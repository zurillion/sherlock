import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {ClientSession} from '../src/session.mjs';
import {waitUntilCost} from '../src/wait-until.mjs';
import {UnsupportedFeature} from '../src/world.mjs';
import {assertOriginalState} from './helpers/original-state.mjs';
import {SpectrumBuffer} from '../src/spectrum.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url))),data=await read('../data/game.json'),ref=await read('fixtures/wait-until-reference.json');
assert.equal(ref.cases.length,5,'Complete native wait corpus');
const keys=['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'];
function packets(screen,events){for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const a of screen.packet(e))if(a==='line')while(!screen.newline())screen.more();}}
test('Original WAIT UNTIL arithmetic: 576 AM/PM, equality, noon and numeric-hour cases',()=>{assert.equal(ref.costs.length,576);for(const row of ref.costs)assert.equal(waitUntilCost(row.literal,row.clock),row.cost,JSON.stringify(row));});
for(const c of ref.cases)test('WAIT UNTIL original minute frames, state and randomness: '+c.label,async()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),screen=new SpectrumBuffer();packets(screen,session.state().opening_screen);for(const command of c.prefix){const out=session.request('command',{command});assert.equal(out.state.analysis.outcome,'ok');for(const m of out.messages)packets(screen,m.screen_events);}
 let job=null,loaded=null,seenNews=false,seenArrival=false;
 for(const[i,row]of c.steps.entries()){
  const g=session.game,start=g.world.random.draws,operation=row.input?(row.input.startsWith('WAIT UNTIL')?'start-command':'command'):'continue-command',body=row.input?{command:row.input}:{job,interrupt:row.interrupt},out=session.request(operation,body),n=g.world.random.draws-start,draws=n?g.world.random.trace.slice(-n):[],label=c.label+' #'+i;
  assert.equal(out.running,row.running,label+' pause');assert.equal(out.state.clock.label,row.after.clock.label,label+' clock');assert.equal(out.state.analysis.outcome,'ok',label+' '+out.state.prototype_notice);assert.equal(draws.length,row.random.length,label+' draw count');for(const[j,d]of row.random.entries())for(const k of keys)assert.deepEqual(draws[j][k],d[k],label+' draw '+j+' '+k);
  assert.equal(g.world.npcs.literal,row.literal,label+' literal');assertOriginalState(g,row.after,label);job=out.job??null;
  for(const m of out.messages){packets(screen,m.screen_events);seenNews||=m.text.includes('two close friends');seenArrival||=m.text.includes('goes')||m.text.includes('enters');}assert.deepEqual(screen.lines,g.world.display.upper,label+' actual browser packets');assert.equal(screen.counter,g.world.display.counter,label+' scroll budget');
  if(row.interrupt){const save=(await session.request('save')).save;loaded=new ClientSession(data);loaded.serial=session.serial;await loaded.request('load',{save});}
  else if(loaded&&row.input){const other=loaded.request(operation,body);assert.deepEqual(other,out,label+' future after load');if(out.running)loaded=null;else assert.deepEqual(loaded.game.dump(),g.dump(),label+' future state');}
 }
 if(c.label==='clock_and_news')assert(seenNews,'A visible message does not end the wait');if(c.label==='house_arrivals')assert(seenArrival,'Visible character movements do not end the wait');
});
test('A distant WAIT UNTIL can be interrupted before any future unimplemented branch is evaluated',()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5'});let out=session.request('start-command',{command:'WAIT UNTIL 7AM'});assert.equal(out.state.clock.label,'Mon 08:01am');assert.equal(session.game.world.clock().label,'Mon 08:01am');out=session.request('continue-command',{job:out.job,interrupt:true});assert.equal(out.running,false);assert.equal(out.state.clock.label,'Mon 08:01am');assert.equal(session.game.pendingWait,undefined);assert.equal(session.game.world.npcs.playerProgramCounter,'9923');
});
test('A partially displayed wait cannot export an invalid prompt save; after ENTER its future is portable',async()=>{
 const a=new ClientSession(data,{npc_profile:'world-v5'});const out=a.request('start-command',{command:'WAIT UNTIL 9:00'});assert.throws(()=>a.game.dump(),/Interrompi/);assert.throws(()=>a.request('save'),/Completa/);
 a.request('continue-command',{job:out.job,interrupt:true});const b=new ClientSession(data);await b.request('load',{save:(await a.request('save')).save});assert.deepEqual(a.request('command',{command:'I'}),b.request('command',{command:'I'}));
});
test('An unknown future minute preserves the visible past and leaves a usable prompt',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'}),step=s.game.npcRuntime.step.bind(s.game.npcRuntime);s.game.npcRuntime.step=(...args)=>{if(s.game.world.minutes===483)throw new Error('test-marker');return step(...args);};
 let out=s.request('start-command',{command:'WAIT UNTIL 9:00'});assert.equal(out.clock.minute,1);out=s.request('continue-command',{job:out.job});assert.equal(out.clock.minute,2);out=s.request('continue-command',{job:out.job});assert.equal(out.clock.minute,3);
 // Inject a documented prototype boundary, not an arbitrary engine fault.
 s.game.npcRuntime.step=(...args)=>{if(s.game.world.minutes===483)throw new UnsupportedFeature('test future boundary');return step(...args);};out=s.request('continue-command',{job:out.job});assert.equal(out.running,false);assert.equal(out.state.clock.minute,3);assert.equal(out.state.analysis.outcome,'not_translated');assert.equal(s.game.pendingWait,undefined);assert.equal(s.game.world.npcs.playerProgramCounter,'9923');s.game.dump();
});
test('A boundary before the first minute cancels only the new input and does not retry the same NPC forever',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'}),before=s.game.world.dump();s.game.npcRuntime.step=()=>{throw new UnsupportedFeature('test initial boundary');};
 const out=s.request('start-command',{command:'WAIT UNTIL 9:00'});assert.equal(out.running,false);assert.deepEqual(s.game.world.dump(),before);assert.equal(out.state.analysis.outcome,'not_translated');assert(!out.messages.some(m=>m.kind==='narrative'));assert.equal(s.game.pendingWait,undefined);s.game.dump();
});
test('The synchronous model API and the incremental page reach the same complete original state',()=>{
 const a=new ClientSession(data,{npc_profile:'world-v5'}),b=new ClientSession(data,{npc_profile:'world-v5'});a.request('command',{command:'WAIT UNTIL 8:20'});let out=b.request('start-command',{command:'WAIT UNTIL 8:20'});while(out.running)out=b.request('continue-command',{job:out.job});assert.deepEqual(a.game.dump(),b.game.dump());
});
