; Dossier verificato sul payload originale.

    ORG $9CCE
; CODE: Incontri · stanza del parlante e confronto con il destinatario
    LD IX,($A017)                         ; $9CCE dd 2a 17 a0
    LD B,(IX+$0F)                         ; $9CD2 dd 46 0f | B riceve la stanza dell’attore nel record. C contiene il destinatario; C821 preserva BC. Dopo l’ultimo incontro di Straker la coppia può arrivare alla stampa del treno.
    LD A,C                                ; $9CD5 79
    CALL $D237                            ; $9CD6 cd 37 d2
    LD A,(IX+$0F)                         ; $9CD9 dd 7e 0f
    CP B                                  ; $9CDC b8
    RET NZ                                ; $9CDD c0
    LD A,C                                ; $9CDE 79
    CALL $C821                            ; $9CDF cd 21 c8
    JR Z,$9CE6                            ; $9CE2 28 02
    XOR A                                 ; $9CE4 af
    RET                                   ; $9CE5 c9
    OR $01                                ; $9CE6 f6 01
    RET                                   ; $9CE8 c9

    ORG $9D30
; CODE: Straker · incontri con Holmes e Watson
    LD A,($9D90)                          ; $9D30 3a 90 9d
    AND A                                 ; $9D33 a7
    RET Z                                 ; $9D34 c8
    LD HL,$9D2E                           ; $9D35 21 2e 9d
    LD C,$00                              ; $9D38 0e 00
    CALL $9CE9                            ; $9D3A cd e9 9c
    LD HL,$9D2F                           ; $9D3D 21 2f 9d
    LD C,$03                              ; $9D40 0e 03 | C=3 per il secondo incontro, con Watson. Alle 23:54 il treno eredita 3503, con Straker nella locazione 53.
    JP $9CE9                              ; $9D42 c3 e9 9c

    ORG $E4C9
; DATA: Intestazione della regola dei treni
    DEFB $04,$00                          ; $E4C9 04 00

    ORG $E4CB
; CODE: Treno · annuncio prima di cambiare visibilità e stanza
    LD HL,$9C56                           ; $E4CB 21 56 9c
    LD A,($A034)                          ; $E4CE 3a 34 a0
    PUSH AF                               ; $E4D1 f5
    CP $02                                ; $E4D2 fe 02
    JR Z,$E4DE                            ; $E4D4 28 08
    CP $03                                ; $E4D6 fe 03
    JR Z,$E4DE                            ; $E4D8 28 04
    CP $04                                ; $E4DA fe 04
    JR NZ,$E4E7                           ; $E4DC 20 09
    LD HL,$7611                           ; $E4DE 21 11 76
    CALL $A59F                            ; $E4E1 cd 9f a5 | Invoca il formatter con il BC del chiamante. Nel caso fuori scena A9F4 salva ugualmente BC durante lo scarico del punto.
    LD HL,$9C60                           ; $E4E4 21 60 9c
    LD A,($A036)                          ; $E4E7 3a 36 a0
    PUSH AF                               ; $E4EA f5
    CALL $E4FB                            ; $E4EB cd fb e4
    POP AF                                ; $E4EE f1
    POP BC                                ; $E4EF c1
    CALL $DD0E                            ; $E4F0 cd 0e dd
    LD HL,($DCFF)                         ; $E4F3 2a ff dc
    RES 6,(HL)                            ; $E4F6 cb b6
    OR $01                                ; $E4F8 f6 01
    RET                                   ; $E4FA c9

    ORG $9CF2
; CODE: Incontri NPC: pubblicazione del destinatario
    LD A,C                                ; $9CF2 79
    LD ($A034),A                          ; $9CF3 32 34 a0 | Scrive il destinatario A034 prima di controllarne la presenza. Anche un incontro fallito aggiorna il campo.
    CALL $9CCE                            ; $9CF6 cd ce 9c
    JR Z,$9D02                            ; $9CF9 28 07
    DEC (HL)                              ; $9CFB 35
    JP P,$9D00                            ; $9CFC f2 00 9d
    INC (HL)                              ; $9CFF 34
    POP DE                                ; $9D00 d1
    RET                                   ; $9D01 c9
    LD A,(HL)                             ; $9D02 7e
    AND A                                 ; $9D03 a7
    JR NZ,$9D00                           ; $9D04 20 fa
    LD A,$0F                              ; $9D06 3e 0f
    CALL $D2A4                            ; $9D08 cd a4 d2
    ADD A,$1E                             ; $9D0B c6 1e
    LD (HL),A                             ; $9D0D 77
    XOR A                                 ; $9D0E af
    RET                                   ; $9D0F c9

    ORG $9D13
; CODE: Watson verifica tre incontri, poi richiama un ricordo
    LD HL,$9D10                           ; $9D13 21 10 9d
    LD C,$00                              ; $9D16 0e 00
    CALL $9CE9                            ; $9D18 cd e9 9c
    LD HL,$9D11                           ; $9D1B 21 11 9d
    LD C,$02                              ; $9D1E 0e 02
    CALL $9CE9                            ; $9D20 cd e9 9c
    LD HL,$9D12                           ; $9D23 21 12 9d
    LD C,$04                              ; $9D26 0e 04 | Ultimo destinatario di Watson: Straker (4). E691 può leggere A034 prima che la successiva regola lo cambi.
    CALL $9CE9                            ; $9D28 cd e9 9c
    JP $E691                              ; $9D2B c3 91 e6

    ORG $9EC0
; DATA: Daphne · stanza salvata prima del sonno
    DEFB $00                              ; $9EC0 00

    ORG $9EC1
; CODE: Daphne · ingresso del richiamo del sonno
    LD HL,$9EC0                           ; $9EC1 21 c0 9e
    LD C,$80                              ; $9EC4 0e 80
    LD B,$4A                              ; $9EC6 06 4a
    JR $9ED7                              ; $9EC8 18 0d

    ORG $9ECA
; DATA: Giardiniere · stanza salvata prima del sonno
    DEFB $00                              ; $9ECA 00

    ORG $9ECB
; CODE: Giardiniere · ingresso del richiamo del sonno
    LD HL,$9ECA                           ; $9ECB 21 ca 9e
    JR $9ED4                              ; $9ECE 18 04

    ORG $9ED0
; DATA: Cuoca · stanza salvata prima del sonno
    DEFB $00                              ; $9ED0 00

    ORG $9ED1
; CODE: Cuoca e percorso comune del sonno e risveglio
    LD HL,$9ED0                           ; $9ED1 21 d0 9e
    LD BC,$0000                           ; $9ED4 01 00 00 | Imposta BC a zero per giardiniere e cuoca. Il rientro pomeridiano conserva B e C. Domenica alle 17:06 il B del giardiniere arriva alla prima regola della cuoca.
    LD A,(HL)                             ; $9ED7 7e
    AND A                                 ; $9ED8 a7
    JR Z,$9EF2                            ; $9ED9 28 17
    LD B,A                                ; $9EDB 47
    XOR A                                 ; $9EDC af
    LD DE,$0000                           ; $9EDD 11 00 00
    CALL $9F1E                            ; $9EE0 cd 1e 9f
    LD A,($A036)                          ; $9EE3 3a 36 a0
    LD B,C                                ; $9EE6 41
    LD DE,$0000                           ; $9EE7 11 00 00
    CALL $F1C1                            ; $9EEA cd c1 f1
    SET 6,(IX+$05)                        ; $9EED dd cb 05 f6
    RET                                   ; $9EF1 c9
    LD A,($9FE2)                          ; $9EF2 3a e2 9f
    CP $61                                ; $9EF5 fe 61
    RET Z                                 ; $9EF7 c8
    LD A,($9FE0)                          ; $9EF8 3a e0 9f
    CP $09                                ; $9EFB fe 09
    RET NZ                                ; $9EFD c0
    LD DE,$01F8                           ; $9EFE 11 f8 01
    LD A,$1E                              ; $9F01 3e 1e
    CALL $D2A4                            ; $9F03 cd a4 d2
    ADD A,E                               ; $9F06 83
    LD E,A                                ; $9F07 5f
    LD A,($A00A)                          ; $9F08 3a 0a a0
    CALL $9F1E                            ; $9F0B cd 1e 9f
    LD A,($A036)                          ; $9F0E 3a 36 a0
    LD B,$10                              ; $9F11 06 10
    LD DE,$07F0                           ; $9F13 11 f0 07
    CALL $F1C1                            ; $9F16 cd c1 f1
    RES 6,(IX+$05)                        ; $9F19 dd cb 05 b6
    RET                                   ; $9F1D c9

    ORG $D29D
; CODE: Calcolo percentuale · ritorni, IX e BC salvati
    LD A,$63                              ; $D29D 3e 63
    CALL $D2A4                            ; $D29F cd a4 d2
    INC A                                 ; $D2A2 3c
    RET                                   ; $D2A3 c9
    CALL $D2AD                            ; $D2A4 cd ad d2
    BIT 7,A                               ; $D2A7 cb 7f
    RET Z                                 ; $D2A9 c8
    NEG                                   ; $D2AA ed 44
    RET                                   ; $D2AC c9
    PUSH IX                               ; $D2AD dd e5 | Conserva IX del ponte CB28. D2AF conserva BC, con C caricato dall’operando in C688 e B ereditato prima della visita.
    PUSH BC                               ; $D2AF c5

    ORG $9E74
; CODE: Stampa, pausa e chiusura del finale
    LD A,$01                              ; $9E74 3e 01
    LD ($5C3C),A                          ; $9E76 32 3c 5c
    CALL $A59F                            ; $9E79 cd 9f a5
    CALL $C306                            ; $9E7C cd 06 c3 | Pausa dopo il testo terminale. La conferma precede il passaggio alla chiusura B0AC.
    CALL $A296                            ; $9E7F cd 96 a2
    JP $B0AC                              ; $9E82 c3 ac b0

    ORG $A2E4
; CODE: Formatter · salvataggio degli argomenti di azione
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
    LD ($A35E),HL                         ; $A2F9 22 5e a3 | Conserva A034 e A035. Il passaggio della cuoca fuori scena lascia 50 a A35E domenica alle 12:56. WAIT UNTIL scrive FE. CDD0/CDD9/CDE2 usano le stesse celle per l’ordine preformato.
    LD A,($A00C)                          ; $A2FC 3a 0c a0
    LD B,A                                ; $A2FF 47
    AND A                                 ; $A300 a7
    LD A,$01                              ; $A301 3e 01
    JR Z,$A306                            ; $A303 28 01
    XOR A                                 ; $A305 af
    LD ($A027),A                          ; $A306 32 27 a0
    CALL $D078                            ; $A309 cd 78 d0

    ORG $A35D
; DATA: Argomenti di uscita persistenti
    DEFB $00,$00,$00                      ; $A35D 00 00 00

    ORG $CDCD
; CODE: Argomenti degli ordini preformati
    LD A,(IX+$02)                         ; $CDCD dd 7e 02
    LD ($A35D),A                          ; $CDD0 32 5d a3
    LD A,(IX+$03)                         ; $CDD3 dd 7e 03
    CALL $CEDE                            ; $CDD6 cd de ce
    LD ($A35E),A                          ; $CDD9 32 5e a3
    LD A,(IX+$04)                         ; $CDDC dd 7e 04
    CALL $CEDE                            ; $CDDF cd de ce
    LD ($A35F),A                          ; $CDE2 32 5f a3

    ORG $A02D
; DATA: Classe del token precedente
    DEFB $00                              ; $A02D 00 | Classe precedente, salvata da AE86. Il WAIT controllato lascia B0, anche dopo il consumo del delimitatore.

    ORG $A02E
; DATA: Selettore nominale
    DEFB $00                              ; $A02E 00 | Il valore è separato da A02D. B3DA lo inizializza e A4EB lo seleziona in base all’intestazione nominale.

    ORG $A4CD
; CODE: Ricerca e selezione del riferimento nominale
    PUSH DE                               ; $A4CD d5
    PUSH HL                               ; $A4CE e5
    PUSH IY                               ; $A4CF fd e5
    LD DE,$0006                           ; $A4D1 11 06 00
    ADD HL,DE                             ; $A4D4 19
    ADD IY,DE                             ; $A4D5 fd 19
    CALL $A51B                            ; $A4D7 cd 1b a5
    JR NZ,$A516                           ; $A4DA 20 3a
    POP IY                                ; $A4DC fd e1
    POP HL                                ; $A4DE e1
    POP DE                                ; $A4DF d1
    PUSH DE                               ; $A4E0 d5
    PUSH HL                               ; $A4E1 e5
    PUSH IY                               ; $A4E2 fd e5
    CALL $A51B                            ; $A4E4 cd 1b a5
    JR NZ,$A516                           ; $A4E7 20 2d
    LD A,$01                              ; $A4E9 3e 01
    LD ($A02E),A                          ; $A4EB 32 2e a0 | Ultima scrittura del selettore per il WAIT UNTIL dal tick 3781. La cuoca lo legge al tick 4070.
    CALL $A51B                            ; $A4EE cd 1b a5
    JR NZ,$A4FA                           ; $A4F1 20 07
    CALL $A51B                            ; $A4F3 cd 1b a5
    LD A,$00                              ; $A4F6 3e 00
    JR Z,$A516                            ; $A4F8 28 1c
    POP IY                                ; $A4FA fd e1
    POP HL                                ; $A4FC e1
    PUSH HL                               ; $A4FD e5
    PUSH IY                               ; $A4FE fd e5
    LD DE,$0004                           ; $A500 11 04 00
    ADD IY,DE                             ; $A503 fd 19
    INC HL                                ; $A505 23
    INC HL                                ; $A506 23
    CALL $A51B                            ; $A507 cd 1b a5
    JR NZ,$A516                           ; $A50A 20 0a
    LD DE,$FFFC                           ; $A50C 11 fc ff
    ADD IY,DE                             ; $A50F fd 19
    CALL $A51B                            ; $A511 cd 1b a5
    LD A,$01                              ; $A514 3e 01
    POP IY                                ; $A516 fd e1
    POP HL                                ; $A518 e1
    POP DE                                ; $A519 d1
    RET                                   ; $A51A c9
    PUSH HL                               ; $A51B e5
    LD A,(HL)                             ; $A51C 7e
    INC HL                                ; $A51D 23
    OR (HL)                               ; $A51E b6
    JR Z,$A52E                            ; $A51F 28 0d
    LD A,(IY+$01)                         ; $A521 fd 7e 01
    XOR (HL)                              ; $A524 ae
    AND $0F                               ; $A525 e6 0f
    JR NZ,$A52E                           ; $A527 20 05
    DEC HL                                ; $A529 2b
    LD A,(HL)                             ; $A52A 7e
    CP (IY+$00)                           ; $A52B fd be 00
    POP HL                                ; $A52E e1
    INC HL                                ; $A52F 23
    INC HL                                ; $A530 23
    INC IY                                ; $A531 fd 23
    INC IY                                ; $A533 fd 23
    RET                                   ; $A535 c9

    ORG $A038
; DATA: Visibilità dei candidati nella ricerca nominale
    DEFB $00                              ; $A038 00 | Valori 0/1 ricavati da A01D per una ricerca dei referenti. BDF0 scrive 2 quando cerca i referenti di un’affermazione. Una semplice attesa senza ricerca non lo azzera.

    ORG $A03B
; DATA: Contatore di attesa del prossimo tasto
    DEFB $00,$00                          ; $A03B 00 00 | Word little endian per il timeout dell’editor. D89B e A558 caricano 3000. L’ingresso che inietta i tasti sostituisce A536, quindi lascia il contatore pieno.

    ORG $A03D
; DATA: Tre byte prima del punto d’ingresso
    DEFB $04,$40,$58                      ; $A03D 04 40 58 | Tre byte caricati 04 40 58. Il listing non identifica un writer o un lettore funzionale oltre al generatore casuale. La traccia del giardiniere legge 04 venerdì alle 05:44.

    ORG $A55D
; DATA: Tabella del dispatcher del formato di testo
    DEFB $5D,$A6,$6C                      ; $A55D 5d a6 6c | Trentadue indirizzi little endian, uno per token di controllo. A621 indicizza la tabella e A633 chiama il formatter scelto.
    DEFB $A6,$79,$A6                      ; $A560 a6 79 a6
    DEFB $02,$A7,$09                      ; $A563 02 a7 09
    DEFB $A7,$11,$A7                      ; $A566 a7 11 a7
    DEFB $20,$A7,$2C                      ; $A569 20 a7 2c
    DEFB $A7,$36,$A7                      ; $A56C a7 36 a7
    DEFB $3B,$A7,$D3                      ; $A56F 3b a7 d3
    DEFB $A6,$5B,$A7                      ; $A572 a6 5b a7
    DEFB $80,$A7,$3A                      ; $A575 80 a7 3a
    DEFB $A6,$8E,$A7                      ; $A578 a6 8e a7
    DEFB $8C,$A6,$93                      ; $A57B 8c a6 93
    DEFB $A7,$AC,$A7                      ; $A57E a7 ac a7
    DEFB $5C,$A6,$B4                      ; $A581 5c a6 b4
    DEFB $A7,$94,$A6                      ; $A584 a7 94 a6
    DEFB $9C,$A6,$A4                      ; $A587 9c a6 a4
    DEFB $A6,$AC,$A6                      ; $A58A a6 ac a6
    DEFB $60,$A3,$71                      ; $A58D 60 a3 71
    DEFB $A7,$84,$A6                      ; $A590 a7 84 a6
    DEFB $52,$A8,$82                      ; $A593 52 a8 82
    DEFB $A6,$3F,$A6                      ; $A596 a6 3f a6
    DEFB $43,$A6,$5A                      ; $A599 43 a6 5a
    DEFB $A6                              ; $A59C a6

    ORG $B868
; DATA: Puntatore dell’ultima citazione consumata
    DEFB $00,$00                          ; $B868 00 00 | B87A copia il puntatore letto dal primo record della coda prima di rilasciarlo. Una ricerca senza coda non sovrascrive il valore precedente.

    ORG $A536
; CODE: Lettura del tasto e ciclo temporizzato
    PUSH HL                               ; $A536 e5
    LD HL,($A03B)                         ; $A537 2a 3b a0
    CALL $C41F                            ; $A53A cd 1f c4
    BIT 7,A                               ; $A53D cb 7f
    JR NZ,$A553                           ; $A53F 20 12
    LD A,$00                              ; $A541 3e 00
    DEC A                                 ; $A543 3d
    PUSH HL                               ; $A544 e5
    POP HL                                ; $A545 e1
    JR NZ,$A543                           ; $A546 20 fb
    DEC HL                                ; $A548 2b
    LD A,H                                ; $A549 7c
    OR L                                  ; $A54A b5
    JR NZ,$A53A                           ; $A54B 20 ed
    POP HL                                ; $A54D e1
    PUSH HL                               ; $A54E e5
    CALL $D9B7                            ; $A54F cd b7 d9
    XOR A                                 ; $A552 af
    AND $7F                               ; $A553 e6 7f
    LD HL,$0BB8                           ; $A555 21 b8 0b
    LD ($A03B),HL                         ; $A558 22 3b a0 | Ricarica 3000 dopo la lettura del tasto nella routine originale. L’oracolo inietta sopra questa routine.
    POP HL                                ; $A55B e1
    RET                                   ; $A55C c9

    ORG $A6D3
; CODE: Scelta testuale: puntatore e ingresso del calcolo casuale
    INC IX                                ; $A6D3 dd 23 | HL identifica l’inizio dell’interprete della scelta testuale. Nel tono del cocchiere fuori scena, D2D3 lo salva a 5D40–5D41.
    LD A,(IX+$00)                         ; $A6D5 dd 7e 00
    LD ($A6D1),A                          ; $A6D8 32 d1 a6
    DEC A                                 ; $A6DB 3d
    CALL $D2A4                            ; $A6DC cd a4 d2

    ORG $A7D0
; CODE: Articolo di un nome comune e ritorno del decoder
    XOR A                                 ; $A7D0 af
    LD ($A7EA),A                          ; $A7D1 32 ea a7
    BIT 7,D                               ; $A7D4 cb 7a | Un nome comune prosegue verso la selezione dell’articolo. Un nome proprio segue il ramo separato.
    JR Z,$A7EB                            ; $A7D6 28 13
    LD A,E                                ; $A7D8 7b
    LD HL,$09EE                           ; $A7D9 21 ee 09
    CP L                                  ; $A7DC bd
    JR NZ,$A7E4                           ; $A7DD 20 05
    LD A,D                                ; $A7DF 7a
    AND $0F                               ; $A7E0 e6 0f
    CP H                                  ; $A7E2 bc
    RET Z                                 ; $A7E3 c8
    LD A,$01                              ; $A7E4 3e 01
    LD ($A7EA),A                          ; $A7E6 32 ea a7
    RET                                   ; $A7E9 c9
    NOP                                   ; $A7EA 00
    LD HL,$A24D                           ; $A7EB 21 4d a2
    LD A,($A027)                          ; $A7EE 3a 27 a0
    LD E,A                                ; $A7F1 5f
    LD A,($A2AA)                          ; $A7F2 3a aa a2
    OR E                                  ; $A7F5 b3
    JR Z,$A7FB                            ; $A7F6 28 03
    LD HL,$A255                           ; $A7F8 21 55 a2
    LD A,D                                ; $A7FB 7a
    RRCA                                  ; $A7FC 0f
    RRCA                                  ; $A7FD 0f
    RRCA                                  ; $A7FE 0f
    AND $1E                               ; $A7FF e6 1e
    PUSH DE                               ; $A801 d5
    LD E,A                                ; $A802 5f
    LD D,$00                              ; $A803 16 00
    ADD HL,DE                             ; $A805 19
    LD E,(HL)                             ; $A806 5e
    INC HL                                ; $A807 23
    LD D,(HL)                             ; $A808 56
    CALL $A887                            ; $A809 cd 87 a8 | La richiesta 6BB7 del cocchiere non percepibile chiama A887 con SP 5D38. Il ritorno A80C sostituisce HL del precedente scorrimento a 5D36–5D37.
    POP DE                                ; $A80C d1
    RET                                   ; $A80D c9

    ORG $A815
; CODE: Chiusura del nome e salvataggio dell’indice dell’articolo
    PUSH AF                               ; $A815 f5
    LD A,D                                ; $A816 7a
    AND $0F                               ; $A817 e6 0f
    LD D,A                                ; $A819 57
    POP AF                                ; $A81A f1
    OR D                                  ; $A81B b2
    LD D,A                                ; $A81C 57
    AND $0F                               ; $A81D e6 0f
    OR E                                  ; $A81F b3
    RET Z                                 ; $A820 c8
    CALL $A887                            ; $A821 cd 87 a8
    LD A,($A7EA)                          ; $A824 3a ea a7
    PUSH HL                               ; $A827 e5 | Il nome del cocchiere fuori scena salva la posizione della word articolo. Con la classe nominale di cabbie e il canale superiore, HL=A24E e occupa 5D38–5D39.
    LD HL,$A026                           ; $A828 21 26 a0
    OR (HL)                               ; $A82B b6
    LD (HL),A                             ; $A82C 77
    POP HL                                ; $A82D e1
    RET                                   ; $A82E c9

    ORG $A887
; CODE: Uscita prima della stampa quando l’attore non è percepibile
    LD A,($5C3C)                          ; $A887 3a 3c 5c | Il flag 5C3C è zero per la richiesta fuori scena: A88B ritorna prima di invocare il renderer.
    AND A                                 ; $A88A a7
    RET Z                                 ; $A88B c8

    ORG $A9D7
; CODE: Buffer grezzo e scarico del punto anche fuori scena
    LD (HL),A                             ; $A9D7 77 | I nomi propri di stanza negli ingressi brevi e le direzioni lessicali dei passaggi scrivono i caratteri grezzi. Entranc(e) lascia il byte a 5C12 e northeas(t) a 5C13.
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9
    PUSH DE                               ; $A9DF d5 | Prima dello scarico salva il descrittore DE. Nel punto di 7611 lascia il descrittore finale 383E a 5D4E–5D4F.
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd
    PUSH AF                               ; $A9EC f5 | Salva AF dal confronto tra spazio residuo e lunghezza della parola a 5D4C–5D4D.
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5 | Il punto di 7611 viene scaricato con BC esterno a zero, salvato a 5D4A–5D4B.
    LD B,L                                ; $A9F5 45
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa | La chiamata di AA14 lascia AA00 a 5D48–5D49, anche quando C1E1 non disegna pixel.
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0
    POP DE                                ; $AA0B d1
    POP HL                                ; $AA0C e1
    POP AF                                ; $AA0D f1
    JR $AA14                              ; $AA0E 18 04
    POP AF                                ; $AA10 f1

    ORG $AE7F
; CODE: Lettura dei token e salvataggio della classe precedente
    LD HL,($A02B)                         ; $AE7F 2a 2b a0
    LD ($A029),HL                         ; $AE82 22 29 a0
    LD A,D                                ; $AE85 7a
    LD ($A02D),A                          ; $AE86 32 2d a0 | Conserva la classe D precedente mentre rilegge il token. Il delimitatore B0 del WAIT resta osservabile nella successiva estrazione della cuoca.
    LD A,(HL)                             ; $AE89 7e
    LD D,A                                ; $AE8A 57
    LD BC,$0000                           ; $AE8B 01 00 00
    INC HL                                ; $AE8E 23
    CP $E0                                ; $AE8F fe e0
    JR Z,$AE9F                            ; $AE91 28 0c
    CP $F0                                ; $AE93 fe f0
    JR Z,$AE9F                            ; $AE95 28 08
    CP $90                                ; $AE97 fe 90
    JR Z,$AE9F                            ; $AE99 28 04
    CP $80                                ; $AE9B fe 80
    JR NC,$AEA4                           ; $AE9D 30 05
    LD A,(HL)                             ; $AE9F 7e
    LD B,A                                ; $AEA0 47
    INC HL                                ; $AEA1 23
    LD C,(HL)                             ; $AEA2 4e
    INC HL                                ; $AEA3 23
    LD ($A02B),HL                         ; $AEA4 22 2b a0
    LD A,D                                ; $AEA7 7a
    RET                                   ; $AEA8 c9

    ORG $B049
; CODE: Verbo TALK implicito e delimitatore di citazione
    BIT 1,E                               ; $B049 cb 4b
    JR Z,$B058                            ; $B04B 28 0b
    LD HL,$088B                           ; $B04D 21 8b 08 | Inserisce TALK ($088B) quando si entra dalla virgoletta senza verbo. Una frase nominale autonoma può produrre un argomento di TALK.
    LD (IY+$00),L                         ; $B050 fd 75 00
    LD (IY+$01),H                         ; $B053 fd 74 01
    RES 1,E                               ; $B056 cb 8b
    PUSH HL                               ; $B058 e5
    PUSH DE                               ; $B059 d5
    PUSH IY                               ; $B05A fd e5
    PUSH IX                               ; $B05C dd e5
    LD IY,$9FEC                           ; $B05E fd 21 ec 9f
    LD DE,$0000                           ; $B062 11 00 00
    CALL $A104                            ; $B065 cd 04 a1
    LD A,$02                              ; $B068 3e 02
    CALL $A11C                            ; $B06A cd 1c a1
    LD HL,($A02B)                         ; $B06D 2a 2b a0
    LD (IX+$00),L                         ; $B070 dd 75 00
    LD (IX+$01),H                         ; $B073 dd 74 01
    PUSH IX                               ; $B076 dd e5
    POP HL                                ; $B078 e1
    LD (IY-$02),L                         ; $B079 fd 75 fe
    LD (IY-$01),H                         ; $B07C fd 74 ff
    POP IX                                ; $B07F dd e1
    POP IY                                ; $B081 fd e1
    POP DE                                ; $B083 d1
    POP HL                                ; $B084 e1
    CALL $AE7F                            ; $B085 cd 7f ae
    CP $90                                ; $B088 fe 90
    JR NZ,$B085                           ; $B08A 20 f9
    LD A,B                                ; $B08C 78
    AND $0F                               ; $B08D e6 0f
    OR C                                  ; $B08F b1
    JR NZ,$B085                           ; $B090 20 f3
    LD HL,($A029)                         ; $B092 2a 29 a0
    LD (HL),$C0                           ; $B095 36 c0
    JP $AB52                              ; $B097 c3 52 ab

    ORG $B3B6
; CODE: Inizializzazione della ricerca nominale
    LD ($B18C),HL                         ; $B3B6 22 8c b1
    LD HL,$B188                           ; $B3B9 21 88 b1
    PUSH HL                               ; $B3BC e5
    LD B,$04                              ; $B3BD 06 04
    CALL $A2AB                            ; $B3BF cd ab a2
    POP HL                                ; $B3C2 e1
    LD B,$02                              ; $B3C3 06 02
    LD E,$04                              ; $B3C5 1e 04
    CALL $B483                            ; $B3C7 cd 83 b4
    LD E,$0E                              ; $B3CA 1e 0e
    CALL $B483                            ; $B3CC cd 83 b4
    LD E,$06                              ; $B3CF 1e 06
    CALL $B483                            ; $B3D1 cd 83 b4
    LD E,$10                              ; $B3D4 1e 10
    CALL $B483                            ; $B3D6 cd 83 b4
    XOR A                                 ; $B3D9 af
    LD ($A02E),A                          ; $B3DA 32 2e a0 | Azzera il selettore prima della ricerca controllata. Questa scrittura non riguarda la classe del token precedente.
    LD HL,$B186                           ; $B3DD 21 86 b1
    LD DE,$0008                           ; $B3E0 11 08 00
    LD IX,$8259                           ; $B3E3 dd 21 59 82
    PUSH IX                               ; $B3E7 dd e5
    POP IY                                ; $B3E9 fd e1
    CALL $A4CD                            ; $B3EB cd cd a4
    JR Z,$B3FD                            ; $B3EE 28 0d
    ADD IX,DE                             ; $B3F0 dd 19
    LD A,(IX+$01)                         ; $B3F2 dd 7e 01
    OR (IX+$00)                           ; $B3F5 dd b6 00
    JR NZ,$B3E7                           ; $B3F8 20 ed
    POP IY                                ; $B3FA fd e1
    RET                                   ; $B3FC c9

    ORG $B8AA
; CODE: Analisi della citazione e coda delle richieste
    LD HL,($B868)                         ; $B8AA 2a 68 b8
    LD ($A02B),HL                         ; $B8AD 22 2b a0
    XOR A                                 ; $B8B0 af
    LD ($A024),A                          ; $B8B1 32 24 a0
    LD HL,($9FF0)                         ; $B8B4 2a f0 9f
    PUSH HL                               ; $B8B7 e5
    LD HL,$0000                           ; $B8B8 21 00 00
    LD ($9FF0),HL                         ; $B8BB 22 f0 9f
    CALL $AAB2                            ; $B8BE cd b2 aa
    JR Z,$B8C7                            ; $B8C1 28 04
    CP $02                                ; $B8C3 fe 02
    JR NZ,$B904                           ; $B8C5 20 3d
    LD HL,($A02B)                         ; $B8C7 2a 2b a0
    LD A,(HL)                             ; $B8CA 7e
    AND $F0                               ; $B8CB e6 f0
    CP $C0                                ; $B8CD fe c0
    JR NZ,$B8BE                           ; $B8CF 20 ed
    LD (HL),$90                           ; $B8D1 36 90
    LD A,$08                              ; $B8D3 3e 08 | La citazione riuscita alloca otto byte di richiesta. I campi +05/+06 puntano alla lista sintattica e +07 contiene il modo.
    CALL $A11C                            ; $B8D5 cd 1c a1
    LD HL,($9FEE)                         ; $B8D8 2a ee 9f
    LD ($9FEE),IX                         ; $B8DB dd 22 ee 9f
    LD (IX-$02),L                         ; $B8DF dd 75 fe
    LD (IX-$01),H                         ; $B8E2 dd 74 ff
    LD HL,($9FF0)                         ; $B8E5 2a f0 9f
    LD (IX+$05),L                         ; $B8E8 dd 75 05
    LD (IX+$06),H                         ; $B8EB dd 74 06
    POP HL                                ; $B8EE e1
    LD ($9FF0),HL                         ; $B8EF 22 f0 9f
    XOR A                                 ; $B8F2 af
    LD (IX+$01),A                         ; $B8F3 dd 77 01
    LD A,($A034)                          ; $B8F6 3a 34 a0
    LD (IX+$00),A                         ; $B8F9 dd 77 00
    LD A,($A024)                          ; $B8FC 3a 24 a0
    LD (IX+$07),A                         ; $B8FF dd 77 07
    XOR A                                 ; $B902 af
    RET                                   ; $B903 c9

    ORG $B4DA
; CODE: Copia del bit di visibilità per il primo referente
    LD A,($A01D)                          ; $B4DA 3a 1d a0
    AND $01                               ; $B4DD e6 01
    LD ($A038),A                          ; $B4DF 32 38 a0

    ORG $B581
; CODE: Copia del bit di visibilità per il secondo referente
    LD A,($A01D)                          ; $B581 3a 1d a0
    AND $01                               ; $B584 e6 01
    LD ($A038),A                          ; $B586 32 38 a0

    ORG $B62F
; CODE: Rifiuto della ricerca: selezione del primo o secondo referente
    LD A,$28                              ; $B62F 3e 28
    JR $B635                              ; $B631 18 02
    LD A,$20                              ; $B633 3e 20
    LD ($B649),A                          ; $B635 32 49 b6 | B649 e B658 ricevono entrambi 20 per il rifiuto del primo argomento o 28 per il secondo. JavaScript conserva lo slot semantico. Il giardiniere legge B649 sabato alle 02:15.
    LD ($B658),A                          ; $B638 32 58 b6
    LD IX,($B18E)                         ; $B63B dd 2a 8e b1
    LD L,(IX+$04)                         ; $B63F dd 6e 04
    LD H,(IX+$05)                         ; $B642 dd 66 05
    BIT 7,(IX+$07)                        ; $B645 dd cb 07 7e
    JR NZ,$B64E                           ; $B649 20 03
    LD HL,$0000                           ; $B64B 21 00 00
    EX (SP),HL                            ; $B64E e3
    PUSH HL                               ; $B64F e5
    LD L,(IX+$02)                         ; $B650 dd 6e 02
    LD H,(IX+$03)                         ; $B653 dd 66 03
    BIT 5,H                               ; $B656 cb 6c
    JR NZ,$B65D                           ; $B658 20 03
    LD HL,$0000                           ; $B65A 21 00 00
    EX (SP),HL                            ; $B65D e3
    JP (HL)                               ; $B65E e9

    ORG $B934
; DATA: Opcode attivo e ultimo opcode di consegna degli ordini
    DEFB $00,$00                          ; $B934 00 00 | Due byte indipendenti. Il primo è l’opcode di un ordine attivo, il secondo è l’ultimo opcode del tentativo di consegna.

    ORG $B936
; CODE: Consegna degli ordini: selezione e copia dell’opcode
    PUSH IX                               ; $B936 dd e5
    PUSH IY                               ; $B938 fd e5
    PUSH HL                               ; $B93A e5
    LD ($B935),A                          ; $B93B 32 35 b9 | Salva l’opcode DOMAIN di qualunque tentativo di consegna. Ultimo B935=83 per il cocchiere martedì alle 09:15.
    CALL $B90E                            ; $B93E cd 0e b9
    LD A,(IX+$07)                         ; $B941 dd 7e 07
    CP $02                                ; $B944 fe 02
    JP Z,$BA20                            ; $B946 ca 20 ba
    LD A,(IX+$01)                         ; $B949 dd 7e 01
    CP $FF                                ; $B94C fe ff
    JR Z,$B98C                            ; $B94E 28 3c
    LD A,($B935)                          ; $B950 3a 35 b9
    LD ($B934),A                          ; $B953 32 34 b9 | Copia l’opcode in B934 solo per la richiesta con un nodo sintattico. L’ordine prefabbricato e l’affermazione biforcano prima.
    LD A,(IX+$02)                         ; $B956 dd 7e 02
    LD ($A01C),A                          ; $B959 32 1c a0

    ORG $BA60
; DATA: Watson · risultato, flag e ultima affermazione accolta
    DEFB $00,$00,$00                      ; $BA60 00 00 00 | BA67 azzera risultato e flag all’avvio dell’analisi. BB46 aggiorna entrambi e copia la tripla. BA65 è il puntatore dell’eccezione del modo 1; la tabella 9A7D è vuota.
    DEFB $00,$00,$00                      ; $BA63 00 00 00
    DEFB $00                              ; $BA66 00

    ORG $BF59
; DATA: Abbreviazioni inglesi dei sette giorni
    DEFB $4D,$6F,$6E                      ; $BF59 4d 6f 6e | Sette record consecutivi di tre caratteri. Il primo byte M è letto dal generatore domenica alle 05:38.
    DEFB $54,$75,$65                      ; $BF5C 54 75 65
    DEFB $57,$65,$64                      ; $BF5F 57 65 64
    DEFB $54,$68,$75                      ; $BF62 54 68 75
    DEFB $46,$72,$69                      ; $BF65 46 72 69
    DEFB $53,$61,$74                      ; $BF68 53 61 74
    DEFB $53,$75,$6E                      ; $BF6B 53 75 6e

    ORG $BF6E
; DATA: Buffer mutabile della stringa dell’orologio
    DEFB $4D,$4F,$4E                      ; $BF6E 4d 4f 4e | Buffer di undici caratteri. BF79 lo aggiorna a ogni stampa del tempo; il contenuto su nastro è solo iniziale.
    DEFB $20,$30,$30                      ; $BF71 20 30 30
    DEFB $3A,$30,$30                      ; $BF74 3a 30 30
    DEFB $61,$6D                          ; $BF77 61 6d

    ORG $BF79
; CODE: Composizione della striscia: giorno, ora, minuto e indicatore am/pm
    LD IX,$BF6E                           ; $BF79 dd 21 6e bf
    LD A,($9FE1)                          ; $BF7D 3a e1 9f
    LD HL,$BF59                           ; $BF80 21 59 bf
    CALL $BFC6                            ; $BF83 cd c6 bf
    INC IX                                ; $BF86 dd 23
    LD A,($9FE0)                          ; $BF88 3a e0 9f
    CALL $BFB0                            ; $BF8B cd b0 bf
    INC IX                                ; $BF8E dd 23
    LD A,($9FDF)                          ; $BF90 3a df 9f
    CALL $BFB0                            ; $BF93 cd b0 bf
    LD A,($9FE2)                          ; $BF96 3a e2 9f
    LD (IX+$00),A                         ; $BF99 dd 77 00
    LD HL,$BF6E                           ; $BF9C 21 6e bf
    LD B,$0B                              ; $BF9F 06 0b
    JP $C1A8                              ; $BFA1 c3 a8 c1
    CALL $BFAA                            ; $BFA4 cd aa bf
    LD A,L                                ; $BFA7 7d
    ADD A,$30                             ; $BFA8 c6 30
    LD (IX+$00),A                         ; $BFAA dd 77 00
    INC IX                                ; $BFAD dd 23
    RET                                   ; $BFAF c9
    LD L,A                                ; $BFB0 6f
    LD H,$00                              ; $BFB1 26 00
    LD DE,$000A                           ; $BFB3 11 0a 00
    CALL $BFBB                            ; $BFB6 cd bb bf
    JR $BFA4                              ; $BFB9 18 e9
    LD C,$2F                              ; $BFBB 0e 2f
    INC C                                 ; $BFBD 0c
    AND A                                 ; $BFBE a7
    SBC HL,DE                             ; $BFBF ed 52
    JR NC,$BFBD                           ; $BFC1 30 fa
    ADD HL,DE                             ; $BFC3 19
    LD A,C                                ; $BFC4 79
    RET                                   ; $BFC5 c9
    LD C,A                                ; $BFC6 4f | Triplica l’indice del giorno e copia esattamente tre byte nella stringa da visualizzare.
    ADD A,A                               ; $BFC7 87
    ADD A,C                               ; $BFC8 81
    LD C,A                                ; $BFC9 4f
    LD B,$00                              ; $BFCA 06 00
    ADD HL,BC                             ; $BFCC 09
    LD B,$03                              ; $BFCD 06 03
    LD A,(HL)                             ; $BFCF 7e
    LD (IX+$00),A                         ; $BFD0 dd 77 00
    INC IX                                ; $BFD3 dd 23
    INC HL                                ; $BFD5 23
    DJNZ $BFCF                            ; $BFD6 10 f7
    RET                                   ; $BFD8 c9

    ORG $C182
; CODE: Attributi della striscia dell’orologio: 32 celle con BRIGHT
    LD HL,$5A40                           ; $C182 21 40 5a
    LD DE,$5A41                           ; $C185 11 41 5a
    LD BC,$001F                           ; $C188 01 1f 00
    LD (HL),$78                           ; $C18B 36 78 | Scrive 78 per la prima cella. LDIR la replica in tutta la striscia 5A40–5A5F, distinta dal normale PAPER 7 con BRIGHT spento. Il giardiniere legge 78 venerdì alle 09:50.
    LDIR                                  ; $C18D ed b0
    RET                                   ; $C18F c9

    ORG $C1A8
; CODE: Orologio: origine, spazi e avanzamento di sette pixel
    LD DE,$5041                           ; $C1A8 11 41 50 | Parte a x=8 (5041). Lo spazio iniziale avanza di sette pixel. Il giorno parte a x=15; quello finale lascia visibili le celle successive del motivo grafico.
    EX DE,HL                              ; $C1AB eb
    LD C,$00                              ; $C1AC 0e 00
    LD A,$20                              ; $C1AE 3e 20
    CALL $C388                            ; $C1B0 cd 88 c3
    LD A,(DE)                             ; $C1B3 1a
    CALL $C388                            ; $C1B4 cd 88 c3
    INC DE                                ; $C1B7 13
    DJNZ $C1B3                            ; $C1B8 10 f9
    LD A,$20                              ; $C1BA 3e 20
    CALL $C388                            ; $C1BC cd 88 c3
    RET                                   ; $C1BF c9

    ORG $C271
; CODE: Ultima cella della pulizia della console
    PUSH HL                               ; $C271 e5 | Pulizia della riga bassa a celle di sette pixel. L’ultima cella ha x=246 e indirizzo video 50FE; non coincide con l’origine della stampa alta.
    PUSH DE                               ; $C272 d5
    PUSH BC                               ; $C273 c5
    LD HL,$5080                           ; $C274 21 80 50
    LD DE,$5060                           ; $C277 11 60 50
    LD A,$08                              ; $C27A 3e 08
    PUSH HL                               ; $C27C e5
    PUSH DE                               ; $C27D d5
    LD BC,$0080                           ; $C27E 01 80 00
    LDIR                                  ; $C281 ed b0
    POP DE                                ; $C283 d1
    POP HL                                ; $C284 e1
    INC H                                 ; $C285 24
    INC D                                 ; $C286 14
    DEC A                                 ; $C287 3d
    JR NZ,$C27C                           ; $C288 20 f2
    LD HL,$50E0                           ; $C28A 21 e0 50
    LD B,$24                              ; $C28D 06 24
    LD C,$01                              ; $C28F 0e 01
    LD A,$20                              ; $C291 3e 20
    CALL $C388                            ; $C293 cd 88 c3 | Nel rifiuto di EXAMINE ROCK si osservano due profondità: 5D38 lascia AF, BC e HL a 5D2C–5D31. Il frame 5D3E lascia AF e BC a 5D32–5D35. HL a 5D36–5D37 può essere sovrascritto da chiamate successive.
    DJNZ $C293                            ; $C296 10 fb
    POP BC                                ; $C298 c1
    POP DE                                ; $C299 d1
    POP HL                                ; $C29A e1
    RET                                   ; $C29B c9

    ORG $C388
; CODE: Indirizzo video, shift e scansione del glifo
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5
    LD L,A                                ; $C38C 6f
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5 | Lo spazio dopo plain lascia L e H di HL a 5D2A/B nel frame 5D32. Nella lista di persone, il clear dopo wall lascia H a 5D17 prima della congiunzione and.
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5
    PUSH AF                               ; $C39D f5
    DEC C                                 ; $C39E 0d
    INC C                                 ; $C39F 0c
    LD B,$FF                              ; $C3A0 06 ff
    JR Z,$C3AB                            ; $C3A2 28 07
    SRL A                                 ; $C3A4 cb 3f
    SRL B                                 ; $C3A6 cb 38
    DEC C                                 ; $C3A8 0d
    JR NZ,$C3A4                           ; $C3A9 20 f9
    LD C,A                                ; $C3AB 4f
    LD A,B                                ; $C3AC 78
    CPL                                   ; $C3AD 2f
    AND (HL)                              ; $C3AE a6
    OR C                                  ; $C3AF b1
    LD (HL),A                             ; $C3B0 77
    POP AF                                ; $C3B1 f1
    POP BC                                ; $C3B2 c1
    DEC C                                 ; $C3B3 0d
    INC C                                 ; $C3B4 0c
    JR Z,$C3D0                            ; $C3B5 28 19
    PUSH BC                               ; $C3B7 c5 | La o di to nella richiesta di pagamento 6BB7 conserva C a 5D1A nel frame 5D24. C deriva dalla colonna del glifo.
    PUSH AF                               ; $C3B8 f5 | Lo stesso glifo conserva a 5D19 l’ultima riga del font prima della rotazione, indipendente dall’offset C.
    LD A,$08                              ; $C3B9 3e 08
    SUB C                                 ; $C3BB 91
    LD C,A                                ; $C3BC 4f
    POP AF                                ; $C3BD f1
    LD B,$FF                              ; $C3BE 06 ff
    SLA A                                 ; $C3C0 cb 27
    SLA B                                 ; $C3C2 cb 20
    DEC C                                 ; $C3C4 0d
    JR NZ,$C3C0                           ; $C3C5 20 f9
    LD C,A                                ; $C3C7 4f
    LD A,B                                ; $C3C8 78
    CPL                                   ; $C3C9 2f
    INC HL                                ; $C3CA 23
    AND (HL)                              ; $C3CB a6
    OR C                                  ; $C3CC b1
    LD (HL),A                             ; $C3CD 77
    DEC HL                                ; $C3CE 2b
    POP BC                                ; $C3CF c1
    INC DE                                ; $C3D0 13
    INC H                                 ; $C3D1 24
    DJNZ $C39B                            ; $C3D2 10 c7
    POP HL                                ; $C3D4 e1
    POP DE                                ; $C3D5 d1
    POP BC                                ; $C3D6 c1
    LD A,C                                ; $C3D7 79
    ADD A,$07                             ; $C3D8 c6 07
    CP $08                                ; $C3DA fe 08
    JR C,$C3E1                            ; $C3DC 38 03
    SUB $08                               ; $C3DE d6 08
    INC L                                 ; $C3E0 2c
    LD C,A                                ; $C3E1 4f
    POP AF                                ; $C3E2 f1
    RET                                   ; $C3E3 c9

    ORG $CC82
; CODE: Ingresso DOMAIN: azzeramento dell’opcode dell’ordine attivo
    LD L,(IY+$01)                         ; $CC82 fd 6e 01
    LD H,(IY+$02)                         ; $CC85 fd 66 02
    XOR A                                 ; $CC88 af
    LD ($B934),A                          ; $CC89 32 34 b9 | Azzera B934 all’ingresso nell’interprete, ma non B935. Watson legge zero qui giovedì alle 23:33.
    LD A,($CC0B)                          ; $CC8C 3a 0b cc
    CP $0A                                ; $CC8F fe 0a
    JP Z,$CD8B                            ; $CC91 ca 8b cd

    ORG $CE3B
; CODE: Operandi temporanei di una regola DOMAIN
    LD A,(IX+$03)                         ; $CE3B dd 7e 03
    CALL $CEDE                            ; $CE3E cd de ce
    LD ($A034),A                          ; $CE41 32 34 a0
    LD A,(IX+$04)                         ; $CE44 dd 7e 04
    CALL $CEDE                            ; $CE47 cd de ce
    LD ($A035),A                          ; $CE4A 32 35 a0 | Scrive il secondo operando risolto a A035; FF è il segnaposto originale per il parametro assente, non un valore di ripiego. Il giardiniere lo legge a 14:29 durante F19A.
    JR $CE57                              ; $CE4D 18 08
    LD A,$FF                              ; $CE4F 3e ff
    LD ($A034),A                          ; $CE51 32 34 a0
    LD ($A035),A                          ; $CE54 32 35 a0
    LD A,$FF                              ; $CE57 3e ff
    LD ($A033),A                          ; $CE59 32 33 a0 | Per una regola DOMAIN A033 è FF; per un’azione viene scritto il suo ID da un ingresso distinto.
    LD L,(IX+$01)                         ; $CE5C dd 6e 01
    LD H,(IX+$02)                         ; $CE5F dd 66 02
    CALL $C591                            ; $CE62 cd 91 c5

    ORG $D008
; CODE: Ripristino e salvataggio del contesto NPC
    LD L,(IY+$04)                         ; $D008 fd 6e 04 | Ricarica gli argomenti dal contesto sospeso o dal record attore.
    LD H,(IY+$05)                         ; $D00B fd 66 05
    CALL $CFB6                            ; $D00E cd b6 cf
    LD A,(IY+$03)                         ; $D011 fd 7e 03
    JR Z,$D01F                            ; $D014 28 09
    LD L,(IX+$03)                         ; $D016 dd 6e 03
    LD H,(IX+$04)                         ; $D019 dd 66 04
    LD A,(IX+$06)                         ; $D01C dd 7e 06
    LD ($9FD6),A                          ; $D01F 32 d6 9f
    LD ($9FD7),HL                         ; $D022 22 d7 9f
    RET                                   ; $D025 c9
    LD HL,($9FD7)                         ; $D026 2a d7 9f
    CALL $CFB6                            ; $D029 cd b6 cf
    LD A,($9FD6)                          ; $D02C 3a d6 9f
    JR Z,$D03B                            ; $D02F 28 0a
    LD (IX+$03),L                         ; $D031 dd 75 03
    LD (IX+$04),H                         ; $D034 dd 74 04
    LD (IX+$06),A                         ; $D037 dd 77 06
    RET                                   ; $D03A c9
    LD (IY+$03),A                         ; $D03B fd 77 03
    LD (IY+$04),L                         ; $D03E fd 75 04 | Il ritorno da un contesto può salvare nella riga di Watson il puntatore alla richiesta del cocchiere. La struttura della coda influisce sullo stato di un altro NPC.
    LD (IY+$05),H                         ; $D041 fd 74 05
    RET                                   ; $D044 c9

    ORG $D05A
; DATA: Riferimenti al dizionario per relazioni e direzioni
    DEFB $24,$06,$66                      ; $D05A 24 06 66 | Voci little endian. D0F2 usa i bit della stanza come offset. Il generatore legge il byte alto della prima voce domenica alle 08:50.
    DEFB $04,$50,$04                      ; $D05D 04 50 04
    DEFB $FF,$05,$9A                      ; $D060 ff 05 9a
    DEFB $00,$C3,$05                      ; $D063 00 c3 05
    DEFB $1A,$08,$84                      ; $D066 1a 08 84
    DEFB $02,$92,$09                      ; $D069 02 92 09
    DEFB $C7,$05,$D0                      ; $D06C c7 05 d0
    DEFB $05,$1E,$08                      ; $D06F 05 1e 08
    DEFB $27,$08,$3C                      ; $D072 27 08 3c
    DEFB $09,$72,$02                      ; $D075 09 72 02

    ORG $D2CB
; CODE: Dopo le letture casuali: salvataggio dell’indice della scelta
    ADC A,(IX+$00)                        ; $D2CB dd 8e 00
    ADD IX,DE                             ; $D2CE dd 19
    XOR (IX+$01)                          ; $D2D0 dd ae 01
    PUSH HL                               ; $D2D3 e5 | Il salvataggio di HL segue la coppia di letture e precede il confronto con il seed. Vale anche quando la scelta ripete il tentativo.
    LD HL,$A037                           ; $D2D4 21 37 a0
    CP (HL)                               ; $D2D7 be
    POP HL                                ; $D2D8 e1
    JR Z,$D2B8                            ; $D2D9 28 dd

    ORG $D33C
; CODE: Indice della stanza dell’attore e ritorno D347
    PUSH AF                               ; $D33C f5
    LD IX,($A017)                         ; $D33D dd 2a 17 a0
    LD A,(IX+$0F)                         ; $D341 dd 7e 0f
    CALL $D224                            ; $D344 cd 24 d2 | Salva il ritorno D347 a 5D5E–5D5F nel frame di movimento DD03. Il giardiniere legge il byte alto lunedì alle 01:35.
    POP AF                                ; $D347 f1
    RET                                   ; $D348 c9

    ORG $D448
; CODE: Scansione delle uscite per direzione
    PUSH DE                               ; $D448 d5
    PUSH BC                               ; $D449 c5
    PUSH IY                               ; $D44A fd e5
    LD B,A                                ; $D44C 47
    CALL $D33C                            ; $D44D cd 3c d3
    LD DE,$0006                           ; $D450 11 06 00
    ADD IX,DE                             ; $D453 dd 19
    CALL $D206                            ; $D455 cd 06 d2
    JR Z,$D467                            ; $D458 28 0d
    LD A,(IX+$02)                         ; $D45A dd 7e 02
    AND A                                 ; $D45D a7
    JR Z,$D455                            ; $D45E 28 f5
    LD A,(IX+$00)                         ; $D460 dd 7e 00
    CP B                                  ; $D463 b8
    JP NZ,$D455                           ; $D464 c2 55 d4
    POP IY                                ; $D467 fd e1
    POP BC                                ; $D469 c1
    POP DE                                ; $D46A d1
    RET                                   ; $D46B c9

    ORG $D3D5
; CODE: Descrittori dei nomi nelle liste
    PUSH IX                               ; $D3D5 dd e5
    POP IY                                ; $D3D7 fd e1
    PUSH IY                               ; $D3D9 fd e5
    PUSH DE                               ; $D3DB d5
    LD DE,$0007                           ; $D3DC 11 07 00
    ADD IY,DE                             ; $D3DF fd 19
    CALL $D3E8                            ; $D3E1 cd e8 d3
    POP DE                                ; $D3E4 d1
    POP IY                                ; $D3E5 fd e1
    RET                                   ; $D3E7 c9
    PUSH AF                               ; $D3E8 f5 | Nel nome del cocchiere fuori scena salva AF con A=ID dell’attore e F dal lookup A4BC, a 5D3E–5D3F. D3E9 salva il relativo del testo a 5D3C–5D3D.
    PUSH DE                               ; $D3E9 d5
    LD D,(IY+$01)                         ; $D3EA fd 56 01
    LD E,(IY+$00)                         ; $D3ED fd 5e 00
    CALL $A7D0                            ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                        ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                           ; $D3F7 20 04
    XOR A                                 ; $D3F9 af
    LD ($A7EA),A                          ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                        ; $D3FD fd cb ff 6e
    JR NZ,$D427                           ; $D401 20 24
    JR $D416                              ; $D403 18 11
    PUSH AF                               ; $D405 f5
    PUSH DE                               ; $D406 d5
    LD D,(IY+$01)                         ; $D407 fd 56 01
    LD E,(IY+$00)                         ; $D40A fd 5e 00
    CALL $A7D0                            ; $D40D cd d0 a7
    LD A,($A028)                          ; $D410 3a 28 a0
    AND A                                 ; $D413 a7
    JR NZ,$D438                           ; $D414 20 22
    LD E,(IY+$02)                         ; $D416 fd 5e 02
    LD D,(IY+$03)                         ; $D419 fd 56 03
    RES 7,D                               ; $D41C cb ba
    BIT 7,(IY+$03)                        ; $D41E fd cb 03 7e
    LD A,$40                              ; $D422 3e 40
    CALL Z,$A815                          ; $D424 cc 15 a8
    LD E,(IY+$04)                         ; $D427 fd 5e 04
    LD D,(IY+$05)                         ; $D42A fd 56 05
    RES 7,D                               ; $D42D cb ba
    BIT 7,(IY+$05)                        ; $D42F fd cb 05 7e
    LD A,$40                              ; $D433 3e 40
    CALL Z,$A815                          ; $D435 cc 15 a8
    LD E,(IY+$00)                         ; $D438 fd 5e 00
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8 | CALL del formatter del sostantivo. Nel nome del cocchiere fuori scena, lascia il ritorno D445 a 5D3A–5D3B.
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $D60B
; CODE: Direzione del passaggio, articolo e nome
    PUSH BC                               ; $D60B c5
    PUSH DE                               ; $D60C d5
    PUSH IY                               ; $D60D fd e5
    PUSH IX                               ; $D60F dd e5
    CALL $D5EF                            ; $D611 cd ef d5
    PUSH IX                               ; $D614 dd e5
    POP IY                                ; $D616 fd e1
    JR $D660                              ; $D618 18 46
    LD A,(IY+$01)                         ; $D61A fd 7e 01
    AND A                                 ; $D61D a7
    JR Z,$D660                            ; $D61E 28 40
    LD A,(IY+$00)                         ; $D620 fd 7e 00
    CP $0B                                ; $D623 fe 0b
    JR NC,$D660                           ; $D625 30 39
    LD A,(IY+$01)                         ; $D627 fd 7e 01
    CALL $D237                            ; $D62A cd 37 d2
    BIT 7,(IX+$05)                        ; $D62D dd cb 05 7e
    JR Z,$D660                            ; $D631 28 2d
    LD A,(IY+$00)                         ; $D633 fd 7e 00
    CALL $D5FB                            ; $D636 cd fb d5
    CP $09                                ; $D639 fe 09
    JR C,$D647                            ; $D63B 38 0a
    LD DE,$000A                           ; $D63D 11 0a 00
    JR Z,$D64D                            ; $D640 28 0b
    LD DE,$00E7                           ; $D642 11 e7 00
    JR $D64D                              ; $D645 18 06
    LD HL,$68BC                           ; $D647 21 bc 68
    CALL $A59F                            ; $D64A cd 9f a5
    CALL $A887                            ; $D64D cd 87 a8 | La parola della direzione resta in attesa fino alla stampa di there is. Se va a capo, C374 pulisce la riga nel frame 5D22 e salva AF a 5D16/17.
    LD HL,$68E9                           ; $D650 21 e9 68
    CALL $A59F                            ; $D653 cd 9f a5
    PUSH IY                               ; $D656 fd e5
    CALL $D3D5                            ; $D658 cd d5 d3 | L’articolo del nome comune scarica is nel frame 5D24, dopo il ritorno a capo della direzione. C3B8 salva un nuovo AF a 5D18/19.
    CALL $A414                            ; $D65B cd 14 a4
    POP IY                                ; $D65E fd e1
    ADD IY,BC                             ; $D660 fd 09
    LD A,$FF                              ; $D662 3e ff
    CP (IY+$00)                           ; $D664 fd be 00
    JP NZ,$D61A                           ; $D667 c2 1a d6
    POP IX                                ; $D66A dd e1
    POP IY                                ; $D66C fd e1
    POP DE                                ; $D66E d1
    POP BC                                ; $D66F c1
    RET                                   ; $D670 c9

    ORG $D898
; CODE: Ingresso dell’editor: ricarica il contatore
    LD HL,$0BB8                           ; $D898 21 b8 0b
    LD ($A03B),HL                         ; $D89B 22 3b a0 | All’ingresso del prompt carica 0BB8 (3000) prima di leggere il tasto.
    LD A,$01                              ; $D89E 3e 01
    LD ($A027),A                          ; $D8A0 32 27 a0
    CALL $D8AD                            ; $D8A3 cd ad d8
    PUSH AF                               ; $D8A6 f5
    XOR A                                 ; $D8A7 af
    LD ($A027),A                          ; $D8A8 32 27 a0
    POP AF                                ; $D8AB f1
    RET                                   ; $D8AC c9

    ORG $DFCC
; CODE: Finale selezionato dalla presenza di Basil
    LD HL,$759C                           ; $DFCC 21 9c 75
    LD A,$06                              ; $DFCF 3e 06
    CALL $D237                            ; $DFD1 cd 37 d2
    LD A,($A009)                          ; $DFD4 3a 09 a0
    CP (IX+$0F)                           ; $DFD7 dd be 0f | Confronta la stanza di Holmes con quella di Basil. Se coincidono seleziona il testo 75D2, altrimenti 759C.
    JP NZ,$9E74                           ; $DFDA c2 74 9e | Ramo naturale di martedì alle 23:41. EEC3 entra da EFC7 mentre Holmes è nella stanza 33 e Basil nella 35.
    LD HL,$75D2                           ; $DFDD 21 d2 75 | Ramo osservato nella camera di Basil mercoledì alle 06:07 con seed 1. 9E74 stampa e termina la partita.
    JP $9E74                              ; $DFE0 c3 74 9e

    ORG $E5DF
; CODE: Confronto di due stanze · lascia il secondo indice in IX
    LD IX,($A013)                         ; $E5DF dd 2a 13 a0
    LD A,(IX+$0F)                         ; $E5E3 dd 7e 0f
    LD IX,($A015)                         ; $E5E6 dd 2a 15 a0 | Carica il puntatore del secondo referente. CB37 lo conserva anche se i due attori sono in stanze diverse; la cuoca lo rilegge nello stack della scelta percentuale.
    CP (IX+$0F)                           ; $E5EA dd be 0f
    LD A,($A035)                          ; $E5ED 3a 35 a0
    JP NZ,$DC15                           ; $E5F0 c2 15 dc
    LD HL,$A034                           ; $E5F3 21 34 a0
    CP (HL)                               ; $E5F6 be
    JP Z,$DC15                            ; $E5F7 ca 15 dc
    OR $01                                ; $E5FA f6 01
    RET                                   ; $E5FC c9

    ORG $E6BE
; CODE: Stampa della richiesta di pagamento del cocchiere
    LD A,($A035)                          ; $E6BE 3a 35 a0
    CALL $E619                            ; $E6C1 cd 19 e6
    JR Z,$E6E3                            ; $E6C4 28 1d
    LD E,(IX+$09)                         ; $E6C6 dd 5e 09
    LD D,(IX+$0A)                         ; $E6C9 dd 56 0a
    LD HL,$6BB7                           ; $E6CC 21 b7 6b | Nella richiesta fuori scena del mercoledì alle 10:17, il renderer resta spento. Il lookup dell’articolo conserva comunque A80C a 5D36–5D37. 6BB7 stampa la richiesta di pagamento. La chiamata del nome del destinatario scarica il precedente to.
    CALL $A59F                            ; $E6CF cd 9f a5
    LD HL,$0000                           ; $E6D2 21 00 00
    AND A                                 ; $E6D5 a7
    SBC HL,DE                             ; $E6D6 ed 52
    CALL $A419                            ; $E6D8 cd 19 a4
    LD A,$22                              ; $E6DB 3e 22
    CALL $A9B7                            ; $E6DD cd b7 a9
    CALL $A2A2                            ; $E6E0 cd a2 a2
    OR $01                                ; $E6E3 f6 01
    RET                                   ; $E6E5 c9

    ORG $E710
; CODE: Avvertimento del cocchiere e visibilità temporanea
    LD A,($5C3C)                          ; $E710 3a 3c 5c
    PUSH AF                               ; $E713 f5
    CALL $CFB6                            ; $E714 cd b6 cf
    LD A,(IX+$03)                         ; $E717 dd 7e 03
    AND A                                 ; $E71A a7
    LD HL,$6C54                           ; $E71B 21 54 6c
    JR NZ,$E725                           ; $E71E 20 05
    LD A,$01                              ; $E720 3e 01
    LD ($5C3C),A                          ; $E722 32 3c 5c
    CALL $A59F                            ; $E725 cd 9f a5 | 6C54 fuori scena conserva il ritorno A80C dell’articolo nello slot 5D44–5D45, sostituendo il D445 della richiesta precedente. E729 ripristina il flag 5C3C.
    POP AF                                ; $E728 f1
    LD ($5C3C),A                          ; $E729 32 3c 5c
    OR $01                                ; $E72C f6 01
    RET                                   ; $E72E c9

    ORG $EBC5
; BYTECODE: Lestrade: attesa della posizione del veicolo
    DEFB $52,$83,$FB                      ; $EBC5 52 83 fb | Lestrade aspetta che il proprio veicolo soddisfi la condizione di posizione. Nel ramo passivo osservato resta in questo punto.
    DEFB $FC,$C5,$EB                      ; $EBC8 fc c5 eb

    ORG $EEB6
; BYTECODE: Basil · fine dell’attesa e chiamata di EFC7
    DEFB $83,$7A,$E5                      ; $EEB6 83 7a e5
    DEFB $AF,$EE,$03                      ; $EEB9 af ee 03
    DEFB $B3,$EF,$47                      ; $EEBC b3 ef 47
    DEFB $BE,$DD,$28                      ; $EEBF be dd 28
    DEFB $FF,$03,$C7                      ; $EEC2 ff 03 c7
    DEFB $EF                              ; $EEC5 ef

    ORG $EF90
; BYTECODE: Basil fuori scena: attesa e salto all’indietro
    DEFB $03,$A8,$E5                      ; $EF90 03 a8 e5 | DOMAIN 03 A8 E5 attende un tick. 0E 90 EF salta di nuovo a EF90. Nella variante passiva Basil resta qui anche la settimana seguente.
    DEFB $0E,$90,$EF                      ; $EF93 0e 90 ef

    ORG $EFC7
; DATA: Intestazione della regola di Basil
    DEFB $00,$00                          ; $EFC7 00 00

    ORG $F05C
; BYTECODE: Poliziotto · attesa e salto accanto all’ingresso del segnale
    DEFB $03,$A8,$E5                      ; $F05C 03 a8 e5 | Chiama E5A8 per attendere un tick. F05F salta all’inizio F05C. Il salto precedente F059 prosegue altrove. Il generatore può leggere questo blocco anche senza entrarvi.
    DEFB $0E,$5C,$F0                      ; $F05F 0e 5c f0

    ORG $EFC9
; CODE: Controllo della posizione di Holmes nella casa di Basil
    LD A,($A009)                          ; $EFC9 3a 09 a0 | Controlla la stanza del giocatore. Le stanze 33–39 abilitano il selettore DFCC. Fuori dall’intervallo aggiorna lo stato di Basil.
    CP $23                                ; $EFCC fe 23
    JR Z,$EFE6                            ; $EFCE 28 16
    CP $21                                ; $EFD0 fe 21
    JR Z,$EFE6                            ; $EFD2 28 12
    CP $22                                ; $EFD4 fe 22
    JR Z,$EFE6                            ; $EFD6 28 0e
    CP $26                                ; $EFD8 fe 26
    JR Z,$EFE6                            ; $EFDA 28 0a
    CP $25                                ; $EFDC fe 25
    JR Z,$EFE6                            ; $EFDE 28 06
    CP $24                                ; $EFE0 fe 24
    JR Z,$EFE6                            ; $EFE2 28 02
    CP $27                                ; $EFE4 fe 27
    JP Z,$DFCC                            ; $EFE6 ca cc df
    LD DE,$0000                           ; $EFE9 11 00 00
    LD B,$80                              ; $EFEC 06 80
    CALL $EFBA                            ; $EFEE cd ba ef
    SET 6,(IX+$05)                        ; $EFF1 dd cb 05 f6
    RET                                   ; $EFF5 c9
