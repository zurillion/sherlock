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

    ORG $AAEA
; CODE: Soggetto nominale e accettazione di un’unità vuota
    LD A,$02                              ; $AAEA 3e 02 | Scrive il modo 2 dopo aver riconosciuto ME come soggetto. Nel caso residuo il punto segue immediatamente il soggetto.
    LD ($A024),A                          ; $AAEC 32 24 a0
    POP HL                                ; $AAEF e1
    PUSH IY                               ; $AAF0 fd e5
    POP HL                                ; $AAF2 e1
    LD DE,$0018                           ; $AAF3 11 18 00
    ADD HL,DE                             ; $AAF6 19
    LD DE,$AAAC                           ; $AAF7 11 ac aa
    EX DE,HL                              ; $AAFA eb
    LD BC,$0006                           ; $AAFB 01 06 00
    LDIR                                  ; $AAFE ed b0
    LD HL,($A029)                         ; $AB00 2a 29 a0
    LD ($A02B),HL                         ; $AB03 22 2b a0
    JR $AB11                              ; $AB06 18 09
    LD A,$01                              ; $AB08 3e 01
    LD ($A024),A                          ; $AB0A 32 24 a0
    POP HL                                ; $AB0D e1
    LD ($A02B),HL                         ; $AB0E 22 2b a0
    POP DE                                ; $AB11 d1
    XOR A                                 ; $AB12 af
    LD ($AAA7),A                          ; $AB13 32 a7 aa
    CALL $AB91                            ; $AB16 cd 91 ab
    JR C,$AB8E                            ; $AB19 38 73
    JR Z,$AB47                            ; $AB1B 28 2a
    CP $90                                ; $AB1D fe 90
    JP Z,$AFB3                            ; $AB1F ca b3 af
    CP $A0                                ; $AB22 fe a0
    JP Z,$ACCC                            ; $AB24 ca cc ac
    BIT 3,E                               ; $AB27 cb 5b
    JR Z,$AB4C                            ; $AB29 28 21
    LD A,($A012)                          ; $AB2B 3a 12 a0
    AND A                                 ; $AB2E a7
    JR NZ,$AB8E                           ; $AB2F 20 5d
    LD A,($A01B)                          ; $AB31 3a 1b a0
    AND A                                 ; $AB34 a7
    JR NZ,$AB4C                           ; $AB35 20 15
    LD A,($A02D)                          ; $AB37 3a 2d a0
    CP $C0                                ; $AB3A fe c0
    JR NZ,$AB8E                           ; $AB3C 20 50
    LD A,$B0                              ; $AB3E 3e b0
    CP D                                  ; $AB40 ba
    JR NZ,$AB8E                           ; $AB41 20 4b
    LD A,$02                              ; $AB43 3e 02 | Stato 2 per l’unità vuota. Il nodo allocato conserva la word del soggetto allo slot 24.
    AND A                                 ; $AB45 a7
    RET                                   ; $AB46 c9

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

    ORG $B224
; CODE: Risoluzione con arresto sul primo candidato valido
    CALL $B4C1                            ; $B224 cd c1 b4
    JR Z,$B244                            ; $B227 28 1b
    CALL $C929                            ; $B229 cd 29 c9
    JR Z,$B224                            ; $B22C 28 f6
    LD A,($A034)                          ; $B22E 3a 34 a0
    LD ($B184),A                          ; $B231 32 84 b1
    LD HL,$B170                           ; $B234 21 70 b1
    INC (HL)                              ; $B237 34
    LD A,($B190)                          ; $B238 3a 90 b1 | B190 non zero termina l’enumerazione al primo candidato valido. CLIMB INTO CAB conserva 8BC9, la riga del cab 30.
    AND A                                 ; $B23B a7
    JR NZ,$B244                           ; $B23C 20 06
    LD A,($A01C)                          ; $B23E 3a 1c a0
    AND A                                 ; $B241 a7
    JR Z,$B224                            ; $B242 28 e0
    LD A,($B184)                          ; $B244 3a 84 b1
    LD ($A034),A                          ; $B247 32 34 a0
    LD A,($B170)                          ; $B24A 3a 70 b1
    AND A                                 ; $B24D a7
    JR Z,$B259                            ; $B24E 28 09
    CP $01                                ; $B250 fe 01
    JR Z,$B20B                            ; $B252 28 b7
    LD HL,$B5E2                           ; $B254 21 e2 b5
    XOR A                                 ; $B257 af
    RET                                   ; $B258 c9

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

    ORG $B96B
; CODE: Copia del cursore del resolver nella richiesta
    LD IX,($B866)                         ; $B96B dd 2a 66 b8
    LD BC,($B17E)                         ; $B96F ed 4b 7e b1
    LD (IX+$03),C                         ; $B973 dd 71 03 | Copia la posizione raggiunta dall’enumeratore. Per CLIMB INTO non è il terminatore dell’indice.
    LD (IX+$04),B                         ; $B976 dd 70 04
    LD A,($A01C)                          ; $B979 3a 1c a0
    LD (IX+$02),A                         ; $B97C dd 77 02

    ORG $B9AC
; CODE: Richiesta rifiutata: avanzo e rilascio dei nodi
    CALL $B9CA                            ; $B9AC cd ca b9
    JR NZ,$B9AC                           ; $B9AF 20 fb
    XOR A                                 ; $B9B1 af
    JR $B985                              ; $B9B2 18 d1
    LD A,($A01C)                          ; $B9B4 3a 1c a0
    AND A                                 ; $B9B7 a7
    JR Z,$B9AC                            ; $B9B8 28 f2
    LD IX,($B866)                         ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                       ; $B9BE dd 36 02 00
    CALL $B9CA                            ; $B9C2 cd ca b9
    JR Z,$B9B1                            ; $B9C5 28 ea
    JP $B93E                              ; $B9C7 c3 3e b9
    LD IX,($B866)                         ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                         ; $B9CE fd 6e fe
    LD H,(IY-$01)                         ; $B9D1 fd 66 ff
    LD (IX+$05),L                         ; $B9D4 dd 75 05 | Sovrascrive il puntatore al nodo prima di liberarlo. L’ultimo nodo scrive una word zero, visibile nel payload liberato.
    LD (IX+$06),H                         ; $B9D7 dd 74 06
    PUSH IX                               ; $B9DA dd e5
    PUSH IY                               ; $B9DC fd e5
    POP IX                                ; $B9DE dd e1
    CALL $A1C7                            ; $B9E0 cd c7 a1
    POP IX                                ; $B9E3 dd e1
    LD A,L                                ; $B9E5 7d
    OR H                                  ; $B9E6 b4
    JR Z,$B9F5                            ; $B9E7 28 0c
    PUSH HL                               ; $B9E9 e5
    POP IY                                ; $B9EA fd e1
    BIT 6,(IY+$01)                        ; $B9EC fd cb 01 76
    JR NZ,$B9CE                           ; $B9F0 20 dc
    OR $01                                ; $B9F2 f6 01
    RET                                   ; $B9F4 c9
    CALL $B9FA                            ; $B9F5 cd fa b9
    XOR A                                 ; $B9F8 af
    RET                                   ; $B9F9 c9

    ORG $BA20
; CODE: Inoltro delle affermazioni ai soli Watson e Lestrade
    LD A,($A036)                          ; $BA20 3a 36 a0 | La richiesta in modo 2 è interpretata da Lestrade o Watson. Con Mrs Jones si torna al turno ordinario lasciandola in lista.
    LD HL,$BA67                           ; $BA23 21 67 ba
    CP $03                                ; $BA26 fe 03
    JR Z,$BA31                            ; $BA28 28 07
    LD HL,$BB67                           ; $BA2A 21 67 bb
    CP $02                                ; $BA2D fe 02
    JR NZ,$BA34                           ; $BA2F 20 03
    CALL $BA3E                            ; $BA31 cd 3e ba
    LD A,$01                              ; $BA34 3e 01
    POP HL                                ; $BA36 e1
    POP IY                                ; $BA37 fd e1
    POP IX                                ; $BA39 dd e1
    AND A                                 ; $BA3B a7
    SCF                                   ; $BA3C 37
    RET                                   ; $BA3D c9

    ORG $CBA7
; CODE: Rifiuto di un ordine durante un’attività vincolata
    LD A,($B934)                          ; $CBA7 3a 34 b9
    BIT 6,A                               ; $CBAA cb 77
    RET Z                                 ; $CBAC c8
    POP HL                                ; $CBAD e1
    XOR A                                 ; $CBAE af
    LD ($A027),A                          ; $CBAF 32 27 a0 | Il rifiuto stampa il frammento 681A nel canale superiore. Il renderer può raggiungere il workspace 5D06.
    LD HL,$681A                           ; $CBB2 21 1a 68
    CALL $A59F                            ; $CBB5 cd 9f a5
    JP $DC15                              ; $CBB8 c3 15 dc

    ORG $D026
; CODE: Ripristino degli argomenti dopo la chiamata DOMAIN
    LD HL,($9FD7)                         ; $D026 2a d7 9f
    CALL $CFB6                            ; $D029 cd b6 cf
    LD A,($9FD6)                          ; $D02C 3a d6 9f
    JR Z,$D03B                            ; $D02F 28 0a
    LD (IX+$03),L                         ; $D031 dd 75 03 | Il passaggio comune ripristina il cliente già selezionato. La scrittura temporanea di E6F0 non modifica il record finale del contesto.
    LD (IX+$04),H                         ; $D034 dd 74 04
    LD (IX+$06),A                         ; $D037 dd 77 06
    RET                                   ; $D03A c9

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

    ORG $D16B
; CODE: Arrivo completo: nome generico del veicolo e della stanza
    LD L,(IX+$07)                         ; $D16B dd 6e 07
    LD H,(IX+$08)                         ; $D16E dd 66 08
    CALL $D182                            ; $D171 cd 82 d1 | L’arrivo in una locazione senza descrizione estesa chiama D187. Il nome del cab va a capo nel frame del glifo 5D1A.
    LD A,B                                ; $D174 78
    CALL $D60B                            ; $D175 cd 0b d6
    LD A,B                                ; $D178 78
    CALL $D68C                            ; $D179 cd 8c d6
    CALL $D4A7                            ; $D17C cd a7 d4
    JP $A2A2                              ; $D17F c3 a2 a2
    LD A,H                                ; $D182 7c
    OR L                                  ; $D183 b5
    JP NZ,$A59F                           ; $D184 c2 9f a5
    EX DE,HL                              ; $D187 eb
    LD A,($A036)                          ; $D188 3a 36 a0
    PUSH AF                               ; $D18B f5
    LD A,($A036)                          ; $D18C 3a 36 a0
    CALL $C863                            ; $D18F cd 63 c8
    EX AF,AF'                             ; $D192 08
    INC A                                 ; $D193 3c
    JR Z,$D19F                            ; $D194 28 09
    DEC A                                 ; $D196 3d
    LD ($A036),A                          ; $D197 32 36 a0
    LD A,$01                              ; $D19A 3e 01
    LD ($A2AA),A                          ; $D19C 32 aa a2
    CALL $A59F                            ; $D19F cd 9f a5
    POP AF                                ; $D1A2 f1
    LD ($A036),A                          ; $D1A3 32 36 a0
    XOR A                                 ; $D1A6 af
    LD ($A2AA),A                          ; $D1A7 32 aa a2
    CALL $D1C6                            ; $D1AA cd c6 d1
    LD A,$2E                              ; $D1AD 3e 2e
    JP $A9B7                              ; $D1AF c3 b7 a9

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

    ORG $D53C
; CODE: Elenco dei contenitori durante LOOK
    DEC C                                 ; $D53C 0d | D3E4 emette lo spazio fra il qualificatore e il nome del cab. Il glifo entra in C388 a 5D26 e conserva AF a 5D1A–5D1B.
    LD A,C                                ; $D53D 79
    AND A                                 ; $D53E a7
    JR NZ,$D546                           ; $D53F 20 05
    CALL $A414                            ; $D541 cd 14 a4
    JR $D557                              ; $D544 18 11
    CP $01                                ; $D546 fe 01
    JR Z,$D551                            ; $D548 28 07
    LD A,$2C                              ; $D54A 3e 2c
    CALL $A9B7                            ; $D54C cd b7 a9
    JR $D557                              ; $D54F 18 06
    LD DE,$005D                           ; $D551 11 5d 00
    CALL $A887                            ; $D554 cd 87 a8
    POP AF                                ; $D557 f1
    JR $D52B                              ; $D558 18 d1
    POP AF                                ; $D55A f1
    CALL $D04F                            ; $D55B cd 4f d0
    PUSH AF                               ; $D55E f5
    CALL $D57D                            ; $D55F cd 7d d5

    ORG $D68C
; CODE: Uscite generiche e caratteri residui delle direzioni
    PUSH IX                               ; $D68C dd e5 | La stampa di Visible exits usa il frammento 68FE. Nell’arrivo a Camden, il glifo s in 5D24 lascia i flag di scansione a 5D18.
    PUSH IY                               ; $D68E fd e5
    PUSH DE                               ; $D690 d5
    PUSH BC                               ; $D691 c5
    CALL $D5EF                            ; $D692 cd ef d5
    CALL $D671                            ; $D695 cd 71 d6
    JR Z,$D6B1                            ; $D698 28 17
    LD HL,$68F1                           ; $D69A 21 f1 68
    CALL $A59F                            ; $D69D cd 9f a5
    LD A,(IX+$00)                         ; $D6A0 dd 7e 00
    CALL $D5FB                            ; $D6A3 cd fb d5
    CALL $A887                            ; $D6A6 cd 87 a8 | Stampa ogni direzione come parola del dizionario. A414 appende il punto e il buffer trattiene i byte grezzi dopo lo svuotamento.
    CALL $D671                            ; $D6A9 cd 71 d6
    JR NZ,$D6A0                           ; $D6AC 20 f2
    CALL $A414                            ; $D6AE cd 14 a4
    POP BC                                ; $D6B1 c1
    POP DE                                ; $D6B2 d1
    POP IY                                ; $D6B3 fd e1
    POP IX                                ; $D6B5 dd e1
    RET                                   ; $D6B7 c9

    ORG $E0A0
; DATA: Intestazione dell’esame approfondito del ruscello
    DEFB $88,$00                          ; $E0A0 88 00

    ORG $E0A2
; BYTECODE: Ritrovamento ed esame del ruscello
    DEFB $07,$AD,$E0,$02,$5D              ; $E0A2 07 ad e0 02 5d | Il ritrovamento richiede la sponda est e il martedì. La selezione dell’argomento 2 deve ammettere Lestrade.
    DEFB $07,$35,$E1,$FD,$FF              ; $E0A7 07 35 e1 fd ff
    DEFB $0B                              ; $E0AC 0b

    ORG $E6EA
; CODE: Cab: controllo del passeggero e scrittura temporanea
    CALL $CFB6                            ; $E6EA cd b6 cf
    LD A,($A034)                          ; $E6ED 3a 34 a0
    LD (IX+$03),A                         ; $E6F0 dd 77 03 | L’enumerazione scrive Holmes, ID 0. Nella traccia delle 12:31 D031 ripristina l’ID 2 di Lestrade.
    OR $01                                ; $E6F3 f6 01
    RET                                   ; $E6F5 c9

    ORG $E710
; CODE: Cab: avvertimento per il debito
    LD A,($5C3C)                          ; $E710 3a 3c 5c
    PUSH AF                               ; $E713 f5
    CALL $CFB6                            ; $E714 cd b6 cf
    LD A,(IX+$03)                         ; $E717 dd 7e 03
    AND A                                 ; $E71A a7
    LD HL,$6C54                           ; $E71B 21 54 6c
    JR NZ,$E725                           ; $E71E 20 05
    LD A,$01                              ; $E720 3e 01
    LD ($5C3C),A                          ; $E722 32 3c 5c
    CALL $A59F                            ; $E725 cd 9f a5 | Stampa l’avvertimento con AF in più sullo stack. A Portman Street la scansione del glifo scrive fino a 5D0E.
    POP AF                                ; $E728 f1
    LD ($5C3C),A                          ; $E729 32 3c 5c
    OR $01                                ; $E72C f6 01
    RET                                   ; $E72E c9

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
