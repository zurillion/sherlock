#!/usr/bin/env python3
"""Catalogo riproducibile del database entità di Sherlock v2.0.

Legge il payload originale; non esegue il gioco e non modifica i sorgenti.
Richiede il decoder già presente in sherlock-analisi/decoder.
"""
import argparse, hashlib, json, sys
from pathlib import Path
sys.dont_write_bytecode=True

def catalog(project):
    project=Path(project)
    sys.path.insert(0,str(project/'sherlock-analisi/decoder'))
    from sherlock_text import Decoder, EXPECTED_PAYLOAD_SHA256
    payload=(project/'sherlock-analisi/block-10.bin').read_bytes()
    assert hashlib.sha256(payload).hexdigest()==EXPECTED_PAYLOAD_SHA256,'Payload diverso dalla versione analizzata'
    d=Decoder.load(project/'sherlock-analisi/block-10.bin');m=d.mem;w=d.word16
    def ref(v,qualifier=False):
        if not v & 0xfff:return None
        word=d.words[v&0xfff]
        return {'raw':f'{v:04X}','offset':f'{v&0xfff:03X}','stem':word.stem,
                'form':d.inflected(word) if qualifier else word.stem,'high_bits':f'{v&0xf000:04X}'}
    actions={}
    for i in range(1,56):
        a=0x8259+(i-1)*8
        if w(a)==0:break
        actions[i]={'address':f'{a:04X}','words':[ref(w(a+j)) for j in range(0,8,2)]}
    locations={x['id']:x['name_hint'] for x in d.locations()}
    records=[];index=0x8b6f
    while m[index]!=255:
        ident=m[index];p=w(index+1);n=m[p];money=bool(m[p+6]&32)
        refs=[ref(w(p+7)),None if money else ref(w(p+9),True),ref(w(p+11),True)]
        name=' '.join(x['form'] for x in [refs[1],refs[2],refs[0]] if x)
        tail=p+15+n;end=tail;rules=[]
        while m[end]!=255:
            tag,value=m[end:end+2]
            rule={'address':f'{end:04X}','action_id':tag,'value':value}
            if tag==0:rule['meaning']='marcatore di inizio regole del personaggio (C93D/D1DC)'
            else:
                assert tag in actions and value>0
                rule['action_words']=actions[tag]['words']
                rule['rule_pointer']=f'{w(0xaa71+(value-1)*2):04X}'
            rules.append(rule);end+=2
            assert end<p+256,'Coda non terminata'
        end+=1
        if m[index+3]!=255:assert end==w(index+4),'Record non contigui'
        desc=w(p+13)
        amount=((m[p+10] if m[p+10]<128 else m[p+10]-256)*128+(m[p+9]&127)) if money else None
        records.append({'id':ident,'id_hex':f'{ident:02X}','index_address':f'{index:04X}','record':f'{p:04X}','end_exclusive':f'{end:04X}',
          'size':end-p,'name':name,'name_note':'forme lessicali; articolo e maiuscole non riprodotti',
          'occurrence_count':n,'parent_id':None if m[p+1]==255 else m[p+1],
          'field_02':m[p+2],'field_03':m[p+3],'field_04':m[p+4],
          'contents_relation':{1:'in',2:'on',3:'behind',4:'under',5:'tied to'}.get(m[p+4]&7),
          'flags_05':f'{m[p+5]:02X}','flags_06':f'{m[p+6]:02X}',
          'person_flag':bool(m[p+5]&64),'money_flag':money,'money_pence':amount,
          'name_references':refs,'name_words_raw':[f'{w(p+j):04X}' for j in (7,9,11)],
          'description_pointer':f'{desc:04X}','description':d.render(desc) if desc else None,
          'locations':[{'id':i,'name_hint':locations.get(i,'non risolta')} for i in m[p+15:tail]],
          'rules':rules,'raw':m[p:end].hex(' ')})
        index+=3
    assert len(records)==110 and index==0x8cb9 and records[-1]['end_exclusive']=='956A'
    ids={x['id'] for x in records}
    for x in records:
        assert x['parent_id'] is None or x['parent_id'] in ids
        seen={x['id']};parent=x['parent_id']
        while parent is not None:
            assert parent not in seen,'Ciclo contenimento';seen.add(parent);parent=records[parent]['parent_id']
    return {'source':'block-10.bin, prima dell’inizializzazione; non è lo stato al prompt',
      'sha256':EXPECTED_PAYLOAD_SHA256,'index_start':'8B6F','index_sentinel':'8CB9',
      'records_end_exclusive':'956A','record_count':110,'person_flag_count':sum(x['person_flag'] for x in records),
      'actions':actions,'entities':records}

def markdown(data):
    entities=data['entities'];lines=['# Catalogo delle entità di Sherlock','',
      'Dati del payload originale, prima dell’inizializzazione. Gli ID sono decimali e, tra parentesi, esadecimali. Nomi senza articolo; le posizioni sono ID di locazione, il genitore è un ID di entità. La locazione 0 non dimostra la presenza fisica di un personaggio nel mondo giocabile.', '',
      '| ID | Record | Nome | Persona¹ | Genitore | Locazioni | Testo | Regole |',
      '|---|---|---|---|---|---|---|---|']
    for x in entities:
        parent='—' if x['parent_id'] is None else f"{x['parent_id']} ({entities[x['parent_id']]['name']})"
        lines.append(f"| {x['id']} ({x['id_hex']}) | ${x['record']} | {x['name']} | {'sì' if x['person_flag'] else ''} | {parent} | {', '.join(str(l['id']) for l in x['locations'])} | {'$'+x['description_pointer'] if x['description'] else '—'} | {len([r for r in x['rules'] if r['action_id']])} |")
    lines+=['','¹ Bit 6 del byte +05: categoria verificata attraverso C8BE e C929; comprende Holmes. Non equivale a personaggio autonomo attivo.','','## Descrizioni specifiche','']
    for x in entities:
        if x['description']:
            lines +=[f"### {x['id']} — {x['name']} (${x['description_pointer']})",'',x['description']['text'],'']
    lines+=['## Regole locali','', 'Il numero della regola seleziona un puntatore nella tabella $AA71. Le parole indicano il modello lessicale dell’azione, non una traduzione completa del suo comportamento.','']
    for x in entities:
        if x['rules']:
            lines +=[f"### {x['id']} — {x['name']}",'']
            for r in x['rules']:
                if r['action_id']==0:lines +=[f"- ${r['address']}: marcatore 00 00 (regole personaggio)."]
                else:
                    label=' / '.join(y['stem'] for y in r['action_words'] if y)
                    lines +=[f"- ${r['address']}: azione {r['action_id']} ({label}), indice {r['value']} → ${r['rule_pointer']}."]
            lines+=['']
    return '\n'.join(lines)+'\n'

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
    a=ap.parse_args();data=catalog(a.project);a.output.mkdir(parents=True,exist_ok=True)
    (a.output/'entities.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
    (a.output/'CATALOGO.md').write_text(markdown(data))
    print(f"{data['record_count']} entità, {data['person_flag_count']} con bit persona; risultati in {a.output}")
if __name__=='__main__':main()
