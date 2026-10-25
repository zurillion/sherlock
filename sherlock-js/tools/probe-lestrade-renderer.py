"""Offline renderer trace for a natural original-engine continuation.

First run probe-lestrade.py on the natural reference's first --after commands
to create the external native prompt checkpoint. This tool restores that
original prompt, runs all intervening original commands with all actors active,
then observes the chosen step. No world overlays or NPC suppression.
"""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser()
ap.add_argument('--state',type=Path,default=Path('/private/tmp/lestrade-native-state.json'))
ap.add_argument('--fixture',type=Path,default=Path('test/fixtures/lestrade-natural-reference.json'))
ap.add_argument('--after',type=int,default=67)
ap.add_argument('--step',type=int,default=146)
ap.add_argument('--output',type=Path,default=Path('results/lestrade/renderer146-natural.json'))
args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
reference=json.loads(args.fixture.read_text());saved=json.loads(args.state.read_text())
assert 0<args.after<args.step<=len(reference['steps'])
g=Game(p,extract(p),seed=reference['seed'],active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers=r[:];w.input_stack=m[0x5d00:0x5d80]
assert w.clock()==reference['steps'][args.after-1]['after']['clock'],'Wrong checkpoint'
for row in reference['steps'][args.after:args.step-1]:
 assert row['kind']=='command';g.command(row['input'])
cells=[0x5cee,0x5cf5,*range(0x5d00,0x5d10)];previous={a:m[a]for a in cells}
last=None;writes=[];glyphs=[]
def observe(m,r,R):
 global last
 pc=r[R.PC]
 for a in cells:
  if m[a]!=previous[a]:
   previous[a]=m[a];writes.append(dict(at=f'{a:04X}',value=m[a],writer=f'{last:04X}'if last else None,frame=r[R.SP],word=bytes(m[0x5c0b:0x5c38]).decode('latin1')))
 if pc==0xc388 and r[R.SP]<=0x5d30:glyphs.append(dict(frame=r[R.SP],character=r[R.A],word=bytes(m[0x5c0b:0x5c38]).decode('latin1')))
 last=pc
w.observer=observe;row=reference['steps'][args.step-1];out=g.command(row['input'])
bitmap=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
assert hashlib.sha256(bitmap).hexdigest()==row['after']['upper_sha256'],'Different source screen'
assert w.clock()==row['after']['clock']
args.output.write_text(json.dumps(dict(scope='Natural original-engine continuation, all actors active, no overlays; offline diagnostic only.',checkpoint_after=args.after,observed_step=args.step,command=row['input'],clock=w.clock(),messages=out['messages'],writes=writes,glyphs=glyphs,after={f'{a:04X}':m[a]for a in cells}),indent=2)+'\n')
print('Verified native screen and clock at step',args.step,flush=True)
