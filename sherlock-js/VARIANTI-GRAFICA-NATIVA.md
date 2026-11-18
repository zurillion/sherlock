# Varianti del percorso con grafica nativa

Aggiornamento 18 novembre 2026.

Sono confrontate due storie con seed 1, grafica attiva dall’avvio,
primo LOOK gratuito, tutti i 24 attori e spostamenti tramite comandi.
Ogni storia è confrontata con la propria esecuzione dello Spectrum.

## Ingresso anticipato al binario di Victoria

Al termine del percorso principale, dopo l’ingresso nell’atrio
delle 20:09, gli ultimi tre input cambiano da I, I, E a E, I, I.
Holmes entra al binario alle 20:11. Il finale $6B79 arriva
mercoledì alle 20:12.

La selezione $9E48 controlla la posizione di Watson e Lestrade.
Quando manca almeno uno dei due aiutanti viene scelto il finale
mortale $6B79. Il percorso principale, con entrambi gli aiutanti
presenti, raggiunge invece $6AF3 allo stesso minuto.

Il confronto verifica tutti i 3.219 checkpoint, ogni estrazione
casuale, la bitmap superiore e gli attributi, il contatore MORE,
l’orologio, la locazione e il finale. Il test carica anche un
salvataggio nuovo nell’atrio delle 20:09 e confronta le tre
prosecuzioni fino al finale.

La registrazione originale condivide i primi 3.216 checkpoint
con il percorso principale. Per acquisire il tratto successivo
è stato usato un checkpoint dello Spectrum al tick 3.136.
L’hash del checkpoint e quello della registrazione di origine
sono conservati nella provenienza del corpus. Il suo schermo e
l’orologio sono verificati prima della prosecuzione. Il test
JavaScript riparte dall’accensione.

[Comandi completi](results/victory-route/victoria-early-platform-graphics-route.txt) ·
[Corpus originale](results/victory-route/victoria-early-platform-graphics-seed1.json.gz) ·
[Risultati e provenienza](results/victory-route/native-early-platform-graphics-verification.json)

## LOOK prima del primo cab

Questa storia aggiunge LOOK prima del primo HAIL CAB, conservando
gli altri input del percorso principale. Il tempo e la sorgente
casuale seguono quindi una storia distinta.

Il confronto JavaScript coincide su 1.896 checkpoint fino a
martedì alle 20:17. A quel punto Holmes si trova a Parliament Street,
durante WAIT UNTIL 10:05PM. Sono superate le letture $5C15 e $5C16.

Durante l’arrivo a Leatherhead, al tick 1.536, il descrittore
$44D3 viene decodificato da $D427/$A815. $A9D7 scrive la
«d» finale di «leatherhead» in $5C15. Le parole successive,
più corte, conservano la coda del buffer. La lettura al tick
1.555 usa ancora quel byte.

INVENTORY usa $D526 e $D539/$D3D9 per i nomi degli oggetti
portati. Il qualificatore «bloodstained» lascia la «e» e la «d»
in $5C15 e $5C16 anche quando viene stampato «clothes».
La proiezione usa lo stesso formatter del dizionario già
confrontato sulle 110 entità con entrambe le politiche
dell’articolo. Tre regressioni mirate controllano l’arrivo,
i nomi negli argomenti di testo e INVENTORY, compreso LOAD.

Il primo checkpoint escluso è martedì alle 20:18. Il giardiniere
legge $5D1C. Il chiamante che lascia questo valore richiede
ancora una ricostruzione. Il test segnala quel confine e conserva
la protezione del prototipo. La registrazione originale prosegue
fino a mercoledì alle 20:13, con Holmes al binario di Victoria e
senza un finale raggiunto a quell’ora.

[Comandi completi](results/victory-route/victoria-extra-look-route.txt) ·
[Corpus originale](results/victory-route/victoria-extra-look-native-seed1.json.gz) ·
[Writer, confronti e prossimo limite](results/victory-route/native-extra-look-verification.json)

## Ripetere i confronti

Dalla cartella sherlock-js si possono eseguire i test della pagina.

~~~sh
node --test --test-name-pattern='Seed (0|1) reproduces|Entering the Victoria platform early|An extra LOOK before the first cab' test/native-picture-window.test.mjs
~~~

Il probe acquisisce nuovamente l’esecuzione originale dall’accensione.

~~~sh
python3 tools/probe-native-picture-window.py /tmp/sherlock-early-platform.json --route results/victory-route/victoria-early-platform-graphics-route.txt --seed 1
python3 tools/probe-native-picture-window.py /tmp/sherlock-extra-look.json --route results/victory-route/victoria-extra-look-route.txt --seed 1
~~~


La pubblicazione Pages esegue la suite completa. Il job di build
dispone di 45 minuti. L’esecuzione del 18 novembre sul commit
43e9735 si è fermata al precedente limite di 20 minuti durante
i test, come conferma l’annotazione del runner.

[Workflow di pubblicazione](../.github/workflows/pages.yml) ·
[Esecuzione interrotta](https://github.com/zurillion/sherlock/actions/runs/44299657258)
