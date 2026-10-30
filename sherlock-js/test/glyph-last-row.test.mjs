import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-abi.json',import.meta.url)));
for(const frame of[0x5D24,0x5D26,0x5D28,0x5D2A,0x5D2C,0x5D2E,0x5D30,0x5D32])for(const count of[3,7])for(const char of[' ','T','q'])test('Native5D27 ABI frame'+frame.toString(16)+' B'+count+' char'+char.charCodeAt(0),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,rows=abi.cases.filter(r=>r.frame===frame&&r.count===count&&r.char===char);assert.equal(rows.length,36);
 for(const row of rows){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame,count,char,column:row.column,at}));if(frame>=0x5D28&&frame<=0x5D32)assert.equal(p.read(0x5D27),row.cells[0x5D27]);else assert.equal(p.read(0x5D27),null);}
});
test('Last font row is variable, unrotated, and independent of saved scan flags',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-last-row/font-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(ref.cases.length,768);const values=new Set();
 for(const row of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);assert.equal(p.read(0x5D27),row.cells[0x5D27]);assert.equal(p.read(0x5D27),data.spectrum.glyphs[row.char.charCodeAt(0)-data.spectrum.first][7]);values.add(p.read(0x5D27));for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify(row));}
 assert(values.has(0));assert(values.has(6));assert(values.has(255));assert(values.size>=8);
});
test('Real C374 clear calls preserve distinct return-link and saved-register roles',async()=>{
 const ref=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-clear-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(ref.cases.length,288);
 for(const row of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(' ',row.frame,row.column,0x5A20);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame:row.frame,column:row.column,at}));if(row.frame===0x5D26)assert.equal(p.read(0x5D27),0xC3);}
});
test('Ownership, unknown callers and LOAD do not invent a missing font row',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D27),null);p.upperGlyphKnown=true;p.glyphResidue('q',0x5D32,8,0x5C42,7);assert.equal(p.read(0x5D27),6);assert.equal(p.read(0x5D26),0);assert.equal(p.read(0x5D25),null);
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D27),6);delete saved.world.display.scratch[0x5D27];const old=Game.load(data,saved);assert.equal(old.sourceDisplay.read(0x5D27),null);assert.equal(old.sourceDisplay.read(0x5D26),0);
 p.invalidateGlyphExtras();assert.equal(p.read(0x5D27),null);p.upperGlyphKnown=true;p.glyphResidue('q',0x5D32,8,0x5C0B,1);p.write('Unknown caller.');assert.equal(p.read(0x5D27),null);
 p.upperGlyphKnown=true;p.glyphResidue('q',0x5D32,8,0x5C0B,1);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D27),null);p.upperGlyphKnown=false;p.glyphResidue('q',0x5D32,8,0x5C0B,1);assert.equal(p.read(0x5D27),null);
 p.upperGlyphKnown=true;p.glyphResidue('q',0x5D32,8,0x5C0B,1);g.npcRuntime.print('682A',2,{object:31,action:29,args:[1,255],actorNameFrame:0x5D2A,actorNameUpper:true,roomNameFrame:0x5D32,preserveGlyphFlags:true},[],{force:true});assert.equal(p.read(0x5D27),null,'unqualified room names have no projected stack contract');
});
test('Natural raw glyph row matches every owned checkpoint and the cook random read',async()=>{
 const{ClientSession}=await import('../src/session.mjs'),ref=JSON.parse(await readFile(new URL('../results/glyph-last-row/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];assert.deepEqual(ref.unclassified_transitions,[]);
 const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D27)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0;
 const cutoff=3301; // Wed15:00: complete differential prefix; A027 remains unimplemented beyond it.
 for(const[index,row]of ref.steps.entries()){
  const target=Math.min(row.clock.tick,cutoff);
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){assert.notEqual(out.state.analysis.outcome,'not_translated',row.input+' '+out.state.prototype_notice);if(!out.running||row.clock.tick>=cutoff&&g.world.tick===cutoff)break;assert(g.world.tick<=target);out=s.request('continue-command',{job:out.job});}
  assert.equal(g.world.tick,target);const value=g.sourceDisplay.read(0x5D27);if(value!==null){produced++;assert.equal(value,row.cells['5D27'],row.input+' '+row.clock.label);}
  if(g.world.tick===cutoff)break;
 }
 assert(produced>0);assert.equal(g.world.tick,cutoff);const expected=ref.reads.filter(r=>r.address==='5D27'&&r.clock.tick<=cutoff);assert.equal(reads.length,1);assert.deepEqual(reads,expected.map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=expected[0].last_store;assert.equal(writer.pc,'C3B8');assert.equal(writer.tick,964);assert.equal(writer.actor,0);assert.equal(writer.glyph.frame,0x5D32);assert.equal(writer.glyph.char,116);assert.equal(writer.value,writer.af>>>8);assert.equal(writer.value,data.spectrum.glyphs[writer.glyph.char-data.spectrum.first][7]);assert.equal(g.sourceDisplay.read(0x5D27),writer.value);assert.equal(g.sourceDisplay.read(0x5D28),null);
 if(s.job){const out=s.request('continue-command',{job:s.job.id,interrupt:true});assert.equal(out.running,false);assert.notEqual(out.state.analysis.outcome,'not_translated');}const saved=(await s.request('save')).save;assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D27),writer.value);
});
