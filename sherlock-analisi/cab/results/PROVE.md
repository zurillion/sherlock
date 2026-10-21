# Prove del servizio cab sullo Z80 originale

Tutti gli attori sono attivi. I rami riprendono memoria e registri dello stesso checkpoint naturale. Un solo scenario ricolloca esplicitamente il cab alternativo: vedere la fixture. Tick e importi in pence. Testo originale con spaziatura normalizzata.

## natural_arrival

Nessun ricollocamento o modifica al mondo.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `OPEN YOUR DOOR` | 2 → 3 | 8 / 255 | 1248 | 0 |
| `WEST` | 3 → 4 | 7 / 255 | 1248 | 0 |
| `DOWN` | 4 → 6 | 6 / 255 | 1248 | 0 |
| `OPEN FRONT DOOR` | 6 → 7 | 6 / 255 | 1248 | 0 |
| `SOUTH` | 7 → 9 | 5 / 255 | 1248 | 0 |
| `HAIL CAB` | 9 → 10 | 5 / 255 | 1248 | 0 |
| `GET INTO CAB` | 10 → 12 | 5 / 33 | 1248 | 0 |
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |

`OPEN YOUR DOOR`

> You open your door.

`WEST`

> You go west. You are in a hall. To the east there is your door. Below there is the stairway.

`DOWN`

> You go down. You are in an entrance hallway. Above there is the stairway. To the south there is the front door.

`OPEN FRONT DOOR`

> You open the front door.

`SOUTH`

> You go south. You are on Baker Street. To the north there is the front door.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`GET INTO CAB`

> You get into the hansom cab.

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

## exact

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `PAY 8D TO CABBIE` | 28 → 29 | 28 / 33 | 1240 | 0 |
| `GET OUT OF CAB` | 29 → 31 | 28 / 255 | 1240 | 0 |
| `WAIT` | 31 → 36 | 28 / 255 | 1240 | 0 |

`PAY 8D TO CABBIE`

> You pay 8d. To the cabbie.

`GET OUT OF CAB`

> You get out of the hansom cab.

## overpay

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `GET OUT OF CAB` | 28 → 30 | 28 / 255 | 1248 | -8 |
| `PAY 1/- TO CABBIE` | 30 → 31 | 28 / 255 | 1240 | 0 |
| `WAIT` | 31 → 36 | 28 / 255 | 1240 | 0 |

`GET OUT OF CAB`

> You get out of the hansom cab. The cabbie, who now appears to be getting quite agitated, says" What about me money guv'nor?".

`PAY 1/- TO CABBIE`

> You pay 1/- to the cabbie. The cabbie pays 4d. To you.

## underpay

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `PAY 4D TO CABBIE` | 28 → 29 | 28 / 33 | 1244 | -4 |
| `WAIT` | 29 → 34 | 28 / 33 | 1244 | -4 |
| `PAY 4D TO CABBIE` | 34 → 35 | 28 / 33 | 1240 | 0 |
| `GET OUT OF CAB` | 35 → 37 | 28 / 255 | 1240 | 0 |
| `WAIT` | 37 → 42 | 28 / 255 | 1240 | 0 |

`PAY 4D TO CABBIE`

> You pay 4d. To the cabbie.

`WAIT`

> You wait. The cabbie says to you" Right guv'nor that will be 4d."

`PAY 4D TO CABBIE`

> You pay 4d. To the cabbie.

`GET OUT OF CAB`

> You get out of the hansom cab.

## unpaid_wait

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `WAIT` | 28 → 33 | 28 / 33 | 1248 | -8 |
| `WAIT` | 33 → 38 | 28 / 33 | 1248 | -8 |
| `WAIT` | 38 → 43 | 28 / 33 | 1248 | -8 |
| `WAIT` | 43 → 48 | 28 / 33 | 1248 | -8 |
| `WAIT` | 48 → 53 | 28 / 33 | 1248 | -8 |

`WAIT`

> You wait. The cabbie says to you" Right guv'nor that will be 8d."

`WAIT`

> You wait. The cabbie says to you" Right guv'nor that will be 8d."

`WAIT`

> You wait. The cabbie says to you" Right guv'nor that will be 8d."

`WAIT`

> You wait. The cabbie says to you" Right guv'nor that will be 8d."

## unpaid_leave

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `GET OUT OF CAB` | 28 → 30 | 28 / 255 | 1248 | -8 |
| `EAST` | 30 → 32 | 29 / 255 | 1248 | -8 |
| `WAIT` | 32 → 37 | 29 / 255 | 1248 | -8 |
| `WAIT` | 37 → 42 | 29 / 255 | 1248 | -8 |
| `WAIT` | 42 → 47 | 29 / 255 | 1248 | -8 |

`GET OUT OF CAB`

> You get out of the hansom cab. The cabbie, who now appears to be getting quite agitated, says" What about me money guv'nor?".

`EAST`

> You go east. You are at Victoria Station. Visible exits are west east. The cabbie shouts" You bloody snob, watch out if we ever meet again".

## currency_99_literal_rejected

Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `PAY £99 TO CABBIE` | 28 → 28 | 28 / 33 | 1248 | -8 |

Canale inferiore: i do not know the word"£99 "

## prepay

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `PAY 1/- TO CABBIE` | 12 → 13 | 5 / 33 | 1236 | 12 |
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 13 → 14 | 1 / 33 | 1236 | 4 |
| `WAIT` | 14 → 19 | 1 / 33 | 1236 | 4 |
| `WAIT` | 19 → 24 | 1 / 33 | 1236 | 4 |
| `WAIT` | 24 → 29 | 28 / 33 | 1236 | 4 |

`PAY 1/- TO CABBIE`

> You pay 1/- to the cabbie.

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east.

## pay_in_transit

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `PAY 1/- TO CABBIE` | 13 → 14 | 1 / 33 | 1236 | 4 |
| `WAIT` | 14 → 19 | 1 / 33 | 1236 | 4 |
| `WAIT` | 19 → 24 | 1 / 33 | 1236 | 4 |
| `WAIT` | 24 → 29 | 28 / 33 | 1236 | 4 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`PAY 1/- TO CABBIE`

> You pay 1/- to the cabbie.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east.

## destination_station

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO VICTORIA STATION"` | 12 → 13 | 5 / 33 | 1248 | 0 |

`SAY TO CABBIE "GO TO VICTORIA STATION"`

> You talk to the cabbie. The cabbie replies" Sorry guv'nor I cannot get there from'ere".

## destination_unknown

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO XYZZY"` | 12 → 12 | 5 / 33 | 1248 | 0 |

Canale inferiore: i do not know the word"XYZZY "

## destination_same

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BAKER STREET"` | 12 → 13 | 5 / 33 | 1248 | 0 |

`SAY TO CABBIE "GO TO BAKER STREET"`

> You talk to the cabbie. The cabbie replies" Sorry guv'nor I cannot get there from'ere".

## take_me

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |

`SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

## furiously_wrong_position

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD FURIOUSLY"` | 12 → 13 | 5 / 33 | 1248 | 0 |
| `WAIT` | 13 → 18 | 5 / 33 | 1248 | 0 |
| `WAIT` | 18 → 23 | 5 / 33 | 1248 | 0 |
| `WAIT` | 23 → 28 | 5 / 33 | 1248 | 0 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD FURIOUSLY"`

> You talk to the cabbie.

`WAIT`

> You wait. The cabbie remarks to you" Well are we goin' anywhere guv'nor?".

`WAIT`

> You wait. The cabbie remarks to you" Well are we goin' anywhere guv'nor?".

## exit_in_transit

Ramo dalla salita naturale, memoria e registri conservati.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `GET OUT OF CAB` | 13 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

Canale inferiore: you cannot get out of the hansom cab.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

## not_aboard

Nessun ricollocamento o modifica al mondo.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `OPEN YOUR DOOR` | 2 → 3 | 8 / 255 | 1248 | 0 |
| `WEST` | 3 → 4 | 7 / 255 | 1248 | 0 |
| `DOWN` | 4 → 6 | 6 / 255 | 1248 | 0 |
| `OPEN FRONT DOOR` | 6 → 7 | 6 / 255 | 1248 | 0 |
| `SOUTH` | 7 → 9 | 5 / 255 | 1248 | 0 |
| `HAIL CAB` | 9 → 10 | 5 / 255 | 1248 | 0 |
| `SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"` | 10 → 11 | 5 / 255 | 1248 | 0 |
| `WAIT` | 11 → 16 | 5 / 255 | 1248 | 0 |
| `WAIT` | 16 → 21 | 5 / 255 | 1248 | 0 |
| `WAIT` | 21 → 26 | 5 / 255 | 1248 | 0 |

`OPEN YOUR DOOR`

> You open your door.

`WEST`

> You go west. You are in a hall. To the east there is your door. Below there is the stairway.

`DOWN`

> You go down. You are in an entrance hallway. Above there is the stairway. To the south there is the front door.

`OPEN FRONT DOOR`

> You open the front door.

`SOUTH`

> You go south. You are on Baker Street. To the north there is the front door.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. The cabbie remarks to you" You have to get into the cab first.".

`WAIT`

> You wait. With a practised flick of the reins, the cabbie moves on down the street in search of other fares.

## furious_prefix

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "FURIOUSLY GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -24 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -24 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -24 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -24 |

`SAY TO CABBIE "FURIOUSLY GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie says to you" Right guv'nor that will be 2/-"

## furious_inside

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO FURIOUSLY TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -24 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -24 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -24 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -24 |

`SAY TO CABBIE "GO FURIOUSLY TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie says to you" Right guv'nor that will be 2/-"

## prepay_refund_requested

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `PAY 1/- TO CABBIE` | 12 → 13 | 5 / 33 | 1236 | 12 |
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 13 → 14 | 1 / 33 | 1236 | 4 |
| `WAIT` | 14 → 19 | 1 / 33 | 1236 | 4 |
| `WAIT` | 19 → 24 | 1 / 33 | 1236 | 4 |
| `WAIT` | 24 → 29 | 28 / 33 | 1236 | 4 |
| `WAIT` | 29 → 34 | 28 / 33 | 1236 | 4 |
| `WAIT` | 34 → 39 | 28 / 33 | 1236 | 4 |
| `SAY TO CABBIE "PAY 4D TO ME"` | 39 → 40 | 28 / 33 | 1240 | 0 |
| `GET OUT OF CAB` | 40 → 42 | 28 / 255 | 1240 | 0 |
| `WAIT` | 42 → 47 | 28 / 255 | 1240 | 0 |

`PAY 1/- TO CABBIE`

> You pay 1/- to the cabbie.

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east.

`WAIT`

> You wait. The cabbie says to you" Well are we goin' anywhere guv'nor?".

`SAY TO CABBIE "PAY 4D TO ME"`

> You talk to the cabbie. The cabbie pays 4d. To you.

`GET OUT OF CAB`

> You get out of the hansom cab. The cabbie remarks to you" Well are we goin' anywhere guv'nor?".

`WAIT`

> You wait. With a practised flick of the reins, the cabbie moves on down the street in search of other fares.

## transit_exact

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `PAY 8D TO CABBIE` | 13 → 14 | 1 / 33 | 1240 | 0 |
| `WAIT` | 14 → 19 | 1 / 33 | 1240 | 0 |
| `WAIT` | 19 → 24 | 1 / 33 | 1240 | 0 |
| `WAIT` | 24 → 29 | 28 / 33 | 1240 | 0 |
| `GET OUT OF CAB` | 29 → 31 | 28 / 255 | 1240 | 0 |
| `WAIT` | 31 → 36 | 28 / 255 | 1240 | 0 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`PAY 8D TO CABBIE`

> You pay 8d. To the cabbie.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east.

`GET OUT OF CAB`

> You get out of the hansom cab.

`WAIT`

> You wait. The cabbie says to you" Well are we goin' anywhere guv'nor?".

## insufficient_funds_valid

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |
| `PAY £9 TO CABBIE` | 28 → 28 | 28 / 33 | 1248 | -8 |
| `PAY 200/- TO CABBIE` | 28 → 28 | 28 / 33 | 1248 | -8 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

Canale inferiore: don't be silly.

Canale inferiore: don't be silly.

## bare_quote

Ramo dalla salita naturale

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "WAIT"` | 12 → 13 | 5 / 33 | 1248 | 0 |
| `"GO TO BUCKINGHAM PALACE ROAD"` | 13 → 14 | 5 / 33 | 1248 | 0 |
| `WAIT` | 14 → 19 | 1 / 33 | 1248 | -8 |
| `WAIT` | 19 → 24 | 1 / 33 | 1248 | -8 |
| `WAIT` | 24 → 29 | 1 / 33 | 1248 | -8 |

`SAY TO CABBIE "WAIT"`

> You talk to the cabbie. The cabbie waits.

`"GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie.

`WAIT`

> You wait. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

## meet_again

Nessun ricollocamento o modifica al mondo.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |
| `GET OUT OF CAB` | 28 → 30 | 28 / 255 | 1248 | -8 |
| `EAST` | 30 → 32 | 29 / 255 | 1248 | -8 |
| `WAIT` | 32 → 37 | 29 / 255 | 1248 | -8 |
| `WEST` | 37 → 39 | 28 / 255 | 1248 | -8 |
| `HAIL CAB` | 39 → 40 | 28 / 255 | 1248 | -8 |
| `GET INTO CAB` | 40 → 42 | 28 / 30 | 1248 | -8 |
| `WAIT` | 42 → 47 | 28 / 30 | 1248 | -8 |

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

`GET OUT OF CAB`

> You get out of the hansom cab. The cabbie, who now appears to be getting quite agitated, says" What about me money guv'nor?".

`EAST`

> You go east. You are at Victoria Station. Visible exits are west east. The cabbie shouts" You bloody snob, watch out if we ever meet again".

`WEST`

> You go west. You are in Buckingham Palace Road. Visible exits are east.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`GET INTO CAB`

> You get into the hansom cab.

`WAIT`

> You wait. The cabbie says to you" Well are we goin' anywhere guv'nor?".

## same_cabbie_debt

Dopo la fuga e il ritorno naturale, solo il cab30 e i suoi figli sono ricollocati in10 per rendere selezionabile soltanto il cab33. Nessuna modifica al cab33, cocchiere34 o conto35.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `OPEN YOUR DOOR` | 2 → 3 | 8 / 255 | 1248 | 0 |
| `WEST` | 3 → 4 | 7 / 255 | 1248 | 0 |
| `DOWN` | 4 → 6 | 6 / 255 | 1248 | 0 |
| `OPEN FRONT DOOR` | 6 → 7 | 6 / 255 | 1248 | 0 |
| `SOUTH` | 7 → 9 | 5 / 255 | 1248 | 0 |
| `HAIL CAB` | 9 → 10 | 5 / 255 | 1248 | 0 |
| `GET INTO CAB` | 10 → 12 | 5 / 33 | 1248 | 0 |
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 12 → 13 | 1 / 33 | 1248 | -8 |
| `WAIT` | 13 → 18 | 1 / 33 | 1248 | -8 |
| `WAIT` | 18 → 23 | 1 / 33 | 1248 | -8 |
| `WAIT` | 23 → 28 | 28 / 33 | 1248 | -8 |
| `GET OUT OF CAB` | 28 → 30 | 28 / 255 | 1248 | -8 |
| `EAST` | 30 → 32 | 29 / 255 | 1248 | -8 |
| `WAIT` | 32 → 37 | 29 / 255 | 1248 | -8 |
| `WEST` | 37 → 39 | 28 / 255 | 1248 | -8 |
| `HAIL CAB` | 39 → 40 | 28 / 255 | 1248 | -8 |
| `GET INTO CAB` | 40 → 42 | 28 / 33 | 1248 | -8 |
| `WAIT` | 42 → 47 | 28 / 33 | 1248 | -8 |
| `SAY TO CABBIE "GO TO BAKER STREET"` | 47 → 48 | 1 / 33 | 1248 | -16 |
| `WAIT` | 48 → 53 | 1 / 33 | 1248 | -16 |
| `WAIT` | 53 → 58 | 1 / 33 | 1248 | -16 |
| `WAIT` | 58 → 63 | 5 / 33 | 1248 | -16 |

`OPEN YOUR DOOR`

> You open your door.

`WEST`

> You go west. You are in a hall. To the east there is your door. Below there is the stairway.

`DOWN`

> You go down. You are in an entrance hallway. Above there is the stairway. To the south there is the front door.

`OPEN FRONT DOOR`

> You open the front door.

`SOUTH`

> You go south. You are on Baker Street. To the north there is the front door.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`GET INTO CAB`

> You get into the hansom cab.

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. You are in a hansom cab. The hansom cab is in Buckingham Palace Road. Visible exits are east. The cabbie remarks to you" Right guv'nor that will be 8d."

`GET OUT OF CAB`

> You get out of the hansom cab. The cabbie, who now appears to be getting quite agitated, says" What about me money guv'nor?".

`EAST`

> You go east. You are at Victoria Station. Visible exits are west east. The cabbie shouts" You bloody snob, watch out if we ever meet again".

`WEST`

> You go west. You are in Buckingham Palace Road. Visible exits are east.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`GET INTO CAB`

> You get into the hansom cab.

`SAY TO CABBIE "GO TO BAKER STREET"`

> You talk to the cabbie. You are in a hansom cab with the cabbie. You are travelling the streets of London in a hansom cab, the sun shines through the windows onto your face.

`WAIT`

> You wait. The hansom cab is on Baker Street. The cabbie remarks to you" Right guv'nor that will be 1/4" The cabbie remarks to you" Right guv'nor that will be 1/4"

## go_without_boarding

Nessun ricollocamento o modifica al mondo.

| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |
|---|---|---|---:|---:|
| `OPEN YOUR DOOR` | 2 → 3 | 8 / 255 | 1248 | 0 |
| `WEST` | 3 → 4 | 7 / 255 | 1248 | 0 |
| `DOWN` | 4 → 6 | 6 / 255 | 1248 | 0 |
| `OPEN FRONT DOOR` | 6 → 7 | 6 / 255 | 1248 | 0 |
| `SOUTH` | 7 → 9 | 5 / 255 | 1248 | 0 |
| `HAIL CAB` | 9 → 10 | 5 / 255 | 1248 | 0 |
| `SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"` | 10 → 11 | 5 / 255 | 1248 | -8 |
| `WAIT` | 11 → 16 | 5 / 255 | 1248 | -8 |
| `WAIT` | 16 → 21 | 5 / 255 | 1248 | -8 |
| `WAIT` | 21 → 26 | 5 / 255 | 1248 | -8 |

`OPEN YOUR DOOR`

> You open your door.

`WEST`

> You go west. You are in a hall. To the east there is your door. Below there is the stairway.

`DOWN`

> You go down. You are in an entrance hallway. Above there is the stairway. To the south there is the front door.

`OPEN FRONT DOOR`

> You open the front door.

`SOUTH`

> You go south. You are on Baker Street. To the north there is the front door.

`HAIL CAB`

> You hail the hansom cab. The cabbie says to you" Good morning guv'nor.".

`SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"`

> You talk to the cabbie.

