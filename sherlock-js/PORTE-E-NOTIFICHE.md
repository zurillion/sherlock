# Porte condivise e notifiche da altre stanze

26 ottobre 2026. Correzione del caso segnalato restando nella stanza di Holmes
con `WAIT UNTIL 11` e poi `WAIT UNTIL 11PM`, seed 1.

## Chi agiva

| Ora | Attore | Locazione reale | Azione |
|---|---|---|---|
| 11:58am | Straker | 068 dining room | apre |
| 12:01pm | Straker | 065 large kitchen | chiude |
| 12:06pm | Straker | 065 large kitchen | apre |
| 12:09pm | Straker | 068 dining room | chiude |
| 12:59pm | Lestrade | 099 dining room | apre |
| 01:02pm | Lestrade | 098 kitchen | chiude |
| 01:03pm | Lestrade | 098 kitchen | apre |
| 01:06pm | Lestrade | 099 dining room | chiude |

Holmes resta nella locazione 008 in tutta la prova. Nessuno di questi attori
sta arrivando nella sua stanza.

## Causa e condizione originale

L’entità 50, `plain door`, è un record unico a `$90CC`, con dieci locazioni:
65, 68, 98, 99, 34, 36, 8, 9, 57, 59. Porte di edifici diversi riusano
quindi l’identificatore. L’appartenenza di 008 alla lista non basta a
concludere che ogni azione sull’entità sia visibile da Holmes.

Il ramo CAAF controlla prima se l’attore è visibile. Per un oggetto presente
in più locazioni verifica la presenza della stanza del giocatore e passa
a CAF0, sostituendo temporaneamente l’attore con FF, «Someone». Ma non
è ancora una stampa: **CB01 chiama D471 e CB06 chiama CA76 soltanto se
la ricerca non restituisce FF**. D471 cerca, nelle uscite della stanza
dell’attore, una destinazione uguale alla stanza di Holmes.

La versione JS aveva ricostruito la presenza dell’entità e il soggetto
anonimo, omettendo quest’ultima ricerca. Questo faceva comparire in Baker
Street le aperture e chiusure di porte lontane. Ora `showAction` richiede
anche l’uscita dalla stanza dell’attore verso quella del giocatore.

Le notifiche anonime realmente locali restano: il precedente test con
Straker che chiude la porta della sala da pranzo mentre Holmes si trova
nella stanza adiacente continua a coincidere con l’originale. Non vengono
separate artificialmente le entità-porta né modificati gli eventi degli NPC.

## Prova differenziale

`tools/probe-shared-door.py` esegue i due comandi nell’originale offline,
con tutti i 24 slot attori, e registra gli otto passaggi in CAF0. Prima
si era visto che questo ramo veniva raggiunto negli stessi minuti anche
nell’originale; osservare il ramo non prova che il messaggio sia stampato.
Il confronto delle bitmap e la verifica di CB01 hanno stabilito che
l’originale rimane silenzioso per questi otto eventi.

`test/shared-door.test.mjs` confronta a ogni confine di minuto successivo
a uno degli otto eventi lo stato completo ricostruito, incluse le bitmap
superiore e inferiore, attori, entità, fatti, arena e stato casuale.
Controlla gli autori effettivi e l’assenza di messaggi «Someone». Prima
della correzione falliva alla bitmap superiore delle 11:59; dopo passa.
Questa prova dichiara il seed e il protocollo della fixture, non certifica
l’intero gioco o tutte le possibili condizioni di visibilità.

```sh
python3 tools/probe-shared-door.py --output test/fixtures/shared-door-reference.json
node --test test/shared-door.test.mjs test/fact-boundary.test.mjs
```

Il listing originale di CAAF/CAF0 e D471 è già in
`../sherlock-analisi/ai/results/random-input-code.asm`.
