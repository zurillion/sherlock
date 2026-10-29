"""Offline original full-state clarification cases; overlays explicitly separate."""
import sys,json,gzip,inspect,textwrap
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
import native_world
src=textwrap.dedent(inspect.getsource(native_world.NativeWorld.iter_submit)).replace('0xb09d,0xb002,0xb00e,','').replace('0xb0c9,','')
src=src.replace('if pc==0xa074:', """if pc==0xc040:
                r[R.F]|=1;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xc03b:
                r[R.A]=0;r[R.PC]+=2;continue
            if pc==0xc40c:
                r[R.A]=192;r[R.PC]+=2;continue
            if pc==0xa074:""")
scope={};exec(src,native_world.__dict__,scope);native_world.NativeWorld.iter_submit=scope['iter_submit']
catalog=extract(p);cases=[];data=json.loads(p.joinpath('sherlock-js/data/game.json').read_text());plain=next(w['id']for w in data['dictionary']if w['stem']=='plain')
scenarios=[(False,c)for c in [['OPEN','YOUR DOOR','I'],['TAKE','LAMP','I'],['EXAMINE','LAMP','I'],['OPEN DOOR','XYZZY','YOUR','I'],['OPEN DOOR','@','YOUR','I'],['OPEN DOOR','','YOUR','I'],['OPEN DOOR','.','YOUR','I'],['GET LAMP','GIVE LAMP TO','I'],['OPEN YOUR DOOR','W','D','OPEN DOOR','S','HAIL','I'],['OPEN DOOR','SAVE','YOUR','I']]]
scenarios += [(False,c)for c in [['GIVE TO WATSON','MONEY','I'],['GET LAMP','PUT ON YOUR ARMCHAIR','LAMP','I']]]
scenarios += [(False,['GET DAILY CHRONICLE','I']),(False,['CARRY DAILY CHRONICLE','I']),(False,['TAKE DAILY CHRONICLE','I']),('single-lamp',['TAKE','I'])]
scenarios += [(True,[c,'PLAIN','I'])for c in ['GIVE MONEY TO WATSON','PAY 6D TO WATSON','PAY WATSON 6D']]
for controlled,inputs in scenarios:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;draws=[];pending=None;events=[];candidates=[]
 if controlled is True:
  q=word(m,0x8b70+3*2);m[q+1]=255;m[q+15]=8;other=word(m,0x8b70+3*3);w.engine.put(w.sim,q+7,word(m,other+7));w.engine.put(w.sim,q+9,plain);w.engine.put(w.sim,q+11,0)
 elif controlled=='single-lamp':
  for ident in range(110):
   if ident not in(0,22):m[word(m,0x8b70+3*ident)+5]&=127
 def obs(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xb22e:candidates.append(m[0xa034])
  if pc in(0xd793,0xb5b6):events.append(dict(pc=f'{pc:04X}',value=r[R.A]))
  if pc==0xd2ad:pending=dict(clarification_offset=m[0xa01b],actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
 w.observer=obs;g.persistence_control=lambda text:None;steps=[]
 for c in inputs:
  out=g.command(c);steps.append(dict(input=c,after=snapshot(w),clarification_offset=m[0xa01b],candidates=candidates[:],events=events[:],random=draws[:],errors=[x['text']for x in out['messages']if x['kind']=='error'],outcome=out['state']['analysis']['outcome']));events.clear();draws.clear();candidates.clear()
 cases.append(dict(controlled=controlled,steps=steps));print(controlled,[(r['input'],r['clarification_offset'],r['errors'])for r in steps],flush=True)
report=dict(protocol='Fresh seed1/all24 actor slots; graphics off after boot; injected uppercase input, immediate MORE. Natural cases have no overlays. Single-lamp setup clears visibility of all entities except Holmes0 and lamp22 after boot. Duplicate-name controlled cases explicitly rename/requalify Lestrade to plain Watson and move him to room8 after boot to exercise both nominal offsets and PAY reversal. Peripheral-only tape adapter matches the state corpus. Every actual A01B write, draw/read, arena byte, actor, entity, fact, bitmap and LOAD future is compared.',cases=cases)
p.joinpath('sherlock-js/test/fixtures/clarification-structure.json.gz').write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode(),mtime=0))
