import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { Game } from '../src/game.mjs';
import { ClientSession } from '../src/session.mjs';

const read = async path => JSON.parse(await readFile(new URL('../' + path, import.meta.url)));
const data = await read('data/game.json');
const makeGame = () => new Game(data, { npc_profile: 'world-v5', seed: 1 });

test('Original glyph frames assign six roles to 5D22, including all eight caller C offsets', async () => {
  const { cases } = await read('test/fixtures/glyph-address-high-abi.json');
  const rows = cases.filter(row => row.frame >= 0x5D24 && row.frame <= 0x5D2E);
  const display = makeGame().sourceDisplay;
  const offsets = new Set();
  assert.equal(rows.length, 1296);
  for (const { frame, char, column, descriptor, count, cells } of rows) {
    display.state.scratch = {};
    display.upperGlyphKnown = true;
    display.glyphFlagsKnown = true;
    display.glyphResidue(char, frame, column, descriptor, count);
    assert.equal(display.read(0x5D22), cells[0x5D22]);
    if (frame === 0x5D26) {
      display.state.scratch = {};
      display.upperGlyphKnown = false;
      display.glyphCallerCKnown = true;
      display.glyphResidue(char, frame, column, descriptor, count);
      assert.equal(display.read(0x5D22), cells[0x5D22]);
      assert.equal(display.read(0x5D23), null);
      offsets.add(cells[0x5D22]);
    }
  }
  assert.equal(offsets.size, 8);
});

test('Saved offsets and scan count match original passage geometry, including wrap revocation', async () => {
  const { cases } = await read('results/passage-caller-c-22/wide-abi/passage-abi.json');
  const game = makeGame();
  const display = game.sourceDisplay;
  game.world.move(0, 48);
  const owned = { 0x5D22: 0, 0x5D28: 0, 0x5D29: 0 };
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
    for (const address of [0x5D22, 0x5D28, 0x5D29]) {
      const value = display.read(address);
      if (value !== null) {
        owned[address]++;
        assert.equal(value, row.cells[address], JSON.stringify({
          address, mode: row.mode, column: row.column, noun: row.noun, spacing: row.spacing,
        }));
      }
      if (row.mode === 'look') assert.equal(value, null);
    }
  }
  assert.equal(owned[0x5D22], 290);
  assert.equal(owned[0x5D28], 290);
  assert.equal(owned[0x5D29], 290);
});

test('Original arrivals preserve caller C and can overwrite scan BC on a wrapped row', async () => {
  const directory = 'results/passage-caller-c-22/wide-abi/';
  const { cases: arrivals } = await read(directory + 'arrival-low-abi.json');
  const { cases: freshRows } = await read(directory + 'arrival-fresh-row-abi.json');
  const { cases: errors } = await read(directory + 'simple-error-abi.json');
  const eligibleArrivals = arrivals.filter(row => row.eligible);
  const eligibleErrors = errors.filter(row => row.eligible);
  assert.equal(arrivals.length, 1512);
  assert.equal(eligibleArrivals.length, 720);
  assert(eligibleArrivals.every(row => row.cells[8] === 165));
  assert.equal(eligibleArrivals.filter(row => row.cells[14] !== 165).length, 110);
  assert.equal(eligibleArrivals.filter(row => row.cells[15] !== 165).length, 110);
  assert.equal(freshRows.length, 300);
  assert(freshRows.every(row => row.column === 0 && row.cells[14] === 165 && row.cells[15] === 165));
  assert.equal(errors.length, 138);
  assert.equal(eligibleErrors.length, 129);
  assert(eligibleErrors.every(row => row.cells[8] === 165 && row.cells[14] === 165 && row.cells[15] === 165));

  for (const [column, counter, preserved] of [[0, 12, true], [0, 13, false], [30, 0, false]]) {
    const game = makeGame();
    const display = game.sourceDisplay;
    Object.assign(display.state, {
      scratch: { [0x5D22]: 5, [0x5D28]: 4, [0x5D29]: 1 }, cursor: column, remaining: 36 - column,
      counter, pending: '', started: false, spacingFlag: 0,
    });
    const output = {
      messages: [{ kind: 'narrative', text: 'Watson enters.', arrival_entity: 3 }],
      visibilityResolved: true, cost: 2, action: 2, args: [],
    };
    game.npcRuntime.showAction(output, 3, [], [], { argumentFlags: true });
    assert.equal(display.read(0x5D22), 5);
    assert.equal(display.read(0x5D28), preserved ? 4 : null);
    assert.equal(display.read(0x5D29), preserved ? 1 : null);
  }

  for (const command of ['EXAMINE STREAM', 'EXAMINE LARGE STREAM']) {
    const game = makeGame();
    game.world.move(0, 48);
    game.world.npcs.sceneryFailure = { action: 19, slot: 0, found: false };
    game.sourceDisplay.state.scratch[0x5D22] = 5;
    game.sourceDisplay.state.scratch[0x5D28] = 4;
    game.sourceDisplay.state.scratch[0x5D29] = 1;
    const message = game.resolve(game.parser.parse(command).nodes[0], 19).message;
    game.sourceDisplay.error([message]);
    const simple = command === 'EXAMINE STREAM';
    assert.equal(game.sourceDisplay.read(0x5D22), simple ? 5 : null);
    assert.equal(game.sourceDisplay.read(0x5D28), simple ? 4 : null);
    assert.equal(game.sourceDisplay.read(0x5D29), simple ? 1 : null);
  }
});

test('Passage scan C comes from the actual separator and does not establish the adjacent scan count', () => {
  const display = makeGame().sourceDisplay;
  display.upperGlyphKnown = false;
  display.glyphSpaceShiftKnown = true;
  for (let column = 0; column < 36; column++) {
    display.glyphResidue(' ', 0x5D32, column, 0x526E);
    assert.equal(display.read(0x5D28), (2 + 7 * column) & 7);
    assert.equal(display.read(0x5D29), null);
  }
  display.glyphResidue('q', 0x5D32, 22, 0x526E);
  assert.equal(display.read(0x5D28), null);
  display.glyphResidue(' ', 0x5D32, 22, 0x526E);
  display.glyphResidue(' ', 0x5D20, 35, 0x5A20);
  assert.equal(display.read(0x5D28), null);
});

test('Ordinary commands derive offsets and scan count from a prewriter SAVE', async () => {
  const session = new ClientSession(data);
  await session.request('load', { save: await read('results/passage-descriptor-high-21/entry-js-save.json') });
  const reference = await read('results/passage-descriptor-high-21/extended-reference.json');
  for (const { input } of reference.cases[0].steps.slice(326, 338)) {
    assert(input && !input.startsWith('WAIT'));
    const out = session.request('command', { command: input });
    assert.notEqual(out.state.analysis.outcome, 'not_translated');
  }
  const save = (await session.request('save')).save;
  const loaded = new ClientSession(data);
  await loaded.request('load', { save });
  assert.equal(loaded.game.runtimeRandom.read(0x5D22), 5);
  assert.equal(loaded.game.runtimeRandom.read(0x5D28), 4);
  assert.equal(loaded.game.runtimeRandom.read(0x5D29), 1);
  const oldState = loaded.game.dump();
  delete oldState.world.display.scratch[0x5D22];
  delete oldState.world.display.scratch[0x5D28];
  delete oldState.world.display.scratch[0x5D29];
  const oldGame = Game.load(data, oldState);
  oldGame.sourceDisplay.write('Watson enters.', { preserve22: true, preserve28: true, preserve29: true });
  assert.throws(() => oldGame.runtimeRandom.read(0x5D22), /5D22/);
  assert.throws(() => oldGame.runtimeRandom.read(0x5D28), /5D28/);
  assert.throws(() => oldGame.runtimeRandom.read(0x5D29), /5D29/);
});

test('Scan B ownership depends on the separator frame even for an aligned glyph', () => {
  const display = makeGame().sourceDisplay;
  display.upperGlyphKnown = false;
  display.glyphSpaceCountKnown = true;
  for (let column = 0; column < 36; column++) {
    display.glyphResidue(' ', 0x5D32, column, 0x526E);
    assert.equal(display.read(0x5D29), 1);
    assert.equal(display.read(0x5D28), null);
  }
  display.glyphResidue('q', 0x5D32, 22, 0x526E);
  assert.equal(display.read(0x5D29), null);
  display.glyphResidue(' ', 0x5D32, 22, 0x526E);
  display.glyphResidue(' ', 0x5D20, 35, 0x5A20);
  assert.equal(display.read(0x5D29), null);
});
