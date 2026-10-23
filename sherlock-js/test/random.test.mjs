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
