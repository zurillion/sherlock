#!/usr/bin/env python3
import sys,json
from pathlib import Path
from types import SimpleNamespace
def boot(project,seed=1,graphics=False):
 sys.path.insert(0,str(Path(project)/'sherlock-analisi/parser'))
 from sherlock_parser import SherlockParser
 e=SherlockParser(project);R=e.R;s=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry)
 s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255));m,r=s.memory,s.registers;calls=[];pending=None;refresh=[]
 for step in range(3000000):
  pc=r[R.PC]
  if pc==0xa536:break
  if pc==0xc415:r[R.A],r[R.PC]=ord('Y' if graphics and m[r[R.SP]]+256*m[r[R.SP]+1]==0xa051 else 'N'),0xc41e
  if pc==0xa061:r[R.A]=seed
  if m[pc:pc+2]==[237,95]:refresh.append(f'{pc:04X}')
  if pc==0xd2ad:
   pending={'caller':f'{m[r[R.SP]]+256*m[r[R.SP]+1]:04X}','arg':r[R.A],'de':r[R.D]*256+r[R.E],'seed':m[0xa037],'cursor':m[0xa039]+256*m[0xa03a],'reads':[]};calls.append(pending)
  if pending and pc in (0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append([f'{at:04X}',m[at]])
  if pending and pc==0xd2ec:pending.update(output=r[R.A],next_seed=m[0xa037],next_cursor=m[0xa039]+256*m[0xa03a]);pending=None
  s.opcodes[m[r[R.PC]]]()
 else:raise RuntimeError(hex(r[R.PC]))
 return e,s,{'seed':seed,'graphics':graphics,'calls':calls,'refresh':refresh,'steps':step}
if __name__=='__main__':
 import argparse
 ap=argparse.ArgumentParser(description='Trace the original RNG during a true boot, before the first prompt.')
 ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--seed',type=int,default=1);ap.add_argument('--output',type=Path)
 a=ap.parse_args()
 if not 0<=a.seed<=255:ap.error('seed must be 0..255')
 results=[boot(a.project,a.seed,graphics)[2] for graphics in (False,True)]
 text=json.dumps(results,indent=2)+'\n'
 if a.output:a.output.write_text(text)
 else:print(text)
