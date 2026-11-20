; Sherlock (1984), rifiuti di movimento e scansione WEAR.
; Estratti selezionati dalle fonti primarie; byte verificati dal builder dell’atlante.
; Compositore dell’azione: azzera A028 e seleziona il modello corrente.
    XOR A                        ; $A37D AF
    LD ($A028),A                 ; $A37E 32 28 A0
    LD A,($A35D)                 ; $A381 3A 5D A3
    CALL $A2B1                   ; $A384 CD B1 A2
    PUSH HL                      ; $A387 E5
    POP IX                       ; $A388 DD E1
    PUSH HL                      ; $A38A E5
    CALL $A2BD                   ; $A38B CD BD A2
    CALL $C493                   ; $A38E CD 93 C4
    CALL $C4B2                   ; $A391 CD B2 C4
    POP HL                       ; $A394 E1
    LD A,($A01D)                 ; $A395 3A 1D A0
    LD C,A                       ; $A398 4F
    PUSH HL                      ; $A399 E5
    LD DE,$0006                  ; $A39A 11 06 00
    ADD HL,DE                    ; $A39D 19
; Emette prima il modificatore, go per i dieci movimenti diretti.
    CALL $A880                   ; $A39E CD 80 A8
    POP HL                       ; $A3A1 E1
; Emette poi la direzione: nei rifiuti senza argomenti è l’ultimo descrittore.
    CALL $A880                   ; $A3A2 CD 80 A8
    BIT 3,C                      ; $A3A5 CB 59
    JR Z,$A3E2                   ; $A3A7 28 39
    BIT 5,C                      ; $A3A9 CB 69
; Secondo argomento assente o non previsto: passa al terminatore A414 senza una nuova parola.
    LD A,($A35F)                 ; $A3E2 3A 5F A3
    CP $FF                       ; $A3E5 FE FF
    JR Z,$A414                   ; $A3E7 28 2B
    BIT 2,C                      ; $A3E9 CB 51
    JR Z,$A414                   ; $A3EB 28 27
; Carica il riferimento dal modello e maschera il nibble alto di contesto.
    LD E,(HL)                    ; $A880 5E
    INC HL                       ; $A881 23
    LD A,(HL)                    ; $A882 7E
    INC HL                       ; $A883 23
    AND $0F                      ; $A884 E6 0F
    LD D,A                       ; $A886 57
    LD A,($5C3C)                 ; $A887 3A 3C 5C
    AND A                        ; $A88A A7
    RET Z                        ; $A88B C8
; Scrive A022 anche se l’offset è zero, purché il canale sia abilitato.
    LD ($A022),DE                ; $A88C ED 53 22 A0
    LD A,D                       ; $A890 7A
    AND $0F                      ; $A891 E6 0F
    OR E                         ; $A893 B3
    RET Z                        ; $A894 C8
    PUSH IX                      ; $A895 DD E5
    PUSH HL                      ; $A897 E5
    PUSH BC                      ; $A898 C5
    LD A,D                       ; $A8AC 7A
    AND $0F                      ; $A8AD E6 0F
    LD D,A                       ; $A8AF 57
    EX DE,HL                     ; $A8B0 EB
    PUSH HL                      ; $A8B1 E5
    LD A,H                       ; $A8B2 7C
    OR C                         ; $A8B3 B1
    LD H,A                       ; $A8B4 67
; Memorizza offset e contesto ricombinati. Ultimo SW della variante: 0827 al tick2293.
    LD ($A022),HL                ; $A8B5 22 22 A0
    POP HL                       ; $A8B8 E1
; WEAR: articolo e qualificatori usano frame5D2C; sono distinti dal verbo a5D2A.
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
; Salva BC anche nel percorso con shift zero; le otto scansioni decrementaranno B.
    PUSH BC                      ; $C39C C5
    PUSH AF                      ; $C39D F5
; WEAR mans: salva BC=0104 in5D22–23 nell’ottava scansione della s, tick2286.
    PUSH BC                      ; $C3B7 C5
; Salva separatamente AF in5D20–21; HL video salvato più sopra occupa5D24–25.
    PUSH AF                      ; $C3B8 F5
    LD A,$08                     ; $C3B9 3E 08
