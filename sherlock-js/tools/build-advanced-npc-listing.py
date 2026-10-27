"""Typed offline listing; every instruction/data directive independently reassembled."""
from pathlib import Path
import sys,json
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[]
for start,body,end,label in[(0x9a99,0x9a9b,0x9acb,'Police routes'),(0x9acb,0x9acd,0x9ae1,'Fast police travel'),(0x9e48,0x9e4a,0x9e6a,'Case companions'),(0x9e6a,0x9e6c,0x9e85,'Straker knowledge and common terminal'),(0x9e85,0x9e87,0x9ea2,'Case-ready terminal'),(0x9ea2,0x9ea4,0x9ec0,'Arrest proofs'),(0xdfca,0xdfcc,0xdfe3,'Basil terminal'),(0xed39,0xed3b,0xed4b,'Revive policeman'),(0xef9c,0xef9e,0xefac,'Basil scene one'),(0xefac,0xefae,0xefb3,'Basil scene two'),(0xefb3,0xefb5,0xefc7,'Sleeping descriptor'),(0xefc7,0xefc9,0xeff6,'Basil night branch'),(0xf103,0xf105,0xf110,'Policeman knowledge'),(0xf1a8,0xf1aa,0xf1d6,'Major and descriptor helper')]:
 regions.extend([(start,body,'data',label+' header'),(body,end,'code',label)])
for start,end,kind,label in[(0x9c43,0x9c6a,'code','Vehicle arrival and visibility'),(0x9ec0,0x9ec1,'data','Daphne saved room'),(0x9ec1,0x9eca,'code','Daphne rest callback'),(0x9eca,0x9ecb,'data','Cook saved room'),(0x9ecb,0x9ed0,'code','Cook rest callback'),(0x9ed0,0x9ed1,'data','Gardener saved room'),(0x9ed1,0x9f38,'code','Shared rest and restoration'),(0xcc29,0xcc37,'code','Actor scope projection'),(0xd045,0xd04f,'code','Player room scope')]:regions.append((start,end,kind,label))
out=['; Research only. DOMAIN headers and mutable saved-room bytes are DATA.', '; $9E88 is the mutable immediate caseReady operand of LD A,n, not immutable code.'];total=count=0
for start,end,kind,label in sorted(regions):
 out.extend(['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}']);at=start
 while at<end:
  if kind=='data':n=min(8,end-at);op='DEFB '+','.join(f'${b:02X}'for b in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=end,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n]
  out.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
root=p/'sherlock-js/results/advanced-npcs';root.mkdir(exist_ok=True);(root/'advanced-npcs.asm').write_text('\n'.join(out)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,mutable_operand='9E88',regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in sorted(regions)]),indent=2)+'\n');print(count,total)
