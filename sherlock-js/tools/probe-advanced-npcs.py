"""Controlled late NPC rule/callback probes, with original all-actor startup."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game,perceived
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);g=Game(p,catalog,seed=1,active_npcs=None);g.world.m[0xa011]=0;g.command('I');w=g.world;base=w.m[:];regs=w.sim.registers[:];cases=[]
for actor,body,name in [(7,0xf1aa,'unimplemented.F1A8'),(4,0xed3b,'unimplemented.ED39'),(6,0xefb5,'unimplemented.EFB3'),(6,0xefe9,'unimplemented.EFC7'),(11,0xf105,'unimplemented.F103'),(6,0xef9e,'unimplemented.EF9C'),(6,0xefae,'unimplemented.EFAC')]:
 for near in [False,True]:cases.append(dict(kind='body',actor=actor,body=body,name=name,near=near))
for actor,entry,cell in [(5,0x9ec1,0x9ec0),(8,0x9ed1,0x9ed0),(9,0x9ecb,0x9eca)]:
 for hour,period,saved in [(8,'am',0),(8,'pm',0),(9,'am',0),(9,'pm',0),(10,'pm',0),(9,'pm',42),(8,'am',42)]:cases.append(dict(kind='sleep',actor=actor,body=entry,cell=cell,hour=hour,period=period,saved=saved))
for accumulator in [0,1,2,42,127,128,254,255]:cases.append(dict(kind='sleep',actor=5,body=0x9ec1,cell=0x9ec0,hour=9,period='pm',saved=0,accumulator=accumulator))
result=[]
for case in cases:
 w.m[:]=base;w.sim.registers[:]=regs;m=w.m;r=w.sim.registers;R=w.R;actor=case['actor'];q=word(m,0x8b70+3*actor);row=next(at for at in range(0x9860,0x9920,8)if m[at]==actor)
 if case['kind']=='body':
  if case['near']:m[q+1]=255;m[q+15]=w.room
 else:
  m[0x9fe0]=case['hour'];m[0x9fe2]=ord(case['period'][0]);m[case['cell']]=case['saved']
  if case['saved']:m[q+1]=255;m[q+15]=74 if actor==5 else 0;m[q+5]&=~64;m[q+8]=(m[q+8]&15)|16;m[q+9:q+11]=[0xf0,7]
 if 'accumulator'in case:m[0xa037]=case['accumulator']
 m[0xa027]=0;m[0xa036]=actor;w.call(0xcc29);m[0x5c3c]=int(perceived(m,actor));r[R.IYh],r[R.IYl]=row>>8,row&255
 calls=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;out=w.call(case['body']);w.observer=None
 result.append(dict(setup=case,after=snapshot(w),rest={str(i):m[at]for i,at in[(5,0x9ec0),(8,0x9ed0),(9,0x9eca)]},random=calls,text=out['text']))
 print(case,out['text'],flush=True)
(p/'sherlock-js/test/fixtures/advanced-npcs-reference.json').write_text(json.dumps(dict(protocol='Controlled isolated rule/callback calls after all-actor seed-1 startup and I. Actor position, clock and saved rest room patched identically. Not a natural history.',cases=result),separators=(',',':'))+'\n')
