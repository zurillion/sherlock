; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.

    ORG $D51A
; CODE: Liste visibili e contenuti ricorsivi: nomi grezzi nel buffer riutilizzato
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
    CALL $D3D9                            ; $D539 cd d9 d3 | D526 stampa l’entità con D3D5. Il nome visibile non è la rappresentazione grezza: i byte dipendono da qualificatori, articolo e suffissi. Lo stesso formatter serve liste a terra e contenuti ricorsivi.
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
    LD DE,$005D                           ; $D551 11 5d 00
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
    CALL $D526                            ; $D56F cd 26 d5 | La ricorsione conserva i delimitatori di ogni livello. La nuova traccia raw-name affianca le profondità dei glifi senza cambiarne il contratto.
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

    ORG $D3D5
; CODE: Formatter D3D5: qualificatori inflettuti e sostantivo non inflettuto
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
    PUSH AF                               ; $D3E8 f5 | Prima seleziona l’articolo con il sostantivo; i qualificatori restano in contesto4 e possono avere suffissi. Il sostantivo successivo usa contesto5/stem.
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
    CALL Z,$A815                          ; $D424 cc 15 a8 | Invia il primo qualificatore se non soppresso; nel caso naturale DE4109 seleziona bloodstained. La i indice8 va a5C13.
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
    CALL NZ,$A815                         ; $D442 c4 15 a8 | Il sostantivo clothes è più corto del qualificatore bloodstained. Il reset del puntatore non cancella la coda: indice8/i sopravvive.
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $A7EB
; CODE: Articolo del nome: due politiche verificate sulle110entità
    LD HL,$A24D                           ; $A7EB 21 4d a2
    LD A,($A027)                          ; $A7EE 3a 27 a0
    LD E,A                                ; $A7F1 5f
    LD A,($A2AA)                          ; $A7F2 3a aa a2 | OriginaleD3D5:220ABI, tutte110entità con A2AA0/1 e canale0. Tabella A24D descrittiva e A255 per annunci/definiti.
    OR E                                  ; $A7F5 b3
    JR Z,$A7FB                            ; $A7F6 28 03
    LD HL,$A255                           ; $A7F8 21 55 a2
    LD A,D                                ; $A7FB 7a
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
    CALL $A887                            ; $A809 cd 87 a8
    POP DE                                ; $A80C d1
    RET                                   ; $A80D c9

    ORG $A24D
; DATA: Tabelle degli articoli: descrizioni e annunci
    DEFB $9D,$08,$01,$00,$5A,$00,$0A,$08  ; $A24D 9d 08 01 00 5a 00 0a 08
    DEFB $9D,$08,$9D,$08,$9D,$08,$0A,$08  ; $A255 9d 08 9d 08 9d 08 0a 08

    ORG $A85C
; DATA: Suffissi grezzi: maiuscole, backspace e terminatori
    DEFB $53,$00,$00,$00,$45,$53,$00,$00  ; $A85C 53 00 00 00 45 53 00 00
    DEFB $49,$45,$53,$00,$08,$49,$45,$53  ; $A864 49 45 53 00 08 49 45 53
    DEFB $44,$00,$00,$00,$49,$4E,$47,$00  ; $A86C 44 00 00 00 49 4e 47 00
    DEFB $45,$44,$00,$00,$08,$49,$4E,$47  ; $A874 45 44 00 00 08 49 4e 47
    DEFB $4C,$59,$00,$00                  ; $A87C 4c 59 00 00

    ORG $A92F
; CODE: Scrittura del suffisso prima della normalizzazione
    LD A,(HL)                             ; $A92F 7e | Non sostituire il suffisso grezzo con la parola formattata sullo schermo. La sequenza può contenere maiuscole e backspace.
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

    ORG $A887
; CODE: Riferimento del dizionario e spazio che scarica il nome precedente
    LD A,($5C3C)                          ; $A887 3a 3c 5c
    AND A                                 ; $A88A a7
    RET Z                                 ; $A88B c8
    LD ($A022),DE                         ; $A88C ed 53 22 a0 | Conserva il riferimento completo. Traccia naturale5C13:4109 durante bloodstained nella lista del salotto, tick1651/Tue11:30.
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
; CODE: Buffer di parola: i nomi nelle liste sovrascrivono solo i byte emessi
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
    LD (HL),A                             ; $A9D7 77 | Ultimo writer naturale5C13: Holmes0,qualificatore4109,bloodstained,i alposto8,tick1651/Tue11:30. La cuoca9 legge105 al1882/Tue15:21; nessuna transizione non classificata nel periodo osservato.
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
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9 | Resetta il puntatore a5C0B, non pulisce il buffer. Dopo clothes e parole più corte resta la coda del qualificatore.
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
    CP $41                                ; $AA14 fe 41 | La proiezione dei pixel segue la formattazione, separata dagli eventi grezzi del nome. Solo una derivazione corrispondente al nome effettivo può diventare nota.
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
