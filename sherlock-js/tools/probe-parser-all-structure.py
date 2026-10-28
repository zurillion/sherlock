import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
for inputs in [['PUT ALL ON YOUR ARMCHAIR INTO LAMP BUT LAMP','I'],['OPEN ALL AND PLAIN DOOR ALL','I'],['OPEN ALL AND PLAIN DOOR BUT YOUR DOOR','I'],['OPEN ALL AND ALL','I'],['OPEN ALL AND CLOSE ALL','I'],['OPEN ALL BUT YOUR DOOR AND PLAIN DOOR','I'],['OPEN DOOR','ALL BUT YOUR DOOR','I'],['SAY WATSON "OPEN ALL BUT YOUR DOOR"','I']]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 for c in inputs:
  out=g.command(c);steps.append(dict(input=c,after=snapshot(w),all_state=m[0xa01a],random=draws[:],outcome=out['state']['analysis']['outcome']));draws.clear()
 cases.append(steps);print([(x['input'],x['outcome'],x['all_state'])for x in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/parser-all-structure.json').write_text(json.dumps(dict(protocol='Fresh seed1 per natural command case, all actors, graphics off after boot, injected uppercase keys and immediate MORE; no world patches. Complete arena, actors, entities, facts, bitmaps and every random draw/read.',cases=cases),separators=(',',':'))+'\n')
