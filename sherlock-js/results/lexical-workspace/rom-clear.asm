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

    ORG $0B6E
; CODE: BASIC: stato del canale associato all’ultimo output
    RES 0,(HL)                            ; $0B6E cb 86
    CP $20                                ; $0B70 fe 20
    JR NZ,$0B76                           ; $0B72 20 02
    SET 0,(HL)                            ; $0B74 cb c6 | Imposta il bit 0 dei flag con l’ultimo canale di output del loader.

    ORG $26C3
; CODE: BASIC: selezione della valutazione numerica di USR
    SET 6,(IY+$01)                        ; $26C3 fd cb 01 f6 | Imposta il bit 6 nella valutazione numerica che precede USR. Con run e output, FLAGS diventa CD.

    ORG $1212
; CODE: BASIC: RASP, PIP, CHARS ed ERR-SP
    LD BC,$0040                           ; $1212 01 40 00
    LD ($5C38),BC                         ; $1215 ed 43 38 5c | BC=0040 inizializza RASP e PIP come un’unica word.
    LD ($5CB2),HL                         ; $1219 22 b2 5c
    LD HL,$3C00                           ; $121C 21 00 3c
    LD ($5C36),HL                         ; $121F 22 36 5c | CHARS riceve 3C00.
    LD HL,($5CB2)                         ; $1222 2a b2 5c
    LD (HL),$3E                           ; $1225 36 3e
    DEC HL                                ; $1227 2b
    LD SP,HL                              ; $1228 f9
    DEC HL                                ; $1229 2b
    DEC HL                                ; $122A 2b
    LD ($5C3D),HL                         ; $122B 22 3d 5c | ERR-SP è RAMTOP meno tre. Profilo 48K FF57 → FF54.

    ORG $12F4
; CODE: BASIC: ERR-NR prima dell’esecuzione
    SET 7,(IY+$01)                        ; $12F4 fd cb 01 fe
    LD (IY+$00),$FF                       ; $12F8 fd 36 00 ff | ERR-NR FF prima dell’esecuzione del comando BASIC.

    ORG $127C
; CODE: Copia solo 14 byte della mappa stream; conserva la coda zero
    LD HL,$15C6                           ; $127C 21 c6 15
    LD DE,$5C10                           ; $127F 11 10 5c
    LD BC,$000E                           ; $1282 01 0e 00 | Copia di 14 byte: 5C10–5C1D. Nessun OPEN # nel loader BASIC prima di USR, quindi 5C1E–5C35 restano zero.
    LDIR                                  ; $1285 ed b0
