from pathlib import Path
import sys,json
from types import SimpleNamespace
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/parser')]
from sherlock_parser import SherlockParser
E=SherlockParser(p);R=E.R;cases=[]
for seed in[0,1,17,255]:
 s=E.audit.from_snapshot(E.audit.Simulator,E.audit.entry);s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255));m=s.memory;r=s.registers;initial=m[0xa021];events=[];changes=[];previous=initial
 for step in range(3000000):
  pc=r[R.PC]
  if m[0xa021]!=previous:changes.append(dict(pc=f'{last:04X}',value=m[0xa021]));previous=m[0xa021]
  if pc in(0xc655,0xc6ba):events.append(dict(pc=f'{pc:04X}',value=r[R.A]))
  if pc==0xa536:break
  if pc==0xc415:r[R.A],r[R.PC]=ord('Y'),0xc41e
  if pc==0xa061:r[R.A]=seed
  last=pc;s.opcodes[m[r[R.PC]]]()
 else:raise RuntimeError('Boot incomplete')
 cases.append(dict(seed=seed,entry=initial,final=m[0xa021],writes=events,changes=changes));print(cases[-1],flush=True)
p.joinpath('sherlock-js/results/argument-check').mkdir(exist_ok=True)
p.joinpath('sherlock-js/results/argument-check/boot-verification.json').write_text(json.dumps(dict(protocol='Complete original snapshot-entry to first editor prompt; graphics enabled; four supplied seeds. Static code scan finds only C655 and C6BA absolute stores; all their executions including same-value writes are observed, plus every value transition. Loaded initial data is distinct from a guessed runtime reset.',cases=cases),indent=2)+'\n')
