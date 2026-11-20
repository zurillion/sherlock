import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const make=()=>new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});
function exitFragment(g,room){
 g.world.move(0,room);const trace=[],text=g.text.scene({source:'arrival',full:true,mark:false,trace});
 const start=text.indexOf('Visible exits are ');if(start<0)return {text:'',trace:[]};
 const end=text.indexOf('.',start)+1;
 return {text:' '+text.slice(start,end),trace:trace.filter(e=>e.start>=start&&e.end<=end).map(e=>({...e,start:e.start-start+1,end:e.end-start+1}))};
}

test('The natural s is EXITS; 731A on the stack is saved AF, not a dialogue address',async()=>{
 const proof=await read('results/full-arrival-exits/natural-ne-detail.json');
 const glyphs=proof.glyphs.filter(g=>g.frame===0x5D28&&g.active_word==='exits');
 assert.equal(glyphs.map(g=>g.char).join(''),'exits');
 const last=glyphs.at(-1);assert.equal(last.stack[1],last.char.charCodeAt(0)*256+0x1A);
 assert.equal(last.char,'s');assert.equal(last.shift,7);
 assert(proof.calls.some(c=>c.pc==='D68C'&&c.sp===0x5D5E));
 assert(proof.calls.some(c=>c.pc==='A59F'&&c.hl===0x68F1));
 assert(!proof.messages.some(m=>m.text.includes('Yes Inspector')));
 assert.equal(proof.clock.label,'Wed 11:17am');
});

test('Full-arrival exit scan and direction-wrap fields match the controlled original ABI',async()=>{
 const abi=await read('results/full-arrival-exits/formatter-abi.json');assert.equal(abi.cases.length,540);
 let shift=0,clear=0,unknown=0;const shifts=new Set();
 const g=make(),p=g.sourceDisplay;
 for(const row of abi.cases){
  const fragment=exitFragment(g,row.room);
  assert.equal(row.text.trim(),fragment.text.trim(),row.room+' original direction selection');
  Object.assign(p.state,{scratch:{},cursor:row.column,remaining:36-row.column,counter:row.counter,windowMode:0,pending:'',spacingFlag:row.column?1:0,started:row.column>0,upper:Array(18).fill('')});
  p.scene(fragment.text,fragment.trace);p.feed('\n');
  for(const at of [0x5D1E,0x5D24]){
   const value=p.read(at);
   if(value===null){unknown++;continue;}
   assert.equal(value,row.cells[at],JSON.stringify({room:row.room,column:row.column,counter:row.counter,at}));
   if(at===0x5D1E){shift++;shifts.add(value);}else clear++;
  }
 }
 assert(shift>100);assert(clear>30);assert(unknown>0);assert.equal(shifts.size,8);
});

test('Other scene callers do not borrow the full arrival exit roles',()=>{
 for(const options of [{source:'look'},{source:'arrival',full:false},{source:'arrival',remote:true}]){
  const g=make();g.world.move(0,21);const trace=[];g.text.scene({full:true,mark:false,...options,trace});
  assert(!trace.some(e=>e.kind.startsWith('full-player-exit')));
 }
 const legacy=new Game(data,{npc_profile:'world-v5',seed:1});legacy.world.move(0,21);const legacyTrace=[];legacy.text.scene({source:'arrival',full:true,mark:false,trace:legacyTrace});assert(!legacyTrace.some(e=>e.kind.startsWith('full-player-exit')));
 const many=make();many.world.move(0,21);many.world.rooms[21].exits.push({direction_id:6,direction:'NW',target:22,gate:0});const manyTrace=[];many.text.scene({source:'arrival',full:true,mark:false,trace:manyTrace});assert(!manyTrace.some(e=>e.kind.startsWith('full-player-exit')));
 const g=make();g.world.player=1;g.world.move(1,21);let trace=[];g.text.scene({source:'arrival',full:true,mark:false,trace});assert(!trace.some(e=>e.kind.startsWith('full-player-exit')));
 g.world.player=0;g.world.move(0,21);g.world.move(3,21);trace=[];g.text.scene({source:'arrival',full:true,mark:false,trace});assert(!trace.some(e=>e.kind.startsWith('full-player-exit')));
});

test('Exit scan ownership is per byte, bounded before MORE, and absent legacy fields remain absent',()=>{
 const g=make(),p=g.sourceDisplay;
 Object.assign(p.state,{scratch:{},counter:0,windowMode:0});p.cabWordRole='full-player-exits';p.upperGlyphKnown=false;
 p.glyphResidue('s',0x5D28,27,0x5C0B,1);assert.equal(p.read(0x5D1E),7);assert.equal(p.read(0x5D1F),null);
 p.cabWordRole='full-player-exit-word';p.glyphResidue(' ',0x5D30,35,0x5A20);assert.equal(p.read(0x5D24),0);assert.equal(p.read(0x5D25),null);
 const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1E),7);
 assert.equal(Game.load(data,save).sourceDisplay.read(0x5D24),0);
 delete save.world.display.scratch[0x5D24];assert.equal(Game.load(data,save).sourceDisplay.read(0x5D24),null);
 delete save.world.display.scratch[0x5D1E];assert.equal(Game.load(data,save).sourceDisplay.read(0x5D1E),null);
 p.cabWordRole='full-player-exits';p.state.counter=12;p.glyphResidue('s',0x5D28,27,0x5C0B,1);assert.equal(p.read(0x5D1E),null);
 p.state.counter=0;p.state.windowMode=1;p.glyphResidue('s',0x5D28,27,0x5C0B,1);assert.equal(p.read(0x5D1E),null);
});
