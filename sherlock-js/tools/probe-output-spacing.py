"""Offline original A025 stores, including unchanged writes, and every random read."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['OPEN ALL','CLOSE ALL','I'],['SAY WATSON "HELLO"','I','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','I'],['WAIT UNTIL 8:10AM','I'],['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I'],['OPEN LAMP','GET DAILY CHRONICLE','EXAMINE WATSON','I'],['GO TO LONDON','LOOK THROUGH YOUR DOOR','I'],['WATSON KILLED YOU','I'],['WAIT UNTIL 8:20AM','I']]
witness='--witness' in sys.argv
if witness:scenarios=[[c for c in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines()if c and not c.startswith('#')]]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None;pending=None;events=[];unclassified=[];old=m[0xa025];last=None;initial=old;steps=[];counts={}
 def obs(m,r,R):
  global draw,pending,old,last
  pc=r[R.PC];value=m[0xa025]
  if pending is not None:last={**pending,'value':value};events.append(last);pending=None
  elif value!=old:unclassified.append(dict(pc=f'{pc:04X}',value=value,tick=word(m,0x9fdd)))
  old=value
  if pc in(0xaa08,0xaa2c,0xaa36):
   counts[f'{pc:04X}']=counts.get(f'{pc:04X}',0)+1
   pending=dict(pc=f'{pc:04X}',a=r[R.A],tick=word(m,0x9fdd),actor=m[0xa036],stack_top=f'{word(m,r[R.SP]):04X}')
  if pc==0xd2ad:draw=dict(tick=word(m,0x9fdd),spacing=value,last_store=last,actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
  if draw is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
   if at==0xa025:print('A025 READ',draw,flush=True)
  if draw is not None and pc==0xd2ec:
   v=r[R.A];draw.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
 w.observer=obs
 for command in inputs:
  out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
  while True:
   steps.append(dict(input=command,after=(dict(clock=w.clock())if witness else snapshot(w)),spacing=m[0xa025],last_store=last,events=events[:],random=draws[:],running=bool(out.get('running'))));events.clear();draws.clear();command=None
   if not out.get('running')or witness and w.clock()['tick']>=3701:break
   out=g.continue_command(out['job'])
  print(w.clock()['label'],m[0xa025],flush=True)
  if witness and w.clock()['tick']>=3701:break
 cases.append(dict(initial=initial,steps=steps,unclassified_transitions=unclassified,store_counts=counts))
root=p/'sherlock-js/results/output-spacing';root.mkdir(exist_ok=True)
name='witness-reference.json.gz'if witness else'natural-reference.json.gz'
(root/name).write_bytes(gzip.compress(json.dumps(dict(stack_top_semantics='Raw word at SP when a store executes; in AA14 this may be saved AF, not a return address.',protocol='Original seed1/all24 actors/free initial LOOK/native graphics off after boot/uppercase injected input/immediate MORE. All three A025 stores including unchanged writes, every random draw and spacing value at every draw/checkpoint. Witness uses minute snapshots of clock only; full-state certificate is separate. Offline only.',cases=cases),separators=(',',':')).encode(),mtime=0));print(name,flush=True)
