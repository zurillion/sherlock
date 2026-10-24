"""Diagnose the semantic owners of scratch-stack inputs; never export a RAM fallback."""
import sys,json
from pathlib import Path
from types import SimpleNamespace
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'));sys.path.insert(0,str(p/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
from native_world import word
from explorer import Game
from extract_locations import extract
e=SherlockParser(p);R=e.R;s=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry);m=s.memory;r=s.registers
s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
watched=[0x5cf5,0x5d00];previous={a:m[a]for a in watched};last_pc=0;last_sp=0;writes={};stage='boot'
def observe(m,r,R):
 global last_pc,last_sp
 for a in watched:
  if m[a]!=previous[a]:
   previous[a]=m[a];writes[a]=dict(stage=stage,at=f'{a:04X}',value=m[a],writer=f'{last_pc:04X}',sp=f'{last_sp:04X}',actor=m[0xa036],hl=f'{r[R.H]*256+r[R.L]:04X}',de=f'{r[R.D]*256+r[R.E]:04X}',bc=f'{r[R.B]*256+r[R.C]:04X}',stack=bytes(m[max(0x5cc0,r[R.SP]):0x5d80]).hex(' '),character=r[R.A],buffer=bytes(m[0x5c0b:0x5c42]).decode('latin1'))
 last_pc=r[R.PC];last_sp=r[R.SP]
for step in range(3000000):
 observe(m,r,R);pc=r[R.PC]
 if pc==0xa536:break
 if pc==0xc415:r[R.A],r[R.PC]=ord('N'),0xc41e
 if pc==0xa061:r[R.A]=1
 s.opcodes[m[r[R.PC]]]()
print('BOOT',json.dumps(list(writes.values())),flush=True)
