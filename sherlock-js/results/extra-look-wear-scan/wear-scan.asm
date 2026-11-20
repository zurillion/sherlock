; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.

    ORG $A2E4
; CODE: Annuncio normale del giocatore: chiamante di WEAR
    LD A,$01                             ; $A2E4 3e 01 | WEAR del giocatore entra da CA76 con SP5D6C. Non confondere questo chiamante ordinario con la stampa pubblica A59F o le richieste NPC isolate.
    LD ($A2AA),A                         ; $A2E6 32 aa a2
    PUSH IY                              ; $A2E9 fd e5
    PUSH BC                              ; $A2EB c5
    PUSH IX                              ; $A2EC dd e5
    PUSH HL                              ; $A2EE e5
    PUSH DE                              ; $A2EF d5
    LD A,($A033)                         ; $A2F0 3a 33 a0
    LD ($A35D),A                         ; $A2F3 32 5d a3
    LD HL,($A034)                        ; $A2F6 2a 34 a0
    LD ($A35E),HL                        ; $A2F9 22 5e a3
    LD A,($A00C)                         ; $A2FC 3a 0c a0
    LD B,A                               ; $A2FF 47
    AND A                                ; $A300 a7
    LD A,$01                             ; $A301 3e 01
    JR Z,$A306                           ; $A303 28 01
    XOR A                                ; $A305 af
    LD ($A027),A                         ; $A306 32 27 a0
    CALL $D078                           ; $A309 cd 78 d0
    JR NC,$A31A                          ; $A30C 30 0c
    LD A,B                               ; $A30E 78
    AND A                                ; $A30F a7
    JR NZ,$A31A                          ; $A310 20 08
    LD HL,$68D1                          ; $A312 21 d1 68
    CALL $A59F                           ; $A315 cd 9f a5
    JR $A34E                             ; $A318 18 34
    LD A,($A35D)                         ; $A31A 3a 5d a3
    CALL $A2B1                           ; $A31D cd b1 a2
    PUSH HL                              ; $A320 e5
    POP IX                               ; $A321 dd e1
    CALL $A2BD                           ; $A323 cd bd a2
    LD A,($A01D)                         ; $A326 3a 1d a0
    AND $10                              ; $A329 e6 10
    JR NZ,$A34E                          ; $A32B 20 21
    CP B                                 ; $A32D b8
    JR Z,$A336                           ; $A32E 28 06
    CALL $DC6C                           ; $A330 cd 6c dc
    CALL Z,$A2A2                         ; $A333 cc a2 a2
    CALL $A724                           ; $A336 cd 24 a7
    LD DE,$017F                          ; $A339 11 7f 01
    XOR A                                ; $A33C af
    CP B                                 ; $A33D b8
    JR NZ,$A348                          ; $A33E 20 08
    CALL $A887                           ; $A340 cd 87 a8
    CALL $A360                           ; $A343 cd 60 a3
    JR $A34B                             ; $A346 18 03
    CALL $A37D                           ; $A348 cd 7d a3 | A37D prepara verbo e argomenti nel normale annuncio. Il CR precedente alla frase contribuisce al contatore cumulativo.
    CALL $A2A2                           ; $A34B cd a2 a2
    XOR A                                ; $A34E af
    LD ($A2AA),A                         ; $A34F 32 aa a2
    LD ($A027),A                         ; $A352 32 27 a0
    POP DE                               ; $A355 d1
    POP HL                               ; $A356 e1
    POP IX                               ; $A357 dd e1
    POP BC                               ; $A359 c1
    POP IY                               ; $A35A fd e1
    RET                                  ; $A35C c9

    ORG $A37D
; CODE: Verbo in attesa e nome del primo argomento
    XOR A                                ; $A37D af
    LD ($A028),A                         ; $A37E 32 28 a0
    LD A,($A35D)                         ; $A381 3a 5d a3
    CALL $A2B1                           ; $A384 cd b1 a2
    PUSH HL                              ; $A387 e5
    POP IX                               ; $A388 dd e1
    PUSH HL                              ; $A38A e5
    CALL $A2BD                           ; $A38B cd bd a2
    CALL $C493                           ; $A38E cd 93 c4
    CALL $C4B2                           ; $A391 cd b2 c4
    POP HL                               ; $A394 e1
    LD A,($A01D)                         ; $A395 3a 1d a0
    LD C,A                               ; $A398 4f
    PUSH HL                              ; $A399 e5
    LD DE,$0006                          ; $A39A 11 06 00
    ADD HL,DE                            ; $A39D 19
    CALL $A880                           ; $A39E cd 80 a8
    POP HL                               ; $A3A1 e1
    CALL $A880                           ; $A3A2 cd 80 a8 | Il descrittore089D lascia wear nel buffer. La parola viene scaricata quando inizia il nome dell’argomento, non direttamente da questa CALL.
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
    CALL $A745                           ; $A3DE cd 45 a7 | A745/A751/D3E8 iniziano il nome del travestimento. Lo scarico di wear entra in C388 con frame5D2A; articolo e qualificatori successivi hanno frame5D2C, il sostantivo finale5D46.
    POP HL                               ; $A3E1 e1

    ORG $B69D
; CODE: Rifiuto di oggetto assente: argomenti vuoti e frammento6894
    LD HL,$0000                          ; $B69D 21 00 00 | Il ramo senza corrispondenza prepara tre argomenti zero, distinti dal percorso che ha trovato una parola nella descrizione.
    PUSH HL                              ; $B6A0 e5
    PUSH HL                              ; $B6A1 e5
    PUSH HL                              ; $B6A2 e5
    LD HL,$05DB                          ; $B6A3 21 db 05
    PUSH HL                              ; $B6A6 e5
    LD HL,$6894                          ; $B6A7 21 94 68 | Il testo6894 costruisce I SEE NO ... THAT YOU CAN ... nel canale degli errori. Il contratto dei soli1E/1F non attribuisce tutti i residui della query.
    CALL $A59F                           ; $B6AA cd 9f a5
    RET                                  ; $B6AD c9

    ORG $B6FD
; CODE: Ricerca nella descrizione: ritorno anticipato se assente
    XOR A                                ; $B6FD af | Azzera il flag di esito prima di cercare nel testo della locazione. La prova dei rifiuti mantiene assente la descrizione e il giocatore alla radice.
    LD ($B77E),A                         ; $B6FE 32 7e b7
    LD ($B6D8),HL                        ; $B701 22 d8 b6
    CALL $D33C                           ; $B704 cd 3c d3 | D33C seleziona il record di descrizione da esaminare. Nei casi certificati il puntatore letto da IX+7/8 è zero.
    LD L,(IX+$07)                        ; $B707 dd 6e 07
    LD H,(IX+$08)                        ; $B70A dd 66 08
    LD A,H                               ; $B70D 7c
    OR L                                 ; $B70E b5
    RET Z                                ; $B70F c8 | Il puntatore zero ritorna prima del decoder della descrizione. Non estendere la conservazione a una ricerca nel testo di una stanza.

    ORG $C388
; CODE: Glifo del verbo WEAR: F e A salvati in1E/1F
    PUSH AF                              ; $C388 f5 | La r finale di wear, tick2286, ha SP5D2A, descrittore5C0B e colonna7. Lo shift è3.
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
    PUSH BC                              ; $C39C c5
    PUSH AF                              ; $C39D f5 | AF dell’ottava scansione precede il disegno. Con frame5D2A il byte F occupa1E e il byte A occupa1F; F e A hanno provenienze indipendenti.
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
    DEC C                                ; $C3B3 0d | Il percorso con shift non nullo ripristina il conteggio prima del secondo PUSH AF. Non si conserva il byte ruotato usato per disegnare.
    INC C                                ; $C3B4 0c
    JR Z,$C3D0                           ; $C3B5 28 19
    PUSH BC                              ; $C3B7 c5
    PUSH AF                              ; $C3B8 f5 | Ultimo writer di1E/1F nel percorso osservato: F=0 dalla scansione, A=0 dall’ottava riga del font r. La cuoca legge1E al2484 e1F al2608. Con q il font residuo può essere diverso da zero.
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
    DJNZ $C39B                           ; $C3D2 10 c7 | Otto scansioni per glifo: la proprietà deriva dall’ultima iterazione. L’ABI riutilizzata varia carattere, shift e conteggio del chiamante.
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
