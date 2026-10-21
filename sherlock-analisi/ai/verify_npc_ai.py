#!/usr/bin/env python3
"""Confronti con l'interprete Z80 e controlli sulle tracce NPC."""
import argparse,json,sys
from pathlib import Path
from decode_npc_ai import SIZES,decode_op,extract
from trace_npc_ai import Probe,word
sys.dont_write_bytecode=True

def verify(project,output):
 q=Probe(project);e,R=q.e,q.R;tests=[]
 def check(name,ok,**details):
  assert ok,(name,details)
  tests.append(dict(test=name,passed=True,**details))
 # CF03 misura il corpo, CEFE misura corpo + eventuale puntatore sul successo.
 for kind,size in SIZES.items():
  for flags in (0,16,128,144):
   s=e.new_sim();s.registers[R.A]=kind|flags;s.registers[R.H]=0x5b;s.registers[R.L]=0x80
   e.call(s,0xcf03);result=s.registers[R.H]*256+s.registers[R.L]
   check(f'length_base_{kind:02X}_{flags:02X}',result==0x5b80+size)
   s.registers[R.A]=kind|flags;s.registers[R.H]=0x5b;s.registers[R.L]=0x80
   e.call(s,0xcefe);result=s.registers[R.H]*256+s.registers[R.L]
   check(f'length_failure_cursor_{kind:02X}_{flags:02X}',result==0x5b80+size+(2 if flags&128 else 0))
 # Riferimenti dinamici: F5..F9 sono alias dell'argomento1, come FD.
 s=e.new_sim();s.memory[0x9fd6:0x9fd9]=[23,45,67];s.memory[0xa036]=3
 for value,expected in [(4,4),(0xf5,45),(0xf9,45),(0xfa,23),(0xfb,3),(0xfc,67),(0xfd,45),(0xfe,254),(0xff,255)]:
  s.registers[R.A]=value;ret=e.call(s,0xcede);check(f'reference_{value:02X}',ret['a']==expected,result=ret['a'])
 # Fixture: programma minimo, nella RAM di input, non nel payload.
 q=Probe(project);m=q.m;s=q.s;r=q.r
 def step(actor,program):
  row=0x9860+next(i for i in range(24) if m[0x9860+i*8]==actor)*8
  m[0x5b80:0x5b80+len(program)]=program;e.put(s,row+1,0x5b80);r[R.A]=actor;e.call(s,0xcc37);e.call(s,0xcc78)
  return {'cost':word(m,0xa01f),'next':f'{word(m,row+1):04X}','signals':q.state()['lists']['signals']}
 first=step(6,[0x19,4,0x80,0x5b,0x0f]);check('signal_absent_yields',first['cost']==1 and first['next']=='5B80')
 sent=step(4,[8,6]);check('signal_records_sender_target',any(x['raw']==[4,6] for x in sent['signals']))
 received=step(6,[0x19,4,0x80,0x5b,0x0f]);check('signal_consumed_once',received['next']=='5B84' and not received['signals'] and received['cost']==0)
 # Un ordine prefabbricato usa la stessa coda, senza lessico/parser.
 step(2,[4,3,41,22,255]);requests=q.state()['lists']['requests'];check('npc_order_record',any(x['raw'][:5]==[3,255,41,22,255] for x in requests))
 r[R.A]=3;e.call(s,0xcc37);e.call(s,0xcc78);lamp=word(m,0x8b70+22*3)
 check('npc_order_executed_by_recipient',m[lamp+1]==3,parent=m[lamp+1])
 # Il flag40 non blocca la variante prefabbricata (tipoFF) degli ordini NPC.
 q=Probe(project);m,s,r=q.m,q.s,q.r
 m[0x5b80:0x5b85]=[4,6,49,255,255];e.put(s,0x9869,0x5b80)
 r[R.A]=2;e.call(s,0xcc37);e.call(s,0xcc78)
 before=word(m,0x9889);r[R.A]=6;e.call(s,0xcc37);e.call(s,0xcc78)
 check('prefabricated_order_bypasses_script_gate',m[before]&64 and word(m,0xa01f)==5 and word(m,0x9889)==before,script=f'{before:04X}',cost=word(m,0xa01f))
 # Cancellazione del bytecode marcato bit5, compreso il puntatore di successo.
 s=e.new_sim();s.memory[0x5b80:0x5b88]=[0xa2,41,22,255,0x90,0x5b,0xaa,0xbb]
 s.registers[R.IXh]=0x5b;s.registers[R.IXl]=0x80;e.call(s,0xcf43)
 check('erase_once_bytecode',s.memory[0x5b80:0x5b88]==[0,0,0,0,0,0,0xaa,0xbb])
 data=extract(project);check('selected_graphs_closed',all(not x['unresolved_successors'] for x in data['scripts']))
 # Nessun byte rivendicato contemporaneamente come opcode e intestazione.
 script_bytes={int(o['address'],16)+i for sc in data['scripts']+data['subscripts'] for o in sc['instructions'] for i in range(o['size'])}
 header_bytes={int(h['address'],16)+i for h in data['rules'] for i in range(h['header_size'])}
 check('bytecode_not_rule_headers',not script_bytes&header_bytes)
 traces=json.loads((output/'npc-traces.json').read_text());byname={x['label']:x for x in traces}
 for case in traces:check('all_commands_completed_'+case['label'],all(x['stop']=='prompt' for x in case['commands']))
 take=byname['watson_take']['commands'][0]
 check('watson_take_action',any(x['event']=='action' and x['actor']==3 and x['action']==41 and x['args']==[22,255] and x['request'] for x in take['events']))
 wait=byname['lestrade_wait']['commands'][0]
 check('lestrade_wait_refusal', 'Sorry, I cannot do that now.' in wait['upper'] and any(x['event']=='request_gate' and x['actor']==2 and x['blocked'] for x in wait['events']))
 autonomous=byname['autonomous_seed_1']['commands']
 check('lestrade_orders_cabbie',any(x['event']=='npc_order' and x['actor']==2 for c in autonomous for x in c['events']) and any(x['event']=='request_dispatch' and x['actor']==31 for c in autonomous for x in c['events']))
 check('basil_waits_for_straker',any(x['event']=='signal_test' and x['actor']==6 and x['sender']==4 for c in autonomous for x in c['events']))
 clear=byname['lestrade_wait_flag_clear']['commands'][0]
 check('single_bit_changes_refusal', 'Inspector Lestrade waits.' in clear['upper'] and 'Sorry, I cannot do that now.' not in clear['upper'])
 drop=byname['watson_drop_follow']['commands']
 check('drop_changes_watson_program',drop[0]['after']['objects']['25']['parent']==24 and any(a['id']==3 and a['room']==7 for a in drop[2]['after']['actors']))
 follow=byname['watson_follow_order']['commands']
 check('follow_order_reaches_player',any(a['id']==3 and a['room']==7 for a in follow[2]['after']['actors']))
 departure=byname['watson_departure']['commands'][-1]['after']
 check('watson_leaves_note_and_map',departure['objects']['26']['room']==8 and any(a['id']==3 and a['room']==0 for a in departure['actors']))
 statement=byname['watson_accusation']['commands'][0]
 check('statement_separate_dispatch',any(x['event']=='statement' and x['actor']==3 for x in statement['events']))
 check('statement_adds_fact',not statement['before']['lists']['facts'] and any(x['raw'][:3]==[6,5,94] for x in statement['after']['lists']['facts']))
 check('take_changes_parent',take['after']['objects']['22']['parent']==3)
 result={'passed':True,'checks':len(tests),'tests':tests,'signal_fixture':{'absent':first,'sent':sent,'received':received},'scope':'Prove limitate: non dimostrano ogni scena o combinazione dello stato del gioco.'}
 (output/'verification.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n');print('OK',len(tests),'controlli')

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();verify(a.project,a.output)
if __name__=='__main__':main()
