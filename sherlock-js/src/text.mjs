import {UnsupportedFeature,joinList,DIRECTION_NAMES} from './world.mjs';

// Compressed prose has been decoded to JSON data by the offline build step.
// This renderer interprets semantic text operations, not CPU instructions.
export class Text {
 constructor(data,dictionary,world){this.data=data;this.dictionary=dictionary;this.world=world;}
 greeting(actor){return this.render('6920',{actor});}
 render(id,context={}){
  const w=this.world,actor=context.actor??w.player,object=context.object??actor,other=context.other??actor;
  let result='',capitalize=true,force=false,depth=0;
  const feed=text=>{for(let c of String(text)){
   if(c==='\b'){result=result.slice(0,-1);continue;}
   if(/[A-Z]/.test(c))c=c.toLowerCase();
   if(c==='"')result+=' ';
   if(c==='.'||c==='"')capitalize=true;
   else if(/[a-z]/.test(c)&&(capitalize||force)){c=c.toUpperCase();capitalize=false;}
   result+=c;
  }};
  const name=(id,be=false)=>w.name(id)+(be?(id===w.player?' are':' is'):'');
  const feedName=(id,be=false)=>{feed(' ');if(w.entity(id).person&&id!==w.player)capitalize=true;feed(name(id,be));};
  const emit=t=>{
   switch(t.op){
    case 'word':{if(t.id){feed(' ');if(t.capitalized)capitalize=true;const word=this.dictionary.word(t.id);if(!word)throw Error('Invalid text word');const inflected=t.form==='inflected'||(t.form==='actor'&&actor!==0)||(t.form==='object'&&object!==0);feed(inflected?word.form:word.stem);}if(t.end==='sentence')feed('.\n');if(t.end==='line')feed('\n');break;}
    case 'literal':feed(t.text);break;
    case 'call':case 'jump':walk(t.text);break;
    case 'choice':throw new UnsupportedFeature('selezione casuale del testo: sorgente originale e stato globale non ancora ricostruiti');
    case 'time':if(w.timeClass()===t.value)emit(t.token);break;
    case 'actorName':feedName(actor);break;
    case 'objectName':feedName(object);break;
    case 'otherName':feedName(other);break;
    case 'actorIs':feedName(actor,true);break;
    case 'objectIs':feedName(object,true);break;
    case 'actorPossessive':feed(actor===w.player?'your':'his');break;
    case 'objectPossessive':feed(object===w.player?'your':'his');break;
    case 'newline':case 'endLine':feed('\n');break;
    case 'endSentence':feed('.\n');break;
    case 'backspace':feed('\b');break;
    case 'toggleUpper':force=!force;break;
    case 'end':case 'noop':break;
    default:throw new UnsupportedFeature('operazione di testo '+t.op);
   }
  };
  const walk=key=>{if(++depth>24)throw Error('Text recursion');const tokens=this.data.texts[key];if(!tokens)throw Error('Unknown text fragment '+key);for(const t of tokens)emit(t);depth--;};
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
