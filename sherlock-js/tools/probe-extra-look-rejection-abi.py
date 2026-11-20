"""Controlled complete missing-object commands from original Portman Street."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];p=root.parent;sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(gzip.decompress((root/'results/extra-look-wear-scan/post-wear-prompt.json.gz').read_bytes()))
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;rows=[]
for player in [0,1,100]:
 for verb in ['OPEN','CLOSE','TAKE','GET','CARRY','EXAMINE','CLOSELY EXAMINE']:
  for name in ['LARGE OAK DOOR','THICK HEAVY DOOR','PLAIN DOOR','RIPPED NOTE','TORN NOTE','PILE','STREAM']:
   m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);w.ended=None
   m[0x9860]=player
   for ident in [0,1,100]:
    ptr=word(m,0x8b70+ident*3);m[ptr]=1;m[ptr+1]=255;m[ptr+15]=45 if ident==player else 0
   m[0xcc0b]=10;m[0x5d1e:0x5d20]=[165,165];w.input_stack[0x1e:0x20]=[165,165];frames=set()
   def observe(m,r,R):
    if r[R.PC]==0xc388 and m[0xa027]==1:frames.add(r[R.SP])
   w.observer=observe;command=verb+' '+name;out=w.submit(command,g.explored)
   text=' '.join(v.get('text','')for v in out['messages']).strip();eligible=text.startswith('I SEE NO ')
   rows.append(dict(player=player,command=command,text=text,eligible=eligible,cells=list(m[0x5d1e:0x5d20]),frames=sorted(frames),clock=w.clock()))
   if eligible:assert m[0x5d1e:0x5d20]==[165,165],(player,command,text,m[0x5d1e:0x5d20])
(root/'results/extra-look-wear-scan/rejection-abi.json').write_text(json.dumps(dict(protocol='Controlled original complete commands from natural post-WEAR prompt2287. Restore state before each, all NPC slots retained. Set active playable identity0/1/100 at root Portman Street45 (no room prose); failure budget10 and A5 in1E/1F plus editor-stack copy isolate the rejected input. Seven verb forms, seven missing nominal groups with0..2qualifiers. Only I SEE NO errors certify preservation; altered identity/markers are not natural-play claims.',cases=rows),separators=(',',':'))+'\n');print(len(rows),sum(r['eligible']for r in rows),flush=True)
