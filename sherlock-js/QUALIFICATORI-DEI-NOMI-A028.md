# $A028: qualificatori nel formatter dei nomi

31 ottobre 2026. Ricostruito A028 come stato funzionale del testo,
conservato nei salvataggi. Il motore resta JavaScript autonomo; codice
originale ed esecuzioni native sono soltanto strumenti offline di verifica.

## Significato: una tuple nome, due percorsi

D405 formatta una tuple di tre word: sostantivo e due qualificatori.
D410 legge A028 dopo aver impostato articolo/nome proprio: zero considera
i qualificatori, nonzero salta direttamente al sostantivo in D438.
Il risultato può essere «Parliament Street» oppure «Street», «a hansom cab»
oppure «a cab». L’articolo non viene cancellato. Il flag resta impostato
anche quando il nome non ha qualificatori e il testo non cambia.

Questo ingresso viene usato per le locazioni e per nomi passati come
argomenti, anche di entità. Non va interpretato come un ID di stanza.
Il percorso diretto del nome di un’entità, D3E8, non consulta A028:
seleziona i qualificatori tramite i bit del record. Perciò il modo1 non
elimina automaticamente gli aggettivi di ogni oggetto stampato.

## Otto writer, senza ripristino automatico

| Writer | Valore e ruolo |
| --- | --- |
| A37E | 0 prima della composizione dell’azione, anche negli annunci fuori scena. |
| A65E | 0 nel comando testo0, prima del nome passato come argomento. |
| A721 | 0 nel nome del soggetto. |
| A72E | 1 nel nome dell’oggetto corrente. |
| A73D | 1 nel nome dell’altro referente. |
| A798 | 0 per soggetto con copula; 1 per oggetto/argomento con copula. |
| D1D2 | 0 prima del nome della locazione. |
| D536 | 0 per ogni elemento effettivamente elencato; nessun writer con lista vuota. |

Il comando testo4 (A709) stampa invece un descrittore letterale e conserva
il flag. L’estrazione distingueva già i comandi, ma li esportava con lo stesso
nome semantico: il metadato `nameMode: full` ora conserva il writer del
comando0 senza modificare la natura dell’argomento.

Nel comando19, A7B4, il byte alto dell’argomento contiene l’ID dell’entità.
EX AF,AF’ conserva l’ID mentre viene scritto modo1: quel byte alto non è
il nuovo valore di A028. Il token nome-con-copula è ora gestito anche nel
renderer JS, con un argomento semantico dichiarato.

I valori rimangono condivisi tra chiamate: non azzerare il flag all’inizio
di ogni testo. Neppure stampare un nome implica da solo una scrittura:
D658 entra direttamente nel nome del passaggio e conserva A028.

## Collegamento al motore

Il campo corrente è `world.npcs.nameQualifierMode`; il payload iniziale
è esportato come `argumentChecks.initialNameQualifierMode`. Le transizioni
seguono token, composizione degli annunci, movimento, inventario e scene.
È incluso il ramo speciale HAIL degli NPC, che altrimenti lasciava il modo1
del dialogo precedente invece del reset A37E.

I nomi consultati dalla mappa restano funzioni pure. Il nome locazione
stampato dal gioco usa invece il proprio ingresso con reset0; il formatter
foglia può consultare il modo corrente senza riscriverlo.
I SAVE conservano il byte. Un vecchio LOAD senza il campo resta unknown
anche nel lettore casuale; non usa il valore iniziale come fallback.
Soltanto una scrittura compresa ne ristabilisce la proprietà.

## Prove e relativo ambito

- 12 storie naturali brevi, 47 input e 57 checkpoint: 165 store osservati,
  205 draw e 410 read; canale del nome a ogni checkpoint/draw, stato completo,
  entità, fatti, scheduler, arena da752 byte, bitmap esatte e futuro LOAD.
- 16 chiamate controllate originali al formatter con quattro tuple di stanze
  e modi0/1/7/128: testo e persistenza del byte. I modi sintetici diversi da1
  verificano il test nonzero del lettore, non una loro origine naturale.
- 18 chiamate controllate ai token soggetto/oggetto/altro, con e senza copula:
  distinguono i writer e verificano che argomento0300 significhi entità3,
  lasciando modo1. Nessuna patch delle istruzioni o del font originale.
- Nuova traccia naturale continua acquisita sino a mercoledì17:00, senza
  transizioni non classificate. Il modello confronta modo e ogni draw in
  3.281 checkpoint sino alle16:50, prima di C128. È una prova specifica di
  modo/casualità, non una certificazione di ogni stato intermedio: resta il
  controesempio precedente nella riga del giardiniere a Tue14:02.

La prima lettura casuale di A028 è della cuoca9. L’ultimo writer registrato
è A37E, tick3399, giardiniere8, chiamanteA34B, valore0. Deriva quindi dalla
composizione dell’azione e non da una costante globale del formatter.

Il confronto completo del prefisso raggiunge **415 checkpoint0–414,
mercoledì16:50**, con **8.296 draw e17.768 read**, tutti24 i posti attore,
arena completa, bitmap e futuro dopo LOAD. Protocollo seed1, LOOK iniziale
gratuito, grafica originale disabilitata, tasti maiuscoli iniettati e MORE
immediato. Le due estrazioni iniziali non sono incluse nei draw confrontati.

Il prossimo limite è **C128**, checkpoint415 verso mercoledì17:00.
Restano i cinque finali naturali aperti, il limite cab5D0C, PRINT/MORE,
TAKE TO e la riga transitoria del giardiniere già registrati nel backlog.
Nessun campo del confronto completo è stato rimosso per superarli.

Passati49 controlli mirati:48 del blocco nomi/informazioni/mappa/pubblicazione
e la prova continua del modo e delle estrazioni. La suite completa viene
eseguita da GitHub Actions sul commit pubblicato.

## Atlante e ripetibilità

Il listing verifica282 istruzioni e607 byte. Nuove zone prima grigie:
A65E–A678 (27 byte), A709–A71F (23), A793–A7B9 (39).
A028 passa da parziale a documentato. Approfonditi A37D–A418,
A720–A750, A7BA–A7CF, D1C6–D1DA, D3D5–D447, D526–D559 e D60B–D66F.
Totali:38.739 documentati,464 parziali,2.397 grigi su41.600 byte.
La copertura statica non misura l’equivalenza completa della partita.

```
python3 tools/probe-name-qualifier-mode.py
python3 tools/probe-name-qualifier-mode.py --witness
python3 tools/probe-name-qualifier-abi.py
python3 tools/probe-name-mode-entries.py
python3 tools/build-name-qualifier-listing.py
python3 tools/build-memory-map.py
node --test test/name-qualifier-mode.test.mjs test/name-qualifier-witness.test.mjs
node tools/verify-witness-prefix.mjs
```

Prove in results/name-qualifier-mode/; rapporto in
results/name-qualifier-mode-verification.json.
