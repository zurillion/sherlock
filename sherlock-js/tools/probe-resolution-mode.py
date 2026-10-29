import sys,json,gzip,inspect,textwrap
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
import native_world
src=textwrap.dedent(inspect.getsource(native_world.NativeWorld.iter_submit)).replace('0xb09d,0xb002,0xb00e,','').replace('0xb0c9,','')
src=src.replace('if pc==0xa074:', """if pc==0xc040:
                r[R.F]|=1;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xc03b:
                r[R.A]=0;r[R.PC]+=2;continue
            if pc==0xc40c:
                r[R.A]=192;r[R.PC]+=2;continue
            if pc==0xa074:""")
scope={};exec(src,native_world.__dict__,scope);native_world.NativeWorld.iter_submit=scope['iter_submit']
catalog=extract(p);cases=[]
scenarios=[['I','@','@','I'],['XYZZY','@','I'],['OPEN DOOR','@','YOUR','I'],['SAY WATSON "BASIL HAS PLANS HE IS INNOCENT"','I'],['SAY WATSON "BASIL HAS PLANS AND HE IS INNOCENT"','I'],['SAY WATSON "BASIL HAS PLANS THAT HAD PLANS"','I'],['SAY WATSON "BASIL HAS PLANS IT IS INNOCENT"','I'],['LOOK','I','WAIT UNTIL 8:05AM'],['OPEN YOUR DOOR AND PLAIN DOOR','LOOK AND LOOK','I'],['OPEN ALL BUT YOUR DOOR','OPEN ALL BUT YOUR DOOR AND PLAIN DOOR','I'],['OPEN DOOR','YOUR','SAVE','I'],['OPEN DOOR','YOUR AND PLAIN','I'],['SAY WATSON "MAJOR VISIT OPIUM DEN AND MAJOR IS INNOCENT"','I'],['SAY WATSON "HE IS INNOCENT"','I'],['SAY WATSON "BASIL HAS PLANS, THAT HAD PLANS"','I'],['LOOK. THE. I','I'],['XYZZY','I'],['PAUSE','I'],['OPEN DOOR','SAVE','YOUR','I'],['PRINT','NOPRINT','I'],['LOOK AND OPEN LAMP','I'],['SAY WATSON ""','I'],['SAY WATSON "THE"','I'],['OPEN ALL BUT','I'],['OPEN DOOR','ALL BUT YOUR DOOR','I']]
scenarios += [['OPEN ALL AND ALL','I'],['OPEN ALL AND CLOSE ALL','I'],['OPEN ALL AND OPEN BUT YOUR DOOR','I'],['OPEN ALL BUT YOUR DOOR BUT PLAIN DOOR','I'],['OPEN ALL. CLOSE ALL','I'],['OPEN ALL BUT YOUR DOOR. XYZZY','I'],['OPEN DOOR','ALL','I'],['SAY WATSON "OPEN ALL BUT YOUR DOOR"','I'],['SAY WATSON ""','OPEN ALL','XYZZY','@','I']]
scenarios += [['OPEN','YOUR DOOR','I'],['OPEN DOOR','XYZZY','YOUR','I'],['PUT MONEY IN ARMCHAIR','YOUR','I'],['PUT MONEY INTO ARMCHAIR','WATSONS','I'],['SAY "HELLO"','WATSON','I'],['OPEN DOOR','PAUSE','YOUR','I'],['OPEN DOOR','PRINT','YOUR','I'],['OPEN DOOR','NOPRINT','YOUR','I'],['OPEN DOOR','THE','YOUR','I'],['OPEN DOOR','I','YOUR','I']]
scenarios += [['TAKE','LAMP','I'],['EXAMINE','LAMP','I'],['HAIL','CAB','I'],['CLOSE','DOOR','YOUR','I'],['CLIMB OUT','CAB','I'],['GET LAMP','GIVE LAMP TO','WATSON','I'],['SAY WATSON "OPEN DOOR"','I'],['OPEN DOOR','','YOUR','I'],['OPEN DOOR','.','YOUR','I'],['TELL WATSON ABOUT ARMCHAIR','YOUR','I']]
scenarios += [['CLIMB INTO ALL','GET OUT','I'],['HAIL ALL','I'],['OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL ALL','I'],['SAY WATSON "CLIMB INTO ALL"','I'],['OPEN ALL','XYZZY','@','I']]
scenarios += [['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I','I','I']]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;events=[];steps=[];draws=[];pending=None
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc in(0xd800,0xb1ec,0xb1fd,0xb959):events.append(dict(pc=f'{pc:04X}',value=r[R.A],actor=m[0xa036]))
  if pc==0xd2ad:pending=dict(resolution_mode=m[0xa01c],player_mode=m[0xd6b8],actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 g.persistence_control=lambda text:None;w.observer=obs
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while out.get('running'):out=g.continue_command(out['job'])
  steps.append(dict(input=c,resolution_mode=m[0xa01c],player_mode=m[0xd6b8],events=events[:],random=draws[:],after=snapshot(w),errors=[v['text']for v in out['messages']if v['kind']=='error'],outcome=out['state']['analysis']['outcome']));events.clear();draws.clear()
 cases.append(steps);print([(s['input'],s['resolution_mode'],s['player_mode'],len(s['events']))for s in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/resolution-mode.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Fresh seed1 natural boots, all24 actor slots, original graphics off after boot; uppercase injected input, immediate MORE. Four source writers toA01C observed, including unchanged stores; complete state and every draw/read. Peripheral-only tape/printer/pause adapter identical to clarification corpus, no actor/world patches.',cases=cases),separators=(',',':')).encode(),mtime=0))
