"""Commented offline evidence for live renderer, rule and lookup fields."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xA011,0xA012,'data','Flag della grafica nativa del protocollo sorgente'),(0xA013,0xA017,'data','Puntatori temporanei ai due argomenti delle regole'),(0xA887,0xA89F,'code','Dizionario: fuori scena non scrive neanche lo spazio nel buffer'),(0xA9B7,0xAA14,'code','Buffer di parola: scritture letterali persistenti anche fuori scena'),(0xBA13,0xBA1C,'data','Affermazioni: due cursori, verbo lessicale e tripla parziale'),(0xBD7E,0xBE5A,'code','Risoluzione globale delle affermazioni e verifica di unicità'),(0xC388,0xC3E4,'code','Glifi: otto scansioni, shift, indirizzo video e residui dei chiamanti'),(0xC8EF,0xC929,'code','Argomenti: indice locazioni o entità; FE/FF conservano il puntatore'),(0xD04F,0xD05A,'code','Enumeratore entità: cursore iniziale tre byte prima della tabella'),(0xD9C5,0xDA32,'code','Lexer: salta numeri e punteggiatura; conserva il confronto lessicale'),(0xDA34,0xDAAD,'code','Lookup: lunghezza della parola e miglior prefisso, anche in parità'),(0xDC13,0xDC15,'data','Lookup: lunghezza e miglior prefisso dell’ultima parola cercata')]
notes={0xA011:'Scelta grafica dell’originale. Il profilo verificato disabilita il disegno bitmap dopo il boot; preferenze SVG/pixel del browser separate.',0xA013:'Word primo argomento, word secondo. C908/C924 aggiornano solo ID <FE: i letterali e FF lasciano il valore precedente.',0xBA13:'BA13/BA15: cursori nella tabella 8B6F, non puntatori ai record entità. BA17: offset del verbo; BA19–BA1B: soggetto, indice predicato, oggetto. Le scritture sono parziali.',0xDC13:'DC13 lunghezza, DC14 miglior prefisso. Numeri e punteggiatura non reinizializzano questi byte.',0xA88B:'Fuori scena ritorna prima dello spazio e della parola di dizionario; i letterali attraversano invece A9B7.',0xA9D7:'Scrive nel buffer riutilizzato. La testimonianza fuori scena di Straker lascia una l a 5C15, letta molte ore dopo dal generatore.',0xBDC5:'Entrambi i cursori partono da 8B6C (8B6F meno 3), prima della prima scansione D36A.',0xBDF3:'Primo match del soggetto; il tentativo seguente verifica che non ve ne sia un secondo.',0xBE46:'Conserva il cursore del soggetto anche in caso di fine o ambiguità: terminatore 8CB9 oppure secondo match.',0xBE55:'Come BE46 per l’oggetto. Se il soggetto era ambiguo, il cursore oggetto resta iniziale.',0xC38B:'PUSH HL salva l’indirizzo video. Con frame 5D1A la word finisce a 5D12: alto 5D13, derivato da colonna e riga.',0xC39C:'Ogni scansione salva BC: l’ultima lascia B=1; C conserva lo shift del carattere.',0xC3D2:'Otto passaggi. Il frame mantiene i residui dell’ultima scansione anche dopo il ritorno.',0xC8F4:'FE/FF saltano il primo aggiornamento senza azzerare A013.',0xC8F9:'Classe <5: record locazione tramite D224. Classe >=5: record entità tramite D237.',0xC908:'Scrittura effettiva della word primo argomento; precede i controlli e il predicato della regola.',0xC911:'FE/FF nel secondo slot conservano A015.',0xC924:'Scrittura effettiva della word secondo argomento.',0xD9D7:'Numeri e punteggiatura riconosciuti ritornano senza riscrivere DC13/DC14.',0xD9E1:'Azzera il miglior prefisso soltanto quando inizia una ricerca alfabetica valida.',0xDA62:'B parte da 1: l’iniziale è già consumata, quindi la lunghezza finale include correttamente quella lettera.',0xDA77:'Salva la lunghezza della parola corrente, non quella della voce canonica o del sinonimo.',0xDAAA:'Salva il miglior prefisso; un pareggio può cambiare la voce selezionata.'}
lines=['; Analisi offline: dati e codice sono distinti; nessuna esecuzione CPU nel motore JS.'];total=count=0
for a,b,kind,label in sorted(regions):
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));total+=n;at+=n
root=p/'sherlock-js/results/transient-inputs';root.mkdir(exist_ok=True)
(root/'transient-inputs.asm').write_text('\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=120 if k=='data'else 85,**({'fields':{'A011':[['A011','1','Flag mutabile: nel profilo storico verificato viene impostato a zero dopo il boot']], 'A013':[['A013','2','Puntatore primo argomento'],['A015','2','Puntatore secondo argomento'],['Regola','C8EF','ID <FE e classe <5: locazione; classe >=5: entità; FE/FF non riscrivono']], 'BA13':[['BA13/BA15','2 + 2','Cursori nella tabella degli ID entità'],['BA17','2','Offset lessicale del predicato'],['BA19–BA1B','3','Tripla parziale soggetto/predicato/oggetto']], 'DC13':[['DC13','1','Lunghezza della parola inserita'],['DC14','1','Miglior prefisso trovato, aggiornato anche in parità']]}[f'{a:04X}']}if k=='data'else{}))for a,b,k,l in regions]),indent=2)+'\n');print(count,total)

# This ROM evidence does not become a coloured ROM region in the atlas.
rom=(p/'skoolkit-10.1/skoolkit/resources/48.rom').read_bytes();lines=['; ROM: copia di dati di inizializzazione; nessuna esecuzione nel motore JS.'];count=0
for a,b,kind,note in [(0x127C,0x1287,'code','Copia 14 byte da 15C6 a 5C10 prima del gioco'),(0x15C6,0x15D4,'data','Mappa iniziale degli stream, successivamente riutilizzata dal buffer di parola')]:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {note}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in rom[at:at+n])
  else:op,n=disassemble(rom,at);count+=1
  assert at+n<=b;assert bytes(asm.assemble(op,at))==rom[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {rom[at:at+n].hex(" ")}');at+=n
(root/'rom-streams.asm').write_text('\n'.join(lines)+'\n')
(root/'rom-streams-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=25,rom_not_part_of_map=True,source='ROM 127C–1285 / 15C6–15D3',initial_streams=list(rom[0x15C6:0x15D4])),indent=2)+'\n')
