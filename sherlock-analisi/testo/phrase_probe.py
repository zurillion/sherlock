"""Esegue una frase originale a $6859, senza sostituire routine di stampa."""
from pathlib import Path
import sys,json
from types import SimpleNamespace
OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(OUT.parents[1]/'skoolkit-10.1'));sys.dont_write_bytecode=True
from skoolkit.snapshot import Snapshot,write_snapshot
from skoolkit.simutils import from_snapshot,get_state,A,H,L,IXh,IXl,SP,PC
from skoolkit.simulator import Simulator
s=from_snapshot(Simulator,Snapshot.get(str(OUT.parent/'startup.z80')))
s.set_tracer(SimpleNamespace(border=7,outfe=7))
m=s.memory;r=s.registers
m[0x5C3C]=1;m[0xA027]=0;m[0xA034]=0;m[0xA036]=0
m[0xA025]=0;m[0xA026]=1;m[0xA851]=0
m[0xA9B5:0xA9B7]=[0x0B,0x5C]
stream=[];tokens=[];word=lambda a:m[a]+256*m[a+1]
def call(pc):
    r[SP]=0x5B80;m[0x5B80:0x5B82]=[0,0x5B];r[PC]=pc
    for n in range(1000000):
        if r[PC]==0x5B00:return
        if r[PC]==0xC2BA:stream.append(r[A])
        if r[PC]==0xA5CD:
            ix=r[IXh]*256+r[IXl];tokens.append({'address':f'{ix:04X}','byte':f'{m[ix]:02X}'})
        s.opcodes[m[r[PC]]]()
    raise RuntimeError(f'Limit at {r[PC]:04X}')
r[H]=0x68;r[L]=0x59
call(0xA5C4)
assert bytes(stream).decode('ascii')=='I do not know the word "'
result={'entry':'A5C4','template':'6859','source_bytes':bytes(m[0x6859:0x6866]).hex(' '),
        'output':bytes(stream).decode('ascii'),'tokens_executed':tokens,
        'conditions':'A034=0 A036=0 A026=1 A027=0 5C3C=1; snapshot startup',
        'scope':'Isolated original template; observational taps only; not an entire gameplay run.'}
r[A]=13;call(0xA9B7)
ram,regs,state,machine=get_state(s)
write_snapshot(str(OUT/'phrase-demo.z80'),ram,regs,state,machine)
(OUT/'phrase-verification.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
