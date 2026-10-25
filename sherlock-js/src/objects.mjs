// Ordinary placement rule DEC1/DED9. Bulk and weight are distinct: D2ED
// sums only direct children's sizes, with the source's signed overflow clamp.
export function containedBulk(world,id){
 let total=0;
 for(const child of world.entities)if(child.parent===id){const sum=(total+child.size)&255;if(!((total^child.size)&128)&&((total^sum)&128))return 255;total=sum;}
 return total;
}
export function canPlace(world,object,target,actor){
 if(!world.perceived(object.id,actor)||!world.owns(actor,object.id)||!world.perceived(target.id,actor))return false;
 // C79A treats attribute masks as non-fatal during semantic preflight.
 // Execution applies those masks separately, after resolving the arguments.
 if(!(target.properties&7))return false;
 const room=target.size-object.size;if(room<0)return false;
 return room>containedBulk(world,target.id);
}
