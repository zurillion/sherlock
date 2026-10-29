import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';import {ClientSession} from '../src/session.mjs';import {Game} from '../src/game.mjs';import {assertOriginalState} from './helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/temporary-cost-reference.json',import.meta.url)));
for(const[index,steps]of ref.cases.entries())test('Shared operation cost: native full-state sequence '+index,async()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=session.game,observed=[];const absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);g.runtimeRandom.absolute=(...args)=>{observed.push([g.npcRuntime.read(0xA01F),g.npcRuntime.read(0xA020)]);return absolute(...args);};let out,mirror=null,mirrorOut=null,n=g.world.random.draws;
 for(const [i,row]of steps.entries()){
  const command=row.input?(row.input.startsWith('WAIT UNTIL')?'start-command':'command'):'continue-command',args=row.input?{command:row.input}:{job:out.job};
  out=session.request(command,args);if(mirror)mirrorOut=mirror.request(command,row.input?{command:row.input}:{job:mirrorOut?.job});
  assert.equal(Boolean(out.running),row.running);assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);
  assert.equal(g.npcRuntime.read(0xA01F),row.temporary_cost&255,'low #'+i);assert.equal(g.npcRuntime.read(0xA020),row.temporary_cost>>>8,'high #'+i);
  const count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];n=g.world.random.draws;assert.equal(draws.length,row.random.length,'draw count #'+i+' '+row.input);
  for(const[j,d]of row.random.entries())for(const k of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[j][k],d[k],i+' draw '+j+' '+k);
  assert.deepEqual(observed.splice(0),row.random.map(d=>[d.temporary_cost&255,d.temporary_cost>>>8]),'cost at each random entry #'+i);
  assertOriginalState(g,row.after,'cost sequence '+index+' #'+i);if(mirror)assert.deepEqual(mirror.game.dump(),g.dump(),'future after LOAD');
  if(!out.running){mirror=new ClientSession(data);await mirror.request('load',{save:JSON.parse(JSON.stringify((await session.request('save')).save))});mirrorOut=null;}
 }
});
test('Cost ownership: partial writes, unknown legacy cells and saved continuation',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),h=g.npcRuntime;
 h.temporaryCost(0x1234);h.temporaryCost(0x56,{lowOnly:true});assert.equal(h.read(0xA01F),0x56);assert.equal(h.read(0xA020),0x12);
 const restored=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.equal(restored.npcRuntime.read(0xA020),0x12);
 delete g.world.npcs.temporaryCost;const old=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.equal(old.npcRuntime.read(0xA020),null);old.npcRuntime.temporaryCost(3,{lowOnly:true});assert.equal(old.npcRuntime.read(0xA01F),3);assert.equal(old.npcRuntime.read(0xA020),null);old.npcRuntime.environment({},[],[]).beginStep();assert.equal(old.npcRuntime.read(0xA020),0);
});
