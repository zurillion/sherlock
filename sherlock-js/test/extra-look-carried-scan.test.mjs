import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async path=>JSON.parse(await readFile(new URL('../'+path,import.meta.url)));
const data=await read('data/game.json');

test('Extra LOOK last writer: separator shift and scan count precede the gardener read',async()=>{
 const {reads}=await read('results/extra-look-carried-scan/stack-writers.json');
 const row=reads.find(r=>r.address==='5D1C'),writer=row.writer;
 assert.equal(row.tick,2178);assert.equal(row.actor,8);assert.equal(row.value,0);
 assert.equal(writer.pc,0xC39C);assert.equal(writer.tick,1770);assert.equal(writer.actor,0);
 assert.equal(writer.command,'LOOK');assert.equal(writer.glyph.frame,0x5D26);
 assert.equal(writer.glyph.character,32);assert.equal(writer.glyph.descriptor,0x51AB);
 assert.equal(writer.registers[3],row.value);assert.equal(writer.registers[2],1);
});

test('Carried-object separator derives all eight shifts; unknown contexts and legacy saves stay unknown',async()=>{
 const abi=await read('test/fixtures/glyph-count-abi.json');
 const g=new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true}),p=g.sourceDisplay;
 const shifts=new Set();
 for(const row of abi.cases.filter(r=>r.frame===0x5D26&&r.char===' '&&r.column<35)){
  Object.assign(p.state,{scratch:{},windowMode:0,counter:4});
  p.glyphFlagsKnown=false;p.upperGlyphKnown=false;p.glyphSpaceShiftKnown=true;p.glyphSpaceCountKnown=true;
  p.glyphResidue(' ',row.frame,row.column,row.descriptor,row.count);
  assert.equal(p.read(0x5D1C),row.cells[0x5D1C]);assert.equal(p.read(0x5D1D),row.cells[0x5D1D]);
  shifts.add(p.read(0x5D1C));
 }
 assert.equal(shifts.size,8);
 const save=JSON.parse(JSON.stringify(g.dump()));
 assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1C),p.read(0x5D1C));
 delete save.world.display.scratch[0x5D1C];
 assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1C),null);
 p.glyphSpaceShiftKnown=false;p.glyphSpaceCountKnown=false;
 p.glyphResidue(' ',0x5D26,18,0x51AB);
 assert.equal(p.read(0x5D1C),null);assert.equal(p.read(0x5D1D),null);
});

test('Original four announcements preserve low cells on every fresh wide-row counter',async()=>{
 const abi=await read('results/extra-look-carried-scan/announcement-abi.json');
 assert.equal(abi.cases.length,200);
 const fresh=abi.cases.filter(r=>r.column===0);
 assert.equal(fresh.length,60);
 for(const row of fresh){assert.deepEqual(row.cells,[165,165,165,165]);assert(row.min_sp>=0x5D1E);}
 assert(abi.cases.some(r=>r.column>0&&r.cells.some(v=>v!==165)),'Partial-row counterexamples remain in the oracle');
});

test('Ordinary door and qualified-arrival contracts preserve only the bounded low fields',()=>{
 for(const kind of ['anonymous','close','arrival','move','page','partial','queued']){
  const g=new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true}),w=g.world,p=g.sourceDisplay;
  w.move(0,45);w.move(13,kind==='anonymous'?46:45);
  Object.assign(p.state,{scratch:{},windowMode:0,cursor:kind==='partial'?1:0,remaining:kind==='partial'?35:36,counter:kind==='page'?13:2,pending:'',spacingFlag:0,started:false,upper:Array(18).fill('')});
  for(let at=0x5D1A;at<=0x5D1D;at++)p.state.scratch[at]=165;
  if(kind==='move')g.projectMessages([g.text.directionalMovement(w.name(13),2,{relocatingActor:13})]);
  else {
   const arrival=kind==='arrival',action=arrival?2:kind==='anonymous'?36:14;
   const message=arrival?{kind:'narrative',text:w.name(13)+' enters.',arrival_entity:13}:{kind:'narrative',text:w.name(13)+(action===36?' opens ':' closes ')+w.name(103)+'.'};
   g.npcRuntime.showAction({messages:[message],cost:1,action,args:arrival?[]:[103]},13,[],[],{argumentFlags:kind!=='queued'});
  }
  const keep=['anonymous','close','arrival','move'].includes(kind);
  for(let at=0x5D1A;at<=0x5D1D;at++)assert.equal(p.read(at),keep?165:null,kind+' '+at.toString(16));
 }
});
