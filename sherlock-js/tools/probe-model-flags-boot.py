from pathlib import Path
import sys,json
from types import SimpleNamespace
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/parser')]
from sherlock_parser import SherlockParser
E=SherlockParser(p);R=E.R;cases=[]
for seed in[0,1,17,255]:
 s=E.audit.from_snapshot(E.audit.Simulator,E.audit.entry);s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255));m=s.memory;r=s.registers;initial=list(m[0xa01d:0xa01f]);events=[];player_writes=[];changes=[];previous=initial
 for step in range(3000000):
  pc=r[R.PC]
  if list(m[0xa01d:0xa01f])!=previous:changes.append(dict(pc=f'{last:04X}',value=list(m[0xa01d:0xa01f])));previous=list(m[0xa01d:0xa01f])
  if pc==0xa2e0:events.append(dict(pc='A2E0',value=[r[R.A],m[0xa01e]]))
  if pc==0xa041:player_writes.append(dict(pc='A041',value=r[R.A]))
  if pc==0xa536:break
  if pc==0xc415:r[R.A],r[R.PC]=ord('Y'),0xc41e
  if pc==0xa061:r[R.A]=seed
  last=pc;s.opcodes[m[r[R.PC]]]()
 else:raise RuntimeError('Boot incomplete')
 cases.append(dict(seed=seed,entry=initial,final=list(m[0xa01d:0xa01f]),writes=events,player_writes=player_writes,player_mode=m[0xd6b8],changes=changes));print(cases[-1],flush=True)
p.joinpath('sherlock-js/results/model-flags').mkdir(exist_ok=True)
p.joinpath('sherlock-js/results/model-flags/boot-verification.json').write_text(json.dumps(dict(protocol='Complete original snapshot-entry to first editor prompt; graphics enabled; four supplied seeds. A2E0 stores and both flag value transitions observed. Loaded initial data is distinct from a guessed runtime reset.',cases=cases),indent=2)+'\n')
