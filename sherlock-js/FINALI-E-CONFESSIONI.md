# Finali naturali e confessioni degli NPC

27 ottobre 2026. Motore autonomo JavaScript `world-v5`.

## Arresto del maggiore, con Holmes presente

`results/final-solution/major-arrest-present.txt` è una cronologia reale:
nessun teletrasporto, modifica di PC, flag delle prove o stato importato.
Holmes torna a Londra, raggiunge Slater Street, indossa il travestimento
cinese per entrare nella fumeria e lo toglie all'interno. In questo percorso
esce prima di ascoltare la confessione. Rimane con Watson sulla strada e
assiste all'arresto: il testo terminale è **69BF**, martedì alle 01:03.
È distinto dal testo **6A26**, già certificato con Holmes altrove.

Confronto passato: 171 checkpoint, 2.464 estrazioni, tutti i 24 posti dello
scheduler attivi. Si confrontano ingressi e successori di ogni estrazione,
scadenze, PC, argomenti, entità, prove, intera arena, buffer e bitmap.
La prova verifica anche i pacchetti della pagina, il testo prima del tasto
finale, Salva/Carica e l'arresto definitivo degli aggiornamenti.

Protocollo: seed 1, LOOK iniziale gratuito, grafica nativa disabilitata dopo
l'avvio, tasti maiuscoli iniettati, MORE e conferma finale immediati, nessun
timeout di input. La certificazione vale per questo protocollo dichiarato.

## Tricia e Mrs Jones: TELL ha effetti, non soltanto una risposta

Le intestazioni e i programmi DOMAIN E17B–E1D7 sono **dati**. Le azioni
locali TELL del parlante selezionano due programmi diversi:

- Tricia, E1A3: E1B4 controlla il tema e la percezione dei vestiti 67.
  Se sono visibili, E03A cambia l'attore 13 nell'identità 95, Mrs Jones;
  vengono trasferiti collocazione, possedimenti diretti e contesti sospesi.
  E1CF rende disponibile la confessione nell'albero della prova.
- Mrs Jones, E17B: E18A registra il racconto dei temi 16, 17 o 67 nella
  prova 9996; poi il corpo comune E1D8 pronuncia la risposta.

Il motore esegue queste trasformazioni e le rispettive fasi DOMAIN, senza
un interprete Z80. I riferimenti espliciti alla vecchia identità restano tali.
Il salvataggio ammette il posto di Tricia occupato da Mrs Jones.

`test/jones-dialogue.test.mjs` confronta l'intera trasformazione, il racconto
a Lestrade e la sua accettazione dell'accusa, compreso il seguito dopo LOAD.
**È una prova controllata**: Tricia e Lestrade sono collocati nella stanza 8,
Tricia parte da F192 e tre indizi hanno il flag di esame. Non certifica una
soluzione naturale completa.

Un secondo caso rivela un difetto dell'originale: chiedere a Tricia dei
vestiti quando non sono percepibili può rimanere nel formatter A9B0. Il
prototipo annulla esplicitamente quel comando senza alterare lo stato;
questa protezione non viene presentata come parità del comportamento nativo.

## Differenze di output e dipendenze casuali corrette

- D1B2, visita breve al buio: stampa il nome del luogo e il testo originale
  68C1, «It is too dark to see much else.»; omette uscite e oggetti.
- CC37/C821 seleziona i dialoghi per percezione; il buio non rende muti gli
  NPC. A2E4 riguarda invece l'annuncio di un'azione fallita. SAY, TELL e
  HAIL mantengono il proprio contratto di luce; INVENTORY richiede luce.
- Un cab guidato da un NPC che arriva nella stanza di Holmes passa da CBC2:
  **A hansom cab enters.** Il ramo non è la descrizione del veicolo occupato
  da Holmes.
- I nomi delle stanze usano le forme flesse degli aggettivi: *disgusting*,
  non il tema *disgust*. Nella composizione degli ordini i loro termini di
  dizionario vengono soppressi fuori scena come nell'originale: non devono
  sovrascrivere il buffer delle parole. I frammenti letterali conservano
  invece i propri effetti anche fuori scena.
- C374 lascia il ritorno C377 nel frame di cancellazione della riga. Un
  ritorno a capo profondo può sovrascrivere campi precedentemente posseduti.
  Questo permette di mantenere i campi calcolati della scena D187 del cab,
  senza installare byte registrati dal gioco originale. Il cab della polizia
  conserva invece il precedente confine dei campi non ancora posseduti.
- A00D/A00E e il padding CC0C sono dati del payload; F60B è il colore di
  riempimento iniziale del profilo con grafica nativa disabilitata. Non sono
  valori di ripiego per salvataggi con uno stato sconosciuto.
- A00F/A010 conservano le classi degli argomenti: si ricavano dal modello
  dell'azione e dalle intestazioni delle regole; CDA7 modifica soltanto la
  prima classe. Sono stato corrente, non copie di una registrazione.

## Limiti ancora aperti

Sono certificati naturalmente quattro testi terminali: **693A, 69BF, 6A26,
759C**. Restano **6A33, 6ABD, 6AF3, 6B79 e 75D2**, oltre all'acquisizione
naturale completa delle prove degli omicidi e della vendita dei piani.
Le verifiche controllate dei nove selettori restano distinte da queste storie.

Il percorso con la vera osservazione del maggiore è in verifica separata:
`major-witness.txt`. La ricerca JavaScript raggiunge attualmente martedì 05:18 e si ferma
prima di usare un ingresso ancora sconosciuto a 5D12. Il campo precedente
5D11 viene ora calcolato dalla proiezione dei glifi, non letto da una traccia.
Il relativo fixture è materiale di ricerca finché il
confronto non passa tutti i suoi checkpoint. Non basta raggiungere il testo
corretto se il primo ingresso casuale o la bitmap divergono prima.

Fonti riproducibili: `tools/probe-other-endings.py`,
`tools/probe-jones-dialogue.py`, `tools/build-final-solution-listing.py`.
Il listato `results/final-solution/source.asm` distingue codice e dati e
riassembla esattamente 406 byte, 181 istruzioni.

## Esito del confronto esteso

La raccolta originale del percorso `major-witness` è conclusa: 521
checkpoint, finale **6A33 giovedì alle 10:00**. È conservata in forma
compressa in `results/final-solution/witness-native-reference.json.gz`.
Non è un nuovo certificato del motore JavaScript.

Il primo confronto fallisce già al checkpoint 25, lunedì 08:57, dopo:

```text
SAY LESTRADE "MAJOR VISIT OPIUM DEN AND MAJOR IS INNOCENT"
```

Il byte 97B5, appartenente a un record del parser già liberato, conserva
9 in JavaScript e 4 nell'originale. La risposta visibile coincide, ma
questo residuo può modificare le successive estrazioni. Il blocco tecnico
a 5D12 delle 05:18 è quindi un limite di esecuzione del prototipo, **non**
il primo punto di divergenza dalla partita originale.

Riproduzione: `node --test tools/compare-witness-research.mjs`. Questo
confronto di ricerca è intenzionalmente ancora fallente ed è separato
dalla suite di regressione: **657 test passati, zero errori**. Il prossimo
intervento deve ricostruire la durata e il riuso dei record delle due
affermazioni prima di certificare il resto della notte.
