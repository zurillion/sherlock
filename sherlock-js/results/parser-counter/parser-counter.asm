; Codice e dati distinti, verificati contro il payload. Nessun opcode eseguito dal runtime JS.

    ORG $A012
; DATA: Contatore temporaneo del parser: inizialmente FF
    DEFB $FF                              ; $A012 ff | Byte FF del payload iniziale. AAB6 lo azzera solo quando inizia il parser; un errore lessicale precedente lo conserva.

    ORG $A019
; DATA: Contatore cumulativo delle righe e MORE
    DEFB $00                              ; $A019 00 | Stato già ricostruito dal renderer e ora esposto al generatore: non è il numero di righe del singolo comando.

    ORG $AAB2
; CODE: Inizio parsing: azzera contatore e stato ALL/BUT
    XOR A                                 ; $AAB2 af
    LD ($A01A),A                          ; $AAB3 32 1a a0
    LD ($A012),A                          ; $AAB6 32 12 a0 | Nuovo ingresso AAB2: contatore zero anche per citazioni vuote e per i tentativi che falliscono nella sintassi.
    LD E,$FF                              ; $AAB9 1e ff
    LD D,$C0                              ; $AABB 16 c0

    ORG $ACCC
; CODE: Coordinazioni, esclusioni e ripristino del contatore nel backtracking
    RES 3,E                               ; $ACCC cb 9b
    PUSH DE                               ; $ACCE d5
    CALL $AE7F                            ; $ACCF cd 7f ae
    CP $A0                                ; $ACD2 fe a0
    JR Z,$ACCF                            ; $ACD4 28 f9
    LD HL,($A029)                         ; $ACD6 2a 29 a0
    LD ($AAA1),HL                         ; $ACD9 22 a1 aa
    LD ($A02B),HL                         ; $ACDC 22 2b a0
    POP DE                                ; $ACDF d1
    LD A,E                                ; $ACE0 7b
    LD ($AAA3),A                          ; $ACE1 32 a3 aa
    LD ($AAA4),IY                         ; $ACE4 fd 22 a4 aa
    LD A,($A012)                          ; $ACE8 3a 12 a0 | Salva il conteggio prima di proseguire speculativamente oltre la congiunzione.
    LD ($AAA6),A                          ; $ACEB 32 a6 aa
    LD A,($A01A)                          ; $ACEE 3a 1a a0
    CP $02                                ; $ACF1 fe 02
    JR NZ,$AD57                           ; $ACF3 20 62
    SET 6,(IY+$01)                        ; $ACF5 fd cb 01 f6 | Con BUT attivo, marca il nodo esclusione; il separatore A0 non deve contare questo nodo.
    JR $AD57                              ; $ACF9 18 5c
    LD A,($A024)                          ; $ACFB 3a 24 a0
    CP $02                                ; $ACFE fe 02
    JR NZ,$AD23                           ; $AD00 20 21
    BIT 6,E                               ; $AD02 cb 73
    JP NZ,$AB4C                           ; $AD04 c2 4c ab
    SET 6,E                               ; $AD07 cb f3
    SET 3,E                               ; $AD09 cb db
    PUSH IY                               ; $AD0B fd e5
    EXX                                   ; $AD0D d9
    POP HL                                ; $AD0E e1
    LD DE,$0008                           ; $AD0F 11 08 00
    ADD HL,DE                             ; $AD12 19
    PUSH HL                               ; $AD13 e5
    LD DE,$0010                           ; $AD14 11 10 00
    ADD HL,DE                             ; $AD17 19
    POP DE                                ; $AD18 d1
    EX DE,HL                              ; $AD19 eb
    LD BC,$0006                           ; $AD1A 01 06 00
    LDIR                                  ; $AD1D ed b0
    EXX                                   ; $AD1F d9
    JP $AB4C                              ; $AD20 c3 4c ab
    LD A,($A01B)                          ; $AD23 3a 1b a0
    AND A                                 ; $AD26 a7
    JR Z,$AD2E                            ; $AD27 28 05
    SET 3,E                               ; $AD29 cb db
    JP $AB4C                              ; $AD2B c3 4c ab
    LD HL,($AAA1)                         ; $AD2E 2a a1 aa
    LD ($A02B),HL                         ; $AD31 22 2b a0
    LD D,$B0                              ; $AD34 16 b0
    LD A,($AAA3)                          ; $AD36 3a a3 aa
    LD E,A                                ; $AD39 5f
    LD A,($AAA6)                          ; $AD3A 3a a6 aa
    LD ($A012),A                          ; $AD3D 32 12 a0 | Ripristina il contatore salvato quando il nuovo verbo va rinviato al ciclo successivo. Le allocazioni speculative restano distinte dal conteggio.
    LD IY,($AAA4)                         ; $AD40 fd 2a a4 aa
    LD L,(IY-$02)                         ; $AD44 fd 6e fe
    LD H,(IY-$01)                         ; $AD47 fd 66 ff
    PUSH HL                               ; $AD4A e5
    POP IX                                ; $AD4B dd e1
    CALL $A1AF                            ; $AD4D cd af a1
    XOR A                                 ; $AD50 af
    LD (IY-$02),A                         ; $AD51 fd 77 fe
    LD (IY-$01),A                         ; $AD54 fd 77 ff
    LD A,($A01A)                          ; $AD57 3a 1a a0 | A01A=2 e separatore A0: salta l’incremento. La chiusura finale invece conta anche l’esclusione.
    DEC A                                 ; $AD5A 3d
    LD HL,$A012                           ; $AD5B 21 12 a0
    DEC A                                 ; $AD5E 3d
    LD A,D                                ; $AD5F 7a
    JR NZ,$AD66                           ; $AD60 20 04
    CP $A0                                ; $AD62 fe a0
    JR Z,$AD67                            ; $AD64 28 01
    INC (HL)                              ; $AD66 34 | Incremento a otto bit: conta il percorso di parsing completato, non semplicemente i nodi allocati.
    CP $A0                                ; $AD67 fe a0
    JP Z,$AABD                            ; $AD69 ca bd aa
    LD A,($A01B)                          ; $AD6C 3a 1b a0
    AND A                                 ; $AD6F a7
    JR Z,$ADD4                            ; $AD70 28 62

    ORG $B01C
; CODE: ALL e BUT: nodo extra e stato della selezione
    LD A,($A01A)                          ; $B01C 3a 1a a0
    CP $01                                ; $B01F fe 01
    JP NZ,$AF67                           ; $B021 c2 67 af
    LD A,$02                              ; $B024 3e 02
    LD ($A01A),A                          ; $B026 32 1a a0 | BUT passa a stato 2 e crea un nodo senza passare per l’incremento AD66 del nodo principale.
    CALL $AE6A                            ; $B029 cd 6a ae
    SET 6,(IY+$01)                        ; $B02C fd cb 01 f6
    JP $AB52                              ; $B030 c3 52 ab
    CALL $AFE8                            ; $B033 cd e8 af
    LD A,($A01A)                          ; $B036 3a 1a a0
    AND A                                 ; $B039 a7
    JP NZ,$AF67                           ; $B03A c2 67 af
    LD A,$01                              ; $B03D 3e 01
    LD ($A01A),A                          ; $B03F 32 1a a0 | ALL imposta stato 1. Un BUT senza nome è accettato dal parser originale: gruppo nominale vuoto, payload zero.
    SET 7,(IY+$01)                        ; $B042 fd cb 01 fe
    JP $AB52                              ; $B046 c3 52 ab

    ORG $B0FD
; CODE: THAT, HE, IT/THEY: riallocazione e conteggi diversi
    LD BC,$0008                           ; $B0FD 01 08 00
    BIT 3,E                               ; $B100 cb 5b
    JR NZ,$B107                           ; $B102 20 03
    CALL $AEC6                            ; $B104 cd c6 ae
    PUSH IY                               ; $B107 fd e5
    POP HL                                ; $B109 e1
    ADD HL,BC                             ; $B10A 09
    PUSH DE                               ; $B10B d5
    PUSH HL                               ; $B10C e5
    BIT 3,E                               ; $B10D cb 5b
    JR NZ,$B118                           ; $B10F 20 07
    SET 3,E                               ; $B111 cb db
    CALL $AEA9                            ; $B113 cd a9 ae
    JR $B11F                              ; $B116 18 07
    LD HL,$A012                           ; $B118 21 12 a0
    INC (HL)                              ; $B11B 34 | THAT senza separatore crea un ulteriore nodo e incrementa il contatore.
    CALL $AE6A                            ; $B11C cd 6a ae
    PUSH IY                               ; $B11F fd e5
    POP HL                                ; $B121 e1
    LD BC,$0018                           ; $B122 01 18 00
    ADD HL,BC                             ; $B125 09
    POP DE                                ; $B126 d1
    EX DE,HL                              ; $B127 eb
    LD BC,$0006                           ; $B128 01 06 00
    LDIR                                  ; $B12B ed b0
    POP DE                                ; $B12D d1
    LD A,E                                ; $B12E 7b
    OR $C7                                ; $B12F f6 c7
    LD E,A                                ; $B131 5f
    JP $AAD1                              ; $B132 c3 d1 aa
    CALL $AFE1                            ; $B135 cd e1 af
    LD A,$02                              ; $B138 3e 02
    LD ($A024),A                          ; $B13A 32 24 a0
    JR $B14B                              ; $B13D 18 0c
    BIT 3,E                               ; $B13F cb 5b
    JR Z,$B14B                            ; $B141 28 08
    PUSH DE                               ; $B143 d5
    CALL $AEA9                            ; $B144 cd a9 ae
    CALL $AE6A                            ; $B147 cd 6a ae | HE senza separatore alloca un nodo ma NON incrementa A012 come THAT: la chiusura finale lo porta a 1.
    POP DE                                ; $B14A d1
    SET 7,(IY+$19)                        ; $B14B fd cb 19 fe
    JR $B12E                              ; $B14F 18 dd
    CALL $AFE1                            ; $B151 cd e1 af
    LD A,$02                              ; $B154 3e 02
    LD ($A024),A                          ; $B156 32 24 a0
    JR $B167                              ; $B159 18 0c
    BIT 3,E                               ; $B15B cb 5b
    JR Z,$B167                            ; $B15D 28 08
    PUSH DE                               ; $B15F d5
    CALL $AEA9                            ; $B160 cd a9 ae
    CALL $AE6A                            ; $B163 cd 6a ae | IT/THEY seguono lo stesso percorso di riallocazione senza incremento supplementare.
    POP DE                                ; $B166 d1
    SET 6,(IY+$19)                        ; $B167 fd cb 19 f6
    JR $B12E                              ; $B16B 18 c1

    ORG $BA1C
; DATA: Deduzioni di Lestrade: riconosciute, non provate e ultimo fatto
    DEFB $00,$00,$00,$00                  ; $BA1C 00 00 00 00 | Due contatori a un byte e un puntatore little-endian. Inizialmente zero; restano osservabili dai successivi sorteggi.

    ORG $BB67
; CODE: Verifica delle frasi: contatori e puntatore dell’ultimo fatto riconosciuto
    LD ($BA1D),A                          ; $BB67 32 1d ba | Nuova verifica: azzera i contatori di riconoscimento e non provato; conserva il vecchio puntatore finché non riconosce un fatto.
    LD ($BA1C),A                          ; $BB6A 32 1c ba
    CALL $BD7E                            ; $BB6D cd 7e bd
    JP C,$BBBE                            ; $BB70 da be bb
    CALL $BC21                            ; $BB73 cd 21 bc
    JR Z,$BB7C                            ; $BB76 28 04
    LD HL,$BA1C                           ; $BB78 21 1c ba
    INC (HL)                              ; $BB7B 34 | Incrementa il numero di frasi riconosciute modulo 256.
    CALL $AEA9                            ; $BB7C cd a9 ae
    JR NZ,$BB6D                           ; $BB7F 20 ec
    LD A,($BA1C)                          ; $BB81 3a 1c ba
    AND A                                 ; $BB84 a7
    JR NZ,$BB8E                           ; $BB85 20 07
    LD HL,$725F                           ; $BB87 21 5f 72
    CALL $A59F                            ; $BB8A cd 9f a5
    RET                                   ; $BB8D c9
    LD A,($BA1D)                          ; $BB8E 3a 1d ba
    AND A                                 ; $BB91 a7
    JR Z,$BBC9                            ; $BB92 28 35
    LD IX,($BA1E)                         ; $BB94 dd 2a 1e ba
    PUSH IX                               ; $BB98 dd e5
    CALL $BE5A                            ; $BB9A cd 5a be
    LD A,(IX+$03)                         ; $BB9D dd 7e 03
    AND $C0                               ; $BBA0 e6 c0
    CP $80                                ; $BBA2 fe 80
    JR Z,$BBB1                            ; $BBA4 28 0b
    BIT 3,(IX+$03)                        ; $BBA6 dd cb 03 5e
    JR NZ,$BBB1                           ; $BBAA 20 05
    CALL $BE72                            ; $BBAC cd 72 be
    JR $BB9D                              ; $BBAF 18 ec
    POP IX                                ; $BBB1 dd e1
    JR NZ,$BBC4                           ; $BBB3 20 0f
    LD HL,$7295                           ; $BBB5 21 95 72
    PUSH IX                               ; $BBB8 dd e5
    CALL $A59F                            ; $BBBA cd 9f a5
    RET                                   ; $BBBD c9
    LD HL,$7243                           ; $BBBE 21 43 72
    JP $A59F                              ; $BBC1 c3 9f a5
    LD HL,$72A6                           ; $BBC4 21 a6 72
    JR $BBB8                              ; $BBC7 18 ef
    CALL $BC46                            ; $BBC9 cd 46 bc
    CALL $BC9C                            ; $BBCC cd 9c bc
    LD A,B                                ; $BBCF 78
    AND A                                 ; $BBD0 a7
    JR NZ,$BBE5                           ; $BBD1 20 12
    CALL $BC74                            ; $BBD3 cd 74 bc
    AND A                                 ; $BBD6 a7
    JR Z,$BBDE                            ; $BBD7 28 05
    LD HL,$72BD                           ; $BBD9 21 bd 72
    JR $BBB8                              ; $BBDC 18 da
    LD HL,$727E                           ; $BBDE 21 7e 72
    CALL $A59F                            ; $BBE1 cd 9f a5
    RET                                   ; $BBE4 c9
    PUSH AF                               ; $BBE5 f5
    LD HL,$67FF                           ; $BBE6 21 ff 67
    CALL $A59F                            ; $BBE9 cd 9f a5
    POP AF                                ; $BBEC f1
    CP $01                                ; $BBED fe 01
    LD HL,$72D6                           ; $BBEF 21 d6 72
    CALL NZ,$A59F                         ; $BBF2 c4 9f a5
    BIT 4,(IX+$03)                        ; $BBF5 dd cb 03 66
    JR Z,$BC1A                            ; $BBF9 28 1f
    RES 1,(IX+$03)                        ; $BBFB dd cb 03 8e
    PUSH IX                               ; $BBFF dd e5
    LD HL,$72E1                           ; $BC01 21 e1 72
    CALL $A59F                            ; $BC04 cd 9f a5
    LD L,(IX+$04)                         ; $BC07 dd 6e 04
    LD H,(IX+$05)                         ; $BC0A dd 66 05
    LD A,L                                ; $BC0D 7d
    OR H                                  ; $BC0E b4
    JP NZ,$A59F                           ; $BC0F c2 9f a5
    LD A,$22                              ; $BC12 3e 22
    CALL $A9B7                            ; $BC14 cd b7 a9
    JP $A414                              ; $BC17 c3 14 a4
    LD L,(IX+$04)                         ; $BC1A dd 6e 04
    LD H,(IX+$05)                         ; $BC1D dd 66 05
    JP (HL)                               ; $BC20 e9
    CALL $BD51                            ; $BC21 cd 51 bd
    JR NZ,$BC2F                           ; $BC24 20 09
    LD A,(IX+$03)                         ; $BC26 dd 7e 03
    AND $C0                               ; $BC29 e6 c0
    CP $80                                ; $BC2B fe 80
    JR Z,$BC31                            ; $BC2D 28 02
    XOR A                                 ; $BC2F af
    RET                                   ; $BC30 c9
    LD ($BA1E),IX                         ; $BC31 dd 22 1e ba | Registra il fatto riconosciuto prima di valutarne la prova. Non è necessariamente l’ultimo fatto non provato.
    CALL $BCC9                            ; $BC35 cd c9 bc
    JR Z,$BC43                            ; $BC38 28 09
    LD A,$01                              ; $BC3A 3e 01
    LD ($BA1D),A                          ; $BC3C 32 1d ba | Imposta il flag non provato a uno: non conta quanti fatti mancano.
    SET 0,(IX+$03)                        ; $BC3F dd cb 03 c6
    OR $01                                ; $BC43 f6 01
    RET                                   ; $BC45 c9

    ORG $BC74
; CODE: Scansione delle ipotesi: primo fatto completo e ultimo incompleto
    LD IX,$9965                           ; $BC74 dd 21 65 99
    LD B,$00                              ; $BC78 06 00
    LD A,(IX+$00)                         ; $BC7A dd 7e 00
    CP $FF                                ; $BC7D fe ff
    JR Z,$BC96                            ; $BC7F 28 15
    BIT 0,(IX+$03)                        ; $BC81 dd cb 03 46
    JR Z,$BC91                            ; $BC85 28 0a
    CALL $BCC9                            ; $BC87 cd c9 bc
    JR Z,$BC91                            ; $BC8A 28 05
    LD ($BA1E),IX                         ; $BC8C dd 22 1e ba | Scansione senza ipotesi completa: conserva l’ultimo fatto incompleto.
    INC B                                 ; $BC90 04
    CALL $BE5A                            ; $BC91 cd 5a be
    JR $BC7A                              ; $BC94 18 e4
    LD A,B                                ; $BC96 78
    LD IX,($BA1E)                         ; $BC97 dd 2a 1e ba
    RET                                   ; $BC9B c9
    LD IX,$9965                           ; $BC9C dd 21 65 99
    LD B,$00                              ; $BCA0 06 00
    LD A,(IX+$00)                         ; $BCA2 dd 7e 00
    CP $FF                                ; $BCA5 fe ff
    JR Z,$BCC4                            ; $BCA7 28 1b
    BIT 0,(IX+$03)                        ; $BCA9 dd cb 03 46
    JR Z,$BCBD                            ; $BCAD 28 0e
    CALL $BCC9                            ; $BCAF cd c9 bc
    JR NZ,$BCBD                           ; $BCB2 20 09
    LD A,B                                ; $BCB4 78
    INC B                                 ; $BCB5 04
    AND A                                 ; $BCB6 a7
    JR NZ,$BCBD                           ; $BCB7 20 04
    LD ($BA1E),IX                         ; $BCB9 dd 22 1e ba | Con ipotesi complete seleziona la prima; questa scansione non azzera i contatori della verifica precedente.
    PUSH BC                               ; $BCBD c5
    CALL $BE72                            ; $BCBE cd 72 be
    POP BC                                ; $BCC1 c1
    JR $BCA2                              ; $BCC2 18 de
    LD IX,($BA1E)                         ; $BCC4 dd 2a 1e ba
    RET                                   ; $BCC8 c9

    ORG $C2CA
; CODE: MORE a quota quindici: attesa, FF e incremento modulo 256
    LD A,($A019)                          ; $C2CA 3a 19 a0
    CP $0F                                ; $C2CD fe 0f
    JR NZ,$C2D6                           ; $C2CF 20 05
    CALL $C306                            ; $C2D1 cd 06 c3 | La quindicesima quota cumulativa attende MORE prima del CR successivo.
    LD A,$FF                              ; $C2D4 3e ff | Il successivo INC A trasforma FF in zero dopo la conferma.
    INC A                                 ; $C2D6 3c
    LD ($A019),A                          ; $C2D7 32 19 a0

    ORG $D6C1
; CODE: Input accettato: azzera sempre il flag transitorio di @
    CALL $D898                            ; $D6C1 cd 98 d8
    JP Z,$DC15                            ; $D6C4 ca 15 dc
    XOR A                                 ; $D6C7 af
    LD ($D714),A                          ; $D6C8 32 14 d7 | Reset del flag anche dopo @: ogni ingresso valido torna a zero prima del preflight. Non trasformare 1 in un attributo persistente del comando.
    OR $01                                ; $D6CB f6 01
    RET                                   ; $D6CD c9

    ORG $D714
; DATA: Flag transitorio di riuso dei token nell’editor
    DEFB $00                              ; $D714 00 | Il tasto @ scrive 1 a D9A7, ma D6C8 ripristina 0 prima del preflight lessicale e dei turni NPC. Il profilo della pagina salva soltanto input completati.

    ORG $D719
; CODE: Tokenizzazione: azzera MORE e consulta il flag di riuso
    XOR A                                 ; $D719 af
    LD ($A019),A                          ; $D71A 32 19 a0 | La nuova tokenizzazione azzera il contatore MORE. Gli errori lessicali fermati prima di questo ingresso non lo fanno.
    CALL $C142                            ; $D71D cd 42 c1
    LD A,($D714)                          ; $D720 3a 14 d7
    AND A                                 ; $D723 a7
    JR NZ,$D760                           ; $D724 20 3a

    ORG $D99E
; CODE: Tasto @: flag temporaneo, ignorato durante una precisazione
    LD A,($A01B)                          ; $D99E 3a 1b a0
    AND A                                 ; $D9A1 a7
    JP NZ,$D8C3                           ; $D9A2 c2 c3 d8
    LD A,$01                              ; $D9A5 3e 01
    LD ($D714),A                          ; $D9A7 32 14 d7 | Scrittura transitoria a uno; il successivo ritorno attraverso D6C8 la annulla.
    OR $01                                ; $D9AA f6 01
