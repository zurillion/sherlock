; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.

    ORG $A3A2
; CODE: Verbo in attesa e nome del primo argomento
    CALL $A880                           ; $A3A2 cd 80 a8 | Il verbo viene prima accumulato. Nell’annuncio WEAR il successivo nome dell’argomento ne provoca lo scarico nel frame5D2A.
    BIT 3,C                              ; $A3A5 cb 59
    JR Z,$A3E2                           ; $A3A7 28 39
    BIT 5,C                              ; $A3A9 cb 69
    CALL NZ,$A880                        ; $A3AB c4 80 a8
    LD A,($A01E)                         ; $A3AE 3a 1e a0
    BIT 7,A                              ; $A3B1 cb 7f
    CALL NZ,$A880                        ; $A3B3 c4 80 a8
    LD A,($A35E)                         ; $A3B6 3a 5e a3
    CP $FE                               ; $A3B9 fe fe
    JR NZ,$A3C7                          ; $A3BB 20 0a
    PUSH HL                              ; $A3BD e5
    LD HL,($A02F)                        ; $A3BE 2a 2f a0
    CALL $A419                           ; $A3C1 cd 19 a4
    POP HL                               ; $A3C4 e1
    JR $A3E2                             ; $A3C5 18 1b
    PUSH HL                              ; $A3C7 e5
    LD HL,$A036                          ; $A3C8 21 36 a0
    CP (HL)                              ; $A3CB be
    JR NZ,$A3D6                          ; $A3CC 20 08
    LD DE,$055B                          ; $A3CE 11 5b 05
    CALL $A887                           ; $A3D1 cd 87 a8
    JR $A3E1                             ; $A3D4 18 0b
    LD A,($A00F)                         ; $A3D6 3a 0f a0
    CP $05                               ; $A3D9 fe 05
    LD A,($A35E)                         ; $A3DB 3a 5e a3
    CALL $A745                           ; $A3DE cd 45 a7 | Il nome del primo argomento usa il formatter A745/A751/D3E8. Per WEAR i qualificatori si scaricano a frame5D2C, distinto dal verbo e dal sostantivo finale.
    POP HL                               ; $A3E1 e1

    ORG $A9DF
; CODE: Scarico della parola nel contesto del separatore
    PUSH DE                              ; $A9DF d5 | Il carattere che delimita una parola seleziona la profondità dello scarico. Lo spazio dopo daily, nell’ultimo oggetto portato del LOOK, entra in C388 con SP5D26.
    LD DE,$5C0B                          ; $A9E0 11 0b 5c
    AND A                                ; $A9E3 a7
    SBC HL,DE                            ; $A9E4 ed 52
    JR Z,$AA0B                           ; $A9E6 28 23
    LD A,($C1F5)                         ; $A9E8 3a f5 c1
    CP L                                 ; $A9EB bd
    PUSH AF                              ; $A9EC f5
    JR NC,$A9F4                          ; $A9ED 30 05
    LD A,$0D                             ; $A9EF 3e 0d
    CALL $AA14                           ; $A9F1 cd 14 aa
    PUSH BC                              ; $A9F4 c5
    LD B,L                               ; $A9F5 45
    LD HL,$5C0B                          ; $A9F6 21 0b 5c
    LD ($A9B5),HL                        ; $A9F9 22 b5 a9
    LD A,(HL)                            ; $A9FC 7e | B del chiamante conta i caratteri residui della parola: non è B interno, che C388 reinizializza per le otto scansioni.
    CALL $AA14                           ; $A9FD cd 14 aa
    INC HL                               ; $AA00 23
    DJNZ $A9FC                           ; $AA01 10 f9
    POP BC                               ; $AA03 c1
    POP AF                               ; $AA04 f1
    JR NZ,$AA0B                          ; $AA05 20 04
    XOR A                                ; $AA07 af
    LD ($A025),A                         ; $AA08 32 25 a0
    POP DE                               ; $AA0B d1
    POP HL                               ; $AA0C e1
    POP AF                               ; $AA0D f1
    JR $AA14                             ; $AA0E 18 04

    ORG $B6FD
; CODE: Ritorno senza ricerca se manca la descrizione
    XOR A                                ; $B6FD af | La conservazione1A–25 dei rifiuti è verificata per un solo gruppo assente,0..2qualificatori,contesto ordinario del giocatore e stanza senza testo. Non estenderla a richieste o ricerche nella prosa.
    LD ($B77E),A                         ; $B6FE 32 7e b7
    LD ($B6D8),HL                        ; $B701 22 d8 b6
    CALL $D33C                           ; $B704 cd 3c d3
    LD L,(IX+$07)                        ; $B707 dd 6e 07
    LD H,(IX+$08)                        ; $B70A dd 66 08
    LD A,H                               ; $B70D 7c
    OR L                                 ; $B70E b5
    RET Z                                ; $B70F c8 | Con puntatore di descrizione zero ritorna prima del decoder. I168comandi controllati non scrivono20 e conservano tutti i marker1A–25,non solo1E/1F.

    ORG $C388
; CODE: AF dello spazio LOOK e del qualificatore WEAR
    PUSH AF                              ; $C388 f5 | Due produttori distinti nello stesso metodo: spazio del LOOK a frame5D26 e qualificatore di WEAR a frame5D2C. Non dedurre uno dei byte dall’altro.
    PUSH BC                              ; $C389 c5
    PUSH DE                              ; $C38A d5
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
    PUSH BC                              ; $C39C c5 | Il BC di scansione conserva shift e conteggio; non contiene AF. È già proiettato separatamente per il separatore daily/chronicle.
    PUSH AF                              ; $C39D f5 | Ultimo PUSH AF se shift zero. Spazio dopo daily,colonna18,shift0,tick1770: F in5D1A,A in5D1B. Il giardiniere legge1A al2730.
    DEC C                                ; $C39E 0d
    INC C                                ; $C39F 0c
    LD B,$FF                             ; $C3A0 06 ff
    JR Z,$C3AB                           ; $C3A2 28 07
    SRL A                                ; $C3A4 cb 3f
    SRL B                                ; $C3A6 cb 38
    DEC C                                ; $C3A8 0d
    JR NZ,$C3A4                          ; $C3A9 20 f9
    LD C,A                               ; $C3AB 4f
    LD A,B                               ; $C3AC 78
    CPL                                  ; $C3AD 2f
    AND (HL)                             ; $C3AE a6
    OR C                                 ; $C3AF b1
    LD (HL),A                            ; $C3B0 77
    POP AF                               ; $C3B1 f1
    POP BC                               ; $C3B2 c1
    DEC C                                ; $C3B3 0d
    INC C                                ; $C3B4 0c
    JR Z,$C3D0                           ; $C3B5 28 19
    PUSH BC                              ; $C3B7 c5
    PUSH AF                              ; $C3B8 f5 | Con shift non nullo ripete AF prima della rotazione per disegnare. Ultima s di mans in WEAR,colonna22,shift4,frame5D2C,tick2286: F in20,A in21. Il giardiniere legge20 nello stesso draw di1A al2730.
    LD A,$08                             ; $C3B9 3e 08
    SUB C                                ; $C3BB 91
    LD C,A                               ; $C3BC 4f
    POP AF                               ; $C3BD f1
    LD B,$FF                             ; $C3BE 06 ff
    SLA A                                ; $C3C0 cb 27
    SLA B                                ; $C3C2 cb 20
    DEC C                                ; $C3C4 0d
    JR NZ,$C3C0                          ; $C3C5 20 f9
    LD C,A                               ; $C3C7 4f
    LD A,B                               ; $C3C8 78
    CPL                                  ; $C3C9 2f
    INC HL                               ; $C3CA 23
    AND (HL)                             ; $C3CB a6
    OR C                                 ; $C3CC b1
    LD (HL),A                            ; $C3CD 77
    DEC HL                               ; $C3CE 2b
    POP BC                               ; $C3CF c1
    INC DE                               ; $C3D0 13
    INC H                                ; $C3D1 24
    DJNZ $C39B                           ; $C3D2 10 c7 | Il residuo appartiene all’ottava scansione. A viene dalla riga del font; F dal percorso dello shift. Nessun valore catturato del corpus entra nel renderer JS.
    POP HL                               ; $C3D4 e1
    POP DE                               ; $C3D5 d1
    POP BC                               ; $C3D6 c1
    LD A,C                               ; $C3D7 79
    ADD A,$07                            ; $C3D8 c6 07
    CP $08                               ; $C3DA fe 08
    JR C,$C3E1                           ; $C3DC 38 03
    SUB $08                              ; $C3DE d6 08
    INC L                                ; $C3E0 2c
    LD C,A                               ; $C3E1 4f
    POP AF                               ; $C3E2 f1
    RET                                  ; $C3E3 c9

    ORG $D3D5
; CODE: Nome di entità: articolo, qualificatori e sostantivo
    PUSH IX                              ; $D3D5 dd e5
    POP IY                               ; $D3D7 fd e1
    PUSH IY                              ; $D3D9 fd e5
    PUSH DE                              ; $D3DB d5
    LD DE,$0007                          ; $D3DC 11 07 00
    ADD IY,DE                            ; $D3DF fd 19
    CALL $D3E8                           ; $D3E1 cd e8 d3
    POP DE                               ; $D3E4 d1
    POP IY                               ; $D3E5 fd e1
    RET                                  ; $D3E7 c9
    PUSH AF                              ; $D3E8 f5 | Il nome ha un proprio contesto di stack. I qualificatori usano context4, il sostantivo context5. La parte numerica del denaro segue un altro percorso e non riceve il nuovo contratto AF del separatore.
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
    CALL Z,$A815                         ; $D424 cc 15 a8 | Primo qualificatore: il nome WEAR ordinario e l’ultimo nome portato nel LOOK hanno frame diversi. Il matching del nome grezzo impedisce di attribuire il contratto a nomi non ricostruiti.
    LD E,(IY+$04)                        ; $D427 fd 5e 04
    LD D,(IY+$05)                        ; $D42A fd 56 05
    RES 7,D                              ; $D42D cb ba
    BIT 7,(IY+$05)                       ; $D42F fd cb 05 7e
    LD A,$40                             ; $D433 3e 40
    CALL Z,$A815                         ; $D435 cc 15 a8 | Secondo qualificatore. La s finale di mans diventa l’ultimo glifo che raggiunge20/21 nella storia osservata.
    LD E,(IY+$00)                        ; $D438 fd 5e 00
    LD D,(IY+$01)                        ; $D43B fd 56 01
    LD A,D                               ; $D43E 7a
    OR E                                 ; $D43F b3
    LD A,$50                             ; $D440 3e 50
    CALL NZ,$A815                        ; $D442 c4 15 a8 | Il sostantivo finale torna a un frame meno profondo. Nel WEAR verificato disguise si scarica a5D46 e non raggiunge20/21.
    POP DE                               ; $D445 d1
    POP AF                               ; $D446 f1
    RET                                  ; $D447 c9
