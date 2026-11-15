# Da Brown al finale con Basil

Il percorso con seed 1 termina **mercoledì alle 06:07**, tick 2768. Da Camden Street Holmes va a est nel cortile di Basil e a nord-est attraverso la finestra. Nella camera trova Basil Phipps, che gli spara. Il gioco passa da `$DFCC`, confronta le due stanze a `$DFD7` e passa il messaggio `$75D2` a `$9E74`. Il finale richiede la conferma a video e poi congela la partita. È un finale di sconfitta. Il confronto dall’avvio coincide su 465 checkpoint, 6.527 estrazioni e 13.890 letture, inclusi bitmap, futuro dopo LOAD e stato congelato dopo la conferma.

[Comandi dall’avvio](results/brown-to-ending/dawn-full-route.txt) · [Comandi dal punto di ripresa Brown](results/brown-to-ending/dawn-route.txt) · [Traccia originale](results/brown-to-ending/dawn-native.json) · [Confronto del motore](results/brown-to-ending/dawn-native-comparison.json)

## Sequenza

- Martedì alle 11:36 si riparte dalla cucina di Tricia dopo l’indagine Brown. Si esce con tre comandi `N` e si attende fino alle 14:00 prima di chiamare il cab.
- Nel cab si dice prima `CAMDEN STREET`, si fa `WAIT`, quindi si dice `GO TO CAMDEN STREET`. La prima frase entra nella coda del dialogo anche quando il cocchiere non la esegue come ordine di viaggio.
- Si lascia che il cab termini la corsa e si paga con `PAY 10D TO CABBIE`. La tariffa è 3d e il resto 7d in questa partita. Dopo `GET OUT` si aspetta in strada.
- Dopo le 22 Basil apre la finestra. Da Camden Street, `WAIT UNTIL 6:05AM`, `E` e `NE` portano alla camera mentre Basil è presente.

## Blocchi trovati

| Indirizzo | Comportamento ricostruito |
|---|---|
| `$5D2A–$5D2B` | Indirizzo video salvato mentre si stampa lo spazio dopo il qualificatore di un passaggio. Il byte basso e quello alto hanno contratti indipendenti. Nel ramo passivo la cuoca legge il primo mercoledì alle 19:19 e il giardiniere legge il secondo alle 20:53. |
| `$A02D` | `$AE86` conserva la classe precedente mentre rilegge il separatore del comando. La cuoca legge il valore nella notte successiva al `WAIT UNTIL`. |
| `$A02E` | `$B3DA` inizializza il selettore della ricerca nominale e `$A4EB` lo imposta dopo il riconoscimento. La cuoca lo legge giovedì alle 03:49. |
| `$5D2C–$5D31` | Ultimi AF, BC e HL lasciati da `$C271–$C29B` durante la pulizia della console dopo il rifiuto di un esame. L’ultima cella inizia a x=246. |
| `$5D16–$5D19` | Nel salotto di Tricia, lo scorrimento dopo `wall` salva il byte alto video in `$5D17`. Il successivo `and` lo conserva. Nell’altra direzione, verso la cucina, `north` va a capo e la pulizia riscrive `$5D16–$5D17`. L’articolo del passaggio scarica poi `is`, che aggiorna `$5D18–$5D19`. |
| `$5C12–$5C13` | Il buffer della parola grezza riceve la `e` finale di `entrance` quando viene stampato il nome della stanza e la `t` finale di `northeast` quando viene stampata la direzione del passaggio. |
| `$B049–$B099`, `$B8AA–$B903`, `$D008–$D044` | La frase nominale entra come argomento di `TALK`. Il delimitatore e il puntatore aggiuntivo restano nella coda delle citazioni quando viene riletto il token di apertura. Il ripristino di un contesto di Watson osserva la richiesta del cocchiere ancora in coda. |
| `$5D19–$5D1A` | Il messaggio della tariffa `$6BB7` scarica `to` mentre comincia il nome del destinatario. L’ottava riga del font e lo shift del glifo `o` entrano nelle estrazioni successive. Pagamento, resto e uscita dal cab preservano lo shift nella geometria verificata. |

Le prove separano il caso naturale dalle configurazioni controllate. La traccia di Camden registra 135.454 scritture di stack, incluse quelle che lasciano il valore invariato. Tutte le transizioni osservate sono classificate. L’originale gira offline con tutti e 24 gli attori, schermate grafiche disattivate e conferme immediate. Il motore giocabile ricostruisce gli stessi valori dalle proprie strutture.

[Disassemblato annotato](results/brown-to-ending/brown-to-ending.asm) · [Verifica dell’atlante](results/memory-map-verification.json) · [Traccia del ritorno a capo e dell’articolo](results/brown-to-ending/passage-wrap-reads.json)

## Variante passiva

Restando nella cucina di Tricia con attese ripetute, l’originale continua fino a **lunedì successivo alle 10:00** senza un epilogo. Basil raggiunge mercoledì alle 15:20 l’attesa in `$EF90` e il salto indietro di `$EF93`. Lestrade rimane a `$EBC5`, in attesa di una condizione sul proprio veicolo. Questi stati valgono per questo percorso e per il seed 1.

Il ponte delle regole conserva due puntatori indipendenti a `$CB28–$CB2B`.
La traccia delle scritture osserva i seguenti risultati. Il motore
JavaScript li genera già a partire dalle regole e dai record del mondo.

| Ora (giovedì) | Lettura | Ultima regola e puntatore |
|---|---|---|
| 04:07 | `$CB28 = $9F` | `$DD6E` di Watson ha restituito IX `$879F`. |
| 05:37 | `$CB29 = $8D` | `$F19A` della cuoca ha conservato IX `$8D42`. |
| 07:06 | `$CB2A = $42` | `$DD07` del giardiniere ha restituito IY `$8D42`. |
| 08:40 | `$CB2B = $DD` | `$DD6E` di Watson ha lasciato IY sull’intestazione `$DD61`. |

Quando `EXAMINE ROCK` viene rifiutato martedì alle 11:36, il ritorno a
capo passa da `$C228` a `$C271`. La pulizia ridisegna 36 spazi larghi
sette pixel. Il glifo finale parte da x=246, con shift 6. Nel frame
`$5D3E`, `$C3B7` salva BC con B ancora a 1 e `$C3B8` salva AF con i
flag ricavati dallo shift e A dall’ottava riga del font. Il motore
conserva questi quattro byte in `$5D32–$5D35` e li legge quando
servono al generatore casuale. La stampa in linea senza ritorno a capo
non attiva questo salvataggio. Il puntatore video di `$5D36–$5D37`
viene riutilizzato da altri chiamanti.

Il secondo letterale vive in `$A031–$A032`. La word iniziale è zero.
Il writer `$B562` è dietro il selettore di classe del secondo argomento.
Nessun modello verbale originale usa la classe numerica 5 in quella
posizione. La cuoca legge `$A032` giovedì alle 09:55. Il primo letterale
usato da `WAIT UNTIL` e `PAY` resta indipendente.

Il lexer salva a `$DA32–$DA33` il limite esclusivo del gruppo scelto.
`$DA54` somma `$5DBF` all’offset del successivo gruppo non vuoto. Il
limite di `UNTIL` è `$670A`. `11PM` e il punto non lo cambiano. Il
giardiniere ne legge il byte basso giovedì alle 10:16.

Mercoledì alle 10:17 il cocchiere chiede la tariffa a Basil Phipps nella
locazione 18, mentre Holmes è nella 48. La richiesta non produce testo
visibile, ma `$A809` chiama comunque il decoder dell’articolo. Il flag
`$5C3C` spento fa uscire `$A887` prima del renderer. La word di ritorno
`$A80C` rimane a `$5D36–$5D37` al posto di `$50FE` e si ritrova nello
stato JavaScript del giovedì alle 10:00.

### Operandi, dizionario e orologio

- **Operandi e ordini.** `$CE4A` scrive il secondo operando prima
  della scelta casuale. Nel turno del giardiniere delle 14:29 i tre
  byte `$A033–$A035` sono `FF 28 FF`. Watson, invece, scrive l’ultimo
  destinatario con `$9CF3`. `$CC89` azzera l’ordine in corso a `$B934`
  mentre `$B93B` conserva l’ultimo opcode tentato a `$B935`. Il valore
  `$83` viene dall’ordine ricevuto dal cocchiere martedì alle 09:15.
- **Editor e BASIC.** `$D89B` carica 3000 a `$A03B–$A03C`. Le prove
  iniettano i tasti sopra la routine che consuma quel contatore.
  Il buffer delle parole riusa alcune variabili del BASIC, fra cui
  RASP, FLAGS, ERR-SP e MODE. Sono inizializzate dal loader e possono
  essere riscritte dal gioco. `$C03B` legge la porta della ZX Printer.
  Il motore legge i byte immutabili del test solo come ingressi casuali.
- **Tariffa fuori scena.** Il ritorno dell’articolo `$A80C`,
  l’indice dell’articolo, l’offset del testo, il record dell’attore e
  il puntatore della scelta restano a varie profondità fra
  `$5D36` e `$5D45`. Il successivo avvertimento del cocchiere
  sovrascrive l’ultima word. Il punto dell’annuncio del treno
  passa da `$C1E1` anche senza arrivare allo schermo.
- **Dizionario.** `$A95B` conserva il prefisso e scrive le nuove
  lettere. `$A92F` aggiunge anche il suffisso fisico con gli zeri
  dopo le lettere. Il lexer decodifica il candidato successivo
  prima di fermarsi. Dopo `UNTIL`, `UP` lascia `p` e zero, con
  la coda di `UNTIL` e dei candidati ancora precedenti.
- **Striscia dell’orologio.** `$C182` riempie i 32 attributi con
  `$78`. `$C1A8` parte da x=8 con uno spazio largo sette pixel,
  poi stampa il giorno a x=15 e aggiunge uno spazio a destra.
  Due letture di questa striscia, a `$5A40` e `$5242`, cambiano
  la scelta del giardiniere se si usa la geometria approssimata.

Il confronto dall’avvio coincide su 876 checkpoint, 16.171 estrazioni
e 34.412 letture fino alle 01:40 di sabato. Le verifiche includono la
ripresa da SAVE/LOAD e i pacchetti della schermata web. Il campione
successivo legge il ritorno AA00 a 5D49, lasciato da A9FD quando
l’annuncio del treno scarica il punto senza disegnarlo.

Il testo alternativo `$759C` è già verificato per l’apertura della
cassaforte. Resta da confrontare il percorso in cui il controllo
`$EFC7` lo seleziona da solo.

[Confronto passivo](results/brown-to-ending/native-tail-comparison.json) · [Letture del ponte](results/brown-to-ending/passive-bridge-reads.json) · [Letture della console](results/brown-to-ending/passive-console-reads.json) · [Tariffa fuori scena](results/brown-to-ending/passive-fare-name-words.json) · [Operandi](results/brown-to-ending/passive-domain-operands.json) · [Opcode degli ordini](results/brown-to-ending/passive-request-opcodes.json) · [Flag ROM](results/brown-to-ending/passive-rom-loader-flags.json) · [Candidati lessicali](results/brown-to-ending/passive-lexical-candidates.json) · [Bitmap dell’orologio](results/brown-to-ending/passive-status-clock.json) · [Traccia originale passiva](results/brown-to-ending/native-tail.json) · [Verifica del ramo della cassaforte](ALTRI-FINALI.md)

## Riproduzione

Dalla cartella del motore JavaScript, eseguire il confronto della storia
di Camden e quello della variante passiva.

```sh
node tools/verify-brown-ending.mjs dawn-native
node tools/verify-brown-ending.mjs native-tail
```

Per ripetere la traccia mirata dei glifi nell’originale usare
`python3 tools/probe-brown-ending-stack.py --passage-wrap`. Per il ramo
passivo usare `python3 tools/probe-brown-ending-stack.py --passive-console`.
