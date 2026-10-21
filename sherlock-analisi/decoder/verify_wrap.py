"""Confronta gli a capo con il canale video Z80 effettivamente eseguito."""
from pathlib import Path
import sys,json
from sherlock_text import Decoder,Context
OUT=Path(__file__).resolve().parent;ROOT=OUT.parents[1]
sys.path.insert(0,str(ROOT/'skoolkit-10.1'));sys.dont_write_bytecode=True
from skoolkit.snapshot import Snapshot
from skoolkit.simutils import from_snapshot,get_registers,A,SP,PC
from skoolkit.simulator import Simulator
s=from_snapshot(Simulator,Snapshot.get(str(ROOT/'sherlock-analisi/startup.z80')));original=s.memory[:]
d=Decoder.load(ROOT/'SHERLOCK.TAP');results=[]
for address in (0x6859,0x680B,0x693A,0x81B7,0x807A,0x7D62):
 s.memory[:]=original;m=s.memory;r=s.registers;r[:]=get_registers({'HL':address},{'iff':0,'im':1},False)
 for a,v in [(0x5C3C,1),(0xA027,0),(0xA034,0),(0xA036,0),(0xA025,0),(0xA026,1),(0xA851,0),(0xA019,0),(0xC1F5,36),(0x9FE0,8),(0x9FE2,ord('a'))]:m[a]=v
 m[0xA9B5:0xA9B7]=[0x0B,0x5C]
 output=[];last=[None]
 def call(pc):
  r[SP]=0x5B80;m[0x5B80:0x5B82]=[0,0x5B];r[PC]=pc
  for _ in range(3000000):
   if r[PC]==0x5B00:return
   if r[PC]==0xC2BA:last[0]=r[A];output.append(r[A])
   if r[PC]==0xC2CA and last[0]!=13:output.append(13)
   # Osservazione soltanto: nessuna routine sostituita, anche il renderer viene eseguito.
   s.opcodes[m[r[PC]]]()
  raise AssertionError(f'Timeout ${address:04X} PC=${r[PC]:04X}')
 call(0xA5C4);r[A]=32;call(0xA9B7)
 actual=bytes(output).decode('ascii').replace('\r','\n').rstrip(' ')
 expected=d.render(address,Context(0,0,True,36,4))['text'].rstrip(' ')
 results.append({'address':f'{address:04X}','match':actual==expected,'z80':actual,'python':expected})
(OUT/'wrap-verification.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
print('Confronti a 36 colonne:',sum(x['match'] for x in results),'/',len(results))
assert all(x['match'] for x in results),results
