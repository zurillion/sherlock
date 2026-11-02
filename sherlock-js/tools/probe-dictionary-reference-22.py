"""Natural dictionary-reference provenance, including identical original stores."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';saved=json.loads(gzip.decompress((root/'talk-native-prompt.json.gz').read_bytes()));assert saved['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=saved['memory'];w.sim.registers[:]=saved['registers'];w.input_registers=saved['input_registers'];w.input_stack=saved['input_stack'];g.explored=set(saved['explored']);g.last_listed=saved['last_listed'];g.last_analysis=saved['last_analysis'];g.opening_pending=False;g.cached_state=None
pending=None;previous=None;last=None;stores=[];reads=[];unclassified=[];old=word(m,0xa022);enabled=False;start=None;command='';command_rows=[]
def observe(m,r,R):
 global pending,previous,last,old
 pc=r[R.PC];value=word(m,0xa022)
 if pending:
  pending['value']=value;last=pending;stores.append(pending)
 elif value!=old:unclassified.append(dict(pc=f'{previous:04X}',value=value,clock=w.clock(),actor=m[0xa036]))
 old=value;pending=None
 if pc in(0xa88c,0xa8b5):pending=dict(pc=f'{pc:04X}',de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],bc=r[R.B]*256+r[R.C],actor=m[0xa036],clock=w.clock(),command=command,sp=r[R.SP],stack=[f'{word(m,a):04X}'for a in range(r[R.SP],min(r[R.SP]+48,0x5d80),2)])
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in(0xa022,0xa023):reads.append(dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_store=last))
 previous=pc
for command in (root/'to-brown-clues.txt').read_text().splitlines()+['WAIT UNTIL 11PM','WAIT UNTIL 10AM']:
 if not enabled and w.clock()['tick']>=1649:old=word(m,0xa022);start=w.clock();w.observer=observe;enabled=True
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while out.get('running')and not any(r['address']=='A022'and r['clock']['tick']>=2857 for r in reads):out=g.continue_command(out['job'])
 command_rows.append(dict(command=command,clock=w.clock(),reference=word(m,0xa022),stores=len(stores)));print(command_rows[-1],flush=True)
 if any(r['address']=='A022'and r['clock']['tick']>=2857 for r in reads):break
assert any(r['address']=='A022'and r['clock']['tick']>=2857 for r in reads)
target=p/'sherlock-js/results/dictionary-reference-22';(target/'natural-stores.json').write_text(json.dumps(dict(protocol='Complete original Jones conversation prompt restored unchanged; ordinary history, all24actors, output profile unchanged. Observer from tick1649/Tue11:28; A88C/A8B5 stores including equal values and all other value transitions. No RAM/register/PC/actor/proof patches. Earlier writers outside window unclaimed. Offline only.',start=start,commands=command_rows,stores=stores,reads=reads,unclassified_transitions=unclassified),separators=(',',':'))+'\n');print('READS',reads,flush=True);print('STORES',len(stores),'unclassified',len(unclassified),flush=True)
