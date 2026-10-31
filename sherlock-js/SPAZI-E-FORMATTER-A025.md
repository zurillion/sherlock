# A025: spazi iniziali, buffer e output invisibile

A025 è il flag persistente della normalizzazione dei caratteri, non uno stato
del parser. Lo0 sopprime uno spazio; qualsiasi valore nonzero permette lo
spazio, che viene poi ricondotto a1. L’iniziale0 viene estratto dal payload,
non inventato da WAIT o dalla fine di un comando. Quattro avvii originali con
seed1,2,77,255 confermano0 al primo prompt.

## I tre writer

- **AA2C scrive1** per ogni carattere non soppresso. Vale anche per CR e
  virgoletta. Uno spazio con flag0 ritorna prima dello store.
- **AA36 scrive0** dopo il passaggio precedente, soltanto per il CR normalizzato.
- **AA08 scrive0** dopo lo svuotamento di una parola, soltanto se la lunghezza
  era esattamente uguale alle colonne rimaste **prima** dell’eventuale wrap.

A9B7 conserva il confronto iniziale nello stack. Una parola di36 caratteri
che richiede prima un CR perché resta una sola colonna non esegue AA08:
non basta osservare che il nuovo cursore sia tornato a inizio riga.
Il wrap grezzo di C1E1/C2BA e C142, che cambia la finestra, non sono writer.
Neppure lessico, prompt, backspace e tasti di MORE costituiscono un reset.
Il canale inferiore salta A9B7/AA14 e non aggiorna il flag.

## Anche ciò che non si vede

A887 ritorna prima del buffer per nomi e parole del dizionario quando5C3C=0.
I caratteri letterali dei testi, invece, attraversano ancora A9B7 e AA14.
C1E1 scarta i pixel solo dopo questi aggiornamenti e non muove il cursore.

Il motore autonomo aggiorna ora il flag anche in questo percorso. Le richieste
di pagamento e i loro suffissi numerici, inclusa la chiusura della frase,
seguono la stessa regola. La nuova prova continua controlla il valore anche
prima di estrazioni che non leggono direttamenteA025: questo ha individuato
il suffisso monetario invisibile che inizialmente mancava dalla proiezione.
Non si sostituisce l’output fuori scena con un reset generico alla fine del turno.

## JavaScript e salvataggi

Il campo è `world.display.spacingFlag`, indipendente da `started`, dal cursore,
da `pending` e da A024. Lo legge il proiettore degli ingressi casuali.
La parola ancora nel buffer non esegue AA14; il flag cambia quando viene
svuotata. Il flag viene serializzato; un vecchio SAVE che non lo contiene
rimane sconosciuto, anche se il cursore e i byte vicini sono noti. Un CR o
un altro writer dimostrato può ristabilirne la proprietà. Nessun fallback
inserisce lo0 catturato nella partita di riferimento.

La logica applica le conseguenze del formatter; non esegue istruzioni Z80.
Il passaggio intermedio1→0 del CR non contiene chiamate casuali: la funzione
JavaScript pubblica direttamente il risultato0, senza simulare i singoli store.

## Prove e ambiti

`tools/probe-output-spacing-abi.py` conserva480 chiamate originali controllate:
A9B7, AA14 e C1E1; visibilità accesa/spenta; flag0,1,255; colonne1,2,4,36;
spazi, CR, virgolette, backspace, parole corte e lunghe36/37. Si confrontaA025
dopo ciascun carattere. I dati di setup sono espliciti; non sono una prova che
tutte queste combinazioni si raggiungano naturalmente. Il codice originale
non viene modificato.

`tools/probe-output-spacing.py` registra separatamente brevi storie naturali
con stato completo e una nuova acquisizione continua del ramo major-witness.
Include tutti24 i posti attore, seed1, LOOK iniziale gratuito, grafica nativa
spenta dopo il boot, input maiuscolo iniettato e MORE immediato. Gli store
originali invariati sono inclusi; eventuali transizioni non classificate non
vengono ignorate. La traccia continua contiene snapshot del clock, flag,
writer ed estrazioni: non è da sola un certificato di stato completo.

Il certificato di stato completo usa separatamente il riferimento originale
major-witness già archiviato. Confronta entità, fatti, programmi,24 attori,
tutti752 byte dell’arena, bitmap, ogni draw/read e futuro dopo LOAD.
I rapporti JSON distinguono questi ambiti e conservano il primo limite escluso.

## Atlante e riproduzione

150 istruzioni e276 byte sono riassemblati contro il payload:
A025; A9B7–AA70; A887–A8AB; C1E1–C1F3; C129–C149.
A025 passa da parziale a documentato. Nessun byte prima grigio riclassificato:
38.848 documentati,429 parziali,2.323 sconosciuti su41.600.
A026, relativo alle maiuscole, rimane un contratto distinto ancora da ricostruire.

```sh
python3 tools/probe-output-spacing-abi.py
python3 tools/probe-output-spacing.py
python3 tools/probe-output-spacing.py --witness
node --test test/output-spacing.test.mjs
node tools/verify-output-spacing-continuous.mjs
node tools/verify-output-spacing-prefix.mjs
node tools/verify-output-spacing-lookahead.mjs
python3 tools/build-output-spacing-listing.py
python3 tools/build-memory-map.py
```

I risultati conclusivi, i conteggi e il prossimo ostacolo sono salvati in
`results/output-spacing-verification.json` e nel punto di ripresa.


## Risultato delle verifiche naturali

Nove storie brevi:34 input,64 checkpoint,199draw/398read,2.796store osservati.
La traccia continua termina a mercoledì21:40:3.571checkpoint,9.000draw e
19.260read, senza transizioniA025 non classificate. Watson3 legge0 al tick3700
(mercoledì21:39); l’ultimo writer originale è AA36 al3698, attore36 (treno).
Sono verificati il flag a ogni minuto e a ogni draw e tutti i draw/read.

Il certificato completo separato copre463checkpoint0–462 fino a giovedì00:30,
9.237draw e19.736read;9.239draw runtime includono le due del boot.
Il checkpoint463 verso giovedì00:40 è escluso: Watson3 leggeA026 nel draw17,
valore originale1. È il prossimo contratto da ricostruire. Non installare1
catturato né dedurlo dal flag vicino. I cinque finali naturali e gli altri
limiti del punto di ripresa rimangono aperti.


## Test conclusivi

48test mirati passati. La suite completa ha concluso1.737test su1.737:
zero errori, cancellazioni o test saltati. Il prefisso completo e il lookahead
sono stati ripetuti sul runtime definitivo, dopo i suffissi monetari invisibili.
Log e rapporti sono conservati nel dossier.
