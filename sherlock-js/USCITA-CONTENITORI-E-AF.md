# Uscita dai contenitori: produttore AF e conservazione del valore

21 novembre 2026.

La variante con LOOK prima del primo HAIL CAB coincide ora per **3.050
checkpoint**, fino a **mercoledì alle 15:49**. È superata la lettura di
$5D20 da parte di Watson nella continuazione dell’attesa delle 14:23.
Il prossimo checkpoint escluso è alle **15:50**, su **$5D21**.

## L’ultima scrittura prima delle 14:23

Il comando GET OUT che termina alle 13:31 produce due annunci:

> You get out of the steam train.
> Watson climbs out of the steam train.

Il secondo annuncio è un’azione ordinaria del programma di Watson, non
l’esecuzione isolata di una citazione. Il suo qualificatore steam passa
per il formatter del primo argomento. Il frame del glifo è **$5D2C**.
L’ultima m viene scansionata al tick **3210** e **PUSH AF a $C3B8**
scrive **F in $5D20 e A in $5D21**. Nell’ottava scansione entrambi valgono
zero. A è l’ultima riga del font, non il codice ASCII della m salvato
all’ingresso del renderer. Il byte basso viene letto al tick **3263**.

Il modello calcola i due byte con l’algoritmo di scansione già ricostruito:
font ROM, allineamento e flag. Non assegna uno zero al generatore casuale.
La prova segue anche gli store che riscrivono lo stesso valore; non ci
sono transizioni non classificate nel byte osservato.

**$CA76** entra con SP=$5D6C. Il formatter seleziona l’argomento a **$A3DE**,
poi articolo e qualificatore passano dal formatter dei nomi. Il sostantivo
finale train. resta invece in buffer fino al CR, il cui ingresso $A9B7
ha SP=$5D5A: i suoi glifi usano **$5D46**. Il wrap di quel sostantivo
non è quindi il wrap del qualificatore e non sostituisce l’AF appena scritto.

La nuova annotazione distingue proprio questi due frame. È limitata a
CLIMB OUT OF e GET OUT OF con costo positivo, chiamante ordinario,
soggetto You oppure nome proprio non qualificato, argomento comune con
un qualificatore e corrispondenza verificata con i dati grezzi del nome.
Richiede inoltre grafica nativa, riga larga nuova, buffer vuoto, margine
prima del MORE, frase al massimo di 72 caratteri e prefisso che entra
nella prima riga. Questi sono limiti conservativi della ricostruzione,
non nuovi vincoli del gioco. Richieste, chiamanti isolati e caption già
proiettate non ereditano il nuovo contratto.

## Perché ricostruire il produttore non bastava

Dopo GET OUT, il modello rendeva nuovamente sconosciuti i byte in tre
percorsi che nell’originale li conservano:

1. **Annunci direzionali del giocatore.** Il compositore senza argomenti
   stampa You go south. senza sostituire questa coppia di stack. La
   conservazione è limitata al giocatore 0, azione direzionale ordinaria
   senza gruppi, riga larga nuova e frase corta prima del MORE.
2. **Descrizioni brevi.** Le due S successive portano alla stazione e alla
   main street. Il chiamante **$D1B2**, con SP=$5D68, salta la parte profonda
   dell’arrivo completo. Il contratto misurato riguarda giocatore 0 alla
   radice, nome di stanza comune con un qualificatore, nessun contenuto da
   elencare, massimo cinque uscite, testo entro 96 caratteri, riga larga
   nuova e `contatore + 8 < 15`. La conservazione copre anche il CR finale.
3. **Errore di riferimento per CLIMB INTO.** La police cab non è presente:
   l’errore I SEE NO POLICE CAB THAT YOU CAN CLIMB INTO conserva i due byte.
   Nel modello il risultato può passare da due rami di risoluzione: entrambi
   ricevono la stessa proprietà circoscritta. Il controllo richiede chiamante
   ordinario, stanza senza prosa, giocatore alla radice e in luce, un gruppo
   con INTO e fino a due qualificatori, senza candidati nominali percepibili.

Il margine sui contatori è una guardia conservativa del modello. I valori
precedenti sono conservati, non ricostruiti dal seed: un campo assente in
un vecchio salvataggio resta assente. Gli altri byte del renderer mantengono
contratti distinti. Il costo delle azioni e gli esiti del gioco non cambiano.

## Prove controllate, separate dalla partita naturale

| Prova originale | Setup | Scopo |
| --- | ---: | --- |
| Caption CA76 più CR conclusivo | 1.152 | Attori 0/3, verbi 13/25, hansom cab/steam train, 36 colonne, quattro contatori |
| Annunci direzionali più CR | 120 | Dieci direzioni, tre colonne, quattro contatori |
| Descrizioni brevi più CR | 360 | Due stanze, 36 colonne, cinque contatori |
| Errori CLIMB INTO | 18 | Tre identità giocabili, sei gruppi nominali |

Le chiamate isolate usano i frame misurati e un ritorno sintetico $0008;
non eseguono tick. Le prove degli errori sono invece input completi, con
identità, marker e budget dei fallimenti controllati: i clock risultanti
sono registrati, senza dichiararli costanti o privi di turni. Tutti i 24
programmi degli attori restano presenti. I setup non sono presentati come
1.650 partite naturali.

Un controllo aggiuntivo mantiene identità, posizione e budget della partita
originale prima di CLIMB INTO POLICE CAB e sovrascrive soltanto i due marker
e le loro copie nell’editor: i marker restano intatti e il clock resta
alle 13:35. I test del singolo glifo confrontano inoltre 216 casi del
precedente ABI, comprese righe finali del font non nulle.

Nei test del modello si confrontano esattamente i byte che i contratti
possiedono; le geometrie escluse restano sconosciute. Sono controllati
anche il testo delle caption e la selezione delle uscite, senza correggere
il confronto naturale per farlo passare.

## Confronto dall’avvio e Salva/Carica

Profilo seed 1, tutti i 24 attori, grafica nativa dall’avvio, primo LOOK
gratuito, input maiuscoli e MORE immediati, nessun teletrasporto.
Il prefisso confronta **8.047 estrazioni e 17.074 letture**, bitmap e
attributi superiori a ogni estrazione, contatore MORE, modo della finestra,
clock, stanza, esito e finale.

Salva/Carica JSON è verificato in nuove sessioni ai checkpoint **1488,
2005, 2780 e 2911**, l’ultimo subito dopo GET OUT. Seguono **138 checkpoint
di futuro**, confrontando anche risposte e stato completo delle sessioni.
Restano confermati i tre percorsi di vittoria con seed **0, 1 e 137**,
ciascuno di 3.219 checkpoint con i rispettivi Salva/Carica.

## Il nuovo limite: stesso indirizzo, nuovo significato

Il LOOK delle 15:15 effettua una scrittura successiva: **PUSH DE a $C38A**
nel glifo spazio con frame **$5D26**, fra daily e chronicle. DE vale
**$51AB**, riferimento a chronicle con contesto 5 e offset $1AB.
Il byte alto **D=$51** viene letto in $5D21 da Watson alle 15:50.

Non è A dell’AF precedente. Il modello correttamente revoca il vecchio
valore invece di riusarlo. Il prossimo lavoro è ricostruire la proprietà
di questo descrittore nel separatore del nome portato e la sua durata.
La traccia del nuovo scrittore è archiviata ma il percorso non è ancora
proiettato nel motore.

## Atlante

Sono approfonditi **$CA76–$CA7E**, **$A3D6–$A3E1**, **$D1B2–$D1C5**,
**$D178–$D181**, **$C388–$C39D** e **$C3B7–$C3BA**. Il workspace $5D20–$5D21
riporta ora sia il produttore AF sia il successivo descrittore DE del LOOK.
Il nuovo listato contiene **43 istruzioni e 77 byte**, riassemblati e
confrontati con il TAP. La copertura resta 40.029 byte documentati,
305 parziali e 1.266 sconosciuti: nessun nuovo grigio classificato.

[Scrittore naturale AF](results/container-exit-af/natural-writer.json) ·
[Comando GET OUT e frame](results/container-exit-af/get-out-detail.json) ·
[Caption controllate](results/container-exit-af/caption-abi.json) ·
[Descrizioni brevi](results/container-exit-af/brief-abi.json) ·
[Errore nel contesto originale](results/container-exit-af/original-error-marker.json) ·
[Nuovo scrittore DE](results/container-exit-af/next-look-descriptor.json) ·
[Listato commentato](results/container-exit-af/container-exit-af.asm).

Controlli conclusivi:30 test di formatter e mappa, il replay dall’avvio
della variante e i tre percorsi completi di vittoria sono passati.
[Rapporto del traguardo](results/container-exit-af/verification.json) ·
[Output dei test](results/container-exit-af/test-output.txt).

Nelle caption di uscita più corte di36caratteri si conserva inoltre
il contratto preesistente dei byte1A–1D. I12setup originali ammissibili
li mantengono tutti a markerA5; i test controllano anche i valori del modello.
Questo evita di perdere il precedente byte1A degli annunci del cab quando
si introduce il nuovo tracciamento del nome dell’argomento.


Aggiornamento 22 novembre 2026: superato il successivo $5D21 del LOOK.
Il prefisso della variante è ora 3.148 checkpoint fino a mercoledì alle 17:27; prossimo
limite $5D22 alle 17:28. Vedi [nuovo dossier](LOOK-E-DESCRITTORE-DEL-SOSTANTIVO.md).
