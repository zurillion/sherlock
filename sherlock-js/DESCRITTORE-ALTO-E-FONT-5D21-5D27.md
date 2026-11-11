# Descrittore alto e byte del font: $5D21 e $5D27

11 novembre 2026. Continuazione di [DESCRITTORE-E-SPAZIO-5D20-5D26.md](DESCRITTORE-E-SPAZIO-5D20-5D26.md).

## Provenienza naturale

Il giardiniere (attore 8) legge entrambi i byte al tick 3288, mercoledì
14:47. L'osservazione originale è stata prolungata fino a questa lettura:
non si è dedotta la provenienza dal byte vicino o dal valore osservato.

| Byte | Ultima scrittura originale | Significato |
|---|---|---|
| `$5D21` | `$C38A`, `PUSH DE`, frame `$5D26` | D, parte alta del descrittore effettivo `$5C0B`, durante la `n` di `plain` |
| `$5D27` | `$C3B8`, `PUSH AF`, frame `$5D32` | A, ultimo byte del glifo prima delle rotazioni, durante lo spazio successivo |

Entrambe le scritture sono di Holmes, tick 1653, martedì 11:32; il ritorno
include `$D65B`. I valori sono rispettivamente 92 e 0 in questa partita.
Il modello calcola `descriptor >>> 8` e `glyph[7]`: non assegna costanti.
A non è il codice del carattere salvato dal precedente `PUSH AF` a `$C388`;
F, trattato nel passo precedente, è un altro operando ancora.

La traccia contiene 3020 scritture su `$5D20–$5D27`, nessuna transizione
non classificata. È identica alla sequenza precedente: nessuna scrittura
aggiuntiva fra il vecchio arresto a 3195 e la nuova lettura a 3288.
Il rilevatore confronta la porzione contigua della lista RAM per accelerare
l'osservazione; continua a registrare separatamente PUSH/CALL anche quando
riscrivono lo stesso valore. L'uguaglianza completa delle 3020 scritture
è verificata dal test e dal report.

## Contratti funzionali in JavaScript

Il descrittore alto e il byte del font hanno proprietà indipendenti dai
precedenti `$5D20` e `$5D26`. Un vecchio SAVE privo di questi campi resta
ignoto finché una scrittura modellata li ricostruisce. LOAD conserva i
valori già derivati e il futuro casuale; nessuna RAM originale entra nel
motore JavaScript.

Il prefisso del nome di un passaggio, chiamato dal movimento ordinario,
abilita il descrittore alto al frame `$5D26`. Solo il suo effettivo spazio
separatore abilita il byte del font al frame `$5D32`. LOOK, nomi successivi,
caller remoti, contenitori, operazioni queued/isolated/relocate e clear
non proiettati non ereditano questi contratti. Wrap e MORE pendente
revocano la proprietà quando il relativo percorso non è ricostruito.

Un normale arrivo proprio preserva `$5D21`. Per `$5D27` si mantiene il
contratto conservativo: riga fresca, 36 colonne libere, buffer vuoto,
spacing zero, nome che entra e `counter + 2 < 15`. Non è una modifica della
paginazione originale: evita di affermare valori oltre i percorsi provati.
I rifiuti semplici della zona comandi hanno una prova separata.

## Verifiche e loro portata

Le ABI originali sono riutilizzate con SHA256, senza una nuova acquisizione
controllata: 1296 casi di glifo per indirizzo, 144 varianti del descrittore,
720 geometrie di passaggio (290 casi posseduti coincidenti per byte),
1512 arrivi e 138 errori. Dei 720 arrivi propri eleggibili, tutti preservano
21 ma 20 modificano 27 facendo wrap da una riga parziale. I 300 controlli
con riga fresca e contatore 0–14 preservano 27. Il nuovo test runtime di
Watson accetta 13 dei 15 contatori, secondo il budget conservativo; i
129 rifiuti semplici eleggibili preservano entrambi i byte.

La nuova acquisizione naturale conserva identici tutti i 511 checkpoint
precedenti e prolunga la continuazione Brown a 183 righe originali.
Il confronto certifica **520 checkpoint, 0–519, fino a mercoledì 16:10**:
8221 estrazioni, 17516 letture, 8223 estrazioni contando le due iniziali.
Confronta tutti i 24 attori, stato completo, 752 byte dell'arena, bitmap e
futuro dopo LOAD anche a ogni minuto. Lo stato iniziale del test dei
comandi è un SAVE prodotto esclusivamente dal JavaScript al checkpoint
325 e confrontato nuovamente con il modello finale.

Il successivo limite è **`$5D22`, tick 3377, mercoledì 16:16**. Il primo
checkpoint escluso, indice 520, è nell'originale alle 16:18 e contiene una
lettura del valore 5 da parte della cuoca (attore 9). La traccia dei writer
termina ancora a 3288: va estesa fino alla lettura successiva, senza
attribuirle automaticamente una precedente scrittura di 22.

La baseline del finale `$6A33` è stata ripetuta: 521 checkpoint fino a
giovedì 10:00, 10345 estrazioni e 22058 letture confrontate, 10347 estrazioni
con l'avvio, compresi pausa e blocco terminali. L'oracolo originale è
riutilizzato con hash. Il finale naturale `$6ABD` e gli altri rami aperti
restano da certificare; questa storia conserva viaggi falliti e la prova
Brown mancante.

La suite preesistente e il nuovo modulo sono eseguiti separatamente sullo
stesso runtime finale: 1891 più 8 test, **1899/1899 passati**, zero errori,
annullamenti o test saltati. Il log preliminare acquisito prima
che esistesse il file di provenienza non costituisce una prova positiva;
è conservato separatamente. Il report verifica i riepiloghi delle due
esecuzioni definitive e gli hash delle evidenze.

## Atlante aggiornato

Il listing riassemblato coincide con 395 istruzioni / 715 byte originali.
Approfondite queste zone già classificate:

- `$C388–$C3E3`: descrittore alto salvato e byte del font prima delle rotazioni.
- `$C316–$C387`, `$C2BA–$C305`: selezione glifo, passaggio di parametri e spazi.
- `$D60B–$D670`: descrizione del passaggio e caller del prefisso.
- `$CBC2–$CC0A`, `$C1FD–$C23F`: arrivi e canale degli errori.
- `$A815–$A82E`, `$A887–$A8B8`, `$D3D5–$D447`: descrittori e nomi con qualificatori.
- Workspace `$5D21` e `$5D27`: proprietà distinte e collegamenti ai writer.

**Zero nuovi byte sottratti al grigio**, nessuna variazione di classe:
39364 documentati, 428 parziali, 1808 ignoti su 41600. La classificazione
statica non certifica l'equivalenza completa del gameplay.

Evidenze: `results/passage-descriptor-high-21/`; report verificabile:
`results/passage-descriptor-high-21-verification.json`; generazione:
`python3 tools/report-passage-descriptor-high-21.py`.
