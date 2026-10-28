; Analisi offline, dati distinti dal codice; nessuna esecuzione Z80 nel motore JS.

    ORG $A01A
; DATA: Stato condiviso ALL/BUT dell’unità di parsing
    DEFB $00                              ; $A01A 00 | Byte iniziale00. AAB3 scrive0 soltanto quando entra davvero nel parser; B03F scrive1 dopo ALL; B026 scrive2 dopo BUT. Non è il bit ALL dell’ultimo nodo AST.

    ORG $AAB2
; CODE: Ingresso del parser: reset di ALL/BUT e contatore
    XOR A                                 ; $AAB2 af
    LD ($A01A),A                          ; $AAB3 32 1a a0 | Nuova unità: ALL/BUT=0, anche dopo il rinvio di un nuovo verbo e quando entra nel parsing di una citazione. Un errore lessicale precedente non raggiunge questo reset.
    LD ($A012),A                          ; $AAB6 32 12 a0
    LD E,$FF                              ; $AAB9 1e ff
    LD D,$C0                              ; $AABB 16 c0

    ORG $ACA6
; CODE: Copia nominale: BUT conserva lo slot fisico corrente
    BIT 6,E                               ; $ACA6 cb 73 | I bit6/7 di E indicano quale slot nominale è ancora disponibile. B026 alloca un nodo ma non azzera questi bit: BUT dopo un primo gruppo scrive nel secondo slot del nuovo nodo.
    JR Z,$ACB2                            ; $ACA8 28 08
    RES 6,E                               ; $ACAA cb b3
    PUSH DE                               ; $ACAC d5
    LD DE,$0004                           ; $ACAD 11 04 00
    JR $ACBB                              ; $ACB0 18 09
    BIT 7,E                               ; $ACB2 cb 7b | Se anche il secondo slot è già consumato, ritorna Z: un ulteriore gruppo nominale è un errore, non un terzo campo oltre il record.
    RET Z                                 ; $ACB4 c8
    RES 7,E                               ; $ACB5 cb bb
    PUSH DE                               ; $ACB7 d5
    LD DE,$000E                           ; $ACB8 11 0e 00
    PUSH IY                               ; $ACBB fd e5
    POP HL                                ; $ACBD e1
    ADD HL,DE                             ; $ACBE 19
    LD DE,$AAA8                           ; $ACBF 11 a8 aa
    EX DE,HL                              ; $ACC2 eb
    LD BC,$000A                           ; $ACC3 01 0a 00
    LDIR                                  ; $ACC6 ed b0
    POP DE                                ; $ACC8 d1
    OR $01                                ; $ACC9 f6 01
    RET                                   ; $ACCB c9

    ORG $ACCC
; CODE: Coordinazioni e backtracking: esclusioni condivise e conteggio
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
    LD A,($A012)                          ; $ACE8 3a 12 a0
    LD ($AAA6),A                          ; $ACEB 32 a6 aa | Salva A012 per il backtracking. Non salva A01A: i due stati hanno cicli di vita distinti.
    LD A,($A01A)                          ; $ACEE 3a 1a a0 | Se A01A=2, il nodo attraversato da questa coordinazione è un’esclusione anche se il nodo precedente è stato sostituito.
    CP $02                                ; $ACF1 fe 02
    JR NZ,$AD57                           ; $ACF3 20 62
    SET 6,(IY+$01)                        ; $ACF5 fd cb 01 f6
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
    LD ($A012),A                          ; $AD3D 32 12 a0 | Ripristina il conteggio speculativo A012, non lo stato ALL/BUT.
    LD IY,($AAA4)                         ; $AD40 fd 2a a4 aa
    LD L,(IY-$02)                         ; $AD44 fd 6e fe
    LD H,(IY-$01)                         ; $AD47 fd 66 ff
    PUSH HL                               ; $AD4A e5
    POP IX                                ; $AD4B dd e1
    CALL $A1AF                            ; $AD4D cd af a1
    XOR A                                 ; $AD50 af
    LD (IY-$02),A                         ; $AD51 fd 77 fe
    LD (IY-$01),A                         ; $AD54 fd 77 ff
    LD A,($A01A)                          ; $AD57 3a 1a a0 | Con A01A=2 il separatore A0 salta AD66; la chiusura finale conta invece anche l’esclusione.
    DEC A                                 ; $AD5A 3d
    LD HL,$A012                           ; $AD5B 21 12 a0
    DEC A                                 ; $AD5E 3d
    LD A,D                                ; $AD5F 7a
    JR NZ,$AD66                           ; $AD60 20 04
    CP $A0                                ; $AD62 fe a0
    JR Z,$AD67                            ; $AD64 28 01
    INC (HL)                              ; $AD66 34
    CP $A0                                ; $AD67 fe a0
    JP Z,$AABD                            ; $AD69 ca bd aa

    ORG $AE11
; CODE: Eredità del verbo: applicata nella post-elaborazione riuscita
    LD A,(IY+$01)                         ; $AE11 fd 7e 01
    AND $7F                               ; $AE14 e6 7f
    OR (IY+$00)                           ; $AE16 fd b6 00
    CALL Z,$AEF1                          ; $AE19 cc f1 ae | Eredità solo dopo il parsing riuscito. Un verbo assunto per comodità dal modello semantico non deve finire nel payload del nodo liberato dopo un errore precedente.
    JR $ADE0                              ; $AE1C 18 c2

    ORG $AEF1
; CODE: Copia del verbo omesso senza propagare il bit ALL
    EXX                                   ; $AEF1 d9
    LD A,(IX+$01)                         ; $AEF2 dd 7e 01
    AND $7F                               ; $AEF5 e6 7f | Maschera il bit7 ALL del verbo precedente; il nuovo nodo non diventa un altro ALL.
    OR (IY+$01)                           ; $AEF7 fd b6 01
    LD (IY+$01),A                         ; $AEFA fd 77 01
    LD A,(IX+$00)                         ; $AEFD dd 7e 00
    LD (IY+$00),A                         ; $AF00 fd 77 00
    EXX                                   ; $AF03 d9

    ORG $AF67
; CODE: Errore sintattico: ritorno senza cancellare ALL/BUT
    LD A,$01                              ; $AF67 3e 01 | Errore sintattico: A01A conserva l’ultima scrittura. Non ripristinarlo dal nodo finale o azzerarlo nella gestione generale degli errori.
    AND A                                 ; $AF69 a7
    RET                                   ; $AF6A c9

    ORG $AFE8
; CODE: Condizioni di ALL: verbo, contatore e chiarimento pendente
    BIT 1,E                               ; $AFE8 cb 4b | ALL verifica il bit di presenza del verbo. Se manca, sono ammesse solo la prima costruzione e una precisazione pendente: gli altri casi tornano ad AF67.
    RET Z                                 ; $AFEA c8
    LD A,($A012)                          ; $AFEB 3a 12 a0
    AND A                                 ; $AFEE a7
    JR NZ,$AFF6                           ; $AFEF 20 05
    LD A,($A01B)                          ; $AFF1 3a 1b a0 | Consulta A01B, cioè il chiarimento pendente, dopo aver verificato il conteggio A012.
    AND A                                 ; $AFF4 a7
    RET NZ                                ; $AFF5 c0
    POP HL                                ; $AFF6 e1
    JP $AF67                              ; $AFF7 c3 67 af

    ORG $B01C
; CODE: Transizioni ALL=1 e BUT=2; nessuna ripetizione nella stessa unità
    LD A,($A01A)                          ; $B01C 3a 1a a0 | BUT richiede lo stato condiviso1, non il booleano ALL del nodo corrente.
    CP $01                                ; $B01F fe 01
    JP NZ,$AF67                           ; $B021 c2 67 af
    LD A,$02                              ; $B024 3e 02
    LD ($A01A),A                          ; $B026 32 1a a0 | Passa a2 prima dell’allocazione del nuovo nodo esclusione. Un errore nominale successivo conserva2.
    CALL $AE6A                            ; $B029 cd 6a ae
    SET 6,(IY+$01)                        ; $B02C fd cb 01 f6
    JP $AB52                              ; $B030 c3 52 ab
    CALL $AFE8                            ; $B033 cd e8 af | Il controllo AFE8 precede la verifica dello stato: non scrivere ALL=1 prima di aver superato entrambi.
    LD A,($A01A)                          ; $B036 3a 1a a0 | ALL è ammesso solo con stato0. Dopo AND lo stato resta condiviso finché non viene avviata una nuova unità.
    AND A                                 ; $B039 a7
    JP NZ,$AF67                           ; $B03A c2 67 af
    LD A,$01                              ; $B03D 3e 01
    LD ($A01A),A                          ; $B03F 32 1a a0 | Transizione a1; il bit7 del nodo è una seconda informazione distinta, usata dall’esecuzione collettiva.
    SET 7,(IY+$01)                        ; $B042 fd cb 01 fe
    JP $AB52                              ; $B046 c3 52 ab

    ORG $D835
; CODE: Fine di ALL: rilascio delle esclusioni e fallimento prima del nodo seguente
    LD A,($D6B8)                          ; $D835 3a b8 d6 | Il nodo ordinario e la coda di esclusioni vengono rimossi insieme quando la ricerca corrente è finita.
    AND A                                 ; $D838 a7
    JR NZ,$D858                           ; $D839 20 1d
    LD IX,($9FF2)                         ; $D83B dd 2a f2 9f
    LD L,(IX-$02)                         ; $D83F dd 6e fe
    LD H,(IX-$01)                         ; $D842 dd 66 ff
    LD ($9FF2),HL                         ; $D845 22 f2 9f
    CALL $A1C7                            ; $D848 cd c7 a1
    LD A,L                                ; $D84B 7d
    OR H                                  ; $D84C b4
    JR Z,$D858                            ; $D84D 28 09
    PUSH HL                               ; $D84F e5
    POP IX                                ; $D850 dd e1
    BIT 6,(IX+$01)                        ; $D852 dd cb 01 76
    JR NZ,$D83F                           ; $D856 20 e7
    OR $01                                ; $D858 f6 01
    RET                                   ; $D85A c9
    XOR A                                 ; $D85B af
    LD ($D6B8),A                          ; $D85C 32 b8 d6
    LD A,($A01C)                          ; $D85F 3a 1c a0
    AND A                                 ; $D862 a7
    JR Z,$D870                            ; $D863 28 0b
    LD A,$FF                              ; $D865 3e ff
    LD ($A033),A                          ; $D867 32 33 a0
    CALL $D835                            ; $D86A cd 35 d8 | Esaurimento di ALL: libera il nodo, poi DC15 restituisce fallimento. Se rimane un nodo ordinario nella stessa unità, il tentativo fallito viene contato prima di eseguirlo.
    JP $DC15                              ; $D86D c3 15 dc
