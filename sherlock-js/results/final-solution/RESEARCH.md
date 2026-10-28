# Continuazione ancora in ricerca

`major-witness.txt` formula le due ipotesi prima della visita e poi osserva
la confessione nella fumeria. Non imposta flag interni. Il riferimento nativo
contiene 521 checkpoint e termina in 6A33 giovedì 10:00; è compresso in
`witness-native-reference.json.gz` e non viene caricato dal gioco.

Aggiornamento 28 ottobre: risolti la scrittura del predicato intermedio
AB7C/AC17 e la fase A00B delle regole con argomenti espliciti. Il confronto
JS passa ora sui checkpoint 0–205 fino a martedì 06:40, con tutti gli attori,
ogni draw/read, arena, entità, fatti, bitmap e futuro dopo LOAD.

`node --test tools/compare-witness-research.mjs` prosegue oltre il prefisso
e si ferma al checkpoint 206, diretto a martedì 06:50, per l’ingresso 5D13
ancora senza proprietario ricostruito. Il vecchio blocco 5D12 era un sintomo
di una sequenza già divergente: non è il confine attuale.

Vedere `PARSER-E-FASE-REGOLE.md` e
`results/parser-rule-lifetimes-verification.json`. La traccia è evidenza
offline, non un asset del runtime. Conservare tutte le allocazioni dei nodi
intermedi: il nuovo predicato ne sovrascrive il verbo prima dell’allocazione
successiva, non ne elimina il record.
