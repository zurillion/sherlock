# Cabbie e viaggio con Lestrade: regressioni del 24 ottobre 2026

Il motore autonomo ora supera la corsa in cab e il viaggio come passeggero insieme a Lestrade nelle sequenze descritte qui. Il riferimento è il TAP locale: seed 1 all’avvio, tutti i 24 attori attivi, LOOK iniziale gratuito, grafica nativa disabilitata dopo il primo prompt, tasti iniettati in maiuscolo, MORE immediato e nessun timeout della tastiera. Nessuna sequenza usa il teletrasporto.

Il rapporto è [results/transport-verification.json](results/transport-verification.json). Le osservazioni originali sono in `test/fixtures/transport-reference.json`; vengono lette esclusivamente dalle prove. Il gioco continua a essere interamente JavaScript e genera i propri ingressi casuali.

## Cosa impediva di proseguire

**Lestrade alla stazione di arrivo.** La regola E4B0, quando l’entità ha il bit 6 degli attributi, prende la prima direzione della stanza di partenza. CA76 annuncia l’azione prima che E49B trasferisca il personaggio. Quando Holmes rimane nel treno a Leatherhead, Lestrade scende e successivamente viene stampato `Inspector Lestrade goes south.` Il vecchio host rifiutava questa notifica visibile e ripristinava l’intero WAIT: ecco perché il tempo sembrava fermarsi.

La correzione riguarda anche le notifiche CAAF/CBC2: viene annunciata l’entità esterna che arriva, per esempio `A steam train enters.` Il testo della scena deve includere gli oggetti trasportati dai compagni di viaggio. L’ordine fra trasferimento, azzeramento del flag di visita E4F6 e stampa CA9E è stato corretto: una visita successiva alla stessa banchina usa la descrizione breve.

È stata conservata un’ulteriore anomalia di CBEA–CBFF: una notifica di arrivo non percepibile lascia selezionato Holmes. D026 può quindi riscrivere gli argomenti della riga principale del personaggio ancora sospeso. La prova con entrambi i treni la osserva sul secondo treno al tick 84; non basta confrontare la sola posizione del treno visibile.

**Corsa dopo LOOK o chiarimento.** Le invalidazioni eliminavano anche residui di stampa ancora validi. Un’estrazione successiva che leggeva $5D00 causava l’annullamento del comando. Le descrizioni ora annotano le operazioni logiche di elenco, nome e inventario, e la proiezione ricostruisce i campi posseduti dai glifi, dalle interruzioni di riga e dalla profondità dei richiami del testo.

Le operazioni rilevanti sono C388/C38B, C39C/C39D/C3B8 e C316/C374. Il frame ricorsivo D526 cresce di sei byte per livello; l’ingresso di LOOK differisce da quello della notifica di movimento. La riga liberata dopo una parola che non entra e quella liberata dopo l’ultimo carattere della riga usano profondità diverse. Anche il delimitatore della parola rimasta nell’inventario può essere prodotto dal successivo frammento di descrizione: i CALL compressi modificano la profondità. Non viene installato un frame iniziale catturato.

Il byte $5CEE incontrato più avanti deriva invece dalla coda del nome file inizializzato a spazi dalla ROM 0616–062B. La posizione viene ricavata dalla lunghezza del programma BASIC sul TAP, dalla fine delle variabili e dalla riga iniziale `LOAD ""`; il calcolatore di USR sovrascrive i primi cinque byte dell’area. La proiezione conserva soltanto i campi di provenienza ricostruita. La stampa può successivamente sostituirli.

Il chiarimento di un solo oggetto conserva questi campi di stampa; la validità delle allocazioni del parser rimane separata. Non è stata eliminata la protezione sulle letture di record ancora sconosciute.

## Le destinazioni richieste

```text
SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"
SAY TO CABBIE "GO TO CAMDEN STREET"
SAY TO CABBIE "GO TO KINGS CROSS ROAD"
```

`GO TO KINGS CROSS` viene ignorato anche dall’originale in questa situazione. Il riferimento nominale corrisponde a più stanze; B191 fallisce e B9B4/B9AC scarta la richiesta all’NPC senza aprire un chiarimento con Holmes. Il programma del cocchiere continua e può chiedere se si vuole andare da qualche parte. È stato ricostruito questo comportamento generale di risoluzione fallita, senza attribuire una destinazione arbitraria alla forma abbreviata.

## Prove

Le sei sequenze coprono Buckingham Palace Road, Camden Street, la richiesta ambigua, una corsa preceduta da LOOK, una corsa preceduta da `OPEN DOOR` → `YOUR` e un percorso completo in cab e treno fino alle **10:49**. Sono 111 comandi, 917 estrazioni e 1.974 letture casuali.

Per ogni estrazione si confrontano ordine, attore, ampiezza, contesto, accumulatore/cursore iniziali, tutti gli indirizzi e valori letti, risultato e stato successivo. A ogni comando si confrontano orologio, tutti i 106 flag delle stanze, 110 record di entità, programmi/argomenti/scadenze dei 24 attori e liste di contatori, contesti e segnali con i loro puntatori. I campi di stampa di cui il modello rivendica la proprietà sono controllati anche quando non vengono letti dal generatore in quel comando.

L’hash della bitmap superiore è confrontato esattamente dopo ogni comando; non viene normalizzato per nascondere differenze nel testo. Le righe prodotte dai pacchetti della sessione web devono inoltre coincidere con la proiezione del motore. Questo non certifica ogni pacchetto di controllo o la cronologia grafica degli errori nell’area inferiore.

Una prova salva la partita a bordo e confronta i due rami, continuo e ricaricato, fino alla discesa e al movimento successivo, compresi i fotogrammi di ciascun minuto. Un’altra prova verifica che un limite del prototipo rimanga visibile dopo l’ultimo fotogramma vuoto dell’animazione. Quattro sostituzioni controllate del nome di Watson verificano che i residui cambino secondo i glifi e il layout.

```sh
node --test test/transport.test.mjs
node --test test/*.test.mjs
```

La suite completa conta **294 prove superate**. Il confronto sull’originale si rigenera offline con:

```sh
/opt/homebrew/bin/python3 tools/probe-transport-regressions.py --watch --output test/fixtures/transport-reference.json
```

`tools/probe-render-residue.py` raccoglie la provenienza dei campi di stampa e della modifica degli argomenti del secondo treno. Questi strumenti richiedono il progetto originale; il runtime e le prove JS usano solo Node e i dati già estratti.

## Pagina e salvataggi

La pagina corretta è sulla porta **8768**. Il server è statico e distribuisce i file aggiornati senza riavvio. Ricarica la pagina e usa **Riavvia** per riprovare da uno stato iniziale ricostruito con questa versione; salva prima la vecchia partita se desideri conservarla. Non è stato modificato lo stato della scheda aperta.

I nuovi salvataggi conservano i campi aggiuntivi nello stato della proiezione. I salvataggi precedenti restano caricabili con il loro stato: non viene ricostruita arbitrariamente una precedente successione casuale già divergente. Le verifiche qui dichiarate riguardano le nuove sequenze e i salvataggi da esse prodotti.

Restano limiti espliciti in altre dipendenze casuali, allocazioni del parser, informazioni, deduzioni, eventi e finali. **L’equivalenza dell’intero gioco e la parità per qualsiasi seed e cronologia non sono ancora certificate.**
