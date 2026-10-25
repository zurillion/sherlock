# Stato del gameplay e ordine di completamento

25 ottobre 2026. Inventario del motore JavaScript autonomo `world-v5`, dopo
le correzioni dei comandi e il primo passaggio sugli oggetti. I documenti delle
fasi precedenti conservano risultati storici: il cab e gli itinerari di Lestrade
sono già collegati, non vanno considerati interamente mancanti.

## 1. Oggetti, contenitori, indizi e identità

**Primo passaggio completato:** regola ordinaria di collocazione, `PUT … ON …`,
`TAKE … FROM …` e `TAKE … OUT OF …`, anche negli ordini a Watson; ingombro,
risoluzione congiunta degli argomenti, errori e relativo stato sorgente.
Vedere [OGGETTI-E-CONTENITORI.md](OGGETTI-E-CONTENITORI.md).

Restano:

- travestimenti `WEAR` e `TAKE OFF`: cambiano l'identità nella prima riga della
  tabella attori, non soltanto un attributo del vestito. Servono identità
  alternative 0/1/100, proprietà/inventario, pronomi e reazioni degli altri;
- regole locali della nota che brucia, casseforti, cassetto, falso fondo,
  esami approfonditi e altri oggetti speciali;
- `LOCK`/`UNLOCK` dove esistono regole locali; non introdurre un'azione generica
  per oggetti che l'originale non consente di chiudere a chiave;
- tutte le combinazioni di luce, peso, possesso e contenitori annidati oltre
  i confronti dichiarati.

**Prossimo intervento consigliato:** identità e travestimenti, prima delle loro
reazioni NPC. Evita di aggiungere un WEAR che conservi erroneamente Holmes
come attore zero.

## 2. Informazioni e deduzioni

Le normali interrogazioni TELL e le interviste dei programmi NPC sono già
presenti nei percorsi verificati. Mancano la gestione completa delle
affermazioni, la memoria delle informazioni, la valutazione delle prove e
le deduzioni attivate nei colloqui con Watson e Lestrade. Le strutture dei
fatti e alcuni flag sono già esportati; ciò non equivale a eseguirne le regole.

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

FOLLOW/COME WITH e GO TO del giocatore oltre ai percorsi differiti degli NPC;
LOOK THROUGH/EXAMINE CLOSELY e varianti ancora mancanti; PAY senza TO con
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
