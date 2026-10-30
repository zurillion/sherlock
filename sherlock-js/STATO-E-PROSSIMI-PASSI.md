# Stato del gameplay e ordine di completamento

27 ottobre 2026. Inventario del motore JavaScript autonomo `world-v5`, dopo
il completamento delle regole degli oggetti e delle identità. I documenti delle
fasi precedenti conservano risultati storici: il cab e gli itinerari di Lestrade
sono già collegati, non vanno considerati interamente mancanti.

## 1. Oggetti, contenitori, indizi e identità

**Primo passaggio completato:** regola ordinaria di collocazione, `PUT … ON …`,
`TAKE … FROM …` e `TAKE … OUT OF …`, anche negli ordini a Watson; ingombro,
risoluzione congiunta degli argomenti, errori e relativo stato sorgente.
Vedere [OGGETTI-E-CONTENITORI.md](OGGETTI-E-CONTENITORI.md).

**Secondo passaggio completato:** identità 0/1/100 e travestimenti WEAR/TAKE
OFF; nota che brucia e sue fasi; casseforti e finali locali; cassetto/falso
fondo, rifiuti, libreria, ruscello e tabella degli esami approfonditi.
Sono conservati i rifiuti originali di LOCK/UNLOCK: nel database di questa
versione non ci sono regole operative per queste azioni.

Peso ricorsivo a otto bit, barriere di contenimento e luce sono confrontati
in 3.264 casi controllati, oltre ai 94 di ingombro del primo passaggio.
La verifica include gli ordini differiti a Watson, il cambio d'identità
nello scheduler e nei contesti, e la ripresa dei nuovi stati da salvataggio.
Vedere [IDENTITA-E-INDIZI.md](IDENTITA-E-INDIZI.md) e
`results/special-objects-verification.json`.

Questo chiude l'implementazione funzionale del punto 1. L'estensione delle
prove a ogni combinazione, seed e temporizzazione rimane il punto 7;
le reazioni dipendenti da informazioni, accuse e identità nei rami ancora
mancanti restano ai punti 2, 3 e 5.

**Prossimo intervento consigliato:** punto 7, ampliare le prove di partita
completa e le dipendenze casuali ancora sconosciute. I nuclei dei punti 2–6
sono implementati; i confini restano dichiarati nei rispettivi rapporti.

## 2. Informazioni e deduzioni

La cronologia reale del blocco di Basil è ora confrontata con l’originale
per 115 comandi. Correzioni di ingombro, ALL, stampa e dipendenze casuali,
con salvataggio ricostruito alle 11:54:
[CRONOLOGIA-BASIL-UTENTE.md](CRONOLOGIA-BASIL-UTENTE.md).

Corretto il blocco tecnico dopo l’alibi di Basil: terminatore della tabella
dei fatti e intestazioni del programma del giocatore ora esportati. Prova
controllata di continuazione e caricamento in
[BASIL-E-CONFINE-DEI-FATTI.md](BASIL-E-CONFINE-DEI-FATTI.md). Questo non
esegue ancora le deduzioni descritte sotto.

**Nucleo implementato:** affermazioni SAY a Watson e Lestrade, memoria delle
triple e riuso dei record, collegamenti e richiami di Watson, valutazione
degli undici alberi delle prove, richieste di prova di Lestrade e conseguenze
delle conclusioni. Sono confrontati anche i colloqui dopo i 98 comandi
naturali forniti dall’utente e il seguito da salvataggio. Vedere
[INFORMAZIONI-E-DEDUZIONI.md](INFORMAZIONI-E-DEDUZIONI.md).

Le citazioni miste ordini/affermazioni restano al punto 4; le fasi successive
del caso al punto 5. L’estensione a ogni seed e ai campi temporanei del
renderer non ancora posseduti resta al punto 7. Le normali interrogazioni
TELL mantengono la propria tabella distinta dalle affermazioni.

## 3. Rami avanzati degli NPC

**Implementati i corpi ancora mancanti delle regole referenziate dai programmi
NPC**, le tre callback serali, i rami di Basil dipendenti dalle identità,
le reazioni del maggiore/Straker/poliziotto e i viaggi della polizia. Collegati
i finali raggiunti da questi programmi e l'arresto dello scheduler anche
durante WAIT UNTIL. Vedere [NPC-AVANZATI.md](NPC-AVANZATI.md) e
`results/advanced-npcs-verification.json`.

La lunga attesa naturale con tutti gli attori è confrontata fino all'esito
originale delle 14:58. I percorsi impostati di sera, con altre identità o
altri stati delle prove sono test controllati: non certificano una partita
intera. Rimangono al punto 7 gli ingressi casuali non ancora ricostruiti,
compresi alcuni frame temporanei D187 dopo l'arrivo in un veicolo dal nome
composto. Il protocollo RETURN di avvio è ora esplicitamente modellato.

## 4. Forme complesse del linguaggio

Implementati coordinazioni e durata dei nodi, risposte multiple ai chiarimenti,
ALL nei due ruoli semantici e negli ordini NPC, esclusioni con le anomalie
originali, code di citazioni lette dai token vivi, modo finale delle richieste,
pronomi/affermazioni in contesto, ripetizione @, lettore numerico con cursore
e contatore dell'editor. Vedere [LINGUAGGIO-COMPLESSO.md](LINGUAGGIO-COMPLESSO.md)
e `results/language-verification.json`.

Sono confrontate integralmente 58 storie naturali con tutti gli attori. Tre
storie di corruzione dei buffer rimangono fuori dalla parità: due ripristinano
il terminatore della riga attraverso una citazione residua, una sovrappone
editor e token. La pagina le annulla esplicitamente, conservando lo stato;
non produce una risposta inventata del gioco. Questi confini della scansione
oltre memoria restano aperti nel punto 7. Il formato grammaticale e la
certificazione di qualsiasi flusso di byte non sono la stessa cosa.

## 5. Conseguenze dell'indagine e fine partita

**Implementato il percorso funzionale dei nove testi terminali**, con accuse
attraverso le affermazioni, conseguenze delle prove, rifiuto originale di KILL,
vittoria, morte e sconfitte. Il fine partita interrompe anche oggetti, ALL e
turni ceduti dai rifiuti; conserva stato e continuazioni in Salva/Carica.
La pagina attende un tasto prima della cancellazione finale. Vedere
[CONCLUSIONE-INDAGINE.md](CONCLUSIONE-INDAGINE.md) e
`results/endings-verification.json`.

Le prove controllate dei finali non sono una soluzione naturale completa.
Il seguito lungo delle accuse conserva il confine esplicito del renderer
5D06 dopo le 08:30 nel caso 22; la scansione e la proprietà dei campi mancanti
restano al punto 7. Non è dichiarata equivalenza di qualsiasi partita.

## 6. Comandi, trasporti e calendario ai limiti

**Nucleo implementato e confrontato:** FOLLOW/COME WITH del giocatore,
ENTER/GO INTO adiacenti, LOOK THROUGH, PAY senza TO e relativi rifiuti.
GO TO/GO FURIOUSLY TO/TAKE … TO conservano l'assenza di regole operative
per Holmes in questa edizione, senza inventare un percorso globale.

Collegati PAUSE, PRINT/NOPRINT con carta virtuale SVG, SAVE/LOAD al prompt
e QUIT. Nastro e riavvio sono adattatori dichiarati della pagina, non
emulazione delle periferiche originali. Confrontati mezzogiorno, mezzanotte,
giorno 255/0 e scadenze/tick a 16 bit, conservando il confronto senza segno.

38 storie native, 124 comandi/checkpoint e 645 estrazioni casuali, con tutti
gli attori attivi e setup di calendario/periferiche espliciti. Vedere
[COMANDI-E-CALENDARIO.md](COMANDI-E-CALENDARIO.md) e
`results/command-limits-verification.json`.

WAIT UNTIL singola è incrementale e interrompibile. Attese in righe composte
e vecchi profili conservano il precedente percorso a frame; lunghe permanenze
su ogni mezzo e ogni seed richiedono l'estensione delle prove del punto 7.

## 7. Equivalenza della partita completa

**Primo passaggio naturale verificato:** attesa a Baker Street fino al finale
693A (lunedì 14:58) e viaggio reale fino alla presentazione a Straker, seguito
soltanto da attese fino all'arresto/sparatoria e rapporto 6A26 (martedì 01:03).
Seed 1 e protocollo dichiarati; nessuna impostazione artificiale di prove,
programmi o posizioni. 187 checkpoint, 3.603 estrazioni e futuro dopo LOAD.
Vedere [FINALI-NATURALI.md](FINALI-NATURALI.md). I due finali di sconfitta non
sono ancora una soluzione dell'indagine né una certificazione degli altri seed.


Estendere i confronti a più seed, ordini delle azioni e partite lunghe;
completare le dipendenze della casualità, incluse immagini native e diverse
temporizzazioni dell'input. Per ogni nuova dipendenza, confrontare le letture
e il successore casuale prima delle sole frasi. I salvataggi conservano il
futuro dello stato ricostruito: un vecchio salvataggio privo di una dipendenza
nuova non la riceve per supposizione.

Il motore rimane una ricostruzione parziale: le prove locali dichiarate non
certificano ancora equivalenza dell'intero gioco o di tutti i seed.

Correzione porte lontane: vedere [PORTE-E-NOTIFICHE.md](PORTE-E-NOTIFICHE.md). Il filtro CB01/D471 ora impedisce notifiche di porte condivise tra edifici diversi; rimangono le notifiche dalle stanze realmente adiacenti.


Aggiornamento 27 ottobre: vedere [ALTRI-FINALI.md](ALTRI-FINALI.md) e
`results/other-endings-verification.json`. Confrontati due percorsi naturali
fino alla cassaforte (stesso finale 759C); corretti la ricerca delle premesse
annidate e il rifiuto originale degli ordini di movimento a Basil impegnato.
Le altre sei varianti terminali restano da certificare con storie naturali.

## Verifica successiva dei finali e delle confessioni

Il finale 69BF dell’arresto in presenza di Holmes passa ora una storia
naturale completa (171 checkpoint, 2.464 estrazioni). Ricostruiti inoltre
i programmi TELL di Tricia/Mrs Jones, il cambio d’identità NPC e il valore
probatorio del suo racconto, con prove controllate e ripresa da LOAD.
Dettagli e confini in [FINALI-E-CONFESSIONI.md](FINALI-E-CONFESSIONI.md).
I testi certificati naturalmente sono quattro; cinque rimangono da verificare.

Il confronto esteso del ramo che scagiona Ffoulkes registra nell’originale
6A33 giovedì 10:00, ma trova la prima differenza JavaScript già lunedì
08:57 (record liberato 97B5, richiesta con due affermazioni AND).
Riproduttore e limiti sono in `results/final-solution/RESEARCH.md`.

## Ripresa 28 ottobre: parser, fase regole e atlante sincronizzato

Vedere `PARSER-E-FASE-REGOLE.md` e `RIPRESA-GAMEPLAY.md`.
Il ramo naturale major-witness ora coincide sui checkpoint 0–205, fino a
martedì 06:40; il confine successivo è 5D13 al checkpoint 206, non il vecchio
97B5 o 5D12. Nessun nuovo finale completo è dichiarato certificato.
L’atlante è stato rigenerato con le nuove analisi commentate e da ora va
aggiornato a ogni nuova scoperta del sorgente o delle strutture dati.

## Seconda ripresa 28 ottobre: residui e conversazioni fuori scena

`INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md` documenta renderer, argomenti,
enumeratori, stato lessicale, TELL fuori scena e inizializzazione ROM dei
canali riutilizzati dal buffer. Suite completa: **681 test passati**.
Il nuovo confronto naturale coincide su 247 checkpoint fino a martedì
13:10. Il prossimo confine è A012, contatore del parser, al checkpoint
247 diretto a 13:20. Nessun nuovo testo terminale è ancora certificato.
La mappa è rigenerata con 402 istruzioni e 744 byte annotati del payload,
più la provenienza ROM verificata separatamente e fuori dalla mappa.

## Terza ripresa 28 ottobre: contatori e stato delle deduzioni

Vedere `CONTATORI-PARSER-E-DEDUZIONI.md`. A012 deriva ora dal percorso
del parser, A019 dal renderer, D714 dall’editor e BA1C–BA1F dalla verifica
delle affermazioni di Lestrade. Suite: **712 test passati**. Il prefisso
naturale coincide sui checkpoint 0–322, fino a mercoledì 01:30.
Il nuovo confine è 5C1F al checkpoint 323 verso 01:40. Ricostruire
inizializzazione ROM e scritture lessicali, senza byte catturati come fallback.
Atlante aggiornato con il dossier commentato e riassellato (304 istruzioni,
705 byte). Restano cinque testi terminali senza certificato naturale completo.

## Quarta ripresa 28 ottobre: buffer lessicale e coda degli stream

Vedere `LEXER-E-BUFFER-CONDIVISO.md`. Ricostruite inizializzazione fredda
della coda degli stream ROM e copie lessicali del corpo delle parole,
anche su errore e @; protetti LOAD e analisi preventive. **719 test passati**.
Il prefisso resta 323 checkpoint fino a mercoledì 01:30: la continuazione
supera 5C1F ma si ferma sulla successiva lettura 5D1F. Ricostruire i suoi
frame temporanei, non aggiungere lo zero osservato. Mappa aggiornata con
173 istruzioni / 286 byte annotati, più la provenienza ROM separata.
Nessun nuovo finale completo certificato.

## Quinta ripresa 28 ottobre: nomi negli ordini e 5D1F

Vedere `NOMI-ORDINI-E-STACK.md`. Ricostruito il frame effettivo del prefisso
del nome proprio negli ordini NPC, con invalidazione dei percorsi ancora
non posseduti. Suite: **722 test passati**. Il prefisso naturale cresce
a 334 checkpoint (0–333), fino a mercoledì 03:20; la continuazione si
ferma su 5D1A al checkpoint 334, diretto a 03:30. Mappa aggiornata con
221 istruzioni/393 byte annotati e 92 byte unici prima non classificati.
Le cinque varianti terminali ancora aperte restano da certificare.

## Sesta ripresa 28 ottobre: flag del glifo e annunci degli argomenti

Vedere `FLAG-GLIFI-E-ANNUNCI.md`. Ricostruiti 5D1A dal word wrap del
prefisso qualificato del primo argomento e 5D20/5D21 dal prefisso degli
ordini. Il tracciato vede anche gli store identici ed EX (SP),HL.
Suite: **725 test passati**. Prefisso naturale: checkpoint 0–337 fino a
mercoledì 04:00; nuovo confine A01A al checkpoint 338 verso 04:10.
Mappa aggiornata con 251 istruzioni/446 byte annotati, 193 nuovi byte
unici classificati. Cinque varianti terminali ancora da certificare.

## Settima ripresa: ciclo di ALL/BUT e nodi sintattici

Vedere `ALL-BUT-E-CICLO-PARSER.md`. Ricostruito A01A dalle scritture
del parser; corretti eredità dei nodi falliti, slot dopo BUT, tentativo
fallito alla fine di ALL e reset superfluo dopo SAVE. Suite: **768 test
passati**. Il prefisso resta checkpoint 0–337 fino a mercoledì 04:00;
la continuazione supera A01A e si ferma sul costo temporaneo A020, nello
stesso checkpoint 338 verso 04:10. Mappa aggiornata con 166 istruzioni/368
byte annotati; gli intervalli sono elencati nel dossier e nella risposta
all’utente. Nessun nuovo finale completo certificato.


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
