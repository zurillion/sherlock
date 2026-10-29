# Chiarimenti: offset fisico e ciclo di A01B

## Tre scritture distinte

A01B non è il puntatore del nodo pendente e non è un booleano.
È l’offset del referente nel nodo originale: 08 esadecimale per il primo,
12 esadecimale per il secondo (8 e 18 decimali). Il referente è seguito dai
due qualificatori. Il nodo trattenuto è collegato separatamente da 9FF0.

- A044 scrive zero all’avvio: è un’istruzione ricostruita, non il byte del
  payload installato come fallback.
- B5B6 scrive l’offset prima di trattenere il nodo e stampare la domanda.
- D793 scrive zero **dopo il ritorno dal parser principale**, anche se il
  parsing fallisce. Il parser legge ancora il vecchio offset mentre fonde
  la risposta a AD6C. Le citazioni non attraversano automaticamente D793.

Un errore lessicale precedente al parser conserva l’offset e la domanda.
Un errore sintattico che torna dal parser lo azzera. Un nuovo verbo sostituisce
il comando trattenuto. Una risposta nominale completa invece il vecchio nodo.
@ durante il chiarimento torna all’editor senza ripetere il comando e senza
il reset D793; una vera risposta vuota entra nel parser, azzera lo stato e
può porre di nuovo la stessa domanda. Anche SAVE può produrre la sequenza
0→08 prima e dopo il minuto pagato. PAUSE/PRINT/NOPRINT seguono i loro ritorni.
LOAD/QUIT restano gli adattatori dichiarati: non si simula un ritorno dal
servizio originale che non è avvenuto; la fine partita prevale sulla domanda.

Il valore è conservato nei salvataggi JSON. Un vecchio salvataggio senza il
campo rimane sconosciuto fino a una scrittura reale. Le analisi preventive e
canStreamWait non lo modificano. Le richieste eseguite dagli NPC non diventano
domande per l’utente e non sovrascrivono questo stato.

## Ruoli semantici e slot del nodo

B447 assegna gli offset 08/12 ai due ruoli secondo l’ordine dei complementi.
Non si deve usare semplicemente l’indice dell’argomento già riordinato dal
motore. La traduzione mantiene il nodo sorgente e la permutazione separati
dalla vista semantica; il chiarimento conserva e completa il nodo fisico.

Per esempio, con la lampada già in possesso:

```text
PUT ON YOUR ARMCHAIR
PUT WHAT ?
LAMP
You put the oil lamp on your armchair.
```

Il destinatario occupa il primo gruppo del nodo e l’oggetto richiesto il
secondo: A01B vale 12, anche se l’oggetto è il primo argomento dell’azione.
La risposta LAMP deve completare il secondo gruppo originale.

## Scelta dei candidati e comandi incompleti

Il numero dei candidati decide fra rifiuto, scelta automatica e domanda.
B244/B250 distingue zero, uno e più di uno; B5D3/B5E2 distingue WHAT da WHICH
in base alla presenza del nome nel ruolo da precisare.

Il preflight non coincide con la possibilità finale di eseguire l’azione.
La proprietà da parte di un altro personaggio è una restrizione morbida
nella classe 9: C7DF arriva a C79A, che la accetta con A00B=0 e la rifiuta in
esecuzione. Restano rigidi gli altri controlli di percezione, record singolo,
non-persona e capacità. DCA2 tratta separatamente il possesso già acquisito
dall’attore; DCA7 impedisce di prendere il proprio contenitore, non misura
il peso. Quest’ultimo è già controllato dalla classe.

Nella stanza iniziale TAKE trova la lampada 22 e il giornale 25 tenuto da
Watson. Chiede quindi TAKE WHAT?, benché il giornale verrà rifiutato se
scelto. Il modello ora lo conta nel preflight e rifiuta l’operazione al
momento corretto, usando il verbo originale GET/CARRY/TAKE. Un setup nativo
con soltanto la lampada disponibile verifica invece la scelta automatica:
non è stata introdotta una regola che chieda sempre il nome.

Sono anche ricostruiti OPEN, TAKE ed EXAMINE senza oggetto, le risposte
successive, il secondo referente unico implicito (GIVE LAMP TO sceglie
Watson) e HAIL senza nome del cab su una strada valida. Nessun candidato
produce il messaggio originale I SEE NOTHING THAT YOU CAN…, senza lasciare
una domanda inesistente. I rifiuti di GIVE/PAY con destinatario ambiguo
non vengono trasformati in chiarimenti: il percorso GIVE comprende anche
la ricerca nella descrizione e i suoi record temporanei.

## Prove e limiti

54 sequenze native, 156 input, 182 scritture del byte confrontate singolarmente,
compresi valori ripetuti: chiarimenti, errori, ALL/BUT, coordinazioni, citazioni,
@, risposte vuote, SAVE e altri controlli. LOAD conserva il seguito.

Altre 19 sequenze confrontano errori esatti, tutti gli attori, entità, fatti,
i 752 byte dell’arena, bitmap, ogni draw/read e il byte A01B a ogni estrazione:
63 input, 203 estrazioni, 406 letture. 15 sono naturali; quattro sono setup
controllati espliciti (tre con Lestrade rinominato/spostato per duplicare il
nome Watson, uno con la sola lampada disponibile). Nessuna modifica al mondo
viene usata nelle sequenze dichiarate naturali. I candidati del TAKE nativo
sono osservati e confrontati anche direttamente.

Protocollo: seed 1, tutti i 24 posti attore, LOOK iniziale gratuito, grafica
originale spenta dopo il boot, input maiuscolo e MORE immediato. Periferiche
SAVE/PAUSE/stampante: stesso adattatore dei precedenti corpus, senza cambi
al codice del gioco. I fixture sono soltanto prove offline.
Suite corrente: 874 test. Rapporto finale: `results/clarification-offset/checks.json`.

Il prefisso witness resta 349 checkpoint, 0–348, fino a **mercoledì 05:50**,
con mondo completo, ogni draw/read, arena, bitmap e futuro dopo LOAD.
A01B è superato; il confronto incontra **A021 allo stesso checkpoint 349**,
diretto a mercoledì 06:00. È un temporaneo dei controlli sugli argomenti:
ricostruirne scritture e persistenza, senza dedurlo dall’ultimo successo o
riempirlo con zero. Non è certificato un nuovo orario né un nuovo finale.
Rapporto: `results/clarification-offset-verification.json`, ripetibile con
`node tools/verify-witness-prefix.mjs`. Cinque varianti terminali restano aperte.

## Atlante

| Intervallo inclusivo | Contenuto |
| --- | --- |
| A01B | Offset del referente nel nodo pendente |
| A040–A047 | Reset all’avvio |
| AAC4–AAD0 | Ingresso del parser durante un chiarimento |
| AD6C–ADD3 | Fusione della risposta o sostituzione del comando |
| B244–B258 | Conteggio dei candidati e scelta univoca |
| B447–B467 | Associazione fra ruoli e offset 08/12 |
| B5B6–B5D2 | Scrittura dell’offset e conservazione del nodo |
| B5D3–B5FB | Dispatch WHICH/WHAT per i due ruoli |
| B5FC–B62E | Domande WHAT sul primo o secondo argomento |
| C792–C7A5 | Restrizione morbida nel preflight |
| C7BB–C7E3 | Verifica della classe 9 e possesso altrui |
| D78E–D7B1 | Reset al ritorno, prima della gestione dell’esito |
| D99E–D9B6 | @ con e senza domanda pendente |
| DCA2–DCC0 | Possesso già acquisito, contenimento e handler |

197 istruzioni/454 byte riassemblati e verificati contro il payload.
51 byte prima grigi (B5FC–B62E) sono documentati; A01B passa da parziale a
documentato. Gli altri sono approfondimenti. Restano 2.802 byte sconosciuti
e 472 parziali: la copertura del codice non equivale alla copertura del gameplay.
