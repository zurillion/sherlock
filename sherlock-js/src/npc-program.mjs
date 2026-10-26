import {UnsupportedFeature} from './world.mjs';
const clone=structuredClone;
// Interpreter of the game's NPC domain language. There are no CPU operations,
// registers or executable bytes here. Labels identify nodes in a semantic graph.
export class NpcProgram {
 constructor(catalog,scheduler){this.catalog=catalog;this.scheduler=scheduler;this.states={};this.erased=[];}
 start(actor,entry,saved=[255,255,255]){this.states[actor]={pc:entry,saved:clone(saved),contexts:[],failures:0,requestAvailable:false};return this.states[actor];}
 state(actor){const s=this.states[actor];if(!s)throw new UnsupportedFeature('programma del personaggio '+actor);return s;}
 prepare(actor){const s=this.state(actor);s.failures=0;s.requestAvailable=this.scheduler.requests.some(r=>r.recipient===actor);}
 resolve(value,actor,saved=this.saved(actor)){
  if(value<245||value>=254)return value;
  if(value===250)return saved[0];if(value===251)return actor;if(value===252)return saved[2];return saved[1];
 }
 saved(actor){const s=this.state(actor);return s.contexts.at(-1)?.saved||s.working||s.saved;}
 node(label){if(this.erased.includes(label)){const n=(parseInt(label,16)+1).toString(16).toUpperCase().padStart(4,'0');return {op:'padding',source:label,size:1,next:n};}const o=this.catalog.instructions[label];if(!o)throw new UnsupportedFeature('nodo del programma NPC '+label);return o;}
 branch(actor,op,success){
  const s=this.state(actor),next=success?op.success:op.failure;
  if(next===null||next===undefined)throw Error('Missing NPC continuation');
  if(success&&op.erase){const begin=parseInt(op.source,16);for(let i=0;i<op.size;i++){const label=(begin+i).toString(16).toUpperCase().padStart(4,'0');if(!this.erased.includes(label))this.erased.push(label);}}
  s.pc=next;if(!success)s.failures++;
  return !success&&next===op.source;
 }
 // Deferred actions retain the originating operation and a new argument scope.
 // The return handler reloads the previous scope, rather than leaking child args.
 defer(actor,op,result,args,{request=false,environment}={}){
  const s=this.state(actor),frame={origin:op.source,request,saved:[this.saved(actor)[0],...clone(result.args||args)]},owner=result.scopeOwner??actor;if(environment?.enterContext)frame.record=environment.enterContext({actor:owner,frame});if(owner===actor)s.contexts.push(frame);else environment.foreignContext?.({actor:owner,frame});delete s.working;s.pc=result.defer;
 }
 step(actor,environment,options={}){
  const result=this.visit(actor,environment,options),s=this.state(actor);
  // A failed child restores working arguments through D008. Successful
  // operations commit through D026 even at zero cost; a failure path can
  // suspend a new child first, preserving the previous actor-row bytes.
  if(result.cost){if(s.working&&!s.contexts.length)s.saved.splice(0,3,...s.working);delete s.working;}
  return result;
 }
 visit(actor,environment,{maxInternal=10000}={}){
  const s=this.state(actor);
  for(let guard=0;guard<maxInternal;guard++){
   if(s.failures===10)return {cost:1};
   const op=this.node(s.pc),saved=this.saved(actor);
   if(op.op==='padding'){s.pc=op.next;continue;}
   if(op.op==='jump'){s.pc=op.target;continue;}
   if(op.op==='trap')throw new UnsupportedFeature('trappola del programma NPC '+op.source);
   if(op.op.startsWith('return.')){
    const frame=s.contexts.at(-1);if(!frame)throw Error('NPC return without a suspended context');
    let rootSaved;const returned=environment.leaveContext?.({actor,frame});if(s.contexts.length===1&&!frame.request&&!frame.external){if(!returned&&typeof environment.returnSaved!=='function')throw new UnsupportedFeature('metadati condivisi al ritorno del contesto NPC');rootSaved=returned||environment.returnSaved({actor,frame});if(!Array.isArray(rootSaved)||rootSaved.length!==3)throw Error('Invalid context root values');}
    s.contexts.pop();if(rootSaved){if(op.op==='return.failure')s.working=clone(rootSaved);else{s.saved.splice(0,3,...rootSaved);delete s.working;}}
    s.pc=frame.external?frame.resume:frame.origin;
    if(frame.external)return {cost:0};
    if(frame.request)return {cost:0};
    const origin=this.node(frame.origin),failedLoop=this.branch(actor,origin,op.op==='return.success');
    if(failedLoop)return {cost:1};if(op.op==='return.failure')continue;return {cost:0};
   }
   if(!['yield'].includes(op.op)&&s.requestAvailable){
    if(typeof environment.request!=='function')throw new UnsupportedFeature('esecuzione della richiesta NPC');
    s.requestAvailable=false;const request=this.scheduler.takeRequest(actor);
    if(request){
     if(typeof environment.request!=='function')throw new UnsupportedFeature('esecuzione della richiesta NPC');
     const result=environment.request(request,{actor,restriction:op.restriction,operation:op,saved});
     if(result?.defer){this.defer(actor,op,result,result.args||[255,255],{request:true,environment});return {cost:result.cost||0};}
     if(result?.handled)return {cost:result.cost||0};
    }
   }
   const context={actor,saved,operation:op},args=(op.args||[255,255]).map(v=>this.resolve(v,actor,saved));let result;
   switch(op.op){
    case 'yield':result={success:true,cost:1};break;
    case 'signal.send':this.scheduler.sendSignal(actor,op.recipient);environment.signalSend?.(actor,op.recipient);result={success:true,cost:0};break;
    case 'signal.take':{const success=this.scheduler.consumeSignal(actor,op.sender);if(success)environment.signalTake?.(actor,op.sender);result={success,cost:0};break;}
    case 'order':{
     const recipient=this.resolve(op.recipient,actor,saved),action=op.action;
     if(typeof environment.order!=='function')throw new UnsupportedFeature('testo di un ordine fra NPC');
     this.scheduler.sendRequest(actor,recipient,{kind:'prefabricated',action,args});
     environment.order({actor,recipient,action,args,operation:op});result={success:true,cost:0};break;
    }
    case 'print':if(typeof environment.print!=='function')throw new UnsupportedFeature('testo del programma NPC');environment.print(op.text,context);result={success:true,cost:0};break;
    case 'say':if(typeof environment.say!=='function')throw new UnsupportedFeature('battuta del programma NPC');environment.say(op.text,this.resolve(op.recipient,actor,saved),context);result={success:true,cost:0};break;
    case 'rule':if(typeof environment.rule!=='function')throw new UnsupportedFeature('regola del programma NPC '+op.rule);result=environment.rule(op.rule,args,context);break;
    case 'action':if(typeof environment.action!=='function')throw new UnsupportedFeature('azione del programma NPC');result=environment.action(this.resolve(op.action,actor,saved),args,context);break;
    default:throw new UnsupportedFeature('operazione NPC '+op.op);
   }
   if(!result||!Number.isInteger(result.cost)||result.cost<0||result.cost>65535)throw Error('Invalid NPC rule result');
   if(result.bindArgs)for(let i=0;i<2;i++)if(this.saved(actor)[i+1]===255)this.saved(actor)[i+1]=result.bindArgs[i];
   if(result.saved)this.saved(actor).splice(0,3,...result.saved);
   if(result.defer){this.defer(actor,op,result,args,{environment});return {cost:result.cost};}
   if(result.success&&s.working&&!s.contexts.length){s.saved.splice(0,3,...s.working);delete s.working;}
   if(typeof result.success!=='boolean')throw Error('Missing NPC rule outcome');
   const failedLoop=this.branch(actor,op,result.success);
   if(result.success||result.cost||failedLoop)return {cost:failedLoop?1:result.cost};
  }
  throw new UnsupportedFeature('programma NPC senza ritorno di tempo o controllo');
 }
 dump(){return {version:1,states:clone(this.states),erased:clone(this.erased)};}
 restore(saved){
  if(saved?.version!==1||!saved.states||!Array.isArray(saved.erased))throw Error('Invalid NPC program save');
  for(const [id,s] of Object.entries(saved.states)){
   this.scheduler.actor(Number(id));if(!s||typeof s.pc!=='string'||!Array.isArray(s.saved)||s.saved.length!==3||!s.saved.every(v=>Number.isInteger(v)&&v>=0&&v<=255)||!Array.isArray(s.contexts)||s.working!==undefined&&(!Array.isArray(s.working)||s.working.length!==3||!s.working.every(v=>Number.isInteger(v)&&v>=0&&v<=255))||!Number.isInteger(s.failures)||s.failures<0||s.failures>10||typeof s.requestAvailable!=='boolean')throw Error('Invalid NPC program state');
   for(const c of s.contexts)if(typeof c.origin!=='string'||typeof c.request!=='boolean'||!Array.isArray(c.saved)||c.saved.length!==3||!c.saved.every(v=>Number.isInteger(v)&&v>=0&&v<=255))throw Error('Invalid NPC continuation');
  }
  this.states=clone(saved.states);this.erased=clone(saved.erased);
 }
}
