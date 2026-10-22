#!/usr/bin/env python3
"""Consolida la copertura osservata senza confonderla con le azioni implementate."""
import argparse,collections,json
from pathlib import Path

def build(project,output):
    project=Path(project);audit=json.loads((output/'gameplay-audit.json').read_text())
    entities=json.loads((project/'sherlock-analisi/entita/results/entities.json').read_text())
    payload=(project/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload
    general={};p=0x9f38
    while m[p]!=255:
        general[m[p]]=f'{m[p+1]+256*m[p+2]:04X}';p+=3
    inventory=[]
    for model in audit['native_action_models']:
        ident=model['id'];local=[{'entity':o['id'],'name':o['name'],'rule':r['rule_pointer']} for o in entities['entities'] for r in o['rules'] if r['action_id']==ident]
        observed=sorted({row['label'] for row in audit['cases'] if any(e['id']==ident for e in row['player_actions'])})
        inventory.append({**model,'general_rule':general.get(ident),'local_rules':local,'observed_dispatch_cases':observed,
                          'has_initial_rule':bool(local or ident in general)})
    counts=collections.Counter(row['outcome'] for row in audit['cases'])
    result={'source_payload_sha256':audit['source_payload_sha256'],'baseline_commit':'fc50b3c',
            'scope':'Static initial rule associations plus observed calls to C4D1 in 70 audit commands. C4D1 reached does not imply action success; absence from this audit does not imply missing support. Runtime mutation of tables is not ruled out by a static inventory.',
            'commands':len(audit['cases']),'outcomes':dict(counts),'native_models':len(inventory),
            'models_reaching_executor_in_audit':sum(bool(x['observed_dispatch_cases']) for x in inventory),'models':inventory}
    (output/'gameplay-action-inventory.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    lines=['# Inventario delle azioni e copertura dell’audit','',
           'Baseline `fc50b3c`. Le parole sono i quattro campi del modello lessicale, non una promessa che ogni combinazione inglese venga accettata. “Dispatch osservato” significa ingresso in C4D1, anche per un tentativo che fallisce. Un modello non osservato in questo audit può essere già coperto da altre prove. Le associazioni alle regole sono quelle del payload iniziale.','',
           '| ID | Modello: verbo / prep. / prep. / modificatore | Regola generale | Regole locali | Dispatch nell’audit |',
           '|---:|---|---|---:|---|']
    for row in inventory:
        words=' / '.join(w or '—' for w in row['words']);rule='$'+row['general_rule'] if row['general_rule'] else '—'
        lines.append(f"| {row['id']} | {words} | {rule} | {len(row['local_rules'])} | {'sì' if row['observed_dispatch_cases'] else 'non osservato'} |")
    lines +=['','## Come leggere i risultati','',
              f"L’audit esegue {len(audit['cases'])} comandi e raggiunge l’esecutore per {result['models_reaching_executor_in_audit']} dei {len(inventory)} modelli. Questa è una misura della prova corrente, non una percentuale del gioco implementato.",'',
              'LOCK e UNLOCK hanno modelli (53/54), ma nel catalogo iniziale non hanno associazioni generali o locali; nello stato provato vengono rifiutati. Non si può dedurre dal manuale che manchi una loro traduzione Python: il comando passa già dal codice originale.','',
              'I dettagli per ogni caso, incluse domande, rifiuti, errori del ponte e buffer normalizzato quando valido, sono in `gameplay-audit.json`. Il report conserva anche il confronto originale su una riga lunga 74 caratteri.']
    (output/'GAMEPLAY-ACTIONS.md').write_text('\n'.join(lines)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='models'}))
    return result

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();build(a.project,a.output)
