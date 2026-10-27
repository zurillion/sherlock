import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {ClientSession,gameStatus} from '../src/session.mjs';
import {RecordLists} from '../src/record-arena.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url)));
const data=await read('../data/game.json');
const references=[['cab, optional TO, absent recipient and errors',await read('fixtures/command-errors-reference.json'),20],['clarification, rejected quotation and 40 further minutes',await read('fixtures/command-errors-continuation-reference.json'),53]];
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function bytes(g,from,to){const values=[];for(let y=from;y<to;y++)for(let x=0;x<32;x++)values.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return values;}
for(const [name,ref,limit]of references)test('Original error recovery, all actors: '+name,()=>{
 assert(ref.steps.length>=limit,'Complete source prefix');
 const g=new Game(data,{npc_profile:'world-v5',seed:ref.seed});
 for(const [i,row]of ref.steps.slice(0,limit).entries()){
  const label=`#${i+1} ${row.input}`,before=g.world.random.draws,out=g.submit(row.input),count=g.world.random.draws-before,draws=count?g.world.random.trace.slice(-count):[];
  assert.notEqual(out.state.analysis.outcome,'not_translated',label+' '+out.state.prototype_notice);
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.messages.filter(m=>m.kind==='error').map(m=>m.text),label+' actual errors');
  assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,expected]of row.random.entries())for(const field of fields)assert.deepEqual(draws[j][field],expected[field],label+` draw ${j+1} ${field}`);
  assert.deepEqual(g.world.clock(),row.after.clock,label+' clock');assert.deepEqual({seed:g.world.random.seed,cursor:g.world.random.cursor},row.after.random_state,label+' random successor');
  for(const actor of row.after.actors){const state=actor.id===0?{pc:'9923',saved:g.world.npcs.playerRootSaved}:g.world.npcs.program.states[actor.id];assert.equal(state.pc,actor.pc,label+' actor '+actor.id);assert.deepEqual(state.saved,actor.saved,label+' arguments '+actor.id);assert.equal(g.world.scheduler.actor(actor.id).due,actor.due,label+' due '+actor.id);}
  for(const entity of row.after.entities)for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(g.world.entity(entity.id)[key],entity[key],label+' entity '+entity.id+' '+key);
  assert.deepEqual(g.world.rooms.map(r=>r.flags),row.after.rooms,label+' room flags');
  const records=RecordLists.load(g.world.npcs.records);assert.deepEqual([...records.arena.bytes],row.after.arena,label+' all arena bytes');assert.equal(records.arena.freeHead,row.after.free_head,label+' free head');
  for(const[name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30,parsed:30}))assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>records.arena.byte(p+i))})),row.after.records[name],label+' '+name);
  assert.deepEqual(g.world.display.input,row.after.input,label+' editor bytes');assert.deepEqual(g.world.display.tokens,row.after.tokens,label+' token bytes');
  assert.equal(createHash('sha256').update(Uint8Array.from(bytes(g,0,144))).digest('hex'),row.after.upper_sha256,label+' exact upper bitmap');
  assert.deepEqual(bytes(g,152,192),row.after.lower_bitmap,label+' exact lower bitmap');
  for(const[at,value]of Object.entries(row.after.working_cells)){const address=parseInt(at,16);if(address in g.world.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned field '+at);}
  assert.equal(g.world.npcs.recordsSourceKnown,true,label+' source remains known');
 }
});
test('Unsupported commands cancel the entire input without poisoning the next command or clarification',()=>{
 for(const command of ['KILL WATSON','FOLLOW WATSON','OPEN ALL. KILL WATSON']){
  const g=new Game(data,{npc_profile:'world-v5'});g.submit('OPEN DOOR');const before=g.dump();
  const out=g.submit(command);assert.equal(out.state.analysis.outcome,'not_translated',command);assert(out.messages.every(m=>m.kind==='system'));assert.match(gameStatus(out.state),/puoi continuare/);
  assert.deepEqual(g.world.dump(),before.world,command+' complete world/source rollback');assert.deepEqual(g.pending,before.pending);assert.equal(g.lastInput,before.lastInput);assert.equal(g.lastFrames.length,0);
  const control=Game.load(data,before);assert.deepEqual(g.submit('YOUR'),control.submit('YOUR'),command+' next command');
 }
});
test('A missing dependency after an earlier action in the same line also cancels its minute frames',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'}),before=s.game.dump(),out=s.request('start-command',{command:'WAIT. KILL WATSON'});
 assert.equal(out.state.analysis.outcome,'not_translated');assert.equal(out.running,false);assert.equal(s.job,null);assert.deepEqual(s.game.world.dump(),before.world);assert.equal(s.game.lastFrames.length,0);
 assert.equal(s.request('command',{command:'I'}).state.clock.label,'Mon 08:01am');
});
test('An unexpected exception restores the last valid input state before reaching the UI',()=>{
 const g=new Game(data,{npc_profile:'world-v5'}),before=g.dump(),execute=g.execute;
 g.execute=()=>{g.world.move(0,5);g.world.tick=700;g.pending=null;throw Error('Controlled failure');};
 assert.throws(()=>g.submit('I'),/Controlled failure/);assert.deepEqual(g.world.dump(),before.world);assert.equal(g.lastInput,before.lastInput);assert.equal(g.analysis,before.analysis);assert.equal(g.lastFrames.length,0);
 g.execute=execute;assert.equal(g.submit('I').state.clock.label,'Mon 08:01am');
});
test('Save/load after an error preserves quotation residue and the complete future source',async()=>{
 const a=new ClientSession(data,{npc_profile:'world-v5'});for(const row of references[0][1].steps.slice(0,17))a.request('command',{command:row.input});
 const b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify((await a.request('save')).save))});
 for(let i=0;i<40;i++){const left=a.request('command',{command:'I'}),right=b.request('command',{command:'I'});assert.deepEqual(left,right);assert.notEqual(left.state.analysis.outcome,'not_translated');assert.deepEqual(a.game.dump(),b.game.dump());}
});
test('Map and roster expose readable initials for every secondary character',()=>{
 const g=new Game(data,{npc_profile:'world-v5'}),characters=g.state().characters;
 for(const badge of ['IL','W','CS','DS','BP','PF','G','CK','MD','P1','P2','TF','C1','C2','MB','MJ','GA'])assert(characters.some(c=>c.badge===badge),badge);
 assert(characters.every(c=>!/^\d+$/.test(c.badge)));
 g.world.move(6,8);const before=g.world.dump(),loaded=Game.load(data,g.dump());assert.equal(loaded.state().characters.find(c=>c.id===6).badge,'BP');assert.deepEqual(g.world.dump(),before,'presentation does not mutate the world');
});
