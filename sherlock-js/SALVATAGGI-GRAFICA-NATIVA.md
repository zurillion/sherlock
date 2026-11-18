# Ripresa della partita con grafica nativa

Aggiornamento 18 novembre 2026.

Le partite con seed 0 e 1 sono state confrontate dall’accensione
alla vittoria $6AF3 a Victoria, mercoledì alle 20:12. Per ogni
seed, sei salvataggi JSON sono stati caricati in una sessione nuova.

| Punto | Ora | Stato |
| --- | --- | --- |
| 11 | lunedì 08:25 | Atrio con immagine |
| 16 | lunedì 08:32 | Cab prenotato |
| 31 | lunedì 09:21 | Sul treno |
| 62 | lunedì 11:08 | Indizi di Leatherhead |
| 3198 | mercoledì 19:51 | Ultimo viaggio in cab |
| 3217 | mercoledì 20:11 | Atrio di Victoria |

Dopo ogni caricamento, la sessione ripresa segue gli stessi input
della sessione continua fino al salvataggio successivo. Ogni minuto
di WAIT UNTIL è una verifica distinta. Il confronto copre 3.207
checkpoint di prosecuzione per seed, 6.414 complessivi.

Si confrontano le risposte complete dell’API, i pacchetti dello schermo
e lo stato del mondo. Gli identificatori dei job appartengono alla
connessione e sono verificati separatamente. Il confronto con lo
Spectrum include ogni estrazione casuale, la bitmap superiore,
gli attributi, l’orologio, la locazione e il finale.

La serializzazione conserva l’accumulatore e il cursore casuale,
gli ingressi mutabili già ricostruiti, i buffer della parola, i residui
dei glifi, i contesti degli NPC e lo scheduler. Il formato resta quello
usato dalla pagina.

La prova dei vecchi salvataggi continua a verificare che un campo
assente resti sconosciuto fino a una scrittura ricostruita. La sua
aspettativa sul messaggio d’errore ora usa la stringa corrente
«Modo finestra nativo non valido». Il controllo passa.

I sei salvataggi sono eseguiti al prompt, quando il comando è terminato.
La pagina richiede di interrompere un’attesa in corso prima di salvare.

[Risultati e hash dei corpus](results/seed-and-saves/native-victoria-save-load.json) ·
[Test riproducibile](test/native-picture-window.test.mjs) ·
[Percorso e confronti originali](PERCORSO-VITTORIA.md#verifica-con-la-grafica-nativa-attiva)
