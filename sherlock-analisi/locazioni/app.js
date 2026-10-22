'use strict';
// Presentation only: world, parser and clock still come from the Python server.
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
 *packet(event){
  this.capitalize=event.capitalize;const text=event.text||'',exact=this.remaining===text.length;
  if(text.length&&this.remaining<text.length)yield* this.formatted('\r',event.force);
  for(const character of text)yield* this.formatted(character,event.force);
  if(text.length&&exact)this.started=false;
  if(event.delimiter)yield* this.formatted(event.delimiter,event.force);
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
  document.addEventListener('keydown',e=>{if(this.active&&this.waiting){e.preventDefault();e.stopImmediatePropagation();this.more();}},true);
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
 cancel(){this.epoch++;this.waiting=false;this.waitingReason=null;this.processing=false;if(this.resume){this.resume(false);this.resume=null;}this.render();}
 focus(){if(this.active)this.input.focus({preventScroll:true});}
 type(character){if(this.ended||!/^[ -~£]$/.test(character)||this.draft.length>=70)return;this.draft+=character.toUpperCase();this.input.value=this.draft;this.render();}
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
if(typeof module!=='undefined')module.exports={SpectrumBuffer,SpectrumTerminal,spectrumTokens,spectrumWrap,presentationPackets};

const SPECTRUM_ASSETS={"source":"Caratteri ROM Spectrum fornita con Foggy London; striscia dal payload Sherlock.","rom_sha256":"d55daa439b673b0e3f5897f99ac37ecb45f974d1862b4dadb85dec34af99cb42","payload_sha256":"c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407","first":32,"glyphs":[[0,0,0,0,0,0,0,0],[0,16,16,16,16,0,16,0],[0,36,36,0,0,0,0,0],[0,36,126,36,36,126,36,0],[0,8,62,40,62,10,62,8],[0,98,100,8,16,38,70,0],[0,16,40,16,42,68,58,0],[0,8,16,0,0,0,0,0],[0,4,8,8,8,8,4,0],[0,32,16,16,16,16,32,0],[0,0,20,8,62,8,20,0],[0,0,8,8,62,8,8,0],[0,0,0,0,0,8,8,16],[0,0,0,0,62,0,0,0],[0,0,0,0,0,24,24,0],[0,0,2,4,8,16,32,0],[0,60,70,74,82,98,60,0],[0,24,40,8,8,8,62,0],[0,60,66,2,60,64,126,0],[0,60,66,12,2,66,60,0],[0,8,24,40,72,126,8,0],[0,126,64,124,2,66,60,0],[0,60,64,124,66,66,60,0],[0,126,2,4,8,16,16,0],[0,60,66,60,66,66,60,0],[0,60,66,66,62,2,60,0],[0,0,0,16,0,0,16,0],[0,0,16,0,0,16,16,32],[0,0,4,8,16,8,4,0],[0,0,0,62,0,62,0,0],[0,0,16,8,4,8,16,0],[0,60,66,4,8,0,8,0],[0,60,74,86,94,64,60,0],[0,60,66,66,126,66,66,0],[0,124,66,124,66,66,124,0],[0,60,66,64,64,66,60,0],[0,120,68,66,66,68,120,0],[0,126,64,124,64,64,126,0],[0,126,64,124,64,64,64,0],[0,60,66,64,78,66,60,0],[0,66,66,126,66,66,66,0],[0,62,8,8,8,8,62,0],[0,2,2,2,66,66,60,0],[0,68,72,112,72,68,66,0],[0,64,64,64,64,64,126,0],[0,66,102,90,66,66,66,0],[0,66,98,82,74,70,66,0],[0,60,66,66,66,66,60,0],[0,124,66,66,124,64,64,0],[0,60,66,66,82,74,60,0],[0,124,66,66,124,68,66,0],[0,60,64,60,2,66,60,0],[0,254,16,16,16,16,16,0],[0,66,66,66,66,66,60,0],[0,66,66,66,66,36,24,0],[0,66,66,66,66,90,36,0],[0,66,36,24,24,36,66,0],[0,130,68,40,16,16,16,0],[0,126,4,8,16,32,126,0],[0,14,8,8,8,8,14,0],[0,0,64,32,16,8,4,0],[0,112,16,16,16,16,112,0],[0,16,56,84,16,16,16,0],[0,0,0,0,0,0,0,255],[0,28,34,120,32,32,126,0],[0,0,56,4,60,68,60,0],[0,32,32,60,34,34,60,0],[0,0,28,32,32,32,28,0],[0,4,4,60,68,68,60,0],[0,0,56,68,120,64,60,0],[0,12,16,24,16,16,16,0],[0,0,60,68,68,60,4,56],[0,64,64,120,68,68,68,0],[0,16,0,48,16,16,56,0],[0,4,0,4,4,4,36,24],[0,32,40,48,48,40,36,0],[0,16,16,16,16,16,12,0],[0,0,104,84,84,84,84,0],[0,0,120,68,68,68,68,0],[0,0,56,68,68,68,56,0],[0,0,120,68,68,120,64,64],[0,0,60,68,68,60,4,6],[0,0,28,32,32,32,32,0],[0,0,56,64,56,4,120,0],[0,16,56,16,16,16,12,0],[0,0,68,68,68,68,56,0],[0,0,68,68,40,40,16,0],[0,0,68,84,84,84,40,0],[0,0,68,40,16,40,68,0],[0,0,68,68,68,60,4,56],[0,0,124,8,16,32,124,0],[0,14,8,48,8,8,14,0],[0,8,8,8,8,8,8,0],[0,112,16,12,16,16,112,0],[0,20,40,0,0,0,0,0],[60,66,153,161,161,153,66,60]],"divider":[0,63,193,192,32,254,1,196,129,232,13,129,65,176,23,130,131,128,127,1,35,131,252,4],"pixels":{"5":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADZUlEQVR4nO3da27iQBAAYYO4Ud//CHOnVRKJZJVgjGFc3U3Vz2wEYT57PH4kexpjLJWLiK+PEBHPvA41DmfkXe2aAHACwAkAJwCcAHACwKUGiOWppX2JzslHP7obJAWIH+Pe2yAjQPwa8cYG6QDixlh3NcgFEKuj3NIgEUBsGN9+BlkAYvPINjO4LEmKrd84xrjeA2hQFoDxPay3KL7vunQyyDIFvW2VAKLLVl8VoKVEIoDxObMvb1YigPfsXPHxk9Fl/qkE0LVcAOPjMLC8VbkA7tZs/ikDEIE9Oji7GgCNSwcwxsf2fvD8A+5e6QB2V3SOynI19N4BYOlqcJrxolsGYu2+Snxde972XkuZCxh/DsuJ2mpedWNrbLdKWZ9jQNEEgBMATgA4ARKfB8xY3s1bdEWaxehDnxFbhj66PB3Fl5u3cgqCEwBOADgB4ApcDZ1Ukj/u8b4AI8fyzykI7vImM8x4bnufdzf00nXcx//jdevreE0A4t74Xr+eTaI2QDw+mtkkLnlWeOORgbj+rtKON0olMQXgmE8yXvQuPyWONyi5DI1GT4jWPgbsmANX5JBfvqy3B8S9MVo/AuW5b1MVYL0t47u+f/z5r/N2i3OnzT82b9159oPpAId91HjwjW59/8G/rHnusfnHriHLsB9UApgxjrdm/MNsztU3/3h6pNj9oAzAmDP6t17nsJ2g54nYpO6S7FitHgSwZWsaya4u/D4xnvETHgSQbXDzVOYY0LXpAG7767kHwAkAJwBc+fOA8YoXAU+F3QPgBCg4Be24SFJ9MRpPXBda/+x7AKqP5ryPvOOevlMQnABwAsAJACcAnABwAsAJ0O5i3LyTxvyluCm//YeIRo/5784pCE4AOAHgBIATAE4AOAHgyj8VUf0xaQH29MLzR3IKGm9/GuwxgE8AOAHgBIATAE4AOAE+Gs3+H7EpgxFLy9wD4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAE8DMzMzMzOzgTj6kz+aZMJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcALACQAnAJwAcAIsbP8AKesBV2sOrUsAAAAASUVORK5CYII=","6":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAD5klEQVR4nO2dAW7bMAxFlSE3+vc/Au80eEG3bJ2TWJb8ya//UBRo0SYOnymKspzc2iBi1AMdJQY8M4A2mb2j/NFKE7WjX1xAlI9+ZQGhEP2yAkIk+jUFhE70CwoIqei31u5Tj2N7tQNfUqhF/woBv+L255AAPP/4Ods/Hvjz3Qdpkzl6kNWGIK3oLyQAKaNPEBARF8SiSvSXyAAkjr6+AOSOvrgApI8+R8A1ZQAVoi+bASgSfU0BqBN9QQEoFX2agEllANWiL5UBKBh9HQGoGX0RASgbfaaAUWUAlaM/9HrA3ir/zAChePRrD0GoH/3CAiARfbKA6C0DMtEvmQEQin49AdCKfjEBkIv+Ng3t2yTynb79JsG4RJxqh/0V+4KS3liQg0pD0DyIOWgBZIYJ2BvN34/ysfQgdM9TA9dk2CzommmiHq4BQgJcBjpwBpCxADKeBZG5DZwFvV4Uer9YBNqpAN6KiIcgMhZAxgLkBIzqBvD1pU2uDMDX9+e4a2tINw3Fy9/rdcwjF+N+M08q5DRMGYK6y0B8djYoDUq5asAhNDQUFqChobyA6hpmCegvA20tDfkyIM7OcWppSNcHrMaUPuCB1ZKHoNndgAb5asBiWAAZC5AW4DLwFk9DdaehDyz4Na4B6gJcBl7jDCBjAWQsgMztgud4DPd9G0bRO4mKIntDp09DTxKZ7uRedAiK3KeIvoAm7eAiAf0bRtUd1MgAYQeVBDRFB8UENDkHV/QBz3TePjb5M69W6QO0Z/SrDEFiWMBKAs53A3o4A8hYABkLWKwPuKYbgPuAF1xUb+PI6wIobxoFwEMQGQsgk+izJGPJbsAZQMYCyJx99/QFB41c29P7ZrHWVmZfUCfRcOhm4W9/H9d0ZpHgAxxycpmP8W9bOf3dLT/g2Ol/nFE+0OAMIOeHBZB9WADZx9kaMGMWi9NlYHYNOMOzj60GUPqAlbsB/H1yiPYBdfBaEJmMH2cbK61LOwPIWAAZC2irC8DaZYB8QSaWCfQezEbMuBHjQ7secP7aAB65yz/8U2RfDcX+CPn21Mm8JFdDQJzLzse6Y3IN/GnobGLbdpt3nEohIOZPRtM64Nwf8F9i1M0Bucecf7hnPTPUAl2yCCsFeo9b3QzQIEURXhkLIGMBZCyAjAWQuadtERfBGUDGAshYABkLIGMBZCyAjAWQsQAyFkDGAshYABkLIGMBZCyAjAWQsQAyFkDGAshYABkLIGMBZCyAjAWQsQAyFkDGAshYABkLIGMBZCyAjAWQsQAyFkDGAshYABkLIGMBZCyAjAWQsQAyFkDGAshYABkLIGMBZCyAjAU0Lj8BkmtqC4dnSPAAAAAASUVORK5CYII=","11":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADO0lEQVR4nO3dYW6rMBAAYVL1Rnv/I+ydnlSqF6kKESSQ2bVnfrdp8GfARIHecmleXrwFERe+9rJ8XffqticB4ASAEwBOADgB4ASAu+Vs63qqR9cTXgfwCQAnAJwAcALACQAnwPDXAaOu688oItwD4ASAEwBOADgB4ASA+17GKp5+iyTrrYnPA/jgtsWr39V54RevNqu7B8SV34iqY1YOIGqM+ztFxH4DT8LwNKoFEP2n/9FtqQUwWHsMCgHEQNN//0YVAhi15wZVVkFRbfqfuvzfXBdlVgE4oXpXufcyY1kevr/vltM/C4/1dg8NGp4DsuXor0VBgKh29L+4qAYwz/R/aAADxGTT/3/Rcg/IEab/H4PzVkFbc3l71OKM6Z9HXiczf3+4iGVEiWXorjaG7NBnv3eqMgxfUx/9Iy69EX5PTc4BmaMyNAH4QBBDB4DMgRk6AHy+DxqUB0h+oXJpfZahZXaCddUbUwAkNv2fXFvcF9BnvL3yh6B63W3WM/Z7J4zCe0D2Ofq/sU+4B5za8b1BADgB4ASAa3l/wEi5B8AJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAHHl/gLkH8AkAJwCcAHACwAkAJwBc4S/nzvH1UAFO7tBDQ/0HDnwCwAnwSic+UNpzAGzgHgAnAFzn+wOCf97KoUcVdTsHxN5tO/TIoGqP2xnkEBQ/LQ0bBKA+w9YbK3wIem9Tqf/Xs/V3JwJAGF7+Q0MdgnodlKYAqM8wBcBaTYOJAGomAJwAcALAJxgB4DO2AH/Lnz62eL2ddqV48FKw2qIwD36EUA9gK2jDdsbevRAx7mdBz6tz18hcAFlm3OcCyHrjPgVAFh73kQGyw7gPCJCtxn0cgOw57u0Bsvm4dwXIUca9GUAON+5tAHLcoV/z01A4AeAEgBMATgA4AeAEgBMATgA4AeAEsLm7UfdS2ZqHIDgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ARY2P4B1BOpwbLBHaoAAAAASUVORK5CYII=","12":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADWUlEQVR4nO3dC26bYBAA4T+Rb7T3P8LeqQqoLknsNNiYWdgZVWqbusTarxjzct8GVOaKB0dss/yIu9/344/WLH/9M7rd+0bL6VVstygByOkLAE9fAHj6AsDTFwCevgDY9HP6Mca4vGDhpyq2XuCXvQ0B9pv+zR09AfaY/g/72AK8dvr/PbwhwKum/8sjSwJsP/1VB/UE2HL6q0Y/J8A2039g9HMCPNvDo58T4JETRA+cwLmXhyLgBIATAE4AOAHgBIATAE4AOAHgBIATAK71saCIBw8Ebdil8+gzb1x9vTPGpfno55a/3RmjHUAuhhrTsJdf+bxaxHS0/3VXxbUEuNksMXf1yMyIePVK0Bcg/g59mjK2Fe77NjSn6GfRGGBuNli+BC1/vUPdAfD6bgOufXsXtOvrkgDMK09fgLgzZ2p73A4gk/mXfi83wnACwAkA124b8KWIZDcPTQFiMffvX9xToh1A3Bo9KNFtG5AvfvzqugGsa4e9YwHgBIATAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBIBrd2HWqqabBu5dGrTNJSsCwDdrCADfJCPAYG8W7guQ/E3anQDi3wXPo1QnB4gbF5rXErh0vg+gQqcFGJ/fpy8/DGL+qcIndZwbYPWt8QhJX4AiJALAJALAn+nh0VA4AeAEgBMATgA4AeAEgBMATgA4AeAEgDvGsaD8dgiM+pzVngB5YpL6APnbxx2TpDhAPvWXj0BSGSC3X2I9koIAOZ033+n0LE7yNqB+PLWXo1L3SJ5/llFtDYiocrXIbmvJe/E3lzXb8HmW2hPO0a86ADlaVgQgR9cqAORoHA6Qo3cgwH57W5Vj14BAv3uJsB2x6/9lOg61B7B5VfaEI5pKVAFoK1EOoJtEXYAmEgcAOLfEkQBOKXFIgDNJHBvgBBInATiuxNkADidxWoCjSJwfoLhEI4CaEvgJGbKYQp+C0b1VWA071/olqEICwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkw2P4A6UHMoHrBa90AAAAASUVORK5CYII=","54":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAFTElEQVR4nO2dW5KjMAxF6S52pP0vQXua6pDKEMDGT11b3PORmuoAZnRkY4xNloVA+VmWRVUTtxaR9I1HRsb4j4jIb9YOqioi3c7nieQJoAO8ADrAC6ADvAA6wAugA7wAOsALoAO8ADrAC6ADvAA6wAugA7wAOsALoAO8ADrAC6CDW7bgdBRABylPhPoKoIPb53HdBdBB/GmohQA6iDyLNhJAB0tgJoCdgIc7kMA8jN/FdnbGMx1IeBaMaQ14pgOJzkECCHiUA7mbAfYnABKJJziQhPl37xogCA3q2kHi7MevJshegzp1kD739OIaYKxB3TnImvkbvAhbalBHDnLnXd/0gsw0qAsHBbPek7qhNhrU1oG8gK85yLgPMNCghg62YG0a6gstXvGRfSPWW4PaOvhErcZEzXqbwjvhrhrUti3aa9iKzjJRudppLd7zcwvdYzBPX4GwXMb1aZEO/46voas/ySoB75N4fer8DpYrDRETTU7vp+1wdPNoSR8HKYc9aDiYqD+x7WiNBWzo8A4k+ZhnDYmt0+0xmzVBFwW8PnXmtih+bbhtnUKcr+1dasCeVkeXpg7KjnZZGxJNhLpVXWrAV8GvT528Hpy7yIczKa4T3QU01KBQB5+iL3tK+5P8bH/4C1JAKw0KcnAuNK4hvQYAnglX3kWr+bhpRPl2F10zmtT9IhxHS3c0qweVHdbDt8MJ2FDLnsxrz/Ttc4sIaYD1gvpdGzT/evA/+qpfGkIHyW9Ybq8NI9aAPblnI8m7SEqID9Goa+guh/ZGrAE1tUETHMTSeIvvuVq0yMsUecMJKNAQcZDaghw0FDU+ZQzXBJ1Jb2H2W5bH70pDfY9rmiaouDZ86kFt6rYO/fQ14E2oTeh6/smdmatdJeXmcYIa8AaRKNvQT8YO+6Cn7TGPgGGpu1xTQBHt+kgUkEyfjikF3NH5hgCzRIl8oAAwFACGAmJI/3sPCgBDAWAoIILFiDQFhDB6HrDuSppkWNQCu2kva6DUJ8sQy8JCQxGyqxiPkiHG5YXHgnbrEi7/6hGxLzJ3MM6xDIGUuvY54+ncCKrgTsPRc7mR8Fd6PN/Wo9P2zwNGcyN5m5+7JI4eSYq5mxbpXKdkKAHGbm7DVHrknI77LALy4yjxQIzyahwHAgK8piQvFdhckfwKkKq4nno/vfAoQGbqA/sSINFvcdGPLOHzIkDuNsiJvln740KAJGwDbXniK1hnFiBpm43X7s8vQJK3zI9+2/bndgH36i/0OnbKTytAjEtqoDHl/QWrs9Bru1cKfQ659GRsAbIMQKGJxNd3rJ5Cr32TtUudGE+ALMNzbyL97TWrm9AroPPToE6MIUCWyfkykfXyph/wjaK0Ocwgff/cV32IAGvA9FnfJg9WB6HXMdK/DFsBHrN+EgHdQq8zp7+JAGY9TED/0Ovk6d9NALMeJsAw9Dp/+jcVwKyHCUCEXl2kf7UAZj1MADT0qk8WwKyHCRgj9KoPFDBG6F3yG5uftP3WxUjRV1/pH64BfwvlRwq8X04CBg67qm8BA4feMessoVf1ehGeIfqOmeONWeo0/acR4JgJBKjf9J9DgG9GF6Cu038CAe4ZWoB6T//RBTyBcQXoA9L/b3o6/FfaT7S5Nbf9zWdXAp7FuE3QQ6AAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAQuWf2PHPbiwANdQAAAAAElFTkSuQmCC","55":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAFTElEQVR4nO2dW5KjMAxF6S52pP0vQXua6pDKEMDGT11b3PORmuoAZnRkY4xNloVA+VmWRVUTtxaR9I1HRsb4j4jIb9YOqioi3c7nieQJoAO8ADrAC6ADvAA6wAugA7wAOsALoAO8ADrAC6ADvAA6wAugA7wAOsALoAO8ADrAC6CDW7bgdBRABylPhPoKoIPb53HdBdBB/GmohQA6iDyLNhJAB0tgJoCdgIc7kMA8jN/FdnbGMx1IeBaMaQ14pgOJzkECCHiUA7mbAfYnABKJJziQhPl37xogCA3q2kHi7MevJshegzp1kD739OIaYKxB3TnImvkbvAhbalBHDnLnXd/0gsw0qAsHBbPek7qhNhrU1oG8gK85yLgPMNCghg62YG0a6gstXvGRfSPWW4PaOvhErcZEzXqbwjvhrhrUti3aa9iKzjJRudppLd7zcwvdYzBPX4GwXMb1aZEO/46voas/ySoB75N4fer8DpYrDRETTU7vp+1wdPNoSR8HKYc9aDiYqD+x7WiNBWzo8A4k+ZhnDYmt0+0xmzVBFwW8PnXmtih+bbhtnUKcr+1dasCeVkeXpg7KjnZZGxJNhLpVXWrAV8GvT528Hpy7yIczKa4T3QU01KBQB5+iL3tK+5P8bH/4C1JAKw0KcnAuNK4hvQYAnglX3kWr+bhpRPl2F10zmtT9IhxHS3c0qweVHdbDt8MJ2FDLnsxrz/Ttc4sIaYD1gvpdGzT/evA/+qpfGkIHyW9Ybq8NI9aAPblnI8m7SEqID9Goa+guh/ZGrAE1tUETHMTSeIvvuVq0yMsUecMJKNAQcZDaghw0FDU+ZQzXBJ1Jb2H2W5bH70pDfY9rmiaouDZ86kFt6rYO/fQ14E2oTeh6/smdmatdJeXmcYIa8AaRKNvQT8YO+6Cn7TGPgGGpu1xTQBHt+kgUkEyfjikF3NH5hgCzRIl8oAAwFACGAmJI/3sPCgBDAWAoIILFiDQFhDB6HrDuSppkWNQCu2kva6DUJ8sQy8JCQxGyqxiPkiHG5YXHgnbrEi7/6hGxLzJ3MM6xDIGUuvY54+ncCKrgTsPRc7mR8Fd6PN/Wo9P2zwNGcyN5m5+7JI4eSYq5mxbpXKdkKAHGbm7DVHrknI77LALy4yjxQIzyahwHAgK8piQvFdhckfwKkKq4nno/vfAoQGbqA/sSINFvcdGPLOHzIkDuNsiJvln740KAJGwDbXniK1hnFiBpm43X7s8vQJK3zI9+2/bndgH36i/0OnbKTytAjEtqoDHl/QWrs9Bru1cKfQ659GRsAbIMQKGJxNd3rJ5Cr32TtUudGE+ALMNzbyL97TWrm9AroPPToE6MIUCWyfkykfXyph/wjaK0Ocwgff/cV32IAGvA9FnfJg9WB6HXMdK/DFsBHrN+EgHdQq8zp7+JAGY9TED/0Ovk6d9NALMeJsAw9Dp/+jcVwKyHCUCEXl2kf7UAZj1MADT0qk8WwKyHCRgj9KoPFDBG6F3yG5uftP3WxUjRV1/pH64BfwvlRwq8X04CBg67qm8BA4feMessoVf1ehGeIfqOmeONWeo0/acR4JgJBKjf9J9DgG9GF6Cu038CAe4ZWoB6T//RBTyBcQXoA9L/b3o6/FfaT7S5Nbf9zWdXAp7FuE3QQ6AAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAQuWf2PHPbiwANdQAAAAAElFTkSuQmCC","61":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAEsUlEQVR4nO2dUXLqMAxFDZMd3f0vQXt6Q5m+oSWkSSz5Wso9H/3ogBPrWLLjQLhZsyZ43InHFhLARwLISAAZCSAjAWQW1oHR0CaDsiJfmB22XR0GsPOVPQCcAaESRCaBADNjDc8BJBBQmxwCrG4S5BBQmDQCrGgSpBFQlUwCrGISZBJQkmQCrFwSJBNQj3wCrFYS5BNQjJQCrFASpBRQiawCrEoSZBVQhsQCrEQSJBZQg9wCLH8S5BZQgPQCLHkSpBeQnQoC7JEELSkVBKSmiACzljQJigjISykBSJgERQQgYejrCAASm0gvANkiXkoAkF5JYgFIFehqAoAiblIKQJ74FhQAlJKUTACShLWmAKCgrcXx27yh37NFhmg6Z8DR71LHffcaKKvNuQRFOMD0Qezp/t29pPg6ANL4O9fxkEnYywFSjX173Bayo32/B82r/Q7gF/1okc/o+5egTnocINvYf+3voY7fQxeX5xwgIPpBRnvG/qALscNrWbQsbER/f6/vI6r5egsriRUafd/G+8f+HwLwOGF0tv7a2kXG/n92hu4eGvdfLdOjD0w09n8IiIv7K5/aR62x//ri6XZDV+YrjD0BzDL2fwgY+cDA17NH0bH/+q4Z7wc8Twuk6J84bsTY/y1Az7EPiv72u4jPDX2cVpBz/NUw8Ng54479lRI0PgkQ06z5Xb64RH/j7fx7wmAdF+Sxv16CTuxo94OwWtS7TPAIxXZdYT47mu7g00zQH/f9xXxFACUJGjUPHia+D3667+dm0FkygOXgVxIcjX7/suX2qQni8/0tfhm6/qZ9+K4V58oAvzzAoRaIGyIfl6HcC2O0efHdOf6YAaElaM8DHvCVBxsvoq9c/4eoZ7CuzAFBoX//GRJ078aZUxHz6vAJEwsl9GL9jlgbi0lMa8uEPyc1nu3JJpQRm3Ebtd76kqDA2JnxOiAvsJk+G7oTu/ZMMCgDVn8ND4luyYdNIKNLkHvQ8fXXP4meLW6frMdRxwkIHe8I1bBqwulgd/4VvR+RmydRDfMn4VmwI+H28yEBHtgFrgPsexG1Zy5JVFYX8pX4X7wvXp//KbKEnTYD7MPVWZm4TyrAZo57TJ2YQoBNFfexE8i3AMY0YFPFvZOzAdzMgBgrcXG3/vdjdIosDlsi2eNOZTlwZYj56ox9NdUSc/sRaOz7xEGHA8/6bs2f7c9TBOz5HRfw/koWVuHjq2f3gix56Z2Gvs24YRqsXUOATRYdq59qH1ZB3D5bmxeruBWxq2+/rpJmlpRMgLUr8yZg2KbQtePOywDFPeSesA1Zz1i7Rgb49rNi1BzJ+akIa2UIFlAoUkFkywBrxcgmoBwSUEZAueIwhoQZYK0SCQXUQgLISEBhAbWKdRDKgEoCNOSPowwgIwFkJICMBJCRADISQGbxfTzl6/O39IsQe7hd/HE9dFSCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBDQu/wDv2zFd4pQOGAAAAABJRU5ErkJggg==","62":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADYElEQVR4nO3cYVIaQRRF4YZiR2//S+g9pRJLC6PIyMz0ef36nMqPxGih95MZQPDSWm/GdQUv2wTgEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOADgB4ASAEwBOALhbm6D48pY6TyTwGgAnAJwAj45ygxKgva/PGAgQD/4+qMUBYsNbzq0AQBz9gUMNrqsevmPH/x7ZdcnDdxz0PksDxIa3bPzA/e+5HED88u3b32F0kwK8NnG69UsCtJxDLwXQJjKoCtBmMSgM0KYwqA0wQQLACQA3xc+Ev6nf/VQ44v9/TpTXADgB4ASAm/UcEJ8P9HMd9ysAdE/CdkgCwAkAN+s5IDwJDyla9XICRFumW/Xdo+UuA0C0hQMBlt4dBHB3BqDM7nHs69TOBqi3+0dxiMHlnFccltn9aT0VwDq739dxgDV3v+/1DX0w7pBe/xYUADYQADYQADYQADYQADYQADbYD+CdgF15DYB79GCc39eDuoy6oAXrW97JQxCcAHACwAkAVxmg/zsL3j9zPWFlAfrd7pkNagL0L4unNSgI0LNu/W3Xv3cX3v5Ur/fk14BlJEa16eGcy0+L+4DQAfUdAHNK9HQvoOy7T8IenXYVx90KUuJog1dvhipxkMG2c8COS8xmFPDl94FPT+8jvuBOL1rgNWKnbx0/Xw1RwqQAffcoT0b/dGHffnxbBaAf96X+YvQ0KkMBzjhex8iz/Akqt9W/02mVM2+GDrkeRCqMJ59opAA474gUs2B8FChAnXPD7ABn36vKi5ENYMD921wYGQA6cUc0C0OcfzM022M1kWT6927F9p1o+m0AX/ZN+VVMOf1bl8SfW/HpB50DqCL59O8VBIhJpi8IEFNNXwogJpy+CEBMO/30ADH59BMDRInppwSIQtNPBhDlpp8GIIpOPwFAlJ4+NUAsMH1SgFhm+nQAsdj0iQBiyelTAMTC08MATo8BOD0G4PQYgNNjAE6PATj9lE9LibZWl57zt7gsU8Ff2DRXAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAnABwAsAJ0Nj+AEAoh9ld1CjbAAAAAElFTkSuQmCC","71":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADlklEQVR4nO3dYVLbMBCG4Q3jG+39j6A7dZpOKIEkyI7kb3f1vr/SKROXfbBiC0IvZs1Iln/ojk1/A0AcAOIAEAeAOADEASAOAHEAiANAHADiABAHgDgAxAEgDgBxAIgDQBwA4gAQB4A4AMQBIG6zsDV/9bde5MeZPlJO3zo+IElRAZYJAHEhAVrf8lJiFQoJsFIAiIsH0PYsLPlXoXgAiwWAuGAAbf+SknwVCgawXgCICwbgh7bYMq9Cl6Dvkmx9M02/J+pRAV4zpJ/7Z35pkQGuud0xxP8H9+e8T1hePgC/PyGyFx3Aa407H0D5UgJ4odMiNIAXGnRKgBWK9nNBrjo5rjcXbWUA/+XPPxoyrfuj+PkGEQBceMgf8z7bYAs7+vbkg9qUucsMtvhf9W3cwbqf6jyDrfCC47cHh2Z5ksFWb/R+e/D2/OYa/LuQ28qM3m8Phs5svMG3C+itzK1sm/XEYwyejWL6GXDa9YSHNyi+FdHmrnQ+aSWoA2CxDZYAsIQG1QAsm0FBAEtlUBPA8hiUBbAkBpUBLINBcQALb1AfwGIbLAFggQ1WAbCoBgsBWEiDCN+UFxjM2zfdi7AcgE03ePDML1TWWoJmr0UHXBcFsAkGx86qdQFsqMHhNW1pABtk8M4ryuoA9rbBm6/nALxl8P7VFADHDYZcy17m/tyIJ3tTr3fPdNf0uQ8YfB4MvI8DYLfB2LtoAPYZDN/DAGCHwYwdJAB6DSbt3wHQZTBv9xQA8d71XIDWct0GPG7q58AZIG7F74gdy+ecE79vReh/RZiLf2XHi8P371vsBtDPPYBE//HaKICIc1dIHD5AOwaQY+6nSIx6xtYJkP1K0a8GE35zykm7e+kBvjLc3XnsPDlUL/RFLkPbbe7/JSxHRQDsy+hzdfl8lHQt8idz3/vJuBwgl4T/9vWeGCCyhHevMxUA4kj4/vW9FEDGWhIAtqPFASAOAHEAiMsN0PJsOVTbimhWpHwAzUqVCaBZwbbZn+uB/2bQHz6P1Sz3i3CBABAHgDgAxAEgDgBxAIgDQBwA4gAQB4A4AMQBIA4AWrsi7w/IG0uQOADEASAOAHEAiANAHADiABAHgDgAxAEgDgBxAIgDQBwA4gAQB4A4AMQBIA4AcQCIA0AcAOIAEAeAOADEASAOAHEAiANAHADiABAHgDgAxAEgDgBxAIgDQBwA4gAQB4A4AMQBIA4AcQCIA0AcAKbtD1IPpz7P2ZGgAAAAAElFTkSuQmCC","74":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAD80lEQVR4nO3ca3KbMBRAYZLxju7+l6A9ddwkju2AeEpHiHN+tDON68f9TMBg+EhpmGjqB7Hq9hFTty9bmn5h9fsawuhTupV+7DxwQDz1Rz/1SosD5EsjPr9P9NQ6mXd9QwD5Xp/8+ytpdulZOPoTAOT7eYUjDBEzPIXWEKtGf3qAfPkpHM6zYfSdA5TgGf1fm0d/aYB8U9N8hnls2GS2cJYkwBaYx8T3r0s+d/5/25kAcAKsLiIO3IoVAE4AOAEOaM+WqADkCkCADT1P//GxIHP4ZCYB4ASAE2BFEZkDfBsTAE6Aw9q2ISrAug4/DCrA0godgRYATgA4AeAEWFS5ryAJADsJACcAnADzFf0OqgBwAsAJMFPp78ALAIMJkKvCKSACwAkwWZ0zoG7cy1j7+ho9I2znoeMa5wfUP2M3dmNVOwHQX0FwApBv/4gQACYU4L3Kp38LACfAS/WvfiAAbHkbCn9QmvwMEEU/HURrb/+vi/P8/UeXADgBvqOufSMAjCrAPfDSTwLAexvbvVpKTG5Wpcpv/yXzfdxm7cJ0a3bcaeo6mK+3PMTjwB3mbxKzxwaqAIxs8t+v6jZsmuPbLfd65E+8zl/Z7PHH6E+XPZEP6PKmpR42fjxqv67ZeU9Y1gFAlIN40GmJNi/c2mGPQXd/3dA+JAQoX3ZN7gcxuH4BUkOXr78kQAynqF+AkyQAnABw1K6I4nsj0u9DNL02wHZFHLu3OZ7ubeIeGmVobl9QLIZZMPSxu2+s5gD2HzA4F8NpAArUBMOVt4JSC++MKwM0wSAAzCAAzODxgEVr5tFvEqcj1uKX3QqKBU817kPOjnm/QedLQIx8enj9e+f9p70GnSwBUeZrdPe7XfK1uLjMEhC1vq9YbTloFCCaHHQJg5oAL08w/2xTq4M+3KDm8YATznRYtA54bq3B8UvA2ybz/yd0vtFXWw62A5Q9y/EyBvMADrqowe35qFKJotQdd2Lw+b0D6ppDKtySXx7uDYUNBIANBIANBIANBIANBIANBMiWihs0ujuaLX8Y8tjPaAIMpcedN7gcQBDjzhh0DhDNjHuqrgCi+XF3BRAnHPeJAaKLcRMAacsX8aPTcb8VjSwBcY1xjwYAXHncf/vwWBhZuC+ITgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEQEvD7YyXxegplwA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEgBMATgA4AeAEGNj+AfouAHdR1z5TAAAAAElFTkSuQmCC","88":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAEK0lEQVR4nO3dXZLaMBBG0WbKO+r9L6H3lJohIYwxxmBJtyV9t1J5SGpsrIPwDx64RIQpri9w3UoAfAKAEwCcAOAEACcAOAHALZY+N9/897ARTiGXHod+53+7U1l6HPqRVJZhhr5TlWXsoT++OspjmXDoUwUfhrp5ktGnHgY2A5KM+4wzIM+zfhXyqJZ3H9OZnVXOcWe7PHtL8uBgHfToaOij7eHQcnKwXh7MdTT07XPzXzNAg9VyElxH++8M0NA37jbglxwn5HNNgvunu94PaN3qxUYA21V6TX5crABgVAE0mgTPliYA2FIA1SfB/kIEABMKoOIkOPKzAoDlBFBlEhz/EQHAYAIoPKbvThddjCt5qe6DFysBFPP47HhJAHDaB8AJAE4AcAKAEwCcAOAEACcAOAHACQBuaXORpOVNu2HReI1JZ8BtCK4j8ux/y3ZdbMs1JgVYbW2bEYm7BfZiUAVgcztrj0g8LKoLg/IAO1tYb0TiyULyGxR+P+DIthXfQ8arlVbcJ/u54QsvCXD8mVVwRCLPLw1+gFEQ4N2BKGIQpx99rWPTgxilAD4bCD9tUOTVvPr5wQ7GPkCZzXPf+XBeP2dQanfa7hxthRFe91KEu9/+znyUEs3WGP7/z08VAe7HXQYb/RjUAngccRlsVgXg2VjLoNWliJ29rgx+V+soaGeg94vr1cyH5e38hKXs4JFViw9sqvwdEZ7T4OANo2O8I+aWtfie0pH9Q/tGmgfvntMNA2BJDDaf7/P8nrBbbw0GYN0ZjAdgfRkMCWAdGYwKYL0YDAxgXRiMDWD5DYYHsOQGMwBYZoNJACytwd6liO0T6KQb0s21ilXL2Xu7XpdKzBkDn+JiXPJ5sLnSyrelZM0tTXMCWB6DaQEsicHMAJbBYHIAww0EYKxBF4eh3nAVrY9Q8wM4tLpGEskBPMGqY1oAtxTVlUgL4JauKhI5AdxSV1IiIYBbNxWQuBhU3Tumud69Lf8y6kD0ks6E4QQAJwA4AcAJAE4AcEdPxO6PbnXg2gLg+4Qi+rm/qdvWJ2LHz+NkUGwGfHbxZbZ54HUWe/YTs6YysAoMX/NcuixSlH7OFTgMnc3AijIU/NREJqcfxsnnX9nPDeW3NozJ03xybtE3NIJ5DC0Zyn+VYdD7kjA4x79LMtBdd1iKnP0yz0CPlMKy5HN+m2pYrnYYdDkaPm8YE8CtG4YxATK3Ykh4Z9wU/TOIYWeAWxdN+nvCiRIA3MgAbh00MkAXCQBucAC37C2pvtdvwgafAfkTAJwA4AQAJwA4AcAJAE4AcAKAEwCcAOAEACcAOAHACQBOAHACgBMAnADgBAAnADgBwAkATgBwAoATAJwA4AQAJwA4AcAJAE4AcAKAEwCcAOAEACcAOAHACQBOAHACgBMAnADgBAAnADgBwAnA2P4ANi0QiwEu+J0AAAAASUVORK5CYII=","89":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAErUlEQVR4nO2dYW7rIBCESeUbzf2PwJ2qxFGVtrEDeJdZYL4f1avU59jzGYxh7dxSzknw+CJ+tpAAPhJARgLISAAZCSAjAWQkgIwEkJEAMhJARgLISAAZCSAjAWQkgIwEkJEAMhJARgLISAAZCSAjAWQkgIwEkJEAMhJARgLISACZzWm75yXXcPrUAbEXUFLtLj0OAoBs9KhB/vA5vwUN/nzDzeQA4mSAtFgLiBP9oJ3bNk30g+rZFom+4bj6+NiO0sRK0afjgwWrBSyVNVHDAHfCeMDdh+x2RnrdCZuAl9zxOAsztWV6tIagAnBwys+nIZwAFPQ2M2nYDCO7OBWByo5+Dg23K6m9jaxhgyiJ/nSrXA3pgoZGAR8jK9wsys/6gu2NqKFaQFVHcbLx6pFlLv/DkTRU3wdUCTsczHiO65GwXx6GuG+oFmCSndXKwSHgN4JCDeGGoRPkXjVS2iIM5qbMvVDDswUMqQGWe2t1N1Or4VcXNIYGGO/en6va/ms3DW+uAUE1wH5/TgYUfTTg5CIcVIMRhWO5x5/5Dtk+jILm04D6YfT+P5w0FA1Dn/c1j04g50xaHcHjZ+dTIftqAGruA/J9F8Ac8+XExlzD13wj7g7c5zqMuoFPLUCJO7OFTzynqdm8E39tqsVdZ07L0HUy7rTfzGlJiLOhiyY+9XT0cCdHlgB2o5xWAFB+5Wd2htMKKBiGhbgI3YLsx4hcmZD4KRuYvwXE4W2thgT48rFARgLs+5+qqiQJuERzBdi+xoVUtR4gXtdFUgv/1xYloCL0Zk7WdCXAK/TCtXQJMA69toZBApJJ6A21I/sFfFUB2ayyo6Fm53XstJQA3H8Yzby01Ur9H7bOLiAb1zA116gd3THMKCDbF45dqQ08v1mbRUB2qda7WJNZcp88soDsVSJ5vRa2fIpio89kASFCt6pBrp0d6rcgc758AXBCN6z9bpuY8xVQu2aEezk+7rVizqHb1txfeSrW4b2hrccFDNPP/HD9geTqFrDn++eDPZ7ggOnD1uZ7aLV7lQLenZuuz8/g2nHGPzMKBJR1CKE0ZJ+d8XgDwoGA1l6YqyG7fbrfyydeBFAnCNuy6PD0oPd7P25+hzD6s5Xo8soVRwHjakDHt924CxhLA7q/aKiTgPgaQHrHU1cBMTWA+notgoA4GsB+sxlTwHOBNudlo2cKIJ7+CBM9YUGG2+0gWPT9BNC7e4SM3l0APfcUO3q/L3Lj555GiN5YQJDc0zjRW32PWJTc02jRXxIQKvc0ZvQtApQ7R0C03NMU0X8WEDD3NFH0hwJi5p6mi37n9vMv1rzYstEbfIlPBzBv9NHL0zF79HEFYI3oIwrAStHHEoD1oo8iAKtGzxeAtaNnClD0NAGKniZA0dMEKHqaAEVPE6DoaQIUfeN09FVCT6rGJfp09PRUf6GzsEUCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBJCRADISQEYCyEgAGQkgIwFkJICMBCQu3yxOMRUGAqf2AAAAAElFTkSuQmCC","92":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAAEZklEQVR4nO2dbXLbMAxEGY1uhPsfAXfqRKpZxYpdWSS4ALhv+sNJE4vaJ/BLtvOlqoXgWIDHJhSAhwLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWBWyFFFZH+g0784HiNgj1426pedD/B45vOBy+RdkIjUuHV7UGVUH/MAq4CKbulP2zvhBbxiEhMLsP+pvI84d+/ktwImqQkv6wD9JNNMNbHC+5/Ja8JLBZS2EFE10X5ERwK6MF5D4+EWV/2PxulJepnOVgHW1L7uuJhvMeFuGqpt52M0bp+btDtob+oadP5zD/nQxMV8dxP3TtBdBRT7InjibOLK0XtdTx4FoGixfrsIRgzCN1qmDvqrMc3jLAjcc/oVoF6LoG/DlknmP26LwG8FFJdF0L1JrgXMUASL8/5HPRWBRWNYAeAiCLAQ0/26207p4mlZLKSNanEJMf+RLdE9VH38y1EEritADuewJ348p6MD650ju6HIowD5vAMZKaPv7tDqp/+RTh13o4wa3Jg7/sgK0O3E7HaeJUIRwARY7/jLrd86hnUlvvbiMBHwpt1j7rRIx6dqbvB7i+NuSQ7rpuTekX67nI9LkCZEXr0vYfWce8R+/1NWo9DvRa9tXWpL+u8OrdqhCDzvBelG45OEu/a9TEO7INYtMSsCgIDu6xopgVli9TMW6V9tlc162LwCTNfxcvcXj6/B+nW+MOydB/0FWLRXe6T/40lO+6wvL/DHT4qanJrH3dArXEzf+W2DqAIkeOg7sp3HmiN9La6RbT/l1/+KJ8B56FvWHxBPgJaoWQcUIOIq6y6Juxcg4NCflwXGFTdagL5+xYMOT//vdf346rmJyT+w6fBYTt+xxqIziSBgv8A/eY1b4uhHCTj3Kr3u8wWP3usgPE30UwgQx9EnFyDuo08rQIJEH1OAvps/xYo+poBE0ScRIGGjDy9AgkcfWICkiN7RK+OmTT9SBUiu3ANXQDK6VcC//f3/X6rfP/nyHRzFy12wMXxZbcN3jFFLYsy6oI6pSUmM5RhAB/hBmA7wsyA6wE9D6QC/DqAD/EKMDvArYTrAb0XQAX4viA7wm3F0YL4XBMxOSyCgAgZ93lvxjAMBg3sSJ+frTsCGlqF/O+PHO7ZBg4kvAfhxdXgaLgX4md7ozAL8aKjohAIcaqjoPAI8a6hoegEhNFQ0q4BYGiqaTEBQDaf1R3AB8TWkeGmiuttguE6KCohcDSkqIHI1pBMQTUNSAXE0pBsDog0Pq82nYbpDttsMrv4u386XwzZNReoxIAIUAIYCwFAAGAoAQwFgKAAMBYChADAUAIYCwFAAGAoAQwFgKAAMBYChADAUAIYCwFAAGAoAQwFgKAAMBYChADAUAIYCwFAAGAoAQwFgKAAMBYChADAUAIYCwFAAGAoAQwFgKAAMBYChADAUAIYCwFAAGAoAQwEFyx/HPH++Tl9vTwAAAABJRU5ErkJggg==","95":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACwCAIAAABIJvExAAADXklEQVR4nO3dUW7bMBAGYbbwjfb+R9g7Fa5fEsRCJFnULMmZlwJNgCT/Z7uyZDctm2Fl5t/nH9x3YE8ADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgADXgAu6rM541ZAKbMjAgB4PUFgNcXAF5fAHh9AeD1BYDXFwBeXwB4fQHg9QWA1xcAXl8AeH0B4PVba49zX2P/Jx/6blZb/yRAe/c1tr5sbn9osk6sfxbg3T1g804RsYJBnlr/vn8D5r6QmWfXv/Uf4VkN8oP17z4Kms8gP1sfOAydySA/Xp95HjCHQV6xPvZEbHSDvGh98pnwuAZ53frwqYhsq6/PnwvKtvT6PEAbx6DH+iUA2ggGndavAtBqG/RbvxBAq2rQdf2zZ0MRg2SAel/PqAXw6v1PTFzYOXTpafiHoDUTAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBIATAE4AOAHgBICr+KqI4fr64olb3qa6fPn91VrDvEfMfiYAnABwAsAJACcAnABwAsAJACcAnABwAsAJACcAXMXT0fn+b2u+j3g6gNj8QEz5Ru1aD0HRyhURXd8tXAggWtG6GlQBiFa6fgYlAKINUCcDHiDaMPUwgAGiDdblBiRAtCG79qj08POAuOh/Vhpi/ez/7I95IhZLbl0FIJYcugpArDp0CYBYeGgeINYeGgbYv35OOvSVAIcOhLd+g89qQ3P3gEmXzv8/1s/b4h2/yG3ZYseyr3MV+w0EuP6UwyEDAbqc4dlvsChA9L/CvNNgCYCALujvMZgQICr9/tZfDYYHiEpznzD4c/ggHT2sj/Jzb/XWIDNL3wOiz9xvb0EB3Q8ei+yeRz4hbjTgAaLbo8rpx8q80eD2CzK1H8Tjhi/x3eAx8dyx+05w83f51eDKo6Dit+4seXX6MEBsn4m1ox0+DH1N7vTMK+NcnQRwfRLA9UkA1ycBXJ8EcP0bGux09Hw9HJSNf4/Y4gkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJwCcAHACwAkAJ0Bj+wf4JRqkNMRmvwAAAABJRU5ErkJggg=="}};
'use strict';
const $=id=>document.getElementById(id), NS='http://www.w3.org/2000/svg';
let operationEpoch=0,restarting=false;
let activeJob=null,canInterrupt=false,interruptRequested=false;
const pendingRequests=new Set();
let data,state,busy=false,history=[],historyAt=0,view=[-15,-15,805,675],drag=null,moved=false;
const rooms=new Map(),nodes=new Map(),edgeEls=[];
const spectrum=new SpectrumTerminal({canvas:$('spectrum-screen'),input:$('spectrum-input'),upper:$('spectrum-upper'),lower:$('spectrum-lower'),status:$('spectrum-status'),onCommand:text=>command(text)});
function preference(key,fallback){try{return localStorage.getItem(key)??fallback;}catch{return fallback;}}
function savePreference(key,value){try{localStorage.setItem(key,String(value));}catch{}}
function focusCommand(){if(spectrum.active)spectrum.focus();else $('command').focus({preventScroll:true});}
function displayCompatibility(enabled){$('compatibility').checked=enabled;document.body.classList.toggle('compatibility-mode',enabled);$('spectrum-panel').hidden=!enabled;spectrum.setActive(enabled);$('compat-picture-mode').disabled=!enabled;$('compat-scale').disabled=!enabled;savePreference('sherlock-compatibility',enabled);}
$('compat-picture-mode').value=preference('sherlock-compat-picture-mode','svg');spectrum.pictureMode=$('compat-picture-mode').value;
$('compat-scale').value=preference('sherlock-compat-scale','2');spectrum.setScale($('compat-scale').value);
displayCompatibility(preference('sherlock-compatibility','false')==='true');
$('compatibility').onchange=async()=>{
 const enabled=$('compatibility').checked;if(busy&&enabled){$('compatibility').checked=spectrum.active;return;}
 displayCompatibility(enabled);if(!enabled){focusCommand();return;}if(!data||!state)return;
 const epoch=++operationEpoch;spectrum.reset();setBusy(true);try{const current=await api('/api/state');if(epoch!==operationEpoch)return;update(current);if(current.game_over){spectrum.resumeSession();await showMessages(current.ending_messages||[]);}else{if(!current.opening)spectrum.resumeSession();await spectrum.writeMessages([{kind:'narrative',text:current.opening||current.initial,screen_events:current.opening_screen||current.initial_screen,image_room:current.room}]);}}catch(error){if(epoch===operationEpoch)append('error',error.message);}finally{if(epoch===operationEpoch){setBusy(false);focusCommand();}}
};
$('compat-picture-mode').onchange=()=>{savePreference('sherlock-compat-picture-mode',$('compat-picture-mode').value);spectrum.setPictureMode($('compat-picture-mode').value);};
$('compat-scale').onchange=()=>{savePreference('sherlock-compat-scale',$('compat-scale').value);spectrum.setScale($('compat-scale').value);};
async function showMessages(messages,options){
 const native=[];
 for(const message of messages){
  if(message.kind==='system'){$('game-status').textContent='Messaggio del prototipo: '+message.text;$('game-status').hidden=false;continue;}
  appendScene(message);native.push(message);
 }
 if(spectrum.active)await spectrum.writeMessages(native,options);
}

function svg(tag,attrs={}){const el=document.createElementNS(NS,tag);for(const [k,v] of Object.entries(attrs))el.setAttribute(k,v);return el;}
function el(tag,text,cls){const e=document.createElement(tag);if(text!==undefined)e.textContent=text;if(cls)e.className=cls;return e;}
function append(kind,text){if(!text)return;$('transcript').append(el('div',text,`entry ${kind}`));$('transcript').scrollTop=$('transcript').scrollHeight;}
function appendScene(message){
 const url=data.pictures?.[message.image_room];let picture=null;
 if(url){const figure=el('figure',undefined,'scene-picture'),link=el('a'),img=el('img');
  link.href=url;link.target='_blank';link.rel='noopener';img.src=url;img.width=1024;img.height=1408;img.alt=`${String(message.image_room).padStart(3,'0')} · ${rooms.get(message.image_room)?.name_hint||'Locazione'}`;
  img.addEventListener('error',()=>figure.remove());link.append(img);figure.append(link,el('figcaption',img.alt+' · apri SVG'));$('transcript').append(figure);picture=figure;
 }
 append(message.kind,message.text);
 if(picture&&!$('pictures').checked)return;
 if(picture)$('transcript').scrollTop+=picture.getBoundingClientRect().top-$('transcript').getBoundingClientRect().top;
}
function setPictures(enabled){spectrum.setPictures(enabled);$('pictures').checked=enabled;document.body.classList.toggle('pictures-off',!enabled);try{localStorage.setItem('sherlock-pictures',String(enabled));}catch{}}
let picturesEnabled=true;try{picturesEnabled=localStorage.getItem('sherlock-pictures')!=='false';}catch{}
setPictures(picturesEnabled);$('pictures').onchange=()=>setPictures($('pictures').checked);
async function api(path,body){
 const request=(async()=>{const options=body===undefined?{}:{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)};const res=await fetch(path,options);const value=await res.json();if(!res.ok)throw new Error(value.error||'Richiesta non riuscita');return value;})();
 pendingRequests.add(request);try{return await request;}finally{pendingRequests.delete(request);}
}
function setBusy(value){busy=value;const ended=Boolean(state?.game_over);$('command').disabled=value||ended;$('submit').disabled=value||ended;$('reset').disabled=restarting||!data;$('busy-label').textContent=value?'Analisi del comando…':'In inglese, come nell’originale';$('map').setAttribute('aria-busy',String(value));spectrum.setBusy(value);for(const button of document.querySelectorAll('[data-command]'))button.disabled=value||ended;}
function setClock(clock){spectrum.setClock(clock.label);$('clock').textContent=clock.label;$('ticks').textContent=`Tick ${clock.tick} · ${state?.visited.length||0} luoghi esplorati`;}
function update(s){const previousRoom=state?.room;state=s;spectrum.setRoom(s.room);spectrum.setEnded(s.game_over);setClock(s.clock);$('game-status').hidden=!s.game_over;if(s.game_over)$('game-status').textContent='Partita terminata. Usa Riavvia per ricominciare.';$('room-id').textContent=String(s.room).padStart(3,'0');$('room-name').textContent=s.name;
 for(const [id,node] of nodes){node.classList.toggle('current',id===s.room);node.classList.toggle('visited',s.visited.includes(id));node.setAttribute('aria-pressed',String(id===s.room));}
 for(const [edge,node] of edgeEls)node.classList.toggle('near',edge.source===s.room);
 updateCharacters(s);
 if(previousRoom!==undefined&&previousRoom!==s.room&&(previousRoom===1||s.room===1))centerRoom(s.room);
 $('exits').replaceChildren();for(const e of s.exits){const row=el('div',undefined,'exit'),button=el('button',e.direction),desc=el('div',`${String(e.target).padStart(3,'0')} ${e.target_name||'destinazione non attiva'}`);button.title='Esegui il movimento, rispettando gli ostacoli';button.onclick=()=>command(e.direction);desc.append(el('small',`${e.gate_name?e.gate_name+' · ':''}${e.status}`));row.append(button,desc);$('exits').append(row);}if(!s.exits.length)$('exits').append(el('span','Nessuna uscita direzionale.'));
 $('objects').replaceChildren();for(const o of s.visible){const item=el('span',o.name,'entity');item.title=`Entità ${o.id}${s.objects.some(x=>x.id===o.id)?' · elencata nella scena':''}`;$('objects').append(item);}if(!s.visible.length)$('objects').append(el('span',s.dark?'È buio: nessun elenco visivo disponibile.':'Nessuna entità percepibile.'));
 if(s.analysis){const a=s.analysis;$('analysis').textContent=JSON.stringify({esito:a.outcome,riga:a.normalised,unita:a.units,controlli:a.controls},null,2);}}
function waitControls(job,allowed){activeJob=job;canInterrupt=Boolean(allowed);$('interrupt-wait').hidden=!canInterrupt;$('interrupt-wait').disabled=interruptRequested;}
function interruptWait(){if(!activeJob||!canInterrupt||spectrum.waiting)return;interruptRequested=true;$('interrupt-wait').disabled=true;}
$('interrupt-wait').onclick=interruptWait;
document.addEventListener('keydown',e=>{if(e.key==='Enter'&&activeJob&&canInterrupt&&!spectrum.waiting){e.preventDefault();interruptWait();}});
async function consumeCommand(result,epoch){
 let continuing=false;
 while(epoch===operationEpoch){
  if(!result.running){update(result.state);await showMessages(result.messages,{complete:true,continuing});waitControls(null,false);return;}
  waitControls(result.job,result.can_interrupt);
  await showMessages(result.messages,{complete:false,continuing});continuing=true;
  if(epoch!==operationEpoch)return;
  setClock(result.clock);
  $('spectrum-status').textContent=canInterrupt?'Attesa in corso: Invio interrompe; MORE continua la pagina.':'Comando in corso…';
  // Let each native clock frame be painted before executing the next minute.
  await new Promise(resolve=>setTimeout(resolve,100));
  if(epoch!==operationEpoch)return;
  const interrupt=interruptRequested;interruptRequested=false;
  result=await api('/api/continue-command',{job:activeJob,interrupt});
 }
}
async function perform(path,body,focus=true){if(busy||state?.game_over)return;const epoch=++operationEpoch;interruptRequested=false;$('game-status').hidden=true;setBusy(true);try{const r=await api(path,body);if(epoch!==operationEpoch)return;if(path==='/api/start-command')await consumeCommand(r,epoch);else{update(r.state);await showMessages(r.messages);}}catch(error){if(epoch===operationEpoch)await showMessages([{kind:'system',text:error.message}]);}finally{if(epoch===operationEpoch){waitControls(null,false);setBusy(false);if(focus||spectrum.active)focusCommand();}}}
async function command(text){if(busy||state?.game_over||!text.trim())return;history.push(text);historyAt=history.length;append('command',text);if(spectrum.active)spectrum.commit(text);$('command').value='';await perform('/api/start-command',{command:text});}
async function teleport(id){if(busy||state?.game_over)return;$('search-results').hidden=true;$('search').value='';await perform('/api/teleport',{room:id},false);}
function applyView(){$('map').setAttribute('viewBox',view.join(' '));}
function zoom(factor,cx=view[0]+view[2]/2,cy=view[1]+view[3]/2){const width=Math.min(7000,Math.max(250,view[2]*factor)),ratio=width/view[2];view=[cx+(view[0]-cx)*ratio,cy+(view[1]-cy)*ratio,width,view[3]*ratio];applyView();}
function point(e){const p=$('map').createSVGPoint();p.x=e.clientX;p.y=e.clientY;return p.matrixTransform($('map').getScreenCTM().inverse());}
const NODE_W=142,NODE_H=104;
const OPPOSITE={N:'S',S:'N',E:'W',W:'E',NE:'SW',SW:'NE',NW:'SE',SE:'NW'};
function portDirection(dx,dy){
 const x=Math.abs(dx)/(NODE_W/2+3),y=Math.abs(dy)/(NODE_H/2+3);
 if(x>=.78&&y>=.78)return (dy<0?'N':'S')+(dx<0?'W':'E');
 return x>y?(dx<0?'W':'E'):(dy<0?'N':'S');
}
function addDirectionLabel(edge,geometry){
 const {x,y,tx,ty,sx,sy,ex,ey,cx,cy,parallelCount,parallelIndex}=geometry;
 const departure=portDirection(sx-x,sy-y),arrival=portDirection(ex-tx,ey-ty);
 if(parallelCount===1&&edge.direction===departure&&OPPOSITE[edge.direction]===arrival)return;
 const t=parallelCount>1?.28+.4*parallelIndex/(parallelCount-1):.36,u=1-t,dx=ex-sx,dy=ey-sy,len=Math.hypot(dx,dy)||1;
 const px=u*u*sx+2*u*t*cx+t*t*ex-dy/len*16,py=u*u*sy+2*u*t*cy+t*t*ey+dx/len*16;
 const label=svg('g',{class:'edge-label',transform:`translate(${px} ${py})`,'data-source':edge.source,'data-target':edge.target,'data-direction':edge.direction,'data-departure':departure,'data-arrival':arrival});
 const width=16+edge.direction.length*8;label.append(svg('rect',{x:-width/2,y:-10,width,height:20,rx:4}));
 const text=svg('text');text.textContent=edge.direction;label.append(text);$('edge-labels').append(label);edgeEls.push([edge,label]);
}
function characterColour(character){return character.is_player?'#85602d':`hsl(${(character.id*67+190)%360} 42% 36%)`;}
function characterTitle(character){return character.name+(character.parent_id!==null?` · contenuto in entità ${character.parent_id}`:'');}
function updateCharacters(s){
 for(const marker of document.querySelectorAll('#nodes .character-marker'))marker.remove();
 const groups=new Map();const characters=s.characters||[];
 for(const character of characters)for(const room of character.rooms){if(!nodes.has(room))continue;if(!groups.has(room))groups.set(room,[]);groups.get(room).push(character);}
 for(const [room,people] of groups){
  people.sort((a,b)=>Number(b.is_player)-Number(a.is_player)||a.id-b.id);
  const shown=people.slice(0,people.length>5?4:5),count=shown.length+(people.length>5?1:0),spacing=23;
  shown.forEach((character,index)=>{
   const marker=svg('g',{class:`character-marker ${character.is_player?'player':''}`,transform:`translate(${(index-(count-1)/2)*spacing} 34)`,'data-character':character.key,'data-entity':character.id,'data-name':character.name,'aria-label':character.name,style:`--character-colour:${characterColour(character)}`});
   const title=svg('title');title.textContent=characterTitle(character);marker.append(title,svg('circle',{r:10}));const text=svg('text');text.textContent=character.badge;marker.append(text);nodes.get(room).append(marker);
  });
  if(people.length>5){const extra=people.slice(4),marker=svg('g',{class:'character-marker character-overflow',transform:`translate(${((count-1)/2)*spacing} 34)`,'data-name':extra.map(p=>p.name).join(', '),style:'--character-colour:#66756a'});marker.append(svg('circle',{r:10}));const text=svg('text');text.textContent='+'+extra.length;marker.append(text);nodes.get(room).append(marker);}
 }
 const list=$('character-list');list.replaceChildren();
 const mapped=characters.filter(c=>c.rooms.length).length;$('character-count').textContent=`· ${mapped} sulla mappa`;
 for(const character of characters){const button=el('button',undefined,`character-item ${character.is_player?'player':''} ${character.rooms.length?'':'off-map'}`);button.style.setProperty('--character-colour',characterColour(character));button.append(el('span',character.badge,'character-badge'));const desc=el('span',character.name);desc.append(el('small',character.rooms.length?character.rooms.map(r=>`${String(r).padStart(3,'0')} ${rooms.get(r)?.name_hint||''}`).join(' / '):'Fuori mappa'));button.append(desc);button.title=character.rooms.length?'Inquadra '+character.name:character.name+' · nessuna locazione attiva';button.disabled=!character.rooms.length;button.onclick=()=>centerRoom(character.rooms[0]);list.append(button);}
}
function wrapName(name){const lines=[];let line='';for(const word of name.split(/\s+/)){if(line&&(line+' '+word).length>19){lines.push(line);line=word;}else line+=(line?' ':'')+word;}if(line)lines.push(line);return lines;}
function fitGraph(){const pts=[...rooms.values()].filter(r=>r.id).map(r=>r.layout),xs=pts.map(p=>p[0]),ys=pts.map(p=>p[1]);view=[Math.min(...xs)-110,Math.min(...ys)-100,Math.max(...xs)-Math.min(...xs)+220,Math.max(...ys)-Math.min(...ys)+200];applyView();}
function centerRoom(id=state?.room||8){const [x,y]=rooms.get(id).layout;view=[x-310,y-245,620,650];applyView();}
function buildGraph(){
 const list=data.rooms.filter(r=>r.id);
 for(const r of data.rooms){rooms.set(r.id,r);const [x,y]=r.coordinates||[30+r.id%10*70,620];r.layout=[x*4.6,y*4.1];}
 // Allontana solo i riquadri sovrapposti, preservando la disposizione di riferimento.
 for(let pass=0;pass<160;pass++){let changed=false;for(let i=0;i<list.length;i++)for(let j=i+1;j<list.length;j++){const a=list[i].layout,b=list[j].layout,dx=b[0]-a[0],dy=b[1]-a[1],ox=NODE_W+14-Math.abs(dx),oy=NODE_H+14-Math.abs(dy);if(ox>0&&oy>0){changed=true;if(ox<oy){const d=(ox+.1)/2*(dx>=0?1:-1);a[0]-=d;b[0]+=d;}else{const d=(oy+.1)/2*(dy>=0?1:-1);a[1]-=d;b[1]+=d;}}}if(!changed)break;}
 const counts=new Map(),indices=new Map();for(const e of data.edges){const key=e.source+':'+e.target;counts.set(key,(counts.get(key)||0)+1);}
 const boundary=(x,y,dx,dy)=>{const t=Math.min((NODE_W/2+3)/(Math.abs(dx)||1e-9),(NODE_H/2+3)/(Math.abs(dy)||1e-9));return [x+dx*t,y+dy*t];};
 for(const e of data.edges){if(!e.target||!e.source)continue;const [x,y]=rooms.get(e.source).layout,[tx,ty]=rooms.get(e.target).layout,dx=tx-x,dy=ty-y,len=Math.hypot(dx,dy)||1;const key=e.source+':'+e.target,parallelCount=counts.get(key),parallelIndex=indices.get(key)||0;indices.set(key,parallelIndex+1);const bend=10+parallelIndex*30;const [sx,sy]=boundary(x,y,dx,dy),[ex,ey]=boundary(tx,ty,-dx,-dy),cx=(sx+ex)/2-dy/len*bend,cy=(sy+ey)/2+dx/len*bend;
  const path=svg('path',{d:`M ${sx} ${sy} Q ${cx} ${cy} ${ex} ${ey}`,class:`edge ${e.gate?'gated':''}`,'data-source':e.source,'data-target':e.target,'data-direction':e.direction});const title=svg('title');title.textContent=`${e.source} → ${e.target} · ${e.direction}${e.gate_name?' · '+e.gate_name:''}`;path.append(title);$('edges').append(path);edgeEls.push([e,path]);addDirectionLabel(e,{x,y,tx,ty,sx,sy,ex,ey,cx,cy,parallelCount,parallelIndex});}
 for(const r of list){const [x,y]=r.layout,node=svg('g',{transform:`translate(${x} ${y})`,class:'node',tabindex:0,role:'button','aria-label':`Vai a ${String(r.id).padStart(3,'0')} ${r.name_hint}`,'data-room':r.id});node.append(svg('rect',{x:-NODE_W/2,y:-NODE_H/2,width:NODE_W,height:NODE_H,rx:5}));const num=svg('text',{y:-37,class:'node-number'});num.textContent=String(r.id).padStart(3,'0');node.append(num);const name=svg('text',{class:'node-name'}),lines=wrapName(r.name_hint);lines.forEach((line,i)=>{const span=svg('tspan',{x:0,y:-17+i*13});span.textContent=line;name.append(span);});node.append(name);
  node.addEventListener('click',()=>{if(!moved)teleport(r.id);});node.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();teleport(r.id);}});
  node.addEventListener('pointermove',e=>{const box=$('map').parentElement.getBoundingClientRect();const person=e.target.closest('.character-marker');$('tooltip').textContent=person?person.getAttribute('data-name'):`${String(r.id).padStart(3,'0')} · ${r.name_hint}`;$('tooltip').style.left=Math.max(5,Math.min(e.clientX-box.left+12,box.width-230))+'px';$('tooltip').style.top=Math.max(3,e.clientY-box.top-35)+'px';$('tooltip').hidden=false;});node.addEventListener('pointerleave',()=>{$('tooltip').hidden=true;});$('nodes').append(node);nodes.set(r.id,node);}
 $('graph-count').textContent=`${nodes.size} luoghi · ${data.edges.length} archi`;$('map').classList.add('show-labels');centerRoom(8);
}
$('command-form').addEventListener('submit',e=>{e.preventDefault();command($('command').value);});
$('command').addEventListener('keydown',e=>{if(e.key==='ArrowUp'||e.key==='ArrowDown'){e.preventDefault();historyAt=Math.max(0,Math.min(history.length,historyAt+(e.key==='ArrowUp'?-1:1)));$('command').value=history[historyAt]||'';}});
for(const b of document.querySelectorAll('[data-command]'))b.onclick=()=>command(b.dataset.command);
$('reset').onclick=async()=>{
 if(restarting||!data)return;const epoch=++operationEpoch;restarting=true;
 waitControls(null,false);interruptRequested=false;
 spectrum.reset();$('transcript').replaceChildren();$('command').value='';$('analysis').textContent='';history=[];historyAt=0;
 $('search').value='';$('search-results').hidden=true;setBusy(true);
 try{
  // Let an already submitted action finish before replacing its session.
  await Promise.allSettled([...pendingRequests]);
  const r=await api('/api/reset',{});if(epoch!==operationEpoch)return;
  update(r.state);centerRoom(r.state.room);restarting=false;setBusy(true);
  await showMessages(r.messages);
 }catch(error){if(epoch===operationEpoch)append('error',error.message);}
 finally{if(epoch===operationEpoch){restarting=false;setBusy(false);focusCommand();}}
};
$('about').onclick=()=>$('help').showModal();$('close-help').onclick=()=>$('help').close();
$('labels').onchange=()=>$('map').classList.toggle('show-labels',$('labels').checked);
$('fit').onclick=fitGraph;$('center').onclick=()=>centerRoom();$('zoom-in').onclick=()=>zoom(.75);$('zoom-out').onclick=()=>zoom(1.333);
$('map').addEventListener('wheel',e=>{e.preventDefault();const p=point(e);zoom(e.deltaY>0?1.13:.885,p.x,p.y);},{passive:false});
$('map').addEventListener('pointerdown',e=>{if(e.button!==0)return;moved=false;drag={x:e.clientX,y:e.clientY,view:[...view],node:e.target.closest('.node')};if(!drag.node)$('map').setPointerCapture(e.pointerId);});
$('map').addEventListener('pointermove',e=>{if(!drag)return;const dx=e.clientX-drag.x,dy=e.clientY-drag.y;if(Math.hypot(dx,dy)>4)moved=true;if(moved){$('map').classList.add('dragging');const scale=$('map').getScreenCTM().a;view=[drag.view[0]-dx/scale,drag.view[1]-dy/scale,drag.view[2],drag.view[3]];applyView();}});
window.addEventListener('pointerup',()=>{drag=null;$('map').classList.remove('dragging');});
$('map').addEventListener('pointercancel',()=>{drag=null;$('map').classList.remove('dragging');});
$('search').addEventListener('input',()=>{const q=$('search').value.trim().toLowerCase(),list=$('search-results');list.replaceChildren();list.hidden=!q;if(!q)return;const found=data.rooms.filter(r=>r.id&&(r.name_hint.toLowerCase().includes(q)||String(r.id).padStart(3,'0').includes(q))).slice(0,18);for(const r of found){const b=el('button',`${String(r.id).padStart(3,'0')} · ${r.name_hint} →`);b.onclick=()=>{centerRoom(r.id);teleport(r.id);};list.append(b);}if(!found.length)list.append(el('p','Nessun luogo corrispondente.'));});
(async()=>{const epoch=++operationEpoch;setBusy(true);try{data=await api('/api/data');spectrum.configure(SPECTRUM_ASSETS,data.pictures,SPECTRUM_ASSETS.pixels);buildGraph();const initialState=await api('/api/state');if(epoch!==operationEpoch)return;update(initialState);centerRoom(state.room);setBusy(true);if(initialState.command_running){spectrum.resumeSession();await consumeCommand({running:true,job:initialState.job,can_interrupt:initialState.can_interrupt,clock:initialState.clock,messages:[]},epoch);}else if(initialState.game_over){spectrum.resumeSession();await showMessages(initialState.ending_messages||[]);}else{if(!initialState.opening)spectrum.resumeSession();await showMessages([{kind:'narrative',text:initialState.opening||initialState.initial,screen_events:initialState.opening_screen||initialState.initial_screen,image_room:initialState.room}]);}}catch(error){if(epoch===operationEpoch)append('error',`Start the Python server to use the explorer. ${error.message}`);}finally{if(epoch===operationEpoch){setBusy(false);focusCommand();}}})();
