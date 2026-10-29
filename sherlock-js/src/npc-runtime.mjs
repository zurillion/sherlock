import {WorldSource} from './world-source.mjs';
import {NpcProgram} from './npc-program.mjs';
import {RecordLists,RECORD_HEADS} from './record-arena.mjs';
import {NpcPrimitives} from './npc-primitives.mjs';
import {UnsupportedFeature,DIRECTION_NAMES} from './world.mjs';
import {CabRoutes,account,balance,transferMoney,formatMoney,encodeMoney,wrapMoney} from './cab-economy.mjs';
import {nodeWords} from './parser.mjs';
import {searchDescription} from './description-search.mjs';
import {specialObjectBody} from './special-objects.mjs';
import {Information} from './information.mjs';
import {runPlayerProgram} from './player-program.mjs';
import {changeNpcIdentity} from './identity.mjs';
import {ArgumentChecks} from './argument-checks.mjs';
import {AdvancedNpcs} from './advanced-npcs.mjs';

const yes=(cost=0,extra={})=>({success:true,cost,...extra}),no=()=>({success:false,cost:0});
const clone=structuredClone;

// Host for the game's DOMAIN programs. Each named rule below is a functional
// translation of its contract; source labels are provenance, not CPU dispatch.
export class NpcRuntime {
 constructor(game){this.game=game;this.checks=new ArgumentChecks(this);this.information=new Information(this);this.advanced=new AdvancedNpcs(this);this.active=null;this.worldSource=new WorldSource(game.data,game.world);this.routes=new CabRoutes(game.data.cab.routes);this.sourceBytes=new Map([...game.data.randomInputs.npcBytes,...game.data.randomInputs.ruleBytes]);}
 get w(){return this.game.world;}
 get state(){return this.w.npcs;}
 setClarificationOffset(value){if(![0,8,18].includes(value))throw Error('Invalid clarification offset');this.state.clarificationOffset=value;}
 // A01F/A020 is shared across operations, not an actor-local duration.
 // DDC5 writes only its low byte; old saves retain unknown untouched cells.
 temporaryCost(value,{lowOnly=false}={}){const cells=this.state.temporaryCost??=[null,null];cells[0]=value&255;if(!lowOnly)cells[1]=(value>>>8)&255;}

 use(operation){
  if(this.active)return operation(this.active);
  const state=this.state,vm=new NpcProgram(this.game.data.npcPrograms,this.w.scheduler),records=RecordLists.load(state.records);
  vm.restore(state.program);const primitives=new NpcPrimitives(this.w),runtime={vm,records,primitives};this.active=runtime;
  try{return operation(runtime);}finally{state.program=vm.dump();state.records=records.dump();this.active=null;}
 }
 initialize(seed=1){
  if(!Number.isInteger(seed)||seed<0||seed>255)throw Error('Il seed deve essere un intero da 0 a 255.');
  const g=this.game,w=this.w,vm=new NpcProgram(g.data.npcPrograms,w.scheduler),records=new RecordLists();
  w.npcs={version:1,profile:'world-v5',clarificationOffset:0,program:null,records:records.dump(),pending:{},foreignContexts:{},playerRootSaved:[255,255,255],information:{he:Array(6).fill(0),it:Array(6).fill(0),addressee:[0x71,9,0,0,0,0]},burningNoteTicks:15,flags:{strakerMet:false,lestradeMet:false,brownClueFound:false,jonesClueFound:false,burningNoteFound:false},encounters:{2:[0,0,0],3:[30,0,0],4:[0,0],11:[0,0,0],12:[0,0,0]},literal:0};
  for(const root of g.data.npcPrograms.actors){vm.start(root.id,root.entry);const a=w.scheduler.actor(root.id);a.enabled=true;a.program='domain';a.due=0;a.behavior=null;}
  w.npcs.program=vm.dump();w.random={version:1,profile:'world-v5',seed,cursor:0,draws:0,trace:[]};g.configureRandom();
  w.npcs.facts=clone(this.worldSource.layout.facts);
  w.npcs.information.verification={recognized:0,unproven:0,lastFact:0};
  w.npcs.information.resolution={cursors:[0,0],verb:0,triple:[0,0,0]};w.npcs.lexicalMatch=[0,0];w.npcs.parserCount=g.data.randomInputs.bootOptions.initialParserCount??null;w.npcs.parserAll=g.data.randomInputs.bootOptions.initialParserAll??null;w.npcs.editorTokenFlag=g.data.randomInputs.bootOptions.initialEditorTokenFlag??null;
  w.npcs.argumentCheck=g.data.argumentChecks?.initialValue??null;w.npcs.initialSeed=seed;w.npcs.argumentClasses=[0,0];w.npcs.argumentPointers=[null,null];
  // Graphics are presentation-only in the declared text-only source profile.
  // F490/F507 are its only colour writers; neither runs after this boot.
  w.npcs.nativeFillColor=g.data.randomInputs.bootOptions.initialFillColor;
  // The declared source protocol disables original bitmap drawing after
  // boot. SVG/pixel display preferences do not change that world input.
  w.npcs.nativeGraphicsEnabled=false;
  w.npcs.printerEnabled=g.data.randomInputs.bootOptions.printerEnabled;
  w.npcs.recordsSourceKnown=true;
  w.npcs.playerFailures=0;
  w.npcs.playerProgramCounter='9923';
  w.npcs.parserPending=null;
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
 prepare(actor){if(actor.id===this.w.player)return {};return this.use(({vm})=>{if(this.state.pending[actor.id]&&!this.w.scheduler.requests.some(r=>r.recipient===actor.id))this.w.scheduler.requests.unshift({sender:this.state.pending[actor.id].sender,recipient:actor.id,command:{continuation:true}});vm.prepare(actor.id);return {};});}
 driver(messages,actions){return {prepare:a=>this.prepare(a),step:a=>this.step(a,messages,actions),callback:(a,c,s,old)=>this.callback(a,old,messages)};}
 step(actor,messages,actions){return this.use(runtime=>{const result=runtime.vm.step(actor.id,this.environment(runtime,messages,actions));if(runtime.identityChange!==undefined){changeNpcIdentity(this,actor.id,runtime.identityChange);delete runtime.identityChange;}return result;});}
 environment(runtime,messages,actions){const {vm,records}=runtime;return {
  beginStep:()=>this.temporaryCost(0),
  forcedCost:value=>this.temporaryCost(value),
  enterContext:({actor,frame})=>records.prepend('contexts',[actor,parseInt(frame.origin,16)&255,parseInt(frame.origin,16)>>>8,frame.saved[1],frame.saved[2],frame.request?2:1,frame.saved[0]]),
  leaveContext:({frame})=>{const p=records.remove('contexts',frame.record);if(!this.state.recordsSourceKnown&&!p&&(records.heads.requests||records.heads.syntax))throw new UnsupportedFeature('metadati dei contesti dopo questo percorso del parser');return records.returnSaved(p);},
  foreignContext:({actor,frame})=>(this.state.foreignContexts[actor]??=[]).push(frame),
  signalSend:(sender,recipient)=>records.prepend('signals',[sender,recipient]),
  signalTake:(recipient,sender)=>{const p=records.records('signals').find(p=>records.arena.byte(p)===sender&&records.arena.byte(p+1)===recipient);if(!p)throw Error('Segnale NPC privo del record');records.remove('signals',p);},
  print:(text,c)=>this.print(text,c.actor,{object:c.saved[1],other:c.saved[2]},messages),
  // A0A8/A0AF retain two visit words; A0B0 adds its return link. CDA7
  // supplies one text argument, consumed by A66C. Its end cursor is therefore
  // the top minus those three words; A776 leaves that cursor as choice input.
  say:(text,recipient,c)=>{(this.state.argumentClasses??=[null,null])[0]=7;return this.print('6830',c.actor,{object:recipient,textArguments:[text],argumentContexts:[0x5D80-3*2]},messages);},
  // CE10–CE13 prints 682A; its two nested calls reach the proper
  // actor-name prefix at glyph frame 5D2A. Non-proper names stay unknown
  // for the newly owned byte; do not reuse the prefab TELL frame 5D1A.
  order:({actor,recipient,action,args})=>{this.recordRequest(actor,recipient,{kind:'prefabricated',action,args});const e=this.w.entity(actor);this.print('682A',actor,{object:recipient,action,args,...(e.person&&(e.noun&32768)?{actorNameFrame:0x5D2A,actorNameUpper:true,preserveGlyphFlags:[29,30].includes(action)}:{})},messages);},
  request:(r,c)=>this.request(r,c,messages,actions),
  rule:(name,args,c)=>this.rule(name,args,c,messages,actions),
  action:(action,args,c)=>this.action(action,args,c,messages,actions)
 };}
 print(text,actor,context,messages,{force=false}={}){
  if(this.state.executionPhase===0)this.state.announcementMode=0; // A5AD..A5B3.
  // CC37/C821 select the output by perception; successful NPC speech is
  // still printed in darkness (A2E4 only rejects dark failure output).
  const g=this.game,visible=force||this.w.perceived(actor);
  const c=visible?g.npcTextContext(actor,{preserveFlags:context.preserveGlyphFlags===true}):{};if(visible&&context.actorNameFrame)c.actorNamePrefix=write=>{const previous=g.sourceDisplay.glyphFrame,upper=g.sourceDisplay.upperGlyphKnown;g.sourceDisplay.glyphFrame=context.actorNameFrame;g.sourceDisplay.upperGlyphKnown=context.actorNameUpper===true;try{write();}finally{g.sourceDisplay.glyphFrame=previous;g.sourceDisplay.upperGlyphKnown=upper;}};c.bufferVisible=visible;c.bufferSink=(ch,options)=>g.sourceDisplay.bufferFeed(ch,options);
  if(force&&!c.sink){c.characters=[];c.sink=ch=>{c.characters.push(ch);g.sourceDisplay.feed(ch,{buffer:false});};}
  const value=g.text.render(text,{...context,...c,actor});if(visible)messages.push(g.textMessage(value,c));return value;
 }
 inspect(id,actor,messages){
  const start=messages.length,g=this.game,e=this.w.entity(id);e.status|=64;
  if(!g.text.examinePreservesLowScratch(e.description))g.sourceDisplay.invalidateScratch();else g.sourceDisplay.invalidateScratch(0x5D12);
  const c=g.npcTextContext(actor);let text;
  if(e.description)text=g.text.render(e.description,{...c,actor,object:id});
  else{text='You see '+this.w.name(id,{indefinite:true})+'.';if(c.sink)for(const ch of text)c.sink(ch);}
  if(c.sink)messages.push(g.textMessage(text,c));
  return start;
 }
 finishObjectLine(messages,start){
  this.game.sourceDisplay.feed('\n');
  const parts=messages.splice(start);if(parts.length)messages.push({kind:'narrative',text:parts.map(m=>m.text).join(' '),raw_text:parts.map(m=>m.raw_text??m.text).join('')+'\n'});
 }
 runPlayerObject(program,action,args,messages,actions){
  const actor=this.w.player,saved=[action,args[0]??255,args[1]??255];
  const job={pc:program,saved,record:this.use(({records})=>records.prepend('contexts',[actor,0x41,0x99,saved[1],saved[2],1,action]))};
  this.state.playerLocal=job;this.state.playerProgramCounter=program;
  for(let guard=0;guard<100;guard++){
   const op=this.game.data.npcPrograms.instructions[job.pc];if(!op)throw new UnsupportedFeature('sequenza oggetto '+job.pc);
   if(op.op==='return.success'){
    this.use(({records})=>{const predecessor=records.remove('contexts',job.record);this.state.playerRootSaved=records.returnSaved(predecessor);});
    delete this.state.playerLocal;this.state.playerProgramCounter='9945';return;
   }
   if(op.op!=='rule')throw new UnsupportedFeature('operazione della sequenza oggetto '+job.pc);
   const values=op.args.map(v=>v===253?saved[1]:v===252?saved[2]:v===250?saved[0]:v===251?this.w.player:v);
   const out=this.use(()=>this.rule(op.rule,values,{actor:this.w.player,saved,local:true},messages,actions));
   if(out.ended)return;
   job.pc=out.success?op.success:op.failure;this.state.playerProgramCounter=job.pc;
   const cost=out.cost||(!out.success&&++this.state.playerFailures===10?1:0);
   if(cost)this.game.advance(cost,{action:saved[0],args:saved.slice(1),messages,actions});
   if(this.game.ended)return;
  }
  throw new UnsupportedFeature('sequenza oggetto senza termine');
 }
 executePlayerObject(rule,action,args,messages,actions){
  const meta=this.game.data.npcPrograms.rules[rule];if(['unimplemented.E452','move.adjacent'].includes(rule))return runPlayerProgram(this,meta.program,action,args,messages,actions);if(meta.program)return this.runPlayerObject(meta.program,action,args,messages,actions);
  const out=this.use(()=>this.rule(rule,[args[0]??255,args[1]??255],{actor:this.w.player,saved:[action,args[0]??255,args[1]??255],local:true},messages,actions));
  if(out.ended)return;
  this.state.playerProgramCounter='9945';
  if(out.cost)this.game.advance(out.cost,{action,args,messages,actions});
 }
 recordRequest(sender,recipient,command){
  // NpcProgram has already inserted prefab requests into the typed queue.
  const request=this.w.scheduler.requests.find(r=>r.sender===sender&&r.recipient===recipient&&!r.record);
  const p=this.active.records.prepend('requests',[recipient,255,command.action,...command.args,0,0,0]);if(request)request.record=p;
 }
 queue(sender,recipient,nodes,mode=nodes[0]?.subject?2:1){
  this.use(({records})=>{const syntax=nodes.map(n=>this.syntaxRecord(n,records));for(let i=0;i<syntax.length;i++)records.arena.putWord(syntax[i]-2,syntax[i+1]||0);const p=records.prepend('requests',[recipient,0,0,0,0,syntax[0]&255,syntax[0]>>>8,mode]);this.w.scheduler.sendRequest(sender,recipient,{nodes,syntax,mode});this.w.scheduler.requests[0].record=p;});
 }
 // AC24 clears the nominal workspace; AC8F/AC94 and AC84 populate it.
 nominal(group){this.state.parserNominal=[group.relations[0]||0,group.relations[1]||0,group.noun||0,group.qualifiers[0]||0,group.qualifiers[1]||0].flatMap(v=>[v&255,v>>>8]);}
 writeSyntax(node,records,p){nodeWords(node).forEach((v,i)=>records.arena.putWord(p+2*i,v));}
 syntaxRecord(node,records){const p=records.arena.allocate(30);this.writeSyntax(node,records,p);return p;}
 beginUnit(nodes,{answer=null,lookahead=null,discarded=[],reusePending=false}={}){return this.use(({records})=>{
  const pending=this.state.parserPending;if(reusePending&&pending){records.heads.syntax=0;records.heads.parsed=pending;this.state.parserPending=null;return [pending];}const raw=nodes.map((n,i)=>i===0&&answer?answer:n),pointers=[];
  const allocations=[];
  const allocate=n=>{const p=this.syntaxRecord(n,records);if(allocations.length)records.arena.putWord(allocations.at(-1).pointer-2,p);allocations.push({pointer:p,discarded:false});this.recordQuotes(n,records);return p;};
  for(const [i,n]of raw.entries()){for(const d of discarded.filter(d=>d.before===i)){allocate(d.node);allocations.at(-1).discarded=true;}pointers.push(allocate(n));}
  for(const [i,a]of allocations.entries())if(a.discarded){records.arena.putWord(allocations[i-1].pointer-2,allocations[i+1]?.pointer||0);records.arena.putWord(a.pointer-2,0); /* AEEA leaves this orphan allocated. */}
  if(lookahead){const temp=this.syntaxRecord(lookahead,records);if(pointers.length)records.arena.putWord(pointers.at(-1)-2,temp);records.arena.release(temp);if(pointers.length)records.arena.putWord(pointers.at(-1)-2,0);}
  if(pending&&pointers.length){
   records.arena.putWord(pending-2,pointers[0]);
   if(answer&&!answer.verb){this.writeSyntax(nodes[0],records,pending);records.arena.putWord(pending-2,pointers[1]||0);records.arena.release(pointers[0]);pointers[0]=pending;}
   else records.arena.release(pending);
  }else if(answer)this.state.recordsSourceKnown=false;
  for(let i=0;i<nodes.length;i++)this.writeSyntax(nodes[i],records,pointers[i]);
  records.heads.syntax=0;records.heads.parsed=pointers[0]||0;this.state.parserPending=null;return pointers;
 });}
 discardParsed(){this.use(({records})=>{while(records.heads.parsed)records.remove('parsed',records.heads.parsed);});}
 popParsed(){this.use(({records})=>{if(records.heads.parsed)records.remove('parsed',records.heads.parsed);while(records.heads.parsed&&(records.arena.byte(records.heads.parsed+1)&64))records.remove('parsed',records.heads.parsed);});}
 parsed(node,{retain=false,collective=false,answer=null,pointer=null}={}){
  if(pointer===null)pointer=this.beginUnit([node],{answer})[0];
  this.use(({records})=>{
  const current=pointer;
  if(retain){records.heads.syntax=current;this.state.parserPending=current;records.heads.parsed=records.arena.word(current-2);records.arena.putWord(current-2,0);}
  node=this.game.semanticNode(node);
  const action=this.game.action(node);let rejected=(!!node.implicitMissing||this.game.action(node)===52)&&!retain&&!collective;this.state.sceneryFailure=null;
  if([14,17,18,19,20,21,22,26,27,29,30,35,36,38,39,42,43,44,45,46,47,48,51,53,54].includes(action)&&!retain&&!collective){for(let slot=0;slot<node.groups.length;slot++){const group=node.groups[slot];if(group.noun&32768||!group.noun&&!group.qualifiers.length)break;const candidates=this.game.referenceCandidates(node,action,slot);if(!candidates.possible.length){this.state.sceneryFailure={action,slot,found:searchDescription(this.game.data,this.w,records,group,this.w.player)};rejected=true;break;}if(candidates.possible.length>1)break;}}
  // A failed class-9 lookup with no perceived nominal target searches the
  // room description, just like other absent references. A visible object
  // rejected by the TAKE predicate retains its separate execution refusal.
  if([11,23,41].includes(action)&&!retain&&!collective){const group=node.groups[0],candidates=this.game.referenceCandidates(node,action,0);if(group&&!candidates.possible.length&&!candidates.nominal.some(e=>this.w.perceived(e.id)&&!e.person&&e.rooms.length===1&&!this.w.owns(this.w.player,e.id))){this.state.sceneryFailure={action,slot:0,found:searchDescription(this.game.data,this.w,records,group,this.w.player)};rejected=true;}}
  if(rejected)this.state.parserRejected=current;
  else if(!retain&&!collective){this.popParsed();}
 });}

 recordQuotes(node,records){for(const quote of(node.quotes||[node.quote]).filter(Boolean)){records.append('quotes',[quote.tokenPointer&255,quote.tokenPointer>>>8]);this.game.sourceDisplay.quoted(quote);}}
 consumeQuote(){return this.use(({records})=>{
  const p=records.heads.quotes;if(!p)return null;
  const pointer=records.arena.word(p);records.remove('quotes',p);
  const bytes=this.w.display.tokens,tokens=[];let at=pointer-0x5B81;
  for(let guard=0;guard<128&&at<bytes.length;guard++){
   const start=at,type=bytes[at++],size=[128,160,176,192].includes(type)?1:3,value=size===1?0:(bytes[at++]<<8)|bytes[at++],word=this.game.dictionary.word(value)?.stem??null;
   tokens.push({type,value,word,start,end:at,source:word??''});
   if(type===192){if(0x5B81+start===this.game.currentInputEnd)throw new UnsupportedFeature('citazione residua che ripristina il terminatore della riga: scansione originale oltre i buffer');bytes[start]=144;break;}
  }
  if(tokens.at(-1)?.type!==192)tokens.push({type:192,value:0,word:null});
  return {tokens,tokenPointer:pointer};
 });}
 consumeQuotes(){return this.consumeQuote();}

 failedParse(nodes){this.use(({records})=>{
  // AAB2 allocates before parsing. D7B3/D7B6 release both temporary lists
  // on failure, leaving the written bytes (and any quotation nodes) intact.
  for(const node of nodes){const p=this.syntaxRecord(node,records),tail=records.records('syntax').at(-1);if(tail)records.arena.putWord(tail-2,p);else records.heads.syntax=p;this.recordQuotes(node,records);}
  for(const list of ['syntax','parsed'])while(records.heads[list])records.remove(list,records.heads[list]);
  this.state.parserPending=null;
 });}
 failedQuote(nodes){this.use(({records})=>{const temporary=[];for(const node of nodes){const p=this.syntaxRecord(node,records);if(temporary.length)records.arena.putWord(temporary.at(-1)-2,p);temporary.push(p);}for(const p of temporary)records.arena.release(p);});}
 // D835 preserves the current node while ALL's search has more references.
 // The final unsuccessful search (D86A) releases it, after the last paid turn.
 finishCollective(){this.popParsed();}
 addressee(group){if(group)this.state.information.addressee=[group.noun||0,...group.qualifiers,0,0].slice(0,3).flatMap(v=>[v&255,v>>>8&255]);}
 moved(room){this.state.lastRelocationRoom=room;}
 invalidateParserProjection({preserveDisplay=false}={}){this.state.recordsSourceKnown=false;if(!preserveDisplay)this.game.sourceDisplay.invalidateScratch();}
 canHail(vehicle){return this.use(({vm})=>vm.state(vehicle+1).contexts.length===0);}
 hail(vehicle,customer){this.use(runtime=>{
  const s=runtime.vm.state(vehicle+1),origin=s.pc,prior=customer===this.w.player?31:runtime.vm.saved(customer)[0],frame={origin,saved:[prior,customer,vehicle],request:false,external:true,resume:origin};
  frame.record=runtime.records.prepend('contexts',[vehicle+1,parseInt(origin,16)&255,parseInt(origin,16)>>>8,customer,vehicle,2,prior]);s.contexts.push(frame);s.pc='F2B6';
 });}
 request(request,context,messages,actions){
  const state=this.state,actor=context.actor;
  let job=state.pending[actor];
  if(!job){job={sender:request.sender,record:request.record,nodes:request.command.nodes||null,mode:request.command.mode,syntax:request.command.syntax||[],action:request.command.action??null,args:request.command.args??null,index:0,prefab:request.command.kind==='prefabricated'};state.pending[actor]=job;}
  const release=()=>{if(job.record&&this.active.records.records('requests').includes(job.record))this.active.records.remove('requests',job.record);job.record=null;};
  const cancel=(advanceSyntax=false)=>{for(const [i,p]of job.syntax.entries()){if(i<job.index)continue;if(advanceSyntax&&job.record)this.active.records.arena.putWord(job.record+5,job.syntax[i+1]||0);this.active.records.arena.release(p);}release();delete state.pending[actor];};
  if(job.prefab)release();
  while(true){
   let node=job.nodes?.[job.index],action=job.action,args=job.args||[255,255];
   if(job.nodes){if(!node){delete state.pending[actor];return {handled:true,cost:0};}action=this.game.action(node);}
   if(!job.prefab&&context.restriction&&[12,13,21,22,24,25,40,49,50].includes(action)){
    this.print('681A',actor,{object:job.sender},messages);cancel();return {handled:true,cost:0};
   }
   if(job.mode===2||job.mode===undefined&&node?.subject){
    const nodes=job.nodes.slice(job.index),firstMessage=messages.length;if(actor===3)this.information.watson(nodes,messages);else if(actor===2){this.information.lestrade(nodes,messages);
     // BA3E/BB94/BCxx return through additional AF/BC frames. Their
     // deepest established write is 5D02; lower existing cells survive.
     // Unprojected higher fields remain unavailable to future draws.
     this.game.sourceDisplay.invalidateScratch(0x5D02);}
    const parts=messages.splice(firstMessage);if(parts.length)messages.push({kind:'narrative',text:parts.map(m=>m.text).join(' '),raw_text:parts.map(m=>m.raw_text??m.text).join('')});
    cancel();return {handled:true,cost:0};
   }
   const collectiveNode=node?.all?node:null;
   if(collectiveNode){
    const previous=this.game.actingActor;this.game.actingActor=actor;
    try{node=[...this.game.collective(collectiveNode)].find(n=>(n.resolved?.[0]??-1)>(job.collectiveCursor??-1));}finally{this.game.actingActor=previous;}
    if(!node){if(job.record)this.active.records.arena.putByte(job.record+2,0);cancel(true);return {handled:true,cost:0};}
    job.collectiveCursor=node.resolved[0];
   }
   const ctx={...context,request:true,node,sender:job.sender,prefab:job.prefab};
   let result,objectSemantic=false;
   if(node&&![21,22,29,30,45].includes(action)){
    const out=this.game.executeAs(node,actor,{requestRestriction:context.restriction});if(out.requestRefused){this.print('681A',actor,{object:job.sender},messages);this.game.sourceDisplay.invalidateScratch(0x5D06);cancel(true);return {handled:true,cost:0};}objectSemantic=Boolean(out.objectRule);this.showAction(out,actor,messages,actions);result=out.objectRule?this.rule(out.objectRule,[out.args[0]??255,out.args[1]??255],{...ctx,saved:[action,...out.args,255].slice(0,3),isolated:true},messages,actions):{...yes(out.cost,{args:out.args}),success:out.cost>0||action===32};
   }else{
    // B191's failed semantic resolution returns to B9B4/B9AC: an NPC
    // discards the remaining request, without asking the player to clarify.
    if(node){args=this.resolveRequest(node,action,actor);if(!args){cancel(true);return {handled:true,cost:0};}}
    result=this.action(action,args,ctx,messages,actions);
   }
   if(node&&job.record&&(collectiveNode||node.groups.length||[21,22,29,30].includes(action)||objectSemantic)){
    // B973/B976 preserve the exhausted first-argument search iterator.
    // Entity searches end at the index terminator; location searches keep
    // the room ordinal in the high byte (D39B/D3CD), with initial low byte 0.
    const iterator=collectiveNode?0x8B6F+3*job.collectiveCursor:[29,30].includes(action)?this.w.rooms.length<<8:0x8B6F+3*this.w.entities.length;
    if(collectiveNode)this.active.records.arena.putByte(job.record+2,128);
    this.active.records.arena.putWord(job.record+3,iterator);
   }
   if(collectiveNode)return result.defer?result:{handled:true,cost:result.cost};
   if(job.syntax[job.index])this.active.records.arena.release(job.syntax[job.index]);job.index++;
   if(job.record)this.active.records.arena.putWord(job.record+5,job.syntax[job.index]||0);
   if(!job.nodes||job.index>=job.nodes.length){release();delete state.pending[actor];}
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
  if(context.isolated)return;
  const frame=context.local?this.state.playerLocal:this.active.vm.state(context.actor).contexts.at(-1);if(frame?.record){const a=this.active.records.arena;a.putByte(frame.record+3,context.saved[1]);a.putByte(frame.record+4,context.saved[2]);a.putByte(frame.record+6,context.saved[0]);}
 }
 rule(name,input,context,messages,actions){
  const g=this.game,w=this.w,meta=g.data.npcPrograms.rules[name];if(!meta)throw new UnsupportedFeature('contratto NPC '+name);
  this.state.argumentClasses=[...meta.classes];
  this.state.executionPhase=0; // C59B: preflight before enumerating rule arguments.
  // C5B2/C5C5 reject invalid literals before execution. With both
  // arguments specified, C5EB/C5EE reach C5F4 before C989 tests the
  // rule's classes, light and predicate, even when that predicate fails.
  if(meta.classes.some((kind,i)=>[5,6].includes(kind)&&input[i]!==254))return no();
  if(!meta.classes.some((kind,i)=>kind!==0&&input[i]===255))this.state.executionPhase=1;
  const actor=context.actor;
  if(!meta.classes.some((kind,i)=>kind!==0&&input[i]===255))this.projectArguments(input);
  const searching=meta.classes.some((kind,i)=>kind!==0&&input[i]===255);
  const candidates=(value,kind)=>value!==255||kind===0?[value]:Array.from({length:kind<=4?w.rooms.length:w.entities.length},(_,i)=>i);
  for(const first of candidates(input[0],meta.classes[0]))for(const second of candidates(input[1],meta.classes[1])){
   const args=[first,second];this.projectArguments(args);const options={actor,phase:searching?0:1};
   if(!this.checks.rule(meta,args,options)){if(name==='object.open'&&this.checks.failure==='mask')specialObjectBody(this,name,args,context,messages);continue;}
   if(this.predicate(name,args,context)){
    if(searching){this.state.executionPhase=1;if(!this.checks.rule(meta,args,{actor,phase:1}))return no();}
    this.temporaryCost(meta.cost);this.state.executionPhase=1;this.state.announcementMode=1;return this.ruleBody(name,args,context,messages,actions);
   }
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
   case 'object.streamClue':return actor===0;
   case 'object.inspectClosely':{for(let p=w.entity(first).parent;p!==null;p=w.entity(p).parent)if(w.entity(p).person)return p===actor;return true;}
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
   case 'npc.jonesEvidence':if([16,17,67].includes(second))this.state.facts.find(f=>f.start===0x9981).terms[7]|=0x200;result=yes();break;
   case 'npc.revealJones':if(second!==67){result=yes();break;}if(!w.perceived(67,actor))throw new UnsupportedFeature('TELL di Tricia senza i vestiti visibili: il rifiuto originale non ritorna al prompt (A9B0)');this.active.identityChange=95;this.state.facts.find(f=>f.start===0x9981).terms[5]|=0x200;result=yes();break;
   case 'npc.tellBody':this.print('6830',actor,{object:first,actorNameFrame:0x5D16,textArguments:[g.dialogue.topic(actor,second)]},messages);result=yes(1);break;
   case 'counter.create':{
    const p=records.prepend('counters',[actor,0]);const random=second===255?0:g.runtimeRandom.absolute(second,{actor,mixOffset:5,purpose:'private-counter'});records.arena.putByte(p+1,(first+random)&255);result=yes();break;
   }
   case 'counter.decrement':if(!counter)return no();{const n=(records.arena.byte(counter+1)-1)&255;records.arena.putByte(counter+1,n);if(!n){records.remove('counters',counter);return no();}result=yes();break;}
   case 'counter.delete':if(!counter)return no();records.remove('counters',counter);result=yes();break;
   case 'unimplemented.F198':result=first>=g.runtimeRandom.percent({actor,mixOffset:5,purpose:'probability-predicate'})?yes():no();break;
   case 'entity.relocate':result=yes(2,{observerScopeLost:this.relocate(first,second,messages,{actor,direction:w.entity(first).attributes&64?w.rooms[w.roomOf(first)].exits[0]?.direction_id:null})});break;
   case 'location.exitDirection':{const edge=w.rooms[w.roomOf(actor)].exits.find(e=>e.target===first&&e.direction_id<=10);if(!edge)return no();context.saved[1]=edge.direction_id;result=yes();break;}
   case 'unimplemented.E4C9':{
    const travel=[2,3,4].includes(first);
    if(travel)this.print('7611',actor,{},messages); // Announce before hiding the train.
    w.entity(actor).attributes=travel?w.entity(actor).attributes&127:w.entity(actor).attributes|128;
    // E4F6 clears the destination's seen flag before CA7F/CA9E prints the
    // passenger's scene. That display sets it again; later visits are brief.
    w.rooms[first].flags&=~64;result=yes(0,{observerScopeLost:this.relocate(actor,first,messages,{actor})});break;
   }
   case 'unimplemented.DDBE':this.temporaryCost(first,{lowOnly:true});result=yes(first);break;
   case 'unimplemented.EBD5':context.saved[0]=(first+1)&255;result=yes();break;
   case 'unimplemented.EAF6':w.entity(second).parent=first;w.entity(second).rooms=[50];w.entity(first).rooms=[50];result=yes();break;
   case 'unimplemented.EB11':result=this.state.facts.find(f=>f.start===0x99A9).flags&2?yes():no();break;
   case 'unimplemented.EB19':result=this.state.facts.find(f=>f.start===0x9997).flags&2?yes():no();break;
   case 'unimplemented.F1F6':w.entity(first).attributes|=128;result=yes();break;
   case 'unimplemented.F203':w.entity(first).attributes&=~1;result=yes();break;
   case 'unimplemented.F210':w.entity(first).attributes|=1;result=yes();break;
   case 'cab.arrive':{const vehicle=w.entity(actor).parent;w.entity(vehicle).attributes|=128;result=yes(0,{observerScopeLost:this.relocate(vehicle,first,messages,{actor,sceneSource:'cab-arrival'})});}break;
   case 'cab.customerPresent':if(w.entity(first).parent!==actor-1||first===actor)return no();{const frame=this.active.vm.state(actor).contexts.at(-1);if(frame){frame.saved[1]=first;records.arena.putByte(frame.record+3,first);}result=yes();break;}
   case 'cab.warnDebtor':{const frame=this.active.vm.state(actor).contexts.at(-1);this.print('6C54',actor,{},messages,{force:frame?.saved[1]===0});result=yes();break;}
   case 'cab.demandPayment':this.demand(actor,first,second,messages);result=yes();break;
   case 'money.balanceAsLiteral':this.state.literal=encodeMoney(balance(w,first))|128;context.saved[1]=254;result=yes();break;
   case 'money.pay':{const amount=this.state.literal&32767,pence=(amount&127)+(amount>>>8)*128;if(!transferMoney(w,actor,second,pence))return no();this.sayPayment(actor,second,pence,messages);result=yes(1);break;}
   default:result=name.startsWith('object.')?specialObjectBody(this,name,args,context,messages):this.advanced.body(name,args,context,messages)??this.active.primitives.body(name,args,context);
  }
  if(result.ended)return result;
  if(result.success)this.bind(context,args);
  if(result.observerScopeLost){
   // CBEA–CBFF fail to restore the observer on an imperceptible arrival.
   // CD91/D026 then commits the working scope through Holmes while IY
   // still identifies the visiting actor. Without a Holmes context this
   // overwrites that actor's ROOT, even while its child scope is suspended.
   const frame=this.state.foreignContexts[w.player]?.at(-1);
   if(frame){frame.saved=[...context.saved];records.arena.putByte(frame.record+3,context.saved[1]);records.arena.putByte(frame.record+4,context.saved[2]);records.arena.putByte(frame.record+6,context.saved[0]);}
   else this.active.vm.state(actor).saved.splice(0,3,...context.saved);
  }
  return result;
 }
 node(action,args){
  const model=this.game.data.actions.find(a=>a.id===action);if(!model)throw new UnsupportedFeature('azione interna NPC '+action);
  const [verb,r1,r2,modifier]=model.words,lookup=v=>v?this.game.dictionary.lookup(v.toUpperCase()).value:0;
  return {verb:lookup(verb),modifier:lookup(modifier),groups:args[0]===255?[]:[{noun:0,qualifiers:[],relations:[r1,r2].filter(Boolean).map(lookup)}],resolved:args.filter(v=>v!==255),subject:null,all:false,exclusion:false,quote:null};
 }
 // C8EF updates a slot only for an ID below FE. Class <5 selects the
 // room index; other classes select the entity index. FE/FF preserve the
 // previous pointer rather than clearing it. Unknown semantic searches
 // revoke ownership until a reconstructed C929/C989 call publishes it.
 projectArguments(args){const pointers=this.state.argumentPointers??(this.state.argumentPointers=[null,null]);for(let i=0;i<2;i++){const id=args[i];if(!Number.isInteger(id)||id>=254)continue;const kind=this.state.argumentClasses?.[i],table=kind===null||kind===undefined?null:kind<5?this.worldSource.layout.rooms:this.worldSource.layout.entities;pointers[i]=table?.find(e=>e.id===id)?.start??null;}}
 checkAction(action,args,actor,{phase=1}={}){
  const catalog=this.game.data.argumentChecks;if(!catalog)return null;
  const actorRule=[47,48].includes(action)?catalog.entities[actor]?.[action]:null;
  const pointer=actorRule||catalog.entities[args[0]]?.[action]||this.game.data.actions.find(a=>a.id===action)?.rule;
  const meta=catalog.headers[pointer];return meta?this.checks.rule(meta,[args[0]??255,args[1]??255],{actor,phase}):null;
 }
 setActionClasses(action){const model=this.game.data.actions.find(a=>a.id===action);if(model?.classes){this.state.argumentClasses=[...model.classes];const pointers=this.state.argumentPointers??(this.state.argumentPointers=[null,null]);for(let i=0;i<2;i++)if(model.classes[i]!==0&&![5,6].includes(model.classes[i]))pointers[i]=null;}}
 action(action,input,context,messages,actions){
  const actor=context.actor,w=this.w,g=this.game;this.state.executionPhase=0; // C4E9 action preflight.
  if(action>=128&&action<153){const meta=g.data.npcPrograms.internalActions?.[action];if(!meta)throw new UnsupportedFeature('azione interna '+action);return this.rule(meta,input,context,messages,actions);}
  this.setActionClasses(action);
  if(!this.state.argumentClasses.some((kind,i)=>kind!==0&&input[i]===255))this.projectArguments(input);
  if([29,30].includes(action)&&[31,34].includes(actor))return this.travel(actor,input[0],action===30,messages);
  if([29,30].includes(action)&&actor===11)return this.advanced.policeTravel(actor,input[0],action===30,messages,input[1]);
  if(action===45&&[31,34].includes(actor))return {cost:0,defer:'E08F',args:input};
  if([21,22].includes(action))return {cost:0,defer:'E456',args:[input[0],255]};
  const classByAction={12:8,13:8,24:8,25:8,40:8,31:8,19:8,41:9,42:9,44:9,11:9,23:9,16:10,17:10,38:10,39:10,36:8,14:8,26:10,32:0,49:0};
  let args=input.slice();if(action===31){if(args[0]===255){const e=w.entities.find(e=>g.cab.available(e,actor));if(!e)return no();args[0]=e.id;}}
  else if(classByAction[action]!==undefined){if(args[0]===255&&classByAction[action]!==0){const previous=g.actingActor;g.actingActor=actor;try{const e=w.entities.find(e=>{const checked=this.checkAction(action,[e.id,args[1]],actor,{phase:0});return checked!==false&&this.select(e.id,classByAction[action],actor)!==null&&g.canResolve(e,action,0);});if(!e)return no();args[0]=e.id;}finally{g.actingActor=previous;}}else{this.checkAction(action,args,actor);const selected=this.select(args[0],classByAction[action],actor);if(selected===null)return no();args[0]=selected;}}
  this.projectArguments(args);
  // Action lookup: a resolved entity without an OPEN/CLOSE rule is a
  // failed operation, not an untranslated special body (e.g. Daphne ED2A).
  if([14,36].includes(action)&&!w.entity(args[0]).rules.some(r=>r.action===action))return no();
  if(action===31){const vehicle=w.entity(args[0]);if(!g.cab.available(vehicle,actor))return no();g.cab.arrive(vehicle,actor);const out={messages:[{kind:'narrative',text:w.name(actor)+' hails '+w.name(vehicle.id)+'.'}],cost:1,action,args};this.showAction(out,actor,messages,actions);this.bind(context,args);return yes(1,{args});}
  if(input[0]===255||classByAction[action]===undefined)this.checkAction(action,args,actor);
  const headerCost=g.data.entities[args[0]]?.rules.find(r=>r.action===action)?.headerCost??g.data.actions.find(a=>a.id===action)?.headerCost;if(headerCost!==null&&headerCost!==undefined)this.temporaryCost(headerCost);
  this.state.executionPhase=1;this.state.announcementMode=1; // C53C / CA37: execute the selected action.
  const out=g.executeAs(this.node(action,args),actor,{textContext:context.prefab&&[47,48].includes(action)?{actorNameFrame:0x5D1A}:null});if(actor===w.player&&!out.projected&&out.messages.some(m=>m.kind==='narrative')){g.sourceDisplay.feed('\n');messages.push({kind:'narrative',text:'',raw_text:'\n'});}
  this.showAction(out,actor,messages,actions,{argumentFlags:!context.request&&!context.isolated});
  if(actor===w.player){const errors=out.messages.filter(m=>m.kind==='error');if(errors.length){for(const e of errors)e.lower_projected=true;messages.push(...errors);g.sourceDisplay.error(errors);}}
  if(out.objectRule)return this.rule(out.objectRule,[out.args[0]??255,out.args[1]??255],context,messages,actions);
  // B9B4 executes a queued command in its own working arguments. A completed
  // immediate request does not bind the suspended program's root arguments;
  // deferred requests get their own context via NpcProgram.defer instead.
  if(out.cost||action===32){if(!context.request)this.bind(context,args);return yes(out.cost,{args});}return no();
 }
 annotateArgumentPrefix(out,messages=out.messages){
  const w=this.w;
  if(!out.projected&&out.cost&&[12,43].includes(out.action)&&out.args[0]!==undefined){
    const e=w.entity(out.args[0]),name=w.name(e.id),prefix=name.lastIndexOf(' ');
    // A3DE -> A745/A751 -> D3E8: qualifiers of the entity argument
    // flush at frame5D2C. A word wrap clears the row at frame5D26;
    // only that proven caller may own scan AF and the saved shift C at5D1A–5D1C.
    if(!(e.noun&32768)&&e.qualifiers.some(v=>v&&!(v&32768))&&prefix>0)for(const m of messages)if(!m.scene_trace){const at=m.text.toLowerCase().lastIndexOf(name.toLowerCase());if(at>=0)m.scene_trace=[{kind:'action-entity-prefix',start:at,end:at+prefix,frame:0x5D2C,flagsKnown:true}];}
   }
 }
 showAction(out,actor,messages,actions,{argumentFlags=false}={}){
  const w=this.w,visible=out.visibilityResolved||w.perceived(actor);
  // CAAF/CAF0: a shared door can be acted on from another room. Announce
  // its change to an observer in either room, replacing the unseen actor
  // with the original anonymous subject ($A036 = FF). CB01/D471 also
  // requires an exit from the ACTOR room to Holmes' room: the same door
  // entity is reused in distant buildings, which must not leak messages.
  const door=[14,36].includes(out.action)&&out.cost&&out.args[0]!==undefined?w.entity(out.args[0]):null;
  const anonymous=!visible&&door?.rooms.length>1&&door.rooms.includes(w.roomOf())&&w.perceived(door.id)&&w.rooms[w.roomOf(actor)].exits.some(exit=>exit.target===w.roomOf());
  if(visible||anonymous){const shown=out.messages.filter(m=>m.kind==='narrative').map(m=>anonymous?{...m,text:'Someone'+m.text.slice(w.name(actor).length)}:m);if(argumentFlags)this.annotateArgumentPrefix(out,shown);
   messages.push(...shown);if(!out.projected)this.game.projectMessages(shown);}
  if(out.cost||out.action===32||out.objectRule)actions.push({actor,id:out.action,arguments:out.args});
 }
 relocate(id,room,messages,notification={}){
  const w=this.w,g=this.game,before=w.roomOf(),visible=w.perceived(id),old=w.roomOf(id),actorOld=notification.actor===undefined?null:w.roomOf(notification.actor),directional=id===notification.actor&&notification.direction>=1&&notification.direction<=10;
  // E4B0 selects the FIRST exit of the old room for a walking entity. CA76
  // announces that action before E49B moves it, even when Holmes is in a train.
  if(directional&&visible){const message={kind:'narrative',text:w.name(id)+' goes '+DIRECTION_NAMES[notification.direction]+'.'};messages.push(message);g.projectMessages([message]);}
  w.move(id,room);this.moved(room);
  if(before!==w.roomOf()){
   const room=w.rooms[w.roomOf()],full=!(room.flags&64),message={...g.sceneMessage({full,source:notification.sceneSource??'arrival'}),image_room:full?w.roomOf():null};room.flags|=64;messages.push(message);g.projectMessages([message]);
   // D187's introduction tail and compound-subject prefix are projected by
   // the scene trace, including C374's return link on a wrapped word. Keep
   // those derived glyph fields for the ordinary hansom cab. The police
   // vehicle's extra caller still has unprojected AF/BC owners.
   const parent=w.entity(w.player).parent;
   if(notification.sceneSource==='cab-arrival'&&!room.description&&parent===109)g.sourceDisplay.invalidateScratch(0x5D08,0x5D0F);
  }else if(old!==room&&id!==w.player&&[30,33].includes(id)&&notification.sceneSource!=='cab-arrival'&&w.perceived(id)){
   const message={kind:'narrative',text:w.name(id)+' is in '+w.roomName(room)+'.'};message.text=message.text[0].toUpperCase()+message.text.slice(1);messages.push(message);g.projectMessages([message]);
  }else if(old!==room&&!visible&&w.perceived(id)){
   // CAAF/CBC2 announce the outermost arriving entity; a vehicle's
   // passengers are described by their own subsequent actions.
   let outer=id;while(w.entity(outer).parent!==null)outer=w.entity(outer).parent;
   const name=w.name(outer,{indefinite:true}),message={kind:'narrative',text:name[0].toUpperCase()+name.slice(1)+' enters.'};
   messages.push(message);g.projectMessages([message]);
  } // An internal, non-directional departure is silent in CAAF/CBC2.
  if(notification.actor!==undefined&&before===w.roomOf()&&actorOld!==before&&w.roomOf(notification.actor)===before){let outer=notification.actor;while(w.entity(outer).parent!==null)outer=w.entity(outer).parent;return !w.perceived(outer);}
  return false;
 }
 travel(actor,target,furiously,messages){
  const w=this.w,vehicle=actor-1,route=this.routes.find(w.roomOf(vehicle),target,{furiously});if(!route){this.print('6C34',actor,{},messages);return yes();}
  const customer=this.active.vm.saved(actor)[1],playerBefore=w.roomOf();this.temporaryCost(route.cost);
  const money=account(w,actor);if(money)money.pence=wrapMoney(money.pence-route.fare);
  w.entity(vehicle).attributes&=127;w.rooms[1].flags&=~64;this.relocate(vehicle,1,messages,{sceneSource:'cab-departure'});
  // 9B44 explicitly reloads the service customer into argument 2. CBEA has
  // an early return which leaves the current actor set to Holmes when a
  // notification cannot perceive its subject. Deferred contexts then belong
  // to Holmes, although the original actor's program pointer still advances.
  const hiddenArrival=playerBefore===1&&!w.perceived(actor);
  return {cost:route.cost,defer:'F3AD',args:[target,customer],scopeOwner:hiddenArrival?w.player:actor};
 }
 playerAction(outcome){this.use(({records})=>{const saved=[outcome.action,outcome.args?.[0]??255,outcome.args?.[1]??255],frame=this.state.foreignContexts[this.w.player]?.at(-1);if(frame){frame.saved=saved;records.arena.putByte(frame.record+3,saved[1]);records.arena.putByte(frame.record+4,saved[2]);records.arena.putByte(frame.record+6,saved[0]);}else this.state.playerRootSaved=saved;});}
 playerInputFailures(stages,messages,actions){
  if(this.state.playerFailures===undefined)throw new UnsupportedFeature('contatore dei tentativi del giocatore assente da questo salvataggio precedente');
  // CEB8 counts failed DOMAIN rules, not rejected input lines. CC8C yields
  // one minute at ten failures; empty node/token checks count too. Each
  // stage names the player program's continuation after the failed rule.
  for(const pc of stages){this.temporaryCost(0);if(pc==='992D'&&this.state.parserRejected)this.use(({records})=>{records.remove('parsed',this.state.parserRejected);delete this.state.parserRejected;});if(++this.state.playerFailures===10){this.temporaryCost(1);this.state.playerProgramCounter=pc;const [action,...args]=this.state.playerRootSaved;this.game.advance(1,{action,args,messages,actions,preservePlayerStage:true});if(this.game.ended)return;}}
  this.temporaryCost(0);this.state.playerProgramCounter='9923';this.state.argumentClasses=[0,0];
 }
 demand(actor,recipient,owner,messages){
  const amount=balance(this.w,owner);if(amount===null)return;
  const g=this.game,visible=this.w.perceived(actor),c=visible?g.npcTextContext(actor):{};c.bufferVisible=visible;c.bufferSink=(ch,options)=>g.sourceDisplay.bufferFeed(ch,options);
  if(visible)c.actorNamePrefix=write=>{const previous=g.sourceDisplay.glyphFrame,upper=g.sourceDisplay.upperGlyphKnown;g.sourceDisplay.glyphFrame=0x5D1A;g.sourceDisplay.upperGlyphKnown=false;try{write();}finally{g.sourceDisplay.glyphFrame=previous;g.sourceDisplay.upperGlyphKnown=upper;}};
  const prefix=g.text.render('6BB7',{...c,actor,object:recipient,other:owner});const suffix=' '+formatMoney((-amount)&16383)+' "\n';for(const ch of suffix.replace(/d\./g,'D.'))g.sourceDisplay.bufferFeed(ch);if(c.sink)for(const ch of suffix)c.sink(ch);
  if(visible)messages.push(g.textMessage(prefix+' '+suffix.trim(),c));
 }
 sayPayment(actor,recipient,pence,messages){const w=this.w,amount=formatMoney(pence);if(!w.perceived(actor)){for(const ch of ' '+amount.replace(/d\./g,'D.')+'.\n')this.game.sourceDisplay.bufferFeed(ch);return;}const text=w.name(actor)+' pays '+amount+(amount.endsWith('.')?' To ':' to ')+(recipient===w.player?'you':w.name(recipient))+'.';if(w.perceived(actor)){const message={kind:'narrative',text:text[0].toUpperCase()+text.slice(1)};messages.push(message);this.game.projectMessages([message]);}}
 callback(actor,oldDue,messages){
  const id=actor.id,w=this.w;
  if(id===6){const e=w.entity(85);if(e.attributes&128&&this.state.burningNoteTicks!==255){this.state.burningNoteTicks=(this.state.burningNoteTicks-1)&255;if(!this.state.burningNoteTicks){e.qualifiers[0]=0x15B;e.name='burnt note';e.description=null;const fact=this.state.facts.find(f=>f.start===0x99A9);fact.terms[5]&=~0x0200;}}return;}
  if([5,8,9].includes(id)){this.advanced.sleep(id);return;}
  if(![2,3,4,11,12].includes(id))return;
  this.use(()=>{
   const counters=this.state.encounters[id],near=target=>w.roomOf(target)===w.roomOf(id)&&w.perceived(target,id);
   const encounter=(target,i,offset,text='6929',permanent=false,returnLink=0x9CEC)=>{
    // 9CF2's early path POPs its own return link into DE. The following
    // encounter's random call sees that link, not a fixed greeting context.
    if(!near(target)){counters[i]=Math.max(0,counters[i]-1);return returnLink;}
    if(counters[i])return returnLink;counters[i]=30+this.game.runtimeRandom.absolute(15,{actor:id,mixOffset:offset,purpose:'encounter:'+target});if(permanent)counters[i]=1;if(text)this.print(text,id,{object:target},messages);return offset;
   };
   if(id===3){let offset=oldDue;for(const [i,target] of [0,2,4].entries())offset=encounter(target,i,offset);const ctx={actor:3,mixOffset:offset,purpose:'watson-information'};if(this.game.runtimeRandom.percent(ctx)>=50){const draw=this.game.runtimeRandom.percent(ctx);this.information.recall(id,draw,messages);}return;}
   if(id===11||id===12){if(!this.state.flags.strakerMet){let offset=oldDue;for(const [i,target]of[0,3,7].entries())offset=encounter(target,i,offset,'6D9A',true,0x9D68);}return;}
   if(id===4){if(this.state.flags.strakerMet){const offset=encounter(0,0,oldDue);encounter(3,1,offset);}return;}
   if(id===2){
    if(near(4)&&near(0)&&!this.state.flags.strakerMet){this.state.flags.strakerMet=true;counters[0]=1;for(const room of [62,92])w.rooms[room].exits[0].gate=0;this.print(this.state.flags.lestradeMet?'7207':'7224',2,{object:4},messages);this.state.flags.lestradeMet=true;return;}
    let offset;if(near(0)&&!this.state.flags.lestradeMet){offset=encounter(0,0,oldDue,'71ED',false,0x9DCA);this.state.flags.lestradeMet=true;}else offset=encounter(0,0,oldDue,'6929',false,0x9DCA);
    const inspectFacts=near(0)&&!counters[1];
    offset=encounter(0,1,offset,null,true,0x9DDB);
    if(inspectFacts){
     // A successful 9DD8 continues through BC46/BC9C/BC74. With no
     // activated facts these scans emit nothing and BE5B leaves DE=2.
     // The early POP-return skips the complete proof scan.
     const {complete,incomplete}=this.information.scan();if(complete.length&&!(complete[0].flags&16))this.information.accept(complete[0],2,messages);else if(!complete.length&&incomplete.length)this.information.print('722D',2,messages,{fact:incomplete.at(-1)});
     offset=2;
    }
    encounter(3,2,offset);
    for(const at of [0x99E3,0x99F1,0x99A9])this.state.facts.find(f=>f.start===at).flags&=~1;
   }
  });
 }
 read(address){if(address===0xF60B)return this.state.nativeFillColor??null;const worldValue=this.worldSource.read(address);if(worldValue!==null)return worldValue;
  if(address===0xDC13||address===0xDC14)return this.state.lexicalMatch?.[address-0xDC13]??null;
  if(address>=0xBA1C&&address<0xBA20){const v=this.state.information.verification;if(!v)return null;return address===0xBA1C?v.recognized:address===0xBA1D?v.unproven:Number.isInteger(v.lastFact)?address===0xBA1E?v.lastFact&255:v.lastFact>>>8:null;}
  if(address>=0xBA13&&address<0xBA1C){const r=this.state.information.resolution;if(!r)return null;const values=[...r.cursors,r.verb];if(address<0xBA19){const n=values[Math.floor((address-0xBA13)/2)];return Number.isInteger(n)?((address&1)?n&255:n>>>8):null;}return r.triple[address-0xBA19]??null;}
  if(address>=0xAAA8&&address<0xAAB2)return this.state.parserNominal?.[address-0xAAA8]??null;
  if(address>=0xC1F4&&address<=0xC1FB)return this.game.sourceDisplay.read(address);
  // A008 is the optional ZX Printer flag, not a darkness/room byte. PRINT
  // and NOPRINT update it; older JS saves without it retain boot.
  // D045 projects the selected player's room; CC29 projects the current
  // actor's room and record. These are live world fields, not seed inputs.
  if(address===0xCC0D){const actor=this.w.scheduler.current?.actor,local=this.active?.vm.states[actor]??this.state.program.states[actor];return local?Number(local.requestAvailable):actor===this.w.player?Number(this.w.scheduler.requests.some(r=>r.recipient===actor)):null;}
  if(address===0xCC0B){const actor=this.w.scheduler.current?.actor;if(actor===this.w.player)return this.state.playerFailures;return this.active?.vm.states[actor]?.failures??this.state.program.states[actor]?.failures??null;}
  if(address>=0xA013&&address<=0xA016){const pointer=this.state.argumentPointers?.[Math.floor((address-0xA013)/2)];return Number.isInteger(pointer)?((address&1)?pointer&255:pointer>>>8):null;}
  if(address===0xD714)return this.state.editorTokenFlag??null;
  if(address===0xA019)return this.w.display?.counter??null;
  if(address===0xA01F||address===0xA020)return this.state.temporaryCost?.[address-0xA01F]??null;
  if(address===0xA021)return this.state.argumentCheck??null;
  if(address===0xA01B)return this.state.clarificationOffset??null;
  if(address===0xA01A)return this.state.parserAll??null;
  if(address===0xA012)return this.state.parserCount??null;
  if(address===0xA011)return this.state.nativeGraphicsEnabled===undefined?null:Number(this.state.nativeGraphicsEnabled);
  if(address===0xA00F||address===0xA010)return this.state.argumentClasses?.[address-0xA00F]??null;
  if(address===0xA00C)return this.state.announcementMode??null;
  if(address===0xA00B)return this.state.executionPhase??null;
  if(address===0xA009)return this.w.roomOf();
  if(address===0xA00A){const actor=this.game.runtimeRandom.inFlight?.actor;return this.w.entities[actor]?.rooms.length===1?this.w.roomOf(actor):null;}
  if(address===0xA017||address===0xA018){const actor=this.game.runtimeRandom.inFlight?.actor,record=this.worldSource.layout.entities.find(e=>e.id===actor)?.start;return record===undefined?null:address===0xA017?record&255:record>>>8;}
  if(address===0xA008)return Number(this.state.printerEnabled??this.game.data.randomInputs.bootOptions.printerEnabled);
  const fact=this.state.facts.find(f=>address>=f.start&&address<f.start+6+2*f.terms.length);if(fact){const bytes=[fact.subject,fact.predicate,fact.object,fact.flags,fact.handler&255,fact.handler>>>8,...fact.terms.flatMap(v=>[v&255,v>>>8])];return bytes[address-fact.start];}
  if([0x9EC0,0x9ECA,0x9ED0].includes(address))return this.state.nightRest?.[{[0x9EC0]:5,[0x9ECA]:9,[0x9ED0]:8}[address]]??0;
  if(address===0x9E88)return this.state.flags.caseReady?1:0;
  if(address>=0x9FF6&&address<0xA002)return [...this.state.information.he,...this.state.information.it][address-0x9FF6];
  if(address>=0xA002&&address<0xA008)return this.state.information.addressee[address-0xA002];
  if(address>=0xDCFF&&address<=0xDD02){const room=this.state.lastRelocationRoom,ptr=room===undefined?0:this.worldSource.layout.rooms.find(r=>r.id===room).start;return [ptr&255,ptr>>>8,room??0,0][address-0xDCFF];}
  if(address>=0x9FDD&&address<=0x9FE2){const c=this.w.clock();return [c.tick&255,c.tick>>>8,c.minute,c.hour,c.day,c.period==='am'?97:112][address-0x9FDD];}
  if(address===0xA02F||address===0xA030)return address===0xA02F?this.state.literal&255:this.state.literal>>>8;
  if(address===0xA036)return this.game.runtimeRandom.inFlight?.actor??null;
  if(address===0xA037)return this.w.random.seed;
  if(address===0xA039||address===0xA03A){const cursor=this.game.runtimeRandom.inFlight?.cursor??this.w.random.cursor;return address===0xA039?cursor&255:cursor>>>8;}
  if(address>=0x9C85&&address<0x9CA1){const callbacks=[[2,this.state.flags.strakerMet?0x9D95:0x9DFF],[3,0x9D13],[4,0x9D30],[11,0x9D48],[12,0x9D73],[8,0x9ED1],[9,0x9ECB],[5,0x9EC1],[6,0x9CA2]];return [...callbacks.flatMap(([id,at])=>[id,at&255,at>>>8]),255][address-0x9C85];}
  if(address===0x9CA1)return this.state.burningNoteTicks;
  if(address===0xA11A||address===0xA11B)return this.state.recordsSourceKnown?this.use(({records})=>{const link=records.arena.allocationLink;return link===null?null:address===0xA11A?link&255:link>>>8;}):null;
  const head=Object.entries(RECORD_HEADS).find(([,at])=>address===at||address===at+1);if(head||address===0x9FE3||address===0x9FE4)return this.state.recordsSourceKnown?this.use(({records})=>{const value=head?records.heads[head[0]]:records.arena.freeHead,at=head?head[1]:0x9FE3;return address===at?value&255:value>>>8;}):null;
  if(address>=0x9860&&address<0x9920){const index=Math.floor((address-0x9860)/8),a=this.w.scheduler.actors[index],s=index===0?{pc:this.state.playerProgramCounter??'9923',saved:this.state.playerRootSaved}:this.active?.vm.state(a.id)||this.state.program.states[a.id],pc=parseInt(s.pc,16);return [a.id,pc&255,pc>>>8,...s.saved,a.due&255,a.due>>>8][(address-0x9860)%8];}
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
  if(s.argumentCheck!==undefined&&s.argumentCheck!==null&&![0,1].includes(s.argumentCheck))throw Error('Invalid saved argument check');
  if(s.clarificationOffset!==undefined&&s.clarificationOffset!==null&&![0,8,18].includes(s.clarificationOffset))throw Error('Invalid saved clarification offset');
  if(s.temporaryCost!==undefined&&(!Array.isArray(s.temporaryCost)||s.temporaryCost.length!==2||s.temporaryCost.some(v=>v!==null&&(!Number.isInteger(v)||v<0||v>255))))throw Error('Costo temporaneo non valido');
  if(s.nativeGraphicsEnabled!==undefined&&s.nativeGraphicsEnabled!==false)throw Error('Grafica nativa fuori dal profilo ricostruito');
  if(s.nativeFillColor!==undefined&&!byte(s.nativeFillColor))throw Error('Colore fill nativo non valido');
  if(s.editorTokenFlag!==undefined&&s.editorTokenFlag!==null&&![0,1].includes(s.editorTokenFlag))throw Error('Flag token editor non valido');
  if(s.parserAll!==undefined&&s.parserAll!==null&&![0,1,2].includes(s.parserAll))throw Error('Stato ALL/BUT non valido');
  if(s.parserCount!==undefined&&s.parserCount!==null&&!byte(s.parserCount))throw Error('Contatore parser non valido');
  if(s.lexicalMatch!==undefined&&(!Array.isArray(s.lexicalMatch)||s.lexicalMatch.length!==2||s.lexicalMatch.some(v=>v!==null&&!byte(v))))throw Error('Stato confronto lessicale non valido');
  if(s.information?.verification){const v=s.information.verification;if([v.recognized,v.unproven].some(n=>n!==null&&!byte(n))||v.lastFact!==null&&(!Number.isInteger(v.lastFact)||v.lastFact<0||v.lastFact>65535))throw Error('Stato verifica ipotesi non valido');}
  if(s.information?.resolution){const r=s.information.resolution;if(!Array.isArray(r.cursors)||r.cursors.length!==2||[...r.cursors,r.verb].some(v=>v!==null&&(!Number.isInteger(v)||v<0||v>65535))||!Array.isArray(r.triple)||r.triple.length!==3||r.triple.some(v=>v!==null&&!byte(v)))throw Error('Stato ricerca informazioni non valido');}
  if(s.argumentPointers!==undefined&&(!Array.isArray(s.argumentPointers)||s.argumentPointers.length!==2||s.argumentPointers.some(v=>v!==null&&(!Number.isInteger(v)||v<0||v>65535))))throw Error('Puntatori argomenti non validi');
  if(s.argumentClasses!==undefined&&(!Array.isArray(s.argumentClasses)||s.argumentClasses.length!==2||s.argumentClasses.some(v=>v!==null&&!byte(v))))throw Error('Classi argomenti non valide');
  if(s.playerFailures!==undefined&&(!Number.isInteger(s.playerFailures)||s.playerFailures<0||s.playerFailures>9))throw Error('Contatore tentativi del giocatore non valido');
  if(s.playerProgramCounter!==undefined&&s.playerProgramCounter!=='9923'&&!(this.game.ended&&(s.playerLocal?.pc===s.playerProgramCounter||['9923','992D','9932','9937','9945'].includes(s.playerProgramCounter))))throw Error('Continuazione del giocatore fuori dal prompt');
  if(s.nightRest!==undefined&&(!s.nightRest||![5,8,9].every(id=>byte(s.nightRest[id]))))throw Error('Stato del riposo NPC non valido');
  if(s.announcementMode!==undefined&&![0,1].includes(s.announcementMode))throw Error('Modo annuncio non valido');
  if(s.executionPhase!==undefined&&![0,1].includes(s.executionPhase))throw Error('Fase di esecuzione regole non valida');
  if(s.parserNominal!==undefined&&(!Array.isArray(s.parserNominal)||s.parserNominal.length!==10||!s.parserNominal.every(byte)))throw Error('Buffer nominale del parser non valido');
  if(s.printerEnabled!==undefined&&typeof s.printerEnabled!=='boolean')throw Error('Stato della stampante non valido');
  if(s?.version!==1||s.profile!=='world-v5'||this.w.random?.profile!=='world-v5'||!byte(s.initialSeed)||typeof s.recordsSourceKnown!=='boolean'||!triple(s.playerRootSaved)||!s.pending||!s.foreignContexts||!s.flags||Object.values(s.flags).some(v=>typeof v!=='boolean')||!byte(s.burningNoteTicks))throw Error('Stato NPC v5 non valido');
  for(const [id,n]of[[2,3],[3,3],[4,2],[11,3],[12,3]])if(!Array.isArray(s.encounters?.[id])||s.encounters[id].length!==n||!s.encounters[id].every(byte))throw Error('Contatori incontri NPC non validi');
  for(const k of ['he','it','addressee'])if(!Array.isArray(s.information?.[k])||s.information[k].length!==6||!s.information[k].every(byte))throw Error('Contesto informazioni non valido');
  if(!Array.isArray(s.facts)||s.facts.length!==this.worldSource.layout.facts.length)throw Error('Record informazioni mancanti');
  for(const [i,f]of s.facts.entries())if(f.start!==this.worldSource.layout.facts[i].start||![f.subject,f.predicate,f.object,f.flags].every(byte)||!Number.isInteger(f.handler)||f.handler<0||f.handler>65535||!Array.isArray(f.terms)||f.terms.length!==this.worldSource.layout.facts[i].terms.length||f.terms.some(v=>!Number.isInteger(v)||v<0||v>65535))throw Error('Record informazioni non valido');
  this.use(({vm,records})=>{
   if(records.arena.base!==0x9570||records.arena.bytes.length!==752||Object.keys(vm.states).length!==23)throw Error('Archivio dei programmi NPC non valido');
   for(const root of this.game.data.npcPrograms.actors){const id=root.id===13&&this.w.scheduler.actors.some(a=>a.id===95)?95:root.id,state=vm.state(id),a=this.w.scheduler.actor(id);if(!a.enabled||a.program!=='domain')throw Error('Attore NPC v5 disabilitato');vm.node(state.pc);for(const frame of state.contexts)if(!records.records('contexts').includes(frame.record))throw Error('Contesto sospeso privo del record');}
   for(const [id,job]of Object.entries(s.pending)){vm.state(Number(id));if(!Array.isArray(job.syntax)||!Number.isInteger(job.index)||job.index<0||job.nodes&&job.index>=job.nodes.length)throw Error('Richiesta pendente non valida');}
   if(s.parserPending!=null&&(!this.game.pending||records.heads.syntax!==s.parserPending||records.arena.allocated.get(s.parserPending)!==30))throw Error('Chiarimento privo del nodo conservato');
   for(const frames of Object.values(s.foreignContexts)){if(!Array.isArray(frames))throw Error('Contesti esterni non validi');for(const frame of frames)if(!triple(frame.saved)||!records.records('contexts').includes(frame.record))throw Error('Contesto esterno privo del record');}
  });
 }
}
