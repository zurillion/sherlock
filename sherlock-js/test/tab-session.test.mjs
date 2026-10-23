import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';import {rememberTab,recallTab,TAB_SESSION_KEY,capturePresentation,lastResponse} from '../src/tab-session.mjs';
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
 const game=new Game(data,{npcs:false});game.submit('OPEN DOOR');const saved=game.dump();saved.version=1;delete saved.world.scheduler;
 const restored=Game.load(data,saved);assert.deepEqual(restored.submit('ALL'),game.submit('ALL'));assert.equal(restored.dump().version,3);
});
test('The engine selector describes both implementations without an automatic fallback',async()=>{
 const html=await readFile(new URL('../index.html',import.meta.url),'utf8');assert(html.includes('id="engine-select"'));assert(html.includes('Originale · Z80'));assert(html.includes('JavaScript autonomo'));assert(html.includes("'8766':'8768'"));assert(html.includes('Partite separate.'));
});
for(const phase of ['startup','more','printing','clock-animation'])test('Switching engines during '+phase+' preserves the game without requiring a complete terminal snapshot',()=>{
 const game=new Game(data);game.submit('OPEN DOOR');game.submit('ALL');const before=game.dump(),tab=storage();
 const transcript=[{kind:'command',text:'OPEN DOOR'},{kind:'error',text:'WHICH DOOR ?'},{kind:'command',text:'ALL'},{kind:'narrative',text:'You open your door.'},{kind:'narrative',text:'You open the plain door.'}];
 const terminal={active:true,waiting:['startup','more'].includes(phase),processing:phase!=='clock-animation',pictures:true,pictureMode:'svg',snapshot(){throw Error('A busy terminal cannot be snapshotted');}};
 const p=capturePresentation(terminal,{transcript,history:['OPEN DOOR','ALL'],view:[0,0,620,650],allowIncomplete:true,inProgress:true});
 assert.equal(p.redraw,true);assert.equal(p.spectrum,null);rememberTab(tab,game,p);
 const resumed=recallTab(tab,data,saved=>assert.equal(saved.redraw,true));assert.deepEqual(resumed.game.dump(),before);
 assert.equal(resumed.game.world.minutes,482);assert.deepEqual(lastResponse(resumed.presentation.transcript).map(r=>r.text),['You open your door.','You open the plain door.']);
});
test('A completed display retains its exact terminal snapshot',()=>{
 const snapshot={completed:true},terminal={active:true,processing:false,waiting:false,snapshot:()=>snapshot};
 const p=capturePresentation(terminal,{transcript:[],history:[],view:[0,0,620,650],allowIncomplete:true});assert.equal(p.spectrum,snapshot);assert.equal(p.redraw,undefined);
});
