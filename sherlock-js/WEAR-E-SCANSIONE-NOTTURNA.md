# WEAR: F e A della scansione letti durante la notte

20 novembre 2026.

Aggiornamento successivo: superati anche $5D1A e $5D20; il prefisso
coincide fino alle 08:49 su 2.664 checkpoint.
[Nuovi contratti e prossimo limite](SCANSIONI-LOOK-WEAR.md).

Questa fase ha verificato la variante con LOOK prima del primo HAIL CAB
per **2.464 checkpoint**, fino a **mercoledì alle 05:29**. Sono superate
le letture di $5D1E e $5D1F della cuoca. Il checkpoint allora escluso
era alle **05:30**: il giardiniere legge $5D1A e poi $5D20 nella stessa
estrazione. Il modello segnala il primo campo ancora sconosciuto.

Il profilo resta seed 1, tutti i 24 attori, grafica nativa dall’avvio,
LOOK iniziale gratuito e nessun teletrasporto. Coincidono le **6.375
estrazioni e 13.484 letture**, bitmap e attributi superiori anche al momento
di ciascuna estrazione, contatore MORE, finestra, orologio, stanza,
stato del comando e finale. È un prefisso verificato, non equivalenza
per tutti gli input o per l’intera storia.

## Lo scrittore originale

Martedì alle 22:06, `WEAR CHINA MANS DISGUISE` stampa:

~~~text
You wear the china mans disguise.
~~~

Il normale annuncio entra in $CA76 con SP=$5D6C. $A3A2 lascia «wear»
nel buffer; l’inizio del nome dell’argomento attraverso $A3DE, $A745/$A751
 e $D3E8 scarica la parola. I glifi del verbo entrano in $C388 con
frame **$5D2A**. L’ultima lettera, «r», è alla colonna 7 e ha shift 3.

Al tick **2286**, $C3B8 salva AF dell’ottava scansione:

| Byte | Significato nel frame $5D2A | Valore osservato |
| --- | --- | ---: |
| $5D1E | F della scansione, dopo il ripristino del conteggio di shift | 0 |
| $5D1F | A, ottava riga del font prima della rotazione per disegnare | 0 |

Il secondo zero proviene dalla riga del font della «r». Altri caratteri,
come «q», possono lasciare un byte diverso. I due valori sono calcolati
dal renderer, non copiati dal corpus. Il motore riusa l’algoritmo delle
scansioni già confrontato con il renderer originale.

L’articolo e i qualificatori dell’oggetto usano frame $5D2C; il sostantivo
finale «disguise.» usa $5D46. Nella geometria verificata non sovrascrivono
$5D1E–$5D1F. Il contratto runtime è limitato al normale annuncio WEAR del
giocatore, finestra larga, riga nuova, buffer vuoto, nome ricostruibile
dal dizionario, frase inferiore a 36 caratteri e margine prima del MORE.
Richieste isolate, altre geometrie e altri chiamanti restano sconosciuti.

La cuoca legge $5D1E al tick **2484**, nel minuto che termina alle **01:24**,
e $5D1F al tick **2608**, nel minuto che termina alle **03:28**. Entrambe
le letture conservano come ultimo scrittore quel PUSH AF di WEAR.
Il probe osserva PUSH/CALL e EX (SP),HL, comprese le riscritture dello
stesso valore. Non risultano transizioni di valore non classificate nei
due byte osservati. Il checkpoint di ricerca precedente a WEAR è
confrontato con il corpus per orologio, stanza, bitmap, contatore e modalità.

## I rifiuti successivi

La storia contiene diversi comandi senza esito, fra cui `OPEN LARGE OAK
DOOR` e `TAKE RIPPED NOTE`: Holmes è ancora a Portman Street. Il modello
stampava già l’errore corretto, ma rendeva sconosciuti i residui precedenti.

$B6FD cerca nel testo della locazione. Il puntatore zero letto da IX+7/8
provoca il ritorno in $B70F prima di entrare nel decoder. Il ramo
$B69D–$B6AD prepara gli argomenti vuoti e stampa il frammento $6894 nel
canale inferiore. Questo percorso lascia intatti i due byte della scansione.

La conservazione è ora esplicita per i rifiuti di un singolo oggetto
assente con al massimo due qualificatori, nei normali OPEN, CLOSE,
EXAMINE/CLOSELY EXAMINE e TAKE/GET/CARRY. Il giocatore deve essere alla
radice, vedere, e trovarsi in una stanza senza testo descrittivo.
Citazioni, ordini NPC, ALL e ricerche nel testo non ereditano il contratto.
La proprietà degli altri byte resta separata: non vengono conservati
indiscriminatamente tutti i residui dello stack.

## Prove controllate e Salva/Carica

- **1.080 casi del formatter WEAR:** entrambi i travestimenti, 36 colonne,
  15 valori del contatore, nello snapshot d’ingresso originale. Il runtime
  possiede solo il sottoinsieme prudente di 24 geometrie su riga nuova.
- **147 rifiuti completi originali:** tre identità giocabili, sette forme
  verbali e sette gruppi nominali assenti con zero, uno o due qualificatori.
  Marker A5 in $5D1E–$5D1F, anche nella copia dello stack dell’editor;
  tutti conservati. Identità e budget dei fallimenti sono controllati:
  questi casi non sono presentati come storie naturali.
- **ABI del glifo riutilizzata:** variazione di carattere, colonna e conteggio
  del chiamante; include residui del font non nulli.
- **Storia naturale:** rigiocata dall’accensione con Salva/Carica JSON nuovo
  ai checkpoint 1488 e 2005. L’ultimo è immediatamente dopo WEAR; le
  successive **458** risposte e gli stati completi delle sessioni coincidono,
  oltre al confronto con l’originale. Un vecchio save senza i byte resta
  privo dei byte attraverso i rifiuti: solo un nuovo writer li ricrea.

[Rapporto del percorso](results/victory-route/native-extra-look-verification.json) ·
[Writer e due letture](results/extra-look-wear-scan/natural-writers.json) ·
[Frame dell’annuncio](results/extra-look-wear-scan/wear-announcement.json) ·
[ABI WEAR](results/extra-look-wear-scan/wear-abi.json) ·
[ABI rifiuti](results/extra-look-wear-scan/rejection-abi.json) ·
[Disassemblato commentato](results/extra-look-wear-scan/wear-scan.asm).

Per ripetere le verifiche da `sherlock-js`:

~~~sh
node --test test/extra-look-wear-scan.test.mjs
node --test --test-name-pattern='An extra LOOK' test/native-picture-window.test.mjs
python3 tools/probe-extra-look-wear-abi.py
python3 tools/probe-extra-look-rejection-abi.py
python3 tools/probe-extra-look-wear-writer.py
python3 tools/build-extra-look-wear-listing.py
python3 tools/build-memory-map.py
~~~

Il probe naturale può ricevere come primo argomento un checkpoint di
ricerca opzionale. Senza argomenti riparte dall’originale dall’avvio;
il suo tempo di esecuzione è maggiore. Corpus e snapshot sono usati
solo offline: la pagina non li importa.

## Mappa aggiornata

Approfonditi **$A2E4–$A35C**, **$A37D–$A3E1**, **$B69D–$B6AD**,
**$B6FD–$B70F** e **$C388–$C3E3**. Il workspace opzionale espone il ruolo
indipendente dei byte **$5D1E–$5D1F** nell’annuncio WEAR.

Il nuovo estratto contiene **193 istruzioni, 350 byte**, verificati contro
il payload e riassemblati. Le classificazioni dei byte non cambiano:
**40.029 documentati, 305 parziali, 1.266 sconosciuti**. Si approfondisce
un chiamante di routine già censite; questo non equivale a colorare nuovo
codice grigio né a dichiarare completa la sua equivalenza funzionale.
