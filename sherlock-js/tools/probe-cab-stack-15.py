"""Natural stack provenance at5D15, including unchanged PUSH/CALL writes."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/'portman-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
from native_world import word
targets=range(0x5d14,0x5d17);pending=None;glyph=None;writers={};stores=[];reads=[];unclassified=[];previous=None;old={a:m[a]for a in targets};enabled=False;start=None;hail_scopes=[];hail_scope=None
commands=sum([(root/name).read_text().splitlines()for name in ['open-and-talk.txt','reveal-jones.txt','talk-jones.txt','to-brown-clues.txt']],[])
def observe(m,r,R):
 global pending,glyph,previous,hail_scope
 pc=r[R.PC];sp=r[R.SP];written=set()
 if pc==0xe2cb and m[0xa036]==6 and word(m,0x9fdd)==1513:
  hail_scope=dict(actor=6,entry_sp=sp,min_sp=sp,glyphs=0);hail_scopes.append(hail_scope)
  (p/'sherlock-js/results/cab-stack-15/hail-entry.json.gz').write_bytes(gzip.compress(json.dumps(dict(memory=m[:],registers=r[:],clock=w.clock())).encode()))
 if hail_scope is not None:
  hail_scope['min_sp']=min(hail_scope['min_sp'],sp)
  if pc==0xc388:hail_scope['glyphs']+=1
  if pc==0xe2ed:hail_scope['return_sp']=sp;hail_scope=None
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   row={k:v for k,v in pending.items()if k not in('addresses','after_sp')};row.update(address=f'{at:04X}',value=m[at]);writers[at]=row;stores.append(row);written.add(at)
 for at in targets:
  if m[at]!=old[at]and at not in written:unclassified.append(dict(address=f'{at:04X}',pc=previous,value=m[at],clock=w.clock()))
  old[at]=m[at]
 pending=None
 if pc==0xc388:glyph=dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],screen_address=r[R.H]*256+r[R.L],shift=r[R.C],caller_count=r[R.B],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'))
 push=m[pc]in(0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc)or(m[pc]in(0xdd,0xfd)and m[pc+1]==0xe5)
 lo=sp-2 if push else sp if m[pc]==0xe3 else None
 if lo is not None:
  addresses=[a for a in(lo,lo+1)if a in targets]
  if addresses:pending=dict(addresses=addresses,after_sp=lo,pc=f'{pc:04X}',opcode=m[pc:pc+3],sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],glyph=glyph,actor=m[0xa036],clock=w.clock(),stack=[f'{word(m,a):04X}'for a in range(sp,min(sp+64,0x5d80),2)])
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in targets:reads.append(dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_store=writers.get(at)))
 previous=f'{pc:04X}'
def enable():
 global enabled,start
 if not enabled and w.clock()['tick']>=1459:
  for a in targets:old[a]=m[a]
  start=w.clock();w.observer=observe;enabled=True
for c in commands:
 enable();out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and not any(x['address']=='5D15'for x in reads):
  enable();out=g.continue_command(out['job'])
 if any(x['address']=='5D15'for x in reads):break
assert any(x['address']=='5D15'for x in reads)
root=p/'sherlock-js/results/cab-stack-15';(root/'natural-stores.json').write_text(json.dumps(dict(protocol='Restore complete original talk-native prompt unchanged; ordinary DROP/cab history. Observe instructions from the restored Portman prompt, including identical stack writes. No RAM/register/PC/proof patches; no native state imported into JS. Observation window does not claim earlier last writers.',start=start,reads=reads,stores=stores,unclassified_transitions=unclassified,hail_scopes=hail_scopes),separators=(',',':'))+'\n');print(reads,flush=True);print('stores',len(stores),'unclassified',len(unclassified),flush=True)
