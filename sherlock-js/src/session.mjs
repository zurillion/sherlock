import {Game} from './game.mjs';
import {presentationPackets} from './spectrum.mjs';
import {seal,verify} from './save.mjs';

function packets(text,{leading=false}={}){
 const raw=text.replace(/ +"/g,'"');
 const events=presentationPackets(raw);
 for(const e of events)if(/^[A-Z]/.test(e.text||''))e.capitalize=true;
 return leading?[{op:'word',text:'',delimiter:'\r',capitalize:true,force:false},...events]:events;
}
export class ClientSession {
 constructor(data){this.data=data;this.game=new Game(data);this.job=null;this.serial=0;}
 publicData(){return {rooms:this.data.rooms.map(r=>({...r,name_hint:r.name})),edges:this.data.rooms.flatMap(r=>r.exits),pictures:this.data.pictures};}
 state(){const s=this.game.state();return {...s,initial_screen:packets(s.initial),opening_screen:s.opening?packets(s.opening,{leading:true}):null};}
 messages(messages){return messages.map(m=>m.kind==='narrative'?{...m,screen_events:[...(m.image_room? [{op:'picture',room:m.image_room}]:[]),...packets(m.text)]}:m);}
 request(operation,body={}){
  if(operation==='data')return this.publicData();
  if(operation==='state')return this.state();
  if(operation==='reset'){this.game=new Game(this.data,{start_mode:body.start_mode});this.job=null;return {state:this.state(),messages:[{kind:'narrative',text:this.game.opening,screen_events:packets(this.game.opening,{leading:true})}]};}
  if(operation==='teleport'){const out=this.game.teleport(body.room);return {state:this.state(),messages:this.messages(out.messages)};}
  if(operation==='save'){if(this.job)throw Error('Completa il comando prima di salvare.');return seal(this.game.dump(),body.presentation??null).then(save=>({save}));}
  if(operation==='load'){if(this.job)throw Error('Completa il comando prima di caricare.');return verify(body.save).then(document=>{const loaded=Game.load(this.data,document);this.game=loaded;return {state:this.state(),presentation:document.presentation??null,messages:[]};});}
  if(operation==='command'||operation==='start-command'){
   if(this.job)throw Error('Un comando è già in corso.');
   const before=this.game.world.clock(),out=this.game.submit(body.command),messages=this.messages(out.messages);
   if(this.game.analysis?.outcome!=='lexical_error'&&messages.length){const first=messages.find(m=>m.kind!=='system');if(first)first.screen_events=[{op:'counter',value:0},{op:'wide'},...(first.screen_events||[])];}
   // UI time frames are presentation of a completed domain transition; there is
   // no CPU running in the background. The not-yet-ported NPC layer is explicit.
   const after=this.game.world.clock(),elapsed=this.game.world.minutes-(before.day*1440+(before.hour%12+(before.period==='pm'?12:0))*60+before.minute);
   if(operation==='start-command'&&elapsed>1){
    const clocks=[];for(let minute=1;minute<=elapsed;minute++){const date=before.day*1440+(before.hour%12+(before.period==='pm'?12:0))*60+before.minute+minute,h=Math.floor(date/60)%24;clocks.push({tick:before.tick+minute,due:after.due,day:Math.floor(date/1440),hour:h%12||12,minute:date%60,period:h<12?'am':'pm',label:`${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][Math.floor(date/1440)%7]} ${String(h%12||12).padStart(2,'0')}:${String(date%60).padStart(2,'0')}${h<12?'am':'pm'}`});}
    this.job={id:String(++this.serial),clocks,index:0,messages,canInterrupt:out.state.analysis.actions.length===1&&out.state.analysis.actions[0].id===50};return this.request('continue-command',{job:this.job.id});
   }
   return {running:false,state:this.state(),messages};
  }
  if(operation==='continue-command'){
   const job=this.job;if(!job||job.id!==body.job)throw Error('Comando non più attivo.');
   if(body.interrupt&&job.canInterrupt){const frame=job.clocks[Math.max(0,job.index-1)];this.game.world.tick=frame.tick;this.game.world.playerDue=frame.tick;this.game.world.minutes=frame.day*1440+(frame.hour%12+(frame.period==='pm'?12:0))*60+frame.minute;job.index=job.clocks.length;}
   if(job.index>=job.clocks.length){this.job=null;return {running:false,state:this.state(),messages:[]};}
   const index=job.index++;return {running:true,job:job.id,clock:job.clocks[index],messages:index===0?job.messages:[],can_interrupt:job.canInterrupt};
  }
  throw Error('Operazione del motore sconosciuta: '+operation);
 }
}
