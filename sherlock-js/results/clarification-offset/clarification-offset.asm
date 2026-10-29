; Analisi offline, dati distinti dal codice; nessuna esecuzione Z80 nel motore JS.

    ORG $A01B
; DATA: Chiarimento: offset fisico del gruppo da completare
    DEFB $00                              ; $A01B 00 | Byte mutabile:0 nessun chiarimento;08 e12 esadecimali sono offset8 e18 decimali dei referenti nei due gruppi del nodo. Non è un booleano né il puntatore del nodo, custodito separatamente a9FF0.

    ORG $A040
; CODE: Avvio: azzeramento esplicito del chiarimento
    XOR A                                 ; $A040 af
    LD ($D6B8),A                          ; $A041 32 b8 d6
    LD ($A01B),A                          ; $A044 32 1b a0 | Scrittura all’avvio, prima del ciclo di input. Il modello inizializza logicamente a0; LOAD vecchi senza campo non riceve un fallback di boot.
    DI                                    ; $A047 f3

    ORG $AAC4
; CODE: Parser: ingresso durante un chiarimento pendente
    LD A,($A01B)                          ; $AAC4 3a 1b a0 | Legge il valore precedente durante il parsing della risposta. Non azzerare A01B all’ingresso AAB2: D793 lo azzera soltanto al ritorno.
    AND A                                 ; $AAC7 a7
    JR Z,$AAD1                            ; $AAC8 28 07
    LD A,$01                              ; $AACA 3e 01
    LD ($A024),A                          ; $AACC 32 24 a0 | Una continuazione forza il modo comando e permette la frase nominale senza verbo.
    RES 3,E                               ; $AACF cb 9b

    ORG $AD6C
; CODE: Continuazione: copia nel vecchio nodo o sostituzione con nuovo verbo
    LD A,($A01B)                          ; $AD6C 3a 1b a0 | Controlla il chiarimento ancora attivo prima del reset esterno D793. Il vecchio nodo è a9FF0.
    AND A                                 ; $AD6F a7
    JR Z,$ADD4                            ; $AD70 28 62
    LD IY,($9FF0)                         ; $AD72 fd 2a f0 9f
    CALL $AEA9                            ; $AD76 cd a9 ae
    LD A,(IY+$01)                         ; $AD79 fd 7e 01
    AND $7F                               ; $AD7C e6 7f
    OR (IY+$00)                           ; $AD7E fd b6 00
    JR NZ,$ADB8                           ; $AD81 20 35 | Un verbo nella nuova frase sostituisce il vecchio comando: non si tratta di una precisazione nominale.
    LD A,($A01B)                          ; $AD83 3a 1b a0 | A01B è un offset nel nodo fisico originale. Il riordino semantico JavaScript dei complementi non deve cambiare lo slot da completare.
    LD E,A                                ; $AD86 5f
    LD D,$00                              ; $AD87 16 00
    LD HL,($9FF0)                         ; $AD89 2a f0 9f
    LD A,(IY+$01)                         ; $AD8C fd 7e 01
    AND $80                               ; $AD8F e6 80
    INC HL                                ; $AD91 23
    OR (HL)                               ; $AD92 b6
    LD (HL),A                             ; $AD93 77
    DEC HL                                ; $AD94 2b
    ADD HL,DE                             ; $AD95 19 | Il campo da completare si ottiene sommando l’offset al vecchio nodo. Una risposta completa i campi disponibili senza perdere il comando precedente.
    LD DE,$0008                           ; $AD96 11 08 00
    ADD IY,DE                             ; $AD99 fd 19
    PUSH IY                               ; $AD9B fd e5
    POP DE                                ; $AD9D d1
    CALL $AE59                            ; $AD9E cd 59 ae
    CALL $AE59                            ; $ADA1 cd 59 ae
    JR Z,$ADAF                            ; $ADA4 28 09
    PUSH DE                               ; $ADA6 d5
    PUSH HL                               ; $ADA7 e5
    DEC DE                                ; $ADA8 1b
    DEC DE                                ; $ADA9 1b
    CALL $AE59                            ; $ADAA cd 59 ae
    POP HL                                ; $ADAD e1
    POP DE                                ; $ADAE d1
    CALL $AE59                            ; $ADAF cd 59 ae
    LD IY,($9FF0)                         ; $ADB2 fd 2a f0 9f
    JR $ADBC                              ; $ADB6 18 04
    LD IY,$9FF2                           ; $ADB8 fd 21 f2 9f | Con nuovo verbo la continuazione precedente viene abbandonata; il reset D793 rimane necessario anche se poi il comando fallisce.
    LD L,(IY-$02)                         ; $ADBC fd 6e fe
    LD H,(IY-$01)                         ; $ADBF fd 66 ff
    PUSH HL                               ; $ADC2 e5
    POP IX                                ; $ADC3 dd e1
    LD L,(IX-$02)                         ; $ADC5 dd 6e fe
    LD H,(IX-$01)                         ; $ADC8 dd 66 ff
    LD (IY-$02),L                         ; $ADCB fd 75 fe
    LD (IY-$01),H                         ; $ADCE fd 74 ff
    CALL $A1C7                            ; $ADD1 cd c7 a1 | Rilascia il nodo non più necessario dopo copia o sostituzione. Le prove confrontano anche tutti i residui del pool.

    ORG $B244
; CODE: Selezione: zero candidati, scelta unica o domanda
    LD A,($B184)                          ; $B244 3a 84 b1
    LD ($A034),A                          ; $B247 32 34 a0
    LD A,($B170)                          ; $B24A 3a 70 b1
    AND A                                 ; $B24D a7
    JR Z,$B259                            ; $B24E 28 09
    CP $01                                ; $B250 fe 01 | La domanda dipende dal numero dei candidati: uno viene scelto, più di uno porta al dispatch WHAT/WHICH. Non chiedere sempre un nome quando manca il primo gruppo.
    JR Z,$B20B                            ; $B252 28 b7
    LD HL,$B5E2                           ; $B254 21 e2 b5
    XOR A                                 ; $B257 af
    RET                                   ; $B258 c9

    ORG $C792
; CODE: Restrizione morbida: accetta in preflight, rifiuta in esecuzione
    XOR $FF                               ; $C792 ee ff
    AND D                                 ; $C794 a2
    AND $7F                               ; $C795 e6 7f
    LD ($CB79),A                          ; $C797 32 79 cb
    LD A,($A00B)                          ; $C79A 3a 0b a0 | A00B=0: una restrizione morbida non scarta il referente dalla ricerca. In esecuzione ritorna l’handler CB7B. La restrizione di possesso altrui nella classe9 arriva a questo controllo.
    AND A                                 ; $C79D a7
    JP Z,$C62F                            ; $C79E ca 2f c6
    LD HL,$CB7B                           ; $C7A1 21 7b cb
    XOR A                                 ; $C7A4 af
    RET                                   ; $C7A5 c9

    ORG $C7BB
; CODE: Classe9: controlli rigidi e proprietà rinviata alla fase esecutiva
    CP $09                                ; $C7BB fe 09 | Classe9: percezione, record singolo, non-persona e capacità sono controllati prima del possesso altrui. Per questo un oggetto troppo pesante non diventa candidato solo perché tenuto da un NPC.
    JR NZ,$C7E4                           ; $C7BD 20 25
    LD A,C                                ; $C7BF 79
    CALL $C821                            ; $C7C0 cd 21 c8
    JP Z,$C632                            ; $C7C3 ca 32 c6
    LD A,C                                ; $C7C6 79
    CALL $C8A7                            ; $C7C7 cd a7 c8
    JP NZ,$C632                           ; $C7CA c2 32 c6
    LD A,C                                ; $C7CD 79
    CALL $C8BE                            ; $C7CE cd be c8
    JP NZ,$C632                           ; $C7D1 c2 32 c6
    LD B,C                                ; $C7D4 41
    LD A,($A036)                          ; $C7D5 3a 36 a0
    CALL $C8C6                            ; $C7D8 cd c6 c8
    JP Z,$C632                            ; $C7DB ca 32 c6
    LD A,C                                ; $C7DE 79
    CALL $C8AF                            ; $C7DF cd af c8 | C8AF individua un antenato persona: il relativo rifiuto passa dal controllo morbido C768/C79A. Il giornale tenuto da Watson conta fra i candidati di TAKE, pur venendo rifiutato durante l’esecuzione.
    JR $C768                              ; $C7E2 18 84

    ORG $DCA2
; CODE: TAKE: possesso già acquisito, ciclo di contenimento e handler
    CALL $D26C                            ; $DCA2 cd 6c d2 | D26C verifica se il referente è già posseduto dall’attore corrente: quel caso usa il diverso handler DCBB. Non confonderlo con la restrizione morbida per il possesso da parte di un altro NPC.
    JR C,$DCB6                            ; $DCA5 38 0f
    LD A,($A036)                          ; $DCA7 3a 36 a0 | Invertendo A e il riferimento HL rispetto a D26C, verifica se l’attore è contenuto nel referente: evita di prendere il proprio contenitore. Il peso è controllato prima, dalla classe9.
    LD HL,$A034                           ; $DCAA 21 34 a0
    CALL $D278                            ; $DCAD cd 78 d2
    JP C,$DC15                            ; $DCB0 da 15 dc
    OR $01                                ; $DCB3 f6 01
    RET                                   ; $DCB5 c9
    LD HL,$DCBB                           ; $DCB6 21 bb dc
    XOR A                                 ; $DCB9 af
    RET                                   ; $DCBA c9
    LD HL,$68B7                           ; $DCBB 21 b7 68 | Handler del caso già posseduto: chiama il testo68B7. I rifiuti specifici e quelli generici non vanno tutti eliminati dal preflight.
    JP $A59F                              ; $DCBE c3 9f a5

    ORG $B447
; CODE: Ruoli degli argomenti: offset08/12 distinti dall’ordine semantico
    BIT 5,A                               ; $B447 cb 6f | Bit5 del modello decide l’associazione dei due ruoli agli offset fisici. La posizione semantica di un oggetto non basta a ricostruire il byte.
    LD BC,$1208                           ; $B449 01 08 12 | Una disposizione usa08/12; l’altra le scambia. Nei comandi con complemento iniziale il referente principale può trovarsi nel secondo gruppo fisico.
    JR Z,$B451                            ; $B44C 28 03
    LD BC,$0812                           ; $B44E 01 12 08
    LD HL,$B182                           ; $B451 21 82 b1
    LD (HL),B                             ; $B454 70
    INC HL                                ; $B455 23
    LD (HL),C                             ; $B456 71
    LD A,B                                ; $B457 78
    LD DE,$B172                           ; $B458 11 72 b1
    LD HL,$B16D                           ; $B45B 21 6d b1
    CALL $B468                            ; $B45E cd 68 b4
    LD A,C                                ; $B461 79
    LD DE,$B178                           ; $B462 11 78 b1
    LD HL,$B16E                           ; $B465 21 6e b1

    ORG $B5B6
; CODE: Domanda: salva offset e trattiene il nodo originale
    LD ($A01B),A                          ; $B5B6 32 1b a0 | Scrive l’offset prima di trattenere il nodo e prima del testo della domanda. SAVE può attraversare0 e porre di nuovo lo stesso chiarimento.
    LD IX,($9FF2)                         ; $B5B9 dd 2a f2 9f
    LD ($9FF0),IX                         ; $B5BD dd 22 f0 9f | Il primo nodo passa dalla lista eseguibile alla lista pendente; il collegamento viene troncato, non ricostruito da un AST finale.
    LD L,(IX-$02)                         ; $B5C1 dd 6e fe
    LD H,(IX-$01)                         ; $B5C4 dd 66 ff
    LD ($9FF2),HL                         ; $B5C7 22 f2 9f
    LD (IX-$02),$00                       ; $B5CA dd 36 fe 00
    LD (IX-$01),$00                       ; $B5CE dd 36 ff 00
    RET                                   ; $B5D2 c9

    ORG $B5D3
; CODE: Domande: distinzione fra WHICH e WHAT per i due ruoli
    LD A,($B16E)                          ; $B5D3 3a 6e b1 | Per il secondo ruolo legge la presenza del nome in B16E. Se manca, usa WHAT aB610; se è presente ma ambiguo, costruisce WHICH.
    BIT 0,A                               ; $B5D6 cb 47
    JR Z,$B610                            ; $B5D8 28 36
    LD A,($B183)                          ; $B5DA 3a 83 b1
    LD HL,$B178                           ; $B5DD 21 78 b1
    JR $B5EF                              ; $B5E0 18 0d
    LD A,($B16D)                          ; $B5E2 3a 6d b1 | Per il primo ruolo legge B16D. Il nome assente porta aB5FC; il nome ambiguo conserva l’offset B182 per WHICH.
    BIT 0,A                               ; $B5E5 cb 47
    JR Z,$B5FC                            ; $B5E7 28 13
    LD A,($B182)                          ; $B5E9 3a 82 b1
    LD HL,$B172                           ; $B5EC 21 72 b1
    CALL $B83C                            ; $B5EF cd 3c b8
    CALL $B5B6                            ; $B5F2 cd b6 b5 | Anche WHICH passa dal medesimo B5B6, che conserva nodo e offset prima di stampare6888.
    LD HL,$6888                           ; $B5F5 21 88 68
    CALL $A59F                            ; $B5F8 cd 9f a5
    RET                                   ; $B5FB c9

    ORG $B5FC
; CODE: WHAT sul primo o secondo argomento: offset prima del testo
    CALL $B633                            ; $B5FC cd 33 b6
    LD HL,($B186)                         ; $B5FF 2a 86 b1
    PUSH HL                               ; $B602 e5
    LD A,($B182)                          ; $B603 3a 82 b1 | WHAT del primo ruolo: usa B182, cioè l’offset fisico preparato per quel ruolo. Può essere08 o12 in base all’ordine dei complementi.
    CALL $B5B6                            ; $B606 cd b6 b5
    LD HL,$6880                           ; $B609 21 80 68
    CALL $A59F                            ; $B60C cd 9f a5
    RET                                   ; $B60F c9
    CALL $B62F                            ; $B610 cd 2f b6
    LD HL,$0000                           ; $B613 21 00 00
    PUSH HL                               ; $B616 e5
    LD HL,$B172                           ; $B617 21 72 b1
    PUSH HL                               ; $B61A e5
    CALL $B633                            ; $B61B cd 33 b6
    LD HL,($B186)                         ; $B61E 2a 86 b1
    PUSH HL                               ; $B621 e5
    LD A,($B183)                          ; $B622 3a 83 b1 | WHAT del secondo ruolo: usa B183. Anche un referente omesso può trattenere il comando. Gli altri argomenti univoci possono invece risolversi implicitamente.
    CALL $B5B6                            ; $B625 cd b6 b5
    LD HL,$687C                           ; $B628 21 7c 68
    CALL $A59F                            ; $B62B cd 9f a5
    RET                                   ; $B62E c9

    ORG $D78E
; CODE: Ritorno del parser: azzera il chiarimento anche in caso di errore
    CALL $AAB2                            ; $D78E cd b2 aa | Unico ingresso ordinario del parser principale. Il parsing delle citazioni segue il proprio percorso: non aggiungere un reset D793 a ogni chiamata interna AAB2.
    PUSH AF                               ; $D791 f5
    XOR A                                 ; $D792 af
    LD ($A01B),A                          ; $D793 32 1b a0 | Reset dopo il ritorno, sia riuscito sia fallito; PUSH/POP AF conserva l’esito del parser. Errori lessicali precedenti non raggiungono questa scrittura.
    POP AF                                ; $D796 f1
    LD HL,($A02B)                         ; $D797 2a 2b a0
    LD ($D6BD),HL                         ; $D79A 22 bd d6
    JR NZ,$D7B2                           ; $D79D 20 13
    LD HL,($9FF0)                         ; $D79F 2a f0 9f
    LD ($9FF2),HL                         ; $D7A2 22 f2 9f
    LD HL,$0000                           ; $D7A5 21 00 00
    LD ($9FF0),HL                         ; $D7A8 22 f0 9f
    XOR A                                 ; $D7AB af
    LD ($D6B8),A                          ; $D7AC 32 b8 d6 | Reset del riuso del buffer dopo una normale unità riuscita; non confonderlo con il byte del chiarimento.
    OR $01                                ; $D7AF f6 01
    RET                                   ; $D7B1 c9

    ORG $D99E
; CODE: Ripetizione @: durante un chiarimento torna all’editor
    LD A,($A01B)                          ; $D99E 3a 1b a0 | @ durante chiarimento non ripete il comando e non entra nel parser: A01B conserva il valore. Una vera risposta vuota entra invece e può azzerare/porre di nuovo la domanda.
    AND A                                 ; $D9A1 a7
    JP NZ,$D8C3                           ; $D9A2 c2 c3 d8
    LD A,$01                              ; $D9A5 3e 01
    LD ($D714),A                          ; $D9A7 32 14 d7 | Senza chiarimento @ seleziona il riuso del buffer; questo flag D714 ha un ciclo distinto.
    OR $01                                ; $D9AA f6 01
    PUSH AF                               ; $D9AC f5
    LD A,$08                              ; $D9AD 3e 08
    CALL $A9B7                            ; $D9AF cd b7 a9
    CALL $A9B7                            ; $D9B2 cd b7 a9
    POP AF                                ; $D9B5 f1
    RET                                   ; $D9B6 c9
