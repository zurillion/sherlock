; Analisi offline: dati tipizzati separati dal codice; byte riasssemblati contro il payload.

    ORG $CB28
; DATA: Risultati persistenti: conservati anche attraverso rifiuti senza callback
    DEFB $00,$00,$00,$00                  ; $CB28 00 00 00 00 | Word persistenti IX/IY dell’ultima chiamata CB34. Un tentativo rifiutato prima di CB34 non le cancella. OldSAVE senza valore restaunknown.

    ORG $CB2C
; CODE: Ponte: il predicato falso salva i registri, il corpo ricarica i risultati
    LD IX,($CB28)                         ; $CB2C dd 2a 28 cb | Solo il corpo immediato ricarica i risultati precedenti. Non sono genericamente i due argomenti correnti.
    LD IY,($CB2A)                         ; $CB30 fd 2a 2a cb
    CALL $CB40                            ; $CB34 cd 40 cb | Predicato o corpo chiamato con IX/IY scelti dal chiamante. Il predicato falso NON evita i due store successivi.
    LD ($CB28),IX                         ; $CB37 dd 22 28 cb | Writer IX: nella ricerca DD6E è l’indirizzo del primo record uscita trovato, oppure quello del terminatoreFF.
    LD ($CB2A),IY                         ; $CB3B fd 22 2a cb | Writer IY: D471 ripristina l’IY entrante; nel predicato DD6E è l’intestazioneDD61.
    RET                                   ; $CB3F c9
    JP (HL)                               ; $CB40 e9

    ORG $C9BF
; CODE: Confine tra preflight, predicato e corpo immediato o differito
    PUSH HL                               ; $C9BF e5
    POP IY                                ; $C9C0 fd e1
    CALL $D078                            ; $C9C2 cd 78 d0
    JR NC,$C9D3                           ; $C9C5 30 0c
    LD A,(IY+$00)                         ; $C9C7 fd 7e 00
    AND $20                               ; $C9CA e6 20
    JR Z,$C9D3                            ; $C9CC 28 05
    LD HL,$CBBB                           ; $C9CE 21 bb cb
    XOR A                                 ; $C9D1 af
    RET                                   ; $C9D2 c9
    CALL $C628                            ; $C9D3 cd 28 c6
    JR Z,$C9D1                            ; $C9D6 28 f9
    CALL $C6BE                            ; $C9D8 cd be c6
    JR Z,$C9D1                            ; $C9DB 28 f4
    BIT 6,(IY+$00)                        ; $C9DD fd cb 00 76 | Nessun predicato senza bit6. I rifiuti dei vincoli prima di questo punto non producono risultati nuovi.
    JR Z,$C9F2                            ; $C9E1 28 0f
    LD L,(IY+$02)                         ; $C9E3 fd 6e 02
    LD H,(IY+$03)                         ; $C9E6 fd 66 03
    PUSH IY                               ; $C9E9 fd e5
    CALL $CB34                            ; $C9EB cd 34 cb | La chiamata predicato passaCB34 anche se ritornerà falso. Non condizionare la pubblicazione a successo.
    POP IY                                ; $C9EE fd e1
    JR Z,$C9D1                            ; $C9F0 28 df
    LD A,($A00B)                          ; $C9F2 3a 0b a0
    AND A                                 ; $C9F5 a7
    JR NZ,$C9FB                           ; $C9F6 20 03
    OR $01                                ; $C9F8 f6 01
    RET                                   ; $C9FA c9
    PUSH IY                               ; $C9FB fd e5
    LD A,(IY+$01)                         ; $C9FD fd 7e 01
    RRCA                                  ; $CA00 0f
    RRCA                                  ; $CA01 0f
    RRCA                                  ; $CA02 0f
    RRCA                                  ; $CA03 0f
    AND $0F                               ; $CA04 e6 0f
    LD L,A                                ; $CA06 6f
    LD H,$00                              ; $CA07 26 00
    LD ($A01F),HL                         ; $CA09 22 1f a0
    POP HL                                ; $CA0C e1
    LD DE,$0002                           ; $CA0D 11 02 00
    ADD HL,DE                             ; $CA10 19
    BIT 6,(IY+$00)                        ; $CA11 fd cb 00 76
    JR Z,$CA18                            ; $CA15 28 01
    ADD HL,DE                             ; $CA17 19
    LD DE,$0005                           ; $CA18 11 05 00
    BIT 4,(IY+$00)                        ; $CA1B fd cb 00 66
    JR Z,$CA22                            ; $CA1F 28 01
    ADD HL,DE                             ; $CA21 19
    LD A,($A00A)                          ; $CA22 3a 0a a0
    LD ($C491),A                          ; $CA25 32 91 c4
    LD IX,($A013)                         ; $CA28 dd 2a 13 a0
    LD A,(IX+$0F)                         ; $CA2C dd 7e 0f
    LD ($C492),A                          ; $CA2F 32 92 c4
    PUSH HL                               ; $CA32 e5
    PUSH IY                               ; $CA33 fd e5
    LD A,$01                              ; $CA35 3e 01
    LD ($A00C),A                          ; $CA37 32 0c a0
    CALL $CA76                            ; $CA3A cd 76 ca
    POP IY                                ; $CA3D fd e1
    POP HL                                ; $CA3F e1
    BIT 7,(IY+$00)                        ; $CA40 fd cb 00 7e | Bit7: il corpo viene differito, senza CB2C. L’eventuale risultato del predicato rimane.
    JR Z,$CA48                            ; $CA44 28 02
    SCF                                   ; $CA46 37
    RET                                   ; $CA47 c9
    LD A,($9FD7)                          ; $CA48 3a d7 9f
    INC A                                 ; $CA4B 3c
    JR NZ,$CA54                           ; $CA4C 20 06
    LD A,($A034)                          ; $CA4E 3a 34 a0
    LD ($9FD7),A                          ; $CA51 32 d7 9f
    LD A,($9FD8)                          ; $CA54 3a d8 9f
    INC A                                 ; $CA57 3c
    JR NZ,$CA60                           ; $CA58 20 06
    LD A,($A035)                          ; $CA5A 3a 35 a0
    LD ($9FD8),A                          ; $CA5D 32 d8 9f
    XOR A                                 ; $CA60 af
    LD ($CAAE),A                          ; $CA61 32 ae ca
    CALL $CB2C                            ; $CA64 cd 2c cb | Corpo immediato viaCB2C; DD65 conserva entrambi i puntatori e legge la direzione dal record selezionato.
    PUSH AF                               ; $CA67 f5
    PUSH HL                               ; $CA68 e5
    CALL $CA7F                            ; $CA69 cd 7f ca
    LD A,($CAAE)                          ; $CA6C 3a ae ca
    AND A                                 ; $CA6F a7
    CALL Z,$CAAF                          ; $CA70 cc af ca
    POP HL                                ; $CA73 e1
    POP AF                                ; $CA74 f1
    RET                                   ; $CA75 c9

    ORG $D206
; CODE: Iteratore delle uscite: avanza di tre byte e lascia il terminatore
    EXX                                   ; $D206 d9 | Iteratore a passi3. Il chiamante parte da room.start+6: prima iterazione torna room.start+9.
    LD DE,$0003                           ; $D207 11 03 00
    ADD IX,DE                             ; $D20A dd 19
    LD D,(IX+$02)                         ; $D20C dd 56 02
    LD E,(IX+$01)                         ; $D20F dd 5e 01
    PUSH DE                               ; $D212 d5
    POP IY                                ; $D213 fd e1
    LD A,(IX+$00)                         ; $D215 dd 7e 00 | Il primo byte è direzione, oppureFF. Anche in caso di terminazione IX rimane sul recordFF.
    CP $FF                                ; $D218 fe ff
    EXX                                   ; $D21A d9
    RET                                   ; $D21B c9

    ORG $D33C
; CODE: Stanza dell’attore dal descrittore A017
    PUSH AF                               ; $D33C f5
    LD IX,($A017)                         ; $D33D dd 2a 17 a0 | Seleziona il descrittore dell’attore corrente, non quello del destinatario dell’uscita.
    LD A,(IX+$0F)                         ; $D341 dd 7e 0f
    CALL $D224                            ; $D344 cd 24 d2 | D224 risale i contenitori e restituisce il record stanza; non supporre che la stanza sia sempre direttamente sull’attore.
    POP AF                                ; $D347 f1
    RET                                   ; $D348 c9

    ORG $D46C
; CODE: Ricerca prima uscita per cancello o destinazione: conserva IY
    PUSH AF                               ; $D46C f5 | Ingresso per cancello: offset1. DD6E usa inveceD471, offset2 destinazione.
    LD A,$01                              ; $D46D 3e 01
    JR $D474                              ; $D46F 18 03
    PUSH AF                               ; $D471 f5 | Ingresso usato daDD6E: cerca la prima uscita la cui destinazione coincide conA034.
    LD A,$02                              ; $D472 3e 02
    LD ($D48D),A                          ; $D474 32 8d d4 | Selezione del campo tramite l’operando mutabileD48D; non è un nuovo record dati.
    POP AF                                ; $D477 f1
    PUSH BC                               ; $D478 c5
    PUSH IY                               ; $D479 fd e5 | Salva IY prima dell’iteratore che lo modifica.
    LD B,A                                ; $D47B 47
    PUSH DE                               ; $D47C d5
    CALL $D33C                            ; $D47D cd 3c d3
    LD DE,$0006                           ; $D480 11 06 00 | Sei byte prima della prima uscita; D206 aggiunge3 prima di leggere.
    ADD IX,DE                             ; $D483 dd 19
    POP DE                                ; $D485 d1
    CALL $D206                            ; $D486 cd 06 d2 | Il primo record corrispondente vince. Non saltare quello con direzione11 o12 per cercarne uno successivo valido.
    JR Z,$D491                            ; $D489 28 06
    LD A,(IX+$02)                         ; $D48B dd 7e 02
    CP B                                  ; $D48E b8
    JR NZ,$D486                           ; $D48F 20 f5
    POP IY                                ; $D491 fd e1 | Ripristina IY anche se la lista termina senza corrispondenza.
    POP BC                                ; $D493 c1
    RET                                   ; $D494 c9

    ORG $DD61
; DATA: Intestazione location.exitDirection: classi e predicato
    DEFB $64,$00,$6E,$DD                  ; $DD61 64 00 6e dd | Quattro byte di intestazione, non istruzioni. IY=DD61 al predicato indipendentemente dai risultati entranti.

    ORG $DD65
; CODE: Direzione dalla prima uscita: ritorno del record anche su fallimento
    LD A,(IX+$00)                         ; $DD65 dd 7e 00 | Corpo: scrive il byte direzione nel secondo argomento di lavoro; non cambia IX/IY.
    LD ($9FD7),A                          ; $DD68 32 d7 9f
    OR $01                                ; $DD6B f6 01
    RET                                   ; $DD6D c9
    LD A,($A034)                          ; $DD6E 3a 34 a0 | A034 contiene la destinazione cercata; D471 cerca nella stanza dell’attore.
    CALL $D471                            ; $DD71 cd 71 d4
    CP $FF                                ; $DD74 fe ff
    JP Z,$DC15                            ; $DD76 ca 15 dc | Nessuna uscita: fallimentoDC15, IX resta sul terminatore e viene comunque pubblicato daCB37.
    LD A,(IX+$00)                         ; $DD79 dd 7e 00
    CP $0B                                ; $DD7C fe 0b
    JP NC,$DC15                           ; $DD7E d2 15 dc | Direzione>=11: fallimento sul PRIMO record trovato. Non filtrare prima la lista per direzioni valide.
    OR $01                                ; $DD81 f6 01 | Accetta i valori inferiori11, compreso0. OR1 produce successo senza modificare il record.
    RET                                   ; $DD83 c9

    ORG $C4E8
; CODE: Preflight delle azioni: rifiuti senza entrare nel ponte
    XOR A                                 ; $C4E8 af
    LD ($A00B),A                          ; $C4E9 32 0b a0 | A00B=0: preparazione, non esecuzione del callback.
    LD A,($A01D)                          ; $C4EC 3a 1d a0
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
    RET Z                                 ; $C524 c8 | Ricerca argomenti esaurita: ritorno prima diCB34, nessuna cancellazione dei risultati.
    LD ($A034),A                          ; $C525 32 34 a0
    PUSH BC                               ; $C528 c5
    CALL $C55A                            ; $C529 cd 5a c5
    POP BC                                ; $C52C c1
    JR NZ,$C53A                           ; $C52D 20 0b
    JR $C520                              ; $C52F 18 ef
    CALL $C542                            ; $C531 cd 42 c5
    JR Z,$C53A                            ; $C534 28 04
    CALL $C560                            ; $C536 cd 60 c5
    RET Z                                 ; $C539 c8 | Altro ritorno preflight senza writer. Il modello conserva le word soltanto quando il rifiuto è dimostrato anteriore al ponte.
    LD A,$01                              ; $C53A 3e 01
    LD ($A00B),A                          ; $C53C 32 0b a0
    JP $C929                              ; $C53F c3 29 c9 | La selezione concreta prosegueC929. Questo dossier non completa i risultati di tutti i suoi callback.
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
