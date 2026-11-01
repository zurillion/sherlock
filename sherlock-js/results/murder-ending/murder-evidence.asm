; Original source evidence only. Typed data are not disassembled as code.

    ORG $E298
; CODE: HAIL: cerca contesti del cab, non del conducente
    LD A,($A034)                          ; $E298 3a 34 a0
    CP $1E                                ; $E29B fe 1e
    JR Z,$E2A4                            ; $E29D 28 05
    CP $21                                ; $E29F fe 21
    JP NZ,$DC15                           ; $E2A1 c2 15 dc
    LD A,($A00A)                          ; $E2A4 3a 0a a0
    LD C,$00                              ; $E2A7 0e 00
    CALL $9C07                            ; $E2A9 cd 07 9c
    JP NZ,$DC15                           ; $E2AC c2 15 dc
    LD IX,($A013)                         ; $E2AF dd 2a 13 a0
    LD A,(IX+$0F)                         ; $E2B3 dd 7e 0f
    AND A                                 ; $E2B6 a7
    JP NZ,$DC15                           ; $E2B7 c2 15 dc
    LD A,($A034)                          ; $E2BA 3a 34 a0 | A contieneA034, identità del veicolo30/33. CFB9 confronta questo id con il primo byte dei contesti; NON cercare31/34. Basil può richiamare un cab con un contesto del conducente ancora attivo.
    CALL $CFB9                            ; $E2BD cd b9 cf
    JP NZ,$DC15                           ; $E2C0 c2 15 dc
    OR $01                                ; $E2C3 f6 01
    RET                                   ; $E2C5 c9

    ORG $E2C6
; DATA: Scratch del servizio cab: identità del conducente
    DEFB $00,$47,$10,$98,$E2              ; $E2C6 00 47 10 98 e2

    ORG $E2CB
; CODE: HAIL: trasferisce il cab e sospende il programma del cocchiere
    LD A,($A00A)                          ; $E2CB 3a 0a a0
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

    ORG $CFB6
; CODE: Ricerca dei contesti per identità esatta del chiamante
    LD A,($A036)                          ; $CFB6 3a 36 a0
    LD IX,$9FEB                           ; $CFB9 dd 21 eb 9f
    PUSH AF                               ; $CFBD f5
    CALL $A0F7                            ; $CFBE cd f7 a0
    JR Z,$CFCC                            ; $CFC1 28 09
    POP AF                                ; $CFC3 f1
    CP (IX+$00)                           ; $CFC4 dd be 00
    JR NZ,$CFBD                           ; $CFC7 20 f4
    OR $01                                ; $CFC9 f6 01
    RET                                   ; $CFCB c9
    POP AF                                ; $CFCC f1
    XOR A                                 ; $CFCD af
    RET                                   ; $CFCE c9

    ORG $A24D
; DATA: Articoli descrittivi: THE, A, AN, SOME
    DEFB $9D,$08,$01,$00,$5A,$00,$0A,$08  ; $A24D 9d 08 01 00 5a 00 0a 08 | Quattro word:089D,0001,005A,080A. Indice dai bit12–13 del nome. Dati, non codice.

    ORG $A255
; DATA: Articoli nelle azioni e negli errori: THE, THE, THE, SOME
    DEFB $9D,$08,$9D,$08,$9D,$08,$0A,$08  ; $A255 9d 08 9d 08 9d 08 0a 08 | Tre forme THE ma il plurale restaSOME (080A); non sostituire tutto conTHE.

    ORG $A2AA
; DATA: Selettore temporaneo degli articoli: distinto da canale e maiuscole
    DEFB $00                              ; $A2AA 00 | A2E6 imposta1 durante l’annuncio, A34F azzera. A7F2 lo combina conA027. Questa annotazione non rende il campo un nuovo ingresso RNG posseduto.

    ORG $A85C
; DATA: Nove suffissi grezzi maiuscoli: quattro byte, con backspace e zero
    DEFB $53,$00,$00,$00,$45,$53,$00,$00  ; $A85C 53 00 00 00 45 53 00 00 | Dati di quattro byte per suffisso. Il testo stampato minuscolo non identifica i byte grezzi condivisi con RNG.
    DEFB $49,$45,$53,$00,$08,$49,$45,$53  ; $A864 49 45 53 00 08 49 45 53
    DEFB $44,$00,$00,$00,$49,$4E,$47,$00  ; $A86C 44 00 00 00 49 4e 47 00
    DEFB $45,$44,$00,$00,$08,$49,$4E,$47  ; $A874 45 44 00 00 08 49 4e 47
    DEFB $4C,$59,$00,$00                  ; $A87C 4c 59 00 00

    ORG $A92F
; CODE: Copia dei suffissi: il buffer conserva ING prima della formattazione
    LD A,(HL)                             ; $A92F 7e | Il selettore a nibble basso sceglie un record di quattro byte; non applica ancora né lowercase né backspace.
    AND $0F                               ; $A930 e6 0f
    CP $0F                                ; $A932 fe 0f
    RET Z                                 ; $A934 c8
    RLCA                                  ; $A935 07
    RLCA                                  ; $A936 07
    LD L,A                                ; $A937 6f
    LD H,$00                              ; $A938 26 00
    LD BC,$A85C                           ; $A93A 01 5c a8
    ADD HL,BC                             ; $A93D 09
    LD B,$04                              ; $A93E 06 04
    LD A,(HL)                             ; $A940 7e
    INC HL                                ; $A941 23
    LD (IX+$00),A                         ; $A942 dd 77 00
    INC IX                                ; $A945 dd 23
    DJNZ $A940                            ; $A947 10 f7
    LD (IX+$00),B                         ; $A949 dd 70 00
    RET                                   ; $A94C c9

    ORG $A7EB
; CODE: Selezione dell’articolo: classe nominale e due tabelle
    LD HL,$A24D                           ; $A7EB 21 4d a2
    LD A,($A027)                          ; $A7EE 3a 27 a0
    LD E,A                                ; $A7F1 5f
    LD A,($A2AA)                          ; $A7F2 3a aa a2 | Se A2AA oppure A027 è nonzero sceglie la tabellaA255; altrimentiA24D. ABI originale16 combinazioni.
    OR E                                  ; $A7F5 b3
    JR Z,$A7FB                            ; $A7F6 28 03
    LD HL,$A255                           ; $A7F8 21 55 a2
    LD A,D                                ; $A7FB 7a | D conserva il nibble della classe: tre rotazioni e AND1E producono l’offset word0/2/4/6.
    RRCA                                  ; $A7FC 0f
    RRCA                                  ; $A7FD 0f
    RRCA                                  ; $A7FE 0f
    AND $1E                               ; $A7FF e6 1e
    PUSH DE                               ; $A801 d5
    LD E,A                                ; $A802 5f
    LD D,$00                              ; $A803 16 00
    ADD HL,DE                             ; $A805 19
    LD E,(HL)                             ; $A806 5e
    INC HL                                ; $A807 23
    LD D,(HL)                             ; $A808 56
    CALL $A887                            ; $A809 cd 87 a8 | Osservato il riferimento selezionato prima della chiamataA887; la restituzione ripristinaDE originale.
    POP DE                                ; $A80C d1
    RET                                   ; $A80D c9

    ORG $A887
; CODE: Separatore del dizionario: scarica la parola dal suo chiamante
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
    CALL $A9B7                            ; $A89C cd b7 a9 | Invia lo spazio del prossimo riferimento al buffer. La parola precedente viene scaricata prima dello spazio grezzo: i due frame differiscono di12 byte nel percorso verificato.
    LD A,D                                ; $A89F 7a
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

    ORG $A9B7
; CODE: Buffer di parola e spazi grezzi: percorsi diversi del ritorno a capo
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0
    AND A                                 ; $A9BB a7
    JR NZ,$AA10                           ; $A9BC 20 52
    POP AF                                ; $A9BE f1
    PUSH AF                               ; $A9BF f5
    PUSH HL                               ; $A9C0 e5
    LD HL,($A9B5)                         ; $A9C1 2a b5 a9
    CP $20                                ; $A9C4 fe 20
    JR Z,$A9DF                            ; $A9C6 28 17
    CP $0D                                ; $A9C8 fe 0d
    JR Z,$A9DF                            ; $A9CA 28 13
    CP $22                                ; $A9CC fe 22
    JR Z,$A9DF                            ; $A9CE 28 0f
    CP $08                                ; $A9D0 fe 08
    JR NZ,$A9D7                           ; $A9D2 20 03
    DEC HL                                ; $A9D4 2b
    JR $A9D9                              ; $A9D5 18 02
    LD (HL),A                             ; $A9D7 77 | Scrive il byte grezzo nel buffer5C0B. Nel nuovo percorso la descrizione del cab scrive travellING: G a5C14 altick1384, letta dalgiardiniere al1432. Derivare daTEXT, non installareG. Nel DROP di Watson, bloodstained lascia invece e a5C15; traccia naturale separata senza store non classificati.
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9
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
    LD B,L                                ; $A9F5 45
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
    POP AF                                ; $AA10 f1
    JP $C1E1                              ; $AA11 c3 e1 c1
    CP $41                                ; $AA14 fe 41
    JR C,$AA1E                            ; $AA16 38 06
    CP $5B                                ; $AA18 fe 5b
    JR NC,$AA1E                           ; $AA1A 30 02
    OR $20                                ; $AA1C f6 20
    PUSH AF                               ; $AA1E f5
    LD A,($A025)                          ; $AA1F 3a 25 a0
    AND A                                 ; $AA22 a7
    JR NZ,$AA2A                           ; $AA23 20 05
    POP AF                                ; $AA25 f1
    CP $20                                ; $AA26 fe 20
    RET Z                                 ; $AA28 c8
    PUSH AF                               ; $AA29 f5
    LD A,$01                              ; $AA2A 3e 01
    LD ($A025),A                          ; $AA2C 32 25 a0
    POP AF                                ; $AA2F f1
    PUSH AF                               ; $AA30 f5
    CP $0D                                ; $AA31 fe 0d
    JR NZ,$AA3B                           ; $AA33 20 06
    XOR A                                 ; $AA35 af
    LD ($A025),A                          ; $AA36 32 25 a0
    JR $AA6D                              ; $AA39 18 32
    CP $22                                ; $AA3B fe 22
    JR NZ,$AA46                           ; $AA3D 20 07
    LD A,$20                              ; $AA3F 3e 20
    CALL $C1E1                            ; $AA41 cd e1 c1
    JR $AA4A                              ; $AA44 18 04
    CP $2E                                ; $AA46 fe 2e
    JR NZ,$AA51                           ; $AA48 20 07
    LD A,$01                              ; $AA4A 3e 01
    LD ($A026),A                          ; $AA4C 32 26 a0
    JR $AA6D                              ; $AA4F 18 1c
    CP $61                                ; $AA51 fe 61
    JR C,$AA6D                            ; $AA53 38 18
    CP $7B                                ; $AA55 fe 7b
    JR NC,$AA6D                           ; $AA57 30 14
    LD A,($A851)                          ; $AA59 3a 51 a8
    AND A                                 ; $AA5C a7
    JR NZ,$AA65                           ; $AA5D 20 06
    LD A,($A026)                          ; $AA5F 3a 26 a0
    AND A                                 ; $AA62 a7
    JR Z,$AA6D                            ; $AA63 28 08
    XOR A                                 ; $AA65 af
    LD ($A026),A                          ; $AA66 32 26 a0
    POP AF                                ; $AA69 f1
    AND $5F                               ; $AA6A e6 5f
    PUSH AF                               ; $AA6C f5
    POP AF                                ; $AA6D f1
    JP $C1E1                              ; $AA6E c3 e1 c1

    ORG $B6DA
; CODE: Riferente escluso dal trasporto: ricerca nella descrizione e messaggi distinti
    CALL $B6FD                            ; $B6DA cd fd b6
    RET Z                                 ; $B6DD c8
    POP DE                                ; $B6DE d1
    CALL $B83C                            ; $B6DF cd 3c b8
    CALL $B633                            ; $B6E2 cd 33 b6
    LD HL,($B186)                         ; $B6E5 2a 86 b1
    PUSH HL                               ; $B6E8 e5
    LD HL,$68A2                           ; $B6E9 21 a2 68
    CALL $A59F                            ; $B6EC cd 9f a5
    RET                                   ; $B6EF c9
    CALL $B6FD                            ; $B6F0 cd fd b6
    RET Z                                 ; $B6F3 c8
    POP DE                                ; $B6F4 d1
    CALL $B83C                            ; $B6F5 cd 3c b8
    CALL $B62F                            ; $B6F8 cd 2f b6
    JR $B6E5                              ; $B6FB 18 e8
    XOR A                                 ; $B6FD af
    LD ($B77E),A                          ; $B6FE 32 7e b7
    LD ($B6D8),HL                         ; $B701 22 d8 b6
    CALL $D33C                            ; $B704 cd 3c d3
    LD L,(IX+$07)                         ; $B707 dd 6e 07
    LD H,(IX+$08)                         ; $B70A dd 66 08
    LD A,H                                ; $B70D 7c
    OR L                                  ; $B70E b5
    RET Z                                 ; $B70F c8 | Descrizione nulla: termina conZ senza trovare il nome. Un oggetto troppo pesante non diventa automaticamente uno scenario nominato.

    ORG $C2BA
; CODE: Canale superiore: uno spazio all’ultima colonna usa il proprio frame
    PUSH HL                               ; $C2BA e5
    PUSH BC                               ; $C2BB c5
    PUSH AF                               ; $C2BC f5
    LD HL,($C1F8)                         ; $C2BD 2a f8 c1
    LD A,($C1FA)                          ; $C2C0 3a fa c1
    LD C,A                                ; $C2C3 4f
    POP AF                                ; $C2C4 f1
    PUSH AF                               ; $C2C5 f5
    CP $0D                                ; $C2C6 fe 0d
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
    CALL $C388                            ; $C2EE cd 88 c3 | Il glifo dello spazio ha il proprio frame; se occupa la colonna35, lo scorrimento sottostante non deve usare il frame della parola precedente.
    LD A,($C1F5)                          ; $C2F1 3a f5 c1
    DEC A                                 ; $C2F4 3d
    JP Z,$C2CA                            ; $C2F5 ca ca c2 | Se il contatore colonne èzero prosegue conC2CA/C2DF: CALLC316 per il nuovo rigo.
    LD ($C1F5),A                          ; $C2F8 32 f5 c1
    LD ($C1F8),HL                         ; $C2FB 22 f8 c1
    LD A,C                                ; $C2FE 79
    LD ($C1FA),A                          ; $C2FF 32 fa c1
    POP AF                                ; $C302 f1
    POP BC                                ; $C303 c1
    POP HL                                ; $C304 e1
    RET                                   ; $C305 c9

    ORG $C316
; CODE: Scorrimento e pulizia: CALLC374 conserva la profondità del chiamante
    LD A,($C128)                          ; $C316 3a 28 c1
    AND A                                 ; $C319 a7
    CALL Z,$C3E4                          ; $C31A cc e4 c3
    PUSH BC                               ; $C31D c5 | Tre PUSH prima del clearC374. Nel caso naturale: parola5D1C, spazio5D28, clear5D20;5D09 non viene scritto.
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
    CALL $C388                            ; $C374 cd 88 c3 | 36 glifi di spazio della pulizia; all’ultima colonna il frame resta quello ricavato dal vero chiamante dello spazio.
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $C7A6
; CODE: Classe9: peso e capacità sono filtri già nella risoluzione
    AND $0F                               ; $C7A6 e6 0f | I controlli strutturali/di peso precedono l’esecuzione; conservare la distinzione dal rifiuto morbido per possesso altrui.
    CP $07                                ; $C7A8 fe 07
    JP Z,$C62F                            ; $C7AA ca 2f c6
    CP $08                                ; $C7AD fe 08
    JR NZ,$C7BB                           ; $C7AF 20 0a
    LD A,C                                ; $C7B1 79
    CALL $C821                            ; $C7B2 cd 21 c8
    JP Z,$C632                            ; $C7B5 ca 32 c6
    JP $C62F                              ; $C7B8 c3 2f c6
    CP $09                                ; $C7BB fe 09
    JR NZ,$C7E4                           ; $C7BD 20 25
    LD A,C                                ; $C7BF 79
    CALL $C821                            ; $C7C0 cd 21 c8
    JP Z,$C632                            ; $C7C3 ca 32 c6
    LD A,C                                ; $C7C6 79
    CALL $C8A7                            ; $C7C7 cd a7 c8
    JP NZ,$C632                           ; $C7CA c2 32 c6
    LD A,C                                ; $C7CD 79
    CALL $C8BE                            ; $C7CE cd be c8
    JP NZ,$C632                           ; $C7D1 c2 32 c6
    LD B,C                                ; $C7D4 41
    LD A,($A036)                          ; $C7D5 3a 36 a0
    CALL $C8C6                            ; $C7D8 cd c6 c8
    JP Z,$C632                            ; $C7DB ca 32 c6
    LD A,C                                ; $C7DE 79
    CALL $C8AF                            ; $C7DF cd af c8
    JR $C768                              ; $C7E2 18 84
    CP $0A                                ; $C7E4 fe 0a
    JR NZ,$C7F9                           ; $C7E6 20 11
    LD A,C                                ; $C7E8 79
    CALL $C821                            ; $C7E9 cd 21 c8
    JP Z,$C632                            ; $C7EC ca 32 c6
    LD A,C                                ; $C7EF 79
    CALL $D275                            ; $C7F0 cd 75 d2
    JP NC,$C632                           ; $C7F3 d2 32 c6
    JP $C62F                              ; $C7F6 c3 2f c6
    CP $0B                                ; $C7F9 fe 0b
    JR NZ,$C80A                           ; $C7FB 20 0d
    LD A,C                                ; $C7FD 79
    CALL $C821                            ; $C7FE cd 21 c8
    JP Z,$C632                            ; $C801 ca 32 c6
    LD A,C                                ; $C804 79
    CALL $C8A7                            ; $C805 cd a7 c8
    JR $C7B5                              ; $C808 18 ab
    CP $0C                                ; $C80A fe 0c
    JR NZ,$C814                           ; $C80C 20 06
    LD A,C                                ; $C80E 79
    CALL $C8BE                            ; $C80F cd be c8
    JR $C7B5                              ; $C812 18 a1
    LD A,C                                ; $C814 79
    CALL $C821                            ; $C815 cd 21 c8
    JP Z,$C632                            ; $C818 ca 32 c6
    LD A,C                                ; $C81B 79
    CALL $C8BE                            ; $C81C cd be c8
    JR $C7B5                              ; $C81F 18 94

    ORG $D3D5
; CODE: Nome di entità: qualificatori, articolo e sostantivo ancora nel buffer
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
    CALL Z,$A815                          ; $D424 cc 15 a8 | Contesto4: qualificatore con suffisso grezzo; il sostantivo finale usa contesto5 senza suffisso. ABI D3D5 su tutte110entità confronta i caratteri prima della normalizzazione.
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

    ORG $D51A
; CODE: Lista degli oggetti e ricorsione dei contenuti: profondità distinte
    PUSH IY                               ; $D51A fd e5
    PUSH DE                               ; $D51C d5
    PUSH BC                               ; $D51D c5
    CALL $D526                            ; $D51E cd 26 d5
    POP BC                                ; $D521 c1
    POP DE                                ; $D522 d1
    POP IY                                ; $D523 fd e1
    RET                                   ; $D525 c9
    PUSH IX                               ; $D526 dd e5
    CALL $D04F                            ; $D528 cd 4f d0
    PUSH AF                               ; $D52B f5
    CALL $D57D                            ; $D52C cd 7d d5
    JR C,$D55A                            ; $D52F 38 29
    SET 7,(IY+$06)                        ; $D531 fd cb 06 fe
    SUB A                                 ; $D535 97
    LD ($A028),A                          ; $D536 32 28 a0
    CALL $D3D9                            ; $D539 cd d9 d3 | D526 chiama il formatter del nome dopo avere aggiornato il flag di osservazione. Qualificatori e sostantivo hanno delimitatori diversi.
    DEC C                                 ; $D53C 0d
    LD A,C                                ; $D53D 79
    AND A                                 ; $D53E a7
    JR NZ,$D546                           ; $D53F 20 05
    CALL $A414                            ; $D541 cd 14 a4
    JR $D557                              ; $D544 18 11
    CP $01                                ; $D546 fe 01
    JR Z,$D551                            ; $D548 28 07
    LD A,$2C                              ; $D54A 3e 2c
    CALL $A9B7                            ; $D54C cd b7 a9
    JR $D557                              ; $D54F 18 06
    LD DE,$005D                           ; $D551 11 5d 00 | AND è una propria chiamata al dizionario, anche nelle liste annidate. Frame5D12 nel treno conWatson e due oggetti; C3B8 lascia0 a5D06 dalla riga del glifo d. Non usare il frame del nome successivo.
    CALL $A887                            ; $D554 cd 87 a8
    POP AF                                ; $D557 f1
    JR $D52B                              ; $D558 18 d1
    POP AF                                ; $D55A f1
    CALL $D04F                            ; $D55B cd 4f d0
    PUSH AF                               ; $D55E f5
    CALL $D57D                            ; $D55F cd 7d d5
    JR C,$D578                            ; $D562 38 14
    PUSH AF                               ; $D564 f5
    CALL $D4CC                            ; $D565 cd cc d4
    JR Z,$D574                            ; $D568 28 0a
    LD C,A                                ; $D56A 4f
    POP AF                                ; $D56B f1
    CALL $D590                            ; $D56C cd 90 d5
    CALL $D526                            ; $D56F cd 26 d5 | La lista ricorsiva aggiunge il suo contesto; i ruoli nella traccia semantica devono conservarlo.
    JR $D575                              ; $D572 18 01
    POP AF                                ; $D574 f1
    POP AF                                ; $D575 f1
    JR $D55E                              ; $D576 18 e6
    POP AF                                ; $D578 f1
    POP IX                                ; $D579 dd e1
    RET                                   ; $D57B c9
    POP AF                                ; $D57C f1
    CALL $D21C                            ; $D57D cd 1c d2
    JR NZ,$D584                           ; $D580 20 02
    SCF                                   ; $D582 37
    RET                                   ; $D583 c9
    PUSH AF                               ; $D584 f5
    CALL $D4EF                            ; $D585 cd ef d4
    JR NC,$D57C                           ; $D588 30 f2
    POP AF                                ; $D58A f1
    LD A,(IX+$00)                         ; $D58B dd 7e 00
    AND A                                 ; $D58E a7
    RET                                   ; $D58F c9
    PUSH IX                               ; $D590 dd e5
    PUSH BC                               ; $D592 c5
    PUSH AF                               ; $D593 f5
    CALL $D237                            ; $D594 cd 37 d2
    BIT 6,(IX+$05)                        ; $D597 dd cb 05 76
    JR Z,$D5A5                            ; $D59B 28 08
    POP AF                                ; $D59D f1
    PUSH AF                               ; $D59E f5
    PUSH AF                               ; $D59F f5
    LD HL,$68B1                           ; $D5A0 21 b1 68
    JR $D5C1                              ; $D5A3 18 1c
    LD HL,$0485                           ; $D5A5 21 85 04
    DEC C                                 ; $D5A8 0d
    JR Z,$D5AE                            ; $D5A9 28 03
    LD HL,$007A                           ; $D5AB 21 7a 00
    PUSH HL                               ; $D5AE e5
    CALL $D5D3                            ; $D5AF cd d3 d5
    LD A,$01                              ; $D5B2 3e 01
    LD ($A2AA),A                          ; $D5B4 32 aa a2
    CALL $D3D5                            ; $D5B7 cd d5 d3
    XOR A                                 ; $D5BA af
    LD ($A2AA),A                          ; $D5BB 32 aa a2
    LD HL,$68D9                           ; $D5BE 21 d9 68
    CALL $A59F                            ; $D5C1 cd 9f a5
    POP AF                                ; $D5C4 f1
    POP BC                                ; $D5C5 c1
    POP IX                                ; $D5C6 dd e1
    RET                                   ; $D5C8 c9

    ORG $9973
; DATA: Prova del suicidio di Mrs Brown: esami e roccia osservata
    DEFB $5E,$05,$60,$A4,$4B,$9A,$2E,$00  ; $9973 5e 05 60 a4 4b 9a 2e 00 | Albero9965 separato. Mrs Brown KILLED herself richiede gli esami della salma/ponte e la roccia osservata.
    DEFB $39,$40,$5D,$00,$5D,$08          ; $997B 39 40 5d 00 5d 08

    ORG $9981
; DATA: Prova dell’omicidio di Tricia: corpo, libreria, abiti e colloqui
    DEFB $5F,$05,$0D,$A4,$59,$9A,$48,$00  ; $9981 5f 05 0d a4 59 9a 48 00 | Mrs Jones KILLED Tricia richiede esami di corpo/libreria e abiti; seguono le due premesse dei colloqui. Non impostare i flag per preparare una soluzione.
    DEFB $42,$40,$43,$00,$43,$40,$00,$00  ; $9989 42 40 43 00 43 40 00 00
    DEFB $00,$00,$00,$00,$00,$08          ; $9991 00 00 00 00 00 08
