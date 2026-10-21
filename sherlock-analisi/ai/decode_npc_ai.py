#!/usr/bin/env python3
"""Decodifica il bytecode di Watson, Lestrade e Basil, separandolo dallo Z80."""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
SIZES={1:2,2:4,3:3,4:5,5:4,6:3,7:5,8:2,9:2,10:1,11:1,12:5,13:2,14:3,15:1}
KINDS={0:'padding',1:'azione senza argomenti',2:'azione con argomenti',3:'regola senza argomenti',4:'accoda ordine a un attore',5:'parla a un destinatario',6:'stampa testo',7:'regola con argomenti',8:'invia segnale',9:'consuma segnale del mittente',10:'ritorna con fallimento',11:'ritorna con successo',12:'trappola JR su se stesso',13:'cede con costo 1 (secondo byte ignorato)',14:'salto assoluto',15:'cede con costo 1'}
RULE_NAMES={0xe488:'salva la locazione del primo argomento in 9FD6',0xe497:'sposta entità alla locazione indicata, staccandola dal genitore',0xe52f:'crea contatore privato base + casuale(ampiezza)',0xe57a:'decrementa contatore; fallisce quando raggiunge zero',0xe588:'elimina contatore privato',0xe5a8:'attesa di costo 1',0xe5ad:'verifica prima locazione dell’entità',0xe5c1:'confronta locazione attore con giocatore attivo',0xe5d8:'confronta prima locazione di due entità distinte',0xe5fd:'confronta le radici del contenimento',0xe79a:'attesa interrompibile di Watson nella stanza iniziale',0xe7e2:'verifica possesso percepibile (classe A)',0xdd52:'raggiungi una locazione attraverso un’uscita diretta',0xdd61:'trova direzione dell’uscita verso la locazione',0xdd84:'salva il genitore del primo argomento in 9FD6',0xf1d6:'verifica ora su 24 ore (non minuti/giorno)',0xdfca:'scena terminale: fine partita',0xef9c:'scena di Basil osservato presso casa sua'}
TERMINAL_RULES={0xdfca,0x9e48,0x9ea2}
def word(m,a):return m[a]+256*m[a+1]
def decode_op(m,a):
 raw=m[a];k=raw&15
 if raw==0:return {'address':f'{a:04X}','opcode':0,'kind':0,'operation':'padding','raw':'00','size':1,'success':f'{a+1:04X}','failure':None,'successors':[f'{a+1:04X}']}
 if not k:raise ValueError(f'Opcode non coperto {raw:02X} a {a:04X}')
 n=SIZES[k];base=a+n;success=word(m,base) if raw&128 else base+(2 if raw&16 else 0)
 failure=word(m,base+(2 if raw&128 else 0)) if raw&16 else base+(2 if raw&128 else 0)
 n+=(2 if raw&128 else 0)+(2 if raw&16 else 0)
 out={'address':f'{a:04X}','opcode':raw,'kind':k,'operation':KINDS[k],'raw':bytes(m[a:a+n]).hex(' '),'size':n,'erase_on_success':bool(raw&32),'request_restriction_flag':bool(raw&64),'success':f'{success:04X}','failure':f'{failure:04X}' if k in (1,2,3,7,9) else None}
 targets=[] if k in (10,11,12) else [word(m,a+1)] if k==14 else [success,failure] if k in (1,2,3,7,9) else [success]
 if k in (1,2):out['action']=m[a+1];out['args']=list(m[a+2:a+4]) if k==2 else [255,255]
 if k in (3,7):out['rule']=f'{word(m,a+1):04X}';out['args']=list(m[a+3:a+5]) if k==7 else [255,255]
 if k in (1,2) and 128<=m[a+1]<153:out['rule']=f'{word(m,0x9fab+2*(m[a+1]-128)):04X}'
 if k==4:out.update(target_actor=m[a+1],action=m[a+2],args=list(m[a+3:a+5]))
 if k in (5,6):out['text_pointer']=f'{word(m,a+(2 if k==5 else 1)):04X}'
 if k in (5,8,9):out['target_actor' if k in (5,8) else 'sender']=m[a+1]
 if k==14:out['jump']=f'{word(m,a+1):04X}'
 if int(out.get('rule','0'),16) in TERMINAL_RULES:targets=[];out['terminal_rule']=True
 out['successors']=[f'{v:04X}' for v in sorted(set(targets))];return out

def extract(project):
 p=Path(project);sys.path.insert(0,str(p/'sherlock-analisi/regole'));sys.path.insert(0,str(p/'sherlock-analisi/decoder'))
 from sherlock_rules import decode_header
 from sherlock_text import Decoder
 payload=(p/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload;d=Decoder.load(p/'sherlock-analisi/block-10.bin')
 cat=json.loads((p/'sherlock-analisi/entita/results/entities.json').read_text());names={x['id']:x['name'] for x in cat['entities']}
 actors=[{'id':m[a],'name':names[m[a]],'row':f'{a:04X}','entry':f'{word(m,a+1):04X}'} for a in range(0x9860,0x9920,8)]
 scripts=[];rules={}
 for ident,ranges in [(3,[(0xe72f,0xe79a),(0xe7b6,0xe7e2)]),(2,[(0xe7e7,0xeaf6)]),(6,[(0xee2b,0xef9c)])]:
  root=next(x for x in actors if x['id']==ident);queue=[int(root['entry'],16)];seen={};external=set()
  while queue:
   a=queue.pop(0)
   if a in seen:continue
   if not any(lo<=a<hi for lo,hi in ranges):external.add(f'{a:04X}');continue
   op=decode_op(m,a);seen[a]=op;queue.extend(int(x,16) for x in op['successors'])
   if 'rule' in op:
    addr=int(op['rule'],16);rules[addr]=decode_header(m,addr)
   if 'text_pointer' in op:op['text']=d.render(int(op['text_pointer'],16))['text']
   if 'action' in op:
    action=cat['actions'].get(str(op['action']));op['action_words']=' '.join(x['stem'] for x in action['words'] if x) if action else None
  scripts.append(dict(root,instructions=sorted(seen.values(),key=lambda x:x['address']),unresolved_successors=sorted(external)))
 # Espansione dei soli corpi esplicitamente marcati bytecode nelle intestazioni.
 pending=list(rules);done=set();subscripts=[]
 while pending:
  addr=pending.pop(0)
  if addr in done:continue
  done.add(addr);header=rules[addr];header['label']=RULE_NAMES.get(addr,'regola da approfondire')
  if not header['deferred']:continue
  queue=[int(header['body'],16)];seen={}
  while queue:
   a=queue.pop(0)
   if a in seen:continue
   if len(seen)>200:raise ValueError('Corpo differito oltre ambito')
   op=decode_op(m,a);seen[a]=op;queue.extend(int(x,16) for x in op['successors'])
   if 'rule' in op:
    b=int(op['rule'],16)
    if b not in rules:rules[b]=decode_header(m,b)
    pending.append(b)
  subscripts.append({'rule':f'{addr:04X}','entry':header['body'],'instructions':sorted(seen.values(),key=lambda x:x['address'])})
 return {'payload_sha256':hashlib.sha256(payload).hexdigest(),'scope':'Tre sequenze NPC; sottosequenze differite raggiunte. Corpi Z80 non interpretati dal decoder.','actors':actors,'scripts':scripts,'subscripts':subscripts,'rules':sorted(rules.values(),key=lambda x:x['address'])}

def markdown(data):
 lines=['# Sequenze NPC decodificate','','Indirizzi esadecimali, ID decimali. Succ./Fall. sono i punti di ripresa; le regole differite possono sospendere la sequenza. `FA/FB/FC/FD` sono riferimenti dinamici, non entità. Il bit `$40` segnala una restrizione agli ordini: non equivale al rifiuto di ogni comando.','']
 for s in data['scripts']+data['subscripts']:
  lines+=['## '+(f"{s['name']} — ID {s['id']}" if 'id' in s else f"Sottosequenza della regola ${s['rule']}"),'','| Indirizzo | Byte | Operazione | Succ. | Fall. |','|---|---|---|---|---|']
  for o in s['instructions']:
   desc=o['operation']
   if 'rule' in o:desc+=f" ${o['rule']} ({RULE_NAMES.get(int(o['rule'],16),'vedere rules.json')})"
   elif 'action' in o:desc+=f" {o['action']} ({o.get('action_words') or 'azione interna'})"
   if 'args' in o:desc+='; arg. '+', '.join(f'${v:02X}' for v in o['args'])
   for key in ['target_actor','sender','jump']:
    if key in o:desc+=f"; {key}={o[key]}"
   if 'text' in o:desc+='; '+o['text'].replace('|','/').replace('\n',' ')
   lines.append(f"| {o['address']} | `{o['raw']}` | {desc} | {o.get('jump',o['success']) if not o.get('terminal_rule') else 'terminale'} | {o['failure'] or '—'} |")
  lines.append('')
 return '\n'.join(lines)+'\n'
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();data=extract(a.project);a.output.mkdir(parents=True,exist_ok=True)
 (a.output/'scripts.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n');(a.output/'SEQUENZE.md').write_text(markdown(data));print(len(data['rules']),'regole;',sum(len(s['instructions']) for s in data['scripts']),'istruzioni NPC;',len(data['subscripts']),'sottosequenze')
if __name__=='__main__':main()
