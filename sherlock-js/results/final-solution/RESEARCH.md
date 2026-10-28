# Continuazione ancora in ricerca

`major-witness.txt` formula le due ipotesi prima della visita e poi osserva
la confessione nella fumeria. Non imposta flag interni. Il riferimento nativo
contiene 521 checkpoint e termina in 6A33 giovedì 10:00; è compresso in
`witness-native-reference.json.gz` e non viene caricato dal gioco.

Aggiornamento 28 ottobre, seconda ripresa: corrette le dipendenze del renderer
fino a 5D19, i puntatori di C8EF e gli enumeratori delle affermazioni,
lunghezza/prefisso lessicale, scritture letterali TELL fuori scena e copia
ROM della mappa degli stream. A011 è esplicito per il profilo grafica off.

Il prefisso JS passa su 247 checkpoint, fino a martedì 13:10, con tutti gli
attori, ogni draw/read, arena, entità, fatti, bitmap e futuro dopo LOAD.
Rapporto: `results/transient-inputs-verification.json`.
Ripetere con `node tools/verify-witness-prefix.mjs`.

Il confronto completo `node --test tools/compare-witness-research.mjs` rimane
separato e si ferma al checkpoint 247, diretto a martedì 13:20: contatore
A012 non ancora proiettato (il nativo legge 1 nel turno del giardiniere).
Ricostruire le scritture del parser, senza trasformare 1 in un fallback.
I vecchi limiti 97B5, A00B, 5D13, A013, BA13, DC13, 5D16, 5C17 e A011 sono
risolti; il vecchio 5D12 apparteneva a una storia già divergente.

Vedere `INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md` e `RIPRESA-GAMEPLAY.md`.
Nessuna traccia raccolta dai probe diventa un asset di comportamento del gioco.
