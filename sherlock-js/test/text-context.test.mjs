import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {World} from '../src/world.mjs';import {Dictionary} from '../src/lexer.mjs';import {Text} from '../src/text.mjs';import {OriginalRandom} from '../src/random.mjs';
const read=async p=>JSON.parse(await readFile(new URL(p,import.meta.url),'utf8'));
const data=await read('../data/game.json'),reference=await read('./fixtures/text-context-reference.json');
const prose=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim();
for(const label of new Set(reference.cases.map(c=>c.label)))test('Native text context derived from domain operations: '+label,()=>{
 for(const c of reference.cases.filter(c=>c.label===label)){
  const d={...data,texts:{...data.texts,...c.texts}},w=new World(d),rng=new OriginalRandom({seed:c.seed,cursor:0});let index=0;
  const text=new Text(d,new Dictionary(d.dictionary),w,{chooseIndex:(count,ctx)=>{
   const call=c.random[index++];assert.equal(ctx.mixOffset,call.mixOffset);assert.equal(count-1,call.width);assert.deepEqual(rng.dump(),{seed:call.seed,cursor:call.cursor});let at=0;
   const result=rng.chooseIndex(count,{mixOffset:ctx.mixOffset,inputs:({cursor,mixOffset})=>{const first=call.reads[at++],second=call.reads[at++];assert.equal(cursor,first.address);assert.equal((cursor+mixOffset+1)&65535,second.address);return {first:first.value,second:second.value};}});
   assert.equal(at,call.reads.length);assert.deepEqual(rng.dump(),{seed:call.next_seed,cursor:call.next_cursor});return result;
  }});
  assert.equal(prose(text.render(c.root,{actor:3,object:0,mixOffset:c.initialMixOffset})),prose(c.text));assert.equal(index,c.random.length);
 }
});
