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

async function replay(trace, { mirrorUntil = -1, savePoints = [], expectedPrefixes = {} } = {}) {
  const session = new ClientSession(data);
  assert.equal(session.request('reset', { seed: trace.seed, native_graphics: true }).state.native_graphics, true);
  const game = session.game;
  let job, mirrorJob, resumed;
  let verifiedSaves = 0;
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
    if (Object.hasOwn(expectedPrefixes, index)) {
      const firstWord = out.messages.flatMap(m => m.screen_events ?? []).find(e => e.op === 'word');
      assert.equal(firstWord?.text, expectedPrefixes[index]);
      assert.equal(firstWord?.delimiter, '\r');
      assert.equal(firstWord?.formatted, true);
    }
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
      // Job identifiers only address this connection's active transport.
      // The two sessions receive and use their own identifier on every tick.
      const { job: sourceJob, state: { job: sourceStateJob, ...sourceState }, ...sourceReply } = out;
      const { job: loadedJob, state: { job: loadedStateJob, ...loadedState }, ...loadedReply } = mirror;
      assert.equal(sourceJob, sourceStateJob, label);
      assert.equal(loadedJob, loadedStateJob, label);
      assert.equal(Boolean(loadedJob), Boolean(sourceJob), label);
      assert.deepEqual({ ...loadedReply, state: loadedState }, { ...sourceReply, state: sourceState }, label + ' after load');
      assert.deepEqual(resumed.game.world.dump(), game.world.dump(), label + ' after load');
    }
    const milestone = savePoints.includes(index);
    if (milestone || !resumed && index < mirrorUntil && row.command === 'D' && row.room === 6) {
      assert.equal(Boolean(out.running), false, label + ' before save');
      const { save } = await session.request('save');
      resumed = new ClientSession(data);
      const loaded = await resumed.request('load', { save: JSON.parse(JSON.stringify(save)) });
      assert.equal(loaded.state.native_graphics, true);
      assert.deepEqual(resumed.game.dump(), game.dump());
      if (milestone) verifiedSaves++;
    }
  }
  if (trace.more) assert.deepEqual(pauses, trace.more);
  assert.equal(verifiedSaves, savePoints.length);
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

test('Seed 0 reproduces the complete graphics-enabled victory at Victoria', async () => {
  const corpus = await readFile(new URL('../results/victory-route/victoria-native-graphics-seed0.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(corpus));
  assert.equal(trace.seed, 0);
  assert.equal(trace.steps.length, 3219);
  const session = await replay(trace, { savePoints: [11, 16, 31, 62, 3198, 3217], expectedPrefixes: { 755: '\0Round.' } });
  assert.equal(session.game.world.clock().label, 'Wed 08:12pm');
  assert.equal(session.game.world.roomOf(), 30);
  assert.equal(session.game.ended.text_pointer, '6AF3');
});

test('Seed 1 reproduces the Victoria route through the victory at Victoria', async () => {
  const corpus = await readFile(new URL('../results/victory-route/victoria-native-graphics-seed1.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(corpus));
  assert.equal(trace.seed, 1);
  assert.equal(trace.steps.length, 3219);
  assert.deepEqual(trace.steps.at(-1).ending, { entry: '9E74', reason: 'story', text_pointer: '6AF3' });
  const session = await replay(trace, { savePoints: [11, 16, 31, 62, 3198, 3217] });
  assert.equal(session.game.world.clock().label, 'Wed 08:12pm');
  assert.equal(session.game.world.roomOf(), 30);
  assert.equal(session.game.ended.text_pointer, '6AF3');
});

test('An extra LOOK before the first cab retains renderer state into Wednesday', async () => {
  const packed = await readFile(new URL('../results/victory-route/victoria-extra-look-native-seed1.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(packed));
  const limit = 3050;
  assert.equal(trace.seed, 1);
  assert.equal(trace.steps.length, 3312);
  const excluded = trace.steps[limit];
  assert(excluded.draws.some(draw => draw.reads.some(read => read.address === 0x5D21)));
  const session = await replay({ ...trace, steps: trace.steps.slice(0, limit) }, { savePoints: [1488, 2005, 2780, 2911] });
  assert.equal(session.game.world.clock().label, 'Wed 03:49pm');
  const boundary = excluded.command === null
    ? session.request('continue-command', { job: session.state().job })
    : session.request('command', { command: excluded.command });
  assert.equal(boundary.state.analysis.outcome, 'not_translated');
  assert.equal(boundary.state.analysis.missing_address, 0x5D21);
});

test('Entering the Victoria platform early reproduces the original death with graphics enabled', async () => {
  const packed = await readFile(new URL('../results/victory-route/victoria-early-platform-graphics-seed1.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(packed));
  assert.equal(trace.seed, 1);
  assert.equal(trace.steps.length, 3219);
  assert.deepEqual(trace.steps.at(-1).ending, { entry: '9E74', reason: 'story', text_pointer: '6B79' });
  const session = await replay(trace, { savePoints: [3215] });
  assert.equal(session.game.world.clock().label, 'Wed 08:12pm');
  assert.equal(session.game.world.roomOf(), 30);
  assert.equal(session.game.ended.text_pointer, '6B79');
});

test('The graphics-enabled Victoria route reproduces the complete victory at Victoria', async () => {
  const corpus = await readFile(new URL('../results/victory-route/victoria-native-graphics-seed137.json.gz', import.meta.url));
  const trace = JSON.parse(gunzipSync(corpus));
  const index = trace.steps.findIndex(step => step.draws.some(draw =>
    draw.actor === 8 && draw.reads.some(read => read.address === 0xF60B)));
  assert.equal(index, 326);
  assert.deepEqual(trace.steps.at(-1).ending, { entry: '9E74', reason: 'story', text_pointer: '6AF3' });
  assert.equal(trace.steps.length, 3219);
  // Hall picture, booked cab, train, Leatherhead evidence, final cab and
  // the last platform. An uninterrupted run validates each loaded segment.
  const savePoints = [11, 16, 31, 62, 3198, 3217];
  const session = await replay({ ...trace, more: undefined }, { savePoints });
  assert.equal(session.game.world.clock().label, 'Wed 08:12pm');
  assert.equal(session.game.world.roomOf(), 30);
  assert.equal(session.game.ended.text_pointer, '6AF3');
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
