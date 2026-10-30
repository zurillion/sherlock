# Nomi delle destinazioni e residuo dello stack a $5D26

30 ottobre 2026. Il limite `$5D26` è ricostruito nel motore autonomo.
Il prefisso naturale confrontato con l’originale raggiunge ora 402 checkpoint
(0–401), sino a mercoledì 14:40, con tutti i 24 posti attore attivi.
Il prossimo operando sconosciuto è `$5D27`: viene letto alle 14:43,
nel checkpoint 402 che mira alle 14:50. I cinque finali naturali ancora
aperti e il limite separato del cab `$5D0C` non sono certificati da questa prova.

## Che cosa scrive davvero $5D26

La stessa cella fisica riceve registri diversi secondo la profondità della
chiamata al renderer `$C388`. Con frame `$5D2A`, `PUSH BC` in `$C389`
vi conserva C del chiamante, calcolato dallo shift della colonna. Questo
ruolo è corretto ma non identifica l’ultimo writer della partita naturale.

Al tick 964, nella frase con cui Lestrade ordina al cocchiere di andare a
Parliament Street, il prefisso «Inspector» usa quel frame. Successivamente
il testo dell’ordine compone il nome della destinazione attraverso
`A360 → A37D/A3DE → A745 → A4AB → A7BA → D405`.
Il soggetto della sola composizione citata è temporaneamente zero (`A036`):
per questo il probe registra attore 0 durante il writer, senza che Holmes
stia impartendo quell’ordine.

Il delimitatore dopo «Parliament» scarica il prefisso proprio mentre la
chiamata del nome locazione è ancora attiva: il frame del glifo è `$5D32`.
Il sostantivo «Street» rimane invece nel buffer e viene scaricato dopo il
ritorno. Applicare il frame del nome attore, oppure quello della locazione
all’intera frase, produce residui sbagliati anche quando il testo è identico.

L’ultimo store naturale è `PUSH AF` in `$C3B8`, alla scansione finale della
`t` di «Parliament»: SP `$5D28`, descrittore `$5C0B`, indirizzo video `$5035`,
colonna 24, shift 2, AF `$0000`. Il byte `$5D26` è F, non C. I flag sono
calcolati dalle operazioni `INC H` e `DEC/INC C` del renderer; non viene
installato lo zero osservato nella traccia come costante. La cuoca, attore 9,
legge questo residuo al tick 3192, mercoledì 13:11.

Per la stessa cella i frame verificati hanno sei ruoli: `$5D28` F chiamante,
`$5D2A` C chiamante, `$5D2C` E descrittore, `$5D2E` L video,
`$5D30` C scansione, `$5D32` F scansione. La CALL reale in `$C374` può
scrivere anche il proprio indirizzo di ritorno: non basta cercare i PUSH.

## Implementazione e confini

Il compositore JS delimita il prefisso proprio del nome locazione, incluso
lo spazio che lo scarica, e applica il contratto del frame verificato agli
ordini GO TO / GO FURIOUSLY TO stampati da CE13. Il sostantivo finale usa
il contesto ripristinato. Nomi o chiamanti senza contratto revocano la
proprietà del byte. I vecchi LOAD senza `$5D26` restano sconosciuti finché
un writer compreso non lo riscrive. `$5D25` e `$5D27` restano non posseduti:
la vicinanza e il valore del probe non autorizzano a inventarne lo stato.

Superato questo ingresso è emersa un’omissione dell’estrazione: `$9920`
è l’FF immutabile dopo le 24 righe attore di 8 byte da `$9860`.
Ora viene esportato dal payload e verificato dal builder. Se il metadato
manca, il lettore restituisce sconosciuto; nessun fallback FF per vecchi dati.

## Prove ripetibili

- `tools/probe-room-name-stack.py`: esecuzione originale offline, seed 1,
  76 input, tutti gli attori, grafica disabilitata, tasti maiuscoli iniettati
  e MORE immediato. Registra anche store invariati e CALL/EX(SP),HL.
  Nessuna transizione non classificata; osservazione fino a mercoledì 16:00.
  Questo termine del probe non è una certificazione completa del modello.
- `test/room-name-stack.test.mjs`: 1.728 ABI originali archiviati, 1.152
  varianti di descrittore, proprietà/invalidazione/LOAD, composizione del
  nome e confronto del writer e della lettura naturali. I casi controllati
  non sono presentati come altrettante partite naturali.
- `tools/verify-witness-prefix.mjs`: 402 checkpoint, 7.959 draw e 17.042 read
  confrontati, scheduler, entità, fatti, intera arena da 752 byte, bitmap
  esatte e futuro dopo LOAD. Nessun teletrasporto o patch del mondo.
  Il contatore finale 7.961 comprende anche le due estrazioni di avvio;
  7.959 è il numero confrontato nei checkpoint.
- 109 test mirati passati, zero errori, comprendendo il dossier precedente
  del descrittore e i controlli della mappa. La suite completa è eseguita
  da GitHub Actions sul commit pubblicato.

Il runtime non esegue Z80 e non legge le tracce: queste restano prove offline.

## Atlante

Il listing commentato verifica 324 istruzioni Z80, 616 byte elencati,
compresi i dati tipizzati. Passano da grigi a documentati 40 byte:
`$A360–$A37C` (soggetto temporaneo della citazione) e `$A7BA–$A7C4`
(ingresso del nome locazione). Sono approfonditi `$A37D–$A418`,
`$C388–$C3E3`, `$D3E8–$D447`, `$CE10–$CE17`, `$9920` e il workspace
`$5D26`, oltre ai ponti del testo elencati nel rapporto JSON.
Totali: 38.569 byte documentati, 466 parziali, 2.565 ancora grigi su 41.600.
Questa copertura statica non equivale alla copertura completa del gameplay.

Artefatti: `results/room-name-stack/`,
`results/room-name-stack-verification.json`.
