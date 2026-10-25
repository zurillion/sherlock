// Diagnostic user input, separate from the world's state and random inputs.
// No wall-clock timestamps: save/load branches retain identical histories.
export class CommandHistory {
 constructor(meta,{complete=true,origin='startup'}={}){this.meta=structuredClone(meta);this.complete=complete;this.origin=origin;this.entries=[];}
 begin(kind,text,world){const entry={number:this.entries.length+1,kind,text,before:{clock:world.clock().label,room:world.roomOf()},after:null,outcome:'running',errors:[]};this.entries.push(entry);return entry;}
 finish(entry,world,{outcome='ok',errors=[]}={}){entry.after={clock:world.clock().label,room:world.roomOf()};entry.outcome=outcome;entry.errors=[...errors];}
 recover(commands){if(this.complete||this.entries.length||!commands?.length)return;this.origin='recovered-tab';for(const text of commands)this.entries.push({number:this.entries.length+1,kind:'command',text,before:null,after:null,outcome:'recovered',errors:[]});}
 format({clock=null,running=false}={}){
  const m=this.meta,lines=['# Sherlock · cronologia comandi',`# Motore: JavaScript · ${m.profile??'profilo precedente'} · cronologia v1`,`# Seed iniziale: ${m.seed??'non registrato'}`,`# Avvio: ${m.startMode==='original'?'08:01 (LOOK iniziale a pagamento)':'08:00 (descrizione iniziale gratuita)'}`,`# ${this.complete?'Cronologia completa dall’avvio.':'Cronologia parziale: partita precedente; possono mancare comandi e teletrasporti iniziali.'}`];
  if(clock)lines.push(`# Orologio visualizzato: ${clock}${running?' · comando/stampa in corso':''}`);
  lines.push('');
  for(const e of this.entries){
   if(e.kind==='command')lines.push(e.text);
   else if(e.kind==='teleport')lines.push(`# Teletrasporto: ${e.text}`);
   else if(e.kind==='interrupt')lines.push(`# Interruzione attesa: ${e.after?.clock??e.text}`);
   if(!['ok','recovered'].includes(e.outcome))lines.push(`# Esito: ${e.outcome}${e.after?' · '+e.after.clock:''}`);
   for(const error of e.errors)for(const line of error.split(/\r?\n/))lines.push('# '+line);
  }
  return lines.join('\n')+'\n';
 }
 dump(){return {version:1,meta:structuredClone(this.meta),complete:this.complete,origin:this.origin,entries:structuredClone(this.entries)};}
 static load(saved,meta){
  if(!saved)return new CommandHistory(meta,{complete:false,origin:'legacy-save'});
  const point=p=>p===null||p&&typeof p.clock==='string'&&Number.isInteger(p.room)&&p.room>=0&&p.room<106;
  if(saved.version!==1||!saved.meta||typeof saved.complete!=='boolean'||typeof saved.origin!=='string'||!Array.isArray(saved.entries)||saved.entries.some((e,i)=>e.number!==i+1||!['command','teleport','interrupt'].includes(e.kind)||typeof e.text!=='string'||!point(e.before)||!point(e.after)||typeof e.outcome!=='string'||!Array.isArray(e.errors)||!e.errors.every(x=>typeof x==='string')))throw Error('Cronologia nel salvataggio non valida.');
  const h=new CommandHistory(meta,{complete:saved.complete,origin:saved.origin});h.entries=structuredClone(saved.entries);return h;
 }
}
