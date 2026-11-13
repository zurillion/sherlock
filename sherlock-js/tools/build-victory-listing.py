"""Build source annotations for the original evidence and pursuit gates."""
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
instructions = json.loads((project / 'sherlock-js/data/game.json').read_text())['npcPrograms']['instructions']
regions = [
    (0x9965, 0x9973, 'data', 'Prova dell’innocenza del maggiore'),
    (0x9973, 0x9981, 'data', 'Prove del suicidio di Mrs Brown'),
    (0x9981, 0x9997, 'data', 'Prove dell’omicidio di Tricia'),
    (0x9997, 0x99A9, 'data', 'Prove che Basil possiede i piani'),
    (0x99A9, 0x99BB, 'data', 'Prove del luogo della vendita'),
    (0x7DE1, 0x7E0B, 'data', 'Descrizione del cab in viaggio: lampioni oppure sole'),
    (0x9A13, 0x9A3D, 'code', 'Accettazione dei piani subordinata ai due omicidi'),
    (0x9E4A, 0x9E6A, 'code', 'Finale di Victoria: presenza di Watson e Lestrade'),
    (0xA679, 0xA684, 'code', 'Salto relativo terminale del decoder'),
    (0xA6AC, 0xA6D1, 'code', 'Condizione notturna e scansione del token saltato'),
    (0xB049, 0xB09A, 'code', 'Accodamento e ricerca del delimitatore della citazione'),
    (0xB8BE, 0xB90E, 'code', 'Analisi della citazione per TALK e creazione della richiesta'),
    (0xD078, 0xD0DC, 'code', 'Controllo di luce e lampada percepibile'),
    (0xD1B2, 0xD1C6, 'code', 'Descrizione breve e controllo della luce dopo lo spostamento'),
    (0xD68C, 0xD6B8, 'code', 'Uscite generiche e caratteri residui delle direzioni'),
    (0xE0A0, 0xE0A2, 'data', 'Intestazione dell’esame approfondito del ruscello'),
    (0xE0A2, 0xE0AD, 'domain', 'Ritrovamento ed esame del ruscello'),
    (0xE955, 0xE96E, 'domain', 'Lestrade attende l’incontro o l’una di notte'),
    (0xE9A7, 0xE9DB, 'domain', 'Lestrade alterna le sponde durante l’ispezione'),
    (0xEA25, 0xEA5F, 'domain', 'Lestrade attende le due deduzioni prima di partire'),
    (0xEAF6, 0xEAF8, 'data', 'Intestazione della regola del cab di polizia'),
    (0xEAF8, 0xEB11, 'code', 'Cab di polizia e conducente collocati in Main Street'),
    (0xEB11, 0xEB13, 'data', 'Intestazione del predicato sul luogo della vendita'),
    (0xEB13, 0xEB19, 'code', 'Controlla la deduzione sul luogo della vendita'),
    (0xEB19, 0xEB1B, 'data', 'Intestazione del predicato sui piani'),
    (0xEB1B, 0xEB28, 'code', 'Controlla la deduzione sul possesso dei piani'),
    (0xEF7A, 0xEF8C, 'domain', 'Basil a Victoria: incontro con Holmes e finale'),
    (0xF14C, 0xF150, 'domain', 'Il poliziotto prende il cadavere dei Brown'),
]
notes = {
    0x7DE1: 'Il token 17 a 7DF1 condiziona il salto 02 a 7DF2. Di notte termina il frammento corrente a favore del testo dei lampioni a 7DC1.',
    0xA679: 'Sposta il cursore del decoder nel frammento di destinazione e restituisce zero al passo corrente. Il testo del chiamante non riprende dopo il salto.',
    0xA6AC: 'Con classe 1 prosegue nel token successivo. Con le altre classi A6B2 scavalca il salto e rimane nel testo del sole.',
    0xD1B2: 'Ingresso breve di CA9E: chiama D187 direttamente e non ripete l’introduzione del contenitore di D113.',
    0xD1BA: 'Nella notifica di arrivo il controllo di percezione C821 usa ancora A00A della partenza mentre il record della lampada è già nella stanza di arrivo.',
    0x9965: 'La conclusione dipende dalla visita del maggiore alla fumeria. La confessione aggiorna la premessa; Lestrade accetta la deduzione quando può parlarne con Holmes.',
    0x9973: 'Richiede cadavere e ponte esaminati, poi la pietra osservata. La nota sul cadavere è un indizio distinto.',
    0x9981: 'Richiede corpo, libreria e abiti esaminati, più le premesse modificate dalla confessione di Mrs Jones.',
    0x9997: 'Richiede esame di nota incompiuta, cartella, lettere e delle due note cifrate.',
    0x99A9: 'Richiede il presupposto impostato da 9A27, l’esame della nota recuperata dal fuoco e che il conto alla rovescia non l’abbia fatta bruciare.',
    0x9A13: 'Prova entrambe le conclusioni su Mrs Brown e Tricia. Se una manca, il ramo 9A2F ritira l’ipotesi corrente.',
    0x9A27: 'Abilita la premessa della deduzione successiva sul luogo della vendita.',
    0x9E4A: 'Prepara il testo 6B79. Con Watson (3) e Lestrade (2) nella stanza di Holmes seleziona 6AF3.',
    0xB05E: 'Accoda il puntatore prima di trovare il delimitatore. Nel controllo TAKE CLOTHES il nodo sintattico si libera ma la citazione resta in coda.',
    0xB095: 'Il byte del delimitatore trovato diventa C0. Nel controllo con puntatore residuo il lettore ha raggiunto 4D15 nella bitmap superiore.',
    0xB8BE: 'Analizza il testo a partire dal puntatore estratto dalla coda delle citazioni.',
    0xB8D1: 'Dopo un’analisi valida ripristina il delimitatore, poi alloca la richiesta da otto byte.',
    0xB904: 'Il ramo di errore libera la sintassi. La nuova citazione eventualmente accodata da B05E rimane disponibile.',
    0xD09E: 'Scorre le entità dopo il controllo di fascia oraria e cerca una sorgente di luce percepibile.',
    0xD6A6: 'Stampa ogni direzione come parola del dizionario. A414 appende il punto e il buffer trattiene i byte grezzi dopo lo svuotamento.',
    0xE0A2: 'Il ritrovamento richiede la sponda est e il martedì. La selezione dell’argomento 2 deve ammettere Lestrade.',
    0xE955: 'Verifica se Holmes e il maggiore sono insieme. In mancanza dell’incontro, E95B attende l’una del mattino.',
    0xE96B: 'Il selettore controlla se l’innocenza è stata riconosciuta. In questa storia può esserlo anche dopo mezzanotte.',
    0xE9A7: 'Alterna il ruscello e i due attraversamenti. La storia osservata trova Lestrade a est alle 09:31.',
    0xF14C: 'Azione 41 sul cadavere 46. Quando la raccolta avviene, il cadavere segue l’attore 12 e non resta sulla sponda.',
    0xEA2C: 'EB19 prova il flag della conclusione sui piani. Il ramo di fallimento attende e torna a verificare.',
    0xEA31: 'EB11 prova il flag sul luogo della vendita. Il successo passa a EA5B, poi il programma segnala a Straker di partire.',
    0xEAF8: 'Il secondo argomento diventa passeggero del primo. Entrambi ricevono la stanza $32, Main Street.',
    0xEB13: 'Seleziona il fatto 99A9 e riusa il test comune a EB1F.',
    0xEB1B: 'Seleziona il fatto 9997. BIT 1 legge il flag della prova confermata, senza modificare il record.',
    0xEF7A: 'Attiva il percorso verso la locazione $1C, Buckingham Palace Road.',
    0xEF83: 'Confronta la posizione di Basil con l’identità esplicita 0. Il ramo con Holmes presente chiama il selettore 9E48.',
}
output = project / 'sherlock-js/results/victory-route'
output.mkdir(parents=True, exist_ok=True)
lines = ['; Dossier verificato sul payload originale.']
count = total = 0
for start, end, kind, label in regions:
    marker = 'BYTECODE' if kind == 'domain' else kind.upper()
    lines.extend(['', f'    ORG ${start:04X}', f'; {marker}: {label}'])
    at = start
    while at < end:
        if kind == 'code':
            op, size = disassemble(memory, at)
            count += 1
        else:
            size = instructions[f'{at:04X}']['size'] if kind == 'domain' else end - at
            op = 'DEFB ' + ','.join(f'${value:02X}' for value in memory[at:at+size])
        assert at + size <= end, (hex(at), op)
        assert bytes(assembler.assemble(op, at)) == memory[at:at+size]
        note = ' | ' + notes[at] if at in notes else ''
        lines.append(f'    {op:<37} ; ${at:04X} {memory[at:at+size].hex(" ")}{note}')
        at += size
        total += size
(output / 'victory-route.asm').write_text('\n'.join(lines) + '\n')
(output / 'listing-verification.json').write_text(json.dumps(dict(
    roundtrip_equal=True, instructions=count, bytes_roundtripped=total, regions=[
        dict(start=f'{a:04X}', end_exclusive=f'{b:04X}', kind=kind, label=label, atlas_priority=189)
        for a, b, kind, label in regions
    ],
), ensure_ascii=False, indent=2) + '\n')
print(count, total)
