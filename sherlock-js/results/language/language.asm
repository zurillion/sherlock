; Offline research only. Headers, tables and working cells are DATA.

    ORG $AAB2
; CODE: Grammar, coordination, continuation and ordinary-tail list traversal
    XOR A                                 ; $AAB2 af
    LD ($A01A),A                          ; $AAB3 32 1a a0
    LD ($A012),A                          ; $AAB6 32 12 a0
    LD E,$FF                              ; $AAB9 1e ff
    LD D,$C0                              ; $AABB 16 c0
    LD A,E                                ; $AABD 7b
    OR $C7                                ; $AABE f6 c7
    LD E,A                                ; $AAC0 5f
    CALL $AE6A                            ; $AAC1 cd 6a ae
    LD A,($A01B)                          ; $AAC4 3a 1b a0
    AND A                                 ; $AAC7 a7
    JR Z,$AAD1                            ; $AAC8 28 07
    LD A,$01                              ; $AACA 3e 01
    LD ($A024),A                          ; $AACC 32 24 a0
    RES 3,E                               ; $AACF cb 9b
    PUSH DE                               ; $AAD1 d5
    LD A,($A024)                          ; $AAD2 3a 24 a0
    AND A                                 ; $AAD5 a7
    JR NZ,$AB11                           ; $AAD6 20 39
    LD ($AAA7),A                          ; $AAD8 32 a7 aa
    LD HL,($A02B)                         ; $AADB 2a 2b a0
    PUSH HL                               ; $AADE e5
    CALL $AC24                            ; $AADF cd 24 ac
    JR NZ,$AB08                           ; $AAE2 20 24
    LD A,($AAA7)                          ; $AAE4 3a a7 aa
    AND A                                 ; $AAE7 a7
    JR NZ,$AB08                           ; $AAE8 20 1e
    LD A,$02                              ; $AAEA 3e 02
    LD ($A024),A                          ; $AAEC 32 24 a0
    POP HL                                ; $AAEF e1
    PUSH IY                               ; $AAF0 fd e5
    POP HL                                ; $AAF2 e1
    LD DE,$0018                           ; $AAF3 11 18 00
    ADD HL,DE                             ; $AAF6 19
    LD DE,$AAAC                           ; $AAF7 11 ac aa
    EX DE,HL                              ; $AAFA eb
    LD BC,$0006                           ; $AAFB 01 06 00
    LDIR                                  ; $AAFE ed b0
    LD HL,($A029)                         ; $AB00 2a 29 a0
    LD ($A02B),HL                         ; $AB03 22 2b a0
    JR $AB11                              ; $AB06 18 09
    LD A,$01                              ; $AB08 3e 01
    LD ($A024),A                          ; $AB0A 32 24 a0
    POP HL                                ; $AB0D e1
    LD ($A02B),HL                         ; $AB0E 22 2b a0
    POP DE                                ; $AB11 d1
    XOR A                                 ; $AB12 af
    LD ($AAA7),A                          ; $AB13 32 a7 aa
    CALL $AB91                            ; $AB16 cd 91 ab
    JR C,$AB8E                            ; $AB19 38 73
    JR Z,$AB47                            ; $AB1B 28 2a
    CP $90                                ; $AB1D fe 90
    JP Z,$AFB3                            ; $AB1F ca b3 af
    CP $A0                                ; $AB22 fe a0
    JP Z,$ACCC                            ; $AB24 ca cc ac
    BIT 3,E                               ; $AB27 cb 5b
    JR Z,$AB4C                            ; $AB29 28 21
    LD A,($A012)                          ; $AB2B 3a 12 a0
    AND A                                 ; $AB2E a7
    JR NZ,$AB8E                           ; $AB2F 20 5d
    LD A,($A01B)                          ; $AB31 3a 1b a0
    AND A                                 ; $AB34 a7
    JR NZ,$AB4C                           ; $AB35 20 15
    LD A,($A02D)                          ; $AB37 3a 2d a0
    CP $C0                                ; $AB3A fe c0
    JR NZ,$AB8E                           ; $AB3C 20 50
    LD A,$B0                              ; $AB3E 3e b0
    CP D                                  ; $AB40 ba
    JR NZ,$AB8E                           ; $AB41 20 4b
    LD A,$02                              ; $AB43 3e 02
    AND A                                 ; $AB45 a7
    RET                                   ; $AB46 c9
    BIT 3,E                               ; $AB47 cb 5b
    JP Z,$ACFB                            ; $AB49 ca fb ac
    LD HL,($A029)                         ; $AB4C 2a 29 a0
    LD ($A02B),HL                         ; $AB4F 22 2b a0
    CALL $AC24                            ; $AB52 cd 24 ac
    JR C,$AB8E                            ; $AB55 38 37
    JR NZ,$AB60                           ; $AB57 20 07
    CALL $ACA6                            ; $AB59 cd a6 ac
    JR Z,$AB8E                            ; $AB5C 28 30
    JR $AB4C                              ; $AB5E 18 ec
    CP $B0                                ; $AB60 fe b0
    JP Z,$AD57                            ; $AB62 ca 57 ad
    CP $A0                                ; $AB65 fe a0
    JP Z,$ACCC                            ; $AB67 ca cc ac
    CP $90                                ; $AB6A fe 90
    JP Z,$AFB3                            ; $AB6C ca b3 af
    LD HL,($A029)                         ; $AB6F 2a 29 a0
    LD ($A02B),HL                         ; $AB72 22 2b a0
    LD A,($A024)                          ; $AB75 3a 24 a0
    CP $02                                ; $AB78 fe 02
    JR NZ,$AB8E                           ; $AB7A 20 12
    CALL $ABF3                            ; $AB7C cd f3 ab
    JR C,$AB8E                            ; $AB7F 38 0d
    JR NZ,$AB8E                           ; $AB81 20 0b
    LD HL,($A029)                         ; $AB83 2a 29 a0
    LD ($A02B),HL                         ; $AB86 22 2b a0
    LD D,$A0                              ; $AB89 16 a0
    JP $ACCC                              ; $AB8B c3 cc ac
    JP $AF67                              ; $AB8E c3 67 af
    LD A,($A024)                          ; $AB91 3a 24 a0
    CP $02                                ; $AB94 fe 02
    JR Z,$ABF3                            ; $AB96 28 5b
    LD A,E                                ; $AB98 7b
    OR $07                                ; $AB99 f6 07
    LD E,A                                ; $AB9B 5f
    CALL $AE7F                            ; $AB9C cd 7f ae
    CP $E0                                ; $AB9F fe e0
    JR Z,$AB9C                            ; $ABA1 28 f9
    CP $30                                ; $ABA3 fe 30
    JR NZ,$ABB7                           ; $ABA5 20 10
    BIT 1,E                               ; $ABA7 cb 4b
    JR Z,$ABB5                            ; $ABA9 28 0a
    RES 1,E                               ; $ABAB cb 8b
    LD (IY+$00),C                         ; $ABAD fd 71 00
    LD (IY+$01),B                         ; $ABB0 fd 70 01
    JR $AB9C                              ; $ABB3 18 e7
    SCF                                   ; $ABB5 37
    RET                                   ; $ABB6 c9
    CP $00                                ; $ABB7 fe 00
    JR NZ,$ABC9                           ; $ABB9 20 0e
    BIT 2,E                               ; $ABBB cb 53
    JR Z,$ABB5                            ; $ABBD 28 f6
    RES 2,E                               ; $ABBF cb 93
    LD (IY+$02),C                         ; $ABC1 fd 71 02
    LD (IY+$03),B                         ; $ABC4 fd 70 03
    JR $AB9C                              ; $ABC7 18 d3
    CP $40                                ; $ABC9 fe 40
    JR NZ,$ABD1                           ; $ABCB 20 04
    RES 0,E                               ; $ABCD cb 83
    JR $ABA7                              ; $ABCF 18 d6
    CP $20                                ; $ABD1 fe 20
    JR NZ,$ABEF                           ; $ABD3 20 1a
    BIT 1,E                               ; $ABD5 cb 4b
    JR NZ,$ABA7                           ; $ABD7 20 ce
    BIT 0,E                               ; $ABD9 cb 43
    JR NZ,$ABBB                           ; $ABDB 20 de
    RES 2,E                               ; $ABDD cb 93
    SET 0,E                               ; $ABDF cb c3
    LD A,(IY+$00)                         ; $ABE1 fd 7e 00
    LD (IY+$02),A                         ; $ABE4 fd 77 02
    LD A,(IY+$01)                         ; $ABE7 fd 7e 01
    LD (IY+$03),A                         ; $ABEA fd 77 03
    JR $ABAB                              ; $ABED 18 bc
    OR A                                  ; $ABEF b7
    BIT 1,E                               ; $ABF0 cb 4b
    RET                                   ; $ABF2 c9
    CALL $AE7F                            ; $ABF3 cd 7f ae
    CP $80                                ; $ABF6 fe 80
    CALL Z,$AE7F                          ; $ABF8 cc 7f ae
    LD A,B                                ; $ABFB 78
    AND $0F                               ; $ABFC e6 0f
    LD B,A                                ; $ABFE 47
    LD HL,$994D                           ; $ABFF 21 4d 99
    LD A,(HL)                             ; $AC02 7e
    INC HL                                ; $AC03 23
    OR (HL)                               ; $AC04 b6
    JR Z,$AC14                            ; $AC05 28 0d
    LD A,B                                ; $AC07 78
    CP (HL)                               ; $AC08 be
    JR NZ,$AC11                           ; $AC09 20 06
    DEC HL                                ; $AC0B 2b
    LD A,C                                ; $AC0C 79
    CP (HL)                               ; $AC0D be
    JR Z,$AC17                            ; $AC0E 28 07
    INC HL                                ; $AC10 23
    INC HL                                ; $AC11 23
    JR $AC02                              ; $AC12 18 ee
    OR $01                                ; $AC14 f6 01
    RET                                   ; $AC16 c9
    LD (IY+$00),C                         ; $AC17 fd 71 00
    LD (IY+$01),B                         ; $AC1A fd 70 01
    RES 1,E                               ; $AC1D cb 8b
    CALL $AE7F                            ; $AC1F cd 7f ae
    XOR A                                 ; $AC22 af
    RET                                   ; $AC23 c9
    LD HL,$AAA8                           ; $AC24 21 a8 aa
    LD B,$0A                              ; $AC27 06 0a
    CALL $A2AB                            ; $AC29 cd ab a2
    LD A,E                                ; $AC2C 7b
    OR $34                                ; $AC2D f6 34
    LD E,A                                ; $AC2F 5f
    CALL $AE7F                            ; $AC30 cd 7f ae
    CP $80                                ; $AC33 fe 80
    JR NZ,$AC41                           ; $AC35 20 0a
    BIT 4,E                               ; $AC37 cb 63
    JR Z,$AC3F                            ; $AC39 28 04
    RES 4,E                               ; $AC3B cb a3
    JR $AC30                              ; $AC3D 18 f1
    SCF                                   ; $AC3F 37
    RET                                   ; $AC40 c9
    CP $10                                ; $AC41 fe 10
    JR Z,$AC49                            ; $AC43 28 04
    CP $70                                ; $AC45 fe 70
    JR NZ,$AC65                           ; $AC47 20 1c
    BIT 4,E                               ; $AC49 cb 63
    JR Z,$AC3F                            ; $AC4B 28 f2
    BIT 2,E                               ; $AC4D cb 53
    JR Z,$AC3F                            ; $AC4F 28 ee
    LD A,($AAA7)                          ; $AC51 3a a7 aa
    CP $03                                ; $AC54 fe 03
    JR NC,$AC3F                           ; $AC56 30 e7
    INC A                                 ; $AC58 3c
    LD ($AAA7),A                          ; $AC59 32 a7 aa
    CALL $AC8F                            ; $AC5C cd 8f ac
    JR NZ,$AC3F                           ; $AC5F 20 de
    RES 5,E                               ; $AC61 cb ab
    JR $AC30                              ; $AC63 18 cb
    CP $60                                ; $AC65 fe 60
    JR NZ,$AC78                           ; $AC67 20 0f
    BIT 2,E                               ; $AC69 cb 53
    JR Z,$AC3F                            ; $AC6B 28 d2
    RES 4,E                               ; $AC6D cb a3
    RES 5,E                               ; $AC6F cb ab
    CALL $AC94                            ; $AC71 cd 94 ac
    JR NZ,$AC3F                           ; $AC74 20 c9
    JR $AC30                              ; $AC76 18 b8
    CP $F0                                ; $AC78 fe f0
    JR Z,$AC80                            ; $AC7A 28 04
    CP $50                                ; $AC7C fe 50
    JR NZ,$AC8B                           ; $AC7E 20 0b
    LD A,E                                ; $AC80 7b
    AND $CB                               ; $AC81 e6 cb
    LD E,A                                ; $AC83 5f
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
    BIT 6,E                               ; $ACA6 cb 73
    JR Z,$ACB2                            ; $ACA8 28 08
    RES 6,E                               ; $ACAA cb b3
    PUSH DE                               ; $ACAC d5
    LD DE,$0004                           ; $ACAD 11 04 00
    JR $ACBB                              ; $ACB0 18 09
    BIT 7,E                               ; $ACB2 cb 7b
    RET Z                                 ; $ACB4 c8
    RES 7,E                               ; $ACB5 cb bb
    PUSH DE                               ; $ACB7 d5
    LD DE,$000E                           ; $ACB8 11 0e 00
    PUSH IY                               ; $ACBB fd e5
    POP HL                                ; $ACBD e1
    ADD HL,DE                             ; $ACBE 19
    LD DE,$AAA8                           ; $ACBF 11 a8 aa
    EX DE,HL                              ; $ACC2 eb
    LD BC,$000A                           ; $ACC3 01 0a 00
    LDIR                                  ; $ACC6 ed b0
    POP DE                                ; $ACC8 d1
    OR $01                                ; $ACC9 f6 01
    RET                                   ; $ACCB c9
    RES 3,E                               ; $ACCC cb 9b
    PUSH DE                               ; $ACCE d5
    CALL $AE7F                            ; $ACCF cd 7f ae
    CP $A0                                ; $ACD2 fe a0
    JR Z,$ACCF                            ; $ACD4 28 f9
    LD HL,($A029)                         ; $ACD6 2a 29 a0
    LD ($AAA1),HL                         ; $ACD9 22 a1 aa
    LD ($A02B),HL                         ; $ACDC 22 2b a0
    POP DE                                ; $ACDF d1
    LD A,E                                ; $ACE0 7b
    LD ($AAA3),A                          ; $ACE1 32 a3 aa
    LD ($AAA4),IY                         ; $ACE4 fd 22 a4 aa
    LD A,($A012)                          ; $ACE8 3a 12 a0
    LD ($AAA6),A                          ; $ACEB 32 a6 aa
    LD A,($A01A)                          ; $ACEE 3a 1a a0
    CP $02                                ; $ACF1 fe 02
    JR NZ,$AD57                           ; $ACF3 20 62
    SET 6,(IY+$01)                        ; $ACF5 fd cb 01 f6
    JR $AD57                              ; $ACF9 18 5c
    LD A,($A024)                          ; $ACFB 3a 24 a0
    CP $02                                ; $ACFE fe 02
    JR NZ,$AD23                           ; $AD00 20 21
    BIT 6,E                               ; $AD02 cb 73
    JP NZ,$AB4C                           ; $AD04 c2 4c ab
    SET 6,E                               ; $AD07 cb f3
    SET 3,E                               ; $AD09 cb db
    PUSH IY                               ; $AD0B fd e5
    EXX                                   ; $AD0D d9
    POP HL                                ; $AD0E e1
    LD DE,$0008                           ; $AD0F 11 08 00
    ADD HL,DE                             ; $AD12 19
    PUSH HL                               ; $AD13 e5
    LD DE,$0010                           ; $AD14 11 10 00
    ADD HL,DE                             ; $AD17 19
    POP DE                                ; $AD18 d1
    EX DE,HL                              ; $AD19 eb
    LD BC,$0006                           ; $AD1A 01 06 00
    LDIR                                  ; $AD1D ed b0
    EXX                                   ; $AD1F d9
    JP $AB4C                              ; $AD20 c3 4c ab
    LD A,($A01B)                          ; $AD23 3a 1b a0
    AND A                                 ; $AD26 a7
    JR Z,$AD2E                            ; $AD27 28 05
    SET 3,E                               ; $AD29 cb db
    JP $AB4C                              ; $AD2B c3 4c ab
    LD HL,($AAA1)                         ; $AD2E 2a a1 aa
    LD ($A02B),HL                         ; $AD31 22 2b a0
    LD D,$B0                              ; $AD34 16 b0
    LD A,($AAA3)                          ; $AD36 3a a3 aa
    LD E,A                                ; $AD39 5f
    LD A,($AAA6)                          ; $AD3A 3a a6 aa
    LD ($A012),A                          ; $AD3D 32 12 a0
    LD IY,($AAA4)                         ; $AD40 fd 2a a4 aa
    LD L,(IY-$02)                         ; $AD44 fd 6e fe
    LD H,(IY-$01)                         ; $AD47 fd 66 ff
    PUSH HL                               ; $AD4A e5
    POP IX                                ; $AD4B dd e1
    CALL $A1AF                            ; $AD4D cd af a1
    XOR A                                 ; $AD50 af
    LD (IY-$02),A                         ; $AD51 fd 77 fe
    LD (IY-$01),A                         ; $AD54 fd 77 ff
    LD A,($A01A)                          ; $AD57 3a 1a a0
    DEC A                                 ; $AD5A 3d
    LD HL,$A012                           ; $AD5B 21 12 a0
    DEC A                                 ; $AD5E 3d
    LD A,D                                ; $AD5F 7a
    JR NZ,$AD66                           ; $AD60 20 04
    CP $A0                                ; $AD62 fe a0
    JR Z,$AD67                            ; $AD64 28 01
    INC (HL)                              ; $AD66 34
    CP $A0                                ; $AD67 fe a0
    JP Z,$AABD                            ; $AD69 ca bd aa
    LD A,($A01B)                          ; $AD6C 3a 1b a0
    AND A                                 ; $AD6F a7
    JR Z,$ADD4                            ; $AD70 28 62
    LD IY,($9FF0)                         ; $AD72 fd 2a f0 9f
    CALL $AEA9                            ; $AD76 cd a9 ae
    LD A,(IY+$01)                         ; $AD79 fd 7e 01
    AND $7F                               ; $AD7C e6 7f
    OR (IY+$00)                           ; $AD7E fd b6 00
    JR NZ,$ADB8                           ; $AD81 20 35
    LD A,($A01B)                          ; $AD83 3a 1b a0
    LD E,A                                ; $AD86 5f
    LD D,$00                              ; $AD87 16 00
    LD HL,($9FF0)                         ; $AD89 2a f0 9f
    LD A,(IY+$01)                         ; $AD8C fd 7e 01
    AND $80                               ; $AD8F e6 80
    INC HL                                ; $AD91 23
    OR (HL)                               ; $AD92 b6
    LD (HL),A                             ; $AD93 77
    DEC HL                                ; $AD94 2b
    ADD HL,DE                             ; $AD95 19
    LD DE,$0008                           ; $AD96 11 08 00
    ADD IY,DE                             ; $AD99 fd 19
    PUSH IY                               ; $AD9B fd e5
    POP DE                                ; $AD9D d1
    CALL $AE59                            ; $AD9E cd 59 ae
    CALL $AE59                            ; $ADA1 cd 59 ae
    JR Z,$ADAF                            ; $ADA4 28 09
    PUSH DE                               ; $ADA6 d5
    PUSH HL                               ; $ADA7 e5
    DEC DE                                ; $ADA8 1b
    DEC DE                                ; $ADA9 1b
    CALL $AE59                            ; $ADAA cd 59 ae
    POP HL                                ; $ADAD e1
    POP DE                                ; $ADAE d1
    CALL $AE59                            ; $ADAF cd 59 ae
    LD IY,($9FF0)                         ; $ADB2 fd 2a f0 9f
    JR $ADBC                              ; $ADB6 18 04
    LD IY,$9FF2                           ; $ADB8 fd 21 f2 9f
    LD L,(IY-$02)                         ; $ADBC fd 6e fe
    LD H,(IY-$01)                         ; $ADBF fd 66 ff
    PUSH HL                               ; $ADC2 e5
    POP IX                                ; $ADC3 dd e1
    LD L,(IX-$02)                         ; $ADC5 dd 6e fe
    LD H,(IX-$01)                         ; $ADC8 dd 66 ff
    LD (IY-$02),L                         ; $ADCB fd 75 fe
    LD (IY-$01),H                         ; $ADCE fd 74 ff
    CALL $A1C7                            ; $ADD1 cd c7 a1
    LD IY,$9FF2                           ; $ADD4 fd 21 f2 9f
    LD A,($A012)                          ; $ADD8 3a 12 a0
    LD B,A                                ; $ADDB 47
    PUSH BC                               ; $ADDC c5
    CALL $AEB6                            ; $ADDD cd b6 ae
    LD A,B                                ; $ADE0 78
    AND A                                 ; $ADE1 a7
    JR Z,$AE1E                            ; $ADE2 28 3a
    CALL $AEB6                            ; $ADE4 cd b6 ae
    LD A,($A024)                          ; $ADE7 3a 24 a0
    CP $02                                ; $ADEA fe 02
    JR NZ,$AE11                           ; $ADEC 20 23
    PUSH IY                               ; $ADEE fd e5
    POP HL                                ; $ADF0 e1
    LD DE,$0018                           ; $ADF1 11 18 00
    ADD HL,DE                             ; $ADF4 19
    PUSH HL                               ; $ADF5 e5
    LD D,$06                              ; $ADF6 16 06
    XOR A                                 ; $ADF8 af
    OR (HL)                               ; $ADF9 b6
    INC HL                                ; $ADFA 23
    DEC D                                 ; $ADFB 15
    JR NZ,$ADF9                           ; $ADFC 20 fb
    POP HL                                ; $ADFE e1
    AND A                                 ; $ADFF a7
    JR NZ,$AE11                           ; $AE00 20 0f
    EX DE,HL                              ; $AE02 eb
    PUSH IX                               ; $AE03 dd e5
    POP HL                                ; $AE05 e1
    PUSH BC                               ; $AE06 c5
    LD BC,$0018                           ; $AE07 01 18 00
    ADD HL,BC                             ; $AE0A 09
    LD BC,$0006                           ; $AE0B 01 06 00
    LDIR                                  ; $AE0E ed b0
    POP BC                                ; $AE10 c1
    LD A,(IY+$01)                         ; $AE11 fd 7e 01
    AND $7F                               ; $AE14 e6 7f
    OR (IY+$00)                           ; $AE16 fd b6 00
    CALL Z,$AEF1                          ; $AE19 cc f1 ae
    JR $ADE0                              ; $AE1C 18 c2
    POP BC                                ; $AE1E c1
    CALL $AEEA                            ; $AE1F cd ea ae
    CALL $AEC5                            ; $AE22 cd c5 ae
    LD A,B                                ; $AE25 78
    AND A                                 ; $AE26 a7
    JP Z,$AE57                            ; $AE27 ca 57 ae
    CALL $AEC5                            ; $AE2A cd c5 ae
    LD A,(IY+$12)                         ; $AE2D fd 7e 12
    OR (IY+$13)                           ; $AE30 fd b6 13
    JR NZ,$AE25                           ; $AE33 20 f0
    LD A,(IY+$00)                         ; $AE35 fd 7e 00
    CP (IX+$00)                           ; $AE38 dd be 00
    JR NZ,$AE25                           ; $AE3B 20 e8
    LD A,(IY+$01)                         ; $AE3D fd 7e 01
    CP (IX+$01)                           ; $AE40 dd be 01
    JR NZ,$AE25                           ; $AE43 20 e0
    LD A,(IX+$0E)                         ; $AE45 dd 7e 0e
    OR (IX+$0F)                           ; $AE48 dd b6 0f
    JR Z,$AE25                            ; $AE4B 28 d8
    EXX                                   ; $AE4D d9
    LD DE,$000E                           ; $AE4E 11 0e 00
    CALL $AF27                            ; $AE51 cd 27 af
    JP $AE25                              ; $AE54 c3 25 ae
    XOR A                                 ; $AE57 af
    RET                                   ; $AE58 c9
    LD A,(HL)                             ; $AE59 7e
    INC HL                                ; $AE5A 23
    OR (HL)                               ; $AE5B b6
    DEC HL                                ; $AE5C 2b
    JR NZ,$AE61                           ; $AE5D 20 02
    LD A,(DE)                             ; $AE5F 1a
    LD (HL),A                             ; $AE60 77
    INC HL                                ; $AE61 23
    INC DE                                ; $AE62 13
    JR NZ,$AE67                           ; $AE63 20 02
    LD A,(DE)                             ; $AE65 1a
    LD (HL),A                             ; $AE66 77
    INC HL                                ; $AE67 23
    INC DE                                ; $AE68 13
    RET                                   ; $AE69 c9
    CALL $AEEA                            ; $AE6A cd ea ae
    LD A,$1E                              ; $AE6D 3e 1e
    CALL $A11C                            ; $AE6F cd 1c a1
    PUSH IX                               ; $AE72 dd e5
    POP HL                                ; $AE74 e1
    LD (IY-$02),L                         ; $AE75 fd 75 fe
    LD (IY-$01),H                         ; $AE78 fd 74 ff
    PUSH HL                               ; $AE7B e5
    POP IY                                ; $AE7C fd e1
    RET                                   ; $AE7E c9
    LD HL,($A02B)                         ; $AE7F 2a 2b a0
    LD ($A029),HL                         ; $AE82 22 29 a0
    LD A,D                                ; $AE85 7a
    LD ($A02D),A                          ; $AE86 32 2d a0
    LD A,(HL)                             ; $AE89 7e
    LD D,A                                ; $AE8A 57
    LD BC,$0000                           ; $AE8B 01 00 00
    INC HL                                ; $AE8E 23
    CP $E0                                ; $AE8F fe e0
    JR Z,$AE9F                            ; $AE91 28 0c
    CP $F0                                ; $AE93 fe f0
    JR Z,$AE9F                            ; $AE95 28 08
    CP $90                                ; $AE97 fe 90
    JR Z,$AE9F                            ; $AE99 28 04
    CP $80                                ; $AE9B fe 80
    JR NC,$AEA4                           ; $AE9D 30 05
    LD A,(HL)                             ; $AE9F 7e
    LD B,A                                ; $AEA0 47
    INC HL                                ; $AEA1 23
    LD C,(HL)                             ; $AEA2 4e
    INC HL                                ; $AEA3 23
    LD ($A02B),HL                         ; $AEA4 22 2b a0
    LD A,D                                ; $AEA7 7a
    RET                                   ; $AEA8 c9
    PUSH HL                               ; $AEA9 e5
    LD L,(IY-$02)                         ; $AEAA fd 6e fe
    LD H,(IY-$01)                         ; $AEAD fd 66 ff
    LD A,H                                ; $AEB0 7c
    OR L                                  ; $AEB1 b5
    EX (SP),HL                            ; $AEB2 e3
    POP IY                                ; $AEB3 fd e1
    RET                                   ; $AEB5 c9
    DEC B                                 ; $AEB6 05
    PUSH IY                               ; $AEB7 fd e5
    POP IX                                ; $AEB9 dd e1
    CALL $AEA9                            ; $AEBB cd a9 ae
    BIT 6,(IY+$01)                        ; $AEBE fd cb 01 76
    JR NZ,$AEB7                           ; $AEC2 20 f3
    RET                                   ; $AEC4 c9
    DEC B                                 ; $AEC5 05
    PUSH IY                               ; $AEC6 fd e5
    POP IX                                ; $AEC8 dd e1
    PUSH HL                               ; $AECA e5
    PUSH DE                               ; $AECB d5
    PUSH IY                               ; $AECC fd e5
    POP DE                                ; $AECE d1
    LD IY,$9FF0                           ; $AECF fd 21 f0 9f
    CALL $A104                            ; $AED3 cd 04 a1
    PUSH IY                               ; $AED6 fd e5
    POP HL                                ; $AED8 e1
    LD DE,$9FF2                           ; $AED9 11 f2 9f
    AND A                                 ; $AEDC a7
    SBC HL,DE                             ; $AEDD ed 52
    JR Z,$AEE7                            ; $AEDF 28 06
    BIT 6,(IY+$01)                        ; $AEE1 fd cb 01 76
    JR NZ,$AECC                           ; $AEE5 20 e5
    POP DE                                ; $AEE7 d1
    POP HL                                ; $AEE8 e1
    RET                                   ; $AEE9 c9
    LD IY,$0000                           ; $AEEA fd 21 00 00
    JP $AEC6                              ; $AEEE c3 c6 ae
    EXX                                   ; $AEF1 d9
    LD A,(IX+$01)                         ; $AEF2 dd 7e 01
    AND $7F                               ; $AEF5 e6 7f
    OR (IY+$01)                           ; $AEF7 fd b6 01
    LD (IY+$01),A                         ; $AEFA fd 77 01
    LD A,(IX+$00)                         ; $AEFD dd 7e 00
    LD (IY+$00),A                         ; $AF00 fd 77 00
    EXX                                   ; $AF03 d9
    LD A,(IX+$04)                         ; $AF04 dd 7e 04
    OR (IX+$05)                           ; $AF07 dd b6 05
    RET Z                                 ; $AF0A c8
    LD A,$0E                              ; $AF0B 3e 0e
    CALL $AF38                            ; $AF0D cd 38 af
    RET NZ                                ; $AF10 c0
    EXX                                   ; $AF11 d9
    PUSH IY                               ; $AF12 fd e5
    POP HL                                ; $AF14 e1
    LD DE,$0012                           ; $AF15 11 12 00
    ADD HL,DE                             ; $AF18 19
    PUSH HL                               ; $AF19 e5
    LD DE,$FFF6                           ; $AF1A 11 f6 ff
    ADD HL,DE                             ; $AF1D 19
    POP DE                                ; $AF1E d1
    LD BC,$0006                           ; $AF1F 01 06 00
    LDIR                                  ; $AF22 ed b0
    LD DE,$0004                           ; $AF24 11 04 00
    CALL $AF52                            ; $AF27 cd 52 af
    LD A,(IY+$02)                         ; $AF2A fd 7e 02
    OR (IY+$03)                           ; $AF2D fd b6 03
    LD DE,$0002                           ; $AF30 11 02 00
    CALL Z,$AF56                          ; $AF33 cc 56 af
    EXX                                   ; $AF36 d9
    RET                                   ; $AF37 c9
    PUSH DE                               ; $AF38 d5
    PUSH BC                               ; $AF39 c5
    PUSH HL                               ; $AF3A e5
    LD B,$0A                              ; $AF3B 06 0a
    PUSH IY                               ; $AF3D fd e5
    POP HL                                ; $AF3F e1
    LD E,A                                ; $AF40 5f
    LD D,$00                              ; $AF41 16 00
    ADD HL,DE                             ; $AF43 19
    XOR A                                 ; $AF44 af
    OR (HL)                               ; $AF45 b6
    INC HL                                ; $AF46 23
    DJNZ $AF45                            ; $AF47 10 fc
    POP HL                                ; $AF49 e1
    POP BC                                ; $AF4A c1
    POP DE                                ; $AF4B d1
    AND A                                 ; $AF4C a7
    RET                                   ; $AF4D c9
    LD C,$06                              ; $AF4E 0e 06
    JR $AF58                              ; $AF50 18 06
    LD C,$0A                              ; $AF52 0e 0a
    JR $AF58                              ; $AF54 18 02
    LD C,$02                              ; $AF56 0e 02
    PUSH IY                               ; $AF58 fd e5
    POP HL                                ; $AF5A e1
    ADD HL,DE                             ; $AF5B 19
    PUSH HL                               ; $AF5C e5
    PUSH IX                               ; $AF5D dd e5
    POP HL                                ; $AF5F e1
    ADD HL,DE                             ; $AF60 19
    POP DE                                ; $AF61 d1
    LD B,$00                              ; $AF62 06 00
    LDIR                                  ; $AF64 ed b0
    RET                                   ; $AF66 c9
    LD A,$01                              ; $AF67 3e 01
    AND A                                 ; $AF69 a7
    RET                                   ; $AF6A c9

    ORG $AF6B
; DATA: Special-token dispatch tables
    DEFB $00,$00,$49,$B0,$40,$00,$33,$B0  ; $AF6B 00 00 49 b0 40 00 33 b0
    DEFB $5E,$01,$1C,$B0,$D5,$06,$FF,$AF  ; $AF73 5e 01 1c b0 d5 06 ff af
    DEFB $BD,$05,$0B,$B0,$07,$05,$A3,$B0  ; $AF7B bd 05 0b b0 07 05 a3 b0
    DEFB $75,$07,$C6,$B0,$60,$06,$9A,$B0  ; $AF83 75 07 c6 b0 60 06 9a b0
    DEFB $E3,$03,$35,$B1,$88,$04,$51,$B1  ; $AF8B e3 03 35 b1 88 04 51 b1
    DEFB $F6,$06,$A3,$B0,$B3,$08,$51,$B1  ; $AF93 f6 06 a3 b0 b3 08 51 b1
    DEFB $99,$08,$FD,$B0,$E3,$03,$3F,$B1  ; $AF9B 99 08 fd b0 e3 03 3f b1
    DEFB $88,$04,$5B,$B1,$B3,$08,$5B,$B1  ; $AFA3 88 04 5b b1 b3 08 5b b1
    DEFB $C5,$00,$FA,$AF,$AE,$08,$FA,$AF  ; $AFAB c5 00 fa af ae 08 fa af

    ORG $AFB3
; CODE: Special-token handlers
    LD HL,$AF6B                           ; $AFB3 21 6b af
    LD A,($A024)                          ; $AFB6 3a 24 a0
    CP $02                                ; $AFB9 fe 02
    JR NZ,$AFC0                           ; $AFBB 20 03
    LD HL,$AF9B                           ; $AFBD 21 9b af
    PUSH DE                               ; $AFC0 d5
    LD E,$0C                              ; $AFC1 1e 0c
    JR NZ,$AFC7                           ; $AFC3 20 02
    LD E,$06                              ; $AFC5 1e 06
    LD A,(HL)                             ; $AFC7 7e
    INC HL                                ; $AFC8 23
    CP C                                  ; $AFC9 b9
    JR NZ,$AFD0                           ; $AFCA 20 04
    LD A,(HL)                             ; $AFCC 7e
    CP B                                  ; $AFCD b8
    JR Z,$AFDA                            ; $AFCE 28 0a
    INC HL                                ; $AFD0 23
    INC HL                                ; $AFD1 23
    INC HL                                ; $AFD2 23
    DEC E                                 ; $AFD3 1d
    JR NZ,$AFC7                           ; $AFD4 20 f1
    POP DE                                ; $AFD6 d1
    JP $AF67                              ; $AFD7 c3 67 af
    INC HL                                ; $AFDA 23
    LD E,(HL)                             ; $AFDB 5e
    INC HL                                ; $AFDC 23
    LD D,(HL)                             ; $AFDD 56
    EX DE,HL                              ; $AFDE eb
    POP DE                                ; $AFDF d1
    JP (HL)                               ; $AFE0 e9
    BIT 1,E                               ; $AFE1 cb 4b
    RET NZ                                ; $AFE3 c0
    POP HL                                ; $AFE4 e1
    JP $AF67                              ; $AFE5 c3 67 af
    BIT 1,E                               ; $AFE8 cb 4b
    RET Z                                 ; $AFEA c8
    LD A,($A012)                          ; $AFEB 3a 12 a0
    AND A                                 ; $AFEE a7
    JR NZ,$AFF6                           ; $AFEF 20 05
    LD A,($A01B)                          ; $AFF1 3a 1b a0
    AND A                                 ; $AFF4 a7
    RET NZ                                ; $AFF5 c0
    POP HL                                ; $AFF6 e1
    JP $AF67                              ; $AFF7 c3 67 af
    LD D,$A0                              ; $AFFA 16 a0
    JP $ACCC                              ; $AFFC c3 cc ac
    CALL $AFE1                            ; $AFFF cd e1 af
    CALL $C03B                            ; $B002 cd 3b c0
    JR NZ,$B015                           ; $B005 20 0e
    LD A,$01                              ; $B007 3e 01
    JR $B012                              ; $B009 18 07
    CALL $AFE1                            ; $B00B cd e1 af
    CALL $A296                            ; $B00E cd 96 a2
    XOR A                                 ; $B011 af
    LD ($A008),A                          ; $B012 32 08 a0
    LD A,($A02D)                          ; $B015 3a 2d a0
    LD D,A                                ; $B018 57
    JP $AAC4                              ; $B019 c3 c4 aa
    LD A,($A01A)                          ; $B01C 3a 1a a0
    CP $01                                ; $B01F fe 01
    JP NZ,$AF67                           ; $B021 c2 67 af
    LD A,$02                              ; $B024 3e 02
    LD ($A01A),A                          ; $B026 32 1a a0
    CALL $AE6A                            ; $B029 cd 6a ae
    SET 6,(IY+$01)                        ; $B02C fd cb 01 f6
    JP $AB52                              ; $B030 c3 52 ab
    CALL $AFE8                            ; $B033 cd e8 af
    LD A,($A01A)                          ; $B036 3a 1a a0
    AND A                                 ; $B039 a7
    JP NZ,$AF67                           ; $B03A c2 67 af
    LD A,$01                              ; $B03D 3e 01
    LD ($A01A),A                          ; $B03F 32 1a a0
    SET 7,(IY+$01)                        ; $B042 fd cb 01 fe
    JP $AB52                              ; $B046 c3 52 ab
    BIT 1,E                               ; $B049 cb 4b
    JR Z,$B058                            ; $B04B 28 0b
    LD HL,$088B                           ; $B04D 21 8b 08
    LD (IY+$00),L                         ; $B050 fd 75 00
    LD (IY+$01),H                         ; $B053 fd 74 01
    RES 1,E                               ; $B056 cb 8b
    PUSH HL                               ; $B058 e5
    PUSH DE                               ; $B059 d5
    PUSH IY                               ; $B05A fd e5
    PUSH IX                               ; $B05C dd e5
    LD IY,$9FEC                           ; $B05E fd 21 ec 9f
    LD DE,$0000                           ; $B062 11 00 00
    CALL $A104                            ; $B065 cd 04 a1
    LD A,$02                              ; $B068 3e 02
    CALL $A11C                            ; $B06A cd 1c a1
    LD HL,($A02B)                         ; $B06D 2a 2b a0
    LD (IX+$00),L                         ; $B070 dd 75 00
    LD (IX+$01),H                         ; $B073 dd 74 01
    PUSH IX                               ; $B076 dd e5
    POP HL                                ; $B078 e1
    LD (IY-$02),L                         ; $B079 fd 75 fe
    LD (IY-$01),H                         ; $B07C fd 74 ff
    POP IX                                ; $B07F dd e1
    POP IY                                ; $B081 fd e1
    POP DE                                ; $B083 d1
    POP HL                                ; $B084 e1
    CALL $AE7F                            ; $B085 cd 7f ae
    CP $90                                ; $B088 fe 90
    JR NZ,$B085                           ; $B08A 20 f9
    LD A,B                                ; $B08C 78
    AND $0F                               ; $B08D e6 0f
    OR C                                  ; $B08F b1
    JR NZ,$B085                           ; $B090 20 f3
    LD HL,($A029)                         ; $B092 2a 29 a0
    LD (HL),$C0                           ; $B095 36 c0
    JP $AB52                              ; $B097 c3 52 ab
    CALL $AFE1                            ; $B09A cd e1 af
    CALL $C415                            ; $B09D cd 15 c4
    JP $B015                              ; $B0A0 c3 15 b0
    CALL $AFE1                            ; $B0A3 cd e1 af
    CALL $B0AC                            ; $B0A6 cd ac b0
    JP $B015                              ; $B0A9 c3 15 b0
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
    CALL $AFE1                            ; $B0C6 cd e1 af
    LD HL,$0001                           ; $B0C9 21 01 00
    LD ($A01F),HL                         ; $B0CC 22 1f a0
    LD A,$02                              ; $B0CF 3e 02
    LD ($A0DA),A                          ; $B0D1 32 da a0
    JP $B015                              ; $B0D4 c3 15 b0
    CALL $B0EE                            ; $B0D7 cd ee b0
    CALL $C0DF                            ; $B0DA cd df c0
    JR NC,$B0D7                           ; $B0DD 30 f8
    LD IY,($9FD4)                         ; $B0DF fd 2a d4 9f
    RET                                   ; $B0E3 c9
    LD ($9FD4),IY                         ; $B0E4 fd 22 d4 9f
    CALL $B0EE                            ; $B0E8 cd ee b0
    JP $C040                              ; $B0EB c3 40 c0
    LD IX,$840B                           ; $B0EE dd 21 0b 84
    LD HL,$A01F                           ; $B0F2 21 1f a0
    LD DE,$840B                           ; $B0F5 11 0b 84
    AND A                                 ; $B0F8 a7
    SBC HL,DE                             ; $B0F9 ed 52
    EX DE,HL                              ; $B0FB eb
    RET                                   ; $B0FC c9
    LD BC,$0008                           ; $B0FD 01 08 00
    BIT 3,E                               ; $B100 cb 5b
    JR NZ,$B107                           ; $B102 20 03
    CALL $AEC6                            ; $B104 cd c6 ae
    PUSH IY                               ; $B107 fd e5
    POP HL                                ; $B109 e1
    ADD HL,BC                             ; $B10A 09
    PUSH DE                               ; $B10B d5
    PUSH HL                               ; $B10C e5
    BIT 3,E                               ; $B10D cb 5b
    JR NZ,$B118                           ; $B10F 20 07
    SET 3,E                               ; $B111 cb db
    CALL $AEA9                            ; $B113 cd a9 ae
    JR $B11F                              ; $B116 18 07
    LD HL,$A012                           ; $B118 21 12 a0
    INC (HL)                              ; $B11B 34
    CALL $AE6A                            ; $B11C cd 6a ae
    PUSH IY                               ; $B11F fd e5
    POP HL                                ; $B121 e1
    LD BC,$0018                           ; $B122 01 18 00
    ADD HL,BC                             ; $B125 09
    POP DE                                ; $B126 d1
    EX DE,HL                              ; $B127 eb
    LD BC,$0006                           ; $B128 01 06 00
    LDIR                                  ; $B12B ed b0
    POP DE                                ; $B12D d1
    LD A,E                                ; $B12E 7b
    OR $C7                                ; $B12F f6 c7
    LD E,A                                ; $B131 5f
    JP $AAD1                              ; $B132 c3 d1 aa
    CALL $AFE1                            ; $B135 cd e1 af
    LD A,$02                              ; $B138 3e 02
    LD ($A024),A                          ; $B13A 32 24 a0
    JR $B14B                              ; $B13D 18 0c
    BIT 3,E                               ; $B13F cb 5b
    JR Z,$B14B                            ; $B141 28 08
    PUSH DE                               ; $B143 d5
    CALL $AEA9                            ; $B144 cd a9 ae
    CALL $AE6A                            ; $B147 cd 6a ae
    POP DE                                ; $B14A d1
    SET 7,(IY+$19)                        ; $B14B fd cb 19 fe
    JR $B12E                              ; $B14F 18 dd
    CALL $AFE1                            ; $B151 cd e1 af
    LD A,$02                              ; $B154 3e 02
    LD ($A024),A                          ; $B156 32 24 a0
    JR $B167                              ; $B159 18 0c
    BIT 3,E                               ; $B15B cb 5b
    JR Z,$B167                            ; $B15D 28 08
    PUSH DE                               ; $B15F d5
    CALL $AEA9                            ; $B160 cd a9 ae
    CALL $AE6A                            ; $B163 cd 6a ae
    POP DE                                ; $B166 d1
    SET 6,(IY+$19)                        ; $B167 fd cb 19 f6
    JR $B12E                              ; $B16B 18 c1

    ORG $B16D
; DATA: Semantic lookup working fields
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $B16D 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $B175 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $B17D 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $B185 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00                  ; $B18D 00 00 00 00

    ORG $B191
; CODE: Argument cardinality and candidate iteration
    LD A,$FF                              ; $B191 3e ff
    LD ($A035),A                          ; $B193 32 35 a0
    LD ($A034),A                          ; $B196 32 34 a0
    LD HL,$B16D                           ; $B199 21 6d b1
    LD B,$11                              ; $B19C 06 11
    CALL $A2AB                            ; $B19E cd ab a2
    CALL $B39D                            ; $B1A1 cd 9d b3
    JR NZ,$B1AB                           ; $B1A4 20 05
    LD HL,$B84C                           ; $B1A6 21 4c b8
    XOR A                                 ; $B1A9 af
    RET                                   ; $B1AA c9
    LD A,$01                              ; $B1AB 3e 01
    PUSH IX                               ; $B1AD dd e5
    POP HL                                ; $B1AF e1
    LD DE,$8259                           ; $B1B0 11 59 82
    SBC HL,DE                             ; $B1B3 ed 52
    JR Z,$B1BF                            ; $B1B5 28 08
    LD DE,$0008                           ; $B1B7 11 08 00
    INC A                                 ; $B1BA 3c
    SBC HL,DE                             ; $B1BB ed 52
    JR NZ,$B1BA                           ; $B1BD 20 fb
    LD ($A033),A                          ; $B1BF 32 33 a0
    LD ($B18E),IX                         ; $B1C2 dd 22 8e b1
    CP $2E                                ; $B1C6 fe 2e
    JR NZ,$B1DD                           ; $B1C8 20 13
    LD HL,$B16D                           ; $B1CA 21 6d b1
    BIT 0,(HL)                            ; $B1CD cb 46
    LD HL,$A002                           ; $B1CF 21 02 a0
    LD DE,$B172                           ; $B1D2 11 72 b1
    LD BC,$0006                           ; $B1D5 01 06 00
    JR Z,$B1DB                            ; $B1D8 28 01
    EX DE,HL                              ; $B1DA eb
    LDIR                                  ; $B1DB ed b0
    CALL $C493                            ; $B1DD cd 93 c4
    CALL $C4B2                            ; $B1E0 cd b2 c4
    LD A,($A01C)                          ; $B1E3 3a 1c a0
    AND A                                 ; $B1E6 a7
    JR NZ,$B1F2                           ; $B1E7 20 09
    LD A,($B39C)                          ; $B1E9 3a 9c b3
    LD ($A01C),A                          ; $B1EC 32 1c a0
    CALL $B34F                            ; $B1EF cd 4f b3
    LD A,($A01E)                          ; $B1F2 3a 1e a0
    AND $10                               ; $B1F5 e6 10
    LD ($B190),A                          ; $B1F7 32 90 b1
    JR Z,$B200                            ; $B1FA 28 04
    XOR A                                 ; $B1FC af
    LD ($A01C),A                          ; $B1FD 32 1c a0
    XOR A                                 ; $B200 af
    LD ($A00B),A                          ; $B201 32 0b a0
    LD A,($A01D)                          ; $B204 3a 1d a0
    AND $0C                               ; $B207 e6 0c
    JR NZ,$B213                           ; $B209 20 08
    CALL $C929                            ; $B20B cd 29 c9
    RET NZ                                ; $B20E c0
    LD HL,$B863                           ; $B20F 21 63 b8
    RET                                   ; $B212 c9
    CALL $B387                            ; $B213 cd 87 b3
    JR NZ,$B280                           ; $B216 20 68
    LD A,($A01C)                          ; $B218 3a 1c a0
    AND A                                 ; $B21B a7
    JR NZ,$B224                           ; $B21C 20 06
    CALL $B308                            ; $B21E cd 08 b3
    AND A                                 ; $B221 a7
    JR Z,$B259                            ; $B222 28 35
    CALL $B4C1                            ; $B224 cd c1 b4
    JR Z,$B244                            ; $B227 28 1b
    CALL $C929                            ; $B229 cd 29 c9
    JR Z,$B224                            ; $B22C 28 f6
    LD A,($A034)                          ; $B22E 3a 34 a0
    LD ($B184),A                          ; $B231 32 84 b1
    LD HL,$B170                           ; $B234 21 70 b1
    INC (HL)                              ; $B237 34
    LD A,($B190)                          ; $B238 3a 90 b1
    AND A                                 ; $B23B a7
    JR NZ,$B244                           ; $B23C 20 06
    LD A,($A01C)                          ; $B23E 3a 1c a0
    AND A                                 ; $B241 a7
    JR Z,$B224                            ; $B242 28 e0
    LD A,($B184)                          ; $B244 3a 84 b1
    LD ($A034),A                          ; $B247 32 34 a0
    LD A,($B170)                          ; $B24A 3a 70 b1
    AND A                                 ; $B24D a7
    JR Z,$B259                            ; $B24E 28 09
    CP $01                                ; $B250 fe 01
    JR Z,$B20B                            ; $B252 28 b7
    LD HL,$B5E2                           ; $B254 21 e2 b5
    XOR A                                 ; $B257 af
    RET                                   ; $B258 c9
    LD A,($A033)                          ; $B259 3a 33 a0
    CP $2E                                ; $B25C fe 2e
    JR NZ,$B27B                           ; $B25E 20 1b
    LD A,($A01C)                          ; $B260 3a 1c a0
    AND A                                 ; $B263 a7
    JR NZ,$B27B                           ; $B264 20 15
    LD HL,$B16D                           ; $B266 21 6d b1
    BIT 0,(HL)                            ; $B269 cb 46
    JR NZ,$B27B                           ; $B26B 20 0e
    LD HL,$0000                           ; $B26D 21 00 00
    LD ($B172),HL                         ; $B270 22 72 b1
    LD ($B174),HL                         ; $B273 22 74 b1
    LD ($B176),HL                         ; $B276 22 76 b1
    JR $B213                              ; $B279 18 98
    LD HL,$B65F                           ; $B27B 21 5f b6
    XOR A                                 ; $B27E af
    RET                                   ; $B27F c9
    LD A,($A01C)                          ; $B280 3a 1c a0
    AND A                                 ; $B283 a7
    JR NZ,$B292                           ; $B284 20 0c
    CALL $B308                            ; $B286 cd 08 b3
    AND A                                 ; $B289 a7
    JR Z,$B259                            ; $B28A 28 cd
    CALL $B32D                            ; $B28C cd 2d b3
    AND A                                 ; $B28F a7
    JR Z,$B303                            ; $B290 28 71
    CALL $B4C1                            ; $B292 cd c1 b4
    JR Z,$B2B7                            ; $B295 28 20
    CALL $B2DF                            ; $B297 cd df b2
    LD A,($B171)                          ; $B29A 3a 71 b1
    CP $01                                ; $B29D fe 01
    JR NZ,$B292                           ; $B29F 20 f1
    LD A,($A034)                          ; $B2A1 3a 34 a0
    LD ($B184),A                          ; $B2A4 32 84 b1
    LD HL,$B170                           ; $B2A7 21 70 b1
    INC (HL)                              ; $B2AA 34
    LD A,($B190)                          ; $B2AB 3a 90 b1
    AND A                                 ; $B2AE a7
    JR NZ,$B2B7                           ; $B2AF 20 06
    LD A,($A01C)                          ; $B2B1 3a 1c a0
    AND A                                 ; $B2B4 a7
    JR Z,$B292                            ; $B2B5 28 db
    LD A,($B184)                          ; $B2B7 3a 84 b1
    LD ($A034),A                          ; $B2BA 32 34 a0
    LD A,($B170)                          ; $B2BD 3a 70 b1
    AND A                                 ; $B2C0 a7
    JR Z,$B259                            ; $B2C1 28 96
    CP $01                                ; $B2C3 fe 01
    JR NZ,$B2DA                           ; $B2C5 20 13
    CALL $B2DF                            ; $B2C7 cd df b2
    LD A,($B171)                          ; $B2CA 3a 71 b1
    AND A                                 ; $B2CD a7
    JR Z,$B303                            ; $B2CE 28 33
    CP $01                                ; $B2D0 fe 01
    JP Z,$B20B                            ; $B2D2 ca 0b b2
    LD HL,$B5D3                           ; $B2D5 21 d3 b5
    XOR A                                 ; $B2D8 af
    RET                                   ; $B2D9 c9
    LD HL,$B5E2                           ; $B2DA 21 e2 b5
    XOR A                                 ; $B2DD af
    RET                                   ; $B2DE c9
    CALL $B36B                            ; $B2DF cd 6b b3
    CALL $B568                            ; $B2E2 cd 68 b5
    JR Z,$B2FC                            ; $B2E5 28 15
    CALL $C929                            ; $B2E7 cd 29 c9
    JR Z,$B2E2                            ; $B2EA 28 f6
    LD A,($A035)                          ; $B2EC 3a 35 a0
    LD ($B185),A                          ; $B2EF 32 85 b1
    LD HL,$B171                           ; $B2F2 21 71 b1
    INC (HL)                              ; $B2F5 34
    LD A,($B190)                          ; $B2F6 3a 90 b1
    AND A                                 ; $B2F9 a7
    JR Z,$B2E2                            ; $B2FA 28 e6
    LD A,($B185)                          ; $B2FC 3a 85 b1
    LD ($A035),A                          ; $B2FF 32 35 a0
    RET                                   ; $B302 c9
    LD HL,$B6AE                           ; $B303 21 ae b6
    XOR A                                 ; $B306 af
    RET                                   ; $B307 c9
    LD HL,($B17E)                         ; $B308 2a 7e b1
    PUSH HL                               ; $B30B e5
    LD A,($B4A2)                          ; $B30C 3a a2 b4
    PUSH AF                               ; $B30F f5
    CALL $B34F                            ; $B310 cd 4f b3
    CALL $B4C1                            ; $B313 cd c1 b4
    JR Z,$B31E                            ; $B316 28 06
    LD HL,$B170                           ; $B318 21 70 b1
    INC (HL)                              ; $B31B 34
    JR $B313                              ; $B31C 18 f5
    POP AF                                ; $B31E f1
    LD ($B4A2),A                          ; $B31F 32 a2 b4
    LD HL,$B170                           ; $B322 21 70 b1
    LD A,(HL)                             ; $B325 7e
    LD (HL),$00                           ; $B326 36 00
    POP HL                                ; $B328 e1
    LD ($B17E),HL                         ; $B329 22 7e b1
    RET                                   ; $B32C c9
    LD HL,($B180)                         ; $B32D 2a 80 b1
    PUSH HL                               ; $B330 e5
    CALL $B36B                            ; $B331 cd 6b b3
    LD A,($B549)                          ; $B334 3a 49 b5
    PUSH AF                               ; $B337 f5
    CALL $B568                            ; $B338 cd 68 b5
    JR Z,$B343                            ; $B33B 28 06
    LD HL,$B171                           ; $B33D 21 71 b1
    INC (HL)                              ; $B340 34
    JR $B338                              ; $B341 18 f5
    POP AF                                ; $B343 f1
    LD ($B549),A                          ; $B344 32 49 b5
    LD A,($B171)                          ; $B347 3a 71 b1
    POP HL                                ; $B34A e1
    LD ($B180),HL                         ; $B34B 22 80 b1
    RET                                   ; $B34E c9
    XOR A                                 ; $B34F af
    LD ($B170),A                          ; $B350 32 70 b1
    LD A,$FF                              ; $B353 3e ff
    LD ($B4A2),A                          ; $B355 32 a2 b4
    CALL $D04F                            ; $B358 cd 4f d0
    LD A,($A00F)                          ; $B35B 3a 0f a0
    CP $07                                ; $B35E fe 07
    JR NC,$B366                           ; $B360 30 04
    LD IX,$0000                           ; $B362 dd 21 00 00
    LD ($B17E),IX                         ; $B366 dd 22 7e b1
    RET                                   ; $B36A c9
    XOR A                                 ; $B36B af
    LD ($B171),A                          ; $B36C 32 71 b1
    LD A,$FF                              ; $B36F 3e ff
    LD ($B549),A                          ; $B371 32 49 b5
    CALL $D04F                            ; $B374 cd 4f d0
    LD A,($A010)                          ; $B377 3a 10 a0
    CP $07                                ; $B37A fe 07
    JR NC,$B382                           ; $B37C 30 04
    LD IX,$0000                           ; $B37E dd 21 00 00
    LD ($B180),IX                         ; $B382 dd 22 80 b1
    RET                                   ; $B386 c9
    LD A,($A01D)                          ; $B387 3a 1d a0
    BIT 2,A                               ; $B38A cb 57
    RET Z                                 ; $B38C c8
    LD HL,$B16E                           ; $B38D 21 6e b1
    BIT 0,(HL)                            ; $B390 cb 46
    RET NZ                                ; $B392 c0
    BIT 1,A                               ; $B393 cb 4f
    JR NZ,$B39A                           ; $B395 20 03
    OR $01                                ; $B397 f6 01
    RET                                   ; $B399 c9
    XOR A                                 ; $B39A af
    RET                                   ; $B39B c9

    ORG $B39C
; DATA: ALL lookup flag
    DEFB $00                              ; $B39C 00

    ORG $B39D
; CODE: Semantic role extraction
    PUSH IY                               ; $B39D fd e5
    LD L,(IY+$00)                         ; $B39F fd 6e 00
    LD H,(IY+$01)                         ; $B3A2 fd 66 01
    LD A,H                                ; $B3A5 7c
    AND $80                               ; $B3A6 e6 80
    LD ($B39C),A                          ; $B3A8 32 9c b3
    RES 7,H                               ; $B3AB cb bc
    LD ($B186),HL                         ; $B3AD 22 86 b1
    LD L,(IY+$02)                         ; $B3B0 fd 6e 02
    LD H,(IY+$03)                         ; $B3B3 fd 66 03
    LD ($B18C),HL                         ; $B3B6 22 8c b1
    LD HL,$B188                           ; $B3B9 21 88 b1
    PUSH HL                               ; $B3BC e5
    LD B,$04                              ; $B3BD 06 04
    CALL $A2AB                            ; $B3BF cd ab a2
    POP HL                                ; $B3C2 e1
    LD B,$02                              ; $B3C3 06 02
    LD E,$04                              ; $B3C5 1e 04
    CALL $B483                            ; $B3C7 cd 83 b4
    LD E,$0E                              ; $B3CA 1e 0e
    CALL $B483                            ; $B3CC cd 83 b4
    LD E,$06                              ; $B3CF 1e 06
    CALL $B483                            ; $B3D1 cd 83 b4
    LD E,$10                              ; $B3D4 1e 10
    CALL $B483                            ; $B3D6 cd 83 b4
    XOR A                                 ; $B3D9 af
    LD ($A02E),A                          ; $B3DA 32 2e a0
    LD HL,$B186                           ; $B3DD 21 86 b1
    LD DE,$0008                           ; $B3E0 11 08 00
    LD IX,$8259                           ; $B3E3 dd 21 59 82
    PUSH IX                               ; $B3E7 dd e5
    POP IY                                ; $B3E9 fd e1
    CALL $A4CD                            ; $B3EB cd cd a4
    JR Z,$B3FD                            ; $B3EE 28 0d
    ADD IX,DE                             ; $B3F0 dd 19
    LD A,(IX+$01)                         ; $B3F2 dd 7e 01
    OR (IX+$00)                           ; $B3F5 dd b6 00
    JR NZ,$B3E7                           ; $B3F8 20 ed
    POP IY                                ; $B3FA fd e1
    RET                                   ; $B3FC c9
    POP IY                                ; $B3FD fd e1
    CALL $B405                            ; $B3FF cd 05 b4
    OR $01                                ; $B402 f6 01
    RET                                   ; $B404 c9
    AND A                                 ; $B405 a7
    JR Z,$B416                            ; $B406 28 0e
    LD HL,($B188)                         ; $B408 2a 88 b1
    LD DE,($B18A)                         ; $B40B ed 5b 8a b1
    LD ($B188),DE                         ; $B40F ed 53 88 b1
    LD ($B18A),HL                         ; $B413 22 8a b1
    CALL $A2BD                            ; $B416 cd bd a2
    LD HL,$B188                           ; $B419 21 88 b1
    LD A,(HL)                             ; $B41C 7e
    INC HL                                ; $B41D 23
    OR (HL)                               ; $B41E b6
    JR NZ,$B426                           ; $B41F 20 05
    LD A,($A01E)                          ; $B421 3a 1e a0
    JR $B445                              ; $B424 18 1f
    DEC HL                                ; $B426 2b
    LD A,(HL)                             ; $B427 7e
    CP (IY+$0E)                           ; $B428 fd be 0e
    JR NZ,$B435                           ; $B42B 20 08
    INC HL                                ; $B42D 23
    LD A,(HL)                             ; $B42E 7e
    CP (IY+$0F)                           ; $B42F fd be 0f
    JR Z,$B440                            ; $B432 28 0c
    DEC HL                                ; $B434 2b
    LD A,(HL)                             ; $B435 7e
    CP (IY+$10)                           ; $B436 fd be 10
    JR NZ,$B440                           ; $B439 20 05
    INC HL                                ; $B43B 23
    LD A,(HL)                             ; $B43C 7e
    CP (IY+$11)                           ; $B43D fd be 11
    LD A,($A01D)                          ; $B440 3a 1d a0
    JR NZ,$B447                           ; $B443 20 02
    XOR $20                               ; $B445 ee 20
    BIT 5,A                               ; $B447 cb 6f
    LD BC,$1208                           ; $B449 01 08 12
    JR Z,$B451                            ; $B44C 28 03
    LD BC,$0812                           ; $B44E 01 12 08
    LD HL,$B182                           ; $B451 21 82 b1
    LD (HL),B                             ; $B454 70
    INC HL                                ; $B455 23
    LD (HL),C                             ; $B456 71
    LD A,B                                ; $B457 78
    LD DE,$B172                           ; $B458 11 72 b1
    LD HL,$B16D                           ; $B45B 21 6d b1
    CALL $B468                            ; $B45E cd 68 b4
    LD A,C                                ; $B461 79
    LD DE,$B178                           ; $B462 11 78 b1
    LD HL,$B16E                           ; $B465 21 6e b1
    PUSH BC                               ; $B468 c5
    LD C,A                                ; $B469 4f
    LD B,$00                              ; $B46A 06 00
    PUSH HL                               ; $B46C e5
    PUSH IY                               ; $B46D fd e5
    POP HL                                ; $B46F e1
    ADD HL,BC                             ; $B470 09
    LD BC,$0006                           ; $B471 01 06 00
    LDIR                                  ; $B474 ed b0
    XOR A                                 ; $B476 af
    LD B,$06                              ; $B477 06 06
    DEC HL                                ; $B479 2b
    OR (HL)                               ; $B47A b6
    DJNZ $B479                            ; $B47B 10 fc
    POP HL                                ; $B47D e1
    POP BC                                ; $B47E c1
    RET Z                                 ; $B47F c8
    SET 0,(HL)                            ; $B480 cb c6
    RET                                   ; $B482 c9
    XOR A                                 ; $B483 af
    CP B                                  ; $B484 b8
    RET Z                                 ; $B485 c8
    LD D,$00                              ; $B486 16 00
    PUSH IY                               ; $B488 fd e5
    ADD IY,DE                             ; $B48A fd 19
    LD A,(IY+$00)                         ; $B48C fd 7e 00
    LD (HL),A                             ; $B48F 77
    INC HL                                ; $B490 23
    LD A,(IY+$01)                         ; $B491 fd 7e 01
    LD (HL),A                             ; $B494 77
    DEC HL                                ; $B495 2b
    OR (IY+$00)                           ; $B496 fd b6 00
    POP IY                                ; $B499 fd e1
    RET Z                                 ; $B49B c8
    DEC B                                 ; $B49C 05
    INC HL                                ; $B49D 23
    INC HL                                ; $B49E 23
    RET                                   ; $B49F c9
    JP (IY)                               ; $B4A0 fd e9

    ORG $B4A2
; DATA: First-argument iterator flag
    DEFB $00                              ; $B4A2 00

    ORG $B4A3
; CODE: First-argument selection and exclusion traversal
    LD A,($B4A2)                          ; $B4A3 3a a2 b4
    INC A                                 ; $B4A6 3c
    JR NZ,$B4CF                           ; $B4A7 20 26
    LD ($B4A2),A                          ; $B4A9 32 a2 b4
    LD A,($B173)                          ; $B4AC 3a 73 b1
    BIT 7,A                               ; $B4AF cb 7f
    JR Z,$B4CF                            ; $B4B1 28 1c
    LD A,$FE                              ; $B4B3 3e fe
    LD ($A034),A                          ; $B4B5 32 34 a0
    LD HL,($B172)                         ; $B4B8 2a 72 b1
    LD ($A02F),HL                         ; $B4BB 22 2f a0
    OR $01                                ; $B4BE f6 01
    RET                                   ; $B4C0 c9
    LD A,($A00F)                          ; $B4C1 3a 0f a0
    CP $05                                ; $B4C4 fe 05
    JR Z,$B4A3                            ; $B4C6 28 db
    LD A,($B173)                          ; $B4C8 3a 73 b1
    BIT 7,A                               ; $B4CB cb 7f
    JR Z,$B4D4                            ; $B4CD 28 05
    LD A,$FF                              ; $B4CF 3e ff
    CP $FF                                ; $B4D1 fe ff
    RET                                   ; $B4D3 c9
    PUSH IY                               ; $B4D4 fd e5
    LD IX,($B17E)                         ; $B4D6 dd 2a 7e b1
    LD A,($A01D)                          ; $B4DA 3a 1d a0
    AND $01                               ; $B4DD e6 01
    LD ($A038),A                          ; $B4DF 32 38 a0
    LD A,($A00F)                          ; $B4E2 3a 0f a0
    CP $05                                ; $B4E5 fe 05
    LD IY,$D39B                           ; $B4E7 fd 21 9b d3
    JR C,$B4F1                            ; $B4EB 38 04
    LD IY,$D36A                           ; $B4ED fd 21 6a d3
    CALL $B4FD                            ; $B4F1 cd fd b4
    CP $FF                                ; $B4F4 fe ff
    LD ($B17E),IX                         ; $B4F6 dd 22 7e b1
    POP IY                                ; $B4FA fd e1
    RET                                   ; $B4FC c9
    LD HL,$B172                           ; $B4FD 21 72 b1
    CALL $B4A0                            ; $B500 cd a0 b4
    CP $FF                                ; $B503 fe ff
    RET Z                                 ; $B505 c8
    LD ($A034),A                          ; $B506 32 34 a0
    CALL $B517                            ; $B509 cd 17 b5
    JR NZ,$B4FD                           ; $B50C 20 ef
    LD A,($A034)                          ; $B50E 3a 34 a0
    LD HL,$B16D                           ; $B511 21 6d b1
    SET 1,(HL)                            ; $B514 cb ce
    RET                                   ; $B516 c9
    LD A,($A01C)                          ; $B517 3a 1c a0
    AND A                                 ; $B51A a7
    RET Z                                 ; $B51B c8
    PUSH IY                               ; $B51C fd e5
    PUSH DE                               ; $B51E d5
    PUSH IX                               ; $B51F dd e5
    CALL $AEA9                            ; $B521 cd a9 ae
    BIT 6,(IY+$01)                        ; $B524 fd cb 01 76
    JR Z,$B543                            ; $B528 28 19
    CALL $D04F                            ; $B52A cd 4f d0
    PUSH IY                               ; $B52D fd e5
    POP HL                                ; $B52F e1
    LD DE,$0008                           ; $B530 11 08 00
    ADD HL,DE                             ; $B533 19
    CALL $D36A                            ; $B534 cd 6a d3
    CP $FF                                ; $B537 fe ff
    JR Z,$B521                            ; $B539 28 e6
    LD HL,$A034                           ; $B53B 21 34 a0
    CP (HL)                               ; $B53E be
    JR NZ,$B52D                           ; $B53F 20 ec
    OR $01                                ; $B541 f6 01
    POP IX                                ; $B543 dd e1
    POP DE                                ; $B545 d1
    POP IY                                ; $B546 fd e1
    RET                                   ; $B548 c9

    ORG $B549
; DATA: Second-argument iterator flag
    DEFB $00                              ; $B549 00

    ORG $B54A
; CODE: Second-argument selection
    LD A,($B549)                          ; $B54A 3a 49 b5
    INC A                                 ; $B54D 3c
    JR NZ,$B576                           ; $B54E 20 26
    LD ($B549),A                          ; $B550 32 49 b5
    LD A,($B179)                          ; $B553 3a 79 b1
    BIT 7,A                               ; $B556 cb 7f
    JR Z,$B576                            ; $B558 28 1c
    LD A,$FE                              ; $B55A 3e fe
    LD ($A035),A                          ; $B55C 32 35 a0
    LD HL,($B178)                         ; $B55F 2a 78 b1
    LD ($A031),HL                         ; $B562 22 31 a0
    OR $01                                ; $B565 f6 01
    RET                                   ; $B567 c9
    LD A,($A010)                          ; $B568 3a 10 a0
    CP $05                                ; $B56B fe 05
    JR Z,$B54A                            ; $B56D 28 db
    LD A,($B179)                          ; $B56F 3a 79 b1
    BIT 7,A                               ; $B572 cb 7f
    JR Z,$B57B                            ; $B574 28 05
    LD A,$FF                              ; $B576 3e ff
    CP $FF                                ; $B578 fe ff
    RET                                   ; $B57A c9
    PUSH IY                               ; $B57B fd e5
    LD IX,($B180)                         ; $B57D dd 2a 80 b1
    LD A,($A01D)                          ; $B581 3a 1d a0
    AND $01                               ; $B584 e6 01
    LD ($A038),A                          ; $B586 32 38 a0
    LD A,($A010)                          ; $B589 3a 10 a0
    CP $05                                ; $B58C fe 05
    LD IY,$D39B                           ; $B58E fd 21 9b d3
    JR C,$B598                            ; $B592 38 04
    LD IY,$D36A                           ; $B594 fd 21 6a d3
    CALL $B5A4                            ; $B598 cd a4 b5
    CP $FF                                ; $B59B fe ff
    LD ($B180),IX                         ; $B59D dd 22 80 b1
    POP IY                                ; $B5A1 fd e1
    RET                                   ; $B5A3 c9
    LD HL,$B178                           ; $B5A4 21 78 b1
    CALL $B4A0                            ; $B5A7 cd a0 b4
    CP $FF                                ; $B5AA fe ff
    RET Z                                 ; $B5AC c8
    LD ($A035),A                          ; $B5AD 32 35 a0
    LD HL,$B16E                           ; $B5B0 21 6e b1
    SET 1,(HL)                            ; $B5B3 cb ce
    RET                                   ; $B5B5 c9

    ORG $B5B6
; CODE: Move ambiguous node to pending list
    LD ($A01B),A                          ; $B5B6 32 1b a0
    LD IX,($9FF2)                         ; $B5B9 dd 2a f2 9f
    LD ($9FF0),IX                         ; $B5BD dd 22 f0 9f
    LD L,(IX-$02)                         ; $B5C1 dd 6e fe
    LD H,(IX-$01)                         ; $B5C4 dd 66 ff
    LD ($9FF2),HL                         ; $B5C7 22 f2 9f
    LD (IX-$02),$00                       ; $B5CA dd 36 fe 00
    LD (IX-$01),$00                       ; $B5CE dd 36 ff 00
    RET                                   ; $B5D2 c9

    ORG $B866
; DATA: Request and quote cursor working fields
    DEFB $00,$00,$00,$00                  ; $B866 00 00 00 00

    ORG $B86A
; CODE: Quote consumption and deferred request allocation
    PUSH AF                               ; $B86A f5
    LD IX,$9FEE                           ; $B86B dd 21 ee 9f
    CALL $A0F7                            ; $B86F cd f7 a0
    JR Z,$B8A8                            ; $B872 28 34
    LD C,(IX+$00)                         ; $B874 dd 4e 00
    LD B,(IX+$01)                         ; $B877 dd 46 01
    LD ($B868),BC                         ; $B87A ed 43 68 b8
    LD L,(IX-$02)                         ; $B87E dd 6e fe
    LD H,(IX-$01)                         ; $B881 dd 66 ff
    LD ($9FEC),HL                         ; $B884 22 ec 9f
    CALL $A1C7                            ; $B887 cd c7 a1
    POP AF                                ; $B88A f1
    PUSH AF                               ; $B88B f5
    AND A                                 ; $B88C a7
    JR Z,$B894                            ; $B88D 28 05
    CALL $B8AA                            ; $B88F cd aa b8
    JR Z,$B8A8                            ; $B892 28 14
    LD BC,($B868)                         ; $B894 ed 4b 68 b8
    LD ($A02B),BC                         ; $B898 ed 43 2b a0
    CALL $AE7F                            ; $B89C cd 7f ae
    CP $C0                                ; $B89F fe c0
    JR NZ,$B89C                           ; $B8A1 20 f9
    LD HL,($A029)                         ; $B8A3 2a 29 a0
    LD (HL),$90                           ; $B8A6 36 90
    POP AF                                ; $B8A8 f1
    RET                                   ; $B8A9 c9
    LD HL,($B868)                         ; $B8AA 2a 68 b8
    LD ($A02B),HL                         ; $B8AD 22 2b a0
    XOR A                                 ; $B8B0 af
    LD ($A024),A                          ; $B8B1 32 24 a0
    LD HL,($9FF0)                         ; $B8B4 2a f0 9f
    PUSH HL                               ; $B8B7 e5
    LD HL,$0000                           ; $B8B8 21 00 00
    LD ($9FF0),HL                         ; $B8BB 22 f0 9f
    CALL $AAB2                            ; $B8BE cd b2 aa
    JR Z,$B8C7                            ; $B8C1 28 04
    CP $02                                ; $B8C3 fe 02
    JR NZ,$B904                           ; $B8C5 20 3d
    LD HL,($A02B)                         ; $B8C7 2a 2b a0
    LD A,(HL)                             ; $B8CA 7e
    AND $F0                               ; $B8CB e6 f0
    CP $C0                                ; $B8CD fe c0
    JR NZ,$B8BE                           ; $B8CF 20 ed
    LD (HL),$90                           ; $B8D1 36 90
    LD A,$08                              ; $B8D3 3e 08
    CALL $A11C                            ; $B8D5 cd 1c a1
    LD HL,($9FEE)                         ; $B8D8 2a ee 9f
    LD ($9FEE),IX                         ; $B8DB dd 22 ee 9f
    LD (IX-$02),L                         ; $B8DF dd 75 fe
    LD (IX-$01),H                         ; $B8E2 dd 74 ff
    LD HL,($9FF0)                         ; $B8E5 2a f0 9f
    LD (IX+$05),L                         ; $B8E8 dd 75 05
    LD (IX+$06),H                         ; $B8EB dd 74 06
    POP HL                                ; $B8EE e1
    LD ($9FF0),HL                         ; $B8EF 22 f0 9f
    XOR A                                 ; $B8F2 af
    LD (IX+$01),A                         ; $B8F3 dd 77 01
    LD A,($A034)                          ; $B8F6 3a 34 a0
    LD (IX+$00),A                         ; $B8F9 dd 77 00
    LD A,($A024)                          ; $B8FC 3a 24 a0
    LD (IX+$07),A                         ; $B8FF dd 77 07
    XOR A                                 ; $B902 af
    RET                                   ; $B903 c9
    PUSH AF                               ; $B904 f5
    CALL $D87D                            ; $B905 cd 7d d8
    POP AF                                ; $B908 f1
    POP HL                                ; $B909 e1
    LD ($9FF0),HL                         ; $B90A 22 f0 9f
    RET                                   ; $B90D c9
    CALL $B91F                            ; $B90E cd 1f b9
    LD ($B866),IX                         ; $B911 dd 22 66 b8
    LD E,(IX+$05)                         ; $B915 dd 5e 05
    LD D,(IX+$06)                         ; $B918 dd 56 06
    PUSH DE                               ; $B91B d5
    POP IY                                ; $B91C fd e1
    RET                                   ; $B91E c9
    LD IX,$9FF0                           ; $B91F dd 21 f0 9f
    CALL $A0F7                            ; $B923 cd f7 a0
    JR Z,$B931                            ; $B926 28 09
    LD A,($A036)                          ; $B928 3a 36 a0
    CP (IX+$00)                           ; $B92B dd be 00
    RET Z                                 ; $B92E c8
    JR $B923                              ; $B92F 18 f2
    OR $01                                ; $B931 f6 01
    RET                                   ; $B933 c9

    ORG $B934
; DATA: Request-loop working fields
    DEFB $00,$00                          ; $B934 00 00

    ORG $B936
; CODE: NPC request execution and syntax-node release
    PUSH IX                               ; $B936 dd e5
    PUSH IY                               ; $B938 fd e5
    PUSH HL                               ; $B93A e5
    LD ($B935),A                          ; $B93B 32 35 b9
    CALL $B90E                            ; $B93E cd 0e b9
    LD A,(IX+$07)                         ; $B941 dd 7e 07
    CP $02                                ; $B944 fe 02
    JP Z,$BA20                            ; $B946 ca 20 ba
    LD A,(IX+$01)                         ; $B949 dd 7e 01
    CP $FF                                ; $B94C fe ff
    JR Z,$B98C                            ; $B94E 28 3c
    LD A,($B935)                          ; $B950 3a 35 b9
    LD ($B934),A                          ; $B953 32 34 b9
    LD A,(IX+$02)                         ; $B956 dd 7e 02
    LD ($A01C),A                          ; $B959 32 1c a0
    LD C,(IX+$03)                         ; $B95C dd 4e 03
    LD B,(IX+$04)                         ; $B95F dd 46 04
    LD ($B17E),BC                         ; $B962 ed 43 7e b1
    CALL $B191                            ; $B966 cd 91 b1
    JR Z,$B9B4                            ; $B969 28 49
    LD IX,($B866)                         ; $B96B dd 2a 66 b8
    LD BC,($B17E)                         ; $B96F ed 4b 7e b1
    LD (IX+$03),C                         ; $B973 dd 71 03
    LD (IX+$04),B                         ; $B976 dd 70 04
    LD A,($A01C)                          ; $B979 3a 1c a0
    LD (IX+$02),A                         ; $B97C dd 77 02
    AND A                                 ; $B97F a7
    CALL Z,$B9CA                          ; $B980 cc ca b9
    LD A,$01                              ; $B983 3e 01
    POP HL                                ; $B985 e1
    POP IY                                ; $B986 fd e1
    POP IX                                ; $B988 dd e1
    AND A                                 ; $B98A a7
    RET                                   ; $B98B c9
    LD A,(IX+$02)                         ; $B98C dd 7e 02
    CALL $CEDE                            ; $B98F cd de ce
    LD ($A033),A                          ; $B992 32 33 a0
    LD A,(IX+$03)                         ; $B995 dd 7e 03
    CALL $CEDE                            ; $B998 cd de ce
    LD ($A034),A                          ; $B99B 32 34 a0
    LD A,(IX+$04)                         ; $B99E dd 7e 04
    CALL $CEDE                            ; $B9A1 cd de ce
    LD ($A035),A                          ; $B9A4 32 35 a0
    CALL $B9FA                            ; $B9A7 cd fa b9
    JR $B983                              ; $B9AA 18 d7
    CALL $B9CA                            ; $B9AC cd ca b9
    JR NZ,$B9AC                           ; $B9AF 20 fb
    XOR A                                 ; $B9B1 af
    JR $B985                              ; $B9B2 18 d1
    LD A,($A01C)                          ; $B9B4 3a 1c a0
    AND A                                 ; $B9B7 a7
    JR Z,$B9AC                            ; $B9B8 28 f2
    LD IX,($B866)                         ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                       ; $B9BE dd 36 02 00
    CALL $B9CA                            ; $B9C2 cd ca b9
    JR Z,$B9B1                            ; $B9C5 28 ea
    JP $B93E                              ; $B9C7 c3 3e b9
    LD IX,($B866)                         ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                         ; $B9CE fd 6e fe
    LD H,(IY-$01)                         ; $B9D1 fd 66 ff
    LD (IX+$05),L                         ; $B9D4 dd 75 05
    LD (IX+$06),H                         ; $B9D7 dd 74 06
    PUSH IX                               ; $B9DA dd e5
    PUSH IY                               ; $B9DC fd e5
    POP IX                                ; $B9DE dd e1
    CALL $A1C7                            ; $B9E0 cd c7 a1
    POP IX                                ; $B9E3 dd e1
    LD A,L                                ; $B9E5 7d
    OR H                                  ; $B9E6 b4
    JR Z,$B9F5                            ; $B9E7 28 0c
    PUSH HL                               ; $B9E9 e5
    POP IY                                ; $B9EA fd e1
    BIT 6,(IY+$01)                        ; $B9EC fd cb 01 76
    JR NZ,$B9CE                           ; $B9F0 20 dc
    OR $01                                ; $B9F2 f6 01
    RET                                   ; $B9F4 c9
    CALL $B9FA                            ; $B9F5 cd fa b9
    XOR A                                 ; $B9F8 af
    RET                                   ; $B9F9 c9
    LD IY,$9FEE                           ; $B9FA fd 21 ee 9f
    PUSH IX                               ; $B9FE dd e5
    POP DE                                ; $BA00 d1
    CALL $A104                            ; $BA01 cd 04 a1
    LD L,(IX-$02)                         ; $BA04 dd 6e fe
    LD H,(IX-$01)                         ; $BA07 dd 66 ff
    LD (IY-$02),L                         ; $BA0A fd 75 fe
    LD (IY-$01),H                         ; $BA0D fd 74 ff
    JP $A1C7                              ; $BA10 c3 c7 a1

    ORG $D7FC
; CODE: Player semantic loop and list release
    XOR A                                 ; $D7FC af
    LD A,($D6B8)                          ; $D7FD 3a b8 d6
    LD ($A01C),A                          ; $D800 32 1c a0
    LD IY,($9FF2)                         ; $D803 fd 2a f2 9f
    LD HL,($D6BB)                         ; $D807 2a bb d6
    LD ($B17E),HL                         ; $D80A 22 7e b1
    CALL $B191                            ; $D80D cd 91 b1
    LD A,$01                              ; $D810 3e 01
    LD ($A00B),A                          ; $D812 32 0b a0
    JP Z,$D85B                            ; $D815 ca 5b d8
    LD A,($A01C)                          ; $D818 3a 1c a0
    LD ($D6B8),A                          ; $D81B 32 b8 d6
    LD A,$01                              ; $D81E 3e 01
    LD ($A026),A                          ; $D820 32 26 a0
    LD A,($A033)                          ; $D823 3a 33 a0
    LD ($9FD6),A                          ; $D826 32 d6 9f
    LD HL,($A034)                         ; $D829 2a 34 a0
    LD ($9FD7),HL                         ; $D82C 22 d7 9f
    LD HL,($B17E)                         ; $D82F 2a 7e b1
    LD ($D6BB),HL                         ; $D832 22 bb d6
    LD A,($D6B8)                          ; $D835 3a b8 d6
    AND A                                 ; $D838 a7
    JR NZ,$D858                           ; $D839 20 1d
    LD IX,($9FF2)                         ; $D83B dd 2a f2 9f
    LD L,(IX-$02)                         ; $D83F dd 6e fe
    LD H,(IX-$01)                         ; $D842 dd 66 ff
    LD ($9FF2),HL                         ; $D845 22 f2 9f
    CALL $A1C7                            ; $D848 cd c7 a1
    LD A,L                                ; $D84B 7d
    OR H                                  ; $D84C b4
    JR Z,$D858                            ; $D84D 28 09
    PUSH HL                               ; $D84F e5
    POP IX                                ; $D850 dd e1
    BIT 6,(IX+$01)                        ; $D852 dd cb 01 76
    JR NZ,$D83F                           ; $D856 20 e7
    OR $01                                ; $D858 f6 01
    RET                                   ; $D85A c9
    XOR A                                 ; $D85B af
    LD ($D6B8),A                          ; $D85C 32 b8 d6
    LD A,($A01C)                          ; $D85F 3a 1c a0
    AND A                                 ; $D862 a7
    JR Z,$D870                            ; $D863 28 0b
    LD A,$FF                              ; $D865 3e ff
    LD ($A033),A                          ; $D867 32 33 a0
    CALL $D835                            ; $D86A cd 35 d8
    JP $DC15                              ; $D86D c3 15 dc
    LD A,$01                              ; $D870 3e 01
    LD ($D7E0),A                          ; $D872 32 e0 d7
    PUSH HL                               ; $D875 e5
    LD HL,($D6BD)                         ; $D876 2a bd d6
    LD (HL),$C0                           ; $D879 36 c0
    POP HL                                ; $D87B e1
    RET                                   ; $D87C c9
    LD IX,($9FF0)                         ; $D87D dd 2a f0 9f
    LD HL,$0000                           ; $D881 21 00 00
    LD ($9FF0),HL                         ; $D884 22 f0 9f
    JP $A1AF                              ; $D887 c3 af a1
    LD IX,($9FF2)                         ; $D88A dd 2a f2 9f
    LD HL,$0000                           ; $D88E 21 00 00
    LD ($9FF2),HL                         ; $D891 22 f2 9f
    JP $A1AF                              ; $D894 c3 af a1

    ORG $D898
; CODE: Editor, quote closure, capacity and repeat key
    LD HL,$0BB8                           ; $D898 21 b8 0b
    LD ($A03B),HL                         ; $D89B 22 3b a0
    LD A,$01                              ; $D89E 3e 01
    LD ($A027),A                          ; $D8A0 32 27 a0
    CALL $D8AD                            ; $D8A3 cd ad d8
    PUSH AF                               ; $D8A6 f5
    XOR A                                 ; $D8A7 af
    LD ($A027),A                          ; $D8A8 32 27 a0
    POP AF                                ; $D8AB f1
    RET                                   ; $D8AC c9
    LD A,$3E                              ; $D8AD 3e 3e
    CALL $A9B7                            ; $D8AF cd b7 a9
    LD A,$20                              ; $D8B2 3e 20
    CALL $A9B7                            ; $D8B4 cd b7 a9
    LD HL,$5B00                           ; $D8B7 21 00 5b
    LD B,$80                              ; $D8BA 06 80
    LD A,$01                              ; $D8BC 3e 01
    LD ($D897),A                          ; $D8BE 32 97 d8
    LD C,$00                              ; $D8C1 0e 00
    CALL $A536                            ; $D8C3 cd 36 a5
    JP Z,$D9AC                            ; $D8C6 ca ac d9
    BIT 7,B                               ; $D8C9 cb 78
    JR Z,$D8D2                            ; $D8CB 28 05
    CP $40                                ; $D8CD fe 40
    JP Z,$D99E                            ; $D8CF ca 9e d9
    BIT 0,C                               ; $D8D2 cb 41
    CALL Z,$D978                          ; $D8D4 cc 78 d9
    LD C,$01                              ; $D8D7 0e 01
    CP $18                                ; $D8D9 fe 18
    JR NZ,$D8E2                           ; $D8DB 20 05
    CALL $D9B7                            ; $D8DD cd b7 d9
    JR $D8BC                              ; $D8E0 18 da
    CP $08                                ; $D8E2 fe 08
    JR NZ,$D900                           ; $D8E4 20 1a
    BIT 7,B                               ; $D8E6 cb 78
    JR NZ,$D8C3                           ; $D8E8 20 d9
    LD A,$08                              ; $D8EA 3e 08
    CALL $A9B7                            ; $D8EC cd b7 a9
    INC B                                 ; $D8EF 04
    DEC HL                                ; $D8F0 2b
    LD A,(HL)                             ; $D8F1 7e
    CP $22                                ; $D8F2 fe 22
    JR NZ,$D8C3                           ; $D8F4 20 cd
    LD A,($D897)                          ; $D8F6 3a 97 d8
    XOR $01                               ; $D8F9 ee 01
    LD ($D897),A                          ; $D8FB 32 97 d8
    JR $D8C3                              ; $D8FE 18 c3
    CP $40                                ; $D900 fe 40
    JR NC,$D93C                           ; $D902 30 38
    CP $22                                ; $D904 fe 22
    JR NZ,$D917                           ; $D906 20 0f
    LD A,($D897)                          ; $D908 3a 97 d8
    XOR $01                               ; $D90B ee 01
    LD ($D897),A                          ; $D90D 32 97 d8
    CALL NZ,$D968                         ; $D910 c4 68 d9
    LD A,$22                              ; $D913 3e 22
    JR $D93C                              ; $D915 18 25
    CP $20                                ; $D917 fe 20
    JR Z,$D93C                            ; $D919 28 21
    CP $0D                                ; $D91B fe 0d
    JR Z,$D949                            ; $D91D 28 2a
    CP $2E                                ; $D91F fe 2e
    JR Z,$D93C                            ; $D921 28 19
    CP $2C                                ; $D923 fe 2c
    JR Z,$D93C                            ; $D925 28 15
    CP $2F                                ; $D927 fe 2f
    JR Z,$D93C                            ; $D929 28 11
    CP $60                                ; $D92B fe 60
    JR Z,$D93C                            ; $D92D 28 0d
    CP $2D                                ; $D92F fe 2d
    JR Z,$D93C                            ; $D931 28 09
    CP $3A                                ; $D933 fe 3a
    JR Z,$D93C                            ; $D935 28 05
    CALL $DAE8                            ; $D937 cd e8 da
    JR C,$D8C3                            ; $D93A 38 87
    DEC B                                 ; $D93C 05
    INC B                                 ; $D93D 04
    JR Z,$D946                            ; $D93E 28 06
    LD (HL),A                             ; $D940 77
    CALL $A9B7                            ; $D941 cd b7 a9
    INC HL                                ; $D944 23
    DEC B                                 ; $D945 05
    JP $D8C3                              ; $D946 c3 c3 d8
    LD A,($D897)                          ; $D949 3a 97 d8
    AND A                                 ; $D94C a7
    CALL Z,$D95C                          ; $D94D cc 5c d9
    CALL $D968                            ; $D950 cd 68 d9
    LD A,$0D                              ; $D953 3e 0d
    LD (HL),A                             ; $D955 77
    CALL $A9B7                            ; $D956 cd b7 a9
    OR $01                                ; $D959 f6 01
    RET                                   ; $D95B c9
    CALL $D968                            ; $D95C cd 68 d9
    LD A,$22                              ; $D95F 3e 22
    LD (HL),A                             ; $D961 77
    CALL $A9B7                            ; $D962 cd b7 a9
    INC HL                                ; $D965 23
    DEC B                                 ; $D966 05
    RET                                   ; $D967 c9
    DEC HL                                ; $D968 2b
    LD A,(HL)                             ; $D969 7e
    CP $2E                                ; $D96A fe 2e
    JR Z,$D976                            ; $D96C 28 08
    INC HL                                ; $D96E 23
    DEC B                                 ; $D96F 05
    LD A,$2E                              ; $D970 3e 2e
    LD (HL),A                             ; $D972 77
    CALL $A9B7                            ; $D973 cd b7 a9
    INC HL                                ; $D976 23
    RET                                   ; $D977 c9
    CP $09                                ; $D978 fe 09
    JR Z,$D996                            ; $D97A 28 1a
    CP $08                                ; $D97C fe 08
    JR Z,$D99A                            ; $D97E 28 1a
    CP $0A                                ; $D980 fe 0a
    JR Z,$D992                            ; $D982 28 0e
    CP $5B                                ; $D984 fe 5b
    RET NZ                                ; $D986 c0
    LD A,$4E                              ; $D987 3e 4e
    LD (HL),A                             ; $D989 77
    INC HL                                ; $D98A 23
    CALL $A9B7                            ; $D98B cd b7 a9
    DEC B                                 ; $D98E 05
    LD A,$0D                              ; $D98F 3e 0d
    RET                                   ; $D991 c9
    LD A,$53                              ; $D992 3e 53
    JR $D989                              ; $D994 18 f3
    LD A,$45                              ; $D996 3e 45
    JR $D989                              ; $D998 18 ef
    LD A,$57                              ; $D99A 3e 57
    JR $D989                              ; $D99C 18 eb
    LD A,($A01B)                          ; $D99E 3a 1b a0
    AND A                                 ; $D9A1 a7
    JP NZ,$D8C3                           ; $D9A2 c2 c3 d8
    LD A,$01                              ; $D9A5 3e 01
    LD ($D714),A                          ; $D9A7 32 14 d7
    OR $01                                ; $D9AA f6 01
    PUSH AF                               ; $D9AC f5
    LD A,$08                              ; $D9AD 3e 08
    CALL $A9B7                            ; $D9AF cd b7 a9
    CALL $A9B7                            ; $D9B2 cd b7 a9
    POP AF                                ; $D9B5 f1
    RET                                   ; $D9B6 c9
    BIT 7,B                               ; $D9B7 cb 78
    RET NZ                                ; $D9B9 c0
    LD A,$08                              ; $D9BA 3e 08
    CALL $A9B7                            ; $D9BC cd b7 a9
    INC B                                 ; $D9BF 04
    DEC HL                                ; $D9C0 2b
    JR $D9B7                              ; $D9C1 18 f4

    ORG $DAEF
; CODE: Numeric time scanner and suffix/period cursor
    CALL $DBF7                            ; $DAEF cd f7 db
    LD B,A                                ; $DAF2 47
    LD A,(HL)                             ; $DAF3 7e
    CP $3A                                ; $DAF4 fe 3a
    JR Z,$DB05                            ; $DAF6 28 0d
    CP $41                                ; $DAF8 fe 41
    JR Z,$DB05                            ; $DAFA 28 09
    CP $50                                ; $DAFC fe 50
    JR Z,$DB05                            ; $DAFE 28 05
    CALL $DB56                            ; $DB00 cd 56 db
    JR NZ,$DB84                           ; $DB03 20 7f
    LD A,B                                ; $DB05 78
    CP $3C                                ; $DB06 fe 3c
    JR NC,$DB4F                           ; $DB08 30 45
    SET 7,B                               ; $DB0A cb f8
    LD C,$00                              ; $DB0C 0e 00
    LD A,(HL)                             ; $DB0E 7e
    CALL $DB56                            ; $DB0F cd 56 db
    JR Z,$DB60                            ; $DB12 28 4c
    CP $3A                                ; $DB14 fe 3a
    JR NZ,$DB21                           ; $DB16 20 09
    INC HL                                ; $DB18 23
    CALL $DBF7                            ; $DB19 cd f7 db
    LD C,A                                ; $DB1C 4f
    CP $3C                                ; $DB1D fe 3c
    JR NC,$DB4F                           ; $DB1F 30 2e
    LD A,(HL)                             ; $DB21 7e
    CALL $DB56                            ; $DB22 cd 56 db
    JR Z,$DB60                            ; $DB25 28 39
    CP $41                                ; $DB27 fe 41
    JR NZ,$DB30                           ; $DB29 20 05
    SET 6,B                               ; $DB2B cb f0
    INC HL                                ; $DB2D 23
    JR $DB37                              ; $DB2E 18 07
    CP $50                                ; $DB30 fe 50
    JR NZ,$DB4F                           ; $DB32 20 1b
    SET 6,C                               ; $DB34 cb f1
    INC HL                                ; $DB36 23
    LD A,(HL)                             ; $DB37 7e
    CP $4D                                ; $DB38 fe 4d
    JR NZ,$DB4F                           ; $DB3A 20 13
    INC HL                                ; $DB3C 23
    LD A,(HL)                             ; $DB3D 7e
    CP $2E                                ; $DB3E fe 2e
    JR Z,$DB3C                            ; $DB40 28 fa
    CALL $DB59                            ; $DB42 cd 59 db
    JR Z,$DB60                            ; $DB45 28 19
    CP $0D                                ; $DB47 fe 0d
    JR Z,$DB5F                            ; $DB49 28 14
    CP $22                                ; $DB4B fe 22
    JR Z,$DB5F                            ; $DB4D 28 10
    XOR A                                 ; $DB4F af
    LD A,$D0                              ; $DB50 3e d0
    LD BC,$0000                           ; $DB52 01 00 00
    RET                                   ; $DB55 c9
    CP $2E                                ; $DB56 fe 2e
    RET Z                                 ; $DB58 c8
    CP $2C                                ; $DB59 fe 2c
    RET Z                                 ; $DB5B c8
    CP $20                                ; $DB5C fe 20
    RET                                   ; $DB5E c9
    DEC HL                                ; $DB5F 2b
    XOR A                                 ; $DB60 af
    LD A,$F0                              ; $DB61 3e f0
    RET                                   ; $DB63 c9

    ORG $DB64
; DATA: Money fields
    DEFB $00,$00,$00                      ; $DB64 00 00 00

    ORG $DB67
; CODE: Currency scanner and rotating decimal accumulator
    INC HL                                ; $DB67 23
    CALL $DBF7                            ; $DB68 cd f7 db
    LD ($DB64),A                          ; $DB6B 32 64 db
    XOR A                                 ; $DB6E af
    LD ($DB65),A                          ; $DB6F 32 65 db
    LD ($DB66),A                          ; $DB72 32 66 db
    INC HL                                ; $DB75 23
    LD A,(HL)                             ; $DB76 7e
    CALL $DAE8                            ; $DB77 cd e8 da
    DEC HL                                ; $DB7A 2b
    JR C,$DBC0                            ; $DB7B 38 43
    INC HL                                ; $DB7D 23
    CALL $DBF7                            ; $DB7E cd f7 db
    LD B,A                                ; $DB81 47
    JR $DB88                              ; $DB82 18 04
    XOR A                                 ; $DB84 af
    LD ($DB64),A                          ; $DB85 32 64 db
    XOR A                                 ; $DB88 af
    LD ($DB65),A                          ; $DB89 32 65 db
    LD ($DB66),A                          ; $DB8C 32 66 db
    LD A,(HL)                             ; $DB8F 7e
    CP $53                                ; $DB90 fe 53
    JR NZ,$DB9A                           ; $DB92 20 06
    LD A,B                                ; $DB94 78
    LD ($DB65),A                          ; $DB95 32 65 db
    JR $DBBF                              ; $DB98 18 25
    CP $44                                ; $DB9A fe 44
    JR NZ,$DBA4                           ; $DB9C 20 06
    LD A,B                                ; $DB9E 78
    LD ($DB66),A                          ; $DB9F 32 66 db
    JR $DB98                              ; $DBA2 18 f4
    CP $2F                                ; $DBA4 fe 2f
    JR NZ,$DB4F                           ; $DBA6 20 a7
    LD A,B                                ; $DBA8 78
    LD ($DB65),A                          ; $DBA9 32 65 db
    INC HL                                ; $DBAC 23
    LD A,(HL)                             ; $DBAD 7e
    CP $2D                                ; $DBAE fe 2d
    JR Z,$DBBF                            ; $DBB0 28 0d
    CALL $DAE8                            ; $DBB2 cd e8 da
    JR C,$DB4F                            ; $DBB5 38 98
    CALL $DBF7                            ; $DBB7 cd f7 db
    LD ($DB66),A                          ; $DBBA 32 66 db
    JR $DBC0                              ; $DBBD 18 01
    INC HL                                ; $DBBF 23
    PUSH HL                               ; $DBC0 e5
    LD A,($DB64)                          ; $DBC1 3a 64 db
    LD L,A                                ; $DBC4 6f
    LD H,$00                              ; $DBC5 26 00
    ADD HL,HL                             ; $DBC7 29
    ADD HL,HL                             ; $DBC8 29
    LD E,L                                ; $DBC9 5d
    LD D,H                                ; $DBCA 54
    ADD HL,HL                             ; $DBCB 29
    ADD HL,HL                             ; $DBCC 29
    ADD HL,DE                             ; $DBCD 19
    LD A,($DB65)                          ; $DBCE 3a 65 db
    LD E,A                                ; $DBD1 5f
    LD D,$00                              ; $DBD2 16 00
    ADD HL,DE                             ; $DBD4 19
    ADD HL,HL                             ; $DBD5 29
    ADD HL,HL                             ; $DBD6 29
    LD E,L                                ; $DBD7 5d
    LD D,H                                ; $DBD8 54
    ADD HL,HL                             ; $DBD9 29
    ADD HL,DE                             ; $DBDA 19
    LD A,($DB66)                          ; $DBDB 3a 66 db
    LD E,A                                ; $DBDE 5f
    LD D,$00                              ; $DBDF 16 00
    ADD HL,DE                             ; $DBE1 19
    EX (SP),HL                            ; $DBE2 e3
    POP BC                                ; $DBE3 c1
    LD A,B                                ; $DBE4 78
    CP $40                                ; $DBE5 fe 40
    JP NC,$DB4F                           ; $DBE7 d2 4f db
    SLA C                                 ; $DBEA cb 21
    RL B                                  ; $DBEC cb 10
    SRL C                                 ; $DBEE cb 39
    SET 7,C                               ; $DBF0 cb f9
    SET 7,B                               ; $DBF2 cb f8
    JP $DB3D                              ; $DBF4 c3 3d db
    PUSH BC                               ; $DBF7 c5
    LD C,$00                              ; $DBF8 0e 00
    LD A,(HL)                             ; $DBFA 7e
    CALL $DAE8                            ; $DBFB cd e8 da
    JR C,$DC10                            ; $DBFE 38 10
    SUB $30                               ; $DC00 d6 30
    LD B,A                                ; $DC02 47
    RLC C                                 ; $DC03 cb 01
    LD A,C                                ; $DC05 79
    RLC C                                 ; $DC06 cb 01
    RLC C                                 ; $DC08 cb 01
    ADD A,C                               ; $DC0A 81
    ADD A,B                               ; $DC0B 80
    LD C,A                                ; $DC0C 4f
    INC HL                                ; $DC0D 23
    JR $DBFA                              ; $DC0E 18 ea
    LD A,C                                ; $DC10 79
    POP BC                                ; $DC11 c1
    RET                                   ; $DC12 c9

    ORG $E1D6
; DATA: TELL rule header
    DEFB $0D,$17                          ; $E1D6 0d 17

    ORG $E1D8
; CODE: TELL topic lookup
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
    CALL $D34E                            ; $E201 cd 4e d3
    CP $FF                                ; $E204 fe ff
    RET                                   ; $E206 c9
    LD IX,$E22A                           ; $E207 dd 21 2a e2
    CP (IX+$00)                           ; $E20B dd be 00
    JR Z,$E1F9                            ; $E20E 28 e9
    PUSH AF                               ; $E210 f5
    LD A,(IX+$00)                         ; $E211 dd 7e 00
    CP $FE                                ; $E214 fe fe
    JR Z,$E1F8                            ; $E216 28 e0
    INC A                                 ; $E218 3c
    JR Z,$E227                            ; $E219 28 0c
    INC IX                                ; $E21B dd 23
    LD A,$FF                              ; $E21D 3e ff
    CALL $D34E                            ; $E21F cd 4e d3
    INC IX                                ; $E222 dd 23
    POP AF                                ; $E224 f1
    JR $E20B                              ; $E225 18 e4
    POP AF                                ; $E227 f1
    XOR A                                 ; $E228 af
    RET                                   ; $E229 c9
