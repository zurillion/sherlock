import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
catalog=extract(p);g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;pointer=[]
for classes,args in [([7,4],[40,20]),([0,0],[2,3]),([7,4],[254,255]),([12,4],[8,16]),([5,13],[254,31])]:
 m[0xa00f:0xa011]=classes;m[0xa034:0xa036]=args;w.call(0xc8ef);pointer.append(dict(classes=classes,args=args,values=[word(m,0xa013),word(m,0xa015)]))
statements=[]
for commands in [['SAY WATSON "BASIL HAS PLANS"','I'],['SAY WATSON "DOOR HAS PLANS"','I'],['SAY WATSON "LAMP VISIT DOOR"','I'],['SAY WATSON "YOUR DOOR HAS PLANS"','I'],['SAY WATSON "MAJOR VISIT OPIUM DEN AND MAJOR IS INNOCENT"','I']]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;steps=[]
 for c in commands:
  out=g.command(c);steps.append(dict(input=c,values=list(m[0xba13:0xba1c])))
 statements.append(steps)
lexical=[]
for commands in [['WAIT UNTIL 11PM','WAIT UNTIL 7AM'],['LOOK','1234','I'],['OPEN DOOR','YOUR','I'],['XYZZY','I']]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;steps=[]
 for c in commands:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  steps.append(dict(input=c,values=list(m[0xdc13:0xdc15])))
  if out.get('running'):out=g.continue_command(out['job'],interrupt=True)
 lexical.append(steps)
p.joinpath('sherlock-js/test/fixtures/transient-reference.json').write_text(json.dumps(dict(protocol='Controlled C8EF argument register inputs; natural fresh seed-1 SAY/lexical commands with all 24 actor slots, free initial LOOK and graphics off after boot. WAIT UNTIL observed at first minute then interrupted to bound this fixture. Not a full-ending certificate.',pointer=pointer,statements=statements,lexical=lexical),separators=(',',':'))+'\n');print('generated',len(pointer),len(statements),len(lexical))
