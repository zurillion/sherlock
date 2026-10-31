"""Observe original A028 writers, qualifier modes at every draw, and natural checkpoints."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
writers={0xa37e,0xa65e,0xa721,0xa72e,0xa73d,0xa798,0xd1d2,0xd536}
scenarios=[['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['OPEN ALL','CLOSE ALL','I'],['GET LAMP','GIVE LAMP TO WATSON','SAY WATSON "GIVE ME MY LAMP"','I'],['SAY WATSON "HELLO"','I','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','I'],['WAIT UNTIL 8:10AM','I'],['HELLO','SAY "HELLO"','SAY WATSON "WAIT"','WAIT','I'],['OPEN LAMP','GET DAILY CHRONICLE','EXAMINE WATSON','I'],['SAY WATSON "BASIL HAS PLANS"','I'],['GO TO LONDON','LOOK THROUGH YOUR DOOR','I'],['OPEN ALL BUT YOUR DOOR','I'],['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I','I','I'],['SAY WATSON "WAIT UNTIL 9AM"','I','PRINT','NOPRINT','@','I'],['TAKE TO','LOOK','SAY WATSON "TAKE TO"','I']]
scenarios=scenarios[:11]+[['WATSON KILLED YOU','I']]
if '--witness' in sys.argv:scenarios=[[c for c in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines()if c and not c.startswith('#')]]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None;pending=None;events=[];unclassified=[];old=m[0xa028];last=None;initial=m[0xa028];protocol_events=[]
 def obs(m,r,R):
  global draw,pending,old,last
  pc=r[R.PC]
  if pending is not None:
   last={**pending,'value':m[0xa028]};events.append(last);pending=None
  elif m[0xa028]!=old:unclassified.append(dict(pc=f'{pc:04X}',value=m[0xa028],tick=word(m,0x9fdd)))
  old=m[0xa028]
  if pc in writers:pending=dict(pc=f'{pc:04X}',a=r[R.A],tick=word(m,0x9fdd),actor=m[0xa036],caller=f'{word(m,r[R.SP]):04X}')
  if pc==0xd2ad:draw=dict(qualifier_mode=m[0xa028],last_store=last,actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
  if draw is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
  if draw is not None and pc==0xd2ec:
   v=r[R.A];draw.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
 w.observer=obs;steps=[];limit=3421
 for command in inputs:
  out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
  while True:
   steps.append(dict(input=command,after=snapshot(w),qualifier_mode=m[0xa028],last_store=last,events=events[:],random=draws[:],running=bool(out.get('running'))));events.clear();draws.clear();command=None
   if not out.get('running')or '--witness'in sys.argv and w.clock()['tick']>=limit:break
   out=g.continue_command(out['job'])
  print(w.clock()['label'],m[0xa028],flush=True)
  if '--witness'in sys.argv and w.clock()['tick']>=limit:break
 cases.append(dict(initial=initial,steps=steps,unclassified_transitions=unclassified,protocol_events=protocol_events))
root=p/'sherlock-js/results/name-qualifier-mode';root.mkdir(exist_ok=True)
name='witness-reference.json.gz'if'--witness'in sys.argv else'name-reference.json.gz'
(root/name).write_bytes(gzip.compress(json.dumps(dict(protocol='Natural seed1, all24 actors, original graphics off after boot, uppercase injected keys and immediate MORE. A028 writers include unchanged stores; qualifier modes at every draw/checkpoint. Editor input bridge does not setA028. No world patches. Offline only.',cases=cases),separators=(',',':')).encode(),mtime=0));print(name,flush=True)
