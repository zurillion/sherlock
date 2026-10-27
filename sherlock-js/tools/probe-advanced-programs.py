"""Original full DOMAIN visits under declared controlled setups and a natural wait."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);scenarios=[]
for identity in [0,1,100]:
 for room in [32,102,50]:scenarios.append(dict(identity=identity,room=room,actor=6,pc='EE7D',actor_room=32))
for actor,pc,extra in [(2,'E932',{}),(2,'E932',dict(straker_met=True)),(2,'E96B',{}),(2,'E96B',dict(case_ready=True)),(2,'EAB3',{}),(2,'EAB3',dict(proofs=True)),(6,'EF89',{}),(6,'EF89',dict(companions=True)),(6,'EF99',{}),(6,'EF99',dict(actor_room=8)),(6,'EE46',dict(room=34))]:scenarios.append(dict(actor=actor,pc=pc,**extra))
scenarios += [dict(actor=6,pc='EE2B',clock=dict(hour=9,period='pm',minute=0)),dict(actor=6,pc='EE2B',clock=dict(hour=9,period='pm',minute=59)),dict(actor=2,pc='E932',command='WAIT UNTIL 9PM')]
result=[]
for index,setup in enumerate(scenarios):
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;g.command('I');m=w.m
 entity=lambda i:word(m,0x8b70+3*i)
 actorrow=lambda i:next(at for at in range(0x9860,0x9920,8)if m[at]==i)
 def move(i,room):
  m[entity(i)+1]=255;m[entity(i)+15]=room;w.call(0xd249,a=i,b=room)
 identity=setup.get('identity',0)
 if identity:w.prepare();w.call(0xe03a,a=identity)
 if 'room'in setup:move(w.player_id,setup['room'])
 if 'actor_room'in setup:move(setup['actor'],setup['actor_room'])
 if setup.get('companions'):
  for i in [2,3]:move(i,w.room);w.engine.put(w.sim,actorrow(i)+6,1000)
 if setup.get('straker_met'):m[0x9d90]=1
 if setup.get('case_ready'):m[0x9e88]=1
 if setup.get('proofs'):m[0x9976]|=2;m[0x9984]|=2
 if setup.get('clock'):
  c=setup['clock'];m[0x9fdf]=c['minute'];m[0x9fe0]=c['hour'];m[0x9fe2]=ord(c['period'][0])
 m[0xa009]=w.room;m[0xa00a]=w.room
 row=actorrow(setup['actor']);w.engine.put(w.sim,row+1,int(setup['pc'],16));w.engine.put(w.sim,row+6,word(m,0x9fdd))
 calls=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 for command in [setup.get('command','I'),'I']:
  if w.ended:break
  calls.clear();out=g.command(command);steps.append(dict(input=command,messages=out['messages'],after=snapshot(w),random=calls[:],ending=w.ended))
 result.append(dict(setup=setup,steps=steps));print(index,setup,w.clock()['label'],w.ended,flush=True)
(p/'sherlock-js/test/fixtures/advanced-programs-reference.json').write_text(json.dumps(dict(protocol='All actors, seed 1, free LOOK then I. Explicit program, position, identity, proof and deadline setups are controlled tests, not naturally reached states. No native state is imported by the JS runtime.',cases=result),separators=(',',':'))+'\n')
