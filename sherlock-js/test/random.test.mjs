import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {OriginalRandom,RandomInputsUnavailable} from '../src/random.mjs';
const reference=JSON.parse(await readFile(new URL('./fixtures/random-reference.json',import.meta.url),'utf8'));
test('Random arithmetic matches every frozen original extraction with its recorded input pairs',()=>{
 for(const [i,c] of reference.calls.entries()){
  const random=new OriginalRandom(c);let reads=0;
  const value=random.draw(c.width,{mixOffset:c.mixOffset,inputs:({cursor,mixOffset})=>{assert.equal(mixOffset,c.mixOffset);const pair={first:c.reads[reads++],second:c.reads[reads++]};if(reads===c.reads.length)assert.equal(cursor,c.next_cursor);return pair;}});
  assert.equal(value,c.output,'call '+i);assert.deepEqual(random.dump(),{seed:c.next_seed,cursor:c.next_cursor});assert.equal(reads,c.reads.length);
 }
});
test('Unavailable inputs leave the random source untouched, instead of substituting Math.random',()=>{
 const random=new OriginalRandom({seed:4,cursor:65535}),before=random.dump();assert.throws(()=>random.draw(4),RandomInputsUnavailable);assert.deepEqual(random.dump(),before);
 assert.throws(()=>random.draw(4,{inputs:()=>null}),RandomInputsUnavailable);assert.deepEqual(random.dump(),before);
});
test('Random state and explicit input provider reproduce later choices after save/load',()=>{
 const inputs=({cursor})=>({first:cursor&255,second:189}),a=new OriginalRandom({seed:1});a.draw(4,{inputs});const b=new OriginalRandom(JSON.parse(JSON.stringify(a.dump())));
 for(let i=0;i<20;i++){assert.equal(a.percent({inputs}),b.percent({inputs}));assert.deepEqual(a.dump(),b.dump());}
});

const choices=JSON.parse(await readFile(new URL('./fixtures/choice-reference.json',import.meta.url),'utf8'));
test('The text alternative selector matches all 1280 controlled native selections',()=>{
 for(const c of choices.cases){
  const random=new OriginalRandom(c);let reads=0;
  assert.equal(random.chooseIndex(c.count,{mixOffset:c.mixOffset,inputs:()=>{reads++;return {first:c.first,second:c.second};}}),c.index,JSON.stringify(c));
  assert.equal(reads,1);assert.deepEqual(random.dump(),{seed:c.next_seed,cursor:c.next_cursor});
 }
});
test('The text selector preserves rollback when source inputs are missing',()=>{
 const r=new OriginalRandom({seed:7,cursor:65535}),before=r.dump();assert.throws(()=>r.chooseIndex(2),RandomInputsUnavailable);assert.deepEqual(r.dump(),before);
 for(const count of [0,256,1.5])assert.throws(()=>r.chooseIndex(count));assert.deepEqual(r.dump(),before);
});

const greetingAudit=JSON.parse(await readFile(new URL('../results/greeting-audit.json',import.meta.url),'utf8'));
test('Arithmetic reproduces 1271 actual shared-stream draws when supplied the observed inputs',()=>{
 let count=0;
 for(const trace of greetingAudit.cases)for(const row of trace.rows)for(const c of row.calls){
  const r=new OriginalRandom(c);let pos=0;
  assert.equal(r.draw(c.width,{mixOffset:c.mix_offset,inputs:({cursor,mixOffset})=>{
   const first=c.reads[pos++],second=c.reads[pos++];assert.equal(first.address,cursor);assert.equal(second.address,(cursor+mixOffset+1)&65535);return {first:first.value,second:second.value};
  }}),c.output);
  assert.deepEqual(r.dump(),{seed:c.next_seed,cursor:c.next_cursor});assert.equal(pos,c.reads.length);count++;
 }
 assert.equal(count,1271);
});
