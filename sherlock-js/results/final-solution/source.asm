; Offline source evidence; headers and DOMAIN operations are DATA.

    ORG $A00D
; DATA: Default word reference, immutable payload
    DEFB $00,$00                          ; $A00D 00 00

    ORG $A2E4
; CODE: Darkness gate for failed-action announcements
    LD A,$01                              ; $A2E4 3e 01
    LD ($A2AA),A                          ; $A2E6 32 aa a2
    PUSH IY                               ; $A2E9 fd e5
    PUSH BC                               ; $A2EB c5
    PUSH IX                               ; $A2EC dd e5
    PUSH HL                               ; $A2EE e5
    PUSH DE                               ; $A2EF d5
    LD A,($A033)                          ; $A2F0 3a 33 a0
    LD ($A35D),A                          ; $A2F3 32 5d a3
    LD HL,($A034)                         ; $A2F6 2a 34 a0
    LD ($A35E),HL                         ; $A2F9 22 5e a3
    LD A,($A00C)                          ; $A2FC 3a 0c a0
    LD B,A                                ; $A2FF 47
    AND A                                 ; $A300 a7

    ORG $C374
; CODE: Row clear and glyph stack residue
    CALL $C388                            ; $C374 cd 88 c3
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9
    EX DE,HL                              ; $C37D eb
    LD A,L                                ; $C37E 7d
    ADD A,$20                             ; $C37F c6 20
    LD L,A                                ; $C381 6f
    RET NC                                ; $C382 d0
    LD A,H                                ; $C383 7c
    ADD A,$08                             ; $C384 c6 08
    LD H,A                                ; $C386 67
    RET                                   ; $C387 c9
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5
    LD L,A                                ; $C38C 6f
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5
    PUSH AF                               ; $C39D f5
    DEC C                                 ; $C39E 0d
    INC C                                 ; $C39F 0c
    LD B,$FF                              ; $C3A0 06 ff
    JR Z,$C3AB                            ; $C3A2 28 07
    SRL A                                 ; $C3A4 cb 3f
    SRL B                                 ; $C3A6 cb 38
    DEC C                                 ; $C3A8 0d
    JR NZ,$C3A4                           ; $C3A9 20 f9
    LD C,A                                ; $C3AB 4f
    LD A,B                                ; $C3AC 78
    CPL                                   ; $C3AD 2f
    AND (HL)                              ; $C3AE a6
    OR C                                  ; $C3AF b1
    LD (HL),A                             ; $C3B0 77
    POP AF                                ; $C3B1 f1
    POP BC                                ; $C3B2 c1
    DEC C                                 ; $C3B3 0d
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5
    PUSH AF                               ; $C3B8 f5
    LD A,$08                              ; $C3B9 3e 08
    SUB C                                 ; $C3BB 91
    LD C,A                                ; $C3BC 4f
    POP AF                                ; $C3BD f1
    LD B,$FF                              ; $C3BE 06 ff

    ORG $CC0C
; DATA: Padding between failure count and request flag
    DEFB $00                              ; $CC0C 00

    ORG $CC29
; CODE: Output perception selection
    LD A,($A036)                          ; $CC29 3a 36 a0
    CALL $D495                            ; $CC2C cd 95 d4
    LD ($A017),IX                         ; $CC2F dd 22 17 a0
    LD ($A00A),A                          ; $CC33 32 0a a0
    RET                                   ; $CC36 c9
    PUSH AF                               ; $CC37 f5
    XOR A                                 ; $CC38 af
    LD ($CC0B),A                          ; $CC39 32 0b cc
    POP AF                                ; $CC3C f1
    CALL $CC0E                            ; $CC3D cd 0e cc
    CP $FF                                ; $CC40 fe ff
    LD HL,$0001                           ; $CC42 21 01 00
    JP Z,$CC74                            ; $CC45 ca 74 cc
    LD ($9FDB),IY                         ; $CC48 fd 22 db 9f
    LD ($A036),A                          ; $CC4C 32 36 a0
    CALL $B91F                            ; $CC4F cd 1f b9
    LD A,$00                              ; $CC52 3e 00
    JR NZ,$CC57                           ; $CC54 20 01
    INC A                                 ; $CC56 3c
    LD ($CC0D),A                          ; $CC57 32 0d cc
    CALL $CC29                            ; $CC5A cd 29 cc
    CALL $D045                            ; $CC5D cd 45 d0
    SUB A                                 ; $CC60 97
    LD ($5C3C),A                          ; $CC61 32 3c 5c
    LD A,($9860)                          ; $CC64 3a 60 98
    CALL $C821                            ; $CC67 cd 21 c8
    JR Z,$CC71                            ; $CC6A 28 05
    LD A,$01                              ; $CC6C 3e 01
    LD ($5C3C),A                          ; $CC6E 32 3c 5c
    LD HL,$0000                           ; $CC71 21 00 00
    LD ($A01F),HL                         ; $CC74 22 1f a0
    RET                                   ; $CC77 c9

    ORG $E03A
; CODE: General actor identity, direct possessions and context transfer
    LD C,A                                ; $E03A 4f
    LD A,($A036)                          ; $E03B 3a 36 a0
    CALL $CC0E                            ; $E03E cd 0e cc
    LD (IY+$00),C                         ; $E041 fd 71 00
    LD IY,($A017)                         ; $E044 fd 2a 17 a0
    LD A,C                                ; $E048 79
    CALL $D237                            ; $E049 cd 37 d2
    LD ($A017),IX                         ; $E04C dd 22 17 a0
    LD A,(IY+$01)                         ; $E050 fd 7e 01
    LD (IX+$01),A                         ; $E053 dd 77 01
    LD (IY+$01),$FF                       ; $E056 fd 36 01 ff
    LD A,(IY+$0F)                         ; $E05A fd 7e 0f
    LD (IX+$0F),A                         ; $E05D dd 77 0f
    LD (IY+$0F),$00                       ; $E060 fd 36 0f 00
    LD B,$00                              ; $E064 06 00
    INC B                                 ; $E066 04
    LD A,B                                ; $E067 78
    CP $6E                                ; $E068 fe 6e
    JR Z,$E07C                            ; $E06A 28 10
    CALL $D237                            ; $E06C cd 37 d2
    LD A,($A036)                          ; $E06F 3a 36 a0
    CP (IX+$01)                           ; $E072 dd be 01
    JR NZ,$E066                           ; $E075 20 ef
    LD (IX+$01),C                         ; $E077 dd 71 01
    JR $E066                              ; $E07A 18 ea
    CALL $CFB6                            ; $E07C cd b6 cf
    JR Z,$E086                            ; $E07F 28 05
    LD (IX+$00),C                         ; $E081 dd 71 00
    JR $E07C                              ; $E084 18 f6
    LD A,C                                ; $E086 79
    LD ($A036),A                          ; $E087 32 36 a0
    OR $01                                ; $E08A f6 01
    RET                                   ; $E08C c9
    ADC A,L                               ; $E08D 8d
    INC B                                 ; $E08E 04

    ORG $E17B
; DATA: Mrs Jones rule header and DOMAIN programme
    DEFB $8D,$07,$07,$88,$E1,$FD,$FC,$07  ; $E17B 8d 07 07 88 e1 fd fc 07
    DEFB $D6,$E1,$FD,$FC,$0B              ; $E183 d6 e1 fd fc 0b

    ORG $E188
; DATA: Evidence rule header
    DEFB $0D,$07                          ; $E188 0d 07

    ORG $E18A
; CODE: Topic 16/17/67 sets fact 9996 bit 1
    LD A,($A035)                          ; $E18A 3a 35 a0
    CP $10                                ; $E18D fe 10
    JR Z,$E199                            ; $E18F 28 08
    CP $43                                ; $E191 fe 43
    JR Z,$E199                            ; $E193 28 04
    CP $11                                ; $E195 fe 11
    JR NZ,$E1D3                           ; $E197 20 3a
    LD IX,$9993                           ; $E199 dd 21 93 99
    SET 1,(IX+$03)                        ; $E19D dd cb 03 ce
    JR $E1D3                              ; $E1A1 18 30

    ORG $E1A3
; DATA: Tricia rule header and conditional DOMAIN programme
    DEFB $8D,$07,$17,$B2,$E1,$FF,$FC,$B1  ; $E1A3 8d 07 17 b2 e1 ff fc b1
    DEFB $E1,$07,$D6,$E1,$FD,$FC,$0B      ; $E1AB e1 07 d6 e1 fd fc 0b

    ORG $E1B2
; DATA: Identity reveal rule header
    DEFB $00,$07                          ; $E1B2 00 07

    ORG $E1B4
; CODE: Clothes perception, NPC identity change, confession flag
    LD A,($A035)                          ; $E1B4 3a 35 a0
    CP $43                                ; $E1B7 fe 43
    JR NZ,$E1D3                           ; $E1B9 20 18
    CALL $C821                            ; $E1BB cd 21 c8
    JR NZ,$E1C6                           ; $E1BE 20 06
    CALL $E1FC                            ; $E1C0 cd fc e1
    JP $DC15                              ; $E1C3 c3 15 dc
    LD A,$5F                              ; $E1C6 3e 5f
    CALL $E03A                            ; $E1C8 cd 3a e0
    LD IX,$998F                           ; $E1CB dd 21 8f 99
    SET 1,(IX+$03)                        ; $E1CF dd cb 03 ce
    OR $01                                ; $E1D3 f6 01
    RET                                   ; $E1D5 c9

    ORG $E1D6
; DATA: Default TELL header
    DEFB $0D,$17                          ; $E1D6 0d 17

    ORG $E1D8
; CODE: Default topic lookup and spoken reply
    LD A,($A036)                          ; $E1D8 3a 36 a0
    CALL $E207                            ; $E1DB cd 07 e2
    JR Z,$E1FC                            ; $E1DE 28 1c
    INC IX                                ; $E1E0 dd 23
    LD A,($A035)                          ; $E1E2 3a 35 a0
    CALL $E201                            ; $E1E5 cd 01 e2
    JR Z,$E1FC                            ; $E1E8 28 12
    LD L,(IX+$01)                         ; $E1EA dd 6e 01
    LD H,(IX+$02)                         ; $E1ED dd 66 02
    PUSH AF                               ; $E1F0 f5
    PUSH HL                               ; $E1F1 e5
    LD HL,$6830                           ; $E1F2 21 30 68
    CALL $A59F                            ; $E1F5 cd 9f a5
    POP AF                                ; $E1F8 f1
    OR $01                                ; $E1F9 f6 01
    RET                                   ; $E1FB c9
    LD HL,$761D                           ; $E1FC 21 1d 76
    JR $E1F0                              ; $E1FF 18 ef
