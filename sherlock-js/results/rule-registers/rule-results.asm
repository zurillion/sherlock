; Analisi offline: dati tipizzati separati dal codice; byte riasssemblati contro il payload.

    ORG $CB28
; DATA: Puntatori IX/IY restituiti dall’ultima regola
    DEFB $00,$00,$00,$00                  ; $CB28 00 00 00 00 | Due word little-endian mutabili, non istruzioni. Primo risultato IX, secondo IY. La riscrittura ne possiede solo i callback ricostruiti; i percorsi ignoti revocano il campo, senza fallback al payload.

    ORG $CB2C
; CODE: Ponte regole: ripristino, chiamata e conservazione dei risultati
    LD IX,($CB28)                         ; $CB2C dd 2a 28 cb | Il corpo riprende i risultati precedenti: non ricarica genericamente i due argomenti.
    LD IY,($CB2A)                         ; $CB30 fd 2a 2a cb
    CALL $CB40                            ; $CB34 cd 40 cb | Ingresso del predicato: il chiamante ha già selezionato IX e intestazione IY. Anche un predicato falso ritorna qui e salva i suoi risultati.
    LD ($CB28),IX                         ; $CB37 dd 22 28 cb | Unico store del primo risultato. OPEN/CLOSE ordinari lasciano il descrittore caricato da A013; contatori e rilascio lasciano record o link specifici.
    LD ($CB2A),IY                         ; $CB3B fd 22 2a cb | Unico store del secondo risultato. IY può essere un’intestazione, un predecessore o altro: non dedurlo sempre dal primo puntatore.
    RET                                   ; $CB3F c9
    JP (HL)                               ; $CB40 e9

    ORG $C9BF
; CODE: Preflight, predicato, durata e corpo immediato o differito
    PUSH HL                               ; $C9BF e5
    POP IY                                ; $C9C0 fd e1
    CALL $D078                            ; $C9C2 cd 78 d0
    JR NC,$C9D3                           ; $C9C5 30 0c
    LD A,(IY+$00)                         ; $C9C7 fd 7e 00
    AND $20                               ; $C9CA e6 20
    JR Z,$C9D3                            ; $C9CC 28 05
    LD HL,$CBBB                           ; $C9CE 21 bb cb
    XOR A                                 ; $C9D1 af
    RET                                   ; $C9D2 c9
    CALL $C628                            ; $C9D3 cd 28 c6
    JR Z,$C9D1                            ; $C9D6 28 f9
    CALL $C6BE                            ; $C9D8 cd be c6
    JR Z,$C9D1                            ; $C9DB 28 f4
    BIT 6,(IY+$00)                        ; $C9DD fd cb 00 76 | Il predicato esiste solo con bit6. I controlli di luce/classi precedenti possono fallire prima del ponte.
    JR Z,$C9F2                            ; $C9E1 28 0f
    LD L,(IY+$02)                         ; $C9E3 fd 6e 02
    LD H,(IY+$03)                         ; $C9E6 fd 66 03
    PUSH IY                               ; $C9E9 fd e5
    CALL $CB34                            ; $C9EB cd 34 cb | Predicato via CB34, poi ripristino dell’intestazione di selezione. CB28/CB2A conservano comunque ciò che il predicato ha restituito.
    POP IY                                ; $C9EE fd e1
    JR Z,$C9D1                            ; $C9F0 28 df
    LD A,($A00B)                          ; $C9F2 3a 0b a0
    AND A                                 ; $C9F5 a7
    JR NZ,$C9FB                           ; $C9F6 20 03
    OR $01                                ; $C9F8 f6 01
    RET                                   ; $C9FA c9
    PUSH IY                               ; $C9FB fd e5
    LD A,(IY+$01)                         ; $C9FD fd 7e 01
    RRCA                                  ; $CA00 0f
    RRCA                                  ; $CA01 0f
    RRCA                                  ; $CA02 0f
    RRCA                                  ; $CA03 0f
    AND $0F                               ; $CA04 e6 0f
    LD L,A                                ; $CA06 6f
    LD H,$00                              ; $CA07 26 00
    LD ($A01F),HL                         ; $CA09 22 1f a0
    POP HL                                ; $CA0C e1
    LD DE,$0002                           ; $CA0D 11 02 00
    ADD HL,DE                             ; $CA10 19
    BIT 6,(IY+$00)                        ; $CA11 fd cb 00 76
    JR Z,$CA18                            ; $CA15 28 01
    ADD HL,DE                             ; $CA17 19
    LD DE,$0005                           ; $CA18 11 05 00
    BIT 4,(IY+$00)                        ; $CA1B fd cb 00 66
    JR Z,$CA22                            ; $CA1F 28 01
    ADD HL,DE                             ; $CA21 19
    LD A,($A00A)                          ; $CA22 3a 0a a0
    LD ($C491),A                          ; $CA25 32 91 c4
    LD IX,($A013)                         ; $CA28 dd 2a 13 a0
    LD A,(IX+$0F)                         ; $CA2C dd 7e 0f
    LD ($C492),A                          ; $CA2F 32 92 c4
    PUSH HL                               ; $CA32 e5
    PUSH IY                               ; $CA33 fd e5
    LD A,$01                              ; $CA35 3e 01
    LD ($A00C),A                          ; $CA37 32 0c a0
    CALL $CA76                            ; $CA3A cd 76 ca
    POP IY                                ; $CA3D fd e1
    POP HL                                ; $CA3F e1
    BIT 7,(IY+$00)                        ; $CA40 fd cb 00 7e | Il bit7 differisce il corpo: non si entra CB2C in questa visita.
    JR Z,$CA48                            ; $CA44 28 02
    SCF                                   ; $CA46 37
    RET                                   ; $CA47 c9
    LD A,($9FD7)                          ; $CA48 3a d7 9f
    INC A                                 ; $CA4B 3c
    JR NZ,$CA54                           ; $CA4C 20 06
    LD A,($A034)                          ; $CA4E 3a 34 a0
    LD ($9FD7),A                          ; $CA51 32 d7 9f
    LD A,($9FD8)                          ; $CA54 3a d8 9f
    INC A                                 ; $CA57 3c
    JR NZ,$CA60                           ; $CA58 20 06
    LD A,($A035)                          ; $CA5A 3a 35 a0
    LD ($9FD8),A                          ; $CA5D 32 d8 9f
    XOR A                                 ; $CA60 af
    LD ($CAAE),A                          ; $CA61 32 ae ca
    CALL $CB2C                            ; $CA64 cd 2c cb | Corpo immediato via CB2C: carica i risultati della chiamata precedente, non i puntatori A013/A015 per convenzione.
    PUSH AF                               ; $CA67 f5
    PUSH HL                               ; $CA68 e5
    CALL $CA7F                            ; $CA69 cd 7f ca
    LD A,($CAAE)                          ; $CA6C 3a ae ca
    AND A                                 ; $CA6F a7
    CALL Z,$CAAF                          ; $CA70 cc af ca
    POP HL                                ; $CA73 e1
    POP AF                                ; $CA74 f1
    RET                                   ; $CA75 c9

    ORG $A1C7
; CODE: Rilascio dei record: link finale e fusioni dei blocchi liberi
    PUSH HL                               ; $A1C7 e5
    PUSH DE                               ; $A1C8 d5
    PUSH IX                               ; $A1C9 dd e5
    POP HL                                ; $A1CB e1
    DEC HL                                ; $A1CC 2b
    DEC HL                                ; $A1CD 2b
    DEC HL                                ; $A1CE 2b
    LD IX,$9FE3                           ; $A1CF dd 21 e3 9f | La ricerca parte dal link della testa libera 9FE3 e avanza in ordine.
    LD E,(IX+$00)                         ; $A1D3 dd 5e 00
    LD D,(IX+$01)                         ; $A1D6 dd 56 01
    LD A,D                                ; $A1D9 7a
    OR E                                  ; $A1DA b3
    JR Z,$A1EB                            ; $A1DB 28 0e
    PUSH HL                               ; $A1DD e5
    AND A                                 ; $A1DE a7
    SBC HL,DE                             ; $A1DF ed 52
    POP HL                                ; $A1E1 e1
    JR C,$A1EB                            ; $A1E2 38 07
    INC DE                                ; $A1E4 13
    INC DE                                ; $A1E5 13
    PUSH DE                               ; $A1E6 d5
    POP IX                                ; $A1E7 dd e1
    JR $A1D3                              ; $A1E9 18 e8
    LD (IX+$00),L                         ; $A1EB dd 75 00
    LD (IX+$01),H                         ; $A1EE dd 74 01
    INC HL                                ; $A1F1 23
    LD (HL),$00                           ; $A1F2 36 00
    INC HL                                ; $A1F4 23
    LD (HL),E                             ; $A1F5 73
    INC HL                                ; $A1F6 23
    LD (HL),D                             ; $A1F7 72
    CALL $A20C                            ; $A1F8 cd 0c a2
    JR Z,$A206                            ; $A1FB 28 09
    LD L,(IX+$00)                         ; $A1FD dd 6e 00 | Solo se la prima fusione fallisce, carica il valore del link come IX: è lo start del blocco liberato, non start+2. Non correggere la stranezza originale.
    LD H,(IX+$01)                         ; $A200 dd 66 01
    PUSH HL                               ; $A203 e5
    POP IX                                ; $A204 dd e1
    CALL $A20C                            ; $A206 cd 0c a2 | La seconda fusione mantiene IX; il suo risultato non sceglie un nuovo puntatore.
    POP DE                                ; $A209 d1
    POP HL                                ; $A20A e1
    RET                                   ; $A20B c9
    PUSH IX                               ; $A20C dd e5
    POP HL                                ; $A20E e1
    DEC HL                                ; $A20F 2b
    DEC HL                                ; $A210 2b
    LD E,(IX-$02)                         ; $A211 dd 5e fe
    LD D,(IX-$01)                         ; $A214 dd 56 ff
    ADD HL,DE                             ; $A217 19
    LD E,(IX+$00)                         ; $A218 dd 5e 00
    LD D,(IX+$01)                         ; $A21B dd 56 01
    LD A,D                                ; $A21E 7a
    OR E                                  ; $A21F b3
    JR NZ,$A225                           ; $A220 20 03
    OR $01                                ; $A222 f6 01
    RET                                   ; $A224 c9
    AND A                                 ; $A225 a7
    SBC HL,DE                             ; $A226 ed 52
    RET NZ                                ; $A228 c0
    LD L,(IX+$00)                         ; $A229 dd 6e 00
    LD H,(IX+$01)                         ; $A22C dd 66 01
    PUSH BC                               ; $A22F c5
    LD E,(HL)                             ; $A230 5e
    INC HL                                ; $A231 23
    LD D,(HL)                             ; $A232 56
    INC HL                                ; $A233 23
    LD C,(HL)                             ; $A234 4e
    INC HL                                ; $A235 23
    LD B,(HL)                             ; $A236 46
    LD L,(IX-$02)                         ; $A237 dd 6e fe
    LD H,(IX-$01)                         ; $A23A dd 66 ff
    ADD HL,DE                             ; $A23D 19
    LD (IX-$02),L                         ; $A23E dd 75 fe
    LD (IX-$01),H                         ; $A241 dd 74 ff
    LD (IX+$00),C                         ; $A244 dd 71 00
    LD (IX+$01),B                         ; $A247 dd 70 01
    POP BC                                ; $A24A c1
    XOR A                                 ; $A24B af
    RET                                   ; $A24C c9

    ORG $E52F
; DATA: Intestazione tipizzata · Creazione del contatore privato
    DEFB $07,$07                          ; $E52F 07 07

    ORG $E531
; CODE: Creazione del contatore privato
    LD A,$02                              ; $E531 3e 02 | Alloca due byte di dati: il puntatore del nuovo contatore rimane in IX. A11C preserva IY.
    CALL $A11C                            ; $E533 cd 1c a1
    LD HL,($9FE5)                         ; $E536 2a e5 9f
    LD ($9FE5),IX                         ; $E539 dd 22 e5 9f
    LD (IX-$02),L                         ; $E53D dd 75 fe
    LD (IX-$01),H                         ; $E540 dd 74 ff
    LD A,($A036)                          ; $E543 3a 36 a0
    LD (IX+$00),A                         ; $E546 dd 77 00
    LD A,($A035)                          ; $E549 3a 35 a0
    LD B,$00                              ; $E54C 06 00
    CP $FF                                ; $E54E fe ff
    JR Z,$E556                            ; $E550 28 04
    CALL $D2A4                            ; $E552 cd a4 d2 | La scelta casuale avviene prima dello store CB37. Durante il draw CB28 conserva il risultato precedente, non il record appena allocato.
    LD B,A                                ; $E555 47
    LD A,($A034)                          ; $E556 3a 34 a0
    ADD A,B                               ; $E559 80
    LD (IX+$01),A                         ; $E55A dd 77 01
    OR $01                                ; $E55D f6 01
    RET                                   ; $E55F c9

    ORG $E57A
; DATA: Intestazione tipizzata · Decremento del contatore privato
    DEFB $40,$00,$73,$E5                  ; $E57A 40 00 73 e5

    ORG $E57E
; CODE: Decremento del contatore privato
    DEC (IX+$01)                          ; $E57E dd 35 01 | Se il decremento non arriva a zero, conserva il record. A zero passa al rilascio E58C e restituisce il suo link, anche se il risultato logico è fallimento.
    RET NZ                                ; $E581 c0
    CALL $E58C                            ; $E582 cd 8c e5
    JP $DC15                              ; $E585 c3 15 dc

    ORG $E588
; DATA: Intestazione tipizzata · Cancellazione del contatore privato
    DEFB $40,$00,$73,$E5                  ; $E588 40 00 73 e5

    ORG $E58C
; CODE: Cancellazione del contatore privato
    PUSH IX                               ; $E58C dd e5
    POP DE                                ; $E58E d1
    LD IY,$9FE5                           ; $E58F fd 21 e5 9f | A104 cerca il predecessore della lista dei contatori. Primo elemento: IY=9FE7; altrimenti IY=record precedente.
    CALL $A104                            ; $E593 cd 04 a1
    LD L,(IX-$02)                         ; $E596 dd 6e fe
    LD H,(IX-$01)                         ; $E599 dd 66 ff
    LD (IY-$02),L                         ; $E59C fd 75 fe
    LD (IY-$01),H                         ; $E59F fd 74 ff
    CALL $A1C7                            ; $E5A2 cd c7 a1 | A1C7 lascia in IX il link libero derivato dalle fusioni. È diverso dall’IY predecessore della lista dei contatori.
    OR $01                                ; $E5A5 f6 01
    RET                                   ; $E5A7 c9

    ORG $E5A8
; DATA: Intestazione tipizzata · Attesa di un tick
    DEFB $00,$10                          ; $E5A8 00 10

    ORG $E5AA
; CODE: Attesa di un tick
    OR $01                                ; $E5AA f6 01
    RET                                   ; $E5AC c9

    ORG $DE9D
; DATA: Intestazione tipizzata · OPEN ordinario: descrittore dell’oggetto restituito
    DEFB $38,$10,$80,$21,$00,$00,$00      ; $DE9D 38 10 80 21 00 00 00

    ORG $DEA4
; CODE: OPEN ordinario: descrittore dell’oggetto restituito
    LD IX,($A013)                         ; $DEA4 dd 2a 13 a0 | LD IX,(A013) possiede esplicitamente il descrittore dell’oggetto. Il modello lo deriva dall’ID risolto solo dopo il corpo ordinario riuscito.
    SET 5,(IX+$05)                        ; $DEA8 dd cb 05 ee
    OR $01                                ; $DEAC f6 01
    RET                                   ; $DEAE c9

    ORG $DEAF
; DATA: Intestazione tipizzata · CLOSE ordinario: descrittore dell’oggetto restituito
    DEFB $38,$10,$00,$20,$00,$00,$00      ; $DEAF 38 10 00 20 00 00 00

    ORG $DEB6
; CODE: CLOSE ordinario: descrittore dell’oggetto restituito
    LD IX,($A013)                         ; $DEB6 dd 2a 13 a0 | Anche CLOSE ricarica A013. Non bisogna conservarvi il puntatore di un precedente contatore.
    RES 5,(IX+$05)                        ; $DEBA dd cb 05 ae
    OR $01                                ; $DEBE f6 01
    RET                                   ; $DEC0 c9

    ORG $F198
; DATA: Intestazione tipizzata · Scelta probabilistica: conserva i puntatori della regola
    DEFB $07,$00                          ; $F198 07 00

    ORG $F19A
; CODE: Scelta probabilistica: conserva i puntatori della regola
    CALL $D29D                            ; $F19A cd 9d d2 | D29D conserva IX/IY sullo stack; la regola restituisce quindi i risultati entranti. Nessun nuovo valore viene inventato dalla percentuale.
    LD B,A                                ; $F19D 47
    LD A,($A034)                          ; $F19E 3a 34 a0
    CP B                                  ; $F1A1 b8
    JP C,$DC15                            ; $F1A2 da 15 dc
    OR $01                                ; $F1A5 f6 01
    RET                                   ; $F1A7 c9

    ORG $F1D6
; DATA: Intestazione tipizzata · Test dell’ora: conserva i puntatori entranti
    DEFB $07,$00                          ; $F1D6 07 00

    ORG $F1D8
; CODE: Test dell’ora: conserva i puntatori entranti
    LD A,($A034)                          ; $F1D8 3a 34 a0 | Il confronto usa A/B/HL e non modifica IX/IY, anche nei ritorni di fallimento DC15.
    LD B,$61                              ; $F1DB 06 61
    CP $0D                                ; $F1DD fe 0d
    JR C,$F1E5                            ; $F1DF 38 04
    LD B,$70                              ; $F1E1 06 70
    SUB $0C                               ; $F1E3 d6 0c
    LD HL,$9FE0                           ; $F1E5 21 e0 9f
    CP (HL)                               ; $F1E8 be
    JP NZ,$DC15                           ; $F1E9 c2 15 dc
    LD A,($9FE2)                          ; $F1EC 3a e2 9f
    CP B                                  ; $F1EF b8
    JP NZ,$DC15                           ; $F1F0 c2 15 dc
    OR $01                                ; $F1F3 f6 01
    RET                                   ; $F1F5 c9

    ORG $D769
; DATA: Intestazione tipizzata · Polling del parser: rami di ritorno ancora non proiettati
    DEFB $40,$00,$70,$D7                  ; $D769 40 00 70 d7

    ORG $D76D
; CODE: Polling del parser: rami di ritorno ancora non proiettati
    OR $01                                ; $D76D f6 01
    RET                                   ; $D76F c9
    LD HL,($D6BD)                         ; $D770 2a bd d6 | Il polling del parser può riscrivere CB28 dopo l’ultimo NPC. Questa analisi non completa tutti i suoi rami: tornando al prompt si revoca il campo.
    LD A,(HL)                             ; $D773 7e
    AND $F0                               ; $D774 e6 f0
    CP $C0                                ; $D776 fe c0
    JP Z,$DC15                            ; $D778 ca 15 dc
    OR $01                                ; $D77B f6 01
    RET                                   ; $D77D c9

    ORG $E560
; CODE: Ricerca del contatore: puntatore al record o zero
    LD IX,$9FE7                           ; $E560 dd 21 e7 9f | A0F7 attraversa la lista: alla fine IX è il record trovato o zero. IY dell’intestazione rimane intatto.
    CALL $A0F7                            ; $E564 cd f7 a0
    RET Z                                 ; $E567 c8
    LD A,($A036)                          ; $E568 3a 36 a0
    CP (IX+$00)                           ; $E56B dd be 00
    JR NZ,$E564                           ; $E56E 20 f4
    OR $01                                ; $E570 f6 01
    RET                                   ; $E572 c9
    CALL $E560                            ; $E573 cd 60 e5 | Un predicato senza contatore fallisce ma salva comunque IX=0 e IY=intestazione.
    JP Z,$DC15                            ; $E576 ca 15 dc
    RET                                   ; $E579 c9
