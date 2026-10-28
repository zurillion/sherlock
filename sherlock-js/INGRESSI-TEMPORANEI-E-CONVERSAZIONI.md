# Ingressi temporanei, conversazioni fuori scena e inizializzazione

28 ottobre 2026. Motore autonomo JavaScript, profilo world-v5.

## Perché la partita si fermava a 5D13

Il generatore consulta memoria che il gioco riutilizza. Il valore a 5D13 non
è una costante: C38B vi lascia il byte alto dell’indirizzo video quando il
frame d’ingresso del glifo è 5D1A. Nel percorso naturale studiato, la stampa
del prefisso del cocchiere durante l’arrivo delle 14:10 lascia 50 esadecimale;
il generatore lo consulta soltanto alle 06:46 del giorno dopo.

C388 conserva anche flags/carattere, BC del chiamante, descrittore e ultimo
scan. La proiezione ora include i campi dimostrati fino a 5D19. Non si tratta
di un’estensione basata sui valori di una registrazione: 45 chiamate native
controllate, su cinque frame, tre caratteri e tre colonne, verificano le
formule. La traccia naturale segue separatamente gli ultimi proprietari:
5D12, 5D16–5D19 sono riscritti dalla stampa dell’identità travestita alle
14:15; 5D13–5D15 conservano ancora i residui del cocchiere. Tutti gli otto
byte coincidono anche nel checkpoint originale delle 07:00.

I frame non ricostruiti devono continuare a revocare la proprietà dei campi.
EXAMINE ordinario conserva i vecchi campi bassi dimostrati, ma revoca quelli
nuovi da 5D12; i rami profondi di Lestrade mantengono la loro revoca separata.

## Puntatori agli argomenti: A013–A016

C8EF sceglie il record di una locazione per classe minore di 5, quello di
un’entità altrimenti. Anche la classe zero segue questa scelta quando il
chiamante passa effettivamente un ID: non significa automaticamente che il
puntatore debba essere azzerato. I valori FE e FF saltano la scrittura e
conservano la word precedente.

La fase di enumerazione aggiorna i puntatori per i candidati realmente
esaminati, prima dei vincoli e del predicato. Una risoluzione semantica non
proiettata revoca il campo invece di conservare un indirizzo vecchio. I
puntatori vengono salvati; un vecchio save che ne è privo non riceve un
valore ricostruito da un’immagine RAM.

La prima lettura naturale incontrata, A013 alle 07:09 del martedì, vede la
word del record dell’entità 40 dopo una chiamata del giardiniere: il byte
basso è E8. Il modello lo ricava dal record dell’entità selezionata.

## Enumeratori delle affermazioni: BA13–BA1B

Questi sono cursori nell’indice delle entità, distinti dai puntatori appena
descritti. BD7E/BDC2 inizializzano BA13 e BA15 a 8B6C, tre byte prima
dell’indice. D36A avanza prima di cercare. Il secondo tentativo verifica
l’unicità: in caso di esaurimento rimane il terminatore 8CB9; in caso di
ambiguità rimane il secondo match. Se il soggetto è ambiguo, l’oggetto non
è cercato e il suo cursore rimane quello iniziale.

BA17 conserva il verbo lessicale. BA19–BA1B vengono aggiornati parzialmente:
il predicato riconosciuto e il primo soggetto/oggetto trovato. Il confronto
nativo comprende affermazioni valide, soggetti ambigui, oggetti ambigui,
qualificatori e frasi coordinate, più il futuro dopo caricamento.

## Stato lessicale: DC13/DC14

DA77 salva la lunghezza della parola inserita; DAAA il miglior prefisso
lessicale. Numeri e punteggiatura non li azzerano. Una parola sconosciuta
può averli già modificati prima dell’errore. Queste scritture appartengono
alla scansione effettiva dell’input: le analisi preventive di WAIT UNTIL e
le chiamate esplorative al parser non devono modificare il mondo.

## Straker fuori scena e il buffer di parola

Nella storia naturale, alle 13:44 del lunedì Straker racconta il suo alibi
fuori dalla vista di Holmes. A887 salta la parola di dizionario e perfino
il relativo spazio quando l’attore non è percepito. I letterali, invece,
attraversano A9B7 e scrivono ancora nel buffer. Le lettere di `ll` lasciano
un residuo che viene letto dal generatore alle 09:27 del martedì.

Il contesto delle conversazioni TELL in JavaScript era vuoto fuori scena:
non mostrava nulla, correttamente, ma ometteva anche queste scritture.
Ora mantiene il sink del buffer e sopprime solo lo schermo e le emissioni
che A887 salta. Non viene mostrato a Holmes un dialogo lontano.

## Inizializzazione ROM: mappa dei canali

Il byte a 5C17 ha un’origine diversa: appartiene alla mappa degli stream.
La ROM a 127C–1285 copia quattordici byte da 15C6 a 5C10; il gioco riusa
poi quell’area come buffer della parola. Finché un byte non è sovrascritto,
quella inizializzazione rimane osservabile.

Il build verifica le istruzioni di copia e ricava la tabella dalla ROM
controllata per checksum. Solo il cold start la usa. Nessun caricamento
sostituisce con quei valori un campo sconosciuto del save. La ROM rimane
esclusa dalla mappa grafica richiesta; il dossier ne conserva la provenienza.
A011 è inoltre esplicito come flag della grafica sorgente disabilitata dopo
il boot, secondo il protocollo del confronto. Le preferenze SVG/pixel del
browser non cambiano quel campo.

## Artefatti e prove

- `results/transient-inputs/transient-inputs.asm`: codice e dati commentati;
  402 istruzioni, 744 byte del payload riassemblati e confrontati.
- `results/transient-inputs/rom-streams.asm`: quattro istruzioni e quattordici
  byte di inizializzazione, verificati separatamente e fuori dalla mappa ROM.
- `stack-owners-reference.json`, `argument-pointer-trace.json` e
  `word-tail-trace.json`: tracce offline dei proprietari e delle letture.
- `test/transient-inputs.test.mjs`: contratti nativi e conservazione nei save.
- `tools/probe-*.py`: ricerche offline ripetibili; il browser non le importa.

La suite completa passa **681 test**. L’atlante è rigenerato con annotazioni,
strutture dati e provenienza aggiornate. La percentuale di byte classificati
non misura la completezza del gameplay; le sezioni già colorate possono
ricevere annotazioni nuove e più precise.

## Nuovo prefisso naturale e punto di ripresa

Il confronto passa su **247 checkpoint**, da 0 a 246, fino a martedì
13:10. Il comando `node tools/verify-witness-prefix.mjs` ripete il certificato,
con ogni estrazione/lettura, arena, entità, fatti, bitmap esatte e futuro dopo
LOAD. Seed 1, tutti i 24 slot attore, LOOK iniziale gratuito, grafica sorgente
off dopo il boot, tasti iniettati e MORE immediato: nessuna modifica a entità,
prove o programmi per produrre il risultato.

Il confronto completo separato si ferma al checkpoint 247, diretto a
martedì 13:20: legge A012, contatore temporaneo del parser, ancora senza
proiezione funzionale. Il riferimento giunge a 6A33 giovedì 10:00 ma non
è un nuovo finale naturale certificato del motore JavaScript.
