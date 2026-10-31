# A029: inizio dell’ultimo token letto

Il nuovo campo `parserTokenStart` ricostruisce un puntatore funzionale del
lexer/parser. A029 è il byte basso, A02A quello alto. Il motore JavaScript
non esegue queste istruzioni: conserva il cursore nel proprio parser e ne
espone i byte al generatore casuale già ricostruito.

## Due writer, due buffer

D9C5 salta gli spazi; D9CD salva l’indirizzo del primo carattere prima del
riconoscimento. Il valore può puntare a una parola sconosciuta o al CR
finale, nel buffer5B00. D6F5 lo usa per stampare il rifiuto lessicale.
Il preflight e la tokenizzazione successiva attraversano entrambi quel
writer. Non ci sono estrazioni casuali tra le due scansioni nel protocollo
verificato; la riscrittura lessicale pubblica lo stesso risultato prima
dell’analisi sintattica.

AE7F carica il cursore prossimo A02B e AE82 lo salva in A029 prima di
leggere il tipo. AE86 conserva separatamente la classe precedente inA02D.
Il lettore avanza di3byte per le classi inferiori a80 e per90/E0/F0;
le altre classi occupano1byte. Il payload dei token è big-endian, mentre
il puntatore A029 e i nodi sintattici sono little-endian.

A02B avanza; A029 conserva l’inizio. Le ricerche speculative del soggetto,
i gruppi nominali e i predicati possono ripartire daA029. Perciò non si
può assegnare semplicemente la fine dell’intera riga una volta per comando.
La riscrittura pubblica il cursore delle consultazioni sintattiche, compresa
la modalità di affermazione e gli errori.

## Citazioni e continuazioni

B06D registra il cursore subito dopo la virgoletta iniziale. B085 consulta
i token fino alla virgoletta finale; B092 usaA029 per sostituirla conC0.
La richiesta differita rilegge quel contenuto con la sua base originale:
non inizia nuovamente da5B81. Il nuovo callback del parser riceve tale
base dalle citazioni, incluse quelle ricavate dalla coda persistente.
La risposta a una domanda di chiarimento è invece una nuova riga di input.
Le prove comprendono OPEN DOOR/YOUR, ALL, citazioni con più azioni,
affermazioni rifiutate, errori lessicali e comandi separati dal punto.

## Il blocco naturale

La nuova acquisizione originale osserva entrambi i writer, anche quando
riscrivono lo stesso valore, con tutti24attori attivi. Non trova altre
transizioni nel percorso witness fino a mercoledì18:20.
L’ultimo store prima della lettura problematica è AE82, tick2341,
Holmes0, chiamanteAC33: il token punto B0 dopo il comando WAIT UNTIL
è a5B8A. La lunghezza viene calcolata dai tipi dei token: non è un8A
di ripiego. Al draw del giardiniere8, il generatore legge A029=8A
insieme adA023=58 e l’intera estrazione torna a coincidere.

## Stato e limiti

Quattro boot originali con seed1/2/77/255 confermano il dato iniziale0.
Il valore caricato dal payload è dichiarato negli asset estratti. Dopo un
writer il puntatore è salvato come stato corrente; un vecchio LOAD senza
campo resta sconosciuto finché un writer compreso lo ristabilisce.
Una revoca della proiezione del parser revoca anche il puntatore.
Le interrogazioni della UI non scrivono questo campo.

Le48ABI controllate del lettore coprono16classi in tre posizioni del buffer;
non sono partite naturali. Il corpus breve conserva anche due tentativi
non certificati: PRINT/NOPRINT/SAVE sono rifiutati dal bridge dell’oracolo,
e TAKE TO incontra il limite di ricerca già dichiarato. Il rollback del
bridge ripristina il vecchio puntatore: le transizioni osservate al ritorno
A536 non sono nuovi writer del gioco. Questi due casi restano nel file di
ricerca ma sono esclusi esplicitamente dai nove confronti positivi; nessun
campo del confronto viene normalizzato per farli passare.

Il confronto continuo di solo puntatore/estrazioni va distinto dal
certificato completo a checkpoint del dossier. Non certifica la riga
transitoria del giardiniere che già divergeva nel campionamento minuto per
minuto. Restano separati i limiti PRINT/MORE, TAKE TO e cab5D0C, oltre ai
cinque finali naturali ancora da raggiungere.

## Mappa della memoria

Il listato tipizzato riassella263istruzioni/564byte contro il payload.
A029–A02A passa da parziale a documentato:2byte, zero byte prima grigi.
Approfonditi AE7F–AEA8, D9C5–DA31, D6CE–D713, D719–D768,
D780–D7B1, AAD1–AB10, AB4C–AB8D e B049–B099.
Copertura:38846byte documentati,431parziali,2323sconosciuti su41600.
La copertura statica non equivale al completamento del gameplay.

## Risultato del confronto completo

Il nuovo certificato positivo comprende **430 checkpoint 0–429 fino a
mercoledì 19:20**, con 8.685 estrazioni e 18.604 letture confrontate.
Comprende tutti i 24 posti attore, stato originale completo, arena752byte,
bitmap esatti e futuro dopo LOAD. È stato eseguito separatamente dal
lookahead: non è una conclusione ricavata dal solo messaggio del prossimo
blocco. Le 8.687 estrazioni totali del runtime includono due estrazioni
iniziali, separate dalle 8.685 confrontate nei comandi.

Il prossimo ingresso sconosciuto è **5D2A al checkpoint430 verso le19:30**,
cuoca9, draw indice4 della traccia originale. Quel checkpoint fallito non
è incluso nel certificato. Non dedurre il valore da5D29 e non installare
il53 osservato. Restano aperti i cinque finali naturali.

Il corpus breve positivo conta nove storie, 31 input, 41 checkpoint,
151 estrazioni, 302 letture e 410 store osservati del puntatore.
La verifica continua separata comprende 3.371 checkpoint e confronta
8.526 estrazioni/18.256 letture fino alle 18:20 di mercoledì.
Gli hash dei riferimenti nuovi e di quello lungo riutilizzato sono in
`results/parser-token-start/provenance.json`.

Verifica conclusiva A029: suite completa di 1.575 test passata, zero errori.
107 controlli mirati parser/lexer e 8 controlli atlante/hosting passati.
Il certificato positivo di 430 checkpoint è completato e salvato.
