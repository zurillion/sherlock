; Sherlock v2.0: servizio cab. HEADER, BYTECODE e ROUTE non sono Z80.

    ORG $9AE1
    DEFB $04,$00                                  ; $9AE1 HEADER 04 00
    CALL $9B50                                    ; $9AE3 Z80 cd 50 9b
    LD DE,$0006                                   ; $9AE6 Z80 11 06 00
    CALL $9B25                                    ; $9AE9 Z80 cd 25 9b
    LD A,(IX+$02)                                 ; $9AEC Z80 dd 7e 02
    SUB $02                                       ; $9AEF Z80 d6 02
    LD L,A                                        ; $9AF1 Z80 6f
    JR $9B02                                      ; $9AF2 Z80 18 0e
    DEFB $04,$00                                  ; $9AF4 HEADER 04 00
    CALL $9B50                                    ; $9AF6 Z80 cd 50 9b
    LD DE,$0002                                   ; $9AF9 Z80 11 02 00
    CALL $9B25                                    ; $9AFC Z80 cd 25 9b
    LD L,(IX+$02)                                 ; $9AFF Z80 dd 6e 02
    LD A,$01                                      ; $9B02 Z80 3e 01
    PUSH AF                                       ; $9B04 Z80 f5
    LD H,$00                                      ; $9B05 Z80 26 00
    LD ($A01F),HL                                 ; $9B07 Z80 22 1f a0
    LD A,($E2C6)                                  ; $9B0A Z80 3a c6 e2
    CALL $9C60                                    ; $9B0D Z80 cd 60 9c
    POP BC                                        ; $9B10 Z80 c1
    PUSH BC                                       ; $9B11 Z80 c5
    LD A,($E2C6)                                  ; $9B12 Z80 3a c6 e2
    CALL $DD0E                                    ; $9B15 Z80 cd 0e dd
    POP AF                                        ; $9B18 Z80 f1
    CALL $D224                                    ; $9B19 Z80 cd 24 d2
    RES 6,(IX+$00)                                ; $9B1C Z80 dd cb 00 b6
    LD HL,$F3AD                                   ; $9B20 Z80 21 ad f3
    SCF                                           ; $9B23 Z80 37
    RET                                           ; $9B24 Z80 c9
    LD A,(IX+$02)                                 ; $9B25 Z80 dd 7e 02
    PUSH IX                                       ; $9B28 Z80 dd e5
    LD HL,$0000                                   ; $9B2A Z80 21 00 00
    ADD HL,DE                                     ; $9B2D Z80 19
    SUB $05                                       ; $9B2E Z80 d6 05
    JR NC,$9B2D                                   ; $9B30 Z80 30 fb
    EX DE,HL                                      ; $9B32 Z80 eb
    LD A,($A036)                                  ; $9B33 Z80 3a 36 a0
    CALL $E619                                    ; $9B36 Z80 cd 19 e6
    JR Z,$9B44                                    ; $9B39 Z80 28 09
    CALL $E39C                                    ; $9B3B Z80 cd 9c e3
    AND A                                         ; $9B3E Z80 a7
    SBC HL,DE                                     ; $9B3F Z80 ed 52
    CALL $E38F                                    ; $9B41 Z80 cd 8f e3
    CALL $CFB6                                    ; $9B44 Z80 cd b6 cf
    LD A,(IX+$03)                                 ; $9B47 Z80 dd 7e 03
    LD ($A035),A                                  ; $9B4A Z80 32 35 a0
    POP IX                                        ; $9B4D Z80 dd e1
    RET                                           ; $9B4F Z80 c9
    LD A,($A036)                                  ; $9B50 Z80 3a 36 a0
    DEC A                                         ; $9B53 Z80 3d
    LD IY,($A017)                                 ; $9B54 Z80 fd 2a 17 a0
    LD (IY+$01),A                                 ; $9B58 Z80 fd 77 01
    LD ($E2C6),A                                  ; $9B5B Z80 32 c6 e2
    CALL $D237                                    ; $9B5E Z80 cd 37 d2
    LD A,(IX+$0F)                                 ; $9B61 Z80 dd 7e 0f
    LD (IY+$0F),A                                 ; $9B64 Z80 fd 77 0f
    LD ($A00A),A                                  ; $9B67 Z80 32 0a a0
    LD A,($A034)                                  ; $9B6A Z80 3a 34 a0
    LD C,A                                        ; $9B6D Z80 4f
    LD A,($A00A)                                  ; $9B6E Z80 3a 0a a0
    CALL $9C07                                    ; $9B71 Z80 cd 07 9c
    RET Z                                         ; $9B74 Z80 c8
    POP HL                                        ; $9B75 Z80 e1
    LD HL,$6C34                                   ; $9B76 Z80 21 34 6c
    CALL $A59F                                    ; $9B79 Z80 cd 9f a5
    OR $01                                        ; $9B7C Z80 f6 01
    RET                                           ; $9B7E Z80 c9
    DEFB $2D,$05,$03                              ; $9B7F ROUTE 2d 05 03
    DEFB $2D,$0A,$07                              ; $9B82 ROUTE 2d 0a 07
    DEFB $2D,$0C,$14                              ; $9B85 ROUTE 2d 0c 14
    DEFB $2D,$0E,$13                              ; $9B88 ROUTE 2d 0e 13
    DEFB $2D,$12,$12                              ; $9B8B ROUTE 2d 12 12
    DEFB $2D,$18,$07                              ; $9B8E ROUTE 2d 18 07
    DEFB $2D,$1C,$0C                              ; $9B91 ROUTE 2d 1c 0c
    DEFB $2D,$20,$06                              ; $9B94 ROUTE 2d 20 06
    DEFB $2D,$28,$0D                              ; $9B97 ROUTE 2d 28 0d
    DEFB $05,$0A,$14                              ; $9B9A ROUTE 05 0a 14
    DEFB $05,$0C,$19                              ; $9B9D ROUTE 05 0c 19
    DEFB $05,$0E,$1A                              ; $9BA0 ROUTE 05 0e 1a
    DEFB $05,$12,$0C                              ; $9BA3 ROUTE 05 12 0c
    DEFB $05,$18,$06                              ; $9BA6 ROUTE 05 18 06
    DEFB $05,$1C,$0F                              ; $9BA9 ROUTE 05 1c 0f
    DEFB $05,$20,$18                              ; $9BAC ROUTE 05 20 18
    DEFB $05,$28,$09                              ; $9BAF ROUTE 05 28 09
    DEFB $0A,$0C,$12                              ; $9BB2 ROUTE 0a 0c 12
    DEFB $0A,$0E,$12                              ; $9BB5 ROUTE 0a 0e 12
    DEFB $0A,$12,$0C                              ; $9BB8 ROUTE 0a 12 0c
    DEFB $0A,$18,$13                              ; $9BBB ROUTE 0a 18 13
    DEFB $0A,$1C,$02                              ; $9BBE ROUTE 0a 1c 02
    DEFB $0A,$20,$04                              ; $9BC1 ROUTE 0a 20 04
    DEFB $0A,$28,$0F                              ; $9BC4 ROUTE 0a 28 0f
    DEFB $0C,$0E,$03                              ; $9BC7 ROUTE 0c 0e 03
    DEFB $0C,$12,$14                              ; $9BCA ROUTE 0c 12 14
    DEFB $0C,$18,$1E                              ; $9BCD ROUTE 0c 18 1e
    DEFB $0C,$1C,$14                              ; $9BD0 ROUTE 0c 1c 14
    DEFB $0C,$20,$11                              ; $9BD3 ROUTE 0c 20 11
    DEFB $0C,$28,$19                              ; $9BD6 ROUTE 0c 28 19
    DEFB $0E,$12,$0D                              ; $9BD9 ROUTE 0e 12 0d
    DEFB $0E,$18,$1C                              ; $9BDC ROUTE 0e 18 1c
    DEFB $0E,$1C,$11                              ; $9BDF ROUTE 0e 1c 11
    DEFB $0E,$20,$09                              ; $9BE2 ROUTE 0e 20 09
    DEFB $0E,$28,$0B                              ; $9BE5 ROUTE 0e 28 0b
    DEFB $12,$18,$0B                              ; $9BE8 ROUTE 12 18 0b
    DEFB $12,$1C,$10                              ; $9BEB ROUTE 12 1c 10
    DEFB $12,$20,$12                              ; $9BEE ROUTE 12 20 12
    DEFB $12,$28,$03                              ; $9BF1 ROUTE 12 28 03
    DEFB $18,$1C,$0F                              ; $9BF4 ROUTE 18 1c 0f
    DEFB $18,$20,$18                              ; $9BF7 ROUTE 18 20 18
    DEFB $18,$28,$0D                              ; $9BFA ROUTE 18 28 0d
    DEFB $1C,$20,$0C                              ; $9BFD ROUTE 1c 20 0c
    DEFB $1C,$28,$13                              ; $9C00 ROUTE 1c 28 13
    DEFB $20,$28,$16                              ; $9C03 ROUTE 20 28 16
    DEFB $FF                                      ; $9C06 DATA ff
    LD IX,$9B7F                                   ; $9C07 Z80 dd 21 7f 9b
    PUSH BC                                       ; $9C0B Z80 c5
    LD B,A                                        ; $9C0C Z80 47
    LD A,(IX+$00)                                 ; $9C0D Z80 dd 7e 00
    CP $FF                                        ; $9C10 Z80 fe ff
    JR Z,$9C3D                                    ; $9C12 Z80 28 29
    LD A,B                                        ; $9C14 Z80 78
    CP (IX+$00)                                   ; $9C15 Z80 dd be 00
    JR Z,$9C2A                                    ; $9C18 Z80 28 10
    CP (IX+$01)                                   ; $9C1A Z80 dd be 01
    JR NZ,$9C33                                   ; $9C1D Z80 20 14
    LD A,C                                        ; $9C1F Z80 79
    AND A                                         ; $9C20 Z80 a7
    JR Z,$9C3B                                    ; $9C21 Z80 28 18
    CP (IX+$00)                                   ; $9C23 Z80 dd be 00
    JR NZ,$9C33                                   ; $9C26 Z80 20 0b
    JR $9C3B                                      ; $9C28 Z80 18 11
    LD A,C                                        ; $9C2A Z80 79
    AND A                                         ; $9C2B Z80 a7
    JR Z,$9C3B                                    ; $9C2C Z80 28 0d
    CP (IX+$01)                                   ; $9C2E Z80 dd be 01
    JR Z,$9C3B                                    ; $9C31 Z80 28 08
    INC IX                                        ; $9C33 Z80 dd 23
    INC IX                                        ; $9C35 Z80 dd 23
    INC IX                                        ; $9C37 Z80 dd 23
    JR $9C0D                                      ; $9C39 Z80 18 d2
    POP BC                                        ; $9C3B Z80 c1
    RET                                           ; $9C3C Z80 c9
    OR $01                                        ; $9C3D Z80 f6 01
    POP BC                                        ; $9C3F Z80 c1
    RET                                           ; $9C40 Z80 c9
    DEFB $04,$00                                  ; $9C41 HEADER 04 00
    LD IX,($A017)                                 ; $9C43 Z80 dd 2a 17 a0
    LD A,(IX+$01)                                 ; $9C47 Z80 dd 7e 01
    PUSH AF                                       ; $9C4A Z80 f5
    CALL $9C56                                    ; $9C4B Z80 cd 56 9c
    LD A,($A034)                                  ; $9C4E Z80 3a 34 a0
    LD B,A                                        ; $9C51 Z80 47
    POP AF                                        ; $9C52 Z80 f1
    JP $DD0E                                      ; $9C53 Z80 c3 0e dd
    CALL $D237                                    ; $9C56 Z80 cd 37 d2
    SET 7,(IX+$05)                                ; $9C59 Z80 dd cb 05 fe
    OR $01                                        ; $9C5D Z80 f6 01
    RET                                           ; $9C5F Z80 c9
    CALL $D237                                    ; $9C60 Z80 cd 37 d2
    RES 7,(IX+$05)                                ; $9C63 Z80 dd cb 05 be
    OR $01                                        ; $9C67 Z80 f6 01
    RET                                           ; $9C69 Z80 c9

    ORG $A419
    PUSH BC                                       ; $A419 Z80 c5
    RES 7,H                                       ; $A41A Z80 cb bc
    SLA L                                         ; $A41C Z80 cb 25
    SRL H                                         ; $A41E Z80 cb 3c
    RR L                                          ; $A420 Z80 cb 1d
    LD A,$20                                      ; $A422 Z80 3e 20
    CALL $A9B7                                    ; $A424 Z80 cd b7 a9
    LD DE,$00F0                                   ; $A427 Z80 11 f0 00
    CALL $A476                                    ; $A42A Z80 cd 76 a4
    AND A                                         ; $A42D Z80 a7
    JR Z,$A442                                    ; $A42E Z80 28 12
    LD B,A                                        ; $A430 Z80 47
    LD A,$60                                      ; $A431 Z80 3e 60
    CALL $A9B7                                    ; $A433 Z80 cd b7 a9
    CALL $A490                                    ; $A436 Z80 cd 90 a4
    LD A,L                                        ; $A439 Z80 7d
    OR H                                          ; $A43A Z80 b4
    JR Z,$A467                                    ; $A43B Z80 28 2a
    LD A,$20                                      ; $A43D Z80 3e 20
    CALL $A9B7                                    ; $A43F Z80 cd b7 a9
    LD DE,$000C                                   ; $A442 Z80 11 0c 00
    CALL $A476                                    ; $A445 Z80 cd 76 a4
    AND A                                         ; $A448 Z80 a7
    JR Z,$A469                                    ; $A449 Z80 28 1e
    LD B,A                                        ; $A44B Z80 47
    CALL $A490                                    ; $A44C Z80 cd 90 a4
    LD A,$2F                                      ; $A44F Z80 3e 2f
    CALL $A9B7                                    ; $A451 Z80 cd b7 a9
    LD A,L                                        ; $A454 Z80 7d
    AND A                                         ; $A455 Z80 a7
    LD B,A                                        ; $A456 Z80 47
    JR Z,$A45E                                    ; $A457 Z80 28 05
    CALL $A490                                    ; $A459 Z80 cd 90 a4
    JR $A467                                      ; $A45C Z80 18 09
    LD A,$2D                                      ; $A45E Z80 3e 2d
    CALL $A9B7                                    ; $A460 Z80 cd b7 a9
    XOR A                                         ; $A463 Z80 af
    LD ($A026),A                                  ; $A464 Z80 32 26 a0
    POP BC                                        ; $A467 Z80 c1
    RET                                           ; $A468 Z80 c9
    LD B,L                                        ; $A469 Z80 45
    CALL $A490                                    ; $A46A Z80 cd 90 a4
    LD A,$44                                      ; $A46D Z80 3e 44
    CALL $A9B7                                    ; $A46F Z80 cd b7 a9
    LD A,$2E                                      ; $A472 Z80 3e 2e
    JR $A460                                      ; $A474 Z80 18 ea

    ORG $E08D
    DEFB $8D,$04                                  ; $E08D HEADER 8d 04
    DEFB $87,$FD,$E5,$FD,$FF,$9B,$E0              ; $E08F BYTECODE 87 fd e5 fd ff 9b e0
    DEFB $05,$FD,$9E,$6B                          ; $E096 BYTECODE 05 fd 9e 6b
    DEFB $0B                                      ; $E09A BYTECODE 0b
    DEFB $02,$1D,$FC,$FF                          ; $E09B BYTECODE 02 1d fc ff
    DEFB $0B                                      ; $E09F BYTECODE 0b

    ORG $E298
    LD A,($A034)                                  ; $E298 Z80 3a 34 a0
    CP $1E                                        ; $E29B Z80 fe 1e
    JR Z,$E2A4                                    ; $E29D Z80 28 05
    CP $21                                        ; $E29F Z80 fe 21
    JP NZ,$DC15                                   ; $E2A1 Z80 c2 15 dc
    LD A,($A00A)                                  ; $E2A4 Z80 3a 0a a0
    LD C,$00                                      ; $E2A7 Z80 0e 00
    CALL $9C07                                    ; $E2A9 Z80 cd 07 9c
    JP NZ,$DC15                                   ; $E2AC Z80 c2 15 dc
    LD IX,($A013)                                 ; $E2AF Z80 dd 2a 13 a0
    LD A,(IX+$0F)                                 ; $E2B3 Z80 dd 7e 0f
    AND A                                         ; $E2B6 Z80 a7
    JP NZ,$DC15                                   ; $E2B7 Z80 c2 15 dc
    LD A,($A034)                                  ; $E2BA Z80 3a 34 a0
    CALL $CFB9                                    ; $E2BD Z80 cd b9 cf
    JP NZ,$DC15                                   ; $E2C0 Z80 c2 15 dc
    OR $01                                        ; $E2C3 Z80 f6 01
    RET                                           ; $E2C5 Z80 c9
    DEFB $00                                      ; $E2C6 DATA 00
    DEFB $47,$10,$98,$E2                          ; $E2C7 HEADER 47 10 98 e2
    LD A,($A00A)                                  ; $E2CB Z80 3a 0a a0
    LD B,A                                        ; $E2CE Z80 47
    LD A,($A034)                                  ; $E2CF Z80 3a 34 a0
    INC A                                         ; $E2D2 Z80 3c
    LD ($E2C6),A                                  ; $E2D3 Z80 32 c6 e2
    DEC A                                         ; $E2D6 Z80 3d
    CALL $DD0E                                    ; $E2D7 Z80 cd 0e dd
    LD A,($A036)                                  ; $E2DA Z80 3a 36 a0
    LD B,A                                        ; $E2DD Z80 47
    LD A,($A034)                                  ; $E2DE Z80 3a 34 a0
    LD C,A                                        ; $E2E1 Z80 4f
    LD DE,$F2B6                                   ; $E2E2 Z80 11 b6 f2
    LD A,($E2C6)                                  ; $E2E5 Z80 3a c6 e2
    CALL $E2EE                                    ; $E2E8 Z80 cd ee e2
    OR $01                                        ; $E2EB Z80 f6 01
    RET                                           ; $E2ED Z80 c9
    PUSH DE                                       ; $E2EE Z80 d5
    LD D,A                                        ; $E2EF Z80 57
    LD A,B                                        ; $E2F0 Z80 78
    LD ($A034),A                                  ; $E2F1 Z80 32 34 a0
    LD A,C                                        ; $E2F4 Z80 79
    LD ($A035),A                                  ; $E2F5 Z80 32 35 a0
    LD A,($A036)                                  ; $E2F8 Z80 3a 36 a0
    PUSH AF                                       ; $E2FB Z80 f5
    LD A,D                                        ; $E2FC Z80 7a
    LD ($A036),A                                  ; $E2FD Z80 32 36 a0
    CALL $CC0E                                    ; $E300 Z80 cd 0e cc
    LD L,(IY+$01)                                 ; $E303 Z80 fd 6e 01
    LD H,(IY+$02)                                 ; $E306 Z80 fd 66 02
    LD B,$02                                      ; $E309 Z80 06 02
    CALL $CF80                                    ; $E30B Z80 cd 80 cf
    POP AF                                        ; $E30E Z80 f1
    LD ($A036),A                                  ; $E30F Z80 32 36 a0
    POP DE                                        ; $E312 Z80 d1
    LD (IY+$01),E                                 ; $E313 Z80 fd 73 01
    LD (IY+$02),D                                 ; $E316 Z80 fd 72 02
    OR $01                                        ; $E319 Z80 f6 01
    RET                                           ; $E31B Z80 c9
    LD IX,($A013)                                 ; $E31C Z80 dd 2a 13 a0
    BIT 5,(IX+$06)                                ; $E320 Z80 dd cb 06 6e
    JP Z,$DC15                                    ; $E324 Z80 ca 15 dc
    RET                                           ; $E327 Z80 c9
    DEFB $6A,$10,$1C,$E3                          ; $E328 HEADER 6a 10 1c e3
    LD HL,$6836                                   ; $E32C Z80 21 36 68
    CALL $A59F                                    ; $E32F Z80 cd 9f a5
    LD IX,($A013)                                 ; $E332 Z80 dd 2a 13 a0
    LD L,(IX+$09)                                 ; $E336 Z80 dd 6e 09
    LD H,(IX+$0A)                                 ; $E339 Z80 dd 66 0a
    CALL $A419                                    ; $E33C Z80 cd 19 a4
    CALL $A2A2                                    ; $E33F Z80 cd a2 a2
    OR $01                                        ; $E342 Z80 f6 01
    RET                                           ; $E344 Z80 c9
    CALL $E34F                                    ; $E345 Z80 cd 4f e3
    RET Z                                         ; $E348 Z80 c8
    LD A,$25                                      ; $E349 Z80 3e 25
    LD ($A033),A                                  ; $E34B Z80 32 33 a0
    RET                                           ; $E34E Z80 c9
    LD A,($A036)                                  ; $E34F Z80 3a 36 a0
    CALL $E619                                    ; $E352 Z80 cd 19 e6
    JR Z,$E365                                    ; $E355 Z80 28 0e
    CALL $E39C                                    ; $E357 Z80 cd 9c e3
    CALL $E3A9                                    ; $E35A Z80 cd a9 e3
    AND A                                         ; $E35D Z80 a7
    SBC HL,DE                                     ; $E35E Z80 ed 52
    JR C,$E365                                    ; $E360 Z80 38 03
    OR $01                                        ; $E362 Z80 f6 01
    RET                                           ; $E364 Z80 c9
    LD HL,$E36A                                   ; $E365 Z80 21 6a e3
    XOR A                                         ; $E368 Z80 af
    RET                                           ; $E369 Z80 c9
    LD HL,$683F                                   ; $E36A Z80 21 3f 68
    JP $A59F                                      ; $E36D Z80 c3 9f a5
    DEFB $66,$1D,$45,$E3                          ; $E370 HEADER 66 1d 45 e3
    CALL $E34F                                    ; $E374 Z80 cd 4f e3
    CALL $E38F                                    ; $E377 Z80 cd 8f e3
    LD A,($A035)                                  ; $E37A Z80 3a 35 a0
    CALL $E619                                    ; $E37D Z80 cd 19 e6
    JR Z,$E38C                                    ; $E380 Z80 28 0a
    CALL $E39C                                    ; $E382 Z80 cd 9c e3
    CALL $E3A9                                    ; $E385 Z80 cd a9 e3
    ADD HL,DE                                     ; $E388 Z80 19
    CALL $E38F                                    ; $E389 Z80 cd 8f e3
    OR $01                                        ; $E38C Z80 f6 01
    RET                                           ; $E38E Z80 c9
    RL L                                          ; $E38F Z80 cb 15
    RL H                                          ; $E391 Z80 cb 14
    SRL L                                         ; $E393 Z80 cb 3d
    LD (IX+$09),L                                 ; $E395 Z80 dd 75 09
    LD (IX+$0A),H                                 ; $E398 Z80 dd 74 0a
    RET                                           ; $E39B Z80 c9
    LD L,(IX+$09)                                 ; $E39C Z80 dd 6e 09
    LD H,(IX+$0A)                                 ; $E39F Z80 dd 66 0a
    RL L                                          ; $E3A2 Z80 cb 15
    SRA H                                         ; $E3A4 Z80 cb 2c
    RR L                                          ; $E3A6 Z80 cb 1d
    RET                                           ; $E3A8 Z80 c9
    LD DE,($A02F)                                 ; $E3A9 Z80 ed 5b 2f a0
    RES 7,D                                       ; $E3AD Z80 cb ba
    RL E                                          ; $E3AF Z80 cb 13
    SRA D                                         ; $E3B1 Z80 cb 2a
    RR E                                          ; $E3B3 Z80 cb 1b
    OR $01                                        ; $E3B5 Z80 f6 01
    RET                                           ; $E3B7 Z80 c9
    CALL $E3F5                                    ; $E3B8 Z80 cd f5 e3
    RET Z                                         ; $E3BB Z80 c8
    LD A,($A036)                                  ; $E3BC Z80 3a 36 a0
    PUSH AF                                       ; $E3BF Z80 f5
    LD A,($A034)                                  ; $E3C0 Z80 3a 34 a0
    INC A                                         ; $E3C3 Z80 3c
    LD ($A036),A                                  ; $E3C4 Z80 32 36 a0
    CALL $CFB6                                    ; $E3C7 Z80 cd b6 cf
    EX AF,AF'                                     ; $E3CA Z80 08
    POP AF                                        ; $E3CB Z80 f1
    LD ($A036),A                                  ; $E3CC Z80 32 36 a0
    EX AF,AF'                                     ; $E3CF Z80 08
    JR Z,$E3E7                                    ; $E3D0 Z80 28 15
    LD A,(IX+$03)                                 ; $E3D2 Z80 dd 7e 03
    CALL $D237                                    ; $E3D5 Z80 cd 37 d2
    LD IY,($A017)                                 ; $E3D8 Z80 fd 2a 17 a0
    LD A,(IX+$04)                                 ; $E3DC Z80 dd 7e 04
    AND (IY+$04)                                  ; $E3DF Z80 fd a6 04
    AND $70                                       ; $E3E2 Z80 e6 70
    JP Z,$DC15                                    ; $E3E4 Z80 ca 15 dc
    OR $01                                        ; $E3E7 Z80 f6 01
    RET                                           ; $E3E9 Z80 c9
    DEFB $78,$20,$B8,$E3,$90,$40,$28,$00,$00      ; $E3EA HEADER 78 20 b8 e3 90 40 28 00 00
    JR $E413                                      ; $E3F3 Z80 18 1e
    CALL $CBA7                                    ; $E3F5 Z80 cd a7 cb
    CALL $DCA7                                    ; $E3F8 Z80 cd a7 dc
    RET Z                                         ; $E3FB Z80 c8
    LD IX,($A017)                                 ; $E3FC Z80 dd 2a 17 a0
    LD IY,($A013)                                 ; $E400 Z80 fd 2a 13 a0
    LD A,($A034)                                  ; $E404 Z80 3a 34 a0
    JP $DEE4                                      ; $E407 Z80 c3 e4 de

    ORG $E413
    LD IY,($A017)                                 ; $E413 Z80 fd 2a 17 a0
    LD A,($A034)                                  ; $E417 Z80 3a 34 a0
    LD (IY+$01),A                                 ; $E41A Z80 fd 77 01
    OR $01                                        ; $E41D Z80 f6 01
    RET                                           ; $E41F Z80 c9
    CALL $CBA7                                    ; $E420 Z80 cd a7 cb
    LD A,($A036)                                  ; $E423 Z80 3a 36 a0
    LD HL,$A034                                   ; $E426 Z80 21 34 a0
    CALL $D278                                    ; $E429 Z80 cd 78 d2
    JP NC,$DC15                                   ; $E42C Z80 d2 15 dc
    OR $01                                        ; $E42F Z80 f6 01
    RET                                           ; $E431 Z80 c9
    DEFB $78,$20,$20,$E4,$10,$80,$28,$00,$00      ; $E432 HEADER 78 20 20 e4 10 80 28 00 00
    LD IY,($A013)                                 ; $E43B Z80 fd 2a 13 a0
    LD A,(IY+$01)                                 ; $E43F Z80 fd 7e 01
    LD IY,($A017)                                 ; $E442 Z80 fd 2a 17 a0
    LD (IY+$01),A                                 ; $E446 Z80 fd 77 01
    OR $01                                        ; $E449 Z80 f6 01
    RET                                           ; $E44B Z80 c9

    ORG $E497
    DEFB $47,$24,$B0,$E4                          ; $E497 HEADER 47 24 b0 e4

    ORG $E4FC
    LD A,($A034)                                  ; $E4FC Z80 3a 34 a0
    CALL $E619                                    ; $E4FF Z80 cd 19 e6
    JP Z,$DC15                                    ; $E502 Z80 ca 15 dc
    RET                                           ; $E505 Z80 c9
    DEFB $AD,$0D                                  ; $E506 HEADER ad 0d
    DEFB $C7,$18,$E5,$FD,$FC,$10,$E5              ; $E508 BYTECODE c7 18 e5 fd fc 10 e5
    DEFB $0A                                      ; $E50F BYTECODE 0a
    DEFB $57,$70,$E3,$FD,$FC,$0F,$E5              ; $E510 BYTECODE 57 70 e3 fd fc 0f e5
    DEFB $0B                                      ; $E517 BYTECODE 0b
    DEFB $6D,$0D,$FC,$E4                          ; $E518 HEADER 6d 0d fc e4
    LD A,$FE                                      ; $E51C Z80 3e fe
    LD ($9FD7),A                                  ; $E51E Z80 32 d7 9f
    LD L,(IX+$09)                                 ; $E521 Z80 dd 6e 09
    LD H,(IX+$0A)                                 ; $E524 Z80 dd 66 0a
    SET 7,L                                       ; $E527 Z80 cb fd
    LD ($A02F),HL                                 ; $E529 Z80 22 2f a0
    OR $01                                        ; $E52C Z80 f6 01
    RET                                           ; $E52E Z80 c9
    DEFB $07,$07                                  ; $E52F HEADER 07 07

    ORG $E57A
    DEFB $40,$00,$73,$E5                          ; $E57A HEADER 40 00 73 e5

    ORG $E588
    DEFB $40,$00,$73,$E5                          ; $E588 HEADER 40 00 73 e5

    ORG $E5A8
    DEFB $00,$10                                  ; $E5A8 HEADER 00 10

    ORG $E5D8
    DEFB $47,$07,$DF,$E5                          ; $E5D8 HEADER 47 07 df e5

    ORG $E5FD
    DEFB $47,$00,$04,$E6                          ; $E5FD HEADER 47 00 04 e6

    ORG $E63E
    DEFB $40,$00,$42,$E6                          ; $E63E HEADER 40 00 42 e6
    LD A,($A036)                                  ; $E642 Z80 3a 36 a0
    CALL $E619                                    ; $E645 Z80 cd 19 e6
    JP Z,$DC15                                    ; $E648 Z80 ca 15 dc
    CALL $E39C                                    ; $E64B Z80 cd 9c e3
    BIT 7,H                                       ; $E64E Z80 cb 7c
    JP Z,$DC15                                    ; $E650 Z80 ca 15 dc
    RET                                           ; $E653 Z80 c9
    DEFB $40,$00,$58,$E6                          ; $E654 HEADER 40 00 58 e6
    LD A,($A036)                                  ; $E658 Z80 3a 36 a0
    CALL $E619                                    ; $E65B Z80 cd 19 e6
    JP Z,$DC15                                    ; $E65E Z80 ca 15 dc
    CALL $E39C                                    ; $E661 Z80 cd 9c e3
    BIT 7,H                                       ; $E664 Z80 cb 7c
    JP NZ,$DC15                                   ; $E666 Z80 c2 15 dc
    LD A,H                                        ; $E669 Z80 7c
    OR L                                          ; $E66A Z80 b5
    JP Z,$DC15                                    ; $E66B Z80 ca 15 dc
    RET                                           ; $E66E Z80 c9
    DEFB $40,$00,$73,$E6                          ; $E66F HEADER 40 00 73 e6
    LD A,($A036)                                  ; $E673 Z80 3a 36 a0
    CALL $E619                                    ; $E676 Z80 cd 19 e6
    JR Z,$E683                                    ; $E679 Z80 28 08
    CALL $E39C                                    ; $E67B Z80 cd 9c e3
    LD A,H                                        ; $E67E Z80 7c
    OR L                                          ; $E67F Z80 b5
    JP NZ,$DC15                                   ; $E680 Z80 c2 15 dc
    OR $01                                        ; $E683 Z80 f6 01
    RET                                           ; $E685 Z80 c9

    ORG $E6BC
    DEFB $0D,$0C                                  ; $E6BC HEADER 0d 0c
    LD A,($A035)                                  ; $E6BE Z80 3a 35 a0
    CALL $E619                                    ; $E6C1 Z80 cd 19 e6
    JR Z,$E6E3                                    ; $E6C4 Z80 28 1d
    LD E,(IX+$09)                                 ; $E6C6 Z80 dd 5e 09
    LD D,(IX+$0A)                                 ; $E6C9 Z80 dd 56 0a
    LD HL,$6BB7                                   ; $E6CC Z80 21 b7 6b
    CALL $A59F                                    ; $E6CF Z80 cd 9f a5
    LD HL,$0000                                   ; $E6D2 Z80 21 00 00
    AND A                                         ; $E6D5 Z80 a7
    SBC HL,DE                                     ; $E6D6 Z80 ed 52
    CALL $A419                                    ; $E6D8 Z80 cd 19 a4
    LD A,$22                                      ; $E6DB Z80 3e 22
    CALL $A9B7                                    ; $E6DD Z80 cd b7 a9
    CALL $A2A2                                    ; $E6E0 Z80 cd a2 a2
    OR $01                                        ; $E6E3 Z80 f6 01
    RET                                           ; $E6E5 Z80 c9
    DEFB $4D,$00,$F6,$E6                          ; $E6E6 HEADER 4d 00 f6 e6
    CALL $CFB6                                    ; $E6EA Z80 cd b6 cf
    LD A,($A034)                                  ; $E6ED Z80 3a 34 a0
    LD (IX+$03),A                                 ; $E6F0 Z80 dd 77 03
    OR $01                                        ; $E6F3 Z80 f6 01
    RET                                           ; $E6F5 Z80 c9
    LD A,($A036)                                  ; $E6F6 Z80 3a 36 a0
    LD HL,$A034                                   ; $E6F9 Z80 21 34 a0
    CP (HL)                                       ; $E6FC Z80 be
    JP Z,$DC15                                    ; $E6FD Z80 ca 15 dc
    DEC A                                         ; $E700 Z80 3d
    LD IX,($A013)                                 ; $E701 Z80 dd 2a 13 a0
    CP (IX+$01)                                   ; $E705 Z80 dd be 01
    JP NZ,$DC15                                   ; $E708 Z80 c2 15 dc
    OR $01                                        ; $E70B Z80 f6 01
    RET                                           ; $E70D Z80 c9
    DEFB $00,$00                                  ; $E70E HEADER 00 00
    LD A,($5C3C)                                  ; $E710 Z80 3a 3c 5c
    PUSH AF                                       ; $E713 Z80 f5
    CALL $CFB6                                    ; $E714 Z80 cd b6 cf
    LD A,(IX+$03)                                 ; $E717 Z80 dd 7e 03
    AND A                                         ; $E71A Z80 a7
    LD HL,$6C54                                   ; $E71B Z80 21 54 6c
    JR NZ,$E725                                   ; $E71E Z80 20 05
    LD A,$01                                      ; $E720 Z80 3e 01
    LD ($5C3C),A                                  ; $E722 Z80 32 3c 5c
    CALL $A59F                                    ; $E725 Z80 cd 9f a5
    POP AF                                        ; $E728 Z80 f1
    LD ($5C3C),A                                  ; $E729 Z80 32 3c 5c
    OR $01                                        ; $E72C Z80 f6 01
    RET                                           ; $E72E Z80 c9

    ORG $F2B2
    DEFB $0F                                      ; $F2B2 BYTECODE 0f
    DEFB $0E,$B2,$F2                              ; $F2B3 BYTECODE 0e b2 f2
    DEFB $05,$FD,$AC,$6B                          ; $F2B6 BYTECODE 05 fd ac 6b
    DEFB $07,$2F,$E5,$04,$04                      ; $F2BA BYTECODE 07 2f e5 04 04
    DEFB $03,$A8,$E5                              ; $F2BF BYTECODE 03 a8 e5
    DEFB $81,$82,$D0,$F2                          ; $F2C2 BYTECODE 81 82 d0 f2
    DEFB $83,$7A,$E5,$BF,$F2                      ; $F2C6 BYTECODE 83 7a e5 bf f2
    DEFB $86,$F6,$6B,$76,$F3                      ; $F2CB BYTECODE 86 f6 6b 76 f3
    DEFB $03,$88,$E5                              ; $F2D0 BYTECODE 03 88 e5
    DEFB $07,$2F,$E5,$05,$03                      ; $F2D3 BYTECODE 07 2f e5 05 03
    DEFB $83,$3E,$E6,$EB,$F2                      ; $F2D8 BYTECODE 83 3e e6 eb f2
    DEFB $03,$A8,$E5                              ; $F2DD BYTECODE 03 a8 e5
    DEFB $83,$7A,$E5,$D8,$F2                      ; $F2E0 BYTECODE 83 7a e5 d8 f2
    DEFB $85,$FD,$1B,$6C,$BA,$F2                  ; $F2E5 BYTECODE 85 fd 1b 6c ba f2
    DEFB $82,$82,$FD,$FF,$FC,$F2                  ; $F2EB BYTECODE 82 82 fd ff fc f2
    DEFB $82,$81,$FD,$FB,$2E,$F3                  ; $F2F1 BYTECODE 82 81 fd fb 2e f3
    DEFB $13,$E6,$E6,$59,$F3                      ; $F2F7 BYTECODE 13 e6 e6 59 f3
    DEFB $03,$88,$E5                              ; $F2FC BYTECODE 03 88 e5
    DEFB $07,$2F,$E5,$05,$02                      ; $F2FF BYTECODE 07 2f e5 05 02
    DEFB $83,$54,$E6,$A2,$F3                      ; $F304 BYTECODE 83 54 e6 a2 f3
    DEFB $83,$6F,$E6,$66,$F3                      ; $F309 BYTECODE 83 6f e6 66 f3
    DEFB $12,$82,$FD,$FF,$2E,$F3                  ; $F30E BYTECODE 12 82 fd ff 2e f3
    DEFB $03,$A8,$E5                              ; $F314 BYTECODE 03 a8 e5
    DEFB $83,$7A,$E5,$04,$F3                      ; $F317 BYTECODE 83 7a e5 04 f3
    DEFB $83,$54,$E6,$A2,$F3                      ; $F31C BYTECODE 83 54 e6 a2 f3
    DEFB $83,$6F,$E6,$69,$F3                      ; $F321 BYTECODE 83 6f e6 69 f3
    DEFB $07,$BC,$E6,$FD,$FB                      ; $F326 BYTECODE 07 bc e6 fd fb
    DEFB $0E,$FF,$F2                              ; $F32B BYTECODE 0e ff f2
    DEFB $03,$88,$E5                              ; $F32E BYTECODE 03 88 e5
    DEFB $06,$C7,$6B                              ; $F331 BYTECODE 06 c7 6b
    DEFB $07,$2F,$E5,$05,$02                      ; $F334 BYTECODE 07 2f e5 05 02
    DEFB $83,$54,$E6,$A2,$F3                      ; $F339 BYTECODE 83 54 e6 a2 f3
    DEFB $83,$6F,$E6,$66,$F3                      ; $F33E BYTECODE 83 6f e6 66 f3
    DEFB $82,$82,$FD,$FF,$FC,$F2                  ; $F343 BYTECODE 82 82 fd ff fc f2
    DEFB $12,$81,$FD,$FB,$59,$F3                  ; $F349 BYTECODE 12 81 fd fb 59 f3
    DEFB $03,$A8,$E5                              ; $F34F BYTECODE 03 a8 e5
    DEFB $93,$7A,$E5,$39,$F3,$31,$F3              ; $F352 BYTECODE 93 7a e5 39 f3 31 f3
    DEFB $03,$88,$E5                              ; $F359 BYTECODE 03 88 e5
    DEFB $03,$0E,$E7                              ; $F35C BYTECODE 03 0e e7
    DEFB $93,$E6,$E6,$FC,$F2,$76,$F3              ; $F35F BYTECODE 93 e6 e6 fc f2 76 f3
    DEFB $03,$88,$E5                              ; $F366 BYTECODE 03 88 e5
    DEFB $0F                                      ; $F369 BYTECODE 0f
    DEFB $0F                                      ; $F36A BYTECODE 0f
    DEFB $82,$82,$FD,$FF,$D0,$F2                  ; $F36B BYTECODE 82 82 fd ff d0 f2
    DEFB $83,$E6,$E6,$E5,$F2                      ; $F371 BYTECODE 83 e6 e6 e5 f2
    DEFB $02,$80,$FC,$00                          ; $F376 BYTECODE 02 80 fc 00
    DEFB $83,$80,$F3,$7A,$F3                      ; $F37A BYTECODE 83 80 f3 7a f3
    DEFB $0B                                      ; $F37F BYTECODE 0b
    DEFB $C8,$00,$89,$F3                          ; $F380 HEADER c8 00 89 f3
    DEFB $02,$80,$FD,$00                          ; $F384 BYTECODE 02 80 fd 00
    DEFB $0B                                      ; $F388 BYTECODE 0b
    LD IX,($A013)                                 ; $F389 Z80 dd 2a 13 a0
    LD A,($A036)                                  ; $F38D Z80 3a 36 a0
    DEC A                                         ; $F390 Z80 3d
    CP (IX+$01)                                   ; $F391 Z80 dd be 01
    JP NZ,$DC15                                   ; $F394 Z80 c2 15 dc
    LD HL,$A034                                   ; $F397 Z80 21 34 a0
    INC A                                         ; $F39A Z80 3c
    CP (HL)                                       ; $F39B Z80 be
    JP Z,$DC15                                    ; $F39C Z80 ca 15 dc
    OR $01                                        ; $F39F Z80 f6 01
    RET                                           ; $F3A1 Z80 c9
    DEFB $03,$88,$E5                              ; $F3A2 BYTECODE 03 88 e5
    DEFB $07,$06,$E5,$FB,$FD                      ; $F3A5 BYTECODE 07 06 e5 fb fd
    DEFB $0E,$69,$F3                              ; $F3AA BYTECODE 0e 69 f3
    DEFB $07,$41,$9C,$FD,$FF                      ; $F3AD BYTECODE 07 41 9c fd ff
    DEFB $83,$54,$E6,$C1,$F3                      ; $F3B2 BYTECODE 83 54 e6 c1 f3
    DEFB $83,$6F,$E6,$C1,$F3                      ; $F3B7 BYTECODE 83 6f e6 c1 f3
    DEFB $07,$BC,$E6,$FC,$FB                      ; $F3BC BYTECODE 07 bc e6 fc fb
    DEFB $0B                                      ; $F3C1 BYTECODE 0b
