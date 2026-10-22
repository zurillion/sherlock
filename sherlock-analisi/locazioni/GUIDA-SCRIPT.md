# Avviare l'esploratore e riprodurre l'analisi

Tutti i file sono nella nuova cartella `sherlock-analisi/locazioni`. Non sono richieste librerie esterne nuove: gli script usano Python 3, SkoolKit e i dati già presenti nel progetto.

## Aprire la pagina

```sh
cd '/Users/giovanni/Documents/Development/Sherlock rebuild'
python3 -B sherlock-analisi/locazioni/serve_explorer.py
```

Aprire **http://127.0.0.1:8766/**. Lasciare il terminale in esecuzione; Ctrl+C ferma il server. Se la porta è occupata, scegliere per esempio `--port 8767` e aprire quella porta nel browser. Il server ascolta solo sulla macchina locale.

La pagina ha tre file leggibili e modificabili: `index.html`, `style.css`, `app.js`. Va aperta attraverso il server, non con un doppio clic sull'HTML: il parser e le routine Z80 girano in Python. Dopo modifiche HTML/CSS/JS basta ricaricare; dopo modifiche Python riavviare il server.

Prova questa sequenza:

```text
LOOK
OPEN DOR
WEST
OPEN YOUR DOOR
WEST
EAST
WEST
EAST
LOOK
```

`OPEN DOR` mostra l'errore lessicale e non consuma tempo. Il primo WEST fallisce perché la porta è chiusa. Gli ingressi successivi mostrano la differenza fra forma estesa e breve; LOOK ripristina quella estesa. Poi clicca un nodo della mappa o cerca `074`: il trasferimento non avanza l'orologio.

Il turno del giocatore esegue ora editor, parser, disambiguazione e azioni originali. Sono verificati LOOK, direzioni, GO INTO/THROUGH, porte, TAKE, INVENTORY e WAIT. Dopo `OPEN DOOR`, rispondi `YOUR` oppure `YOUR DOOR`: il nodo pendente viene completato dal parser originale. `GO TO` conserva il significato originale e non è una scorciatoia per GO INTO. Watson, Lestrade e gli altri attori eseguono i turni originali, compresi viaggi, richieste e segnali; SAVE/LOAD usano ora snapshot JSON completi tramite i pulsanti web o i comandi isolati; stampa/PAUSE restano bloccati con un messaggio tecnico fuori dall’area del gioco e ripristino dello stato. QUIT termina la partita. Morte e conclusione conservano il testo originale, poi richiedono Riavvia.

Ogni sessione browser conserva lo stato in RAM finché il server rimane attivo; le schede con lo stesso cookie condividono lo stato. “Riavvia” esegue l’avvio con il seed (0–255) e il profilo selezionati. Salva partita scarica un JSON completo; Carica partita lo ripristina anche in una sessione nuova, senza rigenerare il seed. La mappa consente di ispezionare luoghi fuori dal normale percorso di gioco, senza consumare tempo. Il salto attraverso la mappa stacca Holmes da un eventuale cab, che prosegue autonomamente.

## I nuovi script

| File | Funzione |
|---|---|
| `serve_explorer.py` | Server HTTP locale e API della pagina |
| `explorer.py` | Stato della sessione, sessione, filtro percettivo Python, stato di esplorazione |
| `native_world.py` | Turno originale del giocatore con continuazioni, chiamate di ispezione e cattura del testo |
| `extract_locations.py` | Estrazione del catalogo e dei 206 archi dal payload |
| `verify_locations.py` | Prove native e del prototipo, confronto del filtro di percezione, campioni di tutte le locazioni |
| `verify_opening.py` | Avvio Z80 completo, origine del saluto di Watson e confronto della presentazione iniziale |
| `verify_wait_endgame.py` | WAIT di cinque minuti, WAIT UNTIL incrementale e interrompibile, confronto Z80 con interrupt e percorsi di fine partita |
| `verify_web_cab.py` | Corse, pagamento e resto nella pagina, ispezioni e teletrasporto, confronto indipendente con lo Z80 completo |
| `trace_movement.py` | Dodici comandi nel gioco completo, con scheduler originale e NPC attivi |
| `build_locations_listing.py` | Listato commentato con separazione codice/dati e ricomposizione identica dei byte |

I quattro comandi di analisi:

```sh
python3 -B sherlock-analisi/locazioni/extract_locations.py
python3 -B sherlock-analisi/locazioni/verify_locations.py
python3 -B sherlock-analisi/locazioni/trace_movement.py
python3 -B sherlock-analisi/locazioni/build_locations_listing.py
```

Scrivono in `sherlock-analisi/locazioni/results`. Accettano `--project PERCORSO` e `--output CARTELLA`; il server accetta `--project` e `--port`. Se si esegue una copia dei file dalla cartella di consegna anziché dalla collocazione canonica, specificare `--project '/Users/giovanni/Documents/Development/Sherlock rebuild'`.

I JSON distinguono campioni sintetici, prove del prototipo e tracce del gioco completo. Le descrizioni nel catalogo includono tutte le cinque fasce temporali; la pagina usa invece il calendario corrente attraverso il codice originale. I documenti Markdown sono il dossier consegnato: gli script rigenerano dati, prove e listato, non il testo editoriale.

## Immagini delle locazioni

Le 14 associazioni illustrate usano i file `*-straight.svg` già ricostruiti in `sherlock-analisi/grafica/immagini`, senza modificarli. L’immagine viene aggiunta al testo al primo ingresso nella sessione (anche tramite mappa) e a ogni LOOK riuscito; un semplice ritorno non la aggiunge nuovamente. I messaggi dei comandi multipli conservano ciascuno la propria locazione.

La casella **Immagini**, in alto nel taccuino, mostra/nasconde anche le immagini nella cronologia e conserva la preferenza nel browser, senza cambiare il tempo o le visite. Cliccando un’immagine si apre l’SVG completo. Al ricaricamento della pagina, il riepilogo della stanza attuale include la sua immagine, se disponibile. “Riavvia” azzera le visite ma conserva la preferenza grafica.

## Messaggi originali e continuazioni

`native_world.py:submit` conserva registri, stack e strutture del comando al prompt, fa girare il ciclo originale con tutti gli attori abilitati. Il parametro facoltativo `active_npcs` di `Game` consente ancora prove isolate; il server usa lo scheduler completo. Vedere [AI-WEB.md](AI-WEB.md). Il costo e l’orologio vengono aggiornati dal codice originale, inclusi gli eventuali passi di sicurezza della VM. Gli errori e le domande non sono più frasi sintetiche Python.

La mappa annulla un’eventuale domanda pendente; senza spostamenti manuali, puoi rispondere naturalmente con un qualificatore o con un nuovo comando. `verify_refinements.py` confronta YOUR e YOUR DOOR con una traccia indipendente del gioco completo e verifica i messaggi e gli eventi delle immagini. Avvio: `python3 -B sherlock-analisi/locazioni/verify_refinements.py`.

I nodi della mappa sono riquadri con ID e nome. La disposizione mantiene come riferimento Foggy London, allontanando i riquadri sovrapposti. **Qui** inquadra il luogo corrente, **Tutta la mappa** inquadra tutti i nodi. Zoom e ricerca permettono di leggere ed esplorare le varie componenti.

## Travestimenti e identità del giocatore

La prima riga dello scheduler rimane a `$9860`, ma l’ID del giocatore cambia con il travestimento: 0 (Holmes), 1 (China man), 100 (old man). Scheduler, posizione, contesto e filtro percettivo seguono ora l’identità attiva.

La sequenza `TAKE DISGUISE` → `CHINA` → `WEAR DISGUISE` → `CHINA` è verificata anche contro il gioco completo, insieme alla rimozione e al secondo travestimento. `verify_disguises.py` rigenera i risultati in `results/`; dettagli in `DISGUISES.md`.

## Orologio e segnaposti sulla mappa

L’orologio è a sinistra nella striscia e usa il formato inglese `Mon 08:05am`. Le frecce hanno una sigla quando la direzione reale differisce da quella suggerita dai lati/spigoli dei riquadri; UP/DOWN e uscite parallele diverse sono esplicite.

I personaggi hanno sigle e colori nei riquadri, con nomi e posizioni nella legenda. Cliccare un nome nella legenda inquadra quel personaggio; non sposta il giocatore. Watson, Lestrade, cocchieri e altri attori si spostano ai propri turni secondo i programmi originali. I segnaposti leggono lo stato corrente a ogni risposta. Dettagli e comandi di verifica in `MAPPA-PERSONAGGI.md`.


## Presentazione compatibilità Spectrum

La modalità si attiva dalla pagina. Griglia, tastiera, immagini e manutenzione sono spiegate in [COMPATIBILITA-SPECTRUM.md](COMPATIBILITA-SPECTRUM.md). Il file `app.js` è ora generato: modificare `explorer-ui.js`/`spectrum.js` e ricostruirlo con `build_compat_assets.py`.

Il servizio cab nella pagina è descritto in [CAB-WEB.md](CAB-WEB.md), con una sequenza breve da provare.

## Watson e Lestrade attivi

Vedere [AI-WEB.md](AI-WEB.md) per gli esperimenti interattivi e le dipendenze fra attori. Per riprodurre le nuove prove:

```sh
python3 -B sherlock-analisi/locazioni/verify_web_ai.py
```

Lo script verifica il comportamento del prototipo e confronta tre sequenze di input con il banco Z80 indipendente. Salva il rapporto in `results/web-ai-verification.json`.

## Attese e conclusione

```sh
python3 -B sherlock-analisi/locazioni/verify_wait_endgame.py
```

Scrive `results/wait-endgame-verification.json`. Le modifiche sono spiegate in `ATTESE-E-FINE-PARTITA.md`. Nella pagina prova `WAIT` e `WAIT UNTIL 8:10AM`: l’orologio si aggiorna ogni minuto. Durante WAIT UNTIL premi Invio o Interrompi per fermarti; davanti al MORE il tasto serve solo a continuare la lettura.

Il saluto iniziale e la sua impaginazione sono documentati in `AVVIO-E-SALUTO-WATSON.md`; `verify_opening.py` rigenera `results/opening-verification.json`.

## Scrolling e MORE originali

[SCROLLING-WEB.md](SCROLLING-WEB.md) descrive il flusso `screen_events`, la cattura prima del word wrap in `native_screen.py` e le prove contro il renderer Z80. Rigenerare prima `verify_paging.py`, poi eseguire `node verify_paging.cjs`: i confronti includono anche i punti precisi di arresto e le schermate complete.

## Inventario delle lacune del gameplay

[BACKLOG-GAMEPLAY.md](BACKLOG-GAMEPLAY.md) è l’elenco corrente, con priorità e ID G01–G19. `audit_gameplay.py` produce 70 prove isolate; `probe_audit_edges.py` controlla i casi dubbi contro un banco Z80 indipendente; `build_gameplay_inventory.py` consolida i 54 modelli lessicali e le regole iniziali. Eseguirli in quest’ordine. I report sono in `results/gameplay-*.json` e `results/GAMEPLAY-ACTIONS.md`. Le prove non usano la sessione del browser e non richiedono un riavvio del server.

## Seed, avvio e salvataggi

Il dossier [SEED-E-SALVATAGGI.md](SEED-E-SALVATAGGI.md) descrive il generatore originale, i requisiti di determinismo e la differenza dal nastro. Scegli “Originale · 08:01” per i confronti; “Descrizione gratuita · 08:00” mantiene l’avvio concordato. Si salva al prompt, anche durante una richiesta di chiarimento, dopo aver completato testo/MORE.

- `audit_random.py --project "/percorso/Sherlock rebuild" --seed 1`: traccia le estrazioni del vero avvio, prima del primo prompt.
- `verify_random.py --project "/percorso/Sherlock rebuild"`: confronta tre seed con un banco Z80 indipendente, fino a ogni byte RAM, registro CPU ed estrazione.
- `verify_saves.py --project "/percorso/Sherlock rebuild"`: confronta riprese da salvataggio, inclusi chiarimenti e cab.
- `verify_persistence_http.py --url http://127.0.0.1:8767`: verifica le API usando sessioni di prova separate su un server già avviato.
- `saved_game.py`: modulo del formato snapshot; usato dal server e dagli script. Non è un eseguibile interattivo.

Il server accetta anche `--seed 7 --start-mode original` per le nuove sessioni, prima delle scelte nella pagina.

`node verify_save_terminal.cjs` verifica il ripristino del video e del contatore MORE, compresa la riga di comando incompleta.
