"""Controlled offline oracle: local TELL programmes and NPC reidentification."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
catalog=extract(p);cases=[]
for visible in [False,True]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0
 def move(ident,room):
  q=word(m,0x8b70+3*ident);m[q+1]=255;m[q+15]=room
 move(13,8);move(2,8);move(67,8 if visible else 0)
 q=0x9860+13*8;m[q+1]=0x92;m[q+2]=0xf1
 for ident in [72,66,67]:m[word(m,0x8b70+3*ident)+6]|=64
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
 for command in ['SAY TRICIA "TELL ME ABOUT CLOTHES"','I','SAY MRS JONES "TELL LESTRADE ABOUT CLOTHES"','SAY LESTRADE "MRS JONES KILLED TRICIA"','I']:
  out=g.command(command);steps.append(dict(input=command,after=snapshot(w),random=draws[:],messages=out['messages']));draws.clear()
 cases.append(dict(visible_clothes=visible,steps=steps));print(visible,[[(m.get('text'))for m in s['messages']]for s in steps],flush=True)
(p/'sherlock-js/test/fixtures/jones-dialogue-reference.json').write_text(json.dumps(dict(protocol='Controlled seed-1 tests, all actors. Place Tricia and Lestrade in room 8; Tricia root PC F192. Clothes are in room 8 or off-stage. Set only the three examination flags for body 72, bookcase 66 and clothes 67. No confession flags or native states are imported into JS.',cases=cases),separators=(',',':'))+'\n')
