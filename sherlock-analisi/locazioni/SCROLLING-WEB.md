# Scrolling originale nella pagina web

La modalità compatibilità riproduce il contatore `$A019` e le routine `$A9B7/$AA14/$C2CA`, invece di attribuire una disponibilità fissa di 18 scroll a ogni pagina. La base Z80 e i listati verificati sono in [Scorrimento e MORE](../scrolling/LEGGIMI-SCROLLING.md).

## Flusso fra Python e JavaScript

`native_screen.py:ScreenStream` osserva il codice originale senza modificarlo:

- `$A9DF`: parola già costruita nel buffer `$5C0B`, delimitatore, flag di maiuscola e nome proprio. La parola è catturata prima del word wrap. Backspace e suffissi sono già stati risolti dal gioco.
- `$D71A/$A29C`: scritture di azzeramento del contatore, nel loro ordine effettivo.
- `$C129/$C142`: modalità stretta/larga. Il C142 chiamato da MORE viene escluso: il browser determina il proprio MORE secondo la larghezza scelta.
- `$A277`: richiesta di immagine della locazione.

Ogni messaggio conserva `text` per la modalità normale e aggiunge `screen_events` per il terminale. Quest’ultimo usa gli eventi senza rispezzare il testo già normalizzato. Eventi senza prosa visibile restano nel flusso. Errori e domande restano nella zona inferiore; i loro eventuali azzeramenti vengono comunque applicati. I lotti al minuto di WAIT non aggiungono CR o reset.

Il motore web mantiene la grafica Z80 disabilitata. Il browser esegue la preparazione A296/C129 quando la richiesta A277 corrisponde a una figura disponibile e abilitata; quindi può scegliere SVG o raster senza cambiare il mondo. Il formatter ricalcola il word wrap a 18 o 36 colonne e inserisce gli spazi delle virgolette come AA14. Non vengono inoltrati anche gli a capo automatici della VM, che altrimenti verrebbero contati due volte. Per il salto tramite mappa, funzionalità propria dell’esploratore, la prima visita conserva una richiesta di figura anche quando CA9E sceglie la descrizione breve e non attraversa A277; una richiesta già presente non viene duplicata.

L’apertura viene osservata eseguendo un avvio originale in una **VM separata**, una sola volta per processo/progetto. Gli eventi partono dal programma iniziale di Holmes, includono il saluto di Watson e arrivano al primo prompt. La VM della partita resta allo snapshot già pronto: nessun turno viene ripetuto e il calendario gratuito richiesto resta alle 08:00am. La cache conserva gli eventi senza modificare il file originale.

## Risultati attesi

Al primo MORE: contatore 15, 15 scroll completati, tre righe vuote in alto e 15 righe di testo, ultima riga `says " Good morning Holmes. "`. Non è ancora stato eseguito il CR finale. La zona comandi è ancora vuota. Il tasto continua il CR, lascia il contatore a zero e rende disponibile `> +`.

Le pause dipendono dagli avanzamenti accumulati e dagli azzeramenti reali. Il criterio non è «schermo pieno», né «fine comando», né «numero di messaggi». Le righe vuote dell’originale restano presenti, senza separatori aggiunti dal frontend.

## Verifiche riproducibili

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/locazioni/verify_paging.py
node sherlock-analisi/locazioni/verify_paging.cjs
node sherlock-analisi/locazioni/verify_compatibility.cjs
node sherlock-analisi/locazioni/verify_terminal.cjs
python3 -B sherlock-analisi/locazioni/verify_opening.py
python3 -B sherlock-analisi/locazioni/verify_wait_endgame.py
```

I primi due script producono `results/paging-fixtures.json`, `paging-bridge-verification.json` e `paging-browser-verification.json`. Il riferimento usa `ScrollProbe` dell’analisi originale: osserva la griglia scritta e gli scroll effettivi, non la funzione JavaScript da verificare. Per ogni fase si confrontano tutte le 18 righe, ogni schermata MORE, contatore, larghezza, colonne residue e numero di scroll. Le prove comprendono avvio, WAIT, parola sconosciuta, LOOK, LOOK. LOOK, errore sintattico, risposta YOUR e lungo intervento di Watson; una prova separata usa il vero formatter Z80 a 18 colonne fino al cambio a 36 durante MORE.

Le prove del terminale coprono inoltre CR a fine riga esatta, pulizia prima dell’immagine, modalità senza immagini, tasto consumato, cancellazione durante restart, flusso diviso in più risposte HTTP e indicatore 8×8 che inverte il motivo originale.

Gli aggiornamenti Python richiedono il riavvio del server locale; la pagina va ricaricata per il nuovo bundle. Le partite sono ancora solo in RAM. La pagina conserva l’avvio gratuito alle 08:00am e il ritmo grafico di circa 32,5 ms per parola, che sono scelte di presentazione già concordate.
