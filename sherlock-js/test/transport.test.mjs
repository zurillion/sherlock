import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {ClientSession,gameStatus} from '../src/session.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';

const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),reference=JSON.parse(await readFile(new URL('fixtures/transport-reference.json',import.meta.url)));
const drawFields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function bitmap(g){const b=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)b.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return createHash('sha256').update(Uint8Array.from(b)).digest('hex');}
function snapshot(g,e,label){
 assert.deepEqual(g.world.clock(),e.clock,label+' clock');
 assert.deepEqual(g.world.rooms.map(r=>r.flags),e.rooms,label+' 106 room flags');
 for(const row of e.entities){const a=g.world.entity(row.id);for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(a[key],row[key],label+` entity ${row.id} ${key}`);}
 for(const row of e.actors){const a=g.world.scheduler.actor(row.id),s=row.id===0?{pc:'9923',saved:g.world.npcs.playerRootSaved}:g.world.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' deadline '+row.id);assert.equal(s.pc,row.pc,label+' program '+row.id);assert.deepEqual(s.saved,row.saved,label+' saved arguments '+row.id);}
 const records=RecordLists.load(g.world.npcs.records);
 for(const name of ['counters','contexts','signals'])assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:name==='contexts'?7:2},(_,i)=>records.arena.byte(p+i))})),e.records[name],label+' '+name);
 assert.deepEqual({seed:g.world.random.seed,cursor:g.world.random.cursor},e.random_state,label+' successor RNG');
 assert.equal(bitmap(g),e.upper_sha256,label+' exact upper bitmap');
 // Observe only owned working bytes. This never supplies fixture values to
 // the game. Unknown bytes still throw when actually consulted by a draw.
 for(const [at,value]of Object.entries(e.working_cells)){const address=parseInt(at,16);if(address in g.world.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned renderer field $'+at);}
}
for(const c of reference.cases)test('Native transport with all actors and generated sources: '+c.label,()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:c.seed}),g=session.game,screen=new SpectrumBuffer();
 const deliver=events=>{for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};
 snapshot(g,c.initial,c.label+' startup');deliver(session.state().opening_screen);
 for(const [i,row]of c.commands.entries()){
  const label=`${c.label} #${i+1} ${row.input}`,before=g.world.random.draws,out=session.request('command',{command:row.input}),n=g.world.random.draws-before,calls=n?g.world.random.trace.slice(-n):[];
  assert.equal(out.state.analysis.outcome,row.outcome,label+' '+JSON.stringify(out.messages));
  assert.equal(calls.length,row.random.length,label+' draw count');
  for(const [j,expected]of row.random.entries())for(const field of drawFields)assert.deepEqual(calls[j][field],expected[field],label+` draw ${j+1} ${field}`);
  snapshot(g,row.after,label);
  for(const m of out.messages)deliver(m.screen_events);
  assert.deepEqual(screen.lines,g.world.display.upper,label+' web word packets');
 }
});
test('Passenger save/load resumes through Lestrade leaving and the next platform',async()=>{
 const c=reference.cases.find(c=>c.label==='train'),a=new ClientSession(data,{npc_profile:'world-v5'});
 for(const row of c.commands.slice(0,27))a.request('command',{command:row.input});
 const saved=(await a.request('save')).save,b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify(saved))});
 for(const row of c.commands.slice(27)){
  let left=a.request('start-command',{command:row.input}),right=b.request('start-command',{command:row.input});assert.deepEqual(left,right);
  while(left.running){left=a.request('continue-command',{job:left.job});right=b.request('continue-command',{job:right.job});assert.deepEqual(left,right);}
  assert.equal(left.state.clock.label,row.after.clock.label);assert.equal(left.state.analysis.outcome,'ok');assert.deepEqual(a.game.dump(),b.game.dump());
 }
});
test('A prototype limit cancels partial minute frames and keeps its notice across save/load',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'}),before=s.game.world.dump(),out=s.request('start-command',{command:'WAIT THEN LOOK "HELLO"'});assert.equal(out.running,false);
 assert.deepEqual(s.game.world.dump(),before);assert.equal(s.game.lastFrames.length,0);assert.equal(out.state.clock.label,'Mon 08:00am');assert.equal(out.state.analysis.outcome,'not_translated');assert.match(gameStatus(out.state),/Messaggio del prototipo:.*citazioni/);
 assert(out.messages.every(m=>m.kind==='system'));
 const restored=Game.load(data,JSON.parse(JSON.stringify(s.game.dump())));assert.equal(gameStatus(restored.state()),gameStatus(out.state));
});
test('Renderer working fields follow glyph layout across controlled name lengths',async()=>{
 const cases=JSON.parse(await readFile(new URL('fixtures/bootstrap-scratch.json',import.meta.url)));
 for(const row of cases){const variant=structuredClone(data);Object.assign(variant.entities[3],{name:row.name,noun:row.noun});const g=new Game(variant,{npc_profile:'world-v5'});
  for(const [address,value]of Object.entries(row.scratch))if(address in g.world.display.scratch)assert.equal(g.sourceDisplay.read(Number(address)),value,row.name+' $'+Number(address).toString(16));
 }
});
