; Analisi offline, dati distinti dal codice; nessuna esecuzione Z80 nel motore JS.

    ORG $A11A
; DATA: Allocatore: link che precede il blocco migliore
    DEFB $00,$00                          ; $A11A 00 00 | Word temporanea mutabile. Conserva l’indirizzo del link che porta al candidato scelto:9FE3 se il candidato è la testa, altrimenti precedente+2. Non è l’indirizzo del candidato e non si ricalcola dalla lista finale. A151 la aggiorna per ogni candidato migliore o uguale; release e scansioni senza candidati la conservano. Nessun fallback nei vecchi salvataggi.

    ORG $A11C
; CODE: Allocazione best fit: scansione e sostituzione anche a parità
    PUSH IY                               ; $A11C fd e5
    PUSH HL                               ; $A11E e5
    PUSH DE                               ; $A11F d5
    PUSH BC                               ; $A120 c5
    ADD A,$03                             ; $A121 c6 03 | La richiesta riguarda il payload: aggiunge tre byte per dimensione e link. I chiamanti ricostruiti usano dimensioni valide entro la capacità del byte.
    LD C,A                                ; $A123 4f
    LD B,$00                              ; $A124 06 00
    LD HL,($9FE3)                         ; $A126 2a e3 9f
    LD IY,$9FE3                           ; $A129 fd 21 e3 9f | Prima del primo blocco, IY punta alla word testa della lista libera, non dentro l’arena.
    LD A,L                                ; $A12D 7d
    OR H                                  ; $A12E b4
    JR Z,$A160                            ; $A12F 28 2f
    LD E,(HL)                             ; $A131 5e
    INC HL                                ; $A132 23
    LD D,(HL)                             ; $A133 56
    INC HL                                ; $A134 23
    LD A,D                                ; $A135 7a
    AND A                                 ; $A136 a7
    JR NZ,$A13D                           ; $A137 20 04
    LD A,E                                ; $A139 7b
    CP C                                  ; $A13A b9
    JR C,$A157                            ; $A13B 38 1a
    BIT 0,B                               ; $A13D cb 40 | Bit0 di B indica se è già stato trovato un candidato abbastanza grande. I blocchi troppo piccoli non cancellano il candidato precedente.
    JR Z,$A14E                            ; $A13F 28 0d
    PUSH HL                               ; $A141 e5
    LD L,(IX-$02)                         ; $A142 dd 6e fe
    LD H,(IX-$01)                         ; $A145 dd 66 ff
    AND A                                 ; $A148 a7
    SBC HL,DE                             ; $A149 ed 52 | Confronta la dimensione del candidato precedente con quella corrente. Salta solo se il precedente è strettamente più piccolo: a parità sceglie l’ULTIMO blocco.
    POP HL                                ; $A14B e1
    JR C,$A157                            ; $A14C 38 09
    PUSH HL                               ; $A14E e5
    POP IX                                ; $A14F dd e1
    LD ($A11A),IY                         ; $A151 fd 22 1a a1 | Conserva il link PRECEDENTE al candidato prima che IY diventi il link corrente. Anche una scrittura dello stesso valore è una nuova selezione.
    SET 0,B                               ; $A155 cb c0
    PUSH HL                               ; $A157 e5 | Il link corrente diventa il predecessore del prossimo blocco, anche se il corrente era troppo piccolo o non migliorava il candidato.
    POP IY                                ; $A158 fd e1
    LD E,(HL)                             ; $A15A 5e
    INC HL                                ; $A15B 23
    LD D,(HL)                             ; $A15C 56
    EX DE,HL                              ; $A15D eb
    JR $A12D                              ; $A15E 18 cd

    ORG $A160
; CODE: Allocazione: assorbimento del resto, taglio in coda e azzeramento
    BIT 0,B                               ; $A160 cb 40 | Nessun candidato: passa al servizio di memoria esaurita, senza azzerare A11A. Le prove controllate si fermano a C1D8 prima della UI: non certificano la gestione del messaggio di esaurimento.
    JR Z,$A1AC                            ; $A162 28 48
    LD L,(IX-$02)                         ; $A164 dd 6e fe
    LD H,(IX-$01)                         ; $A167 dd 66 ff
    LD B,$00                              ; $A16A 06 00
    AND A                                 ; $A16C a7
    SBC HL,BC                             ; $A16D ed 42 | Resto = dimensione del candidato meno payload+3.
    LD A,H                                ; $A16F 7c
    AND A                                 ; $A170 a7
    JR NZ,$A18A                           ; $A171 20 17
    LD A,L                                ; $A173 7d
    CP $04                                ; $A174 fe 04 | Resti0..3 non possono formare un nodo libero di quattro byte: assorbe l’intero blocco.
    JR NC,$A18A                           ; $A176 30 12
    LD IY,($A11A)                         ; $A178 fd 2a 1a a1 | Ricarica il link salvato e lo riscrive per saltare il blocco consumato. Il valore A11A rimane quello selezionato, anche se il suo contenuto cambia.
    LD A,(IX+$00)                         ; $A17C dd 7e 00
    LD (IY+$00),A                         ; $A17F fd 77 00
    LD A,(IX+$01)                         ; $A182 dd 7e 01
    LD (IY+$01),A                         ; $A185 fd 77 01
    JR $A193                              ; $A188 18 09
    LD (IX-$02),L                         ; $A18A dd 75 fe | Con resto>=4 il blocco libero rimane all’inizio; il record è tagliato dalla CODA.
    LD (IX-$01),H                         ; $A18D dd 74 ff
    EX DE,HL                              ; $A190 eb
    ADD IX,DE                             ; $A191 dd 19
    INC IX                                ; $A193 dd 23
    LD (IX-$03),C                         ; $A195 dd 71 fd | La dimensione allocata è un byte; il record pubblico punta tre byte dopo l’inizio fisico.
    PUSH IX                               ; $A198 dd e5
    POP HL                                ; $A19A e1
    DEC HL                                ; $A19B 2b
    DEC HL                                ; $A19C 2b
    LD B,C                                ; $A19D 41
    DEC B                                 ; $A19E 05
    XOR A                                 ; $A19F af
    LD (HL),A                             ; $A1A0 77 | Azzera link e payload del record allocato, non l’intera area libera o il resto assorbito.
    INC HL                                ; $A1A1 23
    DJNZ $A1A0                            ; $A1A2 10 fc
    OR $01                                ; $A1A4 f6 01
    POP BC                                ; $A1A6 c1
    POP DE                                ; $A1A7 d1
    POP HL                                ; $A1A8 e1
    POP IY                                ; $A1A9 fd e1
    RET                                   ; $A1AB c9
    JP $C1D8                              ; $A1AC c3 d8 c1

    ORG $A1AF
; CODE: Liberazione di una catena di record
    PUSH HL                               ; $A1AF e5 | Rilascia una lista: conserva il successore letto dal record corrente prima che la liberazione ne sovrascriva il link.
    PUSH IX                               ; $A1B0 dd e5
    POP HL                                ; $A1B2 e1
    JR $A1C1                              ; $A1B3 18 0c
    LD L,(IX-$02)                         ; $A1B5 dd 6e fe
    LD H,(IX-$01)                         ; $A1B8 dd 66 ff
    CALL $A1C7                            ; $A1BB cd c7 a1
    PUSH HL                               ; $A1BE e5
    POP IX                                ; $A1BF dd e1
    LD A,L                                ; $A1C1 7d
    OR H                                  ; $A1C2 b4
    JR NZ,$A1B5                           ; $A1C3 20 f0
    POP HL                                ; $A1C5 e1
    RET                                   ; $A1C6 c9

    ORG $A1C7
; CODE: Liberazione: reinserimento ordinato e doppio tentativo di fusione
    PUSH HL                               ; $A1C7 e5 | Singolo rilascio: converte il puntatore del payload nell’inizio fisico, poi cerca la posizione ordinata per indirizzo.
    PUSH DE                               ; $A1C8 d5
    PUSH IX                               ; $A1C9 dd e5
    POP HL                                ; $A1CB e1
    DEC HL                                ; $A1CC 2b
    DEC HL                                ; $A1CD 2b
    DEC HL                                ; $A1CE 2b
    LD IX,$9FE3                           ; $A1CF dd 21 e3 9f
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
    LD (IX+$00),L                         ; $A1EB dd 75 00 | Collega il blocco liberato fra predecessore e successore; conserva il payload residuo e non modifica A11A.
    LD (IX+$01),H                         ; $A1EE dd 74 01
    INC HL                                ; $A1F1 23
    LD (HL),$00                           ; $A1F2 36 00
    INC HL                                ; $A1F4 23
    LD (HL),E                             ; $A1F5 73
    INC HL                                ; $A1F6 23
    LD (HL),D                             ; $A1F7 72
    CALL $A20C                            ; $A1F8 cd 0c a2 | Primo tentativo di fusione dal link precedente. L’esito decide l’indirizzo usato nel secondo tentativo.
    JR Z,$A206                            ; $A1FB 28 09
    LD L,(IX+$00)                         ; $A1FD dd 6e 00 | Quirk originale: se il primo tentativo non fonde, il secondo usa l’inizio del nuovo blocco, non il suo link+2. Il JS conserva questo comportamento; non ripararlo come un allocatore moderno.
    LD H,(IX+$01)                         ; $A200 dd 66 01
    PUSH HL                               ; $A203 e5
    POP IX                                ; $A204 dd e1
    CALL $A20C                            ; $A206 cd 0c a2
    POP DE                                ; $A209 d1
    POP HL                                ; $A20A e1
    RET                                   ; $A20B c9

    ORG $A20C
; CODE: Fusione dei blocchi liberi adiacenti
    PUSH IX                               ; $A20C dd e5 | Fonde solo quando fine del blocco corrente e inizio del successivo coincidono esattamente.
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
    ADD HL,DE                             ; $A23D 19 | Somma le dimensioni word e collega il successore del blocco assorbito. Non azzera il suo payload né il temporaneo A11A.
    LD (IX-$02),L                         ; $A23E dd 75 fe
    LD (IX-$01),H                         ; $A241 dd 74 ff
    LD (IX+$00),C                         ; $A244 dd 71 00
    LD (IX+$01),B                         ; $A247 dd 70 01
    POP BC                                ; $A24A c1
    XOR A                                 ; $A24B af
    RET                                   ; $A24C c9
