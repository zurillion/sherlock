; Dossier PAY: modello e intestazione sono dati; istruzioni riasssemblate contro il payload.

    ORG $8379
; DATA: Modello PAY: TO opzionale e ruoli dativi
    DEFB $64,$C6,$DB,$08,$00,$D0,$00,$20  ; $8379 64 c6 db 08 00 d0 00 20 | Quattro word del modello37 con flag nei nibble alti: PAY/TO. A01D=0C,A01E=2D. Non è codice; anche l’assenza della preposizione passa alla scelta dei ruoli.

    ORG $B39D
; CODE: Ricerca del modello lessicale prima dei ruoli degli argomenti
    PUSH IY                               ; $B39D fd e5
    LD L,(IY+$00)                         ; $B39F fd 6e 00
    LD H,(IY+$01)                         ; $B3A2 fd 66 01
    LD A,H                                ; $B3A5 7c
    AND $80                               ; $B3A6 e6 80
    LD ($B39C),A                          ; $B3A8 32 9c b3
    RES 7,H                               ; $B3AB cb bc
    LD ($B186),HL                         ; $B3AD 22 86 b1
    LD L,(IY+$02)                         ; $B3B0 fd 6e 02
    LD H,(IY+$03)                         ; $B3B3 fd 66 03
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
    LD ($A02E),A                          ; $B3DA 32 2e a0
    LD HL,$B186                           ; $B3DD 21 86 b1
    LD DE,$0008                           ; $B3E0 11 08 00
    LD IX,$8259                           ; $B3E3 dd 21 59 82
    PUSH IX                               ; $B3E7 dd e5
    POP IY                                ; $B3E9 fd e1
    CALL $A4CD                            ; $B3EB cd cd a4 | Confronta il modello lessicale; gli argomenti monetari o mancanti non giustificano un modello sconosciuto inventato dal prototipo.
    JR Z,$B3FD                            ; $B3EE 28 0d
    ADD IX,DE                             ; $B3F0 dd 19
    LD A,(IX+$01)                         ; $B3F2 dd 7e 01
    OR (IX+$00)                           ; $B3F5 dd b6 00
    JR NZ,$B3E7                           ; $B3F8 20 ed
    POP IY                                ; $B3FA fd e1
    RET                                   ; $B3FC c9
    POP IY                                ; $B3FD fd e1
    CALL $B405                            ; $B3FF cd 05 b4
    OR $01                                ; $B402 f6 01
    RET                                   ; $B404 c9

    ORG $B405
; CODE: Ordinamento semantico: senza TO destinatario prima dell’importo
    AND A                                 ; $B405 a7 | Lo scambio dei ruoli è guidato dal modello e dalla preposizione, non dal test euristico “il secondo nominale sembra denaro”.
    JR Z,$B416                            ; $B406 28 0e
    LD HL,($B188)                         ; $B408 2a 88 b1
    LD DE,($B18A)                         ; $B40B ed 5b 8a b1
    LD ($B188),DE                         ; $B40F ed 53 88 b1
    LD ($B18A),HL                         ; $B413 22 8a b1
    CALL $A2BD                            ; $B416 cd bd a2
    LD HL,$B188                           ; $B419 21 88 b1
    LD A,(HL)                             ; $B41C 7e
    INC HL                                ; $B41D 23
    OR (HL)                               ; $B41E b6
    JR NZ,$B426                           ; $B41F 20 05
    LD A,($A01E)                          ; $B421 3a 1e a0 | Preposizione assente: usa A01E, poi XOR20. PAY legge destinatario, importo anche se uno dei due nominali manca.
    JR $B445                              ; $B424 18 1f
    DEC HL                                ; $B426 2b
    LD A,(HL)                             ; $B427 7e
    CP (IY+$0E)                           ; $B428 fd be 0e
    JR NZ,$B435                           ; $B42B 20 08
    INC HL                                ; $B42D 23
    LD A,(HL)                             ; $B42E 7e
    CP (IY+$0F)                           ; $B42F fd be 0f
    JR Z,$B440                            ; $B432 28 0c
    DEC HL                                ; $B434 2b
    LD A,(HL)                             ; $B435 7e
    CP (IY+$10)                           ; $B436 fd be 10
    JR NZ,$B440                           ; $B439 20 05
    INC HL                                ; $B43B 23
    LD A,(HL)                             ; $B43C 7e
    CP (IY+$11)                           ; $B43D fd be 11
    LD A,($A01D)                          ; $B440 3a 1d a0
    JR NZ,$B447                           ; $B443 20 02
    XOR $20                               ; $B445 ee 20 | La selezione degli offset del nodo non muta i due gruppi sintattici. Conservare gli slot fisici e il loro ordine nell’arena.
    BIT 5,A                               ; $B447 cb 6f
    LD BC,$1208                           ; $B449 01 08 12 | Offset12/08 oppure08/12 per primo/secondo ruolo. Un importo scritto da solo non diventa automaticamente un pagamento al personaggio vicino.
    JR Z,$B451                            ; $B44C 28 03
    LD BC,$0812                           ; $B44E 01 12 08
    LD HL,$B182                           ; $B451 21 82 b1
    LD (HL),B                             ; $B454 70
    INC HL                                ; $B455 23
    LD (HL),C                             ; $B456 71
    LD A,B                                ; $B457 78
    LD DE,$B172                           ; $B458 11 72 b1
    LD HL,$B16D                           ; $B45B 21 6d b1
    CALL $B468                            ; $B45E cd 68 b4
    LD A,C                                ; $B461 79
    LD DE,$B178                           ; $B462 11 78 b1
    LD HL,$B16E                           ; $B465 21 6e b1

    ORG $B468
; CODE: Copia dei nominali nei ruoli senza alterare il nodo sintattico
    PUSH BC                               ; $B468 c5 | Copia sei byte del nominale selezionato; anche uno slot vuoto partecipa alla semantica.
    LD C,A                                ; $B469 4f
    LD B,$00                              ; $B46A 06 00
    PUSH HL                               ; $B46C e5
    PUSH IY                               ; $B46D fd e5
    POP HL                                ; $B46F e1
    ADD HL,BC                             ; $B470 09
    LD BC,$0006                           ; $B471 01 06 00
    LDIR                                  ; $B474 ed b0
    XOR A                                 ; $B476 af
    LD B,$06                              ; $B477 06 06
    DEC HL                                ; $B479 2b
    OR (HL)                               ; $B47A b6
    DJNZ $B479                            ; $B47B 10 fc
    POP HL                                ; $B47D e1
    POP BC                                ; $B47E c1
    RET Z                                 ; $B47F c8
    SET 0,(HL)                            ; $B480 cb c6
    RET                                   ; $B482 c9

    ORG $E345
; CODE: Preflight del saldo e rifiuto del pagamento
    CALL $E34F                            ; $E345 cd 4f e3 | Il predicato del pagamento richiede il saldo disponibile; il corpo non è raggiunto quando la semantica precedente rifiuta gli argomenti.
    RET Z                                 ; $E348 c8
    LD A,$25                              ; $E349 3e 25
    LD ($A033),A                          ; $E34B 32 33 a0
    RET                                   ; $E34E c9
    LD A,($A036)                          ; $E34F 3a 36 a0 | Cerca il conto del soggetto corrente; E619 restituisce il descrittore del denaro, oppure Z se manca.
    CALL $E619                            ; $E352 cd 19 e6
    JR Z,$E365                            ; $E355 28 0e
    CALL $E39C                            ; $E357 cd 9c e3
    CALL $E3A9                            ; $E35A cd a9 e3 | Decodifica il letterale monetario A02F prima del confronto con il saldo.
    AND A                                 ; $E35D a7
    SBC HL,DE                             ; $E35E ed 52 | Sottrae l’importo dal saldo: carry indica fondi insufficienti e sceglie il ritorno di fallimento.
    JR C,$E365                            ; $E360 38 03
    OR $01                                ; $E362 f6 01
    RET                                   ; $E364 c9
    LD HL,$E36A                           ; $E365 21 6a e3
    XOR A                                 ; $E368 af
    RET                                   ; $E369 c9
    LD HL,$683F                           ; $E36A 21 3f 68 | Testo di insufficienza fondi disponibile al motore; non è il messaggio visibile in ogni rifiuto semantico PAY.
    JP $A59F                              ; $E36D c3 9f a5

    ORG $E370
; DATA: Intestazione PAY: letterale monetario e persona destinataria
    DEFB $66,$1D,$45,$E3                  ; $E370 66 1d 45 e3 | Header66,1D con predicatoE345: classe6 letterale monetario, classe13 persona percepibile; costo1. Non decodificare come istruzioni.

    ORG $E374
; CODE: Corpo del pagamento: addebito e accredito
    CALL $E34F                            ; $E374 cd 4f e3 | Il trasferimento resta lo stesso per PAY destinatario importo e PAY importo TO destinatario. PAY10D da solo non arriva al corpo e non avanza il tempo.
    CALL $E38F                            ; $E377 cd 8f e3 | Scrive il saldo residuo del pagante nel formato originale.
    LD A,($A035)                          ; $E37A 3a 35 a0
    CALL $E619                            ; $E37D cd 19 e6 | Cerca il conto del destinatario. Se manca, il corpo originale salta l’accredito e termina; questo dossier non modifica tale meccanica.
    JR Z,$E38C                            ; $E380 28 0a
    CALL $E39C                            ; $E382 cd 9c e3
    CALL $E3A9                            ; $E385 cd a9 e3
    ADD HL,DE                             ; $E388 19 | Somma l’importo al saldo del conto destinatario trovato.
    CALL $E38F                            ; $E389 cd 8f e3
    OR $01                                ; $E38C f6 01
    RET                                   ; $E38E c9
