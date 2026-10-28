import sys,json,inspect,textwrap
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
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
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;events=[];steps=[]
 def obs(m,r,R):
  pc=r[R.PC]
  if pc in(0xaab6,0xad3d,0xad66,0xb11b):events.append(dict(pc=f'{pc:04X}',old=m[0xa012],value=r[R.A]if pc in(0xaab6,0xad3d)else(m[0xa012]+1)&255,mode=m[0xa024],exclusion=m[0xa01a]))
 g.persistence_control=lambda text:None;w.observer=obs
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while out.get('running'):out=g.continue_command(out['job'])
  steps.append(dict(input=c,count=m[0xa012],flag=m[0xd714],events=events[:],outcome=out['state']['analysis']['outcome']));events.clear()
 cases.append(steps);print([(s['input'],s['count'],s['outcome'])for s in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/parser-counter-reference.json').write_text(json.dumps(dict(protocol='Natural command cases from fresh seed-1 boots, all actors, graphics off after boot; injected uppercase keys, immediate MORE. Source writes to A012 observed, no actor/world patches. Peripheral-only adapter returns success for tape SAVE and supplies printer/Pause key polls, as in command-limits corpus.',cases=cases),separators=(',',':'))+'\n')
