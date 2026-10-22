#!/usr/bin/env python3
"""Compare every RNG extraction against a separate original-Z80 runner."""
import argparse,json,sys
from pathlib import Path
from audit_random import boot
from explorer import Game
from extract_locations import extract
from native_world import word
from saved_game import save,load

class RandomTrace:
 def __init__(self,R):self.R=R;self.calls=[];self.pending=None;self.refresh=[]
 def __call__(self,m,r,R=None):
  R=self.R;pc=r[R.PC]
  if m[pc:pc+2]==[237,95]:self.refresh.append(f'{pc:04X}')
  if pc==0xd2ad:
   self.pending={'arg':r[R.A],'de':r[R.D]*256+r[R.E],'seed':m[0xa037],
                 'cursor':word(m,0xa039),'reads':[]};self.calls.append(self.pending)
  if self.pending and pc in (0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
   self.pending['reads'].append([f'{at:04X}',m[at]])
  if self.pending and pc==0xd2ec:
   self.pending.update(output=r[R.A],next_seed=m[0xa037],next_cursor=word(m,0xa039));self.pending=None

def verify(project):
 project=Path(project);data=extract(project);sys.path.insert(0,str(project/'sherlock-analisi/ai'))
 from trace_npc_ai import Probe
 checks=[];traces=[]
 def check(name,ok,**details):
  assert ok,(name,details);checks.append({'check':name,'passed':True,**details});print('OK:',name,flush=True)
 # Same exact startup state: no free LOOK normalization in this profile.
 # The reference independently executes entry.z80, not the web boot helper.
 for seed,commands in [(1,['OPEN DOOR','YOUR','WEST']+['WAIT']*30),
                       (0,['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','WAIT','LOOK']),
                       (255,['SAY TO WATSON "TAKE LAMP"','WAIT','WAIT','OPEN DOOR','YOUR','WEST'])]:
  g=Game(project,data,seed=seed,start_mode='original');e,s,initial=boot(project,seed,True);ref=Probe(project)
  ref.m[:]=s.memory;ref.r[:]=s.registers
  check(f'Seed {seed}: true native boot and web begin with identical RAM and CPU',g.world.m==ref.m and g.world.sim.registers==ref.r)
  check(f'Seed {seed}: R is read only at A05F during initialization',initial['refresh']==['A05F'])
  actual,expected=RandomTrace(e.R),RandomTrace(e.R);g.world.observer=actual
  ops=ref.s.opcodes[:]
  ref.s.opcodes[:]=[(lambda op=op:(expected(ref.m,ref.r),op())[-1]) for op in ops]
  rows=[]
  for command in commands:
   before=(g.world.m[:],g.world.sim.registers[:],g.world.input_registers[:],g.world.input_stack[:])
   for _ in range(3):g.state();g.world.scene()
   assert before==(g.world.m,g.world.sim.registers,g.world.input_registers,g.world.input_stack)
   out=g.command(command);original=ref.command(command,budget=16000000)
   assert original['stop']=='prompt',(seed,command,original['stop'])
   assert actual.calls==expected.calls,(seed,command,'RNG divergence')
   assert g.world.m==ref.m,(seed,command,'RAM divergence')
   assert g.world.sim.registers==ref.r,(seed,command,'CPU divergence')
   expected_actions=[{'actor':event['actor'],'id':event['action'],'arguments':event['args']}
                     for event in original['events'] if event['event']=='action']
   assert out['state']['analysis']['actions']==expected_actions,(seed,command,'action divergence')
   normalize=lambda text:' '.join(text.replace('`','£').split()).upper()
   for kind,key in [('narrative','upper'),('error','lower')]:
    assert normalize(' '.join(m['text'] for m in out['messages'] if m['kind']==kind))==normalize(original[key]),(seed,command,'output divergence')
   rows.append({'command':command,'clock':g.world.clock(),'extractions':len(actual.calls),'actions':expected_actions})
  check(f'Seed {seed}: every random argument, DE, read byte, result and state transition matches',True,extractions=len(actual.calls),commands=len(commands))
  check(f'Seed {seed}: all 65536 RAM bytes, CPU registers, actions and output match after each command',True)
  check(f'Seed {seed}: no subsequent LD A,R in the executed path',not actual.refresh and not expected.refresh)
  traces.append({'seed':seed,'start_mode':'original','boot':initial,'commands':rows,'extractions':actual.calls})
 # Demonstrate that the *current* seed affects future calls, not just boot.
 g=Game(project,data,seed=1);other,_=load(project,data,save(g));other.world.m[0xa037]^=128
 a,b=RandomTrace(g.world.R),RandomTrace(other.world.R);g.world.observer=a;other.world.observer=b
 g.command('WAIT');other.command('WAIT')
 check('Changing A037 at a live prompt changes subsequent RNG state/results',a.calls!=b.calls and any(x['output']!=y['output'] for x,y in zip(a.calls,b.calls)))
 check('Extended trace reaches mutable RAM, not just ROM',any(int(address,16)>=0x4000 for t in traces for c in t['extractions'] for address,value in c['reads']))
 return {'passed':True,'checks':checks,'traces':traces,
         'scope':'Exact original 08:01 startup; native graphics enabled; same ROM, initial RAM and injected input. Keyboard idle timeout/hardware timing is outside this bridge.'}

if __name__=='__main__':
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).with_name('results')/'random-verification.json');a=ap.parse_args()
 result=verify(a.project);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n')
