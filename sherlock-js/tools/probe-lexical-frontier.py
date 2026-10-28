"""Last source writers at the next live random-input boundary. Offline only."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;last=m[0x5d1f];previous=None;changes=[];reads=[]
def obs(m,r,R):
 global last,previous
 pc=r[R.PC];sp=r[R.SP]
 if m[0x5d1f]!=last:
  last=m[0x5d1f];changes.append(dict(value=last,writer=previous,clock=w.clock(),actor=m[0xa036]));changes[:]=changes[-30:]
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in(0x5c1f,0x5d1f):reads.append(dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_changes=changes[-3:]));print('read',reads[-1],flush=True)
 previous=dict(pc=f'{pc:04X}',sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L],return_word=word(m,sp)if sp<65535 else None)
w.observer=None
for command in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 if command.startswith('WAIT UNTIL'):
  out=g.start_command(command)
  while out['running'] and w.clock()['tick']<2501:
   if w.clock()['tick']>=2400:w.observer=obs
   out=g.continue_command(out['job'])
 else:out=g.command(command)
 print('command',command,w.clock()['label'],flush=True)
 if w.clock()['tick']>=2501 or w.ended:break
root=p/'sherlock-js/results/lexical-workspace';root.mkdir(exist_ok=True);root.joinpath('next-frontier-trace.json').write_text(json.dumps(dict(scope='Natural major-witness seed1; original source observer, no actor/world patches. Last writers to 5D1F observed from tick 2400; earlier prefix runs without instrumentation. Not installed in runtime.',changes=changes,reads=reads),indent=2)+'\n')
