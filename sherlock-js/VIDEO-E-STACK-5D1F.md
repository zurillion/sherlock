# Il byte alto del video nello stack: `$5D1F`

## Provenienza originale

Il limite precedente era la lettura di `$5D1F` da parte della cuoca (attore 9),
mercoledì alle 02:45. Il valore80 non autorizzava a dedurre né il suo ruolo né
la sua provenienza dal byte vicino già ricostruito.

La nuova traccia riparte dal prompt originale completo della conversazione con
Mrs Jones. Ripete i comandi ordinari e le attese, con tutti gli attori attivi.
L'osservatore viene attivato al tick 1649 (martedì 11:28), prima della scena che
interessa. Registra le scritture su `$5D1E/$5D1F`, comprese quelle che non
cambiano il valore: **974 store e zero transizioni non classificate** nella
finestra osservata. Non attribuisce provenienza ai valori precedenti.

L'ultimo scrittore di `$5D1F` è **`$C398: PUSH HL`**, con SP prima dello store
`$5D20`. L'ingresso del renderer `$C388` era a `$5D26`; il glifo è la **n di
plain**, colonna21, durante «To the north there is a plain door.» nella cucina
di Tricia. Holmes è l'attore 0, il tick 1653 corrisponde a martedì 11:32 e il
return link `$D65B` identifica la chiamata `$D658 → $D3D5` dei passaggi.

HL vale `$5032`: `$5D1E` riceve L, mentre **`$5D1F` riceve H**. Lo stesso
indirizzo è salvato prima a `$C38B`, ripristinato dopo la ricerca del font e
salvato nuovamente a `$C398`. Non è il byte della bitmap né l'ultima riga del
font. La lettura originale osservata avviene al tick 2566, mercoledì 02:45,
molte ore dopo la scrittura.

## Calcolo e ambito della ricostruzione

L'indirizzo segue la geometria già ricostruita del renderer:

```js
const x = 2 + 7 * column;
const videoAddress = 0x5020 + Math.floor(x / 8);
const savedH = videoAddress >>> 8;
```

Il modello deriva quindi H dal cursore del glifo. In questo percorso H vale80;
non viene installato un80 di inizializzazione o di ripiego. Il valore di quel
medesimo byte ha altri significati con altri frame: per esempio, con SP
`$5D2A`, `$5D1F` contiene A grezzo dell'ultima scansione del font.

`Text.scene` rende noto questo nuovo ruolo solo nel prefisso qualificato del
passaggio dopo movimento, con frame `$5D26`, nome grezzo verificato e giocatore
fuori da contenitori. LOOK usa un frame differente; descrizioni remote,
contenitori e altri chiamanti non ricevono una proprietà per analogia.
Una pulizia a profondità diversa può revocare il campo: non basta avere visto
prima un glifo del passaggio per conservarne sempre il risultato.

La proprietà di `$5D1F` è indipendente da quella di `$5D1E`. I messaggi possono
conservare il primo lasciando il secondo sconosciuto, anche se l'originale li
aveva scritti con la stessa istruzione. Le prove non vengono trasferite da un
byte all'altro.

## Conservazione dopo la scrittura

Le prove ABI originali del lavoro precedente sono state ripetute estendendo i
marcatori fino a `$5D1F`:

- **720 configurazioni dei passaggi**: arrivo/LOOK, 36 colonne, due stati coerenti
  di spazio/capitalizzazione, cinque classi del sostantivo. Ogni valore che il
  modello dichiara noto coincide con l'originale; gli altri restano sconosciuti.
- **1.512 configurazioni degli arrivi**: i 720 casi eleggibili con nome proprio
  semplice conservano tutti e sei i marcatori. Fra i nomi non eleggibili ci
  sono 128 controesempi; nessuna conservazione generalizzata ai nomi composti.
- **138 comandi originali completi**, con stato ripristinato per ciascun caso:
  i 129 rifiuti eleggibili conservano anche `$5D1F`. Sono direzioni semplici e
  riferimenti EXAMINE/CLOSELY EXAMINE assenti, senza qualificatori, con il
  giocatore fuori da contenitori e la stanza priva di prosa da cercare.

Questi setup controllati provano il contratto locale; non certificano che ogni
combinazione sia raggiunta in una normale partita. Arrivi accodati/isolati,
`relocate`, chiarimenti, ricerche nella prosa e altri errori non vengono
inclusi. La metadatazione del messaggio sceglie soltanto un contratto verificato:
non fornisce il valore casuale.

SAVE conserva i byte già derivati e LOAD li ripristina. Un vecchio SAVE privo
di `$5D1F` resta sconosciuto anche dopo un messaggio che preserva il campo:
serve una nuova scrittura ricostruita. Il motore non importa snapshot originali,
non esegue codice Z80 e non riproduce sequenze registrate.

## Mappa ed evidenze

Approfonditi **`$C388–$C3E3`** (salvataggio diHL e ruolo del frame),
**`$D60B–$D670`** e **`$D3D5–$D447`** (chiamante del prefisso),
**`$CBC2–$CC0A`** e **`$C1FD–$C23F`** (conservazione nei chiamanti verificati).
Il workspace ha ora una voce specifica per `$5D1F`.

Sono approfondimenti di zone già documentate: **nessun nuovo byte grigio**.
Il disassemblato tipizzato contiene240 istruzioni / 449 byte, confrontati con il
payload e riassemblati. La copertura resta39.206 documentati, 428 parziali e
1.966 ignoti su 41.600 byte. Documentazione del payload ed equivalenza del
comportamento restano misure distinte.

Gli strumenti riproducibili e i risultati sono in `results/stack-high-1f/`;
il riepilogo è `results/stack-high-1f-verification.json`. Il log
`preliminary-missing-evidence-tests.log` registra un errore di setup nel
percorso dell'input ABI, corretto prima delle prove finali; non è un risultato
positivo. I file finali usano gli snapshot originali già acquisiti in
`results/list-stack-1c/`, senza crearne copie runtime.

## Esito finale e prossimo limite

Il percorso originale precedente di 433 checkpoint fino a mercoledì 02:47 passa
interamente. La continuazione mattutina riacquisita dal prompt completo delle
11:36 contiene 124 checkpoint; i 432 checkpoint sovrapposti al precedente oracolo
sono identici. Non ci sono patch di posizioni, attori, prove o indizi.

Il prefisso positivo esteso comprende **461 checkpoint (0–460) fino a
mercoledì 07:30**, 6.858 estrazioni e 14.610 letture confrontate, 6.860 estrazioni
runtime incluse le due iniziali. Sono confrontati tutti i 24 attori, arena di 752 byte,
bitmap e pacchetti dello schermo ai checkpoint. Il futuro dopo LOAD è verificato
anche a ogni minuto delle attese.

Il primo checkpoint escluso è 461, che nell'originale termina alle 07:38 e legge
`$A022=0` per la cuoca 9. Il modello si arresta alle 07:36: il read nativo non
riceve un timestamp più preciso di quello acquisito nel checkpoint. `$A022`
espone il riferimento corrente del dizionario; il prossimo lavoro deve trovare
il suo ultimo scrittore naturale, senza installare uno zero. Gli store `$A88C` e
`$A8B5` sono punti di partenza, non ancora una prova della provenienza in questa storia.

**Suite finale: 1.852/1.852 PASS**, zero errori, test saltati o cancellazioni. Baseline
`$6A33` ripetuta sul codice finale: 521 checkpoint fino a giovedì 10:00,
10.345 draw / 22.058 read confrontati, 10.347 draw runtime incluse le due iniziali,
pausa terminale e congelamento verificati. L'oracolo di quel finale è
riutilizzato con hash; la nuova acquisizione riguarda questa continuazione.
Il finale naturale `$6ABD` e gli altri finali pendenti restano da certificare:
questa storia mantiene i viaggi falliti e la prova Brown non recuperata.
