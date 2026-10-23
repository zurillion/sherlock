#!/usr/bin/env python3
"""Offline original comparisons for NPC continuations, route arithmetic and PAY."""
import sys,json,argparse
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path[:0]=[str(p/'sherlock-analisi/parser'),str(p/'sherlock-analisi/ai'),str(p/'sherlock-analisi/cab')]
from sherlock_parser import SherlockParser
from decode_npc_ai import decode_op
from cab import pack_money,unpack_money,extract
E=SherlockParser(p);R=E.R;word=lambda m,x:m[x]+256*m[x+1]
def execute(s,pc):return E.call(s,pc)
def rows(m,head,size):
 out=[];q=word(m,head);seen=set()
 while q:
  if q in seen:raise RuntimeError('List cycle')
  seen.add(q);out.append(list(m[q:q+size]));q=word(m,q-2)
 return out
specs=[('yield',[15,14,128,91],4),('yield_ignored_operand',[13,99,14,128,91],4),('signal_absent',[25,4,128,91,15,14,128,91],3),('signal_send',[8,6,15,14,128,91],4),('counter_three',[3,168,229,147,122,229,128,91,138,91,15,14,128,91],12),('deferred_reading',[3,154,231,15,14,128,91],12),('dynamic_operands',[7,136,228,251,255,7,173,229,251,250,15,14,128,91],6),('wait_action',[1,49,15,14,128,91],4),('erase_once',[162,49,255,255,135,91,15,15,14,128,91],5)]
result={'scope':'Original low-level NPC steps in explicit program fixtures; not a full game or seeded sequence comparison.','programs':[],'routes':[],'money':[],'payments':[]}
for label,program,count in specs:
 s=E.new_sim();m=s.memory;actor=3;row=0x9870;E.put(s,row+1,0x5b80);m[row+3:row+6]=[255,255,255];m[0x5b80:0x5b80+len(program)]=program
 # Isolate records from any historical pending requests/contexts/counters.
 for head in [0x9fe5,0x9fe7,0x9fe9,0x9fee]:E.put(s,head,0)
 if label=='counter_three':E.put(s,0x9fe5,0x5b40);E.put(s,0x5b3e,0);m[0x5b40:0x5b42]=[3,3]
 graph={};q=[0x5b80];done=set()
 while q:
  at=q.pop(0)
  if at in done:continue
  done.add(at);o=decode_op(m,at);graph[o['address']]=o;q.extend(int(v,16) for v in o['successors'])
  if len(done)>100:raise RuntimeError('Fixture graph')
 trace=[]
 for visit in range(count):
  s.registers[R.A]=actor;execute(s,0xcc37)
  for inner in range(20):
   execute(s,0xcc78);cost=word(m,0xa01f)
   trace.append({'visit':visit,'cost':cost,'pc':f'{word(m,row+1):04X}','saved':list(m[row+3:row+6]),'contexts':rows(m,0x9fe9,7),'counters':rows(m,0x9fe5,2),'signals':rows(m,0x9fe7,2),'fixture_bytes':list(m[0x5b80:0x5b80+len(program)])})
   if cost:break
  else:raise RuntimeError('Fixture visit without time')
 result['programs'].append({'label':label,'actor':actor,'program':program,'initialCounter':3 if label=='counter_three' else None,'graph':graph,'rows':trace})
 print(label,len(trace),flush=True)
from verify_cab import native_verify
result['routes']=native_verify(p)['route_checks']
for amount in [-16384,-1000,-128,-1,0,1,127,128,255,1000,16383]:
 s=E.new_sim();m=s.memory;cash=word(m,0x8b70+32*3);s.registers[R.IXh]=cash>>8;s.registers[R.IXl]=cash&255;s.registers[R.H]=(amount&65535)>>8;s.registers[R.L]=amount&255;execute(s,0xe38f);encoded=word(m,cash+9);execute(s,0xe39c);decoded=s.registers[R.H]*256+s.registers[R.L];decoded=decoded-65536 if decoded>=32768 else decoded
 result['money'].append({'amount':amount,'encoded':encoded,'decoded':decoded})
for sender,recipient in [(0,31),(31,0),(0,3)]:
 for funds,received,pay in [(1248,-8,8),(1248,-8,12),(4,-8,8),(-8,1248,4),(0,0,0),(16383,16383,1),(-16384,0,1)]:
  s=E.new_sim();m=s.memory;m[0xa036]=sender;m[0xa035]=recipient
  ids={0:27,31:32};E.put(s,0xa02f,pack_money(pay)|128)
  for who,amount in [(sender,funds),(recipient,received)]:
   if who in ids:E.put(s,word(m,0x8b70+ids[who]*3)+9,pack_money(amount))
  pre=execute(s,0xe34f);success=not pre['z']
  if success:execute(s,0xe374)
  balances={str(who):unpack_money(word(m,word(m,0x8b70+ident*3)+9)) for who,ident in ids.items()}
  result['payments'].append({'sender':sender,'recipient':recipient,'funds':funds,'received':received,'pay':pay,'success':success,'balances':balances})
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n');print('saved',a.output,flush=True)
