; Dossier offline: intestazioni dati e algoritmo funzionale, nessun runtime Z80.

    ORG $A021
; DATA: Residuo dei controlli: scritture selettive, non esito globale
    DEFB $00                              ; $A021 00 | Dato iniziale caricato =0. L’avvio sino al primo prompt non lo scrive nei quattro seed verificati. C655 scrive0; C6BA scrive1. Il successo, il tick, il nuovo comando e il reset del costo non lo azzerano. LOAD deve conservare il byte; un vecchio save senza campo rimane sconosciuto.

    ORG $C4D1
; CODE: Azioni: enumerazione dei referenti e passaggio da verifica a esecuzione
    LD A,($A033)                          ; $C4D1 3a 33 a0
    BIT 7,A                               ; $C4D4 cb 7f
    JP NZ,$C583                           ; $C4D6 c2 83 c5
    CALL $A2B1                            ; $C4D9 cd b1 a2
    PUSH HL                               ; $C4DC e5
    POP IX                                ; $C4DD dd e1
    CALL $A2BD                            ; $C4DF cd bd a2
    CALL $C493                            ; $C4E2 cd 93 c4
    CALL $C4B2                            ; $C4E5 cd b2 c4
    XOR A                                 ; $C4E8 af
    LD ($A00B),A                          ; $C4E9 32 0b a0 | La fase A00B=0 rende morbide alcune restrizioni: la ricerca dei nomi non equivale all’esecuzione. A021 non viene azzerato qui.
    LD A,($A01D)                          ; $C4EC 3a 1d a0
    AND $0C                               ; $C4EF e6 0c
    JR Z,$C53A                            ; $C4F1 28 47
    LD A,($A00F)                          ; $C4F3 3a 0f a0
    CP $05                                ; $C4F6 fe 05
    JR NZ,$C502                           ; $C4F8 20 08
    LD A,($A034)                          ; $C4FA 3a 34 a0
    CP $FE                                ; $C4FD fe fe
    JP NZ,$CB41                           ; $C4FF c2 41 cb | Rifiuto anticipato di un letterale mancante: non attraversa C655 e conserva A021.
    LD A,($A010)                          ; $C502 3a 10 a0
    CP $05                                ; $C505 fe 05
    JR NZ,$C511                           ; $C507 20 08
    LD A,($A035)                          ; $C509 3a 35 a0
    CP $FE                                ; $C50C fe fe
    JP NZ,$CB41                           ; $C50E c2 41 cb
    LD A,($A00F)                          ; $C511 3a 0f a0
    AND A                                 ; $C514 a7
    JR Z,$C531                            ; $C515 28 1a
    LD A,($A034)                          ; $C517 3a 34 a0
    CP $FF                                ; $C51A fe ff
    JR NZ,$C531                           ; $C51C 20 13
    LD B,$FF                              ; $C51E 06 ff
    INC B                                 ; $C520 04 | Enumera gli ID in ordine crescente. Il modello tradotto deve visitare anche i candidati rifiutati che possono scrivere il residuo.
    CALL $C463                            ; $C521 cd 63 c4
    RET Z                                 ; $C524 c8
    LD ($A034),A                          ; $C525 32 34 a0
    PUSH BC                               ; $C528 c5
    CALL $C55A                            ; $C529 cd 5a c5
    POP BC                                ; $C52C c1
    JR NZ,$C53A                           ; $C52D 20 0b
    JR $C520                              ; $C52F 18 ef
    CALL $C542                            ; $C531 cd 42 c5
    JR Z,$C53A                            ; $C534 28 04
    CALL $C560                            ; $C536 cd 60 c5
    RET Z                                 ; $C539 c8
    LD A,$01                              ; $C53A 3e 01
    LD ($A00B),A                          ; $C53C 32 0b a0 | Imposta la fase esecutiva prima della validazione finale; non scrive A021.
    JP $C929                              ; $C53F c3 29 c9
    LD A,($A010)                          ; $C542 3a 10 a0
    AND A                                 ; $C545 a7
    RET Z                                 ; $C546 c8
    LD A,($A035)                          ; $C547 3a 35 a0
    CP $FF                                ; $C54A fe ff
    JR NZ,$C558                           ; $C54C 20 0a
    LD A,($A01D)                          ; $C54E 3a 1d a0
    AND $02                               ; $C551 e6 02
    JR NZ,$C558                           ; $C553 20 03
    OR $01                                ; $C555 f6 01
    RET                                   ; $C557 c9
    XOR A                                 ; $C558 af
    RET                                   ; $C559 c9
    CALL $C542                            ; $C55A cd 42 c5
    JP Z,$C929                            ; $C55D ca 29 c9
    LD B,$FF                              ; $C560 06 ff
    INC B                                 ; $C562 04
    CALL $C45E                            ; $C563 cd 5e c4
    JR Z,$C570                            ; $C566 28 08
    LD ($A035),A                          ; $C568 32 35 a0
    CALL $C929                            ; $C56B cd 29 c9
    JR Z,$C562                            ; $C56E 28 f2
    RET                                   ; $C570 c9
    LD A,(IX+$00)                         ; $C571 dd 7e 00
    AND $0F                               ; $C574 e6 0f
    LD ($A00F),A                          ; $C576 32 0f a0
    RET                                   ; $C579 c9
    LD A,(IX+$01)                         ; $C57A dd 7e 01
    AND $0F                               ; $C57D e6 0f
    LD ($A010),A                          ; $C57F 32 10 a0
    RET                                   ; $C582 c9

    ORG $C583
; CODE: Regole interne: classi, letterali e ricerca degli argomenti mancanti
    AND $7F                               ; $C583 e6 7f
    LD E,A                                ; $C585 5f
    LD D,$00                              ; $C586 16 00
    LD HL,$9FAB                           ; $C588 21 ab 9f
    ADD HL,DE                             ; $C58B 19
    ADD HL,DE                             ; $C58C 19
    LD E,(HL)                             ; $C58D 5e
    INC HL                                ; $C58E 23
    LD D,(HL)                             ; $C58F 56
    EX DE,HL                              ; $C590 eb
    PUSH HL                               ; $C591 e5
    POP IX                                ; $C592 dd e1
    CALL $C571                            ; $C594 cd 71 c5
    CALL $C57A                            ; $C597 cd 7a c5
    XOR A                                 ; $C59A af
    LD ($A00B),A                          ; $C59B 32 0b a0 | Anche le regole interne hanno preflight separato. Non dedurre il residuo dal solo risultato finale della regola.
    LD A,($A00F)                          ; $C59E 3a 0f a0
    LD HL,$A010                           ; $C5A1 21 10 a0
    OR (HL)                               ; $C5A4 b6
    JR Z,$C5F4                            ; $C5A5 28 4d
    LD A,($A00F)                          ; $C5A7 3a 0f a0
    CP $05                                ; $C5AA fe 05
    JR Z,$C5B2                            ; $C5AC 28 04
    CP $06                                ; $C5AE fe 06
    JR NZ,$C5BA                           ; $C5B0 20 08
    LD A,($A034)                          ; $C5B2 3a 34 a0 | Controllo FE prima della ricerca. Classi5/6 distinguono poi il tag del letterale nel byte basso.
    CP $FE                                ; $C5B5 fe fe
    JP NZ,$CB41                           ; $C5B7 c2 41 cb
    LD A,($A010)                          ; $C5BA 3a 10 a0
    CP $05                                ; $C5BD fe 05
    JR Z,$C5C5                            ; $C5BF 28 04
    CP $06                                ; $C5C1 fe 06
    JR NZ,$C5CD                           ; $C5C3 20 08
    LD A,($A035)                          ; $C5C5 3a 35 a0
    CP $FE                                ; $C5C8 fe fe
    JP NZ,$CB41                           ; $C5CA c2 41 cb
    LD A,($A00F)                          ; $C5CD 3a 0f a0
    AND A                                 ; $C5D0 a7
    JR Z,$C5EB                            ; $C5D1 28 18
    LD A,($A034)                          ; $C5D3 3a 34 a0
    CP $FF                                ; $C5D6 fe ff
    JR NZ,$C5EB                           ; $C5D8 20 11
    LD B,$00                              ; $C5DA 06 00
    CALL $C463                            ; $C5DC cd 63 c4
    RET Z                                 ; $C5DF c8
    LD ($A034),A                          ; $C5E0 32 34 a0
    CALL $C60D                            ; $C5E3 cd 0d c6
    JR NZ,$C5F4                           ; $C5E6 20 0c
    INC B                                 ; $C5E8 04
    JR $C5DC                              ; $C5E9 18 f1
    CALL $C5FC                            ; $C5EB cd fc c5
    JR Z,$C5F4                            ; $C5EE 28 04
    CALL $C613                            ; $C5F0 cd 13 c6
    RET Z                                 ; $C5F3 c8
    LD A,$01                              ; $C5F4 3e 01
    LD ($A00B),A                          ; $C5F6 32 0b a0 | Con argomenti espliciti la fase diventa1 prima del controllo, anche se il predicato finirà per fallire.
    JP $C989                              ; $C5F9 c3 89 c9
    LD A,($A010)                          ; $C5FC 3a 10 a0
    AND A                                 ; $C5FF a7
    RET Z                                 ; $C600 c8
    LD A,($A035)                          ; $C601 3a 35 a0
    CP $FF                                ; $C604 fe ff
    JR NZ,$C60B                           ; $C606 20 03
    OR $01                                ; $C608 f6 01
    RET                                   ; $C60A c9
    XOR A                                 ; $C60B af
    RET                                   ; $C60C c9
    CALL $C5FC                            ; $C60D cd fc c5
    JP Z,$C989                            ; $C610 ca 89 c9
    PUSH BC                               ; $C613 c5
    LD B,$00                              ; $C614 06 00
    CALL $C45E                            ; $C616 cd 5e c4
    JR Z,$C626                            ; $C619 28 0b
    LD ($A035),A                          ; $C61B 32 35 a0
    CALL $C989                            ; $C61E cd 89 c9
    JR NZ,$C626                           ; $C621 20 03
    INC B                                 ; $C623 04
    JR $C616                              ; $C624 18 f0
    POP BC                                ; $C626 c1
    RET                                   ; $C627 c9

    ORG $C628
; CODE: Primo argomento: classi, maschere e scritture del residuo
    LD A,(IY+$00)                         ; $C628 fd 7e 00 | Il nibble basso del primo byte è la classe del primo argomento; classe0 accetta senza scrivere A021.
    AND $0F                               ; $C62B e6 0f
    JR NZ,$C635                           ; $C62D 20 06
    OR $01                                ; $C62F f6 01
    RET                                   ; $C631 c9
    JP $DC15                              ; $C632 c3 15 dc
    CP $05                                ; $C635 fe 05
    JR C,$C660                            ; $C637 38 27
    CP $07                                ; $C639 fe 07
    JR NC,$C682                           ; $C63B 30 45
    LD A,($A034)                          ; $C63D 3a 34 a0
    CP $FE                                ; $C640 fe fe
    JR NZ,$C654                           ; $C642 20 10
    LD HL,($A02F)                         ; $C644 2a 2f a0 | Primo letterale: legge A02F/A030; classe5 richiede bit7 basso spento, classe6 acceso. Il fallimento passa C655.
    LD A,(IY+$00)                         ; $C647 fd 7e 00
    AND $0F                               ; $C64A e6 0f
    CP $05                                ; $C64C fe 05
    JR NZ,$C65A                           ; $C64E 20 0a
    BIT 7,L                               ; $C650 cb 7d
    JR Z,$C62F                            ; $C652 28 db
    XOR A                                 ; $C654 af
    LD ($A021),A                          ; $C655 32 21 a0 | Scrive0 soltanto su questo percorso di rifiuto. Vi arrivano classi locazione/letterale non valide di entrambi i ruoli e rifiuti di classe entità del primo ruolo.
    JR $C632                              ; $C658 18 d8
    BIT 7,L                               ; $C65A cb 7d
    JR NZ,$C62F                           ; $C65C 20 d1
    JR $C654                              ; $C65E 18 f4
    CP $03                                ; $C660 fe 03
    JR NC,$C670                           ; $C662 30 0c
    LD A,($A034)                          ; $C664 3a 34 a0
    CALL $D224                            ; $C667 cd 24 d2
    BIT 7,(IX+$00)                        ; $C66A dd cb 00 7e
    JR Z,$C654                            ; $C66E 28 e4
    BIT 0,(IY+$00)                        ; $C670 fd cb 00 46
    JR Z,$C62F                            ; $C674 28 b9
    LD A,($A034)                          ; $C676 3a 34 a0
    CALL $D471                            ; $C679 cd 71 d4
    CP $FF                                ; $C67C fe ff
    JR Z,$C654                            ; $C67E 28 d4
    JR $C62F                              ; $C680 18 ad
    LD A,($A034)                          ; $C682 3a 34 a0
    LD ($CB7A),A                          ; $C685 32 7a cb
    LD C,A                                ; $C688 4f
    LD A,(IY+$00)                         ; $C689 fd 7e 00
    CALL $C7A6                            ; $C68C cd a6 c7
    JR Z,$C654                            ; $C68F 28 c3 | Il primo ruolo converte anche il fallimento di C7A6 in scrittura0. Questa istruzione è la differenza rispetto a C726.
    BIT 4,(IY+$00)                        ; $C691 fd cb 00 66 | Le maschere esistono soltanto se bit4 dell’intestazione è acceso. Il predicato opzionale bit6 sposta di due byte i dati delle maschere.
    JR Z,$C62F                            ; $C695 28 98
    LD A,(IY+$02)                         ; $C697 fd 7e 02
    LD L,(IY+$03)                         ; $C69A fd 6e 03
    LD H,(IY+$04)                         ; $C69D fd 66 04
    BIT 6,(IY+$00)                        ; $C6A0 fd cb 00 76
    JR Z,$C6AF                            ; $C6A4 28 09
    LD A,(IY+$04)                         ; $C6A6 fd 7e 04
    LD L,(IY+$05)                         ; $C6A9 fd 6e 05
    LD H,(IY+$06)                         ; $C6AC fd 66 06
    RRCA                                  ; $C6AF 0f
    RRCA                                  ; $C6B0 0f
    RRCA                                  ; $C6B1 0f
    RRCA                                  ; $C6B2 0f
    LD B,A                                ; $C6B3 47
    CALL $C74E                            ; $C6B4 cd 4e c7
    RET NZ                                ; $C6B7 c0
    LD A,$01                              ; $C6B8 3e 01
    LD ($A021),A                          ; $C6BA 32 21 a0 | Scrive1 quando le maschere del primo o secondo ruolo falliscono in fase esecutiva. In preflight la restrizione morbida restituisce successo e non raggiunge questa scrittura.
    RET                                   ; $C6BD c9

    ORG $C6BE
; CODE: Secondo argomento: rifiuti che conservano il vecchio residuo
    LD A,(IY+$01)                         ; $C6BE fd 7e 01 | La classe del secondo ruolo viene dal nibble basso del secondo byte dell’intestazione.
    AND $0F                               ; $C6C1 e6 0f
    JR NZ,$C6CB                           ; $C6C3 20 06
    OR $01                                ; $C6C5 f6 01
    RET                                   ; $C6C7 c9
    JP $DC15                              ; $C6C8 c3 15 dc
    CP $05                                ; $C6CB fe 05
    JR C,$C6F5                            ; $C6CD 38 26
    CP $07                                ; $C6CF fe 07
    JR NC,$C719                           ; $C6D1 30 46
    LD A,($A035)                          ; $C6D3 3a 35 a0
    CP $FE                                ; $C6D6 fe fe
    JP NZ,$C654                           ; $C6D8 c2 54 c6
    LD HL,($A031)                         ; $C6DB 2a 31 a0 | Il secondo letterale legge A031/A032, distinto dal primo. Nessuna intestazione attuale estratta usa questa classe nel secondo ruolo; l’ABI controllato verifica comunque il ramo.
    LD A,(IY+$01)                         ; $C6DE fd 7e 01
    AND $0F                               ; $C6E1 e6 0f
    CP $05                                ; $C6E3 fe 05
    JR NZ,$C6EE                           ; $C6E5 20 07
    BIT 7,L                               ; $C6E7 cb 7d
    JR Z,$C6C5                            ; $C6E9 28 da
    JP $C654                              ; $C6EB c3 54 c6
    BIT 7,L                               ; $C6EE cb 7d
    JR NZ,$C6C5                           ; $C6F0 20 d3
    JP $C654                              ; $C6F2 c3 54 c6
    CP $03                                ; $C6F5 fe 03
    JR NC,$C706                           ; $C6F7 30 0d
    LD A,($A035)                          ; $C6F9 3a 35 a0
    CALL $D224                            ; $C6FC cd 24 d2
    BIT 7,(IX+$00)                        ; $C6FF dd cb 00 7e
    JP Z,$C654                            ; $C703 ca 54 c6
    BIT 0,(IY+$01)                        ; $C706 fd cb 01 46
    JR Z,$C6C5                            ; $C70A 28 b9
    LD A,($A035)                          ; $C70C 3a 35 a0
    CALL $D471                            ; $C70F cd 71 d4
    CP $FF                                ; $C712 fe ff
    JP Z,$C654                            ; $C714 ca 54 c6
    JR $C6C5                              ; $C717 18 ac
    LD A,($A035)                          ; $C719 3a 35 a0
    LD ($CB7A),A                          ; $C71C 32 7a cb
    LD C,A                                ; $C71F 4f
    LD A,(IY+$01)                         ; $C720 fd 7e 01
    CALL $C7A6                            ; $C723 cd a6 c7
    RET Z                                 ; $C726 c8 | Rifiuto di classe entità del secondo ruolo: ritorna direttamente senza C655, conservando il precedente A021. Non uniformare i due ruoli.
    BIT 4,(IY+$00)                        ; $C727 fd cb 00 66
    JP Z,$C62F                            ; $C72B ca 2f c6
    LD A,(IY+$02)                         ; $C72E fd 7e 02
    LD L,(IY+$05)                         ; $C731 fd 6e 05
    LD H,(IY+$06)                         ; $C734 fd 66 06
    BIT 6,(IY+$00)                        ; $C737 fd cb 00 76
    JR Z,$C746                            ; $C73B 28 09
    LD A,(IY+$04)                         ; $C73D fd 7e 04
    LD L,(IY+$07)                         ; $C740 fd 6e 07
    LD H,(IY+$08)                         ; $C743 fd 66 08
    LD B,A                                ; $C746 47
    CALL $C74E                            ; $C747 cd 4e c7
    RET NZ                                ; $C74A c0
    JP $C6B8                              ; $C74B c3 b8 c6 | Un fallimento delle maschere del secondo ruolo condivide C6B8/C6BA e quindi scrive1.

    ORG $C74E
; CODE: Maschere: due test ordinati e distinzione fra verifica ed esecuzione
    LD A,C                                ; $C74E 79 | Due test ordinati su attributi record+05. Ogni modo seleziona: tutti presenti, almeno uno (maschera0 accettata), nessuno, non tutti. Una maschera0 con modo3 fallisce.
    CALL $D237                            ; $C74F cd 37 d2
    LD C,(IX+$05)                         ; $C752 dd 4e 05
    LD A,B                                ; $C755 78
    RRCA                                  ; $C756 0f
    RRCA                                  ; $C757 0f
    AND $03                               ; $C758 e6 03
    LD D,L                                ; $C75A 55
    CALL $C763                            ; $C75B cd 63 c7
    RET Z                                 ; $C75E c8
    LD A,B                                ; $C75F 78
    AND $03                               ; $C760 e6 03
    LD D,H                                ; $C762 54
    JR NZ,$C76D                           ; $C763 20 08
    LD A,D                                ; $C765 7a
    AND C                                 ; $C766 a1
    CP D                                  ; $C767 ba
    JP Z,$C62F                            ; $C768 ca 2f c6
    JR $C792                              ; $C76B 18 25
    CP $01                                ; $C76D fe 01
    JR NZ,$C77B                           ; $C76F 20 0a
    LD A,D                                ; $C771 7a
    AND A                                 ; $C772 a7
    JR Z,$C768                            ; $C773 28 f3
    AND C                                 ; $C775 a1
    JR Z,$C795                            ; $C776 28 1d
    JP $C62F                              ; $C778 c3 2f c6
    CP $02                                ; $C77B fe 02
    JR NZ,$C788                           ; $C77D 20 09
    LD A,D                                ; $C77F 7a
    AND C                                 ; $C780 a1
    JP Z,$C62F                            ; $C781 ca 2f c6
    OR $80                                ; $C784 f6 80
    JR $C797                              ; $C786 18 0f
    LD A,D                                ; $C788 7a
    AND C                                 ; $C789 a1
    CP D                                  ; $C78A ba
    JP NZ,$C62F                           ; $C78B c2 2f c6
    OR $80                                ; $C78E f6 80
    JR $C797                              ; $C790 18 05
    XOR $FF                               ; $C792 ee ff
    AND D                                 ; $C794 a2
    AND $7F                               ; $C795 e6 7f
    LD ($CB79),A                          ; $C797 32 79 cb
    LD A,($A00B)                          ; $C79A 3a 0b a0 | Con A00B=0 il rifiuto della maschera è morbido e non scrive A021. Con fase1 ritorna l’handler CB7B e il chiamante registra1.
    AND A                                 ; $C79D a7
    JP Z,$C62F                            ; $C79E ca 2f c6
    LD HL,$CB7B                           ; $C7A1 21 7b cb
    XOR A                                 ; $C7A4 af
    RET                                   ; $C7A5 c9

    ORG $C7A6
; CODE: Classi delle entità: percezione, trasporto, possesso e persona
    AND $0F                               ; $C7A6 e6 0f | La classe effettiva è quella della regola, non la classe di ricerca nominale del modello del verbo.
    CP $07                                ; $C7A8 fe 07
    JP Z,$C62F                            ; $C7AA ca 2f c6
    CP $08                                ; $C7AD fe 08
    JR NZ,$C7BB                           ; $C7AF 20 0a
    LD A,C                                ; $C7B1 79
    CALL $C821                            ; $C7B2 cd 21 c8
    JP Z,$C632                            ; $C7B5 ca 32 c6
    JP $C62F                              ; $C7B8 c3 2f c6
    CP $09                                ; $C7BB fe 09 | Classe9: percezione, una sola occorrenza, non persona e capacità sono controlli rigidi. La risalita a un proprietario persona usa invece la restrizione morbida C768/C79A.
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
    CP $0A                                ; $C7E4 fe 0a | Classe10 richiede percezione e possesso. Classe11 richiede percezione e numero di occorrenze diverso da1.
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
    CP $0C                                ; $C80A fe 0c | Classe12 controlla soltanto il bit persona; classi13–15 richiedono anche percezione.
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

    ORG $C9BF
; CODE: Regola selezionata: luce, primo argomento, secondo e predicato
    PUSH HL                               ; $C9BF e5
    POP IY                                ; $C9C0 fd e1
    CALL $D078                            ; $C9C2 cd 78 d0 | Il rifiuto per buio precede i due argomenti e non modifica A021.
    JR NC,$C9D3                           ; $C9C5 30 0c
    LD A,(IY+$00)                         ; $C9C7 fd 7e 00
    AND $20                               ; $C9CA e6 20
    JR Z,$C9D3                            ; $C9CC 28 05
    LD HL,$CBBB                           ; $C9CE 21 bb cb
    XOR A                                 ; $C9D1 af
    RET                                   ; $C9D2 c9
    CALL $C628                            ; $C9D3 cd 28 c6 | Ordine: primo ruolo, secondo ruolo, eventuale predicato. Un fallimento precedente impedisce controlli e scritture dei successivi.
    JR Z,$C9D1                            ; $C9D6 28 f9
    CALL $C6BE                            ; $C9D8 cd be c6
    JR Z,$C9D1                            ; $C9DB 28 f4
    BIT 6,(IY+$00)                        ; $C9DD fd cb 00 76
    JR Z,$C9F2                            ; $C9E1 28 0f
    LD L,(IY+$02)                         ; $C9E3 fd 6e 02
    LD H,(IY+$03)                         ; $C9E6 fd 66 03
    PUSH IY                               ; $C9E9 fd e5
    CALL $CB34                            ; $C9EB cd 34 cb
    POP IY                                ; $C9EE fd e1
    JR Z,$C9D1                            ; $C9F0 28 df
    LD A,($A00B)                          ; $C9F2 3a 0b a0 | Il successo di preflight ritorna senza eseguire il corpo. Nessun reset di A021 sul successo.
    AND A                                 ; $C9F5 a7
    JR NZ,$C9FB                           ; $C9F6 20 03
    OR $01                                ; $C9F8 f6 01
    RET                                   ; $C9FA c9
