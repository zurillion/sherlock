import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
const reference=JSON.parse(await readFile(new URL('./fixtures/watson-reference.json',import.meta.url),'utf8'));
const norm=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim().toUpperCase();
for(const trace of reference.cases.filter(t=>!['greeting','reading_boundary'].includes(t.label)))test('Original Watson domain trace: '+trace.label,()=>{
 const g=new Game(data);
 for(const row of trace.commands){const out=g.submit(row.input);
  assert.notEqual(out.state.analysis.outcome,'not_translated',JSON.stringify(out.messages));
  assert(!out.messages.some(m=>m.kind==='system'),JSON.stringify(out.messages));
  for(const kind of ['narrative','error'])assert.equal(norm(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),norm(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input+' '+kind);
  assert.deepEqual(out.state.clock,row.after.clock,row.input+' clock');
  for(const e of row.after.entities){const a=g.world.entity(e.id);assert.deepEqual({id:a.id,parent:a.parent,rooms:a.rooms,attributes:a.attributes},e,row.input+' entity '+e.id);}
  assert.equal(g.world.scheduler.actor(3).due,row.after.watson.due,row.input+' Watson deadline');
  const b=g.world.scheduler.actor(3).behavior,counters=[...(b.follow?[b.follow.remaining]:[]),...(b.phase==='reading'?[b.remaining]:[])];
  assert.deepEqual(counters,row.after.watson.counters.filter(c=>c[0]===3).map(c=>c[1]),row.input+' private counters');
 }
});
test('Watson save/load keeps delayed requests, ALL cursors and suspended FOLLOW',()=>{
 for(const command of ['SAY TO WATSON "WAIT"','SAY TO WATSON "OPEN ALL DOORS"','SAY TO WATSON "FOLLOW ME"']){
  const a=new Game(data);a.submit(command);const b=Game.load(data,JSON.parse(JSON.stringify(a.dump())));
  for(const c of ['OPEN YOUR DOOR','WEST','WAIT','DOWN']){assert.deepEqual(a.submit(c),b.submit(c));assert.deepEqual(a.dump(),b.dump());}
 }
});
test('An invalid quote, ambiguity or lexical error gives no actor a turn',()=>{
 const g=new Game(data),before=g.world.dump();for(const c of ['XYZZY','OPEN DOOR','SAY TO WATSON "THE"']){g.submit(c);assert.deepEqual(g.world.dump(),before);}
});
test('Watson requests are executed at his deadline rather than on SAY',()=>{
 const g=new Game(data);g.submit('SAY TO WATSON "WAIT"');g.submit('SAY TO WATSON "TAKE LAMP"');assert.equal(g.world.entity(22).parent,null);
 g.submit('WAIT');assert.equal(g.world.entity(22).parent,3);
});
test('Unknown NPC programs and unported conversation do not become invented replies',()=>{
 for(const command of ['SAY TO WATSON "BASIL KILLED MRS BROWN"','SAY TO WATSON "TELL ME ABOUT LESTRADE"']){
  const g=new Game(data),before=g.world.dump();const out=g.submit(command);assert.equal(out.state.analysis.outcome,'not_translated');assert.deepEqual(g.world.dump(),before);
 }
});
test('The ungenerated second random counter suspends the program once, with explicit provenance',()=>{
 const g=new Game(data);let replies=[];for(let n=0;n<3;n++)replies.push(g.submit('WAIT'));
 const native=reference.cases.find(t=>t.label==='reading_boundary');
 for(let i=0;i<3;i++)assert.equal(norm(replies[i].messages.filter(m=>m.kind==='narrative').map(m=>m.text).join(' ')),norm(native.commands[i].messages.filter(m=>m.kind==='narrative').map(m=>m.text).join(' ')));
 assert.equal(g.world.scheduler.actor(3).behavior.phase,'awaiting-random');assert(!g.world.scheduler.actor(3).enabled);
 assert.equal(replies.flatMap(r=>r.messages).filter(m=>m.kind==='system').length,1);
 assert.equal(g.state().npc_profile,'historical-first-prompt-counter-15');
 const a=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.deepEqual(a.submit('LOOK'),g.submit('LOOK'));
});
test('New requests during an active deferred FOLLOW are explicit until its request gates are ported',()=>{
 const g=new Game(data);g.submit('SAY TO WATSON "FOLLOW ME"');const before=g.world.dump();const out=g.submit('SAY TO WATSON "WAIT"');
 assert.equal(out.state.analysis.outcome,'not_translated');assert.deepEqual(g.world.dump(),before);
});
