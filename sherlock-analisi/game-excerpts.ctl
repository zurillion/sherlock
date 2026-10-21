i $5D80
c $A040 Ingresso del programma dopo il caricamento
D $A040 Ingresso raggiunto nella simulazione del TAP. Questa e una selezione parziale: le aree omesse non sono classificate. Le semantiche delle variabili non sono ancora note.
 $A040 Azzera $D6B8 e $A01B.
 $A048 Prepara lo schermo tramite $C14A.
 $A04B Ripristina lo stack a $5D80.
 $A04E Attende un carattere tramite $C415.
 $A051 Confronta con n minuscola.
 $A055 Confronta con N maiuscola.
 $A05B n/N portano A a zero; ogni altro carattere lascia A a 1.
 $A05C Registra questa scelta in $A011. Significato ancora da verificare.
 $A05F Salva il registro R in $A037; possibile sorgente di variabilita, non ancora dimostrata come seme casuale.
 $A064 Azzera $A0DA prima del ciclo successivo, omesso da questo estratto.
i $A068
c $C14A Preparazione schermo e motivo grafico
D $C14A Eseguita nella prima traccia di avvio. Il ciclo $C168-$C180 copia sei righe da quattro byte ciascuna, ripetendole otto volte in orizzontale. La sorgente a $C190 e quindi un motivo grafico da 24 byte.
 $C14A Chiama $C10F: effetti da documentare separatamente.
 $C14D Imposta parametri nelle celle $C1F4, $C1F6 e $C1FB.
 $C15D Chiama $C142: effetti da documentare separatamente.
 $C160 Destinazione bitmap a $5140.
 $C163 Sorgente del motivo grafico.
 $C166 Sei righe di pixel.
 $C168 Otto ripetizioni orizzontali.
 $C16C Quattro byte per ripetizione.
 $C179 Avanza la sorgente alla riga successiva.
 $C17F Avanza alla riga pixel seguente nella disposizione video Spectrum.
 $C182 Riempie 32 attributi a $5A40-$5A5F con $78.
b $C190 Motivo grafico di 24 byte
D $C190 Provato dalla routine che legge questi byte e li copia nella bitmap. Qui non si devono interpretare i byte come istruzioni Z80.
B $C190,24,4
i $C1A8
c $C415 Attesa di un carattere valido
D $C415 Ripete $C41F finche A ha il bit 7 impostato, poi rimuove quel bit e restituisce il carattere in A. La chiamata iniziale proviene da $A04E; il ramo con un tasto disponibile non e stato esercitato in questa sessione.
c $C41F Poll tastiera sincronizzato con interrupt
D $C41F Preserva IY, IX, HL, DE e BC. Imposta IY=$5C3A, abilita gli interrupt ed esegue HALT; dopo il risveglio li disabilita. Esamina bit 5 di $5C3B e legge il carattere da $5C08. Restituisce 0 senza nuovo carattere oppure il risultato della conversione con bit 7 impostato. Effetti della chiamata $C240 ancora da verificare.
 $C426 Base dell'area di sistema ROM.
 $C42A Abilita interrupt per il successivo HALT.
 $C42D Legge il flag di disponibilita del carattere.
 $C437 Consuma il flag prima di leggere il carattere.
 $C43C Legge il carattere; seguono conversioni $5F->$18, $0C->$08, $0B->$5B.
 $C451 Ulteriore conversione tramite $C240: da analizzare.
 $C454 Marca il risultato come carattere disponibile.
i $C45E
