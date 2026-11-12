import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import assert from 'node:assert/strict';
import { compareNaturalHistory } from '../test/helpers/compare-natural-history.mjs';

const root = new URL('../', import.meta.url);
const output = new URL('results/passage-scan-count-29/', root);
const data = JSON.parse(await readFile(new URL('data/game.json', root)));
const baseline = process.argv.includes('--baseline');
const extended = new URL('results/passage-caller-c-22/extended-reference.json', root);
let reference;
if (baseline) {
  const source = await readFile(new URL('results/final-solution/witness-native-reference.json.gz', root));
  const witness = JSON.parse(gunzipSync(source)).cases.find(row => row.label === 'major-witness');
  assert.equal(witness.steps.at(-1).ending.text_pointer, '6A33');
  reference = { ...witness, expected: '6A33' };
} else {
  const source = await readFile(extended);
  reference = JSON.parse(source).cases[0];
}

let completed = 0;
let lastClock = null;
let result;
try {
  result = await compareNaturalHistory(data, reference, {
    async onCheckpoint(index, session) {
      completed = index + 1;
      lastClock = session.game.world.clock();
      if (completed % 100 === 0) console.log('checkpoint', completed, lastClock.label);

    },
  });
} catch (error) {
  const match = error.message.match(/^(\d+) Ingresso casuale originale non ancora ricostruito: \$([A-F0-9]{4})\./);
  if (baseline || !match || Number(match[1]) !== completed) throw error;
  const address = Number.parseInt(match[2], 16);
  assert(reference.steps[completed].random.some(draw => draw.reads.some(read => read.address === address)));
  result = { stoppedAt: match[2], error: error.message };
}
assert(completed > 0);
const certified = reference.steps.slice(0, completed);
const draws = certified.flatMap(row => row.random);
const report = {
  ...result,
  checkpoints: completed,
  certified_checkpoint_range: [0, completed - 1],
  clock: lastClock,
  compared_random_draws: draws.length,
  compared_random_reads: draws.reduce((total, draw) => total + draw.reads.length, 0),
  all_actors: 24,
  arena_bytes_per_checkpoint: 752,
  bitmaps_compared: true,
  load_future_compared: true,
  full_ending_certified: baseline,
};
await writeFile(new URL(baseline ? 'baseline-6a33.json' : 'full-comparison.json', output),
  JSON.stringify(report, null, 2) + '\n');
console.log(report);
