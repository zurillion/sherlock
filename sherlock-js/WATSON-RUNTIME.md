# Watson nella pagina: profilo storico v4

24 ottobre 2026. Il saluto e TELL sono ora collegati alla riscrittura autonoma. Non sono ancora completi Watson, cabbie e Lestrade, né la parità dell'intera partita con un seed scelto.

## Come provarlo

Apri la pagina JavaScript sulla porta 8768, ricaricala e premi **Riavvia**. Se vuoi conservare una partita precedente, salvala prima: i file vecchi e la sessione ripristinata dalla scheda mantengono il proprio stato precedente. La scritta «Watson v4: saluti e TELL attivi» identifica una nuova partita.

```text
SAY TO WATSON "HELLO"
SAY TO WATSON "HELLO"
SAY TO WATSON "TELL ME ABOUT LESTRADE"
```

HELLO senza citazione continua a dare HI. nella zona comandi. Dopo un ordine WAIT, una richiesta viene eseguita alla scadenza di Watson, non immediatamente. Non introdurre un secondo comando solo perché la risposta differita non è ancora comparsa.

## Cosa è stato collegato

- Scelta inversa delle alternative con l'aritmetica originale; nessuna probabilità sostitutiva o sequenza preregistrata.
- Flusso condiviso di accumulatore e cursore; callback E691 con entrambe le estrazioni anche quando non produce testo.
- Contatori degli incontri con Holmes, Lestrade e Wiggins, compreso il decremento quando sono lontani.
- Seconda attesa di lettura: 15 più l'estrazione originale, attesa prima del primo decremento, ritorno di Holmes, biglietto e uscita di Watson.
- Estrazione di ampiezza zero alla creazione del contatore FOLLOW: modifica comunque lo stato casuale.
- TELL: tabella attore/soggetto, testo della risposta e scelta del prefisso says/remarks. Affermazioni, deduzioni e memoria delle informazioni restano da completare.
- Salvataggi v4 con stato casuale, proiezione video/input, richieste e contatori. Le vecchie versioni non ricevono uno stato casuale inventato.

## Da dove vengono gli ingressi casuali

`runtime-random.mjs` esegue soltanto l'aritmetica della sorgente. `random-display.mjs` ricostruisce caratteri, word wrapping, scroll, cursore di comando e input. I byte bitmap consultati vengono calcolati dai glifi, senza installare una schermata o RAM originale. Le preferenze SVG/pixel e la velocità di animazione del browser non modificano questa proiezione canonica.

Il generatore originale consulta anche valori immutabili della ROM, del dizionario, delle immagini e del codice. L'estrattore li conserva dichiaratamente come **valori di ingresso**, mai come istruzioni da eseguire. `data/game.json` contiene quindi anche valori numerici derivati dal codice verificato e dai 16 KiB della ROM. Il runtime non usa registri CPU, un interprete Z80, un'immagine RAM completa o un backend originale. Gli indirizzi servono a risolvere questi ingressi, non a chiamare routine native.

La classificazione del codice avviene solo offline, partendo da confini e radici riconosciuti; ogni istruzione è riassemblata e confrontata con il payload. I bersagli di scrittura diretta conosciuti sono esclusi dai valori costanti. I programmi NPC modificabili e altre regioni non possedute dalla proiezione non ricevono un ripiego alla RAM iniziale. Questo meccanismo ha l'ambito dei percorsi verificati, non dimostra l'immutabilità globale di ogni byte per ogni possibile partita.

## Prove e confini

`test/runtime-watson.test.mjs` esegue gli stessi comandi nell'engine JS senza fornire le letture della fixture al generatore. Confronta ogni estrazione: ordine, attore, ampiezza, contesto, accumulatore e cursore iniziali, indirizzi e valori letti, risultato e stato successivo. Sono verificati 217 comandi, 572 estrazioni e 1.174 letture, più 217 bitmap del testo superiore confrontate byte per byte attraverso SHA256. Le stesse righe sono verificate anche passando i pacchetti della sessione web attraverso SpectrumBuffer. Tutti i 269 test passano anche in una copia isolata con Node soltanto. Il testo del log conserva le maiuscole ma normalizza spaziatura e virgolette: questo confronto da solo non certifica tutti i pacchetti di IO.

Il riferimento parte dal primo prompt storico, con accumulator 77, cursor 512 e contatore di lettura 15; solo Watson resta attivo. Gli altri test impostano sei accumulatori **dopo il prompt**, con cursore zero: non sono nuovi avvii equivalenti da quei seed. Il profilo canonico è senza grafica originale; SVG e immagini della UI restano una preferenza di presentazione. Il LOOK iniziale gratuito è una deliberata estensione dell'analisi.

La sequenza storica verifica i primi 32 saluti. Il comando 33 raggiunge $5C00, una regione di stato non ancora ricostruita; poco dopo il riferimento usa anche $5D00 e $5CF5. Il comando viene annullato con un avviso del prototipo. Non sono zeri sostitutivi, risposte fisse o avanzamenti silenziosi. Le immagini di stato intermedie del comando annullato vengono scartate anche dalla presentazione dei minuti.

I salvataggi v4 riproducono le scelte future del modello implementato; non trasformano una partita incompleta in una partita equivalente all'originale. Restano necessari bootstrap, tutte le dipendenze casuali, semantica completa delle richieste, informazioni e altri attori. Lestrade e il servizio completo del cab non sono ancora attivi.

## Riprodurre le prove

Nel progetto completo, Python serve solo per interrogare il riferimento offline:

```sh
python3 tools/build-random-listing.py --project .. --output ../sherlock-analisi/ai/results/random-input-code.asm
node tools/build-data.mjs
python3 tools/probe-runtime-watson.py --project .. --output test/fixtures/runtime-watson-reference.json
node --test test/runtime-watson.test.mjs
node --test test/*.test.mjs
```

La cartella `sherlock-js` già costruita funziona e viene testata con Node soltanto.
