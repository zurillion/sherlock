// Offline comparison only; the application does not load these fixtures.
import {readFile,writeFile} from 'node:fs/promises';import assert from 'node:assert/strict';import{ClientSession}from'../src/session.mjs';
const root=new URL('../',import.meta.url),data=JSON.parse(await readFile(new URL('data/game.json',root))),ref=JSON.parse(await readFile(new URL('results/model-flags/natural-stores.json',root))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];
const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if([0xA01D,0xA01E].includes(address))reads.push({address:address.toString(16).toUpperCase(),value,actor:g.runtimeRandom.inFlight?.actor,tick:g.world.tick});return value;};
let out;
for(const[i,row]of ref.steps.entries()){
 out=row.input?s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):s.request('continue-command',{job:out.job});
 assert.notEqual(out.state.analysis.outcome,'not_translated',i+' '+out.state.prototype_notice);assert.equal(g.world.tick,row.clock.tick,'tick '+i);assert.deepEqual(g.world.npcs.modelFlags,row.flags,'flags '+i);
}
assert.deepEqual(reads,ref.reads.map(r=>({address:r.address,value:r.value,actor:r.actor,tick:r.clock.tick})));
const report={protocol:ref.protocol,checkpoints_compared:ref.steps.length,last_clock:g.world.clock(),raw_native_stores:ref.stores.length,actual_random_reads:reads,native_last_writers:ref.reads.map(r=>r.last_writer),same_values_at_every_checkpoint:true,full_game_equivalence:false};
await writeFile(new URL('results/model-flags/natural-verification.json',root),JSON.stringify(report,null,2)+'\n');console.log(report);
