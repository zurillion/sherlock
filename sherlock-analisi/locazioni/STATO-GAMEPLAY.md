# Stato del gameplay nel prototipo web

Valutazione del codice corrente dopo l'attivazione dello scheduler completo. I percorsi ordinari eseguono il codice Z80 originale attraverso SkoolKit: non sono ancora una riscrittura autonoma del gioco in Python. Questo significa che molte azioni e reazioni non ancora studiate in dettaglio possono già funzionare. Non bisogna confondere una meccanica non verificata con una meccanica che il prototipo esclude.

## Già in esecuzione

- Editor/parser, risoluzione semantica, disambiguazione, continuazioni e azioni originali.
- Record di oggetti, contenimento, possesso, porte, percezione, luce e descrizioni di locazione.
- Calendario, costi delle azioni, sequenze, callback e turni di tutti i 24 attori, Sherlock incluso.
- Ordini citati, richieste fra attori, segnali e informazioni del mondo conservati nella memoria originale.
- Cab, tariffe, pagamento e resto; treni e loro orari; movimenti autonomi dei personaggi.
- WAIT di cinque minuti, orologio aggiornato ogni minuto e WAIT UNTIL interrompibile con Invio.
- Percorsi terminali di morte/conclusione e QUIT, testo originale conservato e riavvio. Vedere `ATTESE-E-FINE-PARTITA.md`.

Le prove automatiche coprono parti definite di questi percorsi: vedere `AI-WEB.md`, `CAB-WEB.md`, le analisi delle locazioni e i rispettivi rapporti. Le prove dell'utente sull'itinerario esteso di Lestrade sono ulteriore evidenza pratica; non sono ancora una traccia automatica di risoluzione completa del caso.

## Mancanze accertate

| Parte | Stato attuale | Conseguenza |
|---|---|---|
| Salvataggio e caricamento | SAVE e LOAD sono bloccati prima dei servizi originali. Le sessioni del server sono solo in RAM. | La partita sopravvive al ricaricamento della pagina nella stessa sessione, ma non al riavvio del server; manca un salvataggio esportabile e ricaricabile. |
| Collaudo completo della fine partita | Il gateway comune e rami di morte/vittoria hanno prove dedicate; manca una soluzione completa riproducibile dall’avvio. | La gestione terminale è attiva, ma non tutte le condizioni narrative sono ancora certificate. |
| Attesa per inattività | Al prompt il ponte restituisce subito il controllo al browser; non viene eseguita l'attesa hardware fino al timeout. | Restare fermi davanti alla pagina non produce il WAIT automatico dell'originale. MORE e la scrittura animata restano intenzionalmente gratuiti. |
| Altri servizi | PAUSE, PRINT e NOPRINT sono esplicitamente bloccati. QUIT termina la partita. | Vanno adattati al browser, se desiderati. Riavvia è già disponibile; la stampa Spectrum non è necessaria al nucleo dell'indagine. |
| Limiti del ponte | Protezione per fase senza avanzamento, controllo del dizionario e del buffer dei token; un errore tecnico ripristina lo stato precedente. | Gli avvisi del prototipo sono distinti dal testo originale. Il vecchio limite totale che interrompeva le attese lunghe è stato rimosso. |

### Prova concreta della fine partita

Con una nuova `Game`, trasferimento dichiarato via mappa alla stanza 58 e `OPEN WALL SAFE`, il prototipo ora mostra il testo originale della morte e restituisce `game_over` al passaggio `$9E74`, HL=`$759C`. Lo stato resta terminale fino a Riavvia. La prova del gateway di vittoria `$9E48` usa invece uno stato sintetico esplicitamente dichiarato, non una soluzione completa del caso.

`results/gameplay-boundaries.json` documenta il comportamento **precedente** alla correzione: il ramo mortale era rifiutato come comando nastro/controllo e annullato. Per lo stato corrente usare `results/wait-endgame-verification.json` e `ATTESE-E-FINE-PARTITA.md`.

## Verifiche ancora necessarie

Occorre almeno una partita completa riproducibile, dal nuovo avvio alla conclusione, usando i normali comandi e senza salti tramite mappa. Vanno registrati input, tempi, stati essenziali e testo, includendo una soluzione e rami di fallimento. Le condizioni dei finali identificate nel codice devono essere coperte anche da queste tracce complete, senza inventare un finale nel livello Python.

Le indagini successive dovrebbero approfondire l'uso delle testimonianze e delle informazioni, le accuse e le condizioni che fanno cambiare convinzioni o comportamento agli NPC. Questi percorsi non sono disabilitati: manca ancora una specifica completa e un insieme di prove che li copra. Lo stesso vale per combinazioni avanzate di oggetti, travestimenti, buio, contenitori e ordini agli altri personaggi.

Il prototipo parte dallo snapshot del primo prompt e ricrea quello stato con Riavvia; non riesegue l’introduzione precedente. Ripresenta però descrizione e saluto di Watson già stampati prima dello snapshot, come verificato in `AVVIO-E-SALUTO-WATSON.md`. L'avvio gratuito alle 08:00am è la scelta di presentazione richiesta per la pagina. Il teletrasporto della mappa resta uno strumento di analisi: non è una regola del gameplay originale.

## Ordine proposto

1. Aggiungere salvataggi/caricamenti del prototipo per conservare e riprodurre gli stati raggiunti. Il formato web può evitare l'emulazione del nastro, ma deve conservare tutto lo stato necessario, compresi contesti sospesi e punto di attesa dell'input.
2. Completare il collaudo dell'indagine con almeno una partita completa e rami di fallimento.
3. Ripristinare il timeout di inattività, definendo come l’attività del browser interagisce con la pausa.

La riscrittura del motore in Python è una fase separata: avere il gameplay originale in esecuzione fornisce il riferimento con cui confrontarla.

## Riferimenti nel progetto

- `native_world.py:NativeWorld.submit`: attesa del prompt, confini esclusi, budget e rollback.
- `serve_explorer.py`: sessioni in RAM e route stato/comando/teletrasporto/riavvio e attese incrementali.
- `explorer-ui.js`: comandi incrementali, aggiornamenti per minuto, interruzione di WAIT UNTIL e presentazione del finale.
- `sherlock-analisi/main-loop/LEGGIMI-MAIN-LOOP.md`: timeout originale, WAIT UNTIL interrompibile e servizi SAVE/LOAD.
- `Sherlock manual.txt`: Real Time, WAIT UNTIL e comandi speciali; il manuale è un indizio, mentre il comportamento verificato deriva dalle routine e dalle tracce.
