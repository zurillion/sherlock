# Modalità sintattiche persistenti — $A024

Il byte `$A024` conserva la modalità del parser. Non è il modo dell’ultimo
comando eseguito da un NPC: descrive l’ultima analisi sintattica che ha scritto
il campo, anche quando l’analisi finisce con un errore. Il generatore casuale
può leggerlo molto tempo dopo quella scrittura.

| Valore | Significato |
|---|---|
| 0 | Riconoscimento automatico all’ingresso di una citazione |
| 1 | Comando |
| 2 | Affermazione, con soggetto e predicato |

## Writer e durata

Sono stati identificati sette writer espliciti nel codice originale:

| Indirizzo | Scrittura e condizione |
|---|---|
| D785 | 1 a ogni ingresso nel parser ordinario, dopo la validazione lessicale |
| B8B1 | 0 una sola volta all’ingresso nella citazione differita |
| AACC | 1 quando esiste una risposta di chiarimento pendente |
| AAEC | 2 se la scansione speculativa riconosce un soggetto senza relazioni |
| AB0A | 1 se la scansione speculativa non riconosce quel soggetto |
| B13A | 2 per HE, dopo il controllo preliminare AFE1 |
| B156 | 2 per IT/THEY, dopo il medesimo controllo |

Il ciclo B8BE ripete il parser comune AAB2 senza ristabilire il modo0 fra le
frasi della citazione. Un comando iniziale non consente quindi un secondo
autodetect dopo il punto. Il record della citazione conserva il modo finale
al byte7, letto a B8FC. THAT eredita il modo2: non è un ottavo writer.

Il lexer non scrive questo campo. Una parola sconosciuta lascia il valore
precedente; un errore sintattico può invece lasciare le scritture già effettuate.
Il wrapper ordinario D780 è diverso dal ciclo delle citazioni: anche una
seconda unità della riga passa di nuovo dalla scrittura1 a D785.

## Traduzione autonoma

Il runtime conserva `world.npcs.parserMode`. Gli aggiornamenti provengono dal
parser funzionale tramite `onMode`, dall’ingresso ordinario e dall’ingresso
nella citazione; non da una registrazione delle risposte o delle estrazioni.
Il campo è incluso nei salvataggi e nel lettore degli ingressi casuali.

Il valore iniziale è estratto dal payload, verificato separatamente su quattro
avvii originali. Un vecchio salvataggio senza campo rimane sconosciuto fino a
un writer ricostruito; un rifiuto lessicale non ne crea la proprietà.
L’invalidazione esplicita della proiezione del parser revoca anche questo byte.

## Prove e limiti

`results/parser-mode/natural-reference.json.gz` contiene una nuova acquisizione
originale: modalità ai checkpoint e a ogni estrazione, tutti i sette writer
comprese le assegnazioni che non cambiano valore, stato del mondo e bitmap.

Il confronto completo dei casi brevi include **14 storie, 41 input,
51 checkpoint, 195 estrazioni, 390 letture e 62 scritture**. Controlla tutti
24 i posti attore, l’arena da752 byte, le schermate e il roundtrip SAVE/LOAD.
Un test separato confronta la sequenza esatta delle scritture anche nel caso
esplorativo escluso dal certificato completo.

Tre tentativi restano esplicitamente fuori dal certificato:

- Il bridge di ricerca rifiuta PRINT/NOPRINT/SAVE e annulla TAKE TO. Le
  transizioni A536 del rollback non sono nuovi writer del gioco.
- `SAY WATSON "WATSON KILLED YOU"` produce7 estrazioni in JavaScript e10
  nell’originale. La modalità e le sue scritture coincidono, ma il resto della
  conversazione non è equivalente. La divergenza è riprodotta anche con il
  codice precedente, commit89d8dd3; è conservata in `unrelated-boundary.json`.

La nuova acquisizione continua della modalità e il certificato completo del
ramo del testimone sono prove distinte: i risultati finali sono nei rapporti
associati. Non cancellano il controesempio della riga temporanea del giardiniere.

## Atlante

Nuovo dossier tipizzato: **134 istruzioni, 302 byte**, tutti riassemblati e
confrontati con il payload. Approfondisce:

- A024: modalità persistente, da parziale a documentata;
- AAB2–AB10: chiarimento e selezione speculativa;
- B135–B16C: HE e IT/THEY;
- B8AA–B90D: ciclo e record delle citazioni;
- D780–D7B1: ingresso del parser ordinario.

Nessun byte prima grigio viene riclassificato. La copertura del payload diventa
38.847 byte documentati,430 parziali e2.323 sconosciuti su41.600. Questa misura
riguarda il codice e i dati analizzati, non l’equivalenza di tutto il gameplay.

## Riproduzione

```sh
python3 tools/probe-parser-mode.py
python3 tools/probe-parser-mode-boot.py
node --test test/parser-mode.test.mjs
python3 tools/probe-parser-mode.py --witness
node tools/verify-parser-mode-continuous.mjs
node tools/verify-parser-mode-prefix.mjs
node tools/verify-parser-mode-lookahead.mjs
python3 tools/build-parser-mode-listing.py
python3 tools/build-memory-map.py
```

L’originale è soltanto un oracolo offline. I file di prova e il listato non
sono importati dal motore giocabile.

## Certificato completo del ramo del testimone

La verifica positiva separata è conclusa: **438 checkpoint, da0 a437, fino a
mercoledì20:40**,8.893 estrazioni e19.026 letture confrontate. Include tutti24
posti attore, entità, fatti, programmi, arena752 byte, bitmap e futuro dopoLOAD.
Le8.895 estrazioni runtime comprendono le due estrazioni iniziali del boot.
Profilo: seed1, LOOK iniziale gratuito, grafica originale spenta dopo il boot,
input maiuscolo iniettato e conferma MORE immediata.

Il checkpoint438, verso mercoledì20:50, NON è certificato: la riga del
giardiniere8 conserva `[50,33,1]` inJavaScript contro `[50,255,1]` nell’originale,
con PC EDE1. La stessa forma di differenza era già emersa nel campionamento
continuo precedente: va ricostruita la durata degli argomenti di quel percorso,
non sostituito33 con255 per far passare il confronto. I cinque finali naturali,
il cab5D0C, PRINT/MORE, TAKE TO e il nuovo controesempio di conversazione
restano aperti. Non è rivendicata l’equivalenza dell’intero gioco.

La nuova acquisizione originale continua contiene3.461 checkpoint fino a
mercoledì19:50 e nessuna transizione di A024 non classificata. La lettura
che prima fermava Watson avviene al tick3589, mercoledì19:48: l’ultimo writer
è **D785, tick2341, Holmes0, valore1**. Si tratta della modalità lasciata dal
parser del lungo WAIT, non di un modo dedotto dal programma corrente di Watson.
La provenienza è conservata in `results/parser-mode/natural-read.json` e nei
riferimenti con SHA256; il byte1 non è usato come fallback del runtime.

Verifica conclusiva: **1.645 test passati, zero errori** nella suite generale;
158 controlli mirati passati. La prova continua di sola modalità/estrazioni
confronta3.461 checkpoint,8.763 draw e18.762 read fino a mercoledì19:50,
senza estendere il certificato di stato completo oltre il prefisso separato.
