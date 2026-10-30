"""Original dictionary-reference ownership: natural cases, no runtime reference use."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['SAY WATSON "HELLO"','SAY WATSON "GOOD MORNING"','SAY WATSON "HELLO"'],['WAIT','WAIT','SAY WATSON "HELLO"'],['XYZZY','LOOK','OPEN DOOR','YOUR','I'],['GIVE MONEY TO WATSON','SAY WATSON "GIVE ME MY MONEY"','I'],['OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL CAB','CLIMB INTO CAB','SAY CABBIE "GO TO KINGS CROSS ROAD"','WAIT','WAIT','WAIT','I'],['SAY WATSON "BASIL HAS PLANS"','SAY WATSON "BASIL IS INNOCENT"','WAIT'],['SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','OPEN DOOR','S','I']]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;steps=[];boot_reference=word(m,0xa022)
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=obs
 for command in inputs:
  out=g.command(command);steps.append(dict(dictionary_reference=word(m,0xa022),input=command,after=snapshot(w),random=draws[:],messages=out['messages'],money_parent=m[word(m,0x8b70+3*27)+1],lamp_parent=m[word(m,0x8b70+3*22)+1],outcome=out['state']['analysis']['outcome']));draws.clear()
 cases.append(dict(boot_reference=boot_reference,steps=steps));print([(r['input'],r['money_parent'],r['lamp_parent'],[(q['kind'],q['text'])for q in r['messages']])for r in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/dictionary-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Fresh seed1 natural boots per case, all24 actor slots, free initial LOOK, native graphics off after boot, injected uppercase keys and immediate MORE. No world/actor overlays. Every random draw/read, complete arena/entities/actors/facts/bitmaps. Python bridge message chunks are diagnostic; screen bytes are the display comparison.',cases=cases),separators=(',',':')).encode(),mtime=0))
