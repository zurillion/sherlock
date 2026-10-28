; Analisi offline: nessun opcode o dato del gioco modificato.

    ORG $AB75
; CODE: Nuovo predicato implicito: scrittura nel nodo corrente, poi coordinazione
    LD A,($A024)                          ; $AB75 3a 24 a0
    CP $02                                ; $AB78 fe 02
    JR NZ,$AB8E                           ; $AB7A 20 12
    CALL $ABF3                            ; $AB7C cd f3 ab | ABF3 scrive il nuovo verbo nel nodo corrente PRIMA di allocare il successivo: non conserva il verbo ereditato.
    JR C,$AB8E                            ; $AB7F 38 0d
    JR NZ,$AB8E                           ; $AB81 20 0b
    LD HL,($A029)                         ; $AB83 2a 29 a0 | Ripristina il cursore al token successivo al predicato; ACCC ne prepara una nuova lettura nel prossimo nodo.
    LD ($A02B),HL                         ; $AB86 22 2b a0
    LD D,$A0                              ; $AB89 16 a0
    JP $ACCC                              ; $AB8B c3 cc ac

    ORG $ABF3
; CODE: Predicati: riconoscimento e sovrascrittura della word del verbo
    CALL $AE7F                            ; $ABF3 cd 7f ae
    CP $80                                ; $ABF6 fe 80
    CALL Z,$AE7F                          ; $ABF8 cc 7f ae
    LD A,B                                ; $ABFB 78
    AND $0F                               ; $ABFC e6 0f
    LD B,A                                ; $ABFE 47
    LD HL,$994D                           ; $ABFF 21 4d 99
    LD A,(HL)                             ; $AC02 7e
    INC HL                                ; $AC03 23
    OR (HL)                               ; $AC04 b6
    JR Z,$AC14                            ; $AC05 28 0d
    LD A,B                                ; $AC07 78
    CP (HL)                               ; $AC08 be
    JR NZ,$AC11                           ; $AC09 20 06
    DEC HL                                ; $AC0B 2b
    LD A,C                                ; $AC0C 79
    CP (HL)                               ; $AC0D be
    JR Z,$AC17                            ; $AC0E 28 07
    INC HL                                ; $AC10 23
    INC HL                                ; $AC11 23
    JR $AC02                              ; $AC12 18 ee
    OR $01                                ; $AC14 f6 01
    RET                                   ; $AC16 c9
    LD (IY+$00),C                         ; $AC17 fd 71 00 | Payload sintassi +00: byte basso del predicato lessicale riconosciuto.
    LD (IY+$01),B                         ; $AC1A fd 70 01 | Payload +01: byte alto del predicato. Nella storia major-witness, nodo 97B4: IS=0485, non VISIT=0956.
    RES 1,E                               ; $AC1D cb 8b
    CALL $AE7F                            ; $AC1F cd 7f ae | Consuma il token seguente. I byte del nodo intermedio persistono anche dopo la sua liberazione.
    XOR A                                 ; $AC22 af
    RET                                   ; $AC23 c9

    ORG $ACCC
; CODE: Coordinazione: conserva il nodo e prepara la prossima allocazione
    RES 3,E                               ; $ACCC cb 9b
    PUSH DE                               ; $ACCE d5
    CALL $AE7F                            ; $ACCF cd 7f ae
    CP $A0                                ; $ACD2 fe a0
    JR Z,$ACCF                            ; $ACD4 28 f9
    LD HL,($A029)                         ; $ACD6 2a 29 a0 | Salva la posizione di ripresa dopo il separatore; AB83 usa questo stesso percorso senza AND esplicito.
    LD ($AAA1),HL                         ; $ACD9 22 a1 aa
    LD ($A02B),HL                         ; $ACDC 22 2b a0
    POP DE                                ; $ACDF d1
    LD A,E                                ; $ACE0 7b
    LD ($AAA3),A                          ; $ACE1 32 a3 aa
    LD ($AAA4),IY                         ; $ACE4 fd 22 a4 aa | Conserva il nodo corrente per il backtracking. La successiva allocazione aggiunge un nodo: non sostituisce questo.
    LD A,($A012)                          ; $ACE8 3a 12 a0
    LD ($AAA6),A                          ; $ACEB 32 a6 aa
    LD A,($A01A)                          ; $ACEE 3a 1a a0
    CP $02                                ; $ACF1 fe 02
    JR NZ,$AD57                           ; $ACF3 20 62
    SET 6,(IY+$01)                        ; $ACF5 fd cb 01 f6
    JR $AD57                              ; $ACF9 18 5c

    ORG $C591
; CODE: Regole: pre-verifica, enumerazione e fase di esecuzione
    PUSH HL                               ; $C591 e5
    POP IX                                ; $C592 dd e1
    CALL $C571                            ; $C594 cd 71 c5
    CALL $C57A                            ; $C597 cd 7a c5
    XOR A                                 ; $C59A af
    LD ($A00B),A                          ; $C59B 32 0b a0 | A00B=0: inizio pre-verifica. Non significa che ogni predicato sia eseguito in fase zero.
    LD A,($A00F)                          ; $C59E 3a 0f a0
    LD HL,$A010                           ; $C5A1 21 10 a0
    OR (HL)                               ; $C5A4 b6
    JR Z,$C5F4                            ; $C5A5 28 4d
    LD A,($A00F)                          ; $C5A7 3a 0f a0
    CP $05                                ; $C5AA fe 05
    JR Z,$C5B2                            ; $C5AC 28 04
    CP $06                                ; $C5AE fe 06
    JR NZ,$C5BA                           ; $C5B0 20 08
    LD A,($A034)                          ; $C5B2 3a 34 a0 | Classi letterali 5/6: FE obbligatorio, altrimenti rifiuto prima di passare alla fase uno.
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
    LD A,($A034)                          ; $C5D3 3a 34 a0 | Il primo argomento FF con classe non zero richiede enumerazione dei candidati.
    CP $FF                                ; $C5D6 fe ff
    JR NZ,$C5EB                           ; $C5D8 20 11
    LD B,$00                              ; $C5DA 06 00
    CALL $C463                            ; $C5DC cd 63 c4
    RET Z                                 ; $C5DF c8 | Nessun candidato: ritorna mantenendo fase zero.
    LD ($A034),A                          ; $C5E0 32 34 a0
    CALL $C60D                            ; $C5E3 cd 0d c6 | Per i candidati enumerati verifica C989 in fase zero; soltanto un successo raggiunge C5F4.
    JR NZ,$C5F4                           ; $C5E6 20 0c
    INC B                                 ; $C5E8 04
    JR $C5DC                              ; $C5E9 18 f1
    CALL $C5FC                            ; $C5EB cd fc c5 | Argomento primo già specificato: verifica se il secondo richiede enumerazione.
    JR Z,$C5F4                            ; $C5EE 28 04 | Se anche il secondo è specificato (o classe zero), passa DIRETTAMENTE alla fase uno, senza predicato preventivo.
    CALL $C613                            ; $C5F0 cd 13 c6
    RET Z                                 ; $C5F3 c8
    LD A,$01                              ; $C5F4 3e 01
    LD ($A00B),A                          ; $C5F6 32 0b a0 | A00B=1 PRIMA di C989: anche un successivo predicato falso lascia fase uno. Byte letto dal generatore casuale.
    JP $C989                              ; $C5F9 c3 89 c9 | Controlla luce, classi e predicato; il risultato falso non ripristina A00B.
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
    CALL $C989                            ; $C61E cd 89 c9 | Secondo argomento enumerato: prova in fase zero, poi ripete il controllo in esecuzione quando ha successo.
    JR NZ,$C626                           ; $C621 20 03
    INC B                                 ; $C623 04
    JR $C616                              ; $C624 18 f0
    POP BC                                ; $C626 c1
    RET                                   ; $C627 c9
