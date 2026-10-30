// Offline acceptance comparison. The playable engine never reads this fixture.
import {readFile,writeFile} from 'node:fs/promises';
import {gunzipSync} from 'node:zlib';
import {compareNaturalHistory} from '../test/helpers/compare-natural-history.mjs';
const root=new URL('../',import.meta.url),data=JSON.parse(await readFile(new URL('data/game.json',root))),reference=JSON.parse(gunzipSync(await readFile(new URL('results/final-solution/witness-native-reference.json.gz',root))));
const c=reference.cases.find(c=>c.label==='major-witness'),prefix={...c,steps:c.steps.slice(0,374),expected:null};
const result={protocol:'Natural seed-1, all 24 actor slots, free initial LOOK, original graphics off after boot, injected uppercase keys and immediate MORE. No teleport or world patches. Every random draw/read, scheduler, entities, facts, all arena bytes and exact bitmaps compared; LOAD follows each completed input and each live WAIT minute.',...await compareNaturalHistory(data,prefix),compared_random_draws:prefix.steps.reduce((n,r)=>n+r.random.length,0),compared_random_reads:prefix.steps.reduce((n,r)=>n+r.random.reduce((n,d)=>n+d.reads.length,0),0),certified_checkpoint_range:[0,373],full_history_checkpoints:c.steps.length,full_ending_certified:false,next_boundary:{checkpoint:374,target_clock:c.steps[374].after.clock.label,resolved_address:'A01D/A01E',unknown_address:'5D1E',note:'No captured or initial byte is installed as a fallback.'}};
await writeFile(new URL('results/model-flags/witness-prefix.json',root),JSON.stringify(result,null,2)+'\n');console.log(result);
