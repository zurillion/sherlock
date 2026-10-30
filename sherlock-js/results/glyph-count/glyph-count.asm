; Analisi offline con riassellaggio del payload; nessuna CPU nel motore JS.

    ORG $A3D6
; CODE: Nome del primo argomento: chiamante verificato del salvataggio B
    LD A,($A00F)                          ; $A3D6 3a 0f a0
    CP $05                                ; $A3D9 fe 05
    LD A,($A35E)                          ; $A3DB 3a 5e a3
    CALL $A745                            ; $A3DE cd 45 a7 | Chiamante verificato del prefisso qualificato CLIMB INTO/TAKE OFF: lo scarico passa da A745/A751 a D3E8 con frame5D2C. Il wrap porta il glifo della pulizia a frame5D26. Nessuna proprietà su un chiamante arbitrario.
    POP HL                                ; $A3E1 e1

    ORG $A9DF
; CODE: Scarico della parola: ritorno a capo prima dei glifi
    PUSH DE                               ; $A9DF d5
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd | Il CR viene prima della parola troppo lunga. C363 pulisce la riga e fornisce il glifo spazio: una sola istruzione di output può quindi lasciare il residuo di un’intera pulizia.
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45 | B del chiamante è la lunghezza rimanente della parola. È distinto dal B interno, che C399 reinizializza a8; nel frame5D20 questo byte fisico conserva il B del chiamante, non1.
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
    LD A,($C128)                          ; $C363 3a 28 c1 | Inizio pulizia dell’ultima riga. Il cursore della colonna35 dà shift7; il valore diB non si deduce da quel cursore.
    AND A                                 ; $C366 a7
    LD B,$24                              ; $C367 06 24
    JR Z,$C36D                            ; $C369 28 02
    LD B,$12                              ; $C36B 06 12
    LD HL,$5020                           ; $C36D 21 20 50
    LD C,$02                              ; $C370 0e 02
    LD A,$20                              ; $C372 3e 20
    CALL $C388                            ; $C374 cd 88 c3 | CALL al renderer: il frame5D26 del percorso osservato lascia BC della scansione a5D1C/5D1D. Il salvataggio del registroC era già ricostruito; il byteB è verificato indipendentemente.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $C388
; CODE: Glifo: B della scansione salvato separatamente dal B del chiamante
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5 | Salva il BC del chiamante prima del disegno. Frame5D20: B a5D1D dipende dal conteggio fornito. Le prove usano3 e7 e non installano1 su ogni glifo.
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5 | Con frame5D24 il byte fisico5D1D è H dell’indirizzo video, nonB. Viene calcolato da riga e colonna come nel renderer esistente.
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
    LD B,$08                              ; $C399 06 08 | B=8: il renderer visita otto righe del font, indipendentemente dal B del chiamante salvato prima.
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5 | PUSH BC precede il decremento DJNZ. Ultimo valore salvato: B=1, non0. Con frame5D26 B occupa5D1D. Con shift0 questo è l’ultimo store BC.
    PUSH AF                               ; $C39D f5 | Salva AF della scansione. Con frame5D28 il byte fisico5D1D è A=glyph[7], che può essere nonzero per q. Non è un conteggio universale.
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
    PUSH BC                               ; $C3B7 c5 | Con shift nonzero ripete PUSH BC dopo avere ripristinato BC. B è ancora il contatore della scansione; il cambio in FF/lo shift del secondo byte non sono il valore salvato. Ultimo writer naturale osservato da riportare dal probe, non dal solo byte vicino5D1C.
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
    DJNZ $C39B                            ; $C3D2 10 c7 | DJNZ avviene dopo i salvataggi: raggiunge0 per uscire, ma non salva quello0. Il modello deriva il residuo dalla struttura del ciclo a8 scansioni.
    POP HL                                ; $C3D4 e1
    POP DE                                ; $C3D5 d1
    POP BC                                ; $C3D6 c1 | Ripristina il BC originale del chiamante; i residui salvati più in basso non sono cancellati. Il campo resta proprietario soltanto nei contesti con ABI e profondità noti.
    LD A,C                                ; $C3D7 79
    ADD A,$07                             ; $C3D8 c6 07
    CP $08                                ; $C3DA fe 08
    JR C,$C3E1                            ; $C3DC 38 03
    SUB $08                               ; $C3DE d6 08
    INC L                                 ; $C3E0 2c
    LD C,A                                ; $C3E1 4f
    POP AF                                ; $C3E2 f1
    RET                                   ; $C3E3 c9
