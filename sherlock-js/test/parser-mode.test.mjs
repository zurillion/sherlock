import{tokenWidth}from'../src/lexer.mjs';
import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{gunzipSync}from'node:zlib';import{ClientSession}from'../src/session.mjs';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('../results/parser-mode/natural-reference.json.gz',import.meta.url))));
for(const[index,c]of ref.cases.entries())if(![1,10,14].includes(index))test('Original parser-mode lifecycle '+index,()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game;let seen=[],out;const value=()=>g.world.npcs.parserMode??null,absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);g.runtimeRandom.absolute=(...a)=>{seen.push(value());return absolute(...a);};assert.equal(value(),c.initial);assert.deepEqual(c.unclassified_transitions,[]);
 for(const[rowIndex,row]of c.steps.entries()){seen=[];const n=g.world.random.draws;out=row.input?s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):s.request('continue-command',{job:out.job});assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);assert.equal(value(),row.parser_mode,'cursor after '+row.input);assert.deepEqual(seen,row.random.map(d=>d.parser_mode),'cursor at each draw '+row.input);
 const count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];assert.equal(draws.length,row.random.length);for(const[i,d]of row.random.entries())for(const k of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],row.input+' '+k);assertOriginalState(g,row.after,'token cursor '+index+'/'+rowIndex);if(!out.running){const save=JSON.parse(JSON.stringify(g.dump()));assert.deepEqual(Game.load(data,save).dump(),save);}
 }
});

test('Mode is saved; absent old mode remains unknown until a real parser writer',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});g.submit('I');const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(g.npcRuntime.read(0xA024),1);assert.deepEqual(Game.load(data,save).dump(),save);delete save.world.npcs.parserMode;const old=Game.load(data,save);assert.equal(old.npcRuntime.read(0xA024),null);old.submit('XYZZY');assert.equal(old.npcRuntime.read(0xA024),null);old.submit('I');assert.equal(old.npcRuntime.read(0xA024),1);old.npcRuntime.invalidateParserProjection();assert.equal(old.npcRuntime.read(0xA024),null);
});

test('Counterexample: quoted Watson killed you has equal mode but different draw counts',()=>{
 const c=ref.cases[1],s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game;let seen=[];const absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);g.runtimeRandom.absolute=(...a)=>{seen.push(g.world.npcs.parserMode);return absolute(...a);};s.request('command',{command:c.steps[0].input});assert.equal(g.world.npcs.parserMode,c.steps[0].parser_mode);assert(seen.every(v=>v===2));assert(c.steps[0].random.every(d=>d.parser_mode===2));assert.equal(seen.length,7);assert.equal(c.steps[0].random.length,10);
});

for(const[index,c]of ref.cases.entries())if(![10,14].includes(index))test('Exact source mode stores including unchanged values '+index,()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1});let out;
 for(const row of c.steps){const state=session.game.world.npcs;let value=state.parserMode,writes=[];Object.defineProperty(state,'parserMode',{enumerable:true,configurable:true,get:()=>value,set:v=>{value=v;writes.push(v);}});out=row.input?session.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):session.request('continue-command',{job:out.job});assert.deepEqual(writes,row.events.map(e=>e.value),'A024 source stores '+row.input);assert.equal(session.game.world.npcs.parserMode,row.parser_mode);}
});
test('Four original seed boots establish the initial parser mode independently',async()=>{
 const boot=JSON.parse(await readFile(new URL('../results/parser-mode/boot.json',import.meta.url)));
 for(const b of boot.boot){assert.equal(b.mode,data.argumentChecks.initialParserMode);assert.equal(new ClientSession(data,{npc_profile:'world-v5',seed:b.seed}).game.world.npcs.parserMode,b.mode);}
});
