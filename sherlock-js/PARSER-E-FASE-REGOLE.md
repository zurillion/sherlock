# Predicati coordinati e fase delle regole

28 ottobre 2026. Ripresa della verifica dei finali, motore autonomo world-v5.

## Nodo intermedio: la scrittura avviene prima dell’allocazione

Nella storia naturale `major-witness`, il comando
`SAY LESTRADE "MAJOR VISIT OPIUM DEN AND MAJOR IS INNOCENT"`
lasciava il byte 97B5 a 9 anziché 4. Non era un problema del generatore.

AB7C chiama ABF3 mentre IY punta ancora al nodo intermedio. AC17/AC1A
scrivono il predicato IS (0485) nei suoi primi due byte. Soltanto dopo,
AB83/ACCC ripristinano il cursore e AE6A alloca il nuovo nodo. La
post-elaborazione completa i riferimenti ereditati. Rimangono tre nodi:
non si deve eliminare quello intermedio. Quando viene liberato, il payload
conserva la scrittura; la gestione dei blocchi liberi sovrascrive il byte
basso del verbo ma non quello alto. Da qui il 4 osservato a 97B5.

`src/parser.mjs` ora riscrive il predicato nel nodo corrente prima di
finalizzarlo. Non contiene indirizzi speciali del test né una sequenza
registrata. La traccia offline registra le due scritture prima della
successiva chiamata AE6A: `results/parser-rule-lifetimes/parser-trace.json`.

## A00B non dipende solo dal successo del predicato

Superato quel punto, la prima differenza era una lettura casuale di A00B
martedì alle 04:00: JavaScript restituiva 0, l’originale 1.

C591 imposta inizialmente la fase a zero. Se un argomento non specificato
richiede enumerazione, prova i candidati in questa fase. Con entrambi gli
argomenti specificati, o con slot di classe zero, C5EB/C5EE raggiungono
invece C5F4 direttamente: A00B diventa 1 **prima** dei controlli della
regola e del predicato. Anche un predicato falso lascia quindi 1.
Le classi letterali 5/6 respingono i valori diversi da FE prima di questa
transizione. L’annuncio A00C segue il proprio contratto distinto.

`src/npc-runtime.mjs` conserva ora questa distinzione. Quattro chiamate
controllate dell’originale verificano rifiuti con fase uno ed enumerazione
con pre-verifica a zero. Non sono presentate come partite naturali.

## Verifiche e limite successivo

Il confronto della storia naturale passa su 206 checkpoint, fino a martedì
06:40, con tutti i 24 slot attore. Confronta ogni estrazione e lettura casuale,
programmi e scadenze, entità e fatti, tutti i 752 byte dell’arena, bitmap
superiore e inferiore, pacchetti del browser e futuro dopo LOAD, compresi
i minuti della WAIT in corso. Protocollo: seed 1, LOOK iniziale gratuito,
grafica nativa disattivata dopo il boot, input maiuscolo iniettato e MORE
immediato. Questo non prova parità per ogni seed o protocollo d’input.

Il test ordinario include il comando composto e il WAIT successivo; il
confronto esteso resta ripetibile separatamente:

```sh
node --test test/witness-parser.test.mjs
node tools/verify-witness-prefix.mjs
node --test tools/compare-witness-research.mjs
```

Il confronto completo continua intenzionalmente oltre il prefisso certificato e si
ferma al checkpoint 206, diretto a martedì 06:50: ingresso casuale 5D13
ancora senza proprietario ricostruito. Il rollback resta esplicito; nessun
byte registrato viene usato come fallback. Il finale 6A33 raggiunto dalla
registrazione nativa a giovedì 10:00 non è ancora certificato in JavaScript.

## Mappa aggiornata

Il nuovo listing commentato e riassemblato comprende 128 istruzioni,
272 byte: AB75–AB8D, ABF3–AC23, ACCC–ACFA e C591–C627.
La mappa usa questo dossier per i titoli, le annotazioni e i rimandi.
Sono stati classificati 142 byte prima grigi; gli altri precisano sezioni
già analizzate. A00B e il payload dei record liberati sono documentati
anche nelle strutture dati. Copertura dei byte e completezza del gioco
rimangono misure distinte.

Suite completa dopo le correzioni: **667 test passati, nessun fallimento**.
