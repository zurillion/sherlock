"""Original OPEN/CLOSE body ABI: returned IX is the explicit argument pointer."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
def put(at,v):m[at:at+2]=[v&255,v>>8]
for ident in[19,21,50]:
 for action,target in[(36,0xdea4),(14,0xdeb6)]:
  for ix in[0,0x2468,0xffff]:
   for iy in[0,0x1357,0xffff]:
    for attributes in[0,32,255]:
     m[:]=memory;r[:]=registers;pointer=word(m,0x8b70+3*ident);put(0xa013,pointer);put(0xcb28,ix);put(0xcb2a,iy);m[pointer+5]=attributes;r[R.H]=target>>8;r[R.L]=target&255
     result=w.call(0xcb2c);cases.append(dict(entity=ident,action=action,target=f'{target:04X}',before=dict(pointers=[ix,iy],attributes=attributes),after=dict(pointers=[word(m,0xcb28),word(m,0xcb2a)],attributes=m[pointer+5],success=not result['z'])))
root=p/'sherlock-js/results/rule-registers';(root/'ordinary-controls.json').write_text(json.dumps(dict(protocol='Controlled CB2C calls to original DEA4/DEB6 bodies. Explicit descriptor A013; IX0/2468/FFFF, IY0/1357/FFFF, attributes0/32/255, three ordinary door descriptors. Body ABI only: bypassed masks do not imply arbitrary objects can be opened in play.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
