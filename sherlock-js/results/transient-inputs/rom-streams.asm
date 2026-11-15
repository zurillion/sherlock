; ROM: copia di dati di inizializzazione; nessuna esecuzione nel motore JS.

    ORG $0616
; CODE: Riserva lo spazio per uno o due header del nastro
    LD BC,$0011                           ; $0616 01 11 00
    LD A,($5C74)                          ; $0619 3a 74 5c
    AND A                                 ; $061C a7
    JR Z,$0621                            ; $061D 28 02
    LD C,$22                              ; $061F 0e 22
    RST $30                               ; $0621 f7

    ORG $0873
; CODE: Salva il puntatore al primo header e riserva spazio per il programma
    EX DE,HL                              ; $0873 eb
    LD HL,($5C59)                         ; $0874 2a 59 5c
    DEC HL                                ; $0877 2b
    LD ($5C5F),IX                         ; $0878 dd 22 5f 5c
    LD C,(IX+$0B)                         ; $087C dd 4e 0b
    LD B,(IX+$0C)                         ; $087F dd 46 0c
    PUSH BC                               ; $0882 c5
    CALL $19E5                            ; $0883 cd e5 19
    POP BC                                ; $0886 c1
    PUSH HL                               ; $0887 e5
    PUSH BC                               ; $0888 c5
    CALL $1655                            ; $0889 cd 55 16
    LD IX,($5C5F)                         ; $088C dd 2a 5f 5c

    ORG $1235
; CODE: Carica i canali iniziali, DATADD, PROG e VARS
    LD HL,$5CB6                           ; $1235 21 b6 5c
    LD ($5C4F),HL                         ; $1238 22 4f 5c
    LD DE,$15AF                           ; $123B 11 af 15
    LD BC,$0015                           ; $123E 01 15 00
    EX DE,HL                              ; $1241 eb
    LDIR                                  ; $1242 ed b0
    EX DE,HL                              ; $1244 eb
    DEC HL                                ; $1245 2b
    LD ($5C57),HL                         ; $1246 22 57 5c
    INC HL                                ; $1249 23
    LD ($5C53),HL                         ; $124A 22 53 5c
    LD ($5C4B),HL                         ; $124D 22 4b 5c
    LD (HL),$80                           ; $1250 36 80

    ORG $127C
; CODE: Copia 14 byte da 15C6 a 5C10 prima del gioco
    LD HL,$15C6                           ; $127C 21 c6 15
    LD DE,$5C10                           ; $127F 11 10 5c
    LD BC,$000E                           ; $1282 01 0e 00
    LDIR                                  ; $1285 ed b0

    ORG $15AF
; DATA: Canali iniziali e terminatore, sorgente di PROG
    DEFB $F4,$09,$A8,$10,$4B,$F4,$09,$C4  ; $15AF f4 09 a8 10 4b f4 09 c4
    DEFB $15,$53,$81,$0F,$C4,$15,$52,$F4  ; $15B7 15 53 81 0f c4 15 52 f4
    DEFB $09,$C4,$15,$50,$80              ; $15BF 09 c4 15 50 80

    ORG $15C6
; DATA: Mappa iniziale degli stream, successivamente riutilizzata dal buffer di parola
    DEFB $01,$00,$06,$00,$0B,$00,$01,$00  ; $15C6 01 00 06 00 0b 00 01 00
    DEFB $01,$00,$06,$00,$10,$00          ; $15CE 01 00 06 00 10 00

    ORG $1664
; CODE: Rialloca i puntatori BASIC oltre la posizione di inserimento
    PUSH AF                               ; $1664 f5
    PUSH HL                               ; $1665 e5
    LD HL,$5C4B                           ; $1666 21 4b 5c
    LD A,$0E                              ; $1669 3e 0e
    LD E,(HL)                             ; $166B 5e
    INC HL                                ; $166C 23
    LD D,(HL)                             ; $166D 56
    EX (SP),HL                            ; $166E e3
    AND A                                 ; $166F a7
    SBC HL,DE                             ; $1670 ed 52
    ADD HL,DE                             ; $1672 19
    EX (SP),HL                            ; $1673 e3
    JR NC,$167F                           ; $1674 30 09
    PUSH DE                               ; $1676 d5
    EX DE,HL                              ; $1677 eb
    ADD HL,BC                             ; $1678 09
    EX DE,HL                              ; $1679 eb
    LD (HL),D                             ; $167A 72
    DEC HL                                ; $167B 2b
    LD (HL),E                             ; $167C 73
    INC HL                                ; $167D 23
    POP DE                                ; $167E d1
    INC HL                                ; $167F 23
    DEC A                                 ; $1680 3d
    JR NZ,$166B                           ; $1681 20 e8

    ORG $169E
; CODE: Riserva spazio e ripristina WORKSP
    LD HL,($5C63)                         ; $169E 2a 63 5c
    DEC HL                                ; $16A1 2b
    CALL $1655                            ; $16A2 cd 55 16
    INC HL                                ; $16A5 23
    INC HL                                ; $16A6 23
    POP BC                                ; $16A7 c1
    LD ($5C61),BC                         ; $16A8 ed 43 61 5c
    POP BC                                ; $16AC c1

    ORG $16B0
; CODE: Inizializza l’editor e riallinea la pila di calcolo
    LD HL,($5C59)                         ; $16B0 2a 59 5c
    LD (HL),$0D                           ; $16B3 36 0d
    LD ($5C5B),HL                         ; $16B5 22 5b 5c
    INC HL                                ; $16B8 23
    LD (HL),$80                           ; $16B9 36 80
    INC HL                                ; $16BB 23
    LD ($5C61),HL                         ; $16BC 22 61 5c
    LD HL,($5C61)                         ; $16BF 2a 61 5c
    LD ($5C63),HL                         ; $16C2 22 63 5c
    LD HL,($5C63)                         ; $16C5 2a 63 5c
    LD ($5C65),HL                         ; $16C8 22 65 5c
    PUSH HL                               ; $16CB e5
    LD HL,$5C92                           ; $16CC 21 92 5c
    LD ($5C68),HL                         ; $16CF 22 68 5c

    ORG $1BCA
; CODE: Calcola NXTLIN dalla lunghezza della riga BASIC
    INC HL                                ; $1BCA 23
    LD E,(HL)                             ; $1BCB 5e
    INC HL                                ; $1BCC 23
    LD D,(HL)                             ; $1BCD 56
    EX DE,HL                              ; $1BCE eb
    ADD HL,DE                             ; $1BCF 19
    INC HL                                ; $1BD0 23
    LD ($5C55),HL                         ; $1BD1 22 55 5c
    EX DE,HL                              ; $1BD4 eb
    LD ($5C5D),HL                         ; $1BD5 22 5d 5c

    ORG $26B5
; CODE: Dopo il numero in BASIC salva la nuova posizione CH-ADD
    RST $18                               ; $26B5 df
    INC HL                                ; $26B6 23
    LD A,(HL)                             ; $26B7 7e
    CP $0E                                ; $26B8 fe 0e
    JR NZ,$26B6                           ; $26BA 20 fa
    INC HL                                ; $26BC 23
    CALL $33B4                            ; $26BD cd b4 33
    LD ($5C5D),HL                         ; $26C0 22 5d 5c
    SET 6,(IY+$01)                        ; $26C3 fd cb 01 f6
    JR $26DD                              ; $26C7 18 14

    ORG $26ED
; CODE: Converte il token BASIC USR in un identificatore del calcolatore
    SUB $AF                               ; $26ED d6 af
    JP C,$1C8A                            ; $26EF da 8a 1c
    LD BC,$04F0                           ; $26F2 01 f0 04
    CP $14                                ; $26F5 fe 14
    JR Z,$270D                            ; $26F7 28 14
    JP NC,$1C8A                           ; $26F9 d2 8a 1c
    LD B,$10                              ; $26FC 06 10
    ADD A,$DC                             ; $26FE c6 dc
    LD C,A                                ; $2700 4f

    ORG $2752
; CODE: Maschera il codice dell’operazione e invoca RST 28
    LD A,E                                ; $2752 7b
    AND $3F                               ; $2753 e6 3f
    LD B,A                                ; $2755 47
    RST $28                               ; $2756 ef

    ORG $335E
; CODE: Conserva il codice dell’operazione in BREG
    LD A,B                                ; $335E 78
    LD ($5C67),A                          ; $335F 32 67 5c
