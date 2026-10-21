# Bytecode del cab e regole differite

I byte di queste sequenze sono istruzioni della VM del gioco, non istruzioni Z80. FD/FC/FB sono riferimenti dinamici.

## $F2B2

| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |
|---|---|---|---|---|
| F2B2 | 0f | cede con costo 1 | F2B3 | — |
| F2B3 | 0e b2 f2 | salto assoluto | F2B2 | — |
| F2B6 | 05 fd ac 6b | parla a un destinatario testo $6BAC | F2BA | — |
| F2BA | 07 2f e5 04 04 | regola con argomenti $E52F 04,04 | F2BF | F2BF |
| F2BF | 03 a8 e5 | regola senza argomenti $E5A8 FF,FF | F2C2 | F2C2 |
| F2C2 | 81 82 d0 f2 | azione senza argomenti $E5FD azione 130 FF,FF | F2D0 | F2C6 |
| F2C6 | 83 7a e5 bf f2 | regola senza argomenti $E57A FF,FF | F2BF | F2CB |
| F2CB | 86 f6 6b 76 f3 | stampa testo testo $6BF6 | F376 | — |
| F2D0 | 03 88 e5 | regola senza argomenti $E588 FF,FF | F2D3 | F2D3 |
| F2D3 | 07 2f e5 05 03 | regola con argomenti $E52F 05,03 | F2D8 | F2D8 |
| F2D8 | 83 3e e6 eb f2 | regola senza argomenti $E63E FF,FF | F2EB | F2DD |
| F2DD | 03 a8 e5 | regola senza argomenti $E5A8 FF,FF | F2E0 | F2E0 |
| F2E0 | 83 7a e5 d8 f2 | regola senza argomenti $E57A FF,FF | F2D8 | F2E5 |
| F2E5 | 85 fd 1b 6c ba f2 | parla a un destinatario testo $6C1B | F2BA | — |
| F2EB | 82 82 fd ff fc f2 | azione con argomenti $E5FD azione 130 FD,FF | F2FC | F2F1 |
| F2F1 | 82 81 fd fb 2e f3 | azione con argomenti $E5D8 azione 129 FD,FB | F32E | F2F7 |
| F2F7 | 13 e6 e6 59 f3 | regola senza argomenti $E6E6 FF,FF | F2FC | F359 |
| F2FC | 03 88 e5 | regola senza argomenti $E588 FF,FF | F2FF | F2FF |
| F2FF | 07 2f e5 05 02 | regola con argomenti $E52F 05,02 | F304 | F304 |
| F304 | 83 54 e6 a2 f3 | regola senza argomenti $E654 FF,FF | F3A2 | F309 |
| F309 | 83 6f e6 66 f3 | regola senza argomenti $E66F FF,FF | F366 | F30E |
| F30E | 12 82 fd ff 2e f3 | azione con argomenti $E5FD azione 130 FD,FF | F314 | F32E |
| F314 | 03 a8 e5 | regola senza argomenti $E5A8 FF,FF | F317 | F317 |
| F317 | 83 7a e5 04 f3 | regola senza argomenti $E57A FF,FF | F304 | F31C |
| F31C | 83 54 e6 a2 f3 | regola senza argomenti $E654 FF,FF | F3A2 | F321 |
| F321 | 83 6f e6 69 f3 | regola senza argomenti $E66F FF,FF | F369 | F326 |
| F326 | 07 bc e6 fd fb | regola con argomenti $E6BC FD,FB | F32B | F32B |
| F32B | 0e ff f2 | salto assoluto | F2FF | — |
| F32E | 03 88 e5 | regola senza argomenti $E588 FF,FF | F331 | F331 |
| F331 | 06 c7 6b | stampa testo testo $6BC7 | F334 | — |
| F334 | 07 2f e5 05 02 | regola con argomenti $E52F 05,02 | F339 | F339 |
| F339 | 83 54 e6 a2 f3 | regola senza argomenti $E654 FF,FF | F3A2 | F33E |
| F33E | 83 6f e6 66 f3 | regola senza argomenti $E66F FF,FF | F366 | F343 |
| F343 | 82 82 fd ff fc f2 | azione con argomenti $E5FD azione 130 FD,FF | F2FC | F349 |
| F349 | 12 81 fd fb 59 f3 | azione con argomenti $E5D8 azione 129 FD,FB | F34F | F359 |
| F34F | 03 a8 e5 | regola senza argomenti $E5A8 FF,FF | F352 | F352 |
| F352 | 93 7a e5 39 f3 31 f3 | regola senza argomenti $E57A FF,FF | F339 | F331 |
| F359 | 03 88 e5 | regola senza argomenti $E588 FF,FF | F35C | F35C |
| F35C | 03 0e e7 | regola senza argomenti $E70E FF,FF | F35F | F35F |
| F35F | 93 e6 e6 fc f2 76 f3 | regola senza argomenti $E6E6 FF,FF | F2FC | F376 |
| F366 | 03 88 e5 | regola senza argomenti $E588 FF,FF | F369 | F369 |
| F369 | 0f | cede con costo 1 | F36A | — |
| F36A | 0f | cede con costo 1 | F36B | — |
| F36B | 82 82 fd ff d0 f2 | azione con argomenti $E5FD azione 130 FD,FF | F2D0 | F371 |
| F371 | 83 e6 e6 e5 f2 | regola senza argomenti $E6E6 FF,FF | F2E5 | F376 |
| F376 | 02 80 fc 00 | azione con argomenti $E497 azione 128 FC,00 | F37A | F37A |
| F37A | 83 80 f3 7a f3 | regola senza argomenti $F380 FF,FF | F37A | F37F |
| F37F | 0b | ritorna con successo | F380 | — |
## $F384

| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |
|---|---|---|---|---|
| F384 | 02 80 fd 00 | azione con argomenti $E497 azione 128 FD,00 | F388 | F388 |
| F388 | 0b | ritorna con successo | F389 | — |
## $F3A2

| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |
|---|---|---|---|---|
| F3A2 | 03 88 e5 | regola senza argomenti $E588 FF,FF | F3A5 | F3A5 |
| F3A5 | 07 06 e5 fb fd | regola con argomenti $E506 FB,FD | F3AA | F3AA |
| F3AA | 0e 69 f3 | salto assoluto | F369 | — |
| F3AD | 07 41 9c fd ff | regola con argomenti $9C41 FD,FF | F3B2 | F3B2 |
| F3B2 | 83 54 e6 c1 f3 | regola senza argomenti $E654 FF,FF | F3C1 | F3B7 |
| F3B7 | 83 6f e6 c1 f3 | regola senza argomenti $E66F FF,FF | F3C1 | F3BC |
| F3BC | 07 bc e6 fc fb | regola con argomenti $E6BC FC,FB | F3C1 | F3C1 |
| F3C1 | 0b | ritorna con successo | F3C2 | — |
## $E08F

| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |
|---|---|---|---|---|
| E08F | 87 fd e5 fd ff 9b e0 | regola con argomenti $E5FD FD,FF | E09B | E096 |
| E096 | 05 fd 9e 6b | parla a un destinatario testo $6B9E | E09A | — |
| E09A | 0b | ritorna con successo | E09B | — |
| E09B | 02 1d fc ff | azione con argomenti azione 29 FC,FF | E09F | E09F |
| E09F | 0b | ritorna con successo | E0A0 | — |
## $E508

| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |
|---|---|---|---|---|
| E508 | c7 18 e5 fd fc 10 e5 | regola con argomenti $E518 FD,FC | E510 | E50F |
| E50F | 0a | ritorna con fallimento | E510 | — |
| E510 | 57 70 e3 fd fc 0f e5 | regola con argomenti $E370 FD,FC | E517 | E50F |
| E517 | 0b | ritorna con successo | E518 | — |
