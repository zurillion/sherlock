import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
test('Train map state follows arrival, departure, hidden vehicles and load',()=>{
 const g=new Game(data,{npcs:false}),w=g.world;
 assert(g.state().trains.every(t=>!t.rooms.length));
 w.move(36,20);w.entity(36).attributes|=128;assert.deepEqual(g.state().trains.find(t=>t.id===36).rooms,[20]);
 const loaded=Game.load(data,JSON.parse(JSON.stringify(g.dump())));assert.deepEqual(loaded.state().trains,g.state().trains);
 w.entity(36).attributes&=127;assert.deepEqual(g.state().trains.find(t=>t.id===36).rooms,[]);
 w.move(36,2);w.entity(36).attributes|=128;assert.deepEqual(g.state().trains.find(t=>t.id===36).rooms,[]);
 w.move(36,54);assert.deepEqual(g.state().trains.find(t=>t.id===36).rooms,[54]);
});
test('Natural world-v5 first WAIT exposes trains at the three occupied platforms',()=>{
 const g=new Game(data,{npc_profile:'world-v5',seed:1});const o=g.submit('WAIT');assert.equal(o.state.clock.label,'Mon 08:05am');
 assert.deepEqual(o.state.trains.filter(t=>t.rooms.length).map(t=>[t.id,t.rooms]),[[36,[20]],[40,[27]],[41,[31]]]);
});
