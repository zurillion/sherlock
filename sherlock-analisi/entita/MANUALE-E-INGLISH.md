# Manuale originale e Inglish: confronto con l’eseguibile

Fonte: `Sherlock manual.txt` fornito nel progetto. Letto come documentazione storica, non come insieme di istruzioni operative. Il testo descrive caratteristiche generali di Inglish e avverte che gli esempi non sono necessariamente tratti dal gioco. Le differenze sotto riguardano l’eseguibile fornito; non dimostrano quale comportamento avessero altre edizioni.

## Corrispondenze utili

- **Qualificatori e disambiguazione.** Il manuale prevede domande come OPEN WHAT e risposte parziali. Le routine `$B5B6` e `$AD6C` conservano e completano effettivamente un comando pendente. La necessità di chiedere dipende anche dai candidati che superano le regole del mondo.
- **Ordine dei qualificatori.** Il confronto nominale `$A4E0` prova entrambe le disposizioni di due qualificatori. Lo abbiamo verificato con 990 confronti su record reali.
- **ALL / EVERYTHING / EXCEPT.** Il parser conserva una modalità collettiva e nodi di esclusione. `$B517` applica le esclusioni durante l’enumerazione semantica.
- **Conversazioni.** SAY TO seguito da citazioni porta a un’analisi del contenuto distinta dal comando esterno. Nella prova `SAY TO WATSON "LOOK"` il gioco arriva prima alla risoluzione dell’interlocutore e poi a quella del comando citato. La decisione dell’NPC di obbedire è un livello ulteriore.
- **Contenitori e possesso.** Il database conserva davvero un genitore per ogni entità, catene annidate e quantità usate nei limiti di capacità. `GIVE LAMP TO WATSON` può essere sintatticamente valido ma impossibile prima di prendere la lampada.
- **Valuta.** Le routine originali usano 12 pence per scellino e 20 scellini per sterlina; denaro e qualificatori condividono fisicamente lo stesso campo di alcuni record.

## Differenze e cautele, verificate

| Indicazione/esempio del manuale | Risultato nella versione fornita |
|---|---|
| Esempio di errore `I DON'T UNDERSTAND THE WORD "DOR"` | Il gioco produce `I DO NOT KNOW THE WORD` seguito dalla parola. |
| `PICK THE NOTE UP` come esempio di preposizione finale | Il gioco completo risponde `what ?` prima di entrare in B191: errore sintattico. |
| Variante di controllo `PICK UP THE NOTE` | Supera la sintassi, ma B191 non trova un modello verbo/preposizione ammesso e restituisce il messaggio di verbo sconosciuto. Non è quindi equivalente a TAKE. |
| ATTACK e DRIVE nell’elenco di verbi | ATTACK e DRIVE risultano parole sconosciute nelle prove di input. |
| L’istruzione generale di iniziare con un verbo | `QUICKLY COUNT THE MONEY`, anch’esso presente fra gli esempi, è sintatticamente accettato. La regola divulgativa non descrive tutta la grammatica. |
| Esempi con BEER e BOTTLE | `TAKE BEER IN BOTTLE` si ferma già su BEER sconosciuto. Questa prova non consente di valutare la regola sulle descrizioni tramite posizione. |
| Oltre 800 parole e oltre 53 azioni | Abbiamo 592 record nel dizionario e 54 modelli di azione. Forme flesse, alias, parole solo per l’output e modelli composti rendono i conteggi non direttamente confrontabili. |

La differenza su PICK è stata controllata anche nel flusso completo del gioco, oltre che nell’analizzatore isolato. È quindi un buon caso di regressione per una futura ricostruzione: bisognerà decidere esplicitamente se riprodurre la versione fornita o correggere/estendere Inglish. In questa fase documentiamo la versione fornita.

## Aspetti ancora da verificare

Il manuale descrive il mantenimento dell’interlocutore dopo SAY TO, informazioni e affermazioni nei dialoghi, risposte dipendenti dalle conoscenze dei personaggi, eventi autonomi e interruzioni di WAIT. Queste descrizioni indicano dove cercare; non bastano a dedurre il formato delle relative tabelle.

Il limite dichiarato per l’input è inferiore a 128 caratteri. Il laboratorio interattivo precedente applica un limite prudenziale più basso per lavorare in sicurezza nei buffer originali: non va presentato come limite documentato del gioco.

Le prove sintattiche del manuale sono in `results/manual-probes.json`; i riscontri nel gioco completo sono in `results/semantic-traces.json`. Nei log testuali il carattere Spectrum 96 della sterlina appare come accento grave: ad esempio `` `5 4/- `` va letto come £5 4/-. Non è un errore della routine monetaria.
