# Il registro B salvato a5D1D

30 ottobre 2026. È ricostruito il primo operando che bloccava la cuoca nel
percorso naturale, senza riempire il byte con il valore letto nella traccia.
Il motore resta JavaScript autonomo: nessun interprete CPU o replay viene
introdotto nella pagina.

## Ultimo scrittore naturale

Il probe segue76 comandi dall’avvio, seed 1, tutti i 24 attori, LOOK iniziale
gratuito, grafica originale disabilitata dopo il boot, input maiuscolo
iniettato e MORE immediato. Osserva PUSH/CALL ed EX(SP),HL, compresi gli
store che riscrivono lo stesso valore. Non registra transizioni di valore
non classificate. Osserva anche5D1E per distinguere i ruoli, ma il runtime
non introduce quel byte.

L’ultimo store a5D1D è C3B7, tick 962, attore2: Lestrade sta salendo sul cab.
Il prefisso qualificato hansom del nome del veicolo non entra sulla riga;
il renderer va a capo e pulisce la riga con spazi. C388 entra con frame 5D26,
carattere 32, descrittore5A20, colonna 35 e shift 7. C3B7 salva BC=0107:
il registroB occupa5D1D; il registroC occupa5D1C. Il valore diB viene
verificato indipendentemente, non dedotto dal7 della cella accanto.

La lettura pertinente avviene al tick 2918, mercoledì08:37, attore9: la cuoca.
È la prima lettura della seconda coppia di un’estrazione che ha scartato il
primo tentativo. L’originale legge prima5C1D/5C23, poi5D1D/5D23. Il modello
supera ora5D1D=1 ma si ferma sul secondo operando5D23 ancora non posseduto.
Non vengono copiati né80 da5D23 né il risultato finale dell’estrazione.

## Algoritmo del salvataggio

C388 conserva i registri del chiamante. C399 imposta poi B=8 per le otto
righe del glifo. C39C salva BC prima della mascheratura e degli shift.
Quando lo shift non è zero, C3B7 ripete il salvataggio dopo avere ripristinato
BC. C3D2 esegue DJNZ soltanto dopo questi salvataggi.

Alla scansione finale viene perciò salvato B=1; il successivo decremento a0
serve a uscire dal ciclo e non viene salvato nella stessa posizione.
Con shift0 resta l’ultimo store C39C; con shift diverso da0 resta C3B7.
La proiezione usa il risultato di questo ciclo locale del renderer, non una
costante assegnata globalmente a5D1D all’avvio o al comando WAIT.

## Una cella, sei ruoli

| Frame C388 | Significato fisico di5D1D |
| --- | --- |
|5D1E|A del chiamante: carattere fornito|
|5D20|B del chiamante: per esempio lunghezza rimanente della parola|
|5D22|D del descrittore di testo salvato|
|5D24|H dell’indirizzo video salvato|
|5D26|B del conteggio interno delle scansioni|
|5D28|A dell’ultima riga non allineata del font|
|5D2A/5D2C|Questi salvataggi non raggiungono la cella|

I valori dipendenti dal chiamante rimangono distinti. Il B del chiamante può
essere3 o7 nelle prove, mentre il B interno dell’ottava scansione è1.
Il byte del font può essere nonzero per q. Non è lecito pubblicare1 per
ogni carattere o per ogni profondità di stampa.

## Proprietà del valore e salvataggi

RandomDisplay.glyphResidue calcolava già i salvataggi locali: ora ne
pubblica anche5D1D nei contesti il cui chiamante è verificato. Conserva
le revoche quando un nuovo writer raggiunge il byte ma non ne conosciamo
l’argomento. Per esempio, un frame 5D20 senza conteggio noto non riceve1.

Il percorso GO TO già studiato non raggiunge questo salvataggio AF/BC;
ora conserva anche5D1D. La traccia naturale conferma che il suo ultimo
writer resta quello di Lestrade al tick 962. Output generici, scene senza
contratto ed errori revocano il valore invece di conservare un residuo
potenzialmente obsoleto.

SAVE/LOAD mantiene il byte quando noto. Un vecchio save che non lo contiene
resta sconosciuto: non lo ricava da5D1C, dal payload o dal seed.5D1E rimane
escluso. Gli altri byte già ricostruiti mantengono i propri contratti.

## Prove e confine successivo

- **1.728** chiamate controllate alla routine originale:8 frame,2 conteggi del
 chiamante,3 caratteri e tutte36 colonne.1296 casi raggiungono5D1D nei sei
 ruoli;432 verificano i due frame più superficiali che non lo raggiungono.
 Il confronto include tutti i nuovi byte pubblicati e gli altri salvataggi
 già presenti nel fixture. Sono compresi tutti gli8 shift.
- Proprietà indipendente, conto del chiamante sconosciuto, preservazione
 controllata, revoca, SAVE/LOAD e vecchi salvataggi senza fallback.
- Probe naturale sino a mercoledì08:50. Il modello confronta i valori posseduti
 ai checkpoint precedenti e la lettura effettiva di5D1D. La sua esecuzione
 si ferma però su5D23 alle08:37:08:50 non è un traguardo del modello.

Il certificato completo rimane365 checkpoint0–364 fino a mercoledì08:30:
6992 estrazioni e14966 letture confrontate, tutti gli attori, arena752 byte,
entità, fatti, bitmap esatte e futuro dopo LOAD. Non si aggiunge un checkpoint
solo perché è stato ricostruito il primo operando. Il confronto di ricerca
ora fallisce al checkpoint365 verso08:40 su5D23, nella stessa estrazione.
I cinque finali naturali ancora aperti rimangono aperti.

Rapporti: results/glyph-count-verification.json,
results/glyph-count/witness-prefix.json e results/glyph-count/natural-stores.json.
Riproduzione: node tools/verify-witness-prefix.mjs per il prefisso;
node tools/compare-witness-research.mjs per il limite ancora aperto.

## Atlante

Approfonditi119 istruzioni e179 byte, riassemblati e confrontati col payload:
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3. Aggiunta l’annotazione del
workspace5D1D, separata da5D1C e5D1E. Nessun nuovo byte grigio viene promosso:
sono precisazioni di codice già classificato, e lo stack è fuori dal payload
che inizia a5D80. Totali invariati:38466 documentati,468 parziali e2666
sconosciuti. La copertura statica resta distinta dall’equivalenza della partita.

Verifica conclusiva 5D1D: suite completa 1.104 test passati, 0 errori; 55 controlli mirati passati.
