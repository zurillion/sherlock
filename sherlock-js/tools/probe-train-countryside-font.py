"""Offline Sherlock1984: natural train departure, countryside description and saved final font row."""
import gzip,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
outdir=root/'results/train-countryside-font';outdir.mkdir(exist_ok=True)
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz';ref=json.loads(gzip.decompress(source.read_bytes()))
cache=root/'results/narrow-arrival-descriptor/pre-north-prompt.json.gz';saved=json.loads(gzip.decompress(cache.read_bytes()))
assert saved['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored'])
route=[s['command']for s in ref['steps']if s['command']]
def snapshot(**extra):return dict(memory=m[:],registers=r[:],input_registers=w.input_registers[:],input_stack=w.input_stack[:],explored=sorted(g.explored),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),clock=w.clock(),**extra)
def packed(name,s): (outdir/name).write_bytes(gzip.compress(json.dumps(s,separators=(',',':')).encode(),mtime=0))
for command in route[sum(bool(s['command'])for s in ref['steps'][:3112]):]:
 if command=='WAIT UNTIL 7:29PM' and word(m,0x9fdd)==3499:
  checkpoint=ref['steps'][3203];assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room']
  picture=bytearray()
  for y in range(144):
   at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
  picture.extend(m[0x5800:0x5a40]);assert hashlib.sha256(picture).hexdigest()==checkpoint['video']
  assert m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']
  packed('pre-wait-prompt.json.gz',snapshot(original_checkpoint=3203));break
 w.submit(command,g.explored)
else:raise AssertionError('Natural LOOK source not reached')
glyphs=[];calls=[];active_word='';entries=set();prose_return=None;prose_cells=None
def observe(m,r,R):
 global active_word,prose_return,prose_cells
 pc=r[R.PC];sp=r[R.SP];tick=word(m,0x9fdd)
 if tick!=3504:return
 if pc==0xa59f and r[R.H]*256+r[R.L]==0x7e45 and 'prose'not in entries:
  packed('prose-entry.json.gz',snapshot(entry='A59F',sp=sp));entries.add('prose');prose_return=word(m,sp)
 if prose_return is not None and pc==prose_return and prose_cells is None:prose_cells={f'{a:04X}':m[a]for a in range(0x5d1a,0x5d2c)}
 if pc==0xa9df:
  length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
  if length<64:active_word=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
 if pc in (0xd102,0xd113,0xd178,0xa59f,0xa887,0xa9b7):calls.append(dict(pc=f'{pc:04X}',sp=sp,a=r[R.A],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L]))
 if pc==0xc388:
  glyphs.append(dict(char=chr(r[R.A]),frame=sp,word=active_word,descriptor=r[R.D]*256+r[R.E],counter=m[0xa019],mode=m[0xc128],column_remaining=m[0xc1f5]))
w.observer=observe;result=w.submit('WAIT UNTIL 7:29PM',g.explored)
(outdir/'departure-detail.json').write_text(json.dumps(dict(protocol='Original seed1 extra-LOOK route from verified checkpoint3203;all24actors,native graphics,free initial LOOK,immediate MORE. Full WAIT UNTIL7:29PM; record tick3504 train departure description only. No controlled overlays.',source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),source_cache_sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),original_checkpoint=3203,messages=result['messages'],clock=w.clock(),calls=calls,glyphs=glyphs,cells_after_prose=prose_cells,cells_after_complete_wait={f'{a:04X}':m[a]for a in range(0x5d1a,0x5d2c)}),indent=2)+'\n')
print('WAIT',w.clock(),len(glyphs),'glyphs',flush=True)
