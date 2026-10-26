import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
import {ClientSession,gameStatus} from '../src/session.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
import {assertOriginalState as snapshot} from './helpers/original-state.mjs';
const read=async name=>JSON.parse(await readFile(new URL(name,import.meta.url))),data=await read('../data/game.json');
const prefix=await read('fixtures/lestrade-natural-reference.json');
const legacy=structuredClone(data);legacy.randomInputs.worldLayout.tables=legacy.randomInputs.worldLayout.tables.filter(t=>t.start!==0x99FB);
test('The fact table terminator is an immutable table entry, separate from mutable facts and handler code',()=>{
 const g=new Game(data,{npc_profile:'world-v5'}),facts=g.world.npcs.facts,last=facts.at(-1);assert.equal(last.start+6+last.terms.length*2,0x99FB);assert.deepEqual(data.randomInputs.worldLayout.tables.find(t=>t.start===0x99FB),{start:0x99FB,values:[255],kind:'fact-table-terminator'});
 assert.equal(g.runtimeRandom.read(0x99FB),255);last.flags^=3;last.terms[last.terms.length-1]^=0x200;assert.equal(g.runtimeRandom.read(0x99FB),255);assert.equal(g.runtimeRandom.read(0x99FC),0xCD);assert.equal(g.runtimeRandom.read(0xD7FB),0);
});
test('A missing random dependency repeats after rollback and must not promise that another command will work',()=>{
 const g=new Game(legacy,{npc_profile:'world-v5'});g.world.random.cursor=0x98FB;const before=g.dump();
 for(const command of ['I','WAIT','I']){const out=g.submit(command);assert.equal(out.state.analysis.outcome,'not_translated');assert.equal(out.state.analysis.missing_address,0x99FB);assert.equal(out.state.analysis.recovery,'requires-engine-update');assert.deepEqual(g.world.dump(),before.world);assert.equal(g.lastFrames.length,0);assert(!/puoi continuare/.test(gameStatus(out.state)));assert.match(gameStatus(out.state),/Puoi salvare la partita/);}
 const updated=Game.load(data,JSON.parse(JSON.stringify(g.dump()))),out=updated.submit('I');assert.equal(out.state.analysis.outcome,'ok');assert.equal(updated.world.minutes,481);assert(updated.world.random.trace.some(d=>d.reads.some(r=>r.address===0x99FB&&r.value===255)));
});
test('After Basil alibi: controlled original $99FB read, all actors and exact future state after load',async()=>{
 const ref=await read('fixtures/fact-boundary-reference.json'),session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),screen=new SpectrumBuffer();
 const deliver=events=>{for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const a of screen.packet(e))if(a==='line')while(!screen.newline())screen.more();}};
 deliver(session.state().opening_screen);let alibi=false;
 for(const row of prefix.steps.slice(0,109)){const out=session.request('command',{command:row.input});assert.notEqual(out.state.analysis.outcome,'not_translated');for(const m of out.messages){if(m.text.includes('Chopin'))alibi=true;deliver(m.screen_events);}}
 assert(alibi);assert.equal(session.game.world.clock().label,'Mon 11:53am');assert.equal(ref.skipped_prefix_events,109);assert.equal(ref.steps.length,21);let loaded;
 for(const[i,row]of ref.steps.entries()){
  const g=session.game,label='#'+i+' '+JSON.stringify(row.input);
  if(row.kind==='setup'){assert.deepEqual(row.input,{random_cursor:0x98FB});g.world.random.cursor=row.input.random_cursor;snapshot(g,row.after,label);loaded=new ClientSession(data,{npc_profile:'world-v5'});loaded.game=Game.load(data,JSON.parse(JSON.stringify(g.dump())));continue;}
  const n=g.world.random.draws,out=session.request('command',{command:row.input}),count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];
  assert.equal(out.state.analysis.outcome,'ok',label+' '+out.state.prototype_notice);assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,d]of row.random.entries())for(const key of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[j][key],d[key],label+' draw '+j+' '+key);
  if(i===5)assert(out.messages.some(m=>m.text==='Someone closes the diningroom door.'));
  snapshot(g,row.after,label);const other=loaded.request('command',{command:row.input});assert.deepEqual(other,out,label+' loaded response');assert.deepEqual(loaded.game.dump(),g.dump(),label+' loaded future');for(const m of out.messages)deliver(m.screen_events);assert.deepEqual(screen.lines,g.world.display.upper,label+' browser packets');
 }
 assert(ref.steps.some(s=>s.random.some(d=>d.reads.some(r=>r.address===0x99FB&&r.value===255))));
});
