# LOOK: il descrittore del sostantivo successivo

22 novembre 2026.

La variante con LOOK prima del primo HAIL CAB supera ora il limite
**$5D21** e coincide per **3.148 checkpoint**, fino a **mercoledì alle
17:27**. Sono 98 checkpoint in più rispetto al traguardo precedente.
Il prossimo checkpoint escluso è il 3148, alle **17:28**, su **$5D22**.

## Quale algoritmo scrive il byte

Durante il LOOK che termina alle 15:15, Watson è nella main street e
porta il daily chronicle. Il formatter D3E8 seleziona il riferimento del
sostantivo con A815 e A887, prima di emettere lo spazio che lo precede.
Quello spazio scarica la parola daily ancora nel buffer; il suo DE indica
però già chronicle, **$51AB**, cioè contesto 5 e offset $1AB.

Il glifo spazio entra in C388 con **SP=$5D26**, al tick 3315.
**PUSH DE a $C38A** salva E in frame−6 e D in frame−5: D rimane quindi
in **$5D21**. Watson legge questo byte al tick 3350, nella continuazione
WAIT UNTIL 4:45PM che termina alle 15:50.

Il modello deriva D dal riferimento dell’entità, `5000 | noun`, e lo
salva soltanto nel chiamante verificato. Non assegna 51 al generatore,
non consulta un elenco di risposte e non esegue codice Z80 nel browser.
L’AF lasciato dalla precedente uscita dal treno è un produttore diverso:
lo stesso indirizzo non ha un solo significato permanente.

## Perché il sostantivo finale non deve cancellarlo

Il qualificatore daily usa frame $5D1A; il suo separatore usa $5D26.
Il sostantivo finale chronicle. resta in buffer fino al CR del chiamante.
Il suo scarico usa invece **5D4C**, e il wrap **5D46**. Entrambi sono
più superficiali e non raggiungono $5D21. Il modello prima rendeva quel
byte sconosciuto per il solo fatto che la parola finale andava a capo.

La nuova conservazione attraversa il CR soltanto quando D è già noto;
non ricrea campi assenti da vecchi salvataggi. Il byte $5D20 mantiene il
proprio contratto indipendente e non riceve nuova proprietà.

Il perimetro è LOOK ordinario, ultimo oggetto comune portato da una
persona al livello ricorsivo misurato, nome grezzo verificato, senza
formattazione numerica del denaro. Al separatore servono grafica nativa,
finestra larga, colonna inferiore a 35 e margine prima del MORE
(`counter + 3 < 15`). Il sostantivo finale deve essere più corto di 36
caratteri. Richieste, nomi non ricostruiti e geometrie escluse restano
sconosciuti. Queste guardie sono conservative del modello, non nuove
condizioni del gioco originale.

## Evidenza offline e confronto naturale

La cattura riparte dal checkpoint originale3014, verificando clock,
locazione, bitmap, attributi, contatore e modo della finestra. Registra
il LOOK successivo e i frame reali senza alterare posizioni o identità.
La traccia del produttore21 include anche scritture che conservano lo
stesso valore e non presenta transizioni non classificate.

* **144 LOOK completi controllati:** tutte le 36 colonne iniziali e contatori
  0/4/12/14, con tutti i 24 attori mantenuti. Varia soltanto la geometria
  dichiarata. I messaggi originali sono archiviati senza normalizzazioni;
  il test ABI confronta D soltanto quando il modello ne possiede il valore.
  Non sono144 partite naturali, né una certificazione integrale dei loro
  turni casuali modificati dall’overlay video.
* **216 glifi controllati:** sei descrittori DE, comprese parti alte
  diverse da 51, su tutte le 36 colonne. Dimostrano che D è il byte del
  descrittore, indipendente da font, shift e posizione. Ritorno sintetico
  0008, nessun tick: questa è una prova della routine del glifo.
* **Partita dall’avvio:** seed 1, tutti i 24 attori, grafica nativa, LOOK
  iniziale gratuito, input maiuscoli iniettati e MORE immediato, nessun
  teletrasporto. Sono confrontati **8.283 estrazioni e17.586 letture**, gli
  ingressi e risultati casuali, bitmap e attributi superiori a ogni draw,
  clock, locazione, contatore, finestra, esiti e finale.

Salva/Carica JSON in nuove sessioni è controllato ai checkpoint
**1488,2005,2780,2911,3015**; l’ultimo contiene il D appena ricostruito.
Seguono **132 checkpoint** di futuro, confrontando anche risposte e stato
completo. Le tre storie di vittoria a Victoria con seed 0/1/137 restano
prove distinte, ciascuna di 3.219 checkpoint. Il nuovo prefisso non aggiunge
un finale certificato né dimostra equivalenza per ogni partita.

## Prossimo limite: E del nome train nella finestra stretta

La lettura successiva non ricostruita è **$5D22**: Watson legge 235
($EB) al tick 3448, durante WAIT UNTIL 5:45PM, nel checkpoint che termina
alle 17:28. Il produttore naturale è già tracciato: **C38A al tick 3411**,
comando **N**, spazio dopo steam con **frame $5D28**, in finestra stretta.
DE è **$58EB**, riferimento al sostantivo train. Con quel frame E occupa $5D22.

La traccia include 2.754 scritture osservati e nessuna transizione non
classificata. Il prossimo lavoro riguarda il chiamante dell’arrivo,
la geometria accanto all’immagine e la durata del descrittore. Non è
ancora implementato; non va sostituito con $EB catturato dalla registrazione.

## Mappa e materiali

Approfonditi **$A815–A82E**, **$A887–A8B8**, **$C388–C39D**,
**$D3E8–D444** e **$D526–D5C8**, oltre al workspace dinamico20–22.
Il nuovo listato contiene188 istruzioni e354 byte, riassemblati e
confrontati con il payload. La copertura resta 40.029 byte documentati,
305 parziali,1.266 sconosciuti: nessun nuovo grigio classificato.

[LOOK naturale e frame](results/look-carried-descriptor/look-detail.json) ·
[144 geometrie](results/look-carried-descriptor/look-abi.json) ·
[216 glifi](results/look-carried-descriptor/glyph-abi.json) ·
[Listato commentato](results/look-carried-descriptor/look-carried-descriptor.asm) ·
[Prossimo produttore22](results/look-carried-descriptor/next-stack22.json) ·
[Rapporto e test](results/look-carried-descriptor/verification.json).


Verifica conclusiva: **50 test mirati** passati, oltre al replay della
variante dall’avvio e ai tre percorsi completi fino alla vittoria con
seed 0, 1 e 137. Nessun confronto normalizzato o finale aggiuntivo.
[Output dei test](results/look-carried-descriptor/test-output.txt).


Aggiornamento 24 novembre 2026: superato il successivo $5D22 dell’arrivo
con immagine. La variante coincide per 3.240 checkpoint fino a mercoledì
alle 18:54; prossimo limite $5D23 alle 18:55.
Vedi [arrivo con grafica e nome visibile](ARRIVO-CON-GRAFICA-E-NOME-VISIBILE.md).
