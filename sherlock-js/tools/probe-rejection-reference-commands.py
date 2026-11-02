"""Whole original commands: capture actual6894 parameters and final descriptor."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(gzip.decompress((p/'sherlock-js/results/murder-ending/brown-native-prompt.json.gz').read_bytes()));g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;commands=['EXAMINE STREAM','CLOSELY EXAMINE STREAM','TAKE STREAM','GET STREAM','DROP STREAM','OPEN STREAM','CLOSE STREAM','LOCK STREAM','UNLOCK STREAM','CLIMB INTO STREAM','CLIMB OUT OF STREAM','GET INTO STREAM','GET OUT OF STREAM','SIT IN STREAM','LOOK THROUGH STREAM','GO THROUGH STREAM','TAKE OFF STREAM','TALK TO STREAM','GIVE STREAM TO WATSON','GIVE MONEY TO STREAM','PUT STREAM IN LAMP','PUT LAMP IN STREAM','SHOW STREAM TO WATSON','SHOW MONEY TO STREAM','TELL STREAM ABOUT WATSON','TELL WATSON ABOUT STREAM','EXAMINE LARGE STREAM','CLOSELY EXAMINE YOUR ROCK','EXAMINE CORPSE','EXAMINE BRIDGE','EXAMINE ROCK','N','S','D','OPEN DOOR','SAY WATSON "EXAMINE STREAM"'];rows=[]
for command in commands:
 m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers=saved['input_registers'][:];w.input_stack=saved['input_stack'][:];g.explored=set(saved['explored']);g.last_listed=saved['last_listed'][:];g.last_analysis=saved['last_analysis'];g.opening_pending=False;g.cached_state=None;g.command_job=None;g.job_id=None;w.ended=None;g.ending_messages=[];invocations=[];active=None;selector=None
 def observe(m,r,R):
  global active,selector
  pc=r[R.PC]
  if pc in(0xb633,0xb62f):selector=0 if pc==0xb633 else 1
  if pc==0xa59f and r[R.H]*256+r[R.L]==0x6894:
   active=dict(action=m[0xa033],slot=selector,actor=m[0xa036],arguments=[word(m,r[R.SP]+2+2*i)for i in range(7)],stores=[]);invocations.append(active)
  if active is not None and pc in(0xa88c,0xa8b5):active['stores'].append(r[R.D]*256+r[R.E]if pc==0xa88c else r[R.H]*256+r[R.L])
  if active is not None and pc==0xa5bf:active['final']=word(m,0xa022);active=None
 w.observer=observe;out=g.command(command);rows.append(dict(command=command,text=[x['text']for x in out['messages']if x.get('text')],clock=w.clock(),final=word(m,0xa022),invocations=invocations));print(command,[(r['action'],r['slot'],r.get('final'))for r in invocations],flush=True)
root=p/'sherlock-js/results/dictionary-reference-22';(root/'command-abi.json').write_text(json.dumps(dict(protocol='Controlled complete original commands from intact Kitchen prompt11:36. Restore full RAM/register/editor state for each,all actors retained,no actor/proof/position edits. Capture actual6894 parameters before rendering and A887 stores; other output and clarifications retained as negative scope. Commands may advance original time. Setup is not natural reachability of every input.',cases=rows),separators=(',',':'))+'\n')
