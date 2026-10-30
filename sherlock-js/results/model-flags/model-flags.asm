; Dossier offline: istruzioni riassemblate e dati tipizzati; nessuna CPU nel runtime.

    ORG $A01D
; DATA: Flag persistenti del modello lessicale selezionato
    DEFB $00,$00                          ; $A01D 00 00 | A01D flags=(modello[1]>>4)|(modello[3]&F0); A01E modi=(modello[5]>>4)|(modello[7]&F0). Sono due byte dati persistenti: nessun reset per tick, errore lessicale o nuovo comando senza modello. Vecchio LOAD assente resta unknown.

    ORG $A2B1
; CODE: Selezione modello e decomposizione dei quattro nibble
    DEC A                                 ; $A2B1 3d | Azione1..54:8259+8*(id-1). I byte sono dati lessicali, non istruzioni.
    LD L,A                                ; $A2B2 6f
    LD H,$00                              ; $A2B3 26 00
    ADD HL,HL                             ; $A2B5 29
    ADD HL,HL                             ; $A2B6 29
    ADD HL,HL                             ; $A2B7 29
    LD DE,$8259                           ; $A2B8 11 59 82
    ADD HL,DE                             ; $A2BB 19
    RET                                   ; $A2BC c9
    LD A,(IX+$05)                         ; $A2BD dd 7e 05 | Un solo decoder per i quattro chiamanti B416,C4DF,A323,A38B. Prima scrive A01E, poi A01D. I nibble bassi dei riferimenti lessicali non entrano nei flag.
    RRCA                                  ; $A2C0 0f
    RRCA                                  ; $A2C1 0f
    RRCA                                  ; $A2C2 0f
    RRCA                                  ; $A2C3 0f
    AND $0F                               ; $A2C4 e6 0f
    LD C,A                                ; $A2C6 4f
    LD A,(IX+$07)                         ; $A2C7 dd 7e 07
    AND $F0                               ; $A2CA e6 f0
    ADD A,C                               ; $A2CC 81
    LD ($A01E),A                          ; $A2CD 32 1e a0 | Writer di A01E: combina il nibble alto del byte5 come nibble basso, e quello del byte7 come alto.
    LD A,(IX+$01)                         ; $A2D0 dd 7e 01
    RRCA                                  ; $A2D3 0f
    RRCA                                  ; $A2D4 0f
    RRCA                                  ; $A2D5 0f
    RRCA                                  ; $A2D6 0f
    AND $0F                               ; $A2D7 e6 0f
    LD C,A                                ; $A2D9 4f
    LD A,(IX+$03)                         ; $A2DA dd 7e 03
    AND $F0                               ; $A2DD e6 f0
    ADD A,C                               ; $A2DF 81
    LD ($A01D),A                          ; $A2E0 32 1d a0 | Writer di A01D: combina i nibble alti dei byte1 e3. Nessun salvataggio/ripristino del precedente modello.
    RET                                   ; $A2E3 c9

    ORG $A2E4
; CODE: Gating dell’annuncio: anche fuori scena rilegge il modello
    LD A,$01                              ; $A2E4 3e 01
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
    JR NC,$A31A                           ; $A30C 30 0c | Se attore non percepibile e modo annuncio1, A310 passa comunque ad A31A e al decoder A323. Non limitare la proprietà dei flag ai soli messaggi visibili.
    LD A,B                                ; $A30E 78
    AND A                                 ; $A30F a7
    JR NZ,$A31A                           ; $A310 20 08
    LD HL,$68D1                           ; $A312 21 d1 68
    CALL $A59F                            ; $A315 cd 9f a5
    JR $A34E                              ; $A318 18 34

    ORG $A31A
; CODE: Annuncio: ricarica i flag prima del testo e conserva i residui
    LD A,($A35D)                          ; $A31A 3a 5d a3
    CALL $A2B1                            ; $A31D cd b1 a2
    PUSH HL                               ; $A320 e5
    POP IX                                ; $A321 dd e1
    CALL $A2BD                            ; $A323 cd bd a2 | Anche gli annunci leggono il modello; questo writer non è limitato al comando inserito dal giocatore.
    LD A,($A01D)                          ; $A326 3a 1d a0
    AND $10                               ; $A329 e6 10 | Bit4 di A01D sopprime il normale annuncio. Il decoder è già passato e quindi i flag restano aggiornati anche se il testo viene saltato.
    JR NZ,$A34E                           ; $A32B 20 21
    CP B                                  ; $A32D b8
    JR Z,$A336                            ; $A32E 28 06
    CALL $DC6C                            ; $A330 cd 6c dc
    CALL Z,$A2A2                          ; $A333 cc a2 a2
    CALL $A724                            ; $A336 cd 24 a7
    LD DE,$017F                           ; $A339 11 7f 01
    XOR A                                 ; $A33C af
    CP B                                  ; $A33D b8
    JR NZ,$A348                           ; $A33E 20 08
    CALL $A887                            ; $A340 cd 87 a8
    CALL $A360                            ; $A343 cd 60 a3
    JR $A34B                              ; $A346 18 03
    CALL $A37D                            ; $A348 cd 7d a3
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
; CODE: Composizione degli ordini: aggiorna i flag del modello stampato
    XOR A                                 ; $A37D af
    LD ($A028),A                          ; $A37E 32 28 a0
    LD A,($A35D)                          ; $A381 3a 5d a3
    CALL $A2B1                            ; $A384 cd b1 a2
    PUSH HL                               ; $A387 e5
    POP IX                                ; $A388 dd e1
    PUSH HL                               ; $A38A e5
    CALL $A2BD                            ; $A38B cd bd a2 | Il testo composto di un ordine aggiorna A01D/E con il modello dell’azione citata, non necessariamente SAY/TELL esterno.
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

    ORG $B1DD
; CODE: Resolver: classi e presenza degli argomenti dai flag
    CALL $C493                            ; $B1DD cd 93 c4
    CALL $C4B2                            ; $B1E0 cd b2 c4
    LD A,($A01C)                          ; $B1E3 3a 1c a0
    AND A                                 ; $B1E6 a7
    JR NZ,$B1F2                           ; $B1E7 20 09
    LD A,($B39C)                          ; $B1E9 3a 9c b3
    LD ($A01C),A                          ; $B1EC 32 1c a0
    CALL $B34F                            ; $B1EF cd 4f b3
    LD A,($A01E)                          ; $B1F2 3a 1e a0
    AND $10                               ; $B1F5 e6 10
    LD ($B190),A                          ; $B1F7 32 90 b1
    JR Z,$B200                            ; $B1FA 28 04
    XOR A                                 ; $B1FC af
    LD ($A01C),A                          ; $B1FD 32 1c a0
    XOR A                                 ; $B200 af
    LD ($A00B),A                          ; $B201 32 0b a0
    LD A,($A01D)                          ; $B204 3a 1d a0
    AND $0C                               ; $B207 e6 0c
    JR NZ,$B213                           ; $B209 20 08
    CALL $C929                            ; $B20B cd 29 c9
    RET NZ                                ; $B20E c0
    LD HL,$B863                           ; $B20F 21 63 b8
    RET                                   ; $B212 c9

    ORG $B405
; CODE: Modello lessicale e ordine fisico dei complementi
    AND A                                 ; $B405 a7
    JR Z,$B416                            ; $B406 28 0e
    LD HL,($B188)                         ; $B408 2a 88 b1
    LD DE,($B18A)                         ; $B40B ed 5b 8a b1
    LD ($B188),DE                         ; $B40F ed 53 88 b1
    LD ($B18A),HL                         ; $B413 22 8a b1
    CALL $A2BD                            ; $B416 cd bd a2 | Dopo il riconoscimento del modello, prima di classi e ordine dei complementi. Errori che non raggiungono il riconoscimento conservano i flag precedenti.
    LD HL,$B188                           ; $B419 21 88 b1
    LD A,(HL)                             ; $B41C 7e
    INC HL                                ; $B41D 23
    OR (HL)                               ; $B41E b6
    JR NZ,$B426                           ; $B41F 20 05
    LD A,($A01E)                          ; $B421 3a 1e a0
    JR $B445                              ; $B424 18 1f
    DEC HL                                ; $B426 2b
    LD A,(HL)                             ; $B427 7e
    CP (IY+$0E)                           ; $B428 fd be 0e
    JR NZ,$B435                           ; $B42B 20 08
    INC HL                                ; $B42D 23
    LD A,(HL)                             ; $B42E 7e
    CP (IY+$0F)                           ; $B42F fd be 0f
    JR Z,$B440                            ; $B432 28 0c
    DEC HL                                ; $B434 2b
    LD A,(HL)                             ; $B435 7e
    CP (IY+$10)                           ; $B436 fd be 10
    JR NZ,$B440                           ; $B439 20 05
    INC HL                                ; $B43B 23
    LD A,(HL)                             ; $B43C 7e
    CP (IY+$11)                           ; $B43D fd be 11
    LD A,($A01D)                          ; $B440 3a 1d a0 | Bit5 del primo flag governa l’ordine dei gruppi fisici. Il XOR20 modifica soltanto A nel registro, non A01D.
    JR NZ,$B447                           ; $B443 20 02
    XOR $20                               ; $B445 ee 20
    BIT 5,A                               ; $B447 cb 6f
    LD BC,$1208                           ; $B449 01 08 12
    JR Z,$B451                            ; $B44C 28 03
    LD BC,$0812                           ; $B44E 01 12 08
    LD HL,$B182                           ; $B451 21 82 b1
    LD (HL),B                             ; $B454 70
    INC HL                                ; $B455 23
    LD (HL),C                             ; $B456 71
    LD A,B                                ; $B457 78
    LD DE,$B172                           ; $B458 11 72 b1
    LD HL,$B16D                           ; $B45B 21 6d b1
    CALL $B468                            ; $B45E cd 68 b4
    LD A,C                                ; $B461 79
    LD DE,$B178                           ; $B462 11 78 b1
    LD HL,$B16E                           ; $B465 21 6e b1

    ORG $C493
; CODE: Classi zero, locazione, letterale ed entità dal modello
    XOR A                                 ; $C493 af
    LD HL,$A01D                           ; $C494 21 1d a0
    BIT 3,(HL)                            ; $C497 cb 5e | Bit3 richiede il primo argomento. Se assente, classe0.
    JR Z,$C4AE                            ; $C499 28 13
    LD A,$04                              ; $C49B 3e 04
    BIT 7,(HL)                            ; $C49D cb 7e | Bit7 indica prima classe4 (locazione). Altrimenti modo A01E&0C=0C dà classe5, gli altri classe7.
    JR NZ,$C4AE                           ; $C49F 20 0d
    LD A,($A01E)                          ; $C4A1 3a 1e a0
    AND $0C                               ; $C4A4 e6 0c
    CP $0C                                ; $C4A6 fe 0c
    LD A,$05                              ; $C4A8 3e 05
    JR Z,$C4AE                            ; $C4AA 28 02
    LD A,$07                              ; $C4AC 3e 07
    LD ($A00F),A                          ; $C4AE 32 0f a0
    RET                                   ; $C4B1 c9
    XOR A                                 ; $C4B2 af
    LD HL,$A01D                           ; $C4B3 21 1d a0
    BIT 2,(HL)                            ; $C4B6 cb 56 | Bit2 richiede il secondo argomento; bit6 sceglie locazione. A01E&03=03 sceglie letterale, altrimenti entità.
    JR Z,$C4CD                            ; $C4B8 28 13
    LD A,$04                              ; $C4BA 3e 04
    BIT 6,(HL)                            ; $C4BC cb 76
    JR NZ,$C4CD                           ; $C4BE 20 0d
    LD A,($A01E)                          ; $C4C0 3a 1e a0
    AND $03                               ; $C4C3 e6 03
    CP $03                                ; $C4C5 fe 03
    LD A,$05                              ; $C4C7 3e 05
    JR Z,$C4CD                            ; $C4C9 28 02
    LD A,$07                              ; $C4CB 3e 07
    LD ($A010),A                          ; $C4CD 32 10 a0
    RET                                   ; $C4D0 c9

    ORG $C4D1
; CODE: Dispatch delle azioni: modello dati e argomenti mancanti
    LD A,($A033)                          ; $C4D1 3a 33 a0
    BIT 7,A                               ; $C4D4 cb 7f
    JP NZ,$C583                           ; $C4D6 c2 83 c5
    CALL $A2B1                            ; $C4D9 cd b1 a2
    PUSH HL                               ; $C4DC e5
    POP IX                                ; $C4DD dd e1
    CALL $A2BD                            ; $C4DF cd bd a2 | Ogni azione normale carica il proprio modello prima del preflight. Le regole interne >=128 saltano direttamente a C583 e non fanno questo store.
    CALL $C493                            ; $C4E2 cd 93 c4
    CALL $C4B2                            ; $C4E5 cd b2 c4
    XOR A                                 ; $C4E8 af
    LD ($A00B),A                          ; $C4E9 32 0b a0
    LD A,($A01D)                          ; $C4EC 3a 1d a0 | Maschera0C: presenza dei due argomenti. Non equivale alle classi effettive delle regole DOMAIN, che possono sovrascrivere A00F/A010 senza cambiare A01D/E.
    AND $0C                               ; $C4EF e6 0c
    JR Z,$C53A                            ; $C4F1 28 47
    LD A,($A00F)                          ; $C4F3 3a 0f a0
    CP $05                                ; $C4F6 fe 05
    JR NZ,$C502                           ; $C4F8 20 08
    LD A,($A034)                          ; $C4FA 3a 34 a0
    CP $FE                                ; $C4FD fe fe
    JP NZ,$CB41                           ; $C4FF c2 41 cb
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
    INC B                                 ; $C520 04
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
    LD ($A00B),A                          ; $C53C 32 0b a0
    JP $C929                              ; $C53F c3 29 c9
    LD A,($A010)                          ; $C542 3a 10 a0
    AND A                                 ; $C545 a7
    RET Z                                 ; $C546 c8
    LD A,($A035)                          ; $C547 3a 35 a0
    CP $FF                                ; $C54A fe ff
    JR NZ,$C558                           ; $C54C 20 0a
    LD A,($A01D)                          ; $C54E 3a 1d a0 | Bit1 consente il secondo argomento non specificato nella ricerca delle azioni.
    AND $02                               ; $C551 e6 02
    JR NZ,$C558                           ; $C553 20 03
    OR $01                                ; $C555 f6 01
    RET                                   ; $C557 c9
    XOR A                                 ; $C558 af
    RET                                   ; $C559 c9

    ORG $CA76
; CODE: Annuncio del movimento interno: lookup anche fuori scena
    LD A,($A033)                          ; $CA76 3a 33 a0 | Il movimento interno seleziona la direzione e passa ad A2E4 anche se fuori scena. La visibilità regola il testo, non elimina il successivo decoder dei flag.
    AND $80                               ; $CA79 e6 80
    CALL Z,$A2E4                          ; $CA7B cc e4 a2
    RET                                   ; $CA7E c9

    ORG $E345
; CODE: Pagamento interno: seleziona PAY per il successivo annuncio
    CALL $E34F                            ; $E345 cd 4f e3
    RET Z                                 ; $E348 c8
    LD A,$25                              ; $E349 3e 25
    LD ($A033),A                          ; $E34B 32 33 a0 | Dopo il controllo di fondi, imposta azione25hex=37dec PAY. Il successivo annuncio CA76/A323 aggiorna i flag anche fuori scena; non resta il precedente modello CLOSE di un altro attore.
    RET                                   ; $E34E c9
