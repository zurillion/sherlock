"""Trace stack writes and random reads on the passive Brown and Camden routes."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
late='--late' in sys.argv[1:]
dawn='--dawn' in sys.argv[1:]
low,end=(0x5d10,0x5d37) if dawn else (0x5d20,0x5d31)
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/('brown-native-prompt.json.gz' if late or dawn else 'talk-native-prompt.json.gz')).read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
from native_world import word
targets=range(low,end);pending=None;glyph=None;writers={};stores=[];reads=[];unclassified=[];previous=None;observed=m[low:end];enabled=False;start=None;hail_scopes=[];hail_scope=None
commands=([] if late else (root/'to-brown-clues.txt').read_text().splitlines())+['WAIT UNTIL 11PM','WAIT UNTIL 10AM','WAIT UNTIL 11PM']
if dawn:
 commands=(p/'sherlock-js/results/brown-to-ending/dawn-route.txt').read_text().splitlines()
if late:
 commands.append('WAIT UNTIL 10AM')
 prior=json.loads((p/'sherlock-js/results/brown-to-ending/first-stack-stores.json').read_bytes())
 for row in prior['stores']:
  writers[int(row['address'],16)]=row
def at_end():
 target,minimum=('5D1A',2682) if dawn else ('5D30',4160) if late else ('5D2A',3560)
 return any(r['address']==target and r['clock']['tick']>=minimum for r in reads)
def observe(m,r,R):
 global pending,glyph,previous,observed
 pc=r[R.PC];sp=r[R.SP];written=set()
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   row={k:v for k,v in pending.items()if k not in('addresses','after_sp')};row.update(address=f'{at:04X}',value=m[at]);writers[at]=row;stores.append(row);written.add(at)
 values=m[low:end]
 # Compare the contiguous block in C; still classify every changed byte.
 # Pending PUSH/CALL records above are retained even when bytes are identical.
 if values!=observed:
  for i,value in enumerate(values):
   at=low+i
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
  if at in targets:
   reads.append(dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_store=writers.get(at)))
   if dawn and at in (0x5d17,0x5d19,0x5d1a): print('READ',reads[-1],flush=True)
 previous=pc
def enable():
 global enabled,start,observed
 if not enabled and w.clock()['tick']>=(3561 if late else 1649):
  observed=m[low:end]
  if late:
   assert w.clock()['tick']==3561 and w.sim.registers[w.R.PC]==0xa074
   assert all(m[at]==row['value'] for at,row in writers.items())
  start=w.clock();w.observer=observe;enabled=True
for c in commands:
 enable();out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and not at_end():
  enable();out=g.continue_command(out['job'])
 if at_end():break
assert at_end()
root = p / 'sherlock-js/results/brown-to-ending'
protocol = (
 'Original Brown prompt and dawn route, through the read of 5D1A.' if dawn else
 'Original Brown route, starting at A074 tick 3561 after matching the tracked cells to the previous trace.' if late else
 'Original Jones-confession prompt and normal input, observed from tick 1649. The trace does not claim earlier writers.'
)
report = dict(protocol=protocol, start=start, reads=reads, stores=stores,
              unclassified_transitions=unclassified)
content = (json.dumps(report, separators=(',', ':')) + '\n').encode()
if dawn:
 (root / 'dawn-stack-stores.json.gz').write_bytes(gzip.compress(content, mtime=0))
else:
 (root / ('late-stack-stores.json' if late else 'first-stack-stores.json')).write_bytes(content)
for row in reads:
 print(row['address'], row['value'], row['clock']['label'], row['actor'])
print('stores', len(stores), 'unclassified', len(unclassified), flush=True)
