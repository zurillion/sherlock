"""Controlled C388 descriptor preservation: data arguments, no opcode patches."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for frame in[0x5d32]:
 for descriptor in[0x5c42]:
  for count in[7]:
   for char in range(32,128):
    for column in range(8):
     m[:]=memory;r[:]=registers;x=2+column*7;shift=x&7;address=0x5020+x//8;diff=(char-13)&255;flags=2|8|(diff&128)|(64 if diff==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^diff)&128)else 0)|(1 if char<13 else 0)
     r[R.A]=char;r[R.F]=flags;r[R.B]=count;r[R.C]=shift;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;entry=[]
     def obs(m,r,R):
      if r[R.PC]==0xc388 and not entry:r[R.SP]=frame;m[frame:frame+2]=[8,0];entry.append(True)
     w.observer=obs;w.call(0xc388);cases.append(dict(frame=frame,descriptor=descriptor,count=count,char=chr(char),column=column,cells={str(a):m[a]for a in range(0x5d18,0x5d30)}))
root=p/'sherlock-js/results/glyph-last-row';root.mkdir(exist_ok=True)
(root/'font-abi.json').write_text(json.dumps(dict(protocol='Controlled original C388 calls for all96 original glyphs, eight shifts, frame5D32, DE5C42 and B7. Synthetic return0008 at supplied frame; no opcode or font patches. Check saved raw last font row at5D27, not shifted bitmap or captured zero. Offline ABI evidence, not natural gameplay',cases=cases),separators=(',',':'))+'\n');print(len(cases))
