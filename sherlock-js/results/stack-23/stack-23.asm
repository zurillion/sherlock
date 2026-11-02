; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.

    ORG $C388
; CODE: Glifo: B del chiamante e ruoli distinti dei registri salvati
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5 | Ultimo writer naturale5D23: B del chiamante,nonB della scansione. IngressoC388/SP5D26,n di plain,BC0105,Holmes0,tick1653/Tue11:32,returnD65B. Giardiniere8 legge1 al2926/Wed08:45.554 store su22/23 (277 per byte) dal1649,0 transizioni non classificate.
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
    LD B,$08                              ; $C399 06 08 | La scansione usa B8 eDJNZ; il suo ultimo B salvato1 è un registro con ruolo distinto dal B del chiamante.3/7 nei1296ABI riutilizzati distinguono le due cose.
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
    PUSH BC                               ; $C3B7 c5
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
    DJNZ $C39B                            ; $C3D2 10 c7
    POP HL                                ; $C3D4 e1
    POP DE                                ; $C3D5 d1
    POP BC                                ; $C3D6 c1 | Restituisce BC al chiamante; lo stack conserva ancora il byte del precedente PUSHBC finché un nuovo scrittore non lo sovrascrive.
    LD A,C                                ; $C3D7 79
    ADD A,$07                             ; $C3D8 c6 07
    CP $08                                ; $C3DA fe 08
    JR C,$C3E1                            ; $C3DC 38 03
    SUB $08                               ; $C3DE d6 08
    INC L                                 ; $C3E0 2c
    LD C,A                                ; $C3E1 4f
    POP AF                                ; $C3E2 f1
    RET                                   ; $C3E3 c9

    ORG $A9DF
; CODE: Flush della parola: B è il numero di caratteri rimanenti
    PUSH DE                               ; $A9DF d5
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45 | B=L:lunghezza della parola nel buffer. Ogni DJNZ adAA01 lo decrementa; durante plain il chiamante passa5,4,3,2,1. Il runtime usa la lunghezza rimanente della parola,non una costante1.
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9 | Il decremento è esterno al renderer: C388 preserva il B del chiamante,che può essere3 o7 nei controlli. Il B del font resta sempre distinto.
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0
    POP DE                                ; $AA0B d1
    POP HL                                ; $AA0C e1
    POP AF                                ; $AA0D f1
    JR $AA14                              ; $AA0E 18 04
    POP AF                                ; $AA10 f1
    JP $C1E1                              ; $AA11 c3 e1 c1

    ORG $C316
; CODE: Scrolling: registri del chiamante salvati prima della pulizia C374
    LD A,($C128)                          ; $C316 3a 28 c1
    AND A                                 ; $C319 a7
    CALL Z,$C3E4                          ; $C31A cc e4 c3
    PUSH BC                               ; $C31D c5
    PUSH HL                               ; $C31E e5 | C316 conserva HL sopra il frame della chiamata C374/C388. Con glifo-clearing a5D1E, H del chiamante può riscrivere5D23. Caso ABI:colonna5,noun026E,spazio0,dopo il prefisso il valore è80 e non1.
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
    LD A,$20                              ; $C372 3e 20
    CALL $C388                            ; $C374 cd 88 c3 | Il solo C388 non descrive tutto lo scrolling: il prologo C316 può sovrascrivere byte più alti. La nuova proprietà23 viene revocata per i chiamanti esterni non proiettati; nessun80 ricavato per somiglianza.
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

    ORG $D60B
; CODE: Passaggi: prefisso del nome nel frame C388 a 5D26
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
    PUSH IY                               ; $D656 fd e5
    CALL $D3D5                            ; $D658 cd d5 d3 | Prefisso della porta,root dopo movimento:frame5D26,callerB fornito dal flush. LOOK5D2A,contenitori e chiamanti remoti non ricevono questo nuovo contratto.720 configurazioni dei passaggi: 290 valori dichiarati noti e coincidenti. Gli altri restano ignoti; un nome successivo o il wrap del sostantivo finale revocano il nuovo contratto.
    CALL $A414                            ; $D65B cd 14 a4
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

    ORG $CBC2
; CODE: Arrivi ordinari con nome proprio semplice: conservazione di 5D23
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
    LD A,B                                ; $CBE5 78
    CALL $A4BC                            ; $CBE6 cd bc a4 | 1512ABI,720eleggibili:arrivoordinaryAction,persona propria senzaqualificatori attivi,marcatori fino23 preservati. Nomi composti hanno controesempi;queued/isolated/relocate non sono autorizzati a preservare.
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
; CODE: Canale inferiore: rifiuti semplici che conservano 5D23
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
    CALL $C388                            ; $C21B cd 88 c3 | 129rifiuti completi eleggibili su138setup mantengono anche23. Solo direzioni semplici e EXAMINE assente semplice in stanza senza prosa;qualificatori,chiarimenti eNPC caller revocano.
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
