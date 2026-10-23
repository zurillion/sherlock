# Fase 2: selezione del motore, ALL e ciclo degli attori

## Scegliere quale implementazione provare

Il selettore **Motore**, sopra le altre opzioni, compare in entrambe le pagine:

- **Originale · Z80**: porta 8766. Esegue il programma originale nel ponte già esistente, con NPC, trasporti e storia.
- **Nuovo · JavaScript autonomo**: porta 8768. Esegue soltanto le regole già riscritte in JS e segnala le altre come mancanti.

La selezione cambia pagina esplicitamente; non c'è un ripiego automatico per un comando mancante. I due motori hanno partite e salvataggi distinti. Una partita non viene convertita nell'altra.

La partita originale rimane nella sessione RAM del server; tornando alla pagina viene mostrata la scena corrente. Da questa versione la partita JS viene conservata anche nella `sessionStorage` della scheda, con cronologia, domanda pendente, presentazione e mappa: si può passare all'originale e poi riprendere il nuovo motore. La chiusura della scheda o il riavvio del server originale possono perdere queste sessioni temporanee: per conservarle usare Salva partita.

Il selettore resta disponibile anche durante l'avvio, la stampa e il MORE. Se la stampa JS è incompleta, al ritorno viene ridisegnata l'ultima risposta conservando lo stato logico, senza rieseguire le azioni. I server locali devono essere entrambi avviati. Le porte rimangono quelle già usate dal progetto. Modificare le pagine non richiede di riavviare il server originale e non ne azzera le partite.

## ALL dopo una domanda

È verificato sul programma originale, con turni NPC esclusi:

```text
> OPEN DOOR
WHICH DOOR ?
> ALL
You open your door.
You open the plain door.
```

Il calendario passa dalle 08:00 alle 08:02. Non è una sola azione con costo raddoppiato: sono due esecuzioni distinte, in ordine di entità, ognuna seguita dal ciclo degli attori. EVERYTHING è un alias. Sono implementati anche OPEN ALL, CLOSE ALL, TAKE/CARRY/GET ALL, DROP ALL, GIVE ALL TO WATSON e l'esame generico di più oggetti.

Se una porta è già aperta, viene stampato l'errore e il comando prova comunque l'altra. L'errore non consuma tempo. I candidati vengono ricontrollati dopo ogni azione: spostare un contenitore o un oggetto può cambiare possesso e capacità per i successivi.

ALL da solo, senza una domanda o un verbo, continua a produrre WHAT ?. Non sono ancora tradotte tutte le combinazioni con due argomenti. BUT/EXCEPT rimane un limite esplicito: i primi esperimenti mostrano particolarità nell'elaborazione originale delle esclusioni e non giustificano l'aggiunta di un filtro moderno a intuito.

Le 20 sequenze congelate esercitate in `test/all.test.mjs` confrontano frasi, errori, tempo, locazione e, dove presenti, campi selezionati degli oggetti. Tre sequenze con esclusioni sono conservate come indizi ma non dichiarate supportate.

## Il nuovo scheduler

`src/scheduler.mjs` ricostruisce il ciclo funzionale:

1. Servizi pendenti prima di avanzare il calendario.
2. Incremento del tick e del minuto prima di scandire la tabella.
3. Ordine fisso dei 24 attori e confronto unsigned fra tick e scadenza.
4. Preparazione una sola volta per visita; più passi a costo zero sullo stesso attore.
5. Aggiornamento della scadenza precedente, sommando il costo a 16 bit.
6. Callback prima di passare all'attore successivo.
7. Input sospeso dentro il turno di Sherlock, conservando contesto e punto della scansione.

Il modulo fornisce anche code di richieste e segnali consumabili. Non interpreta istruzioni Z80. Le operazioni del programma di un personaggio saranno funzioni JS che restituiscono effetti, successo/fallimento e costo.

Il gioco usa ora questo ciclo per le azioni del giocatore, comprese quelle espanse da ALL. Prima `World.consume` calcolava direttamente un salto all'orario finale. I nuovi salvataggi versione 2 contengono anche righe degli attori, punto del ciclo, contesto sospeso e code. I salvataggi JS versione 1 vengono migrati; gli snapshot del motore originale rimangono incompatibili.

**I programmi autonomi degli altri 23 attori non sono ancora collegati.** Sono marcati esplicitamente come non tradotti e saltati, senza attribuire loro WAIT inventati. L'inizializzazione attuale crea il mondo e il prompt del sottoinsieme giocabile, non riproduce ancora tutte le sequenze iniziali originali. Il dettaglio espandibile “Stato del ciclo degli attori” rende visibile questa distinzione.

Il confronto del ciclo usa 12 tracce originali, inclusi avvio, errori, due comandi, attese, interruzione e timeout. Il driver delle prove fornisce i costi registrati dall'originale: verifica ordine, eleggibilità, scadenze, passi e callback, **non** la correttezza dei programmi NPC che hanno prodotto quei costi. Nelle tracce avviate dal prompt, i primi eventi `actor_return` hanno attore nullo perché il vecchio tracer è partito a visita già iniziata: la normalizzazione a Sherlock è dichiarata nel test.

## Parte aritmetica della casualità

`src/random.mjs` traduce aggiornamento del cursore, somma con carry, XOR, rifiuto di un valore ripetuto, riduzione, risultato con segno e valore assoluto. È confrontato con **446 estrazioni originali**, fornendo le coppie di byte effettivamente lette in ciascun contesto.

Questa è una prova del calcolo, non dell'uguaglianza di partite complete. Nell'originale gli ingressi provengono anche da memoria mutabile e contesti di lavoro: il modello funzionale che li produce e l'ordine delle estrazioni restano da ricostruire. Il modulo rifiuta ingressi mancanti e ripristina il suo stato, anziché chiamare Math.random. Per questa ragione il seed nella pagina JS resta disabilitato; non è stata introdotta una casualità sostitutiva.

Il prossimo blocco è tradurre le primitive e l'inizializzazione realmente richieste dai programmi, partendo da Watson, e ricostruire gli ingressi casuali necessari. Poi si potranno collegare le sequenze e confrontare gli attori, non solo il loro scheduler.
