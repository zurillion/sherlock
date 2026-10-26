import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {ClientSession} from '../src/session.mjs';
import {assertOriginalState} from './helpers/original-state.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),ref=JSON.parse(await readFile(new URL('fixtures/shared-door-reference.json',import.meta.url)));
test('Original shared-door filter: eight distant actions stay silent, with exact state and both screen bitmaps',()=>{
 assert.equal(ref.events.length,8);assert.equal(ref.frames.length,8);
 const s=new ClientSession(data,{npc_profile:'world-v5',seed:1}),g=s.game,events=[],notifications=[],show=g.npcRuntime.showAction.bind(g.npcRuntime);let checked=0;
 assert.deepEqual(g.world.entity(50).rooms,ref.door_record.rooms);
 g.npcRuntime.showAction=(out,actor,messages,actions)=>{
  const before=messages.length;show(out,actor,messages,actions);
  notifications.push(...messages.slice(before).filter(m=>m.text.startsWith('Someone')));
  if([14,36].includes(out.action)&&out.cost&&out.args[0]===50&&!g.world.perceived(actor)){events.push({time:g.world.clock().label,actor,actor_name:g.world.entity(actor).name,actor_room:g.world.roomOf(actor),door:out.args[0],action:out.action,player_room:g.world.roomOf()});}
 };
 for(const command of ref.commands){
  let out=s.request('start-command',{command});
  for(let guard=0;;guard++){
   assert(guard<500);assert.equal(out.state.analysis.outcome,'ok',out.state.prototype_notice);
   const frame=ref.frames[checked];if(frame&&g.world.clock().label===frame.after.clock.label){assertOriginalState(g,frame.after,frame.after.clock.label);checked++;}
   if(!out.running)break;
   out=s.request('continue-command',{job:out.job,interrupt:g.world.clock().label===ref.stop});
  }
 }
 assert.equal(checked,8);assert.deepEqual(events,ref.events);assert.deepEqual(notifications,[],'Original CB01 rejects distant buildings');assert.equal(g.world.roomOf(),8);
});
