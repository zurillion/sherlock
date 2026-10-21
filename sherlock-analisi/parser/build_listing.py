#!/usr/bin/env python3
"""Listing con intervalli codice/dati espliciti e verifica byte per byte."""
import argparse
import json
from pathlib import Path
from parser_audit import Audit

# Gli estremi destri sono esclusivi. Non si decodificano tabelle come Z80.
REGIONS = [
 (0x6859,0x686A,'data'), (0xA536,0xA55D,'code'),
 (0xA85C,0xA880,'data'), (0xA887,0xA9B5,'code'),
 (0xAAA1,0xAAB2,'data'), (0xAAB2,0xAF6B,'code'),
 (0xAF6B,0xAFB3,'data'), (0xAFB3,0xB16D,'code'),
 (0xB191,0xB1AB,'code'), (0xB84C,0xB863,'code'),
 (0xC1E1,0xC1F4,'code'), (0xC1F4,0xC1FC,'data'), (0xC1FC,0xC249,'code'),
 (0xD6B8,0xD6C1,'data'), (0xD6C1,0xD714,'code'),
 (0xD714,0xD719,'data'), (0xD719,0xD769,'code'),
 (0xD769,0xD76D,'data'), (0xD76D,0xD77E,'code'), (0xD77E,0xD780,'data'),
 (0xD780,0xD7D9,'code'), (0xD7D9,0xD7DD,'data'), (0xD7DD,0xD7E0,'code'),
 (0xD7E0,0xD7E1,'data'), (0xD7E1,0xD7FA,'code'), (0xD7FA,0xD7FC,'data'),
 (0xD7FC,0xD897,'code'), (0xD897,0xD898,'data'), (0xD898,0xD9C3,'code'),
 (0xD9C3,0xD9C5,'data'), (0xD9C5,0xDA32,'code'), (0xDA32,0xDA34,'data'),
 (0xDA34,0xDB64,'code'), (0xDB64,0xDB67,'data'), (0xDB67,0xDC13,'code'),
 (0xDC13,0xDC15,'data'), (0xDC15,0xDC18,'code'),
]
COMMENTS = {
 0x6859: 'Frase compressa: I do not know the word + virgoletta.',
 0x6866: 'Frase compressa: What ? + CR.',
 0xA536: 'Lettura tasto con timeout; zero = nessun comando. Iniettata nelle prove.',
 0xA85C: 'Nove suffissi da quattro byte; maiuscoli. Il backspace e un byte 08.',
 0xA887: 'Stampa parola: rispetta 5C3C. Foggy London modifica A88B, qui NON modificato.',
 0xA92F: 'Appende quattro byte di suffisso, senza applicare backspace o lowercase.',
 0xA94D: 'Decomprime record e appende suffisso; HL avanza al record successivo.',
 0xA95B: 'Decompressione incrementale in 5C42; prima lettera implicita.',
 0xAAA1: 'Variabili di backtracking e scratch del parser; NON istruzioni.',
 0xAAB2: 'Parser: inizializza stato e lista di comandi.',
 0xAABD: 'Inizio nuovo nodo della lista; conserva parte dei flag E.',
 0xAB11: 'Cerca gruppo verbale, poi gruppi nominali.',
 0xAB43: 'A=2: caso speciale/vuoto, distinto dall errore A=1.',
 0xAB91: 'Gruppo verbale: classi 30,40,20,00; E0 saltata.',
 0xABB5: 'Carry: combinazione verbale non ammessa.',
 0xABF3: 'Modo 2: confronta riferimenti con tabella 994D.',
 0xAC24: 'Gruppo nominale: scratch di 10 byte AAA8..AAB1.',
 0xAC37: 'Articolo classe80: massimo uno nel contesto corrente.',
 0xAC49: 'Classi10/70: relazioni/preposizioni, NON nomi comuni.',
 0xAC65: 'Classe60: fino a due qualificatori, prima del nome.',
 0xAC78: 'Classe50 o literal F0: referente centrale del gruppo.',
 0xAC8F: 'Inserimento in due slot da 16 bit a AAA8.',
 0xAC94: 'Inserimento in due slot da 16 bit a AAAE.',
 0xACA6: 'Copia gruppo nominale nei campi +04 o +0E del nodo.',
 0xACCC: 'Separatore A0: coordinazione e salvataggio per backtracking.',
 0xACFB: 'Nuovo verbo dopo coordinazione: puo rinviare il resto al ciclo seguente.',
 0xAD57: 'Fine unita sintattica / coordinazione.',
 0xADD4: 'Post-elaborazione lista, eredita campi tra gruppi coordinati.',
 0xAE57: 'Successo: A=0 e Z=1.',
 0xAE6A: 'Alloca nodo di 30 byte con A11C; link a IY-2.',
 0xAE7F: 'Legge token da A02B, salva inizio in A029; classe in A/D, valore BC.',
 0xAF67: 'Errore sintattico: A=1, NZ.',
 0xAF6B: '12 coppie LE (riferimento parola, handler) per classe90, modo normale.',
 0xAF9B: '6 coppie per classe90 nel modo2; tabella, NON codice Z80.',
 0xAFB3: 'Dispatch classe90 per valore BC; offset0 indica virgoletta.',
 0xB049: 'Virgolette: registra puntatore a contenuto; verbo implicito TALK (SAY e alias) se necessario.',
 0xB092: 'La virgoletta finale nel token stream diventa C0 per analisi differita.',
 0xB0AC: 'LOAD/QUIT: modifica stato di controllo; prove si fermano prima.',
 0xB0C6: 'SAVE: modifica stato di controllo; prove si fermano prima.',
 0xB135: 'HE: attiva modo2 e flag nel campo +19.',
 0xB151: 'IT/THEY: attiva modo2 e flag nel campo +19.',
 0xB191: 'Ingresso fase successiva; mostrato solo il raccordo con errore verbo.',
 0xB1A1: 'Ricerca forma verbale nel livello successivo, non lexer.',
 0xB1A6: 'Restituisce handler B84C se la ricerca fallisce.',
 0xB84C: 'Prepara 4 argomenti e stampa I do not know the verb (686A).',
 0xC1E1: 'Router di stampa: 5C3C abilita; A027 sceglie canale.',
 0xC1F4: 'Stato cursore del canale inferiore, NON codice.',
 0xC1FD: 'Stampa nel canale inferiore; CR/backspace e conversione maiuscolo.',
 0xC240: 'Conversione ASCII a-z -> A-Z.',
 0xD6B8: 'Stato e puntatori di controllo; D6BD = cursore token.',
 0xD6C1: 'Ingresso lettura comando.',
 0xD6CE: 'Preflight lessicale su intera riga: ripete D9C5 fino a C0/D0.',
 0xD6E0: 'Errore: HL=handler D6E5 e Z=1 per il chiamante/interprete.',
 0xD6E5: 'Errore lessicale nel canale inferiore: template 6859 + parola digitata.',
 0xD6F5: 'A029 punta alla prima parola non riconosciuta.',
 0xD714: 'Flag; seguono 4 byte record di script 40 00 CE D6.',
 0xD719: 'Tokenizza nuovamente riga in 5B81, dopo il preflight.',
 0xD751: 'Valore BC serializzato big-endian; il nodo AST usa invece little-endian.',
 0xD769: 'Record di script 40 00 70 D7; NON LD B,B e altre false istruzioni.',
 0xD770: 'Verifica se ci sono token da analizzare.',
 0xD77E: 'Due byte di stato.',
 0xD780: 'Wrapper sintassi: modo1, cursore A02B, chiamata AAB2.',
 0xD79F: 'Successo: passa lista da 9FF0 a 9FF2.',
 0xD7B2: 'Fallimento/caso speciale: libera liste temporanee.',
 0xD7BA: 'A=2 non produce What?; A=1 produce errore generico.',
 0xD7BE: 'A027=1, stampa 6866 What?, poi ripristina canale.',
 0xD7D9: 'Record di script 40 00 E1 D7; NON codice macchina.',
 0xD7E0: 'Flag di stato.',
 0xD7FA: 'Due byte di stato.',
 0xD7FC: 'Confine delle prove: prima di eseguire il livello semantico B191.',
 0xD87D: 'Libera lista a 9FF0.', 0xD88A: 'Libera lista a 9FF2.',
 0xD897: 'Stato virgolette: 1 fuori, 0 dentro.',
 0xD898: 'Editor: timeout e selezione canale inferiore.',
 0xD8AD: 'Stampa prompt > e spazio.',
 0xD8B7: 'Buffer testo 5B00, capacita nominale 80 esadecimale.',
 0xD8C3: 'Chiama lettura tasto A536.',
 0xD949: 'Invio: chiude virgolette aperte, aggiunge punto se manca e CR.',
 0xD95C: 'Chiusura automatica citazione.',
 0xD968: 'Aggiunge punto solo se non presente.',
 0xD978: 'Tasti direzione all inizio: 09=E,08=W,0A=S,5B=N; poi Invio.',
 0xD99E: 'Gestione @ all inizio; ripetizione/stato da approfondire separatamente.',
 0xD9B7: 'Cancella riga con backspace.',
 0xD9C3: 'Puntatore al candidato lessicale.',
 0xD9C5: 'Lexer: salta spazi, riconosce CR/punteggiatura/numeri/parole.',
 0xD9F5: 'Decomprime candidato in 5C42.',
 0xD9F8: 'Scarta record classe D0 anche se presenti nei testi del gioco.',
 0xDA12: 'Accetta se prefisso >=4 oppure coincide con intera lunghezza input.',
 0xDA21: 'Restituisce classe del record canonico e offset rispetto a 5DBF.',
 0xDA32: 'Fine del gruppo alfabetico corrente.',
 0xDA34: 'Indice iniziale a 5D80; ricostruzione input minuscolo a 5C0B.',
 0xDA7D: 'Confronto prefissi: aggiorna anche in parita; si ferma quando peggiora.',
 0xDAAD: 'Segue rimandi sinonimi finche descriptor bit7=0.',
 0xDAC6: 'Token speciali: punto B0, virgola A0, virgoletta90, numeri/F0.',
 0xDAE8: 'Test cifra ASCII.', 0xDAEF: 'Numero: riconosce orario o valuta.',
 0xDB05: 'Ora/minuti: valori <60; flag AM/PM.',
 0xDB4F: 'Numero/formato invalido -> D0, stesso errore lessicale delle parole.',
 0xDB60: 'Ritorna literal F0.',
 0xDB64: 'Tre byte temporanei: pounds/shillings/pence.',
 0xDB67: 'Prefisso 60, simbolo sterlina nel set Spectrum (backtick in ASCII).',
 0xDBC0: 'Converte valuta in pence: (pounds*20+shillings)*12+pence.',
 0xDBF7: 'Legge cifre nel registro B a 8 bit; non intero Python arbitrario.',
 0xDC13: 'Lunghezza input e miglior prefisso: due byte di stato.',
 0xDC15: 'Ritorno falso comune: A=0, HL=0.',
}

def build(project, output):
    audit = Audit(project)
    from skoolkit.traceutils import disassemble
    from skoolkit.z80 import Assembler
    asm = Assembler()
    mem = audit.decoder.mem
    lines = ['; Sherlock Spectrum v2.0 - parser: estratti verificati',
             '; Indirizzi assoluti. Dati intercalati emessi come DEFB, non disassemblati.',
             '; Etichette/commenti sono interpretazioni; i byte sono quelli del payload.', '']
    count = byte_count = 0
    for start, end, kind in REGIONS:
        lines += ['', f'    ORG ${start:04X}', f'; {kind.upper()} ${start:04X}..${end-1:04X}']
        p = start
        while p < end:
            if p in COMMENTS:
                lines += ['', '; ' + COMMENTS[p]]
            if kind == 'code':
                op, size = disassemble(mem, p)
                count += 1
            else:
                boundaries = [c for c in COMMENTS if p < c < min(end, p+8)]
                size = min([end, p+8] + boundaries) - p
                op = 'DEFB ' + ','.join(f'${b:02X}' for b in mem[p:p+size])
            assert p+size <= end, (hex(p), op, hex(end))
            encoded = bytes(asm.assemble(op, p))
            assert encoded == mem[p:p+size], (hex(p), op, encoded.hex())
            raw = mem[p:p+size].hex(' ').upper()
            lines.append(f'    {op:<25} ; ${p:04X}  {raw}')
            byte_count += size
            p += size
    output.mkdir(parents=True, exist_ok=True)
    (output/'parser.asm').write_text('\n'.join(lines)+'\n')
    result = {'regions': [{'start': f'{a:04X}', 'end_exclusive': f'{b:04X}', 'kind': k} for a,b,k in REGIONS],
              'instructions': count, 'bytes_roundtripped': byte_count, 'mismatches': 0,
              'note': 'Roundtrip prova fedelta dei byte, non da solo la correttezza delle etichette codice/dati.'}
    (output/'listing-verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'instructions': count, 'bytes': byte_count, 'mismatches': 0}))

if __name__ == '__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    p.add_argument('--output',type=Path,default=Path(__file__).resolve().parent)
    args=p.parse_args();build(args.project,args.output)
