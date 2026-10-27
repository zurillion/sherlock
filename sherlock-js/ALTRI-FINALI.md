# Altri finali: cassaforte e premesse delle deduzioni

27 ottobre 2026. Motore JavaScript autonomo `world-v5`.

Questo passaggio aggiunge due storie naturali confrontate con l'originale,
126 comandi, 870 estrazioni casuali e 1.840 letture dei loro ingressi.
Entrambe raggiungono il testo terminale **759C**, oltre ai due testi di
sconfitta già certificati in [FINALI-NATURALI.md](FINALI-NATURALI.md).
Non sono due finali diversi: il secondo percorso ha rivelato una differenza
negli ordini a Basil che è stata corretta, anziché accettarla come soluzione.

## Cassaforte: il finale immediato

Dopo il viaggio reale e la presentazione a Straker, Holmes raggiunge Cobden
Lane, entra nella casa, apre la porta del salotto e va a sud nella biblioteca.
`OPEN WALL SAFE` di lunedì stampa l'apertura e chiama DFB8/DFCC: Basil uccide
Holmes immediatamente. Non si applicano i quindici minuti del ritorno ordinario
della regola e non vengono eseguiti altri turni o callback dopo il finale.

Il testo 759C è scelto perché Basil non è nella stessa stanza. La condizione
DFCC conserva la variante 75D2 quando invece è già presente; questa seconda
condizione è tuttora verificata con setup controllati, non con una storia
naturale completa.

La storia riproducibile è
[results/other-endings/safe-absent-inputs.txt](results/other-endings/safe-absent-inputs.txt).
Termina lunedì alle **10:46am**. Non contiene teletrasporti o modifiche dei
programmi, delle prove o delle posizioni.

## Basil non può essere spostato liberamente

Durante l'attesa EE2B del segnale di Straker, il bit di restrizione è attivo.
Il prototipo rispettava il rifiuto per FOLLOW e altre azioni ma ometteva il
controllo per i normali movimenti. Nell'originale DCD2 trova prima l'uscita;
DCDD chiama poi CBA7, che stampa `Sorry, I cannot do that now.` e restituisce
fallimento. Se l'uscita non esiste, non si raggiunge quel controllo.

Ora anche gli ordini direzionali e gli ingressi risolti attraversano quel
controllo, prima di cambiare stanza. Il rifiuto elimina il resto della richiesta
con il percorso originale di avanzamento e rilascio dei nodi. Non viene
spostato Basil artificialmente per ottenere il testo 75D2.

La seconda storia
[results/other-endings/restricted-basil-inputs.txt](results/other-endings/restricted-basil-inputs.txt)
visita Basil e gli ordina un percorso verso la biblioteca. Basil rifiuta e
resta al suo posto; Holmes arriva da solo e il finale è ancora 759C, alle
**11:09am**. Il rifiuto scrive anche frame temporanei non completamente
ricostruiti: da 5D06 vengono revocati i campi precedentemente posseduti, senza
inserire valori osservati come sostituti. Nessuna estrazione dei due percorsi
certificati richiede quei campi ancora sconosciuti.

## Correzione necessaria per i finali dell'indagine

Le prove non sono una lista piatta di sole conclusioni principali. La ricerca
BD51 usa BE5A e può trovare un'affermazione annidata dentro un altro albero.
BC46 valuta gli atomi attivi in ordine inverso; BC9C passa alle conclusioni
complete con BE72, saltando interi gruppi; BC74 torna invece a BE5A per le
premesse ancora incomplete. Il motore ora conserva queste tre scansioni
separate, comprese le loro mutazioni dei flag.

Per esempio, `MAJOR FFOULKES VISIT OPIUM DEN` è una premessa interna di
`MAJOR FFOULKES IS INNOCENT`. Prima poteva non essere trovata. Due nuovi test
nativi spostano esplicitamente Lestrade da Holmes e preparano o meno **solo**
il flag di osservazione F103 a 9972. Dopo le due affermazioni:

- senza osservazione Lestrade continua a chiedere la prova mancante;
- con osservazione accetta la deduzione e attiva la prontezza del caso a 9E88.

Sono prove controllate, dichiarate nel fixture: non dimostrano ancora che
Holmes abbia osservato naturalmente la visita del maggiore. Il riconoscimento
di Watson consulta a sua volta tutti gli atomi, come la ricerca originale.

## Stato e renderer: altre differenze corrette

Aprire una porta già aperta non costa tempo, ma conserva nel contesto del
giocatore l'azione OPEN e l'oggetto risolto. Prima restavano gli argomenti del
movimento precedente. Il percorso della cassaforte confronta anche questo
rifiuto, che non è trascurabile per le letture casuali successive.

La parola SEE della lista degli oggetti viene svuotata dal chiamante del nome
seguente: un nome personale letterale e un nome di dizionario con articolo
hanno due profondità diverse. L'osservazione offline di C388 e il codice di
D3E8/D438 confermano la distinzione. Sono stati corretti i frame corrispondenti,
non installati i byte di un'immagine nativa.

La tabella globale delle azioni 9F38–9FAA e il programma DOMAIN del giocatore
9921–994C sono ora esportati come dati immutabili, con verifica degli ID e dei
puntatori già documentati. Non vengono disassemblati né eseguiti come Z80
nel motore JavaScript.

## Cosa è certificato e cosa rimane

Il confronto comprende tutti i 24 attori, ogni estrazione casuale e i suoi
ingressi, scadenze e argomenti, entità, prove, tutti i 752 byte dell'arena,
buffer del parser, bitmap superiore/inferiore e campi temporanei posseduti.
Verifica inoltre i pacchetti realmente usati dalla pagina, il testo visibile
**prima** del tasto finale, il futuro dopo Salva/Carica e il congelamento dopo
la fine partita.

I nove selettori terminali hanno già prove controllate in
[CONCLUSIONE-INDAGINE.md](CONCLUSIONE-INDAGINE.md). Le storie naturali ora
certificano tre testi distinti: 693A, 6A26 e 759C. Rimangono da certificare
naturalmente **69BF, 6A33, 6ABD, 6AF3, 6B79 e 75D2**, inclusa una soluzione
completa con acquisizione reale degli indizi. In particolare la correzione
delle premesse rende utilizzabile il passaggio che evita l'arresto erroneo,
ma non certifica automaticamente tutti i successivi rami della soluzione.

Dati e strumenti:

- [results/other-endings-verification.json](results/other-endings-verification.json)
- `tools/probe-other-endings.py`: oracle offline delle storie naturali;
- `tools/probe-internal-premises.py`: setup controllati delle premesse;
- `tools/build-other-ending-listing.py`: listato misto e riassemblaggio;
- `test/other-endings.test.mjs` e `test/internal-premises.test.mjs`.

Il nuovo listato distingue dati e codice e riassembla esattamente 611 byte,
194 istruzioni. Il protocollo resta seed 1, descrizione iniziale gratuita,
grafica nativa disabilitata dopo l'avvio, input iniettato e MORE immediato:
non è una dichiarazione di equivalenza per qualsiasi seed e temporizzazione.
