import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL(p,import.meta.url),'utf8'));
const data=await read('../data/game.json'),base=await read('./fixtures/all-reference.json'),extra=await read('./fixtures/all-extra-reference.json');
const norm=s=>s.replace(/\s+/g,' ').trim().toUpperCase();
for(const sequence of [...base.sequences,...extra]){
 if(sequence.commands.some(r=>/\b(BUT|EXCEPT)\b/.test(r.input)))continue;
 test('Original collective trace: '+sequence.commands.map(r=>r.input).join(' → '),()=>{
  const game=new Game(data);
  for(const row of sequence.commands){const out=game.submit(row.input);
   assert.equal(out.state.analysis.outcome,row.analysis.outcome,row.input);
   for(const kind of ['narrative','error'])assert.equal(norm(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),norm(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input+' '+kind);
   assert.equal(out.state.clock.label,row.clock.label,row.input+' time');assert.equal(out.state.room,row.room,row.input+' room');
   for(const r of row.records||[]){const e=game.world.entity(r.id);assert.deepEqual({id:e.id,parent:e.parent,rooms:e.rooms,attributes:e.attributes},r,row.input+' entity '+r.id);}
  }
 });
}
test('ALL after clarification survives logical save/load',()=>{
 const a=new Game(data);a.submit('OPEN DOOR');const b=Game.load(data,structuredClone(a.dump()));
 assert.deepEqual(b.submit('ALL'),a.submit('ALL'));assert.equal(b.world.entity(21).attributes&32,32);assert.equal(b.world.entity(50).attributes&32,32);
});
