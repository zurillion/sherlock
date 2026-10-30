// Presentation-only journal: never part of world state or random inputs.
export class Transcript {
 constructor(entries=[]){
  if(!Array.isArray(entries)||entries.some(e=>!e||!['narrative','error','command'].includes(e.kind)||typeof e.text!=='string'||e.kind==='command'&&typeof e.accepted!=='boolean'))throw Error('Trascrizione non valida.');
  this.entries=structuredClone(entries);
 }
 begin(text){const entry={kind:'command',text,accepted:false};this.entries.push(entry);return entry;}
 finish(entry,analysis){if(entry)entry.accepted=analysis?.outcome!=='not_translated'&&Boolean(analysis?.actions?.some(a=>[0,1,100].includes(a.actor)));}
 message(message){if(['narrative','error'].includes(message.kind)&&message.text)this.entries.push({kind:message.kind,text:message.text});}
 dump(){return structuredClone(this.entries);}
 text({includeCommands=false}={}){
  const parts=this.entries.filter(e=>e.kind!=='command'||includeCommands&&e.accepted).map(e=>e.kind==='command'?'> '+e.text.toUpperCase():e.text.replace(/\r\n?/g,'\n').replace(/\x08/g,''));
  return parts.length?parts.join('\n\n')+'\n':'';
 }
 static fromPresentation(p){return new Transcript(p?.textTranscript??p?.transcript?.filter(e=>['narrative','error'].includes(e.kind)).map(({kind,text})=>({kind,text}))??[]);}
}
