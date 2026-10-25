"""Offline original-engine oracle for parser errors and recovery.

Observations are assertions only, never runtime inputs. Map travel is the
existing research helper (its extra scene is explicitly outside bitmap parity).
"""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--history',type=Path,default=Path('results/errors/inputs.txt'));ap.add_argument('--output',type=Path,required=True);ap.add_argument('--stop',type=int);ap.add_argument('--extra',type=int,default=0);ap.add_argument('--seed',type=int,default=1);ap.add_argument('--watch',action='store_true');ap.add_argument('--follow-until',type=int,help='After the prefix, choose walking/I inputs from the native map until this calendar minute. Test controller only.');args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=args.seed,active_npcs=None);w=g.world;w.m[0xa011]=0
cells=[0x5cee,0x5cf5,*range(0x5d00,0x5d10)]
def snapshot():
 m=w.m;lists={};entities=[]
 for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7),('requests',0x9fee,8),('syntax',0x9ff0,30),('parsed',0x9ff2,30)]:
  q=word(m,head);rows=[]
  while q:rows.append(dict(pointer=q,values=list(m[q:q+size])));q=word(m,q-2)
  lists[name]=rows
 for ident in range(110):
  q=word(m,0x8b70+3*ident);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]]),attributes=m[q+5],status=m[q+6]))
 bitmap=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
 return dict(clock=w.clock(),actors=[dict(id=m[q],pc=f'{word(m,q+1):04X}',saved=list(m[q+3:q+6]),due=word(m,q+6))for q in range(0x9860,0x9920,8)],entities=entities,rooms=[m[word(m,0x840b+2*i)]for i in range(106)],records=lists,arena=list(m[0x9570:0x9860]),free_head=word(m,0x9fe3),random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),upper_sha256=hashlib.sha256(bitmap).hexdigest(),working_cells={f'{at:04X}':m[at]for at in cells},input=list(m[0x5b00:0x5b81]),tokens=list(m[0x5b81:0x5c00]),lower_bitmap=list(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(152,192)for x in range(32)),mutable={f'{at:04X}':m[at]for at in [0xa01b,0xa019,0xa025,0xa024,0xd7e0,0xd6b8]})
result=dict(scope='True seeded bootstrap, all 24 actors; free initial LOOK; graphics off after first prompt; uppercase injected keys, immediate MORE, no idle timeouts. Map travel uses the historical helper when explicit; those rows do not certify bitmap parity.',seed=args.seed,initial=snapshot(),steps=[])
calls=[];pending=None;writers={};last=None;previous={a:w.m[a]for a in cells};events=[];watch_active=False
def observe(m,r,R):
 global pending,last
 pc=r[R.PC]
 if watch_active:
  at=0x5d02
  if m[at]!=previous[at]:
   previous[at]=m[at];writers[f'{at:04X}']=dict(value=m[at],writer=f'{last:04X}'if last else None,actor=m[0xa036],sp=r[R.SP],word=bytes(m[0x5c0b:0x5c3b]).decode('latin1'),cells={f'{a:04X}':m[a]for a in cells})
  last=pc
 if pc==0xd2ad:pending=dict(actor=m[0xa036],tick=word(m,0x9fdd),width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[],writers=dict(writers));calls.append(pending)
 if pending is not None and pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
 if pending is not None and pc==0xd2ec:
  v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 if pc in(0xa2e4,0xcaaf,0xcbc2,0xca76):events.append(dict(at=f'{pc:04X}',actor=m[0xa036],action=m[0xa033],object=m[0xa034],other=m[0xa035],tick=word(m,0x9fdd)))
w.observer=observe
steps=[]
for line in args.history.read_text().splitlines():
 if line.startswith('# Teletrasporto:'):steps.append(('teleport',int(line.split(':')[1].split('·')[0])))
 elif line and not line.startswith('#'):steps.append(('command',line))
if args.stop:steps=steps[:args.stop]
steps += [('command','I')]*args.extra
def follow_command():
 from collections import deque
 m=w.m;current=w.room;target=m[word(m,0x8b70+3*2)+15]
 if current==target:return 'I'
 queue=deque([(current,[])]);seen={current}
 while queue:
  room,path=queue.popleft()
  if room==target:
   edge=path[0];gate=edge['gate']
   if gate and not m[word(m,0x8b70+3*gate)+5]&40:return 'OPEN '+g.entities[gate]['name']
   return edge['direction']
  for edge in g.rooms[room]['exits']:
   if not edge['target']or edge['target']in seen:continue
   if edge['gate']:
    at=word(m,0x8b70+3*edge['gate'])
    if not m[at+5]&40 and m[at+5]&1:continue
   seen.add(edge['target']);queue.append((edge['target'],path+[edge]))
 return 'I'
if args.follow_until:result['scope']+=' No teleports in following mode: an offline test controller selects player movement/I inputs from the graph and Lestrade position; these selected commands are replayed verbatim by JS.'
def sequence():
 yield from steps
 while args.follow_until and w.clock()['hour']%12*60+w.clock()['minute']+(720 if w.clock()['period']=='pm' else 0)<args.follow_until:yield 'command',follow_command()
for i,(kind,value)in enumerate(sequence()):
 watch_active=args.watch and (i>=103 or kind=='command' and value.startswith('EXAMINE'))
 start=len(calls);ev=len(events);out=g.command(value)if kind=='command'else g.teleport(value)
 row=dict(kind=kind,input=value,messages=out['messages'],outcome=out['state']['analysis']['outcome']if kind=='command'else None,random=calls[start:],events=events[ev:],writers=dict(writers),after=snapshot());result['steps'].append(row)
 args.output.write_text(json.dumps(result,indent=2)+'\n')
 print(i+1,kind,value,w.clock()['label'],'L='+str(row['after']['entities'][2]['rooms']),[m['text']for m in out['messages']if m['text']],flush=True)
 Path('/private/tmp/command-errors-native-state.json').write_text(json.dumps(dict(memory=list(w.m),registers=list(w.sim.registers))))
