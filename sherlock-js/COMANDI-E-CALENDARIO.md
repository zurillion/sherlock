# Comandi del giocatore, servizi e calendario

Punto 6, 27 ottobre 2026. Implementazione JavaScript autonoma `world-v5`.
Il binario Spectrum viene eseguito soltanto dagli strumenti di ricerca offline.
Il codice della pagina non carica un emulatore né riproduce sequenze registrate.

## Movimento del giocatore

`ENTER HALL` e `GO INTO HALL` cercano una locazione **adiacente** per nome,
quindi eseguono il movimento attraverso la sua uscita. Non è un teletrasporto:
restano porte, luce, ingombro, contenitore corrente e costo del movimento.
Il predicato D39B–D3D4 filtra i nomi attraverso D471; il programma DOMAIN
DD54 ricava la direzione e richiama l'azione corrispondente.

`FOLLOW WATSON` e `COME WITH WATSON` eseguono il programma differito E456.
Il riferimento iniziale può essere una persona lontana; Holmes non può
seguire sé stesso o una lampada. Il programma cerca la locazione della
persona, tenta il movimento adiacente, confronta i contenitori, prova a
uscire ed entrare nel suo contenitore e cede turni attraverso lo scheduler.
Il contatore iniziale è dieci: non è un percorso globale calcolato dalla mappa
né una modalità permanente «segui». Nel caso iniziale `FOLLOW WATSON` dura
12 minuti e Holmes entra nella poltrona di Watson. Seguire Basil da Baker
Street può esaurire i tentativi senza una frase esplicativa. Sono comportamenti
confrontati con l'originale, non scelte di usabilità del prototipo.

`GO TO HALL`, `GO FURIOUSLY TO HALL` e `TAKE WATSON TO HALL` sono riconosciuti
dal parser ma **non hanno una regola operativa per Holmes nel database di
questa edizione**. Ora seguono ricerca e rifiuto originali, anziché fermarsi
su una funzione JavaScript mancante. Il manuale non basta per dedurre
l'esistenza di una regola. Gli ordini al cocchiere mantengono il proprio
programma specifico e continuano a funzionare.

`LOOK THROUGH YOUR DOOR` richiede una barriera con più occorrenze e aperta
o trasparente. Una porta stretta può consentire di guardare anche quando
non consente di passare. La routine DC20 trasferisce temporaneamente il
punto di osservazione e stampa una descrizione breve; ripristina la posizione
ma conserva gli effetti della visita. Non stampa l'illustrazione della stanza.
Il contenitore del giocatore resta attivo: dalla poltrona di Watson il testo
originale può dire «Watsons armchair can see a hall.». Negli ordini a un NPC
compare l'annuncio del suo gesto, non la descrizione remota per Holmes.

`PAY WATSON 6D` e `PAY WATSON £1` funzionano anche senza TO. La risoluzione
scambia i ruoli semantici, conservando l'ordine dei record sintattici originali;
non cambia il gestore condiviso dei pagamenti, del conto o del resto.

## Comandi di servizio nella pagina

| Comando | Comportamento |
| --- | --- |
| `PAUSE` | Nella modalità Spectrum attende un tasto distinto, senza far passare tempo né applicare il reset di MORE. |
| `PRINT` | Collega la stampante virtuale; non fa passare tempo. |
| `NOPRINT` | Esegue 18 ritorni a capo con reset del contatore dopo ciascuno, poi disabilita la stampa. |
| `SAVE` | Passa dal parser originale ricostruito; costa un minuto e avvia lo scaricamento JSON al prompt successivo. |
| `LOAD` | Passa dal parser e apre la scelta di un salvataggio JSON del prototipo. Annullare mantiene la partita corrente. |
| `QUIT` | Congela la partita al confine del servizio di riavvio; si riparte con Riavvia. |

PAUSE, PRINT e NOPRINT scartano il resto della riga, come i rispettivi
handler originali: `PAUSE. I` non esegue INVENTORY. SAVE invece prosegue:
`SAVE. I` impiega due minuti. Sono verificati anche PAUSE/PRINT/SAVE durante
una domanda `WHICH DOOR ?`, seguiti dalla specificazione `YOUR`.

La stampante originale riceve gli **otto scan della riga superiore prima
dello scroll**, non le parole appena aggiunte in basso. La pagina raccoglie
quei byte e mostra «Scarica stampa», che esporta la carta in SVG nero/bianco.
Anche i ritorni a capo di NOPRINT finiscono sulla carta, prima dello spegnimento.
Carta e flag di stampa sono conservati nei salvataggi. Il taccuino moderno
conserva il transcript; la cancellazione video e PAUSE sono riprodotti dalla
modalità Spectrum.

I servizi periferici sono adattamenti espliciti: nessuna stampa di sistema,
nessun formato nastro Spectrum. SAVE conserva uno stato portabile al prompt,
compreso il seguito di una riga composta; non certifica il checkpoint binario
del nastro durante il servizio. LOAD non riproduce il trasferimento nastro,
il riavvio e i residui temporanei del caricatore. QUIT si ferma prima del
riavvio nativo. I pulsanti Salva/Carica restano disponibili.

## Attese e calendario

La singola `WAIT UNTIL` continua a eseguire un minuto alla volta, con tutti
gli attori attivi. Invio o il pulsante interrompono; un messaggio o un arrivo
non interrompono da soli. Non viene precalcolato il futuro. Le nuove prove
coprono anche `WAIT UNTIL 0` e `WAIT UNTIL 59:59PM`, interrotte dopo pochi
minuti: il parser conserva l'aritmetica originale, anche per valori insoliti.
Vedere anche [WAIT-UNTIL.md](WAIT-UNTIL.md).

La mezzanotte incrementa il giorno a otto bit; dopo 255 viene 0. Il nome del
giorno dipende da quel byte modulo sette, non da una settimana indipendente.
Sono verificati mezzogiorno, domenica/lunedì e giorno 255/0. Non viene
introdotto un calendario civile con mesi o anni che il gioco non possiede.

Tick e scadenze degli attori sono a sedici bit. Il confronto di eleggibilità
è **senza segno**, non una differenza modulare corretta. Se il tick è 65534,
`WAIT UNTIL 9` può ritornare al prompt alle 08:01, perché la scadenza è già
andata a zero. Un successivo INVENTORY può arrivare alle 09:01: il suo costo
si somma alla vecchia scadenza e deve raggiungerla dopo il riporto del tick.
La ricostruzione conserva questa stranezza, confrontata anche per gli NPC.

## Prove e confini

- 33 storie, 100 comandi: movimento, rifiuti, contenitori, pagamenti e servizi.
- 5 storie di attesa, 24 checkpoint: due input naturali con interruzione;
  gli altri impostano esplicitamente calendario/tick per raggiungere i riporti.
- Tutti i 24 slot attore attivi, seed 1, avvio gratuito alle 08:00, immagini
  originali disabilitate, input maiuscolo iniettato, MORE/PAUSE immediati,
  nessun timeout inattivo. 645 estrazioni casuali confrontate, comprese
  letture e successori; stato di tutti gli attori, oggetti, fatti, arena dei
  record, buffer, bitmap e campi temporanei posseduti dal modello.
- La stampante presente/assente e il completamento del trasferimento SAVE
  sono risposte periferiche dichiarate del banco di prova. Non sono prove
  di equivalenza dell'hardware nastro/stampante.
- Roundtrip dei salvataggi e continuazioni future; pacchetti reali della
  pagina confrontati in 24 storie; PAUSE asincrona ed esportazione stampa.
- Prova della pagina separata dalla partita dell'utente: PAUSE, PRINT, I,
  NOPRINT, esportazione SVG, SAVE e QUIT. Nessun riavvio del server richiesto.

Rapporto: [results/command-limits-verification.json](results/command-limits-verification.json).
Listato tipizzato: [results/command-limits/commands.asm](results/command-limits/commands.asm),
191 istruzioni e 502 byte riassemblati identici. Header e programmi DOMAIN
sono dichiarati dati, non disassemblati come Z80.

Questo passaggio implementa i nuclei mancanti del punto 6, ma non certifica
ogni partita lunga. Le attese dentro righe composte e il profilo storico
mantengono il precedente percorso a frame precalcolati; la nuova verifica
incrementale riguarda una singola WAIT UNTIL. Lunghi soggiorni su ogni mezzo,
ogni seed e ogni ordine di eventi rimangono da ampliare al punto 7, insieme
ai confini del renderer già documentati e alle temporizzazioni dell'input.
