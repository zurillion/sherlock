# Casualità, riproducibilità e salvataggi

Analisi del 23 ottobre 2026 sul payload Spectrum già identificato nel progetto. Il motore web continua a eseguire le istruzioni Z80 originali; non usa `random` di Python per decidere le azioni degli NPC.

## Risposta alle domande

Il gioco è deterministico **a parità di stato completo e di input/eventi successivi**. Il seed iniziale è un byte, ma da solo non descrive tutto lo stato casuale. La routine legge anche altri indirizzi di memoria e DE. Sullo Spectrum reale contano quindi anche ROM, RAM iniziale, impostazione grafica e input, compresi eventuali WAIT provocati dal timeout della tastiera. La sola uguaglianza di un numero fra 0 e 255 non è una garanzia universale fra macchine e sessioni diverse.

`LD A,R` a **A05F**, seguito da `LD (A037),A` a **A061**, inizializza il seed. È prima del LOOK iniziale, del saluto di Watson e della creazione del suo contatore di lettura. Le estrazioni successive non rileggono direttamente R: consultano e modificano A037 e A039/A03A. Cambiare A037 durante una partita può cambiare le estrazioni e le scelte future. Cambiare la sola etichetta del *seed iniziale* nel file non sostituisce invece lo stato casuale corrente.

L'avvio web con seed esplicito riparte da `game-entry.z80`, prima di queste operazioni, e imposta A appena prima dell'istruzione originale A061. Non riutilizza il primo contatore di Watson già calcolato nello snapshot al prompt.

## Routine D29D–D2EC

| Indirizzo | Significato |
|---|---|
| A037 | Accumulatore casuale corrente, un byte; non necessariamente uguale al seed iniziale |
| A039/A03A | Cursore a 16 bit, letto in formato Z80 little endian |
| D2AD | Estrazione con ampiezza in A; risultato finale in A |
| D2A4 | Estrae con D2AD e prende il valore assoluto del risultato con segno |
| D29D | Imposta ampiezza 99, chiama D2A4 e aggiunge 1: risultato 1–100 |

D2AD salva IX e BC e conserva in C l'ampiezza richiesta. Il limite B è il doppio dell'ampiezza, oppure 255 se lo shift trabocca. Lo shift determina anche il carry iniziale dell'ADC.

Il cursore avanza incrementando **prima A03A**, poi A039 quando A03A trabocca. Da zero gli indirizzi sono quindi 0100, 0200, …, FF00, 0001, 0101, …: non una normale scansione contigua della memoria.

Per ogni tentativo, con `p` il cursore aggiornato e `s` il vecchio A037:

```
x = ((s + memoria[p] + carry) & 255) XOR memoria[(p + DE + 1) & 65535]
```

Se x è identico a s, ripete con un altro indirizzo; dopo quel confronto il carry è zero. Altrimenti salva **x grezzo** in A037. Per ottenere il risultato, dimezza x finché non supera B e sottrae l'ampiezza C. Per le ampiezze ordinarie 0–127 il risultato rappresenta un valore con segno fra −C e +C. Il metodo non è una distribuzione uniforme: nella futura traduzione Python non va sostituito con `randint`.

Anche lo stack è memoria: una replica puramente aritmetica non deve dimenticare gli effetti di PUSH/POP quando gli indirizzi letti finiscono su quello stack. Il ponte attuale evita questo problema eseguendo la routine originale.

Esempio osservato nell'avvio originale, seed 1 e grafica abilitata:

| Estrazione | A | DE | A037 prima | Cursore prima | Letture | A037 dopo | Risultato D2AD |
|---|---:|---|---:|---|---|---:|---:|
| Contatore Watson | 4 | 0005 | 1 | 0000 | 0100=79, 0106=189 | 237 | 3 |
| Test successivo | 99 | 9CEC | 237 | 0100 | 0200=206, 9EED=221 | 102 | 3 |

Il contatore usa D2A4 e aggiunge la base 13: in questo avvio vale quindi 16. La seconda chiamata passa anche per D29D, che aggiunge 1 al risultato.

## Due profili d'avvio

Nella pagina il campo **Seed iniziale** accetta 0–255. Il valore si applica premendo **Riavvia**; non altera una partita in corso. Il seed predefinito è 1. Per scegliere un altro valore prima di leggere l'introduzione basta impostarlo e riavviare.

- **Originale · 08:01** conserva calendario e scadenze del vero avvio. È il profilo da usare per confrontare le scelte con l'originale.
- **Descrizione gratuita · 08:00** conserva la modifica di presentazione richiesta in precedenza: arretra di un minuto calendario, tick e scadenze dopo l'avvio. Non va confuso con una partita originale allo stesso orario.

In entrambi, la grafica **interna alla VM è abilitata**. SVG, pixel e immagini nascoste sono preferenze della presentazione: non cambiano quel flag né le estrazioni della macchina. Questo è necessario perché il generatore può leggere anche RAM video. Per il confronto esterno selezionare la grafica anche nel gioco originale.

Gli script di ricerca mantengono la possibilità `Game(..., seed=None)` / `NativeWorld(..., seed=None)`, che usa il vecchio snapshot al prompt. È compatibilità con i banchi precedenti, non un nuovo avvio con seed scelto. Il server usa sempre un seed esplicito.

## Ispezioni senza effetti sul mondo

Le routine native per descrivere una scena possono cambiare flag di menzione, registri, contatori di stampa e perfino consumare casualità. Ora `scene()` e `inspect()` ripristinano **tutta** la memoria e tutti i registri dopo l'ispezione. GET `/api/state`, reload e cambio della presentazione non aggiungono LOOK alla partita e non consumano estrazioni.

Un LOOK digitato dal giocatore resta invece un comando autentico: può cambiare la sequenza successiva. Anche un salto tramite mappa modifica lo stato; una riproduzione deve includere gli stessi salti, oppure usare soltanto i comandi originali.

## SAVE/LOAD web

**Salva partita** scarica un JSON; **Carica partita** lo ripristina, anche dopo riavvio del server o fine partita. SAVE e LOAD, scritti da soli, aprono le stesse operazioni web. Non aggiungono un turno: sono istantanee al prompt, non la procedura del nastro.

Il file conserva:

- i 65.536 byte di memoria, inclusi video, seed corrente, cursore, heap e codice modificabile;
- tutti i 30 registri del simulatore, compresi DE, flag, R, PC, SP, registri alternativi e tempo CPU;
- il punto d'attesa del parser e lo stack dell'input;
- seed iniziale, profilo d'avvio, fine partita, locazioni visitate e metadati del ponte;
- nella pagina, testo visibile, contatore MORE, immagine e cronologia inferiore; conserva inoltre fino a 200 voci della trascrizione estesa.

Si salva **al prompt**, dopo aver completato il testo e i MORE, anche quando il parser chiede WHICH DOOR? o durante un viaggio che proseguirà nei turni successivi. Non si serializza una continuazione Python mentre WAIT UNTIL sta ancora girando: interrompere/completare il comando prima di salvare. Il caricamento non legge R e non reimposta il seed.

Formato `sherlock-web-save`, versione 1; SHA-256 dell'intero documento, identificazione del payload e verifica della ROM. File incompleti, corrotti o incompatibili vengono rifiutati prima di sostituire la sessione. Non usa pickle. I file sono snapshot locali del progetto e non sono nastri compatibili con il gioco originale.

## Perché il nastro originale non basta

B0EE delimita il blocco salvato: **840B–A01E inclusi, 7.188 byte**. A037 e A039/A03A sono fuori. Dopo LOAD, A0EE salta ad A040 e si ripassa da A05F: il seed viene ricampionato da R; il cursore non viene ripristinato dal blocco su nastro. Per questo il LOAD originale non garantisce le stesse estrazioni future del momento del SAVE. Il salvataggio web completo soddisfa una garanzia più forte, richiesta per l'analisi.

## Prove riproducibili

```
python3 audit_random.py --project "/percorso/Sherlock rebuild" --seed 1
python3 verify_random.py --project "/percorso/Sherlock rebuild"
python3 verify_saves.py --project "/percorso/Sherlock rebuild"
```

`audit_random.py` osserva l'avvio separatamente dal codice di bootstrap web. `verify_random.py` confronta quel banco Z80 indipendente con il motore web: seed 0, 1 e 255, stato iniziale completo, parametri e letture di ogni estrazione, azioni, output e tutti i 65.536 byte di memoria e registri CPU dopo ogni comando. Comprende una sequenza lunga di WAIT e un percorso verso locazioni illustrate. I risultati sono in `results/random-verification.json`.

`verify_saves.py` confronta rami prima/dopo caricamento per più seed, chiarimenti, cab e partita terminata. Confronta ogni byte e ogni registro, oltre ai messaggi successivi. Risultati in `results/save-verification.json`.

Queste prove certificano le sequenze registrate nel protocollo del ponte, non ogni possibile partita sullo Spectrum fisico: il timeout della tastiera non è ancora simulato. Per estendere la verifica bisogna aggiungere sequenze al confronto, mantenendo uguali seed, avvio, grafica e input/eventi.

Le prove aggiuntive `verify_save_terminal.cjs` verificano che il salvataggio del video conservi il punto del MORE, la cronologia e un comando ancora incompleto, e che i controlli esterni non vengano intercettati dalla pausa iniziale. I risultati HTTP sono in `results/persistence-http-verification.json`; `results/seed-graphics-verification.json` copre anche le immagini 054, 055 e 074 con il profilo grafico interno attivo.

Il file `results/example-save-seed-7.json` è l'esempio effettivamente scaricato e ricaricato nella prova della pagina: seed 7, avvio originale, subito dopo l'introduzione. Si può aprire con Carica partita.
