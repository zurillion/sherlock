import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {ClientSession} from '../src/session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
test('WAIT produces five UI clock frames while the domain logic remains local',()=>{
 const s=new ClientSession(data),frames=[];let result=s.request('start-command',{command:'WAIT'});while(result.running){frames.push(result.clock.minute);result=s.request('continue-command',{job:result.job});}
 assert.deepEqual(frames,[1,2,3,4,5]);assert.equal(result.state.clock.label,'Mon 08:05am');
});
test('SAVE/LOAD preserve logical state and detect corrupted files atomically',async()=>{
 const a=new ClientSession(data);a.request('command',{command:'OPEN DOOR'});const document=(await a.request('save',{presentation:{test:'client'}})).save;
 assert.equal(document.format,'sherlock-js-save');assert(!('memory' in document)&&!('registers' in document));
 const b=new ClientSession(data);await b.request('load',{save:JSON.parse(JSON.stringify(document))});
 assert.deepEqual(a.request('command',{command:'YOUR'}),b.request('command',{command:'YOUR'}));
 const before=b.game.dump(),bad=structuredClone(document);bad.world.minutes++;
 await assert.rejects(()=>b.request('load',{save:bad}));assert.deepEqual(b.game.dump(),before);
 await assert.rejects(()=>b.request('load',{save:{format:'sherlock-web-save',version:1}}));assert.deepEqual(b.game.dump(),before);
});
test('Unsupported narrative scripts never invoke an external service',()=>{
 const s=new ClientSession(data),before=s.game.world.dump();const out=s.request('command',{command:'SAY TO WATSON "TELL ME ABOUT LESTRADE"'});
 assert.equal(out.state.engine,'javascript-autonomous');assert.equal(out.state.analysis.outcome,'not_translated');assert.deepEqual(s.game.world.dump(),before);
});
test('Snapshot validation rejects a containment cycle',async()=>{
 const s=new ClientSession(data),save=s.game.dump();save.world.entities[3].parent=24;save.world.entities[24].parent=3;
 const {Game}=await import('../src/game.mjs');assert.throws(()=>Game.load(data,save),/Ciclo/);
});
test('WAIT UNTIL interruption restores NPC state and queues at the displayed minute, not only the clock',async()=>{
 const a=new ClientSession(data);a.request('command',{command:'SAY TO WATSON "WAIT"'});a.request('command',{command:'SAY TO WATSON "TAKE LAMP"'});
 let frame=a.request('start-command',{command:'WAIT UNTIL 9:00'});assert.equal(frame.clock.label,'Mon 08:03am');
 frame=a.request('continue-command',{job:frame.job});assert.equal(frame.clock.label,'Mon 08:04am');
 const result=a.request('continue-command',{job:frame.job,interrupt:true});assert(!result.running);assert.equal(result.state.clock.label,'Mon 08:04am');
 assert.equal(a.game.world.entity(22).parent,null);assert.equal(a.game.world.scheduler.requests.length,1);
 assert(a.game.world.scheduler.actor(3).enabled);assert.equal(a.game.world.scheduler.actor(3).behavior.remaining,15);
 const b=new ClientSession(data);await b.request('load',{save:(await a.request('save')).save});
 assert.deepEqual(a.request('command',{command:'LOOK'}),b.request('command',{command:'LOOK'}));assert.equal(a.game.world.entity(22).parent,3);
});
test('Minute animation releases Watson text only in its minute and never leaks a future suspended branch on interruption',()=>{
 const s=new ClientSession(data),messages=[];let r=s.request('start-command',{command:'WAIT UNTIL 9:00'});
 for(let n=0;n<3;n++){messages.push(...r.messages);assert.equal(r.clock.minute,n+1);if(n<2)r=s.request('continue-command',{job:r.job});}
 assert.equal(messages.filter(m=>m.kind==='narrative').map(m=>m.text).join(' '),'You wait.');
 assert(!messages.some(m=>m.kind==='system'));s.request('continue-command',{job:r.job,interrupt:true});
 assert.equal(s.game.world.scheduler.actor(3).behavior.remaining,12);assert(s.game.world.scheduler.actor(3).enabled);
 assert.equal(s.game.world.scheduler.actor(3).suspension,undefined);
});
test('A clarification following a multi-minute command is retained in the last frame',()=>{
 const s=new ClientSession(data),messages=[];let r=s.request('start-command',{command:'WAIT. OPEN DOOR'});while(r.running){messages.push(...r.messages);r=s.request('continue-command',{job:r.job});}
 assert(messages.some(m=>m.kind==='error'&&m.text==='WHICH DOOR ?'));assert(s.game.pending);
});

test('Minute frames expose actor state at that minute without advancing or rewinding the live domain',()=>{
 const s=new ClientSession(data);s.request('command',{command:'SAY TO WATSON "WAIT"'});s.request('command',{command:'SAY TO WATSON "TAKE LAMP"'});
 let r=s.request('start-command',{command:'WAIT'});const final=s.game.dump();
 while(r.running){const a=r.state.scheduler.actors.find(a=>a.id===3);assert(a.enabled);
  assert.equal(r.state.clock.label,r.clock.label);assert.equal(s.request('state').clock.label,r.clock.label);
  if(r.clock.minute<5)assert.equal(r.state.scheduler.requests.length,1);else assert.equal(r.state.scheduler.requests.length,0);
  assert.deepEqual(s.game.dump(),final);r=s.request('continue-command',{job:r.job});
 }
 assert.equal(s.game.world.entity(22).parent,3);
});
