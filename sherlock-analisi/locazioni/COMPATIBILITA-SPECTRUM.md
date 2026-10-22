# Modalità compatibilità ZX Spectrum

Attivazione: spuntare **Compatibilità ZX Spectrum** sopra i due pannelli. La preferenza viene ricordata nel browser. Il riquadro usa la partita corrente e il parser già presenti nell’esploratore.

## Schermo e tastiera

Il video virtuale misura 256 × 192 pixel. L’ingrandimento è fisso e selezionabile:

- **2×:** 512 × 384 pixel CSS.
- **3×:** 768 × 576 pixel CSS.

La griglia ha 36 colonne, con passo di sette pixel e margine di due pixel per lato. Le 24 righe hanno altezza di otto pixel: 18 righe superiori, una riga con orologio e motivo grafico, cinque righe inferiori. Si usano i caratteri bitmap della ROM Spectrum fornita con Foggy London e i 24 byte della striscia originale di Sherlock a `$C190`. Sullo schermo i pixel dei caratteri restano netti anche su display ad alta densità.

Fare clic sul video per scrivere. Il testo del comando è maiuscolo; il punto di inserimento è un **+**. Si possono inserire caratteri stampabili, cancellare l’ultimo con **Backspace** e inviare con **Invio**. Frecce, Home, End e Delete non spostano il cursore né modificano il testo. Incolla, taglia e trascinamento di testo sono disabilitati. Il limite resta quello del parser già usato dal prototipo: 70 caratteri per comando. `£` è supportato come nel ponte Python esistente.

Le cinque righe conservano i comandi recenti e le risposte del canale inferiore, scorrendo verso l’alto. Ogni riga usata comincia con `> `, compresi errori e continuazioni su più righe: restano 34 colonne per il contenuto. Il prompt pronto è `> +`. Gli errori e le domande originali, come `WHICH DOOR ?`, vengono mostrati qui in maiuscolo. Le risposte alla domanda vengono inviate allo stesso contesto di continuation del gioco.

## Scrittura, scroll e MORE

All’avvio di una nuova partita e dopo **Riavvia**, lo schermo superiore e l’area comandi sono vuoti; la barra di stato mostra già il motivo originale con le pistole, senza orologio o quadratino. Non compaiono ancora `>` e cursore. Il gioco attende un tasto qualsiasi. Dopo il tasto, la prima riga compare subito sopra la barra; ogni riga nuova fa salire quelle precedenti. Anche la successiva uscita continua a partire dalla riga inferiore. L’orologio appare subito al primo tasto alle **Mon 08:00am** e resta alle 08:00am dopo la descrizione iniziale. La descrizione è seguita dal saluto iniziale di Watson, recuperato dal testo originale già stampato prima dello snapshot: fra descrizione e saluto c’è un solo a capo, senza riga vuota. Non viene eseguito un secondo turno dell’NPC.

L’orologio comincia a x=16 pixel virtuali, con passo di sette pixel. Una cella bianca di otto pixel precede e segue il testo: la seconda cella 8×8 della barra, a x=8, resta quindi vuota.

L’uscita superiore viene composta per parole, con intervallo di presentazione di circa 32,5 ms (il doppio della velocità precedente). Le parole che non entrano nella riga passano alla successiva. Le sequenze più lunghe della riga vengono spezzate per garantire che il testo avanzi sempre.

Alla fine dell’uscita superiore di ciascun comando viene aggiunta una riga vuota, che separa la risposta da quella successiva. I diversi messaggi dello stesso comando rimangono consecutivi; un errore scritto solo nella zona inferiore non modifica il testo superiore. Anche la riga vuota finale rispetta la pausa MORE e non fa avanzare l’orologio.

La regola attuale del renderer web è la seguente: prima del primo scroll che perderebbe una riga delle 18 visualizzate, la scrittura si ferma. L’ultima cella 8×8 della barra di stato (x=248, y=144) lampeggia invertendo il bianco e il nero del motivo già disegnato; nella fase spenta torna visibile il motivo originale. Non viene sostituita con un riquadro pieno. Questo indicatore compare solo per MORE, mai nella pausa iniziale. **Un tasto qualsiasi** riprende l’uscita e autorizza un’altra pagina di scroll; anche un clic sul video consente di continuare. Il tasto viene consumato: non finisce nel comando e non provoca azioni del gioco.

La pausa e la velocità di scrittura sono gestite dalla presentazione JavaScript. L’orologio riceve i valori dal motore esistente e non avanza per i timer grafici né per il tasto MORE. Durante l’uscita non si possono inviare altri comandi. Disattivare la modalità sblocca un eventuale MORE pendente e restituisce la normale interfaccia.

Il pulsante **Riavvia ↺**, sopra il video, ricrea la partita da zero: locazione iniziale, oggetti, stato del parser, comandi e orologio. Resta disponibile anche durante la scrittura e le pause MORE. Annulla l’uscita precedente; se una richiesta è già in corso, ne attende la fine prima di sostituire la partita, evitando che una risposta vecchia alteri il nuovo avvio. Le preferenze grafiche restano memorizzate.

Ricaricare una partita già iniziata, o attivare la modalità durante quella partita, ripresenta la scena corrente con orologio visibile: non propone la pausa riservata al nuovo avvio. Il saluto iniziale di Watson fa parte dell’apertura della nuova partita e di Riavvia; non viene ripetuto come effetto del ricaricamento di una partita in corso.

L’avvio gratuito è una scelta dell’esploratore richiesta dall’utente. Il riferimento Z80 del primo prompt resta alle 08:01am nelle analisi originali. `Game` riporta il calendario alle 08:00am, arretra di un tick le scadenze degli attori e riallinea la scadenza di Sherlock al tick corrente. Quest’ultimo passaggio elimina il minuto già anticipato nello snapshot: WAIT dura cinque minuti anche subito dopo l’avvio e WAIT UNTIL raggiunge l’ora richiesta. Gli opcode Z80 e gli snapshot di ricerca restano invariati. Il dettaglio del confronto è in `ATTESE-E-FINE-PARTITA.md`.

## Attese e fine partita

Durante WAIT e WAIT UNTIL la barra mostra ogni minuto prodotto dal ciclo originale. WAIT dura cinque minuti; WAIT UNTIL si interrompe con **Invio** o con **Interrompi**, appena disponibile il controllo nativo successivo. Se è visibile il MORE, Invio continua soltanto il testo. Per specificare la fascia usare `WAIT UNTIL 9:00AM` o `WAIT UNTIL 9:00PM`, senza spazio prima del suffisso.

Alla morte o alla conclusione si stampa il finale originale e si congelano comandi, tempo e spostamenti tramite mappa. Il MORE rimane utilizzabile per leggere tutto. **Riavvia** apre una nuova partita. Ricaricare la pagina conserva invece il finale nella stessa sessione del server. Gli errori tecnici del prototipo compaiono fuori dallo schermo virtuale.

## Immagini

Il selettore offre:

- **SVG:** le ricostruzioni con linee rette già presenti nell’esploratore.
- **Pixel originali:** i 14 raster `*-exact.png`, 128 × 176, già verificati contro lo Z80 nella fase grafica. Si usa ingrandimento senza interpolazione.

La grafica viene collocata a destra, alla coordinata virtuale x=128, conservando proporzioni e scala del disegno originale. È limitata alle 18 righe superiori richieste: dei 176 pixel di altezza sono inizialmente visibili i primi 144; la composizione principale dei disegni è nei primi 128. La barra e i comandi rimangono nelle proprie righe.

Il testo accanto alla figura usa 18 colonne a sinistra, come nel gestore grafico originale. Dopo il MORE passa a 36 colonne; la figura scorre insieme al contenuto precedente. Cambiando locazione viene rimossa l’immagine precedente; gli eventi di primo ingresso e LOOK forniti dal server decidono quando mostrarne una nuova.

L’interruttore **Immagini** mostra/nasconde anche la grafica della modalità compatibilità. Le scelte SVG/raster e 2×/3× vengono ricordate. Il pannello contiene tutta la larghezza del video e della cornice, anche a 3×. Le due colonne non hanno più larghezza obbligatoriamente uguale: la colonna del gioco rispetta la dimensione effettiva del terminale e il contenitore principale può arrivare a 1900 pixel. Con 3× e meno di 1324 pixel disponibili nella finestra, la mappa passa sotto al gioco; con 2× rimane il passaggio a colonna unica sotto i 1150 pixel. Non c’è uno scorrimento orizzontale interno al riquadro. Se la finestra del browser è fisicamente più stretta dei 768 pixel del video 3×, l’intera pagina deve comunque poter scorrere: per vedere tutto insieme occorre allargare il browser oppure usare 2×. La griglia e la dimensione scelta dei caratteri non vengono ridotte automaticamente.

## File e manutenzione

| File | Funzione |
|---|---|
| `spectrum.js` | Griglia, coda di scrittura, MORE, editor limitato e disegno del terminale. |
| `explorer-ui.js` | Interfaccia e collegamento al server; comprende mappa e modalità normale. |
| `build_compat_assets.py` | Estrae font/striscia, include i raster esistenti e compone il file servito. |
| `spectrum-assets.json` | Asset estratti, hash delle fonti e PNG originali incorporati. |
| `app.js` | Bundle generato da terminale, asset e interfaccia. |
| `verify_compatibility.cjs` | Controlli della griglia, dell’impaginazione e degli asset. |
| `verify_restart.py` | Avvio alle 08:00am, costi nativi e ripristino della partita. |
| `verify_terminal.cjs` | Coda, tastiera, MORE, lotti di testo incrementali e blocco dopo la fine partita. |
| `verify_wait_endgame.py` | Attese, interrupt originali, confronto del mondo, morte, gateway di vittoria e QUIT. |

**Per modificare l’interfaccia, lavorare su `explorer-ui.js` e `spectrum.js`, quindi ricostruire `app.js`.** Il bundle rende la funzione disponibile anche al server già aperto, che conosceva solo le route HTML/CSS/JS precedenti. Per modifiche statiche non occorre riavviarlo né perdere le sessioni. Le modifiche Python richiedono invece il riavvio del server locale.

Dalla cartella Sherlock rebuild:

```sh
python3 -B sherlock-analisi/locazioni/build_compat_assets.py
node sherlock-analisi/locazioni/verify_compatibility.cjs
node sherlock-analisi/locazioni/verify_terminal.cjs
python3 -B sherlock-analisi/locazioni/verify_restart.py
```

Dopo modifiche statiche, ricaricare la pagina. Entrare nella modalità ricompone la descrizione della locazione corrente; la scelta della modalità non esegue LOOK né aggiunge il suo costo temporale.

Le verifiche automatiche coprono impaginazione, progresso delle parole lunghe, pausa prima di perdere righe, ripresa, consumo del tasto MORE, cancellazione della coda al cambio di modalità, tastiera limitata, zona inferiore e dimensioni dei 14 raster. Le prove nel browser controllano anche griglia effettiva, orologio, continuation, SVG/raster e proporzioni del video.

Questa è una presentazione compatibile con le richieste di griglia e interazione. La cadenza delle parole e la paginazione non sono una simulazione dei cicli della CPU o del video Spectrum. Il motore Python esistente continua a determinare azioni, risposte e tempo.

## Confronto con la paginazione originale

L’analisi nativa successiva in [Scorrimento e MORE](../scrolling/LEGGIMI-SCROLLING.md) ha verificato una regola diversa: `$A019` conta gli avanzamenti di riga e richiede MORE quando è 15, prima di quello successivo. Il parser e la modalità grafica hanno azzeramenti propri. La disponibilità di scroll basata sulle 18 righe, descritta sopra, è ancora il comportamento del prototipo e deve essere allineata a quelle tracce per riprodurre la paginazione originale. Questa fase di analisi non modifica il renderer web.
