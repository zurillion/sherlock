# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

1. **Ultimo prefisso verificato del ramo che scagiona Ffoulkes.**
   Corrette la sovrascrittura del predicato nel nodo intermedio (AB7C/AC17)
   e la fase A00B delle regole con argomenti espliciti (C5F4 prima del
   predicato). Confronto naturale riuscito su 206 checkpoint, da 0 a 205,
   fino a martedì 06:40: tutti gli attori, ogni estrazione/lettura casuale,
   arena completa, entità, programmi, bitmap e futuro dopo LOAD.
   Vedere `PARSER-E-FASE-REGOLE.md` e il relativo rapporto.

2. **Prossimo confine reale: ingresso temporaneo $5D13.**
   Eseguire `node --test tools/compare-witness-research.mjs`.
   Il checkpoint 206, diretto a martedì 06:50, incontra questo byte senza
   un proprietario ricostruito. Studiare le scritture del renderer/stack,
   senza riempire il valore da una registrazione o estendere alla cieca
   i campi posseduti. La registrazione nativa completa ha 521 checkpoint
   e termina con 6A33 giovedì 10:00; non è ancora un certificato JS completo.
   I vecchi scostamenti a 97B5 (lun 08:57) e A00B (mar 04:00) sono risolti.
   Non eliminare il nodo intermedio: l’originale lo alloca e ne sovrascrive
   il predicato prima di creare il successivo.

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
Suite di regressione attuale: **667 test passati**. Prefisso esteso ripetibile
con `node tools/verify-witness-prefix.mjs`.
