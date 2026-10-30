"""GIVE roles, possession and NPC request lifetime: offline typed excerpts."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xA022,0xA024,'data','Ultimo riferimento lessicale emesso: offset12 bit e contesto4 bit'),(0xA37D,0xA419,'code','Composizione dell’azione: riferimenti lessicali e nomi argomento'),(0xA5CD,0xA5F2,'code','Token lungo: conserva il nibble di modo nella chiamata lessicale'),(0xA63F,0xA65E,'code','Terminazione: parola finale e CR senza riscrittura del riferimento'),(0xA815,0xA82F,'code','Nome: ricompone il modo40 o50 prima dell’emissione'),(0xA880,0xA895,'code','Ingresso lessicale: gating, primo store e riferimento zero'),(0xA895,0xA8B9,'code','Spazio iniziale e secondo store del riferimento con il suo modo'),(0xA8B9,0xA92F,'code','Ricostruzione della parola e suffisso: il riferimento rimane conservato'),(0xD3E8,0xD448,'code','Nomi dinamici: qualificatori con modo40, sostantivo con modo50')]
notes={0xA022:'Word mutabile condivisa, non istruzioni: byte basso dell’offset aA022, byte alto con nibble di modo aA023. Restano invariati nei caratteri letterali e nell’emissione disabilitata. Il runtime non possiede ancora questo campo dopo ogni output sintetico: i percorsi senza contratto lo revocano, vecchi save restano sconosciuti.',0xA39E:'Il modificatore del modello viene letto con A880, che elimina i nibble di metadati prima dell’emissione. Un riferimento zero raggiunge soltanto il primo store.',0xA3A2:'Stampa il verbo dal modello, poi preposizioni e nomi secondo i flag. Nell’ordine GO TO SLATER STREET il nome della destinazione termina in STREET: D442 emette5000|0861.',0xA5D4:'Il primo byte del token AND7F diventa D: i bit12–14 non sono parte dell’offset ma restano nel riferimento conservato. Non memorizzare solo il risultato flesso o il testo inglese.',0xA647:'Una parola terminale attraversa ancora A887 prima di punto/CR. Gli ingressi A63F/A643 dei comandi senza parola saltano questo CALL e mantengono il riferimento precedente.',0xA81B:'D=A|nibble basso dell’offset.40 forza il suffisso,50 usa la radice; il byte basso non viene ricavato dall’ultima parola visibile a video.',0xA887:'5C3C=0: ritorna PRIMA di qualunque store. Un dialogo fuori scena può inviare caratteri letterali al workspace ma non modifica questa word lessicale.',0xA88C:'Primo store DE, inclusi i tag e il riferimento zero. Con offset0 torna subito adA894 e conserva proprio quel descrittore.',0xA89C:'Lo spazio può svuotare la parola precedente; il descrittore corrente è già stato conservato. Nessuna estrazione casuale viene inventata a questo punto.',0xA8B5:'Secondo store HL. Il nibble di contesto salvato in C viene ricombinato con l’offset: il valore non cambia per via della desinenza che verrà applicata dopo.',0xA903:'50 usa la radice,40 forza la desinenza,10 dipende dall’oggetto, altri contesti dall’attore. A022/A023 non sono modificati da questa decisione.',0xD424:'Qualificatore con contesto40 se il riferimento non è mascherato. La resa del possessivo non cambia il suo offset originale.',0xD442:'Sostantivo nonzero con contesto50. Ultimo writer naturale: tick964, attore0, STREET0861 emesso come5861; il giardiniere ne legge il byte61 a tick2852. Il runtime lo calcola dal record di locazione, non da questa traccia.'}
lines=['; Sherlock: ultimo riferimento lessicale. A022/A023 sono dati mutabili.'];count=total=0
for a,b,k,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {k.upper()}: {label}'];at=a
 while at<b:
  if at in notes:lines.append('; '+notes[at])
  if k=='code':op,n=disassemble(m,at);count+=1
  else:n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  assert at+n<=b,(hex(at),op)
  assert bytes(asm.assemble(op,at))==m[at:at+n],(hex(at),op)
  lines.append(f'    {op:<36} ; ${at:04X} {m[at:at+n].hex(" ")}');total+=n;at+=n
out=p/'sherlock-js/results/dictionary-reference';out.mkdir(exist_ok=True)
(out/'dictionary-reference.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=127)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
