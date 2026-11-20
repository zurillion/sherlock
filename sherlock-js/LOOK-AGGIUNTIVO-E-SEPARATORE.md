# LOOK aggiuntivo: separatore del nome e notifiche di Tricia

20 novembre 2026.

Aggiornamento successivo: il contratto WEAR supera anche $5D1E–$5D1F.
La variante coincide ora fino alle 08:49 di mercoledì su 2.664 checkpoint.
[Nuova analisi e prossimo limite](SCANSIONI-LOOK-WEAR.md).

Questa fase ha verificato la variante con un LOOK prima del primo
HAIL CAB su **2.218 checkpoint**, fino a mercoledì alle **01:23**.
Il precedente limite era martedì alle 20:18, alla lettura di $5D1C.
Il checkpoint allora escluso era mercoledì alle **01:24**: la cuoca
legge $5D1E, ora ricostruito nel dossier successivo.

Il profilo usa seed 1, tutti i 24 attori, grafica nativa dall’avvio,
LOOK iniziale gratuito e nessun teletrasporto. Le 5.898 estrazioni e
12.466 letture del prefisso coincidono, come bitmap e attributi superiori,
contatore MORE, modalità della finestra, orologio, stanza e stato del
comando. Non è una prova per tutti gli input o per l’intero gioco.

## Ultimo scrittore di $5D1C

Il LOOK di martedì alle 13:30, a **Portman Street** (045), termina
elencando Watson e il giornale che porta. Lo spazio fra «daily» e
«chronicle» entra nel renderer $C388 con frame $5D26 e descrittore
$51AB. Il cursore è alla colonna 18. Al tick 1770, $C39C salva BC
con C=0 in $5D1C e B=1 in $5D1D.

Lo shift si calcola da `(2 + 7 * colonna) & 7`; qui è zero. B è il
conteggio residuo dell’ottava scansione del glifo, distinto dalla
lunghezza della parola fornita dal chiamante. Per gli shift non nulli
$C3B7 ripete il salvataggio. Il motore calcola entrambi i byte dal
formatter e dalla geometria, senza leggere la registrazione originale.
Il nuovo contratto non attribuisce automaticamente AF ai byte $5D1A–$5D1B.

Il giardiniere legge ancora C=0 al tick 2178, durante il minuto che
termina alle 20:18. Il probe osserva i PUSH/CALL originali, comprese
le scritture che ripetono lo stesso valore; conserva il writer al
momento della lettura. Il dossier precedente indicava erroneamente
Parliament Street: la stanza 045 è Portman Street.

## Perché il modello perdeva quel byte

Dopo il LOOK, Tricia apre la porta dall’interno, entra nella strada,
richiude e va a sud. Le quattro stampe hanno chiamanti distinti:

| Tick | Stampa | Ingresso | Frame d’ingresso | Frame iniziale del qualificatore/verbo | Minimo SP osservato nel minuto |
| ---: | --- | --- | --- | --- | --- |
| 1805 | Someone opens tricias front door. | CA76, attore FF | 5D6A | 5D2A, «opens» | 5D1E |
| 1806 | Tricia Fender enters. | CBC2 | 5D6A | 5D2C, «Tricia» | 5D20 |
| 1808 | Tricia Fender closes tricias front door. | CA76 | 5D6C | 5D2E, «Tricia» | 5D20 |
| 1809 | Tricia Fender goes south. | CA76 | 5D68 | 5D2A, «Tricia» | 5D1E |

Questi percorsi non raggiungono $5D1C. Il modello lo rendeva invece
sconosciuto alla prima notifica anonima, perché quel chiamante non
aveva ancora un contratto di conservazione.

La conservazione è ora condizionata al normale chiamante dell’azione,
finestra larga, riga nuova, buffer vuoto, nomi corrispondenti al
dizionario e spazio sufficiente prima del MORE. Per le porte la
forma verificata ha nome proprio con due qualificatori; per l’attore
visibile e l’arrivo, nome proprio di due parole. Le richieste isolate,
le altre geometrie e i chiamanti sconosciuti restano conservativi.
Il movimento usa il formatter del qualificatore già ricostruito per
Lestrade, ora verificato anche per Tricia. Non preserva per analogia
tutti i byte vicini: i suoi frame aggiornano separatamente $5D1E e oltre.

## Prove e Salva/Carica

I quattro ingressi originali sono archiviati per ripetere prove
controllate, fuori dal motore giocabile. I 200 casi comprendono tutte
le 36 colonne con contatore zero e la prima colonna con contatori
0–14. Tutti i 60 casi su riga nuova conservano $5D1A–$5D1D; alcuni
casi su riga parziale li sovrascrivono. Il contratto runtime è più
ristretto di questo insieme. Gli snapshot modificati per questi test
non sono presentati come partite raggiunte naturalmente.

Il confronto della storia riparte dall’accensione e include un
Salva/Carica JSON nuovo dopo il LOOK delle 13:30 (checkpoint 1488).
Le successive 729 risposte e gli stati completi delle due sessioni
coincidono fino al limite dichiarato, oltre al confronto con l’originale.
Un vecchio salvataggio privo del byte resta privo del byte: non si
ricostruisce il suo valore dall’ora o dal seed.

[Rapporto del percorso](results/victory-route/native-extra-look-verification.json) ·
[Writer e lettura](results/extra-look-carried-scan/stack-writers.json) ·
[Frame osservati](results/extra-look-carried-scan/announcements-native.json) ·
[ABI controllata](results/extra-look-carried-scan/announcement-abi.json) ·
[Disassemblato commentato](results/extra-look-carried-scan/carried-separator.asm).

Per ripetere le verifiche da `sherlock-js`:

~~~sh
node --test test/extra-look-carried-scan.test.mjs
node --test --test-name-pattern='An extra LOOK' test/native-picture-window.test.mjs
python3 tools/probe-extra-look-announcements.py
python3 tools/probe-extra-look-carried-writer.py
python3 tools/build-extra-look-carried-listing.py
python3 tools/build-memory-map.py
~~~

Il probe del writer rigioca la storia originale completa fino alla
lettura e può richiedere diversi minuti. Un percorso opzionale come
primo argomento conserva checkpoint di ricerca; non è usato dalla pagina.

## Mappa aggiornata

- **$CAAF–$CAEF:** 65 byte prima grigi ora documentati. Esclusione degli
  attori giocabili, confronto della stanza precedente, arrivo nella stanza
  dell’osservatore, filtro della classe dell’argomento e ricerca della
  porta condivisa. Il successivo ramo CAF0/CB01 resta necessario per
  decidere se annunciare l’azione anonima.
- **$C388–$C3E3:** approfondito il ruolo di C39C/C3B7 nel separatore
  dell’ultimo oggetto portato; shift e conteggio hanno proprietà distinte.
- **$CA76–$CA7E, $CAF0–$CB11 e $CBC2–$CC0A:** approfonditi i chiamanti
  delle notifiche e i loro diversi frame.
- Nel workspace opzionale, **$5D1C–$5D1D** espone il nuovo ruolo del
  separatore. Il prossimo $5D1E resta esplicitamente aperto.

I 186 comandi del nuovo estratto, 322 byte, sono verificati contro il
payload e riassemblati. La mappa contiene ora **40.029 byte documentati,
305 parziali e 1.266 sconosciuti**, su 41.600 byte del payload.
