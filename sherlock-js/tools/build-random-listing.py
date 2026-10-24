"""Verified mixed listing for immutable RNG input values, not runtime code.

Known subroutine boundaries only; inline working data stays DEFB. Every item
is independently reassembled before it can become an offline entropy asset.
"""
import argparse,sys,json,re
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0x99fc,0x9a7d,'typed fact evaluation handlers'),(0xa0f7,0xa11a,'list navigation'),(0xa11c,0xa24d,'record allocation/release'),
         (0xa2ab,0xa35d,'action rendering'),(0xa360,0xa55d,'arguments, names, money and input'),
         (0xa59f,0xa6d1,'text dispatch'),(0xa6d3,0xa7ea,'choice, calls and arguments'),
         (0xa7eb,0xa851,'name articles and word selection'),(0xa852,0xa85c,'case toggle'),
         (0xb5fc,0xb6d6,'semantic clarification'),(0xb6da,0xb77e,'semantic description selection'),
         (0xb77f,0xb86a,'semantic text token reader'),(0xbb67,0xbf59,'statements and fact evaluation'),
         (0xc0df,0xc0fe,'load-header routine; header data follows'),
         (0xc591,0xc628,'rule argument enumeration'),
         (0xc9bf,0xcaae,'rule preflight and execution'),(0xcaaf,0xcb28,'visibility notifications'),
         (0xe0ed,0xe0f2,'corpse action tail, called by deferred rule E0EB'),
         (0xe0ff,0xe104,'corpse action tail, called by deferred rule E0FD'),
         (0xcb2c,0xcb79,'predicate trampoline and errors'),(0xcb7b,0xcc0b,'request restriction and containment notification')]
lines=['; Entropy source listing. Original bytes are never executed by JavaScript.']
for start,end,label in regions:
 lines+=['',f'    ORG ${start:04X}',f'; CODE: {label}. Runtime-written absolute targets are excluded by the JS exporter.']
 at=start
 while at<end:
  op,n=disassemble(m,at)
  assert at+n<=end,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<35} ; ${at:04X} {m[at:at+n].hex(" ")}');at+=n
for start,end in [(0xa11a,0xa11c),(0xa35d,0xa360),(0xa6d1,0xa6d3),(0xa7ea,0xa7eb),(0xa851,0xa852),(0xb6d6,0xb6da),(0xb77e,0xb77f)]:
 lines+=['',f'    ORG ${start:04X}','; DATA: mutable scratch; explicitly absent from immutable entropy.',
         '    DEFB '+','.join(f'${v:02X}' for v in m[start:end])+f' ; ${start:04X} '+m[start:end].hex(' ')]
# Reachable CPU instructions are another *offline classification* of fixed
# entropy values. Start only at typed rule bodies/predicates and callback-table
# entries; never linear-disassemble an intervening data area.
sys.path.insert(0,str(p/'sherlock-analisi/regole'))
from sherlock_rules import decode_header
catalog=json.loads((p/'sherlock-analisi/locazioni/results/locations.json').read_text())
actions=json.loads((p/'sherlock-analisi/locazioni/results/gameplay-action-inventory.json').read_text())
headers={int(r['rule_pointer'],16) for e in catalog['entities'] for r in e['rules'] if r.get('rule_pointer')}
headers|={int(x['general_rule'],16) for x in actions['models'] if x.get('general_rule')}
domain=json.loads((p/'sherlock-analisi/ai/results/domain-programs.json').read_text())
headers|={int(r['source'],16) for r in domain['rules'].values()}
queue=[]
for address in headers:
 h=decode_header(m,address)
 if h['predicate']:queue.append(int(h['predicate'],16))
 if not h['deferred']:queue.append(int(h['body'],16))
at=0x9c85
while m[at]!=255:queue.append(m[at+1]+256*m[at+2]);at+=3
queue += [m[a]+256*m[a+1] for a in range(0xa55d,0xa59d,2)]
seen={}
while queue:
 at=queue.pop()
 if at in seen or not 0x9a7f<=at<0xf60b:continue
 op,n=disassemble(m,at);assert bytes(asm.assemble(op,at))==m[at:at+n]
 if op.startswith('DEFB'):continue
 seen[at]=(op,n)
 target=re.search(r'\$([0-9A-F]{4})$',op)
 if op.startswith(('CALL ','JP ','JR ','DJNZ ')) and target:queue.append(int(target[1],16))
 if op in ('RET','RETN','RETI') or re.match(r'^(?:JP|JR) (?:\$|\()',op):continue
 queue.append(at+n)
 assert len(seen)<20000
lines+=['','; CODE: statically reachable typed routines. Indirect jumps are not followed.']
previous=None
for at,(op,n) in sorted(seen.items()):
 if at!=previous:lines.append(f'    ORG ${at:04X}')
 lines.append(f'    {op:<35} ; ${at:04X} {m[at:at+n].hex(" ")}');previous=at+n
a.output.write_text('\n'.join(lines)+'\n')
print(len(lines),'verified listing lines')
