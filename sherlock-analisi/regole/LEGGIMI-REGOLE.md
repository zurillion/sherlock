# Sherlock: dalle regole agli effetti sul mondo

Analisi del 20 ottobre 2026. Prosegue il dossier delle entità e copre TAKE, GIVE, OPEN e SAY TO, comprese le eccezioni locali raggiunte da questi comandi. Il manuale rimane una fonte descrittiva; le conclusioni qui sotto derivano dai byte e da prove Z80.

## Cosa abbiamo ricostruito

Una regola non è semplicemente una routine assembler. Ha un’intestazione compatta, seguita da **codice Z80 oppure da uno script interpretato**. Una word nell’intestazione può inoltre puntare a un predicato Z80. La distinzione dipende dai bit dell’intestazione e spiega perché disassemblare linearmente queste aree produce istruzioni plausibili ma inesistenti nel flusso reale.

Per le quattro azioni sono stati censiti nove blocchi, inclusi CLOSE come controllo complementare e due sottoregole raggiunte dagli script. Ci sono tre regole generali nell’indice `$9F38`: TAKE, GIVE e SAY TO. **OPEN non ha una voce generale in quell’indice**: gli oggetti che lo supportano lo associano nelle proprie code locali. Le associazioni locali censite sono 25: 24 per OPEN, una per TAKE.

Gli script Python e gli estratti non costituiscono ancora un interprete completo del gioco. Riconoscono le intestazioni e i due script effettivamente analizzati, con rifiuto esplicito degli opcode non coperti.

## File e comandi

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/regole/sherlock_rules.py
python3 -B sherlock-analisi/regole/trace_rules.py
python3 -B sherlock-analisi/regole/verify_rules.py
python3 -B sherlock-analisi/regole/build_rules_listing.py
```

Eseguire `trace_rules.py` prima di `verify_rules.py`: quest’ultimo controlla anche il risultato delle tracce. I risultati sono già presenti in `results`.

- `sherlock_rules.py`: genera `rules.json` e `REGOLE.md`, con intestazioni, vincoli, durata, predicati, corpo e associazioni agli oggetti.
- `trace_rules.py`: esegue 21 esperimenti e salva `execution-traces.json`, distinguendo prove dal prompt originale e stati sintetici costruiti apposta.
- `verify_rules.py`: confronta intestazioni e maschere con le routine native e verifica gli effetti nelle tracce; produce `verification.json`.
- `build_rules_listing.py`: genera `rules.asm`, con dati, bytecode e Z80 separati; verifica i byte ricomposti in `listing-verification.json`.

Tutti accettano `--help`, `--project` e `--output`. Usano il payload, il decoder, il catalogatore delle entità, SkoolKit e il parser già nel progetto. Non modificano i file originali del gioco. Fuori dal progetto, passare `--project "/Users/giovanni/Documents/Development/Sherlock rebuild"`.

## 1. Formato dell’intestazione

| Campo | Significato verificato |
|---|---|
| Byte 0, bit 0–3 | Classe/vincolo del primo argomento. |
| Byte 0, bit 4 | Sono presenti cinque byte di test sugli attributi. |
| Byte 0, bit 5 | La regola richiede luce, controllata da `$D078`. |
| Byte 0, bit 6 | Dopo i primi due byte è presente un puntatore LE a un predicato Z80. |
| Byte 0, bit 7 | Il corpo è uno script differito; ritorno con Carry impostato. |
| Byte 1, bit 0–3 | Classe/vincolo del secondo argomento. |
| Byte 1, bit 4–7 | Costo temporale, copiato nella word `$A01F` durante l’esecuzione. |

Ordine: due byte iniziali; eventuale puntatore al predicato, due byte; eventuale blocco maschere, cinque byte; corpo.

```python
body = rule_address + 2
if flags & 0x40:
    body += 2
if flags & 0x10:
    body += 5
```

`$C9BF` interpreta l’intestazione; `$CA0C–$CA21` calcola l’inizio del corpo. Se il bit 7 è zero, `$CB40` esegue un `JP (HL)` verso il corpo Z80. Se è uno, `$CA46` restituisce Carry e HL indica uno script. `$C9A7` prepara un contesto sospeso e il motore riprende da quel puntatore.

### Pre-verifica ed esecuzione

`$A00B = 0` indica la pre-verifica: controlli di classe, luce e predicato possono essere eseguiti, ma non il corpo. La durata non viene assegnata in questa fase. `$A00B != 0` abilita l’esecuzione.

Alcuni controlli degli attributi sono deliberatamente rinviati: `$C79A` rende non eliminatorio un fallimento di maschera durante la pre-verifica. Perciò una porta bloccata può essere identificata correttamente come oggetto di OPEN, per poi produrre «is locked» durante l’esecuzione. È diverso da «non trovo alcuna porta».

### Le maschere

Il blocco di cinque byte contiene un byte di controllo e quattro maschere: due per ciascun argomento. Il nibble alto del controllo riguarda il primo argomento, quello basso il secondo. In ciascun nibble, bit 3–2 = modo del primo test, bit 1–0 = modo del secondo test. I test si applicano al byte `+05` del record.

| Modo | Condizione su `attributes & mask` |
|---:|---|
| 0 | Devono essere presenti tutti i bit della maschera. |
| 1 | Deve esserci almeno un bit; maschera zero accettata. |
| 2 | Non deve esserci nessun bit della maschera. |
| 3 | Non devono esserci tutti i bit della maschera. |

La routine `$C763` è stata confrontata con queste formule in 720 combinazioni, includendo entrambe le fasi. Le maschere non specificano da sole il senso narrativo di ciascun bit.

## 2. TAKE

Regola generale `$DCC1`:

```text
69 10 A2 DC
│  │  └──── predicato $DCA2
│  └─────── costo 1; secondo argomento assente
└────────── primo argomento classe9; luce; predicato
corpo Z80: $DCC5
```

La classe 9 richiede: percezione, una sola occorrenza nel record, assenza del bit personale/animato, capacità dell’attore sufficiente e nessun antenato personale nella catena dei genitori. Il predicato `$DCA2` esclude possesso già acquisito e cicli di contenimento fra attore e oggetto.

Il corpo è piccolo:

```text
IX = record del primo argomento (A013)
record[+01] = attore corrente (A036)
```

La posizione resta quella già condivisa con l’attore. Nella prova TAKE LAMP il genitore della lampada passa da `$FF` a 0. Ripetere TAKE LAMP fallisce e, in questo caso, non avanza il tempo.

### L’eccezione del biglietto in fiamme

L’entità 85 associa TAKE alla regola `$DF7E`, intestazione `88 00`: percezione, costo iniziale zero, script differito.

```text
DF80  07 C1 DC FD FF   esegui regola DCC1 sull’argomento salvato
DF85  07 8B DF FD FF   esegui regola DF8B sullo stesso argomento
DF8A  0B               riprendi il contesto sospeso
```

La prima sottoregola esegue TAKE e ha costo 1. La seconda, corpo `$DF8D`, legge il contatore `$9CA1`: se non è zero lo imposta a `$FF` e cambia il qualificatore del biglietto in SINGED, offset `$07D5`. Se è già zero non effettua questa modifica.

**Fra i due passaggi possono agire altri attori.** Non è una sequenza atomica. Le due prove sintetiche, identiche salvo il contatore iniziale, mostrano:

- contatore 10: dopo TAKE è sceso a 9; il secondo passaggio lo disabilita e rende il biglietto «singed»;
- contatore 1: scade fra i passaggi; il biglietto diventa «burnt» e perde il puntatore alla descrizione, prima che la seconda sottoregola possa salvarne il contenuto.

Il decremento non va chiamato genericamente «un timer di N minuti»: `$9CA2` è una callback associata all’attore 6 nella tabella `$9C85`, richiamata dal ciclo dopo il suo avanzamento. Per comprenderne la cadenza narrativa completa occorre analizzare lo script di quell’attore.

Le fixture collocano Holmes nella stanza 35 e rendono visibile la nota, senza simulare il percorso necessario a raggiungerla. Servono a isolare i due rami del codice, non a proporre una soluzione del gioco.

## 3. GIVE

Regola `$DF02`, intestazione `6A 1D 24 DF`, predicato `$DF24`, corpo `$DF06`.

- Primo argomento: classe A, entità percepibile posseduta dall’attore.
- Secondo argomento: classe D, entità percepibile con bit personale/animato.
- Richiede luce; costo 1.
- Il predicato controlla la capacità del destinatario tramite `$C8C6`.

Effetti:

```text
oggetto.genitore = ID del destinatario
oggetto.locazione = prima locazione del destinatario
aggiorna ricorsivamente la locazione dei figli dell’oggetto (D249)
```

GIVE LAMP TO WATSON fallisce nello stato iniziale. Dopo TAKE LAMP riesce e il genitore della lampada passa da 0 a 3. La propagazione ricorsiva deriva direttamente dalla chiamata `$D249`; questa prova con la lampada non pretende di coprire tutti i possibili contenitori e contenuti.

## 4. OPEN

### Porte e contenitori ordinari

Regola locale `$DE9D`, intestazione `38 10 80 21 00 00 00`, corpo `$DEA4`.

La maschera `$21`, in modo 2, richiede che siano spenti il bit 0 e il bit 5 del byte `+05`: l’oggetto non deve essere bloccato né già aperto. Il corpo esegue `SET 5,(IX+05)`.

Prove:

- OPEN YOUR DOOR: attributi `$80 → $A0`, apertura riuscita;
- stessa frase una seconda volta: «your door is open», corpo non eseguito;
- porta modificata in una fixture a `$81`: identificata nella pre-verifica, poi «your door is locked»;
- CLOSE YOUR DOOR, regola complementare `$DEAF`: richiede il bit 5 e lo spegne, `$A0 → $80`;
- OPEN LAMP: nessuna regola locale appropriata e nessuna regola generale OPEN, quindi rifiuto.

Questo verifica direttamente il significato dei bit «aperto» e «bloccato» nei casi trattati, oltre agli indizi raccolti nella fase precedente.

### Casseforti

Le entità 86 e 89 usano `$DFA7`, intestazione `C8 00 1C E0`: predicato `$E01C`, costo iniziale zero, script differito. Il predicato ammette soltanto l’attore 0, Holmes.

```text
DFAB  07 B6 DF FD FF   regola DFB6: preparazione/evento, costo15
DFB0  07 9D DE FD FF   regola OPEN ordinaria, costo1
DFB5  0B               ritorno
```

Per la cassaforte 86, nella fixture, la preparazione non produce un evento narrativo speciale, ma il costo 15 viene comunque assegnato; in seguito viene applicata OPEN. I costi vengono aggiunti alle scadenze dell’attore, non sommati direttamente al tempo globale nel momento dell’input: nella traccia il contatore globale passa da 2 a 17. Non va tradotto automaticamente in una promessa di «esattamente 16 minuti dal prompt» senza ricostruire il calendario dello scheduler.

Per la cassaforte 89, al giorno zero, il corpo `$DFB8` può produrre una scena di morte, dipendente anche dalla posizione di Basil. La fixture della stanza 58 raggiunge quel ramo e poi la procedura di caricamento. La prova **si arresta prima di `$C0DF`**, senza emulare il nastro. Non viene classificata come normale apertura completata. Il tempo globale viene azzerato dal flusso di fine partita: in quel caso la differenza numerica non è una durata.

## 5. SAY TO e comandi impartiti agli NPC

Regola generale `$DD9E`, intestazione `0D 10`, corpo `$DDA0`. Richiede un interlocutore percepibile con bit personale/animato, non richiede luce tramite l’intestazione, ha costo 1.

Il corpo cerca il destinatario nella tabella degli attori a `$9860`, usando `$CC0E` con passo 8:

```text
se il destinatario compare nella tabella: B86A(A=1)
altrimenti:                              B86A(A=0)
```

A=1 abilita l’analisi della citazione; A=0 la scarta. Essere un record con il bit personale non basta quindi per ricevere istruzioni. La tabella iniziale contiene 24 righe, incluso Holmes e gli otto treni: è ancora una classificazione diversa dalle 20 entità con bit personale del catalogo.

Prove osservate:

- `SAY TO WATSON "LOOK"`: vengono attraversati la risoluzione di Holmes e quella di Watson.
- `SAY TO WATSON "TAKE LAMP"`: la routine generale TAKE viene eseguita con attore 3; il genitore della lampada passa direttamente da `$FF` a 3. Il gioco stampa «Watson takes the oil lamp».
- `SAY TO WATSON "THE"`: il contenuto non costituisce una frase valida; in questa prova compare soltanto l’annuncio della conversazione, senza un errore nella zona del comando utente.
- `SAY TO ARMCHAIR "LOOK"`: rifiutato dal vincolo sul destinatario.
- Mrs Brown resa percepibile da una fixture: il gioco annuncia che le parliamo, ma non entra nell’analisi della citazione perché il suo ID non compare nella tabella degli attori.

Dopo SAY TO WATSON, una nuova riga contenente soltanto `"LOOK"` riutilizza Watson. Il raccordo `$B1CA–$B1DD` conserva a `$A002–$A007` una **tripletta nominale**, non semplicemente un ID immutabile dell’interlocutore. Quando il gruppo è omesso viene recuperato prima della risoluzione. La prova dimostra la persistenza nel caso osservato; resta da esplorare cosa succede quando il destinatario si sposta o il nome diventa ambiguo.

Non abbiamo ancora ricostruito tutte le decisioni di obbedienza, le conoscenze, le intenzioni e i dialoghi degli NPC. Abbiamo però una prova diretta che almeno il comando TAKE impartito a Watson riusa le stesse regole applicate al giocatore.

## 6. Un primo raccordo con il tempo

Non è stata ancora svolta un’analisi completa del loop, ma i punti necessari a queste regole sono identificati:

- `$9860`: righe attore da 8 byte; `+00` ID, `+01/+02` puntatore alla sequenza, `+06/+07` scadenza temporale. Gli altri campi non sono completamente descritti qui.
- `$A093`: scorre le righe; `$A0A0` confronta la scadenza con il tempo globale.
- `$A0B3`: se il costo `$A01F` è zero, prosegue l’elaborazione dello stesso attore.
- `$A0BD`: aggiunge il costo alla scadenza di quell’attore.
- `$A0CC`: chiama la callback specifica dell’attore.
- `$BFD9`: incrementa il contatore globale e il minuto dell’orologio; dopo 60 minuti cambia l’ora.

Nelle prove ordinarie qui raccolte TAKE, GIVE e OPEN riusciti avanzano il tempo globale di un minuto. I rifiuti osservati non lo avanzano. SAY TO costa un minuto anche nel caso di una citazione inutilizzabile. Le sequenze differite mostrano perché questa osservazione non basta per derivare il costo di ogni comando futuro.

## Verifiche completate

- 32 intestazioni sintetiche contro `$C9BF`: tutte le combinazioni dei quattro bit alti, in pre-verifica ed esecuzione. Verificati offset del corpo, predicato, maschere, flag Carry, assegnazione della durata ed esecuzione effettiva del corpo.
- 720 combinazioni di attributi, maschere, modi e fase contro `$C763`.
- 21 esperimenti: 15 dal prompt originale e sei fixture sintetiche chiaramente marcate.
- Asserzioni sugli effetti esatti nei record, sui due rami del biglietto, sui comandi di Watson, sui costi della cassaforte e sull’arresto prima dell’I/O nastro.
- 785 istruzioni negli estratti; 1849 byte, inclusi dati e script espliciti, ricomposti senza differenze.

Queste verifiche coprono i blocchi e i casi descritti, non tutti gli opcode del motore né ogni combinazione del mondo. Il prossimo passo naturale è ricostruire il **formato completo delle righe degli attori e l’interprete delle loro sequenze**, usando questi esempi come prove di regressione.
