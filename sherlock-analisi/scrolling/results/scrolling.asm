; Sherlock v2.0: scorrimento e paginazione. Estratti non contigui.
; Codice e dati separati; tutti i byte ricomposti identici al payload.

    ORG $A019
; DATA fino a $A019
; Contatore condiviso dei ritorni a capo superiori; soglia 15.
    DEFB $00                       ; $A019 00

    ORG $A296
; CODE fino a $A2A9
; Invia 18 CR e azzera A019 DOPO ciascuno; non cancella con un unico riempimento.
    LD B,$12                       ; $A296 06 12
    CALL $A2A2                     ; $A298 cd a2 a2
    XOR A                          ; $A29B af
    LD ($A019),A                   ; $A29C 32 19 a0
    DJNZ $A298                     ; $A29F 10 f7
    RET                            ; $A2A1 c9
; Invia un CR tramite il formatter A9B7 e il canale selezionato.
    PUSH AF                        ; $A2A2 f5
    LD A,$0D                       ; $A2A3 3e 0d
    CALL $A9B7                     ; $A2A5 cd b7 a9
    POP AF                         ; $A2A8 f1
    RET                            ; $A2A9 c9

    ORG $A9B5
; DATA fino a $A9B6
; Puntatore al buffer parola 5C0B; dato, non istruzioni.
    DEFB $0B,$5C                   ; $A9B5 0b 5c

    ORG $A9B7
; CODE fino a $AA70
; Buffer parola: considera la larghezza rimasta prima di stampare.
    PUSH AF                        ; $A9B7 f5
    LD A,($A027)                   ; $A9B8 3a 27 a0
    AND A                          ; $A9BB a7
    JR NZ,$AA10                    ; $A9BC 20 52
    POP AF                         ; $A9BE f1
    PUSH AF                        ; $A9BF f5
    PUSH HL                        ; $A9C0 e5
    LD HL,($A9B5)                  ; $A9C1 2a b5 a9
    CP $20                         ; $A9C4 fe 20
    JR Z,$A9DF                     ; $A9C6 28 17
    CP $0D                         ; $A9C8 fe 0d
    JR Z,$A9DF                     ; $A9CA 28 13
    CP $22                         ; $A9CC fe 22
    JR Z,$A9DF                     ; $A9CE 28 0f
    CP $08                         ; $A9D0 fe 08
    JR NZ,$A9D7                    ; $A9D2 20 03
    DEC HL                         ; $A9D4 2b
    JR $A9D9                       ; $A9D5 18 02
    LD (HL),A                      ; $A9D7 77
    INC HL                         ; $A9D8 23
    LD ($A9B5),HL                  ; $A9D9 22 b5 a9
    POP HL                         ; $A9DC e1
    POP AF                         ; $A9DD f1
    RET                            ; $A9DE c9
    PUSH DE                        ; $A9DF d5
    LD DE,$5C0B                    ; $A9E0 11 0b 5c
    AND A                          ; $A9E3 a7
    SBC HL,DE                      ; $A9E4 ed 52
    JR Z,$AA0B                     ; $A9E6 28 23
    LD A,($C1F5)                   ; $A9E8 3a f5 c1
    CP L                           ; $A9EB bd
    PUSH AF                        ; $A9EC f5
    JR NC,$A9F4                    ; $A9ED 30 05
; CR di word wrap prima della parola che non entra.
    LD A,$0D                       ; $A9EF 3e 0d
    CALL $AA14                     ; $A9F1 cd 14 aa
    PUSH BC                        ; $A9F4 c5
    LD B,L                         ; $A9F5 45
    LD HL,$5C0B                    ; $A9F6 21 0b 5c
    LD ($A9B5),HL                  ; $A9F9 22 b5 a9
    LD A,(HL)                      ; $A9FC 7e
    CALL $AA14                     ; $A9FD cd 14 aa
    INC HL                         ; $AA00 23
    DJNZ $A9FC                     ; $AA01 10 f9
    POP BC                         ; $AA03 c1
    POP AF                         ; $AA04 f1
    JR NZ,$AA0B                    ; $AA05 20 04
    XOR A                          ; $AA07 af
    LD ($A025),A                   ; $AA08 32 25 a0
    POP DE                         ; $AA0B d1
    POP HL                         ; $AA0C e1
    POP AF                         ; $AA0D f1
    JR $AA14                       ; $AA0E 18 04
    POP AF                         ; $AA10 f1
    JP $C1E1                       ; $AA11 c3 e1 c1
; Formatter: spazi, maiuscole, virgolette.
    CP $41                         ; $AA14 fe 41
    JR C,$AA1E                     ; $AA16 38 06
    CP $5B                         ; $AA18 fe 5b
    JR NC,$AA1E                    ; $AA1A 30 02
    OR $20                         ; $AA1C f6 20
    PUSH AF                        ; $AA1E f5
    LD A,($A025)                   ; $AA1F 3a 25 a0
    AND A                          ; $AA22 a7
    JR NZ,$AA2A                    ; $AA23 20 05
    POP AF                         ; $AA25 f1
    CP $20                         ; $AA26 fe 20
    RET Z                          ; $AA28 c8
    PUSH AF                        ; $AA29 f5
    LD A,$01                       ; $AA2A 3e 01
    LD ($A025),A                   ; $AA2C 32 25 a0
    POP AF                         ; $AA2F f1
    PUSH AF                        ; $AA30 f5
    CP $0D                         ; $AA31 fe 0d
    JR NZ,$AA3B                    ; $AA33 20 06
    XOR A                          ; $AA35 af
    LD ($A025),A                   ; $AA36 32 25 a0
    JR $AA6D                       ; $AA39 18 32
    CP $22                         ; $AA3B fe 22
    JR NZ,$AA46                    ; $AA3D 20 07
    LD A,$20                       ; $AA3F 3e 20
    CALL $C1E1                     ; $AA41 cd e1 c1
    JR $AA4A                       ; $AA44 18 04
    CP $2E                         ; $AA46 fe 2e
    JR NZ,$AA51                    ; $AA48 20 07
    LD A,$01                       ; $AA4A 3e 01
    LD ($A026),A                   ; $AA4C 32 26 a0
    JR $AA6D                       ; $AA4F 18 1c
    CP $61                         ; $AA51 fe 61
    JR C,$AA6D                     ; $AA53 38 18
    CP $7B                         ; $AA55 fe 7b
    JR NC,$AA6D                    ; $AA57 30 14
    LD A,($A851)                   ; $AA59 3a 51 a8
    AND A                          ; $AA5C a7
    JR NZ,$AA65                    ; $AA5D 20 06
    LD A,($A026)                   ; $AA5F 3a 26 a0
    AND A                          ; $AA62 a7
    JR Z,$AA6D                     ; $AA63 28 08
    XOR A                          ; $AA65 af
    LD ($A026),A                   ; $AA66 32 26 a0
    POP AF                         ; $AA69 f1
    AND $5F                        ; $AA6A e6 5f
    PUSH AF                        ; $AA6C f5
    POP AF                         ; $AA6D f1
    JP $C1E1                       ; $AA6E c3 e1 c1

    ORG $C10F
; CODE fino a $C127
    LD A,$07                       ; $C10F 3e 07
    OUT ($FE),A                    ; $C111 d3 fe
    LD HL,$4000                    ; $C113 21 00 40
    LD DE,$4001                    ; $C116 11 01 40
    LD BC,$1800                    ; $C119 01 00 18
    LD (HL),$00                    ; $C11C 36 00
    LDIR                           ; $C11E ed b0
    LD BC,$02FF                    ; $C120 01 ff 02
    LD (HL),$38                    ; $C123 36 38
    LDIR                           ; $C125 ed b0
    RET                            ; $C127 c9

    ORG $C128
; DATA fino a $C128
; Modo della finestra: 0=36 colonne; nonzero=18 colonne.
    DEFB $00                       ; $C128 00

    ORG $C129
; CODE fino a $C18F
; Passa a 18 colonne E azzera il contatore.
    XOR A                          ; $C129 af
    LD ($A019),A                   ; $C12A 32 19 a0
    INC A                          ; $C12D 3c
    LD ($C128),A                   ; $C12E 32 28 c1
    LD A,$12                       ; $C131 3e 12
    LD ($C1F5),A                   ; $C133 32 f5 c1
    LD HL,$5020                    ; $C136 21 20 50
    LD ($C1F8),HL                  ; $C139 22 f8 c1
    LD A,$02                       ; $C13C 3e 02
    LD ($C1FA),A                   ; $C13E 32 fa c1
    RET                            ; $C141 c9
; Passa a 36 colonne e ripristina il cursore; NON azzera A019.
    XOR A                          ; $C142 af
    LD ($C128),A                   ; $C143 32 28 c1
    LD A,$24                       ; $C146 3e 24
    JR $C133                       ; $C148 18 e9
; Inizializza schermo, cursori e striscia delle pistole.
    CALL $C10F                     ; $C14A cd 0f c1
    LD A,$24                       ; $C14D 3e 24
    LD ($C1F4),A                   ; $C14F 32 f4 c1
    LD HL,$50E0                    ; $C152 21 e0 50
    LD ($C1F6),HL                  ; $C155 22 f6 c1
    LD A,$02                       ; $C158 3e 02
    LD ($C1FB),A                   ; $C15A 32 fb c1
    CALL $C142                     ; $C15D cd 42 c1
    LD HL,$5140                    ; $C160 21 40 51
    LD DE,$C190                    ; $C163 11 90 c1
    LD B,$06                       ; $C166 06 06
    LD C,$08                       ; $C168 0e 08
    PUSH BC                        ; $C16A c5
    PUSH HL                        ; $C16B e5
    LD B,$04                       ; $C16C 06 04
    PUSH DE                        ; $C16E d5
    LD A,(DE)                      ; $C16F 1a
    LD (HL),A                      ; $C170 77
    INC DE                         ; $C171 13
    INC L                          ; $C172 2c
    DJNZ $C16F                     ; $C173 10 fa
    POP DE                         ; $C175 d1
    DEC C                          ; $C176 0d
    JR NZ,$C16C                    ; $C177 20 f3
    INC DE                         ; $C179 13
    INC DE                         ; $C17A 13
    INC DE                         ; $C17B 13
    INC DE                         ; $C17C 13
    POP HL                         ; $C17D e1
    POP BC                         ; $C17E c1
    INC H                          ; $C17F 24
    DJNZ $C168                     ; $C180 10 e6
    LD HL,$5A40                    ; $C182 21 40 5a
    LD DE,$5A41                    ; $C185 11 41 5a
    LD BC,$001F                    ; $C188 01 1f 00
    LD (HL),$78                    ; $C18B 36 78
    LDIR                           ; $C18D ed b0
    RET                            ; $C18F c9

    ORG $C190
; DATA fino a $C1A7
; 24 byte della striscia; dati bitmap, non codice.
    DEFB $00,$3F,$C1,$C0,$20,$FE,$01,$C4 ; $C190 00 3f c1 c0 20 fe 01 c4
    DEFB $81,$E8,$0D,$81,$41,$B0,$17,$82 ; $C198 81 e8 0d 81 41 b0 17 82
    DEFB $83,$80,$7F,$01,$23,$83,$FC,$04 ; $C1A0 83 80 7f 01 23 83 fc 04

    ORG $C1A8
; CODE fino a $C1BF
; Orologio diretto al renderer: non attraversa il contatore superiore.
    LD DE,$5041                    ; $C1A8 11 41 50
    EX DE,HL                       ; $C1AB eb
    LD C,$00                       ; $C1AC 0e 00
    LD A,$20                       ; $C1AE 3e 20
    CALL $C388                     ; $C1B0 cd 88 c3
    LD A,(DE)                      ; $C1B3 1a
    CALL $C388                     ; $C1B4 cd 88 c3
    INC DE                         ; $C1B7 13
    DJNZ $C1B3                     ; $C1B8 10 f9
    LD A,$20                       ; $C1BA 3e 20
    CALL $C388                     ; $C1BC cd 88 c3
    RET                            ; $C1BF c9

    ORG $C1E1
; CODE fino a $C1F3
; Canale superiore/inferiore e soppressione del testo.
    PUSH AF                        ; $C1E1 f5
    LD A,($5C3C)                   ; $C1E2 3a 3c 5c
    AND A                          ; $C1E5 a7
    JR NZ,$C1EA                    ; $C1E6 20 02
    POP AF                         ; $C1E8 f1
    RET                            ; $C1E9 c9
    LD A,($A027)                   ; $C1EA 3a 27 a0
    AND A                          ; $C1ED a7
    JR NZ,$C1FC                    ; $C1EE 20 0c
    POP AF                         ; $C1F0 f1
    JP $C2BA                       ; $C1F1 c3 ba c2

    ORG $C1F4
; DATA fino a $C1FB
; Colonne residue dei due canali; poi puntatori bitmap e offset in bit.
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $C1F4 00 00 00 00 00 00 00 00

    ORG $C1FC
; CODE fino a $C3E3
; Ripristina AF prima del canale inferiore.
    POP AF                         ; $C1FC f1
; Canale comandi e messaggi inferiori: scroll separato, senza A019.
    PUSH HL                        ; $C1FD e5
    PUSH BC                        ; $C1FE c5
    PUSH AF                        ; $C1FF f5
    LD A,($C1FB)                   ; $C200 3a fb c1
    LD C,A                         ; $C203 4f
    POP AF                         ; $C204 f1
    PUSH AF                        ; $C205 f5
    LD HL,($C1F6)                  ; $C206 2a f6 c1
    CP $0D                         ; $C209 fe 0d
    JR NZ,$C214                    ; $C20B 20 07
    LD A,$20                       ; $C20D 3e 20
    CALL $C388                     ; $C20F cd 88 c3
    JR $C224                       ; $C212 18 10
    CP $08                         ; $C214 fe 08
    JR Z,$C249                     ; $C216 28 31
    CALL $C240                     ; $C218 cd 40 c2
    CALL $C388                     ; $C21B cd 88 c3
    LD A,($C1F4)                   ; $C21E 3a f4 c1
    DEC A                          ; $C221 3d
    JR NZ,$C22D                    ; $C222 20 09
    LD L,$E0                       ; $C224 2e e0
    LD C,$02                       ; $C226 0e 02
    CALL $C271                     ; $C228 cd 71 c2
    LD A,$24                       ; $C22B 3e 24
    LD ($C1F4),A                   ; $C22D 32 f4 c1
    LD A,C                         ; $C230 79
    LD ($C1FB),A                   ; $C231 32 fb c1
    LD ($C1F6),HL                  ; $C234 22 f6 c1
    LD A,$2B                       ; $C237 3e 2b
    CALL $C388                     ; $C239 cd 88 c3
    POP AF                         ; $C23C f1
    POP BC                         ; $C23D c1
    POP HL                         ; $C23E e1
    RET                            ; $C23F c9
    CP $61                         ; $C240 fe 61
    RET C                          ; $C242 d8
    CP $7B                         ; $C243 fe 7b
    RET NC                         ; $C245 d0
    AND $5F                        ; $C246 e6 5f
    RET                            ; $C248 c9
    LD A,$20                       ; $C249 3e 20
    CALL $C388                     ; $C24B cd 88 c3
    CALL $C267                     ; $C24E cd 67 c2
    CALL $C267                     ; $C251 cd 67 c2
    LD A,($C1F4)                   ; $C254 3a f4 c1
    INC A                          ; $C257 3c
    CP $25                         ; $C258 fe 25
    JR NZ,$C22D                    ; $C25A 20 d1
    LD L,$FE                       ; $C25C 2e fe
    LD C,$07                       ; $C25E 0e 07
    CALL $C29C                     ; $C260 cd 9c c2
    LD A,$01                       ; $C263 3e 01
    JR $C22D                       ; $C265 18 c6
    LD A,C                         ; $C267 79
    SUB $07                        ; $C268 d6 07
    LD C,A                         ; $C26A 4f
    RET NC                         ; $C26B d0
    DEC L                          ; $C26C 2d
    ADD A,$08                      ; $C26D c6 08
    LD C,A                         ; $C26F 4f
    RET                            ; $C270 c9
; Scroll fisico della zona inferiore.
    PUSH HL                        ; $C271 e5
    PUSH DE                        ; $C272 d5
    PUSH BC                        ; $C273 c5
    LD HL,$5080                    ; $C274 21 80 50
    LD DE,$5060                    ; $C277 11 60 50
    LD A,$08                       ; $C27A 3e 08
    PUSH HL                        ; $C27C e5
    PUSH DE                        ; $C27D d5
    LD BC,$0080                    ; $C27E 01 80 00
    LDIR                           ; $C281 ed b0
    POP DE                         ; $C283 d1
    POP HL                         ; $C284 e1
    INC H                          ; $C285 24
    INC D                          ; $C286 14
    DEC A                          ; $C287 3d
    JR NZ,$C27C                    ; $C288 20 f2
    LD HL,$50E0                    ; $C28A 21 e0 50
    LD B,$24                       ; $C28D 06 24
    LD C,$01                       ; $C28F 0e 01
    LD A,$20                       ; $C291 3e 20
    CALL $C388                     ; $C293 cd 88 c3
    DJNZ $C293                     ; $C296 10 fb
    POP BC                         ; $C298 c1
    POP DE                         ; $C299 d1
    POP HL                         ; $C29A e1
    RET                            ; $C29B c9
    PUSH HL                        ; $C29C e5
    PUSH DE                        ; $C29D d5
    PUSH BC                        ; $C29E c5
    LD HL,$50DF                    ; $C29F 21 df 50
    LD DE,$50FF                    ; $C2A2 11 ff 50
    LD A,$08                       ; $C2A5 3e 08
    PUSH HL                        ; $C2A7 e5
    PUSH DE                        ; $C2A8 d5
    LD BC,$0080                    ; $C2A9 01 80 00
    LDDR                           ; $C2AC ed b8
    POP DE                         ; $C2AE d1
    POP HL                         ; $C2AF e1
    INC H                          ; $C2B0 24
    INC D                          ; $C2B1 14
    DEC A                          ; $C2B2 3d
    JR NZ,$C2A7                    ; $C2B3 20 f2
    LD HL,$5060                    ; $C2B5 21 60 50
    JR $C28D                       ; $C2B8 18 d3
; Emette il carattere superiore: CR esplicito o esaurimento colonne.
    PUSH HL                        ; $C2BA e5
    PUSH BC                        ; $C2BB c5
    PUSH AF                        ; $C2BC f5
    LD HL,($C1F8)                  ; $C2BD 2a f8 c1
    LD A,($C1FA)                   ; $C2C0 3a fa c1
    LD C,A                         ; $C2C3 4f
    POP AF                         ; $C2C4 f1
    PUSH AF                        ; $C2C5 f5
    CP $0D                         ; $C2C6 fe 0d
    JR NZ,$C2EE                    ; $C2C8 20 24
; Prima dello scroll controlla il contatore.
    LD A,($A019)                   ; $C2CA 3a 19 a0
; Soglia esatta 0F: il sedicesimo CR chiede MORE.
    CP $0F                         ; $C2CD fe 0f
    JR NZ,$C2D6                    ; $C2CF 20 05
; Pausa prima dello scroll pendente.
    CALL $C306                     ; $C2D1 cd 06 c3
; Dopo MORE: FF, poi INC -> 00. Il CR pendente non viene contato come 1.
    LD A,$FF                       ; $C2D4 3e ff
    INC A                          ; $C2D6 3c
    LD ($A019),A                   ; $C2D7 32 19 a0
    LD HL,$5020                    ; $C2DA 21 20 50
    LD C,$02                       ; $C2DD 0e 02
; Scroll fisico di una riga, dopo il controllo MORE.
    CALL $C316                     ; $C2DF cd 16 c3
    LD A,($C128)                   ; $C2E2 3a 28 c1
    AND A                          ; $C2E5 a7
    LD A,$24                       ; $C2E6 3e 24
    JR Z,$C2F8                     ; $C2E8 28 0e
    LD A,$12                       ; $C2EA 3e 12
    JR $C2F8                       ; $C2EC 18 0a
    CALL $C388                     ; $C2EE cd 88 c3
    LD A,($C1F5)                   ; $C2F1 3a f5 c1
    DEC A                          ; $C2F4 3d
; Anche l ultima colonna provoca lo stesso percorso di linefeed.
    JP Z,$C2CA                     ; $C2F5 ca ca c2
    LD ($C1F5),A                   ; $C2F8 32 f5 c1
    LD ($C1F8),HL                  ; $C2FB 22 f8 c1
    LD A,C                         ; $C2FE 79
    LD ($C1FA),A                   ; $C2FF 32 fa c1
    POP AF                         ; $C302 f1
    POP BC                         ; $C303 c1
    POP HL                         ; $C304 e1
    RET                            ; $C305 c9
; MORE: FLASH dell ultima cella della barra, attesa tasto, ritorno a 36 colonne.
    PUSH HL                        ; $C306 e5
; 5A5F = attributo riga 18, colonna 31, cella 8x8 a x248,y144.
    LD HL,$5A5F                    ; $C307 21 5f 5a
    SET 7,(HL)                     ; $C30A cb fe
    CALL $C415                     ; $C30C cd 15 c4
    RES 7,(HL)                     ; $C30F cb be
    CALL $C142                     ; $C311 cd 42 c1
    POP HL                         ; $C314 e1
    RET                            ; $C315 c9
; Copia 17 righe alte 8 pixel verso l alto e svuota la riga inferiore.
    LD A,($C128)                   ; $C316 3a 28 c1
    AND A                          ; $C319 a7
    CALL Z,$C3E4                   ; $C31A cc e4 c3
    PUSH BC                        ; $C31D c5
    PUSH HL                        ; $C31E e5
    PUSH DE                        ; $C31F d5
    LD HL,$4020                    ; $C320 21 20 40
    LD DE,$4000                    ; $C323 11 00 40
; 17 righe da copiare: la finestra fisica e alta 18 righe.
    LD BC,$0011                    ; $C326 01 11 00
    LD A,($C128)                   ; $C329 3a 28 c1
    AND A                          ; $C32C a7
; 32 byte per riga pixel in modo largo.
    LD A,$20                       ; $C32D 3e 20
    JR Z,$C333                     ; $C32F 28 02
; 16 byte per riga pixel in modo stretto.
    LD A,$10                       ; $C331 3e 10
    PUSH HL                        ; $C333 e5
    PUSH DE                        ; $C334 d5
    PUSH BC                        ; $C335 c5
    LD C,$08                       ; $C336 0e 08
    PUSH HL                        ; $C338 e5
    PUSH DE                        ; $C339 d5
    PUSH BC                        ; $C33A c5
    LD C,A                         ; $C33B 4f
    LDIR                           ; $C33C ed b0
    POP BC                         ; $C33E c1
    POP DE                         ; $C33F d1
    POP HL                         ; $C340 e1
    INC H                          ; $C341 24
    INC D                          ; $C342 14
    DEC C                          ; $C343 0d
    JR NZ,$C338                    ; $C344 20 f2
    POP BC                         ; $C346 c1
    POP DE                         ; $C347 d1
    POP HL                         ; $C348 e1
    PUSH AF                        ; $C349 f5
    CALL $C37D                     ; $C34A cd 7d c3
    CALL $C37D                     ; $C34D cd 7d c3
    POP AF                         ; $C350 f1
    DEC C                          ; $C351 0d
    JR NZ,$C333                    ; $C352 20 df
    CP $10                         ; $C354 fe 10
    JR Z,$C363                     ; $C356 28 0b
; In modo largo sposta anche 17 righe di attributi.
    LD HL,$5820                    ; $C358 21 20 58
    LD DE,$5800                    ; $C35B 11 00 58
    LD BC,$0220                    ; $C35E 01 20 02
    LDIR                           ; $C361 ed b0
    LD A,($C128)                   ; $C363 3a 28 c1
    AND A                          ; $C366 a7
    LD B,$24                       ; $C367 06 24
    JR Z,$C36D                     ; $C369 28 02
    LD B,$12                       ; $C36B 06 12
; Svuota in basso con 36 o 18 glifi spazio.
    LD HL,$5020                    ; $C36D 21 20 50
    LD C,$02                       ; $C370 0e 02
    LD A,$20                       ; $C372 3e 20
    CALL $C388                     ; $C374 cd 88 c3
    DJNZ $C374                     ; $C377 10 fb
    POP DE                         ; $C379 d1
    POP HL                         ; $C37A e1
    POP BC                         ; $C37B c1
    RET                            ; $C37C c9
    EX DE,HL                       ; $C37D eb
    LD A,L                         ; $C37E 7d
    ADD A,$20                      ; $C37F c6 20
    LD L,A                         ; $C381 6f
    RET NC                         ; $C382 d0
    LD A,H                         ; $C383 7c
    ADD A,$08                      ; $C384 c6 08
    LD H,A                         ; $C386 67
    RET                            ; $C387 c9
; Glifo ROM 8x8 con passo orizzontale di sette pixel.
    PUSH AF                        ; $C388 f5
    PUSH BC                        ; $C389 c5
    PUSH DE                        ; $C38A d5
    PUSH HL                        ; $C38B e5
    LD L,A                         ; $C38C 6f
    LD H,$00                       ; $C38D 26 00
    ADD HL,HL                      ; $C38F 29
    ADD HL,HL                      ; $C390 29
    ADD HL,HL                      ; $C391 29
    LD DE,$3C00                    ; $C392 11 00 3c
    ADD HL,DE                      ; $C395 19
    EX DE,HL                       ; $C396 eb
    POP HL                         ; $C397 e1
    PUSH HL                        ; $C398 e5
    LD B,$08                       ; $C399 06 08
    LD A,(DE)                      ; $C39B 1a
    PUSH BC                        ; $C39C c5
    PUSH AF                        ; $C39D f5
    DEC C                          ; $C39E 0d
    INC C                          ; $C39F 0c
    LD B,$FF                       ; $C3A0 06 ff
    JR Z,$C3AB                     ; $C3A2 28 07
    SRL A                          ; $C3A4 cb 3f
    SRL B                          ; $C3A6 cb 38
    DEC C                          ; $C3A8 0d
    JR NZ,$C3A4                    ; $C3A9 20 f9
    LD C,A                         ; $C3AB 4f
    LD A,B                         ; $C3AC 78
    CPL                            ; $C3AD 2f
    AND (HL)                       ; $C3AE a6
    OR C                           ; $C3AF b1
    LD (HL),A                      ; $C3B0 77
    POP AF                         ; $C3B1 f1
    POP BC                         ; $C3B2 c1
    DEC C                          ; $C3B3 0d
    INC C                          ; $C3B4 0c
    JR Z,$C3D0                     ; $C3B5 28 19
    PUSH BC                        ; $C3B7 c5
    PUSH AF                        ; $C3B8 f5
    LD A,$08                       ; $C3B9 3e 08
    SUB C                          ; $C3BB 91
    LD C,A                         ; $C3BC 4f
    POP AF                         ; $C3BD f1
    LD B,$FF                       ; $C3BE 06 ff
    SLA A                          ; $C3C0 cb 27
    SLA B                          ; $C3C2 cb 20
    DEC C                          ; $C3C4 0d
    JR NZ,$C3C0                    ; $C3C5 20 f9
    LD C,A                         ; $C3C7 4f
    LD A,B                         ; $C3C8 78
    CPL                            ; $C3C9 2f
    INC HL                         ; $C3CA 23
    AND (HL)                       ; $C3CB a6
    OR C                           ; $C3CC b1
    LD (HL),A                      ; $C3CD 77
    DEC HL                         ; $C3CE 2b
    POP BC                         ; $C3CF c1
    INC DE                         ; $C3D0 13
    INC H                          ; $C3D1 24
    DJNZ $C39B                     ; $C3D2 10 c7
    POP HL                         ; $C3D4 e1
    POP DE                         ; $C3D5 d1
    POP BC                         ; $C3D6 c1
    LD A,C                         ; $C3D7 79
    ADD A,$07                      ; $C3D8 c6 07
    CP $08                         ; $C3DA fe 08
    JR C,$C3E1                     ; $C3DC 38 03
    SUB $08                        ; $C3DE d6 08
    INC L                          ; $C3E0 2c
    LD C,A                         ; $C3E1 4f
    POP AF                         ; $C3E2 f1
    RET                            ; $C3E3 c9

    ORG $C3E4
; CODE fino a $C414
; Servizio stampante opzionale durante lo scroll largo; non e il controllo MORE.
    LD A,($A008)                   ; $C3E4 3a 08 a0
    AND A                          ; $C3E7 a7
    RET Z                          ; $C3E8 c8
    PUSH HL                        ; $C3E9 e5
    PUSH DE                        ; $C3EA d5
    PUSH BC                        ; $C3EB c5
    LD HL,$4000                    ; $C3EC 21 00 40
    LD B,$08                       ; $C3EF 06 08
    PUSH BC                        ; $C3F1 c5
    PUSH HL                        ; $C3F2 e5
    CALL $C403                     ; $C3F3 cd 03 c4
    POP HL                         ; $C3F6 e1
    INC H                          ; $C3F7 24
    POP BC                         ; $C3F8 c1
    DJNZ $C3F1                     ; $C3F9 10 f6
    LD A,$04                       ; $C3FB 3e 04
    OUT ($FB),A                    ; $C3FD d3 fb
    POP BC                         ; $C3FF c1
    POP DE                         ; $C400 d1
    POP HL                         ; $C401 e1
    RET                            ; $C402 c9
    LD A,B                         ; $C403 78
    CP $03                         ; $C404 fe 03
    SBC A,A                        ; $C406 9f
    AND $02                        ; $C407 e6 02
    OUT ($FB),A                    ; $C409 d3 fb
    LD D,A                         ; $C40B 57
    IN A,($FB)                     ; $C40C db fb
    ADD A,A                        ; $C40E 87
    RET M                          ; $C40F f8
    JR NC,$C40C                    ; $C410 30 fa
    JP $0F12                       ; $C412 c3 12 0f

    ORG $C415
; CODE fino a $C45D
; Attende un tasto tramite scansione ROM/interrupt.
    CALL $C41F                     ; $C415 cd 1f c4
    BIT 7,A                        ; $C418 cb 7f
    JR Z,$C415                     ; $C41A 28 f9
    AND $7F                        ; $C41C e6 7f
    RET                            ; $C41E c9
    PUSH IY                        ; $C41F fd e5
    PUSH IX                        ; $C421 dd e5
    PUSH HL                        ; $C423 e5
    PUSH DE                        ; $C424 d5
    PUSH BC                        ; $C425 c5
    LD IY,$5C3A                    ; $C426 fd 21 3a 5c
    EI                             ; $C42A fb
    HALT                           ; $C42B 76
    DI                             ; $C42C f3
    LD A,($5C3B)                   ; $C42D 3a 3b 5c
    BIT 5,A                        ; $C430 cb 6f
    JR NZ,$C437                    ; $C432 20 03
    XOR A                          ; $C434 af
    JR $C456                       ; $C435 18 1f
    RES 5,A                        ; $C437 cb af
    LD ($5C3B),A                   ; $C439 32 3b 5c
    LD A,($5C08)                   ; $C43C 3a 08 5c
    CP $5F                         ; $C43F fe 5f
    JR NZ,$C445                    ; $C441 20 02
    LD A,$18                       ; $C443 3e 18
    CP $0C                         ; $C445 fe 0c
    JR NZ,$C44B                    ; $C447 20 02
    LD A,$08                       ; $C449 3e 08
    CP $0B                         ; $C44B fe 0b
    JR NZ,$C451                    ; $C44D 20 02
    LD A,$5B                       ; $C44F 3e 5b
    CALL $C240                     ; $C451 cd 40 c2
    SET 7,A                        ; $C454 cb ff
    POP BC                         ; $C456 c1
    POP DE                         ; $C457 d1
    POP HL                         ; $C458 e1
    POP IX                         ; $C459 dd e1
    POP IY                         ; $C45B fd e1
    RET                            ; $C45D c9

    ORG $D714
; DATA fino a $D718
; Flag D714 e intestazione della regola D715: dati, non Z80.
    DEFB $00,$40,$00,$CE,$D6       ; $D714 00 40 00 ce d6

    ORG $D719
; CODE fino a $D725
; Ingresso della tokenizzazione dopo il preflight lessicale.
    XOR A                          ; $D719 af
; Azzera A019 prima del parsing, non alla fine del comando.
    LD ($A019),A                   ; $D71A 32 19 a0
    CALL $C142                     ; $D71D cd 42 c1
    LD A,($D714)                   ; $D720 3a 14 d7
    AND A                          ; $D723 a7
    JR NZ,$D760                    ; $D724 20 3a

    ORG $D898
; CODE fino a $D8C5
; Ingresso editor: seleziona il canale inferiore, senza azzerare A019.
    LD HL,$0BB8                    ; $D898 21 b8 0b
    LD ($A03B),HL                  ; $D89B 22 3b a0
    LD A,$01                       ; $D89E 3e 01
    LD ($A027),A                   ; $D8A0 32 27 a0
    CALL $D8AD                     ; $D8A3 cd ad d8
    PUSH AF                        ; $D8A6 f5
    XOR A                          ; $D8A7 af
    LD ($A027),A                   ; $D8A8 32 27 a0
    POP AF                         ; $D8AB f1
    RET                            ; $D8AC c9
; Prompt > e spazio nel canale inferiore.
    LD A,$3E                       ; $D8AD 3e 3e
    CALL $A9B7                     ; $D8AF cd b7 a9
    LD A,$20                       ; $D8B2 3e 20
    CALL $A9B7                     ; $D8B4 cd b7 a9
    LD HL,$5B00                    ; $D8B7 21 00 5b
    LD B,$80                       ; $D8BA 06 80
    LD A,$01                       ; $D8BC 3e 01
    LD ($D897),A                   ; $D8BE 32 97 d8
    LD C,$00                       ; $D8C1 0e 00
    CALL $A536                     ; $D8C3 cd 36 a5
