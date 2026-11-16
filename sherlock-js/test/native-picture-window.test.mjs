import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { ClientSession } from '../src/session.mjs';

const read = async path => JSON.parse(await readFile(new URL(path, import.meta.url)));
const data = await read('../data/game.json');
const reference = await read('fixtures/native-picture-window.json');
const pictureHash = game => {
  const output = Buffer.alloc(144 * 32 + 18 * 32);
  const display = game.sourceDisplay;
  for (let y = 0; y < 144; y++) {
    const start = 0x4000 | ((y & 192) << 5) | ((y & 7) << 8) | ((y & 56) << 2);
    for (let x = 0; x < 32; x++) output[y * 32 + x] = display.read(start + x);
  }
  for (let i = 0; i < 18 * 32; i++) output[144 * 32 + i] = display.read(0x5800 + i);
  return createHash('sha256').update(output).digest('hex');
};
const scan = game => ({
  video: pictureHash(game),
  counter: game.world.display.counter,
  narrow: game.world.display.windowMode,
});

test('Native graphics reproduce original pixels, attributes and random draws through Leatherhead', async () => {
  const session = new ClientSession(data);
  const boot = session.request('reset', { seed: reference.seed, native_graphics: true });
  assert.equal(boot.state.native_graphics, true);
  const game = session.game;
  let scans = [];
  const absolute = game.runtimeRandom.absolute.bind(game.runtimeRandom);
  game.runtimeRandom.absolute = (...args) => {
    scans.push(scan(game));
    return absolute(...args);
  };

  let resumed;
  assert.equal(reference.steps.length, 81);
  for (const [index, row] of reference.steps.entries()) {
    scans = [];
    const before = game.world.random.draws;
    const outcome = session.request('command', { command: row.command });
    const label = row.command + ' · ' + row.clock.label;
    assert.equal(outcome.state.analysis.outcome, row.outcome, label);
    assert.deepEqual(outcome.state.clock, row.clock, label);
    assert.equal(outcome.state.room, row.room, label);
    assert.deepEqual(scan(game), { video: row.video, counter: row.counter, narrow: row.narrow }, label);
    const drawCount = game.world.random.draws - before;
    assert.equal(drawCount, row.draws.length, label);
    const draws = drawCount ? game.world.random.trace.slice(-drawCount) : [];
    for (const [i, { video, counter, narrow, ...draw }] of row.draws.entries()) {
      assert.deepEqual(scans[i], { video, counter, narrow }, label + ' · draw ' + i);
      const { purpose, ...actual } = draws[i];
      assert.deepEqual(actual, draw, label + ' · draw ' + i);
    }

    if (row.command === 'D' && row.room === 6) {
      const { save } = await session.request('save');
      resumed = new ClientSession(data);
      const loaded = await resumed.request('load', { save: JSON.parse(JSON.stringify(save)) });
      assert.equal(loaded.state.native_graphics, true);
      assert.deepEqual(resumed.game.dump(), game.dump());
    } else if (resumed) {
      const next = resumed.request('command', { command: row.command });
      assert.deepEqual(next, outcome, label + ' after load');
      assert.deepEqual(resumed.game.dump(), game.dump(), label + ' after load');
      if (index === 22) resumed = null;
    }
  }
  assert.equal(game.world.clock().label, 'Mon 11:42am');
  assert.equal(game.world.roomOf(), 88);
  const text = session.request('reset', { seed: reference.seed });
  assert.equal(text.state.native_graphics, undefined);
  assert.equal(session.game.world.display.pictureWindow, undefined);
});
