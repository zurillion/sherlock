import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {ActorScheduler,ACTOR_ORDER,SchedulerLimit} from '../src/scheduler.mjs';
const read=async p=>JSON.parse(await readFile(new URL(p,import.meta.url),'utf8'));
const reference=await read('./fixtures/scheduler-reference.json'),prompt=await read('./fixtures/prompt-deadlines.json');
for(const trace of reference.cases)test('Original scheduler cost replay: '+trace.label,()=>{
 const [minute,hour,day,period]=trace.calendar,minutes=day*1440+(hour%12+(period===112?12:0))*60+minute;
 const actors=structuredClone(trace.boot?ACTOR_ORDER.map(id=>({id})):prompt);
 const interrupted=trace.events.some(e=>e.event==='wait_enter_interrupt');if(interrupted)actors[0].savedAction=50;
 const s=new ActorScheduler(actors,{tick:trace.tick,minutes,atPlayerInput:!trace.boot}),seen=[];s.observer=e=>seen.push(e);
 const costs=trace.events.filter(e=>e.event==='actor_return'),queue=[...costs];
 const result=s.run({step:actor=>{
  if(!queue.length)return {type:'input'};
  // The historical tracer starts mid-visit for a prompt snapshot, before its
  // local in_loop variable has seen actor_begin. Those initial nulls are Holmes.
  const next=queue.shift();assert.equal(actor.id,next.actor??0,'recorded actor order');return {cost:next.cost};
 }},{interrupt:interrupted});
 assert.equal(result.type,'input');assert.equal(queue.length,0);
 const fields=e=>({tick:e.tick,actor:e.actor,due:e.due,eligible:e.eligible});
 assert.deepEqual(seen.filter(e=>e.event==='visit').map(fields),trace.events.filter(e=>e.event==='visit').map(fields));
 const deadlines=e=>({tick:e.tick,actor:e.actor,old_due:e.old_due,cost:e.cost,new_due:e.new_due});
 assert.deepEqual(seen.filter(e=>e.event==='reschedule').map(deadlines),trace.events.filter(e=>e.event==='reschedule').map(deadlines));
 assert.deepEqual(seen.filter(e=>e.event==='step').map(e=>[e.tick,e.actor,e.cost]),costs.map(e=>[e.tick,e.actor??0,e.cost]));
 assert.deepEqual(seen.filter(e=>e.event==='callback').map(e=>[e.tick,e.actor]),trace.events.filter(e=>e.event==='callback_dispatch').map(e=>[e.tick,e.loop_actor??0]));
});
test('Same-tick messages and effects are visible to later actors in table order',()=>{
 const s=new ActorScheduler([{id:0},{id:3}],{tick:1,minutes:480,atPlayerInput:true});let paid=false,received=false;
 s.run({step:actor=>{if(actor.id===0){if(paid)return {type:'input'};paid=true;s.sendSignal(0,3);s.sendRequest(0,3,{action:49});return {cost:1};}received=s.consumeSignal(3,0)&&s.takeRequest(3).command.action===49;return {cost:5};}});
 assert(received);assert.equal(s.actor(3).due,5);assert.equal(s.signals.length,0);assert.equal(s.requests.length,0);
});
test('Zero-cost steps and a suspended input retain one prepared context across save/load',()=>{
 const s=new ActorScheduler(ACTOR_ORDER.map(id=>({id,enabled:id===0})),{tick:1,minutes:480});s.phase='visit';let preparations=0;
 s.run({prepare:()=>{preparations++;return {stage:0};},step:(a,c)=>{if(c.stage++===0)return {cost:0};return {type:'input'};}});
 const resumed=ActorScheduler.load(JSON.parse(JSON.stringify(s.dump())));let paid=false;
 resumed.run({prepare:()=>{preparations++;return {};},step:()=>{if(!paid){paid=true;return {cost:2};}return {type:'input'};}});
 assert.equal(preparations,2);assert.equal(resumed.tick,2);assert.equal(resumed.actor(0).due,2);
});
test('Services precede the next tick; deadline comparison and addition remain unsigned 16-bit',()=>{
 const s=new ActorScheduler([{id:0,due:65535}],{tick:65534,minutes:100});s.requestService('save');const before=s.minutes;
 assert.deepEqual(s.run({step:()=>{throw Error('must not run');}}),{type:'service',service:'save'});assert.equal(s.minutes,before);
 s.service=null;let paid=false;s.run({step:()=>{if(paid)return {type:'input'};paid=true;return {cost:1};}});
 assert.equal(s.actor(0).due,0);assert.equal(s.tick,0);assert.equal(s.minutes,before+2);
});
test('A program that never yields is diagnosed without advancing the calendar',()=>{
 const s=new ActorScheduler([{id:0}],{tick:1,minutes:480,atPlayerInput:true});assert.throws(()=>s.run({step:()=>({cost:0})},{maxSteps:20}),SchedulerLimit);assert.equal(s.minutes,480);
});
