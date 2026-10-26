# Verifica della cronologia effettiva dell’utente

26 ottobre 2026. Segue la correzione del terminatore descritta in
[BASIL-E-CONFINE-DEI-FATTI.md](BASIL-E-CONFINE-DEI-FATTI.md).

La cronologia ricevuta successivamente ha permesso di sostituire la sola
prova controllata con un confronto del percorso effettivamente giocato.
Il motore rimane JavaScript autonomo; l’eseguibile originale è usato solo
come oracolo offline. Nessuna sequenza di risposte viene letta dal gioco.

## Risultato e distinzione importante

Con seed 1 coincidono 115 comandi, dall’avvio alle 12:11, con tutti i 24 slot
attori attivi: i 105 comandi dell’utente precedenti il primo teletrasporto,
seguiti da dieci INVENTORY aggiuntivi. Le azioni che prima venivano annullate
ora vengono eseguite, quindi le ripetizioni fanno avanzare il tempo.
Sono confrontate tutte le 623 estrazioni e 1.316 letture casuali, non solo
le frasi o il seed iniziale.

**L’originale, in questa sequenza e con il protocollo dichiarato sotto, non
legge `$99FB`.** Il vecchio motore web arrivava a quella lettura dopo avere
generato ingressi casuali differenti in passaggi precedenti. Il terminatore
mancante era un difetto reale, ma aggiungerlo da solo non rendeva equivalente
questa partita. La prova precedente con cursore controllato resta valida
come verifica separata della dipendenza, non come certificato del percorso
casuale naturale dell’utente.

## Differenze funzionali ricostruite

- Esaurire ALL restituisce un fallimento della regola DOMAIN, anche se
  l’ultimo oggetto selezionato è stato aperto. Il contatore dei fallimenti
  include ora anche quell’ultima ricerca, prima del nuovo prompt.
- GET CHINA MAN, nel piccolo ripostiglio, usa la ricerca nelle descrizioni
  quando non c’è un bersaglio nominale percepibile. Il rifiuto originale è
  `I SEE NO CHINA MAN THAT YOU CAN GET`; il vecchio messaggio YOU CANNOT era
  diverso. Restano distinti i rifiuti del predicato per oggetti visibili.
- Entrare in un contenitore usa il predicato di ingombro DEE4, non la
  capacità residua in peso. D206 avanza prima di leggere la prima voce:
  gli scanner D305 saltano il record zero, anche nella ricorsione del peso.
  Questa particolarità consente a Watson di salire sul treno con Holmes,
  Lestrade e il travestimento trasportato, come nell’originale.
- GO THROUGH conserva l’identità del passaggio negli argomenti del giocatore;
  la porta non viene persa dopo avere eseguito il movimento.
- Sono ricostruiti i residui della stampa del cab, del suo nome usato come
  soggetto e dell’articolo nel nome del cocchiere. La stampa di Watson può
  sovrascrivere anche `$5CEC..$5CED`, prima erroneamente lasciati al residuo
  del caricatore. Questi valori sono prodotti dai glifi, non assegnati a zero
  perché lo richiede la prova.
- L’ultima parola dei passaggi o delle uscite rimane nel buffer fino
  all’introduzione dell’elenco degli oggetti. SEE e AND hanno i propri
  chiamanti. Quando lo spazio dopo il prefisso di un nome trasportato riempie
  la colonna finale, la pulizia della riga avviene dal chiamante dopo il
  ritorno della routine annidata. Un nome finale senza successiva frase sui
  possedimenti non viene invece stampato dal contesto di quella frase.

Il listing misto `results/fact-boundary/boundaries.asm` separa codice e dati;
705 byte sono stati riassemblati indipendentemente. Le osservazioni dello
stack e degli ultimi scrittori sono riassunte in
`results/fact-boundary/renderer-source-evidence.json`.

## Stato e salvataggi confrontati

A ogni comando si confrontano attori, PC, argomenti e scadenze, entità e
codifica del denaro, fatti, flag di tutte le stanze, arena completa di 752
byte, liste, editor, token, bitmap esatte dei due canali e tutti i campi del
renderer di cui il modello dichiara la proprietà. I pacchetti della pagina
ricostruiscono le stesse righe dello schermo.

Un ramo salvato alle 11:54, dopo il comando 98, viene caricato prima del
comando che si bloccava: ogni risposta e ogni stato futuro coincidono con
la prosecuzione senza caricamento. La cronologia integrale, compresi i due
teletrasporti finali, è eseguita anche nel solo JavaScript: non si blocca.
I teletrasporti sono un’estensione dell’interfaccia, esclusa dalla prova di
equivalenza con l’originale. Il conteggio delle azioni rifiutate resta parte
del confronto e non viene normalizzato.

Protocollo: LOOK iniziale gratuito, grafica disattivata dopo il primo prompt,
input maiuscolo iniettato, MORE immediato, nessun timeout da inattività.
Questo certifica il corpus dichiarato; non tutte le partite, i seed o le
temporizzazioni reali di tastiera, né la casualità con grafica nativa attiva.
La valutazione completa delle deduzioni resta ancora da implementare.

## Ripresa consigliata

Usare [sherlock-seed1-ripresa-1154.json](results/fact-boundary/sherlock-seed1-ripresa-1154.json):

1. Conservare, se desiderato, il proprio salvataggio precedente.
2. Ricaricare la pagina JavaScript sulla porta 8768.
3. Premere **Carica partita** e scegliere il file indicato.

Il file riproduce i primi 98 comandi reali, senza impostare a mano né seed
successore né cursore casuale. Si riparte nella sitting room 067 alle 11:54,
dopo l’alibi e prima del primo comando annullato. Contiene lo schermo, i
comandi e i messaggi ricostruiti. La presentazione salvata è testuale, con
immagini disattivate, come nel confronto; si possono riattivare dal controllo
della pagina. I tentativi annullati e i teletrasporti successivi restano
conservati nella cronologia originale allegata, ma non sono applicati alla
partita ricostruita prima del blocco.

Il vecchio salvataggio resta caricabile, ma conserva anche le scelte casuali
già alterate dal vecchio modello: caricarlo non può riscriverne automaticamente
il passato. Per questa ragione è preferibile la ricostruzione dalla cronologia.

Rigenerazione, dalla cartella sherlock-js:

```sh
node tools/rebuild-user-basil-save.mjs
node --test test/basil-user-history.test.mjs
```

Riferimenti riproducibili: `results/fact-boundary/user-history.txt`,
`results/fact-boundary/user-natural-inputs.txt`,
`test/fixtures/basil-user-reference.json` e
`results/basil-user-verification.json`. La fixture originale è ottenuta con
`python3 tools/probe-special-objects.py --history results/fact-boundary/user-natural-inputs.txt --output /tmp/basil-reference.json`;
la formattazione compatta del JSON non modifica alcun valore di confronto.
