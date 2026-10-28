import sys,json,time,gzip,hashlib
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;last=m[0x5d13];previous=None;changes=[];reads=[];glyph=None
changes.append(dict(initial=True,value=last,clock=w.clock()))
def obs(m,r,R):
 global last,previous,glyph
 pc=r[R.PC];sp=r[R.SP]
 if pc==0xc388:glyph=dict(char=r[R.A],sp=sp,bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],clock=w.clock(),actor=m[0xa036])
 if m[0x5d13]!=last:
  last=m[0x5d13];changes.append(dict(value=last,writer=previous,pc=f'{pc:04X}',sp=f'{sp:04X}',clock=w.clock(),actor=m[0xa036],glyph=glyph));print('change',changes[-1],flush=True)
 if pc in(0xd2cb,0xd2d0):
  a=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if a in(0x5d12,0x5d13):reads.append(dict(address=f'{a:04X}',value=m[a],clock=w.clock(),actor=m[0xa036],last_change=len(changes)-1));print('read',reads[-1],flush=True)
 previous=dict(pc=f'{pc:04X}',sp=f'{sp:04X}',a=r[R.A],f=r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],return_word=word(m,sp)if sp<65535 else None)
w.observer=obs
for command in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 if command.startswith('WAIT UNTIL'):
  out=g.start_command(command)
  while out['running'] and w.clock()['tick']<1371:out=g.continue_command(out['job'])
 else:out=g.command(command)
 print('command',command,w.clock()['label'],flush=True)
 if w.clock()['tick']>=1371 or w.ended:break
raw=json.dumps(dict(scope='Natural major-witness seed 1, all actors, watches writes to 5D13 from startup; graphics off after boot, native input protocol.',changes=changes,reads=reads),indent=2).encode()+b'\n'
root=p/'sherlock-js/results/transient-inputs';root.joinpath('stack-writer-trace.json.gz').write_bytes(gzip.compress(raw,mtime=0));root.joinpath('stack-writer-trace.json').write_text(json.dumps(dict(scope='Natural original source trace; offline only.',changes_count=len(changes),last_changes=changes[-6:],reads=reads,raw_sha256=hashlib.sha256(raw).hexdigest()),indent=2)+'\n')
