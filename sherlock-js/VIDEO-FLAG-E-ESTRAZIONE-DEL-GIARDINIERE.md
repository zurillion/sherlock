# Due operandi della stessa estrazione: `$5D1E` e `$5D24`

Il limite precedente arrestava il modello mercoledì alle 10:11 su `$5D1E`.
Ricostruire il primo byte ha rivelato un secondo ingresso sconosciuto nella
**stessa estrazione del giardiniere 8**, `$5D24`. Questo lavoro ricostruisce
entrambi, con algoritmi e ambiti indipendenti. Il runtime rimane JavaScript
standalone; CPU e snapshot originali vengono usati soltanto offline come prove.

## Provenienza naturale

Le due tracce ripartono dal prompt originale completo della conversazione con
Mrs Jones, senza modifiche a RAM, registri, programmi degli attori, posizioni o
prove. Eseguono i comandi ordinari del percorso Brown e le attese. L'osservatore
parte al tick 1649, martedì 11:28, prima della stampa pertinente; registra anche
le scritture che ripetono il valore precedente.

| Ingresso letto | Scrittore finale | Stato della scrittura | Lettura |
| --- | --- | --- | --- |
| `$5D1E = 50` | `$C398: PUSH HL` | Holmes 0, `n` di `plain`, HL=`$5032` | Giardiniere 8, mercoledì 10:11 |
| `$5D24 = 10` | `$C388: PUSH AF` | Holmes 0, stessa `n`, AF=`$6E0A` | Stessa estrazione, dopo `$5D1E` |

Entrambi i writer avvengono al tick 1653, **martedì 11:32**. Il renderer
`$C388` entra con SP=`$5D26`; il return `$D65B` identifica il prefisso del
passaggio, «To the north there is a plain door.» nella cucina di Tricia.
Le tracce osservano **974 scritture su `$5D1E/$5D1F`**, 487 per byte, e
**904 su `$5D24/$5D25`**, 452 per byte: nessuna transizione non classificata.
La lettura dei due operandi è ora osservata direttamente al tick 3012,
mercoledì 10:11; il precedente campione delle 10:13 non offriva quella precisione.

## I due algoritmi

`$5D1E` conserva il byte basso dell'indirizzo video del glifo:

```js
const x = 2 + 7 * column;
const address = 0x5020 + Math.floor(x / 8);
const savedL = address & 255;
```

Per la `n` in colonna 21 si ottiene 50. Le geometrie controllate producono
19 valori noti distinti: non è installato un 50 fisso e non si ricava il byte
dalla conoscenza del vicino `$5D1F`. Con un frame diverso `$5D1E` può conservare
F o C del chiamante, E del descrittore, C della scansione o F della scansione.
Questi ruoli preesistenti rimangono distinti dal nuovo contratto del passaggio.

`$5D24` conserva invece F del chiamante. Il canale superiore esegue
`$C2C6: CP $0D`, seguito da JR NZ e `$C2EE: CALL $C388`, che preservano i flag.
Il loro valore viene calcolato dal confronto Z80, compresi i bit X/Y derivati
dall'operando: **`n` produce 10, `q` produce 26**. Il caso della pulizia usa
un'altra provenienza dei flag e non eredita il contratto del carattere ordinario.
Con `$5D24`, i frame `$5D26/$5D28/$5D2A/$5D2C/$5D2E/$5D30` conservano
rispettivamente F chiamante, C chiamante, E descrittore, L video, C scansione e
F scansione. Il ruolo E già ricostruito rimane valido nel suo chiamante.

Sono riutilizzate con hash **1.296 configurazioni ABI originali per ciascun
indirizzo**, selezionando i sei frame pertinenti. Il vettore originale di tutti
256 confronti CP viene riutilizzato dal dossier del caller F; il nuovo test
confronta la proiezione per tutti i glifi disponibili, senza attribuire al
renderer il supporto per caratteri di controllo o glifi inesistenti.

## Proprietà e conservazione

Il nuovo ambito è il prefisso del nome del passaggio dopo movimento, giocatore
nella stanza principale, con nome grezzo verificato e frame `$5D26`. LOOK usa
un'altra profondità; descrizioni remote, contenitori e altri chiamanti restano
fuori da questo nuovo contratto.

Sono state acquisite nuove prove originali, estendendo i marcatori fino a `$5D25`:

- **720 configurazioni D60B**: arrivo/LOOK, 36 colonne, due stati coerenti degli
  spazi e cinque classi del sostantivo, con il qualificatore del setup invariato.
  Il modello dichiara noti 290 valori per ciascun ingresso, tutti coincidenti;
  gli altri 430 casi per campo rimangono sconosciuti.
- **1.512 arrivi CBC2**: tutti i 720 casi eleggibili con persona propria senza
  qualificatori attivi conservano i marcatori, inclusi `$5D1E` e `$5D24`.
  Fra i casi non eleggibili ci sono controesempi. I caller accodati, isolati e
  `relocate` non ricevono questo contratto.
- **138 pipeline di comandi originali complete**: 129 rifiuti eleggibili
  conservano i due campi. Sono direzioni semplici e EXAMINE/CLOSELY EXAMINE
  assenti semplici, senza ricerca nella prosa, qualificatori o richiesta a NPC.

Queste prove controllate non dimostrano la raggiungibilità naturale di ogni
configurazione. Il nuovo contratto non introduce `$5D25` nel runtime anche se
il marcatore di quel byte è stato acquisito e conservato nelle prove.

`$C316` salva BC/HL/DE anche sopra il frame del glifo di pulizia. Questi store
possono sostituire un valore precedentemente corretto. Il modello revoca la
proprietà per le pulizie non proiettate, i wrap del sostantivo finale ancora
nel buffer e i successivi nomi/prose con chiamante sconosciuto. Le proprietà
di `$5D1E`, `$5D1F`, `$5D23`, `$5D24` e `$5D25` rimangono indipendenti.

SAVE/LOAD conserva i valori derivati e i loro successivi effetti. Le assenze
nei vecchi salvataggi restano sconosciute, anche dopo un messaggio che conserva
il campo: serve una nuova scrittura ricostruita. Il test breve riprende un SAVE
prodotto dal solo JavaScript prima del writer, esegue 12 comandi ordinari,
ricostruisce 50 e 10 e confronta le azioni successive anche dopo LOAD.

## Mappa e riproducibilità

Il disassemblato `results/stack-low-1e/stack-low-1e.asm` contiene **295 istruzioni
/ 524 byte**, confrontati con il payload e riassemblati. L'atlante approfondisce
**`$C2BA–$C305`, `$C316–$C387`, `$C388–$C3E3`, `$D60B–$D670`,
`$CBC2–$CC0A`, `$C1FD–$C23F`** e le due voci del workspace.
Non si aggiungono byte prima grigi: 39.364 documentati, 428 parziali e 1.808
ignoti su 41.600. La copertura del codice non equivale alla parità di gameplay.

I risultati e gli strumenti sono in `results/stack-low-1e/`, con la seconda
traccia e le nuove ABI nella sottocartella `flags-24/`. Gli esiti intermedi
`low-only-*` mantengono esplicito il vecchio arresto sul secondo operando;
il log preliminare segnala soltanto la prova di provenienza ancora in corso
al momento del primo test. Il riepilogo definitivo è
`results/stack-low-1e-verification.json`, con confronto esteso, hash, suite,
baseline terminale e prossimo limite.

## Esito conclusivo

Il confronto positivo comprende **490 checkpoint (0–489) fino a mercoledì
11:40**, 7.525 estrazioni e 16.046 letture, 7.527 estrazioni runtime incluse
le due iniziali. Sono confrontati tutti i 24 posti attore, entità, fatti,
programmi, arena di 752 byte e bitmap ai checkpoint; il futuro dopo LOAD è
confrontato anche a ogni minuto delle attese. I 481 checkpoint originali
precedenti restano identici e passano ora tutti nel modello.

Il primo checkpoint escluso è 490, originale mercoledì 11:43: il giardiniere
8 legge `$5D25=110`. Il modello si ferma alle **11:41, tick 3102**. La nuova
traccia su 24/25 termina alla lettura precedente delle 10:11: non dimostra
quale scrittura sia arrivata fino a questa lettura successiva. Occorre estenderla,
senza inferire il writer dal vicino o dalla coincidenza del valore 110.

**Suite finale: 1.876/1.876 PASS**, nessun errore, salto o cancellazione.
Ripetuta sul codice finale la baseline `$6A33`: 521 checkpoint fino a giovedì
10:00, 10.345 estrazioni e 22.058 letture confrontate, 10.347 estrazioni runtime
incluse le due iniziali, con pausa terminale e congelamento verificati.
L'oracolo terminale è riutilizzato con hash, non una nuova acquisizione di quel
finale. Il finale naturale `$6ABD` e gli altri finali pendenti restano aperti;
questa storia mantiene i viaggi falliti e la prova Brown non recuperata.
