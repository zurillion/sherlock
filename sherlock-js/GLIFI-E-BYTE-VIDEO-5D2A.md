# 5D2A: byte basso video salvato dal renderer

Il motore ricostruisce ora il byte di stack letto dalla cuoca verso le19:30
di mercoledì. Non installa53 dal riferimento: deriva il valore dalle
operazioni di stampa e dalla colonna del carattere, nei chiamanti verificati.

## Scrittura del renderer

All’ingresso C388, il carattere usa una posizione video nella riga di testo
inferiore. Per una colonna `c`, il pixel iniziale è `2 + 7*c` e l’indirizzo
è `0x5020 + floor((2 + 7*c)/8)`. C38B salva HL; C398 lo salva di nuovo
prima delle scansioni. Con SP d’ingresso5D32, il byte L viene scritto a5D2A.
Il successivo ciclo delle otto righe usa altri salvataggi: il byte basso
video non è lo shift C conservato a5D28, né il countdown B a5D29.

## La stessa cella ha altri ruoli

| Ingresso C388 | Valore salvato a5D2A |
| --- | --- |
| 5D2C | F del chiamante |
| 5D2E | C del chiamante, solo se il contratto BC è posseduto |
| 5D30 | E del descrittore testuale |
| 5D32 | L dell’indirizzo video |
| 5D34 | C dello shift nelle scansioni |
| 5D36 | F dell’ultima scansione, con o senza secondo byte |

La vera CALL in C374 scrive anche il ritorno C377. Se l’ingresso del glifo
ha SP5D2A, il byte basso77 resta nella cella. Questo caso è verificato con
le CALL reali archiviate; il return0008 delle ABI sintetiche non ne è una prova.

Le ABI confrontano tutte le36colonne, tre caratteri e due conteggi del
chiamante. Il nuovo frame5D36 ha216chiamate originali controllate; gli altri
ruoli e le CALL sono verificati riutilizzando i riferimenti originali con
hash SHA256. La nuova traccia naturale osserva invece gli store PUSH/CALL
ed EX(SP),HL a5D2A/5D2B, anche quando riscrivono lo stesso valore.
Osservare due byte non significa implementare automaticamente entrambi.

## Ultimo store e lettura naturale

La nuova traccia originale arriva al tick3571 senza transizioni non
classificate di2A/2B. La cuoca9 legge5D2A al tick3562, mercoledì19:21.
L’ultimo store è **C398, tick964, Holmes0, SP5D2C**, nel frame5D32:
HL5035, carattere116 («t»), shift2, descrittore iniziale5C0B.
È la lettera finale del prefisso «Parliament» nella stampa del nome della
destinazione. Il cursore è alla colonna24: `2+7*24=170`, quindi il byte
video è `0x5020+floor(170/8)=0x5035`. Il byte basso35 è53decimale.
Il modello applica questa formula a ogni colonna; non conserva il53 della
traccia come costante. Il sostantivo finale resta nel buffer e viene
scaricato dopo il ritorno del prefisso, con un altro chiamante.

La prova della provenienza distingue gli store che non cambiano valore
ed esige che non vi siano altre transizioni non classificate. Il confronto
completo delle estrazioni e del mondo usa il certificato separato sotto.

## Proprietà, scene e salvataggi

Il renderer pubblica2A soltanto nei suoi contratti di chiamante compresi.
Output non proiettati, scene ignote, errori e nomi locazione senza contratto
revocano la proprietà; una scrittura compresa la ristabilisce.
La revoca del BC del chiamante revoca anche il suo C salvato: non mantiene
un vecchio byte video quando quel ruolo viene sovrascritto.

Un vecchio LOAD senza2A resta sconosciuto anche se29 è noto. Il nuovo SAVE
conserva il valore corrente quando posseduto.5D25 e5D2B restano non proiettati.
Non vengono introdotti stack CPU, registri emulati o snapshot originali nel
motore giocabile: la proiezione parte dai caratteri e dai rispettivi chiamanti.

## Prefisso completo e nuovo limite

Il certificato positivo separato dal lookahead confronta **432checkpoint
0–431 fino a mercoledì19:40**, con **8.738draw e18.710read**. Sono inclusi
tutti i24posti attore, entità, fatti, programmi, arena752byte, bitmap,
paginazione e futuro dopo LOAD. Le8.740estrazioni totali comprendono due
draw del boot, esterni al conteggio dei comandi.

Il successivo ingresso sconosciuto è **A024 al checkpoint432 verso le19:50**.
Quel checkpoint annullato non è incluso nel certificato. I cinque finali
naturali, il limite cab5D0C e i controesempi PRINT/MORE, TAKE TO e riga
transitoria del giardiniere nel campionamento continuo restano aperti.

## Atlante

Approfonditi C388–C3E3, C363–C37C, A360–A418, A59F–A5CC,
A720–A770, A7BA–A7CF, D3E8–D447, A95B–A98F, CE10–CE17 e il
programma di testo682A–682F; aggiornata l’annotazione dello workspace5D2A.
324istruzioni/615byte sono riassellati contro il payload. Sono zone già
censite: zero nuovi byte grigi, copertura invariata38846documentati,
431parziali,2323sconosciuti su41600. La comprensione statica di una zona
non certifica il completamento del gameplay.

La verifica della provenienza naturale confronta tre checkpoint di comando
in cui il modello possiede il byte e conserva esplicitamente come sconosciuti
gli altri73checkpoint. La lettura casuale della cuoca coincide esattamente.
È stata verificata anche la conservazione del byte dopo interruzione eLOAD.
I193controlli mirati su renderer, frame adiacenti, atlante/hosting e
controesempi conservati sono passati. Gli hash dei riferimenti nuovi e
riutilizzati sono in `results/glyph-video-low-2a/provenance.json`.

Verifica conclusiva 5D2A: suite completa1.613test passati, zero errori.
193 controlli mirati distinti passati. La nuova prova naturale del writer
e della lettura e il certificato completo432checkpoint sono conclusi e salvati.
