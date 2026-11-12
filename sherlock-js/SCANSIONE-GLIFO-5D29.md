# Il contatore di scansione del glifo in $5D29

12 novembre 2026. Continuazione di [Offset del glifo in $5D22 e $5D28](OFFSET-GLIFO-5D22-5D28.md).

Il giardiniere legge `$5D29` mercoledì alle 17:48, tick 3469. L'ultima
scrittura è di Holmes, martedì alle 11:32, tick 1653. `$C3B7` esegue
`PUSH BC` con `BC = $0104` durante lo spazio dopo `plain`, nel frame
del glifo `$5D32`. Il byte alto 1 va in `$5D29`, l'offset 4 in `$5D28`.

Il renderer inizializza B a 8 in `$C399`. Ogni riga salva BC in
`$C39C` e, se il glifo attraversa due byte video, di nuovo in
`$C3B7`. `DJNZ` in `$C3D2` decrementa B alla fine della riga.
L'ultimo salvataggio avviene con B uguale a 1. Nel ramo allineato
l'ultimo valore viene dal primo salvataggio, a `$C39C`.

La traccia riparte dal prompt Brown originale e ripete le stesse
attese. Al punto `$A074` del tick 3378 confronta tutti i dieci byte
con la fine della traccia precedente. Da lì segue ogni istruzione
fino alla lettura. Il raccordo registra l'hash delle 3960 scritture
precedenti. La nuova finestra osserva zero ulteriori scritture e zero
transizioni non classificate negli indirizzi `$5D20–$5D29`.

## Motore e controlli

Il campo B è noto nel frame dello spazio separatore ricostruito. La
conoscenza di C e di B resta indipendente. Il conteggio è determinato
dal ciclo del glifo. Uno scorrimento, un nome successivo o un chiamante
ignoto può sovrascrivere il byte. Per esempio, la CALL da `$C374` può
lasciare il byte alto del ritorno `$C377` nello stesso indirizzo.

Le ABI originali esistenti coprono 1296 casi su sei frame. Tra le 720
geometrie del passaggio, i 290 valori che il motore stabilisce
coincidono. Tra i 720 arrivi propri eleggibili, 110 sovrascrivono
`$5D29` durante lo scorrimento. I 300 controlli su riga fresca e i 129
rifiuti semplici preservano il byte. Il motore conserva il valore
durante un arrivo ordinario con riga fresca, buffer vuoto, spacing
zero, nome che entra e `counter + 2 < 15`. Un vecchio SAVE privo del
campo deve passare da una scrittura modellata prima di poterlo usare.

## Confronto della partita

Il confronto riusa il riferimento originale con 562 checkpoint fino
a mercoledì 23:00. La sequenza coincide su **539 checkpoint fino a
mercoledì 19:10**, con 8685 estrazioni e 18524 letture confrontate.
Sono inclusi tutti i 24 attori, i 752 byte dell'arena, le bitmap e il
futuro dopo LOAD anche durante l'attesa minuto per minuto.

Il limite successivo è **`$5D2A` al tick 3560, mercoledì alle 19:19**.
Il checkpoint originale escluso, indice 539, è alle 19:20 e mostra
una lettura di 51 da parte della cuoca. La traccia precedente
terminava a `$5D29`. Serve osservare le scritture a `$5D2A` per
ricostruire la provenienza di quella lettura.

Il finale `$6A33` resta verificato su 521 checkpoint fino a giovedì
10:00, inclusi pausa e blocco terminale. La sequenza Brown mantiene
la prova mancante e i viaggi falliti. Il finale naturale `$6ABD` e
gli altri rami aperti restano da verificare.

Tutti i 1905 test della suite sono passati. Il
[report di verifica](results/passage-scan-count-29-verification.json)
riunisce i risultati e gli hash delle evidenze.

## Atlante

Aggiornati il glifo `$C388–$C3E3`, lo scorrimento
`$C316–$C387`, i passaggi `$D60B–$D670`, gli arrivi
`$CBC2–$CC0A`, i rifiuti `$C1FD–$C23F` e il workspace `$5D29`.
Il listing include i relativi chiamanti, per 395 istruzioni e 715
byte riassemblati. Restano 39364 byte documentati, 428 parziali e
1808 ignoti su 41600.

Gli artefatti sono in `results/passage-scan-count-29/`. Per rigenerare
il listing si usa `tools/build-passage-descriptor-high-21-listing.py
--scan-count`. Per il confronto completo si usa
`node tools/verify-passage-scan-count-29.mjs`, con `--baseline` per
il finale `$6A33`.
