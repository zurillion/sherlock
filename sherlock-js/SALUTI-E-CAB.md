# Separazione dei comandi, saluti e chiamata del cab

23 ottobre 2026. Correzioni della fase 3 del motore autonomo JavaScript.

## La riga vuota

L’originale introduce un CR prima del testo di ogni azione del giocatore. Non aggiunge una riga per ogni messaggio degli NPC o minuto di attesa. Il risultato visivo è una riga vuota tra gli output dei comandi. Gli errori e le richieste di chiarimento nella zona inferiore non modificano la zona superiore.

`Game.submit` marca il primo messaggio narrativo di ogni azione con costo; `ClientSession` genera il CR prima dei suoi pacchetti. Il formatter e il contatore MORE restano quelli già tradotti. Non vengono aggiunti messaggi artificiali agli indici dei fotogrammi del tempo. L’avvio conserva il suo CR già esistente.

La fixture `test/fixtures/paragraph-reference.json` conserva lo schermo iniziale e due WAIT originali dal precedente studio dello scrolling. Partendo dalla stessa griglia, i due WAIT JS producono esattamente le righe, il contatore, le colonne residue e gli scroll attesi. WAIT distribuito in minuti produce solo i due avanzamenti di riga previsti; WAIT. WAIT ne produce quattro, salvo eventuali interventi NPC che aggiungano testo.

## Salutare Watson

```text
SAY TO WATSON "HELLO"
SAY "HELLO" TO WATSON
```

`HELLO` e `HELLO WATSON` non sono equivalenti a questi ordini: nell’originale producono `HI.` nella zona comandi e non consumano un turno. La citazione invia invece una richiesta al destinatario. Il programma di Watson la esegue quando raggiunge il punto ordinario in cui esamina gli ordini.

Durante FOLLOW alcuni passaggi non esaminano subito la nuova richiesta. La traccia originale mostra FOLLOW → HELLO senza risposta immediata → WAIT con risposta. La richiesta è conservata anche nei salvataggi; non è necessario ripetere il saluto.

Il testo originale 6920 compone il nome dell’attore e la risposta. Il frammento 6918 sceglie casualmente fra Hello e il frammento temporale 6902: Good morning, Good afternoon o Good evening. **Per ora scegliamo esplicitamente la variante temporale originale.** Non è ancora ricostruita la sequenza delle estrazioni originali. Lo stato espone `greeting_variant: original-time-of-day-without-rng-parity`; le altre scelte testuali mancanti continuano a produrre un avviso. Non abbiamo introdotto un generatore casuale sostitutivo.

## Chiamare il cab

```text
HAIL CAB
GET INTO CAB
GET OUT OF CAB
```

Il controllo di disponibilità originale E298 richiede una strada della rete e un veicolo libero fuori mappa. E2C7/E2CB effettuano la chiamata con costo uno e spostano il cab; i discendenti, cocchiere e denaro, ne seguono la posizione. E2EE prepara il contesto del cocchiere. Gli indirizzi servono da riferimento all’analisi: il runtime usa regole e oggetti logici JS.

Le dieci strade sono gli ID 5, 10, 12, 14, 18, 24, 28, 32, 40 e 45. Se entrambi i cab sono liberi viene scelto il primo, ID 30; una seconda chiamata può portare il secondo, ID 33. Se entrambi sono già presenti la chiamata non trova un altro cab. La rete viene esportata nei dati, senza percorsi inventati. GET CAB non viene trasformato in una chiamata: senza cab presente conserva l’errore originale.

La regola speciale E3EA controlla l’ingresso nel cab e il vincolo di contenimento, poi E413 aggiorna il genitore. Non si applica il controllo generico del peso usato per altri contenitori, che avrebbe erroneamente impedito a Holmes di salire con il suo inventario. Salita e discesa costano due unità nelle tracce verificate. Gli oggetti trasportati restano discendenti di Holmes.

I cocchieri sono identificati sulla mappa dai segnaposti C1/C2. L’arrivo crea un contesto logico salvabile, ma il loro programma resta disabilitato con un avviso esterno al testo del gioco. **Non sono tradotti saluto del cocchiere, attese, ordini di destinazione, viaggio, pagamento, resto, debito e reazioni.** Non si fanno avanzare contatori inventati per simulare questi comportamenti. Non viene attivata automaticamente l’AI originale né usato il vecchio motore come ripiego.

## Prove e limiti

- 212 test automatici complessivi, zero fallimenti.
- `tools/probe-feedback-reference.py` registra sette sequenze / 18 comandi dell’originale. I test confrontano sei sequenze / 15 comandi: testi normalizzati, orario e genitore/locazioni/attributi di dieci entità selezionate. I confronti dei saluti attestano queste tracce e la variante scelta, non la parità casuale generale.
- Nelle tracce di chiamata, salita e discesa i programmi dei cocchieri sono disabilitati nel riferimento. La settima sequenza, con cocchieri attivi, documenta il saluto e il programma ancora da tradurre e non viene dichiarata equivalente.
- Due WAIT verificano le righe originali dello schermo; altre prove coprono separazione fra azioni, assenza di separazioni per minuto e nessuna riga supplementare prima della risposta NPC.
- Sono verificati salvataggio di un saluto differito, ripresa durante FOLLOW, contesto del cab e propagazione di cab/cocchiere/denaro nelle dieci strade.
- Nessuna di queste prove certifica il gioco completo, la casualità originale, tutti i contenitori o ogni contesto di paginazione.

Dopo l’aggiornamento ricaricare la pagina sulla porta 8768. Non occorre riavviare il server né azzerare la partita del vecchio motore sulla porta 8766. I salvataggi JS versione 3 continuano a essere caricabili; il nuovo contesto del cab usa campi logici facoltativi dello scheduler.

Verifica nel browser: saluto quotato, WAIT di cinque minuti, righe vuote, HAIL CAB, salita e discesa eseguiti dalla UI Spectrum. Il segnaposto C1 compare su Baker Street. `results/feedback-browser.json` conserva il testo DOM osservato; `feedback-watson.png` e `feedback-cab.png` mostrano il risultato. Nessun server è stato riavviato.
