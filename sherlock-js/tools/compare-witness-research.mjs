// Full research comparison intentionally remains separate from certified prefixes.
import{gunzipSync}from'node:zlib';import test from'node:test';import{readFile}from'node:fs/promises';import{compareNaturalHistory}from'../test/helpers/compare-natural-history.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('../results/final-solution/witness-native-reference.json.gz',import.meta.url))));
for(const c of ref.cases.filter(c=>c.label==='major-witness'))test('Research comparison / '+c.label,async t=>{t.diagnostic(JSON.stringify(await compareNaturalHistory(data,c)));});
