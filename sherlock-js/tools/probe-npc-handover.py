"""Original GIVE and NPC return requests: natural cases, no runtime reference use."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['GIVE MONEY TO WATSON','SAY WATSON "GIVE ME MY MONEY"','I'],['GIVE MONEY TO WATSON','SAY WATSON "GIVE MONEY TO ME"','I'],['GIVE MONEY TO WATSON','SAY WATSON "GIVE ME MONEY"','I'],['GIVE WATSON MONEY','SAY WATSON "GIVE ME MY MONEY"','I'],['GET LAMP','GIVE LAMP TO WATSON','SAY WATSON "GIVE ME LAMP"','I'],['GET LAMP','GIVE WATSON LAMP','SAY WATSON "GIVE LAMP TO ME"','I'],['SAY WATSON "GIVE ME DAILY CHRONICLE"','I','I'],['SAY WATSON "GIVE ME MY MONEY"','I'],['GET LAMP','GIVE MONEY TO WATSON','GIVE LAMP TO WATSON','SAY WATSON "GIVE ME ALL"','I','I','I','I'],['GET LAMP','GIVE WATSON ALL','I','SAY WATSON "GIVE ALL TO ME"','I','I','I','I'],['GIVE MONEY WATSON','I'],['GET LAMP','GIVE LAMP TO','WATSON','SAY WATSON "GIVE ME LAMP"','I'],['GET LAMP','GIVE TO WATSON LAMP','SAY WATSON "GIVE TO ME LAMP"','I'],['GET LAMP','SAY WATSON "GIVE ME LAMP"','I'],['GIVE MONEY TO WATSON','SAY WATSON "GIVE ME MY MONEY AND GIVE ME DAILY CHRONICLE"','I','I'],['GET LAMP','GIVE LAMP TO YOUR ARMCHAIR','I']]
street=['OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL CAB']
scenarios += [street+['GIVE MONEY TO CABBIE','SAY CABBIE "GIVE ME MY MONEY"','I','I'],['GET LAMP']+street+['GIVE CABBIE LAMP','SAY CABBIE "GIVE ME LAMP"','I','I'],['GIVE MONEY TO LESTRADE','I'],['GET LAMP','GIVE LAMP TO ME','I'],['GIVE WATSON','I'],['GIVE MONEY','I'],['GIVE','MONEY','I'],['GIVE ALL','I'],['GIVE MONEY TO ME','I']]
# --append resumes an expanded research matrix without regenerating its prefix.
if '--append' in sys.argv:
 cases=json.loads(gzip.decompress(p.joinpath('sherlock-js/test/fixtures/npc-handover.json.gz').read_bytes()))['cases']
 scenarios=scenarios[len(cases):]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;steps=[]
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
  out=g.command(command);steps.append(dict(input=command,after=snapshot(w),random=draws[:],messages=out['messages'],money_parent=m[word(m,0x8b70+3*27)+1],lamp_parent=m[word(m,0x8b70+3*22)+1],outcome=out['state']['analysis']['outcome']));draws.clear()
 cases.append(dict(steps=steps));print([(r['input'],r['money_parent'],r['lamp_parent'],[(q['kind'],q['text'])for q in r['messages']])for r in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/npc-handover.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Fresh seed1 natural boots per case, all24 actor slots, free initial LOOK, native graphics off after boot, injected uppercase keys and immediate MORE. No world/actor overlays. Every random draw/read, complete arena/entities/actors/facts/bitmaps. Python bridge message chunks are diagnostic; screen bytes are the display comparison.',cases=cases),separators=(',',':')).encode(),mtime=0))
