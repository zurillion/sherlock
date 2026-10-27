"""Original oracle for natural ending histories; never imports states into JS."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
ap=argparse.ArgumentParser();ap.add_argument('--through-tick',type=int);ap.add_argument('--checkpoint-file');ap.add_argument('--start',type=int,default=0);ap.add_argument('--manifest',default='results/other-endings/manifest.json');ap.add_argument('--output',default='test/fixtures/other-endings-reference.json');args=ap.parse_args();base=p/'sherlock-js';scenarios=json.loads((base/args.manifest).read_text());target=base/args.output;cases=json.loads(target.read_text())['cases'][:args.start]if args.start else [];catalog=extract(p)
for index,scenario in enumerate(scenarios):
 if index<args.start:continue
 commands=[x for x in (base/scenario['history']).read_text().splitlines()if x and not x.startswith('#')];g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;pause=None;events=[];steps=[];seen_terminal=False;bounded=False
 def observe(m,r,R):
  global pending,pause,seen_terminal
  pc=r[R.PC]
  if pc==0x9e74:seen_terminal=True
  if seen_terminal and pc==0xc306:pause=snapshot(w)
  if pc in(0x9e4a,0x9e6c,0x9e87,0x9ea4,0xdfcc,0x9a3f,0x9a4d,0x9a5b,0xef89,0xf109):events.append(dict(pc=f'{pc:04X}',actor=m[0xa036],clock=w.clock()))
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe
 def record(command,out,messages):
  steps.append(dict(input=command,running=out.get('running',False),after=snapshot(w),random=draws[:],messages=messages[:],ending=w.ended,literal=word(m,0xa02f),pause=pause,events=events[:],case_ready=bool(m[0x9e88])));draws.clear();events.clear()
  if args.checkpoint_file and len(steps)%25==0:(base/args.checkpoint_file).write_text(json.dumps(dict(label=scenario['label'],complete=False,steps=steps),separators=(',',':'))+'\n')
 for command in commands:
  if command.startswith('WAIT UNTIL'):
   out=g.start_command(command);first=True;messages=[];frames=0
   while True:
    messages.extend(out['messages'])
    bounded=args.through_tick is not None and w.clock()['tick']>=args.through_tick
    if first or not out['running']or bounded or w.clock()['minute']%10==0 or any(m.get('text')for m in out['messages']):record(command if first else None,out,messages);messages.clear();first=False
    if not out['running']or bounded:break
    out=g.continue_command(out['job']);frames+=1
    if frames>3000:raise RuntimeError('Research wait guard')
  else:out=g.command(command);record(command,out,out['messages'])
  bounded=bounded or args.through_tick is not None and w.clock()['tick']>=args.through_tick
  print('command',command,w.clock()['label'],flush=True)
  if bounded or w.ended or out['state']['analysis']['outcome']=='tool_limit':break
 cases.append(dict(label=scenario['label'],history=scenario['history'],expected=None if bounded else scenario.get('expected'),steps=steps,**({'bounded_at_tick':w.clock()['tick']}if bounded else {})));target.write_text(json.dumps(dict(protocol='Natural seed-1 histories from free initial LOOK; all 24 actor slots active; native graphics off after boot; uppercase injected keys; immediate MORE/terminal acknowledgement; no idle timeout, teleport, actor-PC or proof patch. Original executes offline only.',cases=cases),separators=(',',':'))+'\n');print(index,scenario['label'],len(steps),w.clock()['label'],w.ended,flush=True)
