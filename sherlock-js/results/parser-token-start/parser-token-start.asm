; Dossier offline: dati e istruzioni distinti, riassellati contro il payload.

    ORG $A029
; DATA: Inizio dell’ultimo token letto: puntatore condiviso lexer/parser
    DEFB $00,$00                          ; $A029 00 00 | Word little-endian. D9CD punta ai caratteri5B00; AE82 ai token5B81, anche dentro una citazione. Persistente fra i turni: non è la fine della riga in ogni situazione e non deriva daA028.

    ORG $AE7F
; CODE: Lettore dei token: conserva inizio e avanza secondo la classe
    LD HL,($A02B)                         ; $AE7F 2a 2b a0 | A02B è il cursore prossimo; non confonderlo con A029 che conserva l’inizio appena letto.
    LD ($A029),HL                         ; $AE82 22 29 a0 | Writer word dell’inizio del token, anche quando il valore non cambia. A029 è il byte basso; A02A l’alto.
    LD A,D                                ; $AE85 7a
    LD ($A02D),A                          ; $AE86 32 2d a0 | Classe precedente inA02D: distinta dall’indirizzo iniziale e dal nuovoD.
    LD A,(HL)                             ; $AE89 7e
    LD D,A                                ; $AE8A 57
    LD BC,$0000                           ; $AE8B 01 00 00
    INC HL                                ; $AE8E 23
    CP $E0                                ; $AE8F fe e0 | E0,F0 e90 hanno payload di2byte anche se la classe è>=80.
    JR Z,$AE9F                            ; $AE91 28 0c
    CP $F0                                ; $AE93 fe f0
    JR Z,$AE9F                            ; $AE95 28 08
    CP $90                                ; $AE97 fe 90
    JR Z,$AE9F                            ; $AE99 28 04
    CP $80                                ; $AE9B fe 80 | Altre classi>=80 occupano1byte; classi<80 occupano3.
    JR NC,$AEA4                           ; $AE9D 30 05
    LD A,(HL)                             ; $AE9F 7e
    LD B,A                                ; $AEA0 47
    INC HL                                ; $AEA1 23
    LD C,(HL)                             ; $AEA2 4e
    INC HL                                ; $AEA3 23
    LD ($A02B),HL                         ; $AEA4 22 2b a0 | AvanzaA02B dopo il tipo e l’eventuale payload: questo store non riscriveA029.
    LD A,D                                ; $AEA7 7a
    RET                                   ; $AEA8 c9

    ORG $D9C5
; CODE: Lexer: salto degli spazi e writer del puntatore al carattere iniziale
    PUSH DE                               ; $D9C5 d5
    LD A,(HL)                             ; $D9C6 7e
    INC HL                                ; $D9C7 23
    CP $20                                ; $D9C8 fe 20
    JR Z,$D9C6                            ; $D9CA 28 fa
    DEC HL                                ; $D9CC 2b
    LD ($A029),HL                         ; $D9CD 22 29 a0 | Dopo il salto degli spazi, conservaHL prima del riconoscimento; può puntare anche aCR o a una parola sconosciuta.
    CP $0D                                ; $D9D0 fe 0d
    JR Z,$DA06                            ; $D9D2 28 32
    CALL $DAC6                            ; $D9D4 cd c6 da
    JR Z,$DA2F                            ; $D9D7 28 56
    CALL $DA34                            ; $D9D9 cd 34 da
    JR Z,$DA0A                            ; $D9DC 28 2c
    PUSH IX                               ; $D9DE dd e5
    XOR A                                 ; $D9E0 af
    LD ($DC14),A                          ; $D9E1 32 14 dc
    LD ($D9C3),DE                         ; $D9E4 ed 53 c3 d9
    LD DE,($DA32)                         ; $D9E8 ed 5b 32 da
    AND A                                 ; $D9EC a7
    PUSH HL                               ; $D9ED e5
    SBC HL,DE                             ; $D9EE ed 52
    POP HL                                ; $D9F0 e1
    JR Z,$DA12                            ; $D9F1 28 1f
    PUSH HL                               ; $D9F3 e5
    POP DE                                ; $D9F4 d1
    CALL $A94D                            ; $D9F5 cd 4d a9
    LD A,(DE)                             ; $D9F8 1a
    AND $F0                               ; $D9F9 e6 f0
    CP $D0                                ; $D9FB fe d0
    JR Z,$D9E8                            ; $D9FD 28 e9
    CALL $DA7D                            ; $D9FF cd 7d da
    JR Z,$DA12                            ; $DA02 28 0e
    JR $D9E4                              ; $DA04 18 de
    LD A,$C0                              ; $DA06 3e c0
    JR $DA0C                              ; $DA08 18 02
    LD A,$D0                              ; $DA0A 3e d0
    LD BC,$0000                           ; $DA0C 01 00 00
    POP DE                                ; $DA0F d1
    LD D,A                                ; $DA10 57
    RET                                   ; $DA11 c9
    POP HL                                ; $DA12 e1
    LD A,($DC14)                          ; $DA13 3a 14 dc
    CP $04                                ; $DA16 fe 04
    JR NC,$DA21                           ; $DA18 30 07
    LD B,A                                ; $DA1A 47
    LD A,($DC13)                          ; $DA1B 3a 13 dc
    CP B                                  ; $DA1E b8
    JR NZ,$DA0A                           ; $DA1F 20 e9
    PUSH HL                               ; $DA21 e5
    LD HL,($D9C3)                         ; $DA22 2a c3 d9
    LD A,(HL)                             ; $DA25 7e
    AND $F0                               ; $DA26 e6 f0
    LD BC,$5DBF                           ; $DA28 01 bf 5d
    SBC HL,BC                             ; $DA2B ed 42
    EX (SP),HL                            ; $DA2D e3
    POP BC                                ; $DA2E c1
    POP DE                                ; $DA2F d1
    LD D,A                                ; $DA30 57
    RET                                   ; $DA31 c9

    ORG $D6CE
; CODE: Preflight lessicale e rifiuto della parola sconosciuta
    LD HL,$5B00                           ; $D6CE 21 00 5b
    CALL $D9C5                            ; $D6D1 cd c5 d9
    CP $D0                                ; $D6D4 fe d0
    JP Z,$D6E0                            ; $D6D6 ca e0 d6
    CP $C0                                ; $D6D9 fe c0
    JR NZ,$D6D1                           ; $D6DB 20 f4
    OR $01                                ; $D6DD f6 01
    RET                                   ; $D6DF c9
    LD HL,$D6E5                           ; $D6E0 21 e5 d6
    XOR A                                 ; $D6E3 af
    RET                                   ; $D6E4 c9
    LD A,$01                              ; $D6E5 3e 01
    LD ($A027),A                          ; $D6E7 32 27 a0
    LD HL,$6859                           ; $D6EA 21 59 68
    CALL $A59F                            ; $D6ED cd 9f a5
    LD HL,($D6BD)                         ; $D6F0 2a bd d6
    LD (HL),$C0                           ; $D6F3 36 c0
    LD HL,($A029)                         ; $D6F5 2a 29 a0 | La stampa del rifiuto lessicale riparte daA029, prima parola non riconosciuta.
    LD A,(HL)                             ; $D6F8 7e
    CP $2E                                ; $D6F9 fe 2e
    JR NZ,$D6FF                           ; $D6FB 20 02
    LD A,$20                              ; $D6FD 3e 20
    CALL $A9B7                            ; $D6FF cd b7 a9
    INC HL                                ; $D702 23
    CP $20                                ; $D703 fe 20
    JR NZ,$D6F8                           ; $D705 20 f1
    LD A,$22                              ; $D707 3e 22
    CALL $A9B7                            ; $D709 cd b7 a9
    CALL $A2A2                            ; $D70C cd a2 a2
    XOR A                                 ; $D70F af
    LD ($A027),A                          ; $D710 32 27 a0
    RET                                   ; $D713 c9

    ORG $D719
; CODE: Seconda scansione lessicale e serializzazione in5B81
    XOR A                                 ; $D719 af
    LD ($A019),A                          ; $D71A 32 19 a0
    CALL $C142                            ; $D71D cd 42 c1
    LD A,($D714)                          ; $D720 3a 14 d7
    AND A                                 ; $D723 a7
    JR NZ,$D760                           ; $D724 20 3a
    LD HL,$5B81                           ; $D726 21 81 5b
    LD B,$60                              ; $D729 06 60
    CALL $A2AB                            ; $D72B cd ab a2
    LD HL,$5B00                           ; $D72E 21 00 5b
    LD IY,$5B81                           ; $D731 fd 21 81 5b
    LD (IY+$00),$C0                       ; $D735 fd 36 00 c0
    CALL $D9C5                            ; $D739 cd c5 d9 | Seconda scansione degli stessi caratteri: serializza le classi e i valori nel buffer dei token.
    LD (IY+$00),D                         ; $D73C fd 72 00
    INC IY                                ; $D73F fd 23
    CP $E0                                ; $D741 fe e0
    JR Z,$D751                            ; $D743 28 0c
    CP $F0                                ; $D745 fe f0
    JR Z,$D751                            ; $D747 28 08
    CP $90                                ; $D749 fe 90
    JR Z,$D751                            ; $D74B 28 04
    CP $80                                ; $D74D fe 80
    JR NC,$D75B                           ; $D74F 30 0a
    LD (IY+$00),B                         ; $D751 fd 70 00
    LD (IY+$01),C                         ; $D754 fd 71 01
    INC IY                                ; $D757 fd 23
    INC IY                                ; $D759 fd 23
    LD A,D                                ; $D75B 7a
    CP $C0                                ; $D75C fe c0
    JR NZ,$D735                           ; $D75E 20 d5
    LD HL,$5B81                           ; $D760 21 81 5b
    LD ($D6BD),HL                         ; $D763 22 bd d6
    OR $01                                ; $D766 f6 01
    RET                                   ; $D768 c9

    ORG $D780
; CODE: Parser del giocatore: cursore di ripresa e lista di sintassi
    XOR A                                 ; $D780 af
    LD ($9FEB),A                          ; $D781 32 eb 9f
    INC A                                 ; $D784 3c
    LD ($A024),A                          ; $D785 32 24 a0
    LD HL,($D6BD)                         ; $D788 2a bd d6
    LD ($A02B),HL                         ; $D78B 22 2b a0 | A02B inizializzato dal cursore salvatoD6BD; A029 sarà scritto dal lettore, non da questa assegnazione.
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

    ORG $AAD1
; CODE: Scansione speculativa del soggetto e ritorno al token
    PUSH DE                               ; $AAD1 d5
    LD A,($A024)                          ; $AAD2 3a 24 a0
    AND A                                 ; $AAD5 a7
    JR NZ,$AB11                           ; $AAD6 20 39
    LD ($AAA7),A                          ; $AAD8 32 a7 aa
    LD HL,($A02B)                         ; $AADB 2a 2b a0
    PUSH HL                               ; $AADE e5
    CALL $AC24                            ; $AADF cd 24 ac
    JR NZ,$AB08                           ; $AAE2 20 24
    LD A,($AAA7)                          ; $AAE4 3a a7 aa
    AND A                                 ; $AAE7 a7
    JR NZ,$AB08                           ; $AAE8 20 1e
    LD A,$02                              ; $AAEA 3e 02
    LD ($A024),A                          ; $AAEC 32 24 a0
    POP HL                                ; $AAEF e1
    PUSH IY                               ; $AAF0 fd e5
    POP HL                                ; $AAF2 e1
    LD DE,$0018                           ; $AAF3 11 18 00
    ADD HL,DE                             ; $AAF6 19
    LD DE,$AAAC                           ; $AAF7 11 ac aa
    EX DE,HL                              ; $AAFA eb
    LD BC,$0006                           ; $AAFB 01 06 00
    LDIR                                  ; $AAFE ed b0
    LD HL,($A029)                         ; $AB00 2a 29 a0 | Selezione affermazione: rilegge il primo token non incluso nel soggetto.
    LD ($A02B),HL                         ; $AB03 22 2b a0
    JR $AB11                              ; $AB06 18 09
    LD A,$01                              ; $AB08 3e 01
    LD ($A024),A                          ; $AB0A 32 24 a0
    POP HL                                ; $AB0D e1
    LD ($A02B),HL                         ; $AB0E 22 2b a0 | Fallback dal soggetto speculativo: ripristina il vecchio cursore prossimo.

    ORG $AB4C
; CODE: Gruppi nominali e predicati: rilettura dal token corrente
    LD HL,($A029)                         ; $AB4C 2a 29 a0 | Un gruppo nominale riparte dal token già letto: il puntatore non è dedotto dalla posizione semantica nel comando.
    LD ($A02B),HL                         ; $AB4F 22 2b a0
    CALL $AC24                            ; $AB52 cd 24 ac
    JR C,$AB8E                            ; $AB55 38 37
    JR NZ,$AB60                           ; $AB57 20 07
    CALL $ACA6                            ; $AB59 cd a6 ac
    JR Z,$AB8E                            ; $AB5C 28 30
    JR $AB4C                              ; $AB5E 18 ec
    CP $B0                                ; $AB60 fe b0
    JP Z,$AD57                            ; $AB62 ca 57 ad
    CP $A0                                ; $AB65 fe a0
    JP Z,$ACCC                            ; $AB67 ca cc ac
    CP $90                                ; $AB6A fe 90
    JP Z,$AFB3                            ; $AB6C ca b3 af
    LD HL,($A029)                         ; $AB6F 2a 29 a0
    LD ($A02B),HL                         ; $AB72 22 2b a0
    LD A,($A024)                          ; $AB75 3a 24 a0
    CP $02                                ; $AB78 fe 02
    JR NZ,$AB8E                           ; $AB7A 20 12
    CALL $ABF3                            ; $AB7C cd f3 ab
    JR C,$AB8E                            ; $AB7F 38 0d
    JR NZ,$AB8E                           ; $AB81 20 0b
    LD HL,($A029)                         ; $AB83 2a 29 a0
    LD ($A02B),HL                         ; $AB86 22 2b a0
    LD D,$A0                              ; $AB89 16 a0
    JP $ACCC                              ; $AB8B c3 cc ac

    ORG $B049
; CODE: Citazione differita: puntatore al contenuto e terminatore temporaneo
    BIT 1,E                               ; $B049 cb 4b
    JR Z,$B058                            ; $B04B 28 0b
    LD HL,$088B                           ; $B04D 21 8b 08
    LD (IY+$00),L                         ; $B050 fd 75 00
    LD (IY+$01),H                         ; $B053 fd 74 01
    RES 1,E                               ; $B056 cb 8b
    PUSH HL                               ; $B058 e5
    PUSH DE                               ; $B059 d5
    PUSH IY                               ; $B05A fd e5
    PUSH IX                               ; $B05C dd e5
    LD IY,$9FEC                           ; $B05E fd 21 ec 9f
    LD DE,$0000                           ; $B062 11 00 00
    CALL $A104                            ; $B065 cd 04 a1
    LD A,$02                              ; $B068 3e 02
    CALL $A11C                            ; $B06A cd 1c a1
    LD HL,($A02B)                         ; $B06D 2a 2b a0 | Salva il cursore al contenuto dopo la virgoletta iniziale nella lista delle citazioni.
    LD (IX+$00),L                         ; $B070 dd 75 00
    LD (IX+$01),H                         ; $B073 dd 74 01
    PUSH IX                               ; $B076 dd e5
    POP HL                                ; $B078 e1
    LD (IY-$02),L                         ; $B079 fd 75 fe
    LD (IY-$01),H                         ; $B07C fd 74 ff
    POP IX                                ; $B07F dd e1
    POP IY                                ; $B081 fd e1
    POP DE                                ; $B083 d1
    POP HL                                ; $B084 e1
    CALL $AE7F                            ; $B085 cd 7f ae | Legge fino alla virgoletta finale; i token interni sono già stati consultati dal medesimo writer.
    CP $90                                ; $B088 fe 90
    JR NZ,$B085                           ; $B08A 20 f9
    LD A,B                                ; $B08C 78
    AND $0F                               ; $B08D e6 0f
    OR C                                  ; $B08F b1
    JR NZ,$B085                           ; $B090 20 f3
    LD HL,($A029)                         ; $B092 2a 29 a0 | La virgoletta finale puntata daA029 diventaC0 per il parsing differito; il suo indirizzo resta valido.
    LD (HL),$C0                           ; $B095 36 c0
    JP $AB52                              ; $B097 c3 52 ab
