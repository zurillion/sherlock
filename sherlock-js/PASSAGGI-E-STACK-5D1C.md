# Passaggi, annunci ed errori: il byte `$5D1C`

## Origine del blocco

Il precedente confronto si fermava martedì alle 19:55, quando il giardiniere
(attore 8) leggeva `$5D1C` durante un'estrazione casuale. Il valore originale
osservato era 5. Quel 5 non è una costante dell'AI e non è stato introdotto come
ripiego nella ricostruzione.

La traccia originale riparte dal prompt completo della confessione di Mrs Jones,
esegue gli stessi comandi ordinari e osserva tutte le scritture su `$5D1C/$5D1D`
a partire dal tick 1649 (martedì 11:28). Registra anche le scritture che lasciano
invariato il valore: 1.578 store e nessuna transizione non classificata nella
finestra osservata. Non pretende di ricostruire gli scrittori precedenti.

L'ultimo store è `PUSH BC` a `$C3B7`, con ingresso del renderer `$C388` e SP
`$5D26`. Avviene al tick 1653, martedì 11:32, mentre Holmes entra nella cucina
di Tricia e viene stampato «To the north there is a plain door.». Il glifo è
la **n di plain**, colonna 21. Il formatter scarica il qualificatore quando
riceve il sostantivo successivo; door resta temporaneamente nel buffer.

Il byte C salvato vale `(2 + 7 * colonna) & 7`, quindi 5 in questo caso.
Il B adiacente vale 1 perché viene salvato prima dell'ultimo `DJNZ` della
scansione del font. Il return link `$D65B` identifica il chiamante: la stampa
del passaggio `$D60B`, che chiama `$D3D5` a `$D658`. Quasi otto ore e mezza dopo,
al tick 2156 (19:55), il generatore legge ancora quel residuo. Il checkpoint
originale termina alle 19:56, dopo l'avanzamento del minuto.

## Ricostruzione autonoma

`Text.scene` descrive il ruolo del prefisso qualificato della porta; la
proiezione del renderer calcola i registri dalla colonna, dal font e dal
chiamante. Il frame differisce di quattro byte fra arrivo e LOOK. La traccia
viene resa nota soltanto quando la derivazione grezza del nome coincide con il
nome effettivo. Passaggi remoti e descrizioni da dentro un contenitore non
ricevono questo nuovo contratto.

La correzione richiede anche di conservare i byte quando l'originale non li
sovrascrive. Il precedente modello li revocava sia dopo «Watson enters.» sia
dopo normali rifiuti nell'area inferiore. La conservazione ora è circoscritta:

- L'arrivo prodotto da un'azione NPC ordinaria conserva `$5D1A–$5D1D` se il
  soggetto è una persona con nome proprio e senza qualificatori attivi. Il
  chiamante accodato/isolato e il percorso `relocate` restano distinti.
- I rifiuti del movimento direzionale semplice del giocatore conservano i
  medesimi byte. Anche EXAMINE/CLOSELY EXAMINE di un riferimento semplice
  assente li conserva quando Holmes è fuori da contenitori, non al buio, in
  una stanza senza testo descrittivo da cercare.
- Nomi composti, chiarimenti, riferimenti qualificati e altri chiamanti non
  verificati continuano a revocare la proprietà. La conservazione di un byte
  sconosciuto non lo rende noto.

Il formato SAVE non cambia: i byte già derivati sono salvati; quelli assenti
nei vecchi salvataggi restano sconosciuti fino a un vero scrittore.
Nessun interprete CPU, snapshot originale o elenco di risposte entra nel gioco.

## Prove originali controllate

I setup ABI sono prove locali dell'algoritmo, non partite naturalmente raggiunte:

- **720** chiamate `$D60B`: frame reali di arrivo/LOOK, 36 colonne, due stati
  coerenti di spazio/capitalizzazione e cinque classi del sostantivo.
- **1.512** chiamate `$CBC2`: persone iniziali, varianti del sostantivo e
  nomi propri semplici sintetici, 36 colonne. I 720 casi eleggibili conservano
  il marcatore; i nomi composti comprendono controesempi e restano esclusi.
- **138** comandi originali completi dal prompt della cucina, con RAM,
  registri e stack dell'editor ripristinati per ciascun caso. I 129 rifiuti
  eleggibili conservano i quattro marcatori. Il budget di fallimenti è
  esplicitamente controllato; il comando può comunque far avanzare il mondo.
  Gli altri esiti sono registrati, non conteggiati come prove di conservazione.

I log `geometry-tests.log` e `arrival-low-abi.log` documentano tentativi
preliminari: rispettivamente un setup incoerente di capitalizzazione e un
controesempio al tentativo di includere nomi composti. Non sono risultati
positivi. Fanno fede i report JSON finali e i test sul codice finale.

## Mappa della memoria

Nuova zona prima grigia: **`$CBC2–$CC0A`**, 73 byte, annuncio di arrivo,
risalita dei contenitori, soggetto e controlli di visibilità.

Approfondite zone già documentate:

- `$D60B–$D670`: descrizione dei passaggi e chiamante del nome della porta;
- `$D3D5–$D447`: formatter dei nomi qualificati;
- `$C388–$C3E3`: renderer dei glifi e registri salvati;
- `$C1FD–$C23F`: percorso del canale inferiore negli errori ordinari;
- workspace `$5D1C`: provenienza e condizioni di conservazione, distinto dal
  contratto del byte adiacente `$5D1D`.

Il nuovo estratto tipizzato contiene 240 istruzioni, 449 byte, tutti confrontati
con il payload e riassemblati. Copertura dell'atlante: **39.206 documentati,
428 parziali, 1.966 ignoti**, su 41.600 byte. Questo misura la documentazione
del payload, non l'equivalenza dell'intero gameplay.

## Evidenze e continuazione

I file riproducibili sono in `results/list-stack-1c/`; il riepilogo finale è
`results/list-stack-1c-verification.json`. La prima prova completa supera tutti
i 390 checkpoint fino a martedì 19:56, con ogni draw/read, 24 attori, arena
752 byte, bitmap, pacchetti dello schermo e futuro dopo LOAD.

La ricerca JavaScript prosegue fino a mercoledì 02:45, dove si ferma su
`$5D1F`. Il relativo confronto esteso e i conteggi finali sono nel riepilogo:
l'orario raggiunto dalla sola ricerca non è un certificato. Il prossimo lavoro
è trovare il vero scrittore di quel byte, senza inferirlo dal vicino `$5D1E`.
Il finale naturale `$6ABD` e gli altri finali aperti restano da certificare.

Confronto esteso finale: **432 checkpoint (0–431) fino a mercoledì 02:40**,
6.079 estrazioni e 12.928 letture confrontate, 6.081 estrazioni runtime incluse
le due iniziali. I primi 389 checkpoint originali sovrapposti sono identici
all'acquisizione precedente. Il checkpoint 432, che nell'originale termina
alle 02:47 e legge `$5D1F=80` per la cuoca (attore9), è escluso dal certificato.
Il modello si arresta alle 02:45: non attribuiamo al read nativo un timestamp
più preciso di quello registrato nel checkpoint.

Suite finale: **1.844/1.844 test superati**, zero errori, skip e cancellazioni.
Anche la storia del finale `$6A33` è stata ripetuta sul codice finale:
521 checkpoint fino a giovedì10:00, 10.345 draw/22.058 read confrontati,
10.347 draw runtime con le due iniziali, pausa terminale e congelamento
verificati. Per quel finale l'oracolo originale è riutilizzato con hash;
la nuova acquisizione di questo lavoro è la continuazione notturna di 95
checkpoint dal prompt completo delle11:36.
