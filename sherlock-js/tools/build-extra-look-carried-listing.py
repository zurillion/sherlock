"""Checked source excerpts for carried-name separators and shallow announcements."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5D80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xA9DF,0xAA10,'Scarico della parola e separatore del nome'),(0xC388,0xC3E4,'Glifo: shift e contatore salvati dallo spazio del nome portato'),(0xCA76,0xCA7F,'Annuncio ordinario: soppressione e chiamata al formatter'),(0xCAAF,0xCB12,'Arrivo e porta condivisa: soggetto anonimo temporaneo'),(0xCBC2,0xCC0B,'Notifica di arrivo nel contesto dell’osservatore')]
notes={0xCAAF:'DC6C esclude le tre identità giocabili 0/1/100: queste notifiche riguardano gli altri attori.',0xCAB3:'C491 conserva la locazione precedente: se l’attore era già nella stanza di Holmes, l’annuncio ordinario è già stato gestito.',0xCABE:'D495 restituisce la sola locazione diretta del record, oppure FF se la lista non è singola. Non scambiare questa chiamata con un percorso nel grafo.',0xCACD:'Solo il nuovo valore uguale alla stanza A009 dell’osservatore invoca CBC2 con il frammento68ED.',0xCAD0:'La classe di ricerca del primo argomento A00F deve essere almeno7 per proseguire verso la notifica dell’oggetto. Le classi inferiori ritornano.',0xCAD9:'D495 carica IX del primo argomento. FF qui distingue il record con lista di locazioni non singola; CAE0 ne leggerà il conteggio.',0xCAE0:'B è il numero di locazioni dell’oggetto. Il ciclo visita IX+0F e avanza IX fino a trovare la stanza di Holmes.',0xCAEF:'Nessuna locazione uguale a quella dell’osservatore: ritorno senza annuncio anonimo.',0xA9DF:'La parola viene scaricata nel contesto del suo chiamante: non ricavare la profondità dal solo testo visibile.',0xA9F5:'B contiene i caratteri rimanenti della parola. Il B della scansione in C39C è un altro conteggio.',0xC388:'LOOK a Portman Street: lo spazio fra daily e chronicle entra con SP5D26, colonna18, descrittore51AB. Ultimo oggetto portato da Watson, nel formatter D3D5.',0xC39C:'Salva BC dell’ottava scansione: C=(2+7*colonna)&7 a5D1C e B=1 a5D1D. A colonna18 C=0: questo PUSH resta l’ultimo writer.',0xC39D:'Il font e F sono distinti dai due byte BC. Il contratto del separatore non attribuisce automaticamente AF a1A–1B.',0xC3B7:'Con shift diverso da zero ripete il salvataggio BC. Nessun valore fisso prelevato dalla traccia nel motore.',0xCA76:'I chiamanti reali osservati hanno frame diversi: anonimo5D6A, chiusura visibile5D6C, spostamento5D68. Non uniformare i loro residui.',0xCAF0:'Il soggetto invisibile viene temporaneamente sostituito da FF; CB01 richiede comunque l’adiacenza corretta.',0xCB06:'L’annuncio anonimo di apertura ha glifi non più profondi di5D2A; sul caso osservato il minimo è5D1E. I byte1A–1D non sono toccati.',0xCBC2:'L’ingresso reale di Tricia ha SP5D6A e primo qualificatore a5D2C. Un wrap su riga parziale può invece raggiungere1A–1D.',0xCC07:'Stampa il frammento di arrivo dopo aver ristabilito il contesto. Non dedurre la profondità di ogni glifo da quella del prefisso.'}
lines=['; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(memory,at);assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;count+=1;total+=n
out=root/'results/extra-look-carried-scan';out.mkdir(exist_ok=True)
(out/'carried-separator.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=98)for a,b,label in regions]),indent=2)+'\n')
print(count,total)
