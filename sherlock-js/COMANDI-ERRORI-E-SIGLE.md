# Comandi, recupero dagli errori e sigle

25 ottobre 2026. Motore autonomo JavaScript, profilo `world-v5`.

## SAY CABBIE è accettato dall'originale

La forma senza TO seleziona la stessa azione di `SAY TO CABBIE`: se il
personaggio è presente, compare `You talk to the cabbie.` e passa un minuto.
Anche `SAY CABBIE "HELLO"` è riconosciuto. La risposta viene decisa dal normale
programma del personaggio e dal generatore condiviso, senza una risposta fissa.

Se il destinatario non è presente, l'originale risponde
`I SEE NO CABBIE THAT YOU CAN TALK TO`, senza avanzare il tempo. La risoluzione
del destinatario precede il controllo della citazione: l'ordine dei controlli
è significativo.

Una citazione con sintassi errata, rivolta a un destinatario presente, ha un
altro comportamento: l'azione TALK avviene, costa un minuto, ma l'ordine interno
viene scartato. Non viene sostituito con una risposta inventata.

## Perché gli errori potevano bloccare i comandi successivi

Il parser originale scrive record temporanei anche prima di scoprire un errore.
La ricostruzione invalidava la loro rappresentazione; un successivo turno NPC
poteva leggere quei dati attraverso il generatore casuale e incontrare una
sorgente dichiarata sconosciuta. Ripetere comandi validi non riparava lo stato.

Ora gli errori ricostruiti liberano le liste nello stesso ordine dell'originale
(AAB2, D7B3/D7B6), conservando anche i byte dei record liberati. Le citazioni
hanno una lista propria: B049–B097 conserva il puntatore ai token; B86A–B8D1 lo
consuma dopo la risoluzione del destinatario. Il token di chiusura passa da C0
a 90. Se il destinatario manca, il record resta nella lista come nell'originale.
La gestione completa di una successiva citazione con una vecchia citazione
ancora accodata resta un percorso esplicitamente non ricostruito.

Sono stati corretti anche i token a due byte, memorizzati dal lexer nell'ordine
alto/basso, e l'output degli errori nel canale inferiore: scrittura a caratteri,
36 colonne, scorrimento e domanda WHICH senza ritorno a capo prima del prompt.
Un errore lessicale non esegue il reset del formatter riservato al preflight
riuscito (D719/C142). La sola rappresentazione testuale non sarebbe sufficiente
a preservare le successive letture casuali.

## Cosa succede a un comando ancora non implementato

Questa è una protezione del prototipo, distinta dal comportamento originale:
l'intera riga viene annullata e mondo, tempo, record, generatore, continuazione
e dipendenze dello schermo tornano allo stato precedente all'invio. Vale anche
se una prima azione della riga aveva già prodotto effetti, come in
`WAIT. KILL WATSON`. Non vengono mantenuti messaggi o fotogrammi intermedi.

L'avviso del prototipo indica che si può inserire un altro comando. Il tentativo
resta nella cronologia diagnostica, che non alimenta la logica di gioco.
Gli errori originali ricostruiti, invece, seguono il loro normale percorso.
Non si saltano turni NPC e non si inventano dati mancanti per far avanzare il
tempo. Un salvataggio storico già privo di dipendenze non viene riparato
retroattivamente da questa modifica.

## Sigle nella mappa e nell'elenco personaggi

La presentazione usa SH, IL, W, CS, DS, BP, PF, G, CK, MD, P1, P2, TF, C1,
C2, MB, MJ e GA. In particolare: Basil Phipps BP, cuoca CK, cameriera MD,
Tricia Fender TF, Mrs Brown MB, Mrs Jones MJ e poliziotti P1/P2.
La stessa funzione alimenta mappa ed elenco; le sigle non modificano AI,
salvataggi o generatore casuale.

## Prove e limiti

`test/error-recovery.test.mjs` confronta 73 comandi con l'eseguibile originale,
seed 1 e tutti i 24 slot attori attivi: 186 estrazioni e 378 letture sorgente.
Sono confrontati ogni argomento/risultato/successore casuale, orologio,
programma/argomenti/scadenza degli attori, 110 entità, 106 flag delle locazioni,
tutti i 752 byte dell'arena, liste, buffer editor/token e bitmap esatte delle
aree superiore e inferiore, oltre ai campi di lavoro posseduti dal modello.
Nessuna normalizzazione dei bitmap nasconde differenze.

Il profilo usa LOOK iniziale gratuito, grafica disattivata dopo il primo prompt,
input maiuscolo iniettato, MORE immediato e nessun timeout di inattività.
Il primo fixture conserva 22 osservazioni native: il certificato si ferma alle
prime 20; le ultime due comprendono EXCEPT, ancora non ricostruito. Il secondo
copre 53 comandi, inclusi errori durante chiarimenti e 40 ulteriori INVENTORY.
Un ramo save/load verifica altri 40 INVENTORY con risposte e stato completo
identici. Gli annullamenti vengono verificati separatamente come protezione
del prototipo, senza attribuirli al gioco originale.

Il rapporto è `results/error-recovery-verification.json`. La suite generale
include le precedenti prove di Watson, cab, treno e interviste di Lestrade.
Queste prove non certificano equivalenza dell'intero gioco né di tutti i seed.

Il server statico sulla porta 8768 serve già i file aggiornati; basta ricaricare
la pagina. Non è stato riavviato e la partita aperta dell'utente non è stata
modificata. L'ultima lettura dei risultati della prova nel browser non è stata
eseguita: la revisione automatica ha segnalato l'esaurimento dell'allowance.
La verifica browser resta quindi non confermata; i risultati locali sono
documentati separatamente.
