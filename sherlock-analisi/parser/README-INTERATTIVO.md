# Laboratorio interattivo del parser di Sherlock

Lo script analizza ciò che digiti e mostra l'errore oppure la struttura del comando: parole riconosciute, alias, verbi, gruppi nominali, qualificatori, pronomi, ALL/esclusioni e contenuto delle citazioni. Analizza anche le frasi successive nella stessa riga.

**È un programma Python che esegue le routine Z80 originali tramite SkoolKit. Non è ancora un porting indipendente del parser. Non esegue azioni nel mondo del gioco.** Usa i dati e SkoolKit già presenti nel progetto; non occorre installare pacchetti.

## Avvio

Da Terminale:

```sh
python3 -B "/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-analisi/parser/sherlock_parser.py"
```

Oppure apri con doppio clic `Avvia parser.command`, nella stessa cartella.

Puoi provare:

```text
GIVE BOOK TO WATSON
TAKE BOOKS
TAKE ALL BUT BOOK
HE KILLED YOU
TELL WATSON "WATSON KILLED YOU"
TELL WATSON "THE"
LOOK. THE
```

`BOOKS → BOOKCASE` è una particolarità del riconoscitore originale, riprodotta intenzionalmente. Una sintassi accettata non garantisce che l'azione abbia senso, sia possibile o trovi gli oggetti richiesti.

## Continuazioni e comandi del laboratorio

```text
Sherlock> EXAMINE ARMCHAIR
Sherlock> /continua 1 WATSONS
```

La seconda riga completa il primo gruppo nominale: EXAMINE, ARMCHAIR, qualificatore WATSONS. Il programma prepara esplicitamente il contesto di una domanda; non decide autonomamente se il gioco debba chiedere “quale poltrona?”.

| Comando | Effetto |
|---|---|
| `/continua 1 RISPOSTA` | Completa il primo gruppo del comando conservato |
| `/continua 2 RISPOSTA` | Completa il secondo gruppo |
| `/dettagli` | Attiva/disattiva classi, offset e byte dei nodi |
| `/json` | Mostra l'ultima analisi completa in JSON |
| `/reset` | Dimentica contesto e riga precedente |
| `/aiuto` | Mostra le istruzioni |
| `/esci` | Esce dal laboratorio |
| `@` | Ripete la riga precedente, tramite il percorso originale |

Usa `@` da solo. QUIT è un comando di Sherlock da analizzare: per uscire dal programma usa `/esci`, Ctrl-D oppure Ctrl-C al prompt.

## Esempio di informazione prodotta

Per `TELL WATSON "WATSON KILLED YOU"`:

```text
Sintassi accettata.
Comando esterno: TELL
  Gruppo nominale 1: WATSON
Citazione: affermazione
  Soggetto: WATSON
  Predicato: KILLED
  Gruppo nominale 1: YOU
```

L'output effettivo include anche la riga normalizzata, i token e il modo del parser. Il destinatario e i referenti non vengono cercati nel mondo del gioco. Per HE/IT/THEY viene mostrato il flag pronominale, senza attribuirgli arbitrariamente un personaggio o un oggetto.

Il contenuto delle citazioni viene verificato anticipatamente: un errore interno è distinto da un errore del comando esterno. Analogamente, per una riga composta si possono vedere unità valide seguite da una errata. Nessuna delle unità viene eseguita.

## Un solo comando e output JSON

Dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/parser/sherlock_parser.py --command 'GIVE BOOK TO WATSON'
python3 -B sherlock-analisi/parser/sherlock_parser.py --command 'TELL WATSON "LOOK"' --json
python3 -B sherlock-analisi/parser/sherlock_parser.py --base 'EXAMINE ARMCHAIR' --continue-group 1 --command WATSONS
```

Se esegui una copia dello script fuori dalla cartella originale, aggiungi:

```text
--project "/Users/giovanni/Documents/Development/Sherlock rebuild"
```

Nel JSON, `outcome` distingue `ok`, `empty`, `lexical_error`, `syntax_error`, `quoted_syntax_error`, `undetermined`, `tool_limit` e `no_context`. Le unità contengono i nodi, le citazioni e i puntatori di scansione. `semantic_checks_performed` è sempre falso.

Un comando non accettato è un risultato dell'analisi, non un crash del programma: l'esecuzione non interattiva termina normalmente e il risultato si legge in `outcome`.

## Limiti e riproduzione delle prove

L'interfaccia accetta fino a 70 caratteri ASCII stampabili, oltre a £. Per alcuni input l'originale supera i propri buffer o prosegue fuori dal dizionario: lo strumento interrompe l'esecuzione e dichiara che non può stabilire l'esito. Non trasforma questi casi in errori sintattici inventati.

Il contesto per `/continua` proviene dall'ultima analisi completamente riuscita con nodi; per più unità conserva l'ultima unità, della quale si completa la testa della lista. Le analisi indipendenti ripartono dallo snapshot iniziale. Questa è una sessione di studio della sintassi, non una partita persistente.

Per ripetere le verifiche, dalla cartella del progetto:

```sh
python3 -B sherlock-analisi/parser/verify_special.py
python3 -B sherlock-analisi/parser/build_special_listing.py
```

Il rapporto tecnico è `LEGGIMI-SPECIALI.md`; una sessione completa è in `results-special/example-session.txt`.
