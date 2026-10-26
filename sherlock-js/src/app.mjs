import {SpectrumTerminal} from './spectrum.mjs';
import {ClientSession,engineStatus,gameStatus} from './session.mjs';
import {rememberTab,recallTab,TAB_SESSION_KEY,capturePresentation,lastResponse} from './tab-session.mjs';
const bundle=await fetch('./data/game.json').then(response=>{if(!response.ok)throw Error('Dati del gioco non disponibili');return response.json();});
const SPECTRUM_ASSETS=bundle.spectrum,session=new ClientSession(bundle,{npc_profile:'world-v5',seed:1});
'use strict';
const $=id=>document.getElementById(id), NS='http://www.w3.org/2000/svg';
let operationEpoch=0,restarting=false,persisting=false;
let activeJob=null,canInterrupt=false,interruptRequested=false;
const pendingRequests=new Set();
let transcriptRows=[],replayingTranscript=false;
let data,state,busy=false,history=[],historyAt=0,view=[-15,-15,805,675],drag=null,moved=false;
const rooms=new Map(),nodes=new Map(),edgeEls=[];
const spectrum=new SpectrumTerminal({canvas:$('spectrum-screen'),input:$('spectrum-input'),upper:$('spectrum-upper'),lower:$('spectrum-lower'),status:$('spectrum-status'),onCommand:text=>command(text)});
function preference(key,fallback){try{return localStorage.getItem(key)??fallback;}catch{return fallback;}}
function savePreference(key,value){try{localStorage.setItem(key,String(value));}catch{}}
function focusCommand(){if(document.querySelector('dialog[open]'))return;if(spectrum.active)spectrum.focus();else $('command').focus({preventScroll:true});}
function presentation(options={}){return capturePresentation(spectrum,{transcript:transcriptRows,history,view,...options});}
function checkpointTab(){if(state)rememberTab(sessionStorage,session.game,presentation({allowIncomplete:true,inProgress:busy||persisting}));}
window.addEventListener('sherlock:engine-change',event=>{
 try{checkpointTab();}catch(error){event.preventDefault();notice('Non posso conservare la partita in questa scheda: '+error.message);}
});
window.addEventListener('pagehide',()=>{try{checkpointTab();}catch{}});
function displayCompatibility(enabled){$('compatibility').checked=enabled;document.body.classList.toggle('compatibility-mode',enabled);$('spectrum-panel').hidden=!enabled;spectrum.setActive(enabled);$('compat-picture-mode').disabled=!enabled;$('compat-scale').disabled=!enabled;savePreference('sherlock-compatibility',enabled);}
$('compat-picture-mode').value=preference('sherlock-compat-picture-mode','svg');spectrum.pictureMode=$('compat-picture-mode').value;
$('compat-scale').value=preference('sherlock-compat-scale','2');spectrum.setScale($('compat-scale').value);
displayCompatibility(preference('sherlock-compatibility','false')==='true');
$('compatibility').onchange=async()=>{
 const enabled=$('compatibility').checked;if(busy&&enabled){$('compatibility').checked=spectrum.active;return;}
 displayCompatibility(enabled);if(!enabled){focusCommand();return;}if(!data||!state)return;
 const epoch=++operationEpoch;spectrum.reset();setBusy(true);try{const current=await engineRequest('state');if(epoch!==operationEpoch)return;update(current);if(current.game_over){spectrum.resumeSession();await showMessages(current.ending_messages||[]);}else{if(!current.opening)spectrum.resumeSession();await spectrum.writeMessages([{kind:'narrative',text:current.opening||current.initial,screen_events:current.opening_screen||current.initial_screen,image_room:current.room}]);}}catch(error){if(epoch===operationEpoch)append('error',error.message);}finally{if(epoch===operationEpoch){setBusy(false);focusCommand();}}
};
$('compat-picture-mode').onchange=()=>{savePreference('sherlock-compat-picture-mode',$('compat-picture-mode').value);spectrum.setPictureMode($('compat-picture-mode').value);};
$('compat-scale').onchange=()=>{savePreference('sherlock-compat-scale',$('compat-scale').value);spectrum.setScale($('compat-scale').value);};
async function showMessages(messages,options){
 const native=[];
 for(const message of messages){
  if(message.kind==='system'){$('game-status').textContent=state?.prototype_notice===message.text?gameStatus(state):'Messaggio del prototipo: '+message.text;$('game-status').hidden=false;continue;}
  appendScene(message);native.push(message);
 }
 if(spectrum.active)await spectrum.writeMessages(native,options);
}

function svg(tag,attrs={}){const el=document.createElementNS(NS,tag);for(const [k,v] of Object.entries(attrs))el.setAttribute(k,v);return el;}
function el(tag,text,cls){const e=document.createElement(tag);if(text!==undefined)e.textContent=text;if(cls)e.className=cls;return e;}
function append(kind,text,record=true){if(!text)return;if(record&&!replayingTranscript)transcriptRows.push({kind,text});$('transcript').append(el('div',text,`entry ${kind}`));$('transcript').scrollTop=$('transcript').scrollHeight;}
function appendScene(message){
 if(!replayingTranscript)transcriptRows.push(structuredClone(message));
 const url=data.pictures?.[message.image_room];let picture=null;
 if(url){const figure=el('figure',undefined,'scene-picture'),link=el('a'),img=el('img');
  link.href=url;link.target='_blank';link.rel='noopener';img.src=url;img.width=1024;img.height=1408;img.alt=`${String(message.image_room).padStart(3,'0')} · ${rooms.get(message.image_room)?.name_hint||'Locazione'}`;
  img.addEventListener('error',()=>figure.remove());link.append(img);figure.append(link,el('figcaption',img.alt+' · apri SVG'));$('transcript').append(figure);picture=figure;
 }
 append(message.kind,message.text,false);
 if(picture&&!$('pictures').checked)return;
 if(picture)$('transcript').scrollTop+=picture.getBoundingClientRect().top-$('transcript').getBoundingClientRect().top;
}
function setPictures(enabled){spectrum.setPictures(enabled);$('pictures').checked=enabled;document.body.classList.toggle('pictures-off',!enabled);try{localStorage.setItem('sherlock-pictures',String(enabled));}catch{}}
let picturesEnabled=true;try{picturesEnabled=localStorage.getItem('sherlock-pictures')!=='false';}catch{}
setPictures(picturesEnabled);$('pictures').onchange=()=>setPictures($('pictures').checked);
async function engineRequest(operation,body){const request=Promise.resolve().then(()=>session.request(operation,body));pendingRequests.add(request);try{return await request;}finally{pendingRequests.delete(request);renderHistory();}}

function renderHistory(){if(!$('command-history').open)return;const area=$('history-text'),value=session.game.history.format({clock:state?.clock.label,running:busy});if(area.value!==value){const end=area.selectionEnd,start=area.selectionStart,scroll=area.scrollTop;area.value=value;area.setSelectionRange(start,end);area.scrollTop=scroll;}}
$('show-history').onclick=()=>{$('history-status').textContent='';$('command-history').showModal();renderHistory();};
$('close-history').onclick=()=>$('command-history').close();
$('copy-history').onclick=async()=>{renderHistory();const area=$('history-text');try{if(!navigator.clipboard?.writeText)throw Error('Clipboard unavailable');await navigator.clipboard.writeText(area.value);$('history-status').textContent='Cronologia copiata.';}catch{area.focus();area.select();$('history-status').textContent=document.execCommand('copy')?'Cronologia copiata.':'Testo selezionato: premi ⌘C o Ctrl+C per copiarlo.';}};

function setBusy(value){busy=value;if($('engine-select'))$('engine-select').disabled=false;const ended=Boolean(state?.game_over);$('command').disabled=value||ended;$('submit').disabled=value||ended;$('reset').disabled=restarting||persisting||!data;$('seed').disabled=value||persisting;$('start-mode').disabled=persisting;$('save-game').disabled=value||!state;$('load-game').disabled=value||!state;$('busy-label').textContent=value?'Analisi del comando…':'In inglese, come nell’originale';$('map').setAttribute('aria-busy',String(value));spectrum.setBusy(value);for(const button of document.querySelectorAll('[data-command]'))button.disabled=value||ended;}
function setClock(clock){spectrum.setClock(clock.label);$('clock').textContent=clock.label;$('ticks').textContent=`Tick ${clock.tick} · ${state?.visited.length||0} luoghi esplorati`;}
function updateGameStatus(s){
 const text=gameStatus(s);
 $('game-status').textContent=text;$('game-status').hidden=!text;
}
function update(s){const previousRoom=state?.room;state=s;if($('engine-hint'))$('engine-hint').textContent=engineStatus(s);$('seed').value=s.seed??1;$('start-mode').value=s.start_mode||'free';spectrum.setRoom(s.room);spectrum.setEnded(s.game_over);setClock(s.clock);updateGameStatus(s);$('room-id').textContent=String(s.room).padStart(3,'0');$('room-name').textContent=s.name;
 for(const [id,node] of nodes){node.classList.toggle('current',id===s.room);node.classList.toggle('visited',s.visited.includes(id));node.setAttribute('aria-pressed',String(id===s.room));}
 for(const [edge,node] of edgeEls)node.classList.toggle('near',edge.source===s.room);
 updateCharacters(s);
 if(previousRoom!==undefined&&previousRoom!==s.room&&(previousRoom===1||s.room===1))centerRoom(s.room);
 $('exits').replaceChildren();for(const e of s.exits){const row=el('div',undefined,'exit'),button=el('button',e.direction),desc=el('div',`${String(e.target).padStart(3,'0')} ${e.target_name||'destinazione non attiva'}`);button.title='Esegui il movimento, rispettando gli ostacoli';button.onclick=()=>command(e.direction);desc.append(el('small',`${e.gate_name?e.gate_name+' · ':''}${e.status}`));row.append(button,desc);$('exits').append(row);}if(!s.exits.length)$('exits').append(el('span','Nessuna uscita direzionale.'));
 $('objects').replaceChildren();for(const o of s.visible){const item=el('span',o.name,'entity');item.title=`Entità ${o.id}${s.objects.some(x=>x.id===o.id)?' · elencata nella scena':''}`;$('objects').append(item);}if(!s.visible.length)$('objects').append(el('span',s.dark?'È buio: nessun elenco visivo disponibile.':'Nessuna entità percepibile.'));
 if($('scheduler-state'))$('scheduler-state').textContent=JSON.stringify({random:s.random_state,...s.scheduler},null,2);
 if(s.analysis){const a=s.analysis;$('analysis').textContent=JSON.stringify({esito:a.outcome,riga:a.normalised,unita:a.units,controlli:a.controls},null,2);}}
function waitControls(job,allowed){activeJob=job;canInterrupt=Boolean(allowed);$('interrupt-wait').hidden=!canInterrupt;$('interrupt-wait').disabled=interruptRequested;}
function interruptWait({allowMore=false}={}){if(!activeJob||!canInterrupt||spectrum.waiting&&!allowMore)return;interruptRequested=true;if(spectrum.waiting){spectrum.more();$('interrupt-wait').disabled=false;}else $('interrupt-wait').disabled=true;}
$('interrupt-wait').onclick=()=>interruptWait({allowMore:true});
// Capture before the input's submit handler: browser microtasks may start
// the wait before this same keydown reaches a document bubble listener.
// A held submit key must not cancel the newly started wait through repeats.
document.addEventListener('keydown',e=>{if(e.target?.closest?.('#engine-select,dialog[open]'))return;if(e.key==='Enter'&&!e.repeat&&activeJob&&canInterrupt&&!spectrum.waiting){e.preventDefault();interruptWait();}},true);
async function consumeCommand(result,epoch){
 let continuing=false;
 while(epoch===operationEpoch){
  if(!result.running){update(result.state);await showMessages(result.messages,{complete:true,continuing});waitControls(null,false);return;}
  waitControls(result.job,result.can_interrupt);
  if(result.state)update(result.state);else setClock(result.clock);
  await showMessages(result.messages,{complete:false,continuing});continuing=true;
  if(epoch!==operationEpoch)return;
  $('spectrum-status').textContent=canInterrupt?'Attesa in corso: Invio interrompe; MORE continua la pagina.':'Comando in corso…';
  // Let each native clock frame be painted before executing the next minute.
  await new Promise(resolve=>setTimeout(resolve,100));
  if(epoch!==operationEpoch)return;
  const interrupt=interruptRequested;interruptRequested=false;
  result=await engineRequest('continue-command',{job:activeJob,interrupt});
 }
}
async function perform(path,body,focus=true){if(busy||state?.game_over)return;const epoch=++operationEpoch;interruptRequested=false;$('game-status').hidden=true;setBusy(true);try{const r=await engineRequest(path,body);if(epoch!==operationEpoch)return;if(path==='start-command')await consumeCommand(r,epoch);else{update(r.state);await showMessages(r.messages);}}catch(error){if(epoch===operationEpoch)await showMessages([{kind:'system',text:error.message}]);}finally{if(epoch===operationEpoch){waitControls(null,false);setBusy(false);renderHistory();try{checkpointTab();}catch(error){notice('Cronologia disponibile, ma non conservata al ricaricamento: '+error.message);}if(focus||spectrum.active)focusCommand();}}}
async function command(text){if(busy||!text.trim())return;const control=text.trim().toUpperCase().replace(/\.$/,'');if(control==='SAVE'){await saveGame();return;}if(control==='LOAD'){chooseLoad();return;}if(state?.game_over)return;history.push(text);historyAt=history.length;append('command',text);if(spectrum.active)spectrum.commit(text);$('command').value='';await perform('start-command',{command:text});}
function notice(text){$('session-notice').textContent=text;}
async function saveGame(){
 if(busy||!state)return;
 try{
  const savedPresentation=presentation();
  persisting=true;setBusy(true);const result=await engineRequest('save',{presentation:savedPresentation});
  const blob=new Blob([JSON.stringify(result.save,null,2)+'\n'],{type:'application/json'}),url=URL.createObjectURL(blob),link=el('a');
  link.href=url;link.download=`sherlock-js-${state.clock.day}-${state.clock.hour}-${state.clock.minute}${state.clock.period}.json`;document.body.append(link);link.click();link.remove();setTimeout(()=>URL.revokeObjectURL(url),1000);
  notice('Partita salvata nel file scaricato.');
 }catch(error){notice(error.message);}finally{persisting=false;setBusy(false);focusCommand();}
}
function chooseLoad(){if(!busy&&state){$('load-file').value='';$('load-file').click();}}
function validatePresentation(p){
 if(p==null)return;
 if(p.version!==1||typeof p.compatibility!=='boolean'||!Array.isArray(p.transcript)||p.transcript.length>200||!p.transcript.every(m=>m&&['command','narrative','error','system'].includes(m.kind)&&typeof m.text==='string')||!Array.isArray(p.history)||p.history.length>200||!p.history.every(t=>typeof t==='string')||!Array.isArray(p.view)||p.view.length!==4||!p.view.every(Number.isFinite)||p.view[2]<=0||p.view[3]<=0)throw new Error('Presentazione nel salvataggio non valida.');
 if(p.redraw===true){if(p.spectrum!==null||typeof p.pictures!=='boolean'||!['svg','pixel'].includes(p.pictureMode))throw new Error('Presentazione da ridisegnare non valida.');}
 else SpectrumTerminal.validateSnapshot(p.spectrum);
}
async function restorePresentation(p,current){
 session.game.history.recover(p.history);
 displayCompatibility(p.compatibility);
 if(p.redraw){spectrum.reset();spectrum.resumeSession();setPictures(p.pictures);await spectrum.setPictureMode(p.pictureMode);}
 else{await spectrum.restore(p.spectrum);setPictures(p.spectrum.pictures);}
 const pictureMode=p.redraw?p.pictureMode:p.spectrum.pictureMode;
 $('compat-picture-mode').value=pictureMode;savePreference('sherlock-compat-picture-mode',pictureMode);
 replayingTranscript=true;try{for(const row of p.transcript){if(row.kind==='command')append(row.kind,row.text);else appendScene(row);}}finally{replayingTranscript=false;}
 transcriptRows=structuredClone(p.transcript);history=[...p.history];historyAt=history.length;view=[...p.view];applyView();update(current);
 if(p.redraw&&spectrum.active){
  for(const text of history.slice(-5))spectrum.commit(text);
  const messages=lastResponse(p.transcript);
  await spectrum.writeMessages(messages.length?messages:[{kind:'narrative',text:current.initial,image_room:current.room}]);
 }
}
$('save-game').onclick=saveGame;$('load-game').onclick=chooseLoad;
$('load-file').onchange=async()=>{
 const file=$('load-file').files[0];if(!file||busy)return;persisting=true;setBusy(true);
 try{
  if(file.size>20000000)throw new Error('File di salvataggio troppo grande.');
  const document=JSON.parse(await file.text());validatePresentation(document.presentation);setBusy(true);
  const result=await engineRequest('load',{save:document});const epoch=++operationEpoch;
  spectrum.reset();$('transcript').replaceChildren();$('analysis').textContent='';$('command').value='';transcriptRows=[];
  const p=result.presentation;
  if(p){
   await restorePresentation(p,result.state);
  }else{
   history=[];historyAt=0;update(result.state);if(state.game_over){spectrum.resumeSession();await showMessages(state.ending_messages||[]);}else{if(!state.opening)spectrum.resumeSession();await showMessages([{kind:'narrative',text:state.opening||state.initial,screen_events:state.opening_screen||state.initial_screen}]);}
  }
  if(epoch===operationEpoch)notice('Partita JavaScript ripristinata.');
 }catch(error){notice(error.message);}finally{persisting=false;setBusy(false);focusCommand();}
};
async function teleport(id){if(busy||state?.game_over)return;$('search-results').hidden=true;$('search').value='';await perform('teleport',{room:id},false);}
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
 if(restarting||persisting||!data)return;const epoch=++operationEpoch;restarting=true;notice('');
 try{sessionStorage.removeItem(TAB_SESSION_KEY);}catch{}
 waitControls(null,false);interruptRequested=false;
 spectrum.reset();$('transcript').replaceChildren();transcriptRows=[];$('command').value='';$('analysis').textContent='';history=[];historyAt=0;
 $('search').value='';$('search-results').hidden=true;setBusy(true);
 try{
  // Let an already submitted action finish before replacing its session.
  await Promise.allSettled([...pendingRequests]);
  const r=await engineRequest('reset',{start_mode:$('start-mode').value,seed:Number($('seed').value)});if(epoch!==operationEpoch)return;
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
(async()=>{
 const epoch=++operationEpoch;setBusy(true);
 try{
  data=await engineRequest('data');spectrum.configure(SPECTRUM_ASSETS,data.pictures,SPECTRUM_ASSETS.pixels);buildGraph();
  let restored=null;try{restored=recallTab(sessionStorage,bundle,validatePresentation);}catch(error){notice('Sessione della scheda non ripristinata: '+error.message);}
  if(restored)session.game=restored.game;
  const initialState=await engineRequest('state');if(epoch!==operationEpoch)return;
  update(initialState);centerRoom(state.room);setBusy(true);
  if(restored?.presentation){
   await restorePresentation(restored.presentation,initialState);notice('Ripresa la partita JavaScript di questa scheda.');
  }else if(initialState.game_over){spectrum.resumeSession();await showMessages(initialState.ending_messages||[]);}
  else{if(!initialState.opening)spectrum.resumeSession();await showMessages([{kind:'narrative',text:initialState.opening||initialState.initial,screen_events:initialState.opening_screen||initialState.initial_screen,image_room:initialState.room}]);}
 }catch(error){if(epoch===operationEpoch)append('error','Impossibile avviare il motore JavaScript. '+error.message);}
 finally{if(epoch===operationEpoch){setBusy(false);focusCommand();}}
})();
