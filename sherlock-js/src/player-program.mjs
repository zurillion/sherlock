// Player deferred movement uses the same understood DOMAIN operations as NPCs,
// with the source's separate root context. No CPU interpreter or recorded path.
export function runPlayerProgram(host,program,action,args,messages,actions){
 const w=host.w,actor=w.player,saved=[action,args[0]??255,args[1]??255];
 const job={domain:true,pc:program,saved,record:host.use(({records})=>records.prepend('contexts',[actor,0x41,0x99,saved[1],saved[2],1,action])),state:null};
 host.state.playerLocal=job;
 for(let guard=0;guard<10000;guard++){
  const result=host.use(runtime=>{
   const {vm}=runtime;
   if(job.state)vm.states[actor]=job.state;
   else{const s=vm.start(actor,program,saved);s.contexts.push({origin:'9941',external:true,resume:'done',request:false,saved:[...saved],record:job.record});}
   const s=vm.state(actor);s.failures=host.state.playerFailures;job.saved=vm.saved(actor);host.state.playerProgramCounter=s.pc;
   const env=host.environment(runtime,messages,actions),leave=env.leaveContext;
   env.leaveContext=event=>{const value=leave(event);if(event.frame.record===job.record){job.failed=vm.node(s.pc).op==='return.failure';if(!job.failed)host.state.playerRootSaved=value;}return value;};
   try{const out=vm.step(actor,env);job.state=s;job.pc=s.pc;job.saved=vm.saved(actor);host.state.playerFailures=s.failures;host.state.playerProgramCounter=s.pc;return out;}
   finally{delete vm.states[actor];}
  });
  if(host.game.ended)return;
  if(job.pc==='done'){delete host.state.playerLocal;host.state.playerProgramCounter='9945';if(job.failed)host.playerInputFailures(['9945'],messages,actions);return;}
  if(result.cost){host.game.advance(result.cost,{action:job.saved[0],args:job.saved.slice(1),messages,actions});if(host.game.ended)return;job.state.requestAvailable=w.scheduler.requests.some(r=>r.recipient===actor);}
 }
 throw Error('Player domain program did not yield or finish.');
}
