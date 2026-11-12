# Offset del glifo in $5D22 e $5D28

12 novembre 2026. Il lavoro prosegue dal passaggio documentato in
[DESCRITTORE-ALTO-E-FONT-5D21-5D27.md](DESCRITTORE-ALTO-E-FONT-5D21-5D27.md).

La cuoca, attore 9, legge `$5D22` e `$5D28` nella stessa estrazione al
tick 3377, mercoledì 16:16. I due byte hanno origine nel renderer.

| Indirizzo | Scrittura nel renderer | Ruolo |
|---|---|---|
| `$5D22` | `$C389`, `PUSH BC`, frame del glifo `$5D26` | C del chiamante mentre viene emessa la `n` di `plain`, colonna 21 |
| `$5D28` | `$C39C` e `$C3B7`, `PUSH BC`, frame del glifo `$5D32` | C della scansione durante lo spazio successivo, colonna 22 |

Il renderer calcola la coordinata orizzontale come `2 + 7 * colonna` e
usa i suoi tre bit bassi per posizionare il glifo dentro il byte video.
Quindi le colonne 21 e 22 producono rispettivamente 5 e 4. `$C39C`
salva C prima delle rotazioni. Con offset diverso da zero `$C3B7` salva
lo stesso C per la seconda parte del glifo. Il ramo con offset zero
conserva il valore scritto da `$C39C`.

Entrambe le ultime scritture sono di Holmes al tick 1653, martedì
11:32. La traccia estesa fino alla lettura delle 16:16 registra
3960 scritture da `$5D20` a `$5D29`, comprese quelle che riscrivono lo
stesso valore. I 3020 eventi sui primi otto indirizzi coincidono con
la traccia precedente. I due indirizzi aggiunti contano 470 scritture
ciascuno. Ogni transizione osservata ha un'istruzione associata.

## Motore JavaScript

Il prefisso del passaggio durante il movimento ordinario abilita il
campo C in `$5D22`. Solo lo spazio separatore verificato abilita il
campo C in `$5D28`. I valori seguono la geometria effettiva dei glifi
e sono conservati da SAVE e LOAD quando noti. Se un vecchio salvataggio
omette un campo, una scrittura modellata deve stabilirne il valore.

La parte finale di un nome, un nuovo nome e lo scorrimento possono
raggiungere profondità diverse. Il modello scarta i valori quando lo
stack del percorso successivo resta ignoto. Le notazioni del renderer
identificano separatamente C del chiamante, B del chiamante, AF della
scansione, C della scansione e B della scansione.

## Controlli con l’originale

Le 1296 prove già acquisite sui sei frame di `$5D22` includono tutti
gli otto valori di C nel frame del qualificatore. Per il passaggio
sono state acquisite di nuovo 720 geometrie, estendendo l'osservazione
fino a `$5D29`. Il modello stabilisce 290 valori per ciascuno dei due
byte e tutti coincidono. I casi LOOK usano un frame diverso.

Tra i 1512 controlli di arrivo, 720 riguardano un soggetto con nome
proprio senza qualificatori attivi. Tutti preservano `$5D22`. In 110
casi lo scorrimento riscrive `$5D28`. Lo stack scende a `$5D28` in 90
di questi casi e a `$5D26` negli altri 20. I 300 controlli su riga fresca preservano entrambi.
Per `$5D28` il motore richiede inoltre buffer vuoto, spazio normalizzato,
nome che entra nella riga e `counter + 2 < 15`, così la conservazione
resta nell'area già verificata prima del MORE. I 129 rifiuti semplici
eleggibili su 138 preservano entrambi lungo la pipeline originale.

Le prove controllate partono da frame raggiunti nell'originale e
variano esplicitamente marker, geometria o soggetto. La verifica della
partita usa invece comandi ordinari e checkpoint originali acquisiti
separatamente.

## Confronto della partita

Il riferimento originale contiene 562 checkpoint fino a mercoledì 23:00.
I 521 del riferimento precedente coincidono esattamente. Il motore è
verificato su **530 checkpoint, fino a mercoledì 17:40**, con 8456
estrazioni e 18036 letture confrontate. La verifica include i 24 attori,
lo stato di gioco, i 752 byte dell'arena, le bitmap e la prosecuzione
dopo LOAD anche durante l'attesa a ogni minuto.

Il modello incontra **`$5D29` alle 17:48**, tick 3469. Nel checkpoint
originale successivo, indice 530 alle 17:50, il giardiniere (attore 8)
legge 1. La traccia delle scritture arriva alle 16:16. Il valore letto
alle 17:48 richiede di seguirne le scritture fino a quel minuto.

Il finale `$6A33` è stato verificato nuovamente su 521 checkpoint, fino
a giovedì 10:00, includendo la pausa e il blocco terminale. Il finale
naturale `$6ABD` resta aperto. Questa sequenza conserva la prova Brown
mancante e i viaggi falliti del riferimento precedente.

I 1899 test esistenti e i cinque nuovi test sono passati in due
esecuzioni sullo stesso motore. Il [report di verifica](results/passage-caller-c-22-verification.json)
riunisce risultati, hash e provenienza.

## Atlante

Il listing conserva 395 istruzioni e 715 byte riassemblati e verificati
sul payload. I commenti nuovi riguardano soprattutto queste zone.

- `$C388–$C3E3` per il salvataggio di C del chiamante e C della scansione.
- `$C316–$C387` per le scritture durante lo scorrimento.
- `$D60B–$D670` per i frame del qualificatore e del separatore.
- `$CBC2–$CC0A` per gli arrivi e `$C1FD–$C23F` per i rifiuti.
- `$5D22` e `$5D28` nel workspace per i ruoli distinti secondo il frame.

Il dossier include anche i relativi intervalli dei chiamanti
`$C2BA–$C305`, `$A815–$A82E`, `$A887–$A8B8` e `$D3D5–$D447`.
La classificazione resta a 39364 byte documentati, 428 parziali e
1808 ignoti su 41600.

Gli artefatti sono in `results/passage-caller-c-22/`. Per rigenerare le
ABI si usano i quattro strumenti del passaggio precedente con
`--through-5d29`. Il listing si rigenera con
`tools/build-passage-descriptor-high-21-listing.py --caller-c`.
