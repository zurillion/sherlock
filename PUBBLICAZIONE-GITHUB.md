# Pubblicazione GitHub e Pages

Repository: https://github.com/zurillion/sherlock

Sito: https://zurillion.github.io/sherlock/

Atlante: https://zurillion.github.io/sherlock/src/memory.html

Il repository conserva la cronologia Git locale e i materiali del progetto:
ricostruzione, prove, analisi, materiali di riferimento, Foggy London e SkoolKit.
La versione corrente esclude file Finder/Windows, cache, credenziali locali,
ambienti virtuali e oggetti di compilazione. I file esclusi già presenti sono
rimasti sul disco; sono stati tolti dall’indice Git. La cronologia preesistente
non è stata riscritta.

Il workflow `.github/workflows/pages.yml` pubblica tramite GitHub Actions dopo
un push su `main` o un avvio manuale. Prima esegue tutti i test su Node.js 24;
poi `npm run build:pages` copia `index.html`, `style.css`, `src`, `data`
e `images` alla radice di `_site/` per il gioco. Inoltre pubblica sotto
`archivio/` tutti i file tracciati da Git, esclusi `.github/` e `.gitignore`,
con gli stessi percorsi del repository. Sono compresi analisi, disassemblati,
documentazione, strumenti, prove differenziali e materiali di riferimento.
Usare l’elenco Git impedisce di includere cache, credenziali locali ignorate
o file temporanei non tracciati. Il pacchetto è ignorato da Git. Le versioni
delle azioni ufficiali sono fissate a commit verificati.

Esempi di URL diretti:

- https://zurillion.github.io/sherlock/archivio/sherlock-analisi/LEGGIMI.md
- https://zurillion.github.io/sherlock/archivio/sherlock-analisi/ai/results/npc-ai.asm
- https://zurillion.github.io/sherlock/archivio/sherlock-js/results/resolution-mode/resolution-mode.asm

L’indice completo è https://zurillion.github.io/sherlock/archivio/manifest.json:
per ogni file contiene `path`, `url` relativo ad `archivio/`, `bytes` e `sha256`.
Gli URL codificano correttamente spazi e caratteri speciali. Il manifest serve
alla futura interfaccia di consultazione; al momento non è presente un indice
HTML né un elenco automatico delle directory. I file sono risorse statiche:
il browser può mostrarli o scaricarli secondo il formato.

```sh
git push origin main
```

È possibile seguire il deploy dalla scheda Actions del repository. Il server
locale sulla porta 8768 rimane indipendente e non richiede riavvio per pubblicare.

Su Pages funziona il motore JavaScript autonomo. Il selettore Z80 è disabilitato
perché richiede il relativo server locale. Per trasferire una partita dal sito
locale al sito pubblico, usare **Salva partita** e poi **Carica partita**:
i browser conservano separatamente lo stato dei due indirizzi.

Il lavoro di reverse engineering resta aperto sul limite A027, come indicato
in `sherlock-js/RIPRESA-GAMEPLAY.md`. La pubblicazione non estende la copertura
del gameplay o la certificazione dei finali.
