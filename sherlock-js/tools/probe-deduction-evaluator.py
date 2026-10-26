"""Offline controlled truth-tree probes; these are not natural histories."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;base=w.m[:];regs=w.sim.registers[:];starts=[0x9965,0x9973,0x9981,0x9997,0x99a9,0x99bb,0x99c5,0x99cf,0x99d9,0x99e3,0x99f1]
atoms=[];at=starts[0]
while at<0x99fb:
 atoms.append(at);at+=6 if w.m[at+3]&48 else 4
assert at==0x99fb
cases=[]
for status in [None,128,64,192]:
 for known in [False,True]:
  for start in starts:
   w.m[:]=base;w.sim.registers[:]=regs
   if status is not None:
    for i in range(110):w.m[word(w.m,0x8b70+i*3)+6]=status
   if known:
    for at in atoms:
     if at not in starts:w.m[at+3]|=2
   w.sim.registers[w.R.IXh]=start>>8;w.sim.registers[w.R.IXl]=start&255
   out=w.call(0xbcc9)
   cases.append(dict(root=start,status=status,known=known,proven=out['z'],facts=list(w.m[0x9965:0x99fb])))
(p/'sherlock-js/test/fixtures/deduction-evaluator-reference.json').write_text(json.dumps(dict(protocol='Controlled isolated BCC9 calls; initial source trees; all entity status bits or premise flags patched in both implementations; not a natural playthrough.',cases=cases),separators=(',',':'))+'\n');print(len(cases),'controlled tree evaluations')
