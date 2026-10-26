"""Offline mixed listing: fact terminator and the shared-door announcement."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0x99f1,0x99fb,'data','Last mutable fact: six-byte prefix and reference terms'),(0x99fb,0x99fc,'data','Immutable fact-table terminator: subject FF'),(0x99fc,0x9a0d,'code','Fact handler and excerpt that modifies 99FA, not the terminator'),(0xbc46,0xbcc9,'code','Three fact scanners: compare subject with FF'),(0xcaf0,0xcb12,'code','Announce shared-object action with anonymous actor FF'),(0xd7fa,0xd7fc,'data','Player semantic-rule header: classes zero, zero duration')]
lines=['; Sherlock: DATA boundaries are established by table readers.'];count=total=0
for start,end,kind,label in regions:
 lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}'];at=start
 while at<end:
  if kind=='code':op,n=disassemble(m,at);count+=1
  else:n=min(8,end-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  assert at+n<=end,(hex(at),op)
  assert bytes(assembler.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<35} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
args.output.mkdir(parents=True,exist_ok=True)
(args.output/'boundaries.asm').write_text('\n'.join(lines)+'\n')
(args.output/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in regions],scope='Known boundaries and excerpts only; byte roundtrip alone does not prove functional equivalence.'),indent=2)+'\n')
print(count,'instructions;',total,'bytes independently reassembled')
