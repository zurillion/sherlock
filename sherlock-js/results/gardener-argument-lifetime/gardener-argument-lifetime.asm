; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.

    ORG $CC78
; CODE: Ingresso di ogni passo DOMAIN: ricarica gli argomenti di lavoro dalla riga o dal contesto
    CALL $CC5A                            ; $CC78 cd 5a cc
    LD IY,($9FDB)                         ; $CC7B fd 2a db 9f
    CALL $D008                            ; $CC7F cd 08 d0 | D008 carica i tre argomenti nella zona di lavoro9FD6–9FD8. La riga persistente non è un alias della zona di lavoro.
    LD L,(IY+$01)                         ; $CC82 fd 6e 01
    LD H,(IY+$02)                         ; $CC85 fd 66 02
    XOR A                                 ; $CC88 af
    LD ($B934),A                          ; $CC89 32 34 b9
    LD A,($CC0B)                          ; $CC8C 3a 0b cc
    CP $0A                                ; $CC8F fe 0a
    JP Z,$CD8B                            ; $CC91 ca 8b cd

    ORG $CA48
; CODE: Binding prima del corpo: riempie gli slot FF solo negli argomenti di lavoro
    LD A,($9FD7)                          ; $CA48 3a d7 9f | Il binding di uno slot FF avviene prima del body. Un body fallito può lasciare33 negli argomenti di lavoro senza aver aggiornato la riga attore.
    INC A                                 ; $CA4B 3c
    JR NZ,$CA54                           ; $CA4C 20 06
    LD A,($A034)                          ; $CA4E 3a 34 a0
    LD ($9FD7),A                          ; $CA51 32 d7 9f | Writer dell’argomento di lavoro1, non del byte+4 della riga attore.
    LD A,($9FD8)                          ; $CA54 3a d8 9f
    INC A                                 ; $CA57 3c
    JR NZ,$CA60                           ; $CA58 20 06
    LD A,($A035)                          ; $CA5A 3a 35 a0
    LD ($9FD8),A                          ; $CA5D 32 d8 9f | Analogo binding dell’argomento2 soltanto se lo slot eraFF.
    XOR A                                 ; $CA60 af
    LD ($CAAE),A                          ; $CA61 32 ae ca
    CALL $CB2C                            ; $CA64 cd 2c cb
    PUSH AF                               ; $CA67 f5
    PUSH HL                               ; $CA68 e5
    CALL $CA7F                            ; $CA69 cd 7f ca
    LD A,($CAAE)                          ; $CA6C 3a ae ca
    AND A                                 ; $CA6F a7
    CALL Z,$CAAF                          ; $CA70 cc af ca
    POP HL                                ; $CA73 e1
    POP AF                                ; $CA74 f1
    RET                                   ; $CA75 c9

    ORG $CE8F
; CODE: Successo e fallimento: commit, ramo interno oppure costo forzato
    CALL $CE83                            ; $CE8F cd 83 ce | Successo: dopo il ramo esegue CD91/D026, anche se il costo è zero.
    CALL $CF03                            ; $CE92 cd 03 cf
    BIT 7,(IX+$00)                        ; $CE95 dd cb 00 7e
    JR Z,$CEA1                            ; $CE99 28 06
    LD E,(HL)                             ; $CE9B 5e
    INC HL                                ; $CE9C 23
    LD D,(HL)                             ; $CE9D 56
    EX DE,HL                              ; $CE9E eb
    JR $CEA8                              ; $CE9F 18 07
    BIT 4,(IX+$00)                        ; $CEA1 dd cb 00 66
    CALL NZ,$CF40                         ; $CEA5 c4 40 cf
    BIT 5,(IX+$00)                        ; $CEA8 dd cb 00 6e
    CALL NZ,$CF43                         ; $CEAC c4 43 cf
    LD (IY+$01),L                         ; $CEAF fd 75 01
    LD (IY+$02),H                         ; $CEB2 fd 74 02
    JP $CD91                              ; $CEB5 c3 91 cd
    LD HL,$CC0B                           ; $CEB8 21 0b cc | Fallimento: conserva gli argomenti di lavoro per il ramo successivo. Non esegue qui un commit della riga.
    INC (HL)                              ; $CEBB 34
    CALL $CE83                            ; $CEBC cd 83 ce
    CALL $CEFE                            ; $CEBF cd fe ce
    BIT 4,(IX+$00)                        ; $CEC2 dd cb 00 66
    JR Z,$CECC                            ; $CEC6 28 04
    LD E,(HL)                             ; $CEC8 5e
    INC HL                                ; $CEC9 23
    LD D,(HL)                             ; $CECA 56
    EX DE,HL                              ; $CECB eb
    LD (IY+$01),L                         ; $CECC fd 75 01
    LD (IY+$02),H                         ; $CECF fd 74 02
    PUSH IX                               ; $CED2 dd e5
    POP DE                                ; $CED4 d1
    AND A                                 ; $CED5 a7
    SBC HL,DE                             ; $CED6 ed 52
    JP Z,$CD8B                            ; $CED8 ca 8b cd | Soltanto l’autoloop fallito passa daCD8B e quindi esegue il commit con costo1; il ramo non ciclico prosegue daCC82.
    JP $CC82                              ; $CEDB c3 82 cc | Ramo fallito interno: non ricarica conD008 e non salva conD026. I successivi test vedono gli slot di lavoro già riempiti.

    ORG $CD82
; CODE: Yield temporale e punto comune di commit degli argomenti
    LD HL,$0001                           ; $CD82 21 01 00
    LD ($A01F),HL                         ; $CD85 22 1f a0
    JP $CE8F                              ; $CD88 c3 8f ce
    LD HL,$0001                           ; $CD8B 21 01 00 | Costo forzato1 e commit. La riga riceve gli argomenti di lavoro anche dopo un fallimento in autoloop.
    LD ($A01F),HL                         ; $CD8E 22 1f a0
    CALL $D026                            ; $CD91 cd 26 d0 | Punto di commit D026: separare il successo di un body dalla precedente mutazione dei suoi argomenti.
    RET                                   ; $CD94 c9

    ORG $CF80
; CODE: Sottosequenza: salva un nuovo contesto senza aggiornare la riga attore
    PUSH IX                               ; $CF80 dd e5 | Avvio sottosequenza. Se raggiunto dopo due body falliti, il binding temporaneo non diventa un aggiornamento della riga radice.
    LD A,$07                              ; $CF82 3e 07
    CALL $A11C                            ; $CF84 cd 1c a1
    LD A,($A036)                          ; $CF87 3a 36 a0
    LD (IX+$00),A                         ; $CF8A dd 77 00
    LD (IX+$01),L                         ; $CF8D dd 75 01
    LD (IX+$02),H                         ; $CF90 dd 74 02
    LD DE,($A034)                         ; $CF93 ed 5b 34 a0 | Il nuovo contesto salva gli argomenti correntiA034/A035 della sottosequenza, distinti da9FD7/9FD8 e dai byte della riga attore.
    LD (IX+$03),E                         ; $CF97 dd 73 03
    LD (IX+$04),D                         ; $CF9A dd 72 04
    LD (IX+$05),B                         ; $CF9D dd 70 05
    LD A,($9FD6)                          ; $CFA0 3a d6 9f
    LD (IX+$06),A                         ; $CFA3 dd 77 06
    LD HL,($9FE9)                         ; $CFA6 2a e9 9f
    LD ($9FE9),IX                         ; $CFA9 dd 22 e9 9f
    LD (IX-$02),L                         ; $CFAD dd 75 fe
    LD (IX-$01),H                         ; $CFB0 dd 74 ff
    POP IX                                ; $CFB3 dd e1
    RET                                   ; $CFB5 c9

    ORG $CFCF
; CODE: Ritorno dal contesto e distinzione fra lettura D008 e commit D026
    CALL $CFB6                            ; $CFCF cd b6 cf
    LD E,(IX+$01)                         ; $CFD2 dd 5e 01
    LD D,(IX+$02)                         ; $CFD5 dd 56 02
    LD ($9FD9),DE                         ; $CFD8 ed 53 d9 9f
    LD (IY+$01),E                         ; $CFDC fd 73 01
    LD (IY+$02),D                         ; $CFDF fd 72 02
    PUSH IX                               ; $CFE2 dd e5
    POP DE                                ; $CFE4 d1
    PUSH IY                               ; $CFE5 fd e5
    LD IY,$9FE9                           ; $CFE7 fd 21 e9 9f
    CALL $A104                            ; $CFEB cd 04 a1
    LD L,(IX-$02)                         ; $CFEE dd 6e fe
    LD H,(IX-$01)                         ; $CFF1 dd 66 ff
    LD (IY-$02),L                         ; $CFF4 fd 75 fe
    LD (IY-$01),H                         ; $CFF7 fd 74 ff
    LD A,(IX+$05)                         ; $CFFA dd 7e 05
    PUSH AF                               ; $CFFD f5
    CALL $A1C7                            ; $CFFE cd c7 a1
    CALL $D008                            ; $D001 cd 08 d0
    POP AF                                ; $D004 f1
    POP IY                                ; $D005 fd e1
    RET                                   ; $D007 c9
    LD L,(IY+$04)                         ; $D008 fd 6e 04 | Lettura degli argomenti: seleziona contesto attivo o riga attore. Non è un commit.
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
    LD HL,($9FD7)                         ; $D026 2a d7 9f | Commit degli argomenti di lavoro: contesto dell’attore se esiste, altrimenti riga. Non chiamato a ogni singolo binding.
    CALL $CFB6                            ; $D029 cd b6 cf
    LD A,($9FD6)                          ; $D02C 3a d6 9f
    JR Z,$D03B                            ; $D02F 28 0a
    LD (IX+$03),L                         ; $D031 dd 75 03
    LD (IX+$04),H                         ; $D034 dd 74 04
    LD (IX+$06),A                         ; $D037 dd 77 06
    RET                                   ; $D03A c9
    LD (IY+$03),A                         ; $D03B fd 77 03
    LD (IY+$04),L                         ; $D03E fd 75 04 | Writer reale dell’argomento1 della riga attore: nella prova naturale il valore rimaneFF mentre9FD7 contiene33.
    LD (IY+$05),H                         ; $D041 fd 74 05
    RET                                   ; $D044 c9

    ORG $ED6A
; DATA: Programma giardiniere: due test di probabilità e sottosequenza di movimento
    DEFB $87,$98,$F1,$21,$FF,$8F,$ED,$87  ; $ED6A 87 98 f1 21 ff 8f ed 87 | Dati DOMAIN, non assembler: test percentuale33, se fallisce prosegue al test50, poi una sottosequenza di movimento. Nessuna costante33→FF nel runtime.
    DEFB $98,$F1,$32,$FF,$AA,$ED,$02,$8B  ; $ED72 98 f1 32 ff aa ed 02 8b
    DEFB $02,$14                          ; $ED7A 02 14
