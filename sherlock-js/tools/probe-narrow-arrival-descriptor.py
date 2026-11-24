"""Offline Sherlock1984: natural pictured platform arrival, root object name and descriptor E."""
import gzip,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
outdir=root/'results/narrow-arrival-descriptor';outdir.mkdir(exist_ok=True)
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz';ref=json.loads(gzip.decompress(source.read_bytes()))
cache=root/'results/look-carried-descriptor/pre-look-prompt.json.gz';saved=json.loads(gzip.decompress(cache.read_bytes()))
assert saved['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored'])
route=[s['command']for s in ref['steps']if s['command']]
def snapshot(**extra):return dict(memory=m[:],registers=r[:],input_registers=w.input_registers[:],input_stack=w.input_stack[:],explored=sorted(g.explored),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),clock=w.clock(),**extra)
def packed(name,s): (outdir/name).write_bytes(gzip.compress(json.dumps(s,separators=(',',':')).encode(),mtime=0))
for command in route[sum(bool(s['command'])for s in ref['steps'][:3015]):]:
 if command=='N' and word(m,0x9fdd)==3411:
  checkpoint=ref['steps'][3111];assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room']
  picture=bytearray()
  for y in range(144):
   at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
  picture.extend(m[0x5800:0x5a40]);assert hashlib.sha256(picture).hexdigest()==checkpoint['video']
  assert m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']
  packed('pre-north-prompt.json.gz',snapshot(original_checkpoint=3111));break
 w.submit(command,g.explored)
else:raise AssertionError('Natural LOOK source not reached')
glyphs=[];calls=[];active_word='';entries=set()
def observe(m,r,R):
 global active_word
 pc=r[R.PC];sp=r[R.SP]
 if pc==0xd3e8 and r[R.SP]==0x5d42 and 'name' not in entries:
  packed('name-entry.json.gz',snapshot(entry='D3E8',sp=sp));entries.add('name')
 if pc==0xa9df:
  length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
  if length<64:active_word=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
 if pc in (0xd102,0xd526,0xd3e8,0xa815,0xa887,0xa9b7):
  calls.append(dict(pc=f'{pc:04X}',sp=sp,a=r[R.A],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L]))
  if pc==0xd102 and pc not in entries:packed('scene-entry.json.gz',snapshot(entry='D102',sp=sp));entries.add(pc)
 if pc==0xc388:
  row=dict(char=chr(r[R.A]),frame=sp,word=active_word,descriptor=r[R.D]*256+r[R.E],counter=m[0xa019],mode=m[0xc128],column_remaining=m[0xc1f5])
  glyphs.append(row)
  if sp==0x5d28 and r[R.A]==32 and r[R.D]*256+r[R.E]==0x58eb and 'separator' not in entries:
   packed('separator-entry.json.gz',snapshot(entry='C388',sp=sp));entries.add('separator')
w.observer=observe;result=w.submit('N',g.explored)
(outdir/'arrival-detail.json').write_text(json.dumps(dict(protocol='Original seed1 extra-LOOK route from verified checkpoint3111; all24actors,native graphics,free initial LOOK,immediate MORE. Capture N3112 at tick3411 into platform55 and its measured callers. No controlled overlays.',source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),source_cache_sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),original_checkpoint=3111,messages=result['messages'],clock=w.clock(),calls=calls,glyphs=glyphs,cells={f'{a:04X}':m[a]for a in range(0x5d1a,0x5d2c)}),indent=2)+'\n')
print('N',w.clock(),len(glyphs),'glyphs',flush=True)
