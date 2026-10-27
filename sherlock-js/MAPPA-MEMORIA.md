# Atlante grafico della memoria

Aprire `http://127.0.0.1:8768/src/memory.html`, oppure il collegamento
**Mappa della memoria** nell’intestazione del gioco. Si apre una scheda
separata; non modifica la partita e non richiede riavviare il server.

## Cosa mostra

- Payload originale del nastro: **5D80–FFFF**, 41.600 byte.
- Buffer e stack opzionali da **5B00**. Non vengono inventati contenuti RAM
  per queste aree dinamiche. ROM e bitmap/attributi video sono sempre esclusi.
- Colori diversi per Z80, programmi DOMAIN, strutture dati, lessico/testi e
  istruzioni grafiche. Grigio per intervalli senza una fonte selezionata;
  tratteggio per quelli parziali.
- Al clic, il pannello sotto la mappa mostra listato, commenti, formato dei
  campi, byte originali e fonti con checksum. Gli indirizzi a quattro cifre
  nei listati e commenti sono navigabili. Si può scaricare la sezione.
- Ricerca per titolo o indirizzo (`$A040`, `0xA040`, `A040`), filtri, quattro
  livelli di dettaglio e navigazione con frecce/Invio nella mappa.

## Significato della copertura

Le percentuali riguardano **byte classificati**, non funzionalità completate.
“Documentato” indica un ruolo/formato sostenuto da una fonte, non conoscenza
perfetta di ogni ramo o equivalenza del motore. I dati decodificati non sono
conteggiati come codice Z80 compreso. Anche un programma DOMAIN è dato
interpretato, non assembler della CPU.

Il generatore legge i dossier e i cataloghi esistenti, riassembla le istruzioni e confronta ogni byte
riportato dai listati con il payload e costruisce una partizione unica.
Intervalli tipizzati più specifici prevalgono su quelli generali: nessun byte
viene contato due volte. Le righe di contesto possono iniziare prima del
confine selezionato; conservano il proprio indirizzo originale.
Il vasto `random-input-code.asm` **non è usato come prova di comprensione**.
Gli spazi non classificati mostrano soltanto DEFB, mai un disassemblato Z80
ipotizzato. I commenti sintattici aggiunti dall’interfaccia sono attenuati e
separati dalle annotazioni originali.

Alcune etichette `unimplemented.*` del catalogo sono storiche e non indicano
necessariamente un corpo oggi mancante: nell’atlante sono rese come indirizzi
di regola, con questa precisazione. Lo stato del portage resta documentato
nei rapporti del gameplay, separatamente dalla mappa.

## Rigenerazione e controlli

Dalla cartella `sherlock-js`:

```sh
python3 tools/build-memory-map.py
node --test test/memory-map.test.mjs test/architecture.test.mjs
```

Output: `src/memory-map-data.json` e `results/memory-map-verification.json`.
L’asset è caricato soltanto dall’atlante; il gioco non lo importa. Non è
eseguita nessuna istruzione Z80 durante costruzione o consultazione.

Il punto di ripresa del lavoro principale è conservato in
[RIPRESA-GAMEPLAY.md](RIPRESA-GAMEPLAY.md). Il confronto fallente del ramo
con due affermazioni AND rimane aperto: questa digressione non lo corregge
né lo considera verificato.
