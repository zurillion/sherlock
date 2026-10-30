import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{ClientSession}from'../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-abi.json',import.meta.url)));
for(const frame of [0x5D24,0x5D26,0x5D28,0x5D2A,0x5D2C,0x5D2E,0x5D30,0x5D32])for(const count of [3,7])for(const char of [' ','T','q'])test('Native5D23 ABI frame'+frame.toString(16)+' B'+count+' char'+char.charCodeAt(0),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,rows=abi.cases.filter(r=>r.frame===frame&&r.count===count&&r.char===char);assert.equal(rows.length,36);
 for(const row of rows){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);
  for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame,count,char,column:row.column,at}));
  if(frame<=0x5D2E)assert.equal(p.read(0x5D23),row.cells[0x5D23]);else assert.equal(p.read(0x5D23),null);
 }
});
test('Native C374 clear ABI: real return-link and register roles at5D23',async()=>{
 const ref=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-clear-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(ref.cases.length,288);
 for(const row of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(' ',row.frame,row.column,0x5A20,1);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame:row.frame,column:row.column,at}));if(row.frame<=0x5D2E)assert.equal(p.read(0x5D23),row.cells[0x5D23]);else assert.equal(p.read(0x5D23),null);}
});
test('5D23 ownership, unknown callers and old saves are independent of5D22',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D23),null);
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,7);assert.equal(p.read(0x5D23),(0x5020+Math.floor((2+7*8)/8))>>>8);
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D23),80);delete saved.world.display.scratch[0x5D23];const old=Game.load(data,saved);assert.equal(old.sourceDisplay.read(0x5D23),null);assert.equal(old.sourceDisplay.read(0x5D22),39);
 p.upperGlyphKnown=false;p.glyphResidue('r',0x5D2A,8,0x5C0B,7);assert.equal(p.read(0x5D23),null);
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,7);p.write('Unknown caller.');assert.equal(p.read(0x5D23),null);
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,7);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D23),null);
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D26,8,0x5C0B);assert.equal(p.read(0x5D23),null,'unknown caller B remains unknown');
});

test('Natural5D23 ownership and cook read continue through Wed10:00 after model flags',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-address-high/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];
 assert.deepEqual(ref.unclassified_transitions,[]);const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D23)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0;
 for(const[index,row]of ref.steps.entries()){
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);if(!out.running||index===ref.steps.length-1&&g.world.tick===row.clock.tick)break;assert(g.world.tick<=row.clock.tick);out=s.request('continue-command',{job:out.job});}
  assert.equal(g.world.tick,row.clock.tick);const value=g.sourceDisplay.read(0x5D23);if(value!==null){produced++;assert.equal(value,row.cells['5D23'],row.input+' '+row.clock.label);}
 }
 assert(produced>0);assert.equal(g.world.tick,ref.steps.at(-1).clock.tick,'full trace completed');
 const expected=ref.reads.filter(r=>r.address==='5D23'&&r.clock.tick<=g.world.tick);assert.equal(reads.length,1);assert.deepEqual(reads,expected.map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=expected[0].last_store;assert.equal(writer.pc,'C398');assert.equal(writer.tick,964);assert.equal(writer.actor,2);assert.equal(writer.glyph.frame,0x5D2A);assert.equal(writer.value,writer.hl>>>8);
 const column=((writer.glyph.screen_address-0x5020)*8+writer.glyph.shift-2)/7;assert(Number.isInteger(column));assert.equal(writer.value,(0x5020+Math.floor((2+7*column)/8))>>>8);assert.equal(g.sourceDisplay.read(0x5D23),writer.value);
 if(s.job){const out=s.request('continue-command',{job:s.job.id,interrupt:true});assert.equal(out.running,false);assert.notEqual(out.state.analysis.outcome,'not_translated');}
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D23),writer.value);
});
