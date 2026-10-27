# Continuazione ancora in ricerca

`major-witness.txt` formula prima della visita le due ipotesi sul maggiore,
poi osserva realmente la confessione nella fumeria. Non imposta alcun flag
interno. Il test nativo esteso è raccolto da `probe-other-endings.py`.

La sua esecuzione JavaScript, ancora distinta dal certificato di 69BF,
scagiona il maggiore e prosegue sino a martedì 05:18. Il successivo ingresso
5D12 non è ancora posseduto: la pagina si arresta esplicitamente a quel
confine, senza installare il byte di un replay. Il dato osservato di 5D11
serve come evidenza offline, non come asset del motore.

Il fixture può contenere successivamente il resto della raccolta nativa:
questo non lo rende automaticamente una storia certificata. Il test dei
finali accetta soltanto i casi esplicitamente elencati come certificati nel
rapporto. Nessun file in questa cartella viene caricato dal gioco.

La raccolta nativa è conclusa e compressa in
`witness-native-reference.json.gz`: 521 checkpoint, 6A33 giovedì 10:00.
Il confronto `node --test tools/compare-witness-research.mjs` trova
la prima divergenza già al checkpoint 25, lunedì 08:57: 97B5 è 9 nel
prototipo, 4 nell'originale, dopo la richiesta con due affermazioni.
Questo ha priorità sul successivo ingresso sconosciuto 5D12.

Esperimento escluso: eliminare il nodo intermedio apparentemente spurio
dopo AND. Anche l’originale lo alloca; toglierlo cambia di 33 byte il
blocco libero e rompe il caso controllato 23 di `information.test.mjs`.
Il motore verificato conserva quella allocazione.
