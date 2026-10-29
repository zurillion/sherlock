# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   349 checkpoint, da 0 a 348, fino a mercoledì 05:50: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `CHIARIMENTI-E-OFFSET-DEL-PARSER.md`
   e `results/clarification-offset-verification.json`.

2. **Prossimo confine reale: $A021, temporaneo dei controlli sugli argomenti.**
   Il confronto completo supera A01B ma si ferma su A021 nello stesso checkpoint 349
   verso mercoledì 06:00. Ricostruire scritture, reset e persistenza; non dedurlo
   dall’ultimo successo, dal costo o da un valore iniziale.
   A01B è ora esplicito: boot A044=0, domanda B5B6=offset 08/12, ritorno D793=0.
   Lexical errors e @ durante un chiarimento non attraversano quel reset.
   La selezione TAKE include il giornale di Watson come candidato semantico;
   l’esecuzione può rifiutarlo. Il riferimento unico è scelto automaticamente.
   Le continuazioni conservano gli slot fisici anche con complementi anteposti.
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
Suite di regressione attuale: **874 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
