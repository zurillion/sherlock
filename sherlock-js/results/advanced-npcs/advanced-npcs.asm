; Research only. DOMAIN headers and mutable saved-room bytes are DATA.
; $9E88 is the mutable immediate caseReady operand of LD A,n, not immutable code.

    ORG $9A99
; DATA: Police routes header
    DEFB $04,$00                          ; $9A99 04 00

    ORG $9A9B
; CODE: Police routes
    CALL $9AA3                            ; $9A9B cd a3 9a
    JP Z,$DC15                            ; $9A9E ca 15 dc
    JR $9AD7                              ; $9AA1 18 34
    LD A,($A00A)                          ; $9AA3 3a 0a a0
    CP $67                                ; $9AA6 fe 67
    JR NZ,$9AB5                           ; $9AA8 20 0b
    LD A,($A034)                          ; $9AAA 3a 34 a0
    CP $32                                ; $9AAD fe 32
    LD L,$70                              ; $9AAF 2e 70
    JR Z,$9AC8                            ; $9AB1 28 15
    XOR A                                 ; $9AB3 af
    RET                                   ; $9AB4 c9
    CP $32                                ; $9AB5 fe 32
    JR NZ,$9AB3                           ; $9AB7 20 fa
    LD A,($A034)                          ; $9AB9 3a 34 a0
    CP $67                                ; $9ABC fe 67
    LD L,$72                              ; $9ABE 2e 72
    JR Z,$9AC8                            ; $9AC0 28 06
    CP $12                                ; $9AC2 fe 12
    JR NZ,$9AB3                           ; $9AC4 20 ed
    LD L,$5E                              ; $9AC6 2e 5e
    OR $01                                ; $9AC8 f6 01
    RET                                   ; $9ACA c9

    ORG $9ACB
; DATA: Fast police travel header
    DEFB $04,$00                          ; $9ACB 04 00

    ORG $9ACD
; CODE: Fast police travel
    CALL $9AA3                            ; $9ACD cd a3 9a
    JP Z,$DC15                            ; $9AD0 ca 15 dc
    LD A,L                                ; $9AD3 7d
    SUB $14                               ; $9AD4 d6 14
    LD L,A                                ; $9AD6 6f
    LD A,$6D                              ; $9AD7 3e 6d
    LD ($E2C6),A                          ; $9AD9 32 c6 e2
    LD A,$69                              ; $9ADC 3e 69
    JP $9B04                              ; $9ADE c3 04 9b

    ORG $9C43
; CODE: Vehicle arrival and visibility
    LD IX,($A017)                         ; $9C43 dd 2a 17 a0
    LD A,(IX+$01)                         ; $9C47 dd 7e 01
    PUSH AF                               ; $9C4A f5
    CALL $9C56                            ; $9C4B cd 56 9c
    LD A,($A034)                          ; $9C4E 3a 34 a0
    LD B,A                                ; $9C51 47
    POP AF                                ; $9C52 f1
    JP $DD0E                              ; $9C53 c3 0e dd
    CALL $D237                            ; $9C56 cd 37 d2
    SET 7,(IX+$05)                        ; $9C59 dd cb 05 fe
    OR $01                                ; $9C5D f6 01
    RET                                   ; $9C5F c9
    CALL $D237                            ; $9C60 cd 37 d2
    RES 7,(IX+$05)                        ; $9C63 dd cb 05 be
    OR $01                                ; $9C67 f6 01
    RET                                   ; $9C69 c9

    ORG $9E48
; DATA: Case companions header
    DEFB $00,$00                          ; $9E48 00 00

    ORG $9E4A
; CODE: Case companions
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
; DATA: Straker knowledge and common terminal header
    DEFB $00,$00                          ; $9E6A 00 00

    ORG $9E6C
; CODE: Straker knowledge and common terminal
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
; DATA: Case-ready terminal header
    DEFB $00,$00                          ; $9E85 00 00

    ORG $9E87
; CODE: Case-ready terminal
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
; DATA: Arrest proofs header
    DEFB $00,$00                          ; $9EA2 00 00

    ORG $9EA4
; CODE: Arrest proofs
    LD HL,$6A33                           ; $9EA4 21 33 6a
    LD IX,$9973                           ; $9EA7 dd 21 73 99
    BIT 1,(IX+$03)                        ; $9EAB dd cb 03 4e
    JR Z,$9E74                            ; $9EAF 28 c3
    LD IX,$9981                           ; $9EB1 dd 21 81 99
    BIT 1,(IX+$03)                        ; $9EB5 dd cb 03 4e
    JR Z,$9E74                            ; $9EB9 28 b9
    LD HL,$6ABD                           ; $9EBB 21 bd 6a
    JR $9E74                              ; $9EBE 18 b4

    ORG $9EC0
; DATA: Daphne saved room
    DEFB $00                              ; $9EC0 00

    ORG $9EC1
; CODE: Daphne rest callback
    LD HL,$9EC0                           ; $9EC1 21 c0 9e
    LD C,$80                              ; $9EC4 0e 80
    LD B,$4A                              ; $9EC6 06 4a
    JR $9ED7                              ; $9EC8 18 0d

    ORG $9ECA
; DATA: Cook saved room
    DEFB $00                              ; $9ECA 00

    ORG $9ECB
; CODE: Cook rest callback
    LD HL,$9ECA                           ; $9ECB 21 ca 9e
    JR $9ED4                              ; $9ECE 18 04

    ORG $9ED0
; DATA: Gardener saved room
    DEFB $00                              ; $9ED0 00

    ORG $9ED1
; CODE: Shared rest and restoration
    LD HL,$9ED0                           ; $9ED1 21 d0 9e
    LD BC,$0000                           ; $9ED4 01 00 00
    LD A,(HL)                             ; $9ED7 7e
    AND A                                 ; $9ED8 a7
    JR Z,$9EF2                            ; $9ED9 28 17
    LD B,A                                ; $9EDB 47
    XOR A                                 ; $9EDC af
    LD DE,$0000                           ; $9EDD 11 00 00
    CALL $9F1E                            ; $9EE0 cd 1e 9f
    LD A,($A036)                          ; $9EE3 3a 36 a0
    LD B,C                                ; $9EE6 41
    LD DE,$0000                           ; $9EE7 11 00 00
    CALL $F1C1                            ; $9EEA cd c1 f1
    SET 6,(IX+$05)                        ; $9EED dd cb 05 f6
    RET                                   ; $9EF1 c9
    LD A,($9FE2)                          ; $9EF2 3a e2 9f
    CP $61                                ; $9EF5 fe 61
    RET Z                                 ; $9EF7 c8
    LD A,($9FE0)                          ; $9EF8 3a e0 9f
    CP $09                                ; $9EFB fe 09
    RET NZ                                ; $9EFD c0
    LD DE,$01F8                           ; $9EFE 11 f8 01
    LD A,$1E                              ; $9F01 3e 1e
    CALL $D2A4                            ; $9F03 cd a4 d2
    ADD A,E                               ; $9F06 83
    LD E,A                                ; $9F07 5f
    LD A,($A00A)                          ; $9F08 3a 0a a0
    CALL $9F1E                            ; $9F0B cd 1e 9f
    LD A,($A036)                          ; $9F0E 3a 36 a0
    LD B,$10                              ; $9F11 06 10
    LD DE,$07F0                           ; $9F13 11 f0 07
    CALL $F1C1                            ; $9F16 cd c1 f1
    RES 6,(IX+$05)                        ; $9F19 dd cb 05 b6
    RET                                   ; $9F1D c9
    LD (HL),A                             ; $9F1E 77
    LD IX,($A017)                         ; $9F1F dd 2a 17 a0
    LD (IX+$0F),B                         ; $9F23 dd 70 0f
    LD (IX+$01),$FF                       ; $9F26 dd 36 01 ff
    LD L,(IY+$06)                         ; $9F2A fd 6e 06
    LD H,(IY+$07)                         ; $9F2D fd 66 07
    ADD HL,DE                             ; $9F30 19
    LD (IY+$06),L                         ; $9F31 fd 75 06
    LD (IY+$07),H                         ; $9F34 fd 74 07
    RET                                   ; $9F37 c9

    ORG $CC29
; CODE: Actor scope projection
    LD A,($A036)                          ; $CC29 3a 36 a0
    CALL $D495                            ; $CC2C cd 95 d4
    LD ($A017),IX                         ; $CC2F dd 22 17 a0
    LD ($A00A),A                          ; $CC33 32 0a a0
    RET                                   ; $CC36 c9

    ORG $D045
; CODE: Player room scope
    LD A,($9860)                          ; $D045 3a 60 98
    CALL $D495                            ; $D048 cd 95 d4
    LD ($A009),A                          ; $D04B 32 09 a0
    RET                                   ; $D04E c9

    ORG $DFCA
; DATA: Basil terminal header
    DEFB $00,$00                          ; $DFCA 00 00

    ORG $DFCC
; CODE: Basil terminal
    LD HL,$759C                           ; $DFCC 21 9c 75
    LD A,$06                              ; $DFCF 3e 06
    CALL $D237                            ; $DFD1 cd 37 d2
    LD A,($A009)                          ; $DFD4 3a 09 a0
    CP (IX+$0F)                           ; $DFD7 dd be 0f
    JP NZ,$9E74                           ; $DFDA c2 74 9e
    LD HL,$75D2                           ; $DFDD 21 d2 75
    JP $9E74                              ; $DFE0 c3 74 9e

    ORG $ED39
; DATA: Revive policeman header
    DEFB $00,$00                          ; $ED39 00 00

    ORG $ED3B
; CODE: Revive policeman
    LD DE,$050B                           ; $ED3B 11 0b 05
    LD HL,$6D6A                           ; $ED3E 21 6a 6d
    LD B,$10                              ; $ED41 06 10
    CALL $F1B2                            ; $ED43 cd b2 f1
    SET 6,(IX+$05)                        ; $ED46 dd cb 05 f6
    RET                                   ; $ED4A c9

    ORG $EF9C
; DATA: Basil scene one header
    DEFB $00,$00                          ; $EF9C 00 00

    ORG $EF9E
; CODE: Basil scene one
    LD HL,$75E8                           ; $EF9E 21 e8 75
    LD A,$01                              ; $EFA1 3e 01
    LD ($5C3C),A                          ; $EFA3 32 3c 5c
    CALL $A59F                            ; $EFA6 cd 9f a5
    OR $01                                ; $EFA9 f6 01
    RET                                   ; $EFAB c9

    ORG $EFAC
; DATA: Basil scene two header
    DEFB $00,$00                          ; $EFAC 00 00

    ORG $EFAE
; CODE: Basil scene two
    LD HL,$7603                           ; $EFAE 21 03 76
    JR $EFA1                              ; $EFB1 18 ee

    ORG $EFB3
; DATA: Sleeping descriptor header
    DEFB $00,$00                          ; $EFB3 00 00

    ORG $EFB5
; CODE: Sleeping descriptor
    LD DE,$07F0                           ; $EFB5 11 f0 07
    LD B,$10                              ; $EFB8 06 10
    LD A,($A036)                          ; $EFBA 3a 36 a0
    CALL $F1C1                            ; $EFBD cd c1 f1
    RES 6,(IX+$05)                        ; $EFC0 dd cb 05 b6
    OR $01                                ; $EFC4 f6 01
    RET                                   ; $EFC6 c9

    ORG $EFC7
; DATA: Basil night branch header
    DEFB $00,$00                          ; $EFC7 00 00

    ORG $EFC9
; CODE: Basil night branch
    LD A,($A009)                          ; $EFC9 3a 09 a0
    CP $23                                ; $EFCC fe 23
    JR Z,$EFE6                            ; $EFCE 28 16
    CP $21                                ; $EFD0 fe 21
    JR Z,$EFE6                            ; $EFD2 28 12
    CP $22                                ; $EFD4 fe 22
    JR Z,$EFE6                            ; $EFD6 28 0e
    CP $26                                ; $EFD8 fe 26
    JR Z,$EFE6                            ; $EFDA 28 0a
    CP $25                                ; $EFDC fe 25
    JR Z,$EFE6                            ; $EFDE 28 06
    CP $24                                ; $EFE0 fe 24
    JR Z,$EFE6                            ; $EFE2 28 02
    CP $27                                ; $EFE4 fe 27
    JP Z,$DFCC                            ; $EFE6 ca cc df
    LD DE,$0000                           ; $EFE9 11 00 00
    LD B,$80                              ; $EFEC 06 80
    CALL $EFBA                            ; $EFEE cd ba ef
    SET 6,(IX+$05)                        ; $EFF1 dd cb 05 f6
    RET                                   ; $EFF5 c9

    ORG $F103
; DATA: Policeman knowledge header
    DEFB $00,$00                          ; $F103 00 00

    ORG $F105
; CODE: Policeman knowledge
    LD IX,$996F                           ; $F105 dd 21 6f 99
    SET 1,(IX+$03)                        ; $F109 dd cb 03 ce
    OR $01                                ; $F10D f6 01
    RET                                   ; $F10F c9

    ORG $F1A8
; DATA: Major and descriptor helper header
    DEFB $00,$00                          ; $F1A8 00 00

    ORG $F1AA
; CODE: Major and descriptor helper
    LD HL,$6D5D                           ; $F1AA 21 5d 6d
    LD DE,$0910                           ; $F1AD 11 10 09
    LD B,$20                              ; $F1B0 06 20
    LD A,$0B                              ; $F1B2 3e 0b
    CALL $F1C1                            ; $F1B4 cd c1 f1
    RES 6,(IX+$05)                        ; $F1B7 dd cb 05 b6
    CALL $A59F                            ; $F1BB cd 9f a5
    OR $01                                ; $F1BE f6 01
    RET                                   ; $F1C0 c9
    CALL $D237                            ; $F1C1 cd 37 d2
    LD (IX+$09),E                         ; $F1C4 dd 73 09
    LD (IX+$0A),D                         ; $F1C7 dd 72 0a
    LD A,(IX+$08)                         ; $F1CA dd 7e 08
    AND $0F                               ; $F1CD e6 0f
    OR B                                  ; $F1CF b0
    LD (IX+$08),A                         ; $F1D0 dd 77 08
    OR $01                                ; $F1D3 f6 01
    RET                                   ; $F1D5 c9
