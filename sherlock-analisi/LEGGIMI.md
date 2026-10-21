# Sherlock ZX Spectrum — prima analisi

Analisi del 19 ottobre 2026. Obiettivo: comprendere il programma Z80; nessun porting del gioco in Python avviato. Lo script Python allegato serve esclusivamente a estrarre e verificare il materiale.

## Risultato

I file forniti sono sufficienti per iniziare. SkoolKit 10.1 viene eseguito direttamente dalla distribuzione fornita, senza installazione. Gli originali non sono stati modificati. La cartella di lavoro corrente, scelta dall’utente, è `/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-analisi`. Tutti i nuovi risultati dell’analisi saranno salvati qui; i file del nastro e la distribuzione SkoolKit restano nella cartella superiore.

Sono stati verificati tutti i checksum dei blocchi, confrontati i nastri, documentato il caricatore e simulato il caricamento fino all'ingresso del programma a **$A040**. Esiste ora uno snapshot riproducibile a quel punto. Questo snapshot precede l'inizializzazione. Il successivo dossier `parser/LEGGIMI-PARSER.md` prosegue fino al prompt e ne salva uno stato inizializzato separato.

## Identita dei nastri

`SHERLOCK.TAP`: 56.104 byte. `Sherlock v2.0.tzx`: 56.313 byte.

I dieci blocchi di header/payload del TAP coincidono byte per byte con i dieci blocchi di dati standard del TZX. Quest'ultimo aggiunge due blocchi di metadati e le temporizzazioni delle pause. Non si tratta quindi di due diversi contenuti del programma. L'identita dei dati non dimostra identita dei tempi di esecuzione: lo stato del registro R puo dipendere dal caricamento.

Il nome `SHD V2.0` e presente nell'header del terzo file. I metadati del TZX dichiarano Version 2.0, 1984, Beam Software/Melbourne House e Phillip Mitchell. Sono indicazioni contenute nel file, non una verifica indipendente della storia di questa edizione. Hash SHA-256 e dettagli sono in `inventory.json`.

## Cinque file logici sul nastro

Gli intervalli sono inclusivi. I numeri di blocco si riferiscono al TAP; nel TZX aggiungere 2.

| Blocchi TAP | Nome | Byte di payload | Destinazione |
|---|---|---:|---|
| 1–2 | SHERLOCK | 23 | Programma BASIC; autoavvio alla riga 5 |
| 3–4 | sherlock | 256 | $8000–$80FF, poi copia a $5B00–$5BFF |
| 5–6 | SHD V2.0 | 7.188 | $840B–$A01E |
| 7–8 | s | 6.912 | Header: $8000; destinazione effettiva: $4000–$5AFF |
| 9–10 | p | 41.600 | $5D80–$FFFF |

Il file `p` copre anche l'intervallo occupato da `SHD V2.0`: il confronto ha verificato che quei 7.188 byte sono identici alla corrispondente porzione di `p`. La ragione storica di questo caricamento ripetuto resta da capire.

## Percorso del caricatore

Il BASIC contiene una sola riga:

```basic
5 LOAD "" CODE : PRINT USR 32768
```

Il bootstrap esegue a $8000:

```asm
DI
LD SP,$5D80
LD HL,$8000
LD DE,$5B00
LD BC,$0100
LDIR
JP $5B12
```

Questo permette al caricatore di continuare a funzionare sotto l'area che verra sovrascritta dal programma principale. A $5B12 la sequenza e:

```asm
CALL $5B30  ; carica SHD V2.0 secondo l'header
CALL $5B62  ; carica lo schermo a $4000
CALL $5B30  ; carica p secondo l'header
JP $A040    ; avvia il programma
```

`$5B30` legge un header di 17 byte, verifica esito e tipo CODE, poi usa lunghezza e indirizzo dell'header per leggere il payload. `$5B62` consuma l'header ma impone $4000 e 6912 byte per lo schermo. Entrambe passano per il wrapper `$5B8B`, che entra nella ROM a $0562 predisponendo un indirizzo di ritorno sullo stack. `$5B9A` registra 1 in $5B2F se il carry di ritorno e impostato, 2 altrimenti. I chiamanti saltano a $0000 in caso di errore.

La vista in `loader.skool` usa gli indirizzi della copia a $5B00: il suo primo tratto e esplicitamente descritto come bootstrap eseguito originariamente a $8000. Lo stato mostrato e quello dei byte sul nastro, prima che la lettura degli header sovrascriva il buffer.

## Due separazioni codice/dati gia motivate

1. **$5B1E–$5B2E:** buffer header. All'inizio contiene tipo 3, nome `MELBHOUSE ` e tre word. Non e codice: il caricatore lo usa come destinazione della lettura e ne legge i campi. `$5B2F` e invece il byte di stato del wrapper.
2. **$C190–$C1A7:** 24 byte di grafica. Il ciclo in `$C14A` li legge come sei righe da quattro byte e le ripete otto volte in orizzontale nello schermo. Un listing lineare produrrebbe qui istruzioni e salti senza significato.

Le altre regioni non analizzate non sono state classificate automaticamente come dati o codice. I control file allegati conservano queste decisioni in forma modificabile e riproducibile.

## Primo tratto del programma

A $A040 vengono azzerate $D6B8 e $A01B, chiamata la preparazione dello schermo a $C14A, ripristinato lo stack e chiamata $C415. Quest'ultima attende un carattere attraverso $C41F.

`$C41F` sincronizza la lettura con un interrupt (`EI; HALT; DI`), consulta le celle $5C3B e $5C08 dell'area di sistema e, quando disponibile, restituisce un carattere con bit 7 impostato. Il ramo senza carattere restituisce zero. `$C415` ripete la chiamata finche il bit 7 e impostato, poi lo elimina.

Il codice successivo alla chiamata confronta il carattere con `n` e `N`: salva 0 in $A011 in quei casi e 1 negli altri. Il significato di questa scelta non e ancora stabilito. Successivamente salva R in $A037: e un candidato per una fonte di variabilita, ma non abbiamo ancora dimostrato che alimenti un generatore casuale.

Le conversioni dei caratteri e il ramo con input sono dedotti dal codice; non sono stati esercitati con una pressione di tasto in questa prima prova.

## Verifiche effettuate

- Tutti gli header e payload hanno checksum XOR valido e lunghezze coerenti.
- Tutti i blocchi standard TAP/TZX sono identici.
- Il listing del caricatore, riconvertito in binario, riproduce tutti i 256 byte originali. Questo controlla la conservazione dei byte, non prova da solo l'interpretazione semantica.
- Caricamento simulato con SkoolKit, modello predefinito 48K, arresto a PC=$A040: raggiunto. SP=$5D80, interrupt disabilitati, stato loader=1.
- RAM $5D80–$FFFF uguale al payload `p`; RAM $4000–$5AFF uguale al payload `s`.
- Da quello snapshot: eseguito un limite di 1.000.000 operazioni senza input, 4.159.751 T-state (circa 1,189 secondi Spectrum); arresto al limite in $C42B, istruzione HALT. Il contatore include le attese simulate e non indica un milione di istruzioni diverse.
- La mappa contiene 140 indirizzi distinti eseguiti, di cui 89 in RAM. Nessuna istruzione a questi indirizzi presenta una decodifica diversa confrontando snapshot iniziale e finale. Questo NON esclude modifiche temporanee o automodifica altrove.
- La schermata risultante e stata ispezionata: fondo uniforme e fascia grafica, senza testo del prompt. Non si afferma quindi di aver gia raggiunto un gioco interattivo verificato.

La simulazione usa le impostazioni predefinite di SkoolKit, compreso il caricamento accelerato dove applicabile e l'assenza della simulazione della contesa. E una base per l'analisi, non una verifica dei tempi su hardware reale.

## File da consultare

- `loader.skool`: primo disassemblato commentato, con dati distinti dal codice.
- `loader.ctl`: annotazioni sorgenti del caricatore.
- `game-excerpts.skool` e `.ctl`: estratti dell'avvio, della grafica e della tastiera; gli intervalli omessi restano da analizzare.
- `game-entry.z80`: snapshot subito prima dell'istruzione a $A040.
- `startup.z80`, `startup.map`, `startup.png`, `startup.log`: prima esecuzione senza input e relativi risultati.
- `block-02.bin` … `block-10.bin`: payload estratti, senza flag/checksum del nastro.
- `inventory.json`, `snapshot-checks.json`, `tap-blocks.txt`, `tzx-blocks.txt`: evidenze e inventario.
- `reproduce.py`: ricrea estrazione e listing; con `--simulate` ripete anche caricamento, controlli sullo snapshot e prima traccia. I nomi dei file e la versione SkoolKit sono quelli di questa consegna.

Esempio, dalla cartella contenente questo dossier:

```sh
python3 -B reproduce.py '/Users/giovanni/Documents/Development/Sherlock rebuild'
python3 -B reproduce.py '/Users/giovanni/Documents/Development/Sherlock rebuild' --simulate
```

## Passo successivo

Seguire la scelta iniziale con input controllato, documentare $C10F/$C142/$C240, proseguire da $A068 fino al ciclo di lettura dei comandi e verificare visivamente l'avvio. Poi analizzare il percorso di un comando semplice. Le strutture del parser, del mondo e dei personaggi restano ancora da ricostruire.


## Aggiornamento: routine del testo

La prima analisi del testo è in `testo/LEGGIMI-TESTO.md`: dizionario a 5 bit, prefissi condivisi, suffissi, interprete delle frasi, buffer e renderer. Contiene listing commentati, 592 voci estratte, verifiche contro il codice Z80 e due prove grafiche. Il primo passo successivo indicato sopra è ora affiancato da questa indagine prioritaria richiesta dall’utente.


## Decoder Python nativo

È disponibile `decoder/sherlock_text.py`, documentato in `decoder/README.md`. Legge il TAP senza emulazione e produce il catalogo in `decoder/estratti/`: 235 ingressi/frammenti, incluse 20 descrizioni specifiche collegate ai record delle locazioni. I testi dinamici restano annotati. Sono disponibili confronti indipendenti con lo Z80.


## Aggiornamento: grafica delle locazioni

La ricostruzione è in `grafica/LEGGIMI-GRAFICA.md`. Sono decodificati 14 collegamenti a locazioni e 13 disegni distinti (2.496 byte). `grafica/sherlock_graphics.py` riproduce il motore in Python nativo: bitmap e attributi coincidono con lo Z80 per tutte le immagini e dopo 913 comandi intermedi. Include esportazioni PNG e SVG ad alta risoluzione, con le approssimazioni della vettorializzazione documentate. Aprire `grafica/immagini/index.html` per la galleria comparativa; `grafica/graphics.asm` e `grafica/instructions.txt` collegano codice e dati.

La modalità grafica `--mode straight` aggiunge SVG/PNG con segmenti retti ricavati dalle primitive del gioco. Il rasterizzatore PNG è stato corretto per rispettare `evenodd`, eliminando le linee spurie segnalate nelle locazioni 054, 055 e 074; le verifiche aggiuntive sono in `grafica/rendering-verification.json`.


## Aggiornamento: lessico e sintassi dei comandi

Il dossier `parser/LEGGIMI-PARSER.md` ricostruisce il percorso da Invio al controllo del dizionario e al parser: errori nell'area inferiore, token, nodi di comando e confine con la semantica. Foggy London è stato usato come indizio e confrontato con i dati originali: coincidono 592 record e 29 rimandi.

`parser/parser_audit.py` esegue le routine Z80 originali su 39 comandi. `parser/dictionary_lookup.py` riproduce in Python la ricerca alfabetica, verificata su 1.804 input; numeri e anomalia del gruppo Z sono documentati separatamente. Il listing `parser/parser.asm` distingue istruzioni, variabili e tabelle intercalate. Le schermate degli errori e il nuovo snapshot al prompt sono in `parser/results/`.

Il passo successivo indicato nella prima analisi è quindi completato per il percorso iniziale: restano da approfondire il modo speciale del parser, citazioni e continuazioni; la risoluzione semantica a partire da $B191 e il motore di gioco sono rinviati alla fase successiva.


## Aggiornamento: modalità speciali e laboratorio interattivo

L’approfondimento `parser/LEGGIMI-SPECIALI.md` documenta ordini/affermazioni, pronomi e connettivi, citazioni differite, ALL/BUT, continuazioni e ripetizione. La fusione della risposta WATSONS dopo EXAMINE ARMCHAIR è stata verificata anche nel flusso reale della domanda «Which armchair?».

Avvio: `python3 -B sherlock-analisi/parser/sherlock_parser.py` dalla cartella del progetto, oppure doppio clic su `parser/Avvia parser.command`. Lo script Python usa le routine Z80 originali tramite SkoolKit e mostra errori, token e strutture, senza eseguire il mondo del gioco. Istruzioni in `parser/README-INTERATTIVO.md`; verifiche e sessione di esempio in `parser/results-special/`. La riscrittura indipendente del parser e l’analisi semantica restano fasi distinte.
