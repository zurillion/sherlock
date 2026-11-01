"""Controlled C388/C374 ABI for physical5D15 at distinct entry depths."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for clear in [False,True]:
 for frame in [0x5d16,0x5d18,0x5d1a,0x5d1c,0x5d1e,0x5d20]:
  for descriptor in ([0x5a20]if clear else[0x5c0b,0x5123]):
   for count in ([1]if clear else[3,7]):
    for char in ([32]if clear else[32,111,113,95]):
     for column in range(36):
      m[:]=memory;r[:]=registers;m[0x5d15]=0xaa;x=2+column*7;address=0x5020+x//8;diff=(char-13)&255;flags=84 if clear else 2|8|(diff&128)|(64 if diff==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^diff)&128)else 0)|(1 if char<13 else 0)
      r[R.A]=char;r[R.F]=flags;r[R.B]=count;r[R.C]=x&7;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;entered=[]
      def observe(m,r,R):
       if not entered and r[R.PC]==(0xc374 if clear else 0xc388):
        if clear:r[R.SP]=frame+2;m[frame+2:frame+10]=[0,0,0,0,0,0,8,0]
        else:r[R.SP]=frame;m[frame:frame+2]=[8,0]
        entered.append(True)
      w.observer=observe;w.call(0xc374 if clear else 0xc388);cases.append(dict(clear=clear,frame=frame,descriptor=descriptor,count=count,char=chr(char),column=column,cells={str(a):m[a]for a in range(0x5d0a,0x5d22)}))
root=p/'sherlock-js/results/cab-stack-15';(root/'glyph-abi.json').write_text(json.dumps(dict(protocol='Controlled original C388/C374: six frames16..20,36columns,descriptors5C0B/5123,two counts3/7,space/o/q/underscore. Synthetic C388return0008 is not natural reachability or a real caller return. Distinguish physical5D15 register roles, especially unshifted eighth font row at frame20.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
