; Dossier offline: dati e codice distinti; istruzioni riassellate contro il payload.

    ORG $C128
; DATA: Modo della finestra sorgente: largo0 / stretto nonzero
    DEFB $00                              ; $C128 00 | Dato mutabile, non parte di un’istruzione.0=36 colonne,nonzero=18. Il profilo canonico corrente disabilita la grafica originale; la scelta SVG/pixel della UI non cambia questo byte.

    ORG $C129
; CODE: Controlli della finestra e inizializzazione tramite C142
    XOR A                                 ; $C129 af | Controllo stretto: reset esplicitoA019 e modo1. Non equivale al solo cambio del numero di colonne.
    LD ($A019),A                          ; $C12A 32 19 a0
    INC A                                 ; $C12D 3c
    LD ($C128),A                          ; $C12E 32 28 c1 | Writer del modo stretto:1 daINC A dopoXOR A.
    LD A,$12                              ; $C131 3e 12
    LD ($C1F5),A                          ; $C133 32 f5 c1 | Ingresso comune: colonne residue dal valoreA fornito dal controllo, originebitmap5020, shift2. Non svuotaA9B5 né il buffer parole.
    LD HL,$5020                           ; $C136 21 20 50
    LD ($C1F8),HL                         ; $C139 22 f8 c1
    LD A,$02                              ; $C13C 3e 02
    LD ($C1FA),A                          ; $C13E 32 fa c1
    RET                                   ; $C141 c9
    XOR A                                 ; $C142 af | Controllo largo:0 nel modo e36 colonne. NON azzeraA019; non inferire il valore del contatore dalla larghezza.
    LD ($C128),A                          ; $C143 32 28 c1 | Writer largo: stesso0 anche se il modo era già0. Tracciati gli store invariati, non soltanto le transizioni.
    LD A,$24                              ; $C146 3e 24
    JR $C133                              ; $C148 18 e9
    CALL $C10F                            ; $C14A cd 0f c1
    LD A,$24                              ; $C14D 3e 24
    LD ($C1F4),A                          ; $C14F 32 f4 c1
    LD HL,$50E0                           ; $C152 21 e0 50
    LD ($C1F6),HL                         ; $C155 22 f6 c1
    LD A,$02                              ; $C158 3e 02
    LD ($C1FB),A                          ; $C15A 32 fb c1
    CALL $C142                            ; $C15D cd 42 c1 | Inizializzazione dello schermo: chiamaC142 prima della stampa iniziale. Questo writer possiede il flag nell’avvio JS; nessun fallback del payload sui vecchiLOAD.

    ORG $A277
; CODE: Schermo per immagine: pulizia e ingresso a18 colonne
    PUSH IX                               ; $A277 dd e5
    PUSH HL                               ; $A279 e5
    PUSH BC                               ; $A27A c5
    PUSH AF                               ; $A27B f5
    CALL $A25D                            ; $A27C cd 5d a2
    JR Z,$A290                            ; $A27F 28 0f
    CALL $A296                            ; $A281 cd 96 a2
    CALL $C129                            ; $A284 cd 29 c1 | Dopo la pulizia per la figura entraC129: la finestra stretta del gioco originale dipende dal percorso grafico, non dalle preferenze della pagina web.
    LD L,(IX+$01)                         ; $A287 dd 6e 01
    LD H,(IX+$02)                         ; $A28A dd 66 02
    CALL $F3C2                            ; $A28D cd c2 f3
    POP AF                                ; $A290 f1
    POP BC                                ; $A291 c1
    POP HL                                ; $A292 e1
    POP IX                                ; $A293 dd e1
    RET                                   ; $A295 c9

    ORG $C2CA
; CODE: Linefeed: contatore MORE e ripristino della larghezza
    LD A,($A019)                          ; $C2CA 3a 19 a0
    CP $0F                                ; $C2CD fe 0f | MORE si attiva quandoA019 èesattamente15, prima dello scroll pendente.
    JR NZ,$C2D6                           ; $C2CF 20 05
    CALL $C306                            ; $C2D1 cd 06 c3
    LD A,$FF                              ; $C2D4 3e ff | DopoMORE:A019=FF, poiINC ->00. C306 da solo non scrive il contatore.
    INC A                                 ; $C2D6 3c
    LD ($A019),A                          ; $C2D7 32 19 a0
    LD HL,$5020                           ; $C2DA 21 20 50
    LD C,$02                              ; $C2DD 0e 02
    CALL $C316                            ; $C2DF cd 16 c3
    LD A,($C128)                          ; $C2E2 3a 28 c1 | La larghezza viene riletta dopoC316 e l’eventualeMORE, che può averla riportata a36.
    AND A                                 ; $C2E5 a7
    LD A,$24                              ; $C2E6 3e 24
    JR Z,$C2F8                            ; $C2E8 28 0e
    LD A,$12                              ; $C2EA 3e 12
    JR $C2F8                              ; $C2EC 18 0a
    CALL $C388                            ; $C2EE cd 88 c3
    LD A,($C1F5)                          ; $C2F1 3a f5 c1
    DEC A                                 ; $C2F4 3d
    JP Z,$C2CA                            ; $C2F5 ca ca c2
    LD ($C1F5),A                          ; $C2F8 32 f5 c1
    LD ($C1F8),HL                         ; $C2FB 22 f8 c1
    LD A,C                                ; $C2FE 79
    LD ($C1FA),A                          ; $C2FF 32 fa c1
    POP AF                                ; $C302 f1
    POP BC                                ; $C303 c1
    POP HL                                ; $C304 e1
    RET                                   ; $C305 c9

    ORG $C306
; CODE: MORE: ritorno largo; scroll parziale o completo
    PUSH HL                               ; $C306 e5 | FLASH dell’ultima cella della barra; attesa del tasto e ritorno aC142. Controlli ABI conSPACE immediato secondo il protocollo dichiarato.
    LD HL,$5A5F                           ; $C307 21 5f 5a
    SET 7,(HL)                            ; $C30A cb fe
    CALL $C415                            ; $C30C cd 15 c4
    RES 7,(HL)                            ; $C30F cb be
    CALL $C142                            ; $C311 cd 42 c1 | MORE scrive il modo0 tramiteC142; il prompt e una normale CR senzaMORE non sono writer diC128.
    POP HL                                ; $C314 e1
    RET                                   ; $C315 c9
    LD A,($C128)                          ; $C316 3a 28 c1 | In modo largo gestisce la stampante e copia32byte per scan; stretto16byte. Il dossier non certifica i bitmap del profilo nativo con immagini.
    AND A                                 ; $C319 a7
    CALL Z,$C3E4                          ; $C31A cc e4 c3
    PUSH BC                               ; $C31D c5
    PUSH HL                               ; $C31E e5
    PUSH DE                               ; $C31F d5
    LD HL,$4020                           ; $C320 21 20 40
    LD DE,$4000                           ; $C323 11 00 40
    LD BC,$0011                           ; $C326 01 11 00
    LD A,($C128)                          ; $C329 3a 28 c1
    AND A                                 ; $C32C a7
    LD A,$20                              ; $C32D 3e 20
    JR Z,$C333                            ; $C32F 28 02
    LD A,$10                              ; $C331 3e 10
    PUSH HL                               ; $C333 e5
    PUSH DE                               ; $C334 d5
    PUSH BC                               ; $C335 c5
    LD C,$08                              ; $C336 0e 08
    PUSH HL                               ; $C338 e5
    PUSH DE                               ; $C339 d5
    PUSH BC                               ; $C33A c5
    LD C,A                                ; $C33B 4f
    LDIR                                  ; $C33C ed b0
    POP BC                                ; $C33E c1
    POP DE                                ; $C33F d1
    POP HL                                ; $C340 e1
    INC H                                 ; $C341 24
    INC D                                 ; $C342 14
    DEC C                                 ; $C343 0d
    JR NZ,$C338                           ; $C344 20 f2
    POP BC                                ; $C346 c1
    POP DE                                ; $C347 d1
    POP HL                                ; $C348 e1
    PUSH AF                               ; $C349 f5
    CALL $C37D                            ; $C34A cd 7d c3
    CALL $C37D                            ; $C34D cd 7d c3
    POP AF                                ; $C350 f1
    DEC C                                 ; $C351 0d
    JR NZ,$C333                           ; $C352 20 df
    CP $10                                ; $C354 fe 10
    JR Z,$C363                            ; $C356 28 0b
    LD HL,$5820                           ; $C358 21 20 58
    LD DE,$5800                           ; $C35B 11 00 58
    LD BC,$0220                           ; $C35E 01 20 02
    LDIR                                  ; $C361 ed b0
    LD A,($C128)                          ; $C363 3a 28 c1 | Pulisce36 o18 caratteri secondo il modo rimasto dopoMORE.
    AND A                                 ; $C366 a7
    LD B,$24                              ; $C367 06 24
    JR Z,$C36D                            ; $C369 28 02
    LD B,$12                              ; $C36B 06 12
    LD HL,$5020                           ; $C36D 21 20 50
    LD C,$02                              ; $C370 0e 02
    LD A,$20                              ; $C372 3e 20
    CALL $C388                            ; $C374 cd 88 c3
    DJNZ $C374                            ; $C377 10 fb
    POP DE                                ; $C379 d1
    POP HL                                ; $C37A e1
    POP BC                                ; $C37B c1
    RET                                   ; $C37C c9

    ORG $D719
; CODE: Input accettato: azzera il contatore e chiama C142
    XOR A                                 ; $D719 af
    LD ($A019),A                          ; $D71A 32 19 a0 | Questo reset del contatore appartiene all’input accettato, non aC142. Gli errori lessicali possono non arrivare aD719.
    CALL $C142                            ; $D71D cd 42 c1 | Writer largo tramiteC142 anche se il flag valeva già0. VecchiLOAD senza il campo tornano posseduti soltanto a un writer compreso.
    LD A,($D714)                          ; $D720 3a 14 d7
    AND A                                 ; $D723 a7
    JR NZ,$D760                           ; $D724 20 3a
