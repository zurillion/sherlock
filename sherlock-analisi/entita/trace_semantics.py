#!/usr/bin/env python3
"""Tracce riproducibili della risoluzione degli argomenti, prima dell’esecuzione."""
import sys,json
from pathlib import Path

def probe(engine, text, previous=None):
 R=engine.R
 s=engine.new_sim(previous);m,r=s.memory,s.registers
 keys=list(text.encode('ascii')+b'\r');lower=[];upper=[];events=[];active=False;pending=[];semantic=[];seen=[]
 for step in range(2500000):
  pc=r[R.PC];sp=r[R.SP]
  if pc==0xa536:
   if not keys:break
   r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=engine.word(s,sp);r[R.SP]+=2;continue
  if pc==0xc415:
   r[R.A],r[R.F]=32,0;r[R.PC]=engine.word(s,sp);r[R.SP]+=2;continue
  if pc==0xc1fd:lower.append(r[R.A])
  if pc==0xc2ba:upper.append(r[R.A])
  if pc in (0xc040,0xc0df,0x04c2,0x0556):raise RuntimeError('unexpected control')
  if pending and pc==pending[-1][0] and sp==pending[-1][1]:
   _,_,e=pending.pop();e.update(z=bool(r[R.F]&64),hl=f'{r[R.H]*256+r[R.L]:04X}',args=list(m[0xa034:0xa036]),steps_end=step)
   if e['kind']=='semantic':
    e.update(action=m[0xa033],classes=list(m[0xa00f:0xa011]),counts=list(m[0xb170:0xb172]),slots=list(m[0xb182:0xb184]),a00b=m[0xa00b]);active=False
  if pc==0xb191:
   active=True;e={'kind':'semantic','step':step,'actor_id':m[0xa036],'nodes':engine.nodes(s,engine.word(s,0x9ff2))};semantic.append(e);pending.append((engine.word(s,sp),sp+2,e))
  if active and pc==0xc929:
   e={'kind':'rules','args':list(m[0xa034:0xa036]),'action':m[0xa033],'a00b':m[0xa00b]};events.append(e);pending.append((engine.word(s,sp),sp+2,e))
  if active and pc in (0xb506,0xb5ad):events.append({'kind':'candidate','slot':1 if pc==0xb506 else 2,'id':r[R.A]})
  if active and pc==0xc7a6:events.append({'kind':'argument_constraint','class':r[R.A]&15,'id':r[R.C]})
  if active and pc==0xc8c6:
   e={'kind':'capacity','container_id':r[R.A],'object_id':r[R.B]};events.append(e);pending.append((engine.word(s,sp),sp+2,e))
  if active and pc==0xc960:events.append({'kind':'local_rule','address':f'{r[R.IXh]*256+r[R.IXl]:04X}','pair':list(m[r[R.IXh]*256+r[R.IXl]:r[R.IXh]*256+r[R.IXl]+2])})
  s.opcodes[m[r[R.PC]]]()
 else:raise RuntimeError((text,'budget',hex(r[R.PC])))
 clean=lambda chars:''.join(chr(x) if x>=32 else '\n' if x==13 else '' for x in chars)
 return {'input':text,'steps':step,'lower':clean(lower),'upper':clean(upper),'semantic':semantic,'events':events,'continuation_slot':m[0xa01b]},engine.freeze(s)

if __name__=='__main__':
 import argparse
 ap=argparse.ArgumentParser(description='Tracce del gioco Z80 completo in copie isolate del prompt; nessuna modifica ai file originali.')
 ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
 ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
 args=ap.parse_args();sys.path.insert(0,str(args.project/'sherlock-analisi/parser'))
 from sherlock_parser import SherlockParser
 engine=SherlockParser(args.project)
 cases=['EXAMINE ARMCHAIR','EXAMINE YOUR ARMCHAIR','EXAMINE WATSONS ARMCHAIR','TAKE ARMCHAIR','EXAMINE BOOK','EXAMINE LAMP','TAKE LAMP','GIVE LAMP TO WATSON','TELL WATSON "LOOK"','EXAMINE HEAVY OAK DOOR','EXAMINE OAK HEAVY DOOR','OPEN DOOR','NORTH','EXAMINE ALIBI','COUNT MONEY','SAY TO WATSON "LOOK"','EXAMINE DAILY CHRONICLE','TAKE YOUR ARMCHAIR','OPEN YOUR DOOR','PICK THE NOTE UP','PICK UP THE NOTE','ATTACK WATSON','DRIVE CAB','OPEN DOR']
 out=[]
 for text in cases:
  result,state=probe(engine,text);out.append(result);print(text,[(e['z'],e['hl'],e['args'],e['classes']) for e in result['semantic']],repr(result['lower'][-200:]),repr(result['upper'][-180:]),flush=True)
 r,state=probe(engine,'EXAMINE ARMCHAIR');r2,_=probe(engine,'WATSONS',state);r2['after']='EXAMINE ARMCHAIR';out.append(r2)
 result,state=probe(engine,'TAKE LAMP');result2,_=probe(engine,'GIVE LAMP TO WATSON',state);result2['after']='TAKE LAMP';out.append(result2)
 by={x['input']:x for x in out if 'after' not in x}
 assert by['EXAMINE ARMCHAIR']['semantic'][0]['hl']=='B5E2'
 assert {x['id'] for x in by['EXAMINE ARMCHAIR']['events'] if x['kind']=='candidate'}=={23,24}
 capacity=[x for x in by['TAKE ARMCHAIR']['events'] if x['kind']=='capacity']
 assert len(capacity)==2 and all(x['z'] for x in capacity)
 assert 'which armchair' not in by['TAKE ARMCHAIR']['lower'].lower()
 assert not out[-1]['semantic'][0]['z'] and out[-1]['semantic'][0]['args']==[22,3]
 assert r2['semantic'][0]['args'][0]==24
 assert '5 4/-' in by['COUNT MONEY']['upper']
 assert all(not x['semantic'] for x in out if x['input'] in ('PICK THE NOTE UP','ATTACK WATSON','DRIVE CAB','OPEN DOR'))
 args.output.mkdir(parents=True,exist_ok=True)
 (args.output/'semantic-traces.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
