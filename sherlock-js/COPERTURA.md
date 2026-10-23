# Copertura della riscrittura autonoma

Data: 23 ottobre 2026. **Questa versione non sostituisce ancora tutte le funzionalità della precedente pagina basata sullo Z80.** La precedente pagina resta un banco di confronto. I suoi risultati e le sue prove non diventano automaticamente risultati di questa riscrittura.

## Già ricostruito nel motore JS

- Dati: 592 voci di dizionario, 110 entità, 105 locazioni effettive, 206 archi diretti e 14 immagini. Il record zero delle locazioni è uno slot di servizio.
- Lessico alfabetico e abbreviazioni, con 1.804 confronti congelati; formati comuni di orari e denaro.
- Grammatica dei comandi ordinari, gruppi nominali, coordinazioni, ALL/EXCEPT, citazioni, modalità dichiarativa e completamento di un riferimento ambiguo.
- Struttura degli oggetti e contenitori, propagazione della posizione, filtro di percezione, condizioni di luce, descrizioni per fascia oraria, prima visita e LOOK.
- Varianti generiche di movimento, OPEN/CLOSE, TAKE/CARRY/GET, DROP, GIVE, INVENTORY, LOOK, EXAMINE e COUNT MONEY.
- WAIT di cinque minuti e presentazione dei minuti; WAIT UNTIL è ancora provvisorio.
- Scheduler funzionale dei 24 attori, ordine, scadenze, contesti sospesi e code; nel gioco sono collegati Holmes e il programma parziale di Watson.
- ALL dopo una domanda, OPEN/CLOSE/TAKE/DROP/GIVE collettivi e alcune varianti di esame; [FASE-2.md](FASE-2.md) precisa la copertura.
- Salvataggio dello stato logico e dello scheduler, inclusa una domanda di chiarimento pendente, e migrazione dei vecchi file JS.
- Mappa, teletrasporto di analisi, SVG/pixel, presentazione Spectrum riutilizzata e collegata al motore locale.

L'inventario [results/action-coverage.json](results/action-coverage.json) elenca tutti i 54 modelli d'azione. 33 hanno una regola generica parziale: questo **non** significa che quei 33 siano completamente equivalenti all'originale.

## Limiti precisi delle parti presenti

- Le citazioni possono impartire a Watson gli ordini generici documentati in [FASE-3.md](FASE-3.md), compresi ALL, WAIT e FOLLOW. Asserzioni, informazioni, deduzioni, altri interlocutori ed esclusioni restano da eseguire.
- Sono verificate le risposte `YOUR` e `YOUR DOOR` a `OPEN DOOR`. Non è ancora completa la ripresa di tutte le code di comandi dopo chiarimenti e conversazioni.
- La lettera Z provoca una lettura oltre il dizionario nell'originale: non riproduciamo quell'accesso accidentale. Formati numerici anomali, overflow e tutti i limiti dell'editor non sono certificati. La UI consente al massimo 128 caratteri, limite di questa implementazione.
- Gli algoritmi di visibilità sono tradotti, ma non ogni combinazione dinamica di luce, contenitori, peso, capacità e overflow a 8 bit è verificata.
- Tutte le 105 locazioni possono essere renderizzate nello stato statico disponibile. Questo non dimostra che ogni testo dinamico sia ricostruito: selezioni casuali e composizioni con argomenti ancora mancanti generano un avviso.
- OPEN/CLOSE riguarda le porte ordinarie. Casseforti, chiavi, serrature, biglietti e oggetti con regole locali speciali restano da tradurre.
- GIVE trasferisce l'oggetto; non riproduce ancora la reazione del destinatario. COUNT riguarda il denaro.
- Calendario e costo del giocatore sono parziali. WAIT UNTIL, interruzioni, attraversamento della mezzanotte e interazione con eventi non sono certificati; il riporto del tick a 16 bit è ora gestito dal ciclo e verificato separatamente. I riporti del calendario su lunghi periodi restano da certificare.
- Watson parte dal primo prompt storico, con il contatore privato 15 dichiarato; il secondo contatore casuale sospende esplicitamente il programma. Le callback degli incontri restano da tradurre. Gli altri personaggi iniziano dalle posizioni nei dati, senza eseguire i programmi di inizializzazione originali: le loro posizioni possono differire dal primo prompt dell'originale. Il buongiorno di Watson è tradotto separatamente, non è l'esecuzione della sua AI.
- La presentazione a caratteri è stata riutilizzata. La corrispondenza esatta dei nuovi pacchetti di testo con paginazione, spaziatura e contatori dell'originale richiederà prove specifiche.
- I controlli testuali SAVE, LOAD, QUIT, PAUSE, PRINT e NOPRINT sono riconosciuti ma non eseguiti come nel gioco. I pulsanti Salva, Carica e Riavvia sono strumenti della nuova UI.

## Ancora da tradurre

1. **Inizializzazione completa, collegamento dei programmi NPC e casualità.** Il ciclo dei 24 attori è ora tradotto; restano i programmi e le dipendenze della sorgente casuale. Il calcolo aritmetico della sorgente è verificato su ingressi registrati, non ancora generati dal modello. Nessuna promessa di equivalenza del seed finché questi elementi non saranno ricostruiti. I vecchi test del seed riguardavano il ponte Z80.
2. **Regole semantiche e azioni mancanti.** Completare contenitori e sedute oltre le varianti ordinarie verificate sulle poltrone; FOLLOW/COME WITH del giocatore oltre agli ordini di Watson; PUT, TAKE FROM/OFF/OUT OF, WEAR, LOCK/UNLOCK, esame approfondito, ulteriori forme di ALL e BUT/EXCEPT, azioni composte e comandi di sistema.
3. **Conoscenze e conversazione.** Pronomi nel contesto di gioco, destinatari, richieste, fatti, deduzioni, reazioni e ordini tra attori.
4. **AI degli NPC.** Completare lettura, nota/partenza e callback di Watson; Lestrade e tutti gli altri programmi. Eventi e scelte dinamiche, oltre alle sequenze scriptate.
5. **Trasporti e denaro.** Cab, destinazioni, pagamento/resto/debito, reazioni del cabbie, treni e orari.
6. **Storia e regole locali.** Indizi, eventi temporali, omicidio, sospetti, arresti, combattimento, morte, vittoria e fine partita.
7. **Equivalenza della sessione completa.** Salvataggi dell'AI e della casualità, replay con lo stesso seed, editor e MORE nei casi limite, partite complete di regressione.

## Prove eseguite e cosa dimostrano

- 1.804 ricerche del dizionario confrontate con risultati congelati dell'originale.
- 39 casi di grammatica di base e 52 casi speciali/di riga completa; confronto degli esiti e dei campi semantici pertinenti. I puntatori dell'allocatore originale non sono stato semantico.
- 18 sequenze di azioni isolate, 33 comandi complessivi: frasi ed errori con spaziatura/maiuscole normalizzate, posizione e orario. I turni NPC erano disabilitati dopo l'avvio di riferimento. `GO TO HALL` è escluso perché l'azione non è tradotta.
- Altre cinque tracce, 14 passaggi, confrontano genitore, locazioni, attributi e flag di esame di 11 entità selezionate. Non è un confronto dell'intera memoria o di tutto lo stato del mondo.
- Save/load, continuazioni, visibilità in contenitori, checksum, rifiuto dei vecchi snapshot e assenza di dipendenze CPU/backend.
- Rendering statico di 105 locazioni: controllo che non venga richiesto un operatore di testo mancante, non prova completa di tutti i contenuti.

## Ordine di lavoro successivo

Il ciclo funzionale è presente: completare l’inizializzazione, ricostruire gli ingressi casuali e le primitive condivise dagli attori. Con queste basi, portare Watson, Lestrade e il cab usando le analisi già disponibili. Ogni passaggio avrà una traccia di confronto esplicita, prima delle regole della storia e delle prove di partita completa.

Aggiornamento fase 2: 20 sequenze di confronto per ALL, 12 replay del ciclo usando costi registrati, 446 estrazioni per il calcolo casuale e prove di selezione/persistenza della scheda. Nessuna di queste prove dichiara tradotti i programmi NPC; vedere [FASE-2.md](FASE-2.md).

Aggiornamento fase 3: ordini, primo contatore e seguito di Watson; 11 sequenze / 43 comandi confrontati con il riferimento isolato, più il prefisso narrativo al confine casuale. Salvataggi JS versione 3 e interruzione delle attese con ripristino degli NPC. Il contatore storico 15 non è un bootstrap generato da un seed. Vedere [FASE-3.md](FASE-3.md).
