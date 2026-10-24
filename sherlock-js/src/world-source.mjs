import {encodeMoney} from './cab-economy.mjs';
const word=(bytes,value)=>bytes.push(value&255,value>>>8&255);
// Serialize understood data records on demand. This is not a snapshot fallback:
// every mutable field below belongs to the logical world and follows its moves.
export class WorldSource {
 constructor(data,world){this.data=data;this.world=world;this.layout=data.randomInputs.worldLayout;}
 room(layout){const r=this.world.rooms[layout.id],bytes=[r.flags];for(const n of r.nameWords)word(bytes,n);word(bytes,r.description?parseInt(r.description,16):0);for(const e of r.exits)bytes.push(e.direction_id,e.gate,e.target);bytes.push(255);return bytes;}
 entity(layout){const e=this.world.entity(layout.id),bytes=[e.rooms.length,e.parent??255,e.size,e.weight,e.properties,e.attributes,e.status];word(bytes,e.noun);word(bytes,e.money?encodeMoney(e.pence):e.qualifiers[0]);word(bytes,e.qualifiers[1]);word(bytes,e.description?parseInt(e.description,16):0);bytes.push(...e.rooms,...layout.rulePairs.flat(),255);return bytes;}
 read(address){
  if(!this.layout)return null;
  const room=this.layout.rooms.find(r=>address>=r.start&&address<r.start+r.size);if(room)return this.room(room)[address-room.start]??null;
  const entity=this.layout.entities.find(e=>address>=e.start&&address<e.start+e.size);if(entity)return this.entity(entity)[address-entity.start]??null;
  for(const r of this.layout.tables)if(address>=r.start&&address<r.start+r.values.length)return r.values[address-r.start];
  return null;
 }
}
