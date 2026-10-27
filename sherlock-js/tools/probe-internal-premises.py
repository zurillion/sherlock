"""Controlled offline tests of a nested hypothesis, separate from natural play."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
cases=[];catalog=extract(p)
for observed in [False,True]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;q=word(m,0x8b70+6);m[q+1]=255;m[q+15]=8
 if observed:m[0x9972]|=2
 draws=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 for command in ['SAY LESTRADE "MAJOR FFOULKES VISIT OPIUM DEN"','SAY LESTRADE "MAJOR FFOULKES IS INNOCENT"','I']:
  out=g.command(command);steps.append(dict(input=command,after=snapshot(w),random=draws[:],messages=out['messages'],case_ready=bool(m[0x9e88])));draws.clear()
 cases.append(dict(observed=observed,steps=steps));print(observed,[(s['input'],[m['text']for m in s['messages']])for s in steps],flush=True)
(p/'sherlock-js/test/fixtures/internal-premises-reference.json').write_text(json.dumps(dict(protocol='Controlled seed-1 tests, all actors; move Lestrade to room 8, optionally set only the F103 observation leaf at 9972. No prepared state is a natural playthrough.',cases=cases),separators=(',',':'))+'\n')
