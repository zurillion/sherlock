; Analisi offline: tabella dati annidata, distinta dal codice lettore. Roundtrip contro il payload.

    ORG $D349
; CODE: Ricerca di coppie o triple: prima chiave e terminatoreFF
    EXX                                  ; $D349 d9 | Ingresso per coppie: stride2. TELL usaD34E, stride3.
    LD E,$02                             ; $D34A 1e 02
    JR $D351                             ; $D34C 18 03
    EXX                                  ; $D34E d9 | Ingresso per triple chiave/word. E201 parte dal primo argomento dopo il byte attore.
    LD E,$03                             ; $D34F 1e 03
    PUSH IX                              ; $D351 dd e5
    POP HL                               ; $D353 e1
    LD B,A                               ; $D354 47
    LD D,$00                             ; $D355 16 00
    LD A,(HL)                            ; $D357 7e
    CP B                                 ; $D358 b8 | La prima chiave uguale vince: prima del controlloFF. Le chiavi della tabella TELL originale sono distinte.
    JR Z,$D363                           ; $D359 28 08
    CP $FF                               ; $D35B fe ff | Se non trova la chiave, si ferma sul terminatoreFF e conserva il suo indirizzo.
    JR Z,$D363                           ; $D35D 28 04
    ADD HL,DE                            ; $D35F 19
    JP $D357                             ; $D360 c3 57 d3
    PUSH HL                              ; $D363 e5 | IX viene restituito sul record trovato o sul terminatore; nessuno store nella tabella.
    POP IX                               ; $D364 dd e1
    CP $FF                               ; $D366 fe ff
    EXX                                  ; $D368 d9
    RET                                  ; $D369 c9

    ORG $E1D8
; CODE: TELL: selezione della sezione del parlante, argomento e risposta di ripiego
    LD A,($A036)                         ; $E1D8 3a 36 a0 | Il selettore è il PARLANTE A036, non il destinatario A034.
    CALL $E207                           ; $E1DB cd 07 e2 | Selezione della prima sezione del parlante o della sezione predefinitaFE.
    JR Z,$E1FC                           ; $E1DE 28 1c
    INC IX                               ; $E1E0 dd 23 | Salta il byte del parlante: i successivi record sono triple argomento/testo.
    LD A,($A035)                         ; $E1E2 3a 35 a0 | Argomento richiesto inA035: per esempio16 what happened,17 your alibi,18 your address.
    CALL $E201                           ; $E1E5 cd 01 e2
    JR Z,$E1FC                           ; $E1E8 28 12 | Argomento assente nella sezione scelta: usa761D. NON riparte dalla sezioneFE.
    LD L,(IX+$01)                        ; $E1EA dd 6e 01 | Legge la word little-endian del testo selezionato: contenuto, non puntatore di codice.
    LD H,(IX+$02)                        ; $E1ED dd 66 02
    PUSH AF                              ; $E1F0 f5
    PUSH HL                              ; $E1F1 e5
    LD HL,$6830                          ; $E1F2 21 30 68 | 6830 è la cornice TELL con parlante, destinatario e testo come argomento.
    CALL $A59F                           ; $E1F5 cd 9f a5
    POP AF                               ; $E1F8 f1
    OR $01                               ; $E1F9 f6 01
    RET                                  ; $E1FB c9
    LD HL,$761D                          ; $E1FC 21 1d 76 | Risposta di ripiego761D quando manca il parlante/default o l’argomento nella sezione scelta.
    JR $E1F0                             ; $E1FF 18 ef
    CALL $D34E                           ; $E201 cd 4e d3 | D34E trova la prima chiave oFF; CPFF trasforma il terminatore in fallimento.
    CP $FF                               ; $E204 fe ff
    RET                                  ; $E206 c9
    LD IX,$E22A                          ; $E207 dd 21 2a e2 | Tabella annidataE22A: byte attore, triple,FF;FF globale dopo l’ultima sezione.
    CP (IX+$00)                          ; $E20B dd be 00 | Confronta l’attore PRIMA del caso specialeFE. Nel payloadFE è l’ultima sezione e intercetta i parlanti senza sezione.
    JR Z,$E1F9                           ; $E20E 28 e9
    PUSH AF                              ; $E210 f5
    LD A,(IX+$00)                        ; $E211 dd 7e 00
    CP $FE                               ; $E214 fe fe | FE è un parlante predefinito, non un argomento e non la fine della tabella.
    JR Z,$E1F8                           ; $E216 28 e0
    INC A                                ; $E218 3c | INC A distingue FF (diventa0) dagli attori ordinari.
    JR Z,$E227                           ; $E219 28 0c
    INC IX                               ; $E21B dd 23
    LD A,$FF                             ; $E21D 3e ff
    CALL $D34E                           ; $E21F cd 4e d3 | Scavalca una sezione cercando la sua chiaveFF con stride3. Non ordinare le chiavi serializzate.
    INC IX                               ; $E222 dd 23 | Passa il terminatore interno; il byte successivo è un nuovo parlante oFF globale.
    POP AF                               ; $E224 f1
    JR $E20B                             ; $E225 18 e4
    POP AF                               ; $E227 f1
    XOR A                                ; $E228 af | Nessuna sezione applicabile: ritorno falso. QuestoAF non è il byte datiE22E.
    RET                                  ; $E229 c9

    ORG $E22A
; DATA: Risposte TELL: dieci sezioni ordinate per parlante, 26 argomenti
    DEFB $08                             ; $E22A 08 | Dati immutabili:8 è il giardiniere. Tutte le sezioni vengono conservate nell’ordine originale per le letture casuali.
    DEFB $10                             ; $E22B 10 | Argomento16: what happened
    DEFW $7846                           ; $E22C 46 78 | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E22E 11 | Byte17=argomento your alibi del giardiniere, NON opcode né puntatore. La word seguente7846 seleziona la risposta. Il resolver deriva il byte dalla tabella tipizzata.
    DEFW $7846                           ; $E22F 46 78 | Testo della risposta su your alibi, word little-endian
    DEFB $07                             ; $E231 07 | Argomento7: major percival ffoulkes
    DEFW $78F8                           ; $E232 f8 78 | Testo della risposta su major percival ffoulkes, word little-endian
    DEFB $FF                             ; $E234 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $09                             ; $E235 09 | Parlante9: cook
    DEFB $10                             ; $E236 10 | Argomento16: what happened
    DEFW $794F                           ; $E237 4f 79 | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E239 11 | Argomento17: your alibi
    DEFW $794F                           ; $E23A 4f 79 | Testo della risposta su your alibi, word little-endian
    DEFB $06                             ; $E23C 06 | Argomento6: basil phipps
    DEFW $79C4                           ; $E23D c4 79 | Testo della risposta su basil phipps, word little-endian
    DEFB $FF                             ; $E23F ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $0A                             ; $E240 0a | Parlante10: maid
    DEFB $10                             ; $E241 10 | Argomento16: what happened
    DEFW $7A35                           ; $E242 35 7a | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E244 11 | Argomento17: your alibi
    DEFW $7A35                           ; $E245 35 7a | Testo della risposta su your alibi, word little-endian
    DEFB $FF                             ; $E247 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $06                             ; $E248 06 | Parlante6: basil phipps
    DEFB $10                             ; $E249 10 | Argomento16: what happened
    DEFW $7AB9                           ; $E24A b9 7a | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E24C 11 | Argomento17: your alibi
    DEFW $7AB9                           ; $E24D b9 7a | Testo della risposta su your alibi, word little-endian
    DEFB $12                             ; $E24F 12 | Argomento18: your address
    DEFW $772C                           ; $E250 2c 77 | Testo della risposta su your address, word little-endian
    DEFB $FF                             ; $E252 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $05                             ; $E253 05 | Parlante5: daphne strachan
    DEFB $10                             ; $E254 10 | Argomento16: what happened
    DEFW $7AF6                           ; $E255 f6 7a | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E257 11 | Argomento17: your alibi
    DEFW $7AF6                           ; $E258 f6 7a | Testo della risposta su your alibi, word little-endian
    DEFB $0D                             ; $E25A 0d | Argomento13: tricia fender
    DEFW $76A4                           ; $E25B a4 76 | Testo della risposta su tricia fender, word little-endian
    DEFB $07                             ; $E25D 07 | Argomento7: major percival ffoulkes
    DEFW $78D4                           ; $E25E d4 78 | Testo della risposta su major percival ffoulkes, word little-endian
    DEFB $FF                             ; $E260 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $04                             ; $E261 04 | Parlante4: chief constable straker
    DEFB $0F                             ; $E262 0f | Argomento15: case
    DEFW $7371                           ; $E263 71 73 | Testo della risposta su case, word little-endian
    DEFB $FF                             ; $E265 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $07                             ; $E266 07 | Parlante7: major percival ffoulkes
    DEFB $11                             ; $E267 11 | Argomento17: your alibi
    DEFW $780C                           ; $E268 0c 78 | Testo della risposta su your alibi, word little-endian
    DEFB $12                             ; $E26A 12 | Argomento18: your address
    DEFW $7722                           ; $E26B 22 77 | Testo della risposta su your address, word little-endian
    DEFB $FF                             ; $E26D ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $0D                             ; $E26E 0d | Parlante13: tricia fender
    DEFB $43                             ; $E26F 43 | Argomento67: bloodstained clothes
    DEFW $7687                           ; $E270 87 76 | Testo della risposta su bloodstained clothes, word little-endian
    DEFB $FF                             ; $E272 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $5F                             ; $E273 5f | Parlante95: mrs jones
    DEFB $43                             ; $E274 43 | Argomento67: bloodstained clothes
    DEFW $7687                           ; $E275 87 76 | Testo della risposta su bloodstained clothes, word little-endian
    DEFB $10                             ; $E277 10 | Argomento16: what happened
    DEFW $7644                           ; $E278 44 76 | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E27A 11 | Argomento17: your alibi
    DEFW $7644                           ; $E27B 44 76 | Testo della risposta su your alibi, word little-endian
    DEFB $0D                             ; $E27D 0d | Argomento13: tricia fender
    DEFW $762D                           ; $E27E 2d 76 | Testo della risposta su tricia fender, word little-endian
    DEFB $FF                             ; $E280 ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $FE                             ; $E281 fe | Parlante254: parlante predefinito FE
    DEFB $12                             ; $E282 12 | Argomento18: your address
    DEFW $6845                           ; $E283 45 68 | Testo della risposta su your address, word little-endian
    DEFB $10                             ; $E285 10 | Argomento16: what happened
    DEFW $6845                           ; $E286 45 68 | Testo della risposta su what happened, word little-endian
    DEFB $11                             ; $E288 11 | Argomento17: your alibi
    DEFW $6845                           ; $E289 45 68 | Testo della risposta su your alibi, word little-endian
    DEFB $FF                             ; $E28B ff | Fine degli argomenti di questa sezione; non fine globale
    DEFB $FF                             ; $E28C ff | Fine globale della tabella dei parlanti
