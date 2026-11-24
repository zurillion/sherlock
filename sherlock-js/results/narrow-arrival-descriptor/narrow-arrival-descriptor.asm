; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.

    ORG $A887
; CODE: Descrittore del nome selezionato prima dello spazio
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
    CALL $A9B7                           ; $A89C cd b7 a9 | Lo spazio che scarica steam usa già DE58EB,train. Il parametro non è il buffer5C0B della parola precedente.
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
; CODE: PUSH DE del glifo: E inframe-6
    PUSH AF                              ; $C388 f5 | Arrivo al binario55: prefisso a steam a5D1C,spazio del sostantivo a5D28. In finestra stretta la posizione osservata è colonna5.
    PUSH BC                              ; $C389 c5
    PUSH DE                              ; $C38A d5 | PUSH DE salva E a5D22 quando frame5D28. E deriva da5000|noun,non da unoEB fisso. D23 resta senza nuovo contratto.
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
    PUSH AF                              ; $C39D f5

    ORG $D102
; CODE: Arrivo completo e immagine della locazione
    CALL $D0DD                           ; $D102 cd dd d0 | Il chiamante dell’arrivo completo è distinto dal LOOK. Le PUSH e CALL seguenti determinano il frame dell’elenco della stanza.
    PUSH IX                              ; $D105 dd e5
    PUSH IY                              ; $D107 fd e5
    PUSH BC                              ; $D109 c5
    CALL $D113                           ; $D10A cd 13 d1
    POP BC                               ; $D10D c1
    POP IY                               ; $D10E fd e1
    POP IX                               ; $D110 dd e1
    RET                                  ; $D112 c9
    LD B,A                               ; $D113 47
    CALL $D224                           ; $D114 cd 24 d2
    LD A,B                               ; $D117 78
    CALL $A277                           ; $D118 cd 77 a2 | La grafica riapre una finestra stretta per il testo. Non attribuire il contratto alla sola parola inglese train.

    ORG $D3D5
; CODE: Nome comune: articolo,qualificatori e sostantivo
    PUSH IX                              ; $D3D5 dd e5
    POP IY                               ; $D3D7 fd e1
    PUSH IY                              ; $D3D9 fd e5
    PUSH DE                              ; $D3DB d5
    LD DE,$0007                          ; $D3DC 11 07 00
    ADD IY,DE                            ; $D3DF fd 19
    CALL $D3E8                           ; $D3E1 cd e8 d3 | D3D9 ha ricevuto IY dell’oggetto da elencare; D3DC sposta IY di7 ai riferimenti nominali.
    POP DE                               ; $D3E4 d1
    POP IY                               ; $D3E5 fd e1
    RET                                  ; $D3E7 c9
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
    CALL Z,$A815                         ; $D424 cc 15 a8 | Qualificatore steam nel contesto4,484C; il successivo sostantivo selezionerà contesto5,58EB.
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
    CALL NZ,$A815                        ; $D442 c4 15 a8 | Il sostantivo resta in buffer fino al puntoA414 e alCR esterno. Scarico finale a5D48,non allo stesso frame del qualificatore.
    POP DE                               ; $D445 d1
    POP AF                               ; $D446 f1
    RET                                  ; $D447 c9

    ORG $D526
; CODE: Elenco degli oggetti visibili alla radice
    PUSH IX                              ; $D526 dd e5
    CALL $D04F                           ; $D528 cd 4f d0
    PUSH AF                              ; $D52B f5
    CALL $D57D                           ; $D52C cd 7d d5
    JR C,$D55A                           ; $D52F 38 29
    SET 7,(IY+$06)                       ; $D531 fd cb 06 fe | Marca l’oggetto elencato. Il nuovo contratto runtime richiede un solo oggetto comune alla radice e senza contenuti.
    SUB A                                ; $D535 97
    LD ($A028),A                         ; $D536 32 28 a0 | A028=0 per il nome ordinario dell’elenco,non il nome richiesto in una citazione.
    CALL $D3D9                           ; $D539 cd d9 d3 | D3D9 formatta l’oggetto corrente. Entrata D3E8 misurata aSP5D42 per il treno.
    DEC C                                ; $D53C 0d
    LD A,C                               ; $D53D 79
    AND A                                ; $D53E a7
    JR NZ,$D546                          ; $D53F 20 05
    CALL $A414                           ; $D541 cd 14 a4 | Ultimo oggetto: A414 emette il punto. A9B7 riceve46 aSP5D48; il successivoCR esterno haSP5D5C.
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
