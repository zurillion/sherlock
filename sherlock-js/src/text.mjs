import {UnsupportedFeature,joinList,DIRECTION_NAMES} from './world.mjs';

// Compressed prose has been decoded to JSON data by the offline build step.
// This renderer interprets semantic text operations, not CPU instructions.
export class Text {
 constructor(data,dictionary,world,{chooseIndex}={}){this.data=data;this.dictionary=dictionary;this.world=world;this.chooseIndex=chooseIndex;}
 // A88C/A8B5 retain the last emitted dictionary descriptor, including its
 // context nibble. Suppressed dictionary output and literal characters keep it.
 setQualifierMode(value){if(this.world.npcs)this.world.npcs.nameQualifierMode=value;}
 roomName(id,{reset=true}={}){if(reset)this.setQualifierMode(0);const mode=this.world.npcs?.nameQualifierMode;if(!reset&&this.world.npcs&&mode==null)throw new UnsupportedFeature('modo dei qualificatori del nome locazione');return this.world.roomName(id,{short:mode!=null&&mode!==0});}
 rememberDictionaryReference(value){if(this.world.npcs)this.world.npcs.dictionaryReference=value;}
 greeting(actor,context={}){return this.render('6920',{...context,actor});}
 examinePreservesLowScratch(description){
  // DF49/DF5B's ordinary inspection stays above $5D1E at its deepest
  // announcement glyph. Flat description text is shallower; each nested
  // text invocation adds at most six bytes. Up to two such levels still
  // cannot touch the owned low renderer cells ($5CEE..$5D0F).
  // Unknown token contracts or deeper invocations remain conservative.
  const flat=new Set(['word','literal','end','endLine','endSentence','newline','backspace','toggleUpper','noop']);
  const visit=(id,depth,seen)=>{if(depth>2||seen.has(id)||!this.data.texts[id])return false;const next=new Set([...seen,id]);return this.data.texts[id].every(t=>flat.has(t.op)||['call','jump'].includes(t.op)&&visit(t.text,depth+1,next));};
  return !description||visit(description,0,new Set());
 }
 render(id,context={}){
  const w=this.world,actor=context.actor??w.player,object=context.object??actor,other=context.other??actor;
  let result='',capitalize=true,force=false,depth=0,argumentsUsed=0,mixOffset=context.mixOffset??null,inChoice=false,pending='',pendingCap=true;const fragments=[];
  const remember=value=>{if(context.bufferVisible!==false)this.rememberDictionaryReference(value);};
  let nameBuffer=false;
  const feed=(text,{raw=text,dict=false,buffer=true}={})=>{if(buffer&&context.bufferSink&&(!(dict||nameBuffer)||context.bufferVisible!==false))for(const c of String(nameBuffer?String(raw).toLowerCase():raw))context.bufferSink(c,{known:!nameBuffer});for(let c of String(text)){
   if(c==='\b'){result=result.slice(0,-1);pending=pending.slice(0,-1);context.sink?.(c);continue;}
   if([' ','\n','\r','"'].includes(c))pending='';
   else{if(!pending)pendingCap=capitalize;pending+=c;}
   if(/[A-Z]/.test(c))c=c.toLowerCase();
   if(c==='"'){result+=' ';context.sink?.(' ');}
   if(c==='.'||c==='"')capitalize=true;
   else if(/[a-z]/.test(c)&&(capitalize||force)){c=c.toUpperCase();capitalize=false;}
   result+=c;context.sink?.(c);
  }};
  const name=(id,be=false)=>w.name(id,{indefinite:Boolean(w.entity(id).person)})+(be?(id===0?' are':' is'):'');
  const feedName=(id,be=false,actorToken=false)=>{const previousNameBuffer=nameBuffer;nameBuffer=true;try{
   feed(' ');const e=w.entity(id);
   if(e.person&&(e.noun&32768)&&id!==w.player){const parts=w.name(id).split(' ');
    // In the prefab TELL path, the actor-name prefix flushes while the
    // nested name call is active. Its last noun is flushed after return.
    if(actorToken&&context.actorNamePrefix&&parts.length>1){context.actorNamePrefix(()=>{for(const[i,part]of parts.slice(0,-1).entries()){if(i)feed(' ');capitalize=true;feed(part);}feed(' ');});capitalize=true;feed(parts.at(-1));}
    else for(const [i,part] of parts.entries()){if(i)feed(' ');capitalize=true;feed(part);}if(be)feed(' is');}
   else if(actorToken&&context.actorNamePrefix&&id!==w.player){const parts=w.name(id,{indefinite:Boolean(e.person)}).split(' ');context.actorNamePrefix(()=>{feed(parts.slice(0,-1).join(' '));feed(' ');});feed(parts.at(-1)+(be?' is':''));}
   else feed(name(id,be));if(e.noun&4095)remember(0x5000|(e.noun&4095));if(be)remember(id===0?0x007A:0x0485);}finally{nameBuffer=previousNameBuffer;}
  };
  const emit=t=>{
   switch(t.op){
    case 'word':{mixOffset=t.randomContext??null;remember(t.randomContext??null);if(t.id){feed(' ',{dict:true});if(t.capitalized)capitalize=true;const word=this.dictionary.word(t.id);if(!word)throw Error('Invalid text word');const inflected=t.form==='inflected'||(t.form==='actor'&&actor!==0)||(t.form==='object'&&object!==0);feed(inflected?word.form:word.stem,{dict:true,raw:word.stem+(inflected?(['S','ES','IES','\bIES','D','ING','ED','\bING','LY'][word.suffix]||''):'')});}if(t.end==='sentence')feed('.\n');if(t.end==='line')feed('\n');break;}
    case 'literal':feed(t.text);break;
    case 'call':case 'jump':mixOffset=t.relativeOffset===undefined?null:(t.relativeOffset-(t.op==='jump'?1:0))&65535;walk(t.text);break;
    case 'choice':{
     if(typeof this.chooseIndex!=='function')throw new UnsupportedFeature('selezione casuale del testo: sorgente originale e stato globale non ancora ricostruiti');
     // A6D1/A6D2 are shared scratch fields. Nested selections overwrite the
     // enclosing loop; a conventional recursive choice is not equivalent.
     if(inChoice)throw new UnsupportedFeature('selettore di testo annidato e contatori condivisi');
     if(mixOffset===null)throw new UnsupportedFeature('contesto originale della selezione del testo');
     const index=this.chooseIndex(t.options.length,{actor,object,other,mixOffset,fragment:fragments.at(-1),token:t,context});
     if(!Number.isInteger(index)||index<0||index>=t.options.length)throw Error('Invalid original text choice');
     inChoice=true;emit(t.options[index]);inChoice=false;break;
    }
    case 'nameArgument':{const id=context.nameArguments?.[argumentsUsed++];if(!Number.isInteger(id))throw new UnsupportedFeature('nome nella memoria delle informazioni');if(t.nameMode==='full')this.setQualifierMode(0);feedName(id);break;}
    case 'argumentIs':{const id=context.nameArguments?.[argumentsUsed++];if(!Number.isInteger(id))throw new UnsupportedFeature('nome con copula nell’argomento di testo');this.setQualifierMode(1);feedName(id,true);mixOffset=id===0?0x007A:0x0485;remember(mixOffset);break;}
    case 'relationArgument':{const f=context.fact;if(!f)throw new UnsupportedFeature('relazione nella memoria delle informazioni');feedName(f.subject);const id=this.data.informationRules.predicates[f.predicate-1];feed(' ');const word=this.dictionary.word(id??93);if(!word)throw new UnsupportedFeature('predicato delle informazioni');feed(actor===0?word.stem:word.form);feedName(f.object);mixOffset=id;break;}
    case 'textArgument':{
     mixOffset=context.argumentContexts?.[argumentsUsed]??null;
     const id=context.textArguments?.[argumentsUsed++];
     if(typeof id!=='string')throw new UnsupportedFeature('argomento di testo della conversazione');
     walk(id);break;
    }
    case 'compose':{
     this.setQualifierMode(0); // A37D/A37E, before any model words or arguments.
     remember(null); // Model-only words without a resolved argument remain unowned.
     const action=context.action,model=this.data.actions.find(a=>a.id===action),args=context.args||[255,255];
     if(!model)throw new UnsupportedFeature('testo dell’ordine NPC '+action);
     if(w.npcs)w.npcs.modelFlags=model.modelFlags?[...model.modelFlags]:[null,null]; // A38B, no restore on return.
     const roomName=id=>{const r=w.rooms[id],proper=Boolean(r.nameWords[0]&32768),parts=[];if(!proper)parts.push({text:({0:'the',4096:'a',8192:'an',12288:'some'})[r.nameWords[0]&12288]});for(const v of r.nameWords.slice(1).filter(Boolean)){const word=this.dictionary.word(v);parts.push({text:word.form,raw:word.stem+(['S','ES','IES','\bIES','D','ING','ED','\bING','LY'][word.suffix]||'')});}parts.push({text:this.dictionary.word(r.nameWords[0]).stem});
      const word=part=>{if(proper)capitalize=true;feed(part.text,{dict:true,raw:part.raw??part.text});};
      // A3DE/A745/A7BA/D405: the qualified proper room prefix is flushed
      // inside the name call (frame5D32 in the verified CE13 order).
      // The final noun remains buffered and flushes after that call returns.
      if(context.roomNamePrefix&&proper&&parts.length>1){context.roomNamePrefix(()=>{for(const part of parts.slice(0,-1)){feed(' ',{dict:true});word(part);}feed(' ',{dict:true});});word(parts.at(-1));}
      else{context.unknownRoomName?.();for(const part of parts){feed(' ',{dict:true});word(part);}}
      remember(0x5000|(r.nameWords[0]&4095));};
     const argument=(id,slot)=>{if(id===255)return;if([18,27,29,30].includes(action)||action===45&&slot===1)roomName(id);else feedName(id);};
     // A3A9/A3EF puts TELL ABOUT's relation between its two arguments;
     // A3C8/A3CE prints "me" when the first argument is the speaker.
     if(action===47||action===48){feed(' tell',{dict:true});if(args[0]===actor)feed(' me',{dict:true});else argument(args[0],0);if(action===48)feed(' about',{dict:true});argument(args[1],1);feed('.');break;}
     feed(' ',{dict:true});feed(model.words[0],{dict:true});if(model.words[3]){feed(' ',{dict:true});feed(model.words[3],{dict:true});}if(model.words[1]){feed(' ',{dict:true});feed(model.words[1],{dict:true});}argument(args[0],0);if(model.words[2]){feed(' ',{dict:true});feed(model.words[2],{dict:true});}argument(args[1],1);feed('.');break;
    }
    case 'time':if(w.timeClass()===t.value)emit(t.token);break;
    case 'actorName':this.setQualifierMode(0);feedName(actor,false,true);break;
    case 'objectName':this.setQualifierMode(1);feedName(object);break;
    case 'otherName':this.setQualifierMode(1);feedName(other);break;
    case 'actorIs':this.setQualifierMode(0);feedName(actor,true);mixOffset=actor===0?0x007A:0x0485;remember(mixOffset);break;
    case 'objectIs':this.setQualifierMode(1);feedName(object,true);mixOffset=object===0?0x007A:0x0485;remember(mixOffset);break;
    case 'actorPossessive':feed(actor===0?'your':'his',{dict:true});mixOffset=actor===0?0x09F2:0x0414;remember(mixOffset);break;
    case 'objectPossessive':feed(object===0?'your':'his',{dict:true});mixOffset=object===0?0x09F2:0x0414;remember(mixOffset);break;
    case 'newline':feed('\n');break;
    case 'endLine':mixOffset=mixOffset===null?null:0x6000|(mixOffset&255);feed('\n');break;
    case 'endSentence':mixOffset=mixOffset===null?null:0x3000|(mixOffset&255);feed('.\n');break;
    case 'backspace':feed('\b');break;
    case 'toggleUpper':{
     force=!force;
     // A9B7 buffers a whole word, including punctuation. AA59 reads the
     // case mode only when its following delimiter flushes that buffer.
     // A toggle before that delimiter therefore also affects this suffix.
     const buffered=pending;if(buffered){for(let i=0;i<buffered.length;i++){result=result.slice(0,-1);context.sink?.('\b');}capitalize=pendingCap;pending='';feed(buffered,{buffer:false});}break;
    }
    case 'end':case 'noop':break;
    default:throw new UnsupportedFeature('operazione di testo '+t.op);
   }
  };
  const walk=key=>{if(++depth>24)throw Error('Text recursion');const tokens=this.data.texts[key];if(!tokens)throw Error('Unknown text fragment '+key);fragments.push(key);for(const t of tokens)emit(t);fragments.pop();depth--;};
  walk(id);return result.replace(/[ \t]+/g,' ').replace(/ *\n */g,'\n').trim();
 }
 scene({full=true,room=this.world.roomOf(),remote=false,mark=true,trace=null,source='look'}={}){
  const w=this.world,r=w.rooms[room],text=[],actorName=remote&&w.entity(w.player).parent!==null?w.name(w.entity(w.player).parent).replace(/^./,c=>c.toUpperCase()):w.player===0?'You':w.name(w.player,{indefinite:true}).replace(/^./,c=>c.toUpperCase()),actorIs=actorName+(w.player===0?' are':' is');w.lastListed=[];
  const briefDark=!full&&!remote&&w.dark();
  const parent=remote?null:w.entity(w.player).parent;
  // D526's recursive list frame adds six bytes per level. A LOOK enters
  // D102 four bytes shallower than CA9E's movement notification; describing
  // fellow passengers in D113 adds two bytes relative to the room list.
  // D1B2's brief scene skips D102's three pushes and D113's call (8 bytes).
  const entryOffset=['look','cab-departure'].includes(source)?4:full?0:8;
  const listFrame=depth=>0x5D18+entryOffset-(parent!==null?2:0)-6*depth;
  const list=parent=>w.entities.filter(e=>e.parent===parent&&e.id!==w.player&&e.rooms.length<2&&!w.owns(w.player,e.id)&&w.perceived(e.id));
  const renderChildren=(parent,depth=0)=>{
   const children=list(parent);if(!children.length)return;
   const names=children.map(e=>{this.setQualifierMode(0);return w.name(e.id,{indefinite:true});});
   let prefix;
   // A414 leaves the final exit/passage noun buffered. The room-list
   // introduction provides its delimiter, then SEE flushes in the first
   // object's naming call. AND is a separate dictionary invocation.
   if(parent===null){const previous=text.join(' '),tail=previous.match(/\S+$/);if(trace&&tail&&/^(Visible exits are |To the |Above |Below )/.test(text.at(-1)))trace.push({kind:'room-list-delimits-exits',start:previous.length-tail[0].length,end:previous.length,frame:listFrame(depth)-2});prefix=actorName+' can see ';const start=text.join(' ').length+(text.length?1:0);text.push(prefix+joinList(names)+'.');
    if(trace)trace.push({kind:'room-list-see',start:start+prefix.length-4,end:start+prefix.length-1,frame:listFrame(depth)+((children[0].noun&32768)?4:2)});
    if(trace){let offset=0;const inventory=joinList(names),conjunction=inventory.lastIndexOf(' and ');if(conjunction>=0)trace.push({kind:'root-list-conjunction',start:start+prefix.length+conjunction+1,end:start+prefix.length+conjunction+4,frame:listFrame(depth)+2});for(const item of names){offset=inventory.indexOf(item,offset);const length=item.lastIndexOf(' ');if(length>0)trace.push({kind:'root-object-prefix',start:start+prefix.length+offset,end:start+prefix.length+offset+length,frame:listFrame(depth)+4});offset+=item.length;}}
   }
   else{const container=w.entity(parent);if(container.person){
    const start=text.join(' ').length+(text.length?1:0),name=w.name(parent);
    // The last noun of the preceding list is still buffered. The first
    // literal name argument of this carrying phrase flushes it, including
    // its trailing space, before the carrier's own name is printed.
    const previous=text.join(' '),tail=previous.match(/\S+$/);
    if(trace&&tail)trace.push({start:previous.length-tail[0].length,end:previous.length,kind:'list-tail-delimited-by-carrier',parent,frame:listFrame(depth)-20,spaceAfter:true});
    if(trace)trace.push({start,end:start+name.length,kind:'carrying-name',parent,depth,frame:listFrame(depth)});
    if(trace)trace.push({start:start+name.length+1,end:start+name.length+3,kind:'carrying-is',parent,depth,frame:listFrame(depth)});
    if(trace)trace.push({start:start+name.length+4,end:start+name.length+12,kind:'carrying-verb',parent,depth,frame:listFrame(depth)+2});
    // D526 names the carried objects after the carrying verb. Their article
    // and qualifiers flush through D3E8/A815; a wrapped article can reach
    // working fields that the verb itself never touches.
    let offset=0;const inventory=joinList(names);
    if(trace)for(const item of names){offset=inventory.indexOf(item,offset);const prefix=item.lastIndexOf(' ');if(prefix>0)trace.push({start:start+name.length+13+offset,end:start+name.length+13+offset+prefix,kind:'carried-object-prefix',frame:listFrame(depth)+4,spaceClearFrame:listFrame(depth)+8});offset+=item.length;}
    text.push(name+' is carrying '+joinList(names)+'.');
   }else{const relation=({1:'In',2:'On',3:'Behind',4:'Under',5:'Tied to'})[container.properties&7]||'In',name=w.name(parent),start=text.join(' ').length+(text.length?1:0);
    prefix=`${relation} ${name} there ${children.length===1?'is':'are'} `;
    if(trace){const nameEnd=start+relation.length+1+name.length;trace.push({kind:'container-relation',start,end:start+relation.length+1,frame:listFrame(depth)-2});trace.push({kind:'container-name',parent,start:start+relation.length+1,end:nameEnd,frame:listFrame(depth)});
     // D5C1/68D9 flushes THERE at the name's depth; the copula is two
     // bytes shallower. A wrapped THERE can reach the low working cells.
     trace.push({kind:'container-there',start:nameEnd+1,end:nameEnd+6,frame:listFrame(depth)});
     trace.push({kind:'container-copula',start:nameEnd+7,end:start+prefix.length-1,frame:listFrame(depth)+2});
     let offset=0;const inventory=joinList(names);for(const [i,item]of names.entries()){offset=inventory.indexOf(item,offset);const length=item.lastIndexOf(' '),at=start+prefix.length+offset;if(length>0)trace.push({kind:'carried-object-prefix',parent:children[i].id,start:at,end:at+length,frame:listFrame(depth)+4,spaceAfter:true});if(i)trace.push({kind:'following-object-delimiter',parent:children[i].id,start:at-1,end:at,frame:listFrame(depth)+2,spaceAfter:true});offset+=item.length;}}
    text.push(prefix+joinList(names)+'.');}}
   if(trace&&prefix&&children.length===1&&children[0].person&&(children[0].noun&32768)&&list(children[0].id).length)trace.push({kind:'literal-person-name',parent:children[0].id,start:text.join(' ').length-names[0].length-1,end:text.join(' ').length,frame:listFrame(depth)-26});
   if(trace&&parent!==null)trace.push({end:text.join(' ').length,kind:w.entity(parent).person?'personal-contents':'container-contents',depth,parent,room,child:children.length===1?children[0].id:null});
   for(const e of children){w.lastListed.push(e.id);if(mark)e.status|=128;}
   for(const e of children)renderChildren(e.id,depth+1);
  };
  const describePassages=()=>{for(const edge of r.exits){if(!edge.gate||!(w.entity(edge.gate).attributes&128))continue;const d=DIRECTION_NAMES[edge.direction_id];text.push(`${edge.direction_id===9?'Above':edge.direction_id===10?'Below':'To the '+d} there is ${w.name(edge.gate,{indefinite:true})}.`);}};
  const describe=()=>{
   const previous=text.join(' ');
   if(trace?.some(e=>e.kind==='personal-contents'&&e.end===previous.length)){
    // A414 leaves the last inventory word pending. The description's first
    // actor-is argument supplies its delimiter; each compressed CALL adds
    // eight bytes to that rendering path. Thus two equal inventory lists
    // can leave different working fields before different descriptions.
    let id=r.description,calls=0,first=this.data.texts[id]?.[0];
    while(first?.op==='call'&&calls<24){calls++;id=first.text;first=this.data.texts[id]?.[0];}
    if(first?.op==='actorIs'){const last=previous.match(/\S+$/);if(last)trace.push({kind:'description-delimits-inventory',start:previous.length-last[0].length,end:previous.length,frame:0x5D1A+entryOffset-8*calls});}
   }
   text.push(this.render(r.description));
  };
  if(parent!==null){
   this.setQualifierMode(0); // actor-is in the container introduction.
   const expand=full&&Boolean(r.description);
   const container=w.entity(parent),peers=w.entities.filter(e=>e.parent===parent&&e.id!==w.player&&w.perceived(e.id)),names=peers.map(e=>w.name(e.id,{indefinite:true}));
   text.push(actorIs+' in '+w.name(parent,{indefinite:true})+(expand&&names.length?' with '+joinList(names):'')+'.');
   // D144/D147 flush the final container noun through A414. When D182
   // then has no room prose, D197 temporarily makes that container the
   // subject; its name prefix flushes inside the actor-is text argument.
   if(trace&&!expand){const first=text.join(' '),tail=first.match(/\S+$/);if(tail)trace.push({kind:'container-introduction-tail',start:first.length-tail[0].length,end:first.length,frame:0x5D14+entryOffset});}

   if(trace&&expand&&names.length){const inventory=joinList(names),base=text.join(' ').length-inventory.length-1;let offset=0;for(const [i,e]of peers.entries()){const name=names[i],prefix=name.lastIndexOf(' ');offset=inventory.indexOf(name,offset);if(prefix>0&&!(e.noun&32768))trace.push({kind:'passenger-name-prefix',parent:e.id,start:base+offset,end:base+offset+prefix,frame:listFrame(0)+4});offset+=name.length;}}
   if(trace&&expand&&peers.length===1&&peers[0].person&&(peers[0].noun&32768))trace.push({kind:'literal-person-name',parent:peers[0].id,start:text.join(' ').length-names[0].length-1,end:text.join(' ').length,frame:listFrame(0)-26});
   if(expand){for(const e of peers){w.lastListed.push(e.id);if(mark)e.status|=128;renderChildren(e.id,1);}describe();}
   else{const start=text.join(' ').length+1,name=w.name(parent),prefix=name.lastIndexOf(' ');text.push((name[0].toUpperCase()+name.slice(1))+' is '+({2:'in',3:'on',4:'at'}[(r.flags&14)/2]||'in')+' '+this.roomName(room)+'.');if(trace&&prefix>0)trace.push({kind:'container-as-subject-prefix',start,end:start+prefix,frame:0x5D16+entryOffset});}
   if(briefDark)return text.join(' ')+' '+this.render('68C1');
   if(full)describePassages();
   const exits=r.exits.filter(e=>!e.gate).map(e=>DIRECTION_NAMES[e.direction_id]);if(exits.length)text.push('Visible exits are '+exits.join(' ')+'.');
   return text.map(s=>s.replace(/^./,c=>c.toUpperCase())).join(' ');
  }
  if(full&&r.description)describe();
  else text.push(remote?`${actorName} can see ${this.roomName(room)}.`:`${actorIs} ${{2:'in',3:'on',4:'at'}[(r.flags&14)/2]||'in'} ${this.roomName(room)}.`);
  if(briefDark)text.push(this.render('68C1'));
  if(full)describePassages();
  const exits=briefDark?[]:r.exits.filter(e=>!e.gate&&e.direction_id>=1&&e.direction_id<=10).map(e=>DIRECTION_NAMES[e.direction_id]);
  if(exits.length)text.push('Visible exits are '+exits.join(' ')+'.');
  if(!briefDark)renderChildren(null);
  const output=text.map(s=>s.replace(/^./,c=>c.toUpperCase())).join(' ');
  if(trace&&w.player!==0)for(let at=output.indexOf(actorName);at!==-1;at=output.indexOf(actorName,at+actorName.length)){const article=actorName.indexOf(' ')+1,noun=actorName.lastIndexOf(' ')+1;trace.push({kind:'alternate-actor-article',start:at,end:at+article,frame:(at===0&&full&&!r.description?0x5D1A:0x5D14)+entryOffset});trace.push({kind:'alternate-actor-name',start:at+article,end:at+noun,frame:(at===0&&full&&!r.description?0x5D1A:0x5D16)+entryOffset});trace.push({kind:'alternate-actor-noun',start:at+noun,end:at+actorName.length+1,frame:0x5D2A+entryOffset});}
  return output;
 }
}
