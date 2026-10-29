; Dossier offline: istruzioni riassemblate e dati tipizzati; nessuna CPU nel runtime.

    ORG $A01C
; DATA: Modo della risoluzione: normale0 o iterazione128
    DEFB $00                              ; $A01C 00 | Byte condiviso0/128. Non coincide col lessico A01A0/1/2 né col chiarimento A01B08/12. Conservare il valore fino a uno dei quattro writer D800/B1EC/B1FD/B959.

    ORG $D6B8
; DATA: Continuazione semantica del giocatore, distinta dal modo globale
    DEFB $00                              ; $D6B8 00 | Il giocatore mantiene qui il proprio stato attraverso turni NPC che possono cambiare A01C. A041 lo azzera all’avvio, D81B copia il modo dopo successo, D85C lo azzera su fallimento. Vecchi save assenti restano sconosciuti.

    ORG $A040
; CODE: Avvio: reset esplicito D6B8 e chiarimento
    XOR A                                 ; $A040 af
    LD ($D6B8),A                          ; $A041 32 b8 d6 | Reset reale della continuazione del giocatore; A01C invece conserva il dato iniziale caricato0 durante l’avvio verificato.
    LD ($A01B),A                          ; $A044 32 1b a0
    DI                                    ; $A047 f3

    ORG $82B1
; DATA: Modello12 CLIMB INTO: forza un solo referente
    DEFB $B2,$81,$77,$24,$00,$00,$00,$50  ; $82B1 b2 81 77 24 00 00 00 50 | Record lessicale di8 byte. Il bit4 del modo proiettato in A01E obbliga A01C=0; ALL non trasforma CLIMB INTO in più ingressi successivi.

    ORG $8349
; DATA: Modello31 HAIL: forza un solo referente
    DEFB $BE,$93,$00,$00,$00,$00,$00,$10  ; $8349 be 93 00 00 00 00 00 10 | Stesso bit4 nel modello HAIL: sceglie un referente e non enumera veicoli/oggetti come un ALL ordinario.

    ORG $B1DD
; CODE: Ingresso semantico: riuso del modo, flag ALL e azzeramento forzato
    CALL $C493                            ; $B1DD cd 93 c4
    CALL $C4B2                            ; $B1E0 cd b2 c4
    LD A,($A01C)                          ; $B1E3 3a 1c a0 | Con modo già nonzero riusa il cursore precedente: non riinizializzare la ricerca a ogni candidato.
    AND A                                 ; $B1E6 a7
    JR NZ,$B1F2                           ; $B1E7 20 09
    LD A,($B39C)                          ; $B1E9 3a 9c b3
    LD ($A01C),A                          ; $B1EC 32 1c a0 | Solo con A01C=0 copia il bit ALL del nodo da B39C:0/128. Anche riscrivere0 è un evento reale.
    CALL $B34F                            ; $B1EF cd 4f b3
    LD A,($A01E)                          ; $B1F2 3a 1e a0
    AND $10                               ; $B1F5 e6 10
    LD ($B190),A                          ; $B1F7 32 90 b1
    JR Z,$B200                            ; $B1FA 28 04
    XOR A                                 ; $B1FC af
    LD ($A01C),A                          ; $B1FD 32 1c a0 | Bit4 del modo del modello: azzera incondizionatamente A01C dopo il riconoscimento. Non confondere con A01A, che può ancora indicare ALL nel lexer.
    XOR A                                 ; $B200 af
    LD ($A00B),A                          ; $B201 32 0b a0
    LD A,($A01D)                          ; $B204 3a 1d a0
    AND $0C                               ; $B207 e6 0c
    JR NZ,$B213                           ; $B209 20 08
    CALL $C929                            ; $B20B cd 29 c9
    RET NZ                                ; $B20E c0
    LD HL,$B863                           ; $B20F 21 63 b8
    RET                                   ; $B212 c9

    ORG $B213
; CODE: Ricerca del primo referente: scelta singola o scansione completa
    CALL $B387                            ; $B213 cd 87 b3
    JR NZ,$B280                           ; $B216 20 68
    LD A,($A01C)                          ; $B218 3a 1c a0 | Nel modo normale esegue la conta nominale; con ALL riprende direttamente dal cursore conservato.
    AND A                                 ; $B21B a7
    JR NZ,$B224                           ; $B21C 20 06
    CALL $B308                            ; $B21E cd 08 b3
    AND A                                 ; $B221 a7
    JR Z,$B259                            ; $B222 28 35
    CALL $B4C1                            ; $B224 cd c1 b4
    JR Z,$B244                            ; $B227 28 1b
    CALL $C929                            ; $B229 cd 29 c9
    JR Z,$B224                            ; $B22C 28 f6
    LD A,($A034)                          ; $B22E 3a 34 a0
    LD ($B184),A                          ; $B231 32 84 b1
    LD HL,$B170                           ; $B234 21 70 b1
    INC (HL)                              ; $B237 34
    LD A,($B190)                          ; $B238 3a 90 b1
    AND A                                 ; $B23B a7
    JR NZ,$B244                           ; $B23C 20 06
    LD A,($A01C)                          ; $B23E 3a 1c a0 | Con ALL si ferma dopo il primo candidato accettabile; in modalità normale continua per scoprire l’ambiguità e porre WHICH.
    AND A                                 ; $B241 a7
    JR Z,$B224                            ; $B242 28 e0
    LD A,($B184)                          ; $B244 3a 84 b1
    LD ($A034),A                          ; $B247 32 34 a0
    LD A,($B170)                          ; $B24A 3a 70 b1
    AND A                                 ; $B24D a7
    JR Z,$B259                            ; $B24E 28 09
    CP $01                                ; $B250 fe 01
    JR Z,$B20B                            ; $B252 28 b7
    LD HL,$B5E2                           ; $B254 21 e2 b5
    XOR A                                 ; $B257 af
    RET                                   ; $B258 c9

    ORG $B280
; CODE: Due argomenti: ricerca delle coppie e riuso del cursore ALL
    LD A,($A01C)                          ; $B280 3a 1c a0 | La coppia richiede la ricerca iniziale di entrambi i nomi soltanto senza continuazione ALL. Il numero dei secondi argomenti non è un semplice prodotto di elenchi indipendenti.
    AND A                                 ; $B283 a7
    JR NZ,$B292                           ; $B284 20 0c
    CALL $B308                            ; $B286 cd 08 b3
    AND A                                 ; $B289 a7
    JR Z,$B259                            ; $B28A 28 cd
    CALL $B32D                            ; $B28C cd 2d b3
    AND A                                 ; $B28F a7
    JR Z,$B303                            ; $B290 28 71
    CALL $B4C1                            ; $B292 cd c1 b4
    JR Z,$B2B7                            ; $B295 28 20
    CALL $B2DF                            ; $B297 cd df b2
    LD A,($B171)                          ; $B29A 3a 71 b1
    CP $01                                ; $B29D fe 01
    JR NZ,$B292                           ; $B29F 20 f1
    LD A,($A034)                          ; $B2A1 3a 34 a0
    LD ($B184),A                          ; $B2A4 32 84 b1
    LD HL,$B170                           ; $B2A7 21 70 b1
    INC (HL)                              ; $B2AA 34
    LD A,($B190)                          ; $B2AB 3a 90 b1
    AND A                                 ; $B2AE a7
    JR NZ,$B2B7                           ; $B2AF 20 06
    LD A,($A01C)                          ; $B2B1 3a 1c a0
    AND A                                 ; $B2B4 a7
    JR Z,$B292                            ; $B2B5 28 db

    ORG $B39C
; DATA: Flag ALL dell’ultimo nodo esaminato: distinto da A01A e A01C
    DEFB $00                              ; $B39C 00 | Solo il bit15 del verbo viene copiato qui. Il suo ruolo è compreso, ma il nuovo runtime non pubblica ancora questo byte come ingresso casuale autonomo.

    ORG $B39D
; CODE: Lettura del verbo: separa bit15 ALL dalla parola lessicale
    PUSH IY                               ; $B39D fd e5
    LD L,(IY+$00)                         ; $B39F fd 6e 00
    LD H,(IY+$01)                         ; $B3A2 fd 66 01
    LD A,H                                ; $B3A5 7c
    AND $80                               ; $B3A6 e6 80
    LD ($B39C),A                          ; $B3A8 32 9c b3 | Scrive B39C prima del confronto dei modelli. A01C viene aggiornato solo più avanti, se il modello è stato trovato.
    RES 7,H                               ; $B3AB cb bc
    LD ($B186),HL                         ; $B3AD 22 86 b1

    ORG $B936
; CODE: Richieste NPC: modo dal record e salvataggio della continuazione
    PUSH IX                               ; $B936 dd e5
    PUSH IY                               ; $B938 fd e5
    PUSH HL                               ; $B93A e5
    LD ($B935),A                          ; $B93B 32 35 b9
    CALL $B90E                            ; $B93E cd 0e b9
    LD A,(IX+$07)                         ; $B941 dd 7e 07
    CP $02                                ; $B944 fe 02
    JP Z,$BA20                            ; $B946 ca 20 ba | Le affermazioni seguono BA20 prima del writer B959: non aggiungere una scrittura del modo a ogni frase rivolta a un NPC.
    LD A,(IX+$01)                         ; $B949 dd 7e 01
    CP $FF                                ; $B94C fe ff
    JR Z,$B98C                            ; $B94E 28 3c
    LD A,($B935)                          ; $B950 3a 35 b9
    LD ($B934),A                          ; $B953 32 34 b9
    LD A,(IX+$02)                         ; $B956 dd 7e 02
    LD ($A01C),A                          ; $B959 32 1c a0 | Una richiesta sintattica copia A01C dal byte2 del proprio record, non dal contesto del giocatore. Le richieste prefabbricate passano B98C e non attraversano questo writer.
    LD C,(IX+$03)                         ; $B95C dd 4e 03
    LD B,(IX+$04)                         ; $B95F dd 46 04
    LD ($B17E),BC                         ; $B962 ed 43 7e b1
    CALL $B191                            ; $B966 cd 91 b1
    JR Z,$B9B4                            ; $B969 28 49
    LD IX,($B866)                         ; $B96B dd 2a 66 b8
    LD BC,($B17E)                         ; $B96F ed 4b 7e b1
    LD (IX+$03),C                         ; $B973 dd 71 03
    LD (IX+$04),B                         ; $B976 dd 70 04
    LD A,($A01C)                          ; $B979 3a 1c a0
    LD (IX+$02),A                         ; $B97C dd 77 02 | Conserva il modo della richiesta nel record dopo un passo riuscito; se è0 avanza/rilascia il nodo, se128 lo mantiene per la visita successiva.
    AND A                                 ; $B97F a7
    CALL Z,$B9CA                          ; $B980 cc ca b9
    LD A,$01                              ; $B983 3e 01
    POP HL                                ; $B985 e1
    POP IY                                ; $B986 fd e1
    POP IX                                ; $B988 dd e1
    AND A                                 ; $B98A a7
    RET                                   ; $B98B c9

    ORG $B9AC
; CODE: Fallimento NPC: pulizia diversa per ALL e richiesta normale
    CALL $B9CA                            ; $B9AC cd ca b9
    JR NZ,$B9AC                           ; $B9AF 20 fb
    XOR A                                 ; $B9B1 af
    JR $B985                              ; $B9B2 18 d1
    LD A,($A01C)                          ; $B9B4 3a 1c a0 | Fallimento con ALL: azzera il modo nel record e avanza la sintassi; A01C può restare128. La richiesta normale scarta i nodi restanti.
    AND A                                 ; $B9B7 a7
    JR Z,$B9AC                            ; $B9B8 28 f2
    LD IX,($B866)                         ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                       ; $B9BE dd 36 02 00
    CALL $B9CA                            ; $B9C2 cd ca b9
    JR Z,$B9B1                            ; $B9C5 28 ea
    JP $B93E                              ; $B9C7 c3 3e b9

    ORG $B9CA
; CODE: Avanza la richiesta e libera i nodi saltando BUT ed EXCEPT
    LD IX,($B866)                         ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                         ; $B9CE fd 6e fe
    LD H,(IY-$01)                         ; $B9D1 fd 66 ff
    LD (IX+$05),L                         ; $B9D4 dd 75 05 | Aggiorna il puntatore sintattico della richiesta prima di liberare il nodo corrente. Non eliminare il suffisso della richiesta quando ALL si esaurisce.
    LD (IX+$06),H                         ; $B9D7 dd 74 06
    PUSH IX                               ; $B9DA dd e5
    PUSH IY                               ; $B9DC fd e5
    POP IX                                ; $B9DE dd e1
    CALL $A1C7                            ; $B9E0 cd c7 a1
    POP IX                                ; $B9E3 dd e1
    LD A,L                                ; $B9E5 7d
    OR H                                  ; $B9E6 b4
    JR Z,$B9F5                            ; $B9E7 28 0c
    PUSH HL                               ; $B9E9 e5
    POP IY                                ; $B9EA fd e1
    BIT 6,(IY+$01)                        ; $B9EC fd cb 01 76 | Bit6 nel byte alto del verbo: i nodi BUT/EXCEPT sono clausole di esclusione, non comandi autonomi. Avanza e libera anche questi nodi prima di riprendere il resolver.
    JR NZ,$B9CE                           ; $B9F0 20 dc
    OR $01                                ; $B9F2 f6 01
    RET                                   ; $B9F4 c9
    CALL $B9FA                            ; $B9F5 cd fa b9
    XOR A                                 ; $B9F8 af
    RET                                   ; $B9F9 c9

    ORG $D7FC
; CODE: Giocatore: copia D6B8, risoluzione, trasferimento e rilascio dei nodi
    XOR A                                 ; $D7FC af
    LD A,($D6B8)                          ; $D7FD 3a b8 d6
    LD ($A01C),A                          ; $D800 32 1c a0 | Prima di ogni tentativo semantico del giocatore copia D6B8 in A01C. Errori lessicali e sintattici precedenti non raggiungono questa scrittura.
    LD IY,($9FF2)                         ; $D803 fd 2a f2 9f
    LD HL,($D6BB)                         ; $D807 2a bb d6
    LD ($B17E),HL                         ; $D80A 22 7e b1
    CALL $B191                            ; $D80D cd 91 b1
    LD A,$01                              ; $D810 3e 01
    LD ($A00B),A                          ; $D812 32 0b a0
    JP Z,$D85B                            ; $D815 ca 5b d8
    LD A,($A01C)                          ; $D818 3a 1c a0
    LD ($D6B8),A                          ; $D81B 32 b8 d6 | Successo semantico: conserva il modo prima dell’esecuzione dell’azione e delle visite NPC. Non ricavarlo dal risultato del corpo dell’azione.
    LD A,$01                              ; $D81E 3e 01
    LD ($A026),A                          ; $D820 32 26 a0
    LD A,($A033)                          ; $D823 3a 33 a0
    LD ($9FD6),A                          ; $D826 32 d6 9f
    LD HL,($A034)                         ; $D829 2a 34 a0
    LD ($9FD7),HL                         ; $D82C 22 d7 9f
    LD HL,($B17E)                         ; $D82F 2a 7e b1
    LD ($D6BB),HL                         ; $D832 22 bb d6
    LD A,($D6B8)                          ; $D835 3a b8 d6 | Rilascia il nodo soltanto con D6B8=0; ALL mantiene la stessa allocazione fra azioni e visite NPC.
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
    LD ($D6B8),A                          ; $D85C 32 b8 d6 | Fallimento semantico: D6B8=0. A01C non viene azzerato: ALL esaurito può lasciare128 come residuo globale.
    LD A,($A01C)                          ; $D85F 3a 1c a0 | Il modo globale decide il percorso di fallimento e rilascio. Non riempire entrambi i byte con lo stesso booleano pending.
    AND A                                 ; $D862 a7
    JR Z,$D870                            ; $D863 28 0b
    LD A,$FF                              ; $D865 3e ff
    LD ($A033),A                          ; $D867 32 33 a0
    CALL $D835                            ; $D86A cd 35 d8
    JP $DC15                              ; $D86D c3 15 dc
    LD A,$01                              ; $D870 3e 01
    LD ($D7E0),A                          ; $D872 32 e0 d7
    PUSH HL                               ; $D875 e5
    LD HL,($D6BD)                         ; $D876 2a bd d6
    LD (HL),$C0                           ; $D879 36 c0
    POP HL                                ; $D87B e1
    RET                                   ; $D87C c9
