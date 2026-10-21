# Script del main loop

Questi tre nuovi script analizzano ed eseguono il codice originale nell'emulatore Z80 già usato per il parser. Non sono ancora un motore Sherlock riscritto in Python. Richiedono Python 3, la distribuzione locale `skoolkit-10.1`, il payload, gli snapshot del parser e il catalogo delle entità presenti nel progetto. Non richiedono nuove dipendenze da scaricare.

Dalla cartella del progetto:

```sh
cd '/Users/giovanni/Documents/Development/Sherlock rebuild'
python3 sherlock-analisi/main-loop/trace_main_loop.py
python3 sherlock-analisi/main-loop/verify_main_loop.py
python3 sherlock-analisi/main-loop/build_loop_listing.py
```

1. `trace_main_loop.py` esegue 14 casi: avvio, LOOK, errori, disambiguazione, comando composto, attese, SAVE/QUIT e timeout. Scrive `results/loop-traces.json` e `results/actors.json`. È il comando più lento; stampa l'avanzamento per caso. Arresta SAVE/QUIT al confine dell'I/O nastro.
2. `verify_main_loop.py` verifica i risultati appena prodotti e alcune routine isolate, incluso il confronto fra attesa HALT accelerata e ordinaria. Scrive `results/verification.json`; un errore genera un'eccezione anziché un esito positivo.
3. `build_loop_listing.py` genera `results/main-loop.asm`, con codice, dati e bytecode esplicitamente distinti; ricompone ogni istruzione e confronta i byte con il payload. Scrive anche `results/listing-verification.json`.

Tutti accettano `--project PERCORSO` e `--output CARTELLA`. Nella collocazione canonica sopra il progetto è individuato automaticamente; se si esegue una copia da un'altra cartella, specificare `--project`:

```sh
python3 trace_main_loop.py --project '/Users/giovanni/Documents/Development/Sherlock rebuild' --output ./results
```

`ATTORI.md` e `TRACCE.md` sono riepiloghi dei risultati consegnati; i tre script rigenerano i JSON e il listato, non i documenti narrativi. Ogni esecuzione delle tracce parte dagli snapshot previsti, non da una partita che l'utente sta giocando. I file originali del gioco non vengono modificati.
