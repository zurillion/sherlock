# Programmi dei personaggi nella pagina: NPC v5

24 ottobre 2026. Il nuovo profilo avvia tutti i 24 posti della tabella degli attori: Holmes e 23 programmi di personaggi, veicoli e treni. È una ricostruzione autonoma ancora parziale. Non è una certificazione dell’intera partita. Le successive correzioni di cab, notifiche e viaggio come passeggero sono documentate in [TRASPORTI.md](TRASPORTI.md), con confronti fino alle 10:49 e salvataggio a bordo.

## Attivazione

L’aggiornamento del 25 ottobre corregge anche il percorso saluto → lettura → FOLLOW → chiarimento della porta → cab: [WATSON-E-CAB.md](WATSON-E-CAB.md). I nuovi confronti verificano tutti i byte dell’area dei record e il salvataggio durante `WHICH DOOR ?`.

Ricarica la pagina sulla porta **8768** e premi **Riavvia**. La nota del motore deve iniziare con **NPC v5**. Una sessione già aperta o un salvataggio v4 mantiene il vecchio esecutore di Watson; non viene convertito di nascosto. Salvalo prima di riavviare se vuoi conservarlo.

**Seed iniziale**, da 0 a 255, ora è utilizzabile. Il valore viene applicato al prossimo Riavvia; l’accumulatore corrente continua a cambiare durante la partita. Salva/Carica v5 conserva anche programmi, scadenze, segnali, richieste, contesti, allocatore e ingressi casuali generati.

## Cosa provare

Una corsa partendo dalla stanza iniziale:

```text
OPEN YOUR DOOR
WEST
DOWN
OPEN FRONT DOOR
SOUTH
HAIL CAB
GET INTO CAB
SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"
WAIT
WAIT
WAIT
GET OUT OF CAB
PAY 1/- TO CABBIE
```

Questa sequenza è verificata con seed 1 e avvio gratuito alle 08:00. Le tre attese sono una sequenza di prova; non sono un tempo universale della corsa. Il cocchiere gestisce richiesta, viaggio, conto, protesta e resto attraverso il proprio programma. Anche `TAKE ME TO BUCKINGHAM PALACE ROAD` raggiunge il percorso differito corrispondente; il corpus completo qui descritto usa GO TO.

Gli ordini sono riconosciuti dal parser e dai riferimenti nominali delle stanze: non tramite una ricerca di frasi nel testo digitato. Il cocchiere li esegue quando arriva il proprio turno. Lestrade può occupare autonomamente l’altro cab.

Per Watson:

```text
SAY TO WATSON "HELLO"
SAY TO WATSON "FOLLOW ME"
OPEN YOUR DOOR
WEST
DOWN
SAY TO WATSON "HELLO"
```

Lestrade lascia Scotland Yard, raggiunge Parliament Street, chiama un cab, ordina Kings Cross Road, prende il treno e prosegue verso Leatherhead. La prova lunga lo segue fino all’incontro con Straker e alle prime ispezioni: i loro programmi si sincronizzano mediante segnali, senza un copione JS del tipo «al minuto X stampa Y».

Al cancello dei Brown, il poliziotto avverte i personaggi percepiti al proprio turno. HELLO senza citazione è un’azione di costo zero: da solo non provoca un nuovo turno. Dopo un LOOK o WAIT viene eseguita la callback dell’incontro. Il blocco del passaggio viene rimosso dal percorso che fa incontrare Holmes, Lestrade e Straker.

## Architettura e provenienza

- `npc-program.mjs` interpreta il linguaggio di dominio del gioco: azioni, condizioni, richieste, segnali, testo, salti e ritorni differiti. Il catalogo contiene 791 nodi e 70 contratti di regole. Nessun nodo esegue un’istruzione CPU.
- `npc-runtime.mjs` collega i programmi al mondo JS, alla risoluzione degli argomenti, alle callback e al generatore condiviso. I corpi delle regole comprese sono funzioni di dominio; quelli mancanti generano un avviso esplicito.
- `record-arena.mjs` ricostruisce il deposito di record di 752 byte, le liste e le anomalie dell’allocatore. Le citazioni usano nodi sintattici di 30 byte e richieste di 8; segnali e contatori usano record di 2.
- `world-source.mjs` proietta record di stanze e oggetti dallo stato logico. L’host proietta anche righe degli attori, contesti, contatori, calendario e alcuni campi di lavoro.
- `random-display.mjs` genera lo schermo canonico e i buffer conosciuti. Il suffisso non scritto dell’input deriva dalla copia del loader TAP e dal suo ultimo header. I campi posseduti dalla stampa vengono calcolati da glifi, layout, liste ricorsive e richiami del testo, anche per LOOK e scene durante il viaggio. Una parte del workspace ROM deriva dalle operazioni del bootstrap BASIC. Le celle prive di provenienza ricostruita restano indisponibili; EXAMINE e percorsi del parser ancora sconosciuti mantengono le invalidazioni. Si vedano `probe-bootstrap-scratch.py` e [TRASPORTI.md](TRASPORTI.md).

I valori immutabili di ROM, codice e dati consultati dal generatore originale restano ingressi numerici. Il runtime non esegue Z80, non chiama Python, non contatta il vecchio motore e non legge le registrazioni delle prove. Gli indirizzi nei cataloghi indicano provenienza e identità dei record.

Sono state mantenute anche due anomalie del sorgente: il ripristino dal predecessore della lista dei contesti e il cambio di proprietario di una continuazione del cab quando una notifica lascia l’attore corrente impostato a Holmes. La seconda emerge quando entrambi i cab si trovano nella locazione di transito. Non è un comportamento aggiunto per rendere plausibile una corsa.

L’EXAMINE di un NPC differisce da quello di Holmes: il corpo DF49 ritorna al controllo DC6C, prima di impostare il bit di esame. La notifica dell’azione e il costo rimangono. Questo è stato verificato anche isolando l’esame del cadavere da parte di Lestrade.

## Verifiche e confini

Il rapporto riproducibile è `results/world-npc-verification.json`; le prove sono in `test/world-npc.test.mjs`. Il riferimento offline parte da un vero bootstrap con il seed applicato ad A061, tutti gli attori attivi e LOOK iniziale gratuito. Usa tasti maiuscoli iniettati, senza timeout dell’editor, e disabilita la grafica nativa dopo il primo prompt. Il profilo tastiera conserva i metadati ROM del RETURN usato per avviare il nastro, già rilasciato. Non certifica qualsiasi temporizzazione di una tastiera fisica.

Ogni estrazione viene confrontata per attore, ampiezza, contesto, stato iniziale, tutte le letture, risultato e stato successivo. Gli ingressi della fixture **non** vengono forniti al runtime. Le prove confrontano inoltre calendario, PC/argomenti/scadenze di tutti gli attori, genitori/locazioni/attributi/stato dei 110 oggetti e contenuto/puntatori delle liste di contatori, segnali e contesti.

Per gli scenari senza teletrasporto si confronta anche l’hash esatto della bitmap superiore. Tutti gli scenari controllano le righe prodotte dai pacchetti della sessione web. Il confronto delle frasi conserva il caso ma normalizza spazi e padding delle virgolette: da solo ha un ambito più ristretto dell’IO completo.

**Differenza nota dell’estensione mappa:** il helper Python `NativeWorld.teleport` chiama prima un’azione e poi una seconda stampa della scena. Il testo della prima chiamata rimane nella sua bitmap, pur essendo scartato dalla sua UI. Il teletrasporto JS mostra una sola scena breve. Le tre prove con questo intervento confrontano estrazioni e stato, ma non certificano la parità della bitmap originale. Una corsa raggiunta camminando da casa è verificata anche sulla bitmap, senza tale intervento.

Restano da completare:

- informazioni, affermazioni, deduzioni e reazioni legate alla conoscenza;
- regole/eventi avanzati e finali, comprese le reazioni serali e alcune notifiche visibili di ricollocazione non tradotte;
- l’intera proiezione di stack, stato di sistema e buffer; una lunga sequenza di soli WAIT oltre il tratto verificato raggiunge ancora celle non possedute;
- la durata esatta delle allocazioni in errori sintattici, ALL e frasi multiple. Il chiarimento singolo è ora ricostruito e mantiene la validità dei record nei percorsi verificati. I percorsi ancora sconosciuti marcano la sorgente non disponibile e interrompono le dipendenze da quei metadati;
- tutti i pacchetti di IO, le immagini nella sorgente casuale e il comportamento con tempi fisici diversi dell’input.

Un percorso mancante annulla il passo e i fotogrammi temporali speculativi e mostra un messaggio del prototipo fuori dal testo originale. Non viene sostituito con un messaggio inventato del personaggio. I salvataggi riprendono esattamente il futuro del modello implementato, senza trasformarlo in una ricostruzione completa.

## Riprodurre

```sh
# Nel progetto completo: il riferimento Z80 è usato soltanto offline.
python3 tools/probe-world-npcs.py --project .. --output test/fixtures/world-npc-reference.json

# Queste prove richiedono soltanto Node e la cartella sherlock-js.
node --test test/world-npc.test.mjs
node --test test/*.test.mjs
```
