# Esperimenti sul ciclo principale

Ogni prova ordinaria riparte dal medesimo snapshot del primo prompt, alle 8:01 am (tick 2, scadenza Holmes 1). La prova di avvio parte invece dal payload all’ingresso A040. Gli esiti sono quelli osservati in questi stati.

| Caso | Comando / input | Tick prima → dopo | Calendario finale | Arresto |
|---|---|---|---|---|
| avvio | — | 0 → 2 | giorno 0, 8:01 am | prompt |
| LOOK | LOOK | 2 → 3 | giorno 0, 8:02 am | prompt |
| errore lessicale | OPEN DOR | 2 → 2 | giorno 0, 8:01 am | prompt |
| errore sintattico | PICK THE NOTE UP | 2 → 2 | giorno 0, 8:01 am | prompt |
| rifiuto semantico | TAKE ARMCHAIR | 2 → 2 | giorno 0, 8:01 am | prompt |
| disambiguazione | EXAMINE ARMCHAIR | 2 → 2 | giorno 0, 8:01 am | prompt |
| due comandi | TAKE LAMP. GIVE LAMP TO WATSON | 2 → 4 | giorno 0, 8:03 am | prompt |
| WAIT | WAIT | 2 → 6 | giorno 0, 8:05 am | prompt |
| WAIT UNTIL | WAIT UNTIL 8:05 | 2 → 5 | giorno 0, 8:04 am | prompt |
| WAIT UNTIL interrotto | WAIT UNTIL 8:05 | 2 → 3 | giorno 0, 8:02 am | prompt |
| SAVE | SAVE | 2 → 2 | giorno 0, 8:01 am | tape_boundary |
| QUIT | QUIT | 2 → 0 | giorno 0, 8:01 am | tape_boundary |
| timeout senza input | — | 2 → 6 | giorno 0, 8:05 am | prompt |
| timeout input parziale | TAKE | 2 → 6 | giorno 0, 8:05 am | prompt |

## Costi e scadenze di Sherlock

Sono elencati tutti gli aggiornamenti della riga di Holmes osservati in ciascun esperimento. Una riga vuota di aggiornamenti indica che non è stato ceduto il turno con un costo positivo.

- **avvio**: 0 + 1 = 1 (al tick 1).
- **LOOK**: 1 + 1 = 2 (al tick 2).
- **errore lessicale**: nessun aggiornamento.
- **errore sintattico**: nessun aggiornamento.
- **rifiuto semantico**: nessun aggiornamento.
- **disambiguazione**: nessun aggiornamento.
- **due comandi**: 1 + 1 = 2 (al tick 2); 2 + 1 = 3 (al tick 3).
- **WAIT**: 1 + 5 = 6 (al tick 2).
- **WAIT UNTIL**: 1 + 4 = 5 (al tick 2).
- **WAIT UNTIL interrotto**: 1 + 4 = 5 (al tick 2).
- **SAVE**: 1 + 1 = 2 (al tick 2).
- **QUIT**: 0 + 1 = 1 (al tick 0).
- **timeout senza input**: 1 + 5 = 6 (al tick 2).
- **timeout input parziale**: 1 + 5 = 6 (al tick 2).

## Timeout

| Caso | Letture tastiera | T-state dell’attesa |
|---|---:|---:|
| timeout senza input | 3000 | 209631233 |
| timeout input parziale | 3000 | 209700936 |

L’input parziale è `TAKE`, senza ENTER. Il timeout cancella la riga e segue il ramo WAIT della sequenza del giocatore. Il conteggio non è una misura del tempo necessario a eseguire lo script Python.

## Limiti delle prove

I caratteri dei comandi e delle scelte di paginazione sono iniettati ai confini delle routine. Per i timeout si eseguono invece polling, ROM e interrupt con nessun tasto premuto. L’interruzione di WAIT UNTIL inietta il ritorno ENTER di C41F. SAVE e QUIT sono interrotti prima dell’I/O: nessun nastro è salvato o caricato. Il JSON integrale conserva tutti gli eventi e le modifiche rilevate alle entità.
