# Arrivo con grafica: il descrittore del nome visibile

24 novembre 2026.

Superato **$5D22** nella variante con LOOK prima del primo HAIL CAB.
Il confronto coincide per **3.240 checkpoint**, fino a **mercoledì alle
18:54**: 92 checkpoint in più rispetto al traguardo precedente.
Il prossimo escluso è il checkpoint 3240, alle **18:55**, su **$5D23**.

## Il produttore naturale di $5D22

Il comando **N**, al tick **3411**, porta Holmes al **binario due di
Leatherhead, locazione 55**. Dopo lo scorrimento che precede la grafica,
la descrizione usa la finestra stretta accanto all’immagine. L’elenco
alla radice contiene un solo oggetto visibile, il treno:

> You can see a steam train.

D102/D113 gestisce l’arrivo completo. D526 visita gli oggetti della stanza;
D536 imposta A028 a zero e D539 chiama D3D9 per il nome. L’ingresso
D3E8 ha **SP=$5D42**. Il prefisso del nome passa dal glifo con frame
**$5D1C**, mentre lo spazio prima di train usa **$5D28**.

A887 ha già selezionato il sostantivo quando emette quello spazio:
DE vale **$58EB**, contesto 5 e offset $8EB, invece del puntatore al
buffer della parola steam. **PUSH DE a $C38A** salva E in frame−6,
quindi in **$5D22**. D occuperebbe il byte vicino, ma non riceve un
nuovo contratto dal modello.

La scrittura osservata avviene alla colonna 5 della finestra stretta,
con contatore 6. Il punto viene emesso con A9B7/SP=$5D48; il CR esterno
usa SP=$5D5C. Il nome finale train. viene scaricato a frame $5D48.
L’annuncio successivo Watson enters. conserva E. Watson legge il valore
235 ($EB) al tick **3448**, nell’attesa che termina alle **17:28**.

Il motore ricava il parametro con `5000 | (noun & 0FFF)` e ne salva il
byte basso nel glifo del chiamante ammesso. Non inserisce $EB nel
generatore casuale e non usa il transcript per decidere le risposte.

## Perimetro della ricostruzione

La nuova annotazione riguarda un arrivo completo ordinario, giocatore 0
alla radice, non remoto, in una locazione con immagine. Richiede un solo
oggetto comune elencato, un qualificatore nel record, nome grezzo
verificato e nessun contenuto successivo da presentare. Esclude persone
e formattazione del denaro.

La proprietà nel glifo richiede frame $5D28, spazio del nome alla radice,
grafica nativa, finestra stretta, colonna inferiore a 17 e margine prima
del MORE (`counter + 3 < 15`). Finestra larga, margine, altri chiamanti,
LOOK, descrizioni brevi e geometrie escluse mantengono i propri contratti.
Le soglie sono guardie conservative del modello, non regole aggiunte al
programma originale. I byte adiacenti non sono dedotti da E.

Il valore appartiene allo stato corrente e viene salvato in JSON. Un
vecchio salvataggio che non lo contiene lo mantiene sconosciuto, finché
un produttore effettivo non lo scrive. Una stampa che conserva un campo
non ne inventa il valore iniziale.

## Prove offline e partita naturale

La cattura originale riparte da un prompt verificato al checkpoint
**3111**: clock, locazione, bitmap, attributi, contatore e finestra
coincidono con la registrazione. Il comando N successivo è naturale:
nessun cambio di posizione, identità o programma degli attori.
La precedente traccia di $5D22 comprende **2.754 scritture**, anche
quelle che riscrivono lo stesso byte, senza transizioni non classificate.

* **216 nomi controllati:** D3E8/SP=$5D42, finestra larga o stretta,
  tutte le rispettive 36 o 18 colonne e contatori 0, 6, 11 e 14.
  Seguono punto e CR nei frame misurati. Buffer vuoto, flag espliciti,
  marker A5 in 22/23 e ritorno sintetico 0008. Nessun tick: non sono
  216 partite naturali. Il test confronta soltanto E quando il modello
  ne possiede il valore; gli altri casi restano sconosciuti.
* **108 glifi controllati:** sei descrittori DE e tutte le 18 colonne
  della finestra stretta, con frame $5D28. I byte bassi differenti da
  $EB verificano che il risultato derivi dal parametro. Nessun tick e
  nessuna concessione automatica del byte alto D.
* **Comando reale:** il test carica il salvataggio JavaScript precedente,
  esegue N, verifica l’arrivo e la conservazione dopo Watson, quindi
  serializza e ricarica il byte calcolato. Le catture originali restano
  strumenti offline, non dati di esecuzione del browser.

Il confronto lungo parte dall’avvio: seed 1, tutti i 24 attori, grafica
nativa, primo LOOK gratuito, input maiuscoli iniettati e MORE immediato,
nessun teletrasporto. Verifica **8.511 estrazioni e 18.068 letture**,
bitmap e attributi superiori a ogni estrazione, ingressi e risultati
casuali, clock, locazione, contatore, finestra, esiti e finale.
Non viene normalizzato per accettare differenze.

I sei punti Salva/Carica sono **1488, 2005, 2780, 2911, 3015 e 3112**.
L’ultimo contiene l’arrivo con immagine e il nuovo E; seguono **127
checkpoint** di futuro, con confronto anche delle risposte e dello
stato delle nuove sessioni. Le storie di vittoria con seed 0, 1 e 137
restano prove distinte di 3.219 checkpoint ciascuna. Questo avanzamento
non certifica un ulteriore finale né ogni possibile partita.

## Il prossimo limite cambia di nuovo significato

Al tick **3535**, il giardiniere, attore 8, legge **$5D23=0** durante
WAIT UNTIL 7:29PM; il checkpoint terminerebbe alle **18:55**.
L’ultimo scrittore è già tracciato: **C3B8 al tick 3504**, attore 0,
ultima h della parola english, frame **$5D2E**, finestra larga.

In quel frame il byte è **A dell’ottava scansione del font**, non D del
descrittore del treno. La traccia conta 6.144 scritture e nessuna
transizione non classificata. Rimangono da ricostruire il chiamante che
produce quel nome e la sua durata nel percorso. Il modello non lo
proietta ancora e non introduce uno zero di ripiego.

## Atlante

Approfonditi **$A887–A8B8**, **$C388–C39D**, **$D102–D11A**,
**$D3D5–D447** e **$D526–D559**, oltre al workspace dinamico $5D22–$5D23.
Il listato contiene **137 istruzioni e 264 byte**, riassemblati e
confrontati con il TAP. La copertura rimane 40.029 byte documentati,
305 parziali e 1.266 sconosciuti: nessun nuovo grigio classificato.

[Arrivo naturale e frame](results/narrow-arrival-descriptor/arrival-detail.json) ·
[216 nomi controllati](results/narrow-arrival-descriptor/name-abi.json) ·
[108 glifi](results/narrow-arrival-descriptor/glyph-abi.json) ·
[Listato commentato](results/narrow-arrival-descriptor/narrow-arrival-descriptor.asm) ·
[Prossimo produttore di 23](results/narrow-arrival-descriptor/next-stack23.json) ·
[Rapporto e test](results/narrow-arrival-descriptor/verification.json).


Verifica conclusiva: **56 test mirati** passati, oltre al confronto della
variante dall’avvio e ai tre percorsi completi fino alla vittoria con
seed 0, 1 e 137.
[Output dei test](results/narrow-arrival-descriptor/test-output.txt).
