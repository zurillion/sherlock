# Script per studiare e provare il cab

Questi strumenti usano il payload, il parser, il banco AI e SkoolKit già presenti in Sherlock rebuild. Non richiedono pacchetti aggiuntivi. I comandi sotto partono dalla cartella del progetto.

## Provare una corsa completa

```sh
python3 -B sherlock-analisi/cab/trace_cab.py --demo
```

Parte dal prompt originale e apre le porte, esce su Baker Street, chiama il cab, sale, ordina Buckingham Palace Road, attende l’arrivo, scende e paga uno scellino. Si vedono la tariffa di 8d e il resto di 4d. Il JSON viene salvato in `sherlock-analisi/cab/results/interactive-trace.json`.

Per continuare a impartire comandi dopo la dimostrazione:

```sh
python3 -B sherlock-analisi/cab/trace_cab.py --demo --interactive
```

Per partire da zero e digitare ogni comando:

```sh
python3 -B sherlock-analisi/cab/trace_cab.py --interactive
```

`:state` mostra posizioni, genitori, conti dei due cocchieri, scadenze e programma corrente. `:quit` termina il banco di prova. Uscendo normalmente viene salvata la sessione JSON. Massimo 70 caratteri ASCII stampabili per comando, oppure `£`; gli input invalidi non vengono inviati al motore.

Gli NPC agiscono davvero attraverso lo scheduler originale. Questa sessione è indipendente dalla partita nel browser. I tasti per MORE sono soddisfatti automaticamente e l’attesa reale alla tastiera non viene simulata. SAVE/LOAD/QUIT e i confini del nastro non sono supportati dal banco; `:quit` è il comando per uscire dallo script.

## Altri ingressi e destinazioni degli output

`--command` è ripetibile. Per esempio:

```sh
python3 -B sherlock-analisi/cab/trace_cab.py \
  --command 'OPEN YOUR DOOR' \
  --command 'WEST' \
  --output sherlock-analisi/cab/prova-breve
```

Da una cartella esterna usare `--project` con il percorso di Sherlock rebuild. Tutti gli script accettano `--help`, `--project` e `--output`.

## Rigenerare dati e prove

```sh
python3 -B sherlock-analisi/cab/cab.py
python3 -B sherlock-analisi/cab/build_cab_listing.py
python3 -B sherlock-analisi/cab/trace_cab.py --suite
python3 -B sherlock-analisi/cab/verify_cab.py
```

La suite può richiedere alcuni minuti e riscrive `results/cab-traces.json` e `PROVE.md`. Il verificatore usa quella raccolta e salva `verification.json`.

| Programma | Funzione |
|---|---|
| `cab.py` | Estrae 45 tratte, bytecode, intestazioni e frasi; espone `fare`, `pack_money`, `unpack_money` per il modello Python. |
| `trace_cab.py` | Esegue 25 scenari con 148 comandi registrati sullo Z80 originale, oppure una sessione interattiva. La sola fixture di ricollocamento del mondo è dichiarata nello scenario dell’incontro con lo stesso cocchiere. |
| `verify_cab.py` | Verifica i risultati degli scenari e confronta 180 viaggi/prezzi, 110 lookup e 16 importi con routine native. Le chiamate isolate preparano dati e contesto; non modificano codice. |
| `build_cab_listing.py` | Produce `cab.asm`, distinguendo istruzioni Z80, intestazioni delle regole, bytecode e tabella delle tratte; verifica 1466 byte per riassemblaggio. |

Per leggere l’analisi cominciare da [LEGGIMI-CAB.md](LEGGIMI-CAB.md), poi consultare [PROVE.md](results/PROVE.md), [ROTTE.md](results/ROTTE.md) e [BYTECODE.md](results/BYTECODE.md). Il listato è il riferimento per controllare i singoli indirizzi.
