# A022/A023: ultimo riferimento lessicale emesso

30 ottobre2026. A022 non è un seme e non descrive l’ultima parola riconosciuta
dal parser. È il byte basso di una word condivisa che l’emettitore del
dizionario conserva fra una chiamata e l’altra. Il byte alto A023 contiene
i quattro bit superiori dell’offset e il nibble del contesto grammaticale.

## I due scrittori

A887 verifica5C3C. Se l’emissione è disabilitata torna prima di qualsiasi
scrittura: i testi fuori scena non aggiornano questa word. I caratteri
letterali possono ancora modificare il buffer della parola, come già
ricostruito, ma non attraversano lo scrittore del dizionario.

A88C conserva DE, incluso il nibble alto. Se l’offset a12 bit è zero termina
subito: anche un riferimento zero può quindi cambiare A022/A023, conservando
il proprio contesto. Altrimenti stampa lo spazio iniziale, poi A8B5 conserva
nuovamente offset e nibble di modo. La ricostruzione dei caratteri e la scelta
della desinenza avvengono dopo; non sostituiscono il riferimento con quello
di un’altra parola.

| Modo | Resa della parola |
| --- | --- |
|50|Radice senza suffisso|
|40|Forma con suffisso|
|10|Forma dipendente dall’oggetto|
|Altri|Forma dipendente dall’attore; alcuni contesti controllano maiuscole e terminazione|

I token lunghi passano il riferimento completo. Le parole frequenti
ricostruiscono lo stesso offset con modo50. A880, usato anche dai modelli
delle azioni, elimina invece i nibble di metadati del record prima della
chiamata. I nomi dinamici usano40 per i qualificatori e50 per il sostantivo.
I comandi senza parola END LINE/END SENTENCE saltano la chiamata A887;
la punteggiatura e il CR da soli non azzerano questa word.

## Implementazione autonoma e proprietà del valore

Il renderer JS conserva il descrittore a partire dalle operazioni lessicali
già estratte. I nomi e gli argomenti di locazione usano i riferimenti presenti
nei record; non cercano l’ultima parola nel testo inglese a video.
Il campo vive nello stato della partita e viene salvato insieme agli altri
ingressi del generatore. Il motore non legge RAM, disassemblati o tracce.

Un’emissione nascosta conserva il valore precedente; i caratteri letterali
lo conservano anche quando sono visibili. Un output sintetico del prototipo
che non ha ancora un contratto lessicale completo rende il campo sconosciuto,
invece di conservare un residuo potenzialmente falso. La stessa cautela vale
per i messaggi d’errore e per i modelli di azione privi di un argomento finale
risolto. Questa limitazione di proprietà è distinta dall’algoritmo dell’emettitore.

Un vecchio SAVE privo del campo resta sconosciuto fino a una nuova emissione
ricostruita: non riceve il valore dell’avvio o quello registrato nella prova.
All’avvio nuovo la stampa reale del saluto di Watson stabilisce il riferimento;
non è introdotta una costante con il suo valore finale. Analisi del parser e
anteprime della scena non modificano lo stato persistente. SAVE/LOAD conserva
anche la proprietà sconosciuta, oltre al valore quando disponibile.

## L’ostacolo del percorso lungo

La traccia naturale identifica l’ultimo store aA8B5, tick964, attore0. Si tratta
del sostantivo della destinazione nell’ordine composto GO TO SLATER STREET.
Il record della locazione contiene STREET con offset0861: il modo50 produce
il descrittore5861. Le stampe successive fuori scena non lo modificano.

Il giardiniere, attore8, legge A022 al tick2852, mercoledì07:31. Il suo valore
è61 esadecimale. Il modello ottiene questo byte dal descrittore derivato dal
record, non installando97 decimale dalla traccia. La word non viene ricavata
dal seed, dal comando WAIT, dal contenuto visibile o dal tempo trascorso.

Il confronto completo ora supera quel punto e si ferma al checkpoint365,
diretto a mercoledì08:40, per il campo temporaneo5D1D ancora sconosciuto.
Il prefisso certificato passa da359 a365 checkpoint,0–364, fino a mercoledì08:30:
6992 estrazioni e14966 letture confrontate, tutti24 attori, mondo, fatti,
arena752 byte, bitmap e prosecuzione dopo LOAD. Il conteggio runtime6994
comprende anche le due estrazioni dell’avvio; il conteggio confrontato6992
si riferisce ai checkpoint. Il finale6A33 dell’intera traccia rimane non
certificato, come gli altri quattro testi terminali ancora aperti.

Riproduzione:

```sh
node tools/verify-witness-prefix.mjs
node tools/compare-witness-research.mjs
```

Il primo comando verifica il prefisso e scrive
results/dictionary-reference/witness-prefix.json. Il secondo è ricerca:
fallisce intenzionalmente sul prossimo campo sconosciuto, senza cambiare
la suite di regressione o usare il suffisso come replay nel gioco.

## Prove brevi e limite separato del cab

64 chiamate controllate alla routine originale coprono8 contesti,4 offset
(compreso zero) e le due condizioni di5C3C. Sono prove ABI, non partite naturali.
Le prove naturali brevi confrontano6 sequenze complete e il prefisso di una
settima:31 input,158 estrazioni,316 letture, tutti24 attori, stato completo,
arena e bitmap. Ogni nuovo valore dichiarato posseduto coincide con l’originale;
LOAD riproduce il seguito e conserva anche le revoche.

La settima sequenza arriva fino all’ingresso nel cab. Il successivo comando
SAY CABBIE "GO TO KINGS CROSS ROAD" mostra una differenza preesistente nel
campo del renderer5D0C: JS47, originale0. La stessa differenza è stata
riprodotta con i sorgenti del commit8e3b605, prima della modifica A022.
Il suffisso nativo resta nel fixture come evidenza; il certificato di stato
completo si ferma prima di quel comando. Nessun campo del confronto viene
omesso o normalizzato. Il recupero della proprietà corretta di5D0C è una
voce separata del backlog, non viene dichiarato risolto da questa modifica.

Suite completa:1054 test passati,0 errori. I test mirati, compreso l’atlante,
sono77. Il server statico8768 serve i file aggiornati: non è stato riavviato
e le prove non hanno modificato la partita aperta nel browser.

## Aggiornamento dell’atlante

265 istruzioni e523 byte sono stati riassemblati e confrontati col payload.
A022–A023 passa da parziale a documentato come struttura dati mutabile.
Escono dal grigio A3E2–A413 (secondo argomento della composizione), A65C–A65D
(terminazione) e A815–A82E (ricomposizione del tag del nome):78 byte nuovi.
Sono approfonditi anche A37D–A3E1,A414–A418,A5CD–A5F1,A63F–A65B,
A880–A92E e D3E8–D447. Il totale è38466 byte documentati,468 parziali,
2666 sconosciuti su41600. La classificazione statica non certifica ogni
combinazione di output o l’equivalenza dell’intera partita.
