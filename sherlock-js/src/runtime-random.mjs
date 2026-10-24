import {OriginalRandom,RandomInputsUnavailable} from './random.mjs';
const compiled=new WeakMap();
function constants(data){
 if(compiled.has(data))return compiled.get(data);
 const source=data.randomInputs;if(source?.version!==1||source.source_sha256!==data.source_sha256)throw new RandomInputsUnavailable('Dati costanti della sorgente originale non disponibili.');
 const fixed=new Map(source.constants);for(const a of source.excludedWrites)fixed.delete(a);
 const value={source,fixed,npcBytes:new Map([...source.npcBytes,...source.ruleBytes])};compiled.set(data,value);return value;
}
// Functional input resolver. There is no CPU, full RAM array or snapshot
// fallback. Only immutable asset values are currently owned by this resolver.
// Each future mutable region must have an explicit logical-state projection.
export class RuntimeRandom {
 constructor(data,world){this.data=data;this.world=world;this.inputs=constants(data);}
 initialize(){const initial=this.inputs.source.historicalPrompt;this.world.random={version:1,profile:initial.profile,seed:initial.seed,cursor:initial.cursor,draws:0,trace:[]};}
 get available(){return Boolean(this.world.random);}
 read(address){
  if(!Number.isInteger(address)||address<0||address>65535)throw Error('Invalid random source address');
  if(this.projector){const projected=this.projector(address);if(projected!==null)return projected;}
  for(const range of this.inputs.source.ranges)if(address>=range.start&&address<range.start+range.values.length)return range.values[address-range.start];
  if(address>=0x4000&&address<0x5D80&&this.display){const value=this.display.read(address);if(value!==null)return value;}
  // By the time actions run, the quotation list has been parsed and transferred
  // to typed requests. Its head (9FEC/9FED) is therefore empty, not the request head.
  if(address===0x9FEC||address===0x9FED)return 0;
  if(this.inputs.npcBytes.has(address)){
   if(this.world.scheduler.actors.some(a=>a.enabled&&![0,3].includes(a.id)))throw new RandomInputsUnavailable('Proiezione dei programmi degli altri NPC ancora da collegare.');
   return this.inputs.npcBytes.get(address);
  }
  if(this.inputs.fixed.has(address))return this.inputs.fixed.get(address);
  throw new RandomInputsUnavailable('Ingresso casuale originale non ancora ricostruito: $'+address.toString(16).toUpperCase().padStart(4,'0')+'. Il comando non è stato applicato.');
 }
 chooseIndex(count,context){return count-1-this.absolute(count-1,context);}
 absolute(width,{mixOffset,actor=3,purpose='npc'}={}){
  const state=this.world.random;if(!state)throw new RandomInputsUnavailable('Stato casuale originale assente in questa partita precedente: salva e usa Riavvia.');
  const generator=new OriginalRandom(state),reads=[];
  let result;try{result=generator.absolute(width,{mixOffset,inputs:({cursor,mixOffset})=>{
   this.inFlight={actor,cursor};
   const second=(cursor+mixOffset+1)&65535,firstValue=this.read(cursor),secondValue=this.read(second);
   reads.push({address:cursor,value:firstValue},{address:second,value:secondValue});return {first:firstValue,second:secondValue};
  }});}finally{this.inFlight=null;}
  state.trace.push({actor,purpose,width,mixOffset,seed:state.seed,cursor:state.cursor,reads,result,next_seed:generator.seed,next_cursor:generator.cursor});
  if(state.trace.length>256)state.trace.shift();state.seed=generator.seed;state.cursor=generator.cursor;state.draws++;return result;
 }
 percent(context){return this.absolute(99,context)+1;}
 static validate(state){
  if(state===null||state===undefined)return;
  if(state.version!==1||!['historical-prompt-watson-v4','world-v5'].includes(state.profile)||!Number.isInteger(state.seed)||state.seed<0||state.seed>255||!Number.isInteger(state.cursor)||state.cursor<0||state.cursor>65535||!Number.isSafeInteger(state.draws)||state.draws<0||!Array.isArray(state.trace)||state.trace.length>256)throw Error('Stato casuale JS non valido.');
 }
}
