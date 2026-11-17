import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { ClientSession } from '../src/session.mjs';

const read = async path => JSON.parse(await readFile(new URL(path, import.meta.url)));
const data = await read('../data/game.json');
const original = await read('../results/native-load/restart-and-load.json');

const command = (session, text) => session.request('command', { command: text });
const boot = { seed: 137, native_graphics: true };

test('NEW matches the original lexical error; Restart rebuilds the configured initial state', () => {
  const session = new ClientSession(data);
  session.request('reset', boot);
  const clean = session.game.dump();

  const result = command(session, 'NEW');
  assert.equal(result.state.analysis.outcome, original.new.analysis.outcome);
  assert.deepEqual(result.messages.map(message => message.text), original.new.messages);
  command(session, 'SAY WATSON "FOLLOW ME"');
  assert.equal(command(session, 'OPEN DOOR').state.analysis.outcome, 'clarification');
  assert.notDeepEqual(session.game.dump(), clean);

  session.request('reset', boot);
  assert.deepEqual(session.game.dump(), clean);
});

test('JSON LOAD restores the pending clarification and the exact future after a canceled chooser', async () => {
  const session = new ClientSession(data);
  session.request('reset', boot);
  command(session, 'SAY WATSON "FOLLOW ME"');
  command(session, 'OPEN DOOR');
  const { save } = await session.request('save');
  const atQuestion = session.game.dump();
  const request = command(session, 'LOAD');
  assert(request.state.analysis.controls.includes('load'));
  assert.deepEqual(session.game.pending, atQuestion.pending);
  assert.equal(session.game.world.tick, atQuestion.world.tick);

  const resumed = new ClientSession(data);
  await resumed.request('load', { save: JSON.parse(JSON.stringify(save)) });
  assert.deepEqual(resumed.game.dump(), atQuestion);
  for (const text of ['YOUR', 'W', 'D', 'WAIT', 'LOOK']) {
    assert.deepEqual(command(resumed, text), command(session, text));
    assert.deepEqual(resumed.game.world.random, session.game.world.random);
  }
});

test('The save port keeps queued NPC orders and their future after LOAD', async () => {
  const session = new ClientSession(data);
  session.request('reset', boot);
  command(session, 'SAY TO WATSON "WAIT"');
  command(session, 'SAY TO WATSON "PAY 1/- TO ME"');
  assert.equal(session.game.world.scheduler.requests.length, 1);

  const { save } = await session.request('save');
  const resumed = new ClientSession(data);
  await resumed.request('load', { save });
  assert.deepEqual(resumed.game.dump(), session.game.dump());
  assert.deepEqual(command(resumed, 'WAIT'), command(session, 'WAIT'));
  assert.equal(resumed.game.world.scheduler.requests.length, 0);
  assert.deepEqual(resumed.game.dump(), session.game.dump());
});
