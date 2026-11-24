import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {gunzipSync} from 'node:zlib';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const saved=JSON.parse(gunzipSync(await readFile(new URL('../results/narrow-arrival-descriptor/pre-north-js-save.json.gz',import.meta.url))));
const make=()=>Game.load(data,structuredClone(saved));
const fresh=(p,mode=1,column=0,counter=0)=>Object.assign(p.state,{scratch:{},cursor:column,remaining:(mode===1?18:36)-column,counter,windowMode:mode,pending:'',spacingFlag:column?1:0,capitalizationFlag:0,started:column>0,upper:Array(18).fill('')});

test('Natural pictured arrival saves E of the next train noun at22, not a scan byte',async()=>{
 const proof=await read('results/look-carried-descriptor/next-stack22.json');assert.deepEqual(proof.unclassified_transitions,[]);const r=proof.reads.at(-1),w=r.writer;
 assert.deepEqual([r.tick,r.actor,r.address,r.value],[3448,3,'5D22',235]);assert.deepEqual([w.pc,w.tick,w.command,w.glyph.frame,w.glyph.word,w.glyph.character,w.glyph.descriptor,w.glyph.mode],[0xC38A,3411,'N',0x5D28,'steam',32,0x58EB,1]);
 const detail=await read('results/narrow-arrival-descriptor/arrival-detail.json');assert.equal(detail.cells['5D22'],235);
 assert(detail.glyphs.some(g=>g.word==='steam'&&g.frame===0x5D1C&&g.char==='s'));
 assert(detail.glyphs.some(g=>g.word==='train.'&&g.frame===0x5D48&&g.char==='t'));
});

test('108 original glyph setups derive only descriptor E under the narrow root-name caller',async()=>{
 const abi=await read('results/narrow-arrival-descriptor/glyph-abi.json'),g=make(),p=g.sourceDisplay,values=new Set();assert.equal(abi.cases.length,108);
 for(const row of abi.cases){fresh(p,1,0,6);p.upperGlyphKnown=false;p.cabWordRole='root-object-prefix';p.glyphDescriptorLowKnown=true;p.glyphResidue(' ',0x5D28,row.column,row.descriptor);
  assert.equal(p.read(0x5D22),row.column<17?row.cells[0x5D22]:null);assert.equal(p.read(0x5D23),null);if(row.column<17)values.add(p.read(0x5D22));}
 assert(values.size>=4);
});

test('216 complete original name-period-CR geometries validate every owned E and retain exclusions',async()=>{
 const abi=await read('results/narrow-arrival-descriptor/name-abi.json');assert.equal(abi.cases.length,216);const g=make(),p=g.sourceDisplay;let owned=0,unknown=0;
 for(const row of abi.cases){fresh(p,row.mode,row.column,row.counter);g.text.setQualifierMode(0);const name=g.world.name(42,{indefinite:true}),prefix=name.lastIndexOf(' '),trace=[{kind:'root-object-prefix',parent:42,start:0,end:prefix,frame:0x5D1C,spaceAfter:true,spaceClearFrame:0x5D20,spaceDescriptorLowKnown:true}];g.text.traceNameBuffer(trace,42,name,0,{indefinite:true});p.write(name+'.',{sceneTrace:trace});
  // Controlled ABI compares owned E only; original text is archived verbatim.
  const value=p.read(0x5D22);if(value===null){unknown++;continue;}assert.equal(value,row.cells[0x5D22],JSON.stringify({mode:row.mode,column:row.column,counter:row.counter}));assert.equal(p.read(0x5D23),null);owned++;
 }
 assert(owned>0);assert(unknown>0);
});

test('Only the ordinary full pictured arrival with one raw root name acquires E ownership',()=>{
 for(const kind of ['ordinary','look','brief','remote','identity','raw-unknown','two-roots','money']){const g=make(),w=g.world;w.move(0,55);if(kind==='identity')w.player=1;if(kind==='two-roots')w.move(3,55);if(kind==='money')w.entity(42).money=true;
  if(kind==='raw-unknown'){const raw=g.text.rawEntityName.bind(g.text);g.text.rawEntityName=(id,options)=>id===42?null:raw(id,options);}
  const trace=[];g.text.scene({source:kind==='look'?'look':'arrival',full:kind!=='brief',remote:kind==='remote',mark:false,trace});const prefix=trace.find(r=>r.kind==='root-object-prefix'&&r.parent===42);assert.equal(prefix?.spaceDescriptorLowKnown===true,kind==='ordinary',kind);
 }
});

test('Wide, margin, MORE and other caller depths do not borrow this root descriptor',()=>{
 for(const kind of ['wide','margin','more','carried','wrong-frame']){const g=make(),p=g.sourceDisplay;fresh(p,kind==='wide'?0:1,0,kind==='more'?14:6);p.upperGlyphKnown=false;p.cabWordRole=kind==='carried'?'carried-object-prefix':'root-object-prefix';p.glyphDescriptorLowKnown=true;p.glyphResidue(' ',kind==='wrong-frame'?0x5D2A:0x5D28,kind==='margin'?17:4,0x58EB);assert.equal(p.read(0x5D22),null,kind);}
});

test('Actual N produces E, Watson arrival preserves it and JSON LOAD retains the computed byte',async()=>{
 const session=new ClientSession(data);await session.request('load',{save:structuredClone(saved)});const result=session.request('command',{command:'N'});assert.notEqual(result.state.analysis.outcome,'not_translated');assert.equal(result.state.clock.label,'Wed 04:52pm');assert.equal(result.state.room,55);assert.equal(session.game.sourceDisplay.read(0x5D22),235);
 const dump=JSON.parse(JSON.stringify(session.game.dump()));assert.equal(Game.load(data,dump).sourceDisplay.read(0x5D22),235);delete dump.world.display.scratch[0x5D22];const legacy=Game.load(data,dump);assert.equal(legacy.sourceDisplay.read(0x5D22),null);legacy.sourceDisplay.write('You go north.',{preserve22:true});assert.equal(legacy.sourceDisplay.read(0x5D22),null);
});
