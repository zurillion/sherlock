# Riepilogo delle prove di esecuzione

Le fixture sono stati alterati intenzionalmente, non partite raggiunte seguendo una soluzione. Tutti gli indirizzi e le modifiche ai record sono nel JSON completo. La tabella include spoiler.

| # | Comando | Stato di partenza | Tempo globale | Riscontro |
|---:|---|---|---|---|
| 1 | `TAKE LAMP` | prompt originale | 2 → 3 | You take the oil lamp. |
| 2 | `TAKE LAMP` | dopo TAKE LAMP | 3 → 3 | you cannot take the lamp |
| 3 | `GIVE LAMP TO WATSON` | dopo TAKE LAMP, TAKE LAMP | 3 → 4 | You give the oil lamp to Watson. |
| 4 | `GIVE LAMP TO WATSON` | prompt originale | 2 → 2 | you cannot give the lamp |
| 5 | `TAKE ARMCHAIR` | prompt originale | 2 → 2 | i see no armchair that you can take |
| 6 | `OPEN YOUR DOOR` | prompt originale | 2 → 3 | You open your door. |
| 7 | `OPEN YOUR DOOR` | dopo OPEN YOUR DOOR | 3 → 3 | your door is open |
| 8 | `CLOSE YOUR DOOR` | dopo OPEN YOUR DOOR, OPEN YOUR DOOR | 3 → 4 | You close your door. |
| 9 | `OPEN LAMP` | prompt originale | 2 → 2 | you cannot open the lamp |
| 10 | `OPEN DOOR` | prompt originale | 2 → 2 | which door ? |
| 11 | `SAY TO WATSON "LOOK"` | prompt originale | 2 → 3 | You talk to Watson. |
| 12 | `"LOOK"` | dopo SAY TO WATSON "LOOK" | 3 → 4 | You talk to Watson. |
| 13 | `SAY TO WATSON "TAKE LAMP"` | prompt originale | 2 → 3 | You talk to Watson. Watson takes the oil lamp. |
| 14 | `SAY TO WATSON "THE"` | prompt originale | 2 → 3 | You talk to Watson. |
| 15 | `SAY TO ARMCHAIR "LOOK"` | prompt originale | 2 → 2 | i see no armchair that you can talk to |
| 16 | `OPEN YOUR DOOR` | porta bloccata | 2 → 2 | your door is locked |
| 17 | `SAY TO MRS BROWN "LOOK"` | Mrs Brown resa percepibile nella stanza iniziale | 2 → 3 | You talk to Mrs Brown. |
| 18 | `TAKE NOTE` | Holmes nella stanza35; nota85 resa visibile; timer9CA1=1 | 2 → 3 | You take the burning note. |
| 19 | `TAKE NOTE` | Holmes nella stanza35; nota85 resa visibile; timer9CA1=10 | 2 → 3 | You take the burning note. |
| 20 | `OPEN WALL SAFE` | Holmes nella stanza47, cassaforte86 | 2 → 17 | You open the wall safe. |
| 21 | `OPEN WALL SAFE` | Holmes nella stanza58, cassaforte89 | fine partita; arresto prima I/O | You open the wall safe. Basil enters and says " Holmes, yourinterference is becoming annoying. ". Pulling a gun he shoots you. Perhaps you should try again. |
