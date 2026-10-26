; Sherlock: verified excerpts. Rule headers and mutable cells are DATA.

    ORG $B6DA
; CODE: Scenery matching and nominal groups
    CALL $B6FD                          ; $B6DA cd fd b6
    RET Z                               ; $B6DD c8
    POP DE                              ; $B6DE d1
    CALL $B83C                          ; $B6DF cd 3c b8
    CALL $B633                          ; $B6E2 cd 33 b6
    LD HL,($B186)                       ; $B6E5 2a 86 b1
    PUSH HL                             ; $B6E8 e5
    LD HL,$68A2                         ; $B6E9 21 a2 68
    CALL $A59F                          ; $B6EC cd 9f a5
    RET                                 ; $B6EF c9
    CALL $B6FD                          ; $B6F0 cd fd b6
    RET Z                               ; $B6F3 c8
    POP DE                              ; $B6F4 d1
    CALL $B83C                          ; $B6F5 cd 3c b8
    CALL $B62F                          ; $B6F8 cd 2f b6
    JR $B6E5                            ; $B6FB 18 e8
    XOR A                               ; $B6FD af
    LD ($B77E),A                        ; $B6FE 32 7e b7
    LD ($B6D8),HL                       ; $B701 22 d8 b6
    CALL $D33C                          ; $B704 cd 3c d3
    LD L,(IX+$07)                       ; $B707 dd 6e 07
    LD H,(IX+$08)                       ; $B70A dd 66 08
    LD A,H                              ; $B70D 7c
    OR L                                ; $B70E b5
    RET Z                               ; $B70F c8
    PUSH HL                             ; $B710 e5
    POP IX                              ; $B711 dd e1
    LD HL,$0000                         ; $B713 21 00 00
    LD ($B6D6),HL                       ; $B716 22 d6 b6
    LD IY,$AAAC                         ; $B719 fd 21 ac aa
    LD HL,$AAAC                         ; $B71D 21 ac aa
    LD B,$06                            ; $B720 06 06
    CALL $A2AB                          ; $B722 cd ab a2
    CALL $B77F                          ; $B725 cd 7f b7
    RET Z                               ; $B728 c8
    CALL $B772                          ; $B729 cd 72 b7
    CP $50                              ; $B72C fe 50
    JR Z,$B75A                          ; $B72E 28 2a
    CP $60                              ; $B730 fe 60
    JR NZ,$B725                         ; $B732 20 f1
    LD (IY+$02),E                       ; $B734 fd 73 02
    LD (IY+$03),D                       ; $B737 fd 72 03
    CALL $B77F                          ; $B73A cd 7f b7
    RET Z                               ; $B73D c8
    CALL $B772                          ; $B73E cd 72 b7
    CP $50                              ; $B741 fe 50
    JR Z,$B75A                          ; $B743 28 15
    CP $60                              ; $B745 fe 60
    JR NZ,$B71D                         ; $B747 20 d4
    LD (IY+$04),E                       ; $B749 fd 73 04
    LD (IY+$05),D                       ; $B74C fd 72 05
    CALL $B77F                          ; $B74F cd 7f b7
    RET Z                               ; $B752 c8
    CALL $B772                          ; $B753 cd 72 b7
    CP $50                              ; $B756 fe 50
    JR NZ,$B71D                         ; $B758 20 c3
    LD (IY+$00),E                       ; $B75A fd 73 00
    LD (IY+$01),D                       ; $B75D fd 72 01
    LD HL,($B6D8)                       ; $B760 2a d8 b6
    CALL $A4E0                          ; $B763 cd e0 a4
    JR NZ,$B71D                         ; $B766 20 b5
    LD IX,($B6D6)                       ; $B768 dd 2a d6 b6
    CALL $A1AF                          ; $B76C cd af a1
    OR $01                              ; $B76F f6 01
    RET                                 ; $B771 c9
    LD HL,$5DBF                         ; $B772 21 bf 5d
    LD A,D                              ; $B775 7a
    AND $0F                             ; $B776 e6 0f
    LD D,A                              ; $B778 57
    ADD HL,DE                           ; $B779 19
    LD A,(HL)                           ; $B77A 7e
    AND $F0                             ; $B77B e6 f0
    RET                                 ; $B77D c9

    ORG $B77E
; DATA: Mutable end-of-fragment flag
    DEFB $00                            ; $B77E 00

    ORG $B77F
; CODE: Text-data search reader and two-byte call records
    LD A,($B77E)                        ; $B77F 3a 7e b7
    CP $FF                              ; $B782 fe ff
    JR NZ,$B7AA                         ; $B784 20 24
    LD HL,($B6D6)                       ; $B786 2a d6 b6
    LD A,L                              ; $B789 7d
    OR H                                ; $B78A b4
    RET Z                               ; $B78B c8
    XOR A                               ; $B78C af
    LD ($B77E),A                        ; $B78D 32 7e b7
    PUSH HL                             ; $B790 e5
    POP IX                              ; $B791 dd e1
    LD L,(IX-$02)                       ; $B793 dd 6e fe
    LD H,(IX-$01)                       ; $B796 dd 66 ff
    LD ($B6D6),HL                       ; $B799 22 d6 b6
    LD L,(IX+$00)                       ; $B79C dd 6e 00
    LD H,(IX+$01)                       ; $B79F dd 66 01
    CALL $A1C7                          ; $B7A2 cd c7 a1
    INC HL                              ; $B7A5 23
    INC HL                              ; $B7A6 23
    PUSH HL                             ; $B7A7 e5
    POP IX                              ; $B7A8 dd e1
    LD A,(IX+$00)                       ; $B7AA dd 7e 00
    INC IX                              ; $B7AD dd 23
    BIT 7,A                             ; $B7AF cb 7f
    JR Z,$B7CD                          ; $B7B1 28 1a
    LD D,A                              ; $B7B3 57
    LD E,(IX+$00)                       ; $B7B4 dd 5e 00
    INC IX                              ; $B7B7 dd 23
    AND $70                             ; $B7B9 e6 70
    CP $60                              ; $B7BB fe 60
    JR Z,$B7C6                          ; $B7BD 28 07
    CP $30                              ; $B7BF fe 30
    JR Z,$B7C6                          ; $B7C1 28 03
    CP $20                              ; $B7C3 fe 20
    RET NZ                              ; $B7C5 c0
    LD A,$FF                            ; $B7C6 3e ff
    LD ($B77E),A                        ; $B7C8 32 7e b7
    AND A                               ; $B7CB a7
    RET                                 ; $B7CC c9
    CP $20                              ; $B7CD fe 20
    JR C,$B7F7                          ; $B7CF 38 26
    CP $60                              ; $B7D1 fe 60
    JR C,$B7DD                          ; $B7D3 38 08
    CALL $A840                          ; $B7D5 cd 40 a8
    OR $01                              ; $B7D8 f6 01
    LD A,$00                            ; $B7DA 3e 00
    RET                                 ; $B7DC c9
    AND $1F                             ; $B7DD e6 1f
    INC A                               ; $B7DF 3c
    LD B,A                              ; $B7E0 47
    PUSH IX                             ; $B7E1 dd e5
    POP HL                              ; $B7E3 e1
    INC HL                              ; $B7E4 23
    LD C,$00                            ; $B7E5 0e 00
    CALL $A990                          ; $B7E7 cd 90 a9
    DJNZ $B7E7                          ; $B7EA 10 fb
    PUSH HL                             ; $B7EC e5
    POP IX                              ; $B7ED dd e1
    LD A,C                              ; $B7EF 79
    AND A                               ; $B7F0 a7
    JR NZ,$B7AA                         ; $B7F1 20 b7
    DEC IX                              ; $B7F3 dd 2b
    JR $B7AA                            ; $B7F5 18 b3
    CP $02                              ; $B7F7 fe 02
    JR NZ,$B807                         ; $B7F9 20 0c
    LD E,(IX+$00)                       ; $B7FB dd 5e 00
    LD D,(IX+$01)                       ; $B7FE dd 56 01
    ADD IX,DE                           ; $B801 dd 19
    DEC IX                              ; $B803 dd 2b
    JR $B7AA                            ; $B805 18 a3
    CP $0B                              ; $B807 fe 0b
    JR NZ,$B834                         ; $B809 20 29
    LD E,(IX+$00)                       ; $B80B dd 5e 00
    LD D,(IX+$01)                       ; $B80E dd 56 01
    PUSH IX                             ; $B811 dd e5
    POP HL                              ; $B813 e1
    LD A,$02                            ; $B814 3e 02
    CALL $A11C                          ; $B816 cd 1c a1
    LD (IX+$00),L                       ; $B819 dd 75 00
    LD (IX+$01),H                       ; $B81C dd 74 01
    PUSH HL                             ; $B81F e5
    LD HL,($B6D6)                       ; $B820 2a d6 b6
    LD ($B6D6),IX                       ; $B823 dd 22 d6 b6
    LD (IX-$02),L                       ; $B827 dd 75 fe
    LD (IX-$01),H                       ; $B82A dd 74 ff
    POP HL                              ; $B82D e1
    ADD HL,DE                           ; $B82E 19
    PUSH HL                             ; $B82F e5
    POP IX                              ; $B830 dd e1
    JR $B803                            ; $B832 18 cf
    CP $1D                              ; $B834 fe 1d
    JP C,$B7AA                          ; $B836 da aa b7
    JP $B786                            ; $B839 c3 86 b7

    ORG $D2ED
; CODE: Direct-child bulk, recursive weight, signed overflow clamp
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

    ORG $DCA2
; CODE: Ordinary TAKE predicate
    CALL $D26C                          ; $DCA2 cd 6c d2
    JR C,$DCB6                          ; $DCA5 38 0f
    LD A,($A036)                        ; $DCA7 3a 36 a0
    LD HL,$A034                         ; $DCAA 21 34 a0
    CALL $D278                          ; $DCAD cd 78 d2
    JP C,$DC15                          ; $DCB0 da 15 dc
    OR $01                              ; $DCB3 f6 01
    RET                                 ; $DCB5 c9
    LD HL,$DCBB                         ; $DCB6 21 bb dc
    XOR A                               ; $DCB9 af
    RET                                 ; $DCBA c9
    LD HL,$68B7                         ; $DCBB 21 b7 68
    JP $A59F                            ; $DCBE c3 9f a5

    ORG $DCC1
; DATA: TAKE header: class 9, duration 1, predicate DCA2
    DEFB $69,$10,$A2,$DC                ; $DCC1 69 10 a2 dc

    ORG $DCC5
; CODE: Ordinary TAKE body
    LD IX,($A013)                       ; $DCC5 dd 2a 13 a0
    LD A,($A036)                        ; $DCC9 3a 36 a0
    LD (IX+$01),A                       ; $DCCC dd 77 01
    OR $01                              ; $DCCF f6 01
    RET                                 ; $DCD1 c9

    ORG $DE9D
; DATA: Rule header: object.open
    DEFB $38,$10,$80,$21,$00,$00,$00    ; $DE9D 38 10 80 21 00 00 00

    ORG $DEA4
; CODE: OPEN body
    LD IX,($A013)                       ; $DEA4 dd 2a 13 a0
    SET 5,(IX+$05)                      ; $DEA8 dd cb 05 ee
    OR $01                              ; $DEAC f6 01
    RET                                 ; $DEAE c9

    ORG $DEC1
; DATA: Placement header: classes A/8, duration 1, masks and predicate DED9
    DEFB $7A,$18,$D9,$DE,$09,$00,$00,$40 ; $DEC1 7a 18 d9 de 09 00 00 40
    DEFB $28                            ; $DEC9 28

    ORG $DECA
; CODE: Placement body and bulk predicate
    LD A,(IY+$0F)                       ; $DECA fd 7e 0f
    LD (IX+$0F),A                       ; $DECD dd 77 0f
    LD A,($A035)                        ; $DED0 3a 35 a0
    LD (IX+$01),A                       ; $DED3 dd 77 01
    OR $01                              ; $DED6 f6 01
    RET                                 ; $DED8 c9
    LD IX,($A013)                       ; $DED9 dd 2a 13 a0
    LD IY,($A015)                       ; $DEDD fd 2a 15 a0
    LD A,($A035)                        ; $DEE1 3a 35 a0
    LD B,A                              ; $DEE4 47
    LD A,(IY+$04)                       ; $DEE5 fd 7e 04
    AND $07                             ; $DEE8 e6 07
    JP Z,$DC15                          ; $DEEA ca 15 dc
    LD A,(IY+$02)                       ; $DEED fd 7e 02
    SUB (IX+$02)                        ; $DEF0 dd 96 02
    JR C,$DF00                          ; $DEF3 38 0b
    PUSH AF                             ; $DEF5 f5
    LD A,B                              ; $DEF6 78
    CALL $D2ED                          ; $DEF7 cd ed d2
    LD B,A                              ; $DEFA 47
    POP AF                              ; $DEFB f1
    SUB B                               ; $DEFC 90
    JR C,$DF00                          ; $DEFD 38 01
    RET NZ                              ; $DEFF c0
    XOR A                               ; $DF00 af
    RET                                 ; $DF01 c9

    ORG $DF49
; CODE: EXAMINE and shared inspection
    LD A,$01                            ; $DF49 3e 01
    LD ($CAAE),A                        ; $DF4B 32 ae ca
    CALL $DC6C                          ; $DF4E cd 6c dc
    RET NZ                              ; $DF51 c0
    CALL $DF5B                          ; $DF52 cd 5b df
    CALL $A2A2                          ; $DF55 cd a2 a2
    OR $01                              ; $DF58 f6 01
    RET                                 ; $DF5A c9
    LD A,($A034)                        ; $DF5B 3a 34 a0
    CALL $D237                          ; $DF5E cd 37 d2
    SET 6,(IX+$06)                      ; $DF61 dd cb 06 f6
    LD L,(IX+$0D)                       ; $DF65 dd 6e 0d
    LD H,(IX+$0E)                       ; $DF68 dd 66 0e
    LD A,H                              ; $DF6B 7c
    OR L                                ; $DF6C b5
    JP NZ,$A59F                         ; $DF6D c2 9f a5
    LD HL,$68E1                         ; $DF70 21 e1 68
    CALL $A59F                          ; $DF73 cd 9f a5
    CALL $D3D5                          ; $DF76 cd d5 d3
    LD A,$2E                            ; $DF79 3e 2e
    JP $A9B7                            ; $DF7B c3 b7 a9

    ORG $DF7E
; DATA: Rule header: object.takeNote
    DEFB $88,$00                        ; $DF7E 88 00

    ORG $DF80
; DATA: Object domain operation: rule
    DEFB $07,$C1,$DC,$FD,$FF            ; $DF80 07 c1 dc fd ff

    ORG $DF85
; DATA: Object domain operation: rule
    DEFB $07,$8B,$DF,$FD,$FF            ; $DF85 07 8b df fd ff

    ORG $DF8A
; DATA: Object domain operation: return.success
    DEFB $0B                            ; $DF8A 0b

    ORG $DF8B
; DATA: Rule header: object.quenchNote
    DEFB $08,$00                        ; $DF8B 08 00

    ORG $DF8D
; CODE: Quench or retain burnt note
    LD A,($9CA1)                        ; $DF8D 3a a1 9c
    AND A                               ; $DF90 a7
    JR Z,$E000                          ; $DF91 28 6d
    LD A,$FF                            ; $DF93 3e ff
    LD ($9CA1),A                        ; $DF95 32 a1 9c
    LD IX,($A013)                       ; $DF98 dd 2a 13 a0
    LD HL,$07D5                         ; $DF9C 21 d5 07
    LD (IX+$09),L                       ; $DF9F dd 75 09
    LD (IX+$0A),H                       ; $DFA2 dd 74 0a
    JR $E000                            ; $DFA5 18 59

    ORG $DFA7
; DATA: Rule header: object.openSafe
    DEFB $C8,$00,$1C,$E0                ; $DFA7 c8 00 1c e0

    ORG $DFAB
; DATA: Object domain operation: rule
    DEFB $07,$B6,$DF,$FD,$FF            ; $DFAB 07 b6 df fd ff

    ORG $DFB0
; DATA: Object domain operation: rule
    DEFB $07,$9D,$DE,$FD,$FF            ; $DFB0 07 9d de fd ff

    ORG $DFB5
; DATA: Object domain operation: return.success
    DEFB $0B                            ; $DFB5 0b

    ORG $DFB6
; DATA: Rule header: object.safeEvent
    DEFB $07,$F0                        ; $DFB6 07 f0

    ORG $DFB8
; CODE: Safe calendar test and terminal branches
    LD A,($A034)                        ; $DFB8 3a 34 a0
    CP $59                              ; $DFBB fe 59
    JP NZ,$E000                         ; $DFBD c2 00 e0
    LD A,($9FE1)                        ; $DFC0 3a e1 9f
    CP $00                              ; $DFC3 fe 00
    JP NZ,$E000                         ; $DFC5 c2 00 e0
    JR $DFCC                            ; $DFC8 18 02
    NOP                                 ; $DFCA 00
    NOP                                 ; $DFCB 00
    LD HL,$759C                         ; $DFCC 21 9c 75
    LD A,$06                            ; $DFCF 3e 06
    CALL $D237                          ; $DFD1 cd 37 d2
    LD A,($A009)                        ; $DFD4 3a 09 a0
    CP (IX+$0F)                         ; $DFD7 dd be 0f
    JP NZ,$9E74                         ; $DFDA c2 74 9e
    LD HL,$75D2                         ; $DFDD 21 d2 75
    JP $9E74                            ; $DFE0 c3 74 9e

    ORG $E03A
; CODE: Transfer actor identity and context ownership
    LD C,A                              ; $E03A 4f
    LD A,($A036)                        ; $E03B 3a 36 a0
    CALL $CC0E                          ; $E03E cd 0e cc
    LD (IY+$00),C                       ; $E041 fd 71 00
    LD IY,($A017)                       ; $E044 fd 2a 17 a0
    LD A,C                              ; $E048 79
    CALL $D237                          ; $E049 cd 37 d2
    LD ($A017),IX                       ; $E04C dd 22 17 a0
    LD A,(IY+$01)                       ; $E050 fd 7e 01
    LD (IX+$01),A                       ; $E053 dd 77 01
    LD (IY+$01),$FF                     ; $E056 fd 36 01 ff
    LD A,(IY+$0F)                       ; $E05A fd 7e 0f
    LD (IX+$0F),A                       ; $E05D dd 77 0f
    LD (IY+$0F),$00                     ; $E060 fd 36 0f 00
    LD B,$00                            ; $E064 06 00
    INC B                               ; $E066 04
    LD A,B                              ; $E067 78
    CP $6E                              ; $E068 fe 6e
    JR Z,$E07C                          ; $E06A 28 10
    CALL $D237                          ; $E06C cd 37 d2
    LD A,($A036)                        ; $E06F 3a 36 a0
    CP (IX+$01)                         ; $E072 dd be 01
    JR NZ,$E066                         ; $E075 20 ef
    LD (IX+$01),C                       ; $E077 dd 71 01
    JR $E066                            ; $E07A 18 ea
    CALL $CFB6                          ; $E07C cd b6 cf
    JR Z,$E086                          ; $E07F 28 05
    LD (IX+$00),C                       ; $E081 dd 71 00
    JR $E07C                            ; $E084 18 f6
    LD A,C                              ; $E086 79
    LD ($A036),A                        ; $E087 32 36 a0
    OR $01                              ; $E08A f6 01
    RET                                 ; $E08C c9

    ORG $E0A0
; DATA: Rule header: object.inspectStream
    DEFB $88,$00                        ; $E0A0 88 00

    ORG $E0A2
; DATA: Object domain operation: rule
    DEFB $07,$AD,$E0,$02,$5D            ; $E0A2 07 ad e0 02 5d

    ORG $E0A7
; DATA: Object domain operation: rule
    DEFB $07,$35,$E1,$FD,$FF            ; $E0A7 07 35 e1 fd ff

    ORG $E0AC
; DATA: Object domain operation: return.success
    DEFB $0B                            ; $E0AC 0b

    ORG $E0AD
; DATA: Rule header: object.streamClue
    DEFB $4D,$07,$1C,$E0                ; $E0AD 4d 07 1c e0

    ORG $E0B1
; CODE: Tuesday stream clue
    LD A,($A00A)                        ; $E0B1 3a 0a a0
    CP $58                              ; $E0B4 fe 58
    JR NZ,$E0DD                         ; $E0B6 20 25
    LD A,($9FE1)                        ; $E0B8 3a e1 9f
    CP $01                              ; $E0BB fe 01
    JR NZ,$E0DD                         ; $E0BD 20 1e
    LD IX,($A015)                       ; $E0BF dd 2a 15 a0
    SET 7,(IX+$06)                      ; $E0C3 dd cb 06 fe
    SET 7,(IX+$05)                      ; $E0C7 dd cb 05 fe
    LD A,($A00A)                        ; $E0CB 3a 0a a0
    LD (IX+$0F),A                       ; $E0CE dd 77 0f
    LD A,($A034)                        ; $E0D1 3a 34 a0
    LD (IX+$01),A                       ; $E0D4 dd 77 01
    LD HL,$7B5A                         ; $E0D7 21 5a 7b
    CALL $A59F                          ; $E0DA cd 9f a5
    OR $01                              ; $E0DD f6 01
    RET                                 ; $E0DF c9

    ORG $E0E0
; DATA: Rule header: object.inspectTrash
    DEFB $88,$00                        ; $E0E0 88 00

    ORG $E0E2
; DATA: Object domain operation: rule
    DEFB $07,$35,$E1,$FD,$FF            ; $E0E2 07 35 e1 fd ff

    ORG $E0E7
; DATA: Object domain operation: rule
    DEFB $03,$EB,$E0                    ; $E0E7 03 eb e0

    ORG $E0EA
; DATA: Object domain operation: return.success
    DEFB $0B                            ; $E0EA 0b

    ORG $E0EB
; DATA: Rule header: object.revealNote
    DEFB $00,$00                        ; $E0EB 00 00

    ORG $E0ED
; CODE: Reveal torn note
    LD A,$51                            ; $E0ED 3e 51
    JP $9C56                            ; $E0EF c3 56 9c

    ORG $E0F2
; DATA: Rule header: object.inspectDrawer
    DEFB $88,$00                        ; $E0F2 88 00

    ORG $E0F4
; DATA: Object domain operation: rule
    DEFB $07,$35,$E1,$FD,$FF            ; $E0F4 07 35 e1 fd ff

    ORG $E0F9
; DATA: Object domain operation: rule
    DEFB $03,$FD,$E0                    ; $E0F9 03 fd e0

    ORG $E0FC
; DATA: Object domain operation: return.success
    DEFB $0B                            ; $E0FC 0b

    ORG $E0FD
; DATA: Rule header: object.revealBottom
    DEFB $00,$00                        ; $E0FD 00 00

    ORG $E0FF
; CODE: Reveal false bottom
    LD A,$3F                            ; $E0FF 3e 3f
    JP $9C56                            ; $E101 c3 56 9c

    ORG $E104
; DATA: Rule header: object.inspectBookcase
    DEFB $08,$60                        ; $E104 08 60

    ORG $E106
; CODE: Bookcase discovery and early return
    LD A,$01                            ; $E106 3e 01
    LD ($CAAE),A                        ; $E108 32 ae ca
    LD A,($A036)                        ; $E10B 3a 36 a0
    AND A                               ; $E10E a7
    RET NZ                              ; $E10F c0
    CALL $DF5B                          ; $E110 cd 5b df
    LD IX,($A013)                       ; $E113 dd 2a 13 a0
    BIT 5,(IX+$05)                      ; $E117 dd cb 05 6e
    RET NZ                              ; $E11B c0
    SET 5,(IX+$05)                      ; $E11C dd cb 05 ee
    LD HL,$7BF7                         ; $E120 21 f7 7b
    LD (IX+$0D),L                       ; $E123 dd 75 0d
    LD (IX+$0E),H                       ; $E126 dd 74 0e
    LD HL,$7C13                         ; $E129 21 13 7c
    CALL $A59F                          ; $E12C cd 9f a5
    CALL $A2A2                          ; $E12F cd a2 a2
    OR $01                              ; $E132 f6 01
    RET                                 ; $E134 c9

    ORG $E135
; DATA: Rule header: object.inspectClosely
    DEFB $78,$50,$2E,$DF,$80,$40,$00,$00 ; $E135 78 50 2e df 80 40 00 00
    DEFB $00                            ; $E13D 00

    ORG $E13E
; CODE: Detailed inspection body and table lookup
    LD A,$01                            ; $E13E 3e 01
    LD ($CAAE),A                        ; $E140 32 ae ca
    LD A,($A036)                        ; $E143 3a 36 a0
    AND A                               ; $E146 a7
    RET NZ                              ; $E147 c0
    CALL $E151                          ; $E148 cd 51 e1
    CALL $A2A2                          ; $E14B cd a2 a2
    OR $01                              ; $E14E f6 01
    RET                                 ; $E150 c9
    CALL $DF5B                          ; $E151 cd 5b df
    LD A,($A034)                        ; $E154 3a 34 a0
    LD IX,$E16B                         ; $E157 dd 21 6b e1
    CALL $D34E                          ; $E15B cd 4e d3
    CP $FF                              ; $E15E fe ff
    RET Z                               ; $E160 c8
    LD L,(IX+$01)                       ; $E161 dd 6e 01
    LD H,(IX+$02)                       ; $E164 dd 66 02
    CALL $A59F                          ; $E167 cd 9f a5
    RET                                 ; $E16A c9

    ORG $E16B
; DATA: Detailed inspection entity/text table; FF terminator
    DEFB $4C,$C2,$7B,$66,$D7,$7B,$39,$9E ; $E16B 4c c2 7b 66 d7 7b 39 9e
    DEFB $7C,$3E,$E7,$7C,$2E,$4A,$7C,$FF ; $E173 7c 3e e7 7c 2e 4a 7c ff
