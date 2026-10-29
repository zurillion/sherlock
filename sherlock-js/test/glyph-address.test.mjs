import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{ClientSession}from'../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-address-abi.json',import.meta.url)));
test('Original glyph ABI at5D22: six caller frames and all36 columns',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,addresses=new Set();assert.equal(abi.cases.length,648);
 for(const row of abi.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame:row.frame,char:row.char,column:row.column,at}));assert.equal(p.read(0x5D22),row.cells[0x5D22],JSON.stringify(row));if(row.frame===0x5D2A){const lo=(0x5020+Math.floor((2+7*row.column)/8))&255;assert.equal(p.read(0x5D22),lo);addresses.add(lo);}}
 assert(addresses.size>20);
});
test('5D22 ownership: unknown boot, caller scope, overwrites and saved continuation',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D22),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);assert.equal(p.read(0x5D22),39);const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D22),39);delete saved.world.display.scratch[0x5D22];assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D22),null);
 p.upperGlyphKnown=false;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);assert.equal(p.read(0x5D22),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,9,0x5C0B,1);assert.notEqual(p.read(0x5D22),null);p.write('Unknown caller.');assert.equal(p.read(0x5D22),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D22),null);
});

test('Natural5D22: every owned checkpoint, actual last writer and exact cook read',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-address/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];assert.deepEqual(ref.unclassified_transitions.filter(e=>e.address==='5D22'),[]);
 const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D22)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0;
 for(const[index,row]of ref.steps.entries()){
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);if(!out.running||index===ref.steps.length-1&&g.world.tick===row.clock.tick)break;assert(g.world.tick<=row.clock.tick,'Overshot native checkpoint');out=s.request('continue-command',{job:out.job});}
  assert.equal(g.world.tick,row.clock.tick);const value=g.sourceDisplay.read(0x5D22);if(value!==null){produced++;assert.equal(value,row.cells['5D22'],row.input+' '+row.clock.label);}
 }
 const expected=ref.reads.filter(r=>r.address==='5D22');assert.equal(expected.length,1);assert(produced>0);assert.deepEqual(reads,expected.map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=expected[0].last_store;assert.equal(writer.pc,'C398');assert.equal(writer.glyph.frame,0x5D2A);assert.equal(writer.actor,2);assert.equal(writer.value,writer.hl&255);const column=((writer.glyph.screen_address-0x5020)*8+writer.glyph.shift-2)/7;assert(Number.isInteger(column));assert.equal(writer.value,(0x5020+Math.floor((2+7*column)/8))&255);assert.equal(g.sourceDisplay.read(0x5D22),writer.value);
 if(s.job?.liveWait)s.request('continue-command',{job:s.job.id,interrupt:true});
 const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D22),writer.value);
});
