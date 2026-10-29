# 5D22: byte basso dell’indirizzo video salvato

5D22 è stato aggiunto alla proiezione funzionale dei residui dello stack.
Il valore non viene copiato dalla traccia di una partita e non è una
costante 39: nel chiamante verificato deriva dalla colonna del testo.

## Il chiamante e il calcolo

L’ordine NPC passa da CE13 al testo compresso 682A, che richiama 6804 e
67F7. La stampa del prefisso del nome proprio dell’attore attraversa
A755/A7C5 e D3E8. I salvataggi di questi chiamanti portano l’ingresso di
C388 al frame 5D2A. È lo stesso percorso già ricostruito per i residui
superiori del prefisso; non è la profondità di qualsiasi stampa di un nome.

C38B salva HL, l’indirizzo video della prima scansione del carattere, a
frame−8/frame−7. C397 lo recupera dopo il calcolo dell’indirizzo del font;
C398 salva nuovamente lo stesso HL. Con frame 5D2A, il byte basso L è 5D22.
Le scansioni successive modificano H durante il disegno, senza cambiare
quel valore residuo salvato.

Il modello calcola già le coordinate del testo. Per la colonna `n`:

```text
x = 2 + 7*n
indirizzo = 0x5020 + floor(x/8)
5D22 = indirizzo & 0xFF     # soltanto con questo chiamante/frame
```

Per la colonna 8 l’indirizzo è 5027 esadecimale e il byte basso è 27
esadecimale, cioè 39 decimale. Il carattere e la riga del font non vengono
usati come sostituti dell’indirizzo.

## Ruoli distinti della stessa cella

| Frame d’ingresso C388 | Ruolo di 5D22 |
| --- | --- |
| 5D24 | F del chiamante |
| 5D26 | C del chiamante |
| 5D28 | E del descrittore del testo |
| 5D2A | L dell’indirizzo video salvato |
| 5D2C | C dell’ultima scansione |
| 5D2E | F dell’ultima scansione |

Le prove controllate distinguono tutti e sei i casi. Il runtime pubblica
il nuovo byte soltanto nello scope del chiamante ricostruito. Le scene
generiche, gli errori e le stampe senza un contratto verificato revocano
la proprietà, anziché mantenere un valore potenzialmente obsoleto.

Il JSON conserva il byte quando è noto. Nei vecchi salvataggi senza campo
rimane sconosciuto fino a una scrittura ricostruita; non viene completato
con il byte vicino, con il valore iniziale o con 39.

## Ultimo scrittore naturale

La cuoca, attore 9, legge 39 da5D22 a mercoledì07:05, tick2826,
come secondo operando della stessa estrazione che legge5D1C=7.
L’ultimo store reale di5D22 è C398, tick964, attore2 (Lestrade),
mentre viene stampata la r finale del prefisso «Inspector» nell’ordine al
cocchiere. Il frame è5D2A, HL=5027, colonna8, shift2. È una provenienza
distinta dal tick962 della pulizia che possiede5D1C.

Il probe confronta anche store invariati: non risultano transizioni di
valore non classificate nelle sei celle osservate. I76 comandi arrivano
naturalmente sino a mercoledì07:20. Il modello confronta tutti i valori
pubblicati ai checkpoint, la lettura per valore/tick/attore e la persistenza
dopo interruzione dell’attesa e LOAD. 895 test distinti verificati; i lotti
e l’aggiustamento del driver SAVE durante WAIT sono esplicitati in checks.json.

## Prove

Il nuovo corpus ABI chiama C388 nell’originale con sei frame, tre caratteri
e tutte le 36 colonne: 648 casi. Confronta il byte fisico 5D22 e tutti gli
altri campi pubblicati che ricadono nell’estratto osservato. Nel frame
5D2A copre oltre venti indirizzi distinti, oltre agli otto allineamenti
orizzontali. Sono setup controllati, separati dalla partita naturale.

Il probe naturale segue la storia major-witness con seed 1, tutti i 24
posti attore, LOOK iniziale gratuito, grafica originale disattivata dopo
il boot, input maiuscolo iniettato e MORE immediato. Osserva le scritture
PUSH/CALL ed EX(SP),HL, comprese quelle che ripetono il valore precedente;
le eventuali variazioni non classificate sono elencate separatamente.

Sono osservate anche le celle vicine 5D23–5D27 per distinguere i frame,
ma questa integrazione non introduce nuovi valori per esse. Il probe
conserva gli ultimi 24 store per intervallo e l’ultimo writer di ogni
cella: non pretende di salvare ogni istruzione eseguita.

La precedente prova naturale di 5D1C ora attraversa il secondo operando
senza richiedere il vecchio blocco su 5D22; resta un confronto della sua
provenienza e lettura. Il confronto completo del prefisso verifica invece
ogni estrazione/lettura, tutti gli attori, entità, fatti, arena di 752 byte,
bitmap esatte e futuro dopo LOAD, compresi i minuti live.

## Avanzamento e limite successivo

Il prefisso viene esteso a 359 checkpoint, da 0 a 358, sino a mercoledì
07:30: tre checkpoint e trenta minuti oltre il precedente. La ricerca
completa si arresta al checkpoint 359, verso mercoledì 07:40, su A01C,
un byte mutabile coinvolto nella risoluzione dei riferimenti del parser.
Va ricostruito dai suoi scrittori e lettori: non dedurlo automaticamente
né dal contatore ALL/BUT a A01A né dal chiarimento a A01B.

I cinque finali ancora privi di certificazione naturale rimangono aperti.
Il fatto di superare un nuovo ingresso casuale non certifica tutti i finali.

I risultati sono in `results/glyph-address/` e
`results/glyph-address-verification.json`. Le prove si ripetono dalla
cartella `sherlock-js` con:

```sh
node --test test/glyph-address.test.mjs test/glyph-shift.test.mjs
node tools/verify-witness-prefix.mjs
```

## Atlante sincronizzato

| Intervallo incluso | Approfondimento |
| --- | --- |
| 682A–682F | Dati compressi del testo degli ordini NPC |
| A59F–A5CC | Ingresso pubblico del testo e salvataggi degli argomenti |
| A720–A770 | Nome dell’attore e chiamate testuali annidate |
| A7C5–A7CF | Descrittore del nome e renderer delle entità |
| A95B–A98F | Scrittore alternativo dello stack nel decoder |
| C388–C3E3 | Salvataggio e riuso dell’indirizzo video |
| CE10–CE17 | Stampa dell’ordine dopo la registrazione della richiesta |
| D3E8–D447 | Prefissi e sostantivo finale, con scarico differito |

Il dossier verifica 221 istruzioni e 393 byte, inclusi i dati, contro il
payload e mediante riassemblaggio. Nessun byte prima grigio cambia stato:
sono approfondimenti di intervalli già classificati. È aggiornata anche
l’annotazione di 5D22 nel workspace dello stack, fuori dal payload.
Restano 38.359 byte documentati, 471 parziali e 2.770 sconosciuti.
