"""Controlled original movement refusals and their emitted dictionary descriptors."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];p=root.parent;sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(gzip.decompress((root/'results/extra-look-wear-scan/post-wear-prompt.json.gz').read_bytes()))
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;rows=[]
directions=[('N','NORTH'),('S','SOUTH'),('E','EAST'),('W','WEST'),('NE','NORTHEAST'),('NW','NORTHWEST'),('SE','SOUTHEAST'),('SW','SOUTHWEST'),('U','UP'),('D','DOWN')]
for player in [0,1,100]:
 for action,(short,name)in enumerate(directions,1):
  for command in [short,name,'GO '+name]:
   m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);w.ended=None
   m[0x9860]=player
   for ident in [0,1,100]:
    ptr=word(m,0x8b70+ident*3);m[ptr]=1;m[ptr+1]=255;m[ptr+15]=45 if ident==player else 0
   m[0xcc0b]=10;stores=[]
   def observe(m,r,R):
    if r[R.PC]in(0xa88c,0xa8b5)and m[0xa027]==1:
     stores.append(dict(pc=r[R.PC],value=r[R.D]*256+r[R.E]if r[R.PC]==0xa88c else r[R.H]*256+r[R.L],actor=m[0xa036]))
   w.observer=observe;out=w.submit(command,g.explored);text=' '.join(v.get('text','')for v in out['messages']if v.get('kind')=='error').strip()
   rows.append(dict(player=player,action=action,command=command,text=text,stores=stores,descriptor=stores[-1]['value']if stores else None,final_descriptor=word(m,0xa022),clock=w.clock()))
(root/'results/direction-rejection-reference/command-abi.json').write_text(json.dumps(dict(protocol='Controlled complete original inputs from natural post-WEAR prompt2287. Three playable identities overlaid at root Portman Street45; failure budget10; no exits except the closed south door. All24 actors retained. Ten directions, abbreviations, full names and GO forms. Capture actual A88C/A8B5 writes in lower channel separately from any later NPC output. Controlled setups are not natural-play certificates.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
