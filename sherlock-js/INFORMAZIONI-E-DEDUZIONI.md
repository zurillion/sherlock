# Informazioni, memoria e deduzioni

26 ottobre 2026. Motore autonomo JavaScript, profilo world-v5.

## Come provarle

Usare SAY con un’affermazione tra virgolette, quando il personaggio è presente:

```text
SAY TO WATSON "BASIL HAS PLANS"
SAY TO LESTRADE "BASIL HAS PLANS"
SAY TO LESTRADE "MAJOR FFOULKES IS INNOCENT"
```

La risposta dipende dalle informazioni e dallo stato casuale. Un complimento
di Watson non certifica che l’affermazione sia vera: è proprio il comportamento
dell’originale. TELL ME ABOUT continua invece a usare la tabella dei colloqui,
che è distinta dalla memoria delle affermazioni.

Dopo l’aggiornamento salvare la partita, ricaricare la pagina e riprendere:
non serve riavviare il server. I record di memoria, i flag delle prove,
le entità modificate e la casualità fanno parte del salvataggio.

## Strutture del gioco originale

- **Predicati:** gli undici riferimenti lessicali a 994D: blackmail, had, has,
  is, killed, visit, hated, examined, hid, owns, made.
- **Ipotesi e prove:** undici alberi dati tra 9965 e 99FA; FF a 99FB è
  il terminatore. Ogni atomo contiene soggetto, predicato, oggetto e flag.
  I nodi con flag 10/20 esadecimali hanno anche due byte di gestore.
- **Memoria di Watson:** lista a 9FF4, con record di cinque byte nella stessa
  arena usata da richieste, contesti e sintassi. I primi tre sono la tripla.
- **Contesti HE/IT:** sei byte ciascuno a 9FF6 e 9FFC. BE22 copia i primi
  sei byte del record dell’entità: la ricostruzione conserva anche questa
  particolarità dell’originale, senza trasformarla in un pronome più intelligente.

Per i flag delle prove: bit 0 indica un’ipotesi attiva; bit 1 una condizione
acquisita; bit 2 introduce un gruppo di condizioni; bit 3 delimita il gruppo.
I bit alti distinguono condizioni di osservazione, esame e ipotesi. Le
condizioni ordinarie consultano i bit 7 e 6 di stato delle entità, alimentati
dalle routine di descrizione, inventario ed esame. Una premessa già acquisita
non viene nuovamente dedotta dalla posizione corrente dell’oggetto.

## Watson

BA20 invia a BA67 le affermazioni rivolte a Watson. BD7E risolve globalmente
i riferimenti, distinguendo nessuna corrispondenza da più corrispondenze.
Il secondo caso produce il WHAT originale. La tabella speciale a 9A7D è
vuota in questa edizione: contiene subito FF.

Watson riconosce le triple della tabella delle ipotesi e applica i test
originali agli altri casi, usando il generatore condiviso. Ricordare una
tripla nuova la inserisce in testa; ripeterla sposta in testa il record
esistente, senza riallocarlo. Anche il diverso contesto della successiva
estrazione casuale è conservato. Il primo elemento accettato conclude
l’esame dell’affermazione: gli altri nodi della richiesta sono scartati.

BD06 cerca relazioni con i ricordi precedenti e può domandare se esista un
collegamento tra le altre due entità. E691 è il richiamo spontaneo dei
ricordi: dopo il primo test, il secondo valore deve essere esattamente 1
per raggiungere il primo record. Il DJNZ non scorre uniformemente tutti
i ricordi. Non è stato sostituito da una scelta casuale più plausibile.

Ascoltare un’affermazione lascia il costo locale a zero e restituisce il
controllo al programma sospeso dell’NPC. Per esempio Watson continua la
lettura e decrementa il relativo contatore nello stesso turno.

## Lestrade

BB67 riconosce le ipotesi della tabella e BCC9 valuta i relativi alberi.
BC46 visita in ordine inverso le voci indicate dal codice; BC9C conta le
conclusioni provate e BC74 quelle ancora aperte. Lo stesso valutatore è
richiamato quando Lestrade incontra Holmes: può tornare a chiedere una prova.

I messaggi 7243–72E1 distinguono riferimenti ambigui, affermazioni non utili,
prove mancanti e conclusioni accettate o respinte. I gestori 99FC–9A7C
aggiornano anche lo stato: acquisizione di altre premesse, nuova fase
dell’indagine e allontanamento di Mrs Jones. Restano le risposte peculiari
dell’originale, compresa l’eventuale ripetizione del prefisso del parlante.

Nel caso dei piani attribuiti a Basil, l’accettazione completa richiede
anche i flag delle altre due conclusioni previsti da 9A13. La prova
controllata esercita sia quel ramo sia il rinvio con prove insufficienti.

## Implementazione e verifica

`src/information.mjs` contiene ricerca delle triple, memoria, attraversamento
dei gruppi, prove, risposte e conseguenze. `NpcRuntime` lo collega alle
richieste e alle callback; `Text` rende nomi e relazioni come operazioni
semantiche. Non esegue il binario e non riproduce una sequenza registrata.

`tools/probe-information.py` e `tools/probe-deduction-evaluator.py` usano
l’originale soltanto offline. La prima fixture contiene 24 scenari: colloqui
con Watson, ripetizioni e collegamenti, 16 colloqui con Lestrade in assetto
controllato, il prefisso naturale di 98 comandi fornito dall’utente, un
ramo con le due conclusioni precedenti acquisite e affermazioni coordinate.
Le prove controllate non vengono presentate come percorsi raggiunti giocando.

Per ogni comando del seguito si confrontano tutte le estrazioni e letture
casuali, le scadenze e i programmi degli attori, tutte le entità, i fatti,
i 752 byte dell’arena, le liste della memoria, HE/IT, i buffer e le bitmap
esatte superiore e inferiore. Il salvataggio/caricamento deve produrre
lo stesso seguito. Le 88 prove isolate confrontano il valutatore con
combinazioni di osservazione, esame e premesse già note.

Il listing `results/information/information.asm` distingue codice, alberi e
campi temporanei; 647 istruzioni e 1.711 byte sono stati riassemblati.
La prova nel browser verifica SAY a Watson nella pagina effettivamente servita.

## Limiti dichiarati

Il corpus certifica il protocollo esplicito: seed 1, tutti i 24 slot attori,
LOOK iniziale gratuito, grafica disattivata dopo l’avvio, tasti iniettati e
MORE immediato. Non certifica tutte le partite, gli altri seed o l’entropia
delle immagini originali. Le citazioni che mescolano ordini e affermazioni
restano esplicite come non implementate; non vengono interpretate per analogia.

Le nuove chiamate di Lestrade attraversano frame AF/BC non posseduti dalla
proiezione ordinaria dei glifi. Al ritorno viene revocata la proprietà dei
campi temporanei del renderer anziché conservare byte precedenti falsi.
Un futuro ingresso casuale da un campo ancora non ricostruito rimane un
limite esplicito. Le letture effettive del corpus sono invece confrontate.

Questo integra il nucleo del punto 2. Le conseguenze complete della partita,
i rami avanzati degli NPC e l’ampliamento della copertura restano ai punti
3, 5 e 7 della lista; non sono implicitamente certificati da questi colloqui.

Risultato finale: 387 test superati. Il corpus nuovo confronta 74 comandi
di seguito, 599 estrazioni e 1.210 letture della sorgente casuale, oltre
al prefisso naturale. Rapporto: `results/information-verification.json`.


Aggiornamento 27 ottobre: vedere [ALTRI-FINALI.md](ALTRI-FINALI.md) e
`results/other-endings-verification.json`. Confrontati due percorsi naturali
fino alla cassaforte (stesso finale 759C); corretti la ricerca delle premesse
annidate e il rifiuto originale degli ordini di movimento a Basil impegnato.
Le altre sei varianti terminali restano da certificare con storie naturali.
