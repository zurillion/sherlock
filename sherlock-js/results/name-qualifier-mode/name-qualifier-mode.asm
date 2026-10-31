; Dossier offline: dati e codice distinti, riassellati contro il payload.

    ORG $A028
; DATA: Modo dei qualificatori nella tuple nome: completo0 / senza qualificatori nonzero
    DEFB $00                              ; $A028 00 | Byte mutabile distinto dal canaleA027. Nonzero salta i due qualificatori nel formatterD405; il nome entitàD3E8 segue invece proprietà dell’entità. Non dedurre un0 globale dal payload.

    ORG $A37D
; CODE: Composizione dell’azione: nome completo prima di parole e argomenti
    XOR A                                 ; $A37D af
    LD ($A028),A                          ; $A37E 32 28 a0 | Scrive0 prima della composizione del modello. Ultimo writer naturale prima della lettura della cuoca: tick3399, giardiniere8, chiamanteA34B.
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
    LD A,($A35E)                          ; $A3B6 3a 5e a3
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
    CALL $A745                            ; $A3DE cd 45 a7
    POP HL                                ; $A3E1 e1
    LD A,($A35F)                          ; $A3E2 3a 5f a3
    CP $FF                                ; $A3E5 fe ff
    JR Z,$A414                            ; $A3E7 28 2b
    BIT 2,C                               ; $A3E9 cb 51
    JR Z,$A414                            ; $A3EB 28 27
    BIT 5,C                               ; $A3ED cb 69
    CALL Z,$A880                          ; $A3EF cc 80 a8
    LD A,($A01E)                          ; $A3F2 3a 1e a0
    BIT 7,A                               ; $A3F5 cb 7f
    CALL Z,$A880                          ; $A3F7 cc 80 a8
    LD A,($A35F)                          ; $A3FA 3a 5f a3
    CP $FE                                ; $A3FD fe fe
    JR NZ,$A409                           ; $A3FF 20 08
    LD HL,($A031)                         ; $A401 2a 31 a0
    CALL $A419                            ; $A404 cd 19 a4
    JR $A414                              ; $A407 18 0b
    LD A,($A010)                          ; $A409 3a 10 a0
    CP $05                                ; $A40C fe 05
    LD A,($A35F)                          ; $A40E 3a 5f a3
    CALL $A745                            ; $A411 cd 45 a7
    LD A,$2E                              ; $A414 3e 2e
    JP $A9B7                              ; $A416 c3 b7 a9

    ORG $A65D
; CODE: Argomento nome completo e lettura della coda argomenti
    XOR A                                 ; $A65D af
    LD ($A028),A                          ; $A65E 32 28 a0 | Comando testo0: scrive0 prima di consumare la tuple nome passata come argomento. Non implica che sia un ID locazione: può puntare ai nomi di entità nelle risposte sulle informazioni.
    CALL $A66C                            ; $A661 cd 6c a6
    EX DE,HL                              ; $A664 eb
    LD A,H                                ; $A665 7c
    OR L                                  ; $A666 b5
    CALL NZ,$A7BA                         ; $A667 c4 ba a7
    XOR A                                 ; $A66A af
    RET                                   ; $A66B c9
    LD HL,($A59D)                         ; $A66C 2a 9d a5
    LD E,(HL)                             ; $A66F 5e
    INC HL                                ; $A670 23
    LD D,(HL)                             ; $A671 56
    INC HL                                ; $A672 23
    LD ($A59D),HL                         ; $A673 22 9d a5
    OR $01                                ; $A676 f6 01
    RET                                   ; $A678 c9

    ORG $A709
; CODE: Nome letterale, soggetto, oggetto e altro referente: writer distinti
    CALL $A66C                            ; $A709 cd 6c a6 | Comando testo4: descrittore lessicale letterale. Non scriveA028; non unificarlo col comando0 solo perché la riscrittura usa lo stesso adapter nameArgument.
    CALL $A80E                            ; $A70C cd 0e a8
    XOR A                                 ; $A70F af
    RET                                   ; $A710 c9
    PUSH IX                               ; $A711 dd e5
    CALL $A66C                            ; $A713 cd 6c a6
    PUSH DE                               ; $A716 d5
    POP IX                                ; $A717 dd e1
    CALL $BF1C                            ; $A719 cd 1c bf
    POP IX                                ; $A71C dd e1
    XOR A                                 ; $A71E af
    RET                                   ; $A71F c9
    XOR A                                 ; $A720 af
    LD ($A028),A                          ; $A721 32 28 a0 | Nome del soggetto: modo0, anche se la parola è poi soppressa o il soggetto èHolmes.
    LD A,($A036)                          ; $A724 3a 36 a0
    CALL $A82F                            ; $A727 cd 2f a8
    XOR A                                 ; $A72A af
    RET                                   ; $A72B c9
    LD A,$01                              ; $A72C 3e 01
    LD ($A028),A                          ; $A72E 32 28 a0 | Nome dell’oggetto corrente: modo1 prima del nome. Il nome entità entra aD3E8 e non sopprime per questo i propri aggettivi.
    LD A,($A034)                          ; $A731 3a 34 a0
    JR $A751                              ; $A734 18 1b
    CALL $A9B7                            ; $A736 cd b7 a9
    XOR A                                 ; $A739 af
    RET                                   ; $A73A c9
    LD A,$01                              ; $A73B 3e 01
    LD ($A028),A                          ; $A73D 32 28 a0 | Altro referente: modo1, comeA72E ma leggeA035.
    LD A,($A035)                          ; $A740 3a 35 a0
    JR $A751                              ; $A743 18 0c
    JR NC,$A751                           ; $A745 30 0a
    PUSH HL                               ; $A747 e5
    CALL $A4AB                            ; $A748 cd ab a4
    CALL $A7BA                            ; $A74B cd ba a7
    POP HL                                ; $A74E e1
    XOR A                                 ; $A74F af
    RET                                   ; $A750 c9

    ORG $A793
; CODE: Nome con copula: modo0 del soggetto e modo1 dell’oggetto
    LD A,($A036)                          ; $A793 3a 36 a0
    EX AF,AF'                             ; $A796 08
    XOR A                                 ; $A797 af
    LD ($A028),A                          ; $A798 32 28 a0 | Soggetto con copula:0 daA797. Oggetto con copula:1 daA7B0. Variante argomentoA7B4: ID entità dal byte altoD, conservato inAF alternativo; il modo scritto resta1. La condizione del lettore è comunque nonzero.
    EX AF,AF'                             ; $A79B 08
    PUSH AF                               ; $A79C f5
    CALL $A82F                            ; $A79D cd 2f a8
    POP AF                                ; $A7A0 f1
    AND A                                 ; $A7A1 a7
    LD DE,$0485                           ; $A7A2 11 85 04
    RET NZ                                ; $A7A5 c0
    LD DE,$007A                           ; $A7A6 11 7a 00
    OR $01                                ; $A7A9 f6 01
    RET                                   ; $A7AB c9
    LD A,($A034)                          ; $A7AC 3a 34 a0
    EX AF,AF'                             ; $A7AF 08
    LD A,$01                              ; $A7B0 3e 01
    JR $A798                              ; $A7B2 18 e4
    CALL $A66C                            ; $A7B4 cd 6c a6
    LD A,D                                ; $A7B7 7a
    JR $A7AF                              ; $A7B8 18 f5

    ORG $A7BA
; CODE: Tuple nome e nome entità: due ingressi distinti
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

    ORG $D1C6
; CODE: Nome della locazione: reset del modo prima del formatter
    LD DE,$0001                           ; $D1C6 11 01 00
    PUSH IY                               ; $D1C9 fd e5
    PUSH IX                               ; $D1CB dd e5
    POP IY                                ; $D1CD fd e1
    ADD IY,DE                             ; $D1CF fd 19
    XOR A                                 ; $D1D1 af
    LD ($A028),A                          ; $D1D2 32 28 a0 | Nome della locazione corrente:0 prima della tupleD405. I nomi usati soltanto da mappa/UI non sono questo writer.
    CALL $D405                            ; $D1D5 cd 05 d4
    POP IY                                ; $D1D8 fd e1
    RET                                   ; $D1DA c9

    ORG $D3D5
; CODE: Formatter dei nomi: entità e tuple generica, salto dei qualificatori
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
    PUSH AF                               ; $D3E8 f5 | Nome entità: non leggeA028. Qualificatori selezionati dai bit del record; non applicare qui il filtro generico delle locazioni.
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
    LD A,($A028)                          ; $D410 3a 28 a0 | LeggeA028 dopo articolo/proper-name setup: se nonzero saltaD416–D435 e stampa solo il sostantivo inD438. Vale per ogni tuple nome, non soltanto per i record delle stanze.
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

    ORG $D526
; CODE: Elenco dei contenuti: modo completo per ogni oggetto
    PUSH IX                               ; $D526 dd e5
    CALL $D04F                            ; $D528 cd 4f d0
    PUSH AF                               ; $D52B f5
    CALL $D57D                            ; $D52C cd 7d d5
    JR C,$D55A                            ; $D52F 38 29
    SET 7,(IY+$06)                        ; $D531 fd cb 06 fe
    SUB A                                 ; $D535 97
    LD ($A028),A                          ; $D536 32 28 a0 | Ogni elemento effettivamente elencato imposta0. Nessun writer se la lista è vuota.
    CALL $D3D9                            ; $D539 cd d9 d3
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

    ORG $D60B
; CODE: Descrizione dei passaggi: ingresso diretto nel nome entità, conserva il modo
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
    CALL $D3D5                            ; $D658 cd d5 d3 | Ingresso direttoD3D5 del nome del passaggio: conservaA028. La presenza di un nome nella frase non basta a stabilire un nuovo modo.
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
