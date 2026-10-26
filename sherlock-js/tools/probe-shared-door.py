"""Offline proof of distant shared-door notifications; no runtime dependency."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;pending=[]
record=lambda ident:word(w.m,0x8b70+3*ident)
q=record(50)
result=dict(protocol='Seed 1, all 24 actors, free initial LOOK, graphics off after startup, uppercase injected keys, immediate MORE, no idle timeout; no teleports.',commands=['WAIT UNTIL 11','WAIT UNTIL 11PM'],stop='Mon 01:07pm',door_record=dict(id=50,address=f'{q:04X}',bytes=list(w.m[q:q+15+w.m[q]]),rooms=list(w.m[q+15:q+15+w.m[q]])),events=[],frames=[])
def observe(m,r,R):
 if r[R.PC]==0xcaf0:
  actor=m[0xa036];pending.append(dict(time=w.clock()['label'],actor=actor,actor_name=g.entities[actor]['name'],actor_room=m[record(actor)+15],door=m[0xa034],action=m[0xa033],player_room=m[0xa009]))
w.observer=observe
for command in result['commands']:
 out=g.start_command(command)
 while True:
  if pending:
   result['events'].extend(pending);result['frames'].append(dict(events=pending[:],after=snapshot(w),messages=out['messages']));pending.clear()
  if not out['running']:break
  out=g.continue_command(out['job'],interrupt=w.clock()['label']==result['stop'])
  if not out['running'] and w.clock()['label']==result['stop']:break
 print(command,w.clock()['label'],flush=True)
args.output.write_text(json.dumps(result,separators=(',',':'))+'\n');print(len(result['events']),'shared-door notification attempts (CB01 still filters them)',flush=True)
