import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {gunzipSync} from 'node:zlib';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const saved=JSON.parse(gunzipSync(await readFile(new URL('../results/look-carried-descriptor/pre-look-js-save.json.gz',import.meta.url))));
const make=()=>Game.load(data,structuredClone(saved));
const fresh=(p,column=0,counter=0)=>Object.assign(p.state,{scratch:{},cursor:column,remaining:36-column,counter,windowMode:0,pending:'',spacingFlag:column?1:0,capitalizationFlag:1,started:column>0,upper:Array(18).fill('')});

test('Original LOOK saves D of the next noun at21; the final noun and wrap use shallower frames',async()=>{
 const proof=await read('results/container-exit-af/next-look-descriptor.json');assert.deepEqual(proof.unclassified_transitions,[]);
 const r=proof.reads.at(-1),w=r.writer;assert.deepEqual([r.tick,r.actor,r.address,r.value],[3350,3,'5D21',81]);
 assert.deepEqual([w.pc,w.tick,w.command,w.glyph.frame,w.glyph.character,w.glyph.descriptor],[0xC38A,3315,'LOOK',0x5D26,32,0x51AB]);
 const detail=await read('results/look-carried-descriptor/look-detail.json');assert.equal(detail.cells['5D21'],81);
 assert(detail.glyphs.some(g=>g.word==='chronicle.'&&g.frame===0x5D4C&&g.char==='c'));
 assert(detail.glyphs.some(g=>g.word==='chronicle.'&&g.frame===0x5D46&&g.descriptor===0x5A20));
});

test('216 original glyph setups prove descriptor high is independent from pixel column and not fixed51',async()=>{
 const abi=await read('results/look-carried-descriptor/glyph-abi.json'),g=make(),p=g.sourceDisplay,values=new Set();assert.equal(abi.cases.length,216);
 for(const row of abi.cases){fresh(p);p.upperGlyphKnown=false;p.glyphDescriptorHighKnown=true;p.glyphResidue(' ',0x5D26,row.column,row.descriptor);assert.equal(p.read(0x5D21),row.cells[0x5D21]);assert.equal(p.read(0x5D20),null);values.add(p.read(0x5D21));}
 assert(values.size>4);
});

test('144 complete original LOOK geometries verify owned D through final noun CR and wrap',async()=>{
 const abi=await read('results/look-carried-descriptor/look-abi.json');assert.equal(abi.cases.length,144);let owned=0,unknown=0,wrapped=0;
 for(const row of abi.cases){const g=make(),p=g.sourceDisplay;fresh(p,row.column,row.counter);const trace=[],text=g.text.scene({source:'look',mark:false,trace});p.write(text,{sceneTrace:trace});
  // This controlled ABI asserts only owned D. Native output is archived
  // verbatim; exact output and bitmap parity belong to the natural replay.
  const actual=p.read(0x5D21);if(actual===null){unknown++;continue;}assert.equal(actual,row.cells[0x5D21],JSON.stringify({column:row.column,counter:row.counter}));owned++;
  if(row.column===0&&row.counter===0){assert.equal(actual,81);wrapped++;}
 }
 assert(owned>0);assert(unknown>0);assert(wrapped>0);
});

test('Only ordinary raw final common carried names own the next-noun descriptor',()=>{
 for(const kind of ['ordinary','requested','raw-unknown','money','arrival']){const g=make(),p=g.sourceDisplay;fresh(p);if(kind==='money')g.world.entity(25).money=true;
  if(kind==='raw-unknown'){const raw=g.text.rawEntityName.bind(g.text);g.text.rawEntityName=(id,opts)=>id===25?null:raw(id,opts);}
  const trace=[];g.text.scene({source:kind==='arrival'?'arrival':'look',ordinaryLook:kind!=='requested',mark:false,trace});
  const role=trace.find(r=>r.kind==='carried-object-prefix'&&r.parent===25);
  assert.equal(role?.spaceDescriptorHighKnown===true,kind==='ordinary',kind);
 }
});

test('Separator scopes exclude margin, MORE and narrow mode without filling absent fields',()=>{
 for(const kind of ['ordinary','margin','more','narrow']){const g=make(),p=g.sourceDisplay;fresh(p,kind==='margin'?30:0,kind==='more'?14:0);if(kind==='narrow')Object.assign(p.state,{windowMode:1,remaining:18});
  p.scene('daily',[{kind:'carried-object-prefix',parent:25,start:0,end:5,frame:0x5D1A,spaceAfter:true,spaceDescriptorHighKnown:true}]);
  assert.equal(p.read(0x5D21),kind==='ordinary'?81:null,kind);
 }
 const g=make(),p=g.sourceDisplay;fresh(p);const trace=[],text=g.text.scene({source:'look',mark:false,trace});for(const role of trace)delete role.spaceDescriptorHighKnown;p.write(text,{sceneTrace:trace});assert.equal(p.read(0x5D21),null);
});

test('SAVE preserves computed D and independent missing legacy bytes',()=>{
 const g=make(),p=g.sourceDisplay;fresh(p);const trace=[],text=g.text.scene({source:'look',mark:false,trace});p.write(text,{sceneTrace:trace});assert.equal(p.read(0x5D21),81);
 const save=JSON.parse(JSON.stringify(g.dump())),loaded=Game.load(data,save);assert.equal(loaded.sourceDisplay.read(0x5D21),81);assert.equal(loaded.sourceDisplay.read(0x5D20),null);
 delete save.world.display.scratch[0x5D21];assert.equal(Game.load(data,save).sourceDisplay.read(0x5D21),null);
});
