import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import assert from 'node:assert/strict';
import { setTimeout as delay } from 'node:timers/promises';
import { compareNaturalHistory } from '../test/helpers/compare-natural-history.mjs';

const root = new URL('../', import.meta.url);
const output = new URL('results/passage-caller-c-22/', root);
const data = JSON.parse(await readFile(new URL('data/game.json', root)));
const baseline = process.argv.includes('--baseline');
const acquiring = process.argv.includes('--await-original');
const extended = new URL('extended-reference.json', output);
let reference;
if (baseline) {
  const source = await readFile(new URL('results/final-solution/witness-native-reference.json.gz', root));
  const witness = JSON.parse(gunzipSync(source)).cases.find(row => row.label === 'major-witness');
  assert.equal(witness.steps.at(-1).ending.text_pointer, '6A33');
  reference = { ...witness, expected: '6A33' };
} else {
  const source = await readFile(acquiring
    ? new URL('results/passage-descriptor-high-21/extended-reference.json', root) : extended);
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
      if (acquiring && completed === 521) {
        console.log('Verified the entire previous original reference.');
        const deadline = Date.now() + 15 * 60_000;
        for (;;) {
          try {
            const next = JSON.parse(await readFile(extended)).cases[0];
            assert.deepEqual(next.steps.slice(0, completed), reference.steps);
            reference.steps.push(...next.steps.slice(completed));
            break;
          } catch (error) {
            if (error.code !== 'ENOENT' || Date.now() > deadline) throw error;
            await delay(5_000);
          }
        }
      }
    },
  });
} catch (error) {
  if (baseline || !error.message.startsWith(completed + ' Ingresso casuale originale non ancora ricostruito: $5D29.')) throw error;
  result = { stoppedAt: '5D29', error: error.message };
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
