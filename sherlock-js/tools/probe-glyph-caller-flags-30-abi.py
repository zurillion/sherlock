"""Controlled C388/C374 ABI for physical5D30 at distinct entry depths."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for clear in [False,True]:
 for frame in [0x5d30,0x5d32,0x5d34,0x5d36,0x5d38,0x5d3a,0x5d3c]:
  for descriptor in ([0x5a20]if clear else[0x5c0b,0x5123]):
   for count in ([1]if clear else[3,7]):
    for char in ([32]if clear else[32,84,113,110]):
     for column in range(36):
      m[:]=memory;r[:]=registers;m[0x5d30]=0xaa;x=2+column*7;address=0x5020+x//8;diff=(char-13)&255;flags=84 if clear else 2|8|(diff&128)|(64 if diff==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^diff)&128)else 0)|(1 if char<13 else 0)
      r[R.A]=char;r[R.F]=flags;r[R.B]=count;r[R.C]=x&7;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;entered=[]
      def observe(m,r,R):
       if not entered and r[R.PC]==(0xc374 if clear else 0xc388):
        if clear:r[R.SP]=frame+2;m[frame+2:frame+10]=[0,0,0,0,0,0,8,0]
        else:r[R.SP]=frame;m[frame:frame+2]=[8,0]
        entered.append(True)
      w.observer=observe;w.call(0xc374 if clear else 0xc388);cases.append(dict(clear=clear,frame=frame,descriptor=descriptor,count=count,char=chr(char),column=column,cells={str(a):m[a]for a in[*range(0x5d18,0x5d2b),0x5d30,0x5d31]}))
cp_flags=[]
for code in range(256):
 m[:]=memory;r[:]=registers;r[R.PC]=0xc2c6;r[R.A]=code;r[R.F]=0xff;w.sim.opcodes[m[r[R.PC]]]()
 cp_flags.append(r[R.F])
root=p/'sherlock-js/results/glyph-caller-flags-30';root.mkdir(exist_ok=True);(root/'glyph-abi.json').write_text(json.dumps(dict(protocol='Controlled original C388 and real C374 calls; seven entry depths30..3C,36 columns,descriptors5C0B/5123,two caller counts,four characters. C388 synthetic return0008 is distinct from real C374 CALL returnC377.5D30 initiallyAA; parameters explicit. ABI only, not natural reachability of every frame.',cp_flags=cp_flags,cases=cases),separators=(',',':'))+'\n');print(len(cases),flush=True)
