"""Original PAY forms, including missing TO and missing recipient."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['PAY 10D','I'],['PAY','I'],['PAY CABBIE','I'],['PAY WATSON','I'],['PAY 10D','WATSON','I'],['PAY 10D TO','WATSON','I'],['PAY WATSON 10D','I'],['PAY 10D WATSON','I'],['PAY 10D TO WATSON','I'],['PAY 1','I'],['PAY 10D. I','I']]
for commands in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None
 def obs(m,r,R):
  global draw
  pc=r[R.PC]
  if pc==0xd2ad:draw=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
  if draw is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
  if draw is not None and pc==0xd2ec:
   v=r[R.A];draw.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
 w.observer=obs;steps=[]
 for command in commands:
  draws.clear();out=g.command(command);steps.append(dict(input=command,messages=out['messages'],outcome=out['state']['analysis']['outcome'],after=snapshot(w),literal=word(m,0xa02f),random=draws[:]))
 cases.append(dict(steps=steps));print(commands,[(s['after']['clock']['label'],[m['text']for m in s['messages']])for s in steps],flush=True)
root=p/'sherlock-js/results/pay-omitted-to';root.mkdir(exist_ok=True);(root/'native-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Natural seed1, all24 actors, free initial LOOK, original graphics off after boot, uppercase injected keys and immediate MORE. No world patches.',cases=cases),separators=(',',':')).encode(),mtime=0))
