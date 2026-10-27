# Due sconfitte naturali: inattività e arresto del maggiore

27 ottobre 2026. Primo passaggio del punto 7, JavaScript autonomo `world-v5`.
Questa volta i percorsi partono dall'avvio e non impostano artificialmente
posizioni, prove, programmi o scadenze. L'originale è soltanto l'oracolo offline.

## Restare a Baker Street non porta necessariamente alla scena dell'arresto

Con seed 1, avvio gratuito alle 08:00 e il protocollo sotto, basta:

```text
WAIT UNTIL 11PM
```

Il gioco termina **lunedì alle 14:58**, prima dell'orario richiesto, col testo
693A che comincia «I do not think you are doing too well». Non è un errore del
prototipo né il racconto dell'arresto: il controllo precedente lo interrompe.

Lestrade raggiunge il nodo DOMAIN E932, che chiama il controllo 9E6A.
Il corpo 9E6C legge il flag 9D90: se è zero, stampa 693A e passa direttamente
al fine partita comune 9E74. Il programma non raggiunge ancora E96B.
Non esiste un nuovo timer del modello che dica «alle 14:58 perdi».
Questo è l'orario in cui Lestrade arriva al controllo nella sequenza verificata.

## Dopo la presentazione a Straker l'indagine continua

Il flag non significa semplicemente «ho detto HELLO a Straker». Il callback
iniziale di Lestrade, 9DFF–9E47, controlla la compresenza con **Straker e
Holmes**; imposta 9D90, apre gli accessi delle proprietà e cambia il callback
di Lestrade. Nel percorso fornito dall'utente accade alle 10:34, arrivando
alla stazione di Leatherhead; il saluto a Straker termina alle 10:35.

La nuova prova ripete i primi 49 comandi della cronologia reale fino a quel
saluto, senza ulteriori indagini, poi esegue:

```text
WAIT UNTIL 11PM
WAIT UNTIL 7AM
```

Alle **14:56** Lestrade supera il controllo 9E6C, perché 9D90 è impostato.
Alle 23:00 la partita non è ancora terminata. Il programma passa attraverso
le attese di segnale e gli spostamenti di Lestrade e del maggiore; il ramo
notturno di Ffoulkes inizia con il controllo dell'ora 23 in F0A4, poi invia
un segnale a Lestrade. Questi non salta direttamente alla conclusione:
E93D/E943/E94D ed E955/E95B includono attese, incontro con Holmes e controllo
dell'ora 1. Il controllo F1D6 confronta l'ora codificata (1 è l'una di notte).

Il controllo E96B → 9E85 arriva in questa storia **martedì alle 01:03**.
Il byte modificabile 9E88 indica che il caso non è pronto. Il corpo 9E87
seleziona 6975, il racconto del tentativo d'arresto e della sparatoria, e poi
sceglie il rapporto finale in base alla posizione di Holmes rispetto a Lestrade:
69BF se erano già insieme, 6A26 se Lestrade entra per riferire.
Qui viene scelto **6A26**. Non è un arresto riuscito seguito da normale gioco:
è un ramo conclusivo, con sparatoria e rapporto di Lestrade.

Il ricordo di un arresto entro sera può riferirsi a una cronologia diversa:
questi orari non sono scadenze universali. Sono due percorsi e un seed
precisi, ora confrontati fino alla conclusione. Non estendiamo questa prova
a tutti gli altri itinerari o seed.

## Correzioni emerse durante il confronto

- Un'operazione OPEN di Daphne in ED2A può ricevere come argomento Daphne
  stessa. Senza regola locale né generale, C929–C987 restituisce fallimento:
  non deve bloccare il motore con «regola speciale open non ricostruita».
- Ricostruito il workspace nominale AAA8–AAB1 dalle scritture del parser.
  AB4C–AB5E tenta un altro gruppo anche dopo quello completo: AC24 azzera
  il workspace prima di riconoscere il delimitatore. Non basta conservarvi
  l'ultimo gruppo dell'AST. Le analisi speculative per riconoscere WAIT
  non devono scrivere questo stato della partita.
- I flag A00B/A00C e CC0B/CC0D dipendono da verifica/esecuzione della regola,
  modo dell'annuncio, fallimenti del turno e richiesta pendente. Ora vengono
  proiettati dai passaggi logici che li modificano.
- Il buffer parola a 5C0B conserva i byte dopo lo svuotamento. Il puntatore
  torna all'inizio, ma il contenuto non viene azzerato. Sono conservati
  lettere grezze, suffissi maiuscoli e backspace prima della formattazione.
- Anche fuori scena i numeri di A419 e alcuni caratteri letterali aggiornano
  quel buffer, mentre il dizionario può essere soppresso. Alle 16:57 la
  richiesta di pagamento del cocchiere lascia il trattino di `3/-` al terzo
  byte; il generatore lo legge soltanto alle 18:59, nel tratto fino alle 19:00.
  La traccia delle scritture identifica A9D7 come autore del byte: il motore
  ricalcola l'importo, non installa il valore 45 della registrazione.
- Il campo ROM SEED inizialmente nullo, a 5C76, cade nello stesso workspace.
  Nel protocollo di avvio LOAD/USR non viene eseguito RND/RANDOMIZE; questo
  campo è distinto dal seed del gioco A037. È inizializzato soltanto nel nuovo
  avvio e può poi essere sovrascritto dal buffer. Un vecchio salvataggio
  privo del buffer non riceve quel valore per supposizione.

Le copie sintetiche dei nomi e gli altri byte raw non ancora posseduti sono
marcati sconosciuti: un'eventuale lettura futura rimane un confine esplicito.
Non vengono usati zeri generici, snapshot nativi o risposte registrate nel runtime.
I nuovi campi entrano nei salvataggi e nella ripresa del futuro.

## Riproduzione e prove

[Comandi del viaggio e dell'attesa](results/natural-loss/meet-straker-inputs.txt).
Il saluto a Watson, la richiesta di seguirci, il cab, il pagamento e il treno
sono azioni reali, comprese le due forme di TAKE del travestimento nella
cronologia originale. Il testo non richiede teletrasporti o trucchi.

Protocollo: seed 1, tutti i 24 slot attore attivi, LOOK iniziale gratuito,
grafica originale disabilitata dopo l'avvio, input maiuscolo iniettato sopra
lo scanner, MORE e accettazione finale immediati, nessun timeout d'inattività.
Le temporizzazioni fisiche della tastiera e altre preferenze d'avvio non
sono certificate da questa prova.

Sono confrontati 187 checkpoint, 3.603 sorteggi e 7.472 letture: ogni attore,
scadenza, argomento, entità, fatto, tutti i 752 byte dell'arena, editor/token,
bitmap superiori/inferiori e campi temporanei posseduti. I pacchetti effettivi
della sessione web ricostruiscono il medesimo testo sullo schermo. Ogni prompt
può essere salvato; dopo il caricamento, ogni minuto successivo delle attese
viene confrontato anche con la partita JavaScript non interrotta. Il terminale
rimane immutabile rispetto a comandi e teletrasporto.

La prova nella pagina è automatizzata attraverso ClientSession/SpectrumBuffer;
non è dichiarata una prova manuale nel browser di tutte le ore di gioco.
Il tasto d'accettazione finale rimane una prova separata già documentata in
[CONCLUSIONE-INDAGINE.md](CONCLUSIONE-INDAGINE.md).

Rapporto: [results/natural-loss-verification.json](results/natural-loss-verification.json).
Listato originale tipizzato: [results/natural-loss/natural-loss.asm](results/natural-loss/natural-loss.asm).
Le tabelle e le sequenze DOMAIN sono dati, non istruzioni Z80.
