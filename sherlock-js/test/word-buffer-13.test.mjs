import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';import{compareNaturalHistory}from'./helpers/compare-natural-history.mjs';
const base=new URL('../',import.meta.url),read=async path=>JSON.parse(await readFile(new URL(path,base))),data=await read('data/game.json');
test('Original D3D5 raw names: all110 entities with both article policies',async()=>{const ref=await read('results/word-buffer-13/name-abi.json'),g=new Game(data,{npc_profile:'world-v5',seed:1});assert.equal(ref.cases.length,220);for(const row of ref.cases){const raw=g.text.rawEntityName(row.id,{indefinite:!row.forced});assert.equal(raw,Buffer.from(row.raw).toString('latin1'),row.id+'/'+row.forced);const trace=[],name=g.world.name(row.id,{indefinite:!row.forced});g.text.traceNameBuffer(trace,row.id,name,17,{indefinite:!row.forced});assert.equal(trace.length,1,row.id+'/'+row.forced);assert.equal(trace[0].start,17);assert.equal(trace[0].end,17+name.length);assert.equal(trace[0].events.map(e=>e.c).join(''),raw);assert(trace[0].events.every(e=>e.known));}});
test('Natural5C13: the room-list qualifier bloodstained leaves i until the cook reads it',async()=>{const ref=await read('results/word-buffer-13/natural-writer.json');assert.deepEqual(ref.unclassified_transitions,[]);const r=ref.read,s=r.last_store;assert.equal(r.actor,9);assert.equal(r.clock.tick,1882);assert.equal(s.clock.tick,1651);assert.equal(s.pc,'A9D7');assert.equal(s.actor,0);assert.equal(s.dictionary_ref,0x4109);assert.equal(Buffer.from(s.raw_word).toString('latin1'),'bloodstai');assert.equal(r.value,'bloodstained'.charCodeAt(8));});
for(const parent of[null,3,86])test('Scene raw name buffer in '+(parent===null?'root list':parent===3?'personal contents':'container contents'),()=>{const g=new Game(data,{npc_profile:'world-v5',seed:1}),w=g.world;w.move(0,47);w.move(3,parent===3?47:5);if(parent===86){w.entity(86).attributes|=40;w.move(87,0);w.move(88,0);}w.move(67,47,parent);const trace=[],text=g.text.scene({full:false,mark:false,trace});const name=w.name(67,{indefinite:true}),span=trace.find(t=>t.kind==='raw-text-buffer'&&text.slice(t.start,t.end)===name);assert(span,text);assert.equal(span.events.map(e=>e.c).join(''),' some bloodstained clothes');g.sourceDisplay.state.wordBuffer.bytes[8]=null;g.sourceDisplay.scene(text,trace);assert.equal(g.sourceDisplay.read(0x5C13),105);const loaded=Game.load(data,structuredClone(g.dump()));assert.equal(loaded.runtimeRandom.read(0x5C13),105);});
test('Unmatched or shortened display names remain unknown; old SAVE absence is not backfilled',()=>{const g=new Game(data,{npc_profile:'world-v5',seed:1}),trace=[];g.text.traceNameBuffer(trace,67,'clothes',0,{indefinite:true});assert.deepEqual(trace,[]);g.sourceDisplay.state.wordBuffer.bytes[8]=null;const old=Game.load(data,structuredClone(g.dump()));assert.throws(()=>old.runtimeRandom.read(0x5C13),/5C13/);const name=old.world.name(67,{indefinite:true});old.text.traceNameBuffer(trace,67,name,0,{indefinite:true});old.sourceDisplay.scene(name,trace);assert.equal(old.runtimeRandom.read(0x5C13),105);});
test('Natural longer WAIT crosses former5C13 boundary with exact original state and LOAD future',async()=>{const ref=await read('results/cab-stack-15/lookahead-reference.json'),result=await compareNaturalHistory(data,ref.cases[0]);assert.equal(result.checkpoints,363);assert.equal(result.clock.tick,1883);});


test('Common room arrivals retain the raw Leatherhead qualifier after shorter words and LOAD',()=>{
 const game=new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
 game.world.move(0,53);
 const trace=[],text=game.text.scene({source:'arrival',full:false,mark:false,trace});
 const name=game.world.roomName(53),span=trace.find(part=>part.kind==='raw-text-buffer'&&text.slice(part.start,part.end)===name);
 assert(span,text);
 assert.equal(span.events.map(event=>event.c).join(''),' the leatherhead station');
 assert.equal(span.affectsStack,false);
 game.sourceDisplay.scene(text,trace);
 assert.equal(game.sourceDisplay.read(0x5C15),'d'.charCodeAt(0));
 const loaded=Game.load(data,JSON.parse(JSON.stringify(game.dump())));
 assert.equal(loaded.runtimeRandom.read(0x5C15),'d'.charCodeAt(0));
});

test('Common object text arguments use the same raw dictionary names as scene lists',()=>{
 const fixture={...data,texts:{...data.texts,NAME:[{op:'objectName'},{op:'end'}]}};
 const game=new Game(fixture,{npc_profile:'world-v5',seed:1});
 for(const id of [67,69,71]){
  const events=[];
  game.text.render('NAME',{object:id,captureBuffer:(c,options)=>events.push({c,...options})});
  assert.equal(events.map(event=>event.c).join(''),game.text.rawEntityName(id));
  assert(events.filter(event=>event.c!==' ').every(event=>event.known));
 }
});


test('INVENTORY retains long dictionary qualifiers in the shared word buffer',()=>{
 const game=new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
 game.world.move(67,game.world.roomOf(),0);
 const out=game.submit('I');
 assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);
 assert.equal(game.sourceDisplay.read(0x5C15),'e'.charCodeAt(0));
 assert.equal(game.sourceDisplay.read(0x5C16),'d'.charCodeAt(0));
 const loaded=Game.load(data,JSON.parse(JSON.stringify(game.dump())));
 assert.equal(loaded.runtimeRandom.read(0x5C15),'e'.charCodeAt(0));
 assert.equal(loaded.runtimeRandom.read(0x5C16),'d'.charCodeAt(0));
});
