# Inventario delle azioni e copertura dell’audit

Baseline `fc50b3c`. Le parole sono i quattro campi del modello lessicale, non una promessa che ogni combinazione inglese venga accettata. “Dispatch osservato” significa ingresso in C4D1, anche per un tentativo che fallisce. Un modello non osservato in questo audit può essere già coperto da altre prove. Le associazioni alle regole sono quelle del payload iniziale.

| ID | Modello: verbo / prep. / prep. / modificatore | Regola generale | Regole locali | Dispatch nell’audit |
|---:|---|---|---:|---|
| 1 | north / — / — / go | $DD03 | 0 | sì |
| 2 | south / — / — / go | $DD03 | 0 | non osservato |
| 3 | east / — / — / go | $DD03 | 0 | non osservato |
| 4 | west / — / — / go | $DD03 | 0 | sì |
| 5 | northeast / — / — / go | $DD03 | 0 | non osservato |
| 6 | northwest / — / — / go | $DD03 | 0 | non osservato |
| 7 | southeast / — / — / go | $DD03 | 0 | non osservato |
| 8 | southwest / — / — / go | $DD03 | 0 | non osservato |
| 9 | up / — / — / go | $DD03 | 0 | non osservato |
| 10 | down / — / — / go | $DD03 | 0 | non osservato |
| 11 | carry / — / — / — | $DCC1 | 0 | sì |
| 12 | climb / into / — / — | — | 14 | sì |
| 13 | climb / out / of / — | — | 14 | sì |
| 14 | close / — / — / — | — | 24 | sì |
| 15 | count / — / — / — | — | 2 | sì |
| 16 | drop / — / — / — | $DC8D | 0 | non osservato |
| 17 | drop / in / — / — | $DEC1 | 0 | non osservato |
| 18 | enter / — / — / — | $DD52 | 0 | sì |
| 19 | examine / — / — / — | $DF40 | 0 | sì |
| 20 | examine / — / — / closely | $E135 | 4 | non osservato |
| 21 | follow / — / — / — | $E452 | 0 | sì |
| 22 | come / with / — / — | $E452 | 0 | sì |
| 23 | get / — / — / — | $DCC1 | 3 | sì |
| 24 | get / into / — / — | — | 14 | sì |
| 25 | get / out / of / — | — | 14 | non osservato |
| 26 | give / to / — / — | $DF02 | 0 | sì |
| 27 | go / into / — / — | $DD52 | 0 | non osservato |
| 28 | go / through / — / — | $DC57 | 0 | non osservato |
| 29 | go / to / — / — | — | 3 | non osservato |
| 30 | go / to / — / furiously | — | 3 | non osservato |
| 31 | hail / — / — / — | — | 2 | non osservato |
| 32 | hello / — / — / — | $9A7E | 0 | sì |
| 33 | inventory / — / — / — | $DE6F | 0 | sì |
| 34 | look / — / — / — | $DC7B | 0 | sì |
| 35 | look / through / — / — | $DC19 | 0 | sì |
| 36 | open / — / — / — | — | 24 | sì |
| 37 | pay / to / — / — | $E370 | 0 | sì |
| 38 | put / in / — / — | $DEC1 | 0 | non osservato |
| 39 | put / on / — / — | $DEC1 | 0 | sì |
| 40 | sit / in / — / — | — | 3 | sì |
| 41 | take / — / — / — | $DCC1 | 1 | sì |
| 42 | take / from / — / — | $DCC1 | 0 | sì |
| 43 | take / off / — / — | — | 2 | sì |
| 44 | take / out / of / — | $DCC1 | 1 | non osservato |
| 45 | take / to / — / — | — | 2 | non osservato |
| 46 | talk / to / — / — | $DD9E | 0 | sì |
| 47 | tell / — / — / — | $E1D6 | 2 | non osservato |
| 48 | tell / about / — / — | $E1D6 | 2 | non osservato |
| 49 | wait / here / — / — | $DDB4 | 0 | non osservato |
| 50 | wait / until / — / — | $DDD0 | 0 | non osservato |
| 51 | wear / — / — / — | — | 2 | sì |
| 52 | kill / — / — / — | $9FC5 | 0 | non osservato |
| 53 | lock / — / — / — | — | 0 | non osservato |
| 54 | unlock / — / — / — | — | 0 | non osservato |

## Come leggere i risultati

L’audit esegue 70 comandi e raggiunge l’esecutore per 27 dei 54 modelli. Questa è una misura della prova corrente, non una percentuale del gioco implementato.

LOCK e UNLOCK hanno modelli (53/54), ma nel catalogo iniziale non hanno associazioni generali o locali; nello stato provato vengono rifiutati. Non si può dedurre dal manuale che manchi una loro traduzione Python: il comando passa già dal codice originale.

I dettagli per ogni caso, incluse domande, rifiuti, errori del ponte e buffer normalizzato quando valido, sono in `gameplay-audit.json`. Il report conserva anche il confronto originale su una riga lunga 74 caratteri.
