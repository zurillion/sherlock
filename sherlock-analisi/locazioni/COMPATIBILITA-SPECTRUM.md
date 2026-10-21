# Modalità compatibilità ZX Spectrum

Attivazione: spuntare **Compatibilità ZX Spectrum** sopra i due pannelli. La preferenza viene ricordata nel browser. Il riquadro usa la partita corrente e il parser già presenti nell’esploratore.

## Schermo e tastiera

Il video virtuale misura 256 × 192 pixel. L’ingrandimento è fisso e selezionabile:

- **2×:** 512 × 384 pixel CSS.
- **3×:** 768 × 576 pixel CSS.

La griglia ha 36 colonne, con passo di sette pixel e margine di due pixel per lato. Le 24 righe hanno altezza di otto pixel: 18 righe superiori, una riga con orologio e motivo grafico, cinque righe inferiori. Si usano i caratteri bitmap della ROM Spectrum fornita con Foggy London e i 24 byte della striscia originale di Sherlock a `$C190`. Sullo schermo i pixel dei caratteri restano netti anche su display ad alta densità.

Fare clic sul video per scrivere. Il testo del comando è maiuscolo; il punto di inserimento è un **+**. Si possono inserire caratteri stampabili, cancellare l’ultimo con **Backspace** e inviare con **Invio**. Frecce, Home, End e Delete non spostano il cursore né modificano il testo. Incolla, taglia e trascinamento di testo sono disabilitati. Il limite resta quello del parser già usato dal prototipo: 70 caratteri per comando. `£` è supportato come nel ponte Python esistente.

Le cinque righe conservano i comandi recenti e le risposte del canale inferiore. Gli errori e le domande originali, come `WHICH DOOR ?`, vengono mostrati qui in maiuscolo. Le risposte alla domanda vengono inviate allo stesso contesto di continuation del gioco.

## Scrittura, scroll e MORE

All’avvio della modalità e dopo **Ricomincia**, lo schermo superiore è vuoto e il quadratino lampeggiante attende un tasto. Dopo il tasto, la prima riga compare subito sopra la barra; ogni riga nuova fa salire quelle precedenti. Anche la successiva uscita continua a partire dalla riga inferiore. L’orologio comincia due colonne più a destra rispetto alla versione precedente: x=16 pixel virtuali, con passo di sette pixel.

L’uscita superiore viene composta per parole, con intervallo di presentazione di circa 65 ms. Le parole che non entrano nella riga passano alla successiva. Le sequenze più lunghe della riga vengono spezzate per garantire che il testo avanzi sempre.

Prima del primo scroll che perderebbe una riga delle 18 visualizzate, la scrittura si ferma. Nella cella destra della barra di stato lampeggia un quadratino. **Un tasto qualsiasi** riprende l’uscita e autorizza un’altra pagina di scroll; anche un clic sul video consente di continuare. Il tasto viene consumato: non finisce nel comando e non provoca azioni del gioco.

La pausa e la velocità di scrittura sono gestite dalla presentazione JavaScript. L’orologio riceve i valori dal motore esistente e non avanza per i timer grafici né per il tasto MORE. Durante l’uscita non si possono inviare altri comandi. Disattivare la modalità sblocca un eventuale MORE pendente e restituisce la normale interfaccia.

## Immagini

Il selettore offre:

- **SVG:** le ricostruzioni con linee rette già presenti nell’esploratore.
- **Pixel originali:** i 14 raster `*-exact.png`, 128 × 176, già verificati contro lo Z80 nella fase grafica. Si usa ingrandimento senza interpolazione.

La grafica viene collocata a destra, alla coordinata virtuale x=128, conservando proporzioni e scala del disegno originale. È limitata alle 18 righe superiori richieste: dei 176 pixel di altezza sono inizialmente visibili i primi 144; la composizione principale dei disegni è nei primi 128. La barra e i comandi rimangono nelle proprie righe.

Il testo accanto alla figura usa 18 colonne a sinistra, come nel gestore grafico originale. Dopo il MORE passa a 36 colonne; la figura scorre insieme al contenuto precedente. Cambiando locazione viene rimossa l’immagine precedente; gli eventi di primo ingresso e LOOK forniti dal server decidono quando mostrarne una nuova.

L’interruttore **Immagini** mostra/nasconde anche la grafica della modalità compatibilità. Le scelte SVG/raster e 2×/3× vengono ricordate. Una finestra più stretta della dimensione scelta offre scorrimento orizzontale del riquadro, senza ridurre la griglia o cambiare la dimensione dei caratteri.

## File e manutenzione

| File | Funzione |
|---|---|
| `spectrum.js` | Griglia, coda di scrittura, MORE, editor limitato e disegno del terminale. |
| `explorer-ui.js` | Interfaccia e collegamento al server; comprende mappa e modalità normale. |
| `build_compat_assets.py` | Estrae font/striscia, include i raster esistenti e compone il file servito. |
| `spectrum-assets.json` | Asset estratti, hash delle fonti e PNG originali incorporati. |
| `app.js` | Bundle generato da terminale, asset e interfaccia. |
| `verify_compatibility.cjs` | Controlli della griglia, dell’impaginazione e degli asset. |
| `verify_terminal.cjs` | Controlli della coda reale, della tastiera e della cancellazione del MORE. |

**Per modificare l’interfaccia, lavorare su `explorer-ui.js` e `spectrum.js`, quindi ricostruire `app.js`.** Il bundle rende la funzione disponibile anche al server già aperto, che conosceva solo le route HTML/CSS/JS precedenti. Non occorre riavviarlo né perdere le sessioni.

Dalla cartella Sherlock rebuild:

```sh
python3 -B sherlock-analisi/locazioni/build_compat_assets.py
node sherlock-analisi/locazioni/verify_compatibility.cjs
node sherlock-analisi/locazioni/verify_terminal.cjs
```

Dopo modifiche statiche, ricaricare la pagina. Entrare nella modalità ricompone la descrizione della locazione corrente; la scelta della modalità non esegue LOOK né aggiunge il suo costo temporale.

Le verifiche automatiche coprono impaginazione, progresso delle parole lunghe, pausa prima di perdere righe, ripresa, consumo del tasto MORE, cancellazione della coda al cambio di modalità, tastiera limitata, zona inferiore e dimensioni dei 14 raster. Le prove nel browser controllano anche griglia effettiva, orologio, continuation, SVG/raster e proporzioni del video.

Questa è una presentazione compatibile con le richieste di griglia e interazione. La cadenza delle parole e la paginazione non sono una simulazione dei cicli della CPU o del video Spectrum. Il motore Python esistente continua a determinare azioni, risposte e tempo.
