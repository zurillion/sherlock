"""Annotate verified code and data from the Brown and Camden routes."""
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
project = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(project / 'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler

memory = bytes(0x5D80) + (project / 'sherlock-analisi/block-10.bin').read_bytes()
assembler = Assembler()
regions = [
    (0x9CF2, 0x9D10, 'code', 'Incontri NPC: pubblicazione del destinatario'),
    (0x9D13, 0x9D2E, 'code', 'Watson verifica tre incontri, poi richiama un ricordo'),
    (0x9E74, 0x9E85, 'code', 'Stampa, pausa e chiusura del finale'),
    (0xA02D, 0xA02E, 'data', 'Classe del token precedente'),
    (0xA02E, 0xA02F, 'data', 'Selettore nominale'),
    (0xA4CD, 0xA536, 'code', 'Ricerca e selezione del riferimento nominale'),
    (0xA038, 0xA039, 'data', 'Visibilità dei candidati nella ricerca nominale'),
    (0xA03B, 0xA03D, 'data', 'Contatore di attesa del prossimo tasto'),
    (0xA03D, 0xA040, 'data', 'Tre byte prima del punto d’ingresso'),
    (0xA536, 0xA55D, 'code', 'Lettura del tasto e ciclo temporizzato'),
    (0xA6D3, 0xA6DF, 'code', 'Scelta testuale: puntatore e ingresso del calcolo casuale'),
    (0xA7D0, 0xA80E, 'code', 'Articolo di un nome comune e ritorno del decoder'),
    (0xA815, 0xA82F, 'code', 'Chiusura del nome e salvataggio dell’indice dell’articolo'),
    (0xA887, 0xA88C, 'code', 'Uscita prima della stampa quando l’attore non è percepibile'),
    (0xA9D7, 0xAA11, 'code', 'Buffer grezzo e scarico del punto anche fuori scena'),
    (0xAE7F, 0xAEA9, 'code', 'Lettura dei token e salvataggio della classe precedente'),
    (0xB049, 0xB09A, 'code', 'Verbo TALK implicito e delimitatore di citazione'),
    (0xB3B6, 0xB3FD, 'code', 'Inizializzazione della ricerca nominale'),
    (0xB8AA, 0xB904, 'code', 'Analisi della citazione e coda delle richieste'),
    (0xB4DA, 0xB4E2, 'code', 'Copia del bit di visibilità per il primo referente'),
    (0xB581, 0xB589, 'code', 'Copia del bit di visibilità per il secondo referente'),
    (0xB62F, 0xB65F, 'code', 'Rifiuto della ricerca: selezione del primo o secondo referente'),
    (0xB934, 0xB936, 'data', 'Opcode attivo e ultimo opcode di consegna degli ordini'),
    (0xB936, 0xB95C, 'code', 'Consegna degli ordini: selezione e copia dell’opcode'),
    (0xC182, 0xC190, 'code', 'Attributi della striscia dell’orologio: 32 celle con BRIGHT'),
    (0xC1A8, 0xC1C0, 'code', 'Orologio: origine, spazi e avanzamento di sette pixel'),
    (0xC271, 0xC29C, 'code', 'Ultima cella della pulizia della console'),
    (0xC388, 0xC3E4, 'code', 'Indirizzo video, shift e scansione del glifo'),
    (0xCC82, 0xCC94, 'code', 'Ingresso DOMAIN: azzeramento dell’opcode dell’ordine attivo'),
    (0xCE3B, 0xCE65, 'code', 'Operandi temporanei di una regola DOMAIN'),
    (0xD008, 0xD045, 'code', 'Ripristino e salvataggio del contesto NPC'),
    (0xD2CB, 0xD2DB, 'code', 'Dopo le letture casuali: salvataggio dell’indice della scelta'),
    (0xD3D5, 0xD448, 'code', 'Descrittori dei nomi nelle liste'),
    (0xD60B, 0xD671, 'code', 'Direzione del passaggio, articolo e nome'),
    (0xD898, 0xD8AD, 'code', 'Ingresso dell’editor: ricarica il contatore'),
    (0xDFCC, 0xDFE3, 'code', 'Finale selezionato dalla presenza di Basil'),
    (0xE6BE, 0xE6E6, 'code', 'Stampa della richiesta di pagamento del cocchiere'),
    (0xE710, 0xE72F, 'code', 'Avvertimento del cocchiere e visibilità temporanea'),
    (0xEBC5, 0xEBCB, 'domain', 'Lestrade: attesa della posizione del veicolo'),
    (0xEF90, 0xEF96, 'domain', 'Basil fuori scena: attesa e salto all’indietro'),
    (0xEFC7, 0xEFC9, 'data', 'Intestazione della regola di Basil'),
    (0xEFC9, 0xEFF6, 'code', 'Controllo della posizione di Holmes nella casa di Basil'),
]
notes = {
    0x9CF3: 'Scrive il destinatario A034 prima di controllarne la presenza. Anche un incontro fallito aggiorna il campo.',
    0x9D26: 'Ultimo destinatario di Watson: Straker (4). E691 può leggere A034 prima che la successiva regola lo cambi.',
    0x9E7C: 'Pausa dopo il testo terminale. La conferma precede il passaggio alla chiusura B0AC.',
    0xA02D: 'Classe precedente, salvata da AE86. Il WAIT controllato lascia B0, anche dopo il consumo del delimitatore.',
    0xA02E: 'Il valore è separato da A02D. B3DA lo inizializza e A4EB lo seleziona in base all’intestazione nominale.',
    0xA4EB: 'Ultima scrittura del selettore per il WAIT UNTIL dal tick 3781. La cuoca lo legge al tick 4070.',
    0xA038: 'Valori 0/1 ricavati da A01D per una ricerca dei referenti. BDF0 scrive 2 quando cerca i referenti di un’affermazione. Una semplice attesa senza ricerca non lo azzera.',
    0xA6D3: 'HL identifica l’inizio dell’interprete della scelta testuale. Nel tono del cocchiere fuori scena, D2D3 lo salva a 5D40–5D41.',
    0xA03B: 'Word little endian per il timeout dell’editor. D89B e A558 caricano 3000. L’ingresso che inietta i tasti sostituisce A536, quindi lascia il contatore pieno.',
    0xA03D: 'Tre byte caricati 04 40 58. Il listing non identifica un writer o un lettore funzionale oltre al generatore casuale. La traccia del giardiniere legge 04 venerdì alle 05:44.',
    0xA558: 'Ricarica 3000 dopo la lettura del tasto nella routine originale. L’oracolo inietta sopra questa routine.',
    0xA7D4: 'Un nome comune prosegue verso la selezione dell’articolo. Un nome proprio segue il ramo separato.',
    0xA809: 'La richiesta 6BB7 del cocchiere non percepibile chiama A887 con SP 5D38. Il ritorno A80C sostituisce HL del precedente scorrimento a 5D36–5D37.',
    0xA827: 'Il nome del cocchiere fuori scena salva la posizione della word articolo. Con la classe nominale di cabbie e il canale superiore, HL=A24E e occupa 5D38–5D39.',
    0xA887: 'Il flag 5C3C è zero per la richiesta fuori scena: A88B ritorna prima di invocare il renderer.',
    0xA9D7: 'I nomi propri di stanza negli ingressi brevi e le direzioni lessicali dei passaggi scrivono i caratteri grezzi. Entranc(e) lascia il byte a 5C12 e northeas(t) a 5C13.',
    0xA9DF: 'Prima dello scarico salva il descrittore DE. Nel punto di 7611 lascia il descrittore finale 383E a 5D4E–5D4F.',
    0xA9EC: 'Salva AF dal confronto tra spazio residuo e lunghezza della parola a 5D4C–5D4D.',
    0xA9F4: 'Il punto di 7611 viene scaricato con BC esterno a zero, salvato a 5D4A–5D4B.',
    0xA9FD: 'La chiamata di AA14 lascia AA00 a 5D48–5D49, anche quando C1E1 non disegna pixel.',
    0xAE86: 'Conserva la classe D precedente mentre rilegge il token. Il delimitatore B0 del WAIT resta osservabile nella successiva estrazione della cuoca.',
    0xB04D: 'Inserisce TALK ($088B) quando si entra dalla virgoletta senza verbo. Una frase nominale autonoma può produrre un argomento di TALK.',
    0xB3DA: 'Azzera il selettore prima della ricerca controllata. Questa scrittura non riguarda la classe del token precedente.',
    0xB8D3: 'La citazione riuscita alloca otto byte di richiesta. I campi +05/+06 puntano alla lista sintattica e +07 contiene il modo.',
    0xB635: 'B649 e B658 ricevono entrambi 20 per il rifiuto del primo argomento o 28 per il secondo. JavaScript conserva lo slot semantico. Il giardiniere legge B649 sabato alle 02:15.',
    0xB934: 'Due byte indipendenti. Il primo è l’opcode di un ordine attivo, il secondo è l’ultimo opcode del tentativo di consegna.',
    0xB93B: 'Salva l’opcode DOMAIN di qualunque tentativo di consegna. Ultimo B935=83 per il cocchiere martedì alle 09:15.',
    0xB953: 'Copia l’opcode in B934 solo per la richiesta con un nodo sintattico. L’ordine prefabbricato e l’affermazione biforcano prima.',
    0xCC89: 'Azzera B934 all’ingresso nell’interprete, ma non B935. Watson legge zero qui giovedì alle 23:33.',
    0xC18B: 'Scrive 78 per la prima cella. LDIR la replica in tutta la striscia 5A40–5A5F, distinta dal normale PAPER 7 con BRIGHT spento. Il giardiniere legge 78 venerdì alle 09:50.',
    0xC1A8: 'Parte a x=8 (5041). Lo spazio iniziale avanza di sette pixel. Il giorno parte a x=15; quello finale lascia visibili le celle successive del motivo grafico.',
    0xC271: 'Pulizia della riga bassa a celle di sette pixel. L’ultima cella ha x=246 e indirizzo video 50FE; non coincide con l’origine della stampa alta.',
    0xC293: 'Nel rifiuto di EXAMINE ROCK si osservano due profondità: 5D38 lascia AF, BC e HL a 5D2C–5D31. Il frame 5D3E lascia AF e BC a 5D32–5D35. HL a 5D36–5D37 può essere sovrascritto da chiamate successive.',
    0xC398: 'Lo spazio dopo plain lascia L e H di HL a 5D2A/B nel frame 5D32. Nella lista di persone, il clear dopo wall lascia H a 5D17 prima della congiunzione and.',
    0xC3B7: 'La o di to nella richiesta di pagamento 6BB7 conserva C a 5D1A nel frame 5D24. C deriva dalla colonna del glifo.',
    0xC3B8: 'Lo stesso glifo conserva a 5D19 l’ultima riga del font prima della rotazione, indipendente dall’offset C.',
    0xCE4A: 'Scrive il secondo operando risolto a A035; FF è il segnaposto originale per il parametro assente, non un valore di ripiego. Il giardiniere lo legge a 14:29 durante F19A.',
    0xCE59: 'Per una regola DOMAIN A033 è FF; per un’azione viene scritto il suo ID da un ingresso distinto.',
    0xD008: 'Ricarica gli argomenti dal contesto sospeso o dal record attore.',
    0xD03E: 'Il ritorno da un contesto può salvare nella riga di Watson il puntatore alla richiesta del cocchiere. La struttura della coda influisce sullo stato di un altro NPC.',
    0xD64D: 'La parola della direzione resta in attesa fino alla stampa di there is. Se va a capo, C374 pulisce la riga nel frame 5D22 e salva AF a 5D16/17.',
    0xD658: 'L’articolo del nome comune scarica is nel frame 5D24, dopo il ritorno a capo della direzione. C3B8 salva un nuovo AF a 5D18/19.',
    0xD2D3: 'Il salvataggio di HL segue la coppia di letture e precede il confronto con il seed. Vale anche quando la scelta ripete il tentativo.',
    0xD3E8: 'Nel nome del cocchiere fuori scena salva AF con A=ID dell’attore e F dal lookup A4BC, a 5D3E–5D3F. D3E9 salva il relativo del testo a 5D3C–5D3D.',
    0xD442: 'CALL del formatter del sostantivo. Nel nome del cocchiere fuori scena, lascia il ritorno D445 a 5D3A–5D3B.',
    0xD89B: 'All’ingresso del prompt carica 0BB8 (3000) prima di leggere il tasto.',
    0xDFD7: 'Confronta la stanza di Holmes con quella di Basil. Se coincidono seleziona il testo 75D2, altrimenti 759C.',
    0xDFDD: 'Ramo osservato nella camera di Basil mercoledì alle 06:07 con seed 1. 9E74 stampa e termina la partita.',
    0xE6CC: 'Nella richiesta fuori scena del mercoledì alle 10:17, il renderer resta spento. Il lookup dell’articolo conserva comunque A80C a 5D36–5D37. 6BB7 stampa la richiesta di pagamento. La chiamata del nome del destinatario scarica il precedente to.',
    0xE725: '6C54 fuori scena conserva il ritorno A80C dell’articolo nello slot 5D44–5D45, sostituendo il D445 della richiesta precedente. E729 ripristina il flag 5C3C.',
    0xEBC5: 'Lestrade aspetta che il proprio veicolo soddisfi la condizione di posizione. Nel ramo passivo osservato resta in questo punto.',
    0xEFC9: 'Controlla la stanza del giocatore. Le stanze 33–39 abilitano il selettore DFCC. Fuori dall’intervallo aggiorna lo stato di Basil.',
    0xEF90: 'DOMAIN 03 A8 E5 attende un tick. 0E 90 EF salta di nuovo a EF90. Nella variante passiva Basil resta qui anche la settimana seguente.',
}
output = project / 'sherlock-js/results/brown-to-ending'
lines = ['; Dossier verificato sul payload originale.']
count = total = 0
for start, end, kind, label in regions:
    lines.extend(['', f'    ORG ${start:04X}', f'; {"BYTECODE" if kind == "domain" else kind.upper()}: {label}'])
    at = start
    while at < end:
        if kind in ('data', 'domain'):
            size = min(end - at, 3)
            op = 'DEFB ' + ','.join(f'${value:02X}' for value in memory[at:at+size])
        else:
            op, size = disassemble(memory, at)
            count += 1
        assert at + size <= end, (hex(at), op)
        assert bytes(assembler.assemble(op, at)) == memory[at:at+size]
        note = ' | ' + notes[at] if at in notes else ''
        lines.append(f'    {op:<37} ; ${at:04X} {memory[at:at+size].hex(" ")}{note}')
        at += size
        total += size
(output / 'brown-to-ending.asm').write_text('\n'.join(lines) + '\n')
(output / 'listing-verification.json').write_text(json.dumps(dict(
    roundtrip_equal=True, instructions=count, bytes_roundtripped=total, regions=[
        dict(start=f'{a:04X}', end_exclusive=f'{b:04X}', kind=kind, label=label, atlas_priority=188)
        for a, b, kind, label in regions
    ],
), ensure_ascii=False, indent=2) + '\n')
print(count, total)
