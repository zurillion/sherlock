#!/usr/bin/env python3
"""Stampa tutte le locazioni di Sherlock usando il decoder sherlock_text.py."""
from __future__ import annotations

import argparse
from pathlib import Path
import sys
import textwrap

from sherlock_text import Context, DecodeError, Decoder, number


def format_locations(decoder: Decoder, context: Context, columns: int = 88,
                     only_described: bool = False) -> str:
    records = decoder.locations()
    total_records = len(records)
    if only_described:
        records = [record for record in records if record["description"] is not None]
    descriptions = sum(record['description'] is not None for record in records)
    rule = '=' * columns
    header = [
        ('SHERLOCK — LOCAZIONI CON DESCRIZIONE SPECIFICA' if only_described
         else 'SHERLOCK — CATALOGO COMPLETO DEI RECORD DELLE LOCAZIONI'),
        f'{len(records)} slot: {sum(bool(r["name_hint"]) for r in records)} con nome, '
        f'{descriptions} con descrizione specifica.',
        'I nomi provengono dai campi lessicali: articoli e grammatica possono essere incompleti.',
        '⟦...⟧ indica una parte dinamica, non testo presente nel gioco.',
        ('Fascia oraria non selezionata: le alternative sono annotate.'
         if context.time_class is None else f'Classe temporale selezionata: {context.time_class}.'),
    ]
    if only_described:
        header.insert(2, f'Esclusi {total_records - len(records)} slot con puntatore alla descrizione zero.')
    sections = ['\n'.join(header)]
    for record in records:
        ident = record['id']
        name = record['name_hint'] or '[record senza nome]'
        label = 'SLOT' if not record['name_hint'] else 'LOCAZIONE'
        lines = [rule, f'{label} {ident:03d} — {name}',
                 f'Record: ${record["record"]}', '-' * columns]
        if record['description'] is None:
            lines.append('Nessuna descrizione specifica: il puntatore nel record è zero.')
            if record['name_hint']:
                lines.append('Il gioco può comporre il testo con il nome e le routine generiche.')
            else:
                lines.append('Slot incluso per completezza; non classificato come luogo visitabile.')
        else:
            address = int(record['description'], 16)
            result = decoder.render(address, context)
            lines.extend([f'Descrizione: ${address:04X}', ''])
            # Impaginazione editoriale del catalogo, distinta dalle colonne video.
            for paragraph in result['text'].rstrip('\n').split('\n'):
                lines.append(textwrap.fill(paragraph, width=columns,
                                           break_long_words=False, break_on_hyphens=False)
                             if paragraph else '')
        sections.append('\n'.join(lines))
    return '\n\n'.join(sections) + '\n\n' + rule + '\n'


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path,
                        default=Path(__file__).resolve().parents[2] / 'SHERLOCK.TAP',
                        help='TAP o payload block-10.bin della versione verificata')
    parser.add_argument('--time-class', type=int, choices=range(1, 6),
                        help='1 notte, 2 tramonto, 3 pomeriggio, 4 mattina/giorno, 5 alba; '
                             'omesso = tutte le alternative annotate')
    parser.add_argument('--subject', type=number, help='Valore della cella $A034 (0–255)')
    parser.add_argument('--other', type=number, help='Valore della cella $A036 (0–255)')
    parser.add_argument('--columns', type=int, default=88, help='Larghezza del catalogo, minimo 40')
    parser.add_argument('--only-described', action='store_true',
                        help='Esclude le locazioni con puntatore alla descrizione zero')
    parser.add_argument('-o', '--output', type=Path,
                        help='Salva in UTF-8 anziché stampare sul terminale')
    args = parser.parse_args()
    try:
        if args.columns < 40:
            raise DecodeError('--columns deve essere almeno 40')
        if any(value is not None and not 0 <= value <= 255 for value in (args.subject, args.other)):
            raise DecodeError('--subject e --other devono essere byte fra 0 e 255')
        decoder = Decoder.load(args.source)
        context = Context(subject=args.subject, other=args.other, time_class=args.time_class)
        catalog = format_locations(decoder, context, args.columns,
                                   only_described=args.only_described)
        if args.output:
            args.output.write_text(catalog, encoding='utf-8')
            print(f'Catalogo salvato: {args.output.resolve()}', file=sys.stderr)
        else:
            sys.stdout.write(catalog)
    except (DecodeError, OSError) as exc:
        parser.exit(2, f'Errore: {exc}\n')


if __name__ == '__main__':
    main()
