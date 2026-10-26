; Sherlock: DATA boundaries are established by table readers.

    ORG $D206
; CODE: Entity iterator advances before reading: entry zero is skipped
    EXX                                 ; $D206 d9
    LD DE,$0003                         ; $D207 11 03 00
    ADD IX,DE                           ; $D20A dd 19
    LD D,(IX+$02)                       ; $D20C dd 56 02
    LD E,(IX+$01)                       ; $D20F dd 5e 01
    PUSH DE                             ; $D212 d5
    POP IY                              ; $D213 fd e1
    LD A,(IX+$00)                       ; $D215 dd 7e 00
    CP $FF                              ; $D218 fe ff
    EXX                                 ; $D21A d9
    RET                                 ; $D21B c9
    PUSH BC                             ; $D21C c5
    LD B,A                              ; $D21D 47
    CALL $D206                          ; $D21E cd 06 d2
    LD A,B                              ; $D221 78
    POP BC                              ; $D222 c1
    RET                                 ; $D223 c9

    ORG $D2ED
; CODE: Direct bulk and recursive weight scans
    PUSH BC                             ; $D2ED c5
    LD B,$01                            ; $D2EE 06 01
    JR $D2F5                            ; $D2F0 18 03
    PUSH BC                             ; $D2F2 c5
    LD B,$00                            ; $D2F3 06 00
    PUSH IX                             ; $D2F5 dd e5
    PUSH IY                             ; $D2F7 fd e5
    LD C,$00                            ; $D2F9 0e 00
    CALL $D305                          ; $D2FB cd 05 d3
    LD A,C                              ; $D2FE 79
    POP IY                              ; $D2FF fd e1
    POP IX                              ; $D301 dd e1
    POP BC                              ; $D303 c1
    RET                                 ; $D304 c9
    PUSH IX                             ; $D305 dd e5
    LD IX,$8B6F                         ; $D307 dd 21 6f 8b
    CALL $D21C                          ; $D30B cd 1c d2
    JR Z,$D334                          ; $D30E 28 24
    CP (IY+$01)                         ; $D310 fd be 01
    JR NZ,$D30B                         ; $D313 20 f6
    PUSH AF                             ; $D315 f5
    SUB A                               ; $D316 97
    CP B                                ; $D317 b8
    LD A,C                              ; $D318 79
    JR Z,$D324                          ; $D319 28 09
    ADD A,(IY+$02)                      ; $D31B fd 86 02
    JP PE,$D337                         ; $D31E ea 37 d3
    LD C,A                              ; $D321 4f
    JR $D331                            ; $D322 18 0d
    ADD A,(IY+$03)                      ; $D324 fd 86 03
    JP PE,$D337                         ; $D327 ea 37 d3
    LD C,A                              ; $D32A 4f
    LD A,(IX+$00)                       ; $D32B dd 7e 00
    CALL $D305                          ; $D32E cd 05 d3
    POP AF                              ; $D331 f1
    JR $D30B                            ; $D332 18 d7
    POP IX                              ; $D334 dd e1
    RET                                 ; $D336 c9
    POP AF                              ; $D337 f1
    LD C,$FF                            ; $D338 0e ff
    JR $D334                            ; $D33A 18 f8

    ORG $E3EA
; DATA: Enter-cab rule header
    DEFB $78,$20,$B8,$E3,$90,$40,$28,$00 ; $E3EA 78 20 b8 e3 90 40 28 00
    DEFB $00                            ; $E3F2 00

    ORG $E3F3
; CODE: Entry predicates and bulk check
    JR $E413                            ; $E3F3 18 1e
    CALL $CBA7                          ; $E3F5 cd a7 cb
    CALL $DCA7                          ; $E3F8 cd a7 dc
    RET Z                               ; $E3FB c8
    LD IX,($A017)                       ; $E3FC dd 2a 17 a0
    LD IY,($A013)                       ; $E400 fd 2a 13 a0
    LD A,($A034)                        ; $E404 3a 34 a0
    JP $DEE4                            ; $E407 c3 e4 de

    ORG $E40A
; DATA: Enter-container rule header
    DEFB $78,$20,$F5,$E3,$90,$40,$28,$00 ; $E40A 78 20 f5 e3 90 40 28 00
    DEFB $00                            ; $E412 00

    ORG $E413
; CODE: Entry body and exit predicate
    LD IY,($A017)                       ; $E413 fd 2a 17 a0
    LD A,($A034)                        ; $E417 3a 34 a0
    LD (IY+$01),A                       ; $E41A fd 77 01
    OR $01                              ; $E41D f6 01
    RET                                 ; $E41F c9
    CALL $CBA7                          ; $E420 cd a7 cb
    LD A,($A036)                        ; $E423 3a 36 a0
    LD HL,$A034                         ; $E426 21 34 a0
    CALL $D278                          ; $E429 cd 78 d2
    JP NC,$DC15                         ; $E42C d2 15 dc
    OR $01                              ; $E42F f6 01
    RET                                 ; $E431 c9

    ORG $D835
; CODE: Collective search exhaustion returns DOMAIN failure
    LD A,($D6B8)                        ; $D835 3a b8 d6
    AND A                               ; $D838 a7
    JR NZ,$D858                         ; $D839 20 1d
    LD IX,($9FF2)                       ; $D83B dd 2a f2 9f
    LD L,(IX-$02)                       ; $D83F dd 6e fe
    LD H,(IX-$01)                       ; $D842 dd 66 ff
    LD ($9FF2),HL                       ; $D845 22 f2 9f
    CALL $A1C7                          ; $D848 cd c7 a1
    LD A,L                              ; $D84B 7d
    OR H                                ; $D84C b4
    JR Z,$D858                          ; $D84D 28 09
    PUSH HL                             ; $D84F e5
    POP IX                              ; $D850 dd e1
    BIT 6,(IX+$01)                      ; $D852 dd cb 01 76
    JR NZ,$D83F                         ; $D856 20 e7
    OR $01                              ; $D858 f6 01
    RET                                 ; $D85A c9
    XOR A                               ; $D85B af
    LD ($D6B8),A                        ; $D85C 32 b8 d6
    LD A,($A01C)                        ; $D85F 3a 1c a0
    AND A                               ; $D862 a7
    JR Z,$D870                          ; $D863 28 0b
    LD A,$FF                            ; $D865 3e ff
    LD ($A033),A                        ; $D867 32 33 a0
    CALL $D835                          ; $D86A cd 35 d8
    JP $DC15                            ; $D86D c3 15 dc

    ORG $C388
; CODE: Glyph caller fields, shift and last scan
    PUSH AF                             ; $C388 f5
    PUSH BC                             ; $C389 c5
    PUSH DE                             ; $C38A d5
    PUSH HL                             ; $C38B e5
    LD L,A                              ; $C38C 6f
    LD H,$00                            ; $C38D 26 00
    ADD HL,HL                           ; $C38F 29
    ADD HL,HL                           ; $C390 29
    ADD HL,HL                           ; $C391 29
    LD DE,$3C00                         ; $C392 11 00 3c
    ADD HL,DE                           ; $C395 19
    EX DE,HL                            ; $C396 eb
    POP HL                              ; $C397 e1
    PUSH HL                             ; $C398 e5
    LD B,$08                            ; $C399 06 08
    LD A,(DE)                           ; $C39B 1a
    PUSH BC                             ; $C39C c5
    PUSH AF                             ; $C39D f5
    DEC C                               ; $C39E 0d
    INC C                               ; $C39F 0c
    LD B,$FF                            ; $C3A0 06 ff
    JR Z,$C3AB                          ; $C3A2 28 07
    SRL A                               ; $C3A4 cb 3f
    SRL B                               ; $C3A6 cb 38
    DEC C                               ; $C3A8 0d
    JR NZ,$C3A4                         ; $C3A9 20 f9
    LD C,A                              ; $C3AB 4f
    LD A,B                              ; $C3AC 78
    CPL                                 ; $C3AD 2f
    AND (HL)                            ; $C3AE a6
    OR C                                ; $C3AF b1
    LD (HL),A                           ; $C3B0 77
    POP AF                              ; $C3B1 f1
    POP BC                              ; $C3B2 c1
    DEC C                               ; $C3B3 0d
    INC C                               ; $C3B4 0c
    JR Z,$C3D0                          ; $C3B5 28 19
    PUSH BC                             ; $C3B7 c5
    PUSH AF                             ; $C3B8 f5
    LD A,$08                            ; $C3B9 3e 08
    SUB C                               ; $C3BB 91
    LD C,A                              ; $C3BC 4f
    POP AF                              ; $C3BD f1
    LD B,$FF                            ; $C3BE 06 ff
    SLA A                               ; $C3C0 cb 27
    SLA B                               ; $C3C2 cb 20
    DEC C                               ; $C3C4 0d
    JR NZ,$C3C0                         ; $C3C5 20 f9
    LD C,A                              ; $C3C7 4f
    LD A,B                              ; $C3C8 78
    CPL                                 ; $C3C9 2f
    INC HL                              ; $C3CA 23
    AND (HL)                            ; $C3CB a6
    OR C                                ; $C3CC b1
    LD (HL),A                           ; $C3CD 77
    DEC HL                              ; $C3CE 2b
    POP BC                              ; $C3CF c1
    INC DE                              ; $C3D0 13
    INC H                               ; $C3D1 24
    DJNZ $C39B                          ; $C3D2 10 c7
    POP HL                              ; $C3D4 e1
    POP DE                              ; $C3D5 d1
    POP BC                              ; $C3D6 c1
    LD A,C                              ; $C3D7 79
    ADD A,$07                           ; $C3D8 c6 07
    CP $08                              ; $C3DA fe 08
    JR C,$C3E1                          ; $C3DC 38 03
    SUB $08                             ; $C3DE d6 08
    INC L                               ; $C3E0 2c
    LD C,A                              ; $C3E1 4f
    POP AF                              ; $C3E2 f1
    RET                                 ; $C3E3 c9

    ORG $A414
; CODE: Sentence period remains in the word buffer
    LD A,$2E                            ; $A414 3e 2e
    JP $A9B7                            ; $A416 c3 b7 a9

    ORG $D60B
; CODE: Passage and free-exit descriptions
    PUSH BC                             ; $D60B c5
    PUSH DE                             ; $D60C d5
    PUSH IY                             ; $D60D fd e5
    PUSH IX                             ; $D60F dd e5
    CALL $D5EF                          ; $D611 cd ef d5
    PUSH IX                             ; $D614 dd e5
    POP IY                              ; $D616 fd e1
    JR $D660                            ; $D618 18 46
    LD A,(IY+$01)                       ; $D61A fd 7e 01
    AND A                               ; $D61D a7
    JR Z,$D660                          ; $D61E 28 40
    LD A,(IY+$00)                       ; $D620 fd 7e 00
    CP $0B                              ; $D623 fe 0b
    JR NC,$D660                         ; $D625 30 39
    LD A,(IY+$01)                       ; $D627 fd 7e 01
    CALL $D237                          ; $D62A cd 37 d2
    BIT 7,(IX+$05)                      ; $D62D dd cb 05 7e
    JR Z,$D660                          ; $D631 28 2d
    LD A,(IY+$00)                       ; $D633 fd 7e 00
    CALL $D5FB                          ; $D636 cd fb d5
    CP $09                              ; $D639 fe 09
    JR C,$D647                          ; $D63B 38 0a
    LD DE,$000A                         ; $D63D 11 0a 00
    JR Z,$D64D                          ; $D640 28 0b
    LD DE,$00E7                         ; $D642 11 e7 00
    JR $D64D                            ; $D645 18 06
    LD HL,$68BC                         ; $D647 21 bc 68
    CALL $A59F                          ; $D64A cd 9f a5
    CALL $A887                          ; $D64D cd 87 a8
    LD HL,$68E9                         ; $D650 21 e9 68
    CALL $A59F                          ; $D653 cd 9f a5
    PUSH IY                             ; $D656 fd e5
    CALL $D3D5                          ; $D658 cd d5 d3
    CALL $A414                          ; $D65B cd 14 a4
    POP IY                              ; $D65E fd e1
    ADD IY,BC                           ; $D660 fd 09
    LD A,$FF                            ; $D662 3e ff
    CP (IY+$00)                         ; $D664 fd be 00
    JP NZ,$D61A                         ; $D667 c2 1a d6
    POP IX                              ; $D66A dd e1
    POP IY                              ; $D66C fd e1
    POP DE                              ; $D66E d1
    POP BC                              ; $D66F c1
    RET                                 ; $D670 c9
    ADD IX,BC                           ; $D671 dd 09
    LD A,$FF                            ; $D673 3e ff
    CP (IX+$00)                         ; $D675 dd be 00
    RET Z                               ; $D678 c8
    XOR A                               ; $D679 af
    CP (IX+$01)                         ; $D67A dd be 01
    JR NZ,$D671                         ; $D67D 20 f2
    LD A,(IX+$00)                       ; $D67F dd 7e 00
    AND A                               ; $D682 a7
    JR Z,$D671                          ; $D683 28 ec
    CP $0B                              ; $D685 fe 0b
    JR NC,$D671                         ; $D687 30 e8
    OR $01                              ; $D689 f6 01
    RET                                 ; $D68B c9
    PUSH IX                             ; $D68C dd e5
    PUSH IY                             ; $D68E fd e5
    PUSH DE                             ; $D690 d5
    PUSH BC                             ; $D691 c5
    CALL $D5EF                          ; $D692 cd ef d5
    CALL $D671                          ; $D695 cd 71 d6
    JR Z,$D6B1                          ; $D698 28 17
    LD HL,$68F1                         ; $D69A 21 f1 68
    CALL $A59F                          ; $D69D cd 9f a5
    LD A,(IX+$00)                       ; $D6A0 dd 7e 00
    CALL $D5FB                          ; $D6A3 cd fb d5
    CALL $A887                          ; $D6A6 cd 87 a8
    CALL $D671                          ; $D6A9 cd 71 d6
    JR NZ,$D6A0                         ; $D6AC 20 f2
    CALL $A414                          ; $D6AE cd 14 a4
    POP BC                              ; $D6B1 c1
    POP DE                              ; $D6B2 d1
    POP IY                              ; $D6B3 fd e1
    POP IX                              ; $D6B5 dd e1
    RET                                 ; $D6B7 c9

    ORG $99F1
; DATA: Last mutable fact: six-byte prefix and reference terms
    DEFB $0D,$01,$5E,$A4,$0A,$9A,$00,$00 ; $99F1 0d 01 5e a4 0a 9a 00 00
    DEFB $00,$08                        ; $99F9 00 08

    ORG $99FB
; DATA: Immutable fact-table terminator: subject FF
    DEFB $FF                            ; $99FB ff

    ORG $99FC
; CODE: Fact handler and excerpt that modifies 99FA, not the terminator
    CALL $9A74                          ; $99FC cd 74 9a
    LD HL,$7079                         ; $99FF 21 79 70
    JP $A59F                            ; $9A02 c3 9f a5
    LD HL,$99FA                         ; $9A05 21 fa 99
    SET 1,(HL)                          ; $9A08 cb ce
    CALL $9A74                          ; $9A0A cd 74 9a

    ORG $BC46
; CODE: Three fact scanners: compare subject with FF
    LD IX,$9965                         ; $BC46 dd 21 65 99
    LD HL,$0000                         ; $BC4A 21 00 00
    PUSH HL                             ; $BC4D e5
    LD A,(IX+$00)                       ; $BC4E dd 7e 00
    CP $FF                              ; $BC51 fe ff
    JR Z,$BC68                          ; $BC53 28 13
    BIT 0,(IX+$03)                      ; $BC55 dd cb 03 46
    JR Z,$BC63                          ; $BC59 28 08
    BIT 5,(IX+$03)                      ; $BC5B dd cb 03 6e
    JR NZ,$BC63                         ; $BC5F 20 02
    PUSH IX                             ; $BC61 dd e5
    CALL $BE5A                          ; $BC63 cd 5a be
    JR $BC4E                            ; $BC66 18 e6
    POP HL                              ; $BC68 e1
    LD A,H                              ; $BC69 7c
    OR L                                ; $BC6A b5
    RET Z                               ; $BC6B c8
    PUSH HL                             ; $BC6C e5
    POP IX                              ; $BC6D dd e1
    CALL $BCC9                          ; $BC6F cd c9 bc
    JR $BC68                            ; $BC72 18 f4
    LD IX,$9965                         ; $BC74 dd 21 65 99
    LD B,$00                            ; $BC78 06 00
    LD A,(IX+$00)                       ; $BC7A dd 7e 00
    CP $FF                              ; $BC7D fe ff
    JR Z,$BC96                          ; $BC7F 28 15
    BIT 0,(IX+$03)                      ; $BC81 dd cb 03 46
    JR Z,$BC91                          ; $BC85 28 0a
    CALL $BCC9                          ; $BC87 cd c9 bc
    JR Z,$BC91                          ; $BC8A 28 05
    LD ($BA1E),IX                       ; $BC8C dd 22 1e ba
    INC B                               ; $BC90 04
    CALL $BE5A                          ; $BC91 cd 5a be
    JR $BC7A                            ; $BC94 18 e4
    LD A,B                              ; $BC96 78
    LD IX,($BA1E)                       ; $BC97 dd 2a 1e ba
    RET                                 ; $BC9B c9
    LD IX,$9965                         ; $BC9C dd 21 65 99
    LD B,$00                            ; $BCA0 06 00
    LD A,(IX+$00)                       ; $BCA2 dd 7e 00
    CP $FF                              ; $BCA5 fe ff
    JR Z,$BCC4                          ; $BCA7 28 1b
    BIT 0,(IX+$03)                      ; $BCA9 dd cb 03 46
    JR Z,$BCBD                          ; $BCAD 28 0e
    CALL $BCC9                          ; $BCAF cd c9 bc
    JR NZ,$BCBD                         ; $BCB2 20 09
    LD A,B                              ; $BCB4 78
    INC B                               ; $BCB5 04
    AND A                               ; $BCB6 a7
    JR NZ,$BCBD                         ; $BCB7 20 04
    LD ($BA1E),IX                       ; $BCB9 dd 22 1e ba
    PUSH BC                             ; $BCBD c5
    CALL $BE72                          ; $BCBE cd 72 be
    POP BC                              ; $BCC1 c1
    JR $BCA2                            ; $BCC2 18 de
    LD IX,($BA1E)                       ; $BCC4 dd 2a 1e ba
    RET                                 ; $BCC8 c9

    ORG $CAF0
; CODE: Announce shared-object action with anonymous actor FF
    LD A,($A036)                        ; $CAF0 3a 36 a0
    LD B,A                              ; $CAF3 47
    LD A,$FF                            ; $CAF4 3e ff
    LD ($A036),A                        ; $CAF6 32 36 a0
    LD A,$01                            ; $CAF9 3e 01
    LD ($5C3C),A                        ; $CAFB 32 3c 5c
    LD A,($A009)                        ; $CAFE 3a 09 a0
    CALL $D471                          ; $CB01 cd 71 d4
    CP $FF                              ; $CB04 fe ff
    CALL NZ,$CA76                       ; $CB06 c4 76 ca
    SUB A                               ; $CB09 97
    LD ($5C3C),A                        ; $CB0A 32 3c 5c
    LD A,B                              ; $CB0D 78
    LD ($A036),A                        ; $CB0E 32 36 a0
    RET                                 ; $CB11 c9

    ORG $D7FA
; DATA: Player semantic-rule header: classes zero, zero duration
    DEFB $00,$00                        ; $D7FA 00 00
