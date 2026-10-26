# Identità, oggetti speciali e indizi

26 ottobre 2026. Secondo passaggio del punto 1 della roadmap, nel motore
JavaScript autonomo `world-v5`. Completa le regole ordinarie descritte in
[OGGETTI-E-CONTENITORI.md](OGGETTI-E-CONTENITORI.md).

## Travestimenti

Dalla stanza iniziale:

```text
OPEN PLAIN DOOR
N
WEAR CHINA MANS DISGUISE
I
LOOK
TAKE OFF CHINA MANS DISGUISE
WEAR OLD MANS DISGUISE
I
TAKE OFF OLD MANS DISGUISE
```

Non è necessario raccogliere il travestimento prima di indossarlo. `WEAR`
trasferisce il giocatore dal personaggio 0 al personaggio 1 oppure 100;
`TAKE OFF` lo riporta a 0. Cambiano la prima riga dello scheduler, posizione,
contenitore, possedimenti diretti e proprietà dei contesti sospesi. Restano
quelle del record originale le dimensioni, la capacità e le altre proprietà
della nuova identità: non vengono copiate tutte quelle di Holmes.

I riferimenti a un'identità precisa non vengono rinominati arbitrariamente.
Anche l'eventuale ordine di seguire Holmes rimane un riferimento a Holmes.
Il vestito indossato viene collocato nel contenitore 0, fuori scena; togliendolo
torna nella stanza corrente, ancora associato al personaggio 0. I salvataggi
conservano l'identità attiva, i contesti e gli ingressi della casualità.

## Regole locali degli indizi

La forma riconosciuta dall'originale è `EXAMINE CLOSELY DRAWER`, non
`EXAMINE DRAWER CLOSELY`. Non abbiamo aggiunto una grammatica alternativa.

| Oggetto | Effetto originale ricostruito |
| --- | --- |
| Cassetto nello studio dei Brown | Esame di cinque minuti, poi rivelazione del falso fondo; l'apertura del cassetto resta un'azione separata. |
| Falso fondo | Si apre separatamente; il contenimento rende accessibili gli indizi sottostanti. |
| Mucchio di rifiuti nel cortile di Basil | Esame di cinque minuti, poi rivelazione della nota strappata. |
| Libreria | Sei minuti; l'esame di Holmes apre il passaggio e cambia la descrizione. Gli esami successivi seguono il ritorno anticipato originale. |
| Letto di Basil, finestra, ponte, cadavere | Esame approfondito di cinque minuti con i rispettivi testi aggiuntivi. |
| Ruscello | Il martedì, sulla sponda est e con Lestrade percepibile, rivela il ritrovamento associato alla pietra. Negli altri rami viene eseguito il normale esame approfondito. |
| Nota che brucia | TAKE/GET avviano il programma locale: prima la raccolta e il suo minuto, poi l'eventuale spegnimento. Se il contatore è arrivato a zero nel frattempo, la nota è già bruciata. |
| Casseforti | Prima l'evento locale di quindici minuti, poi OPEN di un minuto se riesce. Anche ripetere OPEN su una cassaforte aperta passa prima per l'evento locale. |
| Cassaforte di Basil il lunedì | Scatena il finale previsto, con testi diversi secondo la presenza di Basil; non consuma i sedici minuti del ramo normale. |

Le regole distinguono Holmes dalle identità alternative e dagli altri attori.
Un esame ordinato a Watson non viene trasformato automaticamente nell'esame
eseguito da Holmes. Le piccole sequenze degli oggetti passano attraverso gli
stessi contesti, turni e continuazioni dei programmi degli NPC.

`CARRY NOTE` usa la regola ordinaria e non la speciale associata a TAKE/GET.
Inoltre il lookup originale di `BURNING` può selezionare `BURNT`: per la nota
che brucia, il confronto usa `TAKE NOTE`. Sono particolarità dei dati e
dell'algoritmo originali, conservate senza sinonimi inventati.

## Peso, luce e visibilità

Il peso dei contenuti è ricorsivo, nell'ordine degli ID. L'overflow con segno
satura a FF nel livello ricorsivo interessato; i livelli esterni continuano
la scansione. La capacità residua è una sottrazione a otto bit. L'ingombro,
già ricostruito nella fase precedente, è invece la somma dei figli diretti.

Visibilità e luce considerano le barriere lungo l'albero dei contenitori:
oggetto e osservatore devono condividere il contesto percettivo previsto.
La sola presenza nella stessa stanza non basta. Le sorgenti luminose vengono
filtrate con le maschere originali, la fascia oraria e le proprietà dell'attore.
Sono confrontati 448 casi di peso/capacità, 576 di percezione/barriere e 2.240
di luce; questi si aggiungono ai 94 casi di ingombro della fase precedente.

Il dizionario riconosce `LOCK` e `UNLOCK`, ma nel database di questa versione
non esistono regole che permettano quelle azioni. Il motore produce i rifiuti
originali, inclusi ricerca nelle descrizioni e conteggio dei fallimenti.

## Output e prove

I testi cifrati mantengono anche gli spazi ripetuti. Il cambio di modalità
maiuscola opera sul buffer della parola ancora da stampare, non solo sui
caratteri letti dopo il cambio. L'esame della libreria già aperta non emette
il CR finale: l'ultima parola resta sospesa, e il successivo input accettato
reinizializza quel buffer, come nell'originale. I pacchetti della pagina
rispettano i delimitatori effettivamente emessi.

Sono superati 344 test complessivi. Il nuovo corpus contiene 128 comandi,
25 configurazioni controllate, 715 estrazioni e 1.560 letture della sorgente
casuale; altre 13 prove includono esplicitamente lo stato iniziale completo.

I confronti differenziali sono in `test/special-objects.test.mjs` e nel rapporto
`results/special-objects-verification.json`. Usano seed 1 e tutti i 24 slot
attori, LOOK iniziale gratuito, grafica disattivata dopo il primo prompt,
input maiuscolo iniettato, MORE immediato e nessun timeout da inattività.
Gli spostamenti `# Setup` sono configurazioni logiche controllate, esplicite
anche nelle fixture: non sono una certificazione di una partita naturale.

Si confrontano tutte le estrazioni e le relative letture, stato degli attori,
entità e fatti, arena completa anche liberata, editor/token, bitmap superiore
e inferiore esatte e campi temporanei posseduti. I test riproducono inoltre
i pacchetti inviati alla pagina e riprendono da salvataggi durante i nuovi
stati. Non usano le risposte registrate per eseguire il gioco.

Il ritorno fallito da un programma NPC conserva argomenti temporanei distinti
dalla riga attore: una successiva operazione riuscita li conferma anche a
costo zero, mentre un nuovo ordine può prima sospenderli. È verificata la
sequenza di esami consecutivi ordinati a Watson, senza eccezioni per comando.

Il listing misto `results/special-objects/source/object-rules.asm` distingue
codice Z80, intestazioni delle regole, tabella degli esami e istruzioni del
linguaggio degli oggetti. Queste ultime sono dati, non istruzioni CPU.
La ri-assemblazione dei segmenti verifica 1.020 byte, con 394 istruzioni
classificate come codice. La corrispondenza dei byte è un controllo distinto
dalla verifica del comportamento.

L'equivalenza dell'intera partita e di tutti i seed rimane il punto 7 della
roadmap. Informazioni/deduzioni, altri rami NPC e forme linguistiche complesse
conservano i limiti dichiarati nelle rispettive sezioni.
