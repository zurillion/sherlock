# PAY senza TO: stesso modello, diverso ordine dei nominali

L’originale riconosce il modello PAY anche senza TO. L’assenza della
preposizione sceglie l’ordine dativo **destinatario, importo**; non autorizza
la scelta automatica di chi pagare.

| Comando | Risultato originale verificato |
| --- | --- |
| PAY WATSON 10D | Pagamento di 10d a Watson, un minuto |
| PAY 10D TO WATSON | Stesso pagamento e costo |
| PAY 10D | DON’T BE SILLY. Nessun pagamento o avanzamento del tempo |
| PAY 10D WATSON | DON’T BE SILLY. Ordine senza TO errato |
| PAY / PAY WATSON / PAY CABBIE / PAY 1 | DON’T BE SILLY. Argomenti insufficienti o non monetari |
| PAY 10D TO | Rifiuto, senza falsa richiesta di chiarimento |

Dopo `PAY 10D` non rimane una continuation: WATSON da solo riceve WHAT?,
mentre un nuovo comando I viene eseguito normalmente. `PAY 10D. I` è già
rifiutato dal parser con WHAT? in questo protocollo: non è equiparato a
due comandi validi dal prototipo.

## Causa e correzione

Il motore JavaScript selezionava il modello37 senza TO soltanto con due
gruppi nominali. `PAY 10D` cadeva quindi in un vecchio UnsupportedFeature.
Inoltre lo scambio semantico era dedotto dalla presenza del denaro nel
secondo nominale: questo accettava erroneamente `PAY 10D WATSON`.

Ora la selezione lessicale del modello non richiede due argomenti.
B421/B445 determina lo scambio per PAY senza preposizioni anche se uno
slot manca, conservando i gruppi fisici originali tramite sourceGroupOrder.
Il controllo del letterale monetario e del destinatario resta condiviso
con `PAY … TO …`. Un destinatario ambiguo viene rifiutato prima della domanda
nominale generica, coerentemente con needsClarification: nessun record
pendente fittizio e nessun blocco del comando successivo.

Non sono stati modificati trasferimento del denaro, tariffa o resto del cab.
Per pagare il cocchiere: `PAY 10D TO CABBIE` oppure `PAY CABBIE 10D`. L’importo da versare dipende dal conto del viaggio.

## Prove e mappa

11 storie originali, 24 input, 74 draw e 148 letture; tutti i 24 attori attivi,
seed 1, LOOK iniziale gratuito, grafica originale disabilitata dopo il boot,
input maiuscoli iniettati e MORE immediato. I test confrontano risposte,
stato originale completo, arena, bitmap, clock, saldo, ogni draw/lettura e
futuro dopo LOAD. Nessuna normalizzazione dei campi per farli passare.
Con i controlli precedenti dei comandi e quelli di atlante/hosting:
78 test mirati distinti passati.

Atlante: modello8379–8380, selezione/ordine B39D–B482, preflight del saldo
E345–E36F, intestazione E370–E373 e corpo E374–E38E. Modello e intestazione
sono dati tipizzati. 141 istruzioni e 312 byte riasssemblati contro il payload.
Passano da grigi a documentati 60 byte: E34F–E36F ed E374–E38E.
Il rapporto è results/pay-omitted-to-verification.json; il certificato lungo resta quello
CB28:421 checkpoint fino aWed17:50, prossimo limite5D29 verso18:00.
