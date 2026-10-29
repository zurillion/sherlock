import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{ClientSession}from'../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-flags-abi.json',import.meta.url)));
test('Native glyph ABI at5D1C: screen address, bit shift and AF differ by frame',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;let checked=0;const shifts=new Set();
 for(const row of abi.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame:row.frame,char:row.char,column:row.column,at}));
  if(row.frame<=0x5D28){assert.equal(p.read(0x5D1C),row.cells[0x5D1C]);checked++;}else assert.equal(p.read(0x5D1C),null);
  if(row.frame===0x5D26){const shift=(2+row.column*7)&7;assert.equal(p.read(0x5D1C),shift);shifts.add(shift);}}
 assert.equal(checked,324);assert.equal(shifts.size,8);
});
test('5D1C has conditional ownership and survives SAVE only when known',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D1C),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,5,0x5C0B,3);assert.equal(p.read(0x5D1C),5);p.invalidateGlyphExtras({preserveFlags:true});assert.equal(p.read(0x5D1C),5);const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1C),5);delete save.world.display.scratch[0x5D1C];assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1C),null);
 p.glyphFlagsKnown=false;p.glyphResidue('q',0x5D26,5,0x5C0B,3);assert.equal(p.read(0x5D1C),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,5,0x5C0B,3);p.write('Unknown caller.');assert.equal(p.read(0x5D1C),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,5,0x5C0B,3);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D1C),null);
});

test('Natural 5D1C ownership, last writer and exact target read',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-shift/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];
 assert.deepEqual(ref.unclassified_transitions,[]);const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D1C)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0;
 for(const[index,row]of ref.steps.entries()){
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);if(!out.running||index===ref.steps.length-1&&g.world.tick===row.clock.tick)break;assert(g.world.tick<=row.clock.tick,'Overshot source checkpoint');out=s.request('continue-command',{job:out.job});}
  assert.equal(g.world.tick,row.clock.tick);const value=g.sourceDisplay.read(0x5D1C);if(value!==null){produced++;assert.equal(value,row.value,row.input+' '+row.clock.label);}
 }
 assert(produced>0);assert.equal(reads.length,1);assert.deepEqual(reads,ref.reads.slice(0,1).map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=ref.reads[0].last_store;assert.equal(writer.pc,'C3B7');assert.equal(writer.tick,962);assert.equal(writer.actor,2);assert.equal(writer.glyph.frame,0x5D26);assert.equal(writer.glyph.char,32);assert.equal(writer.value,writer.bc&255);assert.equal(g.sourceDisplay.read(0x5D1C),writer.value);
 if(s.job?.liveWait)s.request('continue-command',{job:s.job.id,interrupt:true});
 const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1C),writer.value);
});
