# Fase 3 — ordini di Watson e seguito funzionale

23 ottobre 2026. Questo è un ulteriore blocco della riscrittura, **non il completamento del gioco né dell’AI di Watson**. Il browser esegue soltanto funzioni JavaScript su entità logiche. Il vecchio motore resta separato sulla porta 8766.

## Cosa provare

Ricaricare la pagina sulla porta 8768 e premere **Riavvia**. Le vecchie partite JS restano caricabili ma mantengono gli NPC disabilitati: non inseriamo a metà partita un programma con contatori inventati.

```text
SAY TO WATSON "TAKE LAMP"
SAY TO WATSON "DROP DAILY CHRONICLE"
OPEN YOUR DOOR
WEST
DOWN
OPEN FRONT DOOR
SOUTH
```

Watson prende la lampada, lascia il giornale nella poltrona, interrompe la lettura ed esce dalla poltrona; segue Holmes nelle stanze adiacenti, portando con sé la lampada. La sua posizione sulla mappa si aggiorna con lo stato del mondo, anche nei passaggi al minuto delle attese.

Un altro percorso è `SAY TO WATSON "FOLLOW ME"`, poi apertura della porta e WEST. Sono disponibili anche ordini multipli, `SAY TO WATSON "OPEN ALL DOORS"` e WAIT rivolto a Watson. Un ordine non è eseguito immediatamente dal parser: viene accodato e attende la scadenza di Watson. Le azioni positive rimandano la prosecuzione della lettura. Un ordine riconosciuto ma impossibile può fallire senza stampare un errore nella zona di Holmes, come nell’originale.

Per Holmes e Watson sono state aggiunte le regole ordinarie dei contenitori: CLIMB INTO / OUT OF, GET INTO / OUT OF, SIT IN. Le prove riguardano le poltrone; non certificano tutte le regole dei veicoli, delle capacità e dei contenitori dinamici.

## Inizializzazione: limite deliberato

Il programma di Watson parte dal **primo prompt storico già documentato**, con il contatore privato di lettura a 15. Il dato è confermato nella lista originale: attore 3, valore 15. La scadenza è 0 nel profilo gratuito, 1 in quello con calendario 08:01. Il saluto iniziale resta la presentazione separata già tradotta.

Questo profilo non esegue la nuova partita originale con un seed scelto. Un avvio reale con seed 1 può inizializzare un contatore diverso, per esempio 16. Il campo seed resta perciò disabilitato. Nessuna tabella di replay, immagine RAM o istruzione Z80 è caricata dal runtime per decidere le azioni.

Quando il primo contatore termina, viene eseguito il prefisso compreso del ramo: se Holmes è presente, Watson annuncia il caso. Prima di dover generare il **secondo contatore casuale**, il programma viene sospeso con un avviso esterno alla narrazione. Non sostituiamo l’estrazione con `Math.random`, un valore fisso o il risultato di una traccia. Il profilo, la sospensione e la sua causa rimangono visibili nello stato e nei salvataggi.

Per completare quel ramo servono gli ingressi della casualità e le callback degli incontri. Non sono ancora ricostruiti il ramo della nota e della partenza, le conoscenze, le accuse, le risposte informative o i saluti successivi. Nuovi ordini durante un FOLLOW differito ancora attivo sono segnalati come non tradotti: il filtro delle richieste dipende dal punto di ripresa, non basta accettarli indiscriminatamente. Anche HELLO può raggiungere un testo con scelta casuale e resta non tradotto.

## Dal codice alle funzioni di dominio

| Fonte originale | Comportamento ricostruito | Implementazione |
|---|---|---|
| DD9E, B86A–B934 | Citazione rivolta a un attore percepibile; creazione della richiesta | `Game.execute`, `scheduler.sendRequest` |
| B91F–BA13, CC37–CCAE | Scelta della richiesta al turno dell’attore; prosecuzione dopo un’azione con costo | `Watson.driver`, stato `orders` e indice logico |
| E79F–E7B5 | Controllo stanza 8, possesso/percezione del giornale, decremento del contatore, attesa di costo 1 | Fase `reading` di `Watson.step` |
| E7B6–E7E1 | Interruzione della lettura e seguito dinamico di Holmes | Fase `following` |
| E452–E487 | FOLLOW differito, contatore 10 senza estrazione, tentativo di uscita diretta, contenitori, ritorno | Stato `follow`, con fasi nominate |
| DD52–DD83 | Cerca un’uscita direttamente collegata alla stanza del bersaglio, quindi esegue la direzione | `Watson.follow` e azioni comuni |
| E5FD–E618, C863–C897 | Confronta le radici attraversate nel contenimento | `Watson.root` |
| E40A–E44B | Entra/esce dal contenitore; conserva il genitore esterno all’uscita | Regole `enterContainer`, `leaveContainer` |
| E742–E74A | Annuncio del caso, seguito da creazione del secondo contatore | Testo tradotto; sospensione prima dell’estrazione non compresa |

Questi indirizzi sono riferimenti di ricerca: **non selezionano funzioni da eseguire nel motore**. Non viene interpretato il bytecode originale. La macchina a stati usa nomi come `reading`, `following`, `attempt`, `wait`, `decrement`, `complete`; richieste e salvataggi contengono comandi logici.

FOLLOW esplicito e seguito dopo interruzione della lettura sono due stati diversi. Il primo conserva il contatore precedente e può tornare al programma sospeso; un movimento riuscito completa quel tentativo. Il successivo controllo della lettura può passare al seguito autonomo. Il codice non cerca percorsi generali attraverso il grafo e non teletrasporta Watson: prova soltanto un’uscita adiacente, poi i contenitori.

## Regole condivise e messaggi

Le azioni non sono duplicate in un secondo interprete: il risolutore e l’esecutore ricevono il contesto dell’attore. TAKE di Watson consulta il suo possesso, la sua percezione e la sua capacità; DROP colloca l’oggetto nel suo contenitore attuale. La narrazione usa il soggetto e la forma del verbo corretti. Un movimento NPC produce `Watson leaves.` o `Watson enters.` soltanto quando Holmes può osservarlo.

L’ambiguità interna a una richiesta non sostituisce la domanda di chiarimento del giocatore. Gli errori semantici dell’ordine non vengono stampati come errori dell’input di Holmes. Le funzioni non tradotte continuano invece a produrre un avviso del prototipo, fuori dal testo originale.

Il parser delle citazioni ora riconosce anche un soggetto composto soltanto da qualificatori, come BASIL. Questo permette di classificare correttamente l’asserzione `BASIL KILLED MRS BROWN`; non ne implementa la memoria o la risposta.

## Minuti, interruzione e salvataggi

Ogni passaggio al minuto conserva lo stato logico corrispondente e il punto raggiunto nei messaggi. Il browser aggiorna orologio e segnaposti da quel fotogramma; i testi degli NPC vengono rilasciati solo quando quel minuto è raggiunto.

Interrompere WAIT UNTIL ripristina **entità, contenitori, scadenze, contatori, richieste e stato del programma** al minuto mostrato. Non basta cambiare l’ora lasciando gli effetti futuri. La nuova prova accoda TAKE mentre Watson sta aspettando, interrompe prima della sua scadenza e verifica che la lampada sia ancora sul pavimento e che l’ordine sia ancora pendente. SAVE/LOAD conserva la stessa prosecuzione.

Il formato `sherlock-js-save` è ora alla versione 3. Conserva il programma di Watson, il suo contatore, il FOLLOW sospeso, le richieste e il cursore di ALL. Le versioni 1 e 2 restano caricabili mantenendo la precedente assenza di AI; non vengono trasformate in una nuova partita. L’AI e la casualità del vecchio motore Z80 non sono importabili in questo formato.

## Prove e loro ambito

Il banco offline `tools/probe-watson-reference.py` usa il motore originale solo per produrre fixture di confronto. Parte dal prompt storico, applica il profilo gratuito e abilita soltanto Watson. Gli altri attori sono disabilitati dopo il prompt; il seed viene impostato dopo l’avvio. Non è una prova di equivalenza del bootstrap o del seed.

Sono catturate 13 sequenze / 48 comandi. Il test confronta integralmente **11 sequenze / 43 comandi**: testo normalizzato, clock completo, scadenza di Watson, contatori e campi genitore/stanze/attributi di sette entità selezionate. Le sequenze comprendono richieste riuscite e impossibili, ALL, ordini multipli, WAIT, FOLLOW, timeout del FOLLOW, seguito dopo DROP, contenitori e destinatario non più percepibile.

La sequenza al confine casuale confronta inoltre il prefisso narrativo dei primi tre WAIT, compreso l’annuncio del caso; non confronta gli effetti successivi alla nuova estrazione. HELLO è conservato come traccia di una funzione ancora mancante e non viene contato fra i confronti integrali.

Altre prove verificano SAVE/LOAD durante WAIT ordinato, ALL e FOLLOW, errori senza turni, esecuzione differita degli ordini, ripristino completo su interruzione, assenza di testo futuro e ispezione dei fotogrammi senza modificare il mondo. Le prove precedenti di azioni isolate specificano ora `npcs:false`, conservando il loro ambito originario.

```sh
node --test --test-reporter=tap test/*.test.mjs
python3 -B tools/probe-watson-reference.py --project "/percorso/Sherlock rebuild" --output test/fixtures/watson-reference.json
```

Il banco Python richiede le analisi e SkoolKit già presenti nel progetto. Il gioco e i test Node sui risultati congelati non li richiedono. Rapporti: `results/phase3-verification.json`, `results/tests.tap`; fixture: `test/fixtures/watson-reference.json`.

## Prossimo blocco

Completare inizializzazione e sorgente casuale funzionale, quindi secondo contatore, nota/partenza e callback di Watson. Su queste basi collegare Lestrade, cab e treni. Le loro vecchie prove Z80 restano fonti di confronto, non una dimostrazione che siano già tradotti in JavaScript.

Verifica della pagina: ordini e seguito da input ordinario, ripresa della scheda dopo TAKE e movimento da input Spectrum. La schermata finale mostra `Watson enters.`, Holmes e Watson nella stanza 6, con orologio 08:11am e selettore del motore abilitato. Prove: `results/watson-browser.json` e `results/watson-browser.png`. Il server del riferimento sulla porta 8766 non è stato riavviato.

## Aggiornamento successivo: saluti e chiamata del cab

Il limite relativo a HELLO descritto sopra è stato ristretto: il saluto è eseguibile e può essere differito durante FOLLOW, ma la sua scelta casuale resta mancante. Sono disponibili anche arrivo del cab e salita/discesa; viaggio e pagamento restano sospesi. [SALUTI-E-CAB.md](SALUTI-E-CAB.md) registra le nuove prove e il loro ambito.
