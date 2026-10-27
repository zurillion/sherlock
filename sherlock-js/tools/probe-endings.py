"""Offline ending and KILL histories. Explicit setups are controlled evidence."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
ap=argparse.ArgumentParser();ap.add_argument('--start',type=int,default=0);ap.add_argument('--watch',action='store_true');args=ap.parse_args()
scenarios=[dict(commands=c)for c in [
 ['KILL','KILL WATSON','KILL BASIL','KILL LAMP','I'],
 ['KILL ALL','KILL ALL BUT WATSON','I'],
 ['SAY WATSON "KILL ME"','I','I'],
 ['SAY WATSON "KILL BASIL"','I','I'],
 ['OPEN DOOR','KILL WATSON','YOUR','I'],
 ['WAIT. KILL WATSON','I'],
 ['KILL 5','KILL 6D','I'],
 ['ACCUSE BASIL','ARREST BASIL','SHOOT BASIL','I'],
 ['KILL WATSON']*11+['I'],
]]
for companion in ['both','watson','lestrade','neither']:
 scenarios.append(dict(setup=dict(actor=6,pc='EF89',room=67,actor_room=67,companions=companion),commands=['I']))
for room in [8,12]:scenarios.append(dict(setup=dict(actor=2,pc='E96B',room=room,actor_room=12),commands=['I']))
for proofs in [[],[0x9973],[0x9981],[0x9973,0x9981]]:scenarios.append(dict(setup=dict(actor=2,pc='EAB3',proofs=proofs),commands=['I']))
for basil in [8,67]:scenarios.append(dict(setup=dict(actor=6,pc='EF99',actor_room=basil),commands=['I']))
scenarios.append(dict(setup=dict(actor=2,pc='E932'),commands=['I']))
# Start before the accusation branch and acquire the readiness condition via
# real statements. Evidence leaves are marked known in this controlled setup.
scenarios.append(dict(setup=dict(actor=2,pc='E93C',room=12,actor_room=12,known=True,hold_major=True),commands=['SAY LESTRADE "MRS BROWN KILLED HERSELF"','SAY LESTRADE "MRS JONES KILLED TRICIA"','SAY LESTRADE "BASIL HAS PLANS"','SAY LESTRADE "MAJOR FFOULKES IS INNOCENT"']+['WAIT']*20))
scenarios += [dict(setup=dict(actor=6,pc='EF7F',room=30,actor_room=28,companions=c),commands=['WAIT'])for c in ['both','neither']]
scenarios.append(dict(setup=dict(actor=2,pc='E932',failures=9),commands=['KILL WATSON']))
scenarios.append(dict(setup=dict(actor=2,pc='E932',room=8),commands=['CLOSELY EXAMINE LAMP']))
scenarios += [dict(setup=dict(actor=2,pc=pc,room=58),commands=['OPEN ALL'])for pc in ['E932','E93C']]
scenarios.append(dict(setup=dict(actor=2,pc='E932',failures=9),commands=['EXAMINE ALL']))
scenarios.append(dict(setup=dict(actor=2,pc='E932',failures=9),commands=['EXAMINE ME']))
scenarios.append(dict(setup=dict(actor=2,pc='E932'),commands=['WAIT. I']))
target=p/'sherlock-js/test/fixtures/endings-reference.json';result=json.loads(target.read_text())['cases'][:args.start]if args.start else [];catalog=extract(p)
for index,s in enumerate(scenarios):
 if index<args.start:continue
 if args.watch:target=Path('/private/tmp/sherlock-endings-writers.json')
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0
 setup=s.get('setup',{})
 if setup:g.command('I')
 entity=lambda i:word(m,0x8b70+3*i)
 row=lambda i:next(at for at in range(0x9860,0x9920,8)if m[at]==i)
 def move(i,room):m[entity(i)+1]=255;m[entity(i)+15]=room;w.call(0xd249,a=i,b=room)
 if 'room'in setup:move(w.player_id,setup['room'])
 if 'actor_room'in setup:move(setup['actor'],setup['actor_room'])
 if 'companions'in setup:
  for ident,key in [(2,'lestrade'),(3,'watson')]:
   move(ident,w.room if setup['companions']in('both',key)else 8);w.engine.put(w.sim,row(ident)+6,1000)
 if 'failures'in setup:m[0xcc0b]=setup['failures']
 for at in setup.get('proofs',[]):m[at+3]|=2
 if setup.get('known'):
  roots={0x9965,0x9973,0x9981,0x9997,0x99a9,0x99bb,0x99c5,0x99cf,0x99d9,0x99e3,0x99f1};at=0x9965
  while at<0x99fb:
   flags=m[at+3]
   if at not in roots:m[at+3]|=2
   at+=6 if flags&48 else 4
 if setup.get('hold_major'):move(7,0);w.engine.put(w.sim,row(7)+6,1000);m[0x9d90]=1
 if setup:
  m[0xa009]=w.room;m[0xa00a]=w.room;w.engine.put(w.sim,row(setup['actor'])+1,int(setup['pc'],16));w.engine.put(w.sim,row(setup['actor'])+6,word(m,0x9fdd))
 draws=[];pending=None;events=[];pause=None;steps=[];terminal_seen=False;lastpc=0;lastsp=0;previous=list(m[0x5d00:0x5d10]);writers={}
 def observe(m,r,R):
  global pending,pause,terminal_seen,lastpc,lastsp
  pc=r[R.PC]
  if args.watch:
   for i in range(16):
    at=0x5d00+i
    if m[at]!=previous[i]or lastsp-r[R.SP]==2 and r[R.SP]<=at<r[R.SP]+2:
     writers[f'{at:04X}']=dict(value=m[at],pc=f'{lastpc:04X}',actor=m[0xa036],sp=r[R.SP],word=bytes(m[0x5c0b:0x5c3b]).decode('latin1'),stack=[f'{word(m,a):04X}'for a in range(r[R.SP],min(r[R.SP]+70,0x5d80),2)])
     previous[i]=m[at]
   lastpc=pc;lastsp=r[R.SP]
  if pc==0x9e74:terminal_seen=True
  if terminal_seen and pc==0xc306:pause=snapshot(w)
  if pc in(0x9e4a,0x9e6c,0x9e87,0x9ea4,0xdfcc,0x9a3f,0xeab3,0xef89):events.append(dict(pc=f'{pc:04X}',actor=m[0xa036],tick=word(m,0x9fdd)))
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if args.watch and pc==0xd2ad:pending['writers']=dict(writers)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe
 for c in s['commands']:
  draws.clear();events.clear();pause=None;out=g.command(c)
  steps.append(dict(input=c,messages=out['messages'],after=snapshot(w),random=draws[:],ending=w.ended,pause=pause,events=events[:],story_flags=dict(case_ready=bool(m[0x9e88]),straker_met=bool(m[0x9d90]))))
  if w.ended or out['state']['analysis']['outcome']=='tool_limit':break
 result.append(dict(setup=setup,steps=steps));target.write_text(json.dumps(dict(protocol='All 24 actors, seed 1, free initial LOOK; graphics off after boot; injected uppercase input and immediate MORE/terminal acknowledgement. Setups explicitly mark positions, actor PCs/deadlines and acquired evidence; those histories are controlled, not naturally reached gameplay.',cases=result),separators=(',',':'))+'\n');print(index,len(steps),w.clock()['label'],w.ended,[m['text']for m in out['messages']][-2:],flush=True)
