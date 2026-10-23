import {UnsupportedFeature} from './world.mjs';

const REQUEST_ACTIONS=new Set([1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,21,22,23,24,25,26,32,36,40,41,49]);
const clone=structuredClone;
// A domain state machine, not an interpreter of native instructions. The first
// reading counter is explicit historical-prompt data, not a generated seed.
export class Watson {
 constructor(game){this.game=game;}
 initialize(){
  const g=this.game,a=g.world.scheduler.actor(3);
  a.enabled=true;a.program='watson';a.due=g.startMode==='original'?1:0;
  a.behavior={profile:'historical-first-prompt-counter-15',phase:'reading',remaining:15,orders:[],follow:null};
 }
 validateState(){
  const a=this.game.world.scheduler.actor(3),b=a.behavior;
  if(!a.enabled&&!b)return;
  if(a.program!=='watson'||!b||b.profile!=='historical-first-prompt-counter-15'||!['reading','following','awaiting-random'].includes(b.phase)||!Number.isInteger(b.remaining)||b.remaining<0||b.remaining>15||!Array.isArray(b.orders))throw Error('Stato di Watson non valido.');
  if(a.enabled&&b.phase==='awaiting-random')throw Error('Sorgente casuale di Watson non disponibile.');
  if(b.follow&&(!['attempt','wait','decrement','complete'].includes(b.follow.stage)||!Number.isInteger(b.follow.target)||b.follow.target<0||b.follow.target>=110||!Number.isInteger(b.follow.remaining)||b.follow.remaining<0||b.follow.remaining>10))throw Error('Stato FOLLOW non valido.');
  for(const order of b.orders){if(!Array.isArray(order.nodes)||!Number.isInteger(order.index)||order.index<0||order.index>order.nodes.length)throw Error('Ordine pendente non valido.');this.validateRequest(order.nodes);}
  for(const request of this.game.world.scheduler.requests){if(request.recipient!==3||request.sender!==0)throw Error('Richiesta per attore non tradotto.');this.validateRequest(request.command?.nodes);}
 }
 validateRequest(nodes){
  if(!Array.isArray(nodes)||!nodes.length)throw new UnsupportedFeature('citazione senza ordine eseguibile');
  for(const n of nodes){
   if(n.subject||n.quote||n.exclusion||!REQUEST_ACTIONS.has(this.game.action(n)))throw new UnsupportedFeature('questa istruzione rivolta a Watson');
   if(n.all&&![11,14,16,23,26,36,41].includes(this.game.action(n)))throw new UnsupportedFeature('ALL in questo ordine a Watson');
  }
 }
 driver(messages,actions){return {
  prepare:actor=>{
   if(actor.id!==3)return {};
   const request=this.game.world.scheduler.takeRequest(3);
   if(request)actor.behavior.orders.unshift({nodes:request.command.nodes,index:0,allCursor:-1,priorityGreeting:Boolean(actor.behavior.follow)&&request.command.nodes.every(n=>this.game.action(n)===32)});
   return {};
  },
  step:actor=>{
   if(actor.id!==3)return {type:'blocked',feature:'programma NPC non tradotto'};
   return this.step(actor,messages,actions);
  }
 };}
 perform(node,messages,actions){
  const g=this.game,w=g.world,visibleBefore=!w.dark()&&w.perceived(3),out=g.executeAs(node,3);
  if(visibleBefore||!w.dark()&&w.perceived(3))messages.push(...out.messages.filter(m=>m.kind!=='error'));
  if(out.cost||out.action===32)actions.push({actor:3,id:out.action,arguments:out.args});
  return out;
 }
 root(id){const w=this.game.world;let root=null,e=w.entity(id);while(e.parent!==null){root=e.parent;e=w.entity(root);if(!(e.attributes&128)||!(e.attributes&40))break;}return root;}
 // Only a direct exit is tried. No invented shortest-path search or teleport.
 follow(target,messages,actions){
  const g=this.game,w=g.world,edge=w.rooms[w.roomOf(3)].exits.find(e=>e.target===w.roomOf(target)&&e.direction_id<=10);
  if(edge){const out=this.perform({verb:g.dictionary.lookup(edge.direction.toUpperCase()).value,groups:[],resolved:[]},messages,actions);if(out.cost)return {...out,moved:true};}
  if(this.root(3)===this.root(target))return {cost:1};
  if(w.entity(3).parent!==null){const out=this.perform({verb:g.dictionary.lookup('CLIMB').value,groups:[{relations:[g.dictionary.lookup('OUT').value,g.dictionary.lookup('OF').value],noun:0,qualifiers:[]}],resolved:[w.entity(3).parent]},messages,actions);if(out.cost)return {...out,containment:true};}
  const parent=w.entity(target).parent;
  if(parent!==null){const out=this.perform({verb:g.dictionary.lookup('CLIMB').value,groups:[{relations:[g.dictionary.lookup('INTO').value],noun:0,qualifiers:[]}],resolved:[parent]},messages,actions);if(out.cost)return {...out,containment:true};}
  return {cost:1};
 }
 step(actor,messages,actions){
  const g=this.game,w=g.world,b=actor.behavior;
  try{
   // A visit may run several failed/zero-cost rules before returning time.
   for(let guard=0;guard<128;guard++){
    const greeting=b.orders[0];
    if(greeting?.priorityGreeting&&b.follow?.stage!=='wait'){
     if(greeting.index>=greeting.nodes.length){b.orders.shift();continue;}
     this.perform(greeting.nodes[greeting.index++],messages,actions);continue;
    }
    if(b.follow){const f=b.follow;
     if(f.stage==='complete'){b.follow=null;continue;}
     if(f.stage==='wait'){f.stage='decrement';return {cost:1};}
     if(f.stage==='decrement'){if(--f.remaining===0){b.follow=null;continue;}f.stage='attempt';}
     const out=this.follow(f.target,messages,actions);
     f.stage=out.moved?'complete':out.containment?'wait':'decrement';return {cost:out.cost};
    }
    if(b.orders.length){
     const order=b.orders[0];if(order.index>=order.nodes.length){b.orders.shift();continue;}
     let node=order.nodes[order.index],advance=true;
     if(node.all){
      const previous=g.actingActor;g.actingActor=3;
      let candidates;try{candidates=[...g.collective(node)].filter(n=>n.resolved?.[0]>order.allCursor);}finally{g.actingActor=previous;}
      if(!candidates.length){order.index++;order.allCursor=-1;continue;}
      node=candidates[0];order.allCursor=node.resolved[0];advance=false;
     }
     const action=g.action(node);
     if(advance)order.index++;
     if(action===21||action===22){
      const previous=g.actingActor;g.actingActor=3;let result;try{result=g.resolve(node,action);}finally{g.actingActor=previous;}
      if(result.entity&&result.entity.id!==3)b.follow={target:result.entity.id,remaining:10,stage:'attempt'};
      continue;
     }
     const out=this.perform(node,messages,actions);if(out.cost)return {cost:out.cost};continue;
    }
    if(b.phase==='reading'){
     if(w.roomOf(3)!==8||!w.owns(3,25)||!w.perceived(25,3)){b.phase='following';b.remaining=0;continue;}
     if(--b.remaining>0)return {cost:1};
     // Preserve the understood prefix, then suspend exactly where a new random
     // counter would be required. Do not invent a duration or replay a trace.
     b.phase='awaiting-random';
     if(w.roomOf(0)===w.roomOf(3))messages.push({kind:'narrative',text:g.text.render('6E02',{actor:3})});
     throw new UnsupportedFeature('secondo contatore casuale di Watson: programma sospeso');
    }
    if(b.phase==='following')return {cost:this.follow(0,messages,actions).cost};
    throw new UnsupportedFeature('secondo contatore casuale di Watson: programma sospeso');
   }
   throw new UnsupportedFeature('sequenza di richieste di Watson oltre il limite');
  }catch(error){
   if(!(error instanceof UnsupportedFeature))throw error;
   actor.suspension={feature:error.feature,tick:w.tick};messages.push({kind:'system',text:error.message});return {type:'unavailable',feature:error.feature};
  }
 }
}
