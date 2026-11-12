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
    (0x9E74, 0x9E85, 'code', 'Stampa, pausa e chiusura del finale'),
    (0xA02D, 0xA02E, 'data', 'Classe del token precedente'),
    (0xA02E, 0xA02F, 'data', 'Selettore nominale'),
    (0xA4CD, 0xA536, 'code', 'Ricerca e selezione del riferimento nominale'),
    (0xA9D7, 0xA9DF, 'code', 'Scrittura della parola grezza nel buffer'),
    (0xAE7F, 0xAEA9, 'code', 'Lettura dei token e salvataggio della classe precedente'),
    (0xB049, 0xB09A, 'code', 'Verbo TALK implicito e delimitatore di citazione'),
    (0xB3B6, 0xB3FD, 'code', 'Inizializzazione della ricerca nominale'),
    (0xB8AA, 0xB904, 'code', 'Analisi della citazione e coda delle richieste'),
    (0xC271, 0xC29C, 'code', 'Ultima cella della pulizia della console'),
    (0xC388, 0xC3E4, 'code', 'Indirizzo video, shift e scansione del glifo'),
    (0xD008, 0xD045, 'code', 'Ripristino e salvataggio del contesto NPC'),
    (0xD3D5, 0xD448, 'code', 'Descrittori dei nomi nelle liste'),
    (0xDFCC, 0xDFE3, 'code', 'Finale selezionato dalla presenza di Basil'),
    (0xE6BE, 0xE6E6, 'code', 'Stampa della richiesta di pagamento del cocchiere'),
    (0xEBC5, 0xEBCB, 'domain', 'Lestrade: attesa della posizione del veicolo'),
    (0xEF90, 0xEF96, 'domain', 'Basil fuori scena: attesa e salto all’indietro'),
    (0xEFC7, 0xEFC9, 'data', 'Intestazione della regola di Basil'),
    (0xEFC9, 0xEFF6, 'code', 'Controllo della posizione di Holmes nella casa di Basil'),
]
notes = {
    0x9E7C: 'Pausa dopo il testo terminale. La conferma precede il passaggio alla chiusura B0AC.',
    0xA02D: 'Classe precedente, salvata da AE86. Il WAIT controllato lascia B0, anche dopo il consumo del delimitatore.',
    0xA02E: 'Il valore è separato da A02D. B3DA lo inizializza e A4EB lo seleziona in base all’intestazione nominale.',
    0xA4EB: 'Ultima scrittura del selettore per il WAIT UNTIL dal tick 3781. La cuoca lo legge al tick 4070.',
    0xA9D7: 'I nomi propri di stanza negli ingressi brevi e le direzioni lessicali dei passaggi scrivono i caratteri grezzi. Entranc(e) lascia il byte a 5C12 e northeas(t) a 5C13.',
    0xAE86: 'Conserva la classe D precedente mentre rilegge il token. Il delimitatore B0 del WAIT resta osservabile nella successiva estrazione della cuoca.',
    0xB04D: 'Inserisce TALK ($088B) quando si entra dalla virgoletta senza verbo. Una frase nominale autonoma può produrre un argomento di TALK.',
    0xB3DA: 'Azzera il selettore prima della ricerca controllata. Questa scrittura non riguarda la classe del token precedente.',
    0xB8D3: 'La citazione riuscita alloca otto byte di richiesta. I campi +05/+06 puntano alla lista sintattica e +07 contiene il modo.',
    0xC271: 'Pulizia della riga bassa a celle di sette pixel. L’ultima cella ha x=246 e indirizzo video 50FE; non coincide con l’origine della stampa alta.',
    0xC293: 'Il frame di pulizia conserva AF di scansione, BC di scansione e HL video a 5D2C–5D31.',
    0xC398: 'Lo spazio dopo plain lascia L e H di HL a 5D2A/B nel frame 5D32. Nella lista di persone, il clear dopo wall lascia H a 5D17 prima della congiunzione and.',
    0xC3B7: 'La o di to nella richiesta di pagamento 6BB7 conserva C a 5D1A nel frame 5D24. C deriva dalla colonna del glifo.',
    0xC3B8: 'Lo stesso glifo conserva a 5D19 l’ultima riga del font prima della rotazione, indipendente dall’offset C.',
    0xD008: 'Ricarica gli argomenti dal contesto sospeso o dal record attore.',
    0xD03E: 'Il ritorno da un contesto può salvare nella riga di Watson il puntatore alla richiesta del cocchiere. La struttura della coda influisce sullo stato di un altro NPC.',
    0xDFD7: 'Confronta la stanza di Holmes con quella di Basil. Se coincidono seleziona il testo 75D2, altrimenti 759C.',
    0xDFDD: 'Ramo osservato nella camera di Basil mercoledì alle 06:07 con seed 1. 9E74 stampa e termina la partita.',
    0xE6CC: '6BB7 stampa la richiesta di pagamento. La chiamata del nome del destinatario scarica il precedente to.',
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
