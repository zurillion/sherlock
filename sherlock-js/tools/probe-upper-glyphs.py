import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for frame in [0x5d14,0x5d16,0x5d18,0x5d1a,0x5d1c,0x5d24,0x5d2a]:
 for char in [32,84,113]:
  for column in [0,17,35]:
   m[:]=memory;r[:]=registers;x=2+column*7;shift=x&7;address=0x5020+x//8;descriptor=0x5c0b;count=3
   difference=(char-13)&255;flags=2|8|(difference&128)|(64 if difference==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^difference)&128)else 0)|(1 if char<13 else 0)
   r[R.A]=char;r[R.F]=flags;r[R.B]=count;r[R.C]=shift;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;entry=[]
   def obs(m,r,R):
    if r[R.PC]==0xc388 and not entry:r[R.SP]=frame;m[frame:frame+2]=[8,0];entry.append(True)
   w.observer=obs;w.call(0xc388);cases.append(dict(frame=frame,char=chr(char),column=column,descriptor=descriptor,count=count,cells={str(a):m[a]for a in range(0x5cec,0x5d20)}))
p.joinpath('sherlock-js/test/fixtures/upper-glyph-reference.json').write_text(json.dumps(dict(protocol='Controlled C388 ABI calls from native boot: supplied entry frame, codepoint, CP 0D flags, caller BC count/shift, DE descriptor and screen HL. Synthetic return link 0008. Not natural histories.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
