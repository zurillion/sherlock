# Stato del gameplay e ordine di completamento

27 ottobre 2026. Inventario del motore JavaScript autonomo `world-v5`, dopo
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

**Prossimo intervento consigliato:** punto 7, ampliare le prove di partita
completa e le dipendenze casuali ancora sconosciute. I nuclei dei punti 2–6
sono implementati; i confini restano dichiarati nei rispettivi rapporti.

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

**Implementati i corpi ancora mancanti delle regole referenziate dai programmi
NPC**, le tre callback serali, i rami di Basil dipendenti dalle identità,
le reazioni del maggiore/Straker/poliziotto e i viaggi della polizia. Collegati
i finali raggiunti da questi programmi e l'arresto dello scheduler anche
durante WAIT UNTIL. Vedere [NPC-AVANZATI.md](NPC-AVANZATI.md) e
`results/advanced-npcs-verification.json`.

La lunga attesa naturale con tutti gli attori è confrontata fino all'esito
originale delle 14:58. I percorsi impostati di sera, con altre identità o
altri stati delle prove sono test controllati: non certificano una partita
intera. Rimangono al punto 7 gli ingressi casuali non ancora ricostruiti,
compresi alcuni frame temporanei D187 dopo l'arrivo in un veicolo dal nome
composto. Il protocollo RETURN di avvio è ora esplicitamente modellato.

## 4. Forme complesse del linguaggio

Implementati coordinazioni e durata dei nodi, risposte multiple ai chiarimenti,
ALL nei due ruoli semantici e negli ordini NPC, esclusioni con le anomalie
originali, code di citazioni lette dai token vivi, modo finale delle richieste,
pronomi/affermazioni in contesto, ripetizione @, lettore numerico con cursore
e contatore dell'editor. Vedere [LINGUAGGIO-COMPLESSO.md](LINGUAGGIO-COMPLESSO.md)
e `results/language-verification.json`.

Sono confrontate integralmente 58 storie naturali con tutti gli attori. Tre
storie di corruzione dei buffer rimangono fuori dalla parità: due ripristinano
il terminatore della riga attraverso una citazione residua, una sovrappone
editor e token. La pagina le annulla esplicitamente, conservando lo stato;
non produce una risposta inventata del gioco. Questi confini della scansione
oltre memoria restano aperti nel punto 7. Il formato grammaticale e la
certificazione di qualsiasi flusso di byte non sono la stessa cosa.

## 5. Conseguenze dell'indagine e fine partita

**Implementato il percorso funzionale dei nove testi terminali**, con accuse
attraverso le affermazioni, conseguenze delle prove, rifiuto originale di KILL,
vittoria, morte e sconfitte. Il fine partita interrompe anche oggetti, ALL e
turni ceduti dai rifiuti; conserva stato e continuazioni in Salva/Carica.
La pagina attende un tasto prima della cancellazione finale. Vedere
[CONCLUSIONE-INDAGINE.md](CONCLUSIONE-INDAGINE.md) e
`results/endings-verification.json`.

Le prove controllate dei finali non sono una soluzione naturale completa.
Il seguito lungo delle accuse conserva il confine esplicito del renderer
5D06 dopo le 08:30 nel caso 22; la scansione e la proprietà dei campi mancanti
restano al punto 7. Non è dichiarata equivalenza di qualsiasi partita.

## 6. Comandi, trasporti e calendario ai limiti

**Nucleo implementato e confrontato:** FOLLOW/COME WITH del giocatore,
ENTER/GO INTO adiacenti, LOOK THROUGH, PAY senza TO e relativi rifiuti.
GO TO/GO FURIOUSLY TO/TAKE … TO conservano l'assenza di regole operative
per Holmes in questa edizione, senza inventare un percorso globale.

Collegati PAUSE, PRINT/NOPRINT con carta virtuale SVG, SAVE/LOAD al prompt
e QUIT. Nastro e riavvio sono adattatori dichiarati della pagina, non
emulazione delle periferiche originali. Confrontati mezzogiorno, mezzanotte,
giorno 255/0 e scadenze/tick a 16 bit, conservando il confronto senza segno.

38 storie native, 124 comandi/checkpoint e 645 estrazioni casuali, con tutti
gli attori attivi e setup di calendario/periferiche espliciti. Vedere
[COMANDI-E-CALENDARIO.md](COMANDI-E-CALENDARIO.md) e
`results/command-limits-verification.json`.

WAIT UNTIL singola è incrementale e interrompibile. Attese in righe composte
e vecchi profili conservano il precedente percorso a frame; lunghe permanenze
su ogni mezzo e ogni seed richiedono l'estensione delle prove del punto 7.

## 7. Equivalenza della partita completa

**Primo passaggio naturale verificato:** attesa a Baker Street fino al finale
693A (lunedì 14:58) e viaggio reale fino alla presentazione a Straker, seguito
soltanto da attese fino all'arresto/sparatoria e rapporto 6A26 (martedì 01:03).
Seed 1 e protocollo dichiarati; nessuna impostazione artificiale di prove,
programmi o posizioni. 187 checkpoint, 3.603 estrazioni e futuro dopo LOAD.
Vedere [FINALI-NATURALI.md](FINALI-NATURALI.md). I due finali di sconfitta non
sono ancora una soluzione dell'indagine né una certificazione degli altri seed.


Estendere i confronti a più seed, ordini delle azioni e partite lunghe;
completare le dipendenze della casualità, incluse immagini native e diverse
temporizzazioni dell'input. Per ogni nuova dipendenza, confrontare le letture
e il successore casuale prima delle sole frasi. I salvataggi conservano il
futuro dello stato ricostruito: un vecchio salvataggio privo di una dipendenza
nuova non la riceve per supposizione.

Il motore rimane una ricostruzione parziale: le prove locali dichiarate non
certificano ancora equivalenza dell'intero gioco o di tutti i seed.

Correzione porte lontane: vedere [PORTE-E-NOTIFICHE.md](PORTE-E-NOTIFICHE.md). Il filtro CB01/D471 ora impedisce notifiche di porte condivise tra edifici diversi; rimangono le notifiche dalle stanze realmente adiacenti.


Aggiornamento 27 ottobre: vedere [ALTRI-FINALI.md](ALTRI-FINALI.md) e
`results/other-endings-verification.json`. Confrontati due percorsi naturali
fino alla cassaforte (stesso finale 759C); corretti la ricerca delle premesse
annidate e il rifiuto originale degli ordini di movimento a Basil impegnato.
Le altre sei varianti terminali restano da certificare con storie naturali.

## Verifica successiva dei finali e delle confessioni

Il finale 69BF dell’arresto in presenza di Holmes passa ora una storia
naturale completa (171 checkpoint, 2.464 estrazioni). Ricostruiti inoltre
i programmi TELL di Tricia/Mrs Jones, il cambio d’identità NPC e il valore
probatorio del suo racconto, con prove controllate e ripresa da LOAD.
Dettagli e confini in [FINALI-E-CONFESSIONI.md](FINALI-E-CONFESSIONI.md).
I testi certificati naturalmente sono quattro; cinque rimangono da verificare.
