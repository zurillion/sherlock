#!/usr/bin/env python3
"""Modello Python del confronto alfabetico D9C5/DA34/DA7D, senza Z80.

Riceve un Decoder sherlock_text già caricato. Non implementa numeri, editor,
parser grammaticale o il caso anomalo Z (scansione oltre i record reali).
"""
class DictionaryLookup:
    def __init__(self, decoder):
        self.decoder = decoder
        self.groups = {}
        for word in decoder.words.values():
            self.groups.setdefault(word.stem[0], []).append(word)

    def canonical(self, word):
        seen = set()
        while word.extra:
            if word.offset in seen:
                raise ValueError('Ciclo nei rimandi del dizionario')
            seen.add(word.offset)
            word = self.decoder.words[int.from_bytes(word.extra, 'little')]
        return word

    def lookup(self, text):
        if not text or not text.isascii() or not text.isalpha():
            raise ValueError('Il modello accetta una singola parola ASCII A–Z')
        text = text.lower()
        if text[0] == 'z':
            raise ValueError('Z richiede la prova Z80: il limite originale include un byte dopo i record')
        best = 0
        selected = None
        for word in self.groups.get(text[0], []):
            if word.flags >> 4 == 13:
                continue
            if best >= len(text):
                break
            # A94D aggiunge il suffisso MAIUSCOLO, mentre DA34 rende minuscolo
            # l'input: il confronto non oltrepassa lo stem per quelle lettere.
            matching = 1
            for left, right in zip(text[1:], word.stem[1:]):
                if left != right:
                    break
                matching += 1
            if matching < best:
                break
            best = matching
            selected = self.canonical(word)
        accepted = selected is not None and (best >= 4 or best == len(text))
        return {
            'input': text.upper(), 'type': f'{selected.flags & 0xF0:02X}' if accepted else 'D0',
            'offset': f'{selected.offset:04X}' if accepted else '0000',
            'word': selected.stem if accepted else None,
            'matched_prefix': best, 'input_length': len(text),
        }
