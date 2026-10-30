"""Offline natural writers around 5D27, including unchanged stack stores."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;targets=range(0x5d27,0x5d29);old={a:m[a]for a in targets};pending=None;writers={};glyph=None;previous=None;unclassified=[];steps=[];stores=[];reads=[]
def observe(m,r,R):
 global pending,glyph,previous
 pc=r[R.PC];sp=r[R.SP];written=set()
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   record={k:v for k,v in pending.items()if k not in('addresses','after_sp')};record.update(address=f'{at:04X}',value=m[at]);writers[at]=record;written.add(at);stores.append(record)
  stores[:]=stores[-24:]
 for at in targets:
  if m[at]!=old[at]and at not in written:unclassified.append(dict(address=f'{at:04X}',pc=previous,value=m[at],tick=word(m,0x9fdd)))
  old[at]=m[at]
 pending=None
 if pc==0xc388:glyph=dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],screen_address=r[R.H]*256+r[R.L],shift=r[R.C],caller_count=r[R.B],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'))
 push=m[pc]in(0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc)or(m[pc]in(0xdd,0xfd)and m[pc+1]==0xe5)
 lo=sp-2 if push else sp if m[pc]==0xe3 else None
 if lo is not None:
  addresses=[a for a in(lo,lo+1)if a in targets]
  if addresses:pending=dict(addresses=addresses,after_sp=lo,pc=f'{pc:04X}',sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],tick=word(m,0x9fdd),actor=m[0xa036],glyph=glyph)
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in targets:record=dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_store=writers.get(at));reads.append(record);print('READ',record,flush=True)
 previous=f'{pc:04X}'
w.observer=observe
for command in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while out.get('running')and w.clock()['tick']<3481:out=g.continue_command(out['job'])
 steps.append(dict(input=command,clock=w.clock(),cells={f'{a:04X}':m[a]for a in targets},writers={f'{a:04X}':v for a,v in writers.items()},stores=stores[:]));stores.clear();print(command,w.clock()['label'],writers.get(0x5d27),flush=True)
 if w.clock()['tick']>=3481 or w.ended:break
root=p/'sherlock-js/results/glyph-last-row';root.mkdir(exist_ok=True)
(root/'natural-stores.json').write_text(json.dumps(dict(protocol='Natural seed1 major-witness, all24 actor slots, free initial LOOK, original graphics off after boot, uppercase injected keys and immediate MORE. No world/actor patches. Observe PUSH/CALL and EX(SP),HL stores, including identical-value stores; record unclassified value changes separately. Two stack bytes are observed to distinguish roles; this dossier implements only5D27. Offline only.',steps=steps,reads=reads,unclassified_transitions=unclassified),separators=(',',':'))+'\n')
