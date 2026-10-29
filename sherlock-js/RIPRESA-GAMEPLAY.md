# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   356 checkpoint, da 0 a 355, fino a mercoledì 07:00: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `CONTROLLI-ARGOMENTI-E-RESIDUO.md`
   e `results/argument-check-verification.json`.

2. **Prossimo confine reale: $5D1C, byte dello stack.**
   Il confronto completo supera A021 e si ferma al checkpoint 356 verso
   mercoledì 07:10. Identificare chiamante, frame e ultimo scrittore, comprese
   scritture dello stesso valore. Non copiare un valore registrato né estendere
   automaticamente il contratto di 5D1A/5D1B: vedi GLIFI-E-BYTE-DI-SCANSIONE.md.
   A021 ora segue i controlli C628/C6BE: C655 scrive0, C6BA scrive1;
   il rifiuto di classe entità del secondo ruolo a C726 conserva il vecchio
   byte. Nessun reset per successo, tick o nuovo comando. I vecchi save senza
   campo restano sconosciuti. Le intestazioni sono dati, non codice eseguito.
   La storia nativa completa termina in 6A33 giovedì 10:00: non ancora certificata JS.

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
Suite di regressione attuale: **889 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
