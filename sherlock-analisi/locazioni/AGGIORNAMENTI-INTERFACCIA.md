# Messaggi originali, continuazioni, SVG e mappa

Questa revisione sostituisce la selezione approssimata dei comandi con l'esecuzione del turno originale del giocatore. Restano disabilitate le visite autonome degli NPC.

## Continuazioni e messaggi

Nel gioco originale `OPEN DOOR` al primo prompt produce `WHICH DOOR ?`. Sia `YOUR` sia `YOUR DOOR` completano il nodo pendente e producono `You open your door.`; non richiedono un nuovo verbo.

Le due sequenze sono state confrontate con `entita/trace_semantics.py`, che esegue il gioco completo dallo snapshot del prompt. La porta 21 risulta aperta in entrambe le esecuzioni; il contatore passa da 2 a 3 solo dopo la risposta. Le tracce sono in `results/refinement-traces.json`.

La nuova routine `NativeWorld.submit` conserva il punto di attesa, i registri e lo stack fra input. Le liste dei nodi e il campo A01B restano nella memoria del mondo. Il ciclo originale esegue editor, controllo lessicale, parser, risoluzione semantica e azioni; si saltano solo le righe degli NPC durante la scansione dello scheduler. Questo conserva anche i costi e le eventuali cessioni di tempo per il limite interno della VM.

Il testo viene catturato dai due canali di stampa del gioco. L'input digitato resta nel prompt della pagina e non viene duplicato come narrazione. Le risposte di gioco non sono tradotte in italiano. Messaggi di limite dello strumento o comandi I/O esclusi sono distinti come messaggi tecnici, in inglese, con ripristino del mondo.

Un nuovo verbo può sostituire il comando pendente secondo il parser originale. Uno spostamento manuale dalla mappa annulla la domanda in corso. Anche dopo un ricaricamento della pagina lo stato pendente rimane nella sessione del server.

GO TO conserva ora il significato del gioco: non viene trasformato artificialmente in una direzione. Sono provati anche LOOK, GO INTO/THROUGH, porte, errori, TAKE, INVENTORY e WAIT; gli NPC restano fermi e questo non costituisce una certificazione dell'intera partita.

## Griglia negli SVG

I vecchi SVG disegnavano ogni cella colore 8×8 come un path distinto. Il browser antialiasava i bordi adiacenti, lasciando sottili fessure sullo sfondo. Non erano linee presenti nelle istruzioni grafiche del gioco.

Il renderer ora unisce le celle adiacenti dello stesso colore in regioni con contorni e buchi. Le regioni colore usano bordi netti; il clip vettoriale delle linee resta invariato e indipendente. Sono rigenerati i 14 SVG straight e i 14 smooth. I centri delle celle sono confrontati con i colori dei tasselli precedenti e il clip delle linee viene confrontato separatamente. PNG e istruzioni originali non sono modificati.

## Mappa e testi

I nodi sono riquadri con ID e nome su più righe. La disposizione riprende le coordinate di Foggy London, ingrandite e corrette localmente per evitare sovrapposizioni fra i riquadri. Le frecce terminano sul bordo del rettangolo. Topologia, direzioni e passaggi restano quelli estratti dal gioco.

La mappa parte dall'area del giocatore; **Qui** la inquadra nuovamente e **Tutta la mappa** mostra tutte le componenti. Ricerca, pan, zoom e trasferimento tramite clic restano disponibili.

Sono rimossi sottotitolo, banner introduttivo, etichetta «ti trovi qui» e frase iniziale del taccuino. Il tasto ? apre la guida senza occupare l'area narrativa.
