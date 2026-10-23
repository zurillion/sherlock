#!/usr/bin/env python3
"""Observe original repeated greetings and every shared RNG draw, offline only."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
ap.add_argument('--seeds',type=int,nargs='+',default=[0,1,7,42,127,255]);ap.add_argument('--repetitions',type=int,default=32)
a=ap.parse_args()
if a.repetitions<1 or any(not 0<=s<=255 for s in a.seeds):ap.error('Positive repetitions and byte seeds required.')
sys.path.insert(0,str(a.project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
D=extract(a.project)
class Trace:
 def __init__(self):self.calls=[];self.pending=None;self.choice=None
 def __call__(self,m,r,R):
  pc=r[R.PC]
  if pc==0xa6d3:self.choice={'actor':m[0xa036]}
  if pc==0xd2ad:
   self.pending={'caller':f'{word(m,r[R.SP]):04X}','width':r[R.A],'mix_offset':r[R.D]*256+r[R.E],'seed':m[0xa037],'cursor':word(m,0xa039),'actor':m[0xa036],'tick':word(m,0x9fdd),'choice':self.choice,'reads':[]};self.calls.append(self.pending);self.choice=None
  if self.pending and pc in (0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
   self.pending['reads'].append({'address':at,'value':m[at],'part':'first' if pc==0xd2cb else 'second'})
  if self.pending and pc==0xd2ec:self.pending.update(output=r[R.A],next_seed=m[0xa037],next_cursor=word(m,0xa039));self.pending=None

def run(seed,actors,commands):
 g=Game(a.project,D,seed=seed,start_mode='original');g.world.active_npcs=None if actors is None else frozenset(actors)
 trace=Trace();g.world.observer=trace;rows=[]
 for command in commands:
  k=len(trace.calls);out=g.command(command)
  rows.append({'input':command,'clock':g.world.clock(),'messages':[{'kind':m['kind'],'text':m['text']} for m in out['messages']],'actions':g.last_analysis.get('actions',[]),'outcome':g.last_analysis['outcome'],'calls':trace.calls[k:]})
  if g.last_analysis['outcome']=='tool_limit':raise RuntimeError(g.last_analysis)
 return {'seed':seed,'startup':'true-boot','active_actors':actors,'rows':rows}

result={'scope':'Exact original executable observed offline; no recorded outcomes used as gameplay. Original startup and graphics enabled, injected input, no keyboard idle timeout.','cases':[]}
def capture(seed,actors,commands):
 case=run(seed,actors,commands);result['cases'].append(case)
 a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n')
 print(seed,actors,len(case['rows']),sum(len(r['calls']) for r in case['rows']),flush=True)
for seed in a.seeds:
 for actors in [None,[3]]:capture(seed,actors,['SAY TO WATSON "HELLO"']*a.repetitions)
for commands in [['SAY TO WATSON "HELLO"']*8,['SAY TO WATSON "HELLO"','WAIT']+['SAY TO WATSON "HELLO"']*7]:capture(1,None,commands)
