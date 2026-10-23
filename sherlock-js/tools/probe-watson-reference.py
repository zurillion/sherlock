"""Offline reference capture: selected actors only, historical first prompt, no CPU in JS."""
import sys,json,argparse
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();p=args.project
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
D=extract(p)
cases={
 'take_and_drop_follow':['SAY TO WATSON "TAKE LAMP"','SAY TO WATSON "DROP THE DAILY CHRONICLE"','OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH'],
 'explicit_follow':['SAY TO WATSON "FOLLOW ME"','OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH'],
 'multiple_orders':['SAY TO WATSON "OPEN YOUR DOOR. WEST"','WAIT'],
 'wait_order':['SAY TO WATSON "WAIT"','LOOK','LOOK','LOOK','LOOK','LOOK'],
 'impossible':['SAY TO WATSON "TAKE ARMCHAIR"','SAY TO WATSON "WEST"','SAY TO WATSON "DROP LAMP"'],
 'all_doors':['SAY TO WATSON "OPEN ALL DOORS"','WAIT'],
 'greeting':['SAY TO WATSON "HELLO"'],
 'no_quote':['TALK TO WATSON'],
 'containers':['SIT IN YOUR ARMCHAIR','GET OUT OF YOUR ARMCHAIR','GET INTO WATSONS ARMCHAIR','GET OUT','CLIMB OUT OF WATSONS ARMCHAIR'],
 'drop_journal':['SAY TO WATSON "DROP DAILY CHRONICLE"','WAIT','WAIT'],
 'follow_timeout':['SAY TO WATSON "FOLLOW ME"','WAIT','WAIT','LOOK'],
 'reading_boundary':['WAIT','WAIT','WAIT','LOOK'],
 'silent_remote_order':['SAY TO WATSON "TAKE LAMP"','OPEN YOUR DOOR','WEST','SAY TO WATSON "DROP LAMP"'],
}
rows=[]
for label,commands in cases.items():
 g=Game(p,D,active_npcs=[3]);g.world.m[0xa037]=1;g.parser.put(g.world.sim,0xa039,0)
 def state():
  w=g.world;m=w.m;ents=[]
  for ident in [0,3,21,22,23,24,25]:
   q=word(m,0x8b70+3*ident);ents.append({'id':ident,'parent':None if m[q+1]==255 else m[q+1],'rooms':list(m[q+15:q+15+m[q]]),'attributes':m[q+5]})
  q=0x9870;counter=[];head=word(m,0x9fe5);seen=set()
  while head and head not in seen:
   seen.add(head);counter.append(list(m[head:head+2]));head=word(m,head-2)
  return {'entities':ents,'watson':{'due':word(m,q+6),'resume':f'{word(m,q+1):04X}','saved':list(m[q+3:q+6]),'counters':counter},'clock':w.clock()}
 trace={'label':label,'initial':state(),'commands':[]}
 for c in commands:
  out=g.command(c);r={'input':c,'messages':[{'kind':m['kind'],'text':m['text']} for m in out['messages'] if m['text']],'actions':g.last_analysis.get('actions',[]),'after':state()};trace['commands'].append(r)
  print(label,c,json.dumps(r,ensure_ascii=False),flush=True)
 rows.append(trace);args.output.write_text(json.dumps({'scope':'Historical prompt, free clock, seed set after boot, only Watson enabled; not full-game seed parity.','cases':rows},ensure_ascii=False,indent=2)+'\n')
