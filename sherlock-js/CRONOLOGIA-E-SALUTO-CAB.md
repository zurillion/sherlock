# Cronologia e saluto al cocchiere

25 ottobre 2026. Il blocco riportato con seed 1 è il controllo del prototipo «metadati dei contesti dopo questo percorso del parser», non una risposta del gioco.

## Causa e ricostruzione

Il caso riprodotto saluta Watson, attende la lettura del giornale, gli chiede FOLLOW ME, apre la porta con `OPEN DOOR` → `ALL`, esce a piedi, chiama il cab e dice `SAY "HELLO" TO CABBIE`. Il medesimo percorso con `YOUR` non produceva questo blocco. Anche `OPEN ALL DOORS` riproduceva il difetto.

Il saluto era riconosciuto e accodato. Il problema nasceva prima: il modello eseguiva le azioni di ALL separatamente ma liberava subito il nodo sintattico, marcando quindi l'area condivisa dei record come non ricostruita. Quando Watson concludeva un contesto del FOLLOW durante la richiesta al cabbie, il controllo conservativo incontrava metadati non affidabili e annullava quel turno.

Nel codice originale `D835–D858` il nodo corrente rimane sulla lista `$9FF2` durante le iterazioni di ALL. Il caso nativo mostra due azioni OPEN ai tick 18 e 19, con lo stesso nodo di 30 byte ancora allocato, seguite al tick 20 dall'ultima ricerca senza altri oggetti. `D86A` torna a `D835`, e soltanto allora `D83B–D848` scollega e libera il nodo. I turni NPC fra le due aperture devono quindi vedere quell'allocazione ancora occupata. Nel chiarimento, `AD6C` fonde ALL nel nodo pendente e libera soltanto il nodo temporaneo della risposta.

La riscrittura riproduce questa durata mediante la lista logica `parsed`, mantenendo la ricerca dinamica degli oggetti fra un turno e l'altro. Il generatore dei saluti rimane l'algoritmo condiviso originale. Non sono state aggiunte risposte speciali per il cabbie né rimosso il controllo sui contesti sconosciuti. Le esclusioni, ALL sul secondo argomento e i percorsi multipli ancora non ricostruiti mantengono i limiti espliciti.

Il controllo con YOUR ha inoltre evidenziato il contenuto dei piccoli nodi delle citazioni: `B049–B06D` alloca due byte e conserva il puntatore ai token del contenuto. Ora questo puntatore è calcolato dalla posizione e dalle dimensioni dei token del comando, invece di lasciare zero. Anche un byte liberato può essere osservabile dal generatore casuale in seguito.

## Prove con l'originale

`tools/probe-cabbie-hello.py` genera un oracolo offline in `test/fixtures/cabbie-hello-reference.json`. Le quattro sequenze coprono ALL dopo chiarimento (seed 1 e 42), ALL direttamente nel comando (seed 1) e YOUR come controllo (seed 1). Proseguono con due saluti al cocchiere, ingresso nel cab con Watson, richiesta per Kings Cross Road, attesa dell'arrivo, discesa e pagamento con resto.

Sono **87 comandi, 575 estrazioni casuali, 1.266 letture**, con tutti i 24 attori attivi. Avvio gratuito alle 08:00; grafica nativa disabilitata dopo il primo prompt, tasti iniettati in maiuscolo, MORE immediato, nessun timeout della tastiera né teletrasporto. Le osservazioni non vengono caricate dal motore durante il gioco.

Ogni comando confronta tutti gli ingressi e i risultati delle estrazioni, orologio, programmi/argomenti/scadenze dei 24 attori, 110 entità, 106 flag di stanze, liste e puntatori, testa libera, **tutti i 752 byte dei record** e hash esatto della bitmap superiore. Si confrontano anche i messaggi del canale di errore e le righe prodotte dai pacchetti della sessione web. La prova salva e carica sia durante WHICH DOOR sia dopo ALL e confronta il seguito fino al resto del pagamento. Questo certifica le sequenze dichiarate, non ogni partita possibile.

## Cronologia nella pagina

Sulla porta **8768**, il pulsante **Cronologia** apre una finestra con **Copia cronologia**. Registra l'input esatto, compresi errori e risposte di chiarimento, seed iniziale, modalità di avvio, teletrasporti, interruzioni di WAIT UNTIL e avvisi del prototipo. Gli esiti sono annotazioni, separate dalle risposte originali del gioco. Nessun limite di 200 comandi viene applicato al registro; la breve navigazione con le frecce resta separata.

Il registro è metadato diagnostico esterno al mondo, non entra nelle letture casuali né aggiunge turni. È incluso in Salva/Carica e nei checkpoint della scheda; Riavvia comincia un nuovo registro. Aprire o copiare la finestra non consuma un MORE né interrompe WAIT UNTIL. Se il browser impedisce la copia, il testo viene selezionato per ⌘C/Ctrl+C.

Le vecchie partite senza registro restano caricabili: il testo della breve history recuperabile dalla scheda viene importato con un avviso di cronologia parziale. Non è possibile ricostruire comandi o teletrasporti già perduti. I precedenti stati con metadati del parser sconosciuti mantengono quella limitazione; per provare la correzione completa serve una nuova partita dopo il ricaricamento della pagina.

Le prove della cronologia includono oltre 200 input, salvataggio dopo errore, caricamento, ricaricamento della scheda e interruzione dell'attesa. È stato corretto anche il checksum dei salvataggi: ora viene calcolato sulla rappresentazione JSON effettivamente scritta nel file, evitando un LOAD rifiutato dopo errori che lasciavano campi opzionali undefined nell'analisi.

```sh
node --test test/cabbie-hello.test.mjs test/command-history.test.mjs
node --test test/*.test.mjs
```

Rapporto verifiche: `results/cabbie-history-verification.json`. La prova nella pagina usa una sessione di browser separata; la partita aperta dall'utente e il server non vengono azzerati.
