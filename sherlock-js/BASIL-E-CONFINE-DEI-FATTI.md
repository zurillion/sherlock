# Blocco dopo l’alibi di Basil

26 ottobre 2026. Correzione del blocco ripetuto su `$99FB` nel motore autonomo.

## Causa

Il generatore casuale originale consulta byte dello stato globale e valori
immutabili. Gli undici record dei fatti occupano `$9965..$99FA`; il byte
`FF` a `$99FB` termina la tabella. I tre scanner `$BC46`, `$BC74` e `$BC9C`
leggono il soggetto e si fermano su quel valore. Non è un dodicesimo fatto.
Il codice riprende a `$99FC`. La scrittura in `$9A05` modifica invece
l’ultimo termine, a `$99FA`, lasciando intatto il terminatore.

L’esportazione comprendeva record e codice ma ometteva quel byte di confine.
Quando la casualità lo consultava, il prototipo annullava l’intero comando,
compresi tempo, turni e cursore casuale. Il comando successivo incontrava
quindi la stessa dipendenza: la promessa «puoi continuare» era fuorviante.

Il terminatore viene ora esportato come dato immutabile tipizzato. Sono
esportate anche le intestazioni delle sei regole condizionali del programma
del giocatore. In particolare `$D7FA..$D7FB` è l’intestazione `00 00` della
regola semantica, non uno stato da inventare al caricamento. La continuazione
di prova raggiungeva anche questa seconda omissione.

Nessun valore sostitutivo viene generato per indirizzi ancora sconosciuti.
Questi restano limiti espliciti, con un avviso che chiarisce il rischio di
blocco dei comandi successivi e invita a salvare partita e cronologia.

## Altri dettagli emersi dal confronto

Nel percorso interno TELL, il prefisso del nome dell’attore viene stampato
mentre la chiamata annidata è ancora attiva. Il suffisso finale viene
stampato al ritorno. Riprodurre questa distinzione conserva anche i byte
del renderer consultabili successivamente dalla casualità: il caso Basil
è stato confrontato con le scritture originali, non corretto con una costante.

Quando Straker chiude la porta della sala da pranzo da una stanza adiacente,
l’originale annuncia `Someone closes the diningroom door.` La porta è visibile
da entrambe le stanze, mentre l’attore non lo è. Il ramo `$CAF0` sostituisce
il soggetto con l’attore anonimo `FF`. Anche questa notifica è ora presente.

## Prova e limiti

`test/fact-boundary.test.mjs` riproduce i primi 109 comandi del percorso
naturale seed 1 già certificato, fino all’alibi di Basil alle 11:53. Poi
imposta **esplicitamente in entrambi i motori** il cursore casuale a `$98FB`,
per esercitare la lettura mancante `$99FB`. È una prova controllata della
dipendenza, non la ricostruzione della cronologia esatta dell’utente né
l’affermazione che quel cursore sia raggiunto naturalmente da questo prefisso.

Seguono venti INVENTORY fino alle 12:13: 64 estrazioni, 132 letture, incluse
`$99FB` e `$D7FB`, con tutti i 24 slot attori attivi. Sono confrontati ogni
estrazione e successore casuale, attori e scadenze, entità, fatti, flag delle
stanze, tutti i 752 byte dell’arena, buffer dell’editor e token, bitmap esatte
dei due canali e campi ricostruiti del renderer. I pacchetti effettivi della
pagina ricostruiscono le stesse righe. Un ramo salvato/caricato produce le
stesse risposte e lo stesso stato a ogni comando successivo.

Un’altra prova rimuove il terminatore dai vecchi dati e riproduce tre
annullamenti consecutivi, poi carica quello stato con i dati aggiornati e
verifica che il successivo INVENTORY avanzi. Non serve creare una nuova
partita v5 per ricevere questi dati immutabili; non vengono inventati campi
mutabili mancanti nei salvataggi.

Protocollo: LOOK iniziale gratuito, grafica disattivata dopo il primo prompt,
input maiuscolo iniettato, MORE immediato, nessun timeout da inattività.
Le immagini e le altre temporizzazioni restano fuori da questo confronto.
La suite complessiva supera 347 test. Rapporto: `results/fact-boundary-verification.json`.

## Come aggiornare la partita aperta

Salvare la partita prima di ricaricare la pagina sulla porta 8768. Dopo il
ricaricamento, caricare quel salvataggio e riprovare il comando annullato.
L’errore precedente aveva conservato l’ultimo stato valido. Non usare
Riavvia se si vuole mantenere la partita corrente.

Questa correzione non completa il punto 2: memoria delle affermazioni,
valutazione delle prove e deduzioni rimangono il prossimo lavoro funzionale.
