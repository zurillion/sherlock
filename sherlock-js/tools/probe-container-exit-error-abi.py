"""Original Sherlock1984: offline container-exit AF evidence, error-abi."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];p=root.parent;sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(gzip.decompress((root/'results/container-exit-af/pre-error-prompt.json.gz').read_bytes()))
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;rows=[]
for player in [0,1,100]:
 for verb in ['CLIMB INTO']:
  for name in ['POLICE CAB','CAB','DOOR','PLAIN DOOR','LARGE OAK DOOR','THICK HEAVY DOOR']:
   m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);w.ended=None
   m[0x9860]=player
   for ident in [0,1,100]:
    ptr=word(m,0x8b70+ident*3);m[ptr]=1;m[ptr+1]=255;m[ptr+15]=50 if ident==player else 0
   m[0xcc0b]=10;m[0x5d20:0x5d22]=[165,165];w.input_stack[0x20:0x22]=[165,165];frames=set()
   def observe(m,r,R):
    if r[R.PC]==0xc388 and m[0xa027]==1:frames.add(r[R.SP])
   w.observer=observe;command=verb+' '+name;out=w.submit(command,g.explored)
   text=' '.join(v.get('text','')for v in out['messages']).strip();eligible=text.startswith('I SEE NO ')
   rows.append(dict(player=player,command=command,text=text,eligible=eligible,cells=list(m[0x5d20:0x5d22]),frames=sorted(frames),clock=w.clock()))
   if eligible:assert m[0x5d20:0x5d22]==[165,165],(player,command,text,m[0x5d20:0x5d22])
(root/'results/container-exit-af/error-abi.json').write_text(json.dumps(dict(protocol='Controlled complete CLIMB INTO errors from the original pre-error main-street50 prompt. Three playable identities0/1/100 explicitly installed at root50, other identity rows inactive; failure budget10; A5 in20/21 and editor-stack copies. Six nominal groups with0..2qualifiers. All24 actors retained; recorded clocks show any actor visits in each input. Not a natural-play certificate.',cases=rows),separators=(',',':'))+'\n');print(len(rows),sum(r['eligible']for r in rows),flush=True)

# Preserve the actual identity/location/failure budget; only overlay markers.
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);w.ended=None;w.observer=None
m[0x5d20:0x5d22]=[165,165];w.input_stack[0x20:0x22]=[165,165];before=w.clock();out=w.submit('CLIMB INTO POLICE CAB',g.explored)
assert before==w.clock() and m[0x5d20:0x5d22]==[165,165]
(root/'results/container-exit-af/original-error-marker.json').write_text(json.dumps(dict(protocol='Original pre-error prompt; only A5 markers and editor-stack copies changed. No identity/location/budget changes; all24 actors retained. This is a marker preservation check, not an unmodified natural history.',before=before,after=w.clock(),messages=out['messages'],cells=m[0x5d20:0x5d22]),indent=2)+chr(10))
