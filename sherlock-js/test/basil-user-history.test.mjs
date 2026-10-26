import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {ClientSession} from '../src/session.mjs';
import {Game} from '../src/game.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
import {assertOriginalState} from './helpers/original-state.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url))),data=await read('../data/game.json');
function packets(screen,events){for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const a of screen.packet(e))if(a==='line')while(!screen.newline())screen.more();}}
test('Exact user Basil history: native seed-1 sequence crosses the former stall without a controlled cursor and retains its save/load future',async()=>{
 const ref=await read('fixtures/basil-user-reference.json'),session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),screen=new SpectrumBuffer();packets(screen,session.state().opening_screen);
 let loaded=null,passedStall=false,alibi=false;
 assert.equal(ref.steps.length,115);
 for(const[i,row]of ref.steps.entries()){
  assert.equal(row.kind,'command');const label='#'+(i+1)+' '+row.input,g=session.game,start=g.world.random.draws,out=session.request('command',{command:row.input}),n=g.world.random.draws-start,draws=n?g.world.random.trace.slice(-n):[];
  assert.equal(out.state.analysis.outcome,'ok',label+' '+out.state.prototype_notice);assert.equal(draws.length,row.random.length,label+' draw count');
  for(const[j,d]of row.random.entries())for(const key of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[j][key],d[key],label+' draw '+j+' '+key);
  if(i===98){passedStall=true;assert.equal(g.world.clock().label,'Mon 11:55am');}
  if(out.messages.some(m=>m.text.includes('Chopin')))alibi=true;
  assertOriginalState(g,row.after,label);
  for(const m of out.messages)packets(screen,m.screen_events);assert.deepEqual(screen.lines,g.world.display.upper,label+' page text packets');
  if(loaded){const other=loaded.request('command',{command:row.input});assert.deepEqual(other,out,label+' loaded response');assert.deepEqual(loaded.game.dump(),g.dump(),label+' loaded successor');}
  if(i===97){assert.equal(g.world.clock().label,'Mon 11:54am');loaded=new ClientSession(data,{npc_profile:'world-v5'});loaded.game=Game.load(data,JSON.parse(JSON.stringify(g.dump())));}
 }
 assert(alibi);assert(passedStall);assert.equal(session.game.world.clock().label,'Mon 12:11pm');
});
test('Complete supplied journal, including former retries and map teleports, remains executable',async()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),lines=(await readFile(new URL('../results/fact-boundary/user-history.txt',import.meta.url),'utf8')).split('\n');let commands=0,teleports=0;
 for(const line of lines){if(line.startsWith('# Teletrasporto:')){session.request('teleport',{room:parseInt(line.split(':')[1])});teleports++;continue;}if(!line||line.startsWith('#'))continue;
  const out=session.request('command',{command:line});commands++;assert.notEqual(out.state.analysis.outcome,'not_translated',line+' '+out.state.prototype_notice);
 }
 assert.equal(commands,106);assert.equal(teleports,2);assert.equal(session.game.world.roomOf(),67);assert.equal(session.game.world.clock().label,'Mon 12:02pm');
});
test('Published recovered save restores the verified 11:54 state and continues with the original future',async()=>{
 const ref=await read('fixtures/basil-user-reference.json'),save=await read('../results/fact-boundary/sherlock-seed1-ripresa-1154.json'),session=new ClientSession(data,{npc_profile:'world-v5'}),loaded=await session.request('load',{save});
 assert.equal(session.game.history.entries.length,98);assert.equal(session.game.history.origin,'rebuilt-user-history-before-stall');assertOriginalState(session.game,ref.steps[97].after,'recovered save');assert.deepEqual(loaded.presentation.spectrum.model.lines,session.game.world.display.upper);
 for(const row of ref.steps.slice(98)){const out=session.request('command',{command:row.input});assert.equal(out.state.analysis.outcome,'ok');assertOriginalState(session.game,row.after,'recovered '+row.after.clock.label);}
});
