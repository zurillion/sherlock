"""Controlled final C374 clear call: includes the real C377 return-link store."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for frame in [0x5d22,0x5d24,0x5d26,0x5d28,0x5d2a,0x5d2c,0x5d2e,0x5d30]:
 for column in range(36):
  m[:]=memory;r[:]=registers;x=2+column*7;address=0x5020+x//8;r[R.A]=32;r[R.F]=84;r[R.B]=1;r[R.C]=x&7;r[R.H]=address>>8;r[R.L]=address&255;r[R.D]=0x5a;r[R.E]=0x20;entered=[]
  def obs(m,r,R):
   if r[R.PC]==0xc374 and not entered:
    r[R.SP]=frame+2;m[frame+2:frame+10]=[0,0,0,0,0,0,8,0];entered.append(True)
  w.observer=obs;w.call(0xc374);cases.append(dict(frame=frame,column=column,cells={str(a):m[a]for a in range(0x5d18,0x5d30)}))
p.joinpath('sherlock-js/test/fixtures/glyph-address-high-clear-abi.json').write_text(json.dumps(dict(protocol='Controlled C374 final clear iteration: actual CALL C388 writes C377; supplied B1,A32,F54,C shift,HL video,DE5A20. Dummy three saved words and return0008 form the controlled caller. All36 columns,eight frames. No natural-play claim.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
