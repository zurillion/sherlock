#!/usr/bin/env python3
"""Estratti aggiuntivi verificati: citazioni e continuazioni."""
import argparse,json,sys
from pathlib import Path
from sherlock_parser import SherlockParser

def build(project,output):
    e=SherlockParser(project);m=e.audit.decoder.mem
    from skoolkit.traceutils import disassemble
    from skoolkit.z80 import Assembler
    assembler=Assembler()
    regions=[(0x994D,0x9965,'data'),(0xAAB2,0xAB11,'code'),(0xABF3,0xAC24,'code'),
      (0xAD6C,0xADD4,'code'),(0xAF6B,0xAFB3,'data'),(0xAFB3,0xB16D,'code'),
      (0xB447,0xB468,'code'),(0xB5B6,0xB5D3,'code'),(0xB86A,0xB934,'code'),
      (0xBA20,0xBA60,'code'),(0xD99E,0xD9AC,'code'),(0xDDA0,0xDDB4,'code')]
    comments={
      0x994D:'Tabella LE di 11 predicati del modo2, terminata da 0000; NON istruzioni.',
      0xAAB2:'Ingresso comune; A024 e impostato dal chiamante (0,1,2).',
      0xAAD1:'Modo0: prova gruppo nominale come soggetto, altrimenti riparte in modo1.',
      0xAAEA:'Gruppo iniziale senza relazioni: modo2; copia 6 byte da AAAC al nodo+18.',
      0xAB08:'Rifiuta ipotesi soggetto e riavvolge cursore per modo1.',
      0xABF3:'Modo2: predicato deve figurare nella tabella 994D; non basta classe E0.',
      0xAD6C:'Continuazione: A01B nonzero, nodo pendente a 9FF0.',
      0xAD79:'Se la nuova frase porta un verbo, non fondere: sostituire il comando.',
      0xAD83:'A01B=08/12 indica l inizio del referente+qualificatori nel vecchio nodo.',
      0xAD9E:'AE59 copia soltanto nelle word a zero; il referente esistente resta.',
      0xADA4:'Se il primo qualificatore era occupato, prova il secondo slot.',
      0xADBC:'Scollega/libera nodo transitorio (o vecchio nodo se nuovo verbo).',
      0xAF6B:'Dispatch normale: 12 coppie (offset parola, handler).',
      0xAF9B:'Dispatch modo2: 6 coppie (offset parola, handler).',
      0xAFB3:'Selezione della tabella in funzione di A024.',
      0xAFE1:'Guardia: handler ammesso solo prima di un verbo nel gruppo.',
      0xAFE8:'ALL richiede verbo oppure contesto precedente/continuazione.',
      0xAFFA:'BECAUSE/THEREFORE diventano coordinazione D=A0; nessun flag causale qui.',
      0xB01C:'BUT/EXCEPT richiede ALL, alloca nodo esclusione e imposta bit6 del verbo.',
      0xB033:'ALL/EVERYTHING imposta bit7 del verbo e stato A01A=1.',
      0xB049:'Virgoletta: se manca verbo usa offset088B TALK (SAY e alias di TALK).',
      0xB05E:'Coda dei puntatori alle citazioni: testa 9FEC.',
      0xB085:'Cerca virgoletta90 con valore0; non un generico token90.',
      0xB092:'Il delimitatore finale viene temporaneamente convertito in C0.',
      0xB09A:'PAUSE: prima guardia, poi lettura tasto. Nel tool attesa bypassata.',
      0xB0AC:'LOAD/QUIT modifica stato temporale; nessuna lettura nastro in questa routine.',
      0xB0C6:'SAVE: guardia sintattica prima di modificare flag di controllo.',
      0xB0FD:'THAT: copia 6 byte da gruppo nominale precedente a soggetto+18.',
      0xB135:'HE: A024=2, flag80 nel byte soggetto+19.',
      0xB151:'IT e THEY: medesimo handler, flag40 in soggetto+19.',
      0xB447:'B182/B183 ricevono offset08/12 secondo il ruolo dei due argomenti.',
      0xB5B6:'Preparazione domanda: A01B=A; sposta primo nodo da9FF2 a9FF0; tronca link.',
      0xB86A:'Consumatore reale della coda9FEC; A nonzero richiede analisi del contenuto.',
      0xB88F:'Solo con A!=0 chiama B8AA; con A=0 scarta citazione senza analizzarla.',
      0xB894:'Ripristina il delimitatore da C0 a90 nel caso di scarto/fallimento.',
      0xB8AA:'Secondo ingresso: B868=inizio token citazione, A024=0 (autodetect).',
      0xB8B4:'Salva lista esterna9FF0, analizza citazione in lista separata.',
      0xB8BE:'Ripete AAB2 per tutte le unita fino aC0; A024 non azzerato tra unita.',
      0xB8D1:'Successo: ripristina90, alloca record di 8 byte in lista9FEE.',
      0xB8E5:'Record citazione +05/+06 = testa della lista sintattica.',
      0xB8F6:'Record +00 = A034 (identita proveniente dal livello precedente).',
      0xB8FC:'Record +07 = modo finale1/2 della citazione.',
      0xB904:'Errore: libera nuova lista e ripristina lista esterna.',
      0xB90E:'Recupera lista della citazione associata a un referente.',
      0xBA20:'Raccordo del modo2 con interprete affermazioni; non implementato nel tool.',
      0xBA4E:'D1DB elabora affermazioni: fase successiva alla sola sintassi.',
      0xD99E:'@ riusa il buffer soltanto se A01B=0; durante continuazione torna alla lettura.',
      0xDDA0:'Raccordo del gioco: controlla referente e passa A=0/1 aB86A.',
    }
    lines=['; Sherlock: citazioni, modi e continuazioni. Byte originali, commenti interpretativi.']
    instructions=total=0
    for a,b,kind in regions:
        lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()} ${a:04X}..${b-1:04X}']
        while a<b:
            if a in comments:lines+=['','; '+comments[a]]
            if kind=='code':op,n=disassemble(m,a);instructions+=1
            else:
                n=min([b,a+4]+[x for x in comments if a<x<min(b,a+4)])-a
                op='DEFB '+','.join(f'${x:02X}' for x in m[a:a+n])
            assert a+n<=b
            assert bytes(assembler.assemble(op,a))==m[a:a+n]
            lines.append(f'    {op:<25} ; ${a:04X} {m[a:a+n].hex(" ").upper()}');a+=n;total+=n
    output.mkdir(parents=True,exist_ok=True)
    (output/'parser-special.asm').write_text('\n'.join(lines)+'\n')
    metadata={'modes':{'0':'autodetect citazione','1':'comandi','2':'affermazioni'},
              'statement_verbs':[], 'dispatch_normal':[], 'dispatch_mode2':[]}
    for a in range(0x994D,0x9963,2):
        value=e.audit.decoder.word16(a);metadata['statement_verbs'].append({'address':f'{a:04X}','offset':f'{value:04X}','word':e.audit.decoder.words[value].stem})
    for key,a,b in [('dispatch_normal',0xAF6B,0xAF9B),('dispatch_mode2',0xAF9B,0xAFB3)]:
        for p in range(a,b,4):
            ref=e.audit.decoder.word16(p);target=e.audit.decoder.word16(p+2)
            metadata[key].append({'table_address':f'{p:04X}','offset':f'{ref:04X}','word':e.audit.decoder.words[ref].stem if ref else '<quote>','handler':f'{target:04X}'})
    (output/'special-tables.json').write_text(json.dumps(metadata,indent=2)+'\n')
    summary={'instructions':instructions,'bytes_roundtripped':total,'mismatches':0,
             'regions':[{'start':f'{a:04X}','end_exclusive':f'{b:04X}','kind':k} for a,b,k in regions]}
    (output/'listing-special-verification.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({'instructions':instructions,'bytes':total,'mismatches':0}))
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    p.add_argument('--output',type=Path,default=Path(__file__).resolve().parent)
    a=p.parse_args();build(a.project,a.output)
