import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {ClientSession,engineStatus} from '../src/session.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
const reference=JSON.parse(await readFile(new URL('fixtures/world-npc-reference.json',import.meta.url),'utf8'));
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
// Prose assertion has narrower scope than IO: case preserved, spaces/quote
// padding normalized. Separate exact upper-bitmap and UI-row assertions below.
const prose=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim();
function bitmap(game){const bytes=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)bytes.push(game.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return createHash('sha256').update(Uint8Array.from(bytes)).digest('hex');}
function snapshot(g,expected,label,{bitmapExact=true}={}){
 assert.deepEqual(g.world.clock(),expected.clock,label+' clock');
 for(const row of expected.entities){const e=g.world.entity(row.id);for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(e[key],row[key],label+` entity ${row.id} ${key}`);}
 for(const row of expected.actors){const a=g.world.scheduler.actor(row.id),s=row.id===0?{pc:'9923',saved:g.world.npcs.playerRootSaved}:g.world.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' due '+row.id);assert.equal(s.pc,row.pc,label+' pc '+row.id);assert.deepEqual(s.saved,row.saved,label+' saved '+row.id);}
 const records=RecordLists.load(g.world.npcs.records);
 for(const name of ['counters','contexts','signals'])assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:name==='contexts'?7:2},(_,i)=>records.arena.byte(p+i))})),expected.records[name],label+' '+name);
 assert.deepEqual({seed:g.world.random.seed,cursor:g.world.random.cursor},expected.random_state,label+' source state');
 if(bitmapExact&&expected.upper_sha256)assert.equal(bitmap(g),expected.upper_sha256,label+' exact native upper bitmap');
}
for(const scenario of reference.cases)test('Seeded world, all 24 actor visits, generated inputs: '+scenario.label,()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:scenario.seed}),g=session.game,screen=new SpectrumBuffer();
 const deliver=events=>{for(const e of events){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};
 snapshot(g,scenario.initial,scenario.label+' bootstrap');deliver(session.state().opening_screen);
 if(scenario.teleport){const out=session.request('teleport',{room:scenario.teleport});for(const m of out.messages)deliver(m.screen_events||[]);}
 for(const [i,row]of scenario.commands.entries()){
  const label=`${scenario.label} ${i+1} ${row.input}`,before=g.world.random.draws,out=session.request('command',{command:row.input}),count=g.world.random.draws-before,calls=count?g.world.random.trace.slice(-count):[];
  assert.equal(out.state.analysis.outcome,'ok',label+JSON.stringify(out.messages));assert.equal(calls.length,row.random.length,label+' draw count');
  for(const [j,expected]of row.random.entries())for(const field of fields)assert.deepEqual(calls[j][field],expected[field],label+` draw ${j+1} ${field}`);
  for(const kind of ['narrative','error'])assert.equal(prose(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),prose(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),label+' '+kind);
  // NativeWorld.teleport invokes an action and then an extra scene call; the
  // first call's output remains in its source bitmap but is discarded by that
  // explorer's UI. This is an analysis-helper IO difference, explicitly outside
  // bitmap parity. Natural play (including walk_cab) has no such intervention.
  snapshot(g,row.after,label,{bitmapExact:!scenario.teleport});for(const m of out.messages)deliver(m.screen_events||[]);assert.deepEqual(screen.lines,g.world.display.upper,label+' actual web packets');
 }
});
test('World save/load retains both cabs, foreign contexts and future choices',async()=>{
 const a=new ClientSession(data,{npc_profile:'world-v5'});a.request('teleport',{room:5});
 for(const command of ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"'])a.request('command',{command});
 const saved=(await a.request('save')).save;assert.equal(saved.version,5);assert(saved.world.npcs.foreignContexts[0].length);
 const b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify(saved))});
 for(const command of ['WAIT','WAIT','WAIT','GET OUT OF CAB','PAY 1/- TO CABBIE','WAIT']){assert.deepEqual(a.request('command',{command}),b.request('command',{command}));assert.deepEqual(a.game.dump(),b.game.dump());}
});
test('The page enables the reconstructed NPC host and resets old sessions explicitly',async()=>{
 const app=await readFile(new URL('../src/app.mjs',import.meta.url),'utf8');assert(app.includes("new ClientSession(bundle,{npc_profile:'world-v5',seed:1})"));
 const s=new ClientSession(data),out=s.request('reset',{seed:42});assert.equal(out.state.npc_profile,'world-v5');assert.equal(out.state.seed,42);assert.equal(out.state.scheduler.active.length,24);assert.match(engineStatus(out.state),/NPC v5/);assert.equal(out.state.fidelity.full_game_equivalence,false);
});
test('The original first-prompt clock keeps its paid LOOK deadline',()=>{
 const free=new Game(data,{npc_profile:'world-v5'}),original=new Game(data,{npc_profile:'world-v5',start_mode:'original'});
 assert.equal(original.world.clock().label,'Mon 08:01am');assert.equal(original.world.playerDue,2);
 for(const actor of original.world.scheduler.actors)assert.equal(actor.due,free.world.scheduler.actor(actor.id).due+1);
 assert.equal(original.submit('OPEN YOUR DOOR').state.clock.label,'Mon 08:02am');
});
test('Unresolved dependencies reject and restore the whole world, including shared records',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'});s.game.world.random.cursor=0x5B10;
 const before=s.game.world.dump(),out=s.request('start-command',{command:'SAY TO WATSON "HELLO"'});assert.equal(out.state.analysis.outcome,'not_translated');assert.equal(out.running,false);assert.equal(s.game.lastFrames.length,0);
 const after=s.game.world.dump();delete before.display;delete after.display;assert.deepEqual(after,before);
});
test('Clarification and ALL remain playable; unverified allocation bytes are not supplied to randomness',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'});
 assert.equal(s.request('command',{command:'OPEN DOOR'}).state.analysis.outcome,'clarification');
 const out=s.request('command',{command:'ALL'});assert.equal(out.state.analysis.outcome,'ok');assert.deepEqual(out.messages.filter(m=>m.kind==='narrative').map(m=>m.text),['You open your door.','You open the plain door.']);
 assert.equal(s.game.world.npcs.recordsSourceKnown,false);assert.throws(()=>s.game.runtimeRandom.read(0x9570),/non ancora ricostruito/);
 const loaded=Game.load(data,JSON.parse(JSON.stringify(s.game.dump())));assert.equal(loaded.world.npcs.recordsSourceKnown,false);
 assert.deepEqual(loaded.submit('SAY TO WATSON "HELLO"'),s.game.submit('SAY TO WATSON "HELLO"'));
});
