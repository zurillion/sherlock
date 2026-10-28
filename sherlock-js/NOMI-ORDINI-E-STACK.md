# Nomi negli ordini NPC e provenienza di 5D1F

## Algoritmo ricostruito

5D1F non è un attributo permanente di un personaggio: appartiene allo
spazio temporaneo riutilizzato da vari chiamanti. C388 conserva registri
e righe del font a indirizzi relativi al proprio ingresso. Se il frame
è 5D2A, C39D scrive in 5D1F la riga non ancora allineata del glifo;
l’ultimo passaggio vi lascia la riga numero sette. Non è una costante zero:
un carattere con un tratto nell’ultima riga lascia un valore diverso.

Con altri frame il medesimo byte può invece contenere B o la parte alta
dell’indirizzo video. Anche il decoder A969/A97C può sovrascriverlo.
Estendere semplicemente il limite numerico del renderer conserverebbe
valori obsoleti: una prova naturale ha effettivamente rilevato questo
problema entrando nella fumeria alle 14:17.

## Il chiamante pertinente

Nel percorso naturale osservato, Lestrade ordina al cocchiere di andare
in Parliament Street a tick 964, martedì 00:03. CE10–CE13 stampa il testo
682A dopo aver registrato la richiesta. Il testo chiama 6804, che chiama
67F7: il prefisso del nome dell’attore passa per A751/A7C5/D3E8 e viene
scaricato al delimitatore che precede il sostantivo finale.

La catena di ritorni nativa mostra l’ingresso pubblico del testo a 5D78
e l’ingresso C388 del prefisso «Inspector» a 5D2A. Il sostantivo finale
«Lestrade» viene scaricato dopo il ritorno dal renderer del nome, con un
altro frame. Il prefisso non ha il frame 5D1A già ricostruito per TELL.
I dettagli sono in `results/upper-stack/order-call-chain.json` e sono
riproducibili con `python3 tools/probe-order-call-chain.py`.

Il JavaScript applica il calcolo del glifo al prefisso dei nomi propri
composti negli ordini NPC. Gli altri descrittori e le stampe prive di un
contratto verificato revocano la proprietà del nuovo byte. Le scene
mantengono il loro contratto precedente sui byte bassi: non ottengono
automaticamente la proprietà alta perché ne conosciamo un frame parziale.
Anche gli errori lessicali e le ispezioni non ricostruite revocano il residuo.

Il dato calcolato viene salvato con la partita; il contesto temporaneo del
renderer è ripristinato alla fine della stampa. Un vecchio LOAD privo del
campo non riceve il valore iniziale o quello della traccia. Nessuna nuova
routine CPU viene interpretata dal motore: il tracciato resta una prova offline.

## Prove

La suite completa passa **722 test**. I nuovi controlli comprendono:

- 63 chiamate C388 native controllate: sette frame, tre caratteri e tre
  colonne. Comprendono un carattere con ultima riga non zero, per escludere
  una falsa implementazione che restituisca sempre zero.
- La storia naturale su 76 comandi, tutti gli attori attivi, fino a mercoledì
  01:40: a ogni comando ogni nuovo byte dichiarato noto deve corrispondere
  alla memoria originale. Le celle non possedute restano sconosciute.
- Invalidazione delle stampe senza contratto e nessun riempimento dei campi
  mancanti al LOAD. Il confronto esteso verifica inoltre ogni minuto live
  del WAIT dopo LOAD, record, entità, programmi e bitmap.

Il tracciato `natural-writers.json` osserva i cambiamenti di valore: non
registra le scritture che ripetono lo stesso valore. Non basta da solo a
provare l’ultimo scrittore assoluto. La chiamata C388 e la catena di ritorni
forniscono la prova diretta del percorso di stampa sopra descritto.

## Nuovo limite

`node tools/verify-witness-prefix.mjs` confronta ora **334 checkpoint,
0–333, fino a mercoledì 03:20**, con seed 1, tutti i 24 posti attore,
LOOK iniziale gratuito, grafica originale spenta dopo il boot, input
maiuscolo iniettato e MORE immediato. Confrontati 6.266 sorteggi e 13.438
letture nel prefisso, oltre allo stato e al futuro dopo LOAD.
Rapporto: `results/upper-stack-verification.json`.

Il confronto completo separato raggiunge il checkpoint 334, verso 03:30,
e si ferma su **5D1A** (durante il minuto 03:28). È una dipendenza nuova,
non un errore superato inserendo un valore catturato. Le celle 5D1A–5D1E
restano fuori dal nuovo contratto. Occorre trovare il loro scrittore e le
sovrascritture effettive prima di pubblicarle.

Il finale naturale 6A33 di giovedì 10:00 non è ancora certificato JS.
Restano cinque varianti terminali aperte: 6A33, 6ABD, 6AF3, 6B79 e 75D2;
sono già naturali 693A, 69BF, 6A26 e 759C.

## Mappa

Il nuovo dossier commentato riassela **221 istruzioni / 393 byte** del
payload. Comprende l’ingresso del testo, le chiamate annidate, il renderer
dei nomi, il glifo, il decoder alternativo e la stampa degli ordini NPC.
La classificazione documentata cresce di 92 byte unici; gli altri byte
annotati erano già classificati da fonti generali. Rimangono 3.411 byte
non analizzati. Queste misure non certificano l’equivalenza del gameplay.
