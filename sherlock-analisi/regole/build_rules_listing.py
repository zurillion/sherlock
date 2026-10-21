#!/usr/bin/env python3
"""Estratti verificati per le regole: intestazioni e bytecode separati da Z80."""
import argparse,json,sys
from pathlib import Path
from sherlock_rules import extract

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');args=ap.parse_args()
 sys.path.insert(0,str(args.project/'skoolkit-10.1'))
 from skoolkit.traceutils import disassemble
 from skoolkit.z80 import Assembler
 assembler=Assembler();m=bytes(0x5d80)+(args.project/'sherlock-analisi/block-10.bin').read_bytes();data=extract(args.project)
 regions=[(0x9c6a,0x9c85,'code'),(0x9c85,0x9ca2,'data'),(0x9ca2,0x9cce,'code'),(0xa093,0xa0d8,'code'),(0xbfd9,0xc00c,'code'),
 (0xc4d1,0xc571,'code'),(0xc628,0xc821,'code'),(0xc9bf,0xcaae,'code'),(0xcb28,0xcb2c,'data'),(0xcb2c,0xcb41,'code'),(0xcc0e,0xcc29,'code'),
 (0xcc82,0xccf3,'code'),(0xcd0a,0xcd17,'code'),(0xce3b,0xce6a,'code'),(0xce8f,0xcf43,'code'),(0xcfcf,0xd008,'code'),
 (0xdca2,0xdcc1,'code'),(0xdcc5,0xdcd2,'code'),(0xdda0,0xddb4,'code'),(0xdea4,0xdeaf,'code'),(0xdeb6,0xdec1,'code'),(0xdf06,0xdf2e,'code'),
 (0xdf8d,0xdfa7,'code'),(0xdfb8,0xdfca,'code'),(0xdfca,0xdfcc,'data'),(0xdfcc,0xdfe3,'code'),(0xdffd,0xe003,'code'),(0xe01c,0xe022,'code')]
 comments={0x9c6a:'Selezione callback dell attore dalla tabella9C85.',0x9c85:'Triplette attore/puntatore: include ID6 ->9CA2. NON istruzioni.',0x9ca1:'Contatore della nota85; FF disabilita il conto. Dato mutabile.',0x9ca2:'Se nota85 ha bit7 di+05, decrementa9CA1. A zero diventa BURNT e perde descrizione.',0xa093:'Scorre record attori da8byte, con sentinellaFF.',0xa0b3:'Ripete attore finche costoA01F==0.',0xa0bd:'Aggiunge costoA01F al tempo dovuto del record attore+06/+07.',0xa0cc:'Callback specifica dell attore dopo l avanzamento.',0xbfd9:'Incrementa tempo globale9FDD e minuti9FDF; cambio ora a60.',
 0xc4d1:'Esecuzione di azione con ID; puo ricontrollare/cercare gli argomenti.',0xc53a:'A00B=1 -> valutazione ed esecuzione della regola selezionata.',0xc628:'Classe primo argomento e maschere opzionali.',0xc6be:'Classe secondo argomento e maschere opzionali.',0xc74e:'Modo primo test dai bit3..2, secondo test dai bit1..0 del nibble.',0xc763:'Modo0: tutti; modo1: almeno uno (maschera0 ammessa); modo2: nessuno; modo3: non tutti.',0xc79a:'Una maschera fallita diventa errore soltanto conA00B!=0.',
 0xc9bf:'HL punta all intestazione, NON al codice da eseguire.',0xc9c2:'Controllo luce: si applica se intestazione0 bit5 eD078 segnala buio.',0xc9dd:'Bit6: word+02 = indirizzo predicato Z80.',0xc9f2:'ConA00B=0 termina senza corpo e senza assegnare la durata.',0xc9fd:'Nibble alto del byte+01 ->A01F.',0xca0c:'Calcola corpo: 2byte +2sepredicato +5semaschere.',0xca40:'Bit7: ritornaCF=1, HL=script; il chiamante crea il contesto sospeso.',0xca64:'Altrimenti salta al corpo Z80 tramiteCB2C/CB40.',0xcb28:'IX/IY salvati dal predicato, ripristinati per il corpo.',0xcb40:'JP(HL): predicato o corpo Z80.',0xcc0e:'Cerca ID attore nella tabella9860 con passo8; FF se assente.',0xcc82:'Interprete delle sequenze attori: legge puntatore al prossimo opcode.',0xccc7:'Dispatch sul nibble basso dell opcode.',0xcd0a:'Opcode0B ->ripristino del contesto conCFCF.',0xce3b:'Opcode07: riferimenti degli argomenti ai byte+03/+04; word+01/+02 = regola.',0xce57:'A033=FF: chiamata diretta di regola viaC591, non modello lessicale.',0xce8f:'Avanzamento dopo successo di un opcode.',0xcede:'Riferimenti dinamici: FA ultimaazione, FB attore, FC arg2salvato, FD arg1salvato; FE/FF letterali speciali.',0xcefe:'Calcolo lunghezza/indirizzo successivo del bytecode.',0xcfcf:'Ripristina il contesto sospeso e libera il record temporaneo.',
 0xdca2:'Predicato TAKE: esclude possesso gia acquisito e cicli fra attore e oggetto.',0xdcc5:'TAKE: scrive A036 nel genitore+01 diA013.',0xdda0:'SAY TO: CC0E verifica interlocutore nella tabella attori; B86A analizza o scarta citazioni.',0xdea4:'OPEN: SET5 al byte+05 del primo oggetto.',0xdeb6:'CLOSE: RES5 al byte+05.',0xdf06:'GIVE: nuovo genitoreA035, posizione destinatario e propagazioneD249 ai figli.',0xdf24:'Predicato GIVE: capacita del destinatarioC8C6.',0xdf8d:'Nota85: se contatore nonzero, impostaloFF e cambia qualificatore in SINGED(07D5).',0xdfb8:'Cassaforte89 al giorno0: ramo narrativo che porta a9E74/fine partita.',0xdfca:'Byte saltati dalJR DFC8; mantenuti come dati, non NOP interpretati.',0xe01c:'Predicato cassaforte: ammette soltanto attore0.'}
 for rule in data['rules']:
  start=int(rule['address'],16);body=int(rule['body'],16);regions.append((start,body,'data'));comments[start]=f"Intestazione {rule['label']}: {rule['raw_header']}. Corpo a${body:04X}."
  if rule['deferred']:
   end=int(rule['script'][-1]['address'],16)+1;regions.append((body,end,'data'))
   for op in rule['script']:comments[int(op['address'],16)]=f"BYTECODE: {op['operation']}"+(f" ${op['target']}" if 'target' in op else '')
 regions.sort();assert all(a[1]<=b[0] for a,b in zip(regions,regions[1:]))
 lines=['; Sherlock - regole selezionate. Nessun disassemblaggio Z80 dei metadati o degli script.'];count=total=0
 for a,b,kind in regions:
  lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()} fino a${b-1:04X}']
  while a<b:
   if a in comments:lines+=['; '+comments[a]]
   if kind=='code':op,n=disassemble(m,a);count+=1
   else:
    n=min([a+8,b]+[x for x in comments if a<x<min(a+8,b)])-a;op='DEFB '+','.join(f'${v:02X}' for v in m[a:a+n])
   assert a+n<=b,(hex(a),op);assert bytes(assembler.assemble(op,a))==m[a:a+n]
   lines.append(f'    {op:<34} ; ${a:04X} {m[a:a+n].hex(" ")}');a+=n;total+=n
 args.output.mkdir(parents=True,exist_ok=True);(args.output/'rules.asm').write_text('\n'.join(lines)+'\n');(args.output/'listing-verification.json').write_text(json.dumps({'instructions':count,'bytes_roundtripped':total,'regions':[{'start':f'{a:04X}','end_exclusive':f'{b:04X}','kind':k} for a,b,k in regions]},indent=2)+'\n')
 print('OK:',count,'istruzioni;',total,'byte ricomposti')
if __name__=='__main__':main()
