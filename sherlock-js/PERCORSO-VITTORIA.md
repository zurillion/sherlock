# Percorso verso il finale di Victoria

Il finale di vittoria `$6AF3` passa dal programma di Basil. La regola DOMAIN
`$EF83` verifica se Basil è con Holmes, identità 0. Il successo raggiunge
`$EF89` e il selettore `$9E48`. Quest’ultimo confronta la stanza di Holmes
con quelle di Watson e Lestrade. Se entrambi sono presenti seleziona `$6AF3`,
altrimenti `$6B79`.

## Condizioni dell’indagine nel binario

| Dato o routine | Condizione |
| --- | --- |
| `$9965`, `$9A3D` | La confessione del maggiore nella fumeria rende verificabile l’innocenza. Quando Lestrade la accetta, pone `$9E88` a 1. |
| `$9973`, `$9A4B` | L’esame di cadavere e ponte e l’osservazione della pietra consentono di confermare il suicidio di Mrs Brown. |
| `$9981`, `$9A59` | L’albero dell’omicidio di Tricia usa corpo, libreria, abiti e premesse modificate dalla confessione. L’accettazione rimuove Mrs Jones dalla scena. |
| `$9997`, `$9A13` | Gli esami della nota incompiuta, della cartella, delle lettere e delle due note cifrate rendono dimostrabile il possesso dei piani. Il gestore verifica anche entrambe le conclusioni sugli omicidi. |
| `$99A9`, `$99FC` | La deduzione sul luogo della vendita richiede il presupposto attivato dalla deduzione precedente e la nota recuperata dal fuoco. |
| `$EA25–$EA5E` | Lestrade controlla prima il possesso dei piani attraverso `$EB19`, poi il luogo della vendita attraverso `$EB11`. Superato il secondo controllo, il programma manda un segnale a Straker. |

Il test comune `$EB1F–$EB27` legge il bit 1 del record selezionato.
`$EAF8–$EB10` colloca il cab di polizia e il suo conducente in Main Street.
La [scheda di aiuto del 1985](https://worldofspectrum.net/pub/sinclair/games-info/s/Sherlock_HintSheet.pdf)
indica il rientro a Leatherhead e l’arrivo a Old Mill Road. I controlli nella
tabella sono ricavati dal payload originale.

## Primo riscontro in partita

Nel percorso con seed 1 già acquisito fino alla fumeria, la confessione del
maggiore avviene lunedì alle 23:52. Restando in Slater Street, Lestrade
incontra Holmes e accetta l’innocenza prima del controllo delle 23:59.
Partendo alle 23:55 si perde l’incontro e il flag resta spento. Se il giocatore
attende fino alle 00:06, il primo cab è impegnato con Lestrade e il secondo
può portare Holmes e Watson a Kings Cross. La prova senza lampada si ferma
per il buio alla prima uscita a nord-est.

La lampada può essere raccolta nella stanza iniziale. L’ordine verificato
`TAKE LAMP`, ingresso nel ripostiglio, `WEAR CHINA MANS DISGUISE` e
`TAKE OFF CHINA MANS DISGUISE` lascia entrambi gli oggetti a Holmes.
Il controllo d’illuminazione si trova a `$D078–$D0DB`.

[Listato riassemblato](results/victory-route/victory-route.asm)

## Lampada, lettere e ritrovamento nel ruscello

Sul percorso con la lampada, il maggiore arriva più tardi nella fumeria.
Restando dentro fino alle 00:03, Holmes ascolta la confessione e dà tempo
a Lestrade di registrare la compresenza in `$E955`. Alle 00:04, sulla strada,
Lestrade accetta la conclusione. Alle 00:12 il flag vale 1 e Lestrade ha
liberato il maggiore. Il controllo `$E95B` attende l’una di notte quando
Holmes e il maggiore rimangono separati. Mezzanotte è quindi un riferimento
di quella cronologia, mentre il ramo del codice controlla incontro e ora.

La lampada permette di raggiungere il binario 3 di Kings Cross alle 00:52
e di salire sul treno delle 01:45. Holmes e Watson scendono a Leatherhead
alle 03:03. A Cobden Lane l’apertura della cassaforte termina alle 03:37 e
Holmes esamina le lettere di Tricia alle 03:38.

La sponda est è la locazione 88. Nel controllo di martedì alle 09:31, con
Lestrade nella stessa locazione, `CLOSELY EXAMINE STREAM` attiva
`$E0A2` e rivela la pietra e la pistola. Lestrade riparte con la pietra.
Il cadavere è già fuori scena perché l’attore 12 lo ha raccolto, come
prevede `$F14C`. Per chiudere la deduzione bisogna esaminare la salma
prima della rimozione. È stato verificato l’esame sulla sponda est
lunedì alle 11:41, in una diramazione che visita il giardino prima
di tornare a Londra.

[Comandi del controllo della lampada](results/victory-route/trial-monday-lamp.txt) ·
[Comandi della tratta notturna](results/victory-route/trial-overnight-train.txt) ·
[Stato originale dei punti osservati](results/victory-route/trial-night-and-river-state.json)

## Citazione residua del percorso esplorativo

Un ordine ripetuto a Watson per prendere gli abiti già raccolti ha esposto
un limite distinto della ricostruzione. Nel controllo originale `$B05E`
alloca un ulteriore record e `$B095` riscrive il delimitatore in `$4D15`,
dentro la bitmap. Il valore deriva dalla ricerca che oltrepassa il buffer
dei token. La prova che riproduce la sola allocazione coincide con l’arena
e diverge ancora nell’immagine. L’itinerario con l’esame del cadavere
sostituisce il ritorno ridondante agli abiti.

[Traccia della citazione](results/victory-route/trial-replayed-quote.json)

## Due ordini identici al cocchiere

L’itinerario con il corpo esaminato prosegue dal binario di Kings Cross al
cab. Alle 13:50 il primo `SAY CABBIE "GO TO SLATER STREET"` stampa solo che
Holmes ha parlato. Il puntatore residuo `$5B87` coincide con la virgoletta
di apertura appena riscritta. `$B04D` prepara un TALK implicito, `$B05E`
accoda `$5B8A` e `$B095` converte temporaneamente l’apertura in `C0`.
Il token di movimento è incompatibile con il gruppo nominale atteso.
`$B904` libera il record sintattico. All’input successivo il puntatore
rimasto in testa cade sul verbo. `$B8D1` ripristina la chiusura e
`$B8D3` crea la richiesta. Il cab parte alle 13:52.

Il motore JavaScript riproduce il ramo in cui il puntatore residuo cade
sull’apertura e il token successivo è di movimento. Il confronto da avvio
con seed 1 comprende 114 checkpoint, tutti gli attori, l’arena, i token,
le bitmap, le estrazioni casuali e il futuro di ogni salvataggio. Il
ramo precedente in cui la ricerca scrive nella bitmap resta aperto.

[Comandi del confronto](results/victory-route/monday-corpse-to-cab.txt) ·
[Traccia dei due ordini](results/victory-route/cab-retry-trace.txt)

## Confronto fino a Leatherhead e prove di martedì

Il percorso ripetibile con seed 1 ora coincide tra Spectrum e JavaScript
per 235 checkpoint, dall’avvio fino all’arrivo a Leatherhead alle 03:03
di martedì. Il confronto include i salvataggi, i byte letti a ogni
estrazione casuale e i pacchetti di testo elaborati dalla pagina.

Nella descrizione del cab in viaggio, la classe notturna esegue il salto
relativo `$A679–$A683` dal token di `$7DF2` al frammento dei lampioni.
Il salto sostituisce il resto della descrizione. In altre fasce la
routine `$A6AC–$A6D0` scavalca il token e resta sul testo del sole.
A Kings Cross, già visitata, `$D1B2–$D1C5` entra direttamente nella
descrizione breve. Durante quel controllo `$A00A` contiene ancora la
stanza di partenza, mentre la lampada risulta già a destinazione.
La schermata di arrivo dice quindi che è troppo buio. La lampada torna
percepibile al turno successivo.

Sullo Spectrum, con il corpo e il ponte già esaminati, il ritrovamento
della pietra alle 09:23 consente a Lestrade di accettare il suicidio di
Mrs Brown alle 10:52 sul treno di ritorno. Per il confronto JavaScript
successivo a Leatherhead, il primo ostacolo emerso è stato una lettura
casuale di `$5C12` durante l’attesa sulla sponda est alle 05:55. La
correzione è descritta sotto.

In una diramazione originale separata, il travestimento da cinese
permette di entrare dalla finestra di Camden martedì sera. La porta di
quercia conduce all’ingresso. La nota strappata viene raccolta in
biblioteca alle 22:17 e quella lacerata nel cortile alle 22:31. Dopo
l’arrivo del messaggero mercoledì, aspettare in cortile fino alle 10:06
lascia uscire Basil dalla camera. Holmes entra dalla finestra e può
salvare dal fuoco la nota con `TAKE NOTE` alle 10:09. `TAKE BURNING NOTE`
in quella stessa situazione interpreta il qualificatore come `BURNT`
e fallisce. Restare nella camera durante l’accensione può invece
raggiungere il finale `$75D2`.

[Comandi del confronto notturno](results/victory-route/through-leatherhead-night.txt)

### Caratteri residui delle direzioni e nota salvata

Dopo l’arrivo sulla sponda est, `$D6A6` e `$A414` lasciano
`southeast.` nel buffer della parola. `$A9D7` scrive gli ultimi
tre caratteri in `$5C12–$5C14`. Il generatore casuale li legge
durante l’attesa. Più tardi il movimento visibile del giardiniere
lascia la `t` di `west` in `$5C0E`. Il motore usa le direzioni
effettivamente stampate per derivare entrambi i residui. Con questa
correzione il confronto di stato ha raggiunto il binario 2 di
Leatherhead martedì alle 09:50.

### Dalla biblioteca al treno

La lettura di `$5D15` delle 09:54 deriva da una stampa delle 03:19.
Nella biblioteca di Basil, la descrizione va a capo dopo `wall`.
La cancellazione della nuova riga entra in `$C388` con SP a
`$5D20` e il glifo dello spazio. `$C3B8` salva l’ultima riga
del glifo a `$5D15`. Il motore JavaScript già proiettava il glifo.
La cancellazione prudenziale durante `EXAMINE LETTERS` perdeva
quel residuo. L’esame ordinario di testo piatto ora lo conserva.

Il confronto prosegue fino alla salita sul treno alle 10:47.
Il successivo `TALK TO LESTRADE` riprende una citazione residua
e resta il primo scarto.

### Una citazione residua sul treno

La battuta delle 09:23 sulla morte di Mrs Brown fallisce perché
Lestrade è già uscito. Il puntatore alla citazione sopravvive nella
lista con testa a `$9FEC`. Nei primi due `TALK TO LESTRADE` a bordo
il puntatore vale `$5B8A`, dove il nuovo input ha il punto sintetico.
`$AAB2` restituisce 2 per l’unità vuota. `$B8D1` converte il
terminatore di riga `$5B8B` da `$C0` a `$90` e `$B8D3` accoda la
richiesta. Il turno avanza di un minuto e la richiesta viene rimossa.

Il parser esterno riparte da `$5B8B`. Legge `$90,0,0` come apertura di
una nuova citazione, crea un nodo `TALK` implicito con `$B04D` e
accoda `$5B8E` tramite `$B05E–$B07C`. La ricerca di chiusura a
`$B085` attraversa gli indirizzi dello Spectrum e, in questo
salvataggio, torna a `$5B8B`. `$B095` ripristina `$C0`. La successiva
lettura a `$5B8E` porta al rifiuto sintattico `$AF67` e a `WHAT ?`
nel riquadro inferiore. La frase «You talk to Inspector Lestrade.»
e il minuto trascorso restano.

I due `TALK` seguenti consumano i puntatori a `$5B8E`. Stavolta il
rifiuto avviene nel parser della citazione. `$B904` libera il suo
nodo temporaneo e l’azione si conclude con la sola frase di dialogo.
Alle 10:52 l’originale accetta `SAY LESTRADE "MRS BROWN KILLED HERSELF"`.
La riproduzione JavaScript del caso di rilettura del terminatore
rimane aperta. La scansione originale dipende anche da byte esterni
al buffer dei token.

Eliminando soltanto la battuta delle 09:23 dalla sequenza e presentando
la deduzione appena saliti a bordo, Lestrade la accetta alle 10:48 in
entrambi i motori con seed 1. I due inventari successivi arrivano alle
10:50. La regressione dall’avvio verifica 326 checkpoint di questa
variante, con stato degli attori, arena, estrazioni casuali, bitmap,
pacchetti dello schermo e prosecuzione dopo salvataggio e caricamento.

[Comandi del confronto fino alla deduzione](results/victory-route/through-leatherhead-train.txt)

Nella diramazione di Camden il testo della nota recuperata è stato
letto mercoledì alle 10:17 con `EXAMINE NOTE` dalla strada, lasciando
le altre due note nel cortile per risolvere l’ambiguità. L’originale
la mostra come nota bruciacchiata e registra il bit di esame
sull’oggetto 85. Il ramo `$DF8D` disattiva il conto alla rovescia
e aggiorna il qualificatore.

## Entrambe le deduzioni sugli omicidi

Nello Spectrum, nel salotto di Tricia martedì alle 13:19,
`SAY TRICIA "TELL ME ABOUT CLOTHES"` fa confessare Mrs Jones.
Il cambio d’identità scrive il bit 1 a `$9992` tramite `$E1CF`.
Alle 13:21 `SAY JONES "TELL ME ABOUT CLOTHES"` fa ripetere la
testimonianza e `$E19D` scrive il bit 1 a `$9996`. In questa
sequenza la forma con il solo cognome allinea l’inizio della nuova
citazione al puntatore residuo `$5B8A`. La forma con `MRS JONES`
aggiunge un token e sposta l’inizio della citazione.

Lestrade accetta `SAY LESTRADE "MRS JONES KILLED TRICIA"` a Scotland
Yard alle 13:53. `$9984` passa da `$A4` a `$A6`; `$9976` mantiene
`$A6` per Mrs Brown. Mrs Jones viene rimossa dalla scena.
Il salvataggio di partenza è quello originale di Parliament Street
dopo il treno di ritorno e l’accettazione della deduzione su Mrs Brown.
L’intera tratta è una prova sullo Spectrum.

[Comandi da Parliament Street alla seconda deduzione](results/victory-route/from-brown-to-jones.txt)

## Vittoria a Victoria

### Verifica con la grafica nativa attiva

Lo stesso percorso completo raggiunge **$6AF3** nello Spectrum
mercoledì alle **20:12**, al binario 1 di Victoria, con i seed
0, 1 e 137 e 22 disegni per partita. Gli ingressi usano i comandi
dall’accensione con tutti gli attori attivi.

| Seed | Checkpoint originali | Checkpoint coincidenti in JavaScript | Primo scarto |
| ---: | ---: | ---: | --- |
| 0 | 3.219 | 3.219 | finale $6AF3, mercoledì alle 20:12 |
| 1 | 3.219 | 3.219 | finale $6AF3, mercoledì alle 20:12 |
| 137 | 3.219 | 3.219 | finale $6AF3, mercoledì alle 20:12 |

I test dei seed 0, 1 e 137 confrontano sei riprese da salvataggio JSON
tramite la stessa API della pagina, in una sessione nuova ogni volta.
I punti sono l’atrio con immagine alle 08:25, il cab prenotato alle 08:32,
il treno delle 09:21, gli indizi di Leatherhead alle 11:08, l’ultimo
viaggio in cab mercoledì alle 19:51 e il binario di arrivo alle 20:11.
Dopo ogni ripresa il test confronta lo stato del motore, le risposte
e i pacchetti video con la partita continua, minuto per minuto fino
al punto seguente. In ogni confronto delle attese le due sessioni
usano il proprio identificatore di trasporto. Dal primo salvataggio
alla vittoria sono 3.207 checkpoint di prosecuzione confrontati.
[Verifica dei seed 0 e 1](SALVATAGGI-GRAFICA-NATIVA.md).

Con seed 0, il discorso di Lestrade a Slater Street lascia
`arounD.` nel buffer parola. L’input «I» fa scrivere un
terminatore zero al lexer DA75, sopra la prima lettera.
D719/C142 azzerano il contatore e riposizionano il cursore senza
svuotare la parola; D820 imposta la maiuscola. Il primo CR
dell’inventario passa da DE71 e scarica «Round.» preceduta
dal glifo zero. C388 legge le otto righe FF in ROM a $3C00.
La correzione riproduce anche i pixel della riga e permette
di arrivare fino a martedì alle 12:13.
[Scritture e glifi osservati](results/seed-and-saves/native-victoria-delayed-inventory.json).

Alle 12:14, sempre con seed 0, «HAIL CAB» stampa il nome
del veicolo. D427 e D445 percorrono rispettivamente il
qualificatore «hansom» e il nome «cab». A9D7 scrive la «m»
di «hansom» in $5C10. La parola più corta e il punto
sovrascrivono solo i primi quattro byte, così Watson legge
ancora la «m» nel suo turno. Il modello ricava il nome
dal dizionario e da quel punto coincide fino a mercoledì
alle 08:04.
[Traccia del nome durante HAIL CAB](results/seed-and-saves/native-victoria-hail-name.json).

Con seed 1, la risposta del cocchiere a «HAIL CAB» delle 08:29
passa da CDA7–CDBC al testo 6830 e al frammento 6BAC. Il
selettore 6918 legge $5D6D mentre il ritorno $A5B9 della chiamata
A5B6 è ancora attivo. Il modello espone i due byte del ritorno
solo all’interno di quella scelta. Alle 13:48 lo stesso
selettore legge la «n» di «Mon» da $BF70. A071 chiama BF79
prima delle visite degli attori; BFC6 copia tre byte dal
giorno selezionato e BFB0 converte ora e minuti in due cifre.
La proiezione dei nomi copre la tabella originale di sette giorni.
Il replay dall’accensione coincide fino a martedì alle 20:11.
[Scritture e letture osservate](results/seed-and-saves/native-victoria-cab-choice-clock.json).

La domanda 6830/6C1B del cocchiere a Camden Street inizia con
«The». Durante la partita, il flush A9FD/AA14 usa il frame
$5D28 per quell’articolo. All’ultima scansione della «e»,
C39D salva AF in $5D1C–$5D1D. Il giardiniere legge il byte
basso durante l’attesa delle 20:11, prima del checkpoint delle
20:12. Le 88 prove controllate partivano da CDB6 e in quel
setup preservavano entrambi i byte. La traccia naturale di
questa chiamata stabilisce la scrittura dell’articolo. Il
confronto prosegue fino a mercoledì alle 06:49.
[Prova controllata e traccia naturale](results/seed-and-saves/native-cab-waiting-speech.json).

Nei percorsi dei seed 0 e 1, la cuoca legge $5D22
durante l’attesa nel cortile di Basil. Nel seed 0 è stato
tracciato il writer originale. All’arrivo di Holmes in
travestimento, D1B2 stampa «The china man». Lo spazio tra
«china» e «man» passa al renderer con descrittore $5546 e
frame $5D2E. C3B8 salva F dell’ultima scansione a $5D22.
Entrambe le letture ora coincidono. Il confronto arriva
a mercoledì alle 10:45 con seed 0 e alle 08:33 con seed 1.
[Traccia del separatore](results/seed-and-saves/native-victoria-disguise-separator.json).

Durante lo stesso arrivo nel cortile, il seed 1 percorre
l’elenco delle uscite libere. D6A6 invia «west» ad A887, che
scrive il riferimento $0992 in $A022–$A023. A414 appende il
punto lasciando intatto il riferimento. La cuoca legge $09
alle 08:33, prima del checkpoint delle 08:34. Il modello
deriva il riferimento dall’ultima direzione dell’elenco
quando quello è l’ultimo testo della descrizione breve.
[Traccia di $A023](results/seed-and-saves/native-victoria-last-exit-reference.json).

Con seed 0, dopo la deduzione a Scotland Yard, Lestrade
chiama il cab. L’ultima «s» di «hails» raggiunge C388 con
frame $5D2A e shift 3. C3B8 conserva F in $5D1E. Lo
spazio dopo «hansom» riempie la riga e la pulizia usa
il frame $5D30, che conserva la coppia precedente e
scrive F in $5D24. Il giardiniere legge entrambi nella
stessa estrazione. Il replay dall’accensione coincide
fino a Leatherhead mercoledì alle 18:10.

Con seed 1, il riferimento di «west» permette di arrivare
alla lettura di $5D24 alle 09:39, prima del checkpoint
delle 09:40. Il valore viene dalla «s» finale di «exits»,
quinta lettera scaricata da A9FD/AA14 con frame $5D30.
C39D salva F; i byte sono ancora intatti al turno della
cuoca. Il replay coincide fino alle 10:16.
[Tracce delle scansioni](results/seed-and-saves/native-victoria-hail-and-room-scans.json).

Con seed 0, durante «LOOK» al binario 2 di Leatherhead,
A990 salva DE=$5F6A in $5D22–$5D23. A8EE ha formato il
puntatore aggiungendo la base $5DBF all’offset $01AB della
voce «chronicle». Il ritorno a capo finale porta il contatore
da 14 a 15. Watson legge il byte alto durante l’attesa
delle 18:10, prima del checkpoint delle 18:11. Il recupero
prosegue fino all’ultimo cab delle 19:41.

Con seed 1, il testo della nota bruciata usa il modo
maiuscolo $A851. Dopo la L finale sullo schermo,
A9D7 lascia in $5C0B la lettera grezza «l». Il renderer
JavaScript usa i caratteri grezzi prodotti dal decodificatore
per il buffer e i caratteri formattati per il video.
[Tracce della nota e del dizionario](results/seed-and-saves/native-victoria-note-and-station-dictionary.json).

Con seed 0, il cab finale per Victoria conserva due effetti
del qualificatore «hansom». In C388, la «m» entra a colonna
18 e frame $5D2C. C38B salva il puntatore video $5030 in
$5D24–$5D25 e C388 salva F=$0A in $5D2A. Il saluto di Watson
a Lestrade conserva questi valori su una riga libera.
Il cocchiere legge poi $5C91, il flag di stampa P_FLAG
della ROM. Il normale avvio con la grafica attiva lascia
zero, misurato nei tre seed, e i renderer del gioco
usano i propri flag. La partita JavaScript riproduce tutti
i 3.219 checkpoint, 8.844 estrazioni e 18.824 letture.
Il controllo arriva da un nuovo avvio fino a $6AF3 a
Victoria alle 20:12.

Con seed 1, «You talk to the cabbie» lascia AF della
«o» di «to» nel frame $5D2A e HL video della «e» di «the»
nel frame $5D2C. «You wait.» a bordo del veicolo conserva
i byte poi letti dal giardiniere. Il confronto arriva
fino alle 12:19, durante il successivo viaggio in treno.
[Tracce del cab e del flag della ROM](results/seed-and-saves/native-victoria-hail-talk-and-print-flag.json).

Sul binario di King’s Cross, Watson sale sul treno.
La «m» di «steam» entra in C388 con frame $5D2C.
C39D e C3B8 conservano F dell’ultima scansione in $5D20,
mentre C38A conserva il descrittore del buffer parola
$5C0B in $5D26–$5D27. Il giardiniere legge $5D20 e
$5D26 alle 12:19, prima del checkpoint delle 12:20.
La partita coincide fino alle 15:05, nella carrozza
della polizia.
[Traccia della salita sul treno](results/seed-and-saves/native-victoria-train-boarding-1.json).

All’avvio del viaggio nella carrozza della polizia, «are»
non entra nel resto della riga. La pulizia di $C374
arriva a $C388 con frame $5D2C. $C39C e $C3B7 conservano
a $5D22 lo shift della colonna finale. Nello stesso testo, la
«y» di «country» passa per il frame $5D32 e lascia lo shift
a $5D28. Il giardiniere legge entrambi prima delle 15:06.
Il successivo LOOK conserva a $5D0E–$5D0F l’ultima scansione
di «carrying». Watson legge il byte alto, la riga del glifo,
prima delle 15:41. Alle 15:44 il predicato $E604 ha
già confrontato le radici di contenimento. Le due chiamate
a $C863 preservano IX. Anche quando il confronto è falso,
$CB37 pubblica il record dell’argomento, $8CDC in questa
partita. Il giardiniere legge il byte basso da $CB28.
[Traccia degli shift e del glifo durante il viaggio](results/seed-and-saves/native-victoria-moving-police-cab-1.json).

Nel LOOK durante la corsa, la pausa tra «chronicle»
e «you» lascia la scansione dello spazio a $5D22–$5D23.
La pulizia della riga conserva l’indirizzo video a
$5D28–$5D29. Al binario di Leatherhead, il saluto di
Lestrade usa il nome di dizionario «watson». $D442 passa
per $A815 e $A9D7 conserva la «n» minuscola in $5C10
prima che la stampa applichi la normale maiuscola del nome.
Il successivo LOOK da terra lascia il ritorno $A97F
della chiamata al lettore a cinque bit in $5D24–$5D25.
Più tardi, al rifiuto di salire di nuovo in treno, la «e»
finale di «Lestrade» riempie la diciottesima colonna al
limite di MORE. $C306 ripristina la finestra larga prima
che $C2DF chieda di pulire la riga. Nel frame $5D16,
$C38A salva il descrittore $5A20 in $5D10–$5D11.
Watson legge il byte alto prima delle 18:24.
[Traccia del LOOK e delle letture a Leatherhead](results/seed-and-saves/native-victoria-look-leatherhead-1.json).

Con seed 137, il giardiniere legge $F60B lunedì alle 16:49.
Il colore di lavoro parte da $38 e F507 lo azzera al termine
di ciascun riempimento. Il modello applica questa regola
dopo ogni disegno. La verifica Z80 copre tutte le 14 immagini.

All’arrivo del treno al binario 1 di Leatherhead, il punto dopo
«Watson» riempie la riga a 18 colonne con il glifo nel frame
$5CFC. C2DA prepara HL=$5020 e C=$02. C31D salva BC e C31E salva
HL prima della copia dei pixel. Watson ritrova il byte alto di
HL in $5CF9 alle 05:56, poi i byte di BC in $5CFA e $5CFB alle
07:27 e alle 09:00. Con questi salvataggi il confronto supera
anche entrambe le estrazioni della cuoca delle 05:56.
[Registri e letture osservati](results/seed-and-saves/native-exact-margin-stack.json).

Alle 09:39, l’arrivo di Watson al binario di Leatherhead passa
per CC07 e il frammento $68ED. A9D7 lascia la r di «enterS»
nel buffer $5C0F, che Watson legge prima della prossima parola.
Il modello riproduce quel frammento anche per il buffer grezzo.

[Scrittura osservata durante l’arrivo](results/seed-and-saves/native-arrival-word-buffer.json).

A Parliament Street il cocchiere dà il resto a Lestrade. La r
di «Inspector» arriva all’ultima colonna nel frame $5D2A. C374
pulisce la riga seguente con un frame otto byte più profondo.
C3B8 conserva l’ultima scansione grezza del glifo spazio in
$5D17, letta dal giardiniere alle 12:31.
[Traccia dello scorrimento durante il resto](results/seed-and-saves/native-cab-change-margin.json).

A Camden Street la domanda del cocchiere passa per CDB9 e usa
la cornice $6830 con argomento $6C1B. Quando parte su una riga
larga libera, il frame verificato lascia intatti $5D1A–$5D1D.
Lo confermano 88 prove con due cocchieri, quattro valori
dell’accumulatore e undici valori iniziali del contatore.
Il modello conserva quei byte e supera la lettura delle 16:56.
[Prova dei frame della domanda](results/seed-and-saves/native-cab-waiting-speech.json).

Nel cortile di Basil, C389 salva BC nel frame $5D22 mentre
stampa «china». Il giardiniere legge il contatore B=$01 da
$5D1F alle 02:43. Quando Watson sale sul cab, C39D usa invece
$5D1E per i flag della scansione della o di «into». La cuoca
legge quel byte alle 10:20 insieme al byte basso del puntatore
video lasciato dalla m di «hansom» nel frame $5D2C.
[Tracce dei due frame](results/seed-and-saves/native-victoria-midgame-stack.json).

Al binario di King’s Cross, lo spazio tra «some» e «money»
chiude la riga. C38A salva l’alto del descrittore $5575 a
$5D25. La pulizia successiva salva B=$01 a $5D1F, dal
contatore di C374. In viaggio la parola «English» lascia
invece i byte bassi dei puntatori video della pulizia e
del glifo h in $5D20 e $5D26. Il giardiniere legge queste
coppie alle 11:43 e alle 13:17.
[Tracce dei descrittori e dei puntatori video](results/seed-and-saves/native-victoria-afternoon-stack.json).

Nella carrozza della polizia, il byte letto alle 15:20 viene
dai flag della g di «carrying» durante LOOK. Alle 16:13
vengono letti i flag dello spazio prima di «You» e il byte
basso del puntatore della pulizia di riga. Alle 16:36 il
giardiniere legge poi il riferimento $573F del token «road»
dal descrittore del dizionario in $A022–$A023.
[Tracce della carrozza della polizia](results/seed-and-saves/native-police-cab-stack.json).

A Leatherhead, il titolo «Inspector» lascia il contatore di
scansione in $5D23. La parola «station.» va a capo nella
finestra stretta e la pulizia lascia la scansione dello spazio
in $5D29. Alle 18:02 il LOOK lascia in $A023 l’alto di $51AB,
il riferimento al sostantivo «chronicle» che chiude il testo.
[Traccia dello schermo di Leatherhead](results/seed-and-saves/native-leatherhead-station-stack.json).

La notifica di arrivo del treno usa il frammento $68ED e
lascia la S di «enterS» in $5C10. Nell’ultimo viaggio la h di
«English» lascia lo shift 4 in $5D24 e $5D2A, letto alle 19:03.
Il confronto prosegue fino al richiamo del cab a King’s Cross.
[Traccia dell’ultimo viaggio](results/seed-and-saves/native-victoria-evening-stack.json).

Durante l’ultima salita sul cab, Lestrade esegue FOLLOW.
Il predicato E44C lascia in IY l’intestazione $E452. CB3B
la copia in $CB2A–$CB2B e il generatore legge il byte basso
$52 prima di scegliere la durata del contatore di Lestrade.
Il motore ricava il puntatore dalla regola selezionata.
La prova con seed 137 segue l’intero percorso dall’avvio
e confronta 8.912 estrazioni e 19.024 letture, oltre alla
finestra superiore, agli attributi, all’orologio e al finale.
[Traccia del puntatore FOLLOW](results/seed-and-saves/native-victoria-follow-pointer.json).







Un LOOK aggiuntivo prima del primo HAIL CAB cambia il percorso
col seed 1. In questa variante, mercoledì Lestrade rifiuta le
deduzioni sui piani e sulla vendita. L’attesa a Victoria fino
alle 22:00 lascia la partita aperta. Al primo scarto video di
questa variante, lunedì alle 23:58, A9F4 scarica il residuo
della frase di Lestrade prima dell’inventario. AA6E riceve
$00 seguito da «Round.» e dal ritorno a capo.

[Esiti e primi scarti](results/victory-route/victoria-native-graphics-verification.json) ·
[Traccia con seed 0](results/victory-route/victoria-native-graphics-seed0.json.gz) ·
[Traccia con seed 1](results/victory-route/victoria-native-graphics-seed1.json.gz) ·
[Traccia con seed 137](results/victory-route/victoria-native-graphics-seed137.json.gz) ·
[Riempimenti verificati](results/seed-and-saves/native-picture-fill-residue.json).

Per ripetere la prova sullo Spectrum dalla cartella del motore:

```sh
python3 tools/probe-native-picture-window.py /tmp/sherlock-victoria-137.json \
  --route results/victory-route/victoria-full-route.txt --seed 137
```

### Verifica del profilo testuale

Una partita con seed 1 e tutti gli attori attivi raggiunge il testo
`$6AF3` **mercoledì alle 20:12**, al binario 1 di Victoria.
I comandi sono stati giocati sullo Spectrum senza teletrasporti o
modifiche alla partita. Il motore autonomo JavaScript raggiunge lo stesso finale, con gli
stessi comandi e lo stesso seed.

- Dopo le due deduzioni sugli omicidi, Holmes esamina a Camden
  le due note cifrate martedì sera. Mercoledì salva dal fuoco la
  terza nota alle 10:09 e la esamina alle 10:17. La nota incompiuta
  e la cartella erano già state esaminate nella cassaforte di Tricia.
- A Scotland Yard `SAY LESTRADE "BASIL HAS PLANS"` completa
  `$9997` alle 10:43. `$9A27` abilita la premessa successiva.
  `SAY LESTRADE "SALE LOCATION IS OLD MILL ROAD"` completa
  `$99A9` alle 10:45. Lestrade parte e il programma invia a
  Straker il segnale di `$EA5D`.
- Alle 13:29 Holmes è sul treno appena arrivato al binario 1 di
  Leatherhead. `GET OUT`, `S`, `S`, `CLIMB INTO POLICE CAB`
  lo portano a bordo con Watson e Lestrade. Un solo `LOOK` aggiunto
  prima di salire può lasciare Holmes a terra. La squadra raggiunge
  Old Mill Road, Basil fugge e la vettura torna a Main Street.
- Alle 18:15 il treno del binario 2 di Leatherhead ha a bordo
  Basil e l’agente. Salendo con `CLIMB INTO TRAIN`, Holmes porta
  con sé Watson e Lestrade. Il treno raggiunge Kings Cross alle 19:29.
- Il percorso usa due cab distinti nella tratta finale. Holmes
  sale nel suo prima che Basil chiami l’altro. Alle 19:50 ordina
  `FURIOUSLY GO TO BUCKINGHAM PALACE ROAD`. Alle 20:05 scende e
  va a est nell’atrio di Victoria. Aspetta due minuti con `I`, `I`
  e solo allora va a est al binario. `$EF83` trova Holmes e
  `$9E4A–$9E69` trova anche i due accompagnatori.

Entrando al binario subito e aspettando lì, Lestrade segue il
proprio programma e passa a ovest prima della visita di Basil.
Questa diramazione raggiunge `$6B79` allo stesso minuto. Il test
parte dal salvataggio JavaScript nell’atrio e confronta anche i
[tre comandi della variante](results/victory-route/victoria-early-platform.txt)
con il ramo corrispondente dello Spectrum.

[Sequenza completa dei comandi](results/victory-route/victoria-full-route.txt) ·
[Risultato della riproduzione originale](results/victory-route/victoria-native-verification.json)

Per rifare la verifica offline dalla cartella del motore:

```sh
python3 tools/probe-murder-ending.py \
  --manifest results/victory-route/victoria-manifest.json \
  --output /tmp/sherlock-victoria-native.json
```

## La stessa sequenza con seed 255

Con il seed 255, i comandi del percorso per Victoria portano al
finale **$6A26** martedì alle 01:02. Holmes è in un cab a King’s
Cross Road mentre Lestrade è a Slater Street. Il caso non è pronto
e $9E87–$9EA1 seleziona $6A26 dopo il confronto delle due locazioni.

Il primo scarto osservato nel confronto era alla riga 219
(checkpoint 218 con indice da zero), durante un’attesa. Strachan
sceglie di sedersi sul divano dei Brown. Il nodo $F053 contiene
già l’ID di SIT IN ($28) e lascia ambo gli argomenti a FF. Il ramo
$C4D1–$C53F carica il modello, cerca il primo candidato e verifica
la regola locale $E40A del divano. A fine azione lo slot 5 è nel
contenitore 60 e riprende da $F029 tra due minuti. Alle 15:03
Strachan si alza tramite $F057 e la ripresa a $F059 conserva lo
stesso costo.

Il lexer dell’input interpreta IN come alias di VISIT. Il modello
dell’azione conserva invece l’offset lessicale $450, che produce
IN. La ricostruzione delle azioni interne usa i riferimenti del
modello. Lo stesso meccanismo preserva la preposizione nelle
azioni interne DROP IN e PUT IN. Un test verifica tutti gli ID
del catalogo con un argomento già risolto.

Il confronto arriva al finale in 803 checkpoint con 2.460 estrazioni
e 5.168 letture dopo l’avvio. Comprende i 24 slot degli attori, i record,
le bitmap, la schermata prima della conferma del finale e la
prosecuzione dopo Salva/Carica.

[Rapporto](results/seed-and-saves/victoria-seed255-verification.json) ·
[Corpus originale](results/seed-and-saves/victoria-seed255-native.json.gz) ·
[Manifest](results/seed-and-saves/victoria-seed255-manifest.json)

Per ripetere l’acquisizione dallo Spectrum:

```sh
python3 tools/probe-murder-ending.py --seed 255 --every-minute \
  --manifest results/seed-and-saves/victoria-seed255-manifest.json \
  --output /tmp/sherlock-victoria-seed255.json
```

## Riproduzione JavaScript fino a Mrs Jones

Il confronto dal primo comando arriva a **374 checkpoint**, fino
a martedì alle 13:26. Comprende lo stato degli attori, tutti i 752
byte dell’arena, gli ingressi e i risultati della casualità, la
bitmap, i pacchetti di stampa della pagina e la prosecuzione dopo
salvataggio e caricamento.

- Alle 12:31 il test del passeggero a $E6F0 scrive l’ID 0 di Holmes.
  La continuazione a $D031 ripristina l’ID 2 di Lestrade prima che
  il cabbie annunci al cliente l’arrivo. Il messaggio è rivolto a
  Lestrade anche quando Holmes è a bordo.
- Alle 12:47 l’avvertimento sul debito, a $E725, usa un frame più
  profondo. La stampa sovrascrive un indirizzo video residuo a
  $5D0E. Nel modello il vecchio valore cessa di essere disponibile
  dopo quella stampa.
- Alle 13:22 «SAY TO JONES» lascia il puntatore precedente sopra
  la nuova virgoletta di apertura. $B04D avvia un TALK implicito
  e $B095 tratta la stessa virgoletta come fine della citazione.
  Il verbo TELL nel posto di un argomento provoca il rifiuto
  interno. L’azione esterna TALK consuma il minuto.
- Nel successivo `SAY JONES "FOLLOW ME"` il puntatore rimasto
  raggiunge il solo ME. $AAEA seleziona il modo 2 e $AB43 accetta
  l’unità vuota tenendo il soggetto nello slot 24 del nodo.
  $B8D1 ripristina il delimitatore. $BA20 consegna le affermazioni
  a Watson e Lestrade; Mrs Jones lascia la richiesta nella lista
  e continua il suo turno.

[Disassemblato e byte verificati](results/victory-route/victory-route.asm)

Il rifiuto di un nuovo `FOLLOW ME` alle 13:27 percorre `$CBA7`
per stampare nel canale superiore. Il parser ritorna a `$B969`
senza copiare il cursore dell’argomento nel record. `$B9D4`
copia comunque zero nel puntatore sintattico prima di liberare
l’ultima richiesta. La precedente richiesta in modo 2 rimane.

Alle 13:34 Mrs Jones sale sul cab. `CLIMB INTO` ferma la ricerca
al primo oggetto valido tramite `$B238`. `$B973–$B976` conserva
`$8BC9`, l’indice del cab 30, nel record rilasciato. Quell’arena
è uguale nei due motori anche dopo la successiva deduzione su
Tricia. Lestrade l’accetta alle 13:53. Il confronto arriva a
**394 checkpoint**, fino al secondo ordine per Camden Street
alle 14:00.

### Arrivo in cab a Camden Street

Il secondo ordine per Camden è ricevuto quando il cab è già
in viaggio. L’originale stampa il rifiuto $6C34 attraverso
$9B79, poi arriva comunque a Camden per effetto del primo
ordine. La traccia originale del tick 1803 separa i due eventi.

La descrizione completa entra a $D187 perché la strada ha
puntatore alla prosa zero. L’andata a capo del nome del veicolo
passa per $C374 con frame $5D1A e sostituisce i residui
video a partire da $5D0E. Più avanti $D68C stampa le uscite.
L’ultima s di «exits» entra in $C388 con frame $5D24,
indirizzo video $502A e shift 6. $C3B8 lascia i flag
di scansione a $5D18. La cuoca legge quel byte al tick 1812
e il generatore prosegue alla seconda coppia di letture.
Il motore ricava il valore dalla stampa del glifo e conserva
l’effetto dopo salvataggio e caricamento.

Il LOOK a piedi alle 14:18 lascia un altro AF di scansione
nello stack. Il delimitatore di «hansom cab» entra nel renderer
a $5D26 e salva le flag a $5D1A. La battuta di congedo $6BF6
su riga nuova raggiunge al massimo il frame $5D30 in questa
traccia. Conserva quindi i due byte. Alle 17:19 la cuoca
legge $5D1A e il generatore riproduce la stessa scelta. Alle 20:16 il
giardiniere legge lo shift 3 a $5D1C, salvato da $C39C/$C3B7
per lo stesso spazio. Conservare anche BC allinea questa
seconda estrazione.

Prima dell’elenco del cortile di Basil, il frammento $68E4
richiama l’articolo del personaggio travestito. Il delimitatore
scarica la parola «door.» con il glifo a $5D14. Se deve andare
a capo, $C374 pulisce la riga con il glifo dello spazio a
$5D0E. $C3B8 scrive quindi le flag a $5D02.

Nelle descrizioni brevi senza prosa, anche il qualificatore
del personaggio travestito passa da $D187 e $68DD. L’ultima
«a» di «china» entra nel glifo con frame $5D22. $C3B8
conserva l’ultima scansione del font a $5D17. Watson legge
quel byte al tick 2316, uscendo dalla cucina di Basil.

Nella descrizione breve del cortile anteriore, l’ultima
«a» di «china» a $5D22 lascia l’indirizzo video a $5D1A–$5D1B,
il descrittore a $5D1C–$5D1D e AF a $5D20–$5D21. Lo spazio
che precede il sostantivo ha frame $5D2E e lascia la scansione
a $5D23. La stampa del nome proprio della stanza, incluso il
ritorno a capo di «Yard.», passa da un frame più alto. Questi
byte spiegano le letture del giardiniere e di Watson all’alba.

Holmes salva la nota dal fuoco alle 10:09 e la esamina alle
10:17. Lestrade conferma la deduzione sui piani alle 10:43
e il luogo della vendita alle 10:45. L’annuncio della sua
partenza a ovest comincia con un delimitatore: separa il
nome dalla parola che chiude «catch them.».

Il confronto dello stato, delle estrazioni e della bitmap
arriva a **600 checkpoint**, fino a mercoledì alle 12:40,
sul treno con Lestrade e Watson.

Durante la richiesta di pagamento a Kings Cross, la parola
«to» viene scaricata mentre il decoder apre il nome del
destinatario. Il glifo usa il frame $5D24 e $C398 conserva
il byte basso del descrittore a $5D1E. Il ritorno a capo
di «guv’nor» passa da $C374 con frame $5D30. Il salvataggio
dell’ultima scansione dello spazio a $C3B8 produce $5D24.
La cuoca legge entrambe le celle durante il suo turno
delle 11:13. Holmes paga due scellini e riceve uno scellino
e sei pence di resto.

La successiva lettura da ricostruire è $5D1F, sul treno
verso Leatherhead alle 12:41.


### Il ritorno a Leatherhead

Il tracciato JavaScript arriva a **666 checkpoint**, fino a
mercoledì alle 18:19. Sul treno delle 12:41 le due letture
$5D1F e $5D25 provengono dalla scansione del glifo durante
la stampa di «English» e dal ritorno a capo che lo precede.
La capacità del cab di polizia si verifica con $E3F5 e $DEE4:
Watson e Lestrade salgono, Straker rimane a terra. La stampa
dell’ordine di Lestrade antepone «Furiously» al verbo.
La descrizione del cab ha due chiamanti distinti, all’avvio
della corsa e con LOOK. I loro frame lasciano residui diversi.

Al binario, $CB22 sceglie $68ED. Durante l’arrivo di Lestrade
il qualificatore «Inspector» passa dal frame $5D2C.
$C39C e $C389 lasciano a $5D22 e $5D28 lo shift del glifo,
calcolato dalla colonna. L’annuncio di Watson e quello della
partenza del treno conservano quei byte nella geometria osservata.

Alle 17:32, durante WAIT UNTIL, la cuoca legge $CB28. Il corpo
$DD07 ha lasciato entrambi gli indici sul record di chi si è
mosso: il giardiniere, record $8D42. $CB37 pubblica il primo
puntatore: la cuoca legge il byte basso $42. Il modello deriva
il puntatore dal record dell’attore. Anche il tentativo di salire
sul treno assente attraversa il rifiuto del resolver e libera
il nodo nel momento previsto dal gioco.

Il limite di questa tappa era il LOOK delle 18:20, che esegue
un rifiuto di Lestrade mentre Holmes è a bordo.


### Dal treno di ritorno alla vittoria

Durante il LOOK a bordo, la stampa dell’elenco dei passeggeri
attraversa una pulizia profonda della riga. Il rifiuto di Lestrade
scinde poi «cannot» e «that» nei frame $5D2E e $5D34; $C39D
lascia l’ottava riga dello spazio e del glifo a $5D23 e $5D29.
Alle 18:47, durante il viaggio, Lestrade legge $A023: la coda
letterale di «countryside» conserva il descrittore di «count»
($51F7), che precede il suffisso. L’agente che emerge alla vista
sulla via per l’uscita di Kings Cross è annunciato con l’articolo
indefinito.

Nell’ultimo cab, il ritorno a capo dal frammento $7DE1 usa
$C374 con frame $5D2C. $C38B conserva il byte basso
dell’indirizzo video dell’ultima cella pulita a $5D24; la
stampa del possessivo «your» lascia $5D2A con lo stesso
meccanismo, nel frame $5D32. L’estrazione li legge alle 19:52.

Il test del motore autonomo confronta i 350 comandi della
partita sui 700 punti del riferimento originale: 8.784 estrazioni,
18.748 letture, attori, oggetti, orologio, registri del mondo,
bitmap di testo e pacchetti per la pagina web. Controlla inoltre
il proseguimento dopo SAVE/LOAD e il blocco del mondo dopo
l’unica conferma del finale. Il riferimento originale resta
nei test; il motore non lo carica né interpreta istruzioni Z80.

Il confronto completo copre il seed 1. Le altre diramazioni
e gli altri seed sono nel piano delle verifiche successive.


### Diramazione della vendita tardiva

Dopo l’accettazione della deduzione su Tricia, Holmes rimane a
Scotland Yard e dà tre volte `WAIT UNTIL 11PM`. Sullo Spectrum
la terza attesa viene interrotta giovedì alle 10:00 dal testo
`$6ABD`. L’originale è stato riprodotto dall’avvio con seed 1,
231 comandi e tutti i 24 attori attivi. I primi 390 punti di
confronto coincidono con il percorso di Victoria.

Il programma di Lestrade rimuove l’ispettore dalla scena a
`$EAA9`, aspetta le 10 con `$EAAD` e chiama `$9EA2` da
`$EAB3`. Il corpo a `$9EA4` legge il bit 1 di `$9976` e
`$9984`. Con entrambe le deduzioni confermate, `$9EBB`
seleziona `$6ABD` e passa il testo al gestore comune `$9E74`.

Nella descrizione di Scotland Yard, l’articolo «some» nel denaro
di Lestrade viene stampato nel frame `$5D16`. L’ultima lettera
lascia a `$5D12` lo spostamento orizzontale dei pixel e a
`$5D13` il numero di caratteri rimanenti nel buffer. La risposta
sulla deduzione su Tricia li conserva. Il prefisso «Inspector»
in `$67FF` usa invece il frame `$5D20` e aggiorna i relativi
registri video. Gli attori leggono entrambi i gruppi nel corso
dell’attesa. Il modello ricava questi registri dal formatter.

Le partenze serali e il ritorno delle 07:00 usano chiamanti
diversi. Il qualificatore dell’annuncio di partenza usa il
frame `$5D2A` e il cognome il frame `$5D38`. Al ritorno,
`$CC07` stampa «enters» da una regola e il prefisso usa
`$5D28`. Nel primo saluto, «Good» va a capo quando il decoder
incontra il token di «morning». `$C374` pulisce la riga dal
frame `$5D32`, lasciando ulteriori registri che il gioco
rilegge nel pomeriggio.


Nell’ultima attesa, `$AEA4` consuma il punto del comando
e salva in `$A02B` l’indirizzo del token successivo. `$A029`
resta sul punto. Watson legge il byte basso alle 09:32 di
giovedì. La riscrittura usa la posizione effettiva del token
e conserva il cursore nei salvataggi.

Il confronto JavaScript arriva allo stesso finale su 664
punti, con 10.655 estrazioni e 22.492 letture. Il test avvia
la diramazione da un salvataggio prodotto durante il replay
del prefisso comune. Compare lo stesso testo finale e la
partita si ferma dopo la conferma.

[Sequenza completa](results/final-solution/late-sale-both-murders.txt) ·
[Rapporto del confronto](results/final-solution/late-sale-verification.json)

Per ricreare l’acquisizione originale dalla cartella del motore:

```sh
python3 tools/probe-murder-ending.py \
  --manifest results/final-solution/late-sale-manifest.json \
  --output /tmp/sherlock-late-sale-native.json
```
