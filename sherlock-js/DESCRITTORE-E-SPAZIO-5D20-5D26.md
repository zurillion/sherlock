# Due operandi della cuoca: descrittore `$5D20` e scansione `$5D26`

Il limite precedente fermava il modello mercoledì alle 13:14 su `$5D20`.
La stessa estrazione della cuoca 9 legge anche `$5D26`: i due byte richiedono
provenienze distinte. Il motore resta JavaScript autonomo; le esecuzioni del
codice originale sono prove offline.

## Writer naturali

La traccia riparte dal prompt originale completo di Mrs Jones, esegue i normali
comandi del percorso Brown e le attese, osservando dal tick 1649 fino alla
lettura del **tick 3195, mercoledì 13:14**. Nessuna patch a RAM, registri,
posizioni, prove o programmi. Registra anche gli store che ripetono il valore.
Sono osservate **3.020 scritture su `$5D20–$5D27`**, senza transizioni non
classificate. Non viene attribuita provenienza ai valori precedenti la finestra.

| Campo | Ultimo writer | Glifo / frame | Valore |
| --- | --- | --- | --- |
| `$5D20` | `$C38A: PUSH DE` | `n` di `plain`, frame `$5D26` | E di `$5C0B`: 11 |
| `$5D26` | `$C3B8: PUSH AF` | spazio dopo `plain`, frame `$5D32` | F dell'ultima scansione: 0 |

Entrambi vengono scritti da Holmes 0 al tick 1653, **martedì 11:32**. Il
return `$D65B` identifica il passaggio. La `n` è in colonna 21; lo spazio
successivo è in colonna 22, descrittore `$526E`, shift 4. AF all'ultimo store
è `$0000`: questo zero è il risultato della scansione, non un'inizializzazione.

## I due calcoli

`$5D20` contiene E del parametro passato al renderer: il modello conserva
`descriptor & 255`. Mentre viene scaricata una parola, DE punta al buffer
`$5C0B`. Lo spazio del successivo riferimento lessicale arriva invece con il
parametro del sostantivo, `$5000 | noun`, qui `$526E`. Non tutti i caratteri di
uno stesso nome condividono quindi parametro e profondità del chiamante.
Sono riutilizzate con hash 144 varianti originali del descrittore nel frame
pertinente, oltre alle 1.296 configurazioni dei sei ruoli di quel byte.

`$5D26` è scritto dalla scansione dello spazio. Il modello calcola i flag del
settimo incremento di H e del percorso DEC/INC C, dalla posizione video e
dallo shift già ricostruiti. C39D salva AF prima della rotazione; nel caso
split-byte, C3B8 lo risalva dopo la ricostruzione. Solo l'emissione dello spazio
provata nel frame `$5D32` riceve questo nuovo contratto. Il risultato zero della
partita naturale non viene usato come valore di ripiego. Le 1.296 ABI originali
dei sei ruoli restano una prova indipendente del renderer.

Il return della normale CALL al glifo, quando occupa `$5D26`, non è un valore
da lasciare per inerzia: viene revocato fino a un successivo writer provato.
Il nuovo contratto dello spazio non introduce il byte alto `$5D27`, né il
contratto del descrittore basso rende noto `$5D21`. I vecchi ruoli del renderer
rimangono separati, inclusa la scansione del nome proprio della destinazione.

## Conservazione: `$5D26` richiede maggiore cautela

Nuove prove originali estendono i marcatori fino a `$5D27`:

- **720 chiamate D60B**, movimento/LOOK, 36 colonne, due stati coerenti degli
  spazi e cinque classi nominali. Per ciascun campo il modello dichiara noti
  290 valori, tutti coincidenti; gli altri 430 rimangono ignoti.
- **1.512 arrivi CBC2**. I 720 casi con persona propria senza qualificatori
  attivi conservano `$5D20`. In 20 di questi casi, su righe parziali che
  richiedono wrap, `$5D26` viene invece sovrascritto. Non gli viene attribuito
  il contratto ampio dei byte più profondi.
- **300 controlli CBC2 aggiuntivi** su riga nuova, con i 20 soggetti propri
  eleggibili e contatore 0–14. Tutti conservano `$5D26`. Il runtime ammette una
  condizione più prudente: cursore 0, buffer vuoto, spazio normalizzato azzerato,
  nome che entra nella riga e `counter + 2 < 15`, riservando CR finale e
  separatore prima della soglia MORE. Sono 260 setup del controllo.
- **138 pipeline di comandi originali complete**, 129 rifiuti semplici
  eleggibili: entrambe le celle vengono conservate. Qualificatori, ricerche
  nella prosa, richieste a NPC e altri errori restano esclusi.

Questi sono setup controllati, non prove della raggiungibilità naturale di
ogni configurazione. Arrivi accodati, isolati e `relocate` non ereditano il
contratto ordinario. LOOK, scene remote e contenitori non ricevono la nuova
proiezione del passaggio. I prologhi degli scroll possono salvare registri
sopra il frame del glifo; clear, wrap finali e nomi successivi non proiettati
revocano i campi. Il nuovo `$5D26` resta ignoto anche se si avvicina MORE fuori
dal budget verificato: il budget è una restrizione della proprietà, non una
modifica della regola originale di paginazione.

SAVE/LOAD conserva i valori derivati; le assenze dei vecchi SAVE non vengono
riempite. Un test breve esegue 12 comandi ordinari da un SAVE JavaScript prima
dei writer, ricostruisce i due valori e confronta anche le azioni successive
dopo LOAD. I controlli coprono separatamente i parametri variabili, lo spazio,
i campi vicini rimasti ignoti, i caller esclusi e il contatore di pagina.

## Atlante e risultati

Il dossier `results/passage-descriptor-20/passage-descriptor-20.asm` verifica e
riassembla **395 istruzioni / 715 byte**. Sono approfonditi `$C2BA–$C305`,
`$C316–$C387`, `$C388–$C3E3`, `$D60B–$D670`, `$CBC2–$CC0A`, `$C1FD–$C23F`,
**`$A815–$A82E`, `$A887–$A8B8`, `$D3D5–$D447`** e i due campi del workspace.
Nessun nuovo byte grigio e nessun cambiamento di classificazione: 39.364
documentati, 428 parziali e 1.808 ignoti su 41.600. La copertura statica non
certifica il completamento del gameplay.

Hash, protocolli, acquisizioni e confronti sono in `results/passage-descriptor-20/`;
le nuove ABI sono nella sottocartella `wide-abi/`. Il riepilogo definitivo è
`results/passage-descriptor-20-verification.json`.

## Esito conclusivo

**510 checkpoint (0–509) fino a mercoledì 14:40**, 7.985 estrazioni e 17.010
letture confrontate, 7.987 estrazioni runtime incluse le due iniziali. Tutti i
24 posti attore, entità, fatti, programmi, arena di 752 byte e bitmap ai
checkpoint sono confrontati. Il futuro dopo LOAD è confrontato anche a ogni
minuto delle attese. La nuova continuazione originale ha 173 checkpoint dai
quali vengono mantenuti identici tutti i 501 checkpoint precedenti, ora
interamente positivi; i campioni 2928, 3014, 3104 e 3197 conservano i vecchi confini.

Il primo checkpoint escluso è 510, originale mercoledì 14:49: il giardiniere 8
legge **`$5D21=92`**. Il modello si ferma alle **14:47, tick 3288**. La traccia
20–27 termina alla lettura precedente del tick 3195: occorre estenderla fino
al nuovo read, senza dedurre il writer dal vicino `$5D20` o dal valore 92.

**Suite finale: 1.891/1.891 PASS**, nessun errore, salto o cancellazione.
Baseline `$6A33` ripetuta sul codice finale: 521 checkpoint fino a giovedì 10:00,
10.345 estrazioni e 22.058 letture, 10.347 estrazioni runtime incluse le due
iniziali, con pausa terminale e congelamento verificati. L'oracolo di quel
finale è riutilizzato con hash. Il finale naturale `$6ABD` e gli altri finali
pendenti restano aperti; questa storia mantiene viaggi falliti e prova Brown
non recuperata.
