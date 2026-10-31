# A026: maiuscola pendente e cinque writer distinti

Il nuovo campo `world.display.capitalizationFlag` proietta il byteA026 per il
generatore casuale condiviso. Il valore iniziale del payload è1. Quattro avvii
originali con seed1,2,77,255 restituiscono1 al primo prompt. Il campo non viene
ricavato dalla grafia del testo finale, dal flag degli spaziA025 o dal cursore.

## Normalizzazione differita

Il bufferA9B7 accoda la parola; AA14 normalizza i caratteri quando un separatore
la scarica. Accodare una lettera o un punto non esegue ancora il relativo writer.

- **AA4C** scrive1 per punto o virgoletta già normalizzati.
- **AA66** scrive0 per la lettera che richiede la maiuscola o è forzata daA851.
  Nell’altro ramo il flag era già0: il risultato dopo ogni lettera ASCII è
  dunque0, indipendentemente daA851. Questo consente di ricostruireA026 senza
  inventare il valore casuale diA851, che resta un contratto separato.
- **A8A9** scrive1 per una parola del dizionario in contesto70, dopo lo spazio
  iniziale che scarica la precedente parola. Riferimento nullo e output
  invisibile ritornano prima dello store.
- **A82C** esegue una scrittura indiretta: `A026 |= A7EA` dopo l’emissione del
  nome. Si esegue anche se il disegno era soppresso. L’OR conserva gli altri
  bit: per esempio255 resta255. Un OR1 non basta a conoscere un vecchioSAVE
  senza campo.
- **A464** scrive0 dopo il ramo monetario con D-punto o scellini esatti e
  trattino. Non viene eseguito per sterline intere o scellini con resto.

Un CR da solo conservaA026. Anche wrap video, cambio finestra, input nel canale
inferiore e backspace sono distinti dai cinque writer. Il punto ancora nel
buffer può ristabilire1 solo dopo un successivo separatore, anche se A464 ha
appena scritto0.

## Nomi e importi

A7D0 ricava il latchA7EA dal bit proprio del sostantivo; YOU/09EE è l’eccezione
che mantiene0. D3F9 azzera il latch per entità senza bit persona. A815 propaga
il bit dopo ogni qualificatore e sostantivo effettivamente emesso, senza farlo
per un offset nullo. D405 usa la tuple della locazione senza il controllo
persona diD3E8.

I letterali invisibili attraversano ancora il normalizzatore, come già
ricostruito perA025. Le parole del dizionario sono soppresse prima; la
propagazione del nome avviene invece dopo e resta attiva. Questa differenza è
confrontata a ogni minuto e ogni estrazione della nuova traccia originale.

A419 riceve la **word monetaria codificata**, con un bit di metadati nel byte
basso: le ABI usano `encodeMoney(pence)`, non il numero grezzo dei penny.
Il writer monetario è collegato a PAY, COUNT, richieste del cabbie e pagamenti
NPC. Gli eventi monetari seguono i caratteri del numero e precedono il resto
della frase; non viene aggiunto un reset generico alla fine del messaggio.

## SAVE e proprietà

La classificazione dei caratteri del buffer condiviso conserva se ciascun
carattere è una lettera, un punto/virgoletta o altro. Non inventa il valore
fisico di byte che restano sconosciuti nella proiezione del workspace.
Serve anche per sapere quali caratteri sono sopravvissuti a un backspace
prima di un’emissione invisibile.

SAVE/LOAD conserva flag e classi. Un vecchio salvataggio senzaA026 rimane
sconosciuto finché un writer dimostrato lo stabilisce. Le classi mancanti
possono essere ricavate solo da byte realmente noti; non si riempiono con
lettere o zeri presunti. La validazione rifiuta dati fuori dal contratto.

Questa modifica ricostruisce il residuoA026; non afferma una nuova equivalenza
globale di ogni percorso di impaginazione e maiuscole. Le bitmap complete
sono confrontate nelle storie naturali dichiarate; le ABI del nuovo campo
confrontano il flag, non tutti i pixel di ogni setup controllato. Il formatter
testuale esistente mantiene i suoi contratti separati.

## Prove

- 984 chiamate originaliA9B7/AA14/C1E1: visibilità0/1, forza0/1, flag0/1/255,
  colonne1/36, delimitatori, confini ASCII, parole lunghe e backspace.
- 32 chiamateA815 verificano l’OR, i bit alti e l’offset nullo.
- 144 chiamateA419 verificano tutti i rami di sterline/scellini/pence con
  flag iniziali0,1,254,255.
- 32 chiamateA887 distinguono contesti50/70, offset0/Watson e visibilità.
- Nove storie brevi naturali confrontano stato completo, flag a ogni draw,
  ogni estrazione/lettura e futuro dopoLOAD.
- Una nuova acquisizione originale continua copre3.752checkpoint fino a
  giovedì00:40:9.255draw/19.772read, flag a ogni minuto e draw, nessuna
  transizione non classificata. Tutti e cinque i writer sono stati osservati.

Watson3 legge1 al tick3880 (giovedì00:39). L’ultimo writer è AA4C al3878,
attore36 (treno): punteggiatura normalizzata. Il valore viene ricostruito dal
flusso di output, non copiato dal riferimento.

Il certificato positivo completo è separato e usa il riferimento major-witness
originale già archiviato:24 posti attore, entità, fatti, programmi, arena752,
bitmap, ogni draw/read e futuro dopoLOAD. Il primo checkpoint fallito rimane
escluso. I risultati definitivi sono in `results/output-capitalization-verification.json`.

## Atlante

249 istruzioni e477 byte riassemblati contro il payload: A026,A7D0–A7E9,
A7EA,A815–A82E,A887–A8AB,A9B7–AA70,A419–A475,D3E8–D447,A851–A85B.
A026 passa da parziale a documentato; A7EA è un nuovo byte dati prima grigio.
Copertura:38.850 documentati,428 parziali,2.322 sconosciuti su41.600.

```sh
python3 tools/probe-output-capitalization.py
python3 tools/probe-output-capitalization.py --witness
python3 tools/probe-output-capitalization-abi.py
python3 tools/probe-output-capitalization-dictionary.py
node --test test/output-capitalization.test.mjs test/output-spacing.test.mjs
node tools/verify-output-capitalization-continuous.mjs
node tools/verify-output-capitalization-prefix.mjs
node tools/verify-output-capitalization-lookahead.mjs
python3 tools/build-output-capitalization-listing.py
python3 tools/build-memory-map.py
```

Gli oracoli originali sono solo strumenti offline; il motore giocabile non
esegue Z80 né importa valori da tracce registrate.


## Prefisso completo e prossimo limite

Certificati498checkpoint0–497 sino a giovedì06:20:9.785draw/20.878read,
tutti24i posti attore, entità/fatti/programmi, arena752, bitmap e futuroLOAD.
Le9.787draw runtime comprendono le due del boot. Il checkpoint498 verso
giovedì06:30 è escluso: cuoca9/draw1 leggeCB28, originale131. Ricostruire
writer e proprietà del risultato, senza installare83esadecimale catturato.
Il profilo è seed1/freeLOOK/grafica nativa spenta/input maiuscolo iniettato/
MORE immediato. Cinque finali naturali e gli altri limiti del punto di ripresa
rimangono aperti.


## Test conclusivi

98test mirati passati:50nuovi e48di regressione perA025. Suite completa:
1.093test applicativi passati nella prima invocazione;40file non avviati
per la libreria mancante del vecchioNode Homebrew. Rieseguiti con ilNode
aggiornato già installato:694test su694passati. Sono1.787test distinti
verificati senza errori applicativi residui; non una seconda esecuzione
intera1.787/0. Nessun test applicativo è saltato o cancellato. I rapporti
conservano log completi e ambiti distinti delle prove.
