; Sherlock: ultimo riferimento lessicale. A022/A023 sono dati mutabili.

    ORG $A022
; DATA: Ultimo riferimento lessicale emesso: offset12 bit e contesto4 bit
; Word mutabile condivisa, non istruzioni: byte basso dell’offset aA022, byte alto con nibble di modo aA023. Restano invariati nei caratteri letterali e nell’emissione disabilitata. Il runtime non possiede ancora questo campo dopo ogni output sintetico: i percorsi senza contratto lo revocano, vecchi save restano sconosciuti.
    DEFB $00,$00                         ; $A022 00 00

    ORG $A37D
; CODE: Composizione dell’azione: riferimenti lessicali e nomi argomento
    XOR A                                ; $A37D af
    LD ($A028),A                         ; $A37E 32 28 a0
    LD A,($A35D)                         ; $A381 3a 5d a3
    CALL $A2B1                           ; $A384 cd b1 a2
    PUSH HL                              ; $A387 e5
    POP IX                               ; $A388 dd e1
    PUSH HL                              ; $A38A e5
    CALL $A2BD                           ; $A38B cd bd a2
    CALL $C493                           ; $A38E cd 93 c4
    CALL $C4B2                           ; $A391 cd b2 c4
    POP HL                               ; $A394 e1
    LD A,($A01D)                         ; $A395 3a 1d a0
    LD C,A                               ; $A398 4f
    PUSH HL                              ; $A399 e5
    LD DE,$0006                          ; $A39A 11 06 00
    ADD HL,DE                            ; $A39D 19
; Il modificatore del modello viene letto con A880, che elimina i nibble di metadati prima dell’emissione. Un riferimento zero raggiunge soltanto il primo store.
    CALL $A880                           ; $A39E cd 80 a8
    POP HL                               ; $A3A1 e1
; Stampa il verbo dal modello, poi preposizioni e nomi secondo i flag. Nell’ordine GO TO SLATER STREET il nome della destinazione termina in STREET: D442 emette5000|0861.
    CALL $A880                           ; $A3A2 cd 80 a8
    BIT 3,C                              ; $A3A5 cb 59
    JR Z,$A3E2                           ; $A3A7 28 39
    BIT 5,C                              ; $A3A9 cb 69
    CALL NZ,$A880                        ; $A3AB c4 80 a8
    LD A,($A01E)                         ; $A3AE 3a 1e a0
    BIT 7,A                              ; $A3B1 cb 7f
    CALL NZ,$A880                        ; $A3B3 c4 80 a8
    LD A,($A35E)                         ; $A3B6 3a 5e a3
    CP $FE                               ; $A3B9 fe fe
    JR NZ,$A3C7                          ; $A3BB 20 0a
    PUSH HL                              ; $A3BD e5
    LD HL,($A02F)                        ; $A3BE 2a 2f a0
    CALL $A419                           ; $A3C1 cd 19 a4
    POP HL                               ; $A3C4 e1
    JR $A3E2                             ; $A3C5 18 1b
    PUSH HL                              ; $A3C7 e5
    LD HL,$A036                          ; $A3C8 21 36 a0
    CP (HL)                              ; $A3CB be
    JR NZ,$A3D6                          ; $A3CC 20 08
    LD DE,$055B                          ; $A3CE 11 5b 05
    CALL $A887                           ; $A3D1 cd 87 a8
    JR $A3E1                             ; $A3D4 18 0b
    LD A,($A00F)                         ; $A3D6 3a 0f a0
    CP $05                               ; $A3D9 fe 05
    LD A,($A35E)                         ; $A3DB 3a 5e a3
    CALL $A745                           ; $A3DE cd 45 a7
    POP HL                               ; $A3E1 e1
    LD A,($A35F)                         ; $A3E2 3a 5f a3
    CP $FF                               ; $A3E5 fe ff
    JR Z,$A414                           ; $A3E7 28 2b
    BIT 2,C                              ; $A3E9 cb 51
    JR Z,$A414                           ; $A3EB 28 27
    BIT 5,C                              ; $A3ED cb 69
    CALL Z,$A880                         ; $A3EF cc 80 a8
    LD A,($A01E)                         ; $A3F2 3a 1e a0
    BIT 7,A                              ; $A3F5 cb 7f
    CALL Z,$A880                         ; $A3F7 cc 80 a8
    LD A,($A35F)                         ; $A3FA 3a 5f a3
    CP $FE                               ; $A3FD fe fe
    JR NZ,$A409                          ; $A3FF 20 08
    LD HL,($A031)                        ; $A401 2a 31 a0
    CALL $A419                           ; $A404 cd 19 a4
    JR $A414                             ; $A407 18 0b
    LD A,($A010)                         ; $A409 3a 10 a0
    CP $05                               ; $A40C fe 05
    LD A,($A35F)                         ; $A40E 3a 5f a3
    CALL $A745                           ; $A411 cd 45 a7
    LD A,$2E                             ; $A414 3e 2e
    JP $A9B7                             ; $A416 c3 b7 a9

    ORG $A5CD
; CODE: Token lungo: conserva il nibble di modo nella chiamata lessicale
    LD A,(IX+$00)                        ; $A5CD dd 7e 00
    BIT 7,A                              ; $A5D0 cb 7f
    JR Z,$A5F2                           ; $A5D2 28 1e
; Il primo byte del token AND7F diventa D: i bit12–14 non sono parte dell’offset ma restano nel riferimento conservato. Non memorizzare solo il risultato flesso o il testo inglese.
    AND $7F                              ; $A5D4 e6 7f
    LD D,A                               ; $A5D6 57
    LD E,(IX+$01)                        ; $A5D7 dd 5e 01
    INC IX                               ; $A5DA dd 23
    AND $F0                              ; $A5DC e6 f0
    CP $30                               ; $A5DE fe 30
    JR Z,$A647                           ; $A5E0 28 65
    CP $20                               ; $A5E2 fe 20
    JR Z,$A647                           ; $A5E4 28 61
    CP $60                               ; $A5E6 fe 60
    JR Z,$A647                           ; $A5E8 28 5d
    CALL $A887                           ; $A5EA cd 87 a8
    INC IX                               ; $A5ED dd 23
    OR $01                               ; $A5EF f6 01
    RET                                  ; $A5F1 c9

    ORG $A63F
; CODE: Terminazione: parola finale e CR senza riscrittura del riferimento
    LD D,$60                             ; $A63F 16 60
    JR $A64A                             ; $A641 18 07
    LD D,$30                             ; $A643 16 30
    JR $A64A                             ; $A645 18 03
; Una parola terminale attraversa ancora A887 prima di punto/CR. Gli ingressi A63F/A643 dei comandi senza parola saltano questo CALL e mantengono il riferimento precedente.
    CALL $A887                           ; $A647 cd 87 a8
    LD A,$2E                             ; $A64A 3e 2e
    BIT 6,D                              ; $A64C cb 72
    JR NZ,$A657                          ; $A64E 20 07
    BIT 4,D                              ; $A650 cb 62
    CALL NZ,$A9B7                        ; $A652 c4 b7 a9
    BIT 4,D                              ; $A655 cb 62
    CALL NZ,$A2A2                        ; $A657 c4 a2 a2
    XOR A                                ; $A65A af
    RET                                  ; $A65B c9
    RET                                  ; $A65C c9
    XOR A                                ; $A65D af

    ORG $A815
; CODE: Nome: ricompone il modo40 o50 prima dell’emissione
    PUSH AF                              ; $A815 f5
    LD A,D                               ; $A816 7a
    AND $0F                              ; $A817 e6 0f
    LD D,A                               ; $A819 57
    POP AF                               ; $A81A f1
; D=A|nibble basso dell’offset.40 forza il suffisso,50 usa la radice; il byte basso non viene ricavato dall’ultima parola visibile a video.
    OR D                                 ; $A81B b2
    LD D,A                               ; $A81C 57
    AND $0F                              ; $A81D e6 0f
    OR E                                 ; $A81F b3
    RET Z                                ; $A820 c8
    CALL $A887                           ; $A821 cd 87 a8
    LD A,($A7EA)                         ; $A824 3a ea a7
    PUSH HL                              ; $A827 e5
    LD HL,$A026                          ; $A828 21 26 a0
    OR (HL)                              ; $A82B b6
    LD (HL),A                            ; $A82C 77
    POP HL                               ; $A82D e1
    RET                                  ; $A82E c9

    ORG $A880
; CODE: Ingresso lessicale: gating, primo store e riferimento zero
    LD E,(HL)                            ; $A880 5e
    INC HL                               ; $A881 23
    LD A,(HL)                            ; $A882 7e
    INC HL                               ; $A883 23
    AND $0F                              ; $A884 e6 0f
    LD D,A                               ; $A886 57
; 5C3C=0: ritorna PRIMA di qualunque store. Un dialogo fuori scena può inviare caratteri letterali al workspace ma non modifica questa word lessicale.
    LD A,($5C3C)                         ; $A887 3a 3c 5c
    AND A                                ; $A88A a7
    RET Z                                ; $A88B c8
; Primo store DE, inclusi i tag e il riferimento zero. Con offset0 torna subito adA894 e conserva proprio quel descrittore.
    LD ($A022),DE                        ; $A88C ed 53 22 a0
    LD A,D                               ; $A890 7a
    AND $0F                              ; $A891 e6 0f
    OR E                                 ; $A893 b3
    RET Z                                ; $A894 c8

    ORG $A895
; CODE: Spazio iniziale e secondo store del riferimento con il suo modo
    PUSH IX                              ; $A895 dd e5
    PUSH HL                              ; $A897 e5
    PUSH BC                              ; $A898 c5
    PUSH DE                              ; $A899 d5
    LD A,$20                             ; $A89A 3e 20
; Lo spazio può svuotare la parola precedente; il descrittore corrente è già stato conservato. Nessuna estrazione casuale viene inventata a questo punto.
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
; Secondo store HL. Il nibble di contesto salvato in C viene ricombinato con l’offset: il valore non cambia per via della desinenza che verrà applicata dopo.
    LD ($A022),HL                        ; $A8B5 22 22 a0
    POP HL                               ; $A8B8 e1

    ORG $A8B9
; CODE: Ricostruzione della parola e suffisso: il riferimento rimane conservato
    PUSH BC                              ; $A8B9 c5
    LD IX,$5D80                          ; $A8BA dd 21 80 5d
    LD B,$5F                             ; $A8BE 06 5f
    INC B                                ; $A8C0 04
    LD A,(IX+$01)                        ; $A8C1 dd 7e 01
    CP H                                 ; $A8C4 bc
    JR C,$A8CF                           ; $A8C5 38 08
    JR NZ,$A8D9                          ; $A8C7 20 10
    LD A,(IX+$00)                        ; $A8C9 dd 7e 00
    CP L                                 ; $A8CC bd
    JR NC,$A8D9                          ; $A8CD 30 0a
    INC IX                               ; $A8CF dd 23
    INC IX                               ; $A8D1 dd 23
    LD A,B                               ; $A8D3 78
    CP $7B                               ; $A8D4 fe 7b
    JR NZ,$A8C0                          ; $A8D6 20 e8
    INC B                                ; $A8D8 04
    JR Z,$A8E0                           ; $A8D9 28 05
    DEC IX                               ; $A8DB dd 2b
    DEC IX                               ; $A8DD dd 2b
    DEC B                                ; $A8DF 05
    LD E,(IX+$00)                        ; $A8E0 dd 5e 00
    LD D,(IX+$01)                        ; $A8E3 dd 56 01
    LD A,D                               ; $A8E6 7a
    OR E                                 ; $A8E7 b3
    JR Z,$A8DB                           ; $A8E8 28 f1
    LD A,B                               ; $A8EA 78
    CALL $A9B7                           ; $A8EB cd b7 a9
    LD BC,$5DBF                          ; $A8EE 01 bf 5d
    ADD HL,BC                            ; $A8F1 09
    PUSH HL                              ; $A8F2 e5
    EX DE,HL                             ; $A8F3 eb
    ADD HL,BC                            ; $A8F4 09
    PUSH HL                              ; $A8F5 e5
    AND A                                ; $A8F6 a7
    SBC HL,DE                            ; $A8F7 ed 52
    POP HL                               ; $A8F9 e1
    PUSH AF                              ; $A8FA f5
    CALL $A95B                           ; $A8FB cd 5b a9
    POP AF                               ; $A8FE f1
    JR NZ,$A8F5                          ; $A8FF 20 f4
    POP HL                               ; $A901 e1
    POP BC                               ; $A902 c1
; 50 usa la radice,40 forza la desinenza,10 dipende dall’oggetto, altri contesti dall’attore. A022/A023 non sono modificati da questa decisione.
    LD A,C                               ; $A903 79
    CP $50                               ; $A904 fe 50
    JR Z,$A91C                           ; $A906 28 14
    CP $40                               ; $A908 fe 40
    JR Z,$A919                           ; $A90A 28 0d
    CP $10                               ; $A90C fe 10
    LD A,($A034)                         ; $A90E 3a 34 a0
    JR Z,$A916                           ; $A911 28 03
    LD A,($A036)                         ; $A913 3a 36 a0
    AND A                                ; $A916 a7
    JR Z,$A91C                           ; $A917 28 03
    CALL $A92F                           ; $A919 cd 2f a9
    LD HL,$5C42                          ; $A91C 21 42 5c
    LD A,(HL)                            ; $A91F 7e
    AND A                                ; $A920 a7
    JR Z,$A929                           ; $A921 28 06
    CALL $A9B7                           ; $A923 cd b7 a9
    INC HL                               ; $A926 23
    JR $A91F                             ; $A927 18 f6
    POP DE                               ; $A929 d1
    POP BC                               ; $A92A c1
    POP HL                               ; $A92B e1
    POP IX                               ; $A92C dd e1
    RET                                  ; $A92E c9

    ORG $D3E8
; CODE: Nomi dinamici: qualificatori con modo40, sostantivo con modo50
    PUSH AF                              ; $D3E8 f5
    PUSH DE                              ; $D3E9 d5
    LD D,(IY+$01)                        ; $D3EA fd 56 01
    LD E,(IY+$00)                        ; $D3ED fd 5e 00
    CALL $A7D0                           ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                       ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                          ; $D3F7 20 04
    XOR A                                ; $D3F9 af
    LD ($A7EA),A                         ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                       ; $D3FD fd cb ff 6e
    JR NZ,$D427                          ; $D401 20 24
    JR $D416                             ; $D403 18 11
    PUSH AF                              ; $D405 f5
    PUSH DE                              ; $D406 d5
    LD D,(IY+$01)                        ; $D407 fd 56 01
    LD E,(IY+$00)                        ; $D40A fd 5e 00
    CALL $A7D0                           ; $D40D cd d0 a7
    LD A,($A028)                         ; $D410 3a 28 a0
    AND A                                ; $D413 a7
    JR NZ,$D438                          ; $D414 20 22
    LD E,(IY+$02)                        ; $D416 fd 5e 02
    LD D,(IY+$03)                        ; $D419 fd 56 03
    RES 7,D                              ; $D41C cb ba
    BIT 7,(IY+$03)                       ; $D41E fd cb 03 7e
    LD A,$40                             ; $D422 3e 40
; Qualificatore con contesto40 se il riferimento non è mascherato. La resa del possessivo non cambia il suo offset originale.
    CALL Z,$A815                         ; $D424 cc 15 a8
    LD E,(IY+$04)                        ; $D427 fd 5e 04
    LD D,(IY+$05)                        ; $D42A fd 56 05
    RES 7,D                              ; $D42D cb ba
    BIT 7,(IY+$05)                       ; $D42F fd cb 05 7e
    LD A,$40                             ; $D433 3e 40
    CALL Z,$A815                         ; $D435 cc 15 a8
    LD E,(IY+$00)                        ; $D438 fd 5e 00
    LD D,(IY+$01)                        ; $D43B fd 56 01
    LD A,D                               ; $D43E 7a
    OR E                                 ; $D43F b3
    LD A,$50                             ; $D440 3e 50
; Sostantivo nonzero con contesto50. Ultimo writer naturale: tick964, attore0, STREET0861 emesso come5861; il giardiniere ne legge il byte61 a tick2852. Il runtime lo calcola dal record di locazione, non da questa traccia.
    CALL NZ,$A815                        ; $D442 c4 15 a8
    POP DE                               ; $D445 d1
    POP AF                               ; $D446 f1
    RET                                  ; $D447 c9
