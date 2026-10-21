; Sherlock: AI. Dati/bytecode non vengono disassemblati come istruzioni Z80.

    ORG $9C6A
    LD A,($A036)                                  ; $9C6A 3a 36 a0
    LD IX,$9C85                                   ; $9C6D dd 21 85 9c
    CALL $D34E                                    ; $9C71 cd 4e d3
    CP $FF                                        ; $9C74 fe ff
    RET                                           ; $9C76 c9
    CALL $9C6A                                    ; $9C77 cd 6a 9c
    RET Z                                         ; $9C7A c8
    LD L,(IX+$01)                                 ; $9C7B dd 6e 01
    LD H,(IX+$02)                                 ; $9C7E dd 66 02
    LD A,L                                        ; $9C81 7d
    OR H                                          ; $9C82 b4
    RET Z                                         ; $9C83 c8
    JP (HL)                                       ; $9C84 e9
    DEFB $02,$FF,$9D,$03,$13,$9D,$04,$30          ; $9C85 02 ff 9d 03 13 9d 04 30
    DEFB $9D,$0B,$48,$9D,$0C,$73,$9D,$08          ; $9C8D 9d 0b 48 9d 0c 73 9d 08
    DEFB $D1,$9E,$09,$CB,$9E,$05,$C1,$9E          ; $9C95 d1 9e 09 cb 9e 05 c1 9e
    DEFB $06,$A2,$9C,$FF,$0F                      ; $9C9D 06 a2 9c ff 0f
    LD A,$55                                      ; $9CA2 3e 55
    CALL $D237                                    ; $9CA4 cd 37 d2
    BIT 7,(IX+$05)                                ; $9CA7 dd cb 05 7e
    RET Z                                         ; $9CAB c8
    LD HL,$9CA1                                   ; $9CAC 21 a1 9c
    LD A,(HL)                                     ; $9CAF 7e
    CP $FF                                        ; $9CB0 fe ff
    RET Z                                         ; $9CB2 c8
    DEC (HL)                                      ; $9CB3 35
    RET NZ                                        ; $9CB4 c0
    LD HL,$015B                                   ; $9CB5 21 5b 01
    LD (IX+$09),L                                 ; $9CB8 dd 75 09
    LD (IX+$0A),H                                 ; $9CBB dd 74 0a
    XOR A                                         ; $9CBE af
    LD (IX+$0D),A                                 ; $9CBF dd 77 0d
    LD (IX+$0E),A                                 ; $9CC2 dd 77 0e
    LD IX,$99B7                                   ; $9CC5 dd 21 b7 99
    RES 1,(IX+$03)                                ; $9CC9 dd cb 03 8e
    RET                                           ; $9CCD c9
    LD IX,($A017)                                 ; $9CCE dd 2a 17 a0
    LD B,(IX+$0F)                                 ; $9CD2 dd 46 0f
    LD A,C                                        ; $9CD5 79
    CALL $D237                                    ; $9CD6 cd 37 d2
    LD A,(IX+$0F)                                 ; $9CD9 dd 7e 0f
    CP B                                          ; $9CDC b8
    RET NZ                                        ; $9CDD c0
    LD A,C                                        ; $9CDE 79
    CALL $C821                                    ; $9CDF cd 21 c8
    JR Z,$9CE6                                    ; $9CE2 28 02
    XOR A                                         ; $9CE4 af
    RET                                           ; $9CE5 c9
    OR $01                                        ; $9CE6 f6 01
    RET                                           ; $9CE8 c9
    CALL $9CF2                                    ; $9CE9 cd f2 9c
    LD HL,$6929                                   ; $9CEC 21 29 69
    JP $A59F                                      ; $9CEF c3 9f a5
    LD A,C                                        ; $9CF2 79
    LD ($A034),A                                  ; $9CF3 32 34 a0
    CALL $9CCE                                    ; $9CF6 cd ce 9c
    JR Z,$9D02                                    ; $9CF9 28 07
    DEC (HL)                                      ; $9CFB 35
    JP P,$9D00                                    ; $9CFC f2 00 9d
    INC (HL)                                      ; $9CFF 34
    POP DE                                        ; $9D00 d1
    RET                                           ; $9D01 c9
    LD A,(HL)                                     ; $9D02 7e
    AND A                                         ; $9D03 a7
    JR NZ,$9D00                                   ; $9D04 20 fa
    LD A,$0F                                      ; $9D06 3e 0f
    CALL $D2A4                                    ; $9D08 cd a4 d2
    ADD A,$1E                                     ; $9D0B c6 1e
    LD (HL),A                                     ; $9D0D 77
    XOR A                                         ; $9D0E af
    RET                                           ; $9D0F c9
    DEFB $1E,$00,$00                              ; $9D10 1e 00 00
; Z80: Callback Watson: saluti con contatori di incontri; poi E691.
    LD HL,$9D10                                   ; $9D13 21 10 9d
    LD C,$00                                      ; $9D16 0e 00
    CALL $9CE9                                    ; $9D18 cd e9 9c
    LD HL,$9D11                                   ; $9D1B 21 11 9d
    LD C,$02                                      ; $9D1E 0e 02
    CALL $9CE9                                    ; $9D20 cd e9 9c
    LD HL,$9D12                                   ; $9D23 21 12 9d
    LD C,$04                                      ; $9D26 0e 04
    CALL $9CE9                                    ; $9D28 cd e9 9c
    JP $E691                                      ; $9D2B c3 91 e6

    ORG $9D95
    LD HL,$9D91                                   ; $9D95 21 91 9d
    LD C,$00                                      ; $9D98 0e 00
    CALL $9DC6                                    ; $9D9A cd c6 9d
    LD HL,$9D94                                   ; $9D9D 21 94 9d
    LD C,$00                                      ; $9DA0 0e 00
    CALL $9DD8                                    ; $9DA2 cd d8 9d
    LD HL,$9D93                                   ; $9DA5 21 93 9d
    LD C,$03                                      ; $9DA8 0e 03
    CALL $9CE9                                    ; $9DAA cd e9 9c
    LD IX,$99E3                                   ; $9DAD dd 21 e3 99
    RES 0,(IX+$03)                                ; $9DB1 dd cb 03 86
    LD IX,$99F1                                   ; $9DB5 dd 21 f1 99
    RES 0,(IX+$03)                                ; $9DB9 dd cb 03 86
    LD IX,$99A9                                   ; $9DBD dd 21 a9 99
    RES 0,(IX+$03)                                ; $9DC1 dd cb 03 86
    RET                                           ; $9DC5 c9
    INC HL                                        ; $9DC6 23
    CALL $9CF2                                    ; $9DC7 cd f2 9c
    DEC HL                                        ; $9DCA 2b
    LD A,(HL)                                     ; $9DCB 7e
    AND A                                         ; $9DCC a7
    JP NZ,$9CEC                                   ; $9DCD c2 ec 9c
    INC A                                         ; $9DD0 3c
    LD (HL),A                                     ; $9DD1 77
    LD HL,$71ED                                   ; $9DD2 21 ed 71
    JP $A59F                                      ; $9DD5 c3 9f a5
    CALL $9CF2                                    ; $9DD8 cd f2 9c
    LD (HL),$01                                   ; $9DDB 36 01
    CALL $BC46                                    ; $9DDD cd 46 bc
    CALL $BC9C                                    ; $9DE0 cd 9c bc
    LD A,B                                        ; $9DE3 78
    AND A                                         ; $9DE4 a7
    JR NZ,$9DF5                                   ; $9DE5 20 0e
    CALL $BC74                                    ; $9DE7 cd 74 bc
    AND A                                         ; $9DEA a7
    RET Z                                         ; $9DEB c8
    PUSH IX                                       ; $9DEC dd e5
    LD HL,$722D                                   ; $9DEE 21 2d 72
    CALL $A59F                                    ; $9DF1 cd 9f a5
    RET                                           ; $9DF4 c9
    BIT 4,(IX+$03)                                ; $9DF5 dd cb 03 66
    RET NZ                                        ; $9DF9 c0
    LD A,$01                                      ; $9DFA 3e 01
    JP $BBE5                                      ; $9DFC c3 e5 bb
; Z80: Callback Lestrade: controlla presenza/percezione di Straker e Holmes, modifica stato e callback.
    LD C,$04                                      ; $9DFF 0e 04
    CALL $9CCE                                    ; $9E01 cd ce 9c
    JR NZ,$9D95                                   ; $9E04 20 8f
    LD C,$00                                      ; $9E06 0e 00
    CALL $9CCE                                    ; $9E08 cd ce 9c
    JR NZ,$9D95                                   ; $9E0B 20 88
    LD A,$04                                      ; $9E0D 3e 04
    LD ($A034),A                                  ; $9E0F 32 34 a0
    LD A,$01                                      ; $9E12 3e 01
    LD ($9D90),A                                  ; $9E14 32 90 9d
    LD A,$5C                                      ; $9E17 3e 5c
    CALL $D224                                    ; $9E19 cd 24 d2
    LD (IX+$0A),$00                               ; $9E1C dd 36 0a 00
    LD A,$3E                                      ; $9E20 3e 3e
    CALL $D224                                    ; $9E22 cd 24 d2
    LD (IX+$0A),$00                               ; $9E25 dd 36 0a 00
    LD HL,$9D95                                   ; $9E29 21 95 9d
    LD ($9C86),HL                                 ; $9E2C 22 86 9c
    LD A,$01                                      ; $9E2F 3e 01
    LD ($9D92),A                                  ; $9E31 32 92 9d
    LD A,($9D91)                                  ; $9E34 3a 91 9d
    AND A                                         ; $9E37 a7
    LD HL,$7207                                   ; $9E38 21 07 72
    JR NZ,$9E44                                   ; $9E3B 20 07
    INC A                                         ; $9E3D 3c
    LD ($9D91),A                                  ; $9E3E 32 91 9d
    LD HL,$7224                                   ; $9E41 21 24 72
    CALL $A59F                                    ; $9E44 cd 9f a5
    RET                                           ; $9E47 c9
; HEADER: regola da approfondire; corpo codice Z80 $9E4A; costo0
    DEFB $00,$00                                  ; $9E48 00 00

    ORG $9E6A
; HEADER: regola da approfondire; corpo codice Z80 $9E6C; costo0
    DEFB $00,$00                                  ; $9E6A 00 00

    ORG $9E85
; HEADER: regola da approfondire; corpo codice Z80 $9E87; costo0
    DEFB $00,$00                                  ; $9E85 00 00

    ORG $9EA2
; HEADER: regola da approfondire; corpo codice Z80 $9EA4; costo0
    DEFB $00,$00                                  ; $9EA2 00 00

    ORG $B86A
    PUSH AF                                       ; $B86A f5
    LD IX,$9FEE                                   ; $B86B dd 21 ee 9f
    CALL $A0F7                                    ; $B86F cd f7 a0
    JR Z,$B8A8                                    ; $B872 28 34
    LD C,(IX+$00)                                 ; $B874 dd 4e 00
    LD B,(IX+$01)                                 ; $B877 dd 46 01
    LD ($B868),BC                                 ; $B87A ed 43 68 b8
    LD L,(IX-$02)                                 ; $B87E dd 6e fe
    LD H,(IX-$01)                                 ; $B881 dd 66 ff
    LD ($9FEC),HL                                 ; $B884 22 ec 9f
    CALL $A1C7                                    ; $B887 cd c7 a1
    POP AF                                        ; $B88A f1
    PUSH AF                                       ; $B88B f5
    AND A                                         ; $B88C a7
    JR Z,$B894                                    ; $B88D 28 05
    CALL $B8AA                                    ; $B88F cd aa b8
    JR Z,$B8A8                                    ; $B892 28 14
    LD BC,($B868)                                 ; $B894 ed 4b 68 b8
    LD ($A02B),BC                                 ; $B898 ed 43 2b a0
    CALL $AE7F                                    ; $B89C cd 7f ae
    CP $C0                                        ; $B89F fe c0
    JR NZ,$B89C                                   ; $B8A1 20 f9
    LD HL,($A029)                                 ; $B8A3 2a 29 a0
    LD (HL),$90                                   ; $B8A6 36 90
    POP AF                                        ; $B8A8 f1
    RET                                           ; $B8A9 c9
    LD HL,($B868)                                 ; $B8AA 2a 68 b8
    LD ($A02B),HL                                 ; $B8AD 22 2b a0
    XOR A                                         ; $B8B0 af
    LD ($A024),A                                  ; $B8B1 32 24 a0
    LD HL,($9FF0)                                 ; $B8B4 2a f0 9f
    PUSH HL                                       ; $B8B7 e5
    LD HL,$0000                                   ; $B8B8 21 00 00
    LD ($9FF0),HL                                 ; $B8BB 22 f0 9f
    CALL $AAB2                                    ; $B8BE cd b2 aa
    JR Z,$B8C7                                    ; $B8C1 28 04
    CP $02                                        ; $B8C3 fe 02
    JR NZ,$B904                                   ; $B8C5 20 3d
    LD HL,($A02B)                                 ; $B8C7 2a 2b a0
    LD A,(HL)                                     ; $B8CA 7e
    AND $F0                                       ; $B8CB e6 f0
    CP $C0                                        ; $B8CD fe c0
    JR NZ,$B8BE                                   ; $B8CF 20 ed
    LD (HL),$90                                   ; $B8D1 36 90
; Z80: Richiesta da citazione: record8byte, con lista di nodi sintattici e modo.
    LD A,$08                                      ; $B8D3 3e 08
    CALL $A11C                                    ; $B8D5 cd 1c a1
    LD HL,($9FEE)                                 ; $B8D8 2a ee 9f
    LD ($9FEE),IX                                 ; $B8DB dd 22 ee 9f
    LD (IX-$02),L                                 ; $B8DF dd 75 fe
    LD (IX-$01),H                                 ; $B8E2 dd 74 ff
    LD HL,($9FF0)                                 ; $B8E5 2a f0 9f
    LD (IX+$05),L                                 ; $B8E8 dd 75 05
    LD (IX+$06),H                                 ; $B8EB dd 74 06
    POP HL                                        ; $B8EE e1
    LD ($9FF0),HL                                 ; $B8EF 22 f0 9f
    XOR A                                         ; $B8F2 af
    LD (IX+$01),A                                 ; $B8F3 dd 77 01
    LD A,($A034)                                  ; $B8F6 3a 34 a0
    LD (IX+$00),A                                 ; $B8F9 dd 77 00
    LD A,($A024)                                  ; $B8FC 3a 24 a0
    LD (IX+$07),A                                 ; $B8FF dd 77 07
    XOR A                                         ; $B902 af
    RET                                           ; $B903 c9
    PUSH AF                                       ; $B904 f5
    CALL $D87D                                    ; $B905 cd 7d d8
    POP AF                                        ; $B908 f1
    POP HL                                        ; $B909 e1
    LD ($9FF0),HL                                 ; $B90A 22 f0 9f
    RET                                           ; $B90D c9
    CALL $B91F                                    ; $B90E cd 1f b9
    LD ($B866),IX                                 ; $B911 dd 22 66 b8
    LD E,(IX+$05)                                 ; $B915 dd 5e 05
    LD D,(IX+$06)                                 ; $B918 dd 56 06
    PUSH DE                                       ; $B91B d5
    POP IY                                        ; $B91C fd e1
    RET                                           ; $B91E c9
; Z80: Cerca richiesta destinata all attore corrente nella lista9FEE.
    LD IX,$9FF0                                   ; $B91F dd 21 f0 9f
    CALL $A0F7                                    ; $B923 cd f7 a0
    JR Z,$B931                                    ; $B926 28 09
    LD A,($A036)                                  ; $B928 3a 36 a0
    CP (IX+$00)                                   ; $B92B dd be 00
    RET Z                                         ; $B92E c8
    JR $B923                                      ; $B92F 18 f2
    OR $01                                        ; $B931 f6 01
    RET                                           ; $B933 c9
    DEFB $00,$00                                  ; $B934 00 00
    PUSH IX                                       ; $B936 dd e5
    PUSH IY                                       ; $B938 fd e5
    PUSH HL                                       ; $B93A e5
    LD ($B935),A                                  ; $B93B 32 35 b9
    CALL $B90E                                    ; $B93E cd 0e b9
    LD A,(IX+$07)                                 ; $B941 dd 7e 07
    CP $02                                        ; $B944 fe 02
    JP Z,$BA20                                    ; $B946 ca 20 ba
    LD A,(IX+$01)                                 ; $B949 dd 7e 01
    CP $FF                                        ; $B94C fe ff
    JR Z,$B98C                                    ; $B94E 28 3c
    LD A,($B935)                                  ; $B950 3a 35 b9
    LD ($B934),A                                  ; $B953 32 34 b9
    LD A,(IX+$02)                                 ; $B956 dd 7e 02
    LD ($A01C),A                                  ; $B959 32 1c a0
    LD C,(IX+$03)                                 ; $B95C dd 4e 03
    LD B,(IX+$04)                                 ; $B95F dd 46 04
    LD ($B17E),BC                                 ; $B962 ed 43 7e b1
    CALL $B191                                    ; $B966 cd 91 b1
    JR Z,$B9B4                                    ; $B969 28 49
    LD IX,($B866)                                 ; $B96B dd 2a 66 b8
    LD BC,($B17E)                                 ; $B96F ed 4b 7e b1
    LD (IX+$03),C                                 ; $B973 dd 71 03
    LD (IX+$04),B                                 ; $B976 dd 70 04
    LD A,($A01C)                                  ; $B979 3a 1c a0
    LD (IX+$02),A                                 ; $B97C dd 77 02
    AND A                                         ; $B97F a7
    CALL Z,$B9CA                                  ; $B980 cc ca b9
    LD A,$01                                      ; $B983 3e 01
    POP HL                                        ; $B985 e1
    POP IY                                        ; $B986 fd e1
    POP IX                                        ; $B988 dd e1
    AND A                                         ; $B98A a7
    RET                                           ; $B98B c9
    LD A,(IX+$02)                                 ; $B98C dd 7e 02
    CALL $CEDE                                    ; $B98F cd de ce
    LD ($A033),A                                  ; $B992 32 33 a0
    LD A,(IX+$03)                                 ; $B995 dd 7e 03
    CALL $CEDE                                    ; $B998 cd de ce
    LD ($A034),A                                  ; $B99B 32 34 a0
    LD A,(IX+$04)                                 ; $B99E dd 7e 04
    CALL $CEDE                                    ; $B9A1 cd de ce
    LD ($A035),A                                  ; $B9A4 32 35 a0
    CALL $B9FA                                    ; $B9A7 cd fa b9
    JR $B983                                      ; $B9AA 18 d7
    CALL $B9CA                                    ; $B9AC cd ca b9
    JR NZ,$B9AC                                   ; $B9AF 20 fb
    XOR A                                         ; $B9B1 af
    JR $B985                                      ; $B9B2 18 d1
    LD A,($A01C)                                  ; $B9B4 3a 1c a0
    AND A                                         ; $B9B7 a7
    JR Z,$B9AC                                    ; $B9B8 28 f2
    LD IX,($B866)                                 ; $B9BA dd 2a 66 b8
    LD (IX+$02),$00                               ; $B9BE dd 36 02 00
    CALL $B9CA                                    ; $B9C2 cd ca b9
    JR Z,$B9B1                                    ; $B9C5 28 ea
    JP $B93E                                      ; $B9C7 c3 3e b9
    LD IX,($B866)                                 ; $B9CA dd 2a 66 b8
    LD L,(IY-$02)                                 ; $B9CE fd 6e fe
    LD H,(IY-$01)                                 ; $B9D1 fd 66 ff
    LD (IX+$05),L                                 ; $B9D4 dd 75 05
    LD (IX+$06),H                                 ; $B9D7 dd 74 06
    PUSH IX                                       ; $B9DA dd e5
    PUSH IY                                       ; $B9DC fd e5
    POP IX                                        ; $B9DE dd e1
    CALL $A1C7                                    ; $B9E0 cd c7 a1
    POP IX                                        ; $B9E3 dd e1
    LD A,L                                        ; $B9E5 7d
    OR H                                          ; $B9E6 b4
    JR Z,$B9F5                                    ; $B9E7 28 0c
    PUSH HL                                       ; $B9E9 e5
    POP IY                                        ; $B9EA fd e1
    BIT 6,(IY+$01)                                ; $B9EC fd cb 01 76
    JR NZ,$B9CE                                   ; $B9F0 20 dc
    OR $01                                        ; $B9F2 f6 01
    RET                                           ; $B9F4 c9
    CALL $B9FA                                    ; $B9F5 cd fa b9
    XOR A                                         ; $B9F8 af
    RET                                           ; $B9F9 c9
    LD IY,$9FEE                                   ; $B9FA fd 21 ee 9f
    PUSH IX                                       ; $B9FE dd e5
    POP DE                                        ; $BA00 d1
    CALL $A104                                    ; $BA01 cd 04 a1
    LD L,(IX-$02)                                 ; $BA04 dd 6e fe
    LD H,(IX-$01)                                 ; $BA07 dd 66 ff
    LD (IY-$02),L                                 ; $BA0A fd 75 fe
    LD (IY-$01),H                                 ; $BA0D fd 74 ff
    JP $A1C7                                      ; $BA10 c3 c7 a1
    DEFB $00,$00,$00,$00,$00,$00,$00,$00          ; $BA13 00 00 00 00 00 00 00 00
    DEFB $00,$00,$00,$00,$00                      ; $BA1B 00 00 00 00 00
; Z80: Modo2 (asserzioni): dispatch speciale Watson BA67 / Lestrade BB67.
    LD A,($A036)                                  ; $BA20 3a 36 a0
    LD HL,$BA67                                   ; $BA23 21 67 ba
    CP $03                                        ; $BA26 fe 03
    JR Z,$BA31                                    ; $BA28 28 07
    LD HL,$BB67                                   ; $BA2A 21 67 bb
    CP $02                                        ; $BA2D fe 02
    JR NZ,$BA34                                   ; $BA2F 20 03
    CALL $BA3E                                    ; $BA31 cd 3e ba
    LD A,$01                                      ; $BA34 3e 01
    POP HL                                        ; $BA36 e1
    POP IY                                        ; $BA37 fd e1
    POP IX                                        ; $BA39 dd e1
    AND A                                         ; $BA3B a7
    SCF                                           ; $BA3C 37
    RET                                           ; $BA3D c9
    PUSH IX                                       ; $BA3E dd e5
    XOR A                                         ; $BA40 af
    LD ($9FEB),A                                  ; $BA41 32 eb 9f
    LD E,(IX+$05)                                 ; $BA44 dd 5e 05
    LD D,(IX+$06)                                 ; $BA47 dd 56 06
    PUSH DE                                       ; $BA4A d5
    PUSH DE                                       ; $BA4B d5
    POP IY                                        ; $BA4C fd e1
    CALL $D1DB                                    ; $BA4E cd db d1
    POP IX                                        ; $BA51 dd e1
    PUSH AF                                       ; $BA53 f5
    CALL $A1AF                                    ; $BA54 cd af a1
    POP AF                                        ; $BA57 f1
    POP IX                                        ; $BA58 dd e1
    PUSH AF                                       ; $BA5A f5
    CALL $B9FA                                    ; $BA5B cd fa b9
    POP AF                                        ; $BA5E f1
    RET                                           ; $BA5F c9
    DEFB $00,$00,$00,$00,$00,$00,$00              ; $BA60 00 00 00 00 00 00 00
    LD ($BA60),A                                  ; $BA67 32 60 ba
    LD ($BA61),A                                  ; $BA6A 32 61 ba
    CALL $BD7E                                    ; $BA6D cd 7e bd
    JP C,$BBBE                                    ; $BA70 da be bb
    JR Z,$BAA6                                    ; $BA73 28 31
    CALL $BD4B                                    ; $BA75 cd 4b bd
    JR NZ,$BA85                                   ; $BA78 20 0b
    LD A,$01                                      ; $BA7A 3e 01
    CALL $BB46                                    ; $BA7C cd 46 bb
    LD ($BA65),IX                                 ; $BA7F dd 22 65 ba
    JR $BAAB                                      ; $BA83 18 26
    CALL $BD51                                    ; $BA85 cd 51 bd
    JR NZ,$BA9D                                   ; $BA88 20 13
    LD A,$02                                      ; $BA8A 3e 02
    BIT 5,(IX+$03)                                ; $BA8C dd cb 03 6e
    JR NZ,$BA7C                                   ; $BA90 20 ea
    CALL $D29D                                    ; $BA92 cd 9d d2
    CP $32                                        ; $BA95 fe 32
    LD A,$03                                      ; $BA97 3e 03
    JR C,$BA7C                                    ; $BA99 38 e1
    JR $BAA6                                      ; $BA9B 18 09
    CALL $D29D                                    ; $BA9D cd 9d d2
    CP $46                                        ; $BAA0 fe 46
    LD A,$04                                      ; $BAA2 3e 04
    JR C,$BA7C                                    ; $BAA4 38 d6
    CALL $AEA9                                    ; $BAA6 cd a9 ae
    JR NZ,$BA6D                                   ; $BAA9 20 c2
    LD A,($BA60)                                  ; $BAAB 3a 60 ba
    AND A                                         ; $BAAE a7
    JP Z,$BB3F                                    ; $BAAF ca 3f bb
    LD A,($BA61)                                  ; $BAB2 3a 61 ba
    AND A                                         ; $BAB5 a7
    JR Z,$BB16                                    ; $BAB6 28 5e
    LD IX,$9FF6                                   ; $BAB8 dd 21 f6 9f
    CALL $A0F7                                    ; $BABC cd f7 a0
    JR Z,$BAF5                                    ; $BABF 28 34
    LD A,($BA62)                                  ; $BAC1 3a 62 ba
    CP (IX+$00)                                   ; $BAC4 dd be 00
    JR NZ,$BABC                                   ; $BAC7 20 f3
    LD A,($BA63)                                  ; $BAC9 3a 63 ba
    CP (IX+$01)                                   ; $BACC dd be 01
    JR NZ,$BABC                                   ; $BACF 20 eb
    LD A,($BA64)                                  ; $BAD1 3a 64 ba
    CP (IX+$02)                                   ; $BAD4 dd be 02
    JR NZ,$BABC                                   ; $BAD7 20 e3
    PUSH IY                                       ; $BAD9 fd e5
    PUSH IX                                       ; $BADB dd e5
    POP DE                                        ; $BADD d1
    LD IY,$9FF4                                   ; $BADE fd 21 f4 9f
    CALL $A104                                    ; $BAE2 cd 04 a1
    LD A,(IX-$02)                                 ; $BAE5 dd 7e fe
    LD (IY-$02),A                                 ; $BAE8 fd 77 fe
    LD A,(IX-$01)                                 ; $BAEB dd 7e ff
    LD (IY-$01),A                                 ; $BAEE fd 77 ff
    POP IY                                        ; $BAF1 fd e1
    JR $BAFA                                      ; $BAF3 18 05
    LD A,$05                                      ; $BAF5 3e 05
    CALL $A11C                                    ; $BAF7 cd 1c a1
    LD A,($BA62)                                  ; $BAFA 3a 62 ba
    LD HL,($BA63)                                 ; $BAFD 2a 63 ba
    LD (IX+$00),A                                 ; $BB00 dd 77 00
    LD (IX+$01),L                                 ; $BB03 dd 75 01
    LD (IX+$02),H                                 ; $BB06 dd 74 02
    LD HL,($9FF4)                                 ; $BB09 2a f4 9f
    LD ($9FF4),IX                                 ; $BB0C dd 22 f4 9f
    LD (IX-$02),L                                 ; $BB10 dd 75 fe
    LD (IX-$01),H                                 ; $BB13 dd 74 ff
    LD A,($BA60)                                  ; $BB16 3a 60 ba
    CP $01                                        ; $BB19 fe 01
    JR Z,$BB5C                                    ; $BB1B 28 3f
    CALL $D29D                                    ; $BB1D cd 9d d2
    CP $19                                        ; $BB20 fe 19
    JR C,$BB3F                                    ; $BB22 38 1b
    LD IX,$BA62                                   ; $BB24 dd 21 62 ba
    CALL $BD06                                    ; $BB28 cd 06 bd
    JR NZ,$BB3F                                   ; $BB2B 20 12
    LD A,C                                        ; $BB2D 79
    PUSH BC                                       ; $BB2E c5
    CALL $A4BC                                    ; $BB2F cd bc a4
    POP AF                                        ; $BB32 f1
    PUSH HL                                       ; $BB33 e5
    CALL $A4BC                                    ; $BB34 cd bc a4
    PUSH HL                                       ; $BB37 e5
    LD HL,$6F62                                   ; $BB38 21 62 6f
    CALL $A59F                                    ; $BB3B cd 9f a5
    RET                                           ; $BB3E c9
    LD HL,$6F54                                   ; $BB3F 21 54 6f
    CALL $A59F                                    ; $BB42 cd 9f a5
    RET                                           ; $BB45 c9
    PUSH AF                                       ; $BB46 f5
    LD A,$01                                      ; $BB47 3e 01
    LD ($BA61),A                                  ; $BB49 32 61 ba
    POP AF                                        ; $BB4C f1
    LD ($BA60),A                                  ; $BB4D 32 60 ba
    LD HL,$BA19                                   ; $BB50 21 19 ba
    LD DE,$BA62                                   ; $BB53 11 62 ba
    LD BC,$0003                                   ; $BB56 01 03 00
    LDIR                                          ; $BB59 ed b0
    RET                                           ; $BB5B c9
    LD IX,($BA65)                                 ; $BB5C dd 2a 65 ba
    LD L,(IX+$03)                                 ; $BB60 dd 6e 03
    LD H,(IX+$04)                                 ; $BB63 dd 66 04
    JP (HL)                                       ; $BB66 e9

    ORG $CBA7
; Z80: Rifiuto condizionato dal bit6 del bytecode sospeso; chiamato solo da alcune regole.
    LD A,($B934)                                  ; $CBA7 3a 34 b9
    BIT 6,A                                       ; $CBAA cb 77
    RET Z                                         ; $CBAC c8
    POP HL                                        ; $CBAD e1
    XOR A                                         ; $CBAE af
    LD ($A027),A                                  ; $CBAF 32 27 a0
    LD HL,$681A                                   ; $CBB2 21 1a 68
    CALL $A59F                                    ; $CBB5 cd 9f a5
    JP $DC15                                      ; $CBB8 c3 15 dc

    ORG $CC0E
    PUSH DE                                       ; $CC0E d5
    PUSH BC                                       ; $CC0F c5
    LD C,A                                        ; $CC10 4f
    LD DE,$0008                                   ; $CC11 11 08 00
    LD IY,$9860                                   ; $CC14 fd 21 60 98
    LD A,(IY+$00)                                 ; $CC18 fd 7e 00
    CP C                                          ; $CC1B b9
    JR Z,$CC26                                    ; $CC1C 28 08
    CP $FF                                        ; $CC1E fe ff
    JR Z,$CC26                                    ; $CC20 28 04
    ADD IY,DE                                     ; $CC22 fd 19
    JR $CC18                                      ; $CC24 18 f2
    POP BC                                        ; $CC26 c1
    POP DE                                        ; $CC27 d1
    RET                                           ; $CC28 c9
    LD A,($A036)                                  ; $CC29 3a 36 a0
    CALL $D495                                    ; $CC2C cd 95 d4
    LD ($A017),IX                                 ; $CC2F dd 22 17 a0
    LD ($A00A),A                                  ; $CC33 32 0a a0
    RET                                           ; $CC36 c9
; Z80: Prepara attore, rileva richieste pendenti e azzera contatore fallimenti.
    PUSH AF                                       ; $CC37 f5
    XOR A                                         ; $CC38 af
    LD ($CC0B),A                                  ; $CC39 32 0b cc
    POP AF                                        ; $CC3C f1
    CALL $CC0E                                    ; $CC3D cd 0e cc
    CP $FF                                        ; $CC40 fe ff
    LD HL,$0001                                   ; $CC42 21 01 00
    JP Z,$CC74                                    ; $CC45 ca 74 cc
    LD ($9FDB),IY                                 ; $CC48 fd 22 db 9f
    LD ($A036),A                                  ; $CC4C 32 36 a0
    CALL $B91F                                    ; $CC4F cd 1f b9
    LD A,$00                                      ; $CC52 3e 00
    JR NZ,$CC57                                   ; $CC54 20 01
    INC A                                         ; $CC56 3c
    LD ($CC0D),A                                  ; $CC57 32 0d cc
    CALL $CC29                                    ; $CC5A cd 29 cc
    CALL $D045                                    ; $CC5D cd 45 d0
    SUB A                                         ; $CC60 97
    LD ($5C3C),A                                  ; $CC61 32 3c 5c
    LD A,($9860)                                  ; $CC64 3a 60 98
    CALL $C821                                    ; $CC67 cd 21 c8
    JR Z,$CC71                                    ; $CC6A 28 05
    LD A,$01                                      ; $CC6C 3e 01
    LD ($5C3C),A                                  ; $CC6E 32 3c 5c
    LD HL,$0000                                   ; $CC71 21 00 00
    LD ($A01F),HL                                 ; $CC74 22 1f a0
    RET                                           ; $CC77 c9
; Z80: Riprende lo stato persistente e il programma dell attore.
    CALL $CC5A                                    ; $CC78 cd 5a cc
    LD IY,($9FDB)                                 ; $CC7B fd 2a db 9f
    CALL $D008                                    ; $CC7F cd 08 d0
    LD L,(IY+$01)                                 ; $CC82 fd 6e 01
    LD H,(IY+$02)                                 ; $CC85 fd 66 02
    XOR A                                         ; $CC88 af
    LD ($B934),A                                  ; $CC89 32 34 b9
    LD A,($CC0B)                                  ; $CC8C 3a 0b cc
    CP $0A                                        ; $CC8F fe 0a
    JP Z,$CD8B                                    ; $CC91 ca 8b cd
    LD A,(HL)                                     ; $CC94 7e
    AND A                                         ; $CC95 a7
    JR NZ,$CC9B                                   ; $CC96 20 03
    INC HL                                        ; $CC98 23
    JR $CC94                                      ; $CC99 18 f9
    PUSH HL                                       ; $CC9B e5
    POP IX                                        ; $CC9C dd e1
    LD ($9FD9),HL                                 ; $CC9E 22 d9 9f
    AND $0F                                       ; $CCA1 e6 0f
    CP $0A                                        ; $CCA3 fe 0a
    JR NC,$CCF3                                   ; $CCA5 30 4c
    LD A,($CC0D)                                  ; $CCA7 3a 0d cc
    CP $01                                        ; $CCAA fe 01
    JR NZ,$CCC7                                   ; $CCAC 20 19
; Z80: Elabora al massimo una richiesta per preparazione dell attore; poi riprende il programma.
    SUB A                                         ; $CCAE 97
    LD ($CC0D),A                                  ; $CCAF 32 0d cc
    LD A,(HL)                                     ; $CCB2 7e
    CALL $B936                                    ; $CCB3 cd 36 b9
    JP C,$CD91                                    ; $CCB6 da 91 cd
    JR Z,$CCC7                                    ; $CCB9 28 0c
    CALL $C4D1                                    ; $CCBB cd d1 c4
    RET NC                                        ; $CCBE d0
    CALL $CFB6                                    ; $CCBF cd b6 cf
    LD (IX+$05),$02                               ; $CCC2 dd 36 05 02
    RET                                           ; $CCC6 c9
    LD A,(HL)                                     ; $CCC7 7e
    AND $0F                                       ; $CCC8 e6 0f
    CP $07                                        ; $CCCA fe 07
    JP Z,$CE3B                                    ; $CCCC ca 3b ce
    CP $06                                        ; $CCCF fe 06
    JP Z,$CD95                                    ; $CCD1 ca 95 cd
    CP $05                                        ; $CCD4 fe 05
    JP Z,$CDA1                                    ; $CCD6 ca a1 cd
    CP $04                                        ; $CCD9 fe 04
    JP Z,$CDBF                                    ; $CCDB ca bf cd
    CP $01                                        ; $CCDE fe 01
    JP Z,$CE6A                                    ; $CCE0 ca 6a ce
    CP $03                                        ; $CCE3 fe 03
    JP Z,$CE4F                                    ; $CCE5 ca 4f ce
    CP $08                                        ; $CCE8 fe 08
    JR Z,$CD24                                    ; $CCEA 28 38
    CP $09                                        ; $CCEC fe 09
    JR Z,$CD47                                    ; $CCEE 28 57
    JP $CE18                                      ; $CCF0 c3 18 ce
    CP $0E                                        ; $CCF3 fe 0e
    JR NZ,$CD06                                   ; $CCF5 20 0f
    LD A,(IX+$01)                                 ; $CCF7 dd 7e 01
    LD (IY+$01),A                                 ; $CCFA fd 77 01
    LD A,(IX+$02)                                 ; $CCFD dd 7e 02
    LD (IY+$02),A                                 ; $CD00 fd 77 02
    JP $CC82                                      ; $CD03 c3 82 cc
    CP $0C                                        ; $CD06 fe 0c
; Z80: Trappola intenzionale: JR su se stesso (opcode0C); non un normale yield.
    JR Z,$CD08                                    ; $CD08 28 fe
    CP $0B                                        ; $CD0A fe 0b
    JR NZ,$CD17                                   ; $CD0C 20 09
    CALL $CFCF                                    ; $CD0E cd cf cf
    CP $02                                        ; $CD11 fe 02
    RET Z                                         ; $CD13 c8
    JP $CE8F                                      ; $CD14 c3 8f ce
    CP $0A                                        ; $CD17 fe 0a
    JR NZ,$CD82                                   ; $CD19 20 67
    CALL $CFCF                                    ; $CD1B cd cf cf
    CP $02                                        ; $CD1E fe 02
    RET Z                                         ; $CD20 c8
    JP $CEB8                                      ; $CD21 c3 b8 ce
; Z80: Opcode08: aggiunge coppia mittente/destinatario alla lista9FE7.
    LD A,(IX+$01)                                 ; $CD24 dd 7e 01
    PUSH AF                                       ; $CD27 f5
    LD A,$02                                      ; $CD28 3e 02
    CALL $A11C                                    ; $CD2A cd 1c a1
    LD HL,($9FE7)                                 ; $CD2D 2a e7 9f
    LD ($9FE7),IX                                 ; $CD30 dd 22 e7 9f
    LD (IX-$02),L                                 ; $CD34 dd 75 fe
    LD (IX-$01),H                                 ; $CD37 dd 74 ff
    LD A,($A036)                                  ; $CD3A 3a 36 a0
    LD (IX+$00),A                                 ; $CD3D dd 77 00
    POP AF                                        ; $CD40 f1
    LD (IX+$01),A                                 ; $CD41 dd 77 01
    JP $CE8F                                      ; $CD44 c3 8f ce
; Z80: Opcode09: cerca segnale per attore corrente e mittente richiesto; lo consuma.
    LD B,(IX+$01)                                 ; $CD47 dd 46 01
    LD IX,$9FE9                                   ; $CD4A dd 21 e9 9f
    CALL $A0F7                                    ; $CD4E cd f7 a0
    JP Z,$CEB8                                    ; $CD51 ca b8 ce
    LD A,($A036)                                  ; $CD54 3a 36 a0
    CP (IX+$01)                                   ; $CD57 dd be 01
    JR NZ,$CD4E                                   ; $CD5A 20 f2
    LD A,B                                        ; $CD5C 78
    CP (IX+$00)                                   ; $CD5D dd be 00
    JR NZ,$CD4E                                   ; $CD60 20 ec
    PUSH IY                                       ; $CD62 fd e5
    PUSH IX                                       ; $CD64 dd e5
    POP DE                                        ; $CD66 d1
    LD IY,$9FE7                                   ; $CD67 fd 21 e7 9f
    CALL $A104                                    ; $CD6B cd 04 a1
    LD L,(IX-$02)                                 ; $CD6E dd 6e fe
    LD H,(IX-$01)                                 ; $CD71 dd 66 ff
    LD (IY-$02),L                                 ; $CD74 fd 75 fe
    LD (IY-$01),H                                 ; $CD77 fd 74 ff
    CALL $A1C7                                    ; $CD7A cd c7 a1
    POP IY                                        ; $CD7D fd e1
    JP $CE8F                                      ; $CD7F c3 8f ce
    LD HL,$0001                                   ; $CD82 21 01 00
    LD ($A01F),HL                                 ; $CD85 22 1f a0
    JP $CE8F                                      ; $CD88 c3 8f ce
    LD HL,$0001                                   ; $CD8B 21 01 00
    LD ($A01F),HL                                 ; $CD8E 22 1f a0
    CALL $D026                                    ; $CD91 cd 26 d0
    RET                                           ; $CD94 c9
    LD L,(IX+$01)                                 ; $CD95 dd 6e 01
    LD H,(IX+$02)                                 ; $CD98 dd 66 02
    CALL $A59F                                    ; $CD9B cd 9f a5
    JP $CE8F                                      ; $CD9E c3 8f ce
    LD L,(IX+$02)                                 ; $CDA1 dd 6e 02
    LD H,(IX+$03)                                 ; $CDA4 dd 66 03
    PUSH HL                                       ; $CDA7 e5
    LD A,(IX+$01)                                 ; $CDA8 dd 7e 01
    CALL $CEDE                                    ; $CDAB cd de ce
    LD ($A034),A                                  ; $CDAE 32 34 a0
    LD A,$07                                      ; $CDB1 3e 07
    LD ($A00F),A                                  ; $CDB3 32 0f a0
    LD HL,$6830                                   ; $CDB6 21 30 68
    CALL $A59F                                    ; $CDB9 cd 9f a5
    JP $CE8F                                      ; $CDBC c3 8f ce
; Z80: Opcode04: crea richiesta gia risolta [destinatario, FF, azione, arg1, arg2].
    LD A,$2E                                      ; $CDBF 3e 2e
    LD ($A033),A                                  ; $CDC1 32 33 a0
    LD A,(IX+$01)                                 ; $CDC4 dd 7e 01
    CALL $CEDE                                    ; $CDC7 cd de ce
    LD ($A034),A                                  ; $CDCA 32 34 a0
    LD A,(IX+$02)                                 ; $CDCD dd 7e 02
    LD ($A35D),A                                  ; $CDD0 32 5d a3
    LD A,(IX+$03)                                 ; $CDD3 dd 7e 03
    CALL $CEDE                                    ; $CDD6 cd de ce
    LD ($A35E),A                                  ; $CDD9 32 5e a3
    LD A,(IX+$04)                                 ; $CDDC dd 7e 04
    CALL $CEDE                                    ; $CDDF cd de ce
    LD ($A35F),A                                  ; $CDE2 32 5f a3
    LD A,$08                                      ; $CDE5 3e 08
    CALL $A11C                                    ; $CDE7 cd 1c a1
    LD A,($A034)                                  ; $CDEA 3a 34 a0
    LD (IX+$00),A                                 ; $CDED dd 77 00
    LD (IX+$01),$FF                               ; $CDF0 dd 36 01 ff
    LD A,($A35D)                                  ; $CDF4 3a 5d a3
    LD (IX+$02),A                                 ; $CDF7 dd 77 02
    LD HL,($A35E)                                 ; $CDFA 2a 5e a3
    LD (IX+$03),L                                 ; $CDFD dd 75 03
    LD (IX+$04),H                                 ; $CE00 dd 74 04
    LD HL,($9FEE)                                 ; $CE03 2a ee 9f
    LD ($9FEE),IX                                 ; $CE06 dd 22 ee 9f
    LD (IX-$02),L                                 ; $CE0A dd 75 fe
    LD (IX-$01),H                                 ; $CE0D dd 74 ff
    LD HL,$682A                                   ; $CE10 21 2a 68
    CALL $A59F                                    ; $CE13 cd 9f a5
    JR $CE8F                                      ; $CE16 18 77
    LD A,(IX+$01)                                 ; $CE18 dd 7e 01
    CALL $CEDE                                    ; $CE1B cd de ce
    LD ($A033),A                                  ; $CE1E 32 33 a0
    LD A,(IX+$02)                                 ; $CE21 dd 7e 02
    CALL $CEDE                                    ; $CE24 cd de ce
    LD ($A034),A                                  ; $CE27 32 34 a0
    LD A,(IX+$03)                                 ; $CE2A dd 7e 03
    CALL $CEDE                                    ; $CE2D cd de ce
    LD ($A035),A                                  ; $CE30 32 35 a0
    CALL $C4D1                                    ; $CE33 cd d1 c4
    RET C                                         ; $CE36 d8
    JR Z,$CEB8                                    ; $CE37 28 7f
    JR $CE8F                                      ; $CE39 18 54
    LD A,(IX+$03)                                 ; $CE3B dd 7e 03
    CALL $CEDE                                    ; $CE3E cd de ce
    LD ($A034),A                                  ; $CE41 32 34 a0
    LD A,(IX+$04)                                 ; $CE44 dd 7e 04
    CALL $CEDE                                    ; $CE47 cd de ce
    LD ($A035),A                                  ; $CE4A 32 35 a0
    JR $CE57                                      ; $CE4D 18 08
    LD A,$FF                                      ; $CE4F 3e ff
    LD ($A034),A                                  ; $CE51 32 34 a0
    LD ($A035),A                                  ; $CE54 32 35 a0
    LD A,$FF                                      ; $CE57 3e ff
    LD ($A033),A                                  ; $CE59 32 33 a0
    LD L,(IX+$01)                                 ; $CE5C dd 6e 01
    LD H,(IX+$02)                                 ; $CE5F dd 66 02
    CALL $C591                                    ; $CE62 cd 91 c5
    RET C                                         ; $CE65 d8
    JR Z,$CEB8                                    ; $CE66 28 50
    JR $CE8F                                      ; $CE68 18 25
    LD A,(IX+$01)                                 ; $CE6A dd 7e 01
    CALL $CEDE                                    ; $CE6D cd de ce
    LD ($A033),A                                  ; $CE70 32 33 a0
    LD A,$FF                                      ; $CE73 3e ff
    LD ($A034),A                                  ; $CE75 32 34 a0
    LD ($A035),A                                  ; $CE78 32 35 a0
    CALL $C4D1                                    ; $CE7B cd d1 c4
    RET C                                         ; $CE7E d8
    JR Z,$CEB8                                    ; $CE7F 28 37
    JR $CE8F                                      ; $CE81 18 0c
    LD IY,($9FDB)                                 ; $CE83 fd 2a db 9f
    LD HL,($9FD9)                                 ; $CE87 2a d9 9f
    PUSH HL                                       ; $CE8A e5
    POP IX                                        ; $CE8B dd e1
    LD A,(HL)                                     ; $CE8D 7e
    RET                                           ; $CE8E c9
; Z80: Successo: ramo bit7 oppure sequenza; bit5 cancella bytecode eseguito.
    CALL $CE83                                    ; $CE8F cd 83 ce
    CALL $CF03                                    ; $CE92 cd 03 cf
    BIT 7,(IX+$00)                                ; $CE95 dd cb 00 7e
    JR Z,$CEA1                                    ; $CE99 28 06
    LD E,(HL)                                     ; $CE9B 5e
    INC HL                                        ; $CE9C 23
    LD D,(HL)                                     ; $CE9D 56
    EX DE,HL                                      ; $CE9E eb
    JR $CEA8                                      ; $CE9F 18 07
    BIT 4,(IX+$00)                                ; $CEA1 dd cb 00 66
    CALL NZ,$CF40                                 ; $CEA5 c4 40 cf
    BIT 5,(IX+$00)                                ; $CEA8 dd cb 00 6e
    CALL NZ,$CF43                                 ; $CEAC c4 43 cf
    LD (IY+$01),L                                 ; $CEAF fd 75 01
    LD (IY+$02),H                                 ; $CEB2 fd 74 02
    JP $CD91                                      ; $CEB5 c3 91 cd
; Z80: Fallimento: incrementaCC0B e segue ramo bit4; autoloop o10fallimenti -> costo1.
    LD HL,$CC0B                                   ; $CEB8 21 0b cc
    INC (HL)                                      ; $CEBB 34
    CALL $CE83                                    ; $CEBC cd 83 ce
    CALL $CEFE                                    ; $CEBF cd fe ce
    BIT 4,(IX+$00)                                ; $CEC2 dd cb 00 66
    JR Z,$CECC                                    ; $CEC6 28 04
    LD E,(HL)                                     ; $CEC8 5e
    INC HL                                        ; $CEC9 23
    LD D,(HL)                                     ; $CECA 56
    EX DE,HL                                      ; $CECB eb
    LD (IY+$01),L                                 ; $CECC fd 75 01
    LD (IY+$02),H                                 ; $CECF fd 74 02
    PUSH IX                                       ; $CED2 dd e5
    POP DE                                        ; $CED4 d1
    AND A                                         ; $CED5 a7
    SBC HL,DE                                     ; $CED6 ed 52
    JP Z,$CD8B                                    ; $CED8 ca 8b cd
    JP $CC82                                      ; $CEDB c3 82 cc
; Z80: F5..F9 eFD=arg1, FA=slot9FD6, FB=attore, FC=arg2; FE/FF invariati.
    CP $F5                                        ; $CEDE fe f5
    RET C                                         ; $CEE0 d8
    CP $FE                                        ; $CEE1 fe fe
    RET NC                                        ; $CEE3 d0
    CP $FA                                        ; $CEE4 fe fa
    JR NZ,$CEEC                                   ; $CEE6 20 04
    LD A,($9FD6)                                  ; $CEE8 3a d6 9f
    RET                                           ; $CEEB c9
    CP $FB                                        ; $CEEC fe fb
    JR NZ,$CEF4                                   ; $CEEE 20 04
    LD A,($A036)                                  ; $CEF0 3a 36 a0
    RET                                           ; $CEF3 c9
    CP $FC                                        ; $CEF4 fe fc
    LD A,($9FD8)                                  ; $CEF6 3a d8 9f
    RET Z                                         ; $CEF9 c8
    LD A,($9FD7)                                  ; $CEFA 3a d7 9f
    RET                                           ; $CEFD c9
    BIT 7,A                                       ; $CEFE cb 7f
    CALL NZ,$CF40                                 ; $CF00 c4 40 cf
    AND $0F                                       ; $CF03 e6 0f
    CP $0F                                        ; $CF05 fe 0f
    JR Z,$CF41                                    ; $CF07 28 38
    CP $08                                        ; $CF09 fe 08
    JR Z,$CF40                                    ; $CF0B 28 33
    CP $09                                        ; $CF0D fe 09
    JR Z,$CF40                                    ; $CF0F 28 2f
    CP $01                                        ; $CF11 fe 01
    JR Z,$CF40                                    ; $CF13 28 2b
    CP $02                                        ; $CF15 fe 02
    JR Z,$CF3E                                    ; $CF17 28 25
    CP $03                                        ; $CF19 fe 03
    JR Z,$CF3F                                    ; $CF1B 28 22
    CP $0D                                        ; $CF1D fe 0d
    JR Z,$CF40                                    ; $CF1F 28 1f
    CP $0E                                        ; $CF21 fe 0e
    JR Z,$CF3F                                    ; $CF23 28 1a
    CP $07                                        ; $CF25 fe 07
    JR Z,$CF3D                                    ; $CF27 28 14
    CP $0C                                        ; $CF29 fe 0c
    JR Z,$CF3D                                    ; $CF2B 28 10
    CP $0B                                        ; $CF2D fe 0b
    JR Z,$CF41                                    ; $CF2F 28 10
    CP $0A                                        ; $CF31 fe 0a
    JR Z,$CF41                                    ; $CF33 28 0c
    CP $05                                        ; $CF35 fe 05
    JR Z,$CF3E                                    ; $CF37 28 05
    CP $04                                        ; $CF39 fe 04
    JR NZ,$CF3F                                   ; $CF3B 20 02
    INC HL                                        ; $CF3D 23
    INC HL                                        ; $CF3E 23
    INC HL                                        ; $CF3F 23
    INC HL                                        ; $CF40 23
    INC HL                                        ; $CF41 23
    RET                                           ; $CF42 c9
    LD A,(IX+$00)                                 ; $CF43 dd 7e 00
    BIT 7,A                                       ; $CF46 cb 7f
    CALL NZ,$CF73                                 ; $CF48 c4 73 cf
    BIT 4,A                                       ; $CF4B cb 67
    CALL NZ,$CF73                                 ; $CF4D c4 73 cf
    AND $0F                                       ; $CF50 e6 0f
    CP $01                                        ; $CF52 fe 01
    JR Z,$CF73                                    ; $CF54 28 1d
    CP $02                                        ; $CF56 fe 02
    JR Z,$CF6B                                    ; $CF58 28 11
    CP $05                                        ; $CF5A fe 05
    JR Z,$CF6B                                    ; $CF5C 28 0d
    CP $07                                        ; $CF5E fe 07
    JR Z,$CF68                                    ; $CF60 28 06
    CP $06                                        ; $CF62 fe 06
    JR Z,$CF70                                    ; $CF64 28 0a
    CP $04                                        ; $CF66 fe 04
    CALL Z,$CF79                                  ; $CF68 cc 79 cf
    CALL Z,$CF73                                  ; $CF6B cc 73 cf
    CP $03                                        ; $CF6E fe 03
    CALL Z,$CF79                                  ; $CF70 cc 79 cf
    LD (IX+$00),$00                               ; $CF73 dd 36 00 00
    INC IX                                        ; $CF77 dd 23
    LD (IX+$00),$00                               ; $CF79 dd 36 00 00
    INC IX                                        ; $CF7D dd 23
    RET                                           ; $CF7F c9
; Z80: Salva contesto sospeso nella lista9FE9.
    PUSH IX                                       ; $CF80 dd e5
    LD A,$07                                      ; $CF82 3e 07
    CALL $A11C                                    ; $CF84 cd 1c a1
    LD A,($A036)                                  ; $CF87 3a 36 a0
    LD (IX+$00),A                                 ; $CF8A dd 77 00
    LD (IX+$01),L                                 ; $CF8D dd 75 01
    LD (IX+$02),H                                 ; $CF90 dd 74 02
    LD DE,($A034)                                 ; $CF93 ed 5b 34 a0
    LD (IX+$03),E                                 ; $CF97 dd 73 03
    LD (IX+$04),D                                 ; $CF9A dd 72 04
    LD (IX+$05),B                                 ; $CF9D dd 70 05
    LD A,($9FD6)                                  ; $CFA0 3a d6 9f
    LD (IX+$06),A                                 ; $CFA3 dd 77 06
    LD HL,($9FE9)                                 ; $CFA6 2a e9 9f
    LD ($9FE9),IX                                 ; $CFA9 dd 22 e9 9f
    LD (IX-$02),L                                 ; $CFAD dd 75 fe
    LD (IX-$01),H                                 ; $CFB0 dd 74 ff
    POP IX                                        ; $CFB3 dd e1
    RET                                           ; $CFB5 c9
    LD A,($A036)                                  ; $CFB6 3a 36 a0
    LD IX,$9FEB                                   ; $CFB9 dd 21 eb 9f
    PUSH AF                                       ; $CFBD f5
    CALL $A0F7                                    ; $CFBE cd f7 a0
    JR Z,$CFCC                                    ; $CFC1 28 09
    POP AF                                        ; $CFC3 f1
    CP (IX+$00)                                   ; $CFC4 dd be 00
    JR NZ,$CFBD                                   ; $CFC7 20 f4
    OR $01                                        ; $CFC9 f6 01
    RET                                           ; $CFCB c9
    POP AF                                        ; $CFCC f1
    XOR A                                         ; $CFCD af
    RET                                           ; $CFCE c9
; Z80: Ripristina contesto e libera record.
    CALL $CFB6                                    ; $CFCF cd b6 cf
    LD E,(IX+$01)                                 ; $CFD2 dd 5e 01
    LD D,(IX+$02)                                 ; $CFD5 dd 56 02
    LD ($9FD9),DE                                 ; $CFD8 ed 53 d9 9f
    LD (IY+$01),E                                 ; $CFDC fd 73 01
    LD (IY+$02),D                                 ; $CFDF fd 72 02
    PUSH IX                                       ; $CFE2 dd e5
    POP DE                                        ; $CFE4 d1
    PUSH IY                                       ; $CFE5 fd e5
    LD IY,$9FE9                                   ; $CFE7 fd 21 e9 9f
    CALL $A104                                    ; $CFEB cd 04 a1
    LD L,(IX-$02)                                 ; $CFEE dd 6e fe
    LD H,(IX-$01)                                 ; $CFF1 dd 66 ff
    LD (IY-$02),L                                 ; $CFF4 fd 75 fe
    LD (IY-$01),H                                 ; $CFF7 fd 74 ff
    LD A,(IX+$05)                                 ; $CFFA dd 7e 05
    PUSH AF                                       ; $CFFD f5
    CALL $A1C7                                    ; $CFFE cd c7 a1
    CALL $D008                                    ; $D001 cd 08 d0
    POP AF                                        ; $D004 f1
    POP IY                                        ; $D005 fd e1
    RET                                           ; $D007 c9
    LD L,(IY+$04)                                 ; $D008 fd 6e 04
    LD H,(IY+$05)                                 ; $D00B fd 66 05
    CALL $CFB6                                    ; $D00E cd b6 cf
    LD A,(IY+$03)                                 ; $D011 fd 7e 03
    JR Z,$D01F                                    ; $D014 28 09
    LD L,(IX+$03)                                 ; $D016 dd 6e 03
    LD H,(IX+$04)                                 ; $D019 dd 66 04
    LD A,(IX+$06)                                 ; $D01C dd 7e 06
    LD ($9FD6),A                                  ; $D01F 32 d6 9f
    LD ($9FD7),HL                                 ; $D022 22 d7 9f
    RET                                           ; $D025 c9
    LD HL,($9FD7)                                 ; $D026 2a d7 9f
    CALL $CFB6                                    ; $D029 cd b6 cf
    LD A,($9FD6)                                  ; $D02C 3a d6 9f
    JR Z,$D03B                                    ; $D02F 28 0a
    LD (IX+$03),L                                 ; $D031 dd 75 03
    LD (IX+$04),H                                 ; $D034 dd 74 04
    LD (IX+$06),A                                 ; $D037 dd 77 06
    RET                                           ; $D03A c9
    LD (IY+$03),A                                 ; $D03B fd 77 03
    LD (IY+$04),L                                 ; $D03E fd 75 04
    LD (IY+$05),H                                 ; $D041 fd 74 05
    RET                                           ; $D044 c9

    ORG $D29D
    LD A,$63                                      ; $D29D 3e 63
    CALL $D2A4                                    ; $D29F cd a4 d2
    INC A                                         ; $D2A2 3c
    RET                                           ; $D2A3 c9
    CALL $D2AD                                    ; $D2A4 cd ad d2
    BIT 7,A                                       ; $D2A7 cb 7f
    RET Z                                         ; $D2A9 c8
    NEG                                           ; $D2AA ed 44
    RET                                           ; $D2AC c9
    PUSH IX                                       ; $D2AD dd e5
    PUSH BC                                       ; $D2AF c5
    LD C,A                                        ; $D2B0 4f
    SLA A                                         ; $D2B1 cb 27
    JR NC,$D2B7                                   ; $D2B3 30 02
    LD A,$FF                                      ; $D2B5 3e ff
    LD B,A                                        ; $D2B7 47
    LD IX,$A039                                   ; $D2B8 dd 21 39 a0
    INC (IX+$01)                                  ; $D2BC dd 34 01
    JR NZ,$D2C4                                   ; $D2BF 20 03
    INC (IX+$00)                                  ; $D2C1 dd 34 00
    LD IX,($A039)                                 ; $D2C4 dd 2a 39 a0
    LD A,($A037)                                  ; $D2C8 3a 37 a0
    ADC A,(IX+$00)                                ; $D2CB dd 8e 00
    ADD IX,DE                                     ; $D2CE dd 19
    XOR (IX+$01)                                  ; $D2D0 dd ae 01
    PUSH HL                                       ; $D2D3 e5
    LD HL,$A037                                   ; $D2D4 21 37 a0
    CP (HL)                                       ; $D2D7 be
    POP HL                                        ; $D2D8 e1
    JR Z,$D2B8                                    ; $D2D9 28 dd
    LD ($A037),A                                  ; $D2DB 32 37 a0
    CP B                                          ; $D2DE b8
    JR C,$D2E8                                    ; $D2DF 38 07
    JR Z,$D2E8                                    ; $D2E1 28 05
    SRL A                                         ; $D2E3 cb 3f
    JP $D2DE                                      ; $D2E5 c3 de d2
    SUB C                                         ; $D2E8 91
    POP BC                                        ; $D2E9 c1
    POP IX                                        ; $D2EA dd e1
    RET                                           ; $D2EC c9

    ORG $DD52
; HEADER: raggiungi una locazione attraverso un’uscita diretta; corpo script differito $DD54; costo0
    DEFB $A4,$00                                  ; $DD52 a4 00
; BYTECODE: regola con argomenti; regola $DD61
    DEFB $17,$61,$DD,$FD,$FF,$60,$DD              ; $DD54 17 61 dd fd ff 60 dd
; BYTECODE: azione senza argomenti
    DEFB $11,$FD,$60,$DD                          ; $DD5B 11 fd 60 dd
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $DD5F 0b
; BYTECODE: ritorna con fallimento
    DEFB $0A                                      ; $DD60 0a
; HEADER: trova direzione dell’uscita verso la locazione; corpo codice Z80 $DD65; costo0
    DEFB $64,$00,$6E,$DD                          ; $DD61 64 00 6e dd
    LD A,(IX+$00)                                 ; $DD65 dd 7e 00
    LD ($9FD7),A                                  ; $DD68 32 d7 9f
    OR $01                                        ; $DD6B f6 01
    RET                                           ; $DD6D c9
    LD A,($A034)                                  ; $DD6E 3a 34 a0
    CALL $D471                                    ; $DD71 cd 71 d4
    CP $FF                                        ; $DD74 fe ff
    JP Z,$DC15                                    ; $DD76 ca 15 dc
    LD A,(IX+$00)                                 ; $DD79 dd 7e 00
    CP $0B                                        ; $DD7C fe 0b
    JP NC,$DC15                                   ; $DD7E d2 15 dc
    OR $01                                        ; $DD81 f6 01
    RET                                           ; $DD83 c9
; HEADER: salva il genitore del primo argomento in 9FD6; corpo codice Z80 $DD88; costo0
    DEFB $6D,$00,$91,$DD                          ; $DD84 6d 00 91 dd
    LD A,(IX+$01)                                 ; $DD88 dd 7e 01
    LD ($9FD6),A                                  ; $DD8B 32 d6 9f
    OR $01                                        ; $DD8E f6 01
    RET                                           ; $DD90 c9
    LD IX,($A013)                                 ; $DD91 dd 2a 13 a0
    LD A,(IX+$01)                                 ; $DD95 dd 7e 01
    AND A                                         ; $DD98 a7
    INC A                                         ; $DD99 3c
    JP Z,$DC15                                    ; $DD9A ca 15 dc
    RET                                           ; $DD9D c9

    ORG $DDBE
; HEADER: regola da approfondire; corpo codice Z80 $DDC2; costo0
    DEFB $40,$00,$B8,$DD                          ; $DDBE 40 00 b8 dd

    ORG $DFCA
; HEADER: scena terminale: fine partita; corpo codice Z80 $DFCC; costo0
    DEFB $00,$00                                  ; $DFCA 00 00

    ORG $E370
; HEADER: regola da approfondire; corpo codice Z80 $E374; costo1
    DEFB $66,$1D,$45,$E3                          ; $E370 66 1d 45 e3

    ORG $E488
; HEADER: salva la locazione del primo argomento in 9FD6; corpo codice Z80 $E48A; costo0
    DEFB $27,$00                                  ; $E488 27 00
    LD IX,($A013)                                 ; $E48A dd 2a 13 a0
    LD A,(IX+$0F)                                 ; $E48E dd 7e 0f
    LD ($9FD6),A                                  ; $E491 32 d6 9f
    OR $01                                        ; $E494 f6 01
    RET                                           ; $E496 c9
; HEADER: sposta entità alla locazione indicata, staccandola dal genitore; corpo codice Z80 $E49B; costo2
    DEFB $47,$24,$B0,$E4                          ; $E497 47 24 b0 e4
    LD A,($A035)                                  ; $E49B 3a 35 a0
    LD B,A                                        ; $E49E 47
    LD A,($A034)                                  ; $E49F 3a 34 a0
    LD IX,($A013)                                 ; $E4A2 dd 2a 13 a0
    LD (IX+$01),$FF                               ; $E4A6 dd 36 01 ff
    CALL $DD0E                                    ; $E4AA cd 0e dd
    OR $01                                        ; $E4AD f6 01
    RET                                           ; $E4AF c9
    LD IX,($A013)                                 ; $E4B0 dd 2a 13 a0
    BIT 6,(IX+$05)                                ; $E4B4 dd cb 05 76
    JR Z,$E4C6                                    ; $E4B8 28 0c
    LD A,(IX+$0F)                                 ; $E4BA dd 7e 0f
    CALL $D224                                    ; $E4BD cd 24 d2
    LD A,(IX+$09)                                 ; $E4C0 dd 7e 09
    LD ($A033),A                                  ; $E4C3 32 33 a0
    OR $01                                        ; $E4C6 f6 01
    RET                                           ; $E4C8 c9

    ORG $E506
; HEADER: regola da approfondire; corpo script differito $E508; costo0
    DEFB $AD,$0D                                  ; $E506 ad 0d
; BYTECODE: regola con argomenti; regola $E518
    DEFB $C7,$18,$E5,$FD,$FC,$10,$E5              ; $E508 c7 18 e5 fd fc 10 e5
; BYTECODE: ritorna con fallimento
    DEFB $0A                                      ; $E50F 0a
; BYTECODE: regola con argomenti; regola $E370
    DEFB $57,$70,$E3,$FD,$FC,$0F,$E5              ; $E510 57 70 e3 fd fc 0f e5
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $E517 0b
; HEADER: regola da approfondire; corpo codice Z80 $E51C; costo0
    DEFB $6D,$0D,$FC,$E4                          ; $E518 6d 0d fc e4

    ORG $E52F
; HEADER: crea contatore privato base + casuale(ampiezza); corpo codice Z80 $E531; costo0
    DEFB $07,$07                                  ; $E52F 07 07
; Z80: Contatore privato: base + D2A4(ampiezza); non una scadenza assoluta.
    LD A,$02                                      ; $E531 3e 02
    CALL $A11C                                    ; $E533 cd 1c a1
    LD HL,($9FE5)                                 ; $E536 2a e5 9f
    LD ($9FE5),IX                                 ; $E539 dd 22 e5 9f
    LD (IX-$02),L                                 ; $E53D dd 75 fe
    LD (IX-$01),H                                 ; $E540 dd 74 ff
    LD A,($A036)                                  ; $E543 3a 36 a0
    LD (IX+$00),A                                 ; $E546 dd 77 00
    LD A,($A035)                                  ; $E549 3a 35 a0
    LD B,$00                                      ; $E54C 06 00
    CP $FF                                        ; $E54E fe ff
    JR Z,$E556                                    ; $E550 28 04
    CALL $D2A4                                    ; $E552 cd a4 d2
    LD B,A                                        ; $E555 47
    LD A,($A034)                                  ; $E556 3a 34 a0
    ADD A,B                                       ; $E559 80
    LD (IX+$01),A                                 ; $E55A dd 77 01
    OR $01                                        ; $E55D f6 01
    RET                                           ; $E55F c9
    LD IX,$9FE7                                   ; $E560 dd 21 e7 9f
    CALL $A0F7                                    ; $E564 cd f7 a0
    RET Z                                         ; $E567 c8
    LD A,($A036)                                  ; $E568 3a 36 a0
    CP (IX+$00)                                   ; $E56B dd be 00
    JR NZ,$E564                                   ; $E56E 20 f4
    OR $01                                        ; $E570 f6 01
    RET                                           ; $E572 c9
    CALL $E560                                    ; $E573 cd 60 e5
    JP Z,$DC15                                    ; $E576 ca 15 dc
    RET                                           ; $E579 c9
; HEADER: decrementa contatore; fallisce quando raggiunge zero; corpo codice Z80 $E57E; costo0
    DEFB $40,$00,$73,$E5                          ; $E57A 40 00 73 e5
; Z80: Decrementa contatore; zero lo elimina e restituisce fallimento.
    DEC (IX+$01)                                  ; $E57E dd 35 01
    RET NZ                                        ; $E581 c0
    CALL $E58C                                    ; $E582 cd 8c e5
    JP $DC15                                      ; $E585 c3 15 dc
; HEADER: elimina contatore privato; corpo codice Z80 $E58C; costo0
    DEFB $40,$00,$73,$E5                          ; $E588 40 00 73 e5
    PUSH IX                                       ; $E58C dd e5
    POP DE                                        ; $E58E d1
    LD IY,$9FE5                                   ; $E58F fd 21 e5 9f
    CALL $A104                                    ; $E593 cd 04 a1
    LD L,(IX-$02)                                 ; $E596 dd 6e fe
    LD H,(IX-$01)                                 ; $E599 dd 66 ff
    LD (IY-$02),L                                 ; $E59C fd 75 fe
    LD (IY-$01),H                                 ; $E59F fd 74 ff
    CALL $A1C7                                    ; $E5A2 cd c7 a1
    OR $01                                        ; $E5A5 f6 01
    RET                                           ; $E5A7 c9
; HEADER: attesa di costo 1; corpo codice Z80 $E5AA; costo1
    DEFB $00,$10                                  ; $E5A8 00 10
    OR $01                                        ; $E5AA f6 01
    RET                                           ; $E5AC c9
; HEADER: verifica prima locazione dell’entità; corpo codice Z80 $E5B1; costo0
    DEFB $4C,$04,$B1,$E5                          ; $E5AD 4c 04 b1 e5
    LD IX,($A013)                                 ; $E5B1 dd 2a 13 a0
    LD A,($A035)                                  ; $E5B5 3a 35 a0
    CP (IX+$0F)                                   ; $E5B8 dd be 0f
    JP NZ,$DC15                                   ; $E5BB c2 15 dc
    OR $01                                        ; $E5BE f6 01
    RET                                           ; $E5C0 c9
; HEADER: confronta locazione attore con giocatore attivo; corpo codice Z80 $E5C3; costo0
    DEFB $00,$00                                  ; $E5C1 00 00
    LD A,($9860)                                  ; $E5C3 3a 60 98
    CALL $D237                                    ; $E5C6 cd 37 d2
    LD A,(IX+$0F)                                 ; $E5C9 dd 7e 0f
    LD IX,($A017)                                 ; $E5CC dd 2a 17 a0
    CP (IX+$0F)                                   ; $E5D0 dd be 0f
    LD A,($A036)                                  ; $E5D3 3a 36 a0
    JR $E5F0                                      ; $E5D6 18 18
; HEADER: confronta prima locazione di due entità distinte; corpo codice Z80 $E5DC; costo0
    DEFB $47,$07,$DF,$E5                          ; $E5D8 47 07 df e5
    OR $01                                        ; $E5DC f6 01
    RET                                           ; $E5DE c9
    LD IX,($A013)                                 ; $E5DF dd 2a 13 a0
    LD A,(IX+$0F)                                 ; $E5E3 dd 7e 0f
    LD IX,($A015)                                 ; $E5E6 dd 2a 15 a0
    CP (IX+$0F)                                   ; $E5EA dd be 0f
    LD A,($A035)                                  ; $E5ED 3a 35 a0
    JP NZ,$DC15                                   ; $E5F0 c2 15 dc
    LD HL,$A034                                   ; $E5F3 21 34 a0
    CP (HL)                                       ; $E5F6 be
    JP Z,$DC15                                    ; $E5F7 ca 15 dc
    OR $01                                        ; $E5FA f6 01
    RET                                           ; $E5FC c9
; HEADER: confronta le radici del contenimento; corpo codice Z80 $E601; costo0
    DEFB $47,$00,$04,$E6                          ; $E5FD 47 00 04 e6
    OR $01                                        ; $E601 f6 01
    RET                                           ; $E603 c9
    LD A,($A036)                                  ; $E604 3a 36 a0
    CALL $C863                                    ; $E607 cd 63 c8
    EX AF,AF'                                     ; $E60A 08
    LD B,A                                        ; $E60B 47
    LD A,($A034)                                  ; $E60C 3a 34 a0
    CALL $C863                                    ; $E60F cd 63 c8
    EX AF,AF'                                     ; $E612 08
    CP B                                          ; $E613 b8
    LD A,($A036)                                  ; $E614 3a 36 a0
    JR $E5F0                                      ; $E617 18 d7

    ORG $E72F
; BYTECODE: stampa testo
    DEFB $06,$EB,$6D                              ; $E72F 06 eb 6d
; BYTECODE: regola con argomenti; regola $E52F
    DEFB $07,$2F,$E5,$0D,$04                      ; $E732 07 2f e5 0d 04
; BYTECODE: regola senza argomenti; regola $E79A
    DEFB $13,$9A,$E7,$B6,$E7                      ; $E737 13 9a e7 b6 e7
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $12,$81,$00,$FB,$51,$E7                  ; $E73C 12 81 00 fb 51 e7
; BYTECODE: stampa testo
    DEFB $06,$02,$6E                              ; $E742 06 02 6e
; BYTECODE: regola con argomenti; regola $E52F
    DEFB $07,$2F,$E5,$0F,$0A                      ; $E745 07 2f e5 0f 0a
; BYTECODE: regola senza argomenti; regola $E79A
    DEFB $93,$9A,$E7,$7B,$E7,$B6,$E7              ; $E74A 93 9a e7 7b e7 b6 e7
; BYTECODE: regola con argomenti; regola $E52F
    DEFB $07,$2F,$E5,$0F,$0A                      ; $E751 07 2f e5 0f 0a
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $E756 03 a8 e5
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$FB,$08,$B6,$E7                  ; $E759 12 83 fb 08 b6 e7
; BYTECODE: regola con argomenti; regola $E7E2
    DEFB $17,$E2,$E7,$19,$FF,$B6,$E7              ; $E75F 17 e2 e7 19 ff b6 e7
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$00,$FB,$73,$E7                  ; $E766 82 81 00 fb 73 e7
; BYTECODE: regola senza argomenti; regola $E57A
    DEFB $93,$7A,$E5,$56,$E7,$7B,$E7              ; $E76C 93 7a e5 56 e7 7b e7
; BYTECODE: stampa testo
    DEFB $06,$FC,$6E                              ; $E773 06 fc 6e
; BYTECODE: regola senza argomenti; regola $E79A
    DEFB $13,$9A,$E7,$B6,$E7                      ; $E776 13 9a e7 b6 e7
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$FB,$08,$B6,$E7                  ; $E77B 12 83 fb 08 b6 e7
; BYTECODE: regola senza argomenti; regola $E5C1
    DEFB $13,$C1,$E5,$8C,$E7                      ; $E781 13 c1 e5 8c e7
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $E786 03 a8 e5
; BYTECODE: salto assoluto
    DEFB $0E,$7B,$E7                              ; $E789 0e 7b e7
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$1A,$08                          ; $E78C 02 80 1a 08
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$00                          ; $E790 02 80 fb 00
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $E794 03 a8 e5
; BYTECODE: salto assoluto
    DEFB $0E,$94,$E7                              ; $E797 0e 94 e7
; HEADER: attesa interrompibile di Watson nella stanza iniziale; corpo script differito $E79C; costo0
    DEFB $80,$00                                  ; $E79A 80 00
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $E79C 03 a8 e5
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$FB,$08,$B2,$E7                  ; $E79F 12 83 fb 08 b2 e7
; BYTECODE: regola con argomenti; regola $E7E2
    DEFB $17,$E2,$E7,$19,$FF,$B2,$E7              ; $E7A5 17 e2 e7 19 ff b2 e7
; BYTECODE: regola senza argomenti; regola $E57A
    DEFB $83,$7A,$E5,$9C,$E7                      ; $E7AC 83 7a e5 9c e7
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $E7B1 0b
; BYTECODE: regola senza argomenti; regola $E588
    DEFB $03,$88,$E5                              ; $E7B2 03 88 e5
; BYTECODE: ritorna con fallimento
    DEFB $0A                                      ; $E7B5 0a
; BYTECODE: regola senza argomenti; regola $E588
    DEFB $03,$88,$E5                              ; $E7B6 03 88 e5
; BYTECODE: regola con argomenti; regola $E488
    DEFB $07,$88,$E4,$00,$FF                      ; $E7B9 07 88 e4 00 ff
; BYTECODE: regola con argomenti; regola $DD52
    DEFB $87,$52,$DD,$FA,$FF,$B9,$E7              ; $E7BE 87 52 dd fa ff b9 e7
; BYTECODE: azione con argomenti; regola $E5FD
    DEFB $82,$82,$00,$FF,$B9,$E7                  ; $E7C5 82 82 00 ff b9 e7
; BYTECODE: azione senza argomenti
    DEFB $81,$0D,$B9,$E7                          ; $E7CB 81 0d b9 e7
; BYTECODE: regola con argomenti; regola $DD84
    DEFB $17,$84,$DD,$00,$FF,$B9,$E7              ; $E7CF 17 84 dd 00 ff b9 e7
; BYTECODE: azione con argomenti
    DEFB $82,$0C,$FA,$FF,$B9,$E7                  ; $E7D6 82 0c fa ff b9 e7
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $E7DC 03 a8 e5
; BYTECODE: salto assoluto
    DEFB $0E,$B9,$E7                              ; $E7DF 0e b9 e7
; HEADER: verifica possesso percepibile (classe A); corpo codice Z80 $E7E4; costo0
    DEFB $0A,$00                                  ; $E7E2 0a 00
    OR $01                                        ; $E7E4 f6 01
    RET                                           ; $E7E6 c9
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E7E7 41 04
; BYTECODE: regola senza argomenti; regola $EB72
    DEFB $43,$72,$EB                              ; $E7E9 43 72 eb
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$18,$69                          ; $E7EC 45 04 18 69
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E7F0 48 04
; BYTECODE: consuma segnale del mittente
    DEFB $59,$04,$F2,$E7                          ; $E7F2 59 04 f2 e7
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$63,$71                          ; $E7F6 45 04 63 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E7FA 48 04
; BYTECODE: consuma segnale del mittente
    DEFB $59,$04,$FC,$E7                          ; $E7FC 59 04 fc e7
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$75,$71                          ; $E800 45 04 75 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E804 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$58                          ; $E806 42 86 04 58
; BYTECODE: azione con argomenti
    DEFB $42,$13,$2E,$FF                          ; $E80A 42 13 2e ff
; BYTECODE: azione con argomenti
    DEFB $42,$13,$2F,$FF                          ; $E80E 42 13 2f ff
; BYTECODE: azione con argomenti
    DEFB $42,$13,$39,$FF                          ; $E812 42 13 39 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E816 41 04
; BYTECODE: azione con argomenti
    DEFB $42,$13,$39,$FF                          ; $E818 42 13 39 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $E81C 41 03
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$50,$71                          ; $E81E 45 04 50 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E822 48 04
; BYTECODE: consuma segnale del mittente
    DEFB $59,$04,$24,$E8                          ; $E824 59 04 24 e8
; BYTECODE: azione con argomenti; regola $EB9B
    DEFB $42,$89,$07,$3B                          ; $E828 42 89 07 3b
; BYTECODE: azione con argomenti; regola $EB9B
    DEFB $42,$89,$03,$3A                          ; $E82C 42 89 03 3a
; BYTECODE: azione con argomenti; regola $EB9B
    DEFB $42,$89,$01,$3A                          ; $E830 42 89 01 3a
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $E834 41 05
; BYTECODE: azione con argomenti; regola $EB9B
    DEFB $42,$89,$01,$4B                          ; $E836 42 89 01 4b
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E83A 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E83C 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$06                                  ; $E83E 41 06
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E840 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E842 41 04
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $E844 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $E846 41 02
; BYTECODE: azione con argomenti; regola $EB9B
    DEFB $42,$89,$07,$3B                          ; $E848 42 89 07 3b
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $E84C 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $E84E 41 03
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$89,$71                          ; $E850 45 04 89 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E854 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$43                          ; $E856 42 86 04 43
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E85A 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$05,$30,$FB,$10                      ; $E85B 44 05 30 fb 10
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E860 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$06,$2F,$FB,$11                      ; $E861 44 06 2f fb 11
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E866 0f
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E867 0f
; BYTECODE: stampa testo
    DEFB $46,$26,$71                              ; $E868 46 26 71
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$A4,$71                          ; $E86B 45 04 a4 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E86F 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$41                          ; $E871 42 86 04 41
; BYTECODE: accoda ordine a un attore
    DEFB $44,$08,$30,$FB,$10                      ; $E875 44 08 30 fb 10
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E87A 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$0A,$30,$FB,$10                      ; $E87B 44 0a 30 fb 10
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E880 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$09,$2F,$FB,$10                      ; $E881 44 09 2f fb 10
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E886 0f
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E887 0f
; BYTECODE: stampa testo
    DEFB $46,$26,$71                              ; $E888 46 26 71
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$B7,$71                          ; $E88B 45 04 b7 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E88F 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$5E                          ; $E891 42 86 04 5e
; BYTECODE: azione con argomenti
    DEFB $42,$13,$48,$FF                          ; $E895 42 13 48 ff
; BYTECODE: azione con argomenti
    DEFB $42,$13,$47,$FF                          ; $E899 42 13 47 ff
; BYTECODE: azione con argomenti
    DEFB $42,$13,$42,$FF                          ; $E89D 42 13 42 ff
; BYTECODE: azione con argomenti
    DEFB $52,$1C,$42,$FF,$AB,$E8                  ; $E8A1 52 1c 42 ff ab e8
; BYTECODE: azione con argomenti
    DEFB $42,$13,$43,$FF                          ; $E8A7 42 13 43 ff
; BYTECODE: azione con argomenti
    DEFB $42,$1C,$42,$FF                          ; $E8AB 42 1c 42 ff
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E8AF 48 04
; BYTECODE: regola senza argomenti; regola $EB47
    DEFB $43,$47,$EB                              ; $E8B1 43 47 eb
; BYTECODE: invia segnale
    DEFB $48,$07                                  ; $E8B4 48 07
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8B6 0f
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E8B7 41 01
; BYTECODE: parla a un destinatario
    DEFB $45,$0B,$12,$71                          ; $E8B9 45 0b 12 71
; BYTECODE: invia segnale
    DEFB $48,$0B                                  ; $E8BD 48 0b
; BYTECODE: invia segnale
    DEFB $48,$07                                  ; $E8BF 48 07
; BYTECODE: consuma segnale del mittente
    DEFB $59,$07,$C1,$E8                          ; $E8C1 59 07 c1 e8
; BYTECODE: parla a un destinatario
    DEFB $45,$07,$1D,$71                          ; $E8C5 45 07 1d 71
; BYTECODE: regola senza argomenti; regola $ED17
    DEFB $43,$17,$ED                              ; $E8C9 43 17 ed
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8CC 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$04,$30,$07,$0F                      ; $E8CD 44 04 30 07 0f
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8D2 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$07,$30,$FB,$11                      ; $E8D3 44 07 30 fb 11
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8D8 0f
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8D9 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$07,$2F,$FB,$12                      ; $E8DA 44 07 2f fb 12
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8DF 0f
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E8E0 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$07,$15,$FB,$FF                      ; $E8E1 44 07 15 fb ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$44,$FF                          ; $E8E6 42 87 44 ff
; BYTECODE: stampa testo
    DEFB $46,$26,$71                              ; $E8EA 46 26 71
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$45,$FF                          ; $E8ED 42 87 45 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$13,$FF                          ; $E8F1 42 87 13 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E8F5 41 01
; BYTECODE: parla a un destinatario
    DEFB $45,$0B,$39,$71                          ; $E8F7 45 0b 39 71
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$A4,$71                          ; $E8FB 45 04 a4 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E8FF 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$41                          ; $E901 42 86 04 41
; BYTECODE: accoda ordine a un attore
    DEFB $44,$09,$30,$FB,$07                      ; $E905 44 09 30 fb 07
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E90A 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$08,$30,$FB,$07                      ; $E90B 44 08 30 fb 07
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E910 0f
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$89,$71                          ; $E911 45 04 89 71
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E915 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$43                          ; $E917 42 86 04 43
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E91B 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$05,$30,$FB,$07                      ; $E91C 44 05 30 fb 07
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E921 0f
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$08,$70                          ; $E922 45 04 08 70
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E926 48 04
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $42,$86,$04,$5C                          ; $E928 42 86 04 5c
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$34,$70                          ; $E92C 45 04 34 70
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E930 48 04
; BYTECODE: regola senza argomenti; regola $9E6A
    DEFB $03,$6A,$9E                              ; $E932 03 6a 9e
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E935 41 04
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E937 41 01
; BYTECODE: regola senza argomenti; regola $EB28
    DEFB $43,$28,$EB                              ; $E939 43 28 eb
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $E93C 0f
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $C2,$81,$FB,$00,$49,$E9                  ; $E93D c2 81 fb 00 49 e9
; BYTECODE: consuma segnale del mittente
    DEFB $D9,$07,$51,$E9,$3C,$E9                  ; $E943 d9 07 51 e9 3c e9
; BYTECODE: parla a un destinatario
    DEFB $45,$00,$20,$70                          ; $E949 45 00 20 70
; BYTECODE: consuma segnale del mittente
    DEFB $59,$07,$4D,$E9                          ; $E94D 59 07 4d e9
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$00                          ; $E951 42 80 fb 00
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$00,$07,$61,$E9                  ; $E955 82 81 00 07 61 e9
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$01,$FF,$55,$E9                  ; $E95B 12 88 01 ff 55 e9
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$0C                          ; $E961 02 80 fb 0c
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $52,$81,$FB,$07,$65,$E9                  ; $E965 52 81 fb 07 65 e9
; BYTECODE: regola senza argomenti; regola $9E85
    DEFB $03,$85,$9E                              ; $E96B 03 85 9e
; BYTECODE: parla a un destinatario
    DEFB $45,$07,$75,$70                          ; $E96E 45 07 75 70
; BYTECODE: invia segnale
    DEFB $48,$07                                  ; $E972 48 07
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $47,$A4,$EB,$FF,$0A                      ; $E974 47 a4 eb ff 0a
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$0B                          ; $E979 42 80 fb 0b
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$00                          ; $E97D 42 80 fb 00
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$07,$FF,$81,$E9                  ; $E981 52 88 07 ff 81 e9
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$0B                          ; $E987 42 80 fb 0b
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E98B 41 04
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $E98D 48 04
; BYTECODE: regola senza argomenti; regola $EB72
    DEFB $43,$72,$EB                              ; $E98F 43 72 eb
; BYTECODE: accoda ordine a un attore
    DEFB $44,$04,$20,$FF,$FF                      ; $E992 44 04 20 ff ff
; BYTECODE: regola senza argomenti; regola $ECF6
    DEFB $43,$F6,$EC                              ; $E997 43 f6 ec
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $C2,$88,$0A,$FF,$DB,$E9                  ; $E99A c2 88 0a ff db e9
; BYTECODE: regola con argomenti; regola $E7E2
    DEFB $C7,$E2,$E7,$5D,$FF,$DB,$E9              ; $E9A0 c7 e2 e7 5d ff db e9
; BYTECODE: regola con argomenti; regola $F198
    DEFB $57,$98,$F1,$0A,$FF,$B5,$E9              ; $E9A7 57 98 f1 0a ff b5 e9
; BYTECODE: azione con argomenti
    DEFB $42,$13,$39,$FF                          ; $E9AE 42 13 39 ff
; BYTECODE: salto assoluto
    DEFB $0E,$9A,$E9                              ; $E9B2 0e 9a e9
; BYTECODE: regola con argomenti; regola $F198
    DEFB $57,$98,$F1,$0A,$FF,$C3,$E9              ; $E9B5 57 98 f1 0a ff c3 e9
; BYTECODE: azione con argomenti
    DEFB $42,$13,$3B,$FF                          ; $E9BC 42 13 3b ff
; BYTECODE: salto assoluto
    DEFB $0E,$9A,$E9                              ; $E9C0 0e 9a e9
; BYTECODE: regola con argomenti; regola $F198
    DEFB $57,$98,$F1,$0A,$FF,$CF,$E9              ; $E9C3 57 98 f1 0a ff cf e9
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $E9CA 41 04
; BYTECODE: salto assoluto
    DEFB $0E,$9A,$E9                              ; $E9CC 0e 9a e9
; BYTECODE: regola con argomenti; regola $F198
    DEFB $57,$98,$F1,$0A,$FF,$9A,$E9              ; $E9CF 57 98 f1 0a ff 9a e9
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $E9D6 41 03
; BYTECODE: salto assoluto
    DEFB $0E,$9A,$E9                              ; $E9D8 0e 9a e9
; BYTECODE: regola senza argomenti; regola $ED0C
    DEFB $43,$0C,$ED                              ; $E9DB 43 0c ed
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $E9DE 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $E9E0 41 03
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $E9E2 41 03
; BYTECODE: regola senza argomenti; regola $ED17
    DEFB $43,$17,$ED                              ; $E9E4 43 17 ed
; BYTECODE: azione con argomenti
    DEFB $42,$13,$42,$FF                          ; $E9E7 42 13 42 ff
; BYTECODE: azione con argomenti
    DEFB $42,$13,$47,$FF                          ; $E9EB 42 13 47 ff
; BYTECODE: azione con argomenti
    DEFB $52,$1C,$42,$FF,$F9,$E9                  ; $E9EF 52 1c 42 ff f9 e9
; BYTECODE: azione con argomenti
    DEFB $42,$13,$43,$FF                          ; $E9F5 42 13 43 ff
; BYTECODE: azione con argomenti
    DEFB $42,$1C,$42,$FF                          ; $E9F9 42 1c 42 ff
; BYTECODE: regola senza argomenti; regola $EB47
    DEFB $43,$47,$EB                              ; $E9FD 43 47 eb
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EA00 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $EA02 41 04
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EA04 41 01
; BYTECODE: parla a un destinatario
    DEFB $45,$04,$90,$6F                          ; $EA06 45 04 90 6f
; BYTECODE: regola senza argomenti; regola $EB28
    DEFB $43,$28,$EB                              ; $EA0A 43 28 eb
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$5D,$00                          ; $EA0D 42 80 5d 00
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$15,$FF,$11,$EA                  ; $EA11 52 88 15 ff 11 ea
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$00                          ; $EA17 42 80 fb 00
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$07,$FF,$1B,$EA                  ; $EA1B 52 88 07 ff 1b ea
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$0B                          ; $EA21 42 80 fb 0b
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EA25 0f
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $C2,$88,$15,$FF,$A9,$EA                  ; $EA26 c2 88 15 ff a9 ea
; BYTECODE: regola senza argomenti; regola $EB19
    DEFB $53,$19,$EB,$25,$EA                      ; $EA2C 53 19 eb 25 ea
; BYTECODE: regola senza argomenti; regola $EB11
    DEFB $C3,$11,$EB,$5B,$EA                      ; $EA31 c3 11 eb 5b ea
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $C2,$88,$15,$FF,$A9,$EA                  ; $EA36 c2 88 15 ff a9 ea
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EA3C 0f
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $C2,$81,$FB,$00,$31,$EA                  ; $EA3D c2 81 fb 00 31 ea
; BYTECODE: regola senza argomenti; regola $EB11
    DEFB $C3,$11,$EB,$5B,$EA                      ; $EA43 c3 11 eb 5b ea
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $C2,$88,$15,$FF,$A9,$EA                  ; $EA48 c2 88 15 ff a9 ea
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EA4E 0f
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $52,$81,$FB,$00,$43,$EA                  ; $EA4F 52 81 fb 00 43 ea
; BYTECODE: parla a un destinatario
    DEFB $C5,$00,$C0,$70,$31,$EA                  ; $EA55 c5 00 c0 70 31 ea
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $EA5B 41 04
; BYTECODE: invia segnale
    DEFB $48,$04                                  ; $EA5D 48 04
; BYTECODE: regola con argomenti; regola $EAF6
    DEFB $47,$F6,$EA,$6D,$0B                      ; $EA5F 47 f6 ea 6d 0b
; BYTECODE: regola senza argomenti; regola $EB72
    DEFB $43,$72,$EB                              ; $EA64 43 72 eb
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $EA67 41 02
; BYTECODE: azione con argomenti
    DEFB $42,$0C,$6D,$FF                          ; $EA69 42 0c 6d ff
; BYTECODE: accoda ordine a un attore
    DEFB $44,$0B,$1E,$67,$FF                      ; $EA6D 44 0b 1e 67 ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $52,$83,$FB,$67,$72,$EA                  ; $EA72 52 83 fb 67 72 ea
; BYTECODE: azione con argomenti; regola $E5FD
    DEFB $52,$82,$00,$FF,$84,$EA                  ; $EA78 52 82 00 ff 84 ea
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $C2,$83,$06,$67,$B6,$EA                  ; $EA7E c2 83 06 67 b6 ea
; BYTECODE: accoda ordine a un attore
    DEFB $44,$0B,$1D,$32,$FF                      ; $EA84 44 0b 1d 32 ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $52,$83,$FB,$32,$89,$EA                  ; $EA89 52 83 fb 32 89 ea
; BYTECODE: azione con argomenti
    DEFB $42,$0D,$6D,$FF                          ; $EA8F 42 0d 6d ff
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EA93 41 01
; BYTECODE: regola senza argomenti; regola $EB28
    DEFB $43,$28,$EB                              ; $EA95 43 28 eb
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EA98 0f
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$FB,$00,$A5,$EA                  ; $EA99 82 81 fb 00 a5 ea
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$16,$FF,$98,$EA                  ; $EA9F 52 88 16 ff 98 ea
; BYTECODE: parla a un destinatario
    DEFB $45,$00,$C7,$70                          ; $EAA5 45 00 c7 70
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$00                          ; $EAA9 42 80 fb 00
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$0A,$FF,$AD,$EA                  ; $EAAD 52 88 0a ff ad ea
; BYTECODE: regola senza argomenti; regola $9EA2
    DEFB $03,$A2,$9E                              ; $EAB3 03 a2 9e
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EAB6 0f
; BYTECODE: accoda ordine a un attore
    DEFB $44,$0B,$1E,$32,$FF                      ; $EAB7 44 0b 1e 32 ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $52,$83,$FB,$32,$BC,$EA                  ; $EABC 52 83 fb 32 bc ea
; BYTECODE: azione con argomenti
    DEFB $42,$0D,$6D,$FF                          ; $EAC2 42 0d 6d ff
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EAC6 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EAC8 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EACA 41 01
; BYTECODE: parla a un destinatario
    DEFB $45,$00,$C7,$70                          ; $EACC 45 00 c7 70
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$FB,$2A,$95,$EA                  ; $EAD0 82 81 fb 2a 95 ea
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$FB,$2B,$95,$EA                  ; $EAD6 82 81 fb 2b 95 ea
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$FB,$37,$D0,$EA                  ; $EADC 82 83 fb 37 d0 ea
; BYTECODE: azione con argomenti; regola $EB8B
    DEFB $02,$86,$00,$1E                          ; $EAE2 02 86 00 1e
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $EAE6 41 04
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $EAE8 41 04
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $07,$A4,$EB,$FF,$0A                      ; $EAEA 07 a4 eb ff 0a
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$0B                          ; $EAEF 42 80 fb 0b
; BYTECODE: salto assoluto
    DEFB $0E,$98,$EA                              ; $EAF3 0e 98 ea
; HEADER: regola da approfondire; corpo codice Z80 $EAF8; costo0
    DEFB $07,$07                                  ; $EAF6 07 07

    ORG $EB11
; HEADER: regola da approfondire; corpo codice Z80 $EB13; costo0
    DEFB $00,$00                                  ; $EB11 00 00

    ORG $EB19
; HEADER: regola da approfondire; corpo codice Z80 $EB1B; costo0
    DEFB $00,$00                                  ; $EB19 00 00

    ORG $EB28
; HEADER: regola da approfondire; corpo script differito $EB2A; costo0
    DEFB $80,$00                                  ; $EB28 80 00
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EB2A 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EB2C 41 01
; BYTECODE: regola con argomenti; regola $EBE1
    DEFB $47,$E1,$EB,$17,$FF                      ; $EB2E 47 e1 eb 17 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EB33 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EB35 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EB37 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EB39 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EB3B 41 08
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $47,$A4,$EB,$FF,$0A                      ; $EB3D 47 a4 eb ff 0a
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$0B                          ; $EB42 42 80 fb 0b
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EB46 0b
; HEADER: regola da approfondire; corpo script differito $EB49; costo0
    DEFB $80,$00                                  ; $EB47 80 00
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$44,$FF                          ; $EB49 42 87 44 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$45,$FF                          ; $EB4D 42 87 45 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$31,$FF                          ; $EB51 42 87 31 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$32,$FF                          ; $EB55 42 87 32 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$32,$FF                          ; $EB59 42 87 32 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$31,$FF                          ; $EB5D 42 87 31 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$09                                  ; $EB61 41 09
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$46,$FF                          ; $EB63 42 87 46 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$46,$FF                          ; $EB67 42 87 46 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$0A                                  ; $EB6B 41 0a
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$13,$FF                          ; $EB6D 42 87 13 ff
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EB71 0b
; HEADER: regola da approfondire; corpo script differito $EB74; costo0
    DEFB $80,$00                                  ; $EB72 80 00
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $47,$A4,$EB,$FF,$12                      ; $EB74 47 a4 eb ff 12
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $EB79 41 05
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $EB7B 41 05
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $EB7D 41 05
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $EB7F 41 05
; BYTECODE: regola con argomenti; regola $EBE1
    DEFB $47,$E1,$EB,$36,$FF                      ; $EB81 47 e1 eb 36 ff
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$35                          ; $EB86 42 80 fb 35
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EB8A 0b
; HEADER: regola da approfondire; corpo script differito $EB8D; costo0
    DEFB $8C,$04                                  ; $EB8B 8c 04
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $C2,$83,$FB,$FC,$9A,$EB                  ; $EB8D c2 83 fb fc 9a eb
; BYTECODE: azione con argomenti
    DEFB $42,$15,$FD,$FF                          ; $EB93 42 15 fd ff
; BYTECODE: salto assoluto
    DEFB $0E,$8D,$EB                              ; $EB97 0e 8d eb
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EB9A 0b
; HEADER: regola da approfondire; corpo script differito $EB9D; costo0
    DEFB $87,$07                                  ; $EB9B 87 07
; BYTECODE: azione senza argomenti
    DEFB $41,$FD                                  ; $EB9D 41 fd
; BYTECODE: azione con argomenti
    DEFB $42,$13,$FC,$FF                          ; $EB9F 42 13 fc ff
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EBA3 0b
; HEADER: regola da approfondire; corpo script differito $EBA6; costo0
    DEFB $80,$04                                  ; $EBA4 80 04
; BYTECODE: azione senza argomenti
    DEFB $51,$1F,$A6,$EB                          ; $EBA6 51 1f a6 eb
; BYTECODE: regola con argomenti; regola $EBD5
    DEFB $47,$D5,$EB,$FD,$FF                      ; $EBAA 47 d5 eb fd ff
; BYTECODE: azione con argomenti; regola $E5FD
    DEFB $C2,$82,$FA,$FF,$C0,$EB                  ; $EBAF c2 82 fa ff c0 eb
; BYTECODE: azione con argomenti
    DEFB $52,$0C,$FD,$FF,$AA,$EB                  ; $EBB5 52 0c fd ff aa eb
; BYTECODE: regola con argomenti; regola $EBD5
    DEFB $47,$D5,$EB,$FD,$FF                      ; $EBBB 47 d5 eb fd ff
; BYTECODE: accoda ordine a un attore
    DEFB $44,$FA,$1D,$FC,$FF                      ; $EBC0 44 fa 1d fc ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $52,$83,$FB,$FC,$C5,$EB                  ; $EBC5 52 83 fb fc c5 eb
; BYTECODE: regola con argomenti; regola $E506
    DEFB $47,$06,$E5,$FB,$FA                      ; $EBCB 47 06 e5 fb fa
; BYTECODE: azione con argomenti
    DEFB $42,$0D,$FD,$FF                          ; $EBD0 42 0d fd ff
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EBD4 0b
; HEADER: regola da approfondire; corpo codice Z80 $EBD7; costo0
    DEFB $07,$00                                  ; $EBD5 07 00

    ORG $EBE1
; HEADER: regola da approfondire; corpo script differito $EBE3; costo0
    DEFB $84,$00                                  ; $EBE1 84 00
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $C2,$81,$FB,$2A,$EF,$EB                  ; $EBE3 c2 81 fb 2a ef eb
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $52,$81,$FB,$2B,$E3,$EB                  ; $EBE9 52 81 fb 2b e3 eb
; BYTECODE: azione senza argomenti
    DEFB $41,$0C                                  ; $EBEF 41 0c
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $52,$83,$FB,$FD,$F1,$EB                  ; $EBF1 52 83 fb fd f1 eb
; BYTECODE: azione senza argomenti
    DEFB $41,$0D                                  ; $EBF7 41 0d
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $EBF9 0b

    ORG $ECF6
; HEADER: regola da approfondire; corpo script differito $ECF8; costo0
    DEFB $80,$00                                  ; $ECF6 80 00
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $ECF8 41 02
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $ECFA 41 04
; BYTECODE: salto assoluto
    DEFB $0E,$01,$ED                              ; $ECFC 0e 01 ed

    ORG $ED01
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $ED01 41 02
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $ED03 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $ED05 41 02
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $ED07 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $ED09 41 03
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $ED0B 0b
; HEADER: regola da approfondire; corpo script differito $ED0E; costo0
    DEFB $80,$00                                  ; $ED0C 80 00
; BYTECODE: azione senza argomenti
    DEFB $41,$04                                  ; $ED0E 41 04
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $ED10 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $ED12 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$05                                  ; $ED14 41 05
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $ED16 0b
; HEADER: regola da approfondire; corpo script differito $ED19; costo0
    DEFB $80,$00                                  ; $ED17 80 00
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $ED19 41 02
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$13,$FF                          ; $ED1B 42 87 13 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$45,$FF                          ; $ED1F 42 87 45 ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$44,$FF                          ; $ED23 42 87 44 ff
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $ED27 0b
; HEADER: regola da approfondire; corpo script differito $ED2A; costo0
    DEFB $88,$00                                  ; $ED28 88 00
; BYTECODE: azione con argomenti
    DEFB $42,$24,$FD,$FF                          ; $ED2A 42 24 fd ff
; BYTECODE: azione con argomenti
    DEFB $52,$1C,$FD,$FF,$2A,$ED                  ; $ED2E 52 1c fd ff 2a ed
; BYTECODE: azione con argomenti
    DEFB $42,$0E,$FD,$FF                          ; $ED34 42 0e fd ff
; BYTECODE: ritorna con successo
    DEFB $0B                                      ; $ED38 0b

    ORG $EE2B
; BYTECODE: consuma segnale del mittente
    DEFB $59,$04,$2B,$EE                          ; $EE2B 59 04 2b ee
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$00                          ; $EE2F 42 80 fb 00
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$17,$FF,$33,$EE                  ; $EE33 12 88 17 ff 33 ee
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$3D                          ; $EE39 02 80 fb 3d
; BYTECODE: regola senza argomenti; regola $EFB3
    DEFB $03,$B3,$EF                              ; $EE3D 03 b3 ef
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $52,$88,$07,$FF,$40,$EE                  ; $EE40 52 88 07 ff 40 ee
; BYTECODE: regola senza argomenti; regola $EFC7
    DEFB $03,$C7,$EF                              ; $EE46 03 c7 ef
; BYTECODE: azione senza argomenti
    DEFB $41,$0A                                  ; $EE49 41 0a
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$13,$FF                          ; $EE4B 42 87 13 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EE4F 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EE51 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EE53 41 01
; BYTECODE: azione senza argomenti
    DEFB $41,$01                                  ; $EE55 41 01
; BYTECODE: regola con argomenti; regola $EBE1
    DEFB $47,$E1,$EB,$17,$FF                      ; $EE57 47 e1 eb 17 ff
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EE5C 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EE5E 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EE60 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EE62 41 08
; BYTECODE: azione senza argomenti
    DEFB $41,$08                                  ; $EE64 41 08
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $47,$A4,$EB,$FF,$20                      ; $EE66 47 a4 eb ff 20
; BYTECODE: azione con argomenti; regola $F203
    DEFB $42,$85,$5B,$FF                          ; $EE6B 42 85 5b ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$5B,$FF                          ; $EE6F 42 87 5b ff
; BYTECODE: azione con argomenti; regola $F210
    DEFB $42,$84,$5B,$FF                          ; $EE73 42 84 5b ff
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$0D,$FF,$77,$EE                  ; $EE77 12 88 0d ff 77 ee
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$00,$20,$95,$EE                  ; $EE7D 82 83 00 20 95 ee
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$00,$66,$95,$EE                  ; $EE83 82 83 00 66 95 ee
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$01,$66,$95,$EE                  ; $EE89 82 83 01 66 95 ee
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$01,$20,$98,$EE                  ; $EE8F 12 83 01 20 98 ee
; BYTECODE: regola senza argomenti; regola $EF9C
    DEFB $03,$9C,$EF                              ; $EE95 03 9c ef
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$16,$FF,$98,$EE                  ; $EE98 12 88 16 ff 98 ee
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$23                          ; $EE9E 02 80 fb 23
; BYTECODE: azione con argomenti; regola $F203
    DEFB $02,$85,$4F,$FF                          ; $EEA2 02 85 4f ff
; BYTECODE: azione con argomenti
    DEFB $02,$24,$4F,$FF                          ; $EEA6 02 24 4f ff
; BYTECODE: regola con argomenti; regola $E52F
    DEFB $07,$2F,$E5,$37,$14                      ; $EEAA 07 2f e5 37 14
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $82,$81,$FB,$00,$96,$EF                  ; $EEAF 82 81 fb 00 96 ef
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EEB5 0f
; BYTECODE: regola senza argomenti; regola $E57A
    DEFB $83,$7A,$E5,$AF,$EE                      ; $EEB6 83 7a e5 af ee
; BYTECODE: regola senza argomenti; regola $EFB3
    DEFB $03,$B3,$EF                              ; $EEBB 03 b3 ef
; BYTECODE: regola con argomenti; regola $DDBE
    DEFB $47,$BE,$DD,$28,$FF                      ; $EEBE 47 be dd 28 ff
; BYTECODE: regola senza argomenti; regola $EFC7
    DEFB $03,$C7,$EF                              ; $EEC3 03 c7 ef
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$53,$26,$DA,$EE                  ; $EEC6 12 83 53 26 da ee
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$51,$27,$DA,$EE                  ; $EECC 12 83 51 27 da ee
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$51,$00                          ; $EED2 02 80 51 00
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$53,$00                          ; $EED6 02 80 53 00
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EEDA 0f
; BYTECODE: regola senza argomenti; regola $EFC7
    DEFB $03,$C7,$EF                              ; $EEDB 03 c7 ef
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$09,$FF,$DA,$EE                  ; $EEDE 12 88 09 ff da ee
; BYTECODE: regola con argomenti; regola $DDBE
    DEFB $07,$BE,$DD,$32,$FF                      ; $EEE4 07 be dd 32 ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$00,$20,$01,$EF                  ; $EEE9 82 83 00 20 01 ef
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$00,$66,$01,$EF                  ; $EEEF 82 83 00 66 01 ef
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$01,$66,$01,$EF                  ; $EEF5 82 83 01 66 01 ef
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$01,$20,$09,$EF                  ; $EEFB 12 83 01 20 09 ef
; BYTECODE: regola senza argomenti; regola $EFAC
    DEFB $03,$AC,$EF                              ; $EF01 03 ac ef
; BYTECODE: regola con argomenti; regola $DDBE
    DEFB $07,$BE,$DD,$0F,$FF                      ; $EF04 07 be dd 0f ff
; BYTECODE: regola senza argomenti; regola $EFC7
    DEFB $03,$C7,$EF                              ; $EF09 03 c7 ef
; BYTECODE: regola con argomenti; regola $F1F6
    DEFB $47,$F6,$F1,$55,$FF                      ; $EF0C 47 f6 f1 55 ff
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$21                          ; $EF11 02 80 fb 21
; BYTECODE: azione con argomenti; regola $F203
    DEFB $42,$85,$5B,$FF                          ; $EF15 42 85 5b ff
; BYTECODE: azione con argomenti; regola $ED28
    DEFB $42,$87,$5B,$FF                          ; $EF19 42 87 5b ff
; BYTECODE: azione con argomenti; regola $F210
    DEFB $42,$84,$5B,$FF                          ; $EF1D 42 84 5b ff
; BYTECODE: regola senza argomenti; regola $EB72
    DEFB $43,$72,$EB                              ; $EF21 43 72 eb
; BYTECODE: azione senza argomenti
    DEFB $41,$02                                  ; $EF24 41 02
; BYTECODE: azione senza argomenti
    DEFB $41,$03                                  ; $EF26 41 03
; BYTECODE: invia segnale
    DEFB $08,$68                                  ; $EF28 08 68
; BYTECODE: azione con argomenti; regola $E497
    DEFB $42,$80,$FB,$67                          ; $EF2A 42 80 fb 67
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$0F,$FF,$2E,$EF                  ; $EF2E 12 88 0f ff 2e ef
; BYTECODE: regola con argomenti; regola $E52F
    DEFB $07,$2F,$E5,$10,$FF                      ; $EF34 07 2f e5 10 ff
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $82,$83,$00,$67,$47,$EF                  ; $EF39 82 83 00 67 47 ef
; BYTECODE: cede con costo 1
    DEFB $0F                                      ; $EF3F 0f
; BYTECODE: regola senza argomenti; regola $E57A
    DEFB $93,$7A,$E5,$39,$EF,$8C,$EF              ; $EF40 93 7a e5 39 ef 8c ef
; BYTECODE: stampa testo
    DEFB $06,$73,$75                              ; $EF47 06 73 75
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$32                          ; $EF4A 02 80 fb 32
; BYTECODE: azione con argomenti; regola $F1D6
    DEFB $12,$88,$10,$FF,$4E,$EF                  ; $EF4E 12 88 10 ff 4e ef
; BYTECODE: regola con argomenti; regola $DDBE
    DEFB $07,$BE,$DD,$30,$FF                      ; $EF54 07 be dd 30 ff
; BYTECODE: azione senza argomenti
    DEFB $01,$01                                  ; $EF59 01 01
; BYTECODE: azione senza argomenti
    DEFB $01,$01                                  ; $EF5B 01 01
; BYTECODE: azione senza argomenti
    DEFB $01,$01                                  ; $EF5D 01 01
; BYTECODE: azione senza argomenti
    DEFB $11,$0C,$5F,$EF                          ; $EF5F 11 0c 5f ef
; BYTECODE: azione con argomenti; regola $E5AD
    DEFB $12,$83,$FB,$17,$63,$EF                  ; $EF63 12 83 fb 17 63 ef
; BYTECODE: azione senza argomenti
    DEFB $01,$0D                                  ; $EF69 01 0d
; BYTECODE: azione senza argomenti
    DEFB $01,$08                                  ; $EF6B 01 08
; BYTECODE: azione senza argomenti
    DEFB $01,$08                                  ; $EF6D 01 08
; BYTECODE: azione senza argomenti
    DEFB $01,$08                                  ; $EF6F 01 08
; BYTECODE: azione senza argomenti
    DEFB $01,$08                                  ; $EF71 01 08
; BYTECODE: azione senza argomenti
    DEFB $01,$08                                  ; $EF73 01 08
; BYTECODE: regola con argomenti; regola $DDBE
    DEFB $07,$BE,$DD,$05,$FF                      ; $EF75 07 be dd 05 ff
; BYTECODE: regola con argomenti; regola $EBA4
    DEFB $07,$A4,$EB,$FF,$1C                      ; $EF7A 07 a4 eb ff 1c
; BYTECODE: azione senza argomenti
    DEFB $01,$03                                  ; $EF7F 01 03
; BYTECODE: azione senza argomenti
    DEFB $01,$03                                  ; $EF81 01 03
; BYTECODE: azione con argomenti; regola $E5D8
    DEFB $12,$81,$FB,$00,$8C,$EF                  ; $EF83 12 81 fb 00 8c ef
; BYTECODE: regola senza argomenti; regola $9E48
    DEFB $03,$48,$9E                              ; $EF89 03 48 9e
; BYTECODE: azione con argomenti; regola $E497
    DEFB $02,$80,$FB,$00                          ; $EF8C 02 80 fb 00
; BYTECODE: regola senza argomenti; regola $E5A8
    DEFB $03,$A8,$E5                              ; $EF90 03 a8 e5
; BYTECODE: salto assoluto
    DEFB $0E,$90,$EF                              ; $EF93 0e 90 ef
; BYTECODE: regola senza argomenti; regola $E588
    DEFB $03,$88,$E5                              ; $EF96 03 88 e5
; BYTECODE: regola senza argomenti; regola $DFCA
    DEFB $03,$CA,$DF                              ; $EF99 03 ca df
; HEADER: scena di Basil osservato presso casa sua; corpo codice Z80 $EF9E; costo0
    DEFB $00,$00                                  ; $EF9C 00 00

    ORG $EFAC
; HEADER: regola da approfondire; corpo codice Z80 $EFAE; costo0
    DEFB $00,$00                                  ; $EFAC 00 00

    ORG $EFB3
; HEADER: regola da approfondire; corpo codice Z80 $EFB5; costo0
    DEFB $00,$00                                  ; $EFB3 00 00

    ORG $EFC7
; HEADER: regola da approfondire; corpo codice Z80 $EFC9; costo0
    DEFB $00,$00                                  ; $EFC7 00 00

    ORG $F198
; HEADER: regola da approfondire; corpo codice Z80 $F19A; costo0
    DEFB $07,$00                                  ; $F198 07 00

    ORG $F1D6
; HEADER: verifica ora su 24 ore (non minuti/giorno); corpo codice Z80 $F1D8; costo0
    DEFB $07,$00                                  ; $F1D6 07 00
; Z80: Test ora: 1..12am,13..24pm; non confronta minuti ne giorno.
    LD A,($A034)                                  ; $F1D8 3a 34 a0
    LD B,$61                                      ; $F1DB 06 61
    CP $0D                                        ; $F1DD fe 0d
    JR C,$F1E5                                    ; $F1DF 38 04
    LD B,$70                                      ; $F1E1 06 70
    SUB $0C                                       ; $F1E3 d6 0c
    LD HL,$9FE0                                   ; $F1E5 21 e0 9f
    CP (HL)                                       ; $F1E8 be
    JP NZ,$DC15                                   ; $F1E9 c2 15 dc
    LD A,($9FE2)                                  ; $F1EC 3a e2 9f
    CP B                                          ; $F1EF b8
    JP NZ,$DC15                                   ; $F1F0 c2 15 dc
    OR $01                                        ; $F1F3 f6 01
    RET                                           ; $F1F5 c9
; HEADER: regola da approfondire; corpo codice Z80 $F1F8; costo0
    DEFB $07,$00                                  ; $F1F6 07 00

    ORG $F203
; HEADER: regola da approfondire; corpo codice Z80 $F205; costo0
    DEFB $07,$00                                  ; $F203 07 00

    ORG $F210
; HEADER: regola da approfondire; corpo codice Z80 $F212; costo0
    DEFB $07,$00                                  ; $F210 07 00
