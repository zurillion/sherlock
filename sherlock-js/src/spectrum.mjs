'use strict';
// Presentation only: world, parser and clock come from the autonomous session.
class SpectrumBuffer {
 constructor(columns=36, rows=18){this.columns=columns;this.rows=rows;this.clear();}
 clear(){this.lines=Array(this.rows).fill('');this.counter=0;this.scrolls=0;this.cursor=0;this.remaining=this.columns;this.started=false;this.capitalize=true;}
 startPage(){this.counter=0;}
 setColumns(columns){this.columns=columns;this.cursor=0;this.remaining=columns;}
 newline(){
  // C2CA: pause BEFORE the pending scroll when A019 equals 0F.
  if(this.counter===15)return false;
  this.counter=(this.counter+1)&255;
  const width=this.columns;
  this.lines=this.lines.map((line,row)=>((row+1<this.rows?this.lines[row+1]:'').padEnd(36,' ').slice(0,width)+line.padEnd(36,' ').slice(width)).trimEnd());
  this.scrolls++;this.cursor=0;this.remaining=width;return true;
 }
 more(){this.counter=255;this.setColumns(36);} // C2D4 + pending INC -> 00, not 01.
 put(character){const row=this.lines.at(-1).padEnd(36,' ');this.lines[this.rows-1]=(row.slice(0,this.cursor)+character+row.slice(this.cursor+1)).trimEnd();this.cursor++;this.remaining--;}
 *raw(character){
  if(character==='\r'){yield 'line';return;}
  this.put(character);if(this.remaining===0)yield 'line';
 }
 *formatted(character,force){
  if(character>='A'&&character<='Z')character=character.toLowerCase();
  if(!this.started&&character===' ')return;
  this.started=true;
  if(character==='\r')this.started=false;
  else if(character==='"'){yield* this.raw(' ');this.capitalize=true;}
  else if(character==='.')this.capitalize=true;
  else if(character>='a'&&character<='z'&&(this.capitalize||force)){character=character.toUpperCase();this.capitalize=false;}
  yield* this.raw(character);
 }
 *verbatim(character){
  if(!this.started&&character===' ')return;
  if(character==='\r')this.started=false;else this.started=true;
  const full=this.remaining===1;yield* this.raw(character);if(full)this.started=false;
 }
 *packet(event){
  const write=event.formatted?c=>this.verbatim(c):c=>this.formatted(c,event.force);
  this.capitalize=event.capitalize;const text=event.text||'',exact=this.remaining===text.length;
  if(text.length&&this.remaining<text.length)yield* write('\r');
  for(const character of text)yield* write(character);
  if(text.length&&exact)this.started=false;
  if(event.delimiter)yield* write(event.delimiter);
 }
 visible(){return this.lines.map(line=>line.padEnd(36,' '));}
}
function presentationPackets(text){
 // Fallback for hand-authored UI messages only; native output has its own packets.
 let word='',capitalize=true;const result=[];
 for(const character of text.replace(/\r\n?/g,'\n')+'\n'){
  if(character===' '||character==='\n'||character==='"'){
   result.push({op:'word',text:word,delimiter:character==='\n'?'\r':character,capitalize,force:false});
   for(const c of word){if(/[a-zA-Z]/.test(c))capitalize=false;if(c==='.')capitalize=true;}
   if(character==='"')capitalize=true;word='';
  }else word+=character;
 }
 return result;
}
function spectrumTokens(text){return text.replace(/\r\n?/g,'\n').trim().match(/\n|[^\s]+/g)||[];}
function spectrumWrap(text,columns=36){const lines=[''];for(const c of text){if(c==='\n'||lines[lines.length-1].length===columns)lines.push('');if(c!=='\n')lines[lines.length-1]+=c;}return lines;}
class SpectrumTerminal {
 constructor({canvas,input,upper,lower,status,onCommand}){
  Object.assign(this,{canvas,input,upper,lower,status,onCommand});this.model=new SpectrumBuffer();this.active=false;this.busy=false;this.processing=false;this.waiting=false;this.waitingReason=null;this.startupPending=true;this.epoch=0;this.draft='';this.lowerHistory=[];this.lowerLine='';this.clock='Mon 08:00am';this.clockVisible=false;this.promptVisible=false;this.scale=2;this.pictureMode='svg';this.pictures=true;this.picture=null;this.pictureTop=0;this.pictureNarrow=false;this.cache=new Map();this.delay=32.5;
  input.addEventListener('keydown',e=>this.key(e));input.addEventListener('beforeinput',e=>{e.preventDefault();if(this.busy||this.processing||this.waiting||this.ended)return;if(e.inputType==='insertText'&&e.data)for(const c of e.data)this.type(c);else if(e.inputType==='deleteContentBackward')this.backspace();});
  for(const event of ['paste','drop','cut'])input.addEventListener(event,e=>e.preventDefault());
  input.addEventListener('input',()=>{input.value=this.draft;});
  canvas.parentElement.addEventListener('click',()=>{if(this.waiting)this.more();else this.focus();});
  document.addEventListener('keydown',e=>{if(e.target?.closest?.('dialog[open]'))return;if(this.active&&this.waiting){if(e.target!==this.input&&e.target?.closest?.('input,select,button,textarea,a'))return;e.preventDefault();e.stopImmediatePropagation();this.more();}},true);
  this.blink=setInterval(()=>{if(this.active&&this.waitingReason==='more')this.render();},320);
 }
 configure(assets,pictures,pixels){this.assets=assets;this.urls={svg:pictures||{},pixel:pixels||{}};this.render();}
 setActive(value){this.active=value;if(!value)this.cancel();this.render();}
 setBusy(value){this.busy=value;this.input.setAttribute('aria-busy',String(value));this.render();}
 setClock(value){this.clock=value;this.render();}
 setEnded(value){this.ended=Boolean(value);this.input.setAttribute('aria-disabled',String(this.ended));this.render();}
 resumeSession(){this.startupPending=false;this.clockVisible=true;this.promptVisible=true;this.model.startPage();this.render();}
 setScale(value){this.scale=Number(value)===3?3:2;this.render();}
 setPictures(value){this.pictures=value;const columns=this.picture&&value&&this.pictureNarrow?18:36;if(columns!==this.model.columns)this.model.setColumns(columns);this.render();}
 setRoom(room){this.room=room;}
 async setPictureMode(value){this.pictureMode=value==='pixel'?'pixel':'svg';if(this.picture)await this.loadPicture(this.picture.room,false);this.render();}
 clearPicture(){this.picture=null;this.pictureNarrow=false;this.model.setColumns(36);this.render();}
 reset(){this.cancel();this.ended=false;this.clock='Mon 08:00am';this.clockVisible=false;this.promptVisible=false;this.startupPending=true;this.model.clear();this.lowerHistory=[];this.lowerLine='';this.draft='';this.input.value='';this.clearPicture();this.render();}
 snapshot(){
  if(this.processing||this.waiting)throw new Error('Attendi la fine del testo prima di salvare.');
  const model={};for(const key of ['columns','rows','lines','counter','scrolls','cursor','remaining','started','capitalize'])model[key]=structuredClone(this.model[key]);
  return {model,lowerHistory:[...this.lowerHistory],lowerLine:this.lowerLine,draft:this.draft,clockVisible:this.clockVisible,promptVisible:this.promptVisible,startupPending:this.startupPending,
   picture:this.picture?{room:this.picture.room,scrollOrigin:this.picture.scrollOrigin}:null,pictureTop:this.pictureTop,pictureNarrow:this.pictureNarrow,pictureMode:this.pictureMode,pictures:this.pictures};
 }
 static validateSnapshot(value){
  const fail=()=>{throw new Error('Schermo nel salvataggio non valido.');},m=value?.model;
  if(!m||![18,36].includes(m.columns)||m.rows!==18||!Array.isArray(m.lines)||m.lines.length!==18||!m.lines.every(s=>typeof s==='string'&&s.length<=36))fail();
  for(const key of ['counter','scrolls','cursor','remaining'])if(!Number.isSafeInteger(m[key])||m[key]<0)fail();
  if(m.counter>255||m.cursor>m.columns||m.remaining!==m.columns-m.cursor)fail();
  for(const key of ['started','capitalize'])if(typeof m[key]!=='boolean')fail();
  for(const key of ['clockVisible','promptVisible','startupPending','pictureNarrow','pictures'])if(typeof value[key]!=='boolean')fail();
  if(!['svg','pixel'].includes(value.pictureMode)||!Array.isArray(value.lowerHistory)||value.lowerHistory.length>40||!value.lowerHistory.every(s=>typeof s==='string'&&s.length<=34)||typeof value.lowerLine!=='string'||value.lowerLine.length>34||typeof value.draft!=='string'||value.draft.length>128)fail();
  if(!Number.isSafeInteger(value.pictureTop)||value.pictureTop<0)fail();
  if(value.picture!==null&&(!Number.isInteger(value.picture?.room)||value.picture.room<0||value.picture.room>105||!Number.isSafeInteger(value.picture.scrollOrigin)||value.picture.scrollOrigin<0))fail();
 }
 async restore(value){
  SpectrumTerminal.validateSnapshot(value);this.reset();
  this.pictureMode=value.pictureMode;this.pictures=value.pictures;
  if(value.picture){await this.loadPicture(value.picture.room,false);if(this.picture)this.picture.scrollOrigin=value.picture.scrollOrigin;}
  Object.assign(this.model,structuredClone(value.model));
  for(const key of ['lowerHistory','lowerLine','draft','clockVisible','promptVisible','startupPending','pictureTop','pictureNarrow'])this[key]=structuredClone(value[key]);
  this.input.value=this.draft;this.render();
 }
 cancel(){this.epoch++;this.waiting=false;this.waitingReason=null;this.processing=false;if(this.resume){this.resume(false);this.resume=null;}this.render();}
 focus(){if(this.active)this.input.focus({preventScroll:true});}
 type(character){if(this.ended||!/^[ -~£]$/.test(character)||this.draft.length>=128)return;this.draft+=character.toUpperCase();this.input.value=this.draft;this.render();}
 backspace(){if(this.ended)return;this.draft=this.draft.slice(0,-1);this.input.value=this.draft;this.render();}
 key(e){
  if(e.key==='Tab')return;
  if(e.ctrlKey||e.metaKey){if(['v','x','a'].includes(e.key.toLowerCase()))e.preventDefault();return;}
  e.preventDefault();if(this.busy||this.processing||this.ended||!this.active)return;
  if(e.key==='Backspace')this.backspace();else if(e.key==='Enter'){if(this.draft.trim())this.onCommand(this.draft);}else if(e.key.length===1)this.type(e.key);
 }
 commit(text){this.lowerHistory.push(...spectrumWrap(text.toUpperCase(),34));this.lowerHistory=this.lowerHistory.slice(-40);this.draft='';this.input.value='';this.render();}
 wide(){if(this.picture&&this.pictureNarrow)this.picture.scrollOrigin=this.model.scrolls;this.pictureNarrow=false;this.model.setColumns(36);}
 more(){if(!this.waiting)return;if(this.waitingReason==='startup'){this.clockVisible=true;this.model.startPage();}else{this.wide();this.model.more();}this.waiting=false;this.waitingReason=null;const resolve=this.resume;this.resume=null;this.render();if(resolve)resolve(true);}
 async pause(reason='more'){this.waiting=true;this.waitingReason=reason;this.status.textContent='Premi un tasto qualsiasi per continuare.';this.render();return new Promise(resolve=>{this.resume=resolve;});}
 async line(epoch){while(!this.model.newline()){if(!await this.pause()||epoch!==this.epoch)return false;}return epoch===this.epoch;}
 async loadPicture(room,fresh=true){
  const url=this.urls?.[this.pictureMode]?.[room];if(!url){this.clearPicture();return;}
  const epoch=this.epoch,mode=this.pictureMode;
  if(!this.cache.has(url))this.cache.set(url,new Promise(resolve=>{const image=new Image();image.onload=()=>resolve(image);image.onerror=()=>resolve(null);image.src=url;}));
  const image=await this.cache.get(url);if(epoch!==this.epoch||mode!==this.pictureMode)return;
  if(!image){this.clearPicture();return;}
  if(fresh){this.pictureTop=0;this.pictureNarrow=true;this.model.counter=0;this.model.setColumns(18);}
  this.picture={room,image,url,scrollOrigin:fresh?this.model.scrolls:(this.picture?.scrollOrigin??this.model.scrolls)};const columns=this.pictures&&this.pictureNarrow?18:36;if(fresh||columns!==this.model.columns)this.model.setColumns(columns);this.render();
 }
 async displayEvent(event,epoch){
  if(event.op==='counter')this.model.counter=event.value;
  else if(event.op==='wide')this.wide();
  else if(event.op==='narrow'){this.model.counter=0;this.pictureNarrow=true;this.model.setColumns(18);}
  else if(event.op==='picture'){
   if(this.pictures&&this.urls?.[this.pictureMode]?.[event.room]){
    // A277: clear with 18 CRs, resetting A019 AFTER each; then C129.
    for(let row=0;row<18;row++){this.model.started=false;if(!await this.line(epoch))return false;this.model.counter=0;}
    await this.loadPicture(event.room);
   }
  }else if(event.op==='word'){
   for(const operation of this.model.packet(event))if(operation==='line'&&!await this.line(epoch))return false;
   this.render();
   if(event.text||event.delimiter==='"')await new Promise(resolve=>setTimeout(resolve,this.delay));
  }
  return epoch===this.epoch&&this.active;
 }
 async writeMessages(messages){
  if(!this.active)return;const epoch=this.epoch;this.processing=true;this.status.textContent='Scrittura del testo…';this.render();
  try{
   if(this.startupPending&&messages.some(message=>message.kind!=='error'&&(message.text?.trim()||message.screen_events?.length))){this.startupPending=false;if(!await this.pause('startup')||epoch!==this.epoch)return;}
   for(const message of messages){
    if(epoch!==this.epoch||!this.active)return;
    const native=Array.isArray(message.screen_events),lower=message.kind==='error';
    if(native){for(const event of message.screen_events)if(!await this.displayEvent(event,epoch))return;}
    else if(message.image_room!==undefined&&message.image_room!==null){if(!await this.displayEvent({op:'picture',room:message.image_room},epoch))return;}
    const text=message.text||'';
    if(!lower){
     if(!native&&text)for(const event of presentationPackets(text))if(!await this.displayEvent(event,epoch))return;
     continue;
    }
    for(const token of spectrumTokens(text.toUpperCase())){
     if(epoch!==this.epoch||!this.active)return;
     if(token==='\n'){if(this.lowerLine){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}}
     else{for(let remaining=token;remaining;){if(this.lowerLine.length&&(this.lowerLine.length+1+Math.min(remaining.length,34)>34)){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}const count=Math.min(remaining.length,34-this.lowerLine.length-(this.lowerLine?1:0));this.lowerLine+=(this.lowerLine?' ':'')+remaining.slice(0,count);remaining=remaining.slice(count);}}
     this.render();await new Promise(resolve=>setTimeout(resolve,this.delay));
    }
    if(this.lowerLine){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}
    this.lowerHistory=this.lowerHistory.slice(-40);
   }
   // CRs belong to the native stream. HTTP batches and command completion
   // add no separators and never reset the shared paging counter.
  }finally{if(epoch===this.epoch){if(this.clockVisible)this.promptVisible=true;this.processing=false;this.status.textContent=this.ended?'Partita terminata. Usa Riavvia.':'Pronto. Caratteri, Backspace, Invio.';this.render();}}
 }
 lowerRows(){if(!this.clockVisible||!this.promptVisible)return Array(5).fill(' '.repeat(36));const rows=[...this.lowerHistory];if(this.lowerLine)rows.push(this.lowerLine);const draft=spectrumWrap(this.draft+(!this.busy&&!this.processing&&!this.ended?'+':''),34);rows.push(...draft);return [...Array(Math.max(0,5-rows.length)).fill(null),...rows.slice(-5)].map(line=>line===null?' '.repeat(36):('> '+line).padEnd(36,' '));}
 render(){
  const upper=this.model.visible(),lower=this.lowerRows();this.upper.textContent=upper.join('\n');this.lower.textContent=lower.join('\n');
  this.canvas.setAttribute('aria-label',`Schermo ZX Spectrum${this.clockVisible?' · '+this.clock:''}. 36 colonne, 18 righe di testo, una riga di stato, 5 righe di comando.`);this.canvas.dataset.waiting=String(this.waiting);this.canvas.dataset.waitingReason=this.waitingReason||'';this.canvas.dataset.clockX='16';this.canvas.dataset.clockVisible=String(this.clockVisible);this.canvas.dataset.clock=this.clockVisible?this.clock:'';this.canvas.dataset.processing=String(this.processing);this.canvas.dataset.columns=String(this.model.columns);this.canvas.dataset.scrolls=String(this.model.scrolls);this.canvas.dataset.lineCounter=String(this.model.counter);this.canvas.dataset.picture=this.picture&&this.pictures?String(this.picture.room):'';this.canvas.dataset.pictureMode=this.pictureMode;
  if(!this.assets)return;
  const scale=this.scale,dpr=window.devicePixelRatio||1,w=256*scale,h=192*scale;
  if(this.canvas.width!==Math.round(w*dpr)||this.canvas.height!==Math.round(h*dpr)){this.canvas.width=Math.round(w*dpr);this.canvas.height=Math.round(h*dpr);}
  this.canvas.style.width=w+'px';this.canvas.style.height=h+'px';const ctx=this.canvas.getContext('2d');ctx.setTransform(scale*dpr,0,0,scale*dpr,0,0);ctx.fillStyle='#cdcdcd';ctx.fillRect(0,0,256,192);
  ctx.save();ctx.beginPath();ctx.rect(0,0,256,144);ctx.clip();
  if(this.picture&&this.pictures){const y=this.pictureTop-(this.pictureNarrow?0:8*(this.model.scrolls-this.picture.scrollOrigin));ctx.imageSmoothingEnabled=this.pictureMode!=='pixel';ctx.drawImage(this.picture.image,128,y,128,176);}
  for(let row=0;row<18;row++)this.drawText(ctx,upper[row],2,row*8);ctx.restore();
  ctx.fillStyle='#fff';ctx.fillRect(0,144,256,8);ctx.fillStyle='#000';
  for(let row=0;row<6;row++)for(let x=0;x<256;x++)if(this.assets.divider[row*4+Math.floor(x/8)%4]&(128>>(x%8)))ctx.fillRect(x,145+row,1,1);
  if(this.clockVisible){
   ctx.fillStyle='#fff';ctx.fillRect(8,144,this.clock.length*7+16,8);this.drawText(ctx,this.clock,16,144);
   if(this.waiting&&this.waitingReason==='more'&&Math.floor(Date.now()/320)%2===0){ctx.save();ctx.globalCompositeOperation='difference';ctx.fillStyle='#fff';ctx.fillRect(248,144,8,8);ctx.restore();}
  }
  for(let row=0;row<5;row++)this.drawText(ctx,lower[row],2,152+row*8);
 }
 drawText(ctx,text,x,y){ctx.fillStyle='#000';for(const character of text){let code=character==='£'?96:character.charCodeAt(0);if(code<32||code>127)code=63;const glyph=this.assets.glyphs[code-this.assets.first];for(let row=0;row<8;row++)for(let col=0;col<8;col++)if(glyph[row]&(128>>col))ctx.fillRect(x+col,y+row,1,1);x+=7;}}
}
export {SpectrumBuffer,SpectrumTerminal,spectrumTokens,spectrumWrap,presentationPackets};
