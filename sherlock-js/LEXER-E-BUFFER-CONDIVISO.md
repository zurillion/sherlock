# Lexer e buffer condiviso con la stampa

## Provenienza dei byte

Il confine 5C1F non richiedeva un nuovo algoritmo casuale: richiedeva il
contenuto corretto di un buffer che il generatore consulta come ingresso.
La RAM viene inizializzata dal cold start ROM: 11DC scrive due, 11E9 e
11EC decrementano due volte fino a zero durante il test della memoria.
127C–1285 copia poi soltanto 14 byte di stream in 5C10–5C1D. Il loader
BASIC di questa distribuzione non esegue OPEN # prima di USR: le ulteriori
24 celle degli stream, 5C1E–5C35, restano zero fino a una scrittura effettiva.

Il modello inizializza soltanto questa coda documentata, non l’intero
buffer o le altre variabili ROM. È una condizione del protocollo cold-start
certificato. Un salvataggio vecchio con byte sconosciuti non riceve zeri
all’atto del LOAD.

## Copia lessicale

DA34 usa la prima lettera per scegliere il gruppo del dizionario. Dopo
averne verificato la presenza, DA5F–DA77 copia da 5C0B i caratteri successivi
al primo, applicando OR 20 a ogni byte fino al delimitatore inferiore a 40.
Scrive poi uno zero finale. La lunghezza comprende la prima lettera;
quindi coincide con il numero di byte scritti, corpo più terminatore.

La copia non modifica il puntatore di stampa A9B5. Non cancella la coda:
una parola lunga seguita da una corta lascia residui della parola lunga.
Le copie avvengono già nel preflight, anche sulla parola che provoca un
errore lessicale. Numeri e punteggiatura riconosciuti seguono altri percorsi.
Il comando @ ripete la scansione dell’input precedente e le relative copie.

Il JavaScript raccoglie questi effetti nel lexer puro, poi li applica
soltanto al vero input, anche quando il lexer segnala un errore. Le analisi
preventive del parser e del WAIT non mutano il mondo. Le normali emissioni
di testo continuano a scrivere sul medesimo buffer secondo i propri percorsi.

A94D decomprime invece i candidati del dizionario a 5C42, cioè 55 byte più
avanti. Le nuove copie sono possedute nel tratto inferiore. Se un input
oltrepassa quella soglia, la parte sovrapposta viene dichiarata sconosciuta:
non si pubblica la copia dell’input come valore finale di celle che il
decoder dei candidati può riscrivere. Nessun nuovo fallback nello stack.

## Verifica e prossimo confine

Sette nuovi test portano la suite a **719 test passati**. Cinque sequenze
native partono da cold start seed 1 con tutti i 24 posti attore: parole
lunghe non riconosciute, input successivo, @, conversazioni, ALL/BUT e
WAIT UNTIL. Confrontano copie osservate dopo DA77, byte posseduti del
buffer, ogni estrazione/lettura, arena completa, mondo, bitmap e futuro
dopo LOAD. Altri test proteggono la purezza delle analisi, il puntatore
di stampa, la sovrapposizione e i vecchi salvataggi.

Il confronto completo major-witness supera ora la lettura 5C1F, ma si
ferma sulla successiva 5D1F nello stesso checkpoint 323. Quindi il prefisso
certificato resta **0–322, mercoledì 01:30**, non è esteso a un nuovo orario.
È ripetibile con `node tools/verify-witness-prefix.mjs`; rapporto corrente
`results/lexical-workspace-verification.json`. Il confronto completo resta
separato: `node --test tools/compare-witness-research.mjs` fallisce ancora
esplicitamente, verso il checkpoint di mercoledì 01:40.

Il probe `tools/probe-lexical-frontier.py` ripercorre la storia naturale e
osserva la zona da tick 2400: conferma entrambe le letture, ma non incontra
una nuova scrittura a 5D1F in quell’intervallo. Non identifica quindi il
suo ultimo scrittore precedente. Brevi osservazioni iniziali mostrano che
5D1F può essere riscritto sia dalla decompressione (A969/A97C) sia dal
glifo (C39D). Il prossimo passo è ricostruire questi chiamanti e la loro
validità, non aggiungere lo zero osservato come costante. La proiezione
attuale dello stack termina a 5D19.

Restano quattro testi terminali certificati naturalmente e cinque aperti:
6A33, 6ABD, 6AF3, 6B79 e 75D2. Nessuna nuova certificazione del finale.

## Mappa sincronizzata

`results/lexical-workspace/lexical-workspace.asm` commenta 173 istruzioni /
286 byte del payload; il dossier ROM separato riassela 35 istruzioni /
56 byte. La ROM non diventa una zona dell’atlante. La mappa mostra i due
workspace e le scritture effettive; la copertura classificata in byte non
è aumentata perché queste routine avevano già una classificazione generale.
