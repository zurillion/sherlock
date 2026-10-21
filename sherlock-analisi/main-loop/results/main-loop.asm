; Sherlock v2.0 - main loop. Indirizzi esadecimali, intervalli selezionati.

    ORG $9860
; DATA fino a $9920
; 24 righe attore, 8 byte: ID, PC(word), azione, arg1, arg2, scadenza(word).
    DEFB $00,$21,$99,$FF,$FF,$FF,$00,$00 ; $9860 00 21 99 ff ff ff 00 00
; Riga attore ID 2.
    DEFB $02,$E7,$E7,$FF,$FF,$FF,$00,$00 ; $9868 02 e7 e7 ff ff ff 00 00
; Riga attore ID 3.
    DEFB $03,$2F,$E7,$FF,$FF,$FF,$00,$00 ; $9870 03 2f e7 ff ff ff 00 00
; Riga attore ID 4.
    DEFB $04,$FA,$EB,$FF,$FF,$FF,$00,$00 ; $9878 04 fa eb ff ff ff 00 00
; Riga attore ID 5.
    DEFB $05,$17,$F0,$FF,$FF,$FF,$00,$00 ; $9880 05 17 f0 ff ff ff 00 00
; Riga attore ID 6.
    DEFB $06,$2B,$EE,$FF,$FF,$FF,$00,$00 ; $9888 06 2b ee ff ff ff 00 00
; Riga attore ID 104.
    DEFB $68,$F6,$EF,$FF,$FF,$FF,$00,$00 ; $9890 68 f6 ef ff ff ff 00 00
; Riga attore ID 7.
    DEFB $07,$62,$F0,$FF,$FF,$FF,$00,$00 ; $9898 07 62 f0 ff ff ff 00 00
; Riga attore ID 8.
    DEFB $08,$4B,$ED,$FF,$FF,$FF,$00,$00 ; $98A0 08 4b ed ff ff ff 00 00
; Riga attore ID 9.
    DEFB $09,$F8,$ED,$FF,$FF,$FF,$00,$00 ; $98A8 09 f8 ed ff ff ff 00 00
; Riga attore ID 10.
    DEFB $0A,$1F,$EE,$FF,$FF,$FF,$00,$00 ; $98B0 0a 1f ee ff ff ff 00 00
; Riga attore ID 11.
    DEFB $0B,$10,$F1,$FF,$FF,$FF,$00,$00 ; $98B8 0b 10 f1 ff ff ff 00 00
; Riga attore ID 12.
    DEFB $0C,$45,$F1,$FF,$FF,$FF,$00,$00 ; $98C0 0c 45 f1 ff ff ff 00 00
; Riga attore ID 13.
    DEFB $0D,$5A,$F1,$FF,$FF,$FF,$00,$00 ; $98C8 0d 5a f1 ff ff ff 00 00
; Riga attore ID 31.
    DEFB $1F,$B2,$F2,$FF,$FF,$FF,$00,$00 ; $98D0 1f b2 f2 ff ff ff 00 00
; Riga attore ID 34.
    DEFB $22,$B2,$F2,$FF,$FF,$FF,$00,$00 ; $98D8 22 b2 f2 ff ff ff 00 00
; Riga attore ID 36.
    DEFB $24,$1D,$F2,$FF,$FF,$FF,$00,$00 ; $98E0 24 1d f2 ff ff ff 00 00
; Riga attore ID 37.
    DEFB $25,$3A,$F2,$FF,$FF,$FF,$00,$00 ; $98E8 25 3a f2 ff ff ff 00 00
; Riga attore ID 38.
    DEFB $26,$2D,$F2,$FF,$FF,$FF,$00,$00 ; $98F0 26 2d f2 ff ff ff 00 00
; Riga attore ID 39.
    DEFB $27,$46,$F2,$FF,$FF,$FF,$00,$00 ; $98F8 27 46 f2 ff ff ff 00 00
; Riga attore ID 40.
    DEFB $28,$68,$F2,$FF,$FF,$FF,$00,$00 ; $9900 28 68 f2 ff ff ff 00 00
; Riga attore ID 41.
    DEFB $29,$5B,$F2,$FF,$FF,$FF,$00,$00 ; $9908 29 5b f2 ff ff ff 00 00
; Riga attore ID 42.
    DEFB $2A,$78,$F2,$FF,$FF,$FF,$00,$00 ; $9910 2a 78 f2 ff ff ff 00 00
; Riga attore ID 43.
    DEFB $2B,$8D,$F2,$FF,$FF,$FF,$00,$00 ; $9918 2b 8d f2 ff ff ff 00 00
; FF: fine tabella attori.
    DEFB $FF                           ; $9920 ff

    ORG $9921
; DATA fino a $994C
; BYTECODE: 01 22 = LOOK iniziale.
    DEFB $01,$22                       ; $9921 01 22
; BYTECODE: regola D6BF editor; fallimento ->9948 (WAIT automatico).
    DEFB $13,$BF,$D6,$48,$99           ; $9923 13 bf d6 48 99
; BYTECODE: regola D715 lessico/tokenizzazione; fallimento ->9923.
    DEFB $13,$15,$D7,$23,$99           ; $9928 13 15 d7 23 99
; BYTECODE: regola D769 verifica token residui; fallimento ->9923.
    DEFB $13,$69,$D7,$23,$99           ; $992D 13 69 d7 23 99
; BYTECODE: regola D77E parsing; fallimento ->9923.
    DEFB $13,$7E,$D7,$23,$99           ; $9932 13 7e d7 23 99
; BYTECODE: regola D7D9 verifica nodo; fallimento ->992D.
    DEFB $13,$D9,$D7,$2D,$99           ; $9937 13 d9 d7 2d 99
; BYTECODE: regola D7FA semantica; fallimento ->9937.
    DEFB $13,$FA,$D7,$37,$99           ; $993C 13 fa d7 37 99
; BYTECODE: 02 FA FD FC = esegui azione e argomenti salvati.
    DEFB $02,$FA,$FD,$FC               ; $9941 02 fa fd fc
; BYTECODE: salto 9937, altri nodi del comando.
    DEFB $0E,$37,$99                   ; $9945 0e 37 99
; BYTECODE: 01 31 = WAIT HERE.
    DEFB $01,$31                       ; $9948 01 31
; BYTECODE: salto 9923, nuovo input.
    DEFB $0E,$23,$99                   ; $994A 0e 23 99

    ORG $9C6A
; CODE fino a $9C84
; Selezione callback specifica per attore.
    LD A,($A036)                       ; $9C6A 3a 36 a0
    LD IX,$9C85                        ; $9C6D dd 21 85 9c
    CALL $D34E                         ; $9C71 cd 4e d3
    CP $FF                             ; $9C74 fe ff
    RET                                ; $9C76 c9
    CALL $9C6A                         ; $9C77 cd 6a 9c
    RET Z                              ; $9C7A c8
    LD L,(IX+$01)                      ; $9C7B dd 6e 01
    LD H,(IX+$02)                      ; $9C7E dd 66 02
    LD A,L                             ; $9C81 7d
    OR H                               ; $9C82 b4
    RET Z                              ; $9C83 c8
    JP (HL)                            ; $9C84 e9

    ORG $9C85
; DATA fino a $9CA1
; Tabella callback; non codice. Include il contatore mutabile 9CA1.
    DEFB $02,$FF,$9D,$03,$13,$9D,$04,$30 ; $9C85 02 ff 9d 03 13 9d 04 30
    DEFB $9D,$0B,$48,$9D,$0C,$73,$9D,$08 ; $9C8D 9d 0b 48 9d 0c 73 9d 08
    DEFB $D1,$9E,$09,$CB,$9E,$05,$C1,$9E ; $9C95 d1 9e 09 cb 9e 05 c1 9e
    DEFB $06,$A2,$9C,$FF,$0F           ; $9C9D 06 a2 9c ff 0f

    ORG $9FDD
; DATA fino a $A03F
; Contatore globale word; poi minuti, ore, giorno, a/p.
    DEFB $00,$00,$3B,$07,$00,$61,$70,$95 ; $9FDD 00 00 3b 07 00 61 70 95
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $9FE5 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $9FED 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $9FF5 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$71,$09,$00 ; $9FFD 00 00 00 00 00 71 09 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $A005 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$FF,$00,$00 ; $A00D 00 00 00 00 00 ff 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $A015 00 00 00 00 00 00 00 00
    DEFB $00,$00                       ; $A01D 00 00
; Costo restituito dal passo corrente, word.
    DEFB $00,$00,$00,$00,$00,$00,$00,$01 ; $A01F 00 00 00 00 00 00 00 01
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $A027 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00   ; $A02F 00 00 00 00 00 00 00
; ID attore corrente.
    DEFB $00                           ; $A036 00
; Seme casuale.
    DEFB $00,$00,$00,$00               ; $A037 00 00 00 00
; Contatore inattivita tastiera, word.
    DEFB $00,$00,$04,$40,$58           ; $A03B 00 00 04 40 58

    ORG $A040
; CODE fino a $A0D7
; Avvio UI/sessione; stato iniziale del mondo gia presente nel payload.
    XOR A                              ; $A040 af
    LD ($D6B8),A                       ; $A041 32 b8 d6
    LD ($A01B),A                       ; $A044 32 1b a0
    DI                                 ; $A047 f3
; Inizializzazione schermo.
    CALL $C14A                         ; $A048 cd 4a c1
    LD SP,$5D80                        ; $A04B 31 80 5d
; Scelta grafica iniziale.
    CALL $C415                         ; $A04E cd 15 c4
    CP $6E                             ; $A051 fe 6e
    JR Z,$A05B                         ; $A053 28 06
    CP $4E                             ; $A055 fe 4e
    LD A,$01                           ; $A057 3e 01
    JR NZ,$A05C                        ; $A059 20 01
    XOR A                              ; $A05B af
    LD ($A011),A                       ; $A05C 32 11 a0
; Seme casuale dal registro R.
    LD A,R                             ; $A05F ed 5f
    LD ($A037),A                       ; $A061 32 37 a0
; Azzera richiesta SAVE/LOAD.
    XOR A                              ; $A064 af
    LD ($A0DA),A                       ; $A065 32 da a0
; Inizio ciclo: serve eventuale richiesta pendente.
    LD A,($A0DA)                       ; $A068 3a da a0
    AND A                              ; $A06B a7
    JR NZ,$A0E7                        ; $A06C 20 79
; Avanza tempo PRIMA della scansione attori.
    CALL $BFD9                         ; $A06E cd d9 bf
; Aggiorna visualizzazione orologio.
    CALL $BF79                         ; $A071 cd 79 bf
    LD IY,$9860                        ; $A074 fd 21 60 98
; Azione salvata 32 hex = WAIT UNTIL: controlla ENTER.
    LD A,(IY+$03)                      ; $A078 fd 7e 03
    CP $32                             ; $A07B fe 32
    JR NZ,$A093                        ; $A07D 20 14
    CALL $C41F                         ; $A07F cd 1f c4
    BIT 7,A                            ; $A082 cb 7f
    JR Z,$A093                         ; $A084 28 0d
    CP $8D                             ; $A086 fe 8d
    JR NZ,$A093                        ; $A088 20 09
; ENTER anticipa scadenza di Holmes al tick corrente.
    LD HL,($9FDD)                      ; $A08A 2a dd 9f
    LD (IY+$06),L                      ; $A08D fd 75 06
    LD (IY+$07),H                      ; $A090 fd 74 07
; Riparte dalla prima riga, Holmes.
    LD IY,$9860                        ; $A093 fd 21 60 98
; FF termina la scansione.
    LD A,(IY+$00)                      ; $A097 fd 7e 00
    INC A                              ; $A09A 3c
    JR Z,$A068                         ; $A09B 28 cb
    LD HL,($9FDD)                      ; $A09D 2a dd 9f
; Confronta tempo globale e scadenza: carry se troppo presto.
    CALL $A0DB                         ; $A0A0 cd db a0
    JR C,$A0D1                         ; $A0A3 38 2c
    LD A,(IY+$00)                      ; $A0A5 fd 7e 00
    PUSH IY                            ; $A0A8 fd e5
    PUSH AF                            ; $A0AA f5
; Prepara contesto attore una volta per visita eleggibile.
    CALL $CC37                         ; $A0AB cd 37 cc
    POP AF                             ; $A0AE f1
    PUSH AF                            ; $A0AF f5
; Esegue un passo della sequenza.
    CALL $CC78                         ; $A0B0 cd 78 cc
    LD HL,($A01F)                      ; $A0B3 2a 1f a0
    LD A,L                             ; $A0B6 7d
    OR H                               ; $A0B7 b4
; Costo zero: stesso attore, nuovo passo.
    JR Z,$A0AE                         ; $A0B8 28 f4
    POP AF                             ; $A0BA f1
    POP IY                             ; $A0BB fd e1
; Scadenza nuova = scadenza PRECEDENTE + costo.
    LD E,(IY+$06)                      ; $A0BD fd 5e 06
    LD D,(IY+$07)                      ; $A0C0 fd 56 07
    ADD HL,DE                          ; $A0C3 19
    LD (IY+$06),L                      ; $A0C4 fd 75 06
    LD (IY+$07),H                      ; $A0C7 fd 74 07
    PUSH IY                            ; $A0CA fd e5
; Callback dopo la porzione di attivita con costo positivo.
    CALL $9C77                         ; $A0CC cd 77 9c
    POP IY                             ; $A0CF fd e1
; Prossimo attore: passo fisso 8.
    LD DE,$0008                        ; $A0D1 11 08 00
    ADD IY,DE                          ; $A0D4 fd 19
    JR $A097                           ; $A0D6 18 bf

    ORG $A0D8
; DATA fino a $A0DA
; Stato mutabile, NON INC C / OR 00.
    DEFB $0C,$F6                       ; $A0D8 0c f6
; Richiesta servizio: 0 normale, 1 caricamento, 2 salvataggio.
    DEFB $00                           ; $A0DA 00

    ORG $A0DB
; CODE fino a $A0F6
; Confronto unsigned a 16 bit HL vs scadenza attore.
    LD E,(IY+$06)                      ; $A0DB fd 5e 06
    LD D,(IY+$07)                      ; $A0DE fd 56 07
    LD A,H                             ; $A0E1 7c
    CP D                               ; $A0E2 ba
    RET NZ                             ; $A0E3 c0
    LD A,L                             ; $A0E4 7d
    CP E                               ; $A0E5 bb
    RET                                ; $A0E6 c9
; Servizi a fine scansione: SAVE oppure LOAD/QUIT.
    CP $02                             ; $A0E7 fe 02
    JR Z,$A0F1                         ; $A0E9 28 06
    CALL $B0D7                         ; $A0EB cd d7 b0
    JP $A040                           ; $A0EE c3 40 a0
    CALL $B0E4                         ; $A0F1 cd e4 b0
    JP $A064                           ; $A0F4 c3 64 a0

    ORG $A536
; CODE fino a $A55C
; Attende un carattere o esaurimento contatore.
    PUSH HL                            ; $A536 e5
    LD HL,($A03B)                      ; $A537 2a 3b a0
; Lettura tastiera sincronizzata con interrupt.
    CALL $C41F                         ; $A53A cd 1f c4
    BIT 7,A                            ; $A53D cb 7f
    JR NZ,$A553                        ; $A53F 20 12
    LD A,$00                           ; $A541 3e 00
    DEC A                              ; $A543 3d
    PUSH HL                            ; $A544 e5
    POP HL                             ; $A545 e1
    JR NZ,$A543                        ; $A546 20 fb
; Una iterazione senza tasto consuma una unita.
    DEC HL                             ; $A548 2b
    LD A,H                             ; $A549 7c
    OR L                               ; $A54A b5
    JR NZ,$A53A                        ; $A54B 20 ed
    POP HL                             ; $A54D e1
    PUSH HL                            ; $A54E e5
; Timeout: cancella input incompleto.
    CALL $D9B7                         ; $A54F cd b7 d9
    XOR A                              ; $A552 af
    AND $7F                            ; $A553 e6 7f
; Ripristina 3000 iterazioni; avviene anche dopo ogni tasto.
    LD HL,$0BB8                        ; $A555 21 b8 0b
    LD ($A03B),HL                      ; $A558 22 3b a0
    POP HL                             ; $A55B e1
    RET                                ; $A55C c9

    ORG $B0AC
; CODE fino a $B0FC
; Richiesta LOAD/QUIT: azzera clock e scadenza Holmes, costo 1, flag 1.
    LD HL,$0000                        ; $B0AC 21 00 00
    LD ($9FDD),HL                      ; $B0AF 22 dd 9f
    LD IX,$9860                        ; $B0B2 dd 21 60 98
    LD (IX+$06),L                      ; $B0B6 dd 75 06
    LD (IX+$07),H                      ; $B0B9 dd 74 07
    INC HL                             ; $B0BC 23
    LD ($A01F),HL                      ; $B0BD 22 1f a0
    LD A,L                             ; $B0C0 7d
    LD ($A0DA),A                       ; $B0C1 32 da a0
    AND A                              ; $B0C4 a7
    RET                                ; $B0C5 c9
    CALL $AFE1                         ; $B0C6 cd e1 af
; Richiesta SAVE: costo 1, flag 2.
    LD HL,$0001                        ; $B0C9 21 01 00
    LD ($A01F),HL                      ; $B0CC 22 1f a0
    LD A,$02                           ; $B0CF 3e 02
    LD ($A0DA),A                       ; $B0D1 32 da a0
    JP $B015                           ; $B0D4 c3 15 b0
; Servizio caricamento (I/O non eseguito dalle prove).
    CALL $B0EE                         ; $B0D7 cd ee b0
    CALL $C0DF                         ; $B0DA cd df c0
    JR NC,$B0D7                        ; $B0DD 30 f8
    LD IY,($9FD4)                      ; $B0DF fd 2a d4 9f
    RET                                ; $B0E3 c9
; Servizio salvataggio (I/O non eseguito dalle prove).
    LD ($9FD4),IY                      ; $B0E4 fd 22 d4 9f
    CALL $B0EE                         ; $B0E8 cd ee b0
    JP $C040                           ; $B0EB c3 40 c0
; Intervallo salvato: 840B..A01E, 7188 byte.
    LD IX,$840B                        ; $B0EE dd 21 0b 84
    LD HL,$A01F                        ; $B0F2 21 1f a0
    LD DE,$840B                        ; $B0F5 11 0b 84
    AND A                              ; $B0F8 a7
    SBC HL,DE                          ; $B0F9 ed 52
    EX DE,HL                           ; $B0FB eb
    RET                                ; $B0FC c9

    ORG $BFD9
; CODE fino a $C00B
; Incrementa contatore globale e calendario.
    LD HL,($9FDD)                      ; $BFD9 2a dd 9f
    INC HL                             ; $BFDC 23
    LD ($9FDD),HL                      ; $BFDD 22 dd 9f
    LD HL,$9FDF                        ; $BFE0 21 df 9f
    INC (HL)                           ; $BFE3 34
    LD A,(HL)                          ; $BFE4 7e
    CP $3C                             ; $BFE5 fe 3c
    RET NZ                             ; $BFE7 c0
    LD (HL),$00                        ; $BFE8 36 00
    LD HL,$9FE0                        ; $BFEA 21 e0 9f
    INC (HL)                           ; $BFED 34
    LD A,(HL)                          ; $BFEE 7e
    CP $0D                             ; $BFEF fe 0d
    JR NZ,$BFF6                        ; $BFF1 20 03
    LD (HL),$01                        ; $BFF3 36 01
    RET                                ; $BFF5 c9
    CP $0C                             ; $BFF6 fe 0c
    RET NZ                             ; $BFF8 c0
    LD A,($9FE2)                       ; $BFF9 3a e2 9f
    XOR $11                            ; $BFFC ee 11
    LD ($9FE2),A                       ; $BFFE 32 e2 9f
    CP $61                             ; $C001 fe 61
    RET NZ                             ; $C003 c0
    LD A,($9FE1)                       ; $C004 3a e1 9f
    INC A                              ; $C007 3c
    LD ($9FE1),A                       ; $C008 32 e1 9f
    RET                                ; $C00B c9

    ORG $C415
; CODE fino a $C45D
; Attesa tasto senza timeout usata da scelta grafica/paginazione.
    CALL $C41F                         ; $C415 cd 1f c4
    BIT 7,A                            ; $C418 cb 7f
    JR Z,$C415                         ; $C41A 28 f9
    AND $7F                            ; $C41C e6 7f
    RET                                ; $C41E c9
; EI/HALT/DI e lettura stato tastiera ROM.
    PUSH IY                            ; $C41F fd e5
    PUSH IX                            ; $C421 dd e5
    PUSH HL                            ; $C423 e5
    PUSH DE                            ; $C424 d5
    PUSH BC                            ; $C425 c5
    LD IY,$5C3A                        ; $C426 fd 21 3a 5c
    EI                                 ; $C42A fb
    HALT                               ; $C42B 76
    DI                                 ; $C42C f3
    LD A,($5C3B)                       ; $C42D 3a 3b 5c
    BIT 5,A                            ; $C430 cb 6f
    JR NZ,$C437                        ; $C432 20 03
    XOR A                              ; $C434 af
    JR $C456                           ; $C435 18 1f
    RES 5,A                            ; $C437 cb af
    LD ($5C3B),A                       ; $C439 32 3b 5c
    LD A,($5C08)                       ; $C43C 3a 08 5c
    CP $5F                             ; $C43F fe 5f
    JR NZ,$C445                        ; $C441 20 02
    LD A,$18                           ; $C443 3e 18
    CP $0C                             ; $C445 fe 0c
    JR NZ,$C44B                        ; $C447 20 02
    LD A,$08                           ; $C449 3e 08
    CP $0B                             ; $C44B fe 0b
    JR NZ,$C451                        ; $C44D 20 02
    LD A,$5B                           ; $C44F 3e 5b
    CALL $C240                         ; $C451 cd 40 c2
    SET 7,A                            ; $C454 cb ff
    POP BC                             ; $C456 c1
    POP DE                             ; $C457 d1
    POP HL                             ; $C458 e1
    POP IX                             ; $C459 dd e1
    POP IY                             ; $C45B fd e1
    RET                                ; $C45D c9

    ORG $CC0E
; CODE fino a $CC9A
; Ricerca ID nella tabella attori.
    PUSH DE                            ; $CC0E d5
    PUSH BC                            ; $CC0F c5
    LD C,A                             ; $CC10 4f
    LD DE,$0008                        ; $CC11 11 08 00
    LD IY,$9860                        ; $CC14 fd 21 60 98
    LD A,(IY+$00)                      ; $CC18 fd 7e 00
    CP C                               ; $CC1B b9
    JR Z,$CC26                         ; $CC1C 28 08
    CP $FF                             ; $CC1E fe ff
    JR Z,$CC26                         ; $CC20 28 04
    ADD IY,DE                          ; $CC22 fd 19
    JR $CC18                           ; $CC24 18 f2
    POP BC                             ; $CC26 c1
    POP DE                             ; $CC27 d1
    RET                                ; $CC28 c9
    LD A,($A036)                       ; $CC29 3a 36 a0
    CALL $D495                         ; $CC2C cd 95 d4
    LD ($A017),IX                      ; $CC2F dd 22 17 a0
    LD ($A00A),A                       ; $CC33 32 0a a0
    RET                                ; $CC36 c9
; Prepara attore, riferimenti e contesto; costo iniziale zero.
    PUSH AF                            ; $CC37 f5
    XOR A                              ; $CC38 af
    LD ($CC0B),A                       ; $CC39 32 0b cc
    POP AF                             ; $CC3C f1
    CALL $CC0E                         ; $CC3D cd 0e cc
    CP $FF                             ; $CC40 fe ff
    LD HL,$0001                        ; $CC42 21 01 00
    JP Z,$CC74                         ; $CC45 ca 74 cc
    LD ($9FDB),IY                      ; $CC48 fd 22 db 9f
    LD ($A036),A                       ; $CC4C 32 36 a0
    CALL $B91F                         ; $CC4F cd 1f b9
    LD A,$00                           ; $CC52 3e 00
    JR NZ,$CC57                        ; $CC54 20 01
    INC A                              ; $CC56 3c
    LD ($CC0D),A                       ; $CC57 32 0d cc
    CALL $CC29                         ; $CC5A cd 29 cc
    CALL $D045                         ; $CC5D cd 45 d0
    SUB A                              ; $CC60 97
    LD ($5C3C),A                       ; $CC61 32 3c 5c
    LD A,($9860)                       ; $CC64 3a 60 98
    CALL $C821                         ; $CC67 cd 21 c8
    JR Z,$CC71                         ; $CC6A 28 05
    LD A,$01                           ; $CC6C 3e 01
    LD ($5C3C),A                       ; $CC6E 32 3c 5c
    LD HL,$0000                        ; $CC71 21 00 00
    LD ($A01F),HL                      ; $CC74 22 1f a0
    RET                                ; $CC77 c9
; Ripristina azione e argomenti; poi interprete bytecode.
    CALL $CC5A                         ; $CC78 cd 5a cc
    LD IY,($9FDB)                      ; $CC7B fd 2a db 9f
    CALL $D008                         ; $CC7F cd 08 d0
; Legge puntatore alla sequenza corrente.
    LD L,(IY+$01)                      ; $CC82 fd 6e 01
    LD H,(IY+$02)                      ; $CC85 fd 66 02
    XOR A                              ; $CC88 af
    LD ($B934),A                       ; $CC89 32 34 b9
    LD A,($CC0B)                       ; $CC8C 3a 0b cc
    CP $0A                             ; $CC8F fe 0a
    JP Z,$CD8B                         ; $CC91 ca 8b cd
    LD A,(HL)                          ; $CC94 7e
    AND A                              ; $CC95 a7
    JR NZ,$CC9B                        ; $CC96 20 03
    INC HL                             ; $CC98 23
    JR $CC94                           ; $CC99 18 f9

    ORG $D008
; CODE fino a $D044
; Ripristina azione e argomenti da riga attore o contesto sospeso.
    LD L,(IY+$04)                      ; $D008 fd 6e 04
    LD H,(IY+$05)                      ; $D00B fd 66 05
    CALL $CFB6                         ; $D00E cd b6 cf
    LD A,(IY+$03)                      ; $D011 fd 7e 03
    JR Z,$D01F                         ; $D014 28 09
    LD L,(IX+$03)                      ; $D016 dd 6e 03
    LD H,(IX+$04)                      ; $D019 dd 66 04
    LD A,(IX+$06)                      ; $D01C dd 7e 06
    LD ($9FD6),A                       ; $D01F 32 d6 9f
    LD ($9FD7),HL                      ; $D022 22 d7 9f
    RET                                ; $D025 c9
; Salva azione e argomenti nella riga o contesto sospeso.
    LD HL,($9FD7)                      ; $D026 2a d7 9f
    CALL $CFB6                         ; $D029 cd b6 cf
    LD A,($9FD6)                       ; $D02C 3a d6 9f
    JR Z,$D03B                         ; $D02F 28 0a
    LD (IX+$03),L                      ; $D031 dd 75 03
    LD (IX+$04),H                      ; $D034 dd 74 04
    LD (IX+$06),A                      ; $D037 dd 77 06
    RET                                ; $D03A c9
    LD (IY+$03),A                      ; $D03B fd 77 03
    LD (IY+$04),L                      ; $D03E fd 75 04
    LD (IY+$05),H                      ; $D041 fd 74 05
    RET                                ; $D044 c9
