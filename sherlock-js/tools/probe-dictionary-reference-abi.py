"""Controlled A887 dictionary-output ABI, separate from natural play."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for visible in(0,1):
 for mode in range(0,0x80,0x10):
  for offset in(0,353,2145,0x9f2):
   m[:]=memory;r[:]=registers;m[0x5c3c]=visible;m[0xa022:0xa024]=[0x56,0x34];value=mode*256+offset;r[R.D]=value>>8;r[R.E]=value&255
   w.call(0xa887);cases.append(dict(visible=bool(visible),mode=mode,offset=offset,value=value,initial=0x3456,final=word(m,0xa022)))
out=p/'sherlock-js/test/fixtures/dictionary-reference-abi.json';out.write_text(json.dumps(dict(protocol='Controlled A887 calls from a natural boot, synthetic return0008; supplied DE, output visibility5C3C and prior A0223456. All8 context tags,4 offsets including zero, both output gates. No natural-play claim.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
