# Decoder Python del testo di Sherlock (ZX Spectrum, versione 2.0 fornita)

Il programma principale è `sherlock_text.py`. È un decoder Python nativo: **non emula lo Z80**, non usa SkoolKit a runtime e richiede soltanto Python 3.10 o successivo e la libreria standard. Legge direttamente `SHERLOCK.TAP`, controlla checksum e hash della versione, estrae il blocco principale e ricostruisce il dizionario dai byte originali.

Il risultato è testo sul terminale oppure un catalogo TXT/JSON. Non è ancora la riscrittura del motore del gioco e non disegna la bitmap Spectrum.

## Risultati già salvati

Nella sottocartella `estratti`:

- **`texts.txt`**: 235 punti d'ingresso/frammenti decodificati, con indirizzo; contiene dialoghi, indizi, messaggi di servizio narrativi, descrizioni e parti della conclusione. Contiene spoiler.
- **`texts.json`**: stessi risultati con stato, token attraversati e parti dinamiche ancora irrisolte.
- **`locations.txt`**: 20 puntatori a descrizioni specifiche ricavati dai record delle locazioni.
- **`locations.json`**: tutti i 106 slot esaminati della tabella (compreso lo slot 0), con record sorgente, nome indicativo e campo descrizione. Non significa che esistano 106 descrizioni complete diverse.
- **`service-texts.json`**: tre stringhe non compresse del servizio nastro, nel formato alternativo con bit 7 finale.
- **`stanza-holmes-mattina.txt`**: esempio concreto selezionando la classe temporale 4.
- **`manifest.json`**: versione, area coperta, conteggi e parametri dell'estrazione.

151 punti d'ingresso producono testo senza parti dinamiche irrisolte con le impostazioni simboliche predefinite; 84 contengono segnaposto. Si tratta di frammenti e ingressi anche condivisi, **non di 235 dialoghi indipendenti**.

## Utilizzo

Dalla cartella del progetto:

```sh
cd '/Users/giovanni/Documents/Development/Sherlock rebuild'

# Rigenera tutto il catalogo, conservando le parti dinamiche come annotazioni.
python3 -B sherlock-analisi/decoder/sherlock_text.py extract

# Decodifica un frammento noto.
python3 -B sherlock-analisi/decoder/sherlock_text.py decode 0x6859

# Descrizione della stanza di Holmes, nella condizione di mattina.
python3 -B sherlock-analisi/decoder/sherlock_text.py --time-class 4 decode 0x7D62

# Stesso testo con a capo a 36 colonne.
python3 -B sherlock-analisi/decoder/sherlock_text.py --time-class 4 --width 36 decode 0x7D62

# Un biglietto di Watson.
python3 -B sherlock-analisi/decoder/sherlock_text.py decode 0x807A

# Decodifica una parola: offset $18B, contesto $40 => carries.
python3 -B sherlock-analisi/decoder/sherlock_text.py word 0x418B

# Stringa semplice: REWIND TAPE.
python3 -B sherlock-analisi/decoder/sherlock_text.py plain 0xC0A5

# Imposta esplicitamente i valori delle due celle di contesto.
python3 -B sherlock-analisi/decoder/sherlock_text.py --subject 0 --other 0 decode 0x680B
```

Gli indirizzi accettano `0x6859`, numeri decimali oppure `'$6859'` (il dollaro va protetto nella shell). Le opzioni globali precedono il sottocomando. `decode --json` include la provenienza dei token. `--source` accetta il TAP oppure il payload grezzo `block-10.bin` già estratto; il formato TZX e gli snapshot non sono letti direttamente da questo script.

Per estrarre in una destinazione diversa, usare `extract --out /percorso/scelto`. Per impostazione predefinita tutti i risultati restano accanto allo script, nella cartella `estratti` del progetto.

## Esempio reale

`--time-class 4 decode 0x7D62` produce:

> The sun streams in the two broad windows in your sitting room. There is a pipe rack to the right of the sofa. Bullet pock marks are the feature of one wall, and charts and diagrams fill another. An acid stained table sits in the corner.

`decode 0x807A` produce:

> Dear Sherlock, I have gone back to the practice to see a few patients. Will be back later.      Watson.

I nomi, la grafia e le spaziature provengono dal gioco: il decoder non li corregge editorialmente.

## Cosa viene implementato

- Il dizionario di 592 record, rileggendo l'indice alfabetico e i record compressi.
- I caratteri a 5 bit, l'iniziale implicita e il riuso dei prefissi.
- I suffissi e le cancellazioni della lettera finale.
- I token a un byte delle parole frequenti e i riferimenti lunghi con contesto.
- I frammenti letterali a 5 bit e i caratteri letterali.
- I richiami e i salti relativi a frammenti condivisi, con controllo di cicli e profondità.
- Le terminazioni con o senza punto/ritorno a capo.
- Il buffer delle parole, gli spazi, le maiuscole e, su richiesta, gli a capo a 36 colonne.
- Le condizioni basate sulla classe temporale, se specificata.
- La rappresentazione simbolica dei comandi che richiedono argomenti o stato non ricostruito.
- Il formato semplice `$C1CB`, terminato dal bit 7 dell'ultimo carattere.

## Cosa significano le annotazioni

I delimitatori **⟦...⟧ sono inseriti dal decoder**, non compaiono nel testo originale.

- `⟦nome referente $A036⟧`: qui il gioco inserisce il nome dell'entità corrente. Serve il contesto del mondo per scegliere quello corretto.
- `⟦say | says: dipende da $A036⟧`: entrambe le forme sono ricostruibili; manca il valore del selettore.
- `⟦scelta: say/says / remark/remarks⟧`: alternativa selezionata dal gioco, non una sequenza da stampare interamente.
- `⟦se classe temporale=...⟧ ... ⟦fine condizione⟧`: testo condizionale, mostrato a fini di analisi.
- `⟦testo da argomento stack⟧`: frammento fornito dal chiamante, non determinabile dal solo indirizzo della stringa.

Le annotazioni delimitano la parte ignota; non pretendono di ricostruire uno stato di partita. Se si specificano `--subject` e `--other`, si forniscono rispettivamente i byte delle celle `$A034` e `$A036`. I nomi delle opzioni sono convenzioni del programma e **non costituiscono una classificazione grammaticale dimostrata di quelle celle**.

`--time-class` seleziona il risultato della routine `$C00C`:

| Classe | Etichetta orientativa | Condizione originale |
|---:|---|---|
| 1 | notte | AM ore 12 o 1–5; PM ore 8–11 |
| 2 | tramonto | PM ore 7 |
| 3 | pomeriggio | PM ore 1–6 |
| 4 | mattina/giorno | AM ore 7–11; PM ore 12 |
| 5 | alba | AM ore 6 |

Le etichette sono descrittive; le condizioni sono quelle lette dal codice, non un modello astronomico.

## Area del gioco identificata

L'area contigua decodificata è **$67F7–$8257** (estremo finale esclusivo `$8258`). Il decoder la percorre rispettando le lunghezze di token, argomenti, scelte e frammenti compatti, ottenendo 216 segmenti fisici. Aggiunge gli ingressi richiamati dentro altri frammenti e quelli indicati dalle descrizioni delle locazioni, arrivando a 235 indirizzi.

La tabella usata per le locazioni è a `$840B`: la routine `$D224` la indicizza. Il percorso `$D113/$D16B` legge il puntatore al testo dai campi `+7/+8` del record e lo passa a `$A59F` attraverso `$D182`. Gli slot esaminati sono 0–105; lo slot successivo è separato perché punta alla lista oggetti a `$8B6F`. I nomi indicativi nel catalogo sono le basi lessicali dei campi del record, non il risultato completo della routine che aggiunge articoli e grammatica.

Molti record hanno il campo descrizione zero: il gioco può usare una descrizione generica e il nome, oppure altri percorsi di composizione. Non va interpretato come un errore di estrazione.

L'area contiene chiaramente dialoghi e narrazione oltre alle descrizioni. Non sono ancora stati ricostruiti tutti i collegamenti fra ogni frammento, personaggio e condizione narrativa. Non è dimostrato che questo catalogo copra qualsiasi testo possibile in ogni stato del gioco.

## Verifica indipendente

`verify_decoder.py` richiede SkoolKit, già presente nella cartella del progetto. Il decoder principale non lo richiede.

- Confronta le 592 voci e i loro indirizzi con l'estrazione precedentemente verificata sullo Z80.
- Confronta 151 ingressi statici in due contesti, per **302 esecuzioni**, contro l'interprete e il formattatore Z80 originali.
- Aggiunge le **cinque classi temporali** della stanza di Holmes: **307 confronti passati, zero differenze**.
- Per questi confronti sostituisce soltanto il canale bitmap `$C2BA` per catturare il testo già formattato, senza scorrimento. Non sostituisce il dizionario, il decoder, la scelta dei suffissi o la gestione delle maiuscole. Gli spazi finali introdotti dal flush di prova vengono normalizzati.
- `verify_wrap.py` confronta sei esempi a 36 colonne eseguendo anche il renderer e lo scorrimento originali, con osservazione delle emissioni e degli a capo. Non copre l'interazione della pausa di paginazione.

I risultati sono in `verification.json` e `wrap-verification.json`.

```sh
python3 -B sherlock-analisi/decoder/verify_decoder.py
python3 -B sherlock-analisi/decoder/verify_wrap.py
```

L'esportazione con annotazioni è uno strumento di analisi: non viene dichiarata equivalente a un'esecuzione concreta finché non sono disponibili gli argomenti richiesti. I frammenti con comandi non risolti restano marcati `symbolic` anche quando il loro testo statico è leggibile.


## Stampa di tutte le locazioni

`print_locations.py` riusa il decoder e stampa tutti i 106 slot della tabella,
non soltanto i 20 dotati di descrizione specifica. Ogni voce ha un separatore,
ID, nome indicativo e indirizzo del record. Lo slot 0, senza nome, è segnalato
separatamente; le 105 voci denominate mantengono il proprio ID anche quando
condividono il nome. I campi descrizione nulli sono indicati esplicitamente.

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/decoder/print_locations.py
python3 -B sherlock-analisi/decoder/print_locations.py --time-class 4
python3 -B sherlock-analisi/decoder/print_locations.py --output sherlock-analisi/decoder/estratti/tutte-le-locazioni.txt
```

Il catalogo completo è già salvato in `estratti/tutte-le-locazioni.txt`.
Senza `--time-class` le alternative temporali restano annotate; con il parametro
viene selezionata una sola classe. `--columns` cambia la larghezza editoriale del
catalogo (predefinita: 88). `--help` elenca le altre opzioni.


Per escludere le locazioni con puntatore alla descrizione zero, aggiungere
`--only-described`. Il filtro mantiene gli ID originali e può essere combinato
con `--time-class`, `--columns` e `--output`:

```sh
python3 -B sherlock-analisi/decoder/print_locations.py --only-described --time-class 4
```

Nella versione analizzata vengono stampate 20 locazioni ed esclusi 86 slot.
Senza l'opzione il catalogo completo resta invariato.
