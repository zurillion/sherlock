# Direzione del progetto: motore autonomo JavaScript

Dal 23 ottobre 2026 il prodotto da sviluppare è **`sherlock-js/`**, una riscrittura funzionale autonoma. Il codice Z80 viene studiato e usato in prove separate come riferimento, senza essere eseguito dal nuovo gioco.

La vecchia pagina in `sherlock-analisi/locazioni`, normalmente sulla porta 8766, esegue ancora il motore originale attraverso il ponte Python/Z80. Le sue prove su NPC, trasporti, eventi e casualità riguardano quel ponte: **non attestano che tali sistemi siano già stati riscritti**.

Le analisi e gli estrattori accumulati restano utili. I dati estratti, i testi e le immagini possono essere utilizzati dal nuovo motore. In questa prima consegna autonoma sono tradotti lessico, grammatica, mondo statico e alcune regole generiche. La copertura completa e i limiti delle verifiche sono in `sherlock-js/COPERTURA.md`.

Per provare il nuovo nucleo:

```sh
cd "/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-js"
node tools/serve.mjs --port 8768
```

Aprire <http://127.0.0.1:8768/>. La porta diversa rende esplicito quale implementazione si sta provando. Il nuovo server serve solamente file statici; il gameplay è eseguito dai moduli JavaScript nel browser.

Prossimo blocco funzionale: inizializzazione, scheduler e casualità, seguiti da primitive condivise, Watson, Lestrade e cab. Ogni port richiede confronto di effetti, messaggi e tempo su fixture dichiarate, senza introdurre un ripiego al vecchio motore.
