; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.

    ORG $A9DF
; CODE: Scarico della parola e separatore del nome
    PUSH DE                              ; $A9DF d5 | La parola viene scaricata nel contesto del suo chiamante: non ricavare la profondità dal solo testo visibile.
    LD DE,$5C0B                          ; $A9E0 11 0b 5c
    AND A                                ; $A9E3 a7
    SBC HL,DE                            ; $A9E4 ed 52
    JR Z,$AA0B                           ; $A9E6 28 23
    LD A,($C1F5)                         ; $A9E8 3a f5 c1
    CP L                                 ; $A9EB bd
    PUSH AF                              ; $A9EC f5
    JR NC,$A9F4                          ; $A9ED 30 05
    LD A,$0D                             ; $A9EF 3e 0d
    CALL $AA14                           ; $A9F1 cd 14 aa
    PUSH BC                              ; $A9F4 c5
    LD B,L                               ; $A9F5 45 | B contiene i caratteri rimanenti della parola. Il B della scansione in C39C è un altro conteggio.
    LD HL,$5C0B                          ; $A9F6 21 0b 5c
    LD ($A9B5),HL                        ; $A9F9 22 b5 a9
    LD A,(HL)                            ; $A9FC 7e
    CALL $AA14                           ; $A9FD cd 14 aa
    INC HL                               ; $AA00 23
    DJNZ $A9FC                           ; $AA01 10 f9
    POP BC                               ; $AA03 c1
    POP AF                               ; $AA04 f1
    JR NZ,$AA0B                          ; $AA05 20 04
    XOR A                                ; $AA07 af
    LD ($A025),A                         ; $AA08 32 25 a0
    POP DE                               ; $AA0B d1
    POP HL                               ; $AA0C e1
    POP AF                               ; $AA0D f1
    JR $AA14                             ; $AA0E 18 04

    ORG $C388
; CODE: Glifo: shift e contatore salvati dallo spazio del nome portato
    PUSH AF                              ; $C388 f5 | LOOK a Portman Street: lo spazio fra daily e chronicle entra con SP5D26, colonna18, descrittore51AB. Ultimo oggetto portato da Watson, nel formatter D3D5.
    PUSH BC                              ; $C389 c5
    PUSH DE                              ; $C38A d5
    PUSH HL                              ; $C38B e5
    LD L,A                               ; $C38C 6f
    LD H,$00                             ; $C38D 26 00
    ADD HL,HL                            ; $C38F 29
    ADD HL,HL                            ; $C390 29
    ADD HL,HL                            ; $C391 29
    LD DE,$3C00                          ; $C392 11 00 3c
    ADD HL,DE                            ; $C395 19
    EX DE,HL                             ; $C396 eb
    POP HL                               ; $C397 e1
    PUSH HL                              ; $C398 e5
    LD B,$08                             ; $C399 06 08
    LD A,(DE)                            ; $C39B 1a
    PUSH BC                              ; $C39C c5 | Salva BC dell’ottava scansione: C=(2+7*colonna)&7 a5D1C e B=1 a5D1D. A colonna18 C=0: questo PUSH resta l’ultimo writer.
    PUSH AF                              ; $C39D f5 | Il font e F sono distinti dai due byte BC. Il contratto del separatore non attribuisce automaticamente AF a1A–1B.
    DEC C                                ; $C39E 0d
    INC C                                ; $C39F 0c
    LD B,$FF                             ; $C3A0 06 ff
    JR Z,$C3AB                           ; $C3A2 28 07
    SRL A                                ; $C3A4 cb 3f
    SRL B                                ; $C3A6 cb 38
    DEC C                                ; $C3A8 0d
    JR NZ,$C3A4                          ; $C3A9 20 f9
    LD C,A                               ; $C3AB 4f
    LD A,B                               ; $C3AC 78
    CPL                                  ; $C3AD 2f
    AND (HL)                             ; $C3AE a6
    OR C                                 ; $C3AF b1
    LD (HL),A                            ; $C3B0 77
    POP AF                               ; $C3B1 f1
    POP BC                               ; $C3B2 c1
    DEC C                                ; $C3B3 0d
    INC C                                ; $C3B4 0c
    JR Z,$C3D0                           ; $C3B5 28 19
    PUSH BC                              ; $C3B7 c5 | Con shift diverso da zero ripete il salvataggio BC. Nessun valore fisso prelevato dalla traccia nel motore.
    PUSH AF                              ; $C3B8 f5
    LD A,$08                             ; $C3B9 3e 08
    SUB C                                ; $C3BB 91
    LD C,A                               ; $C3BC 4f
    POP AF                               ; $C3BD f1
    LD B,$FF                             ; $C3BE 06 ff
    SLA A                                ; $C3C0 cb 27
    SLA B                                ; $C3C2 cb 20
    DEC C                                ; $C3C4 0d
    JR NZ,$C3C0                          ; $C3C5 20 f9
    LD C,A                               ; $C3C7 4f
    LD A,B                               ; $C3C8 78
    CPL                                  ; $C3C9 2f
    INC HL                               ; $C3CA 23
    AND (HL)                             ; $C3CB a6
    OR C                                 ; $C3CC b1
    LD (HL),A                            ; $C3CD 77
    DEC HL                               ; $C3CE 2b
    POP BC                               ; $C3CF c1
    INC DE                               ; $C3D0 13
    INC H                                ; $C3D1 24
    DJNZ $C39B                           ; $C3D2 10 c7
    POP HL                               ; $C3D4 e1
    POP DE                               ; $C3D5 d1
    POP BC                               ; $C3D6 c1
    LD A,C                               ; $C3D7 79
    ADD A,$07                            ; $C3D8 c6 07
    CP $08                               ; $C3DA fe 08
    JR C,$C3E1                           ; $C3DC 38 03
    SUB $08                              ; $C3DE d6 08
    INC L                                ; $C3E0 2c
    LD C,A                               ; $C3E1 4f
    POP AF                               ; $C3E2 f1
    RET                                  ; $C3E3 c9

    ORG $CA76
; CODE: Annuncio ordinario: soppressione e chiamata al formatter
    LD A,($A033)                         ; $CA76 3a 33 a0 | I chiamanti reali osservati hanno frame diversi: anonimo5D6A, chiusura visibile5D6C, spostamento5D68. Non uniformare i loro residui.
    AND $80                              ; $CA79 e6 80
    CALL Z,$A2E4                         ; $CA7B cc e4 a2
    RET                                  ; $CA7E c9

    ORG $CAAF
; CODE: Arrivo e porta condivisa: soggetto anonimo temporaneo
    CALL $DC6C                           ; $CAAF cd 6c dc | DC6C esclude le tre identità giocabili 0/1/100: queste notifiche riguardano gli altri attori.
    RET Z                                ; $CAB2 c8
    LD A,($C491)                         ; $CAB3 3a 91 c4 | C491 conserva la locazione precedente: se l’attore era già nella stanza di Holmes, l’annuncio ordinario è già stato gestito.
    LD HL,$A009                          ; $CAB6 21 09 a0
    CP (HL)                              ; $CAB9 be
    RET Z                                ; $CABA c8
    LD A,($A036)                         ; $CABB 3a 36 a0
    CALL $D495                           ; $CABE cd 95 d4 | D495 restituisce la sola locazione diretta del record, oppure FF se la lista non è singola. Non scambiare questa chiamata con un percorso nel grafo.
    LD HL,$A009                          ; $CAC1 21 09 a0
    CP (HL)                              ; $CAC4 be
    JR NZ,$CAD0                          ; $CAC5 20 09
    LD A,($A036)                         ; $CAC7 3a 36 a0
    LD DE,$68ED                          ; $CACA 11 ed 68
    CALL $CBC2                           ; $CACD cd c2 cb | Solo il nuovo valore uguale alla stanza A009 dell’osservatore invoca CBC2 con il frammento68ED.
    LD A,($A00F)                         ; $CAD0 3a 0f a0 | La classe di ricerca del primo argomento A00F deve essere almeno7 per proseguire verso la notifica dell’oggetto. Le classi inferiori ritornano.
    CP $07                               ; $CAD3 fe 07
    RET C                                ; $CAD5 d8
    LD A,($A034)                         ; $CAD6 3a 34 a0
    CALL $D495                           ; $CAD9 cd 95 d4 | D495 carica IX del primo argomento. FF qui distingue il record con lista di locazioni non singola; CAE0 ne leggerà il conteggio.
    CP $FF                               ; $CADC fe ff
    JR NZ,$CB12                          ; $CADE 20 32
    LD B,(IX+$00)                        ; $CAE0 dd 46 00 | B è il numero di locazioni dell’oggetto. Il ciclo visita IX+0F e avanza IX fino a trovare la stanza di Holmes.
    LD A,($A009)                         ; $CAE3 3a 09 a0
    CP (IX+$0F)                          ; $CAE6 dd be 0f
    JR Z,$CAF0                           ; $CAE9 28 05
    INC IX                               ; $CAEB dd 23
    DJNZ $CAE6                           ; $CAED 10 f7
    RET                                  ; $CAEF c9 | Nessuna locazione uguale a quella dell’osservatore: ritorno senza annuncio anonimo.
    LD A,($A036)                         ; $CAF0 3a 36 a0 | Il soggetto invisibile viene temporaneamente sostituito da FF; CB01 richiede comunque l’adiacenza corretta.
    LD B,A                               ; $CAF3 47
    LD A,$FF                             ; $CAF4 3e ff
    LD ($A036),A                         ; $CAF6 32 36 a0
    LD A,$01                             ; $CAF9 3e 01
    LD ($5C3C),A                         ; $CAFB 32 3c 5c
    LD A,($A009)                         ; $CAFE 3a 09 a0
    CALL $D471                           ; $CB01 cd 71 d4
    CP $FF                               ; $CB04 fe ff
    CALL NZ,$CA76                        ; $CB06 c4 76 ca | L’annuncio anonimo di apertura ha glifi non più profondi di5D2A; sul caso osservato il minimo è5D1E. I byte1A–1D non sono toccati.
    SUB A                                ; $CB09 97
    LD ($5C3C),A                         ; $CB0A 32 3c 5c
    LD A,B                               ; $CB0D 78
    LD ($A036),A                         ; $CB0E 32 36 a0
    RET                                  ; $CB11 c9

    ORG $CBC2
; CODE: Notifica di arrivo nel contesto dell’osservatore
    CP $FF                               ; $CBC2 fe ff | L’ingresso reale di Tricia ha SP5D6A e primo qualificatore a5D2C. Un wrap su riga parziale può invece raggiungere1A–1D.
    RET Z                                ; $CBC4 c8
    AND A                                ; $CBC5 a7
    RET Z                                ; $CBC6 c8
    LD B,A                               ; $CBC7 47
    CALL $D495                           ; $CBC8 cd 95 d4
    LD C,A                               ; $CBCB 4f
    LD A,($A009)                         ; $CBCC 3a 09 a0
    CP C                                 ; $CBCF b9
    RET NZ                               ; $CBD0 c0
    LD A,$01                             ; $CBD1 3e 01
    LD ($5C3C),A                         ; $CBD3 32 3c 5c
    PUSH DE                              ; $CBD6 d5
    LD A,B                               ; $CBD7 78
    CALL $D237                           ; $CBD8 cd 37 d2
    LD A,(IX+$01)                        ; $CBDB dd 7e 01
    CP $FF                               ; $CBDE fe ff
    JR Z,$CBE5                           ; $CBE0 28 03
    LD B,A                               ; $CBE2 47
    JR $CBD7                             ; $CBE3 18 f2
    LD A,B                               ; $CBE5 78
    CALL $A4BC                           ; $CBE6 cd bc a4
    EX (SP),HL                           ; $CBE9 e3
    LD A,($A036)                         ; $CBEA 3a 36 a0
    PUSH AF                              ; $CBED f5
    LD A,($9860)                         ; $CBEE 3a 60 98
    LD ($A036),A                         ; $CBF1 32 36 a0
    CALL $CC29                           ; $CBF4 cd 29 cc
    LD A,B                               ; $CBF7 78
    CALL $C821                           ; $CBF8 cd 21 c8
    JR NZ,$CC00                          ; $CBFB 20 03
    POP AF                               ; $CBFD f1
    POP HL                               ; $CBFE e1
    RET                                  ; $CBFF c9
    POP AF                               ; $CC00 f1
    LD ($A036),A                         ; $CC01 32 36 a0
    CALL $CC29                           ; $CC04 cd 29 cc
    CALL $A59F                           ; $CC07 cd 9f a5 | Stampa il frammento di arrivo dopo aver ristabilito il contesto. Non dedurre la profondità di ogni glifo da quella del prefisso.
    RET                                  ; $CC0A c9
