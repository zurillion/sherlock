# Punto di ripresa dopo la digressione sulla mappa della memoria

Il lavoro sul gameplay non è concluso. L’atlante della memoria è una digressione
richiesta dall’utente; non sostituisce questi obiettivi e non ne certifica la copertura.

Aggiornamento corrente: [FLAG-DEL-CHIAMANTE-5D30.md](FLAG-DEL-CHIAMANTE-5D30.md).

1. **Prima storia del ramo witness verificata fino al finale6A33.**
   521 checkpoint0–520 da lunedì08:00 a giovedì10:00; tutti24 i posti attore,
   entità,fatti,programmi,arena752 byte,bitmap,ogni estrazione e futuroLOAD.
   10.345 draw/22.058 read confrontati;10.347 runtime incluse2 estrazioni boot.
   Anche pausa terminale,bitmap prima dell’acknowledgement e comandi congelati
   dopo il finale. Rapporto results/glyph-caller-flags-30/witness-complete.json;
   ripetibile con node tools/verify-glyph-caller-flags-30-witness.mjs.
   Oracolo lungo originale RIUTILIZZATO conSHA, non nuova acquisizione terminale.
   Profilo:seed1/all24/LOOK iniziale gratuito/grafica nativa spenta dopo boot/
   input maiuscoli iniettati/MORE immediato. Non è equivalenza globale del gioco.

2. **5D30 risolto, nessun altro limite in questa storia fino al finale.**
   Il byte di stack ha sei ruoli secondo il frame del renderer: F/C chiamante,
   E descrittore,L video,C/F scansione; veraCALLC374 può lasciare77 del returnC377.
   Canale superioreC2BA–C305: CP0D prima dellaCALL, q→26/n→10; clear→84.
   Non installare26 né ricavarlo dal vicino. Chiamanti non proiettati e dati
   mancanti revocano la proprietà; oldSAVE senza30 restaunknown.2B–2F e31 ignoti.
   Nuove4284 ABI originali e256 esecuzioni indipendenti diCP0D.
   Atlante:362 istruzioni/691 byte riassemblati,approfonditiC2BA–C305,
   C363–C37C,C388–C3E3 e relativi formatter/annunci. Nuovo campo5D30 nelworkspace.
   Nessun nuovo byte grigio del payload;38949/428/2223su41600 invariati.
   Conservare contrattiCB28,A026,A025,5D25 e argomenti del giardiniere.
   Dialogo SAY WATSON "WATSON KILLED YOU":7 drawJS contro10 nativo ancora aperto.

3. **Certificare naturalmente i quattro testi terminali ancora aperti:**
   6ABD, 6AF3, 6B79 e 75D2. Sono già coperti i nove selettori con prove
   controllate; le partite naturali certificate raggiungono soltanto
   693A, 69BF, 6A26, 6A33 e 759C. Occorrono acquisizione reale degli indizi e delle
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

   Limite separato emerso il30 ottobre: ingresso naturale nel cab seguito da
   SAY CABBIE "GO TO KINGS CROSS ROAD" diverge nel campo5D0C (JS47/nativo0).
   Riprodotto anche sul vecchio commit8e3b605: non è una regressione diA022.
   Il corpus breve certifica solo i7 input precedenti; il suffisso è conservato
   e nessun campo del confronto è stato rimosso. Vedere
   results/dictionary-reference/unrelated-boundary.json.

   Due controesempi esplorativi, riprodotti anche sul commit15db455:
   dopo SAY WATSON "WAIT UNTIL 9AM", I, PRINT il contatore MORE è0 inJS
   e2 nell’originale; TAKE TO lascia il budget fallimenti3 inJS e0 nativo.
   Conservati nel corpus e in test separati, senza certificare equivalenza.
   Vedere results/output-channel/unrelated-boundaries.json. Non rimuovere
   campi dal confronto per farli passare; restano da ricostruire.

   Il precedente controesempio continuo al1671/Tue14:02 è ora risolto dalla
   separazione degli argomenti di lavoro: prova completa positiva0–1671.
   Il vecchio rapporto results/output-channel/minute-boundary.json resta
   come evidenza storica. Questo non estende automaticamente il controllo
   completo ai restanti checkpoint delle tracce continueA024/A029.

5. **Estendere l’equivalenza della partita completa.**
   Più seed e ordini delle azioni, attese lunghe e mezzi di trasporto, diversi
   tempi di input e grafica nativa. Il protocollo certificato attuale usa seed 1,
   tutti i 24 posti attore, LOOK iniziale gratuito e grafica nativa disabilitata.
   Salvataggi: conservare lo stato casuale corrente e tutti i suoi ingressi,
   richieste, identità e continuazioni. La pagina resta un motore autonomo JS.

Riferimenti principali: `STATO-E-PROSSIMI-PASSI.md`, `FINALI-E-CONFESSIONI.md`,
`results/final-solution/RESEARCH.md`, `AGENTS.md`.
Aggiornamento 31 ottobre 2026: mappa aggiornata insieme alle nuove analisi.
La verifica completa dei finali rimane aperta; il corpus di ricerca fallente
è separato dalla suite di regressione e dal prefisso naturale certificato.
Suite e prove correnti: vedere `results/name-qualifier-mode-verification.json` e
GitHub Actions del commit pubblicato. Prefisso esteso ripetibile
con `node tools/verify-glyph-video-low-2a-prefix.mjs`.


Aggiornamento29 ottobre2026 — consegna/restituzione NPC: leggere
CONSEGNA-E-RESTITUZIONE-NPC.md e results/npc-handover-verification.json.
GIVE senza TO usa l’ordine destinatario/oggetto del modello8321–8328,
B421/B445. La conversione semantica è idempotente e conserva i gruppi fisici
per continuazioni/arena; ALL può avere un gruppo vuoto. Nessun ramo speciale
Watson. YOUR resta qualificatore del nome; D275 verifica il possesso reale.
La classe D non esclude il soggetto: GIVE MONEY TO ME può riuscire; con
nessun destinatario esplicito conta anche Holmes e la coppia può non essere
unica. Non inventare un default Watson. Un fallimento semantico della
richiesta salta B973/B976 e non scrive l’iteratore nel record liberato.
A7D0–A7E9 mantiene YOU minuscolo dentro la frase, non è nome proprio.
25 sequenze naturali/99 input, Watson e cocchiere, tutti24 attori,376 draw/
754 read, arena752 byte, bitmap esatti e futuro dopo LOAD. Vale il protocollo
IO dichiarato, non una certificazione generale di ogni NPC o finale.
Atlante252 istruzioni/538 byte: A7D0–A7E9 documenta26 byte prima grigi;
approfonditi8321–8328,B280–B2B6,B405–B482,B936–B98B,B9AC–B9F9,
C7E4–C7F8,C814–C820,C8C6–C8EE,D275–D29C,DF02–DF2D.
Confine lungo invariato A022 al checkpoint359 verso Wed07:40; prefisso
naturale0–358 sino a Wed07:30. Cinque finali ancora aperti. Riferire in chat
le nuove zone dell’atlante, senza confondere copertura statica e gameplay.

Verifica conclusiva consegne NPC: suite completa982 test,982 passati,0 errori.


Aggiornamento30 ottobre2026 — leggere ULTIMO-RIFERIMENTO-LESSICALE.md e
results/dictionary-reference-verification.json. A022/A023 conserva il
riferimento lessicale completo (offset12 bit più contesto), scritto daA88C e
A8B5 soltanto con5C3C nonzero. Anche offset0 scrive il primo descrittore;
letterali e dizionario fuori scena conservano. I nomi usano40/50; i comandi
senza parola di terminazione non chiamanoA887. Non ricavare il campo dal
testo inglese finale o dal seed. Text.render lo proietta dalle operazioni;
output sintetici/errori privi di contratto revocano. Old LOAD assente resta
unknown fino a un writer, nessun valore iniziale/catturato di ripiego.
Ultimo writer naturale tick964 attore0, nome destinazione STREET0861 con
modo50:5861. Lettura giardiniere attore8/tick2852/Wed07:31:61hex.
Prefisso ora365 checkpoint0–364 sino a Wed08:30,6992 draw/14966 read,
tutti24 attori, arena752 byte, bitmap e futuro LOAD. Prossimo confine5D1D
al checkpoint365 verso Wed08:40; cinque finali naturali ancora aperti.
64 casi ABI;6 storie brevi complete più prefisso cab7 input:31 input,
158 draw/316 read. Il suffisso cab fallisce su5D0C (47 JS/0 nativo),
riprodotto sul baseline8e3b605: conservarlo come limite separato, senza
normalizzare o ignorare quel campo. Vedi unrelated-boundary.json.
Suite1054 test tutti passati. Atlante265 istruzioni/523 byte: A022–A023
parziale->documentato;78 byte prima grigi in A3E2–A413,A65C–A65D,A815–A82E.
Approfonditi A37D–A418,A5CD–A5F1,A63F–A65D,A880–A92E,D3E8–D447.
Riportare le nuove zone in chat; la copertura statica non è gameplay completo.


30 ottobre2026 — registro B salvato: leggere GLIFI-E-CONTEGGIO-SALVATO.md e
results/glyph-count-verification.json.5D1D è il B interno soltanto nel frame
C388=5D26: C399 imposta8, C39C/C3B7 salvano BC prima di DJNZ; l’ultimo
salvataggio è1. Gli altri frame hanno altri ruoli:5D1E:A chiamante,
5D20:B chiamante,5D22:D descrittore,5D24:H video,5D28:A font.
Non assegnare1 globalmente, né ricavarlo da C a5D1C. Proprietà condizionata
all’ABI del chiamante, GO TO verificato preserva AF/BC; output sconosciuti
revocano. B chiamante assente rimane sconosciuto. Old save senza5D1D non
riceve fallback e5D1E non è introdotto.
Ultimo writer naturale C3B7/tick962/Lestrade/spazio della pulizia del prefisso
hansom cab: frame5D26,BC0107. Lettura cuoca9/tick2918/Wed08:37:1.
1.728 casi ABI:8 frame,2 B chiamante,3 caratteri,36 colonne. Probe naturale
76 comandi sino08:50, nessuna transizione non classificata; il modello
confronta i valori posseduti prima del limite e la prima lettura, NON08:50.
5D1D è superato; manca5D23 nella stessa estrazione, checkpoint365 verso08:40.
Prefisso completo invariato0–364/365 sino Wed08:30,6992 draw/14966 read,
24 attori, arena/bitmap e futuro LOAD. Non dichiarare un nuovo checkpoint o
un finale per avere risolto soltanto il primo operando. Cinque finali aperti.
Atlante119 istruzioni/179 byte approfonditi, nessun nuovo byte grigio:
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 e annotazione workspace5D1D.
Conservare il limite separato del cab5D0C, riportare le zone in chat.

Verifica conclusiva 5D1D: suite completa 1.104 test passati, 0 errori; 55 controlli mirati passati.


30 ottobre2026 — byte alto video: leggere GLIFI-E-BYTE-ALTO-VIDEO.md e
results/glyph-address-high-verification.json.5D23 è H salvato da C38B/C398
solo nel frame5D2A del prefisso proprio del nome attore in682A (CE13 ->6804
->67F7 ->A7C5/D3E8). Calcolare (5020+floor((2+7*colonna)/8))>>>8;
non installare80. Ultimo writer C398/tick964/Lestrade/r di Inspector,
colonna8,HL5027. Lettura cuoca9/tick2918/Wed08:37:80, dopo5D1D=1.
6 ruoli del glifo: frame5D24:A chiamante,5D26:B chiamante,5D28:D descrittore,
5D2A:H video,5D2C:B scansione,5D2E:A font. La vera CALL C374, con frame5D22,
scrive invece C377 e lascia C3 a5D23.1.728 ABI glifo più288 pulizie reali,
8 frame e36 colonne. Vecchi LOAD senza5D23 restano sconosciuti anche con
5D22 noto; chiamanti senza contratto revocano.5D24–5D27 e5D1E non introdotti.
Il vecchio test naturale5D1D ora ESIGE l’assenza di not_translated fino08:50;
non accetta più il vecchio limite5D23. Nuovo probe originale sino10:00,
modello confronta valori posseduti e lettura ma si ferma suA01D: non
spacciare10:00 per certificazione completa. Confine attualeA01D al
checkpoint368 verso Wed09:10. Prefisso esteso0–367/368 sino Wed09:00,
7059 draw/15134 read,24 attori, arena/bitmap e futuro LOAD. Cinque finali
naturali restano aperti. Il limite cab5D0C rimane separato.
Atlante235 istruzioni/419 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C363–C37C,
C388–C3E3,CE10–CE17,D3E8–D447 più workspace5D23. Riferire le zone in chat.

Verifica conclusiva 5D23: suite completa 1.155 test passati, 0 errori; 106 controlli mirati passati.
