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

Il turno del giocatore esegue ora editor, parser, disambiguazione e azioni originali. Sono verificati LOOK, direzioni, GO INTO/THROUGH, porte, TAKE, INVENTORY e WAIT. Dopo `OPEN DOOR`, rispondi `YOUR` oppure `YOUR DOOR`: il nodo pendente viene completato dal parser originale. `GO TO` conserva il significato originale e non è una scorciatoia per GO INTO. Watson, Lestrade e gli altri attori eseguono i turni originali, compresi viaggi, richieste e segnali; i comandi nastro, stampa e controllo sono bloccati con un messaggio tecnico in inglese e ripristino dello stato.

Ogni sessione browser conserva lo stato in RAM finché il server rimane attivo; le schede con lo stesso cookie condividono lo stato. “Riavvia” ripristina lo snapshot iniziale. Non c'è ancora salvataggio su disco della partita. La mappa consente di ispezionare luoghi fuori dal normale percorso di gioco, senza consumare tempo. Il salto attraverso la mappa stacca Holmes da un eventuale cab, che prosegue autonomamente.

## I nuovi script

| File | Funzione |
|---|---|
| `serve_explorer.py` | Server HTTP locale e API della pagina |
| `explorer.py` | Stato della sessione, sessione, filtro percettivo Python, stato di esplorazione |
| `native_world.py` | Turno originale del giocatore con continuazioni, chiamate di ispezione e cattura del testo |
| `extract_locations.py` | Estrazione del catalogo e dei 206 archi dal payload |
| `verify_locations.py` | Prove native e del prototipo, confronto del filtro di percezione, campioni di tutte le locazioni |
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
