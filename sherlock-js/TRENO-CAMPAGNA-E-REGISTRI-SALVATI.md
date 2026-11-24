# Treno in corsa: font e descrittore salvati dalla prosa

24 novembre 2026.

Superati **$5D23 e $5D29**, i due operandi della stessa estrazione nella
variante con LOOK prima del primo HAIL CAB. Coincidono ora **3.281
checkpoint**, fino a **mercoledì alle 19:39**: 41 checkpoint oltre il
traguardo precedente. Il prossimo escluso è il checkpoint 3281,
comando SW che terminerebbe alle **19:41**, su **$CB29**.

## Il chiamante di English

Durante WAIT UNTIL 7:29PM, il treno parte al tick **3504**. Holmes
rimane al suo interno e vede la descrizione della campagna, frammento
**$7E45**:

> You are riding in a steam train through the picturesque English countryside.

D171 passa la descrizione a D182; D184 entra nel decoder A59F quando
il puntatore è diverso da zero. Nel percorso misurato **A59F ha
SP=$5D5A**. Il riferimento alla parola successiva scarica English
ancora in buffer, con glifi a **frame $5D2E**. L’ultima lettera è h.
Il CR esterno usa invece A9B7/SP=$5D58.

Il modello aveva già ricostruito lo scarico di English e alcuni suoi
registri salvati. Mancavano due proprietà distinte:

* **$5D23 è A della scansione del font.** PUSH AF a C3B8 conserva il
  byte dell’ottava riga del glifo prima delle rotazioni. Con frame $5D2E,
  A occupa frame−11, cioè $5D23. L’ultima riga della h vale zero; la
  formula legge il font effettivo e non assegna uno zero al generatore.
* **$5D29 è D del descrittore del glifo.** PUSH DE a C38A salva D in
  frame−5. Durante lo scarico della parola DE punta al buffer $5C0B;
  il byte alto è quindi $5C. Questo parametro non è A del font e non
  si ricava da $5D23. Il separatore successivo usa invece il riferimento
  al tronco countr; il suffisso letterale ryside non seleziona un altro
  riferimento del dizionario.

La traccia naturale segue anche le riscritture dello stesso valore.
Il giardiniere, attore 8, legge **0 e 92** al tick **3535**, nella stessa
estrazione che termina alle **18:55**. I due scrittori sono entrambi
al tick 3504, attore 0, ma sono istruzioni e registri differenti.

## Perimetro del motore autonomo

La nuova proprietà usa il chiamante già tracciato per la prosa del
treno: frame $5D2E, ruolo English del frammento $7E45 nell’arrivo
alla stanza mobile, giocatore 0. Richiede grafica nativa, finestra larga,
colonna inferiore a 35 e margine prima del MORE (`counter + 2 < 15`).
Il valore A viene dall’algoritmo di scansione del font; D dal parametro
DE effettivamente passato al glifo. Il browser non esegue la CPU originale
né sceglie risposte da una registrazione.

Identità alternative, finestre strette, margine, altri frame e chiamanti
non ereditano queste due proprietà. I limiti sui contatori sono guardie
conservative della ricostruzione, non vincoli aggiunti al gioco originale.
I byte vicini mantengono i loro contratti separati.

Salva/Carica conserva i due valori indipendentemente, compreso lo zero
conosciuto di A. Nei vecchi file un campo assente rimane sconosciuto:
una stampa che lo conserva non ne inventa il contenuto. Il test del WAIT
interrompe esplicitamente l’attesa prima di salvare, come richiede
l’adattatore; non salva una visita ancora incompleta del ciclo.

## Evidenza e regressioni

La cattura riparte dal checkpoint originale **3203**, prima del WAIT,
verificando clock, stanza, bitmap, attributi, finestra e contatore.
Il percorso è naturale, con tutti i 24 programmi degli attori attivi,
nessun teletrasporto e nessuna modifica delle loro posizioni.
Registra i chiamanti e i glifi al tick 3504; distingue i valori subito
dopo la prosa da quelli alla fine dell’intero WAIT UNTIL.

* **162 frammenti completi più CR controllati:** A59F/HL=$7E45 nel
  frame misurato, tutte le 36 o 18 colonne delle due finestre, contatori
  0, 5 e 11, buffer vuoto, flag espliciti e marker A5 in 23/29. Il CR
  mantiene il suo frame distinto. Ritorno sintetico 0008, nessun tick:
  non sono 162 partite naturali. Si confrontano soltanto i campi posseduti;
  i pacchetti delle parole originali sono archiviati senza modifiche.
* **216 glifi controllati:** h, q e T, 36 colonne e due descrittori DE.
  La q ha una riga finale non nulla; il descrittore alternativo ha un
  byte alto diverso da $5C. I test distinguono quindi i due algoritmi
  da costanti che funzionerebbero soltanto nella storia osservata.
* **WAIT reale e salvataggio:** da uno stato generato dal solo JavaScript,
  l’attesa raggiunge la partenza del treno; dopo l’interruzione si salva
  e si caricano entrambi i valori, anche quando uno manca in un vecchio file.

Il confronto dall’avvio mantiene seed 1, tutti i 24 attori, grafica
nativa, LOOK iniziale gratuito, input maiuscoli iniettati e MORE immediato.
Verifica **8.620 estrazioni e 18.314 letture**, bitmap e attributi superiori
a ogni estrazione, ingressi e risultati casuali, clock, locazione, modo
della finestra, contatore, esiti e finale. Il confronto non è normalizzato.

I sette punti Salva/Carica sono **1488, 2005, 2780, 2911, 3015, 3112 e
3203**. Dopo l’ultimo seguono **77 checkpoint** di futuro, compresa la
produzione dei due valori e la loro lettura da parte del giardiniere.
L’ultimo salvataggio è prima del WAIT; il salvataggio dopo la partenza
è invece la distinta prova con interruzione esplicita descritta sopra.
I tre percorsi di vittoria con seed 0, 1 e 137 restano verifiche separate,
ciascuna di 3.219 checkpoint. Questo avanzamento non certifica un nuovo
finale né tutta la variante fino al termine.

## Prossimo limite: un risultato temporaneo della regola

Il prossimo indirizzo è **$CB29**. Fa parte dei quattro byte **CB28–CB2B**
che conservano IX e IY fra predicato e corpo delle regole: sono dati
mutabili, anche se si trovano fra routine. Gli zeri nel TAP sono soltanto
il contenuto iniziale e non possono essere usati come fallback.

Al tick **3581**, durante SW, **CB37** salva IX=$9997 dopo il callback
**$E5AA**, eseguito dall’attore **104**, con ritorno $CA67 e IY=$DDBE.
Il giardiniere legge poi il byte alto **$99**. La traccia osserva 2.844
salvataggi, comprese riscritture invariate, senza transizioni non
classificate. Il modello conosce già la struttura generale di questi
risultati; manca il contratto specifico del ritorno da quel callback.
Non viene sostituito con il valore catturato.

L’attribuzione registra sia l’ingresso CB2C sia quello diretto CB34 e
abbina il ritorno tramite SP. Un solo ritorno iniziale appartiene a una
chiamata già sospesa nel prompt di partenza; il risultato finale di E5AA
ha la propria entrata osservata.

## Atlante

Approfonditi **$A9DF–AA0F**, **$C388–C3E3**, **$D16B–D186**,
**$CB28–CB2B** come dati e **$CB2C–CB40** come codice, oltre al workspace
dinamico $5D23/$5D29. Il listato contiene **119 istruzioni e 194 byte**,
compresi quattro byte di dati tipizzati, riassemblati e confrontati con
il TAP. La copertura rimane 40.029 byte documentati, 305 parziali e
1.266 sconosciuti: nessun nuovo grigio classificato.

[Partenza e chiamanti](results/train-countryside-font/departure-detail.json) ·
[Due scrittori della stessa estrazione](results/train-countryside-font/paired-writers.json) ·
[162 frammenti](results/train-countryside-font/prose-abi.json) ·
[216 glifi](results/train-countryside-font/glyph-abi.json) ·
[Listato tipizzato](results/train-countryside-font/train-countryside-font.asm) ·
[Prossimo risultato della regola](results/train-countryside-font/next-rule-result.json) ·
[Rapporto e test](results/train-countryside-font/verification.json).


Verifica conclusiva: **62 test mirati distinti** passati, oltre al
confronto della variante dall’avvio e ai tre percorsi completi fino alla
vittoria con seed 0, 1 e 137. I sei test del nuovo produttore sono stati
ripetuti dopo il completamento dell’attribuzione del callback.
[Output dei test](results/train-countryside-font/test-output.txt).
