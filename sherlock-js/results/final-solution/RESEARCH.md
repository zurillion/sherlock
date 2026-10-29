# Continuazione ancora in ricerca

`major-witness.txt` formula le due ipotesi prima della visita e poi osserva
la confessione nella fumeria. Non imposta flag interni. Il riferimento nativo
contiene 521 checkpoint e termina in 6A33 giovedì 10:00; è compresso in
`witness-native-reference.json.gz` e non viene caricato dal gioco.

Aggiornamento 28 ottobre, seconda ripresa: corrette le dipendenze del renderer
fino a 5D19, i puntatori di C8EF e gli enumeratori delle affermazioni,
lunghezza/prefisso lessicale, scritture letterali TELL fuori scena e copia
ROM della mappa degli stream. A011 è esplicito per il profilo grafica off.

Il prefisso JS passa su 247 checkpoint, fino a martedì 13:10, con tutti gli
attori, ogni draw/read, arena, entità, fatti, bitmap e futuro dopo LOAD.
Rapporto: `results/transient-inputs-verification.json`.
Ripetere con `node tools/verify-witness-prefix.mjs`.

Il confronto completo `node --test tools/compare-witness-research.mjs` rimane
separato e si ferma al checkpoint 247, diretto a martedì 13:20: contatore
A012 non ancora proiettato (il nativo legge 1 nel turno del giardiniere).
Ricostruire le scritture del parser, senza trasformare 1 in un fallback.
I vecchi limiti 97B5, A00B, 5D13, A013, BA13, DC13, 5D16, 5C17 e A011 sono
risolti; il vecchio 5D12 apparteneva a una storia già divergente.

Vedere `INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md` e `RIPRESA-GAMEPLAY.md`.
Nessuna traccia raccolta dai probe diventa un asset di comportamento del gioco.

## Terza ripresa: limite corrente

Il rapporto corrente è `results/parser-counter-verification.json`: 323
checkpoint (0–322) fino a mercoledì 01:30. Ricostruiti A012, A019, D714
e BA1C–BA1F dal sorgente. Il confronto completo si ferma al checkpoint
323 verso mercoledì 01:40, lettura non posseduta 5C1F. Ricostruire la
coda ROM degli stream insieme alle scritture lessicali DA34–DA77 prima
di esporre questi byte. Il finale 6A33 resta non certificato; il rapporto
precedente rimane come prova storica del suo prefisso più corto.

## Quarta ripresa: workspace lessicale

`results/lexical-workspace-verification.json` riconferma i checkpoint
0–322 fino a mercoledì 01:30. Ricostruiti il cold-start degli stream
5C1E–5C35 e le copie lessicali DA34–DA77. Il confronto completo supera
5C1F e si ferma sulla successiva lettura 5D1F nello stesso checkpoint 323.
Nessuna estensione di orario o nuovo finale è certificata. Il probe
naturale da tick 2400 conferma le letture ma non l’ultimo scrittore
precedente: indagare i frame di glifi C39D e decoder A969/A97C.
Vedere `LEXER-E-BUFFER-CONDIVISO.md`; mappa aggiornata nello stesso cambio.

## Quinta ripresa: nome dell’attore negli ordini NPC

Il rapporto corrente è `results/upper-stack-verification.json`: 334
checkpoint 0–333 fino a mercoledì 03:20. Il byte 5D1F deriva dal glifo
del prefisso proprio negli ordini CE13/682A; il tracciato a tick964
mostra la catena reale e C388 frame5D2A. Il confronto completo si ferma
al checkpoint 334 verso 03:30, lettura non posseduta 5D1A. Non pubblicare
le celle intermedie usando soltanto una generica estensione del renderer.
Vedere `NOMI-ORDINI-E-STACK.md`; mappa aggiornata. Nessun nuovo finale
completo è certificato.

## Sesta ripresa: flag del glifo e primo argomento

Rapporto corrente: `results/glyph-flags-verification.json`, 338 checkpoint
(0–337) fino a mercoledì 04:00. Il flag 5D1A proviene dal glifo di pulizia
durante il word wrap dell’annuncio del primo argomento; 5D20/5D21 dal
prefisso del nome negli ordini. Il confronto completo si ferma sullo stato
ALL/BUT A01A al checkpoint 338 verso 04:10. Non sostituirlo con zero o
con lo stato del solo ultimo nodo AST. Vedere `FLAG-GLIFI-E-ANNUNCI.md`.
Mappa aggiornata; il finale 6A33 completo resta non certificato.

## Settima ripresa: ALL/BUT

Rapporto corrente: `results/parser-all-verification.json`. Il modello
supera A01A grazie alle transizioni reali del parser e incontra A020 nello
stesso checkpoint 338 verso mercoledì 04:10. Il prefisso certificato resta
0–337 fino alle 04:00. Ricostruire il costo temporaneo globale A01F/A020,
non usare il costo logico corrente o uno zero osservato come fallback.
Vedere `ALL-BUT-E-CICLO-PARSER.md`, che documenta anche le correzioni dei
record, del conteggio dei fallimenti e le nuove annotazioni della mappa.
Il finale 6A33 completo resta non certificato.


Aggiornamento 29 ottobre 2026: leggere COSTO-TEMPORANEO-E-ATTESE.md e
results/temporary-cost-verification.json. Il costo globale A01F/A020 è
proiettato da reset CC74, intestazioni CA09 prima del corpo, cab 9B07,
controlli B0BD/B0CC, yield CD85/CD8E, byte basso DDC5 e WAIT UNTIL DE42.
Le intestazioni di azioni/oggetti sono dati immutabili estratti; vecchi
salvataggi senza proprietà temporanea non ricevono fallback. Sei sequenze
naturali,32 input/97 checkpoint,302 draw/614 read confrontano anche il costo
a ogni estrazione, tutti gli attori, arena, bitmap e futuro dopo LOAD.
GET OUT dal cab in corsa deve fallire con maschere 80/28, mantenendo gli
argomenti già risolti e il punto finale del messaggio. Suite 775.
Prefisso witness invariato 0–337 fino a Wed04:00; A020 è superato e il
prossimo limite è A11A allo stesso checkpoint 338 verso 04:10. Nessun nuovo
finale certificato. Atlante:153 istruzioni/351 byte, 58 byte prima sconosciuti
ora documentati e 2 byte prima parziali; gli altri sono approfondimenti.


Aggiornamento 29 ottobre 2026, allocatore: leggere ALLOCATORE-E-LINK-PRECEDENTE.md
e results/allocation-link-verification.json. Prefisso witness 0–345 (346 checkpoint)
fino a Wed05:20, tutti gli attori, ogni draw/read, arena, bitmap e futuro dopo LOAD.
Nuovo confine 5D1B al checkpoint 346 verso 05:30: ricostruire il chiamante/ultimo
scrittore dello stack, incluse scritture dello stesso valore; non copiarlo da
una registrazione né dedurlo da 5D1A. Cinque finali ancora senza certificato naturale.
RecordArena.allocationLink conserva A11A/A11B: l’INDIRIZZO DEL LINK PRECEDENTE
al candidato scelto, 9FE3 per la testa o blocco precedente+2. Ogni candidato
migliore o uguale lo aggiorna; release e ricerche senza candidati lo conservano.
La scelta a parità è l’ultima, non la prima. Persiste in JSON; nei vecchi
salvataggi assenti rimane null fino a un’allocazione reale. Non ricavarlo
dalla lista finale e non usare un default 9FE3/zero. Dati controllati: 14 layout,
159 operazioni, 200 scritture con tutti i byte; naturali: 6 sequenze,97 checkpoint,
302 draw/614 read con confronto della word a ogni ingresso casuale. Suite 797.
Atlante: 176 istruzioni/307 byte prima grigi, inclusi 2 byte dati; nuove zone
A11A–A11B,A11C–A15F,A160–A1AE,A1AF–A1C6,A1C7–A20B,A20C–A24C.
