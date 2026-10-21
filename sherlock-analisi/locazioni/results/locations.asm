; Sherlock - locazioni. Dati e bytecode separati da codice Z80.

    ORG $840B
; DATA fino a $8B6E
; Indice: 106 puntatori alle locazioni, poi slot 6A verso indice entita.
    DEFB $E1,$84,$EB,$84,$F5,$84,$FF,$84 ; $840B e1 84 eb 84 f5 84 ff 84
    DEFB $09,$85,$13,$85,$20,$85,$30,$85 ; $8413 09 85 13 85 20 85 30 85
    DEFB $40,$85,$50,$85,$5D,$85,$6A,$85 ; $841B 40 85 50 85 5d 85 6a 85
    DEFB $77,$85,$84,$85,$91,$85,$9E,$85 ; $8423 77 85 84 85 91 85 9e 85
    DEFB $AE,$85,$BE,$85,$CB,$85,$D8,$85 ; $842B ae 85 be 85 cb 85 d8 85
    DEFB $E8,$85,$F8,$85,$08,$86,$18,$86 ; $8433 e8 85 f8 85 08 86 18 86
    DEFB $25,$86,$32,$86,$42,$86,$52,$86 ; $843B 25 86 32 86 42 86 52 86
    DEFB $5F,$86,$6C,$86,$7C,$86,$8C,$86 ; $8443 5f 86 6c 86 7c 86 8c 86
    DEFB $99,$86,$A9,$86,$BC,$86,$D2,$86 ; $844B 99 86 a9 86 bc 86 d2 86
    DEFB $E2,$86,$F2,$86,$FF,$86,$0C,$87 ; $8453 e2 86 f2 86 ff 86 0c 87
    DEFB $19,$87,$26,$87,$39,$87,$46,$87 ; $845B 19 87 26 87 39 87 46 87
    DEFB $56,$87,$63,$87,$70,$87,$80,$87 ; $8463 56 87 63 87 70 87 80 87
    DEFB $93,$87,$A0,$87,$AD,$87,$C6,$87 ; $846B 93 87 a0 87 ad 87 c6 87
    DEFB $D9,$87,$EC,$87,$FC,$87,$0C,$88 ; $8473 d9 87 ec 87 fc 87 0c 88
    DEFB $19,$88,$2C,$88,$3F,$88,$4C,$88 ; $847B 19 88 2c 88 3f 88 4c 88
    DEFB $5C,$88,$6C,$88,$7C,$88,$8C,$88 ; $8483 5c 88 6c 88 7c 88 8c 88
    DEFB $9C,$88,$AF,$88,$BF,$88,$CC,$88 ; $848B 9c 88 af 88 bf 88 cc 88
    DEFB $DC,$88,$EC,$88,$05,$89,$1B,$89 ; $8493 dc 88 ec 88 05 89 1b 89
    DEFB $28,$89,$38,$89,$48,$89,$55,$89 ; $849B 28 89 38 89 48 89 55 89
    DEFB $62,$89,$78,$89,$88,$89,$9B,$89 ; $84A3 62 89 78 89 88 89 9b 89
    DEFB $B4,$89,$C7,$89,$E0,$89,$F3,$89 ; $84AB b4 89 c7 89 e0 89 f3 89
    DEFB $09,$8A,$19,$8A,$29,$8A,$3C,$8A ; $84B3 09 8a 19 8a 29 8a 3c 8a
    DEFB $4F,$8A,$62,$8A,$78,$8A,$8B,$8A ; $84BB 4f 8a 62 8a 78 8a 8b 8a
    DEFB $A1,$8A,$B1,$8A,$C1,$8A,$D1,$8A ; $84C3 a1 8a b1 8a c1 8a d1 8a
    DEFB $DE,$8A,$F4,$8A,$04,$8B,$11,$8B ; $84CB de 8a f4 8a 04 8b 11 8b
    DEFB $21,$8B,$31,$8B,$3E,$8B,$4E,$8B ; $84D3 21 8b 31 8b 3e 8b 4e 8b
    DEFB $58,$8B,$65,$8B              ; $84DB 58 8b 65 8b
; Slot 6A: punta a 8B6F; NON e una locazione.
    DEFB $6F,$8B                      ; $84DF 6f 8b
; Locazione 000: slot nullo. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$00,$00,$00,$00,$00,$00,$00 ; $84E1 04 00 00 00 00 00 00 00
    DEFB $00,$FF                      ; $84E9 00 ff
; Locazione 001: hansom cab. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$64,$11,$CE,$03,$00,$00,$E1 ; $84EB 84 64 11 ce 03 00 00 e1
    DEFB $7D,$FF                      ; $84F3 7d ff
; Locazione 002: steam train. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$EB,$18,$4C,$08,$00,$00,$27 ; $84F5 84 eb 18 4c 08 00 00 27
    DEFB $7E,$FF                      ; $84FD 7e ff
; Locazione 003: steam train. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$EB,$18,$4C,$08,$00,$00,$45 ; $84FF 84 eb 18 4c 08 00 00 45
    DEFB $7E,$FF                      ; $8507 7e ff
; Locazione 004: steam train. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$EB,$18,$4C,$08,$00,$00,$65 ; $8509 84 eb 18 4c 08 00 00 65
    DEFB $7E,$FF                      ; $8511 7e ff
; Locazione 005: baker street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$61,$88,$AB,$00,$00,$00,$00 ; $8513 06 61 88 ab 00 00 00 00
    DEFB $00                          ; $851B 00
; Uscita N: passaggio 19, destinazione 6.
    DEFB $01,$13,$06,$FF              ; $851C 01 13 06 ff
; Locazione 006: entrance hallway. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C6,$23,$9C,$02,$00,$00,$00 ; $8520 84 c6 23 9c 02 00 00 00
    DEFB $00                          ; $8528 00
; Uscita UP: passaggio 20, destinazione 7.
    DEFB $09,$14,$07                  ; $8529 09 14 07
; Uscita S: passaggio 19, destinazione 5.
    DEFB $02,$13,$05,$FF              ; $852C 02 13 05 ff
; Locazione 007: hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C2,$13,$00,$00,$00,$00,$00 ; $8530 84 c2 13 00 00 00 00 00
    DEFB $00                          ; $8538 00
; Uscita E: passaggio 21, destinazione 8.
    DEFB $03,$15,$08                  ; $8539 03 15 08
; Uscita DOWN: passaggio 20, destinazione 6.
    DEFB $0A,$14,$06,$FF              ; $853C 0a 14 06 ff
; Locazione 008: your room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$47,$87,$F2,$09,$00,$00,$62 ; $8540 84 47 87 f2 09 00 00 62
    DEFB $7D                          ; $8548 7d
; Uscita W: passaggio 21, destinazione 7.
    DEFB $04,$15,$07                  ; $8549 04 15 07
; Uscita N: passaggio 50, destinazione 9.
    DEFB $01,$32,$09,$FF              ; $854C 01 32 09 ff
; Locazione 009: small closet. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C2,$11,$F4,$07,$00,$00,$00 ; $8550 84 c2 11 f4 07 00 00 00
    DEFB $00                          ; $8558 00
; Uscita S: passaggio 50, destinazione 8.
    DEFB $02,$32,$08,$FF              ; $8559 02 32 08 ff
; Locazione 010: parliament street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$61,$88,$4C,$06,$00,$00,$00 ; $855D 06 61 88 4c 06 00 00 00
    DEFB $00                          ; $8565 00
; Uscita E: passaggio 0, destinazione 11.
    DEFB $03,$00,$0B,$FF              ; $8566 03 00 0b ff
; Locazione 011: scotland yard. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$E3,$89,$7E,$07,$00,$00,$00 ; $856A 84 e3 89 7e 07 00 00 00
    DEFB $00                          ; $8572 00
; Uscita W: passaggio 0, destinazione 10.
    DEFB $04,$00,$0A,$FF              ; $8573 04 00 0a ff
; Locazione 012: slater street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$61,$88,$EA,$07,$00,$00,$00 ; $8577 06 61 88 ea 07 00 00 00
    DEFB $00                          ; $857F 00
; Uscita N: passaggio 29, destinazione 13.
    DEFB $01,$1D,$0D,$FF              ; $8580 01 1d 0d ff
; Locazione 013: disgust opium den. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$31,$12,$5F,$02,$0F,$06,$00 ; $8584 84 31 12 5f 02 0f 06 00
    DEFB $00                          ; $858C 00
; Uscita S: passaggio 0, destinazione 12.
    DEFB $02,$00,$0C,$FF              ; $858D 02 00 0c ff
; Locazione 014: aldergate street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$61,$88,$31,$00,$00,$00,$00 ; $8591 04 61 88 31 00 00 00 00
    DEFB $00                          ; $8599 00
; Uscita NW: passaggio 0, destinazione 15.
    DEFB $06,$00,$0F,$FF              ; $859A 06 00 0f ff
; Locazione 015: aldergate station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $88,$3E,$88,$31,$00,$00,$00,$00 ; $859E 88 3e 88 31 00 00 00 00
    DEFB $00                          ; $85A6 00
; Uscita SE: passaggio 0, destinazione 14.
    DEFB $07,$00,$0E                  ; $85A7 07 00 0e
; Uscita NW: passaggio 0, destinazione 16.
    DEFB $06,$00,$10,$FF              ; $85AA 06 00 10 ff
; Locazione 016: platform one. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$04,$86,$A2,$06,$00,$00,$FA ; $85AE 86 04 86 a2 06 00 00 fa
    DEFB $7E                          ; $85B6 7e
; Uscita SE: passaggio 0, destinazione 15.
    DEFB $07,$00,$0F                  ; $85B7 07 00 0f
; Uscita NW: passaggio 0, destinazione 17.
    DEFB $06,$00,$11,$FF              ; $85BA 06 00 11 ff
; Locazione 017: platform two. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$08,$89,$A2,$06,$00,$00,$03 ; $85BE 86 08 89 a2 06 00 00 03
    DEFB $7F                          ; $85C6 7f
; Uscita SE: passaggio 0, destinazione 16.
    DEFB $07,$00,$10,$FF              ; $85C7 07 00 10 ff
; Locazione 018: kings cross road. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$3F,$87,$9C,$04,$00,$02,$00 ; $85CB 04 3f 87 9c 04 00 02 00
    DEFB $00                          ; $85D3 00
; Uscita NE: passaggio 0, destinazione 19.
    DEFB $05,$00,$13,$FF              ; $85D4 05 00 13 ff
; Locazione 019: kings cross station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $88,$3E,$88,$9C,$04,$00,$02,$00 ; $85D8 88 3e 88 9c 04 00 02 00
    DEFB $00                          ; $85E0 00
; Uscita SW: passaggio 0, destinazione 18.
    DEFB $08,$00,$12                  ; $85E1 08 00 12
; Uscita NE: passaggio 0, destinazione 20.
    DEFB $05,$00,$14,$FF              ; $85E4 05 00 14 ff
; Locazione 020: platform one. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$04,$86,$A2,$06,$00,$00,$09 ; $85E8 86 04 86 a2 06 00 00 09
    DEFB $7F                          ; $85F0 7f
; Uscita SW: passaggio 0, destinazione 19.
    DEFB $08,$00,$13                  ; $85F1 08 00 13
; Uscita NE: passaggio 0, destinazione 21.
    DEFB $05,$00,$15,$FF              ; $85F4 05 00 15 ff
; Locazione 021: platform two. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$08,$89,$A2,$06,$00,$00,$14 ; $85F8 86 08 89 a2 06 00 00 14
    DEFB $7F                          ; $8600 7f
; Uscita SW: passaggio 0, destinazione 20.
    DEFB $08,$00,$14                  ; $8601 08 00 14
; Uscita NE: passaggio 0, destinazione 22.
    DEFB $05,$00,$16,$FF              ; $8604 05 00 16 ff
; Locazione 022: platform three. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$CA,$88,$A2,$06,$00,$00,$1A ; $8608 86 ca 88 a2 06 00 00 1a
    DEFB $7F                          ; $8610 7f
; Uscita SW: passaggio 0, destinazione 21.
    DEFB $08,$00,$15                  ; $8611 08 00 15
; Uscita NE: passaggio 0, destinazione 23.
    DEFB $05,$00,$17,$FF              ; $8614 05 00 17 ff
; Locazione 023: platform four. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$45,$83,$A2,$06,$00,$00,$24 ; $8618 86 45 83 a2 06 00 00 24
    DEFB $7F                          ; $8620 7f
; Uscita SW: passaggio 0, destinazione 22.
    DEFB $08,$00,$16,$FF              ; $8621 08 00 16 ff
; Locazione 024: bishops road. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$3F,$87,$F5,$00,$00,$00,$00 ; $8625 04 3f 87 f5 00 00 00 00
    DEFB $00                          ; $862D 00
; Uscita SE: passaggio 0, destinazione 25.
    DEFB $07,$00,$19,$FF              ; $862E 07 00 19 ff
; Locazione 025: paddington station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $88,$3E,$88,$36,$06,$00,$00,$00 ; $8632 88 3e 88 36 06 00 00 00
    DEFB $00                          ; $863A 00
; Uscita NW: passaggio 0, destinazione 24.
    DEFB $06,$00,$18                  ; $863B 06 00 18
; Uscita SE: passaggio 0, destinazione 26.
    DEFB $07,$00,$1A,$FF              ; $863E 07 00 1a ff
; Locazione 026: platform one. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$04,$86,$A2,$06,$00,$00,$2E ; $8642 86 04 86 a2 06 00 00 2e
    DEFB $7F                          ; $864A 7f
; Uscita NW: passaggio 0, destinazione 25.
    DEFB $06,$00,$19                  ; $864B 06 00 19
; Uscita SE: passaggio 0, destinazione 27.
    DEFB $07,$00,$1B,$FF              ; $864E 07 00 1b ff
; Locazione 027: platform two. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$08,$89,$A2,$06,$00,$00,$37 ; $8652 86 08 89 a2 06 00 00 37
    DEFB $7F                          ; $865A 7f
; Uscita NW: passaggio 0, destinazione 26.
    DEFB $06,$00,$1A,$FF              ; $865B 06 00 1a ff
; Locazione 028: buckingham palace road. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$3F,$87,$4A,$01,$3E,$06,$00 ; $865F 04 3f 87 4a 01 3e 06 00
    DEFB $00                          ; $8667 00
; Uscita E: passaggio 0, destinazione 29.
    DEFB $03,$00,$1D,$FF              ; $8668 03 00 1d ff
; Locazione 029: victoria station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $88,$3E,$88,$4F,$09,$00,$00,$00 ; $866C 88 3e 88 4f 09 00 00 00
    DEFB $00                          ; $8674 00
; Uscita W: passaggio 0, destinazione 28.
    DEFB $04,$00,$1C                  ; $8675 04 00 1c
; Uscita E: passaggio 0, destinazione 30.
    DEFB $03,$00,$1E,$FF              ; $8678 03 00 1e ff
; Locazione 030: platform one. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$04,$86,$A2,$06,$00,$00,$3D ; $867C 86 04 86 a2 06 00 00 3d
    DEFB $7F                          ; $8684 7f
; Uscita W: passaggio 0, destinazione 29.
    DEFB $04,$00,$1D                  ; $8685 04 00 1d
; Uscita E: passaggio 0, destinazione 31.
    DEFB $03,$00,$1F,$FF              ; $8688 03 00 1f ff
; Locazione 031: platform two. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$08,$89,$A2,$06,$00,$00,$46 ; $868C 86 08 89 a2 06 00 00 46
    DEFB $7F                          ; $8694 7f
; Uscita W: passaggio 0, destinazione 30.
    DEFB $04,$00,$1E,$FF              ; $8695 04 00 1e ff
; Locazione 032: camden street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$61,$88,$74,$01,$00,$00,$00 ; $8699 04 61 88 74 01 00 00 00
    DEFB $00                          ; $86A1 00
; Uscita NE: passaggio 91, destinazione 33.
    DEFB $05,$5B,$21                  ; $86A2 05 5b 21
; Uscita E: passaggio 0, destinazione 102.
    DEFB $03,$00,$66,$FF              ; $86A5 03 00 66 ff
; Locazione 033: entrance hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$C2,$23,$9C,$02,$00,$00,$00 ; $86A9 04 c2 23 9c 02 00 00 00
    DEFB $00                          ; $86B1 00
; Uscita SW: passaggio 91, destinazione 32.
    DEFB $08,$5B,$20                  ; $86B2 08 5b 20
; Uscita NE: passaggio 0, destinazione 34.
    DEFB $05,$00,$22                  ; $86B5 05 00 22
; Uscita SE: passaggio 45, destinazione 35.
    DEFB $07,$2D,$23,$FF              ; $86B8 07 2d 23 ff
; Locazione 034: passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$53,$16,$00,$00,$00,$00,$00 ; $86BC 04 53 16 00 00 00 00 00
    DEFB $00                          ; $86C4 00
; Uscita SW: passaggio 0, destinazione 33.
    DEFB $08,$00,$21                  ; $86C5 08 00 21
; Uscita NE: passaggio 50, destinazione 36.
    DEFB $05,$32,$24                  ; $86C8 05 32 24
; Uscita NW: passaggio 49, destinazione 37.
    DEFB $06,$31,$25                  ; $86CB 06 31 25
; Uscita SE: passaggio 55, destinazione 38.
    DEFB $07,$37,$26,$FF              ; $86CE 07 37 26 ff
; Locazione 035: basils bedroom. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$CE,$80,$BD,$00,$00,$00,$00 ; $86D2 04 ce 80 bd 00 00 00 00
    DEFB $00                          ; $86DA 00
; Uscita NW: passaggio 45, destinazione 33.
    DEFB $06,$2D,$21                  ; $86DB 06 2d 21
; Uscita SW: passaggio 79, destinazione 102.
    DEFB $08,$4F,$66,$FF              ; $86DE 08 4f 66 ff
; Locazione 036: basils kitchen. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$A0,$84,$BD,$00,$00,$00,$00 ; $86E2 04 a0 84 bd 00 00 00 00
    DEFB $00                          ; $86EA 00
; Uscita SW: passaggio 50, destinazione 34.
    DEFB $08,$32,$22                  ; $86EB 08 32 22
; Uscita NE: passaggio 74, destinazione 39.
    DEFB $05,$4A,$27,$FF              ; $86EE 05 4a 27 ff
; Locazione 037: basils dining room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$87,$BD,$00,$4F,$02,$00 ; $86F2 04 47 87 bd 00 4f 02 00
    DEFB $00                          ; $86FA 00
; Uscita SE: passaggio 49, destinazione 34.
    DEFB $07,$31,$22,$FF              ; $86FB 07 31 22 ff
; Locazione 038: basils library. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$EA,$84,$BD,$00,$00,$00,$00 ; $86FF 04 ea 84 bd 00 00 00 00
    DEFB $00                          ; $8707 00
; Uscita NW: passaggio 55, destinazione 34.
    DEFB $06,$37,$22,$FF              ; $8708 06 37 22 ff
; Locazione 039: basils yard. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$E3,$89,$BD,$00,$00,$00,$00 ; $870C 04 e3 89 bd 00 00 00 00
    DEFB $00                          ; $8714 00
; Uscita SW: passaggio 74, destinazione 36.
    DEFB $08,$4A,$24,$FF              ; $8715 08 4a 24 ff
; Locazione 040: sidmouth street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$61,$88,$C2,$07,$00,$00,$00 ; $8719 04 61 88 c2 07 00 00 00
    DEFB $00                          ; $8721 00
; Uscita NW: passaggio 48, destinazione 41.
    DEFB $06,$30,$29,$FF              ; $8722 06 30 29 ff
; Locazione 041: main passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$53,$06,$3F,$05,$00,$00,$00 ; $8726 84 53 06 3f 05 00 00 00
    DEFB $00                          ; $872E 00
; Uscita SE: passaggio 48, destinazione 40.
    DEFB $07,$30,$28                  ; $872F 07 30 28
; Uscita NE: passaggio 55, destinazione 42.
    DEFB $05,$37,$2A                  ; $8732 05 37 2a
; Uscita UP: passaggio 20, destinazione 43.
    DEFB $09,$14,$2B,$FF              ; $8735 09 14 2b ff
; Locazione 042: reading lounge. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$2A,$05,$03,$07,$00,$00,$00 ; $8739 04 2a 05 03 07 00 00 00
    DEFB $00                          ; $8741 00
; Uscita SW: passaggio 55, destinazione 41.
    DEFB $08,$37,$29,$FF              ; $8742 08 37 29 ff
; Locazione 043: passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$53,$06,$00,$00,$00,$00,$00 ; $8746 84 53 06 00 00 00 00 00
    DEFB $00                          ; $874E 00
; Uscita DOWN: passaggio 20, destinazione 41.
    DEFB $0A,$14,$29                  ; $874F 0a 14 29
; Uscita NE: passaggio 48, destinazione 44.
    DEFB $05,$30,$2C,$FF              ; $8752 05 30 2c ff
; Locazione 044: major ffoulkes room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$87,$42,$05,$0A,$03,$7F ; $8756 04 47 87 42 05 0a 03 7f
    DEFB $7E                          ; $875E 7e
; Uscita SW: passaggio 48, destinazione 43.
    DEFB $08,$30,$2B,$FF              ; $875F 08 30 2b ff
; Locazione 045: portman street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$61,$88,$BE,$06,$00,$00,$00 ; $8763 04 61 88 be 06 00 00 00
    DEFB $00                          ; $876B 00
; Uscita S: passaggio 103, destinazione 46.
    DEFB $02,$67,$2E,$FF              ; $876C 02 67 2e ff
; Locazione 046: tricias entrance hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$C2,$83,$FE,$08,$9C,$02,$00 ; $8770 04 c2 83 fe 08 9c 02 00
    DEFB $00                          ; $8778 00
; Uscita N: passaggio 103, destinazione 45.
    DEFB $01,$67,$2D                  ; $8779 01 67 2d
; Uscita S: passaggio 55, destinazione 47.
    DEFB $02,$37,$2F,$FF              ; $877C 02 37 2f ff
; Locazione 047: tricias lounge. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$2A,$85,$FE,$08,$00,$00,$00 ; $8780 04 2a 85 fe 08 00 00 00
    DEFB $00                          ; $8788 00
; Uscita N: passaggio 55, destinazione 46.
    DEFB $01,$37,$2E                  ; $8789 01 37 2e
; Uscita S: passaggio 50, destinazione 48.
    DEFB $02,$32,$30                  ; $878C 02 32 30
; Uscita E: passaggio 51, destinazione 49.
    DEFB $03,$33,$31,$FF              ; $878F 03 33 31 ff
; Locazione 048: tricias kitchen. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$A0,$84,$FE,$08,$00,$00,$00 ; $8793 04 a0 84 fe 08 00 00 00
    DEFB $00                          ; $879B 00
; Uscita N: passaggio 50, destinazione 47.
    DEFB $01,$32,$2F,$FF              ; $879C 01 32 2f ff
; Locazione 049: tricias bedroom. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$CE,$80,$FE,$08,$00,$00,$00 ; $87A0 04 ce 80 fe 08 00 00 00
    DEFB $00                          ; $87A8 00
; Uscita W: passaggio 51, destinazione 47.
    DEFB $04,$33,$2F,$FF              ; $87A9 04 33 2f ff
; Locazione 050: main street. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$61,$08,$3F,$05,$00,$00,$00 ; $87AD 04 61 08 3f 05 00 00 00
    DEFB $00                          ; $87B5 00
; Uscita N: passaggio 0, destinazione 53.
    DEFB $01,$00,$35                  ; $87B6 01 00 35
; Uscita W: passaggio 0, destinazione 62.
    DEFB $04,$00,$3E                  ; $87B9 04 00 3e
; Uscita E: passaggio 0, destinazione 92.
    DEFB $03,$00,$5C                  ; $87BC 03 00 5c
; Uscita S: passaggio 0, destinazione 51.
    DEFB $02,$00,$33                  ; $87BF 02 00 33
; Uscita NE: passaggio 0, destinazione 104.
    DEFB $05,$00,$68,$FF              ; $87C2 05 00 68 ff
; Locazione 051: cobden lane. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$BD,$04,$CA,$01,$00,$00,$00 ; $87C6 04 bd 04 ca 01 00 00 00
    DEFB $00                          ; $87CE 00
; Uscita N: passaggio 0, destinazione 50.
    DEFB $01,$00,$32                  ; $87CF 01 00 32
; Uscita S: passaggio 0, destinazione 52.
    DEFB $02,$00,$34                  ; $87D2 02 00 34
; Uscita E: passaggio 19, destinazione 56.
    DEFB $03,$13,$38,$FF              ; $87D5 03 13 38 ff
; Locazione 052: small lane. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$BD,$04,$F4,$07,$00,$00,$00 ; $87D9 04 bd 04 f4 07 00 00 00
    DEFB $00                          ; $87E1 00
; Uscita N: passaggio 0, destinazione 51.
    DEFB $01,$00,$33                  ; $87E2 01 00 33
; Uscita E: passaggio 73, destinazione 60.
    DEFB $03,$49,$3C                  ; $87E5 03 49 3c
; Uscita W: passaggio 75, destinazione 81.
    DEFB $04,$4B,$51,$FF              ; $87E8 04 4b 51 ff
; Locazione 053: leatherhead station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $88,$3E,$08,$D3,$04,$00,$00,$00 ; $87EC 88 3e 08 d3 04 00 00 00
    DEFB $00                          ; $87F4 00
; Uscita S: passaggio 0, destinazione 50.
    DEFB $02,$00,$32                  ; $87F5 02 00 32
; Uscita N: passaggio 0, destinazione 54.
    DEFB $01,$00,$36,$FF              ; $87F8 01 00 36 ff
; Locazione 054: platform one. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$04,$86,$A2,$06,$00,$00,$4C ; $87FC 86 04 86 a2 06 00 00 4c
    DEFB $7F                          ; $8804 7f
; Uscita S: passaggio 0, destinazione 53.
    DEFB $02,$00,$35                  ; $8805 02 00 35
; Uscita N: passaggio 0, destinazione 55.
    DEFB $01,$00,$37,$FF              ; $8808 01 00 37 ff
; Locazione 055: platform two. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $86,$08,$89,$A2,$06,$00,$00,$57 ; $880C 86 08 89 a2 06 00 00 57
    DEFB $7F                          ; $8814 7f
; Uscita S: passaggio 0, destinazione 54.
    DEFB $02,$00,$36,$FF              ; $8815 02 00 36 ff
; Locazione 056: entrance hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C2,$23,$9C,$02,$00,$00,$00 ; $8819 84 c2 23 9c 02 00 00 00
    DEFB $00                          ; $8821 00
; Uscita W: passaggio 19, destinazione 51.
    DEFB $04,$13,$33                  ; $8822 04 13 33
; Uscita E: passaggio 69, destinazione 57.
    DEFB $03,$45,$39                  ; $8825 03 45 39
; Uscita UP: passaggio 20, destinazione 61.
    DEFB $09,$14,$3D,$FF              ; $8828 09 14 3d ff
; Locazione 057: lounge room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$17,$2A,$05,$00,$00,$00 ; $882C 04 47 17 2a 05 00 00 00
    DEFB $00                          ; $8834 00
; Uscita W: passaggio 69, destinazione 56.
    DEFB $04,$45,$38                  ; $8835 04 45 38
; Uscita E: passaggio 50, destinazione 59.
    DEFB $03,$32,$3B                  ; $8838 03 32 3b
; Uscita S: passaggio 0, destinazione 58.
    DEFB $02,$00,$3A,$FF              ; $883B 02 00 3a ff
; Locazione 058: basils library. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$EA,$84,$BD,$00,$00,$00,$00 ; $883F 04 ea 84 bd 00 00 00 00
    DEFB $00                          ; $8847 00
; Uscita N: passaggio 0, destinazione 57.
    DEFB $01,$00,$39,$FF              ; $8848 01 00 39 ff
; Locazione 059: basils kitchen. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$A0,$84,$BD,$00,$00,$00,$00 ; $884C 04 a0 84 bd 00 00 00 00
    DEFB $00                          ; $8854 00
; Uscita W: passaggio 50, destinazione 57.
    DEFB $04,$32,$39                  ; $8855 04 32 39
; Uscita S: passaggio 74, destinazione 60.
    DEFB $02,$4A,$3C,$FF              ; $8858 02 4a 3c ff
; Locazione 060: small yard. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$E3,$09,$F4,$07,$00,$00,$00 ; $885C 04 e3 09 f4 07 00 00 00
    DEFB $00                          ; $8864 00
; Uscita N: passaggio 74, destinazione 59.
    DEFB $01,$4A,$3B                  ; $8865 01 4a 3b
; Uscita W: passaggio 73, destinazione 52.
    DEFB $04,$49,$34,$FF              ; $8868 04 49 34 ff
; Locazione 061: basils bedroom. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$CE,$80,$BD,$00,$00,$00,$B7 ; $886C 04 ce 80 bd 00 00 00 b7
    DEFB $7E                          ; $8874 7e
; Uscita DOWN: passaggio 20, destinazione 56.
    DEFB $0A,$14,$38                  ; $8875 0a 14 38
; Uscita E: passaggio 102, destinazione 0.
    DEFB $03,$66,$00,$FF              ; $8878 03 66 00 ff
; Locazione 062: browns front gate. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $08,$77,$83,$47,$01,$55,$03,$00 ; $887C 08 77 83 47 01 55 03 00
    DEFB $00                          ; $8884 00
; Uscita S: passaggio 12, destinazione 76.
    DEFB $02,$0C,$4C                  ; $8885 02 0c 4c
; Uscita E: passaggio 0, destinazione 50.
    DEFB $03,$00,$32,$FF              ; $8888 03 00 32 ff
; Locazione 063: browns front door. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $08,$6E,$82,$47,$01,$55,$03,$00 ; $888C 08 6e 82 47 01 55 03 00
    DEFB $00                          ; $8894 00
; Uscita S: passaggio 45, destinazione 64.
    DEFB $02,$2D,$40                  ; $8895 02 2d 40
; Uscita N: passaggio 0, destinazione 76.
    DEFB $01,$00,$4C,$FF              ; $8898 01 00 4c ff
; Locazione 064: entrance hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C2,$23,$9C,$02,$00,$00,$00 ; $889C 84 c2 23 9c 02 00 00 00
    DEFB $00                          ; $88A4 00
; Uscita E: passaggio 48, destinazione 67.
    DEFB $03,$30,$43                  ; $88A5 03 30 43
; Uscita N: passaggio 45, destinazione 63.
    DEFB $01,$2D,$3F                  ; $88A8 01 2d 3f
; Uscita S: passaggio 44, destinazione 69.
    DEFB $02,$2C,$45,$FF              ; $88AB 02 2c 45 ff
; Locazione 065: large kitchen. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$A0,$14,$C1,$04,$00,$00,$00 ; $88AF 84 a0 14 c1 04 00 00 00
    DEFB $00                          ; $88B7 00
; Uscita W: passaggio 0, destinazione 66.
    DEFB $04,$00,$42                  ; $88B8 04 00 42
; Uscita E: passaggio 50, destinazione 68.
    DEFB $03,$32,$44,$FF              ; $88BB 03 32 44 ff
; Locazione 066: pantry. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$43,$16,$00,$00,$00,$00,$00 ; $88BF 04 43 16 00 00 00 00 00
    DEFB $00                          ; $88C7 00
; Uscita E: passaggio 0, destinazione 65.
    DEFB $03,$00,$41,$FF              ; $88C8 03 00 41 ff
; Locazione 067: sitting room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$E0,$07,$00,$00,$00 ; $88CC 04 47 07 e0 07 00 00 00
    DEFB $00                          ; $88D4 00
; Uscita W: passaggio 48, destinazione 64.
    DEFB $04,$30,$40                  ; $88D5 04 30 40
; Uscita S: passaggio 49, destinazione 68.
    DEFB $02,$31,$44,$FF              ; $88D8 02 31 44 ff
; Locazione 068: dining room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$4F,$02,$00,$00,$00 ; $88DC 04 47 07 4f 02 00 00 00
    DEFB $00                          ; $88E4 00
; Uscita W: passaggio 50, destinazione 65.
    DEFB $04,$32,$41                  ; $88E5 04 32 41
; Uscita N: passaggio 49, destinazione 67.
    DEFB $01,$31,$43,$FF              ; $88E8 01 31 43 ff
; Locazione 069: long passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$53,$16,$20,$05,$00,$00,$00 ; $88EC 84 53 16 20 05 00 00 00
    DEFB $00                          ; $88F4 00
; Uscita DOWN: passaggio 44, destinazione 64.
    DEFB $0A,$2C,$40                  ; $88F5 0a 2c 40
; Uscita S: passaggio 52, destinazione 74.
    DEFB $02,$34,$4A                  ; $88F8 02 34 4a
; Uscita W: passaggio 54, destinazione 72.
    DEFB $04,$36,$48                  ; $88FB 04 36 48
; Uscita E: passaggio 0, destinazione 70.
    DEFB $03,$00,$46                  ; $88FE 03 00 46
; Uscita N: passaggio 44, destinazione 64.
    DEFB $01,$2C,$40,$FF              ; $8901 01 2c 40 ff
; Locazione 070: long passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$53,$16,$20,$05,$00,$00,$00 ; $8905 84 53 16 20 05 00 00 00
    DEFB $00                          ; $890D 00
; Uscita W: passaggio 0, destinazione 69.
    DEFB $04,$00,$45                  ; $890E 04 00 45
; Uscita N: passaggio 51, destinazione 73.
    DEFB $01,$33,$49                  ; $8911 01 33 49
; Uscita S: passaggio 53, destinazione 75.
    DEFB $02,$35,$4B                  ; $8914 02 35 4b
; Uscita E: passaggio 55, destinazione 71.
    DEFB $03,$37,$47,$FF              ; $8917 03 37 47 ff
; Locazione 071: browns library. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$EA,$04,$47,$01,$00,$00,$00 ; $891B 04 ea 04 47 01 00 00 00
    DEFB $00                          ; $8923 00
; Uscita W: passaggio 55, destinazione 70.
    DEFB $04,$37,$46,$FF              ; $8924 04 37 46 ff
; Locazione 072: browns study. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$65,$08,$47,$01,$00,$00,$00 ; $8928 04 65 08 47 01 00 00 00
    DEFB $00                          ; $8930 00
; Uscita E: passaggio 54, destinazione 69.
    DEFB $03,$36,$45                  ; $8931 03 36 45
; Uscita NE: passaggio 56, destinazione 73.
    DEFB $05,$38,$49,$FF              ; $8934 05 38 49 ff
; Locazione 073: master bed room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$53,$05,$CB,$00,$00 ; $8938 04 47 07 53 05 cb 00 00
    DEFB $00                          ; $8940 00
; Uscita W: passaggio 56, destinazione 72.
    DEFB $04,$38,$48                  ; $8941 04 38 48
; Uscita S: passaggio 51, destinazione 70.
    DEFB $02,$33,$46,$FF              ; $8944 02 33 46 ff
; Locazione 074: daphnes room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$87,$1B,$02,$00,$00,$00 ; $8948 04 47 87 1b 02 00 00 00
    DEFB $00                          ; $8950 00
; Uscita N: passaggio 52, destinazione 69.
    DEFB $01,$34,$45,$FF              ; $8951 01 34 45 ff
; Locazione 075: guest room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$AA,$03,$00,$00,$00 ; $8955 04 47 07 aa 03 00 00 00
    DEFB $00                          ; $895D 00
; Uscita N: passaggio 53, destinazione 70.
    DEFB $01,$35,$46,$FF              ; $895E 01 35 46 ff
; Locazione 076: garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$6A,$03,$00,$00,$00 ; $8962 06 5c 16 6a 03 00 00 00
    DEFB $00                          ; $896A 00
; Uscita N: passaggio 0, destinazione 62.
    DEFB $01,$00,$3E                  ; $896B 01 00 3e
; Uscita S: passaggio 0, destinazione 63.
    DEFB $02,$00,$3F                  ; $896E 02 00 3f
; Uscita SW: passaggio 0, destinazione 77.
    DEFB $08,$00,$4D                  ; $8971 08 00 4d
; Uscita E: passaggio 0, destinazione 86.
    DEFB $03,$00,$56,$FF              ; $8974 03 00 56 ff
; Locazione 077: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8978 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8980 00
; Uscita NE: passaggio 0, destinazione 76.
    DEFB $05,$00,$4C                  ; $8981 05 00 4c
; Uscita S: passaggio 0, destinazione 78.
    DEFB $02,$00,$4E,$FF              ; $8984 02 00 4e ff
; Locazione 078: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8988 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8990 00
; Uscita N: passaggio 0, destinazione 77.
    DEFB $01,$00,$4D                  ; $8991 01 00 4d
; Uscita SW: passaggio 0, destinazione 89.
    DEFB $08,$00,$59                  ; $8994 08 00 59
; Uscita SE: passaggio 0, destinazione 79.
    DEFB $07,$00,$4F,$FF              ; $8997 07 00 4f ff
; Locazione 079: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $899B 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $89A3 00
; Uscita NW: passaggio 0, destinazione 78.
    DEFB $06,$00,$4E                  ; $89A4 06 00 4e
; Uscita SE: passaggio 0, destinazione 80.
    DEFB $07,$00,$50                  ; $89A7 07 00 50
; Uscita NE: passaggio 0, destinazione 82.
    DEFB $05,$00,$52                  ; $89AA 05 00 52
; Uscita SW: passaggio 0, destinazione 89.
    DEFB $08,$00,$59                  ; $89AD 08 00 59
; Uscita E: passaggio 59, destinazione 0.
    DEFB $03,$3B,$00,$FF              ; $89B0 03 3b 00 ff
; Locazione 080: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $89B4 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $89BC 00
; Uscita SE: passaggio 0, destinazione 91.
    DEFB $07,$00,$5B                  ; $89BD 07 00 5b
; Uscita W: passaggio 0, destinazione 79.
    DEFB $04,$00,$4F                  ; $89C0 04 00 4f
; Uscita NE: passaggio 0, destinazione 81.
    DEFB $05,$00,$51,$FF              ; $89C3 05 00 51 ff
; Locazione 081: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $89C7 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $89CF 00
; Uscita SW: passaggio 0, destinazione 80.
    DEFB $08,$00,$50                  ; $89D0 08 00 50
; Uscita N: passaggio 0, destinazione 83.
    DEFB $01,$00,$53                  ; $89D3 01 00 53
; Uscita S: passaggio 0, destinazione 91.
    DEFB $02,$00,$5B                  ; $89D6 02 00 5b
; Uscita NW: passaggio 0, destinazione 82.
    DEFB $06,$00,$52                  ; $89D9 06 00 52
; Uscita W: passaggio 75, destinazione 52.
    DEFB $04,$4B,$34,$FF              ; $89DC 04 4b 34 ff
; Locazione 082: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $89E0 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $89E8 00
; Uscita NE: passaggio 0, destinazione 83.
    DEFB $05,$00,$53                  ; $89E9 05 00 53
; Uscita W: passaggio 0, destinazione 79.
    DEFB $04,$00,$4F                  ; $89EC 04 00 4f
; Uscita SE: passaggio 0, destinazione 81.
    DEFB $07,$00,$51,$FF              ; $89EF 07 00 51 ff
; Locazione 083: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $89F3 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $89FB 00
; Uscita N: passaggio 0, destinazione 84.
    DEFB $01,$00,$54                  ; $89FC 01 00 54
; Uscita NW: passaggio 0, destinazione 86.
    DEFB $06,$00,$56                  ; $89FF 06 00 56
; Uscita SW: passaggio 0, destinazione 82.
    DEFB $08,$00,$52                  ; $8A02 08 00 52
; Uscita SE: passaggio 0, destinazione 81.
    DEFB $07,$00,$51,$FF              ; $8A05 07 00 51 ff
; Locazione 084: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8A09 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8A11 00
; Uscita NW: passaggio 0, destinazione 85.
    DEFB $06,$00,$55                  ; $8A12 06 00 55
; Uscita S: passaggio 0, destinazione 83.
    DEFB $02,$00,$53,$FF              ; $8A15 02 00 53 ff
; Locazione 085: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8A19 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8A21 00
; Uscita N: passaggio 0, destinazione 86.
    DEFB $01,$00,$56                  ; $8A22 01 00 56
; Uscita E: passaggio 0, destinazione 84.
    DEFB $03,$00,$54,$FF              ; $8A25 03 00 54 ff
; Locazione 086: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8A29 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8A31 00
; Uscita W: passaggio 0, destinazione 76.
    DEFB $04,$00,$4C                  ; $8A32 04 00 4c
; Uscita SE: passaggio 0, destinazione 83.
    DEFB $07,$00,$53                  ; $8A35 07 00 53
; Uscita E: passaggio 0, destinazione 85.
    DEFB $03,$00,$55,$FF              ; $8A38 03 00 55 ff
; Locazione 087: winding garden path. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$5C,$16,$B5,$09,$6A,$03,$00 ; $8A3C 06 5c 16 b5 09 6a 03 00
    DEFB $00                          ; $8A44 00
; Uscita W: passaggio 0, destinazione 88.
    DEFB $04,$00,$58                  ; $8A45 04 00 58
; Uscita E: passaggio 0, destinazione 90.
    DEFB $03,$00,$5A                  ; $8A48 03 00 5a
; Uscita S: passaggio 59, destinazione 0.
    DEFB $02,$3B,$00,$FF              ; $8A4B 02 3b 00 ff
; Locazione 088: east side. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$BE,$07,$84,$02,$00,$00,$00 ; $8A4F 06 be 07 84 02 00 00 00
    DEFB $00                          ; $8A57 00
; Uscita W: passaggio 57, destinazione 89.
    DEFB $04,$39,$59                  ; $8A58 04 39 59
; Uscita SE: passaggio 0, destinazione 87.
    DEFB $07,$00,$57                  ; $8A5B 07 00 57
; Uscita N: passaggio 59, destinazione 0.
    DEFB $01,$3B,$00,$FF              ; $8A5E 01 3b 00 ff
; Locazione 089: west side. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$BE,$07,$92,$09,$00,$00,$00 ; $8A62 06 be 07 92 09 00 00 00
    DEFB $00                          ; $8A6A 00
; Uscita E: passaggio 57, destinazione 88.
    DEFB $03,$39,$58                  ; $8A6B 03 39 58
; Uscita N: passaggio 0, destinazione 78.
    DEFB $01,$00,$4E                  ; $8A6E 01 00 4e
; Uscita NE: passaggio 0, destinazione 79.
    DEFB $05,$00,$4F                  ; $8A71 05 00 4f
; Uscita NW: passaggio 59, destinazione 0.
    DEFB $06,$3B,$00,$FF              ; $8A74 06 3b 00 ff
; Locazione 090: south side. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$BE,$07,$1A,$08,$00,$00,$00 ; $8A78 06 be 07 1a 08 00 00 00
    DEFB $00                          ; $8A80 00
; Uscita W: passaggio 0, destinazione 87.
    DEFB $04,$00,$57                  ; $8A81 04 00 57
; Uscita N: passaggio 58, destinazione 91.
    DEFB $01,$3A,$5B                  ; $8A84 01 3a 5b
; Uscita SE: passaggio 59, destinazione 0.
    DEFB $07,$3B,$00,$FF              ; $8A87 07 3b 00 ff
; Locazione 091: north side. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$BE,$07,$C3,$05,$00,$00,$00 ; $8A8B 06 be 07 c3 05 00 00 00
    DEFB $00                          ; $8A93 00
; Uscita S: passaggio 58, destinazione 90.
    DEFB $02,$3A,$5A                  ; $8A94 02 3a 5a
; Uscita NW: passaggio 0, destinazione 80.
    DEFB $06,$00,$50                  ; $8A97 06 00 50
; Uscita N: passaggio 0, destinazione 81.
    DEFB $01,$00,$51                  ; $8A9A 01 00 51
; Uscita NE: passaggio 59, destinazione 0.
    DEFB $05,$3B,$00,$FF              ; $8A9D 05 3b 00 ff
; Locazione 092: jones front gate. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $08,$77,$83,$8B,$04,$55,$03,$00 ; $8AA1 08 77 83 8b 04 55 03 00
    DEFB $00                          ; $8AA9 00
; Uscita S: passaggio 11, destinazione 93.
    DEFB $02,$0B,$5D                  ; $8AAA 02 0b 5d
; Uscita W: passaggio 0, destinazione 50.
    DEFB $04,$00,$32,$FF              ; $8AAD 04 00 32 ff
; Locazione 093: jones front door. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $08,$6E,$82,$8B,$04,$55,$03,$00 ; $8AB1 08 6e 82 8b 04 55 03 00
    DEFB $00                          ; $8AB9 00
; Uscita S: passaggio 19, destinazione 96.
    DEFB $02,$13,$60                  ; $8ABA 02 13 60
; Uscita N: passaggio 0, destinazione 92.
    DEFB $01,$00,$5C,$FF              ; $8ABD 01 00 5c ff
; Locazione 094: library. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$EA,$14,$00,$00,$00,$00,$00 ; $8AC1 04 ea 14 00 00 00 00 00
    DEFB $00                          ; $8AC9 00
; Uscita W: passaggio 66, destinazione 95.
    DEFB $04,$42,$5F                  ; $8ACA 04 42 5f
; Uscita N: passaggio 68, destinazione 97.
    DEFB $01,$44,$61,$FF              ; $8ACD 01 44 61 ff
; Locazione 095: small room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$17,$F4,$07,$00,$00,$00 ; $8AD1 04 47 17 f4 07 00 00 00
    DEFB $00                          ; $8AD9 00
; Uscita E: passaggio 66, destinazione 94.
    DEFB $03,$42,$5E,$FF              ; $8ADA 03 42 5e ff
; Locazione 096: jones entrance hall. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$C2,$83,$8B,$04,$9C,$02,$00 ; $8ADE 84 c2 83 8b 04 9c 02 00
    DEFB $00                          ; $8AE6 00
; Uscita N: passaggio 19, destinazione 93.
    DEFB $01,$13,$5D                  ; $8AE7 01 13 5d
; Uscita SE: passaggio 49, destinazione 99.
    DEFB $07,$31,$63                  ; $8AEA 07 31 63
; Uscita W: passaggio 69, destinazione 97.
    DEFB $04,$45,$61                  ; $8AED 04 45 61
; Uscita UP: passaggio 20, destinazione 100.
    DEFB $09,$14,$64,$FF              ; $8AF0 09 14 64 ff
; Locazione 097: sitting room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$E0,$07,$00,$00,$00 ; $8AF4 04 47 07 e0 07 00 00 00
    DEFB $00                          ; $8AFC 00
; Uscita S: passaggio 68, destinazione 94.
    DEFB $02,$44,$5E                  ; $8AFD 02 44 5e
; Uscita E: passaggio 69, destinazione 96.
    DEFB $03,$45,$60,$FF              ; $8B00 03 45 60 ff
; Locazione 098: kitchen. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$A0,$14,$00,$00,$00,$00,$00 ; $8B04 04 a0 14 00 00 00 00 00
    DEFB $00                          ; $8B0C 00
; Uscita S: passaggio 50, destinazione 99.
    DEFB $02,$32,$63,$FF              ; $8B0D 02 32 63 ff
; Locazione 099: dining room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$07,$4F,$02,$00,$00,$00 ; $8B11 04 47 07 4f 02 00 00 00
    DEFB $00                          ; $8B19 00
; Uscita N: passaggio 50, destinazione 98.
    DEFB $01,$32,$62                  ; $8B1A 01 32 62
; Uscita NW: passaggio 49, destinazione 96.
    DEFB $06,$31,$60,$FF              ; $8B1D 06 31 60 ff
; Locazione 100: small passage. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$53,$16,$F4,$07,$00,$00,$00 ; $8B21 84 53 16 f4 07 00 00 00
    DEFB $00                          ; $8B29 00
; Uscita DOWN: passaggio 20, destinazione 96.
    DEFB $0A,$14,$60                  ; $8B2A 0a 14 60
; Uscita W: passaggio 70, destinazione 101.
    DEFB $04,$46,$65,$FF              ; $8B2D 04 46 65 ff
; Locazione 101: mrs jones room. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$47,$87,$84,$05,$8B,$04,$00 ; $8B31 04 47 87 84 05 8b 04 00
    DEFB $00                          ; $8B39 00
; Uscita E: passaggio 70, destinazione 100.
    DEFB $03,$46,$64,$FF              ; $8B3A 03 46 64 ff
; Locazione 102: basils front yard. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$E3,$89,$BD,$00,$55,$03,$00 ; $8B3E 04 e3 89 bd 00 55 03 00
    DEFB $00                          ; $8B46 00
; Uscita W: passaggio 0, destinazione 32.
    DEFB $04,$00,$20                  ; $8B47 04 00 20
; Uscita NE: passaggio 79, destinazione 35.
    DEFB $05,$4F,$23,$FF              ; $8B4A 05 4f 23 ff
; Locazione 103: old mill road. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $06,$3F,$07,$FB,$05,$67,$05,$00 ; $8B4E 06 3f 07 fb 05 67 05 00
    DEFB $00,$FF                      ; $8B56 00 ff
; Locazione 104: leatherhead police station. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $04,$3E,$08,$D3,$04,$B5,$06,$00 ; $8B58 04 3e 08 d3 04 b5 06 00
    DEFB $00                          ; $8B60 00
; Uscita SW: passaggio 0, destinazione 50.
    DEFB $08,$00,$32,$FF              ; $8B61 08 00 32 ff
; Locazione 105: police cab. Flags; nome+qualificatori; descrizione; triplette; FF.
    DEFB $84,$64,$11,$B5,$06,$00,$00,$0B ; $8B65 84 64 11 b5 06 00 00 0b
    DEFB $7E,$FF                      ; $8B6D 7e ff

    ORG $C00C
; CODE fino a $C03A
; Classe temporale per luce e varianti delle descrizioni.
    LD A,($9FE2)                      ; $C00C 3a e2 9f
    CP $61                            ; $C00F fe 61
    LD A,($9FE0)                      ; $C011 3a e0 9f
    JR Z,$C02B                        ; $C014 28 15
    CP $0C                            ; $C016 fe 0c
    JR Z,$C035                        ; $C018 28 1b
    CP $08                            ; $C01A fe 08
    JR C,$C021                        ; $C01C 38 03
    LD A,$01                          ; $C01E 3e 01
    RET                               ; $C020 c9
    CP $07                            ; $C021 fe 07
    JR NZ,$C028                       ; $C023 20 03
    LD A,$02                          ; $C025 3e 02
    RET                               ; $C027 c9
    LD A,$03                          ; $C028 3e 03
    RET                               ; $C02A c9
    CP $0C                            ; $C02B fe 0c
    JR Z,$C01E                        ; $C02D 28 ef
    CP $06                            ; $C02F fe 06
    JR C,$C01E                        ; $C031 38 eb
    JR Z,$C038                        ; $C033 28 03
    LD A,$04                          ; $C035 3e 04
    RET                               ; $C037 c9
    LD A,$05                          ; $C038 3e 05
    RET                               ; $C03A c9

    ORG $C821
; CODE fino a $C897
; Filtro percettivo: barriere di contenimento, flag visibilita, occorrenze nella stanza.
    PUSH IX                           ; $C821 dd e5
    PUSH BC                           ; $C823 c5
    CALL $D237                        ; $C824 cd 37 d2
    LD B,A                            ; $C827 47
    LD A,($A036)                      ; $C828 3a 36 a0
    CALL $C863                        ; $C82B cd 63 c8
    CP B                              ; $C82E b8
    JR Z,$C85D                        ; $C82F 28 2c
    BIT 7,(IX+$05)                    ; $C831 dd cb 05 7e
    JR Z,$C85A                        ; $C835 28 23
    LD C,A                            ; $C837 4f
    LD A,B                            ; $C838 78
    LD B,C                            ; $C839 41
    CALL $C863                        ; $C83A cd 63 c8
    LD C,A                            ; $C83D 4f
    LD A,($A036)                      ; $C83E 3a 36 a0
    CP C                              ; $C841 b9
    JR Z,$C85D                        ; $C842 28 19
    LD A,C                            ; $C844 79
    CP B                              ; $C845 b8
    JR NZ,$C85A                       ; $C846 20 12
    INC A                             ; $C848 3c
    JR NZ,$C85D                       ; $C849 20 12
    LD B,(IX+$00)                     ; $C84B dd 46 00
    LD A,($A00A)                      ; $C84E 3a 0a a0
    CP (IX+$0F)                       ; $C851 dd be 0f
    JR Z,$C85D                        ; $C854 28 07
    INC IX                            ; $C856 dd 23
    DJNZ $C851                        ; $C858 10 f7
    XOR A                             ; $C85A af
    JR $C85F                          ; $C85B 18 02
    OR $01                            ; $C85D f6 01
    POP BC                            ; $C85F c1
    POP IX                            ; $C860 dd e1
    RET                               ; $C862 c9
; Trova barriera del contenimento a partire dall ID.
    PUSH IX                           ; $C863 dd e5
    CALL $D237                        ; $C865 cd 37 d2
    CALL $C86E                        ; $C868 cd 6e c8
    POP IX                            ; $C86B dd e1
    RET                               ; $C86D c9
; Risale genitori finche visibili e aperti/rotti; FF se nessuna barriera.
    PUSH IX                           ; $C86E dd e5
    EX AF,AF'                         ; $C870 08
    LD A,$FF                          ; $C871 3e ff
    EX AF,AF'                         ; $C873 08
    LD A,(IX+$01)                     ; $C874 dd 7e 01
    CP $FF                            ; $C877 fe ff
    JR Z,$C895                        ; $C879 28 1a
    EX AF,AF'                         ; $C87B 08
    LD A,(IX+$01)                     ; $C87C dd 7e 01
    CALL $D237                        ; $C87F cd 37 d2
    BIT 7,(IX+$05)                    ; $C882 dd cb 05 7e
    JR Z,$C894                        ; $C886 28 0c
    BIT 5,(IX+$05)                    ; $C888 dd cb 05 6e
    JR NZ,$C873                       ; $C88C 20 e5
    BIT 3,(IX+$05)                    ; $C88E dd cb 05 5e
    JR NZ,$C873                       ; $C892 20 df
    EX AF,AF'                         ; $C894 08
    POP IX                            ; $C895 dd e1
    RET                               ; $C897 c9

    ORG $CA7F
; CODE fino a $CAAD
; Dopo il corpo della regola, verifica se Holmes ha cambiato stanza.
    LD A,($9860)                      ; $CA7F 3a 60 98
    CALL $D237                        ; $CA82 cd 37 d2
    LD A,($A009)                      ; $CA85 3a 09 a0
    CP (IX+$0F)                       ; $CA88 dd be 0f
    RET Z                             ; $CA8B c8
    LD A,($A036)                      ; $CA8C 3a 36 a0
    PUSH AF                           ; $CA8F f5
    LD A,($9860)                      ; $CA90 3a 60 98
    LD ($A036),A                      ; $CA93 32 36 a0
    CALL $CA9E                        ; $CA96 cd 9e ca
    POP AF                            ; $CA99 f1
    LD ($A036),A                      ; $CA9A 32 36 a0
    RET                               ; $CA9D c9
; Ingresso: bit6 del record locazione seleziona descrizione breve/estesa.
    LD A,($DD01)                      ; $CA9E 3a 01 dd
    LD HL,($DCFF)                     ; $CAA1 2a ff dc
    BIT 6,(HL)                        ; $CAA4 cb 76
    JP NZ,$D1B2                       ; $CAA6 c2 b2 d1
; Marca visitata soltanto nel percorso del primo ingresso.
    SET 6,(HL)                        ; $CAA9 cb f6
    JP $D102                          ; $CAAB c3 02 d1

    ORG $D045
; CODE fino a $D059
; Aggiorna A009 con locazione corrente del giocatore.
    LD A,($9860)                      ; $D045 3a 60 98
    CALL $D495                        ; $D048 cd 95 d4
    LD ($A009),A                      ; $D04B 32 09 a0
    RET                               ; $D04E c9
    LD IX,$8B6F                       ; $D04F dd 21 6f 8b
    DEC IX                            ; $D053 dd 2b
    DEC IX                            ; $D055 dd 2b
    DEC IX                            ; $D057 dd 2b
    RET                               ; $D059 c9

    ORG $D05A
; DATA fino a $D077
; Riferimenti lessicali alle relazioni; da D064 anche direzioni. Non Z80.
    DEFB $24,$06,$66,$04,$50,$04,$FF,$05 ; $D05A 24 06 66 04 50 04 ff 05
    DEFB $9A,$00,$C3,$05,$1A,$08,$84,$02 ; $D062 9a 00 c3 05 1a 08 84 02
    DEFB $92,$09,$C7,$05,$D0,$05,$1E,$08 ; $D06A 92 09 c7 05 d0 05 1e 08
    DEFB $27,$08,$3C,$09,$72,$02      ; $D072 27 08 3c 09 72 02

    ORG $D078
; CODE fino a $D0DB
; Test del buio: contesto, flag stanza, fascia oraria e sorgenti di luce percepibili.
    PUSH IX                           ; $D078 dd e5
    PUSH IY                           ; $D07A fd e5
    PUSH BC                           ; $D07C c5
    LD IX,($A017)                     ; $D07D dd 2a 17 a0
    LD A,(IX+$04)                     ; $D081 dd 7e 04
    AND $80                           ; $D084 e6 80
    JR Z,$D0C6                        ; $D086 28 3e
    CALL $C86E                        ; $D088 cd 6e c8
    INC A                             ; $D08B 3c
    JR NZ,$D09E                       ; $D08C 20 10
    CALL $D33C                        ; $D08E cd 3c d3
    BIT 7,(IX+$00)                    ; $D091 dd cb 00 7e
    JR NZ,$D0C6                       ; $D095 20 2f
    CALL $C00C                        ; $D097 cd 0c c0
    CP $01                            ; $D09A fe 01
    JR NZ,$D0C6                       ; $D09C 20 28
    LD IX,$8B6F                       ; $D09E dd 21 6f 8b
    CALL $D206                        ; $D0A2 cd 06 d2
    JR Z,$D0C9                        ; $D0A5 28 22
    LD A,(IY+$00)                     ; $D0A7 fd 7e 00
    CP $01                            ; $D0AA fe 01
    JR NZ,$D0A2                       ; $D0AC 20 f4
    LD A,(IY+$05)                     ; $D0AE fd 7e 05
    XOR $B7                           ; $D0B1 ee b7
    AND $5C                           ; $D0B3 e6 5c
    JR NZ,$D0A2                       ; $D0B5 20 eb
    LD A,(IY+$04)                     ; $D0B7 fd 7e 04
    AND $80                           ; $D0BA e6 80
    JR Z,$D0A2                        ; $D0BC 28 e4
    LD A,(IX+$00)                     ; $D0BE dd 7e 00
    CALL $C821                        ; $D0C1 cd 21 c8
    JR Z,$D0A2                        ; $D0C4 28 dc
    AND A                             ; $D0C6 a7
    JR $D0CA                          ; $D0C7 18 01
    SCF                               ; $D0C9 37
    POP BC                            ; $D0CA c1
    POP IY                            ; $D0CB fd e1
    POP IX                            ; $D0CD dd e1
    RET                               ; $D0CF c9
    PUSH DE                           ; $D0D0 d5
    LD DE,$68DE                       ; $D0D1 11 de 68
    EX DE,HL                          ; $D0D4 eb
    SET 7,D                           ; $D0D5 cb fa
    LD (HL),D                         ; $D0D7 72
    INC HL                            ; $D0D8 23
    LD (HL),E                         ; $D0D9 73
    POP DE                            ; $D0DA d1
    RET                               ; $D0DB c9

    ORG $D0DC
; DATA fino a $D0DC
; Stato mutabile: forma di descrizione (es. LOOK THROUGH).
    DEFB $00                          ; $D0DC 00

    ORG $D0DD
; CODE fino a $D1DA
; Seleziona frase generica e relazione locativa dai bit1..3 del record.
    PUSH AF                           ; $D0DD f5
    CALL $D224                        ; $D0DE cd 24 d2
    LD A,($D0DC)                      ; $D0E1 3a dc d0
    AND A                             ; $D0E4 a7
    LD HL,$68E4                       ; $D0E5 21 e4 68
    JR NZ,$D100                       ; $D0E8 20 16
    LD A,(IX+$00)                     ; $D0EA dd 7e 00
    AND $0E                           ; $D0ED e6 0e
    LD E,A                            ; $D0EF 5f
    LD D,$00                          ; $D0F0 16 00
    LD HL,$D05A                       ; $D0F2 21 5a d0
    ADD HL,DE                         ; $D0F5 19
    LD E,(HL)                         ; $D0F6 5e
    INC HL                            ; $D0F7 23
    LD D,(HL)                         ; $D0F8 56
    EX DE,HL                          ; $D0F9 eb
    CALL $D0D0                        ; $D0FA cd d0 d0
    LD HL,$68DD                       ; $D0FD 21 dd 68
    POP AF                            ; $D100 f1
    RET                               ; $D101 c9
; Descrizione estesa della scena.
    CALL $D0DD                        ; $D102 cd dd d0
    PUSH IX                           ; $D105 dd e5
    PUSH IY                           ; $D107 fd e5
    PUSH BC                           ; $D109 c5
    CALL $D113                        ; $D10A cd 13 d1
    POP BC                            ; $D10D c1
    POP IY                            ; $D10E fd e1
    POP IX                            ; $D110 dd e1
    RET                               ; $D112 c9
; Grafica opzionale, eventuale contenitore del giocatore, testo, uscite, oggetti.
    LD B,A                            ; $D113 47
    CALL $D224                        ; $D114 cd 24 d2
    LD A,B                            ; $D117 78
    CALL $A277                        ; $D118 cd 77 a2
    PUSH IX                           ; $D11B dd e5
    PUSH BC                           ; $D11D c5
    PUSH HL                           ; $D11E e5
    LD A,($A036)                      ; $D11F 3a 36 a0
    CALL $C863                        ; $D122 cd 63 c8
    EX AF,AF'                         ; $D125 08
    CP $FF                            ; $D126 fe ff
    JR Z,$D167                        ; $D128 28 3d
    PUSH AF                           ; $D12A f5
    LD HL,($68DE)                     ; $D12B 2a de 68
    PUSH HL                           ; $D12E e5
    LD HL,$8000                       ; $D12F 21 00 80
    CALL $D0D0                        ; $D132 cd d0 d0
    LD HL,$68DD                       ; $D135 21 dd 68
    CALL $A59F                        ; $D138 cd 9f a5
    POP HL                            ; $D13B e1
    LD ($68DE),HL                     ; $D13C 22 de 68
    POP AF                            ; $D13F f1
    PUSH AF                           ; $D140 f5
    CALL $D237                        ; $D141 cd 37 d2
    CALL $D5D3                        ; $D144 cd d3 d5
    CALL $D3D5                        ; $D147 cd d5 d3
    POP AF                            ; $D14A f1
    PUSH AF                           ; $D14B f5
    CALL $D4CC                        ; $D14C cd cc d4
    AND A                             ; $D14F a7
    JR Z,$D163                        ; $D150 28 11
    LD C,A                            ; $D152 4f
    LD DE,$09BF                       ; $D153 11 bf 09
    CALL $A887                        ; $D156 cd 87 a8
    LD A,($A00A)                      ; $D159 3a 0a a0
    LD B,A                            ; $D15C 47
    POP AF                            ; $D15D f1
    CALL $D51A                        ; $D15E cd 1a d5
    JR $D167                          ; $D161 18 04
    CALL $A414                        ; $D163 cd 14 a4
    POP AF                            ; $D166 f1
    POP DE                            ; $D167 d1
    POP BC                            ; $D168 c1
    POP IX                            ; $D169 dd e1
; Puntatore descrizione compressa a +7/+8.
    LD L,(IX+$07)                     ; $D16B dd 6e 07
    LD H,(IX+$08)                     ; $D16E dd 66 08
    CALL $D182                        ; $D171 cd 82 d1
    LD A,B                            ; $D174 78
    CALL $D60B                        ; $D175 cd 0b d6
    LD A,B                            ; $D178 78
    CALL $D68C                        ; $D179 cd 8c d6
    CALL $D4A7                        ; $D17C cd a7 d4
    JP $A2A2                          ; $D17F c3 a2 a2
; Puntatore zero: frase generica e nome; altrimenti A59F.
    LD A,H                            ; $D182 7c
    OR L                              ; $D183 b5
    JP NZ,$A59F                       ; $D184 c2 9f a5
    EX DE,HL                          ; $D187 eb
    LD A,($A036)                      ; $D188 3a 36 a0
    PUSH AF                           ; $D18B f5
    LD A,($A036)                      ; $D18C 3a 36 a0
    CALL $C863                        ; $D18F cd 63 c8
    EX AF,AF'                         ; $D192 08
    INC A                             ; $D193 3c
    JR Z,$D19F                        ; $D194 28 09
    DEC A                             ; $D196 3d
    LD ($A036),A                      ; $D197 32 36 a0
    LD A,$01                          ; $D19A 3e 01
    LD ($A2AA),A                      ; $D19C 32 aa a2
    CALL $A59F                        ; $D19F cd 9f a5
    POP AF                            ; $D1A2 f1
    LD ($A036),A                      ; $D1A3 32 36 a0
    XOR A                             ; $D1A6 af
    LD ($A2AA),A                      ; $D1A7 32 aa a2
    CALL $D1C6                        ; $D1AA cd c6 d1
    LD A,$2E                          ; $D1AD 3e 2e
    JP $A9B7                          ; $D1AF c3 b7 a9
; Descrizione breve: nome; poi uscite senza oggetto e oggetti, oppure buio.
    LD B,A                            ; $D1B2 47
    CALL $D0DD                        ; $D1B3 cd dd d0
    EX DE,HL                          ; $D1B6 eb
    CALL $D187                        ; $D1B7 cd 87 d1
    CALL $D078                        ; $D1BA cd 78 d0
    JR NC,$D178                       ; $D1BD 30 b9
    LD HL,$68C1                       ; $D1BF 21 c1 68
    CALL $A59F                        ; $D1C2 cd 9f a5
    RET                               ; $D1C5 c9
; Stampa nome locazione, campi +1/+3/+5.
    LD DE,$0001                       ; $D1C6 11 01 00
    PUSH IY                           ; $D1C9 fd e5
    PUSH IX                           ; $D1CB dd e5
    POP IY                            ; $D1CD fd e1
    ADD IY,DE                         ; $D1CF fd 19
    XOR A                             ; $D1D1 af
    LD ($A028),A                      ; $D1D2 32 28 a0
    CALL $D405                        ; $D1D5 cd 05 d4
    POP IY                            ; $D1D8 fd e1
    RET                               ; $D1DA c9

    ORG $D224
; CODE fino a $D274
; ID locazione -> IX tramite indice 840B.
    PUSH DE                           ; $D224 d5
    LD DE,$840B                       ; $D225 11 0b 84
    PUSH HL                           ; $D228 e5
    LD L,A                            ; $D229 6f
    LD H,$00                          ; $D22A 26 00
    ADD HL,HL                         ; $D22C 29
    ADD HL,DE                         ; $D22D 19
    LD E,(HL)                         ; $D22E 5e
    INC HL                            ; $D22F 23
    LD D,(HL)                         ; $D230 56
    PUSH DE                           ; $D231 d5
    POP IX                            ; $D232 dd e1
    POP HL                            ; $D234 e1
    POP DE                            ; $D235 d1
    RET                               ; $D236 c9
; ID entita -> IX tramite indice 8B6F.
    LD IX,$8B6F                       ; $D237 dd 21 6f 8b
    CALL $D34E                        ; $D23B cd 4e d3
    PUSH HL                           ; $D23E e5
    LD L,(IX+$01)                     ; $D23F dd 6e 01
    LD H,(IX+$02)                     ; $D242 dd 66 02
    EX (SP),HL                        ; $D245 e3
    POP IX                            ; $D246 dd e1
    RET                               ; $D248 c9
; Propaga la locazione a tutti i discendenti dell entita spostata.
    PUSH IY                           ; $D249 fd e5
    PUSH IX                           ; $D24B dd e5
    CALL $D04F                        ; $D24D cd 4f d0
    CALL $D21C                        ; $D250 cd 1c d2
    JR Z,$D267                        ; $D253 28 12
    CP (IY+$01)                       ; $D255 fd be 01
    JR NZ,$D250                       ; $D258 20 f6
    LD (IY+$0F),B                     ; $D25A fd 70 0f
    PUSH AF                           ; $D25D f5
    LD A,(IX+$00)                     ; $D25E dd 7e 00
    CALL $D249                        ; $D261 cd 49 d2
    POP AF                            ; $D264 f1
    JR $D250                          ; $D265 18 e9
    POP IX                            ; $D267 dd e1
    POP IY                            ; $D269 fd e1
    RET                               ; $D26B c9
    PUSH HL                           ; $D26C e5
    LD A,($A034)                      ; $D26D 3a 34 a0
    CALL $D275                        ; $D270 cd 75 d2
    POP HL                            ; $D273 e1
    RET                               ; $D274 c9

    ORG $D33C
; CODE fino a $D348
; Record della stanza corrente dell attore.
    PUSH AF                           ; $D33C f5
    LD IX,($A017)                     ; $D33D dd 2a 17 a0
    LD A,(IX+$0F)                     ; $D341 dd 7e 0f
    CALL $D224                        ; $D344 cd 24 d2
    POP AF                            ; $D347 f1
    RET                               ; $D348 c9

    ORG $D39B
; CODE fino a $D5C8
; Matching nominale delle locazioni; esclude slot 6A.
    PUSH IY                           ; $D39B fd e5
    PUSH DE                           ; $D39D d5
    PUSH BC                           ; $D39E c5
    PUSH IX                           ; $D39F dd e5
    POP BC                            ; $D3A1 c1
    LD DE,$0001                       ; $D3A2 11 01 00
    INC B                             ; $D3A5 04
    LD A,B                            ; $D3A6 78
    CP $6A                            ; $D3A7 fe 6a
    LD A,$FF                          ; $D3A9 3e ff
    JR Z,$D3CD                        ; $D3AB 28 20
    LD A,B                            ; $D3AD 78
    CALL $D224                        ; $D3AE cd 24 d2
    PUSH IX                           ; $D3B1 dd e5
    POP IY                            ; $D3B3 fd e1
    ADD IY,DE                         ; $D3B5 fd 19
    CALL $A4E0                        ; $D3B7 cd e0 a4
    JR NZ,$D3A5                       ; $D3BA 20 e9
    LD A,($A038)                      ; $D3BC 3a 38 a0
    AND A                             ; $D3BF a7
    JR NZ,$D3CC                       ; $D3C0 20 0a
    PUSH BC                           ; $D3C2 c5
    LD A,B                            ; $D3C3 78
    CALL $D471                        ; $D3C4 cd 71 d4
    POP BC                            ; $D3C7 c1
    CP $FF                            ; $D3C8 fe ff
    JR Z,$D3A5                        ; $D3CA 28 d9
    LD A,B                            ; $D3CC 78
    PUSH BC                           ; $D3CD c5
    POP IX                            ; $D3CE dd e1
    POP BC                            ; $D3D0 c1
    POP DE                            ; $D3D1 d1
    POP IY                            ; $D3D2 fd e1
    RET                               ; $D3D4 c9
    PUSH IX                           ; $D3D5 dd e5
    POP IY                            ; $D3D7 fd e1
    PUSH IY                           ; $D3D9 fd e5
    PUSH DE                           ; $D3DB d5
    LD DE,$0007                       ; $D3DC 11 07 00
    ADD IY,DE                         ; $D3DF fd 19
    CALL $D3E8                        ; $D3E1 cd e8 d3
    POP DE                            ; $D3E4 d1
    POP IY                            ; $D3E5 fd e1
    RET                               ; $D3E7 c9
    PUSH AF                           ; $D3E8 f5
    PUSH DE                           ; $D3E9 d5
    LD D,(IY+$01)                     ; $D3EA fd 56 01
    LD E,(IY+$00)                     ; $D3ED fd 5e 00
    CALL $A7D0                        ; $D3F0 cd d0 a7
    BIT 6,(IY-$02)                    ; $D3F3 fd cb fe 76
    JR NZ,$D3FD                       ; $D3F7 20 04
    XOR A                             ; $D3F9 af
    LD ($A7EA),A                      ; $D3FA 32 ea a7
    BIT 5,(IY-$01)                    ; $D3FD fd cb ff 6e
    JR NZ,$D427                       ; $D401 20 24
    JR $D416                          ; $D403 18 11
    PUSH AF                           ; $D405 f5
    PUSH DE                           ; $D406 d5
    LD D,(IY+$01)                     ; $D407 fd 56 01
    LD E,(IY+$00)                     ; $D40A fd 5e 00
    CALL $A7D0                        ; $D40D cd d0 a7
    LD A,($A028)                      ; $D410 3a 28 a0
    AND A                             ; $D413 a7
    JR NZ,$D438                       ; $D414 20 22
    LD E,(IY+$02)                     ; $D416 fd 5e 02
    LD D,(IY+$03)                     ; $D419 fd 56 03
    RES 7,D                           ; $D41C cb ba
    BIT 7,(IY+$03)                    ; $D41E fd cb 03 7e
    LD A,$40                          ; $D422 3e 40
    CALL Z,$A815                      ; $D424 cc 15 a8
    LD E,(IY+$04)                     ; $D427 fd 5e 04
    LD D,(IY+$05)                     ; $D42A fd 56 05
    RES 7,D                           ; $D42D cb ba
    BIT 7,(IY+$05)                    ; $D42F fd cb 05 7e
    LD A,$40                          ; $D433 3e 40
    CALL Z,$A815                      ; $D435 cc 15 a8
    LD E,(IY+$00)                     ; $D438 fd 5e 00
    LD D,(IY+$01)                     ; $D43B fd 56 01
    LD A,D                            ; $D43E 7a
    OR E                              ; $D43F b3
    LD A,$50                          ; $D440 3e 50
    CALL NZ,$A815                     ; $D442 c4 15 a8
    POP DE                            ; $D445 d1
    POP AF                            ; $D446 f1
    RET                               ; $D447 c9
; Cerca uscita per codice direzione; triplette a record+9.
    PUSH DE                           ; $D448 d5
    PUSH BC                           ; $D449 c5
    PUSH IY                           ; $D44A fd e5
    LD B,A                            ; $D44C 47
    CALL $D33C                        ; $D44D cd 3c d3
    LD DE,$0006                       ; $D450 11 06 00
    ADD IX,DE                         ; $D453 dd 19
    CALL $D206                        ; $D455 cd 06 d2
    JR Z,$D467                        ; $D458 28 0d
    LD A,(IX+$02)                     ; $D45A dd 7e 02
    AND A                             ; $D45D a7
    JR Z,$D455                        ; $D45E 28 f5
    LD A,(IX+$00)                     ; $D460 dd 7e 00
    CP B                              ; $D463 b8
    JP NZ,$D455                       ; $D464 c2 55 d4
    POP IY                            ; $D467 fd e1
    POP BC                            ; $D469 c1
    POP DE                            ; $D46A d1
    RET                               ; $D46B c9
; Cerca uscita per ID del passaggio, campo+1.
    PUSH AF                           ; $D46C f5
    LD A,$01                          ; $D46D 3e 01
    JR $D474                          ; $D46F 18 03
; Cerca uscita per destinazione, campo+2; modifica operando D48D.
    PUSH AF                           ; $D471 f5
    LD A,$02                          ; $D472 3e 02
    LD ($D48D),A                      ; $D474 32 8d d4
    POP AF                            ; $D477 f1
    PUSH BC                           ; $D478 c5
    PUSH IY                           ; $D479 fd e5
    LD B,A                            ; $D47B 47
    PUSH DE                           ; $D47C d5
    CALL $D33C                        ; $D47D cd 3c d3
    LD DE,$0006                       ; $D480 11 06 00
    ADD IX,DE                         ; $D483 dd 19
    POP DE                            ; $D485 d1
    CALL $D206                        ; $D486 cd 06 d2
    JR Z,$D491                        ; $D489 28 06
    LD A,(IX+$02)                     ; $D48B dd 7e 02
    CP B                              ; $D48E b8
    JR NZ,$D486                       ; $D48F 20 f5
    POP IY                            ; $D491 fd e1
    POP BC                            ; $D493 c1
    RET                               ; $D494 c9
; Locazione singola di un entita; FF se non ha esattamente un occorrenza.
    CP $FF                            ; $D495 fe ff
    RET Z                             ; $D497 c8
    CALL $D237                        ; $D498 cd 37 d2
    LD A,$01                          ; $D49B 3e 01
    CP (IX+$00)                       ; $D49D dd be 00
    LD A,$FF                          ; $D4A0 3e ff
    RET NZ                            ; $D4A2 c0
    LD A,(IX+$0F)                     ; $D4A3 dd 7e 0f
    RET                               ; $D4A6 c9
; You can see...: elenco dei figli diretti di FF.
    PUSH IY                           ; $D4A7 fd e5
    PUSH AF                           ; $D4A9 f5
    PUSH BC                           ; $D4AA c5
    LD A,$FF                          ; $D4AB 3e ff
    CALL $D4CC                        ; $D4AD cd cc d4
    JR Z,$D4C7                        ; $D4B0 28 15
    PUSH AF                           ; $D4B2 f5
    LD HL,$68E4                       ; $D4B3 21 e4 68
    CALL $A59F                        ; $D4B6 cd 9f a5
    POP BC                            ; $D4B9 c1
    LD C,B                            ; $D4BA 48
    LD A,$FF                          ; $D4BB 3e ff
    LD IY,($A017)                     ; $D4BD fd 2a 17 a0
    LD B,(IY+$0F)                     ; $D4C1 fd 46 0f
    CALL $D51A                        ; $D4C4 cd 1a d5
    POP BC                            ; $D4C7 c1
    POP AF                            ; $D4C8 f1
    POP IY                            ; $D4C9 fd e1
    RET                               ; $D4CB c9
; Conta candidati per un dato genitore.
    PUSH IX                           ; $D4CC dd e5
    PUSH IY                           ; $D4CE fd e5
    PUSH HL                           ; $D4D0 e5
    PUSH BC                           ; $D4D1 c5
    CALL $D04F                        ; $D4D2 cd 4f d0
    LD B,$00                          ; $D4D5 06 00
    LD C,A                            ; $D4D7 4f
    CALL $D206                        ; $D4D8 cd 06 d2
    JR Z,$D4E6                        ; $D4DB 28 09
    LD A,C                            ; $D4DD 79
    CALL $D4EF                        ; $D4DE cd ef d4
    JR NC,$D4D8                       ; $D4E1 30 f5
    INC B                             ; $D4E3 04
    JR $D4D8                          ; $D4E4 18 f2
    LD A,B                            ; $D4E6 78
    AND A                             ; $D4E7 a7
    POP BC                            ; $D4E8 c1
    POP HL                            ; $D4E9 e1
    POP IY                            ; $D4EA fd e1
    POP IX                            ; $D4EC dd e1
    RET                               ; $D4EE c9
; Filtro elenco: genitore, non attore, C821, meno di2 occorrenze, non posseduto.
    CP (IY+$01)                       ; $D4EF fd be 01
    JR NZ,$D518                       ; $D4F2 20 24
    LD A,($A036)                      ; $D4F4 3a 36 a0
    CP (IX+$00)                       ; $D4F7 dd be 00
    JR Z,$D518                        ; $D4FA 28 1c
    LD A,(IX+$00)                     ; $D4FC dd 7e 00
    CALL $C821                        ; $D4FF cd 21 c8
    JR Z,$D518                        ; $D502 28 14
    LD A,(IY+$00)                     ; $D504 fd 7e 00
    CP $02                            ; $D507 fe 02
    JR NC,$D518                       ; $D509 30 0d
    LD A,($A036)                      ; $D50B 3a 36 a0
    PUSH IX                           ; $D50E dd e5
    POP HL                            ; $D510 e1
    CALL $D278                        ; $D511 cd 78 d2
    JR C,$D518                        ; $D514 38 02
    SCF                               ; $D516 37
    RET                               ; $D517 c9
    AND A                             ; $D518 a7
    RET                               ; $D519 c9
; Stampa elenco e ricorsione sui contenuti.
    PUSH IY                           ; $D51A fd e5
    PUSH DE                           ; $D51C d5
    PUSH BC                           ; $D51D c5
    CALL $D526                        ; $D51E cd 26 d5
    POP BC                            ; $D521 c1
    POP DE                            ; $D522 d1
    POP IY                            ; $D523 fd e1
    RET                               ; $D525 c9
    PUSH IX                           ; $D526 dd e5
    CALL $D04F                        ; $D528 cd 4f d0
    PUSH AF                           ; $D52B f5
    CALL $D57D                        ; $D52C cd 7d d5
    JR C,$D55A                        ; $D52F 38 29
; Marca bit7 di +6 dell entita elencata.
    SET 7,(IY+$06)                    ; $D531 fd cb 06 fe
    SUB A                             ; $D535 97
    LD ($A028),A                      ; $D536 32 28 a0
    CALL $D3D9                        ; $D539 cd d9 d3
    DEC C                             ; $D53C 0d
    LD A,C                            ; $D53D 79
    AND A                             ; $D53E a7
    JR NZ,$D546                       ; $D53F 20 05
    CALL $A414                        ; $D541 cd 14 a4
    JR $D557                          ; $D544 18 11
    CP $01                            ; $D546 fe 01
    JR Z,$D551                        ; $D548 28 07
    LD A,$2C                          ; $D54A 3e 2c
    CALL $A9B7                        ; $D54C cd b7 a9
    JR $D557                          ; $D54F 18 06
    LD DE,$005D                       ; $D551 11 5d 00
    CALL $A887                        ; $D554 cd 87 a8
    POP AF                            ; $D557 f1
    JR $D52B                          ; $D558 18 d1
; Secondo passaggio: presenta ricorsivamente i contenuti.
    POP AF                            ; $D55A f1
    CALL $D04F                        ; $D55B cd 4f d0
    PUSH AF                           ; $D55E f5
    CALL $D57D                        ; $D55F cd 7d d5
    JR C,$D578                        ; $D562 38 14
    PUSH AF                           ; $D564 f5
    CALL $D4CC                        ; $D565 cd cc d4
    JR Z,$D574                        ; $D568 28 0a
    LD C,A                            ; $D56A 4f
    POP AF                            ; $D56B f1
    CALL $D590                        ; $D56C cd 90 d5
    CALL $D526                        ; $D56F cd 26 d5
    JR $D575                          ; $D572 18 01
    POP AF                            ; $D574 f1
    POP AF                            ; $D575 f1
    JR $D55E                          ; $D576 18 e6
    POP AF                            ; $D578 f1
    POP IX                            ; $D579 dd e1
    RET                               ; $D57B c9
    POP AF                            ; $D57C f1
    CALL $D21C                        ; $D57D cd 1c d2
    JR NZ,$D584                       ; $D580 20 02
    SCF                               ; $D582 37
    RET                               ; $D583 c9
    PUSH AF                           ; $D584 f5
    CALL $D4EF                        ; $D585 cd ef d4
    JR NC,$D57C                       ; $D588 30 f2
    POP AF                            ; $D58A f1
    LD A,(IX+$00)                     ; $D58B dd 7e 00
    AND A                             ; $D58E a7
    RET                               ; $D58F c9
; Contenitore personale: carrying; altrimenti relazione in/on/behind/under/tied.
    PUSH IX                           ; $D590 dd e5
    PUSH BC                           ; $D592 c5
    PUSH AF                           ; $D593 f5
    CALL $D237                        ; $D594 cd 37 d2
    BIT 6,(IX+$05)                    ; $D597 dd cb 05 76
    JR Z,$D5A5                        ; $D59B 28 08
    POP AF                            ; $D59D f1
    PUSH AF                           ; $D59E f5
    PUSH AF                           ; $D59F f5
    LD HL,$68B1                       ; $D5A0 21 b1 68
    JR $D5C1                          ; $D5A3 18 1c
    LD HL,$0485                       ; $D5A5 21 85 04
    DEC C                             ; $D5A8 0d
    JR Z,$D5AE                        ; $D5A9 28 03
    LD HL,$007A                       ; $D5AB 21 7a 00
    PUSH HL                           ; $D5AE e5
    CALL $D5D3                        ; $D5AF cd d3 d5
    LD A,$01                          ; $D5B2 3e 01
    LD ($A2AA),A                      ; $D5B4 32 aa a2
    CALL $D3D5                        ; $D5B7 cd d5 d3
    XOR A                             ; $D5BA af
    LD ($A2AA),A                      ; $D5BB 32 aa a2
    LD HL,$68D9                       ; $D5BE 21 d9 68
    CALL $A59F                        ; $D5C1 cd 9f a5
    POP AF                            ; $D5C4 f1
    POP BC                            ; $D5C5 c1
    POP IX                            ; $D5C6 dd e1
    RET                               ; $D5C8 c9

    ORG $D5C9
; DATA fino a $D5D2
; Cinque riferimenti lessicali delle relazioni di contenimento.
    DEFB $50,$04,$FF,$05,$DC,$00,$19,$09 ; $D5C9 50 04 ff 05 dc 00 19 09
    DEFB $D3,$08                      ; $D5D1 d3 08

    ORG $D5D3
; CODE fino a $D6B7
; Relazione dal campo+4 &7 del contenitore.
    LD HL,$D5C9                       ; $D5D3 21 c9 d5
    LD A,(IX+$04)                     ; $D5D6 dd 7e 04
    AND $07                           ; $D5D9 e6 07
    CP $05                            ; $D5DB fe 05
    PUSH AF                           ; $D5DD f5
    DEC A                             ; $D5DE 3d
    LD E,A                            ; $D5DF 5f
    LD D,$00                          ; $D5E0 16 00
    ADD HL,DE                         ; $D5E2 19
    ADD HL,DE                         ; $D5E3 19
    CALL $A880                        ; $D5E4 cd 80 a8
    POP AF                            ; $D5E7 f1
    RET NZ                            ; $D5E8 c0
    LD DE,$08DB                       ; $D5E9 11 db 08
    JP $A887                          ; $D5EC c3 87 a8
; Prepara iterazione delle triplette di uscita.
    CALL $D224                        ; $D5EF cd 24 d2
    LD BC,$0006                       ; $D5F2 01 06 00
    ADD IX,BC                         ; $D5F5 dd 09
    LD BC,$0003                       ; $D5F7 01 03 00
    RET                               ; $D5FA c9
    LD HL,$D064                       ; $D5FB 21 64 d0
    DEC HL                            ; $D5FE 2b
    DEC HL                            ; $D5FF 2b
    LD E,A                            ; $D600 5f
    RES 7,E                           ; $D601 cb bb
    LD D,$00                          ; $D603 16 00
    ADD HL,DE                         ; $D605 19
    ADD HL,DE                         ; $D606 19
    LD E,(HL)                         ; $D607 5e
    INC HL                            ; $D608 23
    LD D,(HL)                         ; $D609 56
    RET                               ; $D60A c9
; Descrive passaggi nonzero con flag visibilita: To the west..., Above..., Below...
    PUSH BC                           ; $D60B c5
    PUSH DE                           ; $D60C d5
    PUSH IY                           ; $D60D fd e5
    PUSH IX                           ; $D60F dd e5
    CALL $D5EF                        ; $D611 cd ef d5
    PUSH IX                           ; $D614 dd e5
    POP IY                            ; $D616 fd e1
    JR $D660                          ; $D618 18 46
    LD A,(IY+$01)                     ; $D61A fd 7e 01
    AND A                             ; $D61D a7
    JR Z,$D660                        ; $D61E 28 40
    LD A,(IY+$00)                     ; $D620 fd 7e 00
    CP $0B                            ; $D623 fe 0b
    JR NC,$D660                       ; $D625 30 39
    LD A,(IY+$01)                     ; $D627 fd 7e 01
    CALL $D237                        ; $D62A cd 37 d2
    BIT 7,(IX+$05)                    ; $D62D dd cb 05 7e
    JR Z,$D660                        ; $D631 28 2d
    LD A,(IY+$00)                     ; $D633 fd 7e 00
    CALL $D5FB                        ; $D636 cd fb d5
    CP $09                            ; $D639 fe 09
    JR C,$D647                        ; $D63B 38 0a
    LD DE,$000A                       ; $D63D 11 0a 00
    JR Z,$D64D                        ; $D640 28 0b
    LD DE,$00E7                       ; $D642 11 e7 00
    JR $D64D                          ; $D645 18 06
    LD HL,$68BC                       ; $D647 21 bc 68
    CALL $A59F                        ; $D64A cd 9f a5
    CALL $A887                        ; $D64D cd 87 a8
    LD HL,$68E9                       ; $D650 21 e9 68
    CALL $A59F                        ; $D653 cd 9f a5
    PUSH IY                           ; $D656 fd e5
    CALL $D3D5                        ; $D658 cd d5 d3
    CALL $A414                        ; $D65B cd 14 a4
    POP IY                            ; $D65E fd e1
    ADD IY,BC                         ; $D660 fd 09
    LD A,$FF                          ; $D662 3e ff
    CP (IY+$00)                       ; $D664 fd be 00
    JP NZ,$D61A                       ; $D667 c2 1a d6
    POP IX                            ; $D66A dd e1
    POP IY                            ; $D66C fd e1
    POP DE                            ; $D66E d1
    POP BC                            ; $D66F c1
    RET                               ; $D670 c9
; Itera uscite direzionali senza entita interposta.
    ADD IX,BC                         ; $D671 dd 09
    LD A,$FF                          ; $D673 3e ff
    CP (IX+$00)                       ; $D675 dd be 00
    RET Z                             ; $D678 c8
    XOR A                             ; $D679 af
    CP (IX+$01)                       ; $D67A dd be 01
    JR NZ,$D671                       ; $D67D 20 f2
    LD A,(IX+$00)                     ; $D67F dd 7e 00
    AND A                             ; $D682 a7
    JR Z,$D671                        ; $D683 28 ec
    CP $0B                            ; $D685 fe 0b
    JR NC,$D671                       ; $D687 30 e8
    OR $01                            ; $D689 f6 01
    RET                               ; $D68B c9
; Elenco generico delle uscite senza passaggio.
    PUSH IX                           ; $D68C dd e5
    PUSH IY                           ; $D68E fd e5
    PUSH DE                           ; $D690 d5
    PUSH BC                           ; $D691 c5
    CALL $D5EF                        ; $D692 cd ef d5
    CALL $D671                        ; $D695 cd 71 d6
    JR Z,$D6B1                        ; $D698 28 17
    LD HL,$68F1                       ; $D69A 21 f1 68
    CALL $A59F                        ; $D69D cd 9f a5
    LD A,(IX+$00)                     ; $D6A0 dd 7e 00
    CALL $D5FB                        ; $D6A3 cd fb d5
    CALL $A887                        ; $D6A6 cd 87 a8
    CALL $D671                        ; $D6A9 cd 71 d6
    JR NZ,$D6A0                       ; $D6AC 20 f2
    CALL $A414                        ; $D6AE cd 14 a4
    POP BC                            ; $D6B1 c1
    POP DE                            ; $D6B2 d1
    POP IY                            ; $D6B3 fd e1
    POP IX                            ; $D6B5 dd e1
    RET                               ; $D6B7 c9

    ORG $DC20
; CODE fino a $DC56
; LOOK THROUGH: trasferimento temporaneo, descrizione breve, ripristino posizione.
    CALL $DC6C                        ; $DC20 cd 6c dc
    RET NZ                            ; $DC23 c0
    LD A,($A034)                      ; $DC24 3a 34 a0
    CALL $D46C                        ; $DC27 cd 6c d4
    LD A,(IX+$02)                     ; $DC2A dd 7e 02
    AND A                             ; $DC2D a7
    JR Z,$DC4B                        ; $DC2E 28 1b
    LD B,A                            ; $DC30 47
    LD A,($A00A)                      ; $DC31 3a 0a a0
    PUSH AF                           ; $DC34 f5
    LD A,$01                          ; $DC35 3e 01
    LD ($D0DC),A                      ; $DC37 32 dc d0
    CALL $DD0B                        ; $DC3A cd 0b dd
    LD A,($A00A)                      ; $DC3D 3a 0a a0
    CALL $D1B2                        ; $DC40 cd b2 d1
    POP BC                            ; $DC43 c1
    CALL $DD0B                        ; $DC44 cd 0b dd
    XOR A                             ; $DC47 af
    LD ($D0DC),A                      ; $DC48 32 dc d0
    OR $01                            ; $DC4B f6 01
    RET                               ; $DC4D c9
; Predicato GO THROUGH: cerca passaggio poi condizioni comuni di movimento.
    LD A,($A034)                      ; $DC4E 3a 34 a0
    CALL $D46C                        ; $DC51 cd 6c d4
    JP $DCDD                          ; $DC54 c3 dd dc

    ORG $DC57
; DATA fino a $DC5A
; Header GO THROUGH: 4B 20 4E DC; costo2, predicato DC4E.
    DEFB $4B,$20,$4E,$DC              ; $DC57 4b 20 4e dc

    ORG $DC5B
; CODE fino a $DC7A
; Ricava direzione dall arco e usa corpo comune DD07.
    LD A,(IX+$00)                     ; $DC5B dd 7e 00
    LD ($A033),A                      ; $DC5E 32 33 a0
    XOR A                             ; $DC61 af
    LD ($A00F),A                      ; $DC62 32 0f a0
    DEC A                             ; $DC65 3d
    LD ($A034),A                      ; $DC66 32 34 a0
    JP $DD07                          ; $DC69 c3 07 dd
    LD A,($A036)                      ; $DC6C 3a 36 a0
    CP $00                            ; $DC6F fe 00
    RET Z                             ; $DC71 c8
    CP $01                            ; $DC72 fe 01
    RET Z                             ; $DC74 c8
    CP $64                            ; $DC75 fe 64
    RET Z                             ; $DC77 c8
    OR $01                            ; $DC78 f6 01
    RET                               ; $DC7A c9

    ORG $DC7B
; DATA fino a $DC7C
; Header LOOK: 20 10; richiede luce, costo1.
    DEFB $20,$10                      ; $DC7B 20 10

    ORG $DC7D
; CODE fino a $DC8C
; LOOK esplicito richiede sempre D102; qui non marca il bit di visita.
    CALL $DC6C                        ; $DC7D cd 6c dc
    RET NZ                            ; $DC80 c0
    CALL $A2A2                        ; $DC81 cd a2 a2
    LD A,($A00A)                      ; $DC84 3a 0a a0
    CALL $D102                        ; $DC87 cd 02 d1
    OR $01                            ; $DC8A f6 01
    RET                               ; $DC8C c9

    ORG $DCD2
; CODE fino a $DCFE
; Predicato direzioni: uscita, vincoli contesto, attore non contenuto, destinazione nonzero, passaggio.
    LD A,($A033)                      ; $DCD2 3a 33 a0
    CALL $D448                        ; $DCD5 cd 48 d4
    CP $FF                            ; $DCD8 fe ff
    JP Z,$DC15                        ; $DCDA ca 15 dc
    CALL $CBA7                        ; $DCDD cd a7 cb
    LD IY,($A017)                     ; $DCE0 fd 2a 17 a0
    LD A,(IY+$01)                     ; $DCE4 fd 7e 01
    CP $FF                            ; $DCE7 fe ff
    JP NZ,$DC15                       ; $DCE9 c2 15 dc
    LD A,(IX+$02)                     ; $DCEC dd 7e 02
    AND A                             ; $DCEF a7
    JP Z,$DC15                        ; $DCF0 ca 15 dc
    LD A,(IX+$01)                     ; $DCF3 dd 7e 01
    CALL $DD35                        ; $DCF6 cd 35 dd
    JP NZ,$DC15                       ; $DCF9 c2 15 dc
    OR $01                            ; $DCFC f6 01
    RET                               ; $DCFE c9

    ORG $DCFF
; DATA fino a $DD02
; Puntatore ultima destinazione (word) e ID destinazione DD01. Stato, non Z80.
    DEFB $00,$00,$00,$00              ; $DCFF 00 00 00 00

    ORG $DD03
; DATA fino a $DD06
; Header movimento direzionale: 60 20 D2 DC; luce, costo2, predicato DCD2.
    DEFB $60,$20,$D2,$DC              ; $DD03 60 20 d2 dc

    ORG $DD07
; CODE fino a $DD51
; Destinazione dalla tripletta poi DD0B.
    LD A,(IX+$02)                     ; $DD07 dd 7e 02
    LD B,A                            ; $DD0A 47
; Sposta attore: aggiorna campo+0F e discendenti D249.
    LD A,($A036)                      ; $DD0B 3a 36 a0
    PUSH AF                           ; $DD0E f5
    LD HL,$A036                       ; $DD0F 21 36 a0
    CP (HL)                           ; $DD12 be
    LD A,B                            ; $DD13 78
    JR NZ,$DD19                       ; $DD14 20 03
    LD ($A00A),A                      ; $DD16 32 0a a0
    CP $FF                            ; $DD19 fe ff
    JR NZ,$DD1E                       ; $DD1B 20 01
    XOR A                             ; $DD1D af
    LD ($DD01),A                      ; $DD1E 32 01 dd
    CALL $D224                        ; $DD21 cd 24 d2
    LD ($DCFF),IX                     ; $DD24 dd 22 ff dc
    POP AF                            ; $DD28 f1
    CALL $D237                        ; $DD29 cd 37 d2
    LD (IX+$0F),B                     ; $DD2C dd 70 0f
    CALL $D249                        ; $DD2F cd 49 d2
    OR $01                            ; $DD32 f6 01
    RET                               ; $DD34 c9
; Passaggio 0 libero; altrimenti flag aperto/rotto e confronto campo+2 con quello dell attore.
    AND A                             ; $DD35 a7
    RET Z                             ; $DD36 c8
    PUSH IX                           ; $DD37 dd e5
    CALL $D237                        ; $DD39 cd 37 d2
    LD A,(IX+$05)                     ; $DD3C dd 7e 05
    AND $28                           ; $DD3F e6 28
    LD A,(IX+$02)                     ; $DD41 dd 7e 02
    POP IX                            ; $DD44 dd e1
    JR Z,$DD4F                        ; $DD46 28 07
    CP (IY+$02)                       ; $DD48 fd be 02
    JR C,$DD4F                        ; $DD4B 38 02
    XOR A                             ; $DD4D af
    RET                               ; $DD4E c9
    OR $01                            ; $DD4F f6 01
    RET                               ; $DD51 c9

    ORG $DD52
; DATA fino a $DD64
; Header GO INTO e sequenza differita; poi header regola ausiliaria DD61. NON Z80.
    DEFB $A4,$00,$17,$61,$DD,$FD,$FF,$60 ; $DD52 a4 00 17 61 dd fd ff 60
    DEFB $DD,$11,$FD,$60,$DD,$0B,$0A,$64 ; $DD5A dd 11 fd 60 dd 0b 0a 64
    DEFB $00,$6E,$DD                  ; $DD62 00 6e dd

    ORG $DD65
; CODE fino a $DD83
; Salva direzione trovata nel primo argomento della sequenza.
    LD A,(IX+$00)                     ; $DD65 dd 7e 00
    LD ($9FD7),A                      ; $DD68 32 d7 9f
    OR $01                            ; $DD6B f6 01
    RET                               ; $DD6D c9
; Cerca locazione adiacente per argomento e verifica direzione inferiore a0B.
    LD A,($A034)                      ; $DD6E 3a 34 a0
    CALL $D471                        ; $DD71 cd 71 d4
    CP $FF                            ; $DD74 fe ff
    JP Z,$DC15                        ; $DD76 ca 15 dc
    LD A,(IX+$00)                     ; $DD79 dd 7e 00
    CP $0B                            ; $DD7C fe 0b
    JP NC,$DC15                       ; $DD7E d2 15 dc
    OR $01                            ; $DD81 f6 01
    RET                               ; $DD83 c9
