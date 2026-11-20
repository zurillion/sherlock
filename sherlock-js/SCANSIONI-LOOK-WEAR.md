# Due salvataggi AF: spazio del LOOK e qualificatore di WEAR

Seguito: [direzioni e registri WEAR](DIREZIONI-E-REGISTRI-WEAR.md),
2.780 checkpoint fino a mercoledì11:15; prossimo5D1E duranteNE.


20 novembre 2026.

La variante con LOOK prima del primo HAIL CAB coincide con l’originale
per **2.664 checkpoint**, fino a **mercoledì alle 08:49**. Sono superati
$5D1A e $5D20, letti nella stessa estrazione del giardiniere alle 05:30,
e i successivi impieghi dei byte AF ricostruiti.

Il prossimo checkpoint escluso è alle **08:50**: la cuoca legge $A022,
il byte basso dell’ultimo descrittore del dizionario. Il significato del
campo è già noto; resta da ricostruire il chiamante che lo aggiorna in
questa variante. Il motore mantiene esplicito quel limite.

## Due scrittori, due contesti

La nuova osservazione riparte dall’accensione dell’originale: seed 1,
tutti i 24 attori, grafica nativa, primo LOOK gratuito, nessun teletrasporto
o modifica della partita. Osserva PUSH/CALL/RST, PUSH degli indici ed
EX (SP),HL, comprese le riscritture dello stesso valore. Non risultano
transizioni di valore non classificate nei due byte seguiti.

| Byte letto | Ultimo scrittore | Tick | Contesto del glifo | Dato conservato |
| --- | --- | ---: | --- | --- |
| $5D1A | $C39D | 1770 | LOOK, spazio fra daily e chronicle; frame $5D26, colonna 18, shift 0 | F dell’ottava scansione |
| $5D20 | $C3B8 | 2286 | WEAR, ultima s di mans; frame $5D2C, colonna 22, shift 4 | F dell’ottava scansione |

Il giardiniere legge entrambi al tick **2730**, nel minuto che termina
alle **05:30**. I due valori osservati sono zero, ma il modello li
calcola dal rispettivo percorso del renderer: non assegna uno zero di
ripiego al generatore casuale.

Ogni PUSH AF scrive anche il byte A adiacente: $5D1B e $5D21. A è
l’ultima riga del font prima della rotazione per disegnare; F deriva dal
percorso di scansione e shift. Le prove del glifo includono caratteri con
riga finale non nulla, come q. I byte di shift e conteggio BC del separatore,
$5D1C–$5D1D, mantengono un contratto distinto da quello AF.

## Ricostruzione nel formatter

Per il LOOK viene riconosciuto l’ultimo nome comune portato da un
personaggio. Il contratto AF richiede il normale chiamante LOOK, il frame verificato, una sequenza
grezza del dizionario corrispondente al nome, una finestra larga e spazio
prima del MORE. I nomi monetari e quelli senza provenienza grezza non
ereditano questo nuovo contratto. Il separatore calcola F e A attraverso
lo stesso algoritmo del renderer già usato per gli altri glifi.

Per WEAR si distinguono tre parti:

- Il verbo usa frame $5D2A e produce $5D1E–$5D1F, già ricostruiti.
- Articolo e qualificatori usano frame $5D2C e producono $5D20–$5D21.
- Il sostantivo finale usa un frame meno profondo; nel caso osservato
  disguise. si scarica a $5D46.

Il nuovo percorso WEAR conserva i byte inferiori che non raggiunge.
Resta limitato al normale annuncio del giocatore, su riga nuova larga,
con frase corta, nome grezzo verificato e margine prima del MORE.
Non viene attribuito a richieste isolate o ad altri chiamanti.

Il renderer della pagina continua a essere JavaScript autonomo. L’originale,
i suoi snapshot e i corpus servono esclusivamente alle verifiche offline.

## Rifiuti con qualificatori

La prima misura controllava soltanto $5D1E–$5D1F. La nuova prova marca
l’intero intervallo **$5D1A–$5D25**. Tutti i marker restano intatti nei
**168 comandi**: tre identità giocabili, sette forme verbali e otto gruppi
nominali assenti, con zero, uno o due qualificatori. È incluso
EXAMINE LARGE STREAM, usato dai vecchi test di esclusione.

Gli ingressi controllati mantengono tutti gli attori; identità attiva,
budget dei fallimenti e marker A5 sono impostati esplicitamente. Non
sono dichiarati percorsi naturali. Il probe non osserva alcun writer
PUSH/CALL/EX (SP),HL di $5D20 durante questi rifiuti.

La conservazione si applica a OPEN, CLOSE, TAKE/GET/CARRY ed
EXAMINE/CLOSELY EXAMINE con un solo gruppo assente, al massimo due
qualificatori, giocatore alla radice, visibilità e stanza senza testo
descrittivo. $B70F ritorna prima del decoder quando la descrizione è zero.

Questa estensione **si ferma a $5D25**. La proprietà di $5D26–$5D2B e
il contratto della pulizia del canale inferiore restano quelli separati
già verificati per il semplice EXAMINE. Prosa, ordini NPC, citazioni,
ALL e altre strutture non ricevono la nuova conservazione.

## Confronto e salvataggi

Il prefisso verifica **6.917 estrazioni e 14.648 letture**, comprese bitmap
e attributi superiori al momento di ogni estrazione, contatore MORE,
modalità della finestra, orologio, stanza, stato del comando e finale.
Non certifica tutti gli input o il resto della storia.

Il test riparte dall’accensione, salva e carica JSON in sessioni nuove
ai checkpoint 1488 e 2005. Dopo l’ultimo, subito dopo WEAR, confronta
**658 checkpoint di futuro**, incluse risposte e stato completo delle
due sessioni. I vecchi salvataggi privi dei byte restano privi dei byte:
una stampa che li conserva non può ricrearli.

Il confronto mantiene anche le vittorie già certificate con seed 1 e
137. Le nuove prove non sostituiscono il corpus della variante con una
sequenza di risposte registrate.

## Verifica generale precedente

La pubblicazione del commit e3d58ae si era fermata con 1.950 test riusciti
su 1.952. I due fallimenti imponevano la revoca di $5D1E e $5D1F dopo
EXAMINE LARGE STREAM. Le nuove prove originali mostrano la conservazione
nel contesto delimitato: sono aggiornate queste aspettative e quelle
analoghe dei byte fino a $5D25. I test continuano a richiedere la revoca
fuori contesto e a distinguere $5D26 e i byte successivi.

[Esecuzione precedente](https://github.com/zurillion/sherlock/actions/runs/44705093422).

## Mappa aggiornata

Approfonditi **$A3A2–$A3E1**, **$A9DF–$AA0F**, **$B6FD–$B70F**,
**$C388–$C3E3** e **$D3D5–$D447**. Le annotazioni precedenti sono
conservate; ai PUSH AF e al formatter dei nomi si aggiungono i nuovi
contratti. Il workspace opzionale espone i due ruoli distinti.

Il nuovo estratto contiene **188 istruzioni e 339 byte**, verificati
contro il payload e riassemblati. Nessun byte prima grigio cambia classe:
restano **40.029 documentati, 305 parziali e 1.266 sconosciuti**.

[Rapporto della storia](results/victory-route/native-extra-look-verification.json) ·
[Scrittori originali dall’avvio](results/extra-look-scan-af/natural-writers.json) ·
[Rifiuti controllati](results/extra-look-scan-af/rejection-abi.json) ·
[Listato commentato](results/extra-look-scan-af/look-wear-af.asm).

Per ripetere i confronti da sherlock-js:

~~~sh
node --test test/extra-look-scan-af.test.mjs
node --test --test-name-pattern='An extra LOOK' test/native-picture-window.test.mjs
python3 tools/probe-extra-look-scan-af.py
python3 tools/probe-extra-look-qualified-wide-abi.py
python3 tools/build-extra-look-scan-af-listing.py
python3 tools/build-memory-map.py
~~~

Il primo probe esegue l’originale dall’avvio e può richiedere diversi
minuti; accetta anche un checkpoint di ricerca opzionale dopo il LOOK,
verificandolo contro il corpus. La prova archiviata qui parte dall’avvio.
