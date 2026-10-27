"""Offline natural losses: stay home; meet Straker then stop investigating."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p)
history=[x for x in (p/'sherlock-js/results/fact-boundary/user-natural-inputs.txt').read_text().splitlines()if x and not x.startswith('#')]
prefix=history[:next(i+1 for i,x in enumerate(history)if x=='SAY "HELLO" TO STRAKER')]
ap=argparse.ArgumentParser();ap.add_argument('--start',type=int,default=0);args=ap.parse_args();target=p/'sherlock-js/test/fixtures/natural-loss-reference.json';cases=json.loads(target.read_text())['cases'][:args.start]if args.start else []
for case_index,(label,commands) in enumerate( [('stay-home',[]),('meet-straker-then-wait',prefix)]):
 if case_index<args.start:continue
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;calls=[];gates=[];pending=None
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc in(0xe932,0x9e6c,0xe96b,0x9e87):gates.append(dict(pc=f'{pc:04X}',actor=m[0xa036],clock=w.clock(),straker_met=m[0x9d90],case_ready=m[0x9e88]))
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe;steps=[]
 def record(command,out,messages):
  steps.append(dict(input=command,running=out.get('running',False),after=snapshot(w),random=calls[:],messages=messages[:],ending=w.ended,literal=word(m,0xa02f)));calls.clear()
 for command in commands:
  out=g.command(command);record(command,out,out['messages'])
 for command in (['WAIT UNTIL 11PM']if case_index==0 else ['WAIT UNTIL 11PM','WAIT UNTIL 7AM']):
  out=g.start_command(command);first=True;messages=[];frames=0
  while True:
   messages.extend(out['messages'])
   if first or not out['running']or w.clock()['minute']%10==0 or any(m.get('text')for m in out['messages']):
    record(command if first else None,out,messages);messages.clear();first=False
   if not out['running']:break
   out=g.continue_command(out['job']);frames+=1
   if frames>1500:raise RuntimeError('Natural expected terminal was not reached in one day')
  if w.ended:break
 cases.append(dict(label=label,prefix=commands,steps=steps,gates=gates))
 target=p/'sherlock-js/test/fixtures/natural-loss-reference.json';target.write_text(json.dumps(dict(protocol='Seed 1, all 24 actor slots active, free initial LOOK, native graphics off after boot, injected uppercase keys, immediate MORE/terminal acknowledgement, no idle timeouts. No teleports, actor-PC patches, acquired-proof patches or native snapshots in the playable engine.',cases=cases),separators=(',',':'))+'\n')
 print(label,len(steps),'checkpoints',w.clock()['label'],w.ended,gates,flush=True)
