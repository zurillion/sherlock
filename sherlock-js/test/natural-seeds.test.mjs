import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import { gunzipSync } from 'node:zlib';
import { Game } from '../src/game.mjs';
import { compareNaturalHistory } from './helpers/compare-natural-history.mjs';

const data = JSON.parse(await readFile(new URL('../data/game.json', import.meta.url)));
const source = new URL('../results/seed-and-saves/watson-cab-native.json.gz', import.meta.url);
const { cases } = JSON.parse(gunzipSync(await readFile(source)));

for (const scenario of cases) {
  test(`Watson and the cab through Kings Cross under native seed ${scenario.seed}`, async () => {
    await compareNaturalHistory(data, scenario);
  });
}


test('Native seed 137 through the Brown house clues', async () => {
  const directory = new URL('../results/seed-and-saves/', import.meta.url);
  const report = JSON.parse(await readFile(new URL('brown-clues-verification.json', directory)));
  const compressed = await readFile(new URL('brown-clues-native.json.gz', directory));
  assert.equal(createHash('sha256').update(compressed).digest('hex'), report.native_corpus_sha256);
  const { cases: [scenario] } = JSON.parse(gunzipSync(compressed));
  assert.equal(scenario.seed, report.seed);
  assert.equal(scenario.steps.length, report.checkpoints);
  const result = await compareNaturalHistory(data, scenario);
  assert.deepEqual(result.clock, report.last_clock);
  assert.equal(result.terminal, report.terminal);
});

test('The consumed quotation address survives unrelated commands and saves', () => {
  const game = new Game(data, { npc_profile: 'world-v5', seed: 1 });
  const command = 'SAY TO WATSON "HELLO"';
  const parserQuote = game.parser.analyze(command).units[0].nodes[0].quote;
  const read = g => [g.npcRuntime.read(0xB868), g.npcRuntime.read(0xB869)];
  const expected = [parserQuote.tokenPointer & 255, parserQuote.tokenPointer >>> 8];
  assert.deepEqual(read(game), [0, 0]);
  assert.equal(game.submit(command).state.analysis.outcome, 'ok');
  assert.deepEqual(read(game), expected);
  game.submit('WAIT');
  assert.deepEqual(read(game), expected);
  const saved = JSON.parse(JSON.stringify(game.dump()));
  assert.deepEqual(read(Game.load(data, saved)), expected);
  delete saved.world.npcs.lastConsumedQuote;
  assert.deepEqual(read(Game.load(data, saved)), [null, null]);
});
