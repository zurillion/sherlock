; Analisi offline: dati e codice sono distinti; nessuna esecuzione CPU nel motore JS.

    ORG $A011
; DATA: Flag della grafica nativa del protocollo sorgente
    DEFB $00                              ; $A011 00 | Scelta grafica dell’originale. Il profilo verificato disabilita il disegno bitmap dopo il boot; preferenze SVG/pixel del browser separate.

    ORG $A013
; DATA: Puntatori temporanei ai due argomenti delle regole
    DEFB $00,$00,$00,$00                  ; $A013 00 00 00 00 | Word primo argomento, word secondo. C908/C924 aggiornano solo ID <FE: i letterali e FF lasciano il valore precedente.

    ORG $A887
; CODE: Dizionario: fuori scena non scrive neanche lo spazio nel buffer
    LD A,($5C3C)                          ; $A887 3a 3c 5c
    AND A                                 ; $A88A a7
    RET Z                                 ; $A88B c8 | Fuori scena ritorna prima dello spazio e della parola di dizionario; i letterali attraversano invece A9B7.
    LD ($A022),DE                         ; $A88C ed 53 22 a0
    LD A,D                                ; $A890 7a
    AND $0F                               ; $A891 e6 0f
    OR E                                  ; $A893 b3
    RET Z                                 ; $A894 c8
    PUSH IX                               ; $A895 dd e5
    PUSH HL                               ; $A897 e5
    PUSH BC                               ; $A898 c5
    PUSH DE                               ; $A899 d5
    LD A,$20                              ; $A89A 3e 20
    CALL $A9B7                            ; $A89C cd b7 a9

    ORG $A9B7
; CODE: Buffer di parola: scritture letterali persistenti anche fuori scena
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0
    AND A                                 ; $A9BB a7
    JR NZ,$AA10                           ; $A9BC 20 52
    POP AF                                ; $A9BE f1
    PUSH AF                               ; $A9BF f5
    PUSH HL                               ; $A9C0 e5
    LD HL,($A9B5)                         ; $A9C1 2a b5 a9
    CP $20                                ; $A9C4 fe 20
    JR Z,$A9DF                            ; $A9C6 28 17
    CP $0D                                ; $A9C8 fe 0d
    JR Z,$A9DF                            ; $A9CA 28 13
    CP $22                                ; $A9CC fe 22
    JR Z,$A9DF                            ; $A9CE 28 0f
    CP $08                                ; $A9D0 fe 08
    JR NZ,$A9D7                           ; $A9D2 20 03
    DEC HL                                ; $A9D4 2b
    JR $A9D9                              ; $A9D5 18 02
    LD (HL),A                             ; $A9D7 77 | Scrive nel buffer riutilizzato. La testimonianza fuori scena di Straker lascia una l a 5C15, letta molte ore dopo dal generatore.
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9
    PUSH DE                               ; $A9DF d5
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa
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
    JP $C1E1                              ; $AA11 c3 e1 c1

    ORG $BA13
; DATA: Affermazioni: due cursori, verbo lessicale e tripla parziale
    DEFB $00,$00,$00,$00,$00,$00,$00,$00  ; $BA13 00 00 00 00 00 00 00 00 | BA13/BA15: cursori nella tabella 8B6F, non puntatori ai record entità. BA17: offset del verbo; BA19–BA1B: soggetto, indice predicato, oggetto. Le scritture sono parziali.
    DEFB $00                              ; $BA1B 00

    ORG $BD7E
; CODE: Risoluzione globale delle affermazioni e verifica di unicità
    PUSH IY                               ; $BD7E fd e5
    POP HL                                ; $BD80 e1
    LD DE,$0018                           ; $BD81 11 18 00
    ADD HL,DE                             ; $BD84 19
    BIT 7,(IY+$19)                        ; $BD85 fd cb 19 7e
    JR Z,$BD8E                            ; $BD89 28 03
    LD HL,$9FF6                           ; $BD8B 21 f6 9f
    BIT 6,(IY+$19)                        ; $BD8E fd cb 19 76
    JR Z,$BD97                            ; $BD92 28 03
    LD HL,$9FFC                           ; $BD94 21 fc 9f
    LD DE,$B172                           ; $BD97 11 72 b1
    LD BC,$0006                           ; $BD9A 01 06 00
    LDIR                                  ; $BD9D ed b0
    PUSH IY                               ; $BD9F fd e5
    POP HL                                ; $BDA1 e1
    LD DE,$0008                           ; $BDA2 11 08 00
    ADD HL,DE                             ; $BDA5 19
    LD DE,$B178                           ; $BDA6 11 78 b1
    LD BC,$0006                           ; $BDA9 01 06 00
    LDIR                                  ; $BDAC ed b0
    LD L,(IY+$00)                         ; $BDAE fd 6e 00
    LD A,(IY+$01)                         ; $BDB1 fd 7e 01
    AND $0F                               ; $BDB4 e6 0f
    LD H,A                                ; $BDB6 67
    LD ($BA17),HL                         ; $BDB7 22 17 ba
    PUSH IY                               ; $BDBA fd e5
    CALL $BDC2                            ; $BDBC cd c2 bd
    POP IY                                ; $BDBF fd e1
    RET                                   ; $BDC1 c9
    CALL $D04F                            ; $BDC2 cd 4f d0
    LD ($BA13),IX                         ; $BDC5 dd 22 13 ba | Entrambi i cursori partono da 8B6C (8B6F meno 3), prima della prima scansione D36A.
    LD ($BA15),IX                         ; $BDC9 dd 22 15 ba
    LD DE,($BA17)                         ; $BDCD ed 5b 17 ba
    LD HL,$994D                           ; $BDD1 21 4d 99
    LD B,$01                              ; $BDD4 06 01
    LD A,(HL)                             ; $BDD6 7e
    INC HL                                ; $BDD7 23
    OR (HL)                               ; $BDD8 b6
    DEC HL                                ; $BDD9 2b
    RET Z                                 ; $BDDA c8
    LD A,E                                ; $BDDB 7b
    CP (HL)                               ; $BDDC be
    JR NZ,$BDE5                           ; $BDDD 20 06
    INC HL                                ; $BDDF 23
    LD A,D                                ; $BDE0 7a
    CP (HL)                               ; $BDE1 be
    DEC HL                                ; $BDE2 2b
    JR Z,$BDEA                            ; $BDE3 28 05
    INC HL                                ; $BDE5 23
    INC HL                                ; $BDE6 23
    INC B                                 ; $BDE7 04
    JR $BDD6                              ; $BDE8 18 ec
    LD A,B                                ; $BDEA 78
    LD ($BA1A),A                          ; $BDEB 32 1a ba
    LD A,$02                              ; $BDEE 3e 02
    LD ($A038),A                          ; $BDF0 32 38 a0
    CALL $BE3C                            ; $BDF3 cd 3c be | Primo match del soggetto; il tentativo seguente verifica che non ve ne sia un secondo.
    CP $FF                                ; $BDF6 fe ff
    RET Z                                 ; $BDF8 c8
    LD ($BA19),A                          ; $BDF9 32 19 ba
    CALL $BE3C                            ; $BDFC cd 3c be
    CP $FF                                ; $BDFF fe ff
    JR NZ,$BE3A                           ; $BE01 20 37
    LD A,($BA19)                          ; $BE03 3a 19 ba
    CALL $BE22                            ; $BE06 cd 22 be
    CALL $BE4B                            ; $BE09 cd 4b be
    CP $FF                                ; $BE0C fe ff
    RET Z                                 ; $BE0E c8
    LD ($BA1B),A                          ; $BE0F 32 1b ba
    CALL $BE4B                            ; $BE12 cd 4b be
    CP $FF                                ; $BE15 fe ff
    JR NZ,$BE3A                           ; $BE17 20 21
    LD A,($BA1B)                          ; $BE19 3a 1b ba
    CALL $BE22                            ; $BE1C cd 22 be
    OR $01                                ; $BE1F f6 01
    RET                                   ; $BE21 c9
    CALL $D237                            ; $BE22 cd 37 d2
    PUSH IX                               ; $BE25 dd e5
    POP HL                                ; $BE27 e1
    BIT 6,(IX+$05)                        ; $BE28 dd cb 05 76
    LD DE,$9FF6                           ; $BE2C 11 f6 9f
    JR NZ,$BE34                           ; $BE2F 20 03
    LD DE,$9FFC                           ; $BE31 11 fc 9f
    LD BC,$0006                           ; $BE34 01 06 00
    LDIR                                  ; $BE37 ed b0
    RET                                   ; $BE39 c9
    SCF                                   ; $BE3A 37
    RET                                   ; $BE3B c9
    LD IX,($BA13)                         ; $BE3C dd 2a 13 ba
    LD HL,$B172                           ; $BE40 21 72 b1
    CALL $D36A                            ; $BE43 cd 6a d3
    LD ($BA13),IX                         ; $BE46 dd 22 13 ba | Conserva il cursore del soggetto anche in caso di fine o ambiguità: terminatore 8CB9 oppure secondo match.
    RET                                   ; $BE4A c9
    LD IX,($BA15)                         ; $BE4B dd 2a 15 ba
    LD HL,$B178                           ; $BE4F 21 78 b1
    CALL $D36A                            ; $BE52 cd 6a d3
    LD ($BA15),IX                         ; $BE55 dd 22 15 ba | Come BE46 per l’oggetto. Se il soggetto era ambiguo, il cursore oggetto resta iniziale.
    RET                                   ; $BE59 c9

    ORG $C388
; CODE: Glifi: otto scansioni, shift, indirizzo video e residui dei chiamanti
    PUSH AF                               ; $C388 f5
    PUSH BC                               ; $C389 c5
    PUSH DE                               ; $C38A d5
    PUSH HL                               ; $C38B e5 | PUSH HL salva l’indirizzo video. Con frame 5D1A la word finisce a 5D12: alto 5D13, derivato da colonna e riga.
    LD L,A                                ; $C38C 6f
    LD H,$00                              ; $C38D 26 00
    ADD HL,HL                             ; $C38F 29
    ADD HL,HL                             ; $C390 29
    ADD HL,HL                             ; $C391 29
    LD DE,$3C00                           ; $C392 11 00 3c
    ADD HL,DE                             ; $C395 19
    EX DE,HL                              ; $C396 eb
    POP HL                                ; $C397 e1
    PUSH HL                               ; $C398 e5
    LD B,$08                              ; $C399 06 08
    LD A,(DE)                             ; $C39B 1a
    PUSH BC                               ; $C39C c5 | Ogni scansione salva BC: l’ultima lascia B=1; C conserva lo shift del carattere.
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
    PUSH BC                               ; $C3B7 c5
    PUSH AF                               ; $C3B8 f5
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
    DJNZ $C39B                            ; $C3D2 10 c7 | Otto passaggi. Il frame mantiene i residui dell’ultima scansione anche dopo il ritorno.
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

    ORG $C8EF
; CODE: Argomenti: indice locazioni o entità; FE/FF conservano il puntatore
    LD A,($A034)                          ; $C8EF 3a 34 a0
    CP $FE                                ; $C8F2 fe fe
    JR NC,$C90C                           ; $C8F4 30 16 | FE/FF saltano il primo aggiornamento senza azzerare A013.
    LD A,($A00F)                          ; $C8F6 3a 0f a0
    CP $05                                ; $C8F9 fe 05 | Classe <5: record locazione tramite D224. Classe >=5: record entità tramite D237.
    LD A,($A034)                          ; $C8FB 3a 34 a0
    JR NC,$C905                           ; $C8FE 30 05
    CALL $D224                            ; $C900 cd 24 d2
    JR $C908                              ; $C903 18 03
    CALL $D237                            ; $C905 cd 37 d2
    LD ($A013),IX                         ; $C908 dd 22 13 a0 | Scrittura effettiva della word primo argomento; precede i controlli e il predicato della regola.
    LD A,($A035)                          ; $C90C 3a 35 a0
    CP $FE                                ; $C90F fe fe
    RET NC                                ; $C911 d0 | FE/FF nel secondo slot conservano A015.
    LD A,($A010)                          ; $C912 3a 10 a0
    CP $05                                ; $C915 fe 05
    LD A,($A035)                          ; $C917 3a 35 a0
    JR NC,$C921                           ; $C91A 30 05
    CALL $D224                            ; $C91C cd 24 d2
    JR $C924                              ; $C91F 18 03
    CALL $D237                            ; $C921 cd 37 d2
    LD ($A015),IX                         ; $C924 dd 22 15 a0 | Scrittura effettiva della word secondo argomento.
    RET                                   ; $C928 c9

    ORG $D04F
; CODE: Enumeratore entità: cursore iniziale tre byte prima della tabella
    LD IX,$8B6F                           ; $D04F dd 21 6f 8b
    DEC IX                                ; $D053 dd 2b
    DEC IX                                ; $D055 dd 2b
    DEC IX                                ; $D057 dd 2b
    RET                                   ; $D059 c9

    ORG $D9C5
; CODE: Lexer: salta numeri e punteggiatura; conserva il confronto lessicale
    PUSH DE                               ; $D9C5 d5
    LD A,(HL)                             ; $D9C6 7e
    INC HL                                ; $D9C7 23
    CP $20                                ; $D9C8 fe 20
    JR Z,$D9C6                            ; $D9CA 28 fa
    DEC HL                                ; $D9CC 2b
    LD ($A029),HL                         ; $D9CD 22 29 a0
    CP $0D                                ; $D9D0 fe 0d
    JR Z,$DA06                            ; $D9D2 28 32
    CALL $DAC6                            ; $D9D4 cd c6 da
    JR Z,$DA2F                            ; $D9D7 28 56 | Numeri e punteggiatura riconosciuti ritornano senza riscrivere DC13/DC14.
    CALL $DA34                            ; $D9D9 cd 34 da
    JR Z,$DA0A                            ; $D9DC 28 2c
    PUSH IX                               ; $D9DE dd e5
    XOR A                                 ; $D9E0 af
    LD ($DC14),A                          ; $D9E1 32 14 dc | Azzera il miglior prefisso soltanto quando inizia una ricerca alfabetica valida.
    LD ($D9C3),DE                         ; $D9E4 ed 53 c3 d9
    LD DE,($DA32)                         ; $D9E8 ed 5b 32 da
    AND A                                 ; $D9EC a7
    PUSH HL                               ; $D9ED e5
    SBC HL,DE                             ; $D9EE ed 52
    POP HL                                ; $D9F0 e1
    JR Z,$DA12                            ; $D9F1 28 1f
    PUSH HL                               ; $D9F3 e5
    POP DE                                ; $D9F4 d1
    CALL $A94D                            ; $D9F5 cd 4d a9
    LD A,(DE)                             ; $D9F8 1a
    AND $F0                               ; $D9F9 e6 f0
    CP $D0                                ; $D9FB fe d0
    JR Z,$D9E8                            ; $D9FD 28 e9
    CALL $DA7D                            ; $D9FF cd 7d da
    JR Z,$DA12                            ; $DA02 28 0e
    JR $D9E4                              ; $DA04 18 de
    LD A,$C0                              ; $DA06 3e c0
    JR $DA0C                              ; $DA08 18 02
    LD A,$D0                              ; $DA0A 3e d0
    LD BC,$0000                           ; $DA0C 01 00 00
    POP DE                                ; $DA0F d1
    LD D,A                                ; $DA10 57
    RET                                   ; $DA11 c9
    POP HL                                ; $DA12 e1
    LD A,($DC14)                          ; $DA13 3a 14 dc
    CP $04                                ; $DA16 fe 04
    JR NC,$DA21                           ; $DA18 30 07
    LD B,A                                ; $DA1A 47
    LD A,($DC13)                          ; $DA1B 3a 13 dc
    CP B                                  ; $DA1E b8
    JR NZ,$DA0A                           ; $DA1F 20 e9
    PUSH HL                               ; $DA21 e5
    LD HL,($D9C3)                         ; $DA22 2a c3 d9
    LD A,(HL)                             ; $DA25 7e
    AND $F0                               ; $DA26 e6 f0
    LD BC,$5DBF                           ; $DA28 01 bf 5d
    SBC HL,BC                             ; $DA2B ed 42
    EX (SP),HL                            ; $DA2D e3
    POP BC                                ; $DA2E c1
    POP DE                                ; $DA2F d1
    LD D,A                                ; $DA30 57
    RET                                   ; $DA31 c9

    ORG $DA34
; CODE: Lookup: lunghezza della parola e miglior prefisso, anche in parità
    LD A,(HL)                             ; $DA34 7e
    INC HL                                ; $DA35 23
    AND $1F                               ; $DA36 e6 1f
    RLCA                                  ; $DA38 07
    LD E,A                                ; $DA39 5f
    LD D,$00                              ; $DA3A 16 00
    PUSH HL                               ; $DA3C e5
    POP IX                                ; $DA3D dd e1
    LD HL,$5D80                           ; $DA3F 21 80 5d
    ADD HL,DE                             ; $DA42 19
    LD E,(HL)                             ; $DA43 5e
    INC HL                                ; $DA44 23
    LD D,(HL)                             ; $DA45 56
    INC HL                                ; $DA46 23
    PUSH DE                               ; $DA47 d5
    LD E,(HL)                             ; $DA48 5e
    INC HL                                ; $DA49 23
    LD D,(HL)                             ; $DA4A 56
    INC HL                                ; $DA4B 23
    LD A,D                                ; $DA4C 7a
    OR E                                  ; $DA4D b3
    JR Z,$DA48                            ; $DA4E 28 f8
    LD HL,$5DBF                           ; $DA50 21 bf 5d
    ADD HL,DE                             ; $DA53 19
    LD ($DA32),HL                         ; $DA54 22 32 da
    POP DE                                ; $DA57 d1
    LD A,D                                ; $DA58 7a
    OR E                                  ; $DA59 b3
    RET Z                                 ; $DA5A c8
    LD HL,$5DBF                           ; $DA5B 21 bf 5d
    ADD HL,DE                             ; $DA5E 19
    LD DE,$5C0B                           ; $DA5F 11 0b 5c
    LD B,$01                              ; $DA62 06 01 | B parte da 1: l’iniziale è già consumata, quindi la lunghezza finale include correttamente quella lettera.
    LD A,(IX+$00)                         ; $DA64 dd 7e 00
    CP $40                                ; $DA67 fe 40
    JR C,$DA74                            ; $DA69 38 09
    OR $20                                ; $DA6B f6 20
    LD (DE),A                             ; $DA6D 12
    INC DE                                ; $DA6E 13
    INC IX                                ; $DA6F dd 23
    INC B                                 ; $DA71 04
    JR $DA64                              ; $DA72 18 f0
    XOR A                                 ; $DA74 af
    LD (DE),A                             ; $DA75 12
    LD A,B                                ; $DA76 78
    LD ($DC13),A                          ; $DA77 32 13 dc | Salva la lunghezza della parola corrente, non quella della voce canonica o del sinonimo.
    OR $01                                ; $DA7A f6 01
    RET                                   ; $DA7C c9
    PUSH HL                               ; $DA7D e5
    PUSH DE                               ; $DA7E d5
    LD A,($DC13)                          ; $DA7F 3a 13 dc
    LD B,A                                ; $DA82 47
    LD A,($DC14)                          ; $DA83 3a 14 dc
    CP B                                  ; $DA86 b8
    JR NC,$DAA5                           ; $DA87 30 1c
    LD B,$01                              ; $DA89 06 01
    LD DE,$5C0B                           ; $DA8B 11 0b 5c
    LD HL,$5C42                           ; $DA8E 21 42 5c
    LD A,(DE)                             ; $DA91 1a
    AND A                                 ; $DA92 a7
    JR Z,$DA9D                            ; $DA93 28 08
    CP (HL)                               ; $DA95 be
    JR NZ,$DA9D                           ; $DA96 20 05
    INC HL                                ; $DA98 23
    INC DE                                ; $DA99 13
    INC B                                 ; $DA9A 04
    JR $DA91                              ; $DA9B 18 f4
    LD A,($DC14)                          ; $DA9D 3a 14 dc
    CP B                                  ; $DAA0 b8
    JR Z,$DAA9                            ; $DAA1 28 06
    JR C,$DAA9                            ; $DAA3 38 04
    POP DE                                ; $DAA5 d1
    POP HL                                ; $DAA6 e1
    XOR A                                 ; $DAA7 af
    RET                                   ; $DAA8 c9
    LD A,B                                ; $DAA9 78
    LD ($DC14),A                          ; $DAAA 32 14 dc | Salva il miglior prefisso; un pareggio può cambiare la voce selezionata.

    ORG $DC13
; DATA: Lookup: lunghezza e miglior prefisso dell’ultima parola cercata
    DEFB $00,$00                          ; $DC13 00 00 | DC13 lunghezza, DC14 miglior prefisso. Numeri e punteggiatura non reinizializzano questi byte.
