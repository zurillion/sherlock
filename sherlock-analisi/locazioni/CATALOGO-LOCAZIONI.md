# Catalogo delle locazioni e delle uscite

ID decimali; indirizzi esadecimali. Topologia dal payload. Il passaggio è un ID entità condiviso, non un oggetto copiato per ogni arco. Destinazione zero = uscita non attiva nel movimento direzionale studiato.

## 000 — slot nullo

Record `$84E1` · flag `$04` · 10 byte · descrizione generica (puntatore zero).

Nessuna uscita direzionale nel record.

## 001 — hansom cab

Record `$84EB` · flag `$84` · 10 byte · descrizione $7DE1.

Nessuna uscita direzionale nel record.

## 002 — steam train

Record `$84F5` · flag `$84` · 10 byte · descrizione $7E27.

Nessuna uscita direzionale nel record.

## 003 — steam train

Record `$84FF` · flag `$84` · 10 byte · descrizione $7E45.

Nessuna uscita direzionale nel record.

## 004 — steam train

Record `$8509` · flag `$84` · 10 byte · descrizione $7E65.

Nessuna uscita direzionale nel record.

## 005 — baker street

Record `$8513` · flag `$06` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 19 front door | 006 — entrance hallway | $851C |

## 006 — entrance hallway

Record `$8520` · flag `$84` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| UP | 20 stairway | 007 — hall | $8529 |
| S | 19 front door | 005 — baker street | $852C |

## 007 — hall

Record `$8530` · flag `$84` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 21 your door | 008 — your room | $8539 |
| DOWN | 20 stairway | 006 — entrance hallway | $853C |

## 008 — your room

Record `$8540` · flag `$84` · 16 byte · descrizione $7D62.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 21 your door | 007 — hall | $8549 |
| N | 50 plain door | 009 — small closet | $854C |

## 009 — small closet

Record `$8550` · flag `$84` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 50 plain door | 008 — your room | $8559 |

## 010 — parliament street

Record `$855D` · flag `$06` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 0 — nessuno | 011 — scotland yard | $8566 |

## 011 — scotland yard

Record `$856A` · flag `$84` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 010 — parliament street | $8573 |

## 012 — slater street

Record `$8577` · flag `$06` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 29 hidden door | 013 — disgust opium den | $8580 |

## 013 — disgust opium den

Record `$8584` · flag `$84` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 0 — nessuno | 012 — slater street | $858D |

## 014 — aldergate street

Record `$8591` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 015 — aldergate station | $859A |

## 015 — aldergate station

Record `$859E` · flag `$88` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 0 — nessuno | 014 — aldergate street | $85A7 |
| NW | 0 — nessuno | 016 — platform one | $85AA |

## 016 — platform one

Record `$85AE` · flag `$86` · 16 byte · descrizione $7EFA.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 0 — nessuno | 015 — aldergate station | $85B7 |
| NW | 0 — nessuno | 017 — platform two | $85BA |

## 017 — platform two

Record `$85BE` · flag `$86` · 13 byte · descrizione $7F03.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 0 — nessuno | 016 — platform one | $85C7 |

## 018 — kings cross road

Record `$85CB` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NE | 0 — nessuno | 019 — kings cross station | $85D4 |

## 019 — kings cross station

Record `$85D8` · flag `$88` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 018 — kings cross road | $85E1 |
| NE | 0 — nessuno | 020 — platform one | $85E4 |

## 020 — platform one

Record `$85E8` · flag `$86` · 16 byte · descrizione $7F09.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 019 — kings cross station | $85F1 |
| NE | 0 — nessuno | 021 — platform two | $85F4 |

## 021 — platform two

Record `$85F8` · flag `$86` · 16 byte · descrizione $7F14.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 020 — platform one | $8601 |
| NE | 0 — nessuno | 022 — platform three | $8604 |

## 022 — platform three

Record `$8608` · flag `$86` · 16 byte · descrizione $7F1A.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 021 — platform two | $8611 |
| NE | 0 — nessuno | 023 — platform four | $8614 |

## 023 — platform four

Record `$8618` · flag `$86` · 13 byte · descrizione $7F24.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 022 — platform three | $8621 |

## 024 — bishops road

Record `$8625` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 0 — nessuno | 025 — paddington station | $862E |

## 025 — paddington station

Record `$8632` · flag `$88` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 024 — bishops road | $863B |
| SE | 0 — nessuno | 026 — platform one | $863E |

## 026 — platform one

Record `$8642` · flag `$86` · 16 byte · descrizione $7F2E.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 025 — paddington station | $864B |
| SE | 0 — nessuno | 027 — platform two | $864E |

## 027 — platform two

Record `$8652` · flag `$86` · 13 byte · descrizione $7F37.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 026 — platform one | $865B |

## 028 — buckingham palace road

Record `$865F` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 0 — nessuno | 029 — victoria station | $8668 |

## 029 — victoria station

Record `$866C` · flag `$88` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 028 — buckingham palace road | $8675 |
| E | 0 — nessuno | 030 — platform one | $8678 |

## 030 — platform one

Record `$867C` · flag `$86` · 16 byte · descrizione $7F3D.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 029 — victoria station | $8685 |
| E | 0 — nessuno | 031 — platform two | $8688 |

## 031 — platform two

Record `$868C` · flag `$86` · 13 byte · descrizione $7F46.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 030 — platform one | $8695 |

## 032 — camden street

Record `$8699` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NE | 91 front door | 033 — entrance hall | $86A2 |
| E | 0 — nessuno | 102 — basils front yard | $86A5 |

## 033 — entrance hall

Record `$86A9` · flag `$04` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 91 front door | 032 — camden street | $86B2 |
| NE | 0 — nessuno | 034 — passage | $86B5 |
| SE | 45 large oak door | 035 — basils bedroom | $86B8 |

## 034 — passage

Record `$86BC` · flag `$04` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 033 — entrance hall | $86C5 |
| NE | 50 plain door | 036 — basils kitchen | $86C8 |
| NW | 49 diningroom door | 037 — basils dining room | $86CB |
| SE | 55 thick heavy door | 038 — basils library | $86CE |

## 035 — basils bedroom

Record `$86D2` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 45 large oak door | 033 — entrance hall | $86DB |
| SW | 79 window | 102 — basils front yard | $86DE |

## 036 — basils kitchen

Record `$86E2` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 50 plain door | 034 — passage | $86EB |
| NE | 74 back door | 039 — basils yard | $86EE |

## 037 — basils dining room

Record `$86F2` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 49 diningroom door | 034 — passage | $86FB |

## 038 — basils library

Record `$86FF` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 55 thick heavy door | 034 — passage | $8708 |

## 039 — basils yard

Record `$870C` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 74 back door | 036 — basils kitchen | $8715 |

## 040 — sidmouth street

Record `$8719` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 48 heavy oak door | 041 — main passage | $8722 |

## 041 — main passage

Record `$8726` · flag `$84` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 48 heavy oak door | 040 — sidmouth street | $872F |
| NE | 55 thick heavy door | 042 — reading lounge | $8732 |
| UP | 20 stairway | 043 — passage | $8735 |

## 042 — reading lounge

Record `$8739` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 55 thick heavy door | 041 — main passage | $8742 |

## 043 — passage

Record `$8746` · flag `$84` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| DOWN | 20 stairway | 041 — main passage | $874F |
| NE | 48 heavy oak door | 044 — major ffoulkes room | $8752 |

## 044 — major ffoulkes room

Record `$8756` · flag `$04` · 13 byte · descrizione $7E7F.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 48 heavy oak door | 043 — passage | $875F |

## 045 — portman street

Record `$8763` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 103 tricias front door | 046 — tricias entrance hall | $876C |

## 046 — tricias entrance hall

Record `$8770` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 103 tricias front door | 045 — portman street | $8779 |
| S | 55 thick heavy door | 047 — tricias lounge | $877C |

## 047 — tricias lounge

Record `$8780` · flag `$04` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 55 thick heavy door | 046 — tricias entrance hall | $8789 |
| S | 50 plain door | 048 — tricias kitchen | $878C |
| E | 51 ornate door | 049 — tricias bedroom | $878F |

## 048 — tricias kitchen

Record `$8793` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 50 plain door | 047 — tricias lounge | $879C |

## 049 — tricias bedroom

Record `$87A0` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 51 ornate door | 047 — tricias lounge | $87A9 |

## 050 — main street

Record `$87AD` · flag `$04` · 25 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 053 — leatherhead station | $87B6 |
| W | 0 — nessuno | 062 — browns front gate | $87B9 |
| E | 0 — nessuno | 092 — jones front gate | $87BC |
| S | 0 — nessuno | 051 — cobden lane | $87BF |
| NE | 0 — nessuno | 104 — leatherhead police station | $87C2 |

## 051 — cobden lane

Record `$87C6` · flag `$04` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 050 — main street | $87CF |
| S | 0 — nessuno | 052 — small lane | $87D2 |
| E | 19 front door | 056 — entrance hall | $87D5 |

## 052 — small lane

Record `$87D9` · flag `$04` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 051 — cobden lane | $87E2 |
| E | 73 back gate | 060 — small yard | $87E5 |
| W | 75 thick hedge | 081 — winding garden path | $87E8 |

## 053 — leatherhead station

Record `$87EC` · flag `$88` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 0 — nessuno | 050 — main street | $87F5 |
| N | 0 — nessuno | 054 — platform one | $87F8 |

## 054 — platform one

Record `$87FC` · flag `$86` · 16 byte · descrizione $7F4C.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 0 — nessuno | 053 — leatherhead station | $8805 |
| N | 0 — nessuno | 055 — platform two | $8808 |

## 055 — platform two

Record `$880C` · flag `$86` · 13 byte · descrizione $7F57.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 0 — nessuno | 054 — platform one | $8815 |

## 056 — entrance hall

Record `$8819` · flag `$84` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 19 front door | 051 — cobden lane | $8822 |
| E | 69 sittingroom door | 057 — lounge room | $8825 |
| UP | 20 stairway | 061 — basils bedroom | $8828 |

## 057 — lounge room

Record `$882C` · flag `$04` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 69 sittingroom door | 056 — entrance hall | $8835 |
| E | 50 plain door | 059 — basils kitchen | $8838 |
| S | 0 — nessuno | 058 — basils library | $883B |

## 058 — basils library

Record `$883F` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 057 — lounge room | $8848 |

## 059 — basils kitchen

Record `$884C` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 50 plain door | 057 — lounge room | $8855 |
| S | 74 back door | 060 — small yard | $8858 |

## 060 — small yard

Record `$885C` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 74 back door | 059 — basils kitchen | $8865 |
| W | 73 back gate | 052 — small lane | $8868 |

## 061 — basils bedroom

Record `$886C` · flag `$04` · 16 byte · descrizione $7EB7.

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| DOWN | 20 stairway | 056 — entrance hall | $8875 |
| E | 102 window | 000 — non attiva | $8878 |

## 062 — browns front gate

Record `$887C` · flag `$08` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 12 local police man | 076 — garden path | $8885 |
| E | 0 — nessuno | 050 — main street | $8888 |

## 063 — browns front door

Record `$888C` · flag `$08` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 45 large oak door | 064 — entrance hall | $8895 |
| N | 0 — nessuno | 076 — garden path | $8898 |

## 064 — entrance hall

Record `$889C` · flag `$84` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 48 heavy oak door | 067 — sitting room | $88A5 |
| N | 45 large oak door | 063 — browns front door | $88A8 |
| S | 44 wide stairway | 069 — long passage | $88AB |

## 065 — large kitchen

Record `$88AF` · flag `$84` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 066 — pantry | $88B8 |
| E | 50 plain door | 068 — dining room | $88BB |

## 066 — pantry

Record `$88BF` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 0 — nessuno | 065 — large kitchen | $88C8 |

## 067 — sitting room

Record `$88CC` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 48 heavy oak door | 064 — entrance hall | $88D5 |
| S | 49 diningroom door | 068 — dining room | $88D8 |

## 068 — dining room

Record `$88DC` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 50 plain door | 065 — large kitchen | $88E5 |
| N | 49 diningroom door | 067 — sitting room | $88E8 |

## 069 — long passage

Record `$88EC` · flag `$84` · 25 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| DOWN | 44 wide stairway | 064 — entrance hall | $88F5 |
| S | 52 daphnes door | 074 — daphnes room | $88F8 |
| W | 54 wooden door | 072 — browns study | $88FB |
| E | 0 — nessuno | 070 — long passage | $88FE |
| N | 44 wide stairway | 064 — entrance hall | $8901 |

## 070 — long passage

Record `$8905` · flag `$84` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 069 — long passage | $890E |
| N | 51 ornate door | 073 — master bed room | $8911 |
| S | 53 bedroom door | 075 — guest room | $8914 |
| E | 55 thick heavy door | 071 — browns library | $8917 |

## 071 — browns library

Record `$891B` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 55 thick heavy door | 070 — long passage | $8924 |

## 072 — browns study

Record `$8928` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 54 wooden door | 069 — long passage | $8931 |
| NE | 56 side door | 073 — master bed room | $8934 |

## 073 — master bed room

Record `$8938` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 56 side door | 072 — browns study | $8941 |
| S | 51 ornate door | 070 — long passage | $8944 |

## 074 — daphnes room

Record `$8948` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 52 daphnes door | 069 — long passage | $8951 |

## 075 — guest room

Record `$8955` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 53 bedroom door | 070 — long passage | $895E |

## 076 — garden path

Record `$8962` · flag `$06` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 062 — browns front gate | $896B |
| S | 0 — nessuno | 063 — browns front door | $896E |
| SW | 0 — nessuno | 077 — winding garden path | $8971 |
| E | 0 — nessuno | 086 — winding garden path | $8974 |

## 077 — winding garden path

Record `$8978` · flag `$06` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NE | 0 — nessuno | 076 — garden path | $8981 |
| S | 0 — nessuno | 078 — winding garden path | $8984 |

## 078 — winding garden path

Record `$8988` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 077 — winding garden path | $8991 |
| SW | 0 — nessuno | 089 — west side | $8994 |
| SE | 0 — nessuno | 079 — winding garden path | $8997 |

## 079 — winding garden path

Record `$899B` · flag `$06` · 25 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 078 — winding garden path | $89A4 |
| SE | 0 — nessuno | 080 — winding garden path | $89A7 |
| NE | 0 — nessuno | 082 — winding garden path | $89AA |
| SW | 0 — nessuno | 089 — west side | $89AD |
| E | 59 deep stream | 000 — non attiva | $89B0 |

## 080 — winding garden path

Record `$89B4` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SE | 0 — nessuno | 091 — north side | $89BD |
| W | 0 — nessuno | 079 — winding garden path | $89C0 |
| NE | 0 — nessuno | 081 — winding garden path | $89C3 |

## 081 — winding garden path

Record `$89C7` · flag `$06` · 25 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 080 — winding garden path | $89D0 |
| N | 0 — nessuno | 083 — winding garden path | $89D3 |
| S | 0 — nessuno | 091 — north side | $89D6 |
| NW | 0 — nessuno | 082 — winding garden path | $89D9 |
| W | 75 thick hedge | 052 — small lane | $89DC |

## 082 — winding garden path

Record `$89E0` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NE | 0 — nessuno | 083 — winding garden path | $89E9 |
| W | 0 — nessuno | 079 — winding garden path | $89EC |
| SE | 0 — nessuno | 081 — winding garden path | $89EF |

## 083 — winding garden path

Record `$89F3` · flag `$06` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 084 — winding garden path | $89FC |
| NW | 0 — nessuno | 086 — winding garden path | $89FF |
| SW | 0 — nessuno | 082 — winding garden path | $8A02 |
| SE | 0 — nessuno | 081 — winding garden path | $8A05 |

## 084 — winding garden path

Record `$8A09` · flag `$06` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| NW | 0 — nessuno | 085 — winding garden path | $8A12 |
| S | 0 — nessuno | 083 — winding garden path | $8A15 |

## 085 — winding garden path

Record `$8A19` · flag `$06` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 0 — nessuno | 086 — winding garden path | $8A22 |
| E | 0 — nessuno | 084 — winding garden path | $8A25 |

## 086 — winding garden path

Record `$8A29` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 076 — garden path | $8A32 |
| SE | 0 — nessuno | 083 — winding garden path | $8A35 |
| E | 0 — nessuno | 085 — winding garden path | $8A38 |

## 087 — winding garden path

Record `$8A3C` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 088 — east side | $8A45 |
| E | 0 — nessuno | 090 — south side | $8A48 |
| S | 59 deep stream | 000 — non attiva | $8A4B |

## 088 — east side

Record `$8A4F` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 57 sandstone bridge | 089 — west side | $8A58 |
| SE | 0 — nessuno | 087 — winding garden path | $8A5B |
| N | 59 deep stream | 000 — non attiva | $8A5E |

## 089 — west side

Record `$8A62` · flag `$06` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 57 sandstone bridge | 088 — east side | $8A6B |
| N | 0 — nessuno | 078 — winding garden path | $8A6E |
| NE | 0 — nessuno | 079 — winding garden path | $8A71 |
| NW | 59 deep stream | 000 — non attiva | $8A74 |

## 090 — south side

Record `$8A78` · flag `$06` · 19 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 087 — winding garden path | $8A81 |
| N | 58 footbridge | 091 — north side | $8A84 |
| SE | 59 deep stream | 000 — non attiva | $8A87 |

## 091 — north side

Record `$8A8B` · flag `$06` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 58 footbridge | 090 — south side | $8A94 |
| NW | 0 — nessuno | 080 — winding garden path | $8A97 |
| N | 0 — nessuno | 081 — winding garden path | $8A9A |
| NE | 59 deep stream | 000 — non attiva | $8A9D |

## 092 — jones front gate

Record `$8AA1` · flag `$08` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 11 local police man | 093 — jones front door | $8AAA |
| W | 0 — nessuno | 050 — main street | $8AAD |

## 093 — jones front door

Record `$8AB1` · flag `$08` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 19 front door | 096 — jones entrance hall | $8ABA |
| N | 0 — nessuno | 092 — jones front gate | $8ABD |

## 094 — library

Record `$8AC1` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 66 bookcase | 095 — small room | $8ACA |
| N | 68 solid door | 097 — sitting room | $8ACD |

## 095 — small room

Record `$8AD1` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 66 bookcase | 094 — library | $8ADA |

## 096 — jones entrance hall

Record `$8ADE` · flag `$84` · 22 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 19 front door | 093 — jones front door | $8AE7 |
| SE | 49 diningroom door | 099 — dining room | $8AEA |
| W | 69 sittingroom door | 097 — sitting room | $8AED |
| UP | 20 stairway | 100 — small passage | $8AF0 |

## 097 — sitting room

Record `$8AF4` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 68 solid door | 094 — library | $8AFD |
| E | 69 sittingroom door | 096 — jones entrance hall | $8B00 |

## 098 — kitchen

Record `$8B04` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| S | 50 plain door | 099 — dining room | $8B0D |

## 099 — dining room

Record `$8B11` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| N | 50 plain door | 098 — kitchen | $8B1A |
| NW | 49 diningroom door | 096 — jones entrance hall | $8B1D |

## 100 — small passage

Record `$8B21` · flag `$84` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| DOWN | 20 stairway | 096 — jones entrance hall | $8B2A |
| W | 70 northern door | 101 — mrs jones room | $8B2D |

## 101 — mrs jones room

Record `$8B31` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| E | 70 northern door | 100 — small passage | $8B3A |

## 102 — basils front yard

Record `$8B3E` · flag `$04` · 16 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| W | 0 — nessuno | 032 — camden street | $8B47 |
| NE | 79 window | 035 — basils bedroom | $8B4A |

## 103 — old mill road

Record `$8B4E` · flag `$06` · 10 byte · descrizione generica (puntatore zero).

Nessuna uscita direzionale nel record.

## 104 — leatherhead police station

Record `$8B58` · flag `$04` · 13 byte · descrizione generica (puntatore zero).

| Direzione | Passaggio | Destinazione | Tripletta |
|---|---|---|---|
| SW | 0 — nessuno | 050 — main street | $8B61 |

## 105 — police cab

Record `$8B65` · flag `$84` · 10 byte · descrizione $7E0B.

Nessuna uscita direzionale nel record.

