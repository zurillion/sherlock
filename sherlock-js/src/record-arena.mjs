// Domain record storage with the original best-fit allocation layout. Addresses
// are record identities/data used by the game's lists and random source. This
// does not execute machine code or emulate a processor.
export class RecordArena {
 constructor({base=0x9570,length=752}={}){this.base=base;this.bytes=new Uint8Array(length);this.free=[{start:base,size:length}];this.allocated=new Map();this.syncFree();}
 byte(at){if(at<this.base||at>=this.base+this.bytes.length)throw Error('Record address outside arena');return this.bytes[at-this.base];}
 putByte(at,value){if(!Number.isInteger(value)||value<0||value>255)throw Error('Invalid record byte');if(at<this.base||at>=this.base+this.bytes.length)throw Error('Record address outside arena');this.bytes[at-this.base]=value;}
 word(at){return this.byte(at)|this.byte(at+1)<<8;}
 putWord(at,value){this.putByte(at,value&255);this.putByte(at+1,value>>>8&255);}
 get freeHead(){return this.free[0]?.start||0;}
 syncFree(){for(let i=0;i<this.free.length;i++){const f=this.free[i];this.putWord(f.start,f.size);this.putWord(f.start+2,this.free[i+1]?.start||0);}}
 allocate(size){
  if(!Number.isInteger(size)||size<1||size>252)throw Error('Unsupported record size');const total=size+3;let best=-1;
  // Equal-size candidates replace the earlier one: choose the LAST best fit.
  for(let i=0;i<this.free.length;i++)if(this.free[i].size>=total&&(best<0||this.free[i].size<=this.free[best].size))best=i;
  if(best<0)throw Error('Original record arena exhausted');
  const block=this.free[best],remainder=block.size-total;let start;
  if(remainder<4){start=block.start;this.free.splice(best,1);}else{start=block.start+remainder;block.size=remainder;}
  this.syncFree();this.putByte(start,total);for(let i=1;i<total;i++)this.putByte(start+i,0);
  const pointer=start+3;this.allocated.set(pointer,size);return pointer;
 }
 release(pointer){
  if(!this.allocated.has(pointer))throw Error('Unknown allocated record');this.allocated.delete(pointer);
  const start=pointer-3;let i=this.free.findIndex(f=>f.start>start);if(i<0)i=this.free.length;
  let head=this.freeHead;const previous=i?this.free[i-1].start+2:null,next=this.free[i]?.start||0;
  if(previous===null)head=start;else this.putWord(previous,start);
  this.putByte(start+1,0);this.putWord(start+2,next);
  const merge=link=>{
   // The list-head prefix contains the calendar (am/pm); with this original
   // pool its computed end cannot be an address inside the pool.
   if(link===null)return false;
   const size=this.word(link-2),following=this.word(link);
   if(!following||((link-2+size)&65535)!==following)return false;
   this.putWord(link-2,(size+this.word(following))&65535);this.putWord(link,this.word(following+2));return true;
  };
  const merged=merge(previous);
  // Preserve A1FD/A203: after a failed first merge the second test uses the
  // new block START, rather than its link at start+2. Do not repair this quirk.
  merge(merged?previous:(previous===null?head:this.word(previous)));
  this.free=[];const seen=new Set();for(let q=head;q;q=this.word(q+2)){if(seen.has(q))throw Error('Free-record list cycle');seen.add(q);this.free.push({start:q,size:this.word(q)});}
 }
 dump(){return {version:1,base:this.base,bytes:[...this.bytes],free:structuredClone(this.free),allocated:[...this.allocated]};}
 static load(s){
  if(s?.version!==1||!Number.isInteger(s.base)||!Array.isArray(s.bytes)||!s.bytes.every(v=>Number.isInteger(v)&&v>=0&&v<=255)||!Array.isArray(s.free)||!Array.isArray(s.allocated))throw Error('Invalid record arena save');
  const a=new RecordArena({base:s.base,length:s.bytes.length});a.bytes=Uint8Array.from(s.bytes);a.free=structuredClone(s.free);a.allocated=new Map(s.allocated);return a;
 }
}
export const RECORD_HEADS={counters:0x9fe5,signals:0x9fe7,contexts:0x9fe9,quotes:0x9fec,requests:0x9fee,syntax:0x9ff0,parsed:0x9ff2,facts:0x9ff4};
export class RecordLists {
 constructor(arena=new RecordArena()){this.arena=arena;this.heads=Object.fromEntries(Object.keys(RECORD_HEADS).map(k=>[k,0]));}
 prepend(list,values){if(!(list in this.heads))throw Error('Unknown record list');const p=this.arena.allocate(values.length);this.arena.putWord(p-2,this.heads[list]);values.forEach((v,i)=>this.arena.putByte(p+i,v));this.heads[list]=p;return p;}
 append(list,values){const tail=this.records(list).at(-1),p=this.arena.allocate(values.length);values.forEach((v,i)=>this.arena.putByte(p+i,v));if(tail)this.arena.putWord(tail-2,p);else this.heads[list]=p;return p;}
 records(list){const out=[],seen=new Set();for(let p=this.heads[list];p;p=this.arena.word(p-2)){if(seen.has(p))throw Error('Record list cycle');seen.add(p);out.push(p);}return out;}
 remove(list,pointer){const all=this.records(list),i=all.indexOf(pointer);if(i<0)throw Error('Record not in list');const successor=this.arena.word(pointer-2),predecessor=i?all[i-1]:null;if(predecessor)this.arena.putWord(predecessor-2,successor);else this.heads[list]=successor;this.arena.release(pointer);return predecessor;}
 // CFCF reloads from the predecessor rather than the actor row when no outer
 // context for this actor remains. Preserve that observable original quirk.
 returnSaved(predecessor){return predecessor?[this.arena.byte(predecessor+3),this.arena.byte(predecessor+4),this.arena.byte(predecessor+5)]:[this.heads.requests&255,this.heads.requests>>>8,this.heads.syntax&255];}
 dump(){return {version:1,arena:this.arena.dump(),heads:structuredClone(this.heads)};}
 static load(s){const heads={parsed:0,quotes:0,...s?.heads};if(s?.version!==1||!s.heads||Object.keys(RECORD_HEADS).some(k=>!Number.isInteger(heads[k])||heads[k]<0||heads[k]>65535))throw Error('Invalid record lists save');const x=new RecordLists(RecordArena.load(s.arena));x.heads=structuredClone(heads);for(const k of Object.keys(RECORD_HEADS))x.records(k);return x;}
}
