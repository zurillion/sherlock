# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Prima divergenza del ramo che scagiona Ffoulkes.**
   Eseguire `node --test tools/compare-witness-research.mjs`.
   Checkpoint 25, lunedì 08:57, seed 1:
   `SAY LESTRADE "MAJOR VISIT OPIUM DEN AND MAJOR IS INNOCENT"`.
   Il record liberato a 97B5 conserva 9 in JavaScript e 4 nell’originale.
   Ricostruire dal codice le scritture e il riuso dei nodi.
   **Non eliminare il nodo intermedio:** anche l’originale lo alloca;
   l’esperimento che lo rimuove cambia il blocco libero di 33 byte e rompe
   il caso 23 di `information.test.mjs`.

2. **Seguire la stessa partita oltre la prima differenza corretta.**
   La registrazione originale completa contiene 521 checkpoint e termina
   con 6A33 giovedì alle 10:00. È salvata in
   `results/final-solution/witness-native-reference.json.gz`.
   Il blocco JS a 5D12 di martedì 05:18 è un limite successivo della vecchia
   sequenza divergente, non il primo difetto da correggere né un tempo nativo
   da riprodurre. Confrontare ogni lettura e successore casuale, arena, bitmap,
   programmi, scadenze e futuro dopo LOAD, senza valori registrati nel runtime.

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
Ultimo punto verificato prima dell’atlante: 657 test di regressione passati;
il confronto di ricerca sopra è separato e ancora fallente.
Commit precedenti: d58092c (motore e arresto naturale), 8b5d12e (ricerca estesa).
