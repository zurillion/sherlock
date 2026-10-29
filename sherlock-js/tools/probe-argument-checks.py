import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['GET LAMP','PUT LAMP ON YOUR ARMCHAIR','OPEN ALL','I'],['SAY WATSON "HELLO"','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL CAB','CLIMB INTO CAB','SAY CABBIE "GO TO KINGS CROSS ROAD"','WAIT','PAY 6D TO CABBIE','GET OUT','I'],['WAIT UNTIL 8:10AM','I'],['SAY WATSON "WAIT"','WAIT','I'],['OPEN LAMP','GET DAILY CHRONICLE','EXAMINE WATSON','I']]
scenarios += [['EXAMINE WATSON','XYZZY','OPEN DOOR','YOUR','EXAMINE WATSON','WAIT UNTIL 6D','I'],['OPEN YOUR DOOR','OPEN YOUR DOOR','I','CLOSE YOUR DOOR','CLOSE YOUR DOOR','I'],['EXAMINE WATSON','GET DAILY CHRONICLE','I']]
scenarios += [['GET LAMP','PUT LAMP IN WATSON','I']]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;events=[];initial=m[0xa021]
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc in(0xc655,0xc6ba):events.append(dict(pc=f'{pc:04X}',value=r[R.A],actor=m[0xa036],action=m[0xa033],phase=m[0xa00b],args=m[0xa034:0xa036],header=f'{(r[R.IYh]*256+r[R.IYl]):04X}'))
  if pc==0xd2ad:pending=dict(argument_check=m[0xa021],actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=obs;steps=[]
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while True:
   steps.append(dict(input=c,after=snapshot(w),argument_check=m[0xa021],events=events[:],random=draws[:],errors=[x['text']for x in out['messages']if x['kind']=='error'],running=bool(out.get('running'))));events.clear();draws.clear();c=None
   if not out.get('running'):break
   out=g.continue_command(out['job'])
 cases.append(dict(initial=initial,steps=steps));print([(r['input'],r['argument_check'],len(r['events']),len(r['random']))for r in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/argument-check-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Natural fresh seed1 boots, all24 actor slots; free initial LOOK, graphics off after boot, injected uppercase keys and immediate MORE. Every raw A021 store including unchanged writes, every random draw/read and complete states. No world overlays.',cases=cases),separators=(',',':')).encode(),mtime=0))
