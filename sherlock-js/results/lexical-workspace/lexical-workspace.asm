; Analisi offline del payload: nessun opcode eseguito dal motore JavaScript.

    ORG $A94D
; CODE: Decompressione del candidato: workspace separato a 5C42
    PUSH IX                               ; $A94D dd e5
    PUSH HL                               ; $A94F e5
    CALL $A95B                            ; $A950 cd 5b a9
    EX (SP),HL                            ; $A953 e3
    CALL $A92F                            ; $A954 cd 2f a9
    POP HL                                ; $A957 e1
    POP IX                                ; $A958 dd e1
    RET                                   ; $A95A c9
    PUSH BC                               ; $A95B c5
    LD IX,$5C42                           ; $A95C dd 21 42 5c | La decompressione dei candidati parte da 5C42, 55 byte dopo 5C0B: non sovrascrive la coda degli stream 5C1E–5C35. Oltre questa soglia le due copie possono sovrapporsi.
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
    INC IX                                ; $A96E dd 23 | Il prefisso compresso conserva i byte precedenti del candidato: non è una cancellazione dell’intero buffer.
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
    LD (IX+$00),$00                       ; $A986 dd 36 00 00 | Termina il candidato con zero. I byte successivi conservano il precedente contenuto.
    LD A,C                                ; $A98A 79
    POP BC                                ; $A98B c1
    AND A                                 ; $A98C a7
    RET Z                                 ; $A98D c8
    INC HL                                ; $A98E 23
    RET                                   ; $A98F c9
    PUSH DE                               ; $A990 d5
    LD D,(HL)                             ; $A991 56
    INC HL                                ; $A992 23
    LD E,(HL)                             ; $A993 5e
    DEC HL                                ; $A994 2b
    LD A,C                                ; $A995 79
    AND A                                 ; $A996 a7
    JR Z,$A9A0                            ; $A997 28 07
    SLA E                                 ; $A999 cb 23
    RL D                                  ; $A99B cb 12
    DEC A                                 ; $A99D 3d
    JR NZ,$A999                           ; $A99E 20 f9
    LD A,C                                ; $A9A0 79
    ADD A,$05                             ; $A9A1 c6 05
    CP $08                                ; $A9A3 fe 08
    JR C,$A9AA                            ; $A9A5 38 03
    SUB $08                               ; $A9A7 d6 08
    INC HL                                ; $A9A9 23
    LD C,A                                ; $A9AA 4f
    LD A,D                                ; $A9AB 7a
    POP DE                                ; $A9AC d1
    RRCA                                  ; $A9AD 0f
    RRCA                                  ; $A9AE 0f
    RRCA                                  ; $A9AF 0f
    AND $1F                               ; $A9B0 e6 1f
    ADD A,$60                             ; $A9B2 c6 60
    RET                                   ; $A9B4 c9

    ORG $D9C5
; CODE: Lookup alfabetico: copie lessicali prima del parsing, anche in preflight
    PUSH DE                               ; $D9C5 d5
    LD A,(HL)                             ; $D9C6 7e
    INC HL                                ; $D9C7 23
    CP $20                                ; $D9C8 fe 20
    JR Z,$D9C6                            ; $D9CA 28 fa
    DEC HL                                ; $D9CC 2b
    LD ($A029),HL                         ; $D9CD 22 29 a0
    CP $0D                                ; $D9D0 fe 0d
    JR Z,$DA06                            ; $D9D2 28 32
    CALL $DAC6                            ; $D9D4 cd c6 da
    JR Z,$DA2F                            ; $D9D7 28 56
    CALL $DA34                            ; $D9D9 cd 34 da | Il preflight e la tokenizzazione eseguono entrambi DA34. Un errore può conservare la copia della parola fallita senza giungere al parser.
    JR Z,$DA0A                            ; $D9DC 28 2c
    PUSH IX                               ; $D9DE dd e5
    XOR A                                 ; $D9E0 af
    LD ($DC14),A                          ; $D9E1 32 14 dc
    LD ($D9C3),DE                         ; $D9E4 ed 53 c3 d9
    LD DE,($DA32)                         ; $D9E8 ed 5b 32 da
    AND A                                 ; $D9EC a7
    PUSH HL                               ; $D9ED e5
    SBC HL,DE                             ; $D9EE ed 52
    POP HL                                ; $D9F0 e1
    JR Z,$DA12                            ; $D9F1 28 1f
    PUSH HL                               ; $D9F3 e5
    POP DE                                ; $D9F4 d1
    CALL $A94D                            ; $D9F5 cd 4d a9 | Ogni candidato, compresi i record D0 scartati subito dopo, viene decompresso nel workspace alto.
    LD A,(DE)                             ; $D9F8 1a
    AND $F0                               ; $D9F9 e6 f0
    CP $D0                                ; $D9FB fe d0
    JR Z,$D9E8                            ; $D9FD 28 e9
    CALL $DA7D                            ; $D9FF cd 7d da
    JR Z,$DA12                            ; $DA02 28 0e
    JR $D9E4                              ; $DA04 18 de
    LD A,$C0                              ; $DA06 3e c0
    JR $DA0C                              ; $DA08 18 02
    LD A,$D0                              ; $DA0A 3e d0
    LD BC,$0000                           ; $DA0C 01 00 00
    POP DE                                ; $DA0F d1
    LD D,A                                ; $DA10 57
    RET                                   ; $DA11 c9
    POP HL                                ; $DA12 e1
    LD A,($DC14)                          ; $DA13 3a 14 dc
    CP $04                                ; $DA16 fe 04
    JR NC,$DA21                           ; $DA18 30 07
    LD B,A                                ; $DA1A 47
    LD A,($DC13)                          ; $DA1B 3a 13 dc
    CP B                                  ; $DA1E b8
    JR NZ,$DA0A                           ; $DA1F 20 e9
    PUSH HL                               ; $DA21 e5
    LD HL,($D9C3)                         ; $DA22 2a c3 d9
    LD A,(HL)                             ; $DA25 7e
    AND $F0                               ; $DA26 e6 f0
    LD BC,$5DBF                           ; $DA28 01 bf 5d
    SBC HL,BC                             ; $DA2B ed 42
    EX (SP),HL                            ; $DA2D e3
    POP BC                                ; $DA2E c1
    POP DE                                ; $DA2F d1
    LD D,A                                ; $DA30 57
    RET                                   ; $DA31 c9

    ORG $DA34
; CODE: Copia del corpo della parola in minuscolo nel buffer di stampa 5C0B
    LD A,(HL)                             ; $DA34 7e | Consuma la prima lettera per selezionare il gruppo; questa lettera NON viene copiata a 5C0B.
    INC HL                                ; $DA35 23
    AND $1F                               ; $DA36 e6 1f
    RLCA                                  ; $DA38 07
    LD E,A                                ; $DA39 5f
    LD D,$00                              ; $DA3A 16 00
    PUSH HL                               ; $DA3C e5
    POP IX                                ; $DA3D dd e1
    LD HL,$5D80                           ; $DA3F 21 80 5d
    ADD HL,DE                             ; $DA42 19
    LD E,(HL)                             ; $DA43 5e
    INC HL                                ; $DA44 23
    LD D,(HL)                             ; $DA45 56
    INC HL                                ; $DA46 23
    PUSH DE                               ; $DA47 d5
    LD E,(HL)                             ; $DA48 5e
    INC HL                                ; $DA49 23
    LD D,(HL)                             ; $DA4A 56
    INC HL                                ; $DA4B 23
    LD A,D                                ; $DA4C 7a
    OR E                                  ; $DA4D b3
    JR Z,$DA48                            ; $DA4E 28 f8
    LD HL,$5DBF                           ; $DA50 21 bf 5d
    ADD HL,DE                             ; $DA53 19
    LD ($DA32),HL                         ; $DA54 22 32 da
    POP DE                                ; $DA57 d1
    LD A,D                                ; $DA58 7a
    OR E                                  ; $DA59 b3
    RET Z                                 ; $DA5A c8 | Un gruppo nullo ritorna prima di copiare il corpo. Non inventare scritture per gruppi assenti.
    LD HL,$5DBF                           ; $DA5B 21 bf 5d
    ADD HL,DE                             ; $DA5E 19
    LD DE,$5C0B                           ; $DA5F 11 0b 5c | Buffer condiviso con A9B7; questa copia diretta non modifica il puntatore di stampa A9B5.
    LD B,$01                              ; $DA62 06 01 | Lunghezza iniziale uno: include la prima lettera consumata.
    LD A,(IX+$00)                         ; $DA64 dd 7e 00
    CP $40                                ; $DA67 fe 40 | La copia si ferma al primo byte inferiore a 40, non soltanto a uno spazio.
    JR C,$DA74                            ; $DA69 38 09
    OR $20                                ; $DA6B f6 20 | OR 20 produce i byte minuscoli; non è una normalizzazione del testo visualizzato.
    LD (DE),A                             ; $DA6D 12 | Scrive il corpo consecutivamente da 5C0B. Parole lunghe possono sovrascrivere le vecchie celle degli stream ROM.
    INC DE                                ; $DA6E 13
    INC IX                                ; $DA6F dd 23
    INC B                                 ; $DA71 04
    JR $DA64                              ; $DA72 18 f0
    XOR A                                 ; $DA74 af
    LD (DE),A                             ; $DA75 12 | Il terminatore è scritto, non cancella il resto del buffer; parole successive corte lasciano la vecchia coda.
    LD A,B                                ; $DA76 78
    LD ($DC13),A                          ; $DA77 32 13 dc | La lunghezza comprende la prima lettera e corrisponde al numero di byte scritti (corpo più zero).
    OR $01                                ; $DA7A f6 01
    RET                                   ; $DA7C c9
