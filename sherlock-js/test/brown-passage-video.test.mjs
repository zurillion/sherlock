import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { Game } from '../src/game.mjs';

const read = async path => JSON.parse(await readFile(new URL('../' + path, import.meta.url)));
const data = await read('data/game.json');
const abi = 'results/brown-to-ending/wide-abi/';
const addresses = [0x5D2A, 0x5D2B];

test('The saved video address matches the original passage across 720 geometries', async () => {
  const { cases } = await read(abi + 'passage-abi.json');
  const game = new Game(data, { npc_profile: 'world-v5', seed: 1 });
  const display = game.sourceDisplay;
  game.world.move(0, 48);
  const matches = new Map(addresses.map(address => [address, 0]));
  for (const row of cases) {
    game.world.entity(50).noun = row.noun;
    const trace = [];
    const text = game.text.scene({ full: true, mark: false, source: row.mode, trace });
    const start = text.indexOf('To the north');
    assert(start >= 0);
    const prefix = row.spacing ? ' ' : '';
    const spans = trace.filter(span => span.start >= start).map(span => ({
      ...span, start: span.start - start + prefix.length, end: span.end - start + prefix.length,
    }));
    Object.assign(display.state, {
      scratch: {}, cursor: row.column, remaining: 36 - row.column, counter: 0,
      started: Boolean(row.spacing), pending: '', spacingFlag: row.spacing,
      capitalizationFlag: row.spacing, upper: Array(18).fill(''),
    });
    display.state.wordBuffer.index = 0;
    display.write(prefix + text.slice(start), { sceneTrace: spans });
    for (const address of addresses) {
      const value = display.read(address);
      if (value !== null) {
        matches.set(address, matches.get(address) + 1);
        assert.equal(value, row.cells[address], JSON.stringify({
          address, mode: row.mode, column: row.column, noun: row.noun, spacing: row.spacing,
        }));
      }
      if (row.mode === 'look') assert.equal(value, null);
    }
  }
  assert.deepEqual([...matches.values()], [290, 290]);
});

test('A known separator low byte does not establish its high byte, and vice versa', () => {
  const game = new Game(data, { npc_profile: 'world-v5', seed: 1 });
  const display = game.sourceDisplay;
  display.upperGlyphKnown = false;
  for (const [low, high] of [[true, false], [false, true]]) {
    display.glyphSpaceVideoLowKnown = low;
    display.glyphSpaceVideoHighKnown = high;
    for (let column = 0; column < 36; column++) {
      display.glyphResidue(' ', 0x5D32, column, 0x526E);
      const address = 0x5020 + Math.floor((2 + 7 * column) / 8);
      assert.equal(display.read(0x5D2A), low ? address & 255 : null);
      assert.equal(display.read(0x5D2B), high ? address >>> 8 : null);
    }
    display.glyphResidue('q', 0x5D32, 22, 0x526E);
    for (const address of addresses) assert.equal(display.read(address), null);
  }
});

test('Fresh-row arrivals preserve the saved video address', async () => {
  const { cases } = await read(abi + 'arrival-fresh-row-abi.json');
  assert.equal(cases.length, 300);
  assert(cases.every(row => row.column === 0 && row.cells[16] === 165 && row.cells[17] === 165));
});
