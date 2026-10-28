; Analisi offline con riassellaggio del payload; nessuna CPU nel motore JS.

    ORG $A2E4
; CODE: Annuncio dell’azione: soggetto, verbo, argomenti e fine riga
    LD A,$01                              ; $A2E4 3e 01 | Annuncio normale selezionato da CA76. I cinque PUSH iniziali appartengono al calcolo della profondità: non usare il frame del testo pubblico A59F.
    LD ($A2AA),A                          ; $A2E6 32 aa a2
    PUSH IY                               ; $A2E9 fd e5
    PUSH BC                               ; $A2EB c5
    PUSH IX                               ; $A2EC dd e5
    PUSH HL                               ; $A2EE e5
    PUSH DE                               ; $A2EF d5
    LD A,($A033)                          ; $A2F0 3a 33 a0
    LD ($A35D),A                          ; $A2F3 32 5d a3
    LD HL,($A034)                         ; $A2F6 2a 34 a0
    LD ($A35E),HL                         ; $A2F9 22 5e a3
    LD A,($A00C)                          ; $A2FC 3a 0c a0
    LD B,A                                ; $A2FF 47
    AND A                                 ; $A300 a7
    LD A,$01                              ; $A301 3e 01
    JR Z,$A306                            ; $A303 28 01
    XOR A                                 ; $A305 af
    LD ($A027),A                          ; $A306 32 27 a0
    CALL $D078                            ; $A309 cd 78 d0
    JR NC,$A31A                           ; $A30C 30 0c
    LD A,B                                ; $A30E 78
    AND A                                 ; $A30F a7
    JR NZ,$A31A                           ; $A310 20 08
    LD HL,$68D1                           ; $A312 21 d1 68
    CALL $A59F                            ; $A315 cd 9f a5
    JR $A34E                              ; $A318 18 34
    LD A,($A35D)                          ; $A31A 3a 5d a3
    CALL $A2B1                            ; $A31D cd b1 a2
    PUSH HL                               ; $A320 e5
    POP IX                                ; $A321 dd e1
    CALL $A2BD                            ; $A323 cd bd a2
    LD A,($A01D)                          ; $A326 3a 1d a0
    AND $10                               ; $A329 e6 10
    JR NZ,$A34E                           ; $A32B 20 21
    CP B                                  ; $A32D b8
    JR Z,$A336                            ; $A32E 28 06
    CALL $DC6C                            ; $A330 cd 6c dc
    CALL Z,$A2A2                          ; $A333 cc a2 a2
    CALL $A724                            ; $A336 cd 24 a7 | Emette il soggetto prima del verbo; il suo nome può avere un frame diverso dal nome dell’argomento.
    LD DE,$017F                           ; $A339 11 7f 01
    XOR A                                 ; $A33C af
    CP B                                  ; $A33D b8
    JR NZ,$A348                           ; $A33E 20 08
    CALL $A887                            ; $A340 cd 87 a8
    CALL $A360                            ; $A343 cd 60 a3
    JR $A34B                              ; $A346 18 03
    CALL $A37D                            ; $A348 cd 7d a3 | A37D emette verbo e argomenti. Nei due percorsi verificati CLIMB INTO e TAKE OFF il prefisso qualificato del primo argomento arriva al glifo con frame 5D2C.
    CALL $A2A2                            ; $A34B cd a2 a2
    XOR A                                 ; $A34E af
    LD ($A2AA),A                          ; $A34F 32 aa a2
    LD ($A027),A                          ; $A352 32 27 a0
    POP DE                                ; $A355 d1
    POP HL                                ; $A356 e1
    POP IX                                ; $A357 dd e1
    POP BC                                ; $A359 c1
    POP IY                                ; $A35A fd e1
    RET                                   ; $A35C c9

    ORG $A37D
; CODE: Primo argomento: risoluzione del nome di entità nel messaggio
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
    LD A,($A35E)                          ; $A3B6 3a 5e a3 | Primo argomento: FE segue il percorso del letterale numerico. Il nuovo contratto non si applica a quel caso.
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
    CALL $A745                            ; $A3DE cd 45 a7 | L’entità viene nominata attraverso A745/A751 e D3E8. Qualificatori e sostantivo finale si scaricano con chiamanti diversi.
    POP HL                                ; $A3E1 e1

    ORG $C316
; CODE: Scroll e pulizia della nuova riga: glifi spazio e frame chiamante
    LD A,($C128)                          ; $C316 3a 28 c1 | Lo scroll sposta la bitmap e poi pulisce la riga inferiore. Una richiesta MORE può sospenderlo prima di questa routine.
    AND A                                 ; $C319 a7
    CALL Z,$C3E4                          ; $C31A cc e4 c3
    PUSH BC                               ; $C31D c5
    PUSH HL                               ; $C31E e5
    PUSH DE                               ; $C31F d5
    LD HL,$4020                           ; $C320 21 20 40
    LD DE,$4000                           ; $C323 11 00 40
    LD BC,$0011                           ; $C326 01 11 00
    LD A,($C128)                          ; $C329 3a 28 c1
    AND A                                 ; $C32C a7
    LD A,$20                              ; $C32D 3e 20
    JR Z,$C333                            ; $C32F 28 02
    LD A,$10                              ; $C331 3e 10
    PUSH HL                               ; $C333 e5
    PUSH DE                               ; $C334 d5
    PUSH BC                               ; $C335 c5
    LD C,$08                              ; $C336 0e 08
    PUSH HL                               ; $C338 e5
    PUSH DE                               ; $C339 d5
    PUSH BC                               ; $C33A c5
    LD C,A                                ; $C33B 4f
    LDIR                                  ; $C33C ed b0
    POP BC                                ; $C33E c1
    POP DE                                ; $C33F d1
    POP HL                                ; $C340 e1
    INC H                                 ; $C341 24
    INC D                                 ; $C342 14
    DEC C                                 ; $C343 0d
    JR NZ,$C338                           ; $C344 20 f2
    POP BC                                ; $C346 c1
    POP DE                                ; $C347 d1
    POP HL                                ; $C348 e1
    PUSH AF                               ; $C349 f5
    CALL $C37D                            ; $C34A cd 7d c3
    CALL $C37D                            ; $C34D cd 7d c3
    POP AF                                ; $C350 f1
    DEC C                                 ; $C351 0d
    JR NZ,$C333                           ; $C352 20 df
    CP $10                                ; $C354 fe 10
    JR Z,$C363                            ; $C356 28 0b
    LD HL,$5820                           ; $C358 21 20 58
    LD DE,$5800                           ; $C35B 11 00 58
    LD BC,$0220                           ; $C35E 01 20 02
    LDIR                                  ; $C361 ed b0
    LD A,($C128)                          ; $C363 3a 28 c1
    AND A                                 ; $C366 a7
    LD B,$24                              ; $C367 06 24
    JR Z,$C36D                            ; $C369 28 02
    LD B,$12                              ; $C36B 06 12
    LD HL,$5020                           ; $C36D 21 20 50
    LD C,$02                              ; $C370 0e 02
    LD A,$20                              ; $C372 3e 20 | Spazio del riempimento: non una parola del gioco. Il renderer usa il font dello spazio in ogni colonna.
    CALL $C388                            ; $C374 cd 88 c3 | Il word wrap del prefisso con frame5D2C arriva qui con il glifo a frame5D26: il byte F dell’ultimo PUSH AF resta a 5D1A.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9
    EX DE,HL                              ; $C37D eb
    LD A,L                                ; $C37E 7d
    ADD A,$20                             ; $C37F c6 20
    LD L,A                                ; $C381 6f
    RET NC                                ; $C382 d0
    LD A,H                                ; $C383 7c
    ADD A,$08                             ; $C384 c6 08
    LD H,A                                ; $C386 67
    RET                                   ; $C387 c9

    ORG $C388
; CODE: Glifo: provenienza dei flag salvati a frame meno dodici
    PUSH AF                               ; $C388 f5
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
    PUSH BC                               ; $C39C c5 | Ultima scansione: B=1 e C=(2+7*colonna) AND7. Nel prefisso degli ordini con frame5D2A questo salva C a 5D20 e B a 5D21.
    PUSH AF                               ; $C39D f5 | Primo salvataggio AF della scansione. Con C=0 il secondo salvataggio viene saltato; il flag dell’ultima scansione deriva da INC H, che porta 56 a57 e non lascia flag attivi dopo la precedente OR.
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
    DEC C                                 ; $C3B3 0d | DEC C / INC C ricostruisce il conteggio dello shift: per C tra1 e7 il flag risultante è zero; il caso zero salta il secondo PUSH.
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5
    PUSH AF                               ; $C3B8 f5 | Secondo salvataggio AF: A è la riga del font non allineata, F deriva dal conteggio C. Con frame5D26 F occupa5D1A. La formula non dipende dal carattere stampato.
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
    DJNZ $C39B                            ; $C3D2 10 c7 | Otto scansioni: il residuo finale è quello dell’ottava, non della prima.
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

    ORG $D237
; CODE: Lookup entità: EX (SP),HL può riscrivere la stessa area temporanea
    LD IX,$8B6F                           ; $D237 dd 21 6f 8b
    CALL $D34E                            ; $D23B cd 4e d3
    PUSH HL                               ; $D23E e5
    LD L,(IX+$01)                         ; $D23F dd 6e 01
    LD H,(IX+$02)                         ; $D242 dd 66 02
    EX (SP),HL                            ; $D245 e3 | EX (SP),HL è uno scrittore alternativo anche quando il valore non cambia. Il probe lo registra insieme ai PUSH/CALL; non dedurre proprietà dal solo ultimo cambiamento.
    POP IX                                ; $D246 dd e1
    RET                                   ; $D248 c9
