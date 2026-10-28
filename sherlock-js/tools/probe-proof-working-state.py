import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
cases=[];catalog=extract(p)
for known,commands in [(False,['SAY LESTRADE "MAJOR IS INNOCENT AND MAJOR VISIT OPIUM DEN"','I']),(False,['SAY LESTRADE "BASIL HAS PLANS"','I','SAY LESTRADE "LAMP HAS PLANS"','I']),(True,['SAY LESTRADE "MAJOR IS INNOCENT"','I']),(False,['SAY LESTRADE "DOOR IS INNOCENT"','I'])]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;at=word(m,0x8b70+3*2);m[at+1]=255;m[at+15]=8
 if known:
  roots=[0x9965,0x9973,0x9981,0x9997,0x99a9,0x99bb,0x99c5,0x99cf,0x99d9,0x99e3,0x99f1];at=0x9965
  while at<0x99fb:
   flags=m[at+3]
   if at not in roots:m[at+3]|=2
   at+=6 if flags&48 else 4
 draws=[];pending=None;events=[];steps=[]
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc in(0xbb67,0xbb6a,0xbb7b,0xbc31,0xbc3c,0xbc8c,0xbcb9):events.append(dict(pc=f'{pc:04X}',a=r[R.A],b=r[R.B],ix=r[R.IXh]*256+r[R.IXl],fields=list(m[0xba1c:0xba20])))
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   a=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=a,value=m[a]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe
 for c in commands:
  out=g.command(c);steps.append(dict(input=c,after=snapshot(w),fields=list(m[0xba1c:0xba20]),events=events[:],random=draws[:],messages=out['messages']));events.clear();draws.clear()
 cases.append(dict(known=known,steps=steps));print(known,[(s['input'],s['fields'])for s in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/proof-working-reference.json').write_text(json.dumps(dict(protocol='Controlled native Lestrade placement in room8; optional premises marked known as in information corpus. All 24 actors active, fresh seed1, source graphics off after boot, injected keys, immediate MORE. Not a natural ending.',cases=cases),separators=(',',':'))+'\n')
