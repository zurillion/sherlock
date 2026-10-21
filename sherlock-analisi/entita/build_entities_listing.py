#!/usr/bin/env python3
"""Estratti Z80 con dati espliciti e ricomposizione byte per byte."""
import argparse,json,sys
from pathlib import Path
from sherlock_entities import catalog

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');args=ap.parse_args()
 sys.path.insert(0,str(args.project/'skoolkit-10.1'))
 from skoolkit.traceutils import disassemble
 from skoolkit.z80 import Assembler
 data=catalog(args.project);m=bytes(0x5d80)+(args.project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
 regions=[(0x8259,0x840b,'data'),(0x8b6f,0x956a,'data'),(0xa419,0xa476,'code'),(0xa4cd,0xa536,'code'),(0xaa71,0xaaa1,'data'),
 (0xb16d,0xb191,'data'),(0xb191,0xb39c,'code'),(0xb39c,0xb39d,'data'),(0xb39d,0xb4a2,'code'),(0xb4a2,0xb4a3,'data'),(0xb4a3,0xb549,'code'),(0xb549,0xb54a,'data'),(0xb54a,0xb5fc,'code'),
 (0xc45e,0xc471,'code'),(0xc493,0xc4d1,'code'),(0xc628,0xc9fb,'code'),
 (0xd04f,0xd05a,'code'),(0xd1dc,0xd224,'code'),(0xd237,0xd29d,'code'),(0xd2ed,0xd33c,'code'),(0xd349,0xd448,'code'),(0xd495,0xd590,'code'),(0xd5c9,0xd5d3,'data'),(0xd5d3,0xd5ef,'code'),
 (0xdf2e,0xdf40,'code'),(0xdf49,0xdf7e,'code'),(0xe31c,0xe328,'code'),(0xe32c,0xe345,'code'),(0xe38f,0xe3b8,'code')]
 comments={0x8259:'54 modelli lessicali da 8 byte + word zero. Nibble alti = metadati, non parte dell offset lessicale.',0x8b6f:'Indice entita: triplette ID, puntatore LE. Non codice.',0x8cb9:'Sentinella FF della tabella indice.',0xaa71:'24 puntatori LE raggiunti dalle regole locali qui censite; non codice.',
 0xb16d:'Stato dei due argomenti e contatori. B172/B178: triplette nominali; B182/B183: slot AST.',0xb191:'Risoluzione semantica del comando: inizializza argomenti a FF e riconosce modello verbo.',0xb201:'A00B=0: richiesta di verifica, prima dell esecuzione delle azioni.',0xb224:'Enumera primo argomento; C929 filtra candidati con le regole dell azione.',0xb244:'Conta superstiti: zero -> B65F; uno -> nuova verifica; piu di uno -> B5E2.',0xb280:'Ramo con secondo argomento: controlla combinazioni, non due elenchi indipendenti.',0xb2df:'Enumera secondo argomento e conta le combinazioni ammesse da C929.',0xb308:'Prima conta dei candidati nominali, senza il filtro completo dell azione.',0xb34f:'Inizializza cursore ricerca: indice entita per classe>=7, cursore locazioni altrimenti.',0xb39c:'Byte di stato, non NOP.',0xb39d:'Confronto dei modelli lessicali da 8259; restituisce indice del modello in A033.',0xb405:'Ordina i due argomenti in base al modello e alle preposizioni.',0xb4a2:'Byte di stato per argomento numerico, non NOP.',0xb4c1:'Argomento1: seleziona enumeratore entita D36A o locazioni D39B; letterali -> FE.',0xb4fd:'Candidato nominale nel primo slot A034, poi esclusioni ALL/EXCEPT.',0xb517:'Esclusioni dei comandi collettivi.',0xb549:'Byte di stato per secondo argomento numerico.',0xb568:'Secondo argomento, analogo al primo; risultato A035.',0xb5b6:'Sposta il nodo in sospeso da 9FF2 a 9FF0; A01B conserva slot08/12.',0xb5d3:'Domanda di precisazione sul secondo argomento.',0xb5e2:'Domanda sul primo argomento; testo base 6888.',
 0xc493:'Classi di ricerca del primo argomento: 0,4,5,7 derivate dal modello.',0xc4b2:'Classi di ricerca del secondo argomento.',0xc628:'Vincolo sul primo argomento del blocco di regole.',0xc6be:'Vincolo sul secondo argomento.',0xc74e:'Valutazione maschere sul byte record+05.',0xc79a:'Una maschera fallita non e necessariamente eliminatoria nella fase A00B=0.',0xc7a6:'Selettore dei vincoli di tipo/accessibilita: il nibble appartiene alla regola, non ad A00F.',0xc821:'Filtro percettivo: contenitori, bit7 di +05, posizione del soggetto e lista locazioni.',0xc86e:'Risalita dei contenitori; bit7, bit5 e bit3 del byte+05.',0xc8a7:'Verifica occorrenza unica: record+00 ==1.',0xc8af:'Risalita dei genitori e controllo categoria persona.',0xc8be:'Test di categoria persona: bit6 di record+05.',0xc8c6:'Confronto quantitativo fra contenitore, oggetto e contenuti usando campo+03.',0xc8ef:'Prepara A013/A015 come puntatori a record entita o locazioni secondo le classi.',0xc929:'Seleziona regola del personaggio, regola dell oggetto o regola generale.',0xc93d:'Cerca marcatore zero nella coda dell attore; poi cerca azione con passo2.',0xc954:'Cerca azione nella coda del primo oggetto.',0xc960:'Byte indice -> word nella tabella AA71.',0xc972:'Fallback: indice globale azioni a9F38.',0xc9f2:'Se A00B=0 ritorna prima di eseguire il corpo della regola.',
 0xd04f:'IX = indice entita meno3; D206 avanza prima di leggere.',0xd1dc:'Avanza di 0F+numero_locazioni; cerca coppie azione/indice, si ferma su FF o zero.',0xd206:'Passo3 dell indice: IX punta alla tripletta, IY al record.',0xd237:'Lookup entita: A=ID -> IX=record, usando indice8B6F e ricercaD34E.',0xd249:'Aggiorna posizione dei discendenti secondo parent_id, ricorsivamente.',0xd275:'Verifica catena di possesso rispetto al soggetto A036; FE/FF speciali.',0xd2ed:'Somma campo+02 dei figli diretti (B=1).',0xd2f2:'Somma ricorsiva campo+03 dei contenuti (B=0).',0xd349:'Ricerca ID in coppie (passo2).',0xd34e:'Ricerca ID in triplette (passo3).',0xd36a:'Matching delle entita: nome+qualificatori a record+07 e filtro C821.',0xd39b:'Matching delle locazioni: indice840B; spazio ID distinto da quello delle entita.',0xd3d5:'Stampa nome dell entita da IX; D3E8 riceve puntatore a record+07.',0xd3fd:'Bit5 di +06: il campo+09 non e un qualificatore lessicale (denaro).',0xd531:'Imposta bit7 di+06 quando enumera un oggetto nella descrizione della scena.',0xd5c9:'Cinque riferimenti LE: in/on/behind/under/tied.',0xd5d3:'Parte bassa (3bit) di+04: relazione per presentare il contenuto del contenitore.',0xd495:'Restituisce locazione+0F solo se occorrenza unica, altrimenti FF.',0xdf2e:'Predicato di EXAMINE: considera catena di possesso.',0xdf5b:'EXAMINE: imposta bit6 di+06, stampa descrizione +0D/0E oppure nome generico.',0xe31c:'COUNT: richiede bit5 di+06 (campo monetario).',0xe32c:'Stampa il valore +09/+0A tramiteA419.',0xe38f:'Codifica importo: byte basso usa7bit; byte alto conserva segno.',0xe39c:'Decodifica importo dal record: signed(high)*128+(low&127).',0xa419:'Formattazione valuta in sterline (240pence), scellini (12pence) e pence.',0xa4e0:'Nome + fino a2 qualificatori: prova entrambi gli ordini.',0xa51b:'Word query zero = wildcard; confronta solo12bit del riferimento.'}
 for x in data['entities']:
  comments[int(x['record'],16)]=f"Entita {x['id']} (${x['id_hex']}): {x['name']}; {x['size']} byte."
  comments[int(x['record'],16)+15+x['occurrence_count']]='Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.'
 lines=['; Sherlock v2.0 - entita e risoluzione semantica. Intervalli scelti, non disassemblato lineare.'];count=0;total=0
 for start,end,kind in regions:
  p=start;lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()} fino a ${end-1:04X}']
  while p<end:
   if p in comments:lines+=['; '+comments[p]]
   if kind=='code':op,n=disassemble(m,p);count+=1
   else:
    n=min([end,p+8]+[v for v in comments if p<v<min(end,p+8)])-p
    op='DEFB '+','.join(f'${x:02X}' for x in m[p:p+n])
   assert p+n<=end,(hex(p),op)
   assert bytes(assembler.assemble(op,p))==m[p:p+n],(hex(p),op)
   lines.append(f'    {op:<34} ; ${p:04X} {m[p:p+n].hex(" ")}');p+=n;total+=n
 args.output.mkdir(parents=True,exist_ok=True)
 (args.output/'entities-semantics.asm').write_text('\n'.join(lines)+'\n')
 (args.output/'listing-verification.json').write_text(json.dumps({'instructions':count,'bytes_roundtripped':total,'regions':[{'start':f'{a:04X}','end_exclusive':f'{b:04X}','kind':k} for a,b,k in regions]},indent=2)+'\n')
 print(f'OK: {count} istruzioni; {total} byte ricomposti, inclusi dati espliciti')
if __name__=='__main__':main()
