"""Offline output-workspace last writers, never consumed by the JS engine."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
ap=argparse.ArgumentParser();ap.add_argument('history');ap.add_argument('--output',required=True);ap.add_argument('--from-command',type=int,default=0);ap.add_argument('--through-tick',type=int);ap.add_argument('--cells',default='5D08:5D12');a=ap.parse_args();base=p/'sherlock-js'
lo,hi=[int(x,16)for x in a.cells.split(':')];assert 0<=lo<hi<=65536
commands=[x for x in(base/a.history).read_text().splitlines()if x and not x.startswith('#')]
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;old=None;previous=None;glyph=None;changes={};samples=[]
def observe(m,r,R):
 global old,previous,glyph
 if r[R.PC]==0xc388:
  glyph=dict(character=chr(r[R.A]),sp=f'{r[R.SP]:04X}',descriptor=f'{r[R.D]*256+r[R.E]:04X}',bc=f'{r[R.B]*256+r[R.C]:04X}')
  if not samples or samples[-1]['sp']!=glyph['sp']:samples.append(glyph)
  del samples[:-80]
 now=m[lo:hi]
 if old is not None:
  for i,(before,value)in enumerate(zip(old,now)):
   if before!=value:changes[f'{lo+i:04X}']=dict(value=value,writer=previous,glyph=glyph,clock=w.clock())
 old=now[:];previous=f'{r[R.PC]:04X}'
for i,c in enumerate(commands):
 if i>=a.from_command:w.observer=observe
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running'):
  if a.through_tick is not None and w.clock()['tick']>=a.through_tick:break
  out=g.continue_command(out['job'])
 result=dict(protocol='Offline seed 1; all actors; graphics off after boot; injected uppercase keys and immediate MORE. No actor/proof/PC patches.',history=a.history,from_command=a.from_command,through_command=i,clock=w.clock(),last_writes=changes,glyph_frame_transitions=samples,current_cells={f'{at:04X}':m[at]for at in range(lo,hi)})
 (base/a.output).write_text(json.dumps(result,indent=2)+'\n');print(i,c,w.clock()['label'],flush=True)
 if w.ended or a.through_tick is not None and w.clock()['tick']>=a.through_tick:break
