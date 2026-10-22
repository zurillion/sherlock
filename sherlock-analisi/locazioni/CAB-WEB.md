# Il cab nella pagina web

Il prototipo ora esegue le visite dei due cocchieri, ID 31 e 34, attraverso lo scheduler Z80 originale. Richieste citate, viaggi differiti, tariffe, pagamento, resto e proteste sono prodotti dal gioco. Con l’integrazione di Watson e Lestrade è attivo l’intero scheduler: vedere [AI-WEB.md](AI-WEB.md). La selezione `Game(active_npcs=(31,34))` resta nelle regressioni isolate del cab; il server usa `None`, che abilita tutti gli attori. Il valore predefinito vuoto di `NativeWorld` mantiene disponibili le prove precedenti senza NPC.

## Una prova breve

1. Aprire la pagina, usare **Riavvia** e completare il MORE iniziale se si usa la modalità Spectrum.
2. Cercare `005` e cliccare Baker Street sulla mappa, oppure uscire normalmente con `OPEN YOUR DOOR`, `WEST`, `DOWN`, `OPEN FRONT DOOR`, `SOUTH`.
3. Inserire un comando per volta:

```text
HAIL CAB
GET INTO CAB
SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"
WAIT
WAIT
WAIT
GET OUT OF CAB
PAY 1/- TO CABBIE
```

La tariffa è 8d. Scendendo prima di pagare il cabbie protesta; pagando uno scellino rende 4d. I due cocchieri hanno segnaposti C1/C2, che si aggiornano insieme a quello di Holmes. Quando il cab entra nella locazione di transito 1 e quando arriva, la mappa inquadra la nuova posizione di Holmes. La normale navigazione manuale del grafo resta disponibile.

Un’altra destinazione valida è `SAY TO CABBIE "TAKE ME TO KINGS CROSS ROAD"`; usare un nome di strada della tabella, non il nome della stazione. La variante rapida è `SAY TO CABBIE "FURIOUSLY GO TO BUCKINGHAM PALACE ROAD"`: costa 2/- per questa tratta. Dettagli, tutte le rotte e le particolarità dei pagamenti anticipati sono in `../cab/LEGGIMI-CAB.md`.

WAIT fa avanzare il mondo. MORE, scrittura del testo, cambio di modalità e aggiornamento della pagina non fanno passare minuti. Ricaricare durante una corsa conserva il contesto del cocchiere nella sessione locale. **Riavvia** ricrea anche i programmi dei cocchieri e azzera i loro conti.

## Modifiche al ponte

- `native_world.py`: la visita a `$A097` salta solo gli NPC non abilitati. Per i cocchieri passano preparazione, ordini, VM, contesti sospesi e rischedulazione originali. L’analisi delle azioni registra anche l’ID dell’attore che le esegue.
- `explorer.py`: abilita tutti gli attori, inclusi i due cocchieri e Lestrade che può usare il cab per proprio conto. Per l’avvio gratuito alle 08:00am arretra insieme tick globale e scadenze degli attori di una unità, evitando che i cocchieri restino spostati di un tick rispetto al giocatore.
- Il salto sulla mappa usa l’azione interna 128 (`$E497`), che stacca l’entità dal genitore e propaga la posizione all’inventario. Questo evita una situazione incoerente in cui Holmes è stato teletrasportato altrove ma risulta ancora contenuto nel cab.
- `explorer-ui.js`: segue sulla mappa ingresso e uscita dalla locazione di transito. Le risposte del gioco restano in inglese in entrambe le modalità.
- `index.html`: aggiorna la legenda e la guida, indicando quali personaggi sono attivi e i comandi della corsa.

Il byte96 del set Spectrum viene reso come £ anche nella modalità normale, quindi COUNT e i pagamenti in sterline conservano il simbolo corretto.

Non c’è una nuova tabella Python di frasi o risposte sintetiche per il cab. I costi non sono timer del browser. Il motore conserva le particolarità riscontrate nell’originale, compreso il credito non automaticamente restituito in alcuni pagamenti anticipati.

## Verifiche

```sh
python3 -B sherlock-analisi/locazioni/verify_web_cab.py
python3 -B sherlock-analisi/locazioni/verify_restart.py
node sherlock-analisi/locazioni/verify_terminal.cjs
```

`verify_web_cab.py` controlla cammino naturale, chiamata e salita, ordine citato, transito, arrivo, scene, orologio, segnaposti, pagamento e resto, anticipo e rimborso richiesto, accelerazione, fuga senza pagare, letture dello stato durante la corsa, salto sulla mappa e ripristino. Un confronto separato abilita tutti gli NPC e confronta il ponte con il banco originale indipendente su 13 comandi, testi, clock e 11 record di entità.

Le prove del browser sono in `results/web-cab-browser-verification.json`; il rapporto Python è in `results/web-cab-verification.json`. Le schermate mostrano corsa, pagamento e resa nella modalità Spectrum.

Il confronto con il banco completo usa gli stessi input su entrambe le macchine, senza aggiungere LOOK a una sola delle due: la stampa originale può consumare scelte casuali e marcare entità come già menzionate. Le ispezioni durante il viaggio sono verificate separatamente per il mantenimento di contesti, destinazione e tempo.
