# Il registro C salvato a 5D1C

Il byte 5D1C è stato ricostruito seguendo le scritture effettive, comprese
quelle che riscrivono lo stesso valore. Non viene ricavato dal byte vicino,
dal valore del payload, dal solo ultimo comando o da una sequenza registrata.

## Provenienza naturale

L’estrazione che incontrava il limite è di Smith, attore 9, a mercoledì
07:05, tick 2826. L’originale legge 7 da 5D1C e poi 39 da 5D22. Sono due
operandi della stessa estrazione; il secondo rimane ancora da ricostruire.

L’ultimo scrittore di 5D1C è C3B7, tick 962, attore 2 (Lestrade), durante
la pulizia della riga provocata dal prefisso qualificato di hansom cab
mentre sale sul veicolo. C388 entra con frame 5D26 e carattere spazio 32.
PUSH BC salva il byte basso C a frame−10, cioè 5D1C. Il registro BC osservato
è 0107: B=1, C=7. Non è stato installato7 nel modello: viene calcolato dalla
colonna del renderer e salvato nel solo contesto ricostruito.

Il probe segue 76 comandi naturali dall’avvio al tratto di WAIT live fino a
mercoledì 07:20, senza patch del mondo. Non risultano cambiamenti di valore
non classificati. Per ogni intervallo conserva gli ultimi 15 store insieme
all’ultimo scrittore corrente, non un dump illimitato di tutte le istruzioni.
La presenza di uno store che lascia lo stesso7 è osservata esplicitamente.

## Algoritmo e significato dei frame

C363 prepara la pulizia dell’ultima riga con 36 spazi. L’origine orizzontale è
2 pixel e ogni carattere occupa7 pixel. Per la colonna `n`:

```text
x = 2 + 7*n
indirizzo = 0x5020 + floor(x/8)
shift = x mod 8
```

C39C salva BC a ogni scansione. Alla scansione finale B=1 e C conserva lo
shift originale. Con shift diverso da zero, C3B7 ripete il salvataggio prima
che il renderer calcoli `8-C`; con shift zero C39C rimane l’ultimo store BC.
Alla colonna 35 della pulizia, `(2+7*35) mod 8 = 7`.

La cella fisica non ha un significato universale:

| Frame d’ingresso C388 | Ruolo di 5D1C |
| --- | --- |
| 5D24 | Byte basso dell’indirizzo video salvato |
| 5D26 | C salvato: shift orizzontale |
| 5D28 | F dell’ultima scansione del font |
| 5D2A | I salvataggi interni del glifo non raggiungono quella cella |

I test distinguono queste profondità. Non si attribuisce lo shift a ogni
stampa e non si completa la coppia BC indovinando5D1D.

## Traduzione e proprietà dello stato

`RandomDisplay.glyphResidue` calcolava già shift e indirizzo dal cursore;
ora pubblica anche 5D1C nel contratto del chiamante verificato. Il nome
qualificato passa da A3DE e A745/A751 a D3E8; lo scarico ha frame 5D2C, e il
wrap prima della parola raggiunge C388 con frame 5D26.

L’annuncio GO TO già ricostruito preserva ora anche questa cella, perché i
suoi salvataggi non la raggiungono. Le stampe senza un contratto di profondità,
le scene generiche e gli errori revocano la proprietà invece di conservare
un valore potenzialmente obsoleto. Non sono introdotti nuovi valori per
5D1D,5D1E o5D22.

Il salvataggio JSON conserva 5D1C quando è noto. Un vecchio LOAD senza il
campo rimane sconosciuto fino a una scrittura ricostruita. L’assenza non viene
colmata col byte iniziale, con 7 o con i flag del byte precedente.

## Prove e limite successivo

- Corpus ABI originale di 432 chiamate: quattro frame, tre caratteri e tutte
  le 36 colonne. 324 casi verificano esplicitamente il nuovo byte nei tre
  frame che lo raggiungono; 108 verificano che il quarto non lo pubblichi.
  Sono coperti tutti gli 8 shift, compreso zero, e i valori dipendenti dagli
  altri ruoli della stessa cella.
- Proprietà condizionata, revoca, preservazione nel chiamante verificato,
  SAVE/LOAD e vecchi salvataggi senza fallback.
- Storia naturale: si confrontano tutti i valori pubblicati dal modello
  ai checkpoint raggiungibili, quindi il primo operando letto da Smith,
  per valore, attore e tick. Il secondo operando sconosciuto 5D22 provoca
  ancora il rollback esplicito del minuto. Non si dichiara verificato lo
  stato completo del modello alle 07:20 solo perché il probe nativo vi arriva.
- Prefisso completo: rimane 0–355, 356 checkpoint sino a mercoledì 07:00;
  tutti i 24 posti attore, ogni estrazione/lettura, arena 752 byte, entità,
  fatti, bitmap e futuro dopo LOAD. Rapporto `results/glyph-shift-verification.json`.
- La ricerca estesa supera 5D1C e si arresta su 5D22 nello stesso checkpoint 356,
  verso 07:10. Occorre individuare frame e ultimo scrittore di 5D22 senza
  attribuirgli automaticamente il ruolo dell’indirizzo video. I cinque
  finali non ancora certificati rimangono aperti.

Suite completa: **892 test passati**; il risultato è salvato in
`results/glyph-shift/checks.json`. Il motore resta JavaScript autonomo;
probe e fixture sono strumenti offline.

## Mappa della memoria

Approfonditi A3D6–A3E1, A9DF–AA0F, C363–C37C e C388–C3E3, con 119 istruzioni
e 179 byte confrontati con il payload e riassemblati. La zona dinamica dello
stack espone ora anche la proprietà condizionata di 5D1C.

Nessun byte prima grigio cambia classificazione: questi intervalli erano
noti e 5D1C appartiene al workspace fuori dal payload. Restano 38.359 byte
documentati, 471 parziali e 2.770 sconosciuti. Copertura documentale ed
equivalenza completa della partita restano misure distinte.


Per ripetere le verifiche dalla cartella `sherlock-js`:

```sh
node --test test/glyph-shift.test.mjs
node tools/verify-witness-prefix.mjs
```

Il probe originale è `tools/probe-glyph-shift.py`; la generazione del dossier
è `tools/build-glyph-shift-listing.py`, seguita da `tools/build-memory-map.py`.
