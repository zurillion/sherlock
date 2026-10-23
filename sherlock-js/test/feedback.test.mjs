import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';import {ClientSession} from '../src/session.mjs';import {SpectrumBuffer} from '../src/spectrum.mjs';
const read=async name=>JSON.parse(await readFile(new URL(name,import.meta.url),'utf8'));
const data=await read('../data/game.json'),reference=await read('./fixtures/feedback-reference.json'),paragraphs=await read('./fixtures/paragraph-reference.json');
const norm=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim().toUpperCase();
for(const trace of reference.cases.filter(c=>!['hail_with_drivers','hello_reading','hello_during_follow'].includes(c.label)))test('Original feedback trace: '+trace.label,()=>{
 const g=new Game(data,{npcs:trace.actors.includes(3)});if(trace.teleport)g.teleport(trace.teleport);
 for(const row of trace.commands){const out=g.submit(row.input);assert.notEqual(out.state.analysis.outcome,'not_translated',JSON.stringify(out.messages));
  for(const kind of ['narrative','error'])assert.equal(norm(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),norm(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input+' '+kind);
  assert.deepEqual(out.state.clock,row.clock,row.input+' clock');
  for(const e of row.entities){const a=g.world.entity(e.id);assert.deepEqual({id:a.id,parent:a.parent,rooms:a.rooms,attributes:a.attributes},e,row.input+' entity '+e.id);}
 }
});
function deliver(buffer,messages){let feeds=0;for(const m of messages)for(const e of m.screen_events||[]){if(e.op==='counter')buffer.counter=e.value;else if(e.op==='wide')buffer.setColumns(36);else if(e.op==='word')for(const op of buffer.packet(e))if(op==='line'){while(!buffer.newline())buffer.more();feeds++;}}return feeds;}
test('The blank line between commands matches native WAIT rows, counters and scrolls',()=>{
 const b=new SpectrumBuffer(),initial=paragraphs.initial;b.lines=structuredClone(initial.rows);b.counter=initial.counter;b.setColumns(initial.width);b.remaining=initial.columns_left;b.cursor=b.columns-b.remaining;
 const s=new ClientSession(data);
 for(const row of paragraphs.wait){const before=b.scrolls,out=s.request('command',{command:'WAIT'});assert.equal(deliver(b,out.messages),row.feeds);assert.deepEqual(b.lines,row.after.rows);assert.equal(b.counter,row.after.counter);assert.equal(b.remaining,row.after.columns_left);assert.equal(b.scrolls-before,2);}
});
test('There is one paragraph per player action, with no extra paragraph before an NPC reply',()=>{
 const s=new ClientSession(data),out=s.request('command',{command:'SAY TO WATSON "FOLLOW ME"'}),b=new SpectrumBuffer();
 assert.equal(out.messages.filter(m=>m.paragraph_before).length,1);deliver(b,out.messages);
 assert(b.lines.join('\n').includes('You talk to Watson.\nWatson climbs out of watsons'));
});
test('Minute batches do not add blank lines and a repeated action gets its own paragraph',()=>{
 const s=new ClientSession(data),b=new SpectrumBuffer();let r=s.request('start-command',{command:'WAIT'}),feeds=0;while(r.running){feeds+=deliver(b,r.messages);r=s.request('continue-command',{job:r.job});}feeds+=deliver(b,r.messages);assert.equal(feeds,2);
 const out=new ClientSession(data).request('command',{command:'WAIT. WAIT'});assert.equal(out.messages.filter(m=>m.paragraph_before).length,2);assert.equal(deliver(b,out.messages),4);
});
test('Input errors leave the upper text alone',()=>{
 const s=new ClientSession(data),b=new SpectrumBuffer();deliver(b,s.request('command',{command:'WAIT'}).messages);const before=[...b.lines];
 deliver(b,s.request('command',{command:'XYZZY'}).messages);deliver(b,s.request('command',{command:'OPEN DOOR'}).messages);assert.deepEqual(b.lines,before);
});
test('A legacy pending greeting remains loadable but never invents a reply',async()=>{
 const g=Game.load(data,await read('./fixtures/legacy-pending-hello.json'));
 const out=g.submit('WAIT');assert(out.messages.some(m=>m.kind==='system'&&m.text.includes('casuale')));
 assert(!out.messages.some(m=>/Watson says/.test(m.text)));
});
test('Unimplemented seeded greetings are refused before queuing or advancing the world',()=>{
 const g=new Game(data),before=g.world.dump();
 for(let i=0;i<8;i++){
  const out=g.submit('SAY TO WATSON "HELLO"');assert.equal(out.state.analysis.outcome,'not_translated');
  assert(out.messages.every(m=>m.kind==='system'));assert.deepEqual(g.world.dump(),before);
 }
 assert.equal(g.state().greeting_variant,'unimplemented-original-random-source');
 assert.equal(g.state().fidelity.original_seed_parity,false);
 assert.throws(()=>g.text.greeting(3),/casuale/);
});
test('Unquoted HELLO retains the original HI. response without taking a turn',()=>{
 const g=new Game(data),before=g.world.dump();
 for(const command of ['HELLO','HELLO WATSON']){const out=g.submit(command);assert.equal(out.state.analysis.outcome,'ok');assert.equal(out.messages[0].text,'HI.');assert.equal(out.messages[0].kind,'error');assert.deepEqual(g.world.dump(),before);}
});
test('The cab arrives on every road in its original network, with driver and money descendants',()=>{
 for(const room of data.cab.streets){const g=new Game(data,{npcs:false});g.teleport(room);const out=g.submit('HAIL CAB');assert.equal(out.state.analysis.outcome,'ok');assert.equal(g.world.roomOf(30),room);assert.equal(g.world.roomOf(31),room);assert.equal(g.world.roomOf(32),room);assert(out.state.characters.some(c=>c.id===31&&c.rooms.includes(room)&&c.badge==='C1'));}
});
test('Cab call and containment survive a logical save; unported journeys stay explicit',()=>{
 const a=new Game(data,{npcs:false});a.teleport(5);a.submit('HAIL CAB');a.submit('GET INTO CAB');const b=Game.load(data,JSON.parse(JSON.stringify(a.dump())));
 assert.deepEqual(a.submit('GET OUT OF CAB'),b.submit('GET OUT OF CAB'));assert.equal(a.world.entity(27).parent,0);
 const before=a.world.dump(),out=a.submit('SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"');assert.equal(out.state.analysis.outcome,'not_translated');assert.deepEqual(a.world.dump(),before);assert.equal(a.state().cab_scope,'arrival-and-containment');
});
