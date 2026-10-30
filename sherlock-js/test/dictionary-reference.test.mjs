import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {gunzipSync} from 'node:zlib';
import {Game} from '../src/game.mjs';
import {Text} from '../src/text.mjs';
import {assertOriginalState} from './helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url)));
const abi=JSON.parse(await readFile(new URL('fixtures/dictionary-reference-abi.json',import.meta.url)));
for(const row of abi.cases)test('A887 dictionary descriptor '+row.value.toString(16)+' / visible='+row.visible,()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});g.world.npcs.dictionaryReference=row.initial;
 const t=new Text({...data,texts:{ABI:[{op:'word',id:row.offset,randomContext:row.value,form:row.mode===0x50?'stem':'inflected'}]}},g.dictionary,g.world);
 t.render('ABI',{bufferVisible:row.visible});assert.equal(g.world.npcs.dictionaryReference,row.final);
 assert.equal(g.npcRuntime.read(0xA022),row.final&255);assert.equal(g.npcRuntime.read(0xA023),row.final>>>8);
});
test('Descriptor lifetime: literals and hidden output preserve, synthetic output revokes, LOAD has no fallback',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});g.world.npcs.dictionaryReference=0x5861;
 const t=new Text({...data,texts:{LITERAL:[{op:'literal',text:'Hello.'}],HIDDEN:[{op:'word',id:353,randomContext:0x5161,form:'stem'}]}},g.dictionary,g.world);
 t.render('LITERAL');t.render('HIDDEN',{bufferVisible:false});assert.equal(g.world.npcs.dictionaryReference,0x5861);
 const before=g.dump();g.scene();g.parser.analyze('LOOK');assert.deepEqual(g.dump(),before);
 const loaded=Game.load(data,JSON.parse(JSON.stringify(before)));assert.equal(loaded.npcRuntime.read(0xA022),97);assert.equal(loaded.npcRuntime.read(0xA023),88);
 delete before.world.npcs.dictionaryReference;const old=Game.load(data,before);assert.equal(old.npcRuntime.read(0xA022),null);
 old.parser.analyze('LOOK');assert.equal(old.npcRuntime.read(0xA022),null);
 g.projectMessages([{kind:'narrative',text:'Unprojected text.'}]);assert.equal(g.npcRuntime.read(0xA022),null);
});
const ref=JSON.parse(gunzipSync(await readFile(new URL('fixtures/dictionary-reference.json.gz',import.meta.url))));
for(const [index,c]of ref.cases.entries())test('Natural dictionary reference '+index+(index===4?' / certified cab prefix before existing5D0C boundary':' / '+c.steps[0].input),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});assert.equal(g.world.npcs.dictionaryReference,c.boot_reference,'bootstrap reference');let loaded=null;
 for(const row of (index===4?c.steps.slice(0,7):c.steps)){const n=g.world.random.draws,out=g.submit(row.input),count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];
  assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);
  if(g.world.npcs.dictionaryReference!==null)assert.equal(g.world.npcs.dictionaryReference,row.dictionary_reference,'owned word '+row.input);
  assert.equal(draws.length,row.random.length);for(const[i,d]of row.random.entries())for(const k of ['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][k],d[k],row.input+' draw '+i+' '+k);
  assertOriginalState(g,row.after,row.input);
  if(loaded){assert.deepEqual(loaded.submit(row.input),out);assert.deepEqual(loaded.dump(),g.dump());}loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));
 }
});
