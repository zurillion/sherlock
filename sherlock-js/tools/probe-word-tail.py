import sys,json,collections
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;changes=collections.deque(maxlen=40);old=m[0x5c15];previous=None;found=[]
def observe(m,r,R):
 global old,previous
 pc=r[R.PC]
 if m[0x5c15]!=old:
  old=m[0x5c15];changes.append(dict(value=old,writer=previous,word=list(m[0x5c0b:0x5c30]),clock=w.clock(),actor=m[0xa036],visible=m[0x5c3c]))
 if pc in(0xd2cb,0xd2d0):
  a=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if a==0x5c15:found.append(dict(value=m[a],clock=w.clock(),actor=m[0xa036],writes=list(changes)));print('READ',found[-1],flush=True)
 previous=f'{pc:04X}'
w.observer=observe
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running') and not found:out=g.continue_command(out['job'])
 print(c,w.clock()['label'],flush=True)
 if c=='WAIT UNTIL 7AM':Path('/private/tmp/witness-native-7am.json').write_text(json.dumps(dict(memory=m[:],registers=w.sim.registers[:],input_registers=w.input_registers,input_stack=w.input_stack,explored=list(g.explored),last_listed=g.last_listed)))
 if found or w.ended:break
p.joinpath('sherlock-js/results/transient-inputs/word-tail-trace.json').write_text(json.dumps(dict(scope='Natural original major-witness seed1, all actors, graphics off after boot; first actual RNG read of 5C15 and source writes.',reads=found),indent=2)+'\n')
