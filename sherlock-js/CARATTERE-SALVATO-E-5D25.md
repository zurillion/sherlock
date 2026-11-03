# `$5D25`: il carattere salvato dal chiamante

Questo lavoro supera la lettura che arrestava la continuazione Brown mercoledì
alle 11:41. Il dato viene ricostruito dal carattere effettivamente emesso dal
renderer JavaScript; non viene assegnato il valore 110 osservato nella partita.
L'eseguibile originale rimane un oracolo offline, separato dal motore giocabile.

## Traccia naturale estesa

La precedente traccia su `$5D24/$5D25` terminava al tick 3012, mercoledì 10:11.
Non bastava a dimostrare la provenienza alla successiva lettura delle 11:41.
Il nuovo osservatore ripete dal prompt originale completo di Mrs Jones gli
stessi comandi ordinari e le attese, con tutti i 24 posti attore attivi, senza
patch di RAM, registri, posizioni, programmi o prove. Osserva dal tick 1649,
prima del writer, fino alla lettura effettiva al **tick 3102, mercoledì 11:41**.

Le scritture osservate sono **904 su `$5D24/$5D25`**, 452 per byte, comprese
quelle che riscrivono lo stesso valore. Non ci sono transizioni non classificate.
La sequenza completa degli store è identica a quella della traccia precedente:
nessun ulteriore store sostituisce quei byte fra le due letture.

L'ultimo writer di `$5D25` è **`$C388: PUSH AF`**, Holmes 0, tick 1653,
**martedì 11:32**, durante la `n` di `plain` nel prefisso del passaggio della
cucina di Tricia. SP all'ingresso è `$5D26`, AF=`$6E0A` e il return `$D65B`
identifica la chiamata del passaggio. Il giardiniere 8 legge quindi **A=110**,
non F=10 e non un byte della scansione del font.

## L'algoritmo e i ruoli distinti

Il canale superiore confronta il carattere con CR in `$C2C6: CP $0D`:
questa istruzione modifica F, preservando A. JR NZ e `$C2EE: CALL $C388`
conservano entrambi fino al PUSH AF iniziale. Nel frame `$5D26` vengono salvati
F a `$5D24` e A a `$5D25`. Il decoder carica poi altri valori in A dal font;
questi non sostituiscono il carattere già salvato in quel frame.

JavaScript trasferisce il codice del carattere al campo soltanto nel chiamante
verificato. Durante `plain` conserva quindi i codici 112, 108, 97, 105 e 110;
sono il risultato della normale emissione dei caratteri, non una tabella del
percorso. Con un altro testo cambia il parametro del renderer.

| SP all'ingresso C388 | Ruolo di `$5D25` |
| --- | --- |
| `$5D26` | A del chiamante, qui il carattere |
| `$5D28` | B del chiamante |
| `$5D2A` | D del descrittore |
| `$5D2C` | H dell'indirizzo video |
| `$5D2E` | B della scansione del font |
| `$5D30` | A grezzo della scansione |

La vera CALL di pulizia `$C374`, con frame `$5D24`, lascia invece C3 del return
`$C377` a `$5D25`. Il return sintetico `$0008` delle chiamate ABI dirette
non costituisce una prova di quel ruolo. I contratti già ricostruiti degli
altri frame restano validi; il nuovo contratto non rende 25 sempre un carattere.

## Ambito e prove

Sono riutilizzate, con hash e senza modificarle, **1.296 configurazioni ABI
originali** dei sei ruoli. Il test del contratto JavaScript esercita inoltre
i 96 codici di glifo supportati e verifica che conoscere A non promuova F:
questo test parametrico non è una nuova acquisizione nativa di 96 glifi.

Le prove complete già acquisite fino al marcatore `$5D25` vengono ispezionate
per quel byte indipendentemente dai vicini:

- **720 configurazioni D60B**: movimento/LOOK, 36 colonne, due stati coerenti
  degli spazi e cinque classi nominali con il qualificatore del setup invariato.
  Tutti i 290 valori dichiarati noti coincidono; gli altri 430 restano ignoti.
- **1.512 arrivi CBC2**: i 720 casi eleggibili, arrivo ordinario di persona
  propria senza qualificatori attivi, conservano 25. Tutti i 792 casi non
  eleggibili del controllo cambiano il marcatore: nessuna conservazione generale.
- **138 pipeline originali di errore**: i 129 rifiuti eleggibili conservano 25;
  cinque dei nove casi non eleggibili lo cambiano. Si tratta delle direzioni
  semplici e dei riferimenti semplici EXAMINE assenti, con giocatore nella
  stanza principale senza prosa da cercare.

Le configurazioni controllate non certificano la raggiungibilità naturale di
ogni setup. La nuova proprietà del prefisso richiede movimento, frame `$5D26`,
giocatore fuori dai contenitori e nome grezzo verificato. LOOK, descrizioni
remote e contenitori restano fuori; i caller accodati, isolati e `relocate`
non ricevono la conservazione dell'arrivo ordinario.

BC/HL/DE salvati dal prologo di `$C316` possono sovrascrivere 25 anche se il
glifo interno non lo tocca. Pulizie profonde non proiettate, wrap del sostantivo
finale ancora nel buffer e nomi/prose successivi con chiamante sconosciuto
revocano la nuova proprietà. Chiarimenti, ricerche nella prosa, richieste a NPC
e altri errori non ereditano il contratto dei rifiuti semplici.

Conoscere F=10 a `$5D24` non determina A: molti caratteri condividono gli stessi
flag. Un vecchio SAVE privo di `$5D25` lo mantiene sconosciuto anche dopo un
messaggio che lo conserva. Una nuova scrittura ricostruita lo rende noto;
SAVE/LOAD ne conserva poi il valore e il futuro. Il test breve esegue 12 comandi
ordinari da un SAVE prodotto dal solo JavaScript prima del writer, osserva i
caratteri di `plain` e confronta anche le azioni successive dopo LOAD.

## Atlante e riproducibilità

Il dossier `results/passage-caller-a-25/passage-caller-a-25.asm` riassembla
**295 istruzioni / 524 byte**, confrontati con il payload. Approfonditi
**`$C2BA–$C305`, `$C316–$C387`, `$C388–$C3E3`, `$D60B–$D670`,
`$CBC2–$CC0A`, `$C1FD–$C23F`** e il workspace `$5D25`; mantenute anche le
annotazioni precedenti sui salvataggi del video.

Nessun byte cambia classificazione e nessun nuovo grigio viene documentato:
restano 39.364 documentati, 428 parziali e 1.808 ignoti su 41.600. Copertura del
payload ed equivalenza del gameplay rimangono misure distinte.

Strumenti, hash e risultati sono in `results/passage-caller-a-25/`;
il riepilogo definitivo è `results/passage-caller-a-25-verification.json`.

## Esito conclusivo e prossimo limite

Il nuovo certificato comprende **500 checkpoint (0–499) fino a mercoledì
13:10**, 7.755 estrazioni e 16.512 letture confrontate, 7.757 estrazioni runtime
incluse le due iniziali. Sono confrontati tutti i 24 posti attore, entità,
fatti, programmi, arena di 752 byte e bitmap ai checkpoint; il futuro dopo
LOAD è confrontato anche a ogni minuto delle attese.

La continuazione originale riprende il prompt completo Brown delle 11:36:
163 checkpoint si aggiungono ai primi 338. Tutti i **491 checkpoint originali
precedenti sono identici e passano interamente**. I campioni aggiuntivi ai
tick 2928, 3014 e 3104 conservano soltanto i precedenti confini di acquisizione,
senza modificare l'esecuzione del gioco.

Il primo checkpoint escluso è 500, originale mercoledì 13:16: la cuoca 9
legge **`$5D20=11`**. Il modello si ferma al tick 3195, **mercoledì 13:14**.
La provenienza di questo nuovo ingresso non è ancora stata tracciata: non va
dedotta dal valore 11, da un frame vicino o dall'ultimo writer di `$5D25`.

La baseline del finale `$6A33` è stata ripetuta sul codice finale: 521 checkpoint
fino a giovedì 10:00, 10.345 estrazioni e 22.058 letture confrontate, 10.347
estrazioni runtime incluse le due iniziali, pausa terminale e congelamento
verificati. L'oracolo terminale è riutilizzato con hash. Il finale naturale
`$6ABD` e gli altri finali pendenti restano aperti; questa storia conserva
viaggi falliti e prova Brown non recuperata. L'esito della suite completa è
registrato nel report definitivo e nel suo log.

Suite conclusiva: **1.883/1.883 PASS**, nessun errore, salto o cancellazione.
