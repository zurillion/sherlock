import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{ClientSession}from'../src/session.mjs';import{Game}from'../src/game.mjs';import{assertOriginalState}from'./helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/calendar-waits-reference.json',import.meta.url)));
for(const[index,c]of ref.cases.entries())test('Original long wait/calendar #'+index,()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=session.game,w=g.world,s=c.setup;if('day'in s){w.minutes=s.day*1440+(s.hour%12+(s.period==='pm'?12:0))*60+s.minute;if('tick'in s){w.tick=s.tick;w.playerDue=s.tick;}}
 let out=null,loaded=null;
 for(const[i,row]of c.steps.entries()){
  const n=w.random.draws;out=row.input?session.request('start-command',{command:row.input}):session.request('continue-command',{job:out.job,interrupt:Boolean(c.steps[i-1].interrupt_next)});
  if(row.input==='I')while(out.running)out=session.request('continue-command',{job:out.job});
  const count=w.random.draws-n,draws=count?w.random.trace.slice(-count):[];assert.notEqual(out.state.analysis.outcome,'not_translated',out.state.prototype_notice);assert.equal(out.running,row.running);assert.equal(draws.length,row.random.length,'Draw count');for(const[j,d]of row.random.entries())for(const k of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[j][k],d[k],'Frame '+i+' draw '+j+' '+k);assertOriginalState(g,row.after,'Calendar '+index+' frame '+i);assert.equal(w.npcs.literal,row.literal);
  if(out.running)assert.throws(()=>g.dump(),/Interrompi/);else{if(loaded&&row.input){loaded.submit(row.input);assert.deepEqual(loaded.dump(),g.dump());}loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));}
 }
});
