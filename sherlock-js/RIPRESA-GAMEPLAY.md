# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   359 checkpoint, da 0 a 358, fino a mercoledì 07:30: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `GLIFI-E-INDIRIZZO-VIDEO-SALVATO.md`
   e `results/glyph-address-verification.json`.

2. **Prossimo confine reale: $A01C, stato della risoluzione dei riferimenti.**
   Il confronto supera i due operandi 5D1C/5D22 dell’estrazione della cuoca
   a Wed07:05 e arriva sino a Wed07:30. Si ferma al checkpoint359 verso07:40.
   Ricostruire letture e scritture di A01C: D800, B1EC/B1FD e i chiamanti
   D818/D85F/B1E3/B218/B23E/B260/B280/B2B1/B517 sono indizi statici,
   non un contratto già implementato. Non derivarlo da ALL/BUT o pending.
   Leggere GLIFI-E-INDIRIZZO-VIDEO-SALVATO.md. 5D22 nel frame5D2A è L
   dell’indirizzo video conservato a C38B/C398; viene calcolato dalla colonna,
   non installato come39. I chiamanti sconosciuti revocano e i vecchi save
   senza byte rimangono sconosciuti. Le celle5D23–5D27 sono solo osservate.
   La storia nativa completa termina in6A33 giovedì10:00: ancora non certificata JS.

3. **Certificare naturalmente i cinque testi terminali ancora aperti:**
   6A33, 6ABD, 6AF3, 6B79 e 75D2. Sono già coperti i nove selettori con prove
   controllate; le partite naturali certificate raggiungono soltanto
   693A, 69BF, 6A26 e 759C. Occorrono acquisizione reale degli indizi e delle
   confessioni, deduzioni degli omicidi, caso dei piani e percorso finale.
   Tricia/Mrs Jones è implementata ma la nuova confessione è verificata in
   un setup controllato, non ancora nella soluzione naturale completa.

4. **Conservare e chiarire i limiti dichiarati.**
   TELL di Tricia senza vestiti percepibili può bloccarsi nell’originale a
   A9B0: il rollback esplicito del prototipo è una protezione, non una risposta
   inventata del gioco. Restano i frame temporanei non posseduti, compresi
   quelli del cab della polizia, e i casi di corruzione dei buffer citati in
   `LINGUAGGIO-COMPLESSO.md`. Non inserire byte iniziali o catturati come fallback.

5. **Estendere l’equivalenza della partita completa.**
   Più seed e ordini delle azioni, attese lunghe e mezzi di trasporto, diversi
   tempi di input e grafica nativa. Il protocollo certificato attuale usa seed 1,
   tutti i 24 posti attore, LOOK iniziale gratuito e grafica nativa disabilitata.
   Salvataggi: conservare lo stato casuale corrente e tutti i suoi ingressi,
   richieste, identità e continuazioni. La pagina resta un motore autonomo JS.

Riferimenti principali: `STATO-E-PROSSIMI-PASSI.md`, `FINALI-E-CONFESSIONI.md`,
`results/final-solution/RESEARCH.md`, `AGENTS.md`.
Aggiornamento 29 ottobre 2026: mappa aggiornata insieme alle nuove analisi.
La verifica completa dei finali rimane aperta; il corpus di ricerca fallente
è separato dalla suite di regressione e dal prefisso naturale certificato.
Suite di regressione attuale: **895 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
