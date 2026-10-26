"""Offline verified code/data boundaries for WAIT UNTIL."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xa068,0xa0a5,'code','Calendar update, clock display, ENTER poll before actor visits'),(0xddcb,0xddd0,'data','Current and target 12-hour totals, selected AM/PM'),(0xddd0,0xddd4,'data','WAIT UNTIL rule header'),(0xddd4,0xde6f,'code','12-hour target selection and original unsigned cost')]
lines=['; WAIT UNTIL: data is not disassembled.'];count=total=0
for start,end,kind,label in regions:
 lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}'];at=start
 while at<end:
  if kind=='code':op,n=disassemble(m,at);count+=1
  else:n=min(8,end-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  assert at+n<=end,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<35} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
args.output.mkdir(parents=True,exist_ok=True);(args.output/'wait-until.asm').write_text('\n'.join(lines)+'\n');(args.output/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in regions]),indent=2)+'\n');print(count,'instructions;',total,'bytes reassembled')
