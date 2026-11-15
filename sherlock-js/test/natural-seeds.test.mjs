import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
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
