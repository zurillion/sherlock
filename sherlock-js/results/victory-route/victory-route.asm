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

    ORG $7DE1
; DATA: Descrizione del cab in viaggio: lampioni oppure sole
    DEFB $10,$C8,$F4,$60,$C8,$61,$65,$F5,$1B,$68,$62,$83,$CE,$D1,$64,$2C,$17,$02,$CF,$FF,$60,$88,$72,$20,$45,$9A,$12,$E2,$CC,$88,$CE,$60,$C9,$BB,$86,$07,$89,$F2,$82,$DD,$2E,$1F ; $7DE1 10 c8 f4 60 c8 61 65 f5 1b 68 62 83 ce d1 64 2c 17 02 cf ff 60 88 72 20 45 9a 12 e2 cc 88 ce 60 c9 bb 86 07 89 f2 82 dd 2e 1f | Il token 17 a 7DF1 condiziona il salto 02 a 7DF2. Di notte termina il frammento corrente a favore del testo dei lampioni a 7DC1.

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

    ORG $A679
; CODE: Salto relativo terminale del decoder
    LD E,(IX+$01)                         ; $A679 dd 5e 01 | Sposta il cursore del decoder nel frammento di destinazione e restituisce zero al passo corrente. Il testo del chiamante non riprende dopo il salto.
    LD D,(IX+$02)                         ; $A67C dd 56 02
    DEC DE                                ; $A67F 1b
    ADD IX,DE                             ; $A680 dd 19
    XOR A                                 ; $A682 af
    RET                                   ; $A683 c9

    ORG $A6AC
; CODE: Condizione notturna e scansione del token saltato
    CALL $C00C                            ; $A6AC cd 0c c0 | Con classe 1 prosegue nel token successivo. Con le altre classi A6B2 scavalca il salto e rimane nel testo del sole.
    CP $01                                ; $A6AF fe 01
    RET Z                                 ; $A6B1 c8
    INC IX                                ; $A6B2 dd 23
    CALL $A6BB                            ; $A6B4 cd bb a6
    DEC IX                                ; $A6B7 dd 2b
    XOR A                                 ; $A6B9 af
    RET                                   ; $A6BA c9
    LD A,(IX+$00)                         ; $A6BB dd 7e 00
    BIT 7,A                               ; $A6BE cb 7f
    JR NZ,$A6CC                           ; $A6C0 20 0a
    CP $02                                ; $A6C2 fe 02
    JR Z,$A6CA                            ; $A6C4 28 04
    CP $0B                                ; $A6C6 fe 0b
    JR NZ,$A6CE                           ; $A6C8 20 04
    INC IX                                ; $A6CA dd 23
    INC IX                                ; $A6CC dd 23
    INC IX                                ; $A6CE dd 23
    RET                                   ; $A6D0 c9

    ORG $B049
; CODE: Accodamento e ricerca del delimitatore della citazione
    BIT 1,E                               ; $B049 cb 4b
    JR Z,$B058                            ; $B04B 28 0b
    LD HL,$088B                           ; $B04D 21 8b 08
    LD (IY+$00),L                         ; $B050 fd 75 00
    LD (IY+$01),H                         ; $B053 fd 74 01
    RES 1,E                               ; $B056 cb 8b
    PUSH HL                               ; $B058 e5
    PUSH DE                               ; $B059 d5
    PUSH IY                               ; $B05A fd e5
    PUSH IX                               ; $B05C dd e5
    LD IY,$9FEC                           ; $B05E fd 21 ec 9f | Accoda il puntatore prima di trovare il delimitatore. Nel controllo TAKE CLOTHES il nodo sintattico si libera ma la citazione resta in coda.
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
    LD (HL),$C0                           ; $B095 36 c0 | Il byte del delimitatore trovato diventa C0. Nel controllo con puntatore residuo il lettore ha raggiunto 4D15 nella bitmap superiore.
    JP $AB52                              ; $B097 c3 52 ab

    ORG $B8BE
; CODE: Analisi della citazione per TALK e creazione della richiesta
    CALL $AAB2                            ; $B8BE cd b2 aa | Analizza il testo a partire dal puntatore estratto dalla coda delle citazioni.
    JR Z,$B8C7                            ; $B8C1 28 04
    CP $02                                ; $B8C3 fe 02
    JR NZ,$B904                           ; $B8C5 20 3d
    LD HL,($A02B)                         ; $B8C7 2a 2b a0
    LD A,(HL)                             ; $B8CA 7e
    AND $F0                               ; $B8CB e6 f0
    CP $C0                                ; $B8CD fe c0
    JR NZ,$B8BE                           ; $B8CF 20 ed
    LD (HL),$90                           ; $B8D1 36 90 | Dopo un’analisi valida ripristina il delimitatore, poi alloca la richiesta da otto byte.
    LD A,$08                              ; $B8D3 3e 08
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
    PUSH AF                               ; $B904 f5 | Il ramo di errore libera la sintassi. La nuova citazione eventualmente accodata da B05E rimane disponibile.
    CALL $D87D                            ; $B905 cd 7d d8
    POP AF                                ; $B908 f1
    POP HL                                ; $B909 e1
    LD ($9FF0),HL                         ; $B90A 22 f0 9f
    RET                                   ; $B90D c9

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

    ORG $D1B2
; CODE: Descrizione breve e controllo della luce dopo lo spostamento
    LD B,A                                ; $D1B2 47 | Ingresso breve di CA9E: chiama D187 direttamente e non ripete l’introduzione del contenitore di D113.
    CALL $D0DD                            ; $D1B3 cd dd d0
    EX DE,HL                              ; $D1B6 eb
    CALL $D187                            ; $D1B7 cd 87 d1
    CALL $D078                            ; $D1BA cd 78 d0 | Nella notifica di arrivo il controllo di percezione C821 usa ancora A00A della partenza mentre il record della lampada è già nella stanza di arrivo.
    JR NC,$D178                           ; $D1BD 30 b9
    LD HL,$68C1                           ; $D1BF 21 c1 68
    CALL $A59F                            ; $D1C2 cd 9f a5
    RET                                   ; $D1C5 c9

    ORG $E0A0
; DATA: Intestazione dell’esame approfondito del ruscello
    DEFB $88,$00                          ; $E0A0 88 00

    ORG $E0A2
; BYTECODE: Ritrovamento ed esame del ruscello
    DEFB $07,$AD,$E0,$02,$5D              ; $E0A2 07 ad e0 02 5d | Il ritrovamento richiede la sponda est e il martedì. La selezione dell’argomento 2 deve ammettere Lestrade.
    DEFB $07,$35,$E1,$FD,$FF              ; $E0A7 07 35 e1 fd ff
    DEFB $0B                              ; $E0AC 0b

    ORG $E955
; BYTECODE: Lestrade attende l’incontro o l’una di notte
    DEFB $82,$81,$00,$07,$61,$E9          ; $E955 82 81 00 07 61 e9 | Verifica se Holmes e il maggiore sono insieme. In mancanza dell’incontro, E95B attende l’una del mattino.
    DEFB $12,$88,$01,$FF,$55,$E9          ; $E95B 12 88 01 ff 55 e9
    DEFB $02,$80,$FB,$0C                  ; $E961 02 80 fb 0c
    DEFB $52,$81,$FB,$07,$65,$E9          ; $E965 52 81 fb 07 65 e9
    DEFB $03,$85,$9E                      ; $E96B 03 85 9e | Il selettore controlla se l’innocenza è stata riconosciuta. In questa storia può esserlo anche dopo mezzanotte.

    ORG $E9A7
; BYTECODE: Lestrade alterna le sponde durante l’ispezione
    DEFB $57,$98,$F1,$0A,$FF,$B5,$E9      ; $E9A7 57 98 f1 0a ff b5 e9 | Alterna il ruscello e i due attraversamenti. La storia osservata trova Lestrade a est alle 09:31.
    DEFB $42,$13,$39,$FF                  ; $E9AE 42 13 39 ff
    DEFB $0E,$9A,$E9                      ; $E9B2 0e 9a e9
    DEFB $57,$98,$F1,$0A,$FF,$C3,$E9      ; $E9B5 57 98 f1 0a ff c3 e9
    DEFB $42,$13,$3B,$FF                  ; $E9BC 42 13 3b ff
    DEFB $0E,$9A,$E9                      ; $E9C0 0e 9a e9
    DEFB $57,$98,$F1,$0A,$FF,$CF,$E9      ; $E9C3 57 98 f1 0a ff cf e9
    DEFB $41,$04                          ; $E9CA 41 04
    DEFB $0E,$9A,$E9                      ; $E9CC 0e 9a e9
    DEFB $57,$98,$F1,$0A,$FF,$9A,$E9      ; $E9CF 57 98 f1 0a ff 9a e9
    DEFB $41,$03                          ; $E9D6 41 03
    DEFB $0E,$9A,$E9                      ; $E9D8 0e 9a e9

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

    ORG $F14C
; BYTECODE: Il poliziotto prende il cadavere dei Brown
    DEFB $42,$29,$2E,$FF                  ; $F14C 42 29 2e ff | Azione 41 sul cadavere 46. Quando la raccolta avviene, il cadavere segue l’attore 12 e non resta sulla sponda.
