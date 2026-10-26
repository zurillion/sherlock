// Ordinary placement rule DEC1/DED9. Bulk and weight are distinct: D2ED
// sums only direct children's sizes, with the source's signed overflow clamp.
// D206 advances past the table's first entry: entity zero is never visited.
export function containedBulk(world,id){
 let total=0;
 for(const child of world.entities)if(child.id!==0&&child.parent===id){const sum=(total+child.size)&255;if(!((total^child.size)&128)&&((total^sum)&128))return 255;total=sum;}
 return total;
}
export function canPlace(world,object,target,actor){
 if(!world.perceived(object.id,actor)||!world.owns(actor,object.id)||!world.perceived(target.id,actor))return false;
 // C79A treats attribute masks as non-fatal during semantic preflight.
 // Execution applies those masks separately, after resolving the arguments.
 return fitsContainer(world,object,target);
}

// E3F5/DEE4 uses the same direct-child bulk predicate for entering.
export function fitsContainer(world,object,target){
 if(!(target.properties&7))return false;
 const room=target.size-object.size;return room>=0&&room>containedBulk(world,target.id);
}
