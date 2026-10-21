; Estratti non contigui: ORG esplicito per ogni intervallo.
; Gli indirizzi numerici rimandano alla memoria originale.
; Indice alfabetico e limite dell'area dizionario
;
; Word little-endian. Il decoder usa le entrate a partire dal codice $60; a-z
; corrispondono a $5D82-$5DB5. I valori sono offset relativi a $5DBF. La word a
; $5DBE contiene $09F8, che conduce a $67B7.
    ORG $5D80
    DEFW $0000             ; $5D80  00 00
    DEFW $0001             ; $5D82  01 00
    DEFW $00A7             ; $5D84  A7 00
    DEFW $0164             ; $5D86  64 01
    DEFW $020D             ; $5D88  0D 02
    DEFW $0280             ; $5D8A  80 02
    DEFW $02DD             ; $5D8C  DD 02
    DEFW $036A             ; $5D8E  6A 03
    DEFW $03BA             ; $5D90  BA 03
    DEFW $042D             ; $5D92  2D 04
    DEFW $048B             ; $5D94  8B 04
    DEFW $0494             ; $5D96  94 04
    DEFW $04B0             ; $5D98  B0 04
    DEFW $0532             ; $5D9A  32 05
    DEFW $0599             ; $5D9C  99 05
    DEFW $05E8             ; $5D9E  E8 05
    DEFW $0636             ; $5DA0  36 06
    DEFW $06EB             ; $5DA2  EB 06
    DEFW $06F9             ; $5DA4  F9 06
    DEFW $075A             ; $5DA6  5A 07
    DEFW $0882             ; $5DA8  82 08
    DEFW $090C             ; $5DAA  0C 09
    DEFW $094B             ; $5DAC  4B 09
    DEFW $095A             ; $5DAE  5A 09
    DEFW $09DF             ; $5DB0  DF 09
    DEFW $09E3             ; $5DB2  E3 09
    DEFW $09F5             ; $5DB4  F5 09
    DEFW $0000             ; $5DB6  00 00
    DEFW $0000             ; $5DB8  00 00
    DEFW $0000             ; $5DBA  00 00
    DEFW $0000             ; $5DBC  00 00
    DEFW $09F8             ; $5DBE  F8 09


; Tabella delle 32 parole frequenti
;
; I token $60-$7F selezionano una word a questa base. Il risultato e un offset
; nel dizionario; $A840 aggiunge il contesto $5000, cioe senza suffisso.
    ORG $67B7
    DEFW $089D             ; $67B7  9D 08
    DEFW $08DB             ; $67B9  DB 08
    DEFW $0001             ; $67BB  01 00
    DEFW $005D             ; $67BD  5D 00
    DEFW $09EE             ; $67BF  EE 09
    DEFW $05EC             ; $67C1  EC 05
    DEFW $0899             ; $67C3  99 08
    DEFW $0485             ; $67C5  85 04
    DEFW $0450             ; $67C7  50 04
    DEFW $096A             ; $67C9  6A 09
    DEFW $009A             ; $67CB  9A 00
    DEFW $042D             ; $67CD  2D 04
    DEFW $0488             ; $67CF  88 04
    DEFW $05D5             ; $67D1  D5 05
    DEFW $03DF             ; $67D3  DF 03
    DEFW $0263             ; $67D5  63 02
    DEFW $0986             ; $67D7  86 09
    DEFW $094B             ; $67D9  4B 09
    DEFW $09BF             ; $67DB  BF 09
    DEFW $03FC             ; $67DD  FC 03
    DEFW $0794             ; $67DF  94 07
    DEFW $015E             ; $67E1  5E 01
    DEFW $03E3             ; $67E3  E3 03
    DEFW $05FF             ; $67E5  FF 05
    DEFW $007A             ; $67E7  7A 00
    DEFW $0620             ; $67E9  20 06
    DEFW $0351             ; $67EB  51 03
    DEFW $05E0             ; $67ED  E0 05
    DEFW $00C0             ; $67EF  C0 00
    DEFW $0996             ; $67F1  96 09
    DEFW $0414             ; $67F3  14 04
    DEFW $0594             ; $67F5  94 05


; Frase verificata: I do not know the word seguito da virgoletta
;
; Eseguita in isolamento con il codice Z80 originale e stampa bitmap reale. Non
; sono istruzioni CPU: e il linguaggio dei testi interpretato da $A5CD.
    ORG $6859
    DEFB $6B,$6F,$6D       ; $6859  6B 6F 6D | Token frequenti: i, do, not.
    DEFB $D4,$AD           ; $685C  D4 AD | Token lungo: contesto $50, offset $4AD = know.
    DEFB $60               ; $685E  60 | Token frequente: the.
    DEFB $20               ; $685F  20 | Spazio letterale.
    DEFB $43,$BB,$E4,$40   ; $6860  43 BB E4 40 | Conteggio $43: quattro caratteri a 5 bit; $BB $E4
    DEFB $22               ; $6864  22 | Virgoletta letterale.
    DEFB $1F               ; $6865  1F | Comando $1F: termina senza punto o ritorno a


; Tabella dispatch dei 32 comandi del linguaggio dei testi
    ORG $A55D
    DEFW $A65D             ; $A55D  5D A6
    DEFW $A66C             ; $A55F  6C A6
    DEFW $A679             ; $A561  79 A6
    DEFW $A702             ; $A563  02 A7
    DEFW $A709             ; $A565  09 A7
    DEFW $A711             ; $A567  11 A7
    DEFW $A720             ; $A569  20 A7
    DEFW $A72C             ; $A56B  2C A7
    DEFW $A736             ; $A56D  36 A7
    DEFW $A73B             ; $A56F  3B A7
    DEFW $A6D3             ; $A571  D3 A6
    DEFW $A75B             ; $A573  5B A7
    DEFW $A780             ; $A575  80 A7
    DEFW $A63A             ; $A577  3A A6
    DEFW $A78E             ; $A579  8E A7
    DEFW $A68C             ; $A57B  8C A6
    DEFW $A793             ; $A57D  93 A7
    DEFW $A7AC             ; $A57F  AC A7
    DEFW $A65C             ; $A581  5C A6
    DEFW $A7B4             ; $A583  B4 A7
    DEFW $A694             ; $A585  94 A6
    DEFW $A69C             ; $A587  9C A6
    DEFW $A6A4             ; $A589  A4 A6
    DEFW $A6AC             ; $A58B  AC A6
    DEFW $A360             ; $A58D  60 A3
    DEFW $A771             ; $A58F  71 A7
    DEFW $A684             ; $A591  84 A6
    DEFW $A852             ; $A593  52 A8
    DEFW $A682             ; $A595  82 A6
    DEFW $A63F             ; $A597  3F A6
    DEFW $A643             ; $A599  43 A6
    DEFW $A65A             ; $A59B  5A A6

; Puntatore agli argomenti sullo stack
    DEFB $00,$00           ; $A59D  00 00

; Interprete pubblico con argomenti sullo stack
;
; Preserva BC, DE, IX, AF; usa HL per l'indirizzo del testo. Memorizza in $A59D
; la posizione degli argomenti oltre l'indirizzo di ritorno. Alla fine
; ripristina i registri, recupera il ritorno e aggiusta SP per consumare gli
; argomenti. La convenzione completa dei singoli comandi resta da documentare.
    PUSH BC                ; $A59F  C5
    PUSH DE                ; $A5A0  D5
    PUSH IX                ; $A5A1  DD E5
    PUSH AF                ; $A5A3  F5
    PUSH HL                ; $A5A4  E5
    LD HL,$000C            ; $A5A5  21 0C 00
    ADD HL,SP              ; $A5A8  39
    LD ($A59D),HL          ; $A5A9  22 9D A5
    POP HL                 ; $A5AC  E1
    LD A,($A00B)           ; $A5AD  3A 0B A0
    AND A                  ; $A5B0  A7
    JR NZ,$A5B6            ; $A5B1  20 03
    LD ($A00C),A           ; $A5B3  32 0C A0
    CALL $A5C4             ; $A5B6  CD C4 A5
    POP AF                 ; $A5B9  F1
    POP IX                 ; $A5BA  DD E1
    POP DE                 ; $A5BC  D1
    POP BC                 ; $A5BD  C1
    POP HL                 ; $A5BE  E1
    LD SP,($A59D)          ; $A5BF  ED 7B 9D A5

; Salto indiretto tramite HL
;
; Used by the routine at #R$A5CD.
    JP (HL)                ; $A5C3  E9

; Interpreta una sequenza di token con inizio in HL
;
; IX diventa il cursore. Ripete $A5CD finche Z e zero; un comando terminale
; restituisce Z impostato. Per sequenze senza argomenti dinamici e utilizzabile
; direttamente, come nella prova a $6859.
    PUSH HL                ; $A5C4  E5
    POP IX                 ; $A5C5  DD E1
    CALL $A5CD             ; $A5C7  CD CD A5
    JR NZ,$A5C7            ; $A5CA  20 FB
    RET                    ; $A5CC  C9

; Decodifica e dispatch di un token
;
; Con bit 7 impostato: token lungo a due byte; D=primo byte AND $7F, E=secondo
; byte. I 12 bit bassi sono l'offset del dizionario, i bit 12-14 selezionano il
; contesto. I contesti $20/$30/$60 terminano la sequenza dopo la parola e
; passano da $A647.
    LD A,(IX+$00)          ; $A5CD  DD 7E 00
    BIT 7,A                ; $A5D0  CB 7F
    JR Z,$A5F2             ; $A5D2  28 1E
    AND $7F                ; $A5D4  E6 7F
    LD D,A                 ; $A5D6  57
    LD E,(IX+$01)          ; $A5D7  DD 5E 01
    INC IX                 ; $A5DA  DD 23
    AND $F0                ; $A5DC  E6 F0
    CP $30                 ; $A5DE  FE 30
    JR Z,$A647             ; $A5E0  28 65
    CP $20                 ; $A5E2  FE 20
    JR Z,$A647             ; $A5E4  28 61
    CP $60                 ; $A5E6  FE 60
    JR Z,$A647             ; $A5E8  28 5D
; This entry point is used by the routine at #R$A83A.
    CALL $A887             ; $A5EA  CD 87 A8
    INC IX                 ; $A5ED  DD 23
    OR $01                 ; $A5EF  F6 01
    RET                    ; $A5F1  C9
    CP $20                 ; $A5F2  FE 20 | {Token sotto $20: comando tramite tabella $A55D.
    JR C,$A621             ; $A5F4  38 2B | }
    CP $60                 ; $A5F6  FE 60 | {Token $60-$7F: parola frequente tramite $A83A/$A840.
    JP NC,$A83A            ; $A5F8  D2 3A A8 | }
    CP $40                 ; $A5FB  FE 40 | {Token $40-$5F: (token AND $1F)+1 caratteri a 5 bit
    JR C,$A61C             ; $A5FD  38 1D | immediatamente successivi.
    AND $1F                ; $A5FF  E6 1F
    INC A                  ; $A601  3C
    LD B,A                 ; $A602  47
    PUSH IX                ; $A603  DD E5
    POP HL                 ; $A605  E1
    INC HL                 ; $A606  23
    LD C,$00               ; $A607  0E 00 | }
    CALL $A990             ; $A609  CD 90 A9 | {Legge un carattere a 5 bit e lo invia al buffer di
    CALL $A9B7             ; $A60C  CD B7 A9 | uscita.
    DJNZ $A609             ; $A60F  10 F8 | }
    PUSH HL                ; $A611  E5 | {Aggiorna IX dopo i byte compatti, tenendo conto
    POP IX                 ; $A612  DD E1 | dell'allineamento.
    LD A,C                 ; $A614  79
    AND A                  ; $A615  A7
    JR NZ,$A5ED            ; $A616  20 D5
    DEC IX                 ; $A618  DD 2B
    JR $A5ED               ; $A61A  18 D1 | }
    CALL $A9B7             ; $A61C  CD B7 A9 | {Token $20-$3F: carattere letterale.
    JR $A5ED               ; $A61F  18 CC | }
    PUSH DE                ; $A621  D5 | {Selezione della routine del comando (2 byte per
    LD E,A                 ; $A622  5F | indirizzo).
    LD D,$00               ; $A623  16 00
    LD HL,$A55D            ; $A625  21 5D A5
    ADD HL,DE              ; $A628  19
    ADD HL,DE              ; $A629  19
    LD E,(HL)              ; $A62A  5E
    INC HL                 ; $A62B  23
    LD D,(HL)              ; $A62C  56
    EX DE,HL               ; $A62D  EB
    POP DE                 ; $A62E  D1 | }
    CP $1D                 ; $A62F  FE 1D | {Comandi $1D-$1F sono terminali e ricevono un salto
    JR NC,$A5C3            ; $A631  30 90 | diretto; gli altri vengono chiamati.
    CALL $A5C3             ; $A633  CD C3 A5
    JR Z,$A5ED             ; $A636  28 B5
    JR $A5EA               ; $A638  18 B0 | }

; Comando che emette A e restituisce Z impostato
    CALL $A9B7             ; $A63A  CD B7 A9
    XOR A                  ; $A63D  AF
    RET                    ; $A63E  C9

; Terminazione con ritorno a capo (contesto $60)
    LD D,$60               ; $A63F  16 60
    JR $A64A               ; $A641  18 07

; Terminazione con punto e ritorno a capo (contesto $30)
    LD D,$30               ; $A643  16 30
    JR $A64A               ; $A645  18 03

; Stampa la parola finale e applica la terminazione
;
; $20: solo fine; $30: punto e CR; $60: CR. I comandi $1D e $1E entrano
; rispettivamente da $A63F e $A643, senza stampare una parola.
    CALL $A887             ; $A647  CD 87 A8
; This entry point is used by the routines at #R$A63F and #R$A643.
    LD A,$2E               ; $A64A  3E 2E
    BIT 6,D                ; $A64C  CB 72
    JR NZ,$A657            ; $A64E  20 07
    BIT 4,D                ; $A650  CB 62
    CALL NZ,$A9B7          ; $A652  C4 B7 A9
    BIT 4,D                ; $A655  CB 62
    CALL NZ,$A2A2          ; $A657  C4 A2 A2
    XOR A                  ; $A65A  AF
    RET                    ; $A65B  C9


; Token compatto di parola frequente
;
; Used by the routine at #R$A5CD.
    ORG $A83A
    CALL $A840             ; $A83A  CD 40 A8
    JP $A5EA               ; $A83D  C3 EA A5

; Risoluzione della parola frequente
;
; A-$60 seleziona una delle 32 word a $67B7. Restituisce DE con offset e
; contesto $5000. Questo ingresso da solo non stampa.
    SUB $60                ; $A840  D6 60
    LD E,A                 ; $A842  5F
    LD D,$00               ; $A843  16 00
    LD HL,$67B7            ; $A845  21 B7 67
    ADD HL,DE              ; $A848  19
    ADD HL,DE              ; $A849  19
    LD E,(HL)              ; $A84A  5E
    INC HL                 ; $A84B  23
    LD A,(HL)              ; $A84C  7E
    ADD A,$50              ; $A84D  C6 50
    LD D,A                 ; $A84F  57
    RET                    ; $A850  C9

; Stato di forzatura delle maiuscole
    DEFB $00               ; $A851  00

; Alterna $A851 tra 0 e 1
    LD A,($A851)           ; $A852  3A 51 A8
    XOR $01                ; $A855  EE 01
    LD ($A851),A           ; $A857  32 51 A8
    XOR A                  ; $A85A  AF
    RET                    ; $A85B  C9

; Nove suffissi da quattro byte ciascuno
;
; S, ES, IES, backspace+IES, D, ING, ED, backspace+ING, LY. Gli zeri sono
; riempimento. $08 viene interpretato come arretramento nel buffer parola da
; $A9B7.
    DEFB $53,$00,$00,$00   ; $A85C  53 00 00 00
    DEFB $45,$53,$00,$00   ; $A860  45 53 00 00
    DEFB $49,$45,$53,$00   ; $A864  49 45 53 00
    DEFB $08,$49,$45,$53   ; $A868  08 49 45 53
    DEFB $44,$00,$00,$00   ; $A86C  44 00 00 00
    DEFB $49,$4E,$47,$00   ; $A870  49 4E 47 00
    DEFB $45,$44,$00,$00   ; $A874  45 44 00 00
    DEFB $08,$49,$4E,$47   ; $A878  08 49 4E 47
    DEFB $4C,$59,$00,$00   ; $A87C  4C 59 00 00

; Legge un riferimento dal puntatore HL e azzera il nibble di contesto
;
; Legge prima il byte basso, poi quello alto; avanza HL di due. A887 riceve
; solo i 12 bit bassi del riferimento.
    LD E,(HL)              ; $A880  5E
    INC HL                 ; $A881  23
    LD A,(HL)              ; $A882  7E
    INC HL                 ; $A883  23
    AND $0F                ; $A884  E6 0F
    LD D,A                 ; $A886  57

; Ricostruisce ed emette una voce del dizionario
;
; Non emette nulla se $5C3C e zero o l'offset e zero. Conserva IX, HL, BC, DE
; sul percorso normale. Inserisce uno spazio prima della voce. Trova il gruppo
; alfabetico nell'indice $5D80, emette l'iniziale implicita e decodifica
; sequenzialmente i record del gruppo fino all'offset richiesto. Applica poi
; l'eventuale suffisso e invia il resto della parola a $A9B7.
;
; DE Offset a 12 bit e contesto nel nibble alto.
    LD A,($5C3C)           ; $A887  3A 3C 5C
    AND A                  ; $A88A  A7
    RET Z                  ; $A88B  C8
    LD ($A022),DE          ; $A88C  ED 53 22 A0
    LD A,D                 ; $A890  7A
    AND $0F                ; $A891  E6 0F
    OR E                   ; $A893  B3
    RET Z                  ; $A894  C8
    PUSH IX                ; $A895  DD E5
    PUSH HL                ; $A897  E5
    PUSH BC                ; $A898  C5
    PUSH DE                ; $A899  D5
    LD A,$20               ; $A89A  3E 20
    CALL $A9B7             ; $A89C  CD B7 A9
    LD A,D                 ; $A89F  7A
    AND $F0                ; $A8A0  E6 F0
    LD C,A                 ; $A8A2  4F
    CP $70                 ; $A8A3  FE 70 | {Contesto $70: imposta $A026 per rendere maiuscola la
    LD A,$01               ; $A8A5  3E 01 | prossima lettera.
    JR NZ,$A8AC            ; $A8A7  20 03
    LD ($A026),A           ; $A8A9  32 26 A0
    LD A,D                 ; $A8AC  7A
    AND $0F                ; $A8AD  E6 0F
    LD D,A                 ; $A8AF  57
    EX DE,HL               ; $A8B0  EB
    PUSH HL                ; $A8B1  E5
    LD A,H                 ; $A8B2  7C
    OR C                   ; $A8B3  B1
    LD H,A                 ; $A8B4  67
    LD ($A022),HL          ; $A8B5  22 22 A0
    POP HL                 ; $A8B8  E1
    PUSH BC                ; $A8B9  C5 | }
    LD IX,$5D80            ; $A8BA  DD 21 80 5D | {Indice alfabetico, confrontato con l'offset richiesto.
    LD B,$5F               ; $A8BE  06 5F
    INC B                  ; $A8C0  04
    LD A,(IX+$01)          ; $A8C1  DD 7E 01
    CP H                   ; $A8C4  BC
    JR C,$A8CF             ; $A8C5  38 08
    JR NZ,$A8D9            ; $A8C7  20 10
    LD A,(IX+$00)          ; $A8C9  DD 7E 00
    CP L                   ; $A8CC  BD
    JR NC,$A8D9            ; $A8CD  30 0A
    INC IX                 ; $A8CF  DD 23
    INC IX                 ; $A8D1  DD 23
    LD A,B                 ; $A8D3  78
    CP $7B                 ; $A8D4  FE 7B
    JR NZ,$A8C0            ; $A8D6  20 E8
    INC B                  ; $A8D8  04
    JR Z,$A8E0             ; $A8D9  28 05
    DEC IX                 ; $A8DB  DD 2B
    DEC IX                 ; $A8DD  DD 2B
    DEC B                  ; $A8DF  05
    LD E,(IX+$00)          ; $A8E0  DD 5E 00
    LD D,(IX+$01)          ; $A8E3  DD 56 01
    LD A,D                 ; $A8E6  7A
    OR E                   ; $A8E7  B3
    JR Z,$A8DB             ; $A8E8  28 F1 | }
    LD A,B                 ; $A8EA  78 | {Emette l'iniziale ricostruita dal numero del gruppo.
    CALL $A9B7             ; $A8EB  CD B7 A9 | }
    LD BC,$5DBF            ; $A8EE  01 BF 5D | {Base relativa $5DBF: converte offset in indirizzi RAM.
    ADD HL,BC              ; $A8F1  09
    PUSH HL                ; $A8F2  E5
    EX DE,HL               ; $A8F3  EB
    ADD HL,BC              ; $A8F4  09 | }
    PUSH HL                ; $A8F5  E5 | {Decodifica record successivi finche arriva al record
    AND A                  ; $A8F6  A7 | richiesto.
    SBC HL,DE              ; $A8F7  ED 52
    POP HL                 ; $A8F9  E1
    PUSH AF                ; $A8FA  F5
    CALL $A95B             ; $A8FB  CD 5B A9
    POP AF                 ; $A8FE  F1
    JR NZ,$A8F5            ; $A8FF  20 F4
    POP HL                 ; $A901  E1
    POP BC                 ; $A902  C1 | }
    LD A,C                 ; $A903  79 | {Contesto $50: nessuna desinenza; $40: desinenza
    CP $50                 ; $A904  FE 50 | obbligatoria; $10: dipende da $A034; gli altri dipendono
    JR Z,$A91C             ; $A906  28 14 | da $A036.
    CP $40                 ; $A908  FE 40
    JR Z,$A919             ; $A90A  28 0D
    CP $10                 ; $A90C  FE 10
    LD A,($A034)           ; $A90E  3A 34 A0
    JR Z,$A916             ; $A911  28 03
    LD A,($A036)           ; $A913  3A 36 A0
    AND A                  ; $A916  A7
    JR Z,$A91C             ; $A917  28 03
    CALL $A92F             ; $A919  CD 2F A9 | }
    LD HL,$5C42            ; $A91C  21 42 5C | {Emette il buffer terminato da zero a $5C42.
    LD A,(HL)              ; $A91F  7E
    AND A                  ; $A920  A7
    JR Z,$A929             ; $A921  28 06
    CALL $A9B7             ; $A923  CD B7 A9
    INC HL                 ; $A926  23
    JR $A91F               ; $A927  18 F6
    POP DE                 ; $A929  D1
    POP BC                 ; $A92A  C1
    POP HL                 ; $A92B  E1
    POP IX                 ; $A92C  DD E1
    RET                    ; $A92E  C9 | }

; Appende il suffisso indicato dal record
;
; HL punta al primo byte del record e IX alla fine del buffer. Nibble basso $F:
; nessun suffisso. Altrimenti usa quattro byte da $A85C+4*nibble e aggiunge un
; terminatore zero. Nel dizionario presente gli indici sono soltanto 0-8 oppure
; $F.
    LD A,(HL)              ; $A92F  7E
    AND $0F                ; $A930  E6 0F
    CP $0F                 ; $A932  FE 0F
    RET Z                  ; $A934  C8
    RLCA                   ; $A935  07
    RLCA                   ; $A936  07
    LD L,A                 ; $A937  6F
    LD H,$00               ; $A938  26 00
    LD BC,$A85C            ; $A93A  01 5C A8
    ADD HL,BC              ; $A93D  09
    LD B,$04               ; $A93E  06 04
    LD A,(HL)              ; $A940  7E
    INC HL                 ; $A941  23
    LD (IX+$00),A          ; $A942  DD 77 00
    INC IX                 ; $A945  DD 23
    DJNZ $A940             ; $A947  10 F7
    LD (IX+$00),B          ; $A949  DD 70 00
    RET                    ; $A94C  C9

; Decodifica un record e applica il suo suffisso
    PUSH IX                ; $A94D  DD E5
    PUSH HL                ; $A94F  E5
    CALL $A95B             ; $A950  CD 5B A9
    EX (SP),HL             ; $A953  E3
    CALL $A92F             ; $A954  CD 2F A9
    POP HL                 ; $A957  E1
    POP IX                 ; $A958  DD E1
    RET                    ; $A95A  C9

; Decodifica il resto di una voce con riuso di prefisso
;
; Usa il buffer precedente a $5C42. Byte 1: bit 7 fa saltare due byte
; aggiuntivi; bit 4-6 indicano quanti caratteri precedenti conservare; bit 0-3
; indicano quanti nuovi caratteri a 5 bit leggere. La prima lettera del gruppo
; non e nel buffer. Restituisce HL al record successivo e IX sul terminatore.
; Conserva BC. La natura dei due byte aggiuntivi non e ancora identificata.
;
; HL Indirizzo del primo byte del record.
    PUSH BC                ; $A95B  C5
    LD IX,$5C42            ; $A95C  DD 21 42 5C
    INC HL                 ; $A960  23 | Salta il byte 0, contenente fra l'altro l'indice di
    LD A,(HL)              ; $A961  7E | {Legge il descrittore del record.
    BIT 7,A                ; $A962  CB 7F
    INC HL                 ; $A964  23
    JR Z,$A969             ; $A965  28 02
    INC HL                 ; $A967  23
    INC HL                 ; $A968  23 | }
    PUSH AF                ; $A969  F5 | {Conserva il prefisso del buffer precedente facendo
    AND $70                ; $A96A  E6 70 | avanzare IX.
    JR Z,$A974             ; $A96C  28 06
    INC IX                 ; $A96E  DD 23
    SUB $10                ; $A970  D6 10
    JR NZ,$A96E            ; $A972  20 FA | }
    LD C,$00               ; $A974  0E 00 | {C e il cursore di bit, inizialmente zero.
    POP AF                 ; $A976  F1
    AND $0F                ; $A977  E6 0F
    JR Z,$A986             ; $A979  28 0B
    LD B,A                 ; $A97B  47 | }
    CALL $A990             ; $A97C  CD 90 A9 | {Estrae i nuovi caratteri e li scrive nel buffer.
    LD (IX+$00),A          ; $A97F  DD 77 00
    INC IX                 ; $A982  DD 23
    DJNZ $A97C             ; $A984  10 F6 | }
    LD (IX+$00),$00        ; $A986  DD 36 00 00 | {Terminatore zero.
    LD A,C                 ; $A98A  79
    POP BC                 ; $A98B  C1 | }
    AND A                  ; $A98C  A7 | {Se restano bit parziali, avanza al byte successivo.
    RET Z                  ; $A98D  C8
    INC HL                 ; $A98E  23
    RET                    ; $A98F  C9 | }

; Estrae un carattere da un flusso a 5 bit
;
; Legge una finestra di due byte, la allinea al cursore C, prende cinque bit e
; aggiunge $60. A restituisce il carattere. HL e C avanzano di cinque bit; DE
; viene preservato.
;
; HL Puntatore al byte corrente.
; C Offset di bit nel byte (0-7), MSB per primo.
    PUSH DE                ; $A990  D5
    LD D,(HL)              ; $A991  56
    INC HL                 ; $A992  23
    LD E,(HL)              ; $A993  5E
    DEC HL                 ; $A994  2B
    LD A,C                 ; $A995  79
    AND A                  ; $A996  A7
    JR Z,$A9A0             ; $A997  28 07
    SLA E                  ; $A999  CB 23
    RL D                   ; $A99B  CB 12
    DEC A                  ; $A99D  3D
    JR NZ,$A999            ; $A99E  20 F9
    LD A,C                 ; $A9A0  79
    ADD A,$05              ; $A9A1  C6 05
    CP $08                 ; $A9A3  FE 08
    JR C,$A9AA             ; $A9A5  38 03
    SUB $08                ; $A9A7  D6 08
    INC HL                 ; $A9A9  23
    LD C,A                 ; $A9AA  4F
    LD A,D                 ; $A9AB  7A
    POP DE                 ; $A9AC  D1
    RRCA                   ; $A9AD  0F
    RRCA                   ; $A9AE  0F
    RRCA                   ; $A9AF  0F
    AND $1F                ; $A9B0  E6 1F
    ADD A,$60              ; $A9B2  C6 60
    RET                    ; $A9B4  C9

; Puntatore corrente del buffer parola (base $5C0B)
    DEFW $5C0B             ; $A9B5  0B 5C

; Buffer parola e a capo senza spezzare le parole
;
; Con $A027 diverso da zero salta direttamente a $C1E1. Nel percorso normale
; accoda il carattere; $08 arretra il puntatore. Spazio, CR e virgoletta
; svuotano il buffer: confronta la lunghezza con le colonne rimaste in $C1F5 ed
; eventualmente emette prima un CR. Poi invia i caratteri e il delimitatore a
; $AA14.
;
; A Carattere da accodare.
    PUSH AF                ; $A9B7  F5
    LD A,($A027)           ; $A9B8  3A 27 A0
    AND A                  ; $A9BB  A7
    JR NZ,$AA10            ; $A9BC  20 52
    POP AF                 ; $A9BE  F1
    PUSH AF                ; $A9BF  F5
    PUSH HL                ; $A9C0  E5
    LD HL,($A9B5)          ; $A9C1  2A B5 A9
    CP $20                 ; $A9C4  FE 20
    JR Z,$A9DF             ; $A9C6  28 17
    CP $0D                 ; $A9C8  FE 0D
    JR Z,$A9DF             ; $A9CA  28 13
    CP $22                 ; $A9CC  FE 22
    JR Z,$A9DF             ; $A9CE  28 0F
    CP $08                 ; $A9D0  FE 08
    JR NZ,$A9D7            ; $A9D2  20 03
    DEC HL                 ; $A9D4  2B
    JR $A9D9               ; $A9D5  18 02
    LD (HL),A              ; $A9D7  77
    INC HL                 ; $A9D8  23
    LD ($A9B5),HL          ; $A9D9  22 B5 A9
    POP HL                 ; $A9DC  E1
    POP AF                 ; $A9DD  F1
    RET                    ; $A9DE  C9
    PUSH DE                ; $A9DF  D5
    LD DE,$5C0B            ; $A9E0  11 0B 5C
    AND A                  ; $A9E3  A7
    SBC HL,DE              ; $A9E4  ED 52
    JR Z,$AA0B             ; $A9E6  28 23
    LD A,($C1F5)           ; $A9E8  3A F5 C1
    CP L                   ; $A9EB  BD
    PUSH AF                ; $A9EC  F5
    JR NC,$A9F4            ; $A9ED  30 05
    LD A,$0D               ; $A9EF  3E 0D
    CALL $AA14             ; $A9F1  CD 14 AA
    PUSH BC                ; $A9F4  C5
    LD B,L                 ; $A9F5  45
    LD HL,$5C0B            ; $A9F6  21 0B 5C
    LD ($A9B5),HL          ; $A9F9  22 B5 A9
    LD A,(HL)              ; $A9FC  7E
    CALL $AA14             ; $A9FD  CD 14 AA
    INC HL                 ; $AA00  23
    DJNZ $A9FC             ; $AA01  10 F9
    POP BC                 ; $AA03  C1
    POP AF                 ; $AA04  F1
    JR NZ,$AA0B            ; $AA05  20 04
    XOR A                  ; $AA07  AF
    LD ($A025),A           ; $AA08  32 25 A0
    POP DE                 ; $AA0B  D1
    POP HL                 ; $AA0C  E1
    POP AF                 ; $AA0D  F1
    JR $AA14               ; $AA0E  18 04
    POP AF                 ; $AA10  F1
    JP $C1E1               ; $AA11  C3 E1 C1

; Normalizzazione, spazi iniziali e maiuscole
;
; Converte inizialmente A-Z in a-z, sopprime lo spazio se $A025 e zero,
; aggiorna lo stato di riga. Punto e virgoletta impostano $A026. Una lettera
; diventa maiuscola se $A026 o $A851 e attivo. Infine salta a $C1E1.
    CP $41                 ; $AA14  FE 41
    JR C,$AA1E             ; $AA16  38 06
    CP $5B                 ; $AA18  FE 5B
    JR NC,$AA1E            ; $AA1A  30 02
    OR $20                 ; $AA1C  F6 20
    PUSH AF                ; $AA1E  F5
    LD A,($A025)           ; $AA1F  3A 25 A0
    AND A                  ; $AA22  A7
    JR NZ,$AA2A            ; $AA23  20 05
    POP AF                 ; $AA25  F1
    CP $20                 ; $AA26  FE 20
    RET Z                  ; $AA28  C8
    PUSH AF                ; $AA29  F5
    LD A,$01               ; $AA2A  3E 01
    LD ($A025),A           ; $AA2C  32 25 A0
    POP AF                 ; $AA2F  F1
    PUSH AF                ; $AA30  F5
    CP $0D                 ; $AA31  FE 0D
    JR NZ,$AA3B            ; $AA33  20 06
    XOR A                  ; $AA35  AF
    LD ($A025),A           ; $AA36  32 25 A0
    JR $AA6D               ; $AA39  18 32
    CP $22                 ; $AA3B  FE 22
    JR NZ,$AA46            ; $AA3D  20 07
    LD A,$20               ; $AA3F  3E 20
    CALL $C1E1             ; $AA41  CD E1 C1
    JR $AA4A               ; $AA44  18 04
    CP $2E                 ; $AA46  FE 2E
    JR NZ,$AA51            ; $AA48  20 07
    LD A,$01               ; $AA4A  3E 01
    LD ($A026),A           ; $AA4C  32 26 A0
    JR $AA6D               ; $AA4F  18 1C
    CP $61                 ; $AA51  FE 61
    JR C,$AA6D             ; $AA53  38 18
    CP $7B                 ; $AA55  FE 7B
    JR NC,$AA6D            ; $AA57  30 14
    LD A,($A851)           ; $AA59  3A 51 A8
    AND A                  ; $AA5C  A7
    JR NZ,$AA65            ; $AA5D  20 06
    LD A,($A026)           ; $AA5F  3A 26 A0
    AND A                  ; $AA62  A7
    JR Z,$AA6D             ; $AA63  28 08
    XOR A                  ; $AA65  AF
    LD ($A026),A           ; $AA66  32 26 A0
    POP AF                 ; $AA69  F1
    AND $5F                ; $AA6A  E6 5F
    PUSH AF                ; $AA6C  F5
    POP AF                 ; $AA6D  F1
    JP $C1E1               ; $AA6E  C3 E1 C1


; Pulisce lo schermo e imposta bordo bianco
;
; Used by the routine at #R$C14A.
    ORG $C10F
    LD A,$07               ; $C10F  3E 07
    OUT ($FE),A            ; $C111  D3 FE
    LD HL,$4000            ; $C113  21 00 40
    LD DE,$4001            ; $C116  11 01 40
    LD BC,$1800            ; $C119  01 00 18
    LD (HL),$00            ; $C11C  36 00
    LDIR                   ; $C11E  ED B0
    LD BC,$02FF            ; $C120  01 FF 02
    LD (HL),$38            ; $C123  36 38
    LDIR                   ; $C125  ED B0
    RET                    ; $C127  C9

; Stato di larghezza della finestra narrativa
    DEFB $00               ; $C128  00

; Imposta modo a 18 colonne
    XOR A                  ; $C129  AF
    LD ($A019),A           ; $C12A  32 19 A0
    INC A                  ; $C12D  3C
    LD ($C128),A           ; $C12E  32 28 C1
    LD A,$12               ; $C131  3E 12
; This entry point is used by the routine at #R$C142.
    LD ($C1F5),A           ; $C133  32 F5 C1
    LD HL,$5020            ; $C136  21 20 50
    LD ($C1F8),HL          ; $C139  22 F8 C1
    LD A,$02               ; $C13C  3E 02
    LD ($C1FA),A           ; $C13E  32 FA C1
    RET                    ; $C141  C9

; Imposta modo a 36 colonne
;
; Used by the routines at #R$C14A and #R$C306.
    XOR A                  ; $C142  AF
    LD ($C128),A           ; $C143  32 28 C1
    LD A,$24               ; $C146  3E 24
    JR $C133               ; $C148  18 E9

; Inizializza i due cursori e il motivo grafico
    CALL $C10F             ; $C14A  CD 0F C1
    LD A,$24               ; $C14D  3E 24
    LD ($C1F4),A           ; $C14F  32 F4 C1
    LD HL,$50E0            ; $C152  21 E0 50
    LD ($C1F6),HL          ; $C155  22 F6 C1
    LD A,$02               ; $C158  3E 02
    LD ($C1FB),A           ; $C15A  32 FB C1
    CALL $C142             ; $C15D  CD 42 C1
    LD HL,$5140            ; $C160  21 40 51
    LD DE,$C190            ; $C163  11 90 C1
    LD B,$06               ; $C166  06 06
    LD C,$08               ; $C168  0E 08
    PUSH BC                ; $C16A  C5
    PUSH HL                ; $C16B  E5
    LD B,$04               ; $C16C  06 04
    PUSH DE                ; $C16E  D5
    LD A,(DE)              ; $C16F  1A
    LD (HL),A              ; $C170  77
    INC DE                 ; $C171  13
    INC L                  ; $C172  2C
    DJNZ $C16F             ; $C173  10 FA
    POP DE                 ; $C175  D1
    DEC C                  ; $C176  0D
    JR NZ,$C16C            ; $C177  20 F3
    INC DE                 ; $C179  13
    INC DE                 ; $C17A  13
    INC DE                 ; $C17B  13
    INC DE                 ; $C17C  13
    POP HL                 ; $C17D  E1
    POP BC                 ; $C17E  C1
    INC H                  ; $C17F  24
    DJNZ $C168             ; $C180  10 E6
    LD HL,$5A40            ; $C182  21 40 5A
    LD DE,$5A41            ; $C185  11 41 5A
    LD BC,$001F            ; $C188  01 1F 00
    LD (HL),$78            ; $C18B  36 78
    LDIR                   ; $C18D  ED B0
    RET                    ; $C18F  C9

; Motivo grafico di 24 byte
    DEFB $00,$3F,$C1,$C0   ; $C190  00 3F C1 C0
    DEFB $20,$FE,$01,$C4   ; $C194  20 FE 01 C4
    DEFB $81,$E8,$0D,$81   ; $C198  81 E8 0D 81
    DEFB $41,$B0,$17,$82   ; $C19C  41 B0 17 82
    DEFB $83,$80,$7F,$01   ; $C1A0  83 80 7F 01
    DEFB $23,$83,$FC,$04   ; $C1A4  23 83 FC 04

; Stampa una stringa di lunghezza B a posizione fissa
;
; Stringa in HL. Imposta destinazione video $5041 e offset zero, emette uno
; spazio, B caratteri e uno spazio direttamente tramite $C388. Usata dalla
; visualizzazione dell'orologio a $BF79.
    LD DE,$5041            ; $C1A8  11 41 50
    EX DE,HL               ; $C1AB  EB
    LD C,$00               ; $C1AC  0E 00
    LD A,$20               ; $C1AE  3E 20
    CALL $C388             ; $C1B0  CD 88 C3
    LD A,(DE)              ; $C1B3  1A
    CALL $C388             ; $C1B4  CD 88 C3
    INC DE                 ; $C1B7  13
    DJNZ $C1B3             ; $C1B8  10 F9
    LD A,$20               ; $C1BA  3E 20
    CALL $C388             ; $C1BC  CD 88 C3
    RET                    ; $C1BF  C9

; Stampa stringa, attende un tasto e va a capo
;
; Used by the routine at #R$C1D8.
    CALL $C1CB             ; $C1C0  CD CB C1
    CALL $C415             ; $C1C3  CD 15 C4
    LD A,$0D               ; $C1C6  3E 0D
    JP $C1FD               ; $C1C8  C3 FD C1

; Stampa stringa non compressa con bit 7 di fine
;
; HL punta alla stringa. Emette ogni byte AND $7F tramite $C1FD e termina
; quando il byte sorgente ha bit 7 impostato. Non e il formato del dizionario
; compresso.
    LD A,(HL)              ; $C1CB  7E
    AND $7F                ; $C1CC  E6 7F
    CALL $C1FD             ; $C1CE  CD FD C1
    BIT 7,(HL)             ; $C1D1  CB 7E
    RET NZ                 ; $C1D3  C0
    INC HL                 ; $C1D4  23
    JR $C1CB               ; $C1D5  18 F4

; RET isolato
    RET                    ; $C1D7  C9

; Messaggio e salto a $A0EB
    LD HL,$13C5            ; $C1D8  21 C5 13
    CALL $C1C0             ; $C1DB  CD C0 C1
    JP $A0EB               ; $C1DE  C3 EB A0

; Selezione del canale di uscita
;
; Se $5C3C e zero, scarta il carattere. Altrimenti $A027=0 seleziona $C2BA;
; $A027 diverso da zero seleziona $C1FD.
    PUSH AF                ; $C1E1  F5
    LD A,($5C3C)           ; $C1E2  3A 3C 5C
    AND A                  ; $C1E5  A7
    JR NZ,$C1EA            ; $C1E6  20 02
    POP AF                 ; $C1E8  F1
    RET                    ; $C1E9  C9
    LD A,($A027)           ; $C1EA  3A 27 A0
    AND A                  ; $C1ED  A7
    JR NZ,$C1FC            ; $C1EE  20 0C
    POP AF                 ; $C1F0  F1
    JP $C2BA               ; $C1F1  C3 BA C2

; Stato dei due cursori video
    DEFB $00,$00           ; $C1F4  00 00 | Colonne rimaste: canale inferiore e superiore.
    DEFW $0000             ; $C1F6  00 00 | {Indirizzi bitmap: canale inferiore e superiore.
    DEFW $0000             ; $C1F8  00 00 | }
    DEFB $00,$00           ; $C1FA  00 00 | Offset orizzontali in bit: superiore e inferiore.

; Ripristina AF prima di entrare nel canale inferiore
;
; Used by the routine at #R$C1E1.
    POP AF                 ; $C1FC  F1

; Canale inferiore con cursore e gestione backspace
;
; Usa $C1F4/$C1F6/$C1FB. Gestisce CR e backspace; converte le lettere in
; maiuscolo. Disegna un segno + come cursore. Usa $C388 per i glifi.
    PUSH HL                ; $C1FD  E5
    PUSH BC                ; $C1FE  C5
    PUSH AF                ; $C1FF  F5
    LD A,($C1FB)           ; $C200  3A FB C1
    LD C,A                 ; $C203  4F
    POP AF                 ; $C204  F1
    PUSH AF                ; $C205  F5
    LD HL,($C1F6)          ; $C206  2A F6 C1
    CP $0D                 ; $C209  FE 0D
    JR NZ,$C214            ; $C20B  20 07
    LD A,$20               ; $C20D  3E 20
    CALL $C388             ; $C20F  CD 88 C3
    JR $C224               ; $C212  18 10
    CP $08                 ; $C214  FE 08
    JR Z,$C249             ; $C216  28 31
    CALL $C240             ; $C218  CD 40 C2
    CALL $C388             ; $C21B  CD 88 C3
    LD A,($C1F4)           ; $C21E  3A F4 C1
    DEC A                  ; $C221  3D
    JR NZ,$C22D            ; $C222  20 09
    LD L,$E0               ; $C224  2E E0
    LD C,$02               ; $C226  0E 02
    CALL $C271             ; $C228  CD 71 C2
    LD A,$24               ; $C22B  3E 24
; This entry point is used by the routine at #R$C249.
    LD ($C1F4),A           ; $C22D  32 F4 C1
    LD A,C                 ; $C230  79
    LD ($C1FB),A           ; $C231  32 FB C1
    LD ($C1F6),HL          ; $C234  22 F6 C1
    LD A,$2B               ; $C237  3E 2B
    CALL $C388             ; $C239  CD 88 C3
    POP AF                 ; $C23C  F1
    POP BC                 ; $C23D  C1
    POP HL                 ; $C23E  E1
    RET                    ; $C23F  C9

; Conversione ASCII a-z in A-Z
;
; Used by the routine at #R$C1FD.
    CP $61                 ; $C240  FE 61
    RET C                  ; $C242  D8
    CP $7B                 ; $C243  FE 7B
    RET NC                 ; $C245  D0
    AND $5F                ; $C246  E6 5F
    RET                    ; $C248  C9

; Gestione backspace del canale inferiore
;
; Used by the routine at #R$C1FD.
    LD A,$20               ; $C249  3E 20
    CALL $C388             ; $C24B  CD 88 C3
    CALL $C267             ; $C24E  CD 67 C2
    CALL $C267             ; $C251  CD 67 C2
    LD A,($C1F4)           ; $C254  3A F4 C1
    INC A                  ; $C257  3C
    CP $25                 ; $C258  FE 25
    JR NZ,$C22D            ; $C25A  20 D1
    LD L,$FE               ; $C25C  2E FE
    LD C,$07               ; $C25E  0E 07
    CALL $C29C             ; $C260  CD 9C C2
    LD A,$01               ; $C263  3E 01
    JR $C22D               ; $C265  18 C6

; Arretra il cursore di sette pixel
;
; Used by the routine at #R$C249.
    LD A,C                 ; $C267  79
    SUB $07                ; $C268  D6 07
    LD C,A                 ; $C26A  4F
    RET NC                 ; $C26B  D0
    DEC L                  ; $C26C  2D
    ADD A,$08              ; $C26D  C6 08
    LD C,A                 ; $C26F  4F
    RET                    ; $C270  C9

; Scorrimento verso l'alto del canale inferiore
;
; Used by the routine at #R$C1FD.
    PUSH HL                ; $C271  E5
    PUSH DE                ; $C272  D5
    PUSH BC                ; $C273  C5
    LD HL,$5080            ; $C274  21 80 50
    LD DE,$5060            ; $C277  11 60 50
    LD A,$08               ; $C27A  3E 08
    PUSH HL                ; $C27C  E5
    PUSH DE                ; $C27D  D5
    LD BC,$0080            ; $C27E  01 80 00
    LDIR                   ; $C281  ED B0
    POP DE                 ; $C283  D1
    POP HL                 ; $C284  E1
    INC H                  ; $C285  24
    INC D                  ; $C286  14
    DEC A                  ; $C287  3D
    JR NZ,$C27C            ; $C288  20 F2
    LD HL,$50E0            ; $C28A  21 E0 50
; This entry point is used by the routine at #R$C29C.
    LD B,$24               ; $C28D  06 24
    LD C,$01               ; $C28F  0E 01
    LD A,$20               ; $C291  3E 20
    CALL $C388             ; $C293  CD 88 C3
    DJNZ $C293             ; $C296  10 FB
    POP BC                 ; $C298  C1
    POP DE                 ; $C299  D1
    POP HL                 ; $C29A  E1
    RET                    ; $C29B  C9

; Scorrimento inverso del canale inferiore
;
; Used by the routine at #R$C249.
    PUSH HL                ; $C29C  E5
    PUSH DE                ; $C29D  D5
    PUSH BC                ; $C29E  C5
    LD HL,$50DF            ; $C29F  21 DF 50
    LD DE,$50FF            ; $C2A2  11 FF 50
    LD A,$08               ; $C2A5  3E 08
    PUSH HL                ; $C2A7  E5
    PUSH DE                ; $C2A8  D5
    LD BC,$0080            ; $C2A9  01 80 00
    LDDR                   ; $C2AC  ED B8
    POP DE                 ; $C2AE  D1
    POP HL                 ; $C2AF  E1
    INC H                  ; $C2B0  24
    INC D                  ; $C2B1  14
    DEC A                  ; $C2B2  3D
    JR NZ,$C2A7            ; $C2B3  20 F2
    LD HL,$5060            ; $C2B5  21 60 50
    JR $C28D               ; $C2B8  18 D3

; Canale superiore del testo narrativo
;
; Usa $C1F5/$C1F8/$C1FA. CR oppure esaurimento delle colonne attivano lo
; scorrimento $C316. Dopo un contatore di righe, $C306 attende un tasto. Il
; renderer e sempre $C388.
    PUSH HL                ; $C2BA  E5
    PUSH BC                ; $C2BB  C5
    PUSH AF                ; $C2BC  F5
    LD HL,($C1F8)          ; $C2BD  2A F8 C1
    LD A,($C1FA)           ; $C2C0  3A FA C1
    LD C,A                 ; $C2C3  4F
    POP AF                 ; $C2C4  F1
    PUSH AF                ; $C2C5  F5
    CP $0D                 ; $C2C6  FE 0D
    JR NZ,$C2EE            ; $C2C8  20 24
    LD A,($A019)           ; $C2CA  3A 19 A0
    CP $0F                 ; $C2CD  FE 0F
    JR NZ,$C2D6            ; $C2CF  20 05
    CALL $C306             ; $C2D1  CD 06 C3
    LD A,$FF               ; $C2D4  3E FF
    INC A                  ; $C2D6  3C
    LD ($A019),A           ; $C2D7  32 19 A0
    LD HL,$5020            ; $C2DA  21 20 50
    LD C,$02               ; $C2DD  0E 02
    CALL $C316             ; $C2DF  CD 16 C3
    LD A,($C128)           ; $C2E2  3A 28 C1
    AND A                  ; $C2E5  A7
    LD A,$24               ; $C2E6  3E 24
    JR Z,$C2F8             ; $C2E8  28 0E
    LD A,$12               ; $C2EA  3E 12
    JR $C2F8               ; $C2EC  18 0A
    CALL $C388             ; $C2EE  CD 88 C3
    LD A,($C1F5)           ; $C2F1  3A F5 C1
    DEC A                  ; $C2F4  3D
    JP Z,$C2CA             ; $C2F5  CA CA C2
    LD ($C1F5),A           ; $C2F8  32 F5 C1
    LD ($C1F8),HL          ; $C2FB  22 F8 C1
    LD A,C                 ; $C2FE  79
    LD ($C1FA),A           ; $C2FF  32 FA C1
    POP AF                 ; $C302  F1
    POP BC                 ; $C303  C1
    POP HL                 ; $C304  E1
    RET                    ; $C305  C9

; Pausa di paginazione e ripristino del modo largo
;
; Used by the routine at #R$C2BA.
    PUSH HL                ; $C306  E5
    LD HL,$5A5F            ; $C307  21 5F 5A
    SET 7,(HL)             ; $C30A  CB FE
    CALL $C415             ; $C30C  CD 15 C4
    RES 7,(HL)             ; $C30F  CB BE
    CALL $C142             ; $C311  CD 42 C1
    POP HL                 ; $C314  E1
    RET                    ; $C315  C9

; Scorrimento della finestra superiore
;
; Used by the routine at #R$C2BA.
    LD A,($C128)           ; $C316  3A 28 C1
    AND A                  ; $C319  A7
    CALL Z,$C3E4           ; $C31A  CC E4 C3
    PUSH BC                ; $C31D  C5
    PUSH HL                ; $C31E  E5
    PUSH DE                ; $C31F  D5
    LD HL,$4020            ; $C320  21 20 40
    LD DE,$4000            ; $C323  11 00 40
    LD BC,$0011            ; $C326  01 11 00
    LD A,($C128)           ; $C329  3A 28 C1
    AND A                  ; $C32C  A7
    LD A,$20               ; $C32D  3E 20
    JR Z,$C333             ; $C32F  28 02
    LD A,$10               ; $C331  3E 10
    PUSH HL                ; $C333  E5
    PUSH DE                ; $C334  D5
    PUSH BC                ; $C335  C5
    LD C,$08               ; $C336  0E 08
    PUSH HL                ; $C338  E5
    PUSH DE                ; $C339  D5
    PUSH BC                ; $C33A  C5
    LD C,A                 ; $C33B  4F
    LDIR                   ; $C33C  ED B0
    POP BC                 ; $C33E  C1
    POP DE                 ; $C33F  D1
    POP HL                 ; $C340  E1
    INC H                  ; $C341  24
    INC D                  ; $C342  14
    DEC C                  ; $C343  0D
    JR NZ,$C338            ; $C344  20 F2
    POP BC                 ; $C346  C1
    POP DE                 ; $C347  D1
    POP HL                 ; $C348  E1
    PUSH AF                ; $C349  F5
    CALL $C37D             ; $C34A  CD 7D C3
    CALL $C37D             ; $C34D  CD 7D C3
    POP AF                 ; $C350  F1
    DEC C                  ; $C351  0D
    JR NZ,$C333            ; $C352  20 DF
    CP $10                 ; $C354  FE 10
    JR Z,$C363             ; $C356  28 0B
    LD HL,$5820            ; $C358  21 20 58
    LD DE,$5800            ; $C35B  11 00 58
    LD BC,$0220            ; $C35E  01 20 02
    LDIR                   ; $C361  ED B0
    LD A,($C128)           ; $C363  3A 28 C1
    AND A                  ; $C366  A7
    LD B,$24               ; $C367  06 24
    JR Z,$C36D             ; $C369  28 02
    LD B,$12               ; $C36B  06 12
    LD HL,$5020            ; $C36D  21 20 50
    LD C,$02               ; $C370  0E 02
    LD A,$20               ; $C372  3E 20
    CALL $C388             ; $C374  CD 88 C3
    DJNZ $C374             ; $C377  10 FB
    POP DE                 ; $C379  D1
    POP HL                 ; $C37A  E1
    POP BC                 ; $C37B  C1
    RET                    ; $C37C  C9

; Avanzamento di una riga carattere nella bitmap Spectrum
;
; Used by the routine at #R$C316.
    EX DE,HL               ; $C37D  EB
    LD A,L                 ; $C37E  7D
    ADD A,$20              ; $C37F  C6 20
    LD L,A                 ; $C381  6F
    RET NC                 ; $C382  D0
    LD A,H                 ; $C383  7C
    ADD A,$08              ; $C384  C6 08
    LD H,A                 ; $C386  67
    RET                    ; $C387  C9

; Disegna un glifo ROM alla posizione indicata
;
; Indirizzo font=$3C00+8*A. Legge otto righe e le combina tramite maschere con
; uno o due byte dello schermo. INC H passa alla riga pixel seguente. Alla fine
; HL/C avanzano di SETTE pixel, non otto. Preserva A, B e DE; modifica i flag.
; Non invoca la routine PRINT della ROM.
;
; A Codice carattere.
; HL Indirizzo bitmap della prima riga del glifo.
; C Offset orizzontale in bit (0-7).
    PUSH AF                ; $C388  F5
    PUSH BC                ; $C389  C5
    PUSH DE                ; $C38A  D5
    PUSH HL                ; $C38B  E5
    LD L,A                 ; $C38C  6F | {Calcola 8*A.
    LD H,$00               ; $C38D  26 00
    ADD HL,HL              ; $C38F  29
    ADD HL,HL              ; $C390  29
    ADD HL,HL              ; $C391  29 | }
    LD DE,$3C00            ; $C392  11 00 3C | {Base per la tabella caratteri ROM.
    ADD HL,DE              ; $C395  19
    EX DE,HL               ; $C396  EB
    POP HL                 ; $C397  E1
    PUSH HL                ; $C398  E5 | }
    LD B,$08               ; $C399  06 08 | Otto righe per glifo.
    LD A,(DE)              ; $C39B  1A | {Allinea e unisce la prima porzione di riga al byte
    PUSH BC                ; $C39C  C5 | video.
    PUSH AF                ; $C39D  F5
    DEC C                  ; $C39E  0D
    INC C                  ; $C39F  0C
    LD B,$FF               ; $C3A0  06 FF
    JR Z,$C3AB             ; $C3A2  28 07
    SRL A                  ; $C3A4  CB 3F
    SRL B                  ; $C3A6  CB 38
    DEC C                  ; $C3A8  0D
    JR NZ,$C3A4            ; $C3A9  20 F9
    LD C,A                 ; $C3AB  4F
    LD A,B                 ; $C3AC  78
    CPL                    ; $C3AD  2F
    AND (HL)               ; $C3AE  A6
    OR C                   ; $C3AF  B1
    LD (HL),A              ; $C3B0  77
    POP AF                 ; $C3B1  F1
    POP BC                 ; $C3B2  C1 | }
    DEC C                  ; $C3B3  0D | {Se C non e zero, unisce anche la porzione nel byte
    INC C                  ; $C3B4  0C | successivo.
    JR Z,$C3D0             ; $C3B5  28 19
    PUSH BC                ; $C3B7  C5
    PUSH AF                ; $C3B8  F5
    LD A,$08               ; $C3B9  3E 08
    SUB C                  ; $C3BB  91
    LD C,A                 ; $C3BC  4F
    POP AF                 ; $C3BD  F1
    LD B,$FF               ; $C3BE  06 FF
    SLA A                  ; $C3C0  CB 27
    SLA B                  ; $C3C2  CB 20
    DEC C                  ; $C3C4  0D
    JR NZ,$C3C0            ; $C3C5  20 F9
    LD C,A                 ; $C3C7  4F
    LD A,B                 ; $C3C8  78
    CPL                    ; $C3C9  2F
    INC HL                 ; $C3CA  23
    AND (HL)               ; $C3CB  A6
    OR C                   ; $C3CC  B1
    LD (HL),A              ; $C3CD  77
    DEC HL                 ; $C3CE  2B
    POP BC                 ; $C3CF  C1
    INC DE                 ; $C3D0  13
    INC H                  ; $C3D1  24
    DJNZ $C39B             ; $C3D2  10 C7
    POP HL                 ; $C3D4  E1
    POP DE                 ; $C3D5  D1
    POP BC                 ; $C3D6  C1 | }
    LD A,C                 ; $C3D7  79 | {Avanzamento orizzontale di sette pixel.
    ADD A,$07              ; $C3D8  C6 07
    CP $08                 ; $C3DA  FE 08
    JR C,$C3E1             ; $C3DC  38 03
    SUB $08                ; $C3DE  D6 08
    INC L                  ; $C3E0  2C
    LD C,A                 ; $C3E1  4F
    POP AF                 ; $C3E2  F1
    RET                    ; $C3E3  C9 | }

