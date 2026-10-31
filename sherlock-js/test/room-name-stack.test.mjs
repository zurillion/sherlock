import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-abi.json',import.meta.url)));
for(const frame of[0x5D24,0x5D26,0x5D28,0x5D2A,0x5D2C,0x5D2E,0x5D30,0x5D32])for(const count of[3,7])for(const char of[' ','T','q'])test('Native5D26 ABI frame'+frame.toString(16)+' B'+count+' char'+char.charCodeAt(0),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,rows=abi.cases.filter(r=>r.frame===frame&&r.count===count&&r.char===char);assert.equal(rows.length,36);
 for(const row of rows){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame,count,char,column:row.column,at}));if(frame>=0x5D28&&frame<=0x5D32)assert.equal(p.read(0x5D26),row.cells[0x5D26]);else assert.equal(p.read(0x5D26),null);}
});
test('Caller shift ownership is independent of descriptor and caller B',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D26),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C42,7);assert.equal(p.read(0x5D26),(2+8*7)&7);assert.equal(p.read(0x5D25),0x5C,'independent descriptor D is now owned');
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D26),2);delete saved.world.display.scratch[0x5D26];const old=Game.load(data,saved);assert.equal(old.sourceDisplay.read(0x5D26),null);assert.equal(old.sourceDisplay.read(0x5D24),0x42);
 p.upperGlyphKnown=false;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);assert.equal(p.read(0x5D26),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);p.write('Unknown caller.');assert.equal(p.read(0x5D26),null);
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);p.error([{text:'WHAT ?'}]);assert.equal(p.read(0x5D26),null);p.glyphResidue('r',0x5D2A,8,0x5C0B);assert.equal(p.read(0x5D26),null,'unprojected caller BC stays unknown');
});
test('Native parameter variants keep caller C independent of descriptor and B',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-descriptor-low/descriptor-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(ref.cases.length,1152);
 for(const row of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame:row.frame,descriptor:row.descriptor,column:row.column,at}));if(row.frame>=0x5D28&&row.frame<=0x5D32)assert.equal(p.read(0x5D26),row.cells[0x5D26]);}
});
test('A composed proper room prefix replaces actor-name C with its deeper saved scan F',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,seen=[],glyph=p.glyphResidue.bind(p);p.glyphResidue=(c,frame,...args)=>{if(frame===0x5D32)seen.push(c);return glyph(c,frame,...args);};
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5C0B,1);assert.equal(p.read(0x5D26),2);
 g.npcRuntime.print('682A',2,{object:31,action:29,args:[10,255],actorNameFrame:0x5D2A,actorNameUpper:true,roomNameFrame:0x5D32,preserveGlyphFlags:true},[],{force:true});
 assert(seen.join('').toLowerCase().includes('parliament'));assert.equal(p.read(0x5D26),0);assert.equal(p.read(0x5D25),0x5C,'independent descriptor D is now owned');
});
test('The actor-table terminator is extracted immutable data, never an invented legacy fallback',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});assert.equal(data.npcPrograms.actorTerminator,255);assert.equal(g.npcRuntime.read(0x9920),255);
 const oldData=structuredClone(data);delete oldData.npcPrograms.actorTerminator;const old=new Game(oldData,{npc_profile:'world-v5',seed:1});assert.equal(old.npcRuntime.read(0x9920),null);
});
test('Natural room-name scan flags supersede actor C and match the actual cook read',async()=>{
 const {ClientSession}=await import('../src/session.mjs');const ref=JSON.parse(await readFile(new URL('../results/room-name-stack/natural-stores.json',import.meta.url))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,reads=[];
 assert.deepEqual(ref.unclassified_transitions,[]);const read=g.runtimeRandom.read.bind(g.runtimeRandom);g.runtimeRandom.read=address=>{const value=read(address);if(address===0x5D26)reads.push({value,tick:g.world.tick,actor:g.runtimeRandom.inFlight?.actor});return value;};let produced=0;
 const cutoff=3301; // Wed15:00: requires all formerly blocked5D27 minutes; next A027 stays explicit.
 for(const[index,row]of ref.steps.entries()){
  const target=Math.min(row.clock.tick,cutoff);
  let out=s.request(row.input.startsWith('WAIT UNTIL')?'start-command':'command',{command:row.input});
  for(;;){assert.notEqual(out.state.analysis.outcome,'not_translated',row.input+' '+out.state.prototype_notice);if(!out.running||row.clock.tick>=cutoff&&g.world.tick===cutoff)break;assert(g.world.tick<=target);out=s.request('continue-command',{job:out.job});}
  assert.equal(g.world.tick,target);const value=g.sourceDisplay.read(0x5D26);if(value!==null){produced++;assert.equal(value,row.cells['5D26'],row.input+' '+row.clock.label);}
  if(g.world.tick===cutoff)break;
 }
 assert(produced>0);assert.equal(g.world.tick,cutoff,'the probe must reach Wed15:00 without an unsupported input');const expected=ref.reads.filter(r=>r.address==='5D26'&&r.clock.tick<=g.world.tick);assert.equal(reads.length,1);assert.deepEqual(reads,expected.map(r=>({value:r.value,tick:r.clock.tick,actor:r.actor})));
 const writer=expected[0].last_store;assert.equal(writer.pc,'C3B8');assert.equal(writer.tick,964);assert.equal(writer.actor,0);assert.equal(writer.glyph.frame,0x5D32);assert.equal(writer.glyph.char,116);assert.equal(writer.value,writer.af&255);assert.equal(g.sourceDisplay.read(0x5D26),writer.value);assert.equal(g.sourceDisplay.read(0x5D27),data.spectrum.glyphs[writer.glyph.char-data.spectrum.first][7]);
 if(s.job){const out=s.request('continue-command',{job:s.job.id,interrupt:true});assert.equal(out.running,false);assert.notEqual(out.state.analysis.outcome,'not_translated');}
 const saved=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,saved).sourceDisplay.read(0x5D26),writer.value);
});
