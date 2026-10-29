# A01C: modalità della ricerca e continuazioni ALL

A01C contiene 0 per la risoluzione ordinaria oppure 128 per una ricerca
ALL in corso. Non è una copia generica del testo dell’ultimo comando:
il giocatore e ogni richiesta rivolta a un NPC possiedono una continuazione
separata, che viene caricata prima della ricerca semantica.

| Stato | Significato |
| --- | --- |
| A01A | Flag lessicale ALL/BUT: 0, 1, 2 |
| A01B | Offset fisico del chiarimento: 0, 08, 12 esadecimali |
| A01C | Modo condiviso del resolver: 0 oppure 80 esadecimale |
| D6B8 | Modo conservato dal giocatore fra azioni e visite NPC |
| Record richiesta +2 | Modo conservato da quella richiesta NPC |
| B39C | Bit ALL del nodo appena esaminato dal confronto dei modelli |

B39C è spiegato nel dossier ma non viene introdotto come nuovo ingresso
casuale posseduto dal runtime: la sua eventuale lettura richiederà un
contratto distinto. Anche A01D/A01E e gli altri temporanei non sono
riempiti copiando l’intera area del parser.

## Quattro scrittori, non un reset a ogni input

- D800 copia D6B8 prima di ogni tentativo semantico del giocatore.
- B959 copia il byte +2 del record prima di risolvere una richiesta NPC.
  Le affermazioni passano prima da BA20; le richieste prefabbricate passano
  da B98C. Questi due percorsi non ricevono una scrittura B959 inventata.
- B1EC, soltanto se A01C è zero e il modello è stato riconosciuto, copia
  il bit ALL del nodo da B39C. Può quindi riscrivere zero oppure scrivere 128.
- B1FD azzera A01C quando il bit4 del modo del modello richiede una sola
  selezione. Nei 54 modelli estratti il flag è presente per CLIMB INTO e HAIL.

A041 azzera realmente D6B8 all’avvio. A01C invece mantiene il dato iniziale
caricato, zero: l’avvio completo con seed 0, 1, 17 e 255 non attraversa i
quattro scrittori e non cambia quel byte. Il dato iniziale è usato solo
per una nuova partita. Un vecchio JSON senza il campo rimane sconosciuto
fino a una scrittura ricostruita; non viene riempito con zero o con ALL.

Gli errori lessicali e sintattici prima del resolver non raggiungono D800.
Per esempio, dopo OPEN ALL esaurito il residuo può rimanere 128 attraverso
XYZZY e la sua ripetizione con @. Non deve essere azzerato alla pressione
di Invio, all’avvio del parser o dopo un’azione riuscita.

## Ricerca e proprietà dei nodi

In modo ordinario il resolver conta i candidati per distinguere un nome
univoco da un’ambiguità. Con A01C nonzero riprende il cursore già salvato e
si ferma al primo candidato accettabile, mantenendo il nodo fra azioni e
turni NPC. L’ultima ricerca senza candidati è un vero tentativo aggiuntivo.

D81B conserva il modo del giocatore dopo il successo semantico, prima del
corpo dell’azione e delle visite NPC. D85C azzera D6B8 sul fallimento, senza
azzerare A01C. Pertanto ALL esaurito può lasciare A01C=128 e D6B8=0. Un NPC
può nel frattempo sovrascrivere il modo globale: il successivo passo del
giocatore deve ripristinare il proprio contesto.

I due modelli a selezione singola possono conservare ALL nel nodo lessicale
ma azzerano il modo semantico. Il modello JavaScript ora usa il flag estratto
per non trattare CLIMB INTO ALL o HAIL ALL come più azioni consecutive e per
non chiedere un chiarimento laddove il resolver sceglie il primo referente.
I metadati dei 54 modelli sono stati confrontati col payload; gli altri dati
del gioco rimangono identici.

## Richieste NPC e comandi successivi

B97C salva il modo nel record dopo un passo riuscito. Se è nonzero il nodo
ALL rimane allocato; se è zero si avanza alla sintassi successiva.

Quando ALL esaurisce la ricerca, B9B4 azzera il modo nel record, B9CA rilascia
il nodo e B9C7 torna al comando successivo della stessa richiesta. Non scarta
il suffisso come nel rifiuto di una richiesta ordinaria. B9EC salta inoltre
i nodi BUT/EXCEPT, identificati dal bit6: non vanno eseguiti come comandi. È stato corretto
anche questo ramo nel runtime, includendo il reset del cursore privato prima
di un eventuale secondo ALL.

La prova dedicata usa `SAY WATSON "OPEN ALL AND CLOSE ALL"` e visite successive
con I. Confronta scritture, richieste, nodi rimasti/liberati, turni, mondo,
bitmap e futuro dopo LOAD; non si limita a controllare le frasi stampate.

## Protocollo delle prove

Le sequenze ripartono da seed 1, con tutti i 24 posti attore, LOOK iniziale
gratuito, grafica originale disattivata dopo l’avvio, input maiuscolo
iniettato e MORE immediato. Per SAVE, PRINT, NOPRINT e PAUSE si usa lo stesso
adattatore delle periferiche già dichiarato nel corpus dei chiarimenti;
non sono applicate patch agli attori o al mondo.

Ogni passo confronta tutte le scritture A01C, comprese quelle invariate,
i due modi all’ingresso di ogni estrazione, tutte le letture casuali e lo
stato completo: attori, entità, fatti, 752 byte dell’arena e bitmap esatte.
Si verifica poi la prosecuzione da un salvataggio JSON. I confini dei chunk
JSON del ponte Python non appartengono al gioco originale: il canale errori
è confrontato tramite bitmap e cursore esatti, senza normalizzare i pixel.

Il corpus include errori, @, chiarimenti, servizi, frasi concatenate,
citazioni, ALL/BUT, richieste NPC e i modelli che forzano un solo referente.
Le prove di proprietà verificano parsing preventivo privo di effetti,
valori assenti nei vecchi salvataggi e validazione dei byte.

**956 test distinti verificati**: la regressione estesa e il successivo lotto
di 154 test sul ramo corretto sono registrati separatamente in checks.json.

Il corpus finale comprende **60 sequenze e 180 input**, con **375 scritture**,
**679 estrazioni e 1.358 letture** confrontate. Il rapporto `checks.json`
registra anche la regressione generale e le prove di avvio e dei modelli.

## Limite della certificazione

Il confronto esteso supera A01C, ma la seconda lettura della stessa
estrazione del giardiniere incontra A022, ancora sconosciuto. Rimane il
checkpoint 359, diretto a mercoledì 07:40. Il prefisso completo certificato
resta 0–358: 359 checkpoint sino a mercoledì 07:30, 6.834 estrazioni e
14.644 letture confrontate, tutti gli attori, arena, bitmap e futuro LOAD.
Non è un nuovo finale certificato; le cinque varianti ancora aperte restano
nel punto di ripresa.

Riferimenti: `results/resolution-mode/` e
`results/resolution-mode-verification.json`. Per ripetere:

```sh
node --test test/resolution-mode.test.mjs
node tools/verify-witness-prefix.mjs
```

## Atlante

213 istruzioni e 518 byte sono confrontati col payload e riassemblati.
A01C, prima parziale, diventa documentato. Non cambia nessun byte prima
grigio: gli altri intervalli sono approfondimenti di zone già classificate.

- A01C; D6B8: modo globale e continuazione del giocatore.
- A040–A047: reset all’avvio.
- 82B1–82B8 e 8349–8350: dati dei modelli CLIMB INTO e HAIL.
- B1DD–B258: selezione del modo e primo referente.
- B280–B2B6: ricerca delle coppie.
- B39C; B39D–B3AF: dato ALL del nodo e suo scrittore.
- B936–B98B; B9AC–B9F9: contesto delle richieste NPC e fine di ALL.
- D7FC–D87C: trasferimenti e rilascio dei nodi del giocatore.

Copertura documentale: 38.360 byte documentati, 470 parziali e 2.770
sconosciuti sui 41.600 del payload. Queste quantità non misurano
equivalenza di tutti i percorsi di gameplay.
