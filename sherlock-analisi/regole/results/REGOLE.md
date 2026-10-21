# Intestazioni delle regole selezionate

Indirizzi esadecimali; durata in minuti del modello di tempo del gioco. I corpi marcati Z80 iniziano dopo l’intestazione, non all’indirizzo della regola.

| Regola | Indirizzo | Argomenti | Luce | Durata | Predicato | Corpo | Tipo |
|---|---|---|---|---|---|---|---|
| TAKE generale | $DCC1 | 9, 0 | sì | 1 | DCA2 | $DCC5 | codice Z80 |
| SAY TO generale | $DD9E | D, 0 | no | 1 | — | $DDA0 | codice Z80 |
| OPEN ordinario | $DE9D | 8, 0 | sì | 1 | — | $DEA4 | codice Z80 |
| CLOSE ordinario (controllo complementare) | $DEAF | 8, 0 | sì | 1 | — | $DEB6 | codice Z80 |
| GIVE generale | $DF02 | A, D | sì | 1 | DF24 | $DF06 | codice Z80 |
| TAKE biglietto in fiamme | $DF7E | 8, 0 | no | 0 | — | $DF80 | script differito |
| aggiornamento biglietto dopo TAKE | $DF8B | 8, 0 | no | 0 | — | $DF8D | codice Z80 |
| OPEN cassaforte | $DFA7 | 8, 0 | no | 0 | E01C | $DFAB | script differito |
| evento narrativo cassaforte | $DFB6 | 7, 0 | no | 15 | — | $DFB8 | codice Z80 |

## Dettagli

### $DCC1 — TAKE generale

Intestazione: `69 10 a2 dc`.

- Argomento 1: classe 9 — entità trasportabile: percezione, occorrenza unica, non persona, capacità, catena genitori non personale.
- Argomento 2: classe 0 — nessuno.

### $DD9E — SAY TO generale

Intestazione: `0d 10`.

- Argomento 1: classe D — entità percepibile con bit persona.
- Argomento 2: classe 0 — nessuno.

### $DE9D — OPEN ordinario

Intestazione: `38 10 80 21 00 00 00`.

- Argomento 1: classe 8 — entità percepibile.
- Argomento 2: classe 0 — nessuno.
- Maschere argomento 1: modo 2, maschera $21; modo 0, maschera $00.
- Maschere argomento 2: modo 0, maschera $00; modo 0, maschera $00.

### $DEAF — CLOSE ordinario (controllo complementare)

Intestazione: `38 10 00 20 00 00 00`.

- Argomento 1: classe 8 — entità percepibile.
- Argomento 2: classe 0 — nessuno.
- Maschere argomento 1: modo 0, maschera $20; modo 0, maschera $00.
- Maschere argomento 2: modo 0, maschera $00; modo 0, maschera $00.

### $DF02 — GIVE generale

Intestazione: `6a 1d 24 df`.

- Argomento 1: classe A — entità percepibile posseduta dall’attore.
- Argomento 2: classe D — entità percepibile con bit persona.

### $DF7E — TAKE biglietto in fiamme

Intestazione: `88 00`.

- Argomento 1: classe 8 — entità percepibile.
- Argomento 2: classe 0 — nessuno.
- Script $DF80: `07 c1 dc fd ff` — esegui regola a puntatore $DCC1 (primo argomento salvato (9FD7), assente).
- Script $DF85: `07 8b df fd ff` — esegui regola a puntatore $DF8B (primo argomento salvato (9FD7), assente).
- Script $DF8A: `0b` — ritorno al contesto sospeso, CFCF.

### $DF8B — aggiornamento biglietto dopo TAKE

Intestazione: `08 00`.

- Argomento 1: classe 8 — entità percepibile.
- Argomento 2: classe 0 — nessuno.

### $DFA7 — OPEN cassaforte

Intestazione: `c8 00 1c e0`.

- Argomento 1: classe 8 — entità percepibile.
- Argomento 2: classe 0 — nessuno.
- Script $DFAB: `07 b6 df fd ff` — esegui regola a puntatore $DFB6 (primo argomento salvato (9FD7), assente).
- Script $DFB0: `07 9d de fd ff` — esegui regola a puntatore $DE9D (primo argomento salvato (9FD7), assente).
- Script $DFB5: `0b` — ritorno al contesto sospeso, CFCF.

### $DFB6 — evento narrativo cassaforte

Intestazione: `07 f0`.

- Argomento 1: classe 7 — entità senza ulteriore filtro di questa classe.
- Argomento 2: classe 0 — nessuno.

