import {Dictionary,Lexer,InputError,normalizeInput} from './lexer.mjs';
import {Parser} from './parser.mjs';
import {World,UnsupportedFeature,joinList,DIRECTION_NAMES} from './world.mjs';
import {Text} from './text.mjs';
import {Watson} from './watson.mjs';
import {Cab} from './cab.mjs';
import {Conversation} from './conversation.mjs';
import {waitUntilCost} from './wait-until.mjs';
import {transferMoney,decodeMoney,formatMoney} from './cab-economy.mjs';
import {RuntimeRandom} from './runtime-random.mjs';
import {RandomInputsUnavailable} from './random.mjs';
import {RandomDisplay} from './random-display.mjs';
import {NpcRuntime} from './npc-runtime.mjs';
import {CommandHistory} from './command-history.mjs';
import {characterBadge} from './characters.mjs';
import {canPlace,fitsContainer} from './objects.mjs';
import {changeIdentity} from './identity.mjs';
import {objectRuleFor} from './special-objects.mjs';

export const SUPPORTED_ACTIONS=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54];
const clone=structuredClone;
// Rules are domain functions over logical objects. No binary, RAM, CPU, address
// dispatcher, server-side game logic, or fallback to the reference engine.
export class Game {
 constructor(data,{start_mode='free',npcs=true,npc_random=true,npc_profile='historical-watson-v4',seed=1}={}){
  this.data=data;this.dictionary=new Dictionary(data.dictionary);this.lexer=new Lexer(this.dictionary);this.parser=new Parser(this.lexer);this.world=new World(data);this.text=new Text(data,this.dictionary,this.world);
  this.startMode=start_mode;this.pending=null;this.analysis=null;this.lastInput=null;this.ended=null;this.openingPending=true;this.conversation=null;
  if(start_mode==='original'){this.world.tick=2;this.world.minutes++;}
  this.sourceDisplay=new RandomDisplay(data,this.world);this.runtimeRandom=new RuntimeRandom(data,this.world);this.runtimeRandom.display=this.sourceDisplay;this.npcRuntime=new NpcRuntime(this);if(npcs&&npc_random&&npc_profile!=='world-v5')this.runtimeRandom.initialize();this.configureRandom();
  this.cab=new Cab(this);this.watson=new Watson(this);this.dialogue=new Conversation(data,this.text);if(npcs&&npc_profile!=='world-v5')this.watson.initialize();
  this.bootstrapSceneTrace=[];this.initial=this.text.scene({trace:this.bootstrapSceneTrace});this.opening=this.initial+'\n'+this.text.render('6DEB');
  if(npcs&&npc_profile==='world-v5'){this.runtimeRandom.projector=a=>this.npcRuntime.read(a);const boot=this.npcRuntime.initialize(seed);this.opening=this.initial+'\n'+boot.filter(m=>m.kind==='narrative').map(m=>m.text).join('\n');}
  else if(this.world.random)this.sourceDisplay.initialize(this.opening,{sceneTrace:this.bootstrapSceneTrace});
  this.history=new CommandHistory(this.historyMeta());
 }
 historyMeta(){return {seed:this.world.npcs?.initialSeed??null,startMode:this.startMode,profile:this.world.npcs?.profile??this.world.scheduler.actor(3).behavior?.profile??null,source_sha256:this.data.source_sha256};}
 configureRandom(){this.text.chooseIndex=this.world.random?(count,ctx)=>this.runtimeRandom.chooseIndex(count,{...ctx,purpose:'text:'+ctx.fragment}):undefined;}
 // Literal speech still traverses the word workspace outside Holmes' view;
 // only the screen sink and dictionary/name writes are suppressed there.
 npcTextContext(actor){if(!this.world.display)return {};if(!this.world.perceived(actor))return {bufferVisible:false,bufferSink:(c,options)=>this.sourceDisplay.bufferFeed(c,options)};const characters=[];return {characters,bufferVisible:true,bufferSink:(c,options)=>this.sourceDisplay.bufferFeed(c,options),...(this.actingTextContext?.actorNameFrame?{actorNamePrefix:write=>{const previous=this.sourceDisplay.glyphFrame;this.sourceDisplay.glyphFrame=this.actingTextContext.actorNameFrame;try{write();}finally{this.sourceDisplay.glyphFrame=previous;}}}:{}),sink:c=>{if(c==='\b')characters.pop();else characters.push(c);this.sourceDisplay.feed(c,{buffer:false});}};}
 textMessage(text,context){return {kind:'narrative',text,...(context.characters?{raw_text:context.characters.join('')}: {})};}
 projectMessages(messages){if(this.world.display)for(const m of messages)if(m.kind==='narrative')this.sourceDisplay.write(m.raw_text??m.text,{leading:Boolean(m.paragraph_before),sceneTrace:m.scene_trace});}
 sceneMessage(options={}){const scene_trace=[];return {kind:'narrative',text:this.text.scene({source:'arrival',...options,trace:scene_trace}),scene_trace};}
 word(id){return this.dictionary.word(id)?.stem||'';}
 queryName(group){return [...group.qualifiers,group.noun].filter(Boolean).map(id=>this.word(id)).join(' ')||'anything';}
 action(node){
  if(!node.verb)return 1;
  const verb=this.word(node.verb),modifier=this.word(node.modifier),relations=node.groups.flatMap(g=>g.relations).map(id=>this.word(id));
  if(verb==='pay'&&!relations.length&&node.groups.length===2)return 37;
  if(verb==='sit'&&!relations.length)return 40;
  if(['get','climb'].includes(verb)&&relations.join(' ')==='out')return verb==='get'?25:13;
  // The conversation form accepts the optional TO: SAY CABBIE and SAY TO
  // CABBIE select the same action, with the same nominal argument/quote.
  if(verb==='talk'&&!modifier&&!relations.length&&node.groups.length===1)return 46;
  if(DIRECTION_NAMES.includes(verb)&&verb&&!modifier&&!relations.length)return DIRECTION_NAMES.indexOf(verb);
  return this.data.actions.find(a=>a.words[0]===verb&&JSON.stringify(a.words.slice(1,3).filter(Boolean))===JSON.stringify(relations)&&(a.words[3]||'')===modifier)?.id
    ||(verb!=='pay'?this.data.actions.find(a=>a.words[0]===verb&&(a.words[3]||'')===modifier&&relations.every(r=>a.words.slice(1,3).includes(r)))?.id:0)
    ||(verb==='wait'&&relations.length===0?49:0);
 }
 get actor(){return this.actingActor??this.world.player;}
 canTake(e){const w=this.world,actor=this.actor;return w.perceived(e.id,actor)&&e.rooms.length===1&&!e.person&&!w.owns(actor,e.id)&&!w.owns(e.id,actor)&&w.weight(e.id)<=w.remainingCapacity(actor)&&!w.entities.some(p=>p.person&&w.owns(p.id,e.id));}
 canResolve(e,action,slot){
  if([29,30,45].includes(action))return false;
  if([47,48].includes(action)&&slot===1)return e.id!==0;
  if([21,22].includes(action))return e.person&&e.id!==this.actor;
  if(action===43)return e.rules.some(r=>r.action===43)&&this.actor===(e.id===14?1:100);
  const w=this.world,actor=this.actor;if(!w.perceived(e.id,actor))return false;
  if([53,54].includes(action))return e.rules.some(r=>r.action===action);
  if(action===51)return actor===0&&e.rules.some(r=>r.action===51);
  if(action===36&&e.rules.some(r=>r.rule==='openSafe'))return actor===0;
  if([23,41,44].includes(action)&&e.rules.some(r=>r.action===action&&r.rule==='takeBurningNote'))return true;
  if(action===19||action===20){if(action===20&&e.rules.some(r=>r.action===20))return true;for(let p=e.parent;p!==null;p=w.entity(p).parent)if(w.entity(p).person)return p===actor;return true;}
  if(action===35)return e.rooms.length!==1;
  if(action===36||action===14)return e.rules.some(r=>r.action===action);
  if([11,23,41,42,44].includes(action))return slot===0?this.canTake(e):true;
  if([17,38,39].includes(action))return slot===0?w.owns(actor,e.id):true;
  if(action===26)return slot===0?w.owns(actor,e.id):e.person&&e.id!==actor;
  if(action===16)return w.owns(actor,e.id);
  if([12,24,40].includes(action))return e.rules.some(r=>r.action===action);
  if([13,25].includes(action))return w.entity(actor).parent===e.id;
  if(action===46)return e.person&&e.id!==actor;
  if([47,48].includes(action))return slot===0?e.person:e.id!==0;
  if(action===37)return e.person;
  return true;
 }
 error(text){return {kind:'error',text};}
 semanticNode(node){if(this.action(node)===37&&!(node.groups[0]?.noun&32768)&&node.groups[1]?.noun&32768)return {...node,groups:[node.groups[1],node.groups[0]]};if(this.world.npcs&&this.action(node)===46&&!node.groups[0]?.noun&&!node.groups[0]?.qualifiers.length){const b=this.world.npcs.information.addressee,query={noun:b[0]|b[1]<<8,qualifiers:[b[2]|b[3]<<8,b[4]|b[5]<<8].filter(Boolean)};if(!this.world.entities.some(e=>this.world.nounMatches(e,query)&&this.canResolve(e,46,0)))return {...node,implicitMissing:true};return {...node,groups:[{noun:b[0]|b[1]<<8,qualifiers:[b[2]|b[3]<<8,b[4]|b[5]<<8].filter(Boolean),relations:node.groups[0]?.relations||[]}]};}if(node.all&&node.groups.length===1&&node.groups[0].relations.length&&[17,26,37,38,39,42,44,47,48].includes(this.action(node)))return {...node,groups:[{noun:0,qualifiers:[],relations:[]},node.groups[0]]};return node;}
 locationCandidates(node){const g=node.groups[0]||{noun:0,qualifiers:[]};return this.world.rooms.filter(r=>this.world.rooms[this.world.roomOf(this.actor)].exits.some(e=>e.target===r.id)&&(!g.noun||r.nameWords.some(n=>(n&4095)===(g.noun&4095)))&&g.qualifiers.every(q=>r.nameWords.some(n=>(n&4095)===(q&4095))));}
 referenceCandidates(node,action,slot=0){if([18,27].includes(action))return {nominal:[],possible:this.locationCandidates(node)};node=this.semanticNode(node);const group=node.groups[slot]||{noun:0,qualifiers:[],relations:[]},nominal=this.world.entities.filter(e=>this.world.nounMatches(e,group));let possible=nominal.filter(e=>this.canResolve(e,action,slot));
  if([17,38,39,42,44].includes(action)){
   const other=node.groups[1-slot];const partners=(node.resolved?.[1-slot]!==undefined?[this.world.entity(node.resolved[1-slot])]:this.world.entities.filter(e=>!other||this.world.nounMatches(e,other))).filter(e=>this.world.perceived(e.id,this.actor));
   // B29A counts a first argument only when EXACTLY one second argument
   // survives. Two possible destinations can therefore reject the object,
   // rather than asking which destination; preserve that original quirk.
   if(partners.length||!other||slot!==0)possible=possible.filter(e=>{const count=partners.filter(p=>[42,44].includes(action)?this.canResolve(p,action,1-slot):canPlace(this.world,slot===0?e:p,slot===0?p:e,this.actor)).length;return slot===0?count===1:count>0;});
  }
  if([47,48].includes(action)&&slot===0){const topic=node.groups[1]||{noun:0,qualifiers:[]},topics=this.world.entities.filter(e=>e.id!==0&&this.world.nounMatches(e,topic));if(topics.length!==1)possible=[];}
  return {nominal,possible};}
 needsClarification(node){
  node=this.semanticNode(node);
  if(node.implicitMissing)return true;if([18,27].includes(this.action(node)))return this.locationCandidates(node).length>1;
  // This preflight uses the same semantic candidates as resolve(). It only
  // determines whether B5B6 retains the parsed node; it executes no action.
  const action=this.action(node);if(node.all||node.exclusion||node.quote||node.subject||this.world.dark()||!SUPPORTED_ACTIONS.includes(action))return false;
  const slots=action===37?[1]:[17,26,38,39,42,44].includes(action)?[0,1]:[11,12,13,14,16,19,20,21,22,23,24,25,28,35,36,40,41,43,46,47,48,51,53,54].includes(action)?[0]:[];
  for(const slot of slots){const group=node.groups[slot];if(!group?.noun&&!group?.qualifiers?.length)return false;const {possible}=this.referenceCandidates(node,action,slot);if(possible.length>1)return true;if(!possible.length)return false;}
  return false;
 }
 resolve(node,action,slot=0){
  if(node.resolved?.[slot]!==undefined)return {entity:this.world.entity(node.resolved[slot])};
  const w=this.world,group=node.groups[slot]||{noun:0,qualifiers:[],relations:[]};
  if(!group.noun&&!group.qualifiers.length&&!node.collective){return {message:this.error(`${this.word(node.verb).toUpperCase()} WHAT ?`)};}
  const {nominal,possible}=this.referenceCandidates(node,action,slot);
  if(possible.length>1){this.pending={node:clone(node),slot};return {message:this.error(`WHICH ${this.word(group.noun).toUpperCase()||'ONE'} ?`)};}
  if(possible.length===1)return {entity:possible[0]};
  const query=this.queryName(group).toUpperCase(),verb=this.word(node.verb).toUpperCase();
  const scenery=w.npcs?.sceneryFailure;
  if(scenery?.action===action&&scenery.slot===slot){const relations=([45,47,48].includes(action)?[]:this.data.actions.find(a=>a.id===action)?.words.slice(1,3).filter(Boolean))||[],modifier=this.word(node.modifier).toUpperCase();return {message:this.error(scenery.found?`YOU CANNOT ${[modifier,verb,...([29,30,35].includes(action)?relations.map(r=>r.toUpperCase()):[])].filter(Boolean).join(' ')} THE ${query}`:`I SEE NO ${query} THAT YOU CAN ${[verb,...relations.map(r=>r.toUpperCase())].join(' ')}`)};}
  if(slot===1&&[17,38,39,42,44].includes(action))return {message:this.error(`I SEE NO ${query} THAT YOU CAN ${[verb,...(([45,47,48].includes(action)?[]:this.data.actions.find(a=>a.id===action)?.words.slice(1,3).filter(Boolean))||[])].join(' ').toUpperCase()}`)};
  if([12,13,24,25,40,43,46,47,48,51,53,54,21,22].includes(action))return {message:this.error(`I SEE NO ${query} THAT YOU CAN ${[verb,...(([45,47,48].includes(action)?[]:this.data.actions.find(a=>a.id===action)?.words.slice(1,3).filter(Boolean))||[])].join(' ').toUpperCase()}`)};
  if(nominal.length>1)return {message:this.error(`I SEE NO ${query} THAT YOU CAN ${verb}`)};
  if([11,23,41,42,44].includes(action)&&slot===0&&nominal.length===1&&w.perceived(nominal[0].id)&&w.entities.some(p=>p.person&&p.id!==w.player&&w.owns(p.id,nominal[0].id)))return {message:this.error(`YOU CANNOT TAKE ${w.name(nominal[0].id).toUpperCase()}.`)};
  return {message:this.error(`YOU CANNOT ${verb} THE ${query}`)};
 }
 executeAs(node,actor,{textContext=null,requestRestriction=false}={}){const previous=this.actingActor,pending=this.pending,priorText=this.actingTextContext,priorRestriction=this.actingRequestRestriction;this.actingActor=actor;this.actingTextContext=textContext;this.actingRequestRestriction=requestRestriction;try{return this.execute(node);}finally{this.actingActor=previous;this.actingTextContext=priorText;this.actingRequestRestriction=priorRestriction;this.pending=pending;}}
 execute(node){
  node=this.semanticNode(node);
  const w=this.world,action=this.action(node),actor=this.actor,subject=actor===0?'You':w.name(actor).replace(/^./,c=>c.toUpperCase()),verb=(base,third=this.dictionary.word(this.dictionary.lookup(base.toUpperCase()).value)?.form||base+'s')=>actor===0?base:third,say=(base,tail,third)=>`${subject} ${verb(base,third)}${tail}`,narrative=text=>({kind:'narrative',text}),ok=(messages,cost=1,args=[])=>({messages:messages.map(m=>typeof m==='string'?narrative(m):m),cost,action,args}),reject=text=>({messages:[this.error(text)],cost:0,action,args:[]});
  if(w.npcs&&action)this.npcRuntime.setActionClasses(action);
  if(node.all||node.exclusion)throw new UnsupportedFeature('questa forma di ALL/EXCEPT');
  if(node.quote&&action!==46){
   if(!w.npcs)for(const quote of node.quotes||[node.quote])try{this.parser.quoted(quote);}catch(error){if(error instanceof InputError)throw new InputError('quoted_syntax_error','WHAT ?');throw error;}
   throw new UnsupportedFeature('citazioni per questa forma di conversazione');
  }
  if(!action){if(this.word(node.verb)==='pay'){
   // PAY's first argument must be a money literal; PAY CABBIE fails that
   // semantic preflight before a recipient/action can be selected.
   if(node.groups.length===1&&node.groups[0].noun&&!(node.groups[0].noun&32768))return reject("DON'T BE SILLY.");
   throw new UnsupportedFeature('forma PAY senza TO e relativo passaggio al turno seguente');
  }const words=[node.modifier,node.verb,...node.groups.flatMap(g=>g.relations)].filter(Boolean).map(id=>' '+this.word(id).toUpperCase()).join('');return reject(`I DO NOT KNOW THE VERB"${words}"`);}
  // 9FC5 has class-zero arguments and a predicate that always fails.
  // It rejects before light/reference resolution and never enters combat.
  if(action===52)return reject(this.text.render('680B').toUpperCase());
  if(!SUPPORTED_ACTIONS.includes(action))throw new UnsupportedFeature(`azione ${action} (${this.word(node.verb)})`);
  const lightFreeLocal=node.groups[0]&&w.entities.some(e=>w.nounMatches(e,node.groups[0])&&e.rules.some(r=>r.action===action&&['takeBurningNote','openSafe','untranslated:E0A0','untranslated:E0E0','untranslated:E0F2','untranslated:E104'].includes(r.rule)));
  if(w.dark(actor)&&![31,43,46,47,48,49,50,51,53,54].includes(action)&&!lightFreeLocal)return reject('SORRY IT IS TOO DARK.');
  if(action===34)return actor===w.player?ok([{...this.sceneMessage({source:'look'}),image_room:w.roomOf()}]):ok([],1);
  if(action===33){const listed=w.entities.filter(e=>e.parent===actor&&e.rooms.length<2&&w.perceived(e.id,actor));for(const e of listed)e.status|=128;const items=listed.map(e=>w.name(e.id,{indefinite:true}));const name=actor===0?'You are':w.name(actor,{indefinite:true})+' is';return ok([name.replace(/^./,c=>c.toUpperCase())+' carrying '+(items.length?joinList(items)+'.':'nothing')]);}
  if(action===32){if(actor===w.player)return ok([this.error(this.text.render('6915').toUpperCase())],0);const context=this.npcTextContext(actor),out=ok([this.textMessage(this.text.greeting(actor,context),context)],0);out.projected=Boolean(context.sink);return out;}
  if(action===37){
   const literal=node.groups[0]?.noun;
   if(!(literal&32768)||!(literal&128))return reject("DON'T BE SILLY.");
   if(w.npcs)w.npcs.literal=literal;
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
   // Prefabricated NPC orders already contain resolved entity identities;
   // their second argument does not pass through another noun phrase.
   const topics=node.resolved?.[1]!==undefined?[w.entity(node.resolved[1])]:group?w.entities.filter(e=>w.nounMatches(e,group)):[];
   if(topics.length!==1)throw new UnsupportedFeature('risoluzione del soggetto TELL: zero o più riferimenti');
   const specific={ 'untranslated:E17B':'npc.tellJones','untranslated:E1A3':'npc.tellTricia'}[w.entity(actor).rules.find(r=>r.action===action)?.rule];
   if(specific)return {...ok([],0,[target.entity.id,topics[0].id]),objectRule:specific,semanticResolved:true,projected:true};
   const context=this.npcTextContext(actor);
   const out=ok([this.textMessage(this.dialogue.tell(actor,target.entity.id,topics[0].id,context),context)],1,[target.entity.id,topics[0].id]);out.projected=Boolean(context.sink);out.suppressParagraph=true;return out;
  }
  if([21,22].includes(action)){if(!w.npcs)throw new UnsupportedFeature('FOLLOW nel profilo storico');const target=this.resolve(node,action);if(target.message)return {messages:[target.message],cost:0,action,args:[]};return {...ok([],0,[target.entity.id]),objectRule:'unimplemented.E452',semanticResolved:true};}
  if([29,30,45].includes(action)){const result=this.resolve(node,action);return result.message?{messages:[result.message],cost:0,action,args:[]}:reject('YOU CANNOT '+this.word(node.verb).toUpperCase());}
  if([18,27].includes(action)&&w.npcs){const group=node.groups[0]||{noun:0,qualifiers:[]},rooms=this.locationCandidates(node);if(!rooms.length){const out=this.resolve(node,action);return {messages:[out.message],cost:0,action,args:[]};}if(rooms.length>1){this.pending={node:clone(node),slot:0};return reject('WHICH '+this.word(group.noun).toUpperCase()+' ?');}return {...ok([],0,[rooms[0].id]),objectRule:'move.adjacent',semanticResolved:true};}
  if(action===49)return ok([say('wait','.')],5);
  if(action===50){const literal=node.groups[0]?.noun;if(!(literal&32768)||literal&128)return reject('WAIT UNTIL WHAT ?');
   if(w.npcs){w.npcs.literal=literal;if(actor===w.player)w.npcs.playerProgramCounter='9945';}
   return ok([],waitUntilCost(literal,w.clock()),[254]);
  }
  if(action===31){
   const group=node.groups[0]||{noun:0,qualifiers:[]};if(!group.noun&&!group.qualifiers.length)return reject('HAIL WHAT ?');
   const nominal=w.entities.filter(e=>w.nounMatches(e,group)),vehicle=nominal.find(e=>this.cab.available(e,actor));
   if(!vehicle)return reject(!this.cab.isStreet(w.roomOf(actor))&&nominal.some(e=>e.rules.some(r=>r.rule==='hailCab'))?'YOU CANNOT HAIL THE '+this.queryName(group).toUpperCase():'I SEE NO '+this.queryName(group).toUpperCase()+' THAT YOU CAN HAIL');
   this.cab.arrive(vehicle,actor);return ok([say('hail',' '+w.name(vehicle.id)+'.')],1,[vehicle.id]);
  }
  if(action===46){
   if(node.implicitMissing){this.pending={node:clone({...node,implicitMissing:false}),slot:0};return reject('TALK TO WHAT ?');}
   if(w.npcs)this.npcRuntime.addressee(node.groups[0]);
   const target=this.resolve(node,action);if(target.message)return {messages:[target.message],cost:0,action,args:[]};
   let commands=[],quoteMode=1;
   const quote=w.npcs&&actor===w.player?this.npcRuntime.consumeQuote():node.quote;
   if(quote){try{const parsed=this.parser.quoted(quote,{onNominal:w.npcs?group=>this.npcRuntime.nominal(group):null,onCount:w.npcs?value=>{w.npcs.parserCount=value;}:null});commands=parsed.nodes;quoteMode=parsed.mode;}catch(error){
    if(!(error instanceof InputError))throw error;
    if(w.npcs&&error.detail.partialNodes)this.npcRuntime.failedQuote(error.detail.partialNodes);
    else throw new InputError('quoted_syntax_error','WHAT ?',error.detail);
   }}
   if(w.npcs){
    this.npcRuntime.addressee(node.groups[0]);
    if(!w.scheduler.actors.some(a=>a.id===target.entity.id&&a.enabled))throw new UnsupportedFeature('programma e conversazione di '+target.entity.name);
    if(commands.length)this.npcRuntime.queue(actor,target.entity.id,commands,quoteMode);
    return ok([say('talk',' to '+w.name(target.entity.id)+'.')],1,[target.entity.id]);
   }
   if(target.entity.id!==3||!w.scheduler.actor(3).enabled)throw new UnsupportedFeature('programma e conversazione di '+target.entity.name);
   if(node.quote){
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
   if(w.owns(e.id,actor)||w.owns(actor,e.id)||e.size<w.entity(actor).size||(rule.rule!=='enterCab'&&!fitsContainer(w,w.entity(actor),e)))return reject('YOU CANNOT GET INTO '+w.name(e.id).toUpperCase());
   w.move(actor,w.roomOf(actor),e.id);return ok([say(this.word(node.verb),(action===40?' in ':' into ')+w.name(e.id)+'.')],2,[e.id]);
  }
  if(action<=10||[18,27,28,35].includes(action)){
   let edge,direction=action;
   if(action<=10)edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.direction_id===action);
   else if(action===18||action===27){const group=node.groups[0]||{noun:0,qualifiers:[]};edge=w.rooms[w.roomOf(actor)].exits.find(e=>{const r=w.rooms[e.target],ids=r?.nameWords.map(n=>n&4095)||[];return (!group.noun||ids.includes(group.noun&4095))&&group.qualifiers.every(q=>ids.includes(q&4095));});direction=edge?.direction_id;}
   else{const result=this.resolve(node,action);if(result.message)return {messages:[result.message],cost:0,action,args:[]};edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.gate===result.entity.id);direction=edge?.direction_id;}
   // DCD2 resolves the exit before DCDD/CBA7 checks the suspended request.
   if(action!==35&&edge?.target&&this.actingRequestRestriction)return {messages:[],cost:0,action,args:[],requestRefused:true};
   const gate=edge?.gate?w.entity(edge.gate):null;
   const failure=()=>action===35?reject(`YOU CANNOT LOOK THROUGH ${gate?w.name(gate.id).toUpperCase():'THAT'}.`):reject(`YOU CANNOT GO ${DIRECTION_NAMES[direction||action]?.toUpperCase()||'THAT WAY'}.`);
   if(!edge||!edge.target||action!==35&&w.entity(actor).parent!==null||(gate&&(!(gate.attributes&40)||action!==35&&gate.size<w.entity(actor).size))){const out=failure();return action===35?{...out,args:[gate?.id??node.resolved?.[0]??255],semanticResolved:true}:out;}
   if(action===35){if(actor!==w.player)return ok([say('look',' through '+w.name(gate.id)+'.')],2,[gate.id]);const room=w.roomOf(actor),parent=w.entity(actor).parent;w.move(actor,edge.target,parent);let scene;try{scene=this.text.scene({full:false,remote:true,mark:true,source:'remote'});}finally{w.move(actor,room,parent);}return ok([`You look through ${w.name(gate.id)}.\n${scene}`],2,[gate.id]);}
   const room=edge.target,first=!(w.rooms[room].flags&64),visibleBefore=w.perceived(actor);w.move(actor,room);if(w.npcs)this.npcRuntime.moved(room);
   if(actor!==w.player){const visibleAfter=w.perceived(actor),messages=[];
    // CA3A/CA76 announces the action before relocation; CAAF/CBC2 adds an
    // arrival only when the actor becomes perceptible from elsewhere.
    if(visibleBefore)messages.push(action===28?`${w.name(actor)} goes through ${w.name(gate.id)}.`:`${w.name(actor)} goes ${DIRECTION_NAMES[direction]}.`);
    if(!visibleBefore&&visibleAfter)messages.push(`${w.name(actor)} enters.`);
    return {...ok(messages,2,action===28?[gate.id]:[]),visibilityResolved:true};
   }
   w.rooms[room].flags|=64;w.explored.add(room);
   const movement=action===28?say('go',' through '+w.name(gate.id)+'.'):say('go',' '+DIRECTION_NAMES[direction]+'.');
   return ok([movement,{...this.sceneMessage({full:first}),image_room:first?room:null}],2,action===28?[gate.id]:[]);
  }
  if(node.groups.some(g=>g.noun&32768))throw new UnsupportedFeature('argomenti letterali per questa azione');
  const result=this.resolve(node,action);if(result.message)return {messages:[result.message],cost:0,action,args:[]};const e=result.entity;
  const objectRule=objectRuleFor(e,action);
  if(objectRule){if(!w.npcs)throw new UnsupportedFeature('regole degli oggetti speciali nel profilo storico');if(action===20&&e.person&&!e.rules.some(r=>r.action===20))return {...reject(`${subject} cannot closely examine ${w.name(e.id)}.`.toUpperCase()),args:[e.id],semanticResolved:true};const text=action===20?`${subject} closely ${verb('examine')} ${w.name(e.id)}.`:say(this.word(node.verb),' '+w.name(e.id)+'.');return {...ok([text],0,[e.id]),objectRule,semanticResolved:true};}
  if(action===51||action===43){const message=say(action===51?'wear':'take',' '+(action===43?'off ':'')+w.name(e.id)+'.'),room=changeIdentity(this,action===43?0:e.id===14?1:100);e.parent=0;e.rooms=[action===43?room:0];return ok([message],1,[e.id]);}
  if([11,23,41,42,44].includes(action)){if(e.rules.some(r=>r.action===action))throw new UnsupportedFeature('regola speciale TAKE di '+e.name);if(w.entities.some(p=>p.person&&p.id!==actor&&w.owns(p.id,e.id)))return {...reject(`YOU CANNOT TAKE ${w.name(e.id).toUpperCase()}.`),args:[e.id],semanticResolved:true};let source=null;
   if([42,44].includes(action)){const target=this.resolve(node,action,1);if(target.message)return {messages:[target.message],cost:0,action,args:[]};source=target.entity;}
   w.move(e.id,w.roomOf(actor),actor);return ok([say(this.data.actions.find(a=>a.id===action).words[0],' '+w.name(e.id)+(source?' '+(action===42?'from':'out of')+' '+w.name(source.id):'')+'.')],1,source?[e.id,source.id]:[e.id]);}
  if([17,38,39].includes(action)){const target=this.resolve(node,action,1);if(target.message)return {messages:[target.message],cost:0,action,args:[]};
   if(!canPlace(w,e,target.entity,actor))return reject(`YOU CANNOT ${this.word(node.verb).toUpperCase()} THE ${this.queryName(node.groups[0]||{qualifiers:[]}).toUpperCase()}`);
   if(target.entity.attributes&64||!(target.entity.attributes&40))return {...reject(`${subject} cannot ${action===17?'drop':'put'} ${w.name(e.id)} ${action===39?'on':'in'} ${w.name(target.entity.id)}.`.toUpperCase()),args:[e.id,target.entity.id],semanticResolved:true};
   if(target.entity.id===e.id||w.owns(e.id,target.entity.id))throw new UnsupportedFeature('ciclo di contenimento nella regola PUT');
   w.move(e.id,w.roomOf(target.entity.id),target.entity.id);return ok([say(action===17?'drop':'put',' '+w.name(e.id)+(action===39?' on ':' in ')+w.name(target.entity.id)+'.')],1,[e.id,target.entity.id]);}
  if(action===16){w.move(e.id,w.roomOf(actor),w.entity(actor).parent);return ok([say('drop',' '+w.name(e.id)+'.')],1,[e.id]);}
  if(action===26){const target=this.resolve(node,action,1);if(target.message)return {messages:[target.message],cost:0,action,args:[]};if(w.weight(e.id)>w.remainingCapacity(target.entity.id))return reject(`YOU CANNOT GIVE THE ${this.queryName(node.groups[0]).toUpperCase()}`);w.move(e.id,w.roomOf(target.entity.id),target.entity.id);return ok([say('give',' '+w.name(e.id)+' to '+w.name(target.entity.id)+'.')],1,[e.id,target.entity.id]);}
  if(action===36||action===14){const rule=e.rules.find(r=>r.action===action);if(!['openOrdinary','closeOrdinary'].includes(rule?.rule))throw new UnsupportedFeature('regola speciale '+this.word(node.verb)+' di '+e.name);
   if(e.attributes&1)return reject(w.name(e.id).toUpperCase()+' IS LOCKED');const open=Boolean(e.attributes&32);
   if(action===36&&open)return {...reject(w.name(e.id).toUpperCase()+' IS OPEN'),args:[e.id],semanticResolved:true};if(action===14&&!open)return {...reject(w.name(e.id).toUpperCase()+' IS CLOSED'),args:[e.id],semanticResolved:true};
   e.attributes=action===36?e.attributes|32:e.attributes&~32;return ok([say(action===36?'open':'close',' '+w.name(e.id)+'.')],1,[e.id]);
  }
  if(action===19&&e.person)return {...reject(`YOU CANNOT EXAMINE ${e.id===actor?'ME':w.name(e.id).toUpperCase()}.`),args:[e.id],semanticResolved:true};
  if(action===19){if(e.rules.some(r=>r.action===19))throw new UnsupportedFeature('EXAMINE speciale di '+e.name);if(![0,1,100].includes(actor))return ok([say('examine',' '+w.name(e.id)+'.')]);if(w.npcs){if(!this.text.examinePreservesLowScratch(e.description))this.sourceDisplay.invalidateScratch();else this.sourceDisplay.invalidateScratch(0x5D12);}e.status|=64;
   const characters=[],description=e.description?this.text.render(e.description,{object:e.id,sink:c=>{if(c==='\b')characters.pop();else characters.push(c);}}):`${subject} see ${w.name(e.id,{indefinite:true})}.`,announcement=say('examine',' '+w.name(e.id)+'.')+'\n';
   return ok([{kind:'narrative',text:announcement+description,raw_text:announcement+(e.description?characters.join(''):description)+'\n'}],1,[e.id]);}
  if(action===15){if(!e.money)throw new UnsupportedFeature('COUNT non monetario');return ok([`You count ${w.name(e.id)}.\nIt totals ${formatMoney(e.pence&16383)}`],1,[e.id]);}
  throw new UnsupportedFeature('azione '+action);
 }
 // ALL selects references, rather than turning into one synthetic action with
 // a multiplied cost. Each object is executed and scheduled separately.
 supportsCollective(node){return !node.exclusion&&SUPPORTED_ACTIONS.includes(this.action(node));}
 *collective(node){
  node=this.semanticNode(node);
  if(!node.all){yield node;return;}
  const action=this.action(node),w=this.world,actor=this.actor;
  if(action===52)return; // Its always-failing predicate selects no ALL member.
  if(![11,12,13,14,16,17,19,20,21,22,23,24,25,26,28,31,35,36,37,38,39,40,41,42,43,44,45,46,47,48,51,53,54].includes(action)){yield {...node,all:false};return;}
  const group=node.groups[0]||{noun:0,qualifiers:[]};
  // B517 starts its exclusion scan AFTER the current index entry. In this
  // game's unique ascending entity index it cannot return that same entity;
  // BUT nodes remain allocated, but do not filter these selections.
  for(const entity of w.entities){
   if(!w.perceived(entity.id,actor)||!w.nounMatches(entity,group)||!([11,23,41].includes(action)?entity.rooms.length===1&&!entity.person&&!w.owns(actor,entity.id)&&!w.owns(entity.id,actor)&&w.weight(entity.id)<=w.remainingCapacity(actor):this.canResolve(entity,action,0)))continue;
   if([17,38,39,42,44,47,48].includes(action)&&!this.referenceCandidates(node,action,0).possible.some(e=>e.id===entity.id))continue;
   yield {...clone(node),all:false,collective:true,resolved:[entity.id]};
  }
 }

 submit(input,{streamWait=false}={}){
  if(this.ended)return {state:this.state(),messages:[]};
  const entry=this.history.begin('command',input,this.world);this.streamWait=streamWait;
  try{const out=this.submitCommand(input);this.history.finish(entry,this.world,{outcome:this.pendingWait?'running':out.state.analysis?.outcome??'ok',errors:out.messages.filter(m=>['error','system'].includes(m.kind)).map(m=>m.text)});return out;}
  catch(error){this.cancelFailedInput?.();this.history.finish(entry,this.world,{outcome:'exception',errors:[error.message]});throw error;}
  finally{delete this.cancelFailedInput;delete this.streamWait;delete this.currentInputEnd;}
 }
 submitCommand(input){
  if(this.ended)return {state:this.state(),messages:[]};
  const checkpoint={world:this.world.dump(),pending:clone(this.pending),analysis:clone(this.analysis),lastInput:this.lastInput,ended:clone(this.ended),conversation:clone(this.conversation),openingPending:this.openingPending};
  const cancel=()=>{this.world.restore(checkpoint.world);for(const key of ['pending','analysis','lastInput','ended','conversation','openingPending'])this[key]=clone(checkpoint[key]);this.lastFrames=[];delete this.pendingWait;};
  this.cancelFailedInput=cancel;
  const messages=[],actions=[],units=[],projectedErrors=new Set();this.lastFrames=[];this.openingPending=false;let lexed,index=0,mode=1,lastOutcome=null;
  try{
   const repeat=input.trim()==='@'&&!this.pending;
   if(input.trim()==='@')input=this.pending?'':this.lastInput||'';
   if(this.world.display){if(repeat)this.sourceDisplay.repeat();else this.sourceDisplay.command(normalizeInput(input));}
   // D6C8 clears the transient @ token-reuse flag after accepted input,
   // before lexical validation or any paid actor visit.
   if(this.world.npcs)this.world.npcs.editorTokenFlag=0;
   this.lastInput=input;lexed=this.lexer.scan(input);this.sourceDisplay.lexicalWorkspace(lexed.workspaceCopies);if(this.world.npcs&&lexed.lookupState)this.world.npcs.lexicalMatch=lexed.lookupState;this.currentInputEnd=0x5B81+lexed.tokens.slice(0,-1).reduce((n,t)=>n+([128,160,176,192].includes(t.type)?1:3),0);if(this.world.display)this.sourceDisplay.lexed(lexed.tokens);
   this.analysis={input,normalised:lexed.normalized,outcome:'ok',units,actions};
   while(index<lexed.tokens.length&&lexed.tokens[index].type!==192){
    if(index&&lastOutcome&&this.world.npcs)this.npcRuntime.playerInputFailures(lastOutcome.collectiveExhausted?['9937','992D']:['992D'],messages,actions);
    const pendingBefore=this.pending,parsed=this.parser.unit(lexed.tokens,index,{pending:pendingBefore,mode,onNominal:this.world.npcs?group=>this.npcRuntime.nominal(group):null,onCount:this.world.npcs?value=>{this.world.npcs.parserCount=value;}:null});index=parsed.next;mode=parsed.mode;units.push(...parsed.nodes);this.pending=null;
    if(parsed.outcome==='control'){
     this.pending=pendingBefore;const control=parsed.control;this.analysis.control=control;(this.analysis.controls??=[]).push(control);if(this.world.npcs&&(!pendingBefore||control==='save'))this.npcRuntime.use(({records})=>{const p=this.npcRuntime.syntaxRecord({verb:0,modifier:0,groups:[],subject:null},records);if(control==='quit')records.heads.syntax=p;else records.arena.release(p);});
     if(!['pause','print','noprint','save','load','quit'].includes(control))throw new UnsupportedFeature('controllo '+control+' (porta nastro non ancora collegata)');
     if(control==='quit'){if(this.world.npcs)this.world.npcs.playerProgramCounter='9932';this.ended={entry:'B0A6',reason:'quit'};break;}
     if(control==='load')break;
     if(control==='save'){const saved=this.world.npcs.playerRootSaved;this.world.npcs.playerProgramCounter='9923';this.advance(1,{action:saved[0],args:saved.slice(1),messages,actions,preservePlayerStage:true});if(this.ended)break;delete this.analysis.control;if(!pendingBefore)continue;parsed.reusePending=true;}
     if(control==='pause')messages.push({kind:'narrative',text:'',screen_pause:true});
     if(control==='print')this.world.npcs.printerEnabled=this.printerConnected!==false;
     if(control==='noprint'){for(let i=0;i<18;i++){this.sourceDisplay.feed('\n');this.world.display.counter=0;}this.world.npcs.printerEnabled=false;messages.push({kind:'narrative',text:'',screen_clear:true});}
     if(!pendingBefore)break;
     delete this.analysis.control;parsed.nodes=[structuredClone(pendingBefore.node)];parsed.continuationAnswer={verb:0,modifier:0,groups:[],subject:null};parsed.next=lexed.tokens.length-1;index=parsed.next;this.pending=null;
    }
    const pointers=this.world.npcs?this.npcRuntime.beginUnit(parsed.nodes,{answer:parsed.continuationAnswer,lookahead:parsed.lookahead,discarded:parsed.discarded,reusePending:parsed.reusePending}):[];
    for(const [nodeIndex,originalNode]of parsed.nodes.entries()){if(originalNode.exclusion)continue;let syntaxAllocated=false;
     try{
     if(this.world.npcs){this.npcRuntime.parsed(originalNode,{retain:this.needsClarification(originalNode),collective:originalNode.all,pointer:pointers[nodeIndex]});syntaxAllocated=true;}
     for(const node of this.collective(originalNode)){
     const before=this.world.dump(),messageCount=messages.length,actionCount=actions.length,frameCount=this.lastFrames.length;let outcome;
     try{outcome=this.execute(node);lastOutcome=outcome;
      const paragraph=(outcome.cost||outcome.objectRule)&&!outcome.suppressParagraph&&outcome.messages.find(m=>m.kind==='narrative');if(paragraph)paragraph.paragraph_before=true;
      messages.push(...outcome.messages);
      if(this.world.display){const errors=outcome.messages.filter(m=>m.kind==='error');if(errors.length){this.sourceDisplay.error(errors,{inline:Boolean(this.pending)});for(const e of errors)projectedErrors.add(e);}}
      if(!outcome.projected)this.projectMessages(outcome.messages);
      if(this.world.npcs&&(outcome.cost||outcome.action===32||outcome.semanticResolved))this.npcRuntime.playerAction(outcome);
      if(outcome.objectRule){actions.push({actor:this.world.player,id:outcome.action,arguments:outcome.args});this.npcRuntime.executePlayerObject(outcome.objectRule,outcome.action,outcome.args,messages,actions);}
      else if(outcome.cost){actions.push({actor:this.world.player,id:outcome.action,arguments:outcome.args});this.advance(outcome.cost,{action:outcome.action,args:outcome.args,messages,actions});}}
     catch(error){this.world.restore(before);if(before.npcs?.parserPending)this.pending=clone(pendingBefore);messages.length=messageCount;actions.length=actionCount;this.lastFrames.length=frameCount;throw error;}

     if(this.ended)break;
     if(originalNode.all&&outcome?.messages.some(m=>m.kind==='error')&&this.world.npcs)this.npcRuntime.playerInputFailures([outcome.semanticResolved?'9945':'9937'],messages,actions);
     if(this.ended)break;
     if(this.pending){this.analysis.outcome='clarification';if(this.world.npcs&&!this.world.npcs.parserPending)throw new UnsupportedFeature('durata dei record per questo chiarimento');break;}
     }
     }finally{if(this.world.npcs&&originalNode.all&&syntaxAllocated&&!this.ended)this.npcRuntime.finishCollective();}
     // D85B/D86D returns failure after ALL exhausts its search, even when
     // the final selected action succeeded. It counts as a DOMAIN failure.
     if(originalNode.all&&!this.pending)lastOutcome={...(lastOutcome||{messages:[],action:this.action(originalNode)}),collectiveExhausted:true};
     if(this.pending||this.ended||lastOutcome?.messages.some(m=>m.kind==='error')&&!originalNode.all)break;
    }
    if(this.pending||this.ended||lastOutcome?.messages.some(m=>m.kind==='error')){if(this.world.display&&!this.ended){const at=lexed.tokens.slice(0,index).reduce((n,t)=>n+([128,160,176,192].includes(t.type)?1:3),0);this.world.display.tokens[at]=192;}if(this.world.npcs&&this.pending)this.npcRuntime.discardParsed();break;}
   }
  }catch(error){
   if(error instanceof InputError&&error.kind==='tool_limit'){cancel();this.analysis={input,outcome:'not_translated',feature:'editor-boundary',notice:error.message,units:[],actions:[]};messages.length=0;messages.push({kind:'system',text:error.message});}
   else if(error instanceof InputError){this.sourceDisplay.lexicalWorkspace(error.detail.workspaceCopies);if(this.world.npcs&&error.detail.lookupState)this.world.npcs.lexicalMatch=error.detail.lookupState;if(this.world.npcs&&['syntax_error','quoted_syntax_error'].includes(error.kind)){if(error.detail.partialNodes)this.npcRuntime.failedParse(error.detail.partialNodes);else this.npcRuntime.invalidateParserProjection();this.pending=null;}this.analysis={input,normalised:lexed?.normalized,outcome:error.kind,units,actions};messages.push({kind:error.kind==='tool_limit'?'system':'error',text:error.message.replaceAll('`','£')});}
   else{cancel();messages.length=0;actions.length=0;
    if(error instanceof UnsupportedFeature||error instanceof RandomInputsUnavailable){this.analysis={input,normalised:lexed?.normalized,outcome:'not_translated',feature:error.feature??'original-random-input',notice:error.message,...(error instanceof RandomInputsUnavailable?{recovery:'requires-engine-update',missing_address:error.address??null}:{}),units,actions};messages.push({kind:'system',text:error.message});}
    else throw error;
   }
  }
  if(this.ended)this.analysis.outcome='game_over';
  if(this.world.display&&this.analysis.outcome!=='not_translated'&&!this.ended&&!this.pendingWait)try{
   if(messages.some(m=>m.kind==='error'&&!m.lower_projected&&!projectedErrors.has(m)))this.sourceDisplay.error(messages.filter(m=>m.kind==='error'&&!m.lower_projected&&!projectedErrors.has(m)),{inline:this.analysis.outcome==='clarification'});
   if(this.world.npcs){const syntax=Boolean(this.analysis.control)||['syntax_error','lexical_error','quoted_syntax_error'].includes(this.analysis.outcome),failed=lastOutcome?.collectiveExhausted||lastOutcome?.messages.some(m=>m.kind==='error')&&lastOutcome.action!==32;
    this.npcRuntime.playerInputFailures(syntax?['9923']:failed?[lastOutcome?.semanticResolved?'9945':'9937','992D','9923']:['992D','9923'],messages,actions);if(!this.pending&&!this.ended)this.npcRuntime.discardParsed();}
   if(!this.ended)this.sourceDisplay.prompt();
  }catch(error){cancel();messages.length=0;actions.length=0;if(error instanceof UnsupportedFeature||error instanceof RandomInputsUnavailable){this.analysis={input,outcome:'not_translated',notice:error.message,units:[],actions:[]};messages.push({kind:'system',text:error.message});}else throw error;}
  if(this.ended)this.analysis.outcome='game_over';
  if(this.pendingWait)this.pendingWait.cancelInput=cancel;
  if(this.pending)this.analysis.continuation_slot=this.pending.slot;
  return {state:this.state(),messages};
 }
 advance(cost,{action,args,messages,actions,preservePlayerStage=false}){
  if(this.world.npcs){this.world.npcs.playerFailures=0;if(!this.world.npcs.playerLocal&&!preservePlayerStage)this.world.npcs.playerProgramCounter='9945';}
  if(this.streamWait&&this.world.npcs&&action===50){this.pendingWait={cost,action,args,paid:false,messages,actions};this.world.npcs.playerProgramCounter='9945';return;}

  const driver=this.world.npcs?this.npcRuntime.driver(messages,actions):this.watson.driver(messages,actions);
  driver.clock=()=>this.lastFrames.push({clock:this.world.clock(),world:this.world.dump(),messageCount:messages.length,actionCount:actions.length});
  this.world.consume(cost,{action,args,driver});
 }
 canStreamWait(input){
  if(!this.world.npcs)return false;
  try{const parsed=this.parser.analyze(input.trim()==='@'?this.lastInput||'':input);return parsed.units.length===1&&parsed.units[0].nodes.length===1&&this.action(parsed.units[0].nodes[0])===50;}catch{return false;}
 }
 continueWait({interrupt=false}={}){
  const wait=this.pendingWait;if(!wait)throw Error('Nessuna attesa in corso.');
  const w=this.world,s=w.scheduler,driver=this.npcRuntime.driver(wait.messages,wait.actions);
  if(interrupt&&wait.paid){s.actors[0].due=s.tick;s.emit({event:'wait_interrupt'});}
  const result=s.run({
   prepare:(actor,scheduler)=>driver.prepare(actor,scheduler),
   step:(actor,context,scheduler)=>{if(actor===s.actors[0]){if(wait.paid)return {type:'input'};wait.paid=true;actor.savedAction=wait.action;actor.savedArgs=[...wait.args];return {cost:wait.cost};}return driver.step(actor,context,scheduler);},
   callback:driver.callback,clock:()=>({type:'pause'})
  });
  if(result.type==='ended'){delete this.pendingWait;this.analysis.outcome='game_over';const entry=this.history.entries.findLast(e=>e.kind==='command');if(entry)this.history.finish(entry,w,{outcome:'game_over'});return {running:false,messages:wait.messages};}
  if(result.type==='pause')return {running:true,messages:wait.messages};
  if(result.type!=='input')throw new UnsupportedFeature('continuazione dell’attesa');
  this.npcRuntime.playerInputFailures(['992D','9923'],wait.messages,wait.actions);if(this.ended)this.analysis.outcome='game_over';else this.sourceDisplay.prompt();delete this.pendingWait;
  const entry=this.history.entries.findLast(e=>e.kind==='command');if(entry)this.history.finish(entry,w,{outcome:this.analysis.outcome});
  if(interrupt){const event=this.history.begin('interrupt',w.clock().label,w);this.history.finish(event,w);}
  return {running:false,messages:wait.messages};
 }
 scene(){const before=this.world.dump();try{return this.text.scene({full:!this.world.dark()});}finally{this.world.restore(before);}}
 state(){const w=this.world,room=w.rooms[w.roomOf()],dark=w.dark();
  return {printer:{enabled:Boolean(w.npcs?.printerEnabled),rows:w.display?.printerPaper?.length||0},room:room.id,name:room.name,clock:w.clock(),player_id:w.player,seed:w.npcs?.initialSeed??null,start_mode:this.startMode,visited:[...w.explored],native_seen:w.rooms.filter(r=>r.flags&64).map(r=>r.id),exits:room.exits.map(e=>({...e,target_name:w.rooms[e.target]?.name,status:!e.gate?'libera':w.entity(e.gate).attributes&40?'aperta / attraversabile':'chiusa / ostacolo'})),objects:w.lastListed.map(id=>({id,name:w.entity(id).name})),visible:w.entities.filter(e=>e.id!==w.player&&!dark&&w.perceived(e.id)).map(e=>({id:e.id,name:e.name})),characters:w.entities.filter(e=>this.data.entities[e.id].person&&(![0,1,100].includes(e.id)||e.id===w.player)).map(e=>({id:e.id,key:e.id===w.player?'player':String(e.id),name:e.id===w.player?'Sherlock Holmes':e.name,badge:characterBadge(e,w.player),rooms:e.rooms.filter(id=>id>0),parent_id:e.parent,is_player:e.id===w.player})),dark,initial:this.scene(),opening:this.openingPending?this.opening:null,opening_screen:null,analysis:this.analysis,game_over:this.ended,ending_messages:[],command_running:false,prototype_notice:this.analysis?.notice??null,engine:'javascript-autonomous',ai:w.npcs?'domain-programs-partial':w.scheduler.actor(3).enabled?'watson-partial':'not-translated',npc_profile:w.npcs?.profile??w.scheduler.actor(3).behavior?.profile??null,greeting_variant:w.npcs?'original-arithmetic-shared-world':w.random?'original-arithmetic-historical-watson':'unimplemented-original-random-source',random_state:w.random?{profile:w.random.profile,accumulator:w.random.seed,cursor:w.random.cursor,draws:w.random.draws}:null,fidelity:{status:'partial-functional-rewrite',original_seed_parity:false,full_game_equivalence:false},cab_scope:w.npcs?'service-program-journey-fare-refund':'arrival-and-containment',scheduler:{active:w.scheduler.actors.filter(a=>a.enabled).map(a=>a.id),actors:clone(w.scheduler.actors),phase:w.scheduler.phase,index:w.scheduler.index,requests:clone(w.scheduler.requests),signals:clone(w.scheduler.signals),events:clone(w.scheduler.trace.slice(-64))}};
 }
 teleport(room){if(this.ended)return {state:this.state(),messages:[]};if(!Number.isInteger(room)||room<1||room>=this.world.rooms.length)throw Error('Invalid location');const entry=this.history.begin('teleport',String(room).padStart(3,'0')+' · '+this.world.rooms[room].name,this.world);try{const out=this.teleportWorld(room);this.history.finish(entry,this.world,{outcome:out.messages.some(m=>m.kind==='system')?'not_translated':'ok',errors:out.messages.filter(m=>m.kind==='system').map(m=>m.text)});return out;}catch(error){this.history.finish(entry,this.world,{outcome:'exception',errors:[error.message]});throw error;}}
 teleportWorld(room){const before=this.world.dump();try{this.pending=null;this.openingPending=false;this.world.move(this.world.player,room);this.world.explored.add(room);this.world.rooms[room].flags|=64;const scene=this.text.scene({full:!this.world.npcs}),messages=[{kind:'narrative',text:scene,image_room:room}];this.projectMessages(messages);return {state:this.state(),messages};}catch(error){this.world.restore(before);if(error instanceof UnsupportedFeature)return {state:this.state(),messages:[{kind:'system',text:error.message}]};throw error;}}
 dump(){if(this.pendingWait)throw Error('Interrompi l’attesa prima di salvare.');return {format:'sherlock-js-save',version:this.world.npcs?5:4,source_sha256:this.data.source_sha256,world:this.world.dump(),pending:clone(this.pending),analysis:clone(this.analysis),lastInput:this.lastInput,ended:clone(this.ended),openingPending:this.openingPending,opening:this.opening,startMode:this.startMode,conversation:clone(this.conversation),command_history:this.history.dump()};}
 static load(data,save){
  if(save?.format!=='sherlock-js-save'||![1,2,3,4,5].includes(save.version)||save.source_sha256!==data.source_sha256)throw Error('Questo file non è un salvataggio del motore JavaScript autonomo.');
  if(save.version>=2&&!save.world?.scheduler)throw Error('Salvataggio privo dello scheduler.');
  if(save.version<5&&save.world?.scheduler?.actors?.some(a=>a.enabled&&a.id!==0&&(a.id!==3||save.version<3)))throw Error('Questo salvataggio richiede programmi NPC non ancora tradotti.');
  if((save.version===5)!==Boolean(save.world?.npcs))throw Error('Profilo del salvataggio NPC non valido.');
  const s=save.world;if(!s||!Array.isArray(s.entities)||s.entities.length!==110||!Array.isArray(s.rooms)||s.rooms.length!==106||!Number.isInteger(s.tick)||s.tick<0||s.tick>65535||!Number.isInteger(s.playerDue)||s.playerDue<0||s.playerDue>65535||!Number.isSafeInteger(s.minutes)||s.minutes<0||!Number.isInteger(s.player)||s.player<0||s.player>=110)throw Error('Salvataggio JS incompleto.');
  if(![0,1,100].includes(s.player)||(s.scheduler?.actors[0].id??0)!==s.player)throw Error('Identità del giocatore incoerente.');
  for(const [i,e] of s.entities.entries())if(e.id!==i||!Array.isArray(e.rooms)||!e.rooms.every(r=>Number.isInteger(r)&&r>=0&&r<106)||e.parent!==null&&(!Number.isInteger(e.parent)||e.parent<0||e.parent>=110))throw Error('Entità nel salvataggio non valida.');
  for(const e of s.entities){const seen=new Set([e.id]);let parent=e.parent;while(parent!==null){if(seen.has(parent))throw Error('Ciclo nei contenitori del salvataggio.');seen.add(parent);parent=s.entities[parent].parent;}}
  RuntimeRandom.validate(s.random);RandomDisplay.validate(s.display);if(Boolean(s.random)!==Boolean(s.display))throw Error('Salvataggio casuale privo dello stato sorgente completo.');if(save.version<4&&s.random)throw Error('Stato casuale inatteso in un salvataggio precedente.');
  const g=new Game(data,{start_mode:save.startMode,npcs:false});g.world.restore(s);g.configureRandom();for(const key of ['pending','analysis','lastInput','ended','openingPending','opening','conversation'])g[key]=clone(save[key]);g.history=CommandHistory.load(save.command_history,g.historyMeta());if(s.npcs){g.runtimeRandom.projector=a=>g.npcRuntime.read(a);g.npcRuntime.validate();}else g.watson.validateState();g.cab.validateState();g.state();return g;
 }
}
