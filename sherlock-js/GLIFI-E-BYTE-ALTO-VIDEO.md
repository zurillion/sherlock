# 5D23: parte alta dell’indirizzo video salvato

30 ottobre 2026. È ricostruito il secondo operando che fermava l’estrazione
della cuoca alle 08:37. Il valore viene prodotto dalla proiezione funzionale
del renderer JavaScript, senza CPU Z80, immagine RAM o replay nel gioco.

## Ultimo writer naturale

Il percorso dell’ordine NPC passa da CE13 a 682A, poi ai testi 6804 e 67F7.
Il prefisso del nome proprio dell’attore attraversa A7C5/D3E8. In quel
chiamante, il renderer C388 entra con frame 5D2A.

L’ultimo store osservato a 5D23 è C398, tick 964, attore 2: Lestrade sta
impartendo l’ordine al cocchiere. Viene stampata la r finale di Inspector,
colonna 8, shift 2, indirizzo video iniziale 5027. C38B salva HL; C397 lo
ripristina dopo il calcolo del font e C398 salva nuovamente lo stesso HL.
Il byte H finisce a frame−7, cioè 5D23. L occupa la cella 5D22 già ricostruita.

Gli incrementi successivi di H servono a disegnare le otto righe del glifo;
non aggiornano quel residuo salvato. Non si usa quindi l’indirizzo della
scansione finale né il byte della riga del font.

```text
x = 2 + 7 * colonna
indirizzo = 0x5020 + floor(x / 8)
H salvato = indirizzo >> 8
```

Questa formula viene applicata nel chiamante verificato. Non viene assegnato
80 a 5D23 per ogni stampa o all’inizio della partita. Nei vecchi LOAD senza
5D23, il byte rimane sconosciuto anche se 5D22 è presente: la coppia non viene
completata per deduzione dal vicino o dal valore del payload.

## Ruoli alternativi

| Frame C388 | Ruolo di 5D23 nei salvataggi del glifo |
| --- | --- |
| 5D24 | A del chiamante, il carattere fornito |
| 5D26 | B del chiamante, per esempio lunghezza rimanente della parola |
| 5D28 | D del descrittore salvato |
| 5D2A | H dell’indirizzo video iniziale salvato |
| 5D2C | B del conteggio interno delle scansioni |
| 5D2E | A dell’ultima riga non allineata del font |
| 5D30/5D32 | I salvataggi interni non raggiungono la cella |

Esiste inoltre il ruolo del return link nella pulizia della riga. La vera
CALL C374 scrive C377 prima di entrare in C388. Se il frame d’ingresso del
glifo è 5D22, il byte alto C3 di quel link occupa 5D23. È distinto dal
registro H video ed è verificato eseguendo la CALL reale nell’originale.

Il modello pubblica il nuovo campo solo nei contesti con proprietà del
chiamante verificata. I percorsi sconosciuti, le scene generiche e gli errori
lo revocano. Se il ruolo è il B del chiamante ma il conteggio manca, il byte
resta sconosciuto. I contratti di 5D1D, 5D22 e degli altri salvataggi restano
indipendenti. Non sono introdotti valori per 5D1E o 5D24–5D27.

## Prove controllate e naturali

1.728 chiamate originali a C388 coprono otto frame, due valori del B del
chiamante, tre caratteri e tutte le 36 colonne. Distinguono sei ruoli e
includono gli otto shift. I caratteri spazio, T e q distinguono anche una
riga finale del font nonzero. I conteggi 3 e 7 impediscono di trattare il
B del chiamante come il contatore interno che termina a 1.

Altre 288 chiamate controllate eseguono C374 con la condizione dell’ultima
iterazione della pulizia: B=1, A=32, flag da AND 0, descrittore 5A20 e
coordinate fornite. Il chiamante controllato contiene tre word salvate e
un ritorno sintetico 0008. La CALL a C388 scrive invece il vero C377.
Sono confrontati il nuovo campo e gli altri byte pubblicati nel fixture.
Queste prove ABI sono distinte dalle partite naturali.

Il probe naturale segue 76 comandi, seed 1, tutti i 24 posti attore, LOOK
iniziale gratuito, grafica originale disattivata dopo il boot, input
maiuscolo iniettato e MORE immediato. Osserva PUSH/CALL ed EX(SP),HL,
comprese le scritture invariate. Non risultano transizioni di valore non
classificate. Anche 5D24 è osservato per distinguere i writer, ma non viene
introdotto nel runtime.

La cuoca, attore 9, legge 5D23=80 al tick 2918, mercoledì 08:37, dopo avere
letto 5D1D=1 nella stessa estrazione. È la seconda coppia di letture del
medesimo draw: la prima era stata scartata dal generatore. Il modello ora
confronta l’intera estrazione e la successiva prosecuzione con l’originale.
La precedente prova naturale di 5D1D richiede ora il superamento di 5D23
fino alla sua fine alle 08:50; non accetta più il vecchio arresto.

Il nuovo probe originale arriva alle 10:00. Il modello confronta tutti i
valori posseduti ai checkpoint precedenti, la lettura effettiva di H e la
persistenza dopo LOAD, ma si ferma prima di quel termine su A01D. Le 10:00
non sono dichiarate come traguardo del modello.

## Prefisso completo e prossimo limite

Il certificato passa da 365 a 368 checkpoint, da 0 a 367, fino a mercoledì
09:00. Confronta 7.059 estrazioni e 15.134 letture casuali, tutti gli attori,
argomenti e scadenze, entità, fatti, 752 byte di arena, bitmap esatte e
prosecuzione dopo LOAD, compresi i minuti di WAIT live. Il conteggio runtime
7.061 comprende anche le due estrazioni dell’avvio.

Il confronto completo di ricerca ora si ferma al checkpoint 368, diretto
alle 09:10, su A01D ancora sconosciuto. Non viene introdotto un valore preso
dalla traccia. I cinque testi terminali ancora privi di certificazione
naturale rimangono aperti: 6A33, 6ABD, 6AF3, 6B79 e 75D2.

Riproduzione:

```sh
node tools/verify-witness-prefix.mjs
node tools/compare-witness-research.mjs
```

Il primo scrive results/glyph-address-high/witness-prefix.json. Il secondo
rimane ricerca separata dalla regressione e mostra il nuovo limite A01D.
Il problema preesistente 5D0C nel diverso percorso del cab rimane nel backlog,
come descritto in results/dictionary-reference/unrelated-boundary.json.

## Atlante

Sono approfonditi 235 istruzioni e 419 byte, riassemblati contro il payload:
682A–682F, A59F–A5CC, A720–A770, A7C5–A7CF, A95B–A98F, C363–C37C,
C388–C3E3, CE10–CE17 e D3E8–D447. Aggiunta l’annotazione del workspace
5D23, mantenendo distinte le strutture dati del testo dal codice Z80.

Nessun nuovo byte grigio viene promosso: sono approfondimenti di zone già
classificate. Restano 38.466 byte documentati, 468 parziali e 2.666 sconosciuti
su 41.600 byte del payload. La copertura statica non misura l’equivalenza
dell’intera partita.

Verifica conclusiva 5D23: suite completa 1.155 test passati, 0 errori; 106 controlli mirati passati.
