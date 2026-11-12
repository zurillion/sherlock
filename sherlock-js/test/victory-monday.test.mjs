import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { gunzipSync } from 'node:zlib';
import { compareNaturalHistory } from './helpers/compare-natural-history.mjs';

test('Natural victory route prefix / Monday evidence and retained cab quotation', async () => {
 const [dataFile, referenceFile] = await Promise.all([
  readFile(new URL('../data/game.json', import.meta.url)),
  readFile(new URL('fixtures/victory-monday-reference.json.gz', import.meta.url))
 ]);
 const [scenario] = JSON.parse(gunzipSync(referenceFile)).cases;
 await compareNaturalHistory(JSON.parse(dataFile), scenario);
});
