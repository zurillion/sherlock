import {UnsupportedFeature,joinList,DIRECTION_NAMES} from './world.mjs';

// Compressed prose has been decoded to JSON data by the offline build step.
// This renderer interprets semantic text operations, not CPU instructions.
export class Text {
 constructor(data,dictionary,world,{chooseIndex}={}){this.data=data;this.dictionary=dictionary;this.world=world;this.chooseIndex=chooseIndex;}
 greeting(actor,context={}){return this.render('6920',{...context,actor});}
 render(id,context={}){
  const w=this.world,actor=context.actor??w.player,object=context.object??actor,other=context.other??actor;
  let result='',capitalize=true,force=false,depth=0,argumentsUsed=0,mixOffset=context.mixOffset??null,inChoice=false;const fragments=[];
  const feed=text=>{for(let c of String(text)){
   if(c==='\b'){result=result.slice(0,-1);context.sink?.(c);continue;}
   if(/[A-Z]/.test(c))c=c.toLowerCase();
   if(c==='"'){result+=' ';context.sink?.(' ');}
   if(c==='.'||c==='"')capitalize=true;
   else if(/[a-z]/.test(c)&&(capitalize||force)){c=c.toUpperCase();capitalize=false;}
   result+=c;context.sink?.(c);
  }};
  const name=(id,be=false)=>w.name(id)+(be?(id===w.player?' are':' is'):'');
  const feedName=(id,be=false)=>{
   feed(' ');const e=w.entity(id);
   if(e.person&&(e.noun&32768)&&id!==w.player){for(const [i,part] of w.name(id).split(' ').entries()){if(i)feed(' ');capitalize=true;feed(part);}if(be)feed(' is');}
   else feed(name(id,be));
  };
  const emit=t=>{
   switch(t.op){
    case 'word':{mixOffset=t.randomContext??null;if(t.id){feed(' ');if(t.capitalized)capitalize=true;const word=this.dictionary.word(t.id);if(!word)throw Error('Invalid text word');const inflected=t.form==='inflected'||(t.form==='actor'&&actor!==0)||(t.form==='object'&&object!==0);feed(inflected?word.form:word.stem);}if(t.end==='sentence')feed('.\n');if(t.end==='line')feed('\n');break;}
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
    case 'textArgument':{
     mixOffset=context.argumentContexts?.[argumentsUsed]??null;
     const id=context.textArguments?.[argumentsUsed++];
     if(typeof id!=='string')throw new UnsupportedFeature('argomento di testo della conversazione');
     walk(id);break;
    }
    case 'time':if(w.timeClass()===t.value)emit(t.token);break;
    case 'actorName':feedName(actor);break;
    case 'objectName':feedName(object);break;
    case 'otherName':feedName(other);break;
    case 'actorIs':feedName(actor,true);mixOffset=actor===0?0x007A:0x0485;break;
    case 'objectIs':feedName(object,true);mixOffset=object===0?0x007A:0x0485;break;
    case 'actorPossessive':feed(actor===w.player?'your':'his');mixOffset=actor===0?0x09F2:0x0414;break;
    case 'objectPossessive':feed(object===w.player?'your':'his');mixOffset=object===0?0x09F2:0x0414;break;
    case 'newline':feed('\n');break;
    case 'endLine':mixOffset=mixOffset===null?null:0x6000|(mixOffset&255);feed('\n');break;
    case 'endSentence':mixOffset=mixOffset===null?null:0x3000|(mixOffset&255);feed('.\n');break;
    case 'backspace':feed('\b');break;
    case 'toggleUpper':force=!force;break;
    case 'end':case 'noop':break;
    default:throw new UnsupportedFeature('operazione di testo '+t.op);
   }
  };
  const walk=key=>{if(++depth>24)throw Error('Text recursion');const tokens=this.data.texts[key];if(!tokens)throw Error('Unknown text fragment '+key);fragments.push(key);for(const t of tokens)emit(t);fragments.pop();depth--;};
  walk(id);return result.replace(/[ \t]+/g,' ').replace(/ *\n */g,'\n').trim();
 }
 scene({full=true,room=this.world.roomOf(),remote=false,mark=true}={}){
  const w=this.world,r=w.rooms[room],text=[];w.lastListed=[];
  if(w.dark()&&!remote)return 'It is too dark to see.';
  if(full&&r.description)text.push(this.render(r.description));
  else text.push(remote?`You can see ${w.roomName(room)}.`:`You are ${{2:'in',3:'on',4:'at'}[(r.flags&14)/2]||'in'} ${w.roomName(room)}.`);
  if(full)for(const edge of r.exits){if(!edge.gate||!(w.entity(edge.gate).attributes&128))continue;const d=DIRECTION_NAMES[edge.direction_id];text.push(`${edge.direction_id===9?'Above':edge.direction_id===10?'Below':'To the '+d} there is ${w.name(edge.gate,{indefinite:true})}.`);}
  const exits=r.exits.filter(e=>!e.gate&&e.direction_id>=1&&e.direction_id<=10).map(e=>DIRECTION_NAMES[e.direction_id]);
  if(exits.length)text.push('You can go '+joinList(exits)+'.');
  const list=parent=>w.entities.filter(e=>e.parent===parent&&e.id!==w.player&&e.rooms.length<2&&!w.owns(w.player,e.id)&&w.perceived(e.id));
  const renderChildren=parent=>{
   const children=list(parent);if(!children.length)return;
   const names=children.map(e=>w.name(e.id,{indefinite:parent===null||!w.entity(parent).person}));
   if(parent===null)text.push('You can see '+joinList(names)+'.');
   else{const container=w.entity(parent);if(container.person)text.push(w.name(parent)+' is carrying '+joinList(names)+'.');else text.push(`${({1:'In',2:'On',3:'Behind',4:'Under',5:'Tied to'})[container.properties&7]||'In'} ${w.name(parent)} there ${children.length===1?'is':'are'} ${joinList(names)}.`);}
   for(const e of children){w.lastListed.push(e.id);if(mark)e.status|=128;}
   for(const e of children)renderChildren(e.id);
  };
  renderChildren(null);
  return text.join(' ');
 }
}
