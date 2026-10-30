"""Natural A022/A023 dictionary-reference writers; original is an offline oracle."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
catalog=extract(p);g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;events=[];reads=[];last=None;steps=[]
def obs(m,r,R):
 global last
 pc=r[R.PC]
 if pc in (0xa88c,0xa8b5):
  value=(r[R.D]*256+r[R.E])if pc==0xa88c else r[R.H]*256+r[R.L]
  last=dict(pc=f'{pc:04X}',value=value,actor=m[0xa036],tick=word(m,0x9fdd),visible=m[0x5c3c],stack_top=f'{word(m,r[R.SP]):04X}')
  events.append(last)
 if pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
  if at in(0xa022,0xa023):
   row=dict(address=f'{at:04X}',value=m[at],clock=w.clock(),actor=m[0xa036],last_store=last);reads.append(row);print('READ',row,flush=True)
w.observer=obs
for command in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while out.get('running')and w.clock()['tick']<2871:out=g.continue_command(out['job'])
 steps.append(dict(input=command,clock=w.clock(),value=word(m,0xa022),last_store=last,events=events[:]));events.clear();print(command,w.clock()['label'],last,flush=True)
 if w.clock()['tick']>=2871 or w.ended:break
out=p/'sherlock-js/results/dictionary-reference';out.mkdir(exist_ok=True)
(out/'natural-writers.json').write_text(json.dumps(dict(protocol='Natural seed1 major-witness, all24 actor slots, free initial LOOK, graphics off after boot, injected uppercase keys, immediate MORE. Both absolute word stores including unchanged writes; no world patches. Offline evidence only.',steps=steps,reads=reads),separators=(',',':'))+'\n')
