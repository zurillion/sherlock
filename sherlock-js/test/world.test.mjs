import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
const observations=JSON.parse(await readFile(new URL('./fixtures/world-observations.json',import.meta.url),'utf8'));
const normalize=text=>text.replaceAll('`','£').replace(/\s+/g,' ').trim().toUpperCase();
for(const sequence of observations){
 const commands=sequence.commands.map(c=>c.input);
 if(commands.includes('GO TO HALL'))continue;
 test('Native isolated action trace: '+commands.join(' → '),()=>{
  const game=new Game(data);
  for(const row of sequence.commands){const actual=game.submit(row.input);
   assert.notEqual(actual.state.analysis.outcome,'not_translated',JSON.stringify(actual.state.analysis));
   for(const kind of ['narrative','error'])assert.equal(normalize(actual.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),normalize(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input+' '+kind);
   assert.equal(actual.state.clock.label,row.clock.label,row.input+' clock');assert.equal(actual.state.room,row.room,row.input+' room');
  }
 });
}
test('Visibility follows containment and light, not a flat room filter',()=>{
 const g=new Game(data),w=g.world;assert(w.perceived(25));w.entity(24).attributes&=~32;assert(!w.perceived(3)&&!w.perceived(25));assert(w.perceived(24));
 w.entity(24).attributes|=32;assert(w.perceived(25));w.move(22,8,0);w.move(0,7);assert.equal(w.roomOf(22),7);
});
test('Logical save/load resumes clarification and future commands without CPU state',()=>{
 const a=new Game(data);a.submit('OPEN DOOR');const file=JSON.parse(JSON.stringify(a.dump()));assert(!('memory' in file)&&!('registers' in file));
 const b=Game.load(data,file);
 for(const command of ['YOUR','WEST','DOWN','OPEN FRONT DOOR','SOUTH']){assert.deepEqual(a.submit(command),b.submit(command));assert.deepEqual(a.dump(),b.dump());}
});
test('An unported action is explicit and has no hidden fallback or world effect',()=>{
 const g=new Game(data),before=g.world.dump();const out=g.submit('SAY TO WATSON "TAKE LAMP"');assert.equal(out.state.analysis.outcome,'not_translated');assert(out.messages.some(m=>m.kind==='system'));assert.deepEqual(g.world.dump(),before);
});
test('Quoted syntax errors are checked before unported conversation execution',()=>{
 const g=new Game(data),before=g.world.dump();const out=g.submit('TELL WATSON "THE"');
 assert.equal(out.state.analysis.outcome,'quoted_syntax_error');assert.equal(out.messages[0].text,'WHAT ?');assert.deepEqual(g.world.dump(),before);
});

const states=JSON.parse(await readFile(new URL('./fixtures/world-states.json',import.meta.url),'utf8'));
for(const sequence of states.sequences)test('Native selected entity mutations: '+sequence.commands.map(c=>c.input).join(' → '),()=>{
 const game=new Game(data);
 for(const row of sequence.commands){game.submit(row.input);
  for(const record of row.records){const e=game.world.entity(record.id);assert.deepEqual({id:e.id,parent:e.parent,rooms:e.rooms,attributes:e.attributes,examined:Boolean(e.status&64)},record,row.input+' entity '+e.id);}
 }
});
