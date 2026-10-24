# Sherlock: riscrittura autonoma in JavaScript

Questa è la prima parte di una riscrittura funzionale di Sherlock. **Non è ancora il gioco completo.** Il motore contiene regole JavaScript su oggetti logici e non esegue il programma Z80. Il vecchio esperimento web in `sherlock-analisi/locazioni` rimane uno strumento di riferimento separato.

## Avvio

Serve Node.js 20 o successivo, senza pacchetti da installare:

```sh
cd "/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-js"
node tools/serve.mjs --port 8768
```

Aprire <http://127.0.0.1:8768/>. Il server distribuisce solamente file: i comandi e lo stato della partita vengono gestiti nel browser. Non occorrono Python, SkoolKit, TAP, TZX, un file ROM esterno o un altro servizio: i valori immutabili usati dalla sorgente casuale sono già nei dati. La cartella può essere copiata da sola su un server statico. Il doppio clic su `index.html` non è sufficiente, perché i browser limitano i moduli e il caricamento JSON attraverso `file://`.

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

**Watson risponde ora ai saluti e a TELL nelle nuove partite del profilo storico v4.** Ricarica la pagina JavaScript e premi **Riavvia**; salva prima se vuoi conservare la partita precedente. La pagina ripristina automaticamente le vecchie sessioni, che non ricevono uno stato casuale inventato.

Prova `SAY TO WATSON "HELLO"`, ripetilo, poi `SAY TO WATSON "TELL ME ABOUT LESTRADE"`. `HELLO` senza citazione mantiene `HI.` nella zona comandi. Restano disponibili gli ordini TAKE/DROP, WAIT e FOLLOW ME, e il seguito attraverso uscite adiacenti. Sono collegati il secondo contatore di lettura, le callback e il biglietto di Watson nel profilo verificato.

**Non è ancora una ricostruzione completa degli NPC.** Il profilo ha solo Watson attivo e manca il bootstrap da seed. La sorgente originale usa anche lo schermo e altri dati: i percorsi verificati generano gli ingressi; regioni ancora sconosciute causano l'annullamento esplicito del comando. Nella prova storica di saluti ripetuti, questo confine arriva al comando 33. Dettagli, provenienza dei valori usati e ambito dei confronti: [WATSON-RUNTIME.md](WATSON-RUNTIME.md) e [FIDELITY.md](FIDELITY.md).

Su Baker Street (e nelle altre nove strade della rete) prova `HAIL CAB`, `GET INTO CAB`, `GET OUT OF CAB`. Cab, cocchiere e denaro arrivano insieme; chiamata, salita e discesa sono salvate. Ora è disponibile anche `PAY 1/- TO CABBIE`, come trasferimento ordinario. **Viaggio, attese, richieste di pagamento, proteste e resto non sono ancora tradotti.** Un avviso fuori dal testo del gioco segnala questo limite. La separazione fra comandi è ora verificata sulle righe dello schermo originale; i messaggi degli NPC non introducono una separazione supplementare. Analisi del prefisso: [SALUTI-E-CAB.md](SALUTI-E-CAB.md). Aggiornamento, tabella TELL e contesto delle scelte: [CONVERSATIONS.md](CONVERSATIONS.md). Le conversazioni nella pagina restano incomplete.

Lo stesso esperimento funziona con `YOUR` per aprire soltanto la propria porta. Sono supportati anche `OPEN ALL DOORS`, `CLOSE ALL`, `TAKE ALL`, `DROP ALL` e `GIVE ALL TO WATSON` nelle varianti generiche già tradotte; BUT/EXCEPT resta esplicitamente mancante.

## Sorgenti e verifiche

Il flusso è `Lexer → Parser → Game → World/Text → scheduler → presentazione`. [ARCHITETTURA.md](ARCHITETTURA.md) lo descrive con esempi. [COPERTURA.md](COPERTURA.md) distingue ciò che funziona, ciò che è parziale e ciò che manca.

```sh
node --test test/*.test.mjs
```

Le fixture sono risultati congelati dell'originale, non chiamate al vecchio motore durante i test. Molti confronti di frasi normalizzano spaziatura e maiuscole; quelli nuovi del corpo TELL conservano le maiuscole. Non certificano l'output grafico esatto. Il rapporto corrente elenca i test automatici, compreso il confronto del selettore testuale con 1.280 esecuzioni controllate originali. La parità di seed e della sequenza di gioco non è ancora implementata. `results/verification.json` registra l'ambito delle prove; `results/tests.tap` ne conserva il risultato.

## Dati e salvataggi

`data/game.json` contiene dizionario, oggetti, locazioni, grafo e testi estratti. I testi sono rappresentati come operazioni semantiche di un formato dati, ad esempio parola, nome dell'oggetto e condizione sull'ora. Nessuna di queste operazioni è un'istruzione CPU. I dati includono separatamente valori immutabili di ROM e codice consultati come ingressi dalla sorgente casuale; non sono mai eseguiti. [WATSON-RUNTIME.md](WATSON-RUNTIME.md) ne dichiara la provenienza e i limiti.

Il programma giocabile usa esclusivamente questi dati e i moduli JS. Per rigenerare i dati dalle analisi già presenti nel progetto, separatamente dall'esecuzione:

```sh
node tools/build-data.mjs --project "/Users/giovanni/Documents/Development/Sherlock rebuild"
```

L'estrattore legge anche le sezioni dati del payload originale, senza eseguirlo. Conserviamo gli identificatori delle parole e dei frammenti per poterli confrontare con le analisi. La riscrittura è indipendente dal codice eseguibile originale, non dagli asset e dai contenuti del gioco.

I nuovi salvataggi `sherlock-js-save` memorizzano entità, locazioni, tempo, domanda di chiarimento pendente e presentazione. La versione 4 conserva anche accumulatore, cursore e ingressi video/input generati, oltre al programma, ai contatori e agli ordini di Watson. I file v3 mantengono il vecchio profilo privo di sorgente casuale: Riavvia attiva i nuovi dialoghi. Le versioni 1 e 2 sono caricabili con gli NPC disabilitati come in precedenza; Riavvia attiva il nuovo profilo. Sono controllati tramite checksum e non contengono RAM o registri. I vecchi snapshot del ponte Z80 non sono compatibili. La ripresa deterministica è verificata per il nucleo attuale; comprende le scelte future del profilo v4 implementato, senza certificare la partita completa originale.

Il lavoro sul kernel condiviso degli NPC è descritto in [NPC-FOUNDATIONS.md](NPC-FOUNDATIONS.md). Programmi semantici, continuazioni, arena dei record e aritmetica del cab sono implementati e confrontati separatamente; i tre NPC completi non sono ancora disponibili nella pagina. Per rigenerare i dati occorre prima esportare `ai/results/domain-programs.json` con il comando documentato in quel file.
