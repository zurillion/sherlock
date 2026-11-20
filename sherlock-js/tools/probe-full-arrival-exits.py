"""Original Sherlock1984: trace active word length, text calls and glyph stack records for NE."""
import sys,gzip,json,hashlib
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
cache=(root/'results/full-arrival-exits/pre-ne-prompt.json.gz');s=json.loads(gzip.decompress(cache.read_bytes()));g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers
m[:]=s['memory'];r[:]=s['registers'];w.input_registers[:]=s['input_registers'];w.input_stack[:]=s['input_stack'];g.explored=set(s['explored']);glyphs=[];calls=[];entry=None;active_word=""
source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz'
reference=json.loads(gzip.decompress(source.read_bytes()))
assert s['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
checkpoint=reference['steps'][2779]
picture=bytearray()
for y in range(144):
 at=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2);picture.extend(m[at:at+32])
picture.extend(m[0x5800:0x5a40])
assert w.clock()==checkpoint['clock'] and w.room==checkpoint['room'] and hashlib.sha256(picture).hexdigest()==checkpoint['video']
assert m[0xa019]==checkpoint['counter'] and m[0xc128]==checkpoint['narrow']


def observe(m,r,R):
 global entry,active_word
 pc=r[R.PC];sp=r[R.SP]
 if pc==0xd68c and entry is None:
  entry=dict(entry='D68C',memory=m[:],registers=r[:],source_sha256=s['source_sha256'],clock=w.clock(),sp=sp)
  (root/'results/full-arrival-exits/d68c-entry.json.gz').write_bytes(gzip.compress(json.dumps(entry,separators=(',',':')).encode(),mtime=0))
 if pc==0xa9df:
  length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
  if length<64:active_word=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
 if pc in (0xd68c,0xd1b2,0xd102,0xa59f,0xd6a6)or pc==0xa9b7 and r[R.A]==13:calls.append(dict(pc=f'{pc:04X}',sp=sp,hl=r[R.H]*256+r[R.L],a=r[R.A],actor=m[0xa036],tick=word(m,0x9fdd)))
 if pc==0xc388:
  glyphs.append(dict(char=chr(r[R.A]),frame=sp,actor=m[0xa036],tick=word(m,0x9fdd),active_word=active_word,buffer_residue=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'),buffer_pointer=word(m,0xa9b5),column_remaining=m[0xc1f5],counter=m[0xa019],mode=m[0xc128],descriptor=r[R.D]*256+r[R.E],shift=r[R.C],stack=[word(m,a)for a in range(sp,0x5d80,2)]))
w.observer=observe;out=w.submit('NE',g.explored)
(root/'results/full-arrival-exits/natural-ne-detail.json').write_text(json.dumps(dict(source_cache_sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),source_sha256=s['source_sha256'],original_checkpoint=2779,command='NE',messages=out['messages'],clock=w.clock(),calls=calls,glyphs=glyphs,cells={f'{a:04X}':m[a]for a in range(0x5d1a,0x5d2c)}),indent=2)+'\n');print(out['messages'],len(glyphs),flush=True)
