# Sherlock v2.0 — interprete grafico e ricostruzione Python

L'interprete e il formato delle immagini sono stati ricostruiti dal TAP fornito. La tabella contiene **14 locazioni e 13 disegni distinti**: Platform One e Platform Two condividono lo stesso stream. I 13 stream occupano complessivamente **2.496 byte**.

Il programma `sherlock_graphics.py` interpreta i dati in Python nativo: non usa un emulatore Z80. SkoolKit serve soltanto per verificare il risultato e rigenerare il listing. Le immagini si trovano in `immagini/`; aprire `immagini/index.html` per il confronto.

## Esecuzione

Dalla cartella principale del progetto:

```sh
cd "/Users/giovanni/Documents/Development/Sherlock rebuild"

# Elenco delle locazioni illustrate, indirizzi e dimensioni degli stream.
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --list

# Tutte le immagini: PNG 1024 × 1408 e SVG scalabili.
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --scale 8

# Tutte le immagini con segmenti retti (nuova variante).
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --mode straight --scale 8

# Solo Baker Street, PNG 2048 × 2816 e relativo SVG.
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --location 5 --scale 16 -o sherlock-analisi/grafica/baker-hires

# Riquadro superiore quadrato: 1024 × 1024.
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --location 5 --crop-picture -o sherlock-analisi/grafica/ritagli

# Raster originale, senza semplificazioni: 128 × 176.
python3 -B sherlock-analisi/grafica/sherlock_graphics.py --mode exact --scale 1
```

Per l'esportazione serve **Pillow** (già presente nell'ambiente usato). Il decoder riutilizza `../decoder/sherlock_text.py` per caricare/verificare il TAP e recuperare i nomi. `--source` accetta anche `block-10.bin`; il controllo della versione è lo stesso del decoder testuale. Gli ID sono numerici, con eventuale prefisso `0x` oppure `$` (quest'ultimo va quotato nella shell). Senza `--location` vengono esportate tutte le 14 associazioni, comprese le due immagini identiche dei binari ferroviari.

`--scale` ammette 1–32; nella modalità `exact` ingrandisce i pixel, nelle modalità `smooth` e `straight` rasterizza nuovamente i contorni vettoriali. I file con lo stesso nome nella directory di destinazione vengono aggiornati: usare `-o` per conservare varianti.

## Mappa del codice

| Indirizzo | Ruolo |
|---|---|
| `$A25D` | Controlla abilitazione grafica e cerca l'ID della locazione nella tabella |
| `$A277` | Prepara il video e chiama l'interprete con HL=puntatore allo stream |
| `$C129` | Imposta il canale narrativo stretto, 18 colonne |
| `$D34E` | Ricerca in una tabella di triple, terminata da ID `$FF` |
| `$F3C2` | Interprete delle istruzioni grafiche |
| `$F490` | Riempimento scanline con stack di seed |
| `$F50D` | Test del bit di un pixel |
| `$F514–$F549` | Movimenti nella memoria degli attributi |
| `$F54A–$F56D` | Movimenti del cursore con controllo dei margini |
| `$F56E` | Tracciamento di un segmento a gradini |
| `$F5D2` | Accensione del pixel e aggiornamento dell'attributo INK |
| `$F5FB` | Conversione delle coordinate in indirizzo/maschera bitmap, via ROM `$22AA` |

Il puntatore a `$A0D8` vale **`$F60C`**. La tabella contiene record `[ID, puntatore basso, puntatore alto]`; termina a `$F636` con `$FF`. Gli stream referenziati sono nell'intervallo `$F638–$FFFF`, ma **8 byte tra alcuni stream non vengono eseguiti**. Sono `$F867`, `$F927`, `$FF41–$FF46`; non ne è stato attribuito un significato. Anche `$F637` resta fuori dalla tabella e dagli stream.

`$F48E/$F48F` sono flag temporanei del fill, **non istruzioni**. `$F60B` è il colore corrente, inizialmente `$38` nel binario; ogni fill lo imposta al proprio colore e poi lo riporta a zero. Il decoder conserva anche questo particolare, senza normalizzarlo arbitrariamente.

Il listing `graphics.asm` separa codice e dati e riporta indirizzo, byte e commenti. Un dettaglio insolito: `$F52E` salta a `$F532`, cioè nel secondo byte di `SBC HL,DE` (`ED 52`). Eseguito da lì, `$52` è `LD D,D`; il listing lo segnala. Non è un errore da correggere.

## Sistema di coordinate e dimensioni

Le istruzioni MOVE/FILL memorizzano x locale; il codice applica `x | 128`, per disegnare nella metà destra del video. Le coordinate effettive sono:

- **x = 128…255**, larghezza 128;
- **y = 0…175**, con y crescente verso l'alto;
- riga fisica sullo schermo, dall'alto: **`175 - y`**.

L'area ammessa dal motore è dunque **128 × 176**, rapporto **8:11**, conservato nell'esportazione completa. Quasi tutta la composizione occupa il riquadro superiore **128 × 128**. Ci sono però 2 pixel della locazione 92 e 4 della locazione 61 anche sulla riga fisica 128. Per questo il ritaglio quadrato è esplicito (`--crop-picture`), non il comportamento predefinito. La galleria mostra inizialmente il riquadro quadrato e permette di passare all'area completa.

## Formato delle istruzioni

Il dispatch controlla i casi **nell'ordine indicato**. I flag non sono categorie indipendenti: un opcode con bit7 e bit6 accesi è un segmento, non un fill.

| Opcode | Byte successivi | Significato |
|---|---|---|
| `$00` | nessuno | Fine del disegno |
| `$08` | x, y | Spostamento assoluto del cursore senza tracciare |
| bit7 = 1 | q | Segmento: direzione, periodo e numero di pixel |
| bit7 = 0, bit6 = 1 | x, y | Fill con colore `opcode & 7` |
| bit7/6 = 0, bit5 = 1 | alto, basso, run…, `$FF` | Cammino nella memoria attributi; PAPER=`opcode & 7` |
| altri | nessuno | Ignorati dall'interprete |

### Segmenti: non è Bresenham

Dati opcode `p` e secondo byte `q`:

```python
direction = p & 7
period = 1 + ((p >> 1) & 0x3c) + (q >> 6)
length = 1 + (q & 0x3f)
```

`period` e `length` sono compresi tra 1 e 64. `direction` si divide così:

- bit0: 0 = asse maggiore x, 1 = asse maggiore y;
- bit1: 1 = y decrescente, 0 = y crescente;
- bit2: 1 = x decrescente, 0 = x crescente.

L'algoritmo accende un pixel, avanza di un passo sull'asse maggiore e, ogni `period` passi, avanza anche sull'altro asse. Ripete per `length` pixel oppure si ferma contro il margine. Il cursore finale è normalmente **un passo oltre l'ultimo pixel acceso**: il successivo segmento riparte da lì. Non va confuso con l'estremo visibile del segmento.

Il contatore del periodo riparte da capo per ogni istruzione. Per ottenere un tratto orizzontale o verticale basta un periodo maggiore o uguale alla lunghezza; nel caso di uguaglianza il passo sull'asse minore può avvenire dopo l'ultimo pixel, modificando comunque il cursore. Tutti i disegni reali iniziano con un MOVE.

Esempio, Baker Street:

```text
$FF47  08 2E 9F   MOVE x locale=46, y=159   → video (174,159)
$FF4A  90 CB      segmento direzione=0, periodo=12, lunghezza=12
$FF4C  87 D0      segmento direzione=7, periodo=4, lunghezza=17
```

`instructions.txt` traduce ogni comando di ogni locazione. `immagini/instructions.json` contiene gli stessi dati in forma elaborabile, con intervalli di indirizzi e byte originali.

### Riempimento

È un **flood fill scanline**, senza ricorsione di sottoprogrammi: usa lo stack Z80 come pila di coordinate da visitare.

1. Imposta il colore INK e inserisce una sentinella con y=`$B0` (176, esterna all'area).
2. Dal seed cammina a sinistra fino a un pixel già acceso o al margine.
3. Scorre verso destra, accendendo i pixel vuoti.
4. Per ciascuna corsa vuota nelle due righe adiacenti inserisce un seed sullo stack.
5. Estrae il seed successivo e ripete; la sentinella termina il lavoro.

**La barriera è il bit del bitmap, non il colore visibile.** Il fill ripassa anche alcuni pixel di bordo già accesi: il bit non cambia, ma può cambiare INK nell'intera cella 8 × 8. Un comune flood fill RGB non riproduce questa semantica. Il cursore dei segmenti viene preservato; alla fine il colore corrente torna a nero.

### Colori e cammini di attributi

Lo Spectrum assegna un INK e un PAPER a ogni cella 8 × 8. Il plot conserva PAPER, imposta INK e azzera BRIGHT/FLASH; se il colore INK richiesto coincide con PAPER, usa il complementare `INK XOR 7`.

Il comando PAPER opera direttamente sulla memoria attributi. I primi due byte sono alto/basso dell'indirizzo, ma al basso viene sommato `$10` **senza propagare il riporto**. Ciascun run ha:

```python
direction = run & 3            # 0 su; 1 destra; 2 giù; 3 sinistra
length = 1 + (run >> 2)        # FF è invece il terminatore
```

Per ogni cella imposta PAPER, mantiene INK (complementandolo se diventerebbe invisibile) e si sposta. Le routine controllano la pagina alta `$57/$5A`, non un rettangolo geometrico convenzionale. Non bisogna sostituirle con un generico clipping senza verificarne l'effetto.

## Ricostruzione ad alta risoluzione: cosa è originale e cosa no

La modalità **exact** traduce l'interprete e conserva la griglia originale. È il riferimento per lo studio del gioco. Se ingrandita, mantiene deliberatamente i pixel quadrati.

La modalità **smooth** è una ricostruzione vettoriale conservativa:

1. Esegue i comandi decodificati e il fill fedele alla risoluzione nativa, così i confini delle regioni sono quelli del gioco.
2. Estrae i contorni orientati del bitmap risultante, inclusi i buchi e le componenti separate.
3. Semplifica i contorni con Douglas–Peucker, tolleranza **0,85 pixel originali**, per ridurre le scalettature.
4. Rasterizza i poligoni alla nuova risoluzione, con antialias. Applica gli INK/PAPER originali e conserva il rapporto d'aspetto.
5. Esporta anche un **SVG senza bitmap incorporate**, composto da contorni e celle colore.

Quindi non è un semplice ingrandimento della bitmap, ma nemmeno un replay delle sole primitive originali su una griglia più grande: la topologia viene risolta sulla griglia nativa, poi vettorializzata. Non si recuperano dettagli che il gioco non memorizza. Le linee molto sottili e i dettagli minuti possono conservare parte della struttura della griglia o cambiare leggermente con la semplificazione; la modalità `exact` resta il riferimento filologico.

Un tentativo di rendere prima continui i segmenti e poi eseguire il fill ad alta risoluzione ha aperto/chiuso varchi assenti/presenti sul raster originale. Per evitare regioni di colore sbagliate, il programma finale usa il procedimento descritto sopra. La variante `straight` descritta sotto affronta la rettifica mantenendo i contorni già risolti dal motore originale.

La tavolozza di visualizzazione usa intensità normale 205 e BRIGHT 255: è una scelta RGB di presentazione, non una misura del segnale analogico dello Spectrum. Rimangono i cambi di colore a blocchi di 8 × 8; eliminarli richiederebbe ricostruire una suddivisione cromatica che i dati non definiscono a livello di singolo pixel.

## Aggiornamento: PNG corretti e SVG con linee rette

Le linee spurie nei PNG delle locazioni **054, 055 e 074** dipendevano dalla rasterizzazione dei contorni, non dai dati del gioco. Il vecchio codice disegnava i contorni uno alla volta, con bordi inclusivi di Pillow e riempimenti alternati in base all'orientamento. Questa procedura non equivale alla regola SVG `evenodd`, specialmente dove i contorni coincidono o si intersecano dopo la semplificazione. Ora PNG e SVG adottano entrambi **la regola pari/dispari**, con campionamento ai centri dei pixel e intervalli semiaperti. Sono stati rigenerati tutti i PNG `smooth`.

La nuova modalità **`--mode straight`** produce file `*-straight.svg` e `*-straight.png`. A differenza di `smooth`, non si limita a semplificare la silhouette dei pixel:

1. Per ogni primitiva LINE conserva i pixel realmente attraversati e associa ciascun pixel all'indirizzo del comando.
2. Definisce il segmento geometrico tra il centro del primo e quello dell'ultimo pixel tracciato, con una penna larga un'unità della griglia originale.
3. Associa i bordi delle regioni ai segmenti che li hanno generati; sostituisce le catene di gradini con i lati rettilinei della penna.
4. Ricava i vertici dalle intersezioni fra questi lati. Per evitare punte eccessive, limita i giunti lontani a proiezioni locali (soglia 2 pixel originali).
5. Esporta i contorni rettificati in SVG e rasterizza gli stessi contorni per il PNG.

Il risultato mantiene le regioni definite dal fill nativo, evitando di riempire da capo contorni che potrebbero essere aperti nella nuova geometria. Le celle di colore Spectrum restano volutamente a blocchi: la rettifica riguarda le linee e i bordi geometrici. Ai piccoli incroci possono esserci differenze dalla forma dei singoli pixel originali. L'SVG contiene geometria continua e il visualizzatore applica l'antialiasing; non contiene una bitmap ingrandita.

La galleria mostra ora **originale e linee rette**. I link permettono anche di consultare la versione `smooth` corretta.

`verify_rendering.py` verifica contorni coincidenti, buchi e bordi condivisi, la continuità di una diagonale isolata, il ritorno ai pixel originali dei contorni non semplificati e gli hash dei 14 schermi fedeli. Con `--reference-dir` confronta anche i PNG con una rasterizzazione indipendente dei rispettivi SVG. Il supporto opzionale `render_svg_reference.cjs` produce i PNG di riferimento dagli SVG usando Node e Sharp; il modulo può essere indicato con `SHERLOCK_SHARP_MODULE`. Non è una dipendenza del programma Python. Il rapporto `rendering-verification.json` include il confronto di 28 immagini con librsvg, tramite Sharp: sono ammesse differenze di antialias vicino ai bordi; non ci sono differenze significative lontano dai bordi.

## Verifiche riproducibili

```sh
python3 -B sherlock-analisi/grafica/verify_graphics.py
python3 -B sherlock-analisi/grafica/verify_rendering.py
python3 -B sherlock-analisi/grafica/build_graphics_dossier.py
```

- **14/14 immagini identiche allo Z80**, su schermo iniziale vuoto con attributi `$38`.
- Confronto dell'intera memoria video: **6.144 byte bitmap + 768 attributi** per immagine, non soltanto del ritaglio.
- Confronto anche dopo **913 comandi intermedi**, tutti identici: segmenti, fill e cammini di attributi.
- Vengono eseguiti `$F3C2` e ROM `$22AA` originali, senza sostituire plot/fill o altre routine con stub.
- Ogni istruzione del listing è ri-assemblata e confrontata con il TAP.
- I contorni **prima della semplificazione** vengono rasterizzati e ricampionati sui centri dei pixel: coincidono con il bitmap nativo per tutte le 14 locazioni.

Queste verifiche coprono tutti gli stream referenziati dalla tabella del gioco. Non costituiscono un test esaustivo di tutti i possibili opcode, degli stream arbitrari o di qualunque stato iniziale dello schermo. La modalità `smooth` è volutamente diversa dal raster originale e non è dichiarata pixel-identica.

Rapporti: `verification.json`, `listing-verification.json`, `contour-verification.json`. Le immagini `.scr` contengono i 6.912 byte di schermo prodotti dal motore Python nelle condizioni di verifica.

## File principali

- `sherlock_graphics.py`: decoder, traduzione nativa, esportazione PNG/SVG e CLI.
- `graphics.asm`: listing Z80 commentato con indirizzi e byte.
- `instructions.txt`: istruzioni dei disegni decodificate, da leggere accanto al listing.
- `verify_graphics.py`: confronto indipendente con lo Z80 tramite SkoolKit.
- `build_graphics_dossier.py`: rigenerazione listing, galleria, schermate `.scr` e controllo dei contorni.
- `immagini/index.html`: galleria comparativa, utilizzabile offline.
- `immagini/confronto.png`: tavola di confronto del riquadro superiore.
