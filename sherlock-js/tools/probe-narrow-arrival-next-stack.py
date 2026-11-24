"""Offline original Sherlock1984: next stack23 producer after pictured root-name arrival."""
import gzip,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz'
reference=json.loads(gzip.decompress(source.read_bytes()));route=[s['command']for s in reference['steps']if s['command']]
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
cache=(root/'results/narrow-arrival-descriptor/pre-north-prompt.json.gz');saved=json.loads(gzip.decompress(cache.read_bytes()));assert saved['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);start=sum(bool(s['command'])for s in reference['steps'][:3112])
checkpoint=reference['steps'][3111];assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room']
picture=bytearray()
for y in range(144):
 at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
picture.extend(m[0x5800:0x5a40]);assert hashlib.sha256(picture).hexdigest()==checkpoint['video']
assert m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']
handover=dict(sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),original_checkpoint=3111,clock_room_video_counter_and_mode_match=True,clock=w.clock())
targets=(0x5d23,);old={a:m[a]for a in targets};last={};counts={a:0 for a in targets};pending=None;previous=None;glyph=None;active_word="";reads=[];unclassified=[];command=None
pushes={0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc,0xc7,0xcf,0xd7,0xdf,0xe7,0xef,0xf7,0xff}
def observe(m,r,R):
 global pending,previous,glyph,active_word
 pc=r[R.PC];sp=r[R.SP];classified=set()
 if pending and sp==pending['after_sp']:
  for at in pending['addresses']:
   event={k:v for k,v in pending.items()if k not in ('addresses','after_sp')};event.update(address=f'{at:04X}',value=m[at]);last[at]=event;counts[at]+=1;classified.add(at)
 for at in targets:
  if old[at]!=m[at]and at not in classified:unclassified.append(dict(pc=previous,address=f'{at:04X}',value=m[at],tick=word(m,0x9fdd)))
  old[at]=m[at]
 pending=None
 if pc==0xa9df:
  length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
  if length<64:active_word=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
 if pc==0xc388:glyph=dict(word=active_word,frame=sp,character=r[R.A],counter=m[0xa019],mode=m[0xc128],channel=m[0xa027],descriptor=r[R.D]*256+r[R.E],address=r[R.H]*256+r[R.L],shift=r[R.C],return_link=word(m,sp))
 op=m[pc];push=op in pushes or op in (0xdd,0xfd)and m[pc+1]==0xe5
 base=sp-2 if push else sp if op==0xe3 else None
 if base is not None:
  addresses=[a for a in (base,base+1)if a in targets]
  if addresses:pending=dict(addresses=addresses,after_sp=sp-2 if push else sp,tick=word(m,0x9fdd),command=command,pc=pc,sp=sp,actor=m[0xa036],registers=[r[i]for i in (R.A,R.F,R.B,R.C,R.D,R.E,R.H,R.L)],glyph=glyph,stack=[word(m,sp+i)for i in range(0,min(96,0x5d80-sp),2)])
 if pc in (0xd2cb,0xd2d0):
  at=(((r[R.IXh]<<8)|r[R.IXl])+(pc==0xd2d0))&65535
  if at in targets and word(m,0x9fdd)>=reference['steps'][3240]['clock']['tick']-1:
   reads.append(dict(tick=word(m,0x9fdd),command=command,actor=m[0xa036],address=f'{at:04X}',value=m[at],writer=last.get(at),count=counts[at]))
   output=dict(protocol='Original seed1 extra-LOOK route, all actors, graphics native from boot, free opening LOOK. Observe PUSH/CALL/RST/index PUSH and EX(SP),HL, including same-value stores; independently record changed bytes not explained by those operations. No CPU code in browser engine.',source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),handover=handover,reads=reads,unclassified_transitions=unclassified)
   (root/'results/narrow-arrival-descriptor/next-stack23.json').write_text(json.dumps(output,indent=2)+'\n')
   print('READ',word(m,0x9fdd),hex(at),m[at],flush=True)
   if at==0x5d23:raise SystemExit()
 previous=pc
w.observer=observe
for index,command in enumerate(route[start:],start):
 w.submit(command,g.explored)
 if index%15==0:print(index,w.clock(),flush=True)
