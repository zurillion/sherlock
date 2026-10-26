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
