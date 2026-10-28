import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url)));
const natural=JSON.parse(await readFile(new URL('fixtures/lestrade-natural-reference.json',import.meta.url)));
const user=JSON.parse(await readFile(new URL('fixtures/lestrade-user-reference.json',import.meta.url)));
const fields=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function bitmap(g){const bytes=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)bytes.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return createHash('sha256').update(Uint8Array.from(bytes)).digest('hex');}
function snapshot(g,e,label,{exactBitmap=true}={}){
 const w=g.world,records=RecordLists.load(w.npcs.records);assert.deepEqual(w.clock(),e.clock,label+' clock');
 assert.deepEqual(w.rooms.map(r=>r.flags),e.rooms,label+' room flags');
 for(const row of e.entities)for(const key of ['parent','rooms','attributes','status'])assert.deepEqual(w.entity(row.id)[key],row[key],label+` entity ${row.id} ${key}`);
 for(const row of e.actors){const a=w.scheduler.actor(row.id),s=row.id===0?{pc:'9923',saved:w.npcs.playerRootSaved}:w.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' deadline '+row.id);assert.equal(s.pc,row.pc,label+' program '+row.id);assert.deepEqual(s.saved,row.saved,label+' arguments '+row.id);}
 for(const[name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30,parsed:30}))assert.deepEqual(records.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>records.arena.byte(p+i))})),e.records[name],label+' '+name);
 assert.deepEqual([...records.arena.bytes],e.arena,label+' all 752 arena bytes');assert.equal(records.arena.freeHead,e.free_head,label+' free head');
 assert.deepEqual({seed:w.random.seed,cursor:w.random.cursor},e.random_state,label+' RNG successor');
 if(exactBitmap)assert.equal(bitmap(g),e.upper_sha256,label+' exact upper bitmap');
 if(exactBitmap)for(const[at,value]of Object.entries(e.working_cells)){const address=parseInt(at,16);if(address in w.display.scratch)assert.equal(g.sourceDisplay.read(address),value,label+' owned scratch '+at);}
}
function verify(reference,{limit=reference.steps.length,teleportBitmap=false}={}){
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:reference.seed}),g=session.game,screen=new SpectrumBuffer();let teleported=false;
 const deliver=events=>{for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}};
 snapshot(g,reference.initial,'startup');deliver(session.state().opening_screen);
 for(const[i,row]of reference.steps.slice(0,limit).entries()){
  const label=`#${i+1} ${row.kind} ${row.input}`,before=g.world.random.draws,out=session.request(row.kind,row.kind==='command'?{command:row.input}:{room:row.input}),n=g.world.random.draws-before,draws=n?g.world.random.trace.slice(-n):[];
  if(row.kind==='teleport')teleported=true;
  assert.notEqual(out.state.analysis?.outcome,'not_translated',label+' '+out.state.prototype_notice);
  assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,d]of row.random.entries())for(const f of fields)assert.deepEqual(draws[j][f],d[f],label+` draw ${j+1} ${f}`);
  assert.deepEqual(out.messages.filter(m=>m.kind==='error').map(m=>m.text),row.messages.filter(m=>m.kind==='error').map(m=>m.text),label+' errors');
  snapshot(g,row.after,label,{exactBitmap:!teleported||teleportBitmap});
  for(const m of out.messages)deliver(m.screen_events);assert.deepEqual(screen.lines,g.world.display.upper,label+' actual web packets');
 }
 return session;
}
test('Lestrade followed on foot: all actors, every draw, all record bytes and exact upper screen',()=>{
 assert.equal(natural.steps.some(s=>s.kind==='teleport'),false);
 assert.equal(natural.steps.at(-1).after.clock.label,'Mon 01:00pm','Completed reference, not a partial probe');
 verify(natural);
});
test('Save/load during the house interviews preserves the remaining natural playthrough',()=>{
 const original=new ClientSession(data,{npc_profile:'world-v5',seed:1});
 for(const row of natural.steps.slice(0,114))original.request('command',{command:row.input});
 const loaded=Game.load(data,JSON.parse(JSON.stringify(original.game.dump())));
 for(const row of natural.steps.slice(114)){
  assert.deepEqual(loaded.submit(row.input),original.game.submit(row.input),row.input);
  assert.deepEqual(loaded.dump(),original.game.dump(),row.after.clock.label);
 }
 assert.equal(loaded.world.clock().label,'Mon 01:00pm');
});
test('The original time-class branch keeps noon in morning and midnight in night',()=>{
 const g=new Game(data,{npc_profile:'world-v5'});
 for(const [hour,value]of [[0,1],[5,1],[6,5],[7,4],[11,4],[12,4],[13,3],[18,3],[19,2],[20,1],[23,1]]){g.world.minutes=hour*60;assert.equal(g.world.timeClass(),value,'C00C hour '+hour);}
});
test('Submitted history prefix through the garden: every draw/state; known map IO difference is explicit',()=>{
 // The old Python map helper prints twice. The first read of its differing
 // bitmap is at step 121. Do not normalize or pretend to certify that suffix.
 verify(user,{limit:120});
});
test('The complete submitted history passes 11:42 and the subsequent interviews without prototype errors',async()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});
 const lines=(await readFile(new URL('../results/lestrade/user-history.txt',import.meta.url),'utf8')).split('\n');let count=0;
 for(const line of lines){if(!line||line.startsWith('#')&&!line.startsWith('# Teletrasporto'))continue;const out=line.startsWith('#')?g.teleport(Number(line.match(/\d+/)[0])):g.submit(line);assert.notEqual(out.state.analysis?.outcome,'not_translated',line+' '+out.state.prototype_notice);count++;}
 assert.equal(count,141);assert.equal(g.world.clock().label,'Mon 11:45am');
 for(let i=0;i<40;i++){const out=g.submit('I');assert.equal(out.state.analysis.outcome,'ok',out.state.prototype_notice);}
 assert.equal(g.world.clock().label,'Mon 12:25pm');assert.equal(g.world.roomOf(2),76);
 const loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.deepEqual(loaded.submit('I'),g.submit('I'));assert.deepEqual(loaded.dump(),g.dump());
});
test('Ordinary EXAMINE preserves proven untouched low fields; unknown text contracts still invalidate them',()=>{
 const g=new Game(data,{npc_profile:'world-v5'});assert(g.text.examinePreservesLowScratch(null));assert(g.text.examinePreservesLowScratch('81B7'));
 assert.equal(g.text.examinePreservesLowScratch('missing'),false);
 const own=structuredClone(g.world.display.scratch);g.submit('EXAMINE LAMP');for(const[at,value]of Object.entries(own))if(Number(at)<=0x5D11)assert.equal(g.world.display.scratch[at],value);else assert.equal(g.world.display.scratch[at],undefined,'New high renderer fields lose ownership on EXAMINE');
});
test('Formatter coordinates derive from both channels, including their state across save/load',()=>{
 const g=new Game(data,{npc_profile:'world-v5'}),r=g.sourceDisplay;
 assert.equal(r.read(0xC1F6),0xE2);assert.equal(r.read(0xC1FB),0);
 r.command('I.');assert.equal(r.read(0xC1F4),36);assert.equal(r.read(0xC1F6),0xE0);assert.equal(r.read(0xC1F7),0x50);assert.equal(r.read(0xC1FB),2);
 const loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));for(let at=0xC1F4;at<=0xC1FB;at++)assert.equal(loaded.sourceDisplay.read(at),r.read(at));
 assert.equal(g.npcRuntime.read(0xA008),0);
});
