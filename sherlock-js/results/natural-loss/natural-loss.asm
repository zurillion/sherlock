; Offline source evidence. DOMAIN headers and operations are DATA.

    ORG $9DFF
; CODE: Lestrade encounter with Holmes and Straker
    LD C,$04                              ; $9DFF 0e 04
    CALL $9CCE                            ; $9E01 cd ce 9c
    JR NZ,$9D95                           ; $9E04 20 8f
    LD C,$00                              ; $9E06 0e 00
    CALL $9CCE                            ; $9E08 cd ce 9c
    JR NZ,$9D95                           ; $9E0B 20 88
    LD A,$04                              ; $9E0D 3e 04
    LD ($A034),A                          ; $9E0F 32 34 a0
    LD A,$01                              ; $9E12 3e 01
    LD ($9D90),A                          ; $9E14 32 90 9d
    LD A,$5C                              ; $9E17 3e 5c
    CALL $D224                            ; $9E19 cd 24 d2
    LD (IX+$0A),$00                       ; $9E1C dd 36 0a 00
    LD A,$3E                              ; $9E20 3e 3e
    CALL $D224                            ; $9E22 cd 24 d2
    LD (IX+$0A),$00                       ; $9E25 dd 36 0a 00
    LD HL,$9D95                           ; $9E29 21 95 9d
    LD ($9C86),HL                         ; $9E2C 22 86 9c
    LD A,$01                              ; $9E2F 3e 01
    LD ($9D92),A                          ; $9E31 32 92 9d
    LD A,($9D91)                          ; $9E34 3a 91 9d
    AND A                                 ; $9E37 a7
    LD HL,$7207                           ; $9E38 21 07 72
    JR NZ,$9E44                           ; $9E3B 20 07
    INC A                                 ; $9E3D 3c
    LD ($9D91),A                          ; $9E3E 32 91 9d
    LD HL,$7224                           ; $9E41 21 24 72
    CALL $A59F                            ; $9E44 cd 9f a5
    RET                                   ; $9E47 c9

    ORG $9E6A
; DATA: Early loss rule header
    DEFB $00,$00                          ; $9E6A 00 00

    ORG $9E6C
; CODE: Straker gate and common terminal
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
; DATA: Case readiness header
    DEFB $00,$00                          ; $9E85 00 00

    ORG $9E87
; CODE: Unready case: arrest and alternative reports
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

    ORG $A419
; CODE: Money writes raw digits, uppercase D and shilling slash/dash even off-stage
    PUSH BC                               ; $A419 c5
    RES 7,H                               ; $A41A cb bc
    SLA L                                 ; $A41C cb 25
    SRL H                                 ; $A41E cb 3c
    RR L                                  ; $A420 cb 1d
    LD A,$20                              ; $A422 3e 20
    CALL $A9B7                            ; $A424 cd b7 a9
    LD DE,$00F0                           ; $A427 11 f0 00
    CALL $A476                            ; $A42A cd 76 a4
    AND A                                 ; $A42D a7
    JR Z,$A442                            ; $A42E 28 12
    LD B,A                                ; $A430 47
    LD A,$60                              ; $A431 3e 60
    CALL $A9B7                            ; $A433 cd b7 a9
    CALL $A490                            ; $A436 cd 90 a4
    LD A,L                                ; $A439 7d
    OR H                                  ; $A43A b4
    JR Z,$A467                            ; $A43B 28 2a
    LD A,$20                              ; $A43D 3e 20
    CALL $A9B7                            ; $A43F cd b7 a9
    LD DE,$000C                           ; $A442 11 0c 00
    CALL $A476                            ; $A445 cd 76 a4
    AND A                                 ; $A448 a7
    JR Z,$A469                            ; $A449 28 1e
    LD B,A                                ; $A44B 47
    CALL $A490                            ; $A44C cd 90 a4
    LD A,$2F                              ; $A44F 3e 2f
    CALL $A9B7                            ; $A451 cd b7 a9
    LD A,L                                ; $A454 7d
    AND A                                 ; $A455 a7
    LD B,A                                ; $A456 47
    JR Z,$A45E                            ; $A457 28 05
    CALL $A490                            ; $A459 cd 90 a4
    JR $A467                              ; $A45C 18 09
    LD A,$2D                              ; $A45E 3e 2d
    CALL $A9B7                            ; $A460 cd b7 a9
    XOR A                                 ; $A463 af
    LD ($A026),A                          ; $A464 32 26 a0
    POP BC                                ; $A467 c1
    RET                                   ; $A468 c9
    LD B,L                                ; $A469 45
    CALL $A490                            ; $A46A cd 90 a4
    LD A,$44                              ; $A46D 3e 44
    CALL $A9B7                            ; $A46F cd b7 a9
    LD A,$2E                              ; $A472 3e 2e
    JR $A460                              ; $A474 18 ea

    ORG $A5AD
; CODE: Preflight text clears announcement mode
    LD A,($A00B)                          ; $A5AD 3a 0b a0
    AND A                                 ; $A5B0 a7
    JR NZ,$A5B6                           ; $A5B1 20 03
    LD ($A00C),A                          ; $A5B3 32 0c a0

    ORG $A9B5
; DATA: Word workspace cursor
    DEFB $0B,$5C                          ; $A9B5 0b 5c

    ORG $A9B7
; CODE: Append, backspace, flush and pointer reset
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0
    AND A                                 ; $A9BB a7
    JR NZ,$AA10                           ; $A9BC 20 52
    POP AF                                ; $A9BE f1
    PUSH AF                               ; $A9BF f5
    PUSH HL                               ; $A9C0 e5
    LD HL,($A9B5)                         ; $A9C1 2a b5 a9
    CP $20                                ; $A9C4 fe 20
    JR Z,$A9DF                            ; $A9C6 28 17
    CP $0D                                ; $A9C8 fe 0d
    JR Z,$A9DF                            ; $A9CA 28 13
    CP $22                                ; $A9CC fe 22
    JR Z,$A9DF                            ; $A9CE 28 0f
    CP $08                                ; $A9D0 fe 08
    JR NZ,$A9D7                           ; $A9D2 20 03
    DEC HL                                ; $A9D4 2b
    JR $A9D9                              ; $A9D5 18 02
    LD (HL),A                             ; $A9D7 77
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9
    PUSH DE                               ; $A9DF d5
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0
    POP DE                                ; $AA0B d1
    POP HL                                ; $AA0C e1
    POP AF                                ; $AA0D f1
    JR $AA14                              ; $AA0E 18 04
    POP AF                                ; $AA10 f1
    JP $C1E1                              ; $AA11 c3 e1 c1

    ORG $AB4C
; CODE: Nominal copy followed by another nominal attempt
    LD HL,($A029)                         ; $AB4C 2a 29 a0
    LD ($A02B),HL                         ; $AB4F 22 2b a0
    CALL $AC24                            ; $AB52 cd 24 ac
    JR C,$AB8E                            ; $AB55 38 37
    JR NZ,$AB60                           ; $AB57 20 07
    CALL $ACA6                            ; $AB59 cd a6 ac
    JR Z,$AB8E                            ; $AB5C 28 30
    JR $AB4C                              ; $AB5E 18 ec

    ORG $AC24
; CODE: Clear ten-byte nominal workspace
    LD HL,$AAA8                           ; $AC24 21 a8 aa
    LD B,$0A                              ; $AC27 06 0a
    CALL $A2AB                            ; $AC29 cd ab a2
    LD A,E                                ; $AC2C 7b
    OR $34                                ; $AC2D f6 34
    LD E,A                                ; $AC2F 5f

    ORG $AC84
; CODE: Noun store and relation/qualifier slots
    LD ($AAAC),BC                         ; $AC84 ed 43 ac aa
    CALL $AE7F                            ; $AC88 cd 7f ae
    AND A                                 ; $AC8B a7
    BIT 5,E                               ; $AC8C cb 6b
    RET                                   ; $AC8E c9
    LD HL,$AAA8                           ; $AC8F 21 a8 aa
    JR $AC97                              ; $AC92 18 03
    LD HL,$AAAE                           ; $AC94 21 ae aa
    LD A,(HL)                             ; $AC97 7e
    INC HL                                ; $AC98 23
    OR (HL)                               ; $AC99 b6
    JR Z,$ACA1                            ; $AC9A 28 05
    INC HL                                ; $AC9C 23
    LD A,(HL)                             ; $AC9D 7e
    INC HL                                ; $AC9E 23
    OR (HL)                               ; $AC9F b6
    RET NZ                                ; $ACA0 c0
    LD (HL),B                             ; $ACA1 70
    DEC HL                                ; $ACA2 2b
    LD (HL),C                             ; $ACA3 71
    XOR A                                 ; $ACA4 af
    RET                                   ; $ACA5 c9

    ORG $C4E8
; CODE: Action verification mode
    XOR A                                 ; $C4E8 af
    LD ($A00B),A                          ; $C4E9 32 0b a0

    ORG $C53A
; CODE: Action execution mode
    LD A,$01                              ; $C53A 3e 01
    LD ($A00B),A                          ; $C53C 32 0b a0

    ORG $C59A
; CODE: Rule verification mode
    XOR A                                 ; $C59A af
    LD ($A00B),A                          ; $C59B 32 0b a0

    ORG $C5F4
; CODE: Rule execution mode
    LD A,$01                              ; $C5F4 3e 01
    LD ($A00B),A                          ; $C5F6 32 0b a0

    ORG $C929
; CODE: Actor/object/global action lookup and no-rule failure
    CALL $C8EF                            ; $C929 cd ef c8
    LD A,($A034)                          ; $C92C 3a 34 a0
    CP $FE                                ; $C92F fe fe
    JR NC,$C972                           ; $C931 30 3f
    LD IX,($A017)                         ; $C933 dd 2a 17 a0
    BIT 6,(IX+$05)                        ; $C937 dd cb 05 76
    JR Z,$C94D                            ; $C93B 28 10
    XOR A                                 ; $C93D af
    CALL $D1DC                            ; $C93E cd dc d1
    JR NC,$C94D                           ; $C941 30 0a
    LD A,($A033)                          ; $C943 3a 33 a0
    CALL $D349                            ; $C946 cd 49 d3
    CP $FF                                ; $C949 fe ff
    JR NZ,$C960                           ; $C94B 20 13
    LD A,($A00F)                          ; $C94D 3a 0f a0
    CP $07                                ; $C950 fe 07
    JR C,$C972                            ; $C952 38 1e
    LD IX,($A013)                         ; $C954 dd 2a 13 a0
    LD A,($A033)                          ; $C958 3a 33 a0
    CALL $D1DC                            ; $C95B cd dc d1
    JR NC,$C972                           ; $C95E 30 12
    LD A,(IX+$01)                         ; $C960 dd 7e 01
    LD E,A                                ; $C963 5f
    LD D,$00                              ; $C964 16 00
    LD HL,$AA71                           ; $C966 21 71 aa
    DEC DE                                ; $C969 1b
    ADD HL,DE                             ; $C96A 19
    ADD HL,DE                             ; $C96B 19
    LD E,(HL)                             ; $C96C 5e
    INC HL                                ; $C96D 23
    LD D,(HL)                             ; $C96E 56
    EX DE,HL                              ; $C96F eb
    JR $C996                              ; $C970 18 24
    LD A,($A033)                          ; $C972 3a 33 a0
    LD IX,$9F38                           ; $C975 dd 21 38 9f
    CALL $D34E                            ; $C979 cd 4e d3
    CP $FF                                ; $C97C fe ff
    JP Z,$DC15                            ; $C97E ca 15 dc
    LD L,(IX+$01)                         ; $C981 dd 6e 01
    LD H,(IX+$02)                         ; $C984 dd 66 02
    JR $C996                              ; $C987 18 0d

    ORG $CA35
; CODE: Successful announcement mode
    LD A,$01                              ; $CA35 3e 01
    LD ($A00C),A                          ; $CA37 32 0c a0
    CALL $CA76                            ; $CA3A cd 76 ca

    ORG $CC0B
; DATA: Current visit failure/request flags
    DEFB $00,$00,$00                      ; $CC0B 00 00 00

    ORG $CC37
; CODE: Prepare current visit flags and visibility
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

    ORG $E932
; DATA: Lestrade DOMAIN gates, signal waits and relocation
    DEFB $03,$6A,$9E,$41,$04,$41,$01,$43  ; $E932 03 6a 9e 41 04 41 01 43
    DEFB $28,$EB,$0F,$C2,$81,$FB,$00,$49  ; $E93A 28 eb 0f c2 81 fb 00 49
    DEFB $E9,$D9,$07,$51,$E9,$3C,$E9,$45  ; $E942 e9 d9 07 51 e9 3c e9 45
    DEFB $00,$20,$70,$59,$07,$4D,$E9,$42  ; $E94A 00 20 70 59 07 4d e9 42
    DEFB $80,$FB,$00,$82,$81,$00,$07,$61  ; $E952 80 fb 00 82 81 00 07 61
    DEFB $E9,$12,$88,$01,$FF,$55,$E9,$02  ; $E95A e9 12 88 01 ff 55 e9 02
    DEFB $80,$FB,$0C,$52,$81,$FB,$07,$65  ; $E962 80 fb 0c 52 81 fb 07 65
    DEFB $E9,$03,$85,$9E                  ; $E96A e9 03 85 9e

    ORG $F0A4
; DATA: Ffoulkes DOMAIN night programme and signals
    DEFB $12,$88,$17,$FF,$A4,$F0,$17,$98  ; $F0A4 12 88 17 ff a4 f0 17 98
    DEFB $F1,$14,$FF,$AA,$F0,$02,$80,$FB  ; $F0AC f1 14 ff aa f0 02 80 fb
    DEFB $28,$42,$87,$30,$FF,$41,$09,$42  ; $F0B4 28 42 87 30 ff 41 09 42
    DEFB $24,$30,$FF,$41,$05,$41,$08,$41  ; $F0BC 24 30 ff 41 05 41 08 41
    DEFB $0A,$42,$87,$30,$FF,$47,$A4,$EB  ; $F0C4 0a 42 87 30 ff 47 a4 eb
    DEFB $FF,$0C,$41,$01,$08,$02,$0F,$82  ; $F0CC ff 0c 41 01 08 02 0f 82
    DEFB $81,$00,$FB,$E2,$F0,$52,$88,$01  ; $F0D4 81 00 fb e2 f0 52 88 01
    DEFB $FF,$D2,$F0,$0E,$EE,$F0,$45,$00  ; $F0DC ff d2 f0 0e ee f0 45 00
    DEFB $78,$6C,$43,$03,$F1,$07,$BE,$DD  ; $F0E4 78 6c 43 03 f1 07 be dd
    DEFB $04,$FF,$17,$98,$F1,$14,$FF,$EE  ; $F0EC 04 ff 17 98 f1 14 ff ee
    DEFB $F0,$01,$02,$59,$02,$F7,$F0,$42  ; $F0F4 f0 01 02 59 02 f7 f0 42
    DEFB $80,$FB,$00                      ; $F0FC 80 fb 00
