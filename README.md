# Sherlock · ZX Spectrum

Reverse engineering di **Sherlock** (Melbourne House) e ricostruzione autonoma
in JavaScript. Il gioco originale è usato come riferimento offline; la versione
web esegue la logica ricostruita nel browser.

- [Gioca su GitHub Pages](https://zurillion.github.io/sherlock/)
- [Esplora la mappa della memoria](https://zurillion.github.io/sherlock/src/memory.html)
- [Stato e lavoro ancora da fare](sherlock-js/RIPRESA-GAMEPLAY.md)

La ricostruzione è ancora parziale. L’ultimo prefisso naturale certificato
comprende 415 checkpoint fino a mercoledì 16:50, con tutti i 24 posti attore,
estrazioni casuali, stato e output confrontati con l’originale. La successiva dipendenza C128 è stata ricostruita
con prove native mirate; il prossimo limite effettivo è CB28. Vedere
`sherlock-js/FINESTRA-DEL-TESTO-C128.md`. La documentazione distingue i test controllati dalla
certificazione di una partita completa e conserva i limiti ancora aperti.

## Contenuto

| Percorso | Contenuto |
| --- | --- |
| `sherlock-js/` | Gioco nel browser, documentazione, test e prove differenziali |
| `sherlock-analisi/` | Decoder, strumenti Python, disassemblati e analisi |
| `Foggy London/` | Documentazione e sorgenti del tool originale di ispezione |
| `skoolkit-10.1/` | Distribuzione degli strumenti usati per l’analisi offline |
| TAP, TZX e manuale | Materiali originali di riferimento |

I materiali originali e gli strumenti di terzi conservano i rispettivi diritti
e licenze; la copia di SkoolKit include il proprio file `COPYING`.

## Avvio locale

Serve Node.js 20 o successivo; GitHub Actions verifica la versione 24.

```sh
cd sherlock-js
npm start -- --port 8768
```

Aprire `http://127.0.0.1:8768/`. Il selettore del motore originale richiede
anche il relativo server locale sulla porta 8766; su GitHub Pages è disponibile
solo la ricostruzione JavaScript. Salvataggi e cronologia restano nel browser
o nei file esportati dall’utente.

## Test e pubblicazione

```sh
cd sherlock-js
node --test --test-concurrency=2 test/*.test.mjs
npm run build:pages
```

Il secondo comando genera `_site/` alla radice del repository: gioco e atlante
sono alla radice del sito; tutti i file del progetto tracciati da Git (eccetto
la configurazione di pubblicazione) sono copiati sotto `archivio/`, conservando
i percorsi del repository. Il pacchetto è escluso da Git.

Il workflow `.github/workflows/pages.yml` esegue i test e pubblica su Pages a
ogni push su `main`, oppure su avvio manuale. Analisi, disassemblati, prove e
materiali di riferimento sono quindi disponibili anche tramite URL diretto su
Pages. [Il manifest dell’archivio](https://zurillion.github.io/sherlock/archivio/manifest.json)
elenca percorsi, URL relativi alla cartella archivio, dimensioni e hash SHA-256.
Non è ancora prevista un’interfaccia di consultazione: i file `.asm`, `.md`,
`.txt` e gli altri formati sono serviti come file statici, non eseguiti.
La cronologia Git locale è conservata. File di sistema, cache, credenziali
locali e oggetti di compilazione sono esclusi dalla versione corrente.
