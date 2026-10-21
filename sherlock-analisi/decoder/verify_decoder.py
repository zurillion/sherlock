"""Confronto del decoder Python con esecuzione indipendente del codice Z80.
SkoolKit e necessario soltanto per questa verifica, non per usare il decoder.
"""
from pathlib import Path
import sys,json
from sherlock_text import Decoder,Context,Formatter,DecodeError
ROOT=Path(__file__).resolve().parents[2];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'skoolkit-10.1'));sys.dont_write_bytecode=True
from skoolkit.snapshot import Snapshot
from skoolkit.simulator import Simulator
from skoolkit.simutils import from_snapshot,get_registers,A,H,L,SP,PC

d=Decoder.load(ROOT/'SHERLOCK.TAP')
prior=json.loads((ROOT/'sherlock-analisi/testo/dictionary.json').read_text())
for row in prior:
 w=d.words[int(row['offset'],16)]
 assert w.stem==row['stem'] and w.address==int(row['address'],16) and w.next_address==int(row['next_address'],16)
assert d.render(0x6859,Context(0,0))['text']=='I do not know the word "'
assert d.word_form(0x18B,0x40,Context(0,0))[0]=='carries'
assert d.word_form(0x38D,0x40,Context(0,0))[0]=='goes'
assert d.word_form(0x3DF,0x40,Context(0,0))[0]=='having'
assert d.render(0x67F7)['status']=='symbolic'
assert 'classe temporale' in d.render(0x7D62)['text']
# Blocca versioni/byte invalidi invece di estrarre frasi inventate.
bad=bytearray(d.mem);bad[0x6859:0x685B]=b'\x8f\xff'
try:Decoder(bad).render(0x6859)
except DecodeError:pass
else:raise AssertionError('Riferimento non valido accettato')

s=from_snapshot(Simulator,Snapshot.get(str(ROOT/'sherlock-analisi/startup.z80')))
original=s.memory[:]
addresses=[int(r['address'],16) for r in json.loads((OUT/'estratti/texts.json').read_text())]
checked=[];mismatches=[];skipped=[]
for address in addresses:
 cases=[(0,0,None),(1,1,None)]
 if address==0x7D62:cases += [(0,0,t) for t in range(1,6)]
 for subject,other,time_class in cases:
  py=d.render(address,Context(subject,other,time_class=time_class))
  if py['status']!='decoded':
   skipped.append(address);continue
  s.memory[:]=original;m=s.memory;r=s.registers
  r[:]=get_registers({'HL':address},{'iff':0,'im':1},False)
  m[0x5C3C]=1;m[0xA027]=0;m[0xA034]=subject;m[0xA036]=other
  m[0xA025]=0;m[0xA026]=1;m[0xA851]=0;m[0xA9B5:0xA9B7]=[0x0B,0x5C]
  # Stub del solo canale bitmap: cattura l'output gia formattato, senza
  # decrementare colonne o scorrere. Confronto intenzionalmente senza wrap.
  m[0xC1F5]=255;output=[]
  if time_class is not None:
   hour,ampm={1:(9,'p'),2:(7,'p'),3:(3,'p'),4:(8,'a'),5:(6,'a')}[time_class]
   m[0x9FE0]=hour;m[0x9FE2]=ord(ampm)
  def call(pc):
   r[SP]=0x5B80;m[0x5B80:0x5B82]=[0,0x5B];r[PC]=pc
   for n in range(3000000):
    if r[PC]==0x5B00:return
    if r[PC]==0xC2BA:
     output.append(r[A]);sp=r[SP];r[PC]=m[sp]|m[sp+1]<<8;r[SP]+=2
    else:s.opcodes[m[r[PC]]]()
   raise AssertionError(f'Limite istruzioni ${address:04X}, PC=${r[PC]:04X}')
  call(0xA5C4)
  r[A]=32;call(0xA9B7) # espone l'ultima parola rimasta nel buffer
  actual=bytes(output).decode('ascii').replace('\r','\n').rstrip(' ')
  expected=py['text'].rstrip(' ')
  if actual!=expected:mismatches.append({'address':f'{address:04X}','subject':subject,'other':other,'time_class':time_class,'z80':actual,'python':expected})
  else:checked.append({'address':f'{address:04X}','subject':subject,'other':other})
result={'dictionary_records':len(prior),'phrase_context_comparisons':len(checked)+len(mismatches),'passed':len(checked),
        'mismatches':mismatches,'skipped_dynamic_addresses':sorted(set(f'{a:04X}' for a in skipped)),
        'method':'Interprete e formattatore Z80 originali; solo C2BA sostituita per catturare testo senza bitmap/wrap. Spazi finali del flush normalizzati.'}
(OUT/'verification.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'compared':result['phrase_context_comparisons'],'passed':len(checked),'mismatch_count':len(mismatches),'first_mismatches':mismatches[:3]},ensure_ascii=False,indent=2))
assert not mismatches
