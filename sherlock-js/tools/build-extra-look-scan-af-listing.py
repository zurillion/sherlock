"""Checked source excerpts for carried-name separators and shallow announcements."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5D80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xA3A2,0xA3E2,'Verbo in attesa e nome del primo argomento'),(0xA9DF,0xAA10,'Scarico della parola nel contesto del separatore'),(0xB6FD,0xB710,'Ritorno senza ricerca se manca la descrizione'),(0xC388,0xC3E4,'AF dello spazio LOOK e del qualificatore WEAR'),(0xD3D5,0xD448,'Nome di entità: articolo, qualificatori e sostantivo')]
notes={0xA3A2:'Il verbo viene prima accumulato. Nell’annuncio WEAR il successivo nome dell’argomento ne provoca lo scarico nel frame5D2A.',0xA3DE:'Il nome del primo argomento usa il formatter A745/A751/D3E8. Per WEAR i qualificatori si scaricano a frame5D2C, distinto dal verbo e dal sostantivo finale.',0xA9DF:'Il carattere che delimita una parola seleziona la profondità dello scarico. Lo spazio dopo daily, nell’ultimo oggetto portato del LOOK, entra in C388 con SP5D26.',0xA9FC:'B del chiamante conta i caratteri residui della parola: non è B interno, che C388 reinizializza per le otto scansioni.',0xB6FD:'La conservazione1A–25 dei rifiuti è verificata per un solo gruppo assente,0..2qualificatori,contesto ordinario del giocatore e stanza senza testo. Non estenderla a richieste o ricerche nella prosa.',0xB70F:'Con puntatore di descrizione zero ritorna prima del decoder. I168comandi controllati non scrivono20 e conservano tutti i marker1A–25,non solo1E/1F.',0xC388:'Due produttori distinti nello stesso metodo: spazio del LOOK a frame5D26 e qualificatore di WEAR a frame5D2C. Non dedurre uno dei byte dall’altro.',0xC39C:'Il BC di scansione conserva shift e conteggio; non contiene AF. È già proiettato separatamente per il separatore daily/chronicle.',0xC39D:'Ultimo PUSH AF se shift zero. Spazio dopo daily,colonna18,shift0,tick1770: F in5D1A,A in5D1B. Il giardiniere legge1A al2730.',0xC3B8:'Con shift non nullo ripete AF prima della rotazione per disegnare. Ultima s di mans in WEAR,colonna22,shift4,frame5D2C,tick2286: F in20,A in21. Il giardiniere legge20 nello stesso draw di1A al2730.',0xC3D2:'Il residuo appartiene all’ottava scansione. A viene dalla riga del font; F dal percorso dello shift. Nessun valore catturato del corpus entra nel renderer JS.',0xD3E8:'Il nome ha un proprio contesto di stack. I qualificatori usano context4, il sostantivo context5. La parte numerica del denaro segue un altro percorso e non riceve il nuovo contratto AF del separatore.',0xD424:'Primo qualificatore: il nome WEAR ordinario e l’ultimo nome portato nel LOOK hanno frame diversi. Il matching del nome grezzo impedisce di attribuire il contratto a nomi non ricostruiti.',0xD435:'Secondo qualificatore. La s finale di mans diventa l’ultimo glifo che raggiunge20/21 nella storia osservata.',0xD442:'Il sostantivo finale torna a un frame meno profondo. Nel WEAR verificato disguise si scarica a5D46 e non raggiunge20/21.'}
lines=['; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(memory,at);assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;count+=1;total+=n
out=root/'results/extra-look-scan-af';out.mkdir(exist_ok=True)
(out/'look-wear-af.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=98)for a,b,label in regions]),indent=2)+'\n')
print(count,total)
