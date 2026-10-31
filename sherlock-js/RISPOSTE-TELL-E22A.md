# Risposte TELL e tabella E22A–E28C

31 ottobre2026. Ricostruito il limiteE22E emerso dopo la ricerca uscite.
Il blocco era un dato non esposto al generatore casuale. La selezione funzionale
 dei dialoghi esisteva già; ora lookup e letture casuali derivano dalla stessa
 struttura tipizzata, mantenendo l’ordine fisico originale. Non è stata aggiunta
 una risposta simulata o una costante17 isolata.

## Formato

99 byte immutabili: dieci sezioni, ciascuna con un byte parlante, zero o più
 triple `[argomento byte, indirizzo testo word little-endian]`, un terminatoreFF.
 Un altroFF termina la tabella esterna. FE è la sezione del parlante predefinito.
 Nove sezioni specifiche piùFE;26 triple complessive. Il confine esclusivo èE28D:
 l’ultimoFF èE28C. Il precedente builder controllava il cursore sulFF finale,
 non sul byte seguente: non confondere quei due indirizzi.

| Inizio | Parlante | Argomenti → testo |
|---|---|---|
| `$E22A` | 8 gardener | 16 what happened → `$7846`; 17 your alibi → `$7846`; 7 major percival ffoulkes → `$78F8` |
| `$E235` | 9 cook | 16 what happened → `$794F`; 17 your alibi → `$794F`; 6 basil phipps → `$79C4` |
| `$E240` | 10 maid | 16 what happened → `$7A35`; 17 your alibi → `$7A35` |
| `$E248` | 6 basil phipps | 16 what happened → `$7AB9`; 17 your alibi → `$7AB9`; 18 your address → `$772C` |
| `$E253` | 5 daphne strachan | 16 what happened → `$7AF6`; 17 your alibi → `$7AF6`; 13 tricia fender → `$76A4`; 7 major percival ffoulkes → `$78D4` |
| `$E261` | 4 chief constable straker | 15 case → `$7371` |
| `$E266` | 7 major percival ffoulkes | 17 your alibi → `$780C`; 18 your address → `$7722` |
| `$E26E` | 13 tricia fender | 67 bloodstained clothes → `$7687` |
| `$E273` | 95 mrs jones | 67 bloodstained clothes → `$7687`; 16 what happened → `$7644`; 17 your alibi → `$7644`; 13 tricia fender → `$762D` |
| `$E281` | 254 FE · predefinito | 18 your address → `$6845`; 16 what happened → `$6845`; 17 your alibi → `$6845` |

E22A=8 identifica il giardiniere. E22B=16 è what happened; E22C/D è il testo7846.
**E22E=17 è your alibi**, seguito dalla stessa word7846 aE22F/30. Sono dati,
 non istruzioniZ80. Il fatto che due argomenti puntino allo stesso testo è reale.

## Selezione funzionale

E1D8 prende il PARLANTE daA036. Il destinatarioA034 non sceglie la sezione.
E207 attraversa le sezioni; usa quella del primo attore corrispondente,
 altrimenti si ferma suFE. Il suo E21F/D34E salta una sezione cercando il suoFF.
E1E0 salta il tag del parlante; E201/D34E cerca la prima tripla con argomentoA035.
 Se manca, la risposta è761D: **non si torna a cercare quell’argomento inFE**.
 Per esempio Watson3 usaFE per argomento18 e sceglie6845; il giardiniere8 ha una
 sezione propria ma non18, quindi sceglie761D. Le mappe logiche conservano questa
 distinzione; la serializzazione conserva anche l’ordine8,9,10,6,5,4,7,13,95,254.
 Ordinare numericamente gli oggettiJSON avrebbe alterato le letture casuali.

D34E percorre triple con passo3, restituisceIX sul record trovato o sulFF.
 Il confronto con la chiave precede quello conFF. I selettori modificano registri,
 non il contenuto della tabella. Il lettoreE1D8–E229 non la scrive; nessuno degli
 store diretti catalogati nell’eseguibile ne interseca i99byte. I setup ABI ne
 verificano inoltre l’invarianza. Non è uno stato iniziale mutabile da ripristinare.

## Correzione autonoma

`tools/build-conversation-topics.mjs` decodifica i record, verifica i puntatori
 nella prosa e il confine, genera le mappe usate daConversation e riserializza
 ogni byte nell’ordine sorgente. Il roundtrip deve coincidere con il payload.
 La struttura entra inrandomInputs.worldLayout.tables ed è letta daWorldSource:
 il motore già usava quel resolver per gli asset tipizzati. Nessun interpreteCPU,
 replay o fallback della RAM originale viene introdotto. Le risposte del gioco
 non cambiano per effetto della sola correzione: si completa l’ingresso casuale.

SAVE/LOAD non richiede nuovi campi mutabili: la tabella appartiene alla versione
 originale dell’asset, già identificata daSHA256. Un vecchio pacchetto dati senza
 questa tabella resta esplicitamenteunknown aE22E. Un vecchio salvataggio caricato
 con gli asset aggiornati ha invece gli stessi dati immutabili dell’originale.

## Prove

Nuove3072 chiamate originali ai selettoriE207/E201: tutti256valori del byte attore
 per12argomenti presenti/assenti, inclusiFE/FF. Confronto della sezione scelta,
 del record o terminatore restituito e del testo finale. La tabella resta identica
 dopo ogni coppia. È prova ABI dei selettori, non ammissibilità di attori arbitrari
 nel gioco e non certificazione di ogni possibile stampa dei testi selezionati.

Il riferimento naturale completo già acquisito è RIUTILIZZATO con percorso/SHA,
 non una nuova traccia lunga. Al checkpoint498/draw24, giardiniere8, leggeE228=175
 edE22E=17; la nuova struttura produce quella lettura senza valore registrato
 installato nel runtime. I rapporti conservano tutti i campi della draw.

Certificato positivo separato:512checkpoint0–511 finoThu08:40,10144draw e21630read;
 10146drawruntime comprendono2boot. Tutti24posti attore, entità, fatti, programmi,
 arena752byte, bitmap e futuro dopoLOAD. Nessuna normalizzazione del confronto.
 La partita non è conclusa: **prossimo5D30 al512 versoThu08:50**, cuoca9/draw15,
 originale26. Quello è un altro ingresso, da ricostruire senza dedurlo dai vicini.
 Checkpoint512 escluso dal positivo. Il rapporto lookahead è una prova di scoperta
 separata dal certificato positivo, non un finale naturale riuscito.

## Atlante e ripresa

Nuova zona datiE22A–E28C:99byte prima grigi ora documentati. Approfonditi i lettori
E1D8–E229 eD349–D369. In tutto60istruzioni/214byte riassemblati sul payload.
 Copertura38949documentati/428parziali/2223sconosciuti su41600. Questa metrica
 classifica byte, non percentuale di gameplay equivalente. Verifica browser
 e anteprima salvate insieme al listato.

Ripetibile con `python3 tools/probe-conversation-topic-table.py`,
 `node tools/verify-conversation-table-prefix.mjs` e
 `node tools/verify-conversation-table-lookahead.mjs`.
 Il builder completo è `node tools/build-data.mjs`; l’atlante si rigenera con
 `python3 tools/build-conversation-table-listing.py` e `python3 tools/build-memory-map.py`.

Conservare gli altri limiti: cinque finali naturali, cab5D0C, PRINT/MORE, TAKE TO
 e il dialogoWatsonKilledYou(7drawJS/10nativo). Nessuna equivalenza globale dichiarata.

Verifica finale:21 controlli mirati e suite completa1801/1801PASS, zero errori,
 skipped o cancelled. Il pacchetto dati cambia soltanto per l’aggiunta della
 tabella inworldLayout.tables; il fixture speciale mantiene il formato precedente.
