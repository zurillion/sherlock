"""Allocation lifetimes in ordinary parsing and actor requests; offline only."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);g.world.m[0xa011]=0;g.teleport(5);pending=[];events=[]
def observe(m,r,R):
 pc=r[R.PC]
 for event in pending[:]:
  if pc==event['return']and r[R.SP]==event['sp']+2:event['pointer']=r[R.IXh]*256+r[R.IXl];pending.remove(event)
 if pc==0xa11c:
  event=dict(op='allocate',size=r[R.A],caller=f'{word(m,r[R.SP]):04X}',actor=m[0xa036],return_=word(m,r[R.SP]),sp=r[R.SP]);event['return']=event.pop('return_');pending.append(event);events.append(event)
 if pc==0xa1c7:events.append(dict(op='release',pointer=r[R.IXh]*256+r[R.IXl],caller=f'{word(m,r[R.SP]):04X}',actor=m[0xa036]))
g.world.observer=observe
for c in ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','WAIT']:
 events.clear();g.command(c);print(c,json.dumps(events),flush=True)
