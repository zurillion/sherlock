"""Offline all-actor language histories. Observations are tests, never runtime input."""
import sys,json,argparse
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
# Raise the research bridge's 70-key cap for the editor-capacity test only.
# The game bytes and keyboard algorithm remain untouched.
import inspect,textwrap,native_world
scope={};exec(textwrap.dedent(inspect.getsource(native_world.NativeWorld.iter_submit)).replace('len(text)>70','len(text)>160'),native_world.__dict__,scope)
native_world.NativeWorld.iter_submit=scope['iter_submit']
catalog=extract(p)
scenarios=[
 ['OPEN YOUR DOOR AND PLAIN DOOR','CLOSE YOUR DOOR AND PLAIN DOOR','I'],
 ['OPEN ALL BUT YOUR DOOR','CLOSE ALL EXCEPT PLAIN DOOR','I'],
 ['TAKE ALL BUT MONEY','I','DROP ALL EXCEPT LAMP','I'],
 ['OPEN DOOR AND LAMP','YOUR','I'],
 ['OPEN DOOR AND OPEN LAMP','YOUR','I'],
 ['OPEN DOOR','YOUR AND PLAIN','I'],
 ['EXAMINE ARMCHAIR','@','WATSONS','I'],
 ['OPEN DOOR','YOUR. LOOK','I'],
 ['OPEN DOOR AND PLAIN DOOR','LOOK','I'],
 ['TAKE LAMP','GIVE LAMP TO ALL','I'],
 ['TAKE LAMP','PUT LAMP ON ALL','I'],
 ['SAY TO WATSON "HELLO" "HELLO"','I','SAY TO WATSON "LOOK"','I'],
 ['SAY TO CABBIE "HELLO"','SAY TO WATSON "LOOK"','I','SAY TO WATSON "HELLO"','I'],
 ['SAY TO WATSON "LOOK. HELLO"','I'],
 ['SAY TO WATSON "HELLO. HE IS INNOCENT"','I'],
 ['SAY TO WATSON "BASIL KILLED MRS BROWN. HE IS INNOCENT"','HE IS INNOCENT','I'],
 ['SAY TO WATSON "BASIL KILLED MRS BROWN, THAT HAD PLANS"','SAY TO WATSON "THEY ARE INNOCENT"','I'],
 ['OPEN ALL BUT YOUR DOOR AND PLAIN DOOR','I'],
 ['OPEN ALL EXCEPT LAMP','I'],
 ['TAKE LAMP AND MONEY','PUT LAMP AND MONEY ON TABLE','I'],
 ['LOOK AND LOOK','I'],
 ['OPEN DOOR','LOOK AND I','I'],
 ['OPEN DOOR','YOUR AND LOOK','I'],
 ['SAY TO WATSON "TAKE LAMP AND MONEY"','I','I'],
 ['SAY TO WATSON "TAKE ALL EXCEPT MONEY"','I','I'],
 ['SAY TO WATSON "BASIL KILLED MRS BROWN"','HE IS INNOCENT','IT IS INNOCENT','I'],
]
scenarios += [
 ['I','@','@','I'],['TAKE LAMP','@','I'],['XYZZY','@','I'],
 ['SAY TO WATSON "HELLO"','@','@','I'],
 ['OPEN DOOR','LOOK AND OPEN DOOR','PLAIN','I'],
 ['OPEN DOOR','ALL BUT YOUR DOOR','I'],
 ['OPEN ALL BUT YOUR DOOR, PLAIN DOOR','I'],
 ['SAY TO WATSON "BASIL HAS PLANS"','SAY TO WATSON "HE OWNS PLANS THEREFORE THAT IS INNOCENT"','I'],
 ['SAY TO WATSON "LOOK" "HELLO"','SAY TO WATSON "TAKE LAMP"','I'],
 ['SAY TO CABBIE "TAKE LAMP"','SAY TO WATSON "HELLO"','I'],
 ['SAY TO WATSON "THE" "HELLO"','I','SAY TO WATSON "HELLO"','I'],
 ['TAKE ALL','PUT ALL ON YOUR ARMCHAIR','I'],
 ['TAKE LAMP','GIVE ALL TO ALL','I'],
 ['TAKE LAMP','DROP LAMP AND MONEY','I'],
 ['SAY TO WATSON "OPEN ALL"','I','I','I'],
 ['SAY TO WATSON "TAKE LAMP" "DROP LAMP"','WAIT','SAY WATSON','I'],
 ['WAIT UNTIL 8:01AM','I'],['PAY `1/2S TO WATSON','I'],['PAY `1 2/6 TO WATSON','I'],
 ['I'+' '*140,'I'],['OPEN YOUR DOOR?','I'],["SAY TO WATSON \"HELLO!\"",'I'],
]
scenarios += [
 ['TELL WATSON ABOUT ALL','I'],['TELL ALL ABOUT LAMP','I'],['TELL WATSON ABOUT DOOR','I'],
 ['TELL WATSON ABOUT INNOCENT','I'],['SAY TO WATSON "TELL ME ABOUT ALL"','I'],
 ['TAKE ALL FROM ALL','I'],['EXAMINE ALL BUT WATSON','I'],
 ['OPEN YOUR DOOR, PLAIN DOOR AND LOOK','LOOK. THE. I','I'],
]
scenarios += [
 ['SAY WATSON ""','I'],['SAY WATSON " "','I'],
 ['"HELLO"','I'],['SAY','"HELLO"','I'],
 ['SAY CABBIE','"HELLO"','I'],
]
ap=argparse.ArgumentParser();ap.add_argument('--start',type=int,default=0);args=ap.parse_args();target=p/'sherlock-js/test/fixtures/language-reference.json'
result=json.loads(target.read_text())['cases'][:args.start]if args.start else []
for index,commands in enumerate(scenarios):
 if index<args.start:continue
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0;draws=[];pending=None;events=[]
 def observe(m,r,R):
  global pending
  pc=r[R.PC]
  if pc==0xd2ad:pending=dict(actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(pending)
  if pending is not None and pc in(0xd2cb,0xd2d0):
   at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=at,value=m[at]))
  if pending is not None and pc==0xd2ec:
   v=r[R.A];pending.update(result=abs(v if v<128 else v-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));pending=None
  if pc in [0xd7fc,0xd835,0xb5b6,0xb8aa,0xba20]:
   q=word(m,0x9ff2);nodes=[]
   while q:nodes.append(dict(pointer=q,values=list(m[q:q+30])));q=word(m,q-2)
   events.append(dict(pc=f'{pc:04X}',tick=word(m,0x9fdd),actor=m[0xa036],parsed=nodes,mode=m[0xa024]))
 w.observer=observe;steps=[]
 for c in commands:
  out=g.command(c);state=snapshot(w);q=word(w.m,0x9fec);quotes=[]
  while q:quotes.append(dict(pointer=q,token=word(w.m,q)));q=word(w.m,q-2)
  steps.append(dict(input=c,messages=out['messages'],after=state,events=events[:],quotes=quotes,information=list(w.m[0x9ff6:0xa008]),random=draws[:]));draws.clear();events.clear()
 result.append(dict(steps=steps));print(index,[(s['input'],s['after']['clock']['label'],[m['text']for m in s['messages']if m['text']])for s in steps],flush=True)
 (p/'sherlock-js/test/fixtures/language-reference.json').write_text(json.dumps(dict(protocol='Natural fresh seed-1 startup; all 24 actors; free initial LOOK; graphics off after boot; injected uppercase keys; immediate MORE; no idle timeout. No world patches or teleports.',cases=result),separators=(',',':'))+'\n')
