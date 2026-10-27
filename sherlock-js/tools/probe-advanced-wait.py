"""Natural two-wait history; retain clock checkpoints, every draw and output."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;calls=[];pending=None
result=dict(protocol='Natural seed-1 history, all actors, free initial LOOK, no teleports or patches; graphics off after boot, injected keys and immediate MORE.',commands=['WAIT UNTIL 11','WAIT UNTIL 11PM'],steps=[])
def observe(m,r,R):
 global pending
 pc=r[R.PC]
 if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
 if pending is not None and pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
 if pending is not None and pc==0xd2ec:
  v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
w.observer=observe
for command in result['commands']:
 out=g.start_command(command);first=True;messages=[]
 while True:
  messages.extend(out['messages'])
  if first or not out['running']or w.clock()['minute']%10==0 or any(m.get('text')for m in out['messages']):
   result['steps'].append(dict(input=command if first else None,after=snapshot(w),random=calls[:],messages=messages[:],running=out['running'],ending=w.ended,literal=word(w.m,0xa02f)));calls.clear();messages.clear();first=False
  if not out['running']:break
  out=g.continue_command(out['job'])
 print(command,w.clock()['label'],w.ended,flush=True)
 if w.ended:break
(p/'sherlock-js/test/fixtures/advanced-wait-reference.json').write_text(json.dumps(result,separators=(',',':'))+'\n');print(len(result['steps']),'checkpoint states',flush=True)
