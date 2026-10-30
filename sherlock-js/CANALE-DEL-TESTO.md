# $A027: selezione del canale del testo

31 ottobre 2026. Il limite `$A027` è ricostruito come stato funzionale
condiviso, conservato nei salvataggi. Il motore rimane autonomo JavaScript;
nessuna traccia o istruzione Z80 viene eseguita durante il gioco.

## Significato e scrittori

Zero seleziona la finestra superiore del mondo; uno la finestra inferiore
dei comandi. Il payload iniziale contiene zero, ora esportato come dato
immutabile `argumentChecks.initialOutputChannel`. Il valore corrente è
mutabile e non viene sostituito con quello iniziale a ogni lettura.

Il router `$C1E1` controlla prima `$5C3C` (output abilitato), poi `$A027`:
zero va a `$C2BA`, nonzero a `$C1FD`. In `$A9B7`, il canale inferiore salta
anche il normale buffer delle parole. Non è una preferenza HTML e non
è uno dei flag lessicali `$A01D/$A01E`.

Sono individuati dodici store assoluti nel codice verificato:

| Writer | Comportamento |
| --- | --- |
| `$D8A0` | Scrive 1 prima del prompt e dell’editor. |
| `$D8A8` | Scrive 0 quando l’editor restituisce il comando, prima del lessico e dei turni. |
| `$D6E7` / `$D710` | Errore lessicale: apre sotto con 1, poi chiude scrivendo 0. |
| `$D7C0` / `$D7CA` | Errore sintattico WHAT?: stesso passaggio 1 → 0. |
| `$CB69` / `$CB74` | Handler del predicato fallito: 1 durante l’errore, 0 al ritorno. |
| `$A306` / `$A352` | Annuncio: 1 se il modo A00C è zero, altrimenti 0; uscita sempre 0. Conta anche quando il testo è soppresso fuori scena. |
| `$CBAF` | Richiesta vietata: forza 0 prima del testo 681A. |
| `$9A90` | Saluto: 1 se il soggetto è Holmes (ID zero), 0 per gli NPC. |

I reset scrivono **zero**, non ripristinano il canale precedente. Il nuovo
prompt può successivamente scrivere uno. Un WAIT vivo sospeso ad `$A074`
è ancora nel canale superiore; un comando terminato nel prompt è sotto.

## Traduzione funzionale

`world.npcs.outputChannel` contiene il byte e `NpcRuntime.read` lo espone
al generatore casuale. Le transizioni seguono ingresso/ritorno dell’editor,
errori, saluto, rifiuti e annunci. Il prompt iniziale è aperto dopo gli NPC
dell’avvio, così le loro prime estrazioni non ereditano il canale dell’editor.
La proiezione grafica del prompt rimane idempotente, ma il writer del canale
viene eseguito anche se `> ` era già disegnato.

Vecchi LOAD senza il campo restano sconosciuti, sia nel lettore del dominio
sia in quello casuale; nessuno zero di ripiego. Un writer successivo compreso
ne ristabilisce il valore. I salvataggi attuali conservano il canale corrente.
`$A028` e gli altri byte adiacenti non vengono proiettati per estensione.

## Prove e limiti dichiarati

Il corpus breve conserva 14 storie originali: 13 ordinarie/esplorative e
una dedicata alla sintassi errata. In 12 storie il confronto controlla
canale a ogni checkpoint e draw, ogni operando casuale, scheduler, entità,
fatti, arena da 752 byte, bitmap esatte e futuro dopo LOAD.
Gli store invariati sono registrati, senza dedurre il writer soltanto dai
cambi di valore. La copertura dinamica del catalogo non pretende che ogni
writer sia stato raggiunto: il ramo CBAF è documentato staticamente.

L’oracolo inietta i tasti riprendendo il proprio editor e imposta esplicitamente
A027=1. Il probe distingue questo passaggio del protocollo dagli store Z80;
non lo conta come una scrittura scoperta nel gioco.

Due storie esplorative rivelano differenze **già presenti nel commit 15db455**:

- Caso 11: dopo `SAY WATSON "WAIT UNTIL 9AM"`, `I`, `PRINT`, il contatore
  MORE è 0 in JS e 2 nell’originale.
- Caso 12: `TAKE TO` lascia il budget di fallimento a 3 in JS e 0 nell’originale.

Il corpus completo è conservato. Questi casi hanno test separati che
richiedono esattamente il controesempio osservato; non sono certificati di
parità. Nessun campo viene rimosso dal confronto per farli passare.
Il rapporto `unrelated-boundaries.json` riproduce gli stessi primi scarti
con sorgenti JS non modificati del commit precedente.

Il prefisso lungo raggiunge **411 checkpoint 0–410, mercoledì 16:10**,
con 8.201 draw e 17.558 read confrontati, tutti i 24 posti attore, arena
completa, bitmap e futuro dopo LOAD. Nessun teletrasporto o patch del mondo.
Il prossimo confine è `$5D28`, checkpoint 411 verso le 16:20; la lettura
originale già osservata è alle 16:12. Le due estrazioni iniziali non sono
incluse nel conteggio dei draw confrontati nei checkpoint.

La nuova acquisizione continua campiona 3.241 checkpoint. Canale e ogni
estrazione casuale coincidono nell’intera traccia. Per il confronto completo
dello stato emerge però un ulteriore confine al checkpoint 1671, martedì
14:02: la riga del giardiniere in PC EDE1 conserva `[50,33,1]` in JS contro
`[50,255,1]` nel sorgente. Il prefisso completo di questa acquisizione
continua si ferma quindi a 0–1670; i controlli successivi hanno ambito
esplicito limitato a canale/draw. Non sono una certificazione di ogni stato
intermedio. Il confronto completo ai 411 checkpoint originari resta integro.
Vedere `minute-boundary.json` per la riproduzione con il commit precedente.

Cinque finali naturali restano aperti (6A33, 6ABD, 6AF3, 6B79, 75D2), così
come il limite separato del cab 5D0C. Non è certificata l’intera partita.

Passati 47 controlli mirati, inclusi i test che conservano esplicitamente
i controesempi. La suite completa viene eseguita da GitHub Actions sul
commit pubblicato.

## Atlante e strumenti

Il listing verifica **160 istruzioni e 338 byte**, separando A027 come dato.
Passano da grigi a documentati `$9A80–$9A98` (saluto e scelta del canale,
25 byte) e `$CB43–$CB78` (fallimento con handler, 54 byte). Il singolo byte
`$A027` passa da parziale a documentato.

Approfonditi anche `$A2E4–$A35C`, `$A9B7–$A9BE`, `$C1E1–$C1F3`,
`$CBA7–$CBBA`, `$D6E5–$D713`, `$D7BA–$D7CF`, `$D898–$D8AC`.
Totali: 38.649 documentati, 465 parziali, 2.486 grigi su 41.600 byte.
La copertura statica non misura la copertura completa del gameplay.

```
python3 tools/probe-output-channel.py
python3 tools/probe-output-channel.py --syntax
python3 tools/probe-output-channel.py --witness
python3 tools/build-output-channel-listing.py
python3 tools/build-memory-map.py
node --test test/output-channel.test.mjs test/output-channel-boundaries.test.mjs
node tools/verify-witness-prefix.mjs
```

Artefatti: `results/output-channel/`, `results/output-channel-verification.json`.
