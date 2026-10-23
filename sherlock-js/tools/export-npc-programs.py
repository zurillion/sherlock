#!/usr/bin/env python3
"""Offline semantic export of the NPC instruction language, never CPU code."""
import argparse,json,sys,hashlib
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project
sys.path[:0]=[str(p/'sherlock-analisi/ai'),str(p/'sherlock-analisi/regole')]
from decode_npc_ai import decode_op
from sherlock_rules import decode_header
payload=(p/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload
word=lambda x:m[x]+256*m[x+1]
names={0xe488:'location.save',0xe497:'entity.relocate',0xe52f:'counter.create',0xe57a:'counter.decrement',0xe588:'counter.delete',0xe5a8:'wait.tick',0xe5ad:'entity.at',0xe5c1:'actor.withPlayer',0xe5d8:'entity.samePlace',0xe5fd:'entity.sameContainer',0xe79a:'watson.readingWait',0xe7e2:'entity.ownedAndPerceived',0xdd52:'move.adjacent',0xdd61:'location.exitDirection',0xdd84:'parent.save',0xf1d6:'clock.hour',0x9ae1:'cab.travelFast',0x9af4:'cab.travel',0x9c41:'cab.arrive',0xe08d:'cab.takeTo',0xe2c7:'cab.hail',0xe370:'money.pay',0xe3ea:'cab.enter',0xe432:'container.leave',0xe506:'money.refund',0xe518:'money.balanceAsLiteral',0xe63e:'balance.negative',0xe654:'balance.positive',0xe66f:'balance.settled',0xe6bc:'cab.demandPayment',0xe6e6:'cab.customerPresent',0xe70e:'cab.warnDebtor',0xf380:'cab.disembarkRemaining',0xdfca:'ending.quit',0x9e48:'ending.case',0x9ea2:'ending.arrest'}
ops={0:'padding',1:'action',2:'action',3:'rule',4:'order',5:'say',6:'print',7:'rule',8:'signal.send',9:'signal.take',10:'return.failure',11:'return.success',12:'trap',13:'yield',14:'jump',15:'yield'}
actors=[{'id':m[x],'entry':f'{word(x+1):04X}'} for x in range(0x9868,0x9920,8)]
pending=[x['entry'] for x in actors];instructions={};rules={}
def rule(addr):
 key=names.get(addr,f'unimplemented.{addr:04X}')
 if key in rules:return key
 h=decode_header(m,addr);r={'source':h['address'],'classes':[v['class'] for v in h['arguments']],'requiresLight':h['requires_light'],'cost':h['duration'],'masks':h['attribute_masks'],'predicateSource':h['predicate'],'implemented':False}
 if h['deferred']:r['program']=h['body'];pending.append(h['body'])
 rules[key]=r;return key
def drain():
 while pending:
  key=pending.pop(0)
  if key in instructions:continue
  at=int(key,16)
  if not 0x9900<=at<0xf500:raise ValueError(f'Program escapes data bounds at {key}')
  o=decode_op(m,at);k=o['kind'];out={'op':ops[k],'source':key,'size':o['size'],'next':f'{at+o["size"]:04X}'}
  if k in [1,2,3,7,9,4,5,6,8,13,15]:out.update(success=o['success'],failure=o['failure'],erase=bool(o.get('erase_on_success')),restriction=bool(o.get('request_restriction_flag')))
  if 'args'in o:out['args']=o['args']
  if 'action'in o:
   if k in (1,2) and 128<=o['action']<153:out['op']='rule';out['rule']=rule(int(o['rule'],16))
   else:out['action']=o['action']
  elif 'rule'in o:out['rule']=rule(int(o['rule'],16))
  for old,new in [('target_actor','recipient'),('sender','sender'),('text_pointer','text'),('jump','target')]:
   if old in o:out[new]=o[old]
  instructions[key]=out
  if not o.get('terminal_rule'):pending.extend(o['successors'])
  if len(instructions)>10000:raise ValueError('Program graph failed to close')
drain()
# Include the cab's externally installed service and deferred journeys.
extra=[0xf2b6,0xf3ad,0xe452,0xe08d,0xe506]
# Root export is repeated below for extra programs through the same decoder.
for addr in extra:
 if addr in [0xe452,0xe08d,0xe506]:rule(addr)
 else:pending.append(f'{addr:04X}')
drain()
result={'source_sha256':hashlib.sha256(payload).hexdigest(),'language':'NPC domain instructions, not CPU instructions','actors':actors,'instructions':dict(sorted(instructions.items())),'rules':dict(sorted(rules.items())),'installedPrograms':{'cabService':'F2B6','cabJourney':'F3AD'}}
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n');print(len(instructions),'semantic instructions;',len(rules),'rule contracts;',len(actors),'NPC entries')
