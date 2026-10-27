"""Offline live waits: very long targets and controlled calendar/tick boundaries."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
catalog=extract(p);cases=[]
scenarios=[dict(command='WAIT UNTIL 0',stop=3),dict(command='WAIT UNTIL 59:59PM',stop=2),dict(command='WAIT UNTIL 12:02AM',setup=dict(day=255,hour=11,minute=58,period='pm')),dict(command='WAIT UNTIL 12:02AM',setup=dict(day=6,hour=11,minute=58,period='pm')),dict(command='WAIT UNTIL 9',setup=dict(day=0,hour=8,minute=0,period='am',tick=65534))]
for setup in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;s=setup.get('setup',{})
 if s:
  m[0x9fdf:0x9fe3]=[s['minute'],s['hour'],s['day'],ord(s['period'][0])]
  if 'tick'in s:w.engine.put(w.sim,0x9fdd,s['tick']);w.engine.put(w.sim,0x9866,s['tick'])
 calls=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[];out=g.start_command(setup['command']);n=1;first=True
 while True:
  steps.append(dict(input=setup['command']if first else None,running=out['running'],after=snapshot(w),random=calls[:],literal=word(m,0xa02f)));calls.clear();first=False
  if not out['running']:break
  out=g.continue_command(out['job'],interrupt=n==setup.get('stop'));steps[-1]['interrupt_next']=n==setup.get('stop');n+=1
  if n>100:raise RuntimeError('Expected short controlled/interrupted wait')
 out=g.command('I');steps.append(dict(input='I',running=False,after=snapshot(w),random=calls[:],literal=word(m,0xa02f)))
 cases.append(dict(setup=s,steps=steps));print(setup,w.clock()['label'],len(steps),flush=True)
(p/'sherlock-js/test/fixtures/calendar-waits-reference.json').write_text(json.dumps(dict(protocol='Seed 1, all 24 actors, free LOOK, original graphics off, uppercase injected keys and immediate MORE. Two natural long-target inputs interrupted by ENTER; other cases explicitly patch calendar/tick counters only.',cases=cases),separators=(',',':'))+'\n')
