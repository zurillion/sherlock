import {paperSvg} from './virtual-printer.mjs';
import {Game} from './game.mjs';
import {UnsupportedFeature} from './world.mjs';
import {RandomInputsUnavailable} from './random.mjs';
import {presentationPackets} from './spectrum.mjs';
import {seal,verify} from './save.mjs';

function packets(text,{leading=false,formatted=false}={}){
 const raw=formatted?(text.endsWith('\n')?text.slice(0,-1):text):text.replace(/ +"/g,'"');
 const events=presentationPackets(raw);
 for(const e of events){if(formatted)e.formatted=true;else if(/^[A-Z]/.test(e.text||''))e.capitalize=true;}
 return leading?[{op:'word',text:'',delimiter:'\r',capitalize:true,force:false},...events]:events;
}
function rawPackets(text,buffer){
 const events=[];for(const c of text.replace(/\r\n?/g,'\n')){if([' ','\n','"'].includes(c)){events.push({op:'word',text:buffer.word,delimiter:c==='\n'?'\r':c,formatted:true});buffer.word='';}else if(c==='\b')buffer.word=buffer.word.slice(0,-1);else buffer.word+=c;}return events;
}
export class ClientSession {
 constructor(data,options={}){this.data=data;this.game=new Game(data,options);this.job=null;this.serial=0;}
 continueWait(interrupt){
  const job=this.job,g=this.game,wait=g.pendingWait,checkpoint=g.world.dump(),count=wait.messages.length,actionCount=wait.actions.length,paid=wait.paid;
  let result;
  try{result=g.continueWait({interrupt});}
  catch(error){
   g.world.restore(checkpoint);wait.messages.length=count;wait.actions.length=actionCount;wait.paid=paid;
   if(!(error instanceof UnsupportedFeature||error instanceof RandomInputsUnavailable))throw error;
   // Preserve already displayed minutes. Do not roll back the whole WAIT or
   // install the future state from a precomputed execution.
   if(!paid)wait.cancelInput();else g.continueWait({interrupt:true});g.analysis={...g.analysis,outcome:'not_translated',notice:error.message,recovery:'requires-engine-update',missing_address:error.address??null};
   wait.messages.push({kind:'system',text:error.message});const entry=g.history.entries.findLast(e=>e.kind==='command');if(entry)g.history.finish(entry,g.world,{outcome:'not_translated',errors:[error.message]});result={running:false,messages:wait.messages};
  }
  const batch=result.messages.slice(job.sent);job.sent=result.messages.length;
  const messages=this.messages(batch,{buffer:job.buffer});if(job.first&&(result.running||g.analysis?.outcome!=='not_translated')){let first=messages.find(m=>m.kind!=='system');if(!first){first={kind:'narrative',text:'',screen_events:[]};messages.unshift(first);}first.screen_events=[{op:'counter',value:0},{op:'wide'},...(first.screen_events||[])];job.first=false;}
  if(!result.running){this.job=null;return {running:false,state:this.state(),messages};}
  return {running:true,job:job.id,state:this.state(),clock:g.world.clock(),messages,can_interrupt:true};
 }
 publicData(){return {rooms:this.data.rooms.map(r=>({...r,name_hint:r.name})),edges:this.data.rooms.flatMap(r=>r.exits),pictures:this.data.pictures};}
 frameState(frame){
  const before=this.game.world.dump();try{this.game.world.restore(frame.world);const s=this.game.state();if(s.analysis)s.analysis={...s.analysis,actions:s.analysis.actions.slice(0,frame.actionCount)};return {...s,command_running:true,job:this.job?.id};}finally{this.game.world.restore(before);}
 }
 state(){if(this.job?.liveWait)return {...this.game.state(),command_running:true,job:this.job.id};const s=this.job?this.frameState(this.job.frames[Math.max(0,this.job.index-1)]):this.game.state();return {...s,initial_screen:packets(s.initial),opening_screen:s.opening?packets(s.opening,{leading:true}):null};}
 messages(messages,{pending='',buffer={word:pending}}={}){return messages.map(m=>{if(m.kind!=='narrative')return m;let events;
  if(m.screen_pause)events=[{op:'pause'}];
  else if(m.screen_ack)events=[{op:'acknowledge',reason:'ending'}];
  else if(m.screen_clear)events=[...Array.from({length:18},()=>[{op:'word',text:'',delimiter:'\r',formatted:true},{op:'counter',value:0}]).flat(),{op:'clear-picture'}];
  else if(m.raw_text!==undefined)events=rawPackets((m.paragraph_before?'\n':'')+m.raw_text,buffer);
  else{events=packets(m.text,{leading:Boolean(m.paragraph_before)});if(buffer.word&&events.length){events[0]={...events[0],text:buffer.word+events[0].text,formatted:true};buffer.word='';}}
  return {...m,screen_events:[...(m.image_room?[{op:'picture',room:m.image_room}]:[]),...events]};});}
 request(operation,body={}){
  if(operation==='printer')return {svg:paperSvg(this.game.world.display?.printerPaper||[])};
  if(operation==='data')return this.publicData();
  if(operation==='state')return this.state();
  if(operation==='reset'){this.game=new Game(this.data,{start_mode:body.start_mode,npc_profile:'world-v5',seed:body.seed??1});this.job=null;return {state:this.state(),messages:[{kind:'narrative',text:this.game.opening,screen_events:packets(this.game.opening,{leading:true})}]};}
  if(operation==='teleport'){const out=this.game.teleport(body.room);return {state:this.state(),messages:this.messages(out.messages)};}
  if(operation==='save'){if(this.job)throw Error('Completa il comando prima di salvare.');return seal(this.game.dump(),body.presentation??null).then(save=>({save}));}
  if(operation==='load'){if(this.job)throw Error('Completa il comando prima di caricare.');return verify(body.save).then(document=>{const loaded=Game.load(this.data,document);this.game=loaded;return {state:this.state(),presentation:document.presentation??null,messages:[]};});}
  if(operation==='command'||operation==='start-command'){
   if(this.job)throw Error('Un comando è già in corso.');
   const liveWait=operation==='start-command'&&this.game.canStreamWait(body.command);
   const out=this.game.submit(body.command,{streamWait:liveWait});
   if(this.game.pendingWait){this.job={id:String(++this.serial),liveWait:true,sent:0,buffer:{word:''},first:true,canInterrupt:true};return this.continueWait(false);}
   const messages=this.messages(out.messages);
   if(this.game.analysis?.outcome!=='lexical_error'&&messages.length){const first=messages.find(m=>m.kind!=='system');if(first)first.screen_events=[{op:'counter',value:0},{op:'wide'},...(first.screen_events||[])];}
   // Domain transitions stay synchronous. Presentation releases their messages
   // in minute order; WAIT UNTIL interruption restores the complete domain state
   // at the displayed minute, including NPCs and pending orders.
   const frames=this.game.lastFrames||[];
   if(operation==='start-command'&&frames.length>1){
    this.job={id:String(++this.serial),frames,index:0,messages,sent:0,canInterrupt:out.state.analysis.actions.filter(a=>[0,1,100].includes(a.actor)).length===1&&out.state.analysis.actions[0].id===50};
    return this.request('continue-command',{job:this.job.id});
   }
   return {running:false,state:this.state(),messages};
  }
  if(operation==='continue-command'){
   const job=this.job;if(!job||job.id!==body.job)throw Error('Comando non più attivo.');
   if(job.liveWait)return this.continueWait(Boolean(body.interrupt));
   if(body.interrupt&&job.canInterrupt){
    const frame=job.frames[Math.max(0,job.index-1)];
    this.game.world.restore(frame.world);
    const scheduler=this.game.world.scheduler;scheduler.actors[0].due=frame.clock.tick;
    scheduler.phase='visit';scheduler.index=0;scheduler.current={actor:scheduler.actors[0].id,context:{},steps:0};
    this.game.analysis.actions.length=frame.actionCount;scheduler.emit({event:'wait_interrupt'});
    const command=this.game.history.entries.findLast(e=>e.kind==='command');if(command)this.game.history.finish(command,this.game.world,{outcome:'ok',errors:command.errors});
    const event=this.game.history.begin('interrupt',frame.clock.label,this.game.world);this.game.history.finish(event,this.game.world);
    this.job=null;return {running:false,state:this.state(),messages:[]};
   }
   if(job.index>=job.frames.length){this.job=null;return {running:false,state:this.state(),messages:[]};}
   const frame=job.frames[job.index++],end=job.index===job.frames.length?job.messages.length:frame.messageCount,messages=job.messages.slice(job.sent,end);job.sent=end;
   return {running:true,job:job.id,state:this.frameState(frame),clock:frame.clock,messages,can_interrupt:job.canInterrupt};
  }
  throw Error('Operazione del motore sconosciuta: '+operation);
 }
}

export function engineStatus(state){
 if(state.npc_profile==='world-v5')return 'Partite separate. NPC v5: programmi condivisi attivi, cab con viaggio e pagamento, Lestrade in movimento. Ricostruzione ancora parziale.';
 if(state.random_state)return 'Partite separate. Sessione Watson v4 precedente: salva se vuoi conservarla, poi premi Riavvia per attivare NPC v5.';
 return state.random_state
  ? 'Partite separate. Watson v4: saluti e TELL attivi nel profilo storico; AI completa ancora in lavorazione.'
  : 'Partite separate. Partita JS precedente: salva se vuoi conservarla, poi premi Riavvia per attivare i nuovi dialoghi di Watson.';
}

export function gameStatus(state){
 const suspended=state.scheduler.actors.filter(a=>a.suspension);
 return state.game_over?'Partita terminata. Usa Riavvia per ricominciare.':state.prototype_notice&&!state.command_running?'Messaggio del prototipo: '+state.prototype_notice+(state.analysis?.recovery==='requires-engine-update'?' La partita è conservata, ma questa dipendenza mancante può bloccare anche i comandi successivi. Puoi salvare la partita e la cronologia; per superare questo punto serve aggiornare il motore.':' Comando annullato: puoi continuare con un altro comando.'):suspended.length?'Motore JavaScript: '+suspended.map(a=>a.suspension.feature).join('; '):'';
}
