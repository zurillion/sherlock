# Acquisizione naturale delle prove e buffer dei nomi

1 novembre 2026. Questo passaggio prepara il certificato naturale del finale
`$6ABD`; non lo certifica ancora. Il motore giocabile resta JavaScript autonomo.
Il TAP viene eseguito soltanto dagli strumenti di ricerca offline.

## Risultato positivo e confine

La storia parte dal boot, seed 1, tutti i 24 attori, LOOK iniziale gratuito,
grafica originale disattivata dopo il boot, input maiuscolo iniettato e MORE
immediato. Nessun teletrasporto, flag di prova, posizione o PC viene predisposto.
Watson trasporta gli abiti che Holmes non riesce a prendere per il peso.
Dopo la confessione notturna del maggiore, Holmes raggiunge Portman Street e
ottiene naturalmente entrambe le confessioni di Mrs Jones: prima rivolgendosi
a Tricia Fender, poi a Mrs Jones. I rifiuti e i tentativi errati della storia
restano nella sequenza: non sono stati rimossi per facilitare il confronto.

`results/murder-ending/bounded-308-comparison.log` certifica i checkpoint 0–307,
fino a Tue 09:12am: 3659 estrazioni runtime (incluse due del boot), ogni input
letto dall'RNG, stato dei 24 attori, arena di 752 byte, bitmap, pause e futuro
dopo LOAD. La successiva diagnosi per minuto passa fino a Tue 09:18am, ma ha
portata separata: parte dal SAVE JavaScript completo e non ripete i controlli
sui pacchetti browser o sul futuro dopo ogni LOAD.

Il primo limite successivo è `$5D15`, letto dalla cuoca al turno che produce
Tue 09:19am. L'originale legge 0; il vecchio residuo JS era 115. Nessuno dei due
valori viene imposto come fallback: un nuovo HAIL con contesto già attivo
revoca i campi superiori dello stack non ancora proiettati. Il comando resta
esplicitamente non ricostruito. Va identificato il vero scrittore di 5D15.
Il checkpoint divergente e tutti i successivi sono esclusi dal positivo.

## Correzioni funzionali

* C2BA/C316: lo spazio grezzo a fine riga usa un frame distinto da quello
  dell'ultima parola. La visita al cancello Jones conserva correttamente 5D09.
* A7EB: due tabelle degli articoli, entrambe con SOME per la classe plurale.
  Sedici combinazioni originali verificano classe, canale e A2AA.
* C7A6/B6DA: il rifiuto per peso interviene nella risoluzione TAKE, prima della
  ricerca nella descrizione. Non equivale al rifiuto per proprietà altrui.
* D51A/D5C4: AND nella lista ricorsiva dei contenuti usa la propria profondità.
* A92F/A9D7: il buffer conserva i suffissi grezzi maiuscoli. La descrizione del
  cab scrive `travellING`; il giardiniere legge poi G a 5C14. Il renderer ora
  conserva queste operazioni separatamente dalla forma stampata.
* D3D5/D3E8: qualificatori in contesto4, sostantivo in contesto5. Centodieci
  chiamate ABI originali verificano tutti i nomi iniziali, prima della
  normalizzazione. DROP e TAKE OFF possono proiettare i byte del loro argomento
  quando la derivazione dal dizionario coincide con il nome effettivo. Negli
  altri casi restano sconosciuti: non si rende noto il testo formattato in blocco.
  Nel DROP naturale di Watson, `bloodstained` lascia e a 5C15, letta dalla cuoca.
* E298/CFB9: HAIL cerca contesti appartenenti al VEICOLO 30/33, non al conducente
  31/34. L'errore impediva a Basil di richiamare un cab e alterava le estrazioni
  successive. Un contesto del conducente non basta a impedire una nuova chiamata.

Le ABI controllate non provano raggiungibilità naturale di tutte le combinazioni.
Le prove naturali dei buffer osservano anche scritture senza variazione del byte;
non risultano transizioni non classificate nelle due tracce A9D7.

## Provenienza e strumenti

Gli oracoli sono acquisiti in segmenti tramite ripristino INTEGRALE di veri prompt
originali: monday → night → portman → confession → reveal → talk → brown.
I file `*-native-prompt.json.gz` conservano RAM, registri, stack/input e metadati
completi, con hash del payload, storia del segmento e parent. Non sono importati
nel motore JavaScript. Non chiamare queste continuazioni nuovi boot indipendenti.
Il report `results/murder-evidence-verification.json` elenca gli hash degli input.

`tools/research-murder-ending.mjs` prova esclusivamente comandi ordinari e può
ripartire da un SAVE JS. `tools/probe-murder-ending.py` acquisisce l'oracolo;
`--every-minute` restringe la diagnosi temporale. `tools/verify-murder-ending.mjs`
confronta dal boot usando il contratto completo. I file `retry-*`, `tricia-*`,
`brown-*`, `research-*` includono esperimenti negativi: non sono certificati
per il finale. In particolare il secondo viaggio del cab viene ignorato anche
nell'originale in questa storia; non è stato arbitrariamente reso funzionante.

## Atlante

Nuove aree documentate: A24D–A25C (articoli), A2AA (selettore), A7EB–A80D
(selezione articolo), E298–E2C5 e E2CB–E2ED (HAIL), E2C6–E2CA (scratch cab),
CFB6–CFCE (ricerca per identità nei contesti). Altri approfondimenti:
A85C–A87F, A92F–A94C, A887–A8B8, A9B7–AA70, C2BA–C305, C316–C37C,
B6DA–B70F, C7A6–C820, D3D5–D447, D51A–D5C8, alberi 9973–9996.
Il listato distingue codice e dati e riassembla 540 istruzioni/1147 byte.
Copertura: 39087 documentati, 428 parziali, 2085 ignoti su 41600 byte;
138 byte prima ignoti ora documentati. Questo misura la documentazione,
non l'equivalenza globale del gameplay.

## Lavoro ancora necessario

Ricostruire lo scrittore di 5D15; completare il percorso naturale verso la roccia
di martedì e la deduzione su Mrs Brown; consegnare entrambe le conclusioni a
Lestrade e verificare realmente 6ABD. Restano inoltre 6AF3/6B79/75D2 e gli altri
limiti del backlog (cab5D0C, PRINT/MORE, TAKE TO, WatsonKilledYou).

## Verifica finale

Suite completa sulla versione finale: 1816/1816 PASS, zero errori, skip o cancel.
Confronto del precedente finale naturale 6A33 ripetuto sul codice finale:
521 checkpoint fino a Thu10:00, 10345 estrazioni confrontate e 22058 letture;
10347 estrazioni runtime contando le due del boot. Pausa terminale e stato
congelato dopo l'ack restano verificati. Questa regressione riutilizza l'oracolo
originale già acquisito: non costituisce una nuova esecuzione nativa del finale.
I log separano gli esperimenti intermedi negativi dalle verifiche finali.
