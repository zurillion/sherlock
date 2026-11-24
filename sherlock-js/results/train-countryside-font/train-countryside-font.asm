; Analisi offline Sherlock1984. Dati e codice distinti;nessuna CPU nel motore JS.

    ORG $A9DF
; CODE: Scarico della parola e CR esterno
    PUSH DE                              ; $A9DF d5 | English resta in buffer fino al riferimento successivo. La parola esce nel frame del decoder7E45,non nel chiamante finale del CR.
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
    LD B,L                               ; $A9F5 45 | BC del chiamante contiene caratteri residui e shift;non e A dell ultima riga del font.
    LD HL,$5C0B                          ; $A9F6 21 0b 5c
    LD ($A9B5),HL                        ; $A9F9 22 b5 a9
    LD A,(HL)                            ; $A9FC 7e
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

    ORG $C388
; CODE: Font A e descrittore D salvati indipendentemente
    PUSH AF                              ; $C388 f5 | English nel testo della campagna: frame5D2E. Nuova proprietà A23 della scansione e D29 del descrittore,indipendenti dai BC/video già ricostruiti.
    PUSH BC                              ; $C389 c5
    PUSH DE                              ; $C38A d5 | PUSH DE nel frame5D2E salva D in5D29. Nel writer naturale3504,DE=5C0B; il valore deriva dal parametro,non da92costante.
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
    PUSH AF                              ; $C39D f5 | Il ramo allineato conserva A prima della rotazione. Vale la stessa formula di scansione del ramo con shift.
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
    PUSH AF                              ; $C3B8 f5 | Ultima h di english,tick3504,giocatore0,frame5D2E:salva A grezzo dell ottava riga del font in23. Il valore0 osservato non e un fallback.
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
    DJNZ $C39B                           ; $C3D2 10 c7 | Il decremento segue la scansione corrente. A proviene dal font prima delle rotazioni sullo schermo.
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

    ORG $D16B
; CODE: Descrizione della stanza mobile e decoder
    LD L,(IX+$07)                        ; $D16B dd 6e 07
    LD H,(IX+$08)                        ; $D16E dd 66 08
    CALL $D182                           ; $D171 cd 82 d1 | D182 riceve il frammento descrittivo dalla stanza. Per il treno in corsa e7E45.
    LD A,B                               ; $D174 78
    CALL $D60B                           ; $D175 cd 0b d6
    LD A,B                               ; $D178 78
    CALL $D68C                           ; $D179 cd 8c d6
    CALL $D4A7                           ; $D17C cd a7 d4
    JP $A2A2                             ; $D17F c3 a2 a2
    LD A,H                               ; $D182 7c
    OR L                                 ; $D183 b5
    JP NZ,$A59F                          ; $D184 c2 9f a5 | Con puntatore nonzero entra in A59F. Nel percorso naturale A59F/SP5D5A scarica English a C388/SP5D2E;CRsuccessivo A9B7/SP5D58.

    ORG $CB28
; DATA: IX e IY temporanei delle regole
    DEFB $00,$00,$00,$00                 ; $CB28 00 00 00 00 | Dati mutabili: IX/IY del predicato e corpo. Gli zeri sono solo il payload iniziale,non il valore durante la partita.

    ORG $CB2C
; CODE: Chiamata del predicato/corpo e salvataggio degli indici
    LD IX,($CB28)                        ; $CB2C dd 2a 28 cb
    LD IY,($CB2A)                        ; $CB30 fd 2a 2a cb
    CALL $CB40                           ; $CB34 cd 40 cb
    LD ($CB28),IX                        ; $CB37 dd 22 28 cb | Prossimo limiteCB29:salva IX. Al3581,l attore104 ritorna dal callbackE5AA con IX9997 eIYDDBE;il giardiniere legge il byte99. Contratto specifico del callback ancora non ricostruito.
    LD ($CB2A),IY                        ; $CB3B fd 22 2a cb
    RET                                  ; $CB3F c9
    JP (HL)                              ; $CB40 e9
