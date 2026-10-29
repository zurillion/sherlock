# Consegna e restituzione degli oggetti agli NPC

29 ottobre 2026. Ricostruzione autonoma della sintassi dativa GIVE e della
risoluzione delle richieste di consegna. Il motore originale è usato soltanto
come riferimento offline; la pagina esegue le regole JavaScript.

## Cosa provare

Da una partita nuova, seed1:

```text
GIVE MONEY TO WATSON
SAY WATSON "GIVE ME MY MONEY"
INVENTORY
GET LAMP
GIVE WATSON LAMP
SAY WATSON "GIVE LAMP TO ME"
```

Il cocchiere usa la stessa operazione:

```text
OPEN YOUR DOOR
W
D
OPEN DOOR
S
HAIL CAB
GIVE MONEY TO CABBIE
SAY CABBIE "GIVE ME MY MONEY"
```

Ricaricare la pagina sulla porta8768 per caricare i moduli aggiornati. Il
server è statico: non richiede riavvio e la partita aperta non viene alterata
per eseguire le prove. Le verifiche usano sessioni indipendenti.

## Perché non funzionava

Il parser riconosceva le parole ma conservava, correttamente, i gruppi nel loro
ordine fisico. La fase semantica non applicava il modo dativo del modello GIVE:

| Forma | Gruppo fisico1 | Gruppo fisico2 | Oggetto semantico | Destinatario |
|---|---|---|---|---|
| GIVE MONEY TO WATSON | MONEY | TO WATSON | MONEY | WATSON |
| GIVE WATSON MONEY | WATSON | MONEY | MONEY | WATSON |
| GIVE ME MY MONEY | ME | MY MONEY | MY MONEY | ME |
| GIVE TO WATSON LAMP | TO WATSON | LAMP | LAMP | WATSON |
| GIVE WATSON ALL | WATSON | vuoto | ALL | WATSON |

Il modello8 byte8321–8328 ricompone A01D=0C e A01E=61. B421/B445
usano il bit5 del modo in assenza di preposizioni, scegliendo gli offset
fisici08/12 o12/08. B468–B482 copiano6 byte per gruppo nominale.
Questi offset sono distinti dagli indici dei ruoli semantici: la continuazione
deve aggiornare la sintassi fisica. La conversione è ora idempotente, anche
quando ALL attraversa più visite. Nessun nome o verbo è ricavato da una
registrazione dell’esecuzione.

ME è alias lessicale di YOU; MY e MINE sono alias di YOUR. YOUR non è una
variabile di possesso: il qualificatore resta associato a your money quando
cambia il genitore. La verifica di possesso effettivo segue invece la catena
dei genitori fino all’attore corrente, D275–D29C. Perciò Watson non può dare
la lampada che Holmes sta ancora portando.

## Regola condivisa, non risposta speciale di Watson

Header DF02–DF05: classi A/D, controllo luce, costo1 e predicato DF24.
La classe A richiede un oggetto percepibile posseduto dall’attore; D richiede
una persona percepibile. DF24 usa C8C6 per peso e capacità, con i limiti
originali a8 bit. Non è un semplice test di dimensione del contenitore.

DF06–DF23 trasferisce il genitore dell’oggetto al destinatario, ne copia la
stanza e aggiorna i discendenti con D249. Il contenuto segue l’oggetto. Per il
denaro trasferisce il record monetario intero: non esegue PAY, non paga una
tariffa e non fonde i pence con il portafoglio dell’altro personaggio.

Gli NPC ricevono l’ordine citato attraverso la normale coda di richieste e
lo eseguono al loro turno. I loro programmi e vincoli continuano a decidere
se una richiesta viene accettata: la correzione non rende tutti gli NPC
incondizionatamente obbedienti. Non è stato aggiunto un ramo "Watson restituisce
il denaro". Le consegne e restituzioni naturali sono verificate con Watson e
con il cocchiere.

Con ALL, B29A richiede esattamente un destinatario valido per ciascun oggetto.
Il giocatore esegue le consegne in ordine crescente di ID nello stesso input,
con i relativi turni; l’NPC mantiene il cursore e consegna un oggetto a ogni
visita. Nell’esempio lampada+denaro prestati a Watson, GIVE ME ALL restituisce
lampada22, giornale25 e denaro27 in quest’ordine. SAVE/LOAD conserva la richiesta
parzialmente eseguita e la sequenza futura.

Una richiesta GIVE non risolvibile termina senza consegna. B969 salta a B9B4
prima degli store dell’iteratore B973/B976; il record liberato non deve ricevere
un cursore mai accettato. È stata corretta anche questa differenza di arena,
che avrebbe potuto cambiare estrazioni casuali successive.

## Minuzie conservate

- GIVE WATSON può inferire your money se è l’unico oggetto ammesso.
- GIVE MONEY WATSON ha l’ordine dativo sbagliato: non viene reinterpretato
  attraverso i tipi delle entità. L’originale dice I SEE NO WATSON THAT YOU CAN GIVE.
- GIVE e GIVE ALL senza nomi non scelgono Watson arbitrariamente: la coppia
  non è unica, perché anche Holmes può essere un destinatario valido.
- GIVE MONEY TO ME può riuscire senza cambiare possessore. Il soggetto non è
  escluso dalla classe D; il predicato e la conta delle coppie decidono.
- GIVE LAMP TO YOUR ARMCHAIR fallisce: una poltrona non è una persona. La
  ricerca nella descrizione determina il rifiuto YOU CANNOT GIVE THE LAMP.
- A7D0–A7E9 esclude YOU09EE dalla maiuscola dei nomi propri: Watson gives
  your money to you., non to You. La maiuscola a inizio frase resta separata.

## Prove e limiti

25 sequenze naturali indipendenti,99 input, tutti i24 attori attivi, seed1:
376 estrazioni e754 letture casuali confrontate. Il corpus verifica orologi,
scadenze/PC/argomenti di tutti gli attori, entità, stanze, fatti, arena completa
752 byte, liste, buffer, bitmap superiore/inferiore, MORE e campi temporanei
posseduti. A ogni input un LOAD separato verifica la continuazione. I chunk
narrativi del bridge Python sono diagnostici: il confronto visivo usa i byte
dello schermo, senza normalizzarli. Un test aggiuntivo controlla immutabilità
della sintassi e idempotenza della conversione dei ruoli.

I test storici includono anche il destinatario ambiguo con due Watson: quel
rifiuto conserva la formulazione originale e non viene sostituito con una
domanda moderna. La copertura di questa consegna non certifica tutte le
reazioni di ogni NPC né la partita completa. Rimangono il confine A022 del
percorso lungo e i cinque finali naturali ancora da certificare.

## Atlante

252 istruzioni e538 byte riassemblati indipendentemente. Nuova zona
precedentemente grigia A7D0–A7E9:26 byte. Documentati38386 byte, parziali470,
sconosciuti2744 su41600 byte del payload. Sono approfonditi anche8321–8328,
B280–B2B6,B405–B482,B936–B98B,B9AC–B9F9,C7E4–C7F8,C814–C820,
C8C6–C8EE,D275–D29C,DF02–DF2D, distinguendo il modello e l’header dai
corpi di codice. La copertura dell’atlante misura documentazione statica,
non equivalenza di tutti i comportamenti.
