# Argomenti invisibili dei rifiuti e riferimento lessicale `$A022`

## La scrittura originale

Il precedente limite era una lettura di `$A022` da parte della cuoca (attore 9),
mercoledì alle 07:36. Il valore originale era zero, ma il modello lo dichiarava
sconosciuto: non bastava inizializzarlo o ricavarlo dall'ultima parola visibile.

La traccia riparte dal prompt originale completo della conversazione con
Mrs Jones e ripete gli input ordinari con tutti gli attori. Osserva gli store
`$A88C` e `$A8B5`, anche quando non cambiano il valore, e segnala separatamente
le altre transizioni del campo. La finestra comincia al tick 1649, martedì
11:28: **243 store, nessuna transizione non classificata**. Non attribuisce
provenienza ai valori precedenti alla finestra osservata.

L'ultimo store è **`$A88C: LD ($A022),DE`**, con DE zero, durante **EXAMINE ROCK**,
tick 1657, martedì 11:36. L'attore è Holmes e nella pila compaiono il return
`$A5ED` del linguaggio dei testi e `$B6AD` del rifiuto semantico. La lettura
osservata avviene al tick 2857, mercoledì 07:36: il descrittore è sopravvissuto
anche all'intera notte di attesa.

`$A022/$A023` conservano insieme una word: offset del dizionario e nibble di
contesto. `$A88C` salva il descrittore **prima** di controllare se l'offset è
zero. Un parametro vuoto non stampa lettere, ma aggiorna comunque il campo.

## Perché EXAMINE lascia zero

Il template `$6894`, che costruisce «I SEE NO … THAT YOU CAN …», riceve sette
word come argomenti. Le ultime tre sono il verbo e due parole opzionali del
modello dell'azione. Il token `wordArgument` chiama `$A66C`, consuma una word e
restituisce NZ; il dispatcher torna quindi al normale ingresso lessicale
`$A887` anche quando la word vale zero.

Il modello EXAMINE non seleziona le due parole successive al verbo: entrambi
gli argomenti sono zero. L'ultima parola visibile è EXAMINE, ma dopo di essa
il formatter passa altri due descrittori vuoti. L'ultimo store lascia dunque
zero, anziché l'offset di EXAMINE o di ROCK.

La selezione dipende da **modello e slot nominale fallito**:

- `$B633`, primo slot: seleziona la prima parola opzionale in base al bit 5
  del byte alto del secondo campo; seleziona la seconda in base al bit 7 del
  byte alto del quarto campo.
- `$B62F`, secondo slot: inverte quelle condizioni.
- Un campo non selezionato produce una word zero. Un campo selezionato
  conserva tutti i bit del modello, non solo l'offset del dizionario.

Nell'originale vengono cambiati due opcode JR; la riscrittura esprime
semplicemente le due condizioni logiche. Non esegue né modifica istruzioni.
I valori grezzi dei quattro campi di ciascuno dei 54 modelli sono ora dati
espliciti nell'asset e nella sua procedura di estrazione. Un controllo separato
verifica che tutti gli altri dati dell'asset siano rimasti invariati.

Non esiste una regola generale «errore uguale zero»: CLIMB OUT OF e GET OUT OF
possono lasciare **OF, `$05EC`**. Il secondo slot di GIVE può lasciare
**`$1000`**, un descrittore privo di offset che non stampa nulla ma conserva un
byte alto diverso da zero. Il futuro del generatore dipende anche da questo.

## Integrazione e limiti

`Text.rejectionDictionaryWords` ricostruisce le due word dal modello e dallo
slot. Il rifiuto semantico per un riferimento descrittivo assente associa il
risultato al messaggio; la proiezione del canale inferiore pubblica il
riferimento finale nell'ordine effettivo dei messaggi. Il template interessato
è piatto e non esegue estrazioni casuali fra quelle parole.

L'ambito nuovo comprende il percorso del giocatore con `sceneryFailure.found`
false e slot individuato. Non rende noti per analogia gli errori relativi a un
termine trovato, i chiarimenti, gli errori lessicali/sintattici, altri template
o i chiamanti NPC. Un messaggio non ricostruito continua a revocare il campo;
un riferimento zero esplicito è invece distinto da un valore mancante.

SAVE conserva entrambi i byte. LOAD non aggiunge un valore a un vecchio SAVE
che ne è privo: serve una nuova operazione ricostruita. L'analisi del parser
rimane priva di effetti sul campo. Nessuno snapshot originale, registro CPU o
elenco di risposte registrate viene importato nel motore giocabile.

## Prove e mappa

- **216 setup ABI originali**: 54 modelli, entrambi gli slot, emissione abilitata
  o soppressa. Sono confrontati i due argomenti e il descrittore finale;
  14 casi visibili hanno un finale nonzero. Il gating soppresso conserva il
  precedente valore. Queste combinazioni non certificano la raggiungibilità
  di ogni rifiuto durante una partita.
- **36 comandi originali completi** da un prompt integro, ripristinato per ogni
  caso: contengono 27 invocazioni effettive di `$6894`, comprese richieste con
  qualificatori e secondo slot nominale. Le code dei parametri coincidono con
  la selezione del modello. I restanti casi sono scope negativo: non vengono
  presentati come equivalenza completa di tutti quei comandi.
- Verifiche della metadatazione applicata, dell'ordine dei messaggi, dei tag
  nonzero, dei chiamanti esclusi e della persistenza SAVE/LOAD.

Nuovi **158 byte prima grigi**, ora documentati:

- **`$B62F–$B65E`**, selezione delle parole opzionali;
- **`$B678–$B6D5`**, costruzione dei parametri del rifiuto nei due slot;
- **`$B83C–$B84B`**, ordine delle word nominali sullo stack del testo.

Approfonditi `$A022–$A023`, `$A59F–$A5C3`, `$A621–$A639`, `$A66C–$A678`,
`$A887–$A8B8`, il template dati `$6894–$68A1` e i modelli `$8259–$840A`.
Dati e istruzioni restano distinti. L'estratto tipizzato comprende **147
istruzioni e 733 byte**, tutti confrontati con il payload e riassemblati.
La copertura è **39.364 byte documentati, 428 parziali e 1.808 ignoti** su
41.600. Questa è copertura della documentazione, non del gameplay completo.

Evidenze e strumenti sono in `results/dictionary-reference-22/`; il riepilogo
finale è `results/dictionary-reference-22-verification.json`. Il log
`preliminary-count-assertion.log` registra un'asserzione preliminare sbagliata
sul numero di casi nonzero, corretta a 14 sulla matrice acquisita; non è un
risultato positivo del test. Tutti i confronti dei descrittori erano già uguali.

## Certificato finale e prossimo lavoro

La nuova proprietà è applicata a **20 dei 36 comandi di controllo**. Fra questi,
GIVE MONEY TO STREAM conserva `$1000` anche nel motore giocabile. Gli esempi OF
provano l'algoritmo del selettore, non la copertura di ogni forma CLIMB OUT nel
motore: alcuni rifiuti fallback restano senza proprietà. I byte degli opcode
mutabili `$B649/$B658` non vengono proiettati da questo lavoro come ingressi
casuali; la comprensione del selettore non rende noti tutti i suoi campi.

Passano tutti i 462 checkpoint del precedente oracolo fino a mercoledì 07:38.
La continuazione originale è stata riacquisita dal prompt integro delle 11:36:
131 checkpoint nuovi, con i primi 461 sovrapposti identici al precedente oracolo.
Il prefisso positivo esteso comprende **468 checkpoint (0–467) fino a mercoledì
08:40**, con **7.030 estrazioni e 14.970 letture** confrontate, 7.032 estrazioni
runtime incluse le due iniziali. Sono confrontati tutti i 24 attori, i 752 byte
dell'arena, bitmap e pacchetti dello schermo ai checkpoint. Il futuro dopo LOAD
è verificato anche a ogni minuto delle attese.

Il primo checkpoint escluso è 468: nell'originale termina alle 08:47 e contiene
la lettura di `$5D23=1` da parte del giardiniere (attore 8). Il modello si ferma
alle 08:45. Il prossimo lavoro deve trovare lo scrittore naturale di questo
byte: il suo ruolo nel vecchio frame `$5D2A` non dimostra il ruolo attuale, né
il valore osservato autorizza a installare una costante 1.

**Suite finale: 1.860/1.860 PASS**, zero errori, test saltati o cancellazioni.
Baseline `$6A33` ripetuta sul codice finale: 521 checkpoint fino a giovedì
10:00, 10.345 draw / 22.058 read confrontati, 10.347 draw runtime incluse le
due iniziali; pausa terminale e congelamento verificati. Per quel finale
l'oracolo è riutilizzato con hash, non riacquisito. Il finale naturale `$6ABD`
e gli altri finali pendenti restano da certificare; questa storia mantiene
viaggi falliti e prova Brown non recuperata, senza patch di mondo o indizi.
