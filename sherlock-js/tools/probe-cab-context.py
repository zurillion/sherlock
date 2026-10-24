import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;g.teleport(5)
def observe(m,r,R):
 pc=r[R.PC]
 if pc in (0xcf80,0xc9a7,0x9af6,0x9c43,0xb98c,0xca7f,0xca9a) and m[0xa036] in (0,31,34):
  row=word(m,0x9fdb);print(json.dumps(dict(pc=hex(pc),tick=word(m,0x9fdd),actor=m[0xa036],row=m[row] if row else None,origin=hex(word(m,0x9fd9)),args=list(m[0xa033:0xa036]),saved=list(m[0x9fd6:0x9fd9]),caller=hex(word(m,r[R.SP])))),flush=True)
w.observer=observe
for c in ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','WAIT','WAIT','WAIT']:
 print('COMMAND',c,flush=True);g.command(c)
