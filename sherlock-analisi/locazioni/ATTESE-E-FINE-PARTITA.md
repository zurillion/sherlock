# Attese, orologio e fine partita

## Il messaggio nello screenshot

`The command exceeded the execution limit.` era un errore del ponte Python, non una frase di Sherlock. Il vecchio `NativeWorld.submit` consentiva al massimo 9.000.000 di istruzioni per l’intero comando e annullava il comando quando il limite veniva superato.

La riproduzione controllata parte alle 18:24 e invia `WAIT UNTIL 9:00`: l’ora implicita è quella delle 21:00, non le 09:00 del giorno dopo. Il vecchio ponte raggiunge il limite e ripristina le 18:24. Lo stesso esperimento senza limite totale completa il comando in 10.876.581 passi. Il rapporto `results/evening-wait-until.json` confronta le due versioni sullo snapshot grezzo di `NativeWorld`: quel banco conserva il disallineamento iniziale di un tick e torna alle 20:59. La prova applicativa corretta in `results/wait-endgame-verification.json` completa invece tutti i 156 minuti e arriva alle 21:00.

Non è stato semplicemente alzato il limite totale. Il ponte ora restituisce il controllo dopo ogni minuto prodotto dal codice originale; mantiene una protezione di 9.000.000 di passi per fase senza avanzamento. Un vero blocco continua a essere segnalato e annullato. Gli avvisi tecnici vengono mostrati fuori dallo schermo virtuale, senza confonderli con le risposte originali inglesi.

## Durata e aggiornamenti dell’orologio

`WAIT` dura cinque minuti. `WAIT UNTIL` raggiunge l’ora scelta dal parser originale. Per esempio, da una nuova partita:

```text
WAIT
WAIT UNTIL 8:10AM
WAIT UNTIL 9:00AM
```

I suffissi devono essere attaccati all’ora: `9:00AM`, `9:00PM`. Con uno spazio, `AM`/`PM` sono parole separate e possono essere rifiutate dal dizionario originale. Non è stata aggiunta una correzione automatica della grammatica.

Il ciclo aggiorna il calendario con `$BFD9`, stampa l’orologio con `$BF79` e raggiunge `$A074`: qui `iter_submit` sospende la macchina e restituisce calendario e testo già prodotti. La pagina mostra quel minuto prima di chiedere il successivo. La pausa di presentazione minima di 100 ms rende visibili gli aggiornamenti; non determina il tempo del mondo. NPC, mezzi, dialoghi e scadenze continuano a essere calcolati dallo scheduler Z80.

La nuova API usa `/api/start-command` e `/api/continue-command`, con un identificatore del comando sospeso. `/api/command` rimane disponibile per gli script sincroni. Le ispezioni HTTP durante un’attesa leggono soltanto calendario e posizioni: le routine di descrizione, che usano i registri di lavoro, non vengono richiamate mentre lo scheduler è sospeso. Ricaricare la pagina riprende il comando ancora pendente nella stessa sessione.

### Perché prima risultavano quattro minuti

Lo snapshot di ricerca del primo prompt ha tick globale 2 e scadenza di Sherlock 1. Il precedente avvio gratuito arretrava entrambi di uno: tick 1, scadenza 0. Aggiungendo il costo nativo 5, il prompt successivo arrivava dopo quattro incrementi del calendario.

L’applicazione conserva l’avvio richiesto alle 08:00am, ma riallinea la scadenza del giocatore al tick corrente (1). WAIT aggiunge ancora il costo originale 5, raggiungendo tick 6 e le 08:05am. Le altre scadenze mantengono lo scarto già usato dal prototipo. Non sono modificati gli opcode delle azioni o dello scheduler. Il confronto indipendente riceve esplicitamente lo stesso stato iniziale.

La precedente traccia di ricerca che osservava un primo WAIT di quattro minuti sullo snapshot grezzo resta una misura corretta di quello stato. Non era una dimostrazione che WAIT avesse costo quattro; il costo cinque e il punto iniziale vanno distinti.

## Interruzione di WAIT UNTIL e MORE

Durante WAIT UNTIL si può premere **Invio** oppure **Interrompi**. Il ponte fornisce il codice ENTER `$8D` alla scansione chiamata da `$A07F`; i controlli `$A082`/`$A08A` del gioco interrompono l’attesa. Senza richiesta di interruzione viene fornito il risultato “nessun tasto”. Il percorso è confrontato con una seconda esecuzione che usa ROM, HALT e interrupt originali, senza questa scorciatoia del ponte.

WAIT semplice non è interrompibile. Se lo schermo è in pausa MORE, Invio è consumato dalla lettura e non interrompe WAIT UNTIL. Lo scorrimento delle parole e il MORE non avanzano il calendario. I lotti intermedi di uno stesso comando non aggiungono righe vuote: il separatore arriva una sola volta alla fine del comando.

## Percorsi terminali originali

Il passaggio comune `$9E74` riceve in HL il testo del finale. Il gioco lo stampa, attende la paginazione, ripristina la stampa e salta al caricamento `$B0AC`. Il ponte conserva il testo e si ferma prima dell’accesso al nastro, impostando `game_over` anziché annullare il mondo. QUIT viene riconosciuto al passaggio `$B0A6` e termina allo stesso confine.

Riferimenti dei testi osservati nel codice:

| Puntatore | Ramo |
|---|---|
| `$693A` | Valutazione negativa generica |
| `$69BF`, `$6A26` | Lestrade conclude il caso con esito insoddisfacente per Holmes |
| `$6A33`, `$6ABD` | Piani perduti e soluzione incompleta |
| `$6AF3` | Soluzione riuscita |
| `$6B79` | Morte |
| `$759C`, `$75D2` | Rami mortali delle casseforti |

Il gateway della soluzione ha intestazione `$9E48` e corpo `$9E4A`: controlla la presenza di Watson (3) e Lestrade (2). La prova automatica prepara **uno stato sintetico dichiarato**, posizionando gli attori e facendo invocare al programma di Basil quel gateway originale. Verifica il testo `$6AF3` e l’arresto terminale; non equivale ad avere completato il caso dall’inizio con soli comandi ordinari.

La prova di morte usa invece una nuova partita, un trasferimento via mappa alla locazione 58 e `OPEN WALL SAFE`. Il gioco produce il testo originale della scena e raggiunge `$9E74`, HL=`$759C`.

Dopo il finale, orologio, comandi e spostamenti sulla mappa sono congelati; rimangono lettura e MORE. **Riavvia** ripristina il mondo iniziale alle 08:00am. Ricaricare la pagina conserva e ripresenta il finale della sessione. Il server conserva le sessioni solo in RAM: riavviarlo le azzera. Ora SAVE/LOAD usano file JSON completi, ripristinabili anche dopo la fine partita o il riavvio del server; vedere SEED-E-SALVATAGGI.md. Servizi di stampa, PAUSE e timeout di inattività restano da adattare.

## Riprodurre le verifiche

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/locazioni/verify_wait_endgame.py
python3 -B sherlock-analisi/locazioni/verify_restart.py
python3 -B sherlock-analisi/locazioni/verify_web_ai.py
python3 -B sherlock-analisi/locazioni/verify_web_cab.py
node sherlock-analisi/locazioni/verify_terminal.cjs
```

Il nuovo script completa 16 controlli: durata, minuto per minuto, ora implicita serale, errori senza consumo temporale, interruzione, ispezioni innocue, token obsoleti, confronto dei 110 record di entità e delle 24 righe degli attori con interrupt reali, morte, gateway di vittoria, QUIT, riavvio e rollback di un autentico blocco. Restano superate le regressioni di riavvio (3), cab (11), AI (18, 77 comandi) e terminale (14).

I rapporti sono in `results/wait-endgame-verification.json` e `results/wait-endgame-browser-verification.json`, con le regressioni nei rispettivi JSON. Le prove browser osservano i minuti effettivamente mostrati e verificano finale, ricaricamento e riavvio. Rimane necessaria una partita completa riproducibile per certificare tutte le condizioni narrative di vittoria e fallimento.
