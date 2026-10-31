"""Controlled C129/C142/C306 state transitions; original instructions unchanged."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;memory=m[:];registers=r[:];cases=[]
for entry in[0xc129,0xc142,0xc306]:
 for mode in[0,1,7]:
  for counter in[0,7,15,255]:
   m[:]=memory;r[:]=registers;m[0xc128]=mode;m[0xa019]=counter;m[0xc1f5]=11;m[0xc1f8:0xc1fa]=[0x2a,0x50];m[0xc1fa]=3
   w.call(entry);cases.append(dict(entry=f'{entry:04X}',before=dict(mode=mode,counter=counter,remaining=11,pointer=0x502a,shift=3),after=dict(mode=m[0xc128],counter=m[0xa019],remaining=m[0xc1f5],pointer=word(m,0xc1f8),shift=m[0xc1fa])))
root=p/'sherlock-js/results/text-window-mode';root.mkdir(exist_ok=True);(root/'control-abi.json').write_text(json.dumps(dict(protocol='Controlled original C129/C142/C306 calls, initial flag0/1/7 and A0190/7/15/255. Cursor supplied as declared. C415 gets immediate SPACE under the standard oracle protocol. No opcode patches; control registers only, not full narrow-mode graphics parity.',cases=cases),indent=2)+'\n');print(len(cases))
