; ROM fuori dall’atlante del payload; provenienza dell’inizializzazione, non dati catturati.

    ORG $0000
; CODE: Reset freddo: A=0, DE=FFFF
    DI                                    ; $0000 f3
    XOR A                                 ; $0001 af | Cold start: XOR A. Il riavvio caldo ha un percorso differente e non è il profilo certificato.
    LD DE,$FFFF                           ; $0002 11 ff ff
    JP $11CB                              ; $0005 c3 cb 11

    ORG $11CB
; CODE: RAM test: riempimento con 2 e doppio decremento a zero
    LD B,A                                ; $11CB 47
    LD A,$07                              ; $11CC 3e 07
    OUT ($FE),A                           ; $11CE d3 fe
    LD A,$3F                              ; $11D0 3e 3f
    LD I,A                                ; $11D2 ed 47
    NOP                                   ; $11D4 00
    NOP                                   ; $11D5 00
    NOP                                   ; $11D6 00
    NOP                                   ; $11D7 00
    NOP                                   ; $11D8 00
    NOP                                   ; $11D9 00
    LD H,D                                ; $11DA 62
    LD L,E                                ; $11DB 6b
    LD (HL),$02                           ; $11DC 36 02 | Riempie la RAM da FFFF a 4000 con due.
    DEC HL                                ; $11DE 2b
    CP H                                  ; $11DF bc
    JR NZ,$11DC                           ; $11E0 20 fa
    AND A                                 ; $11E2 a7
    SBC HL,DE                             ; $11E3 ed 52
    ADD HL,DE                             ; $11E5 19
    INC HL                                ; $11E6 23
    JR NC,$11EF                           ; $11E7 30 06
    DEC (HL)                              ; $11E9 35 | Primo decremento: 2 diventa 1 nella RAM funzionante.
    JR Z,$11EF                            ; $11EA 28 03
    DEC (HL)                              ; $11EC 35 | Secondo decremento: 1 diventa 0, poi procede alla cella successiva.
    JR Z,$11E2                            ; $11ED 28 f3
    DEC HL                                ; $11EF 2b

    ORG $127C
; CODE: Copia solo 14 byte della mappa stream; conserva la coda zero
    LD HL,$15C6                           ; $127C 21 c6 15
    LD DE,$5C10                           ; $127F 11 10 5c
    LD BC,$000E                           ; $1282 01 0e 00 | Copia di 14 byte: 5C10–5C1D. Nessun OPEN # nel loader BASIC prima di USR, quindi 5C1E–5C35 restano zero.
    LDIR                                  ; $1285 ed b0
