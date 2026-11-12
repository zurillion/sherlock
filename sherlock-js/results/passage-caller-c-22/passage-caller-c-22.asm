; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.

    ORG $C2BA
; CODE: Canale superiore: A conservato prima del renderer
    PUSH HL                               ; $C2BA e5
    PUSH BC                               ; $C2BB c5
    PUSH AF                               ; $C2BC f5
    LD HL,($C1F8)                         ; $C2BD 2a f8 c1
    LD A,($C1FA)                          ; $C2C0 3a fa c1
    LD C,A                                ; $C2C3 4f
    POP AF                                ; $C2C4 f1
    PUSH AF                               ; $C2C5 f5
    CP $0D                                ; $C2C6 fe 0d | CP 0D modifica F ma conserva A. Per il glifo ordinario JR NZ e CALL C388 non cambiano il codice del carattere: A e F hanno contratti indipendenti.
    JR NZ,$C2EE                           ; $C2C8 20 24
    LD A,($A019)                          ; $C2CA 3a 19 a0
    CP $0F                                ; $C2CD fe 0f
    JR NZ,$C2D6                           ; $C2CF 20 05
    CALL $C306                            ; $C2D1 cd 06 c3
    LD A,$FF                              ; $C2D4 3e ff
    INC A                                 ; $C2D6 3c
    LD ($A019),A                          ; $C2D7 32 19 a0
    LD HL,$5020                           ; $C2DA 21 20 50
    LD C,$02                              ; $C2DD 0e 02
    CALL $C316                            ; $C2DF cd 16 c3
    LD A,($C128)                          ; $C2E2 3a 28 c1
    AND A                                 ; $C2E5 a7
    LD A,$24                              ; $C2E6 3e 24
    JR Z,$C2F8                            ; $C2E8 28 0e
    LD A,$12                              ; $C2EA 3e 12
    JR $C2F8                              ; $C2EC 18 0a
    CALL $C388                            ; $C2EE cd 88 c3 | Il canale superiore passa il carattere a C388. Nel frame5D26 PUSH AF conserva A a5D25. Non è il byte grezzo dell ultima scansione del font, che occupa questo indirizzo in altri frame.
    LD A,($C1F5)                          ; $C2F1 3a f5 c1
    DEC A                                 ; $C2F4 3d
    JP Z,$C2CA                            ; $C2F5 ca ca c2
    LD ($C1F5),A                          ; $C2F8 32 f5 c1
    LD ($C1F8),HL                         ; $C2FB 22 f8 c1
    LD A,C                                ; $C2FE 79
    LD ($C1FA),A                          ; $C2FF 32 fa c1
    POP AF                                ; $C302 f1
    POP BC                                ; $C303 c1
    POP HL                                ; $C304 e1
    RET                                   ; $C305 c9

    ORG $C388
; CODE: Glifo: offset C del chiamante e offset C della scansione
    PUSH AF                               ; $C388 f5 | Nuovo contratto: A del chiamante salvato a5D25 nel prefisso del passaggio,frame5D26. Il modello deriva il codice del carattere emesso,non110 fisso.1296ABI originali dei sei ruoli riutilizzate; test del modello su tutti96 codici di glifo supportati. Traccia naturale estesa:Holmes0,n di plain,AF6E0A,tick1653/Tue11:32;giardiniere8 legge110 al3102/Wed11:41.904 scritture su24/25(452 per byte),zero transizioni non classificate;stessa sequenza904store della traccia precedente,nessun nuovo store fino al read successivo.
    PUSH BC                               ; $C389 c5 | Nel frame $5D26 PUSH BC conserva C in $5D22. C = (2 + 7 * colonna) & 7. B è il conteggio conservato separatamente in $5D23.
    PUSH DE                               ; $C38A d5 | Writer20 naturale:E del parametro DE5C0B,Holmes0,n di plain,frame5D26,tick1653/Tue11:32. Cuoca9 legge11 al3195/Wed13:14. Non un0B fisso:144varianti originali del descrittore più1296ABI dei ruoli. Nuovo21:D dello stesso parametro,non inferito daE;giardiniere8 legge92 al3288/Wed14:47 dopo traccia estesa.
    PUSH HL                               ; $C38B e5 | PUSH HL salva l’indirizzo bitmap prima della ricerca del font. La posizione deriva da x=2+7*colonna,HL=5020+floor(x/8); il byte L è indipendente dalla conoscenza di H.
    LD L,A                                ; $C38C 6f
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5 | Ultimo writer naturale di5D1E: risalva HL5032,Holmes0,n di plain,frame5D26,colonna21,tick1653/Tue11:32,returnD65B. Giardiniere8 legge50 al3012/Wed10:11. 974 scritture su1E/1F (487 per byte),nessuna transizione non classificata. Non un50 costante.
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a | Carica A dalla riga del font;questo byte è distinto dal codice del carattere già salvato dal chiamante. Il nuovo27 deriva da glyph[7],prima delle rotazioni e senza leggere il pixel composto.
    PUSH BC                               ; $C39C c5 | Prima delle rotazioni, PUSH BC conserva C nel byte $5D28 con frame $5D32. Vale anche con C = 0.
    PUSH AF                               ; $C39D f5 | PUSH AF conserva F della scansione prima delle rotazioni. Con frame5D32 F occupa5D26. Calcolarlo daINC H e dallo shift;il byte27 diA non viene introdotto daquesto contratto.
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
    PUSH BC                               ; $C3B7 c5 | Con C diverso da zero, la metà successiva del glifo salva di nuovo lo stesso C. Per lo spazio dopo plain (colonna 22) il valore salvato è 4.
    PUSH AF                               ; $C3B8 f5 | Ultimo writer26 naturale:AF0000 durante lo spazio dopo plain,frame5D32,colonna22,descriptor526E. Holmes0,tick1653;cuoca9 legge0 al3195. Non lo stesso glifo n che scrive20,e non uno0 di inizializzazione. Nuovo27:A grezzo dell ottava riga del font dello spazio,in questo caso0. Il giardiniere8 legge0 al3288,stesso writer1653. Non copiareF26 né assegnare0 di default.
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

    ORG $C316
; CODE: Scroll: salvataggi esterni e revoca dei chiamanti non ricostruiti
    LD A,($C128)                          ; $C316 3a 28 c1
    AND A                                 ; $C319 a7
    CALL Z,$C3E4                          ; $C31A cc e4 c3
    PUSH BC                               ; $C31D c5 | BC/HL/DE del prologo di scroll possono riscrivere25 sopra il frame del glifo. Il nuovo contratto revoca i clear profondi non proiettati,anche se il solo glifo non scrive25. I salvataggi esterni dello scroll e la relativa CALL possono raggiungere $5D22 e $5D28. Un percorso con stack non ricostruito revoca il valore noto.
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
    LD A,$20                              ; $C372 3e 20
    CALL $C388                            ; $C374 cd 88 c3 | La vera CALL salva C377:frame5D24 lascia C3 a25. Questo ruolo già dimostrato non autorizza a preservare il carattere di un vecchio frame; il return sintetico0008 resta una prova distinta.
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
; CODE: Passaggi: offset del qualificatore e dello spazio successivo
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
    CALL $D3D5                            ; $D658 cd d5 d3 | Prefisso del passaggio dopo movimento,root e nome grezzo verificato: nuovo caller A a25,indipendente dal caller F a24.720geometrie originali riutilizzate:290 valori noti coincidenti. LOOK,remote econtainer fuori dal nuovo contratto. Il qualificatore e il separatore sono emessi a profondità diverse. Il valore C viene calcolato dalla colonna effettiva di ciascun glifo.
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
; CODE: Arrivi propri: effetti dello scorrimento sugli offset conservati
    CP $FF                                ; $CBC2 fe ff | Nei 720 arrivi propri eleggibili, tutti preservano $5D22. In 110 casi lo scorrimento riscrive $5D28. I 300 controlli su riga fresca preservano entrambi.
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
    CALL $A4BC                            ; $CBE6 cd bc a4 | 26 ha un contratto più stretto di20:20dei720 arrivi propri eleggibili alterano26 su riga parziale.300nuovi controlli a colonna0,counter0..14,preservano26. Il runtime ammette solo riga fresca,nome cheentra e counter+2<15,260setup;queued/isolated esclusi. Il medesimo controllo originale è verificato indipendentemente per27:20wrap lo cambiano,300riga fresca lo preservano;runtimecounter+2<15.
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
; CODE: Rifiuti semplici: conservazione dei due offset
    PUSH HL                               ; $C1FD e5 | I 129 rifiuti semplici controllati preservano $5D22 e $5D28 lungo la pipeline completa.
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
    CALL $C388                            ; $C21B cd 88 c3 | 129pipeline di errore semplici preservano20 e26;qualificatori,prosa eNPCcaller esclusi. La conservazione non crea un byte assente in un vecchioSAVE.
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

    ORG $A815
; CODE: Riferimenti nominali: ingresso del sostantivo nel decoder
    PUSH AF                               ; $A815 f5 | Ingresso del riferimento lessicale del sostantivo. L emissione dello spazio iniziale può scaricare la parola precedente; il descrittore del sostantivo non è il puntatore al buffer della parola.
    LD A,D                                ; $A816 7a
    AND $0F                               ; $A817 e6 0f
    LD D,A                                ; $A819 57
    POP AF                                ; $A81A f1
    OR D                                  ; $A81B b2
    LD D,A                                ; $A81C 57
    AND $0F                               ; $A81D e6 0f
    OR E                                  ; $A81F b3
    RET Z                                 ; $A820 c8
    CALL $A887                            ; $A821 cd 87 a8
    LD A,($A7EA)                          ; $A824 3a ea a7
    PUSH HL                               ; $A827 e5
    LD HL,$A026                           ; $A828 21 26 a0
    OR (HL)                               ; $A82B b6
    LD (HL),A                             ; $A82C 77
    POP HL                                ; $A82D e1
    RET                                   ; $A82E c9

    ORG $A887
; CODE: Decoder: spazio che scarica il qualificatore prima del sostantivo
    LD A,($5C3C)                          ; $A887 3a 3c 5c
    AND A                                 ; $A88A a7
    RET Z                                 ; $A88B c8
    LD ($A022),DE                         ; $A88C ed 53 22 a0
    LD A,D                                ; $A890 7a
    AND $0F                               ; $A891 e6 0f
    OR E                                  ; $A893 b3
    RET Z                                 ; $A894 c8
    PUSH IX                               ; $A895 dd e5
    PUSH HL                               ; $A897 e5
    PUSH BC                               ; $A898 c5
    PUSH DE                               ; $A899 d5
    LD A,$20                              ; $A89A 3e 20
    CALL $A9B7                            ; $A89C cd b7 a9
    LD A,D                                ; $A89F 7a | Durante il separatore del sostantivo,il ritorno A89F è nella traccia del glifo spazio,frame5D32. Il nuovo26 appartiene soltanto a questa emissione provata;non a ogni carattere del nome.
    AND $F0                               ; $A8A0 e6 f0
    LD C,A                                ; $A8A2 4f
    CP $70                                ; $A8A3 fe 70
    LD A,$01                              ; $A8A5 3e 01
    JR NZ,$A8AC                           ; $A8A7 20 03
    LD ($A026),A                          ; $A8A9 32 26 a0
    LD A,D                                ; $A8AC 7a
    AND $0F                               ; $A8AD e6 0f
    LD D,A                                ; $A8AF 57
    EX DE,HL                              ; $A8B0 eb
    PUSH HL                               ; $A8B1 e5
    LD A,H                                ; $A8B2 7c
    OR C                                  ; $A8B3 b1
    LD H,A                                ; $A8B4 67
    LD ($A022),HL                         ; $A8B5 22 22 a0
    POP HL                                ; $A8B8 e1

    ORG $D3D5
; CODE: Nomi: qualificatori, sostantivo e loro descrittori distinti
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
    LD E,(IY+$00)                         ; $D438 fd 5e 00 | Carica il sostantivo nel descrittore 5000|noun. Nel caso naturale526E il separatore entra aC388 come spazio,mentre il precedente n usaDE5C0B. Distinguere i due frame ed entrambi i parametri.
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9
