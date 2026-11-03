import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
const base=new URL('../',import.meta.url),read=async path=>JSON.parse(await readFile(new URL(path,base))),data=await read('data/game.json');

test('Natural25 provenance extends through the actual later gardener read',async()=>{
 const n=await read('results/passage-caller-a-25/natural-stores.json'),r=n.reads.find(r=>r.address==='5D25'&&r.clock.tick===3102),s=r.last_store;
 assert.deepEqual(n.unclassified_transitions,[]);assert.equal(r.actor,8);assert.equal(s.pc,'C388');assert.equal(s.actor,0);assert.equal(s.clock.tick,1653);assert.equal(s.glyph.frame,0x5D26);assert.equal(s.glyph.char,110);assert.equal(s.value,s.af>>>8);assert.equal(r.value,s.value);assert(s.stack.includes('D65B'));
});

test('Original six-role ABI and all supported glyphs distinguish caller A from other saved high bytes',async()=>{
 const ref=await read('test/fixtures/glyph-address-high-abi.json'),rows=ref.cases.filter(r=>r.frame>=0x5D26&&r.frame<=0x5D30),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(rows.length,1296);
 for(const r of rows){p.state.scratch={};p.upperGlyphKnown=true;p.glyphFlagsKnown=true;p.glyphResidue(r.char,r.frame,r.column,r.descriptor,r.count);assert.equal(p.read(0x5D25),r.cells[0x5D25]);}
 p.upperGlyphKnown=false;p.glyphCallerAKnown=true;const values=new Set();for(let code=data.spectrum.first;code<data.spectrum.first+data.spectrum.glyphs.length;code++){p.glyphResidue(String.fromCharCode(code),0x5D26,17,0x5C0B,3);assert.equal(p.read(0x5D25),code);assert.equal(p.read(0x5D24),null);values.add(p.read(0x5D25));}assert.equal(values.size,96);
});

test('Owned passage A agrees with720 original geometries and LOOK remains outside the new contract',async()=>{
 const ref=await read('results/stack-low-1e/flags-24/passage-abi.json');assert.equal(ref.cases.length,720);let owned=0;
 for(const mode of ['arrival','look']){const g=new Game(data,{npc_profile:'world-v5',seed:1}),w=g.world,p=g.sourceDisplay;w.move(0,48);for(const r of ref.cases.filter(r=>r.mode===mode)){w.entity(50).noun=r.noun;const trace=[],text=g.text.scene({full:true,mark:false,source:mode,trace}),start=text.indexOf('To the north'),offset=r.spacing?1:0,section=(offset?' ':'')+text.slice(start),spans=trace.filter(t=>t.start>=start).map(t=>({...t,start:t.start-start+offset,end:t.end-start+offset}));Object.assign(p.state,{scratch:{},cursor:r.column,remaining:36-r.column,counter:0,started:Boolean(r.spacing),pending:'',spacingFlag:r.spacing,capitalizationFlag:r.spacing,upper:Array(18).fill('')});p.state.wordBuffer.index=0;p.write(section,{sceneTrace:spans});const value=p.read(0x5D25);if(value!==null){owned++;assert.equal(value,r.cells[0x5D25],JSON.stringify({mode,col:r.column,noun:r.noun,spacing:r.spacing}));}if(mode==='look')assert.equal(value,null);}}
 assert.equal(owned,290);
});

test('Original arrivals/rejections prove25 preservation, with counterexamples outside their declared scopes',async()=>{
 for(const [path,total,eligible]of[['arrival-low-abi.json',1512,720],['simple-error-abi.json',138,129]]){const ref=await read('results/stack-low-1e/flags-24/'+path),rows=ref.cases.filter(r=>r.eligible);assert.equal(ref.cases.length,total);assert.equal(rows.length,eligible);assert(rows.every(r=>r.cells[11]===165));assert(ref.cases.some(r=>!r.eligible&&r.cells[11]!==165));}
 for(const [actor,ordinary,keep]of[[3,true,true],[3,false,false],[6,true,false],[9,true,false]]){const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;p.state.scratch[0x5D25]=165;g.npcRuntime.showAction({messages:[{kind:'narrative',text:g.world.name(actor)+' enters.',arrival_entity:actor}],visibilityResolved:true,cost:2,action:2,args:[]},actor,[],[],{argumentFlags:ordinary});assert.equal(p.read(0x5D25),keep?165:null);}
 for(const [text,prose,acting,keep]of[['EXAMINE STREAM',false,false,true],['EXAMINE STREAM',true,false,false],['EXAMINE LARGE STREAM',false,false,false],['EXAMINE STREAM',false,true,false]]){const g=new Game(data,{npc_profile:'world-v5',seed:1}),w=g.world,p=g.sourceDisplay;w.move(0,48);if(prose)w.rooms[48].description=1;if(acting)g.actingActor=3;const node=g.parser.parse(text).nodes[0];w.npcs.sceneryFailure={action:19,slot:0,found:false};p.state.scratch[0x5D25]=165;p.error([g.resolve(node,19).message]);assert.equal(p.read(0x5D25),keep?165:null);}
});

test('Caller F does not initialize caller A; old missing SAVE fields and unknown callers stay unknown',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;p.upperGlyphKnown=false;p.glyphCallerFlagsKnown=true;p.glyphResidue('n',0x5D26,21,0x5C0B,1);assert.equal(p.read(0x5D24),10);assert.equal(p.read(0x5D25),null);p.glyphCallerAKnown=true;p.glyphResidue('q',0x5D26,21,0x5C0B,3);assert.equal(p.read(0x5D25),113);const save=g.dump(),loaded=Game.load(data,structuredClone(save));assert.equal(loaded.runtimeRandom.read(0x5D25),113);delete save.world.display.scratch[0x5D25];const old=Game.load(data,save);old.sourceDisplay.write('Watson enters.',{preserve24:true,preserve25:true});assert.equal(old.sourceDisplay.read(0x5D24),26);assert.throws(()=>old.runtimeRandom.read(0x5D25),/5D25/);p.write('Unprojected output.');assert.equal(p.read(0x5D25),null);p.error([{text:'WHICH DOOR ?'}],{inline:true});assert.equal(p.read(0x5D25),null);
});

test('Outer clear registers, later names and final pending-word wraps revoke newly owned caller A',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;p.upperGlyphKnown=false;p.glyphCallerAKnown=true;for(const frame of [0x5D1E,0x5D20,0x5D22,0x5D24]){p.state.scratch[0x5D25]=110;p.glyphResidue(' ',frame,35,0x5A20);assert.equal(p.read(0x5D25),null);}
 for(const later of [false,true]){Object.assign(p.state,{scratch:{},cursor:0,remaining:36,counter:0,started:false,pending:'',spacingFlag:0,capitalizationFlag:0,upper:Array(18).fill('')});const text=later?'plain door. lamp.':'plain '+('x'.repeat(34)),trace=[{kind:'passage-name-prefix',parent:50,start:0,end:5,frame:0x5D26,flagsKnown:true,callerAKnown:true,spaceAfter:true},{kind:'raw-text-buffer',start:0,end:11,events:[]}];if(later)trace.push({kind:'raw-text-buffer',start:12,end:text.length,events:[]});p.write(text,{sceneTrace:trace});assert.equal(p.read(0x5D25),null);}
});

test('Short ordinary JS history derives each character of plain and retains the result after SAVE/LOAD',async()=>{
 const proof=await read('results/stack-23/entry-provenance.json'),body=await readFile(new URL('results/stack-23/entry-js-save.json',base));assert.equal(createHash('sha256').update(body).digest('hex'),proof.save_sha256);const raw=await readFile(new URL(proof.reference,base));assert.equal(createHash('sha256').update(raw).digest('hex'),proof.reference_sha256);const ref=JSON.parse(raw).cases[0],s=new ClientSession(data);await s.request('load',{save:JSON.parse(body)});const g=s.game,p=g.sourceDisplay,events=[],glyph=p.glyphResidue.bind(p);assert.equal(p.read(0x5D25),null);p.glyphResidue=(c,frame,col,descriptor,count)=>{glyph(c,frame,col,descriptor,count);if(p.glyphCallerAKnown&&frame===0x5D26&&descriptor===0x5C0B)events.push({c,value:p.read(0x5D25)});};for(const row of ref.steps.slice(326,338)){const out=s.request('command',{command:row.input});assert.notEqual(out.state.analysis.outcome,'not_translated');}assert.equal(g.world.tick,1657);assert.equal(p.read(0x5D25),110);assert(events.some((e,i)=>events.slice(i,i+5).map(e=>e.c).join('')==='plain'&&events.slice(i,i+5).every(e=>e.value===e.c.charCodeAt(0))));const loaded=new ClientSession(data);await loaded.request('load',{save:(await s.request('save')).save});assert.deepEqual(loaded.game.dump(),g.dump());for(const command of ['I','I','WAIT']){s.request('command',{command});loaded.request('command',{command});assert.deepEqual(loaded.game.dump(),g.dump());}
});
