"""Rigenera il listing e verifica ogni istruzione/direttiva sul binario."""
from pathlib import Path
import sys,subprocess,re,json
out=Path(__file__).resolve().parent
kit=out.parents[1]/'skoolkit-10.1'
sys.path.insert(0,str(kit));sys.dont_write_bytecode=True
from skoolkit.snapshot import get_snapshot
from skoolkit.z80 import Assembler
with (out/'text.skool').open('w') as f:
 subprocess.run([sys.executable,'-B',str(kit/'sna2skool.py'),'-H','-c',str(out/'text.ctl'),str(out.parent/'game-entry.z80')],stdout=f,check=True)
m=get_snapshot(str(out.parent/'game-entry.z80'));assembler=Assembler();total=0;lines=0
listing=['; Estratti non contigui: ORG esplicito per ogni intervallo.','; Gli indirizzi numerici rimandano alla memoria originale.']
next_address=None
for line in (out/'text.skool').read_text().splitlines():
 match=re.match(r'^[bcgistuw *]\$([0-9A-F]{4})\s+(.+)',line)
 if not match:
  if line.startswith(';') or not line.strip():listing.append(line)
  continue
 address=int(match[1],16);operation=match[2].split(';')[0].strip()
 data=assembler.assemble(operation,address)
 assert data,(hex(address),operation)
 assert bytes(data)==bytes(m[address:address+len(data)]),(hex(address),operation)
 if address!=next_address:listing.append(f'    ORG ${address:04X}')
 comment=match[2].partition(';')[2].strip()
 listing.append(f'    {operation:<22} ; ${address:04X}  '+bytes(data).hex(' ').upper()+(' | '+comment if comment else ''))
 next_address=address+len(data);total+=len(data);lines+=1
(out/'text.asm').write_text('\n'.join(listing)+'\n')
(out/'listing-verification.json').write_text(json.dumps({'statements':lines,'bytes_verified':total,'all_match_snapshot':True},indent=2)+'\n')
print(f'{lines} istruzioni/direttive, {total} byte confrontati con lo snapshot: identici.')
