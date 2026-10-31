"""Controlled bottom-row C388 ABI: distinct physical5D23 roles."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for frame in [0x5d36]:
 for supplied_count in [3,7]:
  for char in [32,84,113]:
   for column in range(36):
    m[:]=memory;r[:]=registers;x=2+column*7;shift=x&7;address=0x5020+x//8;descriptor=0x5c0b;count=supplied_count
    difference=(char-13)&255;flags=2|8|(difference&128)|(64 if difference==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^difference)&128)else 0)|(1 if char<13 else 0)
    r[R.A]=char;r[R.F]=flags;r[R.B]=count;r[R.C]=shift;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;entry=[]
    def obs(m,r,R):
     if r[R.PC]==0xc388 and not entry:r[R.SP]=frame;m[frame:frame+2]=[8,0];entry.append(True)
    w.observer=obs;w.call(0xc388);cases.append(dict(frame=frame,char=chr(char),column=column,descriptor=descriptor,count=count,cells={str(a):m[a]for a in range(0x5d18,0x5d30)}))
p.joinpath('sherlock-js/results/glyph-video-low-2a/deeper-frame-abi.json').write_text(json.dumps(dict(protocol='Controlled C388 calls from native boot; synthetic return0008, CP13 flags, supplied frame and BC/DE/HL. Bottom text row5020, all36 columns, frame5D36, two caller counts and three characters; includes all saved scan flags at physical5D2A. No natural-play certificate.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
