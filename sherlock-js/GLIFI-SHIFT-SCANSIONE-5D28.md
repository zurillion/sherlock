# $5D28: shift della scansione nel nome della destinazione

31 ottobre 2026. Ricostruito il byte `$5D28` consultato dal giardiniere alle
16:12 di mercoledì. Il runtime rimane JavaScript autonomo: la proiezione
calcola il residuo dalle operazioni del formatter, senza eseguire Z80 né
installare il valore catturato nella traccia.

## Algoritmo e ultimo writer

Nella finestra di testo il carattere in colonna c comincia al pixel
`x = 2 + 7*c`. Il renderer usa `C = x & 7` per dividerne la riga tra i due
byte della bitmap. `$C39C` salva BC prima della scansione; quando C non è
zero, `$C3B2` lo ripristina e `$C3B7` lo salva nuovamente prima del secondo
byte. Con C zero, `$C3B7` viene saltata e resta l’ultimo store di `$C39C`.
Il C temporaneamente usato per il secondo shift non è il residuo finale.

Con frame `$5D32`, C salvato occupa `$5D28`. Il chiamante naturale è il
prefisso proprio del nome della destinazione nell’ordine di Lestrade al
cocchiere: «Parliament» viene scaricato prima del ritorno, mentre «Street»
rimane nel buffer. L’ultima lettera del prefisso è `t`, in colonna 24:
`(2 + 7*24) & 7 = 2`.

Ultimo store originale: `$C3B7`, tick 964, SP `$5D2A`, BC `$0102`, frame
`$5D32`, glifo `t`, descrittore `$5C0B`, video `$5035`. Il soggetto
temporaneo della citazione è zero; l’ordine resta di Lestrade. Il
Giardiniere (attore 8) legge il byte al tick 3373, mercoledì 16:12.
Il valore 2 non è una costante globale: tutte le colonne sono verificate.

La stessa cella ha sei ruoli secondo il frame d’ingresso: `$5D2A` F del
chiamante, `$5D2C` C del chiamante, `$5D2E` E del descrittore, `$5D30` L
video, `$5D32` C della scansione, `$5D34` F della scansione. La CALL reale
in `$C374`, con frame `$5D28`, può lasciarvi 77 del ritorno C377.

## Proprietà e salvataggi

Il byte è posseduto soltanto nei chiamanti verificati del renderer.
Scene, errori, nomi locazione senza contratto e output non proiettato ne
revocano il valore. Il vecchio SAVE senza 28 resta sconosciuto anche se
27 è noto; il lettore casuale non deve trovare un fallback nelle costanti.
Una nuova scrittura compresa ristabilisce il dato. I nuovi SAVE conservano
lo stato corrente. `$5D25` e `$5D29` rimangono non proiettati.

## Prove e ambiti

- 1.728 casi ABI originali archiviati: otto frame, 36 colonne, due conteggi
  del chiamante e tre caratteri. Verificano anche lo shift zero.
- 1.152 varianti archiviate di descrittore: distinguono E dal C dello shift.
- 216 nuove chiamate originali con frame `$5D34`: verificano il ruolo F
  della scansione nella stessa cella. Sono prove controllate, non partite.
- 288 vere CALL di pulizia: distinguono il return link dai registri.
- La traccia naturale è **riutilizzata** da `glyph-last-row/natural-stores.json`,
  che già osservava 27 e 28 insieme. La copia nel dossier conserva percorso
  e SHA256 della fonte. Non viene dichiarata una nuova esecuzione naturale.
  Non risultavano transizioni non classificate nell’acquisizione originale.
- Replay JS senza patch del mondo fino a mercoledì 16:30: confronta i valori
  posseduti, il writer e la lettura effettiva del giardiniere; interrompe
  regolarmente WAIT prima del SAVE. Questo test non sostituisce il confronto
  completo del prefisso descritto di seguito.

Il prefisso completo raggiunge **413 checkpoint 0–412, mercoledì 16:30**,
con **8254 draw e 17684 read** confrontati, tutti i 24 posti attore,
entità, fatti, scheduler, arena di 752 byte, bitmap e futuro dopo LOAD.
Protocollo: seed 1, LOOK iniziale gratuito, grafica originale disabilitata,
tasti maiuscoli iniettati e MORE immediato. Le due estrazioni iniziali sono
separate dal numero di draw confrontati nei checkpoint.

Il prossimo limite è `$A028`, al checkpoint 413 verso mercoledì 16:40.
Non vengono rimossi campi dal confronto per superarlo. Restano anche i
cinque finali naturali aperti, il limite cab 5D0C e i tre controesempi
precedenti: PRINT/MORE, TAKE TO e la riga transitoria del giardiniere al
minuto Tue14:02. La prova continua di A027 resta limitata a canale/draw
oltre quel confine di stato; il nuovo prefisso completo usa i propri
checkpoint originali, senza normalizzazione degli argomenti degli attori.

Passati 113 controlli mirati distinti: 53 del nuovo dossier, 52 del font
e 8 di mappa/pubblicazione. La suite completa viene eseguita da GitHub
Actions sul commit pubblicato.

## Atlante e ripetibilità

Approfonditi `$C388–$C3E3`, in particolare `$C39C`, `$C3B2–$C3B7` e
`$C3CF`, la pulizia `$C363–$C37C`, i nomi in `$A360–$A418`, `$A7BA–$A7C4`,
`$D3E8–$D447`, l’ordine `$CE10–$CE17` e il workspace `$5D28`.
Il listing verifica 324 istruzioni e 616 byte. Sono raffinamenti di zone
già documentate: **nessun nuovo byte prima grigio**. Copertura invariata:
38.649 documentati, 465 parziali, 2.486 grigi su 41.600 byte.
Questa misura statica non certifica l’equivalenza dell’intero gameplay.

```
python3 tools/probe-glyph-scan-shift-abi.py
python3 tools/build-glyph-scan-shift-listing.py
python3 tools/build-memory-map.py
node --test test/glyph-scan-shift.test.mjs test/glyph-last-row.test.mjs test/memory-map.test.mjs
node tools/verify-witness-prefix.mjs
```

Artefatti: `results/glyph-scan-shift/` e
`results/glyph-scan-shift-verification.json`.
