import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{gunzipSync}from'node:zlib';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('fixtures/npc-handover.json.gz',import.meta.url))));
for(const[index,c]of ref.cases.entries())test('Native NPC handover '+index+' / '+c.steps[0].input,()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});let loaded=null;
 for(const row of c.steps){const n=g.world.random.draws,out=g.submit(row.input),count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);assert.equal(g.world.entity(27).parent??255,row.money_parent,'money owner '+row.input);assert.equal(g.world.entity(22).parent??255,row.lamp_parent,'lamp owner '+row.input);assert.equal(draws.length,row.random.length,'draws '+row.input);for(const[i,d]of row.random.entries())for(const k of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],row.input+' draw'+i+' '+k);assertOriginalState(g,row.after,row.input);if(loaded){assert.deepEqual(loaded.submit(row.input),out);assert.deepEqual(loaded.dump(),g.dump(),'future after LOAD');}loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));}
});

test('GIVE semantic roles preserve physical syntax and are idempotent',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});
 for(const text of ['GIVE WATSON MONEY','GIVE ME MY MONEY','GIVE WATSON ALL','GIVE TO WATSON MONEY','GIVE ALL TO WATSON','GIVE WATSON','GIVE']){
  const raw=g.parser.parse(text).nodes[0],before=structuredClone(raw),node=g.semanticNode(raw);
  assert.deepEqual(raw,before,'physical syntax '+text);
  assert.deepEqual(g.semanticNode(node),node,'semantic roles '+text);
  assert.deepEqual(node.sourceGroupOrder,[1,0],text);
 }
 const raw=g.parser.parse('GIVE MONEY TO WATSON').nodes[0];
 assert.equal(g.semanticNode(raw),raw,'standard TO form keeps its roles');
});
