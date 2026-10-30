# $5D27: ultima riga del font nel nome della destinazione

31 ottobre 2026. Ricostruito il byte `$5D27`, che bloccava il prefisso
naturale dopo mercoledì 14:40. Il motore rimane JavaScript autonomo:
l’originale e le tracce servono soltanto alle prove offline.

## Provenienza del byte

Il renderer `$C388` ricava l’indirizzo del glifo con `3C00 + carattere*8`.
`LD A,(DE)` in `$C39B` carica ciascuna delle otto righe. `PUSH AF` in
`$C39D` salva A prima di spostare i pixel; quando la riga occupa due byte
video, `$C3B1` ripristina A e `$C3B8` lo risalva per il secondo byte.
L’ultimo A salvato è quindi **la riga grezza numero 7 del font**.
Non è il carattere ASCII, un byte della bitmap già disegnata o il flag F.

Nel frame `$5D32` del prefisso proprio del nome locazione, A occupa
`$5D27` e F occupa `$5D26`. Il chiamante è quello già ricostruito in
NOMI-LOCAZIONI-E-STACK.md: la frase dell’ordine di Lestrade al cocchiere,
con il prefisso «Parliament» scaricato prima del ritorno e «Street» ancora
nel buffer. La composizione usa temporaneamente il soggetto zero.

L’ultimo store naturale è `$C3B8`, tick 964, glifo `t`, frame `$5D32`,
SP `$5D28`, colonna 24, shift 2, descrittore `$5C0B`, video `$5035`.
La cuoca, attore 9, legge `$5D27` al tick 3284, mercoledì 14:43.
Qui `glyph(t)[7]` vale zero; il motore lo ricava dal font. La stessa regola
restituisce 6 per `q` e 255 per `_`, indipendentemente dallo shift.

Questa cella ha altri ruoli in altri frame: A chiamante in `$5D28`,
B chiamante in `$5D2A`, D descrittore in `$5D2C`, H video in `$5D2E`,
B scansione in `$5D30`, A font in `$5D32`. La CALL reale in `$C374`,
con frame `$5D26`, lascia invece il byte alto C3 del ritorno C377.
Le prove distinguono questi casi anziché attribuire ovunque una riga del font.

## Proprietà e salvataggi

La proiezione usa i contratti di chiamata già verificati per il prefisso
proprio della destinazione negli ordini CE13. Output privo di contratto,
scene ed errori revocano il dato; anche il percorso di un nome locazione
non proiettato revoca entrambi i byte 26 e 27.
Un vecchio SAVE senza 27 resta sconosciuto finché una scrittura compresa
non lo riscrive, anche se 26 è presente. I nuovi salvataggi conservano il
byte corrente e il confronto verifica anche il futuro dopo LOAD.
`$5D25` e `$5D28` non vengono introdotti per vicinanza.

## Prove e limite successivo

- 1.728 casi ABI originali archiviati: otto frame, 36 colonne, due conteggi
  del chiamante e tre caratteri, compreso `q` con riga finale non nulla.
- 768 nuovi casi originali: tutti i 96 glifi del font, otto shift, frame
  `$5D32`, DE `$5C42`, B 7. Nessuna patch del codice o del font.
- 288 vere CALL di pulizia `$C374`, con controllo del residuo di ritorno.
- Probe naturale seed 1, tutti i 24 attori, grafica originale disabilitata,
  tasti maiuscoli iniettati e MORE immediato: segue anche store invariati
  e CALL/EX(SP),HL. L’osservazione dell’originale oltre il limite del modello
  non certifica quelle ore di gameplay JavaScript.
- Confronto completo del prefisso: **404 checkpoint 0–403 fino a mercoledì
  15:00**, 8.011 draw e 17.166 read, scheduler, entità, fatti, tutti i 752
  byte dell’arena, bitmap esatte e futuro dopo LOAD. Le due estrazioni
  iniziali sono separate dal conteggio dei draw confrontati.

Passati 164 test mirati distinti: 52 del nuovo dossier, 53 del nome
locazione, 51 del descrittore e 8 di mappa/pubblicazione. La suite completa
è affidata a GitHub Actions sul commit pubblicato.

Il prossimo confine è **`$A027`**, checkpoint 404 verso mercoledì 15:10.
Il confronto esplorativo non sopprime il fallimento. I test naturali dei
byte 26 e 27 devono completare fino alle 15:00 senza not_translated, poi
interrompono regolarmente WAIT prima del SAVE; non si fermano più al
vecchio limite 27. I cinque finali naturali 6A33, 6ABD, 6AF3, 6B79, 75D2 e
il limite distinto del cab 5D0C restano aperti.

## Atlante e ripetibilità

Approfonditi `$C388–$C3E3` (soprattutto lookup del font, caricamento e
salvataggio delle scansioni), `$C363–$C37C` (ritorno della CALL reale),
`$A360–$A418`, `$A7BA–$A7C4`, `$D3E8–$D447`, `$CE10–$CE17` e il workspace
`$5D27`. Sono raffinamenti di zone già classificate: **nessun nuovo byte
prima grigio**. Il listing del dossier verifica 324 istruzioni e 616 byte.
Copertura statica invariata: 38.569 documentati, 466 parziali, 2.565 grigi
su 41.600; non è una misura dell’equivalenza dell’intera partita.

Strumenti:

```
python3 tools/probe-glyph-last-row-abi.py
python3 tools/probe-glyph-last-row.py
python3 tools/build-glyph-last-row-listing.py
python3 tools/build-memory-map.py
node --test test/glyph-last-row.test.mjs test/room-name-stack.test.mjs test/memory-map.test.mjs
node tools/verify-witness-prefix.mjs
```

Prove in `results/glyph-last-row/` e rapporto in
`results/glyph-last-row-verification.json`. I dossier precedenti conservano
i loro risultati storici; il backlog corrente è RIPRESA-GAMEPLAY.md.
