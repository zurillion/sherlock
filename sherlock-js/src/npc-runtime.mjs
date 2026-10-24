import {WorldSource} from './world-source.mjs';
import {NpcProgram} from './npc-program.mjs';
import {RecordLists,RECORD_HEADS} from './record-arena.mjs';
import {NpcPrimitives} from './npc-primitives.mjs';
import {UnsupportedFeature,DIRECTION_NAMES} from './world.mjs';
import {CabRoutes,account,balance,transferMoney,formatMoney,encodeMoney,wrapMoney} from './cab-economy.mjs';

const yes=(cost=0,extra={})=>({success:true,cost,...extra}),no=()=>({success:false,cost:0});
const clone=structuredClone;

// Host for the game's DOMAIN programs. Each named rule below is a functional
// translation of its contract; source labels are provenance, not CPU dispatch.
export class NpcRuntime {
 constructor(game){this.game=game;this.active=null;this.worldSource=new WorldSource(game.data,game.world);this.routes=new CabRoutes(game.data.cab.routes);this.sourceBytes=new Map([...game.data.randomInputs.npcBytes,...game.data.randomInputs.ruleBytes]);}
 get w(){return this.game.world;}
 get state(){return this.w.npcs;}
 use(operation){
  if(this.active)return operation(this.active);
  const state=this.state,vm=new NpcProgram(this.game.data.npcPrograms,this.w.scheduler),records=RecordLists.load(state.records);
  vm.restore(state.program);const primitives=new NpcPrimitives(this.w),runtime={vm,records,primitives};this.active=runtime;
  try{return operation(runtime);}finally{state.program=vm.dump();state.records=records.dump();this.active=null;}
 }
 initialize(seed=1){
  if(!Number.isInteger(seed)||seed<0||seed>255)throw Error('Il seed deve essere un intero da 0 a 255.');
  const g=this.game,w=this.w,vm=new NpcProgram(g.data.npcPrograms,w.scheduler),records=new RecordLists();
  w.npcs={version:1,profile:'world-v5',program:null,records:records.dump(),pending:{},foreignContexts:{},playerRootSaved:[255,255,255],information:{he:Array(6).fill(0),it:Array(6).fill(0),addressee:[0x71,9,0,0,0,0]},burningNoteTicks:15,flags:{strakerMet:false,lestradeMet:false,brownClueFound:false,jonesClueFound:false,burningNoteFound:false},encounters:{2:[0,0,0],3:[30,0,0],4:[0,0],11:[0,0,0],12:[0,0,0]},literal:0};
  for(const root of g.data.npcPrograms.actors){vm.start(root.id,root.entry);const a=w.scheduler.actor(root.id);a.enabled=true;a.program='domain';a.due=0;a.behavior=null;}
  w.npcs.program=vm.dump();w.random={version:1,profile:'world-v5',seed,cursor:0,draws:0,trace:[]};g.configureRandom();
  w.npcs.facts=clone(this.worldSource.layout.facts);
  w.npcs.initialSeed=seed;
  w.npcs.recordsSourceKnown=true;
  w.tick=1;w.minutes=480;g.sourceDisplay.initialize(g.initial,{sceneTrace:g.bootstrapSceneTrace});const messages=[],actions=[];
  // The initial LOOK has consumed the player's first turn. Run the remaining
  // actor visits of that SAME tick before opening the next editor prompt.
  for(const a of w.scheduler.actors.slice(1)){
   this.prepare(a);let result;
   for(let guard=0;guard<10000;guard++){result=this.step(a,messages,actions);if(result.cost)break;if(guard===9999)throw Error('Bootstrap NPC senza costo');}
   const oldDue=a.due;a.due=(a.due+result.cost)&65535;this.callback(a,oldDue,messages);
  }
  if(g.startMode==='original'){w.tick=2;w.minutes=481;}else for(const a of w.scheduler.actors.slice(1))a.due=Math.max(0,a.due-1);
  w.playerDue=g.startMode==='original'?2:1;g.sourceDisplay.prompt();
  return messages;
 }
 prepare(actor){if(actor.id===0)return {};return this.use(({vm})=>{if(this.state.pending[actor.id]&&!this.w.scheduler.requests.some(r=>r.recipient===actor.id))this.w.scheduler.requests.unshift({sender:this.state.pending[actor.id].sender,recipient:actor.id,command:{continuation:true}});vm.prepare(actor.id);return {};});}
 driver(messages,actions){return {prepare:a=>this.prepare(a),step:a=>this.step(a,messages,actions),callback:(a,c,s,old)=>this.callback(a,old,messages)};}
 step(actor,messages,actions){return this.use(runtime=>runtime.vm.step(actor.id,this.environment(runtime,messages,actions)));}
 environment(runtime,messages,actions){const {vm,records}=runtime;return {
  enterContext:({actor,frame})=>records.prepend('contexts',[actor,parseInt(frame.origin,16)&255,parseInt(frame.origin,16)>>>8,frame.saved[1],frame.saved[2],frame.request?2:1,frame.saved[0]]),
  leaveContext:({frame})=>{const p=records.remove('contexts',frame.record);if(!this.state.recordsSourceKnown&&!p&&(records.heads.requests||records.heads.syntax))throw new UnsupportedFeature('metadati dei contesti dopo questo percorso del parser');return records.returnSaved(p);},
  foreignContext:({actor,frame})=>(this.state.foreignContexts[actor]??=[]).push(frame),
  signalSend:(sender,recipient)=>records.prepend('signals',[sender,recipient]),
  signalTake:(recipient,sender)=>{const p=records.records('signals').find(p=>records.arena.byte(p)===sender&&records.arena.byte(p+1)===recipient);if(!p)throw Error('Segnale NPC privo del record');records.remove('signals',p);},
  print:(text,c)=>this.print(text,c.actor,{object:c.saved[1],other:c.saved[2]},messages),
  // A0A8/A0AF retain two visit words; A0B0 adds its return link. CDA7
  // supplies one text argument, consumed by A66C. Its end cursor is therefore
  // the top minus those three words; A776 leaves that cursor as choice input.
  say:(text,recipient,c)=>this.print('6830',c.actor,{object:recipient,textArguments:[text],argumentContexts:[0x5D80-3*2]},messages),
  order:({actor,recipient,action,args})=>{this.recordRequest(actor,recipient,{kind:'prefabricated',action,args});this.print('682A',actor,{object:recipient,action,args},messages);},
  request:(r,c)=>this.request(r,c,messages,actions),
  rule:(name,args,c)=>this.rule(name,args,c,messages,actions),
  action:(action,args,c)=>this.action(action,args,c,messages,actions)
 };}
 print(text,actor,context,messages,{force=false}={}){
  const g=this.game,visible=force||(!this.w.dark()&&this.w.perceived(actor));
  const c=visible?g.npcTextContext(actor):{};
  if(force&&!c.sink){c.characters=[];c.sink=ch=>{c.characters.push(ch);g.sourceDisplay.feed(ch);};}
  const value=g.text.render(text,{...context,...c,actor});if(visible)messages.push(g.textMessage(value,c));return value;
 }
 recordRequest(sender,recipient,command){
  // NpcProgram has already inserted prefab requests into the typed queue.
  const request=this.w.scheduler.requests.find(r=>r.sender===sender&&r.recipient===recipient&&!r.record);
  const p=this.active.records.prepend('requests',[recipient,255,command.action,...command.args,0,0,0]);if(request)request.record=p;
 }
 queue(sender,recipient,nodes){
  this.use(({records})=>{const syntax=nodes.map(n=>this.syntaxRecord(n,records));for(let i=0;i<syntax.length;i++)records.arena.putWord(syntax[i]-2,syntax[i+1]||0);const p=records.prepend('requests',[recipient,0,0,0,0,syntax[0]&255,syntax[0]>>>8,1]);this.w.scheduler.sendRequest(sender,recipient,{nodes,syntax});this.w.scheduler.requests[0].record=p;});
 }
 syntaxRecord(node,records){const bytes=Array(30).fill(0),word=(at,v)=>{bytes[at]=v&255;bytes[at+1]=v>>>8;};word(0,node.verb|(node.all?32768:0)|(node.exclusion?16384:0));word(2,node.modifier);for(const [i,g]of node.groups.entries()){if(i>=2)break;const at=4+10*i;word(at,g.relations[0]||0);word(at+2,g.relations[1]||0);word(at+4,g.noun||0);word(at+6,g.qualifiers[0]||0);word(at+8,g.qualifiers[1]||0);}if(node.subject){word(24,node.subject.noun||0);word(26,node.subject.qualifiers[0]||0);word(28,node.subject.qualifiers[1]||0);}const p=records.arena.allocate(30);bytes.forEach((v,i)=>records.arena.putByte(p+i,v));return p;}
 parsed(node){this.use(({records})=>{const p=this.syntaxRecord(node,records),quotes=(node.quotes||[node.quote]).filter(Boolean).map(()=>records.arena.allocate(2));records.arena.release(p);for(const q of quotes)records.arena.release(q);});}
 addressee(group){if(group)this.state.information.addressee=[group.noun||0,...group.qualifiers,0,0].slice(0,3).flatMap(v=>[v&255,v>>>8&255]);}
 moved(room){this.state.lastRelocationRoom=room;}
 invalidateParserProjection(){this.state.recordsSourceKnown=false;this.game.sourceDisplay.invalidateScratch();}
 canHail(vehicle){return this.use(({vm})=>vm.state(vehicle+1).contexts.length===0);}
 hail(vehicle,customer){this.use(runtime=>{
  const s=runtime.vm.state(vehicle+1),origin=s.pc,prior=customer===this.w.player?31:runtime.vm.saved(customer)[0],frame={origin,saved:[prior,customer,vehicle],request:false,external:true,resume:origin};
  frame.record=runtime.records.prepend('contexts',[vehicle+1,parseInt(origin,16)&255,parseInt(origin,16)>>>8,customer,vehicle,2,prior]);s.contexts.push(frame);s.pc='F2B6';
 });}
 request(request,context,messages,actions){
  const state=this.state,actor=context.actor;
  let job=state.pending[actor];
  if(!job){job={sender:request.sender,record:request.record,nodes:request.command.nodes||null,syntax:request.command.syntax||[],action:request.command.action,args:request.command.args,index:0,prefab:request.command.kind==='prefabricated'};state.pending[actor]=job;}
  const release=()=>{if(job.record&&this.active.records.records('requests').includes(job.record))this.active.records.remove('requests',job.record);job.record=null;};
  const cancel=()=>{for(const p of job.syntax.slice(job.index))this.active.records.arena.release(p);release();delete state.pending[actor];};
  if(job.prefab)release();
  while(true){
   let node=job.nodes?.[job.index],action=job.action,args=job.args||[255,255];
   if(job.nodes){if(!node){delete state.pending[actor];return {handled:true,cost:0};}action=this.game.action(node);}
   if(!job.prefab&&context.restriction&&[12,13,21,22,24,25,40,49,50].includes(action)){
    this.print('681A',actor,{object:job.sender},messages);cancel();return {handled:true,cost:0};
   }
   const ctx={...context,request:true,node,sender:job.sender};
   let result;
   if(node&&![21,22,29,30,45].includes(action)){
    const out=this.game.executeAs(node,actor);this.showAction(out,actor,messages,actions);result={...yes(out.cost,{args:out.args}),success:out.cost>0||action===32};
   }else{
    if(node){args=this.resolveRequest(node,action,actor);if(!args)throw new UnsupportedFeature('risoluzione della destinazione o del destinatario di questa richiesta NPC');}
    result=this.action(action,args,ctx,messages,actions);
   }
   if(job.syntax[job.index])this.active.records.arena.release(job.syntax[job.index]);job.index++;if(!job.nodes||job.index>=job.nodes.length){release();delete state.pending[actor];}else if(job.record)this.active.records.arena.putWord(job.record+5,job.syntax[job.index]);
   if(result.defer)return result;
   if(result.cost)return {handled:true,cost:result.cost};
   if(!state.pending[actor])return {handled:true,cost:0};
  }
 }
 resolveRequest(node,action,actor){
  const groups=node.groups,w=this.w;
  if([21,22].includes(action)){const previous=this.game.actingActor;this.game.actingActor=actor;try{const resolved=this.game.resolve(node,action);return resolved.entity?[resolved.entity.id,255]:null;}finally{this.game.actingActor=previous;}}
  if([29,30].includes(action)){
   const group=groups[0];if(!group)return null;
   const rooms=w.rooms.filter(r=>r.id&&(!group.noun||r.nameWords.some(n=>(n&4095)===(group.noun&4095)))&&group.qualifiers.every(q=>r.nameWords.some(n=>(n&4095)===(q&4095))));
   return rooms.length===1?[rooms[0].id,255]:null;
  }
  if(action===45){const group=groups[0],people=w.entities.filter(e=>e.person&&w.perceived(e.id,actor)&&w.nounMatches(e,group));if(people.length!==1)return null;const location=this.resolveRequest({...node,groups:groups.slice(1)},29,actor);return location?[people[0].id,location[0]]:null;}
  return null;
 }
 select(value,kind,actor){
  const w=this.w;if(kind===0)return value;
  const valid=id=>{
   if(kind<=4){const r=w.rooms[id];if(!r)return false;if((kind===1||kind===2)&&!(r.flags&128))return false;if(kind===1||kind===3)return w.rooms[w.roomOf(actor)].exits.some(e=>e.target===id);return true;}
   if(kind===5||kind===6)return value===254;
   const e=w.entities[id];if(!e)return false;
   if(kind>=12&&!e.person)return false;
   if([8,9,10,11,13,14,15].includes(kind)&&!w.perceived(id,actor))return false;
   if(kind===10&&!w.owns(actor,id))return false;
   if(kind===11&&e.rooms.length===1)return false;
   if(kind===9&&(e.person||e.rooms.length!==1||w.owns(actor,id)||w.owns(id,actor)||w.entities.some(e=>e.person&&w.owns(e.id,id))||w.weight(id)>w.remainingCapacity(actor)))return false;
   return true;
  };
  if(value!==255)return valid(value)?value:null;
  const limit=kind<=4?w.rooms.length:w.entities.length;for(let id=0;id<limit;id++)if(valid(id))return id;return null;
 }
 bind(context,args){
  for(let i=0;i<2;i++)if(context.saved[i+1]===255)context.saved[i+1]=args[i];
  const frame=this.active.vm.state(context.actor).contexts.at(-1);if(frame?.record){const a=this.active.records.arena;a.putByte(frame.record+3,context.saved[1]);a.putByte(frame.record+4,context.saved[2]);a.putByte(frame.record+6,context.saved[0]);}
 }
 rule(name,input,context,messages,actions){
  const g=this.game,w=this.w,meta=g.data.npcPrograms.rules[name];if(!meta)throw new UnsupportedFeature('contratto NPC '+name);
  const actor=context.actor;if(meta.requiresLight&&w.dark(actor))return no();
  const candidates=(value,kind)=>{if(value!==255||kind===0){const chosen=this.select(value,kind,actor);return chosen===null?[]:[chosen];}const values=[];for(let i=0;i<(kind<=4?w.rooms.length:w.entities.length);i++)if(this.select(i,kind,actor)!==null)values.push(i);return values;};
  for(const first of candidates(input[0],meta.classes[0]))for(const second of candidates(input[1],meta.classes[1])){
   const args=[first,second];if(this.predicate(name,args,context))return this.ruleBody(name,args,context,messages,actions);
  }
  return no();
 }
 predicate(name,args,context){
  const [first,second]=args,w=this.w,actor=context.actor;
  switch(name){
   case 'counter.delete':case 'counter.decrement':return this.active.records.records('counters').some(p=>this.active.records.arena.byte(p)===actor);
   case 'entity.at':return w.roomOf(first)===second;
   case 'entity.samePlace':return first!==second&&w.roomOf(first)===w.roomOf(second);
   case 'entity.sameContainer':return first!==actor&&this.active.primitives.root(first)===this.active.primitives.root(actor);
   case 'parent.save':return w.entity(first).parent!==null;
   case 'location.exitDirection':return w.rooms[w.roomOf(actor)].exits.some(e=>e.target===first&&e.direction_id<=10);
   case 'balance.negative':return balance(w,actor)!==null&&balance(w,actor)<0;
   case 'balance.positive':return balance(w,actor)!==null&&balance(w,actor)>0;
   case 'balance.settled':return balance(w,actor)===null||balance(w,actor)===0;
   case 'cab.customerPresent':case 'cab.disembarkRemaining':return w.entity(first).parent===actor-1&&first!==actor;
   case 'money.balanceAsLiteral':return account(w,first)!==null&&balance(w,first)>=0;
   case 'money.pay':{const encoded=this.state.literal&32767,amount=(encoded&127)+(encoded>>>8)*128;return account(w,actor)!==null&&(balance(w,actor)&65535)>=amount;}
   case 'unimplemented.E452':return first!==actor;
   default:return true;
  }
 }
 ruleBody(name,args,context,messages,actions){
  const g=this.game,w=this.w,meta=g.data.npcPrograms.rules[name],actor=context.actor;
  const [first,second]=args;
  // Predicates run before allocating a deferred context or binding arguments.
  if(name==='parent.save'&&w.entity(first).parent===null)return no();
  if(name==='unimplemented.E452'&&first===actor)return no();
  if(name==='cab.disembarkRemaining'&&(w.entity(first).parent!==actor-1||first===actor))return no();
  if(name==='money.balanceAsLiteral'&&(!account(w,first)||balance(w,first)<0))return no();
  if(meta.program)return {cost:meta.cost,defer:meta.program,args};
  // Header checks precede binding, but a body may still return failure after
  // successful binding (the hour test is one such case).
  this.bind(context,args);
  let result;
  const records=this.active.records,counter=records.records('counters').find(p=>records.arena.byte(p)===actor);
  switch(name){
   case 'counter.create':{
    const p=records.prepend('counters',[actor,0]);const random=second===255?0:g.runtimeRandom.absolute(second,{actor,mixOffset:5,purpose:'private-counter'});records.arena.putByte(p+1,(first+random)&255);result=yes();break;
   }
   case 'counter.decrement':if(!counter)return no();{const n=(records.arena.byte(counter+1)-1)&255;records.arena.putByte(counter+1,n);if(!n){records.remove('counters',counter);return no();}result=yes();break;}
   case 'counter.delete':if(!counter)return no();records.remove('counters',counter);result=yes();break;
   case 'unimplemented.F198':result=first>=g.runtimeRandom.percent({actor,mixOffset:5,purpose:'probability-predicate'})?yes():no();break;
   case 'entity.relocate':this.relocate(first,second,messages);result=yes(2);break;
   case 'location.exitDirection':{const edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.target===first&&e.direction_id<=10);if(!edge)return no();context.saved[1]=edge.direction_id;result=yes();break;}
   case 'unimplemented.E4C9':{
    const travel=[2,3,4].includes(first);w.entity(actor).attributes=travel?w.entity(actor).attributes&127:w.entity(actor).attributes|128;
    if(travel)this.print('7611',actor,{},messages);this.relocate(actor,first,messages);w.rooms[first].flags&=~64;result=yes();break;
   }
   case 'unimplemented.DDBE':result=yes(first);break;
   case 'unimplemented.EBD5':context.saved[0]=(first+1)&255;result=yes();break;
   case 'unimplemented.EAF6':w.entity(second).parent=first;w.entity(second).rooms=[50];w.entity(first).rooms=[50];result=yes();break;
   case 'unimplemented.EB11':result=this.state.facts.find(f=>f.start===0x99A9).flags&2?yes():no();break;
   case 'unimplemented.EB19':result=this.state.facts.find(f=>f.start===0x9997).flags&2?yes():no();break;
   case 'unimplemented.F1F6':w.entity(first).attributes|=128;result=yes();break;
   case 'unimplemented.F203':w.entity(first).attributes&=~1;result=yes();break;
   case 'unimplemented.F210':w.entity(first).attributes|=1;result=yes();break;
   case 'cab.arrive':w.entity(actor-1).attributes|=128;this.relocate(actor-1,first,messages);result=yes();break;
   case 'cab.customerPresent':if(w.entity(first).parent!==actor-1||first===actor)return no();{const frame=this.active.vm.state(actor).contexts.at(-1);if(frame){frame.saved[1]=first;records.arena.putByte(frame.record+3,first);}result=yes();break;}
   case 'cab.warnDebtor':{const frame=this.active.vm.state(actor).contexts.at(-1);this.print('6C54',actor,{},messages,{force:frame?.saved[1]===0});result=yes();break;}
   case 'cab.demandPayment':this.demand(actor,first,second,messages);result=yes();break;
   case 'money.balanceAsLiteral':this.state.literal=encodeMoney(balance(w,first));context.saved[1]=254;result=yes();break;
   case 'money.pay':{const amount=this.state.literal&32767,pence=(amount&127)+(amount>>>8)*128;if(!transferMoney(w,actor,second,pence))return no();this.sayPayment(actor,second,pence,messages);result=yes(1);break;}
   default:result=this.active.primitives.body(name,args,context);
  }
  if(result.success)this.bind(context,args);return result;
 }
 node(action,args){
  const model=this.game.data.actions.find(a=>a.id===action);if(!model)throw new UnsupportedFeature('azione interna NPC '+action);
  const [verb,r1,r2,modifier]=model.words,lookup=v=>v?this.game.dictionary.lookup(v.toUpperCase()).value:0;
  return {verb:lookup(verb),modifier:lookup(modifier),groups:args[0]===255?[]:[{noun:0,qualifiers:[],relations:[r1,r2].filter(Boolean).map(lookup)}],resolved:args.filter(v=>v!==255),subject:null,all:false,exclusion:false,quote:null};
 }
 action(action,input,context,messages,actions){
  const actor=context.actor,w=this.w,g=this.game;
  if(action>=128&&action<153){const meta=g.data.npcPrograms.internalActions?.[action];if(!meta)throw new UnsupportedFeature('azione interna '+action);return this.rule(meta,input,context,messages,actions);}
  if([29,30].includes(action)&&[31,34].includes(actor))return this.travel(actor,input[0],action===30,messages);
  if(action===45&&[31,34].includes(actor))return {cost:0,defer:'E08F',args:input};
  if([21,22].includes(action))return {cost:0,defer:'E456',args:[input[0],255]};
  const classByAction={12:8,13:8,24:8,25:8,40:8,31:8,19:8,41:9,11:9,23:9,16:10,36:8,14:8,26:10,32:0,49:0};
  let args=input.slice();if(action===31){if(args[0]===255){const e=w.entities.find(e=>g.cab.available(e,actor));if(!e)return no();args[0]=e.id;}}
  else if(classByAction[action]!==undefined){if(args[0]===255&&classByAction[action]!==0){const previous=g.actingActor;g.actingActor=actor;try{const e=w.entities.find(e=>this.select(e.id,classByAction[action],actor)!==null&&g.canResolve(e,action,0));if(!e)return no();args[0]=e.id;}finally{g.actingActor=previous;}}else{const selected=this.select(args[0],classByAction[action],actor);if(selected===null)return no();args[0]=selected;}}
  if(action===31){const vehicle=w.entity(args[0]);if(!g.cab.available(vehicle,actor))return no();g.cab.arrive(vehicle,actor);const out={messages:[{kind:'narrative',text:w.name(actor)+' hails '+w.name(vehicle.id)+'.'}],cost:1,action,args};this.showAction(out,actor,messages,actions);this.bind(context,args);return yes(1,{args});}
  const out=g.executeAs(this.node(action,args),actor);this.showAction(out,actor,messages,actions);
  if(out.cost||action===32){this.bind(context,args);return yes(out.cost,{args});}return no();
 }
 showAction(out,actor,messages,actions){
  const visible=!this.w.dark()&&this.w.perceived(actor);if(visible){const shown=out.messages.filter(m=>m.kind==='narrative');messages.push(...shown);if(!out.projected)this.game.projectMessages(shown);}
  if(out.cost||out.action===32)actions.push({actor,id:out.action,arguments:out.args});
 }
 relocate(id,room,messages){
  const w=this.w,g=this.game,before=w.roomOf(),visible=w.perceived(id),old=w.roomOf(id);w.move(id,room);this.moved(room);
  if(before!==w.roomOf()){
   const room=w.rooms[w.roomOf()],full=!(room.flags&64),text=g.text.scene({full}),message={kind:'narrative',text,image_room:full?w.roomOf():null};room.flags|=64;messages.push(message);g.projectMessages([message]);
  }else if(old!==room&&id!==w.player&&[30,33].includes(id)&&w.perceived(id)){
   const message={kind:'narrative',text:w.name(id)+' is in '+w.roomName(room)+'.'};message.text=message.text[0].toUpperCase()+message.text.slice(1);messages.push(message);g.projectMessages([message]);
  }else if(old!==room&&w.entity(id).person&&(visible||w.perceived(id))){
   throw new UnsupportedFeature('notifica visibile di ricollocazione del personaggio '+id);
  }
 }
 travel(actor,target,furiously,messages){
  const w=this.w,vehicle=actor-1,route=this.routes.find(w.roomOf(vehicle),target,{furiously});if(!route){this.print('6C34',actor,{},messages);return yes();}
  const customer=this.active.vm.saved(actor)[1],playerBefore=w.roomOf();
  const money=account(w,actor);if(money)money.pence=wrapMoney(money.pence-route.fare);
  w.entity(vehicle).attributes&=127;this.relocate(vehicle,1,messages);w.rooms[1].flags&=~64;
  // 9B44 explicitly reloads the service customer into argument 2. CBEA has
  // an early return which leaves the current actor set to Holmes when a
  // notification cannot perceive its subject. Deferred contexts then belong
  // to Holmes, although the original actor's program pointer still advances.
  const hiddenArrival=playerBefore===1&&!w.perceived(actor);
  return {cost:route.cost,defer:'F3AD',args:[target,customer],scopeOwner:hiddenArrival?w.player:actor};
 }
 playerAction(outcome){this.use(({records})=>{const saved=[outcome.action,outcome.args?.[0]??255,outcome.args?.[1]??255],frame=this.state.foreignContexts[this.w.player]?.at(-1);if(frame){frame.saved=saved;records.arena.putByte(frame.record+3,saved[1]);records.arena.putByte(frame.record+4,saved[2]);records.arena.putByte(frame.record+6,saved[0]);}else this.state.playerRootSaved=saved;});}
 demand(actor,recipient,owner,messages){
  const amount=balance(this.w,owner);if(amount===null)return;
  const g=this.game,visible=!this.w.dark()&&this.w.perceived(actor),c=visible?g.npcTextContext(actor):{};
  const prefix=g.text.render('6BB7',{...c,actor,object:recipient,other:owner});const suffix=' '+formatMoney((-amount)&16383)+' "\n';if(c.sink)for(const ch of suffix)c.sink(ch);
  if(visible)messages.push(g.textMessage(prefix+' '+suffix.trim(),c));
 }
 sayPayment(actor,recipient,pence,messages){const w=this.w,amount=formatMoney(pence),text=w.name(actor)+' pays '+amount+(amount.endsWith('.')?' To ':' to ')+(recipient===w.player?'you':w.name(recipient))+'.';if(!w.dark()&&w.perceived(actor)){const message={kind:'narrative',text:text[0].toUpperCase()+text.slice(1)};messages.push(message);this.game.projectMessages([message]);}}
 callback(actor,oldDue,messages){
  const id=actor.id,w=this.w;
  if(id===6){const e=w.entity(85);if(e.attributes&128&&this.state.burningNoteTicks!==255){this.state.burningNoteTicks=(this.state.burningNoteTicks-1)&255;if(!this.state.burningNoteTicks){e.qualifiers[0]=0x15B;e.name='burnt note';e.description=null;const fact=this.state.facts.find(f=>f.start===0x99A9);fact.terms[5]&=~0x0200;}}return;}
  if([5,8,9].includes(id)&&Math.floor(w.minutes/60)%24===21)throw new UnsupportedFeature('reazione serale del personaggio '+id);
  if(![2,3,4,11,12].includes(id))return;
  this.use(()=>{
   const counters=this.state.encounters[id],near=target=>w.roomOf(target)===w.roomOf(id)&&w.perceived(target,id);
   const encounter=(target,i,offset,text='6929',permanent=false)=>{
    if(!near(target)){counters[i]=Math.max(0,counters[i]-1);return;}
    if(counters[i])return;counters[i]=30+this.game.runtimeRandom.absolute(15,{actor:id,mixOffset:offset,purpose:'encounter:'+target});if(permanent)counters[i]=1;if(text)this.print(text,id,{object:target},messages);
   };
   if(id===3){for(const [i,target] of [0,2,4].entries())encounter(target,i,i===0?oldDue:0x9CEC);const ctx={actor:3,mixOffset:0x9CEC,purpose:'watson-information'};if(this.game.runtimeRandom.percent(ctx)>=50)this.game.runtimeRandom.percent(ctx);return;}
   if(id===11||id===12){if(!this.state.flags.strakerMet)for(const [i,target]of[0,3,7].entries())encounter(target,i,i===0?oldDue:0x9CEC,'6D9A',true);return;}
   if(id===4){if(this.state.flags.strakerMet){encounter(0,0,oldDue);encounter(3,1,0x9CEC);}return;}
   if(id===2){
    if(near(4)&&near(0)&&!this.state.flags.strakerMet){this.state.flags.strakerMet=true;counters[0]=1;for(const room of [62,92])w.rooms[room].exits[0].gate=0;this.print(this.state.flags.lestradeMet?'7207':'7224',2,{object:4},messages);this.state.flags.lestradeMet=true;return;}
    if(near(0)&&!this.state.flags.lestradeMet){encounter(0,0,oldDue,'71ED');this.state.flags.lestradeMet=true;}else encounter(0,0,oldDue);
    encounter(0,1,oldDue,null,true);
    encounter(3,2,0x9CEC);
    for(const at of [0x99E3,0x99F1,0x99A9])this.state.facts.find(f=>f.start===at).flags&=~1;
   }
  });
 }
 read(address){const worldValue=this.worldSource.read(address);if(worldValue!==null)return worldValue;
  const fact=this.state.facts.find(f=>address>=f.start&&address<f.start+6+2*f.terms.length);if(fact){const bytes=[fact.subject,fact.predicate,fact.object,fact.flags,fact.handler&255,fact.handler>>>8,...fact.terms.flatMap(v=>[v&255,v>>>8])];return bytes[address-fact.start];}
  if(address>=0x9FF6&&address<0xA002)return [...this.state.information.he,...this.state.information.it][address-0x9FF6];
  if(address>=0xA002&&address<0xA008)return this.state.information.addressee[address-0xA002];
  if(address>=0xDCFF&&address<=0xDD02){const room=this.state.lastRelocationRoom,ptr=room===undefined?0:this.worldSource.layout.rooms.find(r=>r.id===room).start;return [ptr&255,ptr>>>8,room??0,0][address-0xDCFF];}
  if(address>=0x9FDD&&address<=0x9FE2){const c=this.w.clock();return [c.tick&255,c.tick>>>8,c.minute,c.hour,c.day,c.period==='am'?97:112][address-0x9FDD];}
  if(address===0xA036)return this.game.runtimeRandom.inFlight?.actor??null;
  if(address===0xA037)return this.w.random.seed;
  if(address===0xA039||address===0xA03A){const cursor=this.game.runtimeRandom.inFlight?.cursor??this.w.random.cursor;return address===0xA039?cursor&255:cursor>>>8;}
  if(address>=0x9C85&&address<0x9CA1){const callbacks=[[2,this.state.flags.strakerMet?0x9D95:0x9DFF],[3,0x9D13],[4,0x9D30],[11,0x9D48],[12,0x9D73],[8,0x9ED1],[9,0x9ECB],[5,0x9EC1],[6,0x9CA2]];return [...callbacks.flatMap(([id,at])=>[id,at&255,at>>>8]),255][address-0x9C85];}
  if(address===0x9CA1)return this.state.burningNoteTicks;
  const head=Object.entries(RECORD_HEADS).find(([,at])=>address===at||address===at+1);if(head||address===0x9FE3||address===0x9FE4)return this.state.recordsSourceKnown?this.use(({records})=>{const value=head?records.heads[head[0]]:records.arena.freeHead,at=head?head[1]:0x9FE3;return address===at?value&255:value>>>8;}):null;
  if(address>=0x9860&&address<0x9920){const index=Math.floor((address-0x9860)/8),a=this.w.scheduler.actors[index],s=a.id===0?{pc:'9923',saved:this.state.playerRootSaved}:this.active?.vm.state(a.id)||this.state.program.states[a.id],pc=parseInt(s.pc,16);return [a.id,pc&255,pc>>>8,...s.saved,a.due&255,a.due>>>8][(address-0x9860)%8];}
  const encounterCells={0x9D92:this.state.encounters[2][0],0x9D93:this.state.encounters[2][2],0x9D94:this.state.encounters[2][1]};for(const [id,start]of[[3,0x9D10],[4,0x9D2E],[11,0x9D45],[12,0x9D70]])for(const [i,v]of this.state.encounters[id].entries())encounterCells[start+i]=v;if(address in encounterCells)return encounterCells[address];
  if(address===0x9D90)return Number(this.state.flags.strakerMet);if(address===0x9D91)return Number(this.state.flags.lestradeMet);
  if(address===0x5C00)return 255; // ROM KSTATE: no key held in the injected-key protocol.
  if(!(address>=0x9570&&address<0x9860)&&!this.sourceBytes.has(address))return null;return this.use(({vm,records})=>{
  if(address>=records.arena.base&&address<records.arena.base+records.arena.bytes.length)return this.state.recordsSourceKnown?records.arena.byte(address):null;
  if(this.sourceBytes.has(address)){if(vm.erased.includes(address.toString(16).toUpperCase()))return 0;return this.sourceBytes.get(address);}
  return null;
 });}
 validate(){
  const s=this.state,byte=v=>Number.isInteger(v)&&v>=0&&v<=255,triple=v=>Array.isArray(v)&&v.length===3&&v.every(byte);
  if(s?.version!==1||s.profile!=='world-v5'||this.w.random?.profile!=='world-v5'||!byte(s.initialSeed)||typeof s.recordsSourceKnown!=='boolean'||!triple(s.playerRootSaved)||!s.pending||!s.foreignContexts||!s.flags||Object.values(s.flags).some(v=>typeof v!=='boolean')||!byte(s.burningNoteTicks))throw Error('Stato NPC v5 non valido');
  for(const [id,n]of[[2,3],[3,3],[4,2],[11,3],[12,3]])if(!Array.isArray(s.encounters?.[id])||s.encounters[id].length!==n||!s.encounters[id].every(byte))throw Error('Contatori incontri NPC non validi');
  for(const k of ['he','it','addressee'])if(!Array.isArray(s.information?.[k])||s.information[k].length!==6||!s.information[k].every(byte))throw Error('Contesto informazioni non valido');
  if(!Array.isArray(s.facts)||s.facts.length!==this.worldSource.layout.facts.length)throw Error('Record informazioni mancanti');
  for(const [i,f]of s.facts.entries())if(f.start!==this.worldSource.layout.facts[i].start||![f.subject,f.predicate,f.object,f.flags].every(byte)||!Number.isInteger(f.handler)||f.handler<0||f.handler>65535||!Array.isArray(f.terms)||f.terms.length!==this.worldSource.layout.facts[i].terms.length||f.terms.some(v=>!Number.isInteger(v)||v<0||v>65535))throw Error('Record informazioni non valido');
  this.use(({vm,records})=>{
   if(records.arena.base!==0x9570||records.arena.bytes.length!==752||Object.keys(vm.states).length!==23)throw Error('Archivio dei programmi NPC non valido');
   for(const root of this.game.data.npcPrograms.actors){const state=vm.state(root.id),a=this.w.scheduler.actor(root.id);if(!a.enabled||a.program!=='domain')throw Error('Attore NPC v5 disabilitato');vm.node(state.pc);for(const frame of state.contexts)if(!records.records('contexts').includes(frame.record))throw Error('Contesto sospeso privo del record');}
   for(const [id,job]of Object.entries(s.pending)){vm.state(Number(id));if(!Array.isArray(job.syntax)||!Number.isInteger(job.index)||job.index<0||job.nodes&&job.index>=job.nodes.length)throw Error('Richiesta pendente non valida');}
   for(const frames of Object.values(s.foreignContexts)){if(!Array.isArray(frames))throw Error('Contesti esterni non validi');for(const frame of frames)if(!triple(frame.saved)||!records.records('contexts').includes(frame.record))throw Error('Contesto esterno privo del record');}
  });
 }
}
