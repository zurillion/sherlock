import sys,json,collections
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;writes=collections.deque(maxlen=40);found=[]
def observe(m,r,R):
 pc=r[R.PC]
 if pc in(0xc908,0xc924):writes.append(dict(cell='A013'if pc==0xc908 else'A015',value=r[R.IXh]*256+r[R.IXl],args=list(m[0xa034:0xa036]),classes=list(m[0xa00f:0xa011]),action=m[0xa033],actor=m[0xa036],clock=w.clock(),caller=[word(m,a)for a in range(r[R.SP],min(0x5d80,r[R.SP]+12),2)]))
 if pc in(0xd2cb,0xd2d0):
  a=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if 0xa013<=a<0xa017:found.append(dict(address=f'{a:04X}',value=m[a],clock=w.clock(),actor=m[0xa036],writes=list(writes)));print('READ',found[-1],flush=True)
w.observer=observe
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running') and not found:out=g.continue_command(out['job'])
 print(c,w.clock()['label'],flush=True)
 if found or w.ended:break
p.joinpath('sherlock-js/results/transient-inputs/argument-pointer-trace.json').write_text(json.dumps(dict(scope='Offline original major-witness natural seed-1 history; all actors, no state patches; graphics off after boot.',reads=found),indent=2)+'\n')
