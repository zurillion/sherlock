# Come usare gli script Python

## Preparazione

Apri il Terminale e posizionati nella cartella del progetto:

```sh
cd "/Users/giovanni/Documents/Development/Sherlock rebuild"
```

Tutti gli script qui elencati sono già stati eseguiti: puoi consultare i risultati senza rilanciarli. Non sono interattivi. Usano i file e SkoolKit già presenti nel progetto, senza installazioni aggiuntive. Non modificano TAP, TZX o snapshot originali; rigenerano soltanto i propri risultati. Le prove emulano le modifiche del gioco in memoria.

## I quattro script della fase «entità»

### Estrarre il database

```sh
python3 -B sherlock-analisi/entita/sherlock_entities.py
```

Produce `sherlock-analisi/entita/results/CATALOGO.md` e `entities.json`: le 110 entità, nomi, descrizioni, genitori/contenitori, posizioni, byte e regole locali. Il catalogo contiene spoiler. È lo script da usare per consultare o riutilizzare il database.

### Verificare l’estrazione contro lo Z80

```sh
python3 -B sherlock-analisi/entita/verify_entities.py
```

Confronta lookup, categoria personale, posizioni, qualificatori, regole locali e importi con le routine originali. Prova anche dieci esempi del manuale. Produce `verification.json` e `manual-probes.json`. In caso di discordanza si interrompe mostrando l’asserzione fallita.

### Rigenerare gli estratti assembler

```sh
python3 -B sherlock-analisi/entita/build_entities_listing.py
```

Produce `entities-semantics.asm` e `listing-verification.json`. Separa i dati dalle istruzioni e ricompone ogni riga nei byte originari. Non disassembla automaticamente tutta la memoria: gli intervalli sono quelli identificati durante l’analisi.

### Ripetere gli esperimenti semantici

```sh
python3 -B sherlock-analisi/entita/trace_semantics.py
```

Esegue 26 esperimenti e produce `semantic-traces.json`: candidati, verifiche, argomenti risolti, attori e messaggi. Comprende sia comandi isolati sia due casi che conservano lo stato del comando precedente. Non offre un prompt libero: l’elenco degli esperimenti è nello script.

## I quattro script aggiunti nella fase «regole»

| Script | Funzione | Risultati principali |
|---|---|---|
| `sherlock_rules.py` | Decodifica nove blocchi relativi a TAKE, GIVE, OPEN e SAY TO. | `rules.json`, `REGOLE.md` |
| `trace_rules.py` | Esegue 21 esperimenti con cattura degli effetti e del tempo. Sei prove costruiscono stati sintetici, dichiarati nei risultati. | `execution-traces.json` |
| `verify_rules.py` | Confronta intestazioni e maschere con lo Z80 e controlla le tracce precedenti. | `verification.json` |
| `build_rules_listing.py` | Genera e verifica gli estratti separando intestazioni, bytecode e assembler. | `rules.asm`, `listing-verification.json` |

Comandi, nell’ordine consigliato:

```sh
python3 -B sherlock-analisi/regole/sherlock_rules.py
python3 -B sherlock-analisi/regole/trace_rules.py
python3 -B sherlock-analisi/regole/verify_rules.py
python3 -B sherlock-analisi/regole/build_rules_listing.py
```

I loro risultati sono in `sherlock-analisi/regole/results`. La prova sintetica di una delle casseforti raggiunge un finale del gioco e si arresta intenzionalmente prima della lettura del nastro: il rapporto lo distingue da un comando concluso normalmente.

## Opzioni comuni

Per vedere l’aiuto:

```sh
python3 -B sherlock-analisi/entita/sherlock_entities.py --help
```

Per conservare i risultati precedenti e scrivere altrove:

```sh
python3 -B sherlock-analisi/entita/sherlock_entities.py --output "sherlock-analisi/entita/prova-estrazione"
```

Per usare una copia dello script da un’altra directory, specifica la radice del progetto:

```sh
python3 -B "/percorso/alla/copia/sherlock_entities.py" --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output "/percorso/dei/risultati"
```

Se cambi `--output` per la fase regole, usa la stessa cartella per `trace_rules.py` e `verify_rules.py`: il verificatore legge lì `execution-traces.json`.

`-B` evita di creare file Python `__pycache__`. Non cambia il risultato dell’analisi.

Per inserire comandi liberamente rimane disponibile il laboratorio interattivo precedente:

```sh
python3 -B sherlock-analisi/parser/sherlock_parser.py
```

Questo laboratorio continua a verificare la sintassi: le nuove analisi del mondo non sono state trasformate in una semantica interattiva approssimativa.
