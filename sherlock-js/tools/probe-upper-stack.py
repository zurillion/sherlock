"""Natural source writers to 5D1F, before the previously observed late interval."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;old=m[0x5d1f];prev=None;glyph=None;changes=[];steps=[];last_writer=None

def obs(m,r,R):
 global old,prev,glyph,last_writer
 pc=r[R.PC];sp=r[R.SP]
 if m[0x5d1f]!=old:
  old=m[0x5d1f];last_writer=dict(value=old,writer=prev,glyph=glyph,actor=m[0xa036],tick=w.clock()['tick']);changes.append(last_writer);changes[:]=changes[-15:]
 if pc==0xc388:glyph=dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E])
 # Only retain register details at a push which can own the target byte.
 if sp==0x5d20:prev=dict(pc=f'{pc:04X}',sp=f'{sp:04X}',af=r[R.A]*256+r[R.F],bc=r[R.B]*256+r[R.C],de=r[R.D]*256+r[R.E],hl=r[R.H]*256+r[R.L])
 else:prev=dict(pc=f'{pc:04X}',sp=f'{sp:04X}')
w.observer=obs
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 if c.startswith('WAIT UNTIL'):
  out=g.start_command(c)
  while out['running'] and w.clock()['tick']<2501:out=g.continue_command(out['job'])
 else:out=g.command(c)
 steps.append(dict(input=c,clock=w.clock(),cells=list(m[0x5d1a:0x5d20]),last_writer=last_writer,changes=changes[:]));changes.clear();print(c,w.clock()['label'],last_writer,flush=True)
 if w.clock()['tick']>=2501 or w.ended:break
root=p/'sherlock-js/results/upper-stack';root.mkdir(exist_ok=True);root.joinpath('natural-writers.json').write_text(json.dumps(dict(protocol='Natural seed1 major-witness; all 24 actor slots, free boot LOOK, graphics off after boot, injected uppercase keys and immediate MORE. No actor/world patches. Changes record value transitions, not identical-value stores. Observer starts after boot, follows all commands through target tick2501.',steps=steps),separators=(',',':'))+'\n')
