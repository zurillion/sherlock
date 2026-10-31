# Risultati persistenti della ricerca delle uscite

31 ottobre 2026. Continuazione del limite CB28 del rapporto A026.

Il byte131 letto dalla cuoca non è una costante da aggiungere: è il byte basso
 del puntatore8583. Watson si trova a Slater Street (stanza12) e cerca un’uscita
 verso12. Non esiste: il suo solo arco conduce13. La ricerca termina quindi
 sul byteFF a8583, dopo il record uscita a8580. Anche il predicato falso pubblica
 il puntatore del terminatore. Il secondo risultato rimaneDD61, intestazione
 della regola. La riscrittura ora deriva entrambe le identità dai record correnti.

## Algoritmo e durata

DD6E legge la destinazione daA034 e chiamaD471. Quest’ultima risale il contenitore
 dell’attore tramiteA017/D33C, poi attraversa le triple direzione/cancello/destinazione.
 D206 avanza prima di leggere: il primo record è room.start+9. Il primo target
 corrispondente vince; in assenza di corrispondenze IX punta al terminatoreFF.
 D471 salva e ripristinaIY. DD6E rifiuta l’assenza e le direzioni>=11, senza cercare
 un altro arco valido. Le direzioni inferiori11, compreso0, danno successo.
 Il corpoDD65 legge il byte direzione nel lavoro9FD7 e conserva IX/IY.

CB34 salva entrambi i risultati aCB37/CB3B anche quando il predicato ritorna falso.
 I rifiuti precedenti al ponte non scrivono. La traduzione cancellava le word
 all’ingresso di ogni azione NPC, perdendo un risultato ancora valido. Ora
 conserva i rifiuti dimostrati anteriori al callback e i fallimenti di selezione.
 Non viene genericamente conservato ogni corpo differito: FOLLOW passa dal
 predicatoE44C, i cui risultati restano esplicitamente ignoti. Il corpo differito
 non scrive, ma il suo predicato può averlo già fatto. Parser, prompt, callback
 ignoti e vecchiLOAD senza il campo mantengono i limiti di proprietà esistenti.

Nel percorso naturale al tick4221 Watson esegue ripetutamente DD6E e lascia
 IX8583/IYDD61; i tentativi falliti di Daphne non entrano nel ponte. WAIT di
 Basil6 e dell’agente104 risalvano gli stessi valori; F198 della cuoca9 li
 conserva durante la draw. Con seed51/cursorCA28/mix5 la draw legge
 CB28=131 eCB2E=40 e produce59, nextseed158/cursorCB28. Questi valori sono
 prove offline: nessuno viene installato nel motore.

## Prove e loro ambito

- 516 ABI originali: undici stanze, uscite esistenti/assenti, tre coppie entranti,
  duplicati e prima direzione non valida. Il setup delle varianti mutate è
  dichiarato separatamente; opcode originali invariati. Confronto del risultato
  logico, delle word restituite e della direzione salvata dal corpo riuscito.
- Nuova acquisizione originale naturale finoThu06:30:4102 checkpoint di minuto,
  150897 store per ciascuna word, compresi quelli invariati, zero transizioni
  non classificate. Le chiamate annidate sono associate perSP aCB34/CB37/CB3B;
  la sola ultima destinazione globale non è una provenienza affidabile.
- Il confronto continuo è limitato ai minuti COMPLETI fino4229/Thu06:28 e
  confronta ogni word dichiarata posseduta e ogni draw/read. Le word ignote
  vengono conteggiate, non sostituite. Non è da solo una prova di stato completo.
- Il certificato di stato completo riusa gli originali0–497 e aggiunge una
  nuova acquisizione completa a4229. Confronta tutti24 posti attore, entità,
  fatti, programmi, arena752, bitmap e futuro dopoLOAD. Il minuto successivo
  è escluso. I rapporti JSON registrano i conteggi conclusivi.

Il nuovo limite èE22E, nella visita del giardiniere8 al tick4229. La draw legge
 primaE228=175, poiE22E=17. Non eliminare il campo dal confronto né dedurre17
 dal payload: la prossima analisi deve ricostruirne la proprietà.

## Atlante

208 istruzioni/456 byte riassemblati e confrontati con il payload. Approfonditi:
 CB28–CB40, C9BF–CA75, C4E8–C570, D206–D21B, D33C–D348, D46C–D494,
 DD61–DD83 (quattro byte di intestazione separati dal codice).
 Nessun byte prima grigio: copertura invariata38850 documentati/428 parziali/
 2322 sconosciuti su41600. L’approfondimento funzionale non aumenta
 artificialmente la copertura. Atlante verificato anche nel browser.

Riproduzione: `python3 tools/probe-exit-rule-results.py`,
 `python3 tools/probe-rule-result-lifetime.py`,
 `python3 tools/probe-rule-result-boundary.py`,
 `node tools/verify-rule-result-lifetime-continuous.mjs`,
 `node tools/verify-rule-result-lifetime-prefix.mjs`.
 Il runtime giocabile non importa nessuna di queste catture o listati.

Restano aperti i cinque finali naturali, cab5D0C, PRINT/MORE, TAKE TO e
 il dialogoWatsonKilledYou (7drawJS contro10nativo). Nessuna equivalenza
 globale dell’intero gioco viene dichiarata.

Verifica conclusiva: suite definitiva1795/1795PASS, zero errori, skipped o
 cancelled. Controlli mirati30/30PASS (regressioni del ponte, nuovi casi e
 atlante). La seconda esecuzione completa segue la restrizione finale ai
 preflight globali senza override locale; i due log sono conservati.
 Confronto continuo definitivo14619word note/13195ignote; non usare i vecchi
 conteggi prima della restrizione.
