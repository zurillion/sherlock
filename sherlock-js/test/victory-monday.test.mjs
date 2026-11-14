import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { gunzipSync } from 'node:zlib';
import { compareNaturalHistory } from './helpers/compare-natural-history.mjs';

test('Natural Sherlock routes from boot through the Victoria and late-sale endings', async () => {
 const [dataFile, referenceFile, lateSaleFile] = await Promise.all([
  readFile(new URL('../data/game.json', import.meta.url)),
  readFile(new URL('fixtures/victory-monday-reference.json.gz', import.meta.url)),
  readFile(new URL('../results/final-solution/late-sale-native-suffix.json.gz', import.meta.url))
 ]);
 const [scenario, branch] = JSON.parse(gunzipSync(referenceFile)).cases;
 const [lateSale] = JSON.parse(gunzipSync(lateSaleFile)).cases;
 const data=JSON.parse(dataFile),saves=new Map();
 await compareNaturalHistory(data,scenario,{onCheckpoint:async(index,session)=>{
  if(index===branch.fork_after||index===lateSale.fork_after)saves.set(index,(await session.request('save')).save);
 }});
 await compareNaturalHistory(data,branch,{initialSave:saves.get(branch.fork_after)});
 await compareNaturalHistory(data,lateSale,{initialSave:saves.get(lateSale.fork_after)});
});
