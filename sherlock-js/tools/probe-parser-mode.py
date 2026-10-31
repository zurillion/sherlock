"""Observe all original A024 mode writers, including unchanged writes. Offline only."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['HE HAD BOOK. I','I'],['SAY WATSON "WATSON KILLED YOU"','I'],['SAY WATSON "HE HAD BOOK"','I'],['SAY WATSON "IT IS GUN"','I'],['SAY WATSON "LOOK. WATSON KILLED YOU"','I'],['SAY WATSON "WATSON KILLED YOU. LOOK"','I'],['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['OPEN ALL','CLOSE ALL','I'],['SAY WATSON "HELLO"','I','SAY WATSON "FOLLOW ME"','I'],['WAIT UNTIL 8:10AM','I'],['PRINT','NOPRINT','SAVE','I'],['OPEN','SAY "HELLO"','I'],['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I','I'],['WATSON KILLED YOU','I'],['TAKE TO','LOOK'],['LOOK. I','I'],['OPEN LAMP','GET DAILY CHRONICLE','I']]
if '--witness' in sys.argv:scenarios=[['HE HAD BOOK. I','I'],['SAY WATSON "WATSON KILLED YOU"','I'],['SAY WATSON "HE HAD BOOK"','I'],['SAY WATSON "IT IS GUN"','I'],['SAY WATSON "LOOK. WATSON KILLED YOU"','I'],['SAY WATSON "WATSON KILLED YOU. LOOK"','I'],[c for c in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines()if c and not c.startswith('#')]]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None;pending=None;events=[];unclassified=[];old=m[0xa024];last=None;initial=old;steps=[]
 def obs(m,r,R):
  global draw,pending,old,last
  pc=r[R.PC];value=m[0xa024]
  if pending is not None:last={**pending,'value':value};events.append(last);pending=None
  elif value!=old:unclassified.append(dict(pc=f'{pc:04X}',value=value,tick=word(m,0x9fdd)))
  old=value
  if pc in(0xaacc,0xaaec,0xab0a,0xb13a,0xb156,0xb8b1,0xd785):pending=dict(pc=f'{pc:04X}',a=r[R.A],tick=word(m,0x9fdd),actor=m[0xa036],caller=f'{word(m,r[R.SP]):04X}')
  if pc==0xd2ad:draw=dict(parser_mode=value,last_store=last,actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
  if draw is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
  if draw is not None and pc==0xd2ec:
   v=r[R.A];draw.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
 w.observer=obs
 for command in inputs:
  out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
  while True:
   steps.append(dict(input=command,after=snapshot(w),parser_mode=m[0xa024],last_store=last,events=events[:],random=draws[:],running=bool(out.get('running'))));events.clear();draws.clear();command=None
   if not out.get('running')or '--witness'in sys.argv and w.clock()['tick']>=3591:break
   out=g.continue_command(out['job'])
  print(w.clock()['label'],f'{m[0xa024]:04X}',last,flush=True)
  if '--witness'in sys.argv and w.clock()['tick']>=3591:break
 cases.append(dict(inputs=inputs,initial=initial,steps=steps,unclassified_transitions=unclassified))
root=p/'sherlock-js/results/parser-mode';root.mkdir(exist_ok=True)
name='witness-reference.json.gz'if'--witness'in sys.argv else'natural-reference.json.gz'
(root/name).write_bytes(gzip.compress(json.dumps(dict(protocol='Original seed1/all24 actors/free initial LOOK/graphics off after boot/uppercase injected input/immediate MORE. Observe all seven A024 byte stores including unchanged values, all random draws and full checkpoints. No instruction/world patches. Offline only.',cases=cases),separators=(',',':')).encode(),mtime=0));print(name,flush=True)
