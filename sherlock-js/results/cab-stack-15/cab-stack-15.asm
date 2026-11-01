; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.

    ORG $C388
; CODE: Renderer: 5D15 è A grezzo della scansione con frame5D20
    PUSH AF                               ; $C388 f5 | I sei frame16/18/1A/1C/1E/20 fanno assumere a5D15 sei ruoli distinti: A chiamante, B chiamante, D descrittore, H video, B scansione, A scansione. ABI separate:3672casi.
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
    PUSH BC                               ; $C39C c5
    PUSH AF                               ; $C39D f5 | Con frame5D20 salva A, riga grezza del font, a5D15; il byteF è a5D14. Non leggere la bitmap né usare zero globale.
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
    PUSH AF                               ; $C3B8 f5 | Ultimo writer naturale: MrsJones95,tick1472/Tue08:31,carattereo diTO prima del nomeYOU,frame5D20. Salva l’ottava riga grezza: o=0,q=6,underscore=255. La cuoca legge5D15 al1519/Tue09:18.
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

    ORG $A59F
; CODE: TEXT con argomento: chiamante del prefisso di una risposta TELL
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
; CODE: Nome destinatario: lo spazio scarica la parola TO precedente
    XOR A                                 ; $A720 af
    LD ($A028),A                          ; $A721 32 28 a0
    LD A,($A036)                          ; $A724 3a 36 a0
    CALL $A82F                            ; $A727 cd 2f a8
    XOR A                                 ; $A72A af
    RET                                   ; $A72B c9
    LD A,$01                              ; $A72C 3e 01 | Il token nome-oggetto imposta modo1 e usaA034. Nel TELL con destinatario proprio, il primo spazio scarica TO a frame5D20; non è ancora il glifo del destinatario.
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
    PUSH HL                               ; $A751 e5 | Non possedere il medesimo frame per destinatari con articolo: A7EB aggiunge un proprio chiamante e un proprio delimitatore.
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

    ORG $A7BA
; CODE: Formatter di nome proprio e YOU: articolo distinto
    PUSH IY                               ; $A7BA fd e5
    PUSH HL                               ; $A7BC e5
    POP IY                                ; $A7BD fd e1
    CALL $D405                            ; $A7BF cd 05 d4
    POP IY                                ; $A7C2 fd e1
    RET                                   ; $A7C4 c9
    PUSH IY                               ; $A7C5 fd e5
    PUSH HL                               ; $A7C7 e5
    POP IY                                ; $A7C8 fd e1
    CALL $D3E8                            ; $A7CA cd e8 d3
    POP IY                                ; $A7CD fd e1
    RET                                   ; $A7CF c9
    XOR A                                 ; $A7D0 af
    LD ($A7EA),A                          ; $A7D1 32 ea a7
    BIT 7,D                               ; $A7D4 cb 7a
    JR Z,$A7EB                            ; $A7D6 28 13
    LD A,E                                ; $A7D8 7b
    LD HL,$09EE                           ; $A7D9 21 ee 09
    CP L                                  ; $A7DC bd
    JR NZ,$A7E4                           ; $A7DD 20 05
    LD A,D                                ; $A7DF 7a
    AND $0F                               ; $A7E0 e6 0f
    CP H                                  ; $A7E2 bc
    RET Z                                 ; $A7E3 c8
    LD A,$01                              ; $A7E4 3e 01
    LD ($A7EA),A                          ; $A7E6 32 ea a7
    RET                                   ; $A7E9 c9

    ORG $D3D5
; CODE: Nome entità: delimitatore prima dei qualificatori e del sostantivo
    PUSH IX                               ; $D3D5 dd e5
    POP IY                                ; $D3D7 fd e1
    PUSH IY                               ; $D3D9 fd e5
    PUSH DE                               ; $D3DB d5
    LD DE,$0007                           ; $D3DC 11 07 00
    ADD IY,DE                             ; $D3DF fd 19
    CALL $D3E8                            ; $D3E1 cd e8 d3
    POP DE                                ; $D3E4 d1
    POP IY                                ; $D3E5 fd e1
    RET                                   ; $D3E7 c9
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
    LD E,(IY+$00)                         ; $D438 fd 5e 00
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8 | Il sostantivo YOU viene inviato al dizionario. Il suo spazio iniziale stampa la parola precedente TO, non YOU; il sostantivo rimane pendente.
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $E1D8
; CODE: Risposta TELL ABOUT: seleziona il testo e usa il modello6830
    LD A,($A036)                          ; $E1D8 3a 36 a0
    CALL $E207                            ; $E1DB cd 07 e2
    JR Z,$E1FC                            ; $E1DE 28 1c
    INC IX                                ; $E1E0 dd 23
    LD A,($A035)                          ; $E1E2 3a 35 a0
    CALL $E201                            ; $E1E5 cd 01 e2
    JR Z,$E1FC                            ; $E1E8 28 12
    LD L,(IX+$01)                         ; $E1EA dd 6e 01
    LD H,(IX+$02)                         ; $E1ED dd 66 02
    PUSH AF                               ; $E1F0 f5
    PUSH HL                               ; $E1F1 e5
    LD HL,$6830                           ; $E1F2 21 30 68 | Carica modello6830 dopo due PUSH aggiuntivi. Il suo prefisso richiama6804: TO e il nome destinatario hanno profondità distinte.
    CALL $A59F                            ; $E1F5 cd 9f a5
    POP AF                                ; $E1F8 f1
    OR $01                                ; $E1F9 f6 01
    RET                                   ; $E1FB c9
    LD HL,$761D                           ; $E1FC 21 1d 76
    JR $E1F0                              ; $E1FF 18 ef

    ORG $E2CB
; CODE: HAIL invisibile: sospensione del cocchiere sopra il workspace basso
    LD A,($A00A)                          ; $E2CB 3a 0a a0 | Nel percorso DOMAIN invisibile naturale, ingressoSP5D6E,minimo5D4E e zero chiamateC388. Nessuno store5D14–5D16 dopo la confessione fino alla lettura. Non attribuire lo zero aHAIL.
    LD B,A                                ; $E2CE 47
    LD A,($A034)                          ; $E2CF 3a 34 a0
    INC A                                 ; $E2D2 3c
    LD ($E2C6),A                          ; $E2D3 32 c6 e2
    DEC A                                 ; $E2D6 3d
    CALL $DD0E                            ; $E2D7 cd 0e dd
    LD A,($A036)                          ; $E2DA 3a 36 a0
    LD B,A                                ; $E2DD 47
    LD A,($A034)                          ; $E2DE 3a 34 a0
    LD C,A                                ; $E2E1 4f
    LD DE,$F2B6                           ; $E2E2 11 b6 f2
    LD A,($E2C6)                          ; $E2E5 3a c6 e2
    CALL $E2EE                            ; $E2E8 cd ee e2
    OR $01                                ; $E2EB f6 01
    RET                                   ; $E2ED c9
    PUSH DE                               ; $E2EE d5
    LD D,A                                ; $E2EF 57
    LD A,B                                ; $E2F0 78
    LD ($A034),A                          ; $E2F1 32 34 a0
    LD A,C                                ; $E2F4 79
    LD ($A035),A                          ; $E2F5 32 35 a0
    LD A,($A036)                          ; $E2F8 3a 36 a0
    PUSH AF                               ; $E2FB f5
    LD A,D                                ; $E2FC 7a
    LD ($A036),A                          ; $E2FD 32 36 a0
    CALL $CC0E                            ; $E300 cd 0e cc
    LD L,(IY+$01)                         ; $E303 fd 6e 01
    LD H,(IY+$02)                         ; $E306 fd 66 02
    LD B,$02                              ; $E309 06 02
    CALL $CF80                            ; $E30B cd 80 cf | La creazione del contesto conserva l’origineF37A. ABI E2CB controllate:24combinazioni frame66/6E,cab30/33,azione precedente0/31/255,marker00/A5;5D15 invariato. Non è raggiungibilità naturale di tutti i parametri.
    POP AF                                ; $E30E f1
    LD ($A036),A                          ; $E30F 32 36 a0
    POP DE                                ; $E312 d1
    LD (IY+$01),E                         ; $E313 fd 73 01
    LD (IY+$02),D                         ; $E316 fd 72 02
    OR $01                                ; $E319 f6 01
    RET                                   ; $E31B c9

    ORG $CF80
; CODE: Crea contesto esterno del cocchiere: conserva origine e argomenti
    PUSH IX                               ; $CF80 dd e5 | Lista di contesti esterni, distinta dal byte di stack5D15. Il fatto che HAIL allochi una nuova riga non autorizza una cancellazione del workspace basso.
    LD A,$07                              ; $CF82 3e 07
    CALL $A11C                            ; $CF84 cd 1c a1
    LD A,($A036)                          ; $CF87 3a 36 a0
    LD (IX+$00),A                         ; $CF8A dd 77 00
    LD (IX+$01),L                         ; $CF8D dd 75 01
    LD (IX+$02),H                         ; $CF90 dd 74 02
    LD DE,($A034)                         ; $CF93 ed 5b 34 a0
    LD (IX+$03),E                         ; $CF97 dd 73 03
    LD (IX+$04),D                         ; $CF9A dd 72 04
    LD (IX+$05),B                         ; $CF9D dd 70 05
    LD A,($9FD6)                          ; $CFA0 3a d6 9f
    LD (IX+$06),A                         ; $CFA3 dd 77 06
    LD HL,($9FE9)                         ; $CFA6 2a e9 9f
    LD ($9FE9),IX                         ; $CFA9 dd 22 e9 9f
    LD (IX-$02),L                         ; $CFAD dd 75 fe
    LD (IX-$01),H                         ; $CFB0 dd 74 ff
    POP IX                                ; $CFB3 dd e1
    RET                                   ; $CFB5 c9

    ORG $67F7
; DATA: Prefissi compressi della conversazione: attore, TO e destinatario
    DEFB $06,$0A,$02,$87,$79,$87,$13,$1F  ; $67F7 06 0a 02 87 79 87 13 1f
    DEFB $0B,$F8,$FF,$22,$1F,$0B,$F3,$FF  ; $67FF 0b f8 ff 22 1f 0b f3 ff
    DEFB $61,$07,$22,$1F                  ; $6807 61 07 22 1f

    ORG $6830
; DATA: Modello compresso della risposta: prefisso, argomento e virgolette
    DEFB $0B,$D4,$FF,$19,$22,$1E          ; $6830 0b d4 ff 19 22 1e
