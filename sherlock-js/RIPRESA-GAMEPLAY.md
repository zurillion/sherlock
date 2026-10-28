# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   247 checkpoint, da 0 a 246, fino a martedì 13:10: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap e
   futuro dopo LOAD. Alle correzioni del parser AB7C e della fase A00B si
   aggiungono renderer fino a 5D19, puntatori A013–A016, enumeratori delle
   affermazioni BA13–BA1B, lookup DC13/DC14, letterali TELL fuori scena,
   inizializzazione ROM dei canali e flag grafico A011.
   Vedere `INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md` e il relativo rapporto.

2. **Prossimo confine reale: contatore del parser $A012.**
   `node --test tools/compare-witness-research.mjs` si ferma al checkpoint
   247, diretto a martedì 13:20. Il generatore consulta A012 (1 nel nativo).
   Ricostruire AAB2/AD57, coordinazioni, esclusioni, backtracking e citazioni;
   non inserire il valore osservato come costante. La lettura arriva nel
   turno del giardiniere. Il confronto completo ha ancora 521 checkpoint
   e termina nel nativo con 6A33 giovedì 10:00: quel finale non è certificato JS.
   La traccia precedente 5D13/5D16 è risolta; le letture reali dei nuovi byte
   coincidono. Anche il vecchio errore nel buffer di Straker a 5C15 è risolto.

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
Suite di regressione attuale: **681 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
