; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.

    ORG $A024
; DATA: Modalità sintattica persistente:0 automatica,1 comando,2 affermazione
    DEFB $00                              ; $A024 00 | Byte persistente.0 autodetect,1 comando,2 affermazione. Il lexer non lo resetta. Vecchi LOAD senza campo restano sconosciuti fino a un writer verificato; non installare1 dal riferimento casuale.

    ORG $AAB2
; CODE: Parser comune: continuazione e scelta speculativa della modalità
    XOR A                                 ; $AAB2 af
    LD ($A01A),A                          ; $AAB3 32 1a a0
    LD ($A012),A                          ; $AAB6 32 12 a0
    LD E,$FF                              ; $AAB9 1e ff
    LD D,$C0                              ; $AABB 16 c0
    LD A,E                                ; $AABD 7b
    OR $C7                                ; $AABE f6 c7
    LD E,A                                ; $AAC0 5f
    CALL $AE6A                            ; $AAC1 cd 6a ae
    LD A,($A01B)                          ; $AAC4 3a 1b a0
    AND A                                 ; $AAC7 a7
    JR Z,$AAD1                            ; $AAC8 28 07
    LD A,$01                              ; $AACA 3e 01
    LD ($A024),A                          ; $AACC 32 24 a0 | Una continuazione pendente forza1 prima della scansione comune, anche se il chiamante citato era in modo0.
    RES 3,E                               ; $AACF cb 9b
    PUSH DE                               ; $AAD1 d5
    LD A,($A024)                          ; $AAD2 3a 24 a0 | Legge il modo corrente: il parser comune non lo azzera automaticamente a ogni unità.
    AND A                                 ; $AAD5 a7
    JR NZ,$AB11                           ; $AAD6 20 39
    LD ($AAA7),A                          ; $AAD8 32 a7 aa
    LD HL,($A02B)                         ; $AADB 2a 2b a0
    PUSH HL                               ; $AADE e5
    CALL $AC24                            ; $AADF cd 24 ac | In modo0 tenta il gruppo soggetto. Relazioni o fallimento ripristinano il cursore e passano al comando.
    JR NZ,$AB08                           ; $AAE2 20 24
    LD A,($AAA7)                          ; $AAE4 3a a7 aa
    AND A                                 ; $AAE7 a7
    JR NZ,$AB08                           ; $AAE8 20 1e
    LD A,$02                              ; $AAEA 3e 02
    LD ($A024),A                          ; $AAEC 32 24 a0 | Soggetto riconosciuto senza relazioni: scrive2, poi copia i sei byte del soggetto nel nodo.
    POP HL                                ; $AAEF e1
    PUSH IY                               ; $AAF0 fd e5
    POP HL                                ; $AAF2 e1
    LD DE,$0018                           ; $AAF3 11 18 00
    ADD HL,DE                             ; $AAF6 19
    LD DE,$AAAC                           ; $AAF7 11 ac aa
    EX DE,HL                              ; $AAFA eb
    LD BC,$0006                           ; $AAFB 01 06 00
    LDIR                                  ; $AAFE ed b0
    LD HL,($A029)                         ; $AB00 2a 29 a0
    LD ($A02B),HL                         ; $AB03 22 2b a0
    JR $AB11                              ; $AB06 18 09
    LD A,$01                              ; $AB08 3e 01
    LD ($A024),A                          ; $AB0A 32 24 a0 | Scansione speculativa fallita: scrive1 prima di ripristinare il cursore dei token.
    POP HL                                ; $AB0D e1
    LD ($A02B),HL                         ; $AB0E 22 2b a0

    ORG $B135
; CODE: Pronomi HE e IT/THEY: writer espliciti della modalità affermazione
    CALL $AFE1                            ; $B135 cd e1 af
    LD A,$02                              ; $B138 3e 02
    LD ($A024),A                          ; $B13A 32 24 a0 | HE scrive2 dopo il controllo AFE1; errori prima del controllo non costituiscono writer.
    JR $B14B                              ; $B13D 18 0c
    BIT 3,E                               ; $B13F cb 5b
    JR Z,$B14B                            ; $B141 28 08
    PUSH DE                               ; $B143 d5
    CALL $AEA9                            ; $B144 cd a9 ae
    CALL $AE6A                            ; $B147 cd 6a ae
    POP DE                                ; $B14A d1
    SET 7,(IY+$19)                        ; $B14B fd cb 19 fe
    JR $B12E                              ; $B14F 18 dd
    CALL $AFE1                            ; $B151 cd e1 af
    LD A,$02                              ; $B154 3e 02
    LD ($A024),A                          ; $B156 32 24 a0 | IT/THEY scrivono2 dopo il controllo AFE1; il flag del soggetto resta distinto dalla modalità.
    JR $B167                              ; $B159 18 0c
    BIT 3,E                               ; $B15B cb 5b
    JR Z,$B167                            ; $B15D 28 08
    PUSH DE                               ; $B15F d5
    CALL $AEA9                            ; $B160 cd a9 ae
    CALL $AE6A                            ; $B163 cd 6a ae
    POP DE                                ; $B166 d1
    SET 6,(IY+$19)                        ; $B167 fd cb 19 f6
    JR $B12E                              ; $B16B 18 c1

    ORG $B8AA
; CODE: Citazione differita: modo0 una volta, conservato fra le unità e nel record
    LD HL,($B868)                         ; $B8AA 2a 68 b8
    LD ($A02B),HL                         ; $B8AD 22 2b a0
    XOR A                                 ; $B8B0 af
    LD ($A024),A                          ; $B8B1 32 24 a0 | Ingresso nella citazione: scrive0 una sola volta. Non ristabilire0 fra le frasi della stessa citazione.
    LD HL,($9FF0)                         ; $B8B4 2a f0 9f
    PUSH HL                               ; $B8B7 e5
    LD HL,$0000                           ; $B8B8 21 00 00
    LD ($9FF0),HL                         ; $B8BB 22 f0 9f
    CALL $AAB2                            ; $B8BE cd b2 aa | Ripete AAB2 conservando A024; una frase comando non riattiva autodetect per il soggetto seguente.
    JR Z,$B8C7                            ; $B8C1 28 04
    CP $02                                ; $B8C3 fe 02
    JR NZ,$B904                           ; $B8C5 20 3d
    LD HL,($A02B)                         ; $B8C7 2a 2b a0
    LD A,(HL)                             ; $B8CA 7e
    AND $F0                               ; $B8CB e6 f0
    CP $C0                                ; $B8CD fe c0
    JR NZ,$B8BE                           ; $B8CF 20 ed
    LD (HL),$90                           ; $B8D1 36 90
    LD A,$08                              ; $B8D3 3e 08
    CALL $A11C                            ; $B8D5 cd 1c a1
    LD HL,($9FEE)                         ; $B8D8 2a ee 9f
    LD ($9FEE),IX                         ; $B8DB dd 22 ee 9f
    LD (IX-$02),L                         ; $B8DF dd 75 fe
    LD (IX-$01),H                         ; $B8E2 dd 74 ff
    LD HL,($9FF0)                         ; $B8E5 2a f0 9f
    LD (IX+$05),L                         ; $B8E8 dd 75 05
    LD (IX+$06),H                         ; $B8EB dd 74 06
    POP HL                                ; $B8EE e1
    LD ($9FF0),HL                         ; $B8EF 22 f0 9f
    XOR A                                 ; $B8F2 af
    LD (IX+$01),A                         ; $B8F3 dd 77 01
    LD A,($A034)                          ; $B8F6 3a 34 a0
    LD (IX+$00),A                         ; $B8F9 dd 77 00
    LD A,($A024)                          ; $B8FC 3a 24 a0 | Legge il modo finale e lo conserva al byte7 del record: non lo deduce dal singolo nodo.
    LD (IX+$07),A                         ; $B8FF dd 77 07
    XOR A                                 ; $B902 af
    RET                                   ; $B903 c9
    PUSH AF                               ; $B904 f5
    CALL $D87D                            ; $B905 cd 7d d8
    POP AF                                ; $B908 f1
    POP HL                                ; $B909 e1
    LD ($9FF0),HL                         ; $B90A 22 f0 9f
    RET                                   ; $B90D c9

    ORG $D780
; CODE: Parser ordinario: modo1 a ogni ingresso, prima dell’analisi
    XOR A                                 ; $D780 af
    LD ($9FEB),A                          ; $D781 32 eb 9f
    INC A                                 ; $D784 3c
    LD ($A024),A                          ; $D785 32 24 a0 | Ogni ingresso ordinario scrive1. Una riga composta può passare qui più volte, a differenza del ciclo B8BE.
    LD HL,($D6BD)                         ; $D788 2a bd d6
    LD ($A02B),HL                         ; $D78B 22 2b a0
    CALL $AAB2                            ; $D78E cd b2 aa
    PUSH AF                               ; $D791 f5
    XOR A                                 ; $D792 af
    LD ($A01B),A                          ; $D793 32 1b a0
    POP AF                                ; $D796 f1
    LD HL,($A02B)                         ; $D797 2a 2b a0
    LD ($D6BD),HL                         ; $D79A 22 bd d6
    JR NZ,$D7B2                           ; $D79D 20 13
    LD HL,($9FF0)                         ; $D79F 2a f0 9f
    LD ($9FF2),HL                         ; $D7A2 22 f2 9f
    LD HL,$0000                           ; $D7A5 21 00 00
    LD ($9FF0),HL                         ; $D7A8 22 f0 9f
    XOR A                                 ; $D7AB af
    LD ($D6B8),A                          ; $D7AC 32 b8 d6
    OR $01                                ; $D7AF f6 01
    RET                                   ; $D7B1 c9
