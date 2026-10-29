"""Observe actual stack stores, including unchanged bytes, at the 5D1B boundary."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;pending=None;last=None;glyph=None;steps=[];stores=[];reads=[];old=m[0x5d1b];previous=None;unclassified=[]
def obs(m,r,R):
 global pending,last,glyph,old,previous
 pc=r[R.PC];sp=r[R.SP]
 if pending and sp==0x5d1a:
  last={**pending,'value':m[0x5d1b]};stores.append(last);stores[:]=stores[-15:]
 elif m[0x5d1b]!=old:unclassified.append(dict(pc=previous,value=m[0x5d1b],tick=word(m,0x9fdd)))
 old=m[0x5d1b];pending=None
 if pc==0xc388:glyph=dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'))
 if (sp==0x5d1a and m[pc]==0xe3)or sp==0x5d1c and (m[pc]in(0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc)or(m[pc]in(0xdd,0xfd)and m[pc+1]==0xe5)):
  pending=dict(pc=f'{pc:04X}',sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],tick=word(m,0x9fdd),actor=m[0xa036],glyph=glyph)
 if pc in(0xd2cb,0xd2d0):
  address=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if address==0x5d1b:reads.append(dict(address='5D1B',value=m[address],clock=w.clock(),actor=m[0xa036],last_store=last));print('READ',reads[-1],flush=True)
 previous=f'{pc:04X}'
w.observer=obs
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 if c.startswith('WAIT UNTIL'):
  out=g.start_command(c)
  while out['running']and w.clock()['tick']<2731:out=g.continue_command(out['job'])
 else:out=g.command(c)
 steps.append(dict(input=c,clock=w.clock(),value=m[0x5d1b],last_store=last,stores=stores[:]));stores.clear();print(c,w.clock()['label'],last,flush=True)
 if w.clock()['tick']>=2731 or w.ended:break
root=p/'sherlock-js/results/glyph-byte';root.mkdir(exist_ok=True);root.joinpath('natural-stores.json').write_text(json.dumps(dict(protocol='Natural major-witness seed1, all actors, free initial LOOK, graphics off after boot, uppercase injected keys and immediate MORE. Observer after boot captures PUSH/CALL stores from SP5D1C and EX(SP),HL stores at SP5D1A, including identical-value writes; transitions not captured by that rule are separate. No actor/world patches. Offline only.',steps=steps,reads=reads,unclassified_transitions=unclassified),separators=(',',':'))+'\n')
