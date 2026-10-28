# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   338 checkpoint, da 0 a 337, fino a mercoledì 04:00: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `FLAG-GLIFI-E-ANNUNCI.md`
   e `results/glyph-flags-verification.json`.

2. **Prossimo confine reale: stato ALL/BUT del parser $A01A.**
   Il confronto completo si ferma al checkpoint 338 verso mercoledì 04:10.
   Ricostruire AAB3 (reset), B03F (ALL=1), B026 (BUT=2), controlli AFE8,
   vita del dato fra unità, citazioni, errori e continuazioni. È uno stato
   globale temporaneo del parsing, non il booleano ALL dell’ultimo nodo.
   Il backtracking che ripristina A012 non ripristina automaticamente A01A.
   Non inserire zero perché la storia corrente sta eseguendo WAIT.
   Il precedente 5D1A è derivato dal flag F del glifo di pulizia a frame5D26:
   gli annunci CLIMB INTO/TAKE OFF scaricano il prefisso di entità a frame5D2C.
   5D20/5D21 derivano da C/B del prefisso degli ordini; 5D1B–5D1E restano
   sconosciuti. Il probe delle scritture include anche EX (SP),HL e gli
   store di valore identico. Vedere il dossier per invalidazione e limiti.
   La storia nativa completa termina in 6A33 giovedì 10:00: quel finale
   non è ancora certificato JavaScript.

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
Suite di regressione attuale: **725 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
