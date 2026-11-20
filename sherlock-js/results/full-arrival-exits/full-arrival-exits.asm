; Sherlock1984: elenco uscite e provenienza tipizzata dei registri.
    LD L,(IX+$07)                ; $D16B DD 6E 07
    LD H,(IX+$08)                ; $D16E DD 66 08
    CALL $D182                   ; $D171 CD 82 D1
    LD A,B                       ; $D174 78
    CALL $D60B                   ; $D175 CD 0B D6
    LD A,B                       ; $D178 78
; Arrivo completo: chiama D68C aSP5D5E nel normale giocatore alla radice.
    CALL $D68C                   ; $D179 CD 8C D6
    CALL $D4A7                   ; $D17C CD A7 D4
    JP $A2A2                     ; $D17F C3 A2 A2
; Salva quattro coppie di registri e enumera le uscite prive di oggetto interposto.
    PUSH IX                      ; $D68C DD E5
    PUSH IY                      ; $D68E FD E5
    PUSH DE                      ; $D690 D5
    PUSH BC                      ; $D691 C5
    CALL $D5EF                   ; $D692 CD EF D5
    CALL $D671                   ; $D695 CD 71 D6
    JR Z,$D6B1                   ; $D698 28 17
; Introduzione compressa 68F1: visible, exits, are.
    LD HL,$68F1                  ; $D69A 21 F1 68
    CALL $A59F                   ; $D69D CD 9F A5
    LD A,(IX+$00)                ; $D6A0 DD 7E 00
    CALL $D5FB                   ; $D6A3 CD FB D5
; Emette la direzione dal dizionario: il separatore scarica la parola precedente.
    CALL $A887                   ; $D6A6 CD 87 A8
    CALL $D671                   ; $D6A9 CD 71 D6
    JR NZ,$D6A0                  ; $D6AC 20 F2
    CALL $A414                   ; $D6AE CD 14 A4
    POP BC                       ; $D6B1 C1
    POP DE                       ; $D6B2 D1
    POP IY                       ; $D6B3 FD E1
    POP IX                       ; $D6B5 DD E1
    RET                          ; $D6B7 C9
; Lunghezza della parola da HL meno5C0B. Il buffer non termina necessariamente con zero.
    PUSH DE                      ; $A9DF D5
    LD DE,$5C0B                  ; $A9E0 11 0B 5C
    AND A                        ; $A9E3 A7
    SBC HL,DE                    ; $A9E4 ED 52
    JR Z,$AA0B                   ; $A9E6 28 23
    LD A,($C1F5)                 ; $A9E8 3A F5 C1
    CP L                         ; $A9EB BD
    PUSH AF                      ; $A9EC F5
    JR NC,$A9F4                  ; $A9ED 30 05
    LD A,$0D                     ; $A9EF 3E 0D
    CALL $AA14                   ; $A9F1 CD 14 AA
    PUSH BC                      ; $A9F4 C5
    LD B,L                       ; $A9F5 45
    LD HL,$5C0B                  ; $A9F6 21 0B 5C
; Ripristina il puntatore ma non cancella i caratteri residui del buffer.
    LD ($A9B5),HL                ; $A9F9 22 B5 A9
    LD A,(HL)                    ; $A9FC 7E
    CALL $AA14                   ; $A9FD CD 14 AA
    INC HL                       ; $AA00 23
    DJNZ $A9FC                   ; $AA01 10 F9
    POP BC                       ; $AA03 C1
    PUSH HL                      ; $C2BA E5
    PUSH BC                      ; $C2BB C5
; Salva AF:731A significa carattere s con flag1A. Non è un indirizzo di testo.
    PUSH AF                      ; $C2BC F5
; Salva nuovamente AF prima della scansione: il tipo del dato viene dal PUSH.
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
; Con frame5D28, C della scansione occupa5D1E; la s di exits lascia7 nella traccia naturale.
    PUSH BC                      ; $C3B7 C5
    PUSH AF                      ; $C3B8 F5
    LD A,$08                     ; $C3B9 3E 08
; DATA: Introduzione compressa delle uscite, seguita dal terminatore senza CR.
    DEFB $20,$46,$B2,$66,$91,$30,$A0,$20,$44,$2E,$13,$49,$80,$78,$1F ; $68F1 20 46 B2 66 91 30 A0 20 44 2E 13 49 80 78 1F
