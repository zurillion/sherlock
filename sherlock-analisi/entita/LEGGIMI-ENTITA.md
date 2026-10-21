# Sherlock: database delle entità e risoluzione dei comandi

Analisi del 20 ottobre 2026, sul payload ZX Spectrum fornito nel progetto. Questa fase collega il parser sintattico al mondo del gioco. Il manuale e Foggy London sono fonti di indizi; i risultati dichiarati verificati derivano dai byte originali e dall’esecuzione Z80 in copie isolate.

## Risultato principale

Il gioco usa **110 record di entità**, indicizzati da `$00` a `$6D`. Oggetti, persone, mezzi di trasporto e alcuni concetti delle conversazioni condividono la stessa struttura. Il nome di un oggetto nel comando viene prima confrontato con questi record; i candidati vengono poi filtrati in funzione dell’azione e dello stato del mondo. Solo allora viene eventualmente chiesto «quale?».

Abbiamo identificato:

- indice, limiti e struttura di tutti i 110 record, compresi i dati variabili;
- 20 record con il flag di categoria «persona», incluso Holmes;
- 17 record con un puntatore a una descrizione specifica, estratte nel catalogo;
- 141 coppie nelle code locali, di cui 5 marcatori e 136 associazioni azione/regola;
- il percorso da `$B191` al confronto nominale, alla verifica dei candidati e alla domanda di disambiguazione;
- la distinzione fra posizione, contenimento, categoria personale, importi e riferimenti lessicali.

**Non abbiamo ancora decodificato integralmente il linguaggio delle regole, i comportamenti autonomi degli NPC e il ciclo temporale.** I campi non sufficientemente compresi restano indicati come tali.

## File e riproduzione

- `results/CATALOGO.md`: tutte le entità, contenitori, locazioni, descrizioni e associazioni alle regole locali. Contiene spoiler.
- `results/entities.json`: record strutturati, byte originali, riferimenti al dizionario, importi e puntatori.
- `results/entities-semantics.asm`: estratti commentati, con i dati dichiarati come `DEFB`.
- `results/semantic-traces.json`: 26 esperimenti sul gioco completo, compresi due con uno stato precedente conservato.
- `results/verification.json`: verifiche differenziali e differenze fra payload e snapshot al prompt.
- `results/manual-probes.json`: dieci frasi confrontate con il parser originale.
- `MANUALE-E-INGLISH.md`: confronto ragionato con il manuale.

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/entita/sherlock_entities.py
python3 -B sherlock-analisi/entita/verify_entities.py
python3 -B sherlock-analisi/entita/build_entities_listing.py
python3 -B sherlock-analisi/entita/trace_semantics.py
```

I programmi scrivono nella sottocartella `results`. Accettano `--project` e `--output`. L’estrattore usa il decoder già presente; le verifiche richiedono anche SkoolKit 10.1 e `parser/results/prompt.z80`, entrambi già nel progetto. Le copie dei programmi fuori dal progetto richiedono `--project "/Users/giovanni/Documents/Development/Sherlock rebuild"`.

I programmi di verifica eseguono anche azioni del gioco **soltanto nella memoria dell’emulatore**, senza modificare TAP, TZX o snapshot di partenza. La tastiera viene alimentata artificialmente e le pause di visualizzazione superate con uno spazio. Le tracce sono riproducibili da questo snapshot, non simulazioni di tutte le possibili condizioni di una partita.

## 1. Indice e struttura dei record

L’indice occupa `$8B6F–$8CB8`: 110 triplette di un ID e un puntatore little endian. A `$8CB9` c’è la sentinella `$FF`. I record occupano esattamente `$8CBA–$9569`. I sei byte `$956A–$956F` non appartengono all’ultimo record; il successivo spazio di lavoro inizia a `$9570`.

La routine `$D237` riceve l’ID in A e restituisce il puntatore al record in IX. Usa `$D34E`, una ricerca con passo 3. L’enumeratore `$D206` restituisce invece IX sulla tripletta e IY sul record. Sono due contratti diversi, da non confondere nell’annotazione del disassemblato. Il lookup originale non è un’API con validazione degli ID: usarlo su valori arbitrari sarebbe inaffidabile.

| Offset | Dimensione | Interpretazione e prova |
|---|---:|---|
| `+00` | 1 | Numero delle locazioni associate; `$D495`, `$C821`. |
| `+01` | 1 | Entità genitore/contenitore; `$FF` = nessun genitore. `$C86E`, `$D249`. |
| `+02` | 1 | Grandezza quantitativa non ancora completamente interpretata. `$D2ED` somma questo campo per i figli diretti. |
| `+03` | 1 | Grandezza impiegata nel limite di carico/capacità. `$D2F2` somma ricorsivamente i contenuti; `$C8C6` confronta disponibilità e oggetto da trasferire. Unità e significato fisico preciso ancora aperti. |
| `+04` | 1 | Campo misto: i tre bit bassi selezionano una relazione spaziale per descrivere i contenuti; i bit alti hanno altri usi. |
| `+05` | 1 | Attributi fisici e categoria dell’entità. Vedere sotto. |
| `+06` | 1 | Altri attributi, inclusi stato di osservazione e specializzazione monetaria. |
| `+07/+08` | 2 | Riferimento lessicale del nome; i 12 bit bassi sono l’offset nel dizionario, i bit alti sono metadati. |
| `+09/+0A` | 2 | Primo qualificatore, oppure importo se `+06 & $20`. |
| `+0B/+0C` | 2 | Secondo qualificatore. |
| `+0D/+0E` | 2 | Puntatore alla descrizione specifica; zero = descrizione generica. `$DF5B–$DF7D`. |
| `+0F...` | `N` | Lista di ID di locazione, dove N è `+00`. |
| `+0F+N...` | variabile | Coppie azione/indice di regola, eventualmente precedute da `00 00`; termina con un solo byte `$FF`. |

La dimensione è `15 + N + 2*K + 1`, con K numero delle coppie, inclusi gli eventuali marcatori. È stata verificata la contiguità di tutti i record. Una porta o un passaggio può avere più locazioni nello stesso record: non bisogna inventare un oggetto indipendente per ogni posizione. Gli effetti delle modifiche di stato su queste entità condivise meritano una verifica specifica successiva.

Gli ID delle entità e quelli delle locazioni appartengono a **due spazi distinti**. Il valore 8 nel campo posizione significa locazione 8; il valore 8 nel campo genitore significherebbe entità 8, il giardiniere.

### Attributi: cosa possiamo già affermare

- `+05 & $40`: categoria personale. `$C8BE` è un test diretto; `$C929` la usa per cercare regole dell’attore. Il catalogo contiene 20 record con questo bit. Non implica 20 persone indipendenti, attive e autonome: possono esserci identità alternative e personaggi fuori scena.
- `+05 & $80`: parte del filtro di percezione `$C821`. Il filtro considera anche luogo e contenitori: il bit da solo non significa «visibile qui e ora».
- `+05 & $20` e `+05 & $08`: intervengono nel risalire contenitori in `$C86E`. Foggy London li denomina «open» e «broken»; la funzione osservata è compatibile, ma questo lavoro non ha verificato tutti i comandi che li modificano.
- Gli altri nomi proposti da Foggy London per `+05` — locked, liquid, full, gives light — restano indizi, non una certificazione completa del significato di ogni bit.
- `+06 & $20`: oggetto monetario. `$D3FD` salta il campo che normalmente conterrebbe il primo aggettivo; `$E31C` lo richiede per COUNT.
- `+06 & $40`: impostato durante EXAMINE da `$DF61`. Possiamo chiamarlo «esaminato», senza assumere di avere enumerato tutti i suoi usi.
- `+06 & $80`: impostato da `$D531` quando l’entità viene elencata nella descrizione. È distinto da «esaminato»; il nome provvisorio è «osservato/elencato».

Per `+04 & 7`, `$D5D3` consulta la tabella `$D5C9`: 1 = IN, 2 = ON, 3 = BEHIND, 4 = UNDER, 5 = TIED TO. È la relazione usata per presentare i contenuti del contenitore. Il valore zero e gli altri bit non sono tradotti in proprietà Python ipotetiche.

### Denaro: un’eccezione importante

Il campo `+09/+0A` delle entità monetarie non è né un aggettivo né un normale intero little endian in pence. `$E39C` lo decodifica come:

```python
pence = signed_byte(high) * 128 + (low & 0x7f)
```

Per il denaro di Holmes i byte sono `60 09`: **1248 pence = 5 sterline e 4 scellini**. La prova originale `COUNT MONEY` stampa proprio questo importo. Interpretarli come `$0960 = 2400` darebbe un risultato errato. La routine è stata confrontata anche su valori sintetici positivi e negativi, compresi i limiti del formato a 15 bit con segno.

## 2. Persone e contenimento

Foggy London elenca 29 «characters», ma include anche otto treni e la carrozza della polizia. Il bit della categoria personale individua invece 20 record: Holmes, 19 altri record personali, e nessuno di quei nove veicoli. Per ricostruire gli NPC occorre tenere separate **categoria personale, identità narrativa e presenza nello scheduler**.

Alcuni esempi, con ID decimali:

```text
Holmes (0)
└── denaro (27)

poltrona di Watson (24)
└── Watson (3)
    └── Daily Chronicle (25)

scrivania (61)
└── cassetto (62)
    └── falso fondo (63)
        ├── libretto bancario (64)
        └── nota (65)
```

Questo albero è nei dati, non nel testo delle descrizioni. `$D249` aggiorna ricorsivamente le posizioni dei discendenti quando cambia la posizione di un contenitore. `$C86E`, `$C8AF` e `$D275` risalgono invece la catena per accessibilità e possesso.

Il catalogo fotografa il payload prima dell’inizializzazione. Lo snapshot al prompt è già cambiato: per esempio Lestrade e gli oggetti che porta sono passati dalla locazione 11 alla 10; un treno è stato collocato nella locazione 16; alcuni oggetti della stanza hanno il bit «elencato». Le differenze precise sono in `verification.json`. La locazione zero di vari record non va interpretata automaticamente come una stanza ordinaria o come un errore del catalogo.

## 3. Le regole locali sono parte dei dati

La routine `$D1DC` salta l’intestazione e la lista delle locazioni e cerca l’azione nella coda. Se trova una coppia, il secondo byte è un indice **a partire da 1** nella tabella di puntatori `$AA71`.

Esempio: la poltrona di Holmes, ID `$17`, ha questa coda a `$8E76`:

```text
0D 08   CLIMB OUT OF  -> indice 8 -> $E432
0C 09   CLIMB INTO    -> indice 9 -> $E40A
19 08   GET OUT OF    -> indice 8 -> $E432
18 09   GET INTO      -> indice 9 -> $E40A
28 09   SIT IN        -> indice 9 -> $E40A
FF      fine
```

I puntatori arrivano a **blocchi di regole**, che possono contenere dati e chiamate a codice. Non vanno automaticamente disassemblati come routine Z80 a partire dal primo byte.

Cinque record personali hanno una coda che inizia con `00 00`: poliziotto `$0B`, Tricia `$0D`, i due vetturini `$1F/$22`, Mrs Jones `$5F`. In `$C929` il percorso delle regole dell’attore cerca prima il marcatore zero e poi usa `$D349`, ricerca con passo 2. La ricerca ordinaria di un’azione tramite `$D1DC` si arresta anche sullo zero: il marcatore cambia il modo di consultare la coda.

Ordine osservato della selezione in `$C929`:

1. regola speciale del personaggio che sta agendo, se applicabile;
2. regola locale del primo oggetto, se applicabile;
3. regola generale dell’azione, attraverso l’indice `$9F38`.

È il punto migliore da approfondire prima di affrontare il loop completo.

## 4. Dai nomi alle entità concrete

Il percorso ordinario è:

```text
parser sintattico -> nodo del comando
    -> D7FC / B191
    -> modello verbo + preposizioni, tabella8259
    -> due triplette nominali B172/B178
    -> enumerazione nominale e percettiva
    -> verifica delle regole C929 con A00B=0
    -> zero / uno / più candidati ammessi
    -> errore / argomenti risolti / domanda di precisazione
```

`$B39D` confronta il verbo e le relazioni con 54 modelli da 8 byte. `$B405` assegna i gruppi nominali ai due ruoli del modello: non basta chiamare il primo gruppo sintattico «oggetto diretto» in ogni frase. `$B182/$B183` conservano gli offset `$08/$12` nel nodo originale. Gli ID risolti finiscono in `$A034/$A035`; `$A033` contiene l’indice dell’azione riconosciuta.

Le classi di ricerca `$A00F/$A010`, derivate da `$C493/$C4B2`, distinguono locazioni, letterali ed entità. Per le entità viene usato `$D36A`, per le locazioni `$D39B`. `$FE` indica un argomento letterale in determinati percorsi; `$FF` è il valore iniziale/assenza. **Dopo un fallimento i valori rimasti in A034/A035 non sono argomenti validi**: possono essere residui dei tentativi.

`$A4E0` confronta nome e due qualificatori:

- la word zero nella query è un campo non specificato;
- si confrontano soltanto i 12 bit lessicali, ignorando i metadati alti;
- i due qualificatori possono corrispondere nei due ordini;
- un nome corrispondente non basta: `$D36A` applica anche `$C821`, salvo la modalità che lo bypassa mediante `$A038`.

La prova isolata con HEAVY OAK DOOR e OAK HEAVY DOOR trova lo stesso record; al prompt iniziale entrambi i comandi completi falliscono perché quella porta non è accessibile nella situazione iniziale. È un esempio concreto della differenza fra confronto nominale e risoluzione nel mondo.

### Il controllo semantico anticipa una parte delle regole di gioco

In `$B191` il byte `$A00B` viene posto a zero. `$C929` può quindi consultare i vincoli della regola senza eseguirne il corpo: `$C9F2` distingue questa fase dall’esecuzione. Non significa però che ogni condizione venga applicata allo stesso modo nei due passaggi: in particolare `$C79A` permette che alcuni controlli di maschera falliti siano rinviati alla fase di esecuzione. Il confine «semantica / motore» è meno rigido di un compilatore a tre fasi completamente separate.

| Prova sul gioco completo | Risultato verificato |
|---|---|
| `EXAMINE ARMCHAIR` | Candidati 23 e 24; entrambi superano le regole; domanda `which armchair ?`. |
| risposta `WATSONS` | Il nodo pendente viene completato; risolto ID 24; esame eseguito. |
| `EXAMINE YOUR ARMCHAIR` | Risolto ID 23, senza domanda. |
| `TAKE ARMCHAIR` | Stessi candidati nominali; entrambi falliscono il controllo quantitativo `$C8C6`; nessuna domanda, messaggio di impossibilità. |
| `OPEN DOOR` | Restano ID 21 e 50; domanda `which door ?`. |
| `OPEN YOUR DOOR` | Risolto ID 21; selezionata la regola locale di OPEN. |
| `GIVE LAMP TO WATSON`, al prompt iniziale | Fallisce il requisito di possesso della lampada. |
| `TAKE LAMP`, poi `GIVE LAMP TO WATSON` | La seconda frase risolve ID 22 e 3 ed esegue il trasferimento. |
| `EXAMINE DAILY CHRONICLE` | La corrispondenza nominale esiste, ma EXAMINE considera anche che il giornale appartiene a Watson. |

Il contatore `$B170` riguarda il primo argomento; `$B171` il secondo. Nei comandi a due argomenti si valutano combinazioni e vincoli congiunti: due ricerche indipendenti «prendi il primo oggetto che ha quel nome» non riprodurrebbero il comportamento originale.

La domanda di precisazione passa da `$B5E2` o `$B5D3` a `$B5B6`: il nodo viene spostato da `$9FF2` a `$9FF0`, e `$A01B` memorizza lo slot da completare. È il raccordo con le continuazioni già documentate nella fase precedente.

Nelle tracce `z=true` all’uscita da B191 indica fallimento/richiesta di precisazione; `z=false` indica che questa risoluzione è riuscita. Il campo `hl` è registrato come dato grezzo: **non è sempre un puntatore a una routine**, soprattutto nei ritorni riusciti.

## 5. Verifiche e limiti

Verifiche completate:

- 110 lookup, test della categoria personale e letture della posizione contro le routine native;
- 141 accessi alle code locali, incluso il percorso dei marcatori zero;
- 990 confronti differenziali della routine nominale, con nomi, qualificatori invertiti, campi omessi e metadati alti;
- 10 valori monetari contro la conversione Z80;
- 26 esperimenti sul gioco completo con cattura dei candidati, predicati, attori, messaggi e ritorni;
- 1580 istruzioni negli estratti; 6419 byte, comprendenti i dati espliciti, ricomposti senza differenze.

La ricomposizione verifica la fedeltà dei byte degli estratti; non dimostra da sola che un intervallo sia codice. La selezione dei tratti di codice deriva dalle routine seguite e dai loro salti/chiamate. I blocchi di dati e i byte di stato sono esplicitamente separati.

Da approfondire: significato completo di `+02/+03/+04`, aggiornamenti di tutti i flag, grammatica dei blocchi di regole, classificazione delle identità alternative, tabelle di intenzioni e conoscenze degli NPC, persistenza dell’interlocutore, scheduler e avanzamento del tempo. L’analizzatore interattivo precedente resta uno strumento sintattico: questi risultati non sono stati aggiunti come una semantica Python approssimativa.

## Prossimo passo consigliato

Decodificare il linguaggio dei blocchi di regole partendo da **TAKE, GIVE, OPEN e SAY TO**, sfruttando i puntatori già trovati. Per ciascuna azione possiamo ricostruire predicati, effetti sul database, testo prodotto e costo temporale. Dopo questo passaggio il loop centrale avrà nomi e contratti comprensibili; potremo seguirne l’ordine di esecuzione e capire come gli NPC usano lo stesso motore.
