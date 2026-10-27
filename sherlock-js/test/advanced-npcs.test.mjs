import test from 'node:test';import assert from 'node:assert/strict';import {readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/advanced-npcs-reference.json',import.meta.url)));
for(const[index,row]of ref.cases.entries())test('Original advanced NPC rule/callback #'+index+' '+JSON.stringify(row.setup),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});g.submit('I');const w=g.world,c=row.setup,h=g.npcRuntime,messages=[],n=w.random.draws;
 if('accumulator'in c)w.random.seed=c.accumulator;
 if(c.kind==='body'){if(c.near){w.entity(c.actor).parent=null;w.entity(c.actor).rooms=[w.roomOf()];}h.use(()=>h.advanced.body(c.name,[255,255],{actor:c.actor,saved:[255,255,255]},messages));}
 else{w.minutes=(c.hour%12+(c.period==='pm'?12:0))*60+1;w.npcs.nightRest={5:0,8:0,9:0};w.npcs.nightRest[c.actor]=c.saved;if(c.saved){w.entity(c.actor).rooms=[c.actor===5?74:0];w.entity(c.actor).parent=null;h.advanced.describe(c.actor,0x7F0,16,false);}h.callback(w.scheduler.actor(c.actor),w.scheduler.actor(c.actor).due,messages);assert.deepEqual(w.npcs.nightRest,row.rest);}
 const count=w.random.draws-n,draws=count?w.random.trace.slice(-count):[];assert.equal(draws.length,row.random.length);for(const[i,d]of row.random.entries())for(const k of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],'Draw '+i+' '+k);
 assertOriginalState(g,row.after,'Controlled '+index);if(c.kind==='sleep')assert(g.state().characters.some(e=>e.id===c.actor),'Sleeping actor remains identifiable on map');const saved=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.deepEqual(saved.dump(),g.dump(),'Portable complete state');
});
