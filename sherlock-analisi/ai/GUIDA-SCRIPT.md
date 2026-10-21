# Strumenti Python per l’AI dei personaggi

Cartella del progetto: `sherlock-analisi/ai`. Gli script leggono il payload originale e riusano il parser, il decoder, il catalogo entità e SkoolKit già nel progetto. Non richiedono pacchetti aggiuntivi. I dati del gioco e il server dell’esploratore non vengono modificati.

Dalla cartella `Sherlock rebuild`:

```sh
python3 -B sherlock-analisi/ai/decode_npc_ai.py
python3 -B sherlock-analisi/ai/trace_npc_ai.py
python3 -B sherlock-analisi/ai/verify_npc_ai.py
python3 -B sherlock-analisi/ai/build_ai_listing.py
```

I risultati sono già generati in `results`. Tutti gli script hanno `--help`, `--project` e `--output`. Eseguire la traccia prima della verifica se si vogliono rigenerare i risultati.

| Script | Che cosa fa | Output |
|---|---|---|
| `decode_npc_ai.py` | Segue i rami delle sequenze di Watson, Lestrade e Basil; riconosce le regole differite e separa intestazioni e bytecode. Non sostituisce l’esecutore Z80. | `scripts.json`, `SEQUENZE.md` |
| `trace_npc_ai.py` | Esegue 17 scenari e 67 comandi nello Z80 originale, abilitando tutti gli attori. Salva turni, opcode, regole, richieste, segnali, testo e stati. Può richiedere alcuni minuti. | `npc-traces.json`, `PROVE.md` |
| `verify_npc_ai.py` | Confronta il decoder con le routine native e verifica risultati e fixture causali. Richiede il file completo delle tracce. | `verification.json` |
| `build_ai_listing.py` | Genera un listato misto, con dati e script distinti dallo Z80; riassembla ogni frammento e lo confronta con l’originale. | `npc-ai.asm`, `listing-verification.json` |

Per una prova breve, senza sovrascrivere la raccolta completa:

```sh
python3 -B sherlock-analisi/ai/trace_npc_ai.py \
  --only watson_take \
  --only watson_follow_order \
  --output sherlock-analisi/ai/prova-breve
```

`--only` è ripetibile. Nomi disponibili:

- `autonomous_seed_1`, `autonomous_seed_7`: dieci WAIT, con due stati iniziali del generatore casuale.
- `watson_take`, `watson_impossible`: azione valida e richiesta non eseguibile.
- `watson_departure`: Holmes esce e aspetta; Watson lascia il biglietto e sparisce dalla mappa.
- `watson_drop_follow`: Watson lascia il Daily Chronicle; la lettura si interrompe e passa al seguito autonomo.
- `watson_follow_order`: seguito richiesto esplicitamente con FOLLOW ME.
- `watson_innocent`, `watson_accusation`, `watson_statement`: tre affermazioni, con esiti diversi.
- `watson_tell`: richiesta di informazioni su Lestrade.
- `watson_go`, `watson_open_then_west`: movimento e due istruzioni consecutive. La seconda prova contiene OPEN YOUR DOOR e WEST.
- `lestrade_wait`, `lestrade_take`, `lestrade_west`: fixture di compresenza per interrogare Lestrade durante la fase iniziale.
- `lestrade_wait_flag_clear`: confronto causale con `lestrade_wait`, azzerando solo il bit40 dell’opcode E7E9.

Gli scenari non sono salvataggi della partita del browser. Ciascuno usa una macchina isolata. `fixture: true` indica una modifica costruita per la prova; `fixture_description` ne spiega il contenuto. La fixture che cambia E7E9 opera solo sulla RAM del simulatore.

Il confronto dei semi parte dal primo prompt: le azioni e il primo contatore di Watson già presenti nello snapshot non vengono ripetuti. La traccia mette `$A037` al seme scelto e il cursore `$A039` a zero. Per riprodurre un avvio da nastro con lo stesso stato casuale servirà una prova distinta.

Il file delle tracce è volutamente dettagliato (circa 8 MB). Per leggerlo è preferibile cominciare da `PROVE.md`, poi cercare uno scenario e un evento nel JSON. Esempi di eventi: `opcode`, `branch`, `action`, `rule`, `request_dispatch`, `request_gate`, `npc_order`, `signal_send`, `signal_test`, `reschedule`, `callback`, `statement`.

Fuori dal progetto, indicare esplicitamente la sua posizione:

```sh
python3 -B decode_npc_ai.py \
  --project "/Users/giovanni/Documents/Development/Sherlock rebuild" \
  --output risultati-ai
```

L’esploratore HTML conserva per ora gli NPC statici. Questa cartella è il banco di analisi del comportamento nativo, da usare per preparare un’integrazione verificata.
