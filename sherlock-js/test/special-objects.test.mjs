import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {ClientSession} from '../src/session.mjs';
import {Game} from '../src/game.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url))),data=await read('../data/game.json');
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function bitmap(g,from,to){const bytes=[];for(let y=from;y<to;y++)for(let x=0;x<32;x++)bytes.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return bytes;}
function setup(g,value){const w=g.world;if('room'in value){w.move(w.player,value.room);w.rooms[value.room].flags|=64;w.explored.add(value.room);}if('day'in value)w.minutes=value.day*1440+w.minutes%1440;if('note_ticks'in value)w.npcs.burningNoteTicks=value.note_ticks;for(const row of value.entities||[]){const e=w.entity(row.id);for(const key of ['parent','attributes','status','properties','size','weight','qualifiers'])if(key in row)e[key]=structuredClone(row[key]);if('room'in row)e.rooms=[row.room];if('description'in row)e.description=row.description;if(row.qualifiers)e.name=row.qualifiers.filter(Boolean).map(q=>g.dictionary.word(q&4095).form).concat(g.dictionary.word(e.noun&4095).stem).join(' ');}}
function snapshot(g,e,label){const w=g.world,r=RecordLists.load(w.npcs.records);
 assert.equal(w.player,e.player,label+' identity');assert.deepEqual(w.clock(),e.clock,label+' clock');assert.equal(w.npcs.playerFailures,e.player_failures,label+' failure budget');
 for(const row of e.actors){const a=w.scheduler.actor(row.id),state=a===w.scheduler.actors[0]?{pc:w.npcs.playerProgramCounter,saved:w.npcs.playerRootSaved}:w.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' deadline '+row.id);assert.equal(state.pc,row.pc,label+' program '+row.id);assert.deepEqual(state.saved,row.saved,label+' arguments '+row.id);}
 for(const row of e.entities)for(const key of ['parent','rooms','attributes','status','properties','noun','qualifiers','description']){const actual=w.entity(row.id)[key],expected=key==='description'&&row[key]==='0000'?null:row[key];if(key==='qualifiers'&&w.entity(row.id).money)continue;assert.deepEqual(actual,expected,label+' entity '+row.id+' '+key);}
 assert.deepEqual(w.rooms.map(r=>r.flags),e.rooms,label+' room flags');assert.deepEqual([...r.arena.bytes],e.arena,label+' all arena bytes');assert.equal(r.arena.freeHead,e.free_head,label+' free head');
 for(const[name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30,parsed:30}))assert.deepEqual(r.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>r.arena.byte(p+i))})),e.records[name],label+' '+name);
 assert.deepEqual(w.npcs.facts.map(f=>[f.subject,f.predicate,f.object,f.flags,f.handler&255,f.handler>>>8,...f.terms.flatMap(n=>[n&255,n>>>8])]),e.facts,label+' fact memory');
 assert.deepEqual({seed:w.random.seed,cursor:w.random.cursor},e.random_state,label+' RNG successor');assert.equal(createHash('sha256').update(Uint8Array.from(bitmap(g,0,144))).digest('hex'),e.upper_sha256,label+' exact upper bitmap');assert.deepEqual(bitmap(g,152,192),e.lower_bitmap,label+' exact lower bitmap');
 assert.deepEqual(w.display.input,e.input,label+' editor bytes');assert.deepEqual(w.display.tokens,e.tokens,label+' tokens');for(const[at,value]of Object.entries(e.working_cells)){const address=parseInt(at,16);if(address in w.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned field '+at);}
}
function verify(ref,{saveAt=[]}={}){let session=new ClientSession(data,{npc_profile:'world-v5',seed:ref.seed});const screen=new SpectrumBuffer(),deliver=events=>{for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};snapshot(session.game,ref.initial,'startup');deliver(session.state().opening_screen);
 for(const[i,row]of ref.steps.entries()){const g=session.game,label=`#${i+1} ${JSON.stringify(row.input)}`;
  if(row.kind==='setup'){setup(g,row.input);snapshot(g,row.after,label);continue;}
  const before=g.world.random.draws,out=session.request('command',{command:row.input}),count=g.world.random.draws-before,draws=count?g.world.random.trace.slice(-count):[];
  assert.notEqual(out.state.analysis.outcome,'not_translated',label+' '+out.state.prototype_notice);assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,d]of row.random.entries())for(const field of fields)assert.deepEqual(draws[j][field],d[field],label+' draw '+(j+1)+' '+field);
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.messages.filter(m=>m.kind==='error').map(m=>m.text),label+' errors');snapshot(g,row.after,label);for(const m of out.messages)deliver(m.screen_events);assert.deepEqual(screen.lines,g.world.display.upper,label+' actual web packets');
  if(saveAt.includes(i+1)){session.game=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.deepEqual(session.game.dump(),g.dump(),label+' save/load');}
 }return session;
}
for(const[name,file,saveAt]of [['both disguises and identity references','special-disguises-reference.json',[3,13]],['drawer, trash, bookcase, note and safe','special-clues-reference.json',[14,22]],['lock refusals, inspection and clarification','special-controls-reference.json',[11]],['stream and detailed clues','special-stream-reference.json',[8]],['burning note phases','special-note-reference.json',[2]],['safe on Tuesday','special-safe-tuesday-reference.json',[3]],['safe ending alone','special-safe-alone-reference.json',[2]],['safe ending with Basil','special-safe-basil-reference.json',[2]],['object rules while disguised','special-disguise-objects-reference.json',[5]],['Watson deferred object requests','special-requests-reference.json',[2]]])test('Special objects / native comparison: '+name,async()=>verify(await read('fixtures/'+file),{saveAt}));
test('Original recursive weight and modulo capacity: 448 controlled cases',async()=>{
 const ref=await read('fixtures/object-physics-reference.json');assert.equal(ref.weights.length,448);
 for(const c of ref.weights){const g=new Game(data,{npcs:false}),w=g.world;for(const e of w.entities)if([0,15,16,22].includes(e.parent))e.parent=null;w.entity(0).weight=c.capacity;w.entity(22).weight=c.object_weight;w.entity(22).parent=null;c.contents.forEach((weight,i)=>Object.assign(w.entity(15+i),{parent:c.nested&&i?15:0,weight}));assert.equal(w.contentsWeight(0),c.total,JSON.stringify(c));assert.equal(w.weight(22)<=w.remainingCapacity(0),c.allowed,JSON.stringify(c));}
});
test('Original barriers and perception in nested containers: 576 controlled cases',async()=>{
 const ref=await read('fixtures/object-physics-reference.json');assert.equal(ref.perception.length,576);
 for(const c of ref.perception){const g=new Game(data,{npcs:false}),w=g.world;for(const[id,parent,room,attributes]of [[0,c.actor_parent,8,224],[22,c.object_parent,c.object_room,c.object_flags],[15,null,8,c.outer_flags],[16,15,8,c.inner_flags]])Object.assign(w.entity(id),{parent,rooms:[room],attributes});assert.equal(w.barrier(0),c.actor_barrier,JSON.stringify(c));assert.equal(w.barrier(22),c.object_barrier,JSON.stringify(c));assert.equal(w.perceived(22),c.visible,JSON.stringify(c));}
});
test('Original light, daylight, actor and perceived lamps: 2240 controlled cases',async()=>{
 const ref=await read('fixtures/object-physics-reference.json');assert.equal(ref.light.length,2240);
 for(const c of ref.light){const g=new Game(data,{npcs:false}),w=g.world;for(const e of w.entities)e.properties&=127;Object.assign(w.entity(0),{properties:c.actor_properties,parent:c.actor_parent,rooms:[8]});Object.assign(w.entity(15),{parent:null,attributes:c.box_flags,rooms:[8]});Object.assign(w.entity(22),{parent:c.lamp_parent,properties:c.lamp_properties,attributes:c.lamp_flags,rooms:[8]});w.rooms[8].flags=c.room_flags;w.minutes=c.hour*60;assert.equal(w.dark(),c.dark,JSON.stringify(c));}
});
