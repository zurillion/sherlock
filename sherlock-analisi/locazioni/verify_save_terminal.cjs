'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const handlers={};global.document={addEventListener:(name,fn)=>handlers[name]=fn};global.window={devicePixelRatio:1};
const {SpectrumTerminal}=require('./spectrum.js');
function terminal(){const input={value:'',addEventListener(){},setAttribute(){},focus(){}},canvas={dataset:{},setAttribute(){},parentElement:{addEventListener(){}}};const t=new SpectrumTerminal({canvas,input,upper:{},lower:{},status:{},onCommand(){}});clearInterval(t.blink);t.active=true;t.delay=0;t.resumeSession();return t;}
const until=async predicate=>{for(let n=0;n<1000;n++){if(predicate())return;await new Promise(r=>setTimeout(r,1));}throw Error('Expected terminal state did not arrive');};
const checks=[];
(async()=>{
 let t=terminal();t.waiting=true;t.waitingReason='startup';let consumed=false;
 handlers.keydown({target:{closest:()=>true},preventDefault(){consumed=true;},stopImmediatePropagation(){}});
 assert(!consumed&&t.waiting);checks.push('Seed and other external controls do not consume the startup key/MORE');
 handlers.keydown({target:t.input,preventDefault(){consumed=true;},stopImmediatePropagation(){}});assert(consumed&&!t.waiting);checks.push('A key in the virtual screen still starts/continues the original display');
 t=terminal();t.model.counter=14;t.lowerHistory=['OPEN DOOR','WHICH DOOR ?'];t.draft='YOUR';t.input.value='YOUR';
 const saved=JSON.parse(JSON.stringify(t.snapshot())),restored=terminal();await restored.restore(saved);assert.deepEqual(restored.snapshot(),saved);assert(restored.lowerRows().join('\n').includes('WHICH DOOR ?'));checks.push('JSON round trip retains native paging state, lower history and unfinished clarification text');
 const packet=text=>({op:'word',text,delimiter:'\r',capitalize:false,force:false});
 const messages=[{kind:'narrative',text:'',screen_events:[packet('first'),packet('second'),packet('third')]}];
 const a=t.writeMessages(messages),b=restored.writeMessages(messages);await until(()=>t.waiting&&restored.waiting);
 assert.equal(t.model.counter,15);assert.deepEqual(restored.model.visible(),t.model.visible());t.more();restored.more();await Promise.all([a,b]);assert.deepEqual(restored.snapshot(),t.snapshot());checks.push('Continuation after restore pauses at the same MORE and produces the same screen');
 t.processing=true;assert.throws(()=>t.snapshot());t.processing=false;t.waiting=true;assert.throws(()=>t.snapshot());checks.push('Cannot save a partial output operation or an unacknowledged MORE');
 const bad=JSON.parse(JSON.stringify(saved));bad.model.remaining=999;assert.throws(()=>SpectrumTerminal.validateSnapshot(bad));checks.push('Inconsistent terminal snapshots are rejected before restoration');
 const output=process.argv[2]||path.join(__dirname,'results/save-terminal-verification.json');fs.mkdirSync(path.dirname(output),{recursive:true});fs.writeFileSync(output,JSON.stringify({passed:true,checks},null,2)+'\n');console.log('OK:',checks.length,'controlli del terminale salvato.');
})().catch(e=>{console.error(e);process.exitCode=1;});
