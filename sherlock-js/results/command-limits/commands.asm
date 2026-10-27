; Offline source evidence. DOMAIN headers and operations are DATA.

    ORG $A296
; CODE: Eighteen clear CRs, counter reset after each
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

    ORG $AF6B
; DATA: Control dictionary identifiers and handler pointers
    DEFB $00,$00,$49,$B0,$40,$00,$33,$B0  ; $AF6B 00 00 49 b0 40 00 33 b0
    DEFB $5E,$01,$1C,$B0,$D5,$06,$FF,$AF  ; $AF73 5e 01 1c b0 d5 06 ff af
    DEFB $BD,$05,$0B,$B0,$07,$05,$A3,$B0  ; $AF7B bd 05 0b b0 07 05 a3 b0
    DEFB $75,$07,$C6,$B0,$60,$06,$9A,$B0  ; $AF83 75 07 c6 b0 60 06 9a b0
    DEFB $E3,$03,$35,$B1,$88,$04,$51,$B1  ; $AF8B e3 03 35 b1 88 04 51 b1
    DEFB $F6,$06,$A3,$B0,$B3,$08,$51,$B1  ; $AF93 f6 06 a3 b0 b3 08 51 b1

    ORG $AFFF
; CODE: PRINT presence test and NOPRINT clear before disabling
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

    ORG $B09A
; CODE: PAUSE key service; LOAD/QUIT pending restart service
    CALL $AFE1                            ; $B09A cd e1 af
    CALL $C415                            ; $B09D cd 15 c4
    JP $B015                              ; $B0A0 c3 15 b0
    CALL $AFE1                            ; $B0A3 cd e1 af
    CALL $B0AC                            ; $B0A6 cd ac b0
    JP $B015                              ; $B0A9 c3 15 b0

    ORG $B0C6
; CODE: SAVE scheduling, one minute, preserve current action
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

    ORG $BFD9
; CODE: Clock advance, midnight day byte and time classes
    LD HL,($9FDD)                         ; $BFD9 2a dd 9f
    INC HL                                ; $BFDC 23
    LD ($9FDD),HL                         ; $BFDD 22 dd 9f
    LD HL,$9FDF                           ; $BFE0 21 df 9f
    INC (HL)                              ; $BFE3 34
    LD A,(HL)                             ; $BFE4 7e
    CP $3C                                ; $BFE5 fe 3c
    RET NZ                                ; $BFE7 c0
    LD (HL),$00                           ; $BFE8 36 00
    LD HL,$9FE0                           ; $BFEA 21 e0 9f
    INC (HL)                              ; $BFED 34
    LD A,(HL)                             ; $BFEE 7e
    CP $0D                                ; $BFEF fe 0d
    JR NZ,$BFF6                           ; $BFF1 20 03
    LD (HL),$01                           ; $BFF3 36 01
    RET                                   ; $BFF5 c9
    CP $0C                                ; $BFF6 fe 0c
    RET NZ                                ; $BFF8 c0
    LD A,($9FE2)                          ; $BFF9 3a e2 9f
    XOR $11                               ; $BFFC ee 11
    LD ($9FE2),A                          ; $BFFE 32 e2 9f
    CP $61                                ; $C001 fe 61
    RET NZ                                ; $C003 c0
    LD A,($9FE1)                          ; $C004 3a e1 9f
    INC A                                 ; $C007 3c
    LD ($9FE1),A                          ; $C008 32 e1 9f
    RET                                   ; $C00B c9
    LD A,($9FE2)                          ; $C00C 3a e2 9f
    CP $61                                ; $C00F fe 61
    LD A,($9FE0)                          ; $C011 3a e0 9f
    JR Z,$C02B                            ; $C014 28 15
    CP $0C                                ; $C016 fe 0c
    JR Z,$C035                            ; $C018 28 1b
    CP $08                                ; $C01A fe 08
    JR C,$C021                            ; $C01C 38 03
    LD A,$01                              ; $C01E 3e 01
    RET                                   ; $C020 c9
    CP $07                                ; $C021 fe 07
    JR NZ,$C028                           ; $C023 20 03
    LD A,$02                              ; $C025 3e 02
    RET                                   ; $C027 c9
    LD A,$03                              ; $C028 3e 03
    RET                                   ; $C02A c9
    CP $0C                                ; $C02B fe 0c
    JR Z,$C01E                            ; $C02D 28 ef
    CP $06                                ; $C02F fe 06
    JR C,$C01E                            ; $C031 38 eb
    JR Z,$C038                            ; $C033 28 03
    LD A,$04                              ; $C035 3e 04
    RET                                   ; $C037 c9
    LD A,$05                              ; $C038 3e 05
    RET                                   ; $C03A c9

    ORG $C3E4
; CODE: Printer receives old top row before scrolling
    LD A,($A008)                          ; $C3E4 3a 08 a0
    AND A                                 ; $C3E7 a7
    RET Z                                 ; $C3E8 c8
    PUSH HL                               ; $C3E9 e5
    PUSH DE                               ; $C3EA d5
    PUSH BC                               ; $C3EB c5
    LD HL,$4000                           ; $C3EC 21 00 40
    LD B,$08                              ; $C3EF 06 08
    PUSH BC                               ; $C3F1 c5
    PUSH HL                               ; $C3F2 e5
    CALL $C403                            ; $C3F3 cd 03 c4
    POP HL                                ; $C3F6 e1
    INC H                                 ; $C3F7 24
    POP BC                                ; $C3F8 c1
    DJNZ $C3F1                            ; $C3F9 10 f6
    LD A,$04                              ; $C3FB 3e 04
    OUT ($FB),A                           ; $C3FD d3 fb
    POP BC                                ; $C3FF c1
    POP DE                                ; $C400 d1
    POP HL                                ; $C401 e1
    RET                                   ; $C402 c9
    LD A,B                                ; $C403 78
    CP $03                                ; $C404 fe 03
    SBC A,A                               ; $C406 9f
    AND $02                               ; $C407 e6 02
    OUT ($FB),A                           ; $C409 d3 fb
    LD D,A                                ; $C40B 57
    IN A,($FB)                            ; $C40C db fb
    ADD A,A                               ; $C40E 87
    RET M                                 ; $C40F f8
    JR NC,$C40C                           ; $C410 30 fa
    JP $0F12                              ; $C412 c3 12 0f

    ORG $D39B
; CODE: Location matching filtered by adjacency
    PUSH IY                               ; $D39B fd e5
    PUSH DE                               ; $D39D d5
    PUSH BC                               ; $D39E c5
    PUSH IX                               ; $D39F dd e5
    POP BC                                ; $D3A1 c1
    LD DE,$0001                           ; $D3A2 11 01 00
    INC B                                 ; $D3A5 04
    LD A,B                                ; $D3A6 78
    CP $6A                                ; $D3A7 fe 6a
    LD A,$FF                              ; $D3A9 3e ff
    JR Z,$D3CD                            ; $D3AB 28 20
    LD A,B                                ; $D3AD 78
    CALL $D224                            ; $D3AE cd 24 d2
    PUSH IX                               ; $D3B1 dd e5
    POP IY                                ; $D3B3 fd e1
    ADD IY,DE                             ; $D3B5 fd 19
    CALL $A4E0                            ; $D3B7 cd e0 a4
    JR NZ,$D3A5                           ; $D3BA 20 e9
    LD A,($A038)                          ; $D3BC 3a 38 a0
    AND A                                 ; $D3BF a7
    JR NZ,$D3CC                           ; $D3C0 20 0a
    PUSH BC                               ; $D3C2 c5
    LD A,B                                ; $D3C3 78
    CALL $D471                            ; $D3C4 cd 71 d4
    POP BC                                ; $D3C7 c1
    CP $FF                                ; $D3C8 fe ff
    JR Z,$D3A5                            ; $D3CA 28 d9
    LD A,B                                ; $D3CC 78
    PUSH BC                               ; $D3CD c5
    POP IX                                ; $D3CE dd e1
    POP BC                                ; $D3D0 c1
    POP DE                                ; $D3D1 d1
    POP IY                                ; $D3D2 fd e1

    ORG $DC19
; DATA: LOOK THROUGH multioccurrence header
    DEFB $1B,$20,$40,$28,$00,$00,$00      ; $DC19 1b 20 40 28 00 00 00

    ORG $DC20
; CODE: LOOK THROUGH temporary relocation and restore
    CALL $DC6C                            ; $DC20 cd 6c dc
    RET NZ                                ; $DC23 c0
    LD A,($A034)                          ; $DC24 3a 34 a0
    CALL $D46C                            ; $DC27 cd 6c d4
    LD A,(IX+$02)                         ; $DC2A dd 7e 02
    AND A                                 ; $DC2D a7
    JR Z,$DC4B                            ; $DC2E 28 1b
    LD B,A                                ; $DC30 47
    LD A,($A00A)                          ; $DC31 3a 0a a0
    PUSH AF                               ; $DC34 f5
    LD A,$01                              ; $DC35 3e 01
    LD ($D0DC),A                          ; $DC37 32 dc d0
    CALL $DD0B                            ; $DC3A cd 0b dd
    LD A,($A00A)                          ; $DC3D 3a 0a a0
    CALL $D1B2                            ; $DC40 cd b2 d1
    POP BC                                ; $DC43 c1
    CALL $DD0B                            ; $DC44 cd 0b dd
    XOR A                                 ; $DC47 af
    LD ($D0DC),A                          ; $DC48 32 dc d0
    OR $01                                ; $DC4B f6 01
    RET                                   ; $DC4D c9
    LD A,($A034)                          ; $DC4E 3a 34 a0
    CALL $D46C                            ; $DC51 cd 6c d4
    JP $DCDD                              ; $DC54 c3 dd dc
    LD C,E                                ; $DC57 4b
    JR NZ,$DCA8                           ; $DC58 20 4e
    CALL C,$7EDD                          ; $DC5A dc dd 7e
    NOP                                   ; $DC5D 00
    LD ($A033),A                          ; $DC5E 32 33 a0
    XOR A                                 ; $DC61 af
    LD ($A00F),A                          ; $DC62 32 0f a0
    DEC A                                 ; $DC65 3d
    LD ($A034),A                          ; $DC66 32 34 a0
    JP $DD07                              ; $DC69 c3 07 dd

    ORG $DD52
; DATA: Adjacent movement DOMAIN header
    DEFB $A4,$00                          ; $DD52 a4 00

    ORG $DD54
; DATA: Adjacent movement DOMAIN operations, not Z80
    DEFB $17,$61,$DD,$FD,$FF,$60,$DD,$11  ; $DD54 17 61 dd fd ff 60 dd 11
    DEFB $FD,$60,$DD,$0B,$0A,$64          ; $DD5C fd 60 dd 0b 0a 64

    ORG $E452
; DATA: FOLLOW/COME WITH class-12 header and predicate
    DEFB $EC,$00,$4C,$E4                  ; $E452 ec 00 4c e4

    ORG $E456
; DATA: FOLLOW deferred DOMAIN program, not Z80
    DEFB $07,$2F,$E5,$0A,$FF,$47,$88,$E4  ; $E456 07 2f e5 0a ff 47 88 e4
    DEFB $FD,$FF,$57,$52,$DD,$FA,$FF,$6B  ; $E45E fd ff 57 52 dd fa ff 6b
    DEFB $E4,$43,$88,$E5,$0B,$C7,$FD,$E5  ; $E466 e4 43 88 e5 0b c7 fd e5
    DEFB $FD,$FF,$81,$E4,$C1,$0D,$81,$E4  ; $E46E fd ff 81 e4 c1 0d 81 e4
    DEFB $57,$84,$DD,$FD,$FF,$81,$E4,$42  ; $E476 57 84 dd fd ff 81 e4 42
    DEFB $0C,$FA,$FF,$0F,$C3,$7A,$E5,$5B  ; $E47E 0c fa ff 0f c3 7a e5 5b
    DEFB $E4,$0A                          ; $E486 e4 0a
