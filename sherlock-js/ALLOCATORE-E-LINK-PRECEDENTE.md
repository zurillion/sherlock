# Allocatore e link precedente al candidato

## Significato di A11A–A11B

La word non è il puntatore al record allocato né la testa corrente dei blocchi
liberi. Conserva **l’indirizzo del collegamento che porta al blocco scelto**:
9FE3 per la testa; in seguito, indirizzo del blocco precedente più due.
A151 scrive il collegamento a ogni nuovo candidato migliore o uguale.
IY viene avanzato al link corrente soltanto dopo questa scelta.

La scansione è best fit e l’ultimo blocco vince a parità di dimensione:

```text
richiesta = payload + 3
candidato = nessuno
link_precedente = indirizzo della testa
per ogni blocco libero:
    se abbastanza grande e non peggiore del candidato:
        candidato = blocco
        temporaneo = link_precedente
    link_precedente = indirizzo del link del blocco corrente
```

Anche un blocco troppo piccolo o peggiore avanza il link precedente per il
successivo. Per questo A11A non si deduce dall’indirizzo del candidato e
non si ricalcola dalla lista libera finale. La word rimane quella scelta
anche se il blocco viene consumato, successivamente liberato o fuso.
Una scansione senza alcun candidato non la azzera.

La traduzione best fit e il layout dei record esistevano già. Questo passo
collega il temporaneo ai punti effettivi della selezione in RecordArena,
lo espone agli ingressi casuali e lo conserva nei salvataggi. Non usa valori
catturati o byte iniziali come fallback. Il campo di un vecchio salvataggio
rimane sconosciuto finché una nuova allocazione non seleziona un candidato;
una semplice analisi preventiva non lo scrive.

## Taglio, liberazione e memoria residua

Un record ha tre byte di prefisso: dimensione totale in un byte, link in due,
poi payload. Un nodo libero conserva dimensione word e link word.
Il resto inferiore a quattro byte viene assorbito; altrimenti l’allocazione
si prende dalla coda, conservando il blocco libero all’inizio.
A1A0 azzera il link e il payload allocati. Il rilascio non cancella il payload.

A1AF libera una catena leggendo il successore prima che il rilascio del
record corrente ne sovrascriva il link. A1C7 reinserisce in ordine di indirizzo
e tenta le fusioni; A20C fonde soltanto blocchi esattamente adiacenti.
È conservato il quirk A1FD: se il primo tentativo non fonde, il secondo usa
l’inizio del nuovo blocco invece del suo link+2. Non è stato corretto come
si farebbe in un allocatore moderno.

Nessuna di queste liberazioni scrive A11A. L’esaurimento del pool rimane
il confine già dichiarato: le prove controllate si fermano al servizio C1D8,
prima della UI originale; non certificano il messaggio di memoria esaurita.
Le dimensioni di payload coperte sono quelle ammesse dal runtime ricostruito,
non l’overflow arbitrario di ADD A,3 con richieste fuori intervallo.

## Prove

- 14 layout controllati, più una sequenza di 140 allocazioni e rilasci:
  159 operazioni e 200 scritture di selezione, incluse quelle dello stesso
  valore. Coprono testa/non testa, candidati migliori e uguali, predecessori
  troppo piccoli, resti 0–4, lista vuota, esaurimento e catene da liberare.
  Si confrontano tutti i byte del pool, puntatori, testa libera e temporaneo;
  il seguito attraversa round trip JSON dopo ogni operazione.
- Sei sequenze naturali, 32 input e 97 checkpoint, con tutti i 24 posti attore:
  chiarimenti, errori, ordini a Watson, attese live e cab. A ogni checkpoint
  e a ogni ingresso di estrazione si confronta l’intera word A11A/A11B.
  Sono confrontati 302 sorteggi e 614 letture, mondo, fatti, arena completa,
  bitmap e futuro dopo LOAD.
- Vecchi salvataggi senza campo: nessun default a zero o alla testa; analisi
  preventiva pura e ricostruzione della proprietà tramite allocazione reale.

Protocollo naturale: seed 1, LOOK iniziale gratuito, grafica originale spenta
dopo il boot, input maiuscolo iniettato e MORE immediato. I layout e il valore
sentinella 4321 sono setup espliciti delle sole prove controllate; non vengono
iniettati nelle partite naturali. Nessun fixture è importato dal motore.
Suite completa: **797 test passati**. Riscontri: `results/allocation-link/checks.json`.

## Avanzamento del ramo witness

Il confronto naturale completo supera A11A e verifica 346 checkpoint, 0–345,
fino a **mercoledì 05:20**: otto checkpoint e 80 minuti oltre il precedente
limite. Ogni sorteggio/lettura, attore, entità, fatto, tutti i 752 byte
dell’arena, bitmap e futuro dopo LOAD rimangono confrontati.
Rapporto: `results/allocation-link-verification.json`, ripetibile con
`node tools/verify-witness-prefix.mjs`.

Il prossimo ingresso non ricostruito è **5D1B**, nello stack della stampa,
al checkpoint 346 diretto a mercoledì 05:30. Non dedurlo dal vicino 5D1A:
servono il suo chiamante e le sue scritture, comprese quelle dello stesso
valore. Il confronto di ricerca si arresta esplicitamente; non si riempie
il byte con un dato registrato. Nessuno dei cinque finali ancora aperti
è diventato certificato in questo passo.

## Nuove zone dell’atlante

| Intervallo inclusivo | Analisi |
| --- | --- |
| A11A–A11B | Dato mutabile: link precedente al candidato migliore |
| A11C–A15F | Scansione best fit, requisiti e parità |
| A160–A1AE | Resto, consumo del blocco, taglio e azzeramento |
| A1AF–A1C6 | Liberazione di una catena |
| A1C7–A20B | Reinserimento ordinato e due tentativi di fusione |
| A20C–A24C | Fusione per adiacenza |

Tutti i 307 byte erano grigi: ora due sono dati e 305 codice documentato.
Il dossier riassembla 176 istruzioni e confronta tutti i byte col payload.
Restano 2.853 byte sconosciuti e 473 parziali. Le parti circostanti non analizzate
rimangono grigie; questa misura non è una percentuale di gameplay equivalente.
