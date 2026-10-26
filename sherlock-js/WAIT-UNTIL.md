# WAIT UNTIL e interruzione dell’attesa

26 ottobre 2026. Questo passaggio precede le deduzioni, che restano il prossimo
intervento dopo la prova dell’utente.

## Comandi nella pagina

```text
WAIT UNTIL 9:00
WAIT UNTIL 9:00AM
WAIT UNTIL 2:30PM
```

Senza AM/PM viene scelta la prossima occorrenza di quell’ora. Se l’ora richiesta
coincide con quella attuale, la forma senza suffisso attende dodici ore;
con AM/PM esplicito attende fino al giorno successivo. Il calcolo conserva le
particolarità del formato numerico originale, comprese mezzanotte e mezzogiorno.

L’orologio e il mondo avanzano un minuto alla volta. I messaggi e i movimenti
dei personaggi non terminano automaticamente l’attesa. Per fermarla:

- **Invio** interrompe al minuto visualizzato, prima del successivo giro degli attori.
- Il pulsante **Interrompi attesa** offre lo stesso arresto.
- Se è attivo MORE, Invio fa prima scorrere la pagina. Il pulsante può invece
  già richiedere l’arresto e sbloccare il testo; l’attesa termina dopo avere
  mostrato i messaggi di quel minuto.

Una volta tornati al prompt si può impartire un comando e salvare normalmente.
Interrompere prima di salvare, ricaricare la pagina o cambiare motore: uno
stato ancora nel mezzo di WAIT non viene esportato come se fosse un prompt.
La ricostruzione resta parziale: un ramo futuro non ricostruito può ancora
mostrare un avviso, conservando però i minuti già visualizzati.

## Cosa fa l’originale

La regola DDD4–DE6E converte ora attuale e richiesta nel quadrante a dodici ore,
sceglie AM/PM e produce il costo in minuti. Lo scheduler lo somma alla
scadenza precedente dell’attore: non modifica soltanto una stringa di orologio.
Il giocatore conserva azione 50, argomenti `FE FF`, e il programma è sospeso
a `9945`. Il letterale temporale è il valore originale condiviso a `A02F`.

Nel main loop A068–A093 il calendario viene aggiornato e l’orologio mostrato;
se l’azione salvata è WAIT UNTIL, C41F verifica ENTER (`8D`). Solo allora
A08A anticipa la scadenza del giocatore al tick corrente. La stampa non
modifica quella scadenza. MORE sospende la stampa e non equivale a terminare
l’attesa. WAIT UNTIL non stampa «You wait.»; WAIT semplice sì e costa cinque
minuti.

Il listing `results/wait-until/wait-until.asm` separa il codice, i due totali
temporali e il byte AM/PM dall’intestazione della regola. Ogni voce è stata
riassemblata indipendentemente.

## Correzione del motore autonomo

Il precedente supporto calcolava l’intero futuro e poi mostrava fotogrammi
registrati. Un limite molto successivo poteva quindi annullare l’attesa prima
che l’utente avesse la possibilità di interromperla. Ora una WAIT UNTIL
singola nella pagina prepara il comando una volta e sospende lo scheduler a
ogni vero aggiornamento del calendario, prima della scansione degli attori.
Continuare esegue soltanto il minuto successivo. Non vengono ripetuti parsing
e allocazione dei record a ogni minuto e non viene importato uno stato futuro.

L’interruzione conserva NPC, code, denaro, dati del parser e casualità di quel
momento. L’API sincrona del modello raggiunge lo stesso stato finale, ma la
pagina usa il percorso incrementale. I comandi multipli e i profili storici
conservano il proprio percorso precedente e non rientrano nel nuovo certificato
incrementale.

Sono corretti anche il ritorno del lexer dopo AM/PM a fine riga, il tag del
letterale monetario prodotto dagli NPC e il pagamento successivo a un’attesa:
questi campi possono essere letti dalla sorgente casuale condivisa.

## Verifiche

`test/wait-until.test.mjs` confronta 576 calcoli isolati con la routine originale
e cinque sequenze con tutti i 24 slot attori attivi:

1. Attesa fino alle 8:20, compreso il racconto di Watson, e una seconda attesa.
2. Interruzione alle 8:04, comando successivo, salvataggio/caricamento e nuova attesa.
3. Ora obiettivo del giorno successivo, interrotta alle 8:02.
4. Pagamento a Watson dopo un’interruzione, con codifica originale del letterale.
5. Storia reale di 98 comandi fino alle 11:54, poi attesa alle 12:02 con movimenti visibili.

Per ogni confine di minuto si confrontano stato degli attori, PC e scadenze,
entità e denaro, fatti, flag delle stanze, tutti i 752 byte dell’arena, buffer,
bitmap esatte di entrambi i canali, budget dello scrolling e campi posseduti
del renderer. Ogni estrazione casuale è confrontata con tutte le letture e il
successore. I pacchetti realmente usati dalla pagina producono le stesse righe.

Protocollo: seed 1, LOOK iniziale gratuito, grafica originale disattivata dopo
il primo prompt, tasti maiuscoli iniettati, MORE immediato e nessun timeout di
inattività. Questo certifica il corpus, non tutte le partite o temporizzazioni.

La prova in una scheda separata ha verificato il pulsante, MORE, il tasto Invio
in modalità Spectrum e un INVENTORY successivo. Non è stata riavviata la
partita aperta dall’utente. La schermata è in
`results/wait-until/browser-interrupted.png`.

```sh
node --test test/wait-until.test.mjs
node --test test/*.test.mjs
python3 tools/probe-wait-until.py --output test/fixtures/wait-until-reference.json
```

Il terzo comando richiede il progetto originale e SkoolKit solo per la ricerca
offline. La pagina e le prove JS restano autonome. Rapporto:
`results/wait-until-verification.json`.

## Correzione dell’Invio di conferma

L’ascoltatore di interruzione ora opera nella fase di cattura, prima
dell’input Spectrum. Nel browser le microtask avviate dal gestore dell’input
possono già creare il job prima che lo stesso evento raggiunga il gestore
del documento in risalita: l’Invio di conferma veniva quindi riutilizzato
come interruzione al primo minuto. La cattura verifica l’attesa prima
dell’invio del comando. Ignora anche l’autoripetizione del tasto tenuto premuto.
Un nuovo Invio durante l’attesa continua a interromperla; MORE conserva
la precedenza grazie al proprio ascoltatore di cattura registrato prima.

Verifica nel browser, con eventi reali di tastiera in una scheda separata:
prima della correzione `WAIT UNTIL 8:05` da 08:00 terminava a 08:01;
dopo la correzione da 08:01 raggiunge 08:05 senza altri tasti. Una nuova
attesa alle 08:09, interrotta con un secondo Invio, termina a 08:06;
ripetendola senza interruzione raggiunge 08:09. Gli 11 test specifici del
motore restano verdi. Evidenze: `results/wait-until/enter-key-verification.json`
e `results/wait-until/browser-enter-fixed.png`. La precedente verifica del
modello non copriva questa differenza nella propagazione degli eventi browser.
