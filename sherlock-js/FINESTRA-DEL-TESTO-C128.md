# Finestra del testo: $C128

`$C128` è il modo della finestra sorgente: zero seleziona 36 colonne,
un valore nonzero 18 colonne, accanto alla figura. Non è un flag della
preferenza SVG/pixel del browser. Il profilo delle prove naturali correnti
ha la grafica originale disabilitata dopo il boot; le immagini della pagina
restano una presentazione indipendente.

## Writer e contatore MORE

- `$C129`, store `$C12E`: azzera `$A019`, scrive modo 1, imposta 18 colonne.
- `$C142`, store `$C143`: scrive modo 0 e imposta 36 colonne, **conservando**
  `$A019`. Entrambi riposizionano il cursore a `$5020`, shift 2; non cancellano
  il buffer della parola pendente.
- Boot `$C15D` chiama `$C142`. La preparazione dell'immagine `$A284` chiama
  `$C129`. Sono percorsi distinti.
- Input accettato `$D719`: prima azzera `$A019`, poi chiama `$C142` a `$D71D`.
  Non si deve attribuire quel reset al controllo largo stesso.
- MORE `$C306` attende un tasto e chiama `$C142` a `$C311`, senza azzerare
  il contatore. Il chiamante `$C2D4` scrive FF, poi incrementa a zero.
  Una CR senza MORE non è un writer del modo.
- `$C2E2` rilegge la larghezza dopo lo scroll e l'eventuale MORE.
  `$C316` copia 16 oppure 32 byte per scan; `$C363` pulisce 18 oppure 36 caratteri.

## Implementazione e salvataggi

`src/text-window.mjs` ricostruisce i controlli logici; `RandomDisplay` conserva
`world.display.windowMode`, lo aggiorna ai writer compresi e lo espone al
lettore casuale tramite `NpcRuntime`. Non viene installato un byte catturato
come risposta fissa del generatore casuale.

Un vecchio LOAD privo del campo resta sconosciuto fino a un writer compreso.
Prompt, eco del comando ed errore lessicale non bastano. Anche il preflight
dei controlli speciali conserva questa prudenza: il controesempio PRINT/MORE
preesistente rimane aperto. Il controllo largo opera anche se il vecchio
salvataggio non possiede più il workspace dei token.

Il profilo sorgente supportato dal renderer casuale resta largo: LOAD con
modo stretto è rifiutato esplicitamente. Sono verificati i controlli logici
stretti, **non** la completa equivalenza dei bitmap nativi con immagini.
Nessun cambiamento delle preferenze grafiche della pagina deve riscrivere il flag.

## Prove riproducibili

- `tools/probe-text-window-mode.py`: 12 storie native brevi; confronto di
  modo, ogni draw/read, stato originale completo e ripresa dopo LOAD.
- `tools/probe-text-window-control.py`: 36 chiamate controllate originali
  a C129/C142/C306, modi iniziali 0/1/7 e contatori 0/7/15/255. Gli store
  invariati sono considerati writer. Queste sono prove ABI, non partite naturali.
- `results/text-window-mode/native-random-reads.json`: letture reali di C128
  estratte dal riferimento nativo completo già archiviato, con percorso e SHA256.
  Non è una nuova acquisizione lunga. L'ora è quella del checkpoint; non
  pretende di indicare l'istante esatto della singola lettura.
- `test/text-window-mode.test.mjs`: corpus breve, controlli e proprietà dei
  vecchi LOAD. `test/output-channel-boundaries.test.mjs` conserva i due
  controesempi PRINT/MORE e TAKE TO senza normalizzare il confronto.

Il limite di stato completo del giardiniere nella traccia continua al checkpoint
1671 resta anch'esso separato e aperto. Cinque finali naturali e cab $5D0C
restano da certificare: questo intervento non li dichiara risolti.

## Zone dell'atlante approfondite

`C128`, `C129–C15F`, `A277–A295`, `C2CA–C305`, `C306–C37C`, `D719–D725`:
140 istruzioni e 279 byte riasssemblati contro il payload. Queste aree erano
già censite: nessun byte prima grigio diventa documentato. La copertura resta
38.739 byte documentati, 464 parziali e 2.397 sconosciuti su 41.600.

## Esito del confronto lungo

`compareNaturalHistory` ha nuovamente completato i checkpoint 0–414:
415 checkpoint sino a Wed 16:50, 8.296 draw e 17.768 read confrontati,
24 attori, arena completa, bitmap e futuro dopo LOAD. Il tentativo del
checkpoint 415 verso Wed 17:00 ora si ferma a **$CB28**: la cuoca (attore 9),
draw 19 nel riferimento nativo, legge 204 a questo indirizzo. Il draw 10
del giardiniere leggeva C128=0. Non si certifica lo stato completo né il
confronto di ogni draw del checkpoint annullato: il certificato resta 0–414.
Vedere `results/text-window-mode/lookahead.txt`, `witness-prefix.json` e
`tools/verify-witness-prefix.mjs` per ripetere il prefisso delimitato.

Sono passati 25 test mirati distinti: 17 su runtime/prove native/proprietà/
provenienza/controesempi conservati, più 8 su atlante e hosting.
