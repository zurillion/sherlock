# A01D/A01E: flag persistenti del modello lessicale

Il gioco conserva due byte derivati dall’ultimo modello lessicale raggiunto.
Non sono il verbo corrente, un esito booleano né uno stato dell’NPC.
Il modello è un record di otto byte nella tabella $8259–$840A (54 azioni).
A2B1 seleziona `8259 + 8*(azione-1)`; A2BD combina i nibble alti:

```
A01D = (record[1] >> 4) | (record[3] & 0xF0)
A01E = (record[5] >> 4) | (record[7] & 0xF0)
```

I nibble bassi appartengono ai riferimenti lessicali e non entrano nei flag.
A2CD scrive A01E, A2E0 scrive A01D. Il runtime autonomo conserva il risultato
semantico del decoder: non esegue queste istruzioni e non legge i fixture.

## Chi aggiorna i byte

Sono stati osservati tutti e quattro i chiamanti del decoder, anche con
scritture dello stesso valore:

| CALL | Ritorno | Percorso |
| --- | --- | --- |
| B416 | B419 | Modello riconosciuto e ordine dei complementi nel resolver |
| C4DF | C4E2 | Preflight delle azioni normali, anche degli NPC |
| A323 | A326 | Annuncio dell’azione |
| A38B | A38E | Composizione dell’ordine come testo |

Le regole interne da128 saltano il normale lookup. Le classi della regola
DOMAIN possono cambiare A00F/A010 senza riscrivere A01D/E. La composizione
di un ordine può invece lasciare i flag dell’azione citata, diversi dal SAY
esterno. Non ripristinare automaticamente il modello precedente al ritorno.
Anche le notifiche dei movimenti interni (CA76) e dei pagamenti (E34B)
attraversano il lookup dell’annuncio. Questo avviene anche fuori scena:
A30C/A310 con modo1 proseguono verso A31A. Non condizionare gli store alla
visibilità del messaggio. Il confronto continuo ha individuato questi
percorsi a Mon10:32 (movimento Lestrade) e Mon16:58 (pagamento cabbie).

Errori lessicali senza riconoscimento, parsing di prova e passare del tempo
non sono writer. Non dedurre i byte dall’ultimo input del giocatore.

Bit3/bit2 di A01D indicano la presenza dei due argomenti; bit7/bit6 scelgono
la classe locazione. I gruppi0C/03 di A01E distinguono il letterale dalla
normale ricerca di entità. Bit5 partecipa all’ordine fisico dei complementi;
B445 modifica A nel registro, non A01D. Bit4 di A01D sopprime l’annuncio
normale, dopo il decoder; il bit4 di A01E è la selezione singola già studiata.
Bit1 di A01D consente la ricerca del secondo argomento non specificato.

## Avvio, salvataggi e prove

I byte iniziali del payload sono0/0. Quattro avvii nativi completi, con
seed0,1,17,255, osservano tutti i writer sino al primo prompt; il valore
finale0/0 deriva dall’effettiva sequenza di avvio e non da un reset per tick.
L’esportatore conserva i flag nei dati dei modelli e l’inizializzazione
separata. SAVE/LOAD conserva la coppia corrente. Un vecchio salvataggio che
non la contiene resta sconosciuto fino a un writer ricostruito; nessun
fallback al dato di boot. Il parser di analisi non modifica lo stato.

Prove controllate:310 chiamate originali (tutti54 modelli e256 record dati
sintetici con nibble bassi non nulli), decoder e classi C493/C4B2. Non sono
partite naturali. Prove naturali brevi:11 sequenze,43 input,53 checkpoint,
273 scritture native,197 draw/394 read. Tutti24 posti attore attivi,
arena752 byte, entità, fatti, bitmap e futuro dopo LOAD confrontati. I valori
della coppia sono confrontati anche a ogni estrazione, non solo al prompt.
I conteggi273 descrivono gli store osservati nella CPU originale: il modello
JavaScript non pretende di riprodurre il conteggio delle istruzioni.

La traccia naturale continua contiene2821 checkpoint fino a Wed09:10 e
30265 store A2E0, inclusi quelli invariati. La lettura effettiva A01D avviene
alle Wed09:04 (tick2945), dalla cuoca9: valore8. L’ultimo writer è A2E0,
ritorno C4E2, stesso tick2945, attore5 Daphne, modello8371=CLOSE, coppia8/64.
Il valore deriva dal modello di quell’azione, non è un default8 installato.
Il confronto continuo è in `results/model-flags/natural-verification.json`.

Il prefisso completo esteso conta374 checkpoint0–373 sino a Wed10:00,
7223 draw/15464 read confrontati. Il prossimo confine è5D1E nel checkpoint374
verso Wed10:10. Il prefisso lungo e il prossimo limite sono nel rapporto
`results/model-flags/witness-prefix.json`. Non sono certificati tutti i finali:
restano6A33,6ABD,6AF3,6B79,75D2 e il limite separato del cab5D0C.
Il vecchio test5D23 ora richiede la prosecuzione sino al termine del proprio
probe (Wed10:00), senza accettare il precedente blocco A01D.

## Atlante e riproducibilità

Nuove zone documentate: **A01D–A01E** (due byte prima parziali),
**A2B1–A2E3** (51 byte prima grigi). Approfondimenti: A31A–A35C,
A37D–A418, B1DD–B212, B405–B467, C493–C4D0, C4D1–C559, CA76–CA7E, E345–E34E.
Il dossier riassembla328 istruzioni e701 byte. Copertura statica e certificato
di gameplay sono metriche distinte.

```
python3 tools/probe-model-flags-abi.py
python3 tools/probe-model-flags-boot.py
python3 tools/probe-model-flags.py
python3 tools/probe-model-flags-natural.py
python3 tools/build-model-flags-listing.py
python3 tools/build-memory-map.py
node --test test/model-flags.test.mjs test/glyph-address-high.test.mjs test/memory-map.test.mjs
node tools/verify-model-flags-natural.mjs
node tools/verify-witness-prefix.mjs
```

I probe sono strumenti offline e richiedono il progetto completo.
