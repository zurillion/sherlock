i $5D80
w $5D80 Indice alfabetico e limite dell'area dizionario
D $5D80 Word little-endian. Il decoder usa le entrate a partire dal codice $60; a-z corrispondono a $5D82-$5DB5. I valori sono offset relativi a $5DBF. La word a $5DBE contiene $09F8, che conduce a $67B7.
i $5DC0
w $67B7 Tabella delle 32 parole frequenti
D $67B7 I token $60-$7F selezionano una word a questa base. Il risultato e un offset nel dizionario; $A840 aggiunge il contesto $5000, cioe senza suffisso.
i $67F7
b $6859 Frase verificata: I do not know the word seguito da virgoletta
D $6859 Eseguita in isolamento con il codice Z80 originale e stampa bitmap reale. Non sono istruzioni CPU: e il linguaggio dei testi interpretato da $A5CD.
B $6859,3 Token frequenti: i, do, not.
B $685C,2 Token lungo: contesto $50, offset $4AD = know.
B $685E,1 Token frequente: the.
B $685F,1 Spazio letterale.
B $6860,4 Conteggio $43: quattro caratteri a 5 bit; $BB $E4 $40 = word.
B $6864,1 Virgoletta letterale.
B $6865,1 Comando $1F: termina senza punto o ritorno a capo.
i $6866
w $A55D Tabella dispatch dei 32 comandi del linguaggio dei testi
b $A59D Puntatore agli argomenti sullo stack
c $A59F Interprete pubblico con argomenti sullo stack
D $A59F Preserva BC, DE, IX, AF; usa HL per l'indirizzo del testo. Memorizza in $A59D la posizione degli argomenti oltre l'indirizzo di ritorno. Alla fine ripristina i registri, recupera il ritorno e aggiusta SP per consumare gli argomenti. La convenzione completa dei singoli comandi resta da documentare.
c $A5C3 Salto indiretto tramite HL
c $A5C4 Interpreta una sequenza di token con inizio in HL
D $A5C4 IX diventa il cursore. Ripete $A5CD finche Z e zero; un comando terminale restituisce Z impostato. Per sequenze senza argomenti dinamici e utilizzabile direttamente, come nella prova a $6859.
c $A5CD Decodifica e dispatch di un token
D $A5CD Con bit 7 impostato: token lungo a due byte; D=primo byte AND $7F, E=secondo byte. I 12 bit bassi sono l'offset del dizionario, i bit 12-14 selezionano il contesto. I contesti $20/$30/$60 terminano la sequenza dopo la parola e passano da $A647.
 $A5F2 Token sotto $20: comando tramite tabella $A55D.
 $A5F6 Token $60-$7F: parola frequente tramite $A83A/$A840.
 $A5FB Token $40-$5F: (token AND $1F)+1 caratteri a 5 bit immediatamente successivi.
 $A609 Legge un carattere a 5 bit e lo invia al buffer di uscita.
 $A611 Aggiorna IX dopo i byte compatti, tenendo conto dell'allineamento.
 $A61C Token $20-$3F: carattere letterale.
 $A621 Selezione della routine del comando (2 byte per indirizzo).
 $A62F Comandi $1D-$1F sono terminali e ricevono un salto diretto; gli altri vengono chiamati.
c $A63A Comando che emette A e restituisce Z impostato
c $A63F Terminazione con ritorno a capo (contesto $60)
c $A643 Terminazione con punto e ritorno a capo (contesto $30)
c $A647 Stampa la parola finale e applica la terminazione
D $A647 $20: solo fine; $30: punto e CR; $60: CR. I comandi $1D e $1E entrano rispettivamente da $A63F e $A643, senza stampare una parola.
i $A65C
c $A83A Token compatto di parola frequente
c $A840 Risoluzione della parola frequente
D $A840 A-$60 seleziona una delle 32 word a $67B7. Restituisce DE con offset e contesto $5000. Questo ingresso da solo non stampa.
b $A851 Stato di forzatura delle maiuscole
c $A852 Alterna $A851 tra 0 e 1
b $A85C Nove suffissi da quattro byte ciascuno
D $A85C S, ES, IES, backspace+IES, D, ING, ED, backspace+ING, LY. Gli zeri sono riempimento. $08 viene interpretato come arretramento nel buffer parola da $A9B7.
B $A85C,36,4
c $A880 Legge un riferimento dal puntatore HL e azzera il nibble di contesto
D $A880 Legge prima il byte basso, poi quello alto; avanza HL di due. A887 riceve solo i 12 bit bassi del riferimento.
c $A887 Ricostruisce ed emette una voce del dizionario
R $A887 DE Offset a 12 bit e contesto nel nibble alto.
D $A887 Non emette nulla se $5C3C e zero o l'offset e zero. Conserva IX, HL, BC, DE sul percorso normale. Inserisce uno spazio prima della voce. Trova il gruppo alfabetico nell'indice $5D80, emette l'iniziale implicita e decodifica sequenzialmente i record del gruppo fino all'offset richiesto. Applica poi l'eventuale suffisso e invia il resto della parola a $A9B7.
 $A8A3 Contesto $70: imposta $A026 per rendere maiuscola la prossima lettera.
 $A8BA Indice alfabetico, confrontato con l'offset richiesto.
 $A8EA Emette l'iniziale ricostruita dal numero del gruppo.
 $A8EE Base relativa $5DBF: converte offset in indirizzi RAM.
 $A8F5 Decodifica record successivi finche arriva al record richiesto.
 $A903 Contesto $50: nessuna desinenza; $40: desinenza obbligatoria; $10: dipende da $A034; gli altri dipendono da $A036.
 $A91C Emette il buffer terminato da zero a $5C42.
c $A92F Appende il suffisso indicato dal record
D $A92F HL punta al primo byte del record e IX alla fine del buffer. Nibble basso $F: nessun suffisso. Altrimenti usa quattro byte da $A85C+4*nibble e aggiunge un terminatore zero. Nel dizionario presente gli indici sono soltanto 0-8 oppure $F.
c $A94D Decodifica un record e applica il suo suffisso
c $A95B Decodifica il resto di una voce con riuso di prefisso
R $A95B HL Indirizzo del primo byte del record.
D $A95B Usa il buffer precedente a $5C42. Byte 1: bit 7 fa saltare due byte aggiuntivi; bit 4-6 indicano quanti caratteri precedenti conservare; bit 0-3 indicano quanti nuovi caratteri a 5 bit leggere. La prima lettera del gruppo non e nel buffer. Restituisce HL al record successivo e IX sul terminatore. Conserva BC. La natura dei due byte aggiuntivi non e ancora identificata.
 $A960 Salta il byte 0, contenente fra l'altro l'indice di suffisso.
 $A961 Legge il descrittore del record.
 $A969 Conserva il prefisso del buffer precedente facendo avanzare IX.
 $A974 C e il cursore di bit, inizialmente zero.
 $A97C Estrae i nuovi caratteri e li scrive nel buffer.
 $A986 Terminatore zero.
 $A98C Se restano bit parziali, avanza al byte successivo.
c $A990 Estrae un carattere da un flusso a 5 bit
R $A990 HL Puntatore al byte corrente.
R $A990 C Offset di bit nel byte (0-7), MSB per primo.
D $A990 Legge una finestra di due byte, la allinea al cursore C, prende cinque bit e aggiunge $60. A restituisce il carattere. HL e C avanzano di cinque bit; DE viene preservato.
w $A9B5 Puntatore corrente del buffer parola (base $5C0B)
c $A9B7 Buffer parola e a capo senza spezzare le parole
R $A9B7 A Carattere da accodare.
D $A9B7 Con $A027 diverso da zero salta direttamente a $C1E1. Nel percorso normale accoda il carattere; $08 arretra il puntatore. Spazio, CR e virgoletta svuotano il buffer: confronta la lunghezza con le colonne rimaste in $C1F5 ed eventualmente emette prima un CR. Poi invia i caratteri e il delimitatore a $AA14.
c $AA14 Normalizzazione, spazi iniziali e maiuscole
D $AA14 Converte inizialmente A-Z in a-z, sopprime lo spazio se $A025 e zero, aggiorna lo stato di riga. Punto e virgoletta impostano $A026. Una lettera diventa maiuscola se $A026 o $A851 e attivo. Infine salta a $C1E1.
i $AA71
c $C10F Pulisce lo schermo e imposta bordo bianco
b $C128 Stato di larghezza della finestra narrativa
B $C128,1
c $C129 Imposta modo a 18 colonne
c $C142 Imposta modo a 36 colonne
c $C14A Inizializza i due cursori e il motivo grafico
b $C190 Motivo grafico di 24 byte
B $C190,24,4
c $C1A8 Stampa una stringa di lunghezza B a posizione fissa
D $C1A8 Stringa in HL. Imposta destinazione video $5041 e offset zero, emette uno spazio, B caratteri e uno spazio direttamente tramite $C388. Usata dalla visualizzazione dell'orologio a $BF79.
c $C1C0 Stampa stringa, attende un tasto e va a capo
c $C1CB Stampa stringa non compressa con bit 7 di fine
D $C1CB HL punta alla stringa. Emette ogni byte AND $7F tramite $C1FD e termina quando il byte sorgente ha bit 7 impostato. Non e il formato del dizionario compresso.
c $C1D7 RET isolato
c $C1D8 Messaggio e salto a $A0EB
c $C1E1 Selezione del canale di uscita
D $C1E1 Se $5C3C e zero, scarta il carattere. Altrimenti $A027=0 seleziona $C2BA; $A027 diverso da zero seleziona $C1FD.
b $C1F4 Stato dei due cursori video
B $C1F4,2 Colonne rimaste: canale inferiore e superiore.
W $C1F6,4 Indirizzi bitmap: canale inferiore e superiore.
B $C1FA,2 Offset orizzontali in bit: superiore e inferiore.
c $C1FC Ripristina AF prima di entrare nel canale inferiore
c $C1FD Canale inferiore con cursore e gestione backspace
D $C1FD Usa $C1F4/$C1F6/$C1FB. Gestisce CR e backspace; converte le lettere in maiuscolo. Disegna un segno + come cursore. Usa $C388 per i glifi.
c $C240 Conversione ASCII a-z in A-Z
c $C249 Gestione backspace del canale inferiore
c $C267 Arretra il cursore di sette pixel
c $C271 Scorrimento verso l'alto del canale inferiore
c $C29C Scorrimento inverso del canale inferiore
c $C2BA Canale superiore del testo narrativo
D $C2BA Usa $C1F5/$C1F8/$C1FA. CR oppure esaurimento delle colonne attivano lo scorrimento $C316. Dopo un contatore di righe, $C306 attende un tasto. Il renderer e sempre $C388.
c $C306 Pausa di paginazione e ripristino del modo largo
c $C316 Scorrimento della finestra superiore
c $C37D Avanzamento di una riga carattere nella bitmap Spectrum
c $C388 Disegna un glifo ROM alla posizione indicata
R $C388 A Codice carattere.
R $C388 HL Indirizzo bitmap della prima riga del glifo.
R $C388 C Offset orizzontale in bit (0-7).
D $C388 Indirizzo font=$3C00+8*A. Legge otto righe e le combina tramite maschere con uno o due byte dello schermo. INC H passa alla riga pixel seguente. Alla fine HL/C avanzano di SETTE pixel, non otto. Preserva A, B e DE; modifica i flag. Non invoca la routine PRINT della ROM.
 $C38C Calcola 8*A.
 $C392 Base per la tabella caratteri ROM.
 $C399 Otto righe per glifo.
 $C39B Allinea e unisce la prima porzione di riga al byte video.
 $C3B3 Se C non e zero, unisce anche la porzione nel byte successivo.
 $C3D7 Avanzamento orizzontale di sette pixel.
i $C3E4
