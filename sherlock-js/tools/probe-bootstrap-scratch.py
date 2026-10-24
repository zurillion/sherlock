"""Controlled name changes verify the renderer's scratch derivation, not a byte lookup table."""
import sys,json
from pathlib import Path
from types import SimpleNamespace
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/parser'));from sherlock_parser import SherlockParser
e=SherlockParser(p);R=e.R;out=[]
for name in ['watson','lestrade','straker','holmes']:
 w=next(w for w in e.audit.decoder.words.values()if w.stem==name);s=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry);m=s.memory;r=s.registers;s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255));at=m[0x8b79]+256*m[0x8b7a];m[at+7:at+9]=[(w.offset|32768)&255,(w.offset|32768)>>8]
 for step in range(3000000):
  pc=r[R.PC]
  if pc==0xa536:break
  if pc==0xc415:r[R.A],r[R.PC]=ord('N'),0xc41e
  if pc==0xa061:r[R.A]=1
  s.opcodes[m[r[R.PC]]]()
 else:raise RuntimeError('Boot did not finish')
 row=dict(name=name,noun=w.offset|32768,scratch={str(a):m[a]for a in [0x5cf5,*range(0x5d00,0x5d07)]});out.append(row);print(json.dumps(row),flush=True)
(p/'sherlock-js/test/fixtures/bootstrap-scratch.json').write_text(json.dumps(out,indent=2)+'\n')
