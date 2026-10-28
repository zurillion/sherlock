# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   334 checkpoint, da 0 a 333, fino a mercoledì 03:20: tutti gli attori,
   ogni estrazione/lettura, arena completa, entità, programmi, bitmap,
   contatore MORE e futuro dopo LOAD. Vedere `NOMI-ORDINI-E-STACK.md`
   e `results/upper-stack-verification.json`.

2. **Prossimo confine reale: frame temporanei $5D1A.**
   Il confronto completo si ferma al checkpoint 334, verso mercoledì
   03:30 (minuto effettivo 03:28). 5D1F è ora derivato dal prefisso del
   nome proprio negli ordini NPC: CE13/682A -> 6804 -> 67F7, poi
   A751/A7C5/D3E8, C388 frame5D2A. Non estendere la proprietà ai byte
   5D1A–5D1E o alle scene: la prima estensione generica lasciava residui
   obsoleti. Identificare scrittori e sovrascritture del nuovo indirizzo.
   Le stampe senza contratto, nomi non propri ed errori revocano il nuovo
   byte. Il tracciato delle transizioni non osserva scritture identiche:
   usare insieme catena di chiamate, ABI e confronti naturali.
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
Suite di regressione attuale: **722 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
