"""Last-writer provenance for model flags along the natural witness history."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;last=None;stores=[];reads=[];steps=[]
def obs(m,r,R):
 global last
 pc=r[R.PC]
 if pc==0xa2e0:
  last=dict(writer='A2E0',caller=f'{word(m,r[R.SP]):04X}',model=f'{(r[R.IXh]*256+r[R.IXl]):04X}',flags=[r[R.A],m[0xa01e]],actor=m[0xa036],tick=word(m,0x9fdd));stores.append(last)
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in(0xa01d,0xa01e):reads.append(dict(address=f'{at:04X}',value=m[at],actor=m[0xa036],clock=w.clock(),last_writer=last))
w.observer=obs
for command in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while True:
  steps.append(dict(input=command,flags=list(m[0xa01d:0xa01f]),clock=w.clock(),last_writer=last,running=bool(out.get('running'))));command=None
  if not out.get('running')or w.clock()['tick']>=2951:break
  out=g.continue_command(out['job'])
 if w.clock()['tick']>=2951 or w.ended:break
root=p/'sherlock-js/results/model-flags';root.mkdir(exist_ok=True)
(root/'natural-stores.json').write_text(json.dumps(dict(protocol='Natural seed1 witness, all24 actors, free initial LOOK, graphics off, uppercase injected keys/immediate MORE. All raw A2E0 stores including unchanged writes and A01D/E reads; no patches to world or actors. Offline provenance, not a whole-game certificate.',steps=steps,stores=stores,reads=reads),separators=(',',':'))+'\n');print('checkpoints',len(steps),'stores',len(stores),'reads',reads,flush=True)
