# Coordinazioni, collettivi, citazioni e continuazioni

27 ottobre 2026. Implementazione del nucleo del punto 4 nel motore autonomo
JavaScript `world-v5`. La pagina usa questi algoritmi direttamente, senza
chiamare il motore originale. Il corpus distingue i percorsi confrontati
integralmente e tre confini di corruzione dei buffer ancora non ricostruiti.

## Coordinazioni e durata dei nodi

AAB2–AF6A costruisce un'intera unità sintattica prima di eseguirla. I nodi di
`OPEN YOUR DOOR AND PLAIN DOOR` devono quindi essere già entrambi allocati
quando il primo OPEN cede il turno agli NPC. D83B–D856 libera il nodo eseguito
e le esclusioni collegate; ALL conserva invece il nodo durante le iterazioni.
La pagina ora segue questa durata, compresi i byte lasciati nei blocchi liberi.

Quando un nuovo verbo dopo AND inizia un'altra unità, il parser originale
prova prima un nodo temporaneo, poi lo libera e riavvolge il cursore. Anche
questa allocazione lascia tracce osservabili. Una domanda interrompe il resto
della vecchia riga: il nodo ambiguo viene conservato da B5B6, il resto scartato.
La nuova risposta può però contenere più azioni:

```text
OPEN DOOR
YOUR AND PLAIN
```

La fusione del primo nodo precede la propagazione del verbo ai successivi.
Sono verificati anche `YOUR AND LOOK`, `LOOK AND I`, una nuova domanda nella
risposta e gli errori dopo un'azione già effettuata. I tentativi falliti del
programma del giocatore vengono contati fra le unità, non soltanto a fine riga.
Un errore semantico arresta le azioni residue; un rifiuto dentro ALL viene
contato prima della ricerca dell'oggetto successivo.

Gli errori del canale inferiore vengono ora proiettati nel momento in cui
avvengono, prima degli eventuali turni successivi della coordinazione. Un
WHAT dopo un LOOK nella stessa riga non azzera di nuovo il contatore di scroll.

## ALL, BUT e EXCEPT: le anomalie originali

ALL non è una moltiplicazione del costo: ogni riferimento viene cercato nello
stato corrente e ogni azione cede separatamente il turno. Vale anche per gli
ordini a Watson: il nodo, il cursore di ricerca e il flag del record della
richiesta sopravvivono fra le visite dello scheduler e in Salva/Carica.

Il parser memorizza `PUT ALL ON YOUR ARMCHAIR` con ON/ARMCHAIR nel primo
gruppo fisico. La selezione dell'azione assegna poi quel gruppo al secondo
ruolo semantico. Inserire subito un gruppo vuoto nell'AST alterava i record.
Ora formato sintattico e ruoli dell'azione rimangono distinti.

I collettivi non forzano tutti i secondi riferimenti a diventare azioni:
`GIVE LAMP TO ALL`, nella stanza iniziale, sceglie Watson; `PUT LAMP ON ALL`
non trova una coppia univoca e non esegue nulla. Anche l'esaurimento silenzioso
ha un effetto sul contatore dei tentativi. TELL usa lo stesso requisito di
unicità del secondo argomento; i suoi soggetti di classe 7 comprendono anche
entità fuori scena, come il riferimento astratto INNOCENT.

**BUT/EXCEPT non filtra come ci si aspetterebbe in questa versione del gioco.**
B517–B548 richiama D36A partendo dall'indice dell'oggetto corrente, e D206
avanza prima di controllare un candidato. Nell'indice univoco del database
non può quindi restituire quello stesso oggetto per escluderlo. Il codice
mantiene i nodi di esclusione, ma nei casi verificati apre entrambe le porte
anche con `OPEN ALL BUT YOUR DOOR`, e DROP non risparmia l'oggetto nominato
nell'esclusione. La riscrittura conserva questa anomalia.

Un AND o una virgola dopo un'esclusione ha un altro effetto: AEEA trova
l'ultima coda ordinaria e ne sovrascrive il collegamento. Il vecchio nodo di
esclusione resta allocato e irraggiungibile; il nuovo nodo può restare senza
verbo. B39D interpreta i campi mancanti come jolly, selezionando qui NORTH.
Per questo `OPEN ALL BUT YOUR DOOR AND PLAIN DOOR` apre le porte e poi porta
Holmes nel ripostiglio. Non è stata applicata una correzione linguistica moderna.
Il blocco perso resta occupato anche nel salvataggio.

EXAMINE su persone conserva invece i rifiuti originali, senza pagare un
minuto o modificare lo stato di esame: `EXAMINE ALL BUT WATSON` può quindi
stampare i rifiuti per Holmes e Watson e poi esaminare i sei oggetti ammessi.

## Citazioni e pronomi

B049 accoda puntatori ai token, non copie delle frasi. DDA0/B86A consuma
**una sola citazione** dopo aver risolto il destinatario. Le altre restano
in coda; se il destinatario manca, resta anche la prima. Quando verrà letta,
il puntatore trova il contenuto corrente del buffer, eventualmente già
sovrascritto dal comando successivo. Ora la pagina consulta quei token vivi;
non conserva una vecchia stringa da eseguire in ritardo.

Sono confrontate citazioni multiple, un destinatario assente seguito da
un colloquio valido, citazioni rifiutate internamente, ordini coordinati e
più unità all'interno di una citazione. LOOK richiesto a Watson costa il suo
turno ma non stampa la descrizione di Holmes. Un successivo HELLO può essere
eseguito alla visita successiva, senza consumare anticipatamente il nodo.

Una citazione vuota viene comunque analizzata e può produrre una richiesta
vuota all’NPC: non viene semplicemente scartata. Una citazione senza
destinatario esplicito riutilizza l’ultimo destinatario; se è assente, il
parser torna alla selezione e conserva il nodo con `TALK TO WHAT ?` in attesa
di chiarimento. Sono verificati anche questi record e il comando successivo.

La modalità 0/1/2 appartiene all'intera analisi della citazione. La modalità
finale è conservata nel record della richiesta: non si decide separatamente
per ogni nodo se trattarlo come ordine o affermazione. HE, IT/THEY, THAT e
THEREFORE continuano a usare i riferimenti e la memoria del punto 2.
Sono conservati anche i rifiuti del parser originale: per esempio
`"BASIL KILLED MRS BROWN. HE IS INNOCENT"` fallisce internamente nel secondo
passaggio, mentre il passaggio da un ordine a HE può attivare il modo 2.
Un'affermazione digitata fuori dal colloquio non viene automaticamente
trasformata in una comunicazione a Watson.

## Ripetizione, numeri ed editor

`@` fuori da un chiarimento rianalizza l'ultimo input, compreso un input
lessicalmente errato. Cancella il prompt attivo senza ristampare la riga
precedente nella breve history. Durante una domanda viene ignorato come
ripetizione; l'Invio successivo produce la normale risposta vuota.

DAEF–DC12 è tradotto con due risultati distinti: valore e posizione di
ripresa del lexer. Sono preservati l'accumulo decimale con rotazioni a otto
bit, i limiti di ora/minuti e valuta, i flag AM/PM e il consumo dei punti.
Il separatore dopo le sterline non è necessariamente una barra: `£1/2S`
e `£1 2/6` sono riconosciuti come nell'originale. I casi non validi continuano
ad attraversare l'errore lessicale originale.

L'editor ignora i segni non accettati dalla routine D900, aggiunge i punti e
chiude le virgolette. La capacità è calcolata con il contatore a otto bit,
compreso il riporto delle chiusure automatiche. Diciotto chiamate isolate
verificano i confini da 0 a 140 tasti; quarantasei prove del lettore numerico
confrontano valore e cursore con la routine originale. La prova numerica
aggiunge spazio, punto e CR, come il laboratorio `native_lookup`.

## Tre confini ancora espliciti

Non considero equivalenti questi casi:

1. Una citazione residua può iniziare sul punto finale della nuova riga e
   ripristinare a 90 il suo terminatore C0. Un successivo B049 cerca una
   chiusura fuori dal buffer e può attraversare la memoria fino a tornare
   all'inizio dell'input. Due sequenze del corpus raggiungono questo ramo;
   l'originale avanza il tempo e poi produce WHAT, mentre il prototipo annulla
   l'intero input con un avviso esterno al testo del gioco.
2. Un input arrivato al confine fisico dell'editor può sovrapporsi al buffer
   dei token. La prova lunga raggiunge il limite di 96 byte del **ponte di
   ricerca**: quel messaggio non è attribuito al gioco. La pagina rifiuta
   la sovrapposizione prima di applicare il comando.

Queste tre storie sono testate separatamente come protezioni del prototipo,
non incluse nella certificazione delle 58 storie complete. Il loro prefisso
valido viene confrontato; l'annullamento conserva lo stato precedente e un
successivo INVENTORY rimane utilizzabile. Non significa che qualsiasi altro
colloquio possa aggirare lo stesso confine. Mancano qui le dipendenze della
scansione oltre memoria e non viene installata un'immagine RAM di ripiego.
Questi casi restano aperti nell'audit di equivalenza del punto 7.

## Verifiche e pagina

Il corpus naturale usa seed 1, tutti i 24 posti degli attori, LOOK iniziale
gratuito, grafica disabilitata dopo il primo prompt, input maiuscolo iniettato,
MORE immediato e nessun timeout. Non modifica posizioni o conoscenze.
Il limite artificiale di 70 tasti del ponte è alzato a 160 soltanto per la
prova di capacità; il codice del gioco resta intatto.

Per le 58 storie dichiarate vengono confrontati ogni sorteggio e ogni byte
letto, programmi/scadenze/argomenti degli attori, entità, fatti, stanze,
tutti i 752 byte dell'allocatore, code delle citazioni, pronomi, destinatario,
editor, token, bitmap superiori/inferiori e futuro dopo Salva/Carica.
Undici storie verificano inoltre righe e contatore di scroll prodotti dai
pacchetti reali della sessione web. I tre confini sopra non vengono nascosti
con normalizzazioni o risposte sostitutive.

`results/language/language.asm` separa tabelle, intestazioni e flag di lavoro
dalle istruzioni: **1.890 istruzioni e 4.108 byte** riassemblati identici.
Il rapporto numerico completo è `results/language-verification.json`.
La suite generale passa **533 test**.

Per provarlo: ricaricare la pagina sulla porta **8768**. Non serve riavviare
il server. Il passo successivo del backlog è il punto 5, conseguenze
dell'indagine e comandi/finali ancora mancanti; i confini appena descritti
restano esplicitamente aperti.
