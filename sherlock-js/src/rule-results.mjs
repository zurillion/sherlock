// Functional result pointers retained by the source rule bridge CB34/CB37.
// These are domain record identities, not a processor or an instruction runner.
const word=n=>Number.isInteger(n)&&n>=0&&n<=65535;
export class RuleResults {
 constructor(host){this.host=host;}
 get state(){return this.host.state;}
 get values(){return this.state.ruleResultPointers??[null,null];}
 invalidate(){this.state.ruleResultPointers=[null,null];}
 write(first,second){this.state.ruleResultPointers=[first??null,second??null];}
 read(address){const n=this.values[Math.floor((address-0xCB28)/2)];return word(n)?(address&1?n>>>8:n&255):null;}
 ordinaryAction(out,previous){
  if(out.cost>0&&[14,36].includes(out.action)){const id=out.args[0],source=this.host.game.data.argumentChecks?.entities[id]?.[out.action];
   if(source==='DE9D'||source==='DEAF')this.write(this.host.worldSource.layout.entities.find(e=>e.id===id)?.start,previous[1]);
  }
 }
 predicate(name,meta,actor){
  if(['counter.delete','counter.decrement'].includes(name)){
   const r=this.host.active.records,p=r.records('counters').find(p=>r.arena.byte(p)===actor)??0;
   this.write(p,parseInt(meta.source,16)); // E573/E560 preserves the rule header in IY.
  }else if(name==='entity.at')this.write(this.state.argumentPointers?.[0],parseInt(meta.source,16));
  else this.invalidate();
 }
 begin(name,actor){
  const prior=[...this.values],r=this.host.active.records;
  if(['wait.tick','clock.hour','unimplemented.F198','entity.samePlace','entity.sameContainer','parent.save'].includes(name))return {kind:'preserve',prior};
  if(name==='location.save'||name==='entity.at')return {kind:'argument',prior,pointer:this.state.argumentPointers?.[0]??null};
  if(name==='counter.create')return {kind:'create',prior};
  if(['counter.delete','counter.decrement'].includes(name)){
   const all=r.records('counters'),index=all.findIndex(p=>r.arena.byte(p)===actor),p=all[index];
   if(p===undefined){this.invalidate();return null;}
   if(name==='counter.decrement'&&r.arena.byte(p+1)!==1)return {kind:'counter',prior,pointer:p};
   const start=p-3,previous=r.arena.free.filter(f=>f.start<start).at(-1);
   // A1C7 leaves the predecessor's link if the first merge succeeds;
   // otherwise A1FD/A204 leaves the released block start, not start+2.
   const pointer=previous&&previous.start+previous.size===start?previous.start+2:start;
   return {kind:'release',pointer,listLink:index?all[index-1]:0x9FE7};
  }
  this.invalidate();return null;
 }
 finish(frame){if(!frame)return;
  if(frame.kind==='preserve')this.write(...frame.prior);
  else if(frame.kind==='release')this.write(frame.pointer,frame.listLink);
  else this.write(frame.kind==='create'?this.host.active.records.heads.counters:frame.pointer,frame.prior[1]);
 }
}
