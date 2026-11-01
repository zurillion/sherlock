"""Controlled original upper-channel raw separator; all36 cursor columns."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];rows=[]
for col in range(36):
 m[:]=memory;r[:]=registers;m[0xc128]=0;m[0xa019]=0;x=2+7*col;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-col;m[0x5d08:0x5d32]=[0xa5]*42;r[R.A]=32;r[R.F]=0x93;r[R.D]=0x45;r[R.E]=0x0b;entered=[];glyphs=[]
 def observe(m,r,R):
  if r[R.PC]==0xc2ba and not entered:r[R.SP]=0x5d30;m[0x5d30:0x5d32]=[8,0];entered.append(True)
  if r[R.PC]==0xc388:glyphs.append(dict(frame=r[R.SP],descriptor=r[R.D]*256+r[R.E],column_address=r[R.H]*256+r[R.L],shift=r[R.C]))
 w.observer=observe;w.call(0xc2ba);rows.append(dict(column=col,cells={str(a):m[a]for a in range(0x5d08,0x5d30)},glyphs=glyphs))
root=p/'sherlock-js/results/murder-ending';(root/'root-space-abi.json').write_text(json.dumps(dict(protocol='Controlled original C2BA raw space, entrySP5D30 and descriptor450B. Every column0..35, C128wide, counter0, owned-cell markerA5. Synthetic return0008 is not a real caller return proof. Compare stack effects only; no natural reachability claim.',cases=rows),separators=(',',':'))+'\n');print(len(rows))
