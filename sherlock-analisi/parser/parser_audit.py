#!/usr/bin/env python3
"""Prove riproducibili sul parser originale di Sherlock Spectrum v2.0.
Nessuna patch alle istruzioni del gioco; solo iniezione dei tasti e osservazione.
"""
from __future__ import annotations
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import random
import re
import sys
import subprocess
from types import SimpleNamespace

sys.dont_write_bytecode = True

def save_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')

class Audit:
    def __init__(self, project):
        self.project = Path(project).resolve()
        self.analysis = self.project / 'sherlock-analisi'
        sys.path[:0] = [str(self.project / 'skoolkit-10.1'), str(self.analysis / 'decoder')]
        from sherlock_text import Decoder
        from dictionary_lookup import DictionaryLookup
        from skoolkit.snapshot import Snapshot
        from skoolkit.simulator import Simulator
        from skoolkit.simutils import from_snapshot
        self.decoder = Decoder.load(self.analysis / 'block-10.bin')
        self.lookup = DictionaryLookup(self.decoder)
        self.Snapshot, self.Simulator, self.from_snapshot = Snapshot, Simulator, from_snapshot
        self.entry = Snapshot.get(str(self.analysis / 'game-entry.z80'))
        sim = from_snapshot(Simulator, self.entry)
        assert bytes(sim.memory[0x5D80:]) == self.decoder.mem[0x5D80:]
        self.prompt = None

    @staticmethod
    def word(mem, address):
        return mem[address] | mem[address + 1] << 8

    @staticmethod
    def save_snapshot(sim, path):
        from skoolkit.snapshot import write_snapshot
        from skoolkit.simutils import get_state
        ram, regs, state, machine = get_state(sim)
        write_snapshot(str(path), ram, regs, state, machine)

    def boot(self, path):
        from skoolkit.simutils import A, PC, SP
        sim = self.from_snapshot(self.Simulator, self.entry)
        sim.set_tracer(SimpleNamespace(border=7, outfe=7))
        r, mem = sim.registers, sim.memory
        boot_key_returns = []
        for steps in range(3_000_000):
            pc = r[PC]
            if pc == 0xA536:
                break
            if pc == 0xC415:
                # N alla domanda grafica e alla pausa di pagina; esegue il RET originale.
                r[A], r[PC] = ord('N'), 0xC41E
                boot_key_returns.append(f'{self.word(mem, r[SP]):04X}')
            sim.opcodes[mem[r[PC]]]()
        else:
            raise RuntimeError(f'Avvio non completato: PC={r[PC]:04X}')
        assert boot_key_returns == ['A051', 'C30F'], boot_key_returns
        self.save_snapshot(sim, path)
        self.prompt = self.Snapshot.get(str(path))
        return {'instructions': steps, 'boot_keys': ['N'] * len(boot_key_returns), 'boot_key_return_addresses': boot_key_returns, 'pc': 'A536',
                'game_clock': self.word(mem, 0x9FDD),
                'free_list': f'{self.word(mem, 0x9FE3):04X}'}

    def new_sim(self):
        if self.prompt is None:
            raise RuntimeError('Eseguire boot prima delle prove')
        sim = self.from_snapshot(self.Simulator, self.prompt)
        sim.set_tracer(SimpleNamespace(border=7, outfe=7))
        return sim

    def native_lookup(self, text):
        from skoolkit.simutils import A, B, C, H, L, SP, PC
        text = text.upper()
        if not text or len(text) > 32 or not text.isascii() or any(ord(c) < 32 for c in text):
            raise ValueError('Attesa una parola/literal ASCII di 1–32 caratteri')
        sim = self.new_sim()
        mem, r = sim.memory, sim.registers
        data = text.encode('ascii') + b' .\r'
        mem[0x5B00:0x5B00 + len(data)] = data
        r[H], r[L], r[SP], r[PC] = 0x5B, 0, 0x5D7E, 0xD9C5
        mem[0x5D7E:0x5D80] = [8, 0]  # ritorno sentinella, non eseguito
        for steps in range(50_000):
            if r[PC] == 8:
                break
            sim.opcodes[mem[r[PC]]]()
        else:
            return {'input': text, 'status': 'instruction_limit', 'pc': f'{r[PC]:04X}'}
        offset = r[B] * 256 + r[C]
        word = self.decoder.words.get(offset)
        return {'input': text, 'status': 'returned', 'type': f'{r[A]:02X}',
                'offset': f'{offset:04X}', 'word': word.stem if word else None,
                'next_input': f'{r[H] * 256 + r[L]:04X}', 'instructions': steps}

    def tokens(self, data):
        result = []
        i = 0
        while i < len(data):
            start = i
            kind = data[i]
            i += 1
            item = {'address': f'{0x5B81 + start:04X}', 'type': f'{kind:02X}'}
            if kind < 0x80 or kind in (0x90, 0xE0, 0xF0):
                if i + 2 > len(data):
                    raise RuntimeError('Token troncato')
                value = data[i] * 256 + data[i + 1]
                item['value'] = f'{value:04X}'
                if kind != 0xF0 and value in self.decoder.words:
                    item['word'] = self.decoder.words[value].stem
                i += 2
            item['bytes'] = bytes(data[start:i]).hex(' ')
            result.append(item)
            if kind == 0xC0:
                return result
        raise RuntimeError('Token di fine assente')

    def command(self, command, snapshot=None):
        from skoolkit.simutils import A, F, PC, SP
        if not command.isascii() or len(command) > 70 or any(ord(c) < 32 for c in command):
            raise ValueError('Prova limitata a 70 caratteri ASCII stampabili; invio aggiunto dal tool')
        sim = self.new_sim()
        mem, r = sim.memory, sim.registers
        keys = list(command.upper().encode()) + [13]
        output, trace, token_stream, nodes = [], [], [], []
        initial_clock = self.word(mem, 0x9FDD)
        initial_upper = bytes(mem[0x4000:0x5000])
        lex_error = syntax_error = False
        stop = None
        watched = {0xD6CE, 0xD6E5, 0xD719, 0xD780, 0xAAB2, 0xAF67, 0xAE57, 0xD7B2}
        control_stops = {0xB0AC: 'load_or_quit', 0xB0C6: 'save', 0xC415: 'pause_or_key_wait',
                         0xC03B: 'print', 0xA296: 'noprint'}
        for steps in range(1_000_000):
            pc = r[PC]
            if pc == 0xA536:
                if not keys:
                    stop = 'input_again'
                    break
                r[A], r[F] = keys.pop(0), 0  # nonzero tasto; Z=0, C=0
                r[PC] = self.word(mem, r[SP])
                r[SP] += 2
                continue
            if pc == 0xD7FC:
                stop = 'before_semantics'
                break
            if pc in control_stops:
                stop = 'control_command:' + control_stops[pc]
                break
            if pc == 0xC1FD:
                # C240 converte a-z in A-Z prima del glifo. Conserva CR/backspace.
                c = r[A]
                output.append(c - 32 if 97 <= c <= 122 else c)
            if pc in watched:
                trace.append(f'{pc:04X}')
            if pc == 0xD6E5:
                lex_error = True
            if pc == 0xD7C3:
                syntax_error = True
            if pc == 0xD780:
                token_stream = self.tokens(mem[0x5B81:0x5BE1])
            sim.opcodes[mem[r[PC]]]()
        else:
            stop = 'instruction_limit'
        p, seen = self.word(mem, 0x9FF2), set()
        while p and p not in seen and len(nodes) < 40:
            seen.add(p)
            nodes.append({'address': f'{p:04X}', 'bytes': bytes(mem[p:p+30]).hex(' '),
                          'words_le': [f'{self.word(mem, q):04X}' for q in range(p, p+30, 2)]})
            p = self.word(mem, p-2)
        if snapshot:
            self.save_snapshot(sim, snapshot)
        outcome = 'lexical_error' if lex_error else 'syntax_error' if syntax_error else stop
        return {'input': command, 'outcome': outcome, 'stop': stop, 'pc': f'{r[PC]:04X}',
                'editor_buffer': bytes(mem[0x5B00:0x5B81]).split(b'\r')[0].decode('latin1'),
                'lower_output': bytes(output).decode('latin1'), 'trace': trace,
                'tokens_before_parser': token_stream, 'command_nodes': nodes,
                'next_token_pointer': f'{self.word(mem, 0xD6BD):04X}',
                'clock_before': initial_clock, 'clock_after': self.word(mem, 0x9FDD),
                'upper_bitmap_unchanged': initial_upper == bytes(mem[0x4000:0x5000]),
                'instructions': steps}

    def dictionary(self):
        rows = []
        for word in self.decoder.words.values():
            canonical = self.lookup.canonical(word)
            try:
                recognition = self.lookup.lookup(word.stem)
            except ValueError as exc:
                recognition = {'not_modelled': str(exc)}
            rows.append({'offset': f'{word.offset:04X}', 'address': f'{word.address:04X}',
                         'stem': word.stem, 'output_inflected': self.decoder.inflected(word),
                         'class': f'{word.flags & 0xF0:02X}', 'suffix_code': f'{word.flags & 15:X}',
                         'descriptor': f'{word.descriptor:02X}',
                         'prefix_length_excluding_initial': (word.descriptor >> 4) & 7,
                         'new_letters': word.descriptor & 15,
                         'alias_direct': f'{int.from_bytes(word.extra, "little"):04X}' if word.extra else None,
                         'canonical_offset': f'{canonical.offset:04X}', 'canonical_stem': canonical.stem,
                         'recognition_of_stem': recognition,
                         'raw_bytes': self.decoder.mem[word.address:word.next_address].hex(' ')})
        return rows

    def build(self, output):
        output.mkdir(parents=True, exist_ok=True)
        boot = self.boot(output / 'prompt.z80')
        dictionary = self.dictionary()
        save_json(output / 'dictionary.json', dictionary)
        foggy_path = self.project / 'Foggy London/Dictionary.txt'
        source_rows = {}
        for line in foggy_path.read_text().splitlines():
            match = re.match(r'^([0-9A-F]{4})\s+(\S+)\s+(\S+)(?:\s+==>\s+\(([0-9A-F]{4})\))?', line)
            if match:
                off, spelling, label, alias = match.groups()
                source_rows[off] = (spelling.split('-')[0].lower(), label, alias)
        assert set(source_rows) == {row['offset'] for row in dictionary}
        labels = {}
        for row in dictionary:
            stem, label, alias = source_rows[row['offset']]
            assert (stem, alias) == (row['stem'], row['alias_direct'])
            labels.setdefault(row['class'], set()).add(label)
        save_json(output / 'foggy-comparison.json', {
            'source': str(foggy_path.relative_to(self.project)), 'records': len(source_rows),
            'stem_and_alias_mismatches': 0,
            'labels_by_native_class': {k: sorted(v) for k,v in labels.items()},
            'suffix_warning': 'CARRY-[BS]IESD nel dump include D del suffisso successivo. Il suffisso originale 3 occupa quattro byte: 08 49 45 53.',
        })
        txt = ['OFFSET ADDR CLASS STEM             VARIANTE-OUTPUT    ALIAS CANONICO']
        for row in dictionary:
            txt.append(f"{row['offset']}   {row['address']} {row['class']}    {row['stem']:<16} {row['output_inflected']:<18} {row['alias_direct'] or '-':<5} {row['canonical_stem']}")
        (output / 'dictionary.txt').write_text('\n'.join(txt) + '\n')
        cases = {'LOOK': 'before_semantics', 'XYZZY': 'lexical_error', 'TAKE XYZZY': 'lexical_error',
                 'THE': 'syntax_error', 'BOOK': 'syntax_error', 'TAKE TAKE': 'syntax_error',
                 'TAKE THE THE BOOK': 'syntax_error', 'TAKE BOOK BOOK BOOK': 'syntax_error',
                 'THE TAKE BOOK': 'syntax_error', 'GO NORTH NORTH': 'syntax_error',
                 'LOOK 60': 'lexical_error', 'TELL WATSON "XYZZY"': 'lexical_error',
                 'ABOVE': 'lexical_error', 'ASKS': 'lexical_error',
                 'TAKE BOOK': 'before_semantics', 'TAKE BOOKS': 'before_semantics',
                 'TAKE THE': 'before_semantics', 'TAKE THE BOOK': 'before_semantics',
                 'TAKE HEAVY BOOK': 'before_semantics', 'TAKE BOOK GUN': 'before_semantics',
                 'TAKE 12:30': 'before_semantics', 'TAKE BOOK AND GUN': 'before_semantics',
                 'TAKE BOOK, DROP BOOK': 'before_semantics', 'LOOK. THE': 'before_semantics',
                 'GIVE BOOK TO WATSON': 'before_semantics', 'TAKE BOOK WITH GUN': 'before_semantics',
                 'LOOK AT BOOK': 'before_semantics', 'LOOK NORTH': 'before_semantics',
                 'GO NORTH': 'before_semantics', 'NORTH': 'before_semantics',
                 'EXAMINE BOOK': 'before_semantics', 'TELL WATSON "LOOK"': 'before_semantics',
                 'TELL WATSON "LOOK': 'before_semantics', 'IS LOOK': 'before_semantics',
                 'TAKE ALL': 'before_semantics', '': 'input_again',
                 'QUIT': 'control_command:load_or_quit', 'SAVE': 'control_command:save',
                 'PAUSE': 'control_command:pause_or_key_wait'}
        command_results = []
        for text, expected in cases.items():
            screen = {'XYZZY': 'error-unknown', 'TAKE TAKE': 'error-syntax'}.get(text)
            result = self.command(text, output / (screen + '.z80') if screen else None)
            assert result['outcome'] == expected, result
            if expected in ('lexical_error', 'syntax_error'):
                assert result['clock_before'] == result['clock_after'], result
                assert result['upper_bitmap_unchanged'], result
                expected_message = 'I DO NOT KNOW THE WORD' if expected == 'lexical_error' else 'WHAT ?'
                assert expected_message in result['lower_output'], result
            command_results.append(result)
        save_json(output / 'commands.json', command_results)
        by_command = {r['input']: r for r in command_results}
        give = by_command['GIVE BOOK TO WATSON']['command_nodes'][0]['words_le']
        assert give[:1] == ['0389'] and give[4] == '011B' and give[7:10:2] == ['08DB', '0971'], give
        assert len(by_command['TAKE BOOK AND GUN']['command_nodes']) == 2
        assert by_command['TAKE BOOKS']['tokens_before_parser'][1]['word'] == 'bookcase'
        for name in ('error-unknown', 'error-syntax'):
            subprocess.run([sys.executable, '-B', str(self.project / 'skoolkit-10.1/sna2img.py'),
                            '-s', '3', str(output / (name + '.z80')), str(output / (name + '.png'))], check=True)
        # Corpus deterministico: stem, varianti di stampa, prefissi brevi,
        # code spurie e 200 parole casuali. Esclude Z dal modello dichiarato.
        corpus = set()
        for word in self.decoder.words.values():
            for t in (word.stem, self.decoder.inflected(word), word.stem[:3], word.stem+'xyz'):
                if not t.startswith('z'):
                    corpus.add(t.upper())
        rng = random.Random(20261019)
        for _ in range(200):
            corpus.add(''.join(rng.choice('abcdefghijklmnopqrstuvwxy') for _ in range(rng.randint(1,12))).upper())
        checks = []
        for text in sorted(corpus):
            native, model = self.native_lookup(text), self.lookup.lookup(text)
            assert native['status'] == 'returned', native
            assert all(native[k] == model[k] for k in ('type', 'offset', 'word')), (native, model)
            checks.append({'input': text, 'type': native['type'], 'offset': native['offset'],
                           'word': native['word'], 'matched_prefix': model['matched_prefix']})
        save_json(output / 'lookup-checks.json', checks)
        literal_cases = ['.', ',', '"', '1', '12:30', '12PM', '60', '2S', '`1', 'Z', 'ZZ']
        save_json(output / 'literals-and-boundary.json', [self.native_lookup(t) for t in literal_cases])
        save_json(output / 'verification.json', {
            'payload_sha256': hashlib.sha256(self.decoder.mem[0x5D80:]).hexdigest(),
            'boot': boot, 'dictionary_records': len(dictionary),
            'aliases': sum(row['alias_direct'] is not None for row in dictionary),
            'classes': dict(sorted(Counter(row['class'] for row in dictionary).items())),
            'lookup_comparisons': len(checks), 'lookup_mismatches': 0,
            'command_cases': len(command_results),
            'outcomes': dict(Counter(x['outcome'] for x in command_results)),
            'scope': 'Original Z80 through editor, lexical pass, tokenisation and first syntactic unit. Stops before D7FC or control-command effects. Key polling bypassed; original print code executes.',
            'not_modelled_in_python': ['numeric/special literals', 'Z group boundary anomaly', 'syntactic parser', 'semantic/game rules'],
        })
        return {'output': str(output), 'lookups': len(checks), 'commands': len(command_results)}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument('--output', type=Path, default=Path(__file__).resolve().parent / 'results')
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('build')
    sub.add_parser('lookup').add_argument('text')
    sub.add_parser('command').add_argument('text')
    args = parser.parse_args()
    audit = Audit(args.project)
    if args.action == 'build':
        result = audit.build(args.output)
    else:
        args.output.mkdir(parents=True, exist_ok=True)
        audit.boot(args.output / 'prompt.z80')
        if args.action == 'lookup':
            result = {'native_z80': audit.native_lookup(args.text)}
            try:
                result['python'] = audit.lookup.lookup(args.text)
            except ValueError as exc:
                result['python_not_modelled'] = str(exc)
        else:
            result = audit.command(args.text)
        save_json(args.output / 'last-probe.json', result)
    print(json.dumps(result, ensure_ascii=False, indent=2))

if __name__ == '__main__':
    main()
