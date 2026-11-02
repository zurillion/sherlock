# `$5D23`: il registro B del chiamante durante la stampa del passaggio

Questo approfondimento risolve il limite che arrestava la continuazione del caso
Brown mercoledì alle 08:45. Il motore rimane JavaScript autonomo: le esecuzioni
originali descritte qui sono prove offline, non un backend della pagina.

## Il writer naturale

Dal tick 1649, martedì 11:28, fino alla lettura del giardiniere 8 al tick 2926,
mercoledì 08:45, sono state osservate **554 scritture su `$5D22–$5D23`**, 277 per ciascun byte,
comprese quelle che riscrivono lo stesso valore. Non ci sono transizioni non classificate.
L'ultima scrittura di `$5D23` è **`$C389: PUSH BC`**, durante la stampa della
`n` di `plain` nel nome della porta, Holmes 0, tick 1653, martedì 11:32.

L'ingresso di `$C388` ha SP=`$5D26`; prima del PUSH BC SP è `$5D24` e
BC=`$0105`. Il byte alto salvato a `$5D23` è dunque **B del chiamante**.
Il return `$D65B` collega il glifo alla descrizione dei passaggi in `$D60B`.
Non è H della posizione video e non è B del ciclo interno del font.

## L'algoritmo che genera il valore

`$A9DF–$AA13` scarica la parola dal buffer: `$A9F5` assegna a B la lunghezza
rimanente e `$AA01` la decrementa con DJNZ. Il renderer preserva il registro
attraverso ogni carattere. Per `plain` riceve quindi **5, 4, 3, 2, 1**.
JavaScript usa la lunghezza della parola ancora da emettere, carattere per
carattere; non assegna un 1 fisso alla cella.

L'indirizzo fisico cambia significato con la profondità del chiamante:

| SP all'ingresso di C388 | Contenuto di `$5D23` |
| --- | --- |
| `$5D24` | A del chiamante |
| `$5D26` | B del chiamante, qui il conteggio della parola |
| `$5D28` | D del descrittore |
| `$5D2A` | H dell'indirizzo video |
| `$5D2C` | B della scansione del font |
| `$5D2E` | A grezzo del font |

Sono riutilizzate con hash **1.296 prove ABI originali** dei sei ruoli. I
conteggi 3 e 7 distinguono B del chiamante dal B interno, il cui ultimo
salvataggio prima di DJNZ è 1. Questo è distinto dal precedente dossier sul
ruolo H nello stesso indirizzo: [GLIFI-E-BYTE-ALTO-VIDEO.md](GLIFI-E-BYTE-ALTO-VIDEO.md).

## Quando il valore può essere conservato

Il nuovo contratto riguarda il prefisso del nome del passaggio dopo movimento,
giocatore nella stanza principale e nome grezzo verificato. LOOK usa una
profondità diversa; descrizioni remote e contenitori non ricevono questa
proprietà per analogia.

Le **720 configurazioni originali di D60B** combinano arrivo/LOOK, 36 colonne,
due stati coerenti degli spazi e cinque classi del sostantivo, mantenendo il
qualificatore della porta del setup. Il modello dichiara noti **290 valori**,
tutti coincidenti; gli altri 430 restano sconosciuti. Non è un certificato di
raggiungibilità naturale di tutte le configurazioni.

Il solo glifo non basta a descrivere lo scrolling. `$C316` salva registri
anche *sopra* il frame della sua chiamata a `$C374/C388`: `$C31E: PUSH HL`
può sovrascrivere `$5D23` con H del chiamante. Nel caso controllato con
sostantivo `$026E`, colonna 5 e spazio iniziale 0, l'originale termina con 80,
non con l'1 precedente. Il motore revoca la proprietà in questa situazione:
non installa 80 né conserva il vecchio B. La revoca copre anche il wrap del
sostantivo finale rimasto nel buffer e i successivi nomi/prose con chiamante
non ricostruito.

Sono state estese fino a `$5D23` anche le prove dei chiamanti successivi:

- **1.512 arrivi originali**, con 720 casi eleggibili: arrivo ordinario di una
  persona con nome proprio senza qualificatori attivi. Tutti preservano il
  marcatore. Nomi composti e chiamanti accodati/isolati o `relocate` restano fuori.
- **138 comandi originali completi**, con 129 rifiuti eleggibili: direzioni
  semplici e EXAMINE/CLOSELY EXAMINE di un riferimento semplice assente,
  giocatore fuori da contenitori e stanza senza prosa da cercare.

Le proprietà di `$5D1E`, `$5D1F`, `$5D22` e `$5D23` sono indipendenti. Un
messaggio che conserva `$5D23` non rende noti i vicini. SAVE/LOAD conserva il
valore derivato; se un vecchio salvataggio ne è privo, resta sconosciuto fino
a una nuova scrittura ricostruita.

## Prove riproducibili e mappa

Gli strumenti e le evidenze sono in `results/stack-23/`. Il test breve parte
da un SAVE prodotto dal solo JavaScript al checkpoint 325, verificato contro
l'intero mondo del replay finale, e ripercorre i 12 comandi fino al tick 1657.
Osserva l'effettivo conteggio 5→1 e controlla il futuro dopo SAVE/LOAD.
Non importa RAM originale e non corregge posizioni, programmi o prove.

La nuova acquisizione originale riprende il prompt completo Brown delle 11:36:
143 checkpoint si aggiungono ai primi 338. Tutti i **469 checkpoint precedenti
sono identici**. L'opzione offline `--checkpoint-tick 2928` aggiunge soltanto un
campione al vecchio confine, senza cambiare l'esecuzione.

La mappa approfondisce **`$A9DF–$AA13`, `$C316–$C387`, `$C388–$C3E3`,
`$D60B–$D670`, `$CBC2–$CC0A`, `$C1FD–$C23F`** e la voce di workspace `$5D23`.
Il dossier riassembla **287 istruzioni / 501 byte**, confrontati col payload.
**Nessun nuovo byte grigio**: restano 39.364 documentati, 428 parziali e
1.808 ignoti su 41.600. Classificazione del codice ed equivalenza del gameplay
rimangono misure distinte.

L'esito del confronto esteso, la suite finale e il prossimo confine sono
registrati in `results/stack-23-verification.json` e nello stato del progetto.
I log preliminari conservano gli errori incontrati durante lo sviluppo; non
sono usati come certificati positivi.
