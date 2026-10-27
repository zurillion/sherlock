"""Offline source evidence: typed TELL programmes and related output contracts."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[
(0xE17B,0xE188,'data','Mrs Jones rule header and DOMAIN programme'),
(0xE188,0xE18A,'data','Evidence rule header'),
(0xE18A,0xE1A3,'code','Topic 16/17/67 sets fact 9996 bit 1'),
(0xE1A3,0xE1B2,'data','Tricia rule header and conditional DOMAIN programme'),
(0xE1B2,0xE1B4,'data','Identity reveal rule header'),
(0xE1B4,0xE1D6,'code','Clothes perception, NPC identity change, confession flag'),
(0xE1D6,0xE1D8,'data','Default TELL header'),
(0xE1D8,0xE201,'code','Default topic lookup and spoken reply'),
(0xE03A,0xE08F,'code','General actor identity, direct possessions and context transfer'),
(0xC374,0xC3C0,'code','Row clear and glyph stack residue'),
(0xA2E4,0xA301,'code','Darkness gate for failed-action announcements'),
(0xCC29,0xCC78,'code','Output perception selection'),
(0xA00D,0xA00F,'data','Default word reference, immutable payload'),
(0xCC0C,0xCC0D,'data','Padding between failure count and request flag'),
]
lines=[];total=instructions=0
for a,b,kind,label in sorted(regions):
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);instructions+=1
  assert at+n<=b,(hex(at),op,hex(b))
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');at+=n;total+=n
root=p/'sherlock-js/results/final-solution';root.mkdir(exist_ok=True)
(root/'source.asm').write_text('; Offline source evidence; headers and DOMAIN operations are DATA.\n'+'\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=instructions,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l)for a,b,k,l in sorted(regions)]),indent=2)+'\n')
print(instructions,total)
