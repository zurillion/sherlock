// Functional translation of rule-header constraints C628/C6BE. Headers are
// typed data; this module neither executes nor decodes source instructions.
import {UnsupportedFeature} from './world.mjs';
export class ArgumentChecks {
 constructor(host){this.host=host;}
 write(value){this.host.state.argumentCheck=value;}
 argument(meta,slot,id,{actor,phase,literal=this.host.state.literal,otherLiteral=this.host.state.otherLiteral}={}){
  const w=this.host.w,kind=meta.classes[slot];if(!kind)return true;
  const reject=()=>{this.write(0);return false;};
  if(kind<=4){const room=w.rooms[id];if(kind<=2&&!(room?.flags&128))return reject();if(kind&1&&!w.rooms[w.roomOf(actor)].exits.some(e=>e.target===id))return reject();return true;}
  if(kind<=6){if(id!==254)return reject();const raw=slot?otherLiteral:literal;if(!Number.isInteger(raw))throw new UnsupportedFeature('letterale del secondo argomento non ricostruito');return Boolean(raw&128)===(kind===6)||reject();}
  const e=w.entities[id];let valid=Boolean(e),soft=false;
  if(valid&&kind!==7){
   if(kind!==12)valid=w.perceived(id,actor);
   if(valid&&kind===9){valid=e.rooms.length===1&&!e.person&&w.weight(id)<=w.remainingCapacity(actor);soft=valid&&w.entities.some(p=>p.person&&w.owns(p.id,id));}
   if(valid&&kind===10)valid=w.owns(actor,id);
   if(valid&&kind===11)valid=e.rooms.length!==1;
   if(valid&&kind>=12)valid=e.person;
  }
  // First-argument class failure passes C655; second-argument entity failure
  // returns directly at C726, retaining the old A021 byte.
  if(!valid||soft&&phase){if(slot===0)this.write(0);return false;}
  const tests=meta.masks?.find(m=>m.argument===slot+1)?.tests||[];
  for(const {mode,mask}of tests){const bits=e.attributes&mask,ok=[bits===mask,!mask||bits!==0,bits===0,bits!==mask][mode];if(!ok){if(phase){this.failure='mask';this.write(1);return false;}break;}}
  return true;
 }
 rule(meta,args,options){this.failure=null;const w=this.host.w;if(meta.requiresLight&&w.dark(options.actor))return false;return this.argument(meta,0,args[0],options)&&this.argument(meta,1,args[1],options);}
}
