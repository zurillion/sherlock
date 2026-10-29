# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   359 checkpoint, da 0 a 358, fino a mercoledì 07:30: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `MODALITA-ALL-E-CONTINUAZIONE-SEMANTICA.md`
   e `results/resolution-mode-verification.json`.

2. **Prossimo confine reale: $A022, secondo ingresso della stessa estrazione.**
   A01C è superato: il giardiniere legge0 dal modo del resolver, quindi
   incontra A022 ancora sconosciuto al checkpoint359 verso Wed07:40.
   Ricostruire writer, inizializzazione e conservazione di A022; non
   installare il97 registrato né inferirlo dai flag del parser o del testo.
   A01C segue D800/B959/B1EC/B1FD e ha contesti distinti D6B8/record richiesta+2.
   Errori precedenti al resolver conservano il residuo; ALL esaurito può
   lasciare A01C=128 mentre D6B8=0. CLIMB INTO/HAIL forzano selezione singola.
   Fine ALL NPC: libera quel nodo e passa al comando successivo, non cancella
   il suffisso. Vecchi save senza campo rimangono sconosciuti fino a un writer.
   Il prefisso resta0–358 sino a Wed07:30; nessun nuovo finale certificato.

3. **Certificare naturalmente i cinque testi terminali ancora aperti:**
   6A33, 6ABD, 6AF3, 6B79 e 75D2. Sono già coperti i nove selettori con prove
   controllate; le partite naturali certificate raggiungono soltanto
   693A, 69BF, 6A26 e 759C. Occorrono acquisizione reale degli indizi e delle
   confessioni, deduzioni degli omicidi, caso dei piani e percorso finale.
   Tricia/Mrs Jones è implementata ma la nuova confessione è verificata in
   un setup controllato, non ancora nella soluzione naturale completa.

4. **Conservare e chiarire i limiti dichiarati.**
   Da confrontare separatamente: CLIMB INTO ARMCHAIR ripetuto quando si è
   già nel primo candidato (predicato E3F5/DEE4), oltre al flag di selezione
   singola ora ricostruito. Non estendere il certificato del flag ai predicati
   non esercitati dalle sequenze attuali.
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
Suite di regressione attuale: **956 test verificati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
