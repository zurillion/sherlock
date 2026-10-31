; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.

    ORG $A025
; DATA: Stato degli spazi: normalizzazione distinta dal cursore e dal parser
    DEFB $00                              ; $A025 00 | Flag persistente del normalizzatore:0 sopprime lo spazio, nonzero permette lo spazio. Byte iniziale estratto0, non un reset per comando. OldSAVE assente restaunknown finché un writer è dimostrato.

    ORG $A9B7
; CODE: Buffer e normalizzazione: i tre writer A025, confronto esatto prima del wrap
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0 | CanaleA027 nonzero salta il buffer e AA14: non modificaA025. Non confondere prompt inferiore e normalizzazione superiore.
    AND A                                 ; $A9BB a7
    JR NZ,$AA10                           ; $A9BC 20 52
    POP AF                                ; $A9BE f1
    PUSH AF                               ; $A9BF f5
    PUSH HL                               ; $A9C0 e5
    LD HL,($A9B5)                         ; $A9C1 2a b5 a9
    CP $20                                ; $A9C4 fe 20
    JR Z,$A9DF                            ; $A9C6 28 17
    CP $0D                                ; $A9C8 fe 0d
    JR Z,$A9DF                            ; $A9CA 28 13
    CP $22                                ; $A9CC fe 22
    JR Z,$A9DF                            ; $A9CE 28 0f
    CP $08                                ; $A9D0 fe 08
    JR NZ,$A9D7                           ; $A9D2 20 03
    DEC HL                                ; $A9D4 2b | Backspace arretra soltanto il puntatore del buffer; non normalizza caratteri e non scriveA025.
    JR $A9D9                              ; $A9D5 18 02
    LD (HL),A                             ; $A9D7 77
    INC HL                                ; $A9D8 23
    LD ($A9B5),HL                         ; $A9D9 22 b5 a9
    POP HL                                ; $A9DC e1
    POP AF                                ; $A9DD f1
    RET                                   ; $A9DE c9
    PUSH DE                               ; $A9DF d5
    LD DE,$5C0B                           ; $A9E0 11 0b 5c
    AND A                                 ; $A9E3 a7
    SBC HL,DE                             ; $A9E4 ed 52
    JR Z,$AA0B                            ; $A9E6 28 23
    LD A,($C1F5)                          ; $A9E8 3a f5 c1
    CP L                                  ; $A9EB bd | CP L salva il confronto con la larghezza PRIMA del possibile CR. Il flagZ non si ricalcola dopo il wrap.
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa | Parola troppo lunga per le colonne rimaste: AA14 normalizza un CR, scrivendo1 poi0 anche se C1E1 non disegna.
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1 | Ripristina il confronto iniziale: una parola lunga36 preceduta da wrap non è un riempimento esatto della larghezza precedente.
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0 | Writer0 soltanto se il confronto prima del wrap era uguale. Un wrap grezzo della routine video non è questo writer.
    POP DE                                ; $AA0B d1
    POP HL                                ; $AA0C e1
    POP AF                                ; $AA0D f1
    JR $AA14                              ; $AA0E 18 04
    POP AF                                ; $AA10 f1
    JP $C1E1                              ; $AA11 c3 e1 c1
    CP $41                                ; $AA14 fe 41
    JR C,$AA1E                            ; $AA16 38 06
    CP $5B                                ; $AA18 fe 5b
    JR NC,$AA1E                           ; $AA1A 30 02
    OR $20                                ; $AA1C f6 20
    PUSH AF                               ; $AA1E f5
    LD A,($A025)                          ; $AA1F 3a 25 a0 | Legge il flag di spaziatura: è indipendente da A024 e dal cursore fisico.
    AND A                                 ; $AA22 a7
    JR NZ,$AA2A                           ; $AA23 20 05
    POP AF                                ; $AA25 f1
    CP $20                                ; $AA26 fe 20
    RET Z                                 ; $AA28 c8 | Spazio iniziale conA025=0: ritorna senza alcuno store. Con stato ignoto non si può dedurre0.
    PUSH AF                               ; $AA29 f5
    LD A,$01                              ; $AA2A 3e 01
    LD ($A025),A                          ; $AA2C 32 25 a0 | Writer1 per ogni carattere non soppresso, compresi CR e virgoletta. I caratteri letterali invisibili passano anche qui.
    POP AF                                ; $AA2F f1
    PUSH AF                               ; $AA30 f5
    CP $0D                                ; $AA31 fe 0d
    JR NZ,$AA3B                           ; $AA33 20 06
    XOR A                                 ; $AA35 af
    LD ($A025),A                          ; $AA36 32 25 a0 | Writer0 del CR normalizzato; sovrascrive il precedente writer1 dello stesso carattere.
    JR $AA6D                              ; $AA39 18 32
    CP $22                                ; $AA3B fe 22
    JR NZ,$AA46                           ; $AA3D 20 07
    LD A,$20                              ; $AA3F 3e 20
    CALL $C1E1                            ; $AA41 cd e1 c1 | Inserisce uno spazio grezzo prima della virgoletta; non costituisce un ulteriore writerA025.
    JR $AA4A                              ; $AA44 18 04
    CP $2E                                ; $AA46 fe 2e
    JR NZ,$AA51                           ; $AA48 20 07
    LD A,$01                              ; $AA4A 3e 01
    LD ($A026),A                          ; $AA4C 32 26 a0 | A026 riguarda le maiuscole e rimane un limite distinto, non implementato dal nuovo contrattoA025.
    JR $AA6D                              ; $AA4F 18 1c
    CP $61                                ; $AA51 fe 61
    JR C,$AA6D                            ; $AA53 38 18
    CP $7B                                ; $AA55 fe 7b
    JR NC,$AA6D                           ; $AA57 30 14
    LD A,($A851)                          ; $AA59 3a 51 a8
    AND A                                 ; $AA5C a7
    JR NZ,$AA65                           ; $AA5D 20 06
    LD A,($A026)                          ; $AA5F 3a 26 a0
    AND A                                 ; $AA62 a7
    JR Z,$AA6D                            ; $AA63 28 08
    XOR A                                 ; $AA65 af
    LD ($A026),A                          ; $AA66 32 26 a0
    POP AF                                ; $AA69 f1
    AND $5F                               ; $AA6A e6 5f
    PUSH AF                               ; $AA6C f5
    POP AF                                ; $AA6D f1
    JP $C1E1                              ; $AA6E c3 e1 c1

    ORG $A887
; CODE: Dizionario: emissione soppressa prima del formatter se non visibile
    LD A,($5C3C)                          ; $A887 3a 3c 5c | Con5C3C=0 le parole del dizionario e i nomi non raggiungono il buffer; i caratteri letterali del testo sì.
    AND A                                 ; $A88A a7
    RET Z                                 ; $A88B c8
    LD ($A022),DE                         ; $A88C ed 53 22 a0
    LD A,D                                ; $A890 7a
    AND $0F                               ; $A891 e6 0f
    OR E                                  ; $A893 b3
    RET Z                                 ; $A894 c8
    PUSH IX                               ; $A895 dd e5
    PUSH HL                               ; $A897 e5
    PUSH BC                               ; $A898 c5
    PUSH DE                               ; $A899 d5
    LD A,$20                              ; $A89A 3e 20
    CALL $A9B7                            ; $A89C cd b7 a9
    LD A,D                                ; $A89F 7a
    AND $F0                               ; $A8A0 e6 f0
    LD C,A                                ; $A8A2 4f
    CP $70                                ; $A8A3 fe 70
    LD A,$01                              ; $A8A5 3e 01
    JR NZ,$A8AC                           ; $A8A7 20 03
    LD ($A026),A                          ; $A8A9 32 26 a0

    ORG $C1E1
; CODE: Uscita invisibile: scarta pixel dopo gli aggiornamenti del normalizzatore
    PUSH AF                               ; $C1E1 f5
    LD A,($5C3C)                          ; $C1E2 3a 3c 5c | 5C3C=0 impedisce il disegno: A9B7 e AA14 hanno però già aggiornato il buffer eA025. Non far avanzare il cursore nascosto.
    AND A                                 ; $C1E5 a7
    JR NZ,$C1EA                           ; $C1E6 20 02
    POP AF                                ; $C1E8 f1
    RET                                   ; $C1E9 c9
    LD A,($A027)                          ; $C1EA 3a 27 a0
    AND A                                 ; $C1ED a7
    JR NZ,$C1FC                           ; $C1EE 20 0c
    POP AF                                ; $C1F0 f1
    JP $C2BA                              ; $C1F1 c3 ba c2

    ORG $C129
; CODE: Cambio finestra: aggiorna cursore e contatore, conserva A025
    XOR A                                 ; $C129 af
    LD ($A019),A                          ; $C12A 32 19 a0
    INC A                                 ; $C12D 3c
    LD ($C128),A                          ; $C12E 32 28 c1
    LD A,$12                              ; $C131 3e 12
    LD ($C1F5),A                          ; $C133 32 f5 c1
    LD HL,$5020                           ; $C136 21 20 50
    LD ($C1F8),HL                         ; $C139 22 f8 c1
    LD A,$02                              ; $C13C 3e 02
    LD ($C1FA),A                          ; $C13E 32 fa c1
    RET                                   ; $C141 c9
    XOR A                                 ; $C142 af | Ripristina36 colonne e cursore, senza scrivereA025. Non azzerare il flag dal solo cambio finestra.
    LD ($C128),A                          ; $C143 32 28 c1
    LD A,$24                              ; $C146 3e 24
    JR $C133                              ; $C148 18 e9
