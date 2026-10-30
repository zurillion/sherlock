# Sherlock · ZX Spectrum

Reverse engineering di **Sherlock** (Melbourne House) e ricostruzione autonoma
in JavaScript. Il gioco originale è usato come riferimento offline; la versione
web esegue la logica ricostruita nel browser.

- [Gioca su GitHub Pages](https://zurillion.github.io/sherlock/)
- [Esplora la mappa della memoria](https://zurillion.github.io/sherlock/src/memory.html)
- [Stato e lavoro ancora da fare](sherlock-js/RIPRESA-GAMEPLAY.md)

La ricostruzione è ancora parziale. L’ultimo prefisso naturale certificato
comprende 368 checkpoint fino a mercoledì 09:00, con tutti i 24 posti attore,
estrazioni casuali, stato e output confrontati con l’originale. Il prossimo
limite dichiarato è A01D. La documentazione distingue i test controllati dalla
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

Il secondo comando genera `_site/` alla radice del repository, con solo i file
necessari al browser e all’atlante. Il pacchetto è escluso da Git.

Il workflow `.github/workflows/pages.yml` esegue i test e pubblica su Pages a
ogni push su `main`, oppure su avvio manuale. Ricerca offline, fixture e materiali
originali rimangono nel repository, senza essere copiati nel pacchetto Pages.
La cronologia Git locale è conservata. File di sistema, cache, credenziali
locali e oggetti di compilazione sono esclusi dalla versione corrente.
