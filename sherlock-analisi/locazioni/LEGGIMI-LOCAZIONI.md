# Sherlock: locazioni, movimento e descrizione del mondo

**Aggiornamento del prototipo:** il turno del giocatore ora attraversa editor, parser, semantica e azioni Z80 originali, con stato pendente conservato fra input. Le domande e i rifiuti sono stampati dal gioco; YOUR e YOUR DOOR completano OPEN DOOR. Le visite NPC vengono saltate. Vedere `AGGIORNAMENTI-INTERFACCIA.md` per verifiche e modifiche a SVG e mappa.

Analisi del payload ZX Spectrum v2.0 fornito nel progetto. Gli indirizzi sono esadecimali; ID e costi sono decimali. I risultati derivano dai byte originali e da esecuzioni Z80. Foggy London è usato come indizio e, nell'interfaccia, come fonte delle coordinate grafiche dei nodi: la topologia viene estratta dal gioco.

## Che cosa è stato ricostruito

- Indice di 106 slot di locazione, da 0 a 105; lo zero è uno slot nullo. I 105 record con nome comprendono anche interni di mezzi di trasporto, non soltanto stanze ordinarie.
- 206 archi diretti, ciascuno con direzione, entità di passaggio e destinazione. Sette hanno destinazione zero e non sono normali uscite percorribili.
- Movimento direzionale, GO INTO, GO THROUGH e confronto con GO TO nel gioco completo.
- Primo ingresso, ritorno e LOOK; differenze fra descrizione specifica, frase generica, uscite e oggetti.
- Filtro percettivo e attraversamento dei contenitori, con una traduzione Python confrontata con il codice originale.
- Un esploratore HTML/CSS/JavaScript con server Python: input, parser originale, descrizioni, movimenti, porte, orologio e grafo cliccabile.

## Record e grafo

`$D224` legge l'indice di word little-endian a `$840B`. Per ID `i`, il puntatore si trova a `840B + 2*i`. `$D3A9` arresta la ricerca prima di ID `$6A` (106): quello slot punta all'indice delle entità `$8B6F`, non a un'altra stanza.

Ogni locazione ha questa struttura variabile:

| Offset | Byte | Contenuto |
|---|---:|---|
| +0 | 1 | Flag e relazione locativa |
| +1 | 2 | Riferimento lessicale del nome |
| +3 | 2 | Primo qualificatore |
| +5 | 2 | Secondo qualificatore |
| +7 | 2 | Puntatore al testo compresso, oppure zero |
| +9 | 3 × n | Uscite: direzione, ID del passaggio, ID destinazione |
| dopo le uscite | 1 | Terminatore FF |

Nel byte +0, il bit 6 è il flag di visita usato da `$CA9E`; il bit 7 interviene nel test di illuminazione `$D078`. I bit 1–3 selezionano una relazione per la frase generica attraverso `$D05A`: nei record osservati 4 produce IN, 6 ON, 8 AT. Non assegniamo significati ipotetici ai bit rimanenti.

Le direzioni sono: 1 N, 2 S, 3 E, 4 W, 5 NE, 6 NW, 7 SE, 8 SW, 9 UP, 10 DOWN. Le triplette sono **archi diretti**, non coppie automaticamente bidirezionali. Si conservano ordine e direzione di ciascun record; non si inventa un ritorno quando manca.

Esempio, stanza 8 a `$8540`:

```text
84 47 87 F2 09 00 00 62 7D   intestazione, descrizione a 7D62
04 15 07                     W, entità 21 (your door), stanza 7
01 32 09                     N, entità 50 (plain door), stanza 9
FF                           fine
```

Il passaggio zero significa che non c'è un'entità interposta. Un passaggio nonzero può essere una porta, una scala o un personaggio: non va convertito automaticamente in una proprietà booleana «porta» dell'arco.

Le entità dei passaggi sono **condivise**. `plain door`, ID 50, compare in dieci locazioni; il suo record e i flag sono unici. Duplicare lo stato per ciascun arco cambierebbe il modello originale. La mappa del prototipo mostra archi tratteggiati quando esiste un'entità interposta, senza promettere che ogni tratteggio sia una porta chiusa.

Le componenti separate del grafo non sono collegate artificialmente. Viaggi in carrozza e treno, interni dei mezzi e mutazioni del mondo possono fornire spostamenti che non sono una semplice uscita direzionale statica. Questa fase non ricostruisce integralmente quegli itinerari dinamici.

## Come avviene uno spostamento

Le dieci azioni direzionali condividono la regola `$DD03`:

```text
60 20 D2 DC    header: luce richiesta, costo 2, predicato DCD2
DD07          corpo Z80
```

`$DCD2` chiama `$D448` per cercare la direzione fra le triplette della stanza dell'attore. Verifica poi condizioni di contesto, che l'attore non sia contenuto in un'altra entità, che la destinazione non sia zero e che il passaggio sia attraversabile. L'intestazione della regola impone anche il controllo della luce.

`$DD35` ammette direttamente il passaggio zero. Altrimenti consulta l'entità interposta: il campo +05 deve avere almeno uno dei bit `$20/$08` (aperto/rotto nel comportamento osservato), e il suo campo +02 deve essere almeno quello dell'attore. Quest'ultimo è un confronto di capacità/dimensione: non basta che una porta sia aperta per dichiarare qualsiasi passaggio attraversabile. In questa fase non viene certificato il significato fisico di ogni valore del campo.

Se il predicato riesce, `$DD07` prende la destinazione dalla tripletta e `$DD0B` aggiorna la posizione +0F dell'attore. `$D249` propaga la nuova locazione ai discendenti nell'albero del contenimento. Il denaro portato da Holmes, per esempio, si sposta con lui.

Dopo il corpo della regola, `$CA7F` confronta la posizione di Holmes con quella precedente in `$A009`. Se è cambiata, `$CA9E` stampa la scena d'arrivo. Il flag di visita viene consultato e aggiornato lì, non nel semplice assegnamento della posizione.

### Le diverse forme del comando

- **WEST / GO WEST**: azione direzionale, regola `$DD03`, costo 2.
- **GO INTO HALL**: `$DD52` contiene un'intestazione e una sequenza differita, non una routine Z80 lineare. La regola ausiliaria cerca la stanza adiacente con `$D471` e ricava la direzione; viene poi eseguito il movimento direzionale.
- **GO THROUGH YOUR DOOR**: regola `$DC57`, predicato `$DC4E`; cerca il passaggio con `$D46C` e usa i controlli comuni. Il corpo `$DC5B` ricava la direzione e continua nel corpo di movimento. Costo 2, con testo narrativo diverso da WEST.
- **GO TO HALL** non è equivalente a GO INTO HALL nell'originale. Dopo aver aperto la porta, la prova completa rifiuta GO TO HALL, ma accetta GO INTO HALL e GO THROUGH YOUR DOOR. La prima versione del prototipo trattava GO TO come una scorciatoia; ora conserva la semantica originale e quindi rifiuta questo caso.
- **LOOK THROUGH YOUR DOOR** non sposta definitivamente Holmes. `$DC20` conserva la posizione, effettua un trasferimento temporaneo, usa la descrizione breve dell'altro luogo e ripristina la posizione. La prova completa stampa «You can see a hall.»; questa azione attraversa ora anche nell’interfaccia il flusso originale.

I casi nel gioco completo, con scheduler e NPC attivi, sono in `results/full-game-traces.json`. I casi del prototipo hanno una sorgente distinta e non vengono presentati come partite complete.

## Primo ingresso, ritorno e LOOK

Il punto di decisione è `$CA9E`:

```text
se bit 6 del record destinazione è già impostato:
    D1B2: descrizione breve
altrimenti:
    imposta bit 6
    D102: descrizione estesa
```

**Descrizione estesa, `$D102/$D113`:** eventuale grafica; contesto del contenitore in cui si trova l'attore; testo specifico o frase generica; passaggi; uscite senza entità interposta; oggetti e contenuti.

**Descrizione breve, `$D1B2`:** frase generica con il nome, quindi controllo della luce; se illuminato, uscite senza entità interposta e oggetti; altrimenti messaggio di buio. Non passa dalla routine `$D60B` che elenca porte e scale. Perciò un ritorno nel corridoio può stampare solo «You are in a hall.» pur avendo ancora porta e scala.

**LOOK esplicito, `$DC7B/$DC7D`:** richiede luce, costa 1 e chiama sempre `$D102`. Ripristina quindi la descrizione estesa anche dopo visite precedenti. Il testo specifico continua a dipendere dalla fascia oraria: non è memorizzata per sempre una descrizione unica della stanza.

Il puntatore descrizione zero **non significa locazione vuota o inesistente**: `$D182/$D187` compongono una frase generica e `$D1C6` stampa il nome dai campi lessicali.

Una particolarità verificata: il LOOK iniziale della partita **non imposta da solo il bit di visita**. Dopo aver lasciato la stanza di Holmes, il primo rientro può ancora usare la forma estesa; è quel percorso d'ingresso a marcare il record. Dalla seconda visita d'ingresso si ottiene la forma breve. Il prototipo distingue perciò i luoghi esplorati nell'interfaccia dal flag di visita nativo.

## Che cosa rende un oggetto visibile

La descrizione non cerca semplicemente «tutti gli oggetti con room == stanza». Ci sono due livelli distinti.

### 1. Percezione: `$C821`, `$C863`, `$C86E`

Ogni entità può avere un genitore (+01), più occorrenze in locazioni diverse e flag propri. `$C86E` risale i genitori finché sono visibili e aperti/rotti; si ferma alla prima barriera, oppure restituisce FF se non ne trova.

Il filtro `$C821` confronta il contesto dell'attore con quello dell'oggetto:

1. La barriera che contiene l'attore è percepibile dall'interno.
2. Negli altri casi l'entità deve avere il bit di visibilità +05/$80.
3. Un oggetto il cui contesto è l'attore stesso è ammesso.
4. Contesti separati da una barriera sono esclusi.
5. Quando entrambi sono senza barriera, almeno una delle locazioni dell'entità deve coincidere con quella dell'attore.

`explorer.py:perceived` traduce questo algoritmo, senza attribuire visibilità universale al solo bit $80. È stato confrontato con la routine Z80 per tutti i 110 oggetti in sei locazioni, più quattro stati sintetici della poltrona di Watson: **1.100 confronti concordanti**.

Il buio è un controllo separato, `$D078`: considera il contesto dell'attore, il flag della stanza, la fascia oraria e sorgenti luminose percepibili con opportuni flag. La regola LOOK lo consulta. L'interfaccia nasconde l'elenco visivo quando questo controllo segnala buio.

### 2. Elenco nella scena: `$D4CC/$D4EF/$D51A`

Un oggetto percepibile non viene necessariamente elencato sotto «You can see». Per ogni livello della ricorsione `$D4EF` richiede:

- il genitore richiesto dal livello corrente;
- che non sia l'attore stesso;
- il superamento di `$C821`;
- meno di due occorrenze (quindi i passaggi condivisi non entrano in questo elenco ordinario);
- che non appartenga alla catena di possesso dell'attore.

L'elenco di primo livello parte dal genitore FF. `$D531` imposta il bit +06/$80 sugli oggetti stampati; poi un secondo passaggio discende nei loro contenuti. `$D590` distingue persone («carrying») e altri contenitori, usando la relazione IN/ON/BEHIND/UNDER/TIED TO dal campo +04 & 7.

Nella stanza iniziale vengono elencati lampada (22), poltrona di Holmes (23), poltrona di Watson (24), poi Watson (3) e il giornale (25). Il denaro di Holmes è percepibile, ma non compare nella descrizione della stanza perché è posseduto dal giocatore. Le porte 21 e 50 sono percepibili ma vengono presentate come passaggi, non nell'elenco ordinario degli oggetti.

## Uscite nella descrizione

`$D60B` percorre le triplette con passaggio nonzero e direzione 1–10. Se il passaggio ha il flag di visibilità, stampa la relazione direzionale e il suo nome: «To the west there is your door.», oppure le forme Above/Below. Questo non equivale a dire che il passaggio sia già aperto.

`$D68C/$D671` stampa invece le direzioni delle triplette senza entità interposta. È usata sia dalla forma estesa sia da quella breve. Le due liste sono costruite a partire dal record corrente, non dal testo compresso della stanza.

## Architettura del prototipo

```text
Pagina HTML/CSS/JS
    → HTTP locale su 127.0.0.1
    → parser Z80 originale, in copia isolata
    → AST del comando
    → esecuzione originale del turno del giocatore
    → ciclo originale, saltando le visite degli NPC
    → costo, orologio simulato, testo e stato della mappa
```

La pagina esegue il turno originale del giocatore: editor, tokenizzazione, parser, risoluzione semantica, domande di disambiguazione e azioni. Conserva registri e stack al punto di attesa, oltre ai dati del comando e ai nodi pendenti. Le routine di ispezione possono usare separatamente i registri; prima del prossimo input si ripristina il punto corretto. Le frasi mostrate nell'area di gioco sono catturate dalle routine di stampa, senza una traduzione o una riscrittura degli errori in Python.

Le visite degli NPC nello scheduler sono saltate. Il tempo e la scadenza di Holmes vengono aggiornati dal ciclo originale; non si calcola più il costo del comando con una selezione Python. Restano bloccati i servizi nastro, stampa e controllo, per i quali compare un messaggio tecnico in inglese e viene ripristinato lo stato precedente. Le azioni non elencate fra i casi verificati non sono per questo certificate in ogni situazione di gioco.

Le continuazioni avvengono naturalmente: dopo WHICH DOOR ? la risposta YOUR o YOUR DOOR completa il nodo pendente. Un nuovo verbo può sostituirlo, secondo le regole originali. Un trasferimento manuale tramite la mappa annulla il comando pendente.

Gli oggetti e gli NPC partono dallo snapshot del primo prompt; gli effetti delle azioni vengono applicati dal codice originale. Le routine di descrizione mantengono la grafica nativa disabilitata perché la pagina inserisce gli SVG separatamente. Il payload sul disco non viene modificato. Il buio, le porte e le altre condizioni delle azioni vengono valutati dal gioco.

Il clic sulla mappa è uno strumento di esplorazione: chiama il trasferimento originale con propagazione ai discendenti, poi il percorso di descrizione d'arrivo, ma **ignora porte, adiacenza e costo**. Consente anche di ispezionare interni di mezzi non raggiungibili con i soli comandi implementati. Il punto zero non è una destinazione selezionabile.

Il grafo supporta ricerca, pan, zoom, nomi opzionali, evidenziazione del luogo corrente e dei luoghi esplorati. I sette archi a zero rimangono nei dati e nell'elenco delle uscite; non sono disegnati come collegamenti a una stanza reale.

## Verifiche e limiti

- 105 descrizioni d'ingresso ottenute in stati sintetici separati, trasferendo Holmes e lasciando il resto del mondo fermo.
- 1.100 confronti del filtro percettivo Python/Z80.
- Nove casi nativi mirati: porte, prime visite, ritorni, LOOK e buio.
- Quattordici comandi del prototipo aggiornato, inclusi errori, forme non supportate e sequenze.
- Dodici comandi nel gioco completo con scheduler originale, per confrontare movimento e descrizioni.
- 844 istruzioni e 3689 byte selezionati ricomposti identicamente al payload. Il listato separa dati, intestazioni e bytecode dal codice.
- Verifica nel browser di errore lessicale, apertura, movimento, aggiornamento dell'orologio e salto sulla mappa a tempo invariato.

I test sintetici non attestano che tutti gli stati siano raggiungibili attraverso una partita ordinaria. I campioni testuali non includono tutte le combinazioni di ora, contenimento e stato narrativo. Il filtro di percezione tradotto è verificato sui casi dichiarati; la regola completa di ogni azione, i trasporti e l'evoluzione autonoma dei personaggi restano fuori dal prototipo.

Vedere [GUIDA-SCRIPT.md](GUIDA-SCRIPT.md) per avvio e riproduzione; [CATALOGO-LOCAZIONI.md](CATALOGO-LOCAZIONI.md) per tutti i record e gli archi; `results/locations.asm` per il listato commentato.
