import {Game} from './game.mjs';
import {presentationPackets} from './spectrum.mjs';
import {seal,verify} from './save.mjs';

function packets(text,{leading=false,formatted=false}={}){
 const raw=formatted?(text.endsWith('\n')?text.slice(0,-1):text):text.replace(/ +"/g,'"');
 const events=presentationPackets(raw);
 for(const e of events){if(formatted)e.formatted=true;else if(/^[A-Z]/.test(e.text||''))e.capitalize=true;}
 return leading?[{op:'word',text:'',delimiter:'\r',capitalize:true,force:false},...events]:events;
}
export class ClientSession {
 constructor(data,options={}){this.data=data;this.game=new Game(data,options);this.job=null;this.serial=0;}
 publicData(){return {rooms:this.data.rooms.map(r=>({...r,name_hint:r.name})),edges:this.data.rooms.flatMap(r=>r.exits),pictures:this.data.pictures};}
 frameState(frame){
  const before=this.game.world.dump();try{this.game.world.restore(frame.world);const s=this.game.state();if(s.analysis)s.analysis={...s.analysis,actions:s.analysis.actions.slice(0,frame.actionCount)};return {...s,command_running:true,job:this.job?.id};}finally{this.game.world.restore(before);}
 }
 state(){const s=this.job?this.frameState(this.job.frames[Math.max(0,this.job.index-1)]):this.game.state();return {...s,initial_screen:packets(s.initial),opening_screen:s.opening?packets(s.opening,{leading:true}):null};}
 messages(messages){return messages.map(m=>m.kind==='narrative'?{...m,screen_events:[...(m.image_room? [{op:'picture',room:m.image_room}]:[]),...packets(m.raw_text??m.text,{leading:Boolean(m.paragraph_before),formatted:m.raw_text!==undefined})]}:m);}
 request(operation,body={}){
  if(operation==='data')return this.publicData();
  if(operation==='state')return this.state();
  if(operation==='reset'){this.game=new Game(this.data,{start_mode:body.start_mode,npc_profile:'world-v5',seed:body.seed??1});this.job=null;return {state:this.state(),messages:[{kind:'narrative',text:this.game.opening,screen_events:packets(this.game.opening,{leading:true})}]};}
  if(operation==='teleport'){const out=this.game.teleport(body.room);return {state:this.state(),messages:this.messages(out.messages)};}
  if(operation==='save'){if(this.job)throw Error('Completa il comando prima di salvare.');return seal(this.game.dump(),body.presentation??null).then(save=>({save}));}
  if(operation==='load'){if(this.job)throw Error('Completa il comando prima di caricare.');return verify(body.save).then(document=>{const loaded=Game.load(this.data,document);this.game=loaded;return {state:this.state(),presentation:document.presentation??null,messages:[]};});}
  if(operation==='command'||operation==='start-command'){
   if(this.job)throw Error('Un comando è già in corso.');
   const out=this.game.submit(body.command),messages=this.messages(out.messages);
   if(this.game.analysis?.outcome!=='lexical_error'&&messages.length){const first=messages.find(m=>m.kind!=='system');if(first)first.screen_events=[{op:'counter',value:0},{op:'wide'},...(first.screen_events||[])];}
   // Domain transitions stay synchronous. Presentation releases their messages
   // in minute order; WAIT UNTIL interruption restores the complete domain state
   // at the displayed minute, including NPCs and pending orders.
   const frames=this.game.lastFrames||[];
   if(operation==='start-command'&&frames.length>1){
    this.job={id:String(++this.serial),frames,index:0,messages,sent:0,canInterrupt:out.state.analysis.actions.filter(a=>a.actor===0).length===1&&out.state.analysis.actions[0].id===50};
    return this.request('continue-command',{job:this.job.id});
   }
   return {running:false,state:this.state(),messages};
  }
  if(operation==='continue-command'){
   const job=this.job;if(!job||job.id!==body.job)throw Error('Comando non più attivo.');
   if(body.interrupt&&job.canInterrupt){
    const frame=job.frames[Math.max(0,job.index-1)];
    this.game.world.restore(frame.world);
    const scheduler=this.game.world.scheduler;scheduler.actor(0).due=frame.clock.tick;
    scheduler.phase='visit';scheduler.index=0;scheduler.current={actor:0,context:{},steps:0};
    this.game.analysis.actions.length=frame.actionCount;scheduler.emit({event:'wait_interrupt'});
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
 return state.game_over?'Partita terminata. Usa Riavvia per ricominciare.':state.prototype_notice&&!state.command_running?'Messaggio del prototipo: '+state.prototype_notice:suspended.length?'Motore JavaScript: '+suspended.map(a=>a.suspension.feature).join('; '):'';
}
