"""Typed source dossier: nested TELL responses, readers and source-order entropy."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler();data=json.loads((p/'sherlock-js/data/game.json').read_text());table=next(t for t in data['randomInputs']['worldLayout']['tables']if t.get('kind')=='immutable-conversation-topics')
regions=[(0xd349,0xd36a,'code','Ricerca di coppie o triple: prima chiave e terminatoreFF'),(0xe1d8,0xe22a,'code','TELL: selezione della sezione del parlante, argomento e risposta di ripiego'),(0xe22a,0xe28d,'data','Risposte TELL: dieci sezioni ordinate per parlante, 26 argomenti')]
notes={0xd349:'Ingresso per coppie: stride2. TELL usaD34E, stride3.',0xd34e:'Ingresso per triple chiave/word. E201 parte dal primo argomento dopo il byte attore.',0xd358:'La prima chiave uguale vince: prima del controlloFF. Le chiavi della tabella TELL originale sono distinte.',0xd35b:'Se non trova la chiave, si ferma sul terminatoreFF e conserva il suo indirizzo.',0xd363:'IX viene restituito sul record trovato o sul terminatore; nessuno store nella tabella.',0xe1d8:'Il selettore è il PARLANTE A036, non il destinatario A034.',0xe1db:'Selezione della prima sezione del parlante o della sezione predefinitaFE.',0xe1e0:'Salta il byte del parlante: i successivi record sono triple argomento/testo.',0xe1e2:'Argomento richiesto inA035: per esempio16 what happened,17 your alibi,18 your address.',0xe1e8:'Argomento assente nella sezione scelta: usa761D. NON riparte dalla sezioneFE.',0xe1ea:'Legge la word little-endian del testo selezionato: contenuto, non puntatore di codice.',0xe1f2:'6830 è la cornice TELL con parlante, destinatario e testo come argomento.',0xe1fc:'Risposta di ripiego761D quando manca il parlante/default o l’argomento nella sezione scelta.',0xe201:'D34E trova la prima chiave oFF; CPFF trasforma il terminatore in fallimento.',0xe207:'Tabella annidataE22A: byte attore, triple,FF;FF globale dopo l’ultima sezione.',0xe20b:'Confronta l’attore PRIMA del caso specialeFE. Nel payloadFE è l’ultima sezione e intercetta i parlanti senza sezione.',0xe214:'FE è un parlante predefinito, non un argomento e non la fine della tabella.',0xe218:'INC A distingue FF (diventa0) dagli attori ordinari.',0xe21f:'Scavalca una sezione cercando la sua chiaveFF con stride3. Non ordinare le chiavi serializzate.',0xe222:'Passa il terminatore interno; il byte successivo è un nuovo parlante oFF globale.',0xe228:'Nessuna sezione applicabile: ritorno falso. QuestoAF non è il byte datiE22E.',0xe22a:'Dati immutabili:8 è il giardiniere. Tutte le sezioni vengono conservate nell’ordine originale per le letture casuali.',0xe22e:'Byte17=argomento your alibi del giardiniere, NON opcode né puntatore. La word seguente7846 seleziona la risposta. Il resolver deriva il byte dalla tabella tipizzata.'}
fields=[['Struttura','10 sezioni / 26 triple / 99 byte','byte parlante, [byte argomento + word testo]*,FF; poiFF globale'],['FE','Parlante predefinito','Solo se non c’è una sezione del parlante; non è un fallback per argomenti mancanti'],['FF','Due livelli di terminazione','Fine argomenti del parlante e fine tabella dei parlanti'],['Ordine','8,9,10,6,5,4,7,13,95,254','La lookup logica può usare mappe, ma le letture casuali richiedono l’ordine sorgente'],['E22E','17: your alibi del giardiniere','Byte dati seguito dal testo7846; asset immutabile, nessun nuovo campo nelSAVE']]
rows=[];instructions=total=0
def emit(at,op,n,comment=''):
 global total
 assert bytes(assembler.assemble(op,at))==m[at:at+n],(hex(at),op);rows.append(f'    {op:<36} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+comment if comment else''));total+=n
for a,b,kind,label in regions:
 rows+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}']
 if kind=='code':
  at=a
  while at<b:
   op,n=disassemble(m,at);assert at+n<=b;emit(at,op,n,notes.get(at,''));instructions+=1;at+=n
 else:
  for record in table['records']:
   actor=record['actor'];name=data['entities'][actor]['name']if actor<110 else'parlante predefinito FE';emit(record['start'],f'DEFB ${actor:02X}',1,notes.get(record['start'],f'Parlante{actor}: {name}'))
   for t in record['topics']:
    subject=t['subject'];name=data['entities'][subject]['name'];emit(t['start'],f'DEFB ${subject:02X}',1,notes.get(t['start'],f'Argomento{subject}: {name}'));emit(t['start']+1,f'DEFW ${t["text"]}',2,f'Testo della risposta su {name}, word little-endian')
   emit(record['end']-1,'DEFB $FF',1,'Fine degli argomenti di questa sezione; non fine globale')
  emit(b-1,'DEFB $FF',1,'Fine globale della tabella dei parlanti')
root=p/'sherlock-js/results/conversation-topic-table';(root/'conversation-topic-table.asm').write_text('; Analisi offline: tabella dati annidata, distinta dal codice lettore. Roundtrip contro il payload.\n'+'\n'.join(rows)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=instructions,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=157,**({'fields':fields}if k=='data'else{}))for a,b,k,l in regions]),indent=2,ensure_ascii=False)+'\n');print(instructions,total)
