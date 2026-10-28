; ROM: copia di dati di inizializzazione; nessuna esecuzione nel motore JS.

    ORG $127C
; CODE: Copia 14 byte da 15C6 a 5C10 prima del gioco
    LD HL,$15C6                           ; $127C 21 c6 15
    LD DE,$5C10                           ; $127F 11 10 5c
    LD BC,$000E                           ; $1282 01 0e 00
    LDIR                                  ; $1285 ed b0

    ORG $15C6
; DATA: Mappa iniziale degli stream, successivamente riutilizzata dal buffer di parola
    DEFB $01,$00,$06,$00,$0B,$00,$01,$00  ; $15C6 01 00 06 00 0b 00 01 00
    DEFB $01,$00,$06,$00,$10,$00          ; $15CE 01 00 06 00 10 00
