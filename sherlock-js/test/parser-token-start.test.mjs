import{tokenWidth}from'../src/lexer.mjs';
import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{gunzipSync}from'node:zlib';import{ClientSession}from'../src/session.mjs';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('../results/parser-token-start/natural-reference.json.gz',import.meta.url))));
for(const[index,c]of ref.cases.entries())if(![4,8].includes(index))test('Original token-start lifecycle '+index,()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game;let seen=[],out;const value=()=>g.world.npcs.parserTokenStart??null,absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);g.runtimeRandom.absolute=(...a)=>{seen.push(value());return absolute(...a);};assert.equal(value(),c.initial);assert.deepEqual(c.unclassified_transitions,[]);
 for(const[rowIndex,row]of c.steps.entries()){seen=[];const n=g.world.random.draws;out=row.input?s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input}):s.request('continue-command',{job:out.job});assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);assert.equal(value(),row.token_start,'cursor after '+row.input);assert.deepEqual(seen,row.random.map(d=>d.token_start),'cursor at each draw '+row.input);
 const count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];assert.equal(draws.length,row.random.length);for(const[i,d]of row.random.entries())for(const k of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],row.input+' '+k);assertOriginalState(g,row.after,'token cursor '+index+'/'+rowIndex);if(!out.running){const save=JSON.parse(JSON.stringify(g.dump()));assert.deepEqual(Game.load(data,save).dump(),save);}
 }
});
test('Token start survives SAVE/LOAD; old saves do not invent a pointer',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});g.submit('I');const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).npcRuntime.read(0xA029),0x84);delete save.world.npcs.parserTokenStart;const old=Game.load(data,save);assert.equal(old.npcRuntime.read(0xA029),null);assert.equal(old.npcRuntime.read(0xA02A),null);assert.throws(()=>old.runtimeRandom.read(0xA029),/\$A029/);old.submit('I');assert.equal(old.npcRuntime.read(0xA029),0x84);
});

test('Original AE7F ABI: all token classes, payload widths and four seed boots',async()=>{
 const abi=JSON.parse(await readFile(new URL('../results/parser-token-start/reader-abi.json',import.meta.url)));assert.equal(abi.cases.length,48);
 for(const c of abi.cases){assert.equal(c.start,c.pointer);assert.equal(c.next,c.pointer+tokenWidth(c.type));assert.equal(c.result_class,c.type);assert.equal(c.previous_class,112);assert.equal(c.value,tokenWidth(c.type)===3?0x1234:0);}
 for(const b of abi.boot){assert.equal(b.pointer,data.argumentChecks.initialParserTokenStart);assert.equal(new ClientSession(data,{npc_profile:'world-v5',seed:b.seed}).game.world.npcs.parserTokenStart,b.pointer);}
});
