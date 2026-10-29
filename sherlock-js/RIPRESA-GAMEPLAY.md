# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   356 checkpoint, da 0 a 355, fino a mercoledì 07:00: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `GLIFI-E-SHIFT-SALVATO.md`
   e `results/glyph-shift-verification.json`.

2. **Prossimo confine reale: $5D22, secondo operando sullo stack.**
   Il confronto supera 5D1C e si ferma al checkpoint 356 verso mercoledì07:10:
   l’estrazione della cuoca al tick2826 legge prima5D1C=7 (ora ricostruito), poi
   5D22 (ancora sconosciuto). Identificare frame e ultimo scrittore, comprese
   scritture invariate; non dedurre39 da un possibile indirizzo video.
   Leggere GLIFI-E-SHIFT-SALVATO.md. Il valore5D1C è C nel frame5D26,
   shift=(2+7*colonna)&7, ultimo writer naturale C3B7/tick962/Lestrade.
   Il GO TO verificato lo preserva; gli altri chiamanti non proiettati lo
   revocano. Vecchi salvataggi senza byte restano sconosciuti.
   Il prefisso completo rimane0–355 sino a Wed07:00: nessun nuovo minuto o
   finale certificato soltanto per il superamento del primo operando.

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
Suite di regressione attuale: **892 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
