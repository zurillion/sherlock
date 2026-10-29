import test from 'node:test';import assert from 'node:assert/strict';import{readFile}from'node:fs/promises';import{gunzipSync}from'node:zlib';import{Game}from'../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(gunzipSync(await readFile(new URL('fixtures/argument-check-abi.json.gz',import.meta.url))));
for(const slot of[0,1])for(const phase of[0,1])test(`Original argument validator: slot ${slot+1}, phase ${phase}`,()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),h=g.npcRuntime;let writes=[];h.checks.write=value=>{writes.push(value);h.state.argumentCheck=value;};
 for(const[index,c]of ref.cases.entries()){if(c.slot!==slot||c.phase!==phase)continue;writes=[];h.state.argumentCheck=c.initial;const valid=h.checks.argument(c.meta,c.slot,c.id,{actor:0,phase:c.phase,literal:c.literal,otherLiteral:c.literal});assert.equal(valid,c.valid,'valid #'+index+' '+JSON.stringify(c));assert.equal(h.read(0xA021),c.after,'residue #'+index);assert.deepEqual(writes,c.writes,'stores #'+index);}
});
test('Argument check ownership: cold data, legacy unknown, explicit writes and saved state',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1}),h=g.npcRuntime;assert.equal(h.read(0xA021),data.argumentChecks.initialValue);
 h.checks.write(1);const restored=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.equal(restored.npcRuntime.read(0xA021),1);
 delete g.world.npcs.argumentCheck;const old=Game.load(data,JSON.parse(JSON.stringify(g.dump()))),checks=old.npcRuntime.checks;
 assert.equal(old.npcRuntime.read(0xA021),null);checks.argument({classes:[0,0]},0,255,{actor:0,phase:1});assert.equal(old.npcRuntime.read(0xA021),null);
 checks.argument({classes:[1,0]},0,8,{actor:0,phase:1});assert.equal(old.npcRuntime.read(0xA021),0);
 const before=restored.dump();restored.parser.analyze('OPEN DOOR');restored.canStreamWait?.('WAIT UNTIL 9AM');assert.deepEqual(restored.dump(),before,'dry parser cannot publish writes');
 const bad=structuredClone(before);bad.world.npcs.argumentCheck=2;assert.throws(()=>Game.load(data,bad));
});
