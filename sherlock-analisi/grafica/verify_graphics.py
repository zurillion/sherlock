"""Confronto indipendente della traduzione Python e del codice macchina originale."""
from pathlib import Path
import hashlib,json,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE))
from sherlock_graphics import Decoder,catalog,Exact
sys.path.insert(0,str(ROOT/'skoolkit-10.1'));sys.dont_write_bytecode=True
from skoolkit.snapshot import Snapshot
from skoolkit.simulator import Simulator
from skoolkit.simutils import from_snapshot,get_registers,SP,PC,IYh,IYl

def main():
 d=Decoder.load(ROOT/'SHERLOCK.TAP')
 s=from_snapshot(Simulator,Snapshot.get(str(ROOT/'sherlock-analisi/startup.z80')))
 original=s.memory[:];results=[]
 for row in catalog(d):
  s.memory[:]=original;m=s.memory;r=s.registers
  # Stato video controllato, uguale nei due interpreti. Nessuna routine stub.
  m[0x4000:0x5800]=[0]*6144;m[0x5800:0x5B00]=[0x38]*768;m[0xF60B]=d.mem[0xF60B]
  r[:]=get_registers({'HL':row['start']},{'iff':0,'im':1},False)
  expected=Exact(m,clear=False);states={}
  for c in row['commands']:
   expected.execute([c])
   if c['kind']!='end':states[c['end']]=bytes(expected.mem[0x4000:0x5B00])
  r[SP]=0x5D7E;m[0x5D7E:0x5D80]=[0,0x5B];r[PC]=0xF3C2
  command_checks=0;min_sp=r[SP];command_mismatches=[]
  for n in range(6000000):
   if r[PC]==0x5B00:break
   if r[PC]==0xF3D4:
    pointer=r[IYh]*256+r[IYl]
    if pointer in states:
     command_checks+=1
     if bytes(m[0x4000:0x5B00])!=states[pointer]:command_mismatches.append(f'{pointer:04X}')
   s.opcodes[m[r[PC]]]()
   min_sp=min(min_sp,r[SP])
  else:raise AssertionError(f"Limite istruzioni, locazione {row['location']}, PC={r[PC]:04X}")
  mismatches=[a for a in range(0x4000,0x5B00) if m[a]!=expected.mem[a]]
  result=dict(location=row['location'],name=row['name'],start=f"{row['start']:04X}",instructions=n,
    command_checks=command_checks,command_mismatches=command_mismatches,minimum_stack_pointer=f'{min_sp:04X}',compared_screen_bytes=6912,mismatches=len(mismatches),
    first_mismatches=[dict(address=f'{a:04X}',z80=m[a],python=expected.mem[a]) for a in mismatches[:10]],
    screen_sha256=hashlib.sha256(bytes(m[0x4000:0x5B00])).hexdigest())
  results.append(result);print(json.dumps(result),flush=True)
 report=dict(method='F3C2 originale, ROM22AA originale, nessuno stub; confronto bitmap e attributi su schermo iniziale vuoto con attributi 0x38.',
   passed=sum(r['mismatches']==0 and not r['command_mismatches'] for r in results),total=len(results),results=results)
 (HERE/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
 assert report['passed']==report['total']
 assert sum(r['command_checks'] for r in results)==sum(len(r['commands'])-1 for r in catalog(d))

if __name__=='__main__':main()
