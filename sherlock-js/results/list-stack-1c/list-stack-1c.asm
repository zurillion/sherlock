; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.

    ORG $D60B
; CODE: Descrizione dei passaggi: cornice del qualificatore prima del nome della porta
    PUSH BC                               ; $D60B c5
    PUSH DE                               ; $D60C d5
    PUSH IY                               ; $D60D fd e5
    PUSH IX                               ; $D60F dd e5
    CALL $D5EF                            ; $D611 cd ef d5
    PUSH IX                               ; $D614 dd e5
    POP IY                                ; $D616 fd e1
    JR $D660                              ; $D618 18 46
    LD A,(IY+$01)                         ; $D61A fd 7e 01
    AND A                                 ; $D61D a7
    JR Z,$D660                            ; $D61E 28 40
    LD A,(IY+$00)                         ; $D620 fd 7e 00
    CP $0B                                ; $D623 fe 0b
    JR NC,$D660                           ; $D625 30 39
    LD A,(IY+$01)                         ; $D627 fd 7e 01
    CALL $D237                            ; $D62A cd 37 d2
    BIT 7,(IX+$05)                        ; $D62D dd cb 05 7e
    JR Z,$D660                            ; $D631 28 2d
    LD A,(IY+$00)                         ; $D633 fd 7e 00
    CALL $D5FB                            ; $D636 cd fb d5
    CP $09                                ; $D639 fe 09
    JR C,$D647                            ; $D63B 38 0a
    LD DE,$000A                           ; $D63D 11 0a 00
    JR Z,$D64D                            ; $D640 28 0b
    LD DE,$00E7                           ; $D642 11 e7 00
    JR $D64D                              ; $D645 18 06
    LD HL,$68BC                           ; $D647 21 bc 68
    CALL $A59F                            ; $D64A cd 9f a5
    CALL $A887                            ; $D64D cd 87 a8
    LD HL,$68E9                           ; $D650 21 e9 68
    CALL $A59F                            ; $D653 cd 9f a5
    PUSH IY                               ; $D656 fd e5 | Conserva IY prima del formatter D3D5: ingresso C388 a5D26 nella descrizione dopo movimento, a5D2A dopo LOOK.720 ABI originali:36colonne,2stati di spazio,5classi del sostantivo.
    CALL $D3D5                            ; $D658 cd d5 d3 | Nel percorso naturale il nome plain door scarica plain prima del sostantivo door. Ultimo glifo n,colonna21,tick1653/Tue11:32. Non attribuire lo stesso frame ai passaggi remoti o in contenitori.
    CALL $A414                            ; $D65B cd 14 a4 | Return link osservato sulla pila del vero writer5D1C. La presenza di una porta senza qualificatore non basta a derivare gli stessi registri.
    POP IY                                ; $D65E fd e1
    ADD IY,BC                             ; $D660 fd 09
    LD A,$FF                              ; $D662 3e ff
    CP (IY+$00)                           ; $D664 fd be 00
    JP NZ,$D61A                           ; $D667 c2 1a d6
    POP IX                                ; $D66A dd e1
    POP IY                                ; $D66C fd e1
    POP DE                                ; $D66E d1
    POP BC                                ; $D66F c1
    RET                                   ; $D670 c9

    ORG $D3D5
; CODE: Nome qualificato: il sostantivo finale scarica il prefisso
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
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $C388
; CODE: Glifo e residuo BC: shift orizzontale e scansione salvati sullo stack
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
    PUSH BC                               ; $C39C c5
    PUSH AF                               ; $C39D f5
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
    PUSH BC                               ; $C3B7 c5 | Writer naturale5D1C: C dello shift=(2+7*colonna)&7, con C388/SP5D26. Ultimo n di plain:5; a5D1D il B salvato1.1578store osservati,0transizioni nonclassificate. Il giardiniere8 legge5D1C al2156/Tue19:55.
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
    DJNZ $C39B                            ; $C3D2 10 c7 | Otto righe del font; PUSH BC salva B prima diDJNZ,non il contatore dopo. Nessun5 o1 globale,il ruolo dipende dal frame.
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

    ORG $CBC2
; CODE: Arrivo di un attore: nomi propri semplici contro nomi composti
    CP $FF                                ; $CBC2 fe ff
    RET Z                                 ; $CBC4 c8
    AND A                                 ; $CBC5 a7
    RET Z                                 ; $CBC6 c8
    LD B,A                                ; $CBC7 47
    CALL $D495                            ; $CBC8 cd 95 d4
    LD C,A                                ; $CBCB 4f
    LD A,($A009)                          ; $CBCC 3a 09 a0
    CP C                                  ; $CBCF b9
    RET NZ                                ; $CBD0 c0
    LD A,$01                              ; $CBD1 3e 01
    LD ($5C3C),A                          ; $CBD3 32 3c 5c
    PUSH DE                               ; $CBD6 d5
    LD A,B                                ; $CBD7 78
    CALL $D237                            ; $CBD8 cd 37 d2
    LD A,(IX+$01)                         ; $CBDB dd 7e 01
    CP $FF                                ; $CBDE fe ff
    JR Z,$CBE5                            ; $CBE0 28 03
    LD B,A                                ; $CBE2 47
    JR $CBD7                              ; $CBE3 18 f2
    LD A,B                                ; $CBE5 78 | Il soggetto effettivo risale i contenitori. Preservazione verificata solo nel chiamante ordinaryAction e con persona propria senza qualificatori visibili:720setup eleggibili su1512ABI. Altri nomi hanno controesempi reali e devono revocare.
    CALL $A4BC                            ; $CBE6 cd bc a4 | A4BC costruisce il nome prima di enters. Watson non riscrive1A–1D; non estendere a nomi composti, richieste accodate o relocate senza prova del chiamante.
    EX (SP),HL                            ; $CBE9 e3
    LD A,($A036)                          ; $CBEA 3a 36 a0
    PUSH AF                               ; $CBED f5
    LD A,($9860)                          ; $CBEE 3a 60 98
    LD ($A036),A                          ; $CBF1 32 36 a0
    CALL $CC29                            ; $CBF4 cd 29 cc
    LD A,B                                ; $CBF7 78
    CALL $C821                            ; $CBF8 cd 21 c8
    JR NZ,$CC00                           ; $CBFB 20 03
    POP AF                                ; $CBFD f1
    POP HL                                ; $CBFE e1
    RET                                   ; $CBFF c9
    POP AF                                ; $CC00 f1
    LD ($A036),A                          ; $CC01 32 36 a0
    CALL $CC29                            ; $CC04 cd 29 cc
    CALL $A59F                            ; $CC07 cd 9f a5
    RET                                   ; $CC0A c9

    ORG $C1FD
; CODE: Canale inferiore: percorso ordinario degli errori e a capo
    PUSH HL                               ; $C1FD e5
    PUSH BC                               ; $C1FE c5
    PUSH AF                               ; $C1FF f5
    LD A,($C1FB)                          ; $C200 3a fb c1
    LD C,A                                ; $C203 4f
    POP AF                                ; $C204 f1
    PUSH AF                               ; $C205 f5
    LD HL,($C1F6)                         ; $C206 2a f6 c1
    CP $0D                                ; $C209 fe 0d
    JR NZ,$C214                           ; $C20B 20 07
    LD A,$20                              ; $C20D 3e 20
    CALL $C388                            ; $C20F cd 88 c3
    JR $C224                              ; $C212 18 10
    CP $08                                ; $C214 fe 08
    JR Z,$C249                            ; $C216 28 31
    CALL $C240                            ; $C218 cd 40 c2
    CALL $C388                            ; $C21B cd 88 c3 | Canale inferiore ordinario: errori di direzione e riferimenti EXAMINE semplici assenti,giocatore root in stanza senza descrizione.129casi originali completi preservano1A–1D. Qualificatori,ricerca nella prosa e chiarimenti non coperti.
    LD A,($C1F4)                          ; $C21E 3a f4 c1
    DEC A                                 ; $C221 3d
    JR NZ,$C22D                           ; $C222 20 09
    LD L,$E0                              ; $C224 2e e0
    LD C,$02                              ; $C226 0e 02
    CALL $C271                            ; $C228 cd 71 c2
    LD A,$24                              ; $C22B 3e 24
    LD ($C1F4),A                          ; $C22D 32 f4 c1
    LD A,C                                ; $C230 79
    LD ($C1FB),A                          ; $C231 32 fb c1
    LD ($C1F6),HL                         ; $C234 22 f6 c1
    LD A,$2B                              ; $C237 3e 2b
    CALL $C388                            ; $C239 cd 88 c3
    POP AF                                ; $C23C f1
    POP BC                                ; $C23D c1
    POP HL                                ; $C23E e1
    RET                                   ; $C23F c9
