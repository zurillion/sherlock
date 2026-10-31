"""Controlled original token entries; argument high byte is an entity ID, not A028."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;memory=m[:];registers=r[:];cases=[]
for entry,expected in[(0xa720,0),(0xa72c,1),(0xa73b,1),(0xa793,0),(0xa7ac,1),(0xa7b4,1)]:
 for initial in[0,1,7]:
  m[:]=memory;r[:]=registers;m[0xa028]=initial;m[0xa036]=3;m[0xa034]=3;m[0xa035]=3;m[0xa027]=0;m[0x5c3c]=1;m[0xa59d:0xa59f]=[0,0x5b];m[0x5b00:0x5b02]=[0,3]
  w.call(entry);assert m[0xa028]==expected,(hex(entry),m[0xa028]);cases.append(dict(entry=f'{entry:04X}',initial=initial,expected=expected,argument=0x0300 if entry==0xa7b4 else None))
p.joinpath('sherlock-js/results/name-qualifier-mode/entry-abi.json').write_text(json.dumps(dict(protocol='Controlled original text-token entries, actor/object/otherID3, initial mode0/1/7; argument0300 supplies entityID3 inD. No instruction patches. Observe A028 after the entry; not natural gameplay.',cases=cases),indent=2)+'\n');print(len(cases))
