"""Offline source observation; no actor/world patches or captured runtime inputs."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_snapshot import snapshot
from native_world import word
catalog=extract(p);cases=[]
for inputs in [['SUPERCALIFRAGILISTICEXPIALIDOCIOUS','I','XYZZY','I'],['EXTRAORDINARILYLONGWORD','@','LOOK'],['SAY WATSON "FOLLOW ME"','WAIT UNTIL 8:05AM'],['OPEN ALL BUT','I'],['SAY "HELLO" TO WATSON','I']]:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;copies=[];draws=[];pending=None
 boot=list(m[0x5c0b:0x5c42]);steps=[]
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xda7a:copies.append(list(m[0x5c0b:0x5c0b+m[0xdc13]]))
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=observe
 for c in inputs:
  out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
  while out.get('running'):out=g.continue_command(out['job'])
  steps.append(dict(input=c,after=snapshot(w),workspace=list(m[0x5c0b:0x5c42]),copies=copies[:],random=draws[:],outcome=out['state']['analysis']['outcome']));copies.clear();draws.clear()
 cases.append(dict(boot=boot,steps=steps));print([(s['input'],s['outcome'])for s in steps],flush=True)
p.joinpath('sherlock-js/test/fixtures/lexical-workspace-reference.json').write_text(json.dumps(dict(protocol='Fresh natural seed1 per case, all actors, graphics off after boot, uppercase injected input and immediate MORE; no actor/world patches. DA7A observes each completed lexical copy including preflight. Only first 55 bytes below dictionary workspace are certified.',cases=cases),separators=(',',':'))+'\n')
