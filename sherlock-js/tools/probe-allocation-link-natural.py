import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
for inputs in [['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['WAIT UNTIL 8:05AM','I'],['WAIT UNTIL 9:00AM','I'],['SAY WATSON "HELLO"','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL CAB','CLIMB INTO CAB','SAY CABBIE "GO TO KINGS CROSS ROAD"','WAIT','PAY 6D TO CABBIE','GET OUT','I'],['SAY WATSON "WAIT"','WAIT','I'],['SAY WATSON "WAIT UNTIL 8:05AM"','I','WAIT','I']]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(allocation_link=word(m,0xa11a),actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while True:
   steps.append(dict(input=c,after=snapshot(w),allocation_link=word(m,0xa11a),random=draws[:],running=bool(out.get('running')),outcome=out.get('state',{}).get('analysis',{}).get('outcome')));draws.clear();c=None
   if not out.get('running'):break
   out=g.continue_command(out['job'])
 cases.append(steps);print([(x['input'],x['allocation_link'],x['running'])for x in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/allocation-link-natural.json.gz').write_bytes(gzip.compress((json.dumps(dict(protocol='Fresh seed1 per natural command case, all actors, graphics off after boot, injected uppercase keys and immediate MORE; no world patches. Allocation predecessor at every checkpoint and random entry; complete arena, actors, entities, facts, bitmaps and every random draw/read.',cases=cases),separators=(',',':'))+'\n').encode(),mtime=0))
