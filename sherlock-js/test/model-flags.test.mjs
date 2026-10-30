import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';import{gunzipSync}from'node:zlib';import{ClientSession}from'../src/session.mjs';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('fixtures/model-flags-reference.json.gz',import.meta.url))));
for(const[index,c]of ref.cases.entries())test('Native action-model flag lifecycle '+index,async()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game;let seen=[],loaded=null,out;
 const flags=()=>[g.npcRuntime.read(0xA01D),g.npcRuntime.read(0xA01E)],absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);
 g.runtimeRandom.absolute=(...a)=>{seen.push(flags());return absolute(...a);};assert.deepEqual(flags(),c.initial,'boot');
 for(const row of c.steps){seen=[];const n=g.world.random.draws;
 out=row.input?s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):s.request('continue-command',{job:out.job});
 assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);assert.deepEqual(flags(),row.model_flags,'flags after '+row.input);
 assert.deepEqual(seen,row.random.map(d=>d.model_flags),'flags at every draw '+row.input);
 const count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];assert.equal(draws.length,row.random.length);
 for(const[i,d]of row.random.entries())for(const k of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],row.input+' '+k);
 assertOriginalState(g,row.after,row.input);
 if(loaded&&row.input&&!row.input.startsWith('WAIT UNTIL')){loaded.submit(row.input);assert.deepEqual(loaded.dump(),g.dump(),'future after LOAD');}
 loaded=out.running?null:Game.load(data,JSON.parse(JSON.stringify(g.dump())));
 }
});
test('Old absent model flags stay unknown through dry runs and lexical errors',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),saved=JSON.parse(JSON.stringify(g.dump()));delete saved.world.npcs.modelFlags;const old=Game.load(data,saved);
 assert.equal(old.npcRuntime.read(0xA01D),null);const before=old.dump();old.parser.analyze('OPEN ALL');assert.deepEqual(old.dump(),before);old.submit('XYZZY');assert.equal(old.npcRuntime.read(0xA01D),null);
 old.npcRuntime.setActionClasses(14);assert.deepEqual(old.world.npcs.modelFlags,data.actions.find(a=>a.id===14).modelFlags);
});
test('All 54 model flag pairs and class calculations agree with the native decoder',async()=>{
 const abi=JSON.parse(await readFile(new URL('../results/model-flags/abi.json',import.meta.url)));
 for(const c of abi.cases){const raw=c.raw,flags=[(raw[1]>>>4)|(raw[3]&240),(raw[5]>>>4)|(raw[7]&240)];assert.deepEqual(flags,c.flags);
 if(c.action){const model=data.actions.find(a=>a.id===c.action);assert.deepEqual(model.modelFlags,c.flags);assert.deepEqual(model.classes,c.classes);}}
});
test('Four native cold boots establish loaded data and actual first-prompt flags',async()=>{
 const boot=JSON.parse(await readFile(new URL('../results/model-flags/boot-verification.json',import.meta.url)));
 for(const c of boot.cases){const g=new Game(data,{npc_profile:'world-v5',seed:c.seed});assert.deepEqual(data.argumentChecks.initialModelFlags,c.entry);assert.deepEqual(g.world.npcs.modelFlags,c.final);}
});
test('Native visible and off-stage internal movement announcements update the model flags',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/model-flags/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1});let out;
 for(const[i,row]of ref.steps.slice(0,254).entries()){
  out=row.input?s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):s.request('continue-command',{job:out.job});
  assert.notEqual(out.state.analysis.outcome,'not_translated');assert.equal(s.game.world.tick,row.clock.tick);assert.deepEqual(s.game.world.npcs.modelFlags,row.flags,'checkpoint '+i);
 }
});
