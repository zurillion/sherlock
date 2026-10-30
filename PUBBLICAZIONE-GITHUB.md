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
poi `npm run build:pages` copia solo `index.html`, `style.css`, `src`, `data`
e `images` in `_site/`. Il pacchetto è ignorato da Git e non comprende corpora,
strumenti offline o materiali originali separati. Le versioni delle azioni
ufficiali sono fissate a commit verificati.

```sh
git push origin main
```

È possibile seguire il deploy dalla scheda Actions del repository. Il server
locale sulla porta 8768 rimane indipendente e non richiede riavvio per pubblicare.

Su Pages funziona il motore JavaScript autonomo. Il selettore Z80 è disabilitato
perché richiede il relativo server locale. Per trasferire una partita dal sito
locale al sito pubblico, usare **Salva partita** e poi **Carica partita**:
i browser conservano separatamente lo stato dei due indirizzi.

Il lavoro di reverse engineering resta sospeso sul limite A01D, come indicato
in `sherlock-js/RIPRESA-GAMEPLAY.md`. La pubblicazione non estende la copertura
del gameplay o la certificazione dei finali.
