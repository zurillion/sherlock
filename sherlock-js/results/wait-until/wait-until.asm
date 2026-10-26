; WAIT UNTIL: data is not disassembled.

    ORG $A068
; CODE: Calendar update, clock display, ENTER poll before actor visits
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

    ORG $DDCB
; DATA: Current and target 12-hour totals, selected AM/PM
    DEFB $00,$00,$00,$00,$00            ; $DDCB 00 00 00 00 00

    ORG $DDD0
; DATA: WAIT UNTIL rule header
    DEFB $45,$00,$B8,$DD                ; $DDD0 45 00 b8 dd

    ORG $DDD4
; CODE: 12-hour target selection and original unsigned cost
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
