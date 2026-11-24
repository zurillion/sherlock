import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {gunzipSync} from 'node:zlib';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const saved=JSON.parse(gunzipSync(await readFile(new URL('../results/train-countryside-font/pre-wait-js-save.json.gz',import.meta.url))));
const make=()=>Game.load(data,structuredClone(saved));
const fresh=(p,mode=0,column=0,counter=5)=>Object.assign(p.state,{scratch:{},cursor:column,remaining:(mode?18:36)-column,counter,windowMode:mode,pending:'',spacingFlag:column?1:0,capitalizationFlag:1,started:column>0,upper:Array(18).fill('')});
function prose(g){const events=[],text=g.text.render('7E45',{captureBuffer:(c,options)=>events.push({c,...options})}),at=text.indexOf(' English ');assert(at>=0);return {text,trace:[{kind:'raw-text-buffer',start:0,end:text.length,events},{kind:'train-description-english',start:at+1,end:at+8,frame:0x5D2E,trainScanKnown:true}]};}

test('The paired original read has two independent English writers: raw font A and descriptor D',async()=>{
 const proof=await read('results/train-countryside-font/paired-writers.json');assert.deepEqual(proof.unclassified_transitions,[]);assert.deepEqual(proof.reads.map(r=>[r.address,r.tick,r.actor,r.value]),[['5D23',3535,8,0],['5D29',3535,8,92]]);
 for(const r of proof.reads){const w=r.writer;assert.deepEqual([w.tick,w.command,w.actor,w.glyph.word,w.glyph.character,w.glyph.frame],[3504,'WAIT UNTIL 7:29PM',0,'english',104,0x5D2E]);assert.equal(w.pc,r.address==='5D23'?0xC3B8:0xC38A);}
 const detail=await read('results/train-countryside-font/departure-detail.json');assert.equal(detail.cells_after_prose['5D23'],0);assert.equal(detail.cells_after_prose['5D29'],92);assert(detail.messages.some(m=>m.text.includes('picturesque English countryside.')));
});

test('216 original glyph cases distinguish nonzero font rows and different descriptor high bytes',async()=>{
 const abi=await read('results/train-countryside-font/glyph-abi.json'),g=make(),p=g.sourceDisplay,fonts=new Set(),descriptors=new Set();assert.equal(abi.cases.length,216);
 for(const row of abi.cases){fresh(p);p.upperGlyphKnown=false;p.trainScanKnown=true;p.cabWordRole='train-description-english';p.glyphResidue(row.char,0x5D2E,row.column,row.descriptor,3);
  for(const at of [0x5D23,0x5D29])assert.equal(p.read(at),row.column<35?row.cells[at]:null);if(row.column<35){fonts.add(p.read(0x5D23));descriptors.add(p.read(0x5D29));}}
 assert(fonts.size>1);assert.deepEqual([...descriptors].sort(),[81,92]);
});

test('162 original countryside fragments plus CR validate each owned field through wrapping',async()=>{
 const abi=await read('results/train-countryside-font/prose-abi.json');assert.equal(abi.cases.length,162);const g=make(),p=g.sourceDisplay;let owned=0,unknown=0;
 for(const row of abi.cases){fresh(p,row.mode,row.column,row.counter);const {text,trace}=prose(g);p.write(text,{sceneTrace:trace});
  // Controlled ABI asserts owned fields; original word packets remain verbatim.
  for(const at of [0x5D23,0x5D29]){const value=p.read(at);if(value===null){unknown++;continue;}assert.equal(value,row.cells[at],JSON.stringify({mode:row.mode,column:row.column,counter:row.counter,address:at}));owned++;}}
 assert(owned>0);assert(unknown>0);
});

test('Narrow, margin, MORE, alternate identity and unrelated glyph callers stay unowned',()=>{
 for(const kind of ['narrow','margin','more','identity','role','frame','picture']){const g=make(),p=g.sourceDisplay;fresh(p,kind==='narrow'?1:0,0,kind==='more'?14:5);p.upperGlyphKnown=false;p.trainScanKnown=true;p.cabWordRole=kind==='role'?'carried-object-prefix':'train-description-english';if(kind==='identity')g.world.player=1;if(kind==='picture')delete p.state.pictureWindow;
  p.glyphResidue('q',kind==='frame'?0x5D30:0x5D2E,kind==='margin'?35:4,0x5C0B,3);for(const at of [0x5D23,0x5D29])assert.equal(p.read(at),null,kind+' '+at.toString(16));}
});

test('The actual live WAIT reaches the departure, and SAVE retains zero A and independent D',async()=>{
 const session=new ClientSession(data);await session.request('load',{save:structuredClone(saved)});let out=session.request('start-command',{command:'WAIT UNTIL 7:29PM'}),steps=0;
 while(session.game.world.tick<=3504&&out.running&&++steps<10)out=session.request('continue-command',{job:out.job});assert.equal(session.game.world.tick,3505);assert.notEqual(out.state.analysis.outcome,'not_translated');
 const p=session.game.sourceDisplay;assert.equal(p.read(0x5D23),0);assert.equal(p.read(0x5D29),92);session.request('continue-command',{job:out.job,interrupt:true});const dump=JSON.parse(JSON.stringify(session.game.dump())),loaded=Game.load(data,dump);assert.equal(loaded.sourceDisplay.read(0x5D23),0);assert.equal(loaded.sourceDisplay.read(0x5D29),92);
 delete dump.world.display.scratch[0x5D23];const old=Game.load(data,dump);old.sourceDisplay.write('You go north.',{preserve23:true,preserve29:true});assert.equal(old.sourceDisplay.read(0x5D23),null);assert.equal(old.sourceDisplay.read(0x5D29),92);
});

test('The new boundary CB29 is mutable saved-rule-index data, with an observed CB37 writer',async()=>{
 const p=await read('results/train-countryside-font/next-rule-result.json');assert.deepEqual(p.unclassified_transitions,[]);assert.equal(p.read.address,'CB29');assert.equal(p.read.tick,3581);assert.equal(p.writer.pc,'CB37');assert.deepEqual([p.writer.owner.handler,p.writer.owner.caller,p.writer.ix],[0xE5AA,0xCA67,0x9997]);assert.equal(p.read.value,p.writer.ix>>>8);assert(p.observed_stores>0);
});
