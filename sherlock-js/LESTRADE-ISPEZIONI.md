# Lestrade: spostamenti e interrogatori

25 ottobre 2026. Questa fase corregge gli annunci di movimento, supera il
blocco delle 11:42 della cronologia fornita e collega gli interrogatori nelle
case dei Brown e dei Jones. Il programma di Lestrade non terminava nel giardino:
mancavano dipendenze del motore condiviso.

## Perché mancava «Inspector Lestrade goes …»

Il gioco annuncia l'azione con `$CA3A/$CA76` prima dello spostamento; verifica
poi l'arrivo con `$CAAF/$CBC2`. Il modello selezionava soltanto `enters/leaves`
e filtrava nuovamente il messaggio dopo aver mosso il personaggio: una partenza
visibile diventava così invisibile.

Ora la visibilità della partenza viene valutata prima di modificare il mondo.
Se Holmes vede partire Lestrade, compaiono la direzione oppure il passaggio:
`Inspector Lestrade goes south.` o `… goes through the large oak door.`.
Un personaggio che arriva dall'esterno produce invece `enters.`. Lo stesso
percorso serve gli altri NPC, compreso Straker.

## Il blocco delle 11:42

`$5D02` non è una nuova routine da eseguire. È una cella di lavoro che il
generatore casuale originale può leggere. Il modello ne aveva cancellato la
provenienza a seguito di EXAMINE, anche nei casi in cui la routine originale
non la modifica. L'errore veniva quindi correttamente esposto dal controllo
sulle sorgenti casuali, ma l'invalidazione che lo precedeva era troppo ampia.

Le normali ispezioni `$DF49/$DF5B`, con descrizioni piatte o entro due livelli
di chiamate testuali, restano sopra la finestra bassa posseduta dal renderer
(`$5CEE…$5D0F`). Questi percorsi conservano le celle già ricostruite. Testi
sconosciuti, più profondi o con operazioni non comprese continuano a invalidarle.
Non è stato introdotto un valore di ripiego per gli indirizzi sconosciuti.

Altre sorgenti incontrate nella prosecuzione sono ora rappresentate:

- tabella immutabile di dispatch del parser `$AF6B…$AFB2`;
- stato della stampante opzionale `$A008`, disabilitata all'avvio;
- coordinate dei due canali del testo `$C1F4…$C1FB`, derivate dai cursori;
- descrittori e residui dei glifi, prodotti dalla struttura delle operazioni
  di stampa, compresi gli spazi fra le parole dei nomi e i cambi di riga.

`$C388/$C389` scrivono anche AF e BC. Le celle per cui questi valori non sono
ricostruiti perdono esplicitamente la proprietà: conservare il valore di un
vecchio glifo sarebbe scorretto. Una futura lettura casuale di una cella non
posseduta rimane un errore esplicito.

## Che cosa succede dopo il giardino

Lestrade torna alla porta dei Brown, Straker apre e attraversa la porta,
Lestrade entra e comincia le interviste. Gli ordini interni contengono già due
identificativi risolti: destinatario e argomento. Il modello trasmetteva solo
il primo alla gestione TELL, cercando poi un secondo gruppo nominale inesistente.

Ora questi ordini raggiungono il corpo condiviso `$E1D8…$E229`, la stessa tabella
di risposte usata dal TELL del giocatore. La stampa dell'ordine segue anche
`$A3A9/$A3C8/$A3EF`: «Tell me about what happened.» e «Tell me your alibi.».
Una richiesta immediata eseguita da un NPC non modifica gli argomenti del suo
programma sospeso; una richiesta differita conserva il proprio contesto.

Il seguito verificato comprende Daphne e Basil nella sitting room, il
giardiniere, la cuoca e la domestica in cucina, quindi il sopralluogo nella
casa dei Jones. Sono le sequenze del programma del personaggio, con regole
condivise tradotte funzionalmente: non sono risposte indicizzate per numero
di comando o per ora.

Sono stati corretti anche tre dettagli del motore:

- `I` marca gli oggetti elencati come già mostrati (bit 7 di status), come
  `$D4CC/$D526/$D531`.
- `PAY CABBIE`, senza importo e senza TO, risponde nell'originale
  `DON'T BE SILLY.` senza consumare tempo. La forma con importo resta distinta.
- `$C00C` considera ancora “mattino” l'intera ora 12pm; mezzanotte è invece
  “notte”. Non segue il confine convenzionale del mezzogiorno.

## Incontri e sorgente casuale

`$9CF2` ha due uscite diverse. Quando il contatore impedisce un nuovo incontro,
estrae il proprio indirizzo di ritorno in DE e salta il resto della procedura.
Un incontro nuovo prosegue invece nelle stampe e negli eventuali controlli.
Il DE residuo è un ingresso del successivo sorteggio: non può essere sostituito
da una costante comune a tutti gli incontri.

Watson e Straker ora propagano questo risultato fra i controlli successivi.
Per Lestrade sono distinti i ritorni `$9DCA` e `$9DDB`. Il successo di `$9DD8`
prosegue nei controlli dei fatti `$BC46/$BC9C/$BC74`; se non ci sono fatti
attivati, le scansioni non stampano e `$BE5B` lascia DE=2. La valutazione di
deduzioni attive resta un confine esplicito da ricostruire, non un esito vuoto
inventato.

## Come riprendere la cronologia

Ricaricare la pagina su `http://127.0.0.1:8768/` per caricare i moduli aggiornati.
Usare **Carica partita** e selezionare:

`results/lestrade/sherlock-seed1-1142-restored.json`

Il file viene ricostruito con il solo motore JavaScript da 138 eventi della
cronologia: seed 1, avvio gratuito, porta dei Brown alle 11:42, prima delle tre
`I` annullate. Il diario ne indica l'origine. Non contiene uno snapshot Z80 e
non pretende di conservare lo stato errato del vecchio modello.

Le successive tre `I` avanzano a 11:43, 11:44 e 11:45, mostrando l'apertura
della porta e gli spostamenti di Straker e Lestrade. Il caricamento è stato
provato anche nella pagina web, in una sessione di prova separata.

## Verifica e limiti

I risultati quantitativi e i confini del confronto sono registrati in
`results/lestrade-verification.json`; i test sono in `test/lestrade.test.mjs`.
Il percorso naturale è generato dall'originale con tutti i 24 slot attivi,
seed 1, descrizione iniziale gratuita, grafica disabilitata dopo il primo
prompt, input maiuscolo iniettato senza timeout e MORE immediato.

Il vecchio helper Python del teletrasporto stampa una scena aggiuntiva che
non restituisce al chiamante. La prima lettura casuale della bitmap diversa
si presenta all'evento 121 della cronologia con teletrasporti. Quel suffisso
non viene dichiarato equivalente all'originale. La prosecuzione della stessa
cronologia nel JS è una prova separata di funzionamento e save/load.

Restano da ricostruire le deduzioni attivate, le conseguenze dell'accusa e i
finali, oltre ai percorsi/comandi ancora esplicitamente non supportati. Queste
prove non stabiliscono equivalenza dell'intero gioco, di ogni seed, della
grafica come ingresso casuale o dei tempi della tastiera fisica.
