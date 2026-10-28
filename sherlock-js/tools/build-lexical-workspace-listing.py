"""Source evidence for the lexical/output workspace and its cold-start owner."""
import sys,json,hashlib
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
payload=(p/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload;asm=Assembler();root=p/'sherlock-js/results/lexical-workspace';root.mkdir(exist_ok=True)
regions=[(0xA94D,0xA9B5,'code','Decompressione del candidato: workspace separato a 5C42'),(0xD9C5,0xDA32,'code','Lookup alfabetico: copie lessicali prima del parsing, anche in preflight'),(0xDA34,0xDA7D,'code','Copia del corpo della parola in minuscolo nel buffer di stampa 5C0B')]
notes={0xA95C:'La decompressione dei candidati parte da 5C42, 55 byte dopo 5C0B: non sovrascrive la coda degli stream 5C1E–5C35. Oltre questa soglia le due copie possono sovrapporsi.',0xA96E:'Il prefisso compresso conserva i byte precedenti del candidato: non è una cancellazione dell’intero buffer.',0xA986:'Termina il candidato con zero. I byte successivi conservano il precedente contenuto.',0xD9D9:'Il preflight e la tokenizzazione eseguono entrambi DA34. Un errore può conservare la copia della parola fallita senza giungere al parser.',0xD9F5:'Ogni candidato, compresi i record D0 scartati subito dopo, viene decompresso nel workspace alto.',0xDA34:'Consuma la prima lettera per selezionare il gruppo; questa lettera NON viene copiata a 5C0B.',0xDA5A:'Un gruppo nullo ritorna prima di copiare il corpo. Non inventare scritture per gruppi assenti.',0xDA5F:'Buffer condiviso con A9B7; questa copia diretta non modifica il puntatore di stampa A9B5.',0xDA62:'Lunghezza iniziale uno: include la prima lettera consumata.',0xDA67:'La copia si ferma al primo byte inferiore a 40, non soltanto a uno spazio.',0xDA6B:'OR 20 produce i byte minuscoli; non è una normalizzazione del testo visualizzato.',0xDA6D:'Scrive il corpo consecutivamente da 5C0B. Parole lunghe possono sovrascrivere le vecchie celle degli stream ROM.',0xDA75:'Il terminatore è scritto, non cancella il resto del buffer; parole successive corte lasciano la vecchia coda.',0xDA77:'La lunghezza comprende la prima lettera e corrisponde al numero di byte scritti (corpo più zero).'}
def listing(memory,regions,header,notes):
 lines=[header];count=total=0
 for a,b,kind,label in regions:
  lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
  while at<b:
   op,n=disassemble(memory,at);assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==memory[at:at+n]
   lines.append(f'    {op:<37} ; ${at:04X} {memory[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));count+=1;total+=n;at+=n
 return '\n'.join(lines)+'\n',count,total
text,count,total=listing(m,regions,'; Analisi offline del payload: nessun opcode eseguito dal motore JavaScript.',notes)
(root/'lexical-workspace.asm').write_text(text)
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=87,fields=[['5C0B–5C41','55 byte','Corpo lessicale e buffer di stampa condivisi; prima lettera omessa, zero finale, coda conservata'],['5C1E–5C35','24 byte','Coda degli stream: zero solo al cold start, poi scritture effettive'],['5C42','workspace candidato','Decompressione incrementale del dizionario; sovrapposizione oltre i primi 55 byte non certificata']])for a,b,k,l in regions]),indent=2)+'\n')
rom=(p/'skoolkit-10.1/skoolkit/resources/48.rom').read_bytes()
rom_regions=[(0,8,'code','Reset freddo: A=0, DE=FFFF'),(0x11CB,0x11F0,'code','RAM test: riempimento con 2 e doppio decremento a zero'),(0x127C,0x1287,'code','Copia solo 14 byte della mappa stream; conserva la coda zero')]
text,rc,rb=listing(rom,rom_regions,'; ROM fuori dall’atlante del payload; provenienza dell’inizializzazione, non dati catturati.',{0x0001:'Cold start: XOR A. Il riavvio caldo ha un percorso differente e non è il profilo certificato.',0x11DC:'Riempie la RAM da FFFF a 4000 con due.',0x11E9:'Primo decremento: 2 diventa 1 nella RAM funzionante.',0x11EC:'Secondo decremento: 1 diventa 0, poi procede alla cella successiva.',0x1282:'Copia di 14 byte: 5C10–5C1D. Nessun OPEN # nel loader BASIC prima di USR, quindi 5C1E–5C35 restano zero.'})
(root/'rom-clear.asm').write_text(text)
(root/'rom-clear-verification.json').write_text(json.dumps(dict(instructions=rc,bytes_roundtripped=rb,roundtrip_equal=True,rom_not_part_of_map=True,firmware_sha256=hashlib.sha256(rom).hexdigest(),cold_start_only=True,derived_zero_range=['5C1E','5C36']),indent=2)+'\n')
print(count,total,rc,rb)
