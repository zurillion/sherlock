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

## Scelta del motore

Il selettore **Motore** in alto passa fra **Originale · Z80** (porta 8766) e **Nuovo · JavaScript autonomo** (porta 8768). Le partite sono separate: il nuovo conserva la propria sessione nella scheda e l’originale nel server già esistente. Non viene convertita una partita da un formato all’altro. Il cambio è disponibile anche durante l’avvio, la stampa e il MORE. Dettagli e limiti: [FASE-2.md](FASE-2.md).

## Cosa provare

```text
OPEN DOOR
ALL
WEST
DOWN
OPEN FRONT DOOR
SOUTH
NORTH
UP
EAST
```

Oppure, dopo un riavvio: `TAKE LAMP`, `INVENTORY`, `GIVE LAMP TO WATSON`, `COUNT MONEY`, `WAIT`. I clic sul grafo permettono di esplorare le descrizioni senza consumare tempo. Sono presenti immagini SVG e pixel originali e la presentazione in stile Spectrum.

**Watson esegue ora gli ordini e il seguito attraverso uscite adiacenti.** Prova `SAY TO WATSON "TAKE LAMP"`, `SAY TO WATSON "DROP DAILY CHRONICLE"`, poi `OPEN YOUR DOOR`, `WEST`, `DOWN`. È disponibile anche `SAY TO WATSON "FOLLOW ME"`. `HELLO` da solo produce `HI.` nella zona comandi, come nell’originale. Il saluto rivolto a Watson richiede la sorgente casuale globale: la precedente risposta temporale fissa è stata rimossa. Per ora la richiesta viene segnalata come non ricostruita, senza consumare tempo o inventare una risposta. [FIDELITY.md](FIDELITY.md) stabilisce il criterio di equivalenza e documenta il problema. Gli altri NPC, treni e storia restano da riscrivere. Il contatore iniziale di Watson è il valore 15 del prompt storico; al secondo contatore casuale il programma si sospende esplicitamente. Inizializzazione completa, callback e sequenza casuale non sono ancora equivalenti all’originale. Dettagli e prove: [FASE-3.md](FASE-3.md). Un comportamento non tradotto produce un avviso esplicito fuori dal testo del gioco. Non esiste un ripiego automatico al motore originale. Il seed è disabilitato finché non avremo ricostruito il generatore e tutte le dipendenze che ne determinano le estrazioni.

Su Baker Street (e nelle altre nove strade della rete) prova `HAIL CAB`, `GET INTO CAB`, `GET OUT OF CAB`. Cab, cocchiere e denaro arrivano insieme; chiamata, salita e discesa sono salvate. **Viaggio, attese del cocchiere, pagamento e resto non sono ancora tradotti.** Un avviso fuori dal testo del gioco segnala questo limite. La separazione fra comandi è ora verificata sulle righe dello schermo originale; i messaggi degli NPC non introducono una separazione supplementare. Analisi e prove: [SALUTI-E-CAB.md](SALUTI-E-CAB.md).

Lo stesso esperimento funziona con `YOUR` per aprire soltanto la propria porta. Sono supportati anche `OPEN ALL DOORS`, `CLOSE ALL`, `TAKE ALL`, `DROP ALL` e `GIVE ALL TO WATSON` nelle varianti generiche già tradotte; BUT/EXCEPT resta esplicitamente mancante.

## Sorgenti e verifiche

Il flusso è `Lexer → Parser → Game → World/Text → scheduler → presentazione`. [ARCHITETTURA.md](ARCHITETTURA.md) lo descrive con esempi. [COPERTURA.md](COPERTURA.md) distingue ciò che funziona, ciò che è parziale e ciò che manca.

```sh
node --test test/*.test.mjs
```

Le fixture sono risultati congelati dell'originale, non chiamate al vecchio motore durante i test. Il confronto di una frase normalizza spaziatura e maiuscole: non certifica l'output grafico esatto. Sono presenti 236 test automatici, compreso il confronto del selettore testuale con 1.280 esecuzioni controllate originali. La parità di seed e della sequenza di gioco non è ancora implementata. `results/verification.json` registra l'ambito delle prove; `results/tests.tap` ne conserva il risultato.

## Dati e salvataggi

`data/game.json` contiene dizionario, oggetti, locazioni, grafo e testi estratti. I testi sono rappresentati come operazioni semantiche di un formato dati, ad esempio parola, nome dell'oggetto e condizione sull'ora. Nessuna di queste operazioni è un'istruzione CPU.

Il programma giocabile usa esclusivamente questi dati e i moduli JS. Per rigenerare i dati dalle analisi già presenti nel progetto, separatamente dall'esecuzione:

```sh
node tools/build-data.mjs --project "/Users/giovanni/Documents/Development/Sherlock rebuild"
```

L'estrattore legge anche le sezioni dati del payload originale, senza eseguirlo. Conserviamo gli identificatori delle parole e dei frammenti per poterli confrontare con le analisi. La riscrittura è indipendente dal codice eseguibile originale, non dagli asset e dai contenuti del gioco.

I nuovi salvataggi `sherlock-js-save` memorizzano entità, locazioni, tempo, domanda di chiarimento pendente e presentazione. La versione 3 conserva anche il programma, i contatori e gli ordini di Watson. Le versioni 1 e 2 sono caricabili con gli NPC disabilitati come in precedenza; Riavvia attiva il nuovo profilo. Sono controllati tramite checksum e non contengono RAM o registri. I vecchi snapshot del ponte Z80 non sono compatibili. La ripresa deterministica è verificata per il nucleo attuale; non è ancora una promessa sulle scelte casuali degli NPC, la cui sorgente resta da tradurre.

Il lavoro sul kernel condiviso degli NPC è descritto in [NPC-FOUNDATIONS.md](NPC-FOUNDATIONS.md). Programmi semantici, continuazioni, arena dei record e aritmetica del cab sono implementati e confrontati separatamente; i tre NPC completi non sono ancora disponibili nella pagina. Per rigenerare i dati occorre prima esportare `ai/results/domain-programs.json` con il comando documentato in quel file.
