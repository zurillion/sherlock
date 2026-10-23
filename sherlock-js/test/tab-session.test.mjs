import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';import {rememberTab,recallTab,TAB_SESSION_KEY} from '../src/tab-session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
const storage=()=>({rows:new Map(),getItem(key){return this.rows.get(key)||null;},setItem(key,value){this.rows.set(key,value);}});
test('Switching away and back preserves pending ALL, later effects and presentation',()=>{
 const game=new Game(data),tab=storage();game.submit('OPEN DOOR');rememberTab(tab,game,{transcript:['OPEN DOOR','WHICH DOOR ?']});
 const restored=recallTab(tab,data,p=>assert.equal(p.transcript.at(-1),'WHICH DOOR ?'));
 assert.deepEqual(restored.game.submit('ALL'),game.submit('ALL'));assert.deepEqual(restored.game.submit('WEST'),game.submit('WEST'));
 assert.equal(restored.game.world.roomOf(),7);
});
test('A tab checkpoint is not a conversion of the original engine save',()=>{
 const tab=storage();tab.setItem(TAB_SESSION_KEY,JSON.stringify({engine:'original',game:{memory:[]}}));assert.throws(()=>recallTab(tab,data,()=>{}),/altro motore/);
});
test('Version-one JS saves migrate to a logical scheduler without losing a clarification',()=>{
 const game=new Game(data);game.submit('OPEN DOOR');const saved=game.dump();saved.version=1;delete saved.world.scheduler;
 const restored=Game.load(data,saved);assert.deepEqual(restored.submit('ALL'),game.submit('ALL'));assert.equal(restored.dump().version,2);
});
test('The engine selector describes both implementations without an automatic fallback',async()=>{
 const html=await readFile(new URL('../index.html',import.meta.url),'utf8');assert(html.includes('id="engine-select"'));assert(html.includes('Originale · Z80'));assert(html.includes('JavaScript autonomo'));assert(html.includes("'8766':'8768'"));assert(html.includes('Partite separate.'));
});
