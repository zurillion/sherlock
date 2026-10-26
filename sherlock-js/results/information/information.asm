; Verified typed listing: research only; not executed by JavaScript.

    ORG $994D
; DATA: Predicate lexicon
    DEFB $FE,$00,$BA,$03,$D8,$03,$85,$04  ; $994D fe 00 ba 03 d8 03 85 04
    DEFB $98,$04,$56,$09,$DB,$03,$CD,$02  ; $9955 98 04 56 09 db 03 cd 02
    DEFB $0A,$04,$32,$06,$38,$05,$00,$00  ; $995D 0a 04 32 06 38 05 00 00

    ORG $9965
; DATA: Proof trees and FF terminator
    DEFB $07,$04,$62,$A4,$3D,$9A,$07,$06  ; $9965 07 04 62 a4 3d 9a 07 06
    DEFB $63,$8C,$00,$00,$00,$08,$5E,$05  ; $996D 63 8c 00 00 00 08 5e 05
    DEFB $60,$A4,$4B,$9A,$2E,$00,$39,$40  ; $9975 60 a4 4b 9a 2e 00 39 40
    DEFB $5D,$00,$5D,$08,$5F,$05,$0D,$A4  ; $997D 5d 00 5d 08 5f 05 0d a4
    DEFB $59,$9A,$48,$00,$42,$40,$43,$00  ; $9985 59 9a 48 00 42 40 43 00
    DEFB $43,$40,$00,$00,$00,$00,$00,$00  ; $998D 43 40 00 00 00 00 00 00
    DEFB $00,$08,$06,$03,$61,$A4,$13,$9A  ; $9995 00 08 06 03 61 a4 13 9a
    DEFB $57,$00,$58,$40,$5A,$00,$53,$40  ; $999D 57 00 58 40 5a 00 53 40
    DEFB $51,$00,$51,$48,$6A,$04,$69,$A4  ; $99A5 51 00 51 48 6a 04 69 a4
    DEFB $FC,$99,$00,$00,$00,$00,$55,$00  ; $99AD fc 99 00 00 00 00 55 00
    DEFB $55,$40,$00,$00,$00,$0A,$0D,$05  ; $99B5 55 40 00 00 00 0a 0d 05
    DEFB $5E,$B4,$00,$00,$00,$00,$00,$08  ; $99BD 5e b4 00 00 00 00 00 08
    DEFB $0D,$05,$5F,$B4,$00,$00,$00,$00  ; $99C5 0d 05 5f b4 00 00 00 00
    DEFB $00,$08,$06,$05,$5E,$B4,$00,$00  ; $99CD 00 08 06 05 5e b4 00 00
    DEFB $00,$00,$00,$08,$06,$05,$5F,$B4  ; $99D5 00 00 00 08 06 05 5f b4
    DEFB $00,$00,$00,$00,$00,$08,$0D,$02  ; $99DD 00 00 00 00 00 08 0d 02
    DEFB $61,$A4,$05,$9A,$40,$00,$41,$40  ; $99E5 61 a4 05 9a 40 00 41 40
    DEFB $57,$00,$58,$48,$0D,$01,$5E,$A4  ; $99ED 57 00 58 48 0d 01 5e a4
    DEFB $0A,$9A,$00,$00,$00,$08,$FF      ; $99F5 0a 9a 00 00 00 08 ff

    ORG $99FC
; CODE: Deduction consequences
    CALL $9A74                            ; $99FC cd 74 9a
    LD HL,$7079                           ; $99FF 21 79 70
    JP $A59F                              ; $9A02 c3 9f a5
    LD HL,$99FA                           ; $9A05 21 fa 99
    SET 1,(HL)                            ; $9A08 cb ce
    CALL $9A74                            ; $9A0A cd 74 9a
    LD HL,$70E3                           ; $9A0D 21 e3 70
    JP $A59F                              ; $9A10 c3 9f a5
    LD A,($9976)                          ; $9A13 3a 76 99
    AND $02                               ; $9A16 e6 02
    JR Z,$9A2F                            ; $9A18 28 15
    LD A,($9984)                          ; $9A1A 3a 84 99
    AND $02                               ; $9A1D e6 02
    JR Z,$9A2F                            ; $9A1F 28 0e
    CALL $9A74                            ; $9A21 cd 74 9a
    LD HL,$99B2                           ; $9A24 21 b2 99
    SET 1,(HL)                            ; $9A27 cb ce
    LD HL,$7099                           ; $9A29 21 99 70
    JP $A59F                              ; $9A2C c3 9f a5
    RES 1,(IX+$03)                        ; $9A2F dd cb 03 8e
    RES 0,(IX+$03)                        ; $9A33 dd cb 03 86
    LD HL,$7265                           ; $9A37 21 65 72
    JP $A59F                              ; $9A3A c3 9f a5
    CALL $9A74                            ; $9A3D cd 74 9a
    LD A,$01                              ; $9A40 3e 01
    LD ($9E88),A                          ; $9A42 32 88 9e
    LD HL,$70F0                           ; $9A45 21 f0 70
    JP $A59F                              ; $9A48 c3 9f a5
    CALL $9A74                            ; $9A4B cd 74 9a
    LD HL,$9976                           ; $9A4E 21 76 99
    SET 1,(HL)                            ; $9A51 cb ce
    LD HL,$6FAB                           ; $9A53 21 ab 6f
    JP $A59F                              ; $9A56 c3 9f a5
    CALL $9A74                            ; $9A59 cd 74 9a
    LD A,$5F                              ; $9A5C 3e 5f
    CALL $D237                            ; $9A5E cd 37 d2
    LD (IX+$01),$FF                       ; $9A61 dd 36 01 ff
    LD (IX+$0F),$00                       ; $9A65 dd 36 0f 00
    LD HL,$9984                           ; $9A69 21 84 99
    SET 1,(HL)                            ; $9A6C cb ce
    LD HL,$6FCA                           ; $9A6E 21 ca 6f
    JP $A59F                              ; $9A71 c3 9f a5
    SET 1,(IX+$03)                        ; $9A74 dd cb 03 ce
    RES 0,(IX+$03)                        ; $9A78 dd cb 03 86
    RET                                   ; $9A7C c9

    ORG $9A7D
; DATA: Watson exception table terminator
    DEFB $FF,$00,$00                      ; $9A7D ff 00 00

    ORG $BA13
; DATA: Statement lookup working fields
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $BA13 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00              ; $BA1B 00 00 00 00 00

    ORG $BA20
; CODE: Statement dispatch and request cleanup
    LD A,($A036)                          ; $BA20 3a 36 a0
    LD HL,$BA67                           ; $BA23 21 67 ba
    CP $03                                ; $BA26 fe 03
    JR Z,$BA31                            ; $BA28 28 07
    LD HL,$BB67                           ; $BA2A 21 67 bb
    CP $02                                ; $BA2D fe 02
    JR NZ,$BA34                           ; $BA2F 20 03
    CALL $BA3E                            ; $BA31 cd 3e ba
    LD A,$01                              ; $BA34 3e 01
    POP HL                                ; $BA36 e1
    POP IY                                ; $BA37 fd e1
    POP IX                                ; $BA39 dd e1
    AND A                                 ; $BA3B a7
    SCF                                   ; $BA3C 37
    RET                                   ; $BA3D c9
    PUSH IX                               ; $BA3E dd e5
    XOR A                                 ; $BA40 af
    LD ($9FEB),A                          ; $BA41 32 eb 9f
    LD E,(IX+$05)                         ; $BA44 dd 5e 05
    LD D,(IX+$06)                         ; $BA47 dd 56 06
    PUSH DE                               ; $BA4A d5
    PUSH DE                               ; $BA4B d5
    POP IY                                ; $BA4C fd e1
    CALL $D1DB                            ; $BA4E cd db d1
    POP IX                                ; $BA51 dd e1
    PUSH AF                               ; $BA53 f5
    CALL $A1AF                            ; $BA54 cd af a1
    POP AF                                ; $BA57 f1
    POP IX                                ; $BA58 dd e1
    PUSH AF                               ; $BA5A f5
    CALL $B9FA                            ; $BA5B cd fa b9
    POP AF                                ; $BA5E f1
    RET                                   ; $BA5F c9

    ORG $BA60
; DATA: Watson memory working fields
    DEFB $00,$00,$00,$00,$00,$00,$00      ; $BA60 00 00 00 00 00 00 00

    ORG $BA67
; CODE: Watson acceptance, Lestrade proofs, observation trees, triple rendering
    LD ($BA60),A                          ; $BA67 32 60 ba
    LD ($BA61),A                          ; $BA6A 32 61 ba
    CALL $BD7E                            ; $BA6D cd 7e bd
    JP C,$BBBE                            ; $BA70 da be bb
    JR Z,$BAA6                            ; $BA73 28 31
    CALL $BD4B                            ; $BA75 cd 4b bd
    JR NZ,$BA85                           ; $BA78 20 0b
    LD A,$01                              ; $BA7A 3e 01
    CALL $BB46                            ; $BA7C cd 46 bb
    LD ($BA65),IX                         ; $BA7F dd 22 65 ba
    JR $BAAB                              ; $BA83 18 26
    CALL $BD51                            ; $BA85 cd 51 bd
    JR NZ,$BA9D                           ; $BA88 20 13
    LD A,$02                              ; $BA8A 3e 02
    BIT 5,(IX+$03)                        ; $BA8C dd cb 03 6e
    JR NZ,$BA7C                           ; $BA90 20 ea
    CALL $D29D                            ; $BA92 cd 9d d2
    CP $32                                ; $BA95 fe 32
    LD A,$03                              ; $BA97 3e 03
    JR C,$BA7C                            ; $BA99 38 e1
    JR $BAA6                              ; $BA9B 18 09
    CALL $D29D                            ; $BA9D cd 9d d2
    CP $46                                ; $BAA0 fe 46
    LD A,$04                              ; $BAA2 3e 04
    JR C,$BA7C                            ; $BAA4 38 d6
    CALL $AEA9                            ; $BAA6 cd a9 ae
    JR NZ,$BA6D                           ; $BAA9 20 c2
    LD A,($BA60)                          ; $BAAB 3a 60 ba
    AND A                                 ; $BAAE a7
    JP Z,$BB3F                            ; $BAAF ca 3f bb
    LD A,($BA61)                          ; $BAB2 3a 61 ba
    AND A                                 ; $BAB5 a7
    JR Z,$BB16                            ; $BAB6 28 5e
    LD IX,$9FF6                           ; $BAB8 dd 21 f6 9f
    CALL $A0F7                            ; $BABC cd f7 a0
    JR Z,$BAF5                            ; $BABF 28 34
    LD A,($BA62)                          ; $BAC1 3a 62 ba
    CP (IX+$00)                           ; $BAC4 dd be 00
    JR NZ,$BABC                           ; $BAC7 20 f3
    LD A,($BA63)                          ; $BAC9 3a 63 ba
    CP (IX+$01)                           ; $BACC dd be 01
    JR NZ,$BABC                           ; $BACF 20 eb
    LD A,($BA64)                          ; $BAD1 3a 64 ba
    CP (IX+$02)                           ; $BAD4 dd be 02
    JR NZ,$BABC                           ; $BAD7 20 e3
    PUSH IY                               ; $BAD9 fd e5
    PUSH IX                               ; $BADB dd e5
    POP DE                                ; $BADD d1
    LD IY,$9FF4                           ; $BADE fd 21 f4 9f
    CALL $A104                            ; $BAE2 cd 04 a1
    LD A,(IX-$02)                         ; $BAE5 dd 7e fe
    LD (IY-$02),A                         ; $BAE8 fd 77 fe
    LD A,(IX-$01)                         ; $BAEB dd 7e ff
    LD (IY-$01),A                         ; $BAEE fd 77 ff
    POP IY                                ; $BAF1 fd e1
    JR $BAFA                              ; $BAF3 18 05
    LD A,$05                              ; $BAF5 3e 05
    CALL $A11C                            ; $BAF7 cd 1c a1
    LD A,($BA62)                          ; $BAFA 3a 62 ba
    LD HL,($BA63)                         ; $BAFD 2a 63 ba
    LD (IX+$00),A                         ; $BB00 dd 77 00
    LD (IX+$01),L                         ; $BB03 dd 75 01
    LD (IX+$02),H                         ; $BB06 dd 74 02
    LD HL,($9FF4)                         ; $BB09 2a f4 9f
    LD ($9FF4),IX                         ; $BB0C dd 22 f4 9f
    LD (IX-$02),L                         ; $BB10 dd 75 fe
    LD (IX-$01),H                         ; $BB13 dd 74 ff
    LD A,($BA60)                          ; $BB16 3a 60 ba
    CP $01                                ; $BB19 fe 01
    JR Z,$BB5C                            ; $BB1B 28 3f
    CALL $D29D                            ; $BB1D cd 9d d2
    CP $19                                ; $BB20 fe 19
    JR C,$BB3F                            ; $BB22 38 1b
    LD IX,$BA62                           ; $BB24 dd 21 62 ba
    CALL $BD06                            ; $BB28 cd 06 bd
    JR NZ,$BB3F                           ; $BB2B 20 12
    LD A,C                                ; $BB2D 79
    PUSH BC                               ; $BB2E c5
    CALL $A4BC                            ; $BB2F cd bc a4
    POP AF                                ; $BB32 f1
    PUSH HL                               ; $BB33 e5
    CALL $A4BC                            ; $BB34 cd bc a4
    PUSH HL                               ; $BB37 e5
    LD HL,$6F62                           ; $BB38 21 62 6f
    CALL $A59F                            ; $BB3B cd 9f a5
    RET                                   ; $BB3E c9
    LD HL,$6F54                           ; $BB3F 21 54 6f
    CALL $A59F                            ; $BB42 cd 9f a5
    RET                                   ; $BB45 c9
    PUSH AF                               ; $BB46 f5
    LD A,$01                              ; $BB47 3e 01
    LD ($BA61),A                          ; $BB49 32 61 ba
    POP AF                                ; $BB4C f1
    LD ($BA60),A                          ; $BB4D 32 60 ba
    LD HL,$BA19                           ; $BB50 21 19 ba
    LD DE,$BA62                           ; $BB53 11 62 ba
    LD BC,$0003                           ; $BB56 01 03 00
    LDIR                                  ; $BB59 ed b0
    RET                                   ; $BB5B c9
    LD IX,($BA65)                         ; $BB5C dd 2a 65 ba
    LD L,(IX+$03)                         ; $BB60 dd 6e 03
    LD H,(IX+$04)                         ; $BB63 dd 66 04
    JP (HL)                               ; $BB66 e9
    LD ($BA1D),A                          ; $BB67 32 1d ba
    LD ($BA1C),A                          ; $BB6A 32 1c ba
    CALL $BD7E                            ; $BB6D cd 7e bd
    JP C,$BBBE                            ; $BB70 da be bb
    CALL $BC21                            ; $BB73 cd 21 bc
    JR Z,$BB7C                            ; $BB76 28 04
    LD HL,$BA1C                           ; $BB78 21 1c ba
    INC (HL)                              ; $BB7B 34
    CALL $AEA9                            ; $BB7C cd a9 ae
    JR NZ,$BB6D                           ; $BB7F 20 ec
    LD A,($BA1C)                          ; $BB81 3a 1c ba
    AND A                                 ; $BB84 a7
    JR NZ,$BB8E                           ; $BB85 20 07
    LD HL,$725F                           ; $BB87 21 5f 72
    CALL $A59F                            ; $BB8A cd 9f a5
    RET                                   ; $BB8D c9
    LD A,($BA1D)                          ; $BB8E 3a 1d ba
    AND A                                 ; $BB91 a7
    JR Z,$BBC9                            ; $BB92 28 35
    LD IX,($BA1E)                         ; $BB94 dd 2a 1e ba
    PUSH IX                               ; $BB98 dd e5
    CALL $BE5A                            ; $BB9A cd 5a be
    LD A,(IX+$03)                         ; $BB9D dd 7e 03
    AND $C0                               ; $BBA0 e6 c0
    CP $80                                ; $BBA2 fe 80
    JR Z,$BBB1                            ; $BBA4 28 0b
    BIT 3,(IX+$03)                        ; $BBA6 dd cb 03 5e
    JR NZ,$BBB1                           ; $BBAA 20 05
    CALL $BE72                            ; $BBAC cd 72 be
    JR $BB9D                              ; $BBAF 18 ec
    POP IX                                ; $BBB1 dd e1
    JR NZ,$BBC4                           ; $BBB3 20 0f
    LD HL,$7295                           ; $BBB5 21 95 72
    PUSH IX                               ; $BBB8 dd e5
    CALL $A59F                            ; $BBBA cd 9f a5
    RET                                   ; $BBBD c9
    LD HL,$7243                           ; $BBBE 21 43 72
    JP $A59F                              ; $BBC1 c3 9f a5
    LD HL,$72A6                           ; $BBC4 21 a6 72
    JR $BBB8                              ; $BBC7 18 ef
    CALL $BC46                            ; $BBC9 cd 46 bc
    CALL $BC9C                            ; $BBCC cd 9c bc
    LD A,B                                ; $BBCF 78
    AND A                                 ; $BBD0 a7
    JR NZ,$BBE5                           ; $BBD1 20 12
    CALL $BC74                            ; $BBD3 cd 74 bc
    AND A                                 ; $BBD6 a7
    JR Z,$BBDE                            ; $BBD7 28 05
    LD HL,$72BD                           ; $BBD9 21 bd 72
    JR $BBB8                              ; $BBDC 18 da
    LD HL,$727E                           ; $BBDE 21 7e 72
    CALL $A59F                            ; $BBE1 cd 9f a5
    RET                                   ; $BBE4 c9
    PUSH AF                               ; $BBE5 f5
    LD HL,$67FF                           ; $BBE6 21 ff 67
    CALL $A59F                            ; $BBE9 cd 9f a5
    POP AF                                ; $BBEC f1
    CP $01                                ; $BBED fe 01
    LD HL,$72D6                           ; $BBEF 21 d6 72
    CALL NZ,$A59F                         ; $BBF2 c4 9f a5
    BIT 4,(IX+$03)                        ; $BBF5 dd cb 03 66
    JR Z,$BC1A                            ; $BBF9 28 1f
    RES 1,(IX+$03)                        ; $BBFB dd cb 03 8e
    PUSH IX                               ; $BBFF dd e5
    LD HL,$72E1                           ; $BC01 21 e1 72
    CALL $A59F                            ; $BC04 cd 9f a5
    LD L,(IX+$04)                         ; $BC07 dd 6e 04
    LD H,(IX+$05)                         ; $BC0A dd 66 05
    LD A,L                                ; $BC0D 7d
    OR H                                  ; $BC0E b4
    JP NZ,$A59F                           ; $BC0F c2 9f a5
    LD A,$22                              ; $BC12 3e 22
    CALL $A9B7                            ; $BC14 cd b7 a9
    JP $A414                              ; $BC17 c3 14 a4
    LD L,(IX+$04)                         ; $BC1A dd 6e 04
    LD H,(IX+$05)                         ; $BC1D dd 66 05
    JP (HL)                               ; $BC20 e9
    CALL $BD51                            ; $BC21 cd 51 bd
    JR NZ,$BC2F                           ; $BC24 20 09
    LD A,(IX+$03)                         ; $BC26 dd 7e 03
    AND $C0                               ; $BC29 e6 c0
    CP $80                                ; $BC2B fe 80
    JR Z,$BC31                            ; $BC2D 28 02
    XOR A                                 ; $BC2F af
    RET                                   ; $BC30 c9
    LD ($BA1E),IX                         ; $BC31 dd 22 1e ba
    CALL $BCC9                            ; $BC35 cd c9 bc
    JR Z,$BC43                            ; $BC38 28 09
    LD A,$01                              ; $BC3A 3e 01
    LD ($BA1D),A                          ; $BC3C 32 1d ba
    SET 0,(IX+$03)                        ; $BC3F dd cb 03 c6
    OR $01                                ; $BC43 f6 01
    RET                                   ; $BC45 c9
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
    BIT 2,(IX+$03)                        ; $BCC9 dd cb 03 56
    JR Z,$BCDA                            ; $BCCD 28 0b
    PUSH IX                               ; $BCCF dd e5
    PUSH BC                               ; $BCD1 c5
    CALL $BF08                            ; $BCD2 cd 08 bf
    POP BC                                ; $BCD5 c1
    POP IX                                ; $BCD6 dd e1
    JR Z,$BD03                            ; $BCD8 28 29
    BIT 5,(IX+$03)                        ; $BCDA dd cb 03 6e
    JR Z,$BCE6                            ; $BCDE 28 06
    SET 0,(IX+$03)                        ; $BCE0 dd cb 03 c6
    JR $BD01                              ; $BCE4 18 1b
    SET 1,(IX+$03)                        ; $BCE6 dd cb 03 ce
    RES 0,(IX+$03)                        ; $BCEA dd cb 03 86
    BIT 4,(IX+$03)                        ; $BCEE dd cb 03 66
    JR Z,$BD01                            ; $BCF2 28 0d
    LD L,(IX+$04)                         ; $BCF4 dd 6e 04
    LD H,(IX+$05)                         ; $BCF7 dd 66 05
    PUSH IX                               ; $BCFA dd e5
    CALL $D1DB                            ; $BCFC cd db d1
    POP IX                                ; $BCFF dd e1
    XOR A                                 ; $BD01 af
    RET                                   ; $BD02 c9
    OR $01                                ; $BD03 f6 01
    RET                                   ; $BD05 c9
    PUSH IY                               ; $BD06 fd e5
    PUSH IX                               ; $BD08 dd e5
    POP IY                                ; $BD0A fd e1
    LD IX,$9FF6                           ; $BD0C dd 21 f6 9f
    CALL $A0F7                            ; $BD10 cd f7 a0
    JR Z,$BD46                            ; $BD13 28 31
    LD B,(IX+$02)                         ; $BD15 dd 46 02
    LD C,(IY+$02)                         ; $BD18 fd 4e 02
    LD A,(IX+$00)                         ; $BD1B dd 7e 00
    CP (IY+$00)                           ; $BD1E fd be 00
    JR Z,$BD3E                            ; $BD21 28 1b
    LD C,(IY+$00)                         ; $BD23 fd 4e 00
    CP (IY+$02)                           ; $BD26 fd be 02
    JR Z,$BD3E                            ; $BD29 28 13
    LD B,(IX+$00)                         ; $BD2B dd 46 00
    LD A,(IX+$02)                         ; $BD2E dd 7e 02
    CP (IY+$02)                           ; $BD31 fd be 02
    JR Z,$BD3E                            ; $BD34 28 08
    LD C,(IY+$02)                         ; $BD36 fd 4e 02
    CP (IY+$00)                           ; $BD39 fd be 00
    JR NZ,$BD10                           ; $BD3C 20 d2
    LD A,B                                ; $BD3E 78
    CP C                                  ; $BD3F b9
    JR Z,$BD10                            ; $BD40 28 ce
    POP IY                                ; $BD42 fd e1
    XOR A                                 ; $BD44 af
    RET                                   ; $BD45 c9
    OR $01                                ; $BD46 f6 01
    POP IY                                ; $BD48 fd e1
    RET                                   ; $BD4A c9
    LD IX,$9A7D                           ; $BD4B dd 21 7d 9a
    JR $BD55                              ; $BD4F 18 04
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
    PUSH IY                               ; $BD7E fd e5
    POP HL                                ; $BD80 e1
    LD DE,$0018                           ; $BD81 11 18 00
    ADD HL,DE                             ; $BD84 19
    BIT 7,(IY+$19)                        ; $BD85 fd cb 19 7e
    JR Z,$BD8E                            ; $BD89 28 03
    LD HL,$9FF6                           ; $BD8B 21 f6 9f
    BIT 6,(IY+$19)                        ; $BD8E fd cb 19 76
    JR Z,$BD97                            ; $BD92 28 03
    LD HL,$9FFC                           ; $BD94 21 fc 9f
    LD DE,$B172                           ; $BD97 11 72 b1
    LD BC,$0006                           ; $BD9A 01 06 00
    LDIR                                  ; $BD9D ed b0
    PUSH IY                               ; $BD9F fd e5
    POP HL                                ; $BDA1 e1
    LD DE,$0008                           ; $BDA2 11 08 00
    ADD HL,DE                             ; $BDA5 19
    LD DE,$B178                           ; $BDA6 11 78 b1
    LD BC,$0006                           ; $BDA9 01 06 00
    LDIR                                  ; $BDAC ed b0
    LD L,(IY+$00)                         ; $BDAE fd 6e 00
    LD A,(IY+$01)                         ; $BDB1 fd 7e 01
    AND $0F                               ; $BDB4 e6 0f
    LD H,A                                ; $BDB6 67
    LD ($BA17),HL                         ; $BDB7 22 17 ba
    PUSH IY                               ; $BDBA fd e5
    CALL $BDC2                            ; $BDBC cd c2 bd
    POP IY                                ; $BDBF fd e1
    RET                                   ; $BDC1 c9
    CALL $D04F                            ; $BDC2 cd 4f d0
    LD ($BA13),IX                         ; $BDC5 dd 22 13 ba
    LD ($BA15),IX                         ; $BDC9 dd 22 15 ba
    LD DE,($BA17)                         ; $BDCD ed 5b 17 ba
    LD HL,$994D                           ; $BDD1 21 4d 99
    LD B,$01                              ; $BDD4 06 01
    LD A,(HL)                             ; $BDD6 7e
    INC HL                                ; $BDD7 23
    OR (HL)                               ; $BDD8 b6
    DEC HL                                ; $BDD9 2b
    RET Z                                 ; $BDDA c8
    LD A,E                                ; $BDDB 7b
    CP (HL)                               ; $BDDC be
    JR NZ,$BDE5                           ; $BDDD 20 06
    INC HL                                ; $BDDF 23
    LD A,D                                ; $BDE0 7a
    CP (HL)                               ; $BDE1 be
    DEC HL                                ; $BDE2 2b
    JR Z,$BDEA                            ; $BDE3 28 05
    INC HL                                ; $BDE5 23
    INC HL                                ; $BDE6 23
    INC B                                 ; $BDE7 04
    JR $BDD6                              ; $BDE8 18 ec
    LD A,B                                ; $BDEA 78
    LD ($BA1A),A                          ; $BDEB 32 1a ba
    LD A,$02                              ; $BDEE 3e 02
    LD ($A038),A                          ; $BDF0 32 38 a0
    CALL $BE3C                            ; $BDF3 cd 3c be
    CP $FF                                ; $BDF6 fe ff
    RET Z                                 ; $BDF8 c8
    LD ($BA19),A                          ; $BDF9 32 19 ba
    CALL $BE3C                            ; $BDFC cd 3c be
    CP $FF                                ; $BDFF fe ff
    JR NZ,$BE3A                           ; $BE01 20 37
    LD A,($BA19)                          ; $BE03 3a 19 ba
    CALL $BE22                            ; $BE06 cd 22 be
    CALL $BE4B                            ; $BE09 cd 4b be
    CP $FF                                ; $BE0C fe ff
    RET Z                                 ; $BE0E c8
    LD ($BA1B),A                          ; $BE0F 32 1b ba
    CALL $BE4B                            ; $BE12 cd 4b be
    CP $FF                                ; $BE15 fe ff
    JR NZ,$BE3A                           ; $BE17 20 21
    LD A,($BA1B)                          ; $BE19 3a 1b ba
    CALL $BE22                            ; $BE1C cd 22 be
    OR $01                                ; $BE1F f6 01
    RET                                   ; $BE21 c9
    CALL $D237                            ; $BE22 cd 37 d2
    PUSH IX                               ; $BE25 dd e5
    POP HL                                ; $BE27 e1
    BIT 6,(IX+$05)                        ; $BE28 dd cb 05 76
    LD DE,$9FF6                           ; $BE2C 11 f6 9f
    JR NZ,$BE34                           ; $BE2F 20 03
    LD DE,$9FFC                           ; $BE31 11 fc 9f
    LD BC,$0006                           ; $BE34 01 06 00
    LDIR                                  ; $BE37 ed b0
    RET                                   ; $BE39 c9
    SCF                                   ; $BE3A 37
    RET                                   ; $BE3B c9
    LD IX,($BA13)                         ; $BE3C dd 2a 13 ba
    LD HL,$B172                           ; $BE40 21 72 b1
    CALL $D36A                            ; $BE43 cd 6a d3
    LD ($BA13),IX                         ; $BE46 dd 22 13 ba
    RET                                   ; $BE4A c9
    LD IX,($BA15)                         ; $BE4B dd 2a 15 ba
    LD HL,$B178                           ; $BE4F 21 78 b1
    CALL $D36A                            ; $BE52 cd 6a d3
    LD ($BA15),IX                         ; $BE55 dd 22 15 ba
    RET                                   ; $BE59 c9
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
    LD A,(IX+$03)                         ; $BE97 dd 7e 03
    AND $C0                               ; $BE9A e6 c0
    CP $00                                ; $BE9C fe 00
    JR NZ,$BECD                           ; $BE9E 20 2d
    LD A,(IX+$00)                         ; $BEA0 dd 7e 00
    PUSH IX                               ; $BEA3 dd e5
    CALL $D237                            ; $BEA5 cd 37 d2
    BIT 7,(IX+$06)                        ; $BEA8 dd cb 06 7e
    POP IX                                ; $BEAC dd e1
    JR Z,$BE72                            ; $BEAE 28 c2
    LD A,(IX+$02)                         ; $BEB0 dd 7e 02
    PUSH IX                               ; $BEB3 dd e5
    CALL $D237                            ; $BEB5 cd 37 d2
    BIT 7,(IX+$06)                        ; $BEB8 dd cb 06 7e
    POP IX                                ; $BEBC dd e1
    JR Z,$BE72                            ; $BEBE 28 b2
    SET 1,(IX+$03)                        ; $BEC0 dd cb 03 ce
    RES 0,(IX+$03)                        ; $BEC4 dd cb 03 86
    OR $01                                ; $BEC8 f6 01
    JP $BE72                              ; $BECA c3 72 be
    CP $80                                ; $BECD fe 80
    JR Z,$BE72                            ; $BECF 28 a1
    CP $40                                ; $BED1 fe 40
    JR NZ,$BEF6                           ; $BED3 20 21
    LD A,(IX+$00)                         ; $BED5 dd 7e 00
    PUSH IX                               ; $BED8 dd e5
    CALL $D237                            ; $BEDA cd 37 d2
    BIT 6,(IX+$06)                        ; $BEDD dd cb 06 76
    POP IX                                ; $BEE1 dd e1
    JR Z,$BE72                            ; $BEE3 28 8d
    LD A,(IX+$02)                         ; $BEE5 dd 7e 02
    PUSH IX                               ; $BEE8 dd e5
    CALL $D237                            ; $BEEA cd 37 d2
    BIT 6,(IX+$06)                        ; $BEED dd cb 06 76
    POP IX                                ; $BEF1 dd e1
    JP Z,$BE72                            ; $BEF3 ca 72 be
    BIT 2,(IX+$03)                        ; $BEF6 dd cb 03 56
    JR Z,$BEC0                            ; $BEFA 28 c4
    PUSH IX                               ; $BEFC dd e5
    CALL $BF08                            ; $BEFE cd 08 bf
    POP IX                                ; $BF01 dd e1
    JR NZ,$BEC0                           ; $BF03 20 bb
    JP $BE72                              ; $BF05 c3 72 be
    CALL $BE5A                            ; $BF08 cd 5a be
    BIT 3,(IX+$03)                        ; $BF0B dd cb 03 5e
    PUSH AF                               ; $BF0F f5
    CALL $BE91                            ; $BF10 cd 91 be
    JR NZ,$BF18                           ; $BF13 20 03
    POP AF                                ; $BF15 f1
    XOR A                                 ; $BF16 af
    RET                                   ; $BF17 c9
    POP AF                                ; $BF18 f1
    JR Z,$BF0B                            ; $BF19 28 f0
    RET                                   ; $BF1B c9
    LD A,(IX+$00)                         ; $BF1C dd 7e 00
    CALL $A4BC                            ; $BF1F cd bc a4
    PUSH HL                               ; $BF22 e5
    POP IY                                ; $BF23 fd e1
    CALL $D3E8                            ; $BF25 cd e8 d3
    CALL $BF45                            ; $BF28 cd 45 bf
    JR Z,$BF3D                            ; $BF2B 28 10
    CALL $A887                            ; $BF2D cd 87 a8
    LD A,(IX+$02)                         ; $BF30 dd 7e 02
    CALL $A4BC                            ; $BF33 cd bc a4
    PUSH HL                               ; $BF36 e5
    POP IY                                ; $BF37 fd e1
    CALL $D3E8                            ; $BF39 cd e8 d3
    RET                                   ; $BF3C c9
    LD DE,$005D                           ; $BF3D 11 5d 00
    CALL $A887                            ; $BF40 cd 87 a8
    JR $BF30                              ; $BF43 18 eb
    LD A,(IX+$01)                         ; $BF45 dd 7e 01
    AND A                                 ; $BF48 a7
    RET Z                                 ; $BF49 c8
    DEC A                                 ; $BF4A 3d
    LD E,A                                ; $BF4B 5f
    LD D,$00                              ; $BF4C 16 00
    LD HL,$994D                           ; $BF4E 21 4d 99
    ADD HL,DE                             ; $BF51 19
    ADD HL,DE                             ; $BF52 19
    LD E,(HL)                             ; $BF53 5e
    INC HL                                ; $BF54 23
    LD D,(HL)                             ; $BF55 56
    OR $01                                ; $BF56 f6 01
    RET                                   ; $BF58 c9

    ORG $E686
; CODE: Watson recollection selector
    CALL $D29D                            ; $E686 cd 9d d2
    CP $32                                ; $E689 fe 32
    JP C,$DC15                            ; $E68B da 15 dc
    OR $01                                ; $E68E f6 01
    RET                                   ; $E690 c9
    CALL $E686                            ; $E691 cd 86 e6
    RET Z                                 ; $E694 c8
    CALL $D29D                            ; $E695 cd 9d d2
    LD B,A                                ; $E698 47
    LD IX,$9FF6                           ; $E699 dd 21 f6 9f
    DJNZ $E6A6                            ; $E69D 10 07
    CALL $A0F7                            ; $E69F cd f7 a0
    JR Z,$E699                            ; $E6A2 28 f5
    JR $E69D                              ; $E6A4 18 f7
    PUSH IX                               ; $E6A6 dd e5
    POP HL                                ; $E6A8 e1
    LD DE,$9FF6                           ; $E6A9 11 f6 9f
    AND A                                 ; $E6AC a7
    SBC HL,DE                             ; $E6AD ed 52
    JR Z,$E6B9                            ; $E6AF 28 08
    PUSH IX                               ; $E6B1 dd e5
    LD HL,$6F80                           ; $E6B3 21 80 6f
    CALL $A59F                            ; $E6B6 cd 9f a5
    OR $01                                ; $E6B9 f6 01
    RET                                   ; $E6BB c9
