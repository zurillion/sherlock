# Conversazioni e pagamento: stato del lavoro

**Aggiornamento 24 ottobre 2026:** saluti e TELL sono ora attivi nelle nuove partite Watson v4. Ricaricare e premere Riavvia; i vecchi salvataggi conservano il profilo precedente. La sorgente genera gli ingressi delle prove dichiarate, senza replay. [WATSON-RUNTIME.md](WATSON-RUNTIME.md) e il relativo rapporto sostituiscono il precedente stato di conversazioni bloccate. L'integrazione completa di Watson, cabbie e Lestrade resta incompleta.

## Disponibile nella pagina

È collegata l'azione ordinaria `PAY … TO …`, anche per gli ordini differiti già supportati di Watson. Su una strada della rete è possibile provare:

```text
HAIL CAB
PAY 1/- TO CABBIE
PAY 2/6 TO CABBIE
COUNT MONEY
```

Questo trasferisce denaro; non esegue il servizio completo del cocchiere. Viaggio, richiesta della tariffa, proteste, resto e partenza restano mancanti. Il confronto del pagamento del cab usa cocchieri disabilitati in entrambi i motori; non è una prova della loro AI.

Sono preservati gli effetti verificati dell'originale: costo di un minuto, ricerca del conto fra i figli diretti, addebito anche se il destinatario non ha un conto, codifica monetaria e messaggio generico `DON'T BE SILLY.` nel percorso ordinario di fondi insufficienti. `6d.` mantiene il punto e capitalizza il successivo `To`. Le somme in sterline intere non aggiungono `0/-`. Il lexer ora consuma i punti dopo valuta e suffissi AM/PM, come DB3D: il punto in `PAY 6d. TO WATSON` non separa due comandi. Il simbolo della sterlina compare correttamente anche negli errori lessicali.

`PAY 1/-` senza `TO` resta esplicitamente mancante. L'originale dà un errore generico ma, nel profilo osservato, passa comunque al tick seguente senza aggiornare la scadenza di Holmes. Non è stato sostituito con un costo inventato.

## Parti condivise implementate e verificate separatamente

`src/conversation.mjs` ricostruisce la ricerca nella tabella E22A–E28B: attore, soggetto, testo. L'attore FE è il ripiego quando non esiste una tabella propria dell'interlocutore; non è un ripiego dopo una ricerca fallita nella tabella di un attore conosciuto. In mancanza di una voce per il soggetto viene selezionato il testo 761D. La ricerca non consulta le descrizioni degli oggetti o una memoria inventata.

`src/text.mjs` gestisce l'argomento testuale della risposta e un selettore esplicito. Il contesto del selettore è derivato dalle operazioni del testo: riferimenti relativi, parole, nomi, possessivi, copula e ritorno dal frammento. Non viene copiato dall'osservazione originale. In particolare il saluto arriva a FFF4 e il prefisso `says`/`remarks` a FFF3 attraverso riferimenti diversi. La selezione continua a usare la formula inversa del generatore originale.

La dipendenza casuale riguarda anche il prefisso della risposta. Avere decodificato il contenuto di `TELL ME ABOUT LESTRADE` non autorizza a scegliere sempre `Watson says`. Il nuovo profilo giocabile riceve il provider di ingressi generati; i vecchi file senza stato casuale restano esplicitamente bloccati. Le selezioni annidate, che nell'originale condividono i contatori del selettore, sono rifiutate esplicitamente invece di applicare una normale ricorsione. I nomi propri degli NPC e quelli generici, come `the cabbie`, conservano ora le maiuscole distinte.

## Prove e loro limiti

Il rapporto corrente dei test è in results/verification.json; il pacchetto isolato usa solo Node, senza Python o un backend di gioco. Le nuove prove comprendono:

- 90 esecuzioni originali isolate del corpo TELL: tabella attore/soggetto, testo con maiuscole conservate e spaziatura normalizzata, contesto generato della scelta, aritmetica e stato successivo del generatore.
- 48 casi originali di testo, su sei accumulatori iniziali: contesto all'ingresso, parola, parola frequente, possessivo, copula, letterale, ritorno da una chiamata e saluto. Si confrontano contesto, indirizzi e valori letti, stato casuale e testo.
- Sequenze di pagamento con Holmes e Watson: messaggi, orologio, scadenza di Watson e tre conti. Una sequenza separata controlla il conto del cab con driver disabilitati.
- 16 confini lessicali originali per numeri, punti, virgolette e separatori, compresi i casi che devono essere rifiutati.
- Salvataggio/caricamento dopo trasferimenti e con un ordine di pagamento ancora pendente.

**Nelle prove di componente elencate sopra, i byte sorgente delle estrazioni sono forniti dalle fixture soltanto nei test. Non sono replay del gioco eseguiti dalla pagina e non dimostrano che il modello generi quelle sorgenti.** Non viene dichiarata la parità di seed o di una partita con tutti gli attori attivi. I confronti testuali non certificano i pacchetti di schermo completi.

Per riprodurre le nuove osservazioni offline:

```sh
python3 tools/probe-conversation-reference.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output test/fixtures/conversation-reference.json
python3 tools/probe-text-context.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output test/fixtures/text-context-reference.json
python3 tools/probe-number-periods.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output test/fixtures/number-periods-reference.json
node --test test/*.test.mjs
```

Le prove runtime successive generano gli ingressi senza fornirli dalla fixture e sono documentate in WATSON-RUNTIME.md. Resta da completare la sorgente casuale condivisa con tutte le sue dipendenze, completare la selezione semantica delle richieste, fatti/affermazioni/deduzioni e callback, collegare servizio cab e programmi degli altri attori, e confrontare le sequenze complete e i salvataggi. I criteri restano quelli di [FIDELITY.md](FIDELITY.md).
