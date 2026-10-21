; Sherlock - regole selezionate. Nessun disassemblaggio Z80 dei metadati o degli script.

    ORG $9C6A
; CODE fino a$9C84
; Selezione callback dell attore dalla tabella9C85.
    LD A,($A036)                       ; $9C6A 3a 36 a0
    LD IX,$9C85                        ; $9C6D dd 21 85 9c
    CALL $D34E                         ; $9C71 cd 4e d3
    CP $FF                             ; $9C74 fe ff
    RET                                ; $9C76 c9
    CALL $9C6A                         ; $9C77 cd 6a 9c
    RET Z                              ; $9C7A c8
    LD L,(IX+$01)                      ; $9C7B dd 6e 01
    LD H,(IX+$02)                      ; $9C7E dd 66 02
    LD A,L                             ; $9C81 7d
    OR H                               ; $9C82 b4
    RET Z                              ; $9C83 c8
    JP (HL)                            ; $9C84 e9

    ORG $9C85
; DATA fino a$9CA1
; Triplette attore/puntatore: include ID6 ->9CA2. NON istruzioni.
    DEFB $02,$FF,$9D,$03,$13,$9D,$04,$30 ; $9C85 02 ff 9d 03 13 9d 04 30
    DEFB $9D,$0B,$48,$9D,$0C,$73,$9D,$08 ; $9C8D 9d 0b 48 9d 0c 73 9d 08
    DEFB $D1,$9E,$09,$CB,$9E,$05,$C1,$9E ; $9C95 d1 9e 09 cb 9e 05 c1 9e
    DEFB $06,$A2,$9C,$FF               ; $9C9D 06 a2 9c ff
; Contatore della nota85; FF disabilita il conto. Dato mutabile.
    DEFB $0F                           ; $9CA1 0f

    ORG $9CA2
; CODE fino a$9CCD
; Se nota85 ha bit7 di+05, decrementa9CA1. A zero diventa BURNT e perde descrizione.
    LD A,$55                           ; $9CA2 3e 55
    CALL $D237                         ; $9CA4 cd 37 d2
    BIT 7,(IX+$05)                     ; $9CA7 dd cb 05 7e
    RET Z                              ; $9CAB c8
    LD HL,$9CA1                        ; $9CAC 21 a1 9c
    LD A,(HL)                          ; $9CAF 7e
    CP $FF                             ; $9CB0 fe ff
    RET Z                              ; $9CB2 c8
    DEC (HL)                           ; $9CB3 35
    RET NZ                             ; $9CB4 c0
    LD HL,$015B                        ; $9CB5 21 5b 01
    LD (IX+$09),L                      ; $9CB8 dd 75 09
    LD (IX+$0A),H                      ; $9CBB dd 74 0a
    XOR A                              ; $9CBE af
    LD (IX+$0D),A                      ; $9CBF dd 77 0d
    LD (IX+$0E),A                      ; $9CC2 dd 77 0e
    LD IX,$99B7                        ; $9CC5 dd 21 b7 99
    RES 1,(IX+$03)                     ; $9CC9 dd cb 03 8e
    RET                                ; $9CCD c9

    ORG $A093
; CODE fino a$A0D7
; Scorre record attori da8byte, con sentinellaFF.
    LD IY,$9860                        ; $A093 fd 21 60 98
    LD A,(IY+$00)                      ; $A097 fd 7e 00
    INC A                              ; $A09A 3c
    JR Z,$A068                         ; $A09B 28 cb
    LD HL,($9FDD)                      ; $A09D 2a dd 9f
    CALL $A0DB                         ; $A0A0 cd db a0
    JR C,$A0D1                         ; $A0A3 38 2c
    LD A,(IY+$00)                      ; $A0A5 fd 7e 00
    PUSH IY                            ; $A0A8 fd e5
    PUSH AF                            ; $A0AA f5
    CALL $CC37                         ; $A0AB cd 37 cc
    POP AF                             ; $A0AE f1
    PUSH AF                            ; $A0AF f5
    CALL $CC78                         ; $A0B0 cd 78 cc
; Ripete attore finche costoA01F==0.
    LD HL,($A01F)                      ; $A0B3 2a 1f a0
    LD A,L                             ; $A0B6 7d
    OR H                               ; $A0B7 b4
    JR Z,$A0AE                         ; $A0B8 28 f4
    POP AF                             ; $A0BA f1
    POP IY                             ; $A0BB fd e1
; Aggiunge costoA01F al tempo dovuto del record attore+06/+07.
    LD E,(IY+$06)                      ; $A0BD fd 5e 06
    LD D,(IY+$07)                      ; $A0C0 fd 56 07
    ADD HL,DE                          ; $A0C3 19
    LD (IY+$06),L                      ; $A0C4 fd 75 06
    LD (IY+$07),H                      ; $A0C7 fd 74 07
    PUSH IY                            ; $A0CA fd e5
; Callback specifica dell attore dopo l avanzamento.
    CALL $9C77                         ; $A0CC cd 77 9c
    POP IY                             ; $A0CF fd e1
    LD DE,$0008                        ; $A0D1 11 08 00
    ADD IY,DE                          ; $A0D4 fd 19
    JR $A097                           ; $A0D6 18 bf

    ORG $BFD9
; CODE fino a$C00B
; Incrementa tempo globale9FDD e minuti9FDF; cambio ora a60.
    LD HL,($9FDD)                      ; $BFD9 2a dd 9f
    INC HL                             ; $BFDC 23
    LD ($9FDD),HL                      ; $BFDD 22 dd 9f
    LD HL,$9FDF                        ; $BFE0 21 df 9f
    INC (HL)                           ; $BFE3 34
    LD A,(HL)                          ; $BFE4 7e
    CP $3C                             ; $BFE5 fe 3c
    RET NZ                             ; $BFE7 c0
    LD (HL),$00                        ; $BFE8 36 00
    LD HL,$9FE0                        ; $BFEA 21 e0 9f
    INC (HL)                           ; $BFED 34
    LD A,(HL)                          ; $BFEE 7e
    CP $0D                             ; $BFEF fe 0d
    JR NZ,$BFF6                        ; $BFF1 20 03
    LD (HL),$01                        ; $BFF3 36 01
    RET                                ; $BFF5 c9
    CP $0C                             ; $BFF6 fe 0c
    RET NZ                             ; $BFF8 c0
    LD A,($9FE2)                       ; $BFF9 3a e2 9f
    XOR $11                            ; $BFFC ee 11
    LD ($9FE2),A                       ; $BFFE 32 e2 9f
    CP $61                             ; $C001 fe 61
    RET NZ                             ; $C003 c0
    LD A,($9FE1)                       ; $C004 3a e1 9f
    INC A                              ; $C007 3c
    LD ($9FE1),A                       ; $C008 32 e1 9f
    RET                                ; $C00B c9

    ORG $C4D1
; CODE fino a$C570
; Esecuzione di azione con ID; puo ricontrollare/cercare gli argomenti.
    LD A,($A033)                       ; $C4D1 3a 33 a0
    BIT 7,A                            ; $C4D4 cb 7f
    JP NZ,$C583                        ; $C4D6 c2 83 c5
    CALL $A2B1                         ; $C4D9 cd b1 a2
    PUSH HL                            ; $C4DC e5
    POP IX                             ; $C4DD dd e1
    CALL $A2BD                         ; $C4DF cd bd a2
    CALL $C493                         ; $C4E2 cd 93 c4
    CALL $C4B2                         ; $C4E5 cd b2 c4
    XOR A                              ; $C4E8 af
    LD ($A00B),A                       ; $C4E9 32 0b a0
    LD A,($A01D)                       ; $C4EC 3a 1d a0
    AND $0C                            ; $C4EF e6 0c
    JR Z,$C53A                         ; $C4F1 28 47
    LD A,($A00F)                       ; $C4F3 3a 0f a0
    CP $05                             ; $C4F6 fe 05
    JR NZ,$C502                        ; $C4F8 20 08
    LD A,($A034)                       ; $C4FA 3a 34 a0
    CP $FE                             ; $C4FD fe fe
    JP NZ,$CB41                        ; $C4FF c2 41 cb
    LD A,($A010)                       ; $C502 3a 10 a0
    CP $05                             ; $C505 fe 05
    JR NZ,$C511                        ; $C507 20 08
    LD A,($A035)                       ; $C509 3a 35 a0
    CP $FE                             ; $C50C fe fe
    JP NZ,$CB41                        ; $C50E c2 41 cb
    LD A,($A00F)                       ; $C511 3a 0f a0
    AND A                              ; $C514 a7
    JR Z,$C531                         ; $C515 28 1a
    LD A,($A034)                       ; $C517 3a 34 a0
    CP $FF                             ; $C51A fe ff
    JR NZ,$C531                        ; $C51C 20 13
    LD B,$FF                           ; $C51E 06 ff
    INC B                              ; $C520 04
    CALL $C463                         ; $C521 cd 63 c4
    RET Z                              ; $C524 c8
    LD ($A034),A                       ; $C525 32 34 a0
    PUSH BC                            ; $C528 c5
    CALL $C55A                         ; $C529 cd 5a c5
    POP BC                             ; $C52C c1
    JR NZ,$C53A                        ; $C52D 20 0b
    JR $C520                           ; $C52F 18 ef
    CALL $C542                         ; $C531 cd 42 c5
    JR Z,$C53A                         ; $C534 28 04
    CALL $C560                         ; $C536 cd 60 c5
    RET Z                              ; $C539 c8
; A00B=1 -> valutazione ed esecuzione della regola selezionata.
    LD A,$01                           ; $C53A 3e 01
    LD ($A00B),A                       ; $C53C 32 0b a0
    JP $C929                           ; $C53F c3 29 c9
    LD A,($A010)                       ; $C542 3a 10 a0
    AND A                              ; $C545 a7
    RET Z                              ; $C546 c8
    LD A,($A035)                       ; $C547 3a 35 a0
    CP $FF                             ; $C54A fe ff
    JR NZ,$C558                        ; $C54C 20 0a
    LD A,($A01D)                       ; $C54E 3a 1d a0
    AND $02                            ; $C551 e6 02
    JR NZ,$C558                        ; $C553 20 03
    OR $01                             ; $C555 f6 01
    RET                                ; $C557 c9
    XOR A                              ; $C558 af
    RET                                ; $C559 c9
    CALL $C542                         ; $C55A cd 42 c5
    JP Z,$C929                         ; $C55D ca 29 c9
    LD B,$FF                           ; $C560 06 ff
    INC B                              ; $C562 04
    CALL $C45E                         ; $C563 cd 5e c4
    JR Z,$C570                         ; $C566 28 08
    LD ($A035),A                       ; $C568 32 35 a0
    CALL $C929                         ; $C56B cd 29 c9
    JR Z,$C562                         ; $C56E 28 f2
    RET                                ; $C570 c9

    ORG $C628
; CODE fino a$C820
; Classe primo argomento e maschere opzionali.
    LD A,(IY+$00)                      ; $C628 fd 7e 00
    AND $0F                            ; $C62B e6 0f
    JR NZ,$C635                        ; $C62D 20 06
    OR $01                             ; $C62F f6 01
    RET                                ; $C631 c9
    JP $DC15                           ; $C632 c3 15 dc
    CP $05                             ; $C635 fe 05
    JR C,$C660                         ; $C637 38 27
    CP $07                             ; $C639 fe 07
    JR NC,$C682                        ; $C63B 30 45
    LD A,($A034)                       ; $C63D 3a 34 a0
    CP $FE                             ; $C640 fe fe
    JR NZ,$C654                        ; $C642 20 10
    LD HL,($A02F)                      ; $C644 2a 2f a0
    LD A,(IY+$00)                      ; $C647 fd 7e 00
    AND $0F                            ; $C64A e6 0f
    CP $05                             ; $C64C fe 05
    JR NZ,$C65A                        ; $C64E 20 0a
    BIT 7,L                            ; $C650 cb 7d
    JR Z,$C62F                         ; $C652 28 db
    XOR A                              ; $C654 af
    LD ($A021),A                       ; $C655 32 21 a0
    JR $C632                           ; $C658 18 d8
    BIT 7,L                            ; $C65A cb 7d
    JR NZ,$C62F                        ; $C65C 20 d1
    JR $C654                           ; $C65E 18 f4
    CP $03                             ; $C660 fe 03
    JR NC,$C670                        ; $C662 30 0c
    LD A,($A034)                       ; $C664 3a 34 a0
    CALL $D224                         ; $C667 cd 24 d2
    BIT 7,(IX+$00)                     ; $C66A dd cb 00 7e
    JR Z,$C654                         ; $C66E 28 e4
    BIT 0,(IY+$00)                     ; $C670 fd cb 00 46
    JR Z,$C62F                         ; $C674 28 b9
    LD A,($A034)                       ; $C676 3a 34 a0
    CALL $D471                         ; $C679 cd 71 d4
    CP $FF                             ; $C67C fe ff
    JR Z,$C654                         ; $C67E 28 d4
    JR $C62F                           ; $C680 18 ad
    LD A,($A034)                       ; $C682 3a 34 a0
    LD ($CB7A),A                       ; $C685 32 7a cb
    LD C,A                             ; $C688 4f
    LD A,(IY+$00)                      ; $C689 fd 7e 00
    CALL $C7A6                         ; $C68C cd a6 c7
    JR Z,$C654                         ; $C68F 28 c3
    BIT 4,(IY+$00)                     ; $C691 fd cb 00 66
    JR Z,$C62F                         ; $C695 28 98
    LD A,(IY+$02)                      ; $C697 fd 7e 02
    LD L,(IY+$03)                      ; $C69A fd 6e 03
    LD H,(IY+$04)                      ; $C69D fd 66 04
    BIT 6,(IY+$00)                     ; $C6A0 fd cb 00 76
    JR Z,$C6AF                         ; $C6A4 28 09
    LD A,(IY+$04)                      ; $C6A6 fd 7e 04
    LD L,(IY+$05)                      ; $C6A9 fd 6e 05
    LD H,(IY+$06)                      ; $C6AC fd 66 06
    RRCA                               ; $C6AF 0f
    RRCA                               ; $C6B0 0f
    RRCA                               ; $C6B1 0f
    RRCA                               ; $C6B2 0f
    LD B,A                             ; $C6B3 47
    CALL $C74E                         ; $C6B4 cd 4e c7
    RET NZ                             ; $C6B7 c0
    LD A,$01                           ; $C6B8 3e 01
    LD ($A021),A                       ; $C6BA 32 21 a0
    RET                                ; $C6BD c9
; Classe secondo argomento e maschere opzionali.
    LD A,(IY+$01)                      ; $C6BE fd 7e 01
    AND $0F                            ; $C6C1 e6 0f
    JR NZ,$C6CB                        ; $C6C3 20 06
    OR $01                             ; $C6C5 f6 01
    RET                                ; $C6C7 c9
    JP $DC15                           ; $C6C8 c3 15 dc
    CP $05                             ; $C6CB fe 05
    JR C,$C6F5                         ; $C6CD 38 26
    CP $07                             ; $C6CF fe 07
    JR NC,$C719                        ; $C6D1 30 46
    LD A,($A035)                       ; $C6D3 3a 35 a0
    CP $FE                             ; $C6D6 fe fe
    JP NZ,$C654                        ; $C6D8 c2 54 c6
    LD HL,($A031)                      ; $C6DB 2a 31 a0
    LD A,(IY+$01)                      ; $C6DE fd 7e 01
    AND $0F                            ; $C6E1 e6 0f
    CP $05                             ; $C6E3 fe 05
    JR NZ,$C6EE                        ; $C6E5 20 07
    BIT 7,L                            ; $C6E7 cb 7d
    JR Z,$C6C5                         ; $C6E9 28 da
    JP $C654                           ; $C6EB c3 54 c6
    BIT 7,L                            ; $C6EE cb 7d
    JR NZ,$C6C5                        ; $C6F0 20 d3
    JP $C654                           ; $C6F2 c3 54 c6
    CP $03                             ; $C6F5 fe 03
    JR NC,$C706                        ; $C6F7 30 0d
    LD A,($A035)                       ; $C6F9 3a 35 a0
    CALL $D224                         ; $C6FC cd 24 d2
    BIT 7,(IX+$00)                     ; $C6FF dd cb 00 7e
    JP Z,$C654                         ; $C703 ca 54 c6
    BIT 0,(IY+$01)                     ; $C706 fd cb 01 46
    JR Z,$C6C5                         ; $C70A 28 b9
    LD A,($A035)                       ; $C70C 3a 35 a0
    CALL $D471                         ; $C70F cd 71 d4
    CP $FF                             ; $C712 fe ff
    JP Z,$C654                         ; $C714 ca 54 c6
    JR $C6C5                           ; $C717 18 ac
    LD A,($A035)                       ; $C719 3a 35 a0
    LD ($CB7A),A                       ; $C71C 32 7a cb
    LD C,A                             ; $C71F 4f
    LD A,(IY+$01)                      ; $C720 fd 7e 01
    CALL $C7A6                         ; $C723 cd a6 c7
    RET Z                              ; $C726 c8
    BIT 4,(IY+$00)                     ; $C727 fd cb 00 66
    JP Z,$C62F                         ; $C72B ca 2f c6
    LD A,(IY+$02)                      ; $C72E fd 7e 02
    LD L,(IY+$05)                      ; $C731 fd 6e 05
    LD H,(IY+$06)                      ; $C734 fd 66 06
    BIT 6,(IY+$00)                     ; $C737 fd cb 00 76
    JR Z,$C746                         ; $C73B 28 09
    LD A,(IY+$04)                      ; $C73D fd 7e 04
    LD L,(IY+$07)                      ; $C740 fd 6e 07
    LD H,(IY+$08)                      ; $C743 fd 66 08
    LD B,A                             ; $C746 47
    CALL $C74E                         ; $C747 cd 4e c7
    RET NZ                             ; $C74A c0
    JP $C6B8                           ; $C74B c3 b8 c6
; Modo primo test dai bit3..2, secondo test dai bit1..0 del nibble.
    LD A,C                             ; $C74E 79
    CALL $D237                         ; $C74F cd 37 d2
    LD C,(IX+$05)                      ; $C752 dd 4e 05
    LD A,B                             ; $C755 78
    RRCA                               ; $C756 0f
    RRCA                               ; $C757 0f
    AND $03                            ; $C758 e6 03
    LD D,L                             ; $C75A 55
    CALL $C763                         ; $C75B cd 63 c7
    RET Z                              ; $C75E c8
    LD A,B                             ; $C75F 78
    AND $03                            ; $C760 e6 03
    LD D,H                             ; $C762 54
; Modo0: tutti; modo1: almeno uno (maschera0 ammessa); modo2: nessuno; modo3: non tutti.
    JR NZ,$C76D                        ; $C763 20 08
    LD A,D                             ; $C765 7a
    AND C                              ; $C766 a1
    CP D                               ; $C767 ba
    JP Z,$C62F                         ; $C768 ca 2f c6
    JR $C792                           ; $C76B 18 25
    CP $01                             ; $C76D fe 01
    JR NZ,$C77B                        ; $C76F 20 0a
    LD A,D                             ; $C771 7a
    AND A                              ; $C772 a7
    JR Z,$C768                         ; $C773 28 f3
    AND C                              ; $C775 a1
    JR Z,$C795                         ; $C776 28 1d
    JP $C62F                           ; $C778 c3 2f c6
    CP $02                             ; $C77B fe 02
    JR NZ,$C788                        ; $C77D 20 09
    LD A,D                             ; $C77F 7a
    AND C                              ; $C780 a1
    JP Z,$C62F                         ; $C781 ca 2f c6
    OR $80                             ; $C784 f6 80
    JR $C797                           ; $C786 18 0f
    LD A,D                             ; $C788 7a
    AND C                              ; $C789 a1
    CP D                               ; $C78A ba
    JP NZ,$C62F                        ; $C78B c2 2f c6
    OR $80                             ; $C78E f6 80
    JR $C797                           ; $C790 18 05
    XOR $FF                            ; $C792 ee ff
    AND D                              ; $C794 a2
    AND $7F                            ; $C795 e6 7f
    LD ($CB79),A                       ; $C797 32 79 cb
; Una maschera fallita diventa errore soltanto conA00B!=0.
    LD A,($A00B)                       ; $C79A 3a 0b a0
    AND A                              ; $C79D a7
    JP Z,$C62F                         ; $C79E ca 2f c6
    LD HL,$CB7B                        ; $C7A1 21 7b cb
    XOR A                              ; $C7A4 af
    RET                                ; $C7A5 c9
    AND $0F                            ; $C7A6 e6 0f
    CP $07                             ; $C7A8 fe 07
    JP Z,$C62F                         ; $C7AA ca 2f c6
    CP $08                             ; $C7AD fe 08
    JR NZ,$C7BB                        ; $C7AF 20 0a
    LD A,C                             ; $C7B1 79
    CALL $C821                         ; $C7B2 cd 21 c8
    JP Z,$C632                         ; $C7B5 ca 32 c6
    JP $C62F                           ; $C7B8 c3 2f c6
    CP $09                             ; $C7BB fe 09
    JR NZ,$C7E4                        ; $C7BD 20 25
    LD A,C                             ; $C7BF 79
    CALL $C821                         ; $C7C0 cd 21 c8
    JP Z,$C632                         ; $C7C3 ca 32 c6
    LD A,C                             ; $C7C6 79
    CALL $C8A7                         ; $C7C7 cd a7 c8
    JP NZ,$C632                        ; $C7CA c2 32 c6
    LD A,C                             ; $C7CD 79
    CALL $C8BE                         ; $C7CE cd be c8
    JP NZ,$C632                        ; $C7D1 c2 32 c6
    LD B,C                             ; $C7D4 41
    LD A,($A036)                       ; $C7D5 3a 36 a0
    CALL $C8C6                         ; $C7D8 cd c6 c8
    JP Z,$C632                         ; $C7DB ca 32 c6
    LD A,C                             ; $C7DE 79
    CALL $C8AF                         ; $C7DF cd af c8
    JR $C768                           ; $C7E2 18 84
    CP $0A                             ; $C7E4 fe 0a
    JR NZ,$C7F9                        ; $C7E6 20 11
    LD A,C                             ; $C7E8 79
    CALL $C821                         ; $C7E9 cd 21 c8
    JP Z,$C632                         ; $C7EC ca 32 c6
    LD A,C                             ; $C7EF 79
    CALL $D275                         ; $C7F0 cd 75 d2
    JP NC,$C632                        ; $C7F3 d2 32 c6
    JP $C62F                           ; $C7F6 c3 2f c6
    CP $0B                             ; $C7F9 fe 0b
    JR NZ,$C80A                        ; $C7FB 20 0d
    LD A,C                             ; $C7FD 79
    CALL $C821                         ; $C7FE cd 21 c8
    JP Z,$C632                         ; $C801 ca 32 c6
    LD A,C                             ; $C804 79
    CALL $C8A7                         ; $C805 cd a7 c8
    JR $C7B5                           ; $C808 18 ab
    CP $0C                             ; $C80A fe 0c
    JR NZ,$C814                        ; $C80C 20 06
    LD A,C                             ; $C80E 79
    CALL $C8BE                         ; $C80F cd be c8
    JR $C7B5                           ; $C812 18 a1
    LD A,C                             ; $C814 79
    CALL $C821                         ; $C815 cd 21 c8
    JP Z,$C632                         ; $C818 ca 32 c6
    LD A,C                             ; $C81B 79
    CALL $C8BE                         ; $C81C cd be c8
    JR $C7B5                           ; $C81F 18 94

    ORG $C9BF
; CODE fino a$CAAD
; HL punta all intestazione, NON al codice da eseguire.
    PUSH HL                            ; $C9BF e5
    POP IY                             ; $C9C0 fd e1
; Controllo luce: si applica se intestazione0 bit5 eD078 segnala buio.
    CALL $D078                         ; $C9C2 cd 78 d0
    JR NC,$C9D3                        ; $C9C5 30 0c
    LD A,(IY+$00)                      ; $C9C7 fd 7e 00
    AND $20                            ; $C9CA e6 20
    JR Z,$C9D3                         ; $C9CC 28 05
    LD HL,$CBBB                        ; $C9CE 21 bb cb
    XOR A                              ; $C9D1 af
    RET                                ; $C9D2 c9
    CALL $C628                         ; $C9D3 cd 28 c6
    JR Z,$C9D1                         ; $C9D6 28 f9
    CALL $C6BE                         ; $C9D8 cd be c6
    JR Z,$C9D1                         ; $C9DB 28 f4
; Bit6: word+02 = indirizzo predicato Z80.
    BIT 6,(IY+$00)                     ; $C9DD fd cb 00 76
    JR Z,$C9F2                         ; $C9E1 28 0f
    LD L,(IY+$02)                      ; $C9E3 fd 6e 02
    LD H,(IY+$03)                      ; $C9E6 fd 66 03
    PUSH IY                            ; $C9E9 fd e5
    CALL $CB34                         ; $C9EB cd 34 cb
    POP IY                             ; $C9EE fd e1
    JR Z,$C9D1                         ; $C9F0 28 df
; ConA00B=0 termina senza corpo e senza assegnare la durata.
    LD A,($A00B)                       ; $C9F2 3a 0b a0
    AND A                              ; $C9F5 a7
    JR NZ,$C9FB                        ; $C9F6 20 03
    OR $01                             ; $C9F8 f6 01
    RET                                ; $C9FA c9
    PUSH IY                            ; $C9FB fd e5
; Nibble alto del byte+01 ->A01F.
    LD A,(IY+$01)                      ; $C9FD fd 7e 01
    RRCA                               ; $CA00 0f
    RRCA                               ; $CA01 0f
    RRCA                               ; $CA02 0f
    RRCA                               ; $CA03 0f
    AND $0F                            ; $CA04 e6 0f
    LD L,A                             ; $CA06 6f
    LD H,$00                           ; $CA07 26 00
    LD ($A01F),HL                      ; $CA09 22 1f a0
; Calcola corpo: 2byte +2sepredicato +5semaschere.
    POP HL                             ; $CA0C e1
    LD DE,$0002                        ; $CA0D 11 02 00
    ADD HL,DE                          ; $CA10 19
    BIT 6,(IY+$00)                     ; $CA11 fd cb 00 76
    JR Z,$CA18                         ; $CA15 28 01
    ADD HL,DE                          ; $CA17 19
    LD DE,$0005                        ; $CA18 11 05 00
    BIT 4,(IY+$00)                     ; $CA1B fd cb 00 66
    JR Z,$CA22                         ; $CA1F 28 01
    ADD HL,DE                          ; $CA21 19
    LD A,($A00A)                       ; $CA22 3a 0a a0
    LD ($C491),A                       ; $CA25 32 91 c4
    LD IX,($A013)                      ; $CA28 dd 2a 13 a0
    LD A,(IX+$0F)                      ; $CA2C dd 7e 0f
    LD ($C492),A                       ; $CA2F 32 92 c4
    PUSH HL                            ; $CA32 e5
    PUSH IY                            ; $CA33 fd e5
    LD A,$01                           ; $CA35 3e 01
    LD ($A00C),A                       ; $CA37 32 0c a0
    CALL $CA76                         ; $CA3A cd 76 ca
    POP IY                             ; $CA3D fd e1
    POP HL                             ; $CA3F e1
; Bit7: ritornaCF=1, HL=script; il chiamante crea il contesto sospeso.
    BIT 7,(IY+$00)                     ; $CA40 fd cb 00 7e
    JR Z,$CA48                         ; $CA44 28 02
    SCF                                ; $CA46 37
    RET                                ; $CA47 c9
    LD A,($9FD7)                       ; $CA48 3a d7 9f
    INC A                              ; $CA4B 3c
    JR NZ,$CA54                        ; $CA4C 20 06
    LD A,($A034)                       ; $CA4E 3a 34 a0
    LD ($9FD7),A                       ; $CA51 32 d7 9f
    LD A,($9FD8)                       ; $CA54 3a d8 9f
    INC A                              ; $CA57 3c
    JR NZ,$CA60                        ; $CA58 20 06
    LD A,($A035)                       ; $CA5A 3a 35 a0
    LD ($9FD8),A                       ; $CA5D 32 d8 9f
    XOR A                              ; $CA60 af
    LD ($CAAE),A                       ; $CA61 32 ae ca
; Altrimenti salta al corpo Z80 tramiteCB2C/CB40.
    CALL $CB2C                         ; $CA64 cd 2c cb
    PUSH AF                            ; $CA67 f5
    PUSH HL                            ; $CA68 e5
    CALL $CA7F                         ; $CA69 cd 7f ca
    LD A,($CAAE)                       ; $CA6C 3a ae ca
    AND A                              ; $CA6F a7
    CALL Z,$CAAF                       ; $CA70 cc af ca
    POP HL                             ; $CA73 e1
    POP AF                             ; $CA74 f1
    RET                                ; $CA75 c9
    LD A,($A033)                       ; $CA76 3a 33 a0
    AND $80                            ; $CA79 e6 80
    CALL Z,$A2E4                       ; $CA7B cc e4 a2
    RET                                ; $CA7E c9
    LD A,($9860)                       ; $CA7F 3a 60 98
    CALL $D237                         ; $CA82 cd 37 d2
    LD A,($A009)                       ; $CA85 3a 09 a0
    CP (IX+$0F)                        ; $CA88 dd be 0f
    RET Z                              ; $CA8B c8
    LD A,($A036)                       ; $CA8C 3a 36 a0
    PUSH AF                            ; $CA8F f5
    LD A,($9860)                       ; $CA90 3a 60 98
    LD ($A036),A                       ; $CA93 32 36 a0
    CALL $CA9E                         ; $CA96 cd 9e ca
    POP AF                             ; $CA99 f1
    LD ($A036),A                       ; $CA9A 32 36 a0
    RET                                ; $CA9D c9
    LD A,($DD01)                       ; $CA9E 3a 01 dd
    LD HL,($DCFF)                      ; $CAA1 2a ff dc
    BIT 6,(HL)                         ; $CAA4 cb 76
    JP NZ,$D1B2                        ; $CAA6 c2 b2 d1
    SET 6,(HL)                         ; $CAA9 cb f6
    JP $D102                           ; $CAAB c3 02 d1

    ORG $CB28
; DATA fino a$CB2B
; IX/IY salvati dal predicato, ripristinati per il corpo.
    DEFB $00,$00,$00,$00               ; $CB28 00 00 00 00

    ORG $CB2C
; CODE fino a$CB40
    LD IX,($CB28)                      ; $CB2C dd 2a 28 cb
    LD IY,($CB2A)                      ; $CB30 fd 2a 2a cb
    CALL $CB40                         ; $CB34 cd 40 cb
    LD ($CB28),IX                      ; $CB37 dd 22 28 cb
    LD ($CB2A),IY                      ; $CB3B fd 22 2a cb
    RET                                ; $CB3F c9
; JP(HL): predicato o corpo Z80.
    JP (HL)                            ; $CB40 e9

    ORG $CC0E
; CODE fino a$CC28
; Cerca ID attore nella tabella9860 con passo8; FF se assente.
    PUSH DE                            ; $CC0E d5
    PUSH BC                            ; $CC0F c5
    LD C,A                             ; $CC10 4f
    LD DE,$0008                        ; $CC11 11 08 00
    LD IY,$9860                        ; $CC14 fd 21 60 98
    LD A,(IY+$00)                      ; $CC18 fd 7e 00
    CP C                               ; $CC1B b9
    JR Z,$CC26                         ; $CC1C 28 08
    CP $FF                             ; $CC1E fe ff
    JR Z,$CC26                         ; $CC20 28 04
    ADD IY,DE                          ; $CC22 fd 19
    JR $CC18                           ; $CC24 18 f2
    POP BC                             ; $CC26 c1
    POP DE                             ; $CC27 d1
    RET                                ; $CC28 c9

    ORG $CC82
; CODE fino a$CCF2
; Interprete delle sequenze attori: legge puntatore al prossimo opcode.
    LD L,(IY+$01)                      ; $CC82 fd 6e 01
    LD H,(IY+$02)                      ; $CC85 fd 66 02
    XOR A                              ; $CC88 af
    LD ($B934),A                       ; $CC89 32 34 b9
    LD A,($CC0B)                       ; $CC8C 3a 0b cc
    CP $0A                             ; $CC8F fe 0a
    JP Z,$CD8B                         ; $CC91 ca 8b cd
    LD A,(HL)                          ; $CC94 7e
    AND A                              ; $CC95 a7
    JR NZ,$CC9B                        ; $CC96 20 03
    INC HL                             ; $CC98 23
    JR $CC94                           ; $CC99 18 f9
    PUSH HL                            ; $CC9B e5
    POP IX                             ; $CC9C dd e1
    LD ($9FD9),HL                      ; $CC9E 22 d9 9f
    AND $0F                            ; $CCA1 e6 0f
    CP $0A                             ; $CCA3 fe 0a
    JR NC,$CCF3                        ; $CCA5 30 4c
    LD A,($CC0D)                       ; $CCA7 3a 0d cc
    CP $01                             ; $CCAA fe 01
    JR NZ,$CCC7                        ; $CCAC 20 19
    SUB A                              ; $CCAE 97
    LD ($CC0D),A                       ; $CCAF 32 0d cc
    LD A,(HL)                          ; $CCB2 7e
    CALL $B936                         ; $CCB3 cd 36 b9
    JP C,$CD91                         ; $CCB6 da 91 cd
    JR Z,$CCC7                         ; $CCB9 28 0c
    CALL $C4D1                         ; $CCBB cd d1 c4
    RET NC                             ; $CCBE d0
    CALL $CFB6                         ; $CCBF cd b6 cf
    LD (IX+$05),$02                    ; $CCC2 dd 36 05 02
    RET                                ; $CCC6 c9
; Dispatch sul nibble basso dell opcode.
    LD A,(HL)                          ; $CCC7 7e
    AND $0F                            ; $CCC8 e6 0f
    CP $07                             ; $CCCA fe 07
    JP Z,$CE3B                         ; $CCCC ca 3b ce
    CP $06                             ; $CCCF fe 06
    JP Z,$CD95                         ; $CCD1 ca 95 cd
    CP $05                             ; $CCD4 fe 05
    JP Z,$CDA1                         ; $CCD6 ca a1 cd
    CP $04                             ; $CCD9 fe 04
    JP Z,$CDBF                         ; $CCDB ca bf cd
    CP $01                             ; $CCDE fe 01
    JP Z,$CE6A                         ; $CCE0 ca 6a ce
    CP $03                             ; $CCE3 fe 03
    JP Z,$CE4F                         ; $CCE5 ca 4f ce
    CP $08                             ; $CCE8 fe 08
    JR Z,$CD24                         ; $CCEA 28 38
    CP $09                             ; $CCEC fe 09
    JR Z,$CD47                         ; $CCEE 28 57
    JP $CE18                           ; $CCF0 c3 18 ce

    ORG $CD0A
; CODE fino a$CD16
; Opcode0B ->ripristino del contesto conCFCF.
    CP $0B                             ; $CD0A fe 0b
    JR NZ,$CD17                        ; $CD0C 20 09
    CALL $CFCF                         ; $CD0E cd cf cf
    CP $02                             ; $CD11 fe 02
    RET Z                              ; $CD13 c8
    JP $CE8F                           ; $CD14 c3 8f ce

    ORG $CE3B
; CODE fino a$CE69
; Opcode07: riferimenti degli argomenti ai byte+03/+04; word+01/+02 = regola.
    LD A,(IX+$03)                      ; $CE3B dd 7e 03
    CALL $CEDE                         ; $CE3E cd de ce
    LD ($A034),A                       ; $CE41 32 34 a0
    LD A,(IX+$04)                      ; $CE44 dd 7e 04
    CALL $CEDE                         ; $CE47 cd de ce
    LD ($A035),A                       ; $CE4A 32 35 a0
    JR $CE57                           ; $CE4D 18 08
    LD A,$FF                           ; $CE4F 3e ff
    LD ($A034),A                       ; $CE51 32 34 a0
    LD ($A035),A                       ; $CE54 32 35 a0
; A033=FF: chiamata diretta di regola viaC591, non modello lessicale.
    LD A,$FF                           ; $CE57 3e ff
    LD ($A033),A                       ; $CE59 32 33 a0
    LD L,(IX+$01)                      ; $CE5C dd 6e 01
    LD H,(IX+$02)                      ; $CE5F dd 66 02
    CALL $C591                         ; $CE62 cd 91 c5
    RET C                              ; $CE65 d8
    JR Z,$CEB8                         ; $CE66 28 50
    JR $CE8F                           ; $CE68 18 25

    ORG $CE8F
; CODE fino a$CF42
; Avanzamento dopo successo di un opcode.
    CALL $CE83                         ; $CE8F cd 83 ce
    CALL $CF03                         ; $CE92 cd 03 cf
    BIT 7,(IX+$00)                     ; $CE95 dd cb 00 7e
    JR Z,$CEA1                         ; $CE99 28 06
    LD E,(HL)                          ; $CE9B 5e
    INC HL                             ; $CE9C 23
    LD D,(HL)                          ; $CE9D 56
    EX DE,HL                           ; $CE9E eb
    JR $CEA8                           ; $CE9F 18 07
    BIT 4,(IX+$00)                     ; $CEA1 dd cb 00 66
    CALL NZ,$CF40                      ; $CEA5 c4 40 cf
    BIT 5,(IX+$00)                     ; $CEA8 dd cb 00 6e
    CALL NZ,$CF43                      ; $CEAC c4 43 cf
    LD (IY+$01),L                      ; $CEAF fd 75 01
    LD (IY+$02),H                      ; $CEB2 fd 74 02
    JP $CD91                           ; $CEB5 c3 91 cd
    LD HL,$CC0B                        ; $CEB8 21 0b cc
    INC (HL)                           ; $CEBB 34
    CALL $CE83                         ; $CEBC cd 83 ce
    CALL $CEFE                         ; $CEBF cd fe ce
    BIT 4,(IX+$00)                     ; $CEC2 dd cb 00 66
    JR Z,$CECC                         ; $CEC6 28 04
    LD E,(HL)                          ; $CEC8 5e
    INC HL                             ; $CEC9 23
    LD D,(HL)                          ; $CECA 56
    EX DE,HL                           ; $CECB eb
    LD (IY+$01),L                      ; $CECC fd 75 01
    LD (IY+$02),H                      ; $CECF fd 74 02
    PUSH IX                            ; $CED2 dd e5
    POP DE                             ; $CED4 d1
    AND A                              ; $CED5 a7
    SBC HL,DE                          ; $CED6 ed 52
    JP Z,$CD8B                         ; $CED8 ca 8b cd
    JP $CC82                           ; $CEDB c3 82 cc
; Riferimenti dinamici: FA ultimaazione, FB attore, FC arg2salvato, FD arg1salvato; FE/FF letterali speciali.
    CP $F5                             ; $CEDE fe f5
    RET C                              ; $CEE0 d8
    CP $FE                             ; $CEE1 fe fe
    RET NC                             ; $CEE3 d0
    CP $FA                             ; $CEE4 fe fa
    JR NZ,$CEEC                        ; $CEE6 20 04
    LD A,($9FD6)                       ; $CEE8 3a d6 9f
    RET                                ; $CEEB c9
    CP $FB                             ; $CEEC fe fb
    JR NZ,$CEF4                        ; $CEEE 20 04
    LD A,($A036)                       ; $CEF0 3a 36 a0
    RET                                ; $CEF3 c9
    CP $FC                             ; $CEF4 fe fc
    LD A,($9FD8)                       ; $CEF6 3a d8 9f
    RET Z                              ; $CEF9 c8
    LD A,($9FD7)                       ; $CEFA 3a d7 9f
    RET                                ; $CEFD c9
; Calcolo lunghezza/indirizzo successivo del bytecode.
    BIT 7,A                            ; $CEFE cb 7f
    CALL NZ,$CF40                      ; $CF00 c4 40 cf
    AND $0F                            ; $CF03 e6 0f
    CP $0F                             ; $CF05 fe 0f
    JR Z,$CF41                         ; $CF07 28 38
    CP $08                             ; $CF09 fe 08
    JR Z,$CF40                         ; $CF0B 28 33
    CP $09                             ; $CF0D fe 09
    JR Z,$CF40                         ; $CF0F 28 2f
    CP $01                             ; $CF11 fe 01
    JR Z,$CF40                         ; $CF13 28 2b
    CP $02                             ; $CF15 fe 02
    JR Z,$CF3E                         ; $CF17 28 25
    CP $03                             ; $CF19 fe 03
    JR Z,$CF3F                         ; $CF1B 28 22
    CP $0D                             ; $CF1D fe 0d
    JR Z,$CF40                         ; $CF1F 28 1f
    CP $0E                             ; $CF21 fe 0e
    JR Z,$CF3F                         ; $CF23 28 1a
    CP $07                             ; $CF25 fe 07
    JR Z,$CF3D                         ; $CF27 28 14
    CP $0C                             ; $CF29 fe 0c
    JR Z,$CF3D                         ; $CF2B 28 10
    CP $0B                             ; $CF2D fe 0b
    JR Z,$CF41                         ; $CF2F 28 10
    CP $0A                             ; $CF31 fe 0a
    JR Z,$CF41                         ; $CF33 28 0c
    CP $05                             ; $CF35 fe 05
    JR Z,$CF3E                         ; $CF37 28 05
    CP $04                             ; $CF39 fe 04
    JR NZ,$CF3F                        ; $CF3B 20 02
    INC HL                             ; $CF3D 23
    INC HL                             ; $CF3E 23
    INC HL                             ; $CF3F 23
    INC HL                             ; $CF40 23
    INC HL                             ; $CF41 23
    RET                                ; $CF42 c9

    ORG $CFCF
; CODE fino a$D007
; Ripristina il contesto sospeso e libera il record temporaneo.
    CALL $CFB6                         ; $CFCF cd b6 cf
    LD E,(IX+$01)                      ; $CFD2 dd 5e 01
    LD D,(IX+$02)                      ; $CFD5 dd 56 02
    LD ($9FD9),DE                      ; $CFD8 ed 53 d9 9f
    LD (IY+$01),E                      ; $CFDC fd 73 01
    LD (IY+$02),D                      ; $CFDF fd 72 02
    PUSH IX                            ; $CFE2 dd e5
    POP DE                             ; $CFE4 d1
    PUSH IY                            ; $CFE5 fd e5
    LD IY,$9FE9                        ; $CFE7 fd 21 e9 9f
    CALL $A104                         ; $CFEB cd 04 a1
    LD L,(IX-$02)                      ; $CFEE dd 6e fe
    LD H,(IX-$01)                      ; $CFF1 dd 66 ff
    LD (IY-$02),L                      ; $CFF4 fd 75 fe
    LD (IY-$01),H                      ; $CFF7 fd 74 ff
    LD A,(IX+$05)                      ; $CFFA dd 7e 05
    PUSH AF                            ; $CFFD f5
    CALL $A1C7                         ; $CFFE cd c7 a1
    CALL $D008                         ; $D001 cd 08 d0
    POP AF                             ; $D004 f1
    POP IY                             ; $D005 fd e1
    RET                                ; $D007 c9

    ORG $DCA2
; CODE fino a$DCC0
; Predicato TAKE: esclude possesso gia acquisito e cicli fra attore e oggetto.
    CALL $D26C                         ; $DCA2 cd 6c d2
    JR C,$DCB6                         ; $DCA5 38 0f
    LD A,($A036)                       ; $DCA7 3a 36 a0
    LD HL,$A034                        ; $DCAA 21 34 a0
    CALL $D278                         ; $DCAD cd 78 d2
    JP C,$DC15                         ; $DCB0 da 15 dc
    OR $01                             ; $DCB3 f6 01
    RET                                ; $DCB5 c9
    LD HL,$DCBB                        ; $DCB6 21 bb dc
    XOR A                              ; $DCB9 af
    RET                                ; $DCBA c9
    LD HL,$68B7                        ; $DCBB 21 b7 68
    JP $A59F                           ; $DCBE c3 9f a5

    ORG $DCC1
; DATA fino a$DCC4
; Intestazione TAKE generale: 69 10 a2 dc. Corpo a$DCC5.
    DEFB $69,$10,$A2,$DC               ; $DCC1 69 10 a2 dc

    ORG $DCC5
; CODE fino a$DCD1
; TAKE: scrive A036 nel genitore+01 diA013.
    LD IX,($A013)                      ; $DCC5 dd 2a 13 a0
    LD A,($A036)                       ; $DCC9 3a 36 a0
    LD (IX+$01),A                      ; $DCCC dd 77 01
    OR $01                             ; $DCCF f6 01
    RET                                ; $DCD1 c9

    ORG $DD9E
; DATA fino a$DD9F
; Intestazione SAY TO generale: 0d 10. Corpo a$DDA0.
    DEFB $0D,$10                       ; $DD9E 0d 10

    ORG $DDA0
; CODE fino a$DDB3
; SAY TO: CC0E verifica interlocutore nella tabella attori; B86A analizza o scarta citazioni.
    LD A,($A034)                       ; $DDA0 3a 34 a0
    CALL $CC0E                         ; $DDA3 cd 0e cc
    CP $FF                             ; $DDA6 fe ff
    LD A,$00                           ; $DDA8 3e 00
    JR Z,$DDAE                         ; $DDAA 28 02
    LD A,$01                           ; $DDAC 3e 01
    CALL $B86A                         ; $DDAE cd 6a b8
    OR $01                             ; $DDB1 f6 01
    RET                                ; $DDB3 c9

    ORG $DE9D
; DATA fino a$DEA3
; Intestazione OPEN ordinario: 38 10 80 21 00 00 00. Corpo a$DEA4.
    DEFB $38,$10,$80,$21,$00,$00,$00   ; $DE9D 38 10 80 21 00 00 00

    ORG $DEA4
; CODE fino a$DEAE
; OPEN: SET5 al byte+05 del primo oggetto.
    LD IX,($A013)                      ; $DEA4 dd 2a 13 a0
    SET 5,(IX+$05)                     ; $DEA8 dd cb 05 ee
    OR $01                             ; $DEAC f6 01
    RET                                ; $DEAE c9

    ORG $DEAF
; DATA fino a$DEB5
; Intestazione CLOSE ordinario (controllo complementare): 38 10 00 20 00 00 00. Corpo a$DEB6.
    DEFB $38,$10,$00,$20,$00,$00,$00   ; $DEAF 38 10 00 20 00 00 00

    ORG $DEB6
; CODE fino a$DEC0
; CLOSE: RES5 al byte+05.
    LD IX,($A013)                      ; $DEB6 dd 2a 13 a0
    RES 5,(IX+$05)                     ; $DEBA dd cb 05 ae
    OR $01                             ; $DEBE f6 01
    RET                                ; $DEC0 c9

    ORG $DF02
; DATA fino a$DF05
; Intestazione GIVE generale: 6a 1d 24 df. Corpo a$DF06.
    DEFB $6A,$1D,$24,$DF               ; $DF02 6a 1d 24 df

    ORG $DF06
; CODE fino a$DF2D
; GIVE: nuovo genitoreA035, posizione destinatario e propagazioneD249 ai figli.
    LD IY,($A015)                      ; $DF06 fd 2a 15 a0
    LD IX,($A013)                      ; $DF0A dd 2a 13 a0
    LD A,($A035)                       ; $DF0E 3a 35 a0
    LD (IX+$01),A                      ; $DF11 dd 77 01
    LD A,(IY+$0F)                      ; $DF14 fd 7e 0f
    LD (IX+$0F),A                      ; $DF17 dd 77 0f
    LD B,A                             ; $DF1A 47
    LD A,($A034)                       ; $DF1B 3a 34 a0
    CALL $D249                         ; $DF1E cd 49 d2
    OR $01                             ; $DF21 f6 01
    RET                                ; $DF23 c9
; Predicato GIVE: capacita del destinatarioC8C6.
    LD A,($A034)                       ; $DF24 3a 34 a0
    LD B,A                             ; $DF27 47
    LD A,($A035)                       ; $DF28 3a 35 a0
    JP $C8C6                           ; $DF2B c3 c6 c8

    ORG $DF7E
; DATA fino a$DF7F
; Intestazione TAKE biglietto in fiamme: 88 00. Corpo a$DF80.
    DEFB $88,$00                       ; $DF7E 88 00

    ORG $DF80
; DATA fino a$DF8A
; BYTECODE: esegui regola a puntatore $DCC1
    DEFB $07,$C1,$DC,$FD,$FF           ; $DF80 07 c1 dc fd ff
; BYTECODE: esegui regola a puntatore $DF8B
    DEFB $07,$8B,$DF,$FD,$FF           ; $DF85 07 8b df fd ff
; BYTECODE: ritorno al contesto sospeso, CFCF
    DEFB $0B                           ; $DF8A 0b

    ORG $DF8B
; DATA fino a$DF8C
; Intestazione aggiornamento biglietto dopo TAKE: 08 00. Corpo a$DF8D.
    DEFB $08,$00                       ; $DF8B 08 00

    ORG $DF8D
; CODE fino a$DFA6
; Nota85: se contatore nonzero, impostaloFF e cambia qualificatore in SINGED(07D5).
    LD A,($9CA1)                       ; $DF8D 3a a1 9c
    AND A                              ; $DF90 a7
    JR Z,$E000                         ; $DF91 28 6d
    LD A,$FF                           ; $DF93 3e ff
    LD ($9CA1),A                       ; $DF95 32 a1 9c
    LD IX,($A013)                      ; $DF98 dd 2a 13 a0
    LD HL,$07D5                        ; $DF9C 21 d5 07
    LD (IX+$09),L                      ; $DF9F dd 75 09
    LD (IX+$0A),H                      ; $DFA2 dd 74 0a
    JR $E000                           ; $DFA5 18 59

    ORG $DFA7
; DATA fino a$DFAA
; Intestazione OPEN cassaforte: c8 00 1c e0. Corpo a$DFAB.
    DEFB $C8,$00,$1C,$E0               ; $DFA7 c8 00 1c e0

    ORG $DFAB
; DATA fino a$DFB5
; BYTECODE: esegui regola a puntatore $DFB6
    DEFB $07,$B6,$DF,$FD,$FF           ; $DFAB 07 b6 df fd ff
; BYTECODE: esegui regola a puntatore $DE9D
    DEFB $07,$9D,$DE,$FD,$FF           ; $DFB0 07 9d de fd ff
; BYTECODE: ritorno al contesto sospeso, CFCF
    DEFB $0B                           ; $DFB5 0b

    ORG $DFB6
; DATA fino a$DFB7
; Intestazione evento narrativo cassaforte: 07 f0. Corpo a$DFB8.
    DEFB $07,$F0                       ; $DFB6 07 f0

    ORG $DFB8
; CODE fino a$DFC9
; Cassaforte89 al giorno0: ramo narrativo che porta a9E74/fine partita.
    LD A,($A034)                       ; $DFB8 3a 34 a0
    CP $59                             ; $DFBB fe 59
    JP NZ,$E000                        ; $DFBD c2 00 e0
    LD A,($9FE1)                       ; $DFC0 3a e1 9f
    CP $00                             ; $DFC3 fe 00
    JP NZ,$E000                        ; $DFC5 c2 00 e0
    JR $DFCC                           ; $DFC8 18 02

    ORG $DFCA
; DATA fino a$DFCB
; Byte saltati dalJR DFC8; mantenuti come dati, non NOP interpretati.
    DEFB $00,$00                       ; $DFCA 00 00

    ORG $DFCC
; CODE fino a$DFE2
    LD HL,$759C                        ; $DFCC 21 9c 75
    LD A,$06                           ; $DFCF 3e 06
    CALL $D237                         ; $DFD1 cd 37 d2
    LD A,($A009)                       ; $DFD4 3a 09 a0
    CP (IX+$0F)                        ; $DFD7 dd be 0f
    JP NZ,$9E74                        ; $DFDA c2 74 9e
    LD HL,$75D2                        ; $DFDD 21 d2 75
    JP $9E74                           ; $DFE0 c3 74 9e

    ORG $DFFD
; CODE fino a$E002
    JP NZ,$DC15                        ; $DFFD c2 15 dc
    OR $01                             ; $E000 f6 01
    RET                                ; $E002 c9

    ORG $E01C
; CODE fino a$E021
; Predicato cassaforte: ammette soltanto attore0.
    LD A,($A036)                       ; $E01C 3a 36 a0
    AND A                              ; $E01F a7
    JR $DFFD                           ; $E020 18 db
