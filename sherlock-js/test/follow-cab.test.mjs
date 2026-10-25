import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {ClientSession} from '../src/session.mjs';
import {Game} from '../src/game.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/follow-cab-reference.json',import.meta.url)));
assert.equal(ref.cases.length,4,'Completed native corpus');
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function upper(g){const b=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)b.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return createHash('sha256').update(Uint8Array.from(b)).digest('hex');}
function snapshot(g,e,label){
 const w=g.world,records=RecordLists.load(w.npcs.records);
 assert.deepEqual(w.clock(),e.clock,label+' clock');assert.deepEqual(w.rooms.map(r=>r.flags),e.rooms,label+' room flags');
 for(const row of e.entities)for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(w.entity(row.id)[key],row[key],label+` entity ${row.id} ${key}`);
 for(const row of e.actors){const a=w.scheduler.actor(row.id),s=row.id===0?{pc:'9923',saved:w.npcs.playerRootSaved}:w.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' deadline '+row.id);assert.equal(s.pc,row.pc,label+' program '+row.id);assert.deepEqual(s.saved,row.saved,label+' arguments '+row.id);}
 for(const [name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30}))assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>records.arena.byte(p+i))})),e.records[name],label+' '+name);
 assert.deepEqual(e.records.parsed,[],label+' no unfinished parsed list at prompt');assert.equal(records.arena.freeHead,e.free_head,label+' free head');
 assert.deepEqual([...records.arena.bytes],e.arena,label+' EVERY live and released arena byte');
 assert.deepEqual({seed:w.random.seed,cursor:w.random.cursor},e.random_state,label+' random successor');assert.equal(upper(g),e.upper_sha256,label+' exact native upper bitmap');
 for(const [at,value]of Object.entries(e.working_cells||{})){const address=parseInt(at,16);if(address in w.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned rendering field $'+at);}
}
for(const c of ref.cases)test('Native greeting → reading → follow → cab, all actors: '+c.label,()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:c.seed}),g=session.game,screen=new SpectrumBuffer();
 const deliver=events=>{for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};
 snapshot(g,c.initial,c.label+' bootstrap');deliver(session.state().opening_screen);
 for(const [i,row]of c.commands.entries()){
  const label=`${c.label} #${i+1} ${row.input}`,before=g.world.random.draws,out=session.request('command',{command:row.input}),n=g.world.random.draws-before,calls=n?g.world.random.trace.slice(-n):[];
  assert.equal(out.state.analysis.outcome,row.outcome,label+' '+out.state.prototype_notice);assert.equal(calls.length,row.random.length,label+' draw count');
  for(const[j,expected]of row.random.entries())for(const key of fields)assert.deepEqual(calls[j][key],expected[key],label+` draw ${j+1} ${key}`);
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.messages.filter(m=>m.kind==='error').map(m=>m.text),label+' lower-channel messages');
  snapshot(g,row.after,label);for(const m of out.messages)deliver(m.screen_events);assert.deepEqual(screen.lines,g.world.display.upper,label+' actual web packets');
  assert.equal(g.world.npcs.recordsSourceKnown,true,label+' parser source validity');
 }
});
test('Save at WHICH DOOR retains the original command node and future cab request',async()=>{
 const c=ref.cases[0],a=new ClientSession(data,{npc_profile:'world-v5'}),split=c.commands.findIndex(r=>r.input==='YOUR');
 for(const r of c.commands.slice(0,split))a.request('command',{command:r.input});
 const pointer=a.game.world.npcs.parserPending;assert(pointer);assert.equal(a.game.world.npcs.records.heads.syntax,pointer);
 const b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify((await a.request('save')).save))});
 assert.equal(b.game.world.npcs.parserPending,pointer);
 for(const r of c.commands.slice(split)){let left=a.request('start-command',{command:r.input}),right=b.request('start-command',{command:r.input});assert.deepEqual(left,right);while(left.running){left=a.request('continue-command',{job:left.job});right=b.request('continue-command',{job:right.job});assert.deepEqual(left,right);}assert.equal(left.state.analysis.outcome,r.outcome);assert.equal(left.state.clock.label,r.after.clock.label);assert.deepEqual(a.game.dump(),b.game.dump());}
});
test('An old incomplete save does not acquire invented clarification records',()=>{
 const g=new Game(data,{npc_profile:'world-v5'});g.submit('OPEN DOOR');const old=g.dump(),records=RecordLists.load(old.world.npcs.records);records.remove('syntax',old.world.npcs.parserPending);delete old.world.npcs.parserPending;old.world.npcs.records=records.dump();old.world.npcs.recordsSourceKnown=false;
 const loaded=Game.load(data,old);loaded.submit('YOUR');assert.equal(loaded.world.npcs.recordsSourceKnown,false);
});
test('A rejected reply preserves both the logical clarification and its retained record',()=>{
 for(const command of ['KILL WATSON','SAVE']){const g=new Game(data,{npc_profile:'world-v5'});g.submit('OPEN DOOR');const pending=structuredClone(g.pending),pointer=g.world.npcs.parserPending,arena=structuredClone(g.world.npcs.records);
  assert.equal(g.submit(command).state.analysis.outcome,'not_translated');assert.deepEqual(g.pending,pending);assert.equal(g.world.npcs.parserPending,pointer);assert.deepEqual(g.world.npcs.records,arena);
  const loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.equal(loaded.submit('YOUR').state.analysis.outcome,'ok');assert.equal(loaded.world.npcs.parserPending,null);
 }
});
