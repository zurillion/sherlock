# Catalogo delle entità di Sherlock

Dati del payload originale, prima dell’inizializzazione. Gli ID sono decimali e, tra parentesi, esadecimali. Nomi senza articolo; le posizioni sono ID di locazione, il genitore è un ID di entità. La locazione 0 non dimostra la presenza fisica di un personaggio nel mondo giocabile.

| ID | Record | Nome | Persona¹ | Genitore | Locazioni | Testo | Regole |
|---|---|---|---|---|---|---|---|
| 0 (00) | $8CBA | you | sì | — | 8 | — | 0 |
| 1 (01) | $8CCB | china man | sì | — | 0 | — | 0 |
| 2 (02) | $8CDC | inspector lestrade | sì | — | 11 | — | 0 |
| 3 (03) | $8CED | watson | sì | 24 (watsons armchair) | 8 | — | 0 |
| 4 (04) | $8CFE | chief constable straker | sì | — | 53 | — | 0 |
| 5 (05) | $8D0F | daphne strachan | sì | — | 67 | — | 0 |
| 6 (06) | $8D20 | basil phipps | sì | — | 67 | — | 0 |
| 7 (07) | $8D31 | major percival ffoulkes | sì | — | 0 | — | 0 |
| 8 (08) | $8D42 | gardener | sì | — | 65 | — | 0 |
| 9 (09) | $8D53 | cook | sì | — | 65 | — | 0 |
| 10 (0A) | $8D64 | maid | sì | — | 65 | — | 0 |
| 11 (0B) | $8D75 | local police man | sì | — | 92 | — | 2 |
| 12 (0C) | $8D8C | local police man | sì | — | 62 | — | 0 |
| 13 (0D) | $8D9D | tricia fender | sì | — | 0 | — | 2 |
| 14 (0E) | $8DB4 | china mans disguise |  | — | 9 | — | 2 |
| 15 (0F) | $8DC9 | case |  | — | 0 | — | 0 |
| 16 (10) | $8DDA | what happened |  | — | 0 | — | 0 |
| 17 (11) | $8DEB | your alibi |  | — | 0 | — | 0 |
| 18 (12) | $8DFC | your address |  | — | 0 | — | 0 |
| 19 (13) | $8E0D | front door |  | — | 5, 6, 93, 96, 51, 56 | — | 2 |
| 20 (14) | $8E27 | stairway |  | — | 6, 7, 96, 100, 41, 43, 56, 61 | — | 0 |
| 21 (15) | $8E3F | your door |  | — | 7, 8 | — | 2 |
| 22 (16) | $8E55 | oil lamp |  | — | 8 | — | 0 |
| 23 (17) | $8E66 | your armchair |  | — | 8 | — | 5 |
| 24 (18) | $8E81 | watsons armchair |  | — | 8 | — | 5 |
| 25 (19) | $8E9C | daily chronicle |  | 3 (watson) | 8 | — | 0 |
| 26 (1A) | $8EAD | note |  | — | 0 | $807A | 0 |
| 27 (1B) | $8EBE | your money |  | 0 (you) | 8 | — | 1 |
| 28 (1C) | $8ED1 | money |  | 2 (inspector lestrade) | 11 | — | 1 |
| 29 (1D) | $8EE4 | hidden door |  | — | 12, 13 | — | 0 |
| 30 (1E) | $8EF6 | hansom cab |  | — | 0 | — | 6 |
| 31 (1F) | $8F13 | cabbie | sì | 30 (hansom cab) | 0 | — | 3 |
| 32 (20) | $8F2C | money |  | 31 (cabbie) | 0 | — | 0 |
| 33 (21) | $8F3D | hansom cab |  | — | 0 | — | 6 |
| 34 (22) | $8F5A | cabbie | sì | 33 (hansom cab) | 0 | — | 3 |
| 35 (23) | $8F73 | money |  | 34 (cabbie) | 0 | — | 0 |
| 36 (24) | $8F84 | steam train |  | — | 2 | — | 4 |
| 37 (25) | $8F9D | steam train |  | — | 2 | — | 4 |
| 38 (26) | $8FB6 | steam train |  | — | 2 | — | 4 |
| 39 (27) | $8FCF | steam train |  | — | 2 | — | 4 |
| 40 (28) | $8FE8 | steam train |  | — | 2 | — | 4 |
| 41 (29) | $9001 | steam train |  | — | 2 | — | 4 |
| 42 (2A) | $901A | steam train |  | — | 3 | — | 4 |
| 43 (2B) | $9033 | steam train |  | — | 3 | — | 4 |
| 44 (2C) | $904C | wide stairway |  | — | 64, 69 | — | 0 |
| 45 (2D) | $905E | large oak door |  | — | 63, 64, 35, 33 | — | 2 |
| 46 (2E) | $9076 | female corpse |  | — | 88 | $81F5 | 0 |
| 47 (2F) | $9087 | crumpled note |  | 46 (female corpse) | 88 | $8220 | 0 |
| 48 (30) | $9098 | heavy oak door |  | — | 64, 67, 40, 41, 43, 44 | — | 2 |
| 49 (31) | $90B2 | diningroom door |  | — | 67, 68, 96, 99, 34, 37 | — | 2 |
| 50 (32) | $90CC | plain door |  | — | 65, 68, 98, 99, 34, 36, 8, 9, 57, 59 | — | 2 |
| 51 (33) | $90EA | ornate door |  | — | 73, 70, 47, 49 | — | 2 |
| 52 (34) | $9102 | daphnes door |  | — | 74, 69 | — | 2 |
| 53 (35) | $9118 | bedroom door |  | — | 75, 70 | — | 2 |
| 54 (36) | $912E | wooden door |  | — | 72, 69 | — | 2 |
| 55 (37) | $9144 | thick heavy door |  | — | 70, 71, 42, 41, 38, 34, 46, 47 | — | 2 |
| 56 (38) | $9160 | side door |  | — | 72, 73 | — | 2 |
| 57 (39) | $9176 | sandstone bridge |  | — | 88, 89 | — | 0 |
| 58 (3A) | $9188 | footbridge |  | — | 90, 91 | — | 0 |
| 59 (3B) | $919A | deep stream |  | — | 88, 89, 91, 90, 79, 87 | — | 1 |
| 60 (3C) | $91B2 | plush sofa |  | — | 67 | — | 5 |
| 61 (3D) | $91CD | large desk |  | — | 72 | $7FF9 | 0 |
| 62 (3E) | $91DE | drawer |  | 61 (large desk) | 72 | — | 3 |
| 63 (3F) | $91F5 | false bottom |  | 62 (drawer) | 72 | — | 2 |
| 64 (40) | $920A | bank account book |  | 63 (false bottom) | 72 | $801D | 0 |
| 65 (41) | $921B | note |  | 63 (false bottom) | 72 | $81B7 | 0 |
| 66 (42) | $922C | bookcase |  | — | 94, 95 | — | 1 |
| 67 (43) | $9240 | bloodstained clothes |  | — | 95 | $7F77 | 0 |
| 68 (44) | $9251 | solid door |  | — | 94, 97 | — | 2 |
| 69 (45) | $9267 | sittingroom door |  | — | 97, 96, 56, 57 | — | 2 |
| 70 (46) | $927F | northern door |  | — | 100, 101 | — | 2 |
| 71 (47) | $9295 | bloodstained sofa |  | — | 94 | — | 0 |
| 72 (48) | $92A6 | body |  | 71 (bloodstained sofa) | 94 | $8227 | 0 |
| 73 (49) | $92B7 | back gate |  | — | 60, 52 | — | 2 |
| 74 (4A) | $92CD | back door |  | — | 39, 36, 60, 59 | — | 2 |
| 75 (4B) | $92E5 | thick hedge |  | — | 52, 81 | — | 0 |
| 76 (4C) | $92F7 | basils bed |  | — | 61 | $7F89 | 0 |
| 77 (4D) | $9308 | basils piano |  | — | 61 | $7FA2 | 0 |
| 78 (4E) | $9319 | gramaphone |  | — | 61 | $7FB2 | 0 |
| 79 (4F) | $932A | window |  | — | 35, 102 | — | 2 |
| 80 (50) | $9340 | trash pile |  | — | 39 | — | 1 |
| 81 (51) | $9353 | torn coded note |  | 80 (trash pile) | 39 | $80F8 | 0 |
| 82 (52) | $9364 | small rubbish bin |  | — | 38 | — | 0 |
| 83 (53) | $9375 | ripped coded note |  | 82 (small rubbish bin) | 38 | $80AB | 0 |
| 84 (54) | $9386 | fireplace |  | — | 35 | — | 0 |
| 85 (55) | $9397 | burning note |  | 84 (fireplace) | 35 | $8158 | 3 |
| 86 (56) | $93AE | wall safe |  | — | 47 | — | 2 |
| 87 (57) | $93C3 | unfinished note |  | 86 (wall safe) | 47 | $7FC5 | 0 |
| 88 (58) | $93D4 | folder |  | 86 (wall safe) | 47 | $7FDA | 0 |
| 89 (59) | $93E5 | wall safe |  | — | 58 | — | 2 |
| 90 (5A) | $93FA | letters |  | 89 (wall safe) | 58 | $7F61 | 0 |
| 91 (5B) | $940B | front door |  | — | 32, 33 | — | 2 |
| 92 (5C) | $9421 | gun |  | 93 (large rock) | 11 | — | 0 |
| 93 (5D) | $9432 | large rock |  | 2 (inspector lestrade) | 11 | — | 0 |
| 94 (5E) | $9443 | mrs brown | sì | — | 0 | — | 0 |
| 95 (5F) | $9454 | mrs jones | sì | — | 0 | — | 2 |
| 96 (60) | $946B | herself |  | — | 0 | — | 0 |
| 97 (61) | $947C | plans |  | — | 0 | — | 0 |
| 98 (62) | $948D | innocent |  | — | 0 | — | 0 |
| 99 (63) | $949E | opium den |  | — | 0 | — | 0 |
| 100 (64) | $94AF | old man | sì | — | 0 | — | 0 |
| 101 (65) | $94C0 | old mans disguise |  | — | 9 | — | 2 |
| 102 (66) | $94D5 | window |  | — | 61 | — | 0 |
| 103 (67) | $94E6 | tricias front door |  | — | 45, 46 | — | 2 |
| 104 (68) | $94FC | german agent | sì | — | 0 | — | 0 |
| 105 (69) | $950D | old mill road |  | — | 0 | — | 0 |
| 106 (6A) | $951E | sale location |  | — | 0 | — | 0 |
| 107 (6B) | $952F | guilty |  | — | 0 | — | 0 |
| 108 (6C) | $9540 | idiot |  | — | 0 | — | 0 |
| 109 (6D) | $9551 | police cab |  | — | 0 | — | 4 |

¹ Bit 6 del byte +05: categoria verificata attraverso C8BE e C929; comprende Holmes. Non equivale a personaggio autonomo attivo.

## Descrizioni specifiche

### 26 — note ($807A)

Dear Sherlock, I have gone back to the practice to see a few patients. Will be back later.      Watson.

### 46 — female corpse ($81F5)

You see the body of a middle aged woman. Her face is streaked with dried blood.

### 47 — crumpled note ($8220)

It reads " Meet me by the bridge at half past twelve. I have some very important news.  Signed. P. F. ".

### 61 — large desk ($7FF9)

Apart from a fairly new and unused blotting pad the desk top is empty.

### 64 — bank account book ($801D)

While the balance in the account is very high the entries in the book indicate that substantial and regular withdrawals have been made recently. The account name is Mrs Brown.

### 65 — note ($81B7)

The note reads " I have some news of vital importance that I would like to discuss with you at your convenience. Signed. Tricia Fender. "

### 67 — bloodstained clothes ($7F77)

They are labelled " Tricia. Fender. ".

### 72 — body ($8227)

You see the body of a woman who was shot in the head. The face is now mutilated beyond recognition.

### 76 — basils bed ($7F89)

The bed is unmade and one sheet is crumpled up on top.

### 77 — basils piano ($7FA2)

The music on the piano is Baroque.

### 78 — gramaphone ($7FB2)

On the gramaphone is a record of Chopin Nocturnes.

### 81 — torn coded note ($80F8)

VAKS USH KNWH UL UNMH YWNQH. UNMH QNTH FTK RTLVBK GHNUS SNK KUNTUHG USH YLWAQH BLKABP NTLEBG.       Rnkaw.

### 83 — ripped coded note ($80AB)

S. V.
A BLV SNIH USH YWNBK. XLET YTAQH AK NQQHYUNRWH. WHU FH MBLV VSHTH XLE 

### 85 — burning note ($8158)

DSWYP.
GSUV CUVKSUP CSUX GSIC PPYA GPI UVK KS ZKCYVK ILK KS WXSPO UVK ZRD PPYL Y.      V. L.

### 87 — unfinished note ($7FC5)

It is addressed to Mrs Brown and reads " Meet me by the bridge at... ".

### 88 — folder ($7FDA)

The folder is empty but the label reads " Top Secret. Military plans. ".

### 90 — letters ($7F61)

They are to Mrs Brown from Tricia and appear to be blackmail letters.

## Regole locali

Il numero della regola seleziona un puntatore nella tabella $AA71. Le parole indicano il modello lessicale dell’azione, non una traduzione completa del suo comportamento.

### 11 — local police man

- $8D85: marcatore 00 00 (regole personaggio).
- $8D87: azione 29 (go / to), indice 1 → $9A99.
- $8D89: azione 30 (go / to / furiously), indice 2 → $9ACB.

### 13 — tricia fender

- $8DAD: marcatore 00 00 (regole personaggio).
- $8DAF: azione 48 (tell / about), indice 3 → $E1A3.
- $8DB1: azione 47 (tell), indice 3 → $E1A3.

### 14 — china mans disguise

- $8DC4: azione 51 (wear), indice 4 → $E022.
- $8DC6: azione 43 (take / off), indice 5 → $E003.

### 19 — front door

- $8E22: azione 36 (open), indice 6 → $DE9D.
- $8E24: azione 14 (close), indice 7 → $DEAF.

### 21 — your door

- $8E50: azione 36 (open), indice 6 → $DE9D.
- $8E52: azione 14 (close), indice 7 → $DEAF.

### 23 — your armchair

- $8E76: azione 13 (climb / out / of), indice 8 → $E432.
- $8E78: azione 12 (climb / into), indice 9 → $E40A.
- $8E7A: azione 25 (get / out / of), indice 8 → $E432.
- $8E7C: azione 24 (get / into), indice 9 → $E40A.
- $8E7E: azione 40 (sit / in), indice 9 → $E40A.

### 24 — watsons armchair

- $8E91: azione 13 (climb / out / of), indice 8 → $E432.
- $8E93: azione 12 (climb / into), indice 9 → $E40A.
- $8E95: azione 25 (get / out / of), indice 8 → $E432.
- $8E97: azione 24 (get / into), indice 9 → $E40A.
- $8E99: azione 40 (sit / in), indice 9 → $E40A.

### 27 — your money

- $8ECE: azione 15 (count), indice 10 → $E328.

### 28 — money

- $8EE1: azione 15 (count), indice 10 → $E328.

### 30 — hansom cab

- $8F06: azione 23 (get), indice 11 → $E2C7.
- $8F08: azione 31 (hail), indice 11 → $E2C7.
- $8F0A: azione 13 (climb / out / of), indice 8 → $E432.
- $8F0C: azione 12 (climb / into), indice 12 → $E3EA.
- $8F0E: azione 25 (get / out / of), indice 8 → $E432.
- $8F10: azione 24 (get / into), indice 12 → $E3EA.

### 31 — cabbie

- $8F23: marcatore 00 00 (regole personaggio).
- $8F25: azione 45 (take / to), indice 13 → $E08D.
- $8F27: azione 29 (go / to), indice 14 → $9AF4.
- $8F29: azione 30 (go / to / furiously), indice 15 → $9AE1.

### 33 — hansom cab

- $8F4D: azione 23 (get), indice 11 → $E2C7.
- $8F4F: azione 31 (hail), indice 11 → $E2C7.
- $8F51: azione 13 (climb / out / of), indice 8 → $E432.
- $8F53: azione 12 (climb / into), indice 12 → $E3EA.
- $8F55: azione 25 (get / out / of), indice 8 → $E432.
- $8F57: azione 24 (get / into), indice 12 → $E3EA.

### 34 — cabbie

- $8F6A: marcatore 00 00 (regole personaggio).
- $8F6C: azione 45 (take / to), indice 13 → $E08D.
- $8F6E: azione 29 (go / to), indice 14 → $9AF4.
- $8F70: azione 30 (go / to / furiously), indice 15 → $9AE1.

### 36 — steam train

- $8F94: azione 13 (climb / out / of), indice 8 → $E432.
- $8F96: azione 12 (climb / into), indice 9 → $E40A.
- $8F98: azione 25 (get / out / of), indice 8 → $E432.
- $8F9A: azione 24 (get / into), indice 9 → $E40A.

### 37 — steam train

- $8FAD: azione 13 (climb / out / of), indice 8 → $E432.
- $8FAF: azione 12 (climb / into), indice 9 → $E40A.
- $8FB1: azione 25 (get / out / of), indice 8 → $E432.
- $8FB3: azione 24 (get / into), indice 9 → $E40A.

### 38 — steam train

- $8FC6: azione 13 (climb / out / of), indice 8 → $E432.
- $8FC8: azione 12 (climb / into), indice 9 → $E40A.
- $8FCA: azione 25 (get / out / of), indice 8 → $E432.
- $8FCC: azione 24 (get / into), indice 9 → $E40A.

### 39 — steam train

- $8FDF: azione 13 (climb / out / of), indice 8 → $E432.
- $8FE1: azione 12 (climb / into), indice 9 → $E40A.
- $8FE3: azione 25 (get / out / of), indice 8 → $E432.
- $8FE5: azione 24 (get / into), indice 9 → $E40A.

### 40 — steam train

- $8FF8: azione 13 (climb / out / of), indice 8 → $E432.
- $8FFA: azione 12 (climb / into), indice 9 → $E40A.
- $8FFC: azione 25 (get / out / of), indice 8 → $E432.
- $8FFE: azione 24 (get / into), indice 9 → $E40A.

### 41 — steam train

- $9011: azione 13 (climb / out / of), indice 8 → $E432.
- $9013: azione 12 (climb / into), indice 9 → $E40A.
- $9015: azione 25 (get / out / of), indice 8 → $E432.
- $9017: azione 24 (get / into), indice 9 → $E40A.

### 42 — steam train

- $902A: azione 13 (climb / out / of), indice 8 → $E432.
- $902C: azione 12 (climb / into), indice 9 → $E40A.
- $902E: azione 25 (get / out / of), indice 8 → $E432.
- $9030: azione 24 (get / into), indice 9 → $E40A.

### 43 — steam train

- $9043: azione 13 (climb / out / of), indice 8 → $E432.
- $9045: azione 12 (climb / into), indice 9 → $E40A.
- $9047: azione 25 (get / out / of), indice 8 → $E432.
- $9049: azione 24 (get / into), indice 9 → $E40A.

### 45 — large oak door

- $9071: azione 36 (open), indice 6 → $DE9D.
- $9073: azione 14 (close), indice 7 → $DEAF.

### 48 — heavy oak door

- $90AD: azione 36 (open), indice 6 → $DE9D.
- $90AF: azione 14 (close), indice 7 → $DEAF.

### 49 — diningroom door

- $90C7: azione 36 (open), indice 6 → $DE9D.
- $90C9: azione 14 (close), indice 7 → $DEAF.

### 50 — plain door

- $90E5: azione 36 (open), indice 6 → $DE9D.
- $90E7: azione 14 (close), indice 7 → $DEAF.

### 51 — ornate door

- $90FD: azione 36 (open), indice 6 → $DE9D.
- $90FF: azione 14 (close), indice 7 → $DEAF.

### 52 — daphnes door

- $9113: azione 36 (open), indice 6 → $DE9D.
- $9115: azione 14 (close), indice 7 → $DEAF.

### 53 — bedroom door

- $9129: azione 36 (open), indice 6 → $DE9D.
- $912B: azione 14 (close), indice 7 → $DEAF.

### 54 — wooden door

- $913F: azione 36 (open), indice 6 → $DE9D.
- $9141: azione 14 (close), indice 7 → $DEAF.

### 55 — thick heavy door

- $915B: azione 36 (open), indice 6 → $DE9D.
- $915D: azione 14 (close), indice 7 → $DEAF.

### 56 — side door

- $9171: azione 36 (open), indice 6 → $DE9D.
- $9173: azione 14 (close), indice 7 → $DEAF.

### 59 — deep stream

- $91AF: azione 20 (examine / closely), indice 16 → $E0A0.

### 60 — plush sofa

- $91C2: azione 13 (climb / out / of), indice 8 → $E432.
- $91C4: azione 12 (climb / into), indice 9 → $E40A.
- $91C6: azione 25 (get / out / of), indice 8 → $E432.
- $91C8: azione 24 (get / into), indice 9 → $E40A.
- $91CA: azione 40 (sit / in), indice 9 → $E40A.

### 62 — drawer

- $91EE: azione 36 (open), indice 6 → $DE9D.
- $91F0: azione 14 (close), indice 7 → $DEAF.
- $91F2: azione 20 (examine / closely), indice 17 → $E0F2.

### 63 — false bottom

- $9205: azione 36 (open), indice 6 → $DE9D.
- $9207: azione 14 (close), indice 7 → $DEAF.

### 66 — bookcase

- $923D: azione 20 (examine / closely), indice 18 → $E104.

### 68 — solid door

- $9262: azione 36 (open), indice 6 → $DE9D.
- $9264: azione 14 (close), indice 7 → $DEAF.

### 69 — sittingroom door

- $927A: azione 36 (open), indice 6 → $DE9D.
- $927C: azione 14 (close), indice 7 → $DEAF.

### 70 — northern door

- $9290: azione 36 (open), indice 6 → $DE9D.
- $9292: azione 14 (close), indice 7 → $DEAF.

### 73 — back gate

- $92C8: azione 36 (open), indice 6 → $DE9D.
- $92CA: azione 14 (close), indice 7 → $DEAF.

### 74 — back door

- $92E0: azione 36 (open), indice 6 → $DE9D.
- $92E2: azione 14 (close), indice 7 → $DEAF.

### 79 — window

- $933B: azione 36 (open), indice 6 → $DE9D.
- $933D: azione 14 (close), indice 7 → $DEAF.

### 80 — trash pile

- $9350: azione 20 (examine / closely), indice 19 → $E0E0.

### 85 — burning note

- $93A7: azione 41 (take), indice 20 → $DF7E.
- $93A9: azione 23 (get), indice 20 → $DF7E.
- $93AB: azione 44 (take / out / of), indice 20 → $DF7E.

### 86 — wall safe

- $93BE: azione 36 (open), indice 21 → $DFA7.
- $93C0: azione 14 (close), indice 7 → $DEAF.

### 89 — wall safe

- $93F5: azione 36 (open), indice 21 → $DFA7.
- $93F7: azione 14 (close), indice 7 → $DEAF.

### 91 — front door

- $941C: azione 36 (open), indice 6 → $DE9D.
- $941E: azione 14 (close), indice 7 → $DEAF.

### 95 — mrs jones

- $9464: marcatore 00 00 (regole personaggio).
- $9466: azione 48 (tell / about), indice 22 → $E17B.
- $9468: azione 47 (tell), indice 22 → $E17B.

### 101 — old mans disguise

- $94D0: azione 51 (wear), indice 23 → $DFF0.
- $94D2: azione 43 (take / off), indice 24 → $DFEA.

### 103 — tricias front door

- $94F7: azione 36 (open), indice 6 → $DE9D.
- $94F9: azione 14 (close), indice 7 → $DEAF.

### 109 — police cab

- $9561: azione 13 (climb / out / of), indice 8 → $E432.
- $9563: azione 12 (climb / into), indice 12 → $E3EA.
- $9565: azione 25 (get / out / of), indice 8 → $E432.
- $9567: azione 24 (get / into), indice 12 → $E3EA.

