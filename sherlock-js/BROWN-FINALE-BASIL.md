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

Il motore autonomo è stato confrontato su 603 checkpoint di questa variante fino a giovedì alle 05:30. Il modello incontra `$CB29` alle 05:37, nella finestra del successivo checkpoint originale delle 05:40. Il relativo residuo del ritorno di regola è ancora da ricostruire. Il testo alternativo `$759C` è già verificato per l’apertura della cassaforte. Rimane da confrontare il percorso in cui il controllo `$EFC7` lo seleziona da solo.

[Confronto passivo](results/brown-to-ending/native-tail-comparison.json) · [Traccia originale passiva](results/brown-to-ending/native-tail.json) · [Verifica del ramo della cassaforte](ALTRI-FINALI.md)

## Riproduzione

Dalla cartella del motore JavaScript, eseguire il confronto della storia
di Camden e quello della variante passiva.

```sh
node tools/verify-brown-ending.mjs dawn-native
node tools/verify-brown-ending.mjs native-tail
```

Per ripetere la traccia mirata dei glifi nell’originale usare
`python3 tools/probe-brown-ending-stack.py --passage-wrap`.
