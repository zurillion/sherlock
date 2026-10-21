; Sherlock Spectrum v2.0 - parser: estratti verificati
; Indirizzi assoluti. Dati intercalati emessi come DEFB, non disassemblati.
; Etichette/commenti sono interpretazioni; i byte sono quelli del payload.


    ORG $6859
; DATA $6859..$6869

; Frase compressa: I do not know the word + virgoletta.
    DEFB $6B,$6F,$6D,$D4,$AD,$60,$20,$43 ; $6859  6B 6F 6D D4 AD 60 20 43
    DEFB $BB,$E4,$40,$22,$1F  ; $6861  BB E4 40 22 1F

; Frase compressa: What ? + CR.
    DEFB $7D,$20,$3F,$1D      ; $6866  7D 20 3F 1D

    ORG $A536
; CODE $A536..$A55C

; Lettura tasto con timeout; zero = nessun comando. Iniettata nelle prove.
    PUSH HL                   ; $A536  E5
    LD HL,($A03B)             ; $A537  2A 3B A0
    CALL $C41F                ; $A53A  CD 1F C4
    BIT 7,A                   ; $A53D  CB 7F
    JR NZ,$A553               ; $A53F  20 12
    LD A,$00                  ; $A541  3E 00
    DEC A                     ; $A543  3D
    PUSH HL                   ; $A544  E5
    POP HL                    ; $A545  E1
    JR NZ,$A543               ; $A546  20 FB
    DEC HL                    ; $A548  2B
    LD A,H                    ; $A549  7C
    OR L                      ; $A54A  B5
    JR NZ,$A53A               ; $A54B  20 ED
    POP HL                    ; $A54D  E1
    PUSH HL                   ; $A54E  E5
    CALL $D9B7                ; $A54F  CD B7 D9
    XOR A                     ; $A552  AF
    AND $7F                   ; $A553  E6 7F
    LD HL,$0BB8               ; $A555  21 B8 0B
    LD ($A03B),HL             ; $A558  22 3B A0
    POP HL                    ; $A55B  E1
    RET                       ; $A55C  C9

    ORG $A85C
; DATA $A85C..$A87F

; Nove suffissi da quattro byte; maiuscoli. Il backspace e un byte 08.
    DEFB $53,$00,$00,$00,$45,$53,$00,$00 ; $A85C  53 00 00 00 45 53 00 00
    DEFB $49,$45,$53,$00,$08,$49,$45,$53 ; $A864  49 45 53 00 08 49 45 53
    DEFB $44,$00,$00,$00,$49,$4E,$47,$00 ; $A86C  44 00 00 00 49 4E 47 00
    DEFB $45,$44,$00,$00,$08,$49,$4E,$47 ; $A874  45 44 00 00 08 49 4E 47
    DEFB $4C,$59,$00,$00      ; $A87C  4C 59 00 00

    ORG $A887
; CODE $A887..$A9B4

; Stampa parola: rispetta 5C3C. Foggy London modifica A88B, qui NON modificato.
    LD A,($5C3C)              ; $A887  3A 3C 5C
    AND A                     ; $A88A  A7
    RET Z                     ; $A88B  C8
    LD ($A022),DE             ; $A88C  ED 53 22 A0
    LD A,D                    ; $A890  7A
    AND $0F                   ; $A891  E6 0F
    OR E                      ; $A893  B3
    RET Z                     ; $A894  C8
    PUSH IX                   ; $A895  DD E5
    PUSH HL                   ; $A897  E5
    PUSH BC                   ; $A898  C5
    PUSH DE                   ; $A899  D5
    LD A,$20                  ; $A89A  3E 20
    CALL $A9B7                ; $A89C  CD B7 A9
    LD A,D                    ; $A89F  7A
    AND $F0                   ; $A8A0  E6 F0
    LD C,A                    ; $A8A2  4F
    CP $70                    ; $A8A3  FE 70
    LD A,$01                  ; $A8A5  3E 01
    JR NZ,$A8AC               ; $A8A7  20 03
    LD ($A026),A              ; $A8A9  32 26 A0
    LD A,D                    ; $A8AC  7A
    AND $0F                   ; $A8AD  E6 0F
    LD D,A                    ; $A8AF  57
    EX DE,HL                  ; $A8B0  EB
    PUSH HL                   ; $A8B1  E5
    LD A,H                    ; $A8B2  7C
    OR C                      ; $A8B3  B1
    LD H,A                    ; $A8B4  67
    LD ($A022),HL             ; $A8B5  22 22 A0
    POP HL                    ; $A8B8  E1
    PUSH BC                   ; $A8B9  C5
    LD IX,$5D80               ; $A8BA  DD 21 80 5D
    LD B,$5F                  ; $A8BE  06 5F
    INC B                     ; $A8C0  04
    LD A,(IX+$01)             ; $A8C1  DD 7E 01
    CP H                      ; $A8C4  BC
    JR C,$A8CF                ; $A8C5  38 08
    JR NZ,$A8D9               ; $A8C7  20 10
    LD A,(IX+$00)             ; $A8C9  DD 7E 00
    CP L                      ; $A8CC  BD
    JR NC,$A8D9               ; $A8CD  30 0A
    INC IX                    ; $A8CF  DD 23
    INC IX                    ; $A8D1  DD 23
    LD A,B                    ; $A8D3  78
    CP $7B                    ; $A8D4  FE 7B
    JR NZ,$A8C0               ; $A8D6  20 E8
    INC B                     ; $A8D8  04
    JR Z,$A8E0                ; $A8D9  28 05
    DEC IX                    ; $A8DB  DD 2B
    DEC IX                    ; $A8DD  DD 2B
    DEC B                     ; $A8DF  05
    LD E,(IX+$00)             ; $A8E0  DD 5E 00
    LD D,(IX+$01)             ; $A8E3  DD 56 01
    LD A,D                    ; $A8E6  7A
    OR E                      ; $A8E7  B3
    JR Z,$A8DB                ; $A8E8  28 F1
    LD A,B                    ; $A8EA  78
    CALL $A9B7                ; $A8EB  CD B7 A9
    LD BC,$5DBF               ; $A8EE  01 BF 5D
    ADD HL,BC                 ; $A8F1  09
    PUSH HL                   ; $A8F2  E5
    EX DE,HL                  ; $A8F3  EB
    ADD HL,BC                 ; $A8F4  09
    PUSH HL                   ; $A8F5  E5
    AND A                     ; $A8F6  A7
    SBC HL,DE                 ; $A8F7  ED 52
    POP HL                    ; $A8F9  E1
    PUSH AF                   ; $A8FA  F5
    CALL $A95B                ; $A8FB  CD 5B A9
    POP AF                    ; $A8FE  F1
    JR NZ,$A8F5               ; $A8FF  20 F4
    POP HL                    ; $A901  E1
    POP BC                    ; $A902  C1
    LD A,C                    ; $A903  79
    CP $50                    ; $A904  FE 50
    JR Z,$A91C                ; $A906  28 14
    CP $40                    ; $A908  FE 40
    JR Z,$A919                ; $A90A  28 0D
    CP $10                    ; $A90C  FE 10
    LD A,($A034)              ; $A90E  3A 34 A0
    JR Z,$A916                ; $A911  28 03
    LD A,($A036)              ; $A913  3A 36 A0
    AND A                     ; $A916  A7
    JR Z,$A91C                ; $A917  28 03
    CALL $A92F                ; $A919  CD 2F A9
    LD HL,$5C42               ; $A91C  21 42 5C
    LD A,(HL)                 ; $A91F  7E
    AND A                     ; $A920  A7
    JR Z,$A929                ; $A921  28 06
    CALL $A9B7                ; $A923  CD B7 A9
    INC HL                    ; $A926  23
    JR $A91F                  ; $A927  18 F6
    POP DE                    ; $A929  D1
    POP BC                    ; $A92A  C1
    POP HL                    ; $A92B  E1
    POP IX                    ; $A92C  DD E1
    RET                       ; $A92E  C9

; Appende quattro byte di suffisso, senza applicare backspace o lowercase.
    LD A,(HL)                 ; $A92F  7E
    AND $0F                   ; $A930  E6 0F
    CP $0F                    ; $A932  FE 0F
    RET Z                     ; $A934  C8
    RLCA                      ; $A935  07
    RLCA                      ; $A936  07
    LD L,A                    ; $A937  6F
    LD H,$00                  ; $A938  26 00
    LD BC,$A85C               ; $A93A  01 5C A8
    ADD HL,BC                 ; $A93D  09
    LD B,$04                  ; $A93E  06 04
    LD A,(HL)                 ; $A940  7E
    INC HL                    ; $A941  23
    LD (IX+$00),A             ; $A942  DD 77 00
    INC IX                    ; $A945  DD 23
    DJNZ $A940                ; $A947  10 F7
    LD (IX+$00),B             ; $A949  DD 70 00
    RET                       ; $A94C  C9

; Decomprime record e appende suffisso; HL avanza al record successivo.
    PUSH IX                   ; $A94D  DD E5
    PUSH HL                   ; $A94F  E5
    CALL $A95B                ; $A950  CD 5B A9
    EX (SP),HL                ; $A953  E3
    CALL $A92F                ; $A954  CD 2F A9
    POP HL                    ; $A957  E1
    POP IX                    ; $A958  DD E1
    RET                       ; $A95A  C9

; Decompressione incrementale in 5C42; prima lettera implicita.
    PUSH BC                   ; $A95B  C5
    LD IX,$5C42               ; $A95C  DD 21 42 5C
    INC HL                    ; $A960  23
    LD A,(HL)                 ; $A961  7E
    BIT 7,A                   ; $A962  CB 7F
    INC HL                    ; $A964  23
    JR Z,$A969                ; $A965  28 02
    INC HL                    ; $A967  23
    INC HL                    ; $A968  23
    PUSH AF                   ; $A969  F5
    AND $70                   ; $A96A  E6 70
    JR Z,$A974                ; $A96C  28 06
    INC IX                    ; $A96E  DD 23
    SUB $10                   ; $A970  D6 10
    JR NZ,$A96E               ; $A972  20 FA
    LD C,$00                  ; $A974  0E 00
    POP AF                    ; $A976  F1
    AND $0F                   ; $A977  E6 0F
    JR Z,$A986                ; $A979  28 0B
    LD B,A                    ; $A97B  47
    CALL $A990                ; $A97C  CD 90 A9
    LD (IX+$00),A             ; $A97F  DD 77 00
    INC IX                    ; $A982  DD 23
    DJNZ $A97C                ; $A984  10 F6
    LD (IX+$00),$00           ; $A986  DD 36 00 00
    LD A,C                    ; $A98A  79
    POP BC                    ; $A98B  C1
    AND A                     ; $A98C  A7
    RET Z                     ; $A98D  C8
    INC HL                    ; $A98E  23
    RET                       ; $A98F  C9
    PUSH DE                   ; $A990  D5
    LD D,(HL)                 ; $A991  56
    INC HL                    ; $A992  23
    LD E,(HL)                 ; $A993  5E
    DEC HL                    ; $A994  2B
    LD A,C                    ; $A995  79
    AND A                     ; $A996  A7
    JR Z,$A9A0                ; $A997  28 07
    SLA E                     ; $A999  CB 23
    RL D                      ; $A99B  CB 12
    DEC A                     ; $A99D  3D
    JR NZ,$A999               ; $A99E  20 F9
    LD A,C                    ; $A9A0  79
    ADD A,$05                 ; $A9A1  C6 05
    CP $08                    ; $A9A3  FE 08
    JR C,$A9AA                ; $A9A5  38 03
    SUB $08                   ; $A9A7  D6 08
    INC HL                    ; $A9A9  23
    LD C,A                    ; $A9AA  4F
    LD A,D                    ; $A9AB  7A
    POP DE                    ; $A9AC  D1
    RRCA                      ; $A9AD  0F
    RRCA                      ; $A9AE  0F
    RRCA                      ; $A9AF  0F
    AND $1F                   ; $A9B0  E6 1F
    ADD A,$60                 ; $A9B2  C6 60
    RET                       ; $A9B4  C9

    ORG $AAA1
; DATA $AAA1..$AAB1

; Variabili di backtracking e scratch del parser; NON istruzioni.
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $AAA1  00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $AAA9  00 00 00 00 00 00 00 00
    DEFB $00                  ; $AAB1  00

    ORG $AAB2
; CODE $AAB2..$AF6A

; Parser: inizializza stato e lista di comandi.
    XOR A                     ; $AAB2  AF
    LD ($A01A),A              ; $AAB3  32 1A A0
    LD ($A012),A              ; $AAB6  32 12 A0
    LD E,$FF                  ; $AAB9  1E FF
    LD D,$C0                  ; $AABB  16 C0

; Inizio nuovo nodo della lista; conserva parte dei flag E.
    LD A,E                    ; $AABD  7B
    OR $C7                    ; $AABE  F6 C7
    LD E,A                    ; $AAC0  5F
    CALL $AE6A                ; $AAC1  CD 6A AE
    LD A,($A01B)              ; $AAC4  3A 1B A0
    AND A                     ; $AAC7  A7
    JR Z,$AAD1                ; $AAC8  28 07
    LD A,$01                  ; $AACA  3E 01
    LD ($A024),A              ; $AACC  32 24 A0
    RES 3,E                   ; $AACF  CB 9B
    PUSH DE                   ; $AAD1  D5
    LD A,($A024)              ; $AAD2  3A 24 A0
    AND A                     ; $AAD5  A7
    JR NZ,$AB11               ; $AAD6  20 39
    LD ($AAA7),A              ; $AAD8  32 A7 AA
    LD HL,($A02B)             ; $AADB  2A 2B A0
    PUSH HL                   ; $AADE  E5
    CALL $AC24                ; $AADF  CD 24 AC
    JR NZ,$AB08               ; $AAE2  20 24
    LD A,($AAA7)              ; $AAE4  3A A7 AA
    AND A                     ; $AAE7  A7
    JR NZ,$AB08               ; $AAE8  20 1E
    LD A,$02                  ; $AAEA  3E 02
    LD ($A024),A              ; $AAEC  32 24 A0
    POP HL                    ; $AAEF  E1
    PUSH IY                   ; $AAF0  FD E5
    POP HL                    ; $AAF2  E1
    LD DE,$0018               ; $AAF3  11 18 00
    ADD HL,DE                 ; $AAF6  19
    LD DE,$AAAC               ; $AAF7  11 AC AA
    EX DE,HL                  ; $AAFA  EB
    LD BC,$0006               ; $AAFB  01 06 00
    LDIR                      ; $AAFE  ED B0
    LD HL,($A029)             ; $AB00  2A 29 A0
    LD ($A02B),HL             ; $AB03  22 2B A0
    JR $AB11                  ; $AB06  18 09
    LD A,$01                  ; $AB08  3E 01
    LD ($A024),A              ; $AB0A  32 24 A0
    POP HL                    ; $AB0D  E1
    LD ($A02B),HL             ; $AB0E  22 2B A0

; Cerca gruppo verbale, poi gruppi nominali.
    POP DE                    ; $AB11  D1
    XOR A                     ; $AB12  AF
    LD ($AAA7),A              ; $AB13  32 A7 AA
    CALL $AB91                ; $AB16  CD 91 AB
    JR C,$AB8E                ; $AB19  38 73
    JR Z,$AB47                ; $AB1B  28 2A
    CP $90                    ; $AB1D  FE 90
    JP Z,$AFB3                ; $AB1F  CA B3 AF
    CP $A0                    ; $AB22  FE A0
    JP Z,$ACCC                ; $AB24  CA CC AC
    BIT 3,E                   ; $AB27  CB 5B
    JR Z,$AB4C                ; $AB29  28 21
    LD A,($A012)              ; $AB2B  3A 12 A0
    AND A                     ; $AB2E  A7
    JR NZ,$AB8E               ; $AB2F  20 5D
    LD A,($A01B)              ; $AB31  3A 1B A0
    AND A                     ; $AB34  A7
    JR NZ,$AB4C               ; $AB35  20 15
    LD A,($A02D)              ; $AB37  3A 2D A0
    CP $C0                    ; $AB3A  FE C0
    JR NZ,$AB8E               ; $AB3C  20 50
    LD A,$B0                  ; $AB3E  3E B0
    CP D                      ; $AB40  BA
    JR NZ,$AB8E               ; $AB41  20 4B

; A=2: caso speciale/vuoto, distinto dall errore A=1.
    LD A,$02                  ; $AB43  3E 02
    AND A                     ; $AB45  A7
    RET                       ; $AB46  C9
    BIT 3,E                   ; $AB47  CB 5B
    JP Z,$ACFB                ; $AB49  CA FB AC
    LD HL,($A029)             ; $AB4C  2A 29 A0
    LD ($A02B),HL             ; $AB4F  22 2B A0
    CALL $AC24                ; $AB52  CD 24 AC
    JR C,$AB8E                ; $AB55  38 37
    JR NZ,$AB60               ; $AB57  20 07
    CALL $ACA6                ; $AB59  CD A6 AC
    JR Z,$AB8E                ; $AB5C  28 30
    JR $AB4C                  ; $AB5E  18 EC
    CP $B0                    ; $AB60  FE B0
    JP Z,$AD57                ; $AB62  CA 57 AD
    CP $A0                    ; $AB65  FE A0
    JP Z,$ACCC                ; $AB67  CA CC AC
    CP $90                    ; $AB6A  FE 90
    JP Z,$AFB3                ; $AB6C  CA B3 AF
    LD HL,($A029)             ; $AB6F  2A 29 A0
    LD ($A02B),HL             ; $AB72  22 2B A0
    LD A,($A024)              ; $AB75  3A 24 A0
    CP $02                    ; $AB78  FE 02
    JR NZ,$AB8E               ; $AB7A  20 12
    CALL $ABF3                ; $AB7C  CD F3 AB
    JR C,$AB8E                ; $AB7F  38 0D
    JR NZ,$AB8E               ; $AB81  20 0B
    LD HL,($A029)             ; $AB83  2A 29 A0
    LD ($A02B),HL             ; $AB86  22 2B A0
    LD D,$A0                  ; $AB89  16 A0
    JP $ACCC                  ; $AB8B  C3 CC AC
    JP $AF67                  ; $AB8E  C3 67 AF

; Gruppo verbale: classi 30,40,20,00; E0 saltata.
    LD A,($A024)              ; $AB91  3A 24 A0
    CP $02                    ; $AB94  FE 02
    JR Z,$ABF3                ; $AB96  28 5B
    LD A,E                    ; $AB98  7B
    OR $07                    ; $AB99  F6 07
    LD E,A                    ; $AB9B  5F
    CALL $AE7F                ; $AB9C  CD 7F AE
    CP $E0                    ; $AB9F  FE E0
    JR Z,$AB9C                ; $ABA1  28 F9
    CP $30                    ; $ABA3  FE 30
    JR NZ,$ABB7               ; $ABA5  20 10
    BIT 1,E                   ; $ABA7  CB 4B
    JR Z,$ABB5                ; $ABA9  28 0A
    RES 1,E                   ; $ABAB  CB 8B
    LD (IY+$00),C             ; $ABAD  FD 71 00
    LD (IY+$01),B             ; $ABB0  FD 70 01
    JR $AB9C                  ; $ABB3  18 E7

; Carry: combinazione verbale non ammessa.
    SCF                       ; $ABB5  37
    RET                       ; $ABB6  C9
    CP $00                    ; $ABB7  FE 00
    JR NZ,$ABC9               ; $ABB9  20 0E
    BIT 2,E                   ; $ABBB  CB 53
    JR Z,$ABB5                ; $ABBD  28 F6
    RES 2,E                   ; $ABBF  CB 93
    LD (IY+$02),C             ; $ABC1  FD 71 02
    LD (IY+$03),B             ; $ABC4  FD 70 03
    JR $AB9C                  ; $ABC7  18 D3
    CP $40                    ; $ABC9  FE 40
    JR NZ,$ABD1               ; $ABCB  20 04
    RES 0,E                   ; $ABCD  CB 83
    JR $ABA7                  ; $ABCF  18 D6
    CP $20                    ; $ABD1  FE 20
    JR NZ,$ABEF               ; $ABD3  20 1A
    BIT 1,E                   ; $ABD5  CB 4B
    JR NZ,$ABA7               ; $ABD7  20 CE
    BIT 0,E                   ; $ABD9  CB 43
    JR NZ,$ABBB               ; $ABDB  20 DE
    RES 2,E                   ; $ABDD  CB 93
    SET 0,E                   ; $ABDF  CB C3
    LD A,(IY+$00)             ; $ABE1  FD 7E 00
    LD (IY+$02),A             ; $ABE4  FD 77 02
    LD A,(IY+$01)             ; $ABE7  FD 7E 01
    LD (IY+$03),A             ; $ABEA  FD 77 03
    JR $ABAB                  ; $ABED  18 BC
    OR A                      ; $ABEF  B7
    BIT 1,E                   ; $ABF0  CB 4B
    RET                       ; $ABF2  C9

; Modo 2: confronta riferimenti con tabella 994D.
    CALL $AE7F                ; $ABF3  CD 7F AE
    CP $80                    ; $ABF6  FE 80
    CALL Z,$AE7F              ; $ABF8  CC 7F AE
    LD A,B                    ; $ABFB  78
    AND $0F                   ; $ABFC  E6 0F
    LD B,A                    ; $ABFE  47
    LD HL,$994D               ; $ABFF  21 4D 99
    LD A,(HL)                 ; $AC02  7E
    INC HL                    ; $AC03  23
    OR (HL)                   ; $AC04  B6
    JR Z,$AC14                ; $AC05  28 0D
    LD A,B                    ; $AC07  78
    CP (HL)                   ; $AC08  BE
    JR NZ,$AC11               ; $AC09  20 06
    DEC HL                    ; $AC0B  2B
    LD A,C                    ; $AC0C  79
    CP (HL)                   ; $AC0D  BE
    JR Z,$AC17                ; $AC0E  28 07
    INC HL                    ; $AC10  23
    INC HL                    ; $AC11  23
    JR $AC02                  ; $AC12  18 EE
    OR $01                    ; $AC14  F6 01
    RET                       ; $AC16  C9
    LD (IY+$00),C             ; $AC17  FD 71 00
    LD (IY+$01),B             ; $AC1A  FD 70 01
    RES 1,E                   ; $AC1D  CB 8B
    CALL $AE7F                ; $AC1F  CD 7F AE
    XOR A                     ; $AC22  AF
    RET                       ; $AC23  C9

; Gruppo nominale: scratch di 10 byte AAA8..AAB1.
    LD HL,$AAA8               ; $AC24  21 A8 AA
    LD B,$0A                  ; $AC27  06 0A
    CALL $A2AB                ; $AC29  CD AB A2
    LD A,E                    ; $AC2C  7B
    OR $34                    ; $AC2D  F6 34
    LD E,A                    ; $AC2F  5F
    CALL $AE7F                ; $AC30  CD 7F AE
    CP $80                    ; $AC33  FE 80
    JR NZ,$AC41               ; $AC35  20 0A

; Articolo classe80: massimo uno nel contesto corrente.
    BIT 4,E                   ; $AC37  CB 63
    JR Z,$AC3F                ; $AC39  28 04
    RES 4,E                   ; $AC3B  CB A3
    JR $AC30                  ; $AC3D  18 F1
    SCF                       ; $AC3F  37
    RET                       ; $AC40  C9
    CP $10                    ; $AC41  FE 10
    JR Z,$AC49                ; $AC43  28 04
    CP $70                    ; $AC45  FE 70
    JR NZ,$AC65               ; $AC47  20 1C

; Classi10/70: relazioni/preposizioni, NON nomi comuni.
    BIT 4,E                   ; $AC49  CB 63
    JR Z,$AC3F                ; $AC4B  28 F2
    BIT 2,E                   ; $AC4D  CB 53
    JR Z,$AC3F                ; $AC4F  28 EE
    LD A,($AAA7)              ; $AC51  3A A7 AA
    CP $03                    ; $AC54  FE 03
    JR NC,$AC3F               ; $AC56  30 E7
    INC A                     ; $AC58  3C
    LD ($AAA7),A              ; $AC59  32 A7 AA
    CALL $AC8F                ; $AC5C  CD 8F AC
    JR NZ,$AC3F               ; $AC5F  20 DE
    RES 5,E                   ; $AC61  CB AB
    JR $AC30                  ; $AC63  18 CB

; Classe60: fino a due qualificatori, prima del nome.
    CP $60                    ; $AC65  FE 60
    JR NZ,$AC78               ; $AC67  20 0F
    BIT 2,E                   ; $AC69  CB 53
    JR Z,$AC3F                ; $AC6B  28 D2
    RES 4,E                   ; $AC6D  CB A3
    RES 5,E                   ; $AC6F  CB AB
    CALL $AC94                ; $AC71  CD 94 AC
    JR NZ,$AC3F               ; $AC74  20 C9
    JR $AC30                  ; $AC76  18 B8

; Classe50 o literal F0: referente centrale del gruppo.
    CP $F0                    ; $AC78  FE F0
    JR Z,$AC80                ; $AC7A  28 04
    CP $50                    ; $AC7C  FE 50
    JR NZ,$AC8B               ; $AC7E  20 0B
    LD A,E                    ; $AC80  7B
    AND $CB                   ; $AC81  E6 CB
    LD E,A                    ; $AC83  5F
    LD ($AAAC),BC             ; $AC84  ED 43 AC AA
    CALL $AE7F                ; $AC88  CD 7F AE
    AND A                     ; $AC8B  A7
    BIT 5,E                   ; $AC8C  CB 6B
    RET                       ; $AC8E  C9

; Inserimento in due slot da 16 bit a AAA8.
    LD HL,$AAA8               ; $AC8F  21 A8 AA
    JR $AC97                  ; $AC92  18 03

; Inserimento in due slot da 16 bit a AAAE.
    LD HL,$AAAE               ; $AC94  21 AE AA
    LD A,(HL)                 ; $AC97  7E
    INC HL                    ; $AC98  23
    OR (HL)                   ; $AC99  B6
    JR Z,$ACA1                ; $AC9A  28 05
    INC HL                    ; $AC9C  23
    LD A,(HL)                 ; $AC9D  7E
    INC HL                    ; $AC9E  23
    OR (HL)                   ; $AC9F  B6
    RET NZ                    ; $ACA0  C0
    LD (HL),B                 ; $ACA1  70
    DEC HL                    ; $ACA2  2B
    LD (HL),C                 ; $ACA3  71
    XOR A                     ; $ACA4  AF
    RET                       ; $ACA5  C9

; Copia gruppo nominale nei campi +04 o +0E del nodo.
    BIT 6,E                   ; $ACA6  CB 73
    JR Z,$ACB2                ; $ACA8  28 08
    RES 6,E                   ; $ACAA  CB B3
    PUSH DE                   ; $ACAC  D5
    LD DE,$0004               ; $ACAD  11 04 00
    JR $ACBB                  ; $ACB0  18 09
    BIT 7,E                   ; $ACB2  CB 7B
    RET Z                     ; $ACB4  C8
    RES 7,E                   ; $ACB5  CB BB
    PUSH DE                   ; $ACB7  D5
    LD DE,$000E               ; $ACB8  11 0E 00
    PUSH IY                   ; $ACBB  FD E5
    POP HL                    ; $ACBD  E1
    ADD HL,DE                 ; $ACBE  19
    LD DE,$AAA8               ; $ACBF  11 A8 AA
    EX DE,HL                  ; $ACC2  EB
    LD BC,$000A               ; $ACC3  01 0A 00
    LDIR                      ; $ACC6  ED B0
    POP DE                    ; $ACC8  D1
    OR $01                    ; $ACC9  F6 01
    RET                       ; $ACCB  C9

; Separatore A0: coordinazione e salvataggio per backtracking.
    RES 3,E                   ; $ACCC  CB 9B
    PUSH DE                   ; $ACCE  D5
    CALL $AE7F                ; $ACCF  CD 7F AE
    CP $A0                    ; $ACD2  FE A0
    JR Z,$ACCF                ; $ACD4  28 F9
    LD HL,($A029)             ; $ACD6  2A 29 A0
    LD ($AAA1),HL             ; $ACD9  22 A1 AA
    LD ($A02B),HL             ; $ACDC  22 2B A0
    POP DE                    ; $ACDF  D1
    LD A,E                    ; $ACE0  7B
    LD ($AAA3),A              ; $ACE1  32 A3 AA
    LD ($AAA4),IY             ; $ACE4  FD 22 A4 AA
    LD A,($A012)              ; $ACE8  3A 12 A0
    LD ($AAA6),A              ; $ACEB  32 A6 AA
    LD A,($A01A)              ; $ACEE  3A 1A A0
    CP $02                    ; $ACF1  FE 02
    JR NZ,$AD57               ; $ACF3  20 62
    SET 6,(IY+$01)            ; $ACF5  FD CB 01 F6
    JR $AD57                  ; $ACF9  18 5C

; Nuovo verbo dopo coordinazione: puo rinviare il resto al ciclo seguente.
    LD A,($A024)              ; $ACFB  3A 24 A0
    CP $02                    ; $ACFE  FE 02
    JR NZ,$AD23               ; $AD00  20 21
    BIT 6,E                   ; $AD02  CB 73
    JP NZ,$AB4C               ; $AD04  C2 4C AB
    SET 6,E                   ; $AD07  CB F3
    SET 3,E                   ; $AD09  CB DB
    PUSH IY                   ; $AD0B  FD E5
    EXX                       ; $AD0D  D9
    POP HL                    ; $AD0E  E1
    LD DE,$0008               ; $AD0F  11 08 00
    ADD HL,DE                 ; $AD12  19
    PUSH HL                   ; $AD13  E5
    LD DE,$0010               ; $AD14  11 10 00
    ADD HL,DE                 ; $AD17  19
    POP DE                    ; $AD18  D1
    EX DE,HL                  ; $AD19  EB
    LD BC,$0006               ; $AD1A  01 06 00
    LDIR                      ; $AD1D  ED B0
    EXX                       ; $AD1F  D9
    JP $AB4C                  ; $AD20  C3 4C AB
    LD A,($A01B)              ; $AD23  3A 1B A0
    AND A                     ; $AD26  A7
    JR Z,$AD2E                ; $AD27  28 05
    SET 3,E                   ; $AD29  CB DB
    JP $AB4C                  ; $AD2B  C3 4C AB
    LD HL,($AAA1)             ; $AD2E  2A A1 AA
    LD ($A02B),HL             ; $AD31  22 2B A0
    LD D,$B0                  ; $AD34  16 B0
    LD A,($AAA3)              ; $AD36  3A A3 AA
    LD E,A                    ; $AD39  5F
    LD A,($AAA6)              ; $AD3A  3A A6 AA
    LD ($A012),A              ; $AD3D  32 12 A0
    LD IY,($AAA4)             ; $AD40  FD 2A A4 AA
    LD L,(IY-$02)             ; $AD44  FD 6E FE
    LD H,(IY-$01)             ; $AD47  FD 66 FF
    PUSH HL                   ; $AD4A  E5
    POP IX                    ; $AD4B  DD E1
    CALL $A1AF                ; $AD4D  CD AF A1
    XOR A                     ; $AD50  AF
    LD (IY-$02),A             ; $AD51  FD 77 FE
    LD (IY-$01),A             ; $AD54  FD 77 FF

; Fine unita sintattica / coordinazione.
    LD A,($A01A)              ; $AD57  3A 1A A0
    DEC A                     ; $AD5A  3D
    LD HL,$A012               ; $AD5B  21 12 A0
    DEC A                     ; $AD5E  3D
    LD A,D                    ; $AD5F  7A
    JR NZ,$AD66               ; $AD60  20 04
    CP $A0                    ; $AD62  FE A0
    JR Z,$AD67                ; $AD64  28 01
    INC (HL)                  ; $AD66  34
    CP $A0                    ; $AD67  FE A0
    JP Z,$AABD                ; $AD69  CA BD AA
    LD A,($A01B)              ; $AD6C  3A 1B A0
    AND A                     ; $AD6F  A7
    JR Z,$ADD4                ; $AD70  28 62
    LD IY,($9FF0)             ; $AD72  FD 2A F0 9F
    CALL $AEA9                ; $AD76  CD A9 AE
    LD A,(IY+$01)             ; $AD79  FD 7E 01
    AND $7F                   ; $AD7C  E6 7F
    OR (IY+$00)               ; $AD7E  FD B6 00
    JR NZ,$ADB8               ; $AD81  20 35
    LD A,($A01B)              ; $AD83  3A 1B A0
    LD E,A                    ; $AD86  5F
    LD D,$00                  ; $AD87  16 00
    LD HL,($9FF0)             ; $AD89  2A F0 9F
    LD A,(IY+$01)             ; $AD8C  FD 7E 01
    AND $80                   ; $AD8F  E6 80
    INC HL                    ; $AD91  23
    OR (HL)                   ; $AD92  B6
    LD (HL),A                 ; $AD93  77
    DEC HL                    ; $AD94  2B
    ADD HL,DE                 ; $AD95  19
    LD DE,$0008               ; $AD96  11 08 00
    ADD IY,DE                 ; $AD99  FD 19
    PUSH IY                   ; $AD9B  FD E5
    POP DE                    ; $AD9D  D1
    CALL $AE59                ; $AD9E  CD 59 AE
    CALL $AE59                ; $ADA1  CD 59 AE
    JR Z,$ADAF                ; $ADA4  28 09
    PUSH DE                   ; $ADA6  D5
    PUSH HL                   ; $ADA7  E5
    DEC DE                    ; $ADA8  1B
    DEC DE                    ; $ADA9  1B
    CALL $AE59                ; $ADAA  CD 59 AE
    POP HL                    ; $ADAD  E1
    POP DE                    ; $ADAE  D1
    CALL $AE59                ; $ADAF  CD 59 AE
    LD IY,($9FF0)             ; $ADB2  FD 2A F0 9F
    JR $ADBC                  ; $ADB6  18 04
    LD IY,$9FF2               ; $ADB8  FD 21 F2 9F
    LD L,(IY-$02)             ; $ADBC  FD 6E FE
    LD H,(IY-$01)             ; $ADBF  FD 66 FF
    PUSH HL                   ; $ADC2  E5
    POP IX                    ; $ADC3  DD E1
    LD L,(IX-$02)             ; $ADC5  DD 6E FE
    LD H,(IX-$01)             ; $ADC8  DD 66 FF
    LD (IY-$02),L             ; $ADCB  FD 75 FE
    LD (IY-$01),H             ; $ADCE  FD 74 FF
    CALL $A1C7                ; $ADD1  CD C7 A1

; Post-elaborazione lista, eredita campi tra gruppi coordinati.
    LD IY,$9FF2               ; $ADD4  FD 21 F2 9F
    LD A,($A012)              ; $ADD8  3A 12 A0
    LD B,A                    ; $ADDB  47
    PUSH BC                   ; $ADDC  C5
    CALL $AEB6                ; $ADDD  CD B6 AE
    LD A,B                    ; $ADE0  78
    AND A                     ; $ADE1  A7
    JR Z,$AE1E                ; $ADE2  28 3A
    CALL $AEB6                ; $ADE4  CD B6 AE
    LD A,($A024)              ; $ADE7  3A 24 A0
    CP $02                    ; $ADEA  FE 02
    JR NZ,$AE11               ; $ADEC  20 23
    PUSH IY                   ; $ADEE  FD E5
    POP HL                    ; $ADF0  E1
    LD DE,$0018               ; $ADF1  11 18 00
    ADD HL,DE                 ; $ADF4  19
    PUSH HL                   ; $ADF5  E5
    LD D,$06                  ; $ADF6  16 06
    XOR A                     ; $ADF8  AF
    OR (HL)                   ; $ADF9  B6
    INC HL                    ; $ADFA  23
    DEC D                     ; $ADFB  15
    JR NZ,$ADF9               ; $ADFC  20 FB
    POP HL                    ; $ADFE  E1
    AND A                     ; $ADFF  A7
    JR NZ,$AE11               ; $AE00  20 0F
    EX DE,HL                  ; $AE02  EB
    PUSH IX                   ; $AE03  DD E5
    POP HL                    ; $AE05  E1
    PUSH BC                   ; $AE06  C5
    LD BC,$0018               ; $AE07  01 18 00
    ADD HL,BC                 ; $AE0A  09
    LD BC,$0006               ; $AE0B  01 06 00
    LDIR                      ; $AE0E  ED B0
    POP BC                    ; $AE10  C1
    LD A,(IY+$01)             ; $AE11  FD 7E 01
    AND $7F                   ; $AE14  E6 7F
    OR (IY+$00)               ; $AE16  FD B6 00
    CALL Z,$AEF1              ; $AE19  CC F1 AE
    JR $ADE0                  ; $AE1C  18 C2
    POP BC                    ; $AE1E  C1
    CALL $AEEA                ; $AE1F  CD EA AE
    CALL $AEC5                ; $AE22  CD C5 AE
    LD A,B                    ; $AE25  78
    AND A                     ; $AE26  A7
    JP Z,$AE57                ; $AE27  CA 57 AE
    CALL $AEC5                ; $AE2A  CD C5 AE
    LD A,(IY+$12)             ; $AE2D  FD 7E 12
    OR (IY+$13)               ; $AE30  FD B6 13
    JR NZ,$AE25               ; $AE33  20 F0
    LD A,(IY+$00)             ; $AE35  FD 7E 00
    CP (IX+$00)               ; $AE38  DD BE 00
    JR NZ,$AE25               ; $AE3B  20 E8
    LD A,(IY+$01)             ; $AE3D  FD 7E 01
    CP (IX+$01)               ; $AE40  DD BE 01
    JR NZ,$AE25               ; $AE43  20 E0
    LD A,(IX+$0E)             ; $AE45  DD 7E 0E
    OR (IX+$0F)               ; $AE48  DD B6 0F
    JR Z,$AE25                ; $AE4B  28 D8
    EXX                       ; $AE4D  D9
    LD DE,$000E               ; $AE4E  11 0E 00
    CALL $AF27                ; $AE51  CD 27 AF
    JP $AE25                  ; $AE54  C3 25 AE

; Successo: A=0 e Z=1.
    XOR A                     ; $AE57  AF
    RET                       ; $AE58  C9
    LD A,(HL)                 ; $AE59  7E
    INC HL                    ; $AE5A  23
    OR (HL)                   ; $AE5B  B6
    DEC HL                    ; $AE5C  2B
    JR NZ,$AE61               ; $AE5D  20 02
    LD A,(DE)                 ; $AE5F  1A
    LD (HL),A                 ; $AE60  77
    INC HL                    ; $AE61  23
    INC DE                    ; $AE62  13
    JR NZ,$AE67               ; $AE63  20 02
    LD A,(DE)                 ; $AE65  1A
    LD (HL),A                 ; $AE66  77
    INC HL                    ; $AE67  23
    INC DE                    ; $AE68  13
    RET                       ; $AE69  C9

; Alloca nodo di 30 byte con A11C; link a IY-2.
    CALL $AEEA                ; $AE6A  CD EA AE
    LD A,$1E                  ; $AE6D  3E 1E
    CALL $A11C                ; $AE6F  CD 1C A1
    PUSH IX                   ; $AE72  DD E5
    POP HL                    ; $AE74  E1
    LD (IY-$02),L             ; $AE75  FD 75 FE
    LD (IY-$01),H             ; $AE78  FD 74 FF
    PUSH HL                   ; $AE7B  E5
    POP IY                    ; $AE7C  FD E1
    RET                       ; $AE7E  C9

; Legge token da A02B, salva inizio in A029; classe in A/D, valore BC.
    LD HL,($A02B)             ; $AE7F  2A 2B A0
    LD ($A029),HL             ; $AE82  22 29 A0
    LD A,D                    ; $AE85  7A
    LD ($A02D),A              ; $AE86  32 2D A0
    LD A,(HL)                 ; $AE89  7E
    LD D,A                    ; $AE8A  57
    LD BC,$0000               ; $AE8B  01 00 00
    INC HL                    ; $AE8E  23
    CP $E0                    ; $AE8F  FE E0
    JR Z,$AE9F                ; $AE91  28 0C
    CP $F0                    ; $AE93  FE F0
    JR Z,$AE9F                ; $AE95  28 08
    CP $90                    ; $AE97  FE 90
    JR Z,$AE9F                ; $AE99  28 04
    CP $80                    ; $AE9B  FE 80
    JR NC,$AEA4               ; $AE9D  30 05
    LD A,(HL)                 ; $AE9F  7E
    LD B,A                    ; $AEA0  47
    INC HL                    ; $AEA1  23
    LD C,(HL)                 ; $AEA2  4E
    INC HL                    ; $AEA3  23
    LD ($A02B),HL             ; $AEA4  22 2B A0
    LD A,D                    ; $AEA7  7A
    RET                       ; $AEA8  C9
    PUSH HL                   ; $AEA9  E5
    LD L,(IY-$02)             ; $AEAA  FD 6E FE
    LD H,(IY-$01)             ; $AEAD  FD 66 FF
    LD A,H                    ; $AEB0  7C
    OR L                      ; $AEB1  B5
    EX (SP),HL                ; $AEB2  E3
    POP IY                    ; $AEB3  FD E1
    RET                       ; $AEB5  C9
    DEC B                     ; $AEB6  05
    PUSH IY                   ; $AEB7  FD E5
    POP IX                    ; $AEB9  DD E1
    CALL $AEA9                ; $AEBB  CD A9 AE
    BIT 6,(IY+$01)            ; $AEBE  FD CB 01 76
    JR NZ,$AEB7               ; $AEC2  20 F3
    RET                       ; $AEC4  C9
    DEC B                     ; $AEC5  05
    PUSH IY                   ; $AEC6  FD E5
    POP IX                    ; $AEC8  DD E1
    PUSH HL                   ; $AECA  E5
    PUSH DE                   ; $AECB  D5
    PUSH IY                   ; $AECC  FD E5
    POP DE                    ; $AECE  D1
    LD IY,$9FF0               ; $AECF  FD 21 F0 9F
    CALL $A104                ; $AED3  CD 04 A1
    PUSH IY                   ; $AED6  FD E5
    POP HL                    ; $AED8  E1
    LD DE,$9FF2               ; $AED9  11 F2 9F
    AND A                     ; $AEDC  A7
    SBC HL,DE                 ; $AEDD  ED 52
    JR Z,$AEE7                ; $AEDF  28 06
    BIT 6,(IY+$01)            ; $AEE1  FD CB 01 76
    JR NZ,$AECC               ; $AEE5  20 E5
    POP DE                    ; $AEE7  D1
    POP HL                    ; $AEE8  E1
    RET                       ; $AEE9  C9
    LD IY,$0000               ; $AEEA  FD 21 00 00
    JP $AEC6                  ; $AEEE  C3 C6 AE
    EXX                       ; $AEF1  D9
    LD A,(IX+$01)             ; $AEF2  DD 7E 01
    AND $7F                   ; $AEF5  E6 7F
    OR (IY+$01)               ; $AEF7  FD B6 01
    LD (IY+$01),A             ; $AEFA  FD 77 01
    LD A,(IX+$00)             ; $AEFD  DD 7E 00
    LD (IY+$00),A             ; $AF00  FD 77 00
    EXX                       ; $AF03  D9
    LD A,(IX+$04)             ; $AF04  DD 7E 04
    OR (IX+$05)               ; $AF07  DD B6 05
    RET Z                     ; $AF0A  C8
    LD A,$0E                  ; $AF0B  3E 0E
    CALL $AF38                ; $AF0D  CD 38 AF
    RET NZ                    ; $AF10  C0
    EXX                       ; $AF11  D9
    PUSH IY                   ; $AF12  FD E5
    POP HL                    ; $AF14  E1
    LD DE,$0012               ; $AF15  11 12 00
    ADD HL,DE                 ; $AF18  19
    PUSH HL                   ; $AF19  E5
    LD DE,$FFF6               ; $AF1A  11 F6 FF
    ADD HL,DE                 ; $AF1D  19
    POP DE                    ; $AF1E  D1
    LD BC,$0006               ; $AF1F  01 06 00
    LDIR                      ; $AF22  ED B0
    LD DE,$0004               ; $AF24  11 04 00
    CALL $AF52                ; $AF27  CD 52 AF
    LD A,(IY+$02)             ; $AF2A  FD 7E 02
    OR (IY+$03)               ; $AF2D  FD B6 03
    LD DE,$0002               ; $AF30  11 02 00
    CALL Z,$AF56              ; $AF33  CC 56 AF
    EXX                       ; $AF36  D9
    RET                       ; $AF37  C9
    PUSH DE                   ; $AF38  D5
    PUSH BC                   ; $AF39  C5
    PUSH HL                   ; $AF3A  E5
    LD B,$0A                  ; $AF3B  06 0A
    PUSH IY                   ; $AF3D  FD E5
    POP HL                    ; $AF3F  E1
    LD E,A                    ; $AF40  5F
    LD D,$00                  ; $AF41  16 00
    ADD HL,DE                 ; $AF43  19
    XOR A                     ; $AF44  AF
    OR (HL)                   ; $AF45  B6
    INC HL                    ; $AF46  23
    DJNZ $AF45                ; $AF47  10 FC
    POP HL                    ; $AF49  E1
    POP BC                    ; $AF4A  C1
    POP DE                    ; $AF4B  D1
    AND A                     ; $AF4C  A7
    RET                       ; $AF4D  C9
    LD C,$06                  ; $AF4E  0E 06
    JR $AF58                  ; $AF50  18 06
    LD C,$0A                  ; $AF52  0E 0A
    JR $AF58                  ; $AF54  18 02
    LD C,$02                  ; $AF56  0E 02
    PUSH IY                   ; $AF58  FD E5
    POP HL                    ; $AF5A  E1
    ADD HL,DE                 ; $AF5B  19
    PUSH HL                   ; $AF5C  E5
    PUSH IX                   ; $AF5D  DD E5
    POP HL                    ; $AF5F  E1
    ADD HL,DE                 ; $AF60  19
    POP DE                    ; $AF61  D1
    LD B,$00                  ; $AF62  06 00
    LDIR                      ; $AF64  ED B0
    RET                       ; $AF66  C9

; Errore sintattico: A=1, NZ.
    LD A,$01                  ; $AF67  3E 01
    AND A                     ; $AF69  A7
    RET                       ; $AF6A  C9

    ORG $AF6B
; DATA $AF6B..$AFB2

; 12 coppie LE (riferimento parola, handler) per classe90, modo normale.
    DEFB $00,$00,$49,$B0,$40,$00,$33,$B0 ; $AF6B  00 00 49 B0 40 00 33 B0
    DEFB $5E,$01,$1C,$B0,$D5,$06,$FF,$AF ; $AF73  5E 01 1C B0 D5 06 FF AF
    DEFB $BD,$05,$0B,$B0,$07,$05,$A3,$B0 ; $AF7B  BD 05 0B B0 07 05 A3 B0
    DEFB $75,$07,$C6,$B0,$60,$06,$9A,$B0 ; $AF83  75 07 C6 B0 60 06 9A B0
    DEFB $E3,$03,$35,$B1,$88,$04,$51,$B1 ; $AF8B  E3 03 35 B1 88 04 51 B1
    DEFB $F6,$06,$A3,$B0,$B3,$08,$51,$B1 ; $AF93  F6 06 A3 B0 B3 08 51 B1

; 6 coppie per classe90 nel modo2; tabella, NON codice Z80.
    DEFB $99,$08,$FD,$B0,$E3,$03,$3F,$B1 ; $AF9B  99 08 FD B0 E3 03 3F B1
    DEFB $88,$04,$5B,$B1,$B3,$08,$5B,$B1 ; $AFA3  88 04 5B B1 B3 08 5B B1
    DEFB $C5,$00,$FA,$AF,$AE,$08,$FA,$AF ; $AFAB  C5 00 FA AF AE 08 FA AF

    ORG $AFB3
; CODE $AFB3..$B16C

; Dispatch classe90 per valore BC; offset0 indica virgoletta.
    LD HL,$AF6B               ; $AFB3  21 6B AF
    LD A,($A024)              ; $AFB6  3A 24 A0
    CP $02                    ; $AFB9  FE 02
    JR NZ,$AFC0               ; $AFBB  20 03
    LD HL,$AF9B               ; $AFBD  21 9B AF
    PUSH DE                   ; $AFC0  D5
    LD E,$0C                  ; $AFC1  1E 0C
    JR NZ,$AFC7               ; $AFC3  20 02
    LD E,$06                  ; $AFC5  1E 06
    LD A,(HL)                 ; $AFC7  7E
    INC HL                    ; $AFC8  23
    CP C                      ; $AFC9  B9
    JR NZ,$AFD0               ; $AFCA  20 04
    LD A,(HL)                 ; $AFCC  7E
    CP B                      ; $AFCD  B8
    JR Z,$AFDA                ; $AFCE  28 0A
    INC HL                    ; $AFD0  23
    INC HL                    ; $AFD1  23
    INC HL                    ; $AFD2  23
    DEC E                     ; $AFD3  1D
    JR NZ,$AFC7               ; $AFD4  20 F1
    POP DE                    ; $AFD6  D1
    JP $AF67                  ; $AFD7  C3 67 AF
    INC HL                    ; $AFDA  23
    LD E,(HL)                 ; $AFDB  5E
    INC HL                    ; $AFDC  23
    LD D,(HL)                 ; $AFDD  56
    EX DE,HL                  ; $AFDE  EB
    POP DE                    ; $AFDF  D1
    JP (HL)                   ; $AFE0  E9
    BIT 1,E                   ; $AFE1  CB 4B
    RET NZ                    ; $AFE3  C0
    POP HL                    ; $AFE4  E1
    JP $AF67                  ; $AFE5  C3 67 AF
    BIT 1,E                   ; $AFE8  CB 4B
    RET Z                     ; $AFEA  C8
    LD A,($A012)              ; $AFEB  3A 12 A0
    AND A                     ; $AFEE  A7
    JR NZ,$AFF6               ; $AFEF  20 05
    LD A,($A01B)              ; $AFF1  3A 1B A0
    AND A                     ; $AFF4  A7
    RET NZ                    ; $AFF5  C0
    POP HL                    ; $AFF6  E1
    JP $AF67                  ; $AFF7  C3 67 AF
    LD D,$A0                  ; $AFFA  16 A0
    JP $ACCC                  ; $AFFC  C3 CC AC
    CALL $AFE1                ; $AFFF  CD E1 AF
    CALL $C03B                ; $B002  CD 3B C0
    JR NZ,$B015               ; $B005  20 0E
    LD A,$01                  ; $B007  3E 01
    JR $B012                  ; $B009  18 07
    CALL $AFE1                ; $B00B  CD E1 AF
    CALL $A296                ; $B00E  CD 96 A2
    XOR A                     ; $B011  AF
    LD ($A008),A              ; $B012  32 08 A0
    LD A,($A02D)              ; $B015  3A 2D A0
    LD D,A                    ; $B018  57
    JP $AAC4                  ; $B019  C3 C4 AA
    LD A,($A01A)              ; $B01C  3A 1A A0
    CP $01                    ; $B01F  FE 01
    JP NZ,$AF67               ; $B021  C2 67 AF
    LD A,$02                  ; $B024  3E 02
    LD ($A01A),A              ; $B026  32 1A A0
    CALL $AE6A                ; $B029  CD 6A AE
    SET 6,(IY+$01)            ; $B02C  FD CB 01 F6
    JP $AB52                  ; $B030  C3 52 AB
    CALL $AFE8                ; $B033  CD E8 AF
    LD A,($A01A)              ; $B036  3A 1A A0
    AND A                     ; $B039  A7
    JP NZ,$AF67               ; $B03A  C2 67 AF
    LD A,$01                  ; $B03D  3E 01
    LD ($A01A),A              ; $B03F  32 1A A0
    SET 7,(IY+$01)            ; $B042  FD CB 01 FE
    JP $AB52                  ; $B046  C3 52 AB

; Virgolette: registra puntatore a contenuto; verbo implicito TALK (SAY e alias) se necessario.
    BIT 1,E                   ; $B049  CB 4B
    JR Z,$B058                ; $B04B  28 0B
    LD HL,$088B               ; $B04D  21 8B 08
    LD (IY+$00),L             ; $B050  FD 75 00
    LD (IY+$01),H             ; $B053  FD 74 01
    RES 1,E                   ; $B056  CB 8B
    PUSH HL                   ; $B058  E5
    PUSH DE                   ; $B059  D5
    PUSH IY                   ; $B05A  FD E5
    PUSH IX                   ; $B05C  DD E5
    LD IY,$9FEC               ; $B05E  FD 21 EC 9F
    LD DE,$0000               ; $B062  11 00 00
    CALL $A104                ; $B065  CD 04 A1
    LD A,$02                  ; $B068  3E 02
    CALL $A11C                ; $B06A  CD 1C A1
    LD HL,($A02B)             ; $B06D  2A 2B A0
    LD (IX+$00),L             ; $B070  DD 75 00
    LD (IX+$01),H             ; $B073  DD 74 01
    PUSH IX                   ; $B076  DD E5
    POP HL                    ; $B078  E1
    LD (IY-$02),L             ; $B079  FD 75 FE
    LD (IY-$01),H             ; $B07C  FD 74 FF
    POP IX                    ; $B07F  DD E1
    POP IY                    ; $B081  FD E1
    POP DE                    ; $B083  D1
    POP HL                    ; $B084  E1
    CALL $AE7F                ; $B085  CD 7F AE
    CP $90                    ; $B088  FE 90
    JR NZ,$B085               ; $B08A  20 F9
    LD A,B                    ; $B08C  78
    AND $0F                   ; $B08D  E6 0F
    OR C                      ; $B08F  B1
    JR NZ,$B085               ; $B090  20 F3

; La virgoletta finale nel token stream diventa C0 per analisi differita.
    LD HL,($A029)             ; $B092  2A 29 A0
    LD (HL),$C0               ; $B095  36 C0
    JP $AB52                  ; $B097  C3 52 AB
    CALL $AFE1                ; $B09A  CD E1 AF
    CALL $C415                ; $B09D  CD 15 C4
    JP $B015                  ; $B0A0  C3 15 B0
    CALL $AFE1                ; $B0A3  CD E1 AF
    CALL $B0AC                ; $B0A6  CD AC B0
    JP $B015                  ; $B0A9  C3 15 B0

; LOAD/QUIT: modifica stato di controllo; prove si fermano prima.
    LD HL,$0000               ; $B0AC  21 00 00
    LD ($9FDD),HL             ; $B0AF  22 DD 9F
    LD IX,$9860               ; $B0B2  DD 21 60 98
    LD (IX+$06),L             ; $B0B6  DD 75 06
    LD (IX+$07),H             ; $B0B9  DD 74 07
    INC HL                    ; $B0BC  23
    LD ($A01F),HL             ; $B0BD  22 1F A0
    LD A,L                    ; $B0C0  7D
    LD ($A0DA),A              ; $B0C1  32 DA A0
    AND A                     ; $B0C4  A7
    RET                       ; $B0C5  C9

; SAVE: modifica stato di controllo; prove si fermano prima.
    CALL $AFE1                ; $B0C6  CD E1 AF
    LD HL,$0001               ; $B0C9  21 01 00
    LD ($A01F),HL             ; $B0CC  22 1F A0
    LD A,$02                  ; $B0CF  3E 02
    LD ($A0DA),A              ; $B0D1  32 DA A0
    JP $B015                  ; $B0D4  C3 15 B0
    CALL $B0EE                ; $B0D7  CD EE B0
    CALL $C0DF                ; $B0DA  CD DF C0
    JR NC,$B0D7               ; $B0DD  30 F8
    LD IY,($9FD4)             ; $B0DF  FD 2A D4 9F
    RET                       ; $B0E3  C9
    LD ($9FD4),IY             ; $B0E4  FD 22 D4 9F
    CALL $B0EE                ; $B0E8  CD EE B0
    JP $C040                  ; $B0EB  C3 40 C0
    LD IX,$840B               ; $B0EE  DD 21 0B 84
    LD HL,$A01F               ; $B0F2  21 1F A0
    LD DE,$840B               ; $B0F5  11 0B 84
    AND A                     ; $B0F8  A7
    SBC HL,DE                 ; $B0F9  ED 52
    EX DE,HL                  ; $B0FB  EB
    RET                       ; $B0FC  C9
    LD BC,$0008               ; $B0FD  01 08 00
    BIT 3,E                   ; $B100  CB 5B
    JR NZ,$B107               ; $B102  20 03
    CALL $AEC6                ; $B104  CD C6 AE
    PUSH IY                   ; $B107  FD E5
    POP HL                    ; $B109  E1
    ADD HL,BC                 ; $B10A  09
    PUSH DE                   ; $B10B  D5
    PUSH HL                   ; $B10C  E5
    BIT 3,E                   ; $B10D  CB 5B
    JR NZ,$B118               ; $B10F  20 07
    SET 3,E                   ; $B111  CB DB
    CALL $AEA9                ; $B113  CD A9 AE
    JR $B11F                  ; $B116  18 07
    LD HL,$A012               ; $B118  21 12 A0
    INC (HL)                  ; $B11B  34
    CALL $AE6A                ; $B11C  CD 6A AE
    PUSH IY                   ; $B11F  FD E5
    POP HL                    ; $B121  E1
    LD BC,$0018               ; $B122  01 18 00
    ADD HL,BC                 ; $B125  09
    POP DE                    ; $B126  D1
    EX DE,HL                  ; $B127  EB
    LD BC,$0006               ; $B128  01 06 00
    LDIR                      ; $B12B  ED B0
    POP DE                    ; $B12D  D1
    LD A,E                    ; $B12E  7B
    OR $C7                    ; $B12F  F6 C7
    LD E,A                    ; $B131  5F
    JP $AAD1                  ; $B132  C3 D1 AA

; HE: attiva modo2 e flag nel campo +19.
    CALL $AFE1                ; $B135  CD E1 AF
    LD A,$02                  ; $B138  3E 02
    LD ($A024),A              ; $B13A  32 24 A0
    JR $B14B                  ; $B13D  18 0C
    BIT 3,E                   ; $B13F  CB 5B
    JR Z,$B14B                ; $B141  28 08
    PUSH DE                   ; $B143  D5
    CALL $AEA9                ; $B144  CD A9 AE
    CALL $AE6A                ; $B147  CD 6A AE
    POP DE                    ; $B14A  D1
    SET 7,(IY+$19)            ; $B14B  FD CB 19 FE
    JR $B12E                  ; $B14F  18 DD

; IT/THEY: attiva modo2 e flag nel campo +19.
    CALL $AFE1                ; $B151  CD E1 AF
    LD A,$02                  ; $B154  3E 02
    LD ($A024),A              ; $B156  32 24 A0
    JR $B167                  ; $B159  18 0C
    BIT 3,E                   ; $B15B  CB 5B
    JR Z,$B167                ; $B15D  28 08
    PUSH DE                   ; $B15F  D5
    CALL $AEA9                ; $B160  CD A9 AE
    CALL $AE6A                ; $B163  CD 6A AE
    POP DE                    ; $B166  D1
    SET 6,(IY+$19)            ; $B167  FD CB 19 F6
    JR $B12E                  ; $B16B  18 C1

    ORG $B191
; CODE $B191..$B1AA

; Ingresso fase successiva; mostrato solo il raccordo con errore verbo.
    LD A,$FF                  ; $B191  3E FF
    LD ($A035),A              ; $B193  32 35 A0
    LD ($A034),A              ; $B196  32 34 A0
    LD HL,$B16D               ; $B199  21 6D B1
    LD B,$11                  ; $B19C  06 11
    CALL $A2AB                ; $B19E  CD AB A2

; Ricerca forma verbale nel livello successivo, non lexer.
    CALL $B39D                ; $B1A1  CD 9D B3
    JR NZ,$B1AB               ; $B1A4  20 05

; Restituisce handler B84C se la ricerca fallisce.
    LD HL,$B84C               ; $B1A6  21 4C B8
    XOR A                     ; $B1A9  AF
    RET                       ; $B1AA  C9

    ORG $B84C
; CODE $B84C..$B862

; Prepara 4 argomenti e stampa I do not know the verb (686A).
    LD HL,($B18A)             ; $B84C  2A 8A B1
    PUSH HL                   ; $B84F  E5
    LD HL,($B188)             ; $B850  2A 88 B1
    PUSH HL                   ; $B853  E5
    LD HL,($B186)             ; $B854  2A 86 B1
    PUSH HL                   ; $B857  E5
    LD HL,($B18C)             ; $B858  2A 8C B1
    PUSH HL                   ; $B85B  E5
    LD HL,$686A               ; $B85C  21 6A 68
    CALL $A59F                ; $B85F  CD 9F A5
    RET                       ; $B862  C9

    ORG $C1E1
; CODE $C1E1..$C1F3

; Router di stampa: 5C3C abilita; A027 sceglie canale.
    PUSH AF                   ; $C1E1  F5
    LD A,($5C3C)              ; $C1E2  3A 3C 5C
    AND A                     ; $C1E5  A7
    JR NZ,$C1EA               ; $C1E6  20 02
    POP AF                    ; $C1E8  F1
    RET                       ; $C1E9  C9
    LD A,($A027)              ; $C1EA  3A 27 A0
    AND A                     ; $C1ED  A7
    JR NZ,$C1FC               ; $C1EE  20 0C
    POP AF                    ; $C1F0  F1
    JP $C2BA                  ; $C1F1  C3 BA C2

    ORG $C1F4
; DATA $C1F4..$C1FB

; Stato cursore del canale inferiore, NON codice.
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $C1F4  00 00 00 00 00 00 00 00

    ORG $C1FC
; CODE $C1FC..$C248
    POP AF                    ; $C1FC  F1

; Stampa nel canale inferiore; CR/backspace e conversione maiuscolo.
    PUSH HL                   ; $C1FD  E5
    PUSH BC                   ; $C1FE  C5
    PUSH AF                   ; $C1FF  F5
    LD A,($C1FB)              ; $C200  3A FB C1
    LD C,A                    ; $C203  4F
    POP AF                    ; $C204  F1
    PUSH AF                   ; $C205  F5
    LD HL,($C1F6)             ; $C206  2A F6 C1
    CP $0D                    ; $C209  FE 0D
    JR NZ,$C214               ; $C20B  20 07
    LD A,$20                  ; $C20D  3E 20
    CALL $C388                ; $C20F  CD 88 C3
    JR $C224                  ; $C212  18 10
    CP $08                    ; $C214  FE 08
    JR Z,$C249                ; $C216  28 31
    CALL $C240                ; $C218  CD 40 C2
    CALL $C388                ; $C21B  CD 88 C3
    LD A,($C1F4)              ; $C21E  3A F4 C1
    DEC A                     ; $C221  3D
    JR NZ,$C22D               ; $C222  20 09
    LD L,$E0                  ; $C224  2E E0
    LD C,$02                  ; $C226  0E 02
    CALL $C271                ; $C228  CD 71 C2
    LD A,$24                  ; $C22B  3E 24
    LD ($C1F4),A              ; $C22D  32 F4 C1
    LD A,C                    ; $C230  79
    LD ($C1FB),A              ; $C231  32 FB C1
    LD ($C1F6),HL             ; $C234  22 F6 C1
    LD A,$2B                  ; $C237  3E 2B
    CALL $C388                ; $C239  CD 88 C3
    POP AF                    ; $C23C  F1
    POP BC                    ; $C23D  C1
    POP HL                    ; $C23E  E1
    RET                       ; $C23F  C9

; Conversione ASCII a-z -> A-Z.
    CP $61                    ; $C240  FE 61
    RET C                     ; $C242  D8
    CP $7B                    ; $C243  FE 7B
    RET NC                    ; $C245  D0
    AND $5F                   ; $C246  E6 5F
    RET                       ; $C248  C9

    ORG $D6B8
; DATA $D6B8..$D6C0

; Stato e puntatori di controllo; D6BD = cursore token.
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $D6B8  00 00 00 00 00 00 00 00
    DEFB $00                  ; $D6C0  00

    ORG $D6C1
; CODE $D6C1..$D713

; Ingresso lettura comando.
    CALL $D898                ; $D6C1  CD 98 D8
    JP Z,$DC15                ; $D6C4  CA 15 DC
    XOR A                     ; $D6C7  AF
    LD ($D714),A              ; $D6C8  32 14 D7
    OR $01                    ; $D6CB  F6 01
    RET                       ; $D6CD  C9

; Preflight lessicale su intera riga: ripete D9C5 fino a C0/D0.
    LD HL,$5B00               ; $D6CE  21 00 5B
    CALL $D9C5                ; $D6D1  CD C5 D9
    CP $D0                    ; $D6D4  FE D0
    JP Z,$D6E0                ; $D6D6  CA E0 D6
    CP $C0                    ; $D6D9  FE C0
    JR NZ,$D6D1               ; $D6DB  20 F4
    OR $01                    ; $D6DD  F6 01
    RET                       ; $D6DF  C9

; Errore: HL=handler D6E5 e Z=1 per il chiamante/interprete.
    LD HL,$D6E5               ; $D6E0  21 E5 D6
    XOR A                     ; $D6E3  AF
    RET                       ; $D6E4  C9

; Errore lessicale nel canale inferiore: template 6859 + parola digitata.
    LD A,$01                  ; $D6E5  3E 01
    LD ($A027),A              ; $D6E7  32 27 A0
    LD HL,$6859               ; $D6EA  21 59 68
    CALL $A59F                ; $D6ED  CD 9F A5
    LD HL,($D6BD)             ; $D6F0  2A BD D6
    LD (HL),$C0               ; $D6F3  36 C0

; A029 punta alla prima parola non riconosciuta.
    LD HL,($A029)             ; $D6F5  2A 29 A0
    LD A,(HL)                 ; $D6F8  7E
    CP $2E                    ; $D6F9  FE 2E
    JR NZ,$D6FF               ; $D6FB  20 02
    LD A,$20                  ; $D6FD  3E 20
    CALL $A9B7                ; $D6FF  CD B7 A9
    INC HL                    ; $D702  23
    CP $20                    ; $D703  FE 20
    JR NZ,$D6F8               ; $D705  20 F1
    LD A,$22                  ; $D707  3E 22
    CALL $A9B7                ; $D709  CD B7 A9
    CALL $A2A2                ; $D70C  CD A2 A2
    XOR A                     ; $D70F  AF
    LD ($A027),A              ; $D710  32 27 A0
    RET                       ; $D713  C9

    ORG $D714
; DATA $D714..$D718

; Flag; seguono 4 byte record di script 40 00 CE D6.
    DEFB $00,$40,$00,$CE,$D6  ; $D714  00 40 00 CE D6

    ORG $D719
; CODE $D719..$D768

; Tokenizza nuovamente riga in 5B81, dopo il preflight.
    XOR A                     ; $D719  AF
    LD ($A019),A              ; $D71A  32 19 A0
    CALL $C142                ; $D71D  CD 42 C1
    LD A,($D714)              ; $D720  3A 14 D7
    AND A                     ; $D723  A7
    JR NZ,$D760               ; $D724  20 3A
    LD HL,$5B81               ; $D726  21 81 5B
    LD B,$60                  ; $D729  06 60
    CALL $A2AB                ; $D72B  CD AB A2
    LD HL,$5B00               ; $D72E  21 00 5B
    LD IY,$5B81               ; $D731  FD 21 81 5B
    LD (IY+$00),$C0           ; $D735  FD 36 00 C0
    CALL $D9C5                ; $D739  CD C5 D9
    LD (IY+$00),D             ; $D73C  FD 72 00
    INC IY                    ; $D73F  FD 23
    CP $E0                    ; $D741  FE E0
    JR Z,$D751                ; $D743  28 0C
    CP $F0                    ; $D745  FE F0
    JR Z,$D751                ; $D747  28 08
    CP $90                    ; $D749  FE 90
    JR Z,$D751                ; $D74B  28 04
    CP $80                    ; $D74D  FE 80
    JR NC,$D75B               ; $D74F  30 0A

; Valore BC serializzato big-endian; il nodo AST usa invece little-endian.
    LD (IY+$00),B             ; $D751  FD 70 00
    LD (IY+$01),C             ; $D754  FD 71 01
    INC IY                    ; $D757  FD 23
    INC IY                    ; $D759  FD 23
    LD A,D                    ; $D75B  7A
    CP $C0                    ; $D75C  FE C0
    JR NZ,$D735               ; $D75E  20 D5
    LD HL,$5B81               ; $D760  21 81 5B
    LD ($D6BD),HL             ; $D763  22 BD D6
    OR $01                    ; $D766  F6 01
    RET                       ; $D768  C9

    ORG $D769
; DATA $D769..$D76C

; Record di script 40 00 70 D7; NON LD B,B e altre false istruzioni.
    DEFB $40,$00,$70,$D7      ; $D769  40 00 70 D7

    ORG $D76D
; CODE $D76D..$D77D
    OR $01                    ; $D76D  F6 01
    RET                       ; $D76F  C9

; Verifica se ci sono token da analizzare.
    LD HL,($D6BD)             ; $D770  2A BD D6
    LD A,(HL)                 ; $D773  7E
    AND $F0                   ; $D774  E6 F0
    CP $C0                    ; $D776  FE C0
    JP Z,$DC15                ; $D778  CA 15 DC
    OR $01                    ; $D77B  F6 01
    RET                       ; $D77D  C9

    ORG $D77E
; DATA $D77E..$D77F

; Due byte di stato.
    DEFB $00,$00              ; $D77E  00 00

    ORG $D780
; CODE $D780..$D7D8

; Wrapper sintassi: modo1, cursore A02B, chiamata AAB2.
    XOR A                     ; $D780  AF
    LD ($9FEB),A              ; $D781  32 EB 9F
    INC A                     ; $D784  3C
    LD ($A024),A              ; $D785  32 24 A0
    LD HL,($D6BD)             ; $D788  2A BD D6
    LD ($A02B),HL             ; $D78B  22 2B A0
    CALL $AAB2                ; $D78E  CD B2 AA
    PUSH AF                   ; $D791  F5
    XOR A                     ; $D792  AF
    LD ($A01B),A              ; $D793  32 1B A0
    POP AF                    ; $D796  F1
    LD HL,($A02B)             ; $D797  2A 2B A0
    LD ($D6BD),HL             ; $D79A  22 BD D6
    JR NZ,$D7B2               ; $D79D  20 13

; Successo: passa lista da 9FF0 a 9FF2.
    LD HL,($9FF0)             ; $D79F  2A F0 9F
    LD ($9FF2),HL             ; $D7A2  22 F2 9F
    LD HL,$0000               ; $D7A5  21 00 00
    LD ($9FF0),HL             ; $D7A8  22 F0 9F
    XOR A                     ; $D7AB  AF
    LD ($D6B8),A              ; $D7AC  32 B8 D6
    OR $01                    ; $D7AF  F6 01
    RET                       ; $D7B1  C9

; Fallimento/caso speciale: libera liste temporanee.
    PUSH AF                   ; $D7B2  F5
    CALL $D87D                ; $D7B3  CD 7D D8
    CALL $D88A                ; $D7B6  CD 8A D8
    POP AF                    ; $D7B9  F1

; A=2 non produce What?; A=1 produce errore generico.
    CP $02                    ; $D7BA  FE 02
    JR Z,$D7D0                ; $D7BC  28 12

; A027=1, stampa 6866 What?, poi ripristina canale.
    LD A,$01                  ; $D7BE  3E 01
    LD ($A027),A              ; $D7C0  32 27 A0
    LD HL,$6866               ; $D7C3  21 66 68
    CALL $A59F                ; $D7C6  CD 9F A5
    XOR A                     ; $D7C9  AF
    LD ($A027),A              ; $D7CA  32 27 A0
    JP $DC15                  ; $D7CD  C3 15 DC
    LD HL,($A01F)             ; $D7D0  2A 1F A0
    LD A,H                    ; $D7D3  7C
    OR L                      ; $D7D4  B5
    RET NZ                    ; $D7D5  C0
    JP $DC15                  ; $D7D6  C3 15 DC

    ORG $D7D9
; DATA $D7D9..$D7DC

; Record di script 40 00 E1 D7; NON codice macchina.
    DEFB $40,$00,$E1,$D7      ; $D7D9  40 00 E1 D7

    ORG $D7DD
; CODE $D7DD..$D7DF
    OR $01                    ; $D7DD  F6 01
    RET                       ; $D7DF  C9

    ORG $D7E0
; DATA $D7E0..$D7E0

; Flag di stato.
    DEFB $00                  ; $D7E0  00

    ORG $D7E1
; CODE $D7E1..$D7F9
    LD A,($D7E0)              ; $D7E1  3A E0 D7
    AND A                     ; $D7E4  A7
    JR Z,$D7F1                ; $D7E5  28 0A
    XOR A                     ; $D7E7  AF
    LD ($D7E0),A              ; $D7E8  32 E0 D7
    CALL $D88A                ; $D7EB  CD 8A D8
    JP $DC15                  ; $D7EE  C3 15 DC
    LD HL,($9FF2)             ; $D7F1  2A F2 9F
    LD A,L                    ; $D7F4  7D
    OR H                      ; $D7F5  B4
    RET NZ                    ; $D7F6  C0
    JP $DC15                  ; $D7F7  C3 15 DC

    ORG $D7FA
; DATA $D7FA..$D7FB

; Due byte di stato.
    DEFB $00,$00              ; $D7FA  00 00

    ORG $D7FC
; CODE $D7FC..$D896

; Confine delle prove: prima di eseguire il livello semantico B191.
    XOR A                     ; $D7FC  AF
    LD A,($D6B8)              ; $D7FD  3A B8 D6
    LD ($A01C),A              ; $D800  32 1C A0
    LD IY,($9FF2)             ; $D803  FD 2A F2 9F
    LD HL,($D6BB)             ; $D807  2A BB D6
    LD ($B17E),HL             ; $D80A  22 7E B1
    CALL $B191                ; $D80D  CD 91 B1
    LD A,$01                  ; $D810  3E 01
    LD ($A00B),A              ; $D812  32 0B A0
    JP Z,$D85B                ; $D815  CA 5B D8
    LD A,($A01C)              ; $D818  3A 1C A0
    LD ($D6B8),A              ; $D81B  32 B8 D6
    LD A,$01                  ; $D81E  3E 01
    LD ($A026),A              ; $D820  32 26 A0
    LD A,($A033)              ; $D823  3A 33 A0
    LD ($9FD6),A              ; $D826  32 D6 9F
    LD HL,($A034)             ; $D829  2A 34 A0
    LD ($9FD7),HL             ; $D82C  22 D7 9F
    LD HL,($B17E)             ; $D82F  2A 7E B1
    LD ($D6BB),HL             ; $D832  22 BB D6
    LD A,($D6B8)              ; $D835  3A B8 D6
    AND A                     ; $D838  A7
    JR NZ,$D858               ; $D839  20 1D
    LD IX,($9FF2)             ; $D83B  DD 2A F2 9F
    LD L,(IX-$02)             ; $D83F  DD 6E FE
    LD H,(IX-$01)             ; $D842  DD 66 FF
    LD ($9FF2),HL             ; $D845  22 F2 9F
    CALL $A1C7                ; $D848  CD C7 A1
    LD A,L                    ; $D84B  7D
    OR H                      ; $D84C  B4
    JR Z,$D858                ; $D84D  28 09
    PUSH HL                   ; $D84F  E5
    POP IX                    ; $D850  DD E1
    BIT 6,(IX+$01)            ; $D852  DD CB 01 76
    JR NZ,$D83F               ; $D856  20 E7
    OR $01                    ; $D858  F6 01
    RET                       ; $D85A  C9
    XOR A                     ; $D85B  AF
    LD ($D6B8),A              ; $D85C  32 B8 D6
    LD A,($A01C)              ; $D85F  3A 1C A0
    AND A                     ; $D862  A7
    JR Z,$D870                ; $D863  28 0B
    LD A,$FF                  ; $D865  3E FF
    LD ($A033),A              ; $D867  32 33 A0
    CALL $D835                ; $D86A  CD 35 D8
    JP $DC15                  ; $D86D  C3 15 DC
    LD A,$01                  ; $D870  3E 01
    LD ($D7E0),A              ; $D872  32 E0 D7
    PUSH HL                   ; $D875  E5
    LD HL,($D6BD)             ; $D876  2A BD D6
    LD (HL),$C0               ; $D879  36 C0
    POP HL                    ; $D87B  E1
    RET                       ; $D87C  C9

; Libera lista a 9FF0.
    LD IX,($9FF0)             ; $D87D  DD 2A F0 9F
    LD HL,$0000               ; $D881  21 00 00
    LD ($9FF0),HL             ; $D884  22 F0 9F
    JP $A1AF                  ; $D887  C3 AF A1

; Libera lista a 9FF2.
    LD IX,($9FF2)             ; $D88A  DD 2A F2 9F
    LD HL,$0000               ; $D88E  21 00 00
    LD ($9FF2),HL             ; $D891  22 F2 9F
    JP $A1AF                  ; $D894  C3 AF A1

    ORG $D897
; DATA $D897..$D897

; Stato virgolette: 1 fuori, 0 dentro.
    DEFB $00                  ; $D897  00

    ORG $D898
; CODE $D898..$D9C2

; Editor: timeout e selezione canale inferiore.
    LD HL,$0BB8               ; $D898  21 B8 0B
    LD ($A03B),HL             ; $D89B  22 3B A0
    LD A,$01                  ; $D89E  3E 01
    LD ($A027),A              ; $D8A0  32 27 A0
    CALL $D8AD                ; $D8A3  CD AD D8
    PUSH AF                   ; $D8A6  F5
    XOR A                     ; $D8A7  AF
    LD ($A027),A              ; $D8A8  32 27 A0
    POP AF                    ; $D8AB  F1
    RET                       ; $D8AC  C9

; Stampa prompt > e spazio.
    LD A,$3E                  ; $D8AD  3E 3E
    CALL $A9B7                ; $D8AF  CD B7 A9
    LD A,$20                  ; $D8B2  3E 20
    CALL $A9B7                ; $D8B4  CD B7 A9

; Buffer testo 5B00, capacita nominale 80 esadecimale.
    LD HL,$5B00               ; $D8B7  21 00 5B
    LD B,$80                  ; $D8BA  06 80
    LD A,$01                  ; $D8BC  3E 01
    LD ($D897),A              ; $D8BE  32 97 D8
    LD C,$00                  ; $D8C1  0E 00

; Chiama lettura tasto A536.
    CALL $A536                ; $D8C3  CD 36 A5
    JP Z,$D9AC                ; $D8C6  CA AC D9
    BIT 7,B                   ; $D8C9  CB 78
    JR Z,$D8D2                ; $D8CB  28 05
    CP $40                    ; $D8CD  FE 40
    JP Z,$D99E                ; $D8CF  CA 9E D9
    BIT 0,C                   ; $D8D2  CB 41
    CALL Z,$D978              ; $D8D4  CC 78 D9
    LD C,$01                  ; $D8D7  0E 01
    CP $18                    ; $D8D9  FE 18
    JR NZ,$D8E2               ; $D8DB  20 05
    CALL $D9B7                ; $D8DD  CD B7 D9
    JR $D8BC                  ; $D8E0  18 DA
    CP $08                    ; $D8E2  FE 08
    JR NZ,$D900               ; $D8E4  20 1A
    BIT 7,B                   ; $D8E6  CB 78
    JR NZ,$D8C3               ; $D8E8  20 D9
    LD A,$08                  ; $D8EA  3E 08
    CALL $A9B7                ; $D8EC  CD B7 A9
    INC B                     ; $D8EF  04
    DEC HL                    ; $D8F0  2B
    LD A,(HL)                 ; $D8F1  7E
    CP $22                    ; $D8F2  FE 22
    JR NZ,$D8C3               ; $D8F4  20 CD
    LD A,($D897)              ; $D8F6  3A 97 D8
    XOR $01                   ; $D8F9  EE 01
    LD ($D897),A              ; $D8FB  32 97 D8
    JR $D8C3                  ; $D8FE  18 C3
    CP $40                    ; $D900  FE 40
    JR NC,$D93C               ; $D902  30 38
    CP $22                    ; $D904  FE 22
    JR NZ,$D917               ; $D906  20 0F
    LD A,($D897)              ; $D908  3A 97 D8
    XOR $01                   ; $D90B  EE 01
    LD ($D897),A              ; $D90D  32 97 D8
    CALL NZ,$D968             ; $D910  C4 68 D9
    LD A,$22                  ; $D913  3E 22
    JR $D93C                  ; $D915  18 25
    CP $20                    ; $D917  FE 20
    JR Z,$D93C                ; $D919  28 21
    CP $0D                    ; $D91B  FE 0D
    JR Z,$D949                ; $D91D  28 2A
    CP $2E                    ; $D91F  FE 2E
    JR Z,$D93C                ; $D921  28 19
    CP $2C                    ; $D923  FE 2C
    JR Z,$D93C                ; $D925  28 15
    CP $2F                    ; $D927  FE 2F
    JR Z,$D93C                ; $D929  28 11
    CP $60                    ; $D92B  FE 60
    JR Z,$D93C                ; $D92D  28 0D
    CP $2D                    ; $D92F  FE 2D
    JR Z,$D93C                ; $D931  28 09
    CP $3A                    ; $D933  FE 3A
    JR Z,$D93C                ; $D935  28 05
    CALL $DAE8                ; $D937  CD E8 DA
    JR C,$D8C3                ; $D93A  38 87
    DEC B                     ; $D93C  05
    INC B                     ; $D93D  04
    JR Z,$D946                ; $D93E  28 06
    LD (HL),A                 ; $D940  77
    CALL $A9B7                ; $D941  CD B7 A9
    INC HL                    ; $D944  23
    DEC B                     ; $D945  05
    JP $D8C3                  ; $D946  C3 C3 D8

; Invio: chiude virgolette aperte, aggiunge punto se manca e CR.
    LD A,($D897)              ; $D949  3A 97 D8
    AND A                     ; $D94C  A7
    CALL Z,$D95C              ; $D94D  CC 5C D9
    CALL $D968                ; $D950  CD 68 D9
    LD A,$0D                  ; $D953  3E 0D
    LD (HL),A                 ; $D955  77
    CALL $A9B7                ; $D956  CD B7 A9
    OR $01                    ; $D959  F6 01
    RET                       ; $D95B  C9

; Chiusura automatica citazione.
    CALL $D968                ; $D95C  CD 68 D9
    LD A,$22                  ; $D95F  3E 22
    LD (HL),A                 ; $D961  77
    CALL $A9B7                ; $D962  CD B7 A9
    INC HL                    ; $D965  23
    DEC B                     ; $D966  05
    RET                       ; $D967  C9

; Aggiunge punto solo se non presente.
    DEC HL                    ; $D968  2B
    LD A,(HL)                 ; $D969  7E
    CP $2E                    ; $D96A  FE 2E
    JR Z,$D976                ; $D96C  28 08
    INC HL                    ; $D96E  23
    DEC B                     ; $D96F  05
    LD A,$2E                  ; $D970  3E 2E
    LD (HL),A                 ; $D972  77
    CALL $A9B7                ; $D973  CD B7 A9
    INC HL                    ; $D976  23
    RET                       ; $D977  C9

; Tasti direzione all inizio: 09=E,08=W,0A=S,5B=N; poi Invio.
    CP $09                    ; $D978  FE 09
    JR Z,$D996                ; $D97A  28 1A
    CP $08                    ; $D97C  FE 08
    JR Z,$D99A                ; $D97E  28 1A
    CP $0A                    ; $D980  FE 0A
    JR Z,$D992                ; $D982  28 0E
    CP $5B                    ; $D984  FE 5B
    RET NZ                    ; $D986  C0
    LD A,$4E                  ; $D987  3E 4E
    LD (HL),A                 ; $D989  77
    INC HL                    ; $D98A  23
    CALL $A9B7                ; $D98B  CD B7 A9
    DEC B                     ; $D98E  05
    LD A,$0D                  ; $D98F  3E 0D
    RET                       ; $D991  C9
    LD A,$53                  ; $D992  3E 53
    JR $D989                  ; $D994  18 F3
    LD A,$45                  ; $D996  3E 45
    JR $D989                  ; $D998  18 EF
    LD A,$57                  ; $D99A  3E 57
    JR $D989                  ; $D99C  18 EB

; Gestione @ all inizio; ripetizione/stato da approfondire separatamente.
    LD A,($A01B)              ; $D99E  3A 1B A0
    AND A                     ; $D9A1  A7
    JP NZ,$D8C3               ; $D9A2  C2 C3 D8
    LD A,$01                  ; $D9A5  3E 01
    LD ($D714),A              ; $D9A7  32 14 D7
    OR $01                    ; $D9AA  F6 01
    PUSH AF                   ; $D9AC  F5
    LD A,$08                  ; $D9AD  3E 08
    CALL $A9B7                ; $D9AF  CD B7 A9
    CALL $A9B7                ; $D9B2  CD B7 A9
    POP AF                    ; $D9B5  F1
    RET                       ; $D9B6  C9

; Cancella riga con backspace.
    BIT 7,B                   ; $D9B7  CB 78
    RET NZ                    ; $D9B9  C0
    LD A,$08                  ; $D9BA  3E 08
    CALL $A9B7                ; $D9BC  CD B7 A9
    INC B                     ; $D9BF  04
    DEC HL                    ; $D9C0  2B
    JR $D9B7                  ; $D9C1  18 F4

    ORG $D9C3
; DATA $D9C3..$D9C4

; Puntatore al candidato lessicale.
    DEFB $00,$00              ; $D9C3  00 00

    ORG $D9C5
; CODE $D9C5..$DA31

; Lexer: salta spazi, riconosce CR/punteggiatura/numeri/parole.
    PUSH DE                   ; $D9C5  D5
    LD A,(HL)                 ; $D9C6  7E
    INC HL                    ; $D9C7  23
    CP $20                    ; $D9C8  FE 20
    JR Z,$D9C6                ; $D9CA  28 FA
    DEC HL                    ; $D9CC  2B
    LD ($A029),HL             ; $D9CD  22 29 A0
    CP $0D                    ; $D9D0  FE 0D
    JR Z,$DA06                ; $D9D2  28 32
    CALL $DAC6                ; $D9D4  CD C6 DA
    JR Z,$DA2F                ; $D9D7  28 56
    CALL $DA34                ; $D9D9  CD 34 DA
    JR Z,$DA0A                ; $D9DC  28 2C
    PUSH IX                   ; $D9DE  DD E5
    XOR A                     ; $D9E0  AF
    LD ($DC14),A              ; $D9E1  32 14 DC
    LD ($D9C3),DE             ; $D9E4  ED 53 C3 D9
    LD DE,($DA32)             ; $D9E8  ED 5B 32 DA
    AND A                     ; $D9EC  A7
    PUSH HL                   ; $D9ED  E5
    SBC HL,DE                 ; $D9EE  ED 52
    POP HL                    ; $D9F0  E1
    JR Z,$DA12                ; $D9F1  28 1F
    PUSH HL                   ; $D9F3  E5
    POP DE                    ; $D9F4  D1

; Decomprime candidato in 5C42.
    CALL $A94D                ; $D9F5  CD 4D A9

; Scarta record classe D0 anche se presenti nei testi del gioco.
    LD A,(DE)                 ; $D9F8  1A
    AND $F0                   ; $D9F9  E6 F0
    CP $D0                    ; $D9FB  FE D0
    JR Z,$D9E8                ; $D9FD  28 E9
    CALL $DA7D                ; $D9FF  CD 7D DA
    JR Z,$DA12                ; $DA02  28 0E
    JR $D9E4                  ; $DA04  18 DE
    LD A,$C0                  ; $DA06  3E C0
    JR $DA0C                  ; $DA08  18 02
    LD A,$D0                  ; $DA0A  3E D0
    LD BC,$0000               ; $DA0C  01 00 00
    POP DE                    ; $DA0F  D1
    LD D,A                    ; $DA10  57
    RET                       ; $DA11  C9

; Accetta se prefisso >=4 oppure coincide con intera lunghezza input.
    POP HL                    ; $DA12  E1
    LD A,($DC14)              ; $DA13  3A 14 DC
    CP $04                    ; $DA16  FE 04
    JR NC,$DA21               ; $DA18  30 07
    LD B,A                    ; $DA1A  47
    LD A,($DC13)              ; $DA1B  3A 13 DC
    CP B                      ; $DA1E  B8
    JR NZ,$DA0A               ; $DA1F  20 E9

; Restituisce classe del record canonico e offset rispetto a 5DBF.
    PUSH HL                   ; $DA21  E5
    LD HL,($D9C3)             ; $DA22  2A C3 D9
    LD A,(HL)                 ; $DA25  7E
    AND $F0                   ; $DA26  E6 F0
    LD BC,$5DBF               ; $DA28  01 BF 5D
    SBC HL,BC                 ; $DA2B  ED 42
    EX (SP),HL                ; $DA2D  E3
    POP BC                    ; $DA2E  C1
    POP DE                    ; $DA2F  D1
    LD D,A                    ; $DA30  57
    RET                       ; $DA31  C9

    ORG $DA32
; DATA $DA32..$DA33

; Fine del gruppo alfabetico corrente.
    DEFB $00,$00              ; $DA32  00 00

    ORG $DA34
; CODE $DA34..$DB63

; Indice iniziale a 5D80; ricostruzione input minuscolo a 5C0B.
    LD A,(HL)                 ; $DA34  7E
    INC HL                    ; $DA35  23
    AND $1F                   ; $DA36  E6 1F
    RLCA                      ; $DA38  07
    LD E,A                    ; $DA39  5F
    LD D,$00                  ; $DA3A  16 00
    PUSH HL                   ; $DA3C  E5
    POP IX                    ; $DA3D  DD E1
    LD HL,$5D80               ; $DA3F  21 80 5D
    ADD HL,DE                 ; $DA42  19
    LD E,(HL)                 ; $DA43  5E
    INC HL                    ; $DA44  23
    LD D,(HL)                 ; $DA45  56
    INC HL                    ; $DA46  23
    PUSH DE                   ; $DA47  D5
    LD E,(HL)                 ; $DA48  5E
    INC HL                    ; $DA49  23
    LD D,(HL)                 ; $DA4A  56
    INC HL                    ; $DA4B  23
    LD A,D                    ; $DA4C  7A
    OR E                      ; $DA4D  B3
    JR Z,$DA48                ; $DA4E  28 F8
    LD HL,$5DBF               ; $DA50  21 BF 5D
    ADD HL,DE                 ; $DA53  19
    LD ($DA32),HL             ; $DA54  22 32 DA
    POP DE                    ; $DA57  D1
    LD A,D                    ; $DA58  7A
    OR E                      ; $DA59  B3
    RET Z                     ; $DA5A  C8
    LD HL,$5DBF               ; $DA5B  21 BF 5D
    ADD HL,DE                 ; $DA5E  19
    LD DE,$5C0B               ; $DA5F  11 0B 5C
    LD B,$01                  ; $DA62  06 01
    LD A,(IX+$00)             ; $DA64  DD 7E 00
    CP $40                    ; $DA67  FE 40
    JR C,$DA74                ; $DA69  38 09
    OR $20                    ; $DA6B  F6 20
    LD (DE),A                 ; $DA6D  12
    INC DE                    ; $DA6E  13
    INC IX                    ; $DA6F  DD 23
    INC B                     ; $DA71  04
    JR $DA64                  ; $DA72  18 F0
    XOR A                     ; $DA74  AF
    LD (DE),A                 ; $DA75  12
    LD A,B                    ; $DA76  78
    LD ($DC13),A              ; $DA77  32 13 DC
    OR $01                    ; $DA7A  F6 01
    RET                       ; $DA7C  C9

; Confronto prefissi: aggiorna anche in parita; si ferma quando peggiora.
    PUSH HL                   ; $DA7D  E5
    PUSH DE                   ; $DA7E  D5
    LD A,($DC13)              ; $DA7F  3A 13 DC
    LD B,A                    ; $DA82  47
    LD A,($DC14)              ; $DA83  3A 14 DC
    CP B                      ; $DA86  B8
    JR NC,$DAA5               ; $DA87  30 1C
    LD B,$01                  ; $DA89  06 01
    LD DE,$5C0B               ; $DA8B  11 0B 5C
    LD HL,$5C42               ; $DA8E  21 42 5C
    LD A,(DE)                 ; $DA91  1A
    AND A                     ; $DA92  A7
    JR Z,$DA9D                ; $DA93  28 08
    CP (HL)                   ; $DA95  BE
    JR NZ,$DA9D               ; $DA96  20 05
    INC HL                    ; $DA98  23
    INC DE                    ; $DA99  13
    INC B                     ; $DA9A  04
    JR $DA91                  ; $DA9B  18 F4
    LD A,($DC14)              ; $DA9D  3A 14 DC
    CP B                      ; $DAA0  B8
    JR Z,$DAA9                ; $DAA1  28 06
    JR C,$DAA9                ; $DAA3  38 04
    POP DE                    ; $DAA5  D1
    POP HL                    ; $DAA6  E1
    XOR A                     ; $DAA7  AF
    RET                       ; $DAA8  C9
    LD A,B                    ; $DAA9  78
    LD ($DC14),A              ; $DAAA  32 14 DC

; Segue rimandi sinonimi finche descriptor bit7=0.
    POP HL                    ; $DAAD  E1
    PUSH HL                   ; $DAAE  E5
    INC HL                    ; $DAAF  23
    BIT 7,(HL)                ; $DAB0  CB 7E
    DEC HL                    ; $DAB2  2B
    JR Z,$DAC1                ; $DAB3  28 0C
    INC HL                    ; $DAB5  23
    INC HL                    ; $DAB6  23
    LD E,(HL)                 ; $DAB7  5E
    INC HL                    ; $DAB8  23
    LD D,(HL)                 ; $DAB9  56
    LD HL,$5DBF               ; $DABA  21 BF 5D
    ADD HL,DE                 ; $DABD  19
    EX (SP),HL                ; $DABE  E3
    JR $DAAD                  ; $DABF  18 EC
    POP DE                    ; $DAC1  D1
    POP HL                    ; $DAC2  E1
    OR $01                    ; $DAC3  F6 01
    RET                       ; $DAC5  C9

; Token speciali: punto B0, virgola A0, virgoletta90, numeri/F0.
    CP $60                    ; $DAC6  FE 60
    JP Z,$DB67                ; $DAC8  CA 67 DB
    CALL $DAE8                ; $DACB  CD E8 DA
    JP NC,$DAEF               ; $DACE  D2 EF DA
    LD B,$B0                  ; $DAD1  06 B0
    CP $2E                    ; $DAD3  FE 2E
    JR Z,$DAE2                ; $DAD5  28 0B
    LD B,$A0                  ; $DAD7  06 A0
    CP $2C                    ; $DAD9  FE 2C
    JR Z,$DAE2                ; $DADB  28 05
    CP $22                    ; $DADD  FE 22
    RET NZ                    ; $DADF  C0
    LD B,$90                  ; $DAE0  06 90
    INC HL                    ; $DAE2  23
    LD A,B                    ; $DAE3  78
    LD BC,$0000               ; $DAE4  01 00 00
    RET                       ; $DAE7  C9

; Test cifra ASCII.
    CP $30                    ; $DAE8  FE 30
    RET C                     ; $DAEA  D8
    CP $3A                    ; $DAEB  FE 3A
    CCF                       ; $DAED  3F
    RET                       ; $DAEE  C9

; Numero: riconosce orario o valuta.
    CALL $DBF7                ; $DAEF  CD F7 DB
    LD B,A                    ; $DAF2  47
    LD A,(HL)                 ; $DAF3  7E
    CP $3A                    ; $DAF4  FE 3A
    JR Z,$DB05                ; $DAF6  28 0D
    CP $41                    ; $DAF8  FE 41
    JR Z,$DB05                ; $DAFA  28 09
    CP $50                    ; $DAFC  FE 50
    JR Z,$DB05                ; $DAFE  28 05
    CALL $DB56                ; $DB00  CD 56 DB
    JR NZ,$DB84               ; $DB03  20 7F

; Ora/minuti: valori <60; flag AM/PM.
    LD A,B                    ; $DB05  78
    CP $3C                    ; $DB06  FE 3C
    JR NC,$DB4F               ; $DB08  30 45
    SET 7,B                   ; $DB0A  CB F8
    LD C,$00                  ; $DB0C  0E 00
    LD A,(HL)                 ; $DB0E  7E
    CALL $DB56                ; $DB0F  CD 56 DB
    JR Z,$DB60                ; $DB12  28 4C
    CP $3A                    ; $DB14  FE 3A
    JR NZ,$DB21               ; $DB16  20 09
    INC HL                    ; $DB18  23
    CALL $DBF7                ; $DB19  CD F7 DB
    LD C,A                    ; $DB1C  4F
    CP $3C                    ; $DB1D  FE 3C
    JR NC,$DB4F               ; $DB1F  30 2E
    LD A,(HL)                 ; $DB21  7E
    CALL $DB56                ; $DB22  CD 56 DB
    JR Z,$DB60                ; $DB25  28 39
    CP $41                    ; $DB27  FE 41
    JR NZ,$DB30               ; $DB29  20 05
    SET 6,B                   ; $DB2B  CB F0
    INC HL                    ; $DB2D  23
    JR $DB37                  ; $DB2E  18 07
    CP $50                    ; $DB30  FE 50
    JR NZ,$DB4F               ; $DB32  20 1B
    SET 6,C                   ; $DB34  CB F1
    INC HL                    ; $DB36  23
    LD A,(HL)                 ; $DB37  7E
    CP $4D                    ; $DB38  FE 4D
    JR NZ,$DB4F               ; $DB3A  20 13
    INC HL                    ; $DB3C  23
    LD A,(HL)                 ; $DB3D  7E
    CP $2E                    ; $DB3E  FE 2E
    JR Z,$DB3C                ; $DB40  28 FA
    CALL $DB59                ; $DB42  CD 59 DB
    JR Z,$DB60                ; $DB45  28 19
    CP $0D                    ; $DB47  FE 0D
    JR Z,$DB5F                ; $DB49  28 14
    CP $22                    ; $DB4B  FE 22
    JR Z,$DB5F                ; $DB4D  28 10

; Numero/formato invalido -> D0, stesso errore lessicale delle parole.
    XOR A                     ; $DB4F  AF
    LD A,$D0                  ; $DB50  3E D0
    LD BC,$0000               ; $DB52  01 00 00
    RET                       ; $DB55  C9
    CP $2E                    ; $DB56  FE 2E
    RET Z                     ; $DB58  C8
    CP $2C                    ; $DB59  FE 2C
    RET Z                     ; $DB5B  C8
    CP $20                    ; $DB5C  FE 20
    RET                       ; $DB5E  C9
    DEC HL                    ; $DB5F  2B

; Ritorna literal F0.
    XOR A                     ; $DB60  AF
    LD A,$F0                  ; $DB61  3E F0
    RET                       ; $DB63  C9

    ORG $DB64
; DATA $DB64..$DB66

; Tre byte temporanei: pounds/shillings/pence.
    DEFB $00,$00,$00          ; $DB64  00 00 00

    ORG $DB67
; CODE $DB67..$DC12

; Prefisso 60, simbolo sterlina nel set Spectrum (backtick in ASCII).
    INC HL                    ; $DB67  23
    CALL $DBF7                ; $DB68  CD F7 DB
    LD ($DB64),A              ; $DB6B  32 64 DB
    XOR A                     ; $DB6E  AF
    LD ($DB65),A              ; $DB6F  32 65 DB
    LD ($DB66),A              ; $DB72  32 66 DB
    INC HL                    ; $DB75  23
    LD A,(HL)                 ; $DB76  7E
    CALL $DAE8                ; $DB77  CD E8 DA
    DEC HL                    ; $DB7A  2B
    JR C,$DBC0                ; $DB7B  38 43
    INC HL                    ; $DB7D  23
    CALL $DBF7                ; $DB7E  CD F7 DB
    LD B,A                    ; $DB81  47
    JR $DB88                  ; $DB82  18 04
    XOR A                     ; $DB84  AF
    LD ($DB64),A              ; $DB85  32 64 DB
    XOR A                     ; $DB88  AF
    LD ($DB65),A              ; $DB89  32 65 DB
    LD ($DB66),A              ; $DB8C  32 66 DB
    LD A,(HL)                 ; $DB8F  7E
    CP $53                    ; $DB90  FE 53
    JR NZ,$DB9A               ; $DB92  20 06
    LD A,B                    ; $DB94  78
    LD ($DB65),A              ; $DB95  32 65 DB
    JR $DBBF                  ; $DB98  18 25
    CP $44                    ; $DB9A  FE 44
    JR NZ,$DBA4               ; $DB9C  20 06
    LD A,B                    ; $DB9E  78
    LD ($DB66),A              ; $DB9F  32 66 DB
    JR $DB98                  ; $DBA2  18 F4
    CP $2F                    ; $DBA4  FE 2F
    JR NZ,$DB4F               ; $DBA6  20 A7
    LD A,B                    ; $DBA8  78
    LD ($DB65),A              ; $DBA9  32 65 DB
    INC HL                    ; $DBAC  23
    LD A,(HL)                 ; $DBAD  7E
    CP $2D                    ; $DBAE  FE 2D
    JR Z,$DBBF                ; $DBB0  28 0D
    CALL $DAE8                ; $DBB2  CD E8 DA
    JR C,$DB4F                ; $DBB5  38 98
    CALL $DBF7                ; $DBB7  CD F7 DB
    LD ($DB66),A              ; $DBBA  32 66 DB
    JR $DBC0                  ; $DBBD  18 01
    INC HL                    ; $DBBF  23

; Converte valuta in pence: (pounds*20+shillings)*12+pence.
    PUSH HL                   ; $DBC0  E5
    LD A,($DB64)              ; $DBC1  3A 64 DB
    LD L,A                    ; $DBC4  6F
    LD H,$00                  ; $DBC5  26 00
    ADD HL,HL                 ; $DBC7  29
    ADD HL,HL                 ; $DBC8  29
    LD E,L                    ; $DBC9  5D
    LD D,H                    ; $DBCA  54
    ADD HL,HL                 ; $DBCB  29
    ADD HL,HL                 ; $DBCC  29
    ADD HL,DE                 ; $DBCD  19
    LD A,($DB65)              ; $DBCE  3A 65 DB
    LD E,A                    ; $DBD1  5F
    LD D,$00                  ; $DBD2  16 00
    ADD HL,DE                 ; $DBD4  19
    ADD HL,HL                 ; $DBD5  29
    ADD HL,HL                 ; $DBD6  29
    LD E,L                    ; $DBD7  5D
    LD D,H                    ; $DBD8  54
    ADD HL,HL                 ; $DBD9  29
    ADD HL,DE                 ; $DBDA  19
    LD A,($DB66)              ; $DBDB  3A 66 DB
    LD E,A                    ; $DBDE  5F
    LD D,$00                  ; $DBDF  16 00
    ADD HL,DE                 ; $DBE1  19
    EX (SP),HL                ; $DBE2  E3
    POP BC                    ; $DBE3  C1
    LD A,B                    ; $DBE4  78
    CP $40                    ; $DBE5  FE 40
    JP NC,$DB4F               ; $DBE7  D2 4F DB
    SLA C                     ; $DBEA  CB 21
    RL B                      ; $DBEC  CB 10
    SRL C                     ; $DBEE  CB 39
    SET 7,C                   ; $DBF0  CB F9
    SET 7,B                   ; $DBF2  CB F8
    JP $DB3D                  ; $DBF4  C3 3D DB

; Legge cifre nel registro B a 8 bit; non intero Python arbitrario.
    PUSH BC                   ; $DBF7  C5
    LD C,$00                  ; $DBF8  0E 00
    LD A,(HL)                 ; $DBFA  7E
    CALL $DAE8                ; $DBFB  CD E8 DA
    JR C,$DC10                ; $DBFE  38 10
    SUB $30                   ; $DC00  D6 30
    LD B,A                    ; $DC02  47
    RLC C                     ; $DC03  CB 01
    LD A,C                    ; $DC05  79
    RLC C                     ; $DC06  CB 01
    RLC C                     ; $DC08  CB 01
    ADD A,C                   ; $DC0A  81
    ADD A,B                   ; $DC0B  80
    LD C,A                    ; $DC0C  4F
    INC HL                    ; $DC0D  23
    JR $DBFA                  ; $DC0E  18 EA
    LD A,C                    ; $DC10  79
    POP BC                    ; $DC11  C1
    RET                       ; $DC12  C9

    ORG $DC13
; DATA $DC13..$DC14

; Lunghezza input e miglior prefisso: due byte di stato.
    DEFB $00,$00              ; $DC13  00 00

    ORG $DC15
; CODE $DC15..$DC17

; Ritorno falso comune: A=0, HL=0.
    XOR A                     ; $DC15  AF
    LD L,A                    ; $DC16  6F
    LD H,A                    ; $DC17  67
