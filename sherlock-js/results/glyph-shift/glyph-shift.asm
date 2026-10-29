; Analisi offline con riassellaggio del payload; nessuna CPU nel motore JS.

    ORG $A3D6
; CODE: Nome del primo argomento: chiamante verificato del salvataggio C
    LD A,($A00F)                          ; $A3D6 3a 0f a0
    CP $05                                ; $A3D9 fe 05
    LD A,($A35E)                          ; $A3DB 3a 5e a3
    CALL $A745                            ; $A3DE cd 45 a7 | Nel chiamante verificato CLIMB INTO/TAKE OFF, il prefisso qualificato passa da A745/A751 a D3E8; durante il suo scarico C388 ha frame5D2C. Non estendere questo contratto a tutti i nomi o a richieste isolate.
    POP HL                                ; $A3E1 e1

    ORG $A9DF
; CODE: Scarico della parola: ritorno a capo prima dei glifi
    PUSH DE                               ; $A9DF d5 | Il buffer contiene una parola intera. Salvataggi e chiamate contribuiscono alla profondità dello stack, oltre alla sola stampa del glifo.
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd | Se la parola non entra, il CR precede lo scarico. Nel prefisso con frame5D2C la pulizia arriva a C388 con frame5D26.
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa | AA14 con CR provoca scroll e pulizia prima di riprendere i caratteri della parola. Il byte 5D1B deriva quindi da uno spazio, non da una lettera di hansom.
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45 | B riceve la lunghezza della parola; con un altro frame lo stesso byte fisico può conservare un conteggio, non una scansione del font.
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0
    POP DE                                ; $AA0B d1
    POP HL                                ; $AA0C e1
    POP AF                                ; $AA0D f1
    JR $AA14                              ; $AA0E 18 04

    ORG $C363
; CODE: Pulizia della riga: spazio e chiamata al renderer
    LD A,($C128)                          ; $C363 3a 28 c1 | Prepara il riempimento della riga inferiore dopo lo scroll. Il numero di colonne dipende dal canale.
    AND A                                 ; $C366 a7
    LD B,$24                              ; $C367 06 24
    JR Z,$C36D                            ; $C369 28 02
    LD B,$12                              ; $C36B 06 12
    LD HL,$5020                           ; $C36D 21 20 50
    LD C,$02                              ; $C370 0e 02
    LD A,$20                              ; $C372 3e 20 | Lo spazio viene ottenuto dal font vero, non da un valore registrato. La sua ottava riga è zero, ma altri glifi, per esempio q, hanno righe nonzero.
    CALL $C388                            ; $C374 cd 88 c3 | Con frame C388=5D26 i salvataggi AF interni scrivono F a5D1A e A a5D1B. Nel percorso naturale il writer pertinente è C3B8 a tick962, Lestrade che sale sul cab.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $C388
; CODE: Glifo: C dello shift salvato separatamente da F e A
    PUSH AF                               ; $C388 f5 | Salva AF del chiamante. Il frame è parte del contratto: la stessa cella può conservare informazioni diverse con altre profondità.
    PUSH BC                               ; $C389 c5
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5
    LD L,A                                ; $C38C 6f
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
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5 | PUSH BC conserva B=1 e C=shift dell’ottava scansione. Con frame glifo5D26, il byte basso C occupa5D1C. Con shift0 questo resta l’ultimo salvataggio BC; con shift nonzero viene ripetuto aC3B7.
    PUSH AF                               ; $C39D f5 | Primo PUSH AF della scansione; A è il byte del font non allineato. Con shift zero non serve il secondo PUSH, e questo rimane il writer.
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
    DEC C                                 ; $C3B3 0d | Il ciclo di shift modifica A soltanto per disegnare; POP AF ripristina il byte non allineato prima del salvataggio successivo.
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5 | PUSH BC ripete il salvataggio dopo il primo disegno solo se shift nonzero. Il byte basso rimane C originale, non 8-C: la sottrazione avviene dopo. La formula dal cursore è (2+7*colonna)&7; con colonna35 vale7.
    PUSH AF                               ; $C3B8 f5 | PUSH AF salva di nuovo la riga del font non allineata. All’ottavo passaggio, con frame5D26, A=glyph[7] occupa5D1B. Non confondere A con F a5D1A né sostituire entrambi con zero.
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
    DJNZ $C39B                            ; $C3D2 10 c7 | Il ciclo esegue otto scansioni: il residuo è l’ultima riga del glifo. Le prove coprono ogni colonna, inclusi gli shift zero.
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
    POP AF                                ; $C3E2 f1 | Ripristina AF del chiamante al ritorno; il contenuto residuo dello stack rimane finché un altro writer non lo sovrascrive.
    RET                                   ; $C3E3 c9
