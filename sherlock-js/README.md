# Sherlock: riscrittura autonoma in JavaScript

Questa è la prima parte di una riscrittura funzionale di Sherlock. **Non è ancora il gioco completo.** Il motore contiene regole JavaScript su oggetti logici e non esegue il programma Z80. Il vecchio esperimento web in `sherlock-analisi/locazioni` rimane uno strumento di riferimento separato.

## Avvio

Serve Node.js 20 o successivo, senza pacchetti da installare:

```sh
cd "/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-js"
node tools/serve.mjs --port 8768
```

Aprire <http://127.0.0.1:8768/>. Il server distribuisce solamente file: i comandi e lo stato della partita vengono gestiti nel browser. Non occorrono Python, SkoolKit, TAP, TZX, ROM o un altro servizio. La cartella può essere copiata da sola su un server statico. Il doppio clic su `index.html` non è sufficiente, perché i browser limitano i moduli e il caricamento JSON attraverso `file://`.

Interfaccia testuale alternativa, con lo stesso motore:

```sh
node tools/play.mjs
```

Nel terminale, `:save /percorso/partita.json`, `:load /percorso/partita.json` e `:exit` gestiscono la sessione.

## Cosa provare

```text
OPEN DOOR
YOUR
WEST
DOWN
OPEN FRONT DOOR
SOUTH
NORTH
UP
EAST
```

Oppure, dopo un riavvio: `TAKE LAMP`, `INVENTORY`, `GIVE LAMP TO WATSON`, `COUNT MONEY`, `WAIT`. I clic sul grafo permettono di esplorare le descrizioni senza consumare tempo. Sono presenti immagini SVG e pixel originali e la presentazione in stile Spectrum.

**Watson e gli altri personaggi sono statici.** Il saluto iniziale è una sequenza già tradotta, ma l'AI successiva, cab, treni e storia restano da riscrivere. Un comportamento non tradotto produce un avviso esplicito fuori dal testo del gioco. Non esiste un ripiego automatico al motore originale. Il seed è disabilitato finché non avremo ricostruito il generatore e tutte le dipendenze che ne determinano le estrazioni.

## Sorgenti e verifiche

Il flusso è `Lexer → Parser → Game → World/Text → presentazione`. [ARCHITETTURA.md](ARCHITETTURA.md) lo descrive con esempi. [COPERTURA.md](COPERTURA.md) distingue ciò che funziona, ciò che è parziale e ciò che manca.

```sh
node --test test/*.test.mjs
```

Le fixture sono risultati congelati dell'originale, non chiamate al vecchio motore durante i test. Il confronto di una frase normalizza spaziatura e maiuscole: non certifica l'output grafico esatto. `results/verification.json` registra l'ambito delle prove; `results/tests.tap` ne conserva il risultato.

## Dati e salvataggi

`data/game.json` contiene dizionario, oggetti, locazioni, grafo e testi estratti. I testi sono rappresentati come operazioni semantiche di un formato dati, ad esempio parola, nome dell'oggetto e condizione sull'ora. Nessuna di queste operazioni è un'istruzione CPU.

Il programma giocabile usa esclusivamente questi dati e i moduli JS. Per rigenerare i dati dalle analisi già presenti nel progetto, separatamente dall'esecuzione:

```sh
node tools/build-data.mjs --project "/Users/giovanni/Documents/Development/Sherlock rebuild"
```

L'estrattore legge anche le sezioni dati del payload originale, senza eseguirlo. Conserviamo gli identificatori delle parole e dei frammenti per poterli confrontare con le analisi. La riscrittura è indipendente dal codice eseguibile originale, non dagli asset e dai contenuti del gioco.

I nuovi salvataggi `sherlock-js-save` memorizzano entità, locazioni, tempo, domanda di chiarimento pendente e presentazione. Sono controllati tramite checksum e non contengono RAM o registri. I vecchi snapshot del ponte Z80 non sono compatibili. La ripresa deterministica è verificata per il nucleo attuale; non è ancora una promessa sulle scelte casuali degli NPC, che non sono implementate.
