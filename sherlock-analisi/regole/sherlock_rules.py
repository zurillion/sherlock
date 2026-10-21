#!/usr/bin/env python3
"""Decodifica le intestazioni delle regole di TAKE, GIVE, OPEN e SAY TO.

Separa metadati, predicati Z80, corpi Z80 e piccoli script differiti.
Non pretende di interpretare tutti gli opcode del motore.
"""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ACTIONS={26:'GIVE',36:'OPEN',41:'TAKE',46:'SAY TO'}
CONSTRAINTS={0:'nessuno',1:'locazione con bit7 e uscita raggiungibile',2:'locazione con bit7',3:'locazione/uscita raggiungibile',4:'locazione',5:'letterale orario',6:'letterale valuta',7:'entità senza ulteriore filtro di questa classe',8:'entità percepibile',9:'entità trasportabile: percezione, occorrenza unica, non persona, capacità, catena genitori non personale',10:'entità percepibile posseduta dall’attore',11:'entità percepibile con numero occorrenze diverso da1',12:'entità con bit persona',13:'entità percepibile con bit persona',14:'entità percepibile con bit persona',15:'entità percepibile con bit persona'}
SPECIAL={0xfa:'ultima azione (9FD6)',0xfb:'attore corrente (A036)',0xfc:'secondo argomento salvato (9FD8)',0xfd:'primo argomento salvato (9FD7)',0xff:'assente'}
KNOWN={0xdcc1:'TAKE generale',0xdf02:'GIVE generale',0xdd9e:'SAY TO generale',0xde9d:'OPEN ordinario',0xdfa7:'OPEN cassaforte',0xdf7e:'TAKE biglietto in fiamme',0xdf8b:'aggiornamento biglietto dopo TAKE',0xdfb6:'evento narrativo cassaforte',0xdeaf:'CLOSE ordinario (controllo complementare)'}

def word(m,a):return m[a]+256*m[a+1]

def decode_header(m,address):
    b0,b1=m[address:address+2];p=address+2
    result={'address':f'{address:04X}','label':KNOWN.get(address,'regola non etichettata'),'header_bytes':[b0,b1],
      'arguments':[{'class':n,'meaning':CONSTRAINTS[n]} for n in (b0&15,b1&15)],
      'requires_light':bool(b0&32),'deferred':bool(b0&128),'duration':b1>>4,'predicate':None,'attribute_masks':[]}
    if b0&64:result['predicate']=f'{word(m,p):04X}';p+=2
    if b0&16:
        control=m[p];masks=m[p+1:p+5]
        for i in range(2):
            nib=(control>>(4 if i==0 else 0))&15
            result['attribute_masks'].append({'argument':i+1,'tests':[
                {'mode':(nib>>2)&3,'mask':masks[i*2]}, {'mode':nib&3,'mask':masks[i*2+1]}]})
        p+=5
    result.update(body=f'{p:04X}',header_size=p-address,raw_header=bytes(m[address:p]).hex(' '),body_kind='script differito' if b0&128 else 'codice Z80')
    return result

def decode_script(m,start):
    """Solo i due script senza diramazioni rilevati in questa fase.

    Fermarsi a0B è una scelta di ambito esplicita, non un disassemblatore VM generale.
    """
    result=[];p=start
    for _ in range(16):
        op=m[p]
        if op==7:
            target=word(m,p+1);args=list(m[p+3:p+5]);n=5
            item={'address':f'{p:04X}','opcode':op,'operation':'esegui regola a puntatore','target':f'{target:04X}','arguments':[{'raw':v,'meaning':SPECIAL.get(v,f'ID {v}')} for v in args]}
        elif op==11:
            n=1;item={'address':f'{p:04X}','opcode':op,'operation':'ritorno al contesto sospeso, CFCF'}
        else:raise ValueError(f'Opcode non coperto: {op:02X} a {p:04X}')
        item['raw']=bytes(m[p:p+n]).hex(' ');result.append(item);p+=n
        if op==11:return result
    raise ValueError('Script non terminato entro il limite')

def extract(project):
    project=Path(project);sys.path.insert(0,str(project/'sherlock-analisi/entita'))
    from sherlock_entities import catalog
    cat=catalog(project);payload=(project/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload
    selected={};a=0x9f38
    while m[a]!=255:
        if m[a] in ACTIONS:selected[m[a]]=word(m,a+1)
        a+=3
    roots=set(selected.values());local=[]
    for obj in cat['entities']:
        for rule in obj['rules']:
            if rule['action_id'] in ACTIONS:
                p=int(rule['rule_pointer'],16);roots.add(p)
                local.append({'entity_id':obj['id'],'entity':obj['name'],'action_id':rule['action_id'],'rule':f'{p:04X}'})
    rules={};queue=sorted(roots|{0xdeaf})
    while queue:
        address=queue.pop(0)
        if address in rules:continue
        rule=decode_header(m,address)
        if rule['deferred']:
            rule['script']=decode_script(m,int(rule['body'],16))
            queue += [int(x['target'],16) for x in rule['script'] if 'target' in x]
        rules[address]=rule
    return {'source_sha256':hashlib.sha256(payload).hexdigest(),'actions':[{'id':i,'name':n,'global_rule':f'{selected[i]:04X}' if i in selected else None} for i,n in ACTIONS.items()],
            'local_overrides':local,'rules':list(sorted(rules.values(),key=lambda x:x['address']))}

def markdown(data):
    lines=['# Intestazioni delle regole selezionate','','Indirizzi esadecimali; durata in minuti del modello di tempo del gioco. I corpi marcati Z80 iniziano dopo l’intestazione, non all’indirizzo della regola.','', '| Regola | Indirizzo | Argomenti | Luce | Durata | Predicato | Corpo | Tipo |','|---|---|---|---|---|---|---|---|']
    for r in data['rules']:
        lines.append(f"| {r['label']} | ${r['address']} | {r['arguments'][0]['class']:X}, {r['arguments'][1]['class']:X} | {'sì' if r['requires_light'] else 'no'} | {r['duration']} | {r['predicate'] or '—'} | ${r['body']} | {r['body_kind']} |")
    lines+=['','## Dettagli','']
    for r in data['rules']:
        lines +=[f"### ${r['address']} — {r['label']}",'',f"Intestazione: `{r['raw_header']}`.",'']
        for i,c in enumerate(r['arguments'],1):lines.append(f"- Argomento {i}: classe {c['class']:X} — {c['meaning']}.")
        for a in r['attribute_masks']:
            lines.append(f"- Maschere argomento {a['argument']}: "+'; '.join(f"modo {t['mode']}, maschera ${t['mask']:02X}" for t in a['tests'])+'.')
        for op in r.get('script',[]):
            args=', '.join(x['meaning'] for x in op.get('arguments',[]))
            lines.append(f"- Script ${op['address']}: `{op['raw']}` — {op['operation']}"+(f" ${op['target']} ({args})" if 'target' in op else '')+'.')
        lines+=['']
    return '\n'.join(lines)+'\n'

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
    data=extract(a.project);a.output.mkdir(parents=True,exist_ok=True)
    (a.output/'rules.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n');(a.output/'REGOLE.md').write_text(markdown(data))
    print(f"{len(data['rules'])} blocchi, {len(data['local_overrides'])} associazioni locali; risultati in {a.output}")
if __name__=='__main__':main()
