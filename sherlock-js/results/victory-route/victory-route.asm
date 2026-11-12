; Dossier verificato sul payload originale.

    ORG $9965
; DATA: Prova dell’innocenza del maggiore
    DEFB $07,$04,$62,$A4,$3D,$9A,$07,$06,$63,$8C,$00,$00,$00,$08 ; $9965 07 04 62 a4 3d 9a 07 06 63 8c 00 00 00 08 | La conclusione dipende dalla visita del maggiore alla fumeria. La confessione aggiorna la premessa; Lestrade accetta la deduzione quando può parlarne con Holmes.

    ORG $9973
; DATA: Prove del suicidio di Mrs Brown
    DEFB $5E,$05,$60,$A4,$4B,$9A,$2E,$00,$39,$40,$5D,$00,$5D,$08 ; $9973 5e 05 60 a4 4b 9a 2e 00 39 40 5d 00 5d 08 | Richiede cadavere e ponte esaminati, poi la pietra osservata. La nota sul cadavere è un indizio distinto.

    ORG $9981
; DATA: Prove dell’omicidio di Tricia
    DEFB $5F,$05,$0D,$A4,$59,$9A,$48,$00,$42,$40,$43,$00,$43,$40,$00,$00,$00,$00,$00,$00,$00,$08 ; $9981 5f 05 0d a4 59 9a 48 00 42 40 43 00 43 40 00 00 00 00 00 00 00 08 | Richiede corpo, libreria e abiti esaminati, più le premesse modificate dalla confessione di Mrs Jones.

    ORG $9997
; DATA: Prove che Basil possiede i piani
    DEFB $06,$03,$61,$A4,$13,$9A,$57,$00,$58,$40,$5A,$00,$53,$40,$51,$00,$51,$48 ; $9997 06 03 61 a4 13 9a 57 00 58 40 5a 00 53 40 51 00 51 48 | Richiede esame di nota incompiuta, cartella, lettere e delle due note cifrate.

    ORG $99A9
; DATA: Prove del luogo della vendita
    DEFB $6A,$04,$69,$A4,$FC,$99,$00,$00,$00,$00,$55,$00,$55,$40,$00,$00,$00,$0A ; $99A9 6a 04 69 a4 fc 99 00 00 00 00 55 00 55 40 00 00 00 0a | Richiede il presupposto impostato da 9A27, l’esame della nota recuperata dal fuoco e che il conto alla rovescia non l’abbia fatta bruciare.

    ORG $9A13
; CODE: Accettazione dei piani subordinata ai due omicidi
    LD A,($9976)                          ; $9A13 3a 76 99 | Prova entrambe le conclusioni su Mrs Brown e Tricia. Se una manca, il ramo 9A2F ritira l’ipotesi corrente.
    AND $02                               ; $9A16 e6 02
    JR Z,$9A2F                            ; $9A18 28 15
    LD A,($9984)                          ; $9A1A 3a 84 99
    AND $02                               ; $9A1D e6 02
    JR Z,$9A2F                            ; $9A1F 28 0e
    CALL $9A74                            ; $9A21 cd 74 9a
    LD HL,$99B2                           ; $9A24 21 b2 99
    SET 1,(HL)                            ; $9A27 cb ce | Abilita la premessa della deduzione successiva sul luogo della vendita.
    LD HL,$7099                           ; $9A29 21 99 70
    JP $A59F                              ; $9A2C c3 9f a5
    RES 1,(IX+$03)                        ; $9A2F dd cb 03 8e
    RES 0,(IX+$03)                        ; $9A33 dd cb 03 86
    LD HL,$7265                           ; $9A37 21 65 72
    JP $A59F                              ; $9A3A c3 9f a5

    ORG $9E4A
; CODE: Finale di Victoria: presenza di Watson e Lestrade
    LD HL,$6B79                           ; $9E4A 21 79 6b | Prepara il testo 6B79. Con Watson (3) e Lestrade (2) nella stanza di Holmes seleziona 6AF3.
    LD A,$03                              ; $9E4D 3e 03
    CALL $9E60                            ; $9E4F cd 60 9e
    JR NZ,$9E74                           ; $9E52 20 20
    LD A,$02                              ; $9E54 3e 02
    CALL $9E60                            ; $9E56 cd 60 9e
    JR NZ,$9E74                           ; $9E59 20 19
    LD HL,$6AF3                           ; $9E5B 21 f3 6a
    JR $9E74                              ; $9E5E 18 14
    CALL $D237                            ; $9E60 cd 37 d2
    LD A,($A009)                          ; $9E63 3a 09 a0
    CP (IX+$0F)                           ; $9E66 dd be 0f
    RET                                   ; $9E69 c9

    ORG $D078
; CODE: Controllo di luce e lampada percepibile
    PUSH IX                               ; $D078 dd e5
    PUSH IY                               ; $D07A fd e5
    PUSH BC                               ; $D07C c5
    LD IX,($A017)                         ; $D07D dd 2a 17 a0
    LD A,(IX+$04)                         ; $D081 dd 7e 04
    AND $80                               ; $D084 e6 80
    JR Z,$D0C6                            ; $D086 28 3e
    CALL $C86E                            ; $D088 cd 6e c8
    INC A                                 ; $D08B 3c
    JR NZ,$D09E                           ; $D08C 20 10
    CALL $D33C                            ; $D08E cd 3c d3
    BIT 7,(IX+$00)                        ; $D091 dd cb 00 7e
    JR NZ,$D0C6                           ; $D095 20 2f
    CALL $C00C                            ; $D097 cd 0c c0
    CP $01                                ; $D09A fe 01
    JR NZ,$D0C6                           ; $D09C 20 28
    LD IX,$8B6F                           ; $D09E dd 21 6f 8b | Scorre le entità dopo il controllo di fascia oraria e cerca una sorgente di luce percepibile.
    CALL $D206                            ; $D0A2 cd 06 d2
    JR Z,$D0C9                            ; $D0A5 28 22
    LD A,(IY+$00)                         ; $D0A7 fd 7e 00
    CP $01                                ; $D0AA fe 01
    JR NZ,$D0A2                           ; $D0AC 20 f4
    LD A,(IY+$05)                         ; $D0AE fd 7e 05
    XOR $B7                               ; $D0B1 ee b7
    AND $5C                               ; $D0B3 e6 5c
    JR NZ,$D0A2                           ; $D0B5 20 eb
    LD A,(IY+$04)                         ; $D0B7 fd 7e 04
    AND $80                               ; $D0BA e6 80
    JR Z,$D0A2                            ; $D0BC 28 e4
    LD A,(IX+$00)                         ; $D0BE dd 7e 00
    CALL $C821                            ; $D0C1 cd 21 c8
    JR Z,$D0A2                            ; $D0C4 28 dc
    AND A                                 ; $D0C6 a7
    JR $D0CA                              ; $D0C7 18 01
    SCF                                   ; $D0C9 37
    POP BC                                ; $D0CA c1
    POP IY                                ; $D0CB fd e1
    POP IX                                ; $D0CD dd e1
    RET                                   ; $D0CF c9
    PUSH DE                               ; $D0D0 d5
    LD DE,$68DE                           ; $D0D1 11 de 68
    EX DE,HL                              ; $D0D4 eb
    SET 7,D                               ; $D0D5 cb fa
    LD (HL),D                             ; $D0D7 72
    INC HL                                ; $D0D8 23
    LD (HL),E                             ; $D0D9 73
    POP DE                                ; $D0DA d1
    RET                                   ; $D0DB c9

    ORG $EA25
; BYTECODE: Lestrade attende le due deduzioni prima di partire
    DEFB $0F                              ; $EA25 0f
    DEFB $C2,$88,$15,$FF,$A9,$EA          ; $EA26 c2 88 15 ff a9 ea
    DEFB $53,$19,$EB,$25,$EA              ; $EA2C 53 19 eb 25 ea | EB19 prova il flag della conclusione sui piani. Il ramo di fallimento attende e torna a verificare.
    DEFB $C3,$11,$EB,$5B,$EA              ; $EA31 c3 11 eb 5b ea | EB11 prova il flag sul luogo della vendita. Il successo passa a EA5B, poi il programma segnala a Straker di partire.
    DEFB $C2,$88,$15,$FF,$A9,$EA          ; $EA36 c2 88 15 ff a9 ea
    DEFB $0F                              ; $EA3C 0f
    DEFB $C2,$81,$FB,$00,$31,$EA          ; $EA3D c2 81 fb 00 31 ea
    DEFB $C3,$11,$EB,$5B,$EA              ; $EA43 c3 11 eb 5b ea
    DEFB $C2,$88,$15,$FF,$A9,$EA          ; $EA48 c2 88 15 ff a9 ea
    DEFB $0F                              ; $EA4E 0f
    DEFB $52,$81,$FB,$00,$43,$EA          ; $EA4F 52 81 fb 00 43 ea
    DEFB $C5,$00,$C0,$70,$31,$EA          ; $EA55 c5 00 c0 70 31 ea
    DEFB $41,$04                          ; $EA5B 41 04
    DEFB $48,$04                          ; $EA5D 48 04

    ORG $EAF6
; DATA: Intestazione della regola del cab di polizia
    DEFB $07,$07                          ; $EAF6 07 07

    ORG $EAF8
; CODE: Cab di polizia e conducente collocati in Main Street
    LD A,($A034)                          ; $EAF8 3a 34 a0 | Il secondo argomento diventa passeggero del primo. Entrambi ricevono la stanza $32, Main Street.
    LD IX,($A015)                         ; $EAFB dd 2a 15 a0
    LD (IX+$01),A                         ; $EAFF dd 77 01
    LD (IX+$0F),$32                       ; $EB02 dd 36 0f 32
    LD IX,($A013)                         ; $EB06 dd 2a 13 a0
    LD (IX+$0F),$32                       ; $EB0A dd 36 0f 32
    OR $01                                ; $EB0E f6 01
    RET                                   ; $EB10 c9

    ORG $EB11
; DATA: Intestazione del predicato sul luogo della vendita
    DEFB $00,$00                          ; $EB11 00 00

    ORG $EB13
; CODE: Controlla la deduzione sul luogo della vendita
    LD IX,$99A9                           ; $EB13 dd 21 a9 99 | Seleziona il fatto 99A9 e riusa il test comune a EB1F.
    JR $EB1F                              ; $EB17 18 06

    ORG $EB19
; DATA: Intestazione del predicato sui piani
    DEFB $00,$00                          ; $EB19 00 00

    ORG $EB1B
; CODE: Controlla la deduzione sul possesso dei piani
    LD IX,$9997                           ; $EB1B dd 21 97 99 | Seleziona il fatto 9997. BIT 1 legge il flag della prova confermata, senza modificare il record.
    LD HL,$0000                           ; $EB1F 21 00 00
    AND A                                 ; $EB22 a7
    BIT 1,(IX+$03)                        ; $EB23 dd cb 03 4e
    RET                                   ; $EB27 c9

    ORG $EF7A
; BYTECODE: Basil a Victoria: incontro con Holmes e finale
    DEFB $07,$A4,$EB,$FF,$1C              ; $EF7A 07 a4 eb ff 1c | Attiva il percorso verso la locazione $1C, Buckingham Palace Road.
    DEFB $01,$03                          ; $EF7F 01 03
    DEFB $01,$03                          ; $EF81 01 03
    DEFB $12,$81,$FB,$00,$8C,$EF          ; $EF83 12 81 fb 00 8c ef | Confronta la posizione di Basil con l’identità esplicita 0. Il ramo con Holmes presente chiama il selettore 9E48.
    DEFB $03,$48,$9E                      ; $EF89 03 48 9e
