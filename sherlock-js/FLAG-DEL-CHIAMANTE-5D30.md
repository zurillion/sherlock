# Il byte di stack $5D30 e i flag del chiamante

Il precedente confronto si fermava al checkpoint512, verso giovedì08:50:
la cuoca9 leggeva26 a5D30 nell’estrazione di indice15 del
riferimento. Non è una costante: il renderer riutilizza la stessa cella
per registri diversi, secondo la profondità della chiamata.

## Struttura ricostruita

`frame` è SP all’ingresso del rendererC388. Ogni PUSH salva due byte;
5D30 è qui il byte basso di una delle coppie salvate:

| Frame | Writer | Contenuto di5D30 |
|---|---|---|
| 5D32 | C388/PUSH AF | F del chiamante, dopo CP0D nell’emissione ordinaria |
| 5D34 | C389/PUSH BC | C del chiamante, soltanto se il contatore del chiamante è noto |
| 5D36 | C38A/PUSH DE | E del descrittore della parola |
| 5D38 | C38B/C398/PUSH HL | L dell’indirizzo video |
| 5D3A | C39C/C3B7/PUSH BC | C dello shift della scansione |
| 5D3C | C39D/C3B8/PUSH AF | F della scansione, dopo il percorso INC H/DEC C/INC C |

Per una colonna `c`, l’indirizzo è5020+floor((2+7×c)/8) e lo shift
è(2+7×c)&7. I flag ordinari derivano realmente da CP0D: «q» produce26,
«n» produce10. La pulizia di rigaC374 arriva invece dopo AND0 e salva
F=54 esadecimale (84 decimale). I flag della scansione hanno un’altra
provenienza: non vanno confusi con quelli del chiamante.

La CALL eseguita aC374 chiamaC388 e lascia il ritornoC377. Con frame5D30 il suo byte
basso77 rimane proprio a5D30. Le chiamate ABI dirette usano un ritorno
sintetico0008: non provano il return link di un chiamante reale.

## Motore autonomo e salvataggi

`RandomDisplay.glyphResidue` calcola i valori dalle operazioni di stampa,
dalla colonna, dal carattere e dal chiamante ricostruito. Non esegue codice
Z80 e non legge le tracce di ricerca. La proprietà del nuovo byte è separata
da quelle dei campi già ricostruiti; i byte5D2B–5D2F e5D31 restano ignoti.

Un chiamante non ricostruito, un BC mancante o un return link non noto
revocano la proprietà coinvolta. Anche il percorso del nome di stanza non
proiettato revoca5D30. Non c’è un reset generico a fine comando e non si
deduce il byte da quello adiacente. SAVE/LOAD conserva un valore posseduto;
un vecchio salvataggio senza questo campo resta esplicitamente incompleto
fino a una scrittura dimostrata. Non gli viene assegnato26 dal payload.

## ABI originali

Nuova acquisizione di4.284 chiamate originali:4.032 ingressiC388
(7 frame,2 descrittori,2 contatori,4 caratteri,36 colonne) e252 vere
CALLC374 (7 frame×36 colonne). Il byte iniziale èAA per distinguere
una scrittura dalla sua assenza. I descrittori5C0B/5123 distinguono E
variabile da una costante0B; «q»/«n» distinguono i flag variabili da26.

Inoltre la vera istruzione CP0D aC2C6 è eseguita separatamente su tutti
256 valori diA, per verificare i flag senza ricopiarli dalla formulaJavaScript.
I test confrontano anche gli altri campi posseduti presenti nel riferimento,
le revoche, gli oldSAVE e il futuro dopoLOAD. Le ABI hanno parametri
controllati: non dimostrano che tutti quei frame siano raggiungibili in
ogni partita naturale.

## Atlante

Approfondite362 istruzioni e691 byte riassemblati contro il payload:
C2BA–C305,C388–C3E3,C363–C37C,A360–A418,A59F–A5CC,A720–A770,A7BA–A7CF,
D3E8–D447,A95B–A98F,CE10–CE17 e il testo682A–682F. La struttura dello
workspace5CEC–5D7F descrive ora5D30 separatamente, con ruoli e revoche.

Non sono nuovi byte grigi del payload: la copertura resta38.949 documentati,
428 parziali e2.223 sconosciuti su41.600. È copertura documentale, non una
misura dell’equivalenza del gameplay. Per vedere5D30 nella mappa scegliere
«Anche buffer e stack · da $5B00» e cercare l’indirizzo.

## Riproduzione

```sh
python3 tools/probe-glyph-caller-flags-30-abi.py
python3 tools/probe-glyph-caller-flags-30.py
node tools/verify-glyph-caller-flags-30-natural.mjs
node --test test/glyph-caller-flags-30.test.mjs
node tools/verify-glyph-caller-flags-30-witness.mjs
python3 tools/build-glyph-caller-flags-30-listing.py
python3 tools/build-memory-map.py
```

Acquisizioni e confronti sono strumenti offline; il motore giocabile non
importa i riferimenti originali. I risultati naturali e i limiti del
certificato sono riportati sotto e nel rapporto JSON allegato.

## Certificato naturale completo

Il confronto separato dello stato completo è passato per **521 checkpoint
0–520**, fino a **giovedì10:00**, compreso il finale **6A33**. Confronta
**10.345 estrazioni e22.058 letture**; le10.347 estrazioni runtime includono
le due dell’avvio. Sono inclusi tutti24 i posti attore, entità, fatti,
programmi, arena752 byte, bitmap, la ripresa dopoLOAD e il suo futuro a
ogni minuto, la pausa sul testo terminale e il congelamento dopo il finale.

L’oracolo lungo `results/final-solution/witness-native-reference.json.gz`
è riutilizzato, conSHA256 nel manifest: non è una nuova acquisizione del
finale originale. Il profilo è seed1/all24/LOOK iniziale gratuito/grafica
nativa disabilitata dopo l’avvio/input maiuscolo iniettato/MORE immediato.
È la prima certificazione naturale di6A33; in questa storia non rimane un
altro ingresso sconosciuto prima del finale. Non certifica tutti i seed,
tutti gli input, le altre impostazioni grafiche o tutti i finali.

Il prossimo lavoro riguarda i quattro finali naturali ancora aperti:
6ABD,6AF3,6B79,75D2. Restano separati i percorsi del cab della polizia5D0C,
PRINT/MORE,TAKE TO e il dialogoWatsonKilledYou (7drawJS/10nativo).

## Provenienza naturale: cosa è osservato

Una nuova esecuzione originale percorre l’intera storia dall’avvio fino a
Thu08:50 senza modificare mondo o attori. L’osservatore istruzione per
istruzione è attivo soltanto fraThu08:30 e08:50: conta anche PUSH/CALL
ed EX(SP),HL che riscrivono un valore identico. In questa finestra non
ci sono scritture di5D30, né cambiamenti non classificati dei due byte
osservati30/31. La cuoca legge26 al tick4365, **Thu08:44**. Non si attribuisce
un ultimo store a una finestra che non lo ha osservato.

Una prova naturale precedente, esplicitamente riutilizzata e identificata
conSHA, documenta il medesimo frame5D32 nel nome «Parliament»: tick964,
Holmes0, carattere finale«t», descrittore5C0B, colonna24. Registrava C398 e
5D2A, non uno store diretto5D30. Il codiceC2C6/C2EE/C388 e la nuova ABI
indipendente diCP0D dimostrano che quella chiamata salva anche F=26 a5D30.
Questo collegamento non è presentato come una nuova osservazione diretta
dell’ultimo store5D30 sull’intera partita. Il certificato521 confronta
separatamente la lettura effettiva e tutto lo stato del gioco.

## Esito delle verifiche

86 test mirati iniziali passati; dopo l’aggiunta del riferimentoCP completo,
14 test del chiamante e dell’atlante passati. La suite integrale esegue1810
test:1809 passano; un worker aveva già letto il vecchio ABI privo di
`cp_flags` quando il nuovo test è stato aggiunto durante l’esecuzione.
Quel controllo ampliato passa con l’asset definitivo nel rerun dei14 test.
Sono1810 test distinti verificati senza errori residui; non si presenta il
risultato come una seconda esecuzione integrale1810/0. I log sono separati.

La nuova traccia ha77 checkpoint di comando:4 con5D30 posseduto e73
esplicitamente ignoti, tutti confrontati senza normalizzazione. SAVE/LOAD
dopo l’interruzione conserva il campo. Questo confronto di proprietà e
lettura è distinto dal certificato completo dei521 checkpoint.
