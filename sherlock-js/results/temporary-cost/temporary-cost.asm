; Analisi offline, dati distinti dal codice; nessuna esecuzione Z80 nel motore JS.

    ORG $A01F
; DATA: Costo temporaneo globale: byte basso e alto
    DEFB $00,$00                          ; $A01F 00 00 | Word condivisa, non durata locale di un personaggio. CC74 azzera; CA09 assegna il costo del body selezionato; i corpi possono sovrascriverla. Il runtime conserva i due byte e la loro validità anche nei salvataggi JS.

    ORG $9AF1
; CODE: Cab furioso: durata nel byte basso
    LD L,A                                ; $9AF1 6f | Durata furiosa calcolata nel byte L, dopo SUB 2: il prestito non si propaga a H.
    JR $9B02                              ; $9AF2 18 0e

    ORG $9AF4
; DATA: Cab normale: intestazione della regola, non codice
    DEFB $04,$00                          ; $9AF4 04 00 | Intestazione04 00: classe locazione4, costo iniziale0. Il corpo da9AF6 sostituisce il costo con la durata del percorso.

    ORG $9AF6
; CODE: Viaggio cab: durata pubblicata prima della partenza
    CALL $9B50                            ; $9AF6 cd 50 9b
    LD DE,$0002                           ; $9AF9 11 02 00
    CALL $9B25                            ; $9AFC cd 25 9b
    LD L,(IX+$02)                         ; $9AFF dd 6e 02
    LD A,$01                              ; $9B02 3e 01
    PUSH AF                               ; $9B04 f5
    LD H,$00                              ; $9B05 26 00
    LD ($A01F),HL                         ; $9B07 22 1f a0 | Durata del cab pubblicata prima del trasferimento del veicolo e dei suoi annunci. Non aspettare il ritorno dell’azione per aggiornare la word.

    ORG $A0B0
; CODE: Scheduler: costo zero ripete; costo nonzero aggiorna la scadenza
    CALL $CC78                            ; $A0B0 cd 78 cc
    LD HL,($A01F)                         ; $A0B3 2a 1f a0 | Lo scheduler legge la word condivisa: costo zero ripete lo stesso attore. Un byte alto nonzero conta anche quando il basso è zero.
    LD A,L                                ; $A0B6 7d
    OR H                                  ; $A0B7 b4
    JR Z,$A0AE                            ; $A0B8 28 f4
    POP AF                                ; $A0BA f1
    POP IY                                ; $A0BB fd e1
    LD E,(IY+$06)                         ; $A0BD fd 5e 06
    LD D,(IY+$07)                         ; $A0C0 fd 56 07
    ADD HL,DE                             ; $A0C3 19 | La durata si somma alla scadenza precedente, non al tick globale attuale.
    LD (IY+$06),L                         ; $A0C4 fd 75 06
    LD (IY+$07),H                         ; $A0C7 fd 74 07

    ORG $B0AC
; CODE: LOAD/QUIT e SAVE: costo temporaneo uno
    LD HL,$0000                           ; $B0AC 21 00 00
    LD ($9FDD),HL                         ; $B0AF 22 dd 9f
    LD IX,$9860                           ; $B0B2 dd 21 60 98
    LD (IX+$06),L                         ; $B0B6 dd 75 06
    LD (IX+$07),H                         ; $B0B9 dd 74 07
    INC HL                                ; $B0BC 23
    LD ($A01F),HL                         ; $B0BD 22 1f a0 | Richiesta LOAD/QUIT: costo uno dopo il reset del clock.
    LD A,L                                ; $B0C0 7d
    LD ($A0DA),A                          ; $B0C1 32 da a0
    AND A                                 ; $B0C4 a7
    RET                                   ; $B0C5 c9
    CALL $AFE1                            ; $B0C6 cd e1 af
    LD HL,$0001                           ; $B0C9 21 01 00
    LD ($A01F),HL                         ; $B0CC 22 1f a0 | SAVE imposta uno. Il formato JSON del prototipo è un adattatore che conserva anche gli ingressi temporanei della casualità.
    LD A,$02                              ; $B0CF 3e 02
    LD ($A0DA),A                          ; $B0D1 32 da a0
    JP $B015                              ; $B0D4 c3 15 b0

    ORG $B0EE
; CODE: Limite del nastro originale: A01F e A020 sono fuori dal blocco salvato
    LD IX,$840B                           ; $B0EE dd 21 0b 84
    LD HL,$A01F                           ; $B0F2 21 1f a0 | Il blocco nastro è [840B,A01F): esclude la word temporanea. Non trattare un vecchio SAVE nativo come inizializzazione del suo valore.
    LD DE,$840B                           ; $B0F5 11 0b 84
    AND A                                 ; $B0F8 a7
    SBC HL,DE                             ; $B0F9 ed 52
    EX DE,HL                              ; $B0FB eb
    RET                                   ; $B0FC c9

    ORG $C9F2
; CODE: Regola eseguita: costo dal nibble alto prima del corpo
    LD A,($A00B)                          ; $C9F2 3a 0b a0 | In preflight A00B=0 ritorna senza assegnare il costo e senza eseguire il corpo.
    AND A                                 ; $C9F5 a7
    JR NZ,$C9FB                           ; $C9F6 20 03
    OR $01                                ; $C9F8 f6 01
    RET                                   ; $C9FA c9
    PUSH IY                               ; $C9FB fd e5
    LD A,(IY+$01)                         ; $C9FD fd 7e 01
    RRCA                                  ; $CA00 0f
    RRCA                                  ; $CA01 0f
    RRCA                                  ; $CA02 0f
    RRCA                                  ; $CA03 0f
    AND $0F                               ; $CA04 e6 0f
    LD L,A                                ; $CA06 6f
    LD H,$00                              ; $CA07 26 00
    LD ($A01F),HL                         ; $CA09 22 1f a0 | Scrive H=0 e L=nibble alto dell’intestazione PRIMA di entrare nel corpo. Un corpo fallito non ripristina da solo il costo precedente.

    ORG $CC71
; CODE: Ingresso del passo DOMAIN: azzera entrambi i byte del costo
    LD HL,$0000                           ; $CC71 21 00 00
    LD ($A01F),HL                         ; $CC74 22 1f a0 | Reset a ogni ingresso CC78. Non azzerare a ogni minuto: durante la visita successiva il costo può essere sostituito da altri attori.
    RET                                   ; $CC77 c9
    CALL $CC5A                            ; $CC78 cd 5a cc
    LD IY,($9FDB)                         ; $CC7B fd 2a db 9f
    CALL $D008                            ; $CC7F cd 08 d0
    LD L,(IY+$01)                         ; $CC82 fd 6e 01
    LD H,(IY+$02)                         ; $CC85 fd 66 02
    XOR A                                 ; $CC88 af
    LD ($B934),A                          ; $CC89 32 34 b9
    LD A,($CC0B)                          ; $CC8C 3a 0b cc
    CP $0A                                ; $CC8F fe 0a
    JP Z,$CD8B                            ; $CC91 ca 8b cd

    ORG $CD82
; CODE: Yield e budget fallimenti: costo uno
    LD HL,$0001                           ; $CD82 21 01 00
    LD ($A01F),HL                         ; $CD85 22 1f a0 | Yield esplicito: word uno prima della continuazione comune.
    JP $CE8F                              ; $CD88 c3 8f ce
    LD HL,$0001                           ; $CD8B 21 01 00
    LD ($A01F),HL                         ; $CD8E 22 1f a0 | Autoloop fallito o budget di dieci tentativi: word uno prima di D026.
    CALL $D026                            ; $CD91 cd 26 d0
    RET                                   ; $CD94 c9

    ORG $D7D0
; CODE: Ritorno dell’azione del giocatore: controlla entrambi i byte del costo
    LD HL,($A01F)                         ; $D7D0 2a 1f a0 | Anche il predicato che verifica il tempo dell’azione osserva la word condivisa.
    LD A,H                                ; $D7D3 7c
    OR L                                  ; $D7D4 b5
    RET NZ                                ; $D7D5 c0
    JP $DC15                              ; $D7D6 c3 15 dc

    ORG $DDC2
; CODE: Ritardo dinamico: modifica solo il byte basso
    LD A,($A034)                          ; $DDC2 3a 34 a0
    LD ($A01F),A                          ; $DDC5 32 1f a0 | Scrittura di un solo byte. Il byte alto conserva il valore precedente; nel normale percorso la precedente intestazione CA09 lo ha azzerato.
    OR $01                                ; $DDC8 f6 01
    RET                                   ; $DDCA c9

    ORG $DDD4
; CODE: WAIT UNTIL: differenza unsigned sull’orologio a dodici ore
    LD HL,($A02F)                         ; $DDD4 2a 2f a0 | Il valore grezzo A02F contiene ore, minuti e i tag am/pm. Non usare una conversione moderna a data civile.
    RES 7,H                               ; $DDD7 cb bc
    PUSH HL                               ; $DDD9 e5
    LD A,H                                ; $DDDA 7c | Maschera i tag prima della moltiplicazione per sessanta. DE48 tratta ore zero come 256 iterazioni DJNZ.
    AND $3F                               ; $DDDB e6 3f
    LD H,A                                ; $DDDD 67
    LD A,L                                ; $DDDE 7d
    AND $3F                               ; $DDDF e6 3f
    LD L,A                                ; $DDE1 6f
    CALL $DE48                            ; $DDE2 cd 48 de
    LD ($DDCD),HL                         ; $DDE5 22 cd dd
    LD HL,($9FDF)                         ; $DDE8 2a df 9f
    CALL $DE48                            ; $DDEB cd 48 de
    LD ($DDCB),HL                         ; $DDEE 22 cb dd
    POP HL                                ; $DDF1 e1
    LD A,$61                              ; $DDF2 3e 61
    LD ($DDCF),A                          ; $DDF4 32 cf dd
    BIT 6,H                               ; $DDF7 cb 74
    JR NZ,$DE19                           ; $DDF9 20 1e
    LD A,$70                              ; $DDFB 3e 70
    LD ($DDCF),A                          ; $DDFD 32 cf dd
    BIT 6,L                               ; $DE00 cb 75
    JR NZ,$DE19                           ; $DE02 20 15
    CALL $DE60                            ; $DE04 cd 60 de
    LD A,($9FE2)                          ; $DE07 3a e2 9f
    JR C,$DE0E                            ; $DE0A 38 02
    JR NZ,$DE16                           ; $DE0C 20 08
    CP $61                                ; $DE0E fe 61
    LD A,$70                              ; $DE10 3e 70
    JR Z,$DE16                            ; $DE12 28 02
    LD A,$61                              ; $DE14 3e 61
    LD ($DDCF),A                          ; $DE16 32 cf dd
    LD HL,($DDCD)                         ; $DE19 2a cd dd
    LD DE,($DDCB)                         ; $DE1C ed 5b cb dd
    AND A                                 ; $DE20 a7
    SBC HL,DE                             ; $DE21 ed 52 | Sottrazione a sedici bit; le aggiunte di 720 mantengono il wrap unsigned.
    LD DE,$02D0                           ; $DE23 11 d0 02
    LD A,($9FE2)                          ; $DE26 3a e2 9f
    LD C,A                                ; $DE29 4f
    LD A,($DDCF)                          ; $DE2A 3a cf dd
    LD B,A                                ; $DE2D 47
    CALL $DE60                            ; $DE2E cd 60 de
    JR C,$DE3C                            ; $DE31 38 09
    JR Z,$DE3C                            ; $DE33 28 07
    LD A,B                                ; $DE35 78
    CP C                                  ; $DE36 b9
    JR Z,$DE42                            ; $DE37 28 09
    ADD HL,DE                             ; $DE39 19
    JR $DE42                              ; $DE3A 18 06
    ADD HL,DE                             ; $DE3C 19
    LD A,B                                ; $DE3D 78
    CP C                                  ; $DE3E b9
    JR NZ,$DE42                           ; $DE3F 20 01
    ADD HL,DE                             ; $DE41 19
    LD ($A01F),HL                         ; $DE42 22 1f a0 | Scrive entrambe le celle, anche per attese oltre 255 minuti. I passi NPC successivi le riscrivono secondo le loro regole.
    OR $01                                ; $DE45 f6 01
    RET                                   ; $DE47 c9

    ORG $E432
; DATA: Uscita dai contenitori: intestazione con maschere, non codice
    DEFB $78,$20,$20,$E4,$10,$80,$28,$00,$00 ; $E432 78 20 20 e4 10 80 28 00 00 | Header 78 20: costo due, predicato E420; controllo10: richiede attributo80 e almeno uno dei bit28. Un cab in corsa perde80 e non consente di scendere.

    ORG $E43B
; CODE: Uscita dal contenitore: ripristina il genitore esterno
    LD IY,($A013)                         ; $E43B fd 2a 13 a0 | Il corpo si raggiunge solo dopo predicato e maschere. La selezione dell’oggetto può già avere aggiornato gli argomenti anche se il corpo viene rifiutato.
    LD A,(IY+$01)                         ; $E43F fd 7e 01
    LD IY,($A017)                         ; $E442 fd 2a 17 a0
    LD (IY+$01),A                         ; $E446 fd 77 01
    OR $01                                ; $E449 f6 01
    RET                                   ; $E44B c9
