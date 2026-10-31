"""Fresh unpatched full original state immediately before the next unsupported minute."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None
# Original code unchanged. Only draw observations; full state collected at4229.
def observe(m,r,R):
 global draw
 pc=r[R.PC]
 if pc==0xd2ad:draw=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
 if draw is not None and pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
 if draw is not None and pc==0xd2ec:
  a=r[R.A];draw.update(result=abs(a if a<128 else a-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
w.observer=observe
for command in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while out.get('running')and w.clock()['tick']<4229:
  if w.clock()['tick']<=4221:draws.clear()
  out=g.continue_command(out['job'])
 if w.clock()['tick']<=4221:draws.clear()
 print(w.clock()['label'],flush=True)
 if w.clock()['tick']>=4229:break
assert w.clock()['tick']==4229
row=dict(input=None,after=snapshot(w),running=bool(out.get('running')),random=draws,literal=word(m,0xa02f),case_ready=bool(m[0x9e88]),ending=w.ended)
root=p/'sherlock-js/results/rule-result-lifetime';(root/'boundary-state.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Fresh original seed1/all24 actors/freeLOOK/native graphics off/injected uppercase/immediate MORE. Unpatched world; full snapshot at tick4229, draw/read segment after4221. Offline oracle only.',step=row),separators=(',',':')).encode(),mtime=0));print('complete',len(draws),flush=True)
