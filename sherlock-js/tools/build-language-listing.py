"""Typed offline language listing, independently assembled byte-for-byte."""
from pathlib import Path
import sys,json
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xaab2,0xaf6b,'code','Grammar, coordination, continuation and ordinary-tail list traversal'),(0xaf6b,0xafb3,'data','Special-token dispatch tables'),(0xafb3,0xb16d,'code','Special-token handlers'),(0xb16d,0xb191,'data','Semantic lookup working fields'),(0xb191,0xb39c,'code','Argument cardinality and candidate iteration'),(0xb39c,0xb39d,'data','ALL lookup flag'),(0xb39d,0xb4a2,'code','Semantic role extraction'),(0xb4a2,0xb4a3,'data','First-argument iterator flag'),(0xb4a3,0xb549,'code','First-argument selection and exclusion traversal'),(0xb549,0xb54a,'data','Second-argument iterator flag'),(0xb54a,0xb5b6,'code','Second-argument selection'),(0xb5b6,0xb5d3,'code','Move ambiguous node to pending list'),(0xb866,0xb86a,'data','Request and quote cursor working fields'),(0xb86a,0xb934,'code','Quote consumption and deferred request allocation'),(0xb934,0xb936,'data','Request-loop working fields'),(0xb936,0xba13,'code','NPC request execution and syntax-node release'),(0xd7fc,0xd897,'code','Player semantic loop and list release'),(0xd898,0xd9c3,'code','Editor, quote closure, capacity and repeat key'),(0xdaef,0xdb64,'code','Numeric time scanner and suffix/period cursor'),(0xdb64,0xdb67,'data','Money fields'),(0xdb67,0xdc13,'code','Currency scanner and rotating decimal accumulator'),(0xe1d6,0xe1d8,'data','TELL rule header'),(0xe1d8,0xe22a,'code','TELL topic lookup')]
out=['; Offline research only. Headers, tables and working cells are DATA.'];total=count=0
for start,end,kind,label in regions:
 out.extend(['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}']);at=start
 while at<end:
  if kind=='data':n=min(8,end-at);op='DEFB '+','.join(f'${b:02X}'for b in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=end,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n]
  out.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
root=p/'sherlock-js/results/language';root.mkdir(exist_ok=True);(root/'language.asm').write_text('\n'.join(out)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in regions]),indent=2)+'\n');print(count,total)
