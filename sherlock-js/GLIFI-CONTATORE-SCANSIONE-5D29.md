# $5D29: byte alto salvato dal renderer

Il blocco osservato verso le 18:00 dipendeva da un byte dello stack riusato
come ingresso del generatore casuale. Il renderer JavaScript ora ne deriva
il valore nei chiamanti verificati, senza CPU Z80, snapshot di RAM o risposta
casuale registrata da riprodurre.

## Il ciclo delle otto righe

C399 imposta B = 8. Per ogni riga del carattere, C39C salva BC; se il glifo
è diviso fra due byte video, C3B7 salva di nuovo la coppia. C3CF la ripristina
prima del DJNZ in C3D2. L'ultima coppia rimasta sullo stack conserva dunque
**B = 1 prima del decremento finale a zero**. Il B temporaneo FF usato per la
maschera dei pixel non è questo risultato.

Nel frame C388 = 5D32, BC occupa 5D28/5D29: C è lo shift, B è il contatore.
Lo shift zero salta C3B7 ma lascia la stessa ultima iterazione nel PUSH C39C.
È una proprietà del writer in quel frame, non un valore1 restituito per
qualunque lettura dell'indirizzo.

## Sei ruoli dello stesso indirizzo

| Frame d'ingresso C388 | Contenuto salvato a 5D29 |
| --- | --- |
| 5D2A | A del chiamante, normalmente il codice del carattere |
| 5D2C | B del chiamante; sconosciuto se il suo conteggio non è proiettato |
| 5D2E | D del descrittore del testo |
| 5D30 | H dell'indirizzo video |
| 5D32 | B della scansione; ultima iterazione1 |
| 5D34 | A della scansione; ultima riga grezza del font |

Un'altra scrittura è il vero CALL in C374: con frame 5D28 lascia C377
nelle celle 5D28/5D29, quindi **C3** nel byte alto. Un ingresso sintetico
con return0008 non prova questa scrittura; si usano le vere CALL archiviate.

## Perché il writer è noto

La precedente acquisizione originale osservava ogni PUSH/CALL a5D28,
anche quando il valore non cambiava. Il record del PUSH BC aC3B7 conserva
SP 5D2A e BC 0102, tick 964, glifo finale t del prefisso Parliament,
frame 5D32. Quella stessa istruzione scrive due byte: 2 a 28 e 1 a 29.

Il dossier riutilizza il record completo della **scrittura a 16 bit**, con
percorso e SHA256. Non deduce29 dal solo valore numerico di28, e non
presenta questa derivazione come una nuova traccia naturale completa di
tutti gli store29. Il riferimento nativo lungo contiene la lettura di29
al checkpoint421, draw8 della cuoca, valore1; il confronto naturale del
nuovo motore verifica l'intera estrazione, incluse le due coppie di letture.

## Proprietà, errori e LOAD

Il nuovo byte viene pubblicato soltanto nei contratti di renderer compresi.
Un caller ignoto, una scena non proiettata, un errore o un nome locazione
senza contratto revoca29 insieme agli altri residui. Un nuovo writer compreso
lo ristabilisce. Il campo del B del chiamante non viene riempito con1 quando
quel B manca.

Un vecchio LOAD senza29 conserva il dato come sconosciuto anche se27/28
sono presenti. Il nuovo SAVE conserva29 se posseduto. 5D25 resta non
proiettato: il supporto di29 non giustifica estendere altri byte vicini.

## Prove e confini

Le ABI originali archiviate verificano frame,36 colonne, conteggi 3/7,
descrittori diversi, font e vere CALL. Il manifest provenance.json conserva
SHA256 e ambito di ogni file riutilizzato: nessuna nuova acquisizione ABI
o lunga è dichiarata. Le prove distinguono il contatore dalle altre cinque
interpretazioni, coprono lo shift zero e il return link C3.

Il prefisso completo confronta ora **423 checkpoint 0–422 fino a mercoledì
18:10**, con **8.493 draw e 18.188 read**, tutti i 24 attori, entità, fatti,
scheduler, arena di 752 byte, bitmap esatti e futuro dopo LOAD. Protocollo:
seed 1, LOOK iniziale gratuito, grafica originale disabilitata dopo il boot,
input maiuscoli iniettati e MORE immediato.

Il prossimo limite effettivo è **A029 al checkpoint423 verso le18:20**.
I 22 draw verificati prima del blocco non certificano lo stato completo del
checkpoint annullato. La seconda lettura29 nel riferimento, al503, resta
fuori dal prefisso certificato; conservarla non significa averla raggiunta.

Restano i cinque finali naturali, il limite cab5D0C e i controesempi separati
PRINT/MORE, TAKE TO e riga del giardiniere nel campionamento continuo.
Non sono stati eliminati o normalizzati campi di confronto.

## Mappa

Approfonditi C388–C3E3, C363–C37C, A360–A418, A59F–A5CC,
A720–A770, A7BA–A7CF, D3E8–D447, A95B–A98F, CE10–CE17,
il programma di testo682A–682F e il workspace5D29.
324 istruzioni e 615 byte riasssemblati contro il payload. Sono zone già
censite: **zero nuovi byte prima grigi**, copertura invariata del payload.
La mappa del workspace ricorda esplicitamente che29 può essere sconosciuto
anche con28 noto; non certifica una RAM interamente ricostruita.

Verifica conclusiva:155 test mirati distinti passati (40 del nuovo dossier,
53 sullo shift,52 sul font,8 su mappa/hosting,2 sui controesempi conservati).
Sono riutilizzati4152 record di chiamate ABI originali archiviati; non si
rivendica una nuova acquisizione né unicità di tutte le configurazioni.
Il confronto positivo delimitato423 checkpoint è stato eseguito e ha
salvato regolarmente witness-prefix.json.
