"""Controlled original A2BD decoder for all 54 action records and nibble vectors."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
vectors=[(i+1,0x8259+i*8,list(m[0x8259+i*8:0x8261+i*8]))for i in range(54)]
for flags in range(256):
 modes=(flags*73+19)&255
 vectors.append((None,0x8000,[0x37,((flags&15)<<4)|5,0x28,(flags&240)|6,0x19,((modes&15)<<4)|7,0x0a,(modes&240)|8]))
for action,at,raw in vectors:
 m[:]=memory;r[:]=registers;m[at:at+8]=raw;r[R.IXh],r[R.IXl]=at>>8,at&255;m[0xa01d:0xa01f]=[73,91];w.call(0xa2bd);flags=list(m[0xa01d:0xa01f]);w.call(0xc493);w.call(0xc4b2)
 cases.append(dict(action=action,raw=raw,flags=flags,classes=list(m[0xa00f:0xa011])))
root=p/'sherlock-js/results/model-flags';root.mkdir(exist_ok=True)
(root/'abi.json').write_text(json.dumps(dict(protocol='Controlled original A2BD, C493 and C4B2 calls from native boot. All54 immutable action models plus256 synthetic eight-byte DATA records at8000 (no opcode patches); nonzero lexical low nibbles. Not natural play.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
