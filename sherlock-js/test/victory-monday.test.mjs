import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { gunzipSync } from 'node:zlib';
import { compareNaturalHistory } from './helpers/compare-natural-history.mjs';

test('Natural victory route from boot to the Victoria finale, with the original random stream', async () => {
 const [dataFile, referenceFile] = await Promise.all([
  readFile(new URL('../data/game.json', import.meta.url)),
  readFile(new URL('fixtures/victory-monday-reference.json.gz', import.meta.url))
 ]);
 const [scenario, branch] = JSON.parse(gunzipSync(referenceFile)).cases;
 const data=JSON.parse(dataFile);let fork;
 await compareNaturalHistory(data,scenario,{onCheckpoint:async(index,session)=>{
  if(index===branch.fork_after)fork=(await session.request('save')).save;
 }});
 await compareNaturalHistory(data,branch,{initialSave:fork});
});
