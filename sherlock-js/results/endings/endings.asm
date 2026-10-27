; Original source evidence only. Headers and NPC DOMAIN sequences are DATA.

    ORG $9A3D
; CODE: Innocence conclusion sets case readiness
    CALL $9A74                            ; $9A3D cd 74 9a
    LD A,$01                              ; $9A40 3e 01
    LD ($9E88),A                          ; $9A42 32 88 9e
    LD HL,$70F0                           ; $9A45 21 f0 70
    JP $A59F                              ; $9A48 c3 9f a5

    ORG $9A4B
; CODE: Murder conclusions and Mrs Jones removal
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

    ORG $9E48
; DATA: Companion-ending DOMAIN header
    DEFB $00,$00                          ; $9E48 00 00

    ORG $9E4A
; CODE: Watson and Lestrade presence decision
    LD HL,$6B79                           ; $9E4A 21 79 6b
    LD A,$03                              ; $9E4D 3e 03
    CALL $9E60                            ; $9E4F cd 60 9e
    JR NZ,$9E74                           ; $9E52 20 20
    LD A,$02                              ; $9E54 3e 02
    CALL $9E60                            ; $9E56 cd 60 9e
    JR NZ,$9E74                           ; $9E59 20 19
    LD HL,$6AF3                           ; $9E5B 21 f3 6a
    JR $9E74                              ; $9E5E 18 14
    CALL $D237                            ; $9E60 cd 37 d2
    LD A,($A009)                          ; $9E63 3a 09 a0
    CP (IX+$0F)                           ; $9E66 dd be 0f
    RET                                   ; $9E69 c9

    ORG $9E6A
; DATA: Straker-ending DOMAIN header
    DEFB $00,$00                          ; $9E6A 00 00

    ORG $9E6C
; CODE: Straker flag, common terminal, acknowledgement and clear
    LD A,($9D90)                          ; $9E6C 3a 90 9d
    AND A                                 ; $9E6F a7
    RET NZ                                ; $9E70 c0
    LD HL,$693A                           ; $9E71 21 3a 69
    LD A,$01                              ; $9E74 3e 01
    LD ($5C3C),A                          ; $9E76 32 3c 5c
    CALL $A59F                            ; $9E79 cd 9f a5
    CALL $C306                            ; $9E7C cd 06 c3
    CALL $A296                            ; $9E7F cd 96 a2
    JP $B0AC                              ; $9E82 c3 ac b0

    ORG $9E85
; DATA: Case-readiness DOMAIN header
    DEFB $00,$00                          ; $9E85 00 00

    ORG $9E87
; CODE: Major arrest and alternate reports; 9E88 mutable operand
    LD A,$00                              ; $9E87 3e 00
    AND A                                 ; $9E89 a7
    RET NZ                                ; $9E8A c0
    LD HL,$6975                           ; $9E8B 21 75 69
    CALL $A59F                            ; $9E8E cd 9f a5
    LD A,($A009)                          ; $9E91 3a 09 a0
    LD HL,$A00A                           ; $9E94 21 0a a0
    CP (HL)                               ; $9E97 be
    LD HL,$69BF                           ; $9E98 21 bf 69
    JR Z,$9E74                            ; $9E9B 28 d7
    LD HL,$6A26                           ; $9E9D 21 26 6a
    JR $9E74                              ; $9EA0 18 d2

    ORG $9EA2
; DATA: Arrest-consequences DOMAIN header
    DEFB $00,$00                          ; $9EA2 00 00

    ORG $9EA4
; CODE: Murder proofs and stolen plans endings
    LD HL,$6A33                           ; $9EA4 21 33 6a
    LD IX,$9973                           ; $9EA7 dd 21 73 99
    BIT 1,(IX+$03)                        ; $9EAB dd cb 03 4e
    JR Z,$9E74                            ; $9EAF 28 c3
    LD IX,$9981                           ; $9EB1 dd 21 81 99
    BIT 1,(IX+$03)                        ; $9EB5 dd cb 03 4e
    JR Z,$9E74                            ; $9EB9 28 b9
    LD HL,$6ABD                           ; $9EBB 21 bd 6a
    JR $9E74                              ; $9EBE 18 b4

    ORG $9FC5
; DATA: KILL class-zero header and predicate pointer
    DEFB $40,$00,$C9,$9F                  ; $9FC5 40 00 c9 9f

    ORG $9FC9
; CODE: Always-failing KILL predicate and refusal printer
    LD HL,$9FCE                           ; $9FC9 21 ce 9f
    XOR A                                 ; $9FCC af
    RET                                   ; $9FCD c9
    LD HL,$680B                           ; $9FCE 21 0b 68
    JP $A59F                              ; $9FD1 c3 9f a5

    ORG $A296
; CODE: Eighteen unconditional CRs; reset counter after every CR
    LD B,$12                              ; $A296 06 12
    CALL $A2A2                            ; $A298 cd a2 a2
    XOR A                                 ; $A29B af
    LD ($A019),A                          ; $A29C 32 19 a0
    DJNZ $A298                            ; $A29F 10 f7
    RET                                   ; $A2A1 c9
    PUSH AF                               ; $A2A2 f5
    LD A,$0D                              ; $A2A3 3e 0d
    CALL $A9B7                            ; $A2A5 cd b7 a9
    POP AF                                ; $A2A8 f1
    RET                                   ; $A2A9 c9

    ORG $B0AC
; CODE: Post-ending restart service; web freezes BEFORE this entry
    LD HL,$0000                           ; $B0AC 21 00 00
    LD ($9FDD),HL                         ; $B0AF 22 dd 9f
    LD IX,$9860                           ; $B0B2 dd 21 60 98
    LD (IX+$06),L                         ; $B0B6 dd 75 06
    LD (IX+$07),H                         ; $B0B9 dd 74 07
    INC HL                                ; $B0BC 23
    LD ($A01F),HL                         ; $B0BD 22 1f a0
    LD A,L                                ; $B0C0 7d
    LD ($A0DA),A                          ; $B0C1 32 da a0
    AND A                                 ; $B0C4 a7
    RET                                   ; $B0C5 c9

    ORG $BA20
; CODE: Statement request dispatch without loading next operation args
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

    ORG $C1FD
; CODE: Lower output always redraws plus cursor
    PUSH HL                               ; $C1FD e5
    PUSH BC                               ; $C1FE c5
    PUSH AF                               ; $C1FF f5
    LD A,($C1FB)                          ; $C200 3a fb c1
    LD C,A                                ; $C203 4f
    POP AF                                ; $C204 f1
    PUSH AF                               ; $C205 f5
    LD HL,($C1F6)                         ; $C206 2a f6 c1
    CP $0D                                ; $C209 fe 0d
    JR NZ,$C214                           ; $C20B 20 07
    LD A,$20                              ; $C20D 3e 20
    CALL $C388                            ; $C20F cd 88 c3
    JR $C224                              ; $C212 18 10
    CP $08                                ; $C214 fe 08
    JR Z,$C249                            ; $C216 28 31
    CALL $C240                            ; $C218 cd 40 c2
    CALL $C388                            ; $C21B cd 88 c3
    LD A,($C1F4)                          ; $C21E 3a f4 c1
    DEC A                                 ; $C221 3d
    JR NZ,$C22D                           ; $C222 20 09
    LD L,$E0                              ; $C224 2e e0
    LD C,$02                              ; $C226 0e 02
    CALL $C271                            ; $C228 cd 71 c2
    LD A,$24                              ; $C22B 3e 24
    LD ($C1F4),A                          ; $C22D 32 f4 c1
    LD A,C                                ; $C230 79
    LD ($C1FB),A                          ; $C231 32 fb c1
    LD ($C1F6),HL                         ; $C234 22 f6 c1
    LD A,$2B                              ; $C237 3e 2b
    CALL $C388                            ; $C239 cd 88 c3
    POP AF                                ; $C23C f1
    POP BC                                ; $C23D c1
    POP HL                                ; $C23E e1
    RET                                   ; $C23F c9

    ORG $C306
; CODE: Flash divider cell and wait for key, no MORE counter reset
    PUSH HL                               ; $C306 e5
    LD HL,$5A5F                           ; $C307 21 5f 5a
    SET 7,(HL)                            ; $C30A cb fe
    CALL $C415                            ; $C30C cd 15 c4
    RES 7,(HL)                            ; $C30F cb be
    CALL $C142                            ; $C311 cd 42 c1
    POP HL                                ; $C314 e1
    RET                                   ; $C315 c9

    ORG $CCA7
; CODE: Request dispatch before operation argument resolution
    LD A,($CC0D)                          ; $CCA7 3a 0d cc
    CP $01                                ; $CCAA fe 01
    JR NZ,$CCC7                           ; $CCAC 20 19
    SUB A                                 ; $CCAE 97
    LD ($CC0D),A                          ; $CCAF 32 0d cc
    LD A,(HL)                             ; $CCB2 7e
    CALL $B936                            ; $CCB3 cd 36 b9
    JP C,$CD91                            ; $CCB6 da 91 cd
    JR Z,$CCC7                            ; $CCB9 28 0c
    CALL $C4D1                            ; $CCBB cd d1 c4
    RET NC                                ; $CCBE d0
    CALL $CFB6                            ; $CCBF cd b6 cf
    LD (IX+$05),$02                       ; $CCC2 dd 36 05 02
    RET                                   ; $CCC6 c9

    ORG $CD82
; CODE: Request return and commit
    LD HL,$0001                           ; $CD82 21 01 00
    LD ($A01F),HL                         ; $CD85 22 1f a0
    JP $CE8F                              ; $CD88 c3 8f ce
    LD HL,$0001                           ; $CD8B 21 01 00
    LD ($A01F),HL                         ; $CD8E 22 1f a0
    CALL $D026                            ; $CD91 cd 26 d0
    RET                                   ; $CD94 c9

    ORG $DFCA
; DATA: Basil death DOMAIN header
    DEFB $00,$00                          ; $DFCA 00 00

    ORG $DFCC
; CODE: Basil already present or arriving
    LD HL,$759C                           ; $DFCC 21 9c 75
    LD A,$06                              ; $DFCF 3e 06
    CALL $D237                            ; $DFD1 cd 37 d2
    LD A,($A009)                          ; $DFD4 3a 09 a0
    CP (IX+$0F)                           ; $DFD7 dd be 0f
    JP NZ,$9E74                           ; $DFDA c2 74 9e
    LD HL,$75D2                           ; $DFDD 21 d2 75
    JP $9E74                              ; $DFE0 c3 74 9e

    ORG $E4C9
; DATA: Train movement DOMAIN header
    DEFB $04,$00                          ; $E4C9 04 00

    ORG $E4CB
; CODE: Train departure printed before hiding
    LD HL,$9C56                           ; $E4CB 21 56 9c
    LD A,($A034)                          ; $E4CE 3a 34 a0
    PUSH AF                               ; $E4D1 f5
    CP $02                                ; $E4D2 fe 02
    JR Z,$E4DE                            ; $E4D4 28 08
    CP $03                                ; $E4D6 fe 03
    JR Z,$E4DE                            ; $E4D8 28 04
    CP $04                                ; $E4DA fe 04
    JR NZ,$E4E7                           ; $E4DC 20 09
    LD HL,$7611                           ; $E4DE 21 11 76
    CALL $A59F                            ; $E4E1 cd 9f a5
    LD HL,$9C60                           ; $E4E4 21 60 9c
    LD A,($A036)                          ; $E4E7 3a 36 a0
    PUSH AF                               ; $E4EA f5
    CALL $E4FB                            ; $E4EB cd fb e4
    POP AF                                ; $E4EE f1
    POP BC                                ; $E4EF c1
    CALL $DD0E                            ; $E4F0 cd 0e dd
    LD HL,($DCFF)                         ; $E4F3 2a ff dc
    RES 6,(HL)                            ; $E4F6 cb b6
    OR $01                                ; $E4F8 f6 01
    RET                                   ; $E4FA c9
    JP (HL)                               ; $E4FB e9

    ORG $EF7F
; DATA: Basil east/east, explicit Holmes encounter and terminal DOMAIN nodes
    DEFB $01,$03,$01,$03,$12,$81,$FB,$00  ; $EF7F 01 03 01 03 12 81 fb 00
    DEFB $8C,$EF,$03,$48,$9E              ; $EF87 8c ef 03 48 9e
