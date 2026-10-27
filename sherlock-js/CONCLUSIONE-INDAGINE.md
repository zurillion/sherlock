# Accuse, arresti e conclusione dell’indagine

27 ottobre 2026. Punto 5 del motore JavaScript autonomo `world-v5`.
I finali già collegati ai programmi NPC sono ora verificati come insieme,
insieme ai rifiuti di aggressione, alle transizioni terminali durante altre
azioni e alla pausa di lettura nella pagina. Il codice originale è usato
soltanto dagli strumenti di confronto offline.

## Come si formulano le accuse

Questa edizione non ha verbi operativi ACCUSE, ARREST o SHOOT. Le accuse sono
**affermazioni a Lestrade**, per esempio:

```text
SAY TO LESTRADE "MRS BROWN KILLED HERSELF"
SAY TO LESTRADE "MRS JONES KILLED TRICIA"
SAY TO LESTRADE "BASIL HAS PLANS"
SAY TO LESTRADE "MAJOR FFOULKES IS INNOCENT"
```

Non bastano le parole: gli alberi delle prove controllano gli indizi osservati,
esaminati e le premesse già acquisite. Il valutatore e gli altri enunciati sono
in [INFORMAZIONI-E-DEDUZIONI.md](INFORMAZIONI-E-DEDUZIONI.md). Le normali risposte
TELL restano distinte dalle affermazioni.

9A4B e 9A59 confermano le due conclusioni sugli omicidi. Il secondo gestore
rimuove Mrs Jones dalla scena, senza inventare un’azione ARREST del giocatore.
9A13 richiede entrambe le conclusioni precedenti per accettare il ramo dei
piani di Basil; in caso contrario annulla l’ipotesi corrente e rinvia.
9A3D attiva la condizione di prontezza del caso nel ramo sull’innocenza del
maggiore. Saranno i programmi dei personaggi a consultarla successivamente.

Una dichiarazione ricevuta prima dell’operazione successiva dell’NPC **non
carica gli argomenti di quell’operazione nel contesto sospeso**. B936/BA20
interviene prima di quella risoluzione. È stata rimossa una risoluzione
anticipata che poteva alterare i record del viaggio di Lestrade.

## KILL non è un sistema di combattimento

Il modello dell’azione 52 rinvia a 9FC5: due argomenti di classe zero e un
predicato che restituisce sempre fallimento. Il testo originale è:

```text
ONLY AN IDIOT WOULD TRY THAT.
```

Vale anche con un nome assente, un oggetto, un letterale o senza bersaglio.
Il controllo precede quello della luce e non uccide né sposta alcuna entità.
Con ALL, invece, il predicato non seleziona nessun elemento e il collettivo
si esaurisce senza quel messaggio. Sono conservati anche i conteggi dei
fallimenti: ripetere rifiuti può cedere un minuto al mondo. Il nodo sintattico
rimane vivo durante quel turno se la pulizia originale non è ancora avvenuta.
Gli ordini KILL agli NPC vengono scartati attraverso il loro normale percorso
di rifiuto, senza bloccare il prototipo.

## I nove testi terminali

La tabella contiene anticipazioni sulla soluzione.

| Testo | Condizione del codice |
| --- | --- |
| 693A | Lestrade raggiunge 9E6A senza che Holmes abbia incontrato Straker. |
| 69BF / 6A26 | Al controllo 9E85 il caso non è pronto. L’arresto del maggiore sfocia nella sparatoria; il rapporto finale distingue Lestrade già presente da quello che entra. |
| 6A33 / 6ABD | Il ramo tardivo 9EA2 conclude con i piani venduti a una potenza straniera. Il testo distingue se entrambe le conclusioni sugli omicidi erano state confermate. |
| 6AF3 | Nel finale di Basil sono presenti con Holmes **sia Watson sia Lestrade**: Watson lo salva e Lestrade cattura i colpevoli. |
| 6B79 | Lo stesso ingresso di Basil, senza almeno uno dei due aiutanti, provoca la morte di Holmes. |
| 759C / 75D2 | Basil uccide Holmes, con testo diverso se deve entrare oppure è già presente. Questi testi sono condivisi dal ramo della cassaforte e da altri suoi programmi. |

La selezione di 6AF3/6B79 in 9E48 controlla le posizioni dei due aiutanti,
non un nuovo punteggio aggiunto dalla riscrittura. La catena chiamante ha i
propri controlli: EF83 confronta Basil con l’identità esplicita 0. Le identità
alternative non vengono automaticamente sostituite a quel riferimento.
Il ramo serale EFC7 considera le stanze 33–39; la cassaforte 89 ha la sua
condizione del lunedì, già ricostruita nel punto 1.

Le sparatorie conclusive sono testo e trasferimento al fine partita: il codice
non continua una simulazione di cadaveri o combattimenti dopo il salto.
Le normali mutazioni precedenti (prove, Mrs Jones, segnali, posizioni,
argomenti e scadenze) restano nello stato effettivamente raggiunto.

## Arresto immediato e pagina web

`src/endings.mjs` centralizza il percorso comune 9E74. Il testo viene stampato,
poi C306 richiede **un tasto qualsiasi** con la cella lampeggiante nella barra.
Solo dopo l’accettazione si eseguono i diciotto CR di A296. Questa pausa non
è un MORE: dopo il tasto C142 riporta la finestra a 36 colonne senza
modificare il contatore. A296 lo azzera dopo ciascuno dei diciotto CR.
Alla fine viene rimossa anche l’immagine della locazione dalla presentazione.
La pagina ora conserva il finale leggibile fino a quel tasto.

Il motore si ferma prima di callback o attori successivi. Questo vale anche:

- durante WAIT e WAIT UNTIL;
- durante una sequenza di un oggetto che aveva già ceduto un minuto;
- nel turno ceduto dal contatore dei rifiuti, distinguendo il fallimento
  del predicato da quello del corpo già eseguito;
- durante ALL, prima di liberare il nodo o provare un altro elemento.

Nei comandi composti (per esempio `WAIT. I`) nessuna azione successiva
viene eseguita e non viene riscritto il delimitatore dei token.
Nessun prompt viene aggiunto dopo la fine. Il cursore basso lasciato dalla
routine C1FD è conservato nella proiezione sorgente anche quando non si arriva
al prompt. Salva/Carica accetta anche le continuazioni terminali 992D/9937,
senza riavviarle. Comandi e teletrasporto non possono più modificare la partita.
Per ripartire si usa **Riavvia**: il laboratorio conserva il checkpoint prima
di B0AC, mentre l’originale prosegue verso il proprio servizio di riavvio.
Questo adattamento dell’interfaccia resta esplicito; QUIT e i servizi testuali
rimangono nel punto 6.

Il confronto prima della cancellazione ha inoltre scoperto un annuncio del
treno mancante: E4C9 stampa la partenza **prima** di nascondere il mezzo.
L’ordine è stato corretto, senza cambiare l’orario del viaggio.

## Verifiche e limiti

Il nuovo corpus comprende **32 storie**: nove senza modifiche al mondo e ventitré
con assetti controllati dichiarati (posizioni, PC/scadenze NPC, prove note o
contatore dei tentativi). Non presenta quegli assetti come una soluzione
raggiunta giocando dall’avvio. Tutti i 24 posti degli attori rimangono attivi. Gli assetti controllati
eseguono prima INVENTORY, poi le modifiche dichiarate; le nove storie naturali
partono direttamente dal prompt di avvio.

Sono confrontati ogni sorteggio e byte letto, successore casuale, programmi,
scadenze e argomenti degli attori, entità, stanze, fatti, tutti i 752 byte
dell’arena, editor/token e bitmap esatte. Salva/Carica viene provato a ogni
passaggio confrontato. Diciassette casi verificano anche i pacchetti della
sessione web e l’immagine del testo finale al checkpoint C306, prima dei CR.
La prova del buffer e della pausa usa il codice della pagina, non un controllo
visivo manuale del browser.

Sono coperti tutti i nove testi terminali. Due percorsi partono dall’avvicinamento
di Basil attraverso Buckingham Palace Road e Victoria Station, durante WAIT,
anziché invocare direttamente il nodo finale. I corpus precedenti restano
regressioni: comprendono il termine naturale delle 14:58, le conseguenze delle
prove e le casseforti.

**Un limite rimane esplicito nel seguito lungo delle dichiarazioni:** nel caso
controllato 22 vengono confrontati i primi nove comandi fino alle 08:30. Il WAIT
successivo richiede il campo del renderer 5D06, ancora non ricostruito dopo
quelle stampe annidate. La pagina annulla l’input conservando la partita;
non viene certificato il suffisso originale fino alle 09:45, né inserito il
byte della registrazione come ripiego. I campi inferiori a 5D02, non sovrascritti
dall’ingresso delle dichiarazioni, conservano invece la proprietà precedente.
Le dipendenze di stampa mancanti restano nel punto 7, insieme agli altri seed,
alle immagini e alle temporizzazioni d’input non certificate. La logica dei
finali non equivale a una certificazione di tutte le partite complete.

Il listato tipizzato contiene **220 istruzioni e 532 byte**, riassemblati
indipendentemente. Intestazioni delle regole e sequenze DOMAIN sono dati.
La regressione generale passa **584 test**.
Rapporto: `results/endings-verification.json`; prove: `test/endings.test.mjs`.

Per provare la pagina aggiornata: ricaricare **http://127.0.0.1:8768/**.
Il server statico non richiede un riavvio. Non cambiare il seed di un vecchio
stato divergente per tentare di correggerlo: conservare salvataggio e cronologia.


## Primo confronto naturale del punto 7

[FINALI-NATURALI.md](FINALI-NATURALI.md) distingue ora il fallimento senza
presentazione a Straker (14:58) dal successivo ramo dell'arresto/sparatoria,
raggiunto dopo un viaggio naturale e attese (martedì 01:03, seed 1).
Non sono timer universali né assetti preparati: sono due cronologie complete
con tutti gli attori, confrontate fino al fine partita e dopo Salva/Carica.


Aggiornamento 27 ottobre: vedere [ALTRI-FINALI.md](ALTRI-FINALI.md) e
`results/other-endings-verification.json`. Confrontati due percorsi naturali
fino alla cassaforte (stesso finale 759C); corretti la ricerca delle premesse
annidate e il rifiuto originale degli ordini di movimento a Basil impegnato.
Le altre sei varianti terminali restano da certificare con storie naturali.
