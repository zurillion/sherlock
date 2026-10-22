'use strict';
// Presentation only: world, parser and clock still come from the Python server.
class SpectrumBuffer {
 constructor(columns=36, rows=18){this.columns=columns;this.rows=rows;this.clear();}
 clear(){this.lines=Array(this.rows).fill('');this.scrollAllowance=0;this.scrolls=0;}
 startPage(){this.scrollAllowance=this.rows-1;}
 newline(){
  if(this.lines.length===this.rows){if(!this.scrollAllowance)return false;this.lines.shift();this.scrollAllowance--;this.scrolls++;}
  this.lines.push('');return true;
 }
 word(text){
  let line=this.lines[this.lines.length-1],space=line.length?1:0;
  if(line.length+space+Math.min(text.length,this.columns)>this.columns){if(!this.newline())return 0;line='';space=0;}
  const count=Math.min(text.length,this.columns-line.length-space);
  this.lines[this.lines.length-1]=line+(space?' ':'')+text.slice(0,count);return count;
 }
 more(){this.scrollAllowance=this.rows;}
 visible(){return [...this.lines,...Array(this.rows-this.lines.length).fill('')].map(line=>line.padEnd(36,' '));}
}
function spectrumTokens(text){return text.replace(/\r\n?/g,'\n').trim().match(/\n|[^\s]+/g)||[];}
function spectrumWrap(text,columns=36){const lines=[''];for(const c of text){if(c==='\n'||lines[lines.length-1].length===columns)lines.push('');if(c!=='\n')lines[lines.length-1]+=c;}return lines;}
class SpectrumTerminal {
 constructor({canvas,input,upper,lower,status,onCommand}){
  Object.assign(this,{canvas,input,upper,lower,status,onCommand});this.model=new SpectrumBuffer();this.active=false;this.busy=false;this.processing=false;this.waiting=false;this.waitingReason=null;this.startupPending=true;this.epoch=0;this.draft='';this.lowerHistory=[];this.lowerLine='';this.upperSeparated=false;this.clock='Mon 08:00am';this.clockVisible=false;this.scale=2;this.pictureMode='svg';this.pictures=true;this.picture=null;this.pictureTop=0;this.pictureNarrow=false;this.cache=new Map();this.delay=32.5;
  input.addEventListener('keydown',e=>this.key(e));input.addEventListener('beforeinput',e=>{e.preventDefault();if(this.busy||this.processing||this.waiting||this.ended)return;if(e.inputType==='insertText'&&e.data)for(const c of e.data)this.type(c);else if(e.inputType==='deleteContentBackward')this.backspace();});
  for(const event of ['paste','drop','cut'])input.addEventListener(event,e=>e.preventDefault());
  input.addEventListener('input',()=>{input.value=this.draft;});
  canvas.parentElement.addEventListener('click',()=>{if(this.waiting)this.more();else this.focus();});
  document.addEventListener('keydown',e=>{if(this.active&&this.waiting){e.preventDefault();e.stopImmediatePropagation();this.more();}},true);
  this.blink=setInterval(()=>{if(this.active&&this.waiting)this.render();},320);
 }
 configure(assets,pictures,pixels){this.assets=assets;this.urls={svg:pictures||{},pixel:pixels||{}};this.render();}
 setActive(value){this.active=value;if(!value)this.cancel();this.render();}
 setBusy(value){this.busy=value;this.input.setAttribute('aria-busy',String(value));this.render();}
 setClock(value){this.clock=value;this.render();}
 setEnded(value){this.ended=Boolean(value);this.input.setAttribute('aria-disabled',String(this.ended));this.render();}
 resumeSession(){this.startupPending=false;this.clockVisible=true;this.model.startPage();this.render();}
 setScale(value){this.scale=Number(value)===3?3:2;this.render();}
 setPictures(value){this.pictures=value;this.model.columns=this.picture&&value&&this.pictureNarrow?18:36;this.render();}
 setRoom(room){if(this.room!==undefined&&room!==this.room)this.clearPicture();this.room=room;}
 async setPictureMode(value){this.pictureMode=value==='pixel'?'pixel':'svg';if(this.picture)await this.loadPicture(this.picture.room,false);this.render();}
 clearPicture(){this.picture=null;this.pictureNarrow=false;this.model.columns=36;this.render();}
 reset(){this.cancel();this.ended=false;this.commandWroteUpper=false;this.clock='Mon 08:00am';this.clockVisible=false;this.startupPending=true;this.model.clear();this.upperSeparated=false;this.lowerHistory=[];this.lowerLine='';this.draft='';this.input.value='';this.clearPicture();this.render();}
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
 more(){if(!this.waiting)return;if(this.waitingReason==='startup'){this.clockVisible=true;this.model.startPage();}else{this.model.more();if(this.picture&&this.pictureNarrow)this.picture.scrollOrigin=this.model.scrolls;this.pictureNarrow=false;this.model.columns=36;}this.waiting=false;this.waitingReason=null;const resolve=this.resume;this.resume=null;this.render();if(resolve)resolve(true);}
 async pause(reason='more'){this.waiting=true;this.waitingReason=reason;this.status.textContent='Premi un tasto qualsiasi per continuare.';this.render();return new Promise(resolve=>{this.resume=resolve;});}
 async line(epoch){while(!this.model.newline()){if(!await this.pause()||epoch!==this.epoch)return false;}return epoch===this.epoch;}
 async loadPicture(room,fresh=true){
  const url=this.urls?.[this.pictureMode]?.[room];if(!url){this.clearPicture();return;}
  const epoch=this.epoch,mode=this.pictureMode;
  if(!this.cache.has(url))this.cache.set(url,new Promise(resolve=>{const image=new Image();image.onload=()=>resolve(image);image.onerror=()=>resolve(null);image.src=url;}));
  const image=await this.cache.get(url);if(epoch!==this.epoch||mode!==this.pictureMode||(this.room!==undefined&&this.room!==room))return;
  if(!image){this.clearPicture();return;}
  if(fresh){this.model.clear();this.model.startPage();this.upperSeparated=false;this.pictureTop=0;this.pictureNarrow=true;}
  this.picture={room,image,url,scrollOrigin:fresh?this.model.scrolls:(this.picture?.scrollOrigin??this.model.scrolls)};this.model.columns=this.pictures&&this.pictureNarrow?18:36;this.render();
 }
 async writeMessages(messages,{complete=true,continuing=false}={}){
  if(!this.active)return;const epoch=this.epoch;let wroteUpper=false;if(!continuing)this.commandWroteUpper=false;this.processing=true;this.status.textContent='Scrittura del testo…';this.render();
  try{
   if(this.startupPending&&messages.some(message=>message.kind!=='error'&&message.text?.trim())){this.startupPending=false;if(!await this.pause('startup')||epoch!==this.epoch)return;}
   for(const message of messages){
    if(epoch!==this.epoch||!this.active)return;
    if(message.image_room!==undefined&&message.image_room!==null){if(this.pictures)await this.loadPicture(message.image_room);else this.clearPicture();}
    const text=message.text||'';if(!text.trim())continue;
    const lower=message.kind==='error';
    if(!lower){
     if((this.upperSeparated||this.model.lines.at(-1).length)&&!await this.line(epoch))return;
     this.upperSeparated=false;wroteUpper=true;this.commandWroteUpper=true;
    }
    for(const token of spectrumTokens(lower?text.toUpperCase():text)){
     if(epoch!==this.epoch||!this.active)return;
     if(lower){
      if(token==='\n'){if(this.lowerLine){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}}
      else{for(let remaining=token;remaining;){if(this.lowerLine.length&&(this.lowerLine.length+1+Math.min(remaining.length,34)>34)){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}const count=Math.min(remaining.length,34-this.lowerLine.length-(this.lowerLine?1:0));this.lowerLine+=(this.lowerLine?' ':'')+remaining.slice(0,count);remaining=remaining.slice(count);}}
     }else if(token==='\n'){if(!await this.line(epoch))return;}
     else{let remaining=token;while(remaining){const count=this.model.word(remaining);if(!count){if(!await this.pause()||epoch!==this.epoch||!await this.line(epoch))return;}else remaining=remaining.slice(count);}}
     this.render();await new Promise(resolve=>setTimeout(resolve,this.delay));
    }
    if(lower&&this.lowerLine){this.lowerHistory.push(this.lowerLine);this.lowerLine='';}
    this.lowerHistory=this.lowerHistory.slice(-40);
   }
   if(complete&&(wroteUpper||this.commandWroteUpper)&&epoch===this.epoch&&await this.line(epoch)){this.upperSeparated=true;this.commandWroteUpper=false;}
  }finally{if(epoch===this.epoch){this.processing=false;this.status.textContent=this.ended?'Partita terminata. Usa Riavvia.':'Pronto. Caratteri, Backspace, Invio.';this.render();}}
 }
 lowerRows(){const rows=[...this.lowerHistory];if(this.lowerLine)rows.push(this.lowerLine);const draft=spectrumWrap(this.draft+(!this.busy&&!this.processing&&!this.ended?'+':''),34);rows.push(...draft);return [...Array(Math.max(0,5-rows.length)).fill(null),...rows.slice(-5)].map(line=>line===null?' '.repeat(36):('> '+line).padEnd(36,' '));}
 render(){
  const upper=this.model.visible(),lower=this.lowerRows();this.upper.textContent=upper.join('\n');this.lower.textContent=lower.join('\n');
  this.canvas.setAttribute('aria-label',`Schermo ZX Spectrum${this.clockVisible?' · '+this.clock:''}. 36 colonne, 18 righe di testo, una riga di stato, 5 righe di comando.`);this.canvas.dataset.waiting=String(this.waiting);this.canvas.dataset.waitingReason=this.waitingReason||'';this.canvas.dataset.clockX='16';this.canvas.dataset.clockVisible=String(this.clockVisible);this.canvas.dataset.clock=this.clockVisible?this.clock:'';this.canvas.dataset.processing=String(this.processing);this.canvas.dataset.columns=String(this.model.columns);this.canvas.dataset.scrolls=String(this.model.scrolls);this.canvas.dataset.picture=this.picture&&this.pictures?String(this.picture.room):'';this.canvas.dataset.pictureMode=this.pictureMode;
  if(!this.assets)return;
  const scale=this.scale,dpr=window.devicePixelRatio||1,w=256*scale,h=192*scale;
  if(this.canvas.width!==Math.round(w*dpr)||this.canvas.height!==Math.round(h*dpr)){this.canvas.width=Math.round(w*dpr);this.canvas.height=Math.round(h*dpr);}
  this.canvas.style.width=w+'px';this.canvas.style.height=h+'px';const ctx=this.canvas.getContext('2d');ctx.setTransform(scale*dpr,0,0,scale*dpr,0,0);ctx.fillStyle='#cdcdcd';ctx.fillRect(0,0,256,192);
  ctx.save();ctx.beginPath();ctx.rect(0,0,256,144);ctx.clip();
  if(this.picture&&this.pictures){const y=this.pictureTop-(this.pictureNarrow?0:8*(this.model.scrolls-this.picture.scrollOrigin));ctx.imageSmoothingEnabled=this.pictureMode!=='pixel';ctx.drawImage(this.picture.image,128,y,128,176);}
  for(let row=0;row<18;row++)this.drawText(ctx,upper[row],2,row*8);ctx.restore();
  ctx.fillStyle='#fff';ctx.fillRect(0,144,256,8);ctx.fillStyle='#000';
  for(let row=0;row<6;row++)for(let x=0;x<256;x++)if(this.assets.divider[row*4+Math.floor(x/8)%4]&(128>>(x%8)))ctx.fillRect(x,145+row,1,1);
  if(this.clockVisible){ctx.fillStyle='#fff';ctx.fillRect(14,144,this.clock.length*7+6,8);this.drawText(ctx,this.clock,16,144);}
  if(this.waiting){ctx.fillStyle='#fff';ctx.fillRect(247,144,9,8);if(Math.floor(Date.now()/320)%2===0){ctx.fillStyle='#000';ctx.fillRect(249,145,6,6);}}
  for(let row=0;row<5;row++)this.drawText(ctx,lower[row],2,152+row*8);
 }
 drawText(ctx,text,x,y){ctx.fillStyle='#000';for(const character of text){let code=character==='£'?96:character.charCodeAt(0);if(code<32||code>127)code=63;const glyph=this.assets.glyphs[code-this.assets.first];for(let row=0;row<8;row++)for(let col=0;col<8;col++)if(glyph[row]&(128>>col))ctx.fillRect(x+col,y+row,1,1);x+=7;}}
}
if(typeof module!=='undefined')module.exports={SpectrumBuffer,SpectrumTerminal,spectrumTokens,spectrumWrap};
