import test from 'node:test';import assert from 'node:assert/strict';import {gunzipSync} from 'node:zlib';import {readFile} from 'node:fs/promises';import {ClientSession} from '../src/session.mjs';import {Game} from '../src/game.mjs';import {assertOriginalState} from './helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('fixtures/argument-check-reference.json.gz',import.meta.url))));
for(const[index,c]of ref.cases.entries())test('Argument check residual: native full-state sequence '+index,async()=>{
 const steps=c.steps;const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=session.game,observed=[],writes=[];const write=g.npcRuntime.checks.write.bind(g.npcRuntime.checks);g.npcRuntime.checks.write=value=>{writes.push(value);write(value);};const absolute=g.runtimeRandom.absolute.bind(g.runtimeRandom);g.runtimeRandom.absolute=(...args)=>{observed.push(g.npcRuntime.read(0xA021));return absolute(...args);};let out,mirror=null,mirrorOut=null,n=g.world.random.draws;
 for(const [i,row]of steps.entries()){
  const command=row.input?(row.input.startsWith('WAIT UNTIL')?'start-command':'command'):'continue-command',args=row.input?{command:row.input}:{job:out.job};
  out=session.request(command,args);if(mirror)mirrorOut=mirror.request(command,row.input?{command:row.input}:{job:mirrorOut?.job});
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.errors,'original errors #'+i+' '+row.input);
  assert.equal(Boolean(out.running),row.running);assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);
  assert.deepEqual(writes.splice(0),row.events.map(e=>e.value),'actual writes #'+i+' '+row.input);
  assert.equal(g.npcRuntime.read(0xA021),row.argument_check,'A021 #'+i+' '+row.input);
  const count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];n=g.world.random.draws;assert.equal(draws.length,row.random.length,'draw count #'+i+' '+row.input);
  for(const[j,d]of row.random.entries())for(const k of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[j][k],d[k],i+' draw '+j+' '+k);
  assert.deepEqual(observed.splice(0),row.random.map(d=>d.argument_check),'A021 at each random entry #'+i);
  assertOriginalState(g,row.after,'argument-check sequence '+index+' #'+i);if(mirror)assert.deepEqual(mirror.game.dump(),g.dump(),'future after LOAD');
  if(!out.running){mirror=new ClientSession(data);await mirror.request('load',{save:JSON.parse(JSON.stringify((await session.request('save')).save))});mirrorOut=null;}
 }
});
