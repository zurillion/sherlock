// Cab eligibility and arrival. The v5 domain host installs the driver's service;
// older saved profiles retain the former arrival-only implementation.
export class Cab {
 constructor(game){this.game=game;this.streets=new Set(game.data.cab?.streets||[]);}
 isStreet(room=this.game.world.roomOf()){return this.streets.has(room);}
 available(vehicle,actor=this.game.actor){
  const w=this.game.world,driver=w.scheduler.actors.find(a=>a.id===vehicle.id+1);
  return vehicle.rules.some(r=>r.rule==='hailCab')&&this.isStreet(w.roomOf(actor))&&vehicle.parent===null&&vehicle.rooms.length===1&&vehicle.rooms[0]===0&&driver&&(w.npcs?this.game.npcRuntime.canHail(vehicle.id):!driver.behavior);
 }
 arrive(vehicle,actor,{domainAction=false}={}){
  const w=this.game.world;w.move(vehicle.id,w.roomOf(actor));
  if(w.npcs){this.game.npcRuntime.moved(w.roomOf(actor));this.game.npcRuntime.hail(vehicle.id,actor,{domainAction});return;}
  const driver=w.scheduler.actor(vehicle.id+1);driver.program='cab-prefix';driver.enabled=false;
  driver.behavior={phase:'arrival-script-pending',vehicle:vehicle.id,customer:actor};
  driver.suspension={feature:'cocchiere: chiamata, salita e PAY ordinario disponibili; viaggio, attese, richiesta tariffa e resto ancora da ricostruire',tick:w.tick};
 }
 validateState(){
  const w=this.game.world;
  for(const id of [31,34]){
   const a=w.scheduler.actor(id),b=a.behavior;if(a.program!=='cab-prefix')continue;
   if(a.enabled||b?.phase!=='arrival-script-pending'||b.vehicle!==id-1||!Number.isInteger(b.customer)||!w.entities[b.customer]?.person)throw Error('Stato della chiamata del cab non valido.');
  }
 }
}
