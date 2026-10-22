# Il saluto iniziale di Watson

Il saluto è programmato nella sequenza dell’attore, non in una risposta al parser né nella callback degli incontri.

| Elemento | Indirizzo e contenuto |
|---|---|
| Riga iniziale di Watson nella tabella attori | `$9870`: ID 3, PC iniziale `$E72F`, scadenza 0 |
| Primo comando del programma | `$E72F`: `06 EB 6D` |
| Operazione | Opcode `$06`: stampa testo; puntatore little endian `$6DEB` |
| Gestore Z80 | `$CD95` carica HL dai due operandi; `$CD9B` chiama `$A59F` |
| Testo | `Watson looks up from the paper and says " Good morning Holmes. "` |
| Passo successivo | `$E732`: crea il contatore di lettura mediante `$E52F`, base 13 più casuale 0..4 |

## Cosa lo scatena

L’avvio reale parte alle 07:59, incrementa l’orologio alle 08:00 e visita gli attori in ordine. Holmes esegue il LOOK iniziale (`$9921`: `01 22`), poi viene visitato Lestrade, poi Watson. Watson è già nella propria poltrona, nella stanza 8, con il Daily Chronicle. Al suo primo turno esegue direttamente la stampa `$E72F`: non occorrono un saluto digitato, un esame del giornale o un timer grafico.

Subito dopo inizializza il contatore e entra nell’attesa di lettura `$E79C`. Il primo prompt viene raggiunto nel giro successivo, alle **08:01am**, tick 2. Nel prompt salvato il PC persistente di Watson è già **`$E79F`**, il contatore è stato creato e il saluto è passato. La callback `$9D13`, con i contatori degli incontri, è un meccanismo distinto: non è il punto che produce questa specifica frase.

## Perché mancava nel prototipo

Il prototipo riutilizza `parser/results/prompt.z80`, salvato al primo punto d’input `$A536`. Ricostruiva il testo iniziale chiamando la descrizione della stanza; quella routine elenca Watson e il suo giornale ma non può riprodurre una battuta del suo programma già eseguita prima dello snapshot.

Il mondo era quindi già nel periodo di lettura, ma la sua uscita iniziale era stata ricostruita solo in parte. Tornare indietro col PC dell’attore per rieseguire il saluto avrebbe anche ripetuto la creazione del contatore, alterando l’AI.

La correzione ripristina la presentazione iniziale: decodifica il testo puntato dagli operandi originali a `$E730`, usando il decoder Python già verificato, e lo aggiunge alla descrizione iniziale. Non esegue nuovamente il turno di Watson, non cambia il suo contatore, il generatore casuale o le scadenze. Il saluto compare all’avvio e con Riavvia; LOOK e l’ingresso successivo nella stanza mostrano le normali descrizioni. Dopo il primo comando o un trasferimento tramite mappa, ricaricare la pagina non reintroduce il saluto iniziale.

L’orologio della pagina conserva le **08:00am** richieste per l’avvio gratuito. Il confronto con lo screenshot originale alle 08:01am va letto tenendo conto di questa scelta esplicita del prototipo, descritta in `ATTESE-E-FINE-PARTITA.md`.

## A capo e riga vuota

La descrizione termina con un ritorno a capo; il saluto comincia sulla riga immediatamente successiva. L’avvio originale non contiene un secondo ritorno a capo che crei una riga vuota fra le due parti. Sono eventi di attori diversi emessi durante lo stesso giro iniziale, prima che il giocatore possa scrivere.

La pagina trasmette ora descrizione e saluto in un unico messaggio, separati da **un solo `\n`**. La riga vuota aggiunta dall’interfaccia a fine comando resta dopo l’intera uscita iniziale, mai tra le due parti.

## Prova riproducibile

```sh
python3 -B sherlock-analisi/locazioni/verify_opening.py
```

Lo script parte da `game-entry.z80`, esegue l’avvio originale fino al primo prompt e registra ordine degli opcode, attore, tick e testo stampato. Cattura i caratteri nel percorso dei glifi `$C2BA`, distinguendo l’andata a capo fisica da quella del testo; questo include anche gli spazi attorno alle virgolette inseriti dal renderer.

Confronta tutta la narrazione iniziale con la presentazione del prototipo e verifica che ci sia un unico a capo fra descrizione e saluto, che lo snapshot abbia già superato `$E72F`, che la decodifica non modifichi la macchina, che WAIT duri ancora cinque minuti e che LOOK, mappa e riavvio gestiscano il saluto correttamente. Il rapporto è `results/opening-verification.json`.

I riferimenti statici restano in `sherlock-analisi/ai/results/npc-ai.asm`, `SEQUENZE.md`, `sherlock-analisi/main-loop/results/main-loop.asm` e nella traccia di avvio di `main-loop/results/loop-traces.json`.

La verifica della pagina servita sulla porta 8766 è in `results/opening-browser-verification.json`, con schermata `results/avvio-saluto-watson.png`: saluto presente, nessuna riga vuota prima della battuta, prompt pronto e orologio alle 08:00am.
