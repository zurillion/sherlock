import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
import {assertOriginalState} from './helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/endings-reference.json',import.meta.url)));
export function setupEnding(g,s){
 const w=g.world;if(Object.keys(s).length)g.submit('I');
 if('room'in s)w.move(w.player,s.room);if('actor_room'in s)w.move(s.actor,s.actor_room);
 if('companions'in s)for(const[id,key]of [[2,'lestrade'],[3,'watson']]){w.move(id,['both',key].includes(s.companions)?w.roomOf():8);w.scheduler.actor(id).due=1000;}
 if('failures'in s)w.npcs.playerFailures=s.failures;
 for(const at of s.proofs||[])w.npcs.facts.find(f=>f.start===at).flags|=2;
 if(s.known)for(const f of w.npcs.facts)for(let i=0;i<f.terms.length;){const flags=f.terms[i+1]>>>8;f.terms[i+1]|=512;i+=flags&48?3:2;}
 if(s.hold_major){w.move(7,0);w.scheduler.actor(7).due=1000;w.npcs.flags.strakerMet=true;}
 if(s.actor){w.npcs.program.states[s.actor].pc=s.pc;w.scheduler.actor(s.actor).due=w.tick;}
}
for(const[index,c]of ref.cases.entries())test('Original conclusion #'+index+' '+JSON.stringify(c.setup),()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});setupEnding(g,c.setup);let loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));
 for(const row of c.steps){const prior=g.dump(),n=g.world.random.draws,out=g.submit(row.input),count=g.world.random.draws-n,draws=count?g.world.random.trace.slice(-count):[];
 if(index===22&&out.state.analysis.outcome==='not_translated'){assert.equal(g.world.clock().label,'Mon 08:30am');assert.match(out.state.prototype_notice,/5D06/);assert.deepEqual(g.world.dump(),prior.world);return;}
 assert.notEqual(out.state.analysis.outcome,'not_translated',row.input+' @ '+g.world.clock().label+' '+out.state.prototype_notice);assert.equal(draws.length,row.random.length,row.input+' draw count');for(const[i,d]of row.random.entries())for(const key of['actor','width','mixOffset','seed','cursor','reads','result','next_seed','next_cursor'])assert.deepEqual(draws[i][key],d[key],row.input+' draw '+i+' '+key);
 assert.deepEqual(g.ended,row.ending);if(g.ended)assert.equal(g.world.display.counter,row.after.mutable.A019,'Terminal scroll counter');if(row.story_flags){assert.equal(Boolean(g.world.npcs.flags.caseReady),row.story_flags.case_ready);assert.equal(Boolean(g.world.npcs.flags.strakerMet),row.story_flags.straker_met);}assertOriginalState(g,row.after,'Case '+index+' '+row.input);assert.deepEqual(loaded.submit(row.input),out);assert.deepEqual(loaded.dump(),g.dump());loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));
 if(g.ended){const before=g.dump();assert.equal(out.state.analysis.outcome,'game_over');g.submit('I');assert.deepEqual(g.world.dump(),before.world);assert.deepEqual(g.ended,before.ended);}
 }
});

const {ClientSession}=await import('../src/session.mjs'),{SpectrumBuffer,SpectrumTerminal}=await import('../src/spectrum.mjs'),{createHash}=await import('node:crypto');
function upperHash(game,screen){const bytes=[];for(let y=0;y<144;y++)for(let x=0;x<32;x++)bytes.push(game.sourceDisplay.rowByte(screen.lines[Math.floor(y/8)],y%8,x*8));return createHash('sha256').update(Uint8Array.from(bytes)).digest('hex');}
for(const index of[9,13,14,15,18,19,20,21,23,24,25,26,27,28,29,30,31])test('Ending web packets and pre-clear acknowledgement #'+index,()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1});setupEnding(s.game,ref.cases[index].setup);const screen=new SpectrumBuffer(),display=s.game.world.display;
 screen.lines=[...display.upper];screen.counter=display.counter;screen.cursor=display.cursor;screen.remaining=display.remaining;screen.started=display.started;
 let acks=0,run=s.request('start-command',{command:ref.cases[index].steps[0].input}),guard=0;
 for(;;){for(const m of run.messages)for(const e of m.screen_events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='acknowledge'){acks++;assert.equal(e.reason,'ending');assert.equal(screen.counter,ref.cases[index].steps[0].pause.mutable.A019,'Counter before terminal acknowledgement');assert.equal(upperHash(s.game,screen),ref.cases[index].steps[0].pause.upper_sha256,'Final prose stays visible before acknowledgement');}else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}if(!run.running)break;assert(guard++<100);run=s.request('continue-command',{job:run.job});}
 assert.equal(acks,1);assert.deepEqual(screen.lines,s.game.world.display.upper);assert(screen.lines.every(line=>!line));assert.equal(s.job,null);assert.equal(run.state.analysis.outcome,'game_over');
});
test('Spectrum ending acknowledgement waits for a key without applying MORE counter changes',async()=>{
 const terminal=Object.create(SpectrumTerminal.prototype);Object.assign(terminal,{epoch:7,active:true,model:new SpectrumBuffer(),status:{},render(){},waiting:false,waitingReason:null});terminal.model.setColumns(18);terminal.model.counter=11;terminal.model.lines[17]='Final text';
 let done=false;const promise=terminal.displayEvent({op:'acknowledge',reason:'ending'},7).then(v=>{done=true;return v;});await Promise.resolve();assert.equal(done,false);assert.equal(terminal.waitingReason,'ending');assert.equal(terminal.model.lines[17],'Final text');terminal.more();assert.equal(await promise,true);assert.equal(terminal.model.counter,11);assert.equal(terminal.model.columns,36);assert.equal(terminal.model.lines[17],'Final text');
});
test('Terminal state survives saving; commands and map cannot advance it; reset starts a fresh game',async()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1});setupEnding(s.game,ref.cases[9].setup);s.request('command',{command:'I'});const frozen=s.game.dump();
 const saved=(await s.request('save')).save,loaded=new ClientSession(data);await loaded.request('load',{save:JSON.parse(JSON.stringify(saved))});assert.deepEqual(loaded.game.dump(),frozen);
 for(const session of[s,loaded]){assert.deepEqual(session.request('command',{command:'WAIT'}).messages,[]);assert.deepEqual(session.request('teleport',{room:8}).messages,[]);assert.deepEqual(session.game.dump(),frozen);const out=session.request('reset',{seed:1});assert.equal(out.state.game_over,null);assert.equal(out.state.clock.label,'Mon 08:00am');}
});
