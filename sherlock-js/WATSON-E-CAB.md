# Dal chiarimento della porta al cab con Watson

25 ottobre 2026. Regressione segnalata: la corsa funziona raggiungendo subito Baker Street con la mappa, ma viene annullata dopo saluto, lettura del giornale, FOLLOW e uscita a piedi con Watson.

## Causa

La combinazione riprodotta è `OPEN DOOR` → `YOUR`, seguita dall’ingresso nel cab con Watson e dalla richiesta `SAY TO CABBIE "GO TO KINGS CROSS ROAD"`.

Il parser JS conservava il comando da completare come oggetto logico, ma liberava subito il suo record di 30 byte nella proiezione dell’allocatore originale. Dopo il chiarimento marcava quindi l’intera sorgente dei record come non ricostruita. Quando Watson terminava un contesto del FOLLOW durante la nuova richiesta al cocchiere, il ripristino incontrava una lista di richieste non vuota e il controllo conservativo annullava il comando con:

```text
Funzione non ancora ricostruita in JavaScript:
metadati dei contesti dopo questo percorso del parser
```

La destinazione era riconosciuta. La mancanza riguardava l’interazione fra continuazione del parser e contesti degli NPC. I confronti precedenti coprivano il FOLLOW e una corsa dopo chiarimento in sequenze separate; questa combinazione non era verificata. Il teletrasporto immediato non percorre il chiarimento della porta e non crea il contesto sospeso del FOLLOW.

## Ricostruzione dal sorgente

- **B5B6–B5D2:** la domanda sposta il primo nodo dalla lista dei comandi analizzati `$9FF2` a quella pendente `$9FF0` e lo mantiene allocato.
- **AE6A e AD6C–ADD3:** la risposta viene aggiunta alla lista. Se non contiene un verbo, i suoi campi vengono fusi nel nodo conservato e viene liberato soltanto il nodo temporaneo della risposta. Un nuovo verbo sostituisce il nodo precedente.
- **D83B–D848:** il nodo risultante viene liberato dopo la risoluzione semantica, prima dell’esecuzione dell’azione.
- **B973/B976 e B9D4/B9D7:** una richiesta NPC conserva l’iteratore finale della ricerca nominale e aggiorna il puntatore al nodo sintattico successivo, anche quando questo diventa zero. La memoria liberata mantiene quei valori e può essere consultata in seguito.

La proiezione ora segue questa durata. Il controllo di affidabilità non è stato semplicemente rimosso: rimane per percorsi ancora sconosciuti, fra cui ALL, errori sintattici e unità multiple. Il precontrollo che decide se conservare il nodo usa gli stessi candidati semantici di `resolve()` e non esegue azioni o estrazioni.

La durata del nodo viene salvata insieme al suo puntatore. Un comando respinto dal prototipo durante il chiarimento ripristina sia il contesto logico sia il record; il salvataggio resta caricabile. I salvataggi precedenti privi di questa durata non ricevono dati inventati né vengono marcati retroattivamente come equivalenti all’originale.

## Stampa e ingressi casuali

Il confronto ha trovato anche una differenza successiva, durante il WAIT in viaggio: la scena con Watson e il cocchiere sostituiva `$5D00` e altri campi di lavoro, mentre il modello conservava valori della descrizione iniziale.

La stampa originale è differita per parole. Il nome finale dell’elenco dei passeggeri può essere stampato soltanto quando la successiva frase sull’inventario introduce il suo delimitatore. Lo stesso accade per l’articolo degli oggetti trasportati, per esempio `the daily chronicle`; se quell’articolo non entra nella riga, la pulizia della nuova riga sovrascrive altri campi. La stampa alla partenza del cab entra inoltre con una profondità diversa da quella della notifica di movimento del treno.

Questi valori sono ora calcolati dalle operazioni di testo, dai glifi, dal layout e dalla provenienza della scena. Non sono copiati dalle osservazioni. Il generatore casuale, le alternative dei dialoghi e i programmi degli NPC continuano a usare l’algoritmo condiviso ricostruito.

## Sequenze verificate

Avvio con seed 1, poi:

```text
SAY TO WATSON "HELLO"
WAIT
WAIT
WAIT
SAY TO WATSON "FOLLOW ME"
OPEN DOOR
YOUR
WEST
DOWN
OPEN DOOR
SOUTH
HAIL CAB
GET INTO CAB
SAY TO CABBIE "GO TO KINGS CROSS ROAD"
WAIT
WAIT
WAIT
WAIT
GET OUT OF CAB
PAY 1/- TO CABBIE
WAIT
```

Le quattro sequenze del corpus coprono questo percorso, il controllo con porte specificate direttamente, una lettura più lunga con sei WAIT iniziali e il percorso con seed 42. Tutti i 24 attori sono attivi, il LOOK iniziale è gratuito, la grafica nativa è disabilitata dopo il primo prompt, i tasti sono iniettati in maiuscolo, il MORE è immediato e non ci sono timeout della tastiera. Non viene usato il teletrasporto.

Sono **86 comandi, 627 estrazioni e 1.342 letture casuali**. Per ogni comando vengono confrontati:

- ogni estrazione, tutti i suoi ingressi e lo stato casuale successivo;
- orologio, programmi/argomenti/scadenze dei 24 attori, 110 entità e 106 flag di stanze;
- liste e puntatori di contatori, contesti, segnali, richieste e nodo pendente;
- **tutti i 752 byte dell’area dei record**, compresi i byte liberati, e la testa della lista libera;
- hash esatto della bitmap superiore, messaggi di chiarimento e righe dei pacchetti della sessione web;
- campi di stampa di cui il modello rivendica la proprietà, anche quando non sono letti in quel comando.

Una prova aggiuntiva salva mentre è aperta `WHICH DOOR ?`, carica in una nuova sessione e confronta il futuro fino al pagamento, compresi i fotogrammi di ogni minuto.

Le osservazioni originali sono in `test/fixtures/follow-cab-reference.json`, il rapporto in `results/follow-cab-verification.json`, le prove in `test/follow-cab.test.mjs`. La suite completa conta **301 prove superate**.

```sh
node --test test/follow-cab.test.mjs
node --test test/*.test.mjs
```

Rigenerazione offline dell’oracolo:

```sh
/opt/homebrew/bin/python3 tools/probe-follow-cab.py --events --render --output test/fixtures/follow-cab-reference.json
```

Le registrazioni non vengono fornite al motore durante il gioco. La ricostruzione resta autonoma e parziale; queste prove certificano le sequenze dichiarate, non l’intera partita o qualsiasi seed e cronologia.

## Pagina

La porta resta **8768**. Per provare la sequenza con lo stato iniziale corretto, ricarica la pagina e premi **Riavvia**, salvando prima la partita precedente se vuoi conservarla. Non è stato riavviato il server né azzerata la scheda aperta. Uno stato prodotto dalla vecchia proiezione incompleta mantiene i suoi limiti quando viene caricato.
