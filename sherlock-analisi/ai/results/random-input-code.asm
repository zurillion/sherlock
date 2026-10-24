; Entropy source listing. Original bytes are never executed by JavaScript.

    ORG $A0F7
; CODE: list navigation. Runtime-written absolute targets are excluded by the JS exporter.
    PUSH HL                             ; $A0F7 e5
    LD L,(IX-$02)                       ; $A0F8 dd 6e fe
    LD H,(IX-$01)                       ; $A0FB dd 66 ff
    LD A,L                              ; $A0FE 7d
    OR H                                ; $A0FF b4
    EX (SP),HL                          ; $A100 e3
    POP IX                              ; $A101 dd e1
    RET                                 ; $A103 c9
    INC IY                              ; $A104 fd 23
    INC IY                              ; $A106 fd 23
    LD L,(IY-$02)                       ; $A108 fd 6e fe
    LD H,(IY-$01)                       ; $A10B fd 66 ff
    AND A                               ; $A10E a7
    PUSH HL                             ; $A10F e5
    SBC HL,DE                           ; $A110 ed 52
    JR Z,$A118                          ; $A112 28 04
    POP IY                              ; $A114 fd e1
    JR $A108                            ; $A116 18 f0
    POP HL                              ; $A118 e1
    RET                                 ; $A119 c9

    ORG $A11C
; CODE: record allocation/release. Runtime-written absolute targets are excluded by the JS exporter.
    PUSH IY                             ; $A11C fd e5
    PUSH HL                             ; $A11E e5
    PUSH DE                             ; $A11F d5
    PUSH BC                             ; $A120 c5
    ADD A,$03                           ; $A121 c6 03
    LD C,A                              ; $A123 4f
    LD B,$00                            ; $A124 06 00
    LD HL,($9FE3)                       ; $A126 2a e3 9f
    LD IY,$9FE3                         ; $A129 fd 21 e3 9f
    LD A,L                              ; $A12D 7d
    OR H                                ; $A12E b4
    JR Z,$A160                          ; $A12F 28 2f
    LD E,(HL)                           ; $A131 5e
    INC HL                              ; $A132 23
    LD D,(HL)                           ; $A133 56
    INC HL                              ; $A134 23
    LD A,D                              ; $A135 7a
    AND A                               ; $A136 a7
    JR NZ,$A13D                         ; $A137 20 04
    LD A,E                              ; $A139 7b
    CP C                                ; $A13A b9
    JR C,$A157                          ; $A13B 38 1a
    BIT 0,B                             ; $A13D cb 40
    JR Z,$A14E                          ; $A13F 28 0d
    PUSH HL                             ; $A141 e5
    LD L,(IX-$02)                       ; $A142 dd 6e fe
    LD H,(IX-$01)                       ; $A145 dd 66 ff
    AND A                               ; $A148 a7
    SBC HL,DE                           ; $A149 ed 52
    POP HL                              ; $A14B e1
    JR C,$A157                          ; $A14C 38 09
    PUSH HL                             ; $A14E e5
    POP IX                              ; $A14F dd e1
    LD ($A11A),IY                       ; $A151 fd 22 1a a1
    SET 0,B                             ; $A155 cb c0
    PUSH HL                             ; $A157 e5
    POP IY                              ; $A158 fd e1
    LD E,(HL)                           ; $A15A 5e
    INC HL                              ; $A15B 23
    LD D,(HL)                           ; $A15C 56
    EX DE,HL                            ; $A15D eb
    JR $A12D                            ; $A15E 18 cd
    BIT 0,B                             ; $A160 cb 40
    JR Z,$A1AC                          ; $A162 28 48
    LD L,(IX-$02)                       ; $A164 dd 6e fe
    LD H,(IX-$01)                       ; $A167 dd 66 ff
    LD B,$00                            ; $A16A 06 00
    AND A                               ; $A16C a7
    SBC HL,BC                           ; $A16D ed 42
    LD A,H                              ; $A16F 7c
    AND A                               ; $A170 a7
    JR NZ,$A18A                         ; $A171 20 17
    LD A,L                              ; $A173 7d
    CP $04                              ; $A174 fe 04
    JR NC,$A18A                         ; $A176 30 12
    LD IY,($A11A)                       ; $A178 fd 2a 1a a1
    LD A,(IX+$00)                       ; $A17C dd 7e 00
    LD (IY+$00),A                       ; $A17F fd 77 00
    LD A,(IX+$01)                       ; $A182 dd 7e 01
    LD (IY+$01),A                       ; $A185 fd 77 01
    JR $A193                            ; $A188 18 09
    LD (IX-$02),L                       ; $A18A dd 75 fe
    LD (IX-$01),H                       ; $A18D dd 74 ff
    EX DE,HL                            ; $A190 eb
    ADD IX,DE                           ; $A191 dd 19
    INC IX                              ; $A193 dd 23
    LD (IX-$03),C                       ; $A195 dd 71 fd
    PUSH IX                             ; $A198 dd e5
    POP HL                              ; $A19A e1
    DEC HL                              ; $A19B 2b
    DEC HL                              ; $A19C 2b
    LD B,C                              ; $A19D 41
    DEC B                               ; $A19E 05
    XOR A                               ; $A19F af
    LD (HL),A                           ; $A1A0 77
    INC HL                              ; $A1A1 23
    DJNZ $A1A0                          ; $A1A2 10 fc
    OR $01                              ; $A1A4 f6 01
    POP BC                              ; $A1A6 c1
    POP DE                              ; $A1A7 d1
    POP HL                              ; $A1A8 e1
    POP IY                              ; $A1A9 fd e1
    RET                                 ; $A1AB c9
    JP $C1D8                            ; $A1AC c3 d8 c1
    PUSH HL                             ; $A1AF e5
    PUSH IX                             ; $A1B0 dd e5
    POP HL                              ; $A1B2 e1
    JR $A1C1                            ; $A1B3 18 0c
    LD L,(IX-$02)                       ; $A1B5 dd 6e fe
    LD H,(IX-$01)                       ; $A1B8 dd 66 ff
    CALL $A1C7                          ; $A1BB cd c7 a1
    PUSH HL                             ; $A1BE e5
    POP IX                              ; $A1BF dd e1
    LD A,L                              ; $A1C1 7d
    OR H                                ; $A1C2 b4
    JR NZ,$A1B5                         ; $A1C3 20 f0
    POP HL                              ; $A1C5 e1
    RET                                 ; $A1C6 c9
    PUSH HL                             ; $A1C7 e5
    PUSH DE                             ; $A1C8 d5
    PUSH IX                             ; $A1C9 dd e5
    POP HL                              ; $A1CB e1
    DEC HL                              ; $A1CC 2b
    DEC HL                              ; $A1CD 2b
    DEC HL                              ; $A1CE 2b
    LD IX,$9FE3                         ; $A1CF dd 21 e3 9f
    LD E,(IX+$00)                       ; $A1D3 dd 5e 00
    LD D,(IX+$01)                       ; $A1D6 dd 56 01
    LD A,D                              ; $A1D9 7a
    OR E                                ; $A1DA b3
    JR Z,$A1EB                          ; $A1DB 28 0e
    PUSH HL                             ; $A1DD e5
    AND A                               ; $A1DE a7
    SBC HL,DE                           ; $A1DF ed 52
    POP HL                              ; $A1E1 e1
    JR C,$A1EB                          ; $A1E2 38 07
    INC DE                              ; $A1E4 13
    INC DE                              ; $A1E5 13
    PUSH DE                             ; $A1E6 d5
    POP IX                              ; $A1E7 dd e1
    JR $A1D3                            ; $A1E9 18 e8
    LD (IX+$00),L                       ; $A1EB dd 75 00
    LD (IX+$01),H                       ; $A1EE dd 74 01
    INC HL                              ; $A1F1 23
    LD (HL),$00                         ; $A1F2 36 00
    INC HL                              ; $A1F4 23
    LD (HL),E                           ; $A1F5 73
    INC HL                              ; $A1F6 23
    LD (HL),D                           ; $A1F7 72
    CALL $A20C                          ; $A1F8 cd 0c a2
    JR Z,$A206                          ; $A1FB 28 09
    LD L,(IX+$00)                       ; $A1FD dd 6e 00
    LD H,(IX+$01)                       ; $A200 dd 66 01
    PUSH HL                             ; $A203 e5
    POP IX                              ; $A204 dd e1
    CALL $A20C                          ; $A206 cd 0c a2
    POP DE                              ; $A209 d1
    POP HL                              ; $A20A e1
    RET                                 ; $A20B c9
    PUSH IX                             ; $A20C dd e5
    POP HL                              ; $A20E e1
    DEC HL                              ; $A20F 2b
    DEC HL                              ; $A210 2b
    LD E,(IX-$02)                       ; $A211 dd 5e fe
    LD D,(IX-$01)                       ; $A214 dd 56 ff
    ADD HL,DE                           ; $A217 19
    LD E,(IX+$00)                       ; $A218 dd 5e 00
    LD D,(IX+$01)                       ; $A21B dd 56 01
    LD A,D                              ; $A21E 7a
    OR E                                ; $A21F b3
    JR NZ,$A225                         ; $A220 20 03
    OR $01                              ; $A222 f6 01
    RET                                 ; $A224 c9
    AND A                               ; $A225 a7
    SBC HL,DE                           ; $A226 ed 52
    RET NZ                              ; $A228 c0
    LD L,(IX+$00)                       ; $A229 dd 6e 00
    LD H,(IX+$01)                       ; $A22C dd 66 01
    PUSH BC                             ; $A22F c5
    LD E,(HL)                           ; $A230 5e
    INC HL                              ; $A231 23
    LD D,(HL)                           ; $A232 56
    INC HL                              ; $A233 23
    LD C,(HL)                           ; $A234 4e
    INC HL                              ; $A235 23
    LD B,(HL)                           ; $A236 46
    LD L,(IX-$02)                       ; $A237 dd 6e fe
    LD H,(IX-$01)                       ; $A23A dd 66 ff
    ADD HL,DE                           ; $A23D 19
    LD (IX-$02),L                       ; $A23E dd 75 fe
    LD (IX-$01),H                       ; $A241 dd 74 ff
    LD (IX+$00),C                       ; $A244 dd 71 00
    LD (IX+$01),B                       ; $A247 dd 70 01
    POP BC                              ; $A24A c1
    XOR A                               ; $A24B af
    RET                                 ; $A24C c9

    ORG $A2AB
; CODE: action rendering. Runtime-written absolute targets are excluded by the JS exporter.
    XOR A                               ; $A2AB af
    LD (HL),A                           ; $A2AC 77
    INC HL                              ; $A2AD 23
    DJNZ $A2AC                          ; $A2AE 10 fc
    RET                                 ; $A2B0 c9
    DEC A                               ; $A2B1 3d
    LD L,A                              ; $A2B2 6f
    LD H,$00                            ; $A2B3 26 00
    ADD HL,HL                           ; $A2B5 29
    ADD HL,HL                           ; $A2B6 29
    ADD HL,HL                           ; $A2B7 29
    LD DE,$8259                         ; $A2B8 11 59 82
    ADD HL,DE                           ; $A2BB 19
    RET                                 ; $A2BC c9
    LD A,(IX+$05)                       ; $A2BD dd 7e 05
    RRCA                                ; $A2C0 0f
    RRCA                                ; $A2C1 0f
    RRCA                                ; $A2C2 0f
    RRCA                                ; $A2C3 0f
    AND $0F                             ; $A2C4 e6 0f
    LD C,A                              ; $A2C6 4f
    LD A,(IX+$07)                       ; $A2C7 dd 7e 07
    AND $F0                             ; $A2CA e6 f0
    ADD A,C                             ; $A2CC 81
    LD ($A01E),A                        ; $A2CD 32 1e a0
    LD A,(IX+$01)                       ; $A2D0 dd 7e 01
    RRCA                                ; $A2D3 0f
    RRCA                                ; $A2D4 0f
    RRCA                                ; $A2D5 0f
    RRCA                                ; $A2D6 0f
    AND $0F                             ; $A2D7 e6 0f
    LD C,A                              ; $A2D9 4f
    LD A,(IX+$03)                       ; $A2DA dd 7e 03
    AND $F0                             ; $A2DD e6 f0
    ADD A,C                             ; $A2DF 81
    LD ($A01D),A                        ; $A2E0 32 1d a0
    RET                                 ; $A2E3 c9
    LD A,$01                            ; $A2E4 3e 01
    LD ($A2AA),A                        ; $A2E6 32 aa a2
    PUSH IY                             ; $A2E9 fd e5
    PUSH BC                             ; $A2EB c5
    PUSH IX                             ; $A2EC dd e5
    PUSH HL                             ; $A2EE e5
    PUSH DE                             ; $A2EF d5
    LD A,($A033)                        ; $A2F0 3a 33 a0
    LD ($A35D),A                        ; $A2F3 32 5d a3
    LD HL,($A034)                       ; $A2F6 2a 34 a0
    LD ($A35E),HL                       ; $A2F9 22 5e a3
    LD A,($A00C)                        ; $A2FC 3a 0c a0
    LD B,A                              ; $A2FF 47
    AND A                               ; $A300 a7
    LD A,$01                            ; $A301 3e 01
    JR Z,$A306                          ; $A303 28 01
    XOR A                               ; $A305 af
    LD ($A027),A                        ; $A306 32 27 a0
    CALL $D078                          ; $A309 cd 78 d0
    JR NC,$A31A                         ; $A30C 30 0c
    LD A,B                              ; $A30E 78
    AND A                               ; $A30F a7
    JR NZ,$A31A                         ; $A310 20 08
    LD HL,$68D1                         ; $A312 21 d1 68
    CALL $A59F                          ; $A315 cd 9f a5
    JR $A34E                            ; $A318 18 34
    LD A,($A35D)                        ; $A31A 3a 5d a3
    CALL $A2B1                          ; $A31D cd b1 a2
    PUSH HL                             ; $A320 e5
    POP IX                              ; $A321 dd e1
    CALL $A2BD                          ; $A323 cd bd a2
    LD A,($A01D)                        ; $A326 3a 1d a0
    AND $10                             ; $A329 e6 10
    JR NZ,$A34E                         ; $A32B 20 21
    CP B                                ; $A32D b8
    JR Z,$A336                          ; $A32E 28 06
    CALL $DC6C                          ; $A330 cd 6c dc
    CALL Z,$A2A2                        ; $A333 cc a2 a2
    CALL $A724                          ; $A336 cd 24 a7
    LD DE,$017F                         ; $A339 11 7f 01
    XOR A                               ; $A33C af
    CP B                                ; $A33D b8
    JR NZ,$A348                         ; $A33E 20 08
    CALL $A887                          ; $A340 cd 87 a8
    CALL $A360                          ; $A343 cd 60 a3
    JR $A34B                            ; $A346 18 03
    CALL $A37D                          ; $A348 cd 7d a3
    CALL $A2A2                          ; $A34B cd a2 a2
    XOR A                               ; $A34E af
    LD ($A2AA),A                        ; $A34F 32 aa a2
    LD ($A027),A                        ; $A352 32 27 a0
    POP DE                              ; $A355 d1
    POP HL                              ; $A356 e1
    POP IX                              ; $A357 dd e1
    POP BC                              ; $A359 c1
    POP IY                              ; $A35A fd e1
    RET                                 ; $A35C c9

    ORG $A360
; CODE: arguments, names, money and input. Runtime-written absolute targets are excluded by the JS exporter.
    LD A,($A036)                        ; $A360 3a 36 a0
    PUSH AF                             ; $A363 f5
    LD HL,$A35E                         ; $A364 21 5e a3
    CP (HL)                             ; $A367 be
    LD A,$00                            ; $A368 3e 00
    JR NZ,$A36D                         ; $A36A 20 01
    LD (HL),A                           ; $A36C 77
    LD ($A036),A                        ; $A36D 32 36 a0
    PUSH IX                             ; $A370 dd e5
    CALL $A37D                          ; $A372 cd 7d a3
    POP IX                              ; $A375 dd e1
    POP AF                              ; $A377 f1
    LD ($A036),A                        ; $A378 32 36 a0
    XOR A                               ; $A37B af
    RET                                 ; $A37C c9
    XOR A                               ; $A37D af
    LD ($A028),A                        ; $A37E 32 28 a0
    LD A,($A35D)                        ; $A381 3a 5d a3
    CALL $A2B1                          ; $A384 cd b1 a2
    PUSH HL                             ; $A387 e5
    POP IX                              ; $A388 dd e1
    PUSH HL                             ; $A38A e5
    CALL $A2BD                          ; $A38B cd bd a2
    CALL $C493                          ; $A38E cd 93 c4
    CALL $C4B2                          ; $A391 cd b2 c4
    POP HL                              ; $A394 e1
    LD A,($A01D)                        ; $A395 3a 1d a0
    LD C,A                              ; $A398 4f
    PUSH HL                             ; $A399 e5
    LD DE,$0006                         ; $A39A 11 06 00
    ADD HL,DE                           ; $A39D 19
    CALL $A880                          ; $A39E cd 80 a8
    POP HL                              ; $A3A1 e1
    CALL $A880                          ; $A3A2 cd 80 a8
    BIT 3,C                             ; $A3A5 cb 59
    JR Z,$A3E2                          ; $A3A7 28 39
    BIT 5,C                             ; $A3A9 cb 69
    CALL NZ,$A880                       ; $A3AB c4 80 a8
    LD A,($A01E)                        ; $A3AE 3a 1e a0
    BIT 7,A                             ; $A3B1 cb 7f
    CALL NZ,$A880                       ; $A3B3 c4 80 a8
    LD A,($A35E)                        ; $A3B6 3a 5e a3
    CP $FE                              ; $A3B9 fe fe
    JR NZ,$A3C7                         ; $A3BB 20 0a
    PUSH HL                             ; $A3BD e5
    LD HL,($A02F)                       ; $A3BE 2a 2f a0
    CALL $A419                          ; $A3C1 cd 19 a4
    POP HL                              ; $A3C4 e1
    JR $A3E2                            ; $A3C5 18 1b
    PUSH HL                             ; $A3C7 e5
    LD HL,$A036                         ; $A3C8 21 36 a0
    CP (HL)                             ; $A3CB be
    JR NZ,$A3D6                         ; $A3CC 20 08
    LD DE,$055B                         ; $A3CE 11 5b 05
    CALL $A887                          ; $A3D1 cd 87 a8
    JR $A3E1                            ; $A3D4 18 0b
    LD A,($A00F)                        ; $A3D6 3a 0f a0
    CP $05                              ; $A3D9 fe 05
    LD A,($A35E)                        ; $A3DB 3a 5e a3
    CALL $A745                          ; $A3DE cd 45 a7
    POP HL                              ; $A3E1 e1
    LD A,($A35F)                        ; $A3E2 3a 5f a3
    CP $FF                              ; $A3E5 fe ff
    JR Z,$A414                          ; $A3E7 28 2b
    BIT 2,C                             ; $A3E9 cb 51
    JR Z,$A414                          ; $A3EB 28 27
    BIT 5,C                             ; $A3ED cb 69
    CALL Z,$A880                        ; $A3EF cc 80 a8
    LD A,($A01E)                        ; $A3F2 3a 1e a0
    BIT 7,A                             ; $A3F5 cb 7f
    CALL Z,$A880                        ; $A3F7 cc 80 a8
    LD A,($A35F)                        ; $A3FA 3a 5f a3
    CP $FE                              ; $A3FD fe fe
    JR NZ,$A409                         ; $A3FF 20 08
    LD HL,($A031)                       ; $A401 2a 31 a0
    CALL $A419                          ; $A404 cd 19 a4
    JR $A414                            ; $A407 18 0b
    LD A,($A010)                        ; $A409 3a 10 a0
    CP $05                              ; $A40C fe 05
    LD A,($A35F)                        ; $A40E 3a 5f a3
    CALL $A745                          ; $A411 cd 45 a7
    LD A,$2E                            ; $A414 3e 2e
    JP $A9B7                            ; $A416 c3 b7 a9
    PUSH BC                             ; $A419 c5
    RES 7,H                             ; $A41A cb bc
    SLA L                               ; $A41C cb 25
    SRL H                               ; $A41E cb 3c
    RR L                                ; $A420 cb 1d
    LD A,$20                            ; $A422 3e 20
    CALL $A9B7                          ; $A424 cd b7 a9
    LD DE,$00F0                         ; $A427 11 f0 00
    CALL $A476                          ; $A42A cd 76 a4
    AND A                               ; $A42D a7
    JR Z,$A442                          ; $A42E 28 12
    LD B,A                              ; $A430 47
    LD A,$60                            ; $A431 3e 60
    CALL $A9B7                          ; $A433 cd b7 a9
    CALL $A490                          ; $A436 cd 90 a4
    LD A,L                              ; $A439 7d
    OR H                                ; $A43A b4
    JR Z,$A467                          ; $A43B 28 2a
    LD A,$20                            ; $A43D 3e 20
    CALL $A9B7                          ; $A43F cd b7 a9
    LD DE,$000C                         ; $A442 11 0c 00
    CALL $A476                          ; $A445 cd 76 a4
    AND A                               ; $A448 a7
    JR Z,$A469                          ; $A449 28 1e
    LD B,A                              ; $A44B 47
    CALL $A490                          ; $A44C cd 90 a4
    LD A,$2F                            ; $A44F 3e 2f
    CALL $A9B7                          ; $A451 cd b7 a9
    LD A,L                              ; $A454 7d
    AND A                               ; $A455 a7
    LD B,A                              ; $A456 47
    JR Z,$A45E                          ; $A457 28 05
    CALL $A490                          ; $A459 cd 90 a4
    JR $A467                            ; $A45C 18 09
    LD A,$2D                            ; $A45E 3e 2d
    CALL $A9B7                          ; $A460 cd b7 a9
    XOR A                               ; $A463 af
    LD ($A026),A                        ; $A464 32 26 a0
    POP BC                              ; $A467 c1
    RET                                 ; $A468 c9
    LD B,L                              ; $A469 45
    CALL $A490                          ; $A46A cd 90 a4
    LD A,$44                            ; $A46D 3e 44
    CALL $A9B7                          ; $A46F cd b7 a9
    LD A,$2E                            ; $A472 3e 2e
    JR $A460                            ; $A474 18 ea
    LD A,$FF                            ; $A476 3e ff
    INC A                               ; $A478 3c
    AND A                               ; $A479 a7
    SBC HL,DE                           ; $A47A ed 52
    JR NC,$A478                         ; $A47C 30 fa
    ADD HL,DE                           ; $A47E 19
    RET                                 ; $A47F c9
    CALL $A476                          ; $A480 cd 76 a4
    ADD A,$30                           ; $A483 c6 30
    DEC C                               ; $A485 0d
    INC C                               ; $A486 0c
    JR NZ,$A48D                         ; $A487 20 04
    CP $30                              ; $A489 fe 30
    RET Z                               ; $A48B c8
    INC C                               ; $A48C 0c
    JP $A9B7                            ; $A48D c3 b7 a9
    PUSH HL                             ; $A490 e5
    PUSH DE                             ; $A491 d5
    LD L,B                              ; $A492 68
    LD H,$00                            ; $A493 26 00
    LD C,H                              ; $A495 4c
    LD DE,$0064                         ; $A496 11 64 00
    CALL $A480                          ; $A499 cd 80 a4
    LD DE,$000A                         ; $A49C 11 0a 00
    CALL $A480                          ; $A49F cd 80 a4
    LD A,L                              ; $A4A2 7d
    ADD A,$30                           ; $A4A3 c6 30
    CALL $A9B7                          ; $A4A5 cd b7 a9
    POP DE                              ; $A4A8 d1
    POP HL                              ; $A4A9 e1
    RET                                 ; $A4AA c9
    PUSH DE                             ; $A4AB d5
    PUSH IX                             ; $A4AC dd e5
    CALL $D224                          ; $A4AE cd 24 d2
    PUSH IX                             ; $A4B1 dd e5
    POP HL                              ; $A4B3 e1
    LD DE,$0001                         ; $A4B4 11 01 00
    ADD HL,DE                           ; $A4B7 19
    POP IX                              ; $A4B8 dd e1
    POP DE                              ; $A4BA d1
    RET                                 ; $A4BB c9
    PUSH DE                             ; $A4BC d5
    PUSH IX                             ; $A4BD dd e5
    CALL $D237                          ; $A4BF cd 37 d2
    PUSH IX                             ; $A4C2 dd e5
    POP HL                              ; $A4C4 e1
    LD DE,$0007                         ; $A4C5 11 07 00
    ADD HL,DE                           ; $A4C8 19
    POP IX                              ; $A4C9 dd e1
    POP DE                              ; $A4CB d1
    RET                                 ; $A4CC c9
    PUSH DE                             ; $A4CD d5
    PUSH HL                             ; $A4CE e5
    PUSH IY                             ; $A4CF fd e5
    LD DE,$0006                         ; $A4D1 11 06 00
    ADD HL,DE                           ; $A4D4 19
    ADD IY,DE                           ; $A4D5 fd 19
    CALL $A51B                          ; $A4D7 cd 1b a5
    JR NZ,$A516                         ; $A4DA 20 3a
    POP IY                              ; $A4DC fd e1
    POP HL                              ; $A4DE e1
    POP DE                              ; $A4DF d1
    PUSH DE                             ; $A4E0 d5
    PUSH HL                             ; $A4E1 e5
    PUSH IY                             ; $A4E2 fd e5
    CALL $A51B                          ; $A4E4 cd 1b a5
    JR NZ,$A516                         ; $A4E7 20 2d
    LD A,$01                            ; $A4E9 3e 01
    LD ($A02E),A                        ; $A4EB 32 2e a0
    CALL $A51B                          ; $A4EE cd 1b a5
    JR NZ,$A4FA                         ; $A4F1 20 07
    CALL $A51B                          ; $A4F3 cd 1b a5
    LD A,$00                            ; $A4F6 3e 00
    JR Z,$A516                          ; $A4F8 28 1c
    POP IY                              ; $A4FA fd e1
    POP HL                              ; $A4FC e1
    PUSH HL                             ; $A4FD e5
    PUSH IY                             ; $A4FE fd e5
    LD DE,$0004                         ; $A500 11 04 00
    ADD IY,DE                           ; $A503 fd 19
    INC HL                              ; $A505 23
    INC HL                              ; $A506 23
    CALL $A51B                          ; $A507 cd 1b a5
    JR NZ,$A516                         ; $A50A 20 0a
    LD DE,$FFFC                         ; $A50C 11 fc ff
    ADD IY,DE                           ; $A50F fd 19
    CALL $A51B                          ; $A511 cd 1b a5
    LD A,$01                            ; $A514 3e 01
    POP IY                              ; $A516 fd e1
    POP HL                              ; $A518 e1
    POP DE                              ; $A519 d1
    RET                                 ; $A51A c9
    PUSH HL                             ; $A51B e5
    LD A,(HL)                           ; $A51C 7e
    INC HL                              ; $A51D 23
    OR (HL)                             ; $A51E b6
    JR Z,$A52E                          ; $A51F 28 0d
    LD A,(IY+$01)                       ; $A521 fd 7e 01
    XOR (HL)                            ; $A524 ae
    AND $0F                             ; $A525 e6 0f
    JR NZ,$A52E                         ; $A527 20 05
    DEC HL                              ; $A529 2b
    LD A,(HL)                           ; $A52A 7e
    CP (IY+$00)                         ; $A52B fd be 00
    POP HL                              ; $A52E e1
    INC HL                              ; $A52F 23
    INC HL                              ; $A530 23
    INC IY                              ; $A531 fd 23
    INC IY                              ; $A533 fd 23
    RET                                 ; $A535 c9
    PUSH HL                             ; $A536 e5
    LD HL,($A03B)                       ; $A537 2a 3b a0
    CALL $C41F                          ; $A53A cd 1f c4
    BIT 7,A                             ; $A53D cb 7f
    JR NZ,$A553                         ; $A53F 20 12
    LD A,$00                            ; $A541 3e 00
    DEC A                               ; $A543 3d
    PUSH HL                             ; $A544 e5
    POP HL                              ; $A545 e1
    JR NZ,$A543                         ; $A546 20 fb
    DEC HL                              ; $A548 2b
    LD A,H                              ; $A549 7c
    OR L                                ; $A54A b5
    JR NZ,$A53A                         ; $A54B 20 ed
    POP HL                              ; $A54D e1
    PUSH HL                             ; $A54E e5
    CALL $D9B7                          ; $A54F cd b7 d9
    XOR A                               ; $A552 af
    AND $7F                             ; $A553 e6 7f
    LD HL,$0BB8                         ; $A555 21 b8 0b
    LD ($A03B),HL                       ; $A558 22 3b a0
    POP HL                              ; $A55B e1
    RET                                 ; $A55C c9

    ORG $A59F
; CODE: text dispatch. Runtime-written absolute targets are excluded by the JS exporter.
    PUSH BC                             ; $A59F c5
    PUSH DE                             ; $A5A0 d5
    PUSH IX                             ; $A5A1 dd e5
    PUSH AF                             ; $A5A3 f5
    PUSH HL                             ; $A5A4 e5
    LD HL,$000C                         ; $A5A5 21 0c 00
    ADD HL,SP                           ; $A5A8 39
    LD ($A59D),HL                       ; $A5A9 22 9d a5
    POP HL                              ; $A5AC e1
    LD A,($A00B)                        ; $A5AD 3a 0b a0
    AND A                               ; $A5B0 a7
    JR NZ,$A5B6                         ; $A5B1 20 03
    LD ($A00C),A                        ; $A5B3 32 0c a0
    CALL $A5C4                          ; $A5B6 cd c4 a5
    POP AF                              ; $A5B9 f1
    POP IX                              ; $A5BA dd e1
    POP DE                              ; $A5BC d1
    POP BC                              ; $A5BD c1
    POP HL                              ; $A5BE e1
    LD SP,($A59D)                       ; $A5BF ed 7b 9d a5
    JP (HL)                             ; $A5C3 e9
    PUSH HL                             ; $A5C4 e5
    POP IX                              ; $A5C5 dd e1
    CALL $A5CD                          ; $A5C7 cd cd a5
    JR NZ,$A5C7                         ; $A5CA 20 fb
    RET                                 ; $A5CC c9
    LD A,(IX+$00)                       ; $A5CD dd 7e 00
    BIT 7,A                             ; $A5D0 cb 7f
    JR Z,$A5F2                          ; $A5D2 28 1e
    AND $7F                             ; $A5D4 e6 7f
    LD D,A                              ; $A5D6 57
    LD E,(IX+$01)                       ; $A5D7 dd 5e 01
    INC IX                              ; $A5DA dd 23
    AND $F0                             ; $A5DC e6 f0
    CP $30                              ; $A5DE fe 30
    JR Z,$A647                          ; $A5E0 28 65
    CP $20                              ; $A5E2 fe 20
    JR Z,$A647                          ; $A5E4 28 61
    CP $60                              ; $A5E6 fe 60
    JR Z,$A647                          ; $A5E8 28 5d
    CALL $A887                          ; $A5EA cd 87 a8
    INC IX                              ; $A5ED dd 23
    OR $01                              ; $A5EF f6 01
    RET                                 ; $A5F1 c9
    CP $20                              ; $A5F2 fe 20
    JR C,$A621                          ; $A5F4 38 2b
    CP $60                              ; $A5F6 fe 60
    JP NC,$A83A                         ; $A5F8 d2 3a a8
    CP $40                              ; $A5FB fe 40
    JR C,$A61C                          ; $A5FD 38 1d
    AND $1F                             ; $A5FF e6 1f
    INC A                               ; $A601 3c
    LD B,A                              ; $A602 47
    PUSH IX                             ; $A603 dd e5
    POP HL                              ; $A605 e1
    INC HL                              ; $A606 23
    LD C,$00                            ; $A607 0e 00
    CALL $A990                          ; $A609 cd 90 a9
    CALL $A9B7                          ; $A60C cd b7 a9
    DJNZ $A609                          ; $A60F 10 f8
    PUSH HL                             ; $A611 e5
    POP IX                              ; $A612 dd e1
    LD A,C                              ; $A614 79
    AND A                               ; $A615 a7
    JR NZ,$A5ED                         ; $A616 20 d5
    DEC IX                              ; $A618 dd 2b
    JR $A5ED                            ; $A61A 18 d1
    CALL $A9B7                          ; $A61C cd b7 a9
    JR $A5ED                            ; $A61F 18 cc
    PUSH DE                             ; $A621 d5
    LD E,A                              ; $A622 5f
    LD D,$00                            ; $A623 16 00
    LD HL,$A55D                         ; $A625 21 5d a5
    ADD HL,DE                           ; $A628 19
    ADD HL,DE                           ; $A629 19
    LD E,(HL)                           ; $A62A 5e
    INC HL                              ; $A62B 23
    LD D,(HL)                           ; $A62C 56
    EX DE,HL                            ; $A62D eb
    POP DE                              ; $A62E d1
    CP $1D                              ; $A62F fe 1d
    JR NC,$A5C3                         ; $A631 30 90
    CALL $A5C3                          ; $A633 cd c3 a5
    JR Z,$A5ED                          ; $A636 28 b5
    JR $A5EA                            ; $A638 18 b0
    CALL $A9B7                          ; $A63A cd b7 a9
    XOR A                               ; $A63D af
    RET                                 ; $A63E c9
    LD D,$60                            ; $A63F 16 60
    JR $A64A                            ; $A641 18 07
    LD D,$30                            ; $A643 16 30
    JR $A64A                            ; $A645 18 03
    CALL $A887                          ; $A647 cd 87 a8
    LD A,$2E                            ; $A64A 3e 2e
    BIT 6,D                             ; $A64C cb 72
    JR NZ,$A657                         ; $A64E 20 07
    BIT 4,D                             ; $A650 cb 62
    CALL NZ,$A9B7                       ; $A652 c4 b7 a9
    BIT 4,D                             ; $A655 cb 62
    CALL NZ,$A2A2                       ; $A657 c4 a2 a2
    XOR A                               ; $A65A af
    RET                                 ; $A65B c9
    RET                                 ; $A65C c9
    XOR A                               ; $A65D af
    LD ($A028),A                        ; $A65E 32 28 a0
    CALL $A66C                          ; $A661 cd 6c a6
    EX DE,HL                            ; $A664 eb
    LD A,H                              ; $A665 7c
    OR L                                ; $A666 b5
    CALL NZ,$A7BA                       ; $A667 c4 ba a7
    XOR A                               ; $A66A af
    RET                                 ; $A66B c9
    LD HL,($A59D)                       ; $A66C 2a 9d a5
    LD E,(HL)                           ; $A66F 5e
    INC HL                              ; $A670 23
    LD D,(HL)                           ; $A671 56
    INC HL                              ; $A672 23
    LD ($A59D),HL                       ; $A673 22 9d a5
    OR $01                              ; $A676 f6 01
    RET                                 ; $A678 c9
    LD E,(IX+$01)                       ; $A679 dd 5e 01
    LD D,(IX+$02)                       ; $A67C dd 56 02
    DEC DE                              ; $A67F 1b
    ADD IX,DE                           ; $A680 dd 19
    XOR A                               ; $A682 af
    RET                                 ; $A683 c9
    CALL $A66C                          ; $A684 cd 6c a6
    PUSH DE                             ; $A687 d5
    POP IX                              ; $A688 dd e1
    XOR A                               ; $A68A af
    RET                                 ; $A68B c9
    CALL $C00C                          ; $A68C cd 0c c0
    CP $05                              ; $A68F fe 05
    RET Z                               ; $A691 c8
    JR $A6B2                            ; $A692 18 1e
    CALL $C00C                          ; $A694 cd 0c c0
    CP $04                              ; $A697 fe 04
    RET Z                               ; $A699 c8
    JR $A6B2                            ; $A69A 18 16
    CALL $C00C                          ; $A69C cd 0c c0
    CP $03                              ; $A69F fe 03
    RET Z                               ; $A6A1 c8
    JR $A6B2                            ; $A6A2 18 0e
    CALL $C00C                          ; $A6A4 cd 0c c0
    CP $02                              ; $A6A7 fe 02
    RET Z                               ; $A6A9 c8
    JR $A6B2                            ; $A6AA 18 06
    CALL $C00C                          ; $A6AC cd 0c c0
    CP $01                              ; $A6AF fe 01
    RET Z                               ; $A6B1 c8
    INC IX                              ; $A6B2 dd 23
    CALL $A6BB                          ; $A6B4 cd bb a6
    DEC IX                              ; $A6B7 dd 2b
    XOR A                               ; $A6B9 af
    RET                                 ; $A6BA c9
    LD A,(IX+$00)                       ; $A6BB dd 7e 00
    BIT 7,A                             ; $A6BE cb 7f
    JR NZ,$A6CC                         ; $A6C0 20 0a
    CP $02                              ; $A6C2 fe 02
    JR Z,$A6CA                          ; $A6C4 28 04
    CP $0B                              ; $A6C6 fe 0b
    JR NZ,$A6CE                         ; $A6C8 20 04
    INC IX                              ; $A6CA dd 23
    INC IX                              ; $A6CC dd 23
    INC IX                              ; $A6CE dd 23
    RET                                 ; $A6D0 c9

    ORG $A6D3
; CODE: choice, calls and arguments. Runtime-written absolute targets are excluded by the JS exporter.
    INC IX                              ; $A6D3 dd 23
    LD A,(IX+$00)                       ; $A6D5 dd 7e 00
    LD ($A6D1),A                        ; $A6D8 32 d1 a6
    DEC A                               ; $A6DB 3d
    CALL $D2A4                          ; $A6DC cd a4 d2
    INC A                               ; $A6DF 3c
    LD ($A6D2),A                        ; $A6E0 32 d2 a6
    INC IX                              ; $A6E3 dd 23
    LD A,($A6D2)                        ; $A6E5 3a d2 a6
    LD HL,$A6D1                         ; $A6E8 21 d1 a6
    CP (HL)                             ; $A6EB be
    JR NZ,$A6F5                         ; $A6EC 20 07
    PUSH IX                             ; $A6EE dd e5
    CALL $A5CD                          ; $A6F0 cd cd a5
    POP IX                              ; $A6F3 dd e1
    CALL $A6BB                          ; $A6F5 cd bb a6
    LD HL,$A6D1                         ; $A6F8 21 d1 a6
    DEC (HL)                            ; $A6FB 35
    JR NZ,$A6E5                         ; $A6FC 20 e7
    DEC IX                              ; $A6FE dd 2b
    XOR A                               ; $A700 af
    RET                                 ; $A701 c9
    LD DE,($A00D)                       ; $A702 ed 5b 0d a0
    OR $01                              ; $A706 f6 01
    RET                                 ; $A708 c9
    CALL $A66C                          ; $A709 cd 6c a6
    CALL $A80E                          ; $A70C cd 0e a8
    XOR A                               ; $A70F af
    RET                                 ; $A710 c9
    PUSH IX                             ; $A711 dd e5
    CALL $A66C                          ; $A713 cd 6c a6
    PUSH DE                             ; $A716 d5
    POP IX                              ; $A717 dd e1
    CALL $BF1C                          ; $A719 cd 1c bf
    POP IX                              ; $A71C dd e1
    XOR A                               ; $A71E af
    RET                                 ; $A71F c9
    XOR A                               ; $A720 af
    LD ($A028),A                        ; $A721 32 28 a0
    LD A,($A036)                        ; $A724 3a 36 a0
    CALL $A82F                          ; $A727 cd 2f a8
    XOR A                               ; $A72A af
    RET                                 ; $A72B c9
    LD A,$01                            ; $A72C 3e 01
    LD ($A028),A                        ; $A72E 32 28 a0
    LD A,($A034)                        ; $A731 3a 34 a0
    JR $A751                            ; $A734 18 1b
    CALL $A9B7                          ; $A736 cd b7 a9
    XOR A                               ; $A739 af
    RET                                 ; $A73A c9
    LD A,$01                            ; $A73B 3e 01
    LD ($A028),A                        ; $A73D 32 28 a0
    LD A,($A035)                        ; $A740 3a 35 a0
    JR $A751                            ; $A743 18 0c
    JR NC,$A751                         ; $A745 30 0a
    PUSH HL                             ; $A747 e5
    CALL $A4AB                          ; $A748 cd ab a4
    CALL $A7BA                          ; $A74B cd ba a7
    POP HL                              ; $A74E e1
    XOR A                               ; $A74F af
    RET                                 ; $A750 c9
    PUSH HL                             ; $A751 e5
    CALL $A4BC                          ; $A752 cd bc a4
    CALL $A7C5                          ; $A755 cd c5 a7
    POP HL                              ; $A758 e1
    XOR A                               ; $A759 af
    RET                                 ; $A75A c9
    PUSH IX                             ; $A75B dd e5
    POP HL                              ; $A75D e1
    PUSH HL                             ; $A75E e5
    LD E,(IX+$01)                       ; $A75F dd 5e 01
    LD D,(IX+$02)                       ; $A762 dd 56 02
    ADD HL,DE                           ; $A765 19
    CALL $A5C4                          ; $A766 cd c4 a5
    POP IX                              ; $A769 dd e1
    INC IX                              ; $A76B dd 23
    INC IX                              ; $A76D dd 23
    XOR A                               ; $A76F af
    RET                                 ; $A770 c9
    PUSH IX                             ; $A771 dd e5
    CALL $A66C                          ; $A773 cd 6c a6
    EX DE,HL                            ; $A776 eb
    LD A,L                              ; $A777 7d
    OR H                                ; $A778 b4
    CALL NZ,$A5C4                       ; $A779 c4 c4 a5
    POP IX                              ; $A77C dd e1
    XOR A                               ; $A77E af
    RET                                 ; $A77F c9
    LD A,($A036)                        ; $A780 3a 36 a0
    LD DE,$0414                         ; $A783 11 14 04
    AND A                               ; $A786 a7
    RET NZ                              ; $A787 c0
    LD DE,$09F2                         ; $A788 11 f2 09
    OR $01                              ; $A78B f6 01
    RET                                 ; $A78D c9
    LD A,($A034)                        ; $A78E 3a 34 a0
    JR $A783                            ; $A791 18 f0
    LD A,($A036)                        ; $A793 3a 36 a0
    EX AF,AF'                           ; $A796 08
    XOR A                               ; $A797 af
    LD ($A028),A                        ; $A798 32 28 a0
    EX AF,AF'                           ; $A79B 08
    PUSH AF                             ; $A79C f5
    CALL $A82F                          ; $A79D cd 2f a8
    POP AF                              ; $A7A0 f1
    AND A                               ; $A7A1 a7
    LD DE,$0485                         ; $A7A2 11 85 04
    RET NZ                              ; $A7A5 c0
    LD DE,$007A                         ; $A7A6 11 7a 00
    OR $01                              ; $A7A9 f6 01
    RET                                 ; $A7AB c9
    LD A,($A034)                        ; $A7AC 3a 34 a0
    EX AF,AF'                           ; $A7AF 08
    LD A,$01                            ; $A7B0 3e 01
    JR $A798                            ; $A7B2 18 e4
    CALL $A66C                          ; $A7B4 cd 6c a6
    LD A,D                              ; $A7B7 7a
    JR $A7AF                            ; $A7B8 18 f5
    PUSH IY                             ; $A7BA fd e5
    PUSH HL                             ; $A7BC e5
    POP IY                              ; $A7BD fd e1
    CALL $D405                          ; $A7BF cd 05 d4
    POP IY                              ; $A7C2 fd e1
    RET                                 ; $A7C4 c9
    PUSH IY                             ; $A7C5 fd e5
    PUSH HL                             ; $A7C7 e5
    POP IY                              ; $A7C8 fd e1
    CALL $D3E8                          ; $A7CA cd e8 d3
    POP IY                              ; $A7CD fd e1
    RET                                 ; $A7CF c9
    XOR A                               ; $A7D0 af
    LD ($A7EA),A                        ; $A7D1 32 ea a7
    BIT 7,D                             ; $A7D4 cb 7a
    JR Z,$A7EB                          ; $A7D6 28 13
    LD A,E                              ; $A7D8 7b
    LD HL,$09EE                         ; $A7D9 21 ee 09
    CP L                                ; $A7DC bd
    JR NZ,$A7E4                         ; $A7DD 20 05
    LD A,D                              ; $A7DF 7a
    AND $0F                             ; $A7E0 e6 0f
    CP H                                ; $A7E2 bc
    RET Z                               ; $A7E3 c8
    LD A,$01                            ; $A7E4 3e 01
    LD ($A7EA),A                        ; $A7E6 32 ea a7
    RET                                 ; $A7E9 c9

    ORG $A7EB
; CODE: name articles and word selection. Runtime-written absolute targets are excluded by the JS exporter.
    LD HL,$A24D                         ; $A7EB 21 4d a2
    LD A,($A027)                        ; $A7EE 3a 27 a0
    LD E,A                              ; $A7F1 5f
    LD A,($A2AA)                        ; $A7F2 3a aa a2
    OR E                                ; $A7F5 b3
    JR Z,$A7FB                          ; $A7F6 28 03
    LD HL,$A255                         ; $A7F8 21 55 a2
    LD A,D                              ; $A7FB 7a
    RRCA                                ; $A7FC 0f
    RRCA                                ; $A7FD 0f
    RRCA                                ; $A7FE 0f
    AND $1E                             ; $A7FF e6 1e
    PUSH DE                             ; $A801 d5
    LD E,A                              ; $A802 5f
    LD D,$00                            ; $A803 16 00
    ADD HL,DE                           ; $A805 19
    LD E,(HL)                           ; $A806 5e
    INC HL                              ; $A807 23
    LD D,(HL)                           ; $A808 56
    CALL $A887                          ; $A809 cd 87 a8
    POP DE                              ; $A80C d1
    RET                                 ; $A80D c9
    PUSH DE                             ; $A80E d5
    CALL $A7D0                          ; $A80F cd d0 a7
    POP DE                              ; $A812 d1
    LD A,$50                            ; $A813 3e 50
    PUSH AF                             ; $A815 f5
    LD A,D                              ; $A816 7a
    AND $0F                             ; $A817 e6 0f
    LD D,A                              ; $A819 57
    POP AF                              ; $A81A f1
    OR D                                ; $A81B b2
    LD D,A                              ; $A81C 57
    AND $0F                             ; $A81D e6 0f
    OR E                                ; $A81F b3
    RET Z                               ; $A820 c8
    CALL $A887                          ; $A821 cd 87 a8
    LD A,($A7EA)                        ; $A824 3a ea a7
    PUSH HL                             ; $A827 e5
    LD HL,$A026                         ; $A828 21 26 a0
    OR (HL)                             ; $A82B b6
    LD (HL),A                           ; $A82C 77
    POP HL                              ; $A82D e1
    RET                                 ; $A82E c9
    CP $FF                              ; $A82F fe ff
    JP NZ,$A751                         ; $A831 c2 51 a7
    LD DE,$080E                         ; $A834 11 0e 08
    JP $A887                            ; $A837 c3 87 a8
    CALL $A840                          ; $A83A cd 40 a8
    JP $A5EA                            ; $A83D c3 ea a5
    SUB $60                             ; $A840 d6 60
    LD E,A                              ; $A842 5f
    LD D,$00                            ; $A843 16 00
    LD HL,$67B7                         ; $A845 21 b7 67
    ADD HL,DE                           ; $A848 19
    ADD HL,DE                           ; $A849 19
    LD E,(HL)                           ; $A84A 5e
    INC HL                              ; $A84B 23
    LD A,(HL)                           ; $A84C 7e
    ADD A,$50                           ; $A84D c6 50
    LD D,A                              ; $A84F 57
    RET                                 ; $A850 c9

    ORG $A852
; CODE: case toggle. Runtime-written absolute targets are excluded by the JS exporter.
    LD A,($A851)                        ; $A852 3a 51 a8
    XOR $01                             ; $A855 ee 01
    LD ($A851),A                        ; $A857 32 51 a8
    XOR A                               ; $A85A af
    RET                                 ; $A85B c9

    ORG $B5FC
; CODE: semantic clarification. Runtime-written absolute targets are excluded by the JS exporter.
    CALL $B633                          ; $B5FC cd 33 b6
    LD HL,($B186)                       ; $B5FF 2a 86 b1
    PUSH HL                             ; $B602 e5
    LD A,($B182)                        ; $B603 3a 82 b1
    CALL $B5B6                          ; $B606 cd b6 b5
    LD HL,$6880                         ; $B609 21 80 68
    CALL $A59F                          ; $B60C cd 9f a5
    RET                                 ; $B60F c9
    CALL $B62F                          ; $B610 cd 2f b6
    LD HL,$0000                         ; $B613 21 00 00
    PUSH HL                             ; $B616 e5
    LD HL,$B172                         ; $B617 21 72 b1
    PUSH HL                             ; $B61A e5
    CALL $B633                          ; $B61B cd 33 b6
    LD HL,($B186)                       ; $B61E 2a 86 b1
    PUSH HL                             ; $B621 e5
    LD A,($B183)                        ; $B622 3a 83 b1
    CALL $B5B6                          ; $B625 cd b6 b5
    LD HL,$687C                         ; $B628 21 7c 68
    CALL $A59F                          ; $B62B cd 9f a5
    RET                                 ; $B62E c9
    LD A,$28                            ; $B62F 3e 28
    JR $B635                            ; $B631 18 02
    LD A,$20                            ; $B633 3e 20
    LD ($B649),A                        ; $B635 32 49 b6
    LD ($B658),A                        ; $B638 32 58 b6
    LD IX,($B18E)                       ; $B63B dd 2a 8e b1
    LD L,(IX+$04)                       ; $B63F dd 6e 04
    LD H,(IX+$05)                       ; $B642 dd 66 05
    BIT 7,(IX+$07)                      ; $B645 dd cb 07 7e
    JR NZ,$B64E                         ; $B649 20 03
    LD HL,$0000                         ; $B64B 21 00 00
    EX (SP),HL                          ; $B64E e3
    PUSH HL                             ; $B64F e5
    LD L,(IX+$02)                       ; $B650 dd 6e 02
    LD H,(IX+$03)                       ; $B653 dd 66 03
    BIT 5,H                             ; $B656 cb 6c
    JR NZ,$B65D                         ; $B658 20 03
    LD HL,$0000                         ; $B65A 21 00 00
    EX (SP),HL                          ; $B65D e3
    JP (HL)                             ; $B65E e9
    LD A,($A00F)                        ; $B65F 3a 0f a0
    CP $05                              ; $B662 fe 05
    JR Z,$B671                          ; $B664 28 0b
    CP $06                              ; $B666 fe 06
    JR Z,$B671                          ; $B668 28 07
    LD A,($B173)                        ; $B66A 3a 73 b1
    BIT 7,A                             ; $B66D cb 7f
    JR Z,$B678                          ; $B66F 28 07
    LD HL,$6855                         ; $B671 21 55 68
    CALL $A59F                          ; $B674 cd 9f a5
    RET                                 ; $B677 c9
    LD HL,$B16D                         ; $B678 21 6d b1
    BIT 0,(HL)                          ; $B67B cb 46
    LD HL,$B172                         ; $B67D 21 72 b1
    CALL NZ,$B6DA                       ; $B680 c4 da b6
    CALL $B633                          ; $B683 cd 33 b6
    LD A,($B16D)                        ; $B686 3a 6d b1
    LD HL,$B172                         ; $B689 21 72 b1
    LD DE,($B186)                       ; $B68C ed 5b 86 b1
    PUSH DE                             ; $B690 d5
    BIT 0,A                             ; $B691 cb 47
    JR Z,$B69D                          ; $B693 28 08
    CALL $B83C                          ; $B695 cd 3c b8
    LD HL,$05B3                         ; $B698 21 b3 05
    JR $B6A6                            ; $B69B 18 09
    LD HL,$0000                         ; $B69D 21 00 00
    PUSH HL                             ; $B6A0 e5
    PUSH HL                             ; $B6A1 e5
    PUSH HL                             ; $B6A2 e5
    LD HL,$05DB                         ; $B6A3 21 db 05
    PUSH HL                             ; $B6A6 e5
    LD HL,$6894                         ; $B6A7 21 94 68
    CALL $A59F                          ; $B6AA cd 9f a5
    RET                                 ; $B6AD c9
    LD A,($A010)                        ; $B6AE 3a 10 a0
    CP $05                              ; $B6B1 fe 05
    JR Z,$B671                          ; $B6B3 28 bc
    CP $06                              ; $B6B5 fe 06
    JR Z,$B671                          ; $B6B7 28 b8
    LD A,($B179)                        ; $B6B9 3a 79 b1
    BIT 7,A                             ; $B6BC cb 7f
    JR NZ,$B671                         ; $B6BE 20 b1
    LD HL,$B16E                         ; $B6C0 21 6e b1
    BIT 0,(HL)                          ; $B6C3 cb 46
    LD HL,$B178                         ; $B6C5 21 78 b1
    CALL NZ,$B6F0                       ; $B6C8 c4 f0 b6
    CALL $B62F                          ; $B6CB cd 2f b6
    LD A,($B16E)                        ; $B6CE 3a 6e b1
    LD HL,$B178                         ; $B6D1 21 78 b1
    JR $B68C                            ; $B6D4 18 b6

    ORG $B6DA
; CODE: semantic description selection. Runtime-written absolute targets are excluded by the JS exporter.
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

    ORG $B77F
; CODE: semantic text token reader. Runtime-written absolute targets are excluded by the JS exporter.
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
    POP IX                              ; $B83C dd e1
    LD B,$03                            ; $B83E 06 03
    LD E,(HL)                           ; $B840 5e
    INC HL                              ; $B841 23
    LD D,(HL)                           ; $B842 56
    INC HL                              ; $B843 23
    PUSH DE                             ; $B844 d5
    DJNZ $B840                          ; $B845 10 f9
    POP HL                              ; $B847 e1
    EX (SP),HL                          ; $B848 e3
    PUSH HL                             ; $B849 e5
    JP (IX)                             ; $B84A dd e9
    LD HL,($B18A)                       ; $B84C 2a 8a b1
    PUSH HL                             ; $B84F e5
    LD HL,($B188)                       ; $B850 2a 88 b1
    PUSH HL                             ; $B853 e5
    LD HL,($B186)                       ; $B854 2a 86 b1
    PUSH HL                             ; $B857 e5
    LD HL,($B18C)                       ; $B858 2a 8c b1
    PUSH HL                             ; $B85B e5
    LD HL,$686A                         ; $B85C 21 6a 68
    CALL $A59F                          ; $B85F cd 9f a5
    RET                                 ; $B862 c9
    JP $C929                            ; $B863 c3 29 c9
    NOP                                 ; $B866 00
    NOP                                 ; $B867 00
    NOP                                 ; $B868 00
    NOP                                 ; $B869 00

    ORG $BB67
; CODE: statements and fact evaluation. Runtime-written absolute targets are excluded by the JS exporter.
    LD ($BA1D),A                        ; $BB67 32 1d ba
    LD ($BA1C),A                        ; $BB6A 32 1c ba
    CALL $BD7E                          ; $BB6D cd 7e bd
    JP C,$BBBE                          ; $BB70 da be bb
    CALL $BC21                          ; $BB73 cd 21 bc
    JR Z,$BB7C                          ; $BB76 28 04
    LD HL,$BA1C                         ; $BB78 21 1c ba
    INC (HL)                            ; $BB7B 34
    CALL $AEA9                          ; $BB7C cd a9 ae
    JR NZ,$BB6D                         ; $BB7F 20 ec
    LD A,($BA1C)                        ; $BB81 3a 1c ba
    AND A                               ; $BB84 a7
    JR NZ,$BB8E                         ; $BB85 20 07
    LD HL,$725F                         ; $BB87 21 5f 72
    CALL $A59F                          ; $BB8A cd 9f a5
    RET                                 ; $BB8D c9
    LD A,($BA1D)                        ; $BB8E 3a 1d ba
    AND A                               ; $BB91 a7
    JR Z,$BBC9                          ; $BB92 28 35
    LD IX,($BA1E)                       ; $BB94 dd 2a 1e ba
    PUSH IX                             ; $BB98 dd e5
    CALL $BE5A                          ; $BB9A cd 5a be
    LD A,(IX+$03)                       ; $BB9D dd 7e 03
    AND $C0                             ; $BBA0 e6 c0
    CP $80                              ; $BBA2 fe 80
    JR Z,$BBB1                          ; $BBA4 28 0b
    BIT 3,(IX+$03)                      ; $BBA6 dd cb 03 5e
    JR NZ,$BBB1                         ; $BBAA 20 05
    CALL $BE72                          ; $BBAC cd 72 be
    JR $BB9D                            ; $BBAF 18 ec
    POP IX                              ; $BBB1 dd e1
    JR NZ,$BBC4                         ; $BBB3 20 0f
    LD HL,$7295                         ; $BBB5 21 95 72
    PUSH IX                             ; $BBB8 dd e5
    CALL $A59F                          ; $BBBA cd 9f a5
    RET                                 ; $BBBD c9
    LD HL,$7243                         ; $BBBE 21 43 72
    JP $A59F                            ; $BBC1 c3 9f a5
    LD HL,$72A6                         ; $BBC4 21 a6 72
    JR $BBB8                            ; $BBC7 18 ef
    CALL $BC46                          ; $BBC9 cd 46 bc
    CALL $BC9C                          ; $BBCC cd 9c bc
    LD A,B                              ; $BBCF 78
    AND A                               ; $BBD0 a7
    JR NZ,$BBE5                         ; $BBD1 20 12
    CALL $BC74                          ; $BBD3 cd 74 bc
    AND A                               ; $BBD6 a7
    JR Z,$BBDE                          ; $BBD7 28 05
    LD HL,$72BD                         ; $BBD9 21 bd 72
    JR $BBB8                            ; $BBDC 18 da
    LD HL,$727E                         ; $BBDE 21 7e 72
    CALL $A59F                          ; $BBE1 cd 9f a5
    RET                                 ; $BBE4 c9
    PUSH AF                             ; $BBE5 f5
    LD HL,$67FF                         ; $BBE6 21 ff 67
    CALL $A59F                          ; $BBE9 cd 9f a5
    POP AF                              ; $BBEC f1
    CP $01                              ; $BBED fe 01
    LD HL,$72D6                         ; $BBEF 21 d6 72
    CALL NZ,$A59F                       ; $BBF2 c4 9f a5
    BIT 4,(IX+$03)                      ; $BBF5 dd cb 03 66
    JR Z,$BC1A                          ; $BBF9 28 1f
    RES 1,(IX+$03)                      ; $BBFB dd cb 03 8e
    PUSH IX                             ; $BBFF dd e5
    LD HL,$72E1                         ; $BC01 21 e1 72
    CALL $A59F                          ; $BC04 cd 9f a5
    LD L,(IX+$04)                       ; $BC07 dd 6e 04
    LD H,(IX+$05)                       ; $BC0A dd 66 05
    LD A,L                              ; $BC0D 7d
    OR H                                ; $BC0E b4
    JP NZ,$A59F                         ; $BC0F c2 9f a5
    LD A,$22                            ; $BC12 3e 22
    CALL $A9B7                          ; $BC14 cd b7 a9
    JP $A414                            ; $BC17 c3 14 a4
    LD L,(IX+$04)                       ; $BC1A dd 6e 04
    LD H,(IX+$05)                       ; $BC1D dd 66 05
    JP (HL)                             ; $BC20 e9
    CALL $BD51                          ; $BC21 cd 51 bd
    JR NZ,$BC2F                         ; $BC24 20 09
    LD A,(IX+$03)                       ; $BC26 dd 7e 03
    AND $C0                             ; $BC29 e6 c0
    CP $80                              ; $BC2B fe 80
    JR Z,$BC31                          ; $BC2D 28 02
    XOR A                               ; $BC2F af
    RET                                 ; $BC30 c9
    LD ($BA1E),IX                       ; $BC31 dd 22 1e ba
    CALL $BCC9                          ; $BC35 cd c9 bc
    JR Z,$BC43                          ; $BC38 28 09
    LD A,$01                            ; $BC3A 3e 01
    LD ($BA1D),A                        ; $BC3C 32 1d ba
    SET 0,(IX+$03)                      ; $BC3F dd cb 03 c6
    OR $01                              ; $BC43 f6 01
    RET                                 ; $BC45 c9
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
    BIT 2,(IX+$03)                      ; $BCC9 dd cb 03 56
    JR Z,$BCDA                          ; $BCCD 28 0b
    PUSH IX                             ; $BCCF dd e5
    PUSH BC                             ; $BCD1 c5
    CALL $BF08                          ; $BCD2 cd 08 bf
    POP BC                              ; $BCD5 c1
    POP IX                              ; $BCD6 dd e1
    JR Z,$BD03                          ; $BCD8 28 29
    BIT 5,(IX+$03)                      ; $BCDA dd cb 03 6e
    JR Z,$BCE6                          ; $BCDE 28 06
    SET 0,(IX+$03)                      ; $BCE0 dd cb 03 c6
    JR $BD01                            ; $BCE4 18 1b
    SET 1,(IX+$03)                      ; $BCE6 dd cb 03 ce
    RES 0,(IX+$03)                      ; $BCEA dd cb 03 86
    BIT 4,(IX+$03)                      ; $BCEE dd cb 03 66
    JR Z,$BD01                          ; $BCF2 28 0d
    LD L,(IX+$04)                       ; $BCF4 dd 6e 04
    LD H,(IX+$05)                       ; $BCF7 dd 66 05
    PUSH IX                             ; $BCFA dd e5
    CALL $D1DB                          ; $BCFC cd db d1
    POP IX                              ; $BCFF dd e1
    XOR A                               ; $BD01 af
    RET                                 ; $BD02 c9
    OR $01                              ; $BD03 f6 01
    RET                                 ; $BD05 c9
    PUSH IY                             ; $BD06 fd e5
    PUSH IX                             ; $BD08 dd e5
    POP IY                              ; $BD0A fd e1
    LD IX,$9FF6                         ; $BD0C dd 21 f6 9f
    CALL $A0F7                          ; $BD10 cd f7 a0
    JR Z,$BD46                          ; $BD13 28 31
    LD B,(IX+$02)                       ; $BD15 dd 46 02
    LD C,(IY+$02)                       ; $BD18 fd 4e 02
    LD A,(IX+$00)                       ; $BD1B dd 7e 00
    CP (IY+$00)                         ; $BD1E fd be 00
    JR Z,$BD3E                          ; $BD21 28 1b
    LD C,(IY+$00)                       ; $BD23 fd 4e 00
    CP (IY+$02)                         ; $BD26 fd be 02
    JR Z,$BD3E                          ; $BD29 28 13
    LD B,(IX+$00)                       ; $BD2B dd 46 00
    LD A,(IX+$02)                       ; $BD2E dd 7e 02
    CP (IY+$02)                         ; $BD31 fd be 02
    JR Z,$BD3E                          ; $BD34 28 08
    LD C,(IY+$02)                       ; $BD36 fd 4e 02
    CP (IY+$00)                         ; $BD39 fd be 00
    JR NZ,$BD10                         ; $BD3C 20 d2
    LD A,B                              ; $BD3E 78
    CP C                                ; $BD3F b9
    JR Z,$BD10                          ; $BD40 28 ce
    POP IY                              ; $BD42 fd e1
    XOR A                               ; $BD44 af
    RET                                 ; $BD45 c9
    OR $01                              ; $BD46 f6 01
    POP IY                              ; $BD48 fd e1
    RET                                 ; $BD4A c9
    LD IX,$9A7D                         ; $BD4B dd 21 7d 9a
    JR $BD55                            ; $BD4F 18 04
    LD IX,$9965                         ; $BD51 dd 21 65 99
    LD A,(IX+$00)                       ; $BD55 dd 7e 00
    CP $FF                              ; $BD58 fe ff
    JR Z,$BD66                          ; $BD5A 28 0a
    CALL $BD69                          ; $BD5C cd 69 bd
    JR Z,$BD68                          ; $BD5F 28 07
    CALL $BE5A                          ; $BD61 cd 5a be
    JR $BD55                            ; $BD64 18 ef
    OR $01                              ; $BD66 f6 01
    RET                                 ; $BD68 c9
    LD A,($BA1A)                        ; $BD69 3a 1a ba
    CP (IX+$01)                         ; $BD6C dd be 01
    RET NZ                              ; $BD6F c0
    LD A,($BA19)                        ; $BD70 3a 19 ba
    CP (IX+$00)                         ; $BD73 dd be 00
    RET NZ                              ; $BD76 c0
    LD A,($BA1B)                        ; $BD77 3a 1b ba
    CP (IX+$02)                         ; $BD7A dd be 02
    RET                                 ; $BD7D c9
    PUSH IY                             ; $BD7E fd e5
    POP HL                              ; $BD80 e1
    LD DE,$0018                         ; $BD81 11 18 00
    ADD HL,DE                           ; $BD84 19
    BIT 7,(IY+$19)                      ; $BD85 fd cb 19 7e
    JR Z,$BD8E                          ; $BD89 28 03
    LD HL,$9FF6                         ; $BD8B 21 f6 9f
    BIT 6,(IY+$19)                      ; $BD8E fd cb 19 76
    JR Z,$BD97                          ; $BD92 28 03
    LD HL,$9FFC                         ; $BD94 21 fc 9f
    LD DE,$B172                         ; $BD97 11 72 b1
    LD BC,$0006                         ; $BD9A 01 06 00
    LDIR                                ; $BD9D ed b0
    PUSH IY                             ; $BD9F fd e5
    POP HL                              ; $BDA1 e1
    LD DE,$0008                         ; $BDA2 11 08 00
    ADD HL,DE                           ; $BDA5 19
    LD DE,$B178                         ; $BDA6 11 78 b1
    LD BC,$0006                         ; $BDA9 01 06 00
    LDIR                                ; $BDAC ed b0
    LD L,(IY+$00)                       ; $BDAE fd 6e 00
    LD A,(IY+$01)                       ; $BDB1 fd 7e 01
    AND $0F                             ; $BDB4 e6 0f
    LD H,A                              ; $BDB6 67
    LD ($BA17),HL                       ; $BDB7 22 17 ba
    PUSH IY                             ; $BDBA fd e5
    CALL $BDC2                          ; $BDBC cd c2 bd
    POP IY                              ; $BDBF fd e1
    RET                                 ; $BDC1 c9
    CALL $D04F                          ; $BDC2 cd 4f d0
    LD ($BA13),IX                       ; $BDC5 dd 22 13 ba
    LD ($BA15),IX                       ; $BDC9 dd 22 15 ba
    LD DE,($BA17)                       ; $BDCD ed 5b 17 ba
    LD HL,$994D                         ; $BDD1 21 4d 99
    LD B,$01                            ; $BDD4 06 01
    LD A,(HL)                           ; $BDD6 7e
    INC HL                              ; $BDD7 23
    OR (HL)                             ; $BDD8 b6
    DEC HL                              ; $BDD9 2b
    RET Z                               ; $BDDA c8
    LD A,E                              ; $BDDB 7b
    CP (HL)                             ; $BDDC be
    JR NZ,$BDE5                         ; $BDDD 20 06
    INC HL                              ; $BDDF 23
    LD A,D                              ; $BDE0 7a
    CP (HL)                             ; $BDE1 be
    DEC HL                              ; $BDE2 2b
    JR Z,$BDEA                          ; $BDE3 28 05
    INC HL                              ; $BDE5 23
    INC HL                              ; $BDE6 23
    INC B                               ; $BDE7 04
    JR $BDD6                            ; $BDE8 18 ec
    LD A,B                              ; $BDEA 78
    LD ($BA1A),A                        ; $BDEB 32 1a ba
    LD A,$02                            ; $BDEE 3e 02
    LD ($A038),A                        ; $BDF0 32 38 a0
    CALL $BE3C                          ; $BDF3 cd 3c be
    CP $FF                              ; $BDF6 fe ff
    RET Z                               ; $BDF8 c8
    LD ($BA19),A                        ; $BDF9 32 19 ba
    CALL $BE3C                          ; $BDFC cd 3c be
    CP $FF                              ; $BDFF fe ff
    JR NZ,$BE3A                         ; $BE01 20 37
    LD A,($BA19)                        ; $BE03 3a 19 ba
    CALL $BE22                          ; $BE06 cd 22 be
    CALL $BE4B                          ; $BE09 cd 4b be
    CP $FF                              ; $BE0C fe ff
    RET Z                               ; $BE0E c8
    LD ($BA1B),A                        ; $BE0F 32 1b ba
    CALL $BE4B                          ; $BE12 cd 4b be
    CP $FF                              ; $BE15 fe ff
    JR NZ,$BE3A                         ; $BE17 20 21
    LD A,($BA1B)                        ; $BE19 3a 1b ba
    CALL $BE22                          ; $BE1C cd 22 be
    OR $01                              ; $BE1F f6 01
    RET                                 ; $BE21 c9
    CALL $D237                          ; $BE22 cd 37 d2
    PUSH IX                             ; $BE25 dd e5
    POP HL                              ; $BE27 e1
    BIT 6,(IX+$05)                      ; $BE28 dd cb 05 76
    LD DE,$9FF6                         ; $BE2C 11 f6 9f
    JR NZ,$BE34                         ; $BE2F 20 03
    LD DE,$9FFC                         ; $BE31 11 fc 9f
    LD BC,$0006                         ; $BE34 01 06 00
    LDIR                                ; $BE37 ed b0
    RET                                 ; $BE39 c9
    SCF                                 ; $BE3A 37
    RET                                 ; $BE3B c9
    LD IX,($BA13)                       ; $BE3C dd 2a 13 ba
    LD HL,$B172                         ; $BE40 21 72 b1
    CALL $D36A                          ; $BE43 cd 6a d3
    LD ($BA13),IX                       ; $BE46 dd 22 13 ba
    RET                                 ; $BE4A c9
    LD IX,($BA15)                       ; $BE4B dd 2a 15 ba
    LD HL,$B178                         ; $BE4F 21 78 b1
    CALL $D36A                          ; $BE52 cd 6a d3
    LD ($BA15),IX                       ; $BE55 dd 22 15 ba
    RET                                 ; $BE59 c9
    PUSH AF                             ; $BE5A f5
    LD DE,$0002                         ; $BE5B 11 02 00
    ADD IX,DE                           ; $BE5E dd 19
    ADD IX,DE                           ; $BE60 dd 19
    BIT 5,(IX-$01)                      ; $BE62 dd cb ff 6e
    JR NZ,$BE6E                         ; $BE66 20 06
    BIT 4,(IX-$01)                      ; $BE68 dd cb ff 66
    JR Z,$BE70                          ; $BE6C 28 02
    ADD IX,DE                           ; $BE6E dd 19
    POP AF                              ; $BE70 f1
    RET                                 ; $BE71 c9
    PUSH AF                             ; $BE72 f5
    LD B,$00                            ; $BE73 06 00
    LD C,(IX+$03)                       ; $BE75 dd 4e 03
    CALL $BE5A                          ; $BE78 cd 5a be
    BIT 3,C                             ; $BE7B cb 59
    JR Z,$BE84                          ; $BE7D 28 05
    LD A,B                              ; $BE7F 78
    AND A                               ; $BE80 a7
    JR Z,$BE84                          ; $BE81 28 01
    DEC B                               ; $BE83 05
    BIT 2,C                             ; $BE84 cb 51
    JR Z,$BE8B                          ; $BE86 28 03
    INC B                               ; $BE88 04
    JR $BE75                            ; $BE89 18 ea
    LD A,B                              ; $BE8B 78
    AND A                               ; $BE8C a7
    JR NZ,$BE75                         ; $BE8D 20 e6
    POP AF                              ; $BE8F f1
    RET                                 ; $BE90 c9
    BIT 1,(IX+$03)                      ; $BE91 dd cb 03 4e
    JR NZ,$BE72                         ; $BE95 20 db
    LD A,(IX+$03)                       ; $BE97 dd 7e 03
    AND $C0                             ; $BE9A e6 c0
    CP $00                              ; $BE9C fe 00
    JR NZ,$BECD                         ; $BE9E 20 2d
    LD A,(IX+$00)                       ; $BEA0 dd 7e 00
    PUSH IX                             ; $BEA3 dd e5
    CALL $D237                          ; $BEA5 cd 37 d2
    BIT 7,(IX+$06)                      ; $BEA8 dd cb 06 7e
    POP IX                              ; $BEAC dd e1
    JR Z,$BE72                          ; $BEAE 28 c2
    LD A,(IX+$02)                       ; $BEB0 dd 7e 02
    PUSH IX                             ; $BEB3 dd e5
    CALL $D237                          ; $BEB5 cd 37 d2
    BIT 7,(IX+$06)                      ; $BEB8 dd cb 06 7e
    POP IX                              ; $BEBC dd e1
    JR Z,$BE72                          ; $BEBE 28 b2
    SET 1,(IX+$03)                      ; $BEC0 dd cb 03 ce
    RES 0,(IX+$03)                      ; $BEC4 dd cb 03 86
    OR $01                              ; $BEC8 f6 01
    JP $BE72                            ; $BECA c3 72 be
    CP $80                              ; $BECD fe 80
    JR Z,$BE72                          ; $BECF 28 a1
    CP $40                              ; $BED1 fe 40
    JR NZ,$BEF6                         ; $BED3 20 21
    LD A,(IX+$00)                       ; $BED5 dd 7e 00
    PUSH IX                             ; $BED8 dd e5
    CALL $D237                          ; $BEDA cd 37 d2
    BIT 6,(IX+$06)                      ; $BEDD dd cb 06 76
    POP IX                              ; $BEE1 dd e1
    JR Z,$BE72                          ; $BEE3 28 8d
    LD A,(IX+$02)                       ; $BEE5 dd 7e 02
    PUSH IX                             ; $BEE8 dd e5
    CALL $D237                          ; $BEEA cd 37 d2
    BIT 6,(IX+$06)                      ; $BEED dd cb 06 76
    POP IX                              ; $BEF1 dd e1
    JP Z,$BE72                          ; $BEF3 ca 72 be
    BIT 2,(IX+$03)                      ; $BEF6 dd cb 03 56
    JR Z,$BEC0                          ; $BEFA 28 c4
    PUSH IX                             ; $BEFC dd e5
    CALL $BF08                          ; $BEFE cd 08 bf
    POP IX                              ; $BF01 dd e1
    JR NZ,$BEC0                         ; $BF03 20 bb
    JP $BE72                            ; $BF05 c3 72 be
    CALL $BE5A                          ; $BF08 cd 5a be
    BIT 3,(IX+$03)                      ; $BF0B dd cb 03 5e
    PUSH AF                             ; $BF0F f5
    CALL $BE91                          ; $BF10 cd 91 be
    JR NZ,$BF18                         ; $BF13 20 03
    POP AF                              ; $BF15 f1
    XOR A                               ; $BF16 af
    RET                                 ; $BF17 c9
    POP AF                              ; $BF18 f1
    JR Z,$BF0B                          ; $BF19 28 f0
    RET                                 ; $BF1B c9
    LD A,(IX+$00)                       ; $BF1C dd 7e 00
    CALL $A4BC                          ; $BF1F cd bc a4
    PUSH HL                             ; $BF22 e5
    POP IY                              ; $BF23 fd e1
    CALL $D3E8                          ; $BF25 cd e8 d3
    CALL $BF45                          ; $BF28 cd 45 bf
    JR Z,$BF3D                          ; $BF2B 28 10
    CALL $A887                          ; $BF2D cd 87 a8
    LD A,(IX+$02)                       ; $BF30 dd 7e 02
    CALL $A4BC                          ; $BF33 cd bc a4
    PUSH HL                             ; $BF36 e5
    POP IY                              ; $BF37 fd e1
    CALL $D3E8                          ; $BF39 cd e8 d3
    RET                                 ; $BF3C c9
    LD DE,$005D                         ; $BF3D 11 5d 00
    CALL $A887                          ; $BF40 cd 87 a8
    JR $BF30                            ; $BF43 18 eb
    LD A,(IX+$01)                       ; $BF45 dd 7e 01
    AND A                               ; $BF48 a7
    RET Z                               ; $BF49 c8
    DEC A                               ; $BF4A 3d
    LD E,A                              ; $BF4B 5f
    LD D,$00                            ; $BF4C 16 00
    LD HL,$994D                         ; $BF4E 21 4d 99
    ADD HL,DE                           ; $BF51 19
    ADD HL,DE                           ; $BF52 19
    LD E,(HL)                           ; $BF53 5e
    INC HL                              ; $BF54 23
    LD D,(HL)                           ; $BF55 56
    OR $01                              ; $BF56 f6 01
    RET                                 ; $BF58 c9

    ORG $C0DF
; CODE: load-header routine; header data follows. Runtime-written absolute targets are excluded by the JS exporter.
    LD ($C109),DE                       ; $C0DF ed 53 09 c1
    LD ($C10B),IX                       ; $C0E3 dd 22 0b c1
    LD HL,$C0BC                         ; $C0E7 21 bc c0
    CALL $C1CB                          ; $C0EA cd cb c1
    LD IX,$C0FE                         ; $C0ED dd 21 fe c0
    LD DE,$0011                         ; $C0F1 11 11 00
    LD A,$00                            ; $C0F4 3e 00
    AND A                               ; $C0F6 a7
    CALL $0556                          ; $C0F7 cd 56 05
    JR NC,$C0ED                         ; $C0FA 30 f1
    JR $C089                            ; $C0FC 18 8b

    ORG $C591
; CODE: rule argument enumeration. Runtime-written absolute targets are excluded by the JS exporter.
    PUSH HL                             ; $C591 e5
    POP IX                              ; $C592 dd e1
    CALL $C571                          ; $C594 cd 71 c5
    CALL $C57A                          ; $C597 cd 7a c5
    XOR A                               ; $C59A af
    LD ($A00B),A                        ; $C59B 32 0b a0
    LD A,($A00F)                        ; $C59E 3a 0f a0
    LD HL,$A010                         ; $C5A1 21 10 a0
    OR (HL)                             ; $C5A4 b6
    JR Z,$C5F4                          ; $C5A5 28 4d
    LD A,($A00F)                        ; $C5A7 3a 0f a0
    CP $05                              ; $C5AA fe 05
    JR Z,$C5B2                          ; $C5AC 28 04
    CP $06                              ; $C5AE fe 06
    JR NZ,$C5BA                         ; $C5B0 20 08
    LD A,($A034)                        ; $C5B2 3a 34 a0
    CP $FE                              ; $C5B5 fe fe
    JP NZ,$CB41                         ; $C5B7 c2 41 cb
    LD A,($A010)                        ; $C5BA 3a 10 a0
    CP $05                              ; $C5BD fe 05
    JR Z,$C5C5                          ; $C5BF 28 04
    CP $06                              ; $C5C1 fe 06
    JR NZ,$C5CD                         ; $C5C3 20 08
    LD A,($A035)                        ; $C5C5 3a 35 a0
    CP $FE                              ; $C5C8 fe fe
    JP NZ,$CB41                         ; $C5CA c2 41 cb
    LD A,($A00F)                        ; $C5CD 3a 0f a0
    AND A                               ; $C5D0 a7
    JR Z,$C5EB                          ; $C5D1 28 18
    LD A,($A034)                        ; $C5D3 3a 34 a0
    CP $FF                              ; $C5D6 fe ff
    JR NZ,$C5EB                         ; $C5D8 20 11
    LD B,$00                            ; $C5DA 06 00
    CALL $C463                          ; $C5DC cd 63 c4
    RET Z                               ; $C5DF c8
    LD ($A034),A                        ; $C5E0 32 34 a0
    CALL $C60D                          ; $C5E3 cd 0d c6
    JR NZ,$C5F4                         ; $C5E6 20 0c
    INC B                               ; $C5E8 04
    JR $C5DC                            ; $C5E9 18 f1
    CALL $C5FC                          ; $C5EB cd fc c5
    JR Z,$C5F4                          ; $C5EE 28 04
    CALL $C613                          ; $C5F0 cd 13 c6
    RET Z                               ; $C5F3 c8
    LD A,$01                            ; $C5F4 3e 01
    LD ($A00B),A                        ; $C5F6 32 0b a0
    JP $C989                            ; $C5F9 c3 89 c9
    LD A,($A010)                        ; $C5FC 3a 10 a0
    AND A                               ; $C5FF a7
    RET Z                               ; $C600 c8
    LD A,($A035)                        ; $C601 3a 35 a0
    CP $FF                              ; $C604 fe ff
    JR NZ,$C60B                         ; $C606 20 03
    OR $01                              ; $C608 f6 01
    RET                                 ; $C60A c9
    XOR A                               ; $C60B af
    RET                                 ; $C60C c9
    CALL $C5FC                          ; $C60D cd fc c5
    JP Z,$C989                          ; $C610 ca 89 c9
    PUSH BC                             ; $C613 c5
    LD B,$00                            ; $C614 06 00
    CALL $C45E                          ; $C616 cd 5e c4
    JR Z,$C626                          ; $C619 28 0b
    LD ($A035),A                        ; $C61B 32 35 a0
    CALL $C989                          ; $C61E cd 89 c9
    JR NZ,$C626                         ; $C621 20 03
    INC B                               ; $C623 04
    JR $C616                            ; $C624 18 f0
    POP BC                              ; $C626 c1
    RET                                 ; $C627 c9

    ORG $C9BF
; CODE: rule preflight and execution. Runtime-written absolute targets are excluded by the JS exporter.
    PUSH HL                             ; $C9BF e5
    POP IY                              ; $C9C0 fd e1
    CALL $D078                          ; $C9C2 cd 78 d0
    JR NC,$C9D3                         ; $C9C5 30 0c
    LD A,(IY+$00)                       ; $C9C7 fd 7e 00
    AND $20                             ; $C9CA e6 20
    JR Z,$C9D3                          ; $C9CC 28 05
    LD HL,$CBBB                         ; $C9CE 21 bb cb
    XOR A                               ; $C9D1 af
    RET                                 ; $C9D2 c9
    CALL $C628                          ; $C9D3 cd 28 c6
    JR Z,$C9D1                          ; $C9D6 28 f9
    CALL $C6BE                          ; $C9D8 cd be c6
    JR Z,$C9D1                          ; $C9DB 28 f4
    BIT 6,(IY+$00)                      ; $C9DD fd cb 00 76
    JR Z,$C9F2                          ; $C9E1 28 0f
    LD L,(IY+$02)                       ; $C9E3 fd 6e 02
    LD H,(IY+$03)                       ; $C9E6 fd 66 03
    PUSH IY                             ; $C9E9 fd e5
    CALL $CB34                          ; $C9EB cd 34 cb
    POP IY                              ; $C9EE fd e1
    JR Z,$C9D1                          ; $C9F0 28 df
    LD A,($A00B)                        ; $C9F2 3a 0b a0
    AND A                               ; $C9F5 a7
    JR NZ,$C9FB                         ; $C9F6 20 03
    OR $01                              ; $C9F8 f6 01
    RET                                 ; $C9FA c9
    PUSH IY                             ; $C9FB fd e5
    LD A,(IY+$01)                       ; $C9FD fd 7e 01
    RRCA                                ; $CA00 0f
    RRCA                                ; $CA01 0f
    RRCA                                ; $CA02 0f
    RRCA                                ; $CA03 0f
    AND $0F                             ; $CA04 e6 0f
    LD L,A                              ; $CA06 6f
    LD H,$00                            ; $CA07 26 00
    LD ($A01F),HL                       ; $CA09 22 1f a0
    POP HL                              ; $CA0C e1
    LD DE,$0002                         ; $CA0D 11 02 00
    ADD HL,DE                           ; $CA10 19
    BIT 6,(IY+$00)                      ; $CA11 fd cb 00 76
    JR Z,$CA18                          ; $CA15 28 01
    ADD HL,DE                           ; $CA17 19
    LD DE,$0005                         ; $CA18 11 05 00
    BIT 4,(IY+$00)                      ; $CA1B fd cb 00 66
    JR Z,$CA22                          ; $CA1F 28 01
    ADD HL,DE                           ; $CA21 19
    LD A,($A00A)                        ; $CA22 3a 0a a0
    LD ($C491),A                        ; $CA25 32 91 c4
    LD IX,($A013)                       ; $CA28 dd 2a 13 a0
    LD A,(IX+$0F)                       ; $CA2C dd 7e 0f
    LD ($C492),A                        ; $CA2F 32 92 c4
    PUSH HL                             ; $CA32 e5
    PUSH IY                             ; $CA33 fd e5
    LD A,$01                            ; $CA35 3e 01
    LD ($A00C),A                        ; $CA37 32 0c a0
    CALL $CA76                          ; $CA3A cd 76 ca
    POP IY                              ; $CA3D fd e1
    POP HL                              ; $CA3F e1
    BIT 7,(IY+$00)                      ; $CA40 fd cb 00 7e
    JR Z,$CA48                          ; $CA44 28 02
    SCF                                 ; $CA46 37
    RET                                 ; $CA47 c9
    LD A,($9FD7)                        ; $CA48 3a d7 9f
    INC A                               ; $CA4B 3c
    JR NZ,$CA54                         ; $CA4C 20 06
    LD A,($A034)                        ; $CA4E 3a 34 a0
    LD ($9FD7),A                        ; $CA51 32 d7 9f
    LD A,($9FD8)                        ; $CA54 3a d8 9f
    INC A                               ; $CA57 3c
    JR NZ,$CA60                         ; $CA58 20 06
    LD A,($A035)                        ; $CA5A 3a 35 a0
    LD ($9FD8),A                        ; $CA5D 32 d8 9f
    XOR A                               ; $CA60 af
    LD ($CAAE),A                        ; $CA61 32 ae ca
    CALL $CB2C                          ; $CA64 cd 2c cb
    PUSH AF                             ; $CA67 f5
    PUSH HL                             ; $CA68 e5
    CALL $CA7F                          ; $CA69 cd 7f ca
    LD A,($CAAE)                        ; $CA6C 3a ae ca
    AND A                               ; $CA6F a7
    CALL Z,$CAAF                        ; $CA70 cc af ca
    POP HL                              ; $CA73 e1
    POP AF                              ; $CA74 f1
    RET                                 ; $CA75 c9
    LD A,($A033)                        ; $CA76 3a 33 a0
    AND $80                             ; $CA79 e6 80
    CALL Z,$A2E4                        ; $CA7B cc e4 a2
    RET                                 ; $CA7E c9
    LD A,($9860)                        ; $CA7F 3a 60 98
    CALL $D237                          ; $CA82 cd 37 d2
    LD A,($A009)                        ; $CA85 3a 09 a0
    CP (IX+$0F)                         ; $CA88 dd be 0f
    RET Z                               ; $CA8B c8
    LD A,($A036)                        ; $CA8C 3a 36 a0
    PUSH AF                             ; $CA8F f5
    LD A,($9860)                        ; $CA90 3a 60 98
    LD ($A036),A                        ; $CA93 32 36 a0
    CALL $CA9E                          ; $CA96 cd 9e ca
    POP AF                              ; $CA99 f1
    LD ($A036),A                        ; $CA9A 32 36 a0
    RET                                 ; $CA9D c9
    LD A,($DD01)                        ; $CA9E 3a 01 dd
    LD HL,($DCFF)                       ; $CAA1 2a ff dc
    BIT 6,(HL)                          ; $CAA4 cb 76
    JP NZ,$D1B2                         ; $CAA6 c2 b2 d1
    SET 6,(HL)                          ; $CAA9 cb f6
    JP $D102                            ; $CAAB c3 02 d1

    ORG $CAAF
; CODE: visibility notifications. Runtime-written absolute targets are excluded by the JS exporter.
    CALL $DC6C                          ; $CAAF cd 6c dc
    RET Z                               ; $CAB2 c8
    LD A,($C491)                        ; $CAB3 3a 91 c4
    LD HL,$A009                         ; $CAB6 21 09 a0
    CP (HL)                             ; $CAB9 be
    RET Z                               ; $CABA c8
    LD A,($A036)                        ; $CABB 3a 36 a0
    CALL $D495                          ; $CABE cd 95 d4
    LD HL,$A009                         ; $CAC1 21 09 a0
    CP (HL)                             ; $CAC4 be
    JR NZ,$CAD0                         ; $CAC5 20 09
    LD A,($A036)                        ; $CAC7 3a 36 a0
    LD DE,$68ED                         ; $CACA 11 ed 68
    CALL $CBC2                          ; $CACD cd c2 cb
    LD A,($A00F)                        ; $CAD0 3a 0f a0
    CP $07                              ; $CAD3 fe 07
    RET C                               ; $CAD5 d8
    LD A,($A034)                        ; $CAD6 3a 34 a0
    CALL $D495                          ; $CAD9 cd 95 d4
    CP $FF                              ; $CADC fe ff
    JR NZ,$CB12                         ; $CADE 20 32
    LD B,(IX+$00)                       ; $CAE0 dd 46 00
    LD A,($A009)                        ; $CAE3 3a 09 a0
    CP (IX+$0F)                         ; $CAE6 dd be 0f
    JR Z,$CAF0                          ; $CAE9 28 05
    INC IX                              ; $CAEB dd 23
    DJNZ $CAE6                          ; $CAED 10 f7
    RET                                 ; $CAEF c9
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
    LD A,($C492)                        ; $CB12 3a 92 c4
    LD HL,$A009                         ; $CB15 21 09 a0
    CP (HL)                             ; $CB18 be
    RET Z                               ; $CB19 c8
    LD A,($A034)                        ; $CB1A 3a 34 a0
    LD HL,$A036                         ; $CB1D 21 36 a0
    CP (HL)                             ; $CB20 be
    RET Z                               ; $CB21 c8
    LD DE,$68ED                         ; $CB22 11 ed 68
    JP $CBC2                            ; $CB25 c3 c2 cb

    ORG $E0ED
; CODE: corpse action tail, called by deferred rule E0EB. Runtime-written absolute targets are excluded by the JS exporter.
    LD A,$51                            ; $E0ED 3e 51
    JP $9C56                            ; $E0EF c3 56 9c

    ORG $E0FF
; CODE: corpse action tail, called by deferred rule E0FD. Runtime-written absolute targets are excluded by the JS exporter.
    LD A,$3F                            ; $E0FF 3e 3f
    JP $9C56                            ; $E101 c3 56 9c

    ORG $CB2C
; CODE: predicate trampoline and errors. Runtime-written absolute targets are excluded by the JS exporter.
    LD IX,($CB28)                       ; $CB2C dd 2a 28 cb
    LD IY,($CB2A)                       ; $CB30 fd 2a 2a cb
    CALL $CB40                          ; $CB34 cd 40 cb
    LD ($CB28),IX                       ; $CB37 dd 22 28 cb
    LD ($CB2A),IY                       ; $CB3B fd 22 2a cb
    RET                                 ; $CB3F c9
    JP (HL)                             ; $CB40 e9
    XOR A                               ; $CB41 af
    RET                                 ; $CB42 c9
    PUSH HL                             ; $CB43 e5
    CALL $DC6C                          ; $CB44 cd 6c dc
    POP HL                              ; $CB47 e1
    JR NZ,$CB65                         ; $CB48 20 1b
    XOR A                               ; $CB4A af
    LD ($A036),A                        ; $CB4B 32 36 a0
    LD A,($A00B)                        ; $CB4E 3a 0b a0
    AND A                               ; $CB51 a7
    JR Z,$CB5F                          ; $CB52 28 0b
    LD A,L                              ; $CB54 7d
    OR H                                ; $CB55 b4
    JR NZ,$CB67                         ; $CB56 20 0f
    XOR A                               ; $CB58 af
    LD ($A00C),A                        ; $CB59 32 0c a0
    CALL $CA76                          ; $CB5C cd 76 ca
    LD A,($9860)                        ; $CB5F 3a 60 98
    LD ($A036),A                        ; $CB62 32 36 a0
    XOR A                               ; $CB65 af
    RET                                 ; $CB66 c9
    LD A,$01                            ; $CB67 3e 01
    LD ($A027),A                        ; $CB69 32 27 a0
    PUSH IY                             ; $CB6C fd e5
    CALL $CB40                          ; $CB6E cd 40 cb
    POP IY                              ; $CB71 fd e1
    XOR A                               ; $CB73 af
    LD ($A027),A                        ; $CB74 32 27 a0
    JR $CB5F                            ; $CB77 18 e6

    ORG $CB7B
; CODE: request restriction and containment notification. Runtime-written absolute targets are excluded by the JS exporter.
    LD A,($CB79)                        ; $CB7B 3a 79 cb
    BIT 7,A                             ; $CB7E cb 7f
    LD HL,$C471                         ; $CB80 21 71 c4
    JR Z,$CB88                          ; $CB83 28 03
    LD HL,$C481                         ; $CB85 21 81 c4
    OR $80                              ; $CB88 f6 80
    LD E,(HL)                           ; $CB8A 5e
    INC HL                              ; $CB8B 23
    LD D,(HL)                           ; $CB8C 56
    INC HL                              ; $CB8D 23
    RRCA                                ; $CB8E 0f
    JR NC,$CB8A                         ; $CB8F 30 f9
    LD A,D                              ; $CB91 7a
    OR E                                ; $CB92 b3
    JR Z,$CB58                          ; $CB93 28 c3
    LD A,($CB7A)                        ; $CB95 3a 7a cb
    LD ($A034),A                        ; $CB98 32 34 a0
    LD HL,$6817                         ; $CB9B 21 17 68
    CALL $A59F                          ; $CB9E cd 9f a5
    CALL $A887                          ; $CBA1 cd 87 a8
    JP $A2A2                            ; $CBA4 c3 a2 a2
    LD A,($B934)                        ; $CBA7 3a 34 b9
    BIT 6,A                             ; $CBAA cb 77
    RET Z                               ; $CBAC c8
    POP HL                              ; $CBAD e1
    XOR A                               ; $CBAE af
    LD ($A027),A                        ; $CBAF 32 27 a0
    LD HL,$681A                         ; $CBB2 21 1a 68
    CALL $A59F                          ; $CBB5 cd 9f a5
    JP $DC15                            ; $CBB8 c3 15 dc
    LD HL,$68D1                         ; $CBBB 21 d1 68
    CALL $A59F                          ; $CBBE cd 9f a5
    RET                                 ; $CBC1 c9
    CP $FF                              ; $CBC2 fe ff
    RET Z                               ; $CBC4 c8
    AND A                               ; $CBC5 a7
    RET Z                               ; $CBC6 c8
    LD B,A                              ; $CBC7 47
    CALL $D495                          ; $CBC8 cd 95 d4
    LD C,A                              ; $CBCB 4f
    LD A,($A009)                        ; $CBCC 3a 09 a0
    CP C                                ; $CBCF b9
    RET NZ                              ; $CBD0 c0
    LD A,$01                            ; $CBD1 3e 01
    LD ($5C3C),A                        ; $CBD3 32 3c 5c
    PUSH DE                             ; $CBD6 d5
    LD A,B                              ; $CBD7 78
    CALL $D237                          ; $CBD8 cd 37 d2
    LD A,(IX+$01)                       ; $CBDB dd 7e 01
    CP $FF                              ; $CBDE fe ff
    JR Z,$CBE5                          ; $CBE0 28 03
    LD B,A                              ; $CBE2 47
    JR $CBD7                            ; $CBE3 18 f2
    LD A,B                              ; $CBE5 78
    CALL $A4BC                          ; $CBE6 cd bc a4
    EX (SP),HL                          ; $CBE9 e3
    LD A,($A036)                        ; $CBEA 3a 36 a0
    PUSH AF                             ; $CBED f5
    LD A,($9860)                        ; $CBEE 3a 60 98
    LD ($A036),A                        ; $CBF1 32 36 a0
    CALL $CC29                          ; $CBF4 cd 29 cc
    LD A,B                              ; $CBF7 78
    CALL $C821                          ; $CBF8 cd 21 c8
    JR NZ,$CC00                         ; $CBFB 20 03
    POP AF                              ; $CBFD f1
    POP HL                              ; $CBFE e1
    RET                                 ; $CBFF c9
    POP AF                              ; $CC00 f1
    LD ($A036),A                        ; $CC01 32 36 a0
    CALL $CC29                          ; $CC04 cd 29 cc
    CALL $A59F                          ; $CC07 cd 9f a5
    RET                                 ; $CC0A c9

    ORG $A11A
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00,$00 ; $A11A 00 00

    ORG $A35D
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00,$00,$00 ; $A35D 00 00 00

    ORG $A6D1
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00,$00 ; $A6D1 00 00

    ORG $A7EA
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00 ; $A7EA 00

    ORG $A851
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00 ; $A851 00

    ORG $B6D6
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00,$00,$00,$00 ; $B6D6 00 00 00 00

    ORG $B77E
; DATA: mutable scratch; explicitly absent from immutable entropy.
    DEFB $00 ; $B77E 00

; CODE: statically reachable typed routines. Indirect jumps are not followed.
    ORG $9A80
    LD A,($A036)                        ; $9A80 3a 36 a0
    CP $00                              ; $9A83 fe 00
    LD A,$01                            ; $9A85 3e 01
    LD HL,$6915                         ; $9A87 21 15 69
    JR Z,$9A90                          ; $9A8A 28 04
    XOR A                               ; $9A8C af
    LD HL,$6920                         ; $9A8D 21 20 69
    LD ($A027),A                        ; $9A90 32 27 a0
    CALL $A59F                          ; $9A93 cd 9f a5
    OR $01                              ; $9A96 f6 01
    RET                                 ; $9A98 c9
    ORG $9A9B
    CALL $9AA3                          ; $9A9B cd a3 9a
    JP Z,$DC15                          ; $9A9E ca 15 dc
    JR $9AD7                            ; $9AA1 18 34
    LD A,($A00A)                        ; $9AA3 3a 0a a0
    CP $67                              ; $9AA6 fe 67
    JR NZ,$9AB5                         ; $9AA8 20 0b
    LD A,($A034)                        ; $9AAA 3a 34 a0
    CP $32                              ; $9AAD fe 32
    LD L,$70                            ; $9AAF 2e 70
    JR Z,$9AC8                          ; $9AB1 28 15
    XOR A                               ; $9AB3 af
    RET                                 ; $9AB4 c9
    CP $32                              ; $9AB5 fe 32
    JR NZ,$9AB3                         ; $9AB7 20 fa
    LD A,($A034)                        ; $9AB9 3a 34 a0
    CP $67                              ; $9ABC fe 67
    LD L,$72                            ; $9ABE 2e 72
    JR Z,$9AC8                          ; $9AC0 28 06
    CP $12                              ; $9AC2 fe 12
    JR NZ,$9AB3                         ; $9AC4 20 ed
    LD L,$5E                            ; $9AC6 2e 5e
    OR $01                              ; $9AC8 f6 01
    RET                                 ; $9ACA c9
    ORG $9ACD
    CALL $9AA3                          ; $9ACD cd a3 9a
    JP Z,$DC15                          ; $9AD0 ca 15 dc
    LD A,L                              ; $9AD3 7d
    SUB $14                             ; $9AD4 d6 14
    LD L,A                              ; $9AD6 6f
    LD A,$6D                            ; $9AD7 3e 6d
    LD ($E2C6),A                        ; $9AD9 32 c6 e2
    LD A,$69                            ; $9ADC 3e 69
    JP $9B04                            ; $9ADE c3 04 9b
    ORG $9AE3
    CALL $9B50                          ; $9AE3 cd 50 9b
    LD DE,$0006                         ; $9AE6 11 06 00
    CALL $9B25                          ; $9AE9 cd 25 9b
    LD A,(IX+$02)                       ; $9AEC dd 7e 02
    SUB $02                             ; $9AEF d6 02
    LD L,A                              ; $9AF1 6f
    JR $9B02                            ; $9AF2 18 0e
    ORG $9AF6
    CALL $9B50                          ; $9AF6 cd 50 9b
    LD DE,$0002                         ; $9AF9 11 02 00
    CALL $9B25                          ; $9AFC cd 25 9b
    LD L,(IX+$02)                       ; $9AFF dd 6e 02
    LD A,$01                            ; $9B02 3e 01
    PUSH AF                             ; $9B04 f5
    LD H,$00                            ; $9B05 26 00
    LD ($A01F),HL                       ; $9B07 22 1f a0
    LD A,($E2C6)                        ; $9B0A 3a c6 e2
    CALL $9C60                          ; $9B0D cd 60 9c
    POP BC                              ; $9B10 c1
    PUSH BC                             ; $9B11 c5
    LD A,($E2C6)                        ; $9B12 3a c6 e2
    CALL $DD0E                          ; $9B15 cd 0e dd
    POP AF                              ; $9B18 f1
    CALL $D224                          ; $9B19 cd 24 d2
    RES 6,(IX+$00)                      ; $9B1C dd cb 00 b6
    LD HL,$F3AD                         ; $9B20 21 ad f3
    SCF                                 ; $9B23 37
    RET                                 ; $9B24 c9
    LD A,(IX+$02)                       ; $9B25 dd 7e 02
    PUSH IX                             ; $9B28 dd e5
    LD HL,$0000                         ; $9B2A 21 00 00
    ADD HL,DE                           ; $9B2D 19
    SUB $05                             ; $9B2E d6 05
    JR NC,$9B2D                         ; $9B30 30 fb
    EX DE,HL                            ; $9B32 eb
    LD A,($A036)                        ; $9B33 3a 36 a0
    CALL $E619                          ; $9B36 cd 19 e6
    JR Z,$9B44                          ; $9B39 28 09
    CALL $E39C                          ; $9B3B cd 9c e3
    AND A                               ; $9B3E a7
    SBC HL,DE                           ; $9B3F ed 52
    CALL $E38F                          ; $9B41 cd 8f e3
    CALL $CFB6                          ; $9B44 cd b6 cf
    LD A,(IX+$03)                       ; $9B47 dd 7e 03
    LD ($A035),A                        ; $9B4A 32 35 a0
    POP IX                              ; $9B4D dd e1
    RET                                 ; $9B4F c9
    LD A,($A036)                        ; $9B50 3a 36 a0
    DEC A                               ; $9B53 3d
    LD IY,($A017)                       ; $9B54 fd 2a 17 a0
    LD (IY+$01),A                       ; $9B58 fd 77 01
    LD ($E2C6),A                        ; $9B5B 32 c6 e2
    CALL $D237                          ; $9B5E cd 37 d2
    LD A,(IX+$0F)                       ; $9B61 dd 7e 0f
    LD (IY+$0F),A                       ; $9B64 fd 77 0f
    LD ($A00A),A                        ; $9B67 32 0a a0
    LD A,($A034)                        ; $9B6A 3a 34 a0
    LD C,A                              ; $9B6D 4f
    LD A,($A00A)                        ; $9B6E 3a 0a a0
    CALL $9C07                          ; $9B71 cd 07 9c
    RET Z                               ; $9B74 c8
    POP HL                              ; $9B75 e1
    LD HL,$6C34                         ; $9B76 21 34 6c
    CALL $A59F                          ; $9B79 cd 9f a5
    OR $01                              ; $9B7C f6 01
    RET                                 ; $9B7E c9
    ORG $9C07
    LD IX,$9B7F                         ; $9C07 dd 21 7f 9b
    PUSH BC                             ; $9C0B c5
    LD B,A                              ; $9C0C 47
    LD A,(IX+$00)                       ; $9C0D dd 7e 00
    CP $FF                              ; $9C10 fe ff
    JR Z,$9C3D                          ; $9C12 28 29
    LD A,B                              ; $9C14 78
    CP (IX+$00)                         ; $9C15 dd be 00
    JR Z,$9C2A                          ; $9C18 28 10
    CP (IX+$01)                         ; $9C1A dd be 01
    JR NZ,$9C33                         ; $9C1D 20 14
    LD A,C                              ; $9C1F 79
    AND A                               ; $9C20 a7
    JR Z,$9C3B                          ; $9C21 28 18
    CP (IX+$00)                         ; $9C23 dd be 00
    JR NZ,$9C33                         ; $9C26 20 0b
    JR $9C3B                            ; $9C28 18 11
    LD A,C                              ; $9C2A 79
    AND A                               ; $9C2B a7
    JR Z,$9C3B                          ; $9C2C 28 0d
    CP (IX+$01)                         ; $9C2E dd be 01
    JR Z,$9C3B                          ; $9C31 28 08
    INC IX                              ; $9C33 dd 23
    INC IX                              ; $9C35 dd 23
    INC IX                              ; $9C37 dd 23
    JR $9C0D                            ; $9C39 18 d2
    POP BC                              ; $9C3B c1
    RET                                 ; $9C3C c9
    OR $01                              ; $9C3D f6 01
    POP BC                              ; $9C3F c1
    RET                                 ; $9C40 c9
    ORG $9C43
    LD IX,($A017)                       ; $9C43 dd 2a 17 a0
    LD A,(IX+$01)                       ; $9C47 dd 7e 01
    PUSH AF                             ; $9C4A f5
    CALL $9C56                          ; $9C4B cd 56 9c
    LD A,($A034)                        ; $9C4E 3a 34 a0
    LD B,A                              ; $9C51 47
    POP AF                              ; $9C52 f1
    JP $DD0E                            ; $9C53 c3 0e dd
    CALL $D237                          ; $9C56 cd 37 d2
    SET 7,(IX+$05)                      ; $9C59 dd cb 05 fe
    OR $01                              ; $9C5D f6 01
    RET                                 ; $9C5F c9
    CALL $D237                          ; $9C60 cd 37 d2
    RES 7,(IX+$05)                      ; $9C63 dd cb 05 be
    OR $01                              ; $9C67 f6 01
    RET                                 ; $9C69 c9
    LD A,($A036)                        ; $9C6A 3a 36 a0
    LD IX,$9C85                         ; $9C6D dd 21 85 9c
    CALL $D34E                          ; $9C71 cd 4e d3
    CP $FF                              ; $9C74 fe ff
    RET                                 ; $9C76 c9
    CALL $9C6A                          ; $9C77 cd 6a 9c
    RET Z                               ; $9C7A c8
    LD L,(IX+$01)                       ; $9C7B dd 6e 01
    LD H,(IX+$02)                       ; $9C7E dd 66 02
    LD A,L                              ; $9C81 7d
    OR H                                ; $9C82 b4
    RET Z                               ; $9C83 c8
    JP (HL)                             ; $9C84 e9
    ORG $9CA2
    LD A,$55                            ; $9CA2 3e 55
    CALL $D237                          ; $9CA4 cd 37 d2
    BIT 7,(IX+$05)                      ; $9CA7 dd cb 05 7e
    RET Z                               ; $9CAB c8
    LD HL,$9CA1                         ; $9CAC 21 a1 9c
    LD A,(HL)                           ; $9CAF 7e
    CP $FF                              ; $9CB0 fe ff
    RET Z                               ; $9CB2 c8
    DEC (HL)                            ; $9CB3 35
    RET NZ                              ; $9CB4 c0
    LD HL,$015B                         ; $9CB5 21 5b 01
    LD (IX+$09),L                       ; $9CB8 dd 75 09
    LD (IX+$0A),H                       ; $9CBB dd 74 0a
    XOR A                               ; $9CBE af
    LD (IX+$0D),A                       ; $9CBF dd 77 0d
    LD (IX+$0E),A                       ; $9CC2 dd 77 0e
    LD IX,$99B7                         ; $9CC5 dd 21 b7 99
    RES 1,(IX+$03)                      ; $9CC9 dd cb 03 8e
    RET                                 ; $9CCD c9
    LD IX,($A017)                       ; $9CCE dd 2a 17 a0
    LD B,(IX+$0F)                       ; $9CD2 dd 46 0f
    LD A,C                              ; $9CD5 79
    CALL $D237                          ; $9CD6 cd 37 d2
    LD A,(IX+$0F)                       ; $9CD9 dd 7e 0f
    CP B                                ; $9CDC b8
    RET NZ                              ; $9CDD c0
    LD A,C                              ; $9CDE 79
    CALL $C821                          ; $9CDF cd 21 c8
    JR Z,$9CE6                          ; $9CE2 28 02
    XOR A                               ; $9CE4 af
    RET                                 ; $9CE5 c9
    OR $01                              ; $9CE6 f6 01
    RET                                 ; $9CE8 c9
    CALL $9CF2                          ; $9CE9 cd f2 9c
    LD HL,$6929                         ; $9CEC 21 29 69
    JP $A59F                            ; $9CEF c3 9f a5
    LD A,C                              ; $9CF2 79
    LD ($A034),A                        ; $9CF3 32 34 a0
    CALL $9CCE                          ; $9CF6 cd ce 9c
    JR Z,$9D02                          ; $9CF9 28 07
    DEC (HL)                            ; $9CFB 35
    JP P,$9D00                          ; $9CFC f2 00 9d
    INC (HL)                            ; $9CFF 34
    POP DE                              ; $9D00 d1
    RET                                 ; $9D01 c9
    LD A,(HL)                           ; $9D02 7e
    AND A                               ; $9D03 a7
    JR NZ,$9D00                         ; $9D04 20 fa
    LD A,$0F                            ; $9D06 3e 0f
    CALL $D2A4                          ; $9D08 cd a4 d2
    ADD A,$1E                           ; $9D0B c6 1e
    LD (HL),A                           ; $9D0D 77
    XOR A                               ; $9D0E af
    RET                                 ; $9D0F c9
    ORG $9D13
    LD HL,$9D10                         ; $9D13 21 10 9d
    LD C,$00                            ; $9D16 0e 00
    CALL $9CE9                          ; $9D18 cd e9 9c
    LD HL,$9D11                         ; $9D1B 21 11 9d
    LD C,$02                            ; $9D1E 0e 02
    CALL $9CE9                          ; $9D20 cd e9 9c
    LD HL,$9D12                         ; $9D23 21 12 9d
    LD C,$04                            ; $9D26 0e 04
    CALL $9CE9                          ; $9D28 cd e9 9c
    JP $E691                            ; $9D2B c3 91 e6
    ORG $9D30
    LD A,($9D90)                        ; $9D30 3a 90 9d
    AND A                               ; $9D33 a7
    RET Z                               ; $9D34 c8
    LD HL,$9D2E                         ; $9D35 21 2e 9d
    LD C,$00                            ; $9D38 0e 00
    CALL $9CE9                          ; $9D3A cd e9 9c
    LD HL,$9D2F                         ; $9D3D 21 2f 9d
    LD C,$03                            ; $9D40 0e 03
    JP $9CE9                            ; $9D42 c3 e9 9c
    ORG $9D48
    LD A,($9D90)                        ; $9D48 3a 90 9d
    AND A                               ; $9D4B a7
    RET NZ                              ; $9D4C c0
    LD HL,$9D45                         ; $9D4D 21 45 9d
    LD C,$00                            ; $9D50 0e 00
    CALL $9D65                          ; $9D52 cd 65 9d
    LD HL,$9D46                         ; $9D55 21 46 9d
    LD C,$03                            ; $9D58 0e 03
    CALL $9D65                          ; $9D5A cd 65 9d
    LD HL,$9D47                         ; $9D5D 21 47 9d
    LD C,$07                            ; $9D60 0e 07
    JP $9D65                            ; $9D62 c3 65 9d
    CALL $9CF2                          ; $9D65 cd f2 9c
    LD (HL),$01                         ; $9D68 36 01
    LD HL,$6D9A                         ; $9D6A 21 9a 6d
    JP $A59F                            ; $9D6D c3 9f a5
    ORG $9D73
    LD A,($9D90)                        ; $9D73 3a 90 9d
    AND A                               ; $9D76 a7
    RET NZ                              ; $9D77 c0
    LD HL,$9D70                         ; $9D78 21 70 9d
    LD C,$00                            ; $9D7B 0e 00
    CALL $9D65                          ; $9D7D cd 65 9d
    LD HL,$9D71                         ; $9D80 21 71 9d
    LD C,$03                            ; $9D83 0e 03
    CALL $9D65                          ; $9D85 cd 65 9d
    LD HL,$9D72                         ; $9D88 21 72 9d
    LD C,$07                            ; $9D8B 0e 07
    JP $9D65                            ; $9D8D c3 65 9d
    ORG $9D95
    LD HL,$9D91                         ; $9D95 21 91 9d
    LD C,$00                            ; $9D98 0e 00
    CALL $9DC6                          ; $9D9A cd c6 9d
    LD HL,$9D94                         ; $9D9D 21 94 9d
    LD C,$00                            ; $9DA0 0e 00
    CALL $9DD8                          ; $9DA2 cd d8 9d
    LD HL,$9D93                         ; $9DA5 21 93 9d
    LD C,$03                            ; $9DA8 0e 03
    CALL $9CE9                          ; $9DAA cd e9 9c
    LD IX,$99E3                         ; $9DAD dd 21 e3 99
    RES 0,(IX+$03)                      ; $9DB1 dd cb 03 86
    LD IX,$99F1                         ; $9DB5 dd 21 f1 99
    RES 0,(IX+$03)                      ; $9DB9 dd cb 03 86
    LD IX,$99A9                         ; $9DBD dd 21 a9 99
    RES 0,(IX+$03)                      ; $9DC1 dd cb 03 86
    RET                                 ; $9DC5 c9
    INC HL                              ; $9DC6 23
    CALL $9CF2                          ; $9DC7 cd f2 9c
    DEC HL                              ; $9DCA 2b
    LD A,(HL)                           ; $9DCB 7e
    AND A                               ; $9DCC a7
    JP NZ,$9CEC                         ; $9DCD c2 ec 9c
    INC A                               ; $9DD0 3c
    LD (HL),A                           ; $9DD1 77
    LD HL,$71ED                         ; $9DD2 21 ed 71
    JP $A59F                            ; $9DD5 c3 9f a5
    CALL $9CF2                          ; $9DD8 cd f2 9c
    LD (HL),$01                         ; $9DDB 36 01
    CALL $BC46                          ; $9DDD cd 46 bc
    CALL $BC9C                          ; $9DE0 cd 9c bc
    LD A,B                              ; $9DE3 78
    AND A                               ; $9DE4 a7
    JR NZ,$9DF5                         ; $9DE5 20 0e
    CALL $BC74                          ; $9DE7 cd 74 bc
    AND A                               ; $9DEA a7
    RET Z                               ; $9DEB c8
    PUSH IX                             ; $9DEC dd e5
    LD HL,$722D                         ; $9DEE 21 2d 72
    CALL $A59F                          ; $9DF1 cd 9f a5
    RET                                 ; $9DF4 c9
    BIT 4,(IX+$03)                      ; $9DF5 dd cb 03 66
    RET NZ                              ; $9DF9 c0
    LD A,$01                            ; $9DFA 3e 01
    JP $BBE5                            ; $9DFC c3 e5 bb
    LD C,$04                            ; $9DFF 0e 04
    CALL $9CCE                          ; $9E01 cd ce 9c
    JR NZ,$9D95                         ; $9E04 20 8f
    LD C,$00                            ; $9E06 0e 00
    CALL $9CCE                          ; $9E08 cd ce 9c
    JR NZ,$9D95                         ; $9E0B 20 88
    LD A,$04                            ; $9E0D 3e 04
    LD ($A034),A                        ; $9E0F 32 34 a0
    LD A,$01                            ; $9E12 3e 01
    LD ($9D90),A                        ; $9E14 32 90 9d
    LD A,$5C                            ; $9E17 3e 5c
    CALL $D224                          ; $9E19 cd 24 d2
    LD (IX+$0A),$00                     ; $9E1C dd 36 0a 00
    LD A,$3E                            ; $9E20 3e 3e
    CALL $D224                          ; $9E22 cd 24 d2
    LD (IX+$0A),$00                     ; $9E25 dd 36 0a 00
    LD HL,$9D95                         ; $9E29 21 95 9d
    LD ($9C86),HL                       ; $9E2C 22 86 9c
    LD A,$01                            ; $9E2F 3e 01
    LD ($9D92),A                        ; $9E31 32 92 9d
    LD A,($9D91)                        ; $9E34 3a 91 9d
    AND A                               ; $9E37 a7
    LD HL,$7207                         ; $9E38 21 07 72
    JR NZ,$9E44                         ; $9E3B 20 07
    INC A                               ; $9E3D 3c
    LD ($9D91),A                        ; $9E3E 32 91 9d
    LD HL,$7224                         ; $9E41 21 24 72
    CALL $A59F                          ; $9E44 cd 9f a5
    RET                                 ; $9E47 c9
    ORG $9E4A
    LD HL,$6B79                         ; $9E4A 21 79 6b
    LD A,$03                            ; $9E4D 3e 03
    CALL $9E60                          ; $9E4F cd 60 9e
    JR NZ,$9E74                         ; $9E52 20 20
    LD A,$02                            ; $9E54 3e 02
    CALL $9E60                          ; $9E56 cd 60 9e
    JR NZ,$9E74                         ; $9E59 20 19
    LD HL,$6AF3                         ; $9E5B 21 f3 6a
    JR $9E74                            ; $9E5E 18 14
    CALL $D237                          ; $9E60 cd 37 d2
    LD A,($A009)                        ; $9E63 3a 09 a0
    CP (IX+$0F)                         ; $9E66 dd be 0f
    RET                                 ; $9E69 c9
    ORG $9E6C
    LD A,($9D90)                        ; $9E6C 3a 90 9d
    AND A                               ; $9E6F a7
    RET NZ                              ; $9E70 c0
    LD HL,$693A                         ; $9E71 21 3a 69
    LD A,$01                            ; $9E74 3e 01
    LD ($5C3C),A                        ; $9E76 32 3c 5c
    CALL $A59F                          ; $9E79 cd 9f a5
    CALL $C306                          ; $9E7C cd 06 c3
    CALL $A296                          ; $9E7F cd 96 a2
    JP $B0AC                            ; $9E82 c3 ac b0
    ORG $9E87
    LD A,$00                            ; $9E87 3e 00
    AND A                               ; $9E89 a7
    RET NZ                              ; $9E8A c0
    LD HL,$6975                         ; $9E8B 21 75 69
    CALL $A59F                          ; $9E8E cd 9f a5
    LD A,($A009)                        ; $9E91 3a 09 a0
    LD HL,$A00A                         ; $9E94 21 0a a0
    CP (HL)                             ; $9E97 be
    LD HL,$69BF                         ; $9E98 21 bf 69
    JR Z,$9E74                          ; $9E9B 28 d7
    LD HL,$6A26                         ; $9E9D 21 26 6a
    JR $9E74                            ; $9EA0 18 d2
    ORG $9EA4
    LD HL,$6A33                         ; $9EA4 21 33 6a
    LD IX,$9973                         ; $9EA7 dd 21 73 99
    BIT 1,(IX+$03)                      ; $9EAB dd cb 03 4e
    JR Z,$9E74                          ; $9EAF 28 c3
    LD IX,$9981                         ; $9EB1 dd 21 81 99
    BIT 1,(IX+$03)                      ; $9EB5 dd cb 03 4e
    JR Z,$9E74                          ; $9EB9 28 b9
    LD HL,$6ABD                         ; $9EBB 21 bd 6a
    JR $9E74                            ; $9EBE 18 b4
    ORG $9EC1
    LD HL,$9EC0                         ; $9EC1 21 c0 9e
    LD C,$80                            ; $9EC4 0e 80
    LD B,$4A                            ; $9EC6 06 4a
    JR $9ED7                            ; $9EC8 18 0d
    ORG $9ECB
    LD HL,$9ECA                         ; $9ECB 21 ca 9e
    JR $9ED4                            ; $9ECE 18 04
    ORG $9ED1
    LD HL,$9ED0                         ; $9ED1 21 d0 9e
    LD BC,$0000                         ; $9ED4 01 00 00
    LD A,(HL)                           ; $9ED7 7e
    AND A                               ; $9ED8 a7
    JR Z,$9EF2                          ; $9ED9 28 17
    LD B,A                              ; $9EDB 47
    XOR A                               ; $9EDC af
    LD DE,$0000                         ; $9EDD 11 00 00
    CALL $9F1E                          ; $9EE0 cd 1e 9f
    LD A,($A036)                        ; $9EE3 3a 36 a0
    LD B,C                              ; $9EE6 41
    LD DE,$0000                         ; $9EE7 11 00 00
    CALL $F1C1                          ; $9EEA cd c1 f1
    SET 6,(IX+$05)                      ; $9EED dd cb 05 f6
    RET                                 ; $9EF1 c9
    LD A,($9FE2)                        ; $9EF2 3a e2 9f
    CP $61                              ; $9EF5 fe 61
    RET Z                               ; $9EF7 c8
    LD A,($9FE0)                        ; $9EF8 3a e0 9f
    CP $09                              ; $9EFB fe 09
    RET NZ                              ; $9EFD c0
    LD DE,$01F8                         ; $9EFE 11 f8 01
    LD A,$1E                            ; $9F01 3e 1e
    CALL $D2A4                          ; $9F03 cd a4 d2
    ADD A,E                             ; $9F06 83
    LD E,A                              ; $9F07 5f
    LD A,($A00A)                        ; $9F08 3a 0a a0
    CALL $9F1E                          ; $9F0B cd 1e 9f
    LD A,($A036)                        ; $9F0E 3a 36 a0
    LD B,$10                            ; $9F11 06 10
    LD DE,$07F0                         ; $9F13 11 f0 07
    CALL $F1C1                          ; $9F16 cd c1 f1
    RES 6,(IX+$05)                      ; $9F19 dd cb 05 b6
    RET                                 ; $9F1D c9
    LD (HL),A                           ; $9F1E 77
    LD IX,($A017)                       ; $9F1F dd 2a 17 a0
    LD (IX+$0F),B                       ; $9F23 dd 70 0f
    LD (IX+$01),$FF                     ; $9F26 dd 36 01 ff
    LD L,(IY+$06)                       ; $9F2A fd 6e 06
    LD H,(IY+$07)                       ; $9F2D fd 66 07
    ADD HL,DE                           ; $9F30 19
    LD (IY+$06),L                       ; $9F31 fd 75 06
    LD (IY+$07),H                       ; $9F34 fd 74 07
    RET                                 ; $9F37 c9
    ORG $9FC9
    LD HL,$9FCE                         ; $9FC9 21 ce 9f
    XOR A                               ; $9FCC af
    RET                                 ; $9FCD c9
    ORG $A040
    XOR A                               ; $A040 af
    LD ($D6B8),A                        ; $A041 32 b8 d6
    LD ($A01B),A                        ; $A044 32 1b a0
    DI                                  ; $A047 f3
    CALL $C14A                          ; $A048 cd 4a c1
    LD SP,$5D80                         ; $A04B 31 80 5d
    CALL $C415                          ; $A04E cd 15 c4
    CP $6E                              ; $A051 fe 6e
    JR Z,$A05B                          ; $A053 28 06
    CP $4E                              ; $A055 fe 4e
    LD A,$01                            ; $A057 3e 01
    JR NZ,$A05C                         ; $A059 20 01
    XOR A                               ; $A05B af
    LD ($A011),A                        ; $A05C 32 11 a0
    LD A,R                              ; $A05F ed 5f
    LD ($A037),A                        ; $A061 32 37 a0
    XOR A                               ; $A064 af
    LD ($A0DA),A                        ; $A065 32 da a0
    LD A,($A0DA)                        ; $A068 3a da a0
    AND A                               ; $A06B a7
    JR NZ,$A0E7                         ; $A06C 20 79
    CALL $BFD9                          ; $A06E cd d9 bf
    CALL $BF79                          ; $A071 cd 79 bf
    LD IY,$9860                         ; $A074 fd 21 60 98
    LD A,(IY+$03)                       ; $A078 fd 7e 03
    CP $32                              ; $A07B fe 32
    JR NZ,$A093                         ; $A07D 20 14
    CALL $C41F                          ; $A07F cd 1f c4
    BIT 7,A                             ; $A082 cb 7f
    JR Z,$A093                          ; $A084 28 0d
    CP $8D                              ; $A086 fe 8d
    JR NZ,$A093                         ; $A088 20 09
    LD HL,($9FDD)                       ; $A08A 2a dd 9f
    LD (IY+$06),L                       ; $A08D fd 75 06
    LD (IY+$07),H                       ; $A090 fd 74 07
    LD IY,$9860                         ; $A093 fd 21 60 98
    LD A,(IY+$00)                       ; $A097 fd 7e 00
    INC A                               ; $A09A 3c
    JR Z,$A068                          ; $A09B 28 cb
    LD HL,($9FDD)                       ; $A09D 2a dd 9f
    CALL $A0DB                          ; $A0A0 cd db a0
    JR C,$A0D1                          ; $A0A3 38 2c
    LD A,(IY+$00)                       ; $A0A5 fd 7e 00
    PUSH IY                             ; $A0A8 fd e5
    PUSH AF                             ; $A0AA f5
    CALL $CC37                          ; $A0AB cd 37 cc
    POP AF                              ; $A0AE f1
    PUSH AF                             ; $A0AF f5
    CALL $CC78                          ; $A0B0 cd 78 cc
    LD HL,($A01F)                       ; $A0B3 2a 1f a0
    LD A,L                              ; $A0B6 7d
    OR H                                ; $A0B7 b4
    JR Z,$A0AE                          ; $A0B8 28 f4
    POP AF                              ; $A0BA f1
    POP IY                              ; $A0BB fd e1
    LD E,(IY+$06)                       ; $A0BD fd 5e 06
    LD D,(IY+$07)                       ; $A0C0 fd 56 07
    ADD HL,DE                           ; $A0C3 19
    LD (IY+$06),L                       ; $A0C4 fd 75 06
    LD (IY+$07),H                       ; $A0C7 fd 74 07
    PUSH IY                             ; $A0CA fd e5
    CALL $9C77                          ; $A0CC cd 77 9c
    POP IY                              ; $A0CF fd e1
    LD DE,$0008                         ; $A0D1 11 08 00
    ADD IY,DE                           ; $A0D4 fd 19
    JR $A097                            ; $A0D6 18 bf
    ORG $A0DB
    LD E,(IY+$06)                       ; $A0DB fd 5e 06
    LD D,(IY+$07)                       ; $A0DE fd 56 07
    LD A,H                              ; $A0E1 7c
    CP D                                ; $A0E2 ba
    RET NZ                              ; $A0E3 c0
    LD A,L                              ; $A0E4 7d
    CP E                                ; $A0E5 bb
    RET                                 ; $A0E6 c9
    CP $02                              ; $A0E7 fe 02
    JR Z,$A0F1                          ; $A0E9 28 06
    CALL $B0D7                          ; $A0EB cd d7 b0
    JP $A040                            ; $A0EE c3 40 a0
    CALL $B0E4                          ; $A0F1 cd e4 b0
    JP $A064                            ; $A0F4 c3 64 a0
    PUSH HL                             ; $A0F7 e5
    LD L,(IX-$02)                       ; $A0F8 dd 6e fe
    LD H,(IX-$01)                       ; $A0FB dd 66 ff
    LD A,L                              ; $A0FE 7d
    OR H                                ; $A0FF b4
    EX (SP),HL                          ; $A100 e3
    POP IX                              ; $A101 dd e1
    RET                                 ; $A103 c9
    INC IY                              ; $A104 fd 23
    INC IY                              ; $A106 fd 23
    LD L,(IY-$02)                       ; $A108 fd 6e fe
    LD H,(IY-$01)                       ; $A10B fd 66 ff
    AND A                               ; $A10E a7
    PUSH HL                             ; $A10F e5
    SBC HL,DE                           ; $A110 ed 52
    JR Z,$A118                          ; $A112 28 04
    POP IY                              ; $A114 fd e1
    JR $A108                            ; $A116 18 f0
    POP HL                              ; $A118 e1
    RET                                 ; $A119 c9
    ORG $A11C
    PUSH IY                             ; $A11C fd e5
    PUSH HL                             ; $A11E e5
    PUSH DE                             ; $A11F d5
    PUSH BC                             ; $A120 c5
    ADD A,$03                           ; $A121 c6 03
    LD C,A                              ; $A123 4f
    LD B,$00                            ; $A124 06 00
    LD HL,($9FE3)                       ; $A126 2a e3 9f
    LD IY,$9FE3                         ; $A129 fd 21 e3 9f
    LD A,L                              ; $A12D 7d
    OR H                                ; $A12E b4
    JR Z,$A160                          ; $A12F 28 2f
    LD E,(HL)                           ; $A131 5e
    INC HL                              ; $A132 23
    LD D,(HL)                           ; $A133 56
    INC HL                              ; $A134 23
    LD A,D                              ; $A135 7a
    AND A                               ; $A136 a7
    JR NZ,$A13D                         ; $A137 20 04
    LD A,E                              ; $A139 7b
    CP C                                ; $A13A b9
    JR C,$A157                          ; $A13B 38 1a
    BIT 0,B                             ; $A13D cb 40
    JR Z,$A14E                          ; $A13F 28 0d
    PUSH HL                             ; $A141 e5
    LD L,(IX-$02)                       ; $A142 dd 6e fe
    LD H,(IX-$01)                       ; $A145 dd 66 ff
    AND A                               ; $A148 a7
    SBC HL,DE                           ; $A149 ed 52
    POP HL                              ; $A14B e1
    JR C,$A157                          ; $A14C 38 09
    PUSH HL                             ; $A14E e5
    POP IX                              ; $A14F dd e1
    LD ($A11A),IY                       ; $A151 fd 22 1a a1
    SET 0,B                             ; $A155 cb c0
    PUSH HL                             ; $A157 e5
    POP IY                              ; $A158 fd e1
    LD E,(HL)                           ; $A15A 5e
    INC HL                              ; $A15B 23
    LD D,(HL)                           ; $A15C 56
    EX DE,HL                            ; $A15D eb
    JR $A12D                            ; $A15E 18 cd
    BIT 0,B                             ; $A160 cb 40
    JR Z,$A1AC                          ; $A162 28 48
    LD L,(IX-$02)                       ; $A164 dd 6e fe
    LD H,(IX-$01)                       ; $A167 dd 66 ff
    LD B,$00                            ; $A16A 06 00
    AND A                               ; $A16C a7
    SBC HL,BC                           ; $A16D ed 42
    LD A,H                              ; $A16F 7c
    AND A                               ; $A170 a7
    JR NZ,$A18A                         ; $A171 20 17
    LD A,L                              ; $A173 7d
    CP $04                              ; $A174 fe 04
    JR NC,$A18A                         ; $A176 30 12
    LD IY,($A11A)                       ; $A178 fd 2a 1a a1
    LD A,(IX+$00)                       ; $A17C dd 7e 00
    LD (IY+$00),A                       ; $A17F fd 77 00
    LD A,(IX+$01)                       ; $A182 dd 7e 01
    LD (IY+$01),A                       ; $A185 fd 77 01
    JR $A193                            ; $A188 18 09
    LD (IX-$02),L                       ; $A18A dd 75 fe
    LD (IX-$01),H                       ; $A18D dd 74 ff
    EX DE,HL                            ; $A190 eb
    ADD IX,DE                           ; $A191 dd 19
    INC IX                              ; $A193 dd 23
    LD (IX-$03),C                       ; $A195 dd 71 fd
    PUSH IX                             ; $A198 dd e5
    POP HL                              ; $A19A e1
    DEC HL                              ; $A19B 2b
    DEC HL                              ; $A19C 2b
    LD B,C                              ; $A19D 41
    DEC B                               ; $A19E 05
    XOR A                               ; $A19F af
    LD (HL),A                           ; $A1A0 77
    INC HL                              ; $A1A1 23
    DJNZ $A1A0                          ; $A1A2 10 fc
    OR $01                              ; $A1A4 f6 01
    POP BC                              ; $A1A6 c1
    POP DE                              ; $A1A7 d1
    POP HL                              ; $A1A8 e1
    POP IY                              ; $A1A9 fd e1
    RET                                 ; $A1AB c9
    JP $C1D8                            ; $A1AC c3 d8 c1
    PUSH HL                             ; $A1AF e5
    PUSH IX                             ; $A1B0 dd e5
    POP HL                              ; $A1B2 e1
    JR $A1C1                            ; $A1B3 18 0c
    LD L,(IX-$02)                       ; $A1B5 dd 6e fe
    LD H,(IX-$01)                       ; $A1B8 dd 66 ff
    CALL $A1C7                          ; $A1BB cd c7 a1
    PUSH HL                             ; $A1BE e5
    POP IX                              ; $A1BF dd e1
    LD A,L                              ; $A1C1 7d
    OR H                                ; $A1C2 b4
    JR NZ,$A1B5                         ; $A1C3 20 f0
    POP HL                              ; $A1C5 e1
    RET                                 ; $A1C6 c9
    PUSH HL                             ; $A1C7 e5
    PUSH DE                             ; $A1C8 d5
    PUSH IX                             ; $A1C9 dd e5
    POP HL                              ; $A1CB e1
    DEC HL                              ; $A1CC 2b
    DEC HL                              ; $A1CD 2b
    DEC HL                              ; $A1CE 2b
    LD IX,$9FE3                         ; $A1CF dd 21 e3 9f
    LD E,(IX+$00)                       ; $A1D3 dd 5e 00
    LD D,(IX+$01)                       ; $A1D6 dd 56 01
    LD A,D                              ; $A1D9 7a
    OR E                                ; $A1DA b3
    JR Z,$A1EB                          ; $A1DB 28 0e
    PUSH HL                             ; $A1DD e5
    AND A                               ; $A1DE a7
    SBC HL,DE                           ; $A1DF ed 52
    POP HL                              ; $A1E1 e1
    JR C,$A1EB                          ; $A1E2 38 07
    INC DE                              ; $A1E4 13
    INC DE                              ; $A1E5 13
    PUSH DE                             ; $A1E6 d5
    POP IX                              ; $A1E7 dd e1
    JR $A1D3                            ; $A1E9 18 e8
    LD (IX+$00),L                       ; $A1EB dd 75 00
    LD (IX+$01),H                       ; $A1EE dd 74 01
    INC HL                              ; $A1F1 23
    LD (HL),$00                         ; $A1F2 36 00
    INC HL                              ; $A1F4 23
    LD (HL),E                           ; $A1F5 73
    INC HL                              ; $A1F6 23
    LD (HL),D                           ; $A1F7 72
    CALL $A20C                          ; $A1F8 cd 0c a2
    JR Z,$A206                          ; $A1FB 28 09
    LD L,(IX+$00)                       ; $A1FD dd 6e 00
    LD H,(IX+$01)                       ; $A200 dd 66 01
    PUSH HL                             ; $A203 e5
    POP IX                              ; $A204 dd e1
    CALL $A20C                          ; $A206 cd 0c a2
    POP DE                              ; $A209 d1
    POP HL                              ; $A20A e1
    RET                                 ; $A20B c9
    PUSH IX                             ; $A20C dd e5
    POP HL                              ; $A20E e1
    DEC HL                              ; $A20F 2b
    DEC HL                              ; $A210 2b
    LD E,(IX-$02)                       ; $A211 dd 5e fe
    LD D,(IX-$01)                       ; $A214 dd 56 ff
    ADD HL,DE                           ; $A217 19
    LD E,(IX+$00)                       ; $A218 dd 5e 00
    LD D,(IX+$01)                       ; $A21B dd 56 01
    LD A,D                              ; $A21E 7a
    OR E                                ; $A21F b3
    JR NZ,$A225                         ; $A220 20 03
    OR $01                              ; $A222 f6 01
    RET                                 ; $A224 c9
    AND A                               ; $A225 a7
    SBC HL,DE                           ; $A226 ed 52
    RET NZ                              ; $A228 c0
    LD L,(IX+$00)                       ; $A229 dd 6e 00
    LD H,(IX+$01)                       ; $A22C dd 66 01
    PUSH BC                             ; $A22F c5
    LD E,(HL)                           ; $A230 5e
    INC HL                              ; $A231 23
    LD D,(HL)                           ; $A232 56
    INC HL                              ; $A233 23
    LD C,(HL)                           ; $A234 4e
    INC HL                              ; $A235 23
    LD B,(HL)                           ; $A236 46
    LD L,(IX-$02)                       ; $A237 dd 6e fe
    LD H,(IX-$01)                       ; $A23A dd 66 ff
    ADD HL,DE                           ; $A23D 19
    LD (IX-$02),L                       ; $A23E dd 75 fe
    LD (IX-$01),H                       ; $A241 dd 74 ff
    LD (IX+$00),C                       ; $A244 dd 71 00
    LD (IX+$01),B                       ; $A247 dd 70 01
    POP BC                              ; $A24A c1
    XOR A                               ; $A24B af
    RET                                 ; $A24C c9
    ORG $A25D
    PUSH BC                             ; $A25D c5
    LD B,A                              ; $A25E 47
    LD A,($A011)                        ; $A25F 3a 11 a0
    AND A                               ; $A262 a7
    JR Z,$A275                          ; $A263 28 10
    LD HL,($A0D8)                       ; $A265 2a d8 a0
    LD A,H                              ; $A268 7c
    OR L                                ; $A269 b5
    JR Z,$A275                          ; $A26A 28 09
    PUSH HL                             ; $A26C e5
    POP IX                              ; $A26D dd e1
    LD A,B                              ; $A26F 78
    CALL $D34E                          ; $A270 cd 4e d3
    CP $FF                              ; $A273 fe ff
    POP BC                              ; $A275 c1
    RET                                 ; $A276 c9
    PUSH IX                             ; $A277 dd e5
    PUSH HL                             ; $A279 e5
    PUSH BC                             ; $A27A c5
    PUSH AF                             ; $A27B f5
    CALL $A25D                          ; $A27C cd 5d a2
    JR Z,$A290                          ; $A27F 28 0f
    CALL $A296                          ; $A281 cd 96 a2
    CALL $C129                          ; $A284 cd 29 c1
    LD L,(IX+$01)                       ; $A287 dd 6e 01
    LD H,(IX+$02)                       ; $A28A dd 66 02
    CALL $F3C2                          ; $A28D cd c2 f3
    POP AF                              ; $A290 f1
    POP BC                              ; $A291 c1
    POP HL                              ; $A292 e1
    POP IX                              ; $A293 dd e1
    RET                                 ; $A295 c9
    LD B,$12                            ; $A296 06 12
    CALL $A2A2                          ; $A298 cd a2 a2
    XOR A                               ; $A29B af
    LD ($A019),A                        ; $A29C 32 19 a0
    DJNZ $A298                          ; $A29F 10 f7
    RET                                 ; $A2A1 c9
    PUSH AF                             ; $A2A2 f5
    LD A,$0D                            ; $A2A3 3e 0d
    CALL $A9B7                          ; $A2A5 cd b7 a9
    POP AF                              ; $A2A8 f1
    RET                                 ; $A2A9 c9
    ORG $A2AB
    XOR A                               ; $A2AB af
    LD (HL),A                           ; $A2AC 77
    INC HL                              ; $A2AD 23
    DJNZ $A2AC                          ; $A2AE 10 fc
    RET                                 ; $A2B0 c9
    DEC A                               ; $A2B1 3d
    LD L,A                              ; $A2B2 6f
    LD H,$00                            ; $A2B3 26 00
    ADD HL,HL                           ; $A2B5 29
    ADD HL,HL                           ; $A2B6 29
    ADD HL,HL                           ; $A2B7 29
    LD DE,$8259                         ; $A2B8 11 59 82
    ADD HL,DE                           ; $A2BB 19
    RET                                 ; $A2BC c9
    LD A,(IX+$05)                       ; $A2BD dd 7e 05
    RRCA                                ; $A2C0 0f
    RRCA                                ; $A2C1 0f
    RRCA                                ; $A2C2 0f
    RRCA                                ; $A2C3 0f
    AND $0F                             ; $A2C4 e6 0f
    LD C,A                              ; $A2C6 4f
    LD A,(IX+$07)                       ; $A2C7 dd 7e 07
    AND $F0                             ; $A2CA e6 f0
    ADD A,C                             ; $A2CC 81
    LD ($A01E),A                        ; $A2CD 32 1e a0
    LD A,(IX+$01)                       ; $A2D0 dd 7e 01
    RRCA                                ; $A2D3 0f
    RRCA                                ; $A2D4 0f
    RRCA                                ; $A2D5 0f
    RRCA                                ; $A2D6 0f
    AND $0F                             ; $A2D7 e6 0f
    LD C,A                              ; $A2D9 4f
    LD A,(IX+$03)                       ; $A2DA dd 7e 03
    AND $F0                             ; $A2DD e6 f0
    ADD A,C                             ; $A2DF 81
    LD ($A01D),A                        ; $A2E0 32 1d a0
    RET                                 ; $A2E3 c9
    LD A,$01                            ; $A2E4 3e 01
    LD ($A2AA),A                        ; $A2E6 32 aa a2
    PUSH IY                             ; $A2E9 fd e5
    PUSH BC                             ; $A2EB c5
    PUSH IX                             ; $A2EC dd e5
    PUSH HL                             ; $A2EE e5
    PUSH DE                             ; $A2EF d5
    LD A,($A033)                        ; $A2F0 3a 33 a0
    LD ($A35D),A                        ; $A2F3 32 5d a3
    LD HL,($A034)                       ; $A2F6 2a 34 a0
    LD ($A35E),HL                       ; $A2F9 22 5e a3
    LD A,($A00C)                        ; $A2FC 3a 0c a0
    LD B,A                              ; $A2FF 47
    AND A                               ; $A300 a7
    LD A,$01                            ; $A301 3e 01
    JR Z,$A306                          ; $A303 28 01
    XOR A                               ; $A305 af
    LD ($A027),A                        ; $A306 32 27 a0
    CALL $D078                          ; $A309 cd 78 d0
    JR NC,$A31A                         ; $A30C 30 0c
    LD A,B                              ; $A30E 78
    AND A                               ; $A30F a7
    JR NZ,$A31A                         ; $A310 20 08
    LD HL,$68D1                         ; $A312 21 d1 68
    CALL $A59F                          ; $A315 cd 9f a5
    JR $A34E                            ; $A318 18 34
    LD A,($A35D)                        ; $A31A 3a 5d a3
    CALL $A2B1                          ; $A31D cd b1 a2
    PUSH HL                             ; $A320 e5
    POP IX                              ; $A321 dd e1
    CALL $A2BD                          ; $A323 cd bd a2
    LD A,($A01D)                        ; $A326 3a 1d a0
    AND $10                             ; $A329 e6 10
    JR NZ,$A34E                         ; $A32B 20 21
    CP B                                ; $A32D b8
    JR Z,$A336                          ; $A32E 28 06
    CALL $DC6C                          ; $A330 cd 6c dc
    CALL Z,$A2A2                        ; $A333 cc a2 a2
    CALL $A724                          ; $A336 cd 24 a7
    LD DE,$017F                         ; $A339 11 7f 01
    XOR A                               ; $A33C af
    CP B                                ; $A33D b8
    JR NZ,$A348                         ; $A33E 20 08
    CALL $A887                          ; $A340 cd 87 a8
    CALL $A360                          ; $A343 cd 60 a3
    JR $A34B                            ; $A346 18 03
    CALL $A37D                          ; $A348 cd 7d a3
    CALL $A2A2                          ; $A34B cd a2 a2
    XOR A                               ; $A34E af
    LD ($A2AA),A                        ; $A34F 32 aa a2
    LD ($A027),A                        ; $A352 32 27 a0
    POP DE                              ; $A355 d1
    POP HL                              ; $A356 e1
    POP IX                              ; $A357 dd e1
    POP BC                              ; $A359 c1
    POP IY                              ; $A35A fd e1
    RET                                 ; $A35C c9
    ORG $A360
    LD A,($A036)                        ; $A360 3a 36 a0
    PUSH AF                             ; $A363 f5
    LD HL,$A35E                         ; $A364 21 5e a3
    CP (HL)                             ; $A367 be
    LD A,$00                            ; $A368 3e 00
    JR NZ,$A36D                         ; $A36A 20 01
    LD (HL),A                           ; $A36C 77
    LD ($A036),A                        ; $A36D 32 36 a0
    PUSH IX                             ; $A370 dd e5
    CALL $A37D                          ; $A372 cd 7d a3
    POP IX                              ; $A375 dd e1
    POP AF                              ; $A377 f1
    LD ($A036),A                        ; $A378 32 36 a0
    XOR A                               ; $A37B af
    RET                                 ; $A37C c9
    XOR A                               ; $A37D af
    LD ($A028),A                        ; $A37E 32 28 a0
    LD A,($A35D)                        ; $A381 3a 5d a3
    CALL $A2B1                          ; $A384 cd b1 a2
    PUSH HL                             ; $A387 e5
    POP IX                              ; $A388 dd e1
    PUSH HL                             ; $A38A e5
    CALL $A2BD                          ; $A38B cd bd a2
    CALL $C493                          ; $A38E cd 93 c4
    CALL $C4B2                          ; $A391 cd b2 c4
    POP HL                              ; $A394 e1
    LD A,($A01D)                        ; $A395 3a 1d a0
    LD C,A                              ; $A398 4f
    PUSH HL                             ; $A399 e5
    LD DE,$0006                         ; $A39A 11 06 00
    ADD HL,DE                           ; $A39D 19
    CALL $A880                          ; $A39E cd 80 a8
    POP HL                              ; $A3A1 e1
    CALL $A880                          ; $A3A2 cd 80 a8
    BIT 3,C                             ; $A3A5 cb 59
    JR Z,$A3E2                          ; $A3A7 28 39
    BIT 5,C                             ; $A3A9 cb 69
    CALL NZ,$A880                       ; $A3AB c4 80 a8
    LD A,($A01E)                        ; $A3AE 3a 1e a0
    BIT 7,A                             ; $A3B1 cb 7f
    CALL NZ,$A880                       ; $A3B3 c4 80 a8
    LD A,($A35E)                        ; $A3B6 3a 5e a3
    CP $FE                              ; $A3B9 fe fe
    JR NZ,$A3C7                         ; $A3BB 20 0a
    PUSH HL                             ; $A3BD e5
    LD HL,($A02F)                       ; $A3BE 2a 2f a0
    CALL $A419                          ; $A3C1 cd 19 a4
    POP HL                              ; $A3C4 e1
    JR $A3E2                            ; $A3C5 18 1b
    PUSH HL                             ; $A3C7 e5
    LD HL,$A036                         ; $A3C8 21 36 a0
    CP (HL)                             ; $A3CB be
    JR NZ,$A3D6                         ; $A3CC 20 08
    LD DE,$055B                         ; $A3CE 11 5b 05
    CALL $A887                          ; $A3D1 cd 87 a8
    JR $A3E1                            ; $A3D4 18 0b
    LD A,($A00F)                        ; $A3D6 3a 0f a0
    CP $05                              ; $A3D9 fe 05
    LD A,($A35E)                        ; $A3DB 3a 5e a3
    CALL $A745                          ; $A3DE cd 45 a7
    POP HL                              ; $A3E1 e1
    LD A,($A35F)                        ; $A3E2 3a 5f a3
    CP $FF                              ; $A3E5 fe ff
    JR Z,$A414                          ; $A3E7 28 2b
    BIT 2,C                             ; $A3E9 cb 51
    JR Z,$A414                          ; $A3EB 28 27
    BIT 5,C                             ; $A3ED cb 69
    CALL Z,$A880                        ; $A3EF cc 80 a8
    LD A,($A01E)                        ; $A3F2 3a 1e a0
    BIT 7,A                             ; $A3F5 cb 7f
    CALL Z,$A880                        ; $A3F7 cc 80 a8
    LD A,($A35F)                        ; $A3FA 3a 5f a3
    CP $FE                              ; $A3FD fe fe
    JR NZ,$A409                         ; $A3FF 20 08
    LD HL,($A031)                       ; $A401 2a 31 a0
    CALL $A419                          ; $A404 cd 19 a4
    JR $A414                            ; $A407 18 0b
    LD A,($A010)                        ; $A409 3a 10 a0
    CP $05                              ; $A40C fe 05
    LD A,($A35F)                        ; $A40E 3a 5f a3
    CALL $A745                          ; $A411 cd 45 a7
    LD A,$2E                            ; $A414 3e 2e
    JP $A9B7                            ; $A416 c3 b7 a9
    PUSH BC                             ; $A419 c5
    RES 7,H                             ; $A41A cb bc
    SLA L                               ; $A41C cb 25
    SRL H                               ; $A41E cb 3c
    RR L                                ; $A420 cb 1d
    LD A,$20                            ; $A422 3e 20
    CALL $A9B7                          ; $A424 cd b7 a9
    LD DE,$00F0                         ; $A427 11 f0 00
    CALL $A476                          ; $A42A cd 76 a4
    AND A                               ; $A42D a7
    JR Z,$A442                          ; $A42E 28 12
    LD B,A                              ; $A430 47
    LD A,$60                            ; $A431 3e 60
    CALL $A9B7                          ; $A433 cd b7 a9
    CALL $A490                          ; $A436 cd 90 a4
    LD A,L                              ; $A439 7d
    OR H                                ; $A43A b4
    JR Z,$A467                          ; $A43B 28 2a
    LD A,$20                            ; $A43D 3e 20
    CALL $A9B7                          ; $A43F cd b7 a9
    LD DE,$000C                         ; $A442 11 0c 00
    CALL $A476                          ; $A445 cd 76 a4
    AND A                               ; $A448 a7
    JR Z,$A469                          ; $A449 28 1e
    LD B,A                              ; $A44B 47
    CALL $A490                          ; $A44C cd 90 a4
    LD A,$2F                            ; $A44F 3e 2f
    CALL $A9B7                          ; $A451 cd b7 a9
    LD A,L                              ; $A454 7d
    AND A                               ; $A455 a7
    LD B,A                              ; $A456 47
    JR Z,$A45E                          ; $A457 28 05
    CALL $A490                          ; $A459 cd 90 a4
    JR $A467                            ; $A45C 18 09
    LD A,$2D                            ; $A45E 3e 2d
    CALL $A9B7                          ; $A460 cd b7 a9
    XOR A                               ; $A463 af
    LD ($A026),A                        ; $A464 32 26 a0
    POP BC                              ; $A467 c1
    RET                                 ; $A468 c9
    LD B,L                              ; $A469 45
    CALL $A490                          ; $A46A cd 90 a4
    LD A,$44                            ; $A46D 3e 44
    CALL $A9B7                          ; $A46F cd b7 a9
    LD A,$2E                            ; $A472 3e 2e
    JR $A460                            ; $A474 18 ea
    LD A,$FF                            ; $A476 3e ff
    INC A                               ; $A478 3c
    AND A                               ; $A479 a7
    SBC HL,DE                           ; $A47A ed 52
    JR NC,$A478                         ; $A47C 30 fa
    ADD HL,DE                           ; $A47E 19
    RET                                 ; $A47F c9
    CALL $A476                          ; $A480 cd 76 a4
    ADD A,$30                           ; $A483 c6 30
    DEC C                               ; $A485 0d
    INC C                               ; $A486 0c
    JR NZ,$A48D                         ; $A487 20 04
    CP $30                              ; $A489 fe 30
    RET Z                               ; $A48B c8
    INC C                               ; $A48C 0c
    JP $A9B7                            ; $A48D c3 b7 a9
    PUSH HL                             ; $A490 e5
    PUSH DE                             ; $A491 d5
    LD L,B                              ; $A492 68
    LD H,$00                            ; $A493 26 00
    LD C,H                              ; $A495 4c
    LD DE,$0064                         ; $A496 11 64 00
    CALL $A480                          ; $A499 cd 80 a4
    LD DE,$000A                         ; $A49C 11 0a 00
    CALL $A480                          ; $A49F cd 80 a4
    LD A,L                              ; $A4A2 7d
    ADD A,$30                           ; $A4A3 c6 30
    CALL $A9B7                          ; $A4A5 cd b7 a9
    POP DE                              ; $A4A8 d1
    POP HL                              ; $A4A9 e1
    RET                                 ; $A4AA c9
    PUSH DE                             ; $A4AB d5
    PUSH IX                             ; $A4AC dd e5
    CALL $D224                          ; $A4AE cd 24 d2
    PUSH IX                             ; $A4B1 dd e5
    POP HL                              ; $A4B3 e1
    LD DE,$0001                         ; $A4B4 11 01 00
    ADD HL,DE                           ; $A4B7 19
    POP IX                              ; $A4B8 dd e1
    POP DE                              ; $A4BA d1
    RET                                 ; $A4BB c9
    PUSH DE                             ; $A4BC d5
    PUSH IX                             ; $A4BD dd e5
    CALL $D237                          ; $A4BF cd 37 d2
    PUSH IX                             ; $A4C2 dd e5
    POP HL                              ; $A4C4 e1
    LD DE,$0007                         ; $A4C5 11 07 00
    ADD HL,DE                           ; $A4C8 19
    POP IX                              ; $A4C9 dd e1
    POP DE                              ; $A4CB d1
    RET                                 ; $A4CC c9
    PUSH DE                             ; $A4CD d5
    PUSH HL                             ; $A4CE e5
    PUSH IY                             ; $A4CF fd e5
    LD DE,$0006                         ; $A4D1 11 06 00
    ADD HL,DE                           ; $A4D4 19
    ADD IY,DE                           ; $A4D5 fd 19
    CALL $A51B                          ; $A4D7 cd 1b a5
    JR NZ,$A516                         ; $A4DA 20 3a
    POP IY                              ; $A4DC fd e1
    POP HL                              ; $A4DE e1
    POP DE                              ; $A4DF d1
    PUSH DE                             ; $A4E0 d5
    PUSH HL                             ; $A4E1 e5
    PUSH IY                             ; $A4E2 fd e5
    CALL $A51B                          ; $A4E4 cd 1b a5
    JR NZ,$A516                         ; $A4E7 20 2d
    LD A,$01                            ; $A4E9 3e 01
    LD ($A02E),A                        ; $A4EB 32 2e a0
    CALL $A51B                          ; $A4EE cd 1b a5
    JR NZ,$A4FA                         ; $A4F1 20 07
    CALL $A51B                          ; $A4F3 cd 1b a5
    LD A,$00                            ; $A4F6 3e 00
    JR Z,$A516                          ; $A4F8 28 1c
    POP IY                              ; $A4FA fd e1
    POP HL                              ; $A4FC e1
    PUSH HL                             ; $A4FD e5
    PUSH IY                             ; $A4FE fd e5
    LD DE,$0004                         ; $A500 11 04 00
    ADD IY,DE                           ; $A503 fd 19
    INC HL                              ; $A505 23
    INC HL                              ; $A506 23
    CALL $A51B                          ; $A507 cd 1b a5
    JR NZ,$A516                         ; $A50A 20 0a
    LD DE,$FFFC                         ; $A50C 11 fc ff
    ADD IY,DE                           ; $A50F fd 19
    CALL $A51B                          ; $A511 cd 1b a5
    LD A,$01                            ; $A514 3e 01
    POP IY                              ; $A516 fd e1
    POP HL                              ; $A518 e1
    POP DE                              ; $A519 d1
    RET                                 ; $A51A c9
    PUSH HL                             ; $A51B e5
    LD A,(HL)                           ; $A51C 7e
    INC HL                              ; $A51D 23
    OR (HL)                             ; $A51E b6
    JR Z,$A52E                          ; $A51F 28 0d
    LD A,(IY+$01)                       ; $A521 fd 7e 01
    XOR (HL)                            ; $A524 ae
    AND $0F                             ; $A525 e6 0f
    JR NZ,$A52E                         ; $A527 20 05
    DEC HL                              ; $A529 2b
    LD A,(HL)                           ; $A52A 7e
    CP (IY+$00)                         ; $A52B fd be 00
    POP HL                              ; $A52E e1
    INC HL                              ; $A52F 23
    INC HL                              ; $A530 23
    INC IY                              ; $A531 fd 23
    INC IY                              ; $A533 fd 23
    RET                                 ; $A535 c9
    ORG $A59F
    PUSH BC                             ; $A59F c5
    PUSH DE                             ; $A5A0 d5
    PUSH IX                             ; $A5A1 dd e5
    PUSH AF                             ; $A5A3 f5
    PUSH HL                             ; $A5A4 e5
    LD HL,$000C                         ; $A5A5 21 0c 00
    ADD HL,SP                           ; $A5A8 39
    LD ($A59D),HL                       ; $A5A9 22 9d a5
    POP HL                              ; $A5AC e1
    LD A,($A00B)                        ; $A5AD 3a 0b a0
    AND A                               ; $A5B0 a7
    JR NZ,$A5B6                         ; $A5B1 20 03
    LD ($A00C),A                        ; $A5B3 32 0c a0
    CALL $A5C4                          ; $A5B6 cd c4 a5
    POP AF                              ; $A5B9 f1
    POP IX                              ; $A5BA dd e1
    POP DE                              ; $A5BC d1
    POP BC                              ; $A5BD c1
    POP HL                              ; $A5BE e1
    LD SP,($A59D)                       ; $A5BF ed 7b 9d a5
    JP (HL)                             ; $A5C3 e9
    PUSH HL                             ; $A5C4 e5
    POP IX                              ; $A5C5 dd e1
    CALL $A5CD                          ; $A5C7 cd cd a5
    JR NZ,$A5C7                         ; $A5CA 20 fb
    RET                                 ; $A5CC c9
    LD A,(IX+$00)                       ; $A5CD dd 7e 00
    BIT 7,A                             ; $A5D0 cb 7f
    JR Z,$A5F2                          ; $A5D2 28 1e
    AND $7F                             ; $A5D4 e6 7f
    LD D,A                              ; $A5D6 57
    LD E,(IX+$01)                       ; $A5D7 dd 5e 01
    INC IX                              ; $A5DA dd 23
    AND $F0                             ; $A5DC e6 f0
    CP $30                              ; $A5DE fe 30
    JR Z,$A647                          ; $A5E0 28 65
    CP $20                              ; $A5E2 fe 20
    JR Z,$A647                          ; $A5E4 28 61
    CP $60                              ; $A5E6 fe 60
    JR Z,$A647                          ; $A5E8 28 5d
    CALL $A887                          ; $A5EA cd 87 a8
    INC IX                              ; $A5ED dd 23
    OR $01                              ; $A5EF f6 01
    RET                                 ; $A5F1 c9
    CP $20                              ; $A5F2 fe 20
    JR C,$A621                          ; $A5F4 38 2b
    CP $60                              ; $A5F6 fe 60
    JP NC,$A83A                         ; $A5F8 d2 3a a8
    CP $40                              ; $A5FB fe 40
    JR C,$A61C                          ; $A5FD 38 1d
    AND $1F                             ; $A5FF e6 1f
    INC A                               ; $A601 3c
    LD B,A                              ; $A602 47
    PUSH IX                             ; $A603 dd e5
    POP HL                              ; $A605 e1
    INC HL                              ; $A606 23
    LD C,$00                            ; $A607 0e 00
    CALL $A990                          ; $A609 cd 90 a9
    CALL $A9B7                          ; $A60C cd b7 a9
    DJNZ $A609                          ; $A60F 10 f8
    PUSH HL                             ; $A611 e5
    POP IX                              ; $A612 dd e1
    LD A,C                              ; $A614 79
    AND A                               ; $A615 a7
    JR NZ,$A5ED                         ; $A616 20 d5
    DEC IX                              ; $A618 dd 2b
    JR $A5ED                            ; $A61A 18 d1
    CALL $A9B7                          ; $A61C cd b7 a9
    JR $A5ED                            ; $A61F 18 cc
    PUSH DE                             ; $A621 d5
    LD E,A                              ; $A622 5f
    LD D,$00                            ; $A623 16 00
    LD HL,$A55D                         ; $A625 21 5d a5
    ADD HL,DE                           ; $A628 19
    ADD HL,DE                           ; $A629 19
    LD E,(HL)                           ; $A62A 5e
    INC HL                              ; $A62B 23
    LD D,(HL)                           ; $A62C 56
    EX DE,HL                            ; $A62D eb
    POP DE                              ; $A62E d1
    CP $1D                              ; $A62F fe 1d
    JR NC,$A5C3                         ; $A631 30 90
    CALL $A5C3                          ; $A633 cd c3 a5
    JR Z,$A5ED                          ; $A636 28 b5
    JR $A5EA                            ; $A638 18 b0
    CALL $A9B7                          ; $A63A cd b7 a9
    XOR A                               ; $A63D af
    RET                                 ; $A63E c9
    LD D,$60                            ; $A63F 16 60
    JR $A64A                            ; $A641 18 07
    LD D,$30                            ; $A643 16 30
    JR $A64A                            ; $A645 18 03
    CALL $A887                          ; $A647 cd 87 a8
    LD A,$2E                            ; $A64A 3e 2e
    BIT 6,D                             ; $A64C cb 72
    JR NZ,$A657                         ; $A64E 20 07
    BIT 4,D                             ; $A650 cb 62
    CALL NZ,$A9B7                       ; $A652 c4 b7 a9
    BIT 4,D                             ; $A655 cb 62
    CALL NZ,$A2A2                       ; $A657 c4 a2 a2
    XOR A                               ; $A65A af
    RET                                 ; $A65B c9
    RET                                 ; $A65C c9
    XOR A                               ; $A65D af
    LD ($A028),A                        ; $A65E 32 28 a0
    CALL $A66C                          ; $A661 cd 6c a6
    EX DE,HL                            ; $A664 eb
    LD A,H                              ; $A665 7c
    OR L                                ; $A666 b5
    CALL NZ,$A7BA                       ; $A667 c4 ba a7
    XOR A                               ; $A66A af
    RET                                 ; $A66B c9
    LD HL,($A59D)                       ; $A66C 2a 9d a5
    LD E,(HL)                           ; $A66F 5e
    INC HL                              ; $A670 23
    LD D,(HL)                           ; $A671 56
    INC HL                              ; $A672 23
    LD ($A59D),HL                       ; $A673 22 9d a5
    OR $01                              ; $A676 f6 01
    RET                                 ; $A678 c9
    LD E,(IX+$01)                       ; $A679 dd 5e 01
    LD D,(IX+$02)                       ; $A67C dd 56 02
    DEC DE                              ; $A67F 1b
    ADD IX,DE                           ; $A680 dd 19
    XOR A                               ; $A682 af
    RET                                 ; $A683 c9
    CALL $A66C                          ; $A684 cd 6c a6
    PUSH DE                             ; $A687 d5
    POP IX                              ; $A688 dd e1
    XOR A                               ; $A68A af
    RET                                 ; $A68B c9
    CALL $C00C                          ; $A68C cd 0c c0
    CP $05                              ; $A68F fe 05
    RET Z                               ; $A691 c8
    JR $A6B2                            ; $A692 18 1e
    CALL $C00C                          ; $A694 cd 0c c0
    CP $04                              ; $A697 fe 04
    RET Z                               ; $A699 c8
    JR $A6B2                            ; $A69A 18 16
    CALL $C00C                          ; $A69C cd 0c c0
    CP $03                              ; $A69F fe 03
    RET Z                               ; $A6A1 c8
    JR $A6B2                            ; $A6A2 18 0e
    CALL $C00C                          ; $A6A4 cd 0c c0
    CP $02                              ; $A6A7 fe 02
    RET Z                               ; $A6A9 c8
    JR $A6B2                            ; $A6AA 18 06
    CALL $C00C                          ; $A6AC cd 0c c0
    CP $01                              ; $A6AF fe 01
    RET Z                               ; $A6B1 c8
    INC IX                              ; $A6B2 dd 23
    CALL $A6BB                          ; $A6B4 cd bb a6
    DEC IX                              ; $A6B7 dd 2b
    XOR A                               ; $A6B9 af
    RET                                 ; $A6BA c9
    LD A,(IX+$00)                       ; $A6BB dd 7e 00
    BIT 7,A                             ; $A6BE cb 7f
    JR NZ,$A6CC                         ; $A6C0 20 0a
    CP $02                              ; $A6C2 fe 02
    JR Z,$A6CA                          ; $A6C4 28 04
    CP $0B                              ; $A6C6 fe 0b
    JR NZ,$A6CE                         ; $A6C8 20 04
    INC IX                              ; $A6CA dd 23
    INC IX                              ; $A6CC dd 23
    INC IX                              ; $A6CE dd 23
    RET                                 ; $A6D0 c9
    ORG $A6D3
    INC IX                              ; $A6D3 dd 23
    LD A,(IX+$00)                       ; $A6D5 dd 7e 00
    LD ($A6D1),A                        ; $A6D8 32 d1 a6
    DEC A                               ; $A6DB 3d
    CALL $D2A4                          ; $A6DC cd a4 d2
    INC A                               ; $A6DF 3c
    LD ($A6D2),A                        ; $A6E0 32 d2 a6
    INC IX                              ; $A6E3 dd 23
    LD A,($A6D2)                        ; $A6E5 3a d2 a6
    LD HL,$A6D1                         ; $A6E8 21 d1 a6
    CP (HL)                             ; $A6EB be
    JR NZ,$A6F5                         ; $A6EC 20 07
    PUSH IX                             ; $A6EE dd e5
    CALL $A5CD                          ; $A6F0 cd cd a5
    POP IX                              ; $A6F3 dd e1
    CALL $A6BB                          ; $A6F5 cd bb a6
    LD HL,$A6D1                         ; $A6F8 21 d1 a6
    DEC (HL)                            ; $A6FB 35
    JR NZ,$A6E5                         ; $A6FC 20 e7
    DEC IX                              ; $A6FE dd 2b
    XOR A                               ; $A700 af
    RET                                 ; $A701 c9
    LD DE,($A00D)                       ; $A702 ed 5b 0d a0
    OR $01                              ; $A706 f6 01
    RET                                 ; $A708 c9
    CALL $A66C                          ; $A709 cd 6c a6
    CALL $A80E                          ; $A70C cd 0e a8
    XOR A                               ; $A70F af
    RET                                 ; $A710 c9
    PUSH IX                             ; $A711 dd e5
    CALL $A66C                          ; $A713 cd 6c a6
    PUSH DE                             ; $A716 d5
    POP IX                              ; $A717 dd e1
    CALL $BF1C                          ; $A719 cd 1c bf
    POP IX                              ; $A71C dd e1
    XOR A                               ; $A71E af
    RET                                 ; $A71F c9
    XOR A                               ; $A720 af
    LD ($A028),A                        ; $A721 32 28 a0
    LD A,($A036)                        ; $A724 3a 36 a0
    CALL $A82F                          ; $A727 cd 2f a8
    XOR A                               ; $A72A af
    RET                                 ; $A72B c9
    LD A,$01                            ; $A72C 3e 01
    LD ($A028),A                        ; $A72E 32 28 a0
    LD A,($A034)                        ; $A731 3a 34 a0
    JR $A751                            ; $A734 18 1b
    CALL $A9B7                          ; $A736 cd b7 a9
    XOR A                               ; $A739 af
    RET                                 ; $A73A c9
    LD A,$01                            ; $A73B 3e 01
    LD ($A028),A                        ; $A73D 32 28 a0
    LD A,($A035)                        ; $A740 3a 35 a0
    JR $A751                            ; $A743 18 0c
    JR NC,$A751                         ; $A745 30 0a
    PUSH HL                             ; $A747 e5
    CALL $A4AB                          ; $A748 cd ab a4
    CALL $A7BA                          ; $A74B cd ba a7
    POP HL                              ; $A74E e1
    XOR A                               ; $A74F af
    RET                                 ; $A750 c9
    PUSH HL                             ; $A751 e5
    CALL $A4BC                          ; $A752 cd bc a4
    CALL $A7C5                          ; $A755 cd c5 a7
    POP HL                              ; $A758 e1
    XOR A                               ; $A759 af
    RET                                 ; $A75A c9
    PUSH IX                             ; $A75B dd e5
    POP HL                              ; $A75D e1
    PUSH HL                             ; $A75E e5
    LD E,(IX+$01)                       ; $A75F dd 5e 01
    LD D,(IX+$02)                       ; $A762 dd 56 02
    ADD HL,DE                           ; $A765 19
    CALL $A5C4                          ; $A766 cd c4 a5
    POP IX                              ; $A769 dd e1
    INC IX                              ; $A76B dd 23
    INC IX                              ; $A76D dd 23
    XOR A                               ; $A76F af
    RET                                 ; $A770 c9
    PUSH IX                             ; $A771 dd e5
    CALL $A66C                          ; $A773 cd 6c a6
    EX DE,HL                            ; $A776 eb
    LD A,L                              ; $A777 7d
    OR H                                ; $A778 b4
    CALL NZ,$A5C4                       ; $A779 c4 c4 a5
    POP IX                              ; $A77C dd e1
    XOR A                               ; $A77E af
    RET                                 ; $A77F c9
    LD A,($A036)                        ; $A780 3a 36 a0
    LD DE,$0414                         ; $A783 11 14 04
    AND A                               ; $A786 a7
    RET NZ                              ; $A787 c0
    LD DE,$09F2                         ; $A788 11 f2 09
    OR $01                              ; $A78B f6 01
    RET                                 ; $A78D c9
    LD A,($A034)                        ; $A78E 3a 34 a0
    JR $A783                            ; $A791 18 f0
    LD A,($A036)                        ; $A793 3a 36 a0
    EX AF,AF'                           ; $A796 08
    XOR A                               ; $A797 af
    LD ($A028),A                        ; $A798 32 28 a0
    EX AF,AF'                           ; $A79B 08
    PUSH AF                             ; $A79C f5
    CALL $A82F                          ; $A79D cd 2f a8
    POP AF                              ; $A7A0 f1
    AND A                               ; $A7A1 a7
    LD DE,$0485                         ; $A7A2 11 85 04
    RET NZ                              ; $A7A5 c0
    LD DE,$007A                         ; $A7A6 11 7a 00
    OR $01                              ; $A7A9 f6 01
    RET                                 ; $A7AB c9
    LD A,($A034)                        ; $A7AC 3a 34 a0
    EX AF,AF'                           ; $A7AF 08
    LD A,$01                            ; $A7B0 3e 01
    JR $A798                            ; $A7B2 18 e4
    CALL $A66C                          ; $A7B4 cd 6c a6
    LD A,D                              ; $A7B7 7a
    JR $A7AF                            ; $A7B8 18 f5
    PUSH IY                             ; $A7BA fd e5
    PUSH HL                             ; $A7BC e5
    POP IY                              ; $A7BD fd e1
    CALL $D405                          ; $A7BF cd 05 d4
    POP IY                              ; $A7C2 fd e1
    RET                                 ; $A7C4 c9
    PUSH IY                             ; $A7C5 fd e5
    PUSH HL                             ; $A7C7 e5
    POP IY                              ; $A7C8 fd e1
    CALL $D3E8                          ; $A7CA cd e8 d3
    POP IY                              ; $A7CD fd e1
    RET                                 ; $A7CF c9
    XOR A                               ; $A7D0 af
    LD ($A7EA),A                        ; $A7D1 32 ea a7
    BIT 7,D                             ; $A7D4 cb 7a
    JR Z,$A7EB                          ; $A7D6 28 13
    LD A,E                              ; $A7D8 7b
    LD HL,$09EE                         ; $A7D9 21 ee 09
    CP L                                ; $A7DC bd
    JR NZ,$A7E4                         ; $A7DD 20 05
    LD A,D                              ; $A7DF 7a
    AND $0F                             ; $A7E0 e6 0f
    CP H                                ; $A7E2 bc
    RET Z                               ; $A7E3 c8
    LD A,$01                            ; $A7E4 3e 01
    LD ($A7EA),A                        ; $A7E6 32 ea a7
    RET                                 ; $A7E9 c9
    ORG $A7EB
    LD HL,$A24D                         ; $A7EB 21 4d a2
    LD A,($A027)                        ; $A7EE 3a 27 a0
    LD E,A                              ; $A7F1 5f
    LD A,($A2AA)                        ; $A7F2 3a aa a2
    OR E                                ; $A7F5 b3
    JR Z,$A7FB                          ; $A7F6 28 03
    LD HL,$A255                         ; $A7F8 21 55 a2
    LD A,D                              ; $A7FB 7a
    RRCA                                ; $A7FC 0f
    RRCA                                ; $A7FD 0f
    RRCA                                ; $A7FE 0f
    AND $1E                             ; $A7FF e6 1e
    PUSH DE                             ; $A801 d5
    LD E,A                              ; $A802 5f
    LD D,$00                            ; $A803 16 00
    ADD HL,DE                           ; $A805 19
    LD E,(HL)                           ; $A806 5e
    INC HL                              ; $A807 23
    LD D,(HL)                           ; $A808 56
    CALL $A887                          ; $A809 cd 87 a8
    POP DE                              ; $A80C d1
    RET                                 ; $A80D c9
    PUSH DE                             ; $A80E d5
    CALL $A7D0                          ; $A80F cd d0 a7
    POP DE                              ; $A812 d1
    LD A,$50                            ; $A813 3e 50
    PUSH AF                             ; $A815 f5
    LD A,D                              ; $A816 7a
    AND $0F                             ; $A817 e6 0f
    LD D,A                              ; $A819 57
    POP AF                              ; $A81A f1
    OR D                                ; $A81B b2
    LD D,A                              ; $A81C 57
    AND $0F                             ; $A81D e6 0f
    OR E                                ; $A81F b3
    RET Z                               ; $A820 c8
    CALL $A887                          ; $A821 cd 87 a8
    LD A,($A7EA)                        ; $A824 3a ea a7
    PUSH HL                             ; $A827 e5
    LD HL,$A026                         ; $A828 21 26 a0
    OR (HL)                             ; $A82B b6
    LD (HL),A                           ; $A82C 77
    POP HL                              ; $A82D e1
    RET                                 ; $A82E c9
    CP $FF                              ; $A82F fe ff
    JP NZ,$A751                         ; $A831 c2 51 a7
    LD DE,$080E                         ; $A834 11 0e 08
    JP $A887                            ; $A837 c3 87 a8
    CALL $A840                          ; $A83A cd 40 a8
    JP $A5EA                            ; $A83D c3 ea a5
    SUB $60                             ; $A840 d6 60
    LD E,A                              ; $A842 5f
    LD D,$00                            ; $A843 16 00
    LD HL,$67B7                         ; $A845 21 b7 67
    ADD HL,DE                           ; $A848 19
    ADD HL,DE                           ; $A849 19
    LD E,(HL)                           ; $A84A 5e
    INC HL                              ; $A84B 23
    LD A,(HL)                           ; $A84C 7e
    ADD A,$50                           ; $A84D c6 50
    LD D,A                              ; $A84F 57
    RET                                 ; $A850 c9
    ORG $A852
    LD A,($A851)                        ; $A852 3a 51 a8
    XOR $01                             ; $A855 ee 01
    LD ($A851),A                        ; $A857 32 51 a8
    XOR A                               ; $A85A af
    RET                                 ; $A85B c9
    ORG $A880
    LD E,(HL)                           ; $A880 5e
    INC HL                              ; $A881 23
    LD A,(HL)                           ; $A882 7e
    INC HL                              ; $A883 23
    AND $0F                             ; $A884 e6 0f
    LD D,A                              ; $A886 57
    LD A,($5C3C)                        ; $A887 3a 3c 5c
    AND A                               ; $A88A a7
    RET Z                               ; $A88B c8
    LD ($A022),DE                       ; $A88C ed 53 22 a0
    LD A,D                              ; $A890 7a
    AND $0F                             ; $A891 e6 0f
    OR E                                ; $A893 b3
    RET Z                               ; $A894 c8
    PUSH IX                             ; $A895 dd e5
    PUSH HL                             ; $A897 e5
    PUSH BC                             ; $A898 c5
    PUSH DE                             ; $A899 d5
    LD A,$20                            ; $A89A 3e 20
    CALL $A9B7                          ; $A89C cd b7 a9
    LD A,D                              ; $A89F 7a
    AND $F0                             ; $A8A0 e6 f0
    LD C,A                              ; $A8A2 4f
    CP $70                              ; $A8A3 fe 70
    LD A,$01                            ; $A8A5 3e 01
    JR NZ,$A8AC                         ; $A8A7 20 03
    LD ($A026),A                        ; $A8A9 32 26 a0
    LD A,D                              ; $A8AC 7a
    AND $0F                             ; $A8AD e6 0f
    LD D,A                              ; $A8AF 57
    EX DE,HL                            ; $A8B0 eb
    PUSH HL                             ; $A8B1 e5
    LD A,H                              ; $A8B2 7c
    OR C                                ; $A8B3 b1
    LD H,A                              ; $A8B4 67
    LD ($A022),HL                       ; $A8B5 22 22 a0
    POP HL                              ; $A8B8 e1
    PUSH BC                             ; $A8B9 c5
    LD IX,$5D80                         ; $A8BA dd 21 80 5d
    LD B,$5F                            ; $A8BE 06 5f
    INC B                               ; $A8C0 04
    LD A,(IX+$01)                       ; $A8C1 dd 7e 01
    CP H                                ; $A8C4 bc
    JR C,$A8CF                          ; $A8C5 38 08
    JR NZ,$A8D9                         ; $A8C7 20 10
    LD A,(IX+$00)                       ; $A8C9 dd 7e 00
    CP L                                ; $A8CC bd
    JR NC,$A8D9                         ; $A8CD 30 0a
    INC IX                              ; $A8CF dd 23
    INC IX                              ; $A8D1 dd 23
    LD A,B                              ; $A8D3 78
    CP $7B                              ; $A8D4 fe 7b
    JR NZ,$A8C0                         ; $A8D6 20 e8
    INC B                               ; $A8D8 04
    JR Z,$A8E0                          ; $A8D9 28 05
    DEC IX                              ; $A8DB dd 2b
    DEC IX                              ; $A8DD dd 2b
    DEC B                               ; $A8DF 05
    LD E,(IX+$00)                       ; $A8E0 dd 5e 00
    LD D,(IX+$01)                       ; $A8E3 dd 56 01
    LD A,D                              ; $A8E6 7a
    OR E                                ; $A8E7 b3
    JR Z,$A8DB                          ; $A8E8 28 f1
    LD A,B                              ; $A8EA 78
    CALL $A9B7                          ; $A8EB cd b7 a9
    LD BC,$5DBF                         ; $A8EE 01 bf 5d
    ADD HL,BC                           ; $A8F1 09
    PUSH HL                             ; $A8F2 e5
    EX DE,HL                            ; $A8F3 eb
    ADD HL,BC                           ; $A8F4 09
    PUSH HL                             ; $A8F5 e5
    AND A                               ; $A8F6 a7
    SBC HL,DE                           ; $A8F7 ed 52
    POP HL                              ; $A8F9 e1
    PUSH AF                             ; $A8FA f5
    CALL $A95B                          ; $A8FB cd 5b a9
    POP AF                              ; $A8FE f1
    JR NZ,$A8F5                         ; $A8FF 20 f4
    POP HL                              ; $A901 e1
    POP BC                              ; $A902 c1
    LD A,C                              ; $A903 79
    CP $50                              ; $A904 fe 50
    JR Z,$A91C                          ; $A906 28 14
    CP $40                              ; $A908 fe 40
    JR Z,$A919                          ; $A90A 28 0d
    CP $10                              ; $A90C fe 10
    LD A,($A034)                        ; $A90E 3a 34 a0
    JR Z,$A916                          ; $A911 28 03
    LD A,($A036)                        ; $A913 3a 36 a0
    AND A                               ; $A916 a7
    JR Z,$A91C                          ; $A917 28 03
    CALL $A92F                          ; $A919 cd 2f a9
    LD HL,$5C42                         ; $A91C 21 42 5c
    LD A,(HL)                           ; $A91F 7e
    AND A                               ; $A920 a7
    JR Z,$A929                          ; $A921 28 06
    CALL $A9B7                          ; $A923 cd b7 a9
    INC HL                              ; $A926 23
    JR $A91F                            ; $A927 18 f6
    POP DE                              ; $A929 d1
    POP BC                              ; $A92A c1
    POP HL                              ; $A92B e1
    POP IX                              ; $A92C dd e1
    RET                                 ; $A92E c9
    LD A,(HL)                           ; $A92F 7e
    AND $0F                             ; $A930 e6 0f
    CP $0F                              ; $A932 fe 0f
    RET Z                               ; $A934 c8
    RLCA                                ; $A935 07
    RLCA                                ; $A936 07
    LD L,A                              ; $A937 6f
    LD H,$00                            ; $A938 26 00
    LD BC,$A85C                         ; $A93A 01 5c a8
    ADD HL,BC                           ; $A93D 09
    LD B,$04                            ; $A93E 06 04
    LD A,(HL)                           ; $A940 7e
    INC HL                              ; $A941 23
    LD (IX+$00),A                       ; $A942 dd 77 00
    INC IX                              ; $A945 dd 23
    DJNZ $A940                          ; $A947 10 f7
    LD (IX+$00),B                       ; $A949 dd 70 00
    RET                                 ; $A94C c9
    ORG $A95B
    PUSH BC                             ; $A95B c5
    LD IX,$5C42                         ; $A95C dd 21 42 5c
    INC HL                              ; $A960 23
    LD A,(HL)                           ; $A961 7e
    BIT 7,A                             ; $A962 cb 7f
    INC HL                              ; $A964 23
    JR Z,$A969                          ; $A965 28 02
    INC HL                              ; $A967 23
    INC HL                              ; $A968 23
    PUSH AF                             ; $A969 f5
    AND $70                             ; $A96A e6 70
    JR Z,$A974                          ; $A96C 28 06
    INC IX                              ; $A96E dd 23
    SUB $10                             ; $A970 d6 10
    JR NZ,$A96E                         ; $A972 20 fa
    LD C,$00                            ; $A974 0e 00
    POP AF                              ; $A976 f1
    AND $0F                             ; $A977 e6 0f
    JR Z,$A986                          ; $A979 28 0b
    LD B,A                              ; $A97B 47
    CALL $A990                          ; $A97C cd 90 a9
    LD (IX+$00),A                       ; $A97F dd 77 00
    INC IX                              ; $A982 dd 23
    DJNZ $A97C                          ; $A984 10 f6
    LD (IX+$00),$00                     ; $A986 dd 36 00 00
    LD A,C                              ; $A98A 79
    POP BC                              ; $A98B c1
    AND A                               ; $A98C a7
    RET Z                               ; $A98D c8
    INC HL                              ; $A98E 23
    RET                                 ; $A98F c9
    PUSH DE                             ; $A990 d5
    LD D,(HL)                           ; $A991 56
    INC HL                              ; $A992 23
    LD E,(HL)                           ; $A993 5e
    DEC HL                              ; $A994 2b
    LD A,C                              ; $A995 79
    AND A                               ; $A996 a7
    JR Z,$A9A0                          ; $A997 28 07
    SLA E                               ; $A999 cb 23
    RL D                                ; $A99B cb 12
    DEC A                               ; $A99D 3d
    JR NZ,$A999                         ; $A99E 20 f9
    LD A,C                              ; $A9A0 79
    ADD A,$05                           ; $A9A1 c6 05
    CP $08                              ; $A9A3 fe 08
    JR C,$A9AA                          ; $A9A5 38 03
    SUB $08                             ; $A9A7 d6 08
    INC HL                              ; $A9A9 23
    LD C,A                              ; $A9AA 4f
    LD A,D                              ; $A9AB 7a
    POP DE                              ; $A9AC d1
    RRCA                                ; $A9AD 0f
    RRCA                                ; $A9AE 0f
    RRCA                                ; $A9AF 0f
    AND $1F                             ; $A9B0 e6 1f
    ADD A,$60                           ; $A9B2 c6 60
    RET                                 ; $A9B4 c9
    ORG $A9B7
    PUSH AF                             ; $A9B7 f5
    LD A,($A027)                        ; $A9B8 3a 27 a0
    AND A                               ; $A9BB a7
    JR NZ,$AA10                         ; $A9BC 20 52
    POP AF                              ; $A9BE f1
    PUSH AF                             ; $A9BF f5
    PUSH HL                             ; $A9C0 e5
    LD HL,($A9B5)                       ; $A9C1 2a b5 a9
    CP $20                              ; $A9C4 fe 20
    JR Z,$A9DF                          ; $A9C6 28 17
    CP $0D                              ; $A9C8 fe 0d
    JR Z,$A9DF                          ; $A9CA 28 13
    CP $22                              ; $A9CC fe 22
    JR Z,$A9DF                          ; $A9CE 28 0f
    CP $08                              ; $A9D0 fe 08
    JR NZ,$A9D7                         ; $A9D2 20 03
    DEC HL                              ; $A9D4 2b
    JR $A9D9                            ; $A9D5 18 02
    LD (HL),A                           ; $A9D7 77
    INC HL                              ; $A9D8 23
    LD ($A9B5),HL                       ; $A9D9 22 b5 a9
    POP HL                              ; $A9DC e1
    POP AF                              ; $A9DD f1
    RET                                 ; $A9DE c9
    PUSH DE                             ; $A9DF d5
    LD DE,$5C0B                         ; $A9E0 11 0b 5c
    AND A                               ; $A9E3 a7
    SBC HL,DE                           ; $A9E4 ed 52
    JR Z,$AA0B                          ; $A9E6 28 23
    LD A,($C1F5)                        ; $A9E8 3a f5 c1
    CP L                                ; $A9EB bd
    PUSH AF                             ; $A9EC f5
    JR NC,$A9F4                         ; $A9ED 30 05
    LD A,$0D                            ; $A9EF 3e 0d
    CALL $AA14                          ; $A9F1 cd 14 aa
    PUSH BC                             ; $A9F4 c5
    LD B,L                              ; $A9F5 45
    LD HL,$5C0B                         ; $A9F6 21 0b 5c
    LD ($A9B5),HL                       ; $A9F9 22 b5 a9
    LD A,(HL)                           ; $A9FC 7e
    CALL $AA14                          ; $A9FD cd 14 aa
    INC HL                              ; $AA00 23
    DJNZ $A9FC                          ; $AA01 10 f9
    POP BC                              ; $AA03 c1
    POP AF                              ; $AA04 f1
    JR NZ,$AA0B                         ; $AA05 20 04
    XOR A                               ; $AA07 af
    LD ($A025),A                        ; $AA08 32 25 a0
    POP DE                              ; $AA0B d1
    POP HL                              ; $AA0C e1
    POP AF                              ; $AA0D f1
    JR $AA14                            ; $AA0E 18 04
    POP AF                              ; $AA10 f1
    JP $C1E1                            ; $AA11 c3 e1 c1
    CP $41                              ; $AA14 fe 41
    JR C,$AA1E                          ; $AA16 38 06
    CP $5B                              ; $AA18 fe 5b
    JR NC,$AA1E                         ; $AA1A 30 02
    OR $20                              ; $AA1C f6 20
    PUSH AF                             ; $AA1E f5
    LD A,($A025)                        ; $AA1F 3a 25 a0
    AND A                               ; $AA22 a7
    JR NZ,$AA2A                         ; $AA23 20 05
    POP AF                              ; $AA25 f1
    CP $20                              ; $AA26 fe 20
    RET Z                               ; $AA28 c8
    PUSH AF                             ; $AA29 f5
    LD A,$01                            ; $AA2A 3e 01
    LD ($A025),A                        ; $AA2C 32 25 a0
    POP AF                              ; $AA2F f1
    PUSH AF                             ; $AA30 f5
    CP $0D                              ; $AA31 fe 0d
    JR NZ,$AA3B                         ; $AA33 20 06
    XOR A                               ; $AA35 af
    LD ($A025),A                        ; $AA36 32 25 a0
    JR $AA6D                            ; $AA39 18 32
    CP $22                              ; $AA3B fe 22
    JR NZ,$AA46                         ; $AA3D 20 07
    LD A,$20                            ; $AA3F 3e 20
    CALL $C1E1                          ; $AA41 cd e1 c1
    JR $AA4A                            ; $AA44 18 04
    CP $2E                              ; $AA46 fe 2e
    JR NZ,$AA51                         ; $AA48 20 07
    LD A,$01                            ; $AA4A 3e 01
    LD ($A026),A                        ; $AA4C 32 26 a0
    JR $AA6D                            ; $AA4F 18 1c
    CP $61                              ; $AA51 fe 61
    JR C,$AA6D                          ; $AA53 38 18
    CP $7B                              ; $AA55 fe 7b
    JR NC,$AA6D                         ; $AA57 30 14
    LD A,($A851)                        ; $AA59 3a 51 a8
    AND A                               ; $AA5C a7
    JR NZ,$AA65                         ; $AA5D 20 06
    LD A,($A026)                        ; $AA5F 3a 26 a0
    AND A                               ; $AA62 a7
    JR Z,$AA6D                          ; $AA63 28 08
    XOR A                               ; $AA65 af
    LD ($A026),A                        ; $AA66 32 26 a0
    POP AF                              ; $AA69 f1
    AND $5F                             ; $AA6A e6 5f
    PUSH AF                             ; $AA6C f5
    POP AF                              ; $AA6D f1
    JP $C1E1                            ; $AA6E c3 e1 c1
    ORG $AAB2
    XOR A                               ; $AAB2 af
    LD ($A01A),A                        ; $AAB3 32 1a a0
    LD ($A012),A                        ; $AAB6 32 12 a0
    LD E,$FF                            ; $AAB9 1e ff
    LD D,$C0                            ; $AABB 16 c0
    LD A,E                              ; $AABD 7b
    OR $C7                              ; $AABE f6 c7
    LD E,A                              ; $AAC0 5f
    CALL $AE6A                          ; $AAC1 cd 6a ae
    LD A,($A01B)                        ; $AAC4 3a 1b a0
    AND A                               ; $AAC7 a7
    JR Z,$AAD1                          ; $AAC8 28 07
    LD A,$01                            ; $AACA 3e 01
    LD ($A024),A                        ; $AACC 32 24 a0
    RES 3,E                             ; $AACF cb 9b
    PUSH DE                             ; $AAD1 d5
    LD A,($A024)                        ; $AAD2 3a 24 a0
    AND A                               ; $AAD5 a7
    JR NZ,$AB11                         ; $AAD6 20 39
    LD ($AAA7),A                        ; $AAD8 32 a7 aa
    LD HL,($A02B)                       ; $AADB 2a 2b a0
    PUSH HL                             ; $AADE e5
    CALL $AC24                          ; $AADF cd 24 ac
    JR NZ,$AB08                         ; $AAE2 20 24
    LD A,($AAA7)                        ; $AAE4 3a a7 aa
    AND A                               ; $AAE7 a7
    JR NZ,$AB08                         ; $AAE8 20 1e
    LD A,$02                            ; $AAEA 3e 02
    LD ($A024),A                        ; $AAEC 32 24 a0
    POP HL                              ; $AAEF e1
    PUSH IY                             ; $AAF0 fd e5
    POP HL                              ; $AAF2 e1
    LD DE,$0018                         ; $AAF3 11 18 00
    ADD HL,DE                           ; $AAF6 19
    LD DE,$AAAC                         ; $AAF7 11 ac aa
    EX DE,HL                            ; $AAFA eb
    LD BC,$0006                         ; $AAFB 01 06 00
    LDIR                                ; $AAFE ed b0
    LD HL,($A029)                       ; $AB00 2a 29 a0
    LD ($A02B),HL                       ; $AB03 22 2b a0
    JR $AB11                            ; $AB06 18 09
    LD A,$01                            ; $AB08 3e 01
    LD ($A024),A                        ; $AB0A 32 24 a0
    POP HL                              ; $AB0D e1
    LD ($A02B),HL                       ; $AB0E 22 2b a0
    POP DE                              ; $AB11 d1
    XOR A                               ; $AB12 af
    LD ($AAA7),A                        ; $AB13 32 a7 aa
    CALL $AB91                          ; $AB16 cd 91 ab
    JR C,$AB8E                          ; $AB19 38 73
    JR Z,$AB47                          ; $AB1B 28 2a
    CP $90                              ; $AB1D fe 90
    JP Z,$AFB3                          ; $AB1F ca b3 af
    CP $A0                              ; $AB22 fe a0
    JP Z,$ACCC                          ; $AB24 ca cc ac
    BIT 3,E                             ; $AB27 cb 5b
    JR Z,$AB4C                          ; $AB29 28 21
    LD A,($A012)                        ; $AB2B 3a 12 a0
    AND A                               ; $AB2E a7
    JR NZ,$AB8E                         ; $AB2F 20 5d
    LD A,($A01B)                        ; $AB31 3a 1b a0
    AND A                               ; $AB34 a7
    JR NZ,$AB4C                         ; $AB35 20 15
    LD A,($A02D)                        ; $AB37 3a 2d a0
    CP $C0                              ; $AB3A fe c0
    JR NZ,$AB8E                         ; $AB3C 20 50
    LD A,$B0                            ; $AB3E 3e b0
    CP D                                ; $AB40 ba
    JR NZ,$AB8E                         ; $AB41 20 4b
    LD A,$02                            ; $AB43 3e 02
    AND A                               ; $AB45 a7
    RET                                 ; $AB46 c9
    BIT 3,E                             ; $AB47 cb 5b
    JP Z,$ACFB                          ; $AB49 ca fb ac
    LD HL,($A029)                       ; $AB4C 2a 29 a0
    LD ($A02B),HL                       ; $AB4F 22 2b a0
    CALL $AC24                          ; $AB52 cd 24 ac
    JR C,$AB8E                          ; $AB55 38 37
    JR NZ,$AB60                         ; $AB57 20 07
    CALL $ACA6                          ; $AB59 cd a6 ac
    JR Z,$AB8E                          ; $AB5C 28 30
    JR $AB4C                            ; $AB5E 18 ec
    CP $B0                              ; $AB60 fe b0
    JP Z,$AD57                          ; $AB62 ca 57 ad
    CP $A0                              ; $AB65 fe a0
    JP Z,$ACCC                          ; $AB67 ca cc ac
    CP $90                              ; $AB6A fe 90
    JP Z,$AFB3                          ; $AB6C ca b3 af
    LD HL,($A029)                       ; $AB6F 2a 29 a0
    LD ($A02B),HL                       ; $AB72 22 2b a0
    LD A,($A024)                        ; $AB75 3a 24 a0
    CP $02                              ; $AB78 fe 02
    JR NZ,$AB8E                         ; $AB7A 20 12
    CALL $ABF3                          ; $AB7C cd f3 ab
    JR C,$AB8E                          ; $AB7F 38 0d
    JR NZ,$AB8E                         ; $AB81 20 0b
    LD HL,($A029)                       ; $AB83 2a 29 a0
    LD ($A02B),HL                       ; $AB86 22 2b a0
    LD D,$A0                            ; $AB89 16 a0
    JP $ACCC                            ; $AB8B c3 cc ac
    JP $AF67                            ; $AB8E c3 67 af
    LD A,($A024)                        ; $AB91 3a 24 a0
    CP $02                              ; $AB94 fe 02
    JR Z,$ABF3                          ; $AB96 28 5b
    LD A,E                              ; $AB98 7b
    OR $07                              ; $AB99 f6 07
    LD E,A                              ; $AB9B 5f
    CALL $AE7F                          ; $AB9C cd 7f ae
    CP $E0                              ; $AB9F fe e0
    JR Z,$AB9C                          ; $ABA1 28 f9
    CP $30                              ; $ABA3 fe 30
    JR NZ,$ABB7                         ; $ABA5 20 10
    BIT 1,E                             ; $ABA7 cb 4b
    JR Z,$ABB5                          ; $ABA9 28 0a
    RES 1,E                             ; $ABAB cb 8b
    LD (IY+$00),C                       ; $ABAD fd 71 00
    LD (IY+$01),B                       ; $ABB0 fd 70 01
    JR $AB9C                            ; $ABB3 18 e7
    SCF                                 ; $ABB5 37
    RET                                 ; $ABB6 c9
    CP $00                              ; $ABB7 fe 00
    JR NZ,$ABC9                         ; $ABB9 20 0e
    BIT 2,E                             ; $ABBB cb 53
    JR Z,$ABB5                          ; $ABBD 28 f6
    RES 2,E                             ; $ABBF cb 93
    LD (IY+$02),C                       ; $ABC1 fd 71 02
    LD (IY+$03),B                       ; $ABC4 fd 70 03
    JR $AB9C                            ; $ABC7 18 d3
    CP $40                              ; $ABC9 fe 40
    JR NZ,$ABD1                         ; $ABCB 20 04
    RES 0,E                             ; $ABCD cb 83
    JR $ABA7                            ; $ABCF 18 d6
    CP $20                              ; $ABD1 fe 20
    JR NZ,$ABEF                         ; $ABD3 20 1a
    BIT 1,E                             ; $ABD5 cb 4b
    JR NZ,$ABA7                         ; $ABD7 20 ce
    BIT 0,E                             ; $ABD9 cb 43
    JR NZ,$ABBB                         ; $ABDB 20 de
    RES 2,E                             ; $ABDD cb 93
    SET 0,E                             ; $ABDF cb c3
    LD A,(IY+$00)                       ; $ABE1 fd 7e 00
    LD (IY+$02),A                       ; $ABE4 fd 77 02
    LD A,(IY+$01)                       ; $ABE7 fd 7e 01
    LD (IY+$03),A                       ; $ABEA fd 77 03
    JR $ABAB                            ; $ABED 18 bc
    OR A                                ; $ABEF b7
    BIT 1,E                             ; $ABF0 cb 4b
    RET                                 ; $ABF2 c9
    CALL $AE7F                          ; $ABF3 cd 7f ae
    CP $80                              ; $ABF6 fe 80
    CALL Z,$AE7F                        ; $ABF8 cc 7f ae
    LD A,B                              ; $ABFB 78
    AND $0F                             ; $ABFC e6 0f
    LD B,A                              ; $ABFE 47
    LD HL,$994D                         ; $ABFF 21 4d 99
    LD A,(HL)                           ; $AC02 7e
    INC HL                              ; $AC03 23
    OR (HL)                             ; $AC04 b6
    JR Z,$AC14                          ; $AC05 28 0d
    LD A,B                              ; $AC07 78
    CP (HL)                             ; $AC08 be
    JR NZ,$AC11                         ; $AC09 20 06
    DEC HL                              ; $AC0B 2b
    LD A,C                              ; $AC0C 79
    CP (HL)                             ; $AC0D be
    JR Z,$AC17                          ; $AC0E 28 07
    INC HL                              ; $AC10 23
    INC HL                              ; $AC11 23
    JR $AC02                            ; $AC12 18 ee
    OR $01                              ; $AC14 f6 01
    RET                                 ; $AC16 c9
    LD (IY+$00),C                       ; $AC17 fd 71 00
    LD (IY+$01),B                       ; $AC1A fd 70 01
    RES 1,E                             ; $AC1D cb 8b
    CALL $AE7F                          ; $AC1F cd 7f ae
    XOR A                               ; $AC22 af
    RET                                 ; $AC23 c9
    LD HL,$AAA8                         ; $AC24 21 a8 aa
    LD B,$0A                            ; $AC27 06 0a
    CALL $A2AB                          ; $AC29 cd ab a2
    LD A,E                              ; $AC2C 7b
    OR $34                              ; $AC2D f6 34
    LD E,A                              ; $AC2F 5f
    CALL $AE7F                          ; $AC30 cd 7f ae
    CP $80                              ; $AC33 fe 80
    JR NZ,$AC41                         ; $AC35 20 0a
    BIT 4,E                             ; $AC37 cb 63
    JR Z,$AC3F                          ; $AC39 28 04
    RES 4,E                             ; $AC3B cb a3
    JR $AC30                            ; $AC3D 18 f1
    SCF                                 ; $AC3F 37
    RET                                 ; $AC40 c9
    CP $10                              ; $AC41 fe 10
    JR Z,$AC49                          ; $AC43 28 04
    CP $70                              ; $AC45 fe 70
    JR NZ,$AC65                         ; $AC47 20 1c
    BIT 4,E                             ; $AC49 cb 63
    JR Z,$AC3F                          ; $AC4B 28 f2
    BIT 2,E                             ; $AC4D cb 53
    JR Z,$AC3F                          ; $AC4F 28 ee
    LD A,($AAA7)                        ; $AC51 3a a7 aa
    CP $03                              ; $AC54 fe 03
    JR NC,$AC3F                         ; $AC56 30 e7
    INC A                               ; $AC58 3c
    LD ($AAA7),A                        ; $AC59 32 a7 aa
    CALL $AC8F                          ; $AC5C cd 8f ac
    JR NZ,$AC3F                         ; $AC5F 20 de
    RES 5,E                             ; $AC61 cb ab
    JR $AC30                            ; $AC63 18 cb
    CP $60                              ; $AC65 fe 60
    JR NZ,$AC78                         ; $AC67 20 0f
    BIT 2,E                             ; $AC69 cb 53
    JR Z,$AC3F                          ; $AC6B 28 d2
    RES 4,E                             ; $AC6D cb a3
    RES 5,E                             ; $AC6F cb ab
    CALL $AC94                          ; $AC71 cd 94 ac
    JR NZ,$AC3F                         ; $AC74 20 c9
    JR $AC30                            ; $AC76 18 b8
    CP $F0                              ; $AC78 fe f0
    JR Z,$AC80                          ; $AC7A 28 04
    CP $50                              ; $AC7C fe 50
    JR NZ,$AC8B                         ; $AC7E 20 0b
    LD A,E                              ; $AC80 7b
    AND $CB                             ; $AC81 e6 cb
    LD E,A                              ; $AC83 5f
    LD ($AAAC),BC                       ; $AC84 ed 43 ac aa
    CALL $AE7F                          ; $AC88 cd 7f ae
    AND A                               ; $AC8B a7
    BIT 5,E                             ; $AC8C cb 6b
    RET                                 ; $AC8E c9
    LD HL,$AAA8                         ; $AC8F 21 a8 aa
    JR $AC97                            ; $AC92 18 03
    LD HL,$AAAE                         ; $AC94 21 ae aa
    LD A,(HL)                           ; $AC97 7e
    INC HL                              ; $AC98 23
    OR (HL)                             ; $AC99 b6
    JR Z,$ACA1                          ; $AC9A 28 05
    INC HL                              ; $AC9C 23
    LD A,(HL)                           ; $AC9D 7e
    INC HL                              ; $AC9E 23
    OR (HL)                             ; $AC9F b6
    RET NZ                              ; $ACA0 c0
    LD (HL),B                           ; $ACA1 70
    DEC HL                              ; $ACA2 2b
    LD (HL),C                           ; $ACA3 71
    XOR A                               ; $ACA4 af
    RET                                 ; $ACA5 c9
    BIT 6,E                             ; $ACA6 cb 73
    JR Z,$ACB2                          ; $ACA8 28 08
    RES 6,E                             ; $ACAA cb b3
    PUSH DE                             ; $ACAC d5
    LD DE,$0004                         ; $ACAD 11 04 00
    JR $ACBB                            ; $ACB0 18 09
    BIT 7,E                             ; $ACB2 cb 7b
    RET Z                               ; $ACB4 c8
    RES 7,E                             ; $ACB5 cb bb
    PUSH DE                             ; $ACB7 d5
    LD DE,$000E                         ; $ACB8 11 0e 00
    PUSH IY                             ; $ACBB fd e5
    POP HL                              ; $ACBD e1
    ADD HL,DE                           ; $ACBE 19
    LD DE,$AAA8                         ; $ACBF 11 a8 aa
    EX DE,HL                            ; $ACC2 eb
    LD BC,$000A                         ; $ACC3 01 0a 00
    LDIR                                ; $ACC6 ed b0
    POP DE                              ; $ACC8 d1
    OR $01                              ; $ACC9 f6 01
    RET                                 ; $ACCB c9
    RES 3,E                             ; $ACCC cb 9b
    PUSH DE                             ; $ACCE d5
    CALL $AE7F                          ; $ACCF cd 7f ae
    CP $A0                              ; $ACD2 fe a0
    JR Z,$ACCF                          ; $ACD4 28 f9
    LD HL,($A029)                       ; $ACD6 2a 29 a0
    LD ($AAA1),HL                       ; $ACD9 22 a1 aa
    LD ($A02B),HL                       ; $ACDC 22 2b a0
    POP DE                              ; $ACDF d1
    LD A,E                              ; $ACE0 7b
    LD ($AAA3),A                        ; $ACE1 32 a3 aa
    LD ($AAA4),IY                       ; $ACE4 fd 22 a4 aa
    LD A,($A012)                        ; $ACE8 3a 12 a0
    LD ($AAA6),A                        ; $ACEB 32 a6 aa
    LD A,($A01A)                        ; $ACEE 3a 1a a0
    CP $02                              ; $ACF1 fe 02
    JR NZ,$AD57                         ; $ACF3 20 62
    SET 6,(IY+$01)                      ; $ACF5 fd cb 01 f6
    JR $AD57                            ; $ACF9 18 5c
    LD A,($A024)                        ; $ACFB 3a 24 a0
    CP $02                              ; $ACFE fe 02
    JR NZ,$AD23                         ; $AD00 20 21
    BIT 6,E                             ; $AD02 cb 73
    JP NZ,$AB4C                         ; $AD04 c2 4c ab
    SET 6,E                             ; $AD07 cb f3
    SET 3,E                             ; $AD09 cb db
    PUSH IY                             ; $AD0B fd e5
    EXX                                 ; $AD0D d9
    POP HL                              ; $AD0E e1
    LD DE,$0008                         ; $AD0F 11 08 00
    ADD HL,DE                           ; $AD12 19
    PUSH HL                             ; $AD13 e5
    LD DE,$0010                         ; $AD14 11 10 00
    ADD HL,DE                           ; $AD17 19
    POP DE                              ; $AD18 d1
    EX DE,HL                            ; $AD19 eb
    LD BC,$0006                         ; $AD1A 01 06 00
    LDIR                                ; $AD1D ed b0
    EXX                                 ; $AD1F d9
    JP $AB4C                            ; $AD20 c3 4c ab
    LD A,($A01B)                        ; $AD23 3a 1b a0
    AND A                               ; $AD26 a7
    JR Z,$AD2E                          ; $AD27 28 05
    SET 3,E                             ; $AD29 cb db
    JP $AB4C                            ; $AD2B c3 4c ab
    LD HL,($AAA1)                       ; $AD2E 2a a1 aa
    LD ($A02B),HL                       ; $AD31 22 2b a0
    LD D,$B0                            ; $AD34 16 b0
    LD A,($AAA3)                        ; $AD36 3a a3 aa
    LD E,A                              ; $AD39 5f
    LD A,($AAA6)                        ; $AD3A 3a a6 aa
    LD ($A012),A                        ; $AD3D 32 12 a0
    LD IY,($AAA4)                       ; $AD40 fd 2a a4 aa
    LD L,(IY-$02)                       ; $AD44 fd 6e fe
    LD H,(IY-$01)                       ; $AD47 fd 66 ff
    PUSH HL                             ; $AD4A e5
    POP IX                              ; $AD4B dd e1
    CALL $A1AF                          ; $AD4D cd af a1
    XOR A                               ; $AD50 af
    LD (IY-$02),A                       ; $AD51 fd 77 fe
    LD (IY-$01),A                       ; $AD54 fd 77 ff
    LD A,($A01A)                        ; $AD57 3a 1a a0
    DEC A                               ; $AD5A 3d
    LD HL,$A012                         ; $AD5B 21 12 a0
    DEC A                               ; $AD5E 3d
    LD A,D                              ; $AD5F 7a
    JR NZ,$AD66                         ; $AD60 20 04
    CP $A0                              ; $AD62 fe a0
    JR Z,$AD67                          ; $AD64 28 01
    INC (HL)                            ; $AD66 34
    CP $A0                              ; $AD67 fe a0
    JP Z,$AABD                          ; $AD69 ca bd aa
    LD A,($A01B)                        ; $AD6C 3a 1b a0
    AND A                               ; $AD6F a7
    JR Z,$ADD4                          ; $AD70 28 62
    LD IY,($9FF0)                       ; $AD72 fd 2a f0 9f
    CALL $AEA9                          ; $AD76 cd a9 ae
    LD A,(IY+$01)                       ; $AD79 fd 7e 01
    AND $7F                             ; $AD7C e6 7f
    OR (IY+$00)                         ; $AD7E fd b6 00
    JR NZ,$ADB8                         ; $AD81 20 35
    LD A,($A01B)                        ; $AD83 3a 1b a0
    LD E,A                              ; $AD86 5f
    LD D,$00                            ; $AD87 16 00
    LD HL,($9FF0)                       ; $AD89 2a f0 9f
    LD A,(IY+$01)                       ; $AD8C fd 7e 01
    AND $80                             ; $AD8F e6 80
    INC HL                              ; $AD91 23
    OR (HL)                             ; $AD92 b6
    LD (HL),A                           ; $AD93 77
    DEC HL                              ; $AD94 2b
    ADD HL,DE                           ; $AD95 19
    LD DE,$0008                         ; $AD96 11 08 00
    ADD IY,DE                           ; $AD99 fd 19
    PUSH IY                             ; $AD9B fd e5
    POP DE                              ; $AD9D d1
    CALL $AE59                          ; $AD9E cd 59 ae
    CALL $AE59                          ; $ADA1 cd 59 ae
    JR Z,$ADAF                          ; $ADA4 28 09
    PUSH DE                             ; $ADA6 d5
    PUSH HL                             ; $ADA7 e5
    DEC DE                              ; $ADA8 1b
    DEC DE                              ; $ADA9 1b
    CALL $AE59                          ; $ADAA cd 59 ae
    POP HL                              ; $ADAD e1
    POP DE                              ; $ADAE d1
    CALL $AE59                          ; $ADAF cd 59 ae
    LD IY,($9FF0)                       ; $ADB2 fd 2a f0 9f
    JR $ADBC                            ; $ADB6 18 04
    LD IY,$9FF2                         ; $ADB8 fd 21 f2 9f
    LD L,(IY-$02)                       ; $ADBC fd 6e fe
    LD H,(IY-$01)                       ; $ADBF fd 66 ff
    PUSH HL                             ; $ADC2 e5
    POP IX                              ; $ADC3 dd e1
    LD L,(IX-$02)                       ; $ADC5 dd 6e fe
    LD H,(IX-$01)                       ; $ADC8 dd 66 ff
    LD (IY-$02),L                       ; $ADCB fd 75 fe
    LD (IY-$01),H                       ; $ADCE fd 74 ff
    CALL $A1C7                          ; $ADD1 cd c7 a1
    LD IY,$9FF2                         ; $ADD4 fd 21 f2 9f
    LD A,($A012)                        ; $ADD8 3a 12 a0
    LD B,A                              ; $ADDB 47
    PUSH BC                             ; $ADDC c5
    CALL $AEB6                          ; $ADDD cd b6 ae
    LD A,B                              ; $ADE0 78
    AND A                               ; $ADE1 a7
    JR Z,$AE1E                          ; $ADE2 28 3a
    CALL $AEB6                          ; $ADE4 cd b6 ae
    LD A,($A024)                        ; $ADE7 3a 24 a0
    CP $02                              ; $ADEA fe 02
    JR NZ,$AE11                         ; $ADEC 20 23
    PUSH IY                             ; $ADEE fd e5
    POP HL                              ; $ADF0 e1
    LD DE,$0018                         ; $ADF1 11 18 00
    ADD HL,DE                           ; $ADF4 19
    PUSH HL                             ; $ADF5 e5
    LD D,$06                            ; $ADF6 16 06
    XOR A                               ; $ADF8 af
    OR (HL)                             ; $ADF9 b6
    INC HL                              ; $ADFA 23
    DEC D                               ; $ADFB 15
    JR NZ,$ADF9                         ; $ADFC 20 fb
    POP HL                              ; $ADFE e1
    AND A                               ; $ADFF a7
    JR NZ,$AE11                         ; $AE00 20 0f
    EX DE,HL                            ; $AE02 eb
    PUSH IX                             ; $AE03 dd e5
    POP HL                              ; $AE05 e1
    PUSH BC                             ; $AE06 c5
    LD BC,$0018                         ; $AE07 01 18 00
    ADD HL,BC                           ; $AE0A 09
    LD BC,$0006                         ; $AE0B 01 06 00
    LDIR                                ; $AE0E ed b0
    POP BC                              ; $AE10 c1
    LD A,(IY+$01)                       ; $AE11 fd 7e 01
    AND $7F                             ; $AE14 e6 7f
    OR (IY+$00)                         ; $AE16 fd b6 00
    CALL Z,$AEF1                        ; $AE19 cc f1 ae
    JR $ADE0                            ; $AE1C 18 c2
    POP BC                              ; $AE1E c1
    CALL $AEEA                          ; $AE1F cd ea ae
    CALL $AEC5                          ; $AE22 cd c5 ae
    LD A,B                              ; $AE25 78
    AND A                               ; $AE26 a7
    JP Z,$AE57                          ; $AE27 ca 57 ae
    CALL $AEC5                          ; $AE2A cd c5 ae
    LD A,(IY+$12)                       ; $AE2D fd 7e 12
    OR (IY+$13)                         ; $AE30 fd b6 13
    JR NZ,$AE25                         ; $AE33 20 f0
    LD A,(IY+$00)                       ; $AE35 fd 7e 00
    CP (IX+$00)                         ; $AE38 dd be 00
    JR NZ,$AE25                         ; $AE3B 20 e8
    LD A,(IY+$01)                       ; $AE3D fd 7e 01
    CP (IX+$01)                         ; $AE40 dd be 01
    JR NZ,$AE25                         ; $AE43 20 e0
    LD A,(IX+$0E)                       ; $AE45 dd 7e 0e
    OR (IX+$0F)                         ; $AE48 dd b6 0f
    JR Z,$AE25                          ; $AE4B 28 d8
    EXX                                 ; $AE4D d9
    LD DE,$000E                         ; $AE4E 11 0e 00
    CALL $AF27                          ; $AE51 cd 27 af
    JP $AE25                            ; $AE54 c3 25 ae
    XOR A                               ; $AE57 af
    RET                                 ; $AE58 c9
    LD A,(HL)                           ; $AE59 7e
    INC HL                              ; $AE5A 23
    OR (HL)                             ; $AE5B b6
    DEC HL                              ; $AE5C 2b
    JR NZ,$AE61                         ; $AE5D 20 02
    LD A,(DE)                           ; $AE5F 1a
    LD (HL),A                           ; $AE60 77
    INC HL                              ; $AE61 23
    INC DE                              ; $AE62 13
    JR NZ,$AE67                         ; $AE63 20 02
    LD A,(DE)                           ; $AE65 1a
    LD (HL),A                           ; $AE66 77
    INC HL                              ; $AE67 23
    INC DE                              ; $AE68 13
    RET                                 ; $AE69 c9
    CALL $AEEA                          ; $AE6A cd ea ae
    LD A,$1E                            ; $AE6D 3e 1e
    CALL $A11C                          ; $AE6F cd 1c a1
    PUSH IX                             ; $AE72 dd e5
    POP HL                              ; $AE74 e1
    LD (IY-$02),L                       ; $AE75 fd 75 fe
    LD (IY-$01),H                       ; $AE78 fd 74 ff
    PUSH HL                             ; $AE7B e5
    POP IY                              ; $AE7C fd e1
    RET                                 ; $AE7E c9
    LD HL,($A02B)                       ; $AE7F 2a 2b a0
    LD ($A029),HL                       ; $AE82 22 29 a0
    LD A,D                              ; $AE85 7a
    LD ($A02D),A                        ; $AE86 32 2d a0
    LD A,(HL)                           ; $AE89 7e
    LD D,A                              ; $AE8A 57
    LD BC,$0000                         ; $AE8B 01 00 00
    INC HL                              ; $AE8E 23
    CP $E0                              ; $AE8F fe e0
    JR Z,$AE9F                          ; $AE91 28 0c
    CP $F0                              ; $AE93 fe f0
    JR Z,$AE9F                          ; $AE95 28 08
    CP $90                              ; $AE97 fe 90
    JR Z,$AE9F                          ; $AE99 28 04
    CP $80                              ; $AE9B fe 80
    JR NC,$AEA4                         ; $AE9D 30 05
    LD A,(HL)                           ; $AE9F 7e
    LD B,A                              ; $AEA0 47
    INC HL                              ; $AEA1 23
    LD C,(HL)                           ; $AEA2 4e
    INC HL                              ; $AEA3 23
    LD ($A02B),HL                       ; $AEA4 22 2b a0
    LD A,D                              ; $AEA7 7a
    RET                                 ; $AEA8 c9
    PUSH HL                             ; $AEA9 e5
    LD L,(IY-$02)                       ; $AEAA fd 6e fe
    LD H,(IY-$01)                       ; $AEAD fd 66 ff
    LD A,H                              ; $AEB0 7c
    OR L                                ; $AEB1 b5
    EX (SP),HL                          ; $AEB2 e3
    POP IY                              ; $AEB3 fd e1
    RET                                 ; $AEB5 c9
    DEC B                               ; $AEB6 05
    PUSH IY                             ; $AEB7 fd e5
    POP IX                              ; $AEB9 dd e1
    CALL $AEA9                          ; $AEBB cd a9 ae
    BIT 6,(IY+$01)                      ; $AEBE fd cb 01 76
    JR NZ,$AEB7                         ; $AEC2 20 f3
    RET                                 ; $AEC4 c9
    DEC B                               ; $AEC5 05
    PUSH IY                             ; $AEC6 fd e5
    POP IX                              ; $AEC8 dd e1
    PUSH HL                             ; $AECA e5
    PUSH DE                             ; $AECB d5
    PUSH IY                             ; $AECC fd e5
    POP DE                              ; $AECE d1
    LD IY,$9FF0                         ; $AECF fd 21 f0 9f
    CALL $A104                          ; $AED3 cd 04 a1
    PUSH IY                             ; $AED6 fd e5
    POP HL                              ; $AED8 e1
    LD DE,$9FF2                         ; $AED9 11 f2 9f
    AND A                               ; $AEDC a7
    SBC HL,DE                           ; $AEDD ed 52
    JR Z,$AEE7                          ; $AEDF 28 06
    BIT 6,(IY+$01)                      ; $AEE1 fd cb 01 76
    JR NZ,$AECC                         ; $AEE5 20 e5
    POP DE                              ; $AEE7 d1
    POP HL                              ; $AEE8 e1
    RET                                 ; $AEE9 c9
    LD IY,$0000                         ; $AEEA fd 21 00 00
    JP $AEC6                            ; $AEEE c3 c6 ae
    EXX                                 ; $AEF1 d9
    LD A,(IX+$01)                       ; $AEF2 dd 7e 01
    AND $7F                             ; $AEF5 e6 7f
    OR (IY+$01)                         ; $AEF7 fd b6 01
    LD (IY+$01),A                       ; $AEFA fd 77 01
    LD A,(IX+$00)                       ; $AEFD dd 7e 00
    LD (IY+$00),A                       ; $AF00 fd 77 00
    EXX                                 ; $AF03 d9
    LD A,(IX+$04)                       ; $AF04 dd 7e 04
    OR (IX+$05)                         ; $AF07 dd b6 05
    RET Z                               ; $AF0A c8
    LD A,$0E                            ; $AF0B 3e 0e
    CALL $AF38                          ; $AF0D cd 38 af
    RET NZ                              ; $AF10 c0
    EXX                                 ; $AF11 d9
    PUSH IY                             ; $AF12 fd e5
    POP HL                              ; $AF14 e1
    LD DE,$0012                         ; $AF15 11 12 00
    ADD HL,DE                           ; $AF18 19
    PUSH HL                             ; $AF19 e5
    LD DE,$FFF6                         ; $AF1A 11 f6 ff
    ADD HL,DE                           ; $AF1D 19
    POP DE                              ; $AF1E d1
    LD BC,$0006                         ; $AF1F 01 06 00
    LDIR                                ; $AF22 ed b0
    LD DE,$0004                         ; $AF24 11 04 00
    CALL $AF52                          ; $AF27 cd 52 af
    LD A,(IY+$02)                       ; $AF2A fd 7e 02
    OR (IY+$03)                         ; $AF2D fd b6 03
    LD DE,$0002                         ; $AF30 11 02 00
    CALL Z,$AF56                        ; $AF33 cc 56 af
    EXX                                 ; $AF36 d9
    RET                                 ; $AF37 c9
    PUSH DE                             ; $AF38 d5
    PUSH BC                             ; $AF39 c5
    PUSH HL                             ; $AF3A e5
    LD B,$0A                            ; $AF3B 06 0a
    PUSH IY                             ; $AF3D fd e5
    POP HL                              ; $AF3F e1
    LD E,A                              ; $AF40 5f
    LD D,$00                            ; $AF41 16 00
    ADD HL,DE                           ; $AF43 19
    XOR A                               ; $AF44 af
    OR (HL)                             ; $AF45 b6
    INC HL                              ; $AF46 23
    DJNZ $AF45                          ; $AF47 10 fc
    POP HL                              ; $AF49 e1
    POP BC                              ; $AF4A c1
    POP DE                              ; $AF4B d1
    AND A                               ; $AF4C a7
    RET                                 ; $AF4D c9
    ORG $AF52
    LD C,$0A                            ; $AF52 0e 0a
    JR $AF58                            ; $AF54 18 02
    LD C,$02                            ; $AF56 0e 02
    PUSH IY                             ; $AF58 fd e5
    POP HL                              ; $AF5A e1
    ADD HL,DE                           ; $AF5B 19
    PUSH HL                             ; $AF5C e5
    PUSH IX                             ; $AF5D dd e5
    POP HL                              ; $AF5F e1
    ADD HL,DE                           ; $AF60 19
    POP DE                              ; $AF61 d1
    LD B,$00                            ; $AF62 06 00
    LDIR                                ; $AF64 ed b0
    RET                                 ; $AF66 c9
    LD A,$01                            ; $AF67 3e 01
    AND A                               ; $AF69 a7
    RET                                 ; $AF6A c9
    ORG $AFB3
    LD HL,$AF6B                         ; $AFB3 21 6b af
    LD A,($A024)                        ; $AFB6 3a 24 a0
    CP $02                              ; $AFB9 fe 02
    JR NZ,$AFC0                         ; $AFBB 20 03
    LD HL,$AF9B                         ; $AFBD 21 9b af
    PUSH DE                             ; $AFC0 d5
    LD E,$0C                            ; $AFC1 1e 0c
    JR NZ,$AFC7                         ; $AFC3 20 02
    LD E,$06                            ; $AFC5 1e 06
    LD A,(HL)                           ; $AFC7 7e
    INC HL                              ; $AFC8 23
    CP C                                ; $AFC9 b9
    JR NZ,$AFD0                         ; $AFCA 20 04
    LD A,(HL)                           ; $AFCC 7e
    CP B                                ; $AFCD b8
    JR Z,$AFDA                          ; $AFCE 28 0a
    INC HL                              ; $AFD0 23
    INC HL                              ; $AFD1 23
    INC HL                              ; $AFD2 23
    DEC E                               ; $AFD3 1d
    JR NZ,$AFC7                         ; $AFD4 20 f1
    POP DE                              ; $AFD6 d1
    JP $AF67                            ; $AFD7 c3 67 af
    INC HL                              ; $AFDA 23
    LD E,(HL)                           ; $AFDB 5e
    INC HL                              ; $AFDC 23
    LD D,(HL)                           ; $AFDD 56
    EX DE,HL                            ; $AFDE eb
    POP DE                              ; $AFDF d1
    JP (HL)                             ; $AFE0 e9
    ORG $B0AC
    LD HL,$0000                         ; $B0AC 21 00 00
    LD ($9FDD),HL                       ; $B0AF 22 dd 9f
    LD IX,$9860                         ; $B0B2 dd 21 60 98
    LD (IX+$06),L                       ; $B0B6 dd 75 06
    LD (IX+$07),H                       ; $B0B9 dd 74 07
    INC HL                              ; $B0BC 23
    LD ($A01F),HL                       ; $B0BD 22 1f a0
    LD A,L                              ; $B0C0 7d
    LD ($A0DA),A                        ; $B0C1 32 da a0
    AND A                               ; $B0C4 a7
    RET                                 ; $B0C5 c9
    ORG $B0D7
    CALL $B0EE                          ; $B0D7 cd ee b0
    CALL $C0DF                          ; $B0DA cd df c0
    JR NC,$B0D7                         ; $B0DD 30 f8
    LD IY,($9FD4)                       ; $B0DF fd 2a d4 9f
    RET                                 ; $B0E3 c9
    LD ($9FD4),IY                       ; $B0E4 fd 22 d4 9f
    CALL $B0EE                          ; $B0E8 cd ee b0
    JP $C040                            ; $B0EB c3 40 c0
    LD IX,$840B                         ; $B0EE dd 21 0b 84
    LD HL,$A01F                         ; $B0F2 21 1f a0
    LD DE,$840B                         ; $B0F5 11 0b 84
    AND A                               ; $B0F8 a7
    SBC HL,DE                           ; $B0F9 ed 52
    EX DE,HL                            ; $B0FB eb
    RET                                 ; $B0FC c9
    ORG $B191
    LD A,$FF                            ; $B191 3e ff
    LD ($A035),A                        ; $B193 32 35 a0
    LD ($A034),A                        ; $B196 32 34 a0
    LD HL,$B16D                         ; $B199 21 6d b1
    LD B,$11                            ; $B19C 06 11
    CALL $A2AB                          ; $B19E cd ab a2
    CALL $B39D                          ; $B1A1 cd 9d b3
    JR NZ,$B1AB                         ; $B1A4 20 05
    LD HL,$B84C                         ; $B1A6 21 4c b8
    XOR A                               ; $B1A9 af
    RET                                 ; $B1AA c9
    LD A,$01                            ; $B1AB 3e 01
    PUSH IX                             ; $B1AD dd e5
    POP HL                              ; $B1AF e1
    LD DE,$8259                         ; $B1B0 11 59 82
    SBC HL,DE                           ; $B1B3 ed 52
    JR Z,$B1BF                          ; $B1B5 28 08
    LD DE,$0008                         ; $B1B7 11 08 00
    INC A                               ; $B1BA 3c
    SBC HL,DE                           ; $B1BB ed 52
    JR NZ,$B1BA                         ; $B1BD 20 fb
    LD ($A033),A                        ; $B1BF 32 33 a0
    LD ($B18E),IX                       ; $B1C2 dd 22 8e b1
    CP $2E                              ; $B1C6 fe 2e
    JR NZ,$B1DD                         ; $B1C8 20 13
    LD HL,$B16D                         ; $B1CA 21 6d b1
    BIT 0,(HL)                          ; $B1CD cb 46
    LD HL,$A002                         ; $B1CF 21 02 a0
    LD DE,$B172                         ; $B1D2 11 72 b1
    LD BC,$0006                         ; $B1D5 01 06 00
    JR Z,$B1DB                          ; $B1D8 28 01
    EX DE,HL                            ; $B1DA eb
    LDIR                                ; $B1DB ed b0
    CALL $C493                          ; $B1DD cd 93 c4
    CALL $C4B2                          ; $B1E0 cd b2 c4
    LD A,($A01C)                        ; $B1E3 3a 1c a0
    AND A                               ; $B1E6 a7
    JR NZ,$B1F2                         ; $B1E7 20 09
    LD A,($B39C)                        ; $B1E9 3a 9c b3
    LD ($A01C),A                        ; $B1EC 32 1c a0
    CALL $B34F                          ; $B1EF cd 4f b3
    LD A,($A01E)                        ; $B1F2 3a 1e a0
    AND $10                             ; $B1F5 e6 10
    LD ($B190),A                        ; $B1F7 32 90 b1
    JR Z,$B200                          ; $B1FA 28 04
    XOR A                               ; $B1FC af
    LD ($A01C),A                        ; $B1FD 32 1c a0
    XOR A                               ; $B200 af
    LD ($A00B),A                        ; $B201 32 0b a0
    LD A,($A01D)                        ; $B204 3a 1d a0
    AND $0C                             ; $B207 e6 0c
    JR NZ,$B213                         ; $B209 20 08
    CALL $C929                          ; $B20B cd 29 c9
    RET NZ                              ; $B20E c0
    LD HL,$B863                         ; $B20F 21 63 b8
    RET                                 ; $B212 c9
    CALL $B387                          ; $B213 cd 87 b3
    JR NZ,$B280                         ; $B216 20 68
    LD A,($A01C)                        ; $B218 3a 1c a0
    AND A                               ; $B21B a7
    JR NZ,$B224                         ; $B21C 20 06
    CALL $B308                          ; $B21E cd 08 b3
    AND A                               ; $B221 a7
    JR Z,$B259                          ; $B222 28 35
    CALL $B4C1                          ; $B224 cd c1 b4
    JR Z,$B244                          ; $B227 28 1b
    CALL $C929                          ; $B229 cd 29 c9
    JR Z,$B224                          ; $B22C 28 f6
    LD A,($A034)                        ; $B22E 3a 34 a0
    LD ($B184),A                        ; $B231 32 84 b1
    LD HL,$B170                         ; $B234 21 70 b1
    INC (HL)                            ; $B237 34
    LD A,($B190)                        ; $B238 3a 90 b1
    AND A                               ; $B23B a7
    JR NZ,$B244                         ; $B23C 20 06
    LD A,($A01C)                        ; $B23E 3a 1c a0
    AND A                               ; $B241 a7
    JR Z,$B224                          ; $B242 28 e0
    LD A,($B184)                        ; $B244 3a 84 b1
    LD ($A034),A                        ; $B247 32 34 a0
    LD A,($B170)                        ; $B24A 3a 70 b1
    AND A                               ; $B24D a7
    JR Z,$B259                          ; $B24E 28 09
    CP $01                              ; $B250 fe 01
    JR Z,$B20B                          ; $B252 28 b7
    LD HL,$B5E2                         ; $B254 21 e2 b5
    XOR A                               ; $B257 af
    RET                                 ; $B258 c9
    LD A,($A033)                        ; $B259 3a 33 a0
    CP $2E                              ; $B25C fe 2e
    JR NZ,$B27B                         ; $B25E 20 1b
    LD A,($A01C)                        ; $B260 3a 1c a0
    AND A                               ; $B263 a7
    JR NZ,$B27B                         ; $B264 20 15
    LD HL,$B16D                         ; $B266 21 6d b1
    BIT 0,(HL)                          ; $B269 cb 46
    JR NZ,$B27B                         ; $B26B 20 0e
    LD HL,$0000                         ; $B26D 21 00 00
    LD ($B172),HL                       ; $B270 22 72 b1
    LD ($B174),HL                       ; $B273 22 74 b1
    LD ($B176),HL                       ; $B276 22 76 b1
    JR $B213                            ; $B279 18 98
    LD HL,$B65F                         ; $B27B 21 5f b6
    XOR A                               ; $B27E af
    RET                                 ; $B27F c9
    LD A,($A01C)                        ; $B280 3a 1c a0
    AND A                               ; $B283 a7
    JR NZ,$B292                         ; $B284 20 0c
    CALL $B308                          ; $B286 cd 08 b3
    AND A                               ; $B289 a7
    JR Z,$B259                          ; $B28A 28 cd
    CALL $B32D                          ; $B28C cd 2d b3
    AND A                               ; $B28F a7
    JR Z,$B303                          ; $B290 28 71
    CALL $B4C1                          ; $B292 cd c1 b4
    JR Z,$B2B7                          ; $B295 28 20
    CALL $B2DF                          ; $B297 cd df b2
    LD A,($B171)                        ; $B29A 3a 71 b1
    CP $01                              ; $B29D fe 01
    JR NZ,$B292                         ; $B29F 20 f1
    LD A,($A034)                        ; $B2A1 3a 34 a0
    LD ($B184),A                        ; $B2A4 32 84 b1
    LD HL,$B170                         ; $B2A7 21 70 b1
    INC (HL)                            ; $B2AA 34
    LD A,($B190)                        ; $B2AB 3a 90 b1
    AND A                               ; $B2AE a7
    JR NZ,$B2B7                         ; $B2AF 20 06
    LD A,($A01C)                        ; $B2B1 3a 1c a0
    AND A                               ; $B2B4 a7
    JR Z,$B292                          ; $B2B5 28 db
    LD A,($B184)                        ; $B2B7 3a 84 b1
    LD ($A034),A                        ; $B2BA 32 34 a0
    LD A,($B170)                        ; $B2BD 3a 70 b1
    AND A                               ; $B2C0 a7
    JR Z,$B259                          ; $B2C1 28 96
    CP $01                              ; $B2C3 fe 01
    JR NZ,$B2DA                         ; $B2C5 20 13
    CALL $B2DF                          ; $B2C7 cd df b2
    LD A,($B171)                        ; $B2CA 3a 71 b1
    AND A                               ; $B2CD a7
    JR Z,$B303                          ; $B2CE 28 33
    CP $01                              ; $B2D0 fe 01
    JP Z,$B20B                          ; $B2D2 ca 0b b2
    LD HL,$B5D3                         ; $B2D5 21 d3 b5
    XOR A                               ; $B2D8 af
    RET                                 ; $B2D9 c9
    LD HL,$B5E2                         ; $B2DA 21 e2 b5
    XOR A                               ; $B2DD af
    RET                                 ; $B2DE c9
    CALL $B36B                          ; $B2DF cd 6b b3
    CALL $B568                          ; $B2E2 cd 68 b5
    JR Z,$B2FC                          ; $B2E5 28 15
    CALL $C929                          ; $B2E7 cd 29 c9
    JR Z,$B2E2                          ; $B2EA 28 f6
    LD A,($A035)                        ; $B2EC 3a 35 a0
    LD ($B185),A                        ; $B2EF 32 85 b1
    LD HL,$B171                         ; $B2F2 21 71 b1
    INC (HL)                            ; $B2F5 34
    LD A,($B190)                        ; $B2F6 3a 90 b1
    AND A                               ; $B2F9 a7
    JR Z,$B2E2                          ; $B2FA 28 e6
    LD A,($B185)                        ; $B2FC 3a 85 b1
    LD ($A035),A                        ; $B2FF 32 35 a0
    RET                                 ; $B302 c9
    LD HL,$B6AE                         ; $B303 21 ae b6
    XOR A                               ; $B306 af
    RET                                 ; $B307 c9
    LD HL,($B17E)                       ; $B308 2a 7e b1
    PUSH HL                             ; $B30B e5
    LD A,($B4A2)                        ; $B30C 3a a2 b4
    PUSH AF                             ; $B30F f5
    CALL $B34F                          ; $B310 cd 4f b3
    CALL $B4C1                          ; $B313 cd c1 b4
    JR Z,$B31E                          ; $B316 28 06
    LD HL,$B170                         ; $B318 21 70 b1
    INC (HL)                            ; $B31B 34
    JR $B313                            ; $B31C 18 f5
    POP AF                              ; $B31E f1
    LD ($B4A2),A                        ; $B31F 32 a2 b4
    LD HL,$B170                         ; $B322 21 70 b1
    LD A,(HL)                           ; $B325 7e
    LD (HL),$00                         ; $B326 36 00
    POP HL                              ; $B328 e1
    LD ($B17E),HL                       ; $B329 22 7e b1
    RET                                 ; $B32C c9
    LD HL,($B180)                       ; $B32D 2a 80 b1
    PUSH HL                             ; $B330 e5
    CALL $B36B                          ; $B331 cd 6b b3
    LD A,($B549)                        ; $B334 3a 49 b5
    PUSH AF                             ; $B337 f5
    CALL $B568                          ; $B338 cd 68 b5
    JR Z,$B343                          ; $B33B 28 06
    LD HL,$B171                         ; $B33D 21 71 b1
    INC (HL)                            ; $B340 34
    JR $B338                            ; $B341 18 f5
    POP AF                              ; $B343 f1
    LD ($B549),A                        ; $B344 32 49 b5
    LD A,($B171)                        ; $B347 3a 71 b1
    POP HL                              ; $B34A e1
    LD ($B180),HL                       ; $B34B 22 80 b1
    RET                                 ; $B34E c9
    XOR A                               ; $B34F af
    LD ($B170),A                        ; $B350 32 70 b1
    LD A,$FF                            ; $B353 3e ff
    LD ($B4A2),A                        ; $B355 32 a2 b4
    CALL $D04F                          ; $B358 cd 4f d0
    LD A,($A00F)                        ; $B35B 3a 0f a0
    CP $07                              ; $B35E fe 07
    JR NC,$B366                         ; $B360 30 04
    LD IX,$0000                         ; $B362 dd 21 00 00
    LD ($B17E),IX                       ; $B366 dd 22 7e b1
    RET                                 ; $B36A c9
    XOR A                               ; $B36B af
    LD ($B171),A                        ; $B36C 32 71 b1
    LD A,$FF                            ; $B36F 3e ff
    LD ($B549),A                        ; $B371 32 49 b5
    CALL $D04F                          ; $B374 cd 4f d0
    LD A,($A010)                        ; $B377 3a 10 a0
    CP $07                              ; $B37A fe 07
    JR NC,$B382                         ; $B37C 30 04
    LD IX,$0000                         ; $B37E dd 21 00 00
    LD ($B180),IX                       ; $B382 dd 22 80 b1
    RET                                 ; $B386 c9
    LD A,($A01D)                        ; $B387 3a 1d a0
    BIT 2,A                             ; $B38A cb 57
    RET Z                               ; $B38C c8
    LD HL,$B16E                         ; $B38D 21 6e b1
    BIT 0,(HL)                          ; $B390 cb 46
    RET NZ                              ; $B392 c0
    BIT 1,A                             ; $B393 cb 4f
    JR NZ,$B39A                         ; $B395 20 03
    OR $01                              ; $B397 f6 01
    RET                                 ; $B399 c9
    XOR A                               ; $B39A af
    RET                                 ; $B39B c9
    ORG $B39D
    PUSH IY                             ; $B39D fd e5
    LD L,(IY+$00)                       ; $B39F fd 6e 00
    LD H,(IY+$01)                       ; $B3A2 fd 66 01
    LD A,H                              ; $B3A5 7c
    AND $80                             ; $B3A6 e6 80
    LD ($B39C),A                        ; $B3A8 32 9c b3
    RES 7,H                             ; $B3AB cb bc
    LD ($B186),HL                       ; $B3AD 22 86 b1
    LD L,(IY+$02)                       ; $B3B0 fd 6e 02
    LD H,(IY+$03)                       ; $B3B3 fd 66 03
    LD ($B18C),HL                       ; $B3B6 22 8c b1
    LD HL,$B188                         ; $B3B9 21 88 b1
    PUSH HL                             ; $B3BC e5
    LD B,$04                            ; $B3BD 06 04
    CALL $A2AB                          ; $B3BF cd ab a2
    POP HL                              ; $B3C2 e1
    LD B,$02                            ; $B3C3 06 02
    LD E,$04                            ; $B3C5 1e 04
    CALL $B483                          ; $B3C7 cd 83 b4
    LD E,$0E                            ; $B3CA 1e 0e
    CALL $B483                          ; $B3CC cd 83 b4
    LD E,$06                            ; $B3CF 1e 06
    CALL $B483                          ; $B3D1 cd 83 b4
    LD E,$10                            ; $B3D4 1e 10
    CALL $B483                          ; $B3D6 cd 83 b4
    XOR A                               ; $B3D9 af
    LD ($A02E),A                        ; $B3DA 32 2e a0
    LD HL,$B186                         ; $B3DD 21 86 b1
    LD DE,$0008                         ; $B3E0 11 08 00
    LD IX,$8259                         ; $B3E3 dd 21 59 82
    PUSH IX                             ; $B3E7 dd e5
    POP IY                              ; $B3E9 fd e1
    CALL $A4CD                          ; $B3EB cd cd a4
    JR Z,$B3FD                          ; $B3EE 28 0d
    ADD IX,DE                           ; $B3F0 dd 19
    LD A,(IX+$01)                       ; $B3F2 dd 7e 01
    OR (IX+$00)                         ; $B3F5 dd b6 00
    JR NZ,$B3E7                         ; $B3F8 20 ed
    POP IY                              ; $B3FA fd e1
    RET                                 ; $B3FC c9
    POP IY                              ; $B3FD fd e1
    CALL $B405                          ; $B3FF cd 05 b4
    OR $01                              ; $B402 f6 01
    RET                                 ; $B404 c9
    AND A                               ; $B405 a7
    JR Z,$B416                          ; $B406 28 0e
    LD HL,($B188)                       ; $B408 2a 88 b1
    LD DE,($B18A)                       ; $B40B ed 5b 8a b1
    LD ($B188),DE                       ; $B40F ed 53 88 b1
    LD ($B18A),HL                       ; $B413 22 8a b1
    CALL $A2BD                          ; $B416 cd bd a2
    LD HL,$B188                         ; $B419 21 88 b1
    LD A,(HL)                           ; $B41C 7e
    INC HL                              ; $B41D 23
    OR (HL)                             ; $B41E b6
    JR NZ,$B426                         ; $B41F 20 05
    LD A,($A01E)                        ; $B421 3a 1e a0
    JR $B445                            ; $B424 18 1f
    DEC HL                              ; $B426 2b
    LD A,(HL)                           ; $B427 7e
    CP (IY+$0E)                         ; $B428 fd be 0e
    JR NZ,$B435                         ; $B42B 20 08
    INC HL                              ; $B42D 23
    LD A,(HL)                           ; $B42E 7e
    CP (IY+$0F)                         ; $B42F fd be 0f
    JR Z,$B440                          ; $B432 28 0c
    DEC HL                              ; $B434 2b
    LD A,(HL)                           ; $B435 7e
    CP (IY+$10)                         ; $B436 fd be 10
    JR NZ,$B440                         ; $B439 20 05
    INC HL                              ; $B43B 23
    LD A,(HL)                           ; $B43C 7e
    CP (IY+$11)                         ; $B43D fd be 11
    LD A,($A01D)                        ; $B440 3a 1d a0
    JR NZ,$B447                         ; $B443 20 02
    XOR $20                             ; $B445 ee 20
    BIT 5,A                             ; $B447 cb 6f
    LD BC,$1208                         ; $B449 01 08 12
    JR Z,$B451                          ; $B44C 28 03
    LD BC,$0812                         ; $B44E 01 12 08
    LD HL,$B182                         ; $B451 21 82 b1
    LD (HL),B                           ; $B454 70
    INC HL                              ; $B455 23
    LD (HL),C                           ; $B456 71
    LD A,B                              ; $B457 78
    LD DE,$B172                         ; $B458 11 72 b1
    LD HL,$B16D                         ; $B45B 21 6d b1
    CALL $B468                          ; $B45E cd 68 b4
    LD A,C                              ; $B461 79
    LD DE,$B178                         ; $B462 11 78 b1
    LD HL,$B16E                         ; $B465 21 6e b1
    PUSH BC                             ; $B468 c5
    LD C,A                              ; $B469 4f
    LD B,$00                            ; $B46A 06 00
    PUSH HL                             ; $B46C e5
    PUSH IY                             ; $B46D fd e5
    POP HL                              ; $B46F e1
    ADD HL,BC                           ; $B470 09
    LD BC,$0006                         ; $B471 01 06 00
    LDIR                                ; $B474 ed b0
    XOR A                               ; $B476 af
    LD B,$06                            ; $B477 06 06
    DEC HL                              ; $B479 2b
    OR (HL)                             ; $B47A b6
    DJNZ $B479                          ; $B47B 10 fc
    POP HL                              ; $B47D e1
    POP BC                              ; $B47E c1
    RET Z                               ; $B47F c8
    SET 0,(HL)                          ; $B480 cb c6
    RET                                 ; $B482 c9
    XOR A                               ; $B483 af
    CP B                                ; $B484 b8
    RET Z                               ; $B485 c8
    LD D,$00                            ; $B486 16 00
    PUSH IY                             ; $B488 fd e5
    ADD IY,DE                           ; $B48A fd 19
    LD A,(IY+$00)                       ; $B48C fd 7e 00
    LD (HL),A                           ; $B48F 77
    INC HL                              ; $B490 23
    LD A,(IY+$01)                       ; $B491 fd 7e 01
    LD (HL),A                           ; $B494 77
    DEC HL                              ; $B495 2b
    OR (IY+$00)                         ; $B496 fd b6 00
    POP IY                              ; $B499 fd e1
    RET Z                               ; $B49B c8
    DEC B                               ; $B49C 05
    INC HL                              ; $B49D 23
    INC HL                              ; $B49E 23
    RET                                 ; $B49F c9
    JP (IY)                             ; $B4A0 fd e9
    ORG $B4A3
    LD A,($B4A2)                        ; $B4A3 3a a2 b4
    INC A                               ; $B4A6 3c
    JR NZ,$B4CF                         ; $B4A7 20 26
    LD ($B4A2),A                        ; $B4A9 32 a2 b4
    LD A,($B173)                        ; $B4AC 3a 73 b1
    BIT 7,A                             ; $B4AF cb 7f
    JR Z,$B4CF                          ; $B4B1 28 1c
    LD A,$FE                            ; $B4B3 3e fe
    LD ($A034),A                        ; $B4B5 32 34 a0
    LD HL,($B172)                       ; $B4B8 2a 72 b1
    LD ($A02F),HL                       ; $B4BB 22 2f a0
    OR $01                              ; $B4BE f6 01
    RET                                 ; $B4C0 c9
    LD A,($A00F)                        ; $B4C1 3a 0f a0
    CP $05                              ; $B4C4 fe 05
    JR Z,$B4A3                          ; $B4C6 28 db
    LD A,($B173)                        ; $B4C8 3a 73 b1
    BIT 7,A                             ; $B4CB cb 7f
    JR Z,$B4D4                          ; $B4CD 28 05
    LD A,$FF                            ; $B4CF 3e ff
    CP $FF                              ; $B4D1 fe ff
    RET                                 ; $B4D3 c9
    PUSH IY                             ; $B4D4 fd e5
    LD IX,($B17E)                       ; $B4D6 dd 2a 7e b1
    LD A,($A01D)                        ; $B4DA 3a 1d a0
    AND $01                             ; $B4DD e6 01
    LD ($A038),A                        ; $B4DF 32 38 a0
    LD A,($A00F)                        ; $B4E2 3a 0f a0
    CP $05                              ; $B4E5 fe 05
    LD IY,$D39B                         ; $B4E7 fd 21 9b d3
    JR C,$B4F1                          ; $B4EB 38 04
    LD IY,$D36A                         ; $B4ED fd 21 6a d3
    CALL $B4FD                          ; $B4F1 cd fd b4
    CP $FF                              ; $B4F4 fe ff
    LD ($B17E),IX                       ; $B4F6 dd 22 7e b1
    POP IY                              ; $B4FA fd e1
    RET                                 ; $B4FC c9
    LD HL,$B172                         ; $B4FD 21 72 b1
    CALL $B4A0                          ; $B500 cd a0 b4
    CP $FF                              ; $B503 fe ff
    RET Z                               ; $B505 c8
    LD ($A034),A                        ; $B506 32 34 a0
    CALL $B517                          ; $B509 cd 17 b5
    JR NZ,$B4FD                         ; $B50C 20 ef
    LD A,($A034)                        ; $B50E 3a 34 a0
    LD HL,$B16D                         ; $B511 21 6d b1
    SET 1,(HL)                          ; $B514 cb ce
    RET                                 ; $B516 c9
    LD A,($A01C)                        ; $B517 3a 1c a0
    AND A                               ; $B51A a7
    RET Z                               ; $B51B c8
    PUSH IY                             ; $B51C fd e5
    PUSH DE                             ; $B51E d5
    PUSH IX                             ; $B51F dd e5
    CALL $AEA9                          ; $B521 cd a9 ae
    BIT 6,(IY+$01)                      ; $B524 fd cb 01 76
    JR Z,$B543                          ; $B528 28 19
    CALL $D04F                          ; $B52A cd 4f d0
    PUSH IY                             ; $B52D fd e5
    POP HL                              ; $B52F e1
    LD DE,$0008                         ; $B530 11 08 00
    ADD HL,DE                           ; $B533 19
    CALL $D36A                          ; $B534 cd 6a d3
    CP $FF                              ; $B537 fe ff
    JR Z,$B521                          ; $B539 28 e6
    LD HL,$A034                         ; $B53B 21 34 a0
    CP (HL)                             ; $B53E be
    JR NZ,$B52D                         ; $B53F 20 ec
    OR $01                              ; $B541 f6 01
    POP IX                              ; $B543 dd e1
    POP DE                              ; $B545 d1
    POP IY                              ; $B546 fd e1
    RET                                 ; $B548 c9
    ORG $B54A
    LD A,($B549)                        ; $B54A 3a 49 b5
    INC A                               ; $B54D 3c
    JR NZ,$B576                         ; $B54E 20 26
    LD ($B549),A                        ; $B550 32 49 b5
    LD A,($B179)                        ; $B553 3a 79 b1
    BIT 7,A                             ; $B556 cb 7f
    JR Z,$B576                          ; $B558 28 1c
    LD A,$FE                            ; $B55A 3e fe
    LD ($A035),A                        ; $B55C 32 35 a0
    LD HL,($B178)                       ; $B55F 2a 78 b1
    LD ($A031),HL                       ; $B562 22 31 a0
    OR $01                              ; $B565 f6 01
    RET                                 ; $B567 c9
    LD A,($A010)                        ; $B568 3a 10 a0
    CP $05                              ; $B56B fe 05
    JR Z,$B54A                          ; $B56D 28 db
    LD A,($B179)                        ; $B56F 3a 79 b1
    BIT 7,A                             ; $B572 cb 7f
    JR Z,$B57B                          ; $B574 28 05
    LD A,$FF                            ; $B576 3e ff
    CP $FF                              ; $B578 fe ff
    RET                                 ; $B57A c9
    PUSH IY                             ; $B57B fd e5
    LD IX,($B180)                       ; $B57D dd 2a 80 b1
    LD A,($A01D)                        ; $B581 3a 1d a0
    AND $01                             ; $B584 e6 01
    LD ($A038),A                        ; $B586 32 38 a0
    LD A,($A010)                        ; $B589 3a 10 a0
    CP $05                              ; $B58C fe 05
    LD IY,$D39B                         ; $B58E fd 21 9b d3
    JR C,$B598                          ; $B592 38 04
    LD IY,$D36A                         ; $B594 fd 21 6a d3
    CALL $B5A4                          ; $B598 cd a4 b5
    CP $FF                              ; $B59B fe ff
    LD ($B180),IX                       ; $B59D dd 22 80 b1
    POP IY                              ; $B5A1 fd e1
    RET                                 ; $B5A3 c9
    LD HL,$B178                         ; $B5A4 21 78 b1
    CALL $B4A0                          ; $B5A7 cd a0 b4
    CP $FF                              ; $B5AA fe ff
    RET Z                               ; $B5AC c8
    LD ($A035),A                        ; $B5AD 32 35 a0
    LD HL,$B16E                         ; $B5B0 21 6e b1
    SET 1,(HL)                          ; $B5B3 cb ce
    RET                                 ; $B5B5 c9
    ORG $B86A
    PUSH AF                             ; $B86A f5
    LD IX,$9FEE                         ; $B86B dd 21 ee 9f
    CALL $A0F7                          ; $B86F cd f7 a0
    JR Z,$B8A8                          ; $B872 28 34
    LD C,(IX+$00)                       ; $B874 dd 4e 00
    LD B,(IX+$01)                       ; $B877 dd 46 01
    LD ($B868),BC                       ; $B87A ed 43 68 b8
    LD L,(IX-$02)                       ; $B87E dd 6e fe
    LD H,(IX-$01)                       ; $B881 dd 66 ff
    LD ($9FEC),HL                       ; $B884 22 ec 9f
    CALL $A1C7                          ; $B887 cd c7 a1
    POP AF                              ; $B88A f1
    PUSH AF                             ; $B88B f5
    AND A                               ; $B88C a7
    JR Z,$B894                          ; $B88D 28 05
    CALL $B8AA                          ; $B88F cd aa b8
    JR Z,$B8A8                          ; $B892 28 14
    LD BC,($B868)                       ; $B894 ed 4b 68 b8
    LD ($A02B),BC                       ; $B898 ed 43 2b a0
    CALL $AE7F                          ; $B89C cd 7f ae
    CP $C0                              ; $B89F fe c0
    JR NZ,$B89C                         ; $B8A1 20 f9
    LD HL,($A029)                       ; $B8A3 2a 29 a0
    LD (HL),$90                         ; $B8A6 36 90
    POP AF                              ; $B8A8 f1
    RET                                 ; $B8A9 c9
    LD HL,($B868)                       ; $B8AA 2a 68 b8
    LD ($A02B),HL                       ; $B8AD 22 2b a0
    XOR A                               ; $B8B0 af
    LD ($A024),A                        ; $B8B1 32 24 a0
    LD HL,($9FF0)                       ; $B8B4 2a f0 9f
    PUSH HL                             ; $B8B7 e5
    LD HL,$0000                         ; $B8B8 21 00 00
    LD ($9FF0),HL                       ; $B8BB 22 f0 9f
    CALL $AAB2                          ; $B8BE cd b2 aa
    JR Z,$B8C7                          ; $B8C1 28 04
    CP $02                              ; $B8C3 fe 02
    JR NZ,$B904                         ; $B8C5 20 3d
    LD HL,($A02B)                       ; $B8C7 2a 2b a0
    LD A,(HL)                           ; $B8CA 7e
    AND $F0                             ; $B8CB e6 f0
    CP $C0                              ; $B8CD fe c0
    JR NZ,$B8BE                         ; $B8CF 20 ed
    LD (HL),$90                         ; $B8D1 36 90
    LD A,$08                            ; $B8D3 3e 08
    CALL $A11C                          ; $B8D5 cd 1c a1
    LD HL,($9FEE)                       ; $B8D8 2a ee 9f
    LD ($9FEE),IX                       ; $B8DB dd 22 ee 9f
    LD (IX-$02),L                       ; $B8DF dd 75 fe
    LD (IX-$01),H                       ; $B8E2 dd 74 ff
    LD HL,($9FF0)                       ; $B8E5 2a f0 9f
    LD (IX+$05),L                       ; $B8E8 dd 75 05
    LD (IX+$06),H                       ; $B8EB dd 74 06
    POP HL                              ; $B8EE e1
    LD ($9FF0),HL                       ; $B8EF 22 f0 9f
    XOR A                               ; $B8F2 af
    LD (IX+$01),A                       ; $B8F3 dd 77 01
    LD A,($A034)                        ; $B8F6 3a 34 a0
    LD (IX+$00),A                       ; $B8F9 dd 77 00
    LD A,($A024)                        ; $B8FC 3a 24 a0
    LD (IX+$07),A                       ; $B8FF dd 77 07
    XOR A                               ; $B902 af
    RET                                 ; $B903 c9
    PUSH AF                             ; $B904 f5
    CALL $D87D                          ; $B905 cd 7d d8
    POP AF                              ; $B908 f1
    POP HL                              ; $B909 e1
    LD ($9FF0),HL                       ; $B90A 22 f0 9f
    RET                                 ; $B90D c9
    CALL $B91F                          ; $B90E cd 1f b9
    LD ($B866),IX                       ; $B911 dd 22 66 b8
    LD E,(IX+$05)                       ; $B915 dd 5e 05
    LD D,(IX+$06)                       ; $B918 dd 56 06
    PUSH DE                             ; $B91B d5
    POP IY                              ; $B91C fd e1
    RET                                 ; $B91E c9
    LD IX,$9FF0                         ; $B91F dd 21 f0 9f
    CALL $A0F7                          ; $B923 cd f7 a0
    JR Z,$B931                          ; $B926 28 09
    LD A,($A036)                        ; $B928 3a 36 a0
    CP (IX+$00)                         ; $B92B dd be 00
    RET Z                               ; $B92E c8
    JR $B923                            ; $B92F 18 f2
    OR $01                              ; $B931 f6 01
    RET                                 ; $B933 c9
    ORG $B936
    PUSH IX                             ; $B936 dd e5
    PUSH IY                             ; $B938 fd e5
    PUSH HL                             ; $B93A e5
    LD ($B935),A                        ; $B93B 32 35 b9
    CALL $B90E                          ; $B93E cd 0e b9
    LD A,(IX+$07)                       ; $B941 dd 7e 07
    CP $02                              ; $B944 fe 02
    JP Z,$BA20                          ; $B946 ca 20 ba
    LD A,(IX+$01)                       ; $B949 dd 7e 01
    CP $FF                              ; $B94C fe ff
    JR Z,$B98C                          ; $B94E 28 3c
    LD A,($B935)                        ; $B950 3a 35 b9
    LD ($B934),A                        ; $B953 32 34 b9
    LD A,(IX+$02)                       ; $B956 dd 7e 02
    LD ($A01C),A                        ; $B959 32 1c a0
    LD C,(IX+$03)                       ; $B95C dd 4e 03
    LD B,(IX+$04)                       ; $B95F dd 46 04
    LD ($B17E),BC                       ; $B962 ed 43 7e b1
    CALL $B191                          ; $B966 cd 91 b1
    JR Z,$B9B4                          ; $B969 28 49
    LD IX,($B866)                       ; $B96B dd 2a 66 b8
    LD BC,($B17E)                       ; $B96F ed 4b 7e b1
    LD (IX+$03),C                       ; $B973 dd 71 03
    LD (IX+$04),B                       ; $B976 dd 70 04
    LD A,($A01C)                        ; $B979 3a 1c a0
    LD (IX+$02),A                       ; $B97C dd 77 02
    AND A                               ; $B97F a7
    CALL Z,$B9CA                        ; $B980 cc ca b9
    LD A,$01                            ; $B983 3e 01
    POP HL                              ; $B985 e1
    POP IY                              ; $B986 fd e1
    POP IX                              ; $B988 dd e1
    AND A                               ; $B98A a7
    RET                                 ; $B98B c9
    LD A,(IX+$02)                       ; $B98C dd 7e 02
    CALL $CEDE                          ; $B98F cd de ce
    LD ($A033),A                        ; $B992 32 33 a0
    LD A,(IX+$03)                       ; $B995 dd 7e 03
    CALL $CEDE                          ; $B998 cd de ce
    LD ($A034),A                        ; $B99B 32 34 a0
    LD A,(IX+$04)                       ; $B99E dd 7e 04
    CALL $CEDE                          ; $B9A1 cd de ce
    LD ($A035),A                        ; $B9A4 32 35 a0
    CALL $B9FA                          ; $B9A7 cd fa b9
    JR $B983                            ; $B9AA 18 d7
    CALL $B9CA                          ; $B9AC cd ca b9
    JR NZ,$B9AC                         ; $B9AF 20 fb
    XOR A                               ; $B9B1 af
    JR $B985                            ; $B9B2 18 d1
    LD A,($A01C)                        ; $B9B4 3a 1c a0
    AND A                               ; $B9B7 a7
    JR Z,$B9AC                          ; $B9B8 28 f2
    LD IX,($B866)                       ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                     ; $B9BE dd 36 02 00
    CALL $B9CA                          ; $B9C2 cd ca b9
    JR Z,$B9B1                          ; $B9C5 28 ea
    JP $B93E                            ; $B9C7 c3 3e b9
    LD IX,($B866)                       ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                       ; $B9CE fd 6e fe
    LD H,(IY-$01)                       ; $B9D1 fd 66 ff
    LD (IX+$05),L                       ; $B9D4 dd 75 05
    LD (IX+$06),H                       ; $B9D7 dd 74 06
    PUSH IX                             ; $B9DA dd e5
    PUSH IY                             ; $B9DC fd e5
    POP IX                              ; $B9DE dd e1
    CALL $A1C7                          ; $B9E0 cd c7 a1
    POP IX                              ; $B9E3 dd e1
    LD A,L                              ; $B9E5 7d
    OR H                                ; $B9E6 b4
    JR Z,$B9F5                          ; $B9E7 28 0c
    PUSH HL                             ; $B9E9 e5
    POP IY                              ; $B9EA fd e1
    BIT 6,(IY+$01)                      ; $B9EC fd cb 01 76
    JR NZ,$B9CE                         ; $B9F0 20 dc
    OR $01                              ; $B9F2 f6 01
    RET                                 ; $B9F4 c9
    CALL $B9FA                          ; $B9F5 cd fa b9
    XOR A                               ; $B9F8 af
    RET                                 ; $B9F9 c9
    LD IY,$9FEE                         ; $B9FA fd 21 ee 9f
    PUSH IX                             ; $B9FE dd e5
    POP DE                              ; $BA00 d1
    CALL $A104                          ; $BA01 cd 04 a1
    LD L,(IX-$02)                       ; $BA04 dd 6e fe
    LD H,(IX-$01)                       ; $BA07 dd 66 ff
    LD (IY-$02),L                       ; $BA0A fd 75 fe
    LD (IY-$01),H                       ; $BA0D fd 74 ff
    JP $A1C7                            ; $BA10 c3 c7 a1
    ORG $BA20
    LD A,($A036)                        ; $BA20 3a 36 a0
    LD HL,$BA67                         ; $BA23 21 67 ba
    CP $03                              ; $BA26 fe 03
    JR Z,$BA31                          ; $BA28 28 07
    LD HL,$BB67                         ; $BA2A 21 67 bb
    CP $02                              ; $BA2D fe 02
    JR NZ,$BA34                         ; $BA2F 20 03
    CALL $BA3E                          ; $BA31 cd 3e ba
    LD A,$01                            ; $BA34 3e 01
    POP HL                              ; $BA36 e1
    POP IY                              ; $BA37 fd e1
    POP IX                              ; $BA39 dd e1
    AND A                               ; $BA3B a7
    SCF                                 ; $BA3C 37
    RET                                 ; $BA3D c9
    PUSH IX                             ; $BA3E dd e5
    XOR A                               ; $BA40 af
    LD ($9FEB),A                        ; $BA41 32 eb 9f
    LD E,(IX+$05)                       ; $BA44 dd 5e 05
    LD D,(IX+$06)                       ; $BA47 dd 56 06
    PUSH DE                             ; $BA4A d5
    PUSH DE                             ; $BA4B d5
    POP IY                              ; $BA4C fd e1
    CALL $D1DB                          ; $BA4E cd db d1
    POP IX                              ; $BA51 dd e1
    PUSH AF                             ; $BA53 f5
    CALL $A1AF                          ; $BA54 cd af a1
    POP AF                              ; $BA57 f1
    POP IX                              ; $BA58 dd e1
    PUSH AF                             ; $BA5A f5
    CALL $B9FA                          ; $BA5B cd fa b9
    POP AF                              ; $BA5E f1
    RET                                 ; $BA5F c9
    ORG $BBE5
    PUSH AF                             ; $BBE5 f5
    LD HL,$67FF                         ; $BBE6 21 ff 67
    CALL $A59F                          ; $BBE9 cd 9f a5
    POP AF                              ; $BBEC f1
    CP $01                              ; $BBED fe 01
    LD HL,$72D6                         ; $BBEF 21 d6 72
    CALL NZ,$A59F                       ; $BBF2 c4 9f a5
    BIT 4,(IX+$03)                      ; $BBF5 dd cb 03 66
    JR Z,$BC1A                          ; $BBF9 28 1f
    RES 1,(IX+$03)                      ; $BBFB dd cb 03 8e
    PUSH IX                             ; $BBFF dd e5
    LD HL,$72E1                         ; $BC01 21 e1 72
    CALL $A59F                          ; $BC04 cd 9f a5
    LD L,(IX+$04)                       ; $BC07 dd 6e 04
    LD H,(IX+$05)                       ; $BC0A dd 66 05
    LD A,L                              ; $BC0D 7d
    OR H                                ; $BC0E b4
    JP NZ,$A59F                         ; $BC0F c2 9f a5
    LD A,$22                            ; $BC12 3e 22
    CALL $A9B7                          ; $BC14 cd b7 a9
    JP $A414                            ; $BC17 c3 14 a4
    LD L,(IX+$04)                       ; $BC1A dd 6e 04
    LD H,(IX+$05)                       ; $BC1D dd 66 05
    JP (HL)                             ; $BC20 e9
    ORG $BC46
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
    BIT 2,(IX+$03)                      ; $BCC9 dd cb 03 56
    JR Z,$BCDA                          ; $BCCD 28 0b
    PUSH IX                             ; $BCCF dd e5
    PUSH BC                             ; $BCD1 c5
    CALL $BF08                          ; $BCD2 cd 08 bf
    POP BC                              ; $BCD5 c1
    POP IX                              ; $BCD6 dd e1
    JR Z,$BD03                          ; $BCD8 28 29
    BIT 5,(IX+$03)                      ; $BCDA dd cb 03 6e
    JR Z,$BCE6                          ; $BCDE 28 06
    SET 0,(IX+$03)                      ; $BCE0 dd cb 03 c6
    JR $BD01                            ; $BCE4 18 1b
    SET 1,(IX+$03)                      ; $BCE6 dd cb 03 ce
    RES 0,(IX+$03)                      ; $BCEA dd cb 03 86
    BIT 4,(IX+$03)                      ; $BCEE dd cb 03 66
    JR Z,$BD01                          ; $BCF2 28 0d
    LD L,(IX+$04)                       ; $BCF4 dd 6e 04
    LD H,(IX+$05)                       ; $BCF7 dd 66 05
    PUSH IX                             ; $BCFA dd e5
    CALL $D1DB                          ; $BCFC cd db d1
    POP IX                              ; $BCFF dd e1
    XOR A                               ; $BD01 af
    RET                                 ; $BD02 c9
    OR $01                              ; $BD03 f6 01
    RET                                 ; $BD05 c9
    ORG $BE5A
    PUSH AF                             ; $BE5A f5
    LD DE,$0002                         ; $BE5B 11 02 00
    ADD IX,DE                           ; $BE5E dd 19
    ADD IX,DE                           ; $BE60 dd 19
    BIT 5,(IX-$01)                      ; $BE62 dd cb ff 6e
    JR NZ,$BE6E                         ; $BE66 20 06
    BIT 4,(IX-$01)                      ; $BE68 dd cb ff 66
    JR Z,$BE70                          ; $BE6C 28 02
    ADD IX,DE                           ; $BE6E dd 19
    POP AF                              ; $BE70 f1
    RET                                 ; $BE71 c9
    PUSH AF                             ; $BE72 f5
    LD B,$00                            ; $BE73 06 00
    LD C,(IX+$03)                       ; $BE75 dd 4e 03
    CALL $BE5A                          ; $BE78 cd 5a be
    BIT 3,C                             ; $BE7B cb 59
    JR Z,$BE84                          ; $BE7D 28 05
    LD A,B                              ; $BE7F 78
    AND A                               ; $BE80 a7
    JR Z,$BE84                          ; $BE81 28 01
    DEC B                               ; $BE83 05
    BIT 2,C                             ; $BE84 cb 51
    JR Z,$BE8B                          ; $BE86 28 03
    INC B                               ; $BE88 04
    JR $BE75                            ; $BE89 18 ea
    LD A,B                              ; $BE8B 78
    AND A                               ; $BE8C a7
    JR NZ,$BE75                         ; $BE8D 20 e6
    POP AF                              ; $BE8F f1
    RET                                 ; $BE90 c9
    BIT 1,(IX+$03)                      ; $BE91 dd cb 03 4e
    JR NZ,$BE72                         ; $BE95 20 db
    LD A,(IX+$03)                       ; $BE97 dd 7e 03
    AND $C0                             ; $BE9A e6 c0
    CP $00                              ; $BE9C fe 00
    JR NZ,$BECD                         ; $BE9E 20 2d
    LD A,(IX+$00)                       ; $BEA0 dd 7e 00
    PUSH IX                             ; $BEA3 dd e5
    CALL $D237                          ; $BEA5 cd 37 d2
    BIT 7,(IX+$06)                      ; $BEA8 dd cb 06 7e
    POP IX                              ; $BEAC dd e1
    JR Z,$BE72                          ; $BEAE 28 c2
    LD A,(IX+$02)                       ; $BEB0 dd 7e 02
    PUSH IX                             ; $BEB3 dd e5
    CALL $D237                          ; $BEB5 cd 37 d2
    BIT 7,(IX+$06)                      ; $BEB8 dd cb 06 7e
    POP IX                              ; $BEBC dd e1
    JR Z,$BE72                          ; $BEBE 28 b2
    SET 1,(IX+$03)                      ; $BEC0 dd cb 03 ce
    RES 0,(IX+$03)                      ; $BEC4 dd cb 03 86
    OR $01                              ; $BEC8 f6 01
    JP $BE72                            ; $BECA c3 72 be
    CP $80                              ; $BECD fe 80
    JR Z,$BE72                          ; $BECF 28 a1
    CP $40                              ; $BED1 fe 40
    JR NZ,$BEF6                         ; $BED3 20 21
    LD A,(IX+$00)                       ; $BED5 dd 7e 00
    PUSH IX                             ; $BED8 dd e5
    CALL $D237                          ; $BEDA cd 37 d2
    BIT 6,(IX+$06)                      ; $BEDD dd cb 06 76
    POP IX                              ; $BEE1 dd e1
    JR Z,$BE72                          ; $BEE3 28 8d
    LD A,(IX+$02)                       ; $BEE5 dd 7e 02
    PUSH IX                             ; $BEE8 dd e5
    CALL $D237                          ; $BEEA cd 37 d2
    BIT 6,(IX+$06)                      ; $BEED dd cb 06 76
    POP IX                              ; $BEF1 dd e1
    JP Z,$BE72                          ; $BEF3 ca 72 be
    BIT 2,(IX+$03)                      ; $BEF6 dd cb 03 56
    JR Z,$BEC0                          ; $BEFA 28 c4
    PUSH IX                             ; $BEFC dd e5
    CALL $BF08                          ; $BEFE cd 08 bf
    POP IX                              ; $BF01 dd e1
    JR NZ,$BEC0                         ; $BF03 20 bb
    JP $BE72                            ; $BF05 c3 72 be
    CALL $BE5A                          ; $BF08 cd 5a be
    BIT 3,(IX+$03)                      ; $BF0B dd cb 03 5e
    PUSH AF                             ; $BF0F f5
    CALL $BE91                          ; $BF10 cd 91 be
    JR NZ,$BF18                         ; $BF13 20 03
    POP AF                              ; $BF15 f1
    XOR A                               ; $BF16 af
    RET                                 ; $BF17 c9
    POP AF                              ; $BF18 f1
    JR Z,$BF0B                          ; $BF19 28 f0
    RET                                 ; $BF1B c9
    LD A,(IX+$00)                       ; $BF1C dd 7e 00
    CALL $A4BC                          ; $BF1F cd bc a4
    PUSH HL                             ; $BF22 e5
    POP IY                              ; $BF23 fd e1
    CALL $D3E8                          ; $BF25 cd e8 d3
    CALL $BF45                          ; $BF28 cd 45 bf
    JR Z,$BF3D                          ; $BF2B 28 10
    CALL $A887                          ; $BF2D cd 87 a8
    LD A,(IX+$02)                       ; $BF30 dd 7e 02
    CALL $A4BC                          ; $BF33 cd bc a4
    PUSH HL                             ; $BF36 e5
    POP IY                              ; $BF37 fd e1
    CALL $D3E8                          ; $BF39 cd e8 d3
    RET                                 ; $BF3C c9
    LD DE,$005D                         ; $BF3D 11 5d 00
    CALL $A887                          ; $BF40 cd 87 a8
    JR $BF30                            ; $BF43 18 eb
    LD A,(IX+$01)                       ; $BF45 dd 7e 01
    AND A                               ; $BF48 a7
    RET Z                               ; $BF49 c8
    DEC A                               ; $BF4A 3d
    LD E,A                              ; $BF4B 5f
    LD D,$00                            ; $BF4C 16 00
    LD HL,$994D                         ; $BF4E 21 4d 99
    ADD HL,DE                           ; $BF51 19
    ADD HL,DE                           ; $BF52 19
    LD E,(HL)                           ; $BF53 5e
    INC HL                              ; $BF54 23
    LD D,(HL)                           ; $BF55 56
    OR $01                              ; $BF56 f6 01
    RET                                 ; $BF58 c9
    ORG $BF79
    LD IX,$BF6E                         ; $BF79 dd 21 6e bf
    LD A,($9FE1)                        ; $BF7D 3a e1 9f
    LD HL,$BF59                         ; $BF80 21 59 bf
    CALL $BFC6                          ; $BF83 cd c6 bf
    INC IX                              ; $BF86 dd 23
    LD A,($9FE0)                        ; $BF88 3a e0 9f
    CALL $BFB0                          ; $BF8B cd b0 bf
    INC IX                              ; $BF8E dd 23
    LD A,($9FDF)                        ; $BF90 3a df 9f
    CALL $BFB0                          ; $BF93 cd b0 bf
    LD A,($9FE2)                        ; $BF96 3a e2 9f
    LD (IX+$00),A                       ; $BF99 dd 77 00
    LD HL,$BF6E                         ; $BF9C 21 6e bf
    LD B,$0B                            ; $BF9F 06 0b
    JP $C1A8                            ; $BFA1 c3 a8 c1
    CALL $BFAA                          ; $BFA4 cd aa bf
    LD A,L                              ; $BFA7 7d
    ADD A,$30                           ; $BFA8 c6 30
    LD (IX+$00),A                       ; $BFAA dd 77 00
    INC IX                              ; $BFAD dd 23
    RET                                 ; $BFAF c9
    LD L,A                              ; $BFB0 6f
    LD H,$00                            ; $BFB1 26 00
    LD DE,$000A                         ; $BFB3 11 0a 00
    CALL $BFBB                          ; $BFB6 cd bb bf
    JR $BFA4                            ; $BFB9 18 e9
    LD C,$2F                            ; $BFBB 0e 2f
    INC C                               ; $BFBD 0c
    AND A                               ; $BFBE a7
    SBC HL,DE                           ; $BFBF ed 52
    JR NC,$BFBD                         ; $BFC1 30 fa
    ADD HL,DE                           ; $BFC3 19
    LD A,C                              ; $BFC4 79
    RET                                 ; $BFC5 c9
    LD C,A                              ; $BFC6 4f
    ADD A,A                             ; $BFC7 87
    ADD A,C                             ; $BFC8 81
    LD C,A                              ; $BFC9 4f
    LD B,$00                            ; $BFCA 06 00
    ADD HL,BC                           ; $BFCC 09
    LD B,$03                            ; $BFCD 06 03
    LD A,(HL)                           ; $BFCF 7e
    LD (IX+$00),A                       ; $BFD0 dd 77 00
    INC IX                              ; $BFD3 dd 23
    INC HL                              ; $BFD5 23
    DJNZ $BFCF                          ; $BFD6 10 f7
    RET                                 ; $BFD8 c9
    LD HL,($9FDD)                       ; $BFD9 2a dd 9f
    INC HL                              ; $BFDC 23
    LD ($9FDD),HL                       ; $BFDD 22 dd 9f
    LD HL,$9FDF                         ; $BFE0 21 df 9f
    INC (HL)                            ; $BFE3 34
    LD A,(HL)                           ; $BFE4 7e
    CP $3C                              ; $BFE5 fe 3c
    RET NZ                              ; $BFE7 c0
    LD (HL),$00                         ; $BFE8 36 00
    LD HL,$9FE0                         ; $BFEA 21 e0 9f
    INC (HL)                            ; $BFED 34
    LD A,(HL)                           ; $BFEE 7e
    CP $0D                              ; $BFEF fe 0d
    JR NZ,$BFF6                         ; $BFF1 20 03
    LD (HL),$01                         ; $BFF3 36 01
    RET                                 ; $BFF5 c9
    CP $0C                              ; $BFF6 fe 0c
    RET NZ                              ; $BFF8 c0
    LD A,($9FE2)                        ; $BFF9 3a e2 9f
    XOR $11                             ; $BFFC ee 11
    LD ($9FE2),A                        ; $BFFE 32 e2 9f
    CP $61                              ; $C001 fe 61
    RET NZ                              ; $C003 c0
    LD A,($9FE1)                        ; $C004 3a e1 9f
    INC A                               ; $C007 3c
    LD ($9FE1),A                        ; $C008 32 e1 9f
    RET                                 ; $C00B c9
    LD A,($9FE2)                        ; $C00C 3a e2 9f
    CP $61                              ; $C00F fe 61
    LD A,($9FE0)                        ; $C011 3a e0 9f
    JR Z,$C02B                          ; $C014 28 15
    CP $0C                              ; $C016 fe 0c
    JR Z,$C035                          ; $C018 28 1b
    CP $08                              ; $C01A fe 08
    JR C,$C021                          ; $C01C 38 03
    LD A,$01                            ; $C01E 3e 01
    RET                                 ; $C020 c9
    CP $07                              ; $C021 fe 07
    JR NZ,$C028                         ; $C023 20 03
    LD A,$02                            ; $C025 3e 02
    RET                                 ; $C027 c9
    LD A,$03                            ; $C028 3e 03
    RET                                 ; $C02A c9
    CP $0C                              ; $C02B fe 0c
    JR Z,$C01E                          ; $C02D 28 ef
    CP $06                              ; $C02F fe 06
    JR C,$C01E                          ; $C031 38 eb
    JR Z,$C038                          ; $C033 28 03
    LD A,$04                            ; $C035 3e 04
    RET                                 ; $C037 c9
    LD A,$05                            ; $C038 3e 05
    RET                                 ; $C03A c9
    ORG $C040
    LD HL,$09A2                         ; $C040 21 a2 09
    CALL $C1C0                          ; $C043 cd c0 c1
    LD ($C109),DE                       ; $C046 ed 53 09 c1
    LD ($C10B),IX                       ; $C04A dd 22 0b c1
    LD IX,$C0FE                         ; $C04E dd 21 fe c0
    LD DE,$0011                         ; $C052 11 11 00
    XOR A                               ; $C055 af
    CALL $04C2                          ; $C056 cd c2 04
    LD B,$32                            ; $C059 06 32
    HALT                                ; $C05B 76
    DJNZ $C05B                          ; $C05C 10 fd
    DI                                  ; $C05E f3
    LD DE,($C109)                       ; $C05F ed 5b 09 c1
    LD IX,($C10B)                       ; $C063 dd 2a 0b c1
    LD A,$FF                            ; $C067 3e ff
    CALL $04C2                          ; $C069 cd c2 04
    DI                                  ; $C06C f3
    LD HL,$C0A5                         ; $C06D 21 a5 c0
    CALL $C1CB                          ; $C070 cd cb c1
    LD HL,$09AC                         ; $C073 21 ac 09
    CALL $C1C0                          ; $C076 cd c0 c1
    LD IX,$C0FE                         ; $C079 dd 21 fe c0
    LD DE,$0011                         ; $C07D 11 11 00
    LD A,$00                            ; $C080 3e 00
    AND A                               ; $C082 a7
    CALL $0556                          ; $C083 cd 56 05
    JR NC,$C098                         ; $C086 30 10
    AND A                               ; $C088 a7
    LD DE,($C109)                       ; $C089 ed 5b 09 c1
    LD IX,($C10B)                       ; $C08D dd 2a 0b c1
    LD A,$FF                            ; $C091 3e ff
    CALL $0556                          ; $C093 cd 56 05
    DI                                  ; $C096 f3
    RET C                               ; $C097 d8
    DI                                  ; $C098 f3
    LD HL,$C0B1                         ; $C099 21 b1 c0
    CALL $C1CB                          ; $C09C cd cb c1
    LD HL,$09B2                         ; $C09F 21 b2 09
    JP $C1C0                            ; $C0A2 c3 c0 c1
    ORG $C0DF
    LD ($C109),DE                       ; $C0DF ed 53 09 c1
    LD ($C10B),IX                       ; $C0E3 dd 22 0b c1
    LD HL,$C0BC                         ; $C0E7 21 bc c0
    CALL $C1CB                          ; $C0EA cd cb c1
    LD IX,$C0FE                         ; $C0ED dd 21 fe c0
    LD DE,$0011                         ; $C0F1 11 11 00
    LD A,$00                            ; $C0F4 3e 00
    AND A                               ; $C0F6 a7
    CALL $0556                          ; $C0F7 cd 56 05
    JR NC,$C0ED                         ; $C0FA 30 f1
    JR $C089                            ; $C0FC 18 8b
    ORG $C10F
    LD A,$07                            ; $C10F 3e 07
    OUT ($FE),A                         ; $C111 d3 fe
    LD HL,$4000                         ; $C113 21 00 40
    LD DE,$4001                         ; $C116 11 01 40
    LD BC,$1800                         ; $C119 01 00 18
    LD (HL),$00                         ; $C11C 36 00
    LDIR                                ; $C11E ed b0
    LD BC,$02FF                         ; $C120 01 ff 02
    LD (HL),$38                         ; $C123 36 38
    LDIR                                ; $C125 ed b0
    RET                                 ; $C127 c9
    ORG $C129
    XOR A                               ; $C129 af
    LD ($A019),A                        ; $C12A 32 19 a0
    INC A                               ; $C12D 3c
    LD ($C128),A                        ; $C12E 32 28 c1
    LD A,$12                            ; $C131 3e 12
    LD ($C1F5),A                        ; $C133 32 f5 c1
    LD HL,$5020                         ; $C136 21 20 50
    LD ($C1F8),HL                       ; $C139 22 f8 c1
    LD A,$02                            ; $C13C 3e 02
    LD ($C1FA),A                        ; $C13E 32 fa c1
    RET                                 ; $C141 c9
    XOR A                               ; $C142 af
    LD ($C128),A                        ; $C143 32 28 c1
    LD A,$24                            ; $C146 3e 24
    JR $C133                            ; $C148 18 e9
    CALL $C10F                          ; $C14A cd 0f c1
    LD A,$24                            ; $C14D 3e 24
    LD ($C1F4),A                        ; $C14F 32 f4 c1
    LD HL,$50E0                         ; $C152 21 e0 50
    LD ($C1F6),HL                       ; $C155 22 f6 c1
    LD A,$02                            ; $C158 3e 02
    LD ($C1FB),A                        ; $C15A 32 fb c1
    CALL $C142                          ; $C15D cd 42 c1
    LD HL,$5140                         ; $C160 21 40 51
    LD DE,$C190                         ; $C163 11 90 c1
    LD B,$06                            ; $C166 06 06
    LD C,$08                            ; $C168 0e 08
    PUSH BC                             ; $C16A c5
    PUSH HL                             ; $C16B e5
    LD B,$04                            ; $C16C 06 04
    PUSH DE                             ; $C16E d5
    LD A,(DE)                           ; $C16F 1a
    LD (HL),A                           ; $C170 77
    INC DE                              ; $C171 13
    INC L                               ; $C172 2c
    DJNZ $C16F                          ; $C173 10 fa
    POP DE                              ; $C175 d1
    DEC C                               ; $C176 0d
    JR NZ,$C16C                         ; $C177 20 f3
    INC DE                              ; $C179 13
    INC DE                              ; $C17A 13
    INC DE                              ; $C17B 13
    INC DE                              ; $C17C 13
    POP HL                              ; $C17D e1
    POP BC                              ; $C17E c1
    INC H                               ; $C17F 24
    DJNZ $C168                          ; $C180 10 e6
    LD HL,$5A40                         ; $C182 21 40 5a
    LD DE,$5A41                         ; $C185 11 41 5a
    LD BC,$001F                         ; $C188 01 1f 00
    LD (HL),$78                         ; $C18B 36 78
    LDIR                                ; $C18D ed b0
    RET                                 ; $C18F c9
    ORG $C1A8
    LD DE,$5041                         ; $C1A8 11 41 50
    EX DE,HL                            ; $C1AB eb
    LD C,$00                            ; $C1AC 0e 00
    LD A,$20                            ; $C1AE 3e 20
    CALL $C388                          ; $C1B0 cd 88 c3
    LD A,(DE)                           ; $C1B3 1a
    CALL $C388                          ; $C1B4 cd 88 c3
    INC DE                              ; $C1B7 13
    DJNZ $C1B3                          ; $C1B8 10 f9
    LD A,$20                            ; $C1BA 3e 20
    CALL $C388                          ; $C1BC cd 88 c3
    RET                                 ; $C1BF c9
    CALL $C1CB                          ; $C1C0 cd cb c1
    CALL $C415                          ; $C1C3 cd 15 c4
    LD A,$0D                            ; $C1C6 3e 0d
    JP $C1FD                            ; $C1C8 c3 fd c1
    LD A,(HL)                           ; $C1CB 7e
    AND $7F                             ; $C1CC e6 7f
    CALL $C1FD                          ; $C1CE cd fd c1
    BIT 7,(HL)                          ; $C1D1 cb 7e
    RET NZ                              ; $C1D3 c0
    INC HL                              ; $C1D4 23
    JR $C1CB                            ; $C1D5 18 f4
    ORG $C1D8
    LD HL,$13C5                         ; $C1D8 21 c5 13
    CALL $C1C0                          ; $C1DB cd c0 c1
    JP $A0EB                            ; $C1DE c3 eb a0
    PUSH AF                             ; $C1E1 f5
    LD A,($5C3C)                        ; $C1E2 3a 3c 5c
    AND A                               ; $C1E5 a7
    JR NZ,$C1EA                         ; $C1E6 20 02
    POP AF                              ; $C1E8 f1
    RET                                 ; $C1E9 c9
    LD A,($A027)                        ; $C1EA 3a 27 a0
    AND A                               ; $C1ED a7
    JR NZ,$C1FC                         ; $C1EE 20 0c
    POP AF                              ; $C1F0 f1
    JP $C2BA                            ; $C1F1 c3 ba c2
    ORG $C1FC
    POP AF                              ; $C1FC f1
    PUSH HL                             ; $C1FD e5
    PUSH BC                             ; $C1FE c5
    PUSH AF                             ; $C1FF f5
    LD A,($C1FB)                        ; $C200 3a fb c1
    LD C,A                              ; $C203 4f
    POP AF                              ; $C204 f1
    PUSH AF                             ; $C205 f5
    LD HL,($C1F6)                       ; $C206 2a f6 c1
    CP $0D                              ; $C209 fe 0d
    JR NZ,$C214                         ; $C20B 20 07
    LD A,$20                            ; $C20D 3e 20
    CALL $C388                          ; $C20F cd 88 c3
    JR $C224                            ; $C212 18 10
    CP $08                              ; $C214 fe 08
    JR Z,$C249                          ; $C216 28 31
    CALL $C240                          ; $C218 cd 40 c2
    CALL $C388                          ; $C21B cd 88 c3
    LD A,($C1F4)                        ; $C21E 3a f4 c1
    DEC A                               ; $C221 3d
    JR NZ,$C22D                         ; $C222 20 09
    LD L,$E0                            ; $C224 2e e0
    LD C,$02                            ; $C226 0e 02
    CALL $C271                          ; $C228 cd 71 c2
    LD A,$24                            ; $C22B 3e 24
    LD ($C1F4),A                        ; $C22D 32 f4 c1
    LD A,C                              ; $C230 79
    LD ($C1FB),A                        ; $C231 32 fb c1
    LD ($C1F6),HL                       ; $C234 22 f6 c1
    LD A,$2B                            ; $C237 3e 2b
    CALL $C388                          ; $C239 cd 88 c3
    POP AF                              ; $C23C f1
    POP BC                              ; $C23D c1
    POP HL                              ; $C23E e1
    RET                                 ; $C23F c9
    CP $61                              ; $C240 fe 61
    RET C                               ; $C242 d8
    CP $7B                              ; $C243 fe 7b
    RET NC                              ; $C245 d0
    AND $5F                             ; $C246 e6 5f
    RET                                 ; $C248 c9
    LD A,$20                            ; $C249 3e 20
    CALL $C388                          ; $C24B cd 88 c3
    CALL $C267                          ; $C24E cd 67 c2
    CALL $C267                          ; $C251 cd 67 c2
    LD A,($C1F4)                        ; $C254 3a f4 c1
    INC A                               ; $C257 3c
    CP $25                              ; $C258 fe 25
    JR NZ,$C22D                         ; $C25A 20 d1
    LD L,$FE                            ; $C25C 2e fe
    LD C,$07                            ; $C25E 0e 07
    CALL $C29C                          ; $C260 cd 9c c2
    LD A,$01                            ; $C263 3e 01
    JR $C22D                            ; $C265 18 c6
    LD A,C                              ; $C267 79
    SUB $07                             ; $C268 d6 07
    LD C,A                              ; $C26A 4f
    RET NC                              ; $C26B d0
    DEC L                               ; $C26C 2d
    ADD A,$08                           ; $C26D c6 08
    LD C,A                              ; $C26F 4f
    RET                                 ; $C270 c9
    PUSH HL                             ; $C271 e5
    PUSH DE                             ; $C272 d5
    PUSH BC                             ; $C273 c5
    LD HL,$5080                         ; $C274 21 80 50
    LD DE,$5060                         ; $C277 11 60 50
    LD A,$08                            ; $C27A 3e 08
    PUSH HL                             ; $C27C e5
    PUSH DE                             ; $C27D d5
    LD BC,$0080                         ; $C27E 01 80 00
    LDIR                                ; $C281 ed b0
    POP DE                              ; $C283 d1
    POP HL                              ; $C284 e1
    INC H                               ; $C285 24
    INC D                               ; $C286 14
    DEC A                               ; $C287 3d
    JR NZ,$C27C                         ; $C288 20 f2
    LD HL,$50E0                         ; $C28A 21 e0 50
    LD B,$24                            ; $C28D 06 24
    LD C,$01                            ; $C28F 0e 01
    LD A,$20                            ; $C291 3e 20
    CALL $C388                          ; $C293 cd 88 c3
    DJNZ $C293                          ; $C296 10 fb
    POP BC                              ; $C298 c1
    POP DE                              ; $C299 d1
    POP HL                              ; $C29A e1
    RET                                 ; $C29B c9
    PUSH HL                             ; $C29C e5
    PUSH DE                             ; $C29D d5
    PUSH BC                             ; $C29E c5
    LD HL,$50DF                         ; $C29F 21 df 50
    LD DE,$50FF                         ; $C2A2 11 ff 50
    LD A,$08                            ; $C2A5 3e 08
    PUSH HL                             ; $C2A7 e5
    PUSH DE                             ; $C2A8 d5
    LD BC,$0080                         ; $C2A9 01 80 00
    LDDR                                ; $C2AC ed b8
    POP DE                              ; $C2AE d1
    POP HL                              ; $C2AF e1
    INC H                               ; $C2B0 24
    INC D                               ; $C2B1 14
    DEC A                               ; $C2B2 3d
    JR NZ,$C2A7                         ; $C2B3 20 f2
    LD HL,$5060                         ; $C2B5 21 60 50
    JR $C28D                            ; $C2B8 18 d3
    PUSH HL                             ; $C2BA e5
    PUSH BC                             ; $C2BB c5
    PUSH AF                             ; $C2BC f5
    LD HL,($C1F8)                       ; $C2BD 2a f8 c1
    LD A,($C1FA)                        ; $C2C0 3a fa c1
    LD C,A                              ; $C2C3 4f
    POP AF                              ; $C2C4 f1
    PUSH AF                             ; $C2C5 f5
    CP $0D                              ; $C2C6 fe 0d
    JR NZ,$C2EE                         ; $C2C8 20 24
    LD A,($A019)                        ; $C2CA 3a 19 a0
    CP $0F                              ; $C2CD fe 0f
    JR NZ,$C2D6                         ; $C2CF 20 05
    CALL $C306                          ; $C2D1 cd 06 c3
    LD A,$FF                            ; $C2D4 3e ff
    INC A                               ; $C2D6 3c
    LD ($A019),A                        ; $C2D7 32 19 a0
    LD HL,$5020                         ; $C2DA 21 20 50
    LD C,$02                            ; $C2DD 0e 02
    CALL $C316                          ; $C2DF cd 16 c3
    LD A,($C128)                        ; $C2E2 3a 28 c1
    AND A                               ; $C2E5 a7
    LD A,$24                            ; $C2E6 3e 24
    JR Z,$C2F8                          ; $C2E8 28 0e
    LD A,$12                            ; $C2EA 3e 12
    JR $C2F8                            ; $C2EC 18 0a
    CALL $C388                          ; $C2EE cd 88 c3
    LD A,($C1F5)                        ; $C2F1 3a f5 c1
    DEC A                               ; $C2F4 3d
    JP Z,$C2CA                          ; $C2F5 ca ca c2
    LD ($C1F5),A                        ; $C2F8 32 f5 c1
    LD ($C1F8),HL                       ; $C2FB 22 f8 c1
    LD A,C                              ; $C2FE 79
    LD ($C1FA),A                        ; $C2FF 32 fa c1
    POP AF                              ; $C302 f1
    POP BC                              ; $C303 c1
    POP HL                              ; $C304 e1
    RET                                 ; $C305 c9
    PUSH HL                             ; $C306 e5
    LD HL,$5A5F                         ; $C307 21 5f 5a
    SET 7,(HL)                          ; $C30A cb fe
    CALL $C415                          ; $C30C cd 15 c4
    RES 7,(HL)                          ; $C30F cb be
    CALL $C142                          ; $C311 cd 42 c1
    POP HL                              ; $C314 e1
    RET                                 ; $C315 c9
    LD A,($C128)                        ; $C316 3a 28 c1
    AND A                               ; $C319 a7
    CALL Z,$C3E4                        ; $C31A cc e4 c3
    PUSH BC                             ; $C31D c5
    PUSH HL                             ; $C31E e5
    PUSH DE                             ; $C31F d5
    LD HL,$4020                         ; $C320 21 20 40
    LD DE,$4000                         ; $C323 11 00 40
    LD BC,$0011                         ; $C326 01 11 00
    LD A,($C128)                        ; $C329 3a 28 c1
    AND A                               ; $C32C a7
    LD A,$20                            ; $C32D 3e 20
    JR Z,$C333                          ; $C32F 28 02
    LD A,$10                            ; $C331 3e 10
    PUSH HL                             ; $C333 e5
    PUSH DE                             ; $C334 d5
    PUSH BC                             ; $C335 c5
    LD C,$08                            ; $C336 0e 08
    PUSH HL                             ; $C338 e5
    PUSH DE                             ; $C339 d5
    PUSH BC                             ; $C33A c5
    LD C,A                              ; $C33B 4f
    LDIR                                ; $C33C ed b0
    POP BC                              ; $C33E c1
    POP DE                              ; $C33F d1
    POP HL                              ; $C340 e1
    INC H                               ; $C341 24
    INC D                               ; $C342 14
    DEC C                               ; $C343 0d
    JR NZ,$C338                         ; $C344 20 f2
    POP BC                              ; $C346 c1
    POP DE                              ; $C347 d1
    POP HL                              ; $C348 e1
    PUSH AF                             ; $C349 f5
    CALL $C37D                          ; $C34A cd 7d c3
    CALL $C37D                          ; $C34D cd 7d c3
    POP AF                              ; $C350 f1
    DEC C                               ; $C351 0d
    JR NZ,$C333                         ; $C352 20 df
    CP $10                              ; $C354 fe 10
    JR Z,$C363                          ; $C356 28 0b
    LD HL,$5820                         ; $C358 21 20 58
    LD DE,$5800                         ; $C35B 11 00 58
    LD BC,$0220                         ; $C35E 01 20 02
    LDIR                                ; $C361 ed b0
    LD A,($C128)                        ; $C363 3a 28 c1
    AND A                               ; $C366 a7
    LD B,$24                            ; $C367 06 24
    JR Z,$C36D                          ; $C369 28 02
    LD B,$12                            ; $C36B 06 12
    LD HL,$5020                         ; $C36D 21 20 50
    LD C,$02                            ; $C370 0e 02
    LD A,$20                            ; $C372 3e 20
    CALL $C388                          ; $C374 cd 88 c3
    DJNZ $C374                          ; $C377 10 fb
    POP DE                              ; $C379 d1
    POP HL                              ; $C37A e1
    POP BC                              ; $C37B c1
    RET                                 ; $C37C c9
    EX DE,HL                            ; $C37D eb
    LD A,L                              ; $C37E 7d
    ADD A,$20                           ; $C37F c6 20
    LD L,A                              ; $C381 6f
    RET NC                              ; $C382 d0
    LD A,H                              ; $C383 7c
    ADD A,$08                           ; $C384 c6 08
    LD H,A                              ; $C386 67
    RET                                 ; $C387 c9
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
    LD A,($A008)                        ; $C3E4 3a 08 a0
    AND A                               ; $C3E7 a7
    RET Z                               ; $C3E8 c8
    PUSH HL                             ; $C3E9 e5
    PUSH DE                             ; $C3EA d5
    PUSH BC                             ; $C3EB c5
    LD HL,$4000                         ; $C3EC 21 00 40
    LD B,$08                            ; $C3EF 06 08
    PUSH BC                             ; $C3F1 c5
    PUSH HL                             ; $C3F2 e5
    CALL $C403                          ; $C3F3 cd 03 c4
    POP HL                              ; $C3F6 e1
    INC H                               ; $C3F7 24
    POP BC                              ; $C3F8 c1
    DJNZ $C3F1                          ; $C3F9 10 f6
    LD A,$04                            ; $C3FB 3e 04
    OUT ($FB),A                         ; $C3FD d3 fb
    POP BC                              ; $C3FF c1
    POP DE                              ; $C400 d1
    POP HL                              ; $C401 e1
    RET                                 ; $C402 c9
    LD A,B                              ; $C403 78
    CP $03                              ; $C404 fe 03
    SBC A,A                             ; $C406 9f
    AND $02                             ; $C407 e6 02
    OUT ($FB),A                         ; $C409 d3 fb
    LD D,A                              ; $C40B 57
    IN A,($FB)                          ; $C40C db fb
    ADD A,A                             ; $C40E 87
    RET M                               ; $C40F f8
    JR NC,$C40C                         ; $C410 30 fa
    JP $0F12                            ; $C412 c3 12 0f
    CALL $C41F                          ; $C415 cd 1f c4
    BIT 7,A                             ; $C418 cb 7f
    JR Z,$C415                          ; $C41A 28 f9
    AND $7F                             ; $C41C e6 7f
    RET                                 ; $C41E c9
    PUSH IY                             ; $C41F fd e5
    PUSH IX                             ; $C421 dd e5
    PUSH HL                             ; $C423 e5
    PUSH DE                             ; $C424 d5
    PUSH BC                             ; $C425 c5
    LD IY,$5C3A                         ; $C426 fd 21 3a 5c
    EI                                  ; $C42A fb
    HALT                                ; $C42B 76
    DI                                  ; $C42C f3
    LD A,($5C3B)                        ; $C42D 3a 3b 5c
    BIT 5,A                             ; $C430 cb 6f
    JR NZ,$C437                         ; $C432 20 03
    XOR A                               ; $C434 af
    JR $C456                            ; $C435 18 1f
    RES 5,A                             ; $C437 cb af
    LD ($5C3B),A                        ; $C439 32 3b 5c
    LD A,($5C08)                        ; $C43C 3a 08 5c
    CP $5F                              ; $C43F fe 5f
    JR NZ,$C445                         ; $C441 20 02
    LD A,$18                            ; $C443 3e 18
    CP $0C                              ; $C445 fe 0c
    JR NZ,$C44B                         ; $C447 20 02
    LD A,$08                            ; $C449 3e 08
    CP $0B                              ; $C44B fe 0b
    JR NZ,$C451                         ; $C44D 20 02
    LD A,$5B                            ; $C44F 3e 5b
    CALL $C240                          ; $C451 cd 40 c2
    SET 7,A                             ; $C454 cb ff
    POP BC                              ; $C456 c1
    POP DE                              ; $C457 d1
    POP HL                              ; $C458 e1
    POP IX                              ; $C459 dd e1
    POP IY                              ; $C45B fd e1
    RET                                 ; $C45D c9
    LD A,($A010)                        ; $C45E 3a 10 a0
    JR $C466                            ; $C461 18 03
    LD A,($A00F)                        ; $C463 3a 0f a0
    CP $05                              ; $C466 fe 05
    LD A,B                              ; $C468 78
    JR C,$C46E                          ; $C469 38 03
    CP $6E                              ; $C46B fe 6e
    RET                                 ; $C46D c9
    CP $6A                              ; $C46E fe 6a
    RET                                 ; $C470 c9
    ORG $C493
    XOR A                               ; $C493 af
    LD HL,$A01D                         ; $C494 21 1d a0
    BIT 3,(HL)                          ; $C497 cb 5e
    JR Z,$C4AE                          ; $C499 28 13
    LD A,$04                            ; $C49B 3e 04
    BIT 7,(HL)                          ; $C49D cb 7e
    JR NZ,$C4AE                         ; $C49F 20 0d
    LD A,($A01E)                        ; $C4A1 3a 1e a0
    AND $0C                             ; $C4A4 e6 0c
    CP $0C                              ; $C4A6 fe 0c
    LD A,$05                            ; $C4A8 3e 05
    JR Z,$C4AE                          ; $C4AA 28 02
    LD A,$07                            ; $C4AC 3e 07
    LD ($A00F),A                        ; $C4AE 32 0f a0
    RET                                 ; $C4B1 c9
    XOR A                               ; $C4B2 af
    LD HL,$A01D                         ; $C4B3 21 1d a0
    BIT 2,(HL)                          ; $C4B6 cb 56
    JR Z,$C4CD                          ; $C4B8 28 13
    LD A,$04                            ; $C4BA 3e 04
    BIT 6,(HL)                          ; $C4BC cb 76
    JR NZ,$C4CD                         ; $C4BE 20 0d
    LD A,($A01E)                        ; $C4C0 3a 1e a0
    AND $03                             ; $C4C3 e6 03
    CP $03                              ; $C4C5 fe 03
    LD A,$05                            ; $C4C7 3e 05
    JR Z,$C4CD                          ; $C4C9 28 02
    LD A,$07                            ; $C4CB 3e 07
    LD ($A010),A                        ; $C4CD 32 10 a0
    RET                                 ; $C4D0 c9
    LD A,($A033)                        ; $C4D1 3a 33 a0
    BIT 7,A                             ; $C4D4 cb 7f
    JP NZ,$C583                         ; $C4D6 c2 83 c5
    CALL $A2B1                          ; $C4D9 cd b1 a2
    PUSH HL                             ; $C4DC e5
    POP IX                              ; $C4DD dd e1
    CALL $A2BD                          ; $C4DF cd bd a2
    CALL $C493                          ; $C4E2 cd 93 c4
    CALL $C4B2                          ; $C4E5 cd b2 c4
    XOR A                               ; $C4E8 af
    LD ($A00B),A                        ; $C4E9 32 0b a0
    LD A,($A01D)                        ; $C4EC 3a 1d a0
    AND $0C                             ; $C4EF e6 0c
    JR Z,$C53A                          ; $C4F1 28 47
    LD A,($A00F)                        ; $C4F3 3a 0f a0
    CP $05                              ; $C4F6 fe 05
    JR NZ,$C502                         ; $C4F8 20 08
    LD A,($A034)                        ; $C4FA 3a 34 a0
    CP $FE                              ; $C4FD fe fe
    JP NZ,$CB41                         ; $C4FF c2 41 cb
    LD A,($A010)                        ; $C502 3a 10 a0
    CP $05                              ; $C505 fe 05
    JR NZ,$C511                         ; $C507 20 08
    LD A,($A035)                        ; $C509 3a 35 a0
    CP $FE                              ; $C50C fe fe
    JP NZ,$CB41                         ; $C50E c2 41 cb
    LD A,($A00F)                        ; $C511 3a 0f a0
    AND A                               ; $C514 a7
    JR Z,$C531                          ; $C515 28 1a
    LD A,($A034)                        ; $C517 3a 34 a0
    CP $FF                              ; $C51A fe ff
    JR NZ,$C531                         ; $C51C 20 13
    LD B,$FF                            ; $C51E 06 ff
    INC B                               ; $C520 04
    CALL $C463                          ; $C521 cd 63 c4
    RET Z                               ; $C524 c8
    LD ($A034),A                        ; $C525 32 34 a0
    PUSH BC                             ; $C528 c5
    CALL $C55A                          ; $C529 cd 5a c5
    POP BC                              ; $C52C c1
    JR NZ,$C53A                         ; $C52D 20 0b
    JR $C520                            ; $C52F 18 ef
    CALL $C542                          ; $C531 cd 42 c5
    JR Z,$C53A                          ; $C534 28 04
    CALL $C560                          ; $C536 cd 60 c5
    RET Z                               ; $C539 c8
    LD A,$01                            ; $C53A 3e 01
    LD ($A00B),A                        ; $C53C 32 0b a0
    JP $C929                            ; $C53F c3 29 c9
    LD A,($A010)                        ; $C542 3a 10 a0
    AND A                               ; $C545 a7
    RET Z                               ; $C546 c8
    LD A,($A035)                        ; $C547 3a 35 a0
    CP $FF                              ; $C54A fe ff
    JR NZ,$C558                         ; $C54C 20 0a
    LD A,($A01D)                        ; $C54E 3a 1d a0
    AND $02                             ; $C551 e6 02
    JR NZ,$C558                         ; $C553 20 03
    OR $01                              ; $C555 f6 01
    RET                                 ; $C557 c9
    XOR A                               ; $C558 af
    RET                                 ; $C559 c9
    CALL $C542                          ; $C55A cd 42 c5
    JP Z,$C929                          ; $C55D ca 29 c9
    LD B,$FF                            ; $C560 06 ff
    INC B                               ; $C562 04
    CALL $C45E                          ; $C563 cd 5e c4
    JR Z,$C570                          ; $C566 28 08
    LD ($A035),A                        ; $C568 32 35 a0
    CALL $C929                          ; $C56B cd 29 c9
    JR Z,$C562                          ; $C56E 28 f2
    RET                                 ; $C570 c9
    LD A,(IX+$00)                       ; $C571 dd 7e 00
    AND $0F                             ; $C574 e6 0f
    LD ($A00F),A                        ; $C576 32 0f a0
    RET                                 ; $C579 c9
    LD A,(IX+$01)                       ; $C57A dd 7e 01
    AND $0F                             ; $C57D e6 0f
    LD ($A010),A                        ; $C57F 32 10 a0
    RET                                 ; $C582 c9
    AND $7F                             ; $C583 e6 7f
    LD E,A                              ; $C585 5f
    LD D,$00                            ; $C586 16 00
    LD HL,$9FAB                         ; $C588 21 ab 9f
    ADD HL,DE                           ; $C58B 19
    ADD HL,DE                           ; $C58C 19
    LD E,(HL)                           ; $C58D 5e
    INC HL                              ; $C58E 23
    LD D,(HL)                           ; $C58F 56
    EX DE,HL                            ; $C590 eb
    PUSH HL                             ; $C591 e5
    POP IX                              ; $C592 dd e1
    CALL $C571                          ; $C594 cd 71 c5
    CALL $C57A                          ; $C597 cd 7a c5
    XOR A                               ; $C59A af
    LD ($A00B),A                        ; $C59B 32 0b a0
    LD A,($A00F)                        ; $C59E 3a 0f a0
    LD HL,$A010                         ; $C5A1 21 10 a0
    OR (HL)                             ; $C5A4 b6
    JR Z,$C5F4                          ; $C5A5 28 4d
    LD A,($A00F)                        ; $C5A7 3a 0f a0
    CP $05                              ; $C5AA fe 05
    JR Z,$C5B2                          ; $C5AC 28 04
    CP $06                              ; $C5AE fe 06
    JR NZ,$C5BA                         ; $C5B0 20 08
    LD A,($A034)                        ; $C5B2 3a 34 a0
    CP $FE                              ; $C5B5 fe fe
    JP NZ,$CB41                         ; $C5B7 c2 41 cb
    LD A,($A010)                        ; $C5BA 3a 10 a0
    CP $05                              ; $C5BD fe 05
    JR Z,$C5C5                          ; $C5BF 28 04
    CP $06                              ; $C5C1 fe 06
    JR NZ,$C5CD                         ; $C5C3 20 08
    LD A,($A035)                        ; $C5C5 3a 35 a0
    CP $FE                              ; $C5C8 fe fe
    JP NZ,$CB41                         ; $C5CA c2 41 cb
    LD A,($A00F)                        ; $C5CD 3a 0f a0
    AND A                               ; $C5D0 a7
    JR Z,$C5EB                          ; $C5D1 28 18
    LD A,($A034)                        ; $C5D3 3a 34 a0
    CP $FF                              ; $C5D6 fe ff
    JR NZ,$C5EB                         ; $C5D8 20 11
    LD B,$00                            ; $C5DA 06 00
    CALL $C463                          ; $C5DC cd 63 c4
    RET Z                               ; $C5DF c8
    LD ($A034),A                        ; $C5E0 32 34 a0
    CALL $C60D                          ; $C5E3 cd 0d c6
    JR NZ,$C5F4                         ; $C5E6 20 0c
    INC B                               ; $C5E8 04
    JR $C5DC                            ; $C5E9 18 f1
    CALL $C5FC                          ; $C5EB cd fc c5
    JR Z,$C5F4                          ; $C5EE 28 04
    CALL $C613                          ; $C5F0 cd 13 c6
    RET Z                               ; $C5F3 c8
    LD A,$01                            ; $C5F4 3e 01
    LD ($A00B),A                        ; $C5F6 32 0b a0
    JP $C989                            ; $C5F9 c3 89 c9
    LD A,($A010)                        ; $C5FC 3a 10 a0
    AND A                               ; $C5FF a7
    RET Z                               ; $C600 c8
    LD A,($A035)                        ; $C601 3a 35 a0
    CP $FF                              ; $C604 fe ff
    JR NZ,$C60B                         ; $C606 20 03
    OR $01                              ; $C608 f6 01
    RET                                 ; $C60A c9
    XOR A                               ; $C60B af
    RET                                 ; $C60C c9
    CALL $C5FC                          ; $C60D cd fc c5
    JP Z,$C989                          ; $C610 ca 89 c9
    PUSH BC                             ; $C613 c5
    LD B,$00                            ; $C614 06 00
    CALL $C45E                          ; $C616 cd 5e c4
    JR Z,$C626                          ; $C619 28 0b
    LD ($A035),A                        ; $C61B 32 35 a0
    CALL $C989                          ; $C61E cd 89 c9
    JR NZ,$C626                         ; $C621 20 03
    INC B                               ; $C623 04
    JR $C616                            ; $C624 18 f0
    POP BC                              ; $C626 c1
    RET                                 ; $C627 c9
    LD A,(IY+$00)                       ; $C628 fd 7e 00
    AND $0F                             ; $C62B e6 0f
    JR NZ,$C635                         ; $C62D 20 06
    OR $01                              ; $C62F f6 01
    RET                                 ; $C631 c9
    JP $DC15                            ; $C632 c3 15 dc
    CP $05                              ; $C635 fe 05
    JR C,$C660                          ; $C637 38 27
    CP $07                              ; $C639 fe 07
    JR NC,$C682                         ; $C63B 30 45
    LD A,($A034)                        ; $C63D 3a 34 a0
    CP $FE                              ; $C640 fe fe
    JR NZ,$C654                         ; $C642 20 10
    LD HL,($A02F)                       ; $C644 2a 2f a0
    LD A,(IY+$00)                       ; $C647 fd 7e 00
    AND $0F                             ; $C64A e6 0f
    CP $05                              ; $C64C fe 05
    JR NZ,$C65A                         ; $C64E 20 0a
    BIT 7,L                             ; $C650 cb 7d
    JR Z,$C62F                          ; $C652 28 db
    XOR A                               ; $C654 af
    LD ($A021),A                        ; $C655 32 21 a0
    JR $C632                            ; $C658 18 d8
    BIT 7,L                             ; $C65A cb 7d
    JR NZ,$C62F                         ; $C65C 20 d1
    JR $C654                            ; $C65E 18 f4
    CP $03                              ; $C660 fe 03
    JR NC,$C670                         ; $C662 30 0c
    LD A,($A034)                        ; $C664 3a 34 a0
    CALL $D224                          ; $C667 cd 24 d2
    BIT 7,(IX+$00)                      ; $C66A dd cb 00 7e
    JR Z,$C654                          ; $C66E 28 e4
    BIT 0,(IY+$00)                      ; $C670 fd cb 00 46
    JR Z,$C62F                          ; $C674 28 b9
    LD A,($A034)                        ; $C676 3a 34 a0
    CALL $D471                          ; $C679 cd 71 d4
    CP $FF                              ; $C67C fe ff
    JR Z,$C654                          ; $C67E 28 d4
    JR $C62F                            ; $C680 18 ad
    LD A,($A034)                        ; $C682 3a 34 a0
    LD ($CB7A),A                        ; $C685 32 7a cb
    LD C,A                              ; $C688 4f
    LD A,(IY+$00)                       ; $C689 fd 7e 00
    CALL $C7A6                          ; $C68C cd a6 c7
    JR Z,$C654                          ; $C68F 28 c3
    BIT 4,(IY+$00)                      ; $C691 fd cb 00 66
    JR Z,$C62F                          ; $C695 28 98
    LD A,(IY+$02)                       ; $C697 fd 7e 02
    LD L,(IY+$03)                       ; $C69A fd 6e 03
    LD H,(IY+$04)                       ; $C69D fd 66 04
    BIT 6,(IY+$00)                      ; $C6A0 fd cb 00 76
    JR Z,$C6AF                          ; $C6A4 28 09
    LD A,(IY+$04)                       ; $C6A6 fd 7e 04
    LD L,(IY+$05)                       ; $C6A9 fd 6e 05
    LD H,(IY+$06)                       ; $C6AC fd 66 06
    RRCA                                ; $C6AF 0f
    RRCA                                ; $C6B0 0f
    RRCA                                ; $C6B1 0f
    RRCA                                ; $C6B2 0f
    LD B,A                              ; $C6B3 47
    CALL $C74E                          ; $C6B4 cd 4e c7
    RET NZ                              ; $C6B7 c0
    LD A,$01                            ; $C6B8 3e 01
    LD ($A021),A                        ; $C6BA 32 21 a0
    RET                                 ; $C6BD c9
    LD A,(IY+$01)                       ; $C6BE fd 7e 01
    AND $0F                             ; $C6C1 e6 0f
    JR NZ,$C6CB                         ; $C6C3 20 06
    OR $01                              ; $C6C5 f6 01
    RET                                 ; $C6C7 c9
    ORG $C6CB
    CP $05                              ; $C6CB fe 05
    JR C,$C6F5                          ; $C6CD 38 26
    CP $07                              ; $C6CF fe 07
    JR NC,$C719                         ; $C6D1 30 46
    LD A,($A035)                        ; $C6D3 3a 35 a0
    CP $FE                              ; $C6D6 fe fe
    JP NZ,$C654                         ; $C6D8 c2 54 c6
    LD HL,($A031)                       ; $C6DB 2a 31 a0
    LD A,(IY+$01)                       ; $C6DE fd 7e 01
    AND $0F                             ; $C6E1 e6 0f
    CP $05                              ; $C6E3 fe 05
    JR NZ,$C6EE                         ; $C6E5 20 07
    BIT 7,L                             ; $C6E7 cb 7d
    JR Z,$C6C5                          ; $C6E9 28 da
    JP $C654                            ; $C6EB c3 54 c6
    BIT 7,L                             ; $C6EE cb 7d
    JR NZ,$C6C5                         ; $C6F0 20 d3
    JP $C654                            ; $C6F2 c3 54 c6
    CP $03                              ; $C6F5 fe 03
    JR NC,$C706                         ; $C6F7 30 0d
    LD A,($A035)                        ; $C6F9 3a 35 a0
    CALL $D224                          ; $C6FC cd 24 d2
    BIT 7,(IX+$00)                      ; $C6FF dd cb 00 7e
    JP Z,$C654                          ; $C703 ca 54 c6
    BIT 0,(IY+$01)                      ; $C706 fd cb 01 46
    JR Z,$C6C5                          ; $C70A 28 b9
    LD A,($A035)                        ; $C70C 3a 35 a0
    CALL $D471                          ; $C70F cd 71 d4
    CP $FF                              ; $C712 fe ff
    JP Z,$C654                          ; $C714 ca 54 c6
    JR $C6C5                            ; $C717 18 ac
    LD A,($A035)                        ; $C719 3a 35 a0
    LD ($CB7A),A                        ; $C71C 32 7a cb
    LD C,A                              ; $C71F 4f
    LD A,(IY+$01)                       ; $C720 fd 7e 01
    CALL $C7A6                          ; $C723 cd a6 c7
    RET Z                               ; $C726 c8
    BIT 4,(IY+$00)                      ; $C727 fd cb 00 66
    JP Z,$C62F                          ; $C72B ca 2f c6
    LD A,(IY+$02)                       ; $C72E fd 7e 02
    LD L,(IY+$05)                       ; $C731 fd 6e 05
    LD H,(IY+$06)                       ; $C734 fd 66 06
    BIT 6,(IY+$00)                      ; $C737 fd cb 00 76
    JR Z,$C746                          ; $C73B 28 09
    LD A,(IY+$04)                       ; $C73D fd 7e 04
    LD L,(IY+$07)                       ; $C740 fd 6e 07
    LD H,(IY+$08)                       ; $C743 fd 66 08
    LD B,A                              ; $C746 47
    CALL $C74E                          ; $C747 cd 4e c7
    RET NZ                              ; $C74A c0
    JP $C6B8                            ; $C74B c3 b8 c6
    LD A,C                              ; $C74E 79
    CALL $D237                          ; $C74F cd 37 d2
    LD C,(IX+$05)                       ; $C752 dd 4e 05
    LD A,B                              ; $C755 78
    RRCA                                ; $C756 0f
    RRCA                                ; $C757 0f
    AND $03                             ; $C758 e6 03
    LD D,L                              ; $C75A 55
    CALL $C763                          ; $C75B cd 63 c7
    RET Z                               ; $C75E c8
    LD A,B                              ; $C75F 78
    AND $03                             ; $C760 e6 03
    LD D,H                              ; $C762 54
    JR NZ,$C76D                         ; $C763 20 08
    LD A,D                              ; $C765 7a
    AND C                               ; $C766 a1
    CP D                                ; $C767 ba
    JP Z,$C62F                          ; $C768 ca 2f c6
    JR $C792                            ; $C76B 18 25
    CP $01                              ; $C76D fe 01
    JR NZ,$C77B                         ; $C76F 20 0a
    LD A,D                              ; $C771 7a
    AND A                               ; $C772 a7
    JR Z,$C768                          ; $C773 28 f3
    AND C                               ; $C775 a1
    JR Z,$C795                          ; $C776 28 1d
    JP $C62F                            ; $C778 c3 2f c6
    CP $02                              ; $C77B fe 02
    JR NZ,$C788                         ; $C77D 20 09
    LD A,D                              ; $C77F 7a
    AND C                               ; $C780 a1
    JP Z,$C62F                          ; $C781 ca 2f c6
    OR $80                              ; $C784 f6 80
    JR $C797                            ; $C786 18 0f
    LD A,D                              ; $C788 7a
    AND C                               ; $C789 a1
    CP D                                ; $C78A ba
    JP NZ,$C62F                         ; $C78B c2 2f c6
    OR $80                              ; $C78E f6 80
    JR $C797                            ; $C790 18 05
    XOR $FF                             ; $C792 ee ff
    AND D                               ; $C794 a2
    AND $7F                             ; $C795 e6 7f
    LD ($CB79),A                        ; $C797 32 79 cb
    LD A,($A00B)                        ; $C79A 3a 0b a0
    AND A                               ; $C79D a7
    JP Z,$C62F                          ; $C79E ca 2f c6
    LD HL,$CB7B                         ; $C7A1 21 7b cb
    XOR A                               ; $C7A4 af
    RET                                 ; $C7A5 c9
    AND $0F                             ; $C7A6 e6 0f
    CP $07                              ; $C7A8 fe 07
    JP Z,$C62F                          ; $C7AA ca 2f c6
    CP $08                              ; $C7AD fe 08
    JR NZ,$C7BB                         ; $C7AF 20 0a
    LD A,C                              ; $C7B1 79
    CALL $C821                          ; $C7B2 cd 21 c8
    JP Z,$C632                          ; $C7B5 ca 32 c6
    JP $C62F                            ; $C7B8 c3 2f c6
    CP $09                              ; $C7BB fe 09
    JR NZ,$C7E4                         ; $C7BD 20 25
    LD A,C                              ; $C7BF 79
    CALL $C821                          ; $C7C0 cd 21 c8
    JP Z,$C632                          ; $C7C3 ca 32 c6
    LD A,C                              ; $C7C6 79
    CALL $C8A7                          ; $C7C7 cd a7 c8
    JP NZ,$C632                         ; $C7CA c2 32 c6
    LD A,C                              ; $C7CD 79
    CALL $C8BE                          ; $C7CE cd be c8
    JP NZ,$C632                         ; $C7D1 c2 32 c6
    LD B,C                              ; $C7D4 41
    LD A,($A036)                        ; $C7D5 3a 36 a0
    CALL $C8C6                          ; $C7D8 cd c6 c8
    JP Z,$C632                          ; $C7DB ca 32 c6
    LD A,C                              ; $C7DE 79
    CALL $C8AF                          ; $C7DF cd af c8
    JR $C768                            ; $C7E2 18 84
    CP $0A                              ; $C7E4 fe 0a
    JR NZ,$C7F9                         ; $C7E6 20 11
    LD A,C                              ; $C7E8 79
    CALL $C821                          ; $C7E9 cd 21 c8
    JP Z,$C632                          ; $C7EC ca 32 c6
    LD A,C                              ; $C7EF 79
    CALL $D275                          ; $C7F0 cd 75 d2
    JP NC,$C632                         ; $C7F3 d2 32 c6
    JP $C62F                            ; $C7F6 c3 2f c6
    CP $0B                              ; $C7F9 fe 0b
    JR NZ,$C80A                         ; $C7FB 20 0d
    LD A,C                              ; $C7FD 79
    CALL $C821                          ; $C7FE cd 21 c8
    JP Z,$C632                          ; $C801 ca 32 c6
    LD A,C                              ; $C804 79
    CALL $C8A7                          ; $C805 cd a7 c8
    JR $C7B5                            ; $C808 18 ab
    CP $0C                              ; $C80A fe 0c
    JR NZ,$C814                         ; $C80C 20 06
    LD A,C                              ; $C80E 79
    CALL $C8BE                          ; $C80F cd be c8
    JR $C7B5                            ; $C812 18 a1
    LD A,C                              ; $C814 79
    CALL $C821                          ; $C815 cd 21 c8
    JP Z,$C632                          ; $C818 ca 32 c6
    LD A,C                              ; $C81B 79
    CALL $C8BE                          ; $C81C cd be c8
    JR $C7B5                            ; $C81F 18 94
    PUSH IX                             ; $C821 dd e5
    PUSH BC                             ; $C823 c5
    CALL $D237                          ; $C824 cd 37 d2
    LD B,A                              ; $C827 47
    LD A,($A036)                        ; $C828 3a 36 a0
    CALL $C863                          ; $C82B cd 63 c8
    CP B                                ; $C82E b8
    JR Z,$C85D                          ; $C82F 28 2c
    BIT 7,(IX+$05)                      ; $C831 dd cb 05 7e
    JR Z,$C85A                          ; $C835 28 23
    LD C,A                              ; $C837 4f
    LD A,B                              ; $C838 78
    LD B,C                              ; $C839 41
    CALL $C863                          ; $C83A cd 63 c8
    LD C,A                              ; $C83D 4f
    LD A,($A036)                        ; $C83E 3a 36 a0
    CP C                                ; $C841 b9
    JR Z,$C85D                          ; $C842 28 19
    LD A,C                              ; $C844 79
    CP B                                ; $C845 b8
    JR NZ,$C85A                         ; $C846 20 12
    INC A                               ; $C848 3c
    JR NZ,$C85D                         ; $C849 20 12
    LD B,(IX+$00)                       ; $C84B dd 46 00
    LD A,($A00A)                        ; $C84E 3a 0a a0
    CP (IX+$0F)                         ; $C851 dd be 0f
    JR Z,$C85D                          ; $C854 28 07
    INC IX                              ; $C856 dd 23
    DJNZ $C851                          ; $C858 10 f7
    XOR A                               ; $C85A af
    JR $C85F                            ; $C85B 18 02
    OR $01                              ; $C85D f6 01
    POP BC                              ; $C85F c1
    POP IX                              ; $C860 dd e1
    RET                                 ; $C862 c9
    PUSH IX                             ; $C863 dd e5
    CALL $D237                          ; $C865 cd 37 d2
    CALL $C86E                          ; $C868 cd 6e c8
    POP IX                              ; $C86B dd e1
    RET                                 ; $C86D c9
    PUSH IX                             ; $C86E dd e5
    EX AF,AF'                           ; $C870 08
    LD A,$FF                            ; $C871 3e ff
    EX AF,AF'                           ; $C873 08
    LD A,(IX+$01)                       ; $C874 dd 7e 01
    CP $FF                              ; $C877 fe ff
    JR Z,$C895                          ; $C879 28 1a
    EX AF,AF'                           ; $C87B 08
    LD A,(IX+$01)                       ; $C87C dd 7e 01
    CALL $D237                          ; $C87F cd 37 d2
    BIT 7,(IX+$05)                      ; $C882 dd cb 05 7e
    JR Z,$C894                          ; $C886 28 0c
    BIT 5,(IX+$05)                      ; $C888 dd cb 05 6e
    JR NZ,$C873                         ; $C88C 20 e5
    BIT 3,(IX+$05)                      ; $C88E dd cb 05 5e
    JR NZ,$C873                         ; $C892 20 df
    EX AF,AF'                           ; $C894 08
    POP IX                              ; $C895 dd e1
    RET                                 ; $C897 c9
    ORG $C8A7
    CALL $D237                          ; $C8A7 cd 37 d2
    LD A,(IX+$00)                       ; $C8AA dd 7e 00
    DEC A                               ; $C8AD 3d
    RET                                 ; $C8AE c9
    CALL $D237                          ; $C8AF cd 37 d2
    LD A,(IX+$01)                       ; $C8B2 dd 7e 01
    CP $FF                              ; $C8B5 fe ff
    RET Z                               ; $C8B7 c8
    CALL $C8BE                          ; $C8B8 cd be c8
    RET NZ                              ; $C8BB c0
    JR $C8B2                            ; $C8BC 18 f4
    CALL $D237                          ; $C8BE cd 37 d2
    BIT 6,(IX+$05)                      ; $C8C1 dd cb 05 76
    RET                                 ; $C8C5 c9
    PUSH BC                             ; $C8C6 c5
    PUSH AF                             ; $C8C7 f5
    LD A,B                              ; $C8C8 78
    CALL $D237                          ; $C8C9 cd 37 d2
    LD A,B                              ; $C8CC 78
    CALL $D2F2                          ; $C8CD cd f2 d2
    ADD A,(IX+$03)                      ; $C8D0 dd 86 03
    JR NC,$C8D7                         ; $C8D3 30 02
    LD A,$FF                            ; $C8D5 3e ff
    LD B,A                              ; $C8D7 47
    POP AF                              ; $C8D8 f1
    LD C,A                              ; $C8D9 4f
    CALL $D237                          ; $C8DA cd 37 d2
    LD A,C                              ; $C8DD 79
    CALL $D2F2                          ; $C8DE cd f2 d2
    SUB (IX+$03)                        ; $C8E1 dd 96 03
    NEG                                 ; $C8E4 ed 44
    SUB B                               ; $C8E6 90
    POP BC                              ; $C8E7 c1
    JR C,$C8ED                          ; $C8E8 38 03
    OR $01                              ; $C8EA f6 01
    RET                                 ; $C8EC c9
    XOR A                               ; $C8ED af
    RET                                 ; $C8EE c9
    LD A,($A034)                        ; $C8EF 3a 34 a0
    CP $FE                              ; $C8F2 fe fe
    JR NC,$C90C                         ; $C8F4 30 16
    LD A,($A00F)                        ; $C8F6 3a 0f a0
    CP $05                              ; $C8F9 fe 05
    LD A,($A034)                        ; $C8FB 3a 34 a0
    JR NC,$C905                         ; $C8FE 30 05
    CALL $D224                          ; $C900 cd 24 d2
    JR $C908                            ; $C903 18 03
    CALL $D237                          ; $C905 cd 37 d2
    LD ($A013),IX                       ; $C908 dd 22 13 a0
    LD A,($A035)                        ; $C90C 3a 35 a0
    CP $FE                              ; $C90F fe fe
    RET NC                              ; $C911 d0
    LD A,($A010)                        ; $C912 3a 10 a0
    CP $05                              ; $C915 fe 05
    LD A,($A035)                        ; $C917 3a 35 a0
    JR NC,$C921                         ; $C91A 30 05
    CALL $D224                          ; $C91C cd 24 d2
    JR $C924                            ; $C91F 18 03
    CALL $D237                          ; $C921 cd 37 d2
    LD ($A015),IX                       ; $C924 dd 22 15 a0
    RET                                 ; $C928 c9
    CALL $C8EF                          ; $C929 cd ef c8
    LD A,($A034)                        ; $C92C 3a 34 a0
    CP $FE                              ; $C92F fe fe
    JR NC,$C972                         ; $C931 30 3f
    LD IX,($A017)                       ; $C933 dd 2a 17 a0
    BIT 6,(IX+$05)                      ; $C937 dd cb 05 76
    JR Z,$C94D                          ; $C93B 28 10
    XOR A                               ; $C93D af
    CALL $D1DC                          ; $C93E cd dc d1
    JR NC,$C94D                         ; $C941 30 0a
    LD A,($A033)                        ; $C943 3a 33 a0
    CALL $D349                          ; $C946 cd 49 d3
    CP $FF                              ; $C949 fe ff
    JR NZ,$C960                         ; $C94B 20 13
    LD A,($A00F)                        ; $C94D 3a 0f a0
    CP $07                              ; $C950 fe 07
    JR C,$C972                          ; $C952 38 1e
    LD IX,($A013)                       ; $C954 dd 2a 13 a0
    LD A,($A033)                        ; $C958 3a 33 a0
    CALL $D1DC                          ; $C95B cd dc d1
    JR NC,$C972                         ; $C95E 30 12
    LD A,(IX+$01)                       ; $C960 dd 7e 01
    LD E,A                              ; $C963 5f
    LD D,$00                            ; $C964 16 00
    LD HL,$AA71                         ; $C966 21 71 aa
    DEC DE                              ; $C969 1b
    ADD HL,DE                           ; $C96A 19
    ADD HL,DE                           ; $C96B 19
    LD E,(HL)                           ; $C96C 5e
    INC HL                              ; $C96D 23
    LD D,(HL)                           ; $C96E 56
    EX DE,HL                            ; $C96F eb
    JR $C996                            ; $C970 18 24
    LD A,($A033)                        ; $C972 3a 33 a0
    LD IX,$9F38                         ; $C975 dd 21 38 9f
    CALL $D34E                          ; $C979 cd 4e d3
    CP $FF                              ; $C97C fe ff
    JP Z,$DC15                          ; $C97E ca 15 dc
    LD L,(IX+$01)                       ; $C981 dd 6e 01
    LD H,(IX+$02)                       ; $C984 dd 66 02
    JR $C996                            ; $C987 18 0d
    PUSH IX                             ; $C989 dd e5
    POP HL                              ; $C98B e1
    PUSH HL                             ; $C98C e5
    CALL $C8EF                          ; $C98D cd ef c8
    CALL $C996                          ; $C990 cd 96 c9
    POP IX                              ; $C993 dd e1
    RET                                 ; $C995 c9
    PUSH IY                             ; $C996 fd e5
    PUSH BC                             ; $C998 c5
    CALL $C9BF                          ; $C999 cd bf c9
    POP BC                              ; $C99C c1
    POP IY                              ; $C99D fd e1
    JR C,$C9A7                          ; $C99F 38 06
    JP Z,$CB43                          ; $C9A1 ca 43 cb
    OR $01                              ; $C9A4 f6 01
    RET                                 ; $C9A6 c9
    PUSH HL                             ; $C9A7 e5
    PUSH BC                             ; $C9A8 c5
    LD HL,($9FD9)                       ; $C9A9 2a d9 9f
    LD B,$01                            ; $C9AC 06 01
    CALL $CF80                          ; $C9AE cd 80 cf
    POP BC                              ; $C9B1 c1
    POP HL                              ; $C9B2 e1
    LD IX,($9FDB)                       ; $C9B3 dd 2a db 9f
    LD (IX+$01),L                       ; $C9B7 dd 75 01
    LD (IX+$02),H                       ; $C9BA dd 74 02
    SCF                                 ; $C9BD 37
    RET                                 ; $C9BE c9
    PUSH HL                             ; $C9BF e5
    POP IY                              ; $C9C0 fd e1
    CALL $D078                          ; $C9C2 cd 78 d0
    JR NC,$C9D3                         ; $C9C5 30 0c
    LD A,(IY+$00)                       ; $C9C7 fd 7e 00
    AND $20                             ; $C9CA e6 20
    JR Z,$C9D3                          ; $C9CC 28 05
    LD HL,$CBBB                         ; $C9CE 21 bb cb
    XOR A                               ; $C9D1 af
    RET                                 ; $C9D2 c9
    CALL $C628                          ; $C9D3 cd 28 c6
    JR Z,$C9D1                          ; $C9D6 28 f9
    CALL $C6BE                          ; $C9D8 cd be c6
    JR Z,$C9D1                          ; $C9DB 28 f4
    BIT 6,(IY+$00)                      ; $C9DD fd cb 00 76
    JR Z,$C9F2                          ; $C9E1 28 0f
    LD L,(IY+$02)                       ; $C9E3 fd 6e 02
    LD H,(IY+$03)                       ; $C9E6 fd 66 03
    PUSH IY                             ; $C9E9 fd e5
    CALL $CB34                          ; $C9EB cd 34 cb
    POP IY                              ; $C9EE fd e1
    JR Z,$C9D1                          ; $C9F0 28 df
    LD A,($A00B)                        ; $C9F2 3a 0b a0
    AND A                               ; $C9F5 a7
    JR NZ,$C9FB                         ; $C9F6 20 03
    OR $01                              ; $C9F8 f6 01
    RET                                 ; $C9FA c9
    PUSH IY                             ; $C9FB fd e5
    LD A,(IY+$01)                       ; $C9FD fd 7e 01
    RRCA                                ; $CA00 0f
    RRCA                                ; $CA01 0f
    RRCA                                ; $CA02 0f
    RRCA                                ; $CA03 0f
    AND $0F                             ; $CA04 e6 0f
    LD L,A                              ; $CA06 6f
    LD H,$00                            ; $CA07 26 00
    LD ($A01F),HL                       ; $CA09 22 1f a0
    POP HL                              ; $CA0C e1
    LD DE,$0002                         ; $CA0D 11 02 00
    ADD HL,DE                           ; $CA10 19
    BIT 6,(IY+$00)                      ; $CA11 fd cb 00 76
    JR Z,$CA18                          ; $CA15 28 01
    ADD HL,DE                           ; $CA17 19
    LD DE,$0005                         ; $CA18 11 05 00
    BIT 4,(IY+$00)                      ; $CA1B fd cb 00 66
    JR Z,$CA22                          ; $CA1F 28 01
    ADD HL,DE                           ; $CA21 19
    LD A,($A00A)                        ; $CA22 3a 0a a0
    LD ($C491),A                        ; $CA25 32 91 c4
    LD IX,($A013)                       ; $CA28 dd 2a 13 a0
    LD A,(IX+$0F)                       ; $CA2C dd 7e 0f
    LD ($C492),A                        ; $CA2F 32 92 c4
    PUSH HL                             ; $CA32 e5
    PUSH IY                             ; $CA33 fd e5
    LD A,$01                            ; $CA35 3e 01
    LD ($A00C),A                        ; $CA37 32 0c a0
    CALL $CA76                          ; $CA3A cd 76 ca
    POP IY                              ; $CA3D fd e1
    POP HL                              ; $CA3F e1
    BIT 7,(IY+$00)                      ; $CA40 fd cb 00 7e
    JR Z,$CA48                          ; $CA44 28 02
    SCF                                 ; $CA46 37
    RET                                 ; $CA47 c9
    LD A,($9FD7)                        ; $CA48 3a d7 9f
    INC A                               ; $CA4B 3c
    JR NZ,$CA54                         ; $CA4C 20 06
    LD A,($A034)                        ; $CA4E 3a 34 a0
    LD ($9FD7),A                        ; $CA51 32 d7 9f
    LD A,($9FD8)                        ; $CA54 3a d8 9f
    INC A                               ; $CA57 3c
    JR NZ,$CA60                         ; $CA58 20 06
    LD A,($A035)                        ; $CA5A 3a 35 a0
    LD ($9FD8),A                        ; $CA5D 32 d8 9f
    XOR A                               ; $CA60 af
    LD ($CAAE),A                        ; $CA61 32 ae ca
    CALL $CB2C                          ; $CA64 cd 2c cb
    PUSH AF                             ; $CA67 f5
    PUSH HL                             ; $CA68 e5
    CALL $CA7F                          ; $CA69 cd 7f ca
    LD A,($CAAE)                        ; $CA6C 3a ae ca
    AND A                               ; $CA6F a7
    CALL Z,$CAAF                        ; $CA70 cc af ca
    POP HL                              ; $CA73 e1
    POP AF                              ; $CA74 f1
    RET                                 ; $CA75 c9
    LD A,($A033)                        ; $CA76 3a 33 a0
    AND $80                             ; $CA79 e6 80
    CALL Z,$A2E4                        ; $CA7B cc e4 a2
    RET                                 ; $CA7E c9
    LD A,($9860)                        ; $CA7F 3a 60 98
    CALL $D237                          ; $CA82 cd 37 d2
    LD A,($A009)                        ; $CA85 3a 09 a0
    CP (IX+$0F)                         ; $CA88 dd be 0f
    RET Z                               ; $CA8B c8
    LD A,($A036)                        ; $CA8C 3a 36 a0
    PUSH AF                             ; $CA8F f5
    LD A,($9860)                        ; $CA90 3a 60 98
    LD ($A036),A                        ; $CA93 32 36 a0
    CALL $CA9E                          ; $CA96 cd 9e ca
    POP AF                              ; $CA99 f1
    LD ($A036),A                        ; $CA9A 32 36 a0
    RET                                 ; $CA9D c9
    LD A,($DD01)                        ; $CA9E 3a 01 dd
    LD HL,($DCFF)                       ; $CAA1 2a ff dc
    BIT 6,(HL)                          ; $CAA4 cb 76
    JP NZ,$D1B2                         ; $CAA6 c2 b2 d1
    SET 6,(HL)                          ; $CAA9 cb f6
    JP $D102                            ; $CAAB c3 02 d1
    ORG $CAAF
    CALL $DC6C                          ; $CAAF cd 6c dc
    RET Z                               ; $CAB2 c8
    LD A,($C491)                        ; $CAB3 3a 91 c4
    LD HL,$A009                         ; $CAB6 21 09 a0
    CP (HL)                             ; $CAB9 be
    RET Z                               ; $CABA c8
    LD A,($A036)                        ; $CABB 3a 36 a0
    CALL $D495                          ; $CABE cd 95 d4
    LD HL,$A009                         ; $CAC1 21 09 a0
    CP (HL)                             ; $CAC4 be
    JR NZ,$CAD0                         ; $CAC5 20 09
    LD A,($A036)                        ; $CAC7 3a 36 a0
    LD DE,$68ED                         ; $CACA 11 ed 68
    CALL $CBC2                          ; $CACD cd c2 cb
    LD A,($A00F)                        ; $CAD0 3a 0f a0
    CP $07                              ; $CAD3 fe 07
    RET C                               ; $CAD5 d8
    LD A,($A034)                        ; $CAD6 3a 34 a0
    CALL $D495                          ; $CAD9 cd 95 d4
    CP $FF                              ; $CADC fe ff
    JR NZ,$CB12                         ; $CADE 20 32
    LD B,(IX+$00)                       ; $CAE0 dd 46 00
    LD A,($A009)                        ; $CAE3 3a 09 a0
    CP (IX+$0F)                         ; $CAE6 dd be 0f
    JR Z,$CAF0                          ; $CAE9 28 05
    INC IX                              ; $CAEB dd 23
    DJNZ $CAE6                          ; $CAED 10 f7
    RET                                 ; $CAEF c9
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
    LD A,($C492)                        ; $CB12 3a 92 c4
    LD HL,$A009                         ; $CB15 21 09 a0
    CP (HL)                             ; $CB18 be
    RET Z                               ; $CB19 c8
    LD A,($A034)                        ; $CB1A 3a 34 a0
    LD HL,$A036                         ; $CB1D 21 36 a0
    CP (HL)                             ; $CB20 be
    RET Z                               ; $CB21 c8
    LD DE,$68ED                         ; $CB22 11 ed 68
    JP $CBC2                            ; $CB25 c3 c2 cb
    ORG $CB2C
    LD IX,($CB28)                       ; $CB2C dd 2a 28 cb
    LD IY,($CB2A)                       ; $CB30 fd 2a 2a cb
    CALL $CB40                          ; $CB34 cd 40 cb
    LD ($CB28),IX                       ; $CB37 dd 22 28 cb
    LD ($CB2A),IY                       ; $CB3B fd 22 2a cb
    RET                                 ; $CB3F c9
    JP (HL)                             ; $CB40 e9
    XOR A                               ; $CB41 af
    RET                                 ; $CB42 c9
    PUSH HL                             ; $CB43 e5
    CALL $DC6C                          ; $CB44 cd 6c dc
    POP HL                              ; $CB47 e1
    JR NZ,$CB65                         ; $CB48 20 1b
    XOR A                               ; $CB4A af
    LD ($A036),A                        ; $CB4B 32 36 a0
    LD A,($A00B)                        ; $CB4E 3a 0b a0
    AND A                               ; $CB51 a7
    JR Z,$CB5F                          ; $CB52 28 0b
    LD A,L                              ; $CB54 7d
    OR H                                ; $CB55 b4
    JR NZ,$CB67                         ; $CB56 20 0f
    XOR A                               ; $CB58 af
    LD ($A00C),A                        ; $CB59 32 0c a0
    CALL $CA76                          ; $CB5C cd 76 ca
    LD A,($9860)                        ; $CB5F 3a 60 98
    LD ($A036),A                        ; $CB62 32 36 a0
    XOR A                               ; $CB65 af
    RET                                 ; $CB66 c9
    LD A,$01                            ; $CB67 3e 01
    LD ($A027),A                        ; $CB69 32 27 a0
    PUSH IY                             ; $CB6C fd e5
    CALL $CB40                          ; $CB6E cd 40 cb
    POP IY                              ; $CB71 fd e1
    XOR A                               ; $CB73 af
    LD ($A027),A                        ; $CB74 32 27 a0
    JR $CB5F                            ; $CB77 18 e6
    ORG $CBA7
    LD A,($B934)                        ; $CBA7 3a 34 b9
    BIT 6,A                             ; $CBAA cb 77
    RET Z                               ; $CBAC c8
    POP HL                              ; $CBAD e1
    XOR A                               ; $CBAE af
    LD ($A027),A                        ; $CBAF 32 27 a0
    LD HL,$681A                         ; $CBB2 21 1a 68
    CALL $A59F                          ; $CBB5 cd 9f a5
    JP $DC15                            ; $CBB8 c3 15 dc
    ORG $CBC2
    CP $FF                              ; $CBC2 fe ff
    RET Z                               ; $CBC4 c8
    AND A                               ; $CBC5 a7
    RET Z                               ; $CBC6 c8
    LD B,A                              ; $CBC7 47
    CALL $D495                          ; $CBC8 cd 95 d4
    LD C,A                              ; $CBCB 4f
    LD A,($A009)                        ; $CBCC 3a 09 a0
    CP C                                ; $CBCF b9
    RET NZ                              ; $CBD0 c0
    LD A,$01                            ; $CBD1 3e 01
    LD ($5C3C),A                        ; $CBD3 32 3c 5c
    PUSH DE                             ; $CBD6 d5
    LD A,B                              ; $CBD7 78
    CALL $D237                          ; $CBD8 cd 37 d2
    LD A,(IX+$01)                       ; $CBDB dd 7e 01
    CP $FF                              ; $CBDE fe ff
    JR Z,$CBE5                          ; $CBE0 28 03
    LD B,A                              ; $CBE2 47
    JR $CBD7                            ; $CBE3 18 f2
    LD A,B                              ; $CBE5 78
    CALL $A4BC                          ; $CBE6 cd bc a4
    EX (SP),HL                          ; $CBE9 e3
    LD A,($A036)                        ; $CBEA 3a 36 a0
    PUSH AF                             ; $CBED f5
    LD A,($9860)                        ; $CBEE 3a 60 98
    LD ($A036),A                        ; $CBF1 32 36 a0
    CALL $CC29                          ; $CBF4 cd 29 cc
    LD A,B                              ; $CBF7 78
    CALL $C821                          ; $CBF8 cd 21 c8
    JR NZ,$CC00                         ; $CBFB 20 03
    POP AF                              ; $CBFD f1
    POP HL                              ; $CBFE e1
    RET                                 ; $CBFF c9
    POP AF                              ; $CC00 f1
    LD ($A036),A                        ; $CC01 32 36 a0
    CALL $CC29                          ; $CC04 cd 29 cc
    CALL $A59F                          ; $CC07 cd 9f a5
    RET                                 ; $CC0A c9
    ORG $CC0E
    PUSH DE                             ; $CC0E d5
    PUSH BC                             ; $CC0F c5
    LD C,A                              ; $CC10 4f
    LD DE,$0008                         ; $CC11 11 08 00
    LD IY,$9860                         ; $CC14 fd 21 60 98
    LD A,(IY+$00)                       ; $CC18 fd 7e 00
    CP C                                ; $CC1B b9
    JR Z,$CC26                          ; $CC1C 28 08
    CP $FF                              ; $CC1E fe ff
    JR Z,$CC26                          ; $CC20 28 04
    ADD IY,DE                           ; $CC22 fd 19
    JR $CC18                            ; $CC24 18 f2
    POP BC                              ; $CC26 c1
    POP DE                              ; $CC27 d1
    RET                                 ; $CC28 c9
    LD A,($A036)                        ; $CC29 3a 36 a0
    CALL $D495                          ; $CC2C cd 95 d4
    LD ($A017),IX                       ; $CC2F dd 22 17 a0
    LD ($A00A),A                        ; $CC33 32 0a a0
    RET                                 ; $CC36 c9
    PUSH AF                             ; $CC37 f5
    XOR A                               ; $CC38 af
    LD ($CC0B),A                        ; $CC39 32 0b cc
    POP AF                              ; $CC3C f1
    CALL $CC0E                          ; $CC3D cd 0e cc
    CP $FF                              ; $CC40 fe ff
    LD HL,$0001                         ; $CC42 21 01 00
    JP Z,$CC74                          ; $CC45 ca 74 cc
    LD ($9FDB),IY                       ; $CC48 fd 22 db 9f
    LD ($A036),A                        ; $CC4C 32 36 a0
    CALL $B91F                          ; $CC4F cd 1f b9
    LD A,$00                            ; $CC52 3e 00
    JR NZ,$CC57                         ; $CC54 20 01
    INC A                               ; $CC56 3c
    LD ($CC0D),A                        ; $CC57 32 0d cc
    CALL $CC29                          ; $CC5A cd 29 cc
    CALL $D045                          ; $CC5D cd 45 d0
    SUB A                               ; $CC60 97
    LD ($5C3C),A                        ; $CC61 32 3c 5c
    LD A,($9860)                        ; $CC64 3a 60 98
    CALL $C821                          ; $CC67 cd 21 c8
    JR Z,$CC71                          ; $CC6A 28 05
    LD A,$01                            ; $CC6C 3e 01
    LD ($5C3C),A                        ; $CC6E 32 3c 5c
    LD HL,$0000                         ; $CC71 21 00 00
    LD ($A01F),HL                       ; $CC74 22 1f a0
    RET                                 ; $CC77 c9
    CALL $CC5A                          ; $CC78 cd 5a cc
    LD IY,($9FDB)                       ; $CC7B fd 2a db 9f
    CALL $D008                          ; $CC7F cd 08 d0
    LD L,(IY+$01)                       ; $CC82 fd 6e 01
    LD H,(IY+$02)                       ; $CC85 fd 66 02
    XOR A                               ; $CC88 af
    LD ($B934),A                        ; $CC89 32 34 b9
    LD A,($CC0B)                        ; $CC8C 3a 0b cc
    CP $0A                              ; $CC8F fe 0a
    JP Z,$CD8B                          ; $CC91 ca 8b cd
    LD A,(HL)                           ; $CC94 7e
    AND A                               ; $CC95 a7
    JR NZ,$CC9B                         ; $CC96 20 03
    INC HL                              ; $CC98 23
    JR $CC94                            ; $CC99 18 f9
    PUSH HL                             ; $CC9B e5
    POP IX                              ; $CC9C dd e1
    LD ($9FD9),HL                       ; $CC9E 22 d9 9f
    AND $0F                             ; $CCA1 e6 0f
    CP $0A                              ; $CCA3 fe 0a
    JR NC,$CCF3                         ; $CCA5 30 4c
    LD A,($CC0D)                        ; $CCA7 3a 0d cc
    CP $01                              ; $CCAA fe 01
    JR NZ,$CCC7                         ; $CCAC 20 19
    SUB A                               ; $CCAE 97
    LD ($CC0D),A                        ; $CCAF 32 0d cc
    LD A,(HL)                           ; $CCB2 7e
    CALL $B936                          ; $CCB3 cd 36 b9
    JP C,$CD91                          ; $CCB6 da 91 cd
    JR Z,$CCC7                          ; $CCB9 28 0c
    CALL $C4D1                          ; $CCBB cd d1 c4
    RET NC                              ; $CCBE d0
    CALL $CFB6                          ; $CCBF cd b6 cf
    LD (IX+$05),$02                     ; $CCC2 dd 36 05 02
    RET                                 ; $CCC6 c9
    LD A,(HL)                           ; $CCC7 7e
    AND $0F                             ; $CCC8 e6 0f
    CP $07                              ; $CCCA fe 07
    JP Z,$CE3B                          ; $CCCC ca 3b ce
    CP $06                              ; $CCCF fe 06
    JP Z,$CD95                          ; $CCD1 ca 95 cd
    CP $05                              ; $CCD4 fe 05
    JP Z,$CDA1                          ; $CCD6 ca a1 cd
    CP $04                              ; $CCD9 fe 04
    JP Z,$CDBF                          ; $CCDB ca bf cd
    CP $01                              ; $CCDE fe 01
    JP Z,$CE6A                          ; $CCE0 ca 6a ce
    CP $03                              ; $CCE3 fe 03
    JP Z,$CE4F                          ; $CCE5 ca 4f ce
    CP $08                              ; $CCE8 fe 08
    JR Z,$CD24                          ; $CCEA 28 38
    CP $09                              ; $CCEC fe 09
    JR Z,$CD47                          ; $CCEE 28 57
    JP $CE18                            ; $CCF0 c3 18 ce
    CP $0E                              ; $CCF3 fe 0e
    JR NZ,$CD06                         ; $CCF5 20 0f
    LD A,(IX+$01)                       ; $CCF7 dd 7e 01
    LD (IY+$01),A                       ; $CCFA fd 77 01
    LD A,(IX+$02)                       ; $CCFD dd 7e 02
    LD (IY+$02),A                       ; $CD00 fd 77 02
    JP $CC82                            ; $CD03 c3 82 cc
    CP $0C                              ; $CD06 fe 0c
    JR Z,$CD08                          ; $CD08 28 fe
    CP $0B                              ; $CD0A fe 0b
    JR NZ,$CD17                         ; $CD0C 20 09
    CALL $CFCF                          ; $CD0E cd cf cf
    CP $02                              ; $CD11 fe 02
    RET Z                               ; $CD13 c8
    JP $CE8F                            ; $CD14 c3 8f ce
    CP $0A                              ; $CD17 fe 0a
    JR NZ,$CD82                         ; $CD19 20 67
    CALL $CFCF                          ; $CD1B cd cf cf
    CP $02                              ; $CD1E fe 02
    RET Z                               ; $CD20 c8
    JP $CEB8                            ; $CD21 c3 b8 ce
    LD A,(IX+$01)                       ; $CD24 dd 7e 01
    PUSH AF                             ; $CD27 f5
    LD A,$02                            ; $CD28 3e 02
    CALL $A11C                          ; $CD2A cd 1c a1
    LD HL,($9FE7)                       ; $CD2D 2a e7 9f
    LD ($9FE7),IX                       ; $CD30 dd 22 e7 9f
    LD (IX-$02),L                       ; $CD34 dd 75 fe
    LD (IX-$01),H                       ; $CD37 dd 74 ff
    LD A,($A036)                        ; $CD3A 3a 36 a0
    LD (IX+$00),A                       ; $CD3D dd 77 00
    POP AF                              ; $CD40 f1
    LD (IX+$01),A                       ; $CD41 dd 77 01
    JP $CE8F                            ; $CD44 c3 8f ce
    LD B,(IX+$01)                       ; $CD47 dd 46 01
    LD IX,$9FE9                         ; $CD4A dd 21 e9 9f
    CALL $A0F7                          ; $CD4E cd f7 a0
    JP Z,$CEB8                          ; $CD51 ca b8 ce
    LD A,($A036)                        ; $CD54 3a 36 a0
    CP (IX+$01)                         ; $CD57 dd be 01
    JR NZ,$CD4E                         ; $CD5A 20 f2
    LD A,B                              ; $CD5C 78
    CP (IX+$00)                         ; $CD5D dd be 00
    JR NZ,$CD4E                         ; $CD60 20 ec
    PUSH IY                             ; $CD62 fd e5
    PUSH IX                             ; $CD64 dd e5
    POP DE                              ; $CD66 d1
    LD IY,$9FE7                         ; $CD67 fd 21 e7 9f
    CALL $A104                          ; $CD6B cd 04 a1
    LD L,(IX-$02)                       ; $CD6E dd 6e fe
    LD H,(IX-$01)                       ; $CD71 dd 66 ff
    LD (IY-$02),L                       ; $CD74 fd 75 fe
    LD (IY-$01),H                       ; $CD77 fd 74 ff
    CALL $A1C7                          ; $CD7A cd c7 a1
    POP IY                              ; $CD7D fd e1
    JP $CE8F                            ; $CD7F c3 8f ce
    LD HL,$0001                         ; $CD82 21 01 00
    LD ($A01F),HL                       ; $CD85 22 1f a0
    JP $CE8F                            ; $CD88 c3 8f ce
    LD HL,$0001                         ; $CD8B 21 01 00
    LD ($A01F),HL                       ; $CD8E 22 1f a0
    CALL $D026                          ; $CD91 cd 26 d0
    RET                                 ; $CD94 c9
    LD L,(IX+$01)                       ; $CD95 dd 6e 01
    LD H,(IX+$02)                       ; $CD98 dd 66 02
    CALL $A59F                          ; $CD9B cd 9f a5
    JP $CE8F                            ; $CD9E c3 8f ce
    LD L,(IX+$02)                       ; $CDA1 dd 6e 02
    LD H,(IX+$03)                       ; $CDA4 dd 66 03
    PUSH HL                             ; $CDA7 e5
    LD A,(IX+$01)                       ; $CDA8 dd 7e 01
    CALL $CEDE                          ; $CDAB cd de ce
    LD ($A034),A                        ; $CDAE 32 34 a0
    LD A,$07                            ; $CDB1 3e 07
    LD ($A00F),A                        ; $CDB3 32 0f a0
    LD HL,$6830                         ; $CDB6 21 30 68
    CALL $A59F                          ; $CDB9 cd 9f a5
    JP $CE8F                            ; $CDBC c3 8f ce
    LD A,$2E                            ; $CDBF 3e 2e
    LD ($A033),A                        ; $CDC1 32 33 a0
    LD A,(IX+$01)                       ; $CDC4 dd 7e 01
    CALL $CEDE                          ; $CDC7 cd de ce
    LD ($A034),A                        ; $CDCA 32 34 a0
    LD A,(IX+$02)                       ; $CDCD dd 7e 02
    LD ($A35D),A                        ; $CDD0 32 5d a3
    LD A,(IX+$03)                       ; $CDD3 dd 7e 03
    CALL $CEDE                          ; $CDD6 cd de ce
    LD ($A35E),A                        ; $CDD9 32 5e a3
    LD A,(IX+$04)                       ; $CDDC dd 7e 04
    CALL $CEDE                          ; $CDDF cd de ce
    LD ($A35F),A                        ; $CDE2 32 5f a3
    LD A,$08                            ; $CDE5 3e 08
    CALL $A11C                          ; $CDE7 cd 1c a1
    LD A,($A034)                        ; $CDEA 3a 34 a0
    LD (IX+$00),A                       ; $CDED dd 77 00
    LD (IX+$01),$FF                     ; $CDF0 dd 36 01 ff
    LD A,($A35D)                        ; $CDF4 3a 5d a3
    LD (IX+$02),A                       ; $CDF7 dd 77 02
    LD HL,($A35E)                       ; $CDFA 2a 5e a3
    LD (IX+$03),L                       ; $CDFD dd 75 03
    LD (IX+$04),H                       ; $CE00 dd 74 04
    LD HL,($9FEE)                       ; $CE03 2a ee 9f
    LD ($9FEE),IX                       ; $CE06 dd 22 ee 9f
    LD (IX-$02),L                       ; $CE0A dd 75 fe
    LD (IX-$01),H                       ; $CE0D dd 74 ff
    LD HL,$682A                         ; $CE10 21 2a 68
    CALL $A59F                          ; $CE13 cd 9f a5
    JR $CE8F                            ; $CE16 18 77
    LD A,(IX+$01)                       ; $CE18 dd 7e 01
    CALL $CEDE                          ; $CE1B cd de ce
    LD ($A033),A                        ; $CE1E 32 33 a0
    LD A,(IX+$02)                       ; $CE21 dd 7e 02
    CALL $CEDE                          ; $CE24 cd de ce
    LD ($A034),A                        ; $CE27 32 34 a0
    LD A,(IX+$03)                       ; $CE2A dd 7e 03
    CALL $CEDE                          ; $CE2D cd de ce
    LD ($A035),A                        ; $CE30 32 35 a0
    CALL $C4D1                          ; $CE33 cd d1 c4
    RET C                               ; $CE36 d8
    JR Z,$CEB8                          ; $CE37 28 7f
    JR $CE8F                            ; $CE39 18 54
    LD A,(IX+$03)                       ; $CE3B dd 7e 03
    CALL $CEDE                          ; $CE3E cd de ce
    LD ($A034),A                        ; $CE41 32 34 a0
    LD A,(IX+$04)                       ; $CE44 dd 7e 04
    CALL $CEDE                          ; $CE47 cd de ce
    LD ($A035),A                        ; $CE4A 32 35 a0
    JR $CE57                            ; $CE4D 18 08
    LD A,$FF                            ; $CE4F 3e ff
    LD ($A034),A                        ; $CE51 32 34 a0
    LD ($A035),A                        ; $CE54 32 35 a0
    LD A,$FF                            ; $CE57 3e ff
    LD ($A033),A                        ; $CE59 32 33 a0
    LD L,(IX+$01)                       ; $CE5C dd 6e 01
    LD H,(IX+$02)                       ; $CE5F dd 66 02
    CALL $C591                          ; $CE62 cd 91 c5
    RET C                               ; $CE65 d8
    JR Z,$CEB8                          ; $CE66 28 50
    JR $CE8F                            ; $CE68 18 25
    LD A,(IX+$01)                       ; $CE6A dd 7e 01
    CALL $CEDE                          ; $CE6D cd de ce
    LD ($A033),A                        ; $CE70 32 33 a0
    LD A,$FF                            ; $CE73 3e ff
    LD ($A034),A                        ; $CE75 32 34 a0
    LD ($A035),A                        ; $CE78 32 35 a0
    CALL $C4D1                          ; $CE7B cd d1 c4
    RET C                               ; $CE7E d8
    JR Z,$CEB8                          ; $CE7F 28 37
    JR $CE8F                            ; $CE81 18 0c
    LD IY,($9FDB)                       ; $CE83 fd 2a db 9f
    LD HL,($9FD9)                       ; $CE87 2a d9 9f
    PUSH HL                             ; $CE8A e5
    POP IX                              ; $CE8B dd e1
    LD A,(HL)                           ; $CE8D 7e
    RET                                 ; $CE8E c9
    CALL $CE83                          ; $CE8F cd 83 ce
    CALL $CF03                          ; $CE92 cd 03 cf
    BIT 7,(IX+$00)                      ; $CE95 dd cb 00 7e
    JR Z,$CEA1                          ; $CE99 28 06
    LD E,(HL)                           ; $CE9B 5e
    INC HL                              ; $CE9C 23
    LD D,(HL)                           ; $CE9D 56
    EX DE,HL                            ; $CE9E eb
    JR $CEA8                            ; $CE9F 18 07
    BIT 4,(IX+$00)                      ; $CEA1 dd cb 00 66
    CALL NZ,$CF40                       ; $CEA5 c4 40 cf
    BIT 5,(IX+$00)                      ; $CEA8 dd cb 00 6e
    CALL NZ,$CF43                       ; $CEAC c4 43 cf
    LD (IY+$01),L                       ; $CEAF fd 75 01
    LD (IY+$02),H                       ; $CEB2 fd 74 02
    JP $CD91                            ; $CEB5 c3 91 cd
    LD HL,$CC0B                         ; $CEB8 21 0b cc
    INC (HL)                            ; $CEBB 34
    CALL $CE83                          ; $CEBC cd 83 ce
    CALL $CEFE                          ; $CEBF cd fe ce
    BIT 4,(IX+$00)                      ; $CEC2 dd cb 00 66
    JR Z,$CECC                          ; $CEC6 28 04
    LD E,(HL)                           ; $CEC8 5e
    INC HL                              ; $CEC9 23
    LD D,(HL)                           ; $CECA 56
    EX DE,HL                            ; $CECB eb
    LD (IY+$01),L                       ; $CECC fd 75 01
    LD (IY+$02),H                       ; $CECF fd 74 02
    PUSH IX                             ; $CED2 dd e5
    POP DE                              ; $CED4 d1
    AND A                               ; $CED5 a7
    SBC HL,DE                           ; $CED6 ed 52
    JP Z,$CD8B                          ; $CED8 ca 8b cd
    JP $CC82                            ; $CEDB c3 82 cc
    CP $F5                              ; $CEDE fe f5
    RET C                               ; $CEE0 d8
    CP $FE                              ; $CEE1 fe fe
    RET NC                              ; $CEE3 d0
    CP $FA                              ; $CEE4 fe fa
    JR NZ,$CEEC                         ; $CEE6 20 04
    LD A,($9FD6)                        ; $CEE8 3a d6 9f
    RET                                 ; $CEEB c9
    CP $FB                              ; $CEEC fe fb
    JR NZ,$CEF4                         ; $CEEE 20 04
    LD A,($A036)                        ; $CEF0 3a 36 a0
    RET                                 ; $CEF3 c9
    CP $FC                              ; $CEF4 fe fc
    LD A,($9FD8)                        ; $CEF6 3a d8 9f
    RET Z                               ; $CEF9 c8
    LD A,($9FD7)                        ; $CEFA 3a d7 9f
    RET                                 ; $CEFD c9
    BIT 7,A                             ; $CEFE cb 7f
    CALL NZ,$CF40                       ; $CF00 c4 40 cf
    AND $0F                             ; $CF03 e6 0f
    CP $0F                              ; $CF05 fe 0f
    JR Z,$CF41                          ; $CF07 28 38
    CP $08                              ; $CF09 fe 08
    JR Z,$CF40                          ; $CF0B 28 33
    CP $09                              ; $CF0D fe 09
    JR Z,$CF40                          ; $CF0F 28 2f
    CP $01                              ; $CF11 fe 01
    JR Z,$CF40                          ; $CF13 28 2b
    CP $02                              ; $CF15 fe 02
    JR Z,$CF3E                          ; $CF17 28 25
    CP $03                              ; $CF19 fe 03
    JR Z,$CF3F                          ; $CF1B 28 22
    CP $0D                              ; $CF1D fe 0d
    JR Z,$CF40                          ; $CF1F 28 1f
    CP $0E                              ; $CF21 fe 0e
    JR Z,$CF3F                          ; $CF23 28 1a
    CP $07                              ; $CF25 fe 07
    JR Z,$CF3D                          ; $CF27 28 14
    CP $0C                              ; $CF29 fe 0c
    JR Z,$CF3D                          ; $CF2B 28 10
    CP $0B                              ; $CF2D fe 0b
    JR Z,$CF41                          ; $CF2F 28 10
    CP $0A                              ; $CF31 fe 0a
    JR Z,$CF41                          ; $CF33 28 0c
    CP $05                              ; $CF35 fe 05
    JR Z,$CF3E                          ; $CF37 28 05
    CP $04                              ; $CF39 fe 04
    JR NZ,$CF3F                         ; $CF3B 20 02
    INC HL                              ; $CF3D 23
    INC HL                              ; $CF3E 23
    INC HL                              ; $CF3F 23
    INC HL                              ; $CF40 23
    INC HL                              ; $CF41 23
    RET                                 ; $CF42 c9
    LD A,(IX+$00)                       ; $CF43 dd 7e 00
    BIT 7,A                             ; $CF46 cb 7f
    CALL NZ,$CF73                       ; $CF48 c4 73 cf
    BIT 4,A                             ; $CF4B cb 67
    CALL NZ,$CF73                       ; $CF4D c4 73 cf
    AND $0F                             ; $CF50 e6 0f
    CP $01                              ; $CF52 fe 01
    JR Z,$CF73                          ; $CF54 28 1d
    CP $02                              ; $CF56 fe 02
    JR Z,$CF6B                          ; $CF58 28 11
    CP $05                              ; $CF5A fe 05
    JR Z,$CF6B                          ; $CF5C 28 0d
    CP $07                              ; $CF5E fe 07
    JR Z,$CF68                          ; $CF60 28 06
    CP $06                              ; $CF62 fe 06
    JR Z,$CF70                          ; $CF64 28 0a
    CP $04                              ; $CF66 fe 04
    CALL Z,$CF79                        ; $CF68 cc 79 cf
    CALL Z,$CF73                        ; $CF6B cc 73 cf
    CP $03                              ; $CF6E fe 03
    CALL Z,$CF79                        ; $CF70 cc 79 cf
    LD (IX+$00),$00                     ; $CF73 dd 36 00 00
    INC IX                              ; $CF77 dd 23
    LD (IX+$00),$00                     ; $CF79 dd 36 00 00
    INC IX                              ; $CF7D dd 23
    RET                                 ; $CF7F c9
    PUSH IX                             ; $CF80 dd e5
    LD A,$07                            ; $CF82 3e 07
    CALL $A11C                          ; $CF84 cd 1c a1
    LD A,($A036)                        ; $CF87 3a 36 a0
    LD (IX+$00),A                       ; $CF8A dd 77 00
    LD (IX+$01),L                       ; $CF8D dd 75 01
    LD (IX+$02),H                       ; $CF90 dd 74 02
    LD DE,($A034)                       ; $CF93 ed 5b 34 a0
    LD (IX+$03),E                       ; $CF97 dd 73 03
    LD (IX+$04),D                       ; $CF9A dd 72 04
    LD (IX+$05),B                       ; $CF9D dd 70 05
    LD A,($9FD6)                        ; $CFA0 3a d6 9f
    LD (IX+$06),A                       ; $CFA3 dd 77 06
    LD HL,($9FE9)                       ; $CFA6 2a e9 9f
    LD ($9FE9),IX                       ; $CFA9 dd 22 e9 9f
    LD (IX-$02),L                       ; $CFAD dd 75 fe
    LD (IX-$01),H                       ; $CFB0 dd 74 ff
    POP IX                              ; $CFB3 dd e1
    RET                                 ; $CFB5 c9
    LD A,($A036)                        ; $CFB6 3a 36 a0
    LD IX,$9FEB                         ; $CFB9 dd 21 eb 9f
    PUSH AF                             ; $CFBD f5
    CALL $A0F7                          ; $CFBE cd f7 a0
    JR Z,$CFCC                          ; $CFC1 28 09
    POP AF                              ; $CFC3 f1
    CP (IX+$00)                         ; $CFC4 dd be 00
    JR NZ,$CFBD                         ; $CFC7 20 f4
    OR $01                              ; $CFC9 f6 01
    RET                                 ; $CFCB c9
    POP AF                              ; $CFCC f1
    XOR A                               ; $CFCD af
    RET                                 ; $CFCE c9
    CALL $CFB6                          ; $CFCF cd b6 cf
    LD E,(IX+$01)                       ; $CFD2 dd 5e 01
    LD D,(IX+$02)                       ; $CFD5 dd 56 02
    LD ($9FD9),DE                       ; $CFD8 ed 53 d9 9f
    LD (IY+$01),E                       ; $CFDC fd 73 01
    LD (IY+$02),D                       ; $CFDF fd 72 02
    PUSH IX                             ; $CFE2 dd e5
    POP DE                              ; $CFE4 d1
    PUSH IY                             ; $CFE5 fd e5
    LD IY,$9FE9                         ; $CFE7 fd 21 e9 9f
    CALL $A104                          ; $CFEB cd 04 a1
    LD L,(IX-$02)                       ; $CFEE dd 6e fe
    LD H,(IX-$01)                       ; $CFF1 dd 66 ff
    LD (IY-$02),L                       ; $CFF4 fd 75 fe
    LD (IY-$01),H                       ; $CFF7 fd 74 ff
    LD A,(IX+$05)                       ; $CFFA dd 7e 05
    PUSH AF                             ; $CFFD f5
    CALL $A1C7                          ; $CFFE cd c7 a1
    CALL $D008                          ; $D001 cd 08 d0
    POP AF                              ; $D004 f1
    POP IY                              ; $D005 fd e1
    RET                                 ; $D007 c9
    LD L,(IY+$04)                       ; $D008 fd 6e 04
    LD H,(IY+$05)                       ; $D00B fd 66 05
    CALL $CFB6                          ; $D00E cd b6 cf
    LD A,(IY+$03)                       ; $D011 fd 7e 03
    JR Z,$D01F                          ; $D014 28 09
    LD L,(IX+$03)                       ; $D016 dd 6e 03
    LD H,(IX+$04)                       ; $D019 dd 66 04
    LD A,(IX+$06)                       ; $D01C dd 7e 06
    LD ($9FD6),A                        ; $D01F 32 d6 9f
    LD ($9FD7),HL                       ; $D022 22 d7 9f
    RET                                 ; $D025 c9
    LD HL,($9FD7)                       ; $D026 2a d7 9f
    CALL $CFB6                          ; $D029 cd b6 cf
    LD A,($9FD6)                        ; $D02C 3a d6 9f
    JR Z,$D03B                          ; $D02F 28 0a
    LD (IX+$03),L                       ; $D031 dd 75 03
    LD (IX+$04),H                       ; $D034 dd 74 04
    LD (IX+$06),A                       ; $D037 dd 77 06
    RET                                 ; $D03A c9
    LD (IY+$03),A                       ; $D03B fd 77 03
    LD (IY+$04),L                       ; $D03E fd 75 04
    LD (IY+$05),H                       ; $D041 fd 74 05
    RET                                 ; $D044 c9
    LD A,($9860)                        ; $D045 3a 60 98
    CALL $D495                          ; $D048 cd 95 d4
    LD ($A009),A                        ; $D04B 32 09 a0
    RET                                 ; $D04E c9
    LD IX,$8B6F                         ; $D04F dd 21 6f 8b
    DEC IX                              ; $D053 dd 2b
    DEC IX                              ; $D055 dd 2b
    DEC IX                              ; $D057 dd 2b
    RET                                 ; $D059 c9
    ORG $D078
    PUSH IX                             ; $D078 dd e5
    PUSH IY                             ; $D07A fd e5
    PUSH BC                             ; $D07C c5
    LD IX,($A017)                       ; $D07D dd 2a 17 a0
    LD A,(IX+$04)                       ; $D081 dd 7e 04
    AND $80                             ; $D084 e6 80
    JR Z,$D0C6                          ; $D086 28 3e
    CALL $C86E                          ; $D088 cd 6e c8
    INC A                               ; $D08B 3c
    JR NZ,$D09E                         ; $D08C 20 10
    CALL $D33C                          ; $D08E cd 3c d3
    BIT 7,(IX+$00)                      ; $D091 dd cb 00 7e
    JR NZ,$D0C6                         ; $D095 20 2f
    CALL $C00C                          ; $D097 cd 0c c0
    CP $01                              ; $D09A fe 01
    JR NZ,$D0C6                         ; $D09C 20 28
    LD IX,$8B6F                         ; $D09E dd 21 6f 8b
    CALL $D206                          ; $D0A2 cd 06 d2
    JR Z,$D0C9                          ; $D0A5 28 22
    LD A,(IY+$00)                       ; $D0A7 fd 7e 00
    CP $01                              ; $D0AA fe 01
    JR NZ,$D0A2                         ; $D0AC 20 f4
    LD A,(IY+$05)                       ; $D0AE fd 7e 05
    XOR $B7                             ; $D0B1 ee b7
    AND $5C                             ; $D0B3 e6 5c
    JR NZ,$D0A2                         ; $D0B5 20 eb
    LD A,(IY+$04)                       ; $D0B7 fd 7e 04
    AND $80                             ; $D0BA e6 80
    JR Z,$D0A2                          ; $D0BC 28 e4
    LD A,(IX+$00)                       ; $D0BE dd 7e 00
    CALL $C821                          ; $D0C1 cd 21 c8
    JR Z,$D0A2                          ; $D0C4 28 dc
    AND A                               ; $D0C6 a7
    JR $D0CA                            ; $D0C7 18 01
    SCF                                 ; $D0C9 37
    POP BC                              ; $D0CA c1
    POP IY                              ; $D0CB fd e1
    POP IX                              ; $D0CD dd e1
    RET                                 ; $D0CF c9
    PUSH DE                             ; $D0D0 d5
    LD DE,$68DE                         ; $D0D1 11 de 68
    EX DE,HL                            ; $D0D4 eb
    SET 7,D                             ; $D0D5 cb fa
    LD (HL),D                           ; $D0D7 72
    INC HL                              ; $D0D8 23
    LD (HL),E                           ; $D0D9 73
    POP DE                              ; $D0DA d1
    RET                                 ; $D0DB c9
    ORG $D0DD
    PUSH AF                             ; $D0DD f5
    CALL $D224                          ; $D0DE cd 24 d2
    LD A,($D0DC)                        ; $D0E1 3a dc d0
    AND A                               ; $D0E4 a7
    LD HL,$68E4                         ; $D0E5 21 e4 68
    JR NZ,$D100                         ; $D0E8 20 16
    LD A,(IX+$00)                       ; $D0EA dd 7e 00
    AND $0E                             ; $D0ED e6 0e
    LD E,A                              ; $D0EF 5f
    LD D,$00                            ; $D0F0 16 00
    LD HL,$D05A                         ; $D0F2 21 5a d0
    ADD HL,DE                           ; $D0F5 19
    LD E,(HL)                           ; $D0F6 5e
    INC HL                              ; $D0F7 23
    LD D,(HL)                           ; $D0F8 56
    EX DE,HL                            ; $D0F9 eb
    CALL $D0D0                          ; $D0FA cd d0 d0
    LD HL,$68DD                         ; $D0FD 21 dd 68
    POP AF                              ; $D100 f1
    RET                                 ; $D101 c9
    CALL $D0DD                          ; $D102 cd dd d0
    PUSH IX                             ; $D105 dd e5
    PUSH IY                             ; $D107 fd e5
    PUSH BC                             ; $D109 c5
    CALL $D113                          ; $D10A cd 13 d1
    POP BC                              ; $D10D c1
    POP IY                              ; $D10E fd e1
    POP IX                              ; $D110 dd e1
    RET                                 ; $D112 c9
    LD B,A                              ; $D113 47
    CALL $D224                          ; $D114 cd 24 d2
    LD A,B                              ; $D117 78
    CALL $A277                          ; $D118 cd 77 a2
    PUSH IX                             ; $D11B dd e5
    PUSH BC                             ; $D11D c5
    PUSH HL                             ; $D11E e5
    LD A,($A036)                        ; $D11F 3a 36 a0
    CALL $C863                          ; $D122 cd 63 c8
    EX AF,AF'                           ; $D125 08
    CP $FF                              ; $D126 fe ff
    JR Z,$D167                          ; $D128 28 3d
    PUSH AF                             ; $D12A f5
    LD HL,($68DE)                       ; $D12B 2a de 68
    PUSH HL                             ; $D12E e5
    LD HL,$8000                         ; $D12F 21 00 80
    CALL $D0D0                          ; $D132 cd d0 d0
    LD HL,$68DD                         ; $D135 21 dd 68
    CALL $A59F                          ; $D138 cd 9f a5
    POP HL                              ; $D13B e1
    LD ($68DE),HL                       ; $D13C 22 de 68
    POP AF                              ; $D13F f1
    PUSH AF                             ; $D140 f5
    CALL $D237                          ; $D141 cd 37 d2
    CALL $D5D3                          ; $D144 cd d3 d5
    CALL $D3D5                          ; $D147 cd d5 d3
    POP AF                              ; $D14A f1
    PUSH AF                             ; $D14B f5
    CALL $D4CC                          ; $D14C cd cc d4
    AND A                               ; $D14F a7
    JR Z,$D163                          ; $D150 28 11
    LD C,A                              ; $D152 4f
    LD DE,$09BF                         ; $D153 11 bf 09
    CALL $A887                          ; $D156 cd 87 a8
    LD A,($A00A)                        ; $D159 3a 0a a0
    LD B,A                              ; $D15C 47
    POP AF                              ; $D15D f1
    CALL $D51A                          ; $D15E cd 1a d5
    JR $D167                            ; $D161 18 04
    CALL $A414                          ; $D163 cd 14 a4
    POP AF                              ; $D166 f1
    POP DE                              ; $D167 d1
    POP BC                              ; $D168 c1
    POP IX                              ; $D169 dd e1
    LD L,(IX+$07)                       ; $D16B dd 6e 07
    LD H,(IX+$08)                       ; $D16E dd 66 08
    CALL $D182                          ; $D171 cd 82 d1
    LD A,B                              ; $D174 78
    CALL $D60B                          ; $D175 cd 0b d6
    LD A,B                              ; $D178 78
    CALL $D68C                          ; $D179 cd 8c d6
    CALL $D4A7                          ; $D17C cd a7 d4
    JP $A2A2                            ; $D17F c3 a2 a2
    LD A,H                              ; $D182 7c
    OR L                                ; $D183 b5
    JP NZ,$A59F                         ; $D184 c2 9f a5
    EX DE,HL                            ; $D187 eb
    LD A,($A036)                        ; $D188 3a 36 a0
    PUSH AF                             ; $D18B f5
    LD A,($A036)                        ; $D18C 3a 36 a0
    CALL $C863                          ; $D18F cd 63 c8
    EX AF,AF'                           ; $D192 08
    INC A                               ; $D193 3c
    JR Z,$D19F                          ; $D194 28 09
    DEC A                               ; $D196 3d
    LD ($A036),A                        ; $D197 32 36 a0
    LD A,$01                            ; $D19A 3e 01
    LD ($A2AA),A                        ; $D19C 32 aa a2
    CALL $A59F                          ; $D19F cd 9f a5
    POP AF                              ; $D1A2 f1
    LD ($A036),A                        ; $D1A3 32 36 a0
    XOR A                               ; $D1A6 af
    LD ($A2AA),A                        ; $D1A7 32 aa a2
    CALL $D1C6                          ; $D1AA cd c6 d1
    LD A,$2E                            ; $D1AD 3e 2e
    JP $A9B7                            ; $D1AF c3 b7 a9
    LD B,A                              ; $D1B2 47
    CALL $D0DD                          ; $D1B3 cd dd d0
    EX DE,HL                            ; $D1B6 eb
    CALL $D187                          ; $D1B7 cd 87 d1
    CALL $D078                          ; $D1BA cd 78 d0
    JR NC,$D178                         ; $D1BD 30 b9
    LD HL,$68C1                         ; $D1BF 21 c1 68
    CALL $A59F                          ; $D1C2 cd 9f a5
    RET                                 ; $D1C5 c9
    LD DE,$0001                         ; $D1C6 11 01 00
    PUSH IY                             ; $D1C9 fd e5
    PUSH IX                             ; $D1CB dd e5
    POP IY                              ; $D1CD fd e1
    ADD IY,DE                           ; $D1CF fd 19
    XOR A                               ; $D1D1 af
    LD ($A028),A                        ; $D1D2 32 28 a0
    CALL $D405                          ; $D1D5 cd 05 d4
    POP IY                              ; $D1D8 fd e1
    RET                                 ; $D1DA c9
    JP (HL)                             ; $D1DB e9
    PUSH DE                             ; $D1DC d5
    LD D,A                              ; $D1DD 57
    LD A,(IX+$00)                       ; $D1DE dd 7e 00
    ADD A,$0F                           ; $D1E1 c6 0f
    LD E,A                              ; $D1E3 5f
    LD A,D                              ; $D1E4 7a
    LD D,$00                            ; $D1E5 16 00
    ADD IX,DE                           ; $D1E7 dd 19
    POP DE                              ; $D1E9 d1
    CP (IX+$00)                         ; $D1EA dd be 00
    JR Z,$D1FF                          ; $D1ED 28 10
    INC (IX+$00)                        ; $D1EF dd 34 00
    JR Z,$D201                          ; $D1F2 28 0d
    DEC (IX+$00)                        ; $D1F4 dd 35 00
    JR Z,$D204                          ; $D1F7 28 0b
    INC IX                              ; $D1F9 dd 23
    INC IX                              ; $D1FB dd 23
    JR $D1EA                            ; $D1FD 18 eb
    SCF                                 ; $D1FF 37
    RET                                 ; $D200 c9
    DEC (IX+$00)                        ; $D201 dd 35 00
    XOR A                               ; $D204 af
    RET                                 ; $D205 c9
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
    PUSH DE                             ; $D224 d5
    LD DE,$840B                         ; $D225 11 0b 84
    PUSH HL                             ; $D228 e5
    LD L,A                              ; $D229 6f
    LD H,$00                            ; $D22A 26 00
    ADD HL,HL                           ; $D22C 29
    ADD HL,DE                           ; $D22D 19
    LD E,(HL)                           ; $D22E 5e
    INC HL                              ; $D22F 23
    LD D,(HL)                           ; $D230 56
    PUSH DE                             ; $D231 d5
    POP IX                              ; $D232 dd e1
    POP HL                              ; $D234 e1
    POP DE                              ; $D235 d1
    RET                                 ; $D236 c9
    LD IX,$8B6F                         ; $D237 dd 21 6f 8b
    CALL $D34E                          ; $D23B cd 4e d3
    PUSH HL                             ; $D23E e5
    LD L,(IX+$01)                       ; $D23F dd 6e 01
    LD H,(IX+$02)                       ; $D242 dd 66 02
    EX (SP),HL                          ; $D245 e3
    POP IX                              ; $D246 dd e1
    RET                                 ; $D248 c9
    PUSH IY                             ; $D249 fd e5
    PUSH IX                             ; $D24B dd e5
    CALL $D04F                          ; $D24D cd 4f d0
    CALL $D21C                          ; $D250 cd 1c d2
    JR Z,$D267                          ; $D253 28 12
    CP (IY+$01)                         ; $D255 fd be 01
    JR NZ,$D250                         ; $D258 20 f6
    LD (IY+$0F),B                       ; $D25A fd 70 0f
    PUSH AF                             ; $D25D f5
    LD A,(IX+$00)                       ; $D25E dd 7e 00
    CALL $D249                          ; $D261 cd 49 d2
    POP AF                              ; $D264 f1
    JR $D250                            ; $D265 18 e9
    POP IX                              ; $D267 dd e1
    POP IY                              ; $D269 fd e1
    RET                                 ; $D26B c9
    PUSH HL                             ; $D26C e5
    LD A,($A034)                        ; $D26D 3a 34 a0
    CALL $D275                          ; $D270 cd 75 d2
    POP HL                              ; $D273 e1
    RET                                 ; $D274 c9
    LD HL,$A036                         ; $D275 21 36 a0
    CP $FF                              ; $D278 fe ff
    SCF                                 ; $D27A 37
    RET Z                               ; $D27B c8
    CP $FE                              ; $D27C fe fe
    SCF                                 ; $D27E 37
    RET Z                               ; $D27F c8
    PUSH IX                             ; $D280 dd e5
    CALL $D288                          ; $D282 cd 88 d2
    POP IX                              ; $D285 dd e1
    RET                                 ; $D287 c9
    CALL $D237                          ; $D288 cd 37 d2
    PUSH AF                             ; $D28B f5
    LD A,(IX+$01)                       ; $D28C dd 7e 01
    CP $FF                              ; $D28F fe ff
    JR Z,$D29A                          ; $D291 28 07
    POP IX                              ; $D293 dd e1
    CP (HL)                             ; $D295 be
    JR NZ,$D288                         ; $D296 20 f0
    SCF                                 ; $D298 37
    RET                                 ; $D299 c9
    POP AF                              ; $D29A f1
    AND A                               ; $D29B a7
    RET                                 ; $D29C c9
    LD A,$63                            ; $D29D 3e 63
    CALL $D2A4                          ; $D29F cd a4 d2
    INC A                               ; $D2A2 3c
    RET                                 ; $D2A3 c9
    CALL $D2AD                          ; $D2A4 cd ad d2
    BIT 7,A                             ; $D2A7 cb 7f
    RET Z                               ; $D2A9 c8
    NEG                                 ; $D2AA ed 44
    RET                                 ; $D2AC c9
    PUSH IX                             ; $D2AD dd e5
    PUSH BC                             ; $D2AF c5
    LD C,A                              ; $D2B0 4f
    SLA A                               ; $D2B1 cb 27
    JR NC,$D2B7                         ; $D2B3 30 02
    LD A,$FF                            ; $D2B5 3e ff
    LD B,A                              ; $D2B7 47
    LD IX,$A039                         ; $D2B8 dd 21 39 a0
    INC (IX+$01)                        ; $D2BC dd 34 01
    JR NZ,$D2C4                         ; $D2BF 20 03
    INC (IX+$00)                        ; $D2C1 dd 34 00
    LD IX,($A039)                       ; $D2C4 dd 2a 39 a0
    LD A,($A037)                        ; $D2C8 3a 37 a0
    ADC A,(IX+$00)                      ; $D2CB dd 8e 00
    ADD IX,DE                           ; $D2CE dd 19
    XOR (IX+$01)                        ; $D2D0 dd ae 01
    PUSH HL                             ; $D2D3 e5
    LD HL,$A037                         ; $D2D4 21 37 a0
    CP (HL)                             ; $D2D7 be
    POP HL                              ; $D2D8 e1
    JR Z,$D2B8                          ; $D2D9 28 dd
    LD ($A037),A                        ; $D2DB 32 37 a0
    CP B                                ; $D2DE b8
    JR C,$D2E8                          ; $D2DF 38 07
    JR Z,$D2E8                          ; $D2E1 28 05
    SRL A                               ; $D2E3 cb 3f
    JP $D2DE                            ; $D2E5 c3 de d2
    SUB C                               ; $D2E8 91
    POP BC                              ; $D2E9 c1
    POP IX                              ; $D2EA dd e1
    RET                                 ; $D2EC c9
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
    PUSH AF                             ; $D33C f5
    LD IX,($A017)                       ; $D33D dd 2a 17 a0
    LD A,(IX+$0F)                       ; $D341 dd 7e 0f
    CALL $D224                          ; $D344 cd 24 d2
    POP AF                              ; $D347 f1
    RET                                 ; $D348 c9
    EXX                                 ; $D349 d9
    LD E,$02                            ; $D34A 1e 02
    JR $D351                            ; $D34C 18 03
    EXX                                 ; $D34E d9
    LD E,$03                            ; $D34F 1e 03
    PUSH IX                             ; $D351 dd e5
    POP HL                              ; $D353 e1
    LD B,A                              ; $D354 47
    LD D,$00                            ; $D355 16 00
    LD A,(HL)                           ; $D357 7e
    CP B                                ; $D358 b8
    JR Z,$D363                          ; $D359 28 08
    CP $FF                              ; $D35B fe ff
    JR Z,$D363                          ; $D35D 28 04
    ADD HL,DE                           ; $D35F 19
    JP $D357                            ; $D360 c3 57 d3
    PUSH HL                             ; $D363 e5
    POP IX                              ; $D364 dd e1
    CP $FF                              ; $D366 fe ff
    EXX                                 ; $D368 d9
    RET                                 ; $D369 c9
    PUSH BC                             ; $D36A c5
    PUSH DE                             ; $D36B d5
    PUSH IY                             ; $D36C fd e5
    CALL $D206                          ; $D36E cd 06 d2
    JR Z,$D393                          ; $D371 28 20
    LD BC,$0007                         ; $D373 01 07 00
    PUSH IY                             ; $D376 fd e5
    ADD IY,BC                           ; $D378 fd 09
    CALL $A4E0                          ; $D37A cd e0 a4
    POP IY                              ; $D37D fd e1
    JR NZ,$D36E                         ; $D37F 20 ed
    LD A,($A038)                        ; $D381 3a 38 a0
    AND A                               ; $D384 a7
    JR NZ,$D393                         ; $D385 20 0c
    LD A,(IX+$00)                       ; $D387 dd 7e 00
    PUSH IX                             ; $D38A dd e5
    CALL $C821                          ; $D38C cd 21 c8
    POP IX                              ; $D38F dd e1
    JR Z,$D36E                          ; $D391 28 db
    LD A,(IX+$00)                       ; $D393 dd 7e 00
    POP IY                              ; $D396 fd e1
    POP DE                              ; $D398 d1
    POP BC                              ; $D399 c1
    RET                                 ; $D39A c9
    ORG $D3D5
    PUSH IX                             ; $D3D5 dd e5
    POP IY                              ; $D3D7 fd e1
    PUSH IY                             ; $D3D9 fd e5
    PUSH DE                             ; $D3DB d5
    LD DE,$0007                         ; $D3DC 11 07 00
    ADD IY,DE                           ; $D3DF fd 19
    CALL $D3E8                          ; $D3E1 cd e8 d3
    POP DE                              ; $D3E4 d1
    POP IY                              ; $D3E5 fd e1
    RET                                 ; $D3E7 c9
    PUSH AF                             ; $D3E8 f5
    PUSH DE                             ; $D3E9 d5
    LD D,(IY+$01)                       ; $D3EA fd 56 01
    LD E,(IY+$00)                       ; $D3ED fd 5e 00
    CALL $A7D0                          ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                      ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                         ; $D3F7 20 04
    XOR A                               ; $D3F9 af
    LD ($A7EA),A                        ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                      ; $D3FD fd cb ff 6e
    JR NZ,$D427                         ; $D401 20 24
    JR $D416                            ; $D403 18 11
    PUSH AF                             ; $D405 f5
    PUSH DE                             ; $D406 d5
    LD D,(IY+$01)                       ; $D407 fd 56 01
    LD E,(IY+$00)                       ; $D40A fd 5e 00
    CALL $A7D0                          ; $D40D cd d0 a7
    LD A,($A028)                        ; $D410 3a 28 a0
    AND A                               ; $D413 a7
    JR NZ,$D438                         ; $D414 20 22
    LD E,(IY+$02)                       ; $D416 fd 5e 02
    LD D,(IY+$03)                       ; $D419 fd 56 03
    RES 7,D                             ; $D41C cb ba
    BIT 7,(IY+$03)                      ; $D41E fd cb 03 7e
    LD A,$40                            ; $D422 3e 40
    CALL Z,$A815                        ; $D424 cc 15 a8
    LD E,(IY+$04)                       ; $D427 fd 5e 04
    LD D,(IY+$05)                       ; $D42A fd 56 05
    RES 7,D                             ; $D42D cb ba
    BIT 7,(IY+$05)                      ; $D42F fd cb 05 7e
    LD A,$40                            ; $D433 3e 40
    CALL Z,$A815                        ; $D435 cc 15 a8
    LD E,(IY+$00)                       ; $D438 fd 5e 00
    LD D,(IY+$01)                       ; $D43B fd 56 01
    LD A,D                              ; $D43E 7a
    OR E                                ; $D43F b3
    LD A,$50                            ; $D440 3e 50
    CALL NZ,$A815                       ; $D442 c4 15 a8
    POP DE                              ; $D445 d1
    POP AF                              ; $D446 f1
    RET                                 ; $D447 c9
    PUSH DE                             ; $D448 d5
    PUSH BC                             ; $D449 c5
    PUSH IY                             ; $D44A fd e5
    LD B,A                              ; $D44C 47
    CALL $D33C                          ; $D44D cd 3c d3
    LD DE,$0006                         ; $D450 11 06 00
    ADD IX,DE                           ; $D453 dd 19
    CALL $D206                          ; $D455 cd 06 d2
    JR Z,$D467                          ; $D458 28 0d
    LD A,(IX+$02)                       ; $D45A dd 7e 02
    AND A                               ; $D45D a7
    JR Z,$D455                          ; $D45E 28 f5
    LD A,(IX+$00)                       ; $D460 dd 7e 00
    CP B                                ; $D463 b8
    JP NZ,$D455                         ; $D464 c2 55 d4
    POP IY                              ; $D467 fd e1
    POP BC                              ; $D469 c1
    POP DE                              ; $D46A d1
    RET                                 ; $D46B c9
    PUSH AF                             ; $D46C f5
    LD A,$01                            ; $D46D 3e 01
    JR $D474                            ; $D46F 18 03
    PUSH AF                             ; $D471 f5
    LD A,$02                            ; $D472 3e 02
    LD ($D48D),A                        ; $D474 32 8d d4
    POP AF                              ; $D477 f1
    PUSH BC                             ; $D478 c5
    PUSH IY                             ; $D479 fd e5
    LD B,A                              ; $D47B 47
    PUSH DE                             ; $D47C d5
    CALL $D33C                          ; $D47D cd 3c d3
    LD DE,$0006                         ; $D480 11 06 00
    ADD IX,DE                           ; $D483 dd 19
    POP DE                              ; $D485 d1
    CALL $D206                          ; $D486 cd 06 d2
    JR Z,$D491                          ; $D489 28 06
    LD A,(IX+$02)                       ; $D48B dd 7e 02
    CP B                                ; $D48E b8
    JR NZ,$D486                         ; $D48F 20 f5
    POP IY                              ; $D491 fd e1
    POP BC                              ; $D493 c1
    RET                                 ; $D494 c9
    CP $FF                              ; $D495 fe ff
    RET Z                               ; $D497 c8
    CALL $D237                          ; $D498 cd 37 d2
    LD A,$01                            ; $D49B 3e 01
    CP (IX+$00)                         ; $D49D dd be 00
    LD A,$FF                            ; $D4A0 3e ff
    RET NZ                              ; $D4A2 c0
    LD A,(IX+$0F)                       ; $D4A3 dd 7e 0f
    RET                                 ; $D4A6 c9
    PUSH IY                             ; $D4A7 fd e5
    PUSH AF                             ; $D4A9 f5
    PUSH BC                             ; $D4AA c5
    LD A,$FF                            ; $D4AB 3e ff
    CALL $D4CC                          ; $D4AD cd cc d4
    JR Z,$D4C7                          ; $D4B0 28 15
    PUSH AF                             ; $D4B2 f5
    LD HL,$68E4                         ; $D4B3 21 e4 68
    CALL $A59F                          ; $D4B6 cd 9f a5
    POP BC                              ; $D4B9 c1
    LD C,B                              ; $D4BA 48
    LD A,$FF                            ; $D4BB 3e ff
    LD IY,($A017)                       ; $D4BD fd 2a 17 a0
    LD B,(IY+$0F)                       ; $D4C1 fd 46 0f
    CALL $D51A                          ; $D4C4 cd 1a d5
    POP BC                              ; $D4C7 c1
    POP AF                              ; $D4C8 f1
    POP IY                              ; $D4C9 fd e1
    RET                                 ; $D4CB c9
    PUSH IX                             ; $D4CC dd e5
    PUSH IY                             ; $D4CE fd e5
    PUSH HL                             ; $D4D0 e5
    PUSH BC                             ; $D4D1 c5
    CALL $D04F                          ; $D4D2 cd 4f d0
    LD B,$00                            ; $D4D5 06 00
    LD C,A                              ; $D4D7 4f
    CALL $D206                          ; $D4D8 cd 06 d2
    JR Z,$D4E6                          ; $D4DB 28 09
    LD A,C                              ; $D4DD 79
    CALL $D4EF                          ; $D4DE cd ef d4
    JR NC,$D4D8                         ; $D4E1 30 f5
    INC B                               ; $D4E3 04
    JR $D4D8                            ; $D4E4 18 f2
    LD A,B                              ; $D4E6 78
    AND A                               ; $D4E7 a7
    POP BC                              ; $D4E8 c1
    POP HL                              ; $D4E9 e1
    POP IY                              ; $D4EA fd e1
    POP IX                              ; $D4EC dd e1
    RET                                 ; $D4EE c9
    CP (IY+$01)                         ; $D4EF fd be 01
    JR NZ,$D518                         ; $D4F2 20 24
    LD A,($A036)                        ; $D4F4 3a 36 a0
    CP (IX+$00)                         ; $D4F7 dd be 00
    JR Z,$D518                          ; $D4FA 28 1c
    LD A,(IX+$00)                       ; $D4FC dd 7e 00
    CALL $C821                          ; $D4FF cd 21 c8
    JR Z,$D518                          ; $D502 28 14
    LD A,(IY+$00)                       ; $D504 fd 7e 00
    CP $02                              ; $D507 fe 02
    JR NC,$D518                         ; $D509 30 0d
    LD A,($A036)                        ; $D50B 3a 36 a0
    PUSH IX                             ; $D50E dd e5
    POP HL                              ; $D510 e1
    CALL $D278                          ; $D511 cd 78 d2
    JR C,$D518                          ; $D514 38 02
    SCF                                 ; $D516 37
    RET                                 ; $D517 c9
    AND A                               ; $D518 a7
    RET                                 ; $D519 c9
    PUSH IY                             ; $D51A fd e5
    PUSH DE                             ; $D51C d5
    PUSH BC                             ; $D51D c5
    CALL $D526                          ; $D51E cd 26 d5
    POP BC                              ; $D521 c1
    POP DE                              ; $D522 d1
    POP IY                              ; $D523 fd e1
    RET                                 ; $D525 c9
    PUSH IX                             ; $D526 dd e5
    CALL $D04F                          ; $D528 cd 4f d0
    PUSH AF                             ; $D52B f5
    CALL $D57D                          ; $D52C cd 7d d5
    JR C,$D55A                          ; $D52F 38 29
    SET 7,(IY+$06)                      ; $D531 fd cb 06 fe
    SUB A                               ; $D535 97
    LD ($A028),A                        ; $D536 32 28 a0
    CALL $D3D9                          ; $D539 cd d9 d3
    DEC C                               ; $D53C 0d
    LD A,C                              ; $D53D 79
    AND A                               ; $D53E a7
    JR NZ,$D546                         ; $D53F 20 05
    CALL $A414                          ; $D541 cd 14 a4
    JR $D557                            ; $D544 18 11
    CP $01                              ; $D546 fe 01
    JR Z,$D551                          ; $D548 28 07
    LD A,$2C                            ; $D54A 3e 2c
    CALL $A9B7                          ; $D54C cd b7 a9
    JR $D557                            ; $D54F 18 06
    LD DE,$005D                         ; $D551 11 5d 00
    CALL $A887                          ; $D554 cd 87 a8
    POP AF                              ; $D557 f1
    JR $D52B                            ; $D558 18 d1
    POP AF                              ; $D55A f1
    CALL $D04F                          ; $D55B cd 4f d0
    PUSH AF                             ; $D55E f5
    CALL $D57D                          ; $D55F cd 7d d5
    JR C,$D578                          ; $D562 38 14
    PUSH AF                             ; $D564 f5
    CALL $D4CC                          ; $D565 cd cc d4
    JR Z,$D574                          ; $D568 28 0a
    LD C,A                              ; $D56A 4f
    POP AF                              ; $D56B f1
    CALL $D590                          ; $D56C cd 90 d5
    CALL $D526                          ; $D56F cd 26 d5
    JR $D575                            ; $D572 18 01
    POP AF                              ; $D574 f1
    POP AF                              ; $D575 f1
    JR $D55E                            ; $D576 18 e6
    POP AF                              ; $D578 f1
    POP IX                              ; $D579 dd e1
    RET                                 ; $D57B c9
    POP AF                              ; $D57C f1
    CALL $D21C                          ; $D57D cd 1c d2
    JR NZ,$D584                         ; $D580 20 02
    SCF                                 ; $D582 37
    RET                                 ; $D583 c9
    PUSH AF                             ; $D584 f5
    CALL $D4EF                          ; $D585 cd ef d4
    JR NC,$D57C                         ; $D588 30 f2
    POP AF                              ; $D58A f1
    LD A,(IX+$00)                       ; $D58B dd 7e 00
    AND A                               ; $D58E a7
    RET                                 ; $D58F c9
    PUSH IX                             ; $D590 dd e5
    PUSH BC                             ; $D592 c5
    PUSH AF                             ; $D593 f5
    CALL $D237                          ; $D594 cd 37 d2
    BIT 6,(IX+$05)                      ; $D597 dd cb 05 76
    JR Z,$D5A5                          ; $D59B 28 08
    POP AF                              ; $D59D f1
    PUSH AF                             ; $D59E f5
    PUSH AF                             ; $D59F f5
    LD HL,$68B1                         ; $D5A0 21 b1 68
    JR $D5C1                            ; $D5A3 18 1c
    LD HL,$0485                         ; $D5A5 21 85 04
    DEC C                               ; $D5A8 0d
    JR Z,$D5AE                          ; $D5A9 28 03
    LD HL,$007A                         ; $D5AB 21 7a 00
    PUSH HL                             ; $D5AE e5
    CALL $D5D3                          ; $D5AF cd d3 d5
    LD A,$01                            ; $D5B2 3e 01
    LD ($A2AA),A                        ; $D5B4 32 aa a2
    CALL $D3D5                          ; $D5B7 cd d5 d3
    XOR A                               ; $D5BA af
    LD ($A2AA),A                        ; $D5BB 32 aa a2
    LD HL,$68D9                         ; $D5BE 21 d9 68
    CALL $A59F                          ; $D5C1 cd 9f a5
    POP AF                              ; $D5C4 f1
    POP BC                              ; $D5C5 c1
    POP IX                              ; $D5C6 dd e1
    RET                                 ; $D5C8 c9
    ORG $D5D3
    LD HL,$D5C9                         ; $D5D3 21 c9 d5
    LD A,(IX+$04)                       ; $D5D6 dd 7e 04
    AND $07                             ; $D5D9 e6 07
    CP $05                              ; $D5DB fe 05
    PUSH AF                             ; $D5DD f5
    DEC A                               ; $D5DE 3d
    LD E,A                              ; $D5DF 5f
    LD D,$00                            ; $D5E0 16 00
    ADD HL,DE                           ; $D5E2 19
    ADD HL,DE                           ; $D5E3 19
    CALL $A880                          ; $D5E4 cd 80 a8
    POP AF                              ; $D5E7 f1
    RET NZ                              ; $D5E8 c0
    LD DE,$08DB                         ; $D5E9 11 db 08
    JP $A887                            ; $D5EC c3 87 a8
    CALL $D224                          ; $D5EF cd 24 d2
    LD BC,$0006                         ; $D5F2 01 06 00
    ADD IX,BC                           ; $D5F5 dd 09
    LD BC,$0003                         ; $D5F7 01 03 00
    RET                                 ; $D5FA c9
    LD HL,$D064                         ; $D5FB 21 64 d0
    DEC HL                              ; $D5FE 2b
    DEC HL                              ; $D5FF 2b
    LD E,A                              ; $D600 5f
    RES 7,E                             ; $D601 cb bb
    LD D,$00                            ; $D603 16 00
    ADD HL,DE                           ; $D605 19
    ADD HL,DE                           ; $D606 19
    LD E,(HL)                           ; $D607 5e
    INC HL                              ; $D608 23
    LD D,(HL)                           ; $D609 56
    RET                                 ; $D60A c9
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
    ORG $D87D
    LD IX,($9FF0)                       ; $D87D dd 2a f0 9f
    LD HL,$0000                         ; $D881 21 00 00
    LD ($9FF0),HL                       ; $D884 22 f0 9f
    JP $A1AF                            ; $D887 c3 af a1
    ORG $DC15
    XOR A                               ; $DC15 af
    LD L,A                              ; $DC16 6f
    LD H,A                              ; $DC17 67
    RET                                 ; $DC18 c9
    ORG $DC20
    CALL $DC6C                          ; $DC20 cd 6c dc
    RET NZ                              ; $DC23 c0
    LD A,($A034)                        ; $DC24 3a 34 a0
    CALL $D46C                          ; $DC27 cd 6c d4
    LD A,(IX+$02)                       ; $DC2A dd 7e 02
    AND A                               ; $DC2D a7
    JR Z,$DC4B                          ; $DC2E 28 1b
    LD B,A                              ; $DC30 47
    LD A,($A00A)                        ; $DC31 3a 0a a0
    PUSH AF                             ; $DC34 f5
    LD A,$01                            ; $DC35 3e 01
    LD ($D0DC),A                        ; $DC37 32 dc d0
    CALL $DD0B                          ; $DC3A cd 0b dd
    LD A,($A00A)                        ; $DC3D 3a 0a a0
    CALL $D1B2                          ; $DC40 cd b2 d1
    POP BC                              ; $DC43 c1
    CALL $DD0B                          ; $DC44 cd 0b dd
    XOR A                               ; $DC47 af
    LD ($D0DC),A                        ; $DC48 32 dc d0
    OR $01                              ; $DC4B f6 01
    RET                                 ; $DC4D c9
    LD A,($A034)                        ; $DC4E 3a 34 a0
    CALL $D46C                          ; $DC51 cd 6c d4
    JP $DCDD                            ; $DC54 c3 dd dc
    ORG $DC5B
    LD A,(IX+$00)                       ; $DC5B dd 7e 00
    LD ($A033),A                        ; $DC5E 32 33 a0
    XOR A                               ; $DC61 af
    LD ($A00F),A                        ; $DC62 32 0f a0
    DEC A                               ; $DC65 3d
    LD ($A034),A                        ; $DC66 32 34 a0
    JP $DD07                            ; $DC69 c3 07 dd
    LD A,($A036)                        ; $DC6C 3a 36 a0
    CP $00                              ; $DC6F fe 00
    RET Z                               ; $DC71 c8
    CP $01                              ; $DC72 fe 01
    RET Z                               ; $DC74 c8
    CP $64                              ; $DC75 fe 64
    RET Z                               ; $DC77 c8
    OR $01                              ; $DC78 f6 01
    RET                                 ; $DC7A c9
    ORG $DC7D
    CALL $DC6C                          ; $DC7D cd 6c dc
    RET NZ                              ; $DC80 c0
    CALL $A2A2                          ; $DC81 cd a2 a2
    LD A,($A00A)                        ; $DC84 3a 0a a0
    CALL $D102                          ; $DC87 cd 02 d1
    OR $01                              ; $DC8A f6 01
    RET                                 ; $DC8C c9
    ORG $DC91
    LD IX,($A013)                       ; $DC91 dd 2a 13 a0
    LD IY,($A017)                       ; $DC95 fd 2a 17 a0
    LD A,(IY+$01)                       ; $DC99 fd 7e 01
    LD (IX+$01),A                       ; $DC9C dd 77 01
    OR $01                              ; $DC9F f6 01
    RET                                 ; $DCA1 c9
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
    ORG $DCC5
    LD IX,($A013)                       ; $DCC5 dd 2a 13 a0
    LD A,($A036)                        ; $DCC9 3a 36 a0
    LD (IX+$01),A                       ; $DCCC dd 77 01
    OR $01                              ; $DCCF f6 01
    RET                                 ; $DCD1 c9
    LD A,($A033)                        ; $DCD2 3a 33 a0
    CALL $D448                          ; $DCD5 cd 48 d4
    CP $FF                              ; $DCD8 fe ff
    JP Z,$DC15                          ; $DCDA ca 15 dc
    CALL $CBA7                          ; $DCDD cd a7 cb
    LD IY,($A017)                       ; $DCE0 fd 2a 17 a0
    LD A,(IY+$01)                       ; $DCE4 fd 7e 01
    CP $FF                              ; $DCE7 fe ff
    JP NZ,$DC15                         ; $DCE9 c2 15 dc
    LD A,(IX+$02)                       ; $DCEC dd 7e 02
    AND A                               ; $DCEF a7
    JP Z,$DC15                          ; $DCF0 ca 15 dc
    LD A,(IX+$01)                       ; $DCF3 dd 7e 01
    CALL $DD35                          ; $DCF6 cd 35 dd
    JP NZ,$DC15                         ; $DCF9 c2 15 dc
    OR $01                              ; $DCFC f6 01
    RET                                 ; $DCFE c9
    ORG $DD07
    LD A,(IX+$02)                       ; $DD07 dd 7e 02
    LD B,A                              ; $DD0A 47
    LD A,($A036)                        ; $DD0B 3a 36 a0
    PUSH AF                             ; $DD0E f5
    LD HL,$A036                         ; $DD0F 21 36 a0
    CP (HL)                             ; $DD12 be
    LD A,B                              ; $DD13 78
    JR NZ,$DD19                         ; $DD14 20 03
    LD ($A00A),A                        ; $DD16 32 0a a0
    CP $FF                              ; $DD19 fe ff
    JR NZ,$DD1E                         ; $DD1B 20 01
    XOR A                               ; $DD1D af
    LD ($DD01),A                        ; $DD1E 32 01 dd
    CALL $D224                          ; $DD21 cd 24 d2
    LD ($DCFF),IX                       ; $DD24 dd 22 ff dc
    POP AF                              ; $DD28 f1
    CALL $D237                          ; $DD29 cd 37 d2
    LD (IX+$0F),B                       ; $DD2C dd 70 0f
    CALL $D249                          ; $DD2F cd 49 d2
    OR $01                              ; $DD32 f6 01
    RET                                 ; $DD34 c9
    AND A                               ; $DD35 a7
    RET Z                               ; $DD36 c8
    PUSH IX                             ; $DD37 dd e5
    CALL $D237                          ; $DD39 cd 37 d2
    LD A,(IX+$05)                       ; $DD3C dd 7e 05
    AND $28                             ; $DD3F e6 28
    LD A,(IX+$02)                       ; $DD41 dd 7e 02
    POP IX                              ; $DD44 dd e1
    JR Z,$DD4F                          ; $DD46 28 07
    CP (IY+$02)                         ; $DD48 fd be 02
    JR C,$DD4F                          ; $DD4B 38 02
    XOR A                               ; $DD4D af
    RET                                 ; $DD4E c9
    OR $01                              ; $DD4F f6 01
    RET                                 ; $DD51 c9
    ORG $DD65
    LD A,(IX+$00)                       ; $DD65 dd 7e 00
    LD ($9FD7),A                        ; $DD68 32 d7 9f
    OR $01                              ; $DD6B f6 01
    RET                                 ; $DD6D c9
    LD A,($A034)                        ; $DD6E 3a 34 a0
    CALL $D471                          ; $DD71 cd 71 d4
    CP $FF                              ; $DD74 fe ff
    JP Z,$DC15                          ; $DD76 ca 15 dc
    LD A,(IX+$00)                       ; $DD79 dd 7e 00
    CP $0B                              ; $DD7C fe 0b
    JP NC,$DC15                         ; $DD7E d2 15 dc
    OR $01                              ; $DD81 f6 01
    RET                                 ; $DD83 c9
    ORG $DD88
    LD A,(IX+$01)                       ; $DD88 dd 7e 01
    LD ($9FD6),A                        ; $DD8B 32 d6 9f
    OR $01                              ; $DD8E f6 01
    RET                                 ; $DD90 c9
    LD IX,($A013)                       ; $DD91 dd 2a 13 a0
    LD A,(IX+$01)                       ; $DD95 dd 7e 01
    AND A                               ; $DD98 a7
    INC A                               ; $DD99 3c
    JP Z,$DC15                          ; $DD9A ca 15 dc
    RET                                 ; $DD9D c9
    ORG $DDA0
    LD A,($A034)                        ; $DDA0 3a 34 a0
    CALL $CC0E                          ; $DDA3 cd 0e cc
    CP $FF                              ; $DDA6 fe ff
    LD A,$00                            ; $DDA8 3e 00
    JR Z,$DDAE                          ; $DDAA 28 02
    LD A,$01                            ; $DDAC 3e 01
    CALL $B86A                          ; $DDAE cd 6a b8
    OR $01                              ; $DDB1 f6 01
    RET                                 ; $DDB3 c9
    ORG $DDB8
    CALL $CBA7                          ; $DDB8 cd a7 cb
    OR $01                              ; $DDBB f6 01
    RET                                 ; $DDBD c9
    ORG $DDC2
    LD A,($A034)                        ; $DDC2 3a 34 a0
    LD ($A01F),A                        ; $DDC5 32 1f a0
    OR $01                              ; $DDC8 f6 01
    RET                                 ; $DDCA c9
    ORG $DDD4
    LD HL,($A02F)                       ; $DDD4 2a 2f a0
    RES 7,H                             ; $DDD7 cb bc
    PUSH HL                             ; $DDD9 e5
    LD A,H                              ; $DDDA 7c
    AND $3F                             ; $DDDB e6 3f
    LD H,A                              ; $DDDD 67
    LD A,L                              ; $DDDE 7d
    AND $3F                             ; $DDDF e6 3f
    LD L,A                              ; $DDE1 6f
    CALL $DE48                          ; $DDE2 cd 48 de
    LD ($DDCD),HL                       ; $DDE5 22 cd dd
    LD HL,($9FDF)                       ; $DDE8 2a df 9f
    CALL $DE48                          ; $DDEB cd 48 de
    LD ($DDCB),HL                       ; $DDEE 22 cb dd
    POP HL                              ; $DDF1 e1
    LD A,$61                            ; $DDF2 3e 61
    LD ($DDCF),A                        ; $DDF4 32 cf dd
    BIT 6,H                             ; $DDF7 cb 74
    JR NZ,$DE19                         ; $DDF9 20 1e
    LD A,$70                            ; $DDFB 3e 70
    LD ($DDCF),A                        ; $DDFD 32 cf dd
    BIT 6,L                             ; $DE00 cb 75
    JR NZ,$DE19                         ; $DE02 20 15
    CALL $DE60                          ; $DE04 cd 60 de
    LD A,($9FE2)                        ; $DE07 3a e2 9f
    JR C,$DE0E                          ; $DE0A 38 02
    JR NZ,$DE16                         ; $DE0C 20 08
    CP $61                              ; $DE0E fe 61
    LD A,$70                            ; $DE10 3e 70
    JR Z,$DE16                          ; $DE12 28 02
    LD A,$61                            ; $DE14 3e 61
    LD ($DDCF),A                        ; $DE16 32 cf dd
    LD HL,($DDCD)                       ; $DE19 2a cd dd
    LD DE,($DDCB)                       ; $DE1C ed 5b cb dd
    AND A                               ; $DE20 a7
    SBC HL,DE                           ; $DE21 ed 52
    LD DE,$02D0                         ; $DE23 11 d0 02
    LD A,($9FE2)                        ; $DE26 3a e2 9f
    LD C,A                              ; $DE29 4f
    LD A,($DDCF)                        ; $DE2A 3a cf dd
    LD B,A                              ; $DE2D 47
    CALL $DE60                          ; $DE2E cd 60 de
    JR C,$DE3C                          ; $DE31 38 09
    JR Z,$DE3C                          ; $DE33 28 07
    LD A,B                              ; $DE35 78
    CP C                                ; $DE36 b9
    JR Z,$DE42                          ; $DE37 28 09
    ADD HL,DE                           ; $DE39 19
    JR $DE42                            ; $DE3A 18 06
    ADD HL,DE                           ; $DE3C 19
    LD A,B                              ; $DE3D 78
    CP C                                ; $DE3E b9
    JR NZ,$DE42                         ; $DE3F 20 01
    ADD HL,DE                           ; $DE41 19
    LD ($A01F),HL                       ; $DE42 22 1f a0
    OR $01                              ; $DE45 f6 01
    RET                                 ; $DE47 c9
    PUSH DE                             ; $DE48 d5
    PUSH BC                             ; $DE49 c5
    LD C,L                              ; $DE4A 4d
    LD B,H                              ; $DE4B 44
    LD HL,$0000                         ; $DE4C 21 00 00
    LD DE,$003C                         ; $DE4F 11 3c 00
    LD A,B                              ; $DE52 78
    CP $0C                              ; $DE53 fe 0c
    JR Z,$DE5A                          ; $DE55 28 03
    ADD HL,DE                           ; $DE57 19
    DJNZ $DE57                          ; $DE58 10 fd
    LD B,$00                            ; $DE5A 06 00
    ADD HL,BC                           ; $DE5C 09
    POP BC                              ; $DE5D c1
    POP DE                              ; $DE5E d1
    RET                                 ; $DE5F c9
    PUSH HL                             ; $DE60 e5
    PUSH DE                             ; $DE61 d5
    LD HL,($DDCD)                       ; $DE62 2a cd dd
    LD DE,($DDCB)                       ; $DE65 ed 5b cb dd
    AND A                               ; $DE69 a7
    SBC HL,DE                           ; $DE6A ed 52
    POP DE                              ; $DE6C d1
    POP HL                              ; $DE6D e1
    RET                                 ; $DE6E c9
    ORG $DE71
    CALL $A2A2                          ; $DE71 cd a2 a2
    LD HL,$68AD                         ; $DE74 21 ad 68
    CALL $A59F                          ; $DE77 cd 9f a5
    LD A,($A036)                        ; $DE7A 3a 36 a0
    CALL $D4CC                          ; $DE7D cd cc d4
    AND A                               ; $DE80 a7
    LD HL,$6900                         ; $DE81 21 00 69
    JR NZ,$DE8C                         ; $DE84 20 06
    CALL $A59F                          ; $DE86 cd 9f a5
    OR $01                              ; $DE89 f6 01
    RET                                 ; $DE8B c9
    LD C,A                              ; $DE8C 4f
    LD A,($A00A)                        ; $DE8D 3a 0a a0
    LD B,A                              ; $DE90 47
    LD A,($A036)                        ; $DE91 3a 36 a0
    CALL $D51A                          ; $DE94 cd 1a d5
    CALL $A2A2                          ; $DE97 cd a2 a2
    OR $01                              ; $DE9A f6 01
    RET                                 ; $DE9C c9
    ORG $DEA4
    LD IX,($A013)                       ; $DEA4 dd 2a 13 a0
    SET 5,(IX+$05)                      ; $DEA8 dd cb 05 ee
    OR $01                              ; $DEAC f6 01
    RET                                 ; $DEAE c9
    ORG $DEB6
    LD IX,($A013)                       ; $DEB6 dd 2a 13 a0
    RES 5,(IX+$05)                      ; $DEBA dd cb 05 ae
    OR $01                              ; $DEBE f6 01
    RET                                 ; $DEC0 c9
    ORG $DECA
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
    ORG $DF06
    LD IY,($A015)                       ; $DF06 fd 2a 15 a0
    LD IX,($A013)                       ; $DF0A dd 2a 13 a0
    LD A,($A035)                        ; $DF0E 3a 35 a0
    LD (IX+$01),A                       ; $DF11 dd 77 01
    LD A,(IY+$0F)                       ; $DF14 fd 7e 0f
    LD (IX+$0F),A                       ; $DF17 dd 77 0f
    LD B,A                              ; $DF1A 47
    LD A,($A034)                        ; $DF1B 3a 34 a0
    CALL $D249                          ; $DF1E cd 49 d2
    OR $01                              ; $DF21 f6 01
    RET                                 ; $DF23 c9
    LD A,($A034)                        ; $DF24 3a 34 a0
    LD B,A                              ; $DF27 47
    LD A,($A035)                        ; $DF28 3a 35 a0
    JP $C8C6                            ; $DF2B c3 c6 c8
    LD A,($A034)                        ; $DF2E 3a 34 a0
    CALL $C8AF                          ; $DF31 cd af c8
    JR Z,$DF3D                          ; $DF34 28 07
    LD HL,$A036                         ; $DF36 21 36 a0
    CP (HL)                             ; $DF39 be
    JP NZ,$DC15                         ; $DF3A c2 15 dc
    OR $01                              ; $DF3D f6 01
    RET                                 ; $DF3F c9
    ORG $DF49
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
    ORG $DFCC
    LD HL,$759C                         ; $DFCC 21 9c 75
    LD A,$06                            ; $DFCF 3e 06
    CALL $D237                          ; $DFD1 cd 37 d2
    LD A,($A009)                        ; $DFD4 3a 09 a0
    CP (IX+$0F)                         ; $DFD7 dd be 0f
    JP NZ,$9E74                         ; $DFDA c2 74 9e
    LD HL,$75D2                         ; $DFDD 21 d2 75
    JP $9E74                            ; $DFE0 c3 74 9e
    LD A,($A036)                        ; $DFE3 3a 36 a0
    CP $64                              ; $DFE6 fe 64
    JR $DFFD                            ; $DFE8 18 13
    ORG $DFEE
    JR $E007                            ; $DFEE 18 17
    ORG $DFF4
    LD A,$64                            ; $DFF4 3e 64
    JR $E028                            ; $DFF6 18 30
    LD A,($A036)                        ; $DFF8 3a 36 a0
    CP $01                              ; $DFFB fe 01
    JP NZ,$DC15                         ; $DFFD c2 15 dc
    OR $01                              ; $E000 f6 01
    RET                                 ; $E002 c9
    ORG $E007
    XOR A                               ; $E007 af
    CALL $E03A                          ; $E008 cd 3a e0
    LD IX,($A013)                       ; $E00B dd 2a 13 a0
    LD (IX+$01),$00                     ; $E00F dd 36 01 00
    LD A,($A00A)                        ; $E013 3a 0a a0
    LD (IX+$0F),A                       ; $E016 dd 77 0f
    OR $01                              ; $E019 f6 01
    RET                                 ; $E01B c9
    LD A,($A036)                        ; $E01C 3a 36 a0
    AND A                               ; $E01F a7
    JR $DFFD                            ; $E020 18 db
    ORG $E026
    LD A,$01                            ; $E026 3e 01
    CALL $E03A                          ; $E028 cd 3a e0
    LD IX,($A013)                       ; $E02B dd 2a 13 a0
    LD (IX+$01),$00                     ; $E02F dd 36 01 00
    LD (IX+$0F),$00                     ; $E033 dd 36 0f 00
    OR $01                              ; $E037 f6 01
    RET                                 ; $E039 c9
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
    ORG $E106
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
    ORG $E13E
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
    ORG $E1D8
    LD A,($A036)                        ; $E1D8 3a 36 a0
    CALL $E207                          ; $E1DB cd 07 e2
    JR Z,$E1FC                          ; $E1DE 28 1c
    INC IX                              ; $E1E0 dd 23
    LD A,($A035)                        ; $E1E2 3a 35 a0
    CALL $E201                          ; $E1E5 cd 01 e2
    JR Z,$E1FC                          ; $E1E8 28 12
    LD L,(IX+$01)                       ; $E1EA dd 6e 01
    LD H,(IX+$02)                       ; $E1ED dd 66 02
    PUSH AF                             ; $E1F0 f5
    PUSH HL                             ; $E1F1 e5
    LD HL,$6830                         ; $E1F2 21 30 68
    CALL $A59F                          ; $E1F5 cd 9f a5
    POP AF                              ; $E1F8 f1
    OR $01                              ; $E1F9 f6 01
    RET                                 ; $E1FB c9
    LD HL,$761D                         ; $E1FC 21 1d 76
    JR $E1F0                            ; $E1FF 18 ef
    CALL $D34E                          ; $E201 cd 4e d3
    CP $FF                              ; $E204 fe ff
    RET                                 ; $E206 c9
    LD IX,$E22A                         ; $E207 dd 21 2a e2
    CP (IX+$00)                         ; $E20B dd be 00
    JR Z,$E1F9                          ; $E20E 28 e9
    PUSH AF                             ; $E210 f5
    LD A,(IX+$00)                       ; $E211 dd 7e 00
    CP $FE                              ; $E214 fe fe
    JR Z,$E1F8                          ; $E216 28 e0
    INC A                               ; $E218 3c
    JR Z,$E227                          ; $E219 28 0c
    INC IX                              ; $E21B dd 23
    LD A,$FF                            ; $E21D 3e ff
    CALL $D34E                          ; $E21F cd 4e d3
    INC IX                              ; $E222 dd 23
    POP AF                              ; $E224 f1
    JR $E20B                            ; $E225 18 e4
    POP AF                              ; $E227 f1
    XOR A                               ; $E228 af
    RET                                 ; $E229 c9
    ORG $E28D
    LD A,($A036)                        ; $E28D 3a 36 a0
    LD HL,$A034                         ; $E290 21 34 a0
    CP (HL)                             ; $E293 be
    JP Z,$DC15                          ; $E294 ca 15 dc
    RET                                 ; $E297 c9
    LD A,($A034)                        ; $E298 3a 34 a0
    CP $1E                              ; $E29B fe 1e
    JR Z,$E2A4                          ; $E29D 28 05
    CP $21                              ; $E29F fe 21
    JP NZ,$DC15                         ; $E2A1 c2 15 dc
    LD A,($A00A)                        ; $E2A4 3a 0a a0
    LD C,$00                            ; $E2A7 0e 00
    CALL $9C07                          ; $E2A9 cd 07 9c
    JP NZ,$DC15                         ; $E2AC c2 15 dc
    LD IX,($A013)                       ; $E2AF dd 2a 13 a0
    LD A,(IX+$0F)                       ; $E2B3 dd 7e 0f
    AND A                               ; $E2B6 a7
    JP NZ,$DC15                         ; $E2B7 c2 15 dc
    LD A,($A034)                        ; $E2BA 3a 34 a0
    CALL $CFB9                          ; $E2BD cd b9 cf
    JP NZ,$DC15                         ; $E2C0 c2 15 dc
    OR $01                              ; $E2C3 f6 01
    RET                                 ; $E2C5 c9
    ORG $E2CB
    LD A,($A00A)                        ; $E2CB 3a 0a a0
    LD B,A                              ; $E2CE 47
    LD A,($A034)                        ; $E2CF 3a 34 a0
    INC A                               ; $E2D2 3c
    LD ($E2C6),A                        ; $E2D3 32 c6 e2
    DEC A                               ; $E2D6 3d
    CALL $DD0E                          ; $E2D7 cd 0e dd
    LD A,($A036)                        ; $E2DA 3a 36 a0
    LD B,A                              ; $E2DD 47
    LD A,($A034)                        ; $E2DE 3a 34 a0
    LD C,A                              ; $E2E1 4f
    LD DE,$F2B6                         ; $E2E2 11 b6 f2
    LD A,($E2C6)                        ; $E2E5 3a c6 e2
    CALL $E2EE                          ; $E2E8 cd ee e2
    OR $01                              ; $E2EB f6 01
    RET                                 ; $E2ED c9
    PUSH DE                             ; $E2EE d5
    LD D,A                              ; $E2EF 57
    LD A,B                              ; $E2F0 78
    LD ($A034),A                        ; $E2F1 32 34 a0
    LD A,C                              ; $E2F4 79
    LD ($A035),A                        ; $E2F5 32 35 a0
    LD A,($A036)                        ; $E2F8 3a 36 a0
    PUSH AF                             ; $E2FB f5
    LD A,D                              ; $E2FC 7a
    LD ($A036),A                        ; $E2FD 32 36 a0
    CALL $CC0E                          ; $E300 cd 0e cc
    LD L,(IY+$01)                       ; $E303 fd 6e 01
    LD H,(IY+$02)                       ; $E306 fd 66 02
    LD B,$02                            ; $E309 06 02
    CALL $CF80                          ; $E30B cd 80 cf
    POP AF                              ; $E30E f1
    LD ($A036),A                        ; $E30F 32 36 a0
    POP DE                              ; $E312 d1
    LD (IY+$01),E                       ; $E313 fd 73 01
    LD (IY+$02),D                       ; $E316 fd 72 02
    OR $01                              ; $E319 f6 01
    RET                                 ; $E31B c9
    LD IX,($A013)                       ; $E31C dd 2a 13 a0
    BIT 5,(IX+$06)                      ; $E320 dd cb 06 6e
    JP Z,$DC15                          ; $E324 ca 15 dc
    RET                                 ; $E327 c9
    ORG $E32C
    LD HL,$6836                         ; $E32C 21 36 68
    CALL $A59F                          ; $E32F cd 9f a5
    LD IX,($A013)                       ; $E332 dd 2a 13 a0
    LD L,(IX+$09)                       ; $E336 dd 6e 09
    LD H,(IX+$0A)                       ; $E339 dd 66 0a
    CALL $A419                          ; $E33C cd 19 a4
    CALL $A2A2                          ; $E33F cd a2 a2
    OR $01                              ; $E342 f6 01
    RET                                 ; $E344 c9
    CALL $E34F                          ; $E345 cd 4f e3
    RET Z                               ; $E348 c8
    LD A,$25                            ; $E349 3e 25
    LD ($A033),A                        ; $E34B 32 33 a0
    RET                                 ; $E34E c9
    LD A,($A036)                        ; $E34F 3a 36 a0
    CALL $E619                          ; $E352 cd 19 e6
    JR Z,$E365                          ; $E355 28 0e
    CALL $E39C                          ; $E357 cd 9c e3
    CALL $E3A9                          ; $E35A cd a9 e3
    AND A                               ; $E35D a7
    SBC HL,DE                           ; $E35E ed 52
    JR C,$E365                          ; $E360 38 03
    OR $01                              ; $E362 f6 01
    RET                                 ; $E364 c9
    LD HL,$E36A                         ; $E365 21 6a e3
    XOR A                               ; $E368 af
    RET                                 ; $E369 c9
    ORG $E374
    CALL $E34F                          ; $E374 cd 4f e3
    CALL $E38F                          ; $E377 cd 8f e3
    LD A,($A035)                        ; $E37A 3a 35 a0
    CALL $E619                          ; $E37D cd 19 e6
    JR Z,$E38C                          ; $E380 28 0a
    CALL $E39C                          ; $E382 cd 9c e3
    CALL $E3A9                          ; $E385 cd a9 e3
    ADD HL,DE                           ; $E388 19
    CALL $E38F                          ; $E389 cd 8f e3
    OR $01                              ; $E38C f6 01
    RET                                 ; $E38E c9
    RL L                                ; $E38F cb 15
    RL H                                ; $E391 cb 14
    SRL L                               ; $E393 cb 3d
    LD (IX+$09),L                       ; $E395 dd 75 09
    LD (IX+$0A),H                       ; $E398 dd 74 0a
    RET                                 ; $E39B c9
    LD L,(IX+$09)                       ; $E39C dd 6e 09
    LD H,(IX+$0A)                       ; $E39F dd 66 0a
    RL L                                ; $E3A2 cb 15
    SRA H                               ; $E3A4 cb 2c
    RR L                                ; $E3A6 cb 1d
    RET                                 ; $E3A8 c9
    LD DE,($A02F)                       ; $E3A9 ed 5b 2f a0
    RES 7,D                             ; $E3AD cb ba
    RL E                                ; $E3AF cb 13
    SRA D                               ; $E3B1 cb 2a
    RR E                                ; $E3B3 cb 1b
    OR $01                              ; $E3B5 f6 01
    RET                                 ; $E3B7 c9
    CALL $E3F5                          ; $E3B8 cd f5 e3
    RET Z                               ; $E3BB c8
    LD A,($A036)                        ; $E3BC 3a 36 a0
    PUSH AF                             ; $E3BF f5
    LD A,($A034)                        ; $E3C0 3a 34 a0
    INC A                               ; $E3C3 3c
    LD ($A036),A                        ; $E3C4 32 36 a0
    CALL $CFB6                          ; $E3C7 cd b6 cf
    EX AF,AF'                           ; $E3CA 08
    POP AF                              ; $E3CB f1
    LD ($A036),A                        ; $E3CC 32 36 a0
    EX AF,AF'                           ; $E3CF 08
    JR Z,$E3E7                          ; $E3D0 28 15
    LD A,(IX+$03)                       ; $E3D2 dd 7e 03
    CALL $D237                          ; $E3D5 cd 37 d2
    LD IY,($A017)                       ; $E3D8 fd 2a 17 a0
    LD A,(IX+$04)                       ; $E3DC dd 7e 04
    AND (IY+$04)                        ; $E3DF fd a6 04
    AND $70                             ; $E3E2 e6 70
    JP Z,$DC15                          ; $E3E4 ca 15 dc
    OR $01                              ; $E3E7 f6 01
    RET                                 ; $E3E9 c9
    ORG $E3F3
    JR $E413                            ; $E3F3 18 1e
    CALL $CBA7                          ; $E3F5 cd a7 cb
    CALL $DCA7                          ; $E3F8 cd a7 dc
    RET Z                               ; $E3FB c8
    LD IX,($A017)                       ; $E3FC dd 2a 17 a0
    LD IY,($A013)                       ; $E400 fd 2a 13 a0
    LD A,($A034)                        ; $E404 3a 34 a0
    JP $DEE4                            ; $E407 c3 e4 de
    ORG $E413
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
    ORG $E43B
    LD IY,($A013)                       ; $E43B fd 2a 13 a0
    LD A,(IY+$01)                       ; $E43F fd 7e 01
    LD IY,($A017)                       ; $E442 fd 2a 17 a0
    LD (IY+$01),A                       ; $E446 fd 77 01
    OR $01                              ; $E449 f6 01
    RET                                 ; $E44B c9
    CALL $CBA7                          ; $E44C cd a7 cb
    JP $E28D                            ; $E44F c3 8d e2
    ORG $E48A
    LD IX,($A013)                       ; $E48A dd 2a 13 a0
    LD A,(IX+$0F)                       ; $E48E dd 7e 0f
    LD ($9FD6),A                        ; $E491 32 d6 9f
    OR $01                              ; $E494 f6 01
    RET                                 ; $E496 c9
    ORG $E49B
    LD A,($A035)                        ; $E49B 3a 35 a0
    LD B,A                              ; $E49E 47
    LD A,($A034)                        ; $E49F 3a 34 a0
    LD IX,($A013)                       ; $E4A2 dd 2a 13 a0
    LD (IX+$01),$FF                     ; $E4A6 dd 36 01 ff
    CALL $DD0E                          ; $E4AA cd 0e dd
    OR $01                              ; $E4AD f6 01
    RET                                 ; $E4AF c9
    LD IX,($A013)                       ; $E4B0 dd 2a 13 a0
    BIT 6,(IX+$05)                      ; $E4B4 dd cb 05 76
    JR Z,$E4C6                          ; $E4B8 28 0c
    LD A,(IX+$0F)                       ; $E4BA dd 7e 0f
    CALL $D224                          ; $E4BD cd 24 d2
    LD A,(IX+$09)                       ; $E4C0 dd 7e 09
    LD ($A033),A                        ; $E4C3 32 33 a0
    OR $01                              ; $E4C6 f6 01
    RET                                 ; $E4C8 c9
    ORG $E4CB
    LD HL,$9C56                         ; $E4CB 21 56 9c
    LD A,($A034)                        ; $E4CE 3a 34 a0
    PUSH AF                             ; $E4D1 f5
    CP $02                              ; $E4D2 fe 02
    JR Z,$E4DE                          ; $E4D4 28 08
    CP $03                              ; $E4D6 fe 03
    JR Z,$E4DE                          ; $E4D8 28 04
    CP $04                              ; $E4DA fe 04
    JR NZ,$E4E7                         ; $E4DC 20 09
    LD HL,$7611                         ; $E4DE 21 11 76
    CALL $A59F                          ; $E4E1 cd 9f a5
    LD HL,$9C60                         ; $E4E4 21 60 9c
    LD A,($A036)                        ; $E4E7 3a 36 a0
    PUSH AF                             ; $E4EA f5
    CALL $E4FB                          ; $E4EB cd fb e4
    POP AF                              ; $E4EE f1
    POP BC                              ; $E4EF c1
    CALL $DD0E                          ; $E4F0 cd 0e dd
    LD HL,($DCFF)                       ; $E4F3 2a ff dc
    RES 6,(HL)                          ; $E4F6 cb b6
    OR $01                              ; $E4F8 f6 01
    RET                                 ; $E4FA c9
    JP (HL)                             ; $E4FB e9
    LD A,($A034)                        ; $E4FC 3a 34 a0
    CALL $E619                          ; $E4FF cd 19 e6
    JP Z,$DC15                          ; $E502 ca 15 dc
    RET                                 ; $E505 c9
    ORG $E51C
    LD A,$FE                            ; $E51C 3e fe
    LD ($9FD7),A                        ; $E51E 32 d7 9f
    LD L,(IX+$09)                       ; $E521 dd 6e 09
    LD H,(IX+$0A)                       ; $E524 dd 66 0a
    SET 7,L                             ; $E527 cb fd
    LD ($A02F),HL                       ; $E529 22 2f a0
    OR $01                              ; $E52C f6 01
    RET                                 ; $E52E c9
    ORG $E531
    LD A,$02                            ; $E531 3e 02
    CALL $A11C                          ; $E533 cd 1c a1
    LD HL,($9FE5)                       ; $E536 2a e5 9f
    LD ($9FE5),IX                       ; $E539 dd 22 e5 9f
    LD (IX-$02),L                       ; $E53D dd 75 fe
    LD (IX-$01),H                       ; $E540 dd 74 ff
    LD A,($A036)                        ; $E543 3a 36 a0
    LD (IX+$00),A                       ; $E546 dd 77 00
    LD A,($A035)                        ; $E549 3a 35 a0
    LD B,$00                            ; $E54C 06 00
    CP $FF                              ; $E54E fe ff
    JR Z,$E556                          ; $E550 28 04
    CALL $D2A4                          ; $E552 cd a4 d2
    LD B,A                              ; $E555 47
    LD A,($A034)                        ; $E556 3a 34 a0
    ADD A,B                             ; $E559 80
    LD (IX+$01),A                       ; $E55A dd 77 01
    OR $01                              ; $E55D f6 01
    RET                                 ; $E55F c9
    LD IX,$9FE7                         ; $E560 dd 21 e7 9f
    CALL $A0F7                          ; $E564 cd f7 a0
    RET Z                               ; $E567 c8
    LD A,($A036)                        ; $E568 3a 36 a0
    CP (IX+$00)                         ; $E56B dd be 00
    JR NZ,$E564                         ; $E56E 20 f4
    OR $01                              ; $E570 f6 01
    RET                                 ; $E572 c9
    CALL $E560                          ; $E573 cd 60 e5
    JP Z,$DC15                          ; $E576 ca 15 dc
    RET                                 ; $E579 c9
    ORG $E57E
    DEC (IX+$01)                        ; $E57E dd 35 01
    RET NZ                              ; $E581 c0
    CALL $E58C                          ; $E582 cd 8c e5
    JP $DC15                            ; $E585 c3 15 dc
    ORG $E58C
    PUSH IX                             ; $E58C dd e5
    POP DE                              ; $E58E d1
    LD IY,$9FE5                         ; $E58F fd 21 e5 9f
    CALL $A104                          ; $E593 cd 04 a1
    LD L,(IX-$02)                       ; $E596 dd 6e fe
    LD H,(IX-$01)                       ; $E599 dd 66 ff
    LD (IY-$02),L                       ; $E59C fd 75 fe
    LD (IY-$01),H                       ; $E59F fd 74 ff
    CALL $A1C7                          ; $E5A2 cd c7 a1
    OR $01                              ; $E5A5 f6 01
    RET                                 ; $E5A7 c9
    ORG $E5AA
    OR $01                              ; $E5AA f6 01
    RET                                 ; $E5AC c9
    ORG $E5B1
    LD IX,($A013)                       ; $E5B1 dd 2a 13 a0
    LD A,($A035)                        ; $E5B5 3a 35 a0
    CP (IX+$0F)                         ; $E5B8 dd be 0f
    JP NZ,$DC15                         ; $E5BB c2 15 dc
    OR $01                              ; $E5BE f6 01
    RET                                 ; $E5C0 c9
    ORG $E5C3
    LD A,($9860)                        ; $E5C3 3a 60 98
    CALL $D237                          ; $E5C6 cd 37 d2
    LD A,(IX+$0F)                       ; $E5C9 dd 7e 0f
    LD IX,($A017)                       ; $E5CC dd 2a 17 a0
    CP (IX+$0F)                         ; $E5D0 dd be 0f
    LD A,($A036)                        ; $E5D3 3a 36 a0
    JR $E5F0                            ; $E5D6 18 18
    ORG $E5DC
    OR $01                              ; $E5DC f6 01
    RET                                 ; $E5DE c9
    LD IX,($A013)                       ; $E5DF dd 2a 13 a0
    LD A,(IX+$0F)                       ; $E5E3 dd 7e 0f
    LD IX,($A015)                       ; $E5E6 dd 2a 15 a0
    CP (IX+$0F)                         ; $E5EA dd be 0f
    LD A,($A035)                        ; $E5ED 3a 35 a0
    JP NZ,$DC15                         ; $E5F0 c2 15 dc
    LD HL,$A034                         ; $E5F3 21 34 a0
    CP (HL)                             ; $E5F6 be
    JP Z,$DC15                          ; $E5F7 ca 15 dc
    OR $01                              ; $E5FA f6 01
    RET                                 ; $E5FC c9
    ORG $E601
    OR $01                              ; $E601 f6 01
    RET                                 ; $E603 c9
    LD A,($A036)                        ; $E604 3a 36 a0
    CALL $C863                          ; $E607 cd 63 c8
    EX AF,AF'                           ; $E60A 08
    LD B,A                              ; $E60B 47
    LD A,($A034)                        ; $E60C 3a 34 a0
    CALL $C863                          ; $E60F cd 63 c8
    EX AF,AF'                           ; $E612 08
    CP B                                ; $E613 b8
    LD A,($A036)                        ; $E614 3a 36 a0
    JR $E5F0                            ; $E617 18 d7
    LD C,A                              ; $E619 4f
    LD B,$FF                            ; $E61A 06 ff
    INC B                               ; $E61C 04
    LD A,B                              ; $E61D 78
    CP $6E                              ; $E61E fe 6e
    RET Z                               ; $E620 c8
    CALL $D237                          ; $E621 cd 37 d2
    LD A,(IX+$01)                       ; $E624 dd 7e 01
    CP C                                ; $E627 b9
    JR NZ,$E61C                         ; $E628 20 f2
    LD HL,$0575                         ; $E62A 21 75 05
    LD A,(IX+$07)                       ; $E62D dd 7e 07
    CP L                                ; $E630 bd
    JR NZ,$E61C                         ; $E631 20 e9
    LD A,(IX+$08)                       ; $E633 dd 7e 08
    AND $0F                             ; $E636 e6 0f
    CP H                                ; $E638 bc
    JR NZ,$E61C                         ; $E639 20 e1
    OR $01                              ; $E63B f6 01
    RET                                 ; $E63D c9
    ORG $E642
    LD A,($A036)                        ; $E642 3a 36 a0
    CALL $E619                          ; $E645 cd 19 e6
    JP Z,$DC15                          ; $E648 ca 15 dc
    CALL $E39C                          ; $E64B cd 9c e3
    BIT 7,H                             ; $E64E cb 7c
    JP Z,$DC15                          ; $E650 ca 15 dc
    RET                                 ; $E653 c9
    ORG $E658
    LD A,($A036)                        ; $E658 3a 36 a0
    CALL $E619                          ; $E65B cd 19 e6
    JP Z,$DC15                          ; $E65E ca 15 dc
    CALL $E39C                          ; $E661 cd 9c e3
    BIT 7,H                             ; $E664 cb 7c
    JP NZ,$DC15                         ; $E666 c2 15 dc
    LD A,H                              ; $E669 7c
    OR L                                ; $E66A b5
    JP Z,$DC15                          ; $E66B ca 15 dc
    RET                                 ; $E66E c9
    ORG $E673
    LD A,($A036)                        ; $E673 3a 36 a0
    CALL $E619                          ; $E676 cd 19 e6
    JR Z,$E683                          ; $E679 28 08
    CALL $E39C                          ; $E67B cd 9c e3
    LD A,H                              ; $E67E 7c
    OR L                                ; $E67F b5
    JP NZ,$DC15                         ; $E680 c2 15 dc
    OR $01                              ; $E683 f6 01
    RET                                 ; $E685 c9
    CALL $D29D                          ; $E686 cd 9d d2
    CP $32                              ; $E689 fe 32
    JP C,$DC15                          ; $E68B da 15 dc
    OR $01                              ; $E68E f6 01
    RET                                 ; $E690 c9
    CALL $E686                          ; $E691 cd 86 e6
    RET Z                               ; $E694 c8
    CALL $D29D                          ; $E695 cd 9d d2
    LD B,A                              ; $E698 47
    LD IX,$9FF6                         ; $E699 dd 21 f6 9f
    DJNZ $E6A6                          ; $E69D 10 07
    CALL $A0F7                          ; $E69F cd f7 a0
    JR Z,$E699                          ; $E6A2 28 f5
    JR $E69D                            ; $E6A4 18 f7
    PUSH IX                             ; $E6A6 dd e5
    POP HL                              ; $E6A8 e1
    LD DE,$9FF6                         ; $E6A9 11 f6 9f
    AND A                               ; $E6AC a7
    SBC HL,DE                           ; $E6AD ed 52
    JR Z,$E6B9                          ; $E6AF 28 08
    PUSH IX                             ; $E6B1 dd e5
    LD HL,$6F80                         ; $E6B3 21 80 6f
    CALL $A59F                          ; $E6B6 cd 9f a5
    OR $01                              ; $E6B9 f6 01
    RET                                 ; $E6BB c9
    ORG $E6BE
    LD A,($A035)                        ; $E6BE 3a 35 a0
    CALL $E619                          ; $E6C1 cd 19 e6
    JR Z,$E6E3                          ; $E6C4 28 1d
    LD E,(IX+$09)                       ; $E6C6 dd 5e 09
    LD D,(IX+$0A)                       ; $E6C9 dd 56 0a
    LD HL,$6BB7                         ; $E6CC 21 b7 6b
    CALL $A59F                          ; $E6CF cd 9f a5
    LD HL,$0000                         ; $E6D2 21 00 00
    AND A                               ; $E6D5 a7
    SBC HL,DE                           ; $E6D6 ed 52
    CALL $A419                          ; $E6D8 cd 19 a4
    LD A,$22                            ; $E6DB 3e 22
    CALL $A9B7                          ; $E6DD cd b7 a9
    CALL $A2A2                          ; $E6E0 cd a2 a2
    OR $01                              ; $E6E3 f6 01
    RET                                 ; $E6E5 c9
    ORG $E6EA
    CALL $CFB6                          ; $E6EA cd b6 cf
    LD A,($A034)                        ; $E6ED 3a 34 a0
    LD (IX+$03),A                       ; $E6F0 dd 77 03
    OR $01                              ; $E6F3 f6 01
    RET                                 ; $E6F5 c9
    LD A,($A036)                        ; $E6F6 3a 36 a0
    LD HL,$A034                         ; $E6F9 21 34 a0
    CP (HL)                             ; $E6FC be
    JP Z,$DC15                          ; $E6FD ca 15 dc
    DEC A                               ; $E700 3d
    LD IX,($A013)                       ; $E701 dd 2a 13 a0
    CP (IX+$01)                         ; $E705 dd be 01
    JP NZ,$DC15                         ; $E708 c2 15 dc
    OR $01                              ; $E70B f6 01
    RET                                 ; $E70D c9
    ORG $E710
    LD A,($5C3C)                        ; $E710 3a 3c 5c
    PUSH AF                             ; $E713 f5
    CALL $CFB6                          ; $E714 cd b6 cf
    LD A,(IX+$03)                       ; $E717 dd 7e 03
    AND A                               ; $E71A a7
    LD HL,$6C54                         ; $E71B 21 54 6c
    JR NZ,$E725                         ; $E71E 20 05
    LD A,$01                            ; $E720 3e 01
    LD ($5C3C),A                        ; $E722 32 3c 5c
    CALL $A59F                          ; $E725 cd 9f a5
    POP AF                              ; $E728 f1
    LD ($5C3C),A                        ; $E729 32 3c 5c
    OR $01                              ; $E72C f6 01
    RET                                 ; $E72E c9
    ORG $E7E4
    OR $01                              ; $E7E4 f6 01
    RET                                 ; $E7E6 c9
    ORG $EAF8
    LD A,($A034)                        ; $EAF8 3a 34 a0
    LD IX,($A015)                       ; $EAFB dd 2a 15 a0
    LD (IX+$01),A                       ; $EAFF dd 77 01
    LD (IX+$0F),$32                     ; $EB02 dd 36 0f 32
    LD IX,($A013)                       ; $EB06 dd 2a 13 a0
    LD (IX+$0F),$32                     ; $EB0A dd 36 0f 32
    OR $01                              ; $EB0E f6 01
    RET                                 ; $EB10 c9
    ORG $EB13
    LD IX,$99A9                         ; $EB13 dd 21 a9 99
    JR $EB1F                            ; $EB17 18 06
    ORG $EB1B
    LD IX,$9997                         ; $EB1B dd 21 97 99
    LD HL,$0000                         ; $EB1F 21 00 00
    AND A                               ; $EB22 a7
    BIT 1,(IX+$03)                      ; $EB23 dd cb 03 4e
    RET                                 ; $EB27 c9
    ORG $EBD7
    LD A,($A034)                        ; $EBD7 3a 34 a0
    INC A                               ; $EBDA 3c
    LD ($9FD6),A                        ; $EBDB 32 d6 9f
    OR $01                              ; $EBDE f6 01
    RET                                 ; $EBE0 c9
    ORG $ED3B
    LD DE,$050B                         ; $ED3B 11 0b 05
    LD HL,$6D6A                         ; $ED3E 21 6a 6d
    LD B,$10                            ; $ED41 06 10
    CALL $F1B2                          ; $ED43 cd b2 f1
    SET 6,(IX+$05)                      ; $ED46 dd cb 05 f6
    RET                                 ; $ED4A c9
    ORG $EF9E
    LD HL,$75E8                         ; $EF9E 21 e8 75
    LD A,$01                            ; $EFA1 3e 01
    LD ($5C3C),A                        ; $EFA3 32 3c 5c
    CALL $A59F                          ; $EFA6 cd 9f a5
    OR $01                              ; $EFA9 f6 01
    RET                                 ; $EFAB c9
    ORG $EFAE
    LD HL,$7603                         ; $EFAE 21 03 76
    JR $EFA1                            ; $EFB1 18 ee
    ORG $EFB5
    LD DE,$07F0                         ; $EFB5 11 f0 07
    LD B,$10                            ; $EFB8 06 10
    LD A,($A036)                        ; $EFBA 3a 36 a0
    CALL $F1C1                          ; $EFBD cd c1 f1
    RES 6,(IX+$05)                      ; $EFC0 dd cb 05 b6
    OR $01                              ; $EFC4 f6 01
    RET                                 ; $EFC6 c9
    ORG $EFC9
    LD A,($A009)                        ; $EFC9 3a 09 a0
    CP $23                              ; $EFCC fe 23
    JR Z,$EFE6                          ; $EFCE 28 16
    CP $21                              ; $EFD0 fe 21
    JR Z,$EFE6                          ; $EFD2 28 12
    CP $22                              ; $EFD4 fe 22
    JR Z,$EFE6                          ; $EFD6 28 0e
    CP $26                              ; $EFD8 fe 26
    JR Z,$EFE6                          ; $EFDA 28 0a
    CP $25                              ; $EFDC fe 25
    JR Z,$EFE6                          ; $EFDE 28 06
    CP $24                              ; $EFE0 fe 24
    JR Z,$EFE6                          ; $EFE2 28 02
    CP $27                              ; $EFE4 fe 27
    JP Z,$DFCC                          ; $EFE6 ca cc df
    LD DE,$0000                         ; $EFE9 11 00 00
    LD B,$80                            ; $EFEC 06 80
    CALL $EFBA                          ; $EFEE cd ba ef
    SET 6,(IX+$05)                      ; $EFF1 dd cb 05 f6
    RET                                 ; $EFF5 c9
    ORG $F105
    LD IX,$996F                         ; $F105 dd 21 6f 99
    SET 1,(IX+$03)                      ; $F109 dd cb 03 ce
    OR $01                              ; $F10D f6 01
    RET                                 ; $F10F c9
    ORG $F19A
    CALL $D29D                          ; $F19A cd 9d d2
    LD B,A                              ; $F19D 47
    LD A,($A034)                        ; $F19E 3a 34 a0
    CP B                                ; $F1A1 b8
    JP C,$DC15                          ; $F1A2 da 15 dc
    OR $01                              ; $F1A5 f6 01
    RET                                 ; $F1A7 c9
    ORG $F1AA
    LD HL,$6D5D                         ; $F1AA 21 5d 6d
    LD DE,$0910                         ; $F1AD 11 10 09
    LD B,$20                            ; $F1B0 06 20
    LD A,$0B                            ; $F1B2 3e 0b
    CALL $F1C1                          ; $F1B4 cd c1 f1
    RES 6,(IX+$05)                      ; $F1B7 dd cb 05 b6
    CALL $A59F                          ; $F1BB cd 9f a5
    OR $01                              ; $F1BE f6 01
    RET                                 ; $F1C0 c9
    CALL $D237                          ; $F1C1 cd 37 d2
    LD (IX+$09),E                       ; $F1C4 dd 73 09
    LD (IX+$0A),D                       ; $F1C7 dd 72 0a
    LD A,(IX+$08)                       ; $F1CA dd 7e 08
    AND $0F                             ; $F1CD e6 0f
    OR B                                ; $F1CF b0
    LD (IX+$08),A                       ; $F1D0 dd 77 08
    OR $01                              ; $F1D3 f6 01
    RET                                 ; $F1D5 c9
    ORG $F1D8
    LD A,($A034)                        ; $F1D8 3a 34 a0
    LD B,$61                            ; $F1DB 06 61
    CP $0D                              ; $F1DD fe 0d
    JR C,$F1E5                          ; $F1DF 38 04
    LD B,$70                            ; $F1E1 06 70
    SUB $0C                             ; $F1E3 d6 0c
    LD HL,$9FE0                         ; $F1E5 21 e0 9f
    CP (HL)                             ; $F1E8 be
    JP NZ,$DC15                         ; $F1E9 c2 15 dc
    LD A,($9FE2)                        ; $F1EC 3a e2 9f
    CP B                                ; $F1EF b8
    JP NZ,$DC15                         ; $F1F0 c2 15 dc
    OR $01                              ; $F1F3 f6 01
    RET                                 ; $F1F5 c9
    ORG $F1F8
    LD IX,($A013)                       ; $F1F8 dd 2a 13 a0
    SET 7,(IX+$05)                      ; $F1FC dd cb 05 fe
    OR $01                              ; $F200 f6 01
    RET                                 ; $F202 c9
    ORG $F205
    LD IX,($A013)                       ; $F205 dd 2a 13 a0
    RES 0,(IX+$05)                      ; $F209 dd cb 05 86
    OR $01                              ; $F20D f6 01
    RET                                 ; $F20F c9
    ORG $F212
    LD IX,($A013)                       ; $F212 dd 2a 13 a0
    SET 0,(IX+$05)                      ; $F216 dd cb 05 c6
    OR $01                              ; $F21A f6 01
    RET                                 ; $F21C c9
    ORG $F389
    LD IX,($A013)                       ; $F389 dd 2a 13 a0
    LD A,($A036)                        ; $F38D 3a 36 a0
    DEC A                               ; $F390 3d
    CP (IX+$01)                         ; $F391 dd be 01
    JP NZ,$DC15                         ; $F394 c2 15 dc
    LD HL,$A034                         ; $F397 21 34 a0
    INC A                               ; $F39A 3c
    CP (HL)                             ; $F39B be
    JP Z,$DC15                          ; $F39C ca 15 dc
    OR $01                              ; $F39F f6 01
    RET                                 ; $F3A1 c9
    ORG $F3C2
    PUSH IY                             ; $F3C2 fd e5
    PUSH HL                             ; $F3C4 e5
    PUSH HL                             ; $F3C5 e5
    POP IY                              ; $F3C6 fd e1
    PUSH DE                             ; $F3C8 d5
    PUSH BC                             ; $F3C9 c5
    LD D,$7F                            ; $F3CA 16 7f
    LD E,$3F                            ; $F3CC 1e 3f
    LD B,$01                            ; $F3CE 06 01
    LD C,$01                            ; $F3D0 0e 01
    LD L,$01                            ; $F3D2 2e 01
    LD A,(IY+$00)                       ; $F3D4 fd 7e 00
    AND A                               ; $F3D7 a7
    JP Z,$F488                          ; $F3D8 ca 88 f4
    INC IY                              ; $F3DB fd 23
    CP $08                              ; $F3DD fe 08
    JR NZ,$F3EF                         ; $F3DF 20 0e
    LD D,(IY+$00)                       ; $F3E1 fd 56 00
    SET 7,D                             ; $F3E4 cb fa
    INC IY                              ; $F3E6 fd 23
    LD E,(IY+$00)                       ; $F3E8 fd 5e 00
    INC IY                              ; $F3EB fd 23
    JR $F3D4                            ; $F3ED 18 e5
    BIT 7,A                             ; $F3EF cb 7f
    JR Z,$F414                          ; $F3F1 28 21
    LD B,A                              ; $F3F3 47
    AND $07                             ; $F3F4 e6 07
    LD C,A                              ; $F3F6 4f
    LD A,B                              ; $F3F7 78
    RRCA                                ; $F3F8 0f
    AND $3C                             ; $F3F9 e6 3c
    LD B,A                              ; $F3FB 47
    LD A,(IY+$00)                       ; $F3FC fd 7e 00
    AND $3F                             ; $F3FF e6 3f
    LD L,A                              ; $F401 6f
    INC L                               ; $F402 2c
    LD A,(IY+$00)                       ; $F403 fd 7e 00
    INC IY                              ; $F406 fd 23
    RLCA                                ; $F408 07
    RLCA                                ; $F409 07
    AND $03                             ; $F40A e6 03
    OR B                                ; $F40C b0
    LD B,A                              ; $F40D 47
    INC B                               ; $F40E 04
    CALL $F56E                          ; $F40F cd 6e f5
    JR $F3D4                            ; $F412 18 c0
    BIT 6,A                             ; $F414 cb 77
    JR Z,$F42E                          ; $F416 28 16
    AND $07                             ; $F418 e6 07
    PUSH DE                             ; $F41A d5
    LD D,(IY+$00)                       ; $F41B fd 56 00
    SET 7,D                             ; $F41E cb fa
    INC IY                              ; $F420 fd 23
    LD E,(IY+$00)                       ; $F422 fd 5e 00
    INC IY                              ; $F425 fd 23
    CALL $F490                          ; $F427 cd 90 f4
    POP DE                              ; $F42A d1
    JP $F3D4                            ; $F42B c3 d4 f3
    BIT 5,A                             ; $F42E cb 6f
    JP Z,$F3D4                          ; $F430 ca d4 f3
    AND $07                             ; $F433 e6 07
    RLCA                                ; $F435 07
    RLCA                                ; $F436 07
    RLCA                                ; $F437 07
    PUSH HL                             ; $F438 e5
    PUSH DE                             ; $F439 d5
    PUSH BC                             ; $F43A c5
    LD C,A                              ; $F43B 4f
    LD H,(IY+$00)                       ; $F43C fd 66 00
    INC IY                              ; $F43F fd 23
    LD A,(IY+$00)                       ; $F441 fd 7e 00
    ADD A,$10                           ; $F444 c6 10
    LD L,A                              ; $F446 6f
    INC IY                              ; $F447 fd 23
    LD A,(IY+$00)                       ; $F449 fd 7e 00
    INC IY                              ; $F44C fd 23
    CP $FF                              ; $F44E fe ff
    JR Z,$F482                          ; $F450 28 30
    LD B,A                              ; $F452 47
    AND $03                             ; $F453 e6 03
    LD E,A                              ; $F455 5f
    LD A,B                              ; $F456 78
    RRCA                                ; $F457 0f
    RRCA                                ; $F458 0f
    AND $3F                             ; $F459 e6 3f
    INC A                               ; $F45B 3c
    LD B,A                              ; $F45C 47
    LD A,(HL)                           ; $F45D 7e
    AND $07                             ; $F45E e6 07
    RLCA                                ; $F460 07
    RLCA                                ; $F461 07
    RLCA                                ; $F462 07
    CP C                                ; $F463 b9
    JR NZ,$F468                         ; $F464 20 02
    XOR $38                             ; $F466 ee 38
    RRCA                                ; $F468 0f
    RRCA                                ; $F469 0f
    RRCA                                ; $F46A 0f
    OR C                                ; $F46B b1
    LD (HL),A                           ; $F46C 77
    LD A,E                              ; $F46D 7b
    AND A                               ; $F46E a7
    CALL Z,$F514                        ; $F46F cc 14 f5
    DEC A                               ; $F472 3d
    CALL Z,$F540                        ; $F473 cc 40 f5
    DEC A                               ; $F476 3d
    CALL Z,$F525                        ; $F477 cc 25 f5
    DEC A                               ; $F47A 3d
    CALL Z,$F536                        ; $F47B cc 36 f5
    DJNZ $F45D                          ; $F47E 10 dd
    JR $F449                            ; $F480 18 c7
    POP BC                              ; $F482 c1
    POP DE                              ; $F483 d1
    POP HL                              ; $F484 e1
    JP $F3D4                            ; $F485 c3 d4 f3
    POP BC                              ; $F488 c1
    POP DE                              ; $F489 d1
    POP HL                              ; $F48A e1
    POP IY                              ; $F48B fd e1
    RET                                 ; $F48D c9
    ORG $F490
    LD ($F60B),A                        ; $F490 32 0b f6
    PUSH DE                             ; $F493 d5
    PUSH HL                             ; $F494 e5
    LD HL,$00B0                         ; $F495 21 b0 00
    PUSH HL                             ; $F498 e5
    CALL $F50D                          ; $F499 cd 0d f5
    JR NZ,$F4A5                         ; $F49C 20 07
    CALL $F565                          ; $F49E cd 65 f5
    JR NZ,$F499                         ; $F4A1 20 f6
    JR $F4AB                            ; $F4A3 18 06
    CALL $F5D2                          ; $F4A5 cd d2 f5
    CALL $F55E                          ; $F4A8 cd 5e f5
    LD HL,$0000                         ; $F4AB 21 00 00
    LD ($F48E),HL                       ; $F4AE 22 8e f4
    CALL $F54A                          ; $F4B1 cd 4a f5
    LD A,$00                            ; $F4B4 3e 00
    JR Z,$F4CD                          ; $F4B6 28 15
    CALL $F50D                          ; $F4B8 cd 0d f5
    LD A,$00                            ; $F4BB 3e 00
    JR NZ,$F4C8                         ; $F4BD 20 09
    LD A,($F48E)                        ; $F4BF 3a 8e f4
    AND A                               ; $F4C2 a7
    JR NZ,$F4C8                         ; $F4C3 20 03
    PUSH DE                             ; $F4C5 d5
    LD A,$01                            ; $F4C6 3e 01
    PUSH AF                             ; $F4C8 f5
    CALL $F555                          ; $F4C9 cd 55 f5
    POP AF                              ; $F4CC f1
    LD ($F48E),A                        ; $F4CD 32 8e f4
    CALL $F555                          ; $F4D0 cd 55 f5
    LD A,$00                            ; $F4D3 3e 00
    JR Z,$F4EC                          ; $F4D5 28 15
    CALL $F50D                          ; $F4D7 cd 0d f5
    LD A,$00                            ; $F4DA 3e 00
    JR NZ,$F4E7                         ; $F4DC 20 09
    LD A,($F48F)                        ; $F4DE 3a 8f f4
    AND A                               ; $F4E1 a7
    JR NZ,$F4E7                         ; $F4E2 20 03
    PUSH DE                             ; $F4E4 d5
    LD A,$01                            ; $F4E5 3e 01
    PUSH AF                             ; $F4E7 f5
    CALL $F54A                          ; $F4E8 cd 4a f5
    POP AF                              ; $F4EB f1
    LD ($F48F),A                        ; $F4EC 32 8f f4
    CALL $F5D2                          ; $F4EF cd d2 f5
    CALL $F55E                          ; $F4F2 cd 5e f5
    JR Z,$F4FF                          ; $F4F5 28 08
    CALL $F50D                          ; $F4F7 cd 0d f5
    JR Z,$F4B1                          ; $F4FA 28 b5
    CALL $F5D2                          ; $F4FC cd d2 f5
    POP DE                              ; $F4FF d1
    LD A,E                              ; $F500 7b
    CP $B0                              ; $F501 fe b0
    JR NZ,$F499                         ; $F503 20 94
    LD A,$00                            ; $F505 3e 00
    LD ($F60B),A                        ; $F507 32 0b f6
    POP HL                              ; $F50A e1
    POP DE                              ; $F50B d1
    RET                                 ; $F50C c9
    PUSH HL                             ; $F50D e5
    CALL $F5FB                          ; $F50E cd fb f5
    AND (HL)                            ; $F511 a6
    POP HL                              ; $F512 e1
    RET                                 ; $F513 c9
    PUSH AF                             ; $F514 f5
    PUSH DE                             ; $F515 d5
    LD DE,$0020                         ; $F516 11 20 00
    AND A                               ; $F519 a7
    SBC HL,DE                           ; $F51A ed 52
    LD A,H                              ; $F51C 7c
    CP $57                              ; $F51D fe 57
    JR NZ,$F522                         ; $F51F 20 01
    ADD HL,DE                           ; $F521 19
    POP DE                              ; $F522 d1
    POP AF                              ; $F523 f1
    RET                                 ; $F524 c9
    PUSH AF                             ; $F525 f5
    PUSH DE                             ; $F526 d5
    LD DE,$0020                         ; $F527 11 20 00
    ADD HL,DE                           ; $F52A 19
    LD A,H                              ; $F52B 7c
    CP $5A                              ; $F52C fe 5a
    JR NZ,$F532                         ; $F52E 20 02
    AND A                               ; $F530 a7
    SBC HL,DE                           ; $F531 ed 52
    ORG $F532
    LD D,D                              ; $F532 52
    POP DE                              ; $F533 d1
    POP AF                              ; $F534 f1
    RET                                 ; $F535 c9
    PUSH AF                             ; $F536 f5
    DEC HL                              ; $F537 2b
    LD A,H                              ; $F538 7c
    CP $57                              ; $F539 fe 57
    JR NZ,$F53E                         ; $F53B 20 01
    INC HL                              ; $F53D 23
    POP AF                              ; $F53E f1
    RET                                 ; $F53F c9
    PUSH AF                             ; $F540 f5
    INC HL                              ; $F541 23
    LD A,H                              ; $F542 7c
    CP $5A                              ; $F543 fe 5a
    JR NZ,$F548                         ; $F545 20 01
    DEC HL                              ; $F547 2b
    POP AF                              ; $F548 f1
    RET                                 ; $F549 c9
    INC E                               ; $F54A 1c
    LD H,A                              ; $F54B 67
    LD A,E                              ; $F54C 7b
    CP $B0                              ; $F54D fe b0
    LD A,H                              ; $F54F 7c
    RET NZ                              ; $F550 c0
    DEC E                               ; $F551 1d
    XOR A                               ; $F552 af
    LD A,H                              ; $F553 7c
    RET                                 ; $F554 c9
    DEC E                               ; $F555 1d
    LD H,A                              ; $F556 67
    LD A,E                              ; $F557 7b
    CP $FF                              ; $F558 fe ff
    LD A,H                              ; $F55A 7c
    RET NZ                              ; $F55B c0
    INC E                               ; $F55C 1c
    RET                                 ; $F55D c9
    INC D                               ; $F55E 14
    RET NZ                              ; $F55F c0
    DEC D                               ; $F560 15
    LD H,A                              ; $F561 67
    XOR A                               ; $F562 af
    LD A,H                              ; $F563 7c
    RET                                 ; $F564 c9
    DEC D                               ; $F565 15
    BIT 7,D                             ; $F566 cb 7a
    RET NZ                              ; $F568 c0
    INC D                               ; $F569 14
    LD H,A                              ; $F56A 67
    XOR A                               ; $F56B af
    LD A,H                              ; $F56C 7c
    RET                                 ; $F56D c9
    BIT 0,C                             ; $F56E cb 41
    JR NZ,$F5A2                         ; $F570 20 30
    PUSH HL                             ; $F572 e5
    PUSH BC                             ; $F573 c5
    CALL $F5D2                          ; $F574 cd d2 f5
    BIT 2,C                             ; $F577 cb 51
    JR Z,$F582                          ; $F579 28 07
    CALL $F565                          ; $F57B cd 65 f5
    JR Z,$F59F                          ; $F57E 28 1f
    JR $F587                            ; $F580 18 05
    CALL $F55E                          ; $F582 cd 5e f5
    JR Z,$F59F                          ; $F585 28 18
    DEC B                               ; $F587 05
    JR NZ,$F59C                         ; $F588 20 12
    BIT 1,C                             ; $F58A cb 49
    JR Z,$F595                          ; $F58C 28 07
    CALL $F555                          ; $F58E cd 55 f5
    JR Z,$F59F                          ; $F591 28 0c
    JR $F59A                            ; $F593 18 05
    CALL $F54A                          ; $F595 cd 4a f5
    JR Z,$F59F                          ; $F598 28 05
    POP BC                              ; $F59A c1
    PUSH BC                             ; $F59B c5
    DEC L                               ; $F59C 2d
    JR NZ,$F574                         ; $F59D 20 d5
    POP BC                              ; $F59F c1
    POP HL                              ; $F5A0 e1
    RET                                 ; $F5A1 c9
    PUSH HL                             ; $F5A2 e5
    PUSH BC                             ; $F5A3 c5
    CALL $F5D2                          ; $F5A4 cd d2 f5
    BIT 1,C                             ; $F5A7 cb 49
    JR Z,$F5B2                          ; $F5A9 28 07
    CALL $F555                          ; $F5AB cd 55 f5
    JR Z,$F5CF                          ; $F5AE 28 1f
    JR $F5B7                            ; $F5B0 18 05
    CALL $F54A                          ; $F5B2 cd 4a f5
    JR Z,$F5CF                          ; $F5B5 28 18
    DEC B                               ; $F5B7 05
    JR NZ,$F5CC                         ; $F5B8 20 12
    BIT 2,C                             ; $F5BA cb 51
    JR Z,$F5C5                          ; $F5BC 28 07
    CALL $F565                          ; $F5BE cd 65 f5
    JR Z,$F5CF                          ; $F5C1 28 0c
    JR $F5CA                            ; $F5C3 18 05
    CALL $F55E                          ; $F5C5 cd 5e f5
    JR Z,$F5CF                          ; $F5C8 28 05
    POP BC                              ; $F5CA c1
    PUSH BC                             ; $F5CB c5
    DEC L                               ; $F5CC 2d
    JR NZ,$F5A4                         ; $F5CD 20 d5
    POP BC                              ; $F5CF c1
    POP HL                              ; $F5D0 e1
    RET                                 ; $F5D1 c9
    PUSH HL                             ; $F5D2 e5
    CALL $F5FB                          ; $F5D3 cd fb f5
    PUSH AF                             ; $F5D6 f5
    PUSH HL                             ; $F5D7 e5
    LD A,H                              ; $F5D8 7c
    AND $18                             ; $F5D9 e6 18
    RRCA                                ; $F5DB 0f
    RRCA                                ; $F5DC 0f
    RRCA                                ; $F5DD 0f
    ADD A,$58                           ; $F5DE c6 58
    LD H,A                              ; $F5E0 67
    LD A,(HL)                           ; $F5E1 7e
    AND $38                             ; $F5E2 e6 38
    LD (HL),A                           ; $F5E4 77
    LD A,($F60B)                        ; $F5E5 3a 0b f6
    RLCA                                ; $F5E8 07
    RLCA                                ; $F5E9 07
    RLCA                                ; $F5EA 07
    CP (HL)                             ; $F5EB be
    JR NZ,$F5F0                         ; $F5EC 20 02
    XOR $38                             ; $F5EE ee 38
    RRCA                                ; $F5F0 0f
    RRCA                                ; $F5F1 0f
    RRCA                                ; $F5F2 0f
    OR (HL)                             ; $F5F3 b6
    LD (HL),A                           ; $F5F4 77
    POP HL                              ; $F5F5 e1
    POP AF                              ; $F5F6 f1
    OR (HL)                             ; $F5F7 b6
    LD (HL),A                           ; $F5F8 77
    POP HL                              ; $F5F9 e1
    RET                                 ; $F5FA c9
    PUSH BC                             ; $F5FB c5
    LD B,E                              ; $F5FC 43
    LD C,D                              ; $F5FD 4a
    CALL $22AA                          ; $F5FE cd aa 22
    LD B,A                              ; $F601 47
    INC B                               ; $F602 04
    LD A,$01                            ; $F603 3e 01
    RRC A                               ; $F605 cb 0f
    DJNZ $F605                          ; $F607 10 fc
    POP BC                              ; $F609 c1
    RET                                 ; $F60A c9
