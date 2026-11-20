import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const make=()=>new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
const fresh=p=>Object.assign(p.state,{scratch:{},cursor:0,remaining:36,counter:0,windowMode:0,pending:'',spacingFlag:0,started:false,upper:Array(18).fill('')});
function wear(g,id,{player=true}={}){
 const message={kind:'narrative',text:'You wear '+g.world.name(id)+'.',paragraph_before:true};
 g.npcRuntime.annotateArgumentPrefix({messages:[message],cost:1,action:51,args:[id]},[message],{player});
 g.projectMessages([message]);return message;
}

test('Natural WEAR leaves independent F/A bytes until both overnight reads',async()=>{
 const {reads,unclassified_transitions}=await read('results/extra-look-wear-scan/natural-writers.json');
 assert.deepEqual(unclassified_transitions,[]);
 assert.deepEqual(reads.map(r=>[r.address,r.actor,r.tick,r.value]),[['5D1E',9,2484,0],['5D1F',9,2608,0]]);
 for(const r of reads){const s=r.writer;assert.equal(s.tick,2286);assert.equal(s.pc,0xC3B8);assert.equal(s.command,'WEAR CHINA MANS DISGUISE');assert.equal(s.actor,0);assert.equal(s.glyph.frame,0x5D2A);assert.equal(s.glyph.character,114);assert.equal(s.value,s.registers[r.address==='5D1E'?1:0]);}
});

test('Both disguise captions match the owned fields of the original WEAR geometry ABI',async()=>{
 const abi=await read('results/extra-look-wear-scan/wear-abi.json');assert.equal(abi.cases.length,1080);
 const g=make(),p=g.sourceDisplay;let checked=0;
 for(const row of abi.cases.filter(r=>r.column===0&&r.counter+3<15)){
  fresh(p);p.state.counter=row.counter;const message=wear(g,row.target);
  assert(message.scene_trace.some(r=>r.kind==='wear-action-verb'));
  for(const at of [0x5D1E,0x5D1F])assert.equal(p.read(at),row.cells[at]);checked++;
 }
 assert.equal(checked,24);
 const glyphs=await read('test/fixtures/glyph-count-abi.json');let nonzero=0;
 for(const row of glyphs.cases.filter(r=>r.frame===0x5D2A)){
  fresh(p);p.upperGlyphKnown=false;p.cabWordRole='wear-action-verb';p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);
  for(const at of [0x5D1E,0x5D1F])assert.equal(p.read(at),row.cells[at]);if(p.read(0x5D1F)!==0)nonzero++;
 }
 assert(nonzero>0,'The raw eighth font row is derived, not a constant zero');
});

test('WEAR scan ownership excludes unproved callers, partial rows and MORE boundaries',()=>{
 for(const kind of ['queued','partial','narrow','page','pending']){
  const g=make(),p=g.sourceDisplay;fresh(p);
  if(kind==='partial'){p.state.cursor=1;p.state.remaining=35;}
  if(kind==='narrow')p.state.windowMode=1;
  if(kind==='page')p.state.counter=13;
  if(kind==='pending')p.state.pending='old';
  const message=wear(g,14,{player:kind!=='queued'});
  assert.equal(message.scene_trace,undefined,kind);
  assert.equal(p.read(0x5D1E),null,kind);assert.equal(p.read(0x5D1F),null,kind);
 }
});

test('Qualified missing-object errors preserve just the independently proven scan fields',async()=>{
 const abi=await read('results/extra-look-wear-scan/rejection-abi.json');assert.equal(abi.cases.length,147);
 for(const row of abi.cases){
  assert(row.eligible);assert.deepEqual(row.cells,[165,165]);
  const g=make(),w=g.world,p=g.sourceDisplay;w.player=row.player;w.move(row.player,45);w.minutes=1326;w.move(22,45,1);Object.assign(w.entity(22),{attributes:148,properties:128});
  const node=g.parser.parse(row.command).nodes[0],action=g.action(node);w.npcs.sceneryFailure={action,slot:0,found:false};
  const {message}=g.resolve(node,action);assert.equal(message.text,row.text,row.command);
  assert.equal(message.preserve_renderer_1e,true,row.player+' '+row.command);assert.equal(message.preserve_renderer_1f,true,row.player+' '+row.command);
  p.state.scratch[0x5D1E]=165;p.state.scratch[0x5D1F]=165;p.error([message]);
  assert.deepEqual([p.read(0x5D1E),p.read(0x5D1F)],row.cells);
  if(node.groups[0].qualifiers.length)assert.equal(message.preserve_renderer_26,undefined,'The new qualified contract stops at25');
 }
});

test('Prose searches, quotes, requests and ALL do not inherit missing-object scan preservation',()=>{
 for(const kind of ['prose','quote','request','all','three-qualifiers']){
  const g=make(),w=g.world,p=g.sourceDisplay;w.move(0,45);
  const node=g.parser.parse('OPEN LARGE OAK DOOR').nodes[0],action=g.action(node);
  if(kind==='prose')w.rooms[45].description=1;
  if(kind==='quote')node.quote={};
  if(kind==='request')g.actingActor=3;
  if(kind==='all')node.all=true;
  if(kind==='three-qualifiers')node.groups[0].qualifiers.push(node.groups[0].qualifiers[0]);
  w.npcs.sceneryFailure={action,slot:0,found:false};const {message}=g.resolve(node,action);
  assert.equal(message.preserve_renderer_1e,undefined,kind);assert.equal(message.preserve_renderer_1f,undefined,kind);
  p.state.scratch[0x5D1E]=165;p.error([message]);assert.equal(p.read(0x5D1E),null,kind);
 }
});

test('WEAR-derived scan state persists in JSON; missing legacy fields stay absent through errors',()=>{
 const g=make(),p=g.sourceDisplay;fresh(p);wear(g,14);
 const save=JSON.parse(JSON.stringify(g.dump())),loaded=Game.load(data,save);
 assert.equal(loaded.sourceDisplay.read(0x5D1E),p.read(0x5D1E));assert.equal(loaded.sourceDisplay.read(0x5D1F),p.read(0x5D1F));
 delete save.world.display.scratch[0x5D1E];delete save.world.display.scratch[0x5D1F];
 const old=Game.load(data,save);old.sourceDisplay.error([{text:'I SEE NO RIPPED NOTE THAT YOU CAN TAKE',preserve_renderer_1e:true,preserve_renderer_1f:true}]);
 assert.equal(old.sourceDisplay.read(0x5D1E),null);assert.equal(old.sourceDisplay.read(0x5D1F),null);
 fresh(old.sourceDisplay);wear(old,14);assert.equal(old.sourceDisplay.read(0x5D1E),0);assert.equal(old.sourceDisplay.read(0x5D1F),0);
});
