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
