"""Offline command/calendar cases; original code with explicit printer-port protocol."""
import argparse,inspect,json,sys,textwrap
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
import native_world
# Supply only peripheral input: a connected virtual printer and completed
# printer scans. Original control handlers and display code remain untouched.
src=textwrap.dedent(inspect.getsource(native_world.NativeWorld.iter_submit))
src=src.replace('0xb09d,0xb002,0xb00e,','').replace('0xb0c9,','')
src=src.replace('if pc==0xa074:', '''if pc==0xc040:
                r[R.F]|=1;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xc03b:
                r[R.A]=0 if getattr(self,'printer_connected',True) else 64;r[R.PC]+=2;continue
            if pc==0xc40c:
                r[R.A]=192;r[R.PC]+=2;continue
            if pc==0xa074:''')
scope={};exec(src,native_world.__dict__,scope);native_world.NativeWorld.iter_submit=scope['iter_submit']
scenarios=[dict(commands=c)for c in [
 ['GO TO HALL','GO TO YOUR ROOM','I'],
 ['ENTER HALL','OPEN YOUR DOOR','ENTER HALL','I'],
 ['OPEN YOUR DOOR','GO INTO HALL','I'],
 ['LOOK THROUGH YOUR DOOR','OPEN YOUR DOOR','LOOK THROUGH YOUR DOOR','I'],
 ['LOOK THROUGH LAMP','LOOK THROUGH DOOR','YOUR','I'],
 ['PAY WATSON 6D','PAY 6D TO WATSON','I'],
 ['PAY WATSON `1','I'],
 ['FOLLOW WATSON','I'],['FOLLOW BASIL','I'],['FOLLOW LAMP','I'],['COME WITH WATSON','I'],
 ['PAUSE','I'],['PAUSE. I','I'],['LOOK. PAUSE. LOOK','I'],
 ['PRINT','I','NOPRINT','I'],['PRINT. LOOK','NOPRINT. I'],
 ['GO FURIOUSLY TO HALL','TAKE WATSON TO HALL','I']]]
scenarios.append(dict(setup=dict(printer_connected=False),commands=['PRINT','I','NOPRINT','I']))
for day,hour,minute,period,tick in [(0,11,58,'pm',None),(6,11,58,'pm',None),(255,11,58,'pm',None),(0,11,58,'am',None),(0,8,0,'am',65534)]:
 scenarios.append(dict(setup=dict(day=day,hour=hour,minute=minute,period=period,tick=tick),commands=['I']*4))
scenarios += [dict(commands=c)for c in [['SAVE','I'],['QUIT'],['SAVE. I','I'],['OPEN DOOR','PAUSE','YOUR','I'],['OPEN DOOR','PRINT','YOUR','I'],['OPEN DOOR','SAVE','YOUR','I']]]
scenarios += [dict(commands=['ENTER ROOM','I']),dict(setup=dict(gate_size=1),commands=['OPEN YOUR DOOR','LOOK THROUGH YOUR DOOR','W','I']),dict(setup=dict(parent=24),commands=['OPEN YOUR DOOR','LOOK THROUGH YOUR DOOR','I']),dict(commands=['OPEN YOUR DOOR','SAY WATSON "LOOK THROUGH YOUR DOOR"','I','I'])]
ap=argparse.ArgumentParser();ap.add_argument('--start',type=int,default=0);args=ap.parse_args();target=p/'sherlock-js/test/fixtures/command-limits-reference.json';results=json.loads(target.read_text())['cases'][:args.start]if args.start else [];catalog=extract(p)
for index,s in enumerate(scenarios):
 if index<args.start:continue
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;setup=s.get('setup',{})
 w.printer_connected=setup.get('printer_connected',True)
 if 'gate_size'in setup:m[word(m,0x8b70+3*21)+2]=setup['gate_size']
 if 'parent'in setup:m[word(m,0x8b70)+1]=setup['parent']
 if 'day'in setup:
  m[0x9fdf:0x9fe3]=[setup['minute'],setup['hour'],setup['day'],ord(setup['period'][0])]
  if setup['tick'] is not None:
   w.engine.put(w.sim,0x9fdd,setup['tick']);w.engine.put(w.sim,0x9866,setup['tick'])
 calls=[];pending=None;paper=[]
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xc3e4 and m[0xa008]:paper.append([m[0x4000+256*y+x]for y in range(8)for x in range(32)])
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 for c in s['commands']:
  calls.clear();out=g.finish_command(w.submit(c,g.explored))if c.startswith('SAVE')else g.command(c);steps.append(dict(input=c,messages=out['messages'],after=snapshot(w),outcome=out['state']['analysis']['outcome'],random=calls[:],literal=word(m,0xa02f),printer=bool(m[0xa008]),paper=paper[:]))
  if out['state']['analysis']['outcome']=='tool_limit':break
 results.append(dict(setup=setup,steps=steps));target.write_text(json.dumps(dict(protocol='All 24 actor slots, seed 1, free initial LOOK, graphics off after boot, injected uppercase keys, immediate MORE/PAUSE, no idle timeout. Connected printer ports are an explicit peripheral stub; the absent-printer case is declared. Calendar/tick setups patch only declared counters.',cases=results),separators=(',',':'))+'\n');print(index,[(x['input'],x['outcome'],x['after']['clock']['label'],[m['text']for m in x['messages']if m['text']])for x in steps],flush=True)
