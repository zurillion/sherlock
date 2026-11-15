import test from 'node:test';
import { readFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import { compareNaturalHistory } from './helpers/compare-natural-history.mjs';

const data = JSON.parse(await readFile(new URL('../data/game.json', import.meta.url)));
const source = new URL('../results/seed-and-saves/watson-cab-native.json.gz', import.meta.url);
const { cases } = JSON.parse(gunzipSync(await readFile(source)));

for (const scenario of cases) {
  test(`Watson and the cab through Kings Cross under native seed ${scenario.seed}`, async () => {
    await compareNaturalHistory(data, scenario);
  });
}
