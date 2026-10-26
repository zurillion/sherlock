import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';
import {NpcProgram} from '../src/npc-program.mjs';import {NpcPrimitives} from '../src/npc-primitives.mjs';
import {RecordLists} from '../src/record-arena.mjs';
import {ActorScheduler} from '../src/scheduler.mjs';import {World,UnsupportedFeature} from '../src/world.mjs';
import {CabRoutes,encodeMoney,decodeMoney,transferMoney,account} from '../src/cab-economy.mjs';
const read=async name=>JSON.parse(await readFile(new URL(name,import.meta.url),'utf8'));
const data=await read('../data/game.json'),reference=await read('./fixtures/npc-foundations.json');
const ruleIds={'E5A8':'wait.tick','E57A':'counter.decrement','E488':'location.save','E5AD':'entity.at','E79A':'watson.readingWait'};
function semantic(o){const kinds=['padding','action','action','rule','order','say','print','rule','signal.send','signal.take','return.failure','return.success','trap','yield','jump','yield'],n={op:kinds[o.kind],source:o.address,size:o.size,next:(parseInt(o.address,16)+o.size).toString(16).toUpperCase().padStart(4,'0'),success:o.success,failure:o.failure,erase:o.erase_on_success,restriction:o.request_restriction_flag};for(const key of ['args','action'])if(key in o)n[key]=o[key];if(o.rule){n.op='rule';n.rule=ruleIds[o.rule]||Object.entries(data.npcPrograms.rules).find(([,r])=>r.source===o.rule)?.[0];}if(o.target_actor!==undefined)n.recipient=o.target_actor;if(o.sender!==undefined)n.sender=o.sender;if(o.jump)n.target=o.jump;return n;}
function harness(trace){const world=new World(data),catalog=structuredClone(data.npcPrograms),scheduler=new ActorScheduler(),vm=new NpcProgram(catalog,scheduler),primitives=new NpcPrimitives(world);
 for(const [k,o] of Object.entries(trace.graph))catalog.instructions[k]=semantic(o);
 vm.start(trace.actor,'5B80');if(trace.initialCounter!==null)primitives.counters.push({actor:trace.actor,value:trace.initialCounter});
 let recordLists=new RecordLists();
 const env={enterContext:({actor,frame})=>recordLists.prepend('contexts',[actor,parseInt(frame.origin,16)&255,parseInt(frame.origin,16)>>>8,frame.saved[1],frame.saved[2],frame.request?2:1,frame.saved[0]]),leaveContext:({frame})=>recordLists.returnSaved(recordLists.remove('contexts',frame.record)),rule:(name,args,ctx)=>{if(name==='watson.readingWait')return {defer:'E79C',args,cost:0};const result=primitives.body(name,args,ctx);if(result.success){result.bindArgs=args;const frame=vm.state(ctx.actor).contexts.at(-1);if(frame?.record){const bound=ctx.saved.slice();for(let i=0;i<2;i++)if(bound[i+1]===255)bound[i+1]=args[i];recordLists.arena.putByte(frame.record+3,bound[1]);recordLists.arena.putByte(frame.record+4,bound[2]);recordLists.arena.putByte(frame.record+6,bound[0]);}}return result;},action:(id,args,ctx)=>{if(id===49)return {success:true,cost:5};throw new UnsupportedFeature('test action '+id);}};
 return {vm,world,scheduler,primitives,env,records:()=>recordLists,restoreRecords:s=>{recordLists=RecordLists.load(s);}};
}
for(const trace of reference.programs)test('Native NPC control, continuations and counters: '+trace.label,()=>{
 const h=harness(trace);let visit=-1;
 for(const expected of trace.rows){if(expected.visit!==visit){visit=expected.visit;h.vm.prepare(trace.actor);}
  const result=h.vm.step(trace.actor,h.env),s=h.vm.state(trace.actor);
  assert.equal(result.cost,expected.cost);assert.equal(s.pc,expected.pc);assert.deepEqual(s.saved,expected.saved);
  assert.deepEqual(trace.program.map((v,i)=>h.vm.erased.includes((0x5b80+i).toString(16).toUpperCase())?0:v),expected.fixture_bytes);
  assert.deepEqual([...s.contexts].reverse().map(c=>[trace.actor,parseInt(c.origin,16)&255,parseInt(c.origin,16)>>>8,c.saved[1],c.saved[2],c.request?2:1,c.saved[0]]),expected.contexts);
  assert.deepEqual(h.primitives.counters.map(c=>[c.actor,c.value]),expected.counters);assert.deepEqual(h.scheduler.signals.map(s=>[s.sender,s.recipient]),expected.signals);
 }
});
test('Original cab travel cost and fare on all 180 directed/mode cases',()=>{const routes=new CabRoutes(data.cab.routes);assert.equal(reference.routes.length,180);for(const r of reference.routes){const x=routes.find(r.source,r.target,{furiously:r.furiously});assert.equal(x.cost,r.native_duration);assert.equal(x.fare,r.native_fare);}assert.equal(routes.find(10,28,{furiously:true}).cost,0);assert.equal(routes.find(5,5),null);assert.equal(routes.find(5,29),null);});
test('Original money encoding including signed boundaries',()=>{for(const c of reference.money){assert.equal(encodeMoney(c.amount),c.encoded);assert.equal(decodeMoney(c.encoded),c.decoded);}assert.throws(()=>encodeMoney(16384));});
test('Native PAY effects preserve unsigned-funds and missing-account quirks',()=>{
 for(const c of reference.payments){const w=new World(data);account(w,c.sender).pence=c.funds;if(account(w,c.recipient))account(w,c.recipient).pence=c.received;
  assert.equal(transferMoney(w,c.sender,c.recipient,c.pay),c.success,JSON.stringify(c));
  for(const [actor,pence] of Object.entries(c.balances))assert.equal(account(w,Number(actor)).pence,pence,JSON.stringify(c));
 }
});
test('Saving inside a deferred NPC continuation preserves subsequent native steps',()=>{
 const trace=reference.programs.find(c=>c.label==='deferred_reading'),a=harness(trace);a.vm.prepare(3);a.vm.step(3,a.env);assert.equal(a.vm.state(3).contexts.length,1);
 const b=harness(trace);b.vm.restore(JSON.parse(JSON.stringify(a.vm.dump())));b.primitives.restore(a.primitives.dump());b.restoreRecords(a.records().dump());
 for(let i=0;i<8;i++){a.vm.prepare(3);b.vm.prepare(3);assert.deepEqual(a.vm.step(3,a.env),b.vm.step(3,b.env));assert.deepEqual(a.vm.dump(),b.vm.dump());}
});
test('Missing random counter inputs fail explicitly without creating a replacement counter',()=>{const w=new World(data),p=new NpcPrimitives(w);assert.throws(()=>p.body('counter.create',[13,4],{actor:3,saved:[255,255,255]}),UnsupportedFeature);assert.deepEqual(p.counters,[]);p.body('counter.create',[0,255],{actor:3,saved:[255,255,255]});assert.equal(p.body('counter.decrement',[],{actor:3}).success,true);assert.equal(p.counters[0].value,255);});
test('Prefab requests retain their type and can bypass quoted-request restrictions in the host',()=>{
 const scheduler=new ActorScheduler(),catalog={instructions:{A:{op:'order',source:'A',size:1,recipient:3,action:49,args:[255,255],success:'B'},B:{op:'yield',source:'B',size:1,success:'A'},C:{op:'rule',source:'C',rule:'unused',restriction:true,success:'C',failure:'C'}}},vm=new NpcProgram(catalog,scheduler);
 vm.start(2,'A');vm.start(3,'C');vm.prepare(2);vm.step(2,{order:()=>{}});vm.prepare(3);
 const out=vm.step(3,{request:(r,ctx)=>{assert.equal(r.command.kind,'prefabricated');assert.equal(ctx.restriction,true);return {handled:true,cost:5};}});assert.equal(out.cost,5);assert.equal(vm.state(3).pc,'C');assert.deepEqual(scheduler.requests,[]);
});
test('Exported NPC and object catalog contains 23 actor entries and only domain operations',()=>{const catalog=data.npcPrograms;assert.equal(catalog.actors.length,23);assert.equal(Object.keys(catalog.instructions).length,806);assert.equal(Object.keys(catalog.rules).length,84);assert(catalog.actors.some(a=>a.id===2)&&catalog.actors.some(a=>a.id===3)&&catalog.actors.some(a=>a.id===31)&&catalog.actors.some(a=>a.id===34));for(const op of Object.values(catalog.instructions))assert(!('raw' in op));});
