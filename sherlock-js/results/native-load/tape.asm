; Offline cassette probe: hardware transfer tapes remain outside the autonomous game.
    ORG $C089
; CODE: The 17-byte header at C0FE covers the length C109 and address C10B.
    LD DE,($C109)                       ; $C089 ed 5b 09 c1 | 1C14 in the observed saved-game header.
    LD IX,($C10B)                       ; $C08D dd 2a 0b c1 | 840B is the destination in the saved-game header.
    LD A,$FF                            ; $C091 3e ff
    CALL $0556                          ; $C093 cd 56 05 | ROM tape transfer of the data block.
    DI                                  ; $C096 f3
    RET C                               ; $C097 d8 | A successful load returns to B0DF and then to the restart path.

    ORG $C0DF
; CODE: Prepare the tape request and read the header.
    LD ($C109),DE                       ; $C0DF ed 53 09 c1
    LD ($C10B),IX                       ; $C0E3 dd 22 0b c1
    LD HL,$C0BC                         ; $C0E7 21 bc c0
    CALL $C1CB                          ; $C0EA cd cb c1
    LD IX,$C0FE                         ; $C0ED dd 21 fe c0
    LD DE,$0011                         ; $C0F1 11 11 00
    LD A,$00                            ; $C0F4 3e 00
    AND A                               ; $C0F6 a7
    CALL $0556                          ; $C0F7 cd 56 05 | Header transfer observed at C0FE, length 17.
    JR NC,$C0ED                         ; $C0FA 30 f1
    JR $C089                            ; $C0FC 18 8b
