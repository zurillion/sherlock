import {UnsupportedFeature} from './world.mjs';

// Subject/predicate/object memory and proof trees. References below identify
// data records and provenance; this module executes no CPU instructions.
export class Information {
 constructor(host){this.host=host;}
 get world(){return this.host.w;}
 get state(){return this.host.state;}
 get records(){return this.host.active.records;}
 get rules(){return this.host.game.data.informationRules;}
 verification(){return this.state.information.verification??(this.state.information.verification={recognized:null,unproven:null,lastFact:null});}
 reference(entity){const r=this.host.worldSource.layout.entities[entity.id];return this.host.worldSource.entity(r).slice(0,6);}
 resolve(node){
  const w=this.world,info=this.state.information,subject=node.subject?.pronoun?info[node.subject.pronoun]:[node.subject?.noun||0,...(node.subject?.qualifiers||[]),0,0].slice(0,3).flatMap(n=>[n&255,n>>>8]);
  const group=bytes=>({noun:bytes[0]|bytes[1]<<8,qualifiers:[bytes[2]|bytes[3]<<8,bytes[4]|bytes[5]<<8].filter(Boolean)});
  // BD7E/BDC2 own the global reference iterators, not entity pointers.
  // Each uniqueness check runs D36A again; exhaustion leaves the index
  // terminator, while ambiguity leaves the second matching index entry.
  const state=info.resolution??(info.resolution={cursors:[null,null],verb:null,triple:[null,null,null]});
  const indexBase=0x8B6F,indexEnd=indexBase+3*w.entities.length;
  state.verb=node.verb&4095;state.cursors=[indexBase-3,indexBase-3];
  const predicate=this.rules.predicates.indexOf(state.verb)+1;if(!predicate)return null;state.triple[1]=predicate;
  const find=(g,slot)=>{const matches=w.entities.filter(e=>e.id!==0&&w.nounMatches(e,g));state.cursors[slot]=matches.length>1?indexBase+3*matches[1].id:indexEnd;if(matches.length)state.triple[slot===0?0:2]=matches[0].id;return matches;};
  const subjects=find(group(subject),0);if(!subjects.length)return null;if(subjects.length!==1)throw new UnsupportedFeature('internal ambiguous information reference');
  const remember=e=>{info[e.attributes&64?'he':'it']=this.reference(e);};remember(subjects[0]);
  const objects=find(node.groups[0]||{noun:0,qualifiers:[]},1);if(!objects.length)return null;if(objects.length!==1)throw new UnsupportedFeature('internal ambiguous information reference');remember(objects[0]);
  return {subject:subjects[0].id,predicate,object:objects[0].id};
 }
 triplesEqual(a,b){return a.subject===b.subject&&a.predicate===b.predicate&&a.object===b.object;}
 atoms(){
  const out=[];for(const root of this.state.facts){
   out.push({get subject(){return root.subject;},get predicate(){return root.predicate;},get object(){return root.object;},get flags(){return root.flags;},set flags(n){root.flags=n;},handler:root.handler,start:root.start,root});
   for(let i=0;i<root.terms.length;){const at=i;out.push({subject:root.terms[i]&255,predicate:root.terms[i]>>>8,object:root.terms[i+1]&255,get flags(){return root.terms[at+1]>>>8;},set flags(n){root.terms[at+1]=(root.terms[at+1]&255)|(n<<8);},start:root.start+6+2*i,root});i+=(root.terms[i+1]>>>8)&48?3:2;}
  }return out;
 }
 skip(atoms,i){let depth=0;do{const flags=atoms[i++].flags;if(flags&8&&depth)depth--;if(flags&4)depth++;}while(depth);return i;}
 evidence(atoms,i){const atom=atoms[i],flags=atom.flags;if(flags&2)return {met:true,next:this.skip(atoms,i)};
  const type=flags&192,w=this.world;
  if(type===128)return {met:false,next:this.skip(atoms,i)};
  if(type===0&&(!(w.entity(atom.subject).status&128)||!(w.entity(atom.object).status&128)))return {met:false,next:this.skip(atoms,i)};
  if(type===64&&(!(w.entity(atom.subject).status&64)||!(w.entity(atom.object).status&64)))return {met:false,next:this.skip(atoms,i)};
  if(flags&4&&!this.children(atoms,i))return {met:false,next:this.skip(atoms,i)};
  atom.flags=(atom.flags|2)&254;return {met:true,next:this.skip(atoms,i)};
 }
 children(atoms,i){let next=i+1;for(;;){const last=atoms[next].flags&8,result=this.evidence(atoms,next);if(!result.met)return false;next=result.next;if(last)return true;}}
 evaluate(atoms,i){const atom=atoms[i];if(atom.flags&4&&!this.children(atoms,i))return false;if(atom.flags&32){atom.flags|=1;return true;}atom.flags=(atom.flags|2)&254;return true;}
 scan(){const atoms=this.atoms(),roots=[];for(let i=0;i<atoms.length;i=this.skip(atoms,i))roots.push(i);
  // BC46 walks every atom with BE5A, including nested hypotheses.
  // The complete-response scan below uses BE72 and skips complete groups.
  for(const i of atoms.map((_,i)=>i).filter(i=>(atoms[i].flags&33)===1).reverse())this.evaluate(atoms,i);
  const complete=[],incomplete=[],working=this.verification();for(const i of roots){if(atoms[i].flags&1&&this.evaluate(atoms,i)){if(!complete.length)working.lastFact=atoms[i].start;complete.push(atoms[i]);}}
  // BC9C skips groups with BE72; BC74 then uses BE5A for every active atom.
  if(!complete.length)for(let i=0;i<atoms.length;i++)if(atoms[i].flags&1&&!this.evaluate(atoms,i)){working.lastFact=atoms[i].start;incomplete.push(atoms[i]);}
  return {complete,incomplete};
 }
 remember(triple){const r=this.records,a=r.arena,all=r.records('facts'),existing=all.find(p=>a.byte(p)===triple.subject&&a.byte(p+1)===triple.predicate&&a.byte(p+2)===triple.object);let p=existing;
  if(existing){const n=all.indexOf(p),next=a.word(p-2);if(n)a.putWord(all[n-1]-2,next);else r.heads.facts=next;a.putWord(p-2,r.heads.facts);r.heads.facts=p;}
  else p=r.prepend('facts',[triple.subject,triple.predicate,triple.object,0,0]);return p;
 }
 remembered(){const a=this.records.arena;return this.records.records('facts').map(p=>({subject:a.byte(p),predicate:a.byte(p+1),object:a.byte(p+2),pointer:p}));}
 print(text,actor,messages,context={}){return this.host.print(text,actor,context,messages);}
 watson(nodes,messages){let mode=0,last=null;
  for(const node of nodes){let triple;try{triple=this.resolve(node);}catch(error){if(error instanceof UnsupportedFeature&&error.message.includes('internal ambiguous information reference')){this.print('7243',3,messages);return;}throw error;}
   if(!triple)continue;
   const fact=this.atoms().find(f=>this.triplesEqual(f,triple));
   if(fact&&(fact.flags&32)){mode=2;last=triple;}
   else if(this.host.game.runtimeRandom.percent({actor:3,mixOffset:2,purpose:'watson-information-acceptance'})<(fact?50:70)){mode=fact?3:4;last=triple;}
   if(last)break; // BA7F reaches the response directly; later nodes are discarded.
  }
  const duplicate=last?this.remembered().find(t=>this.triplesEqual(t,last)):null;if(last)this.remember(last);
  if(mode&&this.host.game.runtimeRandom.percent({actor:3,mixOffset:duplicate?.pointer??0xBA65,purpose:'watson-information-response'})>=25){
   const a=this.remembered().find(t=>(t.subject===last.subject&&t.object!==last.object)||(t.object===last.subject&&t.subject!==last.object)||(t.object===last.object&&t.subject!==last.subject)||(t.subject===last.object&&t.object!==last.subject));
   if(a){const common=[a.subject,a.object].find(id=>id===last.subject||id===last.object),other=[a.subject,a.object].find(id=>id!==common),requested=last.subject===common?last.object:last.subject;this.print('6F62',3,messages,{nameArguments:[other,requested]});return;}
  }
  this.print('6F54',3,messages);
 }
 recall(actor,draw,messages){const rows=this.remembered();if(draw===1&&rows.length)this.print('6F80',actor,messages,{fact:rows[0]});}
 accept(fact,actor,messages,count=1){
  this.print('67FF',actor,messages);if(count!==1)this.print('72D6',actor,messages);
  if(fact.flags&16){fact.flags&=~2;this.print('72E1',actor,messages,{fact});if(fact.handler)this.print(fact.handler.toString(16).toUpperCase(),actor,messages,{fact});else{const message={kind:'narrative',text:'".',raw_text:' ".'};messages.push(message);for(const c of message.raw_text)this.host.game.sourceDisplay.feed(c);}return;}
  fact.flags=(fact.flags|2)&254;
  const at=address=>this.state.facts.find(f=>f.start===address);
  let text;
  switch(fact.handler){case 0x99FC:text='7079';break;case 0x9A05:at(0x99F1).terms[1]|=0x200;text='70E3';break;case 0x9A0A:text='70E3';break;case 0x9A13:
   if(!(at(0x9973).flags&2)||!(at(0x9981).flags&2)){fact.flags&=~3;text='7265';}else{at(0x99A9).terms[1]|=0x200;text='7099';}break;
   case 0x9A3D:this.state.flags.caseReady=true;text='70F0';break;
   case 0x9A4B:at(0x9973).flags|=2;text='6FAB';break;
   case 0x9A59:{const e=this.world.entity(95);e.parent=null;e.rooms=[0];at(0x9981).flags|=2;text='6FCA';break;}
   default:throw new UnsupportedFeature('deduction handler '+fact.handler.toString(16));
  }this.print(text,actor,messages,{fact});
 }
 lestrade(nodes,messages){let found=0,newFact=null;const working=this.verification();working.recognized=0;working.unproven=0;
  for(const node of nodes){let triple;try{triple=this.resolve(node);}catch(error){if(error instanceof UnsupportedFeature&&error.message.includes('internal ambiguous information reference')){this.print('7243',2,messages);return;}throw error;}if(!triple)continue;
   const fact=this.atoms().find(f=>this.triplesEqual(f,triple)&&(f.flags&192)===128);if(!fact)continue;working.lastFact=fact.start;const atoms=this.atoms();if(!this.evaluate(atoms,atoms.findIndex(a=>a.start===fact.start))){fact.flags|=1;newFact=fact;working.unproven=1;}found++;working.recognized=(working.recognized+1)&255;
  }
  if(!found){this.print('725F',2,messages);return;}
  if(newFact){const atoms=this.atoms();newFact=atoms.find(a=>a.start===working.lastFact);let i=atoms.findIndex(a=>a.start===newFact.start)+1;while((atoms[i].flags&192)!==128&&!(atoms[i].flags&8))i=this.skip(atoms,i);this.print((atoms[i].flags&192)===128?'7295':'72A6',2,messages,{fact:newFact});return;}
  const {complete,incomplete}=this.scan();if(complete.length)this.accept(complete[0],2,messages,complete.length);else this.print(incomplete.length?'72BD':'727E',2,messages,{fact:incomplete.at(-1)});
 }
}
