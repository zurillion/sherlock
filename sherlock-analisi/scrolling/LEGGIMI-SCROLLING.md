# Scorrimento e MORE: regole originali di Sherlock

Analisi di Sherlock ZX Spectrum v2.0, payload `block-10.bin`, SHA-256 `c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407`. Indirizzi esadecimali; quantità e contatori decimali. Le prove eseguono le istruzioni originali, con input controllati e osservazione di registri, memoria e bitmap. Non sono deduzioni dal renderer JavaScript.

## Risultato principale

La finestra superiore contiene **18 righe fisiche**, ma il MORE **non attende che siano tutte occupate**. Prima di ogni avanzamento di riga, il renderer confronta il contatore condiviso `$A019` con **15**. Se è 15, si ferma prima di effettuare quell’avanzamento.

Sono conteggiati i ritorni a capo effettivamente eseguiti nel canale superiore: CR espliciti, word wrap, esaurimento delle colonne e righe vuote. Non sono conteggiati parole, caratteri totali, righe visibili o comandi come unità astratte. Il testo soppresso dal filtro d’uscita `$C1E1` non raggiunge questo contatore: contano soltanto i caratteri realmente inviati al canale superiore.

La traccia dall’avvio riproduce esattamente l’osservazione: **15 righe di testo visibili e MORE prima dell’a capo finale del saluto di Watson**. A quel punto ci sono ancora tre righe vuote sopra il testo. La pausa non segnala che si sta per perdere testo: è una soglia di paginazione distinta dallo scorrimento fisico.

## Il contatore e il punto della pausa

La routine del canale superiore comincia a `$C2BA`. Il percorso comune di avanzamento è `$C2CA`:

```asm
C2CA: LD A,($A019)
C2CD: CP $0F
C2CF: JR NZ,$C2D6
C2D1: CALL $C306       ; MORE: prima dello scroll pendente
C2D4: LD A,$FF
C2D6: INC A
C2D7: LD ($A019),A
```

Segue lo scorrimento fisico, chiamato a `$C2DF` tramite `$C316`. Il listato completo con tutti gli operandi intermedi è in `results/scrolling.asm`.

Dopo il tasto MORE, `$FF` più `INC A` diventa **0**, non 1. L’avanzamento rimasto pendente viene quindi eseguito lasciando il contatore a zero. Con 49 CR consecutivi e nessun azzeramento esterno, le pause avvengono prima delle richieste **16, 32 e 48**:

| Richiesta di avanzamento | Contatore prima | Esito |
|---|---:|---|
| 1–15 | 0–14 | Scroll; contatore 1–15 |
| 16 | 15 | MORE, poi scroll e contatore 0 |
| 17–31 | 0–14 | Scroll; contatore 1–15 |
| 32 | 15 | MORE, poi scroll e contatore 0 |

Cambiare semplicemente la soglia web da 18 a 15 non riprodurrebbe questa macchina a stati, gli azzeramenti del parser e i CR iniziali/finali.

## Perché all’avvio si vedono proprio 15 righe

L’apertura originale della stanza e il saluto producono 16 richieste di avanzamento:

| Richiesta | Contenuto già scritto sulla riga corrente | Contatore prima |
|---|---|---:|
| 1 | Nessun testo: CR iniziale | 0 |
| 2–14 | Le 13 righe della descrizione iniziale | 1–13 |
| 15 | `Watson looks up from the paper and` | 14 |
| 16 | `says " Good morning Holmes. "` | 15 |

La richiesta 16 proviene dal termine del testo `$6DEB`, durante il turno di Watson, al tick 1 e alle 08:00am. Si entra in MORE con 15 scroll già effettuati. La riga vuota inferiore compare solo dopo il tasto che autorizza l’avanzamento pendente.

La schermata `results/boot-more-01.png` è generata **direttamente dalla RAM video nativa** a quella pausa, con la fase invertita del FLASH. Non è ricomposta con font o impaginazione web. Il JSON conserva anche tutte le 18 righe e i registri del cursore.

Dopo questa pausa l’avvio originale arriva al primo prompt nel tick seguente, alle 08:01am. Il prototipo conserva invece la scelta già richiesta dell’avvio gratuito alle 08:00am: questa differenza di calendario non determina la soglia MORE.

## Cosa fa avanzare una riga

Tre percorsi convergono in `$C2CA`:

1. Un CR esplicito, valore 13, ricevuto da `$C2BA`.
2. Un CR aggiunto dal buffer parola `$A9B7`, quando la parola non entra nelle colonne rimaste. Il ramo di wrap è `$A9EF`.
3. Una riga riempita esattamente: dopo il glifo, `$C2F4` decrementa le colonne residue e `$C2F5` salta al percorso comune se sono diventate zero.

Anche una riga vuota conta. La prova isolata che stampa esattamente 36 caratteri raggiunge già contatore 1; un successivo CR, senza altri caratteri, lo porta a 2. Non si può quindi ricavare il contatore contando solo le righe non vuote sullo schermo.

L’orologio usa direttamente il renderer dei glifi tramite `$C1A8`: non incrementa `$A019`. Il canale inferiore `$C1FD`, usato per prompt, input, errori e chiarimenti, ha uno scroll separato e non incrementa il contatore superiore.

## Quando si azzera

Il contatore è condiviso da tutto il testo narrativo, ma ci sono azzeramenti espliciti. Nel payload le quattro scritture dirette `LD ($A019),A` sono `$A29C`, `$C12A`, `$C2D7` e `$D71A`. Nelle tracce complete osservate non sono emerse altre scritture indirette su questo byte.

| Punto | Effetto |
|---|---|
| `$D719` / scrittura `$D71A` | Azzera prima della tokenizzazione, dopo il preflight lessicale; richiama poi `$C142` |
| `$C129` / scrittura `$C12A` | Azzera passando al testo stretto di 18 colonne |
| `$A296` / scrittura `$A29C` | Invia 18 CR e azzera dopo ciascuno, per liberare l’area grafica |
| `$C2D7` | Aggiorna il contatore per ogni avanzamento; lo porta a 0 dopo MORE |

**`$C142`, che passa a 36 colonne, non azzera il contatore.** Azzera il modo stretto e ripristina cursore e colonne. Il ritorno al prompt e il semplice ingresso nell’editor `$D898` non sono di per sé azzeramenti.

La distinzione fra errori conta: `OPEN DOR` viene respinto nel preflight, senza raggiungere `$D719`, e conserva il contatore. `PICK THE NOTE UP`, con parole riconosciute ma sintassi rifiutata, passa dalla tokenizzazione e lo azzera. Entrambe le risposte inferiori non producono avanzamenti del canale superiore.

La pulizia `$A296` azzera **dopo**, non prima, di ciascun CR. Se entra con contatore già a 15, il suo primo CR può ancora richiedere MORE; le prove coprono anche questo caso limite.

## Quanto è cumulativo rispetto ai comandi

Il contatore non viene azzerato alla fine di ogni messaggio, frase, azione o turno NPC. Tutti i testi successivi condividono il valore fino a uno degli azzeramenti sopra elencati.

- Una nuova riga di input che supera il preflight normalmente lo azzera nel parser, prima dell’esecuzione.
- Più azioni nella stessa riga, come `LOOK. LOOK`, condividono quell’unico azzeramento.
- L’uscita degli NPC durante un comando lungo si somma a quella del giocatore. La traccia include un MORE nel racconto di Watson durante WAIT.
- Il WAIT automatico per inattività non passa dalla nuova tokenizzazione. Nella prova del timeout originale con 3000 scansioni, il contatore passa da 2 a 4 senza azzeramenti del parser.
- Un errore lessicale non azzera il valore precedente. Il quantitativo di testo visibile può quindi dare un’impressione diversa dal numero contato per la pausa.

Misure di una sequenza concreta, nella stanza iniziale senza immagine:

| Fase | Contatore entrata → uscita | Avanzamenti superiori | MORE | Azzeramenti `$D71A` |
|---|---|---:|---:|---:|
| Avvio | 0 → 0 | 16 | 1 | 0 |
| WAIT | 0 → 2 | 2 | 0 | 1 |
| WAIT successivo | 2 → 2 | 2 | 0 | 1 |
| OPEN DOR | 2 → 2 | 0 | 0 | 0 |
| LOOK | 2 → 14 | 14 | 0 | 1 |
| LOOK. LOOK | 14 → 12 | 28 | 1 | 1 |
| PICK THE NOTE UP | 12 → 0 | 0 | 0 | 1 |
| Timeout dopo un altro WAIT | 2 → 4 | 2 | 0 | 0 |

I conteggi del testo dipendono dalla scena, dalla larghezza e dalle risposte degli attori. La regola del contatore è invece quella del codice. La tabella non attribuisce 14 righe a qualunque LOOK del gioco.

## Finestra fisica e immagini

`$C316` sposta il contenuto di **8 pixel verso l’alto**. Copia 17 righe di caratteri e svuota l’ultima: è quindi una finestra fisica di **18 righe**, da y=0 a y=143. La barra è a y=144–151 e le cinque righe inferiori a y=152–191.

In modo largo copia 32 byte per riga pixel, cioè 256 pixel; sposta inoltre 17 righe di attributi. In modo stretto copia 16 byte, cioè i 128 pixel a sinistra, e conserva gli attributi. La pulizia inferiore avviene stampando 36 o 18 spazi con glifi di 8 pixel e passo di 7: il test misura anche l’esatto tratto cancellato, x=2–254 o x=2–128 inclusi. Le copie fisiche e il contatore sono separati: una chiamata isolata a `$C316` non cambia `$A019`.

`$C129` prepara le 18 colonne a sinistra dell’immagine e azzera il contatore. Quando arriva MORE, `$C306` richiama `$C142`: il testo torna a **36 colonne prima dello scroll pendente**. Quello scroll si applica quindi all’intera larghezza, compresa la parte con l’immagine. Non esistono due contatori di paginazione distinti per testo e immagine.

## Il segnale MORE

`$C306` imposta il bit FLASH dell’attributo `$5A5F`: ultima cella 8×8 della barra, x=248, y=144. Chiama `$C415` per attendere un tasto, cancella il bit FLASH e ritorna al modo largo. La bitmap della cella non viene sostituita; l’hardware Spectrum alterna inchiostro e carta del motivo già presente.

Il tasto MORE è consumato dalla routine d’attesa. Non è un nuovo comando, non passa dal parser e non incrementa il tempo del mondo. Nelle prove vengono osservati il valore nativo `$F8` dell’attributo durante la pausa e il passaggio successivo al modo largo.

## Limiti del prototipo al momento dell’analisi

Il renderer JavaScript esaminato in questa analisi usava una disponibilità di scroll ricavata dall’altezza di 18 righe (`scrollAllowance`), concedeva 18 scroll dopo MORE e applicava la pausa quando perderebbe una riga. **Questa regola non è quella originale.** Inoltre l’uscita ricevuta viene normalizzata e privata dei CR iniziali/finali; il separatore vuoto è aggiunto dalla presentazione.

Per allinearlo occorre rappresentare il contatore `$A019` e i suoi azzeramenti, conservare i CR realmente emessi e distinguere pausa, avanzamento pendente e copia fisica. Vanno inclusi gli avanzamenti automatici a esaurimento delle colonne e il passaggio 18→36. Il criterio non può dipendere dal solo numero di righe occupate né da un generico “fine comando”.

La consegna originaria conteneva l’analisi e gli strumenti di riferimento. Le tracce sono state poi usate per correggere e verificare la pagina, come indicato nella sezione finale di questo documento.

## File e verifiche

- `trace_scrolling.py`: avvio reale, sequenze di input, timeout originale e fixture isolate del renderer.
- `verify_scrolling.py`: 18 controlli su soglia, azzeramenti, CR, modalità stretto/largo, FLASH e copie reali della bitmap.
- `build_scrolling_listing.py`: 590 istruzioni e dati espliciti; **1087 byte** ri-assemblati e confrontati identici al payload.
- `results/scroll-traces.json`: eventi, contatori, attori, puntatori di testo e righe visibili.
- `results/verification.json`, `results/listing-verification.json`: risultati delle verifiche.
- `results/boot-more-01.png`: prima pausa nativa, prima dell’a capo finale del saluto.

Le fixture che impostano un contatore, un modo video o una bitmap di prova sono dichiarate e separate dalle esecuzioni di gameplay. Non vengono alterate le istruzioni Z80 del gioco. I tasti vengono forniti ai punti d’ingresso della tastiera; per il timeout vengono eseguiti ROM e interrupt con la sola accelerazione delle ripetizioni HALT già verificata nell’analisi del main loop.

## Integrazione successiva nella pagina

La regola analizzata qui è ora implementata nel terminale web, inclusi gli azzeramenti del parser e la preparazione delle figure. Vedere [SCROLLING-WEB.md](../locazioni/SCROLLING-WEB.md) per il protocollo e i confronti automatici delle schermate JavaScript con il renderer Z80. Le tracce di questo dossier restano il riferimento originale indipendente.
