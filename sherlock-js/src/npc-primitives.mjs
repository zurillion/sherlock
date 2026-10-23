import {UnsupportedFeature} from './world.mjs';
import {balance} from './cab-economy.mjs';
const clone=structuredClone;
// Bodies/predicates whose domain meaning has been understood. This component
// does not silently supply header validation, random inputs or dialogue.
export class NpcPrimitives {
 constructor(world,{absoluteRandom}={}){this.world=world;this.absoluteRandom=absoluteRandom;this.counters=[];}
 counter(actor){return this.counters.find(c=>c.actor===actor);}
 root(id){const w=this.world;let object=w.entity(id),last=255;const seen=new Set();while(object.parent!==null){if(seen.has(object.id))throw Error('Containment cycle');seen.add(object.id);last=object.parent;object=w.entity(last);if(!(object.attributes&128)||!(object.attributes&40))break;}return last;}
 body(name,args,{actor,saved}){
  const w=this.world,yes=(cost=0)=>({success:true,cost}),no=()=>({success:false,cost:0}),counter=this.counter(actor);
  switch(name){
   case 'counter.create':{
    let spread=0;if(args[1]!==255){if(typeof this.absoluteRandom!=='function')throw new UnsupportedFeature('sorgente casuale del contatore NPC');spread=this.absoluteRandom(args[1],{purpose:'private-counter',actor});}
    this.counters.unshift({actor,value:(args[0]+spread)&255});return yes();
   }
   case 'counter.decrement':if(!counter)return no();counter.value=(counter.value-1)&255;if(counter.value)return yes();this.counters.splice(this.counters.indexOf(counter),1);return no();
   case 'counter.delete':if(!counter)return no();this.counters.splice(this.counters.indexOf(counter),1);return yes();
   case 'wait.tick':return yes(1);
   case 'location.save':saved[0]=w.roomOf(args[0]);return yes();
   case 'parent.save':if(w.entity(args[0]).parent===null)return no();saved[0]=w.entity(args[0]).parent;return yes();
   case 'entity.at':return w.roomOf(args[0])===args[1]?yes():no();
   case 'actor.withPlayer':return args[0]!==actor&&w.roomOf(actor)===w.roomOf(w.player)?yes():no();
   case 'entity.samePlace':return args[0]!==args[1]&&w.roomOf(args[0])===w.roomOf(args[1])?yes():no();
   case 'entity.sameContainer':return args[0]!==actor&&this.root(args[0])===this.root(actor)?yes():no();
   case 'entity.ownedAndPerceived':return w.perceived(args[0],actor)&&w.owns(actor,args[0])?yes():no();
   case 'clock.hour':{const h=Math.floor(w.minutes/60)%24,encoded=(h%12||12)+(h>=12?12:0);return encoded===args[0]?yes():no();}
   case 'balance.negative':return balance(w,actor)!==null&&balance(w,actor)<0?yes():no();
   case 'balance.positive':return balance(w,actor)!==null&&balance(w,actor)>0?yes():no();
   case 'balance.settled':return balance(w,actor)===null||balance(w,actor)===0?yes():no();
   default:throw new UnsupportedFeature('corpo della regola NPC '+name);
  }
 }
 dump(){return {version:1,counters:clone(this.counters)};}
 restore(s){if(s?.version!==1||!Array.isArray(s.counters)||s.counters.some(c=>!Number.isInteger(c.actor)||!this.world.entities[c.actor]?.person||!Number.isInteger(c.value)||c.value<0||c.value>255))throw Error('Invalid NPC counters');this.counters=clone(s.counters);}
}
