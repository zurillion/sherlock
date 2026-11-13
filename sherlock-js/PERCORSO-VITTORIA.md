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

Nella diramazione di Camden il testo della nota recuperata è stato
letto mercoledì alle 10:17 con `EXAMINE NOTE` dalla strada, lasciando
le altre due note nel cortile per risolvere l’ambiguità. L’originale
la mostra come nota bruciacchiata e registra il bit di esame
sull’oggetto 85. Il ramo `$DF8D` disattiva il conto alla rovescia
e aggiorna il qualificatore.
