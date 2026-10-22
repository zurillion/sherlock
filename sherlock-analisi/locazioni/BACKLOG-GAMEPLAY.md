# Backlog del gameplay di Sherlock

Aggiornamento del 22 ottobre 2026. Baseline applicativa `fc50b3c`, prima di questo audit. Payload ZX Spectrum v2.0 con SHA-256 `c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407`.

**Il prototipo esegue già parser, regole e turni originali tramite SkoolKit. Non ha una piccola whitelist Python di verbi. Un comportamento non ancora studiato o provato può già essere in esecuzione.**

Le categorie qui usate sono: **manca/errato**, **limite del prototipo**, **attivo ma da verificare**, **scelta di presentazione**. Una risposta negativa del gioco non dimostra che manchi un comando. Il manuale e Foggy London restano indizi: le verifiche si riferiscono ai byte della versione fornita.

## Ordine di lavoro consigliato

1. **G01 — SAVE/LOAD**, con stati esportabili e riproducibili; correggere prima la classificazione di LOAD come QUIT. È la base per indagare senza perdere i progressi.
2. **G05 e G04 — informazioni e soluzione del caso**: spiegare come testimonianze/accuse influenzano Watson e Lestrade e costruire una partita completa ripetibile.
3. **G06–G10 — completare le prove del mondo**: altri NPC, treni, indizi, notte e combinazioni degli oggetti, usando gli stati salvati.
4. **G02/G03/G11 — fedeltà dell’interazione**: timeout e PAUSE, limiti dell’input, vera inizializzazione e seme. Il timeout cambia l’esperienza d’uso: va introdotto consapevolmente.
5. **G13–G18 — servizi e dettagli di presentazione**, con priorità alle discrepanze effettivamente riproducibili.
6. **G19 — traduzione autonoma in Python**, dopo aver reso ogni modulo confrontabile con il riferimento Z80.

La priorità 1 segnala un fondamento o una lacuna importante; non impone di implementare tutte quelle voci prima di tornare all’indagine. Gli ID rimangono stabili per poter scegliere il prossimo lavoro.

## Inventario delle lacune e delle verifiche

| ID | Priorità | Parte | Stato |
|---|---:|---|---|
| G01 | 1 | SAVE e LOAD | Manca / comportamento errato |
| G02 | 1 | Timeout di inattività e PAUSE | Manca |
| G03 | 1 | Input lungo e buffer | Limite aggiunto dal prototipo |
| G04 | 1 | Partita completa e tutti i finali | Da verificare fino in fondo |
| G05 | 1 | Informazioni, testimonianze e accuse | In esecuzione; comprensione parziale |
| G06 | 2 | Altri NPC e scene successive | Attivo; copertura incompleta |
| G07 | 2 | Viaggi in treno dal punto di vista del giocatore | Attivo; copertura incompleta |
| G08 | 2 | Indizi e oggetti con eventi speciali | Attivo; da catalogare |
| G09 | 2 | Notte, luce e riposo dei personaggi | Attivo; da verificare |
| G10 | 2 | Fisica degli oggetti e combinazioni di azioni | Attivo; da verificare |
| G11 | 2 | Inizializzazione e varietà fra partite | Differenza accertata; scelta da definire |
| G12 | 2 | Limiti tecnici e anomalie dell’originale | Protezione deliberata; casi da delimitare |
| G13 | 3 | PRINT/NOPRINT e trascrizione esportabile | Manca |
| G14 | 3 | Tastiera e cronologia fedeli | Presentazione parziale |
| G15 | 3 | Ripresa esatta dello schermo | Presentazione parziale |
| G16 | 3 | Mappa e pannelli durante il tempo simulato | Presentazione parziale |
| G17 | 3 | Casi rari di output e viste | Da estendere nelle prove |
| G18 | 3 | Guida e dossier delle fasi precedenti | Documentazione da riallineare |
| G19 | 4 | Motore Python autonomo | Fase futura distinta |

## G01 — SAVE e LOAD

**Priorità 1 · Manca / comportamento errato.**

SAVE è escluso. LOAD raggiunge il ramo comune e viene classificato come QUIT: chiude la partita senza caricare nulla. Le sessioni sono soltanto in RAM.

Evidenza: NativeWorld.iter_submit; serve_explorer.py:sessions; audit: SAVE/LOAD/QUIT.

Completamento verificabile: Un salvataggio esportabile, caricabile anche dopo riavvio del server o morte, ripristina mondo, timer, denaro, code, interlocutore e disambiguazioni. LOAD non termina impropriamente la sessione.

## G02 — Timeout di inattività e PAUSE

**Priorità 1 · Manca.**

Al prompt il ponte si ferma subito; nessun WAIT automatico quando non si scrive. PAUSE è escluso. Il riferimento è il timeout fra tasti, non un orologio continuo a velocità reale.

Evidenza: NativeWorld.iter_submit:A536; main-loop/LEGGIMI-MAIN-LOOP.md; audit: PAUSE.

Completamento verificabile: Riprodurre il timeout nativo di 3000 letture (~60 s nella traccia, diversamente dai ~30 s del manuale), cancellazione dell’input parziale e WAIT. Tasti, PAUSE e MORE devono sospendere o riarmare il timer correttamente.

## G03 — Input lungo e buffer

**Priorità 1 · Limite aggiunto dal prototipo.**

UI e ponte impongono 70 caratteri. Un LOOK con spazi, lungo 74 caratteri, viene eseguito dall’originale e rifiutato dal web. Il limite dei token è distinto dal limite dei caratteri.

Evidenza: index.html:maxlength; SpectrumTerminal.type; NativeWorld.iter_submit; editor D8BA/D93C; audit: original_long_input_reference.

Completamento verificabile: Stabilire i limiti sicuri dell’editor, compresi punto e virgolette aggiunti, e gestire il buffer dei token senza falsi errori grammaticali. Correggere la guida che chiama 70 il limite originale.

## G04 — Partita completa e tutti i finali

**Priorità 1 · Da verificare fino in fondo.**

Morte, QUIT e gateway di vittoria sono provati; la vittoria usa una fixture. Manca una soluzione ripetibile dall’avvio senza mappa e senza modificare il mondo.

Evidenza: verify_wait_endgame.py:fixture victory; AI-WEB.md; STATO-GAMEPLAY.md.

Completamento verificabile: Traccia completa input/tempo/stati fino alla soluzione, poi rami alternativi: accuse errate, indizi distrutti, piani perduti, soluzioni parziali, arrivo tardivo e morte.

## G05 — Informazioni, testimonianze e accuse

**Priorità 1 · In esecuzione; comprensione parziale.**

Il percorso delle affermazioni e la lista di informazioni sono attivi. Non è ancora ricostruito interamente come Watson e Lestrade valutano prove, innocenza, contraddizioni e deduzioni.

Evidenza: ai/LEGGIMI-AI.md §9; BA20, BA67, BB67, 9FF4; audit: conversation.

Completamento verificabile: Catalogare fatti iniziali, metadati, aggiornamenti e condizioni delle risposte; distinguere un assenso verbale dall’acquisizione di un fatto o da una conclusione del caso.

## G06 — Altri NPC e scene successive

**Priorità 2 · Attivo; copertura incompleta.**

Tutti i 24 attori girano già. Restano da spiegare e provare gli sviluppi di Straker, Daphne, Basil, Ffoulkes, agente tedesco, Tricia, domestici e poliziotti, e le scene tarde di Lestrade.

Evidenza: ai/results/scripts.json; ai/LEGGIMI-AI.md; verify_web_ai.py.

Completamento verificabile: Per ciascun personaggio: programma, contatori, callback, incontri, segnali, ordini accettati/rifiutati e conseguenze quando Holmes arriva prima o dopo.

## G07 — Viaggi in treno dal punto di vista del giocatore

**Priorità 2 · Attivo; copertura incompleta.**

Treni e itinerario iniziale di Lestrade sono verificati. Non risulta una suite completa su tutti i viaggi di Holmes, denaro/biglietti, coincidenze, corse perse e discese.

Evidenza: AI-WEB.md; main-loop/ATTORI.md; manuale Movement/Travel.

Completamento verificabile: Percorsi normali fra tutte le linee con Holmes e Watson, condizioni di salita/discesa e rapporto fra passeggeri, posizione del mezzo, tariffe e orari. Verificare nel codice l’effettiva esistenza delle regole sui biglietti citate dal manuale.

## G08 — Indizi e oggetti con eventi speciali

**Priorità 2 · Attivo; da catalogare.**

Nota che brucia, casseforti, pistola, piani e altri oggetti possono attivare script e callback. Le prove isolate non certificano il percorso completo per incontrare ogni variante.

Evidenza: regole/LEGGIMI-REGOLE.md; entita/results/CATALOGO.md; regole/results/execution-traces.json.

Completamento verificabile: Tabella oggetto → azioni/eccezioni → trasformazioni → eventi ritardati → effetto sull’indagine; prove ai due lati delle scadenze.

## G09 — Notte, luce e riposo dei personaggi

**Priorità 2 · Attivo; da verificare.**

Percezione, fasce delle descrizioni e buio sono presenti; non abbiamo una copertura completa di spostamenti notturni, lampada, sonno/rientri e interazioni con gli orari.

Evidenza: verify_locations.py; decoder/print_locations.py; ai/LEGGIMI-AI.md: test F1D6.

Completamento verificabile: Prove di giorno/notte con e senza luce, oggetti dentro contenitori opachi/trasparenti, turni serali degli NPC e passaggio di giorno.

## G10 — Fisica degli oggetti e combinazioni di azioni

**Priorità 2 · Attivo; da verificare.**

TAKE/GIVE/OPEN e parte del contenimento sono studiati. Restano capacità/peso, annidamento, accessibilità, proprietà altrui, serrature e molti successi/fallimenti di azioni poco usate.

Evidenza: entita/LEGGIMI-ENTITA.md; regole/LEGGIMI-REGOLE.md; audit: objects.

Completamento verificabile: Matrice di azioni in stati validi e invalidi, confrontando messaggi, costi ed effetti col codice originale. Non aggiungere comportamenti solo perché una parola compare nel manuale o nei 54 modelli.

## G11 — Inizializzazione e varietà fra partite

**Priorità 2 · Differenza accertata; scelta da definire.**

Riavvia ricarica sempre lo snapshot al primo prompt, con il primo contatore di Watson già inizializzato. L’avvio originale campiona R per il seme a A05F/A061.

Evidenza: Game.__init__; parser/game prompt; A05F LD A,R → A037; ai/LEGGIMI-AI.md §6.

Completamento verificabile: Separare avvio fedele, seme di test riproducibile e nuova partita variabile. Ricalcolare i contatori che precedono lo snapshot se si vuole riprodurre la varietà originale.

## G12 — Limiti tecnici e anomalie dell’originale

**Priorità 2 · Protezione deliberata; casi da delimitare.**

Il ponte blocca scansioni fuori dizionario (es. Z), overflow dei token e fasi senza progresso, con rollback e messaggio tecnico. Non sono errori sintattici del gioco. Nei due casi ALL EXCEPT provati l’oggetto escluso viene comunque trattato: accade anche nel banco originale indipendente, non soltanto nel web.

Evidenza: NativeWorld.iter_submit; parser/LEGGIMI-SPECIALI.md §7; audit: Z e input denso; results/gameplay-edge-comparisons.json.

Completamento verificabile: Per ogni arresto identificare limite del tool o anomalia nativa, conservare una riproduzione e un esito dichiarato. Non rimuovere alla cieca le protezioni per imitare letture fuori tabella.

## G13 — PRINT/NOPRINT e trascrizione esportabile

**Priorità 3 · Manca.**

I due comandi sono bloccati; la cronologia normale non è una registrazione esportabile dell’intera sessione.

Evidenza: NativeWorld.iter_submit; audit: PRINT/NOPRINT.

Completamento verificabile: Adattare PRINT a una trascrizione persistente/esportabile del canale superiore, e NOPRINT all’arresto della registrazione, senza richiedere una stampante Spectrum.

## G14 — Tastiera e cronologia fedeli

**Priorità 3 · Presentazione parziale.**

Il motore aggiunge punto e chiusure delle virgolette, ma la cronologia mostra il testo digitato. Cancellazione intera riga e scorciatoie direzionali native non sono riprodotte; @ attende Invio nel frontend.

Evidenza: SpectrumTerminal.commit/key; explorer-ui.js:command; editor D8D9/D949/D978/D99E; audit: buffer.

Completamento verificabile: Confrontare editor e storia visuale con l’originale. Frecce ignorate e inserimento solo in coda erano scelte richieste: eventuali scorciatoie vanno introdotte come opzione, non cambiate implicitamente.

## G15 — Ripresa esatta dello schermo

**Priorità 3 · Presentazione parziale.**

Reload conserva il mondo ma ricompone la scena, perdendo la storia dello schermo, il punto di animazione/MORE, la bozza e parte della cronologia inferiore.

Evidenza: explorer-ui.js:initial load/compatibility change; SpectrumTerminal.reset/resumeSession.

Completamento verificabile: Conservare o ripristinare la presentazione senza un LOOK di ispezione aggiuntivo; provare reload al prompt, durante MORE, dopo una domanda e durante WAIT UNTIL.

## G16 — Mappa e pannelli durante il tempo simulato

**Priorità 3 · Presentazione parziale.**

Durante i lotti al minuto la pagina aggiorna l’orologio ma aggiorna posizioni/marker solo al risultato finale. Nomi degli oggetti e stato delle uscite usano anche il catalogo iniziale e criteri semplificati.

Evidenza: explorer-ui.js:consumeCommand/updateCharacters; Game.state/characters.

Completamento verificabile: Aggiornare la mappa a ogni minuto senza eseguire ispezioni mutanti; mostrare qualificatori correnti e distinguere stato grafico dell’uscita dall’esito della regola completa. La mappa onnisciente resta uno strumento di analisi richiesto.

## G17 — Casi rari di output e viste

**Priorità 3 · Da estendere nelle prove.**

Il MORE principale ora è verificato contro lo Z80. Restano da collaudare insieme percezione, LOOK THROUGH, grafiche, contenitori, numeri e trasformazioni degli oggetti in scene complesse.

Evidenza: verify_paging.py/cjs; native_screen.py; audit: view/remote_view_probe.

Completamento verificabile: Confronti delle schermate nei casi rari; chiarire prima nel codice cosa fa LOOK THROUGH in questa versione. Il testo promesso dal manuale non basta per dedurre che debba comparire una figura.

## G18 — Guida e dossier delle fasi precedenti

**Priorità 3 · Documentazione da riallineare.**

Alcuni testi storici descrivono ancora NPC esclusi, LOAD bloccato o 70 come limite nativo. Sono descrizioni superate o inesatte, non la situazione del codice corrente.

Evidenza: index.html:help; CAB dossier; LEGGIMI-LOCAZIONI.md; STATO-GAMEPLAY.md precedente.

Completamento verificabile: Indicare chiaramente le versioni storiche e mantenere un solo inventario corrente, con collegamenti alle prove e distinzione fra non implementato e non verificato.

## G19 — Motore Python autonomo

**Priorità 4 · Fase futura distinta.**

La pagina usa Python per pilotare il codice Z80 originale. Decoder di testo/grafica e parti delle strutture sono già Python; parser, regole, scheduler e AI non sono ancora tutti riscritti indipendentemente.

Evidenza: NativeWorld; sherlock_parser.py; documenti regole/AI/main-loop.

Completamento verificabile: Tradurre per moduli solo dopo aver definito gli stati e le prove differenziali. Avere una reazione eseguibile nel prototipo non equivale ad averla capita o riscritta.

## Risultati concreti dell’audit

Sono stati eseguiti **70 comandi** su partite isolate, con tutti gli attori abilitati. Le ricollocazioni tramite mappa sono dichiarate nelle prove. La partita del browser non è stata utilizzata come banco di prova.

- `SAVE`, `PAUSE`, `PRINT`, `NOPRINT`: arresto deliberato del ponte e ripristino dello stato; nessuna funzione equivalente nel web.
- `LOAD`: esito `game_over`, `reason=quit`, ingresso `$B0A6`; nessun caricamento. LOAD e QUIT condividono il ramo originale, che il ponte attuale tratta indiscriminatamente come fine partita.
- `QUIT`: termina correttamente.
- Una riga di **74 caratteri** (`LOOK` seguito da spazi) viene rifiutata dal web; il banco originale esegue LOOK e torna al prompt. L’editor originale parte con B=`$80` a `$D8BA`; aggiunge anche punteggiatura e chiusure. Non basta sostituire meccanicamente 70 con 128.
- La conversazione prosegue con sole virgolette dopo `SAY TO WATSON`; le affermazioni raggiungono le reazioni originali. Restano da comprendere integralmente i loro effetti sulle informazioni.
- `OPEN DOOR` → `YOUR`, anche con ispezione della scena fra domanda e risposta, apre la porta. `@` ripete LOOK; dopo una continuazione può ripetere una riga che da sola non è un comando completo.
- TAKE, CARRY, GET, GIVE, PUT ON, TAKE FROM, SIT/CLIMB/GET INTO, FOLLOW/COME WITH, COUNT, PAY e travestimenti raggiungono i percorsi nativi nei casi registrati. Non sono assenti dal ponte.
- `LOOK THROUGH DAPHNES DOOR`, dalla locazione 69 con porta aperta, produce lo stesso testo nel banco originale con grafica abilitata. La regola `$DC19`, corpo `$DC20`, usa la vista breve `$D1B2`; non attribuiamo al web una funzione grafica mancante soltanto sulla base del manuale.

**Anomalie o limiti della versione originale da non confondere con mancanze del porting:**

- ATTACK e DRIVE sono parole sconosciute nella versione fornita.
- PICK THE NOTE UP produce errore sintattico; PICK UP THE NOTE arriva al rifiuto del modello verbo/preposizione.
- Nei due esperimenti `EXAMINE ALL EXCEPT THE LAMP` e `OPEN ALL EXCEPT THE PLAIN DOOR`, viene trattato anche l’oggetto nominato nell’esclusione. Il testo coincide con quello del banco Z80 indipendente: è un comportamento da spiegare, non la prova di una traduzione Python mancante.
- LOCK/UNLOCK hanno modelli lessicali ma nessuna associazione di regola nel catalogo iniziale generale/locale; il caso provato viene rifiutato anche passando dal motore originale. Non si esclude una modifica di tabelle durante il gioco con il solo censimento statico.

## Scelte già concordate, da tenere separate dalle lacune

Avvio gratuito alle 08:00am, velocità animata delle parole, SVG ad alta risoluzione, mappa con teletrasporto/posizioni di tutti i personaggi e input limitato all’inserimento in coda sono scelte dell’esploratore. Non sono automaticamente difetti da eliminare. Il primo saluto di Watson e il MORE principale sono già stati riallineati e verificati.

## File e riproduzione

| File | Contenuto |
|---|---|
| `audit_gameplay.py` | 70 comandi, controlli dei servizi e confronto nativo della riga lunga. |
| `probe_audit_edges.py` | Confronti indipendenti su ALL EXCEPT e LOOK THROUGH. |
| `build_gameplay_inventory.py` | Censimento dei 54 modelli, regole iniziali e dispatch osservati. |
| `results/gameplay-audit.json` | Risposte, azioni osservate, clock, buffer valido e condizioni delle prove. |
| `results/gameplay-edge-comparisons.json` | Testo dei confronti mirati indipendenti. |
| `results/gameplay-action-inventory.json` / `GAMEPLAY-ACTIONS.md` | Tutti i 54 modelli, senza dedurre assenze dalla sola mancata copertura. |
| `results/gameplay-backlog.json` | Le 19 voci con ID, priorità, evidenza e criterio di completamento. |

Dalla cartella Sherlock rebuild:

```sh
python3 -B sherlock-analisi/locazioni/audit_gameplay.py
python3 -B sherlock-analisi/locazioni/probe_audit_edges.py
python3 -B sherlock-analisi/locazioni/build_gameplay_inventory.py
```

Tutti accettano `--project` e `--output`. I primi due eseguono VM isolate; il terzo legge il rapporto dell’audit. Non serve riavviare il server. I sei controlli dell’audit confermano lo stato osservato, comprese lacune: “passed” qui non significa che i difetti siano risolti. Le 70 prove non sono una soluzione completa né una certificazione di tutte le regole.
