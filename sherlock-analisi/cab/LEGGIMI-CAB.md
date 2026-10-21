# Sherlock: il servizio dei cab, ricostruito dal codice originale

Fonte: ZX Spectrum v2.0, `block-10.bin`, SHA-256 `c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407`. Indirizzi esadecimali; ID, tick e importi in pence decimali. Il manuale e Foggy London sono indizi; le conclusioni sotto sono basate sui byte originali e sull’esecuzione Z80. Tutti gli NPC sono abilitati nelle prove, compreso Lestrade che utilizza autonomamente il primo cab.

## 1. Una corsa completa, senza modificare il mondo

Dal primo prompt originale:

```text
OPEN YOUR DOOR
WEST
DOWN
OPEN FRONT DOOR
SOUTH
HAIL CAB
GET INTO CAB
SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"
WAIT
WAIT
WAIT
GET OUT OF CAB
PAY 1/- TO CABBIE
```

Le tre attese sono la sequenza riprodotta con seme 1 nello snapshot analizzato, non un requisito grammaticale né un numero universale. Il personaggio e il mondo continuano ad agire durante il viaggio.

Frasi intercettate, con spaziatura normalizzata:

```text
You hail the hansom cab.
The cabbie says to you" Good morning guv'nor.".
You get into the hansom cab.
You talk to the cabbie.
You are in a hansom cab with the cabbie.
You are travelling the streets of London in a hansom cab,
the sun shines through the windows onto your face.
...
The hansom cab is in Buckingham Palace Road.
The cabbie remarks to you" Right guv'nor that will be 8d."
You get out of the hansom cab.
The cabbie, who now appears to be getting quite agitated,
says" What about me money guv'nor?".
You pay 1/- to the cabbie.
The cabbie pays 4d. To you.
```

`SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"` produce lo stesso viaggio normale. Il verbo che introduce le battute può variare: le formule di saluto e alcuni introduttori sono selezionati dal sistema di testo, non sono sempre stringhe identiche.

## 2. Quali entità partecipano

| Entità | ID | Record | Relazione iniziale |
|---|---:|---|---|
| Primo hansom cab | 30 | $8EF6 | Genitore FF, locazione 0. |
| Primo cabbie | 31 | $8F13 | Dentro il cab 30. |
| Conto del primo cabbie | 32 | $8F2C | Posseduto dal cabbie 31, saldo 0. |
| Secondo hansom cab | 33 | $8F3D | Genitore FF, locazione 0. |
| Secondo cabbie | 34 | $8F5A | Dentro il cab 33. |
| Conto del secondo cabbie | 35 | $8F73 | Posseduto dal cabbie 34, saldo 0. |
| Denaro di Holmes | 27 | $8EBE | Posseduto da Holmes, 1248d = £5 4/-. |

I due cocchieri eseguono lo stesso programma, inizialmente a `$F2B2`. Le righe scheduler sono `$98D0` e `$98D8`. Queste identità contano: un altro cocchiere ha un altro saldo. Nella corsa naturale Lestrade sta usando il cab 30, quindi Holmes ottiene il cab 33.

## 3. Chiamata e attese

HAIL, e l’alias GET del cab, selezionano la regola locale `$E2C7`.

- Il predicato `$E298` accetta solo gli ID 30/33, verifica con `$9C07` che la locazione corrente sia nella rete stradale, che il cab sia alla locazione 0 e che il suo cocchiere non abbia già un contesto sospeso.
- Il corpo `$E2CB` porta il cab alla strada del chiamante attraverso `$DD0E`, propagando lo spostamento ai figli. Il cocchiere è ricavato come `cab + 1`.
- `$E2EE` salva il programma del cocchiere e avvia `$F2B6`. Il contesto conserva chiamante e cab: qui FD indica il cliente e FC il veicolo, secondo i riferimenti dinamici della VM.
- `$F2B6` pronuncia il saluto `$6BAC`; `$F2BA` crea un contatore `4 + casuale(0..4)`. Se il cliente non sale, la sequenza può stampare `$6BF6` e far sparire il cab nella locazione 0.
- Dopo la salita usa un contatore `5 + casuale(0..3)`. Se non viene avviato un viaggio, può chiedere `$6C1B`: `Well are we goin' anywhere guv'nor?`, poi ricomincia l’attesa.

Sono contatori di visite al programma, non timer JavaScript né scadenze espresse direttamente in minuti. I costi delle richieste ricevute possono ritardare la ripresa del copione. La funzione casuale nativa non è stata assunta uniforme.

Salita e discesa sono le normali modifiche del contenimento: `$E3EA` / `$E413` e `$E432` / `$E43B`, entrambe con costo 2. La salita mette l’ID del cab nel genitore di Holmes; la discesa gli assegna il genitore esterno del cab. Il denaro resta figlio di Holmes e lo segue.

## 4. Come comprende la destinazione

Non c’è un confronto con una lista di frasi del tipo “se contiene Buckingham”. Il percorso è quello già studiato per gli ordini agli NPC:

```text
riga dell’utente
  → preflight lessicale, compresa la citazione
  → SAY TO: regola $DD9E e analisi della citazione $B86A
  → richiesta indirizzata al cocchiere nella lista con testa $9FEE
  → suo turno: $B936 riprende la semantica
  → $C4D1 esegue l’azione usando le sue regole locali
```

Per la richiesta riuscita la traccia registra **attore 34, azione 29, argomenti [28,255]**: GO TO, Buckingham Palace Road, secondo argomento assente. Il cocchiere risolve dunque lo stesso nome di locazione del parser del gioco. Il testo può essere sintatticamente valido ma la destinazione non essere servita.

Le regole locali sono:

| Azione | Regola | Funzione |
|---|---|---|
| TAKE TO, 45 | $E08D | Script a $E08F: verifica il passeggero e inoltra GO TO. |
| GO TO, 29 | $9AF4 | Viaggio ordinario. Corpo a $9AF6. |
| GO TO FURIOUSLY, 30 | $9AE1 | Viaggio accelerato. Corpo a $9AE3. |

TAKE ME TO, se Holmes non è salito, risponde `You have to get into the cab first.`. La regola GO TO muove invece il veicolo: nella prova impartita dalla strada, il cab arriva alla destinazione mentre Holmes rimane su Baker Street. Non va confusa con la verifica del passeggero di TAKE TO.

Risultati verificati:

- `GO TO VICTORIA STATION`: il nome è riconosciuto, ma la coppia non è nella tabella; `Sorry guv'nor I cannot get there from'ere`.
- `GO TO BAKER STREET` quando si è già su Baker Street: stesso rifiuto, perché non esiste una tratta da una strada a se stessa.
- `GO TO XYZZY`: errore lessicale nella zona utente, prima di parlare al cocchiere; nessun tempo consumato nella prova.
- Dopo `SAY TO CABBIE "WAIT"`, una riga `"GO TO BUCKINGHAM PALACE ROAD"` riutilizza il destinatario. L’ordine resta in attesa della scadenza del cocchiere: ricezione ed esecuzione possono avvenire in momenti differenti.

Per accelerare funzionano **`FURIOUSLY GO TO ...`** e **`GO FURIOUSLY TO ...`** dentro la citazione. La forma `GO TO ... FURIOUSLY` non produce il viaggio: il parser della citazione la rifiuta. Il solo `You talk to the cabbie.` non dimostra che l’ordine sia stato capito.

## 5. Grafo, prezzo e durata

La tabella `$9B7F–$9C05` contiene 45 triple `origine, destinazione, durata`; `$9C06` è il terminatore FF. `$9C07` cerca le coppie in entrambi i sensi. Sono tutte le 45 coppie fra dieci strade, quindi 90 direzioni servite. Non viene calcolato un cammino nel grafo delle uscite dei pedoni.

Le dieci destinazioni sono: Baker Street 5, Parliament Street 10, Slater Street 12, Aldergate Street 14, Kings Cross Road 18, Bishops Road 24, Buckingham Palace Road 28, Camden Street 32, Sidmouth Street 40, Portman Street 45. La grafia segue il database del gioco. La tabella completa è in `results/ROTTE.md`.

Per una durata di tabella `D`, `$9B25` dà:

```python
normal_time = D
normal_fare = 2 * (D // 5 + 1)
furious_time = D - 2
furious_fare = 6 * (D // 5 + 1)
```

Il prezzo non è semplicemente arrotondato per eccesso a blocchi di cinque: anche un multiplo esatto paga il blocco successivo, perché il codice somma prima di sottrarre cinque. La tariffa accelerata usa D originale ed è tripla; il tempo scende soltanto di due unità. La tratta da Parliament Street a Buckingham Palace Road ha D=2 e costo accelerato zero: non va forzato un minimo artificiale di un minuto.

Baker Street → Buckingham Palace Road: **costo normale 15, prezzo 8d; accelerato 13, prezzo 24d = 2/-**. I 180 confronti nativi verificano ogni tratta, nei due sensi e nelle due modalità.

Questi sono costi assegnati alla riga del cocchiere. Lo scheduler somma il costo alla **vecchia scadenza**, non sempre all’istante del comando. Nella corsa di prova l’ordine è eseguito al tick12, la scadenza precedente vale11, quindi 11+15=26 è il ritorno del cocchiere; Holmes osserva il risultato al prompt28 dopo WAIT. Non si deve sostituire questo meccanismo con “aspetta esattamente15 minuti dal click”.

## 6. Che cosa succede durante il viaggio

`$9B50` identifica il cab come `cocchiere - 1` e cerca la tratta. `$9B25` addebita il prezzo al **conto del cocchiere**, non al denaro di Holmes. `$9B04` imposta il costo e porta il cab e tutti i figli alla locazione **1**, la scena di transito londinese.

Il bit7 del byte+05 del cab viene spento da `$9C60`: nasconde il veicolo dall’esterno. I passeggeri e il cocchiere condividono il contenitore e possono interagire fra loro; in prova PAY funziona in viaggio. GET OUT fallisce (`you cannot get out of the hansom cab.`), senza cambiare stanza o tempo nella prova. Non è un sistema di spostamento fotogramma per fotogramma attraverso le strade intermedie.

La regola restituisce Carry con puntatore allo script `$F3AD`: è un’azione differita. Quando arriva la scadenza, `$F3AD` chiama `$9C41`, che riattiva il bit di visibilità e usa `$DD0E` per portare cab e figli alla destinazione salvata. Il resto del programma gestisce il conto. In questo intervallo lo scheduler continua a visitare gli altri personaggi.

## 7. Denaro, debito e resto

Il campo monetario è a +09/+0A dei record27/32/35. La decodifica aritmetica di `$E39C` è:

```python
signed_high = high if high < 128 else high - 256
pence = signed_high * 128 + (low & 127)
```

È un valore con segno a 15 bit, non una normale word unsigned. `$E38F` applica il formato inverso. I 16 valori di confronto includono negativi, passaggi 127/128 e limiti del campo.

Nel conto del cabbie:

- **saldo negativo:** tariffa ancora da incassare;
- **zero:** saldo regolato;
- **positivo:** importo da restituire/credito lasciato al cocchiere.

L’addebito normale8d trasforma il suo saldo da 0 a −8. La regola PAY `$E370` usa il predicato `$E345/$E34F`: controlla il denaro dell’attore, sottrae l’importo al suo record e lo aggiunge a quello del destinatario. Costo1. Se Holmes paga 4d, scende da 1248 a 1244 e il conto passa da −8 a −4; il cocchiere richiede soltanto le 4d residue. Pagando altre 4d, il conto arriva a 0.

Le richieste di pagamento sono gestite da `$F2FC–$F358`, con i predicati `$E63E` (negativo), `$E654` (positivo), `$E66F` (zero/assenza). `$E6BC` compone la battuta `$6BB7` e stampa l’importo residuo. I solleciti hanno contatori `5 + casuale(0..2)` e possono ripetersi.

Se il pagamento avviene in questa fase e porta il conto sopra zero, `$F3A2` chiama `$E506`: questa regola differita recupera l’importo con `$E518` e usa **la stessa regola PAY** per restituirlo dal cocchiere al cliente. Non crea monete-oggetto né cerca tagli di monete. Il conto torna a 0 e Holmes perde complessivamente soltanto la tariffa.

### Prima, durante o dopo?

| Momento | Risultato verificato |
|---|---|
| Dopo l’arrivo, 8d esatti | Saldo0; Holmes perde8d. |
| Dopo la discesa, 1/- contro8d | Protesta prima del pagamento; poi restituisce4d automaticamente. |
| Dopo l’arrivo, 4d e poi4d | Sollecita il residuo, poi saldo 0. |
| In anticipo, 1/- | Registra 12d di credito; addebita 8d alla partenza; restano 4d. Nella prova non restituisce automaticamente il resto all’arrivo né dopo altre due WAIT. |
| Durante il viaggio, 1/- | Stesso credito residuo4d, senza resto automatico nella prova. |
| Durante il viaggio, 8d esatti | Arriva con saldo 0, senza richiesta di denaro. |

Il credito anticipato non percorre necessariamente il ramo del pagamento dopo il sollecito: da qui la differenza. Per recuperarlo funziona `SAY TO CABBIE "PAY 4D TO ME"`: il cabbie esegue il normale PAY e restituisce le 4d. Questo comportamento va preservato se si vuole compatibilità, invece di correggerlo implicitamente nel porting.

Con literal validi ma importi superiori al denaro di Holmes, `PAY £9 TO CABBIE` e `PAY 200/- TO CABBIE`, il gioco risponde nel canale inferiore **`don't be silly.`**, senza pagamento o avanzamento del tempo. Il tentativo £99 è invece respinto dal riconoscitore del literal nello scenario: non viene presentato come prova di fondi insufficienti.

## 8. Se non si paga: protesta, fuga e incontro successivo

Si può scendere senza aver saldato. Il cabbie vede il cliente ancora sulla stessa strada e passa al ramo `$F32E`, che stampa `$6BC7`:

> What about me money guv'nor?

Se Holmes resta dentro, il prezzo viene ripetuto periodicamente. Se resta nei pressi del cab, la protesta può ripetersi; scendere non equivale a cancellare il debito.

Se si allontana, i test di contenimento/compresenza falliscono e il programma arriva a `$F359`, poi `$E70E`, testo `$6C54`:

> You bloody snob, watch out if we ever meet again.

`$E70E` forza anche la stampa nel caso in cui il cliente abbia già lasciato la scena, poi ripristina la precedente abilitazione dell’uscita. Non aggiunge qui un flag di rancore o una nuova azione di aggressione. `$F376` porta il cab alla locazione 0; `$F37A` scarica eventuali passeggeri rimasti nel suo contenitore prima del ritorno al programma precedente.

**Il saldo negativo sopravvive alla sparizione del cab.** La prova `same_cabbie_debt` ricolloca esclusivamente il cab alternativo per poter incontrare di nuovo lo stesso cocchiere: saluta ancora, consente la salita e accetta un altro viaggio. Alla vecchia tariffa 8d si aggiungono altre 8d; chiede **1/4, cioè 16d**. Dunque il seguito dimostrato della minaccia è un debito persistente, senza rifiuto del trasporto nella prova. Il conto appartiene al cocchiere, non è una tabella separata dei debiti di ogni cliente.

Un incontro senza tale fixture chiama invece il cab 30, libero, che ha saldo 0: per studiare le conseguenze bisogna distinguere le due identità anche se entrambe appaiono come “cabbie”. Non estendiamo questo risultato a ogni possibile evento futuro della partita.

## 9. Output e riproducibilità

- `cab.py`: estrazione delle 45 tratte, intestazioni, bytecode e testi; modello Python di prezzi e rappresentazione monetaria.
- `trace_cab.py`: sessione interattiva e scenari sul motore originale con tutti gli attori attivi.
- `verify_cab.py`: confronti fra modello Python e routine Z80, più verifiche sugli scenari salvati.
- `build_cab_listing.py`: listato misto; separa Z80, intestazioni, route e bytecode e ricompone 1466 byte identici al payload.
- `results/PROVE.md`: dialoghi e stati leggibili per scenario.
- `results/cab-traces.json`: comandi, testo, eventi, scadenze, posizioni, conti e stati prima/dopo.
- `results/ROTTE.md`, `BYTECODE.md`, `cab-data.json`, `cab.asm`, `verification.json`: tabelle, listato e riscontri dettagliati.

Il banco parte dal primo prompt originale, alle 08:01am; imposta il seme a1 in `$A037` e il cursore a0 in `$A039`, dopo quel prompt. Disabilita la grafica (`$A011=0`) e inietta i tasti nelle attese originali. Sono controlli del banco condivisi da tutti gli scenari; il ricollocamento di un veicolo è dichiarato separatamente nella sola prova dell’incontro con lo stesso cocchiere. L’avvio gratuito alle 08:00am dell’esploratore web è una scelta di presentazione già documentata, non una modifica di questo riferimento.

Aggiornamento successivo: il servizio cab è ora integrato nella pagina HTML, con i turni dei due cocchieri attivi; gli altri NPC restano sospesi. Vedere [CAB-WEB.md](../locazioni/CAB-WEB.md) per comandi, limiti e verifiche. Il banco di questa cartella continua invece ad abilitare tutti gli NPC. Le attese hardware/MORE del banco Python vengono soddisfatte automaticamente; non è un emulatore interattivo dello schermo Spectrum.
