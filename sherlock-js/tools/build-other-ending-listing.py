"""Research-only additional endings source; explicit data/code classification."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[
 (0x9921,0x994D,'data','Immutable player DOMAIN programme'),
 (0x9F38,0x9FAB,'data','Global action id / rule pointer table with FF terminator'),
 (0xD3E8,0xD448,'code','Entity naming: literal personal name versus article and dictionary qualifier'),
 (0xDCD2,0xDCFF,'code','Walking predicate: exit lookup before suspended-program restriction'),
 (0xCBA7,0xCBBB,'code','Restriction flag: refusal text and failed action return'),
 (0xDEA4,0xDEAF,'code','OPEN execution body'),
 (0xDFB8,0xDFCA,'code','Safe calendar gate'),
 (0xDFCA,0xDFCC,'data','Safe fatal event DOMAIN header'),
 (0xDFCC,0xDFE3,'code','Basil present / enters terminal selection'),
 (0xBC46,0xBCC9,'code','Proof scans: BE5A atom traversal versus BE72 group traversal'),
 (0xBD51,0xBD7E,'code','Triple lookup through nested atoms'),
 (0xBE5A,0xBE97,'code','Proof atom length and group traversal'),
]

lines=[];instructions=total=0
for a,b,kind,label in sorted(regions):
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);instructions+=1
  assert at+n<=b,(hex(at),op,hex(b))
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');at+=n;total+=n
root=p/'sherlock-js/results/other-endings';root.mkdir(exist_ok=True)
(root/'other-endings.asm').write_text('; Offline source evidence. DOMAIN headers and operations are DATA.\n'+'\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=instructions,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l)for a,b,k,l in sorted(regions)]),indent=2)+'\n')
print(instructions,total)
