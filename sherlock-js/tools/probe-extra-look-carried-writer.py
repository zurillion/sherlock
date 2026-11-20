"""Trace original Sherlock (1984) game stack writes along the extra-LOOK history."""
import gzip,hashlib,json,sys
from collections import deque
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz'
ref=json.loads(gzip.decompress(source.read_bytes()))
route=[s['command'] for s in ref['steps'] if s['command']]
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;R=w.R
lo,hi=0x5d1a,0x5d2c
last={};history=deque(maxlen=120);glyph=None;cmd=None;counts={a:0 for a in range(lo,hi)}
reads=[];cache=Path(sys.argv[1]) if len(sys.argv)>1 else None;start=0
if cache and cache.exists():
 c=json.loads(gzip.decompress(cache.read_bytes()))
 assert c['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
 w.m[:]=c['memory'];w.sim.registers[:]=c['registers'];w.input_registers[:]=c['input_registers'];w.input_stack[:]=c['input_stack'];g.explored=set(c['explored']);start=c['next'];last={int(k):v for k,v in c['last'].items()};counts={int(k):v for k,v in c['counts'].items()};glyph=c['glyph']
pushes={0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc,0xc7,0xcf,0xd7,0xdf,0xe7,0xef,0xf7,0xff}
def hook(op,original):
 def run():
  global glyph
  m,r=w.m,w.sim.registers;pc=r[R.PC];sp=r[R.SP];a=None
  if pc==0xc388:
   glyph=dict(frame=sp,character=r[R.A],counter=m[0xa019],mode=m[0xc128],buffer=bytes(m[0x5c0b:0x5c27]).hex(),descriptor=(r[R.D]<<8)|r[R.E],return_link=word(m,sp))
  if pc in (0xd2cb,0xd2d0):
   a=(((r[R.IXh]<<8)|r[R.IXl])+(pc==0xd2d0))&65535
   if lo<=a<hi and word(m,0x9fdd)>=2178:
    reads.append(dict(tick=word(m,0x9fdd),command=cmd,actor=m[0xa036],address=f'{a:04X}',value=m[a],writer=last.get(a),count=counts[a]))
    (root/'results/extra-look-carried-scan/stack-writers.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),reads=reads,history=list(history)),indent=2))
    print('READ',word(m,0x9fdd),hex(a),m[a],flush=True)
  is_push=op in pushes or op in (0xdd,0xfd) and m[pc+1]==0xe5
  watched=is_push and lo<=sp-1<hi
  if watched:
   before=dict(tick=word(m,0x9fdd),command=cmd,pc=pc,sp=sp,actor=m[0xa036],registers=[r[i] for i in (R.A,R.F,R.B,R.C,R.D,R.E,R.H,R.L)],glyph=glyph,stack=[word(m,sp+i) for i in range(0,32,2)])
  original()
  if watched and r[R.SP]==sp-2:
   for at in (sp-2,sp-1):
    if lo<=at<hi:
     event={**before,'address':f'{at:04X}','value':m[at]}
     last[at]=event;counts[at]+=1;history.append(event)
 return run
for op in pushes|{0xdd,0xfd}:w.sim.opcodes[op]=hook(op,w.sim.opcodes[op])
for index,cmd in enumerate(route[start:],start):
 out=w.submit(cmd,g.explored);tick=word(w.m,0x9fdd)
 if tick in (1542,1771,2286,2940) or cmd=='LOOK' and tick>1700:
  c=dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),memory=list(w.m),registers=list(w.sim.registers),input_registers=list(w.input_registers),input_stack=list(w.input_stack),explored=sorted(g.explored),next=index+1,last=last,counts=counts,glyph=glyph,clock=w.clock())
  if cache:cache.write_bytes(gzip.compress(json.dumps(c,separators=(',',':')).encode()))
 if index%15==0 or tick>=1700:print(index,tick,cmd,flush=True)
 if reads:break
