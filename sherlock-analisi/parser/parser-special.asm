; Sherlock: citazioni, modi e continuazioni. Byte originali, commenti interpretativi.

    ORG $994D
; DATA $994D..$9964

; Tabella LE di 11 predicati del modo2, terminata da 0000; NON istruzioni.
    DEFB $FE,$00,$BA,$03      ; $994D FE 00 BA 03
    DEFB $D8,$03,$85,$04      ; $9951 D8 03 85 04
    DEFB $98,$04,$56,$09      ; $9955 98 04 56 09
    DEFB $DB,$03,$CD,$02      ; $9959 DB 03 CD 02
    DEFB $0A,$04,$32,$06      ; $995D 0A 04 32 06
    DEFB $38,$05,$00,$00      ; $9961 38 05 00 00

    ORG $AAB2
; CODE $AAB2..$AB10

; Ingresso comune; A024 e impostato dal chiamante (0,1,2).
    XOR A                     ; $AAB2 AF
    LD ($A01A),A              ; $AAB3 32 1A A0
    LD ($A012),A              ; $AAB6 32 12 A0
    LD E,$FF                  ; $AAB9 1E FF
    LD D,$C0                  ; $AABB 16 C0
    LD A,E                    ; $AABD 7B
    OR $C7                    ; $AABE F6 C7
    LD E,A                    ; $AAC0 5F
    CALL $AE6A                ; $AAC1 CD 6A AE
    LD A,($A01B)              ; $AAC4 3A 1B A0
    AND A                     ; $AAC7 A7
    JR Z,$AAD1                ; $AAC8 28 07
    LD A,$01                  ; $AACA 3E 01
    LD ($A024),A              ; $AACC 32 24 A0
    RES 3,E                   ; $AACF CB 9B

; Modo0: prova gruppo nominale come soggetto, altrimenti riparte in modo1.
    PUSH DE                   ; $AAD1 D5
    LD A,($A024)              ; $AAD2 3A 24 A0
    AND A                     ; $AAD5 A7
    JR NZ,$AB11               ; $AAD6 20 39
    LD ($AAA7),A              ; $AAD8 32 A7 AA
    LD HL,($A02B)             ; $AADB 2A 2B A0
    PUSH HL                   ; $AADE E5
    CALL $AC24                ; $AADF CD 24 AC
    JR NZ,$AB08               ; $AAE2 20 24
    LD A,($AAA7)              ; $AAE4 3A A7 AA
    AND A                     ; $AAE7 A7
    JR NZ,$AB08               ; $AAE8 20 1E

; Gruppo iniziale senza relazioni: modo2; copia 6 byte da AAAC al nodo+18.
    LD A,$02                  ; $AAEA 3E 02
    LD ($A024),A              ; $AAEC 32 24 A0
    POP HL                    ; $AAEF E1
    PUSH IY                   ; $AAF0 FD E5
    POP HL                    ; $AAF2 E1
    LD DE,$0018               ; $AAF3 11 18 00
    ADD HL,DE                 ; $AAF6 19
    LD DE,$AAAC               ; $AAF7 11 AC AA
    EX DE,HL                  ; $AAFA EB
    LD BC,$0006               ; $AAFB 01 06 00
    LDIR                      ; $AAFE ED B0
    LD HL,($A029)             ; $AB00 2A 29 A0
    LD ($A02B),HL             ; $AB03 22 2B A0
    JR $AB11                  ; $AB06 18 09

; Rifiuta ipotesi soggetto e riavvolge cursore per modo1.
    LD A,$01                  ; $AB08 3E 01
    LD ($A024),A              ; $AB0A 32 24 A0
    POP HL                    ; $AB0D E1
    LD ($A02B),HL             ; $AB0E 22 2B A0

    ORG $ABF3
; CODE $ABF3..$AC23

; Modo2: predicato deve figurare nella tabella 994D; non basta classe E0.
    CALL $AE7F                ; $ABF3 CD 7F AE
    CP $80                    ; $ABF6 FE 80
    CALL Z,$AE7F              ; $ABF8 CC 7F AE
    LD A,B                    ; $ABFB 78
    AND $0F                   ; $ABFC E6 0F
    LD B,A                    ; $ABFE 47
    LD HL,$994D               ; $ABFF 21 4D 99
    LD A,(HL)                 ; $AC02 7E
    INC HL                    ; $AC03 23
    OR (HL)                   ; $AC04 B6
    JR Z,$AC14                ; $AC05 28 0D
    LD A,B                    ; $AC07 78
    CP (HL)                   ; $AC08 BE
    JR NZ,$AC11               ; $AC09 20 06
    DEC HL                    ; $AC0B 2B
    LD A,C                    ; $AC0C 79
    CP (HL)                   ; $AC0D BE
    JR Z,$AC17                ; $AC0E 28 07
    INC HL                    ; $AC10 23
    INC HL                    ; $AC11 23
    JR $AC02                  ; $AC12 18 EE
    OR $01                    ; $AC14 F6 01
    RET                       ; $AC16 C9
    LD (IY+$00),C             ; $AC17 FD 71 00
    LD (IY+$01),B             ; $AC1A FD 70 01
    RES 1,E                   ; $AC1D CB 8B
    CALL $AE7F                ; $AC1F CD 7F AE
    XOR A                     ; $AC22 AF
    RET                       ; $AC23 C9

    ORG $AD6C
; CODE $AD6C..$ADD3

; Continuazione: A01B nonzero, nodo pendente a 9FF0.
    LD A,($A01B)              ; $AD6C 3A 1B A0
    AND A                     ; $AD6F A7
    JR Z,$ADD4                ; $AD70 28 62
    LD IY,($9FF0)             ; $AD72 FD 2A F0 9F
    CALL $AEA9                ; $AD76 CD A9 AE

; Se la nuova frase porta un verbo, non fondere: sostituire il comando.
    LD A,(IY+$01)             ; $AD79 FD 7E 01
    AND $7F                   ; $AD7C E6 7F
    OR (IY+$00)               ; $AD7E FD B6 00
    JR NZ,$ADB8               ; $AD81 20 35

; A01B=08/12 indica l inizio del referente+qualificatori nel vecchio nodo.
    LD A,($A01B)              ; $AD83 3A 1B A0
    LD E,A                    ; $AD86 5F
    LD D,$00                  ; $AD87 16 00
    LD HL,($9FF0)             ; $AD89 2A F0 9F
    LD A,(IY+$01)             ; $AD8C FD 7E 01
    AND $80                   ; $AD8F E6 80
    INC HL                    ; $AD91 23
    OR (HL)                   ; $AD92 B6
    LD (HL),A                 ; $AD93 77
    DEC HL                    ; $AD94 2B
    ADD HL,DE                 ; $AD95 19
    LD DE,$0008               ; $AD96 11 08 00
    ADD IY,DE                 ; $AD99 FD 19
    PUSH IY                   ; $AD9B FD E5
    POP DE                    ; $AD9D D1

; AE59 copia soltanto nelle word a zero; il referente esistente resta.
    CALL $AE59                ; $AD9E CD 59 AE
    CALL $AE59                ; $ADA1 CD 59 AE

; Se il primo qualificatore era occupato, prova il secondo slot.
    JR Z,$ADAF                ; $ADA4 28 09
    PUSH DE                   ; $ADA6 D5
    PUSH HL                   ; $ADA7 E5
    DEC DE                    ; $ADA8 1B
    DEC DE                    ; $ADA9 1B
    CALL $AE59                ; $ADAA CD 59 AE
    POP HL                    ; $ADAD E1
    POP DE                    ; $ADAE D1
    CALL $AE59                ; $ADAF CD 59 AE
    LD IY,($9FF0)             ; $ADB2 FD 2A F0 9F
    JR $ADBC                  ; $ADB6 18 04
    LD IY,$9FF2               ; $ADB8 FD 21 F2 9F

; Scollega/libera nodo transitorio (o vecchio nodo se nuovo verbo).
    LD L,(IY-$02)             ; $ADBC FD 6E FE
    LD H,(IY-$01)             ; $ADBF FD 66 FF
    PUSH HL                   ; $ADC2 E5
    POP IX                    ; $ADC3 DD E1
    LD L,(IX-$02)             ; $ADC5 DD 6E FE
    LD H,(IX-$01)             ; $ADC8 DD 66 FF
    LD (IY-$02),L             ; $ADCB FD 75 FE
    LD (IY-$01),H             ; $ADCE FD 74 FF
    CALL $A1C7                ; $ADD1 CD C7 A1

    ORG $AF6B
; DATA $AF6B..$AFB2

; Dispatch normale: 12 coppie (offset parola, handler).
    DEFB $00,$00,$49,$B0      ; $AF6B 00 00 49 B0
    DEFB $40,$00,$33,$B0      ; $AF6F 40 00 33 B0
    DEFB $5E,$01,$1C,$B0      ; $AF73 5E 01 1C B0
    DEFB $D5,$06,$FF,$AF      ; $AF77 D5 06 FF AF
    DEFB $BD,$05,$0B,$B0      ; $AF7B BD 05 0B B0
    DEFB $07,$05,$A3,$B0      ; $AF7F 07 05 A3 B0
    DEFB $75,$07,$C6,$B0      ; $AF83 75 07 C6 B0
    DEFB $60,$06,$9A,$B0      ; $AF87 60 06 9A B0
    DEFB $E3,$03,$35,$B1      ; $AF8B E3 03 35 B1
    DEFB $88,$04,$51,$B1      ; $AF8F 88 04 51 B1
    DEFB $F6,$06,$A3,$B0      ; $AF93 F6 06 A3 B0
    DEFB $B3,$08,$51,$B1      ; $AF97 B3 08 51 B1

; Dispatch modo2: 6 coppie (offset parola, handler).
    DEFB $99,$08,$FD,$B0      ; $AF9B 99 08 FD B0
    DEFB $E3,$03,$3F,$B1      ; $AF9F E3 03 3F B1
    DEFB $88,$04,$5B,$B1      ; $AFA3 88 04 5B B1
    DEFB $B3,$08,$5B,$B1      ; $AFA7 B3 08 5B B1
    DEFB $C5,$00,$FA,$AF      ; $AFAB C5 00 FA AF
    DEFB $AE,$08,$FA,$AF      ; $AFAF AE 08 FA AF

    ORG $AFB3
; CODE $AFB3..$B16C

; Selezione della tabella in funzione di A024.
    LD HL,$AF6B               ; $AFB3 21 6B AF
    LD A,($A024)              ; $AFB6 3A 24 A0
    CP $02                    ; $AFB9 FE 02
    JR NZ,$AFC0               ; $AFBB 20 03
    LD HL,$AF9B               ; $AFBD 21 9B AF
    PUSH DE                   ; $AFC0 D5
    LD E,$0C                  ; $AFC1 1E 0C
    JR NZ,$AFC7               ; $AFC3 20 02
    LD E,$06                  ; $AFC5 1E 06
    LD A,(HL)                 ; $AFC7 7E
    INC HL                    ; $AFC8 23
    CP C                      ; $AFC9 B9
    JR NZ,$AFD0               ; $AFCA 20 04
    LD A,(HL)                 ; $AFCC 7E
    CP B                      ; $AFCD B8
    JR Z,$AFDA                ; $AFCE 28 0A
    INC HL                    ; $AFD0 23
    INC HL                    ; $AFD1 23
    INC HL                    ; $AFD2 23
    DEC E                     ; $AFD3 1D
    JR NZ,$AFC7               ; $AFD4 20 F1
    POP DE                    ; $AFD6 D1
    JP $AF67                  ; $AFD7 C3 67 AF
    INC HL                    ; $AFDA 23
    LD E,(HL)                 ; $AFDB 5E
    INC HL                    ; $AFDC 23
    LD D,(HL)                 ; $AFDD 56
    EX DE,HL                  ; $AFDE EB
    POP DE                    ; $AFDF D1
    JP (HL)                   ; $AFE0 E9

; Guardia: handler ammesso solo prima di un verbo nel gruppo.
    BIT 1,E                   ; $AFE1 CB 4B
    RET NZ                    ; $AFE3 C0
    POP HL                    ; $AFE4 E1
    JP $AF67                  ; $AFE5 C3 67 AF

; ALL richiede verbo oppure contesto precedente/continuazione.
    BIT 1,E                   ; $AFE8 CB 4B
    RET Z                     ; $AFEA C8
    LD A,($A012)              ; $AFEB 3A 12 A0
    AND A                     ; $AFEE A7
    JR NZ,$AFF6               ; $AFEF 20 05
    LD A,($A01B)              ; $AFF1 3A 1B A0
    AND A                     ; $AFF4 A7
    RET NZ                    ; $AFF5 C0
    POP HL                    ; $AFF6 E1
    JP $AF67                  ; $AFF7 C3 67 AF

; BECAUSE/THEREFORE diventano coordinazione D=A0; nessun flag causale qui.
    LD D,$A0                  ; $AFFA 16 A0
    JP $ACCC                  ; $AFFC C3 CC AC
    CALL $AFE1                ; $AFFF CD E1 AF
    CALL $C03B                ; $B002 CD 3B C0
    JR NZ,$B015               ; $B005 20 0E
    LD A,$01                  ; $B007 3E 01
    JR $B012                  ; $B009 18 07
    CALL $AFE1                ; $B00B CD E1 AF
    CALL $A296                ; $B00E CD 96 A2
    XOR A                     ; $B011 AF
    LD ($A008),A              ; $B012 32 08 A0
    LD A,($A02D)              ; $B015 3A 2D A0
    LD D,A                    ; $B018 57
    JP $AAC4                  ; $B019 C3 C4 AA

; BUT/EXCEPT richiede ALL, alloca nodo esclusione e imposta bit6 del verbo.
    LD A,($A01A)              ; $B01C 3A 1A A0
    CP $01                    ; $B01F FE 01
    JP NZ,$AF67               ; $B021 C2 67 AF
    LD A,$02                  ; $B024 3E 02
    LD ($A01A),A              ; $B026 32 1A A0
    CALL $AE6A                ; $B029 CD 6A AE
    SET 6,(IY+$01)            ; $B02C FD CB 01 F6
    JP $AB52                  ; $B030 C3 52 AB

; ALL/EVERYTHING imposta bit7 del verbo e stato A01A=1.
    CALL $AFE8                ; $B033 CD E8 AF
    LD A,($A01A)              ; $B036 3A 1A A0
    AND A                     ; $B039 A7
    JP NZ,$AF67               ; $B03A C2 67 AF
    LD A,$01                  ; $B03D 3E 01
    LD ($A01A),A              ; $B03F 32 1A A0
    SET 7,(IY+$01)            ; $B042 FD CB 01 FE
    JP $AB52                  ; $B046 C3 52 AB

; Virgoletta: se manca verbo usa offset088B TALK (SAY e alias di TALK).
    BIT 1,E                   ; $B049 CB 4B
    JR Z,$B058                ; $B04B 28 0B
    LD HL,$088B               ; $B04D 21 8B 08
    LD (IY+$00),L             ; $B050 FD 75 00
    LD (IY+$01),H             ; $B053 FD 74 01
    RES 1,E                   ; $B056 CB 8B
    PUSH HL                   ; $B058 E5
    PUSH DE                   ; $B059 D5
    PUSH IY                   ; $B05A FD E5
    PUSH IX                   ; $B05C DD E5

; Coda dei puntatori alle citazioni: testa 9FEC.
    LD IY,$9FEC               ; $B05E FD 21 EC 9F
    LD DE,$0000               ; $B062 11 00 00
    CALL $A104                ; $B065 CD 04 A1
    LD A,$02                  ; $B068 3E 02
    CALL $A11C                ; $B06A CD 1C A1
    LD HL,($A02B)             ; $B06D 2A 2B A0
    LD (IX+$00),L             ; $B070 DD 75 00
    LD (IX+$01),H             ; $B073 DD 74 01
    PUSH IX                   ; $B076 DD E5
    POP HL                    ; $B078 E1
    LD (IY-$02),L             ; $B079 FD 75 FE
    LD (IY-$01),H             ; $B07C FD 74 FF
    POP IX                    ; $B07F DD E1
    POP IY                    ; $B081 FD E1
    POP DE                    ; $B083 D1
    POP HL                    ; $B084 E1

; Cerca virgoletta90 con valore0; non un generico token90.
    CALL $AE7F                ; $B085 CD 7F AE
    CP $90                    ; $B088 FE 90
    JR NZ,$B085               ; $B08A 20 F9
    LD A,B                    ; $B08C 78
    AND $0F                   ; $B08D E6 0F
    OR C                      ; $B08F B1
    JR NZ,$B085               ; $B090 20 F3

; Il delimitatore finale viene temporaneamente convertito in C0.
    LD HL,($A029)             ; $B092 2A 29 A0
    LD (HL),$C0               ; $B095 36 C0
    JP $AB52                  ; $B097 C3 52 AB

; PAUSE: prima guardia, poi lettura tasto. Nel tool attesa bypassata.
    CALL $AFE1                ; $B09A CD E1 AF
    CALL $C415                ; $B09D CD 15 C4
    JP $B015                  ; $B0A0 C3 15 B0
    CALL $AFE1                ; $B0A3 CD E1 AF
    CALL $B0AC                ; $B0A6 CD AC B0
    JP $B015                  ; $B0A9 C3 15 B0

; LOAD/QUIT modifica stato temporale; nessuna lettura nastro in questa routine.
    LD HL,$0000               ; $B0AC 21 00 00
    LD ($9FDD),HL             ; $B0AF 22 DD 9F
    LD IX,$9860               ; $B0B2 DD 21 60 98
    LD (IX+$06),L             ; $B0B6 DD 75 06
    LD (IX+$07),H             ; $B0B9 DD 74 07
    INC HL                    ; $B0BC 23
    LD ($A01F),HL             ; $B0BD 22 1F A0
    LD A,L                    ; $B0C0 7D
    LD ($A0DA),A              ; $B0C1 32 DA A0
    AND A                     ; $B0C4 A7
    RET                       ; $B0C5 C9

; SAVE: guardia sintattica prima di modificare flag di controllo.
    CALL $AFE1                ; $B0C6 CD E1 AF
    LD HL,$0001               ; $B0C9 21 01 00
    LD ($A01F),HL             ; $B0CC 22 1F A0
    LD A,$02                  ; $B0CF 3E 02
    LD ($A0DA),A              ; $B0D1 32 DA A0
    JP $B015                  ; $B0D4 C3 15 B0
    CALL $B0EE                ; $B0D7 CD EE B0
    CALL $C0DF                ; $B0DA CD DF C0
    JR NC,$B0D7               ; $B0DD 30 F8
    LD IY,($9FD4)             ; $B0DF FD 2A D4 9F
    RET                       ; $B0E3 C9
    LD ($9FD4),IY             ; $B0E4 FD 22 D4 9F
    CALL $B0EE                ; $B0E8 CD EE B0
    JP $C040                  ; $B0EB C3 40 C0
    LD IX,$840B               ; $B0EE DD 21 0B 84
    LD HL,$A01F               ; $B0F2 21 1F A0
    LD DE,$840B               ; $B0F5 11 0B 84
    AND A                     ; $B0F8 A7
    SBC HL,DE                 ; $B0F9 ED 52
    EX DE,HL                  ; $B0FB EB
    RET                       ; $B0FC C9

; THAT: copia 6 byte da gruppo nominale precedente a soggetto+18.
    LD BC,$0008               ; $B0FD 01 08 00
    BIT 3,E                   ; $B100 CB 5B
    JR NZ,$B107               ; $B102 20 03
    CALL $AEC6                ; $B104 CD C6 AE
    PUSH IY                   ; $B107 FD E5
    POP HL                    ; $B109 E1
    ADD HL,BC                 ; $B10A 09
    PUSH DE                   ; $B10B D5
    PUSH HL                   ; $B10C E5
    BIT 3,E                   ; $B10D CB 5B
    JR NZ,$B118               ; $B10F 20 07
    SET 3,E                   ; $B111 CB DB
    CALL $AEA9                ; $B113 CD A9 AE
    JR $B11F                  ; $B116 18 07
    LD HL,$A012               ; $B118 21 12 A0
    INC (HL)                  ; $B11B 34
    CALL $AE6A                ; $B11C CD 6A AE
    PUSH IY                   ; $B11F FD E5
    POP HL                    ; $B121 E1
    LD BC,$0018               ; $B122 01 18 00
    ADD HL,BC                 ; $B125 09
    POP DE                    ; $B126 D1
    EX DE,HL                  ; $B127 EB
    LD BC,$0006               ; $B128 01 06 00
    LDIR                      ; $B12B ED B0
    POP DE                    ; $B12D D1
    LD A,E                    ; $B12E 7B
    OR $C7                    ; $B12F F6 C7
    LD E,A                    ; $B131 5F
    JP $AAD1                  ; $B132 C3 D1 AA

; HE: A024=2, flag80 nel byte soggetto+19.
    CALL $AFE1                ; $B135 CD E1 AF
    LD A,$02                  ; $B138 3E 02
    LD ($A024),A              ; $B13A 32 24 A0
    JR $B14B                  ; $B13D 18 0C
    BIT 3,E                   ; $B13F CB 5B
    JR Z,$B14B                ; $B141 28 08
    PUSH DE                   ; $B143 D5
    CALL $AEA9                ; $B144 CD A9 AE
    CALL $AE6A                ; $B147 CD 6A AE
    POP DE                    ; $B14A D1
    SET 7,(IY+$19)            ; $B14B FD CB 19 FE
    JR $B12E                  ; $B14F 18 DD

; IT e THEY: medesimo handler, flag40 in soggetto+19.
    CALL $AFE1                ; $B151 CD E1 AF
    LD A,$02                  ; $B154 3E 02
    LD ($A024),A              ; $B156 32 24 A0
    JR $B167                  ; $B159 18 0C
    BIT 3,E                   ; $B15B CB 5B
    JR Z,$B167                ; $B15D 28 08
    PUSH DE                   ; $B15F D5
    CALL $AEA9                ; $B160 CD A9 AE
    CALL $AE6A                ; $B163 CD 6A AE
    POP DE                    ; $B166 D1
    SET 6,(IY+$19)            ; $B167 FD CB 19 F6
    JR $B12E                  ; $B16B 18 C1

    ORG $B447
; CODE $B447..$B467

; B182/B183 ricevono offset08/12 secondo il ruolo dei due argomenti.
    BIT 5,A                   ; $B447 CB 6F
    LD BC,$1208               ; $B449 01 08 12
    JR Z,$B451                ; $B44C 28 03
    LD BC,$0812               ; $B44E 01 12 08
    LD HL,$B182               ; $B451 21 82 B1
    LD (HL),B                 ; $B454 70
    INC HL                    ; $B455 23
    LD (HL),C                 ; $B456 71
    LD A,B                    ; $B457 78
    LD DE,$B172               ; $B458 11 72 B1
    LD HL,$B16D               ; $B45B 21 6D B1
    CALL $B468                ; $B45E CD 68 B4
    LD A,C                    ; $B461 79
    LD DE,$B178               ; $B462 11 78 B1
    LD HL,$B16E               ; $B465 21 6E B1

    ORG $B5B6
; CODE $B5B6..$B5D2

; Preparazione domanda: A01B=A; sposta primo nodo da9FF2 a9FF0; tronca link.
    LD ($A01B),A              ; $B5B6 32 1B A0
    LD IX,($9FF2)             ; $B5B9 DD 2A F2 9F
    LD ($9FF0),IX             ; $B5BD DD 22 F0 9F
    LD L,(IX-$02)             ; $B5C1 DD 6E FE
    LD H,(IX-$01)             ; $B5C4 DD 66 FF
    LD ($9FF2),HL             ; $B5C7 22 F2 9F
    LD (IX-$02),$00           ; $B5CA DD 36 FE 00
    LD (IX-$01),$00           ; $B5CE DD 36 FF 00
    RET                       ; $B5D2 C9

    ORG $B86A
; CODE $B86A..$B933

; Consumatore reale della coda9FEC; A nonzero richiede analisi del contenuto.
    PUSH AF                   ; $B86A F5
    LD IX,$9FEE               ; $B86B DD 21 EE 9F
    CALL $A0F7                ; $B86F CD F7 A0
    JR Z,$B8A8                ; $B872 28 34
    LD C,(IX+$00)             ; $B874 DD 4E 00
    LD B,(IX+$01)             ; $B877 DD 46 01
    LD ($B868),BC             ; $B87A ED 43 68 B8
    LD L,(IX-$02)             ; $B87E DD 6E FE
    LD H,(IX-$01)             ; $B881 DD 66 FF
    LD ($9FEC),HL             ; $B884 22 EC 9F
    CALL $A1C7                ; $B887 CD C7 A1
    POP AF                    ; $B88A F1
    PUSH AF                   ; $B88B F5
    AND A                     ; $B88C A7
    JR Z,$B894                ; $B88D 28 05

; Solo con A!=0 chiama B8AA; con A=0 scarta citazione senza analizzarla.
    CALL $B8AA                ; $B88F CD AA B8
    JR Z,$B8A8                ; $B892 28 14

; Ripristina il delimitatore da C0 a90 nel caso di scarto/fallimento.
    LD BC,($B868)             ; $B894 ED 4B 68 B8
    LD ($A02B),BC             ; $B898 ED 43 2B A0
    CALL $AE7F                ; $B89C CD 7F AE
    CP $C0                    ; $B89F FE C0
    JR NZ,$B89C               ; $B8A1 20 F9
    LD HL,($A029)             ; $B8A3 2A 29 A0
    LD (HL),$90               ; $B8A6 36 90
    POP AF                    ; $B8A8 F1
    RET                       ; $B8A9 C9

; Secondo ingresso: B868=inizio token citazione, A024=0 (autodetect).
    LD HL,($B868)             ; $B8AA 2A 68 B8
    LD ($A02B),HL             ; $B8AD 22 2B A0
    XOR A                     ; $B8B0 AF
    LD ($A024),A              ; $B8B1 32 24 A0

; Salva lista esterna9FF0, analizza citazione in lista separata.
    LD HL,($9FF0)             ; $B8B4 2A F0 9F
    PUSH HL                   ; $B8B7 E5
    LD HL,$0000               ; $B8B8 21 00 00
    LD ($9FF0),HL             ; $B8BB 22 F0 9F

; Ripete AAB2 per tutte le unita fino aC0; A024 non azzerato tra unita.
    CALL $AAB2                ; $B8BE CD B2 AA
    JR Z,$B8C7                ; $B8C1 28 04
    CP $02                    ; $B8C3 FE 02
    JR NZ,$B904               ; $B8C5 20 3D
    LD HL,($A02B)             ; $B8C7 2A 2B A0
    LD A,(HL)                 ; $B8CA 7E
    AND $F0                   ; $B8CB E6 F0
    CP $C0                    ; $B8CD FE C0
    JR NZ,$B8BE               ; $B8CF 20 ED

; Successo: ripristina90, alloca record di 8 byte in lista9FEE.
    LD (HL),$90               ; $B8D1 36 90
    LD A,$08                  ; $B8D3 3E 08
    CALL $A11C                ; $B8D5 CD 1C A1
    LD HL,($9FEE)             ; $B8D8 2A EE 9F
    LD ($9FEE),IX             ; $B8DB DD 22 EE 9F
    LD (IX-$02),L             ; $B8DF DD 75 FE
    LD (IX-$01),H             ; $B8E2 DD 74 FF

; Record citazione +05/+06 = testa della lista sintattica.
    LD HL,($9FF0)             ; $B8E5 2A F0 9F
    LD (IX+$05),L             ; $B8E8 DD 75 05
    LD (IX+$06),H             ; $B8EB DD 74 06
    POP HL                    ; $B8EE E1
    LD ($9FF0),HL             ; $B8EF 22 F0 9F
    XOR A                     ; $B8F2 AF
    LD (IX+$01),A             ; $B8F3 DD 77 01

; Record +00 = A034 (identita proveniente dal livello precedente).
    LD A,($A034)              ; $B8F6 3A 34 A0
    LD (IX+$00),A             ; $B8F9 DD 77 00

; Record +07 = modo finale1/2 della citazione.
    LD A,($A024)              ; $B8FC 3A 24 A0
    LD (IX+$07),A             ; $B8FF DD 77 07
    XOR A                     ; $B902 AF
    RET                       ; $B903 C9

; Errore: libera nuova lista e ripristina lista esterna.
    PUSH AF                   ; $B904 F5
    CALL $D87D                ; $B905 CD 7D D8
    POP AF                    ; $B908 F1
    POP HL                    ; $B909 E1
    LD ($9FF0),HL             ; $B90A 22 F0 9F
    RET                       ; $B90D C9

; Recupera lista della citazione associata a un referente.
    CALL $B91F                ; $B90E CD 1F B9
    LD ($B866),IX             ; $B911 DD 22 66 B8
    LD E,(IX+$05)             ; $B915 DD 5E 05
    LD D,(IX+$06)             ; $B918 DD 56 06
    PUSH DE                   ; $B91B D5
    POP IY                    ; $B91C FD E1
    RET                       ; $B91E C9
    LD IX,$9FF0               ; $B91F DD 21 F0 9F
    CALL $A0F7                ; $B923 CD F7 A0
    JR Z,$B931                ; $B926 28 09
    LD A,($A036)              ; $B928 3A 36 A0
    CP (IX+$00)               ; $B92B DD BE 00
    RET Z                     ; $B92E C8
    JR $B923                  ; $B92F 18 F2
    OR $01                    ; $B931 F6 01
    RET                       ; $B933 C9

    ORG $BA20
; CODE $BA20..$BA5F

; Raccordo del modo2 con interprete affermazioni; non implementato nel tool.
    LD A,($A036)              ; $BA20 3A 36 A0
    LD HL,$BA67               ; $BA23 21 67 BA
    CP $03                    ; $BA26 FE 03
    JR Z,$BA31                ; $BA28 28 07
    LD HL,$BB67               ; $BA2A 21 67 BB
    CP $02                    ; $BA2D FE 02
    JR NZ,$BA34               ; $BA2F 20 03
    CALL $BA3E                ; $BA31 CD 3E BA
    LD A,$01                  ; $BA34 3E 01
    POP HL                    ; $BA36 E1
    POP IY                    ; $BA37 FD E1
    POP IX                    ; $BA39 DD E1
    AND A                     ; $BA3B A7
    SCF                       ; $BA3C 37
    RET                       ; $BA3D C9
    PUSH IX                   ; $BA3E DD E5
    XOR A                     ; $BA40 AF
    LD ($9FEB),A              ; $BA41 32 EB 9F
    LD E,(IX+$05)             ; $BA44 DD 5E 05
    LD D,(IX+$06)             ; $BA47 DD 56 06
    PUSH DE                   ; $BA4A D5
    PUSH DE                   ; $BA4B D5
    POP IY                    ; $BA4C FD E1

; D1DB elabora affermazioni: fase successiva alla sola sintassi.
    CALL $D1DB                ; $BA4E CD DB D1
    POP IX                    ; $BA51 DD E1
    PUSH AF                   ; $BA53 F5
    CALL $A1AF                ; $BA54 CD AF A1
    POP AF                    ; $BA57 F1
    POP IX                    ; $BA58 DD E1
    PUSH AF                   ; $BA5A F5
    CALL $B9FA                ; $BA5B CD FA B9
    POP AF                    ; $BA5E F1
    RET                       ; $BA5F C9

    ORG $D99E
; CODE $D99E..$D9AB

; @ riusa il buffer soltanto se A01B=0; durante continuazione torna alla lettura.
    LD A,($A01B)              ; $D99E 3A 1B A0
    AND A                     ; $D9A1 A7
    JP NZ,$D8C3               ; $D9A2 C2 C3 D8
    LD A,$01                  ; $D9A5 3E 01
    LD ($D714),A              ; $D9A7 32 14 D7
    OR $01                    ; $D9AA F6 01

    ORG $DDA0
; CODE $DDA0..$DDB3

; Raccordo del gioco: controlla referente e passa A=0/1 aB86A.
    LD A,($A034)              ; $DDA0 3A 34 A0
    CALL $CC0E                ; $DDA3 CD 0E CC
    CP $FF                    ; $DDA6 FE FF
    LD A,$00                  ; $DDA8 3E 00
    JR Z,$DDAE                ; $DDAA 28 02
    LD A,$01                  ; $DDAC 3E 01
    CALL $B86A                ; $DDAE CD 6A B8
    OR $01                    ; $DDB1 F6 01
    RET                       ; $DDB3 C9
