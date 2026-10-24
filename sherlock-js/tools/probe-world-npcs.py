"""Offline source oracle for the reconstructed domain NPC host. Never runtime input."""
import argparse,json,sys,hashlib
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project.resolve()
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
data=extract(p)
def snapshot(g):
 w=g.world;m=w.m
 rows=[dict(id=m[x],pc=f'{word(m,x+1):04X}',saved=list(m[x+3:x+6]),due=word(m,x+6)) for x in range(0x9860,0x9920,8)]
 entities=[]
 for ident in range(110):
  q=word(m,0x8b70+3*ident);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]]),attributes=m[q+5],status=m[q+6]))
 lists={}
 for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7)]:
  q=word(m,head);values=[]
  while q:values.append(dict(pointer=q,values=list(m[q:q+size])));q=word(m,q-2)
  lists[name]=values
 upper=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
 return dict(clock=w.clock(),actors=rows,entities=entities,records=lists,random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),upper_sha256=hashlib.sha256(upper).hexdigest())
scenarios=[('initial',None,['OPEN YOUR DOOR','WAIT']),('cab',5,['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*4+['GET OUT OF CAB','PAY 1/- TO CABBIE','WAIT']),('police',62,['HELLO','WAIT']),('lestrade',10,['SAY TO LESTRADE "WAIT"']+['WAIT']*5),('long_wait',None,['WAIT']*25),('greetings',None,['SAY TO WATSON "HELLO"']*40)]
scenarios=[(*row,1)for row in scenarios]
scenarios=[(label,teleport,['WAIT']*35 if label=='long_wait'else commands,seed)for label,teleport,commands,seed in scenarios]
scenarios.append(('following',None,['SAY TO WATSON "FOLLOW ME"','OPEN YOUR DOOR','WEST','DOWN','SAY TO WATSON "HELLO"','OPEN FRONT DOOR','SOUTH','NORTH','UP','EAST'],1))
scenarios.extend([('walk_cab',None,['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3+['GET OUT OF CAB','PAY 1/- TO CABBIE'],1)])
for seed in [0,42,255]:scenarios.append((f'greetings_seed_{seed}',None,['SAY TO WATSON "HELLO"']*12,seed))
result={'scope':'True seeded boot (per-case seed), all original actors active, free initial LOOK, graphics disabled after first prompt, injected keys without idle timeout. Teleport is explicit where present.','cases':[]}
for label,teleport,commands,seed in scenarios:
 g=Game(p,data,seed=seed,active_npcs=None);w=g.world;w.m[0xa011]=0
 initial=snapshot(g)
 if teleport:g.teleport(teleport)
 calls=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:
   pending=dict(actor=m[0xa036],tick=word(m,0x9fdd),width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in (0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   value=r[R.A];pending.update(result=abs(value if value<128 else value-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;rows=[]
 for command in commands:
  before=len(calls);out=g.command(command);row=dict(input=command,messages=[dict(kind=x['kind'],text=x['text'],screen_events=x.get('screen_events',[])) for x in out['messages']],random=calls[before:],after=snapshot(g));rows.append(row)
  print(label,command,w.clock()['label'],[(d['actor'],d['width'],hex(d['mixOffset']))for d in row['random']],flush=True)
 result['cases'].append(dict(label=label,seed=seed,teleport=teleport,initial=initial,commands=rows));a.output.write_text(json.dumps(result,indent=2)+'\n')
