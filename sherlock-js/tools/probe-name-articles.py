"""Controlled article-selection ABI, original A7EB and its immutable tables."""
import sys,json,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];rows=[]
for channel in[0,1]:
 for forced in[0,1]:
  for cls in range(4):
   m[:]=memory;r[:]=registers;m[0xa027]=channel;m[0xa2aa]=forced;r[R.D]=(cls<<4)|1;r[R.E]=0xc5;seen=[]
   def observe(m,r,R):
    if r[R.PC]==0xa809:seen.append(dict(table=r[R.H]*256+r[R.L],article=r[R.D]*256+r[R.E]))
   w.observer=observe;w.call(0xa7eb);assert len(seen)==1;rows.append(dict(channel=channel,forced=forced,noun_class=cls,**seen[0]))
root=p/'sherlock-js/results/murder-ending';(root/'article-abi.json').write_text(json.dumps(dict(protocol='Controlled original A7EB selector: four article classes, both channels and A2AA0/1. Input DE explicitly set; no natural reachability claim. Article reference observed before A809 calls A887.',table_base=0xa24d,table_bytes=memory[0xa24d:0xa25d],table_sha256=hashlib.sha256(bytes(memory[0xa24d:0xa25d])).hexdigest(),cases=rows),indent=2)+'\n');print(rows)
