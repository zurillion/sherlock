import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const make=()=>new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
function fresh(p,column=0,counter=0){Object.assign(p.state,{scratch:{[0x5D1A]:165,[0x5D1B]:165,[0x5D1C]:165,[0x5D1D]:165,[0x5D20]:165,[0x5D21]:165},cursor:column,remaining:36-column,counter,windowMode:0,pending:'',spacingFlag:column?1:0,started:column>0,upper:Array(18).fill('')});}
function caption(g,row){g.text.setQualifierMode(0);const base=g.data.actions.find(a=>a.id===row.action).words[0],word=g.dictionary.word(g.dictionary.lookup(base.toUpperCase()).value);return {kind:'narrative',text:(row.actor===0?'You':g.world.name(row.actor))+' '+(row.actor===0?word.stem:word.form)+' out of '+g.world.name(row.target)+'.'};}

test('The last original writer of20 is the steam qualifier scan AF in Watsons ordinary exit',async()=>{
 const p=await read('results/container-exit-af/natural-writer.json');assert.deepEqual(p.unclassified_transitions,[]);assert(p.handover.clock_room_video_counter_and_mode_match);
 const r=p.reads.at(-1),w=r.writer;assert.deepEqual([r.address,r.tick,r.actor,r.value],['5D20',3263,3,0]);
 assert.deepEqual([w.pc,w.tick,w.actor,w.command,w.glyph.word,w.glyph.frame,w.glyph.character],[0xC3B8,3210,3,'GET OUT','steam',0x5D2C,109]);
 const detail=await read('results/container-exit-af/get-out-detail.json');assert(detail.messages.some(m=>m.text.includes('Watson climbs out of the steam train.')));
 for(const actor of [0,3])assert(detail.glyphs.some(g=>g.actor===actor&&g.active_word==='train.'&&g.frame===0x5D46));
});

test('1152 original captions validate the bounded exit producer and the final noun wrap',async()=>{
 const abi=await read('results/container-exit-af/caption-abi.json');assert.equal(abi.cases.length,1152);const g=make(),p=g.sourceDisplay;let owned=0;
 for(const row of abi.cases){fresh(p,row.column,row.counter);const m=caption(g,row);assert.equal(m.text,row.text.trim());g.npcRuntime.annotateArgumentPrefix({cost:2,action:row.action,args:[row.target],messages:[m]},[m],{player:row.actor===0,actor:row.actor});g.projectMessages([m]);
  if(row.column===0&&row.counter+4<15){assert(m.scene_trace.some(t=>t.kind==='container-exit-prefix'));for(const at of [0x5D20,0x5D21])assert.equal(p.read(at),row.cells[at]);if(m.text.length<36)for(let at=0x5D1A;at<=0x5D1D;at++){assert.equal(row.cells[at],165);assert.equal(p.read(at),165);}owned++;}
  else for(const at of [0x5D20,0x5D21])assert.equal(p.read(at),null);
 }
 assert.equal(owned,16);
});

test('The producer computes both AF bytes for every glyph column and nonzero font rows',async()=>{
 const abi=await read('test/fixtures/glyph-count-abi.json'),g=make(),p=g.sourceDisplay;let checked=0,nonzero=0;
 for(const row of abi.cases.filter(r=>r.frame===0x5D2C)){fresh(p);p.upperGlyphKnown=false;p.cabWordRole='container-exit-prefix';p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const at of [0x5D20,0x5D21])assert.equal(p.read(at),row.cells[at]);if(p.read(0x5D21))nonzero++;checked++;}
 assert.equal(checked,216);assert(nonzero>0);
});

test('The 120 original direction captions preserve the marked AF; only fresh bounded player captions own it',async()=>{
 const abi=await read('results/container-exit-af/direction-abi.json');assert.equal(abi.cases.length,120);let owned=0;
 for(const row of abi.cases){const g=make(),w=g.world,p=g.sourceDisplay;w.move(0,54);w.rooms[54].exits=[{direction_id:row.action,target:53,gate:0}];fresh(p,row.column,row.counter);
  const node=g.parser.parse(g.data.actions.find(a=>a.id===row.action).words[0].toUpperCase()).nodes[0],out=g.executeNode(node),m=out.messages[0];assert.equal(m.text,row.text.trim());g.projectMessages([m]);
  const eligible=row.column===0&&row.counter+3<15;
  for(const at of [0x5D20,0x5D21]){assert.equal(row.cells[at],165);assert.equal(p.read(at),eligible?165:null);}if(eligible)owned++;
 }
 assert.equal(owned,20);
});

test('360 original brief-scene geometries validate whole-call preservation without inventing a missing value',async()=>{
 const abi=await read('results/container-exit-af/brief-abi.json');assert.equal(abi.cases.length,360);const g=make(),p=g.sourceDisplay;let owned=0;
 // Match the native controlled scene: these two rooms have no listed occupants.
 for(const e of g.world.entities)if(e.id!==0&&e.parent===null&&e.rooms.length<2&&e.rooms.some(room=>[50,53].includes(room)))g.world.move(e.id,0);
 for(const row of abi.cases){g.world.move(0,row.room);const trace=[],text=g.text.scene({full:false,source:'arrival',mark:false,trace});assert.equal(text,row.text.trim());fresh(p,row.column,row.counter);p.write(text,{sceneTrace:trace});
  const eligible=row.column===0&&row.counter+8<15;for(const at of [0x5D20,0x5D21])assert.equal(p.read(at),eligible?row.cells[at]:null);if(eligible)owned++;
 }
 assert.equal(owned,4);
 fresh(p);delete p.state.scratch[0x5D20];delete p.state.scratch[0x5D21];g.world.move(0,50);const trace=[],text=g.text.scene({full:false,source:'arrival',mark:false,trace});p.write(text,{sceneTrace:trace});assert.equal(p.read(0x5D20),null);assert.equal(p.read(0x5D21),null);
});

test('The missing class7 CLIMB reference preserves AF in both resolution branches and the original context',async()=>{
 const abi=await read('results/container-exit-af/error-abi.json');assert.equal(abi.cases.length,18);
 for(const row of abi.cases){assert(row.eligible);assert.deepEqual(row.cells,[165,165]);for(const scenery of [undefined,{action:12,slot:0,found:false}]){const g=make(),w=g.world,p=g.sourceDisplay;w.player=row.player;w.move(row.player,50);w.npcs.sceneryFailure=scenery;fresh(p);const node=g.parser.parse(row.command).nodes[0],m=g.resolve(node,12).message;assert.equal(m.text,row.text);p.error([m]);assert.equal(p.read(0x5D20),165);assert.equal(p.read(0x5D21),165);}}
 const original=await read('results/container-exit-af/original-error-marker.json');assert.deepEqual(original.before,original.after);assert.deepEqual(original.cells,[165,165]);
});

test('Requests, alternate callers, partial captions and unverified scene kinds do not acquire the exit AF',()=>{
 for(const row of [{actor:undefined,player:false},{actor:1,player:true},{actor:3,player:false,projected:true}]){const g=make(),p=g.sourceDisplay;fresh(p);const m=caption(g,{actor:3,action:13,target:42});g.npcRuntime.annotateArgumentPrefix({cost:2,action:13,args:[42],messages:[m],projected:row.projected},[m],row);assert.equal(m.scene_trace,undefined);}
 for(const opts of [{source:'look',full:false},{source:'arrival',full:true},{source:'arrival',full:false,remote:true}]){const g=make();g.world.move(0,50);const trace=[];g.text.scene({...opts,mark:false,trace});assert(!trace.some(t=>t.kind==='brief-root-preserves-exit-af'));}
});

test('SAVE keeps a zero AF pair, while old missing fields are not supplied by known-preserving code',()=>{
 const g=make(),p=g.sourceDisplay;fresh(p);const m=caption(g,{actor:3,action:13,target:42});g.npcRuntime.annotateArgumentPrefix({cost:2,action:13,args:[42],messages:[m]},[m],{actor:3});g.projectMessages([m]);const save=JSON.parse(JSON.stringify(g.dump()));for(const at of [0x5D20,0x5D21])assert.equal(Game.load(data,save).sourceDisplay.read(at),0);
 for(const at of [0x5D20,0x5D21])delete save.world.display.scratch[at];const old=Game.load(data,save);old.world.move(0,50);const n=old.parser.parse('CLIMB INTO POLICE CAB').nodes[0];old.sourceDisplay.error([old.resolve(n,12).message]);for(const at of [0x5D20,0x5D21])assert.equal(old.sourceDisplay.read(at),null);
});
