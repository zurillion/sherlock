"""Controlled original CB34/CB2C counter rule returns with explicit arena setups."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
def put(at,v):m[at:at+2]=[v&255,v>>8]
def reg(at,v):r[at]=v>>8;r[at+1]=v&255
def pointers():return [word(m,0xcb28),word(m,0xcb2a)]
def pool():
 free=[];at=word(m,0x9fe3)
 while at:free.append(dict(start=at,size=word(m,at)));at=word(m,at+2)
 allocated=[];at=word(m,0x9fe5)
 while at:allocated.append([at,2]);at=word(m,at-2)
 return dict(version=1,arena=dict(version=1,base=0x9570,bytes=list(m[0x9570:0x9860]),free=free,allocated=allocated,allocationLink=None),heads=dict(counters=word(m,0x9fe5),signals=0,contexts=0,quotes=0,requests=0,syntax=0,parsed=0,facts=0))
def body(target):reg(R.H,target);return w.call(0xcb2c)
for count in[0,1,3]:
 for actor in([3,5,8]if count==3 else[3]):
  for value in[0,1,2,255]:
   for name,header,target in[('counter.create',0xe52f,0xe531),('counter.decrement',0xe57a,0xe57e),('counter.delete',0xe588,0xe58c)]:
    m[:]=memory;r[:]=registers;m[0x9570:0x9860]=[0]*752;put(0x9570,752);put(0x9572,0);put(0x9fe3,0x9570);put(0x9fe5,0);put(0xcb28,0x2468);put(0xcb2a,0x1357)
    for ident in[3,5,8][:count]:m[0xa036]=ident;m[0xa034:0xa036]=[value,255];body(0xe531)
    m[0xa036]=actor;m[0xa034:0xa036]=[7,255]
    if name!='counter.create':
     reg(R.IXh,0x2468);reg(R.IYh,header);reg(R.H,0xe573);before=dict(pointers=pointers(),pool=pool());result=w.call(0xcb34);cases.append(dict(stage='predicate',name=name,actor=actor,args=[255,255],before=before,after=dict(pointers=pointers(),pool=pool(),success=not result['z'])))
     if result['z']:continue
    before=dict(pointers=pointers(),pool=pool());result=body(target);cases.append(dict(stage='body',name=name,actor=actor,args=[7,255]if name=='counter.create'else[255,255],before=before,after=dict(pointers=pointers(),pool=pool(),success=not result['z'])))
root=p/'sherlock-js/results/rule-registers';root.mkdir(exist_ok=True);(root/'counter-controls.json').write_text(json.dumps(dict(protocol='Controlled original rule bridge calls. Explicit empty arena and counter lists of0/1/3 records, selected actor3/5/8, values0/1/2/255; supplied IX2468/IY1357. Source opcodes unchanged. No natural-play claim; verifies retained pointers and pool effects without random spreads.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
