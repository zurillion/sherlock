"""Research-only typed source listing; no runtime code or captured state."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[
 (0xaf6b,0xaf9b,'data','Control dictionary identifiers and handler pointers'),
 (0xafff,0xb01c,'code','PRINT presence test and NOPRINT clear before disabling'),
 (0xb09a,0xb0ac,'code','PAUSE key service; LOAD/QUIT pending restart service'),
 (0xb0c6,0xb0e4,'code','SAVE scheduling, one minute, preserve current action'),
 (0xbfd9,0xc03b,'code','Clock advance, midnight day byte and time classes'),
 (0xc3e4,0xc415,'code','Printer receives old top row before scrolling'),
 (0xdd52,0xdd54,'data','Adjacent movement DOMAIN header'),
 (0xdd54,0xdd62,'data','Adjacent movement DOMAIN operations, not Z80'),
 (0xe452,0xe456,'data','FOLLOW/COME WITH class-12 header and predicate'),
 (0xe456,0xe488,'data','FOLLOW deferred DOMAIN program, not Z80'),
 (0xdc19,0xdc20,'data','LOOK THROUGH multioccurrence header'),
 (0xdc20,0xdc6c,'code','LOOK THROUGH temporary relocation and restore'),
 (0xd39b,0xd3d4,'code','Location matching filtered by adjacency'),
 (0xa296,0xa2aa,'code','Eighteen clear CRs, counter reset after each'),
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
root=p/'sherlock-js/results/command-limits';root.mkdir(exist_ok=True)
(root/'commands.asm').write_text('; Offline source evidence. DOMAIN headers and operations are DATA.\n'+'\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=instructions,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l)for a,b,k,l in sorted(regions)]),indent=2)+'\n')
print(instructions,total)
