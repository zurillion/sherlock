; Dossier offline: i byte sono riassellati contro il payload, non eseguiti nel runtime JS.

    ORG $9920
; DATA: Terminatore immutabile FF della tabella attori
    DEFB $FF                              ; $9920 ff

    ORG $A360
; CODE: Ordine citato: soggetto temporaneo e nome della destinazione
    LD A,($A036)                          ; $A360 3a 36 a0 | Soggetto temporaneo0 durante la citazione dell’ordine diLestrade: non è un turno extra diHolmes.
    PUSH AF                               ; $A363 f5
    LD HL,$A35E                           ; $A364 21 5e a3
    CP (HL)                               ; $A367 be
    LD A,$00                              ; $A368 3e 00
    JR NZ,$A36D                           ; $A36A 20 01
    LD (HL),A                             ; $A36C 77
    LD ($A036),A                          ; $A36D 32 36 a0
    PUSH IX                               ; $A370 dd e5
    CALL $A37D                            ; $A372 cd 7d a3
    POP IX                                ; $A375 dd e1
    POP AF                                ; $A377 f1
    LD ($A036),A                          ; $A378 32 36 a0
    XOR A                                 ; $A37B af
    RET                                   ; $A37C c9
    XOR A                                 ; $A37D af
    LD ($A028),A                          ; $A37E 32 28 a0
    LD A,($A35D)                          ; $A381 3a 5d a3
    CALL $A2B1                            ; $A384 cd b1 a2
    PUSH HL                               ; $A387 e5
    POP IX                                ; $A388 dd e1
    PUSH HL                               ; $A38A e5
    CALL $A2BD                            ; $A38B cd bd a2
    CALL $C493                            ; $A38E cd 93 c4
    CALL $C4B2                            ; $A391 cd b2 c4
    POP HL                                ; $A394 e1
    LD A,($A01D)                          ; $A395 3a 1d a0
    LD C,A                                ; $A398 4f
    PUSH HL                               ; $A399 e5
    LD DE,$0006                           ; $A39A 11 06 00
    ADD HL,DE                             ; $A39D 19
    CALL $A880                            ; $A39E cd 80 a8
    POP HL                                ; $A3A1 e1
    CALL $A880                            ; $A3A2 cd 80 a8
    BIT 3,C                               ; $A3A5 cb 59
    JR Z,$A3E2                            ; $A3A7 28 39
    BIT 5,C                               ; $A3A9 cb 69
    CALL NZ,$A880                         ; $A3AB c4 80 a8
    LD A,($A01E)                          ; $A3AE 3a 1e a0
    BIT 7,A                               ; $A3B1 cb 7f
    CALL NZ,$A880                         ; $A3B3 c4 80 a8
    LD A,($A35E)                          ; $A3B6 3a 5e a3
    CP $FE                                ; $A3B9 fe fe
    JR NZ,$A3C7                           ; $A3BB 20 0a
    PUSH HL                               ; $A3BD e5
    LD HL,($A02F)                         ; $A3BE 2a 2f a0
    CALL $A419                            ; $A3C1 cd 19 a4
    POP HL                                ; $A3C4 e1
    JR $A3E2                              ; $A3C5 18 1b
    PUSH HL                               ; $A3C7 e5
    LD HL,$A036                           ; $A3C8 21 36 a0
    CP (HL)                               ; $A3CB be
    JR NZ,$A3D6                           ; $A3CC 20 08
    LD DE,$055B                           ; $A3CE 11 5b 05
    CALL $A887                            ; $A3D1 cd 87 a8
    JR $A3E1                              ; $A3D4 18 0b
    LD A,($A00F)                          ; $A3D6 3a 0f a0
    CP $05                                ; $A3D9 fe 05
    LD A,($A35E)                          ; $A3DB 3a 5e a3
    CALL $A745                            ; $A3DE cd 45 a7 | Destinazione locazione, percorso distinto dal nome entità: A745/A4AB/A7BA/D405. Il prefisso proprio del nome usa frame5D32 nel chiamante CE13 verificato.
    POP HL                                ; $A3E1 e1
    LD A,($A35F)                          ; $A3E2 3a 5f a3
    CP $FF                                ; $A3E5 fe ff
    JR Z,$A414                            ; $A3E7 28 2b
    BIT 2,C                               ; $A3E9 cb 51
    JR Z,$A414                            ; $A3EB 28 27
    BIT 5,C                               ; $A3ED cb 69
    CALL Z,$A880                          ; $A3EF cc 80 a8
    LD A,($A01E)                          ; $A3F2 3a 1e a0
    BIT 7,A                               ; $A3F5 cb 7f
    CALL Z,$A880                          ; $A3F7 cc 80 a8
    LD A,($A35F)                          ; $A3FA 3a 5f a3
    CP $FE                                ; $A3FD fe fe
    JR NZ,$A409                           ; $A3FF 20 08
    LD HL,($A031)                         ; $A401 2a 31 a0
    CALL $A419                            ; $A404 cd 19 a4
    JR $A414                              ; $A407 18 0b
    LD A,($A010)                          ; $A409 3a 10 a0
    CP $05                                ; $A40C fe 05
    LD A,($A35F)                          ; $A40E 3a 5f a3
    CALL $A745                            ; $A411 cd 45 a7
    LD A,$2E                              ; $A414 3e 2e
    JP $A9B7                              ; $A416 c3 b7 a9

    ORG $A7BA
; CODE: Nome locazione: ingresso distinto dal nome entità
    PUSH IY                               ; $A7BA fd e5 | Ingresso nome locazione: il delimitatore scaricaParliament prima del ritorno, mentreStreet rimane nel buffer. Conservare il contratto del dossier5D26.
    PUSH HL                               ; $A7BC e5
    POP IY                                ; $A7BD fd e1
    CALL $D405                            ; $A7BF cd 05 d4
    POP IY                                ; $A7C2 fd e1
    RET                                   ; $A7C4 c9

    ORG $682A
; DATA: Testo degli ordini NPC: prefisso, comando composto e chiusura
    DEFB $0B,$DA,$FF,$18,$22,$1E          ; $682A 0b da ff 18 22 1e

    ORG $A59F
; CODE: Ingresso pubblico del testo e stack degli argomenti
    PUSH BC                               ; $A59F c5
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
    CALL $A7C5                            ; $A755 cd c5 a7
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
    LD E,(IY+$02)                         ; $D416 fd 5e 02
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
    LD E,(IY+$00)                         ; $D438 fd 5e 00 | Il sostantivo finale rimane nel buffer fino al delimitatore nel chiamante; non imporre il frame profondo all’intero ordine.
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
    CALL $A990                            ; $A97C cd 90 a9
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
    CALL $C388                            ; $C374 cd 88 c3 | La CALL reale aC388 scriveC377. Con frame5D26, la cella5D27 conservaC3 del ritorno; caso distinto dalla riga del font.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $C388
; CODE: Glifo: righe e registri salvati; 5D27: riga grezza del font salvata dal prefisso locazione, frame5D32
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5
    LD L,A                                ; $C38C 6f | Usa il codice del carattere per cercare il glifo: char*8 + 3C00. È il font originale, distinto dal descrittore del testo e dalla bitmap già allineata.
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a | A riceve il byte della scansione corrente dal font. Nell’ultima iterazione è glyph[7], non il numero del carattere né il risultato ruotato.
    PUSH BC                               ; $C39C c5
    PUSH AF                               ; $C39D f5 | PUSH AF salva la riga grezza prima dello shift. Con frame5D32 A occupa5D27 e F occupa5D26. Anche shift0 lascia questo store: non dipende dalla seconda metà del byte video.
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
    POP AF                                ; $C3B1 f1 | Ripristina la riga grezza dalla pila, dopo aver modificato A per il primo byte video. Il valore salvato non è la porzione già allineata.
    POP BC                                ; $C3B2 c1
    DEC C                                 ; $C3B3 0d
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5
    PUSH AF                               ; $C3B8 f5 | Con shift nonzero risalva AF, con A ripristinato. Ultimo writer naturale: tick964, soggetto temporaneo0, t diParliament, frame5D32, colonna24,shift2. A=glyph(t)[7]=0. Non installare0: q lascia6, underscore255.
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
    INC DE                                ; $C3D0 13 | Avanza DE al byte del font seguente. Dopo otto scansioni il residuo diA resta quello dell’ottava, non il puntatore incrementato.
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
    CALL $A59F                            ; $CE13 cd 9f a5 | Ordine stampato dopo la registrazione della richiesta. Proprietà di27 soltanto negli stessi chiamanti verificati del nome locazione; forme sconosciute revocano26 e27.
    JR $CE8F                              ; $CE16 18 77
