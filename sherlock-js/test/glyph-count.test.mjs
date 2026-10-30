import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{ClientSession}from'../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-count-abi.json',import.meta.url)));
for(const frame of [0x5D1E,0x5D20,0x5D22,0x5D24,0x5D26,0x5D28,0x5D2A,0x5D2C])for(const count of [3,7])for(const char of [' ','T','q'])test('Native5D1D ABI frame'+frame.toString(16)+' B'+count+' char'+char.charCodeAt(0),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,rows=abi.cases.filter(r=>r.frame===frame&&r.count===count&&r.char===char);assert.equal(rows.length,36);
 for(const row of rows){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);
  for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame,count,char,column:row.column,at}));
  if(frame<=0x5D28)assert.equal(p.read(0x5D1D),row.cells[0x5D1D]);else assert.equal(p.read(0x5D1D),null);
 }
});
test('5D1D ownership and save: independent B, known shallow preservation, unknown caller revocation',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D1D),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,35,0x5C0B,7);assert.equal(p.read(0x5D1D),1);p.invalidateGlyphExtras({preserveFlags:true});assert.equal(p.read(0x5D1D),1);
 p.glyphResidue('q',0x5D20,35,0x5C0B);assert.equal(p.read(0x5D1D),null,'caller B without a count is unknown');p.glyphResidue('q',0x5D26,35,0x5C0B,7);
 const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1D),1);delete save.world.display.scratch[0x5D1D];assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1D),null);
 p.glyphFlagsKnown=false;p.glyphResidue('q',0x5D26,35,0x5C0B,7);assert.equal(p.read(0x5D1D),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,35,0x5C0B,7);p.write('Unprojected caller.');assert.equal(p.read(0x5D1D),null);p.glyphFlagsKnown=true;p.glyphResidue('q',0x5D26,35,0x5C0B,7);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D1D),null);
});

test('Natural5D1D: every owned input checkpoint and first operand before the5D23 boundary',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-count/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];
 assert.deepEqual(ref.unclassified_transitions,[]);const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D1D)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0,blocked=false;
 for(const[index,row]of ref.steps.entries()){
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){if(out.state.analysis.outcome==='not_translated'){assert.equal(index,ref.steps.length-1);assert.match(out.state.prototype_notice,/\$5D23/);blocked=true;break;}if(!out.running||index===ref.steps.length-1&&g.world.tick===row.clock.tick)break;assert(g.world.tick<=row.clock.tick);out=s.request('continue-command',{job:out.job});}
  if(blocked)break;assert.equal(g.world.tick,row.clock.tick);const value=g.sourceDisplay.read(0x5D1D);if(value!==null){produced++;assert.equal(value,row.cells['5D1D'],row.input+' '+row.clock.label);}
 }
 assert(produced>0);assert(blocked,'source observation continues beyond the supported first operand; no complete late checkpoint is claimed');
 const target=ref.reads.filter(r=>r.address==='5D1D');assert.equal(reads.length,1);assert.deepEqual(reads,target.map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=target[0].last_store;assert.equal(writer.pc,'C3B7');assert.equal(writer.tick,962);assert.equal(writer.actor,2);assert.equal(writer.glyph.frame,0x5D26);assert.equal(writer.glyph.char,32);assert.equal(writer.value,writer.bc>>>8);assert.equal(g.sourceDisplay.read(0x5D1D),writer.value);
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D1D),writer.value);
});
