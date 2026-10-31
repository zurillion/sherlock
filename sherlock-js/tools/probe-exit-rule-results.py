"""Controlled original DD6E/DD65 ABI: first exit, terminator and retained IY."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
def put(at,v):m[at:at+2]=[v&255,v>>8]
def reg(at,v):r[at]=v>>8;r[at+1]=v&255
actor=3;entity=word(m,0x8b70+3*actor)
# Natural room records unchanged; selected actor placement and incoming pointers explicit.
for room in [0,1,12,18,19,25,26,53,64,69,94]:
 # The exported source layout carries room identities, not a live-memory fallback.
 layout=json.loads((p/'sherlock-js/data/game.json').read_text())['randomInputs']['worldLayout']['rooms'][room]
 exits=[];at=layout['start']+9
 while memory[at]!=255:exits.append([memory[at],memory[at+1],memory[at+2]]);at+=3
 targets=sorted(set([0,12,26,69,114]+[e[2]for e in exits]))
 for target in targets:
  for supplied in [(0,0),(0x2468,0x1357),(65535,65535)]:
   for variation in ['original','first-match-invalid','duplicate-later-valid']:
    m[:]=memory;r[:]=registers;put(0xa017,entity);m[0xa036]=actor;m[entity]=1;m[entity+1]=255;m[entity+15]=room;m[0xa034]=target
    if variation!='original':
     if len(exits)<2:continue
     m[layout['start']+9:layout['start']+15]=[11,0,target,1,0,target]
     if variation=='first-match-invalid':m[layout['start']+12]=12
    put(0xcb28,supplied[0]);put(0xcb2a,supplied[1]);reg(R.IXh,supplied[0]);reg(R.IYh,0xdd61);reg(R.H,0xdd6e)
    before=dict(pointers=list(supplied),exits=[list(m[a:a+3])for a in range(layout['start']+9,at,3)])
    result=w.call(0xcb34);after=dict(pointers=[word(m,0xcb28),word(m,0xcb2a)],success=not result['z'])
    body=None
    if not result['z']:
     reg(R.H,0xdd65);out=w.call(0xcb2c);body=dict(pointers=[word(m,0xcb28),word(m,0xcb2a)],success=not out['z'],direction=m[0x9fd7])
    cases.append(dict(actor=actor,room=room,target=target,variation=variation,before=before,after=after,body=body))
root=p/'sherlock-js/results/rule-result-lifetime';root.mkdir(exist_ok=True);(root/'exit-controls.json').write_text(json.dumps(dict(protocol='Controlled original CB34 predicate DD6E and successful CB2C body DD65; actor3 explicitly placed in11 rooms, all outgoing targets plus missing targets,3 incoming result pairs. Source room records unchanged in original cases; separately labelled duplicate/invalid-direction mutations exercise first-match rejection. Original opcodes unchanged. ABI proof, not natural gameplay.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
