import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
import {ClientSession} from '../src/session.mjs';
import {CommandHistory} from '../src/command-history.mjs';
import {rememberTab,recallTab,TAB_SESSION_KEY} from '../src/tab-session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url)));

test('The journal retains exact raw commands, failures, continuation replies, seed and teleports',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});
 for(const input of ['Open door','all','xyzzy','LOOK \"HELLO\"'])g.submit(input);
 g.teleport(5);g.submit('hail cab');g.submit('say "hello" to cabbie');
 const entries=g.history.entries;assert.deepEqual(entries.filter(e=>e.kind==='command').map(e=>e.text),['Open door','all','xyzzy','LOOK \"HELLO\"','hail cab','say "hello" to cabbie']);
 assert.equal(entries[0].outcome,'clarification');assert.equal(entries[0].errors[0],'WHICH DOOR ?');assert.equal(entries[2].outcome,'lexical_error');
 assert.equal(entries[3].outcome,'not_translated');assert.match(entries[3].errors[0],/JavaScript/);assert.equal(entries[4].kind,'teleport');assert.equal(entries[4].after.room,5);
 const text=g.history.format();assert.match(text,/# Seed iniziale: 1/);assert.match(text,/Open door\n# Esito: clarification/);assert.match(text,/# Teletrasporto: 005/);assert.match(text,/say "hello" to cabbie/);
});
test('Every input is retained beyond 200 entries and survives a tab reload and a portable save',async()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:42});
 for(let i=0;i<215;i++)s.request('command',{command:'XYZXY'+String(i)});
 const storage={value:null,getItem(key){assert.equal(key,TAB_SESSION_KEY);return this.value;},setItem(key,value){assert.equal(key,TAB_SESSION_KEY);this.value=value;}};
 rememberTab(storage,s.game,{history:[]});const tab=recallTab(storage,data,()=>{});
 assert.equal(tab.game.history.entries.length,215);assert.equal(tab.game.history.entries[0].text,'XYZXY0');assert.equal(tab.game.history.entries.at(-1).text,'XYZXY214');
 const save=(await s.request('save')).save,loaded=new ClientSession(data);await loaded.request('load',{save:JSON.parse(JSON.stringify(save))});
 assert.deepEqual(loaded.game.history.dump(),s.game.history.dump());assert.equal(loaded.game.history.meta.seed,42);loaded.request('command',{command:'LOOK'});assert.equal(loaded.game.history.entries.length,216);
 loaded.request('reset',{seed:7});assert.equal(loaded.game.history.entries.length,0);assert.equal(loaded.game.history.meta.seed,7);
});
test('Inspection and copying the history never alter world, display, queues or random inputs',()=>{
 const g=new Game(data,{npc_profile:'world-v5'});g.submit('OPEN DOOR');const before=g.dump();
 for(let i=0;i<10;i++){g.history.format({clock:g.world.clock().label,running:true});g.history.dump();}
 assert.deepEqual(g.dump(),before);const saved=structuredClone(before);delete saved.command_history;
 const old=Game.load(data,saved);assert.equal(old.history.complete,false);old.history.recover(['OPEN DOOR']);assert.equal(old.history.entries.length,1);assert.match(old.history.format(),/Cronologia parziale/);
 old.history.recover(['MUST NOT BE DUPLICATED']);assert.equal(old.history.entries.length,1);
 assert.equal(old.submit('ALL').state.analysis.outcome,'ok');assert.equal(old.history.entries.length,2);
});
test('The journal records the actual minute of interrupted WAIT UNTIL',()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'});const out=s.request('start-command',{command:'wait until 8:20'});assert(out.running&&out.can_interrupt);
 const first=out.state.clock.label;assert.equal(s.game.history.entries.length,1);s.game.history.format({clock:first,running:true});
 const end=s.request('continue-command',{job:out.job,interrupt:true});assert.equal(end.state.clock.label,first);
 assert.equal(s.game.history.entries[0].after.clock,first);assert.equal(s.game.history.entries[1].kind,'interrupt');assert.equal(s.game.history.entries[1].after.clock,first);
 assert.match(s.game.history.format(),/# Interruzione attesa:/);
});
test('A malformed history cannot replace the live session during load',async()=>{
 const s=new ClientSession(data,{npc_profile:'world-v5'});s.request('command',{command:'LOOK'});const before=s.game.dump(),invalid=structuredClone(before);invalid.command_history.entries[0].errors=[{}];
 assert.throws(()=>Game.load(data,invalid),/Cronologia/);assert.deepEqual(s.game.dump(),before);
 const h=new CommandHistory({seed:1,startMode:'free',profile:'world-v5'});assert.equal(h.format().includes('Cronologia completa'),true);
});
