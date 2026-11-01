"""Controlled article-selection ABI, original A7EB and its immutable tables."""
import sys,json,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];rows=[]
import struct
for ident in sorted(g.entities):
 m[:]=memory;r[:]=registers;m[0xa027]=0;m[0xa2aa]=1;m[0x5c3c]=1;m[0xa9b5:0xa9b7]=[11,92];pointer=m[0x8b70+ident*3]+256*m[0x8b71+ident*3];r[R.IXh]=pointer>>8;r[R.IXl]=pointer&255;events=[]
 def observe(m,r,R):
  if r[R.PC]==0xa9b7:events.append(r[R.A])
 w.observer=observe;w.call(0xd3d5);rows.append(dict(id=ident,raw=events,noun=m[pointer+7]+256*m[pointer+8],attributes=m[pointer+5],status=m[pointer+6]))
root=p/'sherlock-js/results/murder-ending';(root/'entity-name-abi.json').write_text(json.dumps(dict(protocol='Controlled original D3D5: unchanged boot entity records, A0270, A2AA1, visible1, empty word pointer. Record every A9B7 character before normalization. No natural reachability claim.',cases=rows),indent=2)+'\n');print(len(rows))
