# Flag dei glifi e annuncio degli argomenti

## Provenienza di 5D1A

Il valore letto dal generatore a mercoledì 03:28 proviene da un flag del
renderer, conservato sullo stack durante una pulizia della riga inferiore.
Il probe osserva ora i veri PUSH/CALL e anche EX (SP),HL, comprese le
scritture che ripetono il valore precedente. Nel percorso naturale non
rimangono transizioni di valore prive di classificazione.

L’ultimo store pertinente osservato è C3B8 a tick 962: Lestrade sale nel
cab e il qualificatore «hansom» del primo argomento deve andare a capo.
La stessa catena è verificata prima nella rimozione del travestimento:
«The china man takes off the china mans disguise.» La parola «mans»
richiede un ritorno a capo durante lo scarico del buffer.

L’annuncio normale passa da CA76 ad A2E4/A37D; il primo argomento di
entità passa da A3DE ad A745/A751/D3E8. Il prefisso qualificato arriva
al glifo con frame 5D2C. Se la parola non entra, A9EF/A9F1 richiede il
CR e la pulizia C374 raggiunge C388 con frame 5D26. Il flag F dell’ultimo
PUSH AF occupa allora frame−12, cioè 5D1A.

È un valore derivato dalle istruzioni del renderer, non un byte catturato.
Alla scansione finale, con shift tra 1 e 7, DEC C / INC C lascia F a zero;
con shift zero il secondo PUSH viene saltato e rimane il flag della prima
scansione, derivato da INC H verso 57 esadecimale nella riga inferiore.
Anche questo è zero nel contratto ricostruito. Il carattere può avere una
riga del font diversa da zero: F e A non sono la stessa informazione.

## Implementazione autonoma e limiti

La pagina annota il prefisso del nome dell’entità nei due annunci verificati:
CLIMB INTO e TAKE OFF, con qualificatori e sostantivo non proprio. Il
contratto riguarda i comandi diretti del giocatore e le azioni ordinarie
dei programmi NPC; richieste fra personaggi e frame isolati restano esclusi. La stampa
calcola il ritorno a capo con l’impaginazione già ricostruita; soltanto
questo chiamante può pubblicare il nuovo residuo dei flag. Gli altri
annunci e le scene generiche non ricevono automaticamente il contratto.

Gli ordini GO TO / GO FURIOUSLY TO del chiamante già verificato non
raggiungono quel flag: lo conservano mentre aggiornano il proprio prefisso.
In quest’ultimo, il frame 5D2A salva anche C e B a 5D20/5D21: l’ultimo
shift orizzontale e il conteggio B=1. Questi campi sono ora proiettati
separatamente da 5D1A. Le celle intermedie 5D1B–5D1E restano sconosciute.

Stampe ed errori senza un contratto verificato revocano i nuovi campi.
I salvataggi conservano i valori posseduti; LOAD non riempie un campo
mancante con lo zero iniziale o con quello osservato. I contesti del
renderer sono ripristinati al termine della stampa. Non si esegue codice
Z80 nel motore JavaScript.

## Prove e prosecuzione

La suite passa **725 test**. Le nuove prove comprendono 432 chiamate C388
native controllate (quattro frame, tre caratteri, tutte le 36 colonne),
la proprietà di 5D1A lungo 74 comandi naturali fino a martedì 07:00,
l’invalidazione degli altri chiamanti e l’assenza di fallback al LOAD.
Il probe separato continua per 76 comandi fino a mercoledì 03:40.
La storia conserva tutti i 24 posti attore; i setup ABI restano prove
controllate e non certificati di gioco naturale.

Il prefisso major-witness confronta ora **338 checkpoint, 0–337, fino a
mercoledì 04:00**: ogni sorteggio/lettura, arena completa, entità, programmi,
bitmap e futuro dopo LOAD, compresi i minuti live del WAIT. Il protocollo
resta seed 1, LOOK iniziale gratuito, grafica originale spenta dopo il boot,
input maiuscolo iniettato e MORE immediato.
Rapporto: `results/glyph-flags-verification.json`;
ripetere con `node tools/verify-witness-prefix.mjs`.

Il confronto completo separato si ferma al checkpoint 338, diretto a
mercoledì 04:10, su **A01A**: lo stato ALL/BUT del parser. È distinto dal
flag temporaneo 5D1A. Le sue scritture note sono AAB3 (reset), B03F (ALL)
e B026 (BUT). Va ricostruito il ciclo effettivo, comprese citazioni, errori,
coordinazioni e continuazioni: non basta restituire zero perché il comando
corrente è WAIT, né inferirlo soltanto dall’ultimo nodo dell’AST.

Nessun nuovo finale completo è certificato. Rimangono aperti 6A33, 6ABD,
6AF3, 6B79 e 75D2; le varianti naturali certificate restano quattro.

## Mappa sincronizzata

Il dossier `results/glyph-flags/glyph-flags.asm` riassela 251 istruzioni /
446 byte del payload: annuncio dell’azione, primo argomento, scroll,
pulizia, flag delle scansioni e scrittore alternativo EX (SP),HL.
La classificazione documentata cresce di 193 byte unici; quelli ancora
non analizzati sono 3.218. La misura dei byte non è una misura di
equivalenza completa del gameplay.
