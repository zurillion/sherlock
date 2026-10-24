import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;g.teleport(5)
last=None;tracing=False
def observe(m,r,R):
 global last,tracing
 pc=r[R.PC]
 if last and tracing:
  prev,actor,args=last
  if actor!=m[0xa036] or args!=m[0xa035]:print('CHANGE',hex(prev),'actor',actor,'->',m[0xa036],'arg2',args,'->',m[0xa035],flush=True)
 if pc==0x9af6:tracing=True;print('TRAVEL',m[0xa036],flush=True)
 if pc==0xcf80 and tracing:tracing=False;print('DEFER',m[0xa036],list(m[0xa034:0xa036]),flush=True)
 last=(pc,m[0xa036],m[0xa035])
w.observer=observe
for c in ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','WAIT','WAIT','WAIT']:
 print('COMMAND',c,flush=True);g.command(c)
