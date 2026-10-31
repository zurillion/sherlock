; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.

    ORG $A026
; DATA: Maiuscola pendente: stato persistente distinto da spazio, CR e forzatura
    DEFB $01                              ; $A026 01 | Byte iniziale1 estratto dal payload. Non ricavarlo dalle lettere maiuscole già visualizzate. OldSAVE assente restaunknown fino a un writer dimostrato.

    ORG $A7D0
; CODE: Nome proprio: selezione del bit e caso YOU
    XOR A                                 ; $A7D0 af
    LD ($A7EA),A                          ; $A7D1 32 ea a7 | A7D0 azzera il latch del nome proprio prima di esaminare il bit7 del descrittore.
    BIT 7,D                               ; $A7D4 cb 7a
    JR Z,$A7EB                            ; $A7D6 28 13
    LD A,E                                ; $A7D8 7b
    LD HL,$09EE                           ; $A7D9 21 ee 09
    CP L                                  ; $A7DC bd
    JR NZ,$A7E4                           ; $A7DD 20 05
    LD A,D                                ; $A7DF 7a
    AND $0F                               ; $A7E0 e6 0f
    CP H                                  ; $A7E2 bc
    RET Z                                 ; $A7E3 c8 | YOU/09EE è un nome con bit proprio ma non propaga la maiuscola: ritorna con latch0.
    LD A,$01                              ; $A7E4 3e 01
    LD ($A7EA),A                          ; $A7E6 32 ea a7 | Altri nomi con bit7 impostano il latch1. D3F9 può azzerarlo per entità senza attributo persona.
    RET                                   ; $A7E9 c9

    ORG $A7EA
; DATA: Latch del nome proprio:0 oppure1, azzerato per entità non persona
    DEFB $00                              ; $A7EA 00 | Dato mutabile0/1 del chiamante dei nomi. Non è un opcode. Il nuovo runtime ricava il bit dal referente, non installa un valore registrato diA026.

    ORG $A815
; CODE: Emissione del nome: OR indiretto dopo la parola, anche invisibile
    PUSH AF                               ; $A815 f5
    LD A,D                                ; $A816 7a
    AND $0F                               ; $A817 e6 0f
    LD D,A                                ; $A819 57
    POP AF                                ; $A81A f1
    OR D                                  ; $A81B b2
    LD D,A                                ; $A81C 57
    AND $0F                               ; $A81D e6 0f
    OR E                                  ; $A81F b3
    RET Z                                 ; $A820 c8 | Offset nullo: ritorna prima diA887 e prima dell’OR. Nessun writerA82C per la parola inesistente.
    CALL $A887                            ; $A821 cd 87 a8 | Il separatore diA887 scarica la parola precedente prima di accodare la nuova. Solo dopo avviene la propagazione del latch.
    LD A,($A7EA)                          ; $A824 3a ea a7
    PUSH HL                               ; $A827 e5
    LD HL,$A026                           ; $A828 21 26 a0
    OR (HL)                               ; $A82B b6
    LD (HL),A                             ; $A82C 77 | Quinto writer, indiretto: A026 |= A7EA. Si esegue anche se A887 ha soppresso i pixel. OR1 non trasforma255 in1 e non rende noto un vecchioSAVE assente.
    POP HL                                ; $A82D e1
    RET                                   ; $A82E c9

    ORG $A887
; CODE: Dizionario in contesto70: writer1 dopo il separatore iniziale
    LD A,($5C3C)                          ; $A887 3a 3c 5c
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
    LD ($A026),A                          ; $A8A9 32 26 a0 | Contesto70, offset nonzero e output non soppresso: scrive1 dopo lo spazio iniziale e prima delle lettere ancora nel buffer.

    ORG $A9B7
; CODE: Buffer e normalizzazione: maiuscola decisa quando la parola viene scaricata
    PUSH AF                               ; $A9B7 f5
    LD A,($A027)                          ; $A9B8 3a 27 a0
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
    DEC HL                                ; $A9D4 2b | Backspace modifica soltanto il buffer, non scriveA026. La classificazione dei caratteri superstiti rimane nel SAVE.
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
    CP L                                  ; $A9EB bd
    PUSH AF                               ; $A9EC f5
    JR NC,$A9F4                           ; $A9ED 30 05
    LD A,$0D                              ; $A9EF 3e 0d
    CALL $AA14                            ; $A9F1 cd 14 aa
    PUSH BC                               ; $A9F4 c5
    LD B,L                                ; $A9F5 45
    LD HL,$5C0B                           ; $A9F6 21 0b 5c
    LD ($A9B5),HL                         ; $A9F9 22 b5 a9
    LD A,(HL)                             ; $A9FC 7e
    CALL $AA14                            ; $A9FD cd 14 aa | AA14 normalizza i caratteri solo nello svuotamento del buffer; non scrivere il flag quando si accoda una lettera.
    INC HL                                ; $AA00 23
    DJNZ $A9FC                            ; $AA01 10 f9
    POP BC                                ; $AA03 c1
    POP AF                                ; $AA04 f1
    JR NZ,$AA0B                           ; $AA05 20 04
    XOR A                                 ; $AA07 af
    LD ($A025),A                          ; $AA08 32 25 a0
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
    LD A,($A025)                          ; $AA1F 3a 25 a0
    AND A                                 ; $AA22 a7
    JR NZ,$AA2A                           ; $AA23 20 05
    POP AF                                ; $AA25 f1
    CP $20                                ; $AA26 fe 20
    RET Z                                 ; $AA28 c8
    PUSH AF                               ; $AA29 f5
    LD A,$01                              ; $AA2A 3e 01
    LD ($A025),A                          ; $AA2C 32 25 a0
    POP AF                                ; $AA2F f1
    PUSH AF                               ; $AA30 f5
    CP $0D                                ; $AA31 fe 0d
    JR NZ,$AA3B                           ; $AA33 20 06
    XOR A                                 ; $AA35 af
    LD ($A025),A                          ; $AA36 32 25 a0 | Questo writer riguardaA025, NONA026: un CR da solo conserva la maiuscola pendente.
    JR $AA6D                              ; $AA39 18 32
    CP $22                                ; $AA3B fe 22
    JR NZ,$AA46                           ; $AA3D 20 07
    LD A,$20                              ; $AA3F 3e 20
    CALL $C1E1                            ; $AA41 cd e1 c1
    JR $AA4A                              ; $AA44 18 04
    CP $2E                                ; $AA46 fe 2e
    JR NZ,$AA51                           ; $AA48 20 07
    LD A,$01                              ; $AA4A 3e 01
    LD ($A026),A                          ; $AA4C 32 26 a0 | Punto e virgoletta già normalizzati scrivono1 anche se C1E1 scarterà il disegno.
    JR $AA6D                              ; $AA4F 18 1c
    CP $61                                ; $AA51 fe 61
    JR C,$AA6D                            ; $AA53 38 18
    CP $7B                                ; $AA55 fe 7b
    JR NC,$AA6D                           ; $AA57 30 14
    LD A,($A851)                          ; $AA59 3a 51 a8 | A851 forza le lettere. PerA026 il risultato dopo una lettera è comunque0, indipendentemente dalla forzatura.
    AND A                                 ; $AA5C a7
    JR NZ,$AA65                           ; $AA5D 20 06
    LD A,($A026)                          ; $AA5F 3a 26 a0
    AND A                                 ; $AA62 a7
    JR Z,$AA6D                            ; $AA63 28 08
    XOR A                                 ; $AA65 af
    LD ($A026),A                          ; $AA66 32 26 a0 | Lettera con maiuscola richiesta o forzata: scrive0. Nel ramo senza writer il flag era già0; il risultato funzionale è0 per ogni lettera ASCII.
    POP AF                                ; $AA69 f1
    AND $5F                               ; $AA6A e6 5f
    PUSH AF                               ; $AA6C f5
    POP AF                                ; $AA6D f1
    JP $C1E1                              ; $AA6E c3 e1 c1

    ORG $A419
; CODE: Importi: writer0 soltanto nei rami con D-punto o scellini esatti
    PUSH BC                               ; $A419 c5 | HL contiene la valuta codificata: bit7 basso è metadato, non parte dell’importo. Le ABI passano encodeMoney(pence), non il numero grezzo.
    RES 7,H                               ; $A41A cb bc
    SLA L                                 ; $A41C cb 25
    SRL H                                 ; $A41E cb 3c
    RR L                                  ; $A420 cb 1d
    LD A,$20                              ; $A422 3e 20
    CALL $A9B7                            ; $A424 cd b7 a9
    LD DE,$00F0                           ; $A427 11 f0 00
    CALL $A476                            ; $A42A cd 76 a4
    AND A                                 ; $A42D a7
    JR Z,$A442                            ; $A42E 28 12
    LD B,A                                ; $A430 47
    LD A,$60                              ; $A431 3e 60
    CALL $A9B7                            ; $A433 cd b7 a9
    CALL $A490                            ; $A436 cd 90 a4
    LD A,L                                ; $A439 7d
    OR H                                  ; $A43A b4
    JR Z,$A467                            ; $A43B 28 2a | Sterline intere: ritorna senzaA464. Non azzerare per ogni importo.
    LD A,$20                              ; $A43D 3e 20
    CALL $A9B7                            ; $A43F cd b7 a9
    LD DE,$000C                           ; $A442 11 0c 00
    CALL $A476                            ; $A445 cd 76 a4
    AND A                                 ; $A448 a7
    JR Z,$A469                            ; $A449 28 1e
    LD B,A                                ; $A44B 47
    CALL $A490                            ; $A44C cd 90 a4
    LD A,$2F                              ; $A44F 3e 2f
    CALL $A9B7                            ; $A451 cd b7 a9
    LD A,L                                ; $A454 7d
    AND A                                 ; $A455 a7
    LD B,A                                ; $A456 47
    JR Z,$A45E                            ; $A457 28 05
    CALL $A490                            ; $A459 cd 90 a4
    JR $A467                              ; $A45C 18 09 | Scellini con resto in pence: ritorna senzaA464.
    LD A,$2D                              ; $A45E 3e 2d
    CALL $A9B7                            ; $A460 cd b7 a9
    XOR A                                 ; $A463 af
    LD ($A026),A                          ; $A464 32 26 a0 | Writer0 dopo D-punto o trattino degli scellini; la cifra può essere ancora nel buffer. Un punto scaricato più tardi ristabilisce1.
    POP BC                                ; $A467 c1
    RET                                   ; $A468 c9
    LD B,L                                ; $A469 45
    CALL $A490                            ; $A46A cd 90 a4
    LD A,$44                              ; $A46D 3e 44
    CALL $A9B7                            ; $A46F cd b7 a9
    LD A,$2E                              ; $A472 3e 2e
    JR $A460                              ; $A474 18 ea

    ORG $D3E8
; CODE: Tuple nome: propagazione della maiuscola tra qualificatori e sostantivo
    PUSH AF                               ; $D3E8 f5
    PUSH DE                               ; $D3E9 d5
    LD D,(IY+$01)                         ; $D3EA fd 56 01
    LD E,(IY+$00)                         ; $D3ED fd 5e 00
    CALL $A7D0                            ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                        ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                           ; $D3F7 20 04
    XOR A                                 ; $D3F9 af | Entità senza bit6 nell’attributo: azzera il latch proprio, indipendentemente dal bit7 del sostantivo.
    LD ($A7EA),A                          ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                        ; $D3FD fd cb ff 6e
    JR NZ,$D427                           ; $D401 20 24
    JR $D416                              ; $D403 18 11
    PUSH AF                               ; $D405 f5
    PUSH DE                               ; $D406 d5
    LD D,(IY+$01)                         ; $D407 fd 56 01
    LD E,(IY+$00)                         ; $D40A fd 5e 00
    CALL $A7D0                            ; $D40D cd d0 a7
    LD A,($A028)                          ; $D410 3a 28 a0
    AND A                                 ; $D413 a7
    JR NZ,$D438                           ; $D414 20 22
    LD E,(IY+$02)                         ; $D416 fd 5e 02
    LD D,(IY+$03)                         ; $D419 fd 56 03
    RES 7,D                               ; $D41C cb ba
    BIT 7,(IY+$03)                        ; $D41E fd cb 03 7e
    LD A,$40                              ; $D422 3e 40
    CALL Z,$A815                          ; $D424 cc 15 a8
    LD E,(IY+$04)                         ; $D427 fd 5e 04
    LD D,(IY+$05)                         ; $D42A fd 56 05
    RES 7,D                               ; $D42D cb ba
    BIT 7,(IY+$05)                        ; $D42F fd cb 05 7e
    LD A,$40                              ; $D433 3e 40
    CALL Z,$A815                          ; $D435 cc 15 a8
    LD E,(IY+$00)                         ; $D438 fd 5e 00 | Sostantivo finale: può rimanere nel buffer dopo l’ultimo OR, fino al separatore del chiamante.
    LD D,(IY+$01)                         ; $D43B fd 56 01
    LD A,D                                ; $D43E 7a
    OR E                                  ; $D43F b3
    LD A,$50                              ; $D440 3e 50
    CALL NZ,$A815                         ; $D442 c4 15 a8
    POP DE                                ; $D445 d1
    POP AF                                ; $D446 f1
    RET                                   ; $D447 c9

    ORG $A851
; DATA: Forzatura delle maiuscole: stato diverso daA026
    DEFB $00                              ; $A851 00

    ORG $A852
; CODE: Toggle della forzatura: A026 resta indipendente
    LD A,($A851)                          ; $A852 3a 51 a8
    XOR $01                               ; $A855 ee 01
    LD ($A851),A                          ; $A857 32 51 a8 | ScriveA851, nonA026. Il nuovo contratto non pubblica un valore diA851 come ingresso casuale.
    XOR A                                 ; $A85A af
    RET                                   ; $A85B c9
