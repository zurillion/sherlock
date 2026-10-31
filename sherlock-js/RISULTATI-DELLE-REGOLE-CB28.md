# Risultati delle regole: $CB28–$CB2B

Questi quattro byte sono due puntatori little-endian: i risultati IX e IY
conservati dal ponte delle regole. Il corpo immediato può riusarli; anche
il generatore casuale può leggerli. Non sono un nuovo seed né una costante.

## Contratto del ponte

`$CB34` chiama il predicato/corpo selezionato; `$CB37` salva IX in CB28,
`$CB3B` salva IY in CB2A. Il corpo passa da `$CB2C`, che ricarica prima
entrambi i risultati precedenti. Il predicato, invece, entra da CB34 con
il contesto selezionato dal chiamante. Un predicato falso scrive comunque
il suo risultato. Un rifiuto precedente per luce o classi può non arrivare
al ponte; un corpo differito non esegue subito CB2C.

Questo distingue tre cose: argomenti semantici, loro puntatori A013/A015,
e risultati conservati CB28/CB2A. Non si possono rendere sempre uguali.

## Risultati ricostruiti

- **Ricerca del contatore:** E573/E560 restituisce in IX il record del
  contatore dell'attore, oppure zero se manca. IY conserva l'intestazione.
- **Creazione:** E531 alloca il record e lo lascia in IX; IY resta quello
  entrante. La scelta casuale della durata avviene prima del ritorno CB37:
  durante quella scelta, CB28 conserva ancora il risultato precedente.
- **Decremento:** se non raggiunge zero conserva il record. A zero lo libera
  e restituisce i puntatori del rilascio anche se l'esito logico è fallimento.
- **Cancellazione:** IY diventa il predecessore nella lista dei contatori
  (9FE7 per il primo elemento). IX dipende dall'arena libera: link del
  predecessore se la prima fusione riesce; start del blocco liberato se
  fallisce. È la particolarità A1FD/A204 già rispettata dall'allocatore.
- **OPEN/CLOSE ordinari:** DEA4 e DEB6 caricano esplicitamente A013 in IX.
  Il modello deriva quindi il descrittore dall'oggetto risolto quando il
  corpo ordinario riesce. Un rifiuto non stabilisce un nuovo puntatore.
- **Attesa di un tick, test dell'ora e scelta probabilistica:** conservano
  i risultati entranti. D29D preserva IX/IY: il nuovo numero casuale non
  diventa il contenuto di CB28.
- **location.save ed entity.at:** il risultato IX è il puntatore esplicito
  del primo argomento. IY resta entrante nel corpo; nel predicato compreso
  conserva l'intestazione.

`src/rule-results.mjs` esprime questi contratti sui record e sulle azioni
JavaScript. Non interpreta istruzioni Z80: gli indirizzi sono identità dei
record o delle intestazioni, necessarie anche alla sorgente casuale originale.

## Proprietà parziale e LOAD

Il campo `world.npcs.ruleResultPointers` contiene due word, ciascuna nota
oppure nulla. Si possono conoscere i due byte di IX senza conoscere IY.
Un vecchio LOAD privo del campo rimane sconosciuto fino a un writer compreso;
non si inserisce lo zero del payload né un risultato catturato.

I callback non proiettati revocano la proprietà. Il ritorno al prompt esegue
altre regole del parser, tra cui D770: questa analisi non ne completa tutti
i rami. Perciò il modello revoca il risultato tornando al prompt, anziché
conservare il dato dell'ultimo NPC. **Non è una ricostruzione completa di
ogni possibile risultato del ponte.** Le parti note vengono confrontate
con l'originale; le parti ignote continuano a bloccare una lettura casuale.

## Prove e limiti

Il corpus nuovo comprende 12 storie native, 57 checkpoint, 205 draw e 410
letture casuali, con tutti i 24 attori, input maiuscoli iniettati, MORE
immediato e grafica originale disabilitata dopo il boot. Confronta ogni
byte di risultato che il modello dichiara posseduto, oltre a tutti i draw,
allo stato originale completo e al futuro dopo LOAD. Non pretende che i
byte dichiarati sconosciuti siano stati ricostruiti.

Le prove controllate aggiungono 92 casi dei contatori e dell'arena, e 162
chiamate dei corpi OPEN/CLOSE con valori entranti diversi. Queste ultime
verificano l'ABI del corpo, non la possibilità di aprire oggetti senza
superare maschere e controlli semantici.

La lettura che bloccava la partita è nel checkpoint 415, draw 19 della
cuoca: il riferimento originale legge CB28=204. Nel modello il precedente
OPEN/CLOSE del giardiniere lascia il descrittore della plain door 50,
90CC, da cui quel byte viene derivato. La ricostruzione usa l'algoritmo e
il puntatore risolto; non installa 204 come risposta del generatore.
Le letture storiche vengono riutilizzate dal riferimento nativo completo
con percorso e SHA256: non si dichiara una nuova acquisizione nativa lunga
né una traccia originale dell'ultimo store a quel minuto.

Il confronto lungo supera ora CB28: 421 checkpoint, 0–420, sino a
**mercoledì 17:50**, 8.441 draw e 18.066 letture confrontati; 24 attori,
arena completa, entità, fatti, programmi, bitmap e ripresa dopo LOAD.
Il prossimo limite osservato è **5D29**, checkpoint 421 verso le 18:00.
Il checkpoint annullato non estende il certificato di stato completo.

PRINT/MORE, TAKE TO, riga transitoria del giardiniere nella distinta traccia
continua, cab 5D0C e cinque finali naturali restano aperti. I loro confronti
non vengono normalizzati per farli passare.

## Atlante

Approfonditi il ponte CB28–CB40, la selezione C9BF–CA75, il rilascio
A1C7–A24C, i contatori E52F–E5AC, OPEN/CLOSE DE9D–DEC0, il polling
D769–D77D, la probabilità F198–F1A7 e il test dell'ora F1D6–F1F5.
Intestazioni e puntatori sono dati tipizzati separati dalle istruzioni.

255 istruzioni e 573 byte riasssemblati contro il payload. Sono stati
chiariti **14 byte prima grigi, F19A–F1A7**, e promossi da parziali a
documentati 31 byte, E58C–E5A7 ed E5AA–E5AC. Copertura del payload:
38.784 byte documentati, 433 parziali, 2.383 sconosciuti su 41.600.

Sono passati 42 test mirati distinti. Due conservano esplicitamente i vecchi
controesempi PRINT/MORE e TAKE TO: il loro passaggio non significa che tali
differenze siano risolte. Il certificato positivo delimitato è separato
dal log di scoperta: quel run trovò 5D29 ma non riuscì a scrivere il proprio
rapporto per un permesso del processo; il successivo confronto delimitato
ha concluso e salvato regolarmente tutti i 421 checkpoint.
