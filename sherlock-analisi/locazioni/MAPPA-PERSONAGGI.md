# Orologio, direzioni e segnaposti dei personaggi

L’orologio si trova a sinistra nella striscia fra narrazione e comandi. Il calendario usa le abbreviazioni inglesi Mon–Sun e il periodo unito all’ora: `Mon 08:05am`, `Tue 12:05pm`. Il formato non cambia il contatore o i costi delle azioni.

## Direzioni sugli archi

Gli archi conservano direzione e destinazione estratte dal payload. L’aspetto grafico non sostituisce questi dati.

Per ogni arco vengono confrontati il punto di uscita dal riquadro sorgente e quello d’ingresso nel riquadro destinazione. Una faccia implica N/S/E/W; un attacco vicino a entrambi i lati dello spigolo implica una diagonale. Se questa interpretazione non coincide con la direzione reale, compare una sigla sulla freccia. UP e DOWN sono sempre espliciti perché la posizione verticale sulla pagina non permette di distinguerli da NORTH e SOUTH.

La classificazione usa i punti di attacco normalizzati rispetto alle dimensioni del rettangolo: entrambi oltre il 78% del semilato identificano uno spigolo, altrimenti si prende la faccia raggiunta. Nei casi limite si preferisce una sigla esplicita.

Le uscite parallele fra la stessa coppia di stanze sono separate e tutte etichettate. Per esempio 69 → 64 ammette sia N sia DOWN: una sola etichetta avrebbe nascosto una delle due possibilità. Il tooltip continua a riportare la direzione anche sugli archi implicitamente corretti.

## Personaggi

Lo stato HTTP della partita include ora `characters`, ottenuto dai record correnti delle entità personali. Ogni elemento contiene ID, chiave stabile, nome, sigla, locazioni attive, genitore e flag del giocatore. Si legge il campo posizione aggiornato: Lestrade compare in 10 nello snapshot del primo prompt, non nella posizione 11 del payload prima dell’avvio.

I segnaposti occupano una riga dedicata nei riquadri. Sigla, colore e tooltip li rendono riconoscibili; la legenda riporta nomi e locazioni e consente di inquadrare un personaggio senza spostare Holmes. Se più di cinque personaggi si trovano nella stessa locazione, i primi quattro sono affiancati da un contatore degli altri, tutti comunque presenti nella legenda.

Il giocatore mantiene la chiave `player` e la sigla SH anche se cambia identità per un travestimento. Le identità alternative non producono copie del giocatore sulla mappa. I personaggi senza una locazione attiva restano nella legenda come «Fuori mappa»: non viene inventata una posizione. Sono distinti dagli attori-mezzi di trasporto, che qui non ricevono un segnaposto personale.

Allo stato iniziale vengono restituiti 18 personaggi logici, di cui 11 con posizione sulla mappa. Watson è nella stanza 8 anche se contenuto nella sua poltrona. Gli NPC rimangono fermi: i segnaposti si aggiornano da ogni risposta del server e seguiranno le variazioni di posizione quando attiveremo le loro sequenze. Per Holmes il seguito di movimento, teletrasporto e travestimenti è già verificato.

## Riproduzione

```sh
python3 -B sherlock-analisi/locazioni/verify_map_characters.py
node sherlock-analisi/locazioni/verify_edge_labels.cjs
```

Il primo verifica i 14 formati giorno/periodo, le posizioni, il seguito del giocatore, il travestimento e una variazione sintetica del campo posizione di Watson. Il secondo esercita le funzioni di produzione per otto direzioni implicite, undici casi con etichetta e il caso di uscite parallele. Rapporti JSON in `results/`. Le verifiche nel browser controllano anche allineamento dell’orologio, sigle effettivamente mostrate e segnaposti nei nodi.
