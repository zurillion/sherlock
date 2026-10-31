import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{NpcProgram}from'../src/npc-program.mjs';import{ActorScheduler}from'../src/scheduler.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url)));
function setup(saved=[50,255,1]){const vm=new NpcProgram(data.npcPrograms,new ActorScheduler());vm.start(8,'ED6A',saved);const seen=[],env={rule:(name,args,ctx)=>{seen.push({name,args:[...args],working:[...ctx.saved],row:[...vm.state(8).saved]});if(name==='unimplemented.EDDD')return {defer:'EDDF',args,cost:0};for(let i=0;i<2;i++)if(ctx.saved[i+1]===255)ctx.saved[i+1]=args[i];return {success:false,cost:0};}};return{vm,env,seen};}
test('Failed probability bindings survive locally but a deferred child leaves the actor row intact',()=>{
 const{vm,env,seen}=setup();assert.deepEqual(vm.step(8,env),{cost:0});assert.deepEqual(seen.map(s=>s.row),[[50,255,1],[50,255,1],[50,255,1]]);assert.deepEqual(seen.map(s=>s.working),[[50,255,1],[50,33,1],[50,33,1]]);assert.deepEqual(vm.state(8).saved,[50,255,1]);assert.deepEqual(vm.state(8).contexts[0].saved,[50,2,20]);assert.equal(vm.state(8).working,undefined);
});
test('A successful root operation commits earlier working bindings even at zero cost',()=>{
 const{vm,env}=setup();const rule=env.rule;env.rule=(name,args,ctx)=>name==='unimplemented.F198'&&args[0]===50?{success:true,cost:0}:rule(name,args,ctx);assert.deepEqual(vm.step(8,env),{cost:0});assert.deepEqual(vm.state(8).saved,[50,33,1]);assert.equal(vm.state(8).pc,'EDAA');assert.equal(vm.state(8).working,undefined);
});
test('The failed self-loop time yield commits its working arguments',()=>{
 const{vm,env}=setup();vm.state(8).pc='EDE1';vm.state(8).saved=[50,255,20];vm.step(8,env);assert.deepEqual(vm.state(8).saved,[50,20,20]);assert.equal(vm.state(8).pc,'EDE1');assert.equal(vm.state(8).working,undefined);
});
test('Known root arguments are not rebound by a failed rule',()=>{
 const{vm,env}=setup([50,7,1]);vm.step(8,env);assert.deepEqual(vm.state(8).saved,[50,7,1]);assert.deepEqual(vm.state(8).contexts[0].saved,[50,2,20]);
});
test('Save/load at the suspended child preserves both the row and the distinct child arguments',()=>{
 const{vm,env}=setup();vm.step(8,env);const save=JSON.parse(JSON.stringify(vm.dump())),copy=new NpcProgram(data.npcPrograms,new ActorScheduler());copy.restore(save);assert.deepEqual(copy.dump(),save);assert.deepEqual(copy.state(8).saved,[50,255,1]);assert.deepEqual(copy.state(8).contexts[0].saved,[50,2,20]);
});
