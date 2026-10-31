"""Controlled generic-name formatter calls: original tuples and nonzero modes."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for room in[1,7,10,53]:
 for mode in[0,1,7,128]:
  m[:]=memory;r[:]=registers;m[0x5c3c]=1;m[0xa027]=0;m[0xa028]=mode;m[0xa026]=0;m[0xa025]=0;m[0xa2aa]=0;m[0xa851]=0;m[0xc1f5]=36;m[0xa9b5:0xa9b7]=[0x0b,0x5c];m[0xc1f8:0xc1fa]=[0x20,0x50];m[0xc1fa]=2
  chars=[];name=word(m,0x840b+2*room)+1;r[R.H]=name>>8;r[R.L]=name&255
  def obs(m,r,R):
   if r[R.PC]==0xc2ba:chars.append(r[R.A])
  w.observer=obs;w.call(0xa7ba);w.call(0xa2a2);text=''.join(chr(c)for c in chars if c>=32).strip();cases.append(dict(room=room,mode=mode,after=m[0xa028],text=text))
root=p/'sherlock-js/results/name-qualifier-mode';root.mkdir(exist_ok=True);(root/'name-abi.json').write_text(json.dumps(dict(protocol='Controlled original A7BA/D405 calls with genuine room name tuples, A028=0/1/7/128. Reset formatter cursor and case as declared; original code/data/font unchanged. Check text and persistent mode; no natural-play claim.',cases=cases),indent=2)+'\n');print(cases)
