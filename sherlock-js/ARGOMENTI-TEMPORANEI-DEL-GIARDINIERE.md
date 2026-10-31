# Argomenti di lavoro e riga persistente dei programmi DOMAIN

Il limite dopo A024 era una differenza reale: al checkpoint438, mercoledì20:50,
il giardiniere aveva gli argomenti persistenti `[50,33,1]` inJavaScript e
`[50,255,1]` nell’originale, con programma sospeso aEDE1.

La causa è il momento del salvataggio degli argomenti, non il generatore casuale.
Il parser, gli input del giocatore e le estrazioni restano quelli del medesimo
percorso naturale seed1 con tutti24 i posti attore attivi.

## Tre livelli distinti

La riga attore conserva azione e due argomenti ai byte+3,+4,+5. D008 li carica
nella zona di lavoro9FD6–9FD8, scegliendo il contesto sospeso se ne esiste uno.
Il caricamento avviene aCC7F, all’ingresso di ogni nuovo passo del programma.

CA48–CA5D riempie gli argomenti di lavoro ancoraFF con i referenti risolti.
Il binding precede il corpo della regola: anche un corpo fallito può lasciare
un argomento di lavoro valorizzato. Il binding non scrive però direttamente
nella riga persistente.

Il salvataggio è un’operazione separata, D026, chiamata daCD91:

- un’operazione riuscita salva anche quando il costo è zero;
- un fallimento che ritorna sullo stesso nodo passa daCD8B e salva con costo1;
- il raggiungimento del limite di dieci fallimenti passa dallo stesso punto;
- un fallimento che passa al nodo seguente continua daCC82, mantenendo gli
  argomenti di lavoro senza salvarli nella riga e senza ricaricarli daD008.

CF80 crea invece un contesto per una sottosequenza. Il record conserva l’azione
corrente e gli argomenti A034/A035 della chiamata, non rende persistenti tutti
i precedenti binding temporanei della radice.

## Il caso concreto del giardiniere

Dopo il ritorno della precedente sottosequenza, la radice contiene
`[50,255,1]`. Al tick3650 viene raggiunta questa sequenza del programma:

1. ED6A: test di probabilità33. Il body fallisce ma lascia33 nel primo
   argomento di lavoro, inizialmenteFF.
2. ED71: test di probabilità50. Anche questo fallisce; il binding precedente
   rimane nella zona di lavoro. La riga attore contiene ancoraFF.
3. ED78: avvio della sottosequenza di movimento, con argomenti2 e20. Il nuovo
   contesto è `[50,2,20]`; la riga radice rimane `[50,255,1]`.

JavaScript usava direttamente l’array della riga radice come argomenti di lavoro.
Il primo binding scriveva quindi33 nella riga persistente prima di sapere se si
sarebbe raggiunto D026. Ora il programma parte da una copia di lavoro e applica
i punti di commit già ricostruiti. La regola vale per i programmi NPC, senza
una conversione speciale33→255 o una condizione sul giardiniere.

La memoria dei record mantiene le precedenti regole di ritorno, allocazione e
rilascio. La correzione non introduce un’emulazione della CPU: gli indirizzi
sono riferimenti delle prove e del grafo semantico già estratto.

## Prove separate

`tools/probe-gardener-argument-lifetime.py` ripete la storia sull’originale e
traccia i trasferimenti di controllo e le scritture della riga nell’intervallo
3630–3651. Non modifica istruzioni, oggetti o programmi dei personaggi.
Il file precedente `baseline-javascript-trace.json` conserva il difetto del
commitb8b00c3; `javascript-trace.json` mostra la medesima sequenza corretta.

I test del contratto verificano binding falliti seguiti da una sottosequenza,
successo a costo zero, autoloop fallito con costo1, argomenti già valorizzati e
SAVE/LOAD durante la sospensione. Le regressioni includonoWatson, l’intero
hostNPC e tutti i byte dell’arena.

Una verifica positiva distinta ricontrolla i primi **1.672 checkpoint ogni
minuto** del riferimento continuo, fino al precedente controesempio di martedì
14:02: tutti gli stati confrontati e ogni estrazione coincidono. I conteggi
sono4.573 draw e9.796 read. Il riferimento è quello originale acquisito per
A024, riutilizzato con SHA256; non viene presentato come una nuova acquisizione
continua dello stato del mondo.

Il certificato completo del ramo del testimone e il lookahead sono separati:
nessun campo del confronto viene normalizzato per far passare la riga attore.
I risultati conclusivi sono nei rapporti `results/gardener-argument-lifetime/`.

## Atlante aggiornato

Dossier verificato per riassemblaggio: **137 istruzioni e362 byte**:

- CC78–CC93: ingresso e caricamento degli argomenti;
- CA48–CA75: binding prima del corpo;
- CE8F–CEDD: successo, fallimento e rami senza commit;
- CD82–CD94: yield temporale e salvataggio;
- CF80–CFB5: creazione del contesto sospeso;
- CFCF–D044: ritorno, caricamentoD008 e commitD026;
- ED6A–ED7B: dati DOMAIN dei due test e della chiamata successiva.

Sono approfondimenti di zone già classificate. Nessun nuovo byte grigio;
copertura invariata38.847 documentati,430 parziali e2.323 sconosciuti su41.600.
Questa copertura non misura l’equivalenza dell’intero gioco.

## Riproduzione

```sh
python3 tools/probe-gardener-argument-lifetime.py
node tools/probe-gardener-argument-js.mjs
node tools/verify-gardener-argument-provenance.mjs
node --test test/gardener-argument-lifetime.test.mjs
node tools/verify-gardener-continuous.mjs
node tools/verify-gardener-argument-prefix.mjs
node tools/verify-gardener-argument-lookahead.mjs
python3 tools/build-gardener-argument-listing.py
python3 tools/build-memory-map.py
```

## Risultato e orologio

Il certificato positivo separato è concluso: **439 checkpoint0–438 fino a
mercoledì20:50**,8.919 draw e19.078 read; tutti24 i posti attore, arena752,
entità, fatti, programmi, bitmap e futuro dopoLOAD. Sono60 ore e50 minuti di
tempo del gioco dall’avvio gratuito di lunedì08:00, per il profilo verificato.

Il prossimo checkpoint439, verso mercoledì21:00, resta escluso: Watson3
raggiunge un ingresso casuale non posseduto a5D25, draw indice13 del riferimento.
Il valore originale0 non è implementato come costante. Restano da certificare
i cinque finali naturali e gli altri limiti elencati nel punto di ripresa.

La prova della nuova acquisizione è conclusa:330 eventi e8 cambiamenti della
riga attore, tutti i cambiamenti osservati daD03B/D03E. Al tick3650 D03E scriveFF
prima diED6A; nessun commit della radice porta33 nella riga prima diCF80/ED78.
Il verificatore confronta i due body falliti, l’avvio della sottosequenza,
la tracciaJavaScript precedente e quella corretta. Questa è una prova del
flusso e dei writer, distinta dal confronto completo dei439 checkpoint.

## Verifica conclusiva dei test

65 controlli mirati passati. Nella suite completa1.649 test sono passati;
l’unico fallimento era il test storico che pretendeva ancora una differenza
al checkpoint1671 (`Missing expected exception`). Quel test ora richiede
l’uguaglianza completa anche a1671 e conserva tutti i controlli di canale ed
estrazioni sino a3241; rieseguito separatamente, passa. Sono quindi verificati
tutti1.650 test distinti, senza fallimenti residui. I due log rimangono separati:
`full-suite-initial.log` e `updated-channel-regression.log`; non viene dichiarata
una seconda esecuzione integrale della suite.
