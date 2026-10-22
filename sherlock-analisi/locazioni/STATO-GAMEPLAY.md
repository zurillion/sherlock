# Stato del gameplay nel prototipo web

Valutazione del codice corrente dopo l'attivazione dello scheduler completo. I percorsi ordinari eseguono il codice Z80 originale attraverso SkoolKit: non sono ancora una riscrittura autonoma del gioco in Python. Questo significa che molte azioni e reazioni non ancora studiate in dettaglio possono già funzionare. Non bisogna confondere una meccanica non verificata con una meccanica che il prototipo esclude.

## Già in esecuzione

- Editor/parser, risoluzione semantica, disambiguazione, continuazioni e azioni originali.
- Record di oggetti, contenimento, possesso, porte, percezione, luce e descrizioni di locazione.
- Calendario, costi delle azioni, sequenze, callback e turni di tutti i 24 attori, Sherlock incluso.
- Ordini citati, richieste fra attori, segnali e informazioni del mondo conservati nella memoria originale.
- Cab, tariffe, pagamento e resto; treni e loro orari; movimenti autonomi dei personaggi.

Le prove automatiche coprono parti definite di questi percorsi: vedere `AI-WEB.md`, `CAB-WEB.md`, le analisi delle locazioni e i rispettivi rapporti. Le prove dell'utente sull'itinerario esteso di Lestrade sono ulteriore evidenza pratica; non sono ancora una traccia automatica di risoluzione completa del caso.

## Mancanze accertate

| Parte | Stato attuale | Conseguenza |
|---|---|---|
| Salvataggio e caricamento | SAVE e LOAD sono bloccati prima dei servizi originali. Le sessioni del server sono solo in RAM. | La partita sopravvive al ricaricamento della pagina nella stessa sessione, ma non al riavvio del server; manca un salvataggio esportabile e ricaricabile. |
| Fine partita | Non esiste un risultato applicativo distinto per morte/conclusione. `submit` cerca il prossimo prompt o interrompe su un confine escluso/limite. | Un evento terminale può essere trattato come errore tecnico e annullato, invece di terminare la partita mostrando il testo originale. |
| Attesa per inattività | Al prompt il ponte restituisce subito il controllo al browser; non viene eseguita l'attesa hardware fino al timeout. | Restare fermi davanti alla pagina non produce il WAIT automatico dell'originale. MORE e la scrittura animata restano intenzionalmente gratuiti. |
| Interruzione di WAIT UNTIL | La richiesta HTTP esegue il comando fino al prompt. L'editor web blocca nuovi comandi durante l'esecuzione; non c'è un canale per inviare ENTER al loop in corso. | Il comando può avanzare il mondo, ma manca l'interruzione anticipata prevista dal gioco originale. |
| Altri servizi | QUIT, PAUSE, PRINT e NOPRINT sono esplicitamente bloccati. | Vanno adattati al browser, se desiderati. Riavvia è già disponibile; la stampa Spectrum non è necessaria al nucleo dell'indagine. |
| Limiti del ponte | Budget massimo per richiesta, protezione del dizionario e del buffer dei token; in caso di arresto viene ripristinato il mondo precedente. | Serve distinguere un comando non eseguibile nel gioco da un limite del banco, soprattutto nelle attese lunghe e nei casi limite. |

### Prova concreta della fine partita

Nel banco separato, con una nuova `Game` e trasferimento dichiarato via mappa alla stanza 58, `OPEN WALL SAFE` raggiunge il ramo terminale già identificato nell'analisi delle regole. Il prototipo restituisce:

```text
Tape, printing and control commands are not available in this explorer.
```

L'esito è `tool_limit` e la memoria del mondo viene ripristinata integralmente. La scena originale era già documentata in `sherlock-analisi/regole/LEGGIMI-REGOLE.md`, sezione sulle casseforti, e in `results/PROVE.md`. Questo verifica una mancanza concreta per quel ramo di morte; non dimostra ancora dove terminino tutti gli altri rami di morte, sconfitta o soluzione del caso.

Il rapporto di questa ispezione è `results/gameplay-boundaries.json`: contiene anche SAVE, LOAD, QUIT, PAUSE, PRINT e NOPRINT, tutti rifiutati con ripristino dello stato. Le prove sono state eseguite in un processo separato, senza modificare la partita aperta nel browser.

## Verifiche ancora necessarie

Occorre almeno una partita completa riproducibile, dal nuovo avvio alla conclusione, usando i normali comandi e senza salti tramite mappa. Vanno registrati input, tempi, stati essenziali e testo, includendo una soluzione e rami di fallimento. La conclusione del caso e le sue condizioni devono essere identificate nel codice, senza inventare un finale nel livello Python.

Le indagini successive dovrebbero approfondire l'uso delle testimonianze e delle informazioni, le accuse e le condizioni che fanno cambiare convinzioni o comportamento agli NPC. Questi percorsi non sono disabilitati: manca ancora una specifica completa e un insieme di prove che li copra. Lo stesso vale per combinazioni avanzate di oggetti, travestimenti, buio, contenitori e ordini agli altri personaggi.

Il prototipo parte dallo snapshot del primo prompt e ricrea quello stato con Riavvia; non riproduce l'introduzione precedente. L'avvio gratuito alle 08:00am è la scelta di presentazione richiesta per la pagina. Il teletrasporto della mappa resta uno strumento di analisi: non è una regola del gameplay originale.

## Ordine proposto

1. Individuare i percorsi terminali e gestire morte, conclusione e riavvio mantenendo il testo originale, senza rollback involontario.
2. Aggiungere salvataggi/caricamenti del prototipo per conservare e riprodurre gli stati raggiunti. Il formato web può evitare l'emulazione del nastro, ma deve conservare tutto lo stato necessario, compresi contesti sospesi e punto di attesa dell'input.
3. Completare il collaudo dell'indagine con almeno una partita completa e rami di fallimento.
4. Ripristinare il timeout di inattività e l'interruzione di WAIT UNTIL, definendo anche come l'attività del browser interagisce con la pausa.

La riscrittura del motore in Python è una fase separata: avere il gameplay originale in esecuzione fornisce il riferimento con cui confrontarla.

## Riferimenti nel progetto

- `native_world.py:NativeWorld.submit`: attesa del prompt, confini esclusi, budget e rollback.
- `serve_explorer.py`: sessioni in RAM e sole route stato/comando/teletrasporto/riavvio.
- `explorer-ui.js`: invio sincrono rispetto alla partita e blocco dell'input durante una richiesta.
- `sherlock-analisi/main-loop/LEGGIMI-MAIN-LOOP.md`: timeout originale, WAIT UNTIL interrompibile e servizi SAVE/LOAD.
- `Sherlock manual.txt`: Real Time, WAIT UNTIL e comandi speciali; il manuale è un indizio, mentre il comportamento verificato deriva dalle routine e dalle tracce.
