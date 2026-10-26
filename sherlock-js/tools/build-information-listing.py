from pathlib import Path
import sys,json
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'));from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0x994d,0x9965,'data','Predicate lexicon'),(0x9965,0x99fc,'data','Proof trees and FF terminator'),(0x99fc,0x9a7d,'code','Deduction consequences'),(0x9a7d,0x9a80,'data','Watson exception table terminator'),(0xba13,0xba20,'data','Statement lookup working fields'),(0xba20,0xba60,'code','Statement dispatch and request cleanup'),(0xba60,0xba67,'data','Watson memory working fields'),(0xba67,0xbf59,'code','Watson acceptance, Lestrade proofs, observation trees, triple rendering'),(0xe686,0xe6bc,'code','Watson recollection selector')]
out=['; Verified typed listing: research only; not executed by JavaScript.'];total=count=0
for start,end,kind,label in regions:
 out.extend(['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}']);at=start
 while at<end:
  if kind=='data':n=min(8,end-at);op='DEFB '+','.join(f'${b:02X}'for b in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=end,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n]
  out.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
root=p/'sherlock-js/results/information';root.mkdir(exist_ok=True);(root/'information.asm').write_text('\n'.join(out)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in regions]),indent=2)+'\n');print(count,total)
