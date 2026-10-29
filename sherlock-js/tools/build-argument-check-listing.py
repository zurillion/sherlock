"""Verified source dossier: argument constraints and the persistent A021 residue."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xA021,0xA022,'data','Residuo dei controlli: scritture selettive, non esito globale'),(0xC4D1,0xC583,'code','Azioni: enumerazione dei referenti e passaggio da verifica a esecuzione'),(0xC583,0xC628,'code','Regole interne: classi, letterali e ricerca degli argomenti mancanti'),(0xC628,0xC6BE,'code','Primo argomento: classi, maschere e scritture del residuo'),(0xC6BE,0xC74E,'code','Secondo argomento: rifiuti che conservano il vecchio residuo'),(0xC74E,0xC7A6,'code','Maschere: due test ordinati e distinzione fra verifica ed esecuzione'),(0xC7A6,0xC821,'code','Classi delle entità: percezione, trasporto, possesso e persona'),(0xC9BF,0xC9FB,'code','Regola selezionata: luce, primo argomento, secondo e predicato')]
notes={
0xA021:'Dato iniziale caricato =0. L’avvio sino al primo prompt non lo scrive nei quattro seed verificati. C655 scrive0; C6BA scrive1. Il successo, il tick, il nuovo comando e il reset del costo non lo azzerano. LOAD deve conservare il byte; un vecchio save senza campo rimane sconosciuto.',
0xC4E9:'La fase A00B=0 rende morbide alcune restrizioni: la ricerca dei nomi non equivale all’esecuzione. A021 non viene azzerato qui.',
0xC4FF:'Rifiuto anticipato di un letterale mancante: non attraversa C655 e conserva A021.',
0xC520:'Enumera gli ID in ordine crescente. Il modello tradotto deve visitare anche i candidati rifiutati che possono scrivere il residuo.',
0xC53C:'Imposta la fase esecutiva prima della validazione finale; non scrive A021.',
0xC59B:'Anche le regole interne hanno preflight separato. Non dedurre il residuo dal solo risultato finale della regola.',
0xC5B2:'Controllo FE prima della ricerca. Classi5/6 distinguono poi il tag del letterale nel byte basso.',
0xC5F6:'Con argomenti espliciti la fase diventa1 prima del controllo, anche se il predicato finirà per fallire.',
0xC628:'Il nibble basso del primo byte è la classe del primo argomento; classe0 accetta senza scrivere A021.',
0xC644:'Primo letterale: legge A02F/A030; classe5 richiede bit7 basso spento, classe6 acceso. Il fallimento passa C655.',
0xC655:'Scrive0 soltanto su questo percorso di rifiuto. Vi arrivano classi locazione/letterale non valide di entrambi i ruoli e rifiuti di classe entità del primo ruolo.',
0xC68F:'Il primo ruolo converte anche il fallimento di C7A6 in scrittura0. Questa istruzione è la differenza rispetto a C726.',
0xC691:'Le maschere esistono soltanto se bit4 dell’intestazione è acceso. Il predicato opzionale bit6 sposta di due byte i dati delle maschere.',
0xC6BA:'Scrive1 quando le maschere del primo o secondo ruolo falliscono in fase esecutiva. In preflight la restrizione morbida restituisce successo e non raggiunge questa scrittura.',
0xC6BE:'La classe del secondo ruolo viene dal nibble basso del secondo byte dell’intestazione.',
0xC6DB:'Il secondo letterale legge A031/A032, distinto dal primo. Nessuna intestazione attuale estratta usa questa classe nel secondo ruolo; l’ABI controllato verifica comunque il ramo.',
0xC726:'Rifiuto di classe entità del secondo ruolo: ritorna direttamente senza C655, conservando il precedente A021. Non uniformare i due ruoli.',
0xC74B:'Un fallimento delle maschere del secondo ruolo condivide C6B8/C6BA e quindi scrive1.',
0xC74E:'Due test ordinati su attributi record+05. Ogni modo seleziona: tutti presenti, almeno uno (maschera0 accettata), nessuno, non tutti. Una maschera0 con modo3 fallisce.',
0xC79A:'Con A00B=0 il rifiuto della maschera è morbido e non scrive A021. Con fase1 ritorna l’handler CB7B e il chiamante registra1.',
0xC7A6:'La classe effettiva è quella della regola, non la classe di ricerca nominale del modello del verbo.',
0xC7BB:'Classe9: percezione, una sola occorrenza, non persona e capacità sono controlli rigidi. La risalita a un proprietario persona usa invece la restrizione morbida C768/C79A.',
0xC7E4:'Classe10 richiede percezione e possesso. Classe11 richiede percezione e numero di occorrenze diverso da1.',
0xC80A:'Classe12 controlla soltanto il bit persona; classi13–15 richiedono anche percezione.',
0xC9C2:'Il rifiuto per buio precede i due argomenti e non modifica A021.',
0xC9D3:'Ordine: primo ruolo, secondo ruolo, eventuale predicato. Un fallimento precedente impedisce controlli e scritture dei successivi.',
0xC9F2:'Il successo di preflight ritorna senza eseguire il corpo. Nessun reset di A021 sul successo.'}
lines=['; Dossier offline: intestazioni dati e algoritmo funzionale, nessun runtime Z80.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=b-at;op='DEFB '+','.join(f'${v:02X}'for v in m[at:b])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results/argument-check';root.mkdir(exist_ok=True)
(root/'argument-check.asm').write_text('\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=123 if k=='data'else 94,**({'fields':[['A021','1 byte','Residuo persistente:0 per rifiuti selettivi;1 per maschere in esecuzione; altri percorsi lo conservano'],['Vecchi salvataggi','campo assente','Sconosciuto fino a una scrittura reale; nessun fallback di avvio']]}if k=='data'else{}))for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
