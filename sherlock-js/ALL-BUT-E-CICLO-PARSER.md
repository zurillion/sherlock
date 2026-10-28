# ALL/BUT: stato condiviso e ciclo del parser

## Stato e scritture

A01A è un byte temporaneo condiviso dall’intera unità di parsing, distinto
dai bit ALL ed esclusione dei singoli nodi. Il payload iniziale contiene
zero; AAB3 azzera lo stato a ogni ingresso effettivo nel parser. B03F
scrive uno dopo ALL, B026 scrive due dopo BUT. Non vi sono altri scrittori
in questo percorso. Il modello JavaScript riproduce queste transizioni e
le salva con la partita; non legge una sequenza di risposte catturata.

Un errore lessicale precedente al parser conserva lo stato. Un errore
sintattico dopo ALL o BUT conserva l’ultima transizione raggiunta, perché
AF67 ritorna senza azzerare il byte. Le citazioni e le continuazioni
attraversano gli ingressi reali; un’analisi preventiva non modifica lo stato.
I vecchi salvataggi senza il campo restano sconosciuti finché il parser
non lo scrive. Il valore iniziale non è usato come fallback al LOAD.

ALL passa prima da AFE8: il verbo o il chiarimento pendente devono essere
ammessi. Poi lo stato condiviso deve essere zero. BUT richiede invece lo
stato uno. Un AND non azzera il byte: se un nuovo verbo viene rinviato a
una nuova unità, soltanto quel successivo ingresso lo riporta a zero.
Il backtracking ripristina A012 ma non A01A. Per questo il valore non può
essere dedotto dall’ultimo nodo AST o semplicemente dal comando WAIT.

## Casi limite ricostruiti

Le verifiche complete hanno individuato e corretto tre effetti collegati:

- **Eredità tardiva del verbo.** AE19/AEF1 la applica nella post-elaborazione
  riuscita. Se il parsing fallisce prima, il nodo liberato mantiene il
  verbo ancora assente. Anticipare la copia lasciava un byte diverso
  nell’arena, pur mostrando lo stesso messaggio WHAT.
- **Slot nominale dopo BUT.** B026 alloca un nodo senza azzerare i bit di
  disponibilità dei gruppi. ACA6 scrive quindi nello slot fisico ancora
  disponibile: se il primo era già consumato, l’esclusione occupa il secondo.
  Un terzo gruppo non viene scritto oltre il record: è un errore sintattico.
- **Fine di ALL nella stessa unità.** D86A/DC15 restituisce un fallimento
  anche quando le selezioni precedenti hanno avuto successo. Quel tentativo
  va contato prima di eseguire il nodo ordinario successivo. Cambia lo
  stato del contatore e può cambiare quando lo scheduler concede un minuto.

SAVE senza altro input non rientra nel parser per consumare una sola
punteggiatura terminale. È stato eliminato quel reset supplementare del
prototipo: la sequenza delle scritture ora coincide anche in questo caso.
Le anomalie di BUT già documentate in LINGUAGGIO-COMPLESSO.md rimangono:
non è stato sostituito il comportamento originale con un filtro moderno.

## Prove

La suite completa passa **768 test**. I nuovi controlli comprendono:

- 34 sequenze native (87 input) con confronto di ogni scrittura AAB3,
  B026 e B03F, del valore finale, del contatore A012 e dell’esito; comprendono
  citazioni vuote, errori, @, coordinazioni, controlli e chiarimenti.
- Otto sequenze con confronto completo di attori, entità, fatti, arena,
  record liberati, bitmap, ogni estrazione/lettura e seguito dopo LOAD.
  Comprendono ripetizioni di ALL e l’esclusione nel secondo slot.
- Analisi preventive pure e vecchi salvataggi senza inizializzazione inventata.

Tutte le sequenze partono da seed 1 e mantengono tutti gli attori.
I controlli SAVE/PAUSE/PRINT usano il precedente adattatore delle sole
periferiche; la logica di parsing rimane quella originale. I fixture sono
prove offline e non sono caricati dal motore giocabile.

## Limite del confronto naturale

Il prefisso major-witness rimane verificato su **338 checkpoint, 0–337,
fino a mercoledì 04:00**, con tutti i 24 posti attore, ogni sorteggio e
lettura, arena completa, mondo, bitmap e futuro dopo LOAD, inclusi i minuti
live del WAIT. Protocollo: seed 1, LOOK iniziale gratuito, grafica originale
spenta dopo il boot, input maiuscolo iniettato e MORE immediato.
Rapporto corrente: `results/parser-all-verification.json`;
ripetere con `node tools/verify-witness-prefix.mjs`.

La continuazione supera A01A ma incontra **A020 nello stesso checkpoint
338**, verso mercoledì 04:10. È il byte alto del costo temporaneo A01F–A020,
non il tempo totale trascorso o il costo del solo comando attuale. Occorre
ricostruirne scritture e persistenza fra le operazioni prima di pubblicarlo.
Non è stata introdotta una costante zero e non è certificato un orario nuovo.

I cinque testi terminali ancora aperti restano 6A33, 6ABD, 6AF3, 6B79 e
75D2. Il finale nativo 6A33 di giovedì 10:00 non è ancora certificato JS.

## Zone della mappa aggiornate

| Intervallo inclusivo | Contenuto approfondito |
| --- | --- |
| A01A | Stato condiviso ALL/BUT, distinto dai flag dei nodi |
| AAB2–AABC | Reset all’ingresso effettivo del parser |
| ACA6–ACCB | Copia nei due slot nominali, conservati attraverso BUT |
| ACCC–AD6B | Coordinazioni, backtracking e conteggio delle esclusioni |
| AE11–AE1D | Condizione per l’eredità tardiva del verbo |
| AEF1–AF03 | Copia del verbo senza propagare ALL |
| AF67–AF6A | Ritorno dall’errore senza cancellare lo stato |
| AFE8–AFF9 | Verbo, contatore e chiarimento necessari per ALL |
| B01C–B048 | Transizioni ALL/BUT e relative precondizioni |
| D835–D86F | Rilascio delle esclusioni e fallimento alla fine di ALL |

Il nuovo dossier riassela **166 istruzioni / 368 byte** del payload.
A01A passa da classificazione parziale a documentata; gli altri intervalli
sono approfondimenti di zone già classificate. I byte sconosciuti restano
3.218. Queste misure di copertura non certificano l’intero gameplay.
