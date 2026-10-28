# Contatori del parser e stato delle deduzioni

## Comportamento ricostruito dal sorgente

A012 non è la lunghezza dell’albero sintattico: il payload parte da FF,
AAB6 azzera il byte quando entra nel parser, AD66 lo incrementa modulo 256
e AD3D ripristina il valore precedente durante il backtracking. Un errore
lessicale precedente all’ingresso conserva il valore vecchio. Le citazioni
avviano il proprio parsing, comprese quelle vuote.

BUT crea un nodo supplementare senza contare il nodo principale in quel
passaggio; il separatore di un’esclusione non incrementa, la chiusura finale
sì. Anche OPEN ALL BUT, senza un nome dopo BUT, è accettato dall’originale.
THAT senza separatore incrementa prima di riallocare; HE e IT/THEY riallocano
senza quell’incremento. Le prove confrontano anche i record liberati, non
soltanto la frase o il conteggio finale. SAVE/PAUSE/PRINT durante una
precisazione attraversano il percorso del controllo e conservano il loro
conteggio effettivo.

A019 espone il contatore cumulativo del renderer già ricostruito: il
confronto delle storie ora verifica esplicitamente anche questo byte.
D714 è invece transitorio: @ lo imposta nell’editor, ma D6C8 lo azzera
quando consegna l’input, prima della tokenizzazione e dei turni degli NPC.
Non diventa un attributo persistente del comando ripetuto.

BA1C e BA1D sono il numero di affermazioni riconosciute e il flag «almeno
una non provata». BA1E–BA1F contengono il puntatore dell’ultimo fatto
riconosciuto, scritto prima di valutarne la prova. Se nessun fatto è
riconosciuto il puntatore precedente sopravvive. La scansione successiva
seleziona il primo fatto completo oppure l’ultimo incompleto, senza
azzerare i due contatori. Questa distinzione conta anche nelle richieste
con più affermazioni, alcune provate e altre no.

Sono campi logici JavaScript salvati con la partita. I vecchi salvataggi
che non li possiedono mantengono lo stato sconosciuto finché un percorso
ricostruito li scrive; non ricevono un valore osservato come fallback.

## Prove e limiti

La suite completa passa 712 test. I nuovi probe eseguono l’originale offline:
25 sequenze di parsing, OPEN ALL BUT con stato e bitmap completi e quattro
setup controllati delle deduzioni. I setup controllati non sono certificati
di acquisizione naturale degli indizi. Le prove includono estrazioni,
letture, record e futuro dopo LOAD; l’analisi preventiva del parser resta pura.

Il prefisso naturale major-witness è verificato separatamente da
`node tools/verify-witness-prefix.mjs`: checkpoint 0–322, fino a mercoledì
01:30, con tutti i 24 posti attore, seed 1, LOOK iniziale gratuito,
grafica originale spenta dopo l’avvio e MORE immediato. Il rapporto è
`results/parser-counter-verification.json`. Il confronto completo resta
una ricerca fallente separata: al checkpoint 323, verso mercoledì 01:40,
il generatore legge 5C1F, ancora non posseduto dal modello.

5C1F appartiene alla parte dei vecchi stream ROM riutilizzata dal buffer
lessicale. Occorre ricostruire sia l’inizializzazione sia le scritture del
lexer DA34–DA77: copiare semplicemente uno zero osservato introdurrebbe
un valore obsoleto dopo parole sufficientemente lunghe. Anche le successive
letture per rigetto del sorteggio devono essere ricostruite.

Nessun nuovo finale completo è certificato. Restano aperti 6A33, 6ABD,
6AF3, 6B79 e 75D2; sono naturali soltanto 693A, 69BF, 6A26 e 759C.

## Atlante

Il dossier `results/parser-counter/parser-counter.asm` distingue codice e
dati, commenta le scritture e riassela 304 istruzioni / 705 byte del payload.
La mappa include i campi e i percorsi di parser, editor, MORE e deduzioni.
La copertura in byte resta distinta dall’equivalenza del gameplay.
