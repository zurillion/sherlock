import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const make=()=>new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
const fresh=p=>Object.assign(p.state,{scratch:{},cursor:0,remaining:36,counter:0,windowMode:0,pending:'',spacingFlag:0,started:false,upper:Array(18).fill('')});

test('Cold original trace distinguishes LOOK-space AF from WEAR-qualifier AF at the same draw',async()=>{
 const proof=await read('results/extra-look-scan-af/natural-writers.json');assert.equal(proof.handover,null);assert.deepEqual(proof.unclassified_transitions,[]);
 assert.deepEqual(proof.reads.map(r=>[r.address,r.tick,r.actor,r.value]),[['5D1A',2730,8,0],['5D20',2730,8,0]]);
 const [look,wear]=proof.reads.map(r=>r.writer);
 assert.deepEqual([look.pc,look.tick,look.command,look.glyph.frame,look.glyph.character,look.glyph.shift],[0xC39D,1770,'LOOK',0x5D26,32,0]);
 assert.deepEqual([wear.pc,wear.tick,wear.command,wear.glyph.frame,wear.glyph.character,wear.glyph.shift],[0xC3B8,2286,'WEAR CHINA MANS DISGUISE',0x5D2C,115,4]);
});

test('Carried separator owns scan F/A independently from shift/count in the original glyph ABI',async()=>{
 const abi=await read('test/fixtures/glyph-count-abi.json'),g=make(),p=g.sourceDisplay;let checked=0;
 for(const row of abi.cases.filter(r=>r.frame===0x5D26&&r.char===' '&&r.column<35)){
  fresh(p);p.glyphFlagsKnown=false;p.upperGlyphKnown=false;p.glyphSpaceScanKnown=true;p.glyphSpaceByteKnown=true;p.glyphSpaceShiftKnown=false;p.glyphSpaceCountKnown=false;
  p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);
  for(const at of [0x5D1A,0x5D1B])assert.equal(p.read(at),row.cells[at]);
  for(const at of [0x5D1C,0x5D1D])assert.equal(p.read(at),null);checked++;
 }
 assert.equal(checked,70);
 fresh(p);p.glyphSpaceScanKnown=false;p.glyphSpaceByteKnown=false;p.glyphResidue(' ',0x5D26,18,0x51AB);
 assert.equal(p.read(0x5D1A),null);assert.equal(p.read(0x5D1B),null);
});

test('LOOK separator AF requires a final common name with a matching raw dictionary span',()=>{
 for(const known of [true,false]){
  const g=make(),w=g.world;w.move(0,45);w.move(3,45);
  if(!known){const original=g.text.rawEntityName.bind(g.text);g.text.rawEntityName=(id,options)=>id===25?null:original(id,options);}
  const trace=[];g.text.scene({source:'look',mark:false,trace});
  const prefix=trace.find(r=>r.kind==='carried-object-prefix'&&r.parent===25);
  assert(prefix);assert.equal(prefix.spaceScanKnown===true,known);assert.equal(prefix.spaceByteKnown===true,known);
 }
});

test('A requested LOOK does not borrow the ordinary LOOK separator AF frame',()=>{
 const g=make();g.world.move(0,45);g.world.move(3,45);
 const trace=[];g.text.scene({source:'look',ordinaryLook:false,mark:false,trace});
 const prefix=trace.find(r=>r.kind==='carried-object-prefix'&&r.parent===25);assert(prefix);
 assert.equal(prefix.spaceScanKnown,undefined);assert.equal(prefix.spaceByteKnown,undefined);
});

test('Ordinary WEAR preserves low scan bytes and derives both argument-prefix AF bytes',async()=>{
 const abi=await read('results/extra-look-wear-scan/wear-abi.json'),g=make(),p=g.sourceDisplay;let checked=0;
 for(const row of abi.cases.filter(r=>r.column===0&&r.counter+3<15)){
  fresh(p);p.state.counter=row.counter;
  for(let at=0x5D1A;at<=0x5D1D;at++)p.state.scratch[at]=165;
  const message={kind:'narrative',text:'You wear '+g.world.name(row.target)+'.',paragraph_before:true};
  g.npcRuntime.annotateArgumentPrefix({messages:[message],cost:1,action:51,args:[row.target]},[message],{player:true});
  assert(message.scene_trace.some(r=>r.kind==='wear-argument-prefix'&&r.frame===0x5D2C));g.projectMessages([message]);
  for(let at=0x5D1A;at<=0x5D21;at++)assert.equal(p.read(at),row.cells[at],JSON.stringify({target:row.target,counter:row.counter,at}));checked++;
 }
 assert.equal(checked,24);
 const glyphs=await read('test/fixtures/glyph-count-abi.json');let nonzero=0;
 for(const row of glyphs.cases.filter(r=>r.frame===0x5D2C)){
  fresh(p);p.upperGlyphKnown=false;p.cabWordRole='wear-argument-prefix';p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);
  assert.equal(p.read(0x5D20),row.cells[0x5D20]);assert.equal(p.read(0x5D21),row.cells[0x5D21]);if(p.read(0x5D21)!==0)nonzero++;
 }
 assert(nonzero>0,'Argument font row is computed, not filled with zero');
});

test('168 complete original rejections preserve the twelve marked fields and have no stack writer at20',async()=>{
 const abi=await read('results/extra-look-scan-af/rejection-abi.json');assert.equal(abi.cases.length,168);
 for(const row of abi.cases){
  assert(row.eligible);assert.equal(row.last20,null);
  for(let at=0x5D1A;at<=0x5D25;at++)assert.equal(row.cells[at],165,row.command);
  const g=make(),w=g.world,p=g.sourceDisplay;w.player=row.player;w.move(row.player,45);w.minutes=1326;w.move(22,45,1);Object.assign(w.entity(22),{attributes:148,properties:128});
  const node=g.parser.parse(row.command).nodes[0],action=g.action(node);w.npcs.sceneryFailure={action,slot:0,found:false};const {message}=g.resolve(node,action);assert.equal(message.text,row.text);
  for(let at=0x5D1A;at<=0x5D25;at++)p.state.scratch[at]=165;
  p.error([message]);for(let at=0x5D1A;at<=0x5D25;at++)assert.equal(p.read(at),row.cells[at],row.command+' '+at.toString(16));
  if(node.groups[0].qualifiers.length)assert.equal(message.preserve_renderer_26,undefined);
 }
});

test('Unknown old save fields are not recreated by a known-preserving error',()=>{
 const g=make(),p=g.sourceDisplay;fresh(p);p.state.scratch[0x5D1A]=7;p.state.scratch[0x5D20]=9;
 const save=JSON.parse(JSON.stringify(g.dump())),loaded=Game.load(data,save);assert.equal(loaded.sourceDisplay.read(0x5D1A),7);assert.equal(loaded.sourceDisplay.read(0x5D20),9);
 delete save.world.display.scratch[0x5D1A];delete save.world.display.scratch[0x5D20];const old=Game.load(data,save);
 old.world.move(0,45);const node=old.parser.parse('OPEN LARGE OAK DOOR').nodes[0],action=old.action(node);old.world.npcs.sceneryFailure={action,slot:0,found:false};old.sourceDisplay.error([old.resolve(node,action).message]);
 assert.equal(old.sourceDisplay.read(0x5D1A),null);assert.equal(old.sourceDisplay.read(0x5D20),null);
});
