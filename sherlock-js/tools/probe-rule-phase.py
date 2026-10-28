import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
d=json.loads((p/'sherlock-js/data/game.json').read_text());catalog=extract(p);rows=[]
for name,args in [('counter.delete',[255,255]),('entity.samePlace',[0,0]),('entity.at',[0,105]),('entity.samePlace',[255,0])]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;at=int(d['npcPrograms']['rules'][name]['source'],16);m[0xa036]=0;m[0xa033:0xa036]=[255,*args];r[R.H]=at>>8;r[R.L]=at&255;events=[]
 def obs(m,r,R):
  if r[R.PC] in [0xc59b,0xc5f6,0xc9f2]:events.append(dict(pc=f'{r[R.PC]:04X}',phase=m[0xa00b],arguments=list(m[0xa034:0xa036])))
 w.observer=obs;out=w.call(0xc591);rows.append(dict(rule=name,args=args,success=not out['z'],phase=m[0xa00b],events=events));print(rows[-1])
p.joinpath('sherlock-js/test/fixtures/rule-phase-reference.json').write_text(json.dumps(dict(protocol='Controlled offline C591 call from fresh seed-1 boot, actor Holmes, all actor slots retained. Explicit rule/arguments only; not a natural ending certificate.',cases=rows),indent=2)+'\n')
