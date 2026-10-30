# 5D24: byte basso del descrittore di testo salvato

Il secondo operando dell’estrazione del giardiniere alle Wed10:08 è ora
ricostruito. Il motore autonomo calcola il byte dal parametro del renderer:
nessuna CPU, RAM registrata o sequenza di estrazioni è aggiunta alla pagina.

## Algoritmo e chiamante

C388 salva AF, BC, DE e HL prima del disegno. Con frame d’ingresso5D2A,
il PUSH DE di C38A scriveE a5D24 eD a5D25. Solo il primo byte riceve qui
un nuovo contratto: `descriptor & 255`. Il successivo LD DE,3C00 prepara il
font, ma non cambia il valore già salvato. Non è il byte basso del font né
una parte dell’indirizzo video conservato a5D22/5D23.

Il chiamante naturale è il prefisso del nome proprio dell’attore:
682A ->6804 ->67F7 ->nome attore/A7C5/D3E8 ->renderer. Il prefisso viene
scaricato dentro la chiamata del nome, il sostantivo finale può esserlo
dopo il ritorno. I delimitatori possono quindi usare frame e descrittori
differenti. Il percorso della parola fornisce5C0B; altri descrittori del
nome o del decoder non vanno sostituiti con quel valore.

| Frame C388 | Ruolo fisico di5D24 |
| --- | --- |
|5D26|F del chiamante|
|5D28|C del chiamante|
|5D2A|E del descrittore|
|5D2C|L dell’indirizzo video|
|5D2E|C dello shift interno|
|5D30|F della scansione|

La CALL reale C374 può scrivere77 (return linkC377) nella stessa cella,
con frame5D24. I casi restano separati. BC del chiamante sconosciuto revoca
la sua proiezione; non si conserva per errore un vecchio0B.

`upperGlyphKnown` abilita il byte soltanto nel contratto del chiamante già
verificato. Scene generiche, errori e output senza contratto lo revocano;
anche il limite superiore di invalidateGlyphExtras comprende ora5D24.
SAVE/LOAD conserva il byte corrente. Un vecchio salvataggio che non lo
contiene resta unknown anche se5D23 è noto. Non vengono introdotti5D25–5D27.

## Evidenza

Si riesaminano1728 casi nativi C388:8 frame,2 valoriB del chiamante,
3 caratteri,36 colonne. Si aggiungono1152 nuove chiamate originali con
DE=5C0B/5C42/5123,8 frame,2 conteggi,spazio/r/q e8 shift. Sono ABI controllati,
non chiamanti raggiunti naturalmente. Il valore0B non è incorporato nel
codice: i due altri descrittori verificano42 e23 nel medesimo ruoloE.
Le288 chiamate reali aC374 verificano separatamente i return link.

L’ultimo writer naturale èC38A, tick964, Lestrade2, durante il prefisso
Inspector: glifo r,frame5D2A,SP5D26,DE5C0B,HL5027. Il giardiniere8 legge
il byteE=0B al tick3009,Wed10:08. È il secondo operando dopo5D1E. Il valore
viene calcolato dal parametro preservato in quel frame, non dalla registrazione.

La traccia naturale osserva anche gli store invariati, non soltanto i
cambiamenti di valore, e classifica separatamente eventuali scrittori
sconosciuti. La lettura5D24 è confrontata con il modello senza installare
il byte registrato. La traccia osserva anche5D25 per distinguere i due
registri, ma il runtime non acquisisce quel byte per vicinanza.

Il test naturale precedente di5D1E ora deve completare Wed11:00, senza
accettare più il vecchio blocco5D24. La nuova prova del descrittore arriva
al termine del proprio probe Wed12:00 e interrompe regolarmente il WAIT
prima di provare SAVE. Il certificato completo è separato:393 checkpoint
0–392 fino a Wed13:10,7718 draw/16516 read, tutti24 attori, arena752 byte,
bitmap e futuro dopo LOAD. Il prossimo limite è5D26 nel checkpoint393
verso Wed13:20. Non è certificato un nuovo finale; restano cinque varianti
naturali e il limite separato del cab5D0C.

## Atlante e riproduzione

Approfonditi682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,
C363–C37C,C388–C3E3,CE10–CE17,D3E8–D447 e workspace5D24.
Il dossier riassembla235 istruzioni/419 byte; nessun nuovo byte grigio.
Le percentuali statiche dell’atlante non misurano il completamento del gioco.

```
python3 tools/probe-glyph-descriptor-abi.py
python3 tools/probe-glyph-descriptor-low.py
python3 tools/build-glyph-descriptor-low-listing.py
python3 tools/build-memory-map.py
node --test test/glyph-descriptor-low.test.mjs test/glyph-scan-flags.test.mjs test/memory-map.test.mjs
node tools/verify-witness-prefix.mjs
```

Rapporti: results/glyph-descriptor-low-verification.json,
results/glyph-descriptor-low/witness-prefix.json. I fixture sono offline,
mai letti dal motore giocabile.
