import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import { ClientSession } from '../src/session.mjs';

const read = async path => JSON.parse(await readFile(new URL(path, import.meta.url)));
const data = await read('../data/game.json');
const reference = await read('fixtures/native-picture-window.json');
const pictureStress = await read('fixtures/native-picture-stress.json');
const packed = await readFile(new URL('fixtures/native-picture-endings.json.gz', import.meta.url));
const { cases, victoria_prefix: victoriaPrefix } = JSON.parse(gunzipSync(packed));

function scan(game) {
  const output = Buffer.alloc(144 * 32 + 18 * 32);
  const display = game.sourceDisplay;
  for (let y = 0; y < 144; y++) {
    const start = 0x4000 | ((y & 192) << 5) | ((y & 7) << 8) | ((y & 56) << 2);
    for (let x = 0; x < 32; x++) output[y * 32 + x] = display.read(start + x);
  }
  for (let i = 0; i < 18 * 32; i++) output[144 * 32 + i] = display.read(0x5800 + i);
  return {
    video: createHash('sha256').update(output).digest('hex'),
    counter: game.world.display.counter,
    narrow: game.world.display.windowMode,
  };
}

async function replay(trace, { mirrorUntil = -1 } = {}) {
  const session = new ClientSession(data);
  assert.equal(session.request('reset', { seed: trace.seed, native_graphics: true }).state.native_graphics, true);
  const game = session.game;
  let job, mirrorJob, resumed;
  let scans = [], command;
  const pauses = [];
  if (trace.more) {
    const newline = game.sourceDisplay.newline.bind(game.sourceDisplay);
    game.sourceDisplay.newline = () => {
      if (game.world.display.counter === 15) {
        pauses.push({ command, tick: game.world.tick, ...scan(game) });
      }
      return newline();
    };
  }
  const absolute = game.runtimeRandom.absolute.bind(game.runtimeRandom);
  game.runtimeRandom.absolute = (...args) => {
    scans.push(scan(game));
    return absolute(...args);
  };

  for (const [index, row] of trace.steps.entries()) {
    if (row.command !== null) command = row.command;
    scans = [];
    const before = game.world.random.draws;
    const operation = row.command === null ? 'continue-command' :
      row.command.startsWith('WAIT UNTIL') ? 'start-command' : 'command';
    const input = row.command === null ? { job } : { command: row.command };
    const out = session.request(operation, input);
    job = out.job;
    const label = (row.command ?? 'WAIT UNTIL') + ' · ' + row.clock.label;
    assert.notEqual(out.state.analysis.outcome, 'not_translated', out.state.prototype_notice);
    if (row.outcome) assert.equal(out.state.analysis.outcome, row.outcome, label);
    assert.equal(Boolean(out.running), Boolean(row.running), label);
    assert.equal(out.state.room, row.room, label);
    assert.deepEqual(out.state.clock, row.clock, label);
    assert.deepEqual(game.ended, row.ending ?? null, label);
    assert.deepEqual(scan(game), { video: row.video, counter: row.counter, narrow: row.narrow }, label);
    const count = game.world.random.draws - before;
    assert.equal(count, row.draws.length, label);
    assert.equal(scans.length, count, label);
    const draws = count ? game.world.random.trace.slice(-count) : [];
    for (const [i, { video, counter, narrow, ...draw }] of row.draws.entries()) {
      assert.deepEqual(scans[i], { video, counter, narrow }, label + ' draw ' + i);
      const { purpose, ...actual } = draws[i];
      assert.deepEqual(actual, draw, label + ' draw ' + i);
    }

    if (index === mirrorUntil) resumed = null;
    if (resumed) {
      const mirror = resumed.request(operation, row.command === null ? { job: mirrorJob } : input);
      mirrorJob = mirror.job;
      assert.deepEqual(mirror, out, label + ' after load');
      assert.deepEqual(resumed.game.world.dump(), game.world.dump(), label + ' after load');
    } else if (index < mirrorUntil && row.command === 'D' && row.room === 6) {
      const { save } = await session.request('save');
      resumed = new ClientSession(data);
      const loaded = await resumed.request('load', { save: JSON.parse(JSON.stringify(save)) });
      assert.equal(loaded.state.native_graphics, true);
      assert.deepEqual(resumed.game.dump(), game.dump());
    }
  }
  if (trace.more) assert.deepEqual(pauses, trace.more);
  return session;
}

test('Native graphics reproduce original pixels, attributes and random draws through Leatherhead', async () => {
  assert.equal(reference.steps.length, 81);
  const session = await replay(reference, { mirrorUntil: 23 });
  assert.equal(session.game.world.clock().label, 'Mon 11:42am');
  assert.equal(session.game.world.roomOf(), 88);
  const text = session.request('reset', { seed: reference.seed });
  assert.equal(text.state.native_graphics, undefined);
  assert.equal(session.game.world.display.pictureWindow, undefined);
});

test('Native graphics preserve narrow-scroll stack inputs through the return to Slater Street', async () => {
  assert.equal(victoriaPrefix.steps.length, 755);
  const session = await replay(victoriaPrefix);
  assert.equal(session.game.world.clock().label, 'Mon 11:57pm');
});

test('The graphics-enabled Victoria route matches through Tuesday afternoon at Camden Street', async () => {
  const corpus = await readFile(new URL('../results/victory-route/victoria-native-graphics-seed137.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(corpus));
  const index = trace.steps.findIndex(step => step.draws.some(draw =>
    draw.actor === 8 && draw.reads.some(read => read.address === 0xF60B)));
  assert.equal(index, 326);
  assert.deepEqual(trace.steps.at(-1).ending, { entry: '9E74', reason: 'story', text_pointer: '6AF3' });
  const steps = trace.steps.slice(0, 1644);
  const session = await replay({ ...trace, steps, more: undefined });
  assert.equal(session.game.world.clock().label, 'Tue 04:55pm');
});

for (const trace of cases) {
  test('Native graphics through ending 693A with seed ' + trace.seed, async () => {
    assert.equal(trace.steps.length, 400);
    const session = await replay(trace, { mirrorUntil: Infinity });
    assert.equal(session.game.ended.text_pointer, '693A');
    assert.deepEqual(session.request('command', { command: 'LOOK' }).messages, []);
  });
}

test('Repeated room pictures preserve the pictured window when MORE interrupts scrolling', async () => {
  assert.equal(pictureStress.steps.length, 14);
  assert.equal(pictureStress.picture_frames.length, 9);
  assert.equal(pictureStress.more.length, 1);
  assert.equal(pictureStress.more[0].narrow, 1);
  assert.equal(pictureStress.more[0].counter, 15);
  const session = await replay(pictureStress, { mirrorUntil: Infinity });
  assert.equal(session.game.world.clock().label, 'Mon 08:27am');
});
