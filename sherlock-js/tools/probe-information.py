import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
result=[];catalog=extract(p)
scenarios=[dict(commands=[c,'WAIT','WAIT']) for c in ['SAY TO WATSON "BASIL KILLED MRS BROWN"','SAY TO WATSON "BASIL IS INNOCENT"','SAY TO WATSON "THE LAMP IS IN THE ROOM"','SAY TO WATSON "THE LAMP IS INNOCENT"']]
scenarios.append(dict(commands=['SAY TO WATSON "BASIL KILLED MRS BROWN"','SAY TO WATSON "BASIL KILLED MRS BROWN"','SAY TO WATSON "TRICIA KILLED MRS BROWN"','SAY TO WATSON "BASIL HAS PLANS"']+['WAIT']*15))
for known in [False,True]:
 for phrase in ['MAJOR FFOULKES IS INNOCENT','MRS BROWN KILLED HERSELF','MRS JONES KILLED TRICIA','BASIL HAS PLANS','TRICIA HAD PLANS','TRICIA BLACKMAILED MRS BROWN','BASIL KILLED MRS BROWN','THE LAMP IS IN THE ROOM']:
  scenarios.append(dict(setup=dict(lestrade_room=8,known=known),commands=[f'SAY TO LESTRADE "{phrase}"','I']))
history=(p/'sherlock-js/results/fact-boundary/user-natural-inputs.txt').read_text().splitlines()
prefix=[x for x in history if x and not x.startswith('#')][:98]
scenarios.append(dict(prefix=prefix,commands=['SAY TO LESTRADE "BASIL HAS PLANS"','I','SAY TO LESTRADE "MRS BROWN KILLED HERSELF"','I','LOOK']))
scenarios.append(dict(setup=dict(lestrade_room=8,known=True,established=True),commands=['SAY TO LESTRADE "BASIL HAS PLANS"','I']))
scenarios.append(dict(commands=['SAY TO WATSON "BASIL KILLED MRS BROWN AND TRICIA KILLED MRS BROWN"','I','SAY TO WATSON "HE IS INNOCENT"','I']))
for scenario in scenarios:
 command=scenario['commands'][0]
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;events=[];draws=[];pending=None
 if scenario.get('setup'):
  q=word(w.m,0x8b70+3*2);w.m[q+1]=255;w.m[q+15]=8
  if scenario['setup']['known']:
   at=0x9965;roots=[0x9965,0x9973,0x9981,0x9997,0x99a9,0x99bb,0x99c5,0x99cf,0x99d9,0x99e3,0x99f1]
   while at<0x99fb:
    flags=w.m[at+3]
    if at not in roots:w.m[at+3]|=2
    at+=6 if flags&48 else 4
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
  if r[R.PC] in [0xba20,0xbaab,0xbb16,0xbb3f,0xbb5c,0xbb67,0xbbbe,0xbc21]:events.append({'pc':f'{r[R.PC]:04X}','actor':m[0xa036],'statement':list(m[0xba19:0xba20]),'watson':list(m[0xba60:0xba67]),'he':list(m[0x9ff6:0x9ffc]),'it':list(m[0x9ffc:0xa002]),'de':r[R.D]*256+r[R.E]})
 if scenario.get('setup',{}).get('established'):
  for at in [0x9976,0x9984]:w.m[at]|=2
 w.observer=obs
 for c in scenario.get('prefix',[]):g.command(c)
 events.clear();draws.clear();steps=[]
 for c in scenario['commands']:
  out=g.command(c);knowledge=[];q=word(w.m,0x9ff4)
  while q:knowledge.append(dict(pointer=q,values=list(w.m[q:q+5])));q=word(w.m,q-2)
  steps.append(dict(input=c,messages=out['messages'],after=snapshot(w),events=events[:],information=list(w.m[0x9ff6:0xa008]),random=draws[:],knowledge=knowledge));events.clear();draws.clear()
 result.append(dict(setup=scenario.get('setup'),prefix=scenario.get('prefix',[]),steps=steps));print(command,[(x['input'],[m['text']for m in x['messages']])for x in steps],flush=True)
(p/'sherlock-js/test/fixtures/information-reference.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
