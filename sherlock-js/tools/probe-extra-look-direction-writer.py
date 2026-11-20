"""Original Sherlock (1984): last dictionary-descriptor writes before the morning read."""
import gzip,json,hashlib,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz';ref=json.loads(gzip.decompress(source.read_bytes()));route=[s['command']for s in ref['steps']if s['command']]
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
cache=Path(sys.argv[1])if len(sys.argv)>1 else None;start=0;handover=None
if cache and cache.exists():
 saved=json.loads(gzip.decompress(cache.read_bytes()));assert saved['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
 m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);start=saved['next']
 assert word(m,0x9fdd)==2286 and route[start]=='WEAR CHINA MANS DISGUISE'
 checkpoint=ref['steps'][2004];assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room']
 picture=bytearray()
 for y in range(144):
  at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
 picture.extend(m[0x5800:0x5a40]);video=hashlib.sha256(picture).hexdigest()
 assert video==checkpoint['video'] and m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']
 handover=dict(sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),tick=word(m,0x9fdd),next_command=start,original_checkpoint=2004,clock_room_video_counter_and_mode_match=True,video=video)
old=word(m,0xa022);pending=None;last=None;stores=[];unclassified=[];previous=None;command=None

def observe(m,r,R):
 global old,pending,last,previous
 pc=r[R.PC];value=word(m,0xa022)
 if pending:
  last={**pending,'value':value};stores.append(last);pending=None
 elif value!=old:unclassified.append(dict(pc=previous,value=value,tick=word(m,0x9fdd)))
 old=value
 if pc in (0xa88c,0xa8b5):
  sp=r[R.SP];pending=dict(tick=word(m,0x9fdd),command=command,actor=m[0xa036],pc=pc,sp=sp,channel=m[0xa027],enabled=m[0x5c3c],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],stack=[word(m,sp+i)for i in range(0,min(48,0x5d80-sp),2)])
 if pc in (0xd2cb,0xd2d0):
  at=(((r[R.IXh]<<8)|r[R.IXl])+(pc==0xd2d0))&65535
  if at==0xa022 and word(m,0x9fdd)>=2930:
   (root/'results/direction-rejection-reference/natural-writer.json').write_text(json.dumps(dict(handover=handover,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),read=dict(tick=word(m,0x9fdd),actor=m[0xa036],address='A022',value=m[at],descriptor=value,writer=last),stores=stores,unclassified_transitions=unclassified),indent=2));print('READ',word(m,0x9fdd),hex(value),last,flush=True);raise SystemExit()
 previous=pc
w.observer=observe
for index,command in enumerate(route[start:],start):
 w.submit(command,g.explored)
 if index%15==0:print(index,w.clock(),flush=True)
