; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.

    ORG $A815
; CODE: Ingresso del sostantivo nel decoder
    PUSH AF                              ; $A815 f5 | Il riferimento del sostantivo viene selezionato prima dello spazio che scarica il qualificatore precedente.
    LD A,D                               ; $A816 7a
    AND $0F                              ; $A817 e6 0f
    LD D,A                               ; $A819 57
    POP AF                               ; $A81A f1
    OR D                                 ; $A81B b2
    LD D,A                               ; $A81C 57
    AND $0F                              ; $A81D e6 0f
    OR E                                 ; $A81F b3
    RET Z                                ; $A820 c8
    CALL $A887                           ; $A821 cd 87 a8
    LD A,($A7EA)                         ; $A824 3a ea a7
    PUSH HL                              ; $A827 e5
    LD HL,$A026                          ; $A828 21 26 a0
    OR (HL)                              ; $A82B b6
    LD (HL),A                            ; $A82C 77
    POP HL                               ; $A82D e1
    RET                                  ; $A82E c9

    ORG $A887
; CODE: Separatore con descrittore della parola successiva
    LD A,($5C3C)                         ; $A887 3a 3c 5c
    AND A                                ; $A88A a7
    RET Z                                ; $A88B c8
    LD ($A022),DE                        ; $A88C ed 53 22 a0
    LD A,D                               ; $A890 7a
    AND $0F                              ; $A891 e6 0f
    OR E                                 ; $A893 b3
    RET Z                                ; $A894 c8
    PUSH IX                              ; $A895 dd e5
    PUSH HL                              ; $A897 e5
    PUSH BC                              ; $A898 c5
    PUSH DE                              ; $A899 d5
    LD A,$20                             ; $A89A 3e 20
    CALL $A9B7                           ; $A89C cd b7 a9 | Lo spazio iniziale del sostantivo passa con DE del nuovo riferimento. Il glifo spazio non porta DE del buffer della parola daily.
    LD A,D                               ; $A89F 7a
    AND $F0                              ; $A8A0 e6 f0
    LD C,A                               ; $A8A2 4f
    CP $70                               ; $A8A3 fe 70
    LD A,$01                             ; $A8A5 3e 01
    JR NZ,$A8AC                          ; $A8A7 20 03
    LD ($A026),A                         ; $A8A9 32 26 a0
    LD A,D                               ; $A8AC 7a
    AND $0F                              ; $A8AD e6 0f
    LD D,A                               ; $A8AF 57
    EX DE,HL                             ; $A8B0 eb
    PUSH HL                              ; $A8B1 e5
    LD A,H                               ; $A8B2 7c
    OR C                                 ; $A8B3 b1
    LD H,A                               ; $A8B4 67
    LD ($A022),HL                        ; $A8B5 22 22 a0
    POP HL                               ; $A8B8 e1

    ORG $C388
; CODE: Salvataggi DE e AF del glifo
    PUSH AF                              ; $C388 f5 | LOOK ordinario,ultimo nome portato: qualificatore a5D1A,spazio a5D26,nome finale a5D4C,wrap finale a5D46. I frame non sono intercambiabili.
    PUSH BC                              ; $C389 c5
    PUSH DE                              ; $C38A d5 | PUSH DE salva E inframe-6 e D inframe-5. Con frame5D26,D occupa5D21: al3315 è51 del descrittore51AB. Nessun51 fisso nel modello.
    PUSH HL                              ; $C38B e5
    LD L,A                               ; $C38C 6f
    LD H,$00                             ; $C38D 26 00
    ADD HL,HL                            ; $C38F 29
    ADD HL,HL                            ; $C390 29
    ADD HL,HL                            ; $C391 29
    LD DE,$3C00                          ; $C392 11 00 3c
    ADD HL,DE                            ; $C395 19
    EX DE,HL                             ; $C396 eb
    POP HL                               ; $C397 e1
    PUSH HL                              ; $C398 e5
    LD B,$08                             ; $C399 06 08
    LD A,(DE)                            ; $C39B 1a
    PUSH BC                              ; $C39C c5
    PUSH AF                              ; $C39D f5 | Il salvataggio AF più profondo non riscrive D21. F e A della scansione hanno un contratto indipendente.

    ORG $D3E8
; CODE: Nomi comuni: articolo, qualificatori e sostantivo
    PUSH AF                              ; $D3E8 f5
    PUSH DE                              ; $D3E9 d5
    LD D,(IY+$01)                        ; $D3EA fd 56 01
    LD E,(IY+$00)                        ; $D3ED fd 5e 00
    CALL $A7D0                           ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                       ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                          ; $D3F7 20 04
    XOR A                                ; $D3F9 af
    LD ($A7EA),A                         ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                       ; $D3FD fd cb ff 6e
    JR NZ,$D427                          ; $D401 20 24
    JR $D416                             ; $D403 18 11
    PUSH AF                              ; $D405 f5
    PUSH DE                              ; $D406 d5
    LD D,(IY+$01)                        ; $D407 fd 56 01
    LD E,(IY+$00)                        ; $D40A fd 5e 00
    CALL $A7D0                           ; $D40D cd d0 a7
    LD A,($A028)                         ; $D410 3a 28 a0
    AND A                                ; $D413 a7
    JR NZ,$D438                          ; $D414 20 22
    LD E,(IY+$02)                        ; $D416 fd 5e 02
    LD D,(IY+$03)                        ; $D419 fd 56 03
    RES 7,D                              ; $D41C cb ba
    BIT 7,(IY+$03)                       ; $D41E fd cb 03 7e
    LD A,$40                             ; $D422 3e 40
    CALL Z,$A815                         ; $D424 cc 15 a8 | Qualificatori nel contesto4; il sostantivo usa contesto5. Il delimitatore viene emesso dal decoder della parola successiva.
    LD E,(IY+$04)                        ; $D427 fd 5e 04
    LD D,(IY+$05)                        ; $D42A fd 56 05
    RES 7,D                              ; $D42D cb ba
    BIT 7,(IY+$05)                       ; $D42F fd cb 05 7e
    LD A,$40                             ; $D433 3e 40
    CALL Z,$A815                         ; $D435 cc 15 a8
    LD E,(IY+$00)                        ; $D438 fd 5e 00
    LD D,(IY+$01)                        ; $D43B fd 56 01
    LD A,D                               ; $D43E 7a
    OR E                                 ; $D43F b3
    LD A,$50                             ; $D440 3e 50
    CALL NZ,$A815                        ; $D442 c4 15 a8 | Il sostantivo finale resta in buffer fino al CR del chiamante; il wrap misurato a5D46 non raggiunge21.

    ORG $D526
; CODE: Elenco ricorsivo e frase degli oggetti portati
    PUSH IX                              ; $D526 dd e5 | Il livello ricorsivo e il chiamante LOOK determinano lo stack. Il contratto nuovo è limitato al nome comune finale portato da una persona,con testo grezzo verificato.
    CALL $D04F                           ; $D528 cd 4f d0
    PUSH AF                              ; $D52B f5
    CALL $D57D                           ; $D52C cd 7d d5
    JR C,$D55A                           ; $D52F 38 29
    SET 7,(IY+$06)                       ; $D531 fd cb 06 fe
    SUB A                                ; $D535 97
    LD ($A028),A                         ; $D536 32 28 a0
    CALL $D3D9                           ; $D539 cd d9 d3
    DEC C                                ; $D53C 0d
    LD A,C                               ; $D53D 79
    AND A                                ; $D53E a7
    JR NZ,$D546                          ; $D53F 20 05
    CALL $A414                           ; $D541 cd 14 a4
    JR $D557                             ; $D544 18 11
    CP $01                               ; $D546 fe 01
    JR Z,$D551                           ; $D548 28 07
    LD A,$2C                             ; $D54A 3e 2c
    CALL $A9B7                           ; $D54C cd b7 a9
    JR $D557                             ; $D54F 18 06
    LD DE,$005D                          ; $D551 11 5d 00
    CALL $A887                           ; $D554 cd 87 a8
    POP AF                               ; $D557 f1
    JR $D52B                             ; $D558 18 d1
    POP AF                               ; $D55A f1
    CALL $D04F                           ; $D55B cd 4f d0
    PUSH AF                              ; $D55E f5
    CALL $D57D                           ; $D55F cd 7d d5
    JR C,$D578                           ; $D562 38 14
    PUSH AF                              ; $D564 f5
    CALL $D4CC                           ; $D565 cd cc d4
    JR Z,$D574                           ; $D568 28 0a
    LD C,A                               ; $D56A 4f
    POP AF                               ; $D56B f1
    CALL $D590                           ; $D56C cd 90 d5
    CALL $D526                           ; $D56F cd 26 d5
    JR $D575                             ; $D572 18 01
    POP AF                               ; $D574 f1
    POP AF                               ; $D575 f1
    JR $D55E                             ; $D576 18 e6
    POP AF                               ; $D578 f1
    POP IX                               ; $D579 dd e1
    RET                                  ; $D57B c9
    POP AF                               ; $D57C f1
    CALL $D21C                           ; $D57D cd 1c d2
    JR NZ,$D584                          ; $D580 20 02
    SCF                                  ; $D582 37
    RET                                  ; $D583 c9
    PUSH AF                              ; $D584 f5
    CALL $D4EF                           ; $D585 cd ef d4
    JR NC,$D57C                          ; $D588 30 f2
    POP AF                               ; $D58A f1
    LD A,(IX+$00)                        ; $D58B dd 7e 00
    AND A                                ; $D58E a7
    RET                                  ; $D58F c9
    PUSH IX                              ; $D590 dd e5
    PUSH BC                              ; $D592 c5
    PUSH AF                              ; $D593 f5
    CALL $D237                           ; $D594 cd 37 d2
    BIT 6,(IX+$05)                       ; $D597 dd cb 05 76
    JR Z,$D5A5                           ; $D59B 28 08
    POP AF                               ; $D59D f1
    PUSH AF                              ; $D59E f5
    PUSH AF                              ; $D59F f5
    LD HL,$68B1                          ; $D5A0 21 b1 68
    JR $D5C1                             ; $D5A3 18 1c
    LD HL,$0485                          ; $D5A5 21 85 04
    DEC C                                ; $D5A8 0d
    JR Z,$D5AE                           ; $D5A9 28 03
    LD HL,$007A                          ; $D5AB 21 7a 00
    PUSH HL                              ; $D5AE e5
    CALL $D5D3                           ; $D5AF cd d3 d5
    LD A,$01                             ; $D5B2 3e 01
    LD ($A2AA),A                         ; $D5B4 32 aa a2
    CALL $D3D5                           ; $D5B7 cd d5 d3
    XOR A                                ; $D5BA af
    LD ($A2AA),A                         ; $D5BB 32 aa a2
    LD HL,$68D9                          ; $D5BE 21 d9 68
    CALL $A59F                           ; $D5C1 cd 9f a5
    POP AF                               ; $D5C4 f1 | Ritorno dall’elenco prima del CR esterno. La conservazione diD21 attraverso il sostantivo finale è verificata separatamente.
    POP BC                               ; $D5C5 c1
    POP IX                               ; $D5C6 dd e1
    RET                                  ; $D5C8 c9
