; Sherlock1984: AF dell’uscita dai contenitori e chiamanti di conservazione.
; Ingresso dell’annuncio ordinario. La traccia di uscita usa SP5D6C per giocatore e Watson.
    LD A,($A033)                 ; $CA76 3A 33 A0
    AND $80                      ; $CA79 E6 80
    CALL Z,$A2E4                 ; $CA7B CC E4 A2
    RET                          ; $CA7E C9
    LD A,($A00F)                 ; $A3D6 3A 0F A0
    CP $05                       ; $A3D9 FE 05
    LD A,($A35E)                 ; $A3DB 3A 5E A3
; Passa il primo argomento al formatter dei nomi: articolo e qualificatore si scaricano aC388/SP5D2C.
    CALL $A745                   ; $A3DE CD 45 A7
    POP HL                       ; $A3E1 E1
; Descrizione breve: salta il chiamante profondo della descrizione completa. Conservazione AF misurata entro i limiti del dossier.
    LD B,A                       ; $D1B2 47
    CALL $D0DD                   ; $D1B3 CD DD D0
    EX DE,HL                     ; $D1B6 EB
    CALL $D187                   ; $D1B7 CD 87 D1
    CALL $D078                   ; $D1BA CD 78 D0
    JR NC,$D178                  ; $D1BD 30 B9
    LD HL,$68C1                  ; $D1BF 21 C1 68
    CALL $A59F                   ; $D1C2 CD 9F A5
    RET                          ; $D1C5 C9
    LD A,B                       ; $D178 78
; Dopo l’introduzione breve, le uscite sono enumerate dal chiamante più superficiale.
    CALL $D68C                   ; $D179 CD 8C D6
    CALL $D4A7                   ; $D17C CD A7 D4
    JP $A2A2                     ; $D17F C3 A2 A2
; PUSH AF del chiamante: A è il codice carattere; è distinto dall’AF della scansione finale.
    PUSH AF                      ; $C388 F5
    PUSH BC                      ; $C389 C5
    PUSH DE                      ; $C38A D5
    PUSH HL                      ; $C38B E5
    LD L,A                       ; $C38C 6F
    LD H,$00                     ; $C38D 26 00
    ADD HL,HL                    ; $C38F 29
    ADD HL,HL                    ; $C390 29
    ADD HL,HL                    ; $C391 29
    LD DE,$3C00                  ; $C392 11 00 3C
    ADD HL,DE                    ; $C395 19
    EX DE,HL                     ; $C396 EB
    POP HL                       ; $C397 E1
    PUSH HL                      ; $C398 E5
    LD B,$08                     ; $C399 06 08
    LD A,(DE)                    ; $C39B 1A
    PUSH BC                      ; $C39C C5
    PUSH AF                      ; $C39D F5
    PUSH BC                      ; $C3B7 C5
; PUSH AF di scansione: con frame5D2C scrive F in5D20 e l’ultima riga font A in5D21.
    PUSH AF                      ; $C3B8 F5
    LD A,$08                     ; $C3B9 3E 08
