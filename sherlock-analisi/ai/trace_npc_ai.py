#!/usr/bin/env python3
"""Esegue prove dell'AI sullo Z80 originale, con tutti gli attori abilitati."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True

def word(m,a):return m[a]+256*m[a+1]
class Probe:
 def __init__(self,project,seed=1):
  self.project=Path(project);sys.path.insert(0,str(self.project/'sherlock-analisi/parser'))
  from sherlock_parser import SherlockParser
  self.e=SherlockParser(self.project);self.s=self.e.new_sim();self.m=self.s.memory;self.r=self.s.registers;self.R=self.e.R
  self.m[0xa011]=0;self.m[0xa037]=seed&255;self.e.put(self.s,0xa039,0)
 def state(self):
  m=self.m;actors=[]
  for p in range(0x9860,0x9920,8):
   ident=m[p];o=word(m,0x8b70+ident*3)
   actors.append({'id':ident,'room':m[o+15],'parent':m[o+1],'script':f'{word(m,p+1):04X}','due':word(m,p+6),'saved':list(m[p+3:p+6])})
  lists={}
  for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7),('requests',0x9fee,8),('facts',0x9ff4,5)]:
   p=word(m,head);rows=[];seen=set()
   while p:
    if p in seen or not 0x9000<=p<0xa000:raise RuntimeError(f'Lista {name} non valida: {p:04X}')
    seen.add(p);rows.append({'address':f'{p:04X}','raw':list(m[p:p+size])});p=word(m,p-2)
   lists[name]=rows
  return {'objects':{str(i):{'parent':m[word(m,0x8b70+i*3)+1],'room':m[word(m,0x8b70+i*3)+15]} for i in [22,25,26,85]},'tick':word(m,0x9fdd),'calendar':list(m[0x9fdf:0x9fe3]),'actors':actors,'lists':lists}
 def relocate(self,ident,room):
  # Fixture esplicita: sposta un'entità e i figli, senza alterare PC/stack al prompt.
  children={ident}
  for _ in range(110):
   old=len(children)
   for i in range(110):
    p=word(self.m,0x8b70+i*3)
    if self.m[p+1] in children:children.add(i)
   if len(children)==old:break
  for i in children:self.m[word(self.m,0x8b70+i*3)+15]=room
 def command(self,text,budget=5000000):
  m,r,R=self.m,self.r,self.R;keys=list(text.upper().encode())+[13];before=self.state();events=[];upper=[];lower=[];editing=True;stop='prompt';last_op={}
  def event(kind,**kw):events.append(dict(event=kind,tick=word(m,0x9fdd),actor=m[0xa036],**kw))
  for step in range(budget):
   pc=r[R.PC];ix=r[R.IXh]*256+r[R.IXl]
   if pc==0xa536:
    if not keys:break
    r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
   if pc==0xc415:
    r[R.A],r[R.F]=32,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
   if pc in (0xc040,0xc0df,0xb0ac,0xb0c9):stop=f'boundary_{pc:04X}';break
   if pc==0xd6c1:editing=True
   if pc==0xd6ce:editing=False
   if pc==0xc1fd and not editing:lower.append(r[R.A])
   if pc==0xaa28 and not editing and r[R.A]==32 and not m[0xa027] and m[0x5c3c]:upper.append(32)
   if pc==0xaa6e and not editing and not m[0xa027] and m[0x5c3c]:upper.append(32 if r[R.A]==13 and word(m,r[R.SP])==0xa9f4 else r[R.A])
   if pc==0xcc9e:
    last_op[m[0xa036]]=ix;event('opcode',address=f'{ix:04X}',raw=m[ix],saved=list(m[0x9fd6:0x9fd9]))
   if pc in (0xce8f,0xceb8):event('branch',success=pc==0xce8f,address=f'{word(m,0x9fd9):04X}',cost=word(m,0xa01f))
   if pc==0xc4d1:event('action',action=m[0xa033],args=list(m[0xa034:0xa036]),request=bool(m[0xb934]))
   if pc==0xc9bf:event('rule',address=f'{r[R.H]*256+r[R.L]:04X}',execute=bool(m[0xa00b]),args=list(m[0xa034:0xa036]))
   if pc==0xa0bd:
    row=r[R.IYh]*256+r[R.IYl];event('reschedule',row=f'{row:04X}',old_due=word(m,row+6),cost=word(m,0xa01f))
   if pc==0xb936:event('request_dispatch',script_opcode=r[R.A],request=f'{word(m,0x9fee):04X}')
   if pc==0xcba7:event('request_gate',opcode=m[0xb934],blocked=bool(m[0xb934]&64))
   if pc==0xcd24:event('signal_send',target=m[ix+1])
   if pc==0xcd47:event('signal_test',sender=m[ix+1])
   if pc==0xcdbf:event('npc_order',target=m[ix+1],action=m[ix+2],args=list(m[ix+3:ix+5]))
   if pc==0x9c84:event('callback',address=f'{r[R.H]*256+r[R.L]:04X}')
   if pc==0xba20:event('statement',mode=2)
   if pc==0xe531:event('counter_create',base=m[0xa034],spread=m[0xa035])
   self.s.opcodes[m[pc]]()
  else:stop=f'budget_{r[R.PC]:04X}'
  clean=lambda vals:''.join(chr(x) if x>=32 else '\n' if x==13 else '' for x in vals).replace('\x08','')
  return {'command':text,'stop':stop,'steps':step,'before':before,'after':self.state(),'upper':clean(upper),'lower':clean(lower),'events':events}

def scenarios(project,only=None):
 result=[]
 def case(label,commands,seed=1,fixture=None):
  if only and label not in only:return
  q=Probe(project,seed)
  if fixture:fixture(q)
  rows=[]
  for command in commands:
   row=q.command(command);rows.append(row)
   if row['stop']!='prompt':break
  result.append({'label':label,'seed':seed,'fixture':bool(fixture),'fixture_description':{'lestrade_wait':'Holmes e figli ricollocati in locazione10.','lestrade_wait_flag_clear':'Holmes e figli ricollocati in locazione10; solo bit40 del byte E7E9 azzerato.','lestrade_take':'Lestrade e figli ricollocati in locazione8.','lestrade_west':'Lestrade e figli ricollocati in locazione8.'}.get(label),'commands':rows})
  print(label,[(x['command'],x['after']['tick'],x['stop']) for x in rows],flush=True)
 case('autonomous_seed_1',['WAIT']*10)
 case('autonomous_seed_7',['WAIT']*10,seed=7)
 case('watson_take',['SAY TO WATSON "TAKE LAMP"','WAIT'])
 case('watson_impossible',['SAY TO WATSON "TAKE ARMCHAIR"','WAIT'])
 case('watson_departure',['OPEN YOUR DOOR','WEST']+['WAIT']*9)
 case('watson_drop_follow',['SAY TO WATSON "DROP THE DAILY CHRONICLE"','OPEN YOUR DOOR','WEST']+['WAIT']*3)
 case('watson_follow_order',['SAY TO WATSON "FOLLOW ME"','OPEN YOUR DOOR','WEST']+['WAIT']*3)
 case('watson_innocent',['SAY TO WATSON "WATSON IS INNOCENT"','WAIT'])
 case('watson_accusation',['SAY TO WATSON "BASIL KILLED MRS BROWN"','WAIT'])
 case('watson_tell',['SAY TO WATSON "TELL ME ABOUT LESTRADE"','WAIT'])
 case('watson_statement',['SAY TO WATSON "THE LAMP IS IN THE ROOM"','WAIT'])
 case('watson_go',['SAY TO WATSON "WEST"','WAIT'])
 case('watson_open_then_west',['SAY TO WATSON "OPEN YOUR DOOR. WEST"','WAIT'])
 case('lestrade_wait',['SAY TO LESTRADE "WAIT"','WAIT'],fixture=lambda q:q.relocate(0,10))
 def clear_restriction(q):
  q.relocate(0,10);q.m[0xe7e9]&=~64
 case('lestrade_wait_flag_clear',['SAY TO LESTRADE "WAIT"','WAIT'],fixture=clear_restriction)
 case('lestrade_take',['SAY TO LESTRADE "TAKE LAMP"','WAIT'],fixture=lambda q:q.relocate(2,8))
 case('lestrade_west',['SAY TO LESTRADE "WEST"','WAIT'],fixture=lambda q:q.relocate(2,8))
 return result

def write_report(data,output):
 lines=['# Prove AI sul codice originale','','Tutti gli attori sono abilitati. Tick e locazioni sono decimali. Le fixture sono dichiarate; gli altri scenari partono dal prompt originale senza ricollocamenti. I semi sono applicati dopo il primo prompt. Per eventi e differenze completi vedere `npc-traces.json`.','']
 for c in data:
  lines += ['## '+c['label'],'',f"Seme: {c['seed']}. Fixture: {c.get('fixture_description') or ('sì, vedere script' if c['fixture'] else 'nessuna')}.",'','| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |','|---|---|---|---|']
  for r in c['commands']:
   actors={x['id']:x for x in r['after']['actors']};w,l=actors[3],actors[2]
   lines.append(f"| `{r['command']}` | {r['before']['tick']} → {r['after']['tick']} | {w['room']} / {w['script']} | {l['room']} / {l['script']} |")
  lines+=['','Testo intercettato (sono omesse le sole righe ripetute “You wait.”):','']
  for r in c['commands']:
   text=' '.join(r['upper'].split())
   if text and text!='You wait.':lines += ['> '+text,'']
   if r['lower'].strip():lines+=['Canale inferiore: `'+r['lower'].strip().replace('`',"'")+'`','']
  lines += ['']
 (output/'PROVE.md').write_text('\n'.join(lines)+'\n')

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');ap.add_argument('--only',action='append',help='Esegue soltanto lo scenario indicato (ripetibile).');a=ap.parse_args();a.output.mkdir(parents=True,exist_ok=True)
 data=scenarios(a.project,a.only);(a.output/'npc-traces.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n');write_report(data,a.output)
if __name__=='__main__':main()
