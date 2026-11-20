"""Original Sherlock1984: natural prompt before the platform-two arrival; optional verified handover."""
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
cache=Path(sys.argv[1])if len(sys.argv)>1 else None;start=0;handover=None
if cache and cache.exists():
 saved=json.loads(gzip.decompress(cache.read_bytes()));assert saved['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
 m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);start=saved['next']
 assert word(m,0x9fdd)==2286 and route[start]=='WEAR CHINA MANS DISGUISE'
 checkpoint=reference['steps'][2004];assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room']
 picture=bytearray()
 for y in range(144):
  at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
 picture.extend(m[0x5800:0x5a40]);video=hashlib.sha256(picture).hexdigest()
 assert video==checkpoint['video'] and m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']
 handover=dict(sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),tick=word(m,0x9fdd),next_command=start,original_checkpoint=2004,clock_room_video_counter_and_mode_match=True,video=video)
target=sum(bool(s['command'])for s in reference['steps'][:2780]);assert route[target]=='NE'
for index,command in enumerate(route[start:],start):
 if index==target:
  picture=bytearray()
  for y in range(144):
   at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
  picture.extend(m[0x5800:0x5a40]);checkpoint=reference['steps'][2779]
  assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room'] and hashlib.sha256(picture).hexdigest()==checkpoint['video']
  data=dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),clock=w.clock(),next=index,memory=m[:],registers=r[:],input_registers=w.input_registers[:],input_stack=w.input_stack[:],explored=sorted(g.explored),original_checkpoint=2779,video=checkpoint['video'])
  (root/'results/full-arrival-exits/pre-ne-prompt.json.gz').write_bytes(gzip.compress(json.dumps(data,separators=(',',':')).encode(),mtime=0));(root/'results/full-arrival-exits/prompt-provenance.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),handover=handover,original_checkpoint=2779,next_command=index,clock=w.clock(),room=w.room,video=checkpoint['video'],counter=m[0xa019],narrow=m[0xc128]),indent=2)+'\n');print('SAVED',index,w.clock(),flush=True);break
 w.submit(command,g.explored)
 if index%15==0:print(index,w.clock(),flush=True)
