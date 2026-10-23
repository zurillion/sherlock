// Functional reconstruction of the actor loop. The driver supplies understood
// game operations, never CPU instructions or native routine addresses.
export const ACTOR_ORDER=[0,2,3,4,5,6,104,7,8,9,10,11,12,13,31,34,36,37,38,39,40,41,42,43];
const copy=structuredClone;
const word=value=>Number.isInteger(value)&&value>=0&&value<=65535;

export class SchedulerLimit extends Error {}

export class ActorScheduler {
 constructor(actors=ACTOR_ORDER.map(id=>({id})),{tick=0,minutes=479,atPlayerInput=false}={}){
  this.actors=actors.map(a=>({id:a.id,due:0,savedAction:null,savedArgs:[null,null],program:null,enabled:true,...copy(a)}));
  this.tick=tick;this.minutes=minutes;this.index=0;
  this.phase=atPlayerInput?'visit':'tick';
  this.current=atPlayerInput?{actor:this.actors[0].id,context:{},steps:0}:null;
  this.service=null;this.signals=[];this.requests=[];this.trace=[];this.observer=null;
 }
 actor(id){const actor=this.actors.find(a=>a.id===id);if(!actor)throw Error('Unknown actor '+id);return actor;}
 emit(event){const entry={tick:this.tick,...event};this.trace.push(entry);if(this.trace.length>256)this.trace.shift();this.observer?.(entry);}
 requestService(service){if(!['save','load'].includes(service))throw Error('Unknown service');this.service=service;}
 sendSignal(sender,recipient){this.signals.unshift({sender,recipient});}
 consumeSignal(recipient,sender){const i=this.signals.findIndex(s=>s.sender===sender&&s.recipient===recipient);if(i<0)return false;this.signals.splice(i,1);return true;}
 sendRequest(sender,recipient,command){this.requests.unshift({sender,recipient,command:copy(command)});}
 takeRequest(recipient){const i=this.requests.findIndex(r=>r.recipient===recipient);return i<0?null:this.requests.splice(i,1)[0];}

 // A suspended input remains inside Sherlock's visit. Calling run again must
 // not prepare him twice, advance a minute or visit another actor first.
 run(driver,{maxSteps=100000,interrupt=false}={}){
  for(let guard=0;guard<maxSteps;guard++){
   if(this.phase==='tick'){
    if(this.service)return {type:'service',service:this.service};
    this.tick=(this.tick+1)&65535;this.minutes++;this.index=0;this.phase='visit';
    if(interrupt&&this.actors[0].savedAction===50){this.actors[0].due=this.tick;interrupt=false;}
    this.emit({event:'tick'});driver.clock?.(this);
   }
   if(this.index===this.actors.length){this.phase='tick';this.current=null;continue;}
   const actor=this.actors[this.index];
   if(!this.current){
    const eligible=this.tick>=actor.due;
    this.emit({event:'visit',actor:actor.id,due:actor.due,eligible});
    if(!eligible){this.index++;continue;}
    if(!actor.enabled){this.emit({event:'untranslated',actor:actor.id});this.index++;continue;}
    this.current={actor:actor.id,context:driver.prepare?.(actor,this)||{},steps:0};
   }
   const result=driver.step(actor,this.current.context,this)||{cost:0};
   if(result.type==='input'){this.emit({event:'input',actor:actor.id});return {type:'input',actor:actor.id};}
   if(result.type==='unavailable'){
    actor.enabled=false;this.emit({event:'unavailable',actor:actor.id,feature:result.feature});
    this.current=null;this.index++;continue;
   }
   if(result.type==='blocked')return {type:'blocked',actor:actor.id,feature:result.feature};
   if(!word(result.cost))throw Error('Invalid actor cost');
   this.current.steps++;this.emit({event:'step',actor:actor.id,cost:result.cost});
   if(result.cost===0)continue;
   const oldDue=actor.due;actor.due=(oldDue+result.cost)&65535;
   this.emit({event:'reschedule',actor:actor.id,old_due:oldDue,cost:result.cost,new_due:actor.due});
   // Effects are already visible in the shared world when callbacks and the
   // next actor run. No simultaneous end-of-tick commit is introduced.
   driver.callback?.(actor,this.current.context,this);
   this.emit({event:'callback',actor:actor.id});this.current=null;this.index++;
  }
  throw new SchedulerLimit('Il programma di un attore non restituisce tempo o input.');
 }

 // The current playable subset supplies shared actions and a partial Watson
 // driver. Other actors are visibly disabled, without invented WAIT scripts.
 finishPlayer(cost,clock,driver={}){
  if(!word(cost)||cost===0)throw Error('Positive action cost required');
  if(this.current?.actor!==0||this.index!==0)throw Error('Not at Sherlock input');
  let paid=false;const frames=[];
  const result=this.run({
   prepare:(actor,s)=>driver.prepare?.(actor,s)||{},
   step:(actor,context,s)=>{if(actor.id!==0)return driver.step?.(actor,context,s)||{type:'blocked',feature:'NPC program not translated'};if(paid)return {type:'input'};paid=true;return {cost};},
   clock:()=>{const frame=clock();frames.push(frame);driver.clock?.(this);},
   callback:(actor,context,s)=>driver.callback?.(actor,context,s)
  });
  if(result.type!=='input')throw Error('A non-translated actor was enabled');
  return frames;
 }
 dump(){return {version:1,actors:copy(this.actors),tick:this.tick,minutes:this.minutes,index:this.index,phase:this.phase,current:copy(this.current),service:this.service,signals:copy(this.signals),requests:copy(this.requests),trace:copy(this.trace)};}
 static load(saved){
  if(saved?.version!==1||!Array.isArray(saved.actors)||saved.actors.length!==24||saved.actors.some((a,i)=>a.id!==ACTOR_ORDER[i]||!word(a.due)||typeof a.enabled!=='boolean')||!word(saved.tick)||!Number.isSafeInteger(saved.minutes)||saved.minutes<0||!Number.isInteger(saved.index)||saved.index<0||saved.index>24||!['tick','visit'].includes(saved.phase)||!Array.isArray(saved.signals)||!Array.isArray(saved.requests)||!Array.isArray(saved.trace))throw Error('Invalid actor scheduler save');
  if(saved.current&&(saved.phase!=='visit'||saved.index>=24||saved.current.actor!==saved.actors[saved.index].id))throw Error('Invalid suspended actor');
  const scheduler=new ActorScheduler(saved.actors);for(const key of ['tick','minutes','index','phase','current','service','signals','requests','trace'])scheduler[key]=copy(saved[key]);return scheduler;
 }
}

// Domain-level initialization. This is explicitly the playable subset, not a
// captured original snapshot and not a claim to have run all NPC boot programs.
export function playerPromptScheduler(data,{tick=1,minutes=480,due=1}={}){
 const actors=ACTOR_ORDER.map(id=>({id,name:data.entities[id].name,enabled:id===0,program:id===0?'playerInput':'not-translated',due:id===0?due:0}));
 return new ActorScheduler(actors,{tick,minutes,atPlayerInput:true});
}
