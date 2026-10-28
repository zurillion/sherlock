# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   323 checkpoint, da 0 a 322, fino a mercoledì 01:30: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere
   `CONTATORI-PARSER-E-DEDUZIONI.md` e `results/parser-counter-verification.json`.

2. **Prossimo confine reale: workspace lessicale $5C1F.**
   Il confronto completo si ferma al checkpoint 323, verso mercoledì 01:40.
   Ricostruire la coda degli stream ROM e le copie del lexer DA34–DA77
   nel buffer a 5C0B, poi le successive letture per rigetto del sorteggio.
   Non installare zero come fallback: parole lunghe possono sovrascriverlo.
   A012, A019, D714 e BA1C–BA1F sono ora proiettati dal rispettivo algoritmo.
   La storia nativa completa ha 521 checkpoint e termina in 6A33 giovedì
   10:00: quel finale non è ancora certificato JavaScript.

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
Aggiornamento 28 ottobre 2026: mappa aggiornata insieme alle nuove analisi.
La verifica completa dei finali rimane aperta; il corpus di ricerca fallente
è separato dalla suite di regressione e dal prefisso naturale certificato.
Suite di regressione attuale: **712 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
