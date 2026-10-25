"""Offline oracle: ALL lifetime while Watson follows, then greet the cabbie."""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
data=extract(p)
def snapshot(g):
 w=g.world;m=w.m;entities=[];lists={}
 for ident in range(110):
  q=word(m,0x8b70+3*ident);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]]),attributes=m[q+5],status=m[q+6]))
 for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7),('requests',0x9fee,8),('syntax',0x9ff0,30),('parsed',0x9ff2,30)]:
  q=word(m,head);rows=[]
  while q:rows.append(dict(pointer=q,values=list(m[q:q+size])));q=word(m,q-2)
  lists[name]=rows
 bitmap=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
 return dict(clock=w.clock(),actors=[dict(id=m[x],pc=f'{word(m,x+1):04X}',saved=list(m[x+3:x+6]),due=word(m,x+6))for x in range(0x9860,0x9920,8)],entities=entities,rooms=[m[word(m,0x840b+2*i)]for i in range(106)],records=lists,arena=list(m[0x9570:0x9860]),free_head=word(m,0x9fe3),random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),upper_sha256=hashlib.sha256(bitmap).hexdigest())
result={'scope':'Per-case true seeded bootstrap, all 24 actors, free initial LOOK, text-only native source after first prompt, injected uppercase keys, immediate MORE, no idle timeouts, natural walk without teleport. Observations are assertions, never runtime inputs.','cases':[]}
for label,seed,door in [('following_all',1,'ALL'),('following_direct_all',1,'OPEN ALL DOORS'),('following_your',1,'YOUR'),('following_all_seed42',42,'ALL')]:
 g=Game(p,data,seed=seed,active_npcs=None);w=g.world;w.m[0xa011]=0;initial=snapshot(g);calls=[];pending=None;events=[]
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],tick=word(m,0x9fdd),width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
  if pc in(0xa11c,0xa1c7,0xb191,0xd835,0xd848):events.append(dict(at=f'{pc:04X}',tick=word(m,0x9fdd),actor=m[0xa036],value=r[R.A],ix=r[R.IXh]*256+r[R.IXl],heads=[word(m,x)for x in(0x9fee,0x9ff0,0x9ff2)],iteration=m[0xa01c]))
 w.observer=observe
 commands=['SAY TO WATSON "HELLO"']+['WAIT']*3+['SAY TO WATSON "FOLLOW ME"']+([door]if door=='OPEN ALL DOORS'else['OPEN DOOR',door])+['WEST','DOWN','OPEN DOOR','SOUTH','HAIL CAB','SAY "HELLO" TO CABBIE','GET INTO CAB','SAY "HELLO" TO CABBIE','SAY TO CABBIE "GO TO KINGS CROSS ROAD"']+['WAIT']*4+['GET OUT OF CAB','PAY 1/- TO CABBIE']
 rows=[]
 for command in commands:
  begin=len(calls);event_start=len(events);out=g.command(command);rows.append(dict(input=command,outcome=out['state']['analysis']['outcome'],messages=out['messages'],random=calls[begin:],events=events[event_start:],after=snapshot(g)));print(label,command,w.clock()['label'],[m['text']for m in out['messages']if m['text']],flush=True)
 result['cases'].append(dict(label=label,seed=seed,initial=initial,commands=rows));a.output.write_text(json.dumps(result,indent=2)+'\n')
