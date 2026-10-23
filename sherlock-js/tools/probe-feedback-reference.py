"""Offline original-game observations for paragraph boundaries, HELLO and HAIL."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
D=extract(p);rows=[]
cases=[('hello_reading',[3],None,['SAY TO WATSON "HELLO"','SAY "HELLO" TO WATSON','HELLO','HELLO WATSON']),('hello_during_follow',[3],None,['SAY TO WATSON "FOLLOW ME"','SAY TO WATSON "HELLO"','WAIT']),('hail_prefix',[],5,['HAIL CAB','GET INTO CAB','GET OUT OF CAB','HAIL CAB','HAIL CAB']),('get_cab',[],5,['GET CAB']),('hail_inside',[],8,['HAIL CAB']),('hail_cabbie',[],5,['HAIL CABBIE']),('hail_with_drivers',[31,34],5,['HAIL CAB','GET INTO CAB','GET OUT OF CAB'])]
for label,actors,room,commands in cases:
 g=Game(p,D,active_npcs=actors);g.world.m[0xa037]=1;g.parser.put(g.world.sim,0xa039,0)
 if room:g.teleport(room)
 seq={'label':label,'actors':actors,'teleport':room,'commands':[]}
 for command in commands:
  out=g.command(command);m=g.world.m;entities=[]
  for ident in [0,3,25,27,30,31,32,33,34,35]:
   q=word(m,0x8b70+3*ident);entities.append({'id':ident,'parent':None if m[q+1]==255 else m[q+1],'rooms':list(m[q+15:q+15+m[q]]),'attributes':m[q+5]})
  seq['commands'].append({'input':command,'messages':[{'kind':r['kind'],'text':r['text'],'screen_events':r.get('screen_events',[])} for r in out['messages']],'clock':g.world.clock(),'entities':entities,'actions':g.last_analysis.get('actions',[])})
  print(label,command,[(r['kind'],r['text']) for r in out['messages']],flush=True)
 rows.append(seq);a.output.write_text(json.dumps({'scope':'Historical prompt with seed set to 1 after boot, free clock, listed active actors and map fixtures. Not original bootstrap or seed parity.','cases':rows},ensure_ascii=False,indent=2)+'\n')
