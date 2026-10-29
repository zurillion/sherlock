# Il byte di scansione del glifo a 5D1B

## Ultimo scrittore naturale

La lettura che interrompeva il modello è del giardiniere, attore 8, a
**mercoledì 05:27**, tick 2728. Il byte originale vale zero, ma lo zero non è
stato installato come risposta. Il probe segue i PUSH, CALL ed EX(SP),HL,
comprese le scritture che ripetono il valore precedente. Non rimangono
transizioni di valore non classificate nel tratto osservato.

L’ultimo store pertinente è **C3B8, tick 962, attore 2 (Lestrade)**. È la
pulizia della riga provocata dal prefisso qualificato di hansom cab mentre
Lestrade sale sul veicolo. C388 entra con frame 5D26 e carattere spazio 32.
Il suo salvataggio AF dell’ultima scansione lascia F a 5D1A e A a 5D1B.
Il probe registra proprio la lettura successiva insieme a quell’ultimo writer.

La profondità deriva dalla catena già verificata dell’annuncio ordinario:
A3DE → A745/A751 → D3E8 per il nome del primo argomento. Il prefisso si
scarica con frame 5D2C; se la parola non entra, A9F1 richiede CR e la pulizia
C374 raggiunge il glifo con frame 5D26. Non è il frame di qualsiasi stampa.

## Formula, non sequenza registrata

C39D salva AF prima dell’allineamento della riga del font. Quando serve
lo shift, POP AF ripristina il byte originale e C3B8 lo salva di nuovo.
Dopo otto scansioni, A è **glyph[7]**, la riga inferiore non allineata.
Per lo spazio è zero; per q, con questo font, è 6. Non è il flag F del byte
vicino e non dipende soltanto dallo shift.

La stessa cella fisica ha un altro ruolo con altre profondità: con frame 5D24,
5D1B conserva B=1 dell’ultima scansione. Le prove distinguono quel caso dal
frame 5D26. Non si può estendere indiscriminatamente l’interpretazione font.

Il modello calcolava già le righe del font: ora ne pubblica anche il residuo
5D1B nel contratto del chiamante verificato. La proprietà della coppia AF
è conservata dagli ordini GO TO del prefisso già ricostruito quando non la
raggiungono. Se un chiamante non è proiettato, oppure interviene un errore,
la proprietà viene revocata. Nessun nuovo valore è introdotto in 5D1C–5D1E.
Il salvataggio conserva i campi posseduti; un LOAD privo di 5D1B lo lascia
sconosciuto fino a una scrittura realmente ricostruita.

## Prove e avanzamento

- 432 chiamate ABI originali controllate, già disponibili: quattro frame,
 tre caratteri e tutte le 36 colonne. 216 verificano esplicitamente 5D1B
 nei due frame che lo raggiungono; sono presenti righe del font nonzero.
- 76 comandi naturali dall’avvio fino a mercoledì 05:30, compreso l’ultimo
 WAIT ancora live. A ogni checkpoint tutti i valori pubblicati dal modello
 coincidono col nativo; la lettura del giardiniere coincide per valore,
 tick e attore. Il probe mantiene gli ultimi 15 store di ogni tratto, non
 pretende di salvare un dump illimitato di ogni istruzione.
- Proprietà distinta dai flag, preservazione controllata, revoca per output
 sconosciuto ed errori, salvataggio e vecchi LOAD senza fallback.

I fixture sono prove offline e non vengono caricati dal gioco. Protocollo
naturale: seed 1, tutti i 24 posti attore, LOOK iniziale gratuito, grafica
originale spenta dopo il boot, input maiuscolo e MORE immediato.
Suite completa: **800 test passati**. Rapporto: `results/glyph-byte/checks.json`.

Il confronto completo ora verifica 349 checkpoint, 0–348, fino a
**mercoledì 05:50**: ogni sorteggio/lettura, arena completa, entità, fatti,
attori, bitmap e futuro dopo LOAD, compresi i minuti live. Sono tre
checkpoint e 30 minuti oltre il prefisso precedente.
Rapporto: `results/glyph-byte-verification.json`; ripetere con
`node tools/verify-witness-prefix.mjs`.

Il prossimo ingresso sconosciuto è **A01B**, al checkpoint 349 diretto a
mercoledì 06:00. Va ricostruito il suo ciclo di vita nel parser, senza
dedurlo automaticamente dal chiarimento JavaScript o dal comando WAIT.
Restano cinque varianti terminali senza certificato naturale: questo
passo non dichiara equivalenza dell’intero finale.

## Atlante sincronizzato

| Intervallo inclusivo | Approfondimento |
| --- | --- |
| A3D6–A3E1 | Chiamante del nome del primo argomento |
| A9DF–AA0F | Scarico della parola e CR prima della stampa |
| C363–C37C | Pulizia della riga con glifi spazio |
| C388–C3E3 | Salvataggi delle scansioni e ruolo di A distinto da F |

Il dossier riassembla 119 istruzioni/179 byte, tutti già classificati:
sono **approfondimenti**, senza nuovi byte grigi promossi a documentati.
Anche la zona dinamica dello stack espone la proprietà condizionata di
5D1A/5D1B, senza attribuirle un contenuto iniziale come stato della partita.
Restano 2.853 byte sconosciuti e 473 parziali nel payload.
