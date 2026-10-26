"""Offline mixed listing of known object-rule and description-search boundaries."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xb6da,0xb77e,'code','Scenery matching and nominal groups'),(0xb77e,0xb77f,'data','Mutable end-of-fragment flag'),(0xb77f,0xb83c,'code','Text-data search reader and two-byte call records'),(0xd2ed,0xd33c,'code','Direct-child bulk, recursive weight, signed overflow clamp'),(0xdca2,0xdcc1,'code','Ordinary TAKE predicate'),(0xdcc1,0xdcc5,'data','TAKE header: class 9, duration 1, predicate DCA2'),(0xdcc5,0xdcd2,'code','Ordinary TAKE body'),(0xdec1,0xdeca,'data','Placement header: classes A/8, duration 1, masks and predicate DED9'),(0xdeca,0xdf02,'code','Placement body and bulk predicate')]
catalog=json.loads((p/'sherlock-js/data/game.json').read_text())['npcPrograms']
def add(start,end,kind,label):
 if any(a<=start and end<=b for a,b,_,_ in regions):return
 assert not any(start<b and end>a for a,b,_,_ in regions),(hex(start),hex(end))
 regions.append((start,end,kind,label))
for name,rule in catalog['rules'].items():
 if name.startswith('object.'):add(int(rule['source'],16),int(rule['bodySource'],16),'data','Rule header: '+name)
for start,end,label in [(0xdea4,0xdeaf,'OPEN body'),(0xdf49,0xdf7e,'EXAMINE and shared inspection'),(0xdf8d,0xdfa7,'Quench or retain burnt note'),(0xdfb8,0xdfe3,'Safe calendar test and terminal branches'),(0xe03a,0xe08d,'Transfer actor identity and context ownership'),(0xe0b1,0xe0e0,'Tuesday stream clue'),(0xe0ed,0xe0f2,'Reveal torn note'),(0xe0ff,0xe104,'Reveal false bottom'),(0xe106,0xe135,'Bookcase discovery and early return'),(0xe13e,0xe16b,'Detailed inspection body and table lookup')]:add(start,end,'code',label)
add(0xe16b,0xe17b,'data','Detailed inspection entity/text table; FF terminator')
for rule in catalog['rules'].values():
 if rule.get('source')not in ['DF7E','DFA7','E0A0','E0E0','E0F2']:continue
 at=rule['program']
 while True:
  op=catalog['instructions'][at];add(int(at,16),int(at,16)+op['size'],'data','Object domain operation: '+op['op'])
  if op['op']=='return.success':break
  at=op['next']
regions.sort()
lines=['; Sherlock: verified excerpts. Rule headers and mutable cells are DATA.'];count=total=0
for start,end,kind,label in regions:
 lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()}: {label}'];at=start
 while at<end:
  if kind=='code':op,n=disassemble(m,at);count+=1
  else:n=min(8,end-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  assert at+n<=end,(hex(at),op)
  assert bytes(assembler.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<35} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
args.output.mkdir(parents=True,exist_ok=True)
(args.output/'object-rules.asm').write_text('\n'.join(lines)+'\n')
(args.output/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=s)for a,b,k,s in regions],scope='Known observed boundaries only; byte identity alone does not establish classification or functional parity.'),indent=2)+'\n')
print(count,'instructions;',total,'bytes independently reassembled')
