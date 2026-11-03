import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
const base=new URL('../',import.meta.url),read=async path=>JSON.parse(await readFile(new URL(path,base))),data=await read('data/game.json');

test('Natural passage writers independently identify video L and caller F at the same gardener draw',async()=>{
 for(const [path,address,pc] of [['results/stack-low-1e/natural-stores.json','5D1E','C398'],['results/stack-low-1e/flags-24/natural-stores.json','5D24','C388']]){
  const n=await read(path),r=n.reads.find(r=>r.address===address&&r.clock.tick===3012),s=r.last_store;
  assert.deepEqual(n.unclassified_transitions,[]);assert.equal(r.actor,8);assert.equal(s.pc,pc);assert.equal(s.clock.tick,1653);assert.equal(s.actor,0);assert.equal(s.glyph.frame,0x5D26);assert.equal(s.glyph.char,110);assert(s.stack.includes('D65B'));
  assert.equal(s.value,address==='5D1E'?s.hl&255:s.af&255);assert.equal(r.value,s.value);
 }
});

test('Original glyph ABI distinguishes six physical roles for each low-byte input',async()=>{
 const count=await read('test/fixtures/glyph-count-abi.json'),high=await read('test/fixtures/glyph-address-high-abi.json'),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;
 const selections=[[0x5D1E,[...count.cases.filter(r=>[0x5D20,0x5D22].includes(r.frame)),...high.cases.filter(r=>[0x5D24,0x5D26,0x5D28,0x5D2A].includes(r.frame))]],[0x5D24,high.cases.filter(r=>r.frame>=0x5D26&&r.frame<=0x5D30)]];
 for(const [address,rows] of selections){assert.equal(rows.length,1296);for(const r of rows){p.state.scratch={};p.upperGlyphKnown=true;p.glyphFlagsKnown=true;p.glyphResidue(r.char,r.frame,r.column,r.descriptor,r.count);assert.equal(p.read(address),r.cells[address],JSON.stringify({address,frame:r.frame,col:r.column,char:r.char}));}}
});

test('Every owned passage L/F agrees across720 original geometries, while LOOK remains unowned',async()=>{
 const ref=await read('results/stack-low-1e/flags-24/passage-abi.json');assert.equal(ref.cases.length,720);const totals={};
 for(const address of [0x5D1E,0x5D24]){let owned=0;const values=new Set();for(const mode of ['arrival','look']){
  const g=new Game(data,{npc_profile:'world-v5',seed:1}),w=g.world,p=g.sourceDisplay;w.move(0,48);
  for(const r of ref.cases.filter(r=>r.mode===mode)){w.entity(50).noun=r.noun;const trace=[],text=g.text.scene({full:true,mark:false,source:mode,trace}),start=text.indexOf('To the north'),offset=r.spacing?1:0,section=(offset?' ':'')+text.slice(start),spans=trace.filter(t=>t.start>=start).map(t=>({...t,start:t.start-start+offset,end:t.end-start+offset}));
   Object.assign(p.state,{scratch:{},cursor:r.column,remaining:36-r.column,counter:0,started:Boolean(r.spacing),pending:'',spacingFlag:r.spacing,capitalizationFlag:r.spacing,upper:Array(18).fill('')});p.state.wordBuffer.index=0;p.write(section,{sceneTrace:spans});const value=p.read(address);
   if(value!==null){owned++;values.add(value);assert.equal(value,r.cells[address],JSON.stringify({mode,address,noun:r.noun,col:r.column,spacing:r.spacing}));}if(mode==='look')assert.equal(value,null);
  }
 }assert.equal(owned,290);totals[address]=values;}assert.equal(totals[0x5D1E].size,19);
});

test('Caller F follows original CP0D for every supported glyph, including n10 and q26',async()=>{
 const ref=await read('results/glyph-caller-flags-30/glyph-abi.json'),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;p.upperGlyphKnown=false;p.glyphCallerFlagsKnown=true;const values=new Set();
 for(let code=data.spectrum.first;code<data.spectrum.first+data.spectrum.glyphs.length;code++){p.glyphResidue(String.fromCharCode(code),0x5D26,17,0x5C0B,3);assert.equal(p.read(0x5D24),ref.cp_flags[code]);values.add(p.read(0x5D24));}assert(values.size>1);
 p.glyphResidue('n',0x5D26,21,0x5C0B,1);assert.equal(p.read(0x5D24),10);assert.equal(p.read(0x5D25),null);p.glyphResidue('q',0x5D26,21,0x5C0B,3);assert.equal(p.read(0x5D24),26);
});

test('Original ordinary arrivals and simple error controls preserve1E and24 independently',async()=>{
 for(const [path,total,eligible]of[['arrival-low-abi.json',1512,720],['simple-error-abi.json',138,129]]){const ref=await read('results/stack-low-1e/flags-24/'+path),rows=ref.cases.filter(r=>r.eligible);assert.equal(ref.cases.length,total);assert.equal(rows.length,eligible);for(const r of rows)for(const i of [4,10])assert.equal(r.cells[i],165);assert(ref.cases.some(r=>!r.eligible&&r.cells[10]!==165));}
 for(const [actor,ordinary,keep]of[[3,true,true],[3,false,false],[6,true,false],[9,true,false]]){const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;for(const a of [0x5D1E,0x5D24])p.state.scratch[a]=165;g.npcRuntime.showAction({messages:[{kind:'narrative',text:g.world.name(actor)+' enters.',arrival_entity:actor}],visibilityResolved:true,cost:2,action:2,args:[]},actor,[],[],{argumentFlags:ordinary});for(const a of [0x5D1E,0x5D24])assert.equal(p.read(a),keep?165:null);}
 for(const [text,prose,acting,keep]of[['EXAMINE STREAM',false,false,true],['EXAMINE STREAM',true,false,false],['EXAMINE LARGE STREAM',false,false,false],['EXAMINE STREAM',false,true,false]]){const g=new Game(data,{npc_profile:'world-v5',seed:1}),w=g.world,p=g.sourceDisplay;w.move(0,48);if(prose)w.rooms[48].description=1;if(acting)g.actingActor=3;const node=g.parser.parse(text).nodes[0];w.npcs.sceneryFailure={action:19,slot:0,found:false};for(const a of [0x5D1E,0x5D24])p.state.scratch[a]=165;p.error([g.resolve(node,19).message]);for(const a of [0x5D1E,0x5D24])assert.equal(p.read(a),keep?165:null);}
});

test('Low video, high video, caller flags and old SAVE missing fields have separate ownership',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;p.upperGlyphKnown=false;p.glyphVideoLowKnown=true;p.glyphVideoHighKnown=false;p.glyphResidue('n',0x5D26,21,0x5C0B,1);assert.equal(p.read(0x5D1E),50);assert.equal(p.read(0x5D1F),null);assert.equal(p.read(0x5D24),null);
 p.glyphVideoLowKnown=false;p.glyphCallerFlagsKnown=true;p.glyphResidue('q',0x5D26,4,0x5C0B,3);assert.equal(p.read(0x5D24),26);assert.equal(p.read(0x5D1E),null);
 p.upperGlyphKnown=true;p.glyphResidue('n',0x5D26,21,0x5C0B,1);const save=g.dump(),loaded=Game.load(data,structuredClone(save));assert.equal(loaded.runtimeRandom.read(0x5D1E),50);assert.equal(loaded.runtimeRandom.read(0x5D24),10);delete save.world.display.scratch[0x5D1E];delete save.world.display.scratch[0x5D24];const old=Game.load(data,save);old.sourceDisplay.write('Watson enters.',{preserve1E:true,preserve1F:true,preserve24:true});assert.equal(old.sourceDisplay.read(0x5D1F),80);for(const a of [0x5D1E,0x5D24])assert.throws(()=>old.runtimeRandom.read(a),new RegExp(a.toString(16).toUpperCase()));p.write('Unprojected output.');for(const a of [0x5D1E,0x5D24])assert.equal(p.read(a),null);
});

test('Later unprojected names and the final pending-word wrap revoke both new contracts',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;for(const later of [false,true]){Object.assign(p.state,{scratch:{},cursor:0,remaining:36,counter:0,started:false,pending:'',spacingFlag:0,capitalizationFlag:0,upper:Array(18).fill('')});const text=later?'plain door. lamp.':'plain '+('x'.repeat(34)),trace=[{kind:'passage-name-prefix',parent:50,start:0,end:5,frame:0x5D26,flagsKnown:true,videoLowKnown:true,callerFlagsKnown:true,spaceAfter:true},{kind:'raw-text-buffer',start:0,end:11,events:[]}];if(later)trace.push({kind:'raw-text-buffer',start:12,end:text.length,events:[]});p.write(text,{sceneTrace:trace});for(const a of [0x5D1E,0x5D24])assert.equal(p.read(a),null);}
});

test('Short ordinary JS history reconstructs both writers and preserves them through SAVE/LOAD',async()=>{
 const proof=await read('results/stack-23/entry-provenance.json'),body=await readFile(new URL('results/stack-23/entry-js-save.json',base));assert.equal(createHash('sha256').update(body).digest('hex'),proof.save_sha256);const reference=await readFile(new URL(proof.reference,base));assert.equal(createHash('sha256').update(reference).digest('hex'),proof.reference_sha256);const ref=JSON.parse(reference).cases[0],s=new ClientSession(data);await s.request('load',{save:JSON.parse(body)});const g=s.game,p=g.sourceDisplay;for(const a of [0x5D1E,0x5D24])assert.equal(p.read(a),null);
 for(const row of ref.steps.slice(326,338)){assert(row.input&&!row.input.startsWith('WAIT'));const out=s.request('command',{command:row.input});assert.notEqual(out.state.analysis.outcome,'not_translated');}assert.equal(g.world.tick,1657);assert.equal(p.read(0x5D1E),50);assert.equal(p.read(0x5D24),10);const loaded=new ClientSession(data);await loaded.request('load',{save:(await s.request('save')).save});assert.deepEqual(loaded.game.dump(),g.dump());for(const command of ['I','I','WAIT']){s.request('command',{command});loaded.request('command',{command});assert.deepEqual(loaded.game.dump(),g.dump());}
});
