import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {canPlace} from '../src/objects.mjs';
import {ClientSession} from '../src/session.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url)));
const data=await read('../data/game.json'),references=[await read('fixtures/object-containers-reference.json'),await read('fixtures/object-requests-reference.json')];
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function bitmap(g,from,to){const values=[];for(let y=from;y<to;y++)for(let x=0;x<32;x++)values.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return values;}
for(const [index,ref]of references.entries())test('Original containers with every actor: '+(index?'Watson orders, remote source and ambiguous source':'placement, retrieval, rejections and failure yields'),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:ref.seed});
 for(const[i,row]of ref.steps.entries()){
  const label=`#${i+1} ${row.input}`,before=g.world.random.draws,out=g.submit(row.input),count=g.world.random.draws-before,draws=count?g.world.random.trace.slice(-count):[];
  assert.notEqual(out.state.analysis.outcome,'not_translated',label+' '+out.state.prototype_notice);
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.messages.filter(m=>m.kind==='error').map(m=>m.text),label+' original errors');
  assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,expected]of row.random.entries())for(const field of fields)assert.deepEqual(draws[j][field],expected[field],label+` draw ${j+1} ${field}`);
  assert.deepEqual(g.world.clock(),row.after.clock,label+' clock');assert.deepEqual({seed:g.world.random.seed,cursor:g.world.random.cursor},row.after.random_state,label+' random successor');
  for(const actor of row.after.actors){const state=actor.id===0?{pc:g.world.npcs.playerProgramCounter,saved:g.world.npcs.playerRootSaved}:g.world.npcs.program.states[actor.id];assert.equal(state.pc,actor.pc,label+' actor '+actor.id);assert.deepEqual(state.saved,actor.saved,label+' arguments '+actor.id);assert.equal(g.world.scheduler.actor(actor.id).due,actor.due,label+' deadline '+actor.id);}
  for(const entity of row.after.entities)for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(g.world.entity(entity.id)[key],entity[key],label+' entity '+entity.id+' '+key);
  assert.deepEqual(g.world.rooms.map(r=>r.flags),row.after.rooms,label+' room flags');
  const records=RecordLists.load(g.world.npcs.records);assert.deepEqual([...records.arena.bytes],row.after.arena,label+' complete arena');assert.equal(records.arena.freeHead,row.after.free_head,label+' free head');
  for(const[name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30,parsed:30}))assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>records.arena.byte(p+i))})),row.after.records[name],label+' '+name);
  assert.deepEqual(g.world.display.input,row.after.input,label+' editor');assert.deepEqual(g.world.display.tokens,row.after.tokens,label+' tokens');
  assert.equal(createHash('sha256').update(Uint8Array.from(bitmap(g,0,144))).digest('hex'),row.after.upper_sha256,label+' exact upper bitmap');assert.deepEqual(bitmap(g,152,192),row.after.lower_bitmap,label+' exact lower bitmap');
  for(const[at,value]of Object.entries(row.after.working_cells)){const address=parseInt(at,16);if(address in g.world.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned field '+at);}
  assert.equal(g.world.npcs.recordsSourceKnown,true,label+' source validity');
 }
});
test('Original placement capacity, direct bulk, flags and signed overflow: 94 controlled cases',async()=>{
 const ref=await read('fixtures/object-capacity-reference.json');assert.equal(ref.cases.length,94);
 for(const row of ref.cases){const g=new Game(data,{npcs:false}),w=g.world,object=w.entity(22),target=w.entity(23);w.move(22,8,0);object.size=row.size;Object.assign(target,{size:row.capacity,properties:row.properties,attributes:row.attributes});for(const child of w.entities)if(child.parent===23)child.parent=null;row.contents.forEach((size,i)=>{w.move(15+i,8,23);w.entity(15+i).size=size;});assert.equal(canPlace(w,object,target,0),row.allowed,JSON.stringify(row));if(row.allowed&&row.execution_allowed!==undefined){const out=g.execute(g.npcRuntime.node(39,[22,23]));assert.equal(out.cost>0,row.execution_allowed,'execution '+JSON.stringify(row));assert.equal(object.parent,row.execution_allowed?23:0);}}
});
test('A placement mask failure follows semantic success, binds the action, prints the original refusal and retains the object',async()=>{
 const ref=await read('fixtures/object-capacity-reference.json');assert.equal(ref.full_command_mask_errors.length,2);
 for(const row of ref.full_command_mask_errors){const g=new Game(data,{npc_profile:'world-v5'});g.submit('TAKE LAMP');g.world.entity(23).attributes=row.attributes;const out=g.submit('PUT LAMP ON YOUR ARMCHAIR');assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.errors);assert.deepEqual(g.world.clock(),row.clock);assert.deepEqual(g.world.npcs.playerRootSaved,row.player_saved);assert.equal(g.world.entity(22).parent,row.parent);assert.equal(g.world.npcs.playerFailures,row.failures);}
});
test('Save/load preserves a partially used failure budget and subsequent NPC choices',async()=>{
 const a=new ClientSession(data,{npc_profile:'world-v5'});for(const row of references[0].steps.slice(0,9))a.request('command',{command:row.input});assert.equal(a.game.world.npcs.playerFailures,9);
 const b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify((await a.request('save')).save))});
 for(const row of references[0].steps.slice(9)){assert.deepEqual(a.request('command',{command:row.input}),b.request('command',{command:row.input}));assert.deepEqual(a.game.dump(),b.game.dump());}
});
test('Unsupported actions do not consume the original failure budget',()=>{
 const g=new Game(data,{npc_profile:'world-v5'});for(const row of references[0].steps.slice(0,9))g.submit(row.input);const before=g.dump();assert.equal(g.submit('LOOK \"HELLO\"').state.analysis.outcome,'not_translated');assert.deepEqual(g.world.dump(),before.world);const control=Game.load(data,before);assert.deepEqual(g.submit(references[0].steps[9].input),control.submit(references[0].steps[9].input));
});
