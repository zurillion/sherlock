#!/usr/bin/env python3
"""Listato misto del servizio cab: separa e verifica Z80, intestazioni e dati."""
import argparse,json,sys
from pathlib import Path
from cab import extract
sys.dont_write_bytecode=True

def build(project,output):
    p=Path(project);sys.path.insert(0,str(p/'skoolkit-10.1'))
    from skoolkit.traceutils import disassemble
    from skoolkit.z80 import Assembler
    m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();data=extract(p);items={}
    def add(a,n,kind,op):
        if a in items:assert items[a]==(n,kind,op);return
        items[a]=(n,kind,op)
    regions=[(0x9ae3,0x9af4),(0x9af6,0x9b7f),(0x9c07,0x9c41),(0x9c43,0x9c6a),(0xa419,0xa476),(0xe298,0xe2c6),(0xe2cb,0xe328),(0xe32c,0xe370),(0xe374,0xe3ea),(0xe3f3,0xe40a),(0xe413,0xe432),(0xe43b,0xe44c),(0xe4fc,0xe506),(0xe51c,0xe52f),(0xe642,0xe654),(0xe658,0xe66f),(0xe673,0xe686),(0xe6be,0xe6e6),(0xe6ea,0xe70e),(0xe710,0xe72f),(0xf389,0xf3a2)]
    for start,end in regions:
        a=start
        while a<end:
            op,n=disassemble(m,a);assert a+n<=end,(hex(a),op);add(a,n,'Z80',op);a+=n
    for h in data['rules']:
        a=int(h['address'],16);n=h['header_size'];add(a,n,'HEADER','DEFB '+','.join(f'${v:02X}' for v in m[a:a+n]))
    for s in data['scripts']:
        for o in s['instructions']:
            a=int(o['address'],16);n=o['size'];add(a,n,'BYTECODE','DEFB '+','.join(f'${v:02X}' for v in m[a:a+n]))
    for a in range(0x9b7f,0x9c06,3):add(a,3,'ROUTE','DEFB '+','.join(f'${v:02X}' for v in m[a:a+3]))
    for a in (0x9c06,0xe2c6):add(a,1,'DATA',f'DEFB ${m[a]:02X}')
    lines=['; Sherlock v2.0: servizio cab. HEADER, BYTECODE e ROUTE non sono Z80.'];previous=None;assembler=Assembler();total=0
    for a,(n,kind,op) in sorted(items.items()):
        assert previous is None or a>=previous,(hex(a),hex(previous))
        if a!=previous:lines+=['',f'    ORG ${a:04X}']
        assert bytes(assembler.assemble(op,a))==m[a:a+n],hex(a)
        lines.append(f'    {op:<45} ; ${a:04X} {kind} {m[a:a+n].hex(" ")}');previous=a+n;total+=n
    output.mkdir(parents=True,exist_ok=True);(output/'cab.asm').write_text('\n'.join(lines)+'\n')
    result={'roundtrip_equal':True,'bytes_roundtripped':total,'items':len(items),'note':'La ricomposizione verifica i byte, non dimostra da sola la semantica.'};(output/'listing-verification.json').write_text(json.dumps(result,indent=2)+'\n');print(result)
if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();build(a.project,a.output)
