; Offline source evidence. DOMAIN headers and operations are DATA.

    ORG $9921
; DATA: Immutable player DOMAIN programme
    DEFB $01,$22,$13,$BF,$D6,$48,$99,$13  ; $9921 01 22 13 bf d6 48 99 13
    DEFB $15,$D7,$23,$99,$13,$69,$D7,$23  ; $9929 15 d7 23 99 13 69 d7 23
    DEFB $99,$13,$7E,$D7,$23,$99,$13,$D9  ; $9931 99 13 7e d7 23 99 13 d9
    DEFB $D7,$2D,$99,$13,$FA,$D7,$37,$99  ; $9939 d7 2d 99 13 fa d7 37 99
    DEFB $02,$FA,$FD,$FC,$0E,$37,$99,$01  ; $9941 02 fa fd fc 0e 37 99 01
    DEFB $31,$0E,$23,$99                  ; $9949 31 0e 23 99

    ORG $9F38
; DATA: Global action id / rule pointer table with FF terminator
    DEFB $01,$03,$DD,$02,$03,$DD,$03,$03  ; $9F38 01 03 dd 02 03 dd 03 03
    DEFB $DD,$04,$03,$DD,$05,$03,$DD,$06  ; $9F40 dd 04 03 dd 05 03 dd 06
    DEFB $03,$DD,$07,$03,$DD,$08,$03,$DD  ; $9F48 03 dd 07 03 dd 08 03 dd
    DEFB $09,$03,$DD,$0A,$03,$DD,$29,$C1  ; $9F50 09 03 dd 0a 03 dd 29 c1
    DEFB $DC,$17,$C1,$DC,$2C,$C1,$DC,$2A  ; $9F58 dc 17 c1 dc 2c c1 dc 2a
    DEFB $C1,$DC,$10,$8D,$DC,$22,$7B,$DC  ; $9F60 c1 dc 10 8d dc 22 7b dc
    DEFB $21,$6F,$DE,$13,$40,$DF,$14,$35  ; $9F68 21 6f de 13 40 df 14 35
    DEFB $E1,$1A,$02,$DF,$12,$52,$DD,$1B  ; $9F70 e1 1a 02 df 12 52 dd 1b
    DEFB $52,$DD,$2E,$9E,$DD,$0B,$C1,$DC  ; $9F78 52 dd 2e 9e dd 0b c1 dc
    DEFB $11,$C1,$DE,$26,$C1,$DE,$27,$C1  ; $9F80 11 c1 de 26 c1 de 27 c1
    DEFB $DE,$15,$52,$E4,$16,$52,$E4,$32  ; $9F88 de 15 52 e4 16 52 e4 32
    DEFB $D0,$DD,$31,$B4,$DD,$25,$70,$E3  ; $9F90 d0 dd 31 b4 dd 25 70 e3
    DEFB $1C,$57,$DC,$23,$19,$DC,$30,$D6  ; $9F98 1c 57 dc 23 19 dc 30 d6
    DEFB $E1,$2F,$D6,$E1,$20,$7E,$9A,$34  ; $9FA0 e1 2f d6 e1 20 7e 9a 34
    DEFB $C5,$9F,$FF                      ; $9FA8 c5 9f ff

    ORG $BC46
; CODE: Proof scans: BE5A atom traversal versus BE72 group traversal
    LD IX,$9965                           ; $BC46 dd 21 65 99
    LD HL,$0000                           ; $BC4A 21 00 00
    PUSH HL                               ; $BC4D e5
    LD A,(IX+$00)                         ; $BC4E dd 7e 00
    CP $FF                                ; $BC51 fe ff
    JR Z,$BC68                            ; $BC53 28 13
    BIT 0,(IX+$03)                        ; $BC55 dd cb 03 46
    JR Z,$BC63                            ; $BC59 28 08
    BIT 5,(IX+$03)                        ; $BC5B dd cb 03 6e
    JR NZ,$BC63                           ; $BC5F 20 02
    PUSH IX                               ; $BC61 dd e5
    CALL $BE5A                            ; $BC63 cd 5a be
    JR $BC4E                              ; $BC66 18 e6
    POP HL                                ; $BC68 e1
    LD A,H                                ; $BC69 7c
    OR L                                  ; $BC6A b5
    RET Z                                 ; $BC6B c8
    PUSH HL                               ; $BC6C e5
    POP IX                                ; $BC6D dd e1
    CALL $BCC9                            ; $BC6F cd c9 bc
    JR $BC68                              ; $BC72 18 f4
    LD IX,$9965                           ; $BC74 dd 21 65 99
    LD B,$00                              ; $BC78 06 00
    LD A,(IX+$00)                         ; $BC7A dd 7e 00
    CP $FF                                ; $BC7D fe ff
    JR Z,$BC96                            ; $BC7F 28 15
    BIT 0,(IX+$03)                        ; $BC81 dd cb 03 46
    JR Z,$BC91                            ; $BC85 28 0a
    CALL $BCC9                            ; $BC87 cd c9 bc
    JR Z,$BC91                            ; $BC8A 28 05
    LD ($BA1E),IX                         ; $BC8C dd 22 1e ba
    INC B                                 ; $BC90 04
    CALL $BE5A                            ; $BC91 cd 5a be
    JR $BC7A                              ; $BC94 18 e4
    LD A,B                                ; $BC96 78
    LD IX,($BA1E)                         ; $BC97 dd 2a 1e ba
    RET                                   ; $BC9B c9
    LD IX,$9965                           ; $BC9C dd 21 65 99
    LD B,$00                              ; $BCA0 06 00
    LD A,(IX+$00)                         ; $BCA2 dd 7e 00
    CP $FF                                ; $BCA5 fe ff
    JR Z,$BCC4                            ; $BCA7 28 1b
    BIT 0,(IX+$03)                        ; $BCA9 dd cb 03 46
    JR Z,$BCBD                            ; $BCAD 28 0e
    CALL $BCC9                            ; $BCAF cd c9 bc
    JR NZ,$BCBD                           ; $BCB2 20 09
    LD A,B                                ; $BCB4 78
    INC B                                 ; $BCB5 04
    AND A                                 ; $BCB6 a7
    JR NZ,$BCBD                           ; $BCB7 20 04
    LD ($BA1E),IX                         ; $BCB9 dd 22 1e ba
    PUSH BC                               ; $BCBD c5
    CALL $BE72                            ; $BCBE cd 72 be
    POP BC                                ; $BCC1 c1
    JR $BCA2                              ; $BCC2 18 de
    LD IX,($BA1E)                         ; $BCC4 dd 2a 1e ba
    RET                                   ; $BCC8 c9

    ORG $BD51
; CODE: Triple lookup through nested atoms
    LD IX,$9965                           ; $BD51 dd 21 65 99
    LD A,(IX+$00)                         ; $BD55 dd 7e 00
    CP $FF                                ; $BD58 fe ff
    JR Z,$BD66                            ; $BD5A 28 0a
    CALL $BD69                            ; $BD5C cd 69 bd
    JR Z,$BD68                            ; $BD5F 28 07
    CALL $BE5A                            ; $BD61 cd 5a be
    JR $BD55                              ; $BD64 18 ef
    OR $01                                ; $BD66 f6 01
    RET                                   ; $BD68 c9
    LD A,($BA1A)                          ; $BD69 3a 1a ba
    CP (IX+$01)                           ; $BD6C dd be 01
    RET NZ                                ; $BD6F c0
    LD A,($BA19)                          ; $BD70 3a 19 ba
    CP (IX+$00)                           ; $BD73 dd be 00
    RET NZ                                ; $BD76 c0
    LD A,($BA1B)                          ; $BD77 3a 1b ba
    CP (IX+$02)                           ; $BD7A dd be 02
    RET                                   ; $BD7D c9

    ORG $BE5A
; CODE: Proof atom length and group traversal
    PUSH AF                               ; $BE5A f5
    LD DE,$0002                           ; $BE5B 11 02 00
    ADD IX,DE                             ; $BE5E dd 19
    ADD IX,DE                             ; $BE60 dd 19
    BIT 5,(IX-$01)                        ; $BE62 dd cb ff 6e
    JR NZ,$BE6E                           ; $BE66 20 06
    BIT 4,(IX-$01)                        ; $BE68 dd cb ff 66
    JR Z,$BE70                            ; $BE6C 28 02
    ADD IX,DE                             ; $BE6E dd 19
    POP AF                                ; $BE70 f1
    RET                                   ; $BE71 c9
    PUSH AF                               ; $BE72 f5
    LD B,$00                              ; $BE73 06 00
    LD C,(IX+$03)                         ; $BE75 dd 4e 03
    CALL $BE5A                            ; $BE78 cd 5a be
    BIT 3,C                               ; $BE7B cb 59
    JR Z,$BE84                            ; $BE7D 28 05
    LD A,B                                ; $BE7F 78
    AND A                                 ; $BE80 a7
    JR Z,$BE84                            ; $BE81 28 01
    DEC B                                 ; $BE83 05
    BIT 2,C                               ; $BE84 cb 51
    JR Z,$BE8B                            ; $BE86 28 03
    INC B                                 ; $BE88 04
    JR $BE75                              ; $BE89 18 ea
    LD A,B                                ; $BE8B 78
    AND A                                 ; $BE8C a7
    JR NZ,$BE75                           ; $BE8D 20 e6
    POP AF                                ; $BE8F f1
    RET                                   ; $BE90 c9
    BIT 1,(IX+$03)                        ; $BE91 dd cb 03 4e
    JR NZ,$BE72                           ; $BE95 20 db

    ORG $CBA7
; CODE: Restriction flag: refusal text and failed action return
    LD A,($B934)                          ; $CBA7 3a 34 b9
    BIT 6,A                               ; $CBAA cb 77
    RET Z                                 ; $CBAC c8
    POP HL                                ; $CBAD e1
    XOR A                                 ; $CBAE af
    LD ($A027),A                          ; $CBAF 32 27 a0
    LD HL,$681A                           ; $CBB2 21 1a 68
    CALL $A59F                            ; $CBB5 cd 9f a5
    JP $DC15                              ; $CBB8 c3 15 dc

    ORG $D3E8
; CODE: Entity naming: literal personal name versus article and dictionary qualifier
    PUSH AF                               ; $D3E8 f5
    PUSH DE                               ; $D3E9 d5
    LD D,(IY+$01)                         ; $D3EA fd 56 01
    LD E,(IY+$00)                         ; $D3ED fd 5e 00
    CALL $A7D0                            ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                        ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                           ; $D3F7 20 04
    XOR A                                 ; $D3F9 af
    LD ($A7EA),A                          ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                        ; $D3FD fd cb ff 6e
    JR NZ,$D427                           ; $D401 20 24
    JR $D416                              ; $D403 18 11
    PUSH AF                               ; $D405 f5
    PUSH DE                               ; $D406 d5
    LD D,(IY+$01)                         ; $D407 fd 56 01
    LD E,(IY+$00)                         ; $D40A fd 5e 00
    CALL $A7D0                            ; $D40D cd d0 a7
    LD A,($A028)                          ; $D410 3a 28 a0
    AND A                                 ; $D413 a7
    JR NZ,$D438                           ; $D414 20 22
    LD E,(IY+$02)                         ; $D416 fd 5e 02
    LD D,(IY+$03)                         ; $D419 fd 56 03
    RES 7,D                               ; $D41C cb ba
    BIT 7,(IY+$03)                        ; $D41E fd cb 03 7e
    LD A,$40                              ; $D422 3e 40
    CALL Z,$A815                          ; $D424 cc 15 a8
    LD E,(IY+$04)                         ; $D427 fd 5e 04
    LD D,(IY+$05)                         ; $D42A fd 56 05
    RES 7,D                               ; $D42D cb ba
    BIT 7,(IY+$05)                        ; $D42F fd cb 05 7e
    LD A,$40                              ; $D433 3e 40
    CALL Z,$A815                          ; $D435 cc 15 a8
    LD E,(IY+$00)                         ; $D438 fd 5e 00
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $DCD2
; CODE: Walking predicate: exit lookup before suspended-program restriction
    LD A,($A033)                          ; $DCD2 3a 33 a0
    CALL $D448                            ; $DCD5 cd 48 d4
    CP $FF                                ; $DCD8 fe ff
    JP Z,$DC15                            ; $DCDA ca 15 dc
    CALL $CBA7                            ; $DCDD cd a7 cb
    LD IY,($A017)                         ; $DCE0 fd 2a 17 a0
    LD A,(IY+$01)                         ; $DCE4 fd 7e 01
    CP $FF                                ; $DCE7 fe ff
    JP NZ,$DC15                           ; $DCE9 c2 15 dc
    LD A,(IX+$02)                         ; $DCEC dd 7e 02
    AND A                                 ; $DCEF a7
    JP Z,$DC15                            ; $DCF0 ca 15 dc
    LD A,(IX+$01)                         ; $DCF3 dd 7e 01
    CALL $DD35                            ; $DCF6 cd 35 dd
    JP NZ,$DC15                           ; $DCF9 c2 15 dc
    OR $01                                ; $DCFC f6 01
    RET                                   ; $DCFE c9

    ORG $DEA4
; CODE: OPEN execution body
    LD IX,($A013)                         ; $DEA4 dd 2a 13 a0
    SET 5,(IX+$05)                        ; $DEA8 dd cb 05 ee
    OR $01                                ; $DEAC f6 01
    RET                                   ; $DEAE c9

    ORG $DFB8
; CODE: Safe calendar gate
    LD A,($A034)                          ; $DFB8 3a 34 a0
    CP $59                                ; $DFBB fe 59
    JP NZ,$E000                           ; $DFBD c2 00 e0
    LD A,($9FE1)                          ; $DFC0 3a e1 9f
    CP $00                                ; $DFC3 fe 00
    JP NZ,$E000                           ; $DFC5 c2 00 e0
    JR $DFCC                              ; $DFC8 18 02

    ORG $DFCA
; DATA: Safe fatal event DOMAIN header
    DEFB $00,$00                          ; $DFCA 00 00

    ORG $DFCC
; CODE: Basil present / enters terminal selection
    LD HL,$759C                           ; $DFCC 21 9c 75
    LD A,$06                              ; $DFCF 3e 06
    CALL $D237                            ; $DFD1 cd 37 d2
    LD A,($A009)                          ; $DFD4 3a 09 a0
    CP (IX+$0F)                           ; $DFD7 dd be 0f
    JP NZ,$9E74                           ; $DFDA c2 74 9e
    LD HL,$75D2                           ; $DFDD 21 d2 75
    JP $9E74                              ; $DFE0 c3 74 9e
