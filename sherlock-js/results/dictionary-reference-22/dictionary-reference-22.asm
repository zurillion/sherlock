; Sherlock: ultimo riferimento lessicale. A022/A023 sono dati mutabili.

    ORG $A022
; DATA: Ultimo descrittore lessicale: anche un argomento vuoto viene conservato
; Campo mutabile di16bit. Ultimo writer naturaleA88C,DE0,Holmes0,EXAMINE ROCK,tick1657/Tue11:36;cuoca9 leggeA022 al2857/Wed07:36.243store,0transizioni nonclassificate dal1649. Non inizializzare0 nei vecchi SAVE.
    DEFB $00,$00                         ; $A022 00 00

    ORG $8259
; DATA: 54modelli:verbo,preposizioni,modificatore e flag negli alti nibble; terminatore
; Quattro word per modello; i bit alti sono anche metadati.216ABI originali B633/B62F+A887 su54modelli,2slot,2gating.14casi visibili hanno finale nonzero,anche descrittori senza offset come1000. Non ricostruire gli ID dal testo inglese.
    DEFB $C3,$05,$00,$00,$00,$00,$8D,$03 ; $8259 c3 05 00 00 00 00 8d 03
    DEFB $1A,$08,$00,$00,$00,$00,$8D,$03 ; $8261 1a 08 00 00 00 00 8d 03
    DEFB $84,$02,$00,$00,$00,$00,$8D,$03 ; $8269 84 02 00 00 00 00 8d 03
    DEFB $92,$09,$00,$00,$00,$00,$8D,$03 ; $8271 92 09 00 00 00 00 8d 03
    DEFB $C7,$05,$00,$00,$00,$00,$8D,$03 ; $8279 c7 05 00 00 00 00 8d 03
    DEFB $D0,$05,$00,$00,$00,$00,$8D,$03 ; $8281 d0 05 00 00 00 00 8d 03
    DEFB $1E,$08,$00,$00,$00,$00,$8D,$03 ; $8289 1e 08 00 00 00 00 8d 03
    DEFB $27,$08,$00,$00,$00,$00,$8D,$03 ; $8291 27 08 00 00 00 00 8d 03
    DEFB $3C,$09,$00,$00,$00,$00,$8D,$03 ; $8299 3c 09 00 00 00 00 8d 03
    DEFB $72,$02,$00,$00,$00,$00,$8D,$03 ; $82A1 72 02 00 00 00 00 8d 03
    DEFB $8B,$81,$00,$00,$00,$80,$00,$40 ; $82A9 8b 81 00 00 00 80 00 40
    DEFB $B2,$81,$77,$24,$00,$00,$00,$50 ; $82B1 b2 81 77 24 00 00 00 50
    DEFB $B2,$81,$20,$26,$EC,$05,$00,$C0 ; $82B9 b2 81 20 26 ec 05 00 c0
    DEFB $B7,$81,$00,$00,$00,$00,$00,$40 ; $82C1 b7 81 00 00 00 00 00 40
    DEFB $F7,$81,$00,$00,$00,$00,$00,$40 ; $82C9 f7 81 00 00 00 00 00 40
    DEFB $7C,$82,$00,$00,$00,$80,$00,$00 ; $82D1 7c 82 00 00 00 80 00 00
    DEFB $7C,$C2,$50,$04,$00,$00,$00,$40 ; $82D9 7c c2 50 04 00 00 00 40
    DEFB $98,$82,$00,$90,$00,$00,$00,$00 ; $82E1 98 82 00 90 00 00 00 00
    DEFB $CA,$82,$00,$00,$00,$00,$00,$40 ; $82E9 ca 82 00 00 00 00 00 40
    DEFB $CA,$82,$00,$00,$00,$00,$BE,$41 ; $82F1 ca 82 00 00 00 00 be 41
    DEFB $33,$93,$00,$10,$00,$40,$00,$00 ; $82F9 33 93 00 10 00 40 00 00
    DEFB $D4,$91,$BF,$39,$00,$40,$00,$00 ; $8301 d4 91 bf 39 00 40 00 00
    DEFB $81,$83,$00,$00,$00,$00,$00,$40 ; $8309 81 83 00 00 00 00 00 40
    DEFB $81,$83,$77,$24,$00,$00,$00,$40 ; $8311 81 83 77 24 00 00 00 40
    DEFB $81,$83,$20,$26,$EC,$05,$00,$C0 ; $8319 81 83 20 26 ec 05 00 c0
    DEFB $89,$C3,$DB,$08,$00,$10,$00,$60 ; $8321 89 c3 db 08 00 10 00 60
    DEFB $8D,$83,$77,$B4,$00,$00,$00,$00 ; $8329 8d 83 77 b4 00 00 00 00
    DEFB $8D,$83,$CE,$28,$00,$00,$00,$00 ; $8331 8d 83 ce 28 00 00 00 00
    DEFB $8D,$93,$DB,$B8,$00,$00,$00,$40 ; $8339 8d 93 db b8 00 00 00 40
    DEFB $8D,$93,$DB,$B8,$00,$00,$63,$43 ; $8341 8d 93 db b8 00 00 63 43
    DEFB $BE,$93,$00,$00,$00,$00,$00,$10 ; $8349 be 93 00 00 00 00 00 10
    DEFB $F5,$03,$00,$10,$00,$00,$00,$00 ; $8351 f5 03 00 10 00 00 00 00
    DEFB $7A,$04,$00,$10,$00,$00,$00,$40 ; $8359 7a 04 00 10 00 00 00 40
    DEFB $23,$05,$00,$10,$00,$00,$00,$00 ; $8361 23 05 00 10 00 00 00 00
    DEFB $23,$85,$CE,$28,$00,$00,$00,$00 ; $8369 23 85 ce 28 00 00 00 00
    DEFB $0B,$86,$00,$00,$00,$00,$00,$40 ; $8371 0b 86 00 00 00 00 00 40
    DEFB $64,$C6,$DB,$08,$00,$D0,$00,$20 ; $8379 64 c6 db 08 00 d0 00 20
    DEFB $E8,$C6,$50,$04,$00,$00,$00,$40 ; $8381 e8 c6 50 04 00 00 00 40
    DEFB $E8,$C6,$FF,$05,$00,$00,$00,$40 ; $8389 e8 c6 ff 05 00 00 00 40
    DEFB $DD,$87,$50,$24,$00,$00,$00,$40 ; $8391 dd 87 50 24 00 00 00 40
    DEFB $87,$88,$00,$00,$00,$00,$00,$40 ; $8399 87 88 00 00 00 00 00 40
    DEFB $87,$C8,$51,$03,$00,$00,$00,$40 ; $83A1 87 c8 51 03 00 00 00 40
    DEFB $87,$98,$EF,$25,$00,$00,$00,$40 ; $83A9 87 98 ef 25 00 00 00 40
    DEFB $87,$C8,$20,$06,$EC,$05,$00,$40 ; $83B1 87 c8 20 06 ec 05 00 40
    DEFB $87,$D8,$DB,$58,$00,$40,$00,$00 ; $83B9 87 d8 db 58 00 40 00 00
    DEFB $8B,$88,$DB,$28,$00,$40,$00,$00 ; $83C1 8b 88 db 28 00 40 00 00
    DEFB $8F,$D8,$00,$10,$00,$40,$00,$00 ; $83C9 8f d8 00 10 00 40 00 00
    DEFB $8F,$D8,$05,$10,$00,$40,$00,$00 ; $83D1 8f d8 05 10 00 40 00 00
    DEFB $5E,$09,$FF,$03,$00,$00,$00,$00 ; $83D9 5e 09 ff 03 00 00 00 00
    DEFB $5E,$89,$38,$39,$00,$C0,$00,$00 ; $83E1 5e 89 38 39 00 c0 00 00
    DEFB $83,$89,$00,$00,$00,$00,$00,$40 ; $83E9 83 89 00 00 00 00 00 40
    DEFB $94,$04,$00,$00,$00,$00,$00,$00 ; $83F1 94 04 00 00 00 00 00 00
    DEFB $14,$85,$00,$00,$00,$00,$00,$40 ; $83F9 14 85 00 00 00 00 00 40
    DEFB $2B,$89,$00,$00,$00,$00,$00,$40 ; $8401 2b 89 00 00 00 00 00 40
    DEFB $00,$00                         ; $8409 00 00

    ORG $6894
; DATA: Messaggio6894:quattro argomenti prima di THAT YOU CAN,poi verbo e due parole opzionali
; Formato originario del rifiuto I SEE NO...THAT YOU CAN... Gli ultimi argomenti sono il verbo e le due parole opzionali selezionate dal modello. Un parametro0 non stampa,ma raggiungeA887 e aggiornaA022/A023.
    DEFB $6B,$74,$01,$01,$01,$01,$66,$64 ; $6894 6b 74 01 01 01 01 66 64
    DEFB $81,$7C,$01,$01,$01,$1D         ; $689C 81 7c 01 01 01 1d

    ORG $B62F
; CODE: Selezione B633/B62F delle due parole finali del modello,secondo lo slot fallito
; Secondo argomento: inverte la selezione delle preposizioni impostandoJRZ. Il JS esprime direttamente il complemento logico,senza modificare istruzioni.
    LD A,$28                             ; $B62F 3e 28
    JR $B635                             ; $B631 18 02
; Primo argomento: seleziona la prima parola conbit5 del bytealto del secondo campo e la seconda conbit7 del bytealto del quarto. I campi non selezionati diventano word0.
    LD A,$20                             ; $B633 3e 20
    LD ($B649),A                         ; $B635 32 49 b6
    LD ($B658),A                         ; $B638 32 58 b6
    LD IX,($B18E)                        ; $B63B dd 2a 8e b1
    LD L,(IX+$04)                        ; $B63F dd 6e 04
    LD H,(IX+$05)                        ; $B642 dd 66 05
    BIT 7,(IX+$07)                       ; $B645 dd cb 07 7e
    JR NZ,$B64E                          ; $B649 20 03
; Argomento non selezionato: HL0 viene davvero passato al testo,non saltato. Lo store lessicale successivo non è un valore di ripiego.
    LD HL,$0000                          ; $B64B 21 00 00
    EX (SP),HL                           ; $B64E e3
    PUSH HL                              ; $B64F e5
    LD L,(IX+$02)                        ; $B650 dd 6e 02
    LD H,(IX+$03)                        ; $B653 dd 66 03
    BIT 5,H                              ; $B656 cb 6c
    JR NZ,$B65D                          ; $B658 20 03
; Secondo argomento vuoto del modelloEXAMINE: ultimo parametro0. GET OUT/CLIMB OUT hanno inveceOF05EC;GIVE nel secondoslot può lasciare1000.
    LD HL,$0000                          ; $B65A 21 00 00
    EX (SP),HL                           ; $B65D e3
    JP (HL)                              ; $B65E e9

    ORG $B678
; CODE: Preparazione del rifiuto:termine nominale,verbo e parametri per6894
    LD HL,$B16D                          ; $B678 21 6d b1
    BIT 0,(HL)                           ; $B67B cb 46
    LD HL,$B172                          ; $B67D 21 72 b1
    CALL NZ,$B6DA                        ; $B680 c4 da b6
    CALL $B633                           ; $B683 cd 33 b6
    LD A,($B16D)                         ; $B686 3a 6d b1
    LD HL,$B172                          ; $B689 21 72 b1
; Prepara il verbo e i campi nominali.27invocazioni6894 osservate in36comandi completi,anche qualificatori e secondo slot. Altri rifiuti/chiarimenti sono mantenuti come scope negativo.
    LD DE,($B186)                        ; $B68C ed 5b 86 b1
    PUSH DE                              ; $B690 d5
    BIT 0,A                              ; $B691 cb 47
    JR Z,$B69D                           ; $B693 28 08
    CALL $B83C                           ; $B695 cd 3c b8
    LD HL,$05B3                          ; $B698 21 b3 05
    JR $B6A6                             ; $B69B 18 09
    LD HL,$0000                          ; $B69D 21 00 00
    PUSH HL                              ; $B6A0 e5
    PUSH HL                              ; $B6A1 e5
    PUSH HL                              ; $B6A2 e5
    LD HL,$05DB                          ; $B6A3 21 db 05
    PUSH HL                              ; $B6A6 e5
    LD HL,$6894                          ; $B6A7 21 94 68
; Chiamata al template6894;returnB6AD osservato nella pila del vero writer naturale dopoEXAMINE ROCK.
    CALL $A59F                           ; $B6AA cd 9f a5
    RET                                  ; $B6AD c9
; Percorso del secondo termine nominale: B62F seleziona il complemento dei flag,poi converge sullo stesso template.
    LD A,($A010)                         ; $B6AE 3a 10 a0
    CP $05                               ; $B6B1 fe 05
    JR Z,$B671                           ; $B6B3 28 bc
    CP $06                               ; $B6B5 fe 06
    JR Z,$B671                           ; $B6B7 28 b8
    LD A,($B179)                         ; $B6B9 3a 79 b1
    BIT 7,A                              ; $B6BC cb 7f
    JR NZ,$B671                          ; $B6BE 20 b1
    LD HL,$B16E                          ; $B6C0 21 6e b1
    BIT 0,(HL)                           ; $B6C3 cb 46
    LD HL,$B178                          ; $B6C5 21 78 b1
    CALL NZ,$B6F0                        ; $B6C8 c4 f0 b6
    CALL $B62F                           ; $B6CB cd 2f b6
    LD A,($B16E)                         ; $B6CE 3a 6e b1
    LD HL,$B178                          ; $B6D1 21 78 b1
    JR $B68C                             ; $B6D4 18 b6

    ORG $B83C
; CODE: Riordina qualificatori e sostantivo sullo stack degli argomenti del testo
; B83C dispone i tre descrittori nominali senza ricavarli dal nome visibile. La nuova proiezione usa solo la coda del modello provata;messaggi found e richiesteNPC restano sconosciuti.
    POP IX                               ; $B83C dd e1
    LD B,$03                             ; $B83E 06 03
    LD E,(HL)                            ; $B840 5e
    INC HL                               ; $B841 23
    LD D,(HL)                            ; $B842 56
    INC HL                               ; $B843 23
    PUSH DE                              ; $B844 d5
    DJNZ $B840                           ; $B845 10 f9
    POP HL                               ; $B847 e1
    EX (SP),HL                           ; $B848 e3
    PUSH HL                              ; $B849 e5
    JP (IX)                              ; $B84A dd e9

    ORG $A59F
; CODE: Ingresso al testo parametrico e cursore degli argomenti A59D
    PUSH BC                              ; $A59F c5
    PUSH DE                              ; $A5A0 d5
    PUSH IX                              ; $A5A1 dd e5
    PUSH AF                              ; $A5A3 f5
    PUSH HL                              ; $A5A4 e5
    LD HL,$000C                          ; $A5A5 21 0c 00
    ADD HL,SP                            ; $A5A8 39
    LD ($A59D),HL                        ; $A5A9 22 9d a5
    POP HL                               ; $A5AC e1
    LD A,($A00B)                         ; $A5AD 3a 0b a0
    AND A                                ; $A5B0 a7
    JR NZ,$A5B6                          ; $A5B1 20 03
    LD ($A00C),A                         ; $A5B3 32 0c a0
    CALL $A5C4                           ; $A5B6 cd c4 a5
    POP AF                               ; $A5B9 f1
    POP IX                               ; $A5BA dd e1
    POP DE                               ; $A5BC d1
    POP BC                               ; $A5BD c1
    POP HL                               ; $A5BE e1
    LD SP,($A59D)                        ; $A5BF ed 7b 9d a5
    JP (HL)                              ; $A5C3 e9

    ORG $A621
; CODE: Dispatch dei token:wordArgument ritorna al normale ingresso lessicale
    PUSH DE                              ; $A621 d5
    LD E,A                               ; $A622 5f
    LD D,$00                             ; $A623 16 00
    LD HL,$A55D                          ; $A625 21 5d a5
    ADD HL,DE                            ; $A628 19
    ADD HL,DE                            ; $A629 19
    LD E,(HL)                            ; $A62A 5e
    INC HL                               ; $A62B 23
    LD D,(HL)                            ; $A62C 56
    EX DE,HL                             ; $A62D eb
    POP DE                               ; $A62E d1
    CP $1D                               ; $A62F fe 1d
    JR NC,$A5C3                          ; $A631 30 90
    CALL $A5C3                           ; $A633 cd c3 a5
    JR Z,$A5ED                           ; $A636 28 b5
    JR $A5EA                             ; $A638 18 b0

    ORG $A66C
; CODE: Consuma una word argomento,compresozero,e prosegue con flagNZ
; La word vuota è comunque consumata. OR1 forzaNZ: A638 torna adA5EA,che chiamaA887 anche conDE0.
    LD HL,($A59D)                        ; $A66C 2a 9d a5
    LD E,(HL)                            ; $A66F 5e
    INC HL                               ; $A670 23
    LD D,(HL)                            ; $A671 56
    INC HL                               ; $A672 23
    LD ($A59D),HL                        ; $A673 22 9d a5
    OR $01                               ; $A676 f6 01
    RET                                  ; $A678 c9

    ORG $A887
; CODE: A887 salva il descrittore prima del controllo offsetzero; gating visibilità
    LD A,($5C3C)                         ; $A887 3a 3c 5c
    AND A                                ; $A88A a7
    RET Z                                ; $A88B c8
; Store PRIMA del test dell’offset. Traccia naturale:DE0,tick1657,Holmes0,EXAMINE ROCK. Il byte è letto molte ore dopo; nessuna risposta registrata viene riprodotta nel runtime.
    LD ($A022),DE                        ; $A88C ed 53 22 a0
    LD A,D                               ; $A890 7a
    AND $0F                              ; $A891 e6 0f
    OR E                                 ; $A893 b3
; Offsetzero:ritorna senza stampare,ma conserva tutti16bit del descrittore appena scritto.1000 non equivale a0000,anche seentrambi non emettono lettere.
    RET Z                                ; $A894 c8
    PUSH IX                              ; $A895 dd e5
    PUSH HL                              ; $A897 e5
    PUSH BC                              ; $A898 c5
    PUSH DE                              ; $A899 d5
    LD A,$20                             ; $A89A 3e 20
    CALL $A9B7                           ; $A89C cd b7 a9
    LD A,D                               ; $A89F 7a
    AND $F0                              ; $A8A0 e6 f0
    LD C,A                               ; $A8A2 4f
    CP $70                               ; $A8A3 fe 70
    LD A,$01                             ; $A8A5 3e 01
    JR NZ,$A8AC                          ; $A8A7 20 03
    LD ($A026),A                         ; $A8A9 32 26 a0
    LD A,D                               ; $A8AC 7a
    AND $0F                              ; $A8AD e6 0f
    LD D,A                               ; $A8AF 57
    EX DE,HL                             ; $A8B0 eb
    PUSH HL                              ; $A8B1 e5
    LD A,H                               ; $A8B2 7c
    OR C                                 ; $A8B3 b1
    LD H,A                               ; $A8B4 67
; Per riferimenti nonzero ricompone il contesto e risalva il descrittore; la desinenza non ne cambia il valore. Gating5C3C0 ritorna prima di entrambi gli store.
    LD ($A022),HL                        ; $A8B5 22 22 a0
    POP HL                               ; $A8B8 e1
