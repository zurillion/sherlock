# Stato corrente del gameplay

Aggiornato il 22 ottobre 2026 sulla baseline `fc50b3c`. L’inventario di riferimento è [BACKLOG-GAMEPLAY.md](BACKLOG-GAMEPLAY.md), con 19 voci ordinate e criteri di completamento. Gli ID G01–G19 permettono di scegliere il prossimo lavoro.

Il prototipo esegue il codice Z80 originale attraverso SkoolKit: parser, semantica, regole, scheduler di tutti i 24 attori, dialoghi, contenimento, veicoli e calendario. Non è ancora un motore di gioco tradotto interamente in Python. Non va chiamato “mancante” ciò che è soltanto non studiato o non coperto da una prova.

## Lacune accertate

- **SAVE/LOAD:** nessun salvataggio su disco della sessione. SAVE è bloccato; LOAD viene invece classificato come QUIT e termina la partita. La precedente indicazione che LOAD fosse bloccato senza effetti era inesatta.
- **Inattività e PAUSE:** al prompt non scatta il WAIT automatico; PAUSE è bloccato. L’originale ha un timeout fra tasti, circa 60 secondi nelle tracce, che cancella la riga incompleta e avvia WAIT.
- **Input:** 70 caratteri sono un limite del ponte/UI. Una riga di 74 caratteri esegue LOOK nel banco originale. Buffer dei token e anomalie del dizionario hanno protezioni separate.
- **PRINT/NOPRINT:** esclusi; manca un equivalente esportabile della trascrizione.
- **Presentazione:** reload ricompone la scena senza conservare il video esatto; la mappa non avanza i marker a ogni lotto/minuto di WAIT UNTIL. Alcune scorciatoie e dettagli dell’editor sono semplificati.

## In esecuzione, ma non certificato integralmente

Le prove coprono cab, Watson, la prima parte dell’itinerario di Lestrade con treni e Straker, continuazioni, travestimenti, percezione e diversi comandi ordinari. La morte e il gateway di vittoria hanno prove dedicate; la vittoria usa uno stato sintetico dichiarato. Manca una partita completa ripetibile dall’avvio alla soluzione con soli comandi normali.

Restano da approfondire informazioni/alibi/accuse e deduzioni; scene tarde e altri NPC; tutti i percorsi ferroviari del giocatore; indizi e script speciali; notte, luce e riposo; combinazioni avanzate di oggetti, peso e contenitori. Questi percorsi non sono per questo disabilitati nel motore attuale.

## Audit e riferimenti

L’audit corrente contiene 70 comandi su VM isolate, un inventario dei 54 modelli lessicali e confronti mirati con un banco Z80 indipendente. I risultati sono in `results/gameplay-audit.json`, `gameplay-edge-comparisons.json`, `gameplay-action-inventory.json`. Non è stata modificata la partita aperta nel browser.

Le anomalie del manuale o del gioco originale (ATTACK/DRIVE, PICK, alcune esclusioni ALL EXCEPT, modelli LOCK/UNLOCK senza regole iniziali) sono tenute separate dai difetti del prototipo. Vedere il backlog per le riproduzioni e le cautele.

Le scelte concordate — avvio gratuito alle 08:00am, SVG, mappa di analisi, cadenza di presentazione e inserimento in coda — non vengono riclassificate automaticamente come errori. Il MORE ora usa il contatore originale: vedere [SCROLLING-WEB.md](SCROLLING-WEB.md).

Riferimenti specifici: [AI-WEB.md](AI-WEB.md), [CAB-WEB.md](CAB-WEB.md), [ATTESE-E-FINE-PARTITA.md](ATTESE-E-FINE-PARTITA.md), [COMPATIBILITA-SPECTRUM.md](COMPATIBILITA-SPECTRUM.md). Alcuni dossier di fasi precedenti conservano descrizioni storiche ormai superate: per l’inventario corrente usare il backlog.
