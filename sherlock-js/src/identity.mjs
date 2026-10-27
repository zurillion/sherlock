// E03A changes the first actor row and transfers the physical actor record,
// direct possessions (IDs 1..109) and suspended context ownership. Requests
// and references to a particular identity are deliberately not retargeted.
export function changeIdentity(game,id){
 const w=game.world,old=w.player,previous=w.entity(old),next=w.entity(id),room=w.roomOf(old),parent=previous.parent;
 next.parent=parent;next.rooms=[room];previous.parent=null;previous.rooms=[0];
 for(const e of w.entities)if(e.id>0&&e.parent===old)e.parent=id;
 const row=w.scheduler.actors[0];row.id=id;row.name=next.name;
 if(w.scheduler.current?.actor===old&&w.scheduler.index===0)w.scheduler.current.actor=id;
 if(w.npcs)game.npcRuntime.use(({records})=>{
  for(const p of records.records('contexts'))if(records.arena.byte(p)===old)records.arena.putByte(p,id);
  if(w.npcs.foreignContexts[old]){w.npcs.foreignContexts[id]=w.npcs.foreignContexts[old];delete w.npcs.foreignContexts[old];}
 });
 w.player=id;
 return room;
}

// E03A also changes an NPC's actor slot (Tricia -> Mrs Jones). The VM calls
// this only after its current operation returns, before the next operation.
export function changeNpcIdentity(host,actor,id){
 const w=host.w,previous=w.entity(actor),next=w.entity(id),row=w.scheduler.actor(actor);
 next.parent=previous.parent;next.rooms=[w.roomOf(actor)];previous.parent=null;previous.rooms=[0];
 for(const e of w.entities)if(e.id>0&&e.parent===actor)e.parent=id;
 row.id=id;row.name=next.name;if(w.scheduler.current?.actor===actor)w.scheduler.current.actor=id;
 const {vm,records}=host.active;vm.states[id]=vm.states[actor];delete vm.states[actor];
 for(const p of records.records('contexts'))if(records.arena.byte(p)===actor)records.arena.putByte(p,id);
 if(host.state.foreignContexts[actor]){host.state.foreignContexts[id]=host.state.foreignContexts[actor];delete host.state.foreignContexts[actor];}
 // Queued references to the previous identity remain references to that ID.
 if(host.state.pending[actor]){(host.state.inactiveRequests??={})[actor]=host.state.pending[actor];delete host.state.pending[actor];}
}
