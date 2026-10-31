"""Original controlled capitalization normalizer/name/money ABI; offline only."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;before=(m[:],w.sim.registers[:]);cases=[]
for visible in [False,True]:
 for force in [0,1]:
  for routine in [0xa9b7,0xaa14,0xc1e1]:
   for flag in [0,1,255]:
    for remaining in [1,36]:
     for text in (['a','a ','abc.','abc. ','abc. d ','a"','a\b ','\r','9. ','a'*36+' ','a'*37+' ']if routine==0xa9b7 else [' ','A','Z','a','z','@','[','`','{','.','"','\r','1','/','-']):
      m[:]=before[0];w.sim.registers[:]=before[1];w.call(0xc142);m[0xa027]=0;m[0xa851]=force;w.engine.put(w.sim,0xa9b5,0x5c0b)
      for _ in range(36-remaining):w.call(0xc1e1,a=ord('q'))
      m[0xa025]=1;m[0xa026]=flag;m[0x5c3c]=int(visible);events=[];previous=flag;pending=None;unclassified=[];step=0
      def observe(m,r,R):
       global previous,pending
       value=m[0xa026]
       if pending is not None:events.append({**pending,'value':value});pending=None
       elif value!=previous:unclassified.append(dict(pc=f'{r[R.PC]:04X}',value=value))
       previous=value
       if r[R.PC]in(0xa464,0xa82c,0xa8a9,0xaa4c,0xaa66):pending=dict(pc=f'{r[R.PC]:04X}',step=step,a=r[R.A])
      w.observer=observe;steps=[]
      for step,c in enumerate(text):
       w.call(routine,a=ord(c));steps.append(dict(char=c,value=m[0xa026],remaining=m[0xc1f5],pending_length=(m[0xa9b5]+256*m[0xa9b6]-0x5c0b)&65535))
      w.observer=None;cases.append(dict(visible=visible,force=force,routine=f'{routine:04X}',initial=flag,remaining=remaining,text=text,steps=steps,stores=events,unclassified=unclassified))
names=[];money=[]
for visible in [False,True]:
 for flag in [0,1,254,255]:
  for proper in [0,1]:
   for word in [0,0x971]:
    m[:]=before[0];w.sim.registers[:]=before[1];m[0x5c3c]=int(visible);m[0xa027]=0;m[0xa026]=flag;m[0xa7ea]=proper;w.engine.put(w.sim,0xa9b5,0x5c0b);w.engine.put(w.sim,0xa033,word);r=w.sim.registers;R=w.R;r[R.D]=word>>8;r[R.E]=word&255;w.call(0xa815,a=0x50);names.append(dict(visible=visible,initial=flag,proper=proper,word=word,value=m[0xa026]))
  for amount in [0,1,6,11,12,13,18,23,24,239,240,241,252,253,480,16383,16382,16380]:
   m[:]=before[0];w.sim.registers[:]=before[1];m[0x5c3c]=int(visible);m[0xa027]=0;m[0xa026]=flag;w.engine.put(w.sim,0xa9b5,0x5c0b);r=w.sim.registers;R=w.R;encoded=(amount&127)|((amount<<1)&65280);r[R.H]=encoded>>8;r[R.L]=encoded&255;w.call(0xa419);money.append(dict(visible=visible,initial=flag,pence=amount,encoded=encoded,value=m[0xa026]))
root=p/'sherlock-js/results/output-capitalization';root.mkdir(exist_ok=True)
(root/'abi.json').write_text(json.dumps(dict(protocol='Controlled original A9B7/AA14/C1E1, A815 name post-OR and A419 money. Explicit initial flag/force/channel/word pointer/remaining/visibility and register parameters; no code patches. Flag comparisons only, not whole bitmaps or natural reachability.',cases=cases,names=names,money=money),separators=(',',':'))+'\n');print(len(cases),len(names),len(money),flush=True)
boots=[]
for seed in [1,2,77,255]:
 h=Game(p,extract(p),seed=seed,active_npcs=None);boots.append(dict(seed=seed,value=h.world.m[0xa026]))
(root/'boot.json').write_text(json.dumps(dict(protocol='Four original cold starts/all24 actors, A026 at first prompt.',cases=boots),indent=2)+'\n');print(boots,flush=True)
