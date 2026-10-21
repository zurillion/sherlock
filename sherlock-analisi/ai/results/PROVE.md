# Prove AI sul codice originale

Tutti gli attori sono abilitati. Tick e locazioni sono decimali. Le fixture sono dichiarate; gli altri scenari partono dal prompt originale senza ricollocamenti. I semi sono applicati dopo il primo prompt. Per eventi e differenze completi vedere `npc-traces.json`.

## autonomous_seed_1

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `WAIT` | 2 → 6 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 6 → 11 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 11 → 16 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 16 → 21 | 8 / E79F | 19 / EB7B |
| `WAIT` | 21 → 26 | 8 / E79F | 21 / EB7F |
| `WAIT` | 26 → 31 | 8 / E79F | 22 / EBE3 |
| `WAIT` | 31 → 36 | 8 / E79F | 22 / EBE3 |
| `WAIT` | 36 → 41 | 8 / E789 | 22 / EBE3 |
| `WAIT` | 41 → 46 | 8 / E789 | 22 / EBE3 |
| `WAIT` | 46 → 51 | 8 / E789 | 22 / EBE3 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You wait. With an excited look on his face Watson says" Well here is a case that may interest you, it seems that two close friends, a Mrs Brown and a Mrs Jones, were murdered last night in separate incidents although apparently with the same weapon. The crimes occurred at their respective homes in the township of Leather Head and, because of the lack of murder weapon and apparent motive, the local police are completely baffled. They have called upon Scotland Yard for assistance and it appears that the famed detective Inspector Giles Lestrade has taken an interest in the case and will be going to the scene this morning."


## autonomous_seed_7

Seme: 7. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `WAIT` | 2 → 6 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 6 → 11 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 11 → 16 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 16 → 21 | 8 / E79F | 19 / EB7B |
| `WAIT` | 21 → 26 | 8 / E79F | 21 / EB7F |
| `WAIT` | 26 → 31 | 8 / E79F | 22 / EBE3 |
| `WAIT` | 31 → 36 | 8 / E789 | 22 / EBE3 |
| `WAIT` | 36 → 41 | 8 / E789 | 22 / EBE3 |
| `WAIT` | 41 → 46 | 8 / E789 | 22 / EBE3 |
| `WAIT` | 46 → 51 | 8 / E789 | 22 / EBE3 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You wait. With an excited look on his face Watson says" Well here is a case that may interest you, it seems that two close friends, a Mrs Brown and a Mrs Jones, were murdered last night in separate incidents although apparently with the same weapon. The crimes occurred at their respective homes in the township of Leather Head and, because of the lack of murder weapon and apparent motive, the local police are completely baffled. They have called upon Scotland Yard for assistance and it appears that the famed detective Inspector Giles Lestrade has taken an interest in the case and will be going to the scene this morning."


## watson_take

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "TAKE LAMP"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson takes the oil lamp.


## watson_impossible

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "TAKE ARMCHAIR"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson.


## watson_departure

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `OPEN YOUR DOOR` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WEST` | 3 → 4 | 8 / E79F | 10 / EBBB |
| `WAIT` | 4 → 9 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 9 → 14 | 8 / E79F | 1 / EBC5 |
| `WAIT` | 14 → 19 | 8 / E759 | 18 / EBD4 |
| `WAIT` | 19 → 24 | 8 / E759 | 20 / EB7D |
| `WAIT` | 24 → 29 | 8 / E759 | 22 / EBE3 |
| `WAIT` | 29 → 34 | 8 / E759 | 22 / EBE3 |
| `WAIT` | 34 → 39 | 0 / E794 | 22 / EBE3 |
| `WAIT` | 39 → 44 | 0 / E797 | 22 / EBE3 |
| `WAIT` | 44 → 49 | 0 / E797 | 22 / EBE3 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You open your door.

> You go west. You are in a hall. To the east there is your door. Below there is the stairway.


## watson_drop_follow

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "DROP THE DAILY CHRONICLE"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `OPEN YOUR DOOR` | 3 → 4 | 8 / E7B9 | 10 / EBBB |
| `WEST` | 4 → 5 | 7 / DD5F | 10 / EBBB |
| `WAIT` | 5 → 10 | 7 / E7C5 | 1 / EBC5 |
| `WAIT` | 10 → 15 | 7 / E7C5 | 1 / EBC5 |
| `WAIT` | 15 → 20 | 7 / E7C5 | 18 / EBD4 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson drops the daily chronicle.

> You open your door. Watson climbs out of watsons armchair.

> You go west. You are in a hall. To the east there is your door. Below there is the stairway. Watson enters.


## watson_follow_order

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "FOLLOW ME"` | 2 → 3 | 8 / E481 | 10 / EBAA |
| `OPEN YOUR DOOR` | 3 → 4 | 8 / E482 | 10 / EBBB |
| `WEST` | 4 → 5 | 7 / DD5F | 10 / EBBB |
| `WAIT` | 5 → 10 | 7 / DD60 | 1 / EBC5 |
| `WAIT` | 10 → 15 | 7 / DD60 | 1 / EBC5 |
| `WAIT` | 15 → 20 | 7 / DD60 | 18 / EBD4 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson climbs out of watsons armchair.

> You open your door.

> You go west. You are in a hall. To the east there is your door. Below there is the stairway. Watson enters.


## watson_innocent

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "WATSON IS INNOCENT"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson says" That is brilliant Holmes.".


## watson_accusation

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "BASIL KILLED MRS BROWN"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson remarks" That is brilliant Holmes, I do not know how you do it.".


## watson_tell

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "TELL ME ABOUT LESTRADE"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson says to you" I am sorry I cannot help you with that.".


## watson_statement

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "THE LAMP IS IN THE ROOM"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson remarks" What".


## watson_go

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "WEST"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson.


## watson_open_then_west

Seme: 1. Fixture: nessuna.

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO WATSON "OPEN YOUR DOOR. WEST"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Watson. Watson opens your door.


## lestrade_wait

Seme: 1. Fixture: Holmes e figli ricollocati in locazione10..

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO LESTRADE "WAIT"` | 2 → 3 | 8 / E79F | 10 / EBAA |
| `WAIT` | 3 → 7 | 8 / E79F | 1 / EBC5 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Inspector Lestrade. Inspector Lestrade remarks" Sorry, I cannot do that now." Inspector Lestrade hails the hansom cab. Inspector Lestrade with a surprised look on his face, says" Well, Holmes fancy seeing you here.". The cabbie remarks to Inspector Lestrade" Hello guv'nor.".

> You wait. Inspector Lestrade climbs into the hansom cab. Inspector Lestrade says to the cabbie" Go to Kings Cross Road.".


## lestrade_take

Seme: 1. Fixture: Lestrade e figli ricollocati in locazione8..

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO LESTRADE "TAKE LAMP"` | 2 → 3 | 8 / E79F | 8 / EBA6 |
| `WAIT` | 3 → 7 | 8 / E79F | 8 / EBA6 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Inspector Lestrade. Inspector Lestrade with a surprised look on his face, says" Well, Holmes fancy seeing you here.". Inspector Lestrade says to Watson" Hello". Watson says to Inspector Lestrade" Good morning ".


## lestrade_west

Seme: 1. Fixture: Lestrade e figli ricollocati in locazione8..

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO LESTRADE "WEST"` | 2 → 3 | 8 / E79F | 8 / EBA6 |
| `WAIT` | 3 → 7 | 8 / E79F | 8 / EBA6 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Inspector Lestrade. Inspector Lestrade remarks" Sorry, I cannot do that now." Inspector Lestrade with a surprised look on his face, says" Well, Holmes fancy seeing you here.". Inspector Lestrade says to Watson" Good morning ". Watson says to Inspector Lestrade" Good morning ".


## lestrade_wait_flag_clear

Seme: 1. Fixture: Holmes e figli ricollocati in locazione10; solo bit40 del byte E7E9 azzerato..

| Comando | Tick prima → dopo | Watson: stanza / programma | Lestrade: stanza / programma |
|---|---|---|---|
| `SAY TO LESTRADE "WAIT"` | 2 → 3 | 8 / E79F | 10 / E7E9 |
| `WAIT` | 3 → 7 | 8 / E79F | 10 / E7E9 |

Testo intercettato (sono omesse le sole righe ripetute “You wait.”):

> You talk to Inspector Lestrade. Inspector Lestrade waits. Inspector Lestrade with a surprised look on his face, says" Well, Holmes fancy seeing you here.".


