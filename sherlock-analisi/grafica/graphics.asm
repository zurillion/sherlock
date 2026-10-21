; Sherlock v2.0: routine grafiche. Ogni istruzione ri-assemblata e confrontata col TAP.
; Estratti non contigui: ORG espliciti. $F48E/F48F e $F60B sono dati, non istruzioni.

    ORG $A25D

; Cerca l’immagine della locazione A. Flag Z: grafica disabilitata, tabella assente o ID non trovato.
    PUSH BC                  ; $A25D  C5
    LD B,A                   ; $A25E  47
    LD A,($A011)             ; $A25F  3A 11 A0
    AND A                    ; $A262  A7
    JR Z,$A275               ; $A263  28 10

; Puntatore alla tabella di triple: inizialmente $F60C.
    LD HL,($A0D8)            ; $A265  2A D8 A0
    LD A,H                   ; $A268  7C
    OR L                     ; $A269  B5
    JR Z,$A275               ; $A26A  28 09
    PUSH HL                  ; $A26C  E5
    POP IX                   ; $A26D  DD E1
    LD A,B                   ; $A26F  78
    CALL $D34E               ; $A270  CD 4E D3
    CP $FF                   ; $A273  FE FF
    POP BC                   ; $A275  C1
    RET                      ; $A276  C9

; Mostra l’immagine: salva registri, cerca locazione, prepara lo schermo, chiama interprete.
    PUSH IX                  ; $A277  DD E5
    PUSH HL                  ; $A279  E5
    PUSH BC                  ; $A27A  C5
    PUSH AF                  ; $A27B  F5
    CALL $A25D               ; $A27C  CD 5D A2
    JR Z,$A290               ; $A27F  28 0F
    CALL $A296               ; $A281  CD 96 A2
    CALL $C129               ; $A284  CD 29 C1
    LD L,(IX+$01)            ; $A287  DD 6E 01
    LD H,(IX+$02)            ; $A28A  DD 66 02
    CALL $F3C2               ; $A28D  CD C2 F3
    POP AF                   ; $A290  F1
    POP BC                   ; $A291  C1
    POP HL                   ; $A292  E1
    POP IX                   ; $A293  DD E1
    RET                      ; $A295  C9

; Invia 18 carriage return tramite il canale testuale.
    LD B,$12                 ; $A296  06 12
    CALL $A2A2               ; $A298  CD A2 A2
    XOR A                    ; $A29B  AF
    LD ($A019),A             ; $A29C  32 19 A0
    DJNZ $A298               ; $A29F  10 F7
    RET                      ; $A2A1  C9
    PUSH AF                  ; $A2A2  F5
    LD A,$0D                 ; $A2A3  3E 0D
    CALL $A9B7               ; $A2A5  CD B7 A9
    POP AF                   ; $A2A8  F1
    RET                      ; $A2A9  C9

    ORG $C129

; Attiva il canale di testo stretto: 18 colonne.
    XOR A                    ; $C129  AF
    LD ($A019),A             ; $C12A  32 19 A0
    INC A                    ; $C12D  3C
    LD ($C128),A             ; $C12E  32 28 C1
    LD A,$12                 ; $C131  3E 12
    LD ($C1F5),A             ; $C133  32 F5 C1
    LD HL,$5020              ; $C136  21 20 50
    LD ($C1F8),HL            ; $C139  22 F8 C1
    LD A,$02                 ; $C13C  3E 02
    LD ($C1FA),A             ; $C13E  32 FA C1
    RET                      ; $C141  C9

    ORG $D34E

; Cerca A in una lista di record da 3 byte, terminatore ID=$FF. Ritorna IX al record.
    EXX                      ; $D34E  D9
    LD E,$03                 ; $D34F  1E 03
    PUSH IX                  ; $D351  DD E5
    POP HL                   ; $D353  E1
    LD B,A                   ; $D354  47
    LD D,$00                 ; $D355  16 00
    LD A,(HL)                ; $D357  7E
    CP B                     ; $D358  B8
    JR Z,$D363               ; $D359  28 08
    CP $FF                   ; $D35B  FE FF
    JR Z,$D363               ; $D35D  28 04
    ADD HL,DE                ; $D35F  19
    JP $D357                 ; $D360  C3 57 D3
    PUSH HL                  ; $D363  E5
    POP IX                   ; $D364  DD E1
    CP $FF                   ; $D366  FE FF
    EXX                      ; $D368  D9
    RET                      ; $D369  C9

    ORG $F3C2

; Interprete grafico. HL=stream. Salva IY/HL/DE/BC; IY diventa il puntatore corrente.
    PUSH IY                  ; $F3C2  FD E5
    PUSH HL                  ; $F3C4  E5
    PUSH HL                  ; $F3C5  E5
    POP IY                   ; $F3C6  FD E1
    PUSH DE                  ; $F3C8  D5
    PUSH BC                  ; $F3C9  C5

; Cursore iniziale D=127,E=63 (i disegni reali iniziano tutti con MOVE).
    LD D,$7F                 ; $F3CA  16 7F
    LD E,$3F                 ; $F3CC  1E 3F
    LD B,$01                 ; $F3CE  06 01
    LD C,$01                 ; $F3D0  0E 01
    LD L,$01                 ; $F3D2  2E 01

; Dispatch. Il byte zero termina senza incrementare IY.
    LD A,(IY+$00)            ; $F3D4  FD 7E 00
    AND A                    ; $F3D7  A7
    JP Z,$F488               ; $F3D8  CA 88 F4
    INC IY                   ; $F3DB  FD 23

; $08: MOVE assoluto; SET 7,D impone la meta destra dello schermo.
    CP $08                   ; $F3DD  FE 08
    JR NZ,$F3EF              ; $F3DF  20 0E
    LD D,(IY+$00)            ; $F3E1  FD 56 00
    SET 7,D                  ; $F3E4  CB FA
    INC IY                   ; $F3E6  FD 23
    LD E,(IY+$00)            ; $F3E8  FD 5E 00
    INC IY                   ; $F3EB  FD 23
    JR $F3D4                 ; $F3ED  18 E5

; Bit7: segmento di due byte. C=ottante; B=periodo; L=numero di pixel.
    BIT 7,A                  ; $F3EF  CB 7F
    JR Z,$F414               ; $F3F1  28 21
    LD B,A                   ; $F3F3  47
    AND $07                  ; $F3F4  E6 07
    LD C,A                   ; $F3F6  4F
    LD A,B                   ; $F3F7  78
    RRCA                     ; $F3F8  0F
    AND $3C                  ; $F3F9  E6 3C
    LD B,A                   ; $F3FB  47
    LD A,(IY+$00)            ; $F3FC  FD 7E 00
    AND $3F                  ; $F3FF  E6 3F
    LD L,A                   ; $F401  6F
    INC L                    ; $F402  2C
    LD A,(IY+$00)            ; $F403  FD 7E 00
    INC IY                   ; $F406  FD 23
    RLCA                     ; $F408  07
    RLCA                     ; $F409  07
    AND $03                  ; $F40A  E6 03
    OR B                     ; $F40C  B0
    LD B,A                   ; $F40D  47

; B=1+((opcode>>1)&$3C)+(argomento>>6). L=1+(argomento&$3F).
    INC B                    ; $F40E  04
    CALL $F56E               ; $F40F  CD 6E F5
    JR $F3D4                 ; $F412  18 C0

; Bit6 (e bit7=0): fill; bit0..2 colore INK; seguono x,y.
    BIT 6,A                  ; $F414  CB 77
    JR Z,$F42E               ; $F416  28 16
    AND $07                  ; $F418  E6 07
    PUSH DE                  ; $F41A  D5
    LD D,(IY+$00)            ; $F41B  FD 56 00
    SET 7,D                  ; $F41E  CB FA
    INC IY                   ; $F420  FD 23
    LD E,(IY+$00)            ; $F422  FD 5E 00
    INC IY                   ; $F425  FD 23

; Il fill non cambia il cursore dei segmenti: DE viene ripristinato.
    CALL $F490               ; $F427  CD 90 F4
    POP DE                   ; $F42A  D1
    JP $F3D4                 ; $F42B  C3 D4 F3

; Bit5 (bit7/6=0): cammino sulla memoria attributi. Altri opcode ignorati.
    BIT 5,A                  ; $F42E  CB 6F
    JP Z,$F3D4               ; $F430  CA D4 F3
    AND $07                  ; $F433  E6 07
    RLCA                     ; $F435  07
    RLCA                     ; $F436  07
    RLCA                     ; $F437  07
    PUSH HL                  ; $F438  E5
    PUSH DE                  ; $F439  D5
    PUSH BC                  ; $F43A  C5
    LD C,A                   ; $F43B  4F

; Indirizzo iniziale: byte alto diretto; al byte basso si somma $10 senza riporto.
    LD H,(IY+$00)            ; $F43C  FD 66 00
    INC IY                   ; $F43F  FD 23
    LD A,(IY+$00)            ; $F441  FD 7E 00
    ADD A,$10                ; $F444  C6 10
    LD L,A                   ; $F446  6F
    INC IY                   ; $F447  FD 23

; Ogni run attributi: FF termina; direzione=byte&3; lunghezza=1+(byte>>2).
    LD A,(IY+$00)            ; $F449  FD 7E 00
    INC IY                   ; $F44C  FD 23
    CP $FF                   ; $F44E  FE FF
    JR Z,$F482               ; $F450  28 30
    LD B,A                   ; $F452  47
    AND $03                  ; $F453  E6 03
    LD E,A                   ; $F455  5F
    LD A,B                   ; $F456  78
    RRCA                     ; $F457  0F
    RRCA                     ; $F458  0F
    AND $3F                  ; $F459  E6 3F
    INC A                    ; $F45B  3C
    LD B,A                   ; $F45C  47

; Mantiene INK (oppure lo complementa se uguale al nuovo PAPER), azzera BRIGHT/FLASH.
    LD A,(HL)                ; $F45D  7E
    AND $07                  ; $F45E  E6 07
    RLCA                     ; $F460  07
    RLCA                     ; $F461  07
    RLCA                     ; $F462  07
    CP C                     ; $F463  B9
    JR NZ,$F468              ; $F464  20 02
    XOR $38                  ; $F466  EE 38
    RRCA                     ; $F468  0F
    RRCA                     ; $F469  0F
    RRCA                     ; $F46A  0F
    OR C                     ; $F46B  B1
    LD (HL),A                ; $F46C  77
    LD A,E                   ; $F46D  7B
    AND A                    ; $F46E  A7
    CALL Z,$F514             ; $F46F  CC 14 F5
    DEC A                    ; $F472  3D
    CALL Z,$F540             ; $F473  CC 40 F5
    DEC A                    ; $F476  3D
    CALL Z,$F525             ; $F477  CC 25 F5
    DEC A                    ; $F47A  3D
    CALL Z,$F536             ; $F47B  CC 36 F5
    DJNZ $F45D               ; $F47E  10 DD
    JR $F449                 ; $F480  18 C7
    POP BC                   ; $F482  C1
    POP DE                   ; $F483  D1
    POP HL                   ; $F484  E1
    JP $F3D4                 ; $F485  C3 D4 F3

; Uscita dell’interprete e ripristino registri.
    POP BC                   ; $F488  C1
    POP DE                   ; $F489  D1
    POP HL                   ; $F48A  E1
    POP IY                   ; $F48B  FD E1
    RET                      ; $F48D  C9

    ORG $F490

; Fill scanline: scrive colore corrente, salva registri, inserisce sentinella y=$B0.
    LD ($F60B),A             ; $F490  32 0B F6
    PUSH DE                  ; $F493  D5
    PUSH HL                  ; $F494  E5
    LD HL,$00B0              ; $F495  21 B0 00
    PUSH HL                  ; $F498  E5

; Da un seed si cammina a sinistra finche si trova un bit acceso o il margine.
    CALL $F50D               ; $F499  CD 0D F5
    JR NZ,$F4A5              ; $F49C  20 07
    CALL $F565               ; $F49E  CD 65 F5
    JR NZ,$F499              ; $F4A1  20 F6
    JR $F4AB                 ; $F4A3  18 06

; Ripassa anche il pixel di bordo gia acceso, cambiandone l’attributo INK.
    CALL $F5D2               ; $F4A5  CD D2 F5
    CALL $F55E               ; $F4A8  CD 5E F5

; Reset dei due flag: un seed per ciascuna corsa vuota sulle righe adiacenti.
    LD HL,$0000              ; $F4AB  21 00 00
    LD ($F48E),HL            ; $F4AE  22 8E F4

; Controlla riga y+1; accoda sullo stack CPU il primo pixel di ogni corsa vuota.
    CALL $F54A               ; $F4B1  CD 4A F5
    LD A,$00                 ; $F4B4  3E 00
    JR Z,$F4CD               ; $F4B6  28 15
    CALL $F50D               ; $F4B8  CD 0D F5
    LD A,$00                 ; $F4BB  3E 00
    JR NZ,$F4C8              ; $F4BD  20 09
    LD A,($F48E)             ; $F4BF  3A 8E F4
    AND A                    ; $F4C2  A7
    JR NZ,$F4C8              ; $F4C3  20 03
    PUSH DE                  ; $F4C5  D5
    LD A,$01                 ; $F4C6  3E 01
    PUSH AF                  ; $F4C8  F5
    CALL $F555               ; $F4C9  CD 55 F5
    POP AF                   ; $F4CC  F1
    LD ($F48E),A             ; $F4CD  32 8E F4

; Stesso controllo per riga y-1.
    CALL $F555               ; $F4D0  CD 55 F5
    LD A,$00                 ; $F4D3  3E 00
    JR Z,$F4EC               ; $F4D5  28 15
    CALL $F50D               ; $F4D7  CD 0D F5
    LD A,$00                 ; $F4DA  3E 00
    JR NZ,$F4E7              ; $F4DC  20 09
    LD A,($F48F)             ; $F4DE  3A 8F F4
    AND A                    ; $F4E1  A7
    JR NZ,$F4E7              ; $F4E2  20 03
    PUSH DE                  ; $F4E4  D5
    LD A,$01                 ; $F4E5  3E 01
    PUSH AF                  ; $F4E7  F5
    CALL $F54A               ; $F4E8  CD 4A F5
    POP AF                   ; $F4EB  F1
    LD ($F48F),A             ; $F4EC  32 8F F4

; Accende il pixel e prosegue a destra.
    CALL $F5D2               ; $F4EF  CD D2 F5
    CALL $F55E               ; $F4F2  CD 5E F5
    JR Z,$F4FF               ; $F4F5  28 08
    CALL $F50D               ; $F4F7  CD 0D F5
    JR Z,$F4B1               ; $F4FA  28 B5

; Ripassa anche il bordo destro.
    CALL $F5D2               ; $F4FC  CD D2 F5

; Estrae un altro seed; y=$B0 segnala fine del fill.
    POP DE                   ; $F4FF  D1
    LD A,E                   ; $F500  7B
    CP $B0                   ; $F501  FE B0
    JR NZ,$F499              ; $F503  20 94

; Dopo ogni fill il colore corrente torna a zero (nero).
    LD A,$00                 ; $F505  3E 00
    LD ($F60B),A             ; $F507  32 0B F6
    POP HL                   ; $F50A  E1
    POP DE                   ; $F50B  D1
    RET                      ; $F50C  C9

; Test bitmap: Z se pixel spento. DE contiene x,y.
    PUSH HL                  ; $F50D  E5
    CALL $F5FB               ; $F50E  CD FB F5
    AND (HL)                 ; $F511  A6
    POP HL                   ; $F512  E1
    RET                      ; $F513  C9

; Attributi: su, HL-=32. Rifiuta pagina alta $57.
    PUSH AF                  ; $F514  F5
    PUSH DE                  ; $F515  D5
    LD DE,$0020              ; $F516  11 20 00
    AND A                    ; $F519  A7
    SBC HL,DE                ; $F51A  ED 52
    LD A,H                   ; $F51C  7C
    CP $57                   ; $F51D  FE 57
    JR NZ,$F522              ; $F51F  20 01
    ADD HL,DE                ; $F521  19
    POP DE                   ; $F522  D1
    POP AF                   ; $F523  F1
    RET                      ; $F524  C9

; Attributi: giu, HL+=32. Rifiuta pagina alta $5A.
    PUSH AF                  ; $F525  F5
    PUSH DE                  ; $F526  D5
    LD DE,$0020              ; $F527  11 20 00
    ADD HL,DE                ; $F52A  19
    LD A,H                   ; $F52B  7C
    CP $5A                   ; $F52C  FE 5A

; JR NZ $F532 entra nel SECONDO byte ($52=LD D,D) di SBC HL,DE. Voluto dal binario.
    JR NZ,$F532              ; $F52E  20 02
    AND A                    ; $F530  A7
    SBC HL,DE                ; $F531  ED 52
    POP DE                   ; $F533  D1
    POP AF                   ; $F534  F1
    RET                      ; $F535  C9

; Attributi: sinistra, HL-=1; blocca pagina $57.
    PUSH AF                  ; $F536  F5
    DEC HL                   ; $F537  2B
    LD A,H                   ; $F538  7C
    CP $57                   ; $F539  FE 57
    JR NZ,$F53E              ; $F53B  20 01
    INC HL                   ; $F53D  23
    POP AF                   ; $F53E  F1
    RET                      ; $F53F  C9

; Attributi: destra, HL+=1; blocca pagina $5A.
    PUSH AF                  ; $F540  F5
    INC HL                   ; $F541  23
    LD A,H                   ; $F542  7C
    CP $5A                   ; $F543  FE 5A
    JR NZ,$F548              ; $F545  20 01
    DEC HL                   ; $F547  2B
    POP AF                   ; $F548  F1
    RET                      ; $F549  C9

; Pixel: y++; limite 175. Ritorna Z se il movimento non avviene.
    INC E                    ; $F54A  1C
    LD H,A                   ; $F54B  67
    LD A,E                   ; $F54C  7B
    CP $B0                   ; $F54D  FE B0
    LD A,H                   ; $F54F  7C
    RET NZ                   ; $F550  C0
    DEC E                    ; $F551  1D
    XOR A                    ; $F552  AF
    LD A,H                   ; $F553  7C
    RET                      ; $F554  C9

; Pixel: y--; limite zero.
    DEC E                    ; $F555  1D
    LD H,A                   ; $F556  67
    LD A,E                   ; $F557  7B
    CP $FF                   ; $F558  FE FF
    LD A,H                   ; $F55A  7C
    RET NZ                   ; $F55B  C0
    INC E                    ; $F55C  1C
    RET                      ; $F55D  C9

; Pixel: x++; limite 255.
    INC D                    ; $F55E  14
    RET NZ                   ; $F55F  C0
    DEC D                    ; $F560  15
    LD H,A                   ; $F561  67
    XOR A                    ; $F562  AF
    LD A,H                   ; $F563  7C
    RET                      ; $F564  C9

; Pixel: x--; limite 128.
    DEC D                    ; $F565  15
    BIT 7,D                  ; $F566  CB 7A
    RET NZ                   ; $F568  C0
    INC D                    ; $F569  14
    LD H,A                   ; $F56A  67
    XOR A                    ; $F56B  AF
    LD A,H                   ; $F56C  7C
    RET                      ; $F56D  C9

; Segmento a gradini. C bit0=asse maggiore; bit1=y negativo; bit2=x negativo.
    BIT 0,C                  ; $F56E  CB 41
    JR NZ,$F5A2              ; $F570  20 30
    PUSH HL                  ; $F572  E5
    PUSH BC                  ; $F573  C5

; Caso asse maggiore x: plot, passo x, ogni B passi anche passo y; ripeti L volte.
    CALL $F5D2               ; $F574  CD D2 F5
    BIT 2,C                  ; $F577  CB 51
    JR Z,$F582               ; $F579  28 07
    CALL $F565               ; $F57B  CD 65 F5
    JR Z,$F59F               ; $F57E  28 1F
    JR $F587                 ; $F580  18 05
    CALL $F55E               ; $F582  CD 5E F5
    JR Z,$F59F               ; $F585  28 18
    DEC B                    ; $F587  05
    JR NZ,$F59C              ; $F588  20 12
    BIT 1,C                  ; $F58A  CB 49
    JR Z,$F595               ; $F58C  28 07
    CALL $F555               ; $F58E  CD 55 F5
    JR Z,$F59F               ; $F591  28 0C
    JR $F59A                 ; $F593  18 05
    CALL $F54A               ; $F595  CD 4A F5
    JR Z,$F59F               ; $F598  28 05

; Ripristina B dal valore iniziale senza perdere il cursore DE.
    POP BC                   ; $F59A  C1
    PUSH BC                  ; $F59B  C5
    DEC L                    ; $F59C  2D
    JR NZ,$F574              ; $F59D  20 D5
    POP BC                   ; $F59F  C1
    POP HL                   ; $F5A0  E1
    RET                      ; $F5A1  C9

; Caso asse maggiore y, simmetrico.
    PUSH HL                  ; $F5A2  E5
    PUSH BC                  ; $F5A3  C5
    CALL $F5D2               ; $F5A4  CD D2 F5
    BIT 1,C                  ; $F5A7  CB 49
    JR Z,$F5B2               ; $F5A9  28 07
    CALL $F555               ; $F5AB  CD 55 F5
    JR Z,$F5CF               ; $F5AE  28 1F
    JR $F5B7                 ; $F5B0  18 05
    CALL $F54A               ; $F5B2  CD 4A F5
    JR Z,$F5CF               ; $F5B5  28 18
    DEC B                    ; $F5B7  05
    JR NZ,$F5CC              ; $F5B8  20 12
    BIT 2,C                  ; $F5BA  CB 51
    JR Z,$F5C5               ; $F5BC  28 07
    CALL $F565               ; $F5BE  CD 65 F5
    JR Z,$F5CF               ; $F5C1  28 0C
    JR $F5CA                 ; $F5C3  18 05
    CALL $F55E               ; $F5C5  CD 5E F5
    JR Z,$F5CF               ; $F5C8  28 05
    POP BC                   ; $F5CA  C1
    PUSH BC                  ; $F5CB  C5
    DEC L                    ; $F5CC  2D
    JR NZ,$F5A4              ; $F5CD  20 D5
    POP BC                   ; $F5CF  C1
    POP HL                   ; $F5D0  E1
    RET                      ; $F5D1  C9

; Plot: set bit bitmap + imposta INK nella cella 8x8; conserva PAPER.
    PUSH HL                  ; $F5D2  E5
    CALL $F5FB               ; $F5D3  CD FB F5
    PUSH AF                  ; $F5D6  F5
    PUSH HL                  ; $F5D7  E5
    LD A,H                   ; $F5D8  7C
    AND $18                  ; $F5D9  E6 18
    RRCA                     ; $F5DB  0F
    RRCA                     ; $F5DC  0F
    RRCA                     ; $F5DD  0F
    ADD A,$58                ; $F5DE  C6 58
    LD H,A                   ; $F5E0  67
    LD A,(HL)                ; $F5E1  7E
    AND $38                  ; $F5E2  E6 38
    LD (HL),A                ; $F5E4  77
    LD A,($F60B)             ; $F5E5  3A 0B F6
    RLCA                     ; $F5E8  07
    RLCA                     ; $F5E9  07
    RLCA                     ; $F5EA  07
    CP (HL)                  ; $F5EB  BE
    JR NZ,$F5F0              ; $F5EC  20 02

; Se INK==PAPER, usa INK complementare (colore XOR 7).
    XOR $38                  ; $F5EE  EE 38
    RRCA                     ; $F5F0  0F
    RRCA                     ; $F5F1  0F
    RRCA                     ; $F5F2  0F
    OR (HL)                  ; $F5F3  B6
    LD (HL),A                ; $F5F4  77
    POP HL                   ; $F5F5  E1
    POP AF                   ; $F5F6  F1
    OR (HL)                  ; $F5F7  B6
    LD (HL),A                ; $F5F8  77
    POP HL                   ; $F5F9  E1
    RET                      ; $F5FA  C9

; Converte DE=x,y in HL=indirizzo bitmap e A=maschera del bit.
    PUSH BC                  ; $F5FB  C5
    LD B,E                   ; $F5FC  43
    LD C,D                   ; $F5FD  4A

; ROM $22AA: usa B=y, C=x. Riga fisica dall’alto=175-y.
    CALL $22AA               ; $F5FE  CD AA 22
    LD B,A                   ; $F601  47
    INC B                    ; $F602  04
    LD A,$01                 ; $F603  3E 01
    RRC A                    ; $F605  CB 0F
    DJNZ $F605               ; $F607  10 FC
    POP BC                   ; $F609  C1
    RET                      ; $F60A  C9

; Puntatore little-endian alla tabella immagini
    ORG $A0D8
    DEFB $0C,$F6

; Flag scanline fill
    ORG $F48E
    DEFB $00,$00

; Colore corrente iniziale (valore originale $38)
    ORG $F60B
    DEFB $38
