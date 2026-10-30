import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['OPEN ALL','CLOSE ALL','I'],['GET LAMP','GIVE LAMP TO WATSON','SAY WATSON "GIVE ME MY LAMP"','I'],['SAY WATSON "HELLO"','I','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','I'],['WAIT UNTIL 8:10AM','I'],['SAY WATSON "WAIT"','WAIT','I'],['OPEN LAMP','GET DAILY CHRONICLE','EXAMINE WATSON','I'],['SAY WATSON "BASIL HAS PLANS"','I'],['GO TO LONDON','LOOK THROUGH YOUR DOOR','I'],['OPEN ALL BUT YOUR DOOR','I'],['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I','I','I']]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;events=[];initial=list(m[0xa01d:0xa01f])
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xa2e0:events.append(dict(pc='A2E0',value=[r[R.A],m[0xa01e]],caller=f'{word(m,r[R.SP]):04X}',model=f'{(r[R.IXh]*256+r[R.IXl]):04X}',actor=m[0xa036]))
  if pc==0xd2ad:pending=dict(model_flags=list(m[0xa01d:0xa01f]),actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=obs;steps=[]
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while True:
   steps.append(dict(input=c,after=snapshot(w),model_flags=list(m[0xa01d:0xa01f]),events=events[:],random=draws[:],errors=[x['text']for x in out['messages']if x['kind']=='error'],running=bool(out.get('running'))));events.clear();draws.clear();c=None
   if not out.get('running'):break
   out=g.continue_command(out['job'])
 cases.append(dict(initial=initial,steps=steps));print([(r['input'],r['model_flags'],len(r['events']),len(r['random']))for r in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/model-flags-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Natural seed1 boots, all24 actors, graphics off after boot; injected uppercase input and immediate MORE. Every A2E0 store includes unchanged writes and the calling return link; both flags at every random draw; full states and live WAIT minutes. No world patches.',cases=cases),separators=(',',':')).encode(),mtime=0))
