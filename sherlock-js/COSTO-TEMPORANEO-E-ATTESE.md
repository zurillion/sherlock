# Costo temporaneo condiviso e attese

## Stato funzionale

`A01F–A020` è una word globale: basso in A01F, alto in A020. Non coincide
con il costo locale del personaggio né con la durata residua del WAIT.
CC78 chiama CC5A, che a CC74 azzera entrambi i byte a ogni ingresso di passo
DOMAIN. Un fallimento può continuare internamente senza un nuovo ingresso.
Lo scheduler A0B3 ripete il personaggio se la word è zero; altrimenti somma
la word alla sua scadenza precedente.

Quando C989 supera i controlli e A00B indica esecuzione, CA09 pubblica
il nibble alto dell’intestazione, con byte alto zero, **prima del corpo**.
In preflight C9F2 ritorna senza questa scrittura. Un corpo può cambiare il
costo; non viene ripristinato automaticamente se successivamente fallisce.
La traduzione conserva lo stato condiviso e usa intestazioni estratte come
dati, senza eseguire Z80. Gli annunci differiti ricevono il costo prima
di scegliere e stampare il loro testo.

Le altre scritture identificate sono:

- 9B07: durata del viaggio del cab, dopo l’eventuale sottrazione a otto bit
  per la corsa furiosa, prima del trasferimento e degli annunci.
- B0BD/B0CC: richiesta LOAD/QUIT e SAVE, word uno.
- CD85/CD8E: yield, autoloop fallito o budget esaurito, word uno.
- DDC5: solo byte basso dal primo argomento. Il byte alto resta invariato;
  nel percorso ordinario la precedente intestazione lo ha già azzerato.
- DE42: risultato a sedici bit di WAIT UNTIL. Conserva l’aritmetica unsigned,
  i tag am/pm e la conversione originale delle ore zero.

Durante un WAIT UNTIL i successivi passi degli altri attori riscrivono
questa stessa word: nelle prove live compare, per esempio, una successione
di costi tre e quattro, pur essendo Holmes ancora in attesa. Non va
proiettata dalla scadenza del giocatore o riempita con zero.

Il salvataggio JSON conserva i due byte, inclusi eventuali valori sconosciuti.
Un vecchio salvataggio senza campo non riceve valori iniziali inventati:
soltanto nuove scritture reali ristabiliscono la proprietà dei byte.
Il nastro originale salva [840B,A01F), quindi esclude la word; il formato JSON
è l’adattatore dichiarato del prototipo, non una replica del nastro.
Anche LOAD/QUIT restano gli adattatori già dichiarati: B0BD è documentato
come scrittura originale, senza introdurre nel prototipo il suo reset del clock.

## Correzione emersa durante il confronto del cab

La sequenza naturale con Watson al seguito ha mostrato un errore precedente:
il prototipo permetteva GET OUT durante una corsa. L’intestazione E432 è
dato: costo due, predicato E420 e maschere che richiedono attributo80 e almeno
un bit28. Alla partenza il cab perde80. Il comando viene quindi rifiutato
senza scendere e senza pagare due minuti. Restano gli argomenti già risolti
nell’azione radice; il messaggio è `YOU CANNOT GET OUT OF THE HANSOM CAB.`,
con il punto finale. La prova confronta anche la bitmap inferiore.

## Prove e limiti

Sei sequenze naturali da seed 1, tutti i 24 posti attore, LOOK iniziale gratuito,
grafica nativa spenta dopo il boot, input maiuscolo e MORE immediato:
32 input, 97 checkpoint (inclusi i minuti live), 302 estrazioni e 614 letture.
Per ciascuna estrazione è confrontata anche la word del costo all’ingresso,
oltre a ogni draw/read. Si confrontano attori, entità, fatti, tutti i 752 byte
dell’arena, bitmap e seguito dopo LOAD. Le sequenze comprendono chiarimenti,
errori, WAIT UNTIL, ordini di attesa a Watson e viaggio in cab con rifiuto
in corsa. Una settima prova verifica scritture parziali, salvataggi e proprietà
sconosciuta dei vecchi file. Nessun fixture viene letto dal motore giocabile.

Il prefisso witness resta 338 checkpoint, 0–337, fino a **mercoledì 04:00**.
A020 è superato; il confronto completo incontra A11A nello stesso checkpoint 338
verso 04:10. È un temporaneo dell’allocatore, da ricostruire dai suoi scrittori.
Non è certificato un orario nuovo e nessuno dei cinque finali ancora aperti
viene dichiarato completato. Rapporto: `results/temporary-cost-verification.json`.

Suite completa: 775 test. I dettagli verificati e le impronte dei file serviti
sono in `results/temporary-cost/checks.json`.

## Atlante

153 istruzioni e 351 byte riassemblati e confrontati col payload. Le due
intestazioni 9AF4–9AF5 ed E432–E43A sono dati separati dai corpi Z80.

| Intervallo inclusivo | Analisi |
| --- | --- |
| A01F–A020 | Due byte del costo globale |
| 9AF1–9B09 | Cab normale/furioso: header e scrittura della durata |
| A0B0–A0C9 | Lettura del costo e aggiornamento della scadenza |
| B0AC–B0D6 | LOAD/QUIT e SAVE |
| B0EE–B0FC | Limiti del blocco nastro |
| C9F2–CA0B | Assegnazione del costo prima del corpo |
| CC71–CC93 | Reset all’ingresso DOMAIN |
| CD82–CD94 | Yield e budget dei fallimenti |
| D7D0–D7D8 | Verifica del costo restituito dall’azione |
| DDC2–DDCA | Scrittura del solo byte basso |
| DDD4–DE47 | Calcolo di WAIT UNTIL |
| E432–E44B | Header e corpo dell’uscita dal contenitore |

Passano da grigio a documentato 58 byte: 9AF1–9AF3, 9AF6–9B09,
DDC2–DDCA ed E432–E44B. A01F–A020 passa da parziale a documentato.
Gli altri intervalli sono approfondimenti. Restano 3.160 byte sconosciuti e 473
parziali; la copertura dell’atlante non certifica equivalenza dell’intero gioco.
