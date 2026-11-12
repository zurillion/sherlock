import { readFile, writeFile } from 'node:fs/promises';
import assert from 'node:assert/strict';
import { compareNaturalHistory } from '../test/helpers/compare-natural-history.mjs';

const root = new URL('../', import.meta.url);
const results = new URL('results/brown-to-ending/', root);
const read = async url => JSON.parse(await readFile(url));
const data = await read(new URL('data/game.json', root));
const originalPrefix = (await read(new URL('results/murder-ending/native-brown-full.json', root))).cases[0];
const former = (await read(new URL('results/passage-caller-c-22/extended-reference.json', root))).cases[0];
const branch = process.argv[2] ?? 'native-tail';
assert(/^[a-z-]+$/.test(branch));
const tail = (await read(new URL(branch + '.json', results))).cases[0];
const steps = [...originalPrefix.steps, ...tail.steps];
assert.equal(originalPrefix.steps.length, 338);
if (branch === 'native-tail') assert.deepEqual(steps.slice(0, former.steps.length), former.steps);
const expected = steps.at(-1).ending?.text_pointer ?? null;
const scenario = { ...tail, steps, expected };

let completed = 0;
let lastClock;
let outcome;
try {
  outcome = await compareNaturalHistory(data, scenario, {
    onCheckpoint(index, session) {
      completed = index + 1;
      lastClock = session.game.world.clock();
      if (completed % 100 === 0) console.log(completed, lastClock.label);
    },
  });
} catch (error) {
  const missing = error.message.match(/^(\d+) Ingresso casuale originale non ancora ricostruito: \$([\dA-F]{4})\./);
  if (Number(missing?.[1]) !== completed) throw error;
  const address = Number.parseInt(missing[2], 16);
  const row = steps[completed];
  assert(row.random.some(draw => draw.reads.some(read => read.address === address)), error.message);
  outcome = { stoppedAt: missing[2], nextOriginalClock: row.after.clock };
}
const draws = steps.slice(0, completed).flatMap(row => row.random);
const report = {
  ...outcome, originalCheckpoints: steps.length, checkpoints: completed, lastClock,
  comparedDraws: draws.length, comparedReads: draws.reduce((n, draw) => n + draw.reads.length, 0),
  originalEnding: steps.at(-1).ending, verifiedEnding: completed === steps.length ? expected : null,
};
await writeFile(new URL(branch + '-comparison.json', results), JSON.stringify(report, null, 2) + '\n');
console.log(report);
