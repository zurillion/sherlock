"""Offline transport regressions, with Holmes riding and observing the NPCs.

The resulting observations are assertions only, never inputs to the JS game.
"""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--case');ap.add_argument('--watch',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
data=extract(p)
base=['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','HAIL CAB','GET INTO CAB']
kings=base+['SAY TO CABBIE "GO TO KINGS CROSS ROAD"']+['WAIT']*3+['GET OUT OF CAB','PAY 1/- TO CABBIE']
cases=[('buckingham',base+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*4+['GET OUT OF CAB','PAY 1/- TO CABBIE']),('camden',base+['SAY TO CABBIE "GO TO CAMDEN STREET"']+['WAIT']*6+['GET OUT OF CAB','PAY 1/- TO CABBIE']),('kings_short',base+['SAY TO CABBIE "GO TO KINGS CROSS"','WAIT','WAIT']),('after_look',['LOOK']+base+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*4),('after_clarification',['OPEN DOOR','YOUR']+base[1:]+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*4),('train',kings+['NORTHEAST']*4+['WAIT']*8+['GET INTO TRAIN']+['WAIT']*17+['GET OUT OF TRAIN','SOUTH'])]
cells=[0x5cee,0x5cf5,*range(0x5d00,0x5d08)]
def snapshot(g):
 w=g.world;m=w.m;rows=[dict(id=m[x],pc=f'{word(m,x+1):04X}',saved=list(m[x+3:x+6]),due=word(m,x+6))for x in range(0x9860,0x9920,8)]
 entities=[]
 for ident in range(110):
  q=word(m,0x8b70+3*ident);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]]),attributes=m[q+5],status=m[q+6]))
 lists={}
 for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7)]:
  q=word(m,head);values=[]
  while q:values.append(dict(pointer=q,values=list(m[q:q+size])));q=word(m,q-2)
  lists[name]=values
 upper=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
 return dict(clock=w.clock(),actors=rows,entities=entities,rooms=[m[word(m,0x840b+2*i)]for i in range(106)],records=lists,random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),upper_sha256=hashlib.sha256(upper).hexdigest(),working_cells={f'{at:04X}':m[at]for at in cells})
result={'scope':'True seeded bootstrap 1; all original actors active; free initial LOOK; graphics disabled after first prompt; no teleport; uppercase injected keys, immediate MORE, no idle timeouts.','cases':[]}
for label,commands in cases:
 if a.case and label!=a.case:continue
 g=Game(p,data,seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;initial=snapshot(g);calls=[];pending=None;previous={at:w.m[at]for at in cells};last=None;writers={}
 def observe(m,r,R):
  global pending,last
  pc=r[R.PC]
  if a.watch:
   for at in cells:
    if m[at]!=previous[at]:
     previous[at]=m[at];writers[f'{at:04X}']=dict(value=m[at],writer=None if last is None else f'{last:04X}',actor=m[0xa036],sp=r[R.SP],word=bytes(m[0x5c0b:0x5c3b]).decode('latin1'))
   last=pc
  if pc==0xd2ad:pending=dict(actor=m[0xa036],tick=word(m,0x9fdd),width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in (0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   value=r[R.A];pending.update(result=abs(value if value<128 else value-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;rows=[]
 for command in commands:
  before=len(calls);out=g.command(command);rows.append(dict(input=command,outcome=out['state']['analysis']['outcome'],messages=out['messages'],random=calls[before:],after=snapshot(g),writers=dict(writers)if a.watch else None));print(label,command,w.clock()['label'],w.room,out['state']['analysis']['outcome'],[x['text']for x in out['messages']if x['text']],flush=True)
 result['cases'].append(dict(label=label,seed=1,initial=initial,commands=rows));a.output.write_text(json.dumps(result,indent=2)+'\n')
