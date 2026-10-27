# Reazioni avanzate degli NPC

27 ottobre 2026. Estensione autonoma di `world-v5`. Il nucleo del punto 2
(memoria delle affermazioni, collegamenti di Watson e alberi delle prove di
Lestrade) è implementato e verificato nei casi dichiarati in
[INFORMAZIONI-E-DEDUZIONI.md](INFORMAZIONI-E-DEDUZIONI.md).
Questo intervento completa i corpi ancora mancanti delle regole referenziate
dai programmi NPC esportati e le tre callback serali. Non certifica ogni
possibile partita, ingresso casuale o costruzione del parser.

## Cosa è stato ricostruito

| Sorgente | Comportamento funzionale |
| --- | --- |
| F1A8 / F1AA–F1D5 | Il maggiore rende incosciente il primo poliziotto, entità 11. Cambiano qualificatore, articolo e bit di classificazione della persona; il testo 6D5D segue la visibilità originale. |
| ED39 / ED3B–ED4A | Straker rianima lo stesso poliziotto: ripristina la classificazione e il nome «a local police man», poi stampa 6D6A se percepibile. |
| EFB3 / EFC7 | Sonno e ripresa di Basil; quando Holmes è nelle stanze 33–39 il ramo può terminare la partita, scegliendo il testo in base alla presenza di Basil. |
| EF9C / EFAC | Le due scene di Basil stampano 75E8 e 7603 anche da fuori scena: la condizione di presenza è nel programma chiamante, non nel corpo di stampa. |
| F103 | Aggiorna il termine del fatto che inizia a 9965, impostando il bit 0200 della parola a 9972. Non aggiunge una deduzione inventata. |
| 9EC1 / 9ECB / 9ED1 | Callback del riposo di Daphne, cuoca e giardiniere, con stanza salvata e successivo ripristino. |
| 9E6A / 9E85 | Esiti dipendenti dall'incontro con Straker e dallo stato delle conclusioni di Lestrade. |
| 9E48 / 9EA2 / DFCA | Esiti del caso, arresto e ramo di Basil; scelta originale dei messaggi e arresto immediato dello scheduler. |
| 9A99 / 9ACB / 9C43 | Viaggi della vettura della polizia, velocità, visibilità del mezzo e arrivo dei passeggeri. |

I nomi storici come `unimplemented.F1A8` restano identificatori di provenienza
nei dati già esportati: il relativo corpo è ora implementato in
`src/advanced-npcs.mjs`. Nessun codice Z80 viene eseguito dalla pagina.
L'inventario trova 72 nomi di regola referenziati dalle istruzioni NPC:
19 rinviano ad altri programmi di dominio, 53 hanno un corpo funzionale.
L'esistenza del corpo non prova da sola la copertura di tutte le combinazioni.

## Identità, conoscenze e presenza

Il programma di Basil contiene riferimenti espliciti alle identità 0 (Holmes)
e 1 (travestimento cinese). Non vanno sostituiti automaticamente con l'identità
attuale 100 (vecchio). Le prove di visita completa mettono ciascuna identità
nelle stanze 32, 102 e 50 e confrontano il ramo effettivamente percorso.
Le scene dipendono da queste condizioni, dall'ora e dal programma in corso;
non da un timer aggiunto nella riscrittura.

Il poliziotto reagisce a Holmes, Watson e al maggiore tramite contatori di
incontro distinti. Il ritorno anticipato di 9CF2 lascia come contesto della
successiva estrazione il collegamento 9D68 della callback della polizia,
non il 9CEC usato dai saluti ordinari. Sono corretti anche la proiezione
della stanza del giocatore A009 e quella dell'attore corrente A00A/A017.

Le ricollocazioni interne senza una direzione non producono automaticamente
«goes …»: CAAF/CBC2 può renderle silenziose. Restano gli annunci direzionali,
gli ingressi percepibili e le descrizioni quando viene spostato Holmes.
I segnaposti della mappa conservano l'identità del personaggio anche quando
il sonno o l'incoscienza ne cambiano il bit dinamico di persona.

## Riposo serale: anche la particolarità aritmetica

Con stanza salvata zero, la callback considera l'ora **9pm**, a qualunque
minuto di quell'ora. Estrae un valore assoluto 0–30 con contesto 01F8.
Il codice aggiunge il valore al solo byte basso F8 senza propagare il riporto:

```text
durata = 0x0100 | ((0xF8 + estrazione) & 0xFF)
```

Quindi 0–7 producono 504–511 tick; 8–30 producono 256–278 tick.
La stanza precedente è conservata a 9EC0, 9ECA o 9ED0. Viene spostato
il solo attore: Daphne nella stanza 74, gli altri nella stanza 0.
Alla successiva visita prevista dello scheduler, una stanza salvata non zero
provoca il ripristino: non c'è un generico controllo «è mattina».
Questi tre byte e le scadenze fanno parte del salvataggio.

## Vettura della polizia

Le direzioni ammesse sono 103→50 (112 minuti), 50→103 (114) e 50→18 (94).
Sono **Old Mill Road**, **Main Street** e **Kings Cross Road**. La variante
FURIOUSLY sottrae 20 minuti. Non viene applicata la tariffa del cocchiere.
Il veicolo è l'entità 109, la stanza di transito è 105; all'arrivo il mezzo
si ricava dal contenitore effettivo del conducente, non da `attore - 1`.

Le prove comprendono tre tragitti con Holmes a bordo e uno senza.
Controllano anche il futuro dopo un salvataggio durante il viaggio.
Un nome di destinazione non risolto viene scartato dall'NPC secondo B9CA;
il record della richiesta deve avanzare prima di rilasciare il nodo.
La pulizia delle affermazioni del punto 2 segue un altro percorso.

## Esiti terminali e attese

Il testo terminale segue la scelta originale. Il ciclo si ferma prima di
eseguire callback o attori successivi; viene conservato il punto raggiunto
nel programma del giocatore. La pulizia dello schermo segue i 18 ritorni
di riga originali, senza aggiungere un prompt. Un WAIT UNTIL in corso
termina e rilascia il lavoro della sessione. Salva/Carica conserva l'esito.

Una prova **naturale**, senza teletrasporti o modifiche allo stato, esegue:

```text
WAIT UNTIL 11
WAIT UNTIL 11PM
```

Con seed 1 e il protocollo sotto, la partita termina alle **Mon 02:58pm**
con il testo 693A: Holmes non ha incontrato Straker. Durante la sequenza
il maggiore mette fuori combattimento il poliziotto e Straker lo rianima.
Sono confrontati 46 punti dello stato e tutti i 1.141 sorteggi intermedi.
Questo esito non è un limite di esecuzione del prototipo.

## Protocollo, prove e limiti

Le prove native usano tutti i 24 posti degli attori, seed iniziale 1,
LOOK iniziale gratuito (estensione del laboratorio), immagini disabilitate
dopo l'avvio, input maiuscolo iniettato sopra lo scanner della tastiera,
MORE immediato e nessuna attesa inattiva. I casi che impostano programma,
posizioni, identità, conoscenze, ora o accumulatore sono dichiarati
**controllati**, separati dalla sequenza naturale.

È stata corretta un'ulteriore dipendenza casuale dal tasto RETURN di avvio:
lo scanner ROM usa l'ultimo slot libero e ne fa scadere il contatore di
rilascio. Il protocollo dichiarato effettua due scansioni vuote prima di
iniettare i comandi del gioco. `src/keyboard-profile.mjs` ne calcola i byte;
otto prove eseguono lo scanner ROM con 0, 1, 2, 3, 4, 5, 6 e 20 scansioni.
Questo è uno stato dell'input, non una proprietà del seed. Non dimostra
parità con qualsiasi temporizzazione di una tastiera fisica. Il profilo è
salvato nei dati; lo stato corrente non viene riseminato durante la partita.

I confronti includono successione degli attori, scadenze, argomenti salvati,
entità, stanze, fatti, tutti i 752 byte dell'allocatore, liste, editor,
token, bitmap superiore e inferiore, ogni estrazione e ogni byte letto,
oltre al futuro da Salva/Carica. La prova naturale verifica anche i pacchetti
inviati al buffer Spectrum effettivamente usato dalla pagina.

**Limite preciso di stampa:** D187, quando nomina come soggetto un veicolo
con nome composto e senza descrizione della stanza, sovrascrive i campi
5D08–5D0F attraverso frame di argomenti/AF/BC non interamente proiettati.
La loro proprietà viene revocata dopo quell'arrivo: i test non li dichiarano
ricostruiti. Una lettura casuale futura da un campo ancora sconosciuto
rimane esplicitamente non implementata. Nessun valore della registrazione
nativa viene inserito come ripiego nel motore.

Il listato tipizzato in `results/advanced-npcs/advanced-npcs.asm` separa
intestazioni e byte modificabili dai corpi. Tutte le direttive vengono
riassemblate indipendentemente: 222 istruzioni, 567 byte identici.
L'operando 9E88 della condizione `caseReady` è esplicitamente modificabile.
Il rapporto complessivo è `results/advanced-npcs-verification.json`.

Rimangono ai punti 4–7 le forme linguistiche complesse, il completamento
dei comandi di accusa/aggressione e dei controlli manuali, i limiti di
trasporto/calendario e la certificazione di partite complete con altri seed
e altre temporizzazioni. I finali qui collegati sono quelli raggiunti dai
programmi NPC, non una dichiarazione che tutti quei comandi siano pronti.

La pagina sulla porta **8768** carica i file aggiornati senza riavvio del
server. Per una prova pulita: ricaricare la pagina e usare Riavvia. Un vecchio
salvataggio già divergente nella casualità non viene corretto cambiandogli
il seed; i salvataggi coerenti continuano dal proprio stato.
