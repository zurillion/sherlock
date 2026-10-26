// Decode rule HEADERS and the small object DOMAIN programs as data. Bodies
// are named functional contracts in special-objects.mjs, never native code.
export const OBJECT_RULE_NAMES={DCC1:'object.take',DF8B:'object.quenchNote',DFB6:'object.safeEvent',DE9D:'object.open',E0AD:'object.streamClue',E135:'object.inspectClosely',E0EB:'object.revealNote',E0FD:'object.revealBottom',DF7E:'object.takeNote',DFA7:'object.openSafe',E0A0:'object.inspectStream',E0E0:'object.inspectTrash',E0F2:'object.inspectDrawer',E104:'object.inspectBookcase'};
export function extendObjectPrograms(original,payload){
 const result=structuredClone(original),byte=p=>payload[p-0x5d80],word=p=>byte(p)|byte(p+1)<<8,queue=[];
 for(const[source,key]of Object.entries(OBJECT_RULE_NAMES)){
  const at=parseInt(source,16),a=byte(at),b=byte(at+1);let p=at+2;
  const rule={source,classes:[a&15,b&15],requiresLight:Boolean(a&32),cost:b>>>4,masks:[],predicateSource:null,implemented:true};
  if(a&64){rule.predicateSource=word(p).toString(16).toUpperCase();p+=2;}
  if(a&16){const control=byte(p++);for(let i=0;i<2;i++){const n=(control>>>(i===0?4:0))&15;rule.masks.push({argument:i+1,tests:[{mode:n>>>2,mask:byte(p++)},{mode:n&3,mask:byte(p++)}]});}}
  rule.bodySource=p.toString(16).toUpperCase();if(a&128){rule.program=rule.bodySource;queue.push(p);}
  result.rules[key]=rule;
 }
 while(queue.length){const p=queue.shift(),key=p.toString(16).toUpperCase();if(result.instructions[key])continue;const opcode=byte(p);let out;
  if(opcode===11)out={op:'return.success',source:key,size:1,next:(p+1).toString(16).toUpperCase()};
  else if(opcode===3||opcode===7){const source=word(p+1).toString(16).toUpperCase(),rule=OBJECT_RULE_NAMES[source];if(!rule)throw Error('Unknown object rule '+source);const size=opcode===7?5:3,next=(p+size).toString(16).toUpperCase();out={op:'rule',source:key,size,next,success:next,failure:next,erase:false,restriction:false,rule,args:opcode===7?[byte(p+3),byte(p+4)]:[255,255]};queue.push(p+size);}
  else throw Error('Unknown object-domain operation '+key);
  result.instructions[key]=out;
 }
 return result;
}
