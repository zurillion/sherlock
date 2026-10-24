"""Offline complete command traces, not RNG inputs supplied to the JS runtime."""
import argparse,json,sys,hashlib
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
data=extract(p);hello='SAY TO WATSON "HELLO"'
scenarios=[('historical_repeated',None,[hello]*36),
 ('questions',None,['SAY TO WATSON "TELL ME ABOUT LESTRADE"',hello,'TELL WATSON ABOUT CASE',hello]*4),
 ('delayed',None,['SAY TO WATSON "WAIT"',hello,hello,hello,'WAIT',hello]),
 ('following',None,['SAY TO WATSON "FOLLOW ME"',hello,'OPEN YOUR DOOR','WEST',hello,'WAIT',hello]),
 ('reading_and_note',None,['OPEN YOUR DOOR','WEST']+['WAIT']*10)]
for seed in [0,1,7,42,127,255]:scenarios.append((f'after_prompt_seed_{seed}',seed,[hello]*24))
result={'scope':'Historical first prompt; free initial clock; only Watson active after original boot. Optional seed/cursor reset is AFTER the prompt, not seeded bootstrap. Runtime must generate reads; no fixture replay.', 'cases':[]}
for label,seed,commands in scenarios:
 g=Game(p,data,active_npcs=[3]);w=g.world;m=w.m;r=w.sim.registers;R=w.R
 if seed is not None:m[0xa037]=seed;g.parser.put(w.sim,0xa039,0)
 calls=[];pending=None
 def observe(memory,registers,RR):
  global pending
  pc=registers[RR.PC]
  if pc==0xd2ad:
   pending=dict(actor=memory[0xa036],tick=word(memory,0x9fdd),width=registers[RR.A],mixOffset=registers[RR.D]*256+registers[RR.E],seed=memory[0xa037],cursor=word(memory,0xa039),reads=[]);calls.append(pending)
  if pending is not None and pc in (0xd2cb,0xd2d0):
   address=(registers[RR.IXh]*256+registers[RR.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=address,value=memory[address]))
  if pending is not None and pc==0xd2ec:
   value=registers[RR.A];pending.update(result=abs(value if value<128 else value-256),next_seed=memory[0xa037],next_cursor=word(memory,0xa039));pending=None
 w.observer=observe;rows=[]
 for command in commands:
  before=len(calls);out=g.command(command)
  entities=[]
  for ident in [0,3,21,22,23,24,25,26]:
   q=word(m,0x8b70+ident*3);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]])))
  upper=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x] for y in range(144) for x in range(32))
  rows.append(dict(upper_sha256=hashlib.sha256(upper).hexdigest(),input=command,messages=[dict(kind=x['kind'],text=x['text']) for x in out['messages'] if x['text']],clock=w.clock(),random=calls[before:],random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),encounters=list(m[0x9d10:0x9d13]),watson_due=word(m,0x9876),entities=entities))
 result['cases'].append(dict(label=label,seed_after_prompt=seed,commands=rows));print(label,len(rows),len(calls),flush=True)
 a.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
