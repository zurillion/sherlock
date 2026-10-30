; Dossier offline: i byte sono riassellati contro il payload, non eseguiti nel runtime JS.

    ORG $682A
; DATA: Testo degli ordini NPC: prefisso, comando composto e chiusura
    DEFB $0B,$DA,$FF,$18,$22,$1E          ; $682A 0b da ff 18 22 1e | Programma del testo:6804 ->67F7 ->nome attore, poi ordine composto. Il prefisso proprio viene scaricato dentro la chiamata del nome con frameC388=5D2A.

    ORG $A59F
; CODE: Ingresso pubblico del testo e stack degli argomenti
    PUSH BC                               ; $A59F c5 | I salvataggi e gli ingressi annidati determinano il frame del renderer. Non introdurre una profondità fissa per ogni stampa.
    PUSH DE                               ; $A5A0 d5
    PUSH IX                               ; $A5A1 dd e5
    PUSH AF                               ; $A5A3 f5
    PUSH HL                               ; $A5A4 e5
    LD HL,$000C                           ; $A5A5 21 0c 00
    ADD HL,SP                             ; $A5A8 39
    LD ($A59D),HL                         ; $A5A9 22 9d a5
    POP HL                                ; $A5AC e1
    LD A,($A00B)                          ; $A5AD 3a 0b a0
    AND A                                 ; $A5B0 a7
    JR NZ,$A5B6                           ; $A5B1 20 03
    LD ($A00C),A                          ; $A5B3 32 0c a0
    CALL $A5C4                            ; $A5B6 cd c4 a5
    POP AF                                ; $A5B9 f1
    POP IX                                ; $A5BA dd e1
    POP DE                                ; $A5BC d1
    POP BC                                ; $A5BD c1
    POP HL                                ; $A5BE e1
    LD SP,($A59D)                         ; $A5BF ed 7b 9d a5
    JP (HL)                               ; $A5C3 e9
    PUSH HL                               ; $A5C4 e5
    POP IX                                ; $A5C5 dd e1
    CALL $A5CD                            ; $A5C7 cd cd a5
    JR NZ,$A5C7                           ; $A5CA 20 fb
    RET                                   ; $A5CC c9

    ORG $A720
; CODE: Nome dell’attore e chiamate relative dei testi
    XOR A                                 ; $A720 af
    LD ($A028),A                          ; $A721 32 28 a0
    LD A,($A036)                          ; $A724 3a 36 a0
    CALL $A82F                            ; $A727 cd 2f a8
    XOR A                                 ; $A72A af
    RET                                   ; $A72B c9
    LD A,$01                              ; $A72C 3e 01
    LD ($A028),A                          ; $A72E 32 28 a0
    LD A,($A034)                          ; $A731 3a 34 a0
    JR $A751                              ; $A734 18 1b
    CALL $A9B7                            ; $A736 cd b7 a9
    XOR A                                 ; $A739 af
    RET                                   ; $A73A c9
    LD A,$01                              ; $A73B 3e 01
    LD ($A028),A                          ; $A73D 32 28 a0
    LD A,($A035)                          ; $A740 3a 35 a0
    JR $A751                              ; $A743 18 0c
    JR NC,$A751                           ; $A745 30 0a
    PUSH HL                               ; $A747 e5
    CALL $A4AB                            ; $A748 cd ab a4
    CALL $A7BA                            ; $A74B cd ba a7
    POP HL                                ; $A74E e1
    XOR A                                 ; $A74F af
    RET                                   ; $A750 c9
    PUSH HL                               ; $A751 e5
    CALL $A4BC                            ; $A752 cd bc a4
    CALL $A7C5                            ; $A755 cd c5 a7 | Il nome dell’attore attraversa A7C5 e D3E8. Il delimitatore del qualificatore causa lo scarico prima del ritorno del sostantivo finale.
    POP HL                                ; $A758 e1
    XOR A                                 ; $A759 af
    RET                                   ; $A75A c9
    PUSH IX                               ; $A75B dd e5
    POP HL                                ; $A75D e1
    PUSH HL                               ; $A75E e5
    LD E,(IX+$01)                         ; $A75F dd 5e 01
    LD D,(IX+$02)                         ; $A762 dd 56 02
    ADD HL,DE                             ; $A765 19
    CALL $A5C4                            ; $A766 cd c4 a5
    POP IX                                ; $A769 dd e1
    INC IX                                ; $A76B dd 23
    INC IX                                ; $A76D dd 23
    XOR A                                 ; $A76F af
    RET                                   ; $A770 c9

    ORG $A7C5
; CODE: Descrittore del nome: ponte al renderer di entità
    PUSH IY                               ; $A7C5 fd e5
    PUSH HL                               ; $A7C7 e5
    POP IY                                ; $A7C8 fd e1
    CALL $D3E8                            ; $A7CA cd e8 d3
    POP IY                                ; $A7CD fd e1
    RET                                   ; $A7CF c9

    ORG $D3E8
; CODE: Nome composto: prefissi e sostantivo finale con scarico differito
    PUSH AF                               ; $D3E8 f5
    PUSH DE                               ; $D3E9 d5
    LD D,(IY+$01)                         ; $D3EA fd 56 01
    LD E,(IY+$00)                         ; $D3ED fd 5e 00
    CALL $A7D0                            ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                        ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                           ; $D3F7 20 04
    XOR A                                 ; $D3F9 af
    LD ($A7EA),A                          ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                        ; $D3FD fd cb ff 6e
    JR NZ,$D427                           ; $D401 20 24
    JR $D416                              ; $D403 18 11
    PUSH AF                               ; $D405 f5
    PUSH DE                               ; $D406 d5
    LD D,(IY+$01)                         ; $D407 fd 56 01
    LD E,(IY+$00)                         ; $D40A fd 5e 00
    CALL $A7D0                            ; $D40D cd d0 a7
    LD A,($A028)                          ; $D410 3a 28 a0
    AND A                                 ; $D413 a7
    JR NZ,$D438                           ; $D414 20 22
    LD E,(IY+$02)                         ; $D416 fd 5e 02 | Qualificatore del nome proprio: Inspector termina con r. L’ultima stampa naturale verificata conserva il descrittore del buffer parola5C0B.
    LD D,(IY+$03)                         ; $D419 fd 56 03
    RES 7,D                               ; $D41C cb ba
    BIT 7,(IY+$03)                        ; $D41E fd cb 03 7e
    LD A,$40                              ; $D422 3e 40
    CALL Z,$A815                          ; $D424 cc 15 a8
    LD E,(IY+$04)                         ; $D427 fd 5e 04
    LD D,(IY+$05)                         ; $D42A fd 56 05
    RES 7,D                               ; $D42D cb ba
    BIT 7,(IY+$05)                        ; $D42F fd cb 05 7e
    LD A,$40                              ; $D433 3e 40
    CALL Z,$A815                          ; $D435 cc 15 a8
    LD E,(IY+$00)                         ; $D438 fd 5e 00 | Il delimitatore di un sostantivo può fornire un descrittore lessicale5000|noun, distinto dal puntatore del buffer. Conservare il parametro effettivo.
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $A95B
; CODE: Decoder dei candidati: scrittore alternativo del medesimo stack
    PUSH BC                               ; $A95B c5
    LD IX,$5C42                           ; $A95C dd 21 42 5c
    INC HL                                ; $A960 23
    LD A,(HL)                             ; $A961 7e
    BIT 7,A                               ; $A962 cb 7f
    INC HL                                ; $A964 23
    JR Z,$A969                            ; $A965 28 02
    INC HL                                ; $A967 23
    INC HL                                ; $A968 23
    PUSH AF                               ; $A969 f5
    AND $70                               ; $A96A e6 70
    JR Z,$A974                            ; $A96C 28 06
    INC IX                                ; $A96E dd 23
    SUB $10                               ; $A970 d6 10
    JR NZ,$A96E                           ; $A972 20 fa
    LD C,$00                              ; $A974 0e 00
    POP AF                                ; $A976 f1
    AND $0F                               ; $A977 e6 0f
    JR Z,$A986                            ; $A979 28 0b
    LD B,A                                ; $A97B 47
    CALL $A990                            ; $A97C cd 90 a9 | Il decoder di un candidato condivide lo stack ma non il contratto dei glifi. Caller sconosciuti revocano, non conservano un vecchio0B.
    LD (IX+$00),A                         ; $A97F dd 77 00
    INC IX                                ; $A982 dd 23
    DJNZ $A97C                            ; $A984 10 f6
    LD (IX+$00),$00                       ; $A986 dd 36 00 00
    LD A,C                                ; $A98A 79
    POP BC                                ; $A98B c1
    AND A                                 ; $A98C a7
    RET Z                                 ; $A98D c8
    INC HL                                ; $A98E 23
    RET                                   ; $A98F c9

    ORG $C363
; CODE: Pulizia riga: CALL reale e byte alto del return link
    LD A,($C128)                          ; $C363 3a 28 c1
    AND A                                 ; $C366 a7
    LD B,$24                              ; $C367 06 24
    JR Z,$C36D                            ; $C369 28 02
    LD B,$12                              ; $C36B 06 12
    LD HL,$5020                           ; $C36D 21 20 50
    LD C,$02                              ; $C370 0e 02
    LD A,$20                              ; $C372 3e 20
    CALL $C388                            ; $C374 cd 88 c3 | La CALL reale scrive C377. Con frame5D24 la stessa cella fisica5D24 contiene77 del return link, nonE del descrittore.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $C388
; CODE: Glifo: righe e registri salvati; descrittore DE: E salvato a5D24 nel frame5D2A
    PUSH AF                               ; $C388 f5 | AF del chiamante a frame-2. Con frame5D26 la cella5D24 èF del chiamante: dipende daCP13 o dal caller della pulizia.
    PUSH BC                               ; $C389 c5 | BC del chiamante a frame-4. Con frame5D28 la cella5D24 èC, non0B; BC non noto revoca quel ruolo.
    PUSH DE                               ; $C38A d5 | PUSH DE prima di caricare3C00 e calcolare il font. Con frame5D2A il byteE va in5D24 eD in5D25. Pubblicato soltanto5D24: descriptor&FF. Tre descrittori5C0B/5C42/5123 verificano il parametro, non una costante catturata.
    PUSH HL                               ; $C38B e5 | HL video a frame-8. Con frame5D2C la cella5D24 contieneL, calcolato dalla colonna. Non derivareE da questo indirizzo o dal vicino5D23.
    LD L,A                                ; $C38C 6f
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c | Questo LD DE imposta il font DOPO il PUSH: il residuo a5D24 non è il byte basso della riga del font.
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5 | Con frame5D2E la cella5D24 contieneC dello shift interno, prima diDJNZ.
    PUSH AF                               ; $C39D f5 | Con frame5D30 la cella5D24 contieneF della scansione. La derivazione daINC H eDEC/INC C era stata ricostruita per5D1E; non equivale aE.
    DEC C                                 ; $C39E 0d
    INC C                                 ; $C39F 0c
    LD B,$FF                              ; $C3A0 06 ff
    JR Z,$C3AB                            ; $C3A2 28 07
    SRL A                                 ; $C3A4 cb 3f
    SRL B                                 ; $C3A6 cb 38
    DEC C                                 ; $C3A8 0d
    JR NZ,$C3A4                           ; $C3A9 20 f9
    LD C,A                                ; $C3AB 4f
    LD A,B                                ; $C3AC 78
    CPL                                   ; $C3AD 2f
    AND (HL)                              ; $C3AE a6
    OR C                                  ; $C3AF b1
    LD (HL),A                             ; $C3B0 77
    POP AF                                ; $C3B1 f1
    POP BC                                ; $C3B2 c1
    DEC C                                 ; $C3B3 0d
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5
    PUSH AF                               ; $C3B8 f5
    LD A,$08                              ; $C3B9 3e 08
    SUB C                                 ; $C3BB 91
    LD C,A                                ; $C3BC 4f
    POP AF                                ; $C3BD f1
    LD B,$FF                              ; $C3BE 06 ff
    SLA A                                 ; $C3C0 cb 27
    SLA B                                 ; $C3C2 cb 20
    DEC C                                 ; $C3C4 0d
    JR NZ,$C3C0                           ; $C3C5 20 f9
    LD C,A                                ; $C3C7 4f
    LD A,B                                ; $C3C8 78
    CPL                                   ; $C3C9 2f
    INC HL                                ; $C3CA 23
    AND (HL)                              ; $C3CB a6
    OR C                                  ; $C3CC b1
    LD (HL),A                             ; $C3CD 77
    DEC HL                                ; $C3CE 2b
    POP BC                                ; $C3CF c1
    INC DE                                ; $C3D0 13
    INC H                                 ; $C3D1 24
    DJNZ $C39B                            ; $C3D2 10 c7
    POP HL                                ; $C3D4 e1
    POP DE                                ; $C3D5 d1
    POP BC                                ; $C3D6 c1
    LD A,C                                ; $C3D7 79
    ADD A,$07                             ; $C3D8 c6 07
    CP $08                                ; $C3DA fe 08
    JR C,$C3E1                            ; $C3DC 38 03
    SUB $08                               ; $C3DE d6 08
    INC L                                 ; $C3E0 2c
    LD C,A                                ; $C3E1 4f
    POP AF                                ; $C3E2 f1
    RET                                   ; $C3E3 c9

    ORG $CE10
; CODE: Ordine NPC: stampa 682A dopo aver registrato la richiesta
    LD HL,$682A                           ; $CE10 21 2a 68
    CALL $A59F                            ; $CE13 cd 9f a5 | Prefisso proprio dell’attore: il contratto upperGlyphKnown abilita il nuovo byte. Scene, errori, caller sconosciuti lo revocano. Old LOAD senza5D24 resta unknown anche con5D23 noto.
    JR $CE8F                              ; $CE16 18 77
