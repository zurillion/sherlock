# Oggetti e contenitori: primo passaggio

25 ottobre 2026. Implementazione autonoma delle regole ordinarie di collocazione
DEC1/DED9 e di recupero DCC1/DCA2, con tutti gli attori attivi nei confronti.

## Cosa provare

Da una nuova partita:

```text
TAKE LAMP
PUT LAMP ON YOUR ARMCHAIR
INVENTORY
TAKE LAMP FROM YOUR ARMCHAIR
PUT LAMP ON WATSONS ARMCHAIR
TAKE LAMP OUT OF WATSONS ARMCHAIR
```

Anche gli ordini citati usano queste regole:

```text
SAY TO WATSON "PUT DAILY CHRONICLE ON YOUR ARMCHAIR"
SAY TO WATSON "TAKE DAILY CHRONICLE FROM YOUR ARMCHAIR"
```

Il destinatario esegue la richiesta al proprio turno. Non viene trasferito
il giornale dall'interfaccia né viene invocato il motore originale.

## Algoritmo e particolarità originali

- Collocare richiede possesso del primo oggetto e percezione del destinatario.
  Il campo `properties & 7` deve indicare una relazione di contenimento.
- L'ingombro è distinto dal peso: D2ED somma le dimensioni dei figli diretti,
  senza sommare ricorsivamente il loro contenuto. L'overflow **con segno**
  satura a FF; non è una somma senza limiti di JavaScript.
- La capacità residua deve essere strettamente positiva: un oggetto che
  riempirebbe esattamente il contenitore viene rifiutato.
- Le maschere di attributi sono non eliminatorie nel preflight A00B=0, poi
  vengono applicate nell'esecuzione. Non si possono fondere i due controlli.
- B29A considera valido il primo argomento solo se sopravvive esattamente un
  secondo argomento. Due poltrone possibili possono quindi produrre
  `YOU CANNOT PUT THE LAMP`, anziché una domanda sulla poltrona.
- La regola TAKE FROM/OUT OF non verifica necessariamente che l'oggetto si
  trovi davvero nel contenitore dichiarato. Nel corpus originale è accettato
  il recupero dalla poltrona diversa da quella reale e perfino FROM WATSON
  per una lampada sul pavimento. La provenienza deve comunque essere risolta:
  un Lestrade assente dà l'errore originale, non un trasferimento riuscito.

Il catalogo delle azioni contiene anche DROP IN e PUT IN e il loro corpo
condiviso è tradotto. Tuttavia, in questa distribuzione, il lookup di `IN`
rimanda alla voce VISIT, classe E0: `PUT LAMP IN YOUR ARMCHAIR` dà `WHAT ?`
anche nell'originale. `INTO` non seleziona automaticamente il modello IN.
Questa fase conserva il risultato del dizionario e non aggiunge sinonimi.

## Errori, ricerca nelle descrizioni e tempo

Quando una risoluzione fallisce, B6FD–B839 cerca i nomi anche nella descrizione
compressa della stanza. La ricerca usa un lettore diverso dalla stampa: tratta
anche lo spazio letterale come un frammento compresso. I suoi richiami al testo
allocano record temporanei di due byte. Conservare gli stessi record liberati
è necessario perché quei byte possono entrare nella casualità successiva.

`tools/build-description-search.mjs` decodifica offline questo percorso in dati
tipizzati di ricerca. `src/description-search.mjs` ne esegue la logica di
dominio; non interpreta istruzioni CPU e non consulta le fixture.

CC8C/CEB8 conta dieci fallimenti delle **regole del programma del giocatore**
prima di cedere un minuto. Un errore semantico può contare tre fallimenti
(semantica, esaurimento nodi, esaurimento token); uno lessicale o sintattico
segue un altro percorso. Non esiste una durata fissa per comando errato.
Una cessione che avviene prima della pulizia conserva il nodo fallito durante
i turni NPC e lo libera solo al successivo controllo D7D9/D88A.

Il contatore e la continuazione sono ora salvati. I salvataggi precedenti che
non li contengono non ricevono un conteggio inventato: un'azione con costo
eseguita normalmente ristabilisce il contatore noto; un percorso senza costo
che richiede il dato mancante viene annullato esplicitamente.

## Prove e ambito

`test/objects.test.mjs` confronta due sequenze native: 26 + 23 comandi, seed 1,
tutti i 24 slot attori attivi, LOOK iniziale gratuito, grafica disattivata dopo
il primo prompt, input maiuscolo iniettato, nessun timeout e MORE immediato.
Sono verificate 108 estrazioni e 216 letture, stato degli attori e delle 110
entità, 106 flag delle stanze, tutti i 752 byte dell'arena, editor/token e
bitmap esatte superiore/inferiore, oltre ai campi di lavoro posseduti.

Altre 94 prove isolate confrontano il preflight originale per capacità,
ingombro, overflow e flag; 52 verificano anche l'esecuzione. Due comandi
completi verificano il messaggio di rifiuto e gli argomenti salvati dopo
il fallimento delle maschere. Un ramo save/load riparte con il contatore a nove
fallimenti, verificando risposte e stato completo del seguito. Una funzione
ancora mancante non consuma questo contatore: il prototipo annulla la riga.

Il rapporto riproducibile è `results/objects-verification.json`. Restano
travestimenti e identità alternative, esclusioni/collettivi non coperti,
regole locali degli indizi e combinazioni non verificate. Non è una prova
di equivalenza dell'intero gioco. L'ordine complessivo del lavoro è in
[STATO-E-PROSSIMI-PASSI.md](STATO-E-PROSSIMI-PASSI.md).

La suite completa conta 331 test passati. Il listato misto
`results/objects/object-rules.asm` distingue intestazioni e celle di stato
dalle istruzioni; 546 byte sono stati ricomposti senza differenze. Il server
statico locale è stato riattivato e i nuovi moduli rispondono HTTP 200;
questa fase non include una verifica interattiva della pagina nel browser.
