"""Typed source dossier: parser mode writers, quoted units and ordinary entry."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xA025,0xA026,'data','Stato degli spazi: normalizzazione distinta dal cursore e dal parser'),(0xA9B7,0xAA71,'code','Buffer e normalizzazione: i tre writer A025, confronto esatto prima del wrap'),(0xA887,0xA8AC,'code','Dizionario: emissione soppressa prima del formatter se non visibile'),(0xC1E1,0xC1F4,'code','Uscita invisibile: scarta pixel dopo gli aggiornamenti del normalizzatore'),(0xC129,0xC14A,'code','Cambio finestra: aggiorna cursore e contatore, conserva A025')]
notes={0xA025:'Flag persistente del normalizzatore:0 sopprime lo spazio, nonzero permette lo spazio. Byte iniziale estratto0, non un reset per comando. OldSAVE assente restaunknown finché un writer è dimostrato.',0xA9B8:'CanaleA027 nonzero salta il buffer e AA14: non modificaA025. Non confondere prompt inferiore e normalizzazione superiore.',0xA9D4:'Backspace arretra soltanto il puntatore del buffer; non normalizza caratteri e non scriveA025.',0xA9EB:'CP L salva il confronto con la larghezza PRIMA del possibile CR. Il flagZ non si ricalcola dopo il wrap.',0xA9F1:'Parola troppo lunga per le colonne rimaste: AA14 normalizza un CR, scrivendo1 poi0 anche se C1E1 non disegna.',0xAA04:'Ripristina il confronto iniziale: una parola lunga36 preceduta da wrap non è un riempimento esatto della larghezza precedente.',0xAA08:'Writer0 soltanto se il confronto prima del wrap era uguale. Un wrap grezzo della routine video non è questo writer.',0xAA1F:'Legge il flag di spaziatura: è indipendente da A024 e dal cursore fisico.',0xAA28:'Spazio iniziale conA025=0: ritorna senza alcuno store. Con stato ignoto non si può dedurre0.',0xAA2C:'Writer1 per ogni carattere non soppresso, compresi CR e virgoletta. I caratteri letterali invisibili passano anche qui.',0xAA36:'Writer0 del CR normalizzato; sovrascrive il precedente writer1 dello stesso carattere.',0xAA41:'Inserisce uno spazio grezzo prima della virgoletta; non costituisce un ulteriore writerA025.',0xAA4C:'A026 riguarda le maiuscole e rimane un limite distinto, non implementato dal nuovo contrattoA025.',0xA887:'Con5C3C=0 le parole del dizionario e i nomi non raggiungono il buffer; i caratteri letterali del testo sì.',0xC1E2:'5C3C=0 impedisce il disegno: A9B7 e AA14 hanno però già aggiornato il buffer eA025. Non far avanzare il cursore nascosto.',0xC142:'Ripristina36 colonne e cursore, senza scrivereA025. Non azzerare il flag dal solo cambio finestra.'}
lines=['; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results/output-spacing';root.mkdir(exist_ok=True);(root/'output-spacing.asm').write_text('\n'.join(lines)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=154)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
