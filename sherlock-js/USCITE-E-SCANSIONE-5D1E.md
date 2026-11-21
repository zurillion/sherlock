# EXITS, pulizia della riga e due byte della sorgente casuale

Seguito: [uscita dai contenitori e AF](USCITA-CONTENITORI-E-AF.md),
3.050checkpoint fino a mercoledì15:49; prossimo5D21/descrittore del LOOK.


20 novembre 2026.

La variante con LOOK prima del primo HAIL CAB coincide ora per **2.962
checkpoint**, fino a **mercoledì alle 14:22**. Il NE del binario due alle
11:17 supera entrambi i campi prima sconosciuti: **$5D1E e $5D24**.
Il prossimo checkpoint escluso è la continuazione dell’attesa delle
**14:23**: Watson legge **$5D20**, il cui nuovo scrittore resta da ricostruire.

## Correzione: non era una risposta di un NPC

Il precedente dossier attribuiva la s osservata al letterale yes del
frammento $7319. Era un errore nell’interpretazione dello stack:
**$731A è AF salvato**, con A=$73 (s) e F=$1A. Non è un indirizzo da seguire.

La nuova traccia misura la parola attiva all’ingresso di **$A9DF**, prima
che il puntatore del buffer venga azzerato. Durante la scansione osservata
la parola è **exits**. Il buffer contiene anche byte residui di parole
precedenti: non si può leggerlo fino al primo zero per stabilire la parola.
L’intervallo valido viene dal puntatore, come fa $A9E4 sottraendo $5C0B.

La traccia completa del comando mostra:

> You go northeast.
> You are at platform two of Kings cross station. Visible exits are southwest northeast.
> Watson enters.

Non compare «Yes Inspector…». La correzione è riportata anche nel dossier
precedente, nelle istruzioni del progetto e nella mappa.

## Il chiamante e la sequenza del formatter

**$D179** chiama **$D68C**, dopo la descrizione della stanza e i passaggi
con un oggetto interposto. Nel normale arrivo completo osservato,
$D68C entra con SP=$5D5E. Salva quattro coppie di registri, cerca le uscite
senza oggetto interposto ed emette l’introduzione **$68F1–$68FF**:
visible, exits, are. Se non trova uscite, ritorna senza quell’introduzione.

Le parole vengono accodate prima di essere disegnate. Il chiamante che
fornisce il delimitatore determina il frame del loro scaricamento:

| Parte stampata | Frame del glifo | Chiamante |
| --- | --- | --- |
| exits | $5D28 | lo spazio che precede are nel decoder del dizionario |
| are e direzioni seguite da un’altra direzione | $5D36 | emissione successiva da $D6A6/$A887 |
| ultima direzione e punto, senza contenuti da elencare | $5D48 | CR finale, ingresso $A9B7 con SP=$5D5C |
| spazio della pulizia prima di una direzione che non entra | $5D30 | percorso di wrap e ritorno $C377 |

La prima s finale lascia **C**, salvato da **$C3B7**, in $5D1E.
C deriva dalla colonna: `(2 + 7 × colonna) & 7`. Nella partita vale 7;
nei controlli assume tutti gli otto valori. Non viene assegnato un 7 fisso.

Il wrap di southwest prima del disegno richiama la pulizia della riga.
L’ottava scansione dello spazio di pulizia lascia **F** in $5D24 tramite
**$C3B8**. Il modello lo calcola dallo stesso algoritmo di scansione,
con la colonna finale della riga larga. Il valore osservato è zero.
La precedente provenienza WEAR di $5D1E era invece F, in un altro frame:
indirizzo RAM uguale non significa registro salvato uguale.

## Verifiche controllate e limiti della proprietà

Il probe usa l’ingresso $D68C effettivamente catturato e ne ripete la
stampa con tre stanze: due uscite, una e nessuna. Varia tutte le **36
colonne** e cinque contatori di righe (0, 3, 8, 12, 14): **540 setup**.
Inizializza esplicitamente spaziatura e capitalizzazione. Passa la stanza
nel registro A richiesto da $D224 e confronta anche il
testo completo e l’elenco delle direzioni. Il CR conclusivo usa il suo
frame misurato; i ritorni sintetici $0008 servono soltanto al probe offline.

Queste sono chiamate isolate, senza tick. I programmi dei 24 attori sono
conservati ma non eseguiti dal probe: non si presentano i 540 setup come
partite naturali. La traccia NE e il confronto dall’avvio sono prove separate.

La nuova proprietà nel modello è limitata a:

- grafica nativa, giocatore 0 alla radice, arrivo completo e non remoto;
- nessun contenuto della stanza da elencare dopo le uscite;
- una o due uscite senza oggetto interposto, finestra larga;
- `contatore + 6 < 15` al momento del glifo posseduto.

L’ultimo margine è **una guardia conservativa della ricostruzione**, non
una condizione del codice originale. Negli altri casi il gioco può
stampare, ma il modello non attribuisce nuovi valori a questi campi.
LOOK, descrizioni brevi, travestimenti, contenitori e altri chiamanti
mantengono i loro contratti separati.

Nei 540 setup sono confrontati **169 valori posseduti di C** e **36 di F**,
senza differenze. Le altre 875 coppie setup/campo restano sconosciute,
anziché ricevere valori di ripiego. Non si estende la proprietà ai byte
adiacenti. Salva/Carica mantiene separatamente anche lo zero di $5D24;
un vecchio salvataggio senza il campo resta privo del campo.

## Confronto naturale e mappa

Profilo: seed 1, tutti i 24 attori, grafica nativa dall’avvio, primo LOOK
gratuito, input maiuscoli e MORE immediati, nessun teletrasporto.
Il prefisso verifica **7.801 estrazioni e 16.562 letture**, con bitmap e
attributi superiori a ogni estrazione, contatore MORE, modalità finestra,
clock, stanza, esito del comando e finale. Il limite delle 14:23 resta esplicito.

Il test dall’avvio effettua Salva/Carica JSON in nuove sessioni ai checkpoint
**1488, 2005 e 2780**, l’ultimo subito dopo NE. Dopo quest’ultimo sono
confrontati **181 checkpoint di futuro**, incluse risposte e stato completo.
Sono passati anche i tre percorsi di vittoria con seed **0, 1 e 137**,
ciascuno di 3.219 checkpoint con i rispettivi Salva/Carica.

Nuovi approfondimenti dell’atlante:

- **$68F1–$68FF**: dati compressi dell’introduzione delle uscite.
- **$D16B–$D181 e $D68C–$D6B7**: chiamante e iterazione delle uscite.
- **$A9DF–$AA03**: delimitazione della parola valida nel buffer riusato.
- **$C2BA–$C2BC, $C388–$C39D e $C3B7–$C3BA**: salvataggi tipizzati e scansione.
- Workspace **$5D1E/$5D24**: produttori indipendenti e proprietà circoscritta.

Il nuovo estratto comprende **148 byte verificati**, con 73 istruzioni e
una sezione dati distinta. Ogni istruzione viene riassemblata e confrontata
con il TAP. Restano **40.029 byte documentati, 305 parziali e 1.266
sconosciuti**: si approfondiscono zone già identificate, senza nuovo grigio classificato.

[Traccia completa NE](results/full-arrival-exits/natural-ne-detail.json) ·
[540 setup originali](results/full-arrival-exits/formatter-abi.json) ·
[Confronto dei campi](results/full-arrival-exits/verification.json) ·
[Listato commentato](results/full-arrival-exits/full-arrival-exits.asm) ·
[Rapporto del prefisso](results/victory-route/native-extra-look-verification.json).

Controlli conclusi:22 test di formatter e mappa,49 del contratto generale
dei glifi;replay completo della variante e tre percorsi di vittoria
superati. Il [resoconto del traguardo](results/full-arrival-exits/milestone-verification.json)
e l’[output dei test](results/full-arrival-exits/test-output.txt) conservano
il perimetro dei controlli eseguiti.
