# Riprodurre l’analisi dello scrolling

Dalla cartella Sherlock rebuild:

```sh
python3 -B sherlock-analisi/scrolling/trace_scrolling.py
python3 -B sherlock-analisi/scrolling/verify_scrolling.py
python3 -B sherlock-analisi/scrolling/build_scrolling_listing.py
```

Il primo comando esegue l’avvio originale fino al primo prompt, prosegue con le sequenze di input e con il timeout, registra tutte le richieste di avanzamento, le modifiche del contatore e le pause. Scrive `results/scroll-traces.json` e schermate native PNG delle prime pause. Le fixture isolate esercitano CR consecutivi, fine colonna, pulizia e cambio di larghezza.

Il secondo comando legge le tracce, verifica 18 proprietà ed esegue due ulteriori prove native delle copie bitmap con memoria video controllata. Scrive `results/verification.json`.

Il terzo genera `results/scrolling.asm`, con codice e dati distinti, e verifica ogni istruzione/direttiva ri-assemblandola. Scrive `results/listing-verification.json`.

Tutti accettano `--project PERCORSO` e `--output CARTELLA`. Eseguendo gli script da una copia fuori dal progetto specificare, per esempio:

```sh
python3 -B trace_scrolling.py --project '/Users/giovanni/Documents/Development/Sherlock rebuild'
```

Non servono nuove librerie: sono usati Python, la distribuzione SkoolKit del progetto e la RAM originale. I PNG vengono generati con la libreria standard dai byte della bitmap e degli attributi Spectrum. Le istruzioni del payload non vengono modificate e non si accede alla partita del server web.

L’interpretazione dei risultati è in `LEGGIMI-SCROLLING.md`.
