import {Dictionary,Lexer,InputError,normalizeInput} from './lexer.mjs';
import {Parser} from './parser.mjs';
import {World,UnsupportedFeature,joinList,DIRECTION_NAMES} from './world.mjs';
import {Text} from './text.mjs';
import {Watson} from './watson.mjs';
import {Cab} from './cab.mjs';
import {Conversation} from './conversation.mjs';
import {transferMoney,decodeMoney,formatMoney} from './cab-economy.mjs';
import {RuntimeRandom} from './runtime-random.mjs';
import {RandomInputsUnavailable} from './random.mjs';
import {RandomDisplay} from './random-display.mjs';

export const SUPPORTED_ACTIONS=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,23,24,25,26,27,28,31,32,33,34,35,36,37,40,41,46,47,48,49,50];
const clone=structuredClone;
// Rules are domain functions over logical objects. No binary, RAM, CPU, address
// dispatcher, server-side game logic, or fallback to the reference engine.
export class Game {
 constructor(data,{start_mode='free',npcs=true,npc_random=true}={}){
  this.data=data;this.dictionary=new Dictionary(data.dictionary);this.lexer=new Lexer(this.dictionary);this.parser=new Parser(this.lexer);this.world=new World(data);this.text=new Text(data,this.dictionary,this.world);
  this.startMode=start_mode;this.pending=null;this.analysis=null;this.lastInput=null;this.ended=null;this.openingPending=true;this.conversation=null;
  if(start_mode==='original'){this.world.tick=2;this.world.minutes++;}
  this.sourceDisplay=new RandomDisplay(data,this.world);this.runtimeRandom=new RuntimeRandom(data,this.world);this.runtimeRandom.display=this.sourceDisplay;if(npcs&&npc_random)this.runtimeRandom.initialize();this.configureRandom();
  this.cab=new Cab(this);this.watson=new Watson(this);this.dialogue=new Conversation(data,this.text);if(npcs)this.watson.initialize();
  this.initial=this.text.scene();this.opening=this.initial+'\n'+this.text.render('6DEB');
  if(this.world.random)this.sourceDisplay.initialize(this.opening);
 }
 configureRandom(){this.text.chooseIndex=this.world.random?(count,ctx)=>this.runtimeRandom.chooseIndex(count,{...ctx,purpose:'text:'+ctx.fragment}):undefined;}
 npcTextContext(actor){if(!this.world.display||this.world.dark()||!this.world.perceived(actor))return {};const characters=[];return {characters,sink:c=>{characters.push(c);this.sourceDisplay.feed(c);}};}
 textMessage(text,context){return {kind:'narrative',text,...(context.characters?{raw_text:context.characters.join('')}: {})};}
 projectMessages(messages){if(this.world.display)for(const m of messages)if(m.kind==='narrative')this.sourceDisplay.write(m.text,{leading:Boolean(m.paragraph_before)});}
 word(id){return this.dictionary.word(id)?.stem||'';}
 queryName(group){return [...group.qualifiers,group.noun].filter(Boolean).map(id=>this.word(id)).join(' ')||'anything';}
 action(node){
  const verb=this.word(node.verb),modifier=this.word(node.modifier),relations=node.groups.flatMap(g=>g.relations).map(id=>this.word(id));
  if(verb==='sit'&&!relations.length)return 40;
  if(['get','climb'].includes(verb)&&relations.join(' ')==='out')return verb==='get'?25:13;
  if(DIRECTION_NAMES.includes(verb)&&verb)return DIRECTION_NAMES.indexOf(verb);
  return this.data.actions.find(a=>a.words[0]===verb&&JSON.stringify(a.words.slice(1,3).filter(Boolean))===JSON.stringify(relations)&&(a.words[3]||'')===modifier)?.id
    ||(verb==='wait'&&relations.length===0?49:0);
 }
 get actor(){return this.actingActor??this.world.player;}
 canTake(e){const w=this.world,actor=this.actor;return w.perceived(e.id,actor)&&e.rooms.length===1&&!e.person&&!w.owns(actor,e.id)&&!w.owns(e.id,actor)&&w.weight(e.id)<=w.remainingCapacity(actor)&&!w.entities.some(p=>p.person&&w.owns(p.id,e.id));}
 canResolve(e,action,slot){
  const w=this.world,actor=this.actor;if(!w.perceived(e.id,actor))return false;
  if(action===36||action===14)return e.rules.some(r=>r.action===action);
  if([11,23,41].includes(action))return this.canTake(e);
  if(action===26)return slot===0?w.owns(actor,e.id):e.person;
  if(action===16)return w.owns(actor,e.id);
  if([12,24,40].includes(action))return e.rules.some(r=>r.action===action);
  if([13,25].includes(action))return w.entity(actor).parent===e.id;
  if(action===46)return e.person&&e.id!==actor;
  if([37,47,48].includes(action))return e.person;
  return true;
 }
 error(text){return {kind:'error',text};}
 resolve(node,action,slot=0){
  if(node.resolved?.[slot]!==undefined)return {entity:this.world.entity(node.resolved[slot])};
  const w=this.world,group=node.groups[slot]||{noun:0,qualifiers:[],relations:[]};
  if(!group.noun&&!group.qualifiers.length){return {message:this.error(`${this.word(node.verb).toUpperCase()} WHAT ?`)};}
  const nominal=w.entities.filter(e=>w.nounMatches(e,group)),possible=nominal.filter(e=>this.canResolve(e,action,slot));
  if(possible.length>1){this.pending={node:clone(node),slot};return {message:this.error(`WHICH ${this.word(group.noun).toUpperCase()||'ONE'} ?`)};}
  if(possible.length===1)return {entity:possible[0]};
  const query=this.queryName(group).toUpperCase(),verb=this.word(node.verb).toUpperCase();
  if([12,13,24,25,40,46].includes(action))return {message:this.error(`I SEE NO ${query} THAT YOU CAN ${[verb,...(this.data.actions.find(a=>a.id===action)?.words.slice(1,3).filter(Boolean)||[])].join(' ').toUpperCase()}`)};
  if(nominal.length>1)return {message:this.error(`I SEE NO ${query} THAT YOU CAN ${verb}`)};
  if([11,23,41].includes(action)&&nominal.length===1&&w.perceived(nominal[0].id)&&w.entities.some(p=>p.person&&p.id!==w.player&&w.owns(p.id,nominal[0].id)))return {message:this.error(`YOU CANNOT TAKE ${w.name(nominal[0].id).toUpperCase()}.`)};
  return {message:this.error(`YOU CANNOT ${verb} THE ${query}`)};
 }
 executeAs(node,actor){const previous=this.actingActor,pending=this.pending;this.actingActor=actor;try{return this.execute(node);}finally{this.actingActor=previous;this.pending=pending;}}
 execute(node){
  const w=this.world,action=this.action(node),actor=this.actor,subject=actor===w.player?'You':w.name(actor),verb=(base,third=base+'s')=>actor===w.player?base:third,say=(base,tail,third)=>`${subject} ${verb(base,third)}${tail}`,narrative=text=>({kind:'narrative',text}),ok=(messages,cost=1,args=[])=>({messages:messages.map(m=>typeof m==='string'?narrative(m):m),cost,action,args}),reject=text=>({messages:[this.error(text)],cost:0,action,args:[]});
  if(node.all||node.exclusion)throw new UnsupportedFeature('questa forma di ALL/EXCEPT');
  if(node.subject)throw new UnsupportedFeature('asserzioni, informazioni e deduzioni');
  if(node.quote){
   for(const quote of node.quotes||[node.quote])try{this.parser.quoted(quote);}catch(error){if(error instanceof InputError)throw new InputError('quoted_syntax_error','WHAT ?');throw error;}
   if(action!==46)throw new UnsupportedFeature('citazioni per questa forma di conversazione');
  }
  if(!action){if(this.word(node.verb)==='pay')throw new UnsupportedFeature('forma PAY senza TO e relativo passaggio al turno seguente');return reject(`I DO NOT KNOW THE VERB"${this.word(node.verb).toUpperCase()} "`);}
  if(!SUPPORTED_ACTIONS.includes(action))throw new UnsupportedFeature(`azione ${action} (${this.word(node.verb)})`);
  if(w.dark(actor)&&![33,49,50].includes(action))return reject('SORRY IT IS TOO DARK.');
  if(action===34){const scene=this.text.scene();return ok([{kind:'narrative',text:scene,image_room:w.roomOf()}]);}
  if(action===33){const items=w.entities.filter(e=>e.parent===actor).map(e=>w.name(e.id,{indefinite:true}));return ok(['You are carrying '+(items.length?joinList(items):'nothing')+'.']);}
  if(action===32){if(actor===w.player)return ok([this.error(this.text.render('6915').toUpperCase())],0);const context=this.npcTextContext(actor),out=ok([this.textMessage(this.text.greeting(actor,context),context)],0);out.projected=Boolean(context.sink);return out;}
  if(action===37){
   const literal=node.groups[0]?.noun;
   if(!(literal&32768)||!(literal&128))return reject("DON'T BE SILLY.");
   const group=node.groups[1];
   if(group){const nominal=w.entities.filter(e=>w.nounMatches(e,group));if(nominal.length&&!nominal.some(e=>e.person))return reject("DON'T BE SILLY.");}
   const target=this.resolve(node,action,1);if(target.message)return {messages:[target.message],cost:0,action,args:[]};
   const pence=decodeMoney(literal&32767);
   // The normal semantic preflight reports the generic refusal here; the
   // E36A "not enough" routine is not the visible player-command result.
   if(!transferMoney(w,actor,target.entity.id,pence))return reject("DON'T BE SILLY.");
   const amount=formatMoney(pence);
   return ok([say('pay',' '+amount+(amount.endsWith('.')?' To ':' to ')+w.name(target.entity.id)+'.','pays')],1,[254,target.entity.id]);
  }
  if(action===47||action===48){
   const target=this.resolve(node,action);if(target.message)return {messages:[target.message],cost:0,action,args:[]};
   const group=node.groups[1];
   // Class 7 deliberately includes off-stage people and things, independently
   // of visibility; perceived recipient is checked separately by class D.
   const topics=group?w.entities.filter(e=>w.nounMatches(e,group)):[];
   if(topics.length!==1)throw new UnsupportedFeature('risoluzione del soggetto TELL: zero o più riferimenti');
   const context=this.npcTextContext(actor);
   const out=ok([this.textMessage(this.dialogue.tell(actor,target.entity.id,topics[0].id,context),context)],1,[target.entity.id,topics[0].id]);out.projected=Boolean(context.sink);out.suppressParagraph=true;return out;
  }
  if(action===49)return ok([say('wait','.')],5);
  if(action===50){const literal=node.groups[0]?.noun;if(!(literal&32768)||literal&128)return reject('WAIT UNTIL WHAT ?');const hour=(literal>>>8)&63,minute=literal&63;if(hour<1||hour>12)return reject('YOU CANNOT WAIT UNTIL THAT TIME.');let target=(hour%12)*60+minute;
   if(literal&16384){}else if(literal&64)target+=720;else if(Math.floor(w.minutes/720)%2)target+=720;
   let absolute=Math.floor(w.minutes/1440)*1440+target;if(absolute<=w.minutes)absolute+=(literal&16448)?1440:720;
   return ok(['You wait.'],absolute-w.minutes,[{hour,minute}]);
  }
  if(action===31){
   const group=node.groups[0]||{noun:0,qualifiers:[]};if(!group.noun&&!group.qualifiers.length)return reject('HAIL WHAT ?');
   const nominal=w.entities.filter(e=>w.nounMatches(e,group)),vehicle=nominal.find(e=>this.cab.available(e,actor));
   if(!vehicle)return reject(!this.cab.isStreet(w.roomOf(actor))&&nominal.some(e=>e.rules.some(r=>r.rule==='hailCab'))?'YOU CANNOT HAIL THE '+this.queryName(group).toUpperCase():'I SEE NO '+this.queryName(group).toUpperCase()+' THAT YOU CAN HAIL');
   this.cab.arrive(vehicle,actor);return ok([say('hail',' '+w.name(vehicle.id)+'.')],1,[vehicle.id]);
  }
  if(action===46){
   const target=this.resolve(node,action);if(target.message)return {messages:[target.message],cost:0,action,args:[]};
   if(target.entity.id!==3||!w.scheduler.actor(3).enabled)throw new UnsupportedFeature('programma e conversazione di '+target.entity.name);
   if(node.quote){
    const commands=(node.quotes||[node.quote]).flatMap(q=>this.parser.quoted(q).nodes);
    if(commands.some(n=>n.subject))throw new UnsupportedFeature('affermazioni e memoria di Watson');
    this.watson.validateRequest(commands);
    if(commands.some(n=>this.action(n)===32)&&!w.random)throw new UnsupportedFeature('saluto di Watson: questa partita precedente non conserva lo stato casuale; salva e usa Riavvia');
    if(commands.some(n=>[47,48].includes(this.action(n)))&&!this.text.chooseIndex)throw new UnsupportedFeature('risposta TELL: selezione originale di says/remarks e stato casuale globale');
    if(w.scheduler.actor(3).behavior.follow&&!commands.every(n=>this.action(n)===32))throw new UnsupportedFeature('nuovi ordini durante il FOLLOW differito di Watson');
    w.scheduler.sendRequest(actor,3,{nodes:commands});
   }
   return ok([say('talk',' to '+w.name(target.entity.id)+'.')],1,[target.entity.id]);
  }
  if([12,13,24,25,40].includes(action)){
   if([13,25].includes(action)&&!node.groups[0]?.noun&&!node.groups[0]?.qualifiers.length&&w.entity(actor).parent!==null)node={...node,resolved:[w.entity(actor).parent]};
   const result=this.resolve(node,action);if(result.message)return {messages:[result.message],cost:0,action,args:[]};
   const e=result.entity,exiting=[13,25].includes(action),rule=e.rules.find(r=>r.action===action);
   if(!['enterContainer','enterCab','leaveContainer'].includes(rule?.rule))throw new UnsupportedFeature('regola contenitore di '+e.name);
   if(exiting){
    if(w.entity(actor).parent!==e.id)return reject('YOU CANNOT GET OUT OF '+w.name(e.id).toUpperCase());
    w.move(actor,w.roomOf(actor),e.parent);return ok([say(this.word(node.verb),' out of '+w.name(e.id)+'.')],2,[e.id]);
   }
   if(w.entity(actor).parent!==null||w.owns(actor,e.id)||e.size<w.entity(actor).size||(rule.rule!=='enterCab'&&w.weight(actor)>w.remainingCapacity(e.id)))return reject('YOU CANNOT GET INTO '+w.name(e.id).toUpperCase());
   w.move(actor,w.roomOf(actor),e.id);return ok([say(this.word(node.verb),(action===40?' in ':' into ')+w.name(e.id)+'.')],2,[e.id]);
  }
  if(action<=10||[18,27,28,35].includes(action)){
   let edge,direction=action;
   if(action<=10)edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.direction_id===action);
   else if(action===18||action===27){const group=node.groups[0]||{noun:0,qualifiers:[]};edge=w.rooms[w.roomOf(actor)].exits.find(e=>{const r=w.rooms[e.target],ids=r?.nameWords.map(n=>n&4095)||[];return (!group.noun||ids.includes(group.noun&4095))&&group.qualifiers.every(q=>ids.includes(q&4095));});direction=edge?.direction_id;}
   else{const result=this.resolve(node,action);if(result.message)return {messages:[result.message],cost:0,action,args:[]};edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.gate===result.entity.id);direction=edge?.direction_id;}
   const gate=edge?.gate?w.entity(edge.gate):null;
   const failure=()=>action===35?reject(`YOU CANNOT LOOK THROUGH ${gate?w.name(gate.id).toUpperCase():'THAT'}.`):reject(`YOU CANNOT GO ${DIRECTION_NAMES[direction||action]?.toUpperCase()||'THAT WAY'}.`);
   if(!edge||!edge.target||w.entity(actor).parent!==null||(gate&&(!(gate.attributes&40)||gate.size<w.entity(actor).size)))return failure();
   if(action===35){const saved=w.dump();w.move(actor,edge.target);let scene;try{scene=this.text.scene({full:false,remote:true,mark:false});}finally{w.restore(saved);}return ok([`You look through ${w.name(gate.id)}.\n${scene}`],2,[gate.id]);}
   const room=edge.target,first=!(w.rooms[room].flags&64),visibleBefore=w.perceived(actor);w.move(actor,room);
   if(actor!==w.player){const visibleAfter=w.perceived(actor);return ok(visibleAfter?[`${w.name(actor)} enters.`]:visibleBefore?[`${w.name(actor)} leaves.`]:[],2,[]);}
   w.rooms[room].flags|=64;w.explored.add(room);
   const movement=action===28?`You go through ${w.name(gate.id)}.`:`You go ${DIRECTION_NAMES[direction]}.`;
   return ok([movement,{kind:'narrative',text:this.text.scene({full:first}),image_room:first?room:null}],2,[]);
  }
  if(node.groups.some(g=>g.noun&32768))throw new UnsupportedFeature('argomenti letterali per questa azione');
  const result=this.resolve(node,action);if(result.message)return {messages:[result.message],cost:0,action,args:[]};const e=result.entity;
  if([11,23,41].includes(action)){if(e.rules.some(r=>r.action===41))throw new UnsupportedFeature('regola speciale TAKE di '+e.name);if(w.entities.some(p=>p.person&&p.id!==actor&&w.owns(p.id,e.id)))return reject(`YOU CANNOT TAKE ${w.name(e.id).toUpperCase()}.`);w.move(e.id,w.roomOf(actor),actor);return ok([say('take',' '+w.name(e.id)+'.')],1,[e.id]);}
  if(action===16){w.move(e.id,w.roomOf(actor),w.entity(actor).parent);return ok([say('drop',' '+w.name(e.id)+'.')],1,[e.id]);}
  if(action===26){const target=this.resolve(node,action,1);if(target.message)return {messages:[target.message],cost:0,action,args:[]};if(w.weight(e.id)>w.remainingCapacity(target.entity.id))return reject(`YOU CANNOT GIVE THE ${this.queryName(node.groups[0]).toUpperCase()}`);w.move(e.id,w.roomOf(target.entity.id),target.entity.id);return ok([say('give',' '+w.name(e.id)+' to '+w.name(target.entity.id)+'.')],1,[e.id,target.entity.id]);}
  if(action===36||action===14){const rule=e.rules.find(r=>r.action===action);if(!['openOrdinary','closeOrdinary'].includes(rule?.rule))throw new UnsupportedFeature('regola speciale '+this.word(node.verb)+' di '+e.name);
   if(e.attributes&1)return reject(w.name(e.id).toUpperCase()+' IS LOCKED');const open=Boolean(e.attributes&32);
   if(action===36&&open)return reject(w.name(e.id).toUpperCase()+' IS OPEN');if(action===14&&!open)return reject(w.name(e.id).toUpperCase()+' IS CLOSED');
   e.attributes=action===36?e.attributes|32:e.attributes&~32;return ok([say(action===36?'open':'close',' '+w.name(e.id)+'.')],1,[e.id]);
  }
  if(action===19){if(e.rules.some(r=>r.action===19))throw new UnsupportedFeature('EXAMINE speciale di '+e.name);e.status|=64;return ok([`You examine ${w.name(e.id)}.\n`+(e.description?this.text.render(e.description,{object:e.id}):`You see ${w.name(e.id,{indefinite:true})}.`)],1,[e.id]);}
  if(action===15){if(!e.money)throw new UnsupportedFeature('COUNT non monetario');return ok([`You count ${w.name(e.id)}.\nIt totals ${formatMoney(e.pence&16383)}`],1,[e.id]);}
  throw new UnsupportedFeature('azione '+action);
 }
 // ALL selects references, rather than turning into one synthetic action with
 // a multiplied cost. Each object is executed and scheduled separately.
 *collective(node){
  if(!node.all){yield node;return;}
  const action=this.action(node),w=this.world,actor=this.actor,slot=node.allSlot||0;
  if(slot!==0||![11,14,16,19,23,26,36,41].includes(action))throw new UnsupportedFeature('ALL per questa azione o per il secondo argomento');
  const group=node.groups[0]||{noun:0,qualifiers:[]};
  const eligible=e=>{
   if(!w.perceived(e.id,actor)||!w.nounMatches(e,group))return false;
   if(action===14||action===36)return e.rules.some(r=>r.action===action);
   if(action===16||action===26)return w.owns(actor,e.id);
   if(action===19)return true;
   return e.rooms.length===1&&!e.person&&!w.owns(actor,e.id)&&!w.owns(e.id,actor)&&w.weight(e.id)<=w.remainingCapacity(actor);
  };
  let found=false;
  for(const entity of w.entities){
   if(!eligible(entity))continue;found=true;
   yield {...clone(node),all:false,resolved:[entity.id]};
  }
  if(!found)yield {...node,all:false};
 }
 submit(input){
  if(this.ended)return {state:this.state(),messages:[]};
  const messages=[],actions=[],units=[];this.lastFrames=[];this.openingPending=false;let lexed,index=0,mode=1;
  try{
   if(input.trim()==='@'){if(this.pending)throw new InputError('syntax_error','WHAT ?');input=this.lastInput||'';}
   if(this.world.display)this.sourceDisplay.command(normalizeInput(input));
   lexed=this.lexer.scan(input);this.lastInput=input;
   this.analysis={input,normalised:lexed.normalized,outcome:'ok',units,actions};
   while(index<lexed.tokens.length&&lexed.tokens[index].type!==192){
    const parsed=this.parser.unit(lexed.tokens,index,{pending:this.pending,mode});index=parsed.next;mode=parsed.mode;units.push(...parsed.nodes);this.pending=null;
    if(parsed.outcome==='control'){
     throw new UnsupportedFeature('controllo '+parsed.control+' (usare i pulsanti del motore JS)');
    }
    if(parsed.nodes.some(node=>node.exclusion))throw new UnsupportedFeature('esecuzione delle esclusioni BUT/EXCEPT');
    for(const originalNode of parsed.nodes){
     for(const node of this.collective(originalNode)){
     const before=this.world.dump(),messageCount=messages.length,actionCount=actions.length,frameCount=this.lastFrames.length;let outcome;
     try{outcome=this.execute(node);
      const paragraph=outcome.cost&&!outcome.suppressParagraph&&outcome.messages.find(m=>m.kind==='narrative');if(paragraph)paragraph.paragraph_before=true;
      messages.push(...outcome.messages);
      if(!outcome.projected)this.projectMessages(outcome.messages);
      if(outcome.cost){actions.push({actor:this.world.player,id:outcome.action,arguments:outcome.args});this.advance(outcome.cost,{action:outcome.action,args:outcome.args,messages,actions});}}
     catch(error){this.world.restore(before);messages.length=messageCount;actions.length=actionCount;this.lastFrames.length=frameCount;throw error;}

     if(this.pending){this.analysis.outcome='clarification';break;}
     }
     if(this.pending)break;
    }
    if(this.pending)break;
   }
  }catch(error){
   if(error instanceof InputError){this.analysis={input,normalised:lexed?.normalized,outcome:error.kind,units,actions};messages.push({kind:error.kind==='tool_limit'?'system':'error',text:error.message.replaceAll('`','£'),...(error.kind==='syntax_error'?{screen_events:[{op:'counter',value:0},{op:'wide'}]}:{})});}
   else if(error instanceof UnsupportedFeature||error instanceof RandomInputsUnavailable){this.analysis={input,normalised:lexed?.normalized,outcome:'not_translated',feature:error.feature??'original-random-input',units,actions};messages.push({kind:'system',text:error.message});}
   else throw error;
  }
  if(this.world.display){if(messages.some(m=>m.kind==='error'))this.sourceDisplay.error();this.sourceDisplay.prompt();}
  if(this.pending)this.analysis.continuation_slot=this.pending.slot;
  return {state:this.state(),messages};
 }
 advance(cost,{action,args,messages,actions}){
  const driver=this.watson.driver(messages,actions);
  driver.clock=()=>this.lastFrames.push({clock:this.world.clock(),world:this.world.dump(),messageCount:messages.length,actionCount:actions.length});
  this.world.consume(cost,{action,args,driver});
 }
 scene(){const before=this.world.dump();try{return this.text.scene({full:!this.world.dark()});}finally{this.world.restore(before);}}
 state(){const w=this.world,room=w.rooms[w.roomOf()],dark=w.dark();
  return {room:room.id,name:room.name,clock:w.clock(),player_id:w.player,seed:null,start_mode:this.startMode,visited:[...w.explored],native_seen:w.rooms.filter(r=>r.flags&64).map(r=>r.id),exits:room.exits.map(e=>({...e,target_name:w.rooms[e.target]?.name,status:!e.gate?'libera':w.entity(e.gate).attributes&40?'aperta / attraversabile':'chiusa / ostacolo'})),objects:w.lastListed.map(id=>({id,name:w.entity(id).name})),visible:w.entities.filter(e=>e.id!==w.player&&!dark&&w.perceived(e.id)).map(e=>({id:e.id,name:e.name})),characters:w.entities.filter(e=>e.person&&![1,100].includes(e.id)).map(e=>({id:e.id,key:e.id===w.player?'player':String(e.id),name:e.id===w.player?'Sherlock Holmes':e.name,badge:e.id===0?'SH':e.id===3?'W':e.id===2?'IL':e.id===31?'C1':e.id===34?'C2':String(e.id),rooms:e.rooms.filter(id=>id>0),parent_id:e.parent,is_player:e.id===w.player})),dark,initial:this.scene(),opening:this.openingPending?this.opening:null,opening_screen:null,analysis:this.analysis,game_over:this.ended,ending_messages:[],command_running:false,engine:'javascript-autonomous',ai:w.scheduler.actor(3).enabled?'watson-partial':'not-translated',npc_profile:w.scheduler.actor(3).behavior?.profile??null,greeting_variant:w.random?'original-arithmetic-historical-watson':'unimplemented-original-random-source',random_state:w.random?{profile:w.random.profile,accumulator:w.random.seed,cursor:w.random.cursor,draws:w.random.draws}:null,fidelity:{status:'partial-functional-rewrite',original_seed_parity:false,full_game_equivalence:false},cab_scope:'arrival-and-containment',scheduler:{active:w.scheduler.actors.filter(a=>a.enabled).map(a=>a.id),actors:clone(w.scheduler.actors),phase:w.scheduler.phase,index:w.scheduler.index,requests:clone(w.scheduler.requests),signals:clone(w.scheduler.signals),events:clone(w.scheduler.trace.slice(-64))}};
 }
 teleport(room){if(!Number.isInteger(room)||room<1||room>=this.world.rooms.length)throw Error('Invalid location');const before=this.world.dump();try{this.pending=null;this.openingPending=false;this.world.move(this.world.player,room);this.world.explored.add(room);this.world.rooms[room].flags|=64;const scene=this.text.scene(),messages=[{kind:'narrative',text:scene,image_room:room}];this.projectMessages(messages);return {state:this.state(),messages};}catch(error){this.world.restore(before);if(error instanceof UnsupportedFeature)return {state:this.state(),messages:[{kind:'system',text:error.message}]};throw error;}}
 dump(){return {format:'sherlock-js-save',version:4,source_sha256:this.data.source_sha256,world:this.world.dump(),pending:clone(this.pending),analysis:clone(this.analysis),lastInput:this.lastInput,ended:clone(this.ended),openingPending:this.openingPending,opening:this.opening,startMode:this.startMode,conversation:clone(this.conversation)};}
 static load(data,save){
  if(save?.format!=='sherlock-js-save'||![1,2,3,4].includes(save.version)||save.source_sha256!==data.source_sha256)throw Error('Questo file non è un salvataggio del motore JavaScript autonomo.');
  if(save.version>=2&&!save.world?.scheduler)throw Error('Salvataggio privo dello scheduler.');
  if(save.world?.scheduler?.actors?.some(a=>a.enabled&&a.id!==0&&(a.id!==3||save.version<3)))throw Error('Questo salvataggio richiede programmi NPC non ancora tradotti.');
  const s=save.world;if(!s||!Array.isArray(s.entities)||s.entities.length!==110||!Array.isArray(s.rooms)||s.rooms.length!==106||!Number.isInteger(s.tick)||s.tick<0||s.tick>65535||!Number.isInteger(s.playerDue)||s.playerDue<0||s.playerDue>65535||!Number.isSafeInteger(s.minutes)||s.minutes<0||!Number.isInteger(s.player)||s.player<0||s.player>=110)throw Error('Salvataggio JS incompleto.');
  for(const [i,e] of s.entities.entries())if(e.id!==i||!Array.isArray(e.rooms)||!e.rooms.every(r=>Number.isInteger(r)&&r>=0&&r<106)||e.parent!==null&&(!Number.isInteger(e.parent)||e.parent<0||e.parent>=110))throw Error('Entità nel salvataggio non valida.');
  for(const e of s.entities){const seen=new Set([e.id]);let parent=e.parent;while(parent!==null){if(seen.has(parent))throw Error('Ciclo nei contenitori del salvataggio.');seen.add(parent);parent=s.entities[parent].parent;}}
  RuntimeRandom.validate(s.random);RandomDisplay.validate(s.display);if(Boolean(s.random)!==Boolean(s.display))throw Error('Salvataggio casuale privo dello stato sorgente completo.');if(save.version<4&&s.random)throw Error('Stato casuale inatteso in un salvataggio precedente.');
  const g=new Game(data,{start_mode:save.startMode,npcs:false});g.world.restore(s);g.configureRandom();for(const key of ['pending','analysis','lastInput','ended','openingPending','opening','conversation'])g[key]=clone(save[key]);g.watson.validateState();g.cab.validateState();g.state();return g;
 }
}
