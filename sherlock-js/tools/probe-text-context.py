"""Offline data-language fixtures: derive, rather than copy, random context.

The fixtures at 5B80/5BC0 are compressed text data, not Z80 programs.
"""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from native_world import NativeWorld,word
w=NativeWorld(p);m=w.m;r=w.sim.registers;R=w.R
def token(ident):return dict(op='word',id=ident,randomContext=0x5000+ident,form='stem')
options=[token(1013),token(1047)]
choice=dict(op='choice',options=options)
frequent=word(m,0x67b7)
cases=[('entry',[],[]),('word',[0xd7,0x79],[token(1913)]),
       ('frequent',[96],[token(frequent)]),
       ('possessive',[12],[dict(op='actorPossessive')]),
       ('object_is',[17],[dict(op='objectIs')]),
       ('literal',[34],[dict(op='literal',text='"')]),
       ('call_return',[11,0x40,0],[dict(op='call',text='5BC0',relativeOffset=64)]),
       ('greeting',None,None)]
rows=[]
for label,prefix,semantic in cases:
 for seed in [0,1,7,42,127,255]:
  m[0xa037]=seed;w.engine.put(w.sim,0xa039,0);m[0xa036]=3;m[0xa034]=0;m[0xa027]=0;m[0x5c3c]=1
  root='6920' if prefix is None else '5B80'
  if prefix is not None:
   raw=prefix+[10,2,0xd3,0xf5,0xd4,0x17,30];m[0x5b80:0x5b80+len(raw)]=raw
   m[0x5bc0:0x5bc3]=[0xd7,0x79,30]
  r[R.H]=int(root,16)>>8;r[R.L]=int(root,16)&255;r[R.D]=0x12;r[R.E]=0x34
  calls=[];pending=None
  def observe(memory,registers,RR):
   global pending
   pc=registers[RR.PC]
   if pc==0xd2ad:
    pending=dict(width=registers[RR.A],mixOffset=registers[RR.D]*256+registers[RR.E],seed=memory[0xa037],cursor=word(memory,0xa039),reads=[]);calls.append(pending)
   if pending is not None and pc in (0xd2cb,0xd2d0):
    address=(registers[RR.IXh]*256+registers[RR.IXl]+int(pc==0xd2d0))&65535;pending['reads'].append(dict(address=address,value=memory[address]))
   if pending is not None and pc==0xd2ec:pending.update(next_seed=memory[0xa037],next_cursor=word(memory,0xa039));pending=None
  w.observer=observe;out=w.call(0xa59f)
  texts={} if semantic is None else {'5B80':semantic+[choice,dict(op='endSentence')],'5BC0':[token(1913),dict(op='endSentence')]}
  rows.append(dict(label=label,seed=seed,root=root,texts=texts,text=out['text'],random=calls,initialMixOffset=0x1234))
a.output.write_text(json.dumps(dict(scope='48 isolated native text-data cases. Actor 3, object 0, explicit entry context; native source bytes supplied only to tests, never gameplay.',cases=rows),ensure_ascii=False,indent=2)+'\n')
print(len(rows),'text context cases')
