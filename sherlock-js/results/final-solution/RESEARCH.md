# Continuazione ancora in ricerca

Stato corrente30 ottobre2026: prefisso365 checkpoint0–364, fino a Wed08:30,
6992 draw/14966 read confrontati, tutti24 attori, arena/bitmap e futuro LOAD.
A022/A023 è ricostruito dall’emissione lessicale;5D1D è ora ricostruito dal
B salvato nel renderer. Il confronto completo passa quella lettura e si
ferma al checkpoint365 verso Wed08:40 su5D23, nella stessa estrazione.
Il certificato resta fino08:30, senza un nuovo checkpoint per il primo operando.
Rapporti: results/glyph-count-verification.json e
results/glyph-count/witness-prefix.json. Cinque finali naturali
ancora da certificare. Le sezioni successive conservano la cronologia delle
analisi, non sostituiscono questo limite corrente.

`major-witness.txt` formula le due ipotesi prima della visita e poi osserva
la confessione nella fumeria. Non imposta flag interni. Il riferimento nativo
contiene 521 checkpoint e termina in 6A33 giovedì 10:00; è compresso in
`witness-native-reference.json.gz` e non viene caricato dal gioco.

Aggiornamento 28 ottobre, seconda ripresa: corrette le dipendenze del renderer
fino a 5D19, i puntatori di C8EF e gli enumeratori delle affermazioni,
lunghezza/prefisso lessicale, scritture letterali TELL fuori scena e copia
ROM della mappa degli stream. A011 è esplicito per il profilo grafica off.

Il prefisso JS passa su 247 checkpoint, fino a martedì 13:10, con tutti gli
attori, ogni draw/read, arena, entità, fatti, bitmap e futuro dopo LOAD.
Rapporto: `results/transient-inputs-verification.json`.
Ripetere con `node tools/verify-witness-prefix.mjs`.

Il confronto completo `node --test tools/compare-witness-research.mjs` rimane
separato e si ferma al checkpoint 247, diretto a martedì 13:20: contatore
A012 non ancora proiettato (il nativo legge 1 nel turno del giardiniere).
Ricostruire le scritture del parser, senza trasformare 1 in un fallback.
I vecchi limiti 97B5, A00B, 5D13, A013, BA13, DC13, 5D16, 5C17 e A011 sono
risolti; il vecchio 5D12 apparteneva a una storia già divergente.

Vedere `INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md` e `RIPRESA-GAMEPLAY.md`.
Nessuna traccia raccolta dai probe diventa un asset di comportamento del gioco.

## Terza ripresa: limite corrente

Il rapporto corrente è `results/parser-counter-verification.json`: 323
checkpoint (0–322) fino a mercoledì 01:30. Ricostruiti A012, A019, D714
e BA1C–BA1F dal sorgente. Il confronto completo si ferma al checkpoint
323 verso mercoledì 01:40, lettura non posseduta 5C1F. Ricostruire la
coda ROM degli stream insieme alle scritture lessicali DA34–DA77 prima
di esporre questi byte. Il finale 6A33 resta non certificato; il rapporto
precedente rimane come prova storica del suo prefisso più corto.

## Quarta ripresa: workspace lessicale

`results/lexical-workspace-verification.json` riconferma i checkpoint
0–322 fino a mercoledì 01:30. Ricostruiti il cold-start degli stream
5C1E–5C35 e le copie lessicali DA34–DA77. Il confronto completo supera
5C1F e si ferma sulla successiva lettura 5D1F nello stesso checkpoint 323.
Nessuna estensione di orario o nuovo finale è certificata. Il probe
naturale da tick 2400 conferma le letture ma non l’ultimo scrittore
precedente: indagare i frame di glifi C39D e decoder A969/A97C.
Vedere `LEXER-E-BUFFER-CONDIVISO.md`; mappa aggiornata nello stesso cambio.

## Quinta ripresa: nome dell’attore negli ordini NPC

Il rapporto corrente è `results/upper-stack-verification.json`: 334
checkpoint 0–333 fino a mercoledì 03:20. Il byte 5D1F deriva dal glifo
del prefisso proprio negli ordini CE13/682A; il tracciato a tick964
mostra la catena reale e C388 frame5D2A. Il confronto completo si ferma
al checkpoint 334 verso 03:30, lettura non posseduta 5D1A. Non pubblicare
le celle intermedie usando soltanto una generica estensione del renderer.
Vedere `NOMI-ORDINI-E-STACK.md`; mappa aggiornata. Nessun nuovo finale
completo è certificato.

## Sesta ripresa: flag del glifo e primo argomento

Rapporto corrente: `results/glyph-flags-verification.json`, 338 checkpoint
(0–337) fino a mercoledì 04:00. Il flag 5D1A proviene dal glifo di pulizia
durante il word wrap dell’annuncio del primo argomento; 5D20/5D21 dal
prefisso del nome negli ordini. Il confronto completo si ferma sullo stato
ALL/BUT A01A al checkpoint 338 verso 04:10. Non sostituirlo con zero o
con lo stato del solo ultimo nodo AST. Vedere `FLAG-GLIFI-E-ANNUNCI.md`.
Mappa aggiornata; il finale 6A33 completo resta non certificato.

## Settima ripresa: ALL/BUT

Rapporto corrente: `results/parser-all-verification.json`. Il modello
supera A01A grazie alle transizioni reali del parser e incontra A020 nello
stesso checkpoint 338 verso mercoledì 04:10. Il prefisso certificato resta
0–337 fino alle 04:00. Ricostruire il costo temporaneo globale A01F/A020,
non usare il costo logico corrente o uno zero osservato come fallback.
Vedere `ALL-BUT-E-CICLO-PARSER.md`, che documenta anche le correzioni dei
record, del conteggio dei fallimenti e le nuove annotazioni della mappa.
Il finale 6A33 completo resta non certificato.


Aggiornamento 29 ottobre 2026: leggere COSTO-TEMPORANEO-E-ATTESE.md e
results/temporary-cost-verification.json. Il costo globale A01F/A020 è
proiettato da reset CC74, intestazioni CA09 prima del corpo, cab 9B07,
controlli B0BD/B0CC, yield CD85/CD8E, byte basso DDC5 e WAIT UNTIL DE42.
Le intestazioni di azioni/oggetti sono dati immutabili estratti; vecchi
salvataggi senza proprietà temporanea non ricevono fallback. Sei sequenze
naturali,32 input/97 checkpoint,302 draw/614 read confrontano anche il costo
a ogni estrazione, tutti gli attori, arena, bitmap e futuro dopo LOAD.
GET OUT dal cab in corsa deve fallire con maschere 80/28, mantenendo gli
argomenti già risolti e il punto finale del messaggio. Suite 775.
Prefisso witness invariato 0–337 fino a Wed04:00; A020 è superato e il
prossimo limite è A11A allo stesso checkpoint 338 verso 04:10. Nessun nuovo
finale certificato. Atlante:153 istruzioni/351 byte, 58 byte prima sconosciuti
ora documentati e 2 byte prima parziali; gli altri sono approfondimenti.


Aggiornamento 29 ottobre 2026, allocatore: leggere ALLOCATORE-E-LINK-PRECEDENTE.md
e results/allocation-link-verification.json. Prefisso witness 0–345 (346 checkpoint)
fino a Wed05:20, tutti gli attori, ogni draw/read, arena, bitmap e futuro dopo LOAD.
Nuovo confine 5D1B al checkpoint 346 verso 05:30: ricostruire il chiamante/ultimo
scrittore dello stack, incluse scritture dello stesso valore; non copiarlo da
una registrazione né dedurlo da 5D1A. Cinque finali ancora senza certificato naturale.
RecordArena.allocationLink conserva A11A/A11B: l’INDIRIZZO DEL LINK PRECEDENTE
al candidato scelto, 9FE3 per la testa o blocco precedente+2. Ogni candidato
migliore o uguale lo aggiorna; release e ricerche senza candidati lo conservano.
La scelta a parità è l’ultima, non la prima. Persiste in JSON; nei vecchi
salvataggi assenti rimane null fino a un’allocazione reale. Non ricavarlo
dalla lista finale e non usare un default 9FE3/zero. Dati controllati: 14 layout,
159 operazioni, 200 scritture con tutti i byte; naturali: 6 sequenze,97 checkpoint,
302 draw/614 read con confronto della word a ogni ingresso casuale. Suite 797.
Atlante: 176 istruzioni/307 byte prima grigi, inclusi 2 byte dati; nuove zone
A11A–A11B,A11C–A15F,A160–A1AE,A1AF–A1C6,A1C7–A20B,A20C–A24C.


Aggiornamento 29 ottobre 2026, byte dei glifi: leggere GLIFI-E-BYTE-DI-SCANSIONE.md
e results/glyph-byte-verification.json. Prefisso witness 0–348 (349 checkpoint)
fino a Wed05:50, tutti gli attori, ogni draw/read, arena, bitmap e futuro dopo LOAD.
Nuovo confine A01B al checkpoint 349 verso 06:00: ricostruirne il ciclo nel parser,
senza zero per WAIT o deduzione dal solo pending del modello. Cinque finali aperti.
5D1B è A dell’ultima scansione C388 solo nel chiamante verificato. Il probe
con store anche invariati identifica C3B8/tick 962/Lestrade/frame 5D26/spazio;
il giardiniere legge quel residuo a tick 2728 (Wed05:27). Il valore è glyph[7],
non il flag F a 5D1A: q può lasciare 6. Con frame 5D24, 5D1B è invece B=1.
La proprietà della coppia AF è preservata solo dal GO TO già verificato;
output non proiettato, scene generiche ed errori la revocano. Old LOAD non inventa byte.
Non estendere il contratto ai byte 5D1C–5D1E o a tutti i chiamanti del glifo.
ABI 432 casi, 216 espliciti sul nuovo byte; storia naturale 76 comandi fino a
Wed05:30 e lettura del giardiniere verificata per valore/tick/attore. Suite 800.
Atlante: 119 istruzioni/179 byte approfonditi; nessun nuovo byte grigio. Zone
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 e annotazione dello stack dinamico.


Aggiornamento 29 ottobre 2026, chiarimenti: leggere CHIARIMENTI-E-OFFSET-DEL-PARSER.md
e results/clarification-offset-verification.json. Witness invariato 0–348/349 checkpoint
fino a Wed05:50: A01B superato, prossimo limite A021 allo stesso checkpoint 349 verso 06:00.
Ricostruire la classificazione temporanea degli argomenti e la sua persistenza;
nessuno zero di default da successo, WAIT o costo. Cinque finali ancora aperti.
A01B è un offset fisico 08/12, non pending booleano/puntatore: boot A044=0,
B5B6 prima della domanda, D793 dopo il ritorno principale anche su errore.
Lexical errors e @ con domanda non lo azzerano; una risposta vuota o SAVE
può azzerare e porre di nuovo la domanda. Citazioni non aggiungono quel reset.
La vista semantica può riordinare i complementi, ma pending e risposta conservano
il nodo e lo slot fisico sorgente. Con PUT ON YOUR ARMCHAIR il referente richiesto
è nello slot 12. Il preflight C79A della classe 9 include oggetti tenuti da un altro
NPC, pur rifiutati in esecuzione: TAKE iniziale ha lampada 22 e giornale 25;
con un solo candidato si sceglie, non si chiede sempre WHAT. Mantenere peso,
percezione e altri controlli rigidi, e distinguere DCA2/DCA7 (possesso/ciclo)
dalla restrizione morbida. Rifiuti GET/CARRY/TAKE usano il verbo corretto.
GIVE richiede seconda scelta unica e ricerca descrittiva sul fallimento;
PAY ambiguo è DON'T BE SILLY, non una domanda. I finali prevalgono sulla domanda.
54 sequenze/156 input/182 store; 19 confronti completi (15 naturali, 4 controllati),
63 input/203 draw/406 read, arena/bitmap/LOAD. Suite 874. Atlante 197 istruzioni/454 byte:
51 byte prima grigi B5FC–B62E e A01B prima parziale; gli altri sono approfondimenti.


Aggiornamento 29 ottobre 2026, controlli argomenti: leggere
CONTROLLI-ARGOMENTI-E-RESIDUO.md e results/argument-check-verification.json.
Witness 0–355, 356 checkpoint sino a Wed07:00; 6.760 draw/14.470 read,
tutti gli attori, arena/bitmap/futuro LOAD. A021 superato; nuovo limite
5D1C al checkpoint 356 verso Wed07:10. Ricostruire chiamante/frame/ultimo
scrittore dello stack, comprese scritture invariate; non estendere il
contratto precedente di 5D1A/5D1B né copiare il valore dalla registrazione.
Cinque finali restano senza certificato naturale. A021 non è un esito globale:
C655=0, C6BA=1; C726 può conservare il vecchio valore sul rifiuto del secondo
ruolo. Nessun reset per successo, tick o costo. Avvio carica il dato0,
verificato sino al prompt con quattro seed; old save assente rimane unknown.
Le ricerche visitano anche candidati rifiutati. Due maschere ordinate,
restrizioni morbide in preflight e handler di fallimento rimangono distinti.
WAIT UNTIL 6D scrive0 e risponde DON'T BE SILLY.; OPEN senza regola applicabile
mantiene la ricerca descrittiva e l’arena. 692 ABI controllati e 10 sequenze
naturali/53 input/63 checkpoint/218 store/203 draw/406 read; ogni store,
A021 a ogni draw e stato completo verificati. Suite 889. Atlante:
414 istruzioni/909 byte, 32 byte prima grigi C571–C590 e A021 prima parziale;
approfonditi C4D1–C582,C583–C627,C628–C6BD,C6BE–C74D,C74E–C7A5,
C7A6–C820,C9BF–C9FA. Riferire sempre qui gli intervalli nuovi/approfonditi.


Aggiornamento 29 ottobre 2026, shift salvato: leggere GLIFI-E-SHIFT-SALVATO.md
 e results/glyph-shift-verification.json. 5D1C superato: C nel frame glifo5D26, shift=(2+7*colonna)&7.
Ultimo writer C3B7/tick962/Lestrade/spazio della pulizia dopo prefisso hansom;
lettura cuoca attore9/tick2826/Wed07:05:7. Non installare7: calcolarlo dal
cursore nel chiamante verificato. Con frame5D24 la stessa cella è un
indirizzo, con5D28 è F. GO TO verificato preserva; stampe sconosciute/scene
ed errori revocano; old LOAD senza cella rimane unknown. Nessuna proprietà
nuova su5D1D/5D1E/5D22. Prossimo limite5D22 è il SECONDO operando della
stessa estrazione; individuare ultimo writer/frame, non indovinare39 da HL.
Prefisso completo invariato0–355/356 checkpoint sino a Wed07:00, stessi
6.760 draw/14.470 read, attori/arena/bitmap/futuro LOAD. Il probe naturale
76 comandi arriva07:20 ma il modello confronta il primo operando e resta
fermato dal secondo: non spacciare07:20 per certificazione completa.
ABI432 casi,324 espliciti sul nuovo byte e108 frame che non lo raggiungono;
8 shift, proprietà/SAVE/LOAD e lettura naturale verificati. Suite892.
Atlante119 istruzioni/179 byte approfonditi, nessun nuovo byte grigio:
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 più annotazione workspace5D1C.
Cinque finali ancora aperti. Riportare sempre gli intervalli aggiornati in chat.


Aggiornamento 29 ottobre 2026, indirizzo video salvato: leggere
GLIFI-E-INDIRIZZO-VIDEO-SALVATO.md e results/glyph-address-verification.json.
5D22 è L salvato da C38B/C398 soltanto nel chiamante con frame5D2A del
prefisso letterale del nome dell’attore in682A. Calcolare
(5020+floor((2+7*colonna)/8))&FF; non installare39, né dedurlo da5D1C.
Il percorso è CE13 ->682A ->6804 ->67F7 ->nome attore/D3E8. Le altre
profondità conservano F/C/E del chiamante o F/C della scansione; tutti
sei i ruoli sono verificati in648 casi ABI, tre glifi e36 colonne.
Proprietà esplicita del chiamante; output sconosciuto, scene ed errori
revocano; old LOAD senza byte rimane unknown.5D23–5D27 sono osservati
nel probe per distinguere i writer, ma non ricevono nuovi valori runtime.
Il prefisso è ora0–358/359 checkpoint sino a Wed07:30, con6.834 draw e
14.644 read confrontati, tutti gli attori, arena/bitmap/futuro LOAD.
Nuovo limite A01C al checkpoint359 verso Wed07:40: ricostruire gli store
D800/B1EC/B1FD e relativi chiamanti; non inferire dal solo ALL o pending.
La prova precedente di5D1C ora esige assenza di not_translated fino al
proprio checkpoint finale07:20: il blocco su5D22 non è più accettato.
Suite complessiva895 test. Cinque finali rimangono aperti.
Atlante221 istruzioni/393 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C388–C3E3,
CE10–CE17,D3E8–D447 e annotazione workspace5D22. Riferire gli intervalli in chat.


Aggiornamento 29 ottobre 2026, modo semantico: leggere
MODALITA-ALL-E-CONTINUAZIONE-SEMANTICA.md e results/resolution-mode-verification.json.
A01C è0/128, distinto da A01A0/1/2 e A01B08/12. I quattro writer sono
D800 (D6B8 del giocatore), B959 (record richiesta+2), B1EC (bit ALL soltanto
se modo0 e modello trovato), B1FD (flag selezione singola CLIMB INTO/HAIL).
A041 azzera D6B8 all’avvio; A01C usa soltanto il dato iniziale caricato,
verificato con quattro seed. Old save senza campo resta unknown: nessun
fallback da ALL, pending, successo o costo. D81B conserva il modo prima dei
turni NPC; D85C azzera D6B8 ma non A01C. Fine ALL può lasciare128/0.
Le richieste prefabbricate e le affermazioni non attraversano B959.
Fine ALL NPC: B9B4/B9CA liberano quel nodo e B9C7 continua sul suffisso;
non cancellare gli altri comandi della richiesta. Reset del cursore privato
prima del nuovo nodo. CLIMB INTO ALL/HAIL ALL non iterano più azioni.
60 sequenze naturali/180 input/375 store/679 draw/1358 read, tutti i24 attori,
arena752 byte, bitmap/cursore, fatti e futuro LOAD. Errori del bridge possono
avere chunk diversi: il confronto del canale inferiore è nei byte originali,
non una normalizzazione dei messaggi. Test dedicato OPEN ALL AND CLOSE ALL
rivolto a Watson e seguito da I ripetuti. Suite complessiva956 test.
Prefisso invariato0–358/359 checkpoint sino a Wed07:30, 6.834 draw/14.644 read.
A01C superato; secondo ingresso sconosciuto A022 al checkpoint359 verso07:40.
Ricostruire ultimo writer e persistenza; non installare il97 della traccia.
Cinque finali ancora aperti. Atlante213 istruzioni/518 byte: A01C passa da
parziale a documentato, nessun nuovo byte grigio. Approfonditi D6B8,A040–A047,
82B1–82B8,8349–8350,B1DD–B258,B280–B2B6,B39C–B3AF,B936–B98B,
B9AC–B9F9,D7FC–D87C. Riferire sempre gli intervalli aggiornati in chat.
