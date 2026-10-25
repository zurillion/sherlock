> Aggiornamento 24 ottobre 2026: la pagina avvia ora **NPC v5**. Per architettura, prove e limiti attuali vedere [NPC-RUNTIME.md](NPC-RUNTIME.md) e `results/world-npc-verification.json`. Questo documento conserva l’ambito della fase precedente; le affermazioni sul solo Watson attivo o sul cab non collegato non descrivono le nuove partite.

> Inventario aggiornato del lavoro ancora da fare: [STATO-E-PROSSIMI-PASSI.md](STATO-E-PROSSIMI-PASSI.md), 25 ottobre 2026.

# Copertura della riscrittura autonoma

Data: 24 ottobre 2026. **Questa versione non sostituisce ancora tutte le funzionalità della precedente pagina basata sullo Z80.** La precedente pagina resta un banco di confronto. I suoi risultati e le sue prove non diventano automaticamente risultati di questa riscrittura.

## Già ricostruito nel motore JS

- Dati: 592 voci di dizionario, 110 entità, 105 locazioni effettive, 206 archi diretti e 14 immagini. Il record zero delle locazioni è uno slot di servizio.
- Lessico alfabetico e abbreviazioni, con 1.804 confronti congelati; formati comuni di orari e denaro.
- Grammatica dei comandi ordinari, gruppi nominali, coordinazioni, ALL/EXCEPT, citazioni, modalità dichiarativa e completamento di un riferimento ambiguo.
- Struttura degli oggetti e contenitori, propagazione della posizione, filtro di percezione, condizioni di luce, descrizioni per fascia oraria, prima visita e LOOK.
- Varianti generiche di movimento, OPEN/CLOSE, TAKE/CARRY/GET, DROP, GIVE, INVENTORY, LOOK, EXAMINE, COUNT MONEY e PAY valuta TO persona.
- HELLO nella zona comandi; saluto citato e TELL nelle nuove partite Watson v4, con ingressi generati nel profilo storico isolato. Nessuna risposta temporale fissa. [WATSON-RUNTIME.md](WATSON-RUNTIME.md) dichiara prove e primo confine non tradotto.
- HAIL CAB sulle dieci strade della rete, arrivo con cocchiere e denaro, GET INTO CAB e GET OUT OF CAB. Il programma del cocchiere successivo all’arrivo è sospeso.
- WAIT di cinque minuti e presentazione dei minuti; WAIT UNTIL è ancora provvisorio.
- Scheduler funzionale dei 24 attori, ordine, scadenze, contesti sospesi e code; nel gioco sono collegati Holmes e il programma parziale di Watson.
- ALL dopo una domanda, OPEN/CLOSE/TAKE/DROP/GIVE collettivi e alcune varianti di esame; [FASE-2.md](FASE-2.md) precisa la copertura.
- Salvataggio dello stato logico e dello scheduler, inclusa una domanda di chiarimento pendente, e migrazione dei vecchi file JS.
- Mappa, teletrasporto di analisi, SVG/pixel, presentazione Spectrum riutilizzata e collegata al motore locale.

L'inventario [results/action-coverage.json](results/action-coverage.json) elenca tutti i 54 modelli d'azione. 38 hanno almeno una regola giocabile parziale: questo **non** significa che siano completamente equivalenti all'originale. TELL è collegato nel profilo Watson v4; le varianti non risolte restano esplicite.

## Limiti precisi delle parti presenti

- Le citazioni possono impartire a Watson gli ordini generici documentati in [FASE-3.md](FASE-3.md), compresi ALL, WAIT e FOLLOW. I nuovi ordini durante FOLLOW e i saluti citati restano mancanti; la precedentemente concessa variante fissa è stata rimossa. Asserzioni, informazioni, deduzioni, altri interlocutori ed esclusioni restano da eseguire.
- Sono verificate le risposte `YOUR` e `YOUR DOOR` a `OPEN DOOR`. Non è ancora completa la ripresa di tutte le code di comandi dopo chiarimenti e conversazioni.
- La lettera Z provoca una lettura oltre il dizionario nell'originale: non riproduciamo quell'accesso accidentale. Formati numerici anomali, overflow e tutti i limiti dell'editor non sono certificati. La UI consente al massimo 128 caratteri, limite di questa implementazione.
- Gli algoritmi di visibilità sono tradotti, ma non ogni combinazione dinamica di luce, contenitori, peso, capacità e overflow a 8 bit è verificata.
- Tutte le 105 locazioni possono essere renderizzate nello stato statico disponibile. Questo non dimostra che ogni testo dinamico sia ricostruito: selezioni casuali e composizioni con argomenti ancora mancanti generano un avviso.
- OPEN/CLOSE riguarda le porte ordinarie. Casseforti, chiavi, serrature, biglietti e oggetti con regole locali speciali restano da tradurre.
- GIVE trasferisce l'oggetto; non riproduce ancora la reazione del destinatario. COUNT riguarda il denaro.
- Calendario e costo del giocatore sono parziali. WAIT UNTIL, interruzioni, attraversamento della mezzanotte e interazione con eventi non sono certificati; il riporto del tick a 16 bit è ora gestito dal ciclo e verificato separatamente. I riporti del calendario su lunghi periodi restano da certificare.
- Watson parte dal primo prompt storico, con il contatore privato 15 dichiarato; sono collegati il secondo contatore, il biglietto/partenza e le callback nel profilo verificato. Alcune zone di ingresso casuale restano da generare e causano rollback. Gli altri personaggi iniziano dalle posizioni nei dati, senza eseguire i programmi di inizializzazione originali: le loro posizioni possono differire dal primo prompt dell'originale. Il buongiorno di Watson è tradotto separatamente, non è l'esecuzione della sua AI.
- La presentazione a caratteri è stata riutilizzata. Due WAIT consecutivi sono ora confrontati con le righe, i contatori e gli scroll originali; è verificato anche che i lotti dei minuti non aggiungano righe vuote. La corrispondenza completa in tutti i contesti resta da certificare.
- I controlli testuali SAVE, LOAD, QUIT, PAUSE, PRINT e NOPRINT sono riconosciuti ma non eseguiti come nel gioco. I pulsanti Salva, Carica e Riavvia sono strumenti della nuova UI.

## Ancora da tradurre

1. **Inizializzazione completa, collegamento dei programmi NPC e casualità.** Il ciclo dei 24 attori è ora tradotto; restano i programmi e le dipendenze della sorgente casuale. Il calcolo aritmetico è collegato a ingressi generati nel profilo Watson v4; restano altre regioni e i contributi degli attori disabilitati. Nessuna promessa di equivalenza del seed finché questi elementi non saranno ricostruiti. I vecchi test del seed riguardavano il ponte Z80.
2. **Regole semantiche e azioni mancanti.** Completare contenitori e sedute oltre le varianti ordinarie verificate sulle poltrone; FOLLOW/COME WITH del giocatore oltre agli ordini di Watson; PUT, TAKE FROM/OFF/OUT OF, WEAR, LOCK/UNLOCK, esame approfondito, ulteriori forme di ALL e BUT/EXCEPT, azioni composte e comandi di sistema.
3. **Conoscenze e conversazione.** Pronomi nel contesto di gioco, destinatari, richieste, fatti, deduzioni, reazioni e ordini tra attori.
4. **AI degli NPC.** Completare semantica delle richieste e memoria delle informazioni di Watson oltre ai rami verificati; Lestrade e tutti gli altri programmi. Eventi e scelte dinamiche, oltre alle sequenze scriptate.
5. **Trasporti e denaro.** Dopo chiamata e salita nel cab: dialogo e reazioni del cocchiere, attese, destinazioni, viaggio, pagamento/resto/debito; treni e orari.
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

Aggiornamento saluti e cab: 212 test complessivi. Sei nuove sequenze / 15 comandi confrontano testi normalizzati, orario e dieci entità selezionate. Per le chiamate del cab il programma del cocchiere è disabilitato nel riferimento: la prova attesta il prefisso fisico, non la sua conversazione. La settima traccia registrata con cocchieri attivi è documentazione del comportamento ancora mancante. Due WAIT confrontano anche le righe dello schermo originale. Dettagli e limiti: [SALUTI-E-CAB.md](SALUTI-E-CAB.md).

Revisione del criterio di fedeltà: la risposta fissa di Watson è rimossa. Le due tracce sui saluti conservate nel corpus precedente non sono più dichiarate confronti equivalenti del gioco: restano come riferimento del lavoro da completare. Le quattro tracce del cab (8 comandi, cocchieri disabilitati) continuano a passare. 214 test attuali; 1.280 selezioni testuali controllate confrontate con il codice originale. La nuova indagine registra 401 comandi originali su sei seed, senza dichiarare che il motore JS li riproduca. [FIDELITY.md](FIDELITY.md) e `results/fidelity-audit.json` riportano criterio, prove e dipendenze mancanti.

Kernel NPC in costruzione: 236 test complessivi, con nuovi confronti di continuazioni, record, segnali, contatori, rotte e pagamenti. Sono esportati tutti i 23 programmi non giocatore, senza eseguire i corpi Z80. Watson completo, cabbie completo, Lestrade completo e parità casuale globale restano non implementati. Questi componenti non sono ancora attivati nella pagina; vedere [NPC-FOUNDATIONS.md](NPC-FOUNDATIONS.md).

Aggiornamento runtime Watson v4: [WATSON-RUNTIME.md](WATSON-RUNTIME.md) e results/runtime-watson-verification.json sostituiscono il precedente stato dei saluti bloccati. I rapporti delle fasi precedenti restano documenti storici con il loro ambito originale.
