; Sherlock: DATA boundaries are established by table readers.

    ORG $99F1
; DATA: Last mutable fact: six-byte prefix and reference terms
    DEFB $0D,$01,$5E,$A4,$0A,$9A,$00,$00 ; $99F1 0d 01 5e a4 0a 9a 00 00
    DEFB $00,$08                        ; $99F9 00 08

    ORG $99FB
; DATA: Immutable fact-table terminator: subject FF
    DEFB $FF                            ; $99FB ff

    ORG $99FC
; CODE: Fact handler and excerpt that modifies 99FA, not the terminator
    CALL $9A74                          ; $99FC cd 74 9a
    LD HL,$7079                         ; $99FF 21 79 70
    JP $A59F                            ; $9A02 c3 9f a5
    LD HL,$99FA                         ; $9A05 21 fa 99
    SET 1,(HL)                          ; $9A08 cb ce
    CALL $9A74                          ; $9A0A cd 74 9a

    ORG $BC46
; CODE: Three fact scanners: compare subject with FF
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

    ORG $CAF0
; CODE: Announce shared-object action with anonymous actor FF
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

    ORG $D7FA
; DATA: Player semantic-rule header: classes zero, zero duration
    DEFB $00,$00                        ; $D7FA 00 00
