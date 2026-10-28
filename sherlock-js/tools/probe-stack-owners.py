import sys,json,collections
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;lo=0x5d12;hi=0x5d1a;old=m[lo:hi];previous=None;glyph=None;writers={};reads=[]
def observe(m,r,R):
 global old,previous,glyph
 pc=r[R.PC]
 if pc==0xc388:glyph=dict(frame=r[R.SP],char=r[R.A],column_shift=r[R.C],caller_count=r[R.B],de=word([r[R.E],r[R.D]],0),hl=word([r[R.L],r[R.H]],0))
 now=m[lo:hi]
 if old!=now:
  for i,value in enumerate(now):
   if value!=old[i]:writers[f'{lo+i:04X}']=dict(value=value,writer=previous,clock=w.clock(),actor=m[0xa036],glyph=glyph)
  old=now[:]
 if pc in(0xd2cb,0xd2d0):
  a=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if lo<=a<hi:reads.append(dict(address=f'{a:04X}',value=m[a],clock=w.clock(),writer=writers.get(f'{a:04X}')))
 previous=f'{pc:04X}'
w.observer=observe
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and w.clock()['tick']<1561:out=g.continue_command(out['job'])
 print(c,w.clock()['label'],flush=True)
 if w.clock()['tick']>=1561 or w.ended:break
p.joinpath('sherlock-js/results/transient-inputs/stack-owners-reference.json').write_text(json.dumps(dict(scope='Natural seed1, all actors, graphics off after boot; source writes through Tue10:00. Last changes are observed, not runtime inputs.',writers=writers,reads=reads,clock=w.clock()),indent=2)+'\n')
