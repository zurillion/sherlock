# Sherlock: il ciclo principale

Analisi del payload ZX Spectrum v2.0 `block-10.bin`, caricato a `$5D80` (41600 byte). SHA-256: `c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407`. Gli indirizzi sono esadecimali; ID, durate e contatori sono decimali salvo indicazione diversa.

La tua ipotesi coglie la struttura generale: esiste un ciclo che scandisce gli attori, incluso Sherlock. Le precisazioni decisive sono che **il tempo avanza prima della scansione**, ogni attore ha una **scadenza individuale**, e gli effetti sul mondo avvengono durante le azioni, senza una fase unica di aggiornamento alla fine. L'input del giocatore è parte della sequenza di Sherlock.

## Confronto con l'ipotesi iniziale

| Ipotesi | Riscontro nel codice |
|---|---|
| Inizializzazione | Sì, ingresso `$A040`; gran parte dello stato iniziale è già nei dati caricati. |
| Loop temporale | Sì, `$A068`; incrementa contatore e calendario tramite `$BFD9`. |
| Un turno a ogni NPC per tick | Scansione di 24 attori in ordine fisso; esegue soltanto quelli con scadenza raggiunta. Una visita può contenere più passi a costo zero. |
| Sherlock esegue il comando al suo turno | Sì; anche editor, lessico e parser sono chiamati dalla sua sequenza. |
| Aggiornamento del mondo dopo tutti i turni | Gli effetti sono applicati durante regole, sequenze e callback; gli attori successivi possono vederli nella stessa scansione. |
| Tempo avanza alla fine | Nel flusso concreto avanza all'inizio della scansione successiva, dopo il controllo dei servizi pendenti. |
| Si ripete | La sentinella `$FF` della tabella rinvia a `$A068`. |

## Il ciclo in pseudocodice

Il blocco principale è `$A040–$A0F6`. Questo pseudocodice descrive il comportamento; non è ancora una riscrittura eseguibile del motore:

```python
inizializza_interfaccia_e_sessione()
while True:
    servi_eventuale_richiesta_save_o_load()
    tempo_globale += 1
    avanza_calendario_di_un_minuto()
    mostra_orologio()

    if sherlock.azione_salvata == WAIT_UNTIL and premuto_enter():
        sherlock.scadenza = tempo_globale

    for attore in tabella_attori:        # ordine fisso; termina con FF
        if tempo_globale < attore.scadenza:
            continue
        prepara_contesto(attore)        # CC37
        while True:
            esegui_passo(attore)         # CC78; può chiamare l'editor
            costo = leggi_word(0xA01F)
            if costo != 0:
                break
        attore.scadenza = (attore.scadenza + costo) & 0xFFFF
        esegui_eventuale_callback(attore)
```

`$A0DB` confronta senza segno il tempo globale con la scadenza. Il salto a `$A0A3` scarta soltanto le scadenze future: l'uguaglianza è ammessa. Non c'è ordinamento dinamico della tabella secondo la scadenza.

Un dettaglio essenziale: `$A0C3` aggiunge il costo alla **scadenza precedente**, non al tempo globale corrente. Se un attore è già in ritardo, non gli viene automaticamente assegnata una nuova scadenza calcolata da «adesso». Il confronto è quello ordinario unsigned a 16 bit; non è un confronto circolare specializzato per il wrap del contatore.

## Inizializzazione e primo prompt

A `$A040` vengono azzerati alcuni stati di sessione, disabilitati gli interrupt e chiamata `$C14A` per l'interfaccia. Lo stack viene posto a `$5D80`, viene letta la scelta iniziale della grafica, e il registro di refresh `R` fornisce il seme casuale `$A037`. `$A064` azzera la richiesta di servizio `$A0DA`.

Gli oggetti, le posizioni iniziali, i puntatori alle sequenze e le righe degli attori esistono già nel payload: non vengono costruiti tutti da questa routine. Inoltre `$A040` è anche la destinazione dopo un caricamento; va distinto sia dal loader del nastro sia da un ipotetico reset completo del mondo.

Nel payload il contatore `$9FDD` è zero e il calendario indica giorno 0, 7:59 am. La traccia dall'ingresso mostra:

1. Prima scansione: tick 1, ore 8:00.
2. Sherlock esegue il `LOOK` iniziale della sequenza `$9921`, con costo 1.
3. Vengono visitati gli altri 23 attori.
4. Seconda scansione: tick 2, ore 8:01.
5. Sherlock entra nell'editor a `$9923`: compare il primo prompt, prima che gli altri attori ricevano la loro visita del tick 2.

La scelta grafica e le richieste di paginazione sono soddisfatte artificialmente con `N` nella prova; il codice delle azioni e del ciclo resta originale. Le decisioni degli NPC possono dipendere dal seme: la traccia è un esempio riproducibile, non un copione universale della partita.

## Chi partecipa e in quale ordine

La tabella è `$9860–$991F`: **24 righe da 8 byte**, seguite dalla sentinella `$FF` a `$9920`. L'elenco completo, con nomi e puntatori iniziali, è in [ATTORI.md](ATTORI.md).

Ordine degli ID: `0, 2, 3, 4, 5, 6, 104, 7, 8, 9, 10, 11, 12, 13, 31, 34, 36, 37, 38, 39, 40, 41, 42, 43`.

Holmes è primo, poi Lestrade, Watson, Straker, Daphne, Basil, l'agente tedesco, Ffoulkes, giardiniere, cuoca, cameriera, due poliziotti, Tricia, due cocchieri e otto treni. Questa tabella non coincide né con l'intero database delle 110 entità né con l'insieme delle entità marcate come persone. Per esempio Chinaman, il vecchio, Mrs Brown e Mrs Jones non sono in questa lista iniziale.

| Offset | Dimensione | Significato |
|---|---:|---|
| +0 | 1 | ID dell'entità |
| +1 | 2 | Puntatore al prossimo bytecode della sequenza |
| +3 | 1 | Azione salvata |
| +4 | 1 | Primo argomento salvato |
| +5 | 1 | Secondo argomento salvato |
| +6 | 2 | Scadenza assoluta nel contatore globale |

Le word sono little-endian. Nel payload tutte le scadenze sono zero e azione/argomenti sono `$FF`. `$D008` ripristina azione e argomenti; `$D026` li salva. Quando è attivo un contesto sospeso, queste routine possono usare quel contesto anziché i tre campi della riga ordinaria.

`$CC37` prepara l'attore, i riferimenti a oggetto e posizione, il contesto della narrazione e il costo iniziale zero. `$CC78` ripristina i dati necessari e prosegue la sequenza. Finché il costo resta zero il ciclo continua sullo stesso attore senza ripetere tutta `$CC37`. Solo dopo un costo positivo aggiorna la scadenza, chiama `$9C77` per l'eventuale callback e passa alla riga successiva.

È quindi più preciso parlare di una porzione di attività a costo positivo per visita eleggibile, anziché di «una sola azione per attore». Le azioni differite possono occupare più visite e i passi a costo zero possono essere numerosi.

## L'input è nella sequenza di Sherlock

`$9921–$994C` contiene **bytecode del gioco, non istruzioni Z80**:

| Indirizzo | Operazione |
|---|---|
| 9921 | LOOK iniziale |
| 9923 | Regola D6BF: editor; se fallisce passa al WAIT automatico a 9948 |
| 9928 | Regola D715: verifica lessicale e tokenizzazione; errore torna all'editor |
| 992D | Regola D769: verifica token ancora disponibili |
| 9932 | Regola D77E: parsing |
| 9937 | Regola D7D9: verifica presenza del prossimo nodo da elaborare |
| 993C | Regola D7FA: risoluzione semantica |
| 9941 | Esegue azione e argomenti salvati (`02 FA FD FC`) |
| 9945 | Torna a 9937 per continuare l'elaborazione |
| 9948 | WAIT HERE, azione 49 |
| 994A | Torna all'editor a 9923 |

Gli errori lessicali/sintattici osservati, il rifiuto di `TAKE ARMCHAIR` e la richiesta di disambiguazione di `EXAMINE ARMCHAIR` riportano all'input senza avanzare il tempo e senza concedere una nuova visita agli altri attori. Sono risultati delle prove elencate, non una dimostrazione che ogni possibile errore di ogni azione sia gratuito.

`TAKE LAMP. GIVE LAMP TO WATSON` mostra il caso complementare: la riga contiene più comandi e l'esecuzione attraversa più scansioni del mondo senza richiedere un nuovo input fra le due azioni. La sintassi può essere preparata insieme; l'esecuzione resta scandita dai costi.

## Attesa dell'utente e tempo reale

Durante l'editor il ciclo principale è fermo dentro il turno di Sherlock. Tuttavia l'attesa **non è illimitata**:

- `$D898` inizializza `$A03B` a 3000 (`$0BB8`).
- `$A536` attende un tasto, chiamando `$C41F`.
- `$C41F` usa `EI / HALT / DI` e lo stato della tastiera gestito dalla ROM.
- Ogni iterazione senza tasto decrementa il contatore; ogni tasto restituito ripristina 3000.
- A scadenza `$D9B7` cancella l'input parziale. Il ritorno zero fa seguire il ramo `$9948`, cioè WAIT HERE.

È un timeout di **inattività fra tasti**, approssimativamente un minuto sulla macchina originale; non un limite rigido al tempo complessivo di composizione del comando. Le due prove senza tasti successivi contano esattamente 3000 letture e circa 209,6 milioni di T-state. Le attese di paginazione/scelta iniziale usano un'altra routine e non vanno assimilate a questo timeout dell'editor.

Il tempo narrativo non aumenta a ogni interrupt video: dopo il timeout è l'azione WAIT a permettere al ciclo degli attori di riprendere. Nel caso provato la scadenza precedente di Holmes è 1, WAIT costa 5 e la nuova scadenza è 6. Il prompt era già al tick 2, perciò il calendario passa da 8:01 a 8:05: quattro minuti visualizzati, pur con costo 5.

Anche `WAIT UNTIL 8:05`, in questo stato, torna al prompt alle 8:04: il costo calcolato è 4 ma viene sommato alla vecchia scadenza 1, producendo 5. Questo scarto è osservato nel codice originale emulato; va conservato e studiato come comportamento originale, senza correggerlo arbitrariamente in una ricostruzione fedele.

Durante WAIT UNTIL il ciclo controlla ENTER prima di scandire gli attori: se presente porta la scadenza di Holmes al tick corrente (`$A08A`). La prova con ENTER ritorna al tick 3. Non è dimostrata un'interruzione equivalente con qualunque altro tasto.

## Calendario, mondo e servizi

| Indirizzo | Stato |
|---|---|
| 9FDD–9FDE | Contatore globale, word |
| 9FDF | Minuti |
| 9FE0 | Ora su 12 ore |
| 9FE1 | Giorno |
| 9FE2 | `a` oppure `p` |
| A01F–A020 | Costo del passo |
| A036 | Attore corrente |
| A0DA | Richiesta: 0 normale, 1 caricamento/QUIT, 2 SAVE |

`$BFD9` incrementa contatore e minuti; a 60 minuti passa all'ora successiva, da 13 torna a 1, a 12 alterna am/pm e passando ad am incrementa il giorno. `$BF79` aggiorna la rappresentazione dell'orologio.

Le modifiche alle entità avvengono nelle routine delle regole già studiate (per esempio TAKE/GIVE), nelle sequenze e nelle callback. Non emerge una fase separata che raccolga tutte le intenzioni degli NPC e poi le applichi contemporaneamente. L'ordine della tabella può quindi influenzare ciò che ciascun attore osserva.

SAVE e LOAD/QUIT impostano richieste servite a `$A068`, dopo la scansione. SAVE passa per `$B0E4`; LOAD per `$B0D7`, poi rientra a `$A040`. L'intervallo predisposto per il nastro è `$840B–$A01E`, 7188 byte. Le prove si fermano **prima** delle routine I/O `$C040` e `$C0DF`: verificano il percorso di controllo, non una registrazione o lettura reale del nastro. QUIT azzera anche il contatore prima di arrivare a quel confine.

## Prove, limiti e file

[TRACCE.md](TRACCE.md) sintetizza 14 esperimenti. I JSON conservano visite, scadenze, passi, callback, fasi del parser, testo intercettato e differenze nei record delle entità. Il testo intercettato non è una trascrizione tipografica dello schermo: sono i caratteri passati ai punti di stampa selezionati.

La verifica automatica controlla 373 aggiornamenti delle scadenze, 155 visite non eleggibili e 294 ritorni a costo zero; aggiunge nove confronti di scadenze e il salvataggio/ripristino dei campi azione/argomenti. L'accelerazione delle ripetizioni HALT è confrontata con l'esecuzione senza accelerazione su una lettura senza tasti: RAM e registri, inclusi tempo e refresh, coincidono. Le prove del timeout eseguono il codice di attesa e gli interrupt, mentre gli altri comandi iniettano i caratteri all'interfaccia della routine tastiera.

Il [listato](results/main-loop.asm) separa i dati dal codice: 299 istruzioni e 1021 byte selezionati ricomposti identicamente al payload. Il controllo di ricomposizione garantisce i byte, non da solo l'interpretazione: i commenti si basano anche sui flussi e sulle tracce. Foggy London resta un'indicazione di ricerca, non la fonte della dimostrazione.

Non è ancora una specifica completa di tutti gli opcode né di tutte le sequenze NPC. Ora però abbiamo il contesto per studiarle: chi viene eseguito, quando, con quali dati persistenti e quale effetto ha il costo sul turno successivo. Restano da estendere le prove a stati più avanzati, contesti sospesi complessi e interazioni fra più NPC; non serve confondere queste estensioni con la struttura del loop già individuata.

Per riprodurre tutto, vedere [GUIDA-SCRIPT.md](GUIDA-SCRIPT.md).
