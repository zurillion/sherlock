# I sei ruoli del byte alto salvato a $5D25

Il limite precedente era la prima lettura casuale di5D25 da parte diWatson,
nel checkpoint439 verso mercoledì21:00. Il valore originale osservato è92 ($5C), ma
non è una costante del gioco. La cella appartiene allo stack riutilizzato dalle
routine di stampa e può contenere dati diversi in chiamate differenti.

## Writer del renderer

`frame` indica lo stack pointer all’ingresso del glifoC388. I registri salvati
occupano celle fisiche diverse al cambiare del chiamante:

| Frame | Writer | Valore a5D25 |
|---|---|---|
| 5D26 | C388, PUSH AF | A del chiamante: codice del carattere |
| 5D28 | C389, PUSH BC | B del chiamante: lunghezza residua della parola, se posseduta |
| 5D2A | C38A, PUSH DE | D del descrittore di testo fornito dal chiamante |
| 5D2C | C38B/C398, PUSH HL | H dell’indirizzo video5020+floor((2+7×colonna)/8) |
| 5D2E | C39C/C3B7, PUSH BC | B della scansione, salvato prima diDJNZ: ultimo valore1 |
| 5D30 | C39D/C3B8, PUSH AF | A dell’ottava riga grezza del font, prima della rotazione |

Il byte basso5D24 ha un contratto distinto. Non basta conoscerlo per ricavare
quello alto: ad esempio i flagF, il descrittoreE e lo shiftC non permettono di
inventare rispettivamenteA,D oB mancanti.

La vera CALL aC374 lascia il ritornoC377. Quando il frame del glifo è5D24,
il byte altoC3 del ritorno rimane a5D25. Le chiamate ABI con ritorno sintetico
0008 sono distinte: non provano il valore del ritorno di un chiamante reale.
Un ritorno non proiettato revoca il vecchio valore posseduto di5D25.

## Proprietà nel motore autonomo

La proiezioneJavaScript usa le operazioni di output, il frame ricostruito, il
carattere, il descrittore e la colonna. I valori derivano dal chiamante o dai
dati del font, non dalle registrazioni delle estrazioni. Il registroB del
chiamante assente revoca la proprietà invece di conservare un dato vecchio.

Il prefisso noto dell’attore a5D2A può stabilire D=5C. Un frame della
destinazione che scrive soltanto da5D26 in avanti non cancella quel byte:
sono celle indipendenti. I test precedenti che richiedevano5D25 sconosciuto
perché il campo non era ancora implementato ora controllano questo writer.
Scene, errori e chiamanti non posseduti mantengono le loro revoche esplicite.

SAVE/LOAD conserva il campo se è posseduto. Un vecchio salvataggio senza5D25
rimane sconosciuto anche quando5D24 è noto.5D2B non viene introdotto.

## Prove ABI riutilizzate

I riferimenti originali sono già archiviati; il dossier registra percorso e
SHA256, senza presentarli come nuove acquisizioni:

- 1.728 chiamateC388: otto frame, due contatori, tre caratteri,36 colonne;
- 1.152 chiamate con descrittori5C0B,5C42 e5123, per distinguereD da una costante;
- 288 chiamate realiC374, comprendenti il ritornoC377.

I nuovi test esercitano i sei ruoli di5D25, controllano tutti gli altri byte
posseduti presenti nei riferimenti e lasciano5D2B sconosciuto. Controllano anche
il caricamento di un vecchioSAVE incompleto, le revoche e il ritorno non noto.
Queste chiamate hanno parametri controllati: non certificano da sole la
raggiungibilità naturale di tutti quei frame.

## Prova naturale e certificato completo

`tools/probe-glyph-high-role-25.py` esegue nuovamente la storia sull’originale
con tutti24 i posti attore, seed1, LOOK iniziale gratuito, grafica originale
spenta dopo l’avvio, input maiuscolo iniettato e MORE immediato. Osserva sia25
sia26 per distinguere le scritture; il nuovo campo implementato è soltanto25.
Il rapporto conserva l’ultimo writer, anche quando il valore non cambia,
e segnala separatamente eventuali cambiamenti non classificati. Il registro
degli store allegato a ciascun comando è una finestra degli ultimi24 eventi,
non un dump illimitato di tutte le scritture della partita.

La nuova traccia conta76 checkpoint:3 con proprietà nota e73 esplicitamente
sconosciuti, senza transizioni originali non classificate. Watson legge92 al
tick3656 (mercoledì20:55). L’ultimo writer è C38A/PUSH DE al tick964,
Lestrade2, frame5D2A: il carattere finale «r» di «Inspector» salva il
descrittore5C0B, il cui byte alto è5C. Il verificatore ricava D dal registro
originale e confronta SAVE/LOAD dopo un’interruzione.

Correzione dell’annotazione precedente: lo zero era la prima lettura a5C25,
non quella a5D25. La stessa estrazione riprova leggendo in ordine5C25=0,
F912=0,5D25=92,FA12=145. Nessun valore della traccia entra nel runtime.

Il confronto naturale di proprietà e writer è separato dalla verifica completa.
Quest’ultima è conclusa: **443 checkpoint0–442 fino a mercoledì21:30**, con
**8.987 draw e19.234 read**. Include tutti24 i posti attore, entità, fatti,
programmi, arena752 byte, bitmap e futuro dopoLOAD. Le8.989 estrazioni del
runtime comprendono le due del boot. È un certificato delimitato del profilo
sopra dichiarato, non dell’intero gioco.

Il checkpoint443 verso mercoledì21:40 è escluso: Watson3 raggiunge un ingresso
sconosciuto aA025, draw indice12 del riferimento. Non installare lo0 osservato
o dedurlo daA024. I cinque finali naturali, il cab5D0C, PRINT/MORE, TAKE TO e
il controesempio del dialogoWatsonKilledYou rimangono aperti.

## Atlante

Approfondite324 istruzioni e615 byte, tutti riassemblati contro il payload:
C388–C3E3, C363–C37C, A360–A418, A59F–A5CC, A720–A770, A7BA–A7CF,
D3E8–D447, A95B–A98F, CE10–CE17 e il testo682A–682F. La tabella del workspace
ora distingue i sei ruoli di5D25 e il return link.

Nessun byte prima grigio viene riclassificato. La copertura rimane38.847 byte
documentati,430 parziali e2.323 sconosciuti su41.600; non è una misura del
completamento del gameplay.

## Riproduzione

```sh
python3 tools/probe-glyph-high-role-25.py
node tools/verify-glyph-high-role-25-natural.mjs
node --test test/glyph-high-role-25.test.mjs
node tools/verify-glyph-high-role-25-prefix.mjs
node tools/verify-glyph-high-role-25-lookahead.mjs
python3 tools/build-glyph-high-role-25-listing.py
python3 tools/build-memory-map.py
```

I riferimenti ABI e le tracce rimangono oracoli offline. Il motore giocabile
non importa i loro valori e non esegue istruzioniZ80.


## Esito dei test

117 controlli mirati passati. La suite completa ha eseguito1.689 test:
1.687 passati e due vecchie asserzioni room-name che richiedevano5D25 ignoto.
Aggiornate per verificare D=5C, entrambe sono passate nel rerun mirato.
Sono quindi1.689 test distinti verificati senza errori residui; non una seconda
esecuzione completa1.689/0. Log integrale iniziale e rerun sono conservati.
