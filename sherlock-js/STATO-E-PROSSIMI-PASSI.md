# Stato del gameplay e ordine di completamento

26 ottobre 2026. Inventario del motore JavaScript autonomo `world-v5`, dopo
il completamento delle regole degli oggetti e delle identità. I documenti delle
fasi precedenti conservano risultati storici: il cab e gli itinerari di Lestrade
sono già collegati, non vanno considerati interamente mancanti.

## 1. Oggetti, contenitori, indizi e identità

**Primo passaggio completato:** regola ordinaria di collocazione, `PUT … ON …`,
`TAKE … FROM …` e `TAKE … OUT OF …`, anche negli ordini a Watson; ingombro,
risoluzione congiunta degli argomenti, errori e relativo stato sorgente.
Vedere [OGGETTI-E-CONTENITORI.md](OGGETTI-E-CONTENITORI.md).

**Secondo passaggio completato:** identità 0/1/100 e travestimenti WEAR/TAKE
OFF; nota che brucia e sue fasi; casseforti e finali locali; cassetto/falso
fondo, rifiuti, libreria, ruscello e tabella degli esami approfonditi.
Sono conservati i rifiuti originali di LOCK/UNLOCK: nel database di questa
versione non ci sono regole operative per queste azioni.

Peso ricorsivo a otto bit, barriere di contenimento e luce sono confrontati
in 3.264 casi controllati, oltre ai 94 di ingombro del primo passaggio.
La verifica include gli ordini differiti a Watson, il cambio d'identità
nello scheduler e nei contesti, e la ripresa dei nuovi stati da salvataggio.
Vedere [IDENTITA-E-INDIZI.md](IDENTITA-E-INDIZI.md) e
`results/special-objects-verification.json`.

Questo chiude l'implementazione funzionale del punto 1. L'estensione delle
prove a ogni combinazione, seed e temporizzazione rimane il punto 7;
le reazioni dipendenti da informazioni, accuse e identità nei rami ancora
mancanti restano ai punti 2, 3 e 5.

**Prossimo intervento consigliato:** punto 2, informazioni e deduzioni,
partendo dall'acquisizione degli indizi e dal loro uso nei colloqui.

## 2. Informazioni e deduzioni

La cronologia reale del blocco di Basil è ora confrontata con l’originale
per 115 comandi. Correzioni di ingombro, ALL, stampa e dipendenze casuali,
con salvataggio ricostruito alle 11:54:
[CRONOLOGIA-BASIL-UTENTE.md](CRONOLOGIA-BASIL-UTENTE.md).

Corretto il blocco tecnico dopo l’alibi di Basil: terminatore della tabella
dei fatti e intestazioni del programma del giocatore ora esportati. Prova
controllata di continuazione e caricamento in
[BASIL-E-CONFINE-DEI-FATTI.md](BASIL-E-CONFINE-DEI-FATTI.md). Questo non
esegue ancora le deduzioni descritte sotto.

**Nucleo implementato:** affermazioni SAY a Watson e Lestrade, memoria delle
triple e riuso dei record, collegamenti e richiami di Watson, valutazione
degli undici alberi delle prove, richieste di prova di Lestrade e conseguenze
delle conclusioni. Sono confrontati anche i colloqui dopo i 98 comandi
naturali forniti dall’utente e il seguito da salvataggio. Vedere
[INFORMAZIONI-E-DEDUZIONI.md](INFORMAZIONI-E-DEDUZIONI.md).

Le citazioni miste ordini/affermazioni restano al punto 4; le fasi successive
del caso al punto 5. L’estensione a ogni seed e ai campi temporanei del
renderer non ancora posseduti resta al punto 7. Le normali interrogazioni
TELL mantengono la propria tabella distinta dalle affermazioni.

## 3. Rami avanzati degli NPC

Completare i corpi delle regole ancora esplicitamente mancanti, le reazioni
legate a conoscenze e identità, le callback serali e alcune ricollocazioni
visibili. Watson, cabbie e Lestrade non sono copioni di risposte registrate:
eseguono già programmi di dominio, ma non ogni ramo è certificato.

## 4. Forme complesse del linguaggio

Restano esclusioni BUT/EXCEPT, alcuni collettivi sul secondo argomento,
coordinazioni e code dopo chiarimenti, citazioni multiple o residue, pronomi e
affermazioni in contesto, ripetizione durante un chiarimento e alcuni formati
numerici/limiti dell'editor. Il riconoscimento grammaticale e l'esecuzione
completa sono due livelli distinti.

## 5. Conseguenze dell'indagine e fine partita

Accuse, arresti, conseguenze delle prove, aggressioni/KILL, morte, vittoria e
altri finali. Sono necessarie anche le rispettive variazioni dello stato,
del tempo e della disponibilità dei personaggi, non solo i messaggi finali.

## 6. Comandi, trasporti e calendario ai limiti

WAIT UNTIL singola nella pagina è ora incrementale, con interruzione Invio
e pulsante, eventi visibili e ripresa confrontati con l’originale.
Vedere [WAIT-UNTIL.md](WAIT-UNTIL.md). Restano i limiti generali sotto.

FOLLOW/COME WITH e GO TO del giocatore oltre ai percorsi differiti degli NPC;
LOOK THROUGH e varianti non ancora certificate; PAY senza TO con
importo; servizi testuali SAVE/LOAD/QUIT/PAUSE/PRINT/NOPRINT rispetto ai pulsanti
del prototipo. Ampliare attese e interruzioni, lunghe permanenze sui mezzi,
scadenze, mezzanotte e riporti del calendario.

## 7. Equivalenza della partita completa

Estendere i confronti a più seed, ordini delle azioni e partite lunghe;
completare le dipendenze della casualità, incluse immagini native e diverse
temporizzazioni dell'input. Per ogni nuova dipendenza, confrontare le letture
e il successore casuale prima delle sole frasi. I salvataggi conservano il
futuro dello stato ricostruito: un vecchio salvataggio privo di una dipendenza
nuova non la riceve per supposizione.

Il motore rimane una ricostruzione parziale: le prove locali dichiarate non
certificano ancora equivalenza dell'intero gioco o di tutti i seed.

Correzione porte lontane: vedere [PORTE-E-NOTIFICHE.md](PORTE-E-NOTIFICHE.md). Il filtro CB01/D471 ora impedisce notifiche di porte condivise tra edifici diversi; rimangono le notifiche dalle stanze realmente adiacenti.
