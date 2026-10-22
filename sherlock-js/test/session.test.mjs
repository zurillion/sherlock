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
 const s=new ClientSession(data),before=s.game.world.dump();const out=s.request('command',{command:'SAY TO WATSON "TAKE LAMP"'});
 assert.equal(out.state.engine,'javascript-autonomous');assert.equal(out.state.analysis.outcome,'not_translated');assert.deepEqual(s.game.world.dump(),before);
});
test('Snapshot validation rejects a containment cycle',async()=>{
 const s=new ClientSession(data),save=s.game.dump();save.world.entities[3].parent=24;save.world.entities[24].parent=3;
 const {Game}=await import('../src/game.mjs');assert.throws(()=>Game.load(data,save),/Ciclo/);
});
