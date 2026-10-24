import test from 'node:test';
import {createHash} from 'node:crypto';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
import {ClientSession} from '../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
const reference=JSON.parse(await readFile(new URL('./fixtures/runtime-watson-reference.json',import.meta.url),'utf8'));
const prose=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim();
const drawFields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
for(const trace of reference.cases)test('Generated runtime inputs and Watson exchanges within declared profile: '+trace.label,()=>{
 const session=new ClientSession(data),g=session.game,screen=new SpectrumBuffer();
 const deliver=events=>{for(const e of events){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};
 deliver(session.state().opening_screen);if(trace.seed_after_prompt!==null){g.world.random.seed=trace.seed_after_prompt;g.world.random.cursor=0;}
 for(const [i,row] of trace.commands.entries()){
  const before=g.world.random.draws,out=session.request('command',{command:row.input}),count=g.world.random.draws-before,calls=count?g.world.random.trace.slice(-count):[];
  assert.equal(out.state.analysis.outcome,'ok',JSON.stringify({i,input:row.input,messages:out.messages}));
  assert.equal(calls.length,row.random.length,'draw count at '+i);
  for(const [j,expected] of row.random.entries())for(const field of drawFields)assert.deepEqual(calls[j][field],expected[field],`${trace.label} command ${i+1}, draw ${j+1}, ${field}`);
  for(const kind of ['narrative','error'])assert.equal(prose(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),prose(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input);
  if(row.upper_sha256){const pixels=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)pixels.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));assert.equal(createHash('sha256').update(Uint8Array.from(pixels)).digest('hex'),row.upper_sha256,'Generated upper bitmap at '+trace.label+' command '+(i+1));}
  for(const message of out.messages)deliver(message.screen_events||[]);assert.deepEqual(screen.lines,g.world.display.upper,'Actual UI text rows at '+trace.label+' command '+(i+1));
  assert.deepEqual(out.state.clock,row.clock);assert.equal(g.world.scheduler.actor(3).due,row.watson_due);assert.deepEqual(g.world.scheduler.actor(3).behavior.encounters,row.encounters);
  for(const expected of row.entities){const e=g.world.entity(expected.id);assert.deepEqual({id:e.id,parent:e.parent,rooms:e.rooms},expected);}
 }
});
test('Save/load preserves generated future replies, source pixels and pending requests',()=>{
 const a=new Game(data);for(let i=0;i<8;i++)a.submit('SAY TO WATSON "HELLO"');a.submit('SAY TO WATSON "WAIT"');a.submit('SAY TO WATSON "HELLO"');
 const b=Game.load(data,JSON.parse(JSON.stringify(a.dump())));
 for(let i=0;i<12;i++){const command=i%3?'SAY TO WATSON "HELLO"':'SAY TO WATSON "TELL ME ABOUT LESTRADE"';assert.deepEqual(a.submit(command),b.submit(command));assert.deepEqual(a.dump(),b.dump());}
});
test('The actual web session returns a greeting in the upper output',()=>{
 const session=new ClientSession(data),reply=session.request('command',{command:'SAY TO WATSON "HELLO"'});
 assert(reply.messages.some(m=>m.kind==='narrative'&&m.text==='Watson says " Hello ".'));
 assert(reply.messages.find(m=>m.text.includes('Watson says')).screen_events.some(e=>e.op==='word'&&e.text==='Hello'));
 assert.equal(reply.state.clock.label,'Mon 08:01am');assert.equal(reply.state.fidelity.full_game_equivalence,false);
});

test('An unknown random input rolls back its action and speculative clock frames',()=>{
 const s=new ClientSession(data);s.game.world.random.cursor=0x5B10;
 const before=s.game.world.dump(),reply=s.request('start-command',{command:'SAY TO WATSON "HELLO"'});
 assert.equal(reply.running,false);assert.equal(reply.state.analysis.outcome,'not_translated');
 assert(reply.messages.some(m=>m.kind==='system'&&m.text.includes('$5C10')));
 const after=s.game.world.dump();delete before.display;delete after.display;assert.deepEqual(after,before);assert.equal(s.game.lastFrames.length,0);
});
