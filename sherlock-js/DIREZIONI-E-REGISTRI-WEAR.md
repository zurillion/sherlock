# Il descrittore dei rifiuti di movimento e i registri di WEAR

20 novembre 2026.

La variante con un LOOK prima del primo HAIL CAB coincide per **2.780
checkpoint**, fino a **mercoledì alle 11:15**. Sono superati il descrittore
$A022 delle 08:50 e il byte di scansione $5D23 delle 09:58. Il prossimo
checkpoint, un NE che nell’originale termina alle 11:17, richiede un nuovo
scrittore di $5D1E. Non è incluso nel prefisso certificato.

## Perché la cuoca legge «southwest»

Al tick 2293 il giocatore tenta SW. Il movimento viene rifiutato e la
frase nel canale inferiore lascia **$0827**, riferimento alla parola
southwest, in **$A022–$A023**. La cuoca legge il byte basso $27 al tick
2930, nel minuto che termina alle 08:50. Il modello stampava già il
rifiuto corretto, ma non possedeva più il descrittore.

Il compositore **$A37D** legge il modello dell’azione. Emette prima il
modificatore con **$A39E** (go) e poi la parola principale con **$A3A2**
(southwest). Senza argomenti passa dal controllo **$A3E2–$A3EB** al
terminatore $A414. Non viene emessa un’ulteriore parola che sostituisca
il descrittore della direzione.

**$A880–$A886** legge il riferimento e ne maschera il nibble di contesto.
**$A887–$A88B** controlla l’abilitazione della stampa. Se il canale è
abilitato, **$A88C** scrive il descrittore anche per un offset zero.
**$A8AC–$A8B8** ricombina offset e contesto e lo scrive di nuovo a $A8B5.
È quest’ultimo store il produttore osservato della successiva lettura.

La ricostruzione seleziona il riferimento dal modello estratto dell’azione,
non da una tabella di risposte osservate. Il nuovo contratto riguarda il
normale rifiuto del giocatore di una delle dieci direzioni senza gruppi
nominali. Richieste eseguite dagli NPC e altri modelli non lo ereditano.
La proiezione del descrittore rispetta l’ordine dei messaggi; zero resta un
valore valido. Dati del modello mancanti non producono un valore di ripiego.

La prova naturale riparte dal prompt originale prima di WEAR, verificato
contro il checkpoint 2004 del corpus: clock, stanza, bitmap/attributi,
contatore MORE e modalità della finestra. Il file di ripresa è identificato
con SHA-256. Osserva anche gli store che riscrivono lo stesso valore e non
rileva cambiamenti del descrittore senza uno scrittore classificato.

La prova controllata comprende **90 comandi completi**: dieci direzioni,
abbreviazione/nome completo/GO, per ciascuna delle tre identità giocabili.
Il setup usa Portman Street 45, con la porta a sud chiusa, e conserva tutti
i 24 attori. Identità, posizione e budget dei fallimenti sono sovrascritti
esplicitamente: sono controlli dell’algoritmo, non 90 partite naturali.

## La scansione completa del qualificatore WEAR

Il byte letto in **$5D23** alle 09:58 è **B**, il contatore di scansione
dell’ultima s di mans, stampata da WEAR al tick 2286 con frame **$5D2C**.
L’ultimo store è **PUSH BC a $C3B7**, con BC=$0104. B vale 1 nell’ottava
scansione; C vale 4 per l’allineamento del glifo. Non è un valore iniziale.

Il renderer già calcolava questi registri. La proprietà del chiamante
WEAR ora comprende l’intero gruppo che la scansione scrive:

| RAM | Dato | Scrittore |
| --- | --- | --- |
| $5D20–$5D21 | F e A della scansione | $C3B8 |
| $5D22–$5D23 | C e B della scansione | $C39C / $C3B7 |
| $5D24–$5D25 | L e H dell’indirizzo video | $C398 |

Restano i vincoli misurati: normale annuncio WEAR del giocatore, nome grezzo
verificato, riga nuova larga, frase corta e margine prima del MORE. Verbo,
qualificatori e sostantivo hanno frame separati. Nessuna estensione ai byte
$5D26–$5D2B. I vecchi LOAD senza questi campi li mantengono sconosciuti fino
a una scrittura ricostruita; un rifiuto che li conserva non può ricrearli.

Le 24 geometrie WEAR ammesse del corpus di 1.080 casi sono confrontate
su tutti e sei i byte. Il confronto dei glifi usa caratteri, colonne e
conteggi diversi: include A non nullo e shift zero. Il conteggio B e
l’indirizzo HL sono calcolati, non recuperati da uno snapshot. Restano
separate le 168 prove complete di conservazione dei rifiuti qualificati.

## Verifica e atlante

Profilo: seed 1, tutti i 24 attori, grafica nativa dall’avvio, primo LOOK
gratuito, nessun teletrasporto. Il prefisso comprende **7.316 estrazioni**
e **15.510 letture**, confrontate una per una insieme a schermo superiore
e attributi al momento dell’estrazione, contatore MORE, modalità finestra,
clock, stanza, esito e finale. Il test Salva/Carica crea nuove sessioni JSON
ai checkpoint 1488 e 2005 e confronta risposte e stato completo del futuro:
**774 checkpoint dopo l’ultimo LOAD**. Questo perimetro non certifica ogni
possibile storia o tutto il motore.

Nuovi approfondimenti della mappa:

- **$A37D–$A3AA e $A3E2–$A3EC**: ordine delle parole e salto degli argomenti.
- **$A880–$A898 e $A8AC–$A8B8**: selezione, gate e due store del descrittore.
- **$C388–$C39D e $C3B7–$C3BA**: salvataggi del renderer, frame WEAR e registri indipendenti.
- **$A022–$A023 e workspace $5D20–$5D25**: provenienza dei dati mutabili.

Gli estratti comprendono **121 byte**, riassemblati e confrontati con il
payload TAP. Le classificazioni non cambiano: **40.029 byte documentati,
305 parziali e 1.266 sconosciuti** su 41.600. Si approfondiscono zone già
identificate, senza colorare altro grigio sulla sola base del disassemblato.

[Prova naturale A022](results/direction-rejection-reference/natural-writer.json) ·
[90 comandi originali](results/direction-rejection-reference/command-abi.json) ·
[Ultimo BC di WEAR](results/direction-rejection-reference/wear-count-writer.json) ·
[Disassemblato commentato](results/direction-rejection-reference/direction-and-wear.asm) ·
[Rapporto del confronto](results/victory-route/native-extra-look-verification.json).
