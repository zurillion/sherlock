# A021: residuo persistente dei controlli sugli argomenti

A021 non è il risultato globale dell’azione e non viene azzerato a ogni
comando o turno. Nel codice esaminato ci sono due scritture dirette:
C655 scrive 0, C6BA scrive 1. Molti altri percorsi conservano il vecchio
valore. Non c’è un consumatore esplicito che lo legga per decidere il
successo: è però memoria che il generatore casuale può leggere e mescolare.
Perciò un risultato di gioco apparentemente corretto non basta a conservarne
la futura sequenza casuale.

## Scritture e ordine dei controlli

C9BF verifica prima la luce, poi il primo argomento (C628), il secondo
(C6BE), infine l’eventuale predicato. Un rifiuto interrompe i controlli
successivi. Le classi effettive appartengono all’intestazione della regola,
non necessariamente al modello nominale del verbo.

| Percorso | Effetto su A021 |
| --- | --- |
| Classe 0, argomento accettato, successo o predicato falso | Conserva |
| Rifiuto per buio prima degli argomenti | Conserva |
| Rifiuto di classe locazione/letterale, in entrambi i ruoli | Scrive 0 via C655 |
| Rifiuto di classe entità del primo ruolo | Scrive 0 via C68F/C655 |
| Rifiuto di classe entità del secondo ruolo | Conserva, ritorno diretto C726 |
| Maschere respinte durante la verifica preliminare A00B=0 | Restrizione morbida; conserva |
| Maschere respinte durante l’esecuzione A00B=1 | Scrive 1 via C6BA, anche per il secondo ruolo |
| Nuovo tick, nuovo comando, reset del costo temporaneo | Conserva |

Le classi 1–4 controllano locazioni, bit7 e/o adiacenza; 5/6 distinguono
orario e valuta mediante il bit7 del byte basso del letterale. Il primo
letterale è A02F/A030, il secondo A031/A032. Nessuna intestazione attuale
estratta usa 5/6 nel secondo ruolo: l’ABI controllato verifica comunque il
ramo, mentre il runtime rifiuta un eventuale letterale secondo sconosciuto
anziché inventarne il tag.

Le classi 7–15 controllano entità: percezione, trasportabilità, possesso,
numero di occorrenze e bit persona. Per la classe 9 restano distinti i
controlli rigidi e il possesso da parte di una persona, rinviabile alla fase
esecutiva. I due test di maschera sono ordinati: tutti presenti, almeno uno,
nessuno, non tutti. Una maschera zero nel modo «non tutti» fallisce.

Le ricerche enumerano anche candidati rifiutati: ignorarli eliminerebbe
scritture reali di zero. Le intestazioni con predicato hanno due byte in
più prima dei dati delle maschere. Le intestazioni vengono estratte come
dati tipizzati; il motore non decodifica istruzioni e non esegue lo Z80.

## Avvio, persistenza e integrazione

Il dato iniziale caricato è 0. La traccia completa dall’ingresso del programma
al primo prompt, con grafica accesa e seed 0, 1, 17 e 255, non attraversa
nessuna delle due scritture e non cambia il valore. Il modello usa questo
dato soltanto nell’avvio nuovo; non lo installa nei vecchi salvataggi.

Il JSON conserva `world.npcs.argumentCheck`. Se il campo manca, A021 rimane
sconosciuto fino a una scrittura reale; un controllo riuscito non lo rende
noto. Questo contratto riguarda il salvataggio completo del modello, non
una dichiarazione che il nastro originale salvasse tutti i temporanei.

`src/argument-checks.mjs` traduce i controlli funzionalmente. Le regole NPC
lo usano sia durante la ricerca sia nella validazione esecutiva; le azioni
del giocatore lo chiamano prima delle mutazioni del corpo, con entrambi gli
argomenti quando necessari. I rifiuti ordinari conservano il proprio handler,
compreso il messaggio della cassaforte già aperta.

Sono stati corretti anche due dettagli emersi dalle prove: una ricerca OPEN
senza una regola applicabile passa dalla ricerca descrittiva e conserva i
suoi residui nell’arena; WAIT UNTIL con una valuta, per esempio `6D`, registra
il letterale, scrive zero e produce `DON'T BE SILLY.`.

Esempi naturali verificati:

- `EXAMINE WATSON` scrive 1; XYZZY, un chiarimento OPEN e I possono conservarlo.
- Tentare GET OUT dal cab in corsa scrive 1; una successiva ricerca NPC può
  riportare il byte a zero.
- `GET DAILY CHRONICLE` può scrivere zero attraverso il rifiuto di classe 9.
- `PUT LAMP IN WATSON` verifica il secondo argomento e scrive 1 sul suo rifiuto.
- Aprire o chiudere nuovamente una porta produce il rifiuto originale e il
  residuo delle relative maschere, senza un reset generale al comando seguente.

## Verifiche e limite della certificazione

- 692 casi ABI controllati: entrambi i ruoli, tutte le 16 classi, due fasi,
  tutti i 16 accoppiamenti dei modi di maschera e maschere zero/nonzero.
  Si confrontano accettazione, valore finale e ogni scrittura, con sentinella
  iniziale 73 per distinguere conservazione e scrittura. Non sono partite naturali.
- 10 sequenze naturali, 53 input e 63 checkpoint: 218 scritture effettive,
  203 estrazioni e 406 letture casuali. Tutti i 24 posti attore, entità,
  fatti, tutti i 752 byte dell’arena, bitmap esatte e futuro dopo LOAD.
  A021 è confrontato anche a ogni ingresso nel generatore.
- La storia witness conserva il protocollo già dichiarato: seed 1, tutti
  gli attori, LOOK iniziale gratuito, grafica originale disattivata dopo
  l’avvio, input maiuscoli iniettati e MORE immediato. Il prefisso verificato
  è ora 0–355: 356 checkpoint sino a mercoledì 07:00, con 6.760 estrazioni
  e 14.470 letture confrontate. Il totale dello stato include le due
  estrazioni iniziali già verificate separatamente.
- La ricerca completa si ferma al checkpoint 356, verso mercoledì 07:10,
  sul byte di stack ancora sconosciuto 5D1C. Il finale 6A33 della traccia
  nativa completa non è ancora certificato dal modello.

I rapporti sono in `results/argument-check/` e
`results/argument-check-verification.json`. Suite completa: 889 test passati; il risultato è registrato in `checks.json`.

## Atlante aggiornato

Disassemblato tematico: 414 istruzioni e 909 byte, confrontati col payload
e riassemblati. Si aggiungono 32 byte prima grigi C571–C590 e il byte A021
prima parziale; gli altri intervalli sono approfondimenti già classificati.

| Intervallo incluso | Contenuto |
| --- | --- |
| A021 | Dato persistente e proprietà nei salvataggi |
| C4D1–C582 | Azioni, ricerca dei referenti, classi e passaggio alla fase esecutiva |
| C583–C627 | Regole interne e argomenti mancanti |
| C628–C6BD | Primo argomento e scritture 0/1 |
| C6BE–C74D | Secondo argomento e asimmetria dei rifiuti |
| C74E–C7A5 | Due test di maschera e restrizioni morbide |
| C7A6–C820 | Classi delle entità |
| C9BF–C9FA | Ordine luce/argomenti/predicato |

La copertura documentale è 38.359 byte, con 471 parziali e 2.770 sconosciuti
sui 41.600 del payload. La copertura della mappa non prova equivalenza di
ogni percorso di gioco.
