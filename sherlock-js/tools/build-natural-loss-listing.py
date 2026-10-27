"""Research-only natural loss source; explicit data/code classification."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[
 (0x9dff,0x9e48,'code','Lestrade encounter with Holmes and Straker'),
 (0x9e6a,0x9e6c,'data','Early loss rule header'),
 (0x9e6c,0x9e85,'code','Straker gate and common terminal'),
 (0x9e85,0x9e87,'data','Case readiness header'),
 (0x9e87,0x9ea2,'code','Unready case: arrest and alternative reports'),
 (0xe932,0xe96e,'data','Lestrade DOMAIN gates, signal waits and relocation'),
 (0xf0a4,0xf0ff,'data','Ffoulkes DOMAIN night programme and signals'),
 (0xab4c,0xab60,'code','Nominal copy followed by another nominal attempt'),
 (0xac24,0xac30,'code','Clear ten-byte nominal workspace'),
 (0xac84,0xaca6,'code','Noun store and relation/qualifier slots'),
 (0xa419,0xa476,'code','Money writes raw digits, uppercase D and shilling slash/dash even off-stage'),
 (0xcc0b,0xcc0e,'data','Current visit failure/request flags'),
 (0xcc37,0xcc78,'code','Prepare current visit flags and visibility'),
 (0xa9b5,0xa9b7,'data','Word workspace cursor'),
 (0xa9b7,0xaa14,'code','Append, backspace, flush and pointer reset'),
 (0xc4e8,0xc4ec,'code','Action verification mode'),
 (0xc53a,0xc53f,'code','Action execution mode'),
 (0xc59a,0xc59e,'code','Rule verification mode'),
 (0xc5f4,0xc5f9,'code','Rule execution mode'),
 (0xc929,0xc989,'code','Actor/object/global action lookup and no-rule failure'),
 (0xca35,0xca3d,'code','Successful announcement mode'),
 (0xa5ad,0xa5b6,'code','Preflight text clears announcement mode'),
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
root=p/'sherlock-js/results/natural-loss';root.mkdir(exist_ok=True)
(root/'natural-loss.asm').write_text('; Offline source evidence. DOMAIN headers and operations are DATA.\n'+'\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=instructions,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l)for a,b,k,l in sorted(regions)]),indent=2)+'\n')
print(instructions,total)
