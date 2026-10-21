c $5B00 Copia del bootstrap: eseguito originariamente a $8000
D $5B00 Questa vista mostra i 256 byte del blocco 4 TAP alla destinazione della copia. Le istruzioni $5B00-$5B0F sono eseguite a $8000-$800F, non a questi indirizzi nel percorso normale.
 $5B01 Stack iniziale a $5D80; cresce verso indirizzi inferiori.
 $5B0D Copia $0100 byte da $8000 a $5B00.
 $5B0F Prosegue nella copia a $5B12.
c $5B12 Sequenza principale di caricamento
 $5B12 Carica SHD V2.0 usando indirizzo e lunghezza dell'header.
 $5B15 Carica lo schermo forzando destinazione $4000 e lunghezza $1B00.
 $5B18 Carica p usando indirizzo e lunghezza dell'header.
 $5B1B Trasferisce il controllo al programma a $A040.
b $5B1E Buffer header di 17 byte, poi stato di caricamento
D $5B1E Contenuto iniziale: tipo 3, nome MELBHOUSE seguito da spazio, lunghezza $4A00, indirizzo $B600, parametro 2 $B600. I 17 byte $5B1E-$5B2E vengono sovrascritti a ogni lettura di header; $5B2F contiene lo stato restituito dal wrapper.
B $5B1E,1 Tipo del blocco.
T $5B1F,10 Nome iniziale; dati, non istruzioni.
W $5B29,6 Lunghezza e due parametri dell'header.
B $5B2F,1 Stato: 1 successo; 2 mancato carry al ritorno dalla ROM.
c $5B30 Carica un blocco CODE secondo il suo header
D $5B30 Legge un header di 17 byte con flag 0; richiede successo e tipo 3. Carica poi il payload con flag $FF all'indirizzo e per la lunghezza dell'header. Salta a $0000 in caso di errore. Modifica AF, DE, IX e altri registri tramite ROM; contratto completo della ROM ancora da documentare.
 $5B30 Destinazione dell'header.
 $5B39 Wrapper della lettura nastro.
 $5B40 Reset in caso di stato diverso da 1.
 $5B48 Reset se il tipo dell'header non e 3.
 $5B4B IX = indirizzo destinazione dall'header.
 $5B4F DE = lunghezza dall'header.
 $5B53 Flag atteso per il payload.
 $5B5E Reset se il caricamento non e riuscito.
c $5B62 Carica lo schermo ignorando la destinazione dell'header
D $5B62 Consuma e verifica la lettura dell'header, poi legge esattamente 6912 byte a $4000. Non esegue qui il controllo del tipo 3 effettuato da $5B30.
 $5B75 Destinazione effettiva dello schermo, diversa da $8000 dichiarato sul nastro.
 $5B79 6144 byte bitmap e 768 attributi.
c $5B8B Wrapper per la routine di lettura nella ROM
R $5B8B A Flag atteso: 0 header, $FF payload.
R $5B8B IX Destinazione.
R $5B8B DE Numero di byte.
R $5B8B F Il chiamante imposta carry con SCF per la lettura.
 $5B8B INC D / EX AF,AF' / DEC D prepara i flag e salva A e carry nel banco alternativo prima di entrare nella ROM a $0562.
 $5B8F Valore per porta $FE: bordo bianco e bit 3 attivo.
 $5B93 Prepara sullo stack il ritorno a $5B9A.
 $5B97 Entra nella ROM; non e una CALL convenzionale.
c $5B9A Ritorno dalla ROM e registrazione dell'esito
 $5B9A Conserva AF mentre ripristina la porta $FE a 7.
 $5BA0 Esito 1 se carry impostato, 2 altrimenti.
 $5BA5 Salva l'esito fuori dal buffer header.
s $5BAA Riempimento iniziale di 86 byte a zero
i $5C00
