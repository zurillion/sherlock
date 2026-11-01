"""Natural first Jones-gate visit: observe unchanged stack writes of the scene."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;targets=range(0x5d00,0x5d10);pending=None;glyph=None;writers={};stores=[];glyphs=[];unclassified=[];old={a:m[a]for a in targets};previous=None
restore=json.loads(gzip.decompress((p/'sherlock-js/results/murder-ending/monday-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest()
m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
commands=(p/'sherlock-js/results/murder-ending/fetch-clothes.txt').read_text().splitlines()+(p/'sherlock-js/results/murder-ending/night-preparation.txt').read_text().splitlines()[:3]

def observe(m,r,R):
 global pending,glyph,previous
 pc=r[R.PC];sp=r[R.SP];written=set()
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   item={k:v for k,v in pending.items()if k not in('addresses','after_sp')};item.update(address=f'{at:04X}',value=m[at]);writers[at]=item;stores.append(item);written.add(at)
 for at in targets:
  if m[at]!=old[at]and at not in written:unclassified.append(dict(address=f'{at:04X}',pc=previous,value=m[at]))
  old[at]=m[at]
 pending=None
 if pc==0xc388:glyph=dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],screen_address=r[R.H]*256+r[R.L],shift=r[R.C],caller_count=r[R.B],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'),stack=[f'{word(m,a):04X}'for a in range(sp,min(sp+80,0x5d80),2)])
 if pc==0xc388:glyphs.append(glyph)
 push=m[pc]in(0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc)or(m[pc]in(0xdd,0xfd)and m[pc+1]==0xe5)
 lo=sp-2 if push else sp if m[pc]==0xe3 else None
 if lo is not None:
  addresses=[a for a in(lo,lo+1)if a in targets]
  if addresses:pending=dict(addresses=addresses,after_sp=lo,pc=f'{pc:04X}',sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],glyph=glyph,actor=m[0xa036],tick=word(m,0x9fdd))
 previous=f'{pc:04X}'
for i,c in enumerate(commands):
 if i==len(commands)-1:
  for a in targets:old[a]=m[a]
  w.observer=observe
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and w.clock()['tick']<250:out=g.continue_command(out['job'])
root=p/'sherlock-js/results/murder-ending';(root/'train-native-stores.json').write_text(json.dumps(dict(protocol='Original seed1/all24/freeLOOK/native graphics off/uppercase injected keys/immediate MORE. Resume complete unmodified Monday prompt, replay fetch and boarding. Instruction observer only WAIT until tick250/Mon12:09. Chained original history, no selective state patch. No world/PC/proof patches.',clock=w.clock(),writers={f'{a:04X}':v for a,v in writers.items()},stores=stores,glyphs=glyphs,unclassified_transitions=unclassified,messages=out['messages']),separators=(',',':'))+'\n');print(w.clock(),writers.get(0x5d06),len(stores),len(unclassified),flush=True)
