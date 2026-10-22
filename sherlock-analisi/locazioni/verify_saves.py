#!/usr/bin/env python3
"""Full-state SAVE/LOAD replay, including RNG, clarification and cab context."""
import argparse,json,hashlib
from copy import deepcopy
from pathlib import Path
from explorer import Game
from extract_locations import extract
from native_world import word
import saved_game

def verify(project):
 data=extract(project);checks=[];branches=[]
 def check(name,ok,**details):
  assert ok,(name,details)
  checks.append({'check':name,'passed':True,**details});print('OK:',name,flush=True)
 def signature(g):
  w=g.world
  return {'memory':hashlib.sha256(bytes(w.m)).hexdigest(),'registers':w.sim.registers[:],
          'input_registers':w.input_registers[:],'input_stack':w.input_stack[:],
          'ended':w.ended,'seed':w.seed,'explored':sorted(g.explored),'clock':w.clock()}
 def branch(name,game,commands):
  document=saved_game.save(game,{'test':name});encoded=json.loads(json.dumps(document))
  restored,presentation=saved_game.load(project,data,encoded)
  check(name+': load restores every byte, CPU/input register and stack',signature(game)==signature(restored) and presentation=={'test':name})
  logs=[]
  for command in commands:
   # Extra UI reads must not perturb the branch, including seed/cursor/video RAM.
   before=signature(restored)
   for _ in range(2):restored.state();restored.world.scene()
   assert before==signature(restored)
   actual=game.command(command);replayed=restored.command(command)
   assert actual==replayed,(name,command,'response')
   assert signature(game)==signature(restored),(name,command,'machine')
   logs.append({'command':command,'clock':game.world.clock(),'seed':game.world.m[0xa037],'cursor':word(game.world.m,0xa039)})
  check(name+': subsequent output and complete machine state are identical',True,commands=commands)
  branches.append({'name':name,'commands':logs})
  return document
 for seed in (0,1,255):
  g=Game(project,data,seed=seed)
  check(f'Seed {seed} is set before Watson initialization',g.world.seed==seed and word(g.world.m,0xa039)>=256)
  branch('initial_seed_'+str(seed),g,['OPEN YOUR DOOR','WEST','WAIT','WAIT'])
 g=Game(project,data,seed=7);g.command('OPEN DOOR')
 check('Native clarification is pending before save',g.world.m[0xa01b]!=0)
 doc=branch('pending_clarification',g,['YOUR','WEST','WAIT'])
 g=Game(project,data,seed=1);g.teleport(5)
 for cmd in ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']:g.command(cmd)
 check('Cab trip is pending before save',g.world.room==1)
 branch('cab_trip',g,['WAIT','GET OUT OF CAB','PAY 1/- TO CABBIE'])
 g=Game(project,data,seed=1);g.command('QUIT')
 branch('ended_game',g,['LOOK'])
 g=Game(project,data,seed=1);part=g.start_command('WAIT UNTIL 9:00AM')
 check('Long command exposes a safe progress frame',part['running'])
 try:saved_game.save(g)
 except ValueError:pass
 else:raise AssertionError('Active command saved without its Python continuation')
 check('Saving an active command is refused explicitly',True)
 g.command_job.close();g.command_job=None
 for label,mutate in [
  ('checksum',lambda d:d.update(sha256='0'*64)),
  ('version',lambda d:d.update(version=999)),
  ('memory',lambda d:d['machine'].update(memory='bad')),
  ('register',lambda d:d['machine']['input_registers'].__setitem__(24,8)),
  ('seed',lambda d:d['machine'].update(seed=256))]:
  bad=deepcopy(doc);mutate(bad)
  if label not in ('checksum','version'):bad['sha256']=saved_game.digest({k:v for k,v in bad.items() if k!='sha256'})
  try:saved_game.load(project,data,bad)
  except ValueError:pass
  else:raise AssertionError('Invalid save accepted: '+label)
 check('Malformed, incompatible and corrupted saves are rejected',True)
 return {'passed':True,'checks':checks,'branches':branches,'format':saved_game.FORMAT,'version':saved_game.VERSION}
if __name__=='__main__':
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,default=Path(__file__).with_name('results')/'save-verification.json');a=ap.parse_args()
 result=verify(a.project);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n')
