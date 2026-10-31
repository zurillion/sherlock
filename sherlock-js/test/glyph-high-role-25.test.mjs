import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{Game}from'../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),abi=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-abi.json',import.meta.url)));
for(const frame of[0x5D26,0x5D28,0x5D2A,0x5D2C,0x5D2E,0x5D30])for(const count of[3,7])for(const char of[' ','T','q'])test('Original5D25 high-byte role frame'+frame.toString(16)+' B'+count+' char'+char.charCodeAt(0),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay,rows=abi.cases.filter(r=>r.frame===frame&&r.count===count&&r.char===char);assert.equal(rows.length,36);
 for(const row of rows){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at],JSON.stringify({frame,count,char,column:row.column,at}));assert.equal(p.read(0x5D25),row.cells[0x5D25]);assert.equal(p.read(0x5D2B),null);}
});
test('Descriptor high byte varies independently of video and the neighbouring descriptor low byte',async()=>{
 const ref=JSON.parse(await readFile(new URL('../results/glyph-descriptor-low/descriptor-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(ref.cases.length,1152);
 for(const row of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(row.char,row.frame,row.column,row.descriptor,row.count);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in row.cells)assert.equal(v,row.cells[at]);if(row.frame===0x5D2A)assert.equal(p.read(0x5D25),row.descriptor>>>8);}
});
test('5D25 ownership, unknown BC, invalidation and missing old save remain independent',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;assert.equal(p.read(0x5D25),null);p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5123,1);assert.equal(p.read(0x5D25),0x51);const save=JSON.parse(JSON.stringify(g.dump()));assert.equal(Game.load(data,save).sourceDisplay.read(0x5D25),0x51);delete save.world.display.scratch[0x5D25];const old=Game.load(data,save);assert.equal(old.sourceDisplay.read(0x5D24),0x23);assert.equal(old.sourceDisplay.read(0x5D25),null);assert.throws(()=>old.runtimeRandom.read(0x5D25),/5D25/);
 p.upperGlyphKnown=true;p.glyphResidue('q',0x5D28,8);assert.equal(p.read(0x5D25),null,'unknown B must revoke the previous descriptor D');
 for(const invalidate of[()=>p.invalidateGlyphExtras(),()=>p.write('Unknown caller.'),()=>p.error([{text:'WHAT ?'}])]){p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5123,1);invalidate();assert.equal(p.read(0x5D25),null);}
 g.npcRuntime.print('682A',2,{object:31,action:29,args:[1,255],actorNameFrame:0x5D2A,actorNameUpper:true,roomNameFrame:0x5D32,preserveGlyphFlags:true},[],{force:true});assert.equal(p.read(0x5D25),0x5C,'known actor prefix keeps its descriptor high byte; the room frame starts above this cell');
 p.upperGlyphKnown=true;p.glyphResidue('r',0x5D2A,8,0x5123,1);p.glyphResidue('q',0x5D24,8,0x5C0B,1);assert.equal(p.read(0x5D25),null,'an unknown call return high byte revokes the old descriptor');
 p.upperGlyphKnown=false;p.glyphResidue('r',0x5D2A,8,0x5123,1);assert.equal(p.read(0x5D25),null);
});
test('Real C374 CALL leaves C3 at5D25: controlled return0008 is a distinct ABI',async()=>{
 const ref=JSON.parse(await readFile(new URL('fixtures/glyph-address-high-clear-abi.json',import.meta.url))),g=new Game(data,{npc_profile:'world-v5',seed:1}),p=g.sourceDisplay;
 for(const r of ref.cases){g.world.display.scratch={};p.glyphFlagsKnown=true;p.upperGlyphKnown=true;p.glyphResidue(' ',r.frame,r.column,0x5A20);for(const[at,v]of Object.entries(g.world.display.scratch))if(at in r.cells)assert.equal(v,r.cells[at]);if(r.frame===0x5D24)assert.equal(p.read(0x5D25),0xC3);}
});
