# Sequenze NPC decodificate

Indirizzi esadecimali, ID decimali. Succ./Fall. sono i punti di ripresa; le regole differite possono sospendere la sequenza. `FA/FB/FC/FD` sono riferimenti dinamici, non entità. Il bit `$40` segnala una restrizione agli ordini: non equivale al rifiuto di ogni comando.

## watson — ID 3

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| E72F | `06 eb 6d` | stampa testo; Watson looks up from the paper and says " Good morning Holmes. "  | E732 | — |
| E732 | `07 2f e5 0d 04` | regola con argomenti $E52F (crea contatore privato base + casuale(ampiezza)); arg. $0D, $04 | E737 | E737 |
| E737 | `13 9a e7 b6 e7` | regola senza argomenti $E79A (attesa interrompibile di Watson nella stanza iniziale); arg. $FF, $FF | E73C | E7B6 |
| E73C | `12 81 00 fb 51 e7` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $00, $FB | E742 | E751 |
| E742 | `06 02 6e` | stampa testo; With an excited look on his face ⟦nome referente $A036⟧ says " Well here is a case that may interest you, it seems that two close friends, a Mrs Brown and a Mrs Jones, were murdered last night in separate incidents although apparently with the same weapon. The crimes occurred at their respective homes in the township of Leather Head and, because of the lack of murder weapon and apparent motive, the local police are completely baffled. They have called upon Scotland Yard for assistance and it appears that the famed detective Inspector Giles Lestrade has taken an interest in the case and will be going to the scene this morning. "  | E745 | — |
| E745 | `07 2f e5 0f 0a` | regola con argomenti $E52F (crea contatore privato base + casuale(ampiezza)); arg. $0F, $0A | E74A | E74A |
| E74A | `93 9a e7 7b e7 b6 e7` | regola senza argomenti $E79A (attesa interrompibile di Watson nella stanza iniziale); arg. $FF, $FF | E77B | E7B6 |
| E751 | `07 2f e5 0f 0a` | regola con argomenti $E52F (crea contatore privato base + casuale(ampiezza)); arg. $0F, $0A | E756 | E756 |
| E756 | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | E759 | E759 |
| E759 | `12 83 fb 08 b6 e7` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $08 | E75F | E7B6 |
| E75F | `17 e2 e7 19 ff b6 e7` | regola con argomenti $E7E2 (verifica possesso percepibile (classe A)); arg. $19, $FF | E766 | E7B6 |
| E766 | `82 81 00 fb 73 e7` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $00, $FB | E773 | E76C |
| E76C | `93 7a e5 56 e7 7b e7` | regola senza argomenti $E57A (decrementa contatore; fallisce quando raggiunge zero); arg. $FF, $FF | E756 | E77B |
| E773 | `06 fc 6e` | stampa testo; ⟦nome referente $A036⟧ Looks up as you enter saying " Hello there Holmes, just a minute now- here is a case that may interest you, it seems that two close friends, a Mrs Brown and a Mrs Jones, were murdered last night in separate incidents although apparently with the same weapon. The crimes occurred at their respective homes in the township of Leather Head and, because of the lack of murder weapon and apparent motive, the local police are completely baffled. They have called upon Scotland Yard for assistance and it appears that the famed detective Inspector Giles Lestrade has taken an interest in the case and will be going to the scene this morning. "  | E776 | — |
| E776 | `13 9a e7 b6 e7` | regola senza argomenti $E79A (attesa interrompibile di Watson nella stanza iniziale); arg. $FF, $FF | E77B | E7B6 |
| E77B | `12 83 fb 08 b6 e7` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $08 | E781 | E7B6 |
| E781 | `13 c1 e5 8c e7` | regola senza argomenti $E5C1 (confronta locazione attore con giocatore attivo); arg. $FF, $FF | E786 | E78C |
| E786 | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | E789 | E789 |
| E789 | `0e 7b e7` | salto assoluto; jump=E77B | E77B | — |
| E78C | `02 80 1a 08` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $1A, $08 | E790 | E790 |
| E790 | `02 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | E794 | E794 |
| E794 | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | E797 | E797 |
| E797 | `0e 94 e7` | salto assoluto; jump=E794 | E794 | — |
| E7B6 | `03 88 e5` | regola senza argomenti $E588 (elimina contatore privato); arg. $FF, $FF | E7B9 | E7B9 |
| E7B9 | `07 88 e4 00 ff` | regola con argomenti $E488 (salva la locazione del primo argomento in 9FD6); arg. $00, $FF | E7BE | E7BE |
| E7BE | `87 52 dd fa ff b9 e7` | regola con argomenti $DD52 (raggiungi una locazione attraverso un’uscita diretta); arg. $FA, $FF | E7B9 | E7C5 |
| E7C5 | `82 82 00 ff b9 e7` | azione con argomenti $E5FD (confronta le radici del contenimento); arg. $00, $FF | E7B9 | E7CB |
| E7CB | `81 0d b9 e7` | azione senza argomenti 13 (climb out of); arg. $FF, $FF | E7B9 | E7CF |
| E7CF | `17 84 dd 00 ff b9 e7` | regola con argomenti $DD84 (salva il genitore del primo argomento in 9FD6); arg. $00, $FF | E7D6 | E7B9 |
| E7D6 | `82 0c fa ff b9 e7` | azione con argomenti 12 (climb into); arg. $FA, $FF | E7B9 | E7DC |
| E7DC | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | E7DF | E7DF |
| E7DF | `0e b9 e7` | salto assoluto; jump=E7B9 | E7B9 | — |

## inspector lestrade — ID 2

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| E7E7 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E7E9 | E7E9 |
| E7E9 | `43 72 eb` | regola senza argomenti $EB72 (vedere rules.json); arg. $FF, $FF | E7EC | E7EC |
| E7EC | `45 04 18 69` | parla a un destinatario; target_actor=4; ⟦scelta: hello / call @$691C⟧ | E7F0 | — |
| E7F0 | `48 04` | invia segnale; target_actor=4 | E7F2 | — |
| E7F2 | `59 04 f2 e7` | consuma segnale del mittente; sender=4 | E7F6 | E7F2 |
| E7F6 | `45 04 63 71` | parla a un destinatario; target_actor=4; Now what seems to be the problem here? | E7FA | — |
| E7FA | `48 04` | invia segnale; target_actor=4 | E7FC | — |
| E7FC | `59 04 fc e7` | consuma segnale del mittente; sender=4 | E800 | E7FC |
| E800 | `45 04 75 71` | parla a un destinatario; target_actor=4; Well then show me to the Brown's estate please. | E804 | — |
| E804 | `48 04` | invia segnale; target_actor=4 | E806 | — |
| E806 | `42 86 04 58` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $58 | E80A | E80A |
| E80A | `42 13 2e ff` | azione con argomenti 19 (examine); arg. $2E, $FF | E80E | E80E |
| E80E | `42 13 2f ff` | azione con argomenti 19 (examine); arg. $2F, $FF | E812 | E812 |
| E812 | `42 13 39 ff` | azione con argomenti 19 (examine); arg. $39, $FF | E816 | E816 |
| E816 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E818 | E818 |
| E818 | `42 13 39 ff` | azione con argomenti 19 (examine); arg. $39, $FF | E81C | E81C |
| E81C | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | E81E | E81E |
| E81E | `45 04 50 71` | parla a un destinatario; target_actor=4; Have your men searched the river for the gun yet? | E822 | — |
| E822 | `48 04` | invia segnale; target_actor=4 | E824 | — |
| E824 | `59 04 24 e8` | consuma segnale del mittente; sender=4 | E828 | E824 |
| E828 | `42 89 07 3b` | azione con argomenti $EB9B (vedere rules.json); arg. $07, $3B | E82C | E82C |
| E82C | `42 89 03 3a` | azione con argomenti $EB9B (vedere rules.json); arg. $03, $3A | E830 | E830 |
| E830 | `42 89 01 3a` | azione con argomenti $EB9B (vedere rules.json); arg. $01, $3A | E834 | E834 |
| E834 | `41 05` | azione senza argomenti 5 (northeast go); arg. $FF, $FF | E836 | E836 |
| E836 | `42 89 01 4b` | azione con argomenti $EB9B (vedere rules.json); arg. $01, $4B | E83A | E83A |
| E83A | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E83C | E83C |
| E83C | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E83E | E83E |
| E83E | `41 06` | azione senza argomenti 6 (northwest go); arg. $FF, $FF | E840 | E840 |
| E840 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E842 | E842 |
| E842 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E844 | E844 |
| E844 | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | E846 | E846 |
| E846 | `41 02` | azione senza argomenti 2 (south go); arg. $FF, $FF | E848 | E848 |
| E848 | `42 89 07 3b` | azione con argomenti $EB9B (vedere rules.json); arg. $07, $3B | E84C | E84C |
| E84C | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | E84E | E84E |
| E84E | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | E850 | E850 |
| E850 | `45 04 89 71` | parla a un destinatario; target_actor=4; Right then Constable will you show me to Miss Strachan and Mr Phipps please. | E854 | — |
| E854 | `48 04` | invia segnale; target_actor=4 | E856 | — |
| E856 | `42 86 04 43` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $43 | E85A | E85A |
| E85A | `0f` | cede con costo 1 | E85B | — |
| E85B | `44 05 30 fb 10` | accoda ordine a un attore 48 (tell about); arg. $FB, $10; target_actor=5 | E860 | — |
| E860 | `0f` | cede con costo 1 | E861 | — |
| E861 | `44 06 2f fb 11` | accoda ordine a un attore 47 (tell); arg. $FB, $11; target_actor=6 | E866 | — |
| E866 | `0f` | cede con costo 1 | E867 | — |
| E867 | `0f` | cede con costo 1 | E868 | — |
| E868 | `46 26 71` | stampa testo; ⟦nome referente $A036⟧ ⟦scelta: say/says / remark/remarks⟧ " I would like you to remain here please. "  | E86B | — |
| E86B | `45 04 a4 71` | parla a un destinatario; target_actor=4; Chief Constable I will see the staff now. | E86F | — |
| E86F | `48 04` | invia segnale; target_actor=4 | E871 | — |
| E871 | `42 86 04 41` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $41 | E875 | E875 |
| E875 | `44 08 30 fb 10` | accoda ordine a un attore 48 (tell about); arg. $FB, $10; target_actor=8 | E87A | — |
| E87A | `0f` | cede con costo 1 | E87B | — |
| E87B | `44 0a 30 fb 10` | accoda ordine a un attore 48 (tell about); arg. $FB, $10; target_actor=10 | E880 | — |
| E880 | `0f` | cede con costo 1 | E881 | — |
| E881 | `44 09 2f fb 10` | accoda ordine a un attore 47 (tell); arg. $FB, $10; target_actor=9 | E886 | — |
| E886 | `0f` | cede con costo 1 | E887 | — |
| E887 | `0f` | cede con costo 1 | E888 | — |
| E888 | `46 26 71` | stampa testo; ⟦nome referente $A036⟧ ⟦scelta: say/says / remark/remarks⟧ " I would like you to remain here please. "  | E88B | — |
| E88B | `45 04 b7 71` | parla a un destinatario; target_actor=4; Well I must say this is all very confusing, perhaps I should visit the estate of Mrs Jones now. | E88F | — |
| E88F | `48 04` | invia segnale; target_actor=4 | E891 | — |
| E891 | `42 86 04 5e` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $5E | E895 | E895 |
| E895 | `42 13 48 ff` | azione con argomenti 19 (examine); arg. $48, $FF | E899 | E899 |
| E899 | `42 13 47 ff` | azione con argomenti 19 (examine); arg. $47, $FF | E89D | E89D |
| E89D | `42 13 42 ff` | azione con argomenti 19 (examine); arg. $42, $FF | E8A1 | E8A1 |
| E8A1 | `52 1c 42 ff ab e8` | azione con argomenti 28 (go through); arg. $42, $FF | E8A7 | E8AB |
| E8A7 | `42 13 43 ff` | azione con argomenti 19 (examine); arg. $43, $FF | E8AB | E8AB |
| E8AB | `42 1c 42 ff` | azione con argomenti 28 (go through); arg. $42, $FF | E8AF | E8AF |
| E8AF | `48 04` | invia segnale; target_actor=4 | E8B1 | — |
| E8B1 | `43 47 eb` | regola senza argomenti $EB47 (vedere rules.json); arg. $FF, $FF | E8B4 | E8B4 |
| E8B4 | `48 07` | invia segnale; target_actor=7 | E8B6 | — |
| E8B6 | `0f` | cede con costo 1 | E8B7 | — |
| E8B7 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E8B9 | E8B9 |
| E8B9 | `45 0b 12 71` | parla a un destinatario; target_actor=11; What is going on here constable? | E8BD | — |
| E8BD | `48 0b` | invia segnale; target_actor=11 | E8BF | — |
| E8BF | `48 07` | invia segnale; target_actor=7 | E8C1 | — |
| E8C1 | `59 07 c1 e8` | consuma segnale del mittente; sender=7 | E8C5 | E8C1 |
| E8C5 | `45 07 1d 71` | parla a un destinatario; target_actor=7; Come with me please. | E8C9 | — |
| E8C9 | `43 17 ed` | regola senza argomenti $ED17 (vedere rules.json); arg. $FF, $FF | E8CC | E8CC |
| E8CC | `0f` | cede con costo 1 | E8CD | — |
| E8CD | `44 04 30 07 0f` | accoda ordine a un attore 48 (tell about); arg. $07, $0F; target_actor=4 | E8D2 | — |
| E8D2 | `0f` | cede con costo 1 | E8D3 | — |
| E8D3 | `44 07 30 fb 11` | accoda ordine a un attore 48 (tell about); arg. $FB, $11; target_actor=7 | E8D8 | — |
| E8D8 | `0f` | cede con costo 1 | E8D9 | — |
| E8D9 | `0f` | cede con costo 1 | E8DA | — |
| E8DA | `44 07 2f fb 12` | accoda ordine a un attore 47 (tell); arg. $FB, $12; target_actor=7 | E8DF | — |
| E8DF | `0f` | cede con costo 1 | E8E0 | — |
| E8E0 | `0f` | cede con costo 1 | E8E1 | — |
| E8E1 | `44 07 15 fb ff` | accoda ordine a un attore 21 (follow); arg. $FB, $FF; target_actor=7 | E8E6 | — |
| E8E6 | `42 87 44 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $44, $FF | E8EA | E8EA |
| E8EA | `46 26 71` | stampa testo; ⟦nome referente $A036⟧ ⟦scelta: say/says / remark/remarks⟧ " I would like you to remain here please. "  | E8ED | — |
| E8ED | `42 87 45 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $45, $FF | E8F1 | E8F1 |
| E8F1 | `42 87 13 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $13, $FF | E8F5 | E8F5 |
| E8F5 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E8F7 | E8F7 |
| E8F7 | `45 0b 39 71` | parla a un destinatario; target_actor=11; Make sure the Major does not leave constable. | E8FB | — |
| E8FB | `45 04 a4 71` | parla a un destinatario; target_actor=4; Chief Constable I will see the staff now. | E8FF | — |
| E8FF | `48 04` | invia segnale; target_actor=4 | E901 | — |
| E901 | `42 86 04 41` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $41 | E905 | E905 |
| E905 | `44 09 30 fb 07` | accoda ordine a un attore 48 (tell about); arg. $FB, $07; target_actor=9 | E90A | — |
| E90A | `0f` | cede con costo 1 | E90B | — |
| E90B | `44 08 30 fb 07` | accoda ordine a un attore 48 (tell about); arg. $FB, $07; target_actor=8 | E910 | — |
| E910 | `0f` | cede con costo 1 | E911 | — |
| E911 | `45 04 89 71` | parla a un destinatario; target_actor=4; Right then Constable will you show me to Miss Strachan and Mr Phipps please. | E915 | — |
| E915 | `48 04` | invia segnale; target_actor=4 | E917 | — |
| E917 | `42 86 04 43` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $43 | E91B | E91B |
| E91B | `0f` | cede con costo 1 | E91C | — |
| E91C | `44 05 30 fb 07` | accoda ordine a un attore 48 (tell about); arg. $FB, $07; target_actor=5 | E921 | — |
| E921 | `0f` | cede con costo 1 | E922 | — |
| E922 | `45 04 08 70` | parla a un destinatario; target_actor=4; Well it looks as though the Major is our man. | E926 | — |
| E926 | `48 04` | invia segnale; target_actor=4 | E928 | — |
| E928 | `42 86 04 5c` | azione con argomenti $EB8B (vedere rules.json); arg. $04, $5C | E92C | E92C |
| E92C | `45 04 34 70` | parla a un destinatario; target_actor=4; Well then constable I shall return to the Yard and apprehend this Major Ffoulkes. You may remove the bodies now and tell the others they are free to go. | E930 | — |
| E930 | `48 04` | invia segnale; target_actor=4 | E932 | — |
| E932 | `03 6a 9e` | regola senza argomenti $9E6A (vedere rules.json); arg. $FF, $FF | E935 | E935 |
| E935 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E937 | E937 |
| E937 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E939 | E939 |
| E939 | `43 28 eb` | regola senza argomenti $EB28 (vedere rules.json); arg. $FF, $FF | E93C | E93C |
| E93C | `0f` | cede con costo 1 | E93D | — |
| E93D | `c2 81 fb 00 49 e9` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | E949 | E943 |
| E943 | `d9 07 51 e9 3c e9` | consuma segnale del mittente; sender=7 | E951 | E93C |
| E949 | `45 00 20 70` | parla a un destinatario; target_actor=0; Well it looks as though the Major is our man. My men are out looking for him now. | E94D | — |
| E94D | `59 07 4d e9` | consuma segnale del mittente; sender=7 | E951 | E94D |
| E951 | `42 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | E955 | E955 |
| E955 | `82 81 00 07 61 e9` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $00, $07 | E961 | E95B |
| E95B | `12 88 01 ff 55 e9` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $01, $FF | E961 | E955 |
| E961 | `02 80 fb 0c` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0C | E965 | E965 |
| E965 | `52 81 fb 07 65 e9` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $07 | E96B | E965 |
| E96B | `03 85 9e` | regola senza argomenti $9E85 (vedere rules.json); arg. $FF, $FF | E96E | E96E |
| E96E | `45 07 75 70` | parla a un destinatario; target_actor=7; You are free to go. | E972 | — |
| E972 | `48 07` | invia segnale; target_actor=7 | E974 | — |
| E974 | `47 a4 eb ff 0a` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $0A | E979 | E979 |
| E979 | `42 80 fb 0b` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0B | E97D | E97D |
| E97D | `42 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | E981 | E981 |
| E981 | `52 88 07 ff 81 e9` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $07, $FF | E987 | E981 |
| E987 | `42 80 fb 0b` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0B | E98B | E98B |
| E98B | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E98D | E98D |
| E98D | `48 04` | invia segnale; target_actor=4 | E98F | — |
| E98F | `43 72 eb` | regola senza argomenti $EB72 (vedere rules.json); arg. $FF, $FF | E992 | E992 |
| E992 | `44 04 20 ff ff` | accoda ordine a un attore 32 (hello); arg. $FF, $FF; target_actor=4 | E997 | — |
| E997 | `43 f6 ec` | regola senza argomenti $ECF6 (vedere rules.json); arg. $FF, $FF | E99A | E99A |
| E99A | `c2 88 0a ff db e9` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $0A, $FF | E9DB | E9A0 |
| E9A0 | `c7 e2 e7 5d ff db e9` | regola con argomenti $E7E2 (verifica possesso percepibile (classe A)); arg. $5D, $FF | E9DB | E9A7 |
| E9A7 | `57 98 f1 0a ff b5 e9` | regola con argomenti $F198 (vedere rules.json); arg. $0A, $FF | E9AE | E9B5 |
| E9AE | `42 13 39 ff` | azione con argomenti 19 (examine); arg. $39, $FF | E9B2 | E9B2 |
| E9B2 | `0e 9a e9` | salto assoluto; jump=E99A | E99A | — |
| E9B5 | `57 98 f1 0a ff c3 e9` | regola con argomenti $F198 (vedere rules.json); arg. $0A, $FF | E9BC | E9C3 |
| E9BC | `42 13 3b ff` | azione con argomenti 19 (examine); arg. $3B, $FF | E9C0 | E9C0 |
| E9C0 | `0e 9a e9` | salto assoluto; jump=E99A | E99A | — |
| E9C3 | `57 98 f1 0a ff cf e9` | regola con argomenti $F198 (vedere rules.json); arg. $0A, $FF | E9CA | E9CF |
| E9CA | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | E9CC | E9CC |
| E9CC | `0e 9a e9` | salto assoluto; jump=E99A | E99A | — |
| E9CF | `57 98 f1 0a ff 9a e9` | regola con argomenti $F198 (vedere rules.json); arg. $0A, $FF | E9D6 | E99A |
| E9D6 | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | E9D8 | E9D8 |
| E9D8 | `0e 9a e9` | salto assoluto; jump=E99A | E99A | — |
| E9DB | `43 0c ed` | regola senza argomenti $ED0C (vedere rules.json); arg. $FF, $FF | E9DE | E9DE |
| E9DE | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | E9E0 | E9E0 |
| E9E0 | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | E9E2 | E9E2 |
| E9E2 | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | E9E4 | E9E4 |
| E9E4 | `43 17 ed` | regola senza argomenti $ED17 (vedere rules.json); arg. $FF, $FF | E9E7 | E9E7 |
| E9E7 | `42 13 42 ff` | azione con argomenti 19 (examine); arg. $42, $FF | E9EB | E9EB |
| E9EB | `42 13 47 ff` | azione con argomenti 19 (examine); arg. $47, $FF | E9EF | E9EF |
| E9EF | `52 1c 42 ff f9 e9` | azione con argomenti 28 (go through); arg. $42, $FF | E9F5 | E9F9 |
| E9F5 | `42 13 43 ff` | azione con argomenti 19 (examine); arg. $43, $FF | E9F9 | E9F9 |
| E9F9 | `42 1c 42 ff` | azione con argomenti 28 (go through); arg. $42, $FF | E9FD | E9FD |
| E9FD | `43 47 eb` | regola senza argomenti $EB47 (vedere rules.json); arg. $FF, $FF | EA00 | EA00 |
| EA00 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EA02 | EA02 |
| EA02 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | EA04 | EA04 |
| EA04 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EA06 | EA06 |
| EA06 | `45 04 90 6f` | parla a un destinatario; target_actor=4; Keep me posted on any new events. | EA0A | — |
| EA0A | `43 28 eb` | regola senza argomenti $EB28 (vedere rules.json); arg. $FF, $FF | EA0D | EA0D |
| EA0D | `42 80 5d 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $5D, $00 | EA11 | EA11 |
| EA11 | `52 88 15 ff 11 ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $15, $FF | EA17 | EA11 |
| EA17 | `42 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | EA1B | EA1B |
| EA1B | `52 88 07 ff 1b ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $07, $FF | EA21 | EA1B |
| EA21 | `42 80 fb 0b` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0B | EA25 | EA25 |
| EA25 | `0f` | cede con costo 1 | EA26 | — |
| EA26 | `c2 88 15 ff a9 ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $15, $FF | EAA9 | EA2C |
| EA2C | `53 19 eb 25 ea` | regola senza argomenti $EB19 (vedere rules.json); arg. $FF, $FF | EA31 | EA25 |
| EA31 | `c3 11 eb 5b ea` | regola senza argomenti $EB11 (vedere rules.json); arg. $FF, $FF | EA5B | EA36 |
| EA36 | `c2 88 15 ff a9 ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $15, $FF | EAA9 | EA3C |
| EA3C | `0f` | cede con costo 1 | EA3D | — |
| EA3D | `c2 81 fb 00 31 ea` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | EA31 | EA43 |
| EA43 | `c3 11 eb 5b ea` | regola senza argomenti $EB11 (vedere rules.json); arg. $FF, $FF | EA5B | EA48 |
| EA48 | `c2 88 15 ff a9 ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $15, $FF | EAA9 | EA4E |
| EA4E | `0f` | cede con costo 1 | EA4F | — |
| EA4F | `52 81 fb 00 43 ea` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | EA55 | EA43 |
| EA55 | `c5 00 c0 70 31 ea` | parla a un destinatario; target_actor=0; Have you found where the sale location is. | EA31 | — |
| EA5B | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | EA5D | EA5D |
| EA5D | `48 04` | invia segnale; target_actor=4 | EA5F | — |
| EA5F | `47 f6 ea 6d 0b` | regola con argomenti $EAF6 (vedere rules.json); arg. $6D, $0B | EA64 | EA64 |
| EA64 | `43 72 eb` | regola senza argomenti $EB72 (vedere rules.json); arg. $FF, $FF | EA67 | EA67 |
| EA67 | `41 02` | azione senza argomenti 2 (south go); arg. $FF, $FF | EA69 | EA69 |
| EA69 | `42 0c 6d ff` | azione con argomenti 12 (climb into); arg. $6D, $FF | EA6D | EA6D |
| EA6D | `44 0b 1e 67 ff` | accoda ordine a un attore 30 (go to furiously); arg. $67, $FF; target_actor=11 | EA72 | — |
| EA72 | `52 83 fb 67 72 ea` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $67 | EA78 | EA72 |
| EA78 | `52 82 00 ff 84 ea` | azione con argomenti $E5FD (confronta le radici del contenimento); arg. $00, $FF | EA7E | EA84 |
| EA7E | `c2 83 06 67 b6 ea` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $06, $67 | EAB6 | EA84 |
| EA84 | `44 0b 1d 32 ff` | accoda ordine a un attore 29 (go to); arg. $32, $FF; target_actor=11 | EA89 | — |
| EA89 | `52 83 fb 32 89 ea` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $32 | EA8F | EA89 |
| EA8F | `42 0d 6d ff` | azione con argomenti 13 (climb out of); arg. $6D, $FF | EA93 | EA93 |
| EA93 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EA95 | EA95 |
| EA95 | `43 28 eb` | regola senza argomenti $EB28 (vedere rules.json); arg. $FF, $FF | EA98 | EA98 |
| EA98 | `0f` | cede con costo 1 | EA99 | — |
| EA99 | `82 81 fb 00 a5 ea` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | EAA5 | EA9F |
| EA9F | `52 88 16 ff 98 ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $16, $FF | EAA5 | EA98 |
| EAA5 | `45 00 c7 70` | parla a un destinatario; target_actor=0; I am afraid that Basil has eluded us Holmes. | EAA9 | — |
| EAA9 | `42 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | EAAD | EAAD |
| EAAD | `52 88 0a ff ad ea` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $0A, $FF | EAB3 | EAAD |
| EAB3 | `03 a2 9e` | regola senza argomenti $9EA2 (vedere rules.json); arg. $FF, $FF | terminale | EAB6 |
| EAB6 | `0f` | cede con costo 1 | EAB7 | — |
| EAB7 | `44 0b 1e 32 ff` | accoda ordine a un attore 30 (go to furiously); arg. $32, $FF; target_actor=11 | EABC | — |
| EABC | `52 83 fb 32 bc ea` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $32 | EAC2 | EABC |
| EAC2 | `42 0d 6d ff` | azione con argomenti 13 (climb out of); arg. $6D, $FF | EAC6 | EAC6 |
| EAC6 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EAC8 | EAC8 |
| EAC8 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EACA | EACA |
| EACA | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EACC | EACC |
| EACC | `45 00 c7 70` | parla a un destinatario; target_actor=0; I am afraid that Basil has eluded us Holmes. | EAD0 | — |
| EAD0 | `82 81 fb 2a 95 ea` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $2A | EA95 | EAD6 |
| EAD6 | `82 81 fb 2b 95 ea` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $2B | EA95 | EADC |
| EADC | `82 83 fb 37 d0 ea` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $37 | EAD0 | EAE2 |
| EAE2 | `02 86 00 1e` | azione con argomenti $EB8B (vedere rules.json); arg. $00, $1E | EAE6 | EAE6 |
| EAE6 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | EAE8 | EAE8 |
| EAE8 | `41 04` | azione senza argomenti 4 (west go); arg. $FF, $FF | EAEA | EAEA |
| EAEA | `07 a4 eb ff 0a` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $0A | EAEF | EAEF |
| EAEF | `42 80 fb 0b` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0B | EAF3 | EAF3 |
| EAF3 | `0e 98 ea` | salto assoluto; jump=EA98 | EA98 | — |

## basil phipps — ID 6

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EE2B | `59 04 2b ee` | consuma segnale del mittente; sender=4 | EE2F | EE2B |
| EE2F | `42 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | EE33 | EE33 |
| EE33 | `12 88 17 ff 33 ee` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $17, $FF | EE39 | EE33 |
| EE39 | `02 80 fb 3d` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $3D | EE3D | EE3D |
| EE3D | `03 b3 ef` | regola senza argomenti $EFB3 (vedere rules.json); arg. $FF, $FF | EE40 | EE40 |
| EE40 | `52 88 07 ff 40 ee` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $07, $FF | EE46 | EE40 |
| EE46 | `03 c7 ef` | regola senza argomenti $EFC7 (vedere rules.json); arg. $FF, $FF | EE49 | EE49 |
| EE49 | `41 0a` | azione senza argomenti 10 (down go); arg. $FF, $FF | EE4B | EE4B |
| EE4B | `42 87 13 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $13, $FF | EE4F | EE4F |
| EE4F | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EE51 | EE51 |
| EE51 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EE53 | EE53 |
| EE53 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EE55 | EE55 |
| EE55 | `41 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EE57 | EE57 |
| EE57 | `47 e1 eb 17 ff` | regola con argomenti $EBE1 (vedere rules.json); arg. $17, $FF | EE5C | EE5C |
| EE5C | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EE5E | EE5E |
| EE5E | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EE60 | EE60 |
| EE60 | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EE62 | EE62 |
| EE62 | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EE64 | EE64 |
| EE64 | `41 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EE66 | EE66 |
| EE66 | `47 a4 eb ff 20` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $20 | EE6B | EE6B |
| EE6B | `42 85 5b ff` | azione con argomenti $F203 (vedere rules.json); arg. $5B, $FF | EE6F | EE6F |
| EE6F | `42 87 5b ff` | azione con argomenti $ED28 (vedere rules.json); arg. $5B, $FF | EE73 | EE73 |
| EE73 | `42 84 5b ff` | azione con argomenti $F210 (vedere rules.json); arg. $5B, $FF | EE77 | EE77 |
| EE77 | `12 88 0d ff 77 ee` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $0D, $FF | EE7D | EE77 |
| EE7D | `82 83 00 20 95 ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $00, $20 | EE95 | EE83 |
| EE83 | `82 83 00 66 95 ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $00, $66 | EE95 | EE89 |
| EE89 | `82 83 01 66 95 ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $01, $66 | EE95 | EE8F |
| EE8F | `12 83 01 20 98 ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $01, $20 | EE95 | EE98 |
| EE95 | `03 9c ef` | regola senza argomenti $EF9C (scena di Basil osservato presso casa sua); arg. $FF, $FF | EE98 | EE98 |
| EE98 | `12 88 16 ff 98 ee` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $16, $FF | EE9E | EE98 |
| EE9E | `02 80 fb 23` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $23 | EEA2 | EEA2 |
| EEA2 | `02 85 4f ff` | azione con argomenti $F203 (vedere rules.json); arg. $4F, $FF | EEA6 | EEA6 |
| EEA6 | `02 24 4f ff` | azione con argomenti 36 (open); arg. $4F, $FF | EEAA | EEAA |
| EEAA | `07 2f e5 37 14` | regola con argomenti $E52F (crea contatore privato base + casuale(ampiezza)); arg. $37, $14 | EEAF | EEAF |
| EEAF | `82 81 fb 00 96 ef` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | EF96 | EEB5 |
| EEB5 | `0f` | cede con costo 1 | EEB6 | — |
| EEB6 | `83 7a e5 af ee` | regola senza argomenti $E57A (decrementa contatore; fallisce quando raggiunge zero); arg. $FF, $FF | EEAF | EEBB |
| EEBB | `03 b3 ef` | regola senza argomenti $EFB3 (vedere rules.json); arg. $FF, $FF | EEBE | EEBE |
| EEBE | `47 be dd 28 ff` | regola con argomenti $DDBE (vedere rules.json); arg. $28, $FF | EEC3 | EEC3 |
| EEC3 | `03 c7 ef` | regola senza argomenti $EFC7 (vedere rules.json); arg. $FF, $FF | EEC6 | EEC6 |
| EEC6 | `12 83 53 26 da ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $53, $26 | EECC | EEDA |
| EECC | `12 83 51 27 da ee` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $51, $27 | EED2 | EEDA |
| EED2 | `02 80 51 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $51, $00 | EED6 | EED6 |
| EED6 | `02 80 53 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $53, $00 | EEDA | EEDA |
| EEDA | `0f` | cede con costo 1 | EEDB | — |
| EEDB | `03 c7 ef` | regola senza argomenti $EFC7 (vedere rules.json); arg. $FF, $FF | EEDE | EEDE |
| EEDE | `12 88 09 ff da ee` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $09, $FF | EEE4 | EEDA |
| EEE4 | `07 be dd 32 ff` | regola con argomenti $DDBE (vedere rules.json); arg. $32, $FF | EEE9 | EEE9 |
| EEE9 | `82 83 00 20 01 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $00, $20 | EF01 | EEEF |
| EEEF | `82 83 00 66 01 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $00, $66 | EF01 | EEF5 |
| EEF5 | `82 83 01 66 01 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $01, $66 | EF01 | EEFB |
| EEFB | `12 83 01 20 09 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $01, $20 | EF01 | EF09 |
| EF01 | `03 ac ef` | regola senza argomenti $EFAC (vedere rules.json); arg. $FF, $FF | EF04 | EF04 |
| EF04 | `07 be dd 0f ff` | regola con argomenti $DDBE (vedere rules.json); arg. $0F, $FF | EF09 | EF09 |
| EF09 | `03 c7 ef` | regola senza argomenti $EFC7 (vedere rules.json); arg. $FF, $FF | EF0C | EF0C |
| EF0C | `47 f6 f1 55 ff` | regola con argomenti $F1F6 (vedere rules.json); arg. $55, $FF | EF11 | EF11 |
| EF11 | `02 80 fb 21` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $21 | EF15 | EF15 |
| EF15 | `42 85 5b ff` | azione con argomenti $F203 (vedere rules.json); arg. $5B, $FF | EF19 | EF19 |
| EF19 | `42 87 5b ff` | azione con argomenti $ED28 (vedere rules.json); arg. $5B, $FF | EF1D | EF1D |
| EF1D | `42 84 5b ff` | azione con argomenti $F210 (vedere rules.json); arg. $5B, $FF | EF21 | EF21 |
| EF21 | `43 72 eb` | regola senza argomenti $EB72 (vedere rules.json); arg. $FF, $FF | EF24 | EF24 |
| EF24 | `41 02` | azione senza argomenti 2 (south go); arg. $FF, $FF | EF26 | EF26 |
| EF26 | `41 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | EF28 | EF28 |
| EF28 | `08 68` | invia segnale; target_actor=104 | EF2A | — |
| EF2A | `42 80 fb 67` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $67 | EF2E | EF2E |
| EF2E | `12 88 0f ff 2e ef` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $0F, $FF | EF34 | EF2E |
| EF34 | `07 2f e5 10 ff` | regola con argomenti $E52F (crea contatore privato base + casuale(ampiezza)); arg. $10, $FF | EF39 | EF39 |
| EF39 | `82 83 00 67 47 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $00, $67 | EF47 | EF3F |
| EF3F | `0f` | cede con costo 1 | EF40 | — |
| EF40 | `93 7a e5 39 ef 8c ef` | regola senza argomenti $E57A (decrementa contatore; fallisce quando raggiunge zero); arg. $FF, $FF | EF39 | EF8C |
| EF47 | `06 73 75` | stampa testo; As you enter ⟦nome referente $A036⟧ whips his horses into action and speeds off down the road.  | EF4A | — |
| EF4A | `02 80 fb 32` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $32 | EF4E | EF4E |
| EF4E | `12 88 10 ff 4e ef` | azione con argomenti $F1D6 (verifica ora su 24 ore (non minuti/giorno)); arg. $10, $FF | EF54 | EF4E |
| EF54 | `07 be dd 30 ff` | regola con argomenti $DDBE (vedere rules.json); arg. $30, $FF | EF59 | EF59 |
| EF59 | `01 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EF5B | EF5B |
| EF5B | `01 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EF5D | EF5D |
| EF5D | `01 01` | azione senza argomenti 1 (north go); arg. $FF, $FF | EF5F | EF5F |
| EF5F | `11 0c 5f ef` | azione senza argomenti 12 (climb into); arg. $FF, $FF | EF63 | EF5F |
| EF63 | `12 83 fb 17 63 ef` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $17 | EF69 | EF63 |
| EF69 | `01 0d` | azione senza argomenti 13 (climb out of); arg. $FF, $FF | EF6B | EF6B |
| EF6B | `01 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EF6D | EF6D |
| EF6D | `01 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EF6F | EF6F |
| EF6F | `01 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EF71 | EF71 |
| EF71 | `01 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EF73 | EF73 |
| EF73 | `01 08` | azione senza argomenti 8 (southwest go); arg. $FF, $FF | EF75 | EF75 |
| EF75 | `07 be dd 05 ff` | regola con argomenti $DDBE (vedere rules.json); arg. $05, $FF | EF7A | EF7A |
| EF7A | `07 a4 eb ff 1c` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $1C | EF7F | EF7F |
| EF7F | `01 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | EF81 | EF81 |
| EF81 | `01 03` | azione senza argomenti 3 (east go); arg. $FF, $FF | EF83 | EF83 |
| EF83 | `12 81 fb 00 8c ef` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $00 | EF89 | EF8C |
| EF89 | `03 48 9e` | regola senza argomenti $9E48 (vedere rules.json); arg. $FF, $FF | terminale | EF8C |
| EF8C | `02 80 fb 00` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $00 | EF90 | EF90 |
| EF90 | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | EF93 | EF93 |
| EF93 | `0e 90 ef` | salto assoluto; jump=EF90 | EF90 | — |
| EF96 | `03 88 e5` | regola senza argomenti $E588 (elimina contatore privato); arg. $FF, $FF | EF99 | EF99 |
| EF99 | `03 ca df` | regola senza argomenti $DFCA (scena terminale: fine partita); arg. $FF, $FF | terminale | EF9C |

## Sottosequenza della regola $E79A

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| E79C | `03 a8 e5` | regola senza argomenti $E5A8 (attesa di costo 1); arg. $FF, $FF | E79F | E79F |
| E79F | `12 83 fb 08 b2 e7` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $08 | E7A5 | E7B2 |
| E7A5 | `17 e2 e7 19 ff b2 e7` | regola con argomenti $E7E2 (verifica possesso percepibile (classe A)); arg. $19, $FF | E7AC | E7B2 |
| E7AC | `83 7a e5 9c e7` | regola senza argomenti $E57A (decrementa contatore; fallisce quando raggiunge zero); arg. $FF, $FF | E79C | E7B1 |
| E7B1 | `0b` | ritorna con successo | E7B2 | — |
| E7B2 | `03 88 e5` | regola senza argomenti $E588 (elimina contatore privato); arg. $FF, $FF | E7B5 | E7B5 |
| E7B5 | `0a` | ritorna con fallimento | E7B6 | — |

## Sottosequenza della regola $DD52

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| DD54 | `17 61 dd fd ff 60 dd` | regola con argomenti $DD61 (trova direzione dell’uscita verso la locazione); arg. $FD, $FF | DD5B | DD60 |
| DD5B | `11 fd 60 dd` | azione senza argomenti 253 (azione interna); arg. $FF, $FF | DD5F | DD60 |
| DD5F | `0b` | ritorna con successo | DD60 | — |
| DD60 | `0a` | ritorna con fallimento | DD61 | — |

## Sottosequenza della regola $EB72

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EB74 | `47 a4 eb ff 12` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $12 | EB79 | EB79 |
| EB79 | `41 05` | azione senza argomenti 5 (azione interna); arg. $FF, $FF | EB7B | EB7B |
| EB7B | `41 05` | azione senza argomenti 5 (azione interna); arg. $FF, $FF | EB7D | EB7D |
| EB7D | `41 05` | azione senza argomenti 5 (azione interna); arg. $FF, $FF | EB7F | EB7F |
| EB7F | `41 05` | azione senza argomenti 5 (azione interna); arg. $FF, $FF | EB81 | EB81 |
| EB81 | `47 e1 eb 36 ff` | regola con argomenti $EBE1 (vedere rules.json); arg. $36, $FF | EB86 | EB86 |
| EB86 | `42 80 fb 35` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $35 | EB8A | EB8A |
| EB8A | `0b` | ritorna con successo | EB8B | — |

## Sottosequenza della regola $EB8B

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EB8D | `c2 83 fb fc 9a eb` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $FC | EB9A | EB93 |
| EB93 | `42 15 fd ff` | azione con argomenti 21 (azione interna); arg. $FD, $FF | EB97 | EB97 |
| EB97 | `0e 8d eb` | salto assoluto; jump=EB8D | EB8D | — |
| EB9A | `0b` | ritorna con successo | EB9B | — |

## Sottosequenza della regola $EB9B

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EB9D | `41 fd` | azione senza argomenti 253 (azione interna); arg. $FF, $FF | EB9F | EB9F |
| EB9F | `42 13 fc ff` | azione con argomenti 19 (azione interna); arg. $FC, $FF | EBA3 | EBA3 |
| EBA3 | `0b` | ritorna con successo | EBA4 | — |

## Sottosequenza della regola $EB47

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EB49 | `42 87 44 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $44, $FF | EB4D | EB4D |
| EB4D | `42 87 45 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $45, $FF | EB51 | EB51 |
| EB51 | `42 87 31 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $31, $FF | EB55 | EB55 |
| EB55 | `42 87 32 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $32, $FF | EB59 | EB59 |
| EB59 | `42 87 32 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $32, $FF | EB5D | EB5D |
| EB5D | `42 87 31 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $31, $FF | EB61 | EB61 |
| EB61 | `41 09` | azione senza argomenti 9 (azione interna); arg. $FF, $FF | EB63 | EB63 |
| EB63 | `42 87 46 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $46, $FF | EB67 | EB67 |
| EB67 | `42 87 46 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $46, $FF | EB6B | EB6B |
| EB6B | `41 0a` | azione senza argomenti 10 (azione interna); arg. $FF, $FF | EB6D | EB6D |
| EB6D | `42 87 13 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $13, $FF | EB71 | EB71 |
| EB71 | `0b` | ritorna con successo | EB72 | — |

## Sottosequenza della regola $ED17

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| ED19 | `41 02` | azione senza argomenti 2 (azione interna); arg. $FF, $FF | ED1B | ED1B |
| ED1B | `42 87 13 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $13, $FF | ED1F | ED1F |
| ED1F | `42 87 45 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $45, $FF | ED23 | ED23 |
| ED23 | `42 87 44 ff` | azione con argomenti $ED28 (vedere rules.json); arg. $44, $FF | ED27 | ED27 |
| ED27 | `0b` | ritorna con successo | ED28 | — |

## Sottosequenza della regola $ED28

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| ED2A | `42 24 fd ff` | azione con argomenti 36 (azione interna); arg. $FD, $FF | ED2E | ED2E |
| ED2E | `52 1c fd ff 2a ed` | azione con argomenti 28 (azione interna); arg. $FD, $FF | ED34 | ED2A |
| ED34 | `42 0e fd ff` | azione con argomenti 14 (azione interna); arg. $FD, $FF | ED38 | ED38 |
| ED38 | `0b` | ritorna con successo | ED39 | — |

## Sottosequenza della regola $EB28

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EB2A | `41 01` | azione senza argomenti 1 (azione interna); arg. $FF, $FF | EB2C | EB2C |
| EB2C | `41 01` | azione senza argomenti 1 (azione interna); arg. $FF, $FF | EB2E | EB2E |
| EB2E | `47 e1 eb 17 ff` | regola con argomenti $EBE1 (vedere rules.json); arg. $17, $FF | EB33 | EB33 |
| EB33 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | EB35 | EB35 |
| EB35 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | EB37 | EB37 |
| EB37 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | EB39 | EB39 |
| EB39 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | EB3B | EB3B |
| EB3B | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | EB3D | EB3D |
| EB3D | `47 a4 eb ff 0a` | regola con argomenti $EBA4 (vedere rules.json); arg. $FF, $0A | EB42 | EB42 |
| EB42 | `42 80 fb 0b` | azione con argomenti $E497 (sposta entità alla locazione indicata, staccandola dal genitore); arg. $FB, $0B | EB46 | EB46 |
| EB46 | `0b` | ritorna con successo | EB47 | — |

## Sottosequenza della regola $EBA4

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EBA6 | `51 1f a6 eb` | azione senza argomenti 31 (azione interna); arg. $FF, $FF | EBAA | EBA6 |
| EBAA | `47 d5 eb fd ff` | regola con argomenti $EBD5 (vedere rules.json); arg. $FD, $FF | EBAF | EBAF |
| EBAF | `c2 82 fa ff c0 eb` | azione con argomenti $E5FD (confronta le radici del contenimento); arg. $FA, $FF | EBC0 | EBB5 |
| EBB5 | `52 0c fd ff aa eb` | azione con argomenti 12 (azione interna); arg. $FD, $FF | EBBB | EBAA |
| EBBB | `47 d5 eb fd ff` | regola con argomenti $EBD5 (vedere rules.json); arg. $FD, $FF | EBC0 | EBC0 |
| EBC0 | `44 fa 1d fc ff` | accoda ordine a un attore 29 (azione interna); arg. $FC, $FF; target_actor=250 | EBC5 | — |
| EBC5 | `52 83 fb fc c5 eb` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $FC | EBCB | EBC5 |
| EBCB | `47 06 e5 fb fa` | regola con argomenti $E506 (vedere rules.json); arg. $FB, $FA | EBD0 | EBD0 |
| EBD0 | `42 0d fd ff` | azione con argomenti 13 (azione interna); arg. $FD, $FF | EBD4 | EBD4 |
| EBD4 | `0b` | ritorna con successo | EBD5 | — |

## Sottosequenza della regola $ECF6

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| ECF8 | `41 02` | azione senza argomenti 2 (azione interna); arg. $FF, $FF | ECFA | ECFA |
| ECFA | `41 04` | azione senza argomenti 4 (azione interna); arg. $FF, $FF | ECFC | ECFC |
| ECFC | `0e 01 ed` | salto assoluto; jump=ED01 | ED01 | — |
| ED01 | `41 02` | azione senza argomenti 2 (azione interna); arg. $FF, $FF | ED03 | ED03 |
| ED03 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | ED05 | ED05 |
| ED05 | `41 02` | azione senza argomenti 2 (azione interna); arg. $FF, $FF | ED07 | ED07 |
| ED07 | `41 08` | azione senza argomenti 8 (azione interna); arg. $FF, $FF | ED09 | ED09 |
| ED09 | `41 03` | azione senza argomenti 3 (azione interna); arg. $FF, $FF | ED0B | ED0B |
| ED0B | `0b` | ritorna con successo | ED0C | — |

## Sottosequenza della regola $ED0C

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| ED0E | `41 04` | azione senza argomenti 4 (azione interna); arg. $FF, $FF | ED10 | ED10 |
| ED10 | `41 01` | azione senza argomenti 1 (azione interna); arg. $FF, $FF | ED12 | ED12 |
| ED12 | `41 01` | azione senza argomenti 1 (azione interna); arg. $FF, $FF | ED14 | ED14 |
| ED14 | `41 05` | azione senza argomenti 5 (azione interna); arg. $FF, $FF | ED16 | ED16 |
| ED16 | `0b` | ritorna con successo | ED17 | — |

## Sottosequenza della regola $EBE1

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| EBE3 | `c2 81 fb 2a ef eb` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $2A | EBEF | EBE9 |
| EBE9 | `52 81 fb 2b e3 eb` | azione con argomenti $E5D8 (confronta prima locazione di due entità distinte); arg. $FB, $2B | EBEF | EBE3 |
| EBEF | `41 0c` | azione senza argomenti 12 (azione interna); arg. $FF, $FF | EBF1 | EBF1 |
| EBF1 | `52 83 fb fd f1 eb` | azione con argomenti $E5AD (verifica prima locazione dell’entità); arg. $FB, $FD | EBF7 | EBF1 |
| EBF7 | `41 0d` | azione senza argomenti 13 (azione interna); arg. $FF, $FF | EBF9 | EBF9 |
| EBF9 | `0b` | ritorna con successo | EBFA | — |

## Sottosequenza della regola $E506

| Indirizzo | Byte | Operazione | Succ. | Fall. |
|---|---|---|---|---|
| E508 | `c7 18 e5 fd fc 10 e5` | regola con argomenti $E518 (vedere rules.json); arg. $FD, $FC | E510 | E50F |
| E50F | `0a` | ritorna con fallimento | E510 | — |
| E510 | `57 70 e3 fd fc 0f e5` | regola con argomenti $E370 (vedere rules.json); arg. $FD, $FC | E517 | E50F |
| E517 | `0b` | ritorna con successo | E518 | — |

