; Dossier offline: strutture e istruzioni distinte, verificate contro il payload.

    ORG $A027
; DATA: Canale di output corrente: superiore0 / inferiore1
    DEFB $00                              ; $A027 00 | Stato mutabile, non una costante iniziale. Il payload contiene0; editor1, esecuzione ordinaria0. VecchioLOAD assente rimaneunknown fino al prossimo writer compreso.

    ORG $9A80
; CODE: Saluto: Holmes nel canale inferiore, NPC nel superiore
    LD A,($A036)                          ; $9A80 3a 36 a0
    CP $00                                ; $9A83 fe 00
    LD A,$01                              ; $9A85 3e 01
    LD HL,$6915                           ; $9A87 21 15 69
    JR Z,$9A90                            ; $9A8A 28 04
    XOR A                                 ; $9A8C af
    LD HL,$6920                           ; $9A8D 21 20 69
    LD ($A027),A                          ; $9A90 32 27 a0 | A=1 solo seA036=0: il saluto senza destinatario diHolmes usa la zona comandi. Un NPC scrive0. La routine non ripristina il valore precedente.
    CALL $A59F                            ; $9A93 cd 9f a5
    OR $01                                ; $9A96 f6 01
    RET                                   ; $9A98 c9

    ORG $A2E4
; CODE: Annuncio dell’azione: selezione del canale e reset esplicito
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
    LD ($A027),A                          ; $A306 32 27 a0 | A=1 seA00C=0 (fallimento); A=0 seA00C nonzero (annuncio dell’azione). Selezione prima del controllo percettivo e del modello: conta anche fuori scena.
    CALL $D078                            ; $A309 cd 78 d0
    JR NC,$A31A                           ; $A30C 30 0c
    LD A,B                                ; $A30E 78
    AND A                                 ; $A30F a7
    JR NZ,$A31A                           ; $A310 20 08
    LD HL,$68D1                           ; $A312 21 d1 68
    CALL $A59F                            ; $A315 cd 9f a5
    JR $A34E                              ; $A318 18 34
    LD A,($A35D)                          ; $A31A 3a 5d a3
    CALL $A2B1                            ; $A31D cd b1 a2
    PUSH HL                               ; $A320 e5
    POP IX                                ; $A321 dd e1
    CALL $A2BD                            ; $A323 cd bd a2
    LD A,($A01D)                          ; $A326 3a 1d a0
    AND $10                               ; $A329 e6 10
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
    LD ($A027),A                          ; $A352 32 27 a0 | Scrive0, NON il canale in ingresso. Anche i percorsi senza testo ritornano daA34E/A352.
    POP DE                                ; $A355 d1
    POP HL                                ; $A356 e1
    POP IX                                ; $A357 dd e1
    POP BC                                ; $A359 c1
    POP IY                                ; $A35A fd e1
    RET                                   ; $A35C c9

    ORG $A9B7
; CODE: Formatter: il canale inferiore salta il buffer delle parole
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0 | Nonzero salta la normale raccolta della parola e passa al canale inferiore senza lo stesso word wrapping.
    AND A                                 ; $A9BB a7
    JR NZ,$AA10                           ; $A9BC 20 52
    POP AF                                ; $A9BE f1

    ORG $C1E1
; CODE: Router del testo: abilitazione e selezione della finestra
    PUSH AF                               ; $C1E1 f5
    LD A,($5C3C)                          ; $C1E2 3a 3c 5c
    AND A                                 ; $C1E5 a7
    JR NZ,$C1EA                           ; $C1E6 20 02
    POP AF                                ; $C1E8 f1
    RET                                   ; $C1E9 c9
    LD A,($A027)                          ; $C1EA 3a 27 a0 | 5C3C abilita il testo; A027 sceglie C2BA (superiore) oppure C1FD (inferiore). Distinto dai flag lessicaliA01D/E.
    AND A                                 ; $C1ED a7
    JR NZ,$C1FC                           ; $C1EE 20 0c
    POP AF                                ; $C1F0 f1
    JP $C2BA                              ; $C1F1 c3 ba c2

    ORG $CB43
; CODE: Fallimento della regola: messaggio nel canale inferiore
    PUSH HL                               ; $CB43 e5
    CALL $DC6C                            ; $CB44 cd 6c dc
    POP HL                                ; $CB47 e1
    JR NZ,$CB65                           ; $CB48 20 1b
    XOR A                                 ; $CB4A af
    LD ($A036),A                          ; $CB4B 32 36 a0
    LD A,($A00B)                          ; $CB4E 3a 0b a0
    AND A                                 ; $CB51 a7
    JR Z,$CB5F                            ; $CB52 28 0b
    LD A,L                                ; $CB54 7d
    OR H                                  ; $CB55 b4
    JR NZ,$CB67                           ; $CB56 20 0f
    XOR A                                 ; $CB58 af
    LD ($A00C),A                          ; $CB59 32 0c a0
    CALL $CA76                            ; $CB5C cd 76 ca
    LD A,($9860)                          ; $CB5F 3a 60 98
    LD ($A036),A                          ; $CB62 32 36 a0
    XOR A                                 ; $CB65 af
    RET                                   ; $CB66 c9
    LD A,$01                              ; $CB67 3e 01
    LD ($A027),A                          ; $CB69 32 27 a0 | Il predicato falso con handler imposta1 prima della chiamata al messaggio. Non confondere con il fallimento senza handler.
    PUSH IY                               ; $CB6C fd e5
    CALL $CB40                            ; $CB6E cd 40 cb
    POP IY                                ; $CB71 fd e1
    XOR A                                 ; $CB73 af
    LD ($A027),A                          ; $CB74 32 27 a0 | Uscita dell’handler: reset0 esplicito prima del ritorno al resolver.
    JR $CB5F                              ; $CB77 18 e6

    ORG $CBA7
; CODE: Rifiuto della richiesta: forza il canale superiore
    LD A,($B934)                          ; $CBA7 3a 34 b9
    BIT 6,A                               ; $CBAA cb 77
    RET Z                                 ; $CBAC c8
    POP HL                                ; $CBAD e1
    XOR A                                 ; $CBAE af
    LD ($A027),A                          ; $CBAF 32 27 a0 | Richiesta vietata daB934bit6: forza0 prima del testo681A; non ereditare il canale dell’errore precedente.
    LD HL,$681A                           ; $CBB2 21 1a 68
    CALL $A59F                            ; $CBB5 cd 9f a5
    JP $DC15                              ; $CBB8 c3 15 dc

    ORG $D6E5
; CODE: Errore lessicale: apre il canale inferiore e poi scrive zero
    LD A,$01                              ; $D6E5 3e 01
    LD ($A027),A                          ; $D6E7 32 27 a0 | Errore lessicale:1 prima di stampare il template6859 e la parola digitata.
    LD HL,$6859                           ; $D6EA 21 59 68
    CALL $A59F                            ; $D6ED cd 9f a5
    LD HL,($D6BD)                         ; $D6F0 2a bd d6
    LD (HL),$C0                           ; $D6F3 36 c0
    LD HL,($A029)                         ; $D6F5 2a 29 a0
    LD A,(HL)                             ; $D6F8 7e
    CP $2E                                ; $D6F9 fe 2e
    JR NZ,$D6FF                           ; $D6FB 20 02
    LD A,$20                              ; $D6FD 3e 20
    CALL $A9B7                            ; $D6FF cd b7 a9
    INC HL                                ; $D702 23
    CP $20                                ; $D703 fe 20
    JR NZ,$D6F8                           ; $D705 20 f1
    LD A,$22                              ; $D707 3e 22
    CALL $A9B7                            ; $D709 cd b7 a9
    CALL $A2A2                            ; $D70C cd a2 a2
    XOR A                                 ; $D70F af
    LD ($A027),A                          ; $D710 32 27 a0 | Dopo la virgoletta eCR di fine errore scrive0; il nuovo editor potrà poi riscrivere1.
    RET                                   ; $D713 c9

    ORG $D7BA
; CODE: Errore sintattico What?: selezione e chiusura del canale
    CP $02                                ; $D7BA fe 02
    JR Z,$D7D0                            ; $D7BC 28 12
    LD A,$01                              ; $D7BE 3e 01
    LD ($A027),A                          ; $D7C0 32 27 a0 | Sintassi errata:1 prima del template6866 What?.
    LD HL,$6866                           ; $D7C3 21 66 68
    CALL $A59F                            ; $D7C6 cd 9f a5
    XOR A                                 ; $D7C9 af
    LD ($A027),A                          ; $D7CA 32 27 a0 | Reset0 prima del saltoDC15; nessun turno del mondo svolto con un1 inventato.
    JP $DC15                              ; $D7CD c3 15 dc

    ORG $D898
; CODE: Editor: seleziona il canale inferiore fino al ritorno
    LD HL,$0BB8                           ; $D898 21 b8 0b
    LD ($A03B),HL                         ; $D89B 22 3b a0
    LD A,$01                              ; $D89E 3e 01
    LD ($A027),A                          ; $D8A0 32 27 a0 | Ingresso editor:1 prima diD8AD, prompt e acquisizione tasti. La pausa dell’oracolo adA536 vede questo1.
    CALL $D8AD                            ; $D8A3 cd ad d8
    PUSH AF                               ; $D8A6 f5
    XOR A                                 ; $D8A7 af
    LD ($A027),A                          ; $D8A8 32 27 a0 | DopoEnter o ritorno speciale dell’editor scrive0 prima della validazione lessicale e degli NPC. WAIT vivo adA074 resta nel canale superiore.
    POP AF                                ; $D8AB f1
    RET                                   ; $D8AC c9
