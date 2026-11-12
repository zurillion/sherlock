; Dossier verificato sul payload originale.

    ORG $9E74
; CODE: Stampa, pausa e chiusura del finale
    LD A,$01                              ; $9E74 3e 01
    LD ($5C3C),A                          ; $9E76 32 3c 5c
    CALL $A59F                            ; $9E79 cd 9f a5
    CALL $C306                            ; $9E7C cd 06 c3 | Pausa dopo il testo terminale. La conferma precede il passaggio alla chiusura B0AC.
    CALL $A296                            ; $9E7F cd 96 a2
    JP $B0AC                              ; $9E82 c3 ac b0

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

    ORG $A9D7
; CODE: Scrittura della parola grezza nel buffer
    LD (HL),A                             ; $A9D7 77 | I nomi propri di stanza negli ingressi brevi e le direzioni lessicali dei passaggi scrivono i caratteri grezzi. Entranc(e) lascia il byte a 5C12 e northeas(t) a 5C13.
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9

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
    CALL $C388                            ; $C293 cd 88 c3 | Il frame di pulizia conserva AF di scansione, BC di scansione e HL video a 5D2C–5D31.
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
    PUSH AF                               ; $D3E8 f5
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
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $DFCC
; CODE: Finale selezionato dalla presenza di Basil
    LD HL,$759C                           ; $DFCC 21 9c 75
    LD A,$06                              ; $DFCF 3e 06
    CALL $D237                            ; $DFD1 cd 37 d2
    LD A,($A009)                          ; $DFD4 3a 09 a0
    CP (IX+$0F)                           ; $DFD7 dd be 0f | Confronta la stanza di Holmes con quella di Basil. Se coincidono seleziona il testo 75D2, altrimenti 759C.
    JP NZ,$9E74                           ; $DFDA c2 74 9e
    LD HL,$75D2                           ; $DFDD 21 d2 75 | Ramo osservato nella camera di Basil mercoledì alle 06:07 con seed 1. 9E74 stampa e termina la partita.
    JP $9E74                              ; $DFE0 c3 74 9e

    ORG $E6BE
; CODE: Stampa della richiesta di pagamento del cocchiere
    LD A,($A035)                          ; $E6BE 3a 35 a0
    CALL $E619                            ; $E6C1 cd 19 e6
    JR Z,$E6E3                            ; $E6C4 28 1d
    LD E,(IX+$09)                         ; $E6C6 dd 5e 09
    LD D,(IX+$0A)                         ; $E6C9 dd 56 0a
    LD HL,$6BB7                           ; $E6CC 21 b7 6b | 6BB7 stampa la richiesta di pagamento. La chiamata del nome del destinatario scarica il precedente to.
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

    ORG $EBC5
; BYTECODE: Lestrade: attesa della posizione del veicolo
    DEFB $52,$83,$FB                      ; $EBC5 52 83 fb | Lestrade aspetta che il proprio veicolo soddisfi la condizione di posizione. Nel ramo passivo osservato resta in questo punto.
    DEFB $FC,$C5,$EB                      ; $EBC8 fc c5 eb

    ORG $EF90
; BYTECODE: Basil fuori scena: attesa e salto all’indietro
    DEFB $03,$A8,$E5                      ; $EF90 03 a8 e5 | DOMAIN 03 A8 E5 attende un tick. 0E 90 EF salta di nuovo a EF90. Nella variante passiva Basil resta qui anche la settimana seguente.
    DEFB $0E,$90,$EF                      ; $EF93 0e 90 ef

    ORG $EFC7
; DATA: Intestazione della regola di Basil
    DEFB $00,$00                          ; $EFC7 00 00

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
