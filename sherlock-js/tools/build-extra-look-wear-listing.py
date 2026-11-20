"""Checked source excerpts for carried-name separators and shallow announcements."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5D80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xA2E4,0xA35D,'Annuncio normale del giocatore: chiamante di WEAR'),(0xA37D,0xA3E2,'Verbo in attesa e nome del primo argomento'),(0xB69D,0xB6AE,'Rifiuto di oggetto assente: argomenti vuoti e frammento6894'),(0xB6FD,0xB710,'Ricerca nella descrizione: ritorno anticipato se assente'),(0xC388,0xC3E4,'Glifo del verbo WEAR: F e A salvati in1E/1F')]
notes={0xA2E4:'WEAR del giocatore entra da CA76 con SP5D6C. Non confondere questo chiamante ordinario con la stampa pubblica A59F o le richieste NPC isolate.',0xA348:'A37D prepara verbo e argomenti nel normale annuncio. Il CR precedente alla frase contribuisce al contatore cumulativo.',0xA3A2:'Il descrittore089D lascia wear nel buffer. La parola viene scaricata quando inizia il nome dell’argomento, non direttamente da questa CALL.',0xA3DE:'A745/A751/D3E8 iniziano il nome del travestimento. Lo scarico di wear entra in C388 con frame5D2A; articolo e qualificatori successivi hanno frame5D2C, il sostantivo finale5D46.',0xB69D:'Il ramo senza corrispondenza prepara tre argomenti zero, distinti dal percorso che ha trovato una parola nella descrizione.',0xB6A7:'Il testo6894 costruisce I SEE NO ... THAT YOU CAN ... nel canale degli errori. Il contratto dei soli1E/1F non attribuisce tutti i residui della query.',0xB6FD:'Azzera il flag di esito prima di cercare nel testo della locazione. La prova dei rifiuti mantiene assente la descrizione e il giocatore alla radice.',0xB704:'D33C seleziona il record di descrizione da esaminare. Nei casi certificati il puntatore letto da IX+7/8 è zero.',0xB70F:'Il puntatore zero ritorna prima del decoder della descrizione. Non estendere la conservazione a una ricerca nel testo di una stanza.',0xC388:'La r finale di wear, tick2286, ha SP5D2A, descrittore5C0B e colonna7. Lo shift è3.',0xC39D:'AF dell’ottava scansione precede il disegno. Con frame5D2A il byte F occupa1E e il byte A occupa1F; F e A hanno provenienze indipendenti.',0xC3B3:'Il percorso con shift non nullo ripristina il conteggio prima del secondo PUSH AF. Non si conserva il byte ruotato usato per disegnare.',0xC3B8:'Ultimo writer di1E/1F nel percorso osservato: F=0 dalla scansione, A=0 dall’ottava riga del font r. La cuoca legge1E al2484 e1F al2608. Con q il font residuo può essere diverso da zero.',0xC3D2:'Otto scansioni per glifo: la proprietà deriva dall’ultima iterazione. L’ABI riutilizzata varia carattere, shift e conteggio del chiamante.'}
lines=['; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(memory,at);assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;count+=1;total+=n
out=root/'results/extra-look-wear-scan';out.mkdir(exist_ok=True)
(out/'wear-scan.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=98)for a,b,label in regions]),indent=2)+'\n')
print(count,total)
