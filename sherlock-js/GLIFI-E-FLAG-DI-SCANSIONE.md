# 5D1E: i flag salvati durante il disegno del glifo

Il motore autonomo ricostruisce un nuovo operando del generatore casuale:
5D1E. Non carica la RAM dell’originale né una sequenza di risposte.

## Algoritmo e proprietà del valore

Il glifo C388 salva il registroAF del chiamante, i suoi BC/DE/HL e poi
lavora su otto scanline. C39D salva AF della scansione prima degli shift.
C3B1/C3B2 lo ripristinano; DEC C/INC C ricostruiscono i flag dallo shift;
con shift nonzero C3B8 salva di nuovo AF. Il carry è conservato da INC/DEC,
ma l’OR della scanline precedente lo ha azzerato. DJNZ non modificaF.

Prima dell’ottava scansione, F proviene da INC H della settima. Per la
riga del testo in fondo allo schermo, la base è5020: quel passaggio è56->57.
La proiezione calcola i flag di INC (S/Z/H/PV/X/Y e carry conservato), poi,
se shift1..7, quelli di INC(shift-1). Con shift0 resta lo store C39D.
Il risultato è0 nel chiamante verificato. Non si assegna però0 alla cella
all’avvio, a ogni WAIT o a ogni carattere indipendentemente dal frame.
Il contenuto non si deduce dal byte del font salvato accanto: q ha una riga
finale nonzero ma un ruoloF distinto.

| Frame C388 | Ruolo fisico di5D1E |
| --- | --- |
|5D20|F del chiamante, dopo CP13 del carattere|
|5D22|C del chiamante|
|5D24|E del descrittore di testo|
|5D26|L dell’indirizzo video|
|5D28|C dello shift della scansione|
|5D2A|F della scansione|

La CALL reale C374 può inoltre scrivere il proprio return link C377:
con frame5D1E il byte fisico è77, un ruolo diverso. Tutti questi salvataggi
sono trattati dal renderer in modo distinto; BC del chiamante non noto
revoca i byte che ne dipendono.

La nuova proprietà richiede il contratto del prefisso proprio del nome
attore in682A ->6804 ->67F7 ->A7C5/D3E8. La profondità del suo renderer è
5D2A. Il GO TO già verificato non raggiunge questo salvataggio e lo conserva;
scene generiche, errori e chiamanti sconosciuti lo revocano. I vecchi LOAD
senza il byte rimangono sconosciuti fino a un writer, anche se5D1D/5D1F
sono presenti. Non si introducono5D24–5D27 per estensione.

## Prove e confine residuo

Sono riesaminate1728 chiamate native ABI archiviate:8 frame,2 valoriB del
chiamante,3 caratteri e36 colonne. Vengono confrontati tutti i byte posseduti,
compreso il nuovo5D1E; non soltanto l’output SVG o le stringhe inglesi.
Il test di C374 aggiunge288 chiamate reali della pulizia riga. SAVE/LOAD,
revoca su errore e caller BC sconosciuto hanno prove dedicate.

Il confronto lungo supera5D1E, ma si ferma sul secondo operando5D24 nella
stessa estrazione del checkpoint374 verso Wed10:10. Non è un nuovo
checkpoint completo: restano374 checkpoint0–373 fino a Wed10:00,
7223 draw/15464 read,24 attori, arena752 byte, bitmap e futuro LOAD.
Cinque finali naturali restano aperti e il limite cab5D0C è separato.

La lettura vera avviene a Wed10:08, tick3009, giardiniere8. L’ultimo
writer è C3B8 al tick964, Lestrade2: prefisso Inspector, glifo r, frame5D2A,
colonna8, shift2, indirizzo5027,AF0000. Il byteF è0 per il ciclo sopra
ricostruito, non perché la traccia fornisce uno zero da installare.
La lettura di5D1F nello stesso probe serve a distinguereF daA.

La nuova traccia nativa in `results/glyph-scan-flags/natural-stores.json`
osserva tutti i PUSH/CALL ed EX(SP),HL, incluse scritture invariate, non
soltanto variazioni del byte. Raccoglie separatamente le transizioni non
classificate e i veri accessi del generatore. Il rapporto finale è in
`results/glyph-scan-flags-verification.json`.

## Atlante

Approfonditi682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,
C363–C37C,C388–C3E3,CE10–CE17,D3E8–D447 e workspace5D1E.
Il dossier riassembla235 istruzioni/419 byte. Nessun nuovo byte grigio:
è un approfondimento funzionale di routine già classificate; non indica
il completamento del gameplay.

```
python3 tools/probe-glyph-scan-flags.py
python3 tools/build-glyph-scan-flags-listing.py
python3 tools/build-memory-map.py
node --test test/glyph-scan-flags.test.mjs test/glyph-count.test.mjs test/glyph-address-high.test.mjs
node tools/verify-witness-prefix.mjs
```
