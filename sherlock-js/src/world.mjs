import {ActorScheduler,playerPromptScheduler} from './scheduler.mjs';
export const DIRECTION_NAMES=['','north','south','east','west','northeast','northwest','southeast','southwest','up','down'];
export const joinList=items=>items.length<2?(items[0]||''):items.length===2?items.join(' and '):items.slice(0,-1).join(', ')+' and '+items.at(-1);
export class UnsupportedFeature extends Error {
 constructor(feature){super('Funzione non ancora ricostruita in JavaScript: '+feature);this.feature=feature;}
}

export class World {
 constructor(data){this.data=data;this.reset();}
 reset(){this.entities=structuredClone(this.data.entities);this.rooms=structuredClone(this.data.rooms);this.player=0;this.explored=new Set([8]);this.lastListed=[];this.random=null;this.display=null;this.npcs=null;this.scheduler=playerPromptScheduler(this.data);}
 get tick(){return this.scheduler.tick;}set tick(value){this.scheduler.tick=value;}
 get minutes(){return this.scheduler.minutes;}set minutes(value){this.scheduler.minutes=value;}
 get playerDue(){return this.scheduler.actors[0].due;}set playerDue(value){this.scheduler.actors[0].due=value;}
 entity(id){const e=this.entities[id];if(!e)throw Error('Unknown entity');return e;}
 roomOf(id=this.player){return this.entity(id).rooms[0];}
 owns(owner,id){const seen=new Set();for(let p=this.entity(id).parent;p!==null;p=this.entity(p).parent){if(p===owner)return true;if(seen.has(p))throw Error('Containment cycle');seen.add(p);}return false;}
 barrier(id){const seen=new Set();let object=this.entity(id);while(object.parent!==null){const p=object.parent;if(seen.has(p))throw Error('Containment cycle');seen.add(p);object=this.entity(p);if(!(object.attributes&128)||!(object.attributes&40))return p;}return null;}
 perceived(id,actor=this.player){
  const a=this.barrier(actor);if(a===id)return true;const e=this.entity(id);if(!(e.attributes&128))return false;
  const b=this.barrier(id);if(b===actor)return true;if(b!==a)return false;if(b!==null)return true;return e.rooms.includes(this.roomOf(actor));
 }
 timeClass(){const hour=Math.floor(this.minutes/60)%24;if(hour>=20||hour<6)return 1;if(hour===19)return 2;if(hour===12)return 4;if(hour>=13)return 3;if(hour===6)return 5;return 4;}
 dark(actor=this.player){
  const a=this.entity(actor);if(!(a.properties&128))return false;
  if(this.barrier(actor)===null&&((this.rooms[this.roomOf(actor)].flags&128)||this.timeClass()!==1))return false;
  return !this.entities.some(e=>e.rooms.length===1&&((e.attributes^183)&92)===0&&(e.properties&128)&&this.perceived(e.id,actor));
 }
 move(id,room,parent=null){
  if(parent===id||(parent!==null&&this.owns(id,parent)))throw Error('Containment cycle');
  this.entity(id).parent=parent;this.entity(id).rooms=[room];
  const pending=[id],seen=new Set();while(pending.length){const p=pending.pop();if(seen.has(p))throw Error('Containment cycle');seen.add(p);for(const e of this.entities)if(e.parent===p){e.rooms=[room];pending.push(e.id);}}
 }
 contentsWeight(id){
  // D305 begins enumeration after entry zero, even in recursive scans.
  const visit=(parent,total)=>{for(const child of this.entities)if(child.id!==0&&child.parent===parent){const sum=(total+child.weight)&255;if(!((total^child.weight)&128)&&((total^sum)&128))return 255;total=visit(child.id,sum);}return total;};
  return visit(id,0);
 }
 weight(id){return Math.min(255,this.entity(id).weight+this.contentsWeight(id));}
 remainingCapacity(id){return (this.entity(id).weight-this.contentsWeight(id))&255;}
 nounMatches(e,group){
  const names=[e.noun,...e.qualifiers].filter(Boolean).map(x=>x&4095),q=group.qualifiers.map(x=>x&4095);
  return (!group.noun||names.includes(group.noun&4095))&&q.every(id=>names.includes(id));
 }
 name(id,{indefinite=false,proper=true}={}){
  const e=this.entity(id);let name=e.name;
  // A7D0–A7E9: YOU has a proper-name bit but remains lowercase inline.
  if(e.person&&proper&&(e.noun&32768)&&(e.noun&4095)!==0x09EE)name=name.replace(/\b\w/g,c=>c.toUpperCase());
  if(e.noun&32768)return name;
  const article=({0:'the ',4096:'a ',8192:'an ',12288:'some '})[e.noun&12288];
  return (indefinite?article:'the ')+name;
 }
 roomName(id,{indefinite=true,short=false}={}){
  const room=this.rooms[id],word=value=>this.data.dictionary.find(w=>w.id===(value&4095)),name=[...(short?[]:room.nameWords.slice(1).filter(Boolean).map(v=>word(v).form)),word(room.nameWords[0])?.stem].filter(Boolean).join(' ');
  if(room.nameWords[0]&32768)return this.player===0&&/^your\b/.test(name)?name:name.replace(/\b\w/g,c=>c.toUpperCase());
  return indefinite?(({0:'the ',4096:'a ',8192:'an ',12288:'some '})[room.nameWords[0]&12288])+name:name;
 }
 clock(){const day=Math.floor(this.minutes/1440)&255,minute=this.minutes%60,h=Math.floor(this.minutes/60)%24,hour=h%12||12,period=h<12?'am':'pm';return {tick:this.tick,due:this.playerDue,day,minute,hour,period,label:`${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][day%7]} ${String(hour).padStart(2,'0')}:${String(minute).padStart(2,'0')}${period}`};}
 consume(cost,{action=null,args=[],driver={}}={}){
  if(!cost)return [];
  const actor=this.scheduler.actors[0];actor.savedAction=action;actor.savedArgs=structuredClone(args);
  return this.scheduler.finishPlayer(cost,()=>this.clock(),driver);
 }
 dump(){return {entities:structuredClone(this.entities),rooms:structuredClone(this.rooms),player:this.player,explored:[...this.explored],lastListed:[...this.lastListed],tick:this.tick,playerDue:this.playerDue,minutes:this.minutes,scheduler:this.scheduler.dump(),random:structuredClone(this.random),display:structuredClone(this.display),npcs:structuredClone(this.npcs)};}
 restore(state){
  this.entities=structuredClone(state.entities);this.rooms=structuredClone(state.rooms);this.player=state.player;this.explored=new Set(state.explored);this.lastListed=[...state.lastListed];
  this.scheduler=state.scheduler?ActorScheduler.load(state.scheduler):playerPromptScheduler(this.data,{tick:state.tick,minutes:state.minutes,due:state.playerDue});
  this.random=structuredClone(state.random??null);
  this.display=structuredClone(state.display??null);
  this.npcs=structuredClone(state.npcs??null);
  if(this.tick!==state.tick||this.minutes!==state.minutes||this.playerDue!==state.playerDue)throw Error('Inconsistent scheduler clock');
 }
}
