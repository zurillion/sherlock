; Sherlock v2.0 - entita e risoluzione semantica. Intervalli scelti, non disassemblato lineare.

    ORG $8259
; DATA fino a $840A
; 54 modelli lessicali da 8 byte + word zero. Nibble alti = metadati, non parte dell offset lessicale.
    DEFB $C3,$05,$00,$00,$00,$00,$8D,$03 ; $8259 c3 05 00 00 00 00 8d 03
    DEFB $1A,$08,$00,$00,$00,$00,$8D,$03 ; $8261 1a 08 00 00 00 00 8d 03
    DEFB $84,$02,$00,$00,$00,$00,$8D,$03 ; $8269 84 02 00 00 00 00 8d 03
    DEFB $92,$09,$00,$00,$00,$00,$8D,$03 ; $8271 92 09 00 00 00 00 8d 03
    DEFB $C7,$05,$00,$00,$00,$00,$8D,$03 ; $8279 c7 05 00 00 00 00 8d 03
    DEFB $D0,$05,$00,$00,$00,$00,$8D,$03 ; $8281 d0 05 00 00 00 00 8d 03
    DEFB $1E,$08,$00,$00,$00,$00,$8D,$03 ; $8289 1e 08 00 00 00 00 8d 03
    DEFB $27,$08,$00,$00,$00,$00,$8D,$03 ; $8291 27 08 00 00 00 00 8d 03
    DEFB $3C,$09,$00,$00,$00,$00,$8D,$03 ; $8299 3c 09 00 00 00 00 8d 03
    DEFB $72,$02,$00,$00,$00,$00,$8D,$03 ; $82A1 72 02 00 00 00 00 8d 03
    DEFB $8B,$81,$00,$00,$00,$80,$00,$40 ; $82A9 8b 81 00 00 00 80 00 40
    DEFB $B2,$81,$77,$24,$00,$00,$00,$50 ; $82B1 b2 81 77 24 00 00 00 50
    DEFB $B2,$81,$20,$26,$EC,$05,$00,$C0 ; $82B9 b2 81 20 26 ec 05 00 c0
    DEFB $B7,$81,$00,$00,$00,$00,$00,$40 ; $82C1 b7 81 00 00 00 00 00 40
    DEFB $F7,$81,$00,$00,$00,$00,$00,$40 ; $82C9 f7 81 00 00 00 00 00 40
    DEFB $7C,$82,$00,$00,$00,$80,$00,$00 ; $82D1 7c 82 00 00 00 80 00 00
    DEFB $7C,$C2,$50,$04,$00,$00,$00,$40 ; $82D9 7c c2 50 04 00 00 00 40
    DEFB $98,$82,$00,$90,$00,$00,$00,$00 ; $82E1 98 82 00 90 00 00 00 00
    DEFB $CA,$82,$00,$00,$00,$00,$00,$40 ; $82E9 ca 82 00 00 00 00 00 40
    DEFB $CA,$82,$00,$00,$00,$00,$BE,$41 ; $82F1 ca 82 00 00 00 00 be 41
    DEFB $33,$93,$00,$10,$00,$40,$00,$00 ; $82F9 33 93 00 10 00 40 00 00
    DEFB $D4,$91,$BF,$39,$00,$40,$00,$00 ; $8301 d4 91 bf 39 00 40 00 00
    DEFB $81,$83,$00,$00,$00,$00,$00,$40 ; $8309 81 83 00 00 00 00 00 40
    DEFB $81,$83,$77,$24,$00,$00,$00,$40 ; $8311 81 83 77 24 00 00 00 40
    DEFB $81,$83,$20,$26,$EC,$05,$00,$C0 ; $8319 81 83 20 26 ec 05 00 c0
    DEFB $89,$C3,$DB,$08,$00,$10,$00,$60 ; $8321 89 c3 db 08 00 10 00 60
    DEFB $8D,$83,$77,$B4,$00,$00,$00,$00 ; $8329 8d 83 77 b4 00 00 00 00
    DEFB $8D,$83,$CE,$28,$00,$00,$00,$00 ; $8331 8d 83 ce 28 00 00 00 00
    DEFB $8D,$93,$DB,$B8,$00,$00,$00,$40 ; $8339 8d 93 db b8 00 00 00 40
    DEFB $8D,$93,$DB,$B8,$00,$00,$63,$43 ; $8341 8d 93 db b8 00 00 63 43
    DEFB $BE,$93,$00,$00,$00,$00,$00,$10 ; $8349 be 93 00 00 00 00 00 10
    DEFB $F5,$03,$00,$10,$00,$00,$00,$00 ; $8351 f5 03 00 10 00 00 00 00
    DEFB $7A,$04,$00,$10,$00,$00,$00,$40 ; $8359 7a 04 00 10 00 00 00 40
    DEFB $23,$05,$00,$10,$00,$00,$00,$00 ; $8361 23 05 00 10 00 00 00 00
    DEFB $23,$85,$CE,$28,$00,$00,$00,$00 ; $8369 23 85 ce 28 00 00 00 00
    DEFB $0B,$86,$00,$00,$00,$00,$00,$40 ; $8371 0b 86 00 00 00 00 00 40
    DEFB $64,$C6,$DB,$08,$00,$D0,$00,$20 ; $8379 64 c6 db 08 00 d0 00 20
    DEFB $E8,$C6,$50,$04,$00,$00,$00,$40 ; $8381 e8 c6 50 04 00 00 00 40
    DEFB $E8,$C6,$FF,$05,$00,$00,$00,$40 ; $8389 e8 c6 ff 05 00 00 00 40
    DEFB $DD,$87,$50,$24,$00,$00,$00,$40 ; $8391 dd 87 50 24 00 00 00 40
    DEFB $87,$88,$00,$00,$00,$00,$00,$40 ; $8399 87 88 00 00 00 00 00 40
    DEFB $87,$C8,$51,$03,$00,$00,$00,$40 ; $83A1 87 c8 51 03 00 00 00 40
    DEFB $87,$98,$EF,$25,$00,$00,$00,$40 ; $83A9 87 98 ef 25 00 00 00 40
    DEFB $87,$C8,$20,$06,$EC,$05,$00,$40 ; $83B1 87 c8 20 06 ec 05 00 40
    DEFB $87,$D8,$DB,$58,$00,$40,$00,$00 ; $83B9 87 d8 db 58 00 40 00 00
    DEFB $8B,$88,$DB,$28,$00,$40,$00,$00 ; $83C1 8b 88 db 28 00 40 00 00
    DEFB $8F,$D8,$00,$10,$00,$40,$00,$00 ; $83C9 8f d8 00 10 00 40 00 00
    DEFB $8F,$D8,$05,$10,$00,$40,$00,$00 ; $83D1 8f d8 05 10 00 40 00 00
    DEFB $5E,$09,$FF,$03,$00,$00,$00,$00 ; $83D9 5e 09 ff 03 00 00 00 00
    DEFB $5E,$89,$38,$39,$00,$C0,$00,$00 ; $83E1 5e 89 38 39 00 c0 00 00
    DEFB $83,$89,$00,$00,$00,$00,$00,$40 ; $83E9 83 89 00 00 00 00 00 40
    DEFB $94,$04,$00,$00,$00,$00,$00,$00 ; $83F1 94 04 00 00 00 00 00 00
    DEFB $14,$85,$00,$00,$00,$00,$00,$40 ; $83F9 14 85 00 00 00 00 00 40
    DEFB $2B,$89,$00,$00,$00,$00,$00,$40 ; $8401 2b 89 00 00 00 00 00 40
    DEFB $00,$00                       ; $8409 00 00

    ORG $8B6F
; DATA fino a $9569
; Indice entita: triplette ID, puntatore LE. Non codice.
    DEFB $00,$BA,$8C,$01,$CB,$8C,$02,$DC ; $8B6F 00 ba 8c 01 cb 8c 02 dc
    DEFB $8C,$03,$ED,$8C,$04,$FE,$8C,$05 ; $8B77 8c 03 ed 8c 04 fe 8c 05
    DEFB $0F,$8D,$06,$20,$8D,$07,$31,$8D ; $8B7F 0f 8d 06 20 8d 07 31 8d
    DEFB $08,$42,$8D,$09,$53,$8D,$0A,$64 ; $8B87 08 42 8d 09 53 8d 0a 64
    DEFB $8D,$0B,$75,$8D,$0C,$8C,$8D,$0D ; $8B8F 8d 0b 75 8d 0c 8c 8d 0d
    DEFB $9D,$8D,$0E,$B4,$8D,$0F,$C9,$8D ; $8B97 9d 8d 0e b4 8d 0f c9 8d
    DEFB $10,$DA,$8D,$11,$EB,$8D,$12,$FC ; $8B9F 10 da 8d 11 eb 8d 12 fc
    DEFB $8D,$13,$0D,$8E,$14,$27,$8E,$15 ; $8BA7 8d 13 0d 8e 14 27 8e 15
    DEFB $3F,$8E,$16,$55,$8E,$17,$66,$8E ; $8BAF 3f 8e 16 55 8e 17 66 8e
    DEFB $18,$81,$8E,$19,$9C,$8E,$1A,$AD ; $8BB7 18 81 8e 19 9c 8e 1a ad
    DEFB $8E,$1B,$BE,$8E,$1C,$D1,$8E,$1D ; $8BBF 8e 1b be 8e 1c d1 8e 1d
    DEFB $E4,$8E,$1E,$F6,$8E,$1F,$13,$8F ; $8BC7 e4 8e 1e f6 8e 1f 13 8f
    DEFB $20,$2C,$8F,$21,$3D,$8F,$22,$5A ; $8BCF 20 2c 8f 21 3d 8f 22 5a
    DEFB $8F,$23,$73,$8F,$24,$84,$8F,$25 ; $8BD7 8f 23 73 8f 24 84 8f 25
    DEFB $9D,$8F,$26,$B6,$8F,$27,$CF,$8F ; $8BDF 9d 8f 26 b6 8f 27 cf 8f
    DEFB $28,$E8,$8F,$29,$01,$90,$2A,$1A ; $8BE7 28 e8 8f 29 01 90 2a 1a
    DEFB $90,$2B,$33,$90,$2C,$4C,$90,$2D ; $8BEF 90 2b 33 90 2c 4c 90 2d
    DEFB $5E,$90,$2E,$76,$90,$2F,$87,$90 ; $8BF7 5e 90 2e 76 90 2f 87 90
    DEFB $30,$98,$90,$31,$B2,$90,$32,$CC ; $8BFF 30 98 90 31 b2 90 32 cc
    DEFB $90,$33,$EA,$90,$34,$02,$91,$35 ; $8C07 90 33 ea 90 34 02 91 35
    DEFB $18,$91,$36,$2E,$91,$37,$44,$91 ; $8C0F 18 91 36 2e 91 37 44 91
    DEFB $38,$60,$91,$39,$76,$91,$3A,$88 ; $8C17 38 60 91 39 76 91 3a 88
    DEFB $91,$3B,$9A,$91,$3C,$B2,$91,$3D ; $8C1F 91 3b 9a 91 3c b2 91 3d
    DEFB $CD,$91,$3E,$DE,$91,$3F,$F5,$91 ; $8C27 cd 91 3e de 91 3f f5 91
    DEFB $40,$0A,$92,$41,$1B,$92,$42,$2C ; $8C2F 40 0a 92 41 1b 92 42 2c
    DEFB $92,$43,$40,$92,$44,$51,$92,$45 ; $8C37 92 43 40 92 44 51 92 45
    DEFB $67,$92,$46,$7F,$92,$47,$95,$92 ; $8C3F 67 92 46 7f 92 47 95 92
    DEFB $48,$A6,$92,$49,$B7,$92,$4A,$CD ; $8C47 48 a6 92 49 b7 92 4a cd
    DEFB $92,$4B,$E5,$92,$4C,$F7,$92,$4D ; $8C4F 92 4b e5 92 4c f7 92 4d
    DEFB $08,$93,$4E,$19,$93,$4F,$2A,$93 ; $8C57 08 93 4e 19 93 4f 2a 93
    DEFB $50,$40,$93,$51,$53,$93,$52,$64 ; $8C5F 50 40 93 51 53 93 52 64
    DEFB $93,$53,$75,$93,$54,$86,$93,$55 ; $8C67 93 53 75 93 54 86 93 55
    DEFB $97,$93,$56,$AE,$93,$57,$C3,$93 ; $8C6F 97 93 56 ae 93 57 c3 93
    DEFB $58,$D4,$93,$59,$E5,$93,$5A,$FA ; $8C77 58 d4 93 59 e5 93 5a fa
    DEFB $93,$5B,$0B,$94,$5C,$21,$94,$5D ; $8C7F 93 5b 0b 94 5c 21 94 5d
    DEFB $32,$94,$5E,$43,$94,$5F,$54,$94 ; $8C87 32 94 5e 43 94 5f 54 94
    DEFB $60,$6B,$94,$61,$7C,$94,$62,$8D ; $8C8F 60 6b 94 61 7c 94 62 8d
    DEFB $94,$63,$9E,$94,$64,$AF,$94,$65 ; $8C97 94 63 9e 94 64 af 94 65
    DEFB $C0,$94,$66,$D5,$94,$67,$E6,$94 ; $8C9F c0 94 66 d5 94 67 e6 94
    DEFB $68,$FC,$94,$69,$0D,$95,$6A,$1E ; $8CA7 68 fc 94 69 0d 95 6a 1e
    DEFB $95,$6B,$2F,$95,$6C,$40,$95,$6D ; $8CAF 95 6b 2f 95 6c 40 95 6d
    DEFB $51,$95                       ; $8CB7 51 95
; Sentinella FF della tabella indice.
    DEFB $FF                           ; $8CB9 ff
; Entita 0 ($00): you; 17 byte.
    DEFB $01,$FF,$60,$40,$90,$E0,$00,$EE ; $8CBA 01 ff 60 40 90 e0 00 ee
    DEFB $89,$00,$00,$00,$00,$00,$00,$08 ; $8CC2 89 00 00 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8CCA ff
; Entita 1 ($01): china man; 17 byte.
    DEFB $01,$FF,$50,$40,$A0,$E0,$00,$46 ; $8CCB 01 ff 50 40 a0 e0 00 46
    DEFB $05,$A2,$01,$00,$00,$00,$00,$00 ; $8CD3 05 a2 01 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8CDB ff
; Entita 2 ($02): inspector lestrade; 17 byte.
    DEFB $01,$FF,$20,$20,$10,$E0,$00,$DC ; $8CDC 01 ff 20 20 10 e0 00 dc
    DEFB $84,$6B,$04,$00,$00,$00,$00,$0B ; $8CE4 84 6b 04 00 00 00 00 0b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8CEC ff
; Entita 3 ($03): watson; 17 byte.
    DEFB $01,$18,$60,$40,$10,$E0,$00,$71 ; $8CED 01 18 60 40 10 e0 00 71
    DEFB $89,$00,$00,$00,$00,$00,$00,$08 ; $8CF5 89 00 00 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8CFD ff
; Entita 4 ($04): chief constable straker; 17 byte.
    DEFB $01,$FF,$40,$50,$10,$E0,$00,$55 ; $8CFE 01 ff 40 50 10 e0 00 55
    DEFB $88,$9E,$01,$D8,$01,$00,$00,$35 ; $8D06 88 9e 01 d8 01 00 00 35
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D0E ff
; Entita 5 ($05): daphne strachan; 17 byte.
    DEFB $01,$FF,$08,$30,$40,$E0,$00,$4F ; $8D0F 01 ff 08 30 40 e0 00 4f
    DEFB $88,$00,$00,$16,$02,$00,$00,$43 ; $8D17 88 00 00 16 02 00 00 43
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D1F ff
; Entita 6 ($06): basil phipps; 17 byte.
    DEFB $01,$FF,$15,$35,$40,$E0,$00,$7C ; $8D20 01 ff 15 35 40 e0 00 7c
    DEFB $86,$00,$00,$B9,$00,$00,$00,$43 ; $8D28 86 00 00 b9 00 00 00 43
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D30 ff
; Entita 7 ($07): major percival ffoulkes; 17 byte.
    DEFB $01,$FF,$40,$70,$40,$E0,$00,$0A ; $8D31 01 ff 40 70 40 e0 00 0a
    DEFB $83,$42,$05,$6D,$06,$00,$00,$00 ; $8D39 83 42 05 6d 06 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D41 ff
; Entita 8 ($08): gardener; 17 byte.
    DEFB $01,$FF,$15,$50,$40,$E0,$00,$70 ; $8D42 01 ff 15 50 40 e0 00 70
    DEFB $03,$00,$00,$00,$00,$00,$00,$41 ; $8D4A 03 00 00 00 00 00 00 41
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D52 ff
; Entita 9 ($09): cook; 17 byte.
    DEFB $01,$FF,$12,$45,$40,$E0,$00,$DF ; $8D53 01 ff 12 45 40 e0 00 df
    DEFB $01,$00,$00,$00,$00,$00,$00,$41 ; $8D5B 01 00 00 00 00 00 00 41
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D63 ff
; Entita 10 ($0A): maid; 17 byte.
    DEFB $01,$FF,$12,$45,$40,$E0,$00,$3B ; $8D64 01 ff 12 45 40 e0 00 3b
    DEFB $05,$00,$00,$00,$00,$00,$00,$41 ; $8D6C 05 00 00 00 00 00 00 41
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D74 ff
; Entita 11 ($0B): local police man; 23 byte.
    DEFB $01,$FF,$45,$50,$10,$E0,$00,$46 ; $8D75 01 ff 45 50 10 e0 00 46
    DEFB $15,$0B,$05,$B5,$06,$00,$00,$5C ; $8D7D 15 0b 05 b5 06 00 00 5c
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $00,$00,$1D,$01,$1E,$02,$FF   ; $8D85 00 00 1d 01 1e 02 ff
; Entita 12 ($0C): local police man; 17 byte.
    DEFB $01,$FF,$45,$50,$10,$E0,$00,$46 ; $8D8C 01 ff 45 50 10 e0 00 46
    DEFB $15,$0B,$05,$B5,$06,$00,$00,$3E ; $8D94 15 0b 05 b5 06 00 00 3e
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8D9C ff
; Entita 13 ($0D): tricia fender; 23 byte.
    DEFB $01,$FF,$20,$30,$10,$E0,$00,$02 ; $8D9D 01 ff 20 30 10 e0 00 02
    DEFB $83,$F9,$08,$00,$00,$00,$00,$00 ; $8DA5 83 f9 08 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $00,$00,$30,$03,$2F,$03,$FF   ; $8DAD 00 00 30 03 2f 03 ff
; Entita 14 ($0E): china mans disguise; 21 byte.
    DEFB $01,$FF,$80,$30,$00,$A0,$00,$59 ; $8DB4 01 ff 80 30 00 a0 00 59
    DEFB $12,$A2,$01,$49,$05,$00,$00,$09 ; $8DBC 12 a2 01 49 05 00 00 09
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $33,$04,$2B,$05,$FF           ; $8DC4 33 04 2b 05 ff
; Entita 15 ($0F): case; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$91 ; $8DC9 01 ff 00 00 00 80 00 91
    DEFB $01,$00,$00,$00,$00,$00,$00,$00 ; $8DD1 01 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8DD9 ff
; Entita 16 ($10): what happened; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$D2 ; $8DDA 01 ff 00 00 00 80 00 d2
    DEFB $83,$96,$09,$00,$00,$00,$00,$00 ; $8DE2 83 96 09 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8DEA ff
; Entita 17 ($11): your alibi; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$38 ; $8DEB 01 ff 00 00 00 80 00 38
    DEFB $80,$F2,$09,$00,$00,$00,$00,$00 ; $8DF3 80 f2 09 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8DFB ff
; Entita 18 ($12): your address; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$18 ; $8DFC 01 ff 00 00 00 80 00 18
    DEFB $80,$F2,$09,$00,$00,$00,$00,$00 ; $8E04 80 f2 09 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8E0C ff
; Entita 19 ($13): front door; 26 byte.
    DEFB $06,$FF,$FF,$FF,$00,$80,$00,$6E ; $8E0D 06 ff ff ff 00 80 00 6e
    DEFB $02,$55,$03,$00,$00,$00,$00,$05 ; $8E15 02 55 03 00 00 00 00 05
    DEFB $06,$5D,$60,$33,$38           ; $8E1D 06 5d 60 33 38
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $8E22 24 06 0e 07 ff
; Entita 20 ($14): stairway; 24 byte.
    DEFB $08,$FF,$FF,$FF,$00,$A0,$00,$37 ; $8E27 08 ff ff ff 00 a0 00 37
    DEFB $08,$00,$00,$00,$00,$00,$00,$06 ; $8E2F 08 00 00 00 00 00 00 06
    DEFB $07,$60,$64,$29,$2B,$38,$3D   ; $8E37 07 60 64 29 2b 38 3d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8E3E ff
; Entita 21 ($15): your door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $8E3F 02 ff ff ff 00 80 00 6e
    DEFB $82,$F2,$09,$00,$00,$00,$00,$07 ; $8E47 82 f2 09 00 00 00 00 07
    DEFB $08                           ; $8E4F 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $8E50 24 06 0e 07 ff
; Entita 22 ($16): oil lamp; 17 byte.
    DEFB $01,$FF,$20,$20,$80,$94,$00,$B9 ; $8E55 01 ff 20 20 80 94 00 b9
    DEFB $24,$F7,$05,$00,$00,$00,$00,$08 ; $8E5D 24 f7 05 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8E65 ff
; Entita 23 ($17): your armchair; 27 byte.
    DEFB $01,$FF,$FF,$FF,$01,$A0,$00,$7E ; $8E66 01 ff ff ff 01 a0 00 7e
    DEFB $80,$F2,$09,$00,$00,$00,$00,$08 ; $8E6E 80 f2 09 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8E76 0d 08 0c 09 19 08 18 09
    DEFB $28,$09,$FF                   ; $8E7E 28 09 ff
; Entita 24 ($18): watsons armchair; 27 byte.
    DEFB $01,$FF,$FF,$FF,$01,$A0,$00,$7E ; $8E81 01 ff ff ff 01 a0 00 7e
    DEFB $80,$75,$09,$00,$00,$00,$00,$08 ; $8E89 80 75 09 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8E91 0d 08 0c 09 19 08 18 09
    DEFB $28,$09,$FF                   ; $8E99 28 09 ff
; Entita 25 ($19): daily chronicle; 17 byte.
    DEFB $01,$03,$01,$01,$00,$80,$00,$AB ; $8E9C 01 03 01 01 00 80 00 ab
    DEFB $01,$11,$02,$00,$00,$00,$00,$08 ; $8EA4 01 11 02 00 00 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8EAC ff
; Entita 26 ($1A): note; 17 byte.
    DEFB $01,$FF,$01,$01,$00,$80,$00,$D8 ; $8EAD 01 ff 01 01 00 80 00 d8
    DEFB $15,$00,$00,$00,$00,$7A,$80,$00 ; $8EB5 15 00 00 00 00 7a 80 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8EBD ff
; Entita 27 ($1B): your money; 19 byte.
    DEFB $01,$00,$05,$05,$00,$80,$20,$75 ; $8EBE 01 00 05 05 00 80 20 75
    DEFB $85,$60,$09,$F2,$09,$00,$00,$08 ; $8EC6 85 60 09 f2 09 00 00 08
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0F,$0A,$FF                   ; $8ECE 0f 0a ff
; Entita 28 ($1C): money; 19 byte.
    DEFB $01,$02,$05,$05,$00,$80,$20,$75 ; $8ED1 01 02 05 05 00 80 20 75
    DEFB $35,$60,$09,$00,$00,$00,$00,$0B ; $8ED9 35 60 09 00 00 00 00 0b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0F,$0A,$FF                   ; $8EE1 0f 0a ff
; Entita 29 ($1D): hidden door; 18 byte.
    DEFB $02,$FF,$55,$FF,$00,$A0,$00,$6E ; $8EE4 02 ff 55 ff 00 a0 00 6e
    DEFB $12,$0D,$04,$00,$00,$00,$00,$0C ; $8EEC 12 0d 04 00 00 00 00 0c
    DEFB $0D                           ; $8EF4 0d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8EF5 ff
; Entita 30 ($1E): hansom cab; 29 byte.
    DEFB $01,$FF,$FF,$80,$81,$B4,$00,$64 ; $8EF6 01 ff ff 80 81 b4 00 64
    DEFB $11,$CE,$03,$00,$00,$00,$00,$00 ; $8EFE 11 ce 03 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $17,$0B,$1F,$0B,$0D,$08,$0C,$0C ; $8F06 17 0b 1f 0b 0d 08 0c 0c
    DEFB $19,$08,$18,$0C,$FF           ; $8F0E 19 08 18 0c ff
; Entita 31 ($1F): cabbie; 25 byte.
    DEFB $01,$1E,$10,$40,$80,$C0,$00,$68 ; $8F13 01 1e 10 40 80 c0 00 68
    DEFB $01,$00,$00,$00,$00,$00,$00,$00 ; $8F1B 01 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $00,$00,$2D,$0D,$1D,$0E,$1E,$0F ; $8F23 00 00 2d 0d 1d 0e 1e 0f
    DEFB $FF                           ; $8F2B ff
; Entita 32 ($20): money; 17 byte.
    DEFB $01,$1F,$05,$05,$00,$80,$20,$75 ; $8F2C 01 1f 05 05 00 80 20 75
    DEFB $35,$00,$00,$00,$00,$00,$00,$00 ; $8F34 35 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8F3C ff
; Entita 33 ($21): hansom cab; 29 byte.
    DEFB $01,$FF,$FF,$80,$81,$B4,$00,$64 ; $8F3D 01 ff ff 80 81 b4 00 64
    DEFB $11,$CE,$03,$00,$00,$00,$00,$00 ; $8F45 11 ce 03 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $17,$0B,$1F,$0B,$0D,$08,$0C,$0C ; $8F4D 17 0b 1f 0b 0d 08 0c 0c
    DEFB $19,$08,$18,$0C,$FF           ; $8F55 19 08 18 0c ff
; Entita 34 ($22): cabbie; 25 byte.
    DEFB $01,$21,$10,$40,$80,$C0,$00,$68 ; $8F5A 01 21 10 40 80 c0 00 68
    DEFB $01,$00,$00,$00,$00,$00,$00,$00 ; $8F62 01 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $00,$00,$2D,$0D,$1D,$0E,$1E,$0F ; $8F6A 00 00 2d 0d 1d 0e 1e 0f
    DEFB $FF                           ; $8F72 ff
; Entita 35 ($23): money; 17 byte.
    DEFB $01,$22,$05,$05,$00,$80,$20,$75 ; $8F73 01 22 05 05 00 80 20 75
    DEFB $35,$00,$00,$00,$00,$00,$00,$00 ; $8F7B 35 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $8F83 ff
; Entita 36 ($24): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $8F84 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $8F8C 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8F94 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $8F9C ff
; Entita 37 ($25): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $8F9D 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $8FA5 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8FAD 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $8FB5 ff
; Entita 38 ($26): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $8FB6 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $8FBE 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8FC6 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $8FCE ff
; Entita 39 ($27): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $8FCF 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $8FD7 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8FDF 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $8FE7 ff
; Entita 40 ($28): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $8FE8 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $8FF0 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $8FF8 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $9000 ff
; Entita 41 ($29): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $9001 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$02 ; $9009 18 4c 08 00 00 00 00 02
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $9011 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $9019 ff
; Entita 42 ($2A): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $901A 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$03 ; $9022 18 4c 08 00 00 00 00 03
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $902A 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $9032 ff
; Entita 43 ($2B): steam train; 25 byte.
    DEFB $01,$FF,$FF,$FF,$81,$34,$00,$EB ; $9033 01 ff ff ff 81 34 00 eb
    DEFB $18,$4C,$08,$00,$00,$00,$00,$03 ; $903B 18 4c 08 00 00 00 00 03
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $9043 0d 08 0c 09 19 08 18 09
    DEFB $FF                           ; $904B ff
; Entita 44 ($2C): wide stairway; 18 byte.
    DEFB $02,$FF,$FF,$FF,$00,$A0,$00,$37 ; $904C 02 ff ff ff 00 a0 00 37
    DEFB $18,$A9,$09,$00,$00,$00,$00,$40 ; $9054 18 a9 09 00 00 00 00 40
    DEFB $45                           ; $905C 45
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $905D ff
; Entita 45 ($2D): large oak door; 24 byte.
    DEFB $04,$FF,$FF,$FF,$00,$80,$00,$6E ; $905E 04 ff ff ff 00 80 00 6e
    DEFB $12,$C1,$04,$E8,$05,$00,$00,$3F ; $9066 12 c1 04 e8 05 00 00 3f
    DEFB $40,$23,$21                   ; $906E 40 23 21
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9071 24 06 0e 07 ff
; Entita 46 ($2E): female corpse; 17 byte.
    DEFB $01,$FF,$10,$40,$02,$A0,$00,$E8 ; $9076 01 ff 10 40 02 a0 00 e8
    DEFB $11,$FD,$02,$00,$00,$F5,$81,$58 ; $907E 11 fd 02 00 00 f5 81 58
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9086 ff
; Entita 47 ($2F): crumpled note; 17 byte.
    DEFB $01,$2E,$01,$00,$00,$80,$00,$D8 ; $9087 01 2e 01 00 00 80 00 d8
    DEFB $15,$04,$02,$00,$00,$20,$82,$58 ; $908F 15 04 02 00 00 20 82 58
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9097 ff
; Entita 48 ($30): heavy oak door; 26 byte.
    DEFB $06,$FF,$FF,$FF,$00,$80,$00,$6E ; $9098 06 ff ff ff 00 80 00 6e
    DEFB $12,$ED,$03,$E8,$05,$00,$00,$40 ; $90A0 12 ed 03 e8 05 00 00 40
    DEFB $43,$28,$29,$2B,$2C           ; $90A8 43 28 29 2b 2c
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $90AD 24 06 0e 07 ff
; Entita 49 ($31): diningroom door; 26 byte.
    DEFB $06,$FF,$FF,$FF,$00,$80,$00,$6E ; $90B2 06 ff ff ff 00 80 00 6e
    DEFB $02,$54,$02,$00,$00,$00,$00,$43 ; $90BA 02 54 02 00 00 00 00 43
    DEFB $44,$60,$63,$22,$25           ; $90C2 44 60 63 22 25
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $90C7 24 06 0e 07 ff
; Entita 50 ($32): plain door; 30 byte.
    DEFB $0A,$FF,$FF,$FF,$00,$80,$00,$6E ; $90CC 0a ff ff ff 00 80 00 6e
    DEFB $12,$99,$06,$00,$00,$00,$00,$41 ; $90D4 12 99 06 00 00 00 00 41
    DEFB $44,$62,$63,$22,$24,$08,$09,$39 ; $90DC 44 62 63 22 24 08 09 39
    DEFB $3B                           ; $90E4 3b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $90E5 24 06 0e 07 ff
; Entita 51 ($33): ornate door; 24 byte.
    DEFB $04,$FF,$FF,$FF,$00,$80,$00,$6E ; $90EA 04 ff ff ff 00 80 00 6e
    DEFB $22,$16,$06,$00,$00,$00,$00,$49 ; $90F2 22 16 06 00 00 00 00 49
    DEFB $46,$2F,$31                   ; $90FA 46 2f 31
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $90FD 24 06 0e 07 ff
; Entita 52 ($34): daphnes door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $9102 02 ff ff ff 00 80 00 6e
    DEFB $82,$1B,$02,$00,$00,$00,$00,$4A ; $910A 82 1b 02 00 00 00 00 4a
    DEFB $45                           ; $9112 45
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9113 24 06 0e 07 ff
; Entita 53 ($35): bedroom door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $9118 02 ff ff ff 00 80 00 6e
    DEFB $02,$CE,$00,$00,$00,$00,$00,$4B ; $9120 02 ce 00 00 00 00 00 4b
    DEFB $46                           ; $9128 46
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9129 24 06 0e 07 ff
; Entita 54 ($36): wooden door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $912E 02 ff ff ff 00 80 00 6e
    DEFB $02,$CE,$09,$00,$00,$00,$00,$48 ; $9136 02 ce 09 00 00 00 00 48
    DEFB $45                           ; $913E 45
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $913F 24 06 0e 07 ff
; Entita 55 ($37): thick heavy door; 28 byte.
    DEFB $08,$FF,$FF,$FF,$00,$80,$00,$6E ; $9144 08 ff ff ff 00 80 00 6e
    DEFB $02,$B9,$08,$ED,$03,$00,$00,$46 ; $914C 02 b9 08 ed 03 00 00 46
    DEFB $47,$2A,$29,$26,$22,$2E,$2F   ; $9154 47 2a 29 26 22 2e 2f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $915B 24 06 0e 07 ff
; Entita 56 ($38): side door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $9160 02 ff ff ff 00 80 00 6e
    DEFB $02,$BE,$07,$00,$00,$00,$00,$48 ; $9168 02 be 07 00 00 00 00 48
    DEFB $49                           ; $9170 49
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9171 24 06 0e 07 ff
; Entita 57 ($39): sandstone bridge; 18 byte.
    DEFB $02,$FF,$FF,$FF,$02,$A0,$00,$30 ; $9176 02 ff ff ff 02 a0 00 30
    DEFB $11,$6A,$07,$00,$00,$00,$00,$58 ; $917E 11 6a 07 00 00 00 00 58
    DEFB $59                           ; $9186 59
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9187 ff
; Entita 58 ($3A): footbridge; 18 byte.
    DEFB $02,$FF,$FF,$FF,$02,$A0,$00,$37 ; $9188 02 ff ff ff 02 a0 00 37
    DEFB $13,$00,$00,$00,$00,$00,$00,$5A ; $9190 13 00 00 00 00 00 00 5a
    DEFB $5B                           ; $9198 5b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9199 ff
; Entita 59 ($3B): deep stream; 24 byte.
    DEFB $06,$FF,$0F,$0F,$00,$86,$00,$5D ; $919A 06 ff 0f 0f 00 86 00 5d
    DEFB $18,$2D,$02,$00,$00,$00,$00,$58 ; $91A2 18 2d 02 00 00 00 00 58
    DEFB $59,$5B,$5A,$4F,$57           ; $91AA 59 5b 5a 4f 57
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $14,$10,$FF                   ; $91AF 14 10 ff
; Entita 60 ($3C): plush sofa; 27 byte.
    DEFB $01,$FF,$FF,$FF,$02,$A0,$00,$FC ; $91B2 01 ff ff ff 02 a0 00 fc
    DEFB $17,$AD,$06,$00,$00,$00,$00,$43 ; $91BA 17 ad 06 00 00 00 00 43
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$09,$19,$08,$18,$09 ; $91C2 0d 08 0c 09 19 08 18 09
    DEFB $28,$09,$FF                   ; $91CA 28 09 ff
; Entita 61 ($3D): large desk; 17 byte.
    DEFB $01,$FF,$FF,$FF,$01,$A0,$00,$34 ; $91CD 01 ff ff ff 01 a0 00 34
    DEFB $12,$C1,$04,$00,$00,$F9,$7F,$48 ; $91D5 12 c1 04 00 00 f9 7f 48
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $91DD ff
; Entita 62 ($3E): drawer; 23 byte.
    DEFB $01,$3D,$80,$FF,$01,$80,$00,$76 ; $91DE 01 3d 80 ff 01 80 00 76
    DEFB $02,$00,$00,$00,$00,$00,$00,$48 ; $91E6 02 00 00 00 00 00 00 48
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$14,$11,$FF   ; $91EE 24 06 0e 07 14 11 ff
; Entita 63 ($3F): false bottom; 21 byte.
    DEFB $01,$3E,$40,$FF,$04,$00,$00,$24 ; $91F5 01 3e 40 ff 04 00 00 24
    DEFB $11,$E5,$02,$00,$00,$00,$00,$48 ; $91FD 11 e5 02 00 00 00 00 48
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9205 24 06 0e 07 ff
; Entita 64 ($40): bank account book; 17 byte.
    DEFB $01,$3F,$02,$02,$00,$80,$00,$1B ; $920A 01 3f 02 02 00 80 00 1b
    DEFB $11,$AF,$00,$0E,$00,$1D,$80,$48 ; $9212 11 af 00 0e 00 1d 80 48
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $921A ff
; Entita 65 ($41): note; 17 byte.
    DEFB $01,$3F,$02,$02,$00,$80,$00,$D8 ; $921B 01 3f 02 02 00 80 00 d8
    DEFB $15,$00,$00,$00,$00,$B7,$81,$48 ; $9223 15 00 00 00 00 b7 81 48
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $922B ff
; Entita 66 ($42): bookcase; 20 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$1F ; $922C 02 ff ff ff 00 80 00 1f
    DEFB $11,$00,$00,$00,$00,$00,$00,$5E ; $9234 11 00 00 00 00 00 00 5e
    DEFB $5F                           ; $923C 5f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $14,$12,$FF                   ; $923D 14 12 ff
; Entita 67 ($43): bloodstained clothes; 17 byte.
    DEFB $01,$FF,$10,$10,$00,$80,$00,$C5 ; $9240 01 ff 10 10 00 80 00 c5
    DEFB $31,$09,$01,$00,$00,$77,$7F,$5F ; $9248 31 09 01 00 00 77 7f 5f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9250 ff
; Entita 68 ($44): solid door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $9251 02 ff ff ff 00 80 00 6e
    DEFB $12,$03,$08,$00,$00,$00,$00,$5E ; $9259 12 03 08 00 00 00 00 5e
    DEFB $61                           ; $9261 61
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9262 24 06 0e 07 ff
; Entita 69 ($45): sittingroom door; 24 byte.
    DEFB $04,$FF,$FF,$FF,$00,$80,$00,$6E ; $9267 04 ff ff ff 00 80 00 6e
    DEFB $02,$E5,$07,$00,$00,$00,$00,$61 ; $926F 02 e5 07 00 00 00 00 61
    DEFB $60,$38,$39                   ; $9277 60 38 39
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $927A 24 06 0e 07 ff
; Entita 70 ($46): northern door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$6E ; $927F 02 ff ff ff 00 80 00 6e
    DEFB $02,$CC,$05,$00,$00,$00,$00,$64 ; $9287 02 cc 05 00 00 00 00 64
    DEFB $65                           ; $928F 65
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $9290 24 06 0e 07 ff
; Entita 71 ($47): bloodstained sofa; 17 byte.
    DEFB $01,$FF,$FF,$FF,$02,$A0,$00,$FC ; $9295 01 ff ff ff 02 a0 00 fc
    DEFB $17,$09,$01,$00,$00,$00,$00,$5E ; $929D 17 09 01 00 00 00 00 5e
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $92A5 ff
; Entita 72 ($48): body; 17 byte.
    DEFB $01,$47,$40,$40,$02,$A0,$00,$17 ; $92A6 01 47 40 40 02 a0 00 17
    DEFB $11,$00,$00,$00,$00,$27,$82,$5E ; $92AE 11 00 00 00 00 27 82 5e
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $92B6 ff
; Entita 73 ($49): back gate; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$77 ; $92B7 02 ff ff ff 00 80 00 77
    DEFB $03,$A7,$00,$00,$00,$00,$00,$3C ; $92BF 03 a7 00 00 00 00 00 3c
    DEFB $34                           ; $92C7 34
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $92C8 24 06 0e 07 ff
; Entita 74 ($4A): back door; 24 byte.
    DEFB $04,$FF,$FF,$FF,$00,$80,$00,$6E ; $92CD 04 ff ff ff 00 80 00 6e
    DEFB $02,$A7,$00,$00,$00,$00,$00,$27 ; $92D5 02 a7 00 00 00 00 00 27
    DEFB $24,$3C,$3B                   ; $92DD 24 3c 3b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $92E0 24 06 0e 07 ff
; Entita 75 ($4B): thick hedge; 18 byte.
    DEFB $02,$FF,$FF,$FF,$00,$80,$00,$F1 ; $92E5 02 ff ff ff 00 80 00 f1
    DEFB $13,$B9,$08,$00,$00,$00,$00,$34 ; $92ED 13 b9 08 00 00 00 00 34
    DEFB $51                           ; $92F5 51
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $92F6 ff
; Entita 76 ($4C): basils bed; 17 byte.
    DEFB $01,$FF,$FF,$FF,$02,$A0,$00,$CB ; $92F7 01 ff ff ff 02 a0 00 cb
    DEFB $80,$BD,$00,$00,$00,$89,$7F,$3D ; $92FF 80 bd 00 00 00 89 7f 3d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9307 ff
; Entita 77 ($4D): basils piano; 17 byte.
    DEFB $01,$FF,$FF,$FF,$00,$A0,$00,$82 ; $9308 01 ff ff ff 00 a0 00 82
    DEFB $86,$BD,$00,$00,$00,$A2,$7F,$3D ; $9310 86 bd 00 00 00 a2 7f 3d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9318 ff
; Entita 78 ($4E): gramaphone; 17 byte.
    DEFB $01,$FF,$FF,$FF,$00,$A0,$00,$9D ; $9319 01 ff ff ff 00 a0 00 9d
    DEFB $13,$00,$00,$00,$00,$B2,$7F,$3D ; $9321 13 00 00 00 00 b2 7f 3d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9329 ff
; Entita 79 ($4F): window; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$81,$00,$BB ; $932A 02 ff ff ff 00 81 00 bb
    DEFB $09,$00,$00,$00,$00,$00,$00,$23 ; $9332 09 00 00 00 00 00 00 23
    DEFB $66                           ; $933A 66
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $933B 24 06 0e 07 ff
; Entita 80 ($50): trash pile; 19 byte.
    DEFB $01,$FF,$FF,$FF,$01,$A0,$00,$91 ; $9340 01 ff ff ff 01 a0 00 91
    DEFB $16,$F0,$08,$00,$00,$00,$00,$27 ; $9348 16 f0 08 00 00 00 00 27
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $14,$13,$FF                   ; $9350 14 13 ff
; Entita 81 ($51): torn coded note; 17 byte.
    DEFB $01,$50,$01,$01,$00,$00,$00,$D8 ; $9353 01 50 01 01 00 00 00 d8
    DEFB $15,$E7,$08,$D0,$01,$F8,$80,$27 ; $935B 15 e7 08 d0 01 f8 80 27
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9363 ff
; Entita 82 ($52): small rubbish bin; 17 byte.
    DEFB $01,$FF,$FF,$20,$01,$A0,$00,$F1 ; $9364 01 ff ff 20 01 a0 00 f1
    DEFB $10,$F4,$07,$4B,$07,$00,$00,$26 ; $936C 10 f4 07 4b 07 00 00 26
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9374 ff
; Entita 83 ($53): ripped coded note; 17 byte.
    DEFB $01,$52,$01,$01,$00,$80,$00,$D8 ; $9375 01 52 01 01 00 80 00 d8
    DEFB $15,$36,$07,$D0,$01,$AB,$80,$26 ; $937D 15 36 07 d0 01 ab 80 26
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9385 ff
; Entita 84 ($54): fireplace; 17 byte.
    DEFB $01,$FF,$FF,$FF,$01,$A0,$00,$19 ; $9386 01 ff ff ff 01 a0 00 19
    DEFB $03,$00,$00,$00,$00,$00,$00,$23 ; $938E 03 00 00 00 00 00 00 23
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9396 ff
; Entita 85 ($55): burning note; 23 byte.
    DEFB $01,$54,$01,$01,$00,$20,$00,$D8 ; $9397 01 54 01 01 00 20 00 d8
    DEFB $15,$57,$01,$00,$00,$58,$81,$23 ; $939F 15 57 01 00 00 58 81 23
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $29,$14,$17,$14,$2C,$14,$FF   ; $93A7 29 14 17 14 2c 14 ff
; Entita 86 ($56): wall safe; 21 byte.
    DEFB $01,$FF,$30,$FF,$01,$80,$00,$5E ; $93AE 01 ff 30 ff 01 80 00 5e
    DEFB $17,$62,$09,$00,$00,$00,$00,$2F ; $93B6 17 62 09 00 00 00 00 2f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$15,$0E,$07,$FF           ; $93BE 24 15 0e 07 ff
; Entita 87 ($57): unfinished note; 17 byte.
    DEFB $01,$56,$10,$10,$00,$80,$00,$D8 ; $93C3 01 56 10 10 00 80 00 d8
    DEFB $25,$1D,$09,$00,$00,$C5,$7F,$2F ; $93CB 25 1d 09 00 00 c5 7f 2f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $93D3 ff
; Entita 88 ($58): folder; 17 byte.
    DEFB $01,$56,$20,$10,$00,$A0,$00,$2D ; $93D4 01 56 20 10 00 a0 00 2d
    DEFB $13,$00,$00,$00,$00,$DA,$7F,$2F ; $93DC 13 00 00 00 00 da 7f 2f
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $93E4 ff
; Entita 89 ($59): wall safe; 21 byte.
    DEFB $01,$FF,$20,$FF,$01,$80,$00,$5E ; $93E5 01 ff 20 ff 01 80 00 5e
    DEFB $17,$62,$09,$00,$00,$00,$00,$3A ; $93ED 17 62 09 00 00 00 00 3a
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$15,$0E,$07,$FF           ; $93F5 24 15 0e 07 ff
; Entita 90 ($5A): letters; 17 byte.
    DEFB $01,$59,$02,$05,$00,$80,$00,$E5 ; $93FA 01 59 02 05 00 80 00 e5
    DEFB $34,$00,$00,$00,$00,$61,$7F,$3A ; $9402 34 00 00 00 00 61 7f 3a
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $940A ff
; Entita 91 ($5B): front door; 22 byte.
    DEFB $02,$FF,$20,$FF,$00,$81,$00,$6E ; $940B 02 ff 20 ff 00 81 00 6e
    DEFB $02,$55,$03,$00,$00,$00,$00,$20 ; $9413 02 55 03 00 00 00 00 20
    DEFB $21                           ; $941B 21
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $941C 24 06 0e 07 ff
; Entita 92 ($5C): gun; 17 byte.
    DEFB $01,$5D,$02,$05,$00,$A0,$00,$B4 ; $9421 01 5d 02 05 00 a0 00 b4
    DEFB $13,$00,$00,$00,$00,$00,$00,$0B ; $9429 13 00 00 00 00 00 00 0b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9431 ff
; Entita 93 ($5D): large rock; 17 byte.
    DEFB $01,$02,$02,$05,$05,$20,$00,$43 ; $9432 01 02 02 05 05 20 00 43
    DEFB $17,$C1,$04,$00,$00,$00,$00,$0B ; $943A 17 c1 04 00 00 00 00 0b
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9442 ff
; Entita 94 ($5E): mrs brown; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$C0,$00,$43 ; $9443 01 ff 00 00 00 c0 00 43
    DEFB $81,$84,$05,$00,$00,$00,$00,$00 ; $944B 81 84 05 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9453 ff
; Entita 95 ($5F): mrs jones; 23 byte.
    DEFB $01,$FF,$20,$20,$10,$C0,$00,$8B ; $9454 01 ff 20 20 10 c0 00 8b
    DEFB $84,$84,$05,$00,$00,$00,$00,$00 ; $945C 84 84 05 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $00,$00,$30,$16,$2F,$16,$FF   ; $9464 00 00 30 16 2f 16 ff
; Entita 96 ($60): herself; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$02 ; $946B 01 ff 00 00 00 80 00 02
    DEFB $84,$00,$00,$00,$00,$00,$00,$00 ; $9473 84 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $947B ff
; Entita 97 ($61): plans; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$9E ; $947C 01 ff 00 00 00 80 00 9e
    DEFB $06,$00,$00,$00,$00,$00,$00,$00 ; $9484 06 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $948C ff
; Entita 98 ($62): innocent; 17 byte.
    DEFB $01,$FF,$00,$00,$00,$80,$00,$60 ; $948D 01 ff 00 00 00 80 00 60
    DEFB $84,$00,$00,$00,$00,$00,$00,$00 ; $9495 84 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $949D ff
; Entita 99 ($63): opium den; 17 byte.
    DEFB $01,$FF,$05,$05,$00,$80,$00,$31 ; $949E 01 ff 05 05 00 80 00 31
    DEFB $02,$0F,$06,$00,$00,$00,$00,$00 ; $94A6 02 0f 06 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $94AE ff
; Entita 100 ($64): old man; 17 byte.
    DEFB $01,$FF,$60,$40,$A0,$E0,$00,$46 ; $94AF 01 ff 60 40 a0 e0 00 46
    DEFB $25,$FB,$05,$00,$00,$00,$00,$00 ; $94B7 25 fb 05 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $94BF ff
; Entita 101 ($65): old mans disguise; 21 byte.
    DEFB $01,$FF,$80,$30,$00,$A0,$00,$59 ; $94C0 01 ff 80 30 00 a0 00 59
    DEFB $22,$FB,$05,$49,$05,$00,$00,$09 ; $94C8 22 fb 05 49 05 00 00 09
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $33,$17,$2B,$18,$FF           ; $94D0 33 17 2b 18 ff
; Entita 102 ($66): window; 17 byte.
    DEFB $01,$FF,$FF,$FF,$00,$81,$00,$BB ; $94D5 01 ff ff ff 00 81 00 bb
    DEFB $09,$00,$00,$00,$00,$00,$00,$3D ; $94DD 09 00 00 00 00 00 00 3d
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $94E5 ff
; Entita 103 ($67): tricias front door; 22 byte.
    DEFB $02,$FF,$FF,$FF,$00,$81,$00,$6E ; $94E6 02 ff ff ff 00 81 00 6e
    DEFB $82,$FE,$08,$55,$03,$00,$00,$2D ; $94EE 82 fe 08 55 03 00 00 2d
    DEFB $2E                           ; $94F6 2e
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $24,$06,$0E,$07,$FF           ; $94F7 24 06 0e 07 ff
; Entita 104 ($68): german agent; 17 byte.
    DEFB $01,$FF,$30,$30,$40,$E0,$00,$2A ; $94FC 01 ff 30 30 40 e0 00 2a
    DEFB $10,$7B,$03,$00,$00,$00,$00,$00 ; $9504 10 7b 03 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $950C ff
; Entita 105 ($69): old mill road; 17 byte.
    DEFB $01,$FF,$05,$05,$00,$80,$00,$3F ; $950D 01 ff 05 05 00 80 00 3f
    DEFB $07,$FB,$05,$67,$05,$00,$00,$00 ; $9515 07 fb 05 67 05 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $951D ff
; Entita 106 ($6A): sale location; 17 byte.
    DEFB $01,$FF,$05,$05,$00,$80,$00,$0F ; $951E 01 ff 05 05 00 80 00 0f
    DEFB $05,$62,$07,$00,$00,$00,$00,$00 ; $9526 05 62 07 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $952E ff
; Entita 107 ($6B): guilty; 17 byte.
    DEFB $01,$FF,$05,$05,$00,$80,$00,$AF ; $952F 01 ff 05 05 00 80 00 af
    DEFB $83,$00,$00,$00,$00,$00,$00,$00 ; $9537 83 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $953F ff
; Entita 108 ($6C): idiot; 17 byte.
    DEFB $01,$FF,$05,$05,$00,$80,$00,$31 ; $9540 01 ff 05 05 00 80 00 31
    DEFB $24,$00,$00,$00,$00,$00,$00,$00 ; $9548 24 00 00 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $FF                           ; $9550 ff
; Entita 109 ($6D): police cab; 25 byte.
    DEFB $01,$FF,$FF,$80,$81,$B4,$00,$64 ; $9551 01 ff ff 80 81 b4 00 64
    DEFB $11,$B5,$06,$00,$00,$00,$00,$00 ; $9559 11 b5 06 00 00 00 00 00
; Coda locale: coppie azione/indice; FF finale, eventuale marcatore00.
    DEFB $0D,$08,$0C,$0C,$19,$08,$18,$0C ; $9561 0d 08 0c 0c 19 08 18 0c
    DEFB $FF                           ; $9569 ff

    ORG $A419
; CODE fino a $A475
; Formattazione valuta in sterline (240pence), scellini (12pence) e pence.
    PUSH BC                            ; $A419 c5
    RES 7,H                            ; $A41A cb bc
    SLA L                              ; $A41C cb 25
    SRL H                              ; $A41E cb 3c
    RR L                               ; $A420 cb 1d
    LD A,$20                           ; $A422 3e 20
    CALL $A9B7                         ; $A424 cd b7 a9
    LD DE,$00F0                        ; $A427 11 f0 00
    CALL $A476                         ; $A42A cd 76 a4
    AND A                              ; $A42D a7
    JR Z,$A442                         ; $A42E 28 12
    LD B,A                             ; $A430 47
    LD A,$60                           ; $A431 3e 60
    CALL $A9B7                         ; $A433 cd b7 a9
    CALL $A490                         ; $A436 cd 90 a4
    LD A,L                             ; $A439 7d
    OR H                               ; $A43A b4
    JR Z,$A467                         ; $A43B 28 2a
    LD A,$20                           ; $A43D 3e 20
    CALL $A9B7                         ; $A43F cd b7 a9
    LD DE,$000C                        ; $A442 11 0c 00
    CALL $A476                         ; $A445 cd 76 a4
    AND A                              ; $A448 a7
    JR Z,$A469                         ; $A449 28 1e
    LD B,A                             ; $A44B 47
    CALL $A490                         ; $A44C cd 90 a4
    LD A,$2F                           ; $A44F 3e 2f
    CALL $A9B7                         ; $A451 cd b7 a9
    LD A,L                             ; $A454 7d
    AND A                              ; $A455 a7
    LD B,A                             ; $A456 47
    JR Z,$A45E                         ; $A457 28 05
    CALL $A490                         ; $A459 cd 90 a4
    JR $A467                           ; $A45C 18 09
    LD A,$2D                           ; $A45E 3e 2d
    CALL $A9B7                         ; $A460 cd b7 a9
    XOR A                              ; $A463 af
    LD ($A026),A                       ; $A464 32 26 a0
    POP BC                             ; $A467 c1
    RET                                ; $A468 c9
    LD B,L                             ; $A469 45
    CALL $A490                         ; $A46A cd 90 a4
    LD A,$44                           ; $A46D 3e 44
    CALL $A9B7                         ; $A46F cd b7 a9
    LD A,$2E                           ; $A472 3e 2e
    JR $A460                           ; $A474 18 ea

    ORG $A4CD
; CODE fino a $A535
    PUSH DE                            ; $A4CD d5
    PUSH HL                            ; $A4CE e5
    PUSH IY                            ; $A4CF fd e5
    LD DE,$0006                        ; $A4D1 11 06 00
    ADD HL,DE                          ; $A4D4 19
    ADD IY,DE                          ; $A4D5 fd 19
    CALL $A51B                         ; $A4D7 cd 1b a5
    JR NZ,$A516                        ; $A4DA 20 3a
    POP IY                             ; $A4DC fd e1
    POP HL                             ; $A4DE e1
    POP DE                             ; $A4DF d1
; Nome + fino a2 qualificatori: prova entrambi gli ordini.
    PUSH DE                            ; $A4E0 d5
    PUSH HL                            ; $A4E1 e5
    PUSH IY                            ; $A4E2 fd e5
    CALL $A51B                         ; $A4E4 cd 1b a5
    JR NZ,$A516                        ; $A4E7 20 2d
    LD A,$01                           ; $A4E9 3e 01
    LD ($A02E),A                       ; $A4EB 32 2e a0
    CALL $A51B                         ; $A4EE cd 1b a5
    JR NZ,$A4FA                        ; $A4F1 20 07
    CALL $A51B                         ; $A4F3 cd 1b a5
    LD A,$00                           ; $A4F6 3e 00
    JR Z,$A516                         ; $A4F8 28 1c
    POP IY                             ; $A4FA fd e1
    POP HL                             ; $A4FC e1
    PUSH HL                            ; $A4FD e5
    PUSH IY                            ; $A4FE fd e5
    LD DE,$0004                        ; $A500 11 04 00
    ADD IY,DE                          ; $A503 fd 19
    INC HL                             ; $A505 23
    INC HL                             ; $A506 23
    CALL $A51B                         ; $A507 cd 1b a5
    JR NZ,$A516                        ; $A50A 20 0a
    LD DE,$FFFC                        ; $A50C 11 fc ff
    ADD IY,DE                          ; $A50F fd 19
    CALL $A51B                         ; $A511 cd 1b a5
    LD A,$01                           ; $A514 3e 01
    POP IY                             ; $A516 fd e1
    POP HL                             ; $A518 e1
    POP DE                             ; $A519 d1
    RET                                ; $A51A c9
; Word query zero = wildcard; confronta solo12bit del riferimento.
    PUSH HL                            ; $A51B e5
    LD A,(HL)                          ; $A51C 7e
    INC HL                             ; $A51D 23
    OR (HL)                            ; $A51E b6
    JR Z,$A52E                         ; $A51F 28 0d
    LD A,(IY+$01)                      ; $A521 fd 7e 01
    XOR (HL)                           ; $A524 ae
    AND $0F                            ; $A525 e6 0f
    JR NZ,$A52E                        ; $A527 20 05
    DEC HL                             ; $A529 2b
    LD A,(HL)                          ; $A52A 7e
    CP (IY+$00)                        ; $A52B fd be 00
    POP HL                             ; $A52E e1
    INC HL                             ; $A52F 23
    INC HL                             ; $A530 23
    INC IY                             ; $A531 fd 23
    INC IY                             ; $A533 fd 23
    RET                                ; $A535 c9

    ORG $AA71
; DATA fino a $AAA0
; 24 puntatori LE raggiunti dalle regole locali qui censite; non codice.
    DEFB $99,$9A,$CB,$9A,$A3,$E1,$22,$E0 ; $AA71 99 9a cb 9a a3 e1 22 e0
    DEFB $03,$E0,$9D,$DE,$AF,$DE,$32,$E4 ; $AA79 03 e0 9d de af de 32 e4
    DEFB $0A,$E4,$28,$E3,$C7,$E2,$EA,$E3 ; $AA81 0a e4 28 e3 c7 e2 ea e3
    DEFB $8D,$E0,$F4,$9A,$E1,$9A,$A0,$E0 ; $AA89 8d e0 f4 9a e1 9a a0 e0
    DEFB $F2,$E0,$04,$E1,$E0,$E0,$7E,$DF ; $AA91 f2 e0 04 e1 e0 e0 7e df
    DEFB $A7,$DF,$7B,$E1,$F0,$DF,$EA,$DF ; $AA99 a7 df 7b e1 f0 df ea df

    ORG $B16D
; DATA fino a $B190
; Stato dei due argomenti e contatori. B172/B178: triplette nominali; B182/B183: slot AST.
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $B16D 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $B175 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $B17D 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; $B185 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00               ; $B18D 00 00 00 00

    ORG $B191
; CODE fino a $B39B
; Risoluzione semantica del comando: inizializza argomenti a FF e riconosce modello verbo.
    LD A,$FF                           ; $B191 3e ff
    LD ($A035),A                       ; $B193 32 35 a0
    LD ($A034),A                       ; $B196 32 34 a0
    LD HL,$B16D                        ; $B199 21 6d b1
    LD B,$11                           ; $B19C 06 11
    CALL $A2AB                         ; $B19E cd ab a2
    CALL $B39D                         ; $B1A1 cd 9d b3
    JR NZ,$B1AB                        ; $B1A4 20 05
    LD HL,$B84C                        ; $B1A6 21 4c b8
    XOR A                              ; $B1A9 af
    RET                                ; $B1AA c9
    LD A,$01                           ; $B1AB 3e 01
    PUSH IX                            ; $B1AD dd e5
    POP HL                             ; $B1AF e1
    LD DE,$8259                        ; $B1B0 11 59 82
    SBC HL,DE                          ; $B1B3 ed 52
    JR Z,$B1BF                         ; $B1B5 28 08
    LD DE,$0008                        ; $B1B7 11 08 00
    INC A                              ; $B1BA 3c
    SBC HL,DE                          ; $B1BB ed 52
    JR NZ,$B1BA                        ; $B1BD 20 fb
    LD ($A033),A                       ; $B1BF 32 33 a0
    LD ($B18E),IX                      ; $B1C2 dd 22 8e b1
    CP $2E                             ; $B1C6 fe 2e
    JR NZ,$B1DD                        ; $B1C8 20 13
    LD HL,$B16D                        ; $B1CA 21 6d b1
    BIT 0,(HL)                         ; $B1CD cb 46
    LD HL,$A002                        ; $B1CF 21 02 a0
    LD DE,$B172                        ; $B1D2 11 72 b1
    LD BC,$0006                        ; $B1D5 01 06 00
    JR Z,$B1DB                         ; $B1D8 28 01
    EX DE,HL                           ; $B1DA eb
    LDIR                               ; $B1DB ed b0
    CALL $C493                         ; $B1DD cd 93 c4
    CALL $C4B2                         ; $B1E0 cd b2 c4
    LD A,($A01C)                       ; $B1E3 3a 1c a0
    AND A                              ; $B1E6 a7
    JR NZ,$B1F2                        ; $B1E7 20 09
    LD A,($B39C)                       ; $B1E9 3a 9c b3
    LD ($A01C),A                       ; $B1EC 32 1c a0
    CALL $B34F                         ; $B1EF cd 4f b3
    LD A,($A01E)                       ; $B1F2 3a 1e a0
    AND $10                            ; $B1F5 e6 10
    LD ($B190),A                       ; $B1F7 32 90 b1
    JR Z,$B200                         ; $B1FA 28 04
    XOR A                              ; $B1FC af
    LD ($A01C),A                       ; $B1FD 32 1c a0
    XOR A                              ; $B200 af
; A00B=0: richiesta di verifica, prima dell esecuzione delle azioni.
    LD ($A00B),A                       ; $B201 32 0b a0
    LD A,($A01D)                       ; $B204 3a 1d a0
    AND $0C                            ; $B207 e6 0c
    JR NZ,$B213                        ; $B209 20 08
    CALL $C929                         ; $B20B cd 29 c9
    RET NZ                             ; $B20E c0
    LD HL,$B863                        ; $B20F 21 63 b8
    RET                                ; $B212 c9
    CALL $B387                         ; $B213 cd 87 b3
    JR NZ,$B280                        ; $B216 20 68
    LD A,($A01C)                       ; $B218 3a 1c a0
    AND A                              ; $B21B a7
    JR NZ,$B224                        ; $B21C 20 06
    CALL $B308                         ; $B21E cd 08 b3
    AND A                              ; $B221 a7
    JR Z,$B259                         ; $B222 28 35
; Enumera primo argomento; C929 filtra candidati con le regole dell azione.
    CALL $B4C1                         ; $B224 cd c1 b4
    JR Z,$B244                         ; $B227 28 1b
    CALL $C929                         ; $B229 cd 29 c9
    JR Z,$B224                         ; $B22C 28 f6
    LD A,($A034)                       ; $B22E 3a 34 a0
    LD ($B184),A                       ; $B231 32 84 b1
    LD HL,$B170                        ; $B234 21 70 b1
    INC (HL)                           ; $B237 34
    LD A,($B190)                       ; $B238 3a 90 b1
    AND A                              ; $B23B a7
    JR NZ,$B244                        ; $B23C 20 06
    LD A,($A01C)                       ; $B23E 3a 1c a0
    AND A                              ; $B241 a7
    JR Z,$B224                         ; $B242 28 e0
; Conta superstiti: zero -> B65F; uno -> nuova verifica; piu di uno -> B5E2.
    LD A,($B184)                       ; $B244 3a 84 b1
    LD ($A034),A                       ; $B247 32 34 a0
    LD A,($B170)                       ; $B24A 3a 70 b1
    AND A                              ; $B24D a7
    JR Z,$B259                         ; $B24E 28 09
    CP $01                             ; $B250 fe 01
    JR Z,$B20B                         ; $B252 28 b7
    LD HL,$B5E2                        ; $B254 21 e2 b5
    XOR A                              ; $B257 af
    RET                                ; $B258 c9
    LD A,($A033)                       ; $B259 3a 33 a0
    CP $2E                             ; $B25C fe 2e
    JR NZ,$B27B                        ; $B25E 20 1b
    LD A,($A01C)                       ; $B260 3a 1c a0
    AND A                              ; $B263 a7
    JR NZ,$B27B                        ; $B264 20 15
    LD HL,$B16D                        ; $B266 21 6d b1
    BIT 0,(HL)                         ; $B269 cb 46
    JR NZ,$B27B                        ; $B26B 20 0e
    LD HL,$0000                        ; $B26D 21 00 00
    LD ($B172),HL                      ; $B270 22 72 b1
    LD ($B174),HL                      ; $B273 22 74 b1
    LD ($B176),HL                      ; $B276 22 76 b1
    JR $B213                           ; $B279 18 98
    LD HL,$B65F                        ; $B27B 21 5f b6
    XOR A                              ; $B27E af
    RET                                ; $B27F c9
; Ramo con secondo argomento: controlla combinazioni, non due elenchi indipendenti.
    LD A,($A01C)                       ; $B280 3a 1c a0
    AND A                              ; $B283 a7
    JR NZ,$B292                        ; $B284 20 0c
    CALL $B308                         ; $B286 cd 08 b3
    AND A                              ; $B289 a7
    JR Z,$B259                         ; $B28A 28 cd
    CALL $B32D                         ; $B28C cd 2d b3
    AND A                              ; $B28F a7
    JR Z,$B303                         ; $B290 28 71
    CALL $B4C1                         ; $B292 cd c1 b4
    JR Z,$B2B7                         ; $B295 28 20
    CALL $B2DF                         ; $B297 cd df b2
    LD A,($B171)                       ; $B29A 3a 71 b1
    CP $01                             ; $B29D fe 01
    JR NZ,$B292                        ; $B29F 20 f1
    LD A,($A034)                       ; $B2A1 3a 34 a0
    LD ($B184),A                       ; $B2A4 32 84 b1
    LD HL,$B170                        ; $B2A7 21 70 b1
    INC (HL)                           ; $B2AA 34
    LD A,($B190)                       ; $B2AB 3a 90 b1
    AND A                              ; $B2AE a7
    JR NZ,$B2B7                        ; $B2AF 20 06
    LD A,($A01C)                       ; $B2B1 3a 1c a0
    AND A                              ; $B2B4 a7
    JR Z,$B292                         ; $B2B5 28 db
    LD A,($B184)                       ; $B2B7 3a 84 b1
    LD ($A034),A                       ; $B2BA 32 34 a0
    LD A,($B170)                       ; $B2BD 3a 70 b1
    AND A                              ; $B2C0 a7
    JR Z,$B259                         ; $B2C1 28 96
    CP $01                             ; $B2C3 fe 01
    JR NZ,$B2DA                        ; $B2C5 20 13
    CALL $B2DF                         ; $B2C7 cd df b2
    LD A,($B171)                       ; $B2CA 3a 71 b1
    AND A                              ; $B2CD a7
    JR Z,$B303                         ; $B2CE 28 33
    CP $01                             ; $B2D0 fe 01
    JP Z,$B20B                         ; $B2D2 ca 0b b2
    LD HL,$B5D3                        ; $B2D5 21 d3 b5
    XOR A                              ; $B2D8 af
    RET                                ; $B2D9 c9
    LD HL,$B5E2                        ; $B2DA 21 e2 b5
    XOR A                              ; $B2DD af
    RET                                ; $B2DE c9
; Enumera secondo argomento e conta le combinazioni ammesse da C929.
    CALL $B36B                         ; $B2DF cd 6b b3
    CALL $B568                         ; $B2E2 cd 68 b5
    JR Z,$B2FC                         ; $B2E5 28 15
    CALL $C929                         ; $B2E7 cd 29 c9
    JR Z,$B2E2                         ; $B2EA 28 f6
    LD A,($A035)                       ; $B2EC 3a 35 a0
    LD ($B185),A                       ; $B2EF 32 85 b1
    LD HL,$B171                        ; $B2F2 21 71 b1
    INC (HL)                           ; $B2F5 34
    LD A,($B190)                       ; $B2F6 3a 90 b1
    AND A                              ; $B2F9 a7
    JR Z,$B2E2                         ; $B2FA 28 e6
    LD A,($B185)                       ; $B2FC 3a 85 b1
    LD ($A035),A                       ; $B2FF 32 35 a0
    RET                                ; $B302 c9
    LD HL,$B6AE                        ; $B303 21 ae b6
    XOR A                              ; $B306 af
    RET                                ; $B307 c9
; Prima conta dei candidati nominali, senza il filtro completo dell azione.
    LD HL,($B17E)                      ; $B308 2a 7e b1
    PUSH HL                            ; $B30B e5
    LD A,($B4A2)                       ; $B30C 3a a2 b4
    PUSH AF                            ; $B30F f5
    CALL $B34F                         ; $B310 cd 4f b3
    CALL $B4C1                         ; $B313 cd c1 b4
    JR Z,$B31E                         ; $B316 28 06
    LD HL,$B170                        ; $B318 21 70 b1
    INC (HL)                           ; $B31B 34
    JR $B313                           ; $B31C 18 f5
    POP AF                             ; $B31E f1
    LD ($B4A2),A                       ; $B31F 32 a2 b4
    LD HL,$B170                        ; $B322 21 70 b1
    LD A,(HL)                          ; $B325 7e
    LD (HL),$00                        ; $B326 36 00
    POP HL                             ; $B328 e1
    LD ($B17E),HL                      ; $B329 22 7e b1
    RET                                ; $B32C c9
    LD HL,($B180)                      ; $B32D 2a 80 b1
    PUSH HL                            ; $B330 e5
    CALL $B36B                         ; $B331 cd 6b b3
    LD A,($B549)                       ; $B334 3a 49 b5
    PUSH AF                            ; $B337 f5
    CALL $B568                         ; $B338 cd 68 b5
    JR Z,$B343                         ; $B33B 28 06
    LD HL,$B171                        ; $B33D 21 71 b1
    INC (HL)                           ; $B340 34
    JR $B338                           ; $B341 18 f5
    POP AF                             ; $B343 f1
    LD ($B549),A                       ; $B344 32 49 b5
    LD A,($B171)                       ; $B347 3a 71 b1
    POP HL                             ; $B34A e1
    LD ($B180),HL                      ; $B34B 22 80 b1
    RET                                ; $B34E c9
; Inizializza cursore ricerca: indice entita per classe>=7, cursore locazioni altrimenti.
    XOR A                              ; $B34F af
    LD ($B170),A                       ; $B350 32 70 b1
    LD A,$FF                           ; $B353 3e ff
    LD ($B4A2),A                       ; $B355 32 a2 b4
    CALL $D04F                         ; $B358 cd 4f d0
    LD A,($A00F)                       ; $B35B 3a 0f a0
    CP $07                             ; $B35E fe 07
    JR NC,$B366                        ; $B360 30 04
    LD IX,$0000                        ; $B362 dd 21 00 00
    LD ($B17E),IX                      ; $B366 dd 22 7e b1
    RET                                ; $B36A c9
    XOR A                              ; $B36B af
    LD ($B171),A                       ; $B36C 32 71 b1
    LD A,$FF                           ; $B36F 3e ff
    LD ($B549),A                       ; $B371 32 49 b5
    CALL $D04F                         ; $B374 cd 4f d0
    LD A,($A010)                       ; $B377 3a 10 a0
    CP $07                             ; $B37A fe 07
    JR NC,$B382                        ; $B37C 30 04
    LD IX,$0000                        ; $B37E dd 21 00 00
    LD ($B180),IX                      ; $B382 dd 22 80 b1
    RET                                ; $B386 c9
    LD A,($A01D)                       ; $B387 3a 1d a0
    BIT 2,A                            ; $B38A cb 57
    RET Z                              ; $B38C c8
    LD HL,$B16E                        ; $B38D 21 6e b1
    BIT 0,(HL)                         ; $B390 cb 46
    RET NZ                             ; $B392 c0
    BIT 1,A                            ; $B393 cb 4f
    JR NZ,$B39A                        ; $B395 20 03
    OR $01                             ; $B397 f6 01
    RET                                ; $B399 c9
    XOR A                              ; $B39A af
    RET                                ; $B39B c9

    ORG $B39C
; DATA fino a $B39C
; Byte di stato, non NOP.
    DEFB $00                           ; $B39C 00

    ORG $B39D
; CODE fino a $B4A1
; Confronto dei modelli lessicali da 8259; restituisce indice del modello in A033.
    PUSH IY                            ; $B39D fd e5
    LD L,(IY+$00)                      ; $B39F fd 6e 00
    LD H,(IY+$01)                      ; $B3A2 fd 66 01
    LD A,H                             ; $B3A5 7c
    AND $80                            ; $B3A6 e6 80
    LD ($B39C),A                       ; $B3A8 32 9c b3
    RES 7,H                            ; $B3AB cb bc
    LD ($B186),HL                      ; $B3AD 22 86 b1
    LD L,(IY+$02)                      ; $B3B0 fd 6e 02
    LD H,(IY+$03)                      ; $B3B3 fd 66 03
    LD ($B18C),HL                      ; $B3B6 22 8c b1
    LD HL,$B188                        ; $B3B9 21 88 b1
    PUSH HL                            ; $B3BC e5
    LD B,$04                           ; $B3BD 06 04
    CALL $A2AB                         ; $B3BF cd ab a2
    POP HL                             ; $B3C2 e1
    LD B,$02                           ; $B3C3 06 02
    LD E,$04                           ; $B3C5 1e 04
    CALL $B483                         ; $B3C7 cd 83 b4
    LD E,$0E                           ; $B3CA 1e 0e
    CALL $B483                         ; $B3CC cd 83 b4
    LD E,$06                           ; $B3CF 1e 06
    CALL $B483                         ; $B3D1 cd 83 b4
    LD E,$10                           ; $B3D4 1e 10
    CALL $B483                         ; $B3D6 cd 83 b4
    XOR A                              ; $B3D9 af
    LD ($A02E),A                       ; $B3DA 32 2e a0
    LD HL,$B186                        ; $B3DD 21 86 b1
    LD DE,$0008                        ; $B3E0 11 08 00
    LD IX,$8259                        ; $B3E3 dd 21 59 82
    PUSH IX                            ; $B3E7 dd e5
    POP IY                             ; $B3E9 fd e1
    CALL $A4CD                         ; $B3EB cd cd a4
    JR Z,$B3FD                         ; $B3EE 28 0d
    ADD IX,DE                          ; $B3F0 dd 19
    LD A,(IX+$01)                      ; $B3F2 dd 7e 01
    OR (IX+$00)                        ; $B3F5 dd b6 00
    JR NZ,$B3E7                        ; $B3F8 20 ed
    POP IY                             ; $B3FA fd e1
    RET                                ; $B3FC c9
    POP IY                             ; $B3FD fd e1
    CALL $B405                         ; $B3FF cd 05 b4
    OR $01                             ; $B402 f6 01
    RET                                ; $B404 c9
; Ordina i due argomenti in base al modello e alle preposizioni.
    AND A                              ; $B405 a7
    JR Z,$B416                         ; $B406 28 0e
    LD HL,($B188)                      ; $B408 2a 88 b1
    LD DE,($B18A)                      ; $B40B ed 5b 8a b1
    LD ($B188),DE                      ; $B40F ed 53 88 b1
    LD ($B18A),HL                      ; $B413 22 8a b1
    CALL $A2BD                         ; $B416 cd bd a2
    LD HL,$B188                        ; $B419 21 88 b1
    LD A,(HL)                          ; $B41C 7e
    INC HL                             ; $B41D 23
    OR (HL)                            ; $B41E b6
    JR NZ,$B426                        ; $B41F 20 05
    LD A,($A01E)                       ; $B421 3a 1e a0
    JR $B445                           ; $B424 18 1f
    DEC HL                             ; $B426 2b
    LD A,(HL)                          ; $B427 7e
    CP (IY+$0E)                        ; $B428 fd be 0e
    JR NZ,$B435                        ; $B42B 20 08
    INC HL                             ; $B42D 23
    LD A,(HL)                          ; $B42E 7e
    CP (IY+$0F)                        ; $B42F fd be 0f
    JR Z,$B440                         ; $B432 28 0c
    DEC HL                             ; $B434 2b
    LD A,(HL)                          ; $B435 7e
    CP (IY+$10)                        ; $B436 fd be 10
    JR NZ,$B440                        ; $B439 20 05
    INC HL                             ; $B43B 23
    LD A,(HL)                          ; $B43C 7e
    CP (IY+$11)                        ; $B43D fd be 11
    LD A,($A01D)                       ; $B440 3a 1d a0
    JR NZ,$B447                        ; $B443 20 02
    XOR $20                            ; $B445 ee 20
    BIT 5,A                            ; $B447 cb 6f
    LD BC,$1208                        ; $B449 01 08 12
    JR Z,$B451                         ; $B44C 28 03
    LD BC,$0812                        ; $B44E 01 12 08
    LD HL,$B182                        ; $B451 21 82 b1
    LD (HL),B                          ; $B454 70
    INC HL                             ; $B455 23
    LD (HL),C                          ; $B456 71
    LD A,B                             ; $B457 78
    LD DE,$B172                        ; $B458 11 72 b1
    LD HL,$B16D                        ; $B45B 21 6d b1
    CALL $B468                         ; $B45E cd 68 b4
    LD A,C                             ; $B461 79
    LD DE,$B178                        ; $B462 11 78 b1
    LD HL,$B16E                        ; $B465 21 6e b1
    PUSH BC                            ; $B468 c5
    LD C,A                             ; $B469 4f
    LD B,$00                           ; $B46A 06 00
    PUSH HL                            ; $B46C e5
    PUSH IY                            ; $B46D fd e5
    POP HL                             ; $B46F e1
    ADD HL,BC                          ; $B470 09
    LD BC,$0006                        ; $B471 01 06 00
    LDIR                               ; $B474 ed b0
    XOR A                              ; $B476 af
    LD B,$06                           ; $B477 06 06
    DEC HL                             ; $B479 2b
    OR (HL)                            ; $B47A b6
    DJNZ $B479                         ; $B47B 10 fc
    POP HL                             ; $B47D e1
    POP BC                             ; $B47E c1
    RET Z                              ; $B47F c8
    SET 0,(HL)                         ; $B480 cb c6
    RET                                ; $B482 c9
    XOR A                              ; $B483 af
    CP B                               ; $B484 b8
    RET Z                              ; $B485 c8
    LD D,$00                           ; $B486 16 00
    PUSH IY                            ; $B488 fd e5
    ADD IY,DE                          ; $B48A fd 19
    LD A,(IY+$00)                      ; $B48C fd 7e 00
    LD (HL),A                          ; $B48F 77
    INC HL                             ; $B490 23
    LD A,(IY+$01)                      ; $B491 fd 7e 01
    LD (HL),A                          ; $B494 77
    DEC HL                             ; $B495 2b
    OR (IY+$00)                        ; $B496 fd b6 00
    POP IY                             ; $B499 fd e1
    RET Z                              ; $B49B c8
    DEC B                              ; $B49C 05
    INC HL                             ; $B49D 23
    INC HL                             ; $B49E 23
    RET                                ; $B49F c9
    JP (IY)                            ; $B4A0 fd e9

    ORG $B4A2
; DATA fino a $B4A2
; Byte di stato per argomento numerico, non NOP.
    DEFB $00                           ; $B4A2 00

    ORG $B4A3
; CODE fino a $B548
    LD A,($B4A2)                       ; $B4A3 3a a2 b4
    INC A                              ; $B4A6 3c
    JR NZ,$B4CF                        ; $B4A7 20 26
    LD ($B4A2),A                       ; $B4A9 32 a2 b4
    LD A,($B173)                       ; $B4AC 3a 73 b1
    BIT 7,A                            ; $B4AF cb 7f
    JR Z,$B4CF                         ; $B4B1 28 1c
    LD A,$FE                           ; $B4B3 3e fe
    LD ($A034),A                       ; $B4B5 32 34 a0
    LD HL,($B172)                      ; $B4B8 2a 72 b1
    LD ($A02F),HL                      ; $B4BB 22 2f a0
    OR $01                             ; $B4BE f6 01
    RET                                ; $B4C0 c9
; Argomento1: seleziona enumeratore entita D36A o locazioni D39B; letterali -> FE.
    LD A,($A00F)                       ; $B4C1 3a 0f a0
    CP $05                             ; $B4C4 fe 05
    JR Z,$B4A3                         ; $B4C6 28 db
    LD A,($B173)                       ; $B4C8 3a 73 b1
    BIT 7,A                            ; $B4CB cb 7f
    JR Z,$B4D4                         ; $B4CD 28 05
    LD A,$FF                           ; $B4CF 3e ff
    CP $FF                             ; $B4D1 fe ff
    RET                                ; $B4D3 c9
    PUSH IY                            ; $B4D4 fd e5
    LD IX,($B17E)                      ; $B4D6 dd 2a 7e b1
    LD A,($A01D)                       ; $B4DA 3a 1d a0
    AND $01                            ; $B4DD e6 01
    LD ($A038),A                       ; $B4DF 32 38 a0
    LD A,($A00F)                       ; $B4E2 3a 0f a0
    CP $05                             ; $B4E5 fe 05
    LD IY,$D39B                        ; $B4E7 fd 21 9b d3
    JR C,$B4F1                         ; $B4EB 38 04
    LD IY,$D36A                        ; $B4ED fd 21 6a d3
    CALL $B4FD                         ; $B4F1 cd fd b4
    CP $FF                             ; $B4F4 fe ff
    LD ($B17E),IX                      ; $B4F6 dd 22 7e b1
    POP IY                             ; $B4FA fd e1
    RET                                ; $B4FC c9
; Candidato nominale nel primo slot A034, poi esclusioni ALL/EXCEPT.
    LD HL,$B172                        ; $B4FD 21 72 b1
    CALL $B4A0                         ; $B500 cd a0 b4
    CP $FF                             ; $B503 fe ff
    RET Z                              ; $B505 c8
    LD ($A034),A                       ; $B506 32 34 a0
    CALL $B517                         ; $B509 cd 17 b5
    JR NZ,$B4FD                        ; $B50C 20 ef
    LD A,($A034)                       ; $B50E 3a 34 a0
    LD HL,$B16D                        ; $B511 21 6d b1
    SET 1,(HL)                         ; $B514 cb ce
    RET                                ; $B516 c9
; Esclusioni dei comandi collettivi.
    LD A,($A01C)                       ; $B517 3a 1c a0
    AND A                              ; $B51A a7
    RET Z                              ; $B51B c8
    PUSH IY                            ; $B51C fd e5
    PUSH DE                            ; $B51E d5
    PUSH IX                            ; $B51F dd e5
    CALL $AEA9                         ; $B521 cd a9 ae
    BIT 6,(IY+$01)                     ; $B524 fd cb 01 76
    JR Z,$B543                         ; $B528 28 19
    CALL $D04F                         ; $B52A cd 4f d0
    PUSH IY                            ; $B52D fd e5
    POP HL                             ; $B52F e1
    LD DE,$0008                        ; $B530 11 08 00
    ADD HL,DE                          ; $B533 19
    CALL $D36A                         ; $B534 cd 6a d3
    CP $FF                             ; $B537 fe ff
    JR Z,$B521                         ; $B539 28 e6
    LD HL,$A034                        ; $B53B 21 34 a0
    CP (HL)                            ; $B53E be
    JR NZ,$B52D                        ; $B53F 20 ec
    OR $01                             ; $B541 f6 01
    POP IX                             ; $B543 dd e1
    POP DE                             ; $B545 d1
    POP IY                             ; $B546 fd e1
    RET                                ; $B548 c9

    ORG $B549
; DATA fino a $B549
; Byte di stato per secondo argomento numerico.
    DEFB $00                           ; $B549 00

    ORG $B54A
; CODE fino a $B5FB
    LD A,($B549)                       ; $B54A 3a 49 b5
    INC A                              ; $B54D 3c
    JR NZ,$B576                        ; $B54E 20 26
    LD ($B549),A                       ; $B550 32 49 b5
    LD A,($B179)                       ; $B553 3a 79 b1
    BIT 7,A                            ; $B556 cb 7f
    JR Z,$B576                         ; $B558 28 1c
    LD A,$FE                           ; $B55A 3e fe
    LD ($A035),A                       ; $B55C 32 35 a0
    LD HL,($B178)                      ; $B55F 2a 78 b1
    LD ($A031),HL                      ; $B562 22 31 a0
    OR $01                             ; $B565 f6 01
    RET                                ; $B567 c9
; Secondo argomento, analogo al primo; risultato A035.
    LD A,($A010)                       ; $B568 3a 10 a0
    CP $05                             ; $B56B fe 05
    JR Z,$B54A                         ; $B56D 28 db
    LD A,($B179)                       ; $B56F 3a 79 b1
    BIT 7,A                            ; $B572 cb 7f
    JR Z,$B57B                         ; $B574 28 05
    LD A,$FF                           ; $B576 3e ff
    CP $FF                             ; $B578 fe ff
    RET                                ; $B57A c9
    PUSH IY                            ; $B57B fd e5
    LD IX,($B180)                      ; $B57D dd 2a 80 b1
    LD A,($A01D)                       ; $B581 3a 1d a0
    AND $01                            ; $B584 e6 01
    LD ($A038),A                       ; $B586 32 38 a0
    LD A,($A010)                       ; $B589 3a 10 a0
    CP $05                             ; $B58C fe 05
    LD IY,$D39B                        ; $B58E fd 21 9b d3
    JR C,$B598                         ; $B592 38 04
    LD IY,$D36A                        ; $B594 fd 21 6a d3
    CALL $B5A4                         ; $B598 cd a4 b5
    CP $FF                             ; $B59B fe ff
    LD ($B180),IX                      ; $B59D dd 22 80 b1
    POP IY                             ; $B5A1 fd e1
    RET                                ; $B5A3 c9
    LD HL,$B178                        ; $B5A4 21 78 b1
    CALL $B4A0                         ; $B5A7 cd a0 b4
    CP $FF                             ; $B5AA fe ff
    RET Z                              ; $B5AC c8
    LD ($A035),A                       ; $B5AD 32 35 a0
    LD HL,$B16E                        ; $B5B0 21 6e b1
    SET 1,(HL)                         ; $B5B3 cb ce
    RET                                ; $B5B5 c9
; Sposta il nodo in sospeso da 9FF2 a 9FF0; A01B conserva slot08/12.
    LD ($A01B),A                       ; $B5B6 32 1b a0
    LD IX,($9FF2)                      ; $B5B9 dd 2a f2 9f
    LD ($9FF0),IX                      ; $B5BD dd 22 f0 9f
    LD L,(IX-$02)                      ; $B5C1 dd 6e fe
    LD H,(IX-$01)                      ; $B5C4 dd 66 ff
    LD ($9FF2),HL                      ; $B5C7 22 f2 9f
    LD (IX-$02),$00                    ; $B5CA dd 36 fe 00
    LD (IX-$01),$00                    ; $B5CE dd 36 ff 00
    RET                                ; $B5D2 c9
; Domanda di precisazione sul secondo argomento.
    LD A,($B16E)                       ; $B5D3 3a 6e b1
    BIT 0,A                            ; $B5D6 cb 47
    JR Z,$B610                         ; $B5D8 28 36
    LD A,($B183)                       ; $B5DA 3a 83 b1
    LD HL,$B178                        ; $B5DD 21 78 b1
    JR $B5EF                           ; $B5E0 18 0d
; Domanda sul primo argomento; testo base 6888.
    LD A,($B16D)                       ; $B5E2 3a 6d b1
    BIT 0,A                            ; $B5E5 cb 47
    JR Z,$B5FC                         ; $B5E7 28 13
    LD A,($B182)                       ; $B5E9 3a 82 b1
    LD HL,$B172                        ; $B5EC 21 72 b1
    CALL $B83C                         ; $B5EF cd 3c b8
    CALL $B5B6                         ; $B5F2 cd b6 b5
    LD HL,$6888                        ; $B5F5 21 88 68
    CALL $A59F                         ; $B5F8 cd 9f a5
    RET                                ; $B5FB c9

    ORG $C45E
; CODE fino a $C470
    LD A,($A010)                       ; $C45E 3a 10 a0
    JR $C466                           ; $C461 18 03
    LD A,($A00F)                       ; $C463 3a 0f a0
    CP $05                             ; $C466 fe 05
    LD A,B                             ; $C468 78
    JR C,$C46E                         ; $C469 38 03
    CP $6E                             ; $C46B fe 6e
    RET                                ; $C46D c9
    CP $6A                             ; $C46E fe 6a
    RET                                ; $C470 c9

    ORG $C493
; CODE fino a $C4D0
; Classi di ricerca del primo argomento: 0,4,5,7 derivate dal modello.
    XOR A                              ; $C493 af
    LD HL,$A01D                        ; $C494 21 1d a0
    BIT 3,(HL)                         ; $C497 cb 5e
    JR Z,$C4AE                         ; $C499 28 13
    LD A,$04                           ; $C49B 3e 04
    BIT 7,(HL)                         ; $C49D cb 7e
    JR NZ,$C4AE                        ; $C49F 20 0d
    LD A,($A01E)                       ; $C4A1 3a 1e a0
    AND $0C                            ; $C4A4 e6 0c
    CP $0C                             ; $C4A6 fe 0c
    LD A,$05                           ; $C4A8 3e 05
    JR Z,$C4AE                         ; $C4AA 28 02
    LD A,$07                           ; $C4AC 3e 07
    LD ($A00F),A                       ; $C4AE 32 0f a0
    RET                                ; $C4B1 c9
; Classi di ricerca del secondo argomento.
    XOR A                              ; $C4B2 af
    LD HL,$A01D                        ; $C4B3 21 1d a0
    BIT 2,(HL)                         ; $C4B6 cb 56
    JR Z,$C4CD                         ; $C4B8 28 13
    LD A,$04                           ; $C4BA 3e 04
    BIT 6,(HL)                         ; $C4BC cb 76
    JR NZ,$C4CD                        ; $C4BE 20 0d
    LD A,($A01E)                       ; $C4C0 3a 1e a0
    AND $03                            ; $C4C3 e6 03
    CP $03                             ; $C4C5 fe 03
    LD A,$05                           ; $C4C7 3e 05
    JR Z,$C4CD                         ; $C4C9 28 02
    LD A,$07                           ; $C4CB 3e 07
    LD ($A010),A                       ; $C4CD 32 10 a0
    RET                                ; $C4D0 c9

    ORG $C628
; CODE fino a $C9FA
; Vincolo sul primo argomento del blocco di regole.
    LD A,(IY+$00)                      ; $C628 fd 7e 00
    AND $0F                            ; $C62B e6 0f
    JR NZ,$C635                        ; $C62D 20 06
    OR $01                             ; $C62F f6 01
    RET                                ; $C631 c9
    JP $DC15                           ; $C632 c3 15 dc
    CP $05                             ; $C635 fe 05
    JR C,$C660                         ; $C637 38 27
    CP $07                             ; $C639 fe 07
    JR NC,$C682                        ; $C63B 30 45
    LD A,($A034)                       ; $C63D 3a 34 a0
    CP $FE                             ; $C640 fe fe
    JR NZ,$C654                        ; $C642 20 10
    LD HL,($A02F)                      ; $C644 2a 2f a0
    LD A,(IY+$00)                      ; $C647 fd 7e 00
    AND $0F                            ; $C64A e6 0f
    CP $05                             ; $C64C fe 05
    JR NZ,$C65A                        ; $C64E 20 0a
    BIT 7,L                            ; $C650 cb 7d
    JR Z,$C62F                         ; $C652 28 db
    XOR A                              ; $C654 af
    LD ($A021),A                       ; $C655 32 21 a0
    JR $C632                           ; $C658 18 d8
    BIT 7,L                            ; $C65A cb 7d
    JR NZ,$C62F                        ; $C65C 20 d1
    JR $C654                           ; $C65E 18 f4
    CP $03                             ; $C660 fe 03
    JR NC,$C670                        ; $C662 30 0c
    LD A,($A034)                       ; $C664 3a 34 a0
    CALL $D224                         ; $C667 cd 24 d2
    BIT 7,(IX+$00)                     ; $C66A dd cb 00 7e
    JR Z,$C654                         ; $C66E 28 e4
    BIT 0,(IY+$00)                     ; $C670 fd cb 00 46
    JR Z,$C62F                         ; $C674 28 b9
    LD A,($A034)                       ; $C676 3a 34 a0
    CALL $D471                         ; $C679 cd 71 d4
    CP $FF                             ; $C67C fe ff
    JR Z,$C654                         ; $C67E 28 d4
    JR $C62F                           ; $C680 18 ad
    LD A,($A034)                       ; $C682 3a 34 a0
    LD ($CB7A),A                       ; $C685 32 7a cb
    LD C,A                             ; $C688 4f
    LD A,(IY+$00)                      ; $C689 fd 7e 00
    CALL $C7A6                         ; $C68C cd a6 c7
    JR Z,$C654                         ; $C68F 28 c3
    BIT 4,(IY+$00)                     ; $C691 fd cb 00 66
    JR Z,$C62F                         ; $C695 28 98
    LD A,(IY+$02)                      ; $C697 fd 7e 02
    LD L,(IY+$03)                      ; $C69A fd 6e 03
    LD H,(IY+$04)                      ; $C69D fd 66 04
    BIT 6,(IY+$00)                     ; $C6A0 fd cb 00 76
    JR Z,$C6AF                         ; $C6A4 28 09
    LD A,(IY+$04)                      ; $C6A6 fd 7e 04
    LD L,(IY+$05)                      ; $C6A9 fd 6e 05
    LD H,(IY+$06)                      ; $C6AC fd 66 06
    RRCA                               ; $C6AF 0f
    RRCA                               ; $C6B0 0f
    RRCA                               ; $C6B1 0f
    RRCA                               ; $C6B2 0f
    LD B,A                             ; $C6B3 47
    CALL $C74E                         ; $C6B4 cd 4e c7
    RET NZ                             ; $C6B7 c0
    LD A,$01                           ; $C6B8 3e 01
    LD ($A021),A                       ; $C6BA 32 21 a0
    RET                                ; $C6BD c9
; Vincolo sul secondo argomento.
    LD A,(IY+$01)                      ; $C6BE fd 7e 01
    AND $0F                            ; $C6C1 e6 0f
    JR NZ,$C6CB                        ; $C6C3 20 06
    OR $01                             ; $C6C5 f6 01
    RET                                ; $C6C7 c9
    JP $DC15                           ; $C6C8 c3 15 dc
    CP $05                             ; $C6CB fe 05
    JR C,$C6F5                         ; $C6CD 38 26
    CP $07                             ; $C6CF fe 07
    JR NC,$C719                        ; $C6D1 30 46
    LD A,($A035)                       ; $C6D3 3a 35 a0
    CP $FE                             ; $C6D6 fe fe
    JP NZ,$C654                        ; $C6D8 c2 54 c6
    LD HL,($A031)                      ; $C6DB 2a 31 a0
    LD A,(IY+$01)                      ; $C6DE fd 7e 01
    AND $0F                            ; $C6E1 e6 0f
    CP $05                             ; $C6E3 fe 05
    JR NZ,$C6EE                        ; $C6E5 20 07
    BIT 7,L                            ; $C6E7 cb 7d
    JR Z,$C6C5                         ; $C6E9 28 da
    JP $C654                           ; $C6EB c3 54 c6
    BIT 7,L                            ; $C6EE cb 7d
    JR NZ,$C6C5                        ; $C6F0 20 d3
    JP $C654                           ; $C6F2 c3 54 c6
    CP $03                             ; $C6F5 fe 03
    JR NC,$C706                        ; $C6F7 30 0d
    LD A,($A035)                       ; $C6F9 3a 35 a0
    CALL $D224                         ; $C6FC cd 24 d2
    BIT 7,(IX+$00)                     ; $C6FF dd cb 00 7e
    JP Z,$C654                         ; $C703 ca 54 c6
    BIT 0,(IY+$01)                     ; $C706 fd cb 01 46
    JR Z,$C6C5                         ; $C70A 28 b9
    LD A,($A035)                       ; $C70C 3a 35 a0
    CALL $D471                         ; $C70F cd 71 d4
    CP $FF                             ; $C712 fe ff
    JP Z,$C654                         ; $C714 ca 54 c6
    JR $C6C5                           ; $C717 18 ac
    LD A,($A035)                       ; $C719 3a 35 a0
    LD ($CB7A),A                       ; $C71C 32 7a cb
    LD C,A                             ; $C71F 4f
    LD A,(IY+$01)                      ; $C720 fd 7e 01
    CALL $C7A6                         ; $C723 cd a6 c7
    RET Z                              ; $C726 c8
    BIT 4,(IY+$00)                     ; $C727 fd cb 00 66
    JP Z,$C62F                         ; $C72B ca 2f c6
    LD A,(IY+$02)                      ; $C72E fd 7e 02
    LD L,(IY+$05)                      ; $C731 fd 6e 05
    LD H,(IY+$06)                      ; $C734 fd 66 06
    BIT 6,(IY+$00)                     ; $C737 fd cb 00 76
    JR Z,$C746                         ; $C73B 28 09
    LD A,(IY+$04)                      ; $C73D fd 7e 04
    LD L,(IY+$07)                      ; $C740 fd 6e 07
    LD H,(IY+$08)                      ; $C743 fd 66 08
    LD B,A                             ; $C746 47
    CALL $C74E                         ; $C747 cd 4e c7
    RET NZ                             ; $C74A c0
    JP $C6B8                           ; $C74B c3 b8 c6
; Valutazione maschere sul byte record+05.
    LD A,C                             ; $C74E 79
    CALL $D237                         ; $C74F cd 37 d2
    LD C,(IX+$05)                      ; $C752 dd 4e 05
    LD A,B                             ; $C755 78
    RRCA                               ; $C756 0f
    RRCA                               ; $C757 0f
    AND $03                            ; $C758 e6 03
    LD D,L                             ; $C75A 55
    CALL $C763                         ; $C75B cd 63 c7
    RET Z                              ; $C75E c8
    LD A,B                             ; $C75F 78
    AND $03                            ; $C760 e6 03
    LD D,H                             ; $C762 54
    JR NZ,$C76D                        ; $C763 20 08
    LD A,D                             ; $C765 7a
    AND C                              ; $C766 a1
    CP D                               ; $C767 ba
    JP Z,$C62F                         ; $C768 ca 2f c6
    JR $C792                           ; $C76B 18 25
    CP $01                             ; $C76D fe 01
    JR NZ,$C77B                        ; $C76F 20 0a
    LD A,D                             ; $C771 7a
    AND A                              ; $C772 a7
    JR Z,$C768                         ; $C773 28 f3
    AND C                              ; $C775 a1
    JR Z,$C795                         ; $C776 28 1d
    JP $C62F                           ; $C778 c3 2f c6
    CP $02                             ; $C77B fe 02
    JR NZ,$C788                        ; $C77D 20 09
    LD A,D                             ; $C77F 7a
    AND C                              ; $C780 a1
    JP Z,$C62F                         ; $C781 ca 2f c6
    OR $80                             ; $C784 f6 80
    JR $C797                           ; $C786 18 0f
    LD A,D                             ; $C788 7a
    AND C                              ; $C789 a1
    CP D                               ; $C78A ba
    JP NZ,$C62F                        ; $C78B c2 2f c6
    OR $80                             ; $C78E f6 80
    JR $C797                           ; $C790 18 05
    XOR $FF                            ; $C792 ee ff
    AND D                              ; $C794 a2
    AND $7F                            ; $C795 e6 7f
    LD ($CB79),A                       ; $C797 32 79 cb
; Una maschera fallita non e necessariamente eliminatoria nella fase A00B=0.
    LD A,($A00B)                       ; $C79A 3a 0b a0
    AND A                              ; $C79D a7
    JP Z,$C62F                         ; $C79E ca 2f c6
    LD HL,$CB7B                        ; $C7A1 21 7b cb
    XOR A                              ; $C7A4 af
    RET                                ; $C7A5 c9
; Selettore dei vincoli di tipo/accessibilita: il nibble appartiene alla regola, non ad A00F.
    AND $0F                            ; $C7A6 e6 0f
    CP $07                             ; $C7A8 fe 07
    JP Z,$C62F                         ; $C7AA ca 2f c6
    CP $08                             ; $C7AD fe 08
    JR NZ,$C7BB                        ; $C7AF 20 0a
    LD A,C                             ; $C7B1 79
    CALL $C821                         ; $C7B2 cd 21 c8
    JP Z,$C632                         ; $C7B5 ca 32 c6
    JP $C62F                           ; $C7B8 c3 2f c6
    CP $09                             ; $C7BB fe 09
    JR NZ,$C7E4                        ; $C7BD 20 25
    LD A,C                             ; $C7BF 79
    CALL $C821                         ; $C7C0 cd 21 c8
    JP Z,$C632                         ; $C7C3 ca 32 c6
    LD A,C                             ; $C7C6 79
    CALL $C8A7                         ; $C7C7 cd a7 c8
    JP NZ,$C632                        ; $C7CA c2 32 c6
    LD A,C                             ; $C7CD 79
    CALL $C8BE                         ; $C7CE cd be c8
    JP NZ,$C632                        ; $C7D1 c2 32 c6
    LD B,C                             ; $C7D4 41
    LD A,($A036)                       ; $C7D5 3a 36 a0
    CALL $C8C6                         ; $C7D8 cd c6 c8
    JP Z,$C632                         ; $C7DB ca 32 c6
    LD A,C                             ; $C7DE 79
    CALL $C8AF                         ; $C7DF cd af c8
    JR $C768                           ; $C7E2 18 84
    CP $0A                             ; $C7E4 fe 0a
    JR NZ,$C7F9                        ; $C7E6 20 11
    LD A,C                             ; $C7E8 79
    CALL $C821                         ; $C7E9 cd 21 c8
    JP Z,$C632                         ; $C7EC ca 32 c6
    LD A,C                             ; $C7EF 79
    CALL $D275                         ; $C7F0 cd 75 d2
    JP NC,$C632                        ; $C7F3 d2 32 c6
    JP $C62F                           ; $C7F6 c3 2f c6
    CP $0B                             ; $C7F9 fe 0b
    JR NZ,$C80A                        ; $C7FB 20 0d
    LD A,C                             ; $C7FD 79
    CALL $C821                         ; $C7FE cd 21 c8
    JP Z,$C632                         ; $C801 ca 32 c6
    LD A,C                             ; $C804 79
    CALL $C8A7                         ; $C805 cd a7 c8
    JR $C7B5                           ; $C808 18 ab
    CP $0C                             ; $C80A fe 0c
    JR NZ,$C814                        ; $C80C 20 06
    LD A,C                             ; $C80E 79
    CALL $C8BE                         ; $C80F cd be c8
    JR $C7B5                           ; $C812 18 a1
    LD A,C                             ; $C814 79
    CALL $C821                         ; $C815 cd 21 c8
    JP Z,$C632                         ; $C818 ca 32 c6
    LD A,C                             ; $C81B 79
    CALL $C8BE                         ; $C81C cd be c8
    JR $C7B5                           ; $C81F 18 94
; Filtro percettivo: contenitori, bit7 di +05, posizione del soggetto e lista locazioni.
    PUSH IX                            ; $C821 dd e5
    PUSH BC                            ; $C823 c5
    CALL $D237                         ; $C824 cd 37 d2
    LD B,A                             ; $C827 47
    LD A,($A036)                       ; $C828 3a 36 a0
    CALL $C863                         ; $C82B cd 63 c8
    CP B                               ; $C82E b8
    JR Z,$C85D                         ; $C82F 28 2c
    BIT 7,(IX+$05)                     ; $C831 dd cb 05 7e
    JR Z,$C85A                         ; $C835 28 23
    LD C,A                             ; $C837 4f
    LD A,B                             ; $C838 78
    LD B,C                             ; $C839 41
    CALL $C863                         ; $C83A cd 63 c8
    LD C,A                             ; $C83D 4f
    LD A,($A036)                       ; $C83E 3a 36 a0
    CP C                               ; $C841 b9
    JR Z,$C85D                         ; $C842 28 19
    LD A,C                             ; $C844 79
    CP B                               ; $C845 b8
    JR NZ,$C85A                        ; $C846 20 12
    INC A                              ; $C848 3c
    JR NZ,$C85D                        ; $C849 20 12
    LD B,(IX+$00)                      ; $C84B dd 46 00
    LD A,($A00A)                       ; $C84E 3a 0a a0
    CP (IX+$0F)                        ; $C851 dd be 0f
    JR Z,$C85D                         ; $C854 28 07
    INC IX                             ; $C856 dd 23
    DJNZ $C851                         ; $C858 10 f7
    XOR A                              ; $C85A af
    JR $C85F                           ; $C85B 18 02
    OR $01                             ; $C85D f6 01
    POP BC                             ; $C85F c1
    POP IX                             ; $C860 dd e1
    RET                                ; $C862 c9
    PUSH IX                            ; $C863 dd e5
    CALL $D237                         ; $C865 cd 37 d2
    CALL $C86E                         ; $C868 cd 6e c8
    POP IX                             ; $C86B dd e1
    RET                                ; $C86D c9
; Risalita dei contenitori; bit7, bit5 e bit3 del byte+05.
    PUSH IX                            ; $C86E dd e5
    EX AF,AF'                          ; $C870 08
    LD A,$FF                           ; $C871 3e ff
    EX AF,AF'                          ; $C873 08
    LD A,(IX+$01)                      ; $C874 dd 7e 01
    CP $FF                             ; $C877 fe ff
    JR Z,$C895                         ; $C879 28 1a
    EX AF,AF'                          ; $C87B 08
    LD A,(IX+$01)                      ; $C87C dd 7e 01
    CALL $D237                         ; $C87F cd 37 d2
    BIT 7,(IX+$05)                     ; $C882 dd cb 05 7e
    JR Z,$C894                         ; $C886 28 0c
    BIT 5,(IX+$05)                     ; $C888 dd cb 05 6e
    JR NZ,$C873                        ; $C88C 20 e5
    BIT 3,(IX+$05)                     ; $C88E dd cb 05 5e
    JR NZ,$C873                        ; $C892 20 df
    EX AF,AF'                          ; $C894 08
    POP IX                             ; $C895 dd e1
    RET                                ; $C897 c9
    CALL $C89E                         ; $C898 cd 9e c8
    CALL $C86E                         ; $C89B cd 6e c8
    PUSH IX                            ; $C89E dd e5
    PUSH IY                            ; $C8A0 fd e5
    POP IX                             ; $C8A2 dd e1
    POP IY                             ; $C8A4 fd e1
    RET                                ; $C8A6 c9
; Verifica occorrenza unica: record+00 ==1.
    CALL $D237                         ; $C8A7 cd 37 d2
    LD A,(IX+$00)                      ; $C8AA dd 7e 00
    DEC A                              ; $C8AD 3d
    RET                                ; $C8AE c9
; Risalita dei genitori e controllo categoria persona.
    CALL $D237                         ; $C8AF cd 37 d2
    LD A,(IX+$01)                      ; $C8B2 dd 7e 01
    CP $FF                             ; $C8B5 fe ff
    RET Z                              ; $C8B7 c8
    CALL $C8BE                         ; $C8B8 cd be c8
    RET NZ                             ; $C8BB c0
    JR $C8B2                           ; $C8BC 18 f4
; Test di categoria persona: bit6 di record+05.
    CALL $D237                         ; $C8BE cd 37 d2
    BIT 6,(IX+$05)                     ; $C8C1 dd cb 05 76
    RET                                ; $C8C5 c9
; Confronto quantitativo fra contenitore, oggetto e contenuti usando campo+03.
    PUSH BC                            ; $C8C6 c5
    PUSH AF                            ; $C8C7 f5
    LD A,B                             ; $C8C8 78
    CALL $D237                         ; $C8C9 cd 37 d2
    LD A,B                             ; $C8CC 78
    CALL $D2F2                         ; $C8CD cd f2 d2
    ADD A,(IX+$03)                     ; $C8D0 dd 86 03
    JR NC,$C8D7                        ; $C8D3 30 02
    LD A,$FF                           ; $C8D5 3e ff
    LD B,A                             ; $C8D7 47
    POP AF                             ; $C8D8 f1
    LD C,A                             ; $C8D9 4f
    CALL $D237                         ; $C8DA cd 37 d2
    LD A,C                             ; $C8DD 79
    CALL $D2F2                         ; $C8DE cd f2 d2
    SUB (IX+$03)                       ; $C8E1 dd 96 03
    NEG                                ; $C8E4 ed 44
    SUB B                              ; $C8E6 90
    POP BC                             ; $C8E7 c1
    JR C,$C8ED                         ; $C8E8 38 03
    OR $01                             ; $C8EA f6 01
    RET                                ; $C8EC c9
    XOR A                              ; $C8ED af
    RET                                ; $C8EE c9
; Prepara A013/A015 come puntatori a record entita o locazioni secondo le classi.
    LD A,($A034)                       ; $C8EF 3a 34 a0
    CP $FE                             ; $C8F2 fe fe
    JR NC,$C90C                        ; $C8F4 30 16
    LD A,($A00F)                       ; $C8F6 3a 0f a0
    CP $05                             ; $C8F9 fe 05
    LD A,($A034)                       ; $C8FB 3a 34 a0
    JR NC,$C905                        ; $C8FE 30 05
    CALL $D224                         ; $C900 cd 24 d2
    JR $C908                           ; $C903 18 03
    CALL $D237                         ; $C905 cd 37 d2
    LD ($A013),IX                      ; $C908 dd 22 13 a0
    LD A,($A035)                       ; $C90C 3a 35 a0
    CP $FE                             ; $C90F fe fe
    RET NC                             ; $C911 d0
    LD A,($A010)                       ; $C912 3a 10 a0
    CP $05                             ; $C915 fe 05
    LD A,($A035)                       ; $C917 3a 35 a0
    JR NC,$C921                        ; $C91A 30 05
    CALL $D224                         ; $C91C cd 24 d2
    JR $C924                           ; $C91F 18 03
    CALL $D237                         ; $C921 cd 37 d2
    LD ($A015),IX                      ; $C924 dd 22 15 a0
    RET                                ; $C928 c9
; Seleziona regola del personaggio, regola dell oggetto o regola generale.
    CALL $C8EF                         ; $C929 cd ef c8
    LD A,($A034)                       ; $C92C 3a 34 a0
    CP $FE                             ; $C92F fe fe
    JR NC,$C972                        ; $C931 30 3f
    LD IX,($A017)                      ; $C933 dd 2a 17 a0
    BIT 6,(IX+$05)                     ; $C937 dd cb 05 76
    JR Z,$C94D                         ; $C93B 28 10
; Cerca marcatore zero nella coda dell attore; poi cerca azione con passo2.
    XOR A                              ; $C93D af
    CALL $D1DC                         ; $C93E cd dc d1
    JR NC,$C94D                        ; $C941 30 0a
    LD A,($A033)                       ; $C943 3a 33 a0
    CALL $D349                         ; $C946 cd 49 d3
    CP $FF                             ; $C949 fe ff
    JR NZ,$C960                        ; $C94B 20 13
    LD A,($A00F)                       ; $C94D 3a 0f a0
    CP $07                             ; $C950 fe 07
    JR C,$C972                         ; $C952 38 1e
; Cerca azione nella coda del primo oggetto.
    LD IX,($A013)                      ; $C954 dd 2a 13 a0
    LD A,($A033)                       ; $C958 3a 33 a0
    CALL $D1DC                         ; $C95B cd dc d1
    JR NC,$C972                        ; $C95E 30 12
; Byte indice -> word nella tabella AA71.
    LD A,(IX+$01)                      ; $C960 dd 7e 01
    LD E,A                             ; $C963 5f
    LD D,$00                           ; $C964 16 00
    LD HL,$AA71                        ; $C966 21 71 aa
    DEC DE                             ; $C969 1b
    ADD HL,DE                          ; $C96A 19
    ADD HL,DE                          ; $C96B 19
    LD E,(HL)                          ; $C96C 5e
    INC HL                             ; $C96D 23
    LD D,(HL)                          ; $C96E 56
    EX DE,HL                           ; $C96F eb
    JR $C996                           ; $C970 18 24
; Fallback: indice globale azioni a9F38.
    LD A,($A033)                       ; $C972 3a 33 a0
    LD IX,$9F38                        ; $C975 dd 21 38 9f
    CALL $D34E                         ; $C979 cd 4e d3
    CP $FF                             ; $C97C fe ff
    JP Z,$DC15                         ; $C97E ca 15 dc
    LD L,(IX+$01)                      ; $C981 dd 6e 01
    LD H,(IX+$02)                      ; $C984 dd 66 02
    JR $C996                           ; $C987 18 0d
    PUSH IX                            ; $C989 dd e5
    POP HL                             ; $C98B e1
    PUSH HL                            ; $C98C e5
    CALL $C8EF                         ; $C98D cd ef c8
    CALL $C996                         ; $C990 cd 96 c9
    POP IX                             ; $C993 dd e1
    RET                                ; $C995 c9
    PUSH IY                            ; $C996 fd e5
    PUSH BC                            ; $C998 c5
    CALL $C9BF                         ; $C999 cd bf c9
    POP BC                             ; $C99C c1
    POP IY                             ; $C99D fd e1
    JR C,$C9A7                         ; $C99F 38 06
    JP Z,$CB43                         ; $C9A1 ca 43 cb
    OR $01                             ; $C9A4 f6 01
    RET                                ; $C9A6 c9
    PUSH HL                            ; $C9A7 e5
    PUSH BC                            ; $C9A8 c5
    LD HL,($9FD9)                      ; $C9A9 2a d9 9f
    LD B,$01                           ; $C9AC 06 01
    CALL $CF80                         ; $C9AE cd 80 cf
    POP BC                             ; $C9B1 c1
    POP HL                             ; $C9B2 e1
    LD IX,($9FDB)                      ; $C9B3 dd 2a db 9f
    LD (IX+$01),L                      ; $C9B7 dd 75 01
    LD (IX+$02),H                      ; $C9BA dd 74 02
    SCF                                ; $C9BD 37
    RET                                ; $C9BE c9
    PUSH HL                            ; $C9BF e5
    POP IY                             ; $C9C0 fd e1
    CALL $D078                         ; $C9C2 cd 78 d0
    JR NC,$C9D3                        ; $C9C5 30 0c
    LD A,(IY+$00)                      ; $C9C7 fd 7e 00
    AND $20                            ; $C9CA e6 20
    JR Z,$C9D3                         ; $C9CC 28 05
    LD HL,$CBBB                        ; $C9CE 21 bb cb
    XOR A                              ; $C9D1 af
    RET                                ; $C9D2 c9
    CALL $C628                         ; $C9D3 cd 28 c6
    JR Z,$C9D1                         ; $C9D6 28 f9
    CALL $C6BE                         ; $C9D8 cd be c6
    JR Z,$C9D1                         ; $C9DB 28 f4
    BIT 6,(IY+$00)                     ; $C9DD fd cb 00 76
    JR Z,$C9F2                         ; $C9E1 28 0f
    LD L,(IY+$02)                      ; $C9E3 fd 6e 02
    LD H,(IY+$03)                      ; $C9E6 fd 66 03
    PUSH IY                            ; $C9E9 fd e5
    CALL $CB34                         ; $C9EB cd 34 cb
    POP IY                             ; $C9EE fd e1
    JR Z,$C9D1                         ; $C9F0 28 df
; Se A00B=0 ritorna prima di eseguire il corpo della regola.
    LD A,($A00B)                       ; $C9F2 3a 0b a0
    AND A                              ; $C9F5 a7
    JR NZ,$C9FB                        ; $C9F6 20 03
    OR $01                             ; $C9F8 f6 01
    RET                                ; $C9FA c9

    ORG $D04F
; CODE fino a $D059
; IX = indice entita meno3; D206 avanza prima di leggere.
    LD IX,$8B6F                        ; $D04F dd 21 6f 8b
    DEC IX                             ; $D053 dd 2b
    DEC IX                             ; $D055 dd 2b
    DEC IX                             ; $D057 dd 2b
    RET                                ; $D059 c9

    ORG $D1DC
; CODE fino a $D223
; Avanza di 0F+numero_locazioni; cerca coppie azione/indice, si ferma su FF o zero.
    PUSH DE                            ; $D1DC d5
    LD D,A                             ; $D1DD 57
    LD A,(IX+$00)                      ; $D1DE dd 7e 00
    ADD A,$0F                          ; $D1E1 c6 0f
    LD E,A                             ; $D1E3 5f
    LD A,D                             ; $D1E4 7a
    LD D,$00                           ; $D1E5 16 00
    ADD IX,DE                          ; $D1E7 dd 19
    POP DE                             ; $D1E9 d1
    CP (IX+$00)                        ; $D1EA dd be 00
    JR Z,$D1FF                         ; $D1ED 28 10
    INC (IX+$00)                       ; $D1EF dd 34 00
    JR Z,$D201                         ; $D1F2 28 0d
    DEC (IX+$00)                       ; $D1F4 dd 35 00
    JR Z,$D204                         ; $D1F7 28 0b
    INC IX                             ; $D1F9 dd 23
    INC IX                             ; $D1FB dd 23
    JR $D1EA                           ; $D1FD 18 eb
    SCF                                ; $D1FF 37
    RET                                ; $D200 c9
    DEC (IX+$00)                       ; $D201 dd 35 00
    XOR A                              ; $D204 af
    RET                                ; $D205 c9
; Passo3 dell indice: IX punta alla tripletta, IY al record.
    EXX                                ; $D206 d9
    LD DE,$0003                        ; $D207 11 03 00
    ADD IX,DE                          ; $D20A dd 19
    LD D,(IX+$02)                      ; $D20C dd 56 02
    LD E,(IX+$01)                      ; $D20F dd 5e 01
    PUSH DE                            ; $D212 d5
    POP IY                             ; $D213 fd e1
    LD A,(IX+$00)                      ; $D215 dd 7e 00
    CP $FF                             ; $D218 fe ff
    EXX                                ; $D21A d9
    RET                                ; $D21B c9
    PUSH BC                            ; $D21C c5
    LD B,A                             ; $D21D 47
    CALL $D206                         ; $D21E cd 06 d2
    LD A,B                             ; $D221 78
    POP BC                             ; $D222 c1
    RET                                ; $D223 c9

    ORG $D237
; CODE fino a $D29C
; Lookup entita: A=ID -> IX=record, usando indice8B6F e ricercaD34E.
    LD IX,$8B6F                        ; $D237 dd 21 6f 8b
    CALL $D34E                         ; $D23B cd 4e d3
    PUSH HL                            ; $D23E e5
    LD L,(IX+$01)                      ; $D23F dd 6e 01
    LD H,(IX+$02)                      ; $D242 dd 66 02
    EX (SP),HL                         ; $D245 e3
    POP IX                             ; $D246 dd e1
    RET                                ; $D248 c9
; Aggiorna posizione dei discendenti secondo parent_id, ricorsivamente.
    PUSH IY                            ; $D249 fd e5
    PUSH IX                            ; $D24B dd e5
    CALL $D04F                         ; $D24D cd 4f d0
    CALL $D21C                         ; $D250 cd 1c d2
    JR Z,$D267                         ; $D253 28 12
    CP (IY+$01)                        ; $D255 fd be 01
    JR NZ,$D250                        ; $D258 20 f6
    LD (IY+$0F),B                      ; $D25A fd 70 0f
    PUSH AF                            ; $D25D f5
    LD A,(IX+$00)                      ; $D25E dd 7e 00
    CALL $D249                         ; $D261 cd 49 d2
    POP AF                             ; $D264 f1
    JR $D250                           ; $D265 18 e9
    POP IX                             ; $D267 dd e1
    POP IY                             ; $D269 fd e1
    RET                                ; $D26B c9
    PUSH HL                            ; $D26C e5
    LD A,($A034)                       ; $D26D 3a 34 a0
    CALL $D275                         ; $D270 cd 75 d2
    POP HL                             ; $D273 e1
    RET                                ; $D274 c9
; Verifica catena di possesso rispetto al soggetto A036; FE/FF speciali.
    LD HL,$A036                        ; $D275 21 36 a0
    CP $FF                             ; $D278 fe ff
    SCF                                ; $D27A 37
    RET Z                              ; $D27B c8
    CP $FE                             ; $D27C fe fe
    SCF                                ; $D27E 37
    RET Z                              ; $D27F c8
    PUSH IX                            ; $D280 dd e5
    CALL $D288                         ; $D282 cd 88 d2
    POP IX                             ; $D285 dd e1
    RET                                ; $D287 c9
    CALL $D237                         ; $D288 cd 37 d2
    PUSH AF                            ; $D28B f5
    LD A,(IX+$01)                      ; $D28C dd 7e 01
    CP $FF                             ; $D28F fe ff
    JR Z,$D29A                         ; $D291 28 07
    POP IX                             ; $D293 dd e1
    CP (HL)                            ; $D295 be
    JR NZ,$D288                        ; $D296 20 f0
    SCF                                ; $D298 37
    RET                                ; $D299 c9
    POP AF                             ; $D29A f1
    AND A                              ; $D29B a7
    RET                                ; $D29C c9

    ORG $D2ED
; CODE fino a $D33B
; Somma campo+02 dei figli diretti (B=1).
    PUSH BC                            ; $D2ED c5
    LD B,$01                           ; $D2EE 06 01
    JR $D2F5                           ; $D2F0 18 03
; Somma ricorsiva campo+03 dei contenuti (B=0).
    PUSH BC                            ; $D2F2 c5
    LD B,$00                           ; $D2F3 06 00
    PUSH IX                            ; $D2F5 dd e5
    PUSH IY                            ; $D2F7 fd e5
    LD C,$00                           ; $D2F9 0e 00
    CALL $D305                         ; $D2FB cd 05 d3
    LD A,C                             ; $D2FE 79
    POP IY                             ; $D2FF fd e1
    POP IX                             ; $D301 dd e1
    POP BC                             ; $D303 c1
    RET                                ; $D304 c9
    PUSH IX                            ; $D305 dd e5
    LD IX,$8B6F                        ; $D307 dd 21 6f 8b
    CALL $D21C                         ; $D30B cd 1c d2
    JR Z,$D334                         ; $D30E 28 24
    CP (IY+$01)                        ; $D310 fd be 01
    JR NZ,$D30B                        ; $D313 20 f6
    PUSH AF                            ; $D315 f5
    SUB A                              ; $D316 97
    CP B                               ; $D317 b8
    LD A,C                             ; $D318 79
    JR Z,$D324                         ; $D319 28 09
    ADD A,(IY+$02)                     ; $D31B fd 86 02
    JP PE,$D337                        ; $D31E ea 37 d3
    LD C,A                             ; $D321 4f
    JR $D331                           ; $D322 18 0d
    ADD A,(IY+$03)                     ; $D324 fd 86 03
    JP PE,$D337                        ; $D327 ea 37 d3
    LD C,A                             ; $D32A 4f
    LD A,(IX+$00)                      ; $D32B dd 7e 00
    CALL $D305                         ; $D32E cd 05 d3
    POP AF                             ; $D331 f1
    JR $D30B                           ; $D332 18 d7
    POP IX                             ; $D334 dd e1
    RET                                ; $D336 c9
    POP AF                             ; $D337 f1
    LD C,$FF                           ; $D338 0e ff
    JR $D334                           ; $D33A 18 f8

    ORG $D349
; CODE fino a $D447
; Ricerca ID in coppie (passo2).
    EXX                                ; $D349 d9
    LD E,$02                           ; $D34A 1e 02
    JR $D351                           ; $D34C 18 03
; Ricerca ID in triplette (passo3).
    EXX                                ; $D34E d9
    LD E,$03                           ; $D34F 1e 03
    PUSH IX                            ; $D351 dd e5
    POP HL                             ; $D353 e1
    LD B,A                             ; $D354 47
    LD D,$00                           ; $D355 16 00
    LD A,(HL)                          ; $D357 7e
    CP B                               ; $D358 b8
    JR Z,$D363                         ; $D359 28 08
    CP $FF                             ; $D35B fe ff
    JR Z,$D363                         ; $D35D 28 04
    ADD HL,DE                          ; $D35F 19
    JP $D357                           ; $D360 c3 57 d3
    PUSH HL                            ; $D363 e5
    POP IX                             ; $D364 dd e1
    CP $FF                             ; $D366 fe ff
    EXX                                ; $D368 d9
    RET                                ; $D369 c9
; Matching delle entita: nome+qualificatori a record+07 e filtro C821.
    PUSH BC                            ; $D36A c5
    PUSH DE                            ; $D36B d5
    PUSH IY                            ; $D36C fd e5
    CALL $D206                         ; $D36E cd 06 d2
    JR Z,$D393                         ; $D371 28 20
    LD BC,$0007                        ; $D373 01 07 00
    PUSH IY                            ; $D376 fd e5
    ADD IY,BC                          ; $D378 fd 09
    CALL $A4E0                         ; $D37A cd e0 a4
    POP IY                             ; $D37D fd e1
    JR NZ,$D36E                        ; $D37F 20 ed
    LD A,($A038)                       ; $D381 3a 38 a0
    AND A                              ; $D384 a7
    JR NZ,$D393                        ; $D385 20 0c
    LD A,(IX+$00)                      ; $D387 dd 7e 00
    PUSH IX                            ; $D38A dd e5
    CALL $C821                         ; $D38C cd 21 c8
    POP IX                             ; $D38F dd e1
    JR Z,$D36E                         ; $D391 28 db
    LD A,(IX+$00)                      ; $D393 dd 7e 00
    POP IY                             ; $D396 fd e1
    POP DE                             ; $D398 d1
    POP BC                             ; $D399 c1
    RET                                ; $D39A c9
; Matching delle locazioni: indice840B; spazio ID distinto da quello delle entita.
    PUSH IY                            ; $D39B fd e5
    PUSH DE                            ; $D39D d5
    PUSH BC                            ; $D39E c5
    PUSH IX                            ; $D39F dd e5
    POP BC                             ; $D3A1 c1
    LD DE,$0001                        ; $D3A2 11 01 00
    INC B                              ; $D3A5 04
    LD A,B                             ; $D3A6 78
    CP $6A                             ; $D3A7 fe 6a
    LD A,$FF                           ; $D3A9 3e ff
    JR Z,$D3CD                         ; $D3AB 28 20
    LD A,B                             ; $D3AD 78
    CALL $D224                         ; $D3AE cd 24 d2
    PUSH IX                            ; $D3B1 dd e5
    POP IY                             ; $D3B3 fd e1
    ADD IY,DE                          ; $D3B5 fd 19
    CALL $A4E0                         ; $D3B7 cd e0 a4
    JR NZ,$D3A5                        ; $D3BA 20 e9
    LD A,($A038)                       ; $D3BC 3a 38 a0
    AND A                              ; $D3BF a7
    JR NZ,$D3CC                        ; $D3C0 20 0a
    PUSH BC                            ; $D3C2 c5
    LD A,B                             ; $D3C3 78
    CALL $D471                         ; $D3C4 cd 71 d4
    POP BC                             ; $D3C7 c1
    CP $FF                             ; $D3C8 fe ff
    JR Z,$D3A5                         ; $D3CA 28 d9
    LD A,B                             ; $D3CC 78
    PUSH BC                            ; $D3CD c5
    POP IX                             ; $D3CE dd e1
    POP BC                             ; $D3D0 c1
    POP DE                             ; $D3D1 d1
    POP IY                             ; $D3D2 fd e1
    RET                                ; $D3D4 c9
; Stampa nome dell entita da IX; D3E8 riceve puntatore a record+07.
    PUSH IX                            ; $D3D5 dd e5
    POP IY                             ; $D3D7 fd e1
    PUSH IY                            ; $D3D9 fd e5
    PUSH DE                            ; $D3DB d5
    LD DE,$0007                        ; $D3DC 11 07 00
    ADD IY,DE                          ; $D3DF fd 19
    CALL $D3E8                         ; $D3E1 cd e8 d3
    POP DE                             ; $D3E4 d1
    POP IY                             ; $D3E5 fd e1
    RET                                ; $D3E7 c9
    PUSH AF                            ; $D3E8 f5
    PUSH DE                            ; $D3E9 d5
    LD D,(IY+$01)                      ; $D3EA fd 56 01
    LD E,(IY+$00)                      ; $D3ED fd 5e 00
    CALL $A7D0                         ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                     ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                        ; $D3F7 20 04
    XOR A                              ; $D3F9 af
    LD ($A7EA),A                       ; $D3FA 32 ea a7
; Bit5 di +06: il campo+09 non e un qualificatore lessicale (denaro).
    BIT 5,(IY-$01)                     ; $D3FD fd cb ff 6e
    JR NZ,$D427                        ; $D401 20 24
    JR $D416                           ; $D403 18 11
    PUSH AF                            ; $D405 f5
    PUSH DE                            ; $D406 d5
    LD D,(IY+$01)                      ; $D407 fd 56 01
    LD E,(IY+$00)                      ; $D40A fd 5e 00
    CALL $A7D0                         ; $D40D cd d0 a7
    LD A,($A028)                       ; $D410 3a 28 a0
    AND A                              ; $D413 a7
    JR NZ,$D438                        ; $D414 20 22
    LD E,(IY+$02)                      ; $D416 fd 5e 02
    LD D,(IY+$03)                      ; $D419 fd 56 03
    RES 7,D                            ; $D41C cb ba
    BIT 7,(IY+$03)                     ; $D41E fd cb 03 7e
    LD A,$40                           ; $D422 3e 40
    CALL Z,$A815                       ; $D424 cc 15 a8
    LD E,(IY+$04)                      ; $D427 fd 5e 04
    LD D,(IY+$05)                      ; $D42A fd 56 05
    RES 7,D                            ; $D42D cb ba
    BIT 7,(IY+$05)                     ; $D42F fd cb 05 7e
    LD A,$40                           ; $D433 3e 40
    CALL Z,$A815                       ; $D435 cc 15 a8
    LD E,(IY+$00)                      ; $D438 fd 5e 00
    LD D,(IY+$01)                      ; $D43B fd 56 01
    LD A,D                             ; $D43E 7a
    OR E                               ; $D43F b3
    LD A,$50                           ; $D440 3e 50
    CALL NZ,$A815                      ; $D442 c4 15 a8
    POP DE                             ; $D445 d1
    POP AF                             ; $D446 f1
    RET                                ; $D447 c9

    ORG $D495
; CODE fino a $D58F
; Restituisce locazione+0F solo se occorrenza unica, altrimenti FF.
    CP $FF                             ; $D495 fe ff
    RET Z                              ; $D497 c8
    CALL $D237                         ; $D498 cd 37 d2
    LD A,$01                           ; $D49B 3e 01
    CP (IX+$00)                        ; $D49D dd be 00
    LD A,$FF                           ; $D4A0 3e ff
    RET NZ                             ; $D4A2 c0
    LD A,(IX+$0F)                      ; $D4A3 dd 7e 0f
    RET                                ; $D4A6 c9
    PUSH IY                            ; $D4A7 fd e5
    PUSH AF                            ; $D4A9 f5
    PUSH BC                            ; $D4AA c5
    LD A,$FF                           ; $D4AB 3e ff
    CALL $D4CC                         ; $D4AD cd cc d4
    JR Z,$D4C7                         ; $D4B0 28 15
    PUSH AF                            ; $D4B2 f5
    LD HL,$68E4                        ; $D4B3 21 e4 68
    CALL $A59F                         ; $D4B6 cd 9f a5
    POP BC                             ; $D4B9 c1
    LD C,B                             ; $D4BA 48
    LD A,$FF                           ; $D4BB 3e ff
    LD IY,($A017)                      ; $D4BD fd 2a 17 a0
    LD B,(IY+$0F)                      ; $D4C1 fd 46 0f
    CALL $D51A                         ; $D4C4 cd 1a d5
    POP BC                             ; $D4C7 c1
    POP AF                             ; $D4C8 f1
    POP IY                             ; $D4C9 fd e1
    RET                                ; $D4CB c9
    PUSH IX                            ; $D4CC dd e5
    PUSH IY                            ; $D4CE fd e5
    PUSH HL                            ; $D4D0 e5
    PUSH BC                            ; $D4D1 c5
    CALL $D04F                         ; $D4D2 cd 4f d0
    LD B,$00                           ; $D4D5 06 00
    LD C,A                             ; $D4D7 4f
    CALL $D206                         ; $D4D8 cd 06 d2
    JR Z,$D4E6                         ; $D4DB 28 09
    LD A,C                             ; $D4DD 79
    CALL $D4EF                         ; $D4DE cd ef d4
    JR NC,$D4D8                        ; $D4E1 30 f5
    INC B                              ; $D4E3 04
    JR $D4D8                           ; $D4E4 18 f2
    LD A,B                             ; $D4E6 78
    AND A                              ; $D4E7 a7
    POP BC                             ; $D4E8 c1
    POP HL                             ; $D4E9 e1
    POP IY                             ; $D4EA fd e1
    POP IX                             ; $D4EC dd e1
    RET                                ; $D4EE c9
    CP (IY+$01)                        ; $D4EF fd be 01
    JR NZ,$D518                        ; $D4F2 20 24
    LD A,($A036)                       ; $D4F4 3a 36 a0
    CP (IX+$00)                        ; $D4F7 dd be 00
    JR Z,$D518                         ; $D4FA 28 1c
    LD A,(IX+$00)                      ; $D4FC dd 7e 00
    CALL $C821                         ; $D4FF cd 21 c8
    JR Z,$D518                         ; $D502 28 14
    LD A,(IY+$00)                      ; $D504 fd 7e 00
    CP $02                             ; $D507 fe 02
    JR NC,$D518                        ; $D509 30 0d
    LD A,($A036)                       ; $D50B 3a 36 a0
    PUSH IX                            ; $D50E dd e5
    POP HL                             ; $D510 e1
    CALL $D278                         ; $D511 cd 78 d2
    JR C,$D518                         ; $D514 38 02
    SCF                                ; $D516 37
    RET                                ; $D517 c9
    AND A                              ; $D518 a7
    RET                                ; $D519 c9
    PUSH IY                            ; $D51A fd e5
    PUSH DE                            ; $D51C d5
    PUSH BC                            ; $D51D c5
    CALL $D526                         ; $D51E cd 26 d5
    POP BC                             ; $D521 c1
    POP DE                             ; $D522 d1
    POP IY                             ; $D523 fd e1
    RET                                ; $D525 c9
    PUSH IX                            ; $D526 dd e5
    CALL $D04F                         ; $D528 cd 4f d0
    PUSH AF                            ; $D52B f5
    CALL $D57D                         ; $D52C cd 7d d5
    JR C,$D55A                         ; $D52F 38 29
; Imposta bit7 di+06 quando enumera un oggetto nella descrizione della scena.
    SET 7,(IY+$06)                     ; $D531 fd cb 06 fe
    SUB A                              ; $D535 97
    LD ($A028),A                       ; $D536 32 28 a0
    CALL $D3D9                         ; $D539 cd d9 d3
    DEC C                              ; $D53C 0d
    LD A,C                             ; $D53D 79
    AND A                              ; $D53E a7
    JR NZ,$D546                        ; $D53F 20 05
    CALL $A414                         ; $D541 cd 14 a4
    JR $D557                           ; $D544 18 11
    CP $01                             ; $D546 fe 01
    JR Z,$D551                         ; $D548 28 07
    LD A,$2C                           ; $D54A 3e 2c
    CALL $A9B7                         ; $D54C cd b7 a9
    JR $D557                           ; $D54F 18 06
    LD DE,$005D                        ; $D551 11 5d 00
    CALL $A887                         ; $D554 cd 87 a8
    POP AF                             ; $D557 f1
    JR $D52B                           ; $D558 18 d1
    POP AF                             ; $D55A f1
    CALL $D04F                         ; $D55B cd 4f d0
    PUSH AF                            ; $D55E f5
    CALL $D57D                         ; $D55F cd 7d d5
    JR C,$D578                         ; $D562 38 14
    PUSH AF                            ; $D564 f5
    CALL $D4CC                         ; $D565 cd cc d4
    JR Z,$D574                         ; $D568 28 0a
    LD C,A                             ; $D56A 4f
    POP AF                             ; $D56B f1
    CALL $D590                         ; $D56C cd 90 d5
    CALL $D526                         ; $D56F cd 26 d5
    JR $D575                           ; $D572 18 01
    POP AF                             ; $D574 f1
    POP AF                             ; $D575 f1
    JR $D55E                           ; $D576 18 e6
    POP AF                             ; $D578 f1
    POP IX                             ; $D579 dd e1
    RET                                ; $D57B c9
    POP AF                             ; $D57C f1
    CALL $D21C                         ; $D57D cd 1c d2
    JR NZ,$D584                        ; $D580 20 02
    SCF                                ; $D582 37
    RET                                ; $D583 c9
    PUSH AF                            ; $D584 f5
    CALL $D4EF                         ; $D585 cd ef d4
    JR NC,$D57C                        ; $D588 30 f2
    POP AF                             ; $D58A f1
    LD A,(IX+$00)                      ; $D58B dd 7e 00
    AND A                              ; $D58E a7
    RET                                ; $D58F c9

    ORG $D5C9
; DATA fino a $D5D2
; Cinque riferimenti LE: in/on/behind/under/tied.
    DEFB $50,$04,$FF,$05,$DC,$00,$19,$09 ; $D5C9 50 04 ff 05 dc 00 19 09
    DEFB $D3,$08                       ; $D5D1 d3 08

    ORG $D5D3
; CODE fino a $D5EE
; Parte bassa (3bit) di+04: relazione per presentare il contenuto del contenitore.
    LD HL,$D5C9                        ; $D5D3 21 c9 d5
    LD A,(IX+$04)                      ; $D5D6 dd 7e 04
    AND $07                            ; $D5D9 e6 07
    CP $05                             ; $D5DB fe 05
    PUSH AF                            ; $D5DD f5
    DEC A                              ; $D5DE 3d
    LD E,A                             ; $D5DF 5f
    LD D,$00                           ; $D5E0 16 00
    ADD HL,DE                          ; $D5E2 19
    ADD HL,DE                          ; $D5E3 19
    CALL $A880                         ; $D5E4 cd 80 a8
    POP AF                             ; $D5E7 f1
    RET NZ                             ; $D5E8 c0
    LD DE,$08DB                        ; $D5E9 11 db 08
    JP $A887                           ; $D5EC c3 87 a8

    ORG $DF2E
; CODE fino a $DF3F
; Predicato di EXAMINE: considera catena di possesso.
    LD A,($A034)                       ; $DF2E 3a 34 a0
    CALL $C8AF                         ; $DF31 cd af c8
    JR Z,$DF3D                         ; $DF34 28 07
    LD HL,$A036                        ; $DF36 21 36 a0
    CP (HL)                            ; $DF39 be
    JP NZ,$DC15                        ; $DF3A c2 15 dc
    OR $01                             ; $DF3D f6 01
    RET                                ; $DF3F c9

    ORG $DF49
; CODE fino a $DF7D
    LD A,$01                           ; $DF49 3e 01
    LD ($CAAE),A                       ; $DF4B 32 ae ca
    CALL $DC6C                         ; $DF4E cd 6c dc
    RET NZ                             ; $DF51 c0
    CALL $DF5B                         ; $DF52 cd 5b df
    CALL $A2A2                         ; $DF55 cd a2 a2
    OR $01                             ; $DF58 f6 01
    RET                                ; $DF5A c9
; EXAMINE: imposta bit6 di+06, stampa descrizione +0D/0E oppure nome generico.
    LD A,($A034)                       ; $DF5B 3a 34 a0
    CALL $D237                         ; $DF5E cd 37 d2
    SET 6,(IX+$06)                     ; $DF61 dd cb 06 f6
    LD L,(IX+$0D)                      ; $DF65 dd 6e 0d
    LD H,(IX+$0E)                      ; $DF68 dd 66 0e
    LD A,H                             ; $DF6B 7c
    OR L                               ; $DF6C b5
    JP NZ,$A59F                        ; $DF6D c2 9f a5
    LD HL,$68E1                        ; $DF70 21 e1 68
    CALL $A59F                         ; $DF73 cd 9f a5
    CALL $D3D5                         ; $DF76 cd d5 d3
    LD A,$2E                           ; $DF79 3e 2e
    JP $A9B7                           ; $DF7B c3 b7 a9

    ORG $E31C
; CODE fino a $E327
; COUNT: richiede bit5 di+06 (campo monetario).
    LD IX,($A013)                      ; $E31C dd 2a 13 a0
    BIT 5,(IX+$06)                     ; $E320 dd cb 06 6e
    JP Z,$DC15                         ; $E324 ca 15 dc
    RET                                ; $E327 c9

    ORG $E32C
; CODE fino a $E344
; Stampa il valore +09/+0A tramiteA419.
    LD HL,$6836                        ; $E32C 21 36 68
    CALL $A59F                         ; $E32F cd 9f a5
    LD IX,($A013)                      ; $E332 dd 2a 13 a0
    LD L,(IX+$09)                      ; $E336 dd 6e 09
    LD H,(IX+$0A)                      ; $E339 dd 66 0a
    CALL $A419                         ; $E33C cd 19 a4
    CALL $A2A2                         ; $E33F cd a2 a2
    OR $01                             ; $E342 f6 01
    RET                                ; $E344 c9

    ORG $E38F
; CODE fino a $E3B7
; Codifica importo: byte basso usa7bit; byte alto conserva segno.
    RL L                               ; $E38F cb 15
    RL H                               ; $E391 cb 14
    SRL L                              ; $E393 cb 3d
    LD (IX+$09),L                      ; $E395 dd 75 09
    LD (IX+$0A),H                      ; $E398 dd 74 0a
    RET                                ; $E39B c9
; Decodifica importo dal record: signed(high)*128+(low&127).
    LD L,(IX+$09)                      ; $E39C dd 6e 09
    LD H,(IX+$0A)                      ; $E39F dd 66 0a
    RL L                               ; $E3A2 cb 15
    SRA H                              ; $E3A4 cb 2c
    RR L                               ; $E3A6 cb 1d
    RET                                ; $E3A8 c9
    LD DE,($A02F)                      ; $E3A9 ed 5b 2f a0
    RES 7,D                            ; $E3AD cb ba
    RL E                               ; $E3AF cb 13
    SRA D                              ; $E3B1 cb 2a
    RR E                               ; $E3B3 cb 1b
    OR $01                             ; $E3B5 f6 01
    RET                                ; $E3B7 c9
