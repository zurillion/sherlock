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
