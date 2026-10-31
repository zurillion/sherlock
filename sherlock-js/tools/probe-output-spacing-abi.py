"""Controlled original formatter ABI. Set only declared data/register inputs; no code patches."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
catalog=extract(p);g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;before=(m[:],w.sim.registers[:]);cases=[]
for visible in [False,True]:
 for routine in [0xa9b7,0xaa14,0xc1e1]:
  for flag in [0,1,255]:
   for remaining in [1,2,4,36]:
    for text in ([' ','q ','qq ','qqqq ','qqqqq ','q\r','"','q"','q\b ','\r','q'*36+' ','q'*37+' '] if routine==0xa9b7 else [' ','q','"','\r']):
     m[:]=before[0];w.sim.registers[:]=before[1];w.call(0xc142);m[0xa027]=0;m[0xa026]=0;m[0xa851]=0;w.engine.put(w.sim,0xa9b5,0x5c0b)
     for _ in range(36-remaining):w.call(0xc1e1,a=ord('q'))
     m[0xa025]=flag;m[0x5c3c]=int(visible);events=[];previous=flag;pending=None;unclassified=[];step=0
     def observe(m,r,R):
      global previous,pending
      value=m[0xa025]
      if pending is not None:events.append({**pending,'value':value});pending=None
      elif value!=previous:unclassified.append(dict(pc=f'{r[R.PC]:04X}',value=value))
      previous=value
      if r[R.PC]in(0xaa08,0xaa2c,0xaa36):pending=dict(pc=f'{r[R.PC]:04X}',step=step,a=r[R.A])
     w.observer=observe;steps=[]
     for step,c in enumerate(text):
      out=w.call(routine,a=ord(c));steps.append(dict(char=c,value=m[0xa025],remaining=m[0xc1f5],pending_length=(m[0xa9b5]+256*m[0xa9b6]-0x5c0b)&65535))
     w.observer=None;cases.append(dict(visible=visible,routine=f'{routine:04X}',initial=flag,remaining=remaining,text=text,steps=steps,stores=events,unclassified=unclassified))
root=p/'sherlock-js/results/output-spacing';root.mkdir(exist_ok=True)
(root/'abi.json').write_text(json.dumps(dict(protocol='Controlled original AA14 normalizer, A9B7 buffered output and C1E1 raw screen output. All24 actor boot; source code untouched. Data setup explicitly sets incoming A025/column/channel/capitalization/word-buffer pointer and5C3C visibility. Inputs0,1,255; remaining1,2,4,36. Stores include unchanged writes. This does not prove all setups occur naturally.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
boots=[]
for seed in [1,2,77,255]:
 h=Game(p,catalog,seed=seed,active_npcs=None);boots.append(dict(seed=seed,value=h.world.m[0xa025]))
(root/'boot.json').write_text(json.dumps(dict(protocol='Four original cold starts with all24 actors; A025 at the first command prompt.',cases=boots),indent=2)+'\n');print(boots)
