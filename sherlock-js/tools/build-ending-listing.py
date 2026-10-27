"""Research-only typed listing of terminal decisions, refusal and acknowledgement."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0x9e48,0x9e4a,'data','Companion-ending DOMAIN header'),(0x9e4a,0x9e6a,'code','Watson and Lestrade presence decision'),(0x9e6a,0x9e6c,'data','Straker-ending DOMAIN header'),(0x9e6c,0x9e85,'code','Straker flag, common terminal, acknowledgement and clear'),(0x9e85,0x9e87,'data','Case-readiness DOMAIN header'),(0x9e87,0x9ea2,'code','Major arrest and alternate reports; 9E88 mutable operand'),(0x9ea2,0x9ea4,'data','Arrest-consequences DOMAIN header'),(0x9ea4,0x9ec0,'code','Murder proofs and stolen plans endings'),(0x9fc5,0x9fc9,'data','KILL class-zero header and predicate pointer'),(0x9fc9,0x9fd4,'code','Always-failing KILL predicate and refusal printer'),(0x9a3d,0x9a4b,'code','Innocence conclusion sets case readiness'),(0x9a4b,0x9a7d,'code','Murder conclusions and Mrs Jones removal'),(0xba20,0xba60,'code','Statement request dispatch without loading next operation args'),(0xcca7,0xccc7,'code','Request dispatch before operation argument resolution'),(0xcd82,0xcd95,'code','Request return and commit'),(0xc1fd,0xc240,'code','Lower output always redraws plus cursor'),(0xc306,0xc316,'code','Flash divider cell and wait for key, no MORE counter reset'),(0xa296,0xa2aa,'code','Eighteen unconditional CRs; reset counter after every CR'),(0xdfca,0xdfcc,'data','Basil death DOMAIN header'),(0xdfcc,0xdfe3,'code','Basil already present or arriving'),(0xe4c9,0xe4cb,'data','Train movement DOMAIN header'),(0xe4cb,0xe4fc,'code','Train departure printed before hiding'),(0xef7f,0xef8c,'data','Basil east/east, explicit Holmes encounter and terminal DOMAIN nodes'),(0xb0ac,0xb0c6,'code','Post-ending restart service; web freezes BEFORE this entry')]
result=[];count=total=0
for a,b,kind,label in sorted(regions):
 result+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  result.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}');at+=n;total+=n
root=p/'sherlock-js/results/endings';root.mkdir(exist_ok=True);(root/'endings.asm').write_text('; Original source evidence only. Headers and NPC DOMAIN sequences are DATA.\n'+'\n'.join(result)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l)for a,b,k,l in sorted(regions)]),indent=2)+'\n');print(count,total)
