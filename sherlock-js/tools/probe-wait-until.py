"""Original WAIT UNTIL: minute boundaries, explicit ENTER and pure time cost."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);result=dict(protocol='Seed 1, all 24 actors, free initial LOOK, graphics off, injected uppercase keys, immediate MORE, no idle timeout. Frames pause at A074 before the ENTER poll and actor visits.',cases=[],costs=[])
def game():
 g=Game(p,catalog,seed=1,active_npcs=None);g.world.m[0xa011]=0;return g
cases=[('clock_and_news',[],[('WAIT UNTIL 8:20',None),'I',('WAIT UNTIL 8:23',None),'I']),('enter_interrupt',[],[('WAIT UNTIL 9:00',4),'I',('WAIT UNTIL 8:08',None),'I']),('interrupt_long_target',[],[('WAIT UNTIL 7:00AM',2),'I'])]
# Natural supplied history reaches the interviews without map teleports.
history=(p/'sherlock-js/results/fact-boundary/user-natural-inputs.txt').read_text().splitlines();prefix=[x for x in history if x and not x.startswith('#')][:98]
cases.append(('interrupt_then_pay',[],[('WAIT UNTIL 8:10',2),'PAY 6D TO WATSON','I']))
cases.append(('house_arrivals',prefix,[('WAIT UNTIL 12:02',None),'I']))
for label,prefix,commands in cases:
 g=game();w=g.world;calls=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe
 for c in prefix:g.command(c)
 row=dict(label=label,prefix=prefix,steps=[]);result['cases'].append(row)
 def record(out,command,interrupt=False):
  frame=dict(input=command,running=out.get('running',False),interrupt=interrupt,messages=out['messages'],after=snapshot(w),literal=word(w.m,0xa02f),random=calls[:]);calls.clear();row['steps'].append(frame)
 calls.clear()
 for entry in commands:
  if isinstance(entry,str):record(g.command(entry),entry);continue
  command,stop=entry;out=g.start_command(command);record(out,command);n=1
  while out['running']:
   interrupt=stop is not None and n==stop;out=g.continue_command(out['job'],interrupt=interrupt);record(out,None,interrupt);n+=1
  print(label,command,w.clock()['label'],flush=True)
 args.output.write_text(json.dumps(result,separators=(',',':'))+'\n')
# Isolate the arithmetic routine, with controlled clock/literal fields only.
g=game();w=g.world;base=w.m[:];registers=w.sim.registers[:]
for hour in [1,8,11,12]:
 for minute in [0,30,59]:
  for period in ['am','pm']:
   for target in [0,1,7,8,11,12,13,59]:
    for specified in [None,'am','pm']:
     w.m[:]=base;w.sim.registers[:]=registers
     literal=0x8000|(target<<8)|minute|(0x4000 if specified=='am'else 0)|(64 if specified=='pm'else 0)
     w.engine.put(w.sim,0xa02f,literal);w.m[0x9fdf:0x9fe3]=[minute,hour,0,ord(period[0])]
     out=w.call(0xddd4)
     result['costs'].append(dict(clock=dict(hour=hour,minute=minute,period=period),literal=literal,cost=out['cost']))
args.output.write_text(json.dumps(result,separators=(',',':'))+'\n');print(len(result['costs']),'native time-cost cases')
