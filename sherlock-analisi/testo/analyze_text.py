"""Estrazione e verifica del testo contro le routine Z80 originali.
Nessuna modifica ai nastri. Eseguire con python3 -B analyze_text.py.
"""
from pathlib import Path
import sys, json, collections
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[1]
KIT=ROOT/'skoolkit-10.1'
sys.path.insert(0,str(KIT)); sys.dont_write_bytecode=True
from skoolkit.snapshot import Snapshot, get_snapshot, write_snapshot
from skoolkit.simulator import Simulator
from skoolkit.simutils import from_snapshot,get_registers,get_state,A,F,B,C,D,E,H,L,IXh,IXl,SP,PC
BASE=0x5DBF
snapshot=Snapshot.get(str(OUT.parent/'startup.z80'))
sim=from_snapshot(Simulator,snapshot)
original=sim.memory[:]
def word(m,a): return m[a] | m[a+1]<<8
m=original
end=BASE+word(m,0x5DBE)
# Ultimo byte prima della tabella delle parole frequenti: marcatore zero.
assert end==0x67B7 and m[end-1]==0
groups={word(m,0x5D80+2*i):chr(0x60+i) for i in range(1,27)}
rows=[]; p=BASE+1; prev=''; initial=''
while p<end-1:
    offset=p-BASE
    if offset in groups: initial=groups[offset];prev=''
    flags,descriptor=m[p:p+2]
    prefix=(descriptor>>4)&7; count=descriptor&15
    start=p+2+(2 if descriptor&128 else 0)
    size=(count*5+7)//8
    bits=int.from_bytes(bytes(m[start:start+size]),'big')
    tail=''.join(chr(0x60+((bits>>(size*8-5*(i+1)))&31)) for i in range(count))
    assert prefix<=len(prev),(hex(p),prefix,prev)
    stem=prev[:prefix]+tail
    nxt=start+size
    rows.append(dict(offset=f'{offset:03X}',address=f'{p:04X}',stem=initial+stem,
                     flags=f'{flags:02X}',suffix=flags&15,prefix=prefix,tail=tail,
                     descriptor=f'{descriptor:02X}',extra=bytes(m[p+2:start]).hex(),
                     packed=bytes(m[start:nxt]).hex(),next_address=f'{nxt:04X}',
                     group=initial,remainder=stem,previous_remainder=prev))
    prev=stem;p=nxt
assert p==end-1
by_offset={int(row['offset'],16):row for row in rows}
suffixes=[]
for i in range(9): suffixes.append(bytes(m[0xA85C+4*i:0xA860+4*i]).split(b'\0')[0])
def morph(row):
    text=row['stem']
    if row['suffix']!=15:
        assert row['suffix']<len(suffixes)
        for ch in suffixes[row['suffix']]:
            if ch==8: text=text[:-1]
            else:text+=chr(ch).lower()
    return text

def reset(regs=None):
    sim.memory[:]=original
    sim.registers[:]=get_registers(regs or {},{'iff':0,'im':1},False)
    # Abilita l'output e prepara buffer/cursori per prove isolate.
    sim.memory[0x5C3C]=1;sim.memory[0xA027]=0
    sim.memory[0xA9B5:0xA9B7]=[0x0B,0x5C]
    sim.memory[0xA025]=0;sim.memory[0xA026]=0
    sim.memory[0xC1F5]=36;sim.memory[0xC1F8:0xC1FA]=[0x20,0x50];sim.memory[0xC1FA]=2

def call(address,regs=None,intercept=None,limit=1000000):
    if regs:
        for key,val in regs.items():
            if key in ('A','F','B','C','D','E','H','L'):sim.registers[globals()[key]]=val
            else:
                idx={'HL':H,'DE':D,'BC':B,'IX':IXh}[key]
                sim.registers[idx]=val>>8;sim.registers[idx+1]=val&255
    r=sim.registers;mem=sim.memory
    r[SP]=0x5B80;mem[0x5B80:0x5B82]=[0,0x5B];r[PC]=address
    seen=set()
    for n in range(limit):
        pc=r[PC]
        if pc==0x5B00:return n,seen
        seen.add(pc)
        if intercept and intercept(pc,r,mem):
            sp=r[SP];r[PC]=word(mem,sp);r[SP]=sp+2
        else:sim.opcodes[mem[pc]]()
    raise RuntimeError(f'Instruction limit at {r[PC]:04X}')

# Valida ricostruzione dei record e puntatore finale contro A95B, senza stub.
record_operations=0
for row in rows:
    reset()
    prev=row['previous_remainder'].encode('ascii')
    sim.memory[0x5C42:0x5C42+len(prev)+1]=[*prev,0]
    n,_=call(0xA95B,{'HL':int(row['address'],16)})
    record_operations+=n
    actual=bytes(sim.memory[0x5C42:0x5C62]).split(b'\0')[0].decode('ascii')
    assert actual==row['remainder'],(row,actual)
    assert (sim.registers[H]<<8|sim.registers[L])==int(row['next_address'],16)

# Valida A887 e tutti i contesti di scelta suffisso. Stub SOLO per A9B7:
# cattura il flusso di caratteri, senza eseguire la grafica per queste prove.
word_checks=0
for row in rows:
    for context,subject,other in [(0x50,0,0),(0x40,0,0),(0x10,0,1),(0x10,1,0),
                                   (0x00,1,0),(0x00,0,1),(0x70,0,1)]:
        reset();sim.memory[0xA034]=subject;sim.memory[0xA036]=other
        stream=[]
        def capture(pc,r,mem):
            if pc==0xA9B7:stream.append(r[A]);return True
            return False
        call(0xA887,{'DE':int(row['offset'],16)|(context<<8)},capture)
        actual=''
        for ch in stream:
            if ch==8:actual=actual[:-1]
            else:actual+=chr(ch).lower()
        apply=context==0x40 or (context not in (0x40,0x50) and (subject if context==0x10 else other)!=0)
        expected=' '+(morph(row) if apply else row['stem'])
        assert actual==expected,(row,context,actual,expected)
        word_checks+=1

# Pipeline reale di stampa su bitmap: nessuno stub per A887/A9B7/AA14/C1E1/C2BA/C388.
# Intercettazione soltanto osservativa a C2BA, senza sostituire istruzioni.
reset();visible=[];seen_all=set()
def observe(pc,r,mem):
    if pc==0xC2BA:visible.append(r[A])
    return False
samples=[('sherlock',False),('holmes',False),('watson',False),('carry',True),('go',True),('have',True)]
selected=[]
for stem,inflect in samples:
    row=next(x for x in rows if x['stem']==stem)
    _,seen=call(0xA887,{'DE':int(row['offset'],16)|(0x4000 if inflect else 0x5000)},observe)
    seen_all|=seen;selected.append(dict(stem=stem,offset=row['offset'],inflected=inflect,expected=morph(row) if inflect else stem))
call(0xA9B7,{'A':13},observe)
from types import SimpleNamespace
sim.set_tracer(SimpleNamespace(border=7,outfe=7))
ram,regs,state,machine=get_state(sim)
write_snapshot(str(OUT/'print-demo.z80'),ram,regs,state,machine)
(OUT/'print-demo.txt').write_text(bytes(visible).decode('ascii'))
(OUT/'dictionary.json').write_text(json.dumps(rows,indent=2,ensure_ascii=False)+'\n')
(OUT/'dictionary.txt').write_text('\n'.join(f"${r['offset']}  ${r['address']}  {r['stem']:<18} -> {morph(r):<18} flags=${r['flags']} prefix={r['prefix']}" for r in rows)+'\n')
frequent=[]
for i in range(32):
    off=word(m,0x67B7+2*i)
    frequent.append(dict(token=f'{0x60+i:02X}',offset=f'{off:03X}',stem=by_offset[off]['stem']))
(OUT/'frequent-words.json').write_text(json.dumps(frequent,indent=2)+'\n')
results=dict(dictionary_records=len(rows),dictionary_first='5DC0',dictionary_end_exclusive='67B6',
             trailing_zero='67B6',frequent_table='67B7',record_checks=len(rows),
             record_operations=record_operations,word_context_checks=word_checks,
             suffix_counts=dict(collections.Counter(r['suffix'] for r in rows)),
             suffixes=[s.decode('ascii') for s in suffixes],demo=selected,
             actual_demo=bytes(visible).decode('ascii'),demo_executed_addresses=[f'{p:04X}' for p in sorted(seen_all)])
(OUT/'verification.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps({k:v for k,v in results.items() if k!='demo_executed_addresses'},indent=2))
