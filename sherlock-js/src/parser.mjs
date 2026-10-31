import {InputError,tokenWidth} from './lexer.mjs';
const clone=value=>structuredClone(value);
const emptyGroup=()=>({relations:[],noun:0,qualifiers:[]});
const node=()=>({verb:0,modifier:0,groups:[],subject:null,all:false,exclusion:false,quote:null});
const fail=()=>{throw new InputError('syntax_error','WHAT ?');};
const STATEMENTS=new Set(['blackmail','had','has','is','killed','visit','hated','examined','hid','owns','made']);

// A functional grammar over lexical classes. There are no registers, opcodes,
// instruction addresses or simulated Z80 stacks in this parser.
export class Parser {
 constructor(lexer){this.lexer=lexer;this.dictionary=lexer.dictionary;}
 parse(raw,options={}){const lexed=this.lexer.scan(raw);return {...lexed,...this.unit(lexed.tokens,0,options)};}
 analyze(raw){
  const lexical=this.lexer.scan(raw),units=[];let index=0,mode=1;
  while(index<lexical.tokens.length&&lexical.tokens[index].type!==192){
   const unit=this.unit(lexical.tokens,index,{mode});if(unit.next<=index)fail();units.push(unit);index=unit.next;mode=unit.mode;
   for(const n of unit.nodes)for(const quote of n.quotes||(n.quote?[n.quote]:[]))try{quote.parsed=this.quoted(quote);}catch(error){if(error instanceof InputError)throw new InputError('quoted_syntax_error','WHAT ?', {units});throw error;}
  }
  return {...lexical,units,outcome:units.every(u=>u.outcome==='empty')?'empty':'ok'};
 }
 unit(tokens,start=0,{pending=null,mode=1,onNominal=null,onCount=null,onAll=null,onTokenStart=null,onMode=null,tokenBase=0x5B81}={}){
  let index=start,nodes=[],current=node(),relations=0,workingMode=mode,afterAnd=false,lookahead=null,discarded=[];
  // AE19 commits omitted verbs only after successful parsing. Failed
  // records must retain their pre-inheritance payload.
  const deferredFields=new WeakMap();
  const setMode=value=>{workingMode=value;onMode?.(value);};
  let allState=0;onAll?.(allState);
  let count=0;const publishCount=()=>onCount?.(count);publishCount();
  // The common parser only forces command mode for a pending clarification.
  // Its callers own ordinary-entry and quoted-entry mode initialization.
  if(pending)setMode(1);
  const fail=()=>{throw new InputError('syntax_error','WHAT ?', {partialNodes:clone([...nodes,current].map(n=>deferredFields.has(n)?{...n,verb:0,modifier:0,groups:n.groups.slice(deferredFields.get(n))}:n))});};
  const offsets=[];let offset=0;for(const t of tokens){offsets.push(offset);offset+=tokenWidth(t.type);}
  const peek=()=>{if(tokens[index])onTokenStart?.(tokenBase+offsets[index]);return tokens[index]||{type:192};},take=()=>tokens[index++],meaning=t=>t?.word||this.dictionary.word(t?.value||0)?.stem;
  const nominal=()=>{
   const group=emptyGroup(),publish=()=>onNominal?.(clone(group));publish();let article=false,started=false,qualified=false;
   while(true){const t=peek();
    if(t.type===128){if(article||qualified)fail();article=true;take();started=true;continue;}
    if(t.type===16||t.type===112){if(article||qualified||group.relations.length>=2||relations>=3)fail();group.relations.push(take().value);publish();relations++;started=true;continue;}
    if(t.type===96){if(group.qualifiers.length>=2)fail();qualified=true;article=true;group.qualifiers.push(take().value);publish();started=true;continue;}
    if(t.type===80||t.type===240){group.noun=take().value;publish();started=true;break;}
    break;
   }
   return started?group:null;
  };
  const verb=()=>{
   if(workingMode===2){if(peek().type===128)take();if(!STATEMENTS.has(meaning(peek())))return false;current.verb=take().value;return true;}
   let hasVerb=false,movement=false,hasModifier=false;
   while(true){const t=peek();
    if(t.type===224){take();continue;}
    if(t.type===48||t.type===64){if(hasVerb)fail();current.verb=take().value;hasVerb=true;movement=t.type===64;continue;}
    if(t.type===0){if(hasModifier)fail();current.modifier=take().value;hasModifier=true;continue;}
    if(t.type===32){
     if(!hasVerb){current.verb=take().value;hasVerb=true;}
     else if(movement){if(hasModifier)fail();current.modifier=current.verb;current.verb=take().value;hasModifier=true;movement=false;}
     else{if(hasModifier)fail();current.modifier=take().value;hasModifier=true;}
     continue;
    }
    break;
   }
   return hasVerb;
  };
  const finish=(increment=true)=>{if(!current.verb&&!current.exclusion&&!pending&&!nodes.length)fail();nodes.push(current);if(increment){count=(count+1)&255;publishCount();}};
  if(workingMode===0){const saved=index,g=nominal();if(g&&(g.noun||g.qualifiers.length)&&!g.relations.length){current.subject=g;setMode(2);}else{index=saved;relations=0;setMode(1);}}
  if(workingMode===2&&!verb())fail();
  while(true){
   if(peek().type===176||peek().type===192){if(current.groups.length)onNominal?.(emptyGroup());if(!nodes.length&&!current.verb&&!current.groups.length&&!pending)return {nodes:[],next:index+(peek().type===176?1:0),mode:workingMode,outcome:'empty'};finish();if(peek().type===176)take();break;}
   if(peek().type===144&&peek().value!==0){
    const t=take(),word=meaning(t);
    if(['quit','save','load','pause','print','noprint'].includes(word)){if(current.verb||current.groups.length||nodes.length)fail();if(pending&&!['quit','load'].includes(word)){count=(count+1)&255;publishCount();}return {nodes:[],next:index,mode:workingMode,outcome:'control',control:word};}
    if(['he','it','they','that'].includes(word)){
     if(current.verb){finish(word==='that');current=node();}
     if(word==='that'){if(!nodes.length||workingMode!==2)fail();current.subject=clone(nodes.at(-1).groups[0]||emptyGroup());}
     else current.subject={...emptyGroup(),pronoun:word==='he'?'he':'it'};
     if(word!=='that')setMode(2);if(!verb())fail();continue;
    }
    if(word==='all'){if((!current.verb&&!pending)||allState!==0)fail();current.all=true;allState=1;onAll?.(allState);continue;}
    if(word==='but'){
     if(allState!==1)fail();allState=2;onAll?.(allState);const slot=current.groups.length;finish(false);current={...node(),exclusion:true};current.groups=Array.from({length:slot},emptyGroup);const g=nominal();if(g&&slot>=2)fail();if(slot<2)current.groups.push(g||emptyGroup());continue;
    }
    if(['because','therefore'].includes(word)&&workingMode===2){finish();current=node();afterAnd=true;continue;}
    fail();
   }
   if(peek().type===144&&peek().value===0){
    take();const tokenPointer=0x5B81+tokens.slice(0,index).reduce((n,t)=>n+(tokenWidth(t.type)),0),inner=[];while(peek().type!==192&&!(peek().type===144&&peek().value===0))inner.push(take());if(peek().type!==144)fail();take();
    if(!current.verb)current.verb=this.dictionary.lookup('TALK').value;
    const quote={tokens:[...inner,{type:192,value:0,word:null}],source:inner.map(t=>t.source).join(' '),tokenPointer};
    (current.quotes??=[]).push(quote);current.quote=current.quotes[0];continue;
   }
   if(peek().type===160){
    if(current.groups.length)onNominal?.(emptyGroup());take();while(peek().type===160)take();finish(!current.exclusion);const previous=current;current=node();afterAnd=true;if(previous.exclusion){nodes.pop();discarded.push({before:nodes.length,node:clone(previous)});current.suppressedInheritance=true;}
    const next=peek();if([80,96,16,112,128,240].includes(next.type)){deferredFields.set(current,previous.groups.length>1?1:0);current.verb=previous.verb;current.modifier=previous.modifier;current.subject=clone(previous.subject);if(previous.groups.length>1)current.groups=clone(previous.groups.slice(0,1));}
    else if(workingMode===2&&STATEMENTS.has(meaning(next))){current.subject=clone(previous.subject);}
    else if([0,32,48,64,224].includes(next.type)&&workingMode===1&&!pending){lookahead={...node(),verb:next.value};break;}
    continue;
   }
   if(!current.verb){
    if(verb())continue;
    if(!pending&&!nodes.length)fail();
   }
   const group=nominal();
   if(group){if(current.groups.length>=2)fail();current.groups.push(group);continue;}
   // A verb reached without a conjunction can start another statement; ordinary
   // commands require the explicit separator handled above.
   if(workingMode===2&&STATEMENTS.has(meaning(peek()))){
    // AB7C calls the predicate reader before ACCC creates the next node:
    // AC17/AC1A overwrite this node's verb too. Keep the intermediate node;
    // its released payload remains observable by the shared random source.
    current.verb=peek().value;finish();const old=current;current=node();current.subject=clone(old.subject||old.groups[0]);verb();continue;
   }
   fail();
  }
  const continuationAnswer=pending?clone(nodes[0]):null;
  if(pending){const answer=nodes[0];if(!answer.verb){const merged=clone(pending.node),target=merged.groups[pending.slot]||(merged.groups[pending.slot]=emptyGroup()),source=answer.groups[0]||emptyGroup();if(!target.noun)target.noun=source.noun;for(const q of source.qualifiers)if(target.qualifiers.length<2)target.qualifiers.push(q);merged.all=merged.all||answer.all;if(answer.all)merged.allSlot=pending.slot;nodes[0]=merged;}}
  // AD6C merges the first clarification answer before AE19 propagates an
  // omitted verb. Exclusion-tail replacement deliberately has no inherited verb.
  for(let i=1;i<nodes.length;i++)if(!nodes[i].exclusion&&!nodes[i].verb&&!nodes[i].suppressedInheritance){nodes[i].verb=nodes[i-1].verb;nodes[i].modifier=nodes[i-1].modifier;}

  return {nodes,next:index,mode:workingMode,outcome:'ok',...(lookahead?{lookahead}:{}),...(discarded.length?{discarded}:{}),...(continuationAnswer?{continuationAnswer}: {})};
 }
 quoted(quote,{onNominal=null,onCount=null,onAll=null,onTokenStart=null,onMode=null}={}){const units=[];let index=0,mode=0;onMode?.(0);try{do{const out=this.unit(quote.tokens,index,{mode,onNominal,onCount,onAll,onTokenStart,onMode,tokenBase:quote.tokenPointer});if(out.next<=index&&out.outcome!=='empty')fail();units.push(...(out.outcome==='empty'?[node()]:out.nodes));index=out.next;mode=out.mode;}while(index<quote.tokens.length&&quote.tokens[index].type!==192);}catch(error){if(error instanceof InputError)error.detail.partialNodes=[...units,...(error.detail.partialNodes||[])];throw error;}return {nodes:units,mode};}
}

export function nodeWords(n){
 const words=Array(15).fill(0);words[0]=n.verb|(n.all?32768:0)|(n.exclusion?16384:0);words[1]=n.modifier;
 for(let i=0;i<n.groups.length;i++){const g=n.groups[i],p=2+5*i;words[p]=g.relations[0]||0;words[p+1]=g.relations[1]||0;words[p+2]=g.noun;words[p+3]=g.qualifiers[0]||0;words[p+4]=g.qualifiers[1]||0;}
 if(n.subject){words[12]=n.subject.noun||0;words[12]|=n.subject.pronoun==='he'?32768:n.subject.pronoun==='it'?16384:0;words[13]=n.subject.qualifiers[0]||0;words[14]=n.subject.qualifiers[1]||0;}
 return words;
}
