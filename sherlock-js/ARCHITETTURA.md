# Dal comportamento originale alle regole JavaScript

## Il contratto

Lo Z80 è una fonte da studiare e un riferimento da interrogare in prove separate. Il prodotto finale non deve eseguire il suo codice, avere registri simulati, interpretare istruzioni CPU o inviare comandi a un servizio che lo faccia.

Ogni funzione viene ricostruita in termini di condizioni, dati letti, effetti, frasi e tempo impiegato. Un'operazione non capita rimane esplicitamente mancante. Le corrispondenze con indirizzi originali possono comparire nelle analisi e nei dati di provenienza, ma non selezionano routine da eseguire.

## Una richiesta concreta

1. `lexer.mjs` normalizza `OPEN DOOR`, cerca le parole nel dizionario e produce classi lessicali e identificatori.
2. `parser.mjs` produce un comando logico: verbo OPEN e gruppo nominale DOOR. Non sa ancora quale porta sia.
3. `game.mjs` riconosce il modello OPEN, cerca gli oggetti compatibili e filtra quelli percepibili su cui l'azione si applica.
4. Se le porte sono più di una, conserva il comando e il campo da precisare e stampa `WHICH DOOR ?`. `YOUR` completa quel gruppo nominale; `LOOK` lo sostituisce con un nuovo comando.
5. La regola ordinaria OPEN controlla serratura e stato. Quando riesce, aggiorna la proprietà della porta, produce `You open your door.` e assegna il costo dell'azione.
6. `world.mjs` aggiorna scadenza del giocatore e calendario. `session.mjs` fornisce alla presentazione i passaggi del minuto. Il ciclo comune è ora in `scheduler.mjs`; è collegata anche la parte verificata di Watson; gli altri programmi rimangono sospesi.

Aprire una cassaforte richiede una regola diversa. Il motore non usa OPEN generico quando incontra una regola speciale ancora sconosciuta.

## I moduli

| Modulo | Responsabilità |
|---|---|
| `lexer.mjs` | Dizionario, abbreviazioni, classi lessicali, numeri, denaro e ore |
| `parser.mjs` | Grammatica, coordinazioni, citazioni, modalità dichiarativa, continuazioni |
| `world.mjs` | Entità e contenitori, visibilità, movimento e luce |
| `scheduler.mjs` | Turni, ordine, scadenze, calendario, contesti sospesi, segnali e richieste |
| `watson.mjs` | Richieste, primo contatore storico, seguito autonomo, FOLLOW esplicito e saluti differiti |
| `cab.mjs` | Rete stradale, disponibilità e arrivo del cab; contesto successivo sospeso |
| `random.mjs` | Calcolo casuale su ingressi espliciti; modello degli ingressi ancora mancante |
| `tab-session.mjs` | Ripresa della partita JS dopo un cambio di motore nella stessa scheda |
| `text.mjs` | Formato dei testi compressi convertito in dati semantici, descrizioni ed elenchi |
| `game.mjs` | Risoluzione dei riferimenti, regole di azione, effetti e stato logico |
| `session.mjs` | Contratto locale con la UI e progressione visiva del tempo |
| `save.mjs` | Serializzazione logica e checksum |
| `spectrum.mjs` | Presentazione a caratteri, storia dei comandi, animazione e MORE |
| `app.mjs` | Collegamento a DOM, mappa, controlli e immagini |

`tools/serve.mjs` è un server statico. Accetta soltanto GET e HEAD e non dispone di un'API per eseguire comandi. `tools/play.mjs` utilizza direttamente gli stessi moduli del browser.

## Come dimostreremo l'equivalenza

Per ogni regola: analisi funzionale → implementazione JS → fixture indipendente dell'originale → confronto di frasi, stato modificato e tempo. Le fixture hanno un ambito dichiarato: un test senza turni NPC non dimostra la correttezza di quei turni. Non basta che la pagina sembri funzionare o che il verbo venga riconosciuto.

I primi confronti usano prove del parser e azioni isolate. Poi occorreranno tracce complete dello scheduler e degli attori. Per il caso casuale dovremo confrontare anche ogni estrazione e il suo contesto, prima di affermare che lo stesso seed produce la stessa partita.

Un interprete futuro delle sequenze NPC potrà essere autonomo: quel linguaggio descrive comportamenti del gioco e non la CPU. Dovrà usare operazioni di dominio comprese e documentate, senza richiamare routine macchina.

La seconda fase usa il ciclo anche per le singole esecuzioni espanse da ALL. Le prove del ciclo forniscono costi catturati: attestano il ciclo, non inventano il comportamento degli NPC. I dettagli sono in [FASE-2.md](FASE-2.md).

La terza fase introduce un contesto esplicito per l’attore nelle azioni condivise e una macchina a stati funzionale per Watson, senza bytecode originale. Ogni minuto conserva uno stato logico per presentazione e interruzione; i salvataggi versione 3 includono le continuazioni di Watson. Il profilo iniziale e la sospensione al confine della casualità sono dichiarati in [FASE-3.md](FASE-3.md).

La correzione descritta in [SALUTI-E-CAB.md](SALUTI-E-CAB.md) marca il primo messaggio narrativo di ogni azione del giocatore con `paragraph_before`; `session.mjs` lo converte nel CR precedente il testo. Le risposte degli NPC e i lotti dei minuti non creano paragrafi aggiuntivi. Il saluto casuale è ora sospeso con un avviso esplicito; la precedente variante temporale fissa è stata rimossa. La chiamata del cab muove il contenitore e i suoi discendenti; il programma del cocchiere rimane sospeso al confine non tradotto.

Il criterio vincolante è ora esplicitato in [FIDELITY.md](FIDELITY.md). La politica provvisoria del saluto temporale è stata rimossa; il modello non possiede ancora una sorgente casuale globale originale. Il selettore testuale tradotto in `random.mjs` è verificato con ingressi controllati e non viene collegato a ingressi sostitutivi. Le richieste HELLO citate sono bloccate prima di modificare il mondo.

I nuovi componenti `npc-program.mjs`, `npc-primitives.mjs`, `record-arena.mjs` e `cab-economy.mjs` costituiscono il kernel condiviso in costruzione. Sono verificati separatamente e non sostituiscono ancora il driver parziale usato dalla pagina. [NPC-FOUNDATIONS.md](NPC-FOUNDATIONS.md) distingue i risultati dai requisiti ancora da completare.
