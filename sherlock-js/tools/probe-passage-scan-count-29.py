"""Natural stack provenance at 5D29, including unchanged PUSH/CALL writes."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/'brown-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
from native_world import word
targets=range(0x5d20,0x5d2a);pending=None;glyph=None;writers={};stores=[];reads=[];unclassified=[];previous=None;observed=m[0x5d20:0x5d2a];enabled=False;start=None;hail_scopes=[];hail_scope=None
commands=['WAIT UNTIL 11PM','WAIT UNTIL 10AM','WAIT UNTIL 11PM']
# The earlier observer completed the minute containing tick 3377.
# Reacquire the same natural path and validate every tracked byte before
# extending its per-instruction writer history into the next minute.
prior_bytes=(p/'sherlock-js/results/passage-caller-c-22/natural-stores.json').read_bytes()
prior=json.loads(prior_bytes)
handover=None
for row in prior['stores']:
 writers[int(row['address'],16)]=row
def observe(m,r,R):
 global pending,glyph,previous,observed
 pc=r[R.PC];sp=r[R.SP];written=set()
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   row={k:v for k,v in pending.items()if k not in('addresses','after_sp')};row.update(address=f'{at:04X}',value=m[at]);writers[at]=row;stores.append(row);written.add(at)
 values=m[0x5d20:0x5d2a]
 # Compare the contiguous block in C; still classify every changed byte.
 # Pending PUSH/CALL records above are retained even when bytes are identical.
 if values!=observed:
  for i,value in enumerate(values):
   at=0x5d20+i
   if value!=observed[i]and at not in written:unclassified.append(dict(address=f'{at:04X}',pc=f'{previous:04X}' if previous is not None else None,value=value,clock=w.clock()))
  observed=values
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
 previous=pc
def enable():
 global enabled,start,observed,handover
 if not enabled and w.clock()['tick']>=3378:
  observed=m[0x5d20:0x5d2a]
  assert all(m[at]==row["value"] for at,row in writers.items()), w.clock()
  assert w.clock()['tick']==3378 and w.sim.registers[w.R.PC]==0xa074
  handover=dict(pc='A074',bytes=observed,prior_sha256=hashlib.sha256(prior_bytes).hexdigest())
  start=w.clock();w.observer=observe;enabled=True
for c in commands:
 enable();out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and not any(x['address']=='5D29' and x['clock']['tick']>=3469 for x in reads):
  enable();out=g.continue_command(out['job'])
 if any(x['address']=='5D29' and x['clock']['tick']>=3469 for x in reads):break
assert any(x['address']=='5D29' and x['clock']['tick']>=3469 for x in reads)
root=p/'sherlock-js/results/passage-scan-count-29';(root/'natural-stores.json').write_text(json.dumps(dict(protocol='Resume the unmodified Brown prompt. Repeat its WAIT sequence. Reuse classified stores through the minute of tick3377, check all ten original bytes at tick3378, then observe each instruction through the new read. No native state enters JS.',start=start,handover=handover,prior_store_count=len(prior["stores"]),reads=reads,stores=stores,unclassified_transitions=unclassified),separators=(',',':'))+'\n');print(reads,flush=True);print('stores',len(stores),'unclassified',len(unclassified),flush=True)
