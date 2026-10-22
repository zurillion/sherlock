# Watson e Lestrade nella pagina web

La partita web esegue ora anche i turni di Watson e Lestrade, con le sequenze, le azioni, i dialoghi, le richieste e le callback Z80 originali. Non vengono aggiunte risposte scritte apposta in Python o JavaScript. L'analisi dei programmi resta in `sherlock-analisi/ai/LEGGIMI-AI.md`; questo documento descrive l'integrazione e le prove del prototipo.

## Perché sono attivi anche gli altri attori

Abilitare soltanto gli ID 2, 3, 31 e 34 non basta: Lestrade prende il cab, raggiunge Kings Cross, poi aspetta un treno. Con i treni sospesi rimane sul binario. Successivamente scambia segnali e ordini con Straker e altri personaggi, che devono poter rispondere ai propri turni.

Perciò `Game` usa `NativeWorld(active_npcs=None)`: lo scheduler originale visita tutti i 24 attori, Sherlock incluso. L'ordine rimane quello originale: Sherlock, Lestrade, Watson, gli altri personaggi, i due cocchieri e gli otto treni. La documentazione del loop spiega le scadenze individuali: non tutti agiscono a ogni minuto e una visita può contenere più passi a costo zero.

`Game(project, data, active_npcs=(...))` resta disponibile per esperimenti isolati e regressioni. Il server non passa questo argomento e usa il mondo completo. Il valore predefinito di `NativeWorld` resta invece la selezione vuota, per conservare il banco di analisi delle singole routine.

## Il saluto all’avvio

Aggiornamento 23 ottobre: avvio con seed esplicito e salvataggi completi; vedere [SEED-E-SALVATAGGI.md](SEED-E-SALVATAGGI.md). Le prove storiche qui descritte usano ancora il percorso di ricerca `seed=None`.

Il primo opcode del programma (`$E72F`: `06 EB 6D`) stampa il saluto `$6DEB` prima del primo prompt. Lo snapshot usato dal prototipo è già successivo a quel turno: ora la pagina ripresenta il testo perduto insieme alla descrizione, senza riga vuota tra le due parti e senza rieseguire il turno dell’attore. Dettagli e prova dell’avvio reale sono in `AVVIO-E-SALUTO-WATSON.md`.

## Provare Watson

Dopo **Riavvia**, nella stanza iniziale:

```text
SAY TO WATSON "TAKE LAMP"
SAY TO WATSON "DROP THE DAILY CHRONICLE"
OPEN YOUR DOOR
WEST
```

Watson prende la lampada, interrompe la lettura del giornale, esce dalla propria poltrona e raggiunge Holmes nella stanza adiacente. Il suo segnaposto W e gli oggetti che trasporta seguono i record modificati dal gioco. Un altro esperimento, da una nuova partita:

```text
SAY TO WATSON "FOLLOW ME"
OPEN YOUR DOOR
WEST
```

Qui viene eseguito il comportamento differito di FOLLOW; non è la stessa sequenza del seguito autonomo dopo la perdita del giornale. Non viene aggiunta una ricerca Python del percorso: restano i limiti originali su uscite, contenitori e distanza.

Altre interazioni native da provare:

```text
SAY TO WATSON "TELL ME ABOUT LESTRADE"
SAY TO WATSON "BASIL KILLED MRS BROWN"
SAY TO WATSON "WATSON IS INNOCENT"
```

Ordini, interrogazioni e affermazioni usano percorsi distinti del motore. L'accusa a Basil modifica la lista originale delle informazioni, oltre a produrre una risposta. Non significa che ogni affermazione venga verificata come vera.

Se Holmes resta nella stanza e usa WAIT, Watson termina la prima fase di lettura e presenta il caso. Se Holmes esce senza interrompere la lettura e continua ad aspettare, Watson può lasciare la nota nella stanza 8 e andare fuori mappa. I contatori, gli ordini ricevuti e il generatore casuale originale determinano i tempi: non sono timer JavaScript né scadenze fisse aggiunte dal prototipo.

## Provare Lestrade

Dopo **Riavvia**, cliccare subito la locazione **010 Parliament Street** nella mappa. Il salto non consuma tempo. Quindi:

```text
SAY TO LESTRADE "WAIT"
WAIT
```

Durante la fase iniziale risponde `Sorry, I cannot do that now.`. Chiama il cab, vi sale e ordina al cocchiere di andare a Kings Cross Road. Le frasi derivano dalle routine originali; il rifiuto dipende dalla fase del programma e dai controlli dell'azione, non da una regola Python che respinge tutti gli ordini.

Il segnaposto IL permette di seguire l'itinerario anche quando Holmes è altrove. Cliccare **Inspector Lestrade** nell'elenco dei personaggi inquadra la sua posizione senza spostare Holmes. Cliccare un riquadro della mappa sposta invece Holmes. Usare WAIT per far avanzare il mondo: Lestrade raggiunge i binari, aspetta il treno 42, vi sale e prosegue verso Leatherhead. Le locazioni interne dei mezzi e i tempi di partenza sono quelli del gioco.

Gli incontri e i saluti avvengono soltanto quando le condizioni originali di presenza e percezione li consentono. Non vengono mostrati a Holmes tutti i dialoghi che si svolgono lontano da lui.

## Tempo, presentazione e riavvio

Rimangono l'avvio gratuito alle **Mon 08:00am**, i costi originali delle azioni e lo stato pendente delle domande del parser. Errori lessicali e richieste di disambiguazione provati non concedono nuovi turni agli NPC. MORE, animazione delle parole, ricaricamento della pagina e cambio di modalità non fanno passare minuti. Le ispezioni di scena non devono alterare il contesto delle sequenze sospese.

Le modalità normale e Spectrum ricevono gli stessi messaggi dal server. **Riavvia** ora riparte prima del primo prompt e inizializza anche i primi contatori NPC usando il seed scelto. Il vecchio snapshot è conservato come opzione degli script di ricerca (`seed=None`).

## Script e verifiche

```sh
python3 -B sherlock-analisi/locazioni/verify_web_ai.py
python3 -B sherlock-analisi/locazioni/verify_web_cab.py
python3 -B sherlock-analisi/locazioni/verify_restart.py
```

`verify_web_ai.py` verifica ordini, seguito, informazioni, lettura e nota di Watson; rifiuto e viaggio di Lestrade; movimenti dei segnaposti, dipendenza dai treni, avanzamento oltre il primo scambio con Straker e riavvio. Confronta inoltre sequenze di input con `Probe`, il banco indipendente che esegue il gioco originale senza passare da `Game` o da `NativeWorld.submit`: testo superiore/inferiore, 110 record di entità, tutte le 24 righe degli attori e calendario. Il seme di prova è 1; il riferimento riceve lo stesso calendario iniziale e lo stesso riallineamento della scadenza di Sherlock del prototipo, descritti in `ATTESE-E-FINE-PARTITA.md`. Le ispezioni ripetute della scena vengono inserite in una prova per controllare i contesti sospesi.

La verifica ha completato **18 controlli e 77 comandi**, di cui 23 confrontati con il banco indipendente. Nel percorso con seme 1, Lestrade risulta sul treno 42 alle 09:15am e sceso a Leatherhead Station alle 10:35am; alle 10:55am ha superato gli scambi iniziali con Straker ed esaminato gli oggetti 46 e 47. Sono punti osservati ai prompt della prova, non orari universali attribuiti alle scene.

Il rapporto con i comandi e gli stati osservati è `results/web-ai-verification.json`. Le regressioni specifiche del cab mantengono anche un mondo isolato con i soli cocchieri; la nuova verifica esercita un viaggio del giocatore nello scheduler completo. Le prove nel browser controllano risposte e segnaposti anche in modalità Spectrum.

Attivare tutti i programmi non equivale a certificarne ogni scena. Le nuove prove coprono Watson e la prima parte dell'itinerario di Lestrade, compreso il viaggio in treno e il primo incontro con Straker. Gli sviluppi successivi dell’indagine e tutte le combinazioni di ordini non sono ancora verificati integralmente. I percorsi terminali hanno ora prove dedicate in `ATTESE-E-FINE-PARTITA.md`; manca ancora una partita completa riproducibile. Restano esclusi i servizi nastro/stampa e il timeout dell'editor. L'integrazione esegue il codice originale; la sua riscrittura autonoma in Python resta una fase successiva.
