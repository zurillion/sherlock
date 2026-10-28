import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None

def observe(m,r,R):
 global pending
 pc=r[R.PC]
 if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
 if pending is not None and pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
 if pending is not None and pc==0xd2ec:
  v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
w.observer=observe;steps=[]
for c in ['OPEN ALL BUT','I']:
 out=g.command(c);steps.append(dict(input=c,after=snapshot(w),count=m[0xa012],random=draws[:],messages=out['messages']));draws.clear()
p.joinpath('sherlock-js/test/fixtures/empty-exclusion-reference.json').write_text(json.dumps(dict(protocol='Fresh natural seed1, all actors, graphics off after boot, injected input and immediate MORE; no world patches.',steps=steps),separators=(',',':'))+'\n')
