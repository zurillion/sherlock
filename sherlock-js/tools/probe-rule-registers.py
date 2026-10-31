"""Offline CB28/CB2A rule bridge observation; never imported by the game."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
catalog=extract(p);cases=[]
scenarios=[['I','XYZZY','OPEN DOOR','YOUR','LOOK','WAIT','I'],['OPEN ALL','CLOSE ALL','I'],['GET LAMP','GIVE LAMP TO WATSON','SAY WATSON "GIVE ME MY LAMP"','I'],['SAY WATSON "HELLO"','I','SAY WATSON "FOLLOW ME"','OPEN YOUR DOOR','W','D','I'],['WAIT UNTIL 8:10AM','I'],['HELLO','SAY "HELLO"','SAY WATSON "WAIT"','WAIT','I'],['OPEN LAMP','GET DAILY CHRONICLE','EXAMINE WATSON','I'],['SAY WATSON "BASIL HAS PLANS"','I'],['GO TO LONDON','LOOK THROUGH YOUR DOOR','I'],['OPEN ALL BUT YOUR DOOR','I'],['SAY WATSON "OPEN ALL AND CLOSE ALL"','I','I','I','I','I'],['WATSON KILLED YOU','I']]
for inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];draw=None;events=[];frames={};last=None;previous=None;initial=list(m[0xcb28:0xcb2c])
 def obs(m,r,R):
  global draw,last,previous
  pc=r[R.PC];sp=r[R.SP];ix=r[R.IXh]*256+r[R.IXl];iy=r[R.IYh]*256+r[R.IYl]
  if previous is not None:
   for f in frames.values():
    if ix!=previous[1]:f['last_ix_writer']=f'{previous[0]:04X}'
    if iy!=previous[2]:f['last_iy_writer']=f'{previous[0]:04X}'
  previous=(pc,ix,iy)
  if pc==0xcb34:frames[sp]=dict(target=f'{r[R.H]*256+r[R.L]:04X}',caller=f'{word(m,sp):04X}',tick=word(m,0x9fdd),actor=m[0xa036],args=list(m[0xa033:0xa036]),before=[ix,iy],argument_pointers=[word(m,0xa013),word(m,0xa015)])
  if pc==0xcb37:
   f=frames.pop(sp,dict(target='unknown'));f.update(after=[ix,iy]);events.append(f);last=f
  if pc==0xd2ad:draw=dict(registers=list(m[0xcb28:0xcb2c]),last_store=last,actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
  if draw is not None and pc in(0xd2cb,0xd2d0):
   at=(ix+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
  if draw is not None and pc==0xd2ec:
   v=r[R.A];draw.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
 w.observer=obs;steps=[]
 for command in inputs:
  out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
  while True:
   steps.append(dict(input=command,after=snapshot(w),registers=list(m[0xcb28:0xcb2c]),events=events[:],random=draws[:],running=bool(out.get('running'))));events.clear();draws.clear();command=None
   if not out.get('running'):break
   out=g.continue_command(out['job'])
 cases.append(dict(initial=initial,steps=steps));print(len(cases),w.clock()['label'],flush=True)
root=p/'sherlock-js/results/rule-registers';root.mkdir(exist_ok=True);(root/'rule-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Natural seed1, all24 actors, original graphics off after boot, uppercase injected keys and immediate MORE. CB34 entry/CB37 return observed without opcode patches. Offline only.',cases=cases),separators=(',',':')).encode(),mtime=0))
