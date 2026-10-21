# Sherlock: dal testo compresso ai pixel

Analisi del 19 ottobre 2026 sulla versione fornita dall'utente. Tutti gli indirizzi sono esadecimali e si riferiscono alla RAM del gioco caricato. Fonte primaria: byte originali e loro esecuzione tramite SkoolKit 10.1. Nessuna ricostruzione del gioco in Python: gli script allegati sono strumenti di ricerca e verifica.

## Risultato principale

L'ipotesi di partenza è confermata: esistono un dizionario compresso, riferimenti alle parole, suffissi e condizioni che selezionano la forma da emettere. Non c'è però un solo formato di stringa. Il gioco combina:

- un dizionario alfabetico con **592 record**, comprese voci ripetute e basi che non sono parole complete;
- lettere codificate in **5 bit**;
- conservazione del prefisso della voce precedente;
- **32 parole frequenti** richiamabili con un solo byte;
- riferimenti a 12 bit con un contesto di emissione;
- frammenti letterali compatti;
- comandi per comporre frasi, inserire elementi dinamici e decidere quando terminare;
- alcune stringhe di servizio non compresse, in un formato distinto.

La scelta delle desinenze è più ampia del singolare/plurale: comprende anche forme verbali e avverbi. Non va identificato automaticamente ogni flag con una categoria grammaticale.

## Il percorso delle chiamate

```text
$A59F / $A5C4  interprete delle sequenze di testo
       $A5CD  distingue token, comandi e frammenti letterali
          |
          +-- $A840 -> tabella delle parole frequenti
          +-- $A887 -> ricostruzione di una voce del dizionario
          |      +-- $A95B -> riuso del prefisso e decodifica del record
          |      +-- $A990 -> estrazione di un carattere a 5 bit
          |      +-- $A92F -> applicazione del suffisso
          +-- $A990 -> frammento letterale a 5 bit
                 |
              $A9B7  buffer di una parola e decisione dell'a capo
              $AA14  spazi e maiuscole
              $C1E1  selezione del canale di stampa
                 |
           +-----+-----+
           |           |
        $C2BA        $C1FD
        testo        canale inferiore, maiuscole,
        superiore    backspace e cursore
           |           |
           +-----+-----+
              $C388  disegno del glifo nella bitmap
```

Gli indirizzi costituiscono punti di partenza per leggere `text.asm`, che comprende indirizzi, byte originali e commenti. `text.skool` e `text.ctl` sono le versioni utilizzabili da SkoolKit.

## 1. Dove si trovano le parole

| Zona | Contenuto verificato |
|---|---|
| $5D80–$5DBF | Tabella di offset; gruppi alfabetici e valore limite |
| $5DC0–$67B5 | 592 record del dizionario |
| $67B6 | Byte zero di separazione: funzione precisa ancora da stabilire |
| $67B7–$67F6 | 32 riferimenti alle parole frequenti |
| $A85C–$A87F | Nove suffissi, quattro byte per voce |
| $5C42 | Buffer usato per ricostruire la voce, senza l'iniziale implicita |
| $5C0B | Buffer usato per raccogliere una parola prima della stampa |

Un riferimento al dizionario è un **offset relativo a $5DBF**, non un numero progressivo di parola. Per esempio, `$4AD` identifica il record a `$626C`, corrispondente alla base `know`.

La prima lettera non viene ripetuta in ciascun record: si ricava dal gruppo alfabetico. Per ricostruire una voce il programma parte dall'inizio del gruppo e attraversa i record precedenti. Questo è necessario perché la voce può conservare parte della precedente.

`dictionary.txt` mostra le voci, gli indirizzi, i flag e il risultato della trasformazione quando viene forzato il suffisso. Quella colonna **non è una lista di plurali**: è il risultato meccanico della tabella. Alcune combinazioni forzate non sono forme grammaticali valide e non è dimostrato che il gioco le richieda durante una partita. `dictionary.json` conserva anche i byte e i metadati necessari a controllare ogni estrazione.

## 2. Struttura di un record

```text
byte 0: metadati; nibble basso = indice del suffisso
byte 1: bit 7    = presenza di due byte aggiuntivi
        bit 6–4 = numero di caratteri da conservare dal buffer precedente
        bit 3–0 = numero di nuovi caratteri a 5 bit
[2 byte aggiuntivi, se richiesti dal bit 7]
nuovi caratteri impacchettati, da bit più significativo a meno significativo
```

Il decoder di stampa salta i due byte aggiuntivi; il loro significato semantico resta da ricostruire. Sono presenti in 29 record. Anche il nibble alto del byte 0 non è ancora classificato completamente.

Ogni valore a 5 bit diventa un carattere aggiungendo `$60`. I valori 1–26 corrispondono quindi ad `a`–`z`. Il decoder `$A990` usa HL come puntatore e C come posizione di bit: legge una finestra di due byte, la allinea, estrae cinque bit e avanza il cursore.

Esempio verificato:

- `about`, record a `$5DC4`: iniziale implicita `a`, descrittore `$04`, quattro lettere nuove `bout`, byte compatti `13 EB 40`.
- `above`, record successivo a `$5DC9`: iniziale `a`, descrittore `$22`: conserva `bo` dal resto precedente `bout` e aggiunge `ve`, codificato in `B1 40`.

Il risultato è `a` + `bo` + `ve`. Questo spiega perché estrarre le stringhe ASCII dal binario non basta.

## 3. Come variano le parole

La routine `$A92F` seleziona il suffisso con il nibble basso del byte 0 del record:

| Indice | Byte significativi | Effetto |
|---:|---|---|
| 0 | `S` | aggiunge s |
| 1 | `ES` | aggiunge es |
| 2 | `IES` | aggiunge ies, senza cancellazione |
| 3 | `$08 I E S` | cancella l'ultimo carattere e aggiunge ies |
| 4 | `D` | aggiunge d |
| 5 | `ING` | aggiunge ing |
| 6 | `ED` | aggiunge ed |
| 7 | `$08 I N G` | cancella l'ultimo carattere e aggiunge ing |
| 8 | `LY` | aggiunge ly |
| $F | nessuno | lascia la base invariata |

Le desinenze sono memorizzate in maiuscolo; il livello successivo normalizza il caso. Il byte `$08` arretra il puntatore del buffer parola: in questo percorso la cancellazione avviene prima del disegno dei caratteri.

Esempi eseguiti con il codice originale:

| Riferimento | Base | Suffisso | Risultato |
|---|---|---|---|
| $18B | carry | $08 + IES | carries |
| $38D | go | ES | goes |
| $3DF | have | $08 + ING | having |

Una stessa base può avere più record: `carry` esiste anche al riferimento `$18F`, con la desinenza ING. Dunque la trasformazione dipende anche da **quale record** viene richiamato.

L'ingresso `$A887` riceve DE: i 12 bit bassi identificano il record, il nibble alto sceglie il contesto:

| Contesto | Comportamento effettivo in $A887 |
|---|---|
| $50 | non applica il suffisso |
| $40 | applica il suffisso se il record ne prevede uno |
| $10 | applica il suffisso se la cella $A034 è diversa da zero |
| altri | applica il suffisso se la cella $A036 è diversa da zero |
| $70 | oltre alla regola precedente, richiede la maiuscola della prossima lettera |

Queste condizioni sono verificate. I ruoli esatti di `$A034` e `$A036` nel contesto linguistico e nel mondo di gioco richiedono l'analisi dei chiamanti: non li etichettiamo ancora come due semplici flag di numero grammaticale.

## 4. Come sono memorizzate le frasi

Il dispatcher `$A5CD` riconosce queste classi:

| Primo byte | Interpretazione |
|---|---|
| $00–$1F | comando attraverso la tabella di indirizzi a $A55D |
| $20–$3F | carattere letterale, per esempio spazio o punteggiatura |
| $40–$5F | frammento di `(byte AND $1F)+1` caratteri a 5 bit |
| $60–$7F | una delle 32 parole frequenti |
| $80–$FF | riferimento lungo: due byte, offset a 12 bit e contesto a 3 bit |

Per il riferimento lungo, il primo byte contiene `$80 | contesto | parte alta dell'offset`; il secondo contiene la parte bassa. Non va confuso con le word little-endian delle tabelle.

Esempi della tabella frequente: `$60=the`, `$61=to`, `$62=a`, `$63=and`, `$64=you`, `$6B=i`, `$6D=not`. La tabella completa è in `frequent-words.json`. Questi token usano il contesto $50, quindi emettono la base senza suffisso.

I comandi non si limitano alla fine stringa: sono presenti letture di argomenti dallo stack, richiami di altri frammenti, inserimento di nomi e alternative condizionali. La mappa dei 32 handler è nel listing, ma non tutti i contratti sono ancora ricostruiti. Le terminazioni già lette sono:

- `$1F`: fine senza punto o CR;
- `$1D`: fine con CR;
- `$1E`: fine con punto e CR.

I riferimenti lunghi nei contesti $20, $30 e $60 possono stampare l'ultima parola e terminare direttamente, rispettivamente senza aggiunte, con punto+CR e con CR. Perciò non bisogna cercare semplicemente un byte zero come terminatore universale.

### Un esempio completo verificato

A `$6859` sono presenti questi 13 byte:

```text
6B 6F 6D D4 AD 60 20 43 BB E4 40 22 1F
```

| Byte | Decodifica |
|---|---|
| 6B 6F 6D | i, do, not |
| D4 AD | riferimento $4AD, contesto $50: know |
| 60 | the |
| 20 | spazio |
| 43 BB E4 40 | quattro caratteri a 5 bit: word |
| 22 | virgoletta |
| 1F | fine |

Il codice originale, con richiesta iniziale di maiuscola, produce:

```text
I do not know the word "
```

La virgoletta resta aperta perché è un frammento. Non abbiamo aggiunto il testo successivo né ipotizzato che sia una frase completa. `phrase_probe.py` esegue il frammento attraverso l'interprete e la stampa bitmap, senza sostituirne le routine. `phrase-verification.json` elenca anche i token realmente visitati; `phrase-demo.png` mostra lo schermo prodotto.

## 5. Dalla parola alla riga

`$A9B7` raccoglie i caratteri in un buffer a `$5C0B`. Quando arriva spazio, CR o virgoletta, confronta la lunghezza con le colonne disponibili in `$C1F5`. Se serve, emette un CR prima della parola, quindi svuota il buffer. È il livello che evita di spezzare le parole a fine riga.

`$AA14` normalizza inizialmente le lettere in minuscolo e gestisce spazi iniziali e maiuscole. Punto e virgoletta possono richiedere una maiuscola successiva tramite `$A026`; `$A851` è uno stato aggiuntivo di forzatura. Questo livello spiega perché il dizionario non debba conservare tutte le varianti maiuscole.

`$C1E1` seleziona il canale: con `$A027=0` usa `$C2BA`, la finestra superiore; altrimenti usa `$C1FD`, il canale inferiore. `$5C3C=0` sopprime l'output. Il ramo alternativo di `$A9B7` può saltare la normale raccolta della parola.

Il canale superiore gestisce scorrimento e pausa di paginazione; quello inferiore gestisce anche il backspace, converte in maiuscolo e disegna un cursore `+`. I due canali conservano indirizzi bitmap, colonne rimaste e offset di bit separati in `$C1F4–$C1FB`.

## 6. La routine che disegna realmente i caratteri

**$C388 è il renderer di un singolo carattere.**

- A: codice del carattere;
- HL: indirizzo del primo byte video interessato;
- C: offset orizzontale in bit, da 0 a 7.

Calcola l'indirizzo del glifo come `$3C00 + 8*A`, nella ROM Spectrum, e legge otto righe. Per ogni riga sposta i bit, conserva i pixel esterni alla maschera e unisce il glifo a uno o due byte della bitmap. `INC H` avanza alla riga pixel successiva secondo la disposizione video Spectrum.

Alla fine aggiorna HL/C con un avanzamento di **sette pixel**. Il glifo sorgente ha otto righe da otto bit, ma il passo orizzontale è sette: da qui la modalità di 36 colonne. La modalità più stretta usa 18 colonne. Il codice legge il font ROM, ma non delega il disegno alla routine PRINT della ROM.

Questa routine non conosce dizionario, grammatica o parole: riceve solo un codice carattere e una posizione.

## 7. Esiste anche testo non compresso

`$C1CB` stampa una sequenza in HL mascherando il bit 7 e termina quando quel bit è impostato nel byte sorgente. La usa attraverso `$C1FD`, con un percorso diverso dal testo narrativo.

Esempi nel codice di servizio sono `REWIND TAPE` e `TAPE ERROR`, seguiti da un punto con bit 7 impostato. `$C1A8` è un altro ingresso: stampa un numero noto di caratteri a una posizione fissa e viene usato dal codice dell'orologio. Non tutte le stringhe del gioco sono quindi compresse allo stesso modo.

## Verifiche e limiti

1. Ricostruzione indipendente dei 592 record confrontata con l'esecuzione di `$A95B`: buffer e puntatore finale coincidono in tutti i casi. Il decoder Z80 non è stato sostituito.
2. 4.144 prove di `$A887`: 592 record × 7 combinazioni di contesto e celle di stato. Qui soltanto `$A9B7` viene intercettata per raccogliere i caratteri e isolare la decodifica dalla grafica. Tutti i confronti passano.
3. Prova completa di sei parole attraverso buffer, formattazione e renderer originali: `sherlock holmes watson carries goes having`. L'intercettazione a `$C2BA` è soltanto osservativa, senza saltare il codice. Schermata ispezionata in `print-demo.png`.
4. Esecuzione del frammento originale a `$6859` senza stub nelle routine di testo o stampa. Risultato esatto verificato e schermata salvata in `phrase-demo.png`.
5. Istruzioni e direttive del listing ricodificate e confrontate con lo snapshot originale: 932 elementi, 1.688 byte identici. Questa verifica copre gli estratti selezionati, non un'immagine assemblabile completa del gioco.

Sono esperimenti di sottosistemi con stato controllato, non una partita completa. La scelta delle forme nei dialoghi reali, tutti i comandi dell'interprete, i metadati del dizionario e l'elenco completo dei messaggi restano da analizzare. Il dizionario estratto non equivale all'estrazione di tutti i testi.

## Come riprodurre

Dalla cartella `Sherlock rebuild`:

```sh
python3 -B sherlock-analisi/testo/analyze_text.py
python3 -B sherlock-analisi/testo/phrase_probe.py
python3 -B sherlock-analisi/testo/build_listings.py
python3 -B skoolkit-10.1/trace.py -m 1 sherlock-analisi/testo/print-demo.z80 sherlock-analisi/testo/print-demo.png
python3 -B skoolkit-10.1/trace.py -m 1 sherlock-analisi/testo/phrase-demo.z80 sherlock-analisi/testo/phrase-demo.png
```

Le ultime due istruzioni generano immagini dalla memoria video degli snapshot, eseguendo una sola istruzione del bootstrap al ritorno sintetico. Non modificano i nastri. Gli esperimenti impostano stack, registri e alcune celle di stato nelle copie in memoria; i dettagli sono visibili negli script.

## Prossima indagine consigliata

Seguire i chiamanti di `$A887` e i comandi di `$A5CD` per assegnare un significato preciso a `$A034/$A036`, agli altri metadati e alla scelta dei riferimenti nei dialoghi. Questo collegherà le trasformazioni già verificate alla grammatica effettiva del gioco.
