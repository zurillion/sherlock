; Sherlock: GIVE, richieste e possesso. Header e modelli sono dati tipizzati.

    ORG $8321
; DATA: Modello GIVE: TO facoltativo e destinatario anticipato senza TO
; Record lessicale di8 byte, non istruzioni: il bit5 del modo ricomposto A01E inverte i gruppi senza preposizione. GIVE WATSON MONEY e GIVE ME MY MONEY anticipano il destinatario. MY e ME sono alias di YOUR e YOU; il possessivo resta una proprietà lessicale dell’oggetto, non viene cambiato dal trasferimento.
    DEFB $89,$C3,$DB,$08,$00,$10,$00,$60 ; $8321 89 c3 db 08 00 10 00 60

    ORG $B405
; CODE: Ruoli semantici: oggetto e destinatario dai due gruppi fisici
; Non indovinare il ruolo dai tipi dei nomi: contano modello e preposizioni. Le copie semantiche sono distinte dagli offset fisici del nodo08/12, necessari per continuazioni, errori e arena.
    AND A                                ; $B405 a7
    JR Z,$B416                           ; $B406 28 0e
    LD HL,($B188)                        ; $B408 2a 88 b1
    LD DE,($B18A)                        ; $B40B ed 5b 8a b1
    LD ($B188),DE                        ; $B40F ed 53 88 b1
    LD ($B18A),HL                        ; $B413 22 8a b1
    CALL $A2BD                           ; $B416 cd bd a2
    LD HL,$B188                          ; $B419 21 88 b1
    LD A,(HL)                            ; $B41C 7e
    INC HL                               ; $B41D 23
    OR (HL)                              ; $B41E b6
    JR NZ,$B426                          ; $B41F 20 05
; Nessuna preposizione: legge il modo A01E. GIVE passa da B445 e seleziona il secondo gruppo fisico come oggetto. Con ALL il secondo gruppo può essere vuoto.
    LD A,($A01E)                         ; $B421 3a 1e a0
    JR $B445                             ; $B424 18 1f
    DEC HL                               ; $B426 2b
    LD A,(HL)                            ; $B427 7e
    CP (IY+$0E)                          ; $B428 fd be 0e
    JR NZ,$B435                          ; $B42B 20 08
    INC HL                               ; $B42D 23
    LD A,(HL)                            ; $B42E 7e
    CP (IY+$0F)                          ; $B42F fd be 0f
    JR Z,$B440                           ; $B432 28 0c
    DEC HL                               ; $B434 2b
    LD A,(HL)                            ; $B435 7e
    CP (IY+$10)                          ; $B436 fd be 10
    JR NZ,$B440                          ; $B439 20 05
    INC HL                               ; $B43B 23
    LD A,(HL)                            ; $B43C 7e
    CP (IY+$11)                          ; $B43D fd be 11
    LD A,($A01D)                         ; $B440 3a 1d a0
    JR NZ,$B447                          ; $B443 20 02
; Inversione del bit5, poi scelta delle coppie di offset1208 oppure0812. Applicare una volta sola, anche durante ALL.
    XOR $20                              ; $B445 ee 20
    BIT 5,A                              ; $B447 cb 6f
    LD BC,$1208                          ; $B449 01 08 12
    JR Z,$B451                           ; $B44C 28 03
    LD BC,$0812                          ; $B44E 01 12 08
    LD HL,$B182                          ; $B451 21 82 b1
    LD (HL),B                            ; $B454 70
    INC HL                               ; $B455 23
    LD (HL),C                            ; $B456 71
    LD A,B                               ; $B457 78
    LD DE,$B172                          ; $B458 11 72 b1
    LD HL,$B16D                          ; $B45B 21 6d b1
    CALL $B468                           ; $B45E cd 68 b4
    LD A,C                               ; $B461 79
    LD DE,$B178                          ; $B462 11 78 b1
    LD HL,$B16E                          ; $B465 21 6e b1
    PUSH BC                              ; $B468 c5
    LD C,A                               ; $B469 4f
    LD B,$00                             ; $B46A 06 00
    PUSH HL                              ; $B46C e5
    PUSH IY                              ; $B46D fd e5
    POP HL                               ; $B46F e1
    ADD HL,BC                            ; $B470 09
    LD BC,$0006                          ; $B471 01 06 00
; Copia esattamente6 byte: nome e due qualificatori; non modificare la sintassi originale.
    LDIR                                 ; $B474 ed b0
    XOR A                                ; $B476 af
    LD B,$06                             ; $B477 06 06
    DEC HL                               ; $B479 2b
    OR (HL)                              ; $B47A b6
    DJNZ $B479                           ; $B47B 10 fc
    POP HL                               ; $B47D e1
    POP BC                               ; $B47E c1
    RET Z                                ; $B47F c8
    SET 0,(HL)                           ; $B480 cb c6
    RET                                  ; $B482 c9

    ORG $B280
; CODE: Selezione della coppia: un solo destinatario valido per oggetto
    LD A,($A01C)                         ; $B280 3a 1c a0
    AND A                                ; $B283 a7
    JR NZ,$B292                          ; $B284 20 0c
    CALL $B308                           ; $B286 cd 08 b3
    AND A                                ; $B289 a7
    JR Z,$B259                           ; $B28A 28 cd
    CALL $B32D                           ; $B28C cd 2d b3
    AND A                                ; $B28F a7
    JR Z,$B303                           ; $B290 28 71
    CALL $B4C1                           ; $B292 cd c1 b4
    JR Z,$B2B7                           ; $B295 28 20
    CALL $B2DF                           ; $B297 cd df b2
; Senza destinatario esplicito contano anche Holmes e Watson: con il solo denaro due partner validi fanno fallire GIVE/GIVE ALL. Non escludere automaticamente il soggetto. Il primo oggetto sopravvive soltanto se esiste esattamente un destinatario accettabile. ALL conserva l’ordine crescente degli ID, e un NPC esegue una consegna per turno.
    LD A,($B171)                         ; $B29A 3a 71 b1
    CP $01                               ; $B29D fe 01
    JR NZ,$B292                          ; $B29F 20 f1
    LD A,($A034)                         ; $B2A1 3a 34 a0
    LD ($B184),A                         ; $B2A4 32 84 b1
    LD HL,$B170                          ; $B2A7 21 70 b1
    INC (HL)                             ; $B2AA 34
    LD A,($B190)                         ; $B2AB 3a 90 b1
    AND A                                ; $B2AE a7
    JR NZ,$B2B7                          ; $B2AF 20 06
    LD A,($A01C)                         ; $B2B1 3a 1c a0
    AND A                                ; $B2B4 a7
    JR Z,$B292                           ; $B2B5 28 db

    ORG $C7E4
; CODE: Classe A: oggetto percepibile posseduto dall’attore corrente
    CP $0A                               ; $C7E4 fe 0a
    JR NZ,$C7F9                          ; $C7E6 20 11
    LD A,C                               ; $C7E8 79
    CALL $C821                           ; $C7E9 cd 21 c8
    JP Z,$C632                           ; $C7EC ca 32 c6
    LD A,C                               ; $C7EF 79
; D275 controlla possesso transitivo dell’attore A036: una richiesta non può regalare un oggetto posseduto da Holmes come se fosse di Watson.
    CALL $D275                           ; $C7F0 cd 75 d2
    JP NC,$C632                          ; $C7F3 d2 32 c6
    JP $C62F                             ; $C7F6 c3 2f c6

    ORG $C814
; CODE: Classe D: destinatario percepibile di categoria persona
    LD A,C                               ; $C814 79
    CALL $C821                           ; $C815 cd 21 c8
    JP Z,$C632                           ; $C818 ca 32 c6
; Il destinatario è una persona percepibile; non esclude automaticamente il soggetto. GIVE MONEY TO ME può riuscire se il predicato di capacità lo permette.
    LD A,C                               ; $C81B 79
    CALL $C8BE                           ; $C81C cd be c8
    JR $C7B5                             ; $C81F 18 94

    ORG $C8C6
; CODE: Capienza del destinatario e peso complessivo dell’oggetto
; Somma peso ricorsivo, gestisce i limiti originali a8 bit e confronta la capacità. Non usare la sola dimensione del contenitore.
    PUSH BC                              ; $C8C6 c5
    PUSH AF                              ; $C8C7 f5
    LD A,B                               ; $C8C8 78
    CALL $D237                           ; $C8C9 cd 37 d2
    LD A,B                               ; $C8CC 78
    CALL $D2F2                           ; $C8CD cd f2 d2
    ADD A,(IX+$03)                       ; $C8D0 dd 86 03
    JR NC,$C8D7                          ; $C8D3 30 02
    LD A,$FF                             ; $C8D5 3e ff
    LD B,A                               ; $C8D7 47
    POP AF                               ; $C8D8 f1
    LD C,A                               ; $C8D9 4f
    CALL $D237                           ; $C8DA cd 37 d2
    LD A,C                               ; $C8DD 79
    CALL $D2F2                           ; $C8DE cd f2 d2
    SUB (IX+$03)                         ; $C8E1 dd 96 03
    NEG                                  ; $C8E4 ed 44
    SUB B                                ; $C8E6 90
    POP BC                               ; $C8E7 c1
    JR C,$C8ED                           ; $C8E8 38 03
    OR $01                               ; $C8EA f6 01
    RET                                  ; $C8EC c9
    XOR A                                ; $C8ED af
    RET                                  ; $C8EE c9

    ORG $D275
; CODE: Possesso ricorsivo: risalita dei genitori rispetto ad A036
    LD HL,$A036                          ; $D275 21 36 a0
    CP $FF                               ; $D278 fe ff
    SCF                                  ; $D27A 37
    RET Z                                ; $D27B c8
    CP $FE                               ; $D27C fe fe
    SCF                                  ; $D27E 37
    RET Z                                ; $D27F c8
    PUSH IX                              ; $D280 dd e5
    CALL $D288                           ; $D282 cd 88 d2
    POP IX                               ; $D285 dd e1
    RET                                  ; $D287 c9
; Risalita dei genitori fino all’attore corrente; non confronta il qualificatore YOUR. Quindi your money mantiene il nome mentre cambia possessore.
    CALL $D237                           ; $D288 cd 37 d2
    PUSH AF                              ; $D28B f5
    LD A,(IX+$01)                        ; $D28C dd 7e 01
    CP $FF                               ; $D28F fe ff
    JR Z,$D29A                           ; $D291 28 07
    POP IX                               ; $D293 dd e1
    CP (HL)                              ; $D295 be
    JR NZ,$D288                          ; $D296 20 f0
    SCF                                  ; $D298 37
    RET                                  ; $D299 c9
    POP AF                               ; $D29A f1
    AND A                                ; $D29B a7
    RET                                  ; $D29C c9

    ORG $DF02
; DATA: Header GIVE: classi A/D, luce, costo1 e predicato DF24
; 6A 1D 24 DF: due classi A/D, luce, costo1, puntatore al predicato DF24. Non disassemblare questi quattro byte come CPU.
    DEFB $6A,$1D,$24,$DF                 ; $DF02 6a 1d 24 df

    ORG $DF06
; CODE: Consegna: cambia genitore e propaga la stanza ai contenuti
    LD IY,($A015)                        ; $DF06 fd 2a 15 a0
    LD IX,($A013)                        ; $DF0A dd 2a 13 a0
    LD A,($A035)                         ; $DF0E 3a 35 a0
; Scrive il destinatario nel genitore dell’oggetto; DF17 copia la sua stanza e D249 aggiorna i discendenti. GIVE MONEY trasferisce il record intero, senza accorpare pence o eseguire PAY.
    LD (IX+$01),A                        ; $DF11 dd 77 01
    LD A,(IY+$0F)                        ; $DF14 fd 7e 0f
    LD (IX+$0F),A                        ; $DF17 dd 77 0f
    LD B,A                               ; $DF1A 47
    LD A,($A034)                         ; $DF1B 3a 34 a0
    CALL $D249                           ; $DF1E cd 49 d2
    OR $01                               ; $DF21 f6 01
    RET                                  ; $DF23 c9

    ORG $DF24
; CODE: Predicato GIVE: confronto peso e capacità dei due riferimenti
; Passa i due ID al controllo C8C6; lo stesso predicato vale per Holmes e per gli altri attori.
    LD A,($A034)                         ; $DF24 3a 34 a0
    LD B,A                               ; $DF27 47
    LD A,($A035)                         ; $DF28 3a 35 a0
    JP $C8C6                             ; $DF2B c3 c6 c8

    ORG $B936
; CODE: Richieste NPC: il cursore si salva soltanto dopo risoluzione riuscita
    PUSH IX                              ; $B936 dd e5
    PUSH IY                              ; $B938 fd e5
    PUSH HL                              ; $B93A e5
    LD ($B935),A                         ; $B93B 32 35 b9
    CALL $B90E                           ; $B93E cd 0e b9
    LD A,(IX+$07)                        ; $B941 dd 7e 07
    CP $02                               ; $B944 fe 02
    JP Z,$BA20                           ; $B946 ca 20 ba
    LD A,(IX+$01)                        ; $B949 dd 7e 01
    CP $FF                               ; $B94C fe ff
    JR Z,$B98C                           ; $B94E 28 3c
    LD A,($B935)                         ; $B950 3a 35 b9
    LD ($B934),A                         ; $B953 32 34 b9
    LD A,(IX+$02)                        ; $B956 dd 7e 02
    LD ($A01C),A                         ; $B959 32 1c a0
    LD C,(IX+$03)                        ; $B95C dd 4e 03
    LD B,(IX+$04)                        ; $B95F dd 46 04
    LD ($B17E),BC                        ; $B962 ed 43 7e b1
    CALL $B191                           ; $B966 cd 91 b1
; Se B191 fallisce, salta a B9B4 PRIMA degli store del cursore B973/B976. Non sporcare un record liberato con un iteratore mai accettato.
    JR Z,$B9B4                           ; $B969 28 49
    LD IX,($B866)                        ; $B96B dd 2a 66 b8
    LD BC,($B17E)                        ; $B96F ed 4b 7e b1
    LD (IX+$03),C                        ; $B973 dd 71 03
    LD (IX+$04),B                        ; $B976 dd 70 04
    LD A,($A01C)                         ; $B979 3a 1c a0
    LD (IX+$02),A                        ; $B97C dd 77 02
; Modo0 avanza subito il nodo; ALL lo conserva per il prossimo turno. Nessuna risposta speciale di Watson per la restituzione.
    AND A                                ; $B97F a7
    CALL Z,$B9CA                         ; $B980 cc ca b9
    LD A,$01                             ; $B983 3e 01
    POP HL                               ; $B985 e1
    POP IY                               ; $B986 fd e1
    POP IX                               ; $B988 dd e1
    AND A                                ; $B98A a7
    RET                                  ; $B98B c9

    ORG $B9AC
; CODE: Rifiuto o ALL esaurito: avanza e libera la richiesta
    CALL $B9CA                           ; $B9AC cd ca b9
    JR NZ,$B9AC                          ; $B9AF 20 fb
    XOR A                                ; $B9B1 af
    JR $B985                             ; $B9B2 18 d1
; Richiesta normale fallita: scarta il suffisso. ALL esaurito: azzera il flag e passa al nodo successivo, senza buttare via la richiesta intera.
    LD A,($A01C)                         ; $B9B4 3a 1c a0
    AND A                                ; $B9B7 a7
    JR Z,$B9AC                           ; $B9B8 28 f2
    LD IX,($B866)                        ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                      ; $B9BE dd 36 02 00
    CALL $B9CA                           ; $B9C2 cd ca b9
    JR Z,$B9B1                           ; $B9C5 28 ea
    JP $B93E                             ; $B9C7 c3 3e b9
    LD IX,($B866)                        ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                        ; $B9CE fd 6e fe
    LD H,(IY-$01)                        ; $B9D1 fd 66 ff
    LD (IX+$05),L                        ; $B9D4 dd 75 05
    LD (IX+$06),H                        ; $B9D7 dd 74 06
    PUSH IX                              ; $B9DA dd e5
    PUSH IY                              ; $B9DC fd e5
    POP IX                               ; $B9DE dd e1
    CALL $A1C7                           ; $B9E0 cd c7 a1
    POP IX                               ; $B9E3 dd e1
    LD A,L                               ; $B9E5 7d
    OR H                                 ; $B9E6 b4
    JR Z,$B9F5                           ; $B9E7 28 0c
    PUSH HL                              ; $B9E9 e5
    POP IY                               ; $B9EA fd e1
    BIT 6,(IY+$01)                       ; $B9EC fd cb 01 76
    JR NZ,$B9CE                          ; $B9F0 20 dc
    OR $01                               ; $B9F2 f6 01
    RET                                  ; $B9F4 c9
    CALL $B9FA                           ; $B9F5 cd fa b9
    XOR A                                ; $B9F8 af
    RET                                  ; $B9F9 c9

    ORG $A7D0
; CODE: Nome YOU: eccezione alla maiuscola dei nomi propri
    XOR A                                ; $A7D0 af
    LD ($A7EA),A                         ; $A7D1 32 ea a7
    BIT 7,D                              ; $A7D4 cb 7a
    JR Z,$A7EB                           ; $A7D6 28 13
    LD A,E                               ; $A7D8 7b
; Noun09EE (YOU): anche col bit di nome proprio non imposta la maiuscola. La frase termina con to you, non to You.
    LD HL,$09EE                          ; $A7D9 21 ee 09
    CP L                                 ; $A7DC bd
    JR NZ,$A7E4                          ; $A7DD 20 05
    LD A,D                               ; $A7DF 7a
    AND $0F                              ; $A7E0 e6 0f
    CP H                                 ; $A7E2 bc
    RET Z                                ; $A7E3 c8
    LD A,$01                             ; $A7E4 3e 01
    LD ($A7EA),A                         ; $A7E6 32 ea a7
    RET                                  ; $A7E9 c9
